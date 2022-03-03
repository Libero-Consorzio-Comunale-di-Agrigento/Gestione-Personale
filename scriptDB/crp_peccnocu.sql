CREATE OR REPLACE PACKAGE PECCNOCU IS

/******************************************************************************
 NOME:          PECCNOCU
 DESCRIZIONE:   Archiviazione NOTE_CUD per Modello CUD e 770

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003 
 2    13/02/2004 NN     Adeguamento modifiche per CUD 2004   
 2.1  23/12/2004 MS     Modifiche per att. 8898 
 3.0  19/01/2005 MS     Modifiche per Rev. CUD/2005 
 3.1  01/02/2005 MS     Controllo per voce di menu a parte    
 3.2  01/03/2005 MS     Mod. per attivita 9946              
 3.3  03/03/2005 MS     Mod. per attivita 10008
 3.4  08/03/2005 MS     Mod. per attivita 10108
 3.5  15/04/2005 CB     Mod. per attivita 10478
 3.6  10/01/2006 MS     Modifiche per Rev. CUD/2006 - att. 12856
 3.7  27/01/2006 MS     Correzioni da test Att. 14619
 3.8  02/02/2006 MS     Correzioni da test Att. 13956
 3.9  10/03/2006 MS     Correzioni su segnalazioni varie ( att- 15266 - 15270 )
 4.0  14/03/2006 MS     Mod. estrazione tfr per privati ( att. 15370 )
 4.1  29/08/2006 MS     Mod. insert del passo seer er Att. 17360
 4.2  22/01/2007 MS     Attivazione multilinguismo 
 5.0  26/01/2007 MS     Modifiche per Rev. CUD/2007 - att. 14948
 5.1  31/01/2007 MS     Correzioni da test priorità 1
 5.2  22/03/2007 MS     Correzioni da segnalazioni cliente - att. 20231
 5.3  04/04/2007 MS     Inserimento note Libere per addizionali
 5.4  08/05/2007 MS     Inserimento note Libere per esezione addizionale comunale 
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCNOCU IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V5.4 del 08/05/2007';
   END VERSIONE;

 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  D_ente               VARCHAR(4);
  D_ambiente           VARCHAR(8);
  D_utente             VARCHAR(8);
  D_gruppo_ling        VARCHAR(1);  -- per multilinguismo
  D_lingua_dip         VARCHAR(1);  -- per multilinguismo
  D_lingua_dip_2       VARCHAR(1);  -- per multilinguismo
  D_def_lingua         VARCHAR(1);  -- per multilinguismo
  D_anno               VARCHAR(4);
  D_ini_a              VARCHAR(8);
  D_fin_a              VARCHAR(8);
  D_ini_as             VARCHAR(8);
  D_fin_as             VARCHAR(8);
  D_gestione           VARCHAR(4);
  P_sfasato            VARCHAR2(1);
  D_tipo               VARCHAR(1);
  D_dal                DATE;
  D_al                 DATE;
  D_ci                 NUMBER(8);
  D_sequenza           NUMBER(8) := 0;
  D_riga               NUMBER := 0;
  D_errore             VARCHAR(200);
  D_tipo_spese         VARCHAR(2);
  D_spese              NUMBER(2);
  D_attr_spese_x_gg    NUMBER(1);
  D_somme_00           NUMBER(20,5);
  D_somme_09           NUMBER(20,5);
  D_ded_fis            NUMBER(20,5);
  D_ded_base           NUMBER(20,5);
  D_ded_agg            NUMBER(20,5);
  D_lor_liq_ac         NUMBER(20,5);
  D_lor_liq_ap         NUMBER(20,5);
  D_lor_liq_2000       NUMBER(20,5);
  D_lor_liq_ap_2000    NUMBER(20,5);
  D_riv_tfr            NUMBER(20,5);
  D_rit_riv            NUMBER(20,5);
  D_oneri_01           NUMBER(20,5);
  D_oneri_02           NUMBER(20,5);
  D_oneri_03           NUMBER(20,5);
  D_oneri_04           NUMBER(20,5);
  D_oneri_05           NUMBER(20,5);
  D_oneri_06           NUMBER(20,5);
  D_oneri_07           NUMBER(20,5);
  D_oneri_08           NUMBER(20,5);
  D_oneri_09           NUMBER(20,5);
  D_oneri_10           NUMBER(20,5);
  D_oneri_11           NUMBER(20,5);
  D_oneri_12           NUMBER(20,5);
  D_oneri_13           NUMBER(20,5);
  D_oneri_14           NUMBER(20,5);
  D_oneri_15           NUMBER(20,5);
  D_oneri_16           NUMBER(20,5);
  D_oneri_17           NUMBER(20,5);
  D_oneri_18           NUMBER(20,5);
  D_oneri_19           NUMBER(20,5);
  D_oneri_20           NUMBER(20,5);
  D_oneri_21           NUMBER(20,5);
  D_oneri_22           NUMBER(20,5);
  D_oneri_23           NUMBER(20,5);
  D_oneri_24           NUMBER(20,5);
  D_oneri_25           NUMBER(20,5);
  D_oneri_26           NUMBER(20,5);
  D_oneri_27           NUMBER(20,5);
  D_oneri_28           NUMBER(20,5);
  D_oneri_29           NUMBER(20,5);
  D_somme_01           NUMBER(20,5);
  D_somme_02           NUMBER(20,5);
  D_somme_03           NUMBER(20,5);
  D_somme_04           NUMBER(20,5);
  D_somme_05           NUMBER(20,5);
  D_somme_06           NUMBER(20,5);
  D_somme_07           NUMBER(20,5);
  D_somme_08           NUMBER(20,5);
  D_ci_erede           NUMBER(8);
  D_tipo_erede         NUMBER;
  D_quota_erede        NUMBER;
  D_pens               VARCHAR(2);
  D_nota_add_reg       NUMBER(20,5);
  D_nota_add_com       NUMBER(20,5);
  D_add_irpef_comu     NUMBER(15,5); -- addizionale comunale da PRFI
  D_acconto_com        NUMBER(15,5); -- acconto addizionale caricato in INRA
  D_acconto_com_trat   NUMBER(15,5); -- acconto addizionale da MOCO
  D_det_con_ac         NUMBER(15,5);
  D_det_fig_ac         NUMBER(15,5);
  D_det_alt_ac         NUMBER(15,5);
  D_det_spe_ac         NUMBER(15,5);
  D_det_ass_ac         NUMBER(15,5);
  D_det_god            NUMBER(15,5);
  d_note_a_r_cr        NUMBER(20,5);
  d_note_a_r_crc       NUMBER(20,5);
  d_note_cr            NUMBER(20,5);
  d_note_a_c_cr        NUMBER(20,5);
  d_note_a_c_crc       NUMBER(20,5);
  D_add_reg_730        NUMBER(20,5);
  D_add_com_730        NUMBER(20,5);
  D_credito_730        NUMBER(20,5);
  D_note_al            VARCHAR(2000);
  D_note_al_al1        VARCHAR(2000);   -- per multilinguismo
  D_note_TFR           VARCHAR(2000);
  D_intesta_periodi    VARCHAR(2000); 
  D_intesta_periodi_al1 VARCHAR(2000);  -- per multilinguismo
  D_note_periodi       VARCHAR(2000);
  D_descr_rapporto     VARCHAR(30);
  D_descr_rapporto_al1 VARCHAR(30);     -- per multilinguismo
  D_descr_tempo_det    VARCHAR(40);
  D_descr_tempo_det_al1 VARCHAR(40);    -- per multilinguismo
  D_conta_rapporti     NUMBER;
  D_conta_periodi      NUMBER;
  V_errore             varchar2(6);
  V_controllo          varchar2(1) := null ;
  USCITA   EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
  BEGIN
    SELECT valore
      INTO D_tipo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_tipo := NULL;
  END;
-- dbms_output.put_Line('Tipo: '||D_tipo);
  BEGIN
    SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/',
           'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
      INTO D_dal
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_DAL'
    ;
    SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/',
           'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
      INTO D_al
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_AL'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT ini_ela,fin_ela
        INTO D_dal,D_al
        FROM RIFERIMENTO_RETRIBUZIONE
       WHERE rire_id = 'RIRE'
      ;
  END;
-- dbms_output.put_Line('Dal: '||to_char(D_dal)||' al: '||to_char(D_al));
  BEGIN
    SELECT valore
      INTO D_ci
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ci := 0;
  END;
  V_errore := null;
  IF nvl(D_ci,0) = 0 and D_tipo = 'S' THEN
     V_errore := 'A05721';
     RAISE USCITA;
  ELSIF nvl(D_ci,0) != 0 and D_tipo = 'T' THEN
     V_errore := 'A05721';
     RAISE USCITA;
  END IF;
-- dbms_output.put_Line('CI: '||to_char(D_ci));
  BEGIN
    SELECT valore
      INTO D_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GESTIONE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_gestione := NULL;
  END;
-- dbms_output.put_Line('gestione: '||D_gestione);

 BEGIN
  SELECT valore
    INTO P_sfasato
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ANNO_SFASATO'
   ;
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_sfasato := null;
 END;

V_errore := null;
IF P_sfasato = 'X' THEN
  BEGIN
   select 'X' 
     into V_controllo
     from gestioni
    where codice = D_gestione 
      and D_gestione != '%';
  EXCEPTION 
   WHEN NO_DATA_FOUND THEN 
     IF D_tipo = 'S' THEN NULL;
     ELSE 
     V_errore := 'P05130';
     RAISE USCITA;
     END IF;
   WHEN OTHERS THEN NULL;
  END;
END IF;
  BEGIN
    SELECT valore
         , '0101'||valore
         , '3112'||valore
      INTO D_anno
         , D_ini_a
         , D_fin_a
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT anno
           , '0101'||TO_CHAR(anno)
           , '3112'||TO_CHAR(anno)
        INTO D_anno
           , D_ini_a
           , D_fin_a
        FROM RIFERIMENTO_FINE_ANNO
       WHERE rifa_id = 'RIFA'
      ;
  END;

  D_ini_as := '0112'||to_number(D_anno-1);
  D_fin_as := '3011'||D_anno;

-- dbms_output.put_Line('Anno: '||(D_anno)||' ini: '||(d_ini_a)||' fin: '||(d_fin_a));
  BEGIN
    SELECT ENTE        D_ente
         , utente      D_utente
         , ambiente    D_ambiente
         , gruppo_ling D_gruppo_ling
      INTO D_ente,D_utente,D_ambiente,D_gruppo_ling
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ente     := NULL;
      D_utente   := NULL;
      D_ambiente := NULL;
  END;
  BEGIN
    SELECT valore
      INTO D_def_lingua
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_DEF_LINGUA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
         select valore_default
           INTO D_def_lingua
           from a_selezioni
          where parametro = 'P_DEF_LINGUA'
            and voce_menu in ( select voce_menu
                                 from a_prenotazioni
                                WHERE no_prenotazione = prenotazione
                             )
         ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           D_def_lingua := null;
      END;
  END;
--
-- Cancellazione Archiviazione precedente relativa all'anno richiesto
--
  LOCK TABLE NOTE_CUD IN EXCLUSIVE MODE NOWAIT
  ;
  DELETE FROM NOTE_CUD nocu
   WHERE nocu.anno = D_anno
     AND nocu.ci IN (SELECT ci
                      FROM PERIODI_RETRIBUTIVI
                     WHERE nocu.ci = ci
                       AND gestione LIKE nvl(D_gestione,'%'))
     AND (    D_tipo = 'T'
           OR ( D_tipo IN ('I','V','P') AND NOT EXISTS
                 (SELECT 'x' FROM NOTE_CUD
                   WHERE anno       = nocu.anno
                     AND ci         = nocu.ci
                     AND NVL(tipo_agg,' ') = DECODE(D_tipo
                                                    ,'P',tipo_agg,
                                                        D_tipo)
                 )
              )
           OR ( D_tipo = 'C' AND (EXISTS
                 (SELECT 'x'
                    FROM RIFERIMENTO_RETRIBUZIONE rire
                       , PERIODI_GIURIDICI pegi
                   WHERE rire.rire_id        = 'RIRE'
                     AND pegi.rilevanza = 'P'
                     AND pegi.ci         = nocu.ci
                     AND pegi.dal        =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= NVL(D_al,rire.fin_ela)
                         )
                     AND pegi.al BETWEEN NVL(D_dal,rire.ini_ela)
                                     AND NVL(D_al,rire.fin_ela)
                 )
                 OR EXISTS
                 (SELECT 'x'
                    FROM RIFERIMENTO_RETRIBUZIONE  rire
                       , PERIODI_GIURIDICI pegi
                   WHERE rire.rire_id        = 'RIRE'
                     AND pegi.rilevanza = 'P'
                     AND pegi.ci        = nocu.ci
                     AND pegi.dal       =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= NVL(D_al,rire.fin_ela)
                         )
                     AND pegi.al <=
                         (SELECT LAST_DAY
                                 (TO_DATE
                                 (MAX(LPAD(TO_CHAR(mese),2,'0')||
                                 TO_CHAR(anno)),'mmyyyy'))
                            FROM MOVIMENTI_FISCALI
                           WHERE ci       = pegi.ci
                             AND LAST_DAY
                                 (TO_DATE
                                 (LPAD(TO_CHAR(mese),2,'0')||
                                 TO_CHAR(anno),'mmyyyy'))
                                 BETWEEN NVL(D_dal,rire.ini_ela)
                                     AND NVL(D_al,rire.fin_ela)
                             AND NVL(ipn_ord,0)  + NVL(ipn_liq,0)
                                 +NVL(ipn_ap,0)  + NVL(lor_liq,0)
                                 +NVL(lor_acc,0) != 0
                             AND MENSILITA != '*AP'
                         )
                 ))
              )
           OR (D_tipo = 'S' AND nocu.ci = D_ci
              )
          )
     AND EXISTS
        (SELECT 'x'
           FROM RAPPORTI_INDIVIDUALI rain
          WHERE rain.ci = nocu.ci
            AND (   rain.CC IS NULL
                 OR EXISTS
                   (SELECT 'x'
                      FROM a_competenze
                     WHERE ENTE        = D_ente
                       AND ambiente    = D_ambiente
                       AND utente      = D_utente
                       AND competenza  = 'CI'
                       AND oggetto     = rain.CC
                   )
                )
        )
  ;
 COMMIT;
 FOR CUR_CI IN
   (SELECT defi.ci,
           defi.c1,
           defi.c2,
           defi.c36,
           defi.c3,
           defi.c4,
           defi.c6,
           defi.c7,
           defi.c8,
           defi.c9,
           defi.c10,
           defi.c37,
           defi.c13,
           defi.c60,
           defi.c17,
           defi.c26,
           defi.c27,
           defi.c33,
           defi.c34,
           defi.c40,
           defi.c43,
           defi.c45,
           defi.c46,
           defi.c69,
           defi.c70,
           defi.c71,
           defi.c139
      FROM denuncia_fiscale     defi
      WHERE defi.rilevanza = 'T'
        AND defi.anno      = D_anno
        AND EXISTS (select 'x'
                      FROM PERIODI_RETRIBUTIVI  pere
                     WHERE pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                                            AND TO_DATE(D_fin_a,'ddmmyyyy')
                       AND pere.competenza    = 'A'
                       AND pere.gestione   LIKE nvl(D_gestione,'%')
                       AND pere.ci            = defi.ci
                   )
        AND (    D_tipo = 'T'
           OR ( D_tipo IN ('I','V','P') AND NOT EXISTS
                 (SELECT 'x' FROM NOTE_CUD 
                   WHERE anno       = defi.anno
                     AND ci         = defi.ci
                     AND NVL(tipo_agg,' ') = DECODE(D_tipo
                                                    ,'P',tipo_agg,
                                                        D_tipo)
                 )
              )
           OR ( D_tipo = 'C' AND (EXISTS
                 (SELECT 'x'
                    FROM RIFERIMENTO_RETRIBUZIONE rire
                       , PERIODI_GIURIDICI pegi
                   WHERE rire.rire_id        = 'RIRE'
                     AND pegi.rilevanza = 'P'
                     AND pegi.ci         = defi.ci
                     AND pegi.dal        =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= NVL(D_al,rire.fin_ela)
                         )
                     AND pegi.al BETWEEN NVL(D_dal,rire.ini_ela)
                                     AND NVL(D_al,rire.fin_ela)
                 )
                 OR EXISTS
                 (SELECT 'x'
                    FROM RIFERIMENTO_RETRIBUZIONE  rire
                       , PERIODI_GIURIDICI pegi
                   WHERE rire.rire_id        = 'RIRE'
                     AND pegi.rilevanza = 'P'
                     AND pegi.ci        = defi.ci
                     AND pegi.dal       =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= NVL(D_al,rire.fin_ela)
                         )
                     AND pegi.al <=
                         (SELECT LAST_DAY
                                 (TO_DATE
                                 (MAX(LPAD(TO_CHAR(mese),2,'0')||
                                 TO_CHAR(anno)),'mmyyyy'))
                            FROM MOVIMENTI_FISCALI
                           WHERE ci       = pegi.ci
                             AND LAST_DAY
                                 (TO_DATE
                                 (LPAD(TO_CHAR(mese),2,'0')||
                                 TO_CHAR(anno),'mmyyyy'))
                                 BETWEEN NVL(D_dal,rire.ini_ela)
                                     AND NVL(D_al,rire.fin_ela)
                             AND NVL(ipn_ord,0)  + NVL(ipn_liq,0)
                                 +NVL(ipn_ap,0)  + NVL(lor_liq,0)
                                 +NVL(lor_acc,0) != 0
                             AND MENSILITA != '*AP'
                         )
                 ))
              )
          )
     AND EXISTS
        (SELECT 'x'
           FROM RAPPORTI_INDIVIDUALI rain
          WHERE rain.ci = defi.ci
            AND (   rain.CC IS NULL
                 OR EXISTS
                   (SELECT 'x'
                      FROM a_competenze
                     WHERE ENTE        = D_ente
                       AND ambiente    = D_ambiente
                       AND utente      = D_utente
                       AND competenza  = 'CI'
                       AND oggetto     = rain.CC
                   )
                )
        )
	AND D_tipo != 'S'
	UNION ALL
     SELECT defi.ci,
           defi.c1,
           defi.c2,
           defi.c36,
           defi.c3,
           defi.c4,
           defi.c6,
           defi.c7,
           defi.c8,
           defi.c9,
           defi.c10,
           defi.c37,
           defi.c13,
           defi.c60,
           defi.c17,
           defi.c26,
           defi.c27,
           defi.c33,
           defi.c34,
           defi.c40,
           defi.c43,
           defi.c45,
           defi.c46,
           defi.c69,
           defi.c70,
           defi.c71,
           defi.c139
       FROM denuncia_fiscale     defi
      WHERE defi.rilevanza = 'T'
        AND D_tipo  = 'S'
        AND defi.ci = D_ci
        AND defi.anno      = D_anno
        AND EXISTS (select 'x'
                      FROM PERIODI_RETRIBUTIVI  pere
                     WHERE pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                                            AND TO_DATE(D_fin_a,'ddmmyyyy')
                       AND pere.competenza    = 'A'
                       AND pere.gestione   LIKE nvl(D_gestione,'%')
                       AND pere.ci            = defi.ci
                   )
        AND EXISTS
           (SELECT 'x'
              FROM RAPPORTI_INDIVIDUALI rain
             WHERE rain.ci = defi.ci
              AND (   rain.CC IS NULL
                  OR EXISTS
                    (SELECT 'x'
                       FROM a_competenze
                      WHERE ENTE        = D_ente
                        AND ambiente    = D_ambiente
                        AND utente      = D_utente
                        AND competenza  = 'CI'
                        AND oggetto     = rain.CC
                    )
                 )
           )
   )LOOP

    D_acconto_com_trat  := null;  
    D_add_irpef_comu    := null;

    BEGIN
    <<NOTE>>
-- dbms_output.put_Line('CI: '||to_char(CUR_CI.ci));
     BEGIN
       SELECT tipo_spese,
              decode(attribuzione_spese,null,1,3,1,null),
              spese
         INTO d_tipo_spese,
              d_attr_spese_x_gg,
              d_spese
         FROM RAPPORTI_RETRIBUTIVI_STORICI rars
        WHERE ci = CUR_CI.ci
          AND TO_DATE(D_fin_a,'ddmmyyyy') BETWEEN NVL(rars.dal,TO_DATE('2222222','j'))
                                              AND NVL(rars.al,TO_DATE('3333333','j'))
       ;
      EXCEPTION
        WHEN TOO_MANY_ROWS THEN
          D_tipo_spese      := NULL;
          D_spese           := NULL;
          D_attr_spese_x_gg := NULL;
          D_riga := D_riga +1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo ,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,'P01065',substr('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
        WHEN NO_DATA_FOUND THEN
          D_tipo_spese      := NULL;
          D_spese           := NULL;
          D_attr_spese_x_gg := NULL;
          D_riga := D_riga +1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,'P05700',substr('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
      END;
      BEGIN
       SELECT quota_erede,tipo_erede,ci_erede
         INTO D_quota_erede,d_tipo_erede,d_ci_erede
         FROM RAPPORTI_DIVERSI radi
        WHERE ci = CUR_CI.ci
          AND rilevanza = 'E'
          AND anno = D_anno
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         D_quota_erede := null;
         D_tipo_erede  := null;
         D_ci_erede    := null;
     END;
--
-- Estrazione dati da progressivi fiscali
--
     BEGIN
       select nvl(sum(prfi.ded_base_ac),0) + nvl(sum(prfi.ded_agg_ac),0)
            , nvl(sum(prfi.ded_base_ac),0)
            , nvl(sum(prfi.ded_agg_ac),0)
            , NVL(SUM(prfi.lor_acc),0) +
              NVL(SUM(prfi.lor_liq),0)
            , DECODE( NVL(SUM(prfi.lor_acc),0) +
                      NVL(SUM(prfi.lor_acc_2000),0) +
                      NVL(SUM(prfi.lor_liq),0)
                      , 0, 0
                         , NVL(SUM(prfi.ant_liq_ap),0) +
                           NVL(SUM(prfi.ant_acc_ap),0)
                    ) 
            , NVL(SUM(prfi.lor_acc_2000),0)
            , DECODE( NVL(SUM(prfi.lor_acc_2000),0)
                    , 0, 0
                       , NVL(SUM(prfi.ant_acc_2000),0)
                    )
            , NVL(SUM(prfi.riv_tfr_ap_liq),0) + NVL(SUM(prfi.riv_tfr_liq),0)
            , NVL(SUM(prfi.add_irpef_comunale_pag),0) 
            , nvl(sum(prfi.det_con_ac),0)
            , nvl(sum(prfi.det_fig_ac),0)
            , nvl(sum(prfi.det_alt_ac),0)
            , nvl(sum(prfi.det_spe_ac),0)
            , NVL(SUM(prfi.det_fis),0) -
              NVL(SUM(prfi.det_con),0) -
              NVL(SUM(prfi.det_fig),0) -
              NVL(SUM(prfi.det_alt),0) -
              NVL(SUM(prfi.det_spe),0) -
              NVL(SUM(prfi.det_ult),0)  
            , DECODE( SIGN( NVL(SUM(prfi.ipt_ac),0) - NVL(SUM(prfi.det_fis),0) )
                     , -1, NVL(SUM(prfi.ipt_ac),0)
                         , NVL(SUM(prfi.det_fis),0))
         into D_ded_fis
            , D_ded_base
            , D_ded_agg
            , D_lor_liq_ac
            , D_lor_liq_ap
            , D_lor_liq_2000
            , D_lor_liq_ap_2000
            , D_riv_tfr
            , D_add_irpef_comu
            , D_det_con_ac
            , D_det_fig_ac
            , D_det_alt_ac
            , D_det_spe_ac
            , D_det_ass_ac
            , D_det_god
         FROM progressivi_fiscali   prfi
        WHERE prfi.anno         = D_anno
          AND prfi.mese         = 12
          AND prfi.MENSILITA    = (SELECT MAX(MENSILITA)
                                     FROM MENSILITA
                                     WHERE mese = 12
                                       AND tipo IN ('A','N','S'))
          AND prfi.ci           = CUR_CI.ci
        ;
      END;
    IF nvl(d_lor_liq_2000,0) + nvl(d_lor_liq_ac,0) + nvl(d_lor_liq_ap_2000,0) + nvl(d_lor_liq_ap,0)
     + nvl(D_riv_tfr,0) != 0 THEN
     BEGIN
       select NVL(SUM(prfi.rit_riv),0)
         into D_rit_riv
         FROM progressivi_fiscali   prfi
        WHERE prfi.anno between 2001 and D_anno
          AND prfi.mese         = 12
          AND prfi.MENSILITA    = (SELECT MAX(MENSILITA)
                                     FROM MENSILITA
                                     WHERE mese = 12
                                       AND tipo IN ('A','N','S'))
          AND prfi.ci           = CUR_CI.ci
         having NVL(SUM(prfi.rit_riv),0) > 0
        ;
      EXCEPTION WHEN NO_DATA_FOUND THEN D_rit_riv := 0;
      END;
    END IF;

     --
     --  Estrazione acconto addizionale da INRE anno corrente ( casella 7 Bis anno precedente ) 
     --
     BEGIN
      select nvl(imp_tot,0)
        into D_acconto_com
        from informazioni_retributive
       where ci = CUR_CI.ci
         and to_char(dal,'yyyy') = D_anno
         and voce in ( select codice 
                         from voci_economiche
                        where specifica = 'ADD_COM_AC'
                     )
         and sub = substr(D_anno,3,2)
        ;
     EXCEPTION 
          WHEN NO_DATA_FOUND THEN
               D_acconto_com := 0;
          WHEN TOO_MANY_ROWS THEN
               D_acconto_com := 0;
               D_riga       := D_riga +1; 
               -- Esiste Informazione Retributiva collegata a
               INSERT INTO a_segnalazioni_errore
               (no_prenotazione,passo,progressivo,errore,precisazione)
               select prenotazione,1,D_riga,'P05728',substr(' CI: '||TO_CHAR(CUR_CI.ci)||' - Controllare AINRA',1,200)
                 from dual
                where not exists ( select 'x'
                                     from a_segnalazioni_errore
                                    where no_prenotazione = prenotazione
                                      and passo = 1
                                      and errore = 'P05728'
                                      and precisazione = substr(' CI: '||TO_CHAR(CUR_CI.ci)||' - Controllare AINRA',1,200)
                                 );
     END;
     --
     --  Estrazione saldo acconto addizionale comunale trattenuto
     --
     BEGIN
      select sum(decode(voec.tipo,'T',nvl(moco.imp,0)*-1,nvl(moco.imp,0)))
        into D_acconto_com_trat
        from movimenti_contabili moco
           , voci_economiche     voec
       where moco.ci  in ( select CUR_CI.ci
                               FROM dual
                              UNION
                             SELECT ci_erede
                               FROM RAPPORTI_DIVERSI radi
                              WHERE CUR_CI.ci = radi.ci
                                AND radi.rilevanza = 'R'
                                AND radi.anno = D_anno
                         )
         AND moco.anno = D_anno
         AND moco.mensilita != '*AP' 
         and moco.voce = voec.codice 
         and voec.specifica = 'ADD_COM_AC'
         and moco.sub = substr(D_anno,3,2)
        ;
     EXCEPTION 
          WHEN NO_DATA_FOUND THEN
               D_acconto_com_trat := 0;
          WHEN TOO_MANY_ROWS THEN
               D_acconto_com_trat := 0;
    END;
--
-- Estrazione dati da valori contabili
--
     BEGIN
        SELECT NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_01', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_01
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_02', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_02
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_03', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_03
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_04', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_04',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_04',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_04
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_05', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_05',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_05',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_05
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_06', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_06',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_06',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_06
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_07', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_07',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_07',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_07
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_08', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_08',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_08',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_08
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_09', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_09',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_09',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_09
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_10', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_10',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_10',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_10
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_11', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_11',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_11',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_11
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_12', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_12',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_12',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_12
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_13', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_13',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_13',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_13
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_14', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_14',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_14',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_14
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_15', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_15',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_15',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_15
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_16', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_16',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_16',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_16
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_17', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_17',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_17',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_17
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_18', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_18',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_18',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_18
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_19', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_19',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_19',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_19
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_20', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_20',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_20',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_20
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_21', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_21',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_21',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_21
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_22', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_22',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_22',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)          oneri_22
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_23', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_23',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_23',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)        oneri_23
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_24', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_24',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_24',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)        oneri_24
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_25', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_25',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_25',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)        oneri_25
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_26', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_26',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_26',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)        oneri_26
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_27', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_27',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_27',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)        oneri_27
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_28', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_28',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_28',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)        oneri_28
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'ONERI_29', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'ONERI_29',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'ONERI_29',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)        oneri_29
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_01', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_01
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_02', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_02
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_03', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_03
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_04', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_04',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_04',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_04
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_05', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_05',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_05',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_05
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_06', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_06',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_06',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_06
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_07', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_07',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_07',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_07
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_08', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_08',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_08',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_08
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_00', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_00',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_00',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_00
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_09', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_09',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_09',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_09
          INTO D_oneri_01,D_oneri_02,D_oneri_03,D_oneri_04
             , D_oneri_05,D_oneri_06,D_oneri_07,D_oneri_08
             , D_oneri_09,D_oneri_10,D_oneri_11,D_oneri_12
             , D_oneri_13,D_oneri_14,D_oneri_15,D_oneri_16
             , D_oneri_17,D_oneri_18,D_oneri_19,D_oneri_20
             , D_oneri_21,D_oneri_22,D_oneri_23,D_oneri_24
             , D_oneri_25,D_oneri_26,D_oneri_27,D_oneri_28, D_oneri_29
             , D_somme_01,D_somme_02,D_somme_03,D_somme_04
             , D_somme_05,D_somme_06,D_somme_07,D_somme_08
             , D_somme_00,D_somme_09
          FROM valori_contabili_annuali vaca
             , ESTRAZIONE_VALORI_CONTABILI esvc
         WHERE vaca.anno       = D_anno
           AND vaca.mese       = 12
           AND vaca.MENSILITA  = (SELECT MAX(MENSILITA)
                                    FROM MENSILITA
                                   WHERE mese = 12
                                     AND tipo IN ('A','N','S'))
           AND vaca.estrazione = 'DENUNCIA_CUD'
           AND vaca.ci         = CUR_CI.ci
           AND vaca.moco_mensilita != '*AP'
           AND esvc.estrazione        = vaca.estrazione
           AND esvc.colonna           = vaca.colonna
           AND vaca.riferimento BETWEEN esvc.dal
                                     AND NVL(esvc.al,TO_DATE('3333333','j'))
         ;
      END;
      BEGIN
       select decode
             ( nvl(instr(upper(nvl(pegi.note,' '))
                        ,'CASELLARIO DELLE PENSIONI')
                        ,0)
                        , '0','0','1')
          into D_pens
          from periodi_giuridici pegi
         where pegi.rilevanza = 'S'
           and pegi.ci        = CUR_CI.ci
           and pegi.dal       = (select max(dal)
                                   from periodi_giuridici
                                  where rilevanza = 'S'
                                    and ci        = CUR_CI.ci
                                    and dal      <= TO_DATE(D_fin_a,'ddmmyyyy'))
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
	    D_pens := null;
      END;         
      BEGIN
        select sum(imp)
          into D_nota_add_reg
          from movimenti_contabili
         where anno  = D_Anno
           and ci    = CUR_CI.ci
           and mensilita != '*AP'
           and to_char(riferimento,'yyyy') = D_anno
           and voce in (select codice 
                          from voci_economiche
                         where specifica = 'ADD_REG_SO')
        ;  
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          D_nota_add_reg := 0;
      END;
      BEGIN
        select sum(imp)
          into D_nota_add_com
          from movimenti_contabili
         where anno  = D_Anno
           and ci    = CUR_CI.ci
           and mensilita != '*AP'
           and to_char(riferimento,'yyyy') = D_anno
           and voce in (select codice
                          from voci_economiche
                         where specifica = 'ADD_COM_SO')
        ;  
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
           D_nota_add_com := 0;
      END;

    D_sequenza := 0;
    FOR CUR_LINGUA in
    ( select decode( nvl(instr(upper(rain.note),'LINGUA '),0)
                    , 0, anag.gruppo_ling
                       , substr( upper(rain.note) , instr(upper(rain.note),'LINGUA ')+7, 1)
                   )  lingua_dip
            , 0  seq
         from anagrafici anag
            , rapporti_individuali rain
        where rain.ci = CUR_CI.ci
          and rain.ni = anag.ni
          and anag.al is null
    ) LOOP
   
    BEGIN
    select decode(D_def_lingua,'X','I',CUR_lingua.lingua_dip)
      into D_lingua_dip
      from dual
    ;
    select decode(D_def_lingua,'X','D','')
      into D_lingua_dip_2
      from dual
    ;
/* Nota AB - CUD 2007 */
     D_sequenza := 1 + CUR_LINGUA.seq;
