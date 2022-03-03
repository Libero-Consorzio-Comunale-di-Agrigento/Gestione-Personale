CREATE OR REPLACE PACKAGE PECCMORE IS
/******************************************************************************
 NOME:        Peccmore
 DESCRIZIONE: Calcolo Movimenti Retributivi
 
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    28/04/2004 MF     Inserimento Group By per eventuale data AL di Rapporto
                        di Lavoro su Totalizzazione Voci.
                        La totalizzazione scarta i dati dei record con 
                        estrazione = RX (provenienti dallo scorporo contributi).
 2    01/12/2004 NN     In caso di estrazione RX o RY la totalizzazione non viene
                        nemmeno richiamata dal calcolo ritenuta.
 3    23/03/2005 NN     Gestito errore P05342 - Situazione Detrazioni/Deduzioni Incongruente
 4    28/06/2005 CB     Codice SIOPE
 4.1  20/12/2005 NN     Applicazione add. regionale Veneto anno 2006.
 4.2  10/04/2007 CB     Aggiunto il controllo sul codice di competenza di RAIN sul C_SEL_RAGI
 4.3  02/05/2007 NN     Aggiunto il campo cassa_competenza nel C_SEL_RAGI
 4.4  23/07/2007 AM     Trattata la delibera di COVO nel calcolo delle totalizzazioni
 4.5  25/07/2007 AM     Gestiti eredi con più registrazioni su RADI (con anni diversi)
******************************************************************************/

revisione varchar2(30) := '4.5 del 25/07/2007';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

