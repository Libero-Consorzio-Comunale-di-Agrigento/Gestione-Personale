CREATE OR REPLACE PACKAGE prpcgirp IS
/******************************************************************************
 NOME:          PRPCGIRP
 DESCRIZIONE:   Caricamento dei Giustificativi da Rilevazione Presenze e totalizzazione
                per Individuo e Causale.
                Questa fase inserisce su Eventi di Presenza le Causali ottenute raggrup-
                pando i Movimenti giornalieri provenienti da R.P. presenti su Deposito
                Eventi R.P.. A seconda del Riferimento della Causale vengono determinati
                periodi di assenza o presenza contenenti movimenti di R.P. riferiti a
                giornate consecutive. Se il riferimento della Causale e` Mensile, viene
                determinato  un unico movimento riferito al mese di riferimento; se il
                riferimento della Causale e` Mese Precedente, la stessa operazione viene
                eseguita in riferimento al mese precedente.
                Vengono inseriti su Deposito Eventi Presenza i movimenti riferiti a cau-
                sali con rilevanza giuridica.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    22/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY prpcgirp IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 22/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	declare   d_num_elaborati         number(8);
          d_num_rec_derp          number(8);
          d_fin_mes               date;
          d_ini_mes               date;
          d_utente                VARCHAR2(8);
          d_causale               VARCHAR2(8);
          d_motivo                VARCHAR2(8);
          d_giustificativo        VARCHAR2(8);
          d_data                  date;
          d_dalle                 number(4);
          d_alle                  number(4);
          d_quantita              number(4);
          d_badge                 number(5);
          d_ci                    number(8);
          d_riferimento           VARCHAR2(1);
          d_assenza               VARCHAR2(4);
          d_numero                number(12);
          d_data_prec             date;
          d_tot_qta               number(8);
          d_dal                   date;
          d_al                    date;
          d_causale_prec          VARCHAR2(8);
          d_motivo_prec           VARCHAR2(8);
          d_ci_prec               number(8);
          d_riferimento_prec      VARCHAR2(1);
          d_assenza_prec          VARCHAR2(4);
          d_derp_rowid            VARCHAR2(30);
          d_ci_char               VARCHAR2(8);
          d_badge_char            VARCHAR2(5);
          d_giorno_char           VARCHAR2(6);
          d_dalle_char            VARCHAR2(4);
          d_alle_char             VARCHAR2(4);
          d_quantita_char         VARCHAR2(4);
          d_errore                VARCHAR2(6);
          err_dati                exception;
          errore                  exception;
  cursor cagi is  select  cagi.causale
                         ,cagi.motivo
                         ,cagi.codice
                         ,derp.badge
                         ,derp.giorno
                         ,derp.dalle
                         ,derp.alle
                         ,decode(caev.gestione,'G',derp.quantita/pspa.min_gg
                                                  ,derp.quantita
                                )
                         ,rain.ci
                         ,caev.riferimento
                         ,caev.assenza
                         ,derp.rowid
                    from  deposito_eventi_rp          derp
                         ,causali_evento              caev
                         ,periodi_servizio_presenza   pspa
                         ,rapporti_individuali        rain
                         ,riferimento_presenza        ripa
                         ,classi_rapporto             clra
                         ,causali_giustificativo      cagi
                   where  cagi.da_a                   = 'A'
                     and  cagi.codice                 = derp.giustificativo
                     and  exists
                          (select 'x'
                            from motivi_evento moev
                           where moev.codice       like cagi.motivo
                          )
                     and  caev.codice                 = cagi.causale
                     and  derp.data_rif               = '00000003'
                     and  pspa.ci                     = derp.ci
                     and  to_date(derp.giorno,'yymmdd') between
                          pspa.dal and nvl(pspa.al,to_date('3333333','j'))
                     and  rain.ni             =  derp.ci
                     and  clra.codice         =  rain.rapporto
                     and  clra.presenza       =  'SI'
                     and  ripa.fin_mes  between
                                             rain.dal
                                        and  nvl(rain.al,to_date('3333333','j'))
                   order  by cagi.causale,cagi.motivo,derp.ci,
                             derp.giorno
 ;
 cursor  chk_num  is  select  derp.ci
                             ,derp.badge
                             ,derp.giustificativo
                             ,derp.giorno
                             ,derp.dalle
                             ,derp.alle
                             ,derp.quantita
                             ,derp.rowid
                        from  deposito_eventi_rp derp
 ;
BEGIN
/*
        +------------------------------------------------+
        | Eliminazione da EVENTI_PRESENZA di eventuali   |
        | Registrazioni relative ad alimentazioni da     |
        | R.P. riferite allo stesso mese di elaborazione.|
        +------------------------------------------------+
*/
BEGIN
  delete  from  eventi_presenza evpa
   where  evpa.input            = 'R'
     and  evpa.data_agg        in (select  ripa.fin_mes
                                     from  riferimento_presenza ripa
                                    where  ripa.ripa_id     = 'RIPA'
                                  )
  ;
  commit;