-- dbms_output.put_line('Nota AC');
      INSERT INTO NOTE_CUD 
     (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
            select d_anno, CUR_CI.ci, 'AB', D_sequenza
                 , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_1', D_gruppo_ling, D_lingua_dip )
                 ||decode(nvl(CUR_CI.c8,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_2', D_gruppo_ling, D_lingua_dip  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c8)||'.'
                         )
                 ||decode(nvl(CUR_CI.c9,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_3', D_gruppo_ling, D_lingua_dip  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c9)||'.'
                         )
                 ||decode(nvl(CUR_CI.c10,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_4', D_gruppo_ling, D_lingua_dip  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c10)||'.'
                         )
                 ||decode(nvl(CUR_CI.c37,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_5', D_gruppo_ling, D_lingua_dip  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c37)||'.'
                         )
                 ||decode(nvl(CUR_CI.c13,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_6', D_gruppo_ling, D_lingua_dip  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c13)||'.'
                         )
                 ||decode(nvl(CUR_CI.c60,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_7', D_gruppo_ling, D_lingua_dip  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c60)||'.'
                         )
                 , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_1', D_gruppo_ling, D_lingua_dip_2 )
                 ||decode(nvl(CUR_CI.c8,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_2', D_gruppo_ling, D_lingua_dip_2  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c8)||'.'
                         )
                 ||decode(nvl(CUR_CI.c9,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_3', D_gruppo_ling, D_lingua_dip_2  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c9)||'.'
                         )
                 ||decode(nvl(CUR_CI.c10,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_4', D_gruppo_ling, D_lingua_dip_2  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c10)||'.'
                         )
                 ||decode(nvl(CUR_CI.c37,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_5', D_gruppo_ling, D_lingua_dip_2  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c37)||'.'
                         )
                 ||decode(nvl(CUR_CI.c13,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_6', D_gruppo_ling, D_lingua_dip_2  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c13)||'.'
                         )
                 ||decode(nvl(CUR_CI.c60,0)
                         ,0 , null
                            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AB_7', D_gruppo_ling, D_lingua_dip_2  )
                            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c60)||'.'
                         )
              , D_utente, SYSDATE
          from dual
          where ( nvl(CUR_CI.c8,0) != 0
               or nvl(CUR_CI.c9,0) != 0
               or nvl(CUR_CI.c10,0) != 0
               or nvl(CUR_CI.c37,0) != 0
               or nvl(CUR_CI.c13,0) != 0
               or nvl(CUR_CI.c60,0) != 0
               )
        ;
-- dbms_output.put_line('Fine Nota AB');

/* Nota AC - CUD 2007 */
     D_sequenza := 3 + CUR_LINGUA.seq;
-- dbms_output.put_line('Nota AC');
      INSERT INTO NOTE_CUD 
     (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
            select d_anno, CUR_CI.ci, 'AC', D_sequenza
                 , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_1', D_gruppo_ling, D_lingua_dip )
                 ||anag.codice_fiscale 
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_2', D_gruppo_ling, D_lingua_dip  )
                 ||anag.cognome||' '||anag.nome
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_3', D_gruppo_ling, D_lingua_dip  )
                 ||anag.sesso||decode(anag.sesso
                                     ,'F', PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_4', D_gruppo_ling, D_lingua_dip  )
                                         , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_5', D_gruppo_ling, D_lingua_dip  ) 
                                     )
                 ||to_char(anag.data_nas,'dd/mm/yyyy')||'.'
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_6', D_gruppo_ling, D_lingua_dip  )
                 ||decode(nvl(CUR_CI.c69,0) + nvl(CUR_CI.c71,0)
                          ,0 ,null
                             ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_7', D_gruppo_ling, D_lingua_dip  )
                             ||decode(D_tipo_erede
                                    ,'1', PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_8', D_gruppo_ling, D_lingua_dip  )
                                        , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_9', D_gruppo_ling, D_lingua_dip  )
                                     )
                          )
                 , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_1', D_gruppo_ling, D_lingua_dip_2 )
                 ||anag.codice_fiscale 
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_2', D_gruppo_ling, D_lingua_dip_2  )
                 ||anag.cognome||' '||anag.nome
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||anag.sesso||decode(anag.sesso
                                     ,'F', PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_4', D_gruppo_ling, D_lingua_dip_2  )
                                         , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_5', D_gruppo_ling, D_lingua_dip_2  ) 
                                     )
                 ||to_char(anag.data_nas,'dd/mm/yyyy')||'. '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_6', D_gruppo_ling, D_lingua_dip_2 )
                 ||decode(nvl(CUR_CI.c69,0) + nvl(CUR_CI.c71,0)
                          ,0 ,null
                             ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_7', D_gruppo_ling, D_lingua_dip_2  )
                             ||decode(D_tipo_erede
                                    ,'1', PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_8', D_gruppo_ling, D_lingua_dip_2  )
                                        , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AC_9', D_gruppo_ling, D_lingua_dip_2  )
                                     )
                          )
                   , D_utente, SYSDATE
                from comuni            comu
                   , pec_ref_codes     reco
                   , anagrafici        anag
               where anag.ni     = 
                    (select ni
                       from rapporti_individuali
                      where ci = D_ci_erede)
                 and anag.al    is null
                 and D_quota_erede != 0
                 and comu.cod_comune      = anag.comune_nas
                 and comu.cod_provincia   = anag.provincia_nas
                 and reco.rv_domain       = 'RAPPORTI_RETRIBUTIVI.TIPO_EREDE'
                 and reco.rv_low_value    = D_tipo_erede
      ;
-- dbms_output.put_line('Fine Nota AC');

/* Nota AK - CUD 2007 */
-- dbms_output.put_line('Nota AK');
  IF nvl(CUR_CI.c1,0) != 0 or nvl(CUR_CI.c2,0) != 0 THEN
     D_sequenza := 10 + CUR_LINGUA.seq;
     INSERT INTO NOTE_CUD 
     (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
          select d_anno, CUR_CI.ci, 'AK', D_sequenza
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_1', D_gruppo_ling, D_lingua_dip  )
               ||decode( nvl(D_somme_09,0)
                        , 0, null
                           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_2', D_gruppo_ling, D_lingua_dip  )
                           ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_09)
                        )
               ||decode ( nvl(D_somme_09,0)
                        , 0, null
                           , decode( nvl(D_somme_00,0)
                                   , 0, null
                                      , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_3', D_gruppo_ling, D_lingua_dip  )
                                   )
                        )
               ||decode( nvl(D_somme_00,0)
                        , 0, null
                           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_4', D_gruppo_ling, D_lingua_dip  )
                           ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_00)
                           ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_5', D_gruppo_ling, D_lingua_dip  )
                        )
                  ||'.'
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_1', D_gruppo_ling, D_lingua_dip_2  )
               ||decode( nvl(D_somme_09,0)
                        , 0, null
                           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_2', D_gruppo_ling, D_lingua_dip_2  )
                           ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_09)
                        )
               ||decode ( nvl(D_somme_09,0)
                        , 0, null
                           , decode( nvl(D_somme_00,0)
                                   , 0, null
                                      , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_3', D_gruppo_ling, D_lingua_dip_2  )
                                   )
                        )
               ||decode( nvl(D_somme_00,0)
                        , 0, null
                           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_4', D_gruppo_ling, D_lingua_dip_2  )
                           ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_00)
                           ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AK_5', D_gruppo_ling, D_lingua_dip_2  )
                        )
                  ||'.'
               , D_utente, SYSDATE
            from dual
           where nvl(D_somme_00,0) + nvl(D_somme_09,0) != 0
      ;
  END IF; -- controllo su casella 1 e 2 != 0
-- dbms_output.put_line('Fine Nota AK');

-- dbms_output.put_line('Nota AL');
BEGIN
<<NOTA_AL>>
/* Nota AL - CUD 2007 */
  IF nvl(CUR_CI.c1,0) != 0 or nvl(CUR_CI.c2,0) != 0 THEN
    d_conta_rapporti := 0;
    D_note_AL := '';
    D_note_AL_al1 := '';
    FOR CUR_RAPP in (select 2,CUR_CI.ci ci,
                           null rilevanza
                      from dual
                     union
                    select 1,ci_erede ci,
                           rilevanza rilevanza
                      from rapporti_diversi
                     where ci = CUR_CI.ci
                       and rilevanza in ('R')
                       and anno = D_anno
                      order by 1,2
                   )
    LOOP
    BEGIN
        select decode( D_lingua_dip 
                     , grli1.gruppo_al, nvl(clra.descrizione, nvl(clra.descrizione_al1,clra.descrizione_al2))
                     , grli2.gruppo_al, nvl(clra.descrizione_al1, nvl(clra.descrizione,clra.descrizione_al2))
                     , grli3.gruppo_al, nvl(clra.descrizione_al2, nvl(clra.descrizione,clra.descrizione_al1))
                                      , nvl(clra.descrizione, nvl(clra.descrizione_al1,clra.descrizione_al2))
                     )
             , decode( D_lingua_dip_2
                     , grli1.gruppo_al, nvl(clra.descrizione, nvl(clra.descrizione_al1,clra.descrizione_al2))
                     , grli2.gruppo_al, nvl(clra.descrizione_al1, nvl(clra.descrizione,clra.descrizione_al2))
                     , grli3.gruppo_al, nvl(clra.descrizione_al2, nvl(clra.descrizione,clra.descrizione_al1))
                                      , nvl(clra.descrizione, nvl(clra.descrizione_al1,clra.descrizione_al2))
                     )
          into D_descr_rapporto, D_descr_rapporto_al1
          from  rapporti_individuali rain
              , classi_rapporto clra
              , ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
         where ente.ente_id       = 'ENTE'
           and rain.rapporto      = clra.codice
           and rain.ci            = CUR_RAPP.ci
           and (   nvl(CUR_RAPP.rilevanza,'z') != 'R'
              or ( CUR_RAPP.rilevanza = 'R' 
                 and exists ( select 'x'
                                from rapporti_individuali rain2
                               where rain2.ci = CUR_CI.ci
                                 and rain2.rapporto != rain.rapporto
                            )
                 )
               )
           and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                            , 'ENTE*', 'I'
                                                     , upper(D_gruppo_ling)
                                           )
           and grli1.sequenza      = 1
           and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                            , 'ENTE*', 'I'
                                                     , upper(D_gruppo_ling)
                                           )
           and grli2.sequenza      = 2
           and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                            , 'ENTE*', 'I'
                                                     , upper(D_gruppo_ling)
                                           )
           and grli3.sequenza      = 3
        ;
    EXCEPTION
      WHEN no_data_found THEN
           d_descr_rapporto := '';
           d_descr_rapporto_al1 := '';
    END;

    BEGIN
        select decode( posi.tempo_determinato
                      ,'SI', PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_3', D_gruppo_ling, D_lingua_dip  )
                           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_4', D_gruppo_ling, D_lingua_dip  ))
             , decode( posi.tempo_determinato
                      ,'SI', PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_3', D_gruppo_ling, D_lingua_dip_2  )
                           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_4', D_gruppo_ling, D_lingua_dip_2  ))
          into d_descr_tempo_det,d_descr_tempo_det_al1
          from periodi_giuridici pegi,
               posizioni posi
         where pegi.posizione = posi.codice
           and ci = CUR_RAPP.ci
           and rilevanza = 'S'
           and dal = (select max(pegi2.dal)
                        from periodi_giuridici pegi2
                       where pegi2.ci = CUR_RAPP.ci
                         and pegi2.rilevanza = 'S'
                         and pegi2.dal <= to_date(d_fin_a,'ddmmyyyy')
                     )
           and nvl(posi.collaboratore,'NO') = 'NO'
           and nvl(posi.amm_cons,'NO') = 'NO'
           and (d_descr_rapporto is not null or d_descr_rapporto_al1 is not null)
           and not exists (select 'x' from rapporti_diversi
                            where anno = D_anno
                              and ci   = CUR_RAPP.ci
                              and rilevanza = 'E')
        ;
    EXCEPTION
      WHEN no_data_found THEN
           d_descr_tempo_det := '';
           d_descr_tempo_det_al1 := '';
    END;
        D_conta_rapporti := D_conta_rapporti + 1;
        IF D_conta_rapporti = 1 then
           IF nvl(CUR_CI.c1,0) != 0 and nvl(CUR_CI.c2,0) != 0 then
                 D_note_AL := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_2', D_gruppo_ling, D_lingua_dip  );
                 D_note_AL_al1 := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_2', D_gruppo_ling, D_lingua_dip_2  );
           ELSIF nvl(CUR_CI.c1,0) != 0 and nvl(CUR_CI.c2,0) = 0 then
                 D_note_AL := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_1', D_gruppo_ling, D_lingua_dip  );
                 D_note_AL_al1 := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_1', D_gruppo_ling, D_lingua_dip_2  );
           ELSIF nvl(CUR_CI.c1,0) = 0 and nvl(CUR_CI.c2,0) != 0 then
                 D_note_AL := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_2', D_gruppo_ling, D_lingua_dip  );
                 D_note_AL_al1 := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_2', D_gruppo_ling, D_lingua_dip_2  );
           ELSE  D_note_AL := null; D_note_AL_al1 := null;
           END IF;
        END IF;
        IF nvl(CUR_CI.c1,0) + nvl(CUR_CI.c2,0) != 0 then
           IF D_conta_rapporti = 1 then
              D_note_AL := D_note_AL||d_descr_rapporto||d_descr_tempo_det;
              D_note_AL_al1 := D_note_AL_al1||d_descr_rapporto_al1||d_descr_tempo_det_al1;
           ELSIF nvl(d_descr_rapporto,' ') != ' ' or nvl(d_descr_rapporto_al1,' ') != ' ' then
              D_note_AL := D_note_AL||', '||d_descr_rapporto||d_descr_tempo_det;
              D_note_AL_al1 := D_note_AL_al1||', '||d_descr_rapporto_al1||d_descr_tempo_det_al1;
           END IF;
        END IF;
    END LOOP; -- CUR_RAPP

 D_note_periodi := null;
 D_conta_periodi := 0;
 D_intesta_periodi := null;
 D_intesta_periodi_al1 := null;

 IF nvl(CUR_CI.c3,0) between 1 and 364 or nvl(CUR_CI.c4,0) between 1 and 364 THEN
    d_conta_periodi := 0;
    d_note_periodi := '';
    FOR CUR_PEGI in (select decode( P_sfasato
                                   ,'X', to_char(greatest(to_date(d_ini_as,'ddmmyyyy'),pegi.dal),'dd/mm/yyyy')
                                       , to_char(greatest(to_date(d_ini_a,'ddmmyyyy'),pegi.dal),'dd/mm/yyyy')
                                  ) pegi_dal,
                            decode( P_sfasato
                                   ,'X', to_char(least(nvl(pegi.al,to_date(d_fin_a,'ddmmyyyy')),to_date(d_fin_as,'ddmmyyyy')),'dd/mm/yyyy')
                                       , to_char(least(nvl(pegi.al,to_date(d_fin_a,'ddmmyyyy')),to_date(d_fin_a,'ddmmyyyy')),'dd/mm/yyyy')
                                  )  pegi_al
                       from periodi_giuridici pegi
                      where pegi.ci in ( select CUR_CI.ci
                                           from dual
                                          union
                                         select ci_erede ci
                                           from rapporti_diversi
                                          where ci = CUR_CI.ci
                                            and rilevanza = 'R'
                                            and anno = D_anno
                                       )
                        and pegi.rilevanza = 'P'
                        and pegi.dal <= decode( P_sfasato,'X', to_date(d_fin_as,'ddmmyyyy') , to_date(d_fin_a,'ddmmyyyy'))
                        and nvl(pegi.al,decode( P_sfasato,'X',to_date(d_fin_as,'ddmmyyyy'), to_date(d_fin_a,'ddmmyyyy')))
                                >= decode( P_sfasato,'X', to_date(d_ini_as,'ddmmyyyy'), to_date(d_ini_a,'ddmmyyyy'))
                   order by decode( P_sfasato
                                   ,'X', greatest(to_date(d_ini_as,'ddmmyyyy'),pegi.dal)
                                       , greatest(to_date(d_ini_a,'ddmmyyyy'),pegi.dal)
                                  ),
                            decode( P_sfasato
                                   ,'X', least(nvl(pegi.al,to_date(d_fin_a,'ddmmyyyy')),to_date(d_fin_as,'ddmmyyyy'))
                                       , least(nvl(pegi.al,to_date(d_fin_a,'ddmmyyyy')),to_date(d_fin_a,'ddmmyyyy'))
                                  )
                    )
    LOOP
    BEGIN
        D_conta_periodi := D_conta_periodi + 1;
        IF D_conta_periodi = 1 then
           D_note_periodi := D_note_periodi||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'DAL', D_gruppo_ling, D_lingua_dip )
                             ||' '||CUR_PEGI.pegi_dal||' '||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'AL', D_gruppo_ling, D_lingua_dip )
                             ||' '||CUR_PEGI.pegi_al;
        ELSE
           D_note_periodi := D_note_periodi||', '||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'DAL', D_gruppo_ling, D_lingua_dip )
                             ||' '||CUR_PEGI.pegi_dal||' '||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'AL', D_gruppo_ling, D_lingua_dip )
                             ||' '||CUR_PEGI.pegi_al;
        END IF;
    END;
    END LOOP;  -- CUR_PEGI
        IF D_note_periodi is not null THEN D_note_periodi := D_note_periodi||'. ';
        END IF;
        IF D_conta_periodi = 1 then
           D_intesta_periodi := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_5', D_gruppo_ling, D_lingua_dip  );
           D_intesta_periodi_al1 := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_5', D_gruppo_ling, D_lingua_dip_2  );
        ELSE 
           D_intesta_periodi := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_6', D_gruppo_ling, D_lingua_dip  );
           D_intesta_periodi_al1 := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_6', D_gruppo_ling, D_lingua_dip_2  );
        END IF;
  ELSE
     D_note_periodi := null;
     D_conta_periodi := 0;
     D_intesta_periodi := null;
     D_intesta_periodi_al1 := null;
  END IF; -- controllo c6 - c7
  
   BEGIN
   select decode( nvl(CUR_CI.c139,0),0, null, ' con presenza di TFR') 
     into d_note_tfr
     from dual;
   EXCEPTION WHEN NO_DATA_FOUND THEN D_note_tfr := null;
   END;
    select nvl(D_note_AL,' ')||nvl(D_note_tfr,'')||'. '
         ||nvl(D_intesta_periodi,'')
         ||nvl(D_note_periodi,'')
         ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_7', D_gruppo_ling, D_lingua_dip  )
         ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_ci.c1,0) + nvl(CUR_ci.c2,0)))
         ||decode((nvl(CUR_CI.c45,0)+nvl(CUR_CI.c46,0))
                 ,0,''
                   ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_8', D_gruppo_ling, D_lingua_dip)
                  )||'.'
          , nvl(D_note_AL,' ')||nvl(D_note_tfr,'')||'. '
         ||nvl(D_intesta_periodi,'')
         ||nvl(D_note_periodi,'')
         ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_7', D_gruppo_ling, D_lingua_dip_2  )
         ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_ci.c1,0) + nvl(CUR_ci.c2,0)))
         ||decode((nvl(CUR_CI.c45,0)+nvl(CUR_CI.c46,0))
                 ,0,''
                   ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_8', D_gruppo_ling, D_lingua_dip_2)
                  )||'.'
      into D_note_AL
         , D_note_AL_al1 
      from dual;
      D_sequenza := 11 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
      (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'AL', D_sequenza
               , substr(D_note_AL,1,2000)
               , substr(D_note_AL_al1,1,2000)
               , D_utente, SYSDATE
            from dual
      where nvl(CUR_CI.c1,0) + nvl(CUR_CI.c2,0) != 0 
      ;
      IF length(D_note_AL) > 2000 OR length(D_note_AL_Al1) > 2000 THEN
          D_riga := D_riga +1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,2,D_riga,'P00521',substr('CI: '||TO_CHAR(CUR_CI.ci)||', Nota AL '||D_errore,1,50));
      END IF;
  END IF; -- controllo c1 e c2
