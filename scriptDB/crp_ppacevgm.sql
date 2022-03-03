CREATE OR REPLACE PACKAGE ppacevgm IS
/******************************************************************************
 NOME:          PPACEVGM
 DESCRIZIONE:   Alimentazione Eventi di Astensione da Deposito_Eventi_Presenza in
                Eventi_Presenza.

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

CREATE OR REPLACE PACKAGE BODY ppacevgm IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 22/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	declare   d_errore                VARCHAR2(6);
          d_dep_variabili_gape    number(1);
          d_dep_periodo_ggpe      VARCHAR2(1);
          d_anno                  number(4);
          d_mese                  number(2);
          d_mensilita             VARCHAR2(3);
          d_ini_ela               date;
          d_fin_ela               date;
          d_ci                    number(8);
          d_causale               causali_evento.codice%TYPE;
          d_assenza               VARCHAR2(4);
          d_data                  date;
          d_operazione            VARCHAR2(1);
          d_dal                   date;
          d_al                    date;
          d_utente                VARCHAR2(8);
          d_rowid                 rowid;
          d_data_agg              date;
          errore                  exception;
 cursor   depa  is  select  depa.ci
                           ,depa.assenza
                           ,depa.data
                           ,depa.operazione
                           ,depa.dal
                           ,depa.al
                           ,depa.utente
                           ,depa.data_agg
                           ,caev.codice
                           ,depa.rowid
                      from  causali_evento           caev
                           ,rapporti_presenza        rapa
                           ,deposito_eventi_presenza depa
                     where  depa.rilevanza         = 'G'
                       and  rapa.ci                = depa.ci
                       and  rapa.dal              <= depa.dal
                       and  nvl(rapa.al,to_date('3333333','j'))
                                                  >=
                            nvl(depa.al,to_date('3333333','j'))
                       and  caev.assenza           = depa.assenza
                       and  lpad(to_char(nvl(caev.sequenza,0)),6,'0')||
                            caev.codice            =
                           (select min(lpad(to_char(nvl(cae2.sequenza,0)),6,'0'
                                           )||cae2.codice
                                      )
                              from causali_evento  cae2
                             where cae2.assenza    = caev.assenza
                           )
                       and  trunc(months_between(last_day(nvl(depa.al
                                                             ,to_date('3333333'
                                                                     ,'j')))+1
                                                ,last_day(depa.dal)))*30
                            -least(30,to_number(to_char(depa.dal,'dd')))+1
                            +least(30,to_number(to_char(nvl(depa.al
                                                       ,to_date('3333333','j'))
                                                       ,'dd')))
                                                  <= nvl(caev.max_qta
                                                        ,999999999999)
                     order  by
                            depa.data_agg
                           ,depa.operazione
                           ,depa.assenza
                           ,depa.ci
                    ;
BEGIN
/*
          +--------------------------------------------------------+
          | Inserisce o Aggiorna o Elimina, secondo il tipo di     |
          | operazione indicata sulla registrazione della tabella  |
          | di deposito, gli eventi di assenza.                    |
          +--------------------------------------------------------+
*/
  BEGIN
    open depa;
    LOOP
      fetch depa into d_ci,d_assenza,d_data,d_operazione,d_dal,d_al,
                      d_utente,d_data_agg,d_causale,d_rowid;
      exit when depa%NOTFOUND;
      IF  d_operazione      = 'I'      -- Inserimento EVPA
                                          THEN
          insert into eventi_presenza
                (evento
                ,ci
                ,causale
                ,riferimento
                ,dal
                ,al
                ,chiuso
                ,input
                ,valore
                ,utente
                ,data_agg
                )
          select evpa_sq.nextval
                ,d_ci
                ,d_causale
                ,d_dal
                ,d_dal
                ,d_al
                ,'SI'
                ,'G'
                ,trunc(months_between(last_day(d_al)+1,last_day(d_dal)))*30
                 -least(30,to_number(to_char(d_dal,'dd')))+1
                 +least(30,to_number(to_char(d_al ,'dd')))
                ,d_utente
                ,d_data_agg
            from dual
           where not exists
                (select 'x'
                   from causali_evento  caev
                       ,eventi_presenza evpa
                  where evpa.ci         = d_ci
                    and evpa.causale    = caev.codice
                    and evpa.dal       <= nvl(d_al,to_date('3333333','j'))
                    and nvl(evpa.al,to_date('3333333','j'))
                                       >= d_dal
                    and caev.riferimento
                                        = 'G'
                    and caev.gestione   = 'G'
                )
          ;
    ELSIF
          d_operazione      = 'U'      -- Variazione  EVPA
                                          THEN
          update eventi_presenza evpa
             set (causale
                 ,riferimento
                 ,dal
                 ,al
                 ,valore
                 ,utente
                 ,data_agg
                 )
               = (select  d_causale
                         ,d_dal
                         ,d_dal
                         ,d_al
                         ,trunc(months_between(last_day(d_al)+1
                                              ,last_day(d_dal)))*30
                               -least(30,to_number(to_char(d_dal,'dd')))+1
                               +least(30,to_number(to_char(d_al ,'dd')))
                         ,d_utente
                         ,d_data_agg
                    from  dual
                 )
           where evpa.ci               = d_ci
             and evpa.causale          = d_causale
             and evpa.riferimento      = d_data
             and not exists
                (select 'x'
                   from causali_evento  caev
                       ,eventi_presenza evp2
                  where evp2.ci         = d_ci
                    and evp2.rowid     != evpa.rowid
                    and evp2.causale    = caev.codice
                    and evp2.dal       <= nvl(d_al,to_date('3333333','j'))
                    and nvl(evp2.al,to_date('3333333','j'))
                                       >= d_dal
                    and caev.riferimento
                                        = 'G'
                    and caev.gestione   = 'G'
                )
          ;
    ELSIF
          d_operazione      = 'D'      -- Eliminazione EVPA
                                          THEN
          delete from eventi_presenza evpa
           where evpa.ci               = d_ci
             and evpa.causale          = d_causale
             and evpa.riferimento      = d_data
          ;
    END IF;
    IF SQL%FOUND THEN
       delete from deposito_eventi_presenza
        where rowid                    = d_rowid
       ;
    END IF;
    END LOOP;
    close depa;
    commit;
  END;
/*
          +--------------------------------------------------------+
          | Se non ci sono errori si salta il passo di stampa.     |
          +--------------------------------------------------------+
*/
  BEGIN
    select 'x'
      into d_errore
      from deposito_eventi_presenza
     where rilevanza   =  'G'
    ;
    RAISE TOO_MANY_ROWS;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      null;
    WHEN NO_DATA_FOUND THEN
      update a_prenotazioni set prossimo_passo = 3
       where no_prenotazione = prenotazione
      ;
  END;
EXCEPTION
  WHEN errore THEN
    ROLLBACK;
    update a_prenotazioni set errore         = d_errore
                             ,prossimo_passo = 99
     where no_prenotazione = prenotazione
    ;
END;
commit;
end;
end;
/