END;
/*
        +-------------------------------------------------+
        | Eliminazione registrazioni dal Deposito Eventi  |
        | di Presenza.                                    |
        +-------------------------------------------------+
*/
BEGIN
  delete  from  deposito_eventi_presenza depa
   where  depa.data_agg        in (select  ripa.fin_mes
                                     from  riferimento_presenza ripa
                                    where  ripa.ripa_id     = 'RIPA'
                                  )
     and  depa.rilevanza        = 'R'
  ;
  commit;
END;
/*
        +----------------------------------------------------------+
        | Controllo di numericita` sui dati della tabella          |
        | di Deposito proveniente da ambiente R.P.                 |
        |                                                          |
        | Viene utilizzato come flag il campo data non utilizzato  |
        | dalla procedura. Il valore '00000003' significa che non  |
        | contiene errori, il valore '00000002' significa che con- |
        | tiene errori di integrita` o di riferimento relazionale, |
        | il valore '00000001' significa che vi sono errori di va- |
        | lidazione sui dati.                                      |
        +----------------------------------------------------------+
*/
BEGIN
  update deposito_eventi_rp
     set data_rif = '00000003'
  ;
  commit;
END;
BEGIN
  open chk_num;
  LOOP
  fetch chk_num into d_ci_char,d_badge_char,d_giustificativo,d_giorno_char,
                     d_dalle_char,d_alle_char,d_quantita_char,d_derp_rowid;
  exit when chk_num%NOTFOUND;
  BEGIN
    d_numero              := to_number(d_ci_char);
    d_numero              := to_number(d_badge_char);
    d_numero              := to_number(d_dalle_char);
    d_numero              := to_number(d_alle_char);
    d_numero              := to_number(d_quantita_char);
    d_data                := to_date(d_giorno_char,'yymmdd');
    IF  lpad(nvl(d_dalle_char,'0'),4,'0') >
        lpad(nvl(d_alle_char,'0'),4,'0')  THEN
        RAISE ERR_DATI;
    END IF;
    BEGIN
      select 1
        into d_numero
        from dual
       where exists (select 'x' from riferimento_presenza
                      where to_date(d_giorno_char,'yymmdd') <=  fin_mes
                    )
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE ERR_DATI;
    END;
    BEGIN
      select 1
        into d_numero
        from dual
       where exists (select 'x' from causali_giustificativo
                      where codice = d_giustificativo
                    )
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE ERR_DATI;
    END;
    BEGIN
      select 1
        into d_numero
        from dual
       where exists (select 'x' from rapporti_presenza
                      where to_date(d_giorno_char,'yymmdd') between
                            dal and nvl(al,to_date('3333333','j'))
                        and to_number(d_ci_char)   = ci
                    )
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE ERR_DATI;
    END;
  EXCEPTION
    WHEN ERR_DATI THEN
      update deposito_eventi_rp
         set data_rif  = '00000002'
       where rowid     = d_derp_rowid
      ;
    WHEN OTHERS THEN
      update deposito_eventi_rp
         set data_rif  = '00000001'
       where rowid     = d_derp_rowid;
  END;
  END LOOP;
  close chk_num;
  commit;
END;
/*
        +------------------------------------------------------+
        | Inserimento movimenti da R.P.                        |
        | in Eventi di Presenza e Deposito Eventi di Presenza. |
        +------------------------------------------------------+
*/
BEGIN
  d_num_elaborati := 0;
  BEGIN
    select  utente
      into  d_utente
      from  a_prenotazioni
     where  no_prenotazione = prenotazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_utente := '*';
  END;
  BEGIN
    select  ripa.ini_mes,ripa.fin_mes
      into  d_ini_mes,d_fin_mes
      from  riferimento_presenza ripa
     where  ripa.ripa_id  =  'RIPA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_errore := 'P07000';
      RAISE errore;
  END;
  BEGIN
    select  count(*)
      into  d_num_rec_derp
      from  deposito_eventi_rp
    ;
  END;
  BEGIN
    open cagi;
    fetch cagi into d_causale,d_motivo,d_giustificativo,d_badge_char
                   ,d_giorno_char,d_dalle_char,d_alle_char,d_quantita_char
                   ,d_ci_char,d_riferimento,d_assenza,d_derp_rowid;
    IF cagi%FOUND THEN
    d_ci                        := to_number(d_ci_char);
    d_badge                     := to_number(d_badge_char);
    d_data                      := to_date(d_giorno_char,'yymmdd');
    d_dalle                     := to_number(d_dalle_char);
    d_alle                      := to_number(d_alle_char);
    d_quantita                  := to_number(d_quantita_char);
    d_ci_prec                   := d_ci;
    d_causale_prec              := d_causale;
    d_motivo_prec               := d_motivo;
    d_data_prec                 := d_data;
    d_assenza_prec              := d_assenza;
    d_riferimento_prec          := d_riferimento;
    d_dal                       := to_date('3333333','j');
    d_al                        := to_date('2222222','j');
    d_tot_qta                   := 0;
    LOOP
      d_tot_qta := d_tot_qta + nvl(d_quantita,0);
      IF d_data > d_al THEN
         d_al := d_data;
      END IF;
      IF d_data < d_dal THEN
         d_dal := d_data;
      END IF;
      d_num_elaborati := d_num_elaborati + 1;
      d_data_prec     := d_data;