END NOTA_AL;

-- dbms_output.put_line('Fine Nota AL');

/* Nota AN - CUD 2007 */
-- dbms_output.put_line('Nota AN');
     D_sequenza := 13 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
      (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'AN', D_sequenza
                ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AN_1', D_gruppo_ling, D_lingua_dip  )
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AN_2', D_gruppo_ling, D_lingua_dip  )
                ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AN_1', D_gruppo_ling, D_lingua_dip_2  )
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AN_2', D_gruppo_ling, D_lingua_dip_2  )
               , D_utente, SYSDATE
            from dual
           where nvl(D_pens,0) != 0
      ;
-- dbms_output.put_line('Fine Nota AN ');
  d_note_a_r_cr    := 0;
  d_note_a_r_crc   := 0;
  d_note_cr        := 0;
  d_note_a_c_cr    := 0;
  d_note_a_c_crc   := 0;
  D_add_reg_730    := 0;
  D_add_com_730    := 0;
  D_credito_730    := 0;

/* Nota AO - CUD 2007 */
-- dbms_output.put_line('Nota AO');
-- dbms_output.put_line('Nota AO: add.reg  '||D_nota_add_reg);
-- dbms_output.put_line('Nota AO: C6 '||CUR_CI.c6);
-- dbms_output.put_line('Nota AO: add.com '||nvl(D_nota_add_com,0));
-- dbms_output.put_line('Nota AO: C7 '||CUR_CI.c7)

        D_sequenza := 14 + CUR_LINGUA.seq;
/* Regionale e Comunale entrambe interamente trattenute */
        INSERT INTO NOTE_CUD
        (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_2', D_gruppo_ling, D_lingua_dip  )
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_2', D_gruppo_ling, D_lingua_dip_2  )
             , D_utente, SYSDATE
          from dual
        where nvl(D_nota_add_reg,0) = 0 and nvl(CUR_CI.c6,0) != 0
          and nvl(D_nota_add_com,0) = 0 and nvl(D_add_irpef_comu,0) != 0
        union
/* Regionale interamente trattenuta in assenza di comunale */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_3', D_gruppo_ling, D_lingua_dip  )
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_3', D_gruppo_ling, D_lingua_dip_2  )
             , D_utente, SYSDATE
          from dual
        where nvl(D_nota_add_reg,0) = 0 and nvl(CUR_CI.c6,0) != 0
          and nvl(D_nota_add_com,0) = 0 and nvl(D_add_irpef_comu,0) = 0
        union
/* Regionale e comunale entrambe parzialmente trattenute */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_4', D_gruppo_ling, D_lingua_dip  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_5', D_gruppo_ling, D_lingua_dip  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c7,0) - nvl(D_nota_add_com,0)))
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_6', D_gruppo_ling, D_lingua_dip  )
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_4', D_gruppo_ling, D_lingua_dip_2  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_5', D_gruppo_ling, D_lingua_dip_2  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c7,0) - nvl(D_nota_add_com,0)))
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_6', D_gruppo_ling, D_lingua_dip_2  )
              , D_utente, SYSDATE
          from dual
          where nvl(CUR_CI.c6,0) > nvl(D_nota_add_reg,0) 
            and nvl(CUR_CI.c7,0) > nvl(D_nota_add_com,0) 
            and nvl(D_nota_add_reg,0) != 0 and nvl(D_nota_add_com,0) != 0
        union