w_ERRORE	VARCHAR2(6);
err_passo	VARCHAR2(30);
w_personalizzazioni VARCHAR2(2000);
PROCEDURE calcolo;
PROCEDURE voci_totale
(
 p_ci           NUMBER
,p_al           DATE    -- Data di Termine o Fine Mese
,p_fin_ela       DATE
,p_tipo         VARCHAR2
,p_estrazione    VARCHAR2       -- Identificazione della serie di voci
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
PROCEDURE err_trace
(p_trc IN NUMBER -- Tipo di Trace
,p_prn IN NUMBER -- Numero di Prenotazione elaborazione
,p_pas IN NUMBER -- Numero di Passo procedurale
,p_prs IN OUT NUMBER -- Numero progressivo di Segnalazione
,p_stp IN VARCHAR2 -- Identificazione dello Step in oggetto
,p_cnt IN NUMBER -- Count delle row trattate
,p_tim IN OUT VARCHAR2 -- Time impiegato in secondi
) ;
PROCEDURE log_trace
(p_trc IN NUMBER -- Tipo di Trace
,p_prn IN NUMBER -- Numero di Prenotazione elaborazione
,p_pas IN NUMBER -- Numero di Passo procedurale
,p_prs IN OUT NUMBER -- Numero progressivo di Segnalazione
,p_stp IN VARCHAR2 -- Identificazione dello Step in oggetto
,p_cnt IN NUMBER -- Count delle row trattate
,p_tim IN OUT VARCHAR2 -- Time impiegato in secondi
);
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER,PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY Peccmore IS
w_prenotazione	NUMBER(10):=0;
W_PASSO	NUMBER(5):=0;
w_utente	VARCHAR2(10);
w_ambiente	VARCHAR2(10);
W_ENTE	VARCHAR2(10);
w_lingua	VARCHAR2(1);
w_dummy	VARCHAR2(1);
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
   RETURN 'V4.'||revisione;
END VERSIONE;

-- Emissione delle Voci di Totalizzazione
--
-- Totalizzazione delle voci raggruppate per Capitolo e Delibera
--
PROCEDURE voci_totale
(
 p_ci           NUMBER
,p_al           DATE    -- Data di Termine o Fine Mese
,p_fin_ela       DATE
,p_tipo         VARCHAR2
,p_estrazione    VARCHAR2       -- Identificazione della serie di voci
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
BEGIN
  P_stp := 'VOCI_TOTALE-01';
  INSERT INTO CALCOLI_CONTABILI
  ( ci
  , voce
  , sub
  , riferimento
  , input
  , estrazione
  , tar
  , qta
  , imp
  , risorsa_intervento, capitolo, articolo, conto
  , impegno, anno_impegno, sub_impegno, anno_sub_impegno
  , anno_del, sede_del, numero_del, delibera  -- modifica del 28/04/2004
  , ipn_c
  , ipn_s
  , ipn_p
  , ipn_l
  , ipn_e
  , ipn_t
  , ipn_a
  , ipn_ap
  , ipn_eap
  , codice_siope
  )
  SELECT P_ci
       , tovo.voce_acc
       , '*'
       , P_al
       , DECODE( P_tipo||P_estrazione
              , 'AAP', '*'  -- Voci prodotte in mensilita` Aggiuntiva
                          -- utili solo per il calcolo
                    , 'C'
              )
       , 'T'
       , SUM( DECODE( tovo.anno
                    , 'C', DECODE( caco.ipn_p
                                 , NULL, NVL(caco.tar,0)
                                       , NVL(caco.tar,0)
                                       - NVL(caco.ipn_eap,0)
                                 )
                    , 'P', DECODE( TO_CHAR(caco.riferimento,'yyyy')
                                 , TO_CHAR(P_fin_ela,'yyyy'), NVL(caco.ipn_eap,0)
                                                            , NVL(caco.tar,0)
                                 )
                    , 'M', DECODE( caco.ipn_p
                                 , NULL, NVL(caco.tar,0)
                                       , NVL(caco.tar,0)
                                       - NVL(caco.ipn_eap,0)
                                 )
                         , NVL(caco.tar,0)
                    ) * DECODE( NVL(tovo.tipo,'T')
                              , 'T', 1, 'V', 1, 'B', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
        +SUM( NVL(caco.qta,0) * DECODE( NVL(tovo.tipo,'T'), '1', 1, 0 )
                              * NVL(tovo.per_tot,100) / 100
            )
        +SUM( DECODE( tovo.anno
                    , 'C', NVL(caco.imp,0) - NVL(ipn_p,0)
                    , 'P', DECODE
                          ( TO_CHAR(caco.riferimento,'yyyy')
                          , TO_CHAR(P_fin_ela,'yyyy'), NVL(caco.ipn_p,0)
                            , NVL(caco.imp,0)
                          )
                    , 'M', NVL(caco.imp,0) - NVL(ipn_p,0)
                         , NVL(caco.imp,0)
                    ) * DECODE( NVL(tovo.tipo,'T'), '2', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
           ) 
       , SUM( NVL(caco.qta,0) * DECODE( NVL(tovo.tipo,'Q')
                                      , 'Q', 1, 'B', 1, 'D', 1, 0 )
                              * NVL(tovo.per_tot,100) / 100
           )
       , SUM( DECODE( tovo.anno
                    , 'C', NVL(caco.imp,0) - NVL(ipn_p,0)
                    , 'P', DECODE
                          ( TO_CHAR(caco.riferimento,'yyyy')
                          , TO_CHAR(P_fin_ela,'yyyy'), NVL(caco.ipn_p,0)
                            , NVL(caco.imp,0)
                          )
                    , 'M', NVL(caco.imp,0) - NVL(ipn_p,0)
                         , NVL(caco.imp,0)
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
       , caco.risorsa_intervento, caco.capitolo, caco.articolo, caco.conto
       , caco.impegno, caco.anno_impegno, caco.sub_impegno, caco.anno_sub_impegno
/* modifica del 23/07/2007 */
       , nvl(caco.anno_del,covo.anno_del)
       , nvl(caco.sede_del,covo.sede_del)
       , nvl(caco.numero_del,covo.numero_del)
       , caco.delibera
/* fine modifica del 23/07/2007 */
       , SUM( DECODE( tovo.anno
                    , 'P', DECODE(caco.ipn_c,NULL,NULL,0)
                         , NVL(caco.ipn_c,caco.imp)
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
       , SUM( DECODE( tovo.anno
                    , 'P', DECODE(caco.ipn_s,NULL,NULL,0)
                         , caco.ipn_s
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
           )
       , SUM( DECODE( tovo.anno
                    , 'P' , caco.ipn_p
                    , 'A' , caco.ipn_p
                    , NULL, caco.ipn_p
                          , DECODE(caco.ipn_p,NULL,NULL,0)
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
           )
       , SUM( DECODE( tovo.anno
                    , 'P', DECODE(caco.ipn_l,NULL,NULL,0)
                         , caco.ipn_l
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
       , SUM( DECODE( tovo.anno
                    , 'P', DECODE(caco.ipn_e,NULL,NULL,0)
                         , caco.ipn_e
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
       , SUM( DECODE( tovo.anno
                    , 'P', DECODE(caco.ipn_t,NULL,NULL,0)
                         , caco.ipn_t
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
       , SUM( DECODE( tovo.anno
                    , 'P', DECODE(caco.ipn_a,NULL,NULL,0)
                         , caco.ipn_a
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
       , SUM( DECODE( tovo.anno
                    , 'P', DECODE(caco.ipn_ap,NULL,NULL,0)
                         , caco.ipn_ap
                    ) * DECODE( NVL(tovo.tipo,'I')
                              , 'I', 1, 'V', 1, 'D', 1, 0 )
                      * NVL(tovo.per_tot,100) / 100
            )
       , SUM( DECODE
             ( caco.ipn_p
             , NULL, caco.ipn_eap
                   , DECODE( tovo.anno
                           , 'P' , caco.ipn_eap
                           , 'A' , caco.ipn_eap
                           , NULL, caco.ipn_eap
                                 , DECODE(caco.ipn_eap,NULL,NULL,0)
                           )
             ) * DECODE( NVL(tovo.tipo,'T')
                       , 'T', 1, 'V', 1, 'B', 1, 0 )
               * NVL(tovo.per_tot,100) / 100
            )
        , caco.codice_siope
    FROM CONTABILITA_VOCE    covo
       , VOCI_ECONOMICHE  voec
       , TOTALIZZAZIONI_VOCE tovo
/* modifica del 28/04/2004 */
       , PERIODI_GIURIDICI   pegi
/* fine modifica del 28/04/2004 */
       , CALCOLI_CONTABILI   caco
   WHERE covo.voce       = caco.voce||''
     AND covo.sub        = caco.sub
     AND P_al      BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
                     AND NVL(covo.al ,TO_DATE(3333333,'j'))
     AND voec.codice     = tovo.voce_acc||''
     AND voec.classe||'' = 'T'
     AND tovo.voce       =    caco.voce||''
     AND NVL(tovo.sub, caco.sub) = caco.sub
/* modifica del 28/04/2004 */
     and pegi.ci(+)        = caco.ci
     and pegi.rilevanza(+) = 'P'
     and caco.riferimento  between nvl(pegi.dal (+), to_date(2222222,'j'))
                               and nvl(pegi.al (+), to_date(3333333,'j'))
/* fine modifica del 28/04/2004 */
     AND caco.ci          = P_ci
     AND caco.estrazione   = P_estrazione
     AND caco.riferimento  BETWEEN NVL(tovo.dal,TO_DATE(2222222,'j'))
                            AND NVL(tovo.al ,TO_DATE(3333333,'j'))
     AND NVL(caco.arr,' ') =
        DECODE
        ( tovo.anno
        , 'C', DECODE
               ( TO_CHAR(caco.riferimento,'yyyy')
               , TO_CHAR(P_fin_ela,'yyyy'), NVL(caco.arr,' ')
                                      , NULL
               )
        , 'P', DECODE
               ( TO_CHAR(caco.riferimento,'yyyy')
               , TO_CHAR(P_fin_ela,'yyyy'), DECODE
                                        ( NVL(caco.ipn_p,0)
                                        , 0, NULL
                                           , NVL(caco.arr,' ')
                                        )
                                      , NVL(caco.arr,' ')
               )
        , 'M', ' '
        , 'A', caco.arr
             , NVL(caco.arr,' ')
        )
   GROUP BY tovo.voce_acc
/* modifica del 28/04/2004 */
          , pegi.al
/* fine modifica del 28/04/2004 */
         , caco.risorsa_intervento, caco.capitolo, caco.articolo, caco.conto
         , caco.impegno, caco.anno_impegno, caco.sub_impegno, caco.anno_sub_impegno
/* modifica del 23/07/2007 */
         , nvl(caco.anno_del,covo.anno_del)
         , nvl(caco.sede_del,covo.sede_del)
         , nvl(caco.numero_del,covo.numero_del)
         , caco.delibera
--         , caco.anno_del, caco.sede_del, caco.numero_del, caco.delibera 
         , caco.codice_siope
/* fine modifica del 23/07/2007 */
   ;
  log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/*   Versione della Where precedente (piu` lenta???)
    from calcoli_contabili   caco
       , totalizzazioni_voce tovo
   where tovo.voce_acc  in
        (select voec.codice
          from contabilita_voce covo
             , voci_economiche  voec
         where covo.voce       = voec.codice||''
           and covo.sub       = '*'
           and P_al      between nvl(covo.dal,to_date(2222222,'j'))
                           and nvl(covo.al ,to_date(3333333,'j'))
           and voec.classe     = 'T'
        )
     and caco.ci          = P_ci
     and caco.estrazione   = P_estrazione
     and caco.riferimento  between nvl(tovo.dal,to_date(2222222,'j'))
                            and nvl(tovo.al ,to_date(3333333,'j'))
     and nvl(caco.arr,' ') =
        decode( tovo.anno
              , 'C', decode( caco.arr, 'P', null, nvl(caco.arr,' ') )
              , 'P', 'P'
              , 'M', ' '
              , 'A', caco.arr
                  , nvl(caco.arr,' ')
              )
     and caco.voce       =    tovo.voce||''
     and caco.sub       = nvl(tovo.sub, caco.sub)
*/
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
-- Trace di LOG su table Segnalazioni
--
--  Richiamo della Trace
--  --------------------
--  D_stp := 'XXXX_XXXXXXXXXX-01';
--  ...step...
--  log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
--
PROCEDURE log_trace
(
 p_trc    IN     NUMBER   -- Tipo di Trace
,p_prn    IN     NUMBER   -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER   -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER   -- Numero progressivo di Segnalazione
,p_stp    IN     VARCHAR2     -- Identificazione dello Step in oggetto
,p_cnt    IN     NUMBER   -- Count delle row trattate
,p_tim    IN OUT VARCHAR2     -- Time impiegato in secondi
) IS
 d_systime       NUMBER;
 d_ora          VARCHAR2(8); -- Ora:minuti.secondi
BEGIN
 IF P_trc IS NOT NULL THEN
  d_systime := TO_NUMBER(TO_CHAR(SYSDATE,'sssss'));
  IF d_systime < TO_NUMBER(P_tim) THEN
     P_tim := TO_CHAR(86400 - TO_NUMBER(P_tim) + d_systime);
  ELSE
     P_tim := TO_CHAR( d_systime - TO_NUMBER(P_tim));
  END IF;
  d_ora := TO_CHAR(SYSDATE,'hh24:mi.ss');
  P_prs := P_prs+1;
  IF P_trc = 0 THEN  -- Segnalazione di Start
     INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES(P_prn,P_pas,P_prs,'P05800',
                 RPAD(SUBSTR(P_stp,1,20),20)||
                 ' h.'||d_ora
                );
  ELSIF
     P_trc = 1 THEN  -- Trace di singolo step
     INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES(P_prn,P_pas,P_prs,'P05801',
                 RPAD(SUBSTR(P_stp,1,20),20)||
                 ' h.'||d_ora||' ('||P_tim||
                 '") #<'||TO_CHAR(P_cnt)||'>'
                );
  ELSIF
     P_trc = 2 THEN  -- Segnalazione di Stop
     INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES(P_prn,P_pas,P_prs,'P05802',
                 RPAD(SUBSTR(P_stp,1,20),20)||
                 ' h.'||d_ora||' ('||P_tim||'")'
                );
  ELSIF
     P_trc = 6 THEN  -- per Situazione Detrazioni/Deduzioni Incongruente
     INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES(P_prn,P_pas,P_prs,'P05342',
                 RPAD(SUBSTR(P_stp,1,20),20)
                );
  ELSIF
     P_trc = 7 THEN  -- per Netti Negativi
     INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES(P_prn,P_pas,P_prs,'P05830',
                 RPAD(SUBSTR(P_stp,1,20),20)
                );
  ELSIF
     P_trc = 8 THEN  -- per Warning
     INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES(P_prn,P_pas,P_prs,'P05808',
                 RPAD(SUBSTR(P_stp,1,20),20)||
                 ' h.'||d_ora
                );
  END IF;
 END IF;
  P_tim := TO_CHAR(SYSDATE,'sssss');
END;
-- Trace di Errore su table di Segnalazioni
--
PROCEDURE err_trace
(
 p_trc    IN     NUMBER  -- Tipo di Trace
,p_prn    IN     NUMBER  -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER  -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER  -- Numero progressivo di Segnalazione
,p_stp    IN     VARCHAR2    -- Identificazione dello Step in oggetto
,p_cnt    IN     NUMBER  -- Count delle row trattate
,p_tim    IN OUT VARCHAR2    -- Time impiegato in secondi
) IS
d_sqe VARCHAR2(50);  -- Errore Oracle
BEGIN
  D_sqe := SUBSTR(SQLERRM,1,50);
  ROLLBACK;
  BEGIN  -- Preleva numero max di segnalazioni rimaste causa ROLLBACK
     SELECT NVL(MAX(progressivo),0)
       INTO P_prs
       FROM a_segnalazioni_errore
      WHERE no_prenotazione = P_prn
        AND passo          = P_pas
     ;
  END;
  log_trace(1,P_prn,P_pas,P_prs,P_stp,P_cnt,P_tim);
  P_prs := P_prs+1;
  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
        VALUES(P_prn,P_pas,P_prs,'P05809',d_sqe);
  COMMIT;
END;
-- Calcolo Retribuzioni
--
-- Procedura di Calcolo Movimenti Retributivi
--
PROCEDURE calcolo
IS
-- Dati per gestione TRACE
d_trc          NUMBER(1);  -- Tipo di Trace
d_prn          NUMBER(6);  -- Numero di Prenotazione
d_pas          NUMBER(2);  -- Numero di Passo procedurale
d_prs          NUMBER(10); -- Numero progressivo di Segnalazione
d_stp          VARCHAR2(50);   -- Identificazione dello Step in oggetto
d_cnt          NUMBER(5);  -- Count delle row trattate
d_tim          VARCHAR2(5);    -- Time impiegato in secondi
d_tim_ci       VARCHAR2(5);    -- Time impiegato in secondi del Cod.Ind.
d_tim_tot       VARCHAR2(5);    -- Time impiegato in secondi Totale
--
-- Dati per deposito informazioni generali
d_anno         MOVIMENTI_FISCALI.anno%TYPE;
d_mese         MOVIMENTI_FISCALI.mese%TYPE;
d_mensilita     MOVIMENTI_FISCALI.MENSILITA%TYPE;
d_fin_ela       DATE;
d_tipo         VARCHAR2(1);
d_mens_codice   VARCHAR2(4);
d_periodo       VARCHAR2(1);
d_base_ratei    VARCHAR2(1);
d_base_det      VARCHAR2(1);
d_mesi_irpef    NUMBER(2);
d_base_cong     VARCHAR2(1);
d_scad_cong     VARCHAR2(1);
d_rest_cong     VARCHAR2(1);
d_rate_addizionali NUMBER(2);
d_detrazioni_ap    VARCHAR2(2);
D_add_reg_veneto NUMBER(15,5);
D_caso_particolare NUMBER(1);
-- Voci per gestione Carico Familiare
D_ass_fam VOCI_ECONOMICHE.codice%TYPE;
D_det_con VOCI_ECONOMICHE.codice%TYPE;
D_det_fig VOCI_ECONOMICHE.codice%TYPE;
D_det_alt VOCI_ECONOMICHE.codice%TYPE;
D_det_spe VOCI_ECONOMICHE.codice%TYPE;
D_det_ult VOCI_ECONOMICHE.codice%TYPE;
-- Voci per gestione T.F.R.
d_riv_tfr VOCI_ECONOMICHE.codice%TYPE;
d_ret_tfr VOCI_ECONOMICHE.codice%TYPE;
d_qta_tfr VOCI_ECONOMICHE.codice%TYPE;
d_rit_tfr VOCI_ECONOMICHE.codice%TYPE;
d_rit_riv VOCI_ECONOMICHE.codice%TYPE;
d_lor_tfr VOCI_ECONOMICHE.codice%TYPE;
d_lor_tfr_00 VOCI_ECONOMICHE.codice%TYPE;
d_lor_riv VOCI_ECONOMICHE.codice%TYPE;
d_cal_anz VOCI_ECONOMICHE.specifica%TYPE;
-- Voci per gestione Netto
D_comp    VOCI_ECONOMICHE.codice%TYPE;
D_trat    VOCI_ECONOMICHE.codice%TYPE;
D_netto   VOCI_ECONOMICHE.codice%TYPE;
D_add_irpef  VOCI_ECONOMICHE.codice%TYPE;
D_add_irpefs VOCI_ECONOMICHE.codice%TYPE;
D_add_irpefp VOCI_ECONOMICHE.codice%TYPE;
D_add_reg_so VOCI_ECONOMICHE.codice%TYPE;
D_add_reg_pa VOCI_ECONOMICHE.codice%TYPE;
D_add_reg_ra VOCI_ECONOMICHE.codice%TYPE;
D_add_prov   VOCI_ECONOMICHE.codice%TYPE;
D_add_provs  VOCI_ECONOMICHE.codice%TYPE;
D_add_provp  VOCI_ECONOMICHE.codice%TYPE;
D_add_pro_so VOCI_ECONOMICHE.codice%TYPE;
D_add_pro_pa VOCI_ECONOMICHE.codice%TYPE;
D_add_pro_ra VOCI_ECONOMICHE.codice%TYPE;
D_add_comu   VOCI_ECONOMICHE.codice%TYPE;
D_add_comus  VOCI_ECONOMICHE.codice%TYPE;
D_add_comup  VOCI_ECONOMICHE.codice%TYPE;
D_add_com_so VOCI_ECONOMICHE.codice%TYPE;
D_add_com_pa VOCI_ECONOMICHE.codice%TYPE;
D_add_com_ra VOCI_ECONOMICHE.codice%TYPE;
--
CURSOR C_SEL_RAGI
( P_ci_start NUMBER
) IS
SELECT ragi.ROWID
    , ragi.ci
    , ragi.al
    , ragi.cong_ind
    , ragi.d_cong
    , ragi.d_cong_al
    , ragi.cassa_competenza                  -- 02/05/2007
 FROM RAPPORTI_GIURIDICI ragi
    , RAPPORTI_DIVERSI   radi
	, rapporti_individuali rain
WHERE flag_elab = 'P'
  AND ragi.ci = radi.ci (+)
  AND nvl(radi.rilevanza(+),'E') = 'E'
  AND radi.anno (+) = D_anno
--  AND ragi.ci > P_ci_start
  and ragi.ci  = rain.ci
		  and (rain.cc is null
		       or exists
			   (select 'x'
			    from   a_competenze
				where  ente       = w_ente
				and    ambiente   = w_ambiente
				and    utente     = w_utente
				and    competenza ='CI'
				and    oggetto    = rain.cc
				)
			)
  order by nvl(radi.ci_erede,ragi.ci)
;
CURSOR C_UPD_RAGI
( p_rowid VARCHAR2
, p_ci NUMBER
) IS
SELECT 'x'
 FROM RAPPORTI_GIURIDICI
 WHERE ROWID     = P_rowid
  AND ci       = P_ci
  AND flag_elab = 'P'
  FOR UPDATE OF flag_elab NOWAIT
;
D_ROW_RAGI           C_UPD_RAGI%ROWTYPE;
BEGIN
-- determinazione personalizzazioni
 IF w_prenotazione = 0 THEN
  w_ente := si4.ente;
  w_ambiente := si4.ambiente;
  w_utente := si4.utente;
 END IF;
 w_personalizzazioni := TO_CHAR(NULL);
 BEGIN
   select g.note
     into w_personalizzazioni
     from gp4_personalizzazioni g
        , ad4_enti a
    where w_ente = a.ente
      and substr(a.note,instr(a.note,'=') + 1,10) = g.cliente
      and g.voce_menu = 'PXXCMORE'
      and g.tipo = 'P'
   ;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     w_personalizzazioni := TO_CHAR(NULL);
  END;
  BEGIN  -- Assegnazioni Iniziali per Trace
     D_prn := w_prenotazione;
     D_pas := w_passo;
     IF D_prn = 0 THEN
        D_trc := 1;
        DELETE FROM a_segnalazioni_errore
        WHERE no_prenotazione = D_prn
          AND passo          = D_pas
        ;
     ELSE
        D_trc := NULL;
     END IF;
     BEGIN  -- Preleva numero max di segnalazione
        SELECT NVL(MAX(progressivo),0)
         INTO D_prs
         FROM a_segnalazioni_errore
        WHERE no_prenotazione = D_prn
          AND passo          = D_pas
        ;
     END;
  END;
  BEGIN  -- Segnalazione Iniziale
     D_stp     := 'PECCMORE-Start';
     D_tim     := TO_CHAR(SYSDATE,'sssss');
     D_tim_tot := TO_CHAR(SYSDATE,'sssss');
     log_trace(0,D_prn,D_pas,D_prs,D_stp,0,D_tim);
     COMMIT;
  END;
  BEGIN  -- Periodo in elaborazione
     D_stp := 'CALCOLO-01';
     SELECT rire.anno, rire.mese, rire.MENSILITA
         , rire.fin_ela
         , mens.tipo
         , mens.codice
         , mens.periodo
       INTO D_anno, D_mese, D_mensilita
         , D_fin_ela
         , D_tipo
         , D_mens_codice
         , D_periodo
       FROM RIFERIMENTO_RETRIBUZIONE rire
         , MENSILITA mens
      WHERE mens.mese      = rire.mese
        AND mens.MENSILITA = rire.MENSILITA
     ;
     log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  END;
  BEGIN  -- Dati dell'Ente
     D_stp := 'CALCOLO-02';
     SELECT ratei, DETRAZIONI
         , mesi_irpef, base_cong, scad_cong, rest_cong
         , rate_addizionali, detrazioni_ap
         , 0, 0
       INTO D_base_ratei, D_base_det
         , D_mesi_irpef, D_base_cong, D_scad_cong, D_rest_cong
         , D_rate_addizionali, D_detrazioni_ap
         , d_add_reg_veneto, d_caso_particolare
       FROM ENTE
     ;
     log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  END;
  BEGIN  -- Preleva Codice di Voci Fisse
     D_stp := 'CALCOLO-03';
     SELECT MAX( DECODE( automatismo, 'ASS_FAM', codice, NULL ) )
         , MAX( DECODE( automatismo, 'DET_CON', codice, NULL ) )
         , MAX( DECODE( automatismo, 'DET_FIG', codice, NULL ) )
         , MAX( DECODE( automatismo, 'DET_ALT', codice, NULL ) )
         , MAX( DECODE( automatismo, 'DET_SPE', codice, NULL ) )
         , MAX( DECODE( automatismo, 'DET_ULT', codice, NULL ) )
         , MAX( DECODE( automatismo, 'RIV_TFR', codice, NULL ) )
         , MAX( DECODE( automatismo, 'RET_TFR', codice, NULL ) )
         , MAX( DECODE( automatismo, 'QTA_TFR', codice, NULL ) )
         , MAX( DECODE( automatismo, 'RIT_TFR', codice, NULL ) )
         , MAX( DECODE( automatismo, 'RIT_RIV', codice, NULL ) )
         , MAX( DECODE( automatismo, 'LOR_TFR', codice, NULL ) )
         , MAX( DECODE( automatismo, 'LOR_TFR_00', codice, NULL ) )
         , MAX( DECODE( automatismo, 'LOR_RIV', codice, NULL ) )
         , MAX( DECODE( automatismo, 'IRPEF_LIQ', specifica, NULL ) )
         , MAX( DECODE( automatismo, 'COMP'   , codice, NULL ) )
         , MAX( DECODE( automatismo, 'TRAT'   , codice, NULL ) )
         , MAX( DECODE( automatismo, 'NETTO'  , codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_IRPEF' , codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_IRPEFS', codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_IRPEFP', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_REG_SO', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_REG_PA', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_REG_RA', codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_PROV' , codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_PROVS', codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_PROVP', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_PRO_SO', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_PRO_PA', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_PRO_RA', codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_COMU'  , codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_COMUS' , codice, NULL ) )
         , MAX( DECODE( automatismo, 'ADD_COMUP' , codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_COM_SO', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_COM_PA', codice, NULL ) )
         , MAX( DECODE( specifica, 'ADD_COM_RA', codice, NULL ) )
       INTO D_ass_fam
         , D_det_con
         , D_det_fig
         , D_det_alt
         , D_det_spe
         , D_det_ult
         , D_riv_tfr
         , D_ret_tfr
         , D_qta_tfr
         , D_rit_tfr
         , D_rit_riv
         , D_lor_tfr
         , D_lor_tfr_00
         , D_lor_riv
         , D_cal_anz
         , D_comp
         , D_trat
         , D_netto
         , D_add_irpef
         , D_add_irpefs
         , D_add_irpefp
         , D_add_reg_so
         , D_add_reg_pa
         , D_add_reg_ra
         , D_add_prov
         , D_add_provs
         , D_add_provp
         , D_add_pro_so
         , D_add_pro_pa
         , D_add_pro_ra
         , D_add_comu
         , D_add_comus
         , D_add_comup
         , D_add_com_so
         , D_add_com_pa
         , D_add_com_ra
       FROM VOCI_ECONOMICHE
      WHERE automatismo IN
          ( 'ASS_FAM'
          , 'DET_CON', 'DET_FIG', 'DET_ALT', 'DET_SPE', 'DET_ULT'
          , 'RIV_TFR', 'RET_TFR', 'QTA_TFR', 'RIT_TFR', 'RIT_RIV'
		  , 'LOR_TFR', 'LOR_TFR_00', 'LOR_RIV'
          , 'IRPEF_LIQ', 'COMP'   , 'TRAT'   , 'NETTO'
          , 'ADD_IRPEF', 'ADD_IRPEFS', 'ADD_IRPEFP'
          , 'ADD_PROV', 'ADD_PROVS', 'ADD_PROVP'
          , 'ADD_COMU', 'ADD_COMUS', 'ADD_COMUP'
          )
        OR specifica IN
          ( 'ADD_REG_SO', 'ADD_REG_PA', 'ADD_REG_RA'
          , 'ADD_PRO_SO', 'ADD_PRO_PA', 'ADD_PRO_RA'
          , 'ADD_COM_SO', 'ADD_COM_PA', 'ADD_COM_RA'
          )
     ;
     log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  END;
  <<ciclo_ci>>
  DECLARE
  D_dep_ci      NUMBER;    -- Codice Individuale per Ripristino LOOP
  D_ci_start    NUMBER;    -- Codice Individuale di partenza LOOP
  D_cc         VARCHAR2(30);  -- Codice di Competenza individuale
  D_ni         NUMBER;    -- Numero Individuale Anagrafico
  D_count_ci    NUMBER;    -- Contatore ciclico Individui trattati
  non_competente EXCEPTION;
  --
  BEGIN  -- Ciclo su Individui
     D_dep_ci   := 0;  -- Disattivazione iniziale del Ripristino
     D_ci_start := 0;  -- Attivazione partenza del Ciclo Individui
     D_count_ci := 0;  -- Azzeramento iniziale contatore Individui
     LOOP  -- Ripristino Ciclo su Individui:
          -- - in caso di Errore su Individuo
          -- - in caso di LOOP ciclico per rilascio ROLLBACK_SEGMENTS
     FOR RAGI IN C_SEL_RAGI (D_ci_start)
     LOOP
     <<tratta_ci>>
     BEGIN
        D_count_ci := D_count_ci + 1;
        D_tim_ci := TO_CHAR(SYSDATE,'sssss');
        BEGIN  -- Preleva Competenza sull'individuo
          D_stp    := 'CALCOLO-04';
          SELECT cc
               , ni
            INTO d_cc
               , d_ni
            FROM RAPPORTI_INDIVIDUALI
           WHERE ci  = ragi.ci
          ;
          log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               RAISE non_competente;
        END;
        IF D_cc IS NOT NULL THEN
          BEGIN  -- Varifica Competenza sull'Individuo
             D_stp := 'CALCOLO-05';
             SELECT 'x'
               INTO w_dummy
               FROM a_competenze
              WHERE utente      = w_utente
               AND ambiente    = w_ambiente
               AND ENTE       = W_ENTE
               AND competenza  = 'CI'
               AND oggetto     = D_cc
             ;
             RAISE TOO_MANY_ROWS;
          EXCEPTION
             WHEN TOO_MANY_ROWS THEN
                 log_trace
                  (D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
             WHEN NO_DATA_FOUND THEN
                 RAISE non_competente;
          END;
        END IF;
        BEGIN  -- Allocazione individuo
          D_stp    := 'CALCOLO-06';
          OPEN C_UPD_RAGI (ragi.ROWID,ragi.ci);
          FETCH C_UPD_RAGI INTO D_ROW_RAGI;
          IF C_UPD_RAGI%NOTFOUND THEN
             RAISE TIMEOUT_ON_RESOURCE;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
             RAISE TIMEOUT_ON_RESOURCE;
        END;
        BEGIN  -- Calcolo Individuo
          Peccmore1.CALCOLO_CI  -- Calcolo voci retributive individuali
             ( ragi.ci, D_ni
             , LEAST( NVL(ragi.al,TO_DATE('3333333','j'))
                   , D_fin_ela
                   )  -- Data di termine o fine mese
             , D_base_ratei, D_base_det, D_mesi_irpef
             , D_base_cong, D_scad_cong, D_rest_cong
             , D_rate_addizionali, D_detrazioni_ap
             , D_add_reg_veneto                            -- 20/12/2005
             , D_caso_particolare                          -- 20/12/2005
             , D_anno, D_mese, D_mensilita, D_fin_ela
             , D_tipo, D_mens_codice, D_periodo, ragi.cassa_competenza   -- 02/05/2007
             , D_ass_fam
             , D_det_con, D_det_fig, D_det_alt, D_det_spe, D_det_ult
             , D_riv_tfr, D_ret_tfr, D_qta_tfr, D_rit_tfr, D_rit_riv
             , D_lor_tfr, D_lor_tfr_00, D_lor_riv
			 , D_cal_anz, D_comp   , D_trat   , D_netto
             , D_add_irpef, D_add_irpefs, D_add_irpefp
             , D_add_reg_so, D_add_reg_pa, D_add_reg_ra
             , D_add_prov, D_add_provs, D_add_provp
             , D_add_pro_so, D_add_pro_pa, D_add_pro_ra
             , D_add_comu, D_add_comus, D_add_comup
             , D_add_com_so, D_add_com_pa, D_add_com_ra
             , D_trc, D_prn, D_pas, D_prs, D_stp, D_tim
	  );
	  EXCEPTION WHEN FORM_TRIGGER_FAILURE THEN
               BEGIN  -- Preleva numero max di segnalazione
                 SELECT NVL(MAX(progressivo),0)
                   INTO D_prs
                   FROM a_segnalazioni_errore
                  WHERE no_prenotazione = D_prn
                    AND passo          = D_pas
                 ;
               END;
               D_stp := '!!! Error #'||TO_CHAR(ragi.ci);
               log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci);
               W_errore := 'P05809';   -- Errore in Elaborazione
               err_passo := D_stp;      -- Step Errato
               COMMIT;
               CLOSE C_UPD_RAGI;
               D_dep_ci := ragi.ci;  -- Attivazione Ripristino LOOP
               EXIT;               -- Uscita dal LOOP
        END;
        BEGIN  -- Rilascio Individuo Elaborato
          D_stp := 'CALCOLO-07';
          UPDATE RAPPORTI_GIURIDICI
             SET flag_elab = 'E'
           WHERE CURRENT OF C_UPD_RAGI
          ;
          log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
          CLOSE C_UPD_RAGI;
        END;
        BEGIN  -- Trace per Fine Individuo
          D_stp := 'Complete #'||TO_CHAR(ragi.ci);
          log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci);
        END;
        BEGIN  -- Validazione Individuo Elaborato
          COMMIT;
        END;
     EXCEPTION
        WHEN non_competente THEN  -- Individuo non Competente
            NULL;
        WHEN TIMEOUT_ON_RESOURCE THEN
          D_stp := '!!! Reject #'||TO_CHAR(ragi.ci);
          log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci);
          IF W_errore != 'P05809' THEN  -- Errore in Elaborazione
             W_errore := 'P05808';  -- Segnalazione in Elab.
          END IF;
          COMMIT;
          CLOSE C_UPD_RAGI;
     END tratta_ci;
     D_trc := NULL;  -- Disattiva Trace dettagliata dopo primo Individuo
     BEGIN  -- Uscita dal ciclo ogni 10 Individui
           -- per rilascio ROLLBACK_SEGMENTS di Read_consistency
           -- cursor di select su RAPPORTI_GIURIDICI
        IF D_count_ci = 10 THEN
          D_count_ci := 0;
          D_dep_ci   := ragi.ci;  -- Attivazione Ripristino LOOP
          EXIT;                 -- Uscita dal LOOP
        END IF;
     END;
     END LOOP;  -- Fine LOOP su Ciclo Individui
     IF D_dep_ci = 0 THEN
        EXIT;
     ELSE
        D_ci_start := D_dep_ci;
        D_dep_ci   := 0;
     END IF;
     END LOOP;  -- Fine LOOP per Ripristino Ciclo Individui
     BEGIN  -- Operazioni finali per Trace
        D_stp := 'PECCMORE-Stop';
        log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_tot);
        IF W_errore != 'P05809' AND   -- Errore
          W_errore != 'P05342' AND   -- Dizionari Fiscali Incongruenti
          W_errore != 'P05830' AND   -- Netti Negativi
          W_errore != 'P05808' THEN  -- Segnalazione
          W_errore := 'P05802';      -- Elaborazione Completata
        END IF;
        COMMIT;
     END;
  END ciclo_ci;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN  -- Errore gestito in sub-procedure
     W_errore := 'P05809';   -- Errore in Elaborazione
     err_passo := D_stp;      -- Step Errato
  WHEN OTHERS THEN
     err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
     W_errore := 'P05809';   -- Errore in Elaborazione
     err_passo := D_stp;      -- Step Errato