--    delete  from  deposito_eventi_rp derp
--     where  derp.rowid   = d_derp_rowid
--    ;
      fetch cagi into d_causale,d_motivo,d_giustificativo,d_badge_char
                     ,d_giorno_char,d_dalle_char,d_alle_char,d_quantita_char
                     ,d_ci_char,d_riferimento,d_assenza,d_derp_rowid;
      IF cagi%FOUND THEN
         d_ci                   := to_number(d_ci_char);
         d_badge                := to_number(d_badge_char);
         d_data                 := to_date(d_giorno_char,'yymmdd');
         d_dalle                := to_number(d_dalle_char);
         d_alle                 := to_number(d_alle_char);
         d_quantita             := to_number(d_quantita_char);
      END IF;
      IF cagi%NOTFOUND
      OR (    d_data        != d_data_prec + 1
          and d_riferimento not in ('P','M')
         )
      OR d_ci              != d_ci_prec
      OR d_causale         != d_causale_prec
      OR nvl(d_motivo,' ') != nvl(d_motivo_prec,' ') THEN
      insert into eventi_presenza
            (evento
            ,ci
            ,causale
            ,motivo
            ,dal
            ,al
            ,riferimento
            ,chiuso
            ,input
            ,classe
            ,dalle
            ,alle
            ,valore
            ,cdc
            ,sede
            ,note
            ,utente
            ,data_agg
            )
      select  evpa_sq.nextval
             ,d_ci_prec
             ,d_causale_prec
             ,d_motivo_prec
             ,decode(d_riferimento_prec
                    ,'P',add_months(
                         to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy'),-1)
                    ,'M',to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy')
                        ,d_dal
                    )
             ,decode(d_riferimento_prec
                    ,'P',add_months(last_day(d_al),-1)
                    ,'M',last_day(d_al)
                        ,d_al
                    )
             ,decode(d_riferimento_prec
                    ,'P',add_months(
                         to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy'),-1)
                    ,'M',to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy')
                        ,d_dal
                    )
             ,'SI'
             ,'R'
             ,null
             ,d_dalle
             ,d_alle
             ,d_tot_qta
             ,null
             ,null
             ,null
             ,d_utente
             ,d_fin_mes
        from  dual
      ;
      insert  into deposito_eventi_presenza
             (rilevanza
             ,ci
             ,assenza
             ,data
             ,operazione
             ,dal
             ,al
             ,utente
             ,data_agg
             )
      select  'R'
             ,d_ci_prec
             ,d_assenza_prec
             ,decode(d_riferimento_prec
                    ,'P',add_months(
                         to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy'),-1)
                    ,'M',to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy')
                        ,d_dal
                    )
             ,'I'
             ,decode(d_riferimento_prec
                    ,'P',add_months(
                         to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy'),-1)
                    ,'M',to_date('01'||to_char(d_dal,'mmyyyy'),'ddmmyyyy')
                        ,d_dal
                    )
             ,decode(d_riferimento_prec
                    ,'P',add_months(last_day(d_al),-1)
                    ,'M',last_day(d_al)
                        ,d_al
                    )
             ,d_utente
             ,d_fin_mes
        from  dual
       where  d_assenza_prec is not null
      ;
    d_ci_prec                    := d_ci;
    d_causale_prec               := d_causale;
    d_motivo_prec                := d_motivo;
    d_assenza_prec               := d_assenza;
    d_riferimento_prec           := d_riferimento;
    d_data_prec                  := d_data;
    d_dal                        := to_date('3333333','j');
    d_al                         := to_date('2222222','j');
    d_tot_qta                    := 0;
    END IF;
    IF cagi%NOTFOUND THEN
       exit;
    END IF;
    END LOOP;
    END IF;
    close cagi;
  END;
  BEGIN
    update rapporti_presenza  rapa
       set rapa.flag_ec       = 'M'
     where rapa.ci           in (select to_number(derp.ci)
                                   from deposito_eventi_rp  derp
                                  where derp.data_rif    = '00000003'
                                  group by to_number(derp.ci)
                                )
    ;
  END;
  commit;
  IF d_num_elaborati != d_num_rec_derp THEN
     d_errore := 'P07301';
     RAISE errore;
  END IF;
/*
           +--------------------------------------------+
           | Se non ci sono records scartati viene ini- |
           | bita l'esecuzione dello step successivo di |
           | stampa anomalie.                           |
           +--------------------------------------------+
*/
  update a_prenotazioni set prossimo_passo = 3
   where no_prenotazione    = prenotazione
  ;
END;
EXCEPTION
  WHEN errore THEN
    ROLLBACK;
    update a_prenotazioni set errore         = d_errore
                             ,prossimo_passo = decode(d_errore,'P07301',
                                                               prossimo_passo,
                                                               99
                                                     )
     where no_prenotazione = prenotazione
    ;
END;
commit;
end;
end;
/