/* Regionale parzialmente trattenuta in assenza di comunale */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_7', D_gruppo_ling, D_lingua_dip  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_7', D_gruppo_ling, D_lingua_dip_2  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
            , D_utente, SYSDATE
          from dual
          where nvl(CUR_CI.c6,0) > nvl(D_nota_add_reg,0) 
            and nvl(D_nota_add_reg,0) != 0
            and nvl(D_nota_add_com,0) = 0 and nvl(D_add_irpef_comu,0) = 0
        union
/* Regionale parzialmente trattenuta - comunale interamente trattenuta */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_8', D_gruppo_ling, D_lingua_dip  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_8', D_gruppo_ling, D_lingua_dip_2  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
              , D_utente, SYSDATE
          from dual
          where nvl(CUR_CI.c6,0) > nvl(D_nota_add_reg,0) 
            and nvl(D_nota_add_com,0) = 0 and nvl(D_add_irpef_comu,0) != 0
            and nvl(D_nota_add_reg,0) != 0
        union
/* Regionale in restituzione - comunale interamente trattenuta */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_9', D_gruppo_ling, D_lingua_dip  )
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_9', D_gruppo_ling, D_lingua_dip_2  )
              , D_utente, SYSDATE
          from dual
          where nvl(D_add_irpef_comu,0) > nvl(D_nota_add_com,0) 
            and nvl(D_nota_add_reg,0) > nvl(CUR_CI.c6,0)
            and nvl(D_nota_add_com,0) = 0
        union
