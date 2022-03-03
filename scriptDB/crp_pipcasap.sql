CREATE OR REPLACE PACKAGE pipcasap IS
/******************************************************************************
 NOME:          PIPCASAP
 DESCRIZIONE:   Creazione delle assegnazioni individuali a progetti in situazione
                non attiva.
                Questa fase consente l'inserimento automatico delle assegnazioni ai
                progetti relativamente a ciascun individuo e per i soli progetti in
                situazione non attiva (stato Provvisorio o Deliberato).
                Presuppone quindi che relativamente al progetto non esistano assegnazioni
                in quanto la fase opera in inserimento.
                La tavola in accesso e` ASSEGNAZIONI_INCENTIVO ; in tale tavola sara`
                inserita una assegnazione per ciascun individuo in funzione delle
                caratteristiche del servizio assimilabili alle quote di assegnazione al
                progetto, in relazione a ciascun periodo di servizio dell'individuo
                La fase si propone di generare il minor numero di assegnazioni possibile,
                pertanto sara` operata una valutazione sulle variazioni delle caratteristi-
                che del servizio, in modo da garantire la continuita` quando queste
                variazioni non risultano essere significative per l'attribuzione al
                progetto stesso.
                Vengono create assegnazioni a fronte di ogni applicazione incentivo
                in relazione alla validita' della stessa; le assegnazioni saranno
                quindi chiuse nel caso la applicazione sia chiusa.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pipcasap IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 21/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
declare
P_progetto varchar2(8);
P_tipo     varchar2(1);
P_inizio   varchar2(10);
P_ini_mes  varchar2(9);
P_fin_mes  varchar2(9);
P_utente   varchar2(8);
begin
--
--  -- Estrazione Parametri di Selezione della Prenotazione
--
      select max(valore) D_progetto
	    into p_progetto
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_PROGETTO'
      ;
      select max(valore) D_tipo
	    into p_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_TIPO'
      ;
      select max(valore) D_inizio
	    into p_inizio
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DATA_INIZIO'
      ;
      select ini_mes D_ini_mes
           , fin_mes D_fin_mes
		   into P_ini_mes, p_fin_mes
        from riferimento_incentivo
       where riip_id = 'RIIP'
      ;
      select utente D_utente
	    into p_utente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
--
-- Inizio operazioni di Funzione
--
--
--  --  Assegnazione Automatica al Progetto
--
DECLARE
D_dummy VARCHAR2(1);
D_ci    number;
D_dal   date;
D_al    date;
msg     varchar2 (50);
FINE    EXCEPTION;
BEGIN
 D_ci := null;
 D_dal := null;
 D_al := null;
   BEGIN  -- Verifica Progetto richiesto
      select 'x'
        into D_dummy
        from progetti_incentivo
       where progetto   = p_progetto
         and situazione = 'N'
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           /* Progetto non previsto o in situazione non consentita */
           update a_prenotazioni set errore = 'P06091'
                                   , prossimo_passo = 99
            where no_prenotazione = prenotazione
           ;
           RAISE;
      WHEN OTHERS THEN null;
   END;
   BEGIN  -- Verifica unicita' Progetto
      select 'x'
        into D_dummy
        from applicazioni_incentivo x
       where progetto   = p_progetto
         and not exists (select 'x' from applicazioni_incentivo
                      where progetto = x.progetto
                        and rowid != x.rowid)
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           /* Progetto non previsto o in situazione non consentita */
            update a_prenotazioni set errore = 'P06091'
                                   , prossimo_passo = 99
            where no_prenotazione = prenotazione
           ;
           RAISE;
      WHEN OTHERS THEN null;
   END;
   BEGIN  -- Verifica Tipo Elaborazione
      IF p_tipo = 'E' THEN
         BEGIN  -- Verifica esistenza Movimenti Liquidati
            select 'x'
              into D_dummy
              from movimenti_incentivo
             where progetto = p_progetto
            ;
            RAISE TOO_MANY_ROWS;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                 /* Esistono Movimenti Liquidati legati al Progetto */
                 update a_prenotazioni set errore = 'P06206'
                                         , prossimo_passo = 99
                  where no_prenotazione = prenotazione
                 ;
                 RAISE FINE;
            WHEN NO_DATA_FOUND THEN
                 BEGIN  -- Delete Assegnazioni Individuali Previste
                    delete from assegnazioni_incentivo
                     where progetto = p_progetto
                       and nvl(p_inizio,nvl(al,to_date('3333333','j')))
                                        <= nvl(al,to_date('3333333','j'))
                    ;
                    delete from rapporti_incentivo x
                     where progetto = p_progetto
                       and not exists (select 'x' from assegnazioni_incentivo
                                        where ci = x.ci
                                          and progetto = x.progetto
                                      )
                    ;
                 END;
                 RAISE NO_DATA_FOUND;  -- Salta fase di Creazione
            WHEN OTHERS THEN null;
         END;
      END IF;
   EXCEPTION
             WHEN NO_DATA_FOUND THEN RAISE;
             WHEN OTHERS THEN null;
   END;
   BEGIN  -- Verifica esistenza Assegnazioni Individuali al Progetto
      select 'x'
        into D_dummy
        from assegnazioni_incentivo
       where progetto   = p_progetto
                       and nvl (p_inizio,nvl(al,to_date('3333333','j')))
                                         <= nvl(al,to_date('3333333','j'))
      ;
      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN TOO_MANY_ROWS THEN
           /* Esistono Assegnazioni Individuali al Progetto */
           update a_prenotazioni set errore = 'P06188'
                                   , prossimo_passo = 99
            where no_prenotazione = prenotazione
           ;
           RAISE FINE;
      WHEN NO_DATA_FOUND THEN
           null;
   END;
   --
   -- Ciclo per ogni registrazione di servizio e incarico sul Progetto
   --
   FOR CURS IN
     (select
       pegi.ci
     , pegi.rilevanza
     , greatest( aqip.dal
               , aeip.dal
               , nvl(quip.dal,to_date('2222222','j'))
               , qugi.dal
               , pegi.dal
               , apip.dal
               , nvl(p_inizio,apip.dal)
               ) dal
     , decode( least( nvl(aqip.al,to_date('3333333','j'))
                    , nvl(aeip.al,to_date('3333333','j'))
                    , nvl(quip.al,to_date('3333333','j'))
                    , nvl(qugi.al,to_date('3333333','j'))
                    , nvl(pegi.al,to_date('3333333','j'))
                    , nvl(apip.al,to_date('3333333','j'))
                    )
             , to_date('3333333','j'), to_date(null)
               , least( nvl(aqip.al,to_date('3333333','j'))
                      , nvl(aeip.al,to_date('3333333','j'))
                      , nvl(quip.al,to_date('3333333','j'))
                      , nvl(qugi.al,to_date('3333333','j'))
                      , nvl(pegi.al,to_date('3333333','j'))
                      , nvl(apip.al,to_date('3333333','j'))
                      )
       ) al
FROM
    attribuzione_quote_incentivo  aqip,
    attribuzione_equipe_incentivo  aeip,
    qualifiche_incentivo  quip,
    qualifiche_giuridiche  qugi,
    periodi_servizio_incarico  pegi,
    applicazioni_incentivo  apip
 where aqip.progetto = apip.progetto
   and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                        , nvl(quip.al,to_date('3333333','j'))
                        , nvl(qugi.al,to_date('3333333','j'))
                        , nvl(pegi.al,to_date('3333333','j'))
                        , nvl(apip.al,to_date('3333333','j'))
                        )
   and nvl(aqip.al,to_date('3333333','j'))
             >= greatest( aeip.dal
                        , nvl(quip.dal,to_date('2222222','j'))
                        , qugi.dal
                        , pegi.dal
                        , apip.dal
                        )
   and (    aqip.equipe = '%'
        or  aqip.equipe = aeip.equipe
       )
   and (    aqip.gruppo = '%'
        or  aqip.gruppo = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
       )
   and (    aqip.rapporto = '%'
        or  aqip.rapporto = (select rapporto
                               from rapporti_individuali
                              where ci = pegi.ci
                            )
       )
   and (    aqip.ruolo = '%'
        or  aqip.ruolo = (select ruolo
                            from posizioni
                           where codice = pegi.posizione
                         )
        and (    aqip.ruolo     != 'SI'
             or  aqip.ruolo      = 'SI'
             and pegi.rilevanza != 'E'
            )
       )
   and qugi.livello   like aqip.livello
   and qugi.contratto like aqip.contratto
   and qugi.codice    like aqip.qualifica
   and nvl(pegi.tipo_rapporto,' ') like aqip.tipo_rapporto
   and (    aqip.mesi  = 0
        or  aqip.mesi >=
           (select nvl
                   ( sum
                     ( trunc
                       ( months_between
                         ( last_day
                           ( least( nvl( peg2.al+1, riip.ini_mes )
                                  , riip.ini_mes
                                  )
                           )
                         , last_day(dal)
                         )
                       )
                     * 30
                     - least( 30
                            , to_number(to_char(peg2.dal,'dd'))
                            ) + 1
                     + least( 30
                            , to_number
                              ( to_char
                                ( least( nvl( peg2.al+1, riip.ini_mes)
                                       , riip.ini_mes
                                       )
                                , 'dd'
                                )
                              )
                            ) - 1
                     ) / 30
                   , 0
                   )
              from riferimento_incentivo riip
                 , periodi_giuridici     peg2
             where riip.riip_id   = 'RIIP'
               and peg2.dal      <= riip.ini_mes
               and peg2.qualifica = pegi.qualifica
               and peg2.rilevanza = 'Q'
               and peg2.ci        = decode(aqip.mesi,0,0,pegi.ci)
           )
       )
   and aeip.gruppo  = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
   and aeip.settore = pegi.settore
   and aeip.sede    = nvl(pegi.sede,0)
   and aeip.dal    <= least( nvl(quip.al,to_date('3333333','j'))
                           , nvl(qugi.al,to_date('3333333','j'))
                           , nvl(pegi.al,to_date('3333333','j'))
                           , nvl(apip.al,to_date('3333333','j'))
                           )
   and nvl(aeip.al,to_date('3333333','j'))
                   >= greatest( nvl(quip.dal,to_date('2222222','j'))
                              , qugi.dal
                              , pegi.dal
                              , apip.dal
                              )
   and quip.numero (+) = pegi.qualifica
   and quip.dal (+)   <= nvl(pegi.al,to_date('3333333','j'))
   and nvl(quip.dal,to_date('2222222','j'))
                      <= least( nvl(qugi.al,to_date('3333333','j'))
                              , nvl(pegi.al,to_date('3333333','j'))
                              , nvl(apip.al,to_date('3333333','j'))
                              )
   and nvl(quip.al,to_date('3333333','j'))
                   >= greatest( qugi.dal
                              , pegi.dal
                              , apip.dal
                              )
   and qugi.numero = pegi.qualifica
   and qugi.dal   <= least( nvl(pegi.al,to_date('3333333','j'))
                          , nvl(apip.al,to_date('3333333','j'))
                          )
   and nvl(qugi.al,to_date('3333333','j'))
               >= greatest( pegi.dal
                          , apip.dal
                          )
   and pegi.dal   <= nvl(apip.al,to_date('3333333','j'))
   and nvl(pegi.al,to_date('3333333','j'))
               >= apip.dal
   and nvl(pegi.al,to_date('3333333','j'))
               >= greatest( apip.dal
                           ,nvl(p_inizio,apip.dal)
                          )
   and apip.progetto = p_progetto
   and nvl(apip.al,to_date('3333333','j'))
                    >= nvl(p_inizio,apip.dal)
