CREATE OR REPLACE PACKAGE PECCARFI IS
/******************************************************************************
 NOME:          PECCARFI   
 DESCRIZIONE:   CARICAMENTO ARCHIVIO FISCALE
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000 
 2    13/02/2004 NN     Adeguamento modifiche per CUD 2004                                    
 2.1  10/09/2004 MS     Modifiche come da attivita 7043
 2.2  13/09/2004 MS     Modifiche come da attivita 7306
 2.3  02/11/2004 MS     Modifiche per att. 6662
 2.4  23/12/2004 MS     Modifiche per att. 8898
 2.5  27/12/2004 MS     Modifiche per att. 8886
 2.6  12/01/2005 MS     Modifiche per att. 8888
 3    13/01/2005 GM     Adeguamento modifiche per CUD 2005
 3.1  20/01/2005 MS     Modifiche per Att. 9266
 3.2  20/01/2005 MS     Mod. per attivita 8890
 3.3  01/02/2004 MS     Mod. per attivita 9557
 3.4  02/02/2004 MS     Mod. per attivita 8880
 3.5  22/02/2004 MS     Mod. per attivita 7043.2
 3.6  01/03/2005 MS     Mod. per attivita 9946 - 9964 - 9965
 3.7  08/03/2005 MS     Mod. per attivita 10108
 3.8  19/10/2005 MS     Mod. gestione ARR.AP (11804) e pulizia variabili
 3.9  10/01/2006 MS     Adeguamento per CUD/2006 - Att.13955
 3.10 23/02/2006 MS     Mod. assestamento casella 60 (Att. 15038 )
 3.11 27/02/2006 MS     Corretta casella 18 e 19 ( Att. 15078 )
 3.12 29/08/2006 MS     Aggiunta controlli per Att. 17360
 4.0  19/01/2006 MS     Adeguamento per CUD/2007 - Att.19140 + Att- 17900
 4.1  31/01/2007 MS     Correzioni da test priorità 1
 4.2  12/02/2007 MS     Valorizzazione D_acconto_com per casella 7 Bis
 4.3  29/03/2007 MS     Valorizzazione Anno apertura successione casella 61/770
 4.4  03/04/2007 MS     Valorizzazione casella 7 per anno >= 2007
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCARFI IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V4.4 del 03/04/2007';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  D_ente               VARCHAR(4);
  D_ambiente           VARCHAR(8);
  D_utente             VARCHAR(8);
  P_errore             VARCHAR(6);
  D_anno               VARCHAR(4);
  D_min_anno_prec      VARCHAR(4);
  D_ini_a              VARCHAR(8);
  D_fin_a              VARCHAR(8);
  D_gestione           VARCHAR(4);
  D_tipo               VARCHAR(1);
  D_dal                date;
  D_al                 date;
  D_ci                 NUMBER(8);
  D_evento_eccezionale VARCHAR(1);
  D_errore             VARCHAR(200);
  D_cod_errore         VARCHAR(6);
  D_precisazione       VARCHAR(200);
  D_dummy              VARCHAR(1);
  D_riga               NUMBER:=0;
  D_tipo_spese         VARCHAR(2);
  D_spese              NUMBER(2);
  D_ded_non_appl       NUMBER(1);
  D_prev_com           VARCHAR(1);
  D_dec                VARCHAR(1);
  D_ipt_ere            VARCHAR(1);
  D_gg_det             NUMBER(3);
  D_gg_det_dd          NUMBER(3);
  D_gg_det_dp          NUMBER(3);
  D_cf_gestione        VARCHAR(16);
  D_ipn_ord            NUMBER(15,5);
  D_ipn_ass            NUMBER(15,5);
  D_ipt_ac             NUMBER(15,5);
  D_ipt_pag            NUMBER(15,5);
  D_maggiore_ritenuta  NUMBER(1);
  D_ipn_ded            NUMBER(15,5);
  D_ipn_ded_magg       NUMBER(15,5);  
  D_altri_redditi      NUMBER(15,5);  
  D_add_irpef          NUMBER(15,5);
  D_add_irpef_comu     NUMBER(15,5);
  D_acconto_com        NUMBER(15,5);
  D_acconto_com_sosp   NUMBER(15,5);
  D_acconto_com_trat   NUMBER(15,5);
  D_sosp_01            NUMBER(15,5);
  D_sosp_03            NUMBER(15,5);
  D_sosp_04            NUMBER(15,5);
  M_irpef_1r           NUMBER(15,5);
  M_irpef_2r           NUMBER(15,5);
  D_sosp_02            NUMBER(15,5);
  D_irpef_nr           NUMBER(15,5);
  D_add_reg_nr         NUMBER(15,5);
  D_add_com_nr         NUMBER(15,5);
  D_det_ass            NUMBER(15,5);
  D_oneri_01           NUMBER(15,5);
  D_oneri_02           NUMBER(15,5);
  D_oneri_03           NUMBER(15,5);
  D_oneri_04           NUMBER(15,5);
  D_oneri_05           NUMBER(15,5);
  D_oneri_06           NUMBER(15,5);
  D_oneri_07           NUMBER(15,5);
  D_oneri_08           NUMBER(15,5);
  D_oneri_09           NUMBER(15,5);
  D_oneri_10           NUMBER(15,5);
  D_oneri_11           NUMBER(15,5);
  D_oneri_12           NUMBER(15,5);
  D_oneri_13           NUMBER(15,5);
  D_oneri_14           NUMBER(15,5);
  D_oneri_15           NUMBER(15,5);
  D_oneri_16           NUMBER(15,5);
  D_oneri_17           NUMBER(15,5);
  D_oneri_18           NUMBER(15,5);
  D_oneri_19           NUMBER(15,5);
  D_oneri_20           NUMBER(15,5);
  D_oneri_21           NUMBER(15,5);
  D_oneri_22           NUMBER(15,5);
  D_oneri_23           NUMBER(15,5);
  D_oneri_24           NUMBER(15,5);
  D_oneri_25           NUMBER(15,5);
  D_oneri_26           NUMBER(15,5);
  D_oneri_27           NUMBER(15,5);
  D_oneri_28           NUMBER(15,5);
  D_oneri_29           NUMBER(15,5);
  D_somme_01           NUMBER(15,5);
  D_somme_02           NUMBER(15,5);
  D_somme_03           NUMBER(15,5);
  D_somme_04           NUMBER(15,5);
  D_somme_05           NUMBER(15,5);
  D_somme_06           NUMBER(15,5);
  D_somme_07           NUMBER(15,5);
  D_somme_08           NUMBER(15,5);
  D_somme_00           NUMBER(15,5);
  D_somme_09           NUMBER(15,5);
  D_somme_10           NUMBER(15,5);
  D_somme_11           NUMBER(15,5);
  D_somme_12           NUMBER(15,5);
  D_somme_13           NUMBER(15,5);
  D_somme_14           NUMBER(15,5);
  D_somme_16           NUMBER(15,5);
  D_quota_tfr          NUMBER(15,5);
  D_quota_erede        NUMBER(15,5);
  D_flag_erede         VARCHAR2(1);
  D_ap_succ            NUMBER(4);
  D_vari_02            NUMBER(15,5);
  D_irpef_trat         NUMBER(15,5);
  D_ipn_ap             NUMBER(15,5);
  D_ipn_aap            NUMBER(15,5);
  D_ipt_ap             NUMBER(15,5);
  D_ipt_sosp_ap        NUMBER(15,5);
  D_ded_base           NUMBER(15,5);
  D_ded_agg            NUMBER(15,5);
  D_ded_con            NUMBER(15,5);
  D_ded_fig            NUMBER(15,5);
  D_ded_alt            NUMBER(15,5);
  T_ipt_liq            NUMBER(15,5);
  T_lor_liq_ac         NUMBER(15,5);
  T_lor_liq_ap         NUMBER(15,5);
  T_ipt_liq_ap         NUMBER(15,5);
  T_lor_liq_2000       NUMBER(15,5);
  T_lor_liq_ap_2000    NUMBER(15,5);
  T_riv_tfr            NUMBER(15,5);
  D_tot_ipn_ord        NUMBER(15,5);
  D_tot_ipn_ass        NUMBER(15,5);
  D_add_irpef_trat     NUMBER(15,5);
  D_ter_cf             VARCHAR2(11);
  D_prec_cf            VARCHAR2(11);
  D_ipn_ord_prec       NUMBER(15,5);
  D_ipn_ass_prec       NUMBER(15,5);
  D_ipt_pag_prec       NUMBER(15,5);
  D_ipt_sosp_prec      NUMBER(15,5);
  D_add_irpef_prec     NUMBER(15,5);
  D_add_irpef_sosp_prec NUMBER(15,5);
  D_add_irpef_com_prec  NUMBER(15,5);
  D_add_irpef_com_sosp_prec NUMBER(15,5);
  d_tot_neg_cas57      NUMBER(15,5);
  d_tot_neg_cas58      NUMBER(15,5);
  d_tot_neg_cas59      NUMBER(15,5);
  d_tot_neg_cas60      NUMBER(15,5);
  d_tot_a_cas57        NUMBER(15,5);
  d_tot_a_cas58        NUMBER(15,5);
  d_tot_a_cas59        NUMBER(15,5);
  d_tot_a_cas60        NUMBER(15,5);
  D_casella_59         NUMBER(15,5);
  D_tot_casella_59     NUMBER(15,5);
  D_alq                NUMBER(15,5);
  D_ipn_ap_d           NUMBER(15,5);
  D_ipn_aap_d          NUMBER(15,5);
  D_ipt_aap_d          NUMBER(15,5);
  D_ipt_sosp_d         NUMBER(15,5);
  D_contributi_inps    NUMBER(15,5);
  D_presenza_tfr       NUMBER(15,5);
  P_sfasato            VARCHAR2(1);
  V_controllo          varchar2(1) := null ;
  USCITA               EXCEPTION;
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
  IF nvl(D_ci,0) = 0 and D_tipo = 'S' THEN
     P_errore := 'A05721';
     RAISE USCITA;
  ELSIF nvl(D_ci,0) != 0 and D_tipo = 'T' THEN
     P_errore := 'A05721';
     RAISE USCITA;
  END IF;
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
     P_errore := 'P05130';
     RAISE USCITA;
     END IF;
   WHEN OTHERS THEN NULL;
  END;
-- la valorizzazione delle date sfasate e sul cnocu in quando nel carfi non serve
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
      D_dal := to_date(D_ini_a,'ddmmyyyy');
      D_al  := to_date(D_fin_a,'ddmmyyyy');
  END;

   BEGIN
    SELECT valore
      INTO D_evento_eccezionale
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_EVENTO'
     ;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_evento_eccezionale := null;
   END;

  BEGIN
    SELECT ENTE     D_ente
         , utente   D_utente
         , ambiente D_ambiente
      INTO D_ente,D_utente,D_ambiente
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ente     := NULL;
      D_utente   := NULL;
      D_ambiente := NULL;
  END;
--
-- Cancellazione Archiviazione precedente relativa all'anno richiesto
--
  LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
  ;
  DELETE FROM DENUNCIA_FISCALE defs
   WHERE defs.anno             = D_anno
     AND defs.ci IN (SELECT ci
                      FROM PERIODI_RETRIBUTIVI
                 WHERE defs.ci = ci
                        AND gestione LIKE D_gestione)
     AND (    D_tipo = 'T'
           OR ( D_tipo IN ('I','V','P') AND NOT EXISTS
                 (SELECT 'x' FROM DENUNCIA_FISCALE
                   WHERE anno       = defs.anno
                     AND ci         = defs.ci
                     AND NVL(tipo_agg,' ') = DECODE(D_tipo
                                                    ,'P',tipo_agg,
                                                        D_tipo)
                 )
              )
           OR ( D_tipo = 'C' AND (EXISTS
                 (SELECT 'x'
                    FROM PERIODI_GIURIDICI pegi
                   WHERE pegi.rilevanza = 'P'
                     AND pegi.ci         = defs.ci
                     AND pegi.dal        =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= D_al
                         )
                     AND pegi.al BETWEEN D_dal
                                     AND D_al
                 )
                 OR EXISTS
                 (SELECT 'x'
                    FROM PERIODI_GIURIDICI pegi
                   WHERE pegi.rilevanza = 'P'
                     AND pegi.ci        = defs.ci
                     AND pegi.dal       =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= D_al
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
                                 BETWEEN D_dal
                                     AND D_al
                             AND NVL(ipn_ord,0)  + NVL(ipn_liq,0)
                                 +NVL(ipn_ap,0)  + NVL(lor_liq,0)
                                 +NVL(lor_acc,0) != 0
                             AND MENSILITA != '*AP'
                         )
                 ))
              )
           OR (D_tipo = 'S' AND defs.ci = D_ci
              )
          )
     AND EXISTS
        (SELECT 'x'
           FROM RAPPORTI_INDIVIDUALI rain
          WHERE rain.ci = defs.ci
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
-- dbms_output.put_line('Cancellazione effettuata: '||to_char(sysdate,'sssss'));
 FOR CUR_CI IN
   (SELECT prfi.ci,
           MAX(rain.ni)       ni,
           MAX(clra.cat_fiscale)  cat_fiscale,
           MAX(pere.gestione)     gestione
      FROM progressivi_fiscali  prfi,
           PERIODI_RETRIBUTIVI  pere,
           RAPPORTI_INDIVIDUALI rain,
           CLASSI_RAPPORTO      clra
      WHERE pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                             AND TO_DATE(D_fin_a,'ddmmyyyy')
        AND pere.competenza    = 'A'
        AND pere.gestione   LIKE D_gestione
        AND pere.ci            = prfi.ci
        AND rain.ci            = prfi.ci
        AND rain.rapporto      = clra.codice
        AND clra.cat_fiscale   IN ('1','10','15','2','20','25')
        AND NOT EXISTS
            (SELECT 'x'
               FROM RAPPORTI_DIVERSI radi
              WHERE prfi.ci = radi.ci_erede
                and radi.rilevanza in ('L','R')
                and radi.anno = D_anno
            )
        AND prfi.anno      = D_anno
        AND prfi.mese      = 12
        AND prfi.MENSILITA =
            (SELECT MAX(MENSILITA)
            FROM MENSILITA
              WHERE mese = 12
                AND tipo IN ('N','A','S')
          )
        AND (    D_tipo = 'T'
           OR ( D_tipo IN ('I','V','P') AND NOT EXISTS
                 (SELECT 'x' FROM DENUNCIA_FISCALE
                   WHERE anno       = prfi.anno
                     AND ci         = prfi.ci
                     AND NVL(tipo_agg,' ') = DECODE(D_tipo
                                                    ,'P',tipo_agg,
                                                        D_tipo)
                 )
              )
           OR ( D_tipo = 'C' AND (EXISTS
                 (SELECT 'x'
                    FROM PERIODI_GIURIDICI pegi
                   WHERE pegi.rilevanza = 'P'
                     AND pegi.ci         = prfi.ci
                     AND pegi.dal        =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= D_al
                         )
                     AND pegi.al BETWEEN D_dal
                                     AND D_al
                 )
                 OR EXISTS
                 (SELECT 'x'
                    FROM PERIODI_GIURIDICI pegi
                   WHERE pegi.rilevanza = 'P'
                     AND pegi.ci        = prfi.ci
                     AND pegi.dal       =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= D_al
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
                                 BETWEEN D_dal
                                     AND D_al
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
          WHERE rain.ci = prfi.ci
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
      GROUP BY prfi.ci
     HAVING NVL(SUM(prfi.ipn_ac),0) +
            NVL(SUM(prfi.ipn_ap),0) +
            NVL(SUM(prfi.lor_liq),0) +
            NVL(SUM(prfi.lor_acc),0) +
            NVL(SUM(prfi.ipt_liq),0) != 0
	UNION ALL
     SELECT prfi.ci,
            MAX(rain.ni)       ni,
            MAX(clra.cat_fiscale)  cat_fiscale,
            MAX(pere.gestione)     gestione
       FROM progressivi_fiscali  prfi,
            PERIODI_RETRIBUTIVI  pere,
            RAPPORTI_INDIVIDUALI rain,
            CLASSI_RAPPORTO      clra
      WHERE pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                             AND TO_DATE(D_fin_a,'ddmmyyyy')
        AND pere.competenza    = 'A'
        AND pere.gestione   LIKE D_gestione
        AND pere.ci            = prfi.ci
        AND rain.ci            = prfi.ci
        AND rain.rapporto      = clra.codice
        AND clra.cat_fiscale   IN ('1','10','15','2','20','25')
        AND D_tipo  = 'S'
        AND pere.ci = D_ci
        AND NOT EXISTS
            (SELECT 'x'
               FROM RAPPORTI_DIVERSI radi
              WHERE prfi.ci = radi.ci_erede
                and radi.rilevanza in ('L','R')
                and radi.anno = D_anno
            )
        AND prfi.anno      = D_anno
        AND prfi.mese      = 12
        AND prfi.MENSILITA =
            (SELECT MAX(MENSILITA)
            FROM MENSILITA
              WHERE mese = 12
                AND tipo IN ('N','A','S')
            )
        AND EXISTS
           (SELECT 'x'
              FROM RAPPORTI_INDIVIDUALI rain
             WHERE rain.ci = prfi.ci
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
      GROUP BY prfi.ci
     HAVING NVL(SUM(prfi.ipn_ac),0) +
            NVL(SUM(prfi.ipn_ap),0) +
            NVL(SUM(prfi.lor_liq),0) +
            NVL(SUM(prfi.lor_acc),0) +
            NVL(SUM(prfi.ipt_liq),0) != 0
	UNION ALL
     SELECT rain.ci,
            MAX(rain.ni)       ni,
            MAX(clra.cat_fiscale)  cat_fiscale,
            MAX(pere.gestione)     gestione
       from PERIODI_RETRIBUTIVI  pere,
            RAPPORTI_INDIVIDUALI rain,
            CLASSI_RAPPORTO      clra
      where rain.ci + 0        = pere.ci
        AND rain.rapporto      = clra.codice
        AND clra.cat_fiscale   IN ('1','10','15','2','20','25')
        AND pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                             AND TO_DATE(D_fin_a,'ddmmyyyy')
        AND pere.competenza    = 'A'
        AND pere.gestione   LIKE D_gestione
        AND exists (select 'x' from movimenti_contabili moco
                     where moco.ci         = rain.ci 
                       and moco.anno       = D_anno
                       and moco.mensilita != '*AP'
                       and (moco.voce,moco.sub) in (select voce, sub
                                                      from estrazione_righe_contabili esrc
                                                     where estrazione = 'DENUNCIA_CUD'
                                                       and colonna    = 'PREV_04'
                                                       and esrc.dal <= TO_DATE(D_fin_a,'ddmmyyyy')
                                                       and esrc.al >= TO_DATE(D_ini_a,'ddmmyyyy')
                                                     )
                   )
        AND NOT EXISTS
            (SELECT 'x'
               FROM RAPPORTI_DIVERSI radi
              WHERE rain.ci = radi.ci_erede
                and radi.rilevanza in ('L','R')
                and radi.anno = D_anno
            )
        AND (    D_tipo = 'T'
           OR ( D_tipo IN ('I','V','P') AND NOT EXISTS
                 (SELECT 'x' FROM DENUNCIA_FISCALE
                   WHERE anno       = D_anno
                     AND ci         = rain.ci
                     AND NVL(tipo_agg,' ') = DECODE(D_tipo
                                                    ,'P',tipo_agg,
                                                        D_tipo)
                 )
              )
           OR ( D_tipo = 'C' AND (EXISTS
                 (SELECT 'x'
                    FROM PERIODI_GIURIDICI pegi
                   WHERE pegi.rilevanza = 'P'
                     AND pegi.ci         = rain.ci
                     AND pegi.dal        =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= D_al
                         )
                     AND pegi.al BETWEEN D_dal
                                     AND D_al
                 )
                 OR EXISTS
                 (SELECT 'x'
                    FROM PERIODI_GIURIDICI pegi
                   WHERE pegi.rilevanza = 'P'
                     AND pegi.ci        = rain.ci
                     AND pegi.dal       =
                         (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                           WHERE rilevanza = 'P'
                             AND ci        = pegi.ci
                             AND dal      <= D_al
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
                                 BETWEEN D_dal
                                     AND D_al
                             AND MENSILITA != '*AP'
                         )
                 ))
              )
          )
        AND (   D_tipo = 'S' AND rain.ci = D_ci
             OR D_tipo != 'S' 
            )
        AND EXISTS
           (SELECT 'x'
              FROM RAPPORTI_INDIVIDUALI rain
             WHERE rain.ci = rain.ci
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
     group by rain.ci
   )LOOP
-- D_riga := D_riga + 1;
-- dbms_output.put_line('CI: '||CUR_CI.ci||' '||to_char(sysdate,'sssss'));
        T_lor_liq_ac  := 0;
        T_riv_tfr     := 0;
        T_lor_liq_ap  := 0;
        T_ipt_liq     := 0;
        T_ipt_liq_ap  := 0;
        T_lor_liq_2000 := 0;
        T_lor_liq_ap_2000 := 0;
        D_maggiore_ritenuta := null;
        D_ipn_ded           := null;
        D_ipn_ded_magg      := null;
        D_altri_redditi     := null;
        D_acconto_com       := null;
        D_acconto_com_sosp  := null;
        D_acconto_com_trat  := null;

   BEGIN
     --
     --  Estrazione Flag Previdenza complementare (Parte A Dati Generali) -- C103
     --
     BEGIN 
	 SELECT max(substr(nvl(esvc.note,' '),1,1))
         INTO D_prev_com
         FROM estrazione_valori_contabili esvc
            , estrazione_righe_contabili esrc
        WHERE esvc.estrazione = 'DENUNCIA_CUD'
          AND esvc.colonna in ('PREV_09','PREV_10','PREV_11','PREV_12','PREV_99')
          AND to_date(D_fin_a,'ddmmyyyy') between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
          AND esrc.estrazione = esvc.estrazione
          AND esrc.colonna = esvc.colonna
          AND esrc.dal = esvc.dal
          AND exists (select 'x' from movimenti_contabili
                       where anno = D_anno
                         and ci = CUR_CI.ci
                         and voce = esrc.voce
                         and sub = esrc.sub
                         and mensilita != '*AP'
                         and nvl(imp,0) != 0
                      )
       ;
       END;
     --
     --  Estrazione Flag Richiesta non applicazione deduzione -- C4
     --
      BEGIN
       SELECT tipo_spese, spese
         INTO d_tipo_spese, d_spese
         FROM RAPPORTI_RETRIBUTIVI_STORICI rars
        WHERE ci = CUR_CI.ci
          AND TO_DATE(D_fin_a,'ddmmyyyy') BETWEEN NVL(rars.dal,TO_DATE('2222222','j'))
                                              AND NVL(rars.al,TO_DATE('3333333','j'))
       ;
      IF D_tipo_spese in ('DD','DP') then
         IF d_spese = 0 then
            D_ded_non_appl := 1;
         ELSE 
            D_ded_non_appl := 0;
         END IF;
      ELSE 
         D_ded_non_appl := 0;
      END IF;
      EXCEPTION
        WHEN TOO_MANY_ROWS THEN
          D_tipo_spese := NULL;
          D_spese      := NULL;
          D_riga       := D_riga +1;
          D_cod_errore   := 'P01065';  --  Esistono piu Rapporti validi per lo stesso Individuo
          D_precisazione := substr('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,200);
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione);
        WHEN NO_DATA_FOUND THEN
          D_tipo_spese := NULL;
          D_spese      := NULL;
          D_riga := D_riga +1;
          D_cod_errore   := 'P05700';  -- Rapporto Retributivo non presente
          D_precisazione := substr('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,200);
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione);
      END;
     --
     --  Estrazione Giorni Deduzioni -- C6 e C7
     --
      BEGIN
        SELECT NVL(LEAST(365,SUM(pere.gg_det)),0)
         INTO D_gg_det
         FROM PERIODI_RETRIBUTIVI   pere
            , ENTE
        WHERE ente_id           = 'ENTE'
          AND pere.anno+0        = D_anno
          AND pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                               AND TO_DATE(D_fin_a,'ddmmyyyy')
          AND (   TO_CHAR(pere.al,'yyyy') = D_anno
               OR detrazioni_ap = 'SI')
          AND pere.competenza   IN ('A','C','P')
          AND pere.servizio      = 'Q'
          AND pere.ci           IN
              (SELECT CUR_CI.ci
                 FROM dual
                UNION
               SELECT ci_erede
                 FROM RAPPORTI_DIVERSI radi
                WHERE CUR_CI.ci = radi.ci
 --                 AND radi.rilevanza in ('L','R')
 -- ATTENZIONE: e da verificare rispetto a come sono memorizzati i dati su PERE
 -- per i casi di precdente rapporto con l'ente e CUD da altro datore di lavoro:
 -- la lettura di PERE anche del precedente ha senso se non esiste *R* su PERE del DIP
                  AND radi.rilevanza in ('L')
                  AND radi.anno = D_anno
              )
          AND not exists (select 'x' from rapporti_diversi
                           where rilevanza = 'E'
                             and ci = CUR_CI.ci)
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          --
          --  Estrazione Giorni Detrazione (solo progressivi)
          --
          SELECT TO_NUMBER(ROUND(SUM(NVL(prfi.det_spe,0))
                                / (MAX(DEFI.importo)*12/365)))
            INTO D_gg_det
            FROM progressivi_fiscali   prfi
               , DETRAZIONI_FISCALI    DEFI
           WHERE prfi.anno         = D_anno
             AND prfi.mese         = 12
             AND prfi.MENSILITA    = (SELECT MAX(MENSILITA) FROM MENSILITA
                                       WHERE mese = 12
                                         AND tipo IN ('N','S','A'))
             AND prfi.ci           = CUR_CI.ci
             AND DEFI.tipo         = 'DD'
             AND DEFI.scaglione    = 1
             AND DEFI.codice       = '*'
             AND D_fin_a     BETWEEN NVL(DEFI.dal,TO_DATE('2222222','j'))
                                 AND NVL(DEFI.al,TO_DATE('3333333','j'))
          ;
      END;
      IF D_gg_det < 0 THEN
	   D_gg_det := 0;
         D_gg_det_dd := 0;
         D_gg_det_dp := 0;
         D_riga := D_riga +1;
         D_cod_errore   := 'P05040'; -- Numero di giorni per detrazione negativo
         D_precisazione := substr('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,200);
-- dbms_output.put_line('SEER 1: '||D_riga||' '||to_char(sysdate,'sssss'));
         INSERT INTO a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         VALUES (prenotazione,passo,D_riga,D_cod_errore, D_precisazione);
         ELSE
             SELECT DECODE(D_tipo_spese,'DP',null,D_gg_det),
                    DECODE(D_tipo_spese,'DP',D_gg_det,null)
               INTO D_gg_det_dd,
                    D_gg_det_dp
               FROM dual
             ;
       END IF;
-- dbms_output.put_line('GG_DET: '||D_gg_det||' '||to_char(sysdate,'sssss'));

      BEGIN
        SELECT 'x'
          INTO D_dec
          FROM RAPPORTI_DIVERSI radi
         WHERE ci_erede  = CUR_CI.ci
           AND rilevanza = 'E'
           AND anno      = D_anno
      ;
      EXCEPTION
        WHEN TOO_MANY_ROWS THEN
          D_dec := 'x';
        WHEN NO_DATA_FOUND THEN
          D_dec := NULL;
          BEGIN
            SELECT MAX('x')
              INTO D_ipt_ere
              FROM progressivi_fiscali   prfi
             WHERE prfi.anno         = D_anno
               AND prfi.mese         = 12
               AND prfi.MENSILITA    =
                   (SELECT MAX(MENSILITA)
                      FROM MENSILITA
                     WHERE mese = 12
                       AND tipo IN ('A','N','S')
                   )
               AND prfi.ci =  CUR_CI.ci
             GROUP BY prfi.ci
            HAVING NVL(SUM(prfi.ipt_liq),0) != 0
            ;
            BEGIN
            SELECT quota_erede
              INTO D_quota_erede
              FROM RAPPORTI_DIVERSI radi
             WHERE ci = CUR_CI.ci
               AND rilevanza = 'E'
               AND anno = D_anno
            ;
            END;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              D_quota_erede := null;
              D_ipt_ere   := '';
          END;

           BEGIN
            SELECT 'X'
              INTO D_flag_erede
              FROM RAPPORTI_DIVERSI radi
             WHERE ci = CUR_CI.ci
               AND rilevanza = 'E'
               AND anno = D_anno
            ;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              D_flag_erede := null;
          END;

          IF D_flag_erede = 'X' THEN
           BEGIN
            SELECT min(anno)
              INTO D_ap_succ
              FROM RAPPORTI_DIVERSI radi
             WHERE ci = CUR_CI.ci
               AND rilevanza = 'E'
            ;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              D_ap_succ := D_anno;
          END;
          END IF;

            
            BEGIN
            SELECT NVL(SUM(prfi.lor_acc),0) +
                   NVL(SUM(prfi.lor_liq),0)            T_LOR_LIQ_AC
                 , NVL(sum(prfi.riv_tfr_ap_liq), 0) +
                   NVL(sum(prfi.riv_tfr_liq), 0)       T_riv_tfr
                 , DECODE( NVL(SUM(prfi.lor_acc),0) +
                           NVL(SUM(prfi.lor_acc_2000),0) +
                           NVL(SUM(prfi.lor_liq),0)
                           , 0, 0
                              , NVL(SUM(prfi.ant_liq_ap),0) +
                                NVL(SUM(prfi.ant_acc_ap),0)
                          )                            T_LOR_LIQ_AP
                 , DECODE(NVL(SUM(prfi.lor_acc),0) +
                          NVL(SUM(prfi.lor_acc_2000),0) +
                          NVL(SUM(prfi.lor_liq),0)
                          , 0, 0
                             , NVL(SUM(prfi.ipt_liq),0)
                             - NVL(SUM(prfi.det_liq),0)
                             - NVL(SUM(prfi.dtp_liq),0)
                         )                             T_IPT_LIQ
                 , DECODE( NVL(SUM(prfi.lor_acc),0) +
                           NVL(SUM(prfi.lor_acc_2000),0) +
                           NVL(SUM(prfi.lor_liq),0)
                           , 0, 0
                              , NVL(SUM(prfi.ipt_liq_ap),0)
                          )                            T_IPT_LIQ_AP
                , NVL(SUM(prfi.lor_acc_2000),0)        T_LOR_LIQ_2000
                , DECODE( NVL(SUM(prfi.lor_acc_2000),0)
                        , 0, 0
                           , NVL(SUM(prfi.ant_acc_2000),0)
                        )                              T_LOR_LIQ_AP_2000
            INTO T_lor_liq_ac,  T_riv_tfr, T_lor_liq_ap
                ,T_ipt_liq,T_ipt_liq_ap
                ,T_lor_liq_2000,T_lor_liq_ap_2000
            FROM progressivi_fiscali   prfi
           WHERE prfi.anno         = D_anno
             AND prfi.mese         = 12
             AND prfi.MENSILITA    =
                 (SELECT MAX(MENSILITA)
                    FROM MENSILITA
                   WHERE mese = 12
                     AND tipo IN ('A','N','S')
                  )
             AND prfi.ci = CUR_CI.ci
           GROUP BY prfi.ci
          HAVING NVL(SUM(prfi.lor_acc),0) +
                 NVL(SUM(prfi.lor_acc_2000),0) +
                 NVL(SUM(prfi.lor_liq),0)  != 0
          ;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         T_lor_liq_ac  := 0;
         T_riv_tfr     := 0;
         T_lor_liq_ap  := 0;
         T_ipt_liq     := 0;
         T_ipt_liq_ap  := 0;
         T_lor_liq_2000 := 0;
         T_lor_liq_ap_2000 := 0;
      END;
       IF T_lor_liq_ac + T_riv_tfr + T_lor_liq_ap + T_ipt_liq + T_ipt_liq_ap != 0 THEN
         LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
         ;
 -- dbms_output.put_line('Insert DEFI 1'||' '||to_char(sysdate,'sssss'));
         INSERT INTO
         DENUNCIA_FISCALE( anno,ci,rilevanza
                         , c69
                         , c70
                         , c71
                         , c72
                         , utente,data_agg)
                   SELECT D_anno,CUR_CI.ci,'D'
                        , T_lor_liq_ac +  T_riv_tfr
                        , T_lor_liq_ap
                        , T_ipt_liq
                        , T_ipt_liq_ap
                        , D_utente, SYSDATE
                      FROM dual
         ;
-- dbms_output.put_line('Ind. Denuncia fiscale1'||' '||to_char(sysdate,'sssss'));
       END IF;
       IF T_lor_liq_2000 + T_lor_liq_ap_2000 != 0 THEN
         LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
         ;
-- dbms_output.put_line('Insert DEFI 2'||' '||to_char(sysdate,'sssss'));
         INSERT INTO
         DENUNCIA_FISCALE( anno,ci,rilevanza
                         , c69
                         , c70
                         , c71
                         , c72
                         , utente,data_agg)
                   SELECT D_anno,CUR_CI.ci,'D'
                        , T_lor_liq_2000
                        , T_lor_liq_ap_2000
                        , NULL
                        , NULL
                        , D_utente,SYSDATE
                      FROM dual
         ;
-- dbms_output.put_line('Ind. Denuncia fiscale2'||' '||to_char(sysdate,'sssss'));
       END IF;
    END;
    
      BEGIN
-- dbms_output.put_line('inizio select da prfi'||' '||to_char(sysdate,'sssss'));
        SELECT NVL(SUM(prfi.ipn_ac ),0) - SUM(prfi.ipn_ass) - NVL(SUM(prfi.ipn_ter_ass),0)  ipn_ord
             , NVL(SUM(prfi.ipn_ass),0) + NVL(SUM(prfi.ipn_ter_ass),0) ipn_ass
             , NVL(SUM(prfi.det_fis),0)
              -NVL(SUM(prfi.det_con),0)
              -NVL(SUM(prfi.det_fig),0)
              -NVL(SUM(prfi.det_alt),0)
              -NVL(SUM(prfi.det_spe),0)
              -NVL(SUM(prfi.det_ult),0)
             , NVL(SUM(prfi.ipt_ac),0)
             , GREATEST(0,NVL(SUM(prfi.ipt_pag),0))
             , NVL(SUM(prfi.add_irpef_pag),0)
             , NVL(SUM(prfi.add_irpef_comunale_pag),0)
             , NVL(SUM(prfi.ipn_ap),0)-NVL(SUM(prfi.ipn_aap),0)
             , NVL(SUM(prfi.ipn_aap),0)
             , NVL(SUM(prfi.ipt_ap),0)
             , NVL(SUM(prfi.somme_17),0)
             , NVL(SUM(prfi.ded_base_ac),0)
             , NVL(SUM(prfi.ded_agg_ac),0)
             , NVL(SUM(prfi.ded_con_ac),0)
             , NVL(SUM(prfi.ded_fig_ac),0)
             , NVL(SUM(prfi.ded_alt_ac),0)
          INTO D_ipn_ord
             , D_ipn_ass
             , D_det_ass
             , D_ipt_ac
             , D_ipt_pag
             , D_add_irpef
             , D_add_irpef_comu
             , D_ipn_ap
             , D_ipn_aap
             , D_ipt_ap
             , D_ipt_sosp_ap
             , D_ded_base
             , D_ded_agg
             , D_ded_con
             , D_ded_fig
             , D_ded_alt
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
-- dbms_output.put_line('fine select da prfi'||' '||to_char(sysdate,'sssss'));
      BEGIN
-- dbms_output.put_line('inizio select da vaca'||' '||to_char(sysdate,'sssss'));
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
                             , 'CONG_01', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'CONG_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'CONG_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         cong_01
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'CONG_02', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'CONG_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'CONG_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         cong_02
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'VARI_03', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'VARI_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'VARI_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         altri_03
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOSP_01', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOSP_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOSP_01',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         sosp_01
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOSP_02', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOSP_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOSP_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         sosp_02
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOSP_03', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOSP_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOSP_03',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         sosp_03
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOSP_04', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOSP_04',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOSP_04',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         sosp_04
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
                             , 'VARI_02', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'VARI_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'VARI_02',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         altri_02
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
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_10', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_10',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_10',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_10
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_13', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_13',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_13',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_13
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_14', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_14',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_14',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_14
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_11', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_11',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_11',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_11
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_12', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_12',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_12',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_12
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'SOMME_16', vaca.valore
                                        , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'SOMME_16',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'SOMME_16',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)         somme_16
          INTO D_oneri_01,D_oneri_02,D_oneri_03,D_oneri_04
             , D_oneri_05,D_oneri_06,D_oneri_07,D_oneri_08
             , D_oneri_09,D_oneri_10,D_oneri_11,D_oneri_12
             , D_oneri_13,D_oneri_14,D_oneri_15,D_oneri_16
             , D_oneri_17,D_oneri_18,D_oneri_19,D_oneri_20
             , D_oneri_21,D_oneri_22,D_oneri_23,D_oneri_24
             , D_oneri_25,D_oneri_26,D_oneri_27,D_oneri_28
             , D_oneri_29
             , D_irpef_trat,D_add_irpef_trat,D_quota_tfr
             , D_sosp_01,D_sosp_02,D_sosp_03,D_sosp_04
             , D_somme_01,D_somme_02,D_somme_03,D_somme_04
             , D_somme_05,D_somme_06,D_somme_07,D_somme_08
             , D_vari_02
             , D_somme_00, D_somme_09, D_somme_10, D_somme_13, D_somme_14
             , D_somme_11, D_somme_12, D_somme_16 
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
-- dbms_output.put_line('fine select da vaca'||' '||to_char(sysdate,'sssss'));
      BEGIN
-- dbms_output.put_line('inizio select da deca'||' '||to_char(sysdate,'sssss'));
        SELECT DECODE( MAX(deca.conguaglio_1r)
                          , NULL, 0
                                , NVL(SUM(deca.irpef_cr),0)
                      )                               D_irpef_nr
             , DECODE( MAX(deca.conguaglio_1r)
                          , NULL, 0
                                , NVL(SUM(deca.add_reg_dic_cr),0)
                                 +NVL(SUM(deca.add_reg_con_cr),0))
                                                      D_add_reg_nr
             , DECODE( MAX(deca.conguaglio_1r)
                          , NULL, 0
                                , NVL(SUM(deca.add_com_dic_cr),0)
                                 +NVL(SUM(deca.add_com_con_cr),0))
                                                      D_add_com_nr
          INTO D_irpef_nr,D_add_reg_nr,D_add_com_nr
          FROM DENUNCIA_CAAF deca
         WHERE deca.anno      = D_anno - 1
           AND deca.ci        = CUR_CI.ci
           AND deca.rettifica != 'M'
        ;
      END;

     --
     --  Estrazione acconto addizionale per casella 7 bis 
     --

     BEGIN
      select nvl(imp_tot,0)
        into D_acconto_com
        from informazioni_retributive
       where ci = CUR_CI.ci
         and to_char(dal,'yyyy') = D_anno+1
         and voce in ( select codice 
                         from voci_economiche
                        where specifica = 'ADD_COM_AC'
                     )
         and sub = substr(D_anno+1,3,2)
        ;
     EXCEPTION 
          WHEN NO_DATA_FOUND THEN
               D_acconto_com := 0;
          WHEN TOO_MANY_ROWS THEN
               D_acconto_com := 0;
               D_riga       := D_riga +1; 
               D_cod_errore   := 'P05728';  -- Esiste Informazione Retributiva collegata a
               D_precisazione := substr(' CI: '||TO_CHAR(CUR_CI.ci)||' - Controllare AINRA',1,200);
               INSERT INTO a_segnalazioni_errore
               (no_prenotazione,passo,progressivo,errore,precisazione)
               select prenotazione,1,D_riga,D_cod_errore,D_precisazione
                 from dual
                where not exists ( select 'x'
                                     from a_segnalazioni_errore
                                    where no_prenotazione = prenotazione
                                      and passo = 1
                                      and errore = D_cod_errore
                                      and precisazione = D_precisazione
                                 );
     END;

     --
     --  Estrazione saldo acconto addizionale comunale
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

/* Inizio estrazione dati per sezione AP */