END;
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER,PASSO IN NUMBER) IS
BEGIN
 IF prenotazione != 0 THEN
  BEGIN  -- Preleva utente da depositare in campi Global
   SELECT utente
      , ambiente
      , ENTE
      , gruppo_ling
     INTO w_utente
      , w_ambiente
      , W_ENTE
      , w_lingua
     FROM a_prenotazioni
    WHERE no_prenotazione = prenotazione
   ;
  EXCEPTION
   WHEN OTHERS THEN NULL;
  END;
 ELSE -- prenotazione = 0
  w_ente := si4.ente;
  w_ambiente := si4.ambiente;
  w_utente := si4.utente;
 END IF;
 w_personalizzazioni := TO_CHAR(NULL);
 BEGIN
   select g.note
     into w_personalizzazioni
     from gp4_personalizzazioni g
        , ad4_enti a
    where w_ente = a.ente
      and substr(a.note,instr(a.note,'=') + 1,10) = g.cliente
      and g.voce_menu = 'PXXCMORE'
      and g.tipo = 'P'
   ;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     w_personalizzazioni := TO_CHAR(NULL);
  END;
 w_prenotazione := prenotazione;
 w_passo := passo;
 w_errore := TO_CHAR(NULL);
 CALCOLO;  -- Esecuzione del Calcolo Cedolino
IF w_prenotazione != 0 THEN
  IF W_errore in ('P05808','P05342') THEN
   UPDATE a_prenotazioni
    SET errore = 'P05808'
    WHERE no_prenotazione = w_prenotazione
   ;
   COMMIT;
  ELSIF
   W_errore = 'P05830' THEN
   UPDATE a_prenotazioni
    SET errore = 'P05830'
    WHERE no_prenotazione = w_prenotazione
   ;
   COMMIT;
  ELSIF
   SUBSTR(W_errore,6,1) = '9' THEN
   UPDATE a_prenotazioni
    SET errore   = 'P05809'
      , prossimo_passo = 91
    WHERE no_prenotazione = w_prenotazione
   ;
   COMMIT;
  END IF;
 END IF;
EXCEPTION
 WHEN OTHERS THEN
  BEGIN
   ROLLBACK;
   IF w_prenotazione != 0 THEN
    UPDATE a_prenotazioni
     SET errore   = '*Abort*'
       , prossimo_passo = 99
    WHERE no_prenotazione = w_prenotazione
    ;
    COMMIT;
   END IF;
  EXCEPTION
   WHEN OTHERS THEN
		NULL;
  END;
END;
END;
/
