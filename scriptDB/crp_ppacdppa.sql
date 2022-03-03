CREATE OR REPLACE PACKAGE ppacdppa IS
/******************************************************************************
 NOME:          PPACDPPA
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
  PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY ppacdppa IS
	form_trigger_failure	exception;
	W_UTENTE	VARCHAR2(10);
	W_AMBIENTE	VARCHAR2(10);
	W_ENTE		VARCHAR2(10);
	W_LINGUA	VARCHAR2(1);
	W_PRENOTAZIONE	NUMBER(10);
	errore		varchar2(6);
	P_data		date;
-- Intervallo tra l'ultimo Incarico e la Fine del Servizio (segmento = f)
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE INSERT_5 IS
BEGIN
  insert  into DEPOSITO_PERIODI_PRESENZA
  ( prenotazione
  , data
  , ci
  , dal
  , al
  , ufficio
  , badge
  , sede
  , cod_sede
  , seq_sede
  , cartellino
  , gestione
  , matricola
  , gg_set
  , min_gg
  , ore_min_gg
  , minuti_min_gg
  , cdc
  , fattore_produttivo
  , assistenza
  , automatismo
  , rilevanza
  , inizio
  , segmento
  , evento
  , seq_evento
  , posizione
  , seq_posizione
  , ruolo
  , seq_ruolo
  , figura
  , cod_figura
  , seq_figura
  , attivita
  , seq_attivita
  , contratto
  , seq_contratto
  , qualifica
  , cod_qualifica
  , seq_qualifica
  , tipo_rapporto
  , ore
  , settore
  , cod_settore
  , seq_settore
  , funzionale
  , seq_funzionale
  , classe_rapporto
  , seq_classe_rapporto
  )
  select    w_prenotazione
  , p_data
  , rapa.ci
  , greatest( peia.al+1  /* non puo` essere null */
    , rapa.dal
    , cost.dal
    , qugi.dal
    , figi.dal
    )
  , decode  (least ( nvl(pese.al,to_date('3333333','j'))
   , nvl(rapa.al,to_date('3333333','j'))
   , nvl(cost.al,to_date('3333333','j'))
   , nvl(qugi.al,to_date('3333333','j'))
   , nvl(figi.al,to_date('3333333','j'))
   ),to_date('3333333','j'),null,
 least ( nvl(pese.al,to_date('3333333','j'))
   , nvl(rapa.al,to_date('3333333','j'))
   , nvl(cost.al,to_date('3333333','j'))
   , nvl(qugi.al,to_date('3333333','j'))
   , nvl(figi.al,to_date('3333333','j'))
   )
    )
  , rapa.ufficio
  , rapa.badge
  , nvl(rapa.sede,pese.sede)
  , sedi.codice
  , sedi.sequenza
  , rapa.cartellino
  , sett.gestione
  , rare.matricola
  , nvl(rapa.gg_set,trunc(cost.ore_lavoro/cost.ore_gg))
  , nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
   +round((cost.ore_gg
  * nvl(pese.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
   )
  , trunc(
    nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
   +round((cost.ore_gg
  * nvl(pese.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
   )
    / 60)
  , nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
   +round((cost.ore_gg
  * nvl(pese.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
   )
    -
    trunc(
    nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
   +round((cost.ore_gg
  * nvl(pese.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pese.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
   )
    / 60) * 60
  , nvl(rapa.cdc,rifu.cdc)
  , nvl(rapa.fattore_produttivo
   ,decode(pese.tipo_rapporto,'TD',qual.fattore_td
  ,qual.fattore
  )
   )
  , nvl(rapa.assistenza,trpr.assistenza)
  , rapa.automatismo
  , pese.rilevanza
  , pese.dal
  , 'f'
  , pese.evento
  , evgi.sequenza
  , pese.posizione
  , posi.sequenza
  , qugi.ruolo
  , ruol.sequenza
  , pese.figura
  , figi.codice
  , figu.sequenza
  , pese.attivita
  , atti.sequenza
  , qugi.contratto
  , cont.sequenza
  , pese.qualifica
  , qugi.codice
  , qual.sequenza
  , pese.tipo_rapporto
  , nvl(pese.ore,cost.ore_lavoro)
  , pese.settore
  , sett.codice
  , sett.sequenza
  , rifu.funzionale
  , clfu.sequenza
  , rain.rapporto
  , clra.sequenza
  from settori    sett
 , sedi   sedi
 , ripartizioni_funzionali    rifu
 , contratti  cont
 , contratti_storici  cost
 , qualifiche_giuridiche  qugi
 , qualifiche qual
 , trattamenti_previdenziali  trpr
 , rapporti_retributivi   rare
 , rapporti_individuali   rain
 , classi_rapporto    clra
 , eventi_giuridici   evgi
 , posizioni  posi
 , ruoli  ruol
 , figure figu
 , figure_giuridiche  figi
 , attivita   atti
 , classificazioni_funzionali clfu
 , periodi_giuridici  peia
 , periodi_giuridici  pese
 , rapporti_presenza  rapa
 where pese.rilevanza = 'S'
   and peia.rilevanza = 'E'
   and peia.ci    = pese.ci
   and p_data  between peia.dal
    and nvl(peia.al,to_date('3333333','j'))
   and not exists
   (select 'x'
  from periodi_giuridici pein
 where pein.ci    = pese.ci
   and pein.rilevanza = 'E'
   and p_data
    between pein.dal
    and nvl(pein.al,to_date('3333333','j'))
   and pein.dal   > peia.dal
   )
   and nvl(peia.al,to_date('3333333','j'))
 != nvl(pese.al,to_date('3333333','j'))
   and sett.numero    = pese.settore
   and sedi.numero (+)    = pese.sede
   and rifu.settore   = pese.settore
   and rifu.sede  = nvl(pese.sede,0)
   and cont.codice    = qugi.contratto
   and cost.contratto = qugi.contratto
   and qugi.numero    = qual.numero
   and qual.numero    = pese.qualifica
   and pese.figura    = figi.numero
   and pese.figura    = figu.numero
   and atti.codice (+)    = pese.attivita
   and ruol.codice    = qugi.ruolo
   and evgi.codice    = pese.evento
   and posi.codice    = pese.posizione
   and clfu.codice (+)    = rifu.funzionale
   and trpr.codice (+)    = rare.trattamento
   and rare.ci (+)    = pese.ci
   and pese.ci    = rapa.ci
   and rain.ci    = rapa.ci
   and clra.codice    = rain.rapporto
   and p_data  between greatest(peia.al+1
    ,rapa.dal
    ,cost.dal
    ,qugi.dal
    ,figi.dal
    )
    and least(nvl(pese.al,to_date('3333333','j'))
 ,nvl(rapa.al,to_date('3333333','j'))
 ,nvl(cost.al,to_date('3333333','j'))
 ,nvl(qugi.al,to_date('3333333','j'))
 ,nvl(figi.al,to_date('3333333','j'))
 )
  ;
EXCEPTION
  WHEN OTHERS THEN
    RAISE FORM_TRIGGER_FAILURE;
END;
-- Intervalli tra gli Incarichi nel relativo Servizio (segmento = c)
PROCEDURE INSERT_6 IS
BEGIN
  insert  into DEPOSITO_PERIODI_PRESENZA
    ( prenotazione
    , data
    , ci
    , dal
    , al
    , ufficio
    , badge
    , sede
    , cod_sede
    , seq_sede
    , cartellino
    , gestione
    , matricola
    , gg_set
    , min_gg
    , ore_min_gg
    , minuti_min_gg
    , cdc
    , fattore_produttivo
    , assistenza
    , automatismo
    , rilevanza
    , inizio
    , segmento
    , evento
    , seq_evento
    , posizione
    , seq_posizione
    , ruolo
    , seq_ruolo
    , figura
    , cod_figura
    , seq_figura
    , attivita
    , seq_attivita
    , contratto
    , seq_contratto
    , qualifica
    , cod_qualifica
    , seq_qualifica
    , tipo_rapporto
    , ore
    , settore
    , cod_settore
    , seq_settore
    , funzionale
    , seq_funzionale
    , classe_rapporto
    , seq_classe_rapporto
    )
  select w_prenotazione
    , p_data
    , rapa.ci
    , greatest( peia.al+1, rapa.dal, cost.dal, qugi.dal, figi.dal)
    , least ( peis.dal-1
      , nvl(rapa.al,to_date('3333333','j'))
      , nvl(cost.al,to_date('3333333','j'))
      , nvl(qugi.al,to_date('3333333','j'))
      , nvl(figi.al,to_date('3333333','j'))
      )
    , rapa.ufficio
    , rapa.badge
    , nvl(rapa.sede,pese.sede)
    , sedi.codice
    , sedi.sequenza
    , rapa.cartellino
    , sett.gestione
    , rare.matricola
    , nvl(rapa.gg_set,trunc(cost.ore_lavoro/cost.ore_gg))
    , nvl(rapa.min_gg,trunc(cost.ore_gg
         * nvl(pese.ore,cost.ore_lavoro)
         / cost.ore_lavoro
         ) * 60
         +round((cost.ore_gg
          * nvl(pese.ore,cost.ore_lavoro)
          / cost.ore_lavoro
          - trunc(cost.ore_gg
           * nvl(pese.ore,cost.ore_lavoro)
           / cost.ore_lavoro
           )
          ) * 60
         )
      )
    , trunc(
   nvl(rapa.min_gg,trunc(cost.ore_gg
         * nvl(pese.ore,cost.ore_lavoro)
         / cost.ore_lavoro
         ) * 60
         +round((cost.ore_gg
          * nvl(pese.ore,cost.ore_lavoro)
          / cost.ore_lavoro
          - trunc(cost.ore_gg
           * nvl(pese.ore,cost.ore_lavoro)
           / cost.ore_lavoro
           )
          ) * 60
         )
      )
   / 60)
    , nvl(rapa.min_gg,trunc(cost.ore_gg
         * nvl(pese.ore,cost.ore_lavoro)
         / cost.ore_lavoro
         ) * 60
         +round((cost.ore_gg
          * nvl(pese.ore,cost.ore_lavoro)
          / cost.ore_lavoro
          - trunc(cost.ore_gg
           * nvl(pese.ore,cost.ore_lavoro)
           / cost.ore_lavoro
           )
          ) * 60
         )
      )
   -
   trunc(
   nvl(rapa.min_gg,trunc(cost.ore_gg
         * nvl(pese.ore,cost.ore_lavoro)
         / cost.ore_lavoro
         ) * 60
         +round((cost.ore_gg
          * nvl(pese.ore,cost.ore_lavoro)
          / cost.ore_lavoro
          - trunc(cost.ore_gg
           * nvl(pese.ore,cost.ore_lavoro)
           / cost.ore_lavoro
           )
          ) * 60
         )
      )
   / 60) * 60
    , nvl(rapa.cdc,rifu.cdc)
    , nvl(rapa.fattore_produttivo
      ,decode(pese.tipo_rapporto,'TD',qual.fattore_td
             ,qual.fattore
       )
      )
    , nvl(rapa.assistenza,trpr.assistenza)
    , rapa.automatismo
    , pese.rilevanza
    , pese.dal
    , 'c'
    , pese.evento
    , evgi.sequenza
    , pese.posizione
    , posi.sequenza
    , qugi.ruolo
    , ruol.sequenza
    , pese.figura
    , figi.codice
    , figu.sequenza
    , pese.attivita
    , atti.sequenza
    , qugi.contratto
    , cont.sequenza
    , pese.qualifica
    , qugi.codice
    , qual.sequenza
    , pese.tipo_rapporto
    , nvl(pese.ore,cost.ore_lavoro)
    , pese.settore
    , sett.codice
    , sett.sequenza
    , rifu.funzionale
    , clfu.sequenza
    , rain.rapporto
    , clra.sequenza
  from settori     sett
  , sedi        sedi
  , ripartizioni_funzionali rifu
  , contratti      cont
  , contratti_storici    cost
  , qualifiche_giuridiche   qugi
  , qualifiche     qual
  , trattamenti_previdenziali  trpr
  , rapporti_retributivi    rare
  , rapporti_individuali    rain
  , classi_rapporto   clra
  , eventi_giuridici     evgi
  , posizioni      posi
  , ruoli       ruol
  , figure      figu
  , figure_giuridiche    figi
  , attivita       atti
  , classificazioni_funzionali clfu
  , periodi_giuridici    peis
  , periodi_giuridici    peia
  , periodi_giuridici    pese
  , rapporti_presenza    rapa
 where pese.rilevanza   = 'S'
   and peia.rilevanza   = 'E'
   and peia.ci    = pese.ci
   and p_data   between peia.dal
       and nvl(peia.al,to_date('3333333','j'))
   and nvl(peia.al,to_date('3333333','j'))
        != nvl(pese.al,to_date('3333333','j'))
   and peis.rilevanza   = 'E'
   and peis.ci    = peia.ci
   and peis.dal      =
    (select min(pein.dal)    from periodi_giuridici pein
          where pein.ci  = peia.ci
         and pein.rilevanza = 'E'
         and p_data
             between pein.dal and
          nvl(pein.al
             ,to_date('3333333','j'))
         and pein.dal    > peia.dal
    )
   and peia.al+1    != peis.dal
   and sett.numero   = pese.settore
   and sedi.numero (+)  = pese.sede
   and rifu.settore     = pese.settore
   and rifu.sede     = nvl(pese.sede,0)
   and cont.codice   = qugi.contratto
   and cost.contratto   = qugi.contratto
   and qugi.numero   = qual.numero
   and qual.numero   = pese.qualifica
   and pese.figura   = figi.numero
   and pese.figura   = figu.numero
   and atti.codice (+)  = pese.attivita
   and ruol.codice   = qugi.ruolo
   and evgi.codice   = pese.evento
   and posi.codice   = pese.posizione
   and clfu.codice (+)  = rifu.funzionale
   and trpr.codice (+)  = rare.trattamento
   and rare.ci (+)   = pese.ci
   and pese.ci    = rapa.ci
   and rain.ci    = rapa.ci
   and clra.codice   = rain.rapporto
   and p_data   between greatest(peia.al+1
          ,rapa.dal
          ,cost.dal
          ,qugi.dal
          ,figi.dal
          )
       and least(peis.dal-1
          ,nvl(rapa.al,to_date('3333333','j'))
          ,nvl(cost.al,to_date('3333333','j'))
          ,nvl(qugi.al,to_date('3333333','j'))
          ,nvl(figi.al,to_date('3333333','j'))
          )
  ;
EXCEPTION
  WHEN OTHERS THEN
 RAISE FORM_TRIGGER_FAILURE;
END;
PROCEDURE DELETE_TAB IS
  BEGIN
    DELETE FROM DEPOSITO_PERIODI_PRESENZA
     WHERE PRENOTAZIONE = W_PRENOTAZIONE;
  EXCEPTION
    WHEN OTHERS THEN
	 RAISE FORM_TRIGGER_FAILURE;
	END;
  PROCEDURE INSERT_1 IS
  BEGIN
    INSERT  INTO DEPOSITO_PERIODI_PRESENZA
    ( PRENOTAZIONE
    , DATA
    , CI
    , DAL
    , AL
    , UFFICIO
    , BADGE
    , SEDE
    , COD_SEDE
    , SEQ_SEDE
    , CARTELLINO
    , GESTIONE
    , MATRICOLA
    , GG_SET
    , MIN_GG
    , ORE_MIN_GG
    , MINUTI_MIN_GG
    , CDC
    , FATTORE_PRODUTTIVO
    , ASSISTENZA
    , AUTOMATISMO
    , RILEVANZA
    , INIZIO
    , SEGMENTO
    , EVENTO
    , SEQ_EVENTO
    , POSIZIONE
    , SEQ_POSIZIONE
    , RUOLO
    , SEQ_RUOLO
    , FIGURA
    , COD_FIGURA
    , SEQ_FIGURA
    , ATTIVITA
    , SEQ_ATTIVITA
    , CONTRATTO
    , SEQ_CONTRATTO
    , QUALIFICA
    , COD_QUALIFICA
    , SEQ_QUALIFICA
    , TIPO_RAPPORTO
    , ORE
    , SETTORE
    , COD_SETTORE
    , SEQ_SETTORE
    , FUNZIONALE
    , SEQ_FUNZIONALE
    , CLASSE_RAPPORTO
    , SEQ_CLASSE_RAPPORTO
    )
    SELECT    W_PRENOTAZIONE
    , P_DATA
    , RAPA.CI
    , RAPA.DAL
    , RAPA.AL
    , RAPA.UFFICIO
    , RAPA.BADGE
    , RAPA.SEDE
    , SEDI.CODICE
    , SEDI.SEQUENZA
    , RAPA.CARTELLINO
    , NULL       /* GESTIONE    */
    , RARE.MATRICOLA
    , RAPA.GG_SET
    , RAPA.MIN_GG
    , TRUNC(RAPA.MIN_GG / 60)
    , RAPA.MIN_GG - TRUNC(RAPA.MIN_GG / 60) * 60
    , RAPA.CDC
    , RAPA.FATTORE_PRODUTTIVO
    , NVL(RAPA.ASSISTENZA,TRPR.ASSISTENZA)
    , RAPA.AUTOMATISMO
    , NULL       /* RILEVANZA   */
    , NULL       /* DAL PERIODO GIUR.   */
    , NULL       /* SEGMENTO    */
    , NULL       /* EVENTO      */
    , NULL       /* SEQ. EVENTO     */
    , NULL       /* POSIZIONE   */
    , NULL       /* SEQ. POSIZIONE  */
    , NULL       /* RUOLO   */
    , NULL       /* SEQ. RUOLO  */
    , NULL       /* FIGURA      */
    , NULL       /* COD. FIGURA     */
    , NULL       /* SEQ. FIGURA     */
    , NULL       /* ATTIVITA`   */
    , NULL       /* SEQ ATTIVITA`   */
    , NULL       /* CONTRATTO   */
    , NULL       /* SEQ. CONTRATTO  */
    , NULL       /* QUALIFICA   */
    , NULL       /* COD. QUALIFICA  */
    , NULL       /* SEQ. QUALIFICA  */
    , NULL       /* TIPO RAPPORTO   */
    , NULL       /* ORE     */
    , NULL       /* SETTORE     */
    , NULL       /* COD. SETTORE    */
    , NULL       /* SEQ. SETTORE    */
    , NULL       /* CLASS. FUNZIONALE   */
    , NULL       /* SEQ. CL. FUNZIONALE */
    , RAIN.RAPPORTO
    , CLRA.SEQUENZA
     FROM TRATTAMENTI_PREVIDENZIALI TRPR
    , RAPPORTI_RETRIBUTIVI  RARE
    , SEDI      SEDI
    , RAPPORTI_INDIVIDUALI  RAIN
    , CLASSI_RAPPORTO   CLRA
    , RAPPORTI_PRESENZA     RAPA
    WHERE NOT EXISTS
      (SELECT 'X'
     FROM PERIODI_GIURIDICI
    WHERE CI    = RAPA.CI
      AND RILEVANZA = 'S'
      )
      AND SEDI.NUMERO (+)   = RAPA.SEDE
      AND TRPR.CODICE (+)   = RARE.TRATTAMENTO
      AND RARE.CI (+)   = RAPA.CI
      AND RAIN.CI   = RAPA.CI
      AND CLRA.CODICE   = RAIN.RAPPORTO
      AND P_DATA BETWEEN RAPA.DAL
          AND NVL(RAPA.AL,TO_DATE('3333333','J'))
    ;
  EXCEPTION
    WHEN OTHERS THEN
 /*
     ALERT_MESSAGE_STOP(SQLERRM);
  RAISE FORM_TRIGGER_FAILURE;
*/
		raise;
  END;
-- PERIODI DI SERVIZIO SENZA INCARICHI (SEGMENTO = U)
  PROCEDURE INSERT_2 IS
  BEGIN
    INSERT  INTO DEPOSITO_PERIODI_PRESENZA
    ( PRENOTAZIONE
    , DATA
    , CI
    , DAL
    , AL
    , UFFICIO
    , BADGE
    , SEDE
    , COD_SEDE
    , SEQ_SEDE
    , CARTELLINO
    , GESTIONE
    , MATRICOLA
    , GG_SET
    , MIN_GG
    , ORE_MIN_GG
    , MINUTI_MIN_GG
    , CDC
    , FATTORE_PRODUTTIVO
    , ASSISTENZA
    , AUTOMATISMO
    , RILEVANZA
    , INIZIO
    , SEGMENTO
    , EVENTO
    , SEQ_EVENTO
    , POSIZIONE
    , SEQ_POSIZIONE
    , RUOLO
    , SEQ_RUOLO
    , FIGURA
    , COD_FIGURA
    , SEQ_FIGURA
    , ATTIVITA
    , SEQ_ATTIVITA
    , CONTRATTO
    , SEQ_CONTRATTO
    , QUALIFICA
    , COD_QUALIFICA
    , SEQ_QUALIFICA
    , TIPO_RAPPORTO
    , ORE
    , SETTORE
    , COD_SETTORE
    , SEQ_SETTORE
    , FUNZIONALE
    , SEQ_FUNZIONALE
    , CLASSE_RAPPORTO
    , SEQ_CLASSE_RAPPORTO
    )
    SELECT    W_PRENOTAZIONE
    , P_DATA
    , RAPA.CI
    , GREATEST( PESE.DAL
      , RAPA.DAL
      , COST.DAL
      , QUGI.DAL
      , FIGI.DAL
      )
    , DECODE  (LEAST ( NVL(PESE.AL,TO_DATE('3333333','J'))
         , NVL(RAPA.AL,TO_DATE('3333333','J'))
         , NVL(COST.AL,TO_DATE('3333333','J'))
         , NVL(QUGI.AL,TO_DATE('3333333','J'))
         , NVL(FIGI.AL,TO_DATE('3333333','J'))
         ),TO_DATE('3333333','J'),NULL,
       LEAST ( NVL(PESE.AL,TO_DATE('3333333','J'))
         , NVL(RAPA.AL,TO_DATE('3333333','J'))
         , NVL(COST.AL,TO_DATE('3333333','J'))
         , NVL(QUGI.AL,TO_DATE('3333333','J'))
         , NVL(FIGI.AL,TO_DATE('3333333','J'))
         )
      )
    , RAPA.UFFICIO
    , RAPA.BADGE
    , NVL(RAPA.SEDE,PESE.SEDE)
    , SEDI.CODICE
    , SEDI.SEQUENZA
    , RAPA.CARTELLINO
    , SETT.GESTIONE
    , RARE.MATRICOLA
    , NVL(RAPA.GG_SET,TRUNC(COST.ORE_LAVORO/COST.ORE_GG))
    , NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
    , TRUNC(
      NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
      / 60)
    , NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
      -
      TRUNC(
      NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
      / 60) * 60
    , NVL(RAPA.CDC,RIFU.CDC)
    , NVL(RAPA.FATTORE_PRODUTTIVO
     ,DECODE(PESE.TIPO_RAPPORTO,'TD',QUAL.FATTORE_TD
            ,QUAL.FATTORE
        )
     )
    , NVL(RAPA.ASSISTENZA,TRPR.ASSISTENZA)
    , RAPA.AUTOMATISMO
    , PESE.RILEVANZA
    , PESE.DAL
    , 'U'
    , PESE.EVENTO
    , EVGI.SEQUENZA
    , PESE.POSIZIONE
    , POSI.SEQUENZA
    , QUGI.RUOLO
    , RUOL.SEQUENZA
    , PESE.FIGURA
    , FIGI.CODICE
    , FIGU.SEQUENZA
    , PESE.ATTIVITA
    , ATTI.SEQUENZA
    , QUGI.CONTRATTO
    , CONT.SEQUENZA
    , PESE.QUALIFICA
    , QUGI.CODICE
    , QUAL.SEQUENZA
    , PESE.TIPO_RAPPORTO
    , NVL(PESE.ORE,COST.ORE_LAVORO)
    , PESE.SETTORE
    , SETT.CODICE
    , SETT.SEQUENZA
    , RIFU.FUNZIONALE
    , CLFU.SEQUENZA
    , RAIN.RAPPORTO
    , CLRA.SEQUENZA
    FROM SETTORI    SETT
   , SEDI       SEDI
   , RIPARTIZIONI_FUNZIONALI    RIFU
   , CONTRATTI      CONT
   , CONTRATTI_STORICI  COST
   , QUALIFICHE_GIURIDICHE  QUGI
   , QUALIFICHE     QUAL
   , TRATTAMENTI_PREVIDENZIALI  TRPR
   , RAPPORTI_RETRIBUTIVI   RARE
   , RAPPORTI_INDIVIDUALI   RAIN
   , CLASSI_RAPPORTO    CLRA
   , EVENTI_GIURIDICI   EVGI
   , POSIZIONI      POSI
   , RUOLI      RUOL
   , FIGURE     FIGU
   , FIGURE_GIURIDICHE  FIGI
   , ATTIVITA       ATTI
   , CLASSIFICAZIONI_FUNZIONALI CLFU
   , PERIODI_GIURIDICI  PESE
   , RAPPORTI_PRESENZA  RAPA
   WHERE PESE.RILEVANZA     = 'S'
     AND NOT EXISTS
     (SELECT 'X'
    FROM PERIODI_GIURIDICI PEIN
   WHERE PEIN.CI    = PESE.CI
     AND PEIN.RILEVANZA = 'E'
     AND P_DATA
      BETWEEN PEIN.DAL
          AND NVL(PEIN.AL,TO_DATE('3333333','J'))
     )
     AND SETT.NUMERO    = PESE.SETTORE
     AND SEDI.NUMERO (+)    = PESE.SEDE
     AND RIFU.SETTORE   = PESE.SETTORE
     AND RIFU.SEDE      = NVL(PESE.SEDE,0)
     AND CONT.CODICE    = QUGI.CONTRATTO
     AND COST.CONTRATTO     = QUGI.CONTRATTO
     AND QUGI.NUMERO    = QUAL.NUMERO
     AND QUAL.NUMERO    = PESE.QUALIFICA
     AND PESE.FIGURA    = FIGI.NUMERO
     AND PESE.FIGURA    = FIGU.NUMERO
     AND ATTI.CODICE (+)    = PESE.ATTIVITA
     AND RUOL.CODICE    = QUGI.RUOLO
     AND EVGI.CODICE    = PESE.EVENTO
     AND POSI.CODICE    = PESE.POSIZIONE
     AND CLFU.CODICE (+)    = RIFU.FUNZIONALE
     AND TRPR.CODICE (+)    = RARE.TRATTAMENTO
     AND RARE.CI (+)    = PESE.CI
     AND PESE.CI    = RAPA.CI
     AND RAIN.CI    = RAPA.CI
     AND CLRA.CODICE    = RAIN.RAPPORTO
     AND P_DATA  BETWEEN GREATEST(PESE.DAL
          ,RAPA.DAL
          ,COST.DAL
          ,QUGI.DAL
          ,FIGI.DAL
          )
          AND LEAST(NVL(PESE.AL,TO_DATE('3333333','J'))
           ,NVL(RAPA.AL,TO_DATE('3333333','J'))
           ,NVL(COST.AL,TO_DATE('3333333','J'))
           ,NVL(QUGI.AL,TO_DATE('3333333','J'))
           ,NVL(FIGI.AL,TO_DATE('3333333','J'))
           )
    ;
  EXCEPTION
    WHEN OTHERS THEN
/*
  ALERT_MESSAGE_STOP(SQLERRM);
  RAISE FORM_TRIGGER_FAILURE;
*/
		RAISE;
  END;
-- INTERVALLO TRA INIZIO DEL SERVIZIO E PRIMO INCARICO (SEGMENTO = I)
  PROCEDURE INSERT_3 IS
  BEGIN
    INSERT  INTO DEPOSITO_PERIODI_PRESENZA
    ( PRENOTAZIONE
    , DATA
    , CI
    , DAL
    , AL
    , UFFICIO
    , BADGE
    , SEDE
    , COD_SEDE
    , SEQ_SEDE
    , CARTELLINO
    , GESTIONE
    , MATRICOLA
    , GG_SET
    , MIN_GG
    , ORE_MIN_GG
    , MINUTI_MIN_GG
    , CDC
    , FATTORE_PRODUTTIVO
    , ASSISTENZA
    , AUTOMATISMO
    , RILEVANZA
    , INIZIO
    , SEGMENTO
    , EVENTO
    , SEQ_EVENTO
    , POSIZIONE
    , SEQ_POSIZIONE
    , RUOLO
    , SEQ_RUOLO
    , FIGURA
    , COD_FIGURA
    , SEQ_FIGURA
    , ATTIVITA
    , SEQ_ATTIVITA
    , CONTRATTO
    , SEQ_CONTRATTO
    , QUALIFICA
    , COD_QUALIFICA
    , SEQ_QUALIFICA
    , TIPO_RAPPORTO
    , ORE
    , SETTORE
    , COD_SETTORE
    , SEQ_SETTORE
    , FUNZIONALE
    , SEQ_FUNZIONALE
    , CLASSE_RAPPORTO
    , SEQ_CLASSE_RAPPORTO
    )
    SELECT    w_PRENOTAZIONE
    , P_DATA
    , RAPA.CI
    , GREATEST( PESE.DAL
      , RAPA.DAL
      , COST.DAL
      , QUGI.DAL
      , FIGI.DAL
      )
    , LEAST ( PEIN.DAL-1
        , NVL(RAPA.AL,TO_DATE('3333333','J'))
        , NVL(COST.AL,TO_DATE('3333333','J'))
        , NVL(QUGI.AL,TO_DATE('3333333','J'))
        , NVL(FIGI.AL,TO_DATE('3333333','J'))
        )
    , RAPA.UFFICIO
    , RAPA.BADGE
    , NVL(RAPA.SEDE,PESE.SEDE)
    , SEDI.CODICE
    , SEDI.SEQUENZA
    , RAPA.CARTELLINO
    , SETT.GESTIONE
    , RARE.MATRICOLA
    , NVL(RAPA.GG_SET,TRUNC(COST.ORE_LAVORO/COST.ORE_GG))
    , NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
    , TRUNC(
      NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
      / 60)
    , NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
      -
      TRUNC(
      NVL(RAPA.MIN_GG,TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           ) * 60
         +ROUND((COST.ORE_GG
        * NVL(PESE.ORE,COST.ORE_LAVORO)
        / COST.ORE_LAVORO
        - TRUNC(COST.ORE_GG
           * NVL(PESE.ORE,COST.ORE_LAVORO)
           / COST.ORE_LAVORO
           )
        ) * 60
           )
     )
      / 60) * 60
    , NVL(RAPA.CDC,RIFU.CDC)
    , NVL(RAPA.FATTORE_PRODUTTIVO
     ,DECODE(PESE.TIPO_RAPPORTO,'TD',QUAL.FATTORE_TD
            ,QUAL.FATTORE
        )
     )
    , NVL(RAPA.ASSISTENZA,TRPR.ASSISTENZA)
    , RAPA.AUTOMATISMO
    , PESE.RILEVANZA
    , PESE.DAL
    , 'I'
    , PESE.EVENTO
    , EVGI.SEQUENZA
    , PESE.POSIZIONE
    , POSI.SEQUENZA
    , QUGI.RUOLO
    , RUOL.SEQUENZA
    , PESE.FIGURA
    , FIGI.CODICE
    , FIGU.SEQUENZA
    , PESE.ATTIVITA
    , ATTI.SEQUENZA
    , QUGI.CONTRATTO
    , CONT.SEQUENZA
    , PESE.QUALIFICA
    , QUGI.CODICE
    , QUAL.SEQUENZA
    , PESE.TIPO_RAPPORTO
    , NVL(PESE.ORE,COST.ORE_LAVORO)
    , PESE.SETTORE
    , SETT.CODICE
    , SETT.SEQUENZA
    , RIFU.FUNZIONALE
    , CLFU.SEQUENZA
    , RAIN.RAPPORTO
    , CLRA.SEQUENZA
    FROM SETTORI    SETT
   , SEDI       SEDI
   , RIPARTIZIONI_FUNZIONALI    RIFU
   , CONTRATTI      CONT
   , CONTRATTI_STORICI  COST
   , QUALIFICHE_GIURIDICHE  QUGI
   , QUALIFICHE     QUAL
   , TRATTAMENTI_PREVIDENZIALI  TRPR
   , RAPPORTI_RETRIBUTIVI   RARE
   , RAPPORTI_INDIVIDUALI   RAIN
   , CLASSI_RAPPORTO    CLRA
   , EVENTI_GIURIDICI   EVGI
   , POSIZIONI      POSI
   , RUOLI      RUOL
   , FIGURE     FIGU
   , FIGURE_GIURIDICHE  FIGI
   , ATTIVITA       ATTI
   , CLASSIFICAZIONI_FUNZIONALI CLFU
   , PERIODI_GIURIDICI  PESE
   , PERIODI_GIURIDICI  PEIN
   , RAPPORTI_PRESENZA  RAPA
   WHERE PESE.RILEVANZA     = 'S'
     AND PEIN.CI    = PESE.CI
     AND PEIN.RILEVANZA     = 'E'
     AND PEIN.DAL   = (SELECT MIN(PEI2.DAL)
         FROM PERIODI_GIURIDICI PEI2
        WHERE PEI2.CI     = PEIN.CI
          AND PEI2.RILEVANZA  = PEIN.RILEVANZA
          AND P_DATA
            BETWEEN PEIN.DAL AND
          NVL(PEIN.AL
             ,TO_DATE('3333333','J'))
          )
     AND PEIN.DAL      != PESE.DAL
     AND SETT.NUMERO    = PESE.SETTORE
     AND SEDI.NUMERO (+)    = PESE.SEDE
     AND RIFU.SETTORE   = PESE.SETTORE
     AND RIFU.SEDE      = NVL(PESE.SEDE,0)
     AND CONT.CODICE    = QUGI.CONTRATTO
     AND COST.CONTRATTO     = QUGI.CONTRATTO
     AND QUGI.NUMERO    = QUAL.NUMERO
     AND QUAL.NUMERO    = PESE.QUALIFICA
     AND PESE.FIGURA    = FIGI.NUMERO
     AND PESE.FIGURA    = FIGU.NUMERO
     AND ATTI.CODICE (+)    = PESE.ATTIVITA
     AND RUOL.CODICE    = QUGI.RUOLO
     AND EVGI.CODICE    = PESE.EVENTO
     AND POSI.CODICE    = PESE.POSIZIONE
     AND CLFU.CODICE (+)    = RIFU.FUNZIONALE
     AND TRPR.CODICE (+)    = RARE.TRATTAMENTO
     AND RARE.CI (+)    = PESE.CI
     AND PESE.CI    = RAPA.CI
     AND RAIN.CI    = RAPA.CI
     AND CLRA.CODICE    = RAIN.RAPPORTO
     AND P_DATA  BETWEEN GREATEST(PESE.DAL
          ,RAPA.DAL
          ,COST.DAL
          ,QUGI.DAL
          ,FIGI.DAL
          )
          AND LEAST(PEIN.DAL-1
           ,NVL(RAPA.AL,TO_DATE('3333333','J'))
           ,NVL(COST.AL,TO_DATE('3333333','J'))
           ,NVL(QUGI.AL,TO_DATE('3333333','J'))
           ,NVL(FIGI.AL,TO_DATE('3333333','J'))
           )
    ;
  EXCEPTION
    WHEN OTHERS THEN
  RAISE FORM_TRIGGER_FAILURE;
  END;
PROCEDURE CALCOLO
  IS
  BEGIN
     BEGIN
    DELETE_TAB;
    INSERT_1;
    INSERT_2;
    INSERT_3;
    ppacdppa2.INSERT_4(w_prenotazione,p_data);
    INSERT_5;
    INSERT_6;
    COMMIT;
     END;
  END;
  -- INSERIMENTO REGISTRAZIONI DI CATEGORIA PER INDIVIDUI IDONEI
  PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 PASSO    IN NUMBER) is
  begin
IF P_PRENOTAZIONE != 0 THEN
      BEGIN  -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
     SELECT UTENTE
      , AMBIENTE
      , ENTE
      , GRUPPO_LING
       INTO W_UTENTE
      , W_AMBIENTE
      , W_ENTE
      , W_LINGUA
       FROM A_PRENOTAZIONI
      WHERE NO_PRENOTAZIONE = P_PRENOTAZIONE
     ;
      EXCEPTION
     WHEN OTHERS THEN NULL;
      END;
   END IF;
   BEGIN
     SELECT TO_DATE(SUBSTR(PARA.VALORE,1,10),'DD/MM/YYYY')
       INTO P_DATA
       FROM A_PARAMETRI PARA
      WHERE PARA.NO_PRENOTAZIONE = P_PRENOTAZIONE
    AND PARA.PARAMETRO   = 'P_DATA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
       P_DATA := NULL;
   END;
   IF P_DATA IS NULL THEN
      BEGIN
    SELECT  RIPA.INI_MES
      INTO  P_DATA
      FROM  RIFERIMENTO_PRESENZA RIPA
     WHERE  RIPA_ID = 'RIPA_ID'
    ;
      EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_DATA := SYSDATE;
      END;
   END IF;
   W_PRENOTAZIONE := P_PRENOTAZIONE;
   ERRORE := to_char(null);
   -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
   -- VIENE RIAZZERATO IN FORM CHIAMANTE PER EVITARE TRASACTION COMPLETED
   CALCOLO;  -- ESECUZIONE DELLA DETERMINAZIONE PERIODI DI PRESENZA
   IF W_PRENOTAZIONE != 0 THEN
      IF SUBSTR(errore,6,1) = '8' THEN
     UPDATE A_PRENOTAZIONI
        SET ERRORE = 'P05808'
      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
     ;
     COMMIT;
      ELSIF
     SUBSTR(errore,6,1) = '9' THEN
     UPDATE A_PRENOTAZIONI
        SET ERRORE   = 'P05809'
      , PROSSIMO_PASSO = 91
      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
     ;
     COMMIT;
      END IF;
   END IF;
	null;
    EXCEPTION
   WHEN OTHERS THEN
      BEGIN
     ROLLBACK;
     IF W_PRENOTAZIONE != 0 THEN
        UPDATE A_PRENOTAZIONI
       SET ERRORE   = '*ABORT*'
         , PROSSIMO_PASSO = 99
        WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
        ;
        COMMIT;
     END IF;
	null;
      EXCEPTION
     WHEN OTHERS THEN
        null;
      END;
    END;
END;
/