-- dbms_output.put_line('fine select da deca'||' '||to_char(sysdate,'sssss'));
      IF D_ipn_ap + D_ipn_aap + D_ipt_sosp_ap != 0 THEN
          D_min_anno_prec := 0;
          D_casella_59 := 0;
          D_alq        := 0;
       SELECT MAX(TO_CHAR(moco.riferimento,'yyyy'))
         INTO D_min_anno_prec
        FROM MOVIMENTI_CONTABILI moco
              , CONTABILITA_VOCE covo
          WHERE moco.ci in ( select CUR_CI.ci
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
            AND (  (    covo.fiscale IN ('C','S','X')
                 AND moco.arr = 'P')
                 OR covo.fiscale IN ('P','Y')
             OR (covo.somme = '17')
                )
            AND moco.voce = covo.voce
            AND moco.sub = covo.sub
            AND (covo.somme = '17'
                OR covo.fiscale IN ('C','S','R','P','X','Y'))
            AND moco.riferimento BETWEEN NVL(covo.dal,TO_DATE('2222222','j'))
                                     AND NVL(covo.al,TO_DATE('3333333','j'))
         ;
        d_tot_neg_cas57 := 0;
        d_tot_neg_cas58 := 0;
        d_tot_neg_cas59 := 0;
        D_tot_casella_59 := 0;
        d_tot_neg_cas60 := 0;

-- dbms_output.put_line('inizio estrazione arr AP cur_arr_prec '||D_anno||'-'||D_min_anno_prec);

        FOR CUR_ARR_PREC IN
        (SELECT DECODE( TO_CHAR(moco.riferimento,'yyyy')
                     ,D_anno,D_min_anno_prec
                         ,TO_CHAR(moco.riferimento,'yyyy')) anno_rif
              , SUM(DECODE(covo.fiscale,'C',moco.imp,'S',moco.imp,'P',moco.imp,'R',moco.ipn_p,0)) casella_57
              , SUM(DECODE(covo.fiscale,'X',moco.imp,'Y',moco.imp,0))                casella_58
              , SUM(DECODE(covo.somme,'17',moco.imp,0))                              casella_60
           FROM MOVIMENTI_CONTABILI moco
              , CONTABILITA_VOCE covo
          WHERE moco.ci  in ( select CUR_CI.ci
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
            AND ( moco.mensilita != '*R*'
              and moco.ci = CUR_CI.ci
              and exists ( select 'x' 
                                 from rapporti_diversi 
                                where anno = D_anno
                                  and ci = CUR_CI.ci
                                  and rilevanza = 'R' 
                             )
               or moco.ci = CUR_CI.ci 
              and not exists ( select 'x' 
                                 from rapporti_diversi 
                                where anno = D_anno
                                  and ci = CUR_CI.ci
                                  and rilevanza = 'R' 
                             )
               or moco.ci in ( SELECT ci_erede
                               FROM RAPPORTI_DIVERSI radi
                              WHERE radi.ci = CUR_CI.ci
                                AND radi.rilevanza = 'R'
                                AND radi.anno = D_anno
                             )
                 )
            AND (   covo.fiscale IN ('C','S','X') AND moco.arr = 'P'
                 OR covo.fiscale IN ('P','Y')
                 OR covo.fiscale  = 'R'
                 OR covo.somme = '17'
                )
            AND moco.voce = covo.voce
            AND moco.sub = covo.sub
            AND (   covo.somme = '17'
                 OR covo.fiscale IN('C','S','R','P','X','Y'))
            AND moco.riferimento BETWEEN NVL(covo.dal,TO_DATE('2222222','j'))
                                     AND NVL(covo.al,TO_DATE('3333333','j'))
          GROUP BY DECODE( TO_CHAR(moco.riferimento,'yyyy')
                        ,D_anno,D_min_anno_prec
                            ,TO_CHAR(moco.riferimento,'yyyy'))
        HAVING SUM(DECODE(covo.fiscale,'C',moco.imp,'S',moco.imp,'P',moco.imp,'R',moco.ipn_p,0)) +
                SUM(DECODE(covo.fiscale,'X',moco.imp,'Y',moco.imp,0))                +
                SUM(DECODE(covo.somme,'17',moco.imp,0))                             <> 0
        ) LOOP

/* Per la gestione dei NEGATIVI:
verifica se quanto letto è negativo:
se sì lo archivia in un contatore in attesa di poterlo compensare con una cifra positiva (stop)
se no totalizza la somma con i negativi precedentemente archiviati
   se la somma così ottenuta è positiva la inserisce in DEFI ed azzera il contatore dei negativi
   se la somma così ottenuta è negativa aggiorna il contatore dei negativi con il "residuo" da compensare
*/
-- dbms_output.put_line('arr prec 57: '||CUR_ARR_PREC.casella_57);
          BEGIN
            SELECT MIN(qta) * -1
              INTO D_alq
              FROM MOVIMENTI_CONTABILI moco
             WHERE moco.ci in ( select CUR_CI.ci
                               FROM dual
                              UNION
                             SELECT ci_erede
                               FROM RAPPORTI_DIVERSI radi
                              WHERE CUR_CI.ci = radi.ci
                                AND radi.rilevanza = 'R'
                                AND radi.anno = D_anno
                           )
               AND moco.anno = D_anno
               and moco.mensilita != '*AP'
               AND moco.mese = (select max(mese)
                                  from movimenti_contabili
                                 where ci in ( select CUR_CI.ci
                                                 FROM dual
                                                UNION
                                               SELECT ci_erede
                                                 FROM RAPPORTI_DIVERSI radi
                                                WHERE CUR_CI.ci = radi.ci
                                                  AND radi.rilevanza = 'R'
                                                  AND radi.anno = D_anno
                                            )
                                   and anno = D_anno
                                   and mensilita != '*AP'
                                   and voce IN (SELECT codice
                                                  FROM VOCI_ECONOMICHE
                                                 WHERE automatismo IN ('IRPEF_AP','IRPEF_AAP')
                                               )
                               )
               AND moco.voce IN (SELECT codice
                                   FROM VOCI_ECONOMICHE
                                  WHERE automatismo IN ('IRPEF_AP','IRPEF_AAP')
                                )
            ;
            d_casella_59 := e_round((CUR_ARR_PREC.casella_57 + CUR_ARR_PREC.casella_58) * D_alq / 100,'I');
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               d_casella_59 := 0;
               d_alq        := 0;
           END;
-- dbms_output.put_line('cas.57 MOCO: '||CUR_ARR_PREC.casella_57);
-- dbms_output.put_line('cas.58 MOCO: '||CUR_ARR_PREC.casella_58);
-- dbms_output.put_line('cas.59 MOCO: '||D_casella_59);
-- dbms_output.put_line('cas.60 MOCO: '||CUR_ARR_PREC.casella_60);
-- dbms_output.put_line('Anno di riferimento: '||CUR_ARR_PREC.anno_rif);
           IF CUR_ARR_PREC.casella_57+CUR_ARR_PREC.casella_58 < 0 THEN
             d_tot_neg_cas57 := d_tot_neg_cas57 + CUR_ARR_PREC.casella_57;
             d_tot_neg_cas58 := d_tot_neg_cas58 + CUR_ARR_PREC.casella_58;
             d_tot_neg_cas59 := d_tot_neg_cas59 + D_casella_59;
             d_tot_neg_cas60 := d_tot_neg_cas60 + CUR_ARR_PREC.casella_60;
           ELSE
             LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
             ;
-- dbms_output.put_line('se positivo (prima -tot_a): '||d_tot_a_cas57||' '||to_char(sysdate,'sssss'));
             d_tot_a_cas57 := d_tot_neg_cas57 + CUR_ARR_PREC.casella_57;
             d_tot_a_cas58 := d_tot_neg_cas58 + CUR_ARR_PREC.casella_58;
             d_tot_a_cas59 := d_tot_neg_cas59 + D_casella_59;
             d_tot_a_cas60 := d_tot_neg_cas60 + CUR_ARR_PREC.casella_60;
-- dbms_output.put_line('se positivo (dopo-tot_a): '||d_tot_a_cas57||' '||to_char(sysdate,'sssss'));
             IF ( d_tot_a_cas57 + d_tot_a_cas58 ) > 0 or nvl( d_tot_a_cas60,0) > 0 THEN
-- dbms_output.put_line('insert: tot_a'||d_tot_a_cas57||' '||to_char(sysdate,'sssss'));
-- dbms_output.put_line('Insert DEFI 3'||' '||to_char(sysdate,'sssss'));
-- dbms_output.put_line('insert: tot_60: '||d_tot_a_cas60);
               INSERT INTO
               DENUNCIA_FISCALE(anno,ci,rilevanza,
                                c57,c58,
                                c59,c60,
                                c61,c62,
                                utente,data_agg)
                         SELECT D_anno,CUR_CI.ci,'D',
                                greatest(0,d_tot_a_cas57+decode( sign(d_tot_a_cas58)
                                                                ,-1,d_tot_a_cas58,0)),
                                greatest(0,d_tot_a_cas58+decode( sign(d_tot_a_cas57)
                                                                ,-1,d_tot_a_cas57,0)),
                                greatest(0,d_tot_a_cas59),d_tot_a_cas60,
                                null,CUR_ARR_PREC.anno_rif,
                                D_utente,SYSDATE
                           FROM dual
                          WHERE NOT EXISTS(SELECT 'x'
                                             FROM DENUNCIA_FISCALE
                                            WHERE anno = D_anno
                                              AND ci   = CUR_CI.ci
                                              AND rilevanza = 'D'
                                              AND c62 = CUR_ARR_PREC.anno_rif
                                          )
              ;
             END IF;
-- dbms_output.put_line('quasi alla fine tot_neg: '||d_tot_neg_cas57||' '||to_char(sysdate,'sssss'));
-- dbms_output.put_line('quasi alla fine cas_57: '||CUR_ARR_PREC.casella_57||' '||to_char(sysdate,'sssss'));
             d_tot_neg_cas57 := least(0,d_tot_neg_cas57 + CUR_ARR_PREC.casella_57);
             d_tot_neg_cas58 := least(0,d_tot_neg_cas58 + CUR_ARR_PREC.casella_58);
             d_tot_neg_cas59 := least(0,d_tot_neg_cas59 + d_casella_59);
             d_tot_neg_cas60 := least(0,d_tot_neg_cas60 + CUR_ARR_PREC.casella_60);
-- dbms_output.put_line('alla fine tot_neg: '||d_tot_neg_cas60||' '||to_char(sysdate,'sssss'));
           END IF;
        END LOOP; -- cur_arr_prec
        BEGIN
          select sum(nvl(c59,0))
            into D_tot_casella_59
            from denuncia_fiscale
           where anno = D_anno
             and ci = CUR_CI.ci
             and rilevanza = 'D'
             and nvl(c59,0) != 0;
        EXCEPTION WHEN NO_DATA_FOUND THEN
             D_tot_casella_59 := 0;
        END;

-- dbms_output.put_line('tot casella 59 : '||D_tot_casella_59);
-- dbms_output.put_line('tot casella 60 : '||d_tot_a_cas60);
      IF round(nvl(d_tot_a_cas60,0)) != 0 THEN
        IF  round( nvl(D_tot_casella_59,0) ) = round(nvl(d_tot_a_cas60,0)) THEN
            update denuncia_fiscale 
              set C60 = C59
             where anno = D_anno
               and ci = CUR_CI.ci
               and rilevanza = 'D'
               and nvl(c60,0) != nvl(c59,0);
        ELSE
-- dbms_output.put_line('casella 60 non inserita: '||d_tot_a_cas60);
              D_riga := D_riga + 1;
              D_cod_errore   := 'P06716'; -- Attenzione: i dati sono incongruenti, verificare
              D_precisazione := substr(' Casella 60 per il CI: '||TO_CHAR(CUR_CI.ci),1,200);
              INSERT INTO a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
              VALUES (prenotazione,passo,D_riga, D_cod_errore, D_precisazione)
              ;
        END IF;
      END IF; 
-- dbms_output.put_line('negativi rimasti non inseriti: '||d_tot_neg_cas57||' '||to_char(sysdate,'sssss'));
        IF d_tot_neg_cas57 < 0 THEN
              D_riga := D_riga + 1;
              D_cod_errore   := 'P05840'; -- Esistono Valori Negativi
              D_precisazione := substr('CI: '||TO_CHAR(CUR_CI.ci)||' Caselle ficale AP negative non archiviate',1,200);
-- dbms_output.put_line('SEER 2: '||D_riga||' '||to_char(sysdate,'sssss'));
              INSERT INTO a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
              VALUES (prenotazione,passo,D_riga, D_cod_errore, D_precisazione)
              ;
        END IF;
      END IF;
/* Fine estrazione dati per sezione AP */

/* sono dati per il 770; non avendo ancora il modello sono stati inseriti i campi che lo scorso 
anno erano dal 50 al 59 come C102 e da C47 a C56 */

-- dbms_output.put_line('CI in elab.:'||CUR_CI.ci||' '||to_char(sysdate,'sssss'));
-- dbms_output.put_line('inizio cur prec');
      FOR CUR_PREC IN
        (SELECT radi.ci_erede               ci
              , SUBSTR(pegi.note,1,15)      cf
              , DECODE( INSTR(NVL(UPPER(evra.descrizione),' '),'MOD. 770')
                      , '0', evra.codice
                           , SUBSTR(evra.descrizione,11,1)
                      ) causa_a
           FROM PERIODI_GIURIDICI   pegi
              , RAPPORTI_DIVERSI    radi
              , EVENTI_RAPPORTO     evra
          WHERE radi.ci            = CUR_CI.ci
            AND evra.codice        = pegi.posizione
            AND evra.rilevanza     = 'T'
            AND pegi.rilevanza     = 'P'
            and pegi.dal = (select max(dal) from periodi_giuridici
                             where ci = pegi.ci
                               and rilevanza = 'P')
            AND pegi.ci            = radi.ci_erede
            AND radi.rilevanza     = 'L'
            AND radi.anno          = D_anno
            AND EXISTS
                (SELECT 'x'
               FROM progressivi_fiscali        prfi
                  WHERE prfi.anno    = D_anno
                    AND prfi.mese      = 12
                    AND prfi.MENSILITA =
                       (SELECT MAX(MENSILITA)
                     FROM MENSILITA
                         WHERE mese = 12
                           AND tipo IN ('N','A','S'))
                    AND prfi.ci = radi.ci_erede
                  GROUP BY prfi.ci
                 HAVING NVL(SUM(prfi.ipn_ac),0) +
                        NVL(SUM(prfi.ipn_ap),0) != 0
                )
            ORDER BY pegi.dal
        ) LOOP
D_riga := D_riga + 1;
-- dbms_output.put_line('CI PREC: '||CUR_PREC.ci||' '||to_char(sysdate,'sssss'));
-- dbms_output.put_line('CF PREC: '||CUR_PREC.cf||' '||to_char(sysdate,'sssss'));
           BEGIN
            select CUR_PREC.cf
              into D_prec_cf
              from dual
             where translate(lpad(CUR_PREC.cf,11,'0'),'0123456789','0000000000') = '00000000000'
               and length(CUR_PREC.cf) = 11;
           EXCEPTION
        		WHEN NO_DATA_FOUND THEN
                    D_prec_cf := '';
                    D_riga := D_riga +1;
                    D_cod_errore   := 'P05710'; -- Codice Fiscale o Partita Iva Precedente rapporto non definito
                    D_precisazione := substr('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,200);
                    INSERT INTO a_segnalazioni_errore
                    (no_prenotazione,passo,progressivo,errore,precisazione)
                    VALUES (prenotazione,passo,D_riga,D_cod_errore, D_precisazione );
           END;
      BEGIN
          SELECT NVL(SUM(prfi.ipn_ac),0)
                   - nvl(SUM(prfi.ipn_ass),0)
                   - NVL(SUM(prfi.ipn_ter_ass),0)  ipn_ord
               , SUM(prfi.ipn_ass) + NVL(SUM(prfi.ipn_ter_ass),0) ipn_ass
               , GREATEST(0,NVL(SUM(prfi.ipt_pag),0))
               , NVL(SUM(prfi.add_irpef),0)
               , NVL(SUM(prfi.add_irpef_comunale),0)
            INTO D_ipn_ord_prec
               , D_ipn_ass_prec
               , D_ipt_pag_prec
               , D_add_irpef_prec
               , D_add_irpef_com_prec
            FROM progressivi_fiscali   prfi
           WHERE prfi.anno         = D_anno
             AND prfi.mese         = 12
             AND prfi.MENSILITA    = (SELECT MAX(MENSILITA)
                                        FROM MENSILITA
                                       WHERE mese = 12
                                         AND tipo IN ('A','N','S'))
             AND prfi.ci           = CUR_PREC.ci
          ;
          D_ipt_sosp_prec := D_somme_16;
          D_add_irpef_sosp_prec := D_somme_11;
          D_add_irpef_com_sosp_prec := D_somme_12;
          BEGIN
           select 'x'
             into D_dummy
             from dual
            where translate(CUR_PREC.causa_a,'0123456789','0000000000') = '0'
           ;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              d_dummy := null;
              D_riga := D_riga + 1;
              D_cod_errore   := 'P07302'; -- Dati di natura errata
              D_precisazione := substr('CI: '||TO_CHAR(CUR_CI.ci)||' Causa Conguaglio non codificata o non numerica',1,200);
-- dbms_output.put_line('SEER 3: '||D_riga||' '||to_char(sysdate,'sssss'));
              INSERT INTO a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
              VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione)
              ;
/* da rivedere per 770 */
          END;

          IF D_ipn_ord_prec != 0 THEN

             UPDATE DENUNCIA_FISCALE SET c102 = CUR_PREC.cf,
                                         c47 = CUR_PREC.ci,
                                         c48 = decode(d_dummy,'x',CUR_PREC.causa_a,null),
                                         c49 = 1,
                                         c50 = D_ipn_ord_prec,
                                         c51 = D_ipt_pag_prec,
                                         c52 = D_ipt_sosp_prec,
                                         c53 = D_add_irpef_prec,
                                         c54 = D_add_irpef_sosp_prec,
                                         c55 = D_add_irpef_com_prec,
                                         c56 = D_add_irpef_com_sosp_prec
                            WHERE ci =  CUR_CI.ci
                              AND anno = D_anno
                              AND rilevanza = 'D'
                              AND NVL(c48,0) + NVL(c49,0) + NVL(c50,0) +
                                  NVL(c51,0) + NVL(c52,0) + NVL(c53,0) +
                                  NVL(c54,0) + NVL(c55,0) + NVL(c56,0) = 0
                              AND ROWNUM = 1
             ;
-- dbms_output.put_line('CI PREC: '||CUR_PREC.ci||' forse ho fatto l''update'||' '||to_char(sysdate,'sssss'));
            IF SQL%ROWCOUNT = 0 THEN
               LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT;
-- dbms_output.put_line('Insert DEFI 4'||' '||to_char(sysdate,'sssss'));
               INSERT INTO
               DENUNCIA_FISCALE(anno,ci,rilevanza,
                                c102,c47,
                                c48,c49,
                                c50,c51,
                                c52,c53,
                                c54,c55,
                                c56,
                                utente,data_agg)
                         SELECT D_anno,CUR_CI.ci,'D',
                                CUR_PREC.cf,CUR_PREC.ci,
                                decode(d_dummy,'x',CUR_PREC.causa_a,null),
                                1,D_ipn_ord_prec,
                                D_ipt_pag_prec,D_ipt_sosp_prec,
                                D_add_irpef_prec,D_add_irpef_sosp_prec,
                                D_add_irpef_com_prec,D_add_irpef_com_sosp_prec,
                                D_utente, SYSDATE
                           FROM dual
               ;
-- dbms_output.put_line('CI PREC: '||CUR_PREC.ci||' ho sicuramente fatto l''insert'||' '||to_char(sysdate,'sssss'));
            END IF;
          END IF;
          IF D_ipn_ass_prec != 0 THEN
             UPDATE DENUNCIA_FISCALE SET c102 = CUR_PREC.cf,
                                         c47 = CUR_PREC.ci,
                                         c48 = decode(d_dummy,'x',CUR_PREC.causa_a,null),
                                         c49 = 2,
                                         c50 = D_ipn_ass_prec,
                                         c51 = D_ipt_pag_prec,
                                         c52 = D_ipt_sosp_prec,
                                         c53 = D_add_irpef_prec,
                                         c54 = D_add_irpef_sosp_prec,
                                         c55 = D_add_irpef_com_prec,
                                         c56 = D_add_irpef_com_sosp_prec
                            WHERE ci =  CUR_CI.ci
                              AND anno = D_anno
                              AND rilevanza = 'D'
                              AND NVL(c48,0) + NVL(c49,0) + NVL(c50,0) +
                                  NVL(c51,0) + NVL(c52,0) + NVL(c53,0) +
                                  NVL(c54,0) + NVL(c55,0) + NVL(c56,0) = 0
                              AND ROWNUM = 1
             ;
            IF SQL%ROWCOUNT = 0 THEN
               LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT;
-- dbms_output.put_line('Insert DEFI 5'||' '||to_char(sysdate,'sssss'));
               INSERT INTO
               DENUNCIA_FISCALE(anno,ci,rilevanza,
                                c102,c47,
                                c48,c49,
                                c50,c51,
                                c52,c53,
                                c54,c55,
                                c56,
                                utente,data_agg)
                         SELECT D_anno,CUR_CI.ci,'D',
                                CUR_PREC.cf,CUR_PREC.ci,
                                decode(d_dummy,'x',CUR_PREC.causa_a,null),
                                2,D_ipn_ass_prec,
                                D_ipt_pag_prec,D_ipt_sosp_prec,
                                D_add_irpef_prec,D_add_irpef_sosp_prec,
                                D_add_irpef_com_prec,D_add_irpef_com_sosp_prec,
                                D_utente, SYSDATE
                           FROM dual
               ;
            END IF;
          END IF;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_ipn_ord_prec := NULL;
           D_ipn_ass_prec := NULL;
           D_ipt_pag_prec := NULL;
           D_ipt_sosp_prec := NULL;
           D_add_irpef_prec := NULL;
           D_add_irpef_sosp_prec := NULL;
           D_add_irpef_com_prec := NULL;
           D_add_irpef_com_sosp_prec := NULL;
        END;
     END LOOP; -- cur_prec
      D_ipn_ord_prec := NULL;
      D_ipn_ass_prec := NULL;
      D_ipt_pag_prec := NULL;
      D_ipt_sosp_prec := NULL;
      D_add_irpef_prec := NULL;
      D_add_irpef_sosp_prec := NULL;
      D_add_irpef_com_prec := NULL;
      D_add_irpef_com_sosp_prec := NULL;
      BEGIN
         select codice_fiscale
           into d_cf_gestione
           from GESTIONI
          where codice = cur_ci.gestione
         ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              d_cf_gestione := '';
      END;
-- dbms_output.put_line('GESTIONE: '||cur_ci.gestione||' CF GESTIONE: '||d_cf_gestione);
      FOR CUR_TER IN
        (SELECT (SUBSTR(inex.ditta1,1,15))     cf
              , NVL(inex.ipn_1,0)
              - NVL(inex.ipn_ass_1,0) ipn_ord
              , NVL(inex.ipn_ass_1,0) ipn_ass
              , NVL(inex.ipt_1,0)     ipt_pag
              , NVL(inex.add_reg_1,0) add_irpef
              , NVL(inex.add_com_1,0) add_com
              , '5'                   causa_a
           FROM INFORMAZIONI_EXTRACONTABILI inex
          WHERE anno = D_anno
            AND ci   = CUR_CI.ci
            AND NVL(ipn_1,0) != 0
            AND SUBSTR(nvl(inex.ditta1,'x'),1,16) != nvl(D_cf_gestione,'y')
          UNION
         SELECT (SUBSTR(inex.ditta2,1,15))     cf
              , NVL(inex.ipn_2,0)
              - NVL(inex.ipn_ass_2,0) ipn_ord
              , NVL(inex.ipn_ass_2,0) ipn_ass
              , NVL(inex.ipt_2,0)     ipt_pag
              , NVL(inex.add_reg_2,0) add_irpef
              , NVL(inex.add_com_2,0) add_com
              , '5'                   causa_a
           FROM INFORMAZIONI_EXTRACONTABILI inex
          WHERE anno = D_anno
            AND ci   = CUR_CI.ci
            AND NVL(ipn_2,0) != 0
            AND SUBSTR(nvl(inex.ditta2,'x'),1,16) != nvl(D_cf_gestione,'y')
          UNION
         SELECT (SUBSTR(inex.ditta3,1,15))     cf
              , NVL(inex.ipn_3,0)
              - NVL(inex.ipn_ass_3,0) ipn_ord
              , NVL(inex.ipn_ass_3,0) ipn_ass
              , NVL(inex.ipt_3,0)     ipt_pag
              , NVL(inex.add_reg_3,0) add_irpef
              , NVL(inex.add_com_3,0) add_com
              , '5'                   causa_a
           FROM INFORMAZIONI_EXTRACONTABILI inex
          WHERE anno = D_anno
            AND ci   = CUR_CI.ci
            AND NVL(ipn_3,0) != 0
            AND SUBSTR(nvl(inex.ditta3,'x'),1,16) != nvl(D_cf_gestione,'y')
          ) LOOP
           BEGIN
            select CUR_TER.cf
              into D_ter_cf
              from dual
             where translate(lpad(CUR_TER.cf,11,'0'),'0123456789','0000000000') = '00000000000'
               and length(CUR_TER.cf) = 11;
           EXCEPTION
        		WHEN NO_DATA_FOUND THEN
                    D_ter_cf := '';
                    D_riga := D_riga +1;
                    D_cod_errore   := 'P05710'; -- Codice Fiscale o Partita Iva Precedente rapporto non definito
                    D_precisazione := SUBSTR('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,200);
-- dbms_output.put_line('SEER 4: '||D_riga||' '||to_char(sysdate,'sssss'));
                    INSERT INTO a_segnalazioni_errore 
                    (no_prenotazione,passo,progressivo,errore,precisazione)
                    VALUES (prenotazione,passo,D_riga, D_cod_errore, D_precisazione);
           END;
           IF CUR_TER.ipn_ord != 0 THEN
             UPDATE DENUNCIA_FISCALE SET c102 = D_ter_cf,
                                         c48 = CUR_TER.causa_a,
                                         c49 = 1,
                                         c50 = CUR_TER.ipn_ord,
                                         c51 = CUR_TER.ipt_pag,
                                         c52 = null,
                                         c53 = CUR_TER.add_irpef,
                                         c54 = null,
                                         c55 = CUR_TER.add_com,
                                         c56 = null
                            WHERE ci =  CUR_CI.ci
                              AND anno = D_anno
                              AND rilevanza = 'D'
                              AND NVL(c48,0) + NVL(c49,0) + NVL(c50,0) +
                                  NVL(c51,0) + NVL(c52,0) + NVL(c53,0) +
                                  NVL(c54,0) + NVL(c55,0) + NVL(c56,0) = 0
                              AND ROWNUM = 1
             ;
             IF SQL%ROWCOUNT = 0 THEN
                LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT;
-- dbms_output.put_line('Insert DEFI 6'||' '||to_char(sysdate,'sssss'));
                INSERT INTO
                DENUNCIA_FISCALE(anno,ci,rilevanza,
                                 c102,
                                 c48,c49,
                                 c50,c51,
                                 c52,c53,
                                 c54,c55,
                                 c56,
                                 utente,data_agg)
                          SELECT D_anno,CUR_CI.ci,'D',
                                 D_ter_cf,CUR_TER.causa_a,
                                 1,CUR_TER.ipn_ord,
                                 CUR_TER.ipt_pag,NULL,
                                 CUR_TER.add_irpef,NULL,
                                 CUR_TER.add_com,NULL,
                                 D_utente, SYSDATE
                            FROM dual
                ;
             END IF;
           END IF;
           IF CUR_TER.ipn_ass != 0 THEN
             UPDATE DENUNCIA_FISCALE SET c102 = CUR_TER.cf,
                                         c48 = CUR_TER.causa_a,
                                         c49 = 2,
                                         c50 = CUR_TER.ipn_ass,
                                         c51 = CUR_TER.ipt_pag,
                                         c52 = null,
                                         c53 = CUR_TER.add_irpef,
                                         c54 = null,
                                         c55 = CUR_TER.add_com,
                                         c56 = null
                            WHERE ci =  CUR_CI.ci
                              AND anno = D_anno
                              AND rilevanza = 'D'
                              AND NVL(c48,0) + NVL(c49,0) + NVL(c50,0) +
                                  NVL(c51,0) + NVL(c52,0) + NVL(c53,0) +
                                  NVL(c54,0) + NVL(c55,0) + NVL(c56,0) = 0
                              AND ROWNUM = 1
             ;
             IF SQL%ROWCOUNT = 0 THEN
                LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT;
-- dbms_output.put_line('Insert DEFI 7'||' '||to_char(sysdate,'sssss'));
                INSERT INTO
                DENUNCIA_FISCALE(anno,ci,rilevanza,
                                 c102,
                                 c48,c49,
                                 c50,c51,
                                 c52,c53,
                                 c54,c55,
                                 c56,
                                 utente,data_agg)
                          SELECT D_anno,CUR_CI.ci,'D',
                                 CUR_TER.cf,CUR_TER.causa_a,
                                 2,CUR_TER.ipn_ass,
                                 CUR_TER.ipt_pag,NULL,
                                 CUR_TER.add_irpef,NULL,
                                 CUR_TER.add_com,NULL,
                                 D_utente, SYSDATE
                            FROM dual
                ;
             END IF;
           END IF;
        END LOOP; --cur_ter
      BEGIN
        SELECT NVL(SUM(DECODE
                  ( voec.specifica
                  , 'IRPEF_1R', imp*(-1)
                  , 'IRPEF_RA1R', imp*(-1)
                  , 'IRP_RET_1R', imp*(-1)
                  , 0)),0)            m_irpef_1r
             , NVL(SUM(DECODE
                  ( voec.specifica
                  , 'IRPEF_2R', imp*(-1)
                  , 0)),0)               m_irpef_2r
         INTO M_irpef_1r,M_irpef_2r
         FROM MOVIMENTI_CONTABILI moco
            , VOCI_ECONOMICHE     voec
        WHERE moco.anno      = D_anno
          and moco.mensilita != '*AP'
          AND moco.ci        in (select CUR_CI.ci
                                   from dual
                                  union
                                 select ci_erede
                                   from RAPPORTI_DIVERSI radi
                                  where radi.ci = CUR_CI.ci
                                    and radi.rilevanza in ('L','R')
                                    and radi.anno = D_anno
                                )
          AND moco.voce      = voec.codice
          AND voec.specifica IN ('IRPEF_1R','IRPEF_2R',
                                 'IRPEF_RA1R','IRP_RET_1R')
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          M_irpef_1r := 0;
          M_irpef_2r := 0;
      END;
      BEGIN
        SELECT sum(decode(c49,1,nvl(c50,0),0))
             , sum(decode(c49,2,nvl(c50,0),0))
             , sum(nvl(c57,0)), sum(nvl(c58,0))
             , sum(nvl(c59,0)), sum(nvl(c60,0))
          INTO D_tot_ipn_ord
             , D_tot_ipn_ass
             , D_ipn_ap_d,D_ipn_aap_d
             , D_ipt_aap_d,D_ipt_sosp_d
          FROM DENUNCIA_FISCALE
         WHERE anno         = D_anno
           AND ci           = CUR_CI.ci
           AND rilevanza    = 'D'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          D_ipn_ap_d    := null;
          D_ipn_aap_d   := null;
          D_ipt_aap_d   := null;
          D_ipt_sosp_d   := null;
          D_tot_ipn_ord := null;
          D_tot_ipn_ass := null;
      END;
      BEGIN
        SELECT DECODE(maggiore_ritenuta,'X',1,NULL)
             , nvl(inex.ipn_ded,0)         ipn_ded
             , nvl(inex.ipn_ded_magg,0)    ipn_ded_magg
          INTO D_maggiore_ritenuta
             , D_ipn_ded
             , D_ipn_ded_magg
          FROM INFORMAZIONI_EXTRACONTABILI inex
         WHERE ci = CUR_CI.ci
           AND anno = D_anno
        ;
-- dbms_output.put_line('MR: '||D_maggiore_ritenuta||' '||to_char(sysdate,'sssss'));
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          D_maggiore_ritenuta := null;
          D_ipn_ded           := null;
          D_ipn_ded_magg      := null;
      END;

         IF nvl(D_ipn_ded_magg,0) != 0 THEN
            D_altri_redditi := nvl(D_ipn_ded_magg,0);
         ELSIF nvl(D_ipn_ded,0) != 0 THEN
            D_altri_redditi := nvl(D_ipn_ded,0) - nvl(D_ipn_ord,0) - nvl(D_ipn_ass,0);
         END IF;


      BEGIN
-- Estrazione previdenziale
        select round(NVL(SUM(DECODE(vaca.colonna,'PREV_04',
                                    valore,0)),0))
             , round(NVL(SUM(DECODE(vaca.colonna,'TFR_139',
                                    valore,0)),0))
          into D_contributi_inps
             , D_presenza_tfr
          from valori_contabili_annuali vaca
         where vaca.anno       = D_anno
           and vaca.mese       = 12
           and vaca.mensilita  = (select max(mensilita)
                                    from mensilita
                                   where mese = 12
                                     and tipo in ('A','N','S')
					   )
           and vaca.estrazione = 'DENUNCIA_CUD'
           and vaca.colonna    in ('PREV_04','TFR_139')
           and vaca.ci in (select CUR_CI.ci
                             from dual
                            union
                           SELECT radi.ci_erede
                             FROM RAPPORTI_DIVERSI radi
                            WHERE CUR_CI.ci = radi.ci
                              and radi.rilevanza = 'R'
                              and radi.anno = D_anno
                          )
           and vaca.moco_mensilita != '*AP'
        ;
      END;
      LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
      ;
-- dbms_output.put_line('Casella1: '||D_ipn_ord||' '||to_char(sysdate,'sssss'));
-- dbms_output.put_line('Insert DEFI 8'||' '||to_char(sysdate,'sssss'));
      INSERT INTO
        DENUNCIA_FISCALE(anno,ci,rilevanza,
                         c1,c2,c3,c4,c5,c6,c7,
                         c32,
                         c8,c9,c10,
                         c37,
                         c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,
                         c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
                         c31,c33,c34,c35,c36,c38,c39,c40,
                         c41,c42,c43,c44,c45,c46,c47,c48,c49,c50,
                         c51,c52,c53,c54,c55,c56,c57,c58,c59,c60,
                         c145,
                         c61,c62,c63,c64,c65,c66,c67,
                         c69,c70,c71,c72,c73,
                         c103,c104,
                         C139,c141,
                         utente,data_agg)
                  SELECT D_anno,CUR_CI.ci,'T',
                         D_ipn_ord,D_ipn_ass,                                   -- 02
                         decode(nvl(D_ipn_ord,0),0,null,D_gg_det_dd),           -- 03
                         decode(nvl(D_ipn_ord,0),0,null,D_gg_det_dp),           -- 04
                         D_ipt_pag,                                             -- 05
                         D_add_irpef,                                           -- 06
                         decode(sign( ( nvl(D_add_irpef_comu,0)-nvl( D_acconto_com_trat,0)))
                                    , +1, nvl(D_add_irpef_comu,0)-nvl( D_acconto_com_trat,0)
                                        , 0 ),                                  -- 07
                         D_acconto_com,                                         -- 32 ( 7 bis )
                         D_sosp_01,D_sosp_03,D_sosp_04,                         -- 10
                         D_acconto_com_sosp,                                    -- 37 ( 10 bis )
                         M_irpef_1r,M_irpef_2r,                                 -- 12
                         D_sosp_02,                                             -- 13
                         D_irpef_nr,D_add_reg_nr,                               -- 15
                         D_add_com_nr,                                          -- 16
                         DECODE(D_ded_non_appl,
                                1,TO_NUMBER(NULL),
                                  least ((nvl(D_ipn_ord,0) + nvl(D_ipn_ass,0)),
                                         (nvl(D_ded_base,0) + NVL(D_ded_agg,0)))
                               ),                                               -- 17
                         greatest( least (  (nvl(D_ipn_ord,0) + nvl(D_ipn_ass,0))
                                          - (nvl(D_ded_base,0) + NVL(D_ded_agg,0))
                                         , (nvl(D_ded_con,0) + NVL(D_ded_fig,0) + NVL(D_ded_alt,0))
                                         ), 0 ),                                -- 18
                         decode(D_flag_erede
                                , null, greatest( ( NVL(D_ipn_ord,0) + NVL(D_ipn_ass,0) )
                                                 - DECODE(D_ded_non_appl
                                                         , 1, 0
                                                            , (  nvl(D_ded_base,0) + NVL(D_ded_agg,0))
                                                         )
                                                 - ( nvl(D_ded_con,0) + NVL(D_ded_fig,0) + NVL(D_ded_alt,0) )
                                                 , 0
                                                 )
                                      , null ) ,                                -- 19
                         decode ( D_flag_erede
                                 , null, D_ipt_ac
                                       , null ),                                -- 20
                         D_det_ass + D_oneri_18,                                -- 21
                         TO_NUMBER(NULL),                                       -- 22
                         TO_NUMBER(NULL),                                       -- 23 
                         TO_NUMBER(NULL),                                       -- 24
                         TO_NUMBER(NULL),                                       -- 25
                         D_somme_01 + D_somme_02 +
                         D_somme_03 + D_somme_04 +
                         D_somme_05 + D_somme_06 +
                         D_somme_07 + D_somme_08,                               -- 26
                         D_oneri_01 + D_oneri_02 +
                         D_oneri_03 + D_oneri_04 +
                         D_oneri_05 + D_oneri_06 +
                         D_oneri_07 + D_oneri_08 +
                         D_oneri_09 + D_oneri_10 +
                         D_oneri_11 + D_oneri_12 +
                         D_oneri_13 + D_oneri_14 +
                         D_oneri_15 + D_oneri_16 +
                         D_oneri_17 + 
                         D_oneri_19 + D_oneri_20 +
                         D_oneri_21 + D_oneri_22 + 
                         D_oneri_23 + D_oneri_24 +
                         D_oneri_25 + D_oneri_26 +
                         D_oneri_27 + D_oneri_28 + D_oneri_29,                  -- 27
                         DECODE(CUR_CI.cat_fiscale
                               ,'2' ,'0'
                               ,'20','0'
                               ,'25','0'
                                    ,LEAST(5164.57,D_somme_10)),                -- 28
                         DECODE(SIGN(D_somme_10 - 5164.57),1,
                                     D_somme_10 - 5164.57,NULL),                -- 29
                         D_quota_tfr,                                           -- 30
                         TO_NUMBER(NULL),                                       -- 31
                         DECODE(CUR_CI.cat_fiscale
                               ,'2' ,'0'
                               ,'20','0'
                               ,'25','0'
                                    , D_somme_14),                              -- 33
                         DECODE(CUR_CI.cat_fiscale
                               ,'2' ,'0'
                               ,'20','0'
                               ,'25','0'
                                    , decode(nvl(D_somme_13,0)
                                            ,0,TO_NUMBER(NULL),1)),             -- 34
                         D_maggiore_ritenuta,D_ded_non_appl,                    -- 36
                         TO_NUMBER(NULL),                                       -- 38
                         TO_NUMBER(NULL),                                       -- 39
                         D_altri_redditi,                                       -- 40
                         TO_NUMBER(NULL),                                       -- 41
                         TO_NUMBER(NULL),                                       -- 42
                         D_irpef_trat,                                          -- 43
                         TO_NUMBER(NULL),                                       -- 44
                         D_tot_ipn_ord,D_tot_ipn_ass,                           -- 46
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 48
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 50
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 52
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 54
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 56
                         D_ipn_ap_d,D_ipn_aap_d,                                -- 58
                         D_ipt_aap_d,D_ipt_sosp_d,                              -- 60
                         decode(D_flag_erede
                                ,'X',decode( nvl(D_ipn_ap_d,0) + nvl(D_ipn_aap_d,0)
                                           + nvl(D_ipt_aap_d,0) + nvl(D_ipt_sosp_d,0)
                                           ,0,null,D_ap_succ)
                                    , null),                                    -- 145
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 62
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 64
                         TO_NUMBER(NULL),TO_NUMBER(NULL),                       -- 66
                         TO_NUMBER(NULL),                                       -- 67
                         T_lor_liq_ac +   T_riv_tfr + T_lor_liq_2000,           -- 69
                         T_lor_liq_ap + T_lor_liq_ap_2000,                      -- 70
                         T_ipt_liq,                                             -- 71
                         T_ipt_liq_ap,                                          -- 72
                         D_quota_erede,                                         -- 73
                         decode(D_prev_com,'9',null,D_prev_com),                -- 103
                         decode( ( nvl(D_sosp_01,0) + nvl(D_sosp_03,0) 
                                 + nvl(D_sosp_04,0) + nvl(D_acconto_com_sosp,0)
                                 + nvl(D_sosp_02,0) + nvl(D_ipt_sosp_d,0))
                               , 0, null, D_evento_eccezionale ),               -- 104
                         decode(D_presenza_tfr,0,null,D_presenza_tfr),          -- 139
                         decode( nvl(D_contributi_inps,0)
                                ,0, null
                                  ,'5'),                                       -- 141
                         D_utente, SYSDATE
                    FROM dual
      ;
      COMMIT;

       IF   ( nvl(D_sosp_01,0) + nvl(D_sosp_03,0) + nvl(D_sosp_04,0)
            + nvl(D_acconto_com_sosp,0) + nvl(D_sosp_02,0) + nvl(D_ipt_sosp_d,0) ) != 0
        and nvl(D_evento_eccezionale,5) not in ('1','3','4') THEN
         D_riga := D_riga +1;
         D_cod_errore   := 'P00505';  -- Valore non ammesso in questo contesto
         D_precisazione := SUBSTR('CI: '||TO_CHAR(CUR_CI.ci)||' per Casella 10 Eventi Eccezionali ( 1,3,4 ) : '||D_evento_eccezionale,1,200);
-- dbms_output.put_line('SEER 5: '||D_riga||' '||to_char(sysdate,'sssss'));
         INSERT INTO a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione );
      END IF;
      COMMIT;
-- dbms_output.put_line('CI - cas 57 : '||CUR_CI.ci||' new: '||D_ipn_ap_d||' prif: '||D_ipn_ap);
      IF abs( nvl(D_ipn_ap_d,0) - nvl(D_ipn_ap,0) ) > 1 then
         D_riga := D_riga +1;
         D_cod_errore   := 'P05770'; -- Compensi Anni Precedenti Incongruenti
         D_precisazione := SUBSTR('CI: '||TO_CHAR(CUR_CI.ci)||' Casella 57 diversa dal progr. fiscale',1,200);
-- dbms_output.put_line('SEER 5: '||D_riga||' '||to_char(sysdate,'sssss'));
         INSERT INTO a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione );
      END IF;
      COMMIT;
      IF abs( nvl(D_ipn_aap_d,0) - nvl(D_ipn_aap,0) ) > 1 then
         D_riga := D_riga +1;
         D_cod_errore   := 'P05770'; -- Compensi Anni Precedenti Incongruenti
         D_precisazione := SUBSTR('CI: '||TO_CHAR(CUR_CI.ci)||' Casella 58 diversa dal progr. fiscale',1,200);
-- dbms_output.put_line('SEER 6: '||D_riga||' '||to_char(sysdate,'sssss'));
         INSERT INTO a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione);
      END IF;
      COMMIT;
