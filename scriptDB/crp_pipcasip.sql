CREATE OR REPLACE PACKAGE pipcasip IS
/******************************************************************************
 NOME:          PIPCASIP
 DESCRIZIONE:   Revisione delle assegnazioni degli individui a progetto in relazione alle
                variazioni apportate al servizio e significative per l'attribuzione al
                progetto.
                Questa fase consente di ricostruire le assegnazioni individuali ai pro-
                getti, a seguito di variazioni verificatesi sul servizio del dipendente.
                Vengono riallineati tutti gli individui aventi una data di rettifiche
                giuridiche <= al fine mese di riferimento incentivo.
                Per ciascun individuo e per la relativa data di riferimento giuridico
                vengono rivalutate le assegnazioni al progetto in relazione al legame
                tra le caratteristiche del servizio e le quote di attribuzione al
               progetto.
               La fase si propone di non eliminare assegnazioni preesistenti al fine
               di non perdere eventuali variazioni manuali.
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

CREATE OR REPLACE PACKAGE BODY pipcasip IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 21/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
declare
P_fin_mes  varchar2(9);
P_ini_mes  varchar2(9);
P_utente   varchar2(8);
begin
--
--    Allineamento Assegnazioni al Progetto
--
-- La tavola in accesso e` ASSEGNAZIONI_INCENTIVO ; in tale tavola sara`
-- inserita una assegnazione per ciascun individuo in funzione delle
-- caratteristiche del servizio assimilabili alle quote di assegnazione al
-- progetto, in relazione a ciascun periodo di servizio dell'individuo
-- La fase si propone di generare il minor numero di assegnazioni possibile,
-- pertanto sara` operata una valutazione sulle variazioni delle caratteristi-
-- che del servizio, in modo da garantire la continuita` quando queste
-- variazioni non risultano essere significative per l'attribuzione al
-- progetto stesso.
--
--
--  -- Estrazione Parametri di Selezione della Prenotazione
--
      select ini_mes D_ini_mes
           , fin_mes D_fin_mes
		   into p_ini_mes, p_fin_mes
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
DECLARE
D_dummy     VARCHAR2(1);
D_ci        number(8);
D_dal       date;
D_al        date;
D_progetto  varchar2(8);
D_segnale   VARCHAR2(1);
D_coni      date;
D_imp       number(10);
D_dal2      date;
D_al2       date;
D_imp2      number(10);
cursor ragi is
select ci,d_coni
  from rapporti_giuridici
 where nvl(d_coni,to_date('3333333','j')) <= to_date(p_fin_mes)
 order by ci
;
cursor prip is
     select progetto
       from progetti_incentivo
      where situazione = 'A'
        and assegnazione = 'A'
      order by progetto
;
cursor asse is
     select
      greatest( aqip.dal
              , aeip.dal
              , nvl(quip.dal,to_date('2222222','j'))
              , qugi.dal
              , pegi.dal
              , asip.dal
              ) dal
    , decode( least( nvl(aqip.al,to_date('3333333','j'))
                   , nvl(aeip.al,to_date('3333333','j'))
                   , nvl(quip.al,to_date('3333333','j'))
                   , nvl(qugi.al,to_date('3333333','j'))
                   , nvl(pegi.al,to_date('3333333','j'))
                   , nvl(asip.al,to_date('3333333','j'))
                   )
              , to_date('3333333','j'), to_date(null)
              , least( nvl(aqip.al,to_date('3333333','j'))
                     , nvl(aeip.al,to_date('3333333','j'))
                     , nvl(quip.al,to_date('3333333','j'))
                     , nvl(qugi.al,to_date('3333333','j'))
                     , nvl(pegi.al,to_date('3333333','j'))
                     , nvl(asip.al,to_date('3333333','j'))
                     )
      ) al
    , asip.importo
     FROM
        attribuzione_quote_incentivo   aqip,
        attribuzione_equipe_incentivo  aeip,
        qualifiche_incentivo           quip,
        qualifiche_giuridiche          qugi,
        assegnazioni_incentivo         asip,
        periodi_servizio_incarico      pegi
      where aqip.progetto = d_progetto
        and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                             , nvl(quip.al,to_date('3333333','j'))
                             , nvl(qugi.al,to_date('3333333','j'))
                             , nvl(pegi.al,to_date('3333333','j'))
                             )
        and nvl(aqip.al,to_date('3333333','j'))
                     >= greatest( aeip.dal
                                , nvl(quip.dal,to_date('2222222','j'))
                                , qugi.dal
                                , pegi.dal
                                )
        and (    aqip.equipe    = '%'
             or  aqip.equipe    = aeip.equipe
            )
        and (    aqip.gruppo    = '%'
             or  aqip.gruppo    = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
            )
        and (    aqip.rapporto  = '%'
             or  aqip.rapporto  = (select rapporto
                                     from rapporti_individuali
                                    where ci = pegi.ci
                                  )
            )
        and (    aqip.ruolo     = '%'
             or  aqip.ruolo     = (select ruolo
                                     from posizioni
                                    where codice = pegi.posizione
                              )
             and (    aqip.ruolo     != 'SI'
                  or  aqip.ruolo      = 'SI'
                  and pegi.rilevanza != 'E'
                 )
            )
        and qugi.livello        like aqip.livello
        and qugi.contratto      like aqip.contratto
        and qugi.codice         like aqip.qualifica
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
                    and peg2.ci = decode(aqip.mesi,0,0,pegi.ci)
                )
            )
             and (aeip.gruppo   = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
             and aeip.settore   = pegi.settore
             and aeip.sede      = nvl(pegi.sede,0)
             and aeip.dal      <= least( nvl(quip.al,to_date('3333333','j'))
                                       , nvl(qugi.al,to_date('3333333','j'))
                                       , nvl(pegi.al,to_date('3333333','j'))
                                       )
             and nvl(aeip.al,to_date('3333333','j'))
                               >= greatest( nvl(quip.dal,to_date('2222222','j'))
                                           ,    qugi.dal
                                           ,    pegi.dal
                                        )
            )
        and quip.numero (+)     = pegi.qualifica
        and quip.dal (+)       <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(quip.dal,to_date('2222222','j'))
                               <= least( nvl(qugi.al,to_date('3333333','j'))
                                       , nvl(pegi.al,to_date('3333333','j'))
                                       )
        and nvl(quip.al,to_date('3333333','j'))
                               >= greatest( qugi.dal
                                           , pegi.dal
                                          )
        and qugi.numero         = pegi.qualifica
        and qugi.dal           <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(qugi.al,to_date('3333333','j'))
                               >= pegi.dal
        and pegi.ci             = d_ci
        and nvl(pegi.al,to_date('3333333','j'))
                               >= d_coni
        and asip.progetto       = d_progetto
        and asip.ci             = pegi.ci
        and asip.dal           <= least(nvl(aqip.al,to_date('3333333','j'))
                                       ,nvl(aeip.al,to_date('3333333','j'))
                                       ,nvl(quip.al,to_date('3333333','j'))
                                       ,nvl(qugi.al,to_date('3333333','j'))
                                       ,nvl(pegi.al,to_date('3333333','j'))
                                       )
        and nvl(asip.al,to_date('3333333','j'))
                               >= greatest(aqip.dal
                                          ,aeip.dal
                                          ,quip.dal
                                          ,qugi.dal
                                          ,pegi.dal
                                          )
union
     select
      greatest( aqip.dal
              , aeip.dal
              , nvl(quip.dal,to_date('2222222','j'))
              , qugi.dal
              , pegi.dal
              , asip.dal
              ) dal
    , decode( least( nvl(aqip.al,to_date('3333333','j'))
                   , nvl(aeip.al,to_date('3333333','j'))
                   , nvl(quip.al,to_date('3333333','j'))
                   , nvl(qugi.al,to_date('3333333','j'))
                   , nvl(pegi.al,to_date('3333333','j'))
                   , nvl(asip.al,to_date('3333333','j'))
                   )
              , to_date('3333333','j'), to_date(null)
              , least( nvl(aqip.al,to_date('3333333','j'))
                     , nvl(aeip.al,to_date('3333333','j'))
                     , nvl(quip.al,to_date('3333333','j'))
                     , nvl(qugi.al,to_date('3333333','j'))
                     , nvl(pegi.al,to_date('3333333','j'))
                     , nvl(asip.al,to_date('3333333','j'))
                     )
      ) al
    , asip.importo
     FROM
        attribuzione_quote_incentivo   aqip,
        attribuzione_equipe_incentivo  aeip,
        qualifiche_incentivo           quip,
        qualifiche_giuridiche          qugi,
        assegnazioni_incentivo         asip,
        periodi_servizio_incarico      pegi
      where aqip.progetto = d_progetto
        and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                             , nvl(quip.al,to_date('3333333','j'))
                             , nvl(qugi.al,to_date('3333333','j'))
                             , nvl(pegi.al,to_date('3333333','j'))
                             )
        and nvl(aqip.al,to_date('3333333','j'))
                     >= greatest( aeip.dal
                                , nvl(quip.dal,to_date('2222222','j'))
                                , qugi.dal
                                , pegi.dal
                                )
        and (    aqip.equipe    = '%'
             or  aqip.equipe    = aeip.equipe
            )
        and (    aqip.gruppo    = '%'
             or  aqip.gruppo    = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
            )
        and (    aqip.rapporto  = '%'
             or  aqip.rapporto  = (select rapporto
                                     from rapporti_individuali
                                    where ci = pegi.ci
                                  )
            )
        and (    aqip.ruolo     = '%'
             or  aqip.ruolo     = (select ruolo
                                     from posizioni
                                    where codice = pegi.posizione
                              )
             and (    aqip.ruolo     != 'SI'
                  or  aqip.ruolo      = 'SI'
                  and pegi.rilevanza != 'E'
                 )
            )
        and qugi.livello        like aqip.livello
        and qugi.contratto      like aqip.contratto
        and qugi.codice         like aqip.qualifica
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
                    and peg2.ci = decode(aqip.mesi,0,0,pegi.ci)
                )
            )
             and  aeip.gruppo    = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
             and aeip.settore   = 0
             and aeip.sede      = 0
             and not exists
                (select 'x'
                   from attribuzione_equipe_incentivo
                  where gruppo  = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
                    and settore = pegi.settore
                    and sede    = nvl(pegi.sede,0)
                )
        and quip.numero (+)     =pegi.qualifica
        and quip.dal (+)       <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(quip.dal,to_date('2222222','j'))
                               <= least( nvl(qugi.al,to_date('3333333','j'))
                                       , nvl(pegi.al,to_date('3333333','j'))
                                       )
        and nvl(quip.al,to_date('3333333','j'))
                               >= greatest( qugi.dal
                                           , pegi.dal
                                          )
        and qugi.numero         = pegi.qualifica
        and qugi.dal           <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(qugi.al,to_date('3333333','j'))
                               >= pegi.dal
        and pegi.ci             = d_ci
        and nvl(pegi.al,to_date('3333333','j'))
                               >= d_coni
        and asip.progetto       = d_progetto
        and asip.ci             = pegi.ci
        and asip.dal           <= least(nvl(aqip.al,to_date('3333333','j'))
                                       ,nvl(aeip.al,to_date('3333333','j'))
                                       ,nvl(quip.al,to_date('3333333','j'))
                                       ,nvl(qugi.al,to_date('3333333','j'))
                                       ,nvl(pegi.al,to_date('3333333','j'))
                                       )
        and nvl(asip.al,to_date('3333333','j'))
                               >= greatest(aqip.dal
                                          ,aeip.dal
                                          ,quip.dal
                                          ,qugi.dal
                                          ,pegi.dal
                                          )
union
     select
      greatest( aqip.dal
              , aeip.dal
              , nvl(quip.dal,to_date('2222222','j'))
              , qugi.dal
              , pegi.dal
              )
    , decode( least( nvl(aqip.al,to_date('3333333','j'))
                   , nvl(aeip.al,to_date('3333333','j'))
                   , nvl(quip.al,to_date('3333333','j'))
                   , nvl(qugi.al,to_date('3333333','j'))
                   , nvl(pegi.al,to_date('3333333','j'))
                   )
              , to_date('3333333','j'), to_date(null)
              , least( nvl(aqip.al,to_date('3333333','j'))
                     , nvl(aeip.al,to_date('3333333','j'))
                     , nvl(quip.al,to_date('3333333','j'))
                     , nvl(qugi.al,to_date('3333333','j'))
                     , nvl(pegi.al,to_date('3333333','j'))
                     )
      )
    , to_number(null)
     FROM
        attribuzione_quote_incentivo   aqip,
        attribuzione_equipe_incentivo  aeip,
        qualifiche_incentivo           quip,
        qualifiche_giuridiche          qugi,
        periodi_servizio_incarico      pegi
      where aqip.progetto = d_progetto
        and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                             , nvl(quip.al,to_date('3333333','j'))
                             , nvl(qugi.al,to_date('3333333','j'))
                             , nvl(pegi.al,to_date('3333333','j'))
                             )
        and nvl(aqip.al,to_date('3333333','j'))
                     >= greatest( aeip.dal
                                , nvl(quip.dal,to_date('2222222','j'))
                                , qugi.dal
                                , pegi.dal
                                )
        and (    aqip.equipe    = '%'
             or  aqip.equipe    = aeip.equipe
            )
        and (    aqip.gruppo    = '%'
             or  aqip.gruppo    = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
            )
        and (    aqip.rapporto  = '%'
             or  aqip.rapporto  = (select rapporto
                                     from rapporti_individuali
                                    where ci = pegi.ci
                                  )
            )
        and (    aqip.ruolo     = '%'
             or  aqip.ruolo     = (select ruolo
                                     from posizioni
                                    where codice = pegi.posizione
                              )
             and (    aqip.ruolo     != 'SI'
                  or  aqip.ruolo      = 'SI'
                  and pegi.rilevanza != 'E'
                 )
            )
        and qugi.livello        like aqip.livello
        and qugi.contratto      like aqip.contratto
        and qugi.codice         like aqip.qualifica
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
                    and peg2.ci = decode(aqip.mesi,0,0,pegi.ci)
                )
            )
             and (aeip.gruppo   = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
             and aeip.settore   = pegi.settore
             and aeip.sede      = nvl(pegi.sede,0)
             and aeip.dal      <= least( nvl(quip.al,to_date('3333333','j'))
                                       , nvl(qugi.al,to_date('3333333','j'))
                                       , nvl(pegi.al,to_date('3333333','j'))
                                       )
             and nvl(aeip.al,to_date('3333333','j'))
                               >= greatest( nvl(quip.dal,to_date('2222222','j'))
                                           ,    qugi.dal
                                           ,    pegi.dal
                                        )
            )
        and quip.numero (+)     = pegi.qualifica
        and quip.dal (+)       <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(quip.dal,to_date('2222222','j'))
                               <= least( nvl(qugi.al,to_date('3333333','j'))
                                       , nvl(pegi.al,to_date('3333333','j'))
                                       )
        and nvl(quip.al,to_date('3333333','j'))
                               >= greatest( qugi.dal
                                           , pegi.dal
                                          )
        and qugi.numero         = pegi.qualifica
        and qugi.dal           <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(qugi.al,to_date('3333333','j'))
                               >= pegi.dal
        and pegi.ci             = d_ci
        and nvl(pegi.al,to_date('3333333','j'))
                               >= d_coni
        and not exists
           (select 1
              from assegnazioni_incentivo asip
             where asip.dal   <= least(nvl(aqip.al,to_date('3333333','j'))
                                      ,nvl(aeip.al,to_date('3333333','j'))
                                      ,nvl(quip.al,to_date('3333333','j'))
                                      ,nvl(qugi.al,to_date('3333333','j'))
                                      ,nvl(pegi.al,to_date('3333333','j'))
                                      )
               and nvl(asip.al,to_date('3333333','j'))
                              >= greatest(aqip.dal
                                         ,aeip.dal
                                         ,quip.dal
                                         ,qugi.dal
                                         ,pegi.dal
                                         )
               and asip.progetto = d_progetto
               and asip.ci       = pegi.ci
           )
union
     select
      greatest( aqip.dal
              , aeip.dal
              , nvl(quip.dal,to_date('2222222','j'))
              , qugi.dal
              , pegi.dal
              )
    , decode( least( nvl(aqip.al,to_date('3333333','j'))
                   , nvl(aeip.al,to_date('3333333','j'))
                   , nvl(quip.al,to_date('3333333','j'))
                   , nvl(qugi.al,to_date('3333333','j'))
                   , nvl(pegi.al,to_date('3333333','j'))
                   )
              , to_date('3333333','j'), to_date(null)
              , least( nvl(aqip.al,to_date('3333333','j'))
                     , nvl(aeip.al,to_date('3333333','j'))
                     , nvl(quip.al,to_date('3333333','j'))
                     , nvl(qugi.al,to_date('3333333','j'))
                     , nvl(pegi.al,to_date('3333333','j'))
                     )
      )
    , to_number(null)
     FROM
        attribuzione_quote_incentivo   aqip,
        attribuzione_equipe_incentivo  aeip,
        qualifiche_incentivo           quip,
        qualifiche_giuridiche          qugi,
        periodi_servizio_incarico      pegi
      where aqip.progetto = d_progetto
        and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                             , nvl(quip.al,to_date('3333333','j'))
                             , nvl(qugi.al,to_date('3333333','j'))
                             , nvl(pegi.al,to_date('3333333','j'))
                             )
        and nvl(aqip.al,to_date('3333333','j'))
                     >= greatest( aeip.dal
                                , nvl(quip.dal,to_date('2222222','j'))
                                , qugi.dal
                                , pegi.dal
                                )
        and (    aqip.equipe    = '%'
             or  aqip.equipe    = aeip.equipe
            )
        and (    aqip.gruppo    = '%'
             or  aqip.gruppo    = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
            )
        and (    aqip.rapporto  = '%'
             or  aqip.rapporto  = (select rapporto
                                     from rapporti_individuali
                                    where ci = pegi.ci
                                  )
            )
        and (    aqip.ruolo     = '%'
             or  aqip.ruolo     = (select ruolo
                                     from posizioni
                                    where codice = pegi.posizione
                              )
             and (    aqip.ruolo     != 'SI'
                  or  aqip.ruolo      = 'SI'
                  and pegi.rilevanza != 'E'
                 )
            )
        and qugi.livello        like aqip.livello
        and qugi.contratto      like aqip.contratto
        and qugi.codice         like aqip.qualifica
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
                    and peg2.ci = decode(aqip.mesi,0,0,pegi.ci)
                )
            )
             and  aeip.gruppo    = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
             and aeip.settore   = 0
             and aeip.sede      = 0
             and not exists
                (select 'x'
                   from attribuzione_equipe_incentivo
                  where gruppo  = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
                    and settore = pegi.settore
                    and sede    = nvl(pegi.sede,0)
                )
        and quip.numero (+)     = pegi.qualifica
        and quip.dal (+)       <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(quip.dal,to_date('2222222','j'))
                               <= least( nvl(qugi.al,to_date('3333333','j'))
                                       , nvl(pegi.al,to_date('3333333','j'))
                                       )
        and nvl(quip.al,to_date('3333333','j'))
                               >= greatest( qugi.dal
                                           , pegi.dal
                                          )
        and qugi.numero         = pegi.qualifica
        and qugi.dal           <= nvl(pegi.al,to_date('3333333','j'))
        and nvl(qugi.al,to_date('3333333','j'))
                               >= pegi.dal
        and pegi.ci             = d_ci
        and nvl(pegi.al,to_date('3333333','j'))
                               >= d_coni
        and not exists
           (select 1
              from assegnazioni_incentivo asip
             where asip.dal   <= least(nvl(aqip.al,to_date('3333333','j'))
                                      ,nvl(aeip.al,to_date('3333333','j'))
                                      ,nvl(quip.al,to_date('3333333','j'))
                                      ,nvl(qugi.al,to_date('3333333','j'))
                                      ,nvl(pegi.al,to_date('3333333','j'))
                                      )
               and nvl(asip.al,to_date('3333333','j'))
                              >= greatest(aqip.dal
                                         ,aeip.dal
                                         ,quip.dal
                                         ,qugi.dal
                                         ,pegi.dal
                                         )
               and asip.progetto = d_progetto
               and asip.ci       = pegi.ci
           )
      order by 1,3
;
BEGIN
                             --  Ciclo per individui da rettificare
  open ragi;
  LOOP
     fetch ragi into d_ci,d_coni;
     exit  when ragi%NOTFOUND;
     BEGIN                      --  Trattamento vecchie assegnazioni
                                --  da rettificare
        update assegnazioni_incentivo
           set data_agg = to_date('3333333','j'),
               utente = 'Aut'
         where nvl(al,to_date('3333333','j')) >= d_coni
           and ci = d_ci
           and progetto in (select progetto from progetti_incentivo
                            where assegnazione ='A')
        ;
      END;
                             --  Ciclo progetti
      open prip;
      LOOP
      fetch prip into d_progetto;
      exit when prip%NOTFOUND;
                             --  Ciclo inserimento Assegnazioni individuali
      open asse;
      fetch asse into d_dal,d_al,d_imp;
      if asse%FOUND then
       LOOP
        fetch asse into d_dal2,d_al2,d_imp2;
        if asse%NOTFOUND
        or nvl(d_imp2,0) <> nvl(d_imp,0)
        or d_dal2 <> nvl(d_al,to_date('3333333','j'))+1 then
         BEGIN          --  Trattamento registrazione assegnazione
                        --  Controllo con assegnazione precedente
            select 'x'
              into D_segnale
              from assegnazioni_incentivo
             where ci       = D_ci
               and progetto = D_progetto
               and dal      = D_dal
               and nvl(al,to_date('3333333','j'))
                            = nvl(D_al,to_date('3333333','j'))
    --         and data_agg = to_date('3333333','j')
            ;
            RAISE TOO_MANY_ROWS;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               update assegnazioni_incentivo
                  set data_agg = p_ini_mes,
                      utente   = 'Aut.'
                where ci       = D_ci
                  and dal      = D_dal
                  and progetto = D_progetto
                  and nvl(al,to_date('3333333','j'))
                               = nvl(D_al,to_date('3333333','j'))
               ;
            WHEN NO_DATA_FOUND THEN
               BEGIN          --  Registra assegnazione memorizzata
                  insert into assegnazioni_incentivo
                     (progetto,ci,dal,al,note,utente,data_agg,importo)
                  values
                     ( D_progetto
                      ,D_ci
                      ,D_dal
                      ,D_al
                      ,null
                      ,'Aut'
                      ,p_ini_mes
                      ,D_imp
                     )
                  ;
               END;
               BEGIN
                 insert into rapporti_incentivo
                       (progetto,scp,ci)
                 select  D_progetto
                        ,apip.scp
                        ,D_ci
                   from  applicazioni_incentivo apip
                  where  apip.progetto = D_progetto
                    and  apip.stato    != 'C'
                    and  not exists (select 'x'
                                       from rapporti_incentivo raip
                                      where raip.progetto  = D_progetto
                                        and raip.scp       = apip.scp
                                        and raip.ci        = D_ci
                                    )
                 ;
               END;
         END;
         if asse%NOTFOUND then
            exit;
         else
            d_imp      := d_imp2;
            d_dal      := d_dal2;
            d_al       := d_al2;
         end if;
       else
         d_al := d_al2;
       end if;
      END LOOP;
     end if;
     close asse;
     END LOOP;
     close prip;
-- Termina il trattamento dell'individuo
BEGIN                        --  Eliminazione date di rettifica giuridica
                             --  e passaggio nella d_rett
   update rapporti_incentivo rain set d_rett =
                              (select least (nvl(rain.d_rett,
                                                 to_date('3333333','j')
                                                )
                                            , d_coni
                                            )
                                from rapporti_giuridici
                               where ci = rain.ci
                                 and nvl(d_coni,to_date('3333333','j')) <=
                                                        p_fin_mes
                              )
    where ci = d_ci
   ;
   update rapporti_giuridici
      set d_coni = null
    where nvl(d_coni,to_date('3333333','j')) <= p_fin_mes
      and ci = d_ci
   ;
END;
commit;
  END LOOP;
  close ragi;
END;
--
-- Fine operazioni di Funzione
--
BEGIN         -- Aggiornamento stato allineamento giuridico
   update riferimento_incentivo
      set stato_pgm = 'SI'
   ;
END;
end;
end;
end;
/