/* Regionale in restituzione - comunale parzialmente trattenuta */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_10', D_gruppo_ling, D_lingua_dip  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c7,0) - nvl(D_nota_add_com,0)))
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_10', D_gruppo_ling, D_lingua_dip_2  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c7,0) - nvl(D_nota_add_com,0)))
             , D_utente, SYSDATE
          from dual
          where nvl(CUR_CI.c7,0) > nvl(D_nota_add_com,0) 
            and nvl(D_nota_add_reg,0) > nvl(CUR_CI.c6,0)
            and nvl(D_nota_add_com,0) != 0
        union
/* Comunale in restituzione - regionale interamente trattenuta */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_3', D_gruppo_ling, D_lingua_dip  )
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_3', D_gruppo_ling, D_lingua_dip_2  )
              , D_utente, SYSDATE
          from dual
          where nvl(CUR_CI.c6,0) > nvl(D_nota_add_reg,0) 
            and nvl(D_nota_add_com,0) > nvl(CUR_CI.c7,0)
            and nvl(D_nota_add_com,0) != 0
            and nvl(D_nota_add_reg,0) = 0
       union
/* Comunale in restituzione - regionale parzialmente trattenuta */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_7', D_gruppo_ling, D_lingua_dip  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_7', D_gruppo_ling, D_lingua_dip_2  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
              , D_utente, SYSDATE
          from dual
          where nvl(CUR_CI.c6,0) > nvl(D_nota_add_reg,0) 
            and nvl(D_nota_add_com,0) > nvl(CUR_CI.c7,0)
            and nvl(D_nota_add_com,0) != 0
            and nvl(D_nota_add_reg,0) != 0
       union