-- dbms_output.put_line('CI - cas 59 : '||CUR_CI.ci||' new: '||D_ipt_aap_d||' prif: '||D_ipt_ap);
      IF abs( nvl(D_ipt_aap_d,0) - nvl(D_ipt_ap,0) ) > 1 then
         D_riga := D_riga +1;
         D_cod_errore := 'P05770'; -- Compensi Anni Precedenti Incongruenti
         D_precisazione := SUBSTR('CI: '||TO_CHAR(CUR_CI.ci)||' Casella 59 diversa dal progr. fiscale',1,200);
-- dbms_output.put_line('SEER 7: '||D_riga||' '||to_char(sysdate,'sssss'));
         INSERT INTO a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione);
      END IF;
      COMMIT;
      IF nvl(D_ipt_sosp_d,0) != nvl(D_ipt_sosp_ap,0) then
         D_riga := D_riga +1;
         D_cod_errore   := 'P05770'; -- Compensi Anni Precedenti Incongruenti
         D_precisazione := SUBSTR('CI: '||TO_CHAR(CUR_CI.ci)||' Casella 60 diversa dal progr. fiscale',1,200);
-- dbms_output.put_line('SEER 8: '||D_riga||' '||to_char(sysdate,'sssss'));
         INSERT INTO a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione);
      END IF;
      COMMIT;
      begin
      pectrova.main(prenotazione,passo,CUR_CI.ci,d_anno,'<0');
      pectrova.main(prenotazione,passo,CUR_CI.ci,d_anno,'=0');
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
      commit;
      end;
   EXCEPTION
       WHEN OTHERS THEN
          D_errore := SUBSTR(SQLERRM,1,200);
          ROLLBACK;
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
            D_riga := D_riga +1;
            D_cod_errore   := 'P00109'; --  Errori in Elaborazione
            D_precisazione := substr('CI: '||TO_CHAR(CUR_CI.ci)||' '||D_errore,1,200);