union
   select
       pegi.ci
     , pegi.rilevanza
     , greatest( aqip.dal
               , aeip.dal
               , nvl(quip.dal,to_date('2222222','j'))
               , qugi.dal
               , pegi.dal
               , apip.dal
               , nvl(p_inizio,apip.dal)
               ) dal
     , decode( least( nvl(aqip.al,to_date('3333333','j'))
                    , nvl(aeip.al,to_date('3333333','j'))
                    , nvl(quip.al,to_date('3333333','j'))
                    , nvl(qugi.al,to_date('3333333','j'))
                    , nvl(pegi.al,to_date('3333333','j'))
                    , nvl(apip.al,to_date('3333333','j'))
                    )
             , to_date('3333333','j'), to_date(null)
               , least( nvl(aqip.al,to_date('3333333','j'))
                      , nvl(aeip.al,to_date('3333333','j'))
                      , nvl(quip.al,to_date('3333333','j'))
                      , nvl(qugi.al,to_date('3333333','j'))
                      , nvl(pegi.al,to_date('3333333','j'))
                      , nvl(apip.al,to_date('3333333','j'))
                      )
       ) al
FROM
    attribuzione_quote_incentivo  aqip,
    attribuzione_equipe_incentivo  aeip,
    qualifiche_incentivo  quip,
    qualifiche_giuridiche  qugi,
    periodi_servizio_incarico  pegi,
    applicazioni_incentivo  apip
 where aqip.progetto = apip.progetto
   and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                        , nvl(quip.al,to_date('3333333','j'))
                        , nvl(qugi.al,to_date('3333333','j'))
                        , nvl(pegi.al,to_date('3333333','j'))
                        , nvl(apip.al,to_date('3333333','j'))
                        )
   and nvl(aqip.al,to_date('3333333','j'))
             >= greatest( aeip.dal
                        , nvl(quip.dal,to_date('2222222','j'))
                        , qugi.dal
                        , pegi.dal
                        , apip.dal
                        )
   and (    aqip.equipe = '%'
        or  aqip.equipe = aeip.equipe
       )
   and (    aqip.gruppo = '%'
        or  aqip.gruppo = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
       )
   and (    aqip.rapporto = '%'
        or  aqip.rapporto = (select rapporto
                               from rapporti_individuali
                              where ci = pegi.ci
                            )
       )
   and (    aqip.ruolo = '%'
        or  aqip.ruolo = (select ruolo
                            from posizioni
                           where codice = pegi.posizione
                         )
        and (    aqip.ruolo     != 'SI'
             or  aqip.ruolo      = 'SI'
             and pegi.rilevanza != 'E'
            )
       )
   and qugi.livello   like aqip.livello
   and qugi.contratto like aqip.contratto
   and qugi.codice    like aqip.qualifica
   and nvl(pegi.tipo_rapporto,' ') like aqip.tipo_rapporto
   and (    aqip.mesi  = 0
        or  aqip.mesi >=
           (select nvl
                   ( sum
                     ( trunc
                       ( months_between
                         ( last_day
                           ( least( nvl( peg2.al+1, riip.ini_mes )
                                  , riip.ini_mes
                                  )
                           )
                         , last_day(dal)
                         )
                       )
                     * 30
                     - least( 30
                            , to_number(to_char(peg2.dal,'dd'))
                            ) + 1
                     + least( 30
                            , to_number
                              ( to_char
                                ( least( nvl( peg2.al+1, riip.ini_mes)
                                       , riip.ini_mes
                                       )
                                , 'dd'
                                )
                              )
                            ) - 1
                     ) / 30
                   , 0
                   )
              from riferimento_incentivo riip
                 , periodi_giuridici     peg2
             where riip.riip_id   = 'RIIP'
               and peg2.dal      <= riip.ini_mes
               and peg2.qualifica = pegi.qualifica
               and peg2.rilevanza = 'Q'
               and peg2.ci        = decode(aqip.mesi,0,0,pegi.ci)
           )
       )
   and aeip.gruppo  = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
   and aeip.settore = 0
   and aeip.sede    = 0
   and not exists
      (select 'x'
         from attribuzione_equipe_incentivo
        where gruppo  = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
          and settore = pegi.settore
          and sede    = nvl(pegi.sede,0)
      )
   and quip.numero (+) = pegi.qualifica
   and quip.dal (+)   <= nvl(pegi.al,to_date('3333333','j'))
   and nvl(quip.dal,to_date('2222222','j'))
                      <= least( nvl(qugi.al,to_date('3333333','j'))
                              , nvl(pegi.al,to_date('3333333','j'))
                              , nvl(apip.al,to_date('3333333','j'))
                              )
   and nvl(quip.al,to_date('3333333','j'))
                   >= greatest( qugi.dal
                              , pegi.dal
                              , apip.dal
                              )
   and qugi.numero = pegi.qualifica
   and qugi.dal   <= least( nvl(pegi.al,to_date('3333333','j'))
                          , nvl(apip.al,to_date('3333333','j'))
                          )
   and nvl(qugi.al,to_date('3333333','j'))
               >= greatest( pegi.dal
                          , apip.dal
                          )
   and pegi.dal   <= nvl(apip.al,to_date('3333333','j'))
   and nvl(pegi.al,to_date('3333333','j'))
               >= apip.dal
   and nvl(pegi.al,to_date('3333333','j'))
               >= greatest( apip.dal
                           ,nvl(p_inizio,apip.dal)
                          )
   and apip.progetto = p_progetto
   and nvl(apip.al,to_date('3333333','j'))
                    >= nvl(p_inizio,apip.dal)
   order by 1,3
      )
   LOOP
   BEGIN  -- Verifica se registrazione da trattare
      IF  curs.ci  = D_ci
      AND curs.dal = D_al+1  THEN
          D_al := curs.al;
      ELSE
          IF D_ci is null THEN
             D_ci  := curs.ci;
             D_dal := curs.dal;
             D_al  := curs.al;
          ELSE
             BEGIN  -- Registra assegnazione memorizzata
                insert into assegnazioni_incentivo
                      ( progetto, ci, dal, al, note, utente, data_agg)
                values( p_progetto
                      , D_ci
                      , D_dal
                      , D_al
                      , 'Aut.'
                      , p_utente
                      , p_ini_mes
                      )
                ;
                insert into rapporti_incentivo (progetto,scp,ci)
                 select p_progetto,
                        scp,
                        D_ci
                   from applicazioni_incentivo apip
                  where apip.progetto = p_progetto
                    and not exists (select 'x' from rapporti_incentivo
                                     where ci = D_ci
                                       and progetto = p_progetto
                                       and scp = apip.scp
                                   )
                ;
             END;
             D_ci  := curs.ci;
             D_dal := curs.dal;
             D_al  := curs.al;
          END IF;
      END IF;
   END;
   END LOOP;
   IF D_ci is not null THEN
      BEGIN  -- Tratta ultima registrazione
         insert into assegnazioni_incentivo
               ( progetto, ci, dal, al, note, utente, data_agg)
         values( p_progetto
               , D_ci
               , D_dal
               , D_al
               , 'Aut.'
               , p_utente
               , p_ini_mes
               )
         ;
                insert into rapporti_incentivo (progetto,scp,ci)
                (select p_progetto,
                        scp,
                        D_ci
                   from applicazioni_incentivo apip
                  where apip.progetto = p_progetto
                    and not exists (select 'x' from rapporti_incentivo
                                     where ci = D_ci
                                       and progetto = p_progetto
                                       and scp = apip.scp
                                   )
                )
                ;
      END;
   END IF;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN  null;
   WHEN OTHERS THEN
       msg := substr(SQLERRM,1,50);
COMMIT;
END;
end;
end;
end;
/