/* Regionale parzialmente trattenuta - comunale interamente sospesa */
        select d_anno,CUR_CI.ci,'AO',D_sequenza
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_7', D_gruppo_ling, D_lingua_dip  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
             , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_1', D_gruppo_ling, D_lingua_dip_2  )
             ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AO_7', D_gruppo_ling, D_lingua_dip_2  )
             ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_CI.c6,0) - nvl(D_nota_add_reg,0)))
              , D_utente, SYSDATE
          from dual
          where nvl(CUR_CI.c6,0) > nvl(D_nota_add_reg,0) 
            and nvl(D_nota_add_com,0) != 0 
            and nvl(D_nota_add_com,0) =  nvl(CUR_CI.c7,0)
            and nvl(D_nota_add_reg,0) != 0
      ;
          D_riga := D_riga +1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          select prenotazione,2,D_riga,'P00505'
               , substr('CI: '||TO_CHAR(CUR_CI.ci)||' - Verificare Addizionali, Nota AO non archiviata o archiviata parzialmente ',1,200)
          from dual
          where ( nvl(CUR_CI.c6,0) < nvl(D_nota_add_reg,0) 
              or  nvl(CUR_CI.c7,0) < nvl(D_nota_add_com,0) 
                ) 
          ;
-- dbms_output.put_line('Fine Nota AO');

/* Nota AP - CUD 2007 */
-- dbms_output.put_line('Nota AP');
      BEGIN
        select sum(decode(voec.specifica,'ADD_R_CR',nvl(moco.imp,0)
                                                   ,null)) 
             , sum(decode(voec.specifica,'ADD_R_CRC',nvl(moco.imp,0)
                                                   ,null)) 
             , sum(decode(voec.specifica,'IRPEF_CR',nvl(moco.imp,0)
                                                   ,null)) 
             , sum(decode(voec.specifica,'ADD_C_CR',nvl(moco.imp,0)
                                                   ,null)) 
             , sum(decode(voec.specifica,'ADD_C_CRC',nvl(moco.imp,0)
                                                   ,null)) 
          into d_note_a_r_cr
             , d_note_a_r_crc
             , d_note_cr
             , d_note_a_c_cr
             , d_note_a_c_crc
          FROM VOCI_ECONOMICHE voec
             , MOVIMENTI_CONTABILI moco
         WHERE voec.codice = moco.voce
           AND moco.ci = CUR_CI.ci
           AND moco.anno = D_anno
           and moco.mensilita != '*AP'
           AND voec.specifica in ('ADD_R_CR','ADD_R_CRC'
                                 ,'IRPEF_CR','ADD_C_CR'
                                 ,'ADD_C_CRC'
                                 )
        ; 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
           d_note_a_r_cr  := null;
           d_note_a_r_crc := null;
           d_note_cr      := null;
           d_note_a_c_cr  := null;
           d_note_a_c_crc := null;
      END;

D_add_reg_730 := nvl(d_note_a_r_cr,0) + nvl(d_note_a_r_crc,0);
D_add_com_730 := nvl(d_note_a_c_cr,0) + nvl(d_note_a_c_crc,0);
D_credito_730 := nvl(d_note_cr,0);

     D_sequenza := 15 + CUR_LINGUA.seq;
 IF nvl(D_add_reg_730,0) + nvl(D_add_com_730,0) + nvl(D_credito_730,0) != 0 THEN
      INSERT INTO NOTE_CUD
      (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
      select d_anno,CUR_CI.ci,'AP', D_sequenza
           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_1', D_gruppo_ling, D_lingua_dip  )
           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_1', D_gruppo_ling, D_lingua_dip_2  )
           , D_utente, SYSDATE
        from dual
     union
      select d_anno,CUR_CI.ci,'AP', D_sequenza+1
           , decode( nvl(D_credito_730,0) 
                    ,0, ''
                      , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_2', D_gruppo_ling, D_lingua_dip  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_credito_730)
                    )
           , decode( nvl(D_credito_730,0) 
                    ,0, ''
                      , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_2', D_gruppo_ling, D_lingua_dip_2  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_credito_730)
                    )
           , D_utente, SYSDATE 
        from dual
      where nvl(D_credito_730,0) != 0
     union
      select d_anno,CUR_CI.ci,'AP', D_sequenza+2
           , decode( nvl(D_add_reg_730,0)
                   ,0,''
                     , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_3', D_gruppo_ling, D_lingua_dip  )
                     ||GP4EC.GET_VAL_DEC_STAMPA(D_add_reg_730)
                    )
           , decode( nvl(D_add_reg_730,0)
                   ,0,''
                     , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_3', D_gruppo_ling, D_lingua_dip_2  )
                     ||GP4EC.GET_VAL_DEC_STAMPA(D_add_reg_730)
                    )
           , D_utente, SYSDATE
        from dual
      where nvl(D_add_reg_730,0) != 0
     union
      select d_anno,CUR_CI.ci,'AP', D_sequenza+3
           , decode( nvl(D_add_com_730,0)
                   ,0,''
                     , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_4', D_gruppo_ling, D_lingua_dip  )
                     ||GP4EC.GET_VAL_DEC_STAMPA(D_add_com_730)
                    )
           , decode( nvl(D_add_com_730,0)
                   ,0,''
                     , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AP_4', D_gruppo_ling, D_lingua_dip_2  )
                     ||GP4EC.GET_VAL_DEC_STAMPA(D_add_com_730)
                    )
           , D_utente, SYSDATE
        from dual
      where nvl(D_add_com_730,0) != 0
      ;
     update note_cud nocu
        set note = note||'.'
      where anno = D_anno
        and ci = CUR_CI.ci
        and codice = 'AP'
        and sequenza in ( select max(sequenza) 
                            from note_cud 
                           where ci = nocu.ci
                             and anno= D_anno
                             and codice = 'AP')
       ;
  END IF;
-- dbms_output.put_line('Fine Nota AP');

-- dbms_output.put_line('Nota AQ');
/* Nota AQ - CUD 2007 */
     D_sequenza := 19 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
      (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
       select d_anno,CUR_CI.ci,'AQ', D_sequenza
            , decode ( d_attr_spese_x_gg
                      ,null,null, PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AQ_1', D_gruppo_ling, D_lingua_dip  )
                                ||decode (nvl(CUR_CI.c4,CUR_CI.c3)
                                          ,365,null
                                              ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AQ_2', D_gruppo_ling, D_lingua_dip  )
                                         )
                       )
            , decode ( d_attr_spese_x_gg
                      ,null,null, PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AQ_1', D_gruppo_ling, D_lingua_dip_2 )
                                ||decode (nvl(CUR_CI.c4,CUR_CI.c3)
                                          ,365,null
                                              ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AQ_2', D_gruppo_ling, D_lingua_dip_2  )
                                         )
                       )
               , D_utente, SYSDATE
            from dual
           where d_ded_fis != 0
             and nvl(CUR_CI.c17,0) != 0
             and nvl(d_spese,1) != 0 
             and d_attr_spese_x_gg is not null
      ;
-- dbms_output.put_line('Fine Nota AQ');

-- dbms_output.put_line('Nota AR');
/* Nota AR - CUD 2007 */
     D_sequenza := 20 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
      (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
       select d_anno,CUR_CI.ci,'AR', D_sequenza
            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AR', D_gruppo_ling, D_lingua_dip  )
            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c40)||'.'
            , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AR', D_gruppo_ling, D_lingua_dip_2  )
            ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.c40)||'.'
            , D_utente, SYSDATE
         from dual
        where nvl(CUR_CI.c40,0) != 0
      ;
-- dbms_output.put_line('Fine Nota AR');

-- dbms_output.put_line('Nota AS');
/* Nota AS - CUD 2007 */
     D_sequenza := 21 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
     (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
      select d_anno,CUR_CI.ci,'AS', D_sequenza
           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AS', D_gruppo_ling, D_lingua_dip  )
           ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_18)||'.'
           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AS', D_gruppo_ling, D_lingua_dip_2  )
           ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_18)||'.'
           , D_utente, SYSDATE
            from dual
           where nvl(D_oneri_18,0) != 0
      ; 
