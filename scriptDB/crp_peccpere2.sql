CREATE OR REPLACE PACKAGE Peccpere2 IS
/******************************************************************************
 NOME:        Peccpere2
 DESCRIZIONE: Calcolo Periodi
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    01/12/2004 NN     Gestita vista periodi_servizio (che fraziona i periodi
                        di servizio anche in presenza di assenze se attivo il
                        flag servizio_inpdap) al posto della vista
                        periodi_servizio_contabile.
 2    07/12/2004 NN     Gestione percentuale di assenza indicata nel campo Ore
                        del record di assenza.
 2.1  04/07/2005 NN     Solo in caso di assenza con attivo il flag servizio_inpdap,
                        si riporta il codice dell'assenza anche sul record che
                        diventerà con competenza maiuscola.
 2.2  21/02/2006 NN     In caso di intera assenza di febbraio, conteggia solo 28
                        giorni, pagandone cosi 2.
 2.3  15/02/2007 AM     Calcolo gg assenza effettivi in caso di assunti / dimessi
                        e contratto di 26 gg: In caso di intera assenza di febbraio,
                        conteggia solo 24 giorni, pagandone cosi 2.
 3.0  22/03/2007 AM     Accorpate le 4 insert (servizio, incarico, assenza, assenza
                        su incarico) in una sola procedure attivata passando i
                        parametri per le parti variabili; tolto il blocco su
                        APERL = APESS per i giornalieri con note like 365
 3.1  28/03/2007 AM     Assenze a % di ore su APEAS in caso di incarico
 3.2  27/09/2007 NN     Gestito il nuovo campo pegi.delibera
 3.3  22/10/2007 NN     Gestito il nuovo campo pere.gg_df
******************************************************************************/
revisione varchar2(30) := '3.3 del 22/10/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE CARE_INSERT
( P_ci NUMBER
, P_dal DATE
, P_al DATE
, P_cong_ind NUMBER
, P_d_cong DATE
, P_d_cong_al DATE
, P_anno NUMBER
, P_mese NUMBER
, P_mensilita VARCHAR2
, P_ini_ela DATE
, P_fin_ela DATE
, P_ini_per DATE
--Parametri per Trace
, p_trc IN NUMBER --Tipo di Trace
, p_prn IN NUMBER --Numero di Prenotazione elaborazione
, p_pas IN NUMBER --Numero di Passo procedurale
, p_prs IN OUT NUMBER --Numero progressivo di Segnalazione
, p_stp IN OUT VARCHAR2 --Step elaborato
, p_tim IN OUT VARCHAR2 --Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY Peccpere2 IS
form_trigger_failure EXCEPTION;
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.'||revisione;
END VERSIONE;
PROCEDURE CARE_INSERIMENTO
        ( P_ci        NUMBER
        , P_anno_pere NUMBER
        , P_mese_pere NUMBER
        , P_g_dal     NUMBER
        , P_g_al      NUMBER
        , P_g_al_e    NUMBER
        , P_g_al_p    NUMBER
        , P_C_dal     DATE
        , P_C_al      DATE
        , P_C_ore_mensili number
        , P_C_div_orario number
        , P_C_ore_lavoro number
        , P_C_gg_lavoro number
        , P_C_gg_assenza varchar2
        , P_C_gg_effettivi varchar2
        , P_C_ore number
        , P_C_assenza varchar2
        , P_C_non_utile varchar2
        , P_C_rilevanza varchar2
        , P_C_settore number
        , P_C_sede number
        , P_C_figura number
        , P_C_ATTIVITA varchar2
        , P_C_contratto varchar2
        , P_C_gestione varchar2
        , P_C_ruolo varchar2
        , P_C_profilo varchar2
        , P_C_posizione varchar2
        , P_C_qualifica number
        , P_C_tipo_rapporto varchar2
        , P_rap_mese number
        , P_pre_sede_del Varchar2
        , P_pre_anno_del number
        , P_pre_num_del number
        , P_pre_delibera Varchar2
        , P_det_dal   DATE
        , P_Det_al    DATE
        , P_ini_mes   DATE
        , P_fin_mes   DATE
        , p_ser_dal   DATE
        , P_calcolo   varchar2
        --Parametri per Trace
        , p_trc IN NUMBER --Tipo di Trace
        , p_prn IN NUMBER --Numero di Prenotazione elaborazione
        , p_pas IN NUMBER --Numero di Passo procedurale
        , p_prs IN OUT NUMBER --Numero progressivo di Segnalazione
        , p_stp IN OUT VARCHAR2 --Step elaborato
        , p_tim IN OUT VARCHAR2 --Time impiegato in secondi
        ) IS
   D_gg_con NUMBER;
BEGIN
  IF P_calcolo in ('S','I') THEN -- calcolo gg_con con specifiche di servizio o incarico
/* 21/05/2007  altri casi di assenze a fine mese 
   vecchia versione:
     select DECODE( P_C_gg_lavoro
                   , 30, DECODE( TO_CHAR(NVL(P_g_dal,1))||TO_CHAR(NVL(P_g_al_p,32))
                               , '3131', 1
                                       , DECODE( DECODE( P_C_gg_assenza

                                                       , 'P', 'E'
                                                            , P_C_gg_assenza
                                                       )
                                               , 'E', ( NVL(P_g_al_e,30)
                                                      - NVL(P_g_dal,1) + 1
                                                      )
                                                    , ( LEAST(30, NVL(P_g_al,30))
                                                      - NVL(P_g_dal,1) + 1
                                                      )
                                               )
                               )
                      ,  1, 0
                          , DECODE( TO_CHAR(NVL(P_g_dal,1))||TO_CHAR(NVL(P_g_al,31))
                                  , '131', DECODE( nvl(P_C_gg_assenza,' ')||
                                                   nvl(P_C_gg_effettivi,' ')
                                                  , 'ES', 0
                                                        , P_C_gg_lavoro
                                                 )
                                         , 0
                                      )
                   )

      into D_gg_con
      from dual;
*/
     select DECODE( TO_CHAR(NVL(P_g_dal,1))||TO_CHAR(NVL(P_g_al_p,31))
                  , '3131', 1
                          , DECODE( P_C_gg_lavoro
                                  , 30, DECODE( DECODE( P_C_gg_assenza
                                                       , 'P', 'E'
                                                            , P_C_gg_assenza
                                                       )
                                               , 'E', ( NVL(P_g_al_e,30)
                                                      - NVL(P_g_dal,1) + 1
                                                      )
                                                    , ( LEAST(30, NVL(P_g_al,30))
                                                      - NVL(P_g_dal,1) + 1
                                                      )
                                               )
                                   ,  1, 0
                                       , DECODE( TO_CHAR(NVL(P_g_dal,1))||TO_CHAR(NVL(P_g_al,31))
                                              , '131', DECODE( nvl(P_C_gg_assenza,' ')||
                                                                nvl(P_C_gg_effettivi,' ')
                                                               , 'ES', 0
                                                                     , P_C_gg_lavoro
                                                              )
                                                      , 0
                                                   )
                                 )
                   )
      into D_gg_con
      from dual;
  ELSE -- calcolo gg_con con specifiche di assenza
-- dbms_output.put_line('****************************************************');
-- dbms_output.put_line('P_C_gg_lavoro '||P_C_gg_lavoro||' P_C_non_utile '||P_C_non_utile||
--                       ' P_g_dal '||P_g_dal||' P_g_al '||P_g_al||' P_g_al_e '||P_g_al_e||
--                       ' P_C_gg_assenza '||P_C_gg_assenza||' P_C_non_utile '||P_C_non_utile);
    select DECODE( P_C_gg_lavoro
              , 30, DECODE( TO_CHAR(NVL(P_g_dal,1))||TO_CHAR(NVL(P_g_al,31)) -- vecchia versione 32
                          , '3131', 1
                              , '131', DECODE( P_C_gg_assenza||
                                           P_C_non_utile
/* 21/05/2007 per ORA-01400: cannot insert NULL into ... */
                                         , 'A', NVL(P_g_al_e,30) --P_g_al_e
                                         , 'E', NVL(P_g_al_e,30) --P_g_al_e
                                              , 30
                                         )
                                 , DECODE( DECODE( P_C_gg_assenza||
                                                   P_C_non_utile
                                                 , 'A', 'E'
                                                 , 'E', 'E'
                                                      , 'C'
                                                 )
                                         , 'E', ( NVL(P_g_al_e,30)
                                                - NVL(P_g_dal,1) + 1
                                                )
                                         , ( LEAST(30, NVL(P_g_al,30))
                                           - NVL(P_g_dal,1) + 1
                                           )
                                         )
                          )
                       , 1, 0
                          , DECODE( TO_CHAR(NVL(P_g_dal,1))||TO_CHAR(NVL(P_g_al,31))
/* 21/05/2007 - messo il test su 3131 = 1 gg cont anche per i contratti in 26esimi */
                                  , '3131', 1
-- tentativo di modifica per gestire assenze a fine mese 
-- (produce un rec. "misto" con presenza e assenza)
--                                  , to_char(P_fin_mes,'dd')||to_char(P_fin_mes,'dd'), 1
--                                  , to_char(P_fin_mes,'dd')||'31', 1
                                      , '131', DECODE( nvl(P_C_gg_assenza,' ')||
                                                   nvl(P_C_gg_effettivi,' ')
                                                  , 'ES', 0
                                                        , P_C_gg_lavoro
                                                 )
                                         , 0
                                      )
              )
      into D_gg_con
      from dual;
  END IF;
-- dbms_output.put_line('p_calcolo '||p_calcolo||' P_ser_dal '||P_ser_dal||' D_gg_con '||D_gg_con);
  BEGIN
   INSERT INTO CALCOLI_RETRIBUTIVI
           ( ci, anno, mese
           , g_dal
           , g_al
           , dal
           , al
           , servizio
           , settore, sede, figura, ATTIVITA
           , contratto, gestione, ruolo
           , profilo, posizione
           , qualifica, tipo_rapporto
           , ore
           , gg_con
           , gg_lav
           , gg_pre
           , gg_inp
           , st_inp
           , gg_af
           , gg_df
           , gg_fis
           , assenza
           , giorni
           , ore_lavoro
           , rap_mese
           , sede_del
           , anno_del
           , numero_del
           , delibera
           , gg_det
           , gg_365
           )
      SELECT P_ci, P_anno_pere, P_mese_pere
           , P_g_dal
           , P_g_al_e
           , decode( p_calcolo
                   , 'A', GREATEST(P_ser_dal ,P_ini_mes) -- mantiene il legame assenza / rec. di servizio
                        , GREATEST(P_C_dal,P_ini_mes)
                   )
           , LEAST(P_C_al,P_fin_mes)
           , P_C_rilevanza
           , P_C_settore, P_C_sede, P_C_figura, P_C_ATTIVITA
           , P_C_contratto, P_C_gestione, P_C_ruolo
           , P_C_profilo, P_C_posizione
           , P_C_qualifica, P_C_tipo_rapporto
           , NVL(P_C_ore, P_C_ore_lavoro)
           , D_gg_con
           , 0
           , DECODE( TO_CHAR(NVL(P_g_dal,1))||
                     TO_CHAR(NVL(P_g_al,31))
                   , '131', DECODE ( P_C_gg_assenza
                                   , 'E', 0
                                        , DECODE( P_C_gg_lavoro
                                                , 30, 26
                                                    , 0
                                                )
                                   )
                          , 0
                    ) gg_pre
           , DECODE( TO_CHAR(NVL(P_g_dal,1))||
                     TO_CHAR(NVL(P_g_al,31))
                   , '131', 26
                          , 0
                   ) gg_inp
           , 0 gg_af
           , 0 gg_df
           , 0 gg_fis
           , DECODE( TO_CHAR(NVL(P_g_dal,1))||
                     TO_CHAR(NVL(P_g_al_p,32))
                   ,'3131', 1
                          , LEAST(30, NVL(P_g_al,30))
                          - NVL(P_g_dal,1) + 1
                   ) gg_fis
           , P_C_assenza assenza
           , DECODE(P_C_gg_lavoro,1,0,P_C_gg_lavoro) giorni
           , P_C_ore_lavoro
           , DECODE( NVL(P_C_div_orario,0) * NVL(P_C_ore_mensili,0) * P_rap_mese
                   , 0, 1
                      , P_C_ore_mensili / P_C_div_orario
                   ) rap_mese
           , P_pre_sede_del
           , P_pre_anno_del
           , P_pre_num_del
           , P_pre_delibera
           , DECODE( TO_CHAR(NVL(P_det_al,P_fin_mes),'mm')
                   , '02', DECODE( TO_CHAR(NVL(P_Det_al,P_fin_mes),'dd')
                                 , '29', NVL(P_Det_Al,P_fin_mes) -1
                                       , NVL(P_Det_Al,P_fin_mes)
                                 )
                         , NVL(P_Det_al,P_fin_mes)
                   )
           - DECODE( TO_CHAR(NVL(P_det_dal,P_ini_mes),'mm')
                   , '02', DECODE( TO_CHAR(NVL(P_det_dal,P_ini_mes),'dd')
                                 , '29', NVL(P_det_dal,P_ini_mes)-1
                                        , NVL(P_det_dal,P_ini_mes)
                                 )
                         , NVL(P_det_dal,P_ini_mes)
                   ) + 1 gg_det
           , LEAST(P_C_al,P_fin_mes)
           - GREATEST(P_C_dal,P_ini_mes) + 1 gg_365
        FROM dual
 ;
  END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
 RAISE;
 WHEN OTHERS THEN
 Peccpere.err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
 RAISE FORM_TRIGGER_FAILURE;
END;
--Inserimento Periodi di Assenza
--
PROCEDURE CARE_INSERT_ASS
        ( P_ci NUMBER
        , P_dal DATE
        , P_al DATE
        , P_cong_ind NUMBER
        , P_d_cong DATE
        , P_d_cong_al DATE
        , P_anno NUMBER
        , P_mese NUMBER
        , P_mensilita VARCHAR2
        , P_ini_ela DATE
        , P_fin_ela DATE
        , P_ini_per DATE
        , P_ini_mes DATE --Inizio del mese in calcolo
        , P_fin_mes DATE --Fine del mese in calcolo
        , P_avventizio VARCHAR2
        , P_giornaliero VARCHAR2
        , P_assunto VARCHAR2
        , P_dimesso VARCHAR2
        , P_gg_assenza VARCHAR2
        , P_gg_effettivi VARCHAR2
        , P_anno_pere NUMBER
        , P_mese_pere NUMBER
        , P_ser_dal DATE
        , P_ser_al DATE
        , P_ser_rilevanza VARCHAR2
        , P_ser_contratto VARCHAR2
/* modifica del 07/12/2004 */
        , P_ser_ore NUMBER
/* fine modifica del 07/12/2004 */
        --Parametri per Trace
        , p_trc IN NUMBER --Tipo di Trace
        , p_prn IN NUMBER --Numero di Prenotazione elaborazione
        , p_pas IN NUMBER --Numero di Passo procedurale
        , p_prs IN OUT NUMBER --Numero progressivo di Segnalazione
        , p_stp IN OUT VARCHAR2 --Step elaborato
        , p_tim IN OUT VARCHAR2 --Time impiegato in secondi
        ) IS
          D_g_dal NUMBER(2); --Giorno di inizio precalcolato
          --NULL se diverso dal mese in calcolo
          D_det_dal DATE;
          D_g_al NUMBER(2); --Giorno di fine precalcolato
          --NULL se diverso dal mese in calcolo
          --o se uguale a fine mese
          D_det_al DATE;
          D_g_al_p NUMBER(2); --Giorno di fine precalcolato
          D_det_al_p DATE;
          --NULL se Servizio NON coincidente
          --con Inizio Rapporto di Lavoro
          D_g_al_e NUMBER(2); --Giorno di fine effettivo diverso da NULL
          D_Det_al_e DATE;
          --se caso di gestione "gg_effettivi"
          D_rap_mese NUMBER; --a 1 se assunto o dimesso in corso mese
          --e gestione "gg_assenza" = E
          D_det_al_a DATE;
          --sempre diverso da NULL
          --Estrazione dati per ciclo su assenze periodo di servizio o di incarico
CURSOR C_SEL_PEGI_ASS
     ( C_ci NUMBER, C_dal DATE, C_al DATE) IS
       SELECT pegi.dal
            , NVL(pegi.al,TO_DATE(3333333,'j')) al
            , pegi.assenza
            , aste.per_ret
            , DECODE(TO_CHAR(aste.per_ret)||TO_CHAR(aste.servizio)
                    , '00', 'X'
                          , ''
                    ) non_utile
/* modifica del 04/12/2004 */
            , DECODE( NVL(pegi.ore, 100)
              , 100, NVL(P_ser_ore, cost.ore_lavoro)
/* modifica del 28/03/2007 */
--                   , cost.ore_lavoro * (100 - pegi.ore) / 100
                   , NVL(P_ser_ore, cost.ore_lavoro) * (100 - pegi.ore) / 100
/* fine modifica del 28/03/2007 */
              ) ore
/* fine modifica del 04/12/2004 */
            , pegi.ore ore_assenza
            , cost.ore_mensili
            , cost.div_orario
            , cost.ore_lavoro
            , cost.gg_lavoro
            , cost.gg_assenza
            , cost.gg_effettivi
         FROM ASTENSIONI aste
            , PERIODI_GIURIDICI pegi
            , CONTRATTI_STORICI cost
        WHERE aste.codice = pegi.assenza
          AND pegi.ci = C_ci
          AND pegi.rilevanza = 'A'
          AND pegi.dal <= C_al
          AND NVL(pegi.al, TO_DATE(3333333,'j'))
           >= C_dal
          AND cost.contratto = P_ser_contratto
          AND GREATEST(P_ser_dal,P_ini_mes)
              BETWEEN NVL(cost.dal, TO_DATE(3333333,'j'))
                  AND NVL(cost.al , TO_DATE(3333333,'j'))
       ;
--Estrazione dati del Servizio durante un periodo di Assenza in Incarico
CURSOR C_SEL_PEGI_ASS_INC
     ( C_ci NUMBER, C_dal DATE, C_al DATE, C_ore_assenza NUMBER) IS
       SELECT GREATEST( cost.dal
                      , qugi.dal
                      , figi.dal
                      , pegi.dal
                      ) dal
            , LEAST( NVL(cost.al, TO_DATE(3333333,'j'))
                   , NVL(qugi.al, TO_DATE(3333333,'j'))
                   , NVL(figi.al, TO_DATE(3333333,'j'))
                   , NVL(pegi.al, TO_DATE(3333333,'j'))
                   ) al
            , pegi.dal eve_dal
            , NVL(pegi.al, TO_DATE(3333333,'j')) eve_al
            , pegi.settore, pegi.sede, pegi.figura, pegi.ATTIVITA
            , qugi.contratto, pegi.gestione, qugi.ruolo
            , figi.profilo, pegi.posizione
            , pegi.qualifica, pegi.tipo_rapporto
            , DECODE( NVL(C_ore_assenza, 100)
              , 100, pegi.ore
                   , cost.ore_lavoro * (100 - C_ore_assenza) / 100
              ) ore
--            , pegi.ore
            , cost.ore_mensili
            , cost.div_orario
            , cost.ore_lavoro
            , cost.gg_lavoro
            , cost.gg_assenza
            , cost.gg_effettivi
         FROM CONTRATTI_STORICI cost
            , QUALIFICHE_GIURIDICHE qugi
            , FIGURE_GIURIDICHE figi
            , PERIODI_GIURIDICI pegi
        WHERE cost.contratto = qugi.contratto
          AND cost.dal <= LEAST( NVL(qugi.al,TO_DATE(3333333,'j'))
                               , NVL(figi.al,TO_DATE(3333333,'j'))
                               , NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(cost.al,TO_DATE(3333333,'j'))
           >= GREATEST( qugi.dal
                      , figi.dal
                      , pegi.dal
                      , C_dal
                      )
          AND qugi.numero = pegi.qualifica
          AND qugi.dal <= LEAST( NVL(figi.al,TO_DATE(3333333,'j'))
                               , NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(qugi.al,TO_DATE(3333333,'j'))
           >= GREATEST( figi.dal
                      , pegi.dal
                      , C_dal
                      )
          AND figi.numero = pegi.figura
          AND figi.dal <= LEAST( NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(figi.al,TO_DATE(3333333,'j'))
           >= GREATEST( pegi.dal
                      , C_dal
                      )
          AND pegi.ci = C_ci
          AND pegi.rilevanza = 'S'
          AND pegi.dal <= C_al
          AND NVL(pegi.al, TO_DATE(3333333,'j'))
           >= C_dal
       ;
--
BEGIN --Ciclo sulle assenze relative al periodo di servizio o incarico
 FOR CURA IN C_SEL_PEGI_ASS
           ( P_ci, GREATEST(P_ser_dal,P_ini_mes)
           , LEAST(P_ser_al,P_fin_mes)
           ) LOOP
/* Attiva i giorni DAL, AL diversi da NULL nel caso di:
 - Non corrispondenti al primo e ultimo giorno del mese
 - Servizio coincidente con Inizio Rapporto di Lavoro
*/
 --Giorno DAL e data DAL per gg_det
 IF TO_CHAR(GREATEST(P_ser_dal,cura.dal),'mmyyyy')
    =
    TO_CHAR(P_ini_mes,'mmyyyy') THEN
    D_g_dal := TO_CHAR(GREATEST(P_ser_dal,cura.dal),'dd');
    D_det_dal := GREATEST(P_ser_dal,cura.dal);
 ELSE
    D_g_dal := NULL;
    D_det_dal := TO_DATE(NULL);
 END IF;
 --Giorno AL e data AL per gg_det
 IF TO_CHAR(LEAST(P_ser_al,cura.al),'mmyyyy')
    =
    TO_CHAR(P_fin_mes,'mmyyyy') THEN
/* modifica del 21/02/2006 */
/*  IF TO_CHAR(LEAST(P_ser_al,cura.al),'ddmm') in ('2802','2902') THEN
    D_g_al_a := 30;
  ELSE
    D_g_al_a := TO_CHAR(LEAST(P_ser_al,cura.al),'dd');
  END IF;
*//* fine modifica del 21/02/2006 */
    D_det_al_a := LEAST(P_ser_al,cura.al);
    IF LEAST(P_ser_al,cura.al) = P_fin_mes THEN
       D_g_al := NULL;
       D_det_al := TO_DATE(NULL);
    ELSE
       D_g_al := TO_CHAR(LEAST(P_ser_al,cura.al),'dd');
       D_det_al := LEAST(P_ser_al,cura.al);
    END IF;
 ELSE
/* modifica del 21/02/2006 */
/*  IF TO_CHAR(P_fin_mes,'ddmm') in ('2802','2902') THEN
    D_g_al_a := 30;
  ELSE
    D_g_al_a := TO_CHAR(P_fin_mes,'dd');
  END IF;
*//* fine modifica del 21/02/2006 */
    D_det_al_a := P_fin_mes;
    D_g_al := NULL;
    D_det_al := TO_DATE(NULL);
 END IF;
 D_g_al_p := D_g_al;
 D_det_al_p := d_det_al;
 IF P_assunto = 'SI'
    AND TO_CHAR(P_ser_dal,'mmyyyy')
        =
        TO_CHAR(P_ini_mes,'mmyyyy')
 THEN
    D_g_al_p := TO_CHAR(LEAST(P_ser_al,cura.al,P_fin_mes),'dd');
    D_det_al_p := LEAST(P_ser_al,cura.al,P_fin_mes);
 END IF;
 D_g_al_e := D_g_al;
 D_det_al_e := D_det_al;
 IF P_gg_effettivi = 'S'
    OR P_gg_effettivi = 'A'
    AND ( P_assunto = 'SI'
          AND TO_CHAR(P_ser_dal,'mmyyyy') = TO_CHAR(P_ini_mes,'mmyyyy')
          OR P_dimesso = 'SI'
          AND TO_CHAR(P_ser_al,'mmyyyy') = TO_CHAR(P_fin_mes,'mmyyyy')
        )
    OR P_gg_effettivi = 'D'
    AND P_avventizio = 'SI'
    AND ( P_assunto = 'SI'
          AND TO_CHAR(P_ser_dal,'mmyyyy') = TO_CHAR(P_ini_mes,'mmyyyy')
          OR P_dimesso = 'SI'
          AND TO_CHAR(P_ser_al,'mmyyyy') = TO_CHAR(P_fin_mes,'mmyyyy')
        )
    OR P_giornaliero = 'SI'
 THEN
    D_g_al_e := TO_CHAR(LEAST(P_ser_al,cura.al,P_fin_mes),'dd');
    D_det_al_e := LEAST(P_ser_al,cura.al,P_fin_mes);
    IF P_gg_assenza = 'E'
    THEN
       D_rap_mese := 1;
    ELSE
       D_rap_mese := 0;
    END IF;
 ELSE
    D_rap_mese := 0;
 END IF;
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 P_stp := 'CARE_INSERT_ASS-02';
-- dbms_output.put_line('Assenza A');
-- dbms_output.put_line('CPERE2 CURA DAL '||GREATEST(nvl(cura.dal,to_date('2222222','j')),P_ini_mes));
-- dbms_output.put_line('CPERE2 CURA AL '||LEAST(nvl(cura.al,to_date('3333333','j')),P_fin_mes));
-- dbms_output.put_line('CPERE2 CURA ASSENZA '||cura.assenza);
 CARE_INSERIMENTO(  P_ci
                  , P_anno_pere , P_mese_pere
                  , D_g_dal , D_g_al
                  , D_g_al_e , D_g_al_p
                  , GREATEST(cura.dal,P_ser_dal) , LEAST(nvl(cura.al,to_date('3333333','j')),P_ser_al)
                  , cura.ore_mensili , cura.div_orario
                  , cura.ore_lavoro , cura.gg_lavoro
                  , cura.gg_assenza , cura.gg_effettivi
                  , cura.ore, cura.assenza, cura.non_utile
                  , P_ser_rilevanza
                  , to_number(null) , to_number(null) , to_number(null)
                  , null , null
                  , null , null
                  , null , null
                  , to_number(null) , null
                  , D_rap_mese
                  , null , to_number(null) , to_number(null), null 
                  , D_det_dal , D_Det_al
                  , P_ini_mes , P_fin_mes
                  , P_ser_dal , 'A'
                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                 );
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 --
 --Inserimento servizio 'N' per Incarichi su Assenza
 --
 IF P_ser_rilevanza = 'I' THEN
 FOR CURAI IN C_SEL_PEGI_ASS_INC
            ( P_ci, GREATEST(cura.dal,P_ser_dal,P_ini_mes)
            , LEAST(cura.al,P_ser_al,P_fin_mes)
            , cura.ore_assenza
            ) LOOP
     P_stp := 'CARE_INSERT_ASS-03';
/* Attiva i giorni DAL, AL diversi da NULL nel caso di:
 - Non corrispondenti al primo e ultimo giorno del mese
 - Servizio coincidente con Inizio Rapporto di Lavoro
*/
 --Giorno DAL
   IF TO_CHAR(GREATEST(curai.dal,cura.dal,P_ser_dal),'mmyyyy')
      =
      TO_CHAR(P_ini_mes,'mmyyyy') THEN
      D_g_dal := TO_CHAR( GREATEST( curai.dal
                                  , cura.dal
                                  , P_ser_dal
                                  )
                        , 'dd');
      D_det_dal := GREATEST( curai.dal , cura.dal , P_ser_dal );
   ELSE
      D_g_dal := NULL;
      D_det_dal := TO_DATE(NULL);
   END IF;
 --Giorno AL
   IF TO_CHAR(LEAST(curai.al,cura.al,P_ser_al),'mmyyyy')
      =
      TO_CHAR(P_fin_mes,'mmyyyy') THEN
/* modifica del 21/02/2006 */
/*   IF TO_CHAR( LEAST( curai.al, cura.al, P_ser_al), 'ddmm') in ('2802','2902') THEN
      D_g_al_a := 30;
   ELSE
      D_g_al_a := TO_CHAR( LEAST( curai.al
                                , cura.al
                                , P_ser_al
                                )
                         , 'dd');
   END IF;*/
/* fine modifica del 21/02/2006 */
      D_det_al_a := LEAST( curai.al , cura.al , P_ser_al );
      IF LEAST(curai.al,cura.al,P_ser_al) = P_fin_mes THEN
         D_g_al := NULL;
         D_det_al := TO_DATE(NULL);
      ELSE
         D_g_al := TO_CHAR( LEAST( curai.al
                                 , cura.al
                                 , P_ser_al
                                 )
                          , 'dd');
         D_det_al := LEAST( curai.al , cura.al , P_ser_al );
      END IF;
   ELSE
/* modifica del 21/02/2006 */
/*   IF TO_CHAR(P_fin_mes,'ddmm') in ('2802','2902') THEN
      D_g_al_a := 30;
   ELSE
      D_g_al_a := TO_CHAR(P_fin_mes,'dd');
   END IF;
*//* fine modifica del 21/02/2006 */
      D_det_al_a := P_fin_mes;
      D_g_al := NULL;
      D_det_al := TO_DATE(NULL);
   END IF;
   D_g_al_p := D_g_al;
   D_det_al_p := D_det_al;
   IF P_assunto = 'SI'
      AND TO_CHAR(P_ser_dal,'mmyyyy')
      =
      TO_CHAR(P_ini_mes,'mmyyyy')
   THEN
      D_g_al_p := TO_CHAR( LEAST( curai.al
                                , cura.al
                                , P_ser_al
                                , P_fin_mes
                                )
                         , 'dd');
      D_det_al_p := LEAST( curai.al , cura.al , P_ser_al , P_fin_mes );
   END IF;
   D_g_al_e := D_g_al;
   D_det_al_e := D_det_al;
   IF P_gg_effettivi = 'S'
       OR P_gg_effettivi = 'A'
      AND ( P_assunto = 'SI'
            AND TO_CHAR(P_ser_dal,'mmyyyy')
              = TO_CHAR(P_ini_mes,'mmyyyy')
             OR P_dimesso = 'SI'
            AND TO_CHAR(P_ser_al,'mmyyyy')
              = TO_CHAR(P_fin_mes,'mmyyyy')
          )
       OR P_gg_effettivi = 'D'
      AND P_avventizio = 'SI'
      AND ( P_assunto = 'SI'
            AND TO_CHAR(P_ser_dal,'mmyyyy')
              = TO_CHAR(P_ini_mes,'mmyyyy')
             OR P_dimesso = 'SI'
            AND TO_CHAR(P_ser_al,'mmyyyy')
              = TO_CHAR(P_fin_mes,'mmyyyy')
          )
       OR P_giornaliero = 'SI'
   THEN
     D_g_al_e := TO_CHAR( LEAST( curai.al
                               , cura.al
                               , P_ser_al
                               , P_fin_mes
                               )
                        , 'dd');
     D_det_al_e := LEAST( curai.al , cura.al , P_ser_al , P_fin_mes );
     IF P_gg_assenza = 'E'
     THEN
        D_rap_mese := 1;
     ELSE
        D_rap_mese := 0;
     END IF;
   ELSE
     D_rap_mese := 0;
   END IF;
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 P_stp := 'CARE_INSERT_ASS-04';
-- dbms_output.put_line('Assenza su incarico X');
-- dbms_output.put_line('CURAI EVE_DAL '||curai.eve_dal);
-- dbms_output.put_line('CURAI EVE_AL '||curai.eve_al);
-- dbms_output.put_line('CURA2 DAL '||cura.dal);
-- dbms_output.put_line('CURA2 AL '||cura.al);
 CARE_INSERIMENTO(  P_ci
                  , P_anno_pere , P_mese_pere
                  , D_g_dal , D_g_al
                  , D_g_al_e , D_g_al_p
                  , GREATEST(curai.eve_dal,P_ser_dal) , LEAST(nvl(curai.al,to_date('3333333','j')),P_ser_al)
                  , curai.ore_mensili , curai.div_orario
                  , curai.ore_lavoro , curai.gg_lavoro
                  , curai.gg_assenza  , curai.gg_effettivi
                  , curai.ore, cura.assenza, cura.non_utile
                  , 'N'
                  , to_number(null) , to_number(null) , to_number(null)
                  , null , null , null , null , null
                  , null , to_number(null) , null 
                  , D_rap_mese
                  , null , to_number(null) , to_number(null), null 
                  , D_det_dal , D_Det_al
                  , P_ini_mes , P_fin_mes
                  , to_date(null) , 'X'
                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                 );
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END LOOP; --Fine ciclo servizi 'N'
 END IF; --Fine inserimento servizio 'N' Incarichi su Assenza
 END LOOP; --Fine ciclo assenze su servizio e incarico
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
 RAISE;
 WHEN OTHERS THEN
 Peccpere.err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
 RAISE FORM_TRIGGER_FAILURE;
END;
--Inserimento Periodi Giuridici in Tavola di Lavoro
--
PROCEDURE CARE_INSERT
        ( P_ci NUMBER
        , P_dal DATE
        , P_al DATE
        , P_cong_ind NUMBER
        , P_d_cong DATE
        , P_d_cong_al DATE
        , P_anno NUMBER
        , P_mese NUMBER
        , P_mensilita VARCHAR2
        , P_ini_ela DATE
        , P_fin_ela DATE
        , P_ini_per DATE
        --Parametri per Trace
        , p_trc IN NUMBER --Tipo di Trace
        , p_prn IN NUMBER --Numero di Prenotazione elaborazione
        , p_pas IN NUMBER --Numero di Passo procedurale
        , p_prs IN OUT NUMBER --Numero progressivo di Segnalazione
        , p_stp IN OUT VARCHAR2 --Step elaborato
        , p_tim IN OUT VARCHAR2 --Time impiegato in secondi
        ) IS
          D_ini_mes DATE; --Inizio del mese in calcolo
          D_fin_mes DATE; --Fine del mese in calcolo
          D_anno_pere NUMBER(4); --Anno di riferimento per inserimento
          D_mese_pere NUMBER(2); --Mese di riferimento per inserimento
          D_g_dal NUMBER(2); --Giorno di inizio precalcolato
          D_det_dal DATE;
          --NULL se diverso dal mese in calcolo
          D_g_al NUMBER(2); --Giorno di fine precalcolato
          D_det_al DATE;
          --NULL se diverso dal mese in calcolo
          --o se uguale a fine mese
          D_g_al_p NUMBER(2); --Giorno di fine precalcolato
          D_det_al_p DATE;
          --NULL se Servizio NON coincidente
          --con Inizio Rapporto di Lavoro
          --Dati del Rapporto di Lavoro
          D_pre_dal DATE; --Inizio del Rapporto di Lavoro
          D_pre_al DATE; --Fine del Rapporto di Lavoro
          D_note PERIODI_GIURIDICI.note%TYPE;
          D_avventizio VARCHAR2(2); --Servizio a Tempo Determinato coincidente
         --con il Rapporto di Lavoro
         D_giornaliero VARCHAR2(2); --Servizio a Tempo Determinato coincidente
         --con il Rapporto di Lavoro
         --Giorni in note = AL - DAL o '365'
         D_g_al_e NUMBER(2); --Giorno di fine effettivo diverso da NULL
         D_det_Al_E DATE;
         --se caso di gestione "gg_effettivi"
         D_assunto VARCHAR2(2); --Assunto in corso mese (dal != 1)
         D_dimesso VARCHAR2(2); --Dimesso in corso mese (al != ult.gg.)
         D_rap_mese NUMBER; --a 1 se assunto o dimesso in corso mese
         --e gestione "gg_assenza" = E
         D_pre_sede_del PERIODI_GIURIDICI.sede_del%TYPE;
         D_pre_anno_del PERIODI_GIURIDICI.anno_del%TYPE;
         D_pre_num_del PERIODI_GIURIDICI.numero_del%TYPE;
         D_pre_delibera PERIODI_GIURIDICI.delibera%TYPE;
         --Estrazione periodi di Servizio (S) o Incarico (E)
CURSOR C_SEL_PEGI_SER
     ( C_ci NUMBER,C_dal DATE,C_al DATE) IS
       SELECT DECODE(pegi.rilevanza,'S','Q','E','I') rilevanza
            , GREATEST( cost.dal
                      , qugi.dal
                      , figi.dal
                      , pegi.dal
                      ) dal
            , LEAST( NVL(cost.al, TO_DATE(3333333,'j'))
                   , NVL(qugi.al, TO_DATE(3333333,'j'))
                   , NVL(figi.al, TO_DATE(3333333,'j'))
                   , NVL(pegi.al, TO_DATE(3333333,'j'))
                   ) al
            , pegi.settore, pegi.sede, pegi.figura, pegi.ATTIVITA
            , qugi.contratto, pegi.gestione, qugi.ruolo
            , figi.profilo, pegi.posizione
            , posi.tempo_determinato
            , cost.gg_assenza
            , NVL(cost.gg_effettivi,'D') gg_effettivi
            , cost.ore_lavoro, cost.gg_lavoro
            , cost.div_orario,cost.ore_mensili
            , pegi.qualifica, pegi.tipo_rapporto
            , pegi.ore
         FROM CONTRATTI_STORICI cost
            , QUALIFICHE_GIURIDICHE qugi
            , FIGURE_GIURIDICHE figi
            , POSIZIONI posi
            , periodi_servizio pegi
        WHERE cost.contratto = qugi.contratto
          AND cost.dal <= LEAST( NVL(qugi.al,TO_DATE(3333333,'j'))
                               , NVL(figi.al,TO_DATE(3333333,'j'))
                               , NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(cost.al,TO_DATE(3333333,'j'))
           >= GREATEST( qugi.dal
                      , figi.dal
                      , pegi.dal
                      , C_dal
                      )
          AND qugi.numero = pegi.qualifica
          AND qugi.dal <= LEAST( NVL(figi.al,TO_DATE(3333333,'j'))
                               , NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(qugi.al,TO_DATE(3333333,'j'))
           >= GREATEST( figi.dal
                      , pegi.dal
                      , C_dal
                      )
          AND figi.numero = pegi.figura
          AND figi.dal <= LEAST( NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(figi.al,TO_DATE(3333333,'j'))
           >= GREATEST( pegi.dal
                      , C_dal
                      )
          AND posi.codice = pegi.posizione
          AND pegi.ci = C_ci
          AND pegi.rilevanza IN ('S','E')
          AND pegi.dal <= C_al
          AND NVL(pegi.al,TO_DATE(3333333,'j'))
           >= C_dal
 ;
--Estrazione dati del Servizio durante un periodo di Incarico
CURSOR C_SEL_PEGI_INC
     ( C_ci NUMBER, C_dal DATE, C_al DATE) IS
       SELECT GREATEST( cost.dal
                      , qugi.dal
                      , figi.dal
                      , pegi.dal
                      ) dal
            , LEAST( NVL(cost.al, TO_DATE(3333333,'j'))
                   , NVL(qugi.al, TO_DATE(3333333,'j'))
                   , NVL(figi.al, TO_DATE(3333333,'j'))
                   , NVL(pegi.al, TO_DATE(3333333,'j'))
                   ) al
            , pegi.dal eve_dal
            , NVL(pegi.al, TO_DATE(3333333,'j')) eve_al
            , pegi.settore, pegi.sede, pegi.figura, pegi.ATTIVITA
            , qugi.contratto, pegi.gestione, qugi.ruolo
            , figi.profilo, pegi.posizione
            , pegi.qualifica, pegi.tipo_rapporto
            , pegi.ore
            , cost.gg_assenza
            , NVL(cost.gg_effettivi,'D') gg_effettivi
            , cost.ore_lavoro, cost.gg_lavoro
            , cost.div_orario,cost.ore_mensili
         FROM CONTRATTI_STORICI cost
            , QUALIFICHE_GIURIDICHE qugi
            , FIGURE_GIURIDICHE figi
            , PERIODI_GIURIDICI pegi
        WHERE cost.contratto = qugi.contratto
          AND cost.dal <= LEAST( NVL(qugi.al,TO_DATE(3333333,'j'))
                               , NVL(figi.al,TO_DATE(3333333,'j'))
                               , NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(cost.al,TO_DATE(3333333,'j'))
           >= GREATEST( qugi.dal
                      , figi.dal
                      , pegi.dal
                      , C_dal
                      )
          AND qugi.numero = pegi.qualifica
          AND qugi.dal <= LEAST( NVL(figi.al,TO_DATE(3333333,'j'))
                               , NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(qugi.al,TO_DATE(3333333,'j'))
           >= GREATEST( figi.dal
                      , pegi.dal
                      , C_dal
                      )
          AND figi.numero = pegi.figura
          AND figi.dal <= LEAST( NVL(pegi.al,TO_DATE(3333333,'j'))
                               , C_al
                               )
          AND NVL(figi.al,TO_DATE(3333333,'j'))
           >= GREATEST( pegi.dal
                      , C_dal
                      )
          AND pegi.ci = C_ci
          AND pegi.rilevanza = 'S'
          AND pegi.dal <= C_al
          AND NVL(pegi.al,TO_DATE(3333333,'j'))
           >= C_dal
 ;
--
BEGIN --Ciclo sui periodi di Servizio (S) o Incarico (E)
 P_stp := 'CARE_INSERT';
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 FOR CURS IN C_SEL_PEGI_SER
           ( P_ci, P_ini_per, P_fin_ela
           ) LOOP
 BEGIN --Lettura Presenza
 P_stp := 'CARE_INSERT-01';
 SELECT dal
      , al
      , note
      , DECODE(confermato,1,sede_del,NULL)
      , DECODE(confermato,1,anno_del,NULL)
      , DECODE(confermato,1,numero_del,NULL)
      , DECODE(confermato,1,delibera,NULL)
   INTO D_pre_dal
      , D_pre_al
      , D_note
      , D_pre_sede_del
      , D_pre_anno_del
      , D_pre_num_del
      , D_pre_delibera
   FROM PERIODI_GIURIDICI
  WHERE ci = P_ci
    AND rilevanza = 'P'
    AND dal <= curs.dal
    AND NVL(al,TO_DATE(3333333,'j'))
    >= NVL(curs.al, TO_DATE(3333333,'j'))
 ;
 IF curs.dal = D_pre_dal
    AND curs.al = D_pre_al
    AND curs.tempo_determinato = 'SI' THEN
        D_avventizio := 'SI';
 END IF;
-- dbms_output.put_line('curs.tempo_determinato '||curs.tempo_determinato||' D_note '||D_note);
/* modifica del 22/03/2007: eliminato controllo su corrispondenza APERL / APESS x giornalieri */
-- IF curs.dal = D_pre_dal
  IF curs.tempo_determinato = 'SI'
    AND ( D_note LIKE '%'||
          NVL(TO_CHAR(curs.al - curs.dal),'365')||
          'gg%'
     OR D_note LIKE '%365esimi%'
        )
 THEN
    D_giornaliero := 'SI';
 END IF;
-- dbms_output.put_line('D_giornaliero '||D_giornaliero);
 D_assunto := '';
 IF curs.dal = D_pre_dal
    AND TO_NUMBER(TO_CHAR(curs.dal,'dd')) != 1 THEN
        D_assunto := 'SI';
 END IF;
 IF curs.al = D_pre_al
    AND curs.al != LAST_DAY(curs.al) THEN
        D_dimesso := 'SI';
 END IF;
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 EXCEPTION
 WHEN NO_DATA_FOUND
   OR TOO_MANY_ROWS THEN
 NULL;
 END; --Fine Lettura Presenza
 --
 --Ciclo per inserimento periodi di Servizio e Incarico spezzati
 --per mese
 --
 D_ini_mes := TO_DATE( TO_CHAR( GREATEST(curs.dal,P_ini_per)
                              , 'mmyyyy'
                              )
                     , 'mmyyyy'
                     );
 --
 WHILE TO_CHAR(D_ini_mes,'yyyymm')
       <=
       TO_CHAR(LEAST(curs.al,P_fin_ela),'yyyymm')
 LOOP
 P_stp := 'CARE_INSERT-02';
 IF P_cong_ind = 2
 OR P_cong_ind = 4
 THEN --Conguaglio Soggetto ad Anno Corrente
    D_anno_pere := GREATEST( P_anno
                           , TO_NUMBER(TO_CHAR(D_ini_mes,'yyyy'))
                           );
    IF P_anno = TO_NUMBER(TO_CHAR(D_ini_mes,'yyyy'))
    THEN
       D_mese_pere := TO_NUMBER(TO_CHAR(D_ini_mes,'mm'));
    ELSE
       D_mese_pere := 0;
    END IF;
 ELSE
    D_anno_pere := TO_NUMBER(TO_CHAR(D_ini_mes,'yyyy'));
    D_mese_pere := TO_NUMBER(TO_CHAR(D_ini_mes,'mm'));
 END IF;
 D_fin_mes := ADD_MONTHS(D_ini_mes,1) - 1;
/* Attiva i giorni DAL, AL diversi da NULL nel caso di:
 - Non corrispondenti al primo e ultimo giorno del mese
 - Servizio coincidente con Inizio Rapporto di Lavoro
*/
 --Giorno DAL
 IF TO_CHAR(curs.dal,'mmyyyy') = TO_CHAR(D_ini_mes,'mmyyyy')
 THEN
    D_g_dal := TO_CHAR(curs.dal,'dd');
    D_det_dal := curs.dal;
 ELSE
    D_g_dal := NULL;
    D_Det_dal := TO_DATE(NULL);
 END IF;
 --Giorno AL
 IF TO_CHAR(curs.al,'mmyyyy') = TO_CHAR(D_fin_mes,'mmyyyy')
 THEN
    IF curs.al = D_fin_mes
    THEN
       D_g_al := NULL;
       D_det_al := TO_DATE(NULL);
    ELSE
       D_g_al := TO_CHAR(curs.al,'dd');
       D_det_al := curs.al;
    END IF;
 ELSE
    D_g_al := NULL;
    D_det_al := TO_DATE(NULL);
 END IF;
 D_g_al_p := D_g_al;
 D_det_al_p := D_det_al;
 IF D_assunto = 'SI'
    AND TO_CHAR(curs.dal,'mmyyyy') = TO_CHAR(D_ini_mes,'mmyyyy')
 THEN
    D_g_al_p := TO_CHAR(LEAST(curs.al,D_fin_mes),'dd');
    D_det_al_p := LEAST(curs.al,D_fin_mes);
 END IF;
 D_g_al_e := D_g_al;
 D_det_al_e := D_det_al;
 IF curs.gg_effettivi = 'S'
    OR curs.gg_effettivi = 'A'
    AND ( D_assunto = 'SI'
          AND TO_CHAR(curs.dal,'mmyyyy') = TO_CHAR(D_ini_mes,'mmyyyy')
           OR D_dimesso = 'SI'
          AND TO_CHAR(curs.al,'mmyyyy') = TO_CHAR(D_fin_mes,'mmyyyy')
        )
     OR curs.gg_effettivi = 'D'
    AND D_avventizio = 'SI'
    AND ( D_assunto = 'SI'
          AND TO_CHAR(curs.dal,'mmyyyy') = TO_CHAR(D_ini_mes,'mmyyyy')
           OR D_dimesso = 'SI'
          AND TO_CHAR(curs.al,'mmyyyy') = TO_CHAR(D_fin_mes,'mmyyyy')
        )
     OR D_giornaliero = 'SI'
 THEN
    D_g_al_e := TO_CHAR(LEAST(curs.al,D_fin_mes),'dd');
    D_det_al_e := LEAST(curs.al,D_fin_mes);
    IF curs.gg_assenza = 'E'
    THEN
       D_rap_mese := 1;
    ELSE
       D_rap_mese := 0;
    END IF;
 ELSE
    D_rap_mese := 0;
 END IF;
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 P_stp := 'CARE_INSERT-03';
-- dbms_output.put_line('Servizio S');
-- dbms_output.put_line('CPERE2 CURS DAL '||GREATEST(curs.dal,D_ini_mes));
-- dbms_output.put_line('CPERE2 CURS AL '||LEAST(curs.al,D_fin_mes));
 CARE_INSERIMENTO(  P_ci
                  , D_anno_pere , D_mese_pere
                  , D_g_dal , D_g_al , D_g_al_e , D_g_al_p
                  , curs.dal , curs.al
                  , curs.ore_mensili , curs.div_orario
                  , curs.ore_lavoro , curs.gg_lavoro
                  , curs.gg_assenza , curs.gg_effettivi
                  , curs.ore , ' ' , ''
                  , curs.rilevanza
                  , curs.settore , curs.sede
                  , curs.figura , curs.ATTIVITA
                  , curs.contratto , curs.gestione , curs.ruolo
                  , curs.profilo , curs.posizione
                  , curs.qualifica , curs.tipo_rapporto
                  , D_rap_mese
                  , D_pre_sede_del , D_pre_anno_del , D_pre_num_del, D_pre_delibera
                  , D_det_dal , D_Det_al
                  , D_ini_mes , D_fin_mes
                  , to_date(null), 'S'
                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                 );
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 --Inserimento servizio 'N' per incarichi su periodi di Servizio
 IF curs.rilevanza = 'I' THEN
    FOR CURI IN C_SEL_PEGI_INC
              ( P_ci,GREATEST(curs.dal,D_ini_mes)
              , LEAST(curs.al,D_fin_mes)) LOOP
    P_stp := 'CARE_INSERT-04';
/* Attiva i giorni DAL, AL diversi da NULL nel caso di:
 - Non corrispondenti al primo e ultimo giorno del mese
 - Servizio coincidente con Inizio Rapporto di Lavoro
*/
 --Giorno DAL
    IF TO_CHAR(GREATEST(curi.dal,curs.dal),'mmyyyy')
       =
       TO_CHAR(D_ini_mes,'mmyyyy') THEN
       D_g_dal := TO_CHAR(GREATEST(curi.dal,curs.dal),'dd');
       D_Det_dal := GREATEST(curi.dal,curs.dal);
    ELSE
       D_g_dal := NULL;
       D_Det_Dal := TO_DATE(NULL);
    END IF;
 --Giorno AL
    IF TO_CHAR(LEAST(curi.al,curs.al),'mmyyyy')
       =
       TO_CHAR(D_fin_mes,'mmyyyy') THEN
       IF LEAST(curi.al,curs.al) = D_fin_mes THEN
          D_g_al := NULL;
          D_det_al := TO_DATE(NULL);
       ELSE
          D_g_al := TO_CHAR(LEAST(curi.al,curs.al),'dd');
          D_det_al := LEAST(curi.al,curs.al);
       END IF;
    ELSE
       D_g_al := NULL;
       D_det_al := TO_DATE(NULL);
    END IF;
    D_g_al_p := D_g_al;
    D_det_al_p := D_det_al;
    IF D_assunto = 'SI'
       AND TO_CHAR(curs.dal,'mmyyyy') = TO_CHAR(D_ini_mes,'mmyyyy')
    THEN
       D_g_al_p := TO_CHAR( LEAST( curi.al
                                 , curs.al
                                 , D_fin_mes
                                 )
                          , 'dd');
       D_det_al_p := LEAST( curi.al , curs.al , D_fin_mes );
    END IF;
    D_g_al_e := D_g_al;
    D_Det_Al_e := D_det_al;
    IF curs.gg_effettivi = 'S'
        OR curs.gg_effettivi = 'A'
       AND ( D_assunto = 'SI'
             AND TO_CHAR(curs.dal,'mmyyyy')
               = TO_CHAR(D_ini_mes,'mmyyyy')
              OR D_dimesso = 'SI'
             AND TO_CHAR(curs.al,'mmyyyy')
               = TO_CHAR(D_fin_mes,'mmyyyy')
           )
        OR curs.gg_effettivi = 'D'
       AND D_avventizio = 'SI'
       AND ( D_assunto = 'SI'
             AND TO_CHAR(curs.dal,'mmyyyy')
               = TO_CHAR(D_ini_mes,'mmyyyy')
              OR D_dimesso = 'SI'
             AND TO_CHAR(curs.al,'mmyyyy')
               = TO_CHAR(D_fin_mes,'mmyyyy')
           )
        OR D_giornaliero = 'SI'
    THEN
       D_g_al_e := TO_CHAR( LEAST( curi.al
                                 , curs.al
                                 , D_fin_mes
                                 )
                          , 'dd');
       D_Det_al_e := LEAST( curi.al , curs.al , D_fin_mes );
       IF curs.gg_assenza = 'E'
       THEN
          D_rap_mese := 1;
       ELSE
          D_rap_mese := 0;
       END IF;
    ELSE
       D_rap_mese := 0;
    END IF;
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
-- dbms_output.put_line('Incarico I');
-- dbms_output.put_line('CPERE2 CURI DAL '||GREATEST(curs.dal,curi.dal,D_ini_mes));
-- dbms_output.put_line('CPERE2 CURI AL '||LEAST(curs.al,curi.al,D_fin_mes));
 P_stp := 'CARE_INSERT-05';
 CARE_INSERIMENTO(  P_ci
                  , D_anno_pere , D_mese_pere
                  , D_g_dal , D_g_al , D_g_al_e , D_g_al_p
                  , GREATEST(curs.dal,curi.dal) , LEAST(curs.al,curi.al)
                  , curi.ore_mensili , curi.div_orario
                  , curi.ore_lavoro , curi.gg_lavoro
                  , curi.gg_assenza , curi.gg_effettivi
                  , curi.ore , ' ' , ''
                  , 'N'
                  , curi.settore , curi.sede
                  , curi.figura , curi.ATTIVITA
                  , curi.contratto , curi.gestione , curi.ruolo
                  , curi.profilo , curi.posizione
                  , curi.qualifica , curi.tipo_rapporto
                  , D_rap_mese
                  , D_pre_sede_del , D_pre_anno_del , D_pre_num_del, D_pre_delibera
                  , D_det_dal , D_Det_al
                  , D_ini_mes , D_fin_mes
                  , to_date(null) , 'I'
                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                 );
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END LOOP; --Fine ciclo servizi 'N'
 END IF; --Fine inserimento servizio 'N' per incarichi
 --
 CARE_INSERT_ASS --Inserimento periodi di Assenza
           ( P_ci, P_dal, P_al
             , P_cong_ind, P_d_cong, P_d_cong_al
             , P_anno, P_mese, P_mensilita
             , P_ini_ela, P_fin_ela, P_ini_per
             , D_ini_mes, D_fin_mes
             , D_avventizio, D_giornaliero, D_assunto, D_dimesso
             , curs.gg_assenza, curs.gg_effettivi
             , D_anno_pere, D_mese_pere
             , curs.dal, curs.al
             , curs.rilevanza, curs.contratto, curs.ore
             , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
           );
 --
 --Incremento di un mese su data di ciclo
 --
 D_ini_mes := ADD_MONTHS(D_ini_mes,1);
 --
 END LOOP; --Fine ciclo periodi spezzati per mese
 END LOOP; --Fine ciclo sui periodi giuridici
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 -- Cancellazione dal/al non compresi nell'eventuale
 -- periodo di conguaglio richiesto
 P_stp := 'CARE_INSERT-06';
 DELETE FROM CALCOLI_RETRIBUTIVI
  WHERE ci = P_ci
    and al > P_d_cong_al
    and dal < P_ini_ela
    and P_d_cong_al is not null
 ;
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/* modifica del 04/07/2005 */
 -- Indicazione codice di assenza, solo se servizio_inpdap = 'S',
 -- anche sul record che diventerà con competenza maiuscola
 P_stp := 'CARE_INSERT-07';
 update calcoli_retributivi care1
    set assenza = (select max(assenza)
                     from calcoli_retributivi care2
                    where care2.ci = care1.ci
                      and care2.dal = care1.dal
                      and care2.al = care1.al
                      and care2.assenza in (select codice
                                              from astensioni
                                             where servizio_inpdap = 'S'))
 where ci = P_ci
   and assenza = ' '
   and exists (select 'x'
                 from calcoli_retributivi care3
                where care3.ci = care1.ci
                  and care3.dal = care1.dal
                  and care3.al = care1.al
                  and care3.assenza in (select codice
                                          from astensioni
                                         where servizio_inpdap = 'S'))
;
 Peccpere.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/* fine modifica del 04/07/2005 */
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
 RAISE;
 WHEN OTHERS THEN
 Peccpere.err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
 RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
