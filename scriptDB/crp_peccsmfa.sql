/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE peccsmfa IS
/******************************************************************************
 NOME:         PECCSMFA
 DESCRIZIONE:  Creazione del flusso per la Denuncia Fiscale 770 / SA su
               supporto magnetico
               (nastri a bobina o dischetti - ASCII - lung. 4000 crt.).
               Questa fase produce un file secondo un tracciato concordato a livello
               aziendale per via dei limiti di ORACLE che permette di creare record
               di max 250 crt. Una ulteriore elaborazione adeguera' questi files al
               tracciato imposto dal Ministero delle Finanze.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: La gestione che deve risultare come intestataria della denuncia
              deve essere stata inserita in << DGEST >> in modo tale che la
              ragione sociale (campo nome) risulti essere la minore di tutte
              le altre eventualmente inserite.
              Lo stesso risultato si raGgiunge anche inserendo un BLANK prima
              del nome di tutte le gestioni che devono essere escluse.
     
              Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
              da elaborare.
              Il PARAMETRO D_filtro_1 indica i dipendenti da elaborare.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY peccsmfa IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	DECLARE
--
-- Depositi e Contataori Vari
--
  D_dummy           VARCHAR2(1);
  D_dummy_f         VARCHAR2(1);
  D_r1              VARCHAR2(20);
  D_filtro_1        VARCHAR2(15);
  D_tipo_contratto  VARCHAR2(1);
  D_pagina          number := 0;
  D_pagina_prec     number := 0;
  D_pagina_inps     number := 0;
  D_pagina_inail    number := 0;
  D_riga            number := 0;
  D_modulo          number := 0;
  D_modulo_prec     number := 0;
  D_modulo_inps     number := 0;
  D_modulo_inail    number := 0;
  D_num_ord         number := 0;
  D_num_ord_prec    number := 0;
  D_num_ord_inps    number := 0;
  D_num_ord_inail   number := 0;
  D_conta_prec      number := 0;
  D_conta_inps      number := 0;
  D_conta_inail     number := 0;
  D_inail_ci        number := 0;
  D_data_inail      date;
--
-- Variabili di Periodo
--
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
--
-- Variabili di Ente
--
  D_cod_fis_dic     VARCHAR2(16);
  D_ente_cf         VARCHAR2(16);
--
-- Variabili di Dettaglio
--
  D_cod_fis         VARCHAR2(16);
  D_dep_cod_fis     VARCHAR2(16);
  D_cf_prec         VARCHAR2(16);
  D_cf_ere          VARCHAR2(16);
  D_causa_b         VARCHAR2(1);
  D_ipn_ord         VARCHAR2(11);
  D_ipt_pag         VARCHAR2(11);
  D_ipt_sosp        VARCHAR2(11);
  D_add_irpef       VARCHAR2(11);
  D_add_irpef_sosp  VARCHAR2(11);
  D_pos_inail       VARCHAR2(12);
  D_posizione       VARCHAR2(12);
  D_contro_cod      VARCHAR2(12);
  D_dal_inail       date;
  D_al_inail        date;
  D_qua_inps        VARCHAR2(1);
  D_part_time       VARCHAR2(2);
  D_tempo_det       VARCHAR2(2);
  D_qua_fisc        VARCHAR2(2);
  D_qua_inail       VARCHAR2(2);
--
-- Variabili di Exception
--
  NO_QUALIFICA EXCEPTION;
   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
      BEGIN
      select substr(valore,1,4)
           , to_date('01'||substr(valore,1,4),'mmyyyy')
           , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
        into D_anno,D_ini_a,D_fin_a
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              select anno
                   , to_date('01'||to_char(anno),'mmyyyy')
                   , to_date('3112'||to_char(anno),'ddmmyyyy')
                into D_anno,D_ini_a,D_fin_a
                from riferimento_fine_anno
               where rifa_id = 'RIFA';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_1
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_1'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_1 := '%';
      END;
      BEGIN
      select substr(valore,1,1)
        into D_tipo_contratto
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_CONTRATTO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_tipo_contratto := null;
      END;
      BEGIN
      select rpad(ltrim(substr(valore,1,16)),16,' ')
        into D_cod_fis_dic
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_COD_FIS'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_cod_fis_dic := null;
      END;
      BEGIN
      select upper(chiave)
        into D_r1
        from relazione_chiavi_estrazione
       where estrazione = 'FISCALE_ANNO'
         and sequenza = 1
      ;
             IF D_r1 = 'GESTIONE' THEN
                null;
             ELSE
                select ltrim(nvl(ente.codice_fiscale,ente.partita_iva))
                  into D_cod_fis
                  from ente ente
               ;
             END IF;
      END;
      BEGIN
         D_num_ord       := 1;
         D_modulo        := 1;
         D_pagina        := 0;
         D_riga          := 0;
         FOR CUR_RPFA IN
            (select max(rpad(nvl( D_cod_fis
                            , ltrim(nvl( gest.codice_fiscale
                                        ,gest.partita_iva))),16))  ente_cf
                  , tbfa.ci                                        ci
                  , rain.cognome
                  , rain.nome
                  , anag.codice_fiscale                            cod_fis
                  , max(clra.cat_fiscale)                          cat_fiscale
                  , max(radi.ci_erede)                             ci_erede
               from gestioni              gest
                  , anagrafici            anag
                  , rapporti_individuali  rain
                  , classi_rapporto       clra
                  , rapporti_diversi      radi
                  , tabella_fiscale_anno  tbfa
              where gest.codice (+)          = tbfa.c1
                and tbfa.anno                = D_anno
                and nvl(tbfa.c1,' ')      like D_filtro_1
                and anag.ni                  = rain.ni
                and anag.al                 is null
                and rain.ci                  = tbfa.ci
                and rain.rapporto            = clra.codice
                and clra.cat_fiscale        in ('1','10','2','20')
                and exists (select 'x' from progressivi_fiscali        prfi
                             where prfi.anno    = tbfa.anno
                               and prfi.mese      = 12
                               and prfi.mensilita =
                                  (select max(mensilita) from mensilita
                                    where mese = 12
                                      and tipo in ('N','A','S'))
                               and prfi.ci = tbfa.ci
                             group by prfi.ci
                            having nvl(sum(prfi.ipn_ac),0) +
                                   nvl(sum(prfi.ipn_ap),0) != 0
                           )
                and radi.ci (+) = tbfa.ci
                and exists
                   (select 'x' from rapporti_retributivi
                     where ci = tbfa.ci)
                and not exists
                   (select 'x'
                      from rapporti_individuali rain2
                         , classi_rapporto      clra2
                     where rain2.ci     != tbfa.ci
                       and rain2.ni      = rain.ni
                       and rain2.dal     > rain.dal
                       and clra2.codice  = rain2.rapporto
                       and clra2.presenza = 'SI'
                       and clra2.giuridico = 'SI'
                       and clra2.retributivo = 'SI'
                       and exists
                          (select 'x' from rapporti_diversi radi2
                            where radi2.ci_erede = tbfa.ci)
                   )
              group by tbfa.ci
                  , rain.cognome
                  , rain.nome
                     , anag.codice_fiscale
              union
             select max(rpad(nvl( D_cod_fis
                            , ltrim(nvl( gest.codice_fiscale
                                        ,gest.partita_iva))),16))  ente_cf
                  , d1is.ci                                        ci
                  , rain.cognome
                  , rain.nome
                  , anag.codice_fiscale                            cod_fis
                  , max(clra.cat_fiscale)                          cat_fiscale
                  , max(radi.ci_erede)                             ci_erede
               from gestioni              gest
                  , anagrafici            anag
                  , rapporti_individuali  rain
                  , classi_rapporto       clra
                  , rapporti_diversi      radi
                  , denuncia_o1_inps      d1is
              where gest.codice (+)          = d1is.gestione
                and d1is.anno                = D_anno
                and d1is.gestione         like D_filtro_1
                and anag.ni                  = rain.ni
                and anag.al                 is null
                and rain.ci                  = d1is.ci
                and rain.rapporto            = clra.codice
                and radi.ci (+) = d1is.ci
                and exists
                   (select 'x' from rapporti_retributivi
                     where ci = d1is.ci)
                and not exists
                   (select 'x'
                      from rapporti_individuali rain2
                         , classi_rapporto      clra2
                     where rain2.ci     != d1is.ci
                       and rain2.ni      = rain.ni
                       and rain2.dal     > rain.dal
                       and clra2.codice  = rain2.rapporto
                       and clra2.presenza = 'SI'
                       and clra2.giuridico = 'SI'
                       and clra2.retributivo = 'SI'
                       and exists
                          (select 'x' from rapporti_diversi radi2
                            where radi2.ci_erede = d1is.ci)
                   )
              group by d1is.ci
                  , rain.cognome
                  , rain.nome
                     , anag.codice_fiscale
              union
             select max(rpad(nvl( D_cod_fis
                            , ltrim(nvl( gest.codice_fiscale
                                        ,gest.partita_iva))),16))  ente_cf
                  , dein.ci                                        ci
                  , rain.cognome
                  , rain.nome
                  , anag.codice_fiscale                            cod_fis
                  , max(clra.cat_fiscale)                          cat_fiscale
                  , max(radi.ci_erede)                             ci_erede
               from gestioni              gest
                  , anagrafici            anag
                  , rapporti_individuali  rain
                  , classi_rapporto       clra
                  , rapporti_diversi      radi
                  , denuncia_inail        dein
              where gest.codice (+)          = dein.gestione
                and dein.anno                = D_anno
                and dein.gestione         like D_filtro_1
                and anag.ni                  = rain.ni
                and anag.al                 is null
                and rain.ci                  = dein.ci
                and rain.rapporto            = clra.codice
                and radi.ci (+) = dein.ci
                and exists
                   (select 'x' from rapporti_retributivi
                     where ci = dein.ci)
                and not exists
                   (select 'x'
                      from rapporti_individuali rain2
                         , classi_rapporto      clra2
                     where rain2.ci     != dein.ci
                       and rain2.ni      = rain.ni
                       and rain2.dal     > rain.dal
                       and clra2.codice  = rain2.rapporto
                       and clra2.presenza = 'SI'
                       and clra2.giuridico = 'SI'
                       and clra2.retributivo = 'SI'
                       and exists
                          (select 'x' from rapporti_diversi radi2
                            where radi2.ci_erede = dein.ci)
                   )
              group by dein.ci
                  , rain.cognome
                  , rain.nome
                     , anag.codice_fiscale
              order by 1,3,4
            ) LOOP
                BEGIN
                BEGIN
                select 'x'
                  into D_dummy_f
                  from progressivi_fiscali        prfi
                 where prfi.anno      = D_anno
                   and prfi.mese      = 12
                   and prfi.mensilita =
                      (select max(mensilita) from mensilita
                        where mese = 12
                          and tipo in ('N','A','S'))
                   and prfi.ci = CUR_RPFA.ci
                 group by prfi.ci
                having nvl(sum(prfi.ipn_ac),0) +
                       nvl(sum(prfi.ipn_ap),0) != 0;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN D_dummy_f := null;
                END;
                IF D_dummy_f is not null THEN
                    --
                    --  Estrazione Codice Fiscale Defunto
                    --
                    BEGIN
                      select max(decode
                                 ( CUR_RPFA.cod_fis
                                 , y.codice_fiscale, ' '
                                                   , y.codice_fiscale
                                 )
                                )
                        into D_cf_ere
                        from anagrafici y
                           , rapporti_retributivi r
                       where r.ci     = CUR_RPFA.ci
                         and y.al is null
                         and y.ni =
                            (select max(ni)
                               from rapporti_individuali
                              where ci = nvl(CUR_RPFA.ci_erede,CUR_RPFA.ci))
                      ;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            D_cf_ere  := ' ';
                    END;
                    D_cf_prec       := ' ';
                    D_ente_cf       := CUR_RPFA.ente_cf;
                  --
                  --  Inserimento Primo Record Dipendente
                  --
                  IF D_num_ord = 3
                     THEN D_num_ord := 2;
                          D_modulo  := D_modulo  + 1;
                     ELSE D_num_ord := D_num_ord + 1;
                  END IF;
                  D_pagina  := D_pagina + 1;
                  D_riga    := 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , lpad(to_char(CUR_RPFA.ci),8,'0')||
                           lpad(to_char(D_modulo),8,'0')||
                           lpad(to_char(D_num_ord),2,'0')||
                           rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                               ,16,' ')||
                           lpad(' ',18,' ')||
                           nvl(D_dummy_f,' ')||
                           lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')
                         )
                  ;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , 150
                         , '}'
                         )
                  ;
                  IF D_cf_ere != ' '
                     THEN D_riga   := 30;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values ( prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , 'SA'||lpad(to_char(D_num_ord),3,'0')||'039'||
                                   lpad(nvl(D_cf_ere,' '),16,' ')||
                                   '{'
                                 )
                          ;
                  END IF;
                  D_riga         := 29;
                  D_conta_prec   := 0;
                  D_modulo_prec  := D_modulo;
                  D_pagina_prec  := D_pagina;
                  D_num_ord_prec := D_num_ord;
                  FOR CUR_PREC IN
                     (select radi.ci_erede               ci
                           , substr(pegi.note,1,16)      cf
                           , decode(instr(nvl(upper(evra.descrizione),' ')
                                         ,'MOD. 770')
                                   , 0, evra.codice
                                      , substr(evra.descrizione,11,1)) causa_a
                        from periodi_giuridici   pegi
                           , rapporti_diversi    radi
                           , eventi_rapporto     evra
                       where radi.ci            = CUR_RPFA.ci
                         and evra.codice    (+) = pegi.posizione
                         and evra.rilevanza (+) = 'T'
                         and not exists
                            (select 'x' from rapporti_retributivi
                              where ci = radi.ci_erede)
                         and pegi.rilevanza (+) = 'P'
                         and pegi.dal (+)  <= D_fin_a
                         and nvl(pegi.al(+),to_date('3333333','j')) >= D_ini_a
                         and pegi.ci  (+)   = radi.ci_erede
                         and exists
                            (select 'x' from progressivi_fiscali        prfi
                              where prfi.anno    = D_anno
                                and prfi.mese      = 12
                                and prfi.mensilita =
                                   (select max(mensilita) from mensilita
                                     where mese = 12
                                       and tipo in ('N','A','S'))
                                and prfi.ci = radi.ci_erede
                              group by prfi.ci
                             having nvl(sum(prfi.ipn_ac),0) +
                                    nvl(sum(prfi.ipn_ap),0) != 0
                            )
                       order by pegi.dal
                     ) LOOP
                       D_conta_prec := D_conta_prec + 1;
                       select (to_char(nvl(sum(prfi.ipn_ac ),0)))  ipn_ord
                            , to_char(decode
                                      ( nvl(sum(prfi.ipn_ac ),0)
                                       -decode( nvl(sum(prfi.ipn_ass),0)
                                              , 0, nvl(sum(prfi.somme_15),0)
                                                 , sum(prfi.ipn_ass))
                                      , 0 , 2
                                          , 1))                        causa_b
                            , (to_char(greatest(0,nvl(sum(prfi.ipt_pag),0))))
                            , (to_char(nvl(sum(prfi.somme_16),0)))
                            , (to_char(nvl(sum(prfi.add_irpef),0)))
                            , (to_char(nvl(sum(prfi.somme_11),0)))
                         into D_ipn_ord
                            , D_causa_b
                            , D_ipt_pag
                            , D_ipt_sosp
                            , D_add_irpef
                            , D_add_irpef_sosp
                         from progressivi_fiscali   prfi
                        where prfi.anno         = D_anno
                          and prfi.mese         = 12
                          and prfi.mensilita    = (select max(mensilita)
                                                     from mensilita
                                                    where mese = 12
                                                      and tipo in ('A','N','S'))
                          and prfi.ci           = CUR_PREC.ci
                       ;
                       IF mod(D_conta_prec,2) = 0
                        THEN
                          D_riga:= D_riga + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values
                          ( prenotazione
                          , 1
                          , D_pagina_prec
                          , D_riga
                          , 'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'046'||
                            rpad(nvl(CUR_PREC.cf,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'A47'||
                            lpad(nvl(CUR_PREC.causa_a,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'B47'||
                            lpad(nvl(D_causa_b,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'048'||
                            lpad(D_ipn_ord,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'049'||
                            lpad(D_ipt_pag,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'050'||
                            lpad(D_ipt_sosp,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'051'||
                            lpad(D_add_irpef,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'052'||
                            lpad(D_add_irpef_sosp,16,' ')||
                            '{'
                          )
                          ;
                          ELSE
                           IF D_conta_prec != 1
                            THEN
                              IF D_num_ord_prec = 3
                                 THEN D_num_ord_prec := 2;
                                      D_modulo_prec  := D_modulo_prec  + 1;
                                 ELSE D_num_ord_prec := D_num_ord_prec + 1;
                              END IF;
                              D_pagina_prec := D_pagina_prec + 1;
                              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                              values ( prenotazione
                                     , 1
                                     , D_pagina_prec
                                     , 1
                                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                                       lpad(to_char(D_modulo_prec),8,'0')||
                                       lpad(to_char(D_num_ord_prec),2,'0')||
                                       rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                           ,16,' ')
                                     )
                              ;
                              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                              values ( prenotazione
                                     , 1
                                     , D_pagina_prec
                                     , 150
                                     , '}'
                                     )
                              ;
                              D_riga := 29;
                          END IF;
                          D_riga:= D_riga + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values
                          ( prenotazione
                          , 1
                          , D_pagina_prec
                          , D_riga
                          , 'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'039'||
                            rpad(nvl(CUR_PREC.cf,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'A40'||
                            lpad(nvl(CUR_PREC.causa_a,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'B40'||
                            lpad(nvl(D_causa_b,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'041'||
                            lpad(D_ipn_ord,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'042'||
                            lpad(D_ipt_pag,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'043'||
                            lpad(D_ipt_sosp,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'044'||
                            lpad(D_add_irpef,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'045'||
                            lpad(D_add_irpef_sosp,16,' ')||
                            '{'
                          )
                          ;
                       END IF;
                       END LOOP;
                  FOR CUR_TER IN
                     (select inex.ditta1                         cf
                           , to_char((nvl(inex.ipn_1,0)))     ipn_ord
                           , to_char((nvl(inex.ipt_1,0)))     ipt_pag
                           , to_char((nvl(inex.add_reg_1,0))) add_irpef
                           , '3'                                 causa_a
                           , to_char(decode( nvl(inex.ipn_1,0)
                                            -nvl(inex.ipn_ass_1,0)
                                           , 0, 2, 1))           causa_b
                       from informazioni_extracontabili inex
                      where anno = D_anno
                        and ci   = CUR_RPFA.ci
                        and nvl(ipn_1,0) != 0
                      union
                      select inex.ditta2                         cf
                           , to_char((nvl(inex.ipn_2,0)))     ipn_ord
                           , to_char((nvl(inex.ipt_2,0)))     ipt_pag
                           , to_char((nvl(inex.add_reg_2,0))) add_irpef
                           , '3'                                 causa_a
                           , to_char(decode( nvl(inex.ipn_2,0)
                                            -nvl(inex.ipn_ass_2,0)
                                           , 0, 2, 1))           causa_b
                       from informazioni_extracontabili inex
                      where anno = D_anno
                        and ci   = CUR_RPFA.ci
                        and nvl(ipn_2,0) != 0
                      union
                      select inex.ditta3                         cf
                           , to_char((nvl(inex.ipn_3,0)))     ipn_ord
                           , to_char((nvl(inex.ipt_3,0)))     ipt_pag
                           , to_char((nvl(inex.add_reg_3,0))) add_irpef
                           , '3'                                 causa_a
                           , to_char(decode( nvl(inex.ipn_3,0)
                                            -nvl(inex.ipn_ass_3,0)
                                           , 0, 2, 1))           causa_b
                       from informazioni_extracontabili inex
                      where anno = D_anno
                        and ci   = CUR_RPFA.ci
                        and nvl(ipn_3,0) != 0
                     ) LOOP
                         D_conta_prec := D_conta_prec + 1;
                         IF mod(D_conta_prec,2) = 0
                          THEN
                          D_riga:= D_riga + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values
                          ( prenotazione
                          , 1
                          , D_pagina_prec
                          , D_riga
                          , 'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'046'||
                            rpad(nvl(CUR_TER.cf,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'A47'||
                            lpad(nvl(CUR_TER.causa_a,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'B47'||
                            lpad(nvl(CUR_TER.causa_b,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'048'||
                            lpad(CUR_TER.ipn_ord,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'049'||
                            lpad(CUR_TER.ipt_pag,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'050'||
                            lpad('0',16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'051'||
                            lpad(CUR_TER.add_irpef,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'052'||
                            lpad('0',16,' ')||
                            '{'
                          )
                          ;
                          ELSE
                           IF D_conta_prec != 1
                            THEN
                              IF D_num_ord_prec = 3
                                 THEN D_num_ord_prec := 2;
                                      D_modulo_prec  := D_modulo_prec  + 1;
                                 ELSE D_num_ord_prec := D_num_ord_prec + 1;
                              END IF;
                              D_pagina_prec := D_pagina_prec + 1;
                              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                              values ( prenotazione
                                     , 1
                                     , D_pagina_prec
                                     , 1
                                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                                       lpad(to_char(D_modulo_prec),8,'0')||
                                       lpad(to_char(D_num_ord_prec),2,'0')||
                                       rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                           ,16,' ')
                                     )
                              ;
                              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                              values ( prenotazione
                                     , 1
                                     , D_pagina_prec
                                     , 150
                                     , '}'
                                     )
                              ;
                          D_riga := 29;
                          END IF;
                          D_riga:= D_riga + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values
                          ( prenotazione
                          , 1
                          , D_pagina_prec
                          , D_riga
                          , 'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'039'||
                            rpad(nvl(CUR_TER.cf,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'A40'||
                            lpad(nvl(CUR_TER.causa_a,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'B40'||
                            lpad(nvl(CUR_TER.causa_b,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'041'||
                            lpad(CUR_TER.ipn_ord,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'042'||
                            lpad(CUR_TER.ipt_pag,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'043'||
                            lpad('0',16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'044'||
                            lpad(CUR_TER.add_irpef,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_prec),3,'0')||'045'||
                            lpad('0',16,' ')||
                            '{'
                          )
                          ;
                       END IF;
                       END LOOP;
                END IF;
                  D_riga         := 60;
                  D_conta_inps   := 0;
                  D_pagina_inps  := D_pagina;
                  D_modulo_inps  := D_modulo;
                  D_num_ord_inps := D_num_ord;
                  FOR CUR_INPS IN
                     (select lpad(nvl(gest.posizione_inps,'0'),10,'0') matr_az
                           , nvl(d1is.provincia,gest.provincia_inps)   prov_lav
                           , decode( d1is.assicurazioni
                                   , '1', '1'
                                   , '5', '1'
                                   , '6', '1'
                                   , '7', '1'
                                        , '0')||
                             decode( d1is.assicurazioni
                                   , '2', '1'
                                   , '5', '1'
                                   , '7', '1'
                                   , '8', '1'
                                        , '0')||
                             decode( d1is.assicurazioni
                                   , '3', '1'
                                   , '6', '1'
                                   , '7', '1'
                                   , '8', '1'
                                        , '0')||
                             decode( d1is.assicurazioni
                                   , '4', '1'
                                        , '0')       assicurazioni
                           , to_char(sum(nvl(d1is.importo_cc,0))
                                    )                          competenze_corr
                           , to_char(sum(nvl(d1is.importo_ac,0))
                                    )                          altre_competenze
                           , to_char(sum(nvl(d1is.settimane,0)))   settimane
                           , to_char(sum(nvl(d1is.giorni,0)))      giorni
                           , decode( max(nvl(substr(d1is.mesi,1,1),' '))||
                                     max(nvl(substr(d1is.mesi,2,1),' '))||
                                     max(nvl(substr(d1is.mesi,3,1),' '))||
                                     max(nvl(substr(d1is.mesi,4,1),' '))||
                                     max(nvl(substr(d1is.mesi,5,1),' '))||
                                     max(nvl(substr(d1is.mesi,6,1),' '))||
                                     max(nvl(substr(d1is.mesi,7,1),' '))||
                                     max(nvl(substr(d1is.mesi,8,1),' '))||
                                     max(nvl(substr(d1is.mesi,9,1),' '))||
                                     max(nvl(substr(d1is.mesi,10,1),' '))||
                                     max(nvl(substr(d1is.mesi,11,1),' '))||
                                     max(nvl(substr(d1is.mesi,12,1),' '))
                                   , lpad('X',12,'X'),'1','0')          tutti
                           , decode( max(nvl(substr(d1is.mesi,1,1),' '))||
                                     max(nvl(substr(d1is.mesi,2,1),' '))||
                                     max(nvl(substr(d1is.mesi,3,1),' '))||
                                     max(nvl(substr(d1is.mesi,4,1),' '))||
                                     max(nvl(substr(d1is.mesi,5,1),' '))||
                                     max(nvl(substr(d1is.mesi,6,1),' '))||
                                     max(nvl(substr(d1is.mesi,7,1),' '))||
                                     max(nvl(substr(d1is.mesi,8,1),' '))||
                                     max(nvl(substr(d1is.mesi,9,1),' '))||
                                     max(nvl(substr(d1is.mesi,10,1),' '))||
                                     max(nvl(substr(d1is.mesi,11,1),' '))||
                                     max(nvl(substr(d1is.mesi,12,1),' '))
                                   , lpad('X',12,'X'), '0'
                                      , decode( max(nvl(substr(d1is.mesi,1,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,2,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,3,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,4,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,5,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,6,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,7,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,8,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,9,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,10,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,11,1),' '))
                                              , 'X', '0'
                                                   , '1')||
                                        decode( max(nvl(substr(d1is.mesi,12,1),' '))
                                              , 'X', '0'
                                                   , '1'))         mesi
                           , max(d1is.contratto)                   contratto
                           , decode( D_tipo_contratto
                                   , 'X', ' '
                                        , D_tipo_contratto)        tipo_con
                           , max(d1is.livello)                     livello
                           , max(to_char(d1is.data_cessazione,'ddmm')) data_cess
                           , max(nvl(d1is.tipo_rapporto,'0'))          tipo_rapp
                           , max(decode( d1is.trasf_rapporto
                                   , 'SI', '1', '0'))              trasf_rapp
                           , to_char(sum(nvl(d1is.sett_utili,'0')))  sett_utili
                           , '0'                                   matr_az_prec
                           , to_char(sum(nvl(d1is.importo_ap,0)))  importo_ap
                           , max(nvl(d1is.tabella_af,' '))         tabella_af
                           , max(to_char(nvl(d1is.nucleo_af,0)))   nucleo_af
                           , max(nvl(d1is.classe_af,' '))          classe_af
                           , '0'                                   altre_rp
                           , max(nvl(d1is.tipo_c1,' '))                tipo_c1
                           , min(to_char(d1is.dal_c1,'ddmmyyyy'))      dal_c1
                           , max(to_char(d1is.al_c1,'ddmmyyyy'))       al_c1
                           , to_char(sum(nvl(d1is.importo_c1,0)))      imp_c1
                           , to_char(sum(nvl(d1is.sett_c1,0)))         sett_c1
                           , to_char(sum(nvl(d1is.gg_r_c1,0)))         gg_r_c1
                           , to_char(sum(nvl(d1is.gg_u_c1,0)))         gg_u_c1
                           , to_char(sum(nvl(d1is.gg_nr_c1,0)))        gg_nr_c1
                           , to_char(sum(nvl(d1is.importo_pen_c1,0)))  imp_pen_c1
                           , max(nvl(d1is.tipo_c2,' '))               tipo_c2
                           , min(to_char(d1is.dal_c2,'ddmmyyyy'))     dal_c2
                           , max(to_char(d1is.al_c2,'ddmmyyyy'))      al_c2
                           , to_char(sum(nvl(d1is.importo_c2,0)))     imp_c2
                           , to_char(sum(nvl(d1is.sett_c2,0)))        sett_c2
                           , to_char(sum(nvl(d1is.gg_r_c2,0)))        gg_r_c2
                           , to_char(sum(nvl(d1is.gg_u_c2,0)))        gg_u_c2
                           , to_char(sum(nvl(d1is.gg_nr_c2,0)))       gg_nr_c2
                           , to_char(sum(nvl(d1is.importo_pen_c2,0))) imp_pen_c2
                           , to_char(sum(nvl(d1is.sett_d,0)))         sett_d
                           , to_char(sum(nvl(d1is.importo_rid_d,0)))  imp_rid_d
                           , to_char(sum(nvl(d1is.importo_cig_d,0)))  imp_cig_d
                           , to_char(sum(nvl(d1is.sett1_mal_d,0)))    s1_mal_d
                           , to_char(sum(nvl(d1is.sett2_mal_d,0)))    s2_mal_d
                           , to_char(sum(nvl(d1is.sett1_mat_d,0)))    s1_mat_d
                           , to_char(sum(nvl(d1is.sett2_mat_d,0)))    s2_mat_d
                           , to_char(sum(nvl(d1is.sett1_m88_d,0)))    s1_m88_d
                           , to_char(sum(nvl(d1is.sett2_m88_d,0)))    s2_m88_d
                           , to_char(sum(nvl(d1is.sett1_cig_d,0)))    s1_cig_d
                           , to_char(sum(nvl(d1is.sett2_cig_d,0)))    s2_cig_d
                           , to_char(sum(nvl(d1is.sett2_dds_d,0)))    s2_dds_d
                           , min(d1is.dal)                            d1is_dal
                        from denuncia_o1_inps   d1is
                           , gestioni           gest
                       where d1is.anno     = D_anno
                         and d1is.ci      in
                            (select CUR_RPFA.ci from dual
                              union
                             select rain.ci
                               from rapporti_individuali rain
                                  , classi_rapporto      clra
                              where rain.ci != CUR_RPFA.ci
                                and rain.ni  =
                                   (select ni from rapporti_individuali
                                     where ci = CUR_RPFA.ci)
                                and clra.codice = rain.rapporto
                                and clra.presenza = 'SI'
                                and clra.giuridico = 'SI'
                                and clra.retributivo = 'SI'
                                and exists
                                   (select 'x' from rapporti_diversi
                                     where ci_erede  = rain.ci)
                             )
                         and d1is.gestione = gest.codice
                       group by lpad(nvl(gest.posizione_inps,'0'),10,'0')
                              , nvl(d1is.provincia,gest.provincia_inps)
                              , d1is.assicurazioni, d1is.qualifica
                       order by min(d1is.dal)
                     ) LOOP
                       D_conta_inps  := D_conta_inps  + 1;
                       IF D_conta_inps != 1 THEN
                          D_pagina_inps  := D_pagina_inps + 1;
                       END IF;
                       IF D_conta_inps != 1 or D_dummy_f is null
                        THEN
                           IF D_num_ord_inps = 3
                              THEN D_num_ord_inps := 2;
                                   D_modulo_inps  := D_modulo_inps  + 1;
                              ELSE D_num_ord_inps := D_num_ord_inps + 1;
                           END IF;
                            insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                            select  prenotazione
                                  , 1
                                  , D_pagina_inps
                                  , 1
                                  , lpad(to_char(CUR_RPFA.ci),8,'0')||
                                    lpad(to_char(D_modulo_inps),8,'0')||
                                    lpad(to_char(D_num_ord_inps),2,'0')||
                                    rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                        ,16,' ')||
                                    to_char(CUR_INPS.d1is_dal)
                              from dual
                             where not exists
                                  (select 'x' from a_appoggio_stampe
                                    where no_prenotazione = prenotazione
                                      and no_passo        = 1
                                      and pagina          = D_pagina_inps
                                      and riga            = 1)
                            ;
                            insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                            select  prenotazione
                                  , 1
                                  , D_pagina_inps
                                  , 150
                                  , '}'
                              from dual
                             where not exists
                                  (select 'x' from a_appoggio_stampe
                                    where no_prenotazione = prenotazione
                                      and no_passo        = 1
                                      and pagina          = D_pagina_inps
                                      and riga            = 150)
                            ;
                            D_riga := 60;
                        END IF;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'061'||
                          lpad(CUR_INPS.matr_az,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'062'||
                          rpad(CUR_INPS.prov_lav,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'063'||
                          lpad(CUR_INPS.assicurazioni,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'064'||
                          lpad(CUR_INPS.competenze_corr,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'065'||
                          lpad(CUR_INPS.altre_competenze,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'066'||
                          lpad(CUR_INPS.settimane,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'067'||
                          lpad(CUR_INPS.giorni,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'068'||
                          lpad(CUR_INPS.tutti,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'069'||
                          lpad(CUR_INPS.mesi,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'070'||
                          rpad(CUR_INPS.contratto,16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'071'||
                          rpad(nvl(CUR_INPS.tipo_con,' '),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'072'||
                          rpad(nvl(CUR_INPS.livello,' '),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'073'||
                          lpad(nvl(CUR_INPS.data_cess,'0'),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'074'||
                          lpad(nvl(CUR_INPS.tipo_rapp,' '),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'075'||
                          lpad(nvl(CUR_INPS.trasf_rapp,' '),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'076'||
                          lpad(nvl(CUR_INPS.sett_utili,'0'),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'077'||
                          lpad(nvl(CUR_INPS.matr_az_prec,' '),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'078'||
                          lpad(nvl(CUR_INPS.importo_ap,'0'),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'079'||
                          rpad(nvl(CUR_INPS.tabella_af,' '),16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'080'||
                          lpad(nvl(CUR_INPS.nucleo_af,' '),16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'081'||
                          rpad(CUR_INPS.classe_af,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'082'||
                          rpad(CUR_INPS.altre_rp,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'083'||
                          rpad(CUR_INPS.tipo_c1,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'084'||
                          lpad(nvl(CUR_INPS.dal_c1,'0'),16,'0')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'085'||
                          lpad(nvl(CUR_INPS.al_c1,'0'),16,'0')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'086'||
                          lpad(CUR_INPS.imp_c1,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'087'||
                          lpad(CUR_INPS.sett_c1,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'088'||
                          lpad(CUR_INPS.gg_r_c1,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'089'||
                          lpad(CUR_INPS.gg_u_c1,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'090'||
                          lpad(CUR_INPS.gg_nr_c1,16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'091'||
                          lpad(CUR_INPS.imp_pen_c1,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'092'||
                          rpad(CUR_INPS.tipo_c2,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'093'||
                          lpad(nvl(CUR_INPS.dal_c2,'0'),16,'0')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'094'||
                          lpad(nvl(CUR_INPS.al_c2,'0'),16,'0')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'095'||
                          lpad(CUR_INPS.imp_c2,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'096'||
                          lpad(CUR_INPS.sett_c2,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'097'||
                          lpad(CUR_INPS.gg_r_c2,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'098'||
                          lpad(CUR_INPS.gg_u_c2,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'099'||
                          lpad(CUR_INPS.gg_nr_c2,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'100'||
                          lpad(CUR_INPS.imp_pen_c2,16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'101'||
                          lpad(CUR_INPS.sett_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'102'||
                          lpad(CUR_INPS.imp_rid_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'103'||
                          lpad(CUR_INPS.imp_cig_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'104'||
                          lpad(CUR_INPS.s1_mal_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'105'||
                          lpad(CUR_INPS.s2_mal_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'106'||
                          lpad(CUR_INPS.s1_mat_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'107'||
                          lpad(CUR_INPS.s2_mat_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'108'||
                          lpad(CUR_INPS.s1_m88_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'109'||
                          lpad(CUR_INPS.s2_m88_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'110'||
                          lpad(CUR_INPS.s1_cig_d,16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'111'||
                          lpad(CUR_INPS.s2_cig_d,16,' ')||
                          'SA'||lpad(to_char(D_num_ord_inps),3,'0')||'112'||
                          lpad(CUR_INPS.s2_dds_d,16,' ')||
                          '{'
                        )
                        ;
                       D_dummy_f := 'x';
                       END LOOP;
                  D_riga          := 100;
                  D_conta_inail   := 0;
                  D_pagina_inail  := D_pagina;
                  D_modulo_inail  := D_modulo;
                  D_num_ord_inail := D_num_ord;
                  D_pos_inail     := null;
                  D_dal_inail     := to_date(null);
                  D_qua_inps      := null;
                  D_part_time     := null;
                  D_tempo_det     := null;
                  D_qua_fisc      := null;
                  D_qua_inail     := null;
                  D_inail_ci      := 0;
                  D_data_inail    := to_date(null);
                  FOR CUR_INAIL IN
                     (select pos_inail                         pos_inail
                           , nvl(substr(ltrim(pos_inail)
                                       ,1
                                       ,least(8
                                             ,decode(instr(pos_inail,'/')
                                                    ,0,8
                                                      ,instr(pos_inail,'/')-1
                                                    )
                                             )
                                       )
                                ,'0')                          posizione
                           , nvl( substr( pos_inail
                                        ,decode( instr(pos_inail,'/')
                                               ,0,9
                                                 ,instr(pos_inail,'/')+1
                                               )
                                        ,2)
                                ,'0')                          contro_cod
                           , data_variazione                   dal
                           , nvl(qua_inps,' ')                 qua_inps
                           , nvl(part_time,' ')                part_time
                           , nvl(tempo_determinato,' ')        tempo_det
                           , nvl(qua_fiscale,' ')              qua_fisc
                           , nvl(qua_inail,' ')                qua_inail
                           , ci                                inail_ci
                           , dal                               data
                        from denuncia_inail
                       where anno = D_anno
                         and tipo_variazione = '1'
                         and ci      in
                            (select CUR_RPFA.ci from dual
                              union
                             select rain.ci
                               from rapporti_individuali rain
                                  , classi_rapporto      clra
                              where rain.ci != CUR_RPFA.ci
                                and rain.ni  =
                                   (select ni from rapporti_individuali
                                     where ci = CUR_RPFA.ci)
                                and clra.codice = rain.rapporto
                                and clra.presenza = 'SI'
                                and clra.giuridico = 'SI'
                                and clra.retributivo = 'SI'
                                and exists
                                   (select 'x' from rapporti_diversi
                                     where ci_erede  = rain.ci)
                             )
                      union
                      select 'Z'                               pos_inail
                           , null                              posizione
                           , null                              contro_cod
                           , to_date('3333333','j')            dal
                           , 'Z'                               qua_inps
                           , 'Z'                               part_time
                           , 'Z'                               tempo_det
                           , 'Z'                               qua_fisc
                           , 'Z'                               qua_inail
                           , to_number(null)                   inail_ci
                           , D_fin_a                           data
                        from dual
                       where exists
                            (select 'x' from denuncia_inail
                              where anno = D_anno
                                and tipo_variazione = '1'
                                and ci   = CUR_RPFA.ci)
                       order by 4
                     ) LOOP
                       IF nvl(D_pos_inail,' ') = CUR_INAIL.pos_inail and
                          nvl(D_qua_inps,' ')  = CUR_INAIL.qua_inps  and
                          nvl(D_part_time,' ') = CUR_INAIL.part_time and
                          nvl(D_tempo_det,' ') = CUR_INAIL.tempo_det and
                          nvl(D_qua_fisc,' ')  = CUR_INAIL.qua_fisc  and
                          nvl(D_qua_inail,' ') = CUR_INAIL.qua_inail
                          THEN D_inail_ci := CUR_INAIL.inail_ci;
                          ELSIF D_pos_inail is null
                           THEN D_pos_inail   := CUR_INAIL.pos_inail;
                                D_posizione   := CUR_INAIL.posizione;
                                D_contro_cod  := CUR_INAIL.contro_cod;
                                D_dal_inail   := CUR_INAIL.dal;
                                D_qua_inps    := CUR_INAIL.qua_inps;
                                D_part_time   := CUR_INAIL.part_time;
                                D_tempo_det   := CUR_INAIL.tempo_det;
                                D_qua_fisc    := CUR_INAIL.qua_fisc;
                                D_qua_inail   := CUR_INAIL.qua_inail;
                                D_inail_ci    := CUR_INAIL.inail_ci;
                                D_data_inail  := CUR_INAIL.data;
                           ELSE
                            IF D_conta_inail != 0 THEN
                            IF nvl(D_qua_inps,' ')  = CUR_INAIL.qua_inps  and
                               nvl(D_part_time,' ') = CUR_INAIL.part_time and
                               nvl(D_tempo_det,' ') = CUR_INAIL.tempo_det and
                               nvl(D_qua_fisc,' ')  = CUR_INAIL.qua_fisc  and
                               nvl(D_qua_inail,' ') = CUR_INAIL.qua_inail
                              THEN D_conta_inail := D_conta_inail + 1;
                              ELSE D_conta_inail := 3;
                            END IF;
                            ELSE D_conta_inail := D_conta_inail + 1;
                            END IF;
                                BEGIN
                                select max(data_variazione)
                                  into D_al_inail
                                  from denuncia_inail
                                 where anno            = D_anno
                                   and ci              = D_inail_ci
                                   and pos_inail       = D_pos_inail
                                   and nvl(qua_inps,' ')        = D_qua_inps
                                   and nvl(part_time,' ')       = D_part_time
                                   and nvl(tempo_determinato,' ') = D_tempo_det
                                   and nvl(qua_fiscale,' ')     = D_qua_fisc
                                   and nvl(qua_inail,' ')       = D_qua_inail
                                   and tipo_variazione = '2'
                                   and data_variazione < CUR_INAIL.dal;
                                END;
                       IF mod(D_conta_inail,2) = 0
                        THEN
                          D_riga:= D_riga + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values
                          ( prenotazione
                          , 1
                          , D_pagina_inail
                          , D_riga
                          , 'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'117'||
                            rpad(nvl(D_posizione,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'118'||
                            lpad(nvl(D_contro_cod,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'119'||
                            lpad(decode
                                 (nvl(D_dal_inail,D_ini_a)
                                 ,D_ini_a,'0'
                                         ,to_char(D_dal_inail,'ddmm'))
                                ,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'120'||
                            lpad(decode
                                 (nvl(D_al_inail,D_fin_a)
                                 ,D_fin_a,'0'
                                         ,to_char(D_al_inail,'ddmm'))
                                ,16,' ')||
                            '{'
                          )
                          ;
                          ELSE
                           IF D_conta_inail != 1 or D_dummy_f is null
                            THEN
                             IF D_num_ord_inail = 3
                                THEN D_num_ord_inail := 2;
                                     D_modulo_inail  := D_modulo_inail  + 1;
                                ELSE D_num_ord_inail := D_num_ord_inail + 1;
                             END IF;
                                D_pagina_inail  := D_pagina_inail  + 1;
                                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                                select prenotazione
                                     , 1
                                     , D_pagina_inail
                                     , 1
                                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                                       lpad(to_char(D_modulo_inail),8,'0')||
                                       lpad(to_char(D_num_ord_inail),2,'0')||
                                       rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                           ,16,' ')||
                                       rpad(' ',9,' ')||
                                       to_char(D_data_inail)
                                  from dual
                                 where not exists
                                      (select 'x' from a_appoggio_stampe
                                        where no_prenotazione = prenotazione
                                          and no_passo        = 1
                                          and pagina          = D_pagina_inail
                                          and riga            = 1)
                                ;
                            insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                            select  prenotazione
                                  , 1
                                  , D_pagina_inail
                                  , 150
                                  , '}'
                              from dual
                             where not exists
                                  (select 'x' from a_appoggio_stampe
                                    where no_prenotazione = prenotazione
                                      and no_passo        = 1
                                      and pagina          = D_pagina_inail
                                      and riga            = 150)
                            ;
                            D_riga := 100;
                            END IF;
                          D_riga:= D_riga + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values
                          ( prenotazione
                          , 1
                          , D_pagina_inail
                          , D_riga
                          , 'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'113'||
                            rpad(nvl(D_posizione,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'114'||
                            lpad(nvl(D_contro_cod,' '),16,' ')||
                            'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'115'||
                            lpad(decode
                                 (nvl(D_dal_inail,D_ini_a)
                                 ,D_ini_a,'0'
                                         ,to_char(D_dal_inail,'ddmm'))
                                ,16,' ')||
                            'SA'||lpad(to_char(D_num_ord_inail),3,'0')||'116'||
                            lpad(decode
                                 (nvl(D_al_inail,D_fin_a)
                                 ,D_fin_a,'0'
                                         ,to_char(D_al_inail,'ddmm'))
                                ,16,' ')||
                            '{'
                          )
                          ;
                       END IF;
                       D_dummy_f     := 'x';
                       D_pos_inail   := CUR_INAIL.pos_inail;
                       D_posizione   := CUR_INAIL.posizione;
                       D_contro_cod  := CUR_INAIL.contro_cod;
                       D_dal_inail   := CUR_INAIL.dal;
                       D_qua_inps    := CUR_INAIL.qua_inps;
                       D_part_time   := CUR_INAIL.part_time;
                       D_tempo_det   := CUR_INAIL.tempo_det;
                       D_qua_fisc    := CUR_INAIL.qua_fisc;
                       D_qua_inail   := CUR_INAIL.qua_inail;
                       D_data_inail  := CUR_INAIL.data;
                       D_inail_ci    := CUR_INAIL.inail_ci;
                       END IF;
                       END LOOP;
                  D_num_ord := to_number
                               (substr
                                (greatest(lpad(to_char(D_modulo),8,'0')||
                                          lpad(to_char(D_num_ord),3,'0')
                                         ,lpad(to_char(D_modulo_prec),8,'0')||
                                          lpad(to_char(D_num_ord_prec),3,'0')
                                         ,lpad(to_char(D_modulo_inps),8,'0')||
                                          lpad(to_char(D_num_ord_inps),3,'0')
                                         ,lpad(to_char(D_modulo_inail),8,'0')||
                                          lpad(to_char(D_num_ord_inail),3,'0')
                                         ),9));
                  D_modulo  := greatest(D_modulo_prec,D_modulo_inail
                                       ,D_modulo_inps,D_modulo);
                  D_pagina  := greatest(D_pagina_prec,D_pagina_inps
                                       ,D_pagina_inail,D_pagina);
                  D_riga    := D_riga   + 1;
                  D_pagina  := D_pagina + 1;
                END;
              D_riga    := 0;
              D_dummy_f := null;
              END LOOP;
      END;
COMMIT;
EXCEPTION
WHEN NO_QUALIFICA THEN
     null;
END;
end;
end;
/