-- dbms_output.put_line('Fine Nota AS');

-- dbms_output.put_line('Nota AU');
 BEGIN
 select max(sequenza)
   into D_sequenza
   from note_cud
  where anno = D_anno
    and ci = CUR_CI.CI
    and sequenza > 27;
 EXCEPTION WHEN NO_DATA_FOUND THEN
   D_sequenza := 29 + CUR_LINGUA.seq;
 END;

/* Nota AU - CUD 2007 */
       IF nvl(CUR_CI.c26,0) != 0 THEN
          INSERT INTO NOTE_CUD 
         (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+1
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_1', D_gruppo_ling, D_lingua_dip  )
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_1', D_gruppo_ling, D_lingua_dip_2  )
               , D_utente, SYSDATE
            from dual
           where nvl(D_somme_01,0) + nvl(D_somme_02,0) +
                 nvl(D_somme_03,0) + nvl(D_somme_04,0) +
                 nvl(D_somme_05,0) + nvl(D_somme_06,0) +
                 nvl(D_somme_07,0) + nvl(D_somme_08,0) != 0
           union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+2
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_01)
               , substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_01)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and  esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_01'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_01,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+3
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_02)
               , substr(decode( D_lingua_dip_2
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_02)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_02'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_02,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+4
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_03)
               , substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_03)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_03'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_03,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+5
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_04)
               , substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_04)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_04'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_04,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+6
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_05)
               , substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_05)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_05'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_05,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+7
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_06)
               , substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_06)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_06'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_06,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+8
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_07)
               , substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_07)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_07'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_07,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+9
               , substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_08)
               , substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)
               ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(D_somme_08)
               , D_utente, SYSDATE
           from ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
              , estrazione_valori_contabili esvc
          where ente.ente_id       = 'ENTE'
            and esvc.estrazione = 'DENUNCIA_CUD'
            and esvc.colonna = 'SOMME_08'
            and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
            and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
            and nvl(D_somme_08,0) != 0
            and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli1.sequenza      = 1
            and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli2.sequenza      = 2
            and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                             , 'ENTE*', 'I'
                                                      , upper(D_gruppo_ling)
                                            )
            and grli3.sequenza      = 3
          union
          select d_anno,CUR_CI.ci,'AU',nvl(D_sequenza,30)+10
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_3', D_gruppo_ling, D_lingua_dip  )
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AU_3', D_gruppo_ling, D_lingua_dip_2  )
               , D_utente, SYSDATE
            from dual
           where nvl(D_somme_01,0) + nvl(D_somme_02,0) +
                 nvl(D_somme_03,0) + nvl(D_somme_04,0) +
                 nvl(D_somme_05,0) + nvl(D_somme_06,0) +
                 nvl(D_somme_07,0) + nvl(D_somme_08,0) != 0
          ;
       END IF; -- controllo su casella 26
-- dbms_output.put_line('Fine Nota AU');

-- dbms_output.put_line('Nota AV');
 BEGIN
 select max(sequenza)
   into D_sequenza
   from note_cud
  where anno = D_anno
    and ci = CUR_CI.CI
    and sequenza > 40;
 EXCEPTION WHEN NO_DATA_FOUND THEN
   D_sequenza := 40 + CUR_LINGUA.seq;
 END;

/* Nota AV - CUD 2007 */
     IF nvl(CUR_CI.c27,0) != 0 THEN
     INSERT INTO NOTE_CUD 
    (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+1
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_1', D_gruppo_ling, D_lingua_dip  )
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_1', D_gruppo_ling, D_lingua_dip_2  )
               , D_utente, SYSDATE
            from dual
           where nvl(D_oneri_01,0) + nvl(D_oneri_19,0) +
                 nvl(D_oneri_02,0) + nvl(D_oneri_12,0) +
                 nvl(D_oneri_20,0) + nvl(D_oneri_21,0) +
                 nvl(D_oneri_03,0) + nvl(D_oneri_04,0) +
                 nvl(D_oneri_05,0) + nvl(D_oneri_13,0) +
                 nvl(D_oneri_06,0) + nvl(D_oneri_07,0) +
                 nvl(D_oneri_09,0) + nvl(D_oneri_10,0) +
                 nvl(D_oneri_08,0) + nvl(D_oneri_14,0) +
                 nvl(D_oneri_17,0) + nvl(D_oneri_15,0) +
                 nvl(D_oneri_22,0) + nvl(D_oneri_16,0) +
                 nvl(D_oneri_23,0) + nvl(D_oneri_24,0) +
                 nvl(D_oneri_25,0) + nvl(D_oneri_26,0) +
                 nvl(D_oneri_11,0) + nvl(D_oneri_27,0) + 
                 nvl(D_oneri_28,0) + nvl(D_oneri_29,0) != 0
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+2
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '||
                      decode( sign(D_oneri_01 - 129.11)
                            ,-1, PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_2', D_gruppo_ling, D_lingua_dip  )
                               , null)
                      ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_01)||'.'
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '||
                      decode( sign(D_oneri_01 - 129.11)
                            ,-1, PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_2', D_gruppo_ling, D_lingua_dip_2  )
                               , null)
                      ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_01)||'.'
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_01'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_01,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+3
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '||
                         decode( sign(D_oneri_19 - 129.11)
                               ,-1,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_2', D_gruppo_ling, D_lingua_dip  )
                                  ,null)
                      ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_19)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '||
                         decode( sign(D_oneri_19 - 129.11)
                               ,-1,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_2', D_gruppo_ling, D_lingua_dip_2  )
                                  ,null)
                      ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_19)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_19'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_19,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+4
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '||
                           decode( sign(D_oneri_02 - 129.11)
                               ,-1,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_2', D_gruppo_ling, D_lingua_dip  )
                                  ,null)
                      ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_02)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '||
                           decode( sign(D_oneri_02 - 129.11)
                               ,-1,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_2', D_gruppo_ling, D_lingua_dip_2  )
                                  ,null)
                      ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                      ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_02)
             , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_02'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_02,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+5
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_12)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_12)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_12'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_12,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+6
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_20)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_20)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_20'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_20,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+7
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_27)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2 )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_27)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_27'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_27,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+8
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_03)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_03)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_03'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_03,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+9
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_04)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_04)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_04'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_04,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+10
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_05)
               , ' - '||
                 substr(decode( D_lingua_dip_2
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_05)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_05'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_05,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+11
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_13)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_13)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_13'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_13,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+12
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_06)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_06)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_06'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_06,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+13
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_07)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_07)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_07'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_07,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+14
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_09)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_09)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_09'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_09,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+15
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_10)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_10)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_10'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_10,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+16
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_08)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_08)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_08'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_08,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+17
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_14)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_14)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_14'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_14,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+18
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_17)
               , ' - '||
                 substr(decode( D_lingua_dip_2
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_17)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_17'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_17,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+19
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_15)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_15)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_15'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_15,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+20
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_22)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_22)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_22'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_22,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+21
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_16)
               , ' - '||
                 substr(decode( D_lingua_dip_2
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_16)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_16'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_16,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+22
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_23)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_23)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_23'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_23,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+23
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_24)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_24)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_24'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_24,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+24
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_25)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_25)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_25'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_25,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+25
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_26)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2 )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_26)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_26'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_26,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+26
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_21)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_21)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_21'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_21,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+27
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_28)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_28)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_28'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_28,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+28
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_29)
               , ' - '||
                 substr(decode( D_lingua_dip_2 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_29)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_29'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_29,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
           union 
          select d_anno,CUR_CI.ci,'AV', nvl(D_sequenza, 40)+29
               , ' - '||
                 substr(decode( D_lingua_dip 
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_11)
               , ' - '||
                 substr(decode( D_lingua_dip_2
                              , grli1.gruppo_al, nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                              , grli2.gruppo_al, nvl(esvc.note_al1, nvl(esvc.note,esvc.note_al2))
                              , grli3.gruppo_al, nvl(esvc.note_al2, nvl(esvc.note,esvc.note_al1))
                                               , nvl(esvc.note, nvl(esvc.note_al1,esvc.note_al2))
                               )
                       ,1,100)||': '
                 ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AV_3', D_gruppo_ling, D_lingua_dip_2  )
                 ||GP4EC.GET_VAL_DEC_STAMPA(D_oneri_11)
               , D_utente, SYSDATE
            from ente
               , gruppi_linguistici grli1
               , gruppi_linguistici grli2
               , gruppi_linguistici grli3
               , estrazione_valori_contabili esvc
           where ente.ente_id       = 'ENTE'
             and esvc.estrazione = 'DENUNCIA_CUD'
             and colonna = 'ONERI_11'
             and esvc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
             and nvl(esvc.al,to_date('3333333','j')) >= TO_DATE(D_ini_a,'ddmmyyyy')
             and nvl(D_oneri_11,0) != 0
             and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli1.sequenza      = 1
             and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli2.sequenza      = 2
             and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                              , 'ENTE*', 'I'
                                                       , upper(D_gruppo_ling)
                                             )
             and grli3.sequenza      = 3
      ; 
     END IF; -- fine controllo su casella 27
-- dbms_output.put_line('Fine Nota AV');

-- dbms_output.put_line('Nota AX');
/* Nota AX - CUD 2007 */
      D_sequenza := 22 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
      (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'AX',D_sequenza
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AX_1', D_gruppo_ling, D_lingua_dip  )
               ||decode( sign(CUR_CI.c33 - 3615.20)
                            ,1,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AX_3', D_gruppo_ling, D_lingua_dip  )
                               ||GP4EC.GET_VAL_DEC_STAMPA((CUR_CI.c33 - 3615.20))
                              , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AX_2', D_gruppo_ling, D_lingua_dip  )
                           )||'.'
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AX_1', D_gruppo_ling, D_lingua_dip_2  )
               ||decode( sign(CUR_CI.c33 - 3615.20)
                            ,1,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AX_3', D_gruppo_ling, D_lingua_dip_2  )
                               ||GP4EC.GET_VAL_DEC_STAMPA((CUR_CI.c33 - 3615.20))
                              , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AX_2', D_gruppo_ling, D_lingua_dip_2  )
                           )||'.'
               , D_utente, SYSDATE
            from dual
           where nvl(CUR_CI.c33,0) != 0
      ;
-- dbms_output.put_line('Fine Nota AX');

-- dbms_output.put_line('Nota AY');
/* Nota AY - CUD 2007 */
      D_sequenza := 23 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
      (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'AY',D_sequenza
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AY', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.C34)
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AY', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA(CUR_CI.C34)
               , D_utente, SYSDATE
            from dual
           where nvl(CUR_CI.c34,0) != 0
      ;
-- dbms_output.put_line('Fine Nota AY');

-- dbms_output.put_line('Nota AZ');
/* Nota AZ - CUD 2007 */
     D_sequenza := 24 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD
      (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'AZ', D_sequenza
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AZ', D_gruppo_ling, D_lingua_dip  )
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AZ', D_gruppo_ling, D_lingua_dip_2  )
               , D_utente, SYSDATE
            from dual
           where nvl(CUR_CI.c43,0) != 0
      ;
-- dbms_output.put_line('Fine Nota AZ');

-- dbms_output.put_line('Nota BA');
/* Nota BA - CUD 2007 */
    D_sequenza := 25 + CUR_LINGUA.seq;
    IF nvl(d_lor_liq_2000,0) + nvl(d_lor_liq_ac,0) + nvl(d_lor_liq_ap_2000,0) + nvl(d_lor_liq_ap,0) 
     + nvl(D_riv_tfr,0) != 0
      THEN
      INSERT INTO NOTE_CUD
      (anno,ci,codice,sequenza,note,note_al1,utente,data_agg)
      select d_anno,CUR_CI.ci,'BA', D_sequenza
           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_1', D_gruppo_ling, D_lingua_dip  )
           , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_1', D_gruppo_ling, D_lingua_dip_2  )
           , D_utente, SYSDATE
        from dual;
    IF ( ( nvl(d_lor_liq_2000,0) != 0 or nvl(d_lor_liq_ap_2000,0) != 0 ) 
       and nvl(d_lor_liq_ac,0) = 0 and nvl(d_lor_liq_ap,0) = 0
       ) THEN
/* Inserimento annotazione per 2000 */
      INSERT INTO NOTE_CUD 
      (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'BA', nvl(D_sequenza,25) + 1
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_2000,0)+nvl(d_lor_liq_ap_2000,0)))||'.'
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_2000,0)+nvl(d_lor_liq_ap_2000,0)))||'.'
               , D_utente, SYSDATE
            from dual
                ;
    ELSIF ( ( nvl(d_lor_liq_ac,0) != 0 or nvl(d_lor_liq_ap,0) != 0 ) 
         and  nvl(d_lor_liq_2000,0) = 0 and nvl(d_lor_liq_ap_2000,0) = 0 
          ) THEN