-- dbms_output.put_line('SEER 9: '||D_riga||' '||to_char(sysdate,'sssss'));
            INSERT INTO a_segnalazioni_errore
            (no_prenotazione,passo,progressivo,errore,precisazione)
            VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione);
             COMMIT;
   END;
    END LOOP; -- cur_ci
   BEGIN
   <<PREC_ENTE>>
      FOR CUR_PREC_ENTE IN
        (  select  prfi.ci
                , nvl(sum(prfi.lor_acc),0)
                 + nvl(sum(prfi.lor_liq),0)            lor_liq_ac
                ,  nvl(sum(prfi.riv_tfr_ap_liq),0) 
                 + nvl(sum(prfi.riv_tfr_liq), 0)       riv_tfr
                , decode( nvl(sum(prfi.lor_acc),0) + nvl(sum(prfi.lor_acc_2000),0) + nvl(sum(prfi.lor_liq),0)
                         , 0, 0
                            , nvl(sum(prfi.ant_liq_ap),0) + nvl(sum(prfi.ant_acc_ap),0)
                         )                             lor_liq_ap
                , decode(nvl(sum(prfi.lor_acc),0) + nvl(sum(prfi.lor_acc_2000),0) + nvl(sum(prfi.lor_liq),0)
                        , 0, 0
                           , nvl(sum(prfi.ipt_liq),0) - nvl(sum(prfi.det_liq),0) - nvl(sum(prfi.dtp_liq),0)
                         )                             ipt_liq
                , decode( nvl(sum(prfi.lor_acc),0) + nvl(sum(prfi.lor_acc_2000),0) + nvl(sum(prfi.lor_liq),0)
                        , 0, 0
                           , nvl(sum(prfi.ipt_liq_ap),0)
                          )                            ipt_liq_ap
                , nvl(sum(prfi.lor_acc_2000),0)        lor_liq_2000
                , decode( nvl(sum(prfi.lor_acc_2000),0)
                        , 0, 0
                           , nvl(sum(prfi.ant_acc_2000),0)
                        )                              lor_liq_ap_2000
            from progressivi_fiscali   prfi
           where prfi.anno         = D_anno
             and prfi.mese         = 12
             and prfi.mensilita    =
                 (select max(mensilita)
                    from mensilita
                   where mese = 12
                     and tipo in ('A','N','S')
                  )
             and prfi.ci in ( select ci_erede
                                from rapporti_diversi radi
                               where anno = D_anno
                                 and rilevanza = 'R'
                            )
             and not exists ( select 'x'
                                  from denuncia_fiscale
                                 where ci = prfi.ci
                                   and anno = D_anno
                               )
          group by prfi.ci
          having nvl(sum(prfi.lor_acc),0) +
                 nvl(sum(prfi.lor_acc_2000),0) +
                 nvl(sum(prfi.lor_liq),0)  != 0
         ) LOOP

       IF CUR_PREC_ENTE.lor_liq_ac + CUR_PREC_ENTE.riv_tfr + CUR_PREC_ENTE.lor_liq_ap 
        + CUR_PREC_ENTE.ipt_liq + CUR_PREC_ENTE.ipt_liq_ap != 0 THEN
         LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
         ;
         INSERT INTO DENUNCIA_FISCALE 
              ( anno,ci,rilevanza
              , c69
              , c70
              , c71
              , c72
              , utente, data_agg )
         SELECT D_anno,CUR_PREC_ENTE.ci,'D'
              , decode( CUR_PREC_ENTE.lor_liq_ac +  CUR_PREC_ENTE.riv_tfr
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.lor_liq_ac +  CUR_PREC_ENTE.riv_tfr )
              , decode( CUR_PREC_ENTE.lor_liq_ap
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.lor_liq_ap )
              , decode( CUR_PREC_ENTE.ipt_liq
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.ipt_liq )
              , decode( CUR_PREC_ENTE.ipt_liq_ap
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.ipt_liq_ap )
              , D_utente, SYSDATE
           FROM dual
         ;
       END IF;
       IF CUR_PREC_ENTE.lor_liq_2000 + CUR_PREC_ENTE.lor_liq_ap_2000 != 0 THEN
         LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
         ;
         INSERT INTO DENUNCIA_FISCALE 
              ( anno,ci,rilevanza
              , c69
              , c70
              , c71
              , c72
              , utente, data_agg )
         SELECT D_anno,CUR_PREC_ENTE.ci,'D'
              , decode( CUR_PREC_ENTE.lor_liq_2000
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.lor_liq_2000 )
              , decode( CUR_PREC_ENTE.lor_liq_ap_2000
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.lor_liq_ap_2000 )
              , NULL
              , NULL
              , D_utente,SYSDATE
           FROM dual
         ;
       END IF;
         LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT
         ;
         INSERT INTO DENUNCIA_FISCALE 
              ( anno,ci,rilevanza
              , c69
              , c70
              , c71
              , c72
              , utente, data_agg )
         SELECT D_anno,CUR_PREC_ENTE.ci,'T'
              , decode( CUR_PREC_ENTE.lor_liq_ac +  CUR_PREC_ENTE.riv_tfr + CUR_PREC_ENTE.lor_liq_2000
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.lor_liq_ac +  CUR_PREC_ENTE.riv_tfr + CUR_PREC_ENTE.lor_liq_2000 )
              , decode( CUR_PREC_ENTE.lor_liq_ap + CUR_PREC_ENTE.lor_liq_ap_2000
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.lor_liq_ap + CUR_PREC_ENTE.lor_liq_ap_2000 )
              , decode( CUR_PREC_ENTE.ipt_liq
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.ipt_liq )
              , decode( CUR_PREC_ENTE.ipt_liq_ap
                      , 0 , to_number(null)
                          , CUR_PREC_ENTE.ipt_liq_ap )
              , D_utente,SYSDATE
           from dual;
      commit;
     END LOOP; -- CUR_PREC_ENTE
   END PREC_ENTE;