/* Inserimento annotazione solo dal 2001 */
       INSERT INTO NOTE_CUD 
       (anno,ci,codice, sequenza,note,note_al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'BA', nvl(D_sequenza,25) + 1
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_3', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_ac,0)+ nvl(d_lor_liq_ap,0) + nvl(D_riv_tfr,0)))||'.'
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_3', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_ac,0)+ nvl(d_lor_liq_ap,0) + nvl(D_riv_tfr,0)))||'.'
               , D_utente, SYSDATE
            from dual
                ;
    ELSIF ( ( nvl(d_lor_liq_2000,0) != 0 or nvl(d_lor_liq_ap_2000,0) != 0 ) 
        and ( nvl(d_lor_liq_ac,0) != 0 or nvl(d_lor_liq_ap,0) != 0 )
          ) THEN
/* Inserimento annotazione sia 2000 che dal 2001 */
        INSERT INTO NOTE_CUD 
        (anno,ci,codice, sequenza,note,note_Al1,utente,data_agg)
          select d_anno,CUR_CI.ci,'BA',  nvl(D_sequenza,25) + 1
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_2', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_2000,0)+nvl(D_lor_liq_ap_2000,0)))||'; '||
                 PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_3', D_gruppo_ling, D_lingua_dip  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_ac,0)+nvl(d_lor_liq_ap,0)+ nvl(D_riv_tfr,0)))||'.'
               , PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_2', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_2000,0)+nvl(D_lor_liq_ap_2000,0)))||'; '||
                 PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'BA_3', D_gruppo_ling, D_lingua_dip_2  )
               ||GP4EC.GET_VAL_DEC_STAMPA((nvl(d_lor_liq_ac,0)+nvl(d_lor_liq_ap,0)+ nvl(D_riv_tfr,0)))||'.'
               , D_utente, SYSDATE
            from dual;
    END IF;
-- dbms_output.put_line('Fine Nota BA');

   END IF; -- controllo esistenza nota
  END;

-- Inserimento note Libere per Finanziaria 2007

  IF nvl(D_add_irpef_comu,0) < nvl(D_acconto_com_trat,0) and D_anno >= 2007 THEN
     D_sequenza := 70 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD
      (anno,ci,codice,sequenza,note,utente,data_agg)
      select d_anno,CUR_CI.ci,'L10', D_sequenza
           , 'Addizionale Restituita o non trattenuta: '||GP4EC.GET_VAL_DEC_STAMPA(nvl(D_add_irpef_comu,0)-nvl(D_acconto_com_trat,0))
           , D_utente, SYSDATE
        from dual;
  END IF; -- nota 

  IF nvl(D_acconto_com,0) != 0 and nvl(D_acconto_com_trat,0) = 0 and D_anno >= 2007 THEN
     D_sequenza := 71 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD
      (anno,ci,codice,sequenza,note,utente,data_agg)
      select d_anno,CUR_CI.ci,'L11', D_sequenza
           , 'L''acconto dell''addizionale comunale NON e'' stato trattenuto per applicazione automatica '
           ||'della soglia di esenzione.'
           , D_utente, SYSDATE
        from dual;
  END IF; -- nota 

  IF nvl(D_det_con_ac,0) + nvl(D_det_fig_ac,0) + nvl(D_det_alt_ac,0)
   + nvl(D_det_spe_ac,0) + nvl(D_det_ass_ac,0) + nvl(D_det_god,0) != 0  and D_anno >= 2007 THEN
      D_sequenza := 60 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD
      (anno,ci,codice,sequenza,note,utente,data_agg)
      select d_anno,CUR_CI.ci,'L01', D_sequenza
           , 'Detrazioni Spettanti: '
           , D_utente, SYSDATE
        from dual
      union
      select d_anno,CUR_CI.ci,'L01', D_sequenza+1
           , '            Coniuge: '||GP4EC.GET_VAL_DEC_STAMPA(D_det_con_ac)
           , D_utente, SYSDATE
        from dual
       where nvl(D_det_con_ac,0) != 0
      union
      select d_anno,CUR_CI.ci,'L01', D_sequenza+2
           , '            Figli: '||GP4EC.GET_VAL_DEC_STAMPA(D_det_fig_ac)
           , D_utente, SYSDATE
        from dual
       where nvl(D_det_fig_ac,0) != 0
      union
      select d_anno,CUR_CI.ci,'L01', D_sequenza+3
           , '            Altri Familiari: '||GP4EC.GET_VAL_DEC_STAMPA(D_det_alt_ac)
           , D_utente, SYSDATE
        from dual
       where nvl(D_det_alt_ac,0) != 0
      union      
      select d_anno,CUR_CI.ci,'L01', D_sequenza+4
           , '            Altre detrazioni per reddito: ' ||GP4EC.GET_VAL_DEC_STAMPA(D_det_spe_ac)
           , D_utente, SYSDATE
        from dual
       where nvl(D_det_spe_ac,0) != 0
      union      
      select d_anno,CUR_CI.ci,'L01', D_sequenza+5
           , '            Detrazioni per Oneri (cas.21): '||GP4EC.GET_VAL_DEC_STAMPA(D_det_ass_ac)
           , D_utente, SYSDATE
        from dual
       where nvl(D_det_con_ac,0) != 0
      union      
      select d_anno,CUR_CI.ci,'L01', D_sequenza+6
           , '            Totale Detrazioni Spettanti: '||GP4EC.GET_VAL_DEC_STAMPA(nvl(D_det_con_ac,0) + nvl(D_det_fig_ac,0) + nvl(D_det_alt_ac,0) + nvl(D_det_spe_ac,0) + nvl(D_det_ass_ac,0))
           , D_utente, SYSDATE
        from dual
       where nvl(D_det_con_ac,0) + nvl(D_det_fig_ac,0) 
           + nvl(D_det_alt_ac,0) + nvl(D_det_spe_ac,0) + nvl(D_det_ass_ac,0) != 0
      union      
      select d_anno,CUR_CI.ci,'L01', D_sequenza+7
           , '            Totale Detrazioni Attibuite: '||GP4EC.GET_VAL_DEC_STAMPA(D_det_god)
           , D_utente, SYSDATE
        from dual
       where nvl(D_det_god,0) != 0
      ;
  END IF;
  END LOOP; -- CUR_lingua
     BEGIN
       update note_cud 
          set note_al1 = ''
        where anno = D_anno
          and ci = CUR_CI.CI
          and D_lingua_dip_2 is null
       ;
     END;
   EXCEPTION
       WHEN OTHERS THEN
-- dbms_output.put_line('ERRORE');
           D_errore := SUBSTR(SQLERRM,1,30);
          ROLLBACK;
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
          D_riga := D_riga +1;
          INSERT INTO a_segnalazioni_errore
          ( no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,2,D_riga,'P00109',' Note del CI: '||SUBSTR(TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
          COMMIT;
    END NOTE;
   COMMIT;
    END LOOP; -- CUR_CI
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 99
           , errore         = V_errore
       where no_prenotazione = prenotazione;
      commit;
END;
END;
END;
/