/* segnalazione per dati in denuncia_caaf ma non archiviati in denuncia_fiscale */
   BEGIN
      FOR CUR in 
      ( SELECT distinct ci
          FROM DENUNCIA_CAAF deca
         WHERE deca.anno      = D_anno - 1
           AND ( NVL(deca.irpef_cr,0) != 0
             or  NVL(deca.add_reg_dic_cr,0) != 0
             or  NVL(deca.add_reg_con_cr,0) != 0
             or  NVL(deca.add_com_dic_cr,0) != 0
             or  NVL(deca.add_com_con_cr,0) != 0
               )
           and not exists ( select 'x' 
                              from periodi_retributivi
                             where ci = deca.ci
                               and periodo between TO_DATE(D_ini_a,'ddmmyyyy')
                                               AND TO_DATE(D_fin_a,'ddmmyyyy')
                               AND competenza    = 'A' 
                          )
            and (  D_tipo = 'T'
              or ( D_tipo = 'S' AND deca.ci = D_ci )
                )
       order by ci
       ) LOOP
       BEGIN
            D_riga := D_riga +1;
            D_errore := 'Manca Periodo Elaborato';
            D_cod_errore   := 'P05008'; -- Dati non Archiviati
            D_precisazione := substr('CI: '||TO_CHAR(CUR.ci)||' '||D_errore,1,200);
            INSERT INTO a_segnalazioni_errore
            ( no_prenotazione,passo,progressivo,errore,precisazione)
            VALUES (prenotazione,passo,D_riga,D_cod_errore,D_precisazione);
            COMMIT;
       END;
     END LOOP; -- cur
    END;
   EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = P_errore
       where no_prenotazione = prenotazione;
      commit;
   END;
COMMIT;
END;
END;
/
