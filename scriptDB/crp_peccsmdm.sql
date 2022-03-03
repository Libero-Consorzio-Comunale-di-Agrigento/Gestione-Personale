CREATE OR REPLACE PACKAGE PECCSMDM IS
/******************************************************************************
 NOME:          PECCSMDM
 DESCRIZIONE:   Creazione del flusso per la Denuncia Mensile INPS DM10 e DM10/S.
                Questa fase produce un file secondo i tracciati imposti dalla Direzione
                dell' INPS.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:   La gestione che deve risultare come intestataria della denuncia
                deve essere stata inserita in << DGEST >> in modo tale che la
                ragione sociale (campo nome) risulti essere la minore di tutte
                le altre eventualmente inserite.
                Lo stesso risultato si raggiunge anche inserendo un BLANK prima
                del nome di tutte le gestioni che devono essere escluse.
               Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
               da elaborare.
               Il PARAMETRO D_mensilita indica la mensilita` di riferimento della
               denuncia da elaborare.
               Il PARAMETRO D_consulente indica quale gestione deve risultare come
               C.E.D. che ha elaborato il supporto.
               Il PARAMETRO D_pos_inps indica quale posizione INPS deve essere ela-
               rata (% = tutte).
               Il PARAMETRO D_prog_den indica il progressivo di presentazione del
               supporto.
               Il PARAMETRO D_tipo_pag indica la modalita` di pagamento.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    03/11/2003
 1.1  17/10/2006 MS     Modificata lettura dell'IPN_FAM ( A17262 )
 1.2  19/04/2007 ML     Modifiche al tracciato (A20635).
 1.3  21/05/2007 ML     Sistemazione progressivo record (A20635.0.1)
 1.4  28/05/2007 MS     Lettura dei dati per gestioni alternative (A20885.3)
 1.5  31/05/2007 MS     Lettura dei dati per gestioni alternative (A20885.3)
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCSMDM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.5 del 31/05/2007';
END VERSIONE;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
DECLARE
--
--  Variabili di Ordinamento
--
  D_dep_prog            NUMBER := 2;
  D_prog_rec            NUMBER := 1;
  D_prog_rec_a          NUMBER := 0;
  D_prog_ass            NUMBER := 1;
  D_conta_rec_az        NUMBER := 0;
--
--  Variabili di Estrazione
--
  D_anno                NUMBER;
  D_mese                NUMBER;
  D_da_mensilita        VARCHAR2(4);
  D_a_mensilita         VARCHAR2(4);
  D_fine_mese           DATE;
  D_data_esecutivita    DATE;
  D_pos_inps            VARCHAR2(12);
  D_da_pagare           NUMBER;
--
--  Variabili di Consulente/Azienda
--
  D_consulente   VARCHAR2(4);
  D_cons_nome    VARCHAR2(30);
  D_nr_az        NUMBER := 0;
  D_tot_az_a     NUMBER := 0;
  D_tot_az_b     NUMBER := 0;
  D_tot_az       NUMBER := 0;
  D_cons_cf      VARCHAR2(16);
  D_cons_ca      VARCHAR2(16);
  D_cons_inps    VARCHAR2(10);
  D_occupati     NUMBER;
  D_occupati_td  NUMBER;
  D_num_m        NUMBER;
  D_imp_m        NUMBER;
  D_num_f        NUMBER;
  D_imp_f        NUMBER;
  D_sca_max      NUMBER := 0;
  D_sca_prec     NUMBER := 0;
  D_nucleo_2     NUMBER;
  D_nucleo_3     NUMBER;
  D_nucleo_4     NUMBER;
  D_nucleo_5     NUMBER;
  D_nucleo_6     NUMBER;
  D_nucleo_n     NUMBER;
  D_nucleo_t2    NUMBER := 0;
  D_nucleo_t3    NUMBER := 0;
  D_nucleo_t4    NUMBER := 0;
  D_nucleo_t5    NUMBER := 0;
  D_nucleo_t6    NUMBER := 0;
  D_nucleo_tn    NUMBER := 0;
--
--  Variabili di Consulente/Azienda
--
  D_imponibile   NUMBER := 0;
  D_contributo   NUMBER := 0;
--
--  Definizione Exception
--
  NO_DM10S  EXCEPTION;
  NO_DM10   EXCEPTION;
  USCITA    EXCEPTION;
BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
BEGIN
  BEGIN
    SELECT SUBSTR(valore,1,4)
      INTO D_anno
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            SELECT anno
              INTO D_anno
              FROM RIFERIMENTO_RETRIBUZIONE
             WHERE rire_id = 'RIRE';
  END;
  BEGIN
    SELECT SUBSTR(valore,1,4)
      INTO D_mese
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_MESE'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            SELECT mese
              INTO D_mese
              FROM RIFERIMENTO_RETRIBUZIONE
             WHERE rire_id = 'RIRE';
  END;
  BEGIN
    SELECT LAST_DAY(TO_DATE(LPAD(TO_CHAR(D_mese),2,'0')
                                 ||TO_CHAR(D_anno),'mmyyyy'))
      INTO D_fine_mese
      FROM dual
    ;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,4)
      INTO D_da_mensilita
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_DA_MENSILITA'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            SELECT MENSILITA
              INTO D_da_mensilita
              FROM RIFERIMENTO_RETRIBUZIONE
             WHERE rire_id = 'RIRE';
  END;
  BEGIN
    SELECT SUBSTR(valore,1,4)
      INTO D_a_mensilita
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_A_MENSILITA'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            SELECT MENSILITA
              INTO D_a_mensilita
              FROM RIFERIMENTO_RETRIBUZIONE
             WHERE rire_id = 'RIRE';
  END;
  BEGIN
    SELECT TO_DATE(valore,'dd/mm/yyyy')
      INTO D_data_esecutivita
      FROM A_PARAMETRI
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_DATA_ESECUTIVITA'
    ;
     EXCEPTION
    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
      D_data_esecutivita := null;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,4)
      INTO D_consulente
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CONSULENTE'
       AND EXISTS
          (SELECT 'x' FROM GESTIONI
            WHERE codice = RTRIM(SUBSTR(valore,1,4))
          )
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            -- Gestione Consulente non prevista
               UPDATE a_prenotazioni SET errore = 'P01201'
                                       , prossimo_passo = 99
                WHERE no_prenotazione = prenotazione
               ;
            COMMIT;
            RAISE USCITA;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,12)
      INTO D_pos_inps
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_POS_INPS'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_pos_inps := '%';
  END;
  BEGIN
    SELECT SUBSTR(valore,1,12)
      INTO D_da_pagare
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_DA_PAGARE'
    ;
    IF D_pos_inps = '%' THEN
       UPDATE a_prenotazioni
          SET errore          = 'P01202'
            , prossimo_passo  = 99
        WHERE no_prenotazione = prenotazione;
       COMMIT;
       RAISE USCITA;
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           D_da_pagare := '';
  END;
END;
  BEGIN
    D_nr_az    := 0;
    D_tot_az   := 0;
    D_tot_az_a := 0;
    D_tot_az_b := 0;
    --
    --  Estrazione Dati CONSULENTE / AZIENDA
    --
    BEGIN
      SELECT RPAD(gest.nome,30,' ')
           , NVL(gest.codice_fiscale,NVL(gest.partita_iva,' '))
           , NVL(gest.aut_dm10,' ')
           , RPAD(gest.posizione_inps,10,' ')
        INTO D_cons_nome
           , D_cons_cf
           , D_cons_ca
           , D_cons_inps
        FROM GESTIONI gest
       WHERE gest.codice        = D_consulente
      ;
    END;
         --
         --  Loop per inserimento records AZIENDALI
         --
    FOR CUR_AZ IN
       (SELECT NVL(gest.nome,' ')                               gest_nome
             , NVL(gest.aut_dm10,' ')                           gest_ca
             , NVL(gest.csc_dm10,' ')                           gest_csc
             , LPAD(TO_CHAR(NVL(gest.zona_sede_inps,0)),2,'0')  gest_zona
             , RPAD(NVL( gest.codice_fiscale
                       , NVL(gest.partita_iva,' ')),16,' ')     gest_cf
             , gest.posizione_inps                              gest_inps
             , gest.codice                                      gest_codice
          FROM GESTIONI gest
         WHERE gest.codice IN
              (SELECT SUBSTR(MIN(RPAD(nome,40)||codice),41,4)
                 FROM GESTIONI
                WHERE SUBSTR(nome,1,1) !=   ' '
                  AND posizione_inps   LIKE D_pos_inps
                GROUP BY posizione_inps
              )
       ) LOOP
-- dbms_output.put_line('passaggio 1 '||D_prog_rec);
-- dbms_output.put_line('codice della gestione: '||CUR_AZ.gest_codice);
         D_prog_rec     := D_dep_prog+1;
         D_prog_rec_a   := D_prog_rec;
         D_tot_az_a     := 0;
         D_tot_az_b     := 0;
         D_occupati     := 0;
         D_occupati_td  := 0;
         D_conta_rec_az := 0;
         BEGIN  -- estrazione dati DM10/S
              FOR CUR_DM10 IN
                 (SELECT esco.quadro                                   quadro
                       , MAX(esco.arrotondamento)                      tipo_arr
                       , COUNT(DISTINCT(LPAD(TO_CHAR(moco.mese),2,'0')||
                                             TO_CHAR(moco.ci)))        num_ci
                       , COUNT(distinct(TO_CHAR(moco.ci)))             occupati
                       , count(DISTINCT(decode(posi.tempo_determinato
                                              ,'SI',TO_CHAR(moco.ci)
                                                   ,0)))
                               -decode(min(posi.tempo_determinato),'NO',1,0)
                                                                       occupati_td
                       , ROUND(SUM(
                         DECODE( esco.giorni
                               , 'O',NVL(moco.qta,0)*NVL(moco.ore,1)/6
                               , 'Q',NVL(moco.qta,0)
                               , 'I',DECODE
                                     ( DECODE(voec.classe
                                             ,'I','R',voec.classe)
                                     , 'R',DECODE
                                           (esco.tipo
                                           ,'C',NVL(moco.imp,0)
                                                -NVL(moco.ipn_p,0)
                                           ,'P',DECODE
                                               (TO_CHAR(moco.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno),NVL(moco.ipn_p,0)
                                                              , NVL(moco.imp,0)
                                               )
                                               ,NVL(moco.imp,0)
                                           )
                                         ,NVL(moco.imp,0)
	                             )
                                    ,NULL
                               )
                            ))                                         giorni
                       , SUM(
                         DECODE( voec.classe
                               , 'R',DECODE
                                     ( esco.tipo
                                     , 'C',NVL(moco.tar,0)-NVL(moco.ipn_eap,0)
                                     , 'P', DECODE
                                            ( TO_CHAR(moco.riferimento,'yyyy')
                                            , TO_CHAR(D_anno),NVL(moco.ipn_eap,0)
                                                            ,NVL(moco.tar,0)
                                            )
                                          , NVL(moco.tar,0)
                                     )
                               , 'I',DECODE
                                     ( esco.tipo
                                     , 'C',NVL(moco.imp,0)-NVL(moco.ipn_p,0)
                                     , 'P',DECODE
                                           ( TO_CHAR(moco.riferimento,'yyyy')
                                           , TO_CHAR(D_anno), NVL(moco.ipn_p,0)
                                                           , NVL(moco.imp,0)
                                           )
                                          ,NVL(moco.imp,0)
                                     )
                                    ,NVL(moco.tar,0)
	                       ) *DECODE(esco.imponibile,'NO',0,1)
                         )                                          imponibile
                       , SUM(
                         DECODE( DECODE(voec.classe,'I','R',voec.classe)
                               , 'R',DECODE
                                     ( esco.tipo
                                     , 'C',NVL(moco.imp,0)-NVL(moco.ipn_p,0)
                                     , 'P',DECODE
                                           ( TO_CHAR(moco.riferimento,'yyyy')
                                           , TO_CHAR(D_anno), NVL(moco.ipn_p,0)
                                                           , NVL(moco.imp,0)
                                           )
                                          ,NVL(moco.imp,0)
                                     )
                                    ,NVL(moco.imp,0)
                  	       ) *DECODE(voec.tipo,'T',-1,1)
                                 *DECODE(esco.contributo,'NO',0,1)
                         )                                        contributo
                       , DECODE
                         ( GREATEST(100,esco.sequenza)
                                       , 100, RPAD(lpad(esco.codice,4,'*'),4,' ')
                                            , RPAD(esco.codice,4,'0'))           codice
                    FROM ESTRAZIONE_CONTRIBUTI esco
                       , MOVIMENTI_CONTABILI   moco
                       , RITENUTE_VOCE         rivo
                       , VOCI_ECONOMICHE       voec
                       , posizioni             posi
                       , periodi_retributivi   pere
                   WHERE esco.quadro   IN ('C','D')
                     AND moco.ci IN
                                 (SELECT ci
                                    FROM PERIODI_RETRIBUTIVI pere
                                       , def_gestione_denunce dged
                                   WHERE pere.periodo  = D_fine_mese
                                     AND pere.competenza = 'A'
                                     and dged.posizione (+) = pere.posizione
                                     and dged.contratto (+) = pere.contratto
                                     AND nvl(dged.gestione, pere.gestione)  IN ( SELECT codice 
                                                                                   FROM GESTIONI
                                                                                  WHERE posizione_inps = CUR_AZ.gest_inps
                                                                               )
                                 )
                     and moco.ci         = pere.ci
                     and pere.competenza = 'A'
                     and pere.periodo    = D_fine_mese
                     and pere.posizione  = posi.codice (+)
                     AND moco.voce       = esco.voce
                     AND moco.sub        = esco.sub
                     AND voec.codice     = moco.voce
                     AND moco.anno       = D_anno
                     AND moco.mese       = D_mese
                     AND moco.MENSILITA BETWEEN D_da_mensilita
                                            AND D_a_mensilita
                     AND rivo.voce (+)  = moco.voce
                     AND rivo.sub  (+)  = moco.sub
                     AND moco.riferimento
                         BETWEEN NVL(rivo.dal,TO_DATE('2222222','j'))
                             AND NVL(rivo.al,TO_DATE('3333333','j'))
                     AND EXISTS
                        (SELECT 'x' FROM MOVIMENTI_CONTABILI   m
                                       , ESTRAZIONE_CONTRIBUTI ec
                                       , VOCI_ECONOMICHE       voec2
                          WHERE m.ci        (+)  = moco.ci
                            AND m.anno      (+)  = moco.anno
                            AND m.mese      (+)  = moco.mese
                            AND m.MENSILITA (+)  = moco.MENSILITA
                            AND esco.ROWID       = ec.ROWID
                            AND m.voce      (+)  = ec.con_voce
                            AND m.sub       (+)  = ec.con_sub
                            AND voec2.codice     = ec.con_voce
                            AND ((   DECODE
                                     ( voec2.classe
                                     ,'R',DECODE
                                          (ec.tipo
                                          ,'C',NVL(m.tar,0)-NVL(m.ipn_eap,0)
                                          ,'P',DECODE
                                               (TO_CHAR(m.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno),NVL(m.ipn_eap,0)
                                                               , NVL(m.tar,0)
                                               )
                                              ,NVL(m.tar,0)
                                          )
                                     ,'I',DECODE
                                          (ec.tipo
                                          ,'C',NVL(m.imp,0)-NVL(m.ipn_p,0)
                                          ,'P',DECODE
                                               (TO_CHAR(m.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno),NVL(m.ipn_p,0)
                                                               ,NVL(m.imp,0)
                                               )
                                          ,NVL(m.imp,0)
                                          )
                                         ,NVL(m.tar,0)
	                             ) != 0
                                  OR DECODE
                                     (DECODE(voec2.classe,'I','R',voec2.classe)
                                     ,'R',DECODE
                                          (ec.tipo
                                          ,'C',NVL(m.imp,0)-NVL(m.ipn_p,0)
                                          ,'P',DECODE
                                               (TO_CHAR(m.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno), NVL(m.ipn_p,0)
                                                               , NVL(m.imp,0)
                                               )
                                              ,NVL(m.imp,0)
                                          )
                                         ,NVL(m.imp,0)
	                             ) != 0)  AND NVL(ec.tipo,' ')   != '0'
                         	 OR ec.tipo = '0' AND NVL(m.imp,0)    = 0
                                 )
                                )
                            AND (          esco.tipo          IS NULL
                                 OR        esco.tipo           = '0'
                                 OR        esco.tipo           = '>'
                                 OR        esco.tipo           = '<'
                                 OR        esco.tipo           = 'A'       AND
                                           moco.arr           IS NOT NULL  AND
                                    DECODE(voec.tipo,'T',-1,1) = SIGN(moco.imp)
                                 OR        esco.tipo          IN ('C','P') AND
                                       NVL(moco.arr,' ')       =
                                       DECODE
                                       (esco.tipo
                                       ,'C',DECODE
                                            (TO_CHAR(moco.riferimento,'yyyy')
                                            ,TO_CHAR(D_anno),NVL(moco.arr,' ')
                                                            ,NULL
                                            )
                                       ,'P',DECODE
                                            (TO_CHAR(moco.riferimento,'yyyy')
                                            ,TO_CHAR(D_anno),DECODE
                                                             (NVL(moco.ipn_p,0)
                                                             ,0,NULL
                                                              ,NVL(moco.arr,' ')
                                                             )
                                                            , NVL(moco.arr,' ')
                                            )
                                       )
                                 OR        esco.tipo           = 'M'       AND
                                           moco.arr           IS NULL
                                 OR DECODE(esco.tipo,'U','M','D','F') =
                                          (SELECT sesso FROM ANAGRAFICI
                                            WHERE al IS NULL
                                              AND ni =
                                                 (SELECT ni
                                                    FROM RAPPORTI_INDIVIDUALI
                                                   WHERE ci = moco.ci))
                                 OR DECODE(esco.tipo
                                          ,'1',1,'2',2,'3',3,'4',4,'5',5
                                          ,'6',6,'7',7,'8',8,'9',9,0) =
                                   (SELECT MAX(qua_inps)
                                      FROM QUALIFICHE
                                     WHERE numero =
                                          (SELECT TO_NUMBER
                                                  (SUBSTR
                                                   (MAX(DECODE(pere.servizio
                                                              ,'Q','1','I','2','0')
                                                        ||TO_CHAR(pere.qualifica)),2,6))
                                             FROM PERIODI_RETRIBUTIVI pere
                                            WHERE pere.ci        = moco.ci
                                              AND pere.servizio IN ('Q','I')
                                              AND moco.riferimento
                                                  BETWEEN pere.dal AND pere.al
                                              AND pere.periodo   = D_fine_mese
                            AND (    moco.input       = UPPER(moco.input)
                                 AND pere.competenza IN ('D','C','A')
                                  OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('P','D')
                                  OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('C','A')
                                 AND NOT EXISTS
                                    (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                                      WHERE periodo          = pere.periodo
                                        AND ci               = pere.ci
                                        AND competenza       = 'P'
                                        AND moco.riferimento BETWEEN dal AND al)
                               )
                        )
                       )
        OR DECODE(esco.tipo,'X',1,'Y',2,'Z',3) =
          (SELECT MAX(DECODE(qua_inps,9,2,qua_inps))
             FROM QUALIFICHE
            WHERE ('SI','NO',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND pere.servizio IN ('Q','I')
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN pere.dal AND pere.al
               AND pere.periodo  = D_fine_mese
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
           )
          )
        OR DECODE(esco.tipo,'x',1,'y',2) =
          (SELECT MAX(DECODE(qua_inps,9,2,qua_inps))
             FROM QUALIFICHE
            WHERE ('SI','SI',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND pere.servizio IN ('Q','I')
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN dal AND al
               AND pere.periodo  = D_fine_mese
           )
          )
        OR DECODE(esco.tipo,'o',1,'i',2) =
          (SELECT MAX(DECODE(qua_inps,9,2,qua_inps))
             FROM QUALIFICHE
            WHERE ('NO','SI',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
               AND pere.servizio IN ('Q','I')
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN dal AND al
               AND pere.periodo  = D_fine_mese
           )
          )
        OR DECODE(esco.tipo,'O',1,'I',2,'G',3) =
	  (SELECT MAX(DECODE(qua_inps,9,2,qua_inps)) FROM QUALIFICHE
            WHERE ('NO','NO',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
               AND pere.servizio IN ('Q','I')
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN dal AND al
               AND pere.periodo  = D_fine_mese
           )
      )
        OR DECODE(esco.tipo,'R','SI','N','NO') =
                 (SELECT posi.ruolo FROM POSIZIONI posi
                   WHERE posi.codice =
                        (SELECT pere.posizione
                           FROM PERIODI_RETRIBUTIVI pere
                          WHERE pere.ci     = moco.ci
                            AND (    moco.input       = UPPER(moco.input)
                                 AND pere.competenza IN ('D','C','A')
                                 OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('P','D')
                                 OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('C','A')
                                 AND NOT EXISTS
                                    (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                                      WHERE periodo          = pere.periodo
                                        AND ci               = pere.ci
                                        AND competenza       = 'P'
                                        AND moco.riferimento BETWEEN dal AND al)
                               )
                            AND pere.servizio = 'Q'
                            AND moco.riferimento BETWEEN dal AND al
                            AND pere.periodo  = D_fine_mese
                         )
                 )
	OR esco.tipo = '+' AND SIGN(moco.imp) =  1
	OR esco.tipo = '-' AND SIGN(moco.imp) = -1
       )
GROUP BY esco.quadro,esco.sequenza,esco.codice
      UNION
                  SELECT esco.quadro                                   quadro
                       , MAX(esco.arrotondamento)                      tipo_arr
                       , COUNT(DISTINCT(LPAD(TO_CHAR(moco.mese),2,'0')||
                                             TO_CHAR(moco.ci)))        num_ci
                       , COUNT(distinct(TO_CHAR(moco.ci)))             occupati
                       , count(DISTINCT(decode(posi.tempo_determinato
                                              ,'SI',TO_CHAR(moco.ci)
                                                   ,0)))
                               -decode(min(posi.tempo_determinato),'NO',1,0)
                                                                       occupati_td
                       , ROUND(SUM(
                         DECODE( esco.giorni
                               , 'O',NVL(moco.qta,0)*NVL(moco.ore,1)/6
                               , 'Q',NVL(moco.qta,0)
                               , 'I',DECODE
                                     ( DECODE(voec.classe
                                             ,'I','R',voec.classe)
                                     , 'R',DECODE
                                           (esco.tipo
                                           ,'C',NVL(moco.imp,0)
                                                -NVL(moco.ipn_p,0)
                                           ,'P',DECODE
                                               (TO_CHAR(moco.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno),NVL(moco.ipn_p,0)
                                                              , NVL(moco.imp,0)
                                               )
                                               ,NVL(moco.imp,0)
                                           )
                                         ,NVL(moco.imp,0)
	                             )
                                    ,NULL
                               )
                            ))                                         giorni
                       , SUM(
                         DECODE( voec.classe
                               , 'R',DECODE
                                     ( esco.tipo
                                     , 'C',NVL(moco.tar,0)-NVL(moco.ipn_eap,0)
                                     , 'P', DECODE
                                            ( TO_CHAR(moco.riferimento,'yyyy')
                                            , TO_CHAR(D_anno),NVL(moco.ipn_eap,0)
                                                            ,NVL(moco.tar,0)
                                            )
                                          , NVL(moco.tar,0)
                                     )
                               , 'I',DECODE
                                     ( esco.tipo
                                     , 'C',NVL(moco.imp,0)-NVL(moco.ipn_p,0)
                                     , 'P',DECODE
                                           ( TO_CHAR(moco.riferimento,'yyyy')
                                           , TO_CHAR(D_anno), NVL(moco.ipn_p,0)
                                                           , NVL(moco.imp,0)
                                           )
                                          ,NVL(moco.imp,0)
                                     )
                                    ,NVL(moco.tar,0)
	                       ) *DECODE(esco.imponibile,'NO',0,1)
                         )                                          imponibile
                       , SUM(
                         DECODE( DECODE(voec.classe,'I','R',voec.classe)
                               , 'R',DECODE
                                     ( esco.tipo
                                     , 'C',NVL(moco.imp,0)-NVL(moco.ipn_p,0)
                                     , 'P',DECODE
                                           ( TO_CHAR(moco.riferimento,'yyyy')
                                           , TO_CHAR(D_anno), NVL(moco.ipn_p,0)
                                                           , NVL(moco.imp,0)
                                           )
                                          ,NVL(moco.imp,0)
                                     )
                                    ,NVL(moco.imp,0)
                  	       ) *DECODE(voec.tipo,'T',-1,1)
                                 *DECODE(esco.contributo,'NO',0,1)
                         )                                        contributo
                       , RPAD('A',4,'0')                          codice
                    FROM ESTRAZIONE_CONTRIBUTI esco
                       , MOVIMENTI_CONTABILI   moco
                       , RITENUTE_VOCE         rivo
                       , VOCI_ECONOMICHE       voec
                       , posizioni             posi
                       , periodi_retributivi   pere
                   WHERE D_mese         = 1
                     AND esco.quadro   IN ('C','D')
                     AND esco.codice   IN (' 165',' 265')
                     AND moco.ci IN
                                 (SELECT ci
                                    FROM PERIODI_RETRIBUTIVI pere
                                       , def_gestione_denunce dged
                                   WHERE pere.periodo  = D_fine_mese
                                     AND pere.competenza = 'A'
                                     and dged.posizione (+) = pere.posizione
                                     and dged.contratto (+) = pere.contratto
                                     AND nvl(dged.gestione, pere.gestione)  IN ( SELECT codice 
                                                                                   FROM GESTIONI
                                                                                  WHERE posizione_inps = CUR_AZ.gest_inps
                                                                               )
                                 )
                     and moco.ci         = pere.ci
                     and pere.competenza = 'A'
                     and pere.periodo    = D_fine_mese
                     and pere.posizione  = posi.codice (+)
                     AND moco.voce      = esco.voce
                     AND moco.sub       = esco.sub
                     AND voec.codice    = moco.voce
                     AND moco.anno      = D_anno
                     AND moco.mese      = D_mese
                     AND moco.MENSILITA BETWEEN D_da_mensilita
                                            AND D_a_mensilita
                     AND TO_CHAR(moco.riferimento,'yyyy') = D_anno - 1
                     AND rivo.voce (+)  = moco.voce
                     AND rivo.sub  (+)  = moco.sub
                     AND moco.riferimento
                         BETWEEN NVL(rivo.dal,TO_DATE('2222222','j'))
                             AND NVL(rivo.al,TO_DATE('3333333','j'))
                     AND EXISTS
                        (SELECT 'x' FROM MOVIMENTI_CONTABILI   m
                                       , ESTRAZIONE_CONTRIBUTI ec
                                       , VOCI_ECONOMICHE       voec2
                          WHERE m.ci        (+)  = moco.ci
                            AND m.anno      (+)  = moco.anno
                            AND m.mese      (+)  = moco.mese
                            AND m.MENSILITA (+)  = moco.MENSILITA
                            AND esco.ROWID       = ec.ROWID
                            AND m.voce      (+)  = ec.con_voce
                            AND m.sub       (+)  = ec.con_sub
                            AND voec2.codice     = ec.con_voce
                            AND ((   DECODE
                                     ( voec2.classe
                                     ,'R',DECODE
                                          (ec.tipo
                                          ,'C',NVL(m.tar,0)-NVL(m.ipn_eap,0)
                                          ,'P',DECODE
                                               (TO_CHAR(m.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno),NVL(m.ipn_eap,0)
                                                               , NVL(m.tar,0)
                                               )
                                              ,NVL(m.tar,0)
                                          )
                                     ,'I',DECODE
                                          (ec.tipo
                                          ,'C',NVL(m.imp,0)-NVL(m.ipn_p,0)
                                          ,'P',DECODE
                                               (TO_CHAR(m.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno),NVL(m.ipn_p,0)
                                                               ,NVL(m.imp,0)
                                               )
                                          ,NVL(m.imp,0)
                                          )
                                         ,NVL(m.tar,0)
	                             ) != 0
                                  OR DECODE
                                     (DECODE(voec2.classe,'I','R',voec2.classe)
                                     ,'R',DECODE
                                          (ec.tipo
                                          ,'C',NVL(m.imp,0)-NVL(m.ipn_p,0)
                                          ,'P',DECODE
                                               (TO_CHAR(m.riferimento,'yyyy')
                                               ,TO_CHAR(D_anno), NVL(m.ipn_p,0)
                                                               , NVL(m.imp,0)
                                               )
                                              ,NVL(m.imp,0)
                                          )
                                         ,NVL(m.imp,0)
	                             ) != 0)  AND NVL(ec.tipo,' ')   != '0'
                         	 OR ec.tipo = '0' AND NVL(m.imp,0)    = 0
                                 )
                                )
                            AND (          esco.tipo          IS NULL
                                 OR        esco.tipo           = '0'
                                 OR        esco.tipo           = '>'
                                 OR        esco.tipo           = '<'
                                 OR        esco.tipo           = 'A'       AND
                                           moco.arr           IS NOT NULL  AND
                                    DECODE(voec.tipo,'T',-1,1) = SIGN(moco.imp)
                                 OR        esco.tipo          IN ('C','P') AND
                                       NVL(moco.arr,' ')       =
                                       DECODE
                                       (esco.tipo
                                       ,'C',DECODE
                                            (TO_CHAR(moco.riferimento,'yyyy')
                                            ,TO_CHAR(D_anno),NVL(moco.arr,' ')
                                                            ,NULL
                                            )
                                       ,'P',DECODE
                                            (TO_CHAR(moco.riferimento,'yyyy')
                                            ,TO_CHAR(D_anno),DECODE
                                                             (NVL(moco.ipn_p,0)
                                                             ,0,NULL
                                                              ,NVL(moco.arr,' ')
                                                             )
                                                            , NVL(moco.arr,' ')
                                            )
                                       )
                                 OR        esco.tipo           = 'M'       AND
                                           moco.arr           IS NULL
                                 OR DECODE(esco.tipo,'U','M','D','F') =
                                          (SELECT sesso FROM ANAGRAFICI
                                            WHERE al IS NULL
                                              AND ni =
                                                 (SELECT ni
                                                    FROM RAPPORTI_INDIVIDUALI
                                                   WHERE ci = moco.ci))
                                 OR DECODE(esco.tipo
                                          ,'1',1,'2',2,'3',3,'4',4,'5',5
                                          ,'6',6,'7',7,'8',8,'9',9,0) =
                                   (SELECT MAX(qua_inps)
                                      FROM QUALIFICHE
                                     WHERE numero =
                                          (SELECT TO_NUMBER
                                                  (SUBSTR
                                                   (MAX(DECODE(pere.servizio
                                                              ,'Q','1','I','2','0')
                                                        ||TO_CHAR(pere.qualifica)),2,6))
                                             FROM PERIODI_RETRIBUTIVI pere
                                            WHERE pere.ci        = moco.ci
                                              AND pere.servizio IN ('Q','I')
                                              AND moco.riferimento
                                                  BETWEEN pere.dal AND pere.al
                                              AND pere.periodo   = D_fine_mese
                            AND (    moco.input       = UPPER(moco.input)
                                 AND pere.competenza IN ('D','C','A')
                                  OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('P','D')
                                  OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('C','A')
                                 AND NOT EXISTS
                                    (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                                      WHERE periodo          = pere.periodo
                                        AND ci               = pere.ci
                                        AND competenza       = 'P'
                                        AND moco.riferimento BETWEEN dal AND al)
                               )
                        )
                       )
        OR DECODE(esco.tipo,'X',1,'Y',2,'Z',3) =
          (SELECT MAX(DECODE(qua_inps,9,2,qua_inps))
             FROM QUALIFICHE
            WHERE ('SI','NO',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND pere.servizio IN ('Q','I')
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN pere.dal AND pere.al
               AND pere.periodo  = D_fine_mese
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
           )
          )
        OR DECODE(esco.tipo,'x',1,'y',2) =
          (SELECT MAX(DECODE(qua_inps,9,2,qua_inps))
             FROM QUALIFICHE
            WHERE ('SI','SI',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND pere.servizio IN ('Q','I')
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN dal AND al
               AND pere.periodo  = D_fine_mese
           )
          )
        OR DECODE(esco.tipo,'o',1,'i',2) =
          (SELECT MAX(DECODE(qua_inps,9,2,qua_inps))
             FROM QUALIFICHE
            WHERE ('NO','SI',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
               AND pere.servizio IN ('Q','I')
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN dal AND al
               AND pere.periodo  = D_fine_mese
           )
          )
        OR DECODE(esco.tipo,'O',1,'I',2,'G',3) =
	  (SELECT MAX(DECODE(qua_inps,9,2,qua_inps)) FROM QUALIFICHE
            WHERE ('NO','NO',numero) =
           (SELECT SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , TO_NUMBER(SUBSTR(MAX(DECODE(servizio,'Q','1','I','2','0')||TO_CHAR(qualifica)),2,6))
              FROM POSIZIONI posi,PERIODI_RETRIBUTIVI pere
             WHERE pere.ci     = moco.ci
               AND (    moco.input       = UPPER(moco.input)
                    AND pere.competenza IN ('D','C','A')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('P','D')
                     OR  moco.input      != UPPER(moco.input)
                    AND pere.competenza IN ('C','A')
                    AND NOT EXISTS
                       (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                         WHERE periodo          = pere.periodo
                           AND ci               = pere.ci
                           AND competenza       = 'P'
                           AND moco.riferimento BETWEEN dal AND al)
                  )
               AND pere.servizio IN ('Q','I')
               AND pere.posizione = posi.codice
               AND moco.riferimento BETWEEN dal AND al
               AND pere.periodo  = D_fine_mese
           )
      )
        OR DECODE(esco.tipo,'R','SI','N','NO') =
                 (SELECT posi.ruolo FROM POSIZIONI posi
                   WHERE posi.codice =
                        (SELECT pere.posizione
                           FROM PERIODI_RETRIBUTIVI pere
                          WHERE pere.ci     = moco.ci
                            AND (    moco.input       = UPPER(moco.input)
                                 AND pere.competenza IN ('D','C','A')
                                 OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('P','D')
                                 OR  moco.input      != UPPER(moco.input)
                                 AND pere.competenza IN ('C','A')
                                 AND NOT EXISTS
                                    (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                                      WHERE periodo          = pere.periodo
                                        AND ci               = pere.ci
                                        AND competenza       = 'P'
                                        AND moco.riferimento BETWEEN dal AND al)
                               )
                            AND pere.servizio = 'Q'
                            AND moco.riferimento BETWEEN dal AND al
                            AND pere.periodo  = D_fine_mese
                         )
                 )
	OR esco.tipo = '+' AND SIGN(moco.imp) =  1
	OR esco.tipo = '-' AND SIGN(moco.imp) = -1
       )
GROUP BY esco.quadro
            ) LOOP
            D_conta_rec_az := nvl(D_conta_rec_az,0) + 1;
-- dbms_output.put_line('*** DATO *** ');
            IF CUR_DM10.codice = 'MA00' or CUR_DM10.codice = 'FE00' THEN
            D_occupati    := nvl(D_occupati,0) + nvl(CUR_DM10.occupati,0);
            D_occupati_td := nvl(D_occupati_td,0) + nvl(CUR_DM10.occupati_td,0);
            END IF;
              BEGIN
              BEGIN
                SELECT DECODE( CUR_DM10.imponibile
                             , 0, 0
                                , ROUND( CUR_DM10.imponibile)
                             )
                     , DECODE( CUR_DM10.contributo
                             , 0, 0
                                , ROUND( CUR_DM10.contributo)
                             )
                  INTO D_imponibile, D_contributo
                  FROM dual;
              END;
              IF CUR_DM10.quadro = 'C'
              THEN
-- dbms_output.put_line('tipo rec 3   '||D_prog_rec);
                INSERT INTO a_appoggio_stampe
                (no_prenotazione,no_passo,pagina,riga,testo)
                VALUES ( prenotazione
                       , 1
                       , D_prog_rec
                       , D_prog_rec
                       , '3'||
                         RPAD(nvl(CUR_AZ.gest_inps,' '),10,' ')||
                         LPAD(TO_CHAR(nvl(D_mese,0)),2,'0')||
                         RPAD(TO_CHAR(nvl(D_anno,0)),4,'0')||
                         LPAD('0',12,'0')||
                         LPAD(TO_CHAR(nvl(D_prog_rec,0)),4,'0')||
                         'B'||
                         CUR_DM10.codice||
                         DECODE( CUR_DM10.codice
                               , '**23', LPAD(TO_CHAR(nvl(CUR_DM10.num_ci,0)),12,'0')
                               , '**24', LPAD(TO_CHAR(nvl(CUR_DM10.num_ci,0)),12,'0')
                               , '**33', LPAD('0',12,'0')
                               , 'E775', LPAD('0',12,'0')
                                       , LPAD(TO_CHAR(nvl(CUR_DM10.num_ci,0)),12,'0')
                               )||
                         DECODE( CUR_DM10.codice
                               , '**23', LPAD('0',12,'0')
                               , '**24', LPAD(TO_CHAR(nvl(CUR_DM10.giorni,0)),12,'0')
                               , '**33', LPAD('0',12,'0')
                               , 'E775', LPAD('0',12,'0')
                                       , LPAD(TO_CHAR(nvl(CUR_DM10.giorni,0)),12,'0')
                               )||
                         DECODE( CUR_DM10.codice
                               , '**23', LPAD('0',12,'0')
                               , '**24', LPAD(TO_CHAR(
                                           TRUNC(ABS(nvl(D_imponibile,0))))
                                             ,12,'0')
                               , '**33', LPAD('0',12,'0')
                               , 'E775', LPAD('0',12,'0')
                                       , LPAD(TO_CHAR(
                                           TRUNC(ABS(nvl(D_imponibile,0))))
                                             ,12,'0')
                               )||
                         DECODE( CUR_DM10.codice
                               , '**23', LPAD(TO_CHAR(
                                           TRUNC(ABS(nvl(D_contributo,0))))
                                             ,12,'0')
                               , '**24', LPAD('0',12,'0')
                               , '**33', LPAD(TO_CHAR(
                                           TRUNC(ABS(nvl(D_contributo,0))))
                                             ,12,'0')
                               , 'E775', LPAD(TO_CHAR(
                                           TRUNC(ABS(nvl(D_contributo,0))))
                                             ,12,'0')
                                       , LPAD(TO_CHAR(
                                           TRUNC(ABS(nvl(D_contributo,0))))
                                             ,12,'0')
                               )||
                         LPAD('0',12,'0')||
                         LPAD('0',12,'0')||
                         LPAD(' ',10,' ')
                       );
              D_prog_rec := D_prog_rec + 1;
              D_tot_az_a := NVL(D_tot_az_a,0) + nvl(D_contributo,0);
              ELSE
-- dbms_output.put_line('tipo rec 3/2  '||D_prog_rec);
                D_prog_rec := D_prog_rec + 1;
                INSERT INTO a_appoggio_stampe
                (no_prenotazione,no_passo,pagina,riga,testo)
                VALUES ( prenotazione
                       , 1
                       , D_prog_rec
                       , D_prog_rec
                       , '3'||
                         RPAD(CUR_AZ.gest_inps,10,' ')||
                         LPAD(TO_CHAR(D_mese),2,'0')||
                         TO_CHAR(D_anno)||
                         LPAD('0',12,'0')||
                         LPAD(TO_CHAR(D_prog_rec),4,'0')||
                         'D'||
                         CUR_DM10.codice||
                         LPAD('0',12,'0')||
                         LPAD('0',12,'0')||
                         LPAD('0',12,'0')||
                         LPAD(TO_CHAR(TRUNC(
                                        ABS(nvl(D_contributo,0)))),12,'0')||
                         LPAD('0',12,'0')||
                         LPAD('0',12,'0')||
                         LPAD(' ',10,' ')
                       );
              D_tot_az_b := NVL(D_tot_az_b,0) + nvl(D_contributo,0);
              END IF;
              END;
              END LOOP; -- CUR_DM10
         END; -- fine estrazione dati DM10/S
         IF D_conta_rec_az > 0 THEN
         BEGIN -- estrazione e inserimento record di testata aziendale
                BEGIN
                  IF D_anno < 1999 AND D_mese IN (3,9) THEN
                     BEGIN
                       SELECT SUM(DECODE(anag.sesso,'M',1,0))
                            , TRUNC(SUM(DECODE(anag.sesso,'M',moco.imp,0)))
                            , SUM(DECODE(anag.sesso,'F',1,0))
                            , TRUNC(SUM(DECODE(anag.sesso,'F',moco.imp,0)))
                         INTO D_num_m,D_imp_m,D_num_f,D_imp_f
                         FROM MOVIMENTI_CONTABILI moco
                            , ANAGRAFICI          anag
                        WHERE moco.anno      = D_anno
                          AND moco.mese      = D_mese
                          AND moco.MENSILITA = D_da_mensilita
                          AND moco.voce     IN ('INPS','INPSO')
                          AND moco.ci IN
                                      (SELECT ci
                                         FROM PERIODI_RETRIBUTIVI
                                        WHERE periodo  = D_fine_mese
                                          AND competenza = 'A'
                                          AND gestione  IN
                                             (SELECT codice FROM GESTIONI
                                              WHERE posizione_inps =
                                                            CUR_AZ.gest_inps
                                             )
                                      )
                          AND anag.ni        =
                             (SELECT ni FROM RAPPORTI_INDIVIDUALI
                               WHERE ci = moco.ci)
                          AND anag.al IS NULL
                       ;
                     END;
                     D_prog_rec := D_prog_rec + 1;
  -- dbms_output.put_line('tipo rec 3/3 '||D_prog_rec);
                     INSERT INTO a_appoggio_stampe
                    (no_prenotazione,no_passo,pagina,riga,testo)
                     VALUES ( prenotazione
                            , 1
                            , D_prog_rec
                            , D_prog_rec
                            , '3'||
                              RPAD(CUR_AZ.gest_inps,10,' ')||
                              LPAD(TO_CHAR(D_mese),2,'0')||
                              TO_CHAR(D_anno)||
                              LPAD('0',12,'0')||
                              LPAD(TO_CHAR(D_prog_rec),4,'0')||
                              'X'||
                              '**01'||
                              LPAD(TO_CHAR(NVL(D_num_m,0)),12,'0')||
                              LPAD(TO_CHAR(NVL(D_imp_m,0)),12,'0')||
                              LPAD(TO_CHAR(NVL(D_num_f,0)),12,'0')||
                              LPAD(TO_CHAR(NVL(D_imp_f,0)),12,'0')||
                              LPAD('0',12,'0')||
                              LPAD('0',12,'0')||
                              LPAD(' ',10,' ')
                            );
                  BEGIN
                    BEGIN
                      SELECT MAX(scaglione)
                        INTO D_sca_max
                          FROM ASSEGNI_FAMILIARI
                         WHERE D_fine_mese BETWEEN dal
                                               AND NVL(al,TO_DATE('3333333','j'))
                      ;
                    END;
                    D_sca_prec := 0;
                      FOR CUR_SCA IN
                       (SELECT DISTINCT scaglione
                                      , dal
                          FROM ASSEGNI_FAMILIARI
                         WHERE D_fine_mese BETWEEN dal
                                               AND NVL(al,TO_DATE('3333333','j'))
                       ) LOOP
                         D_prog_ass := D_prog_ass + 1;
                         IF D_prog_ass < 12 THEN
                         BEGIN
                           SELECT NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 2, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 3, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 4, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 5, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 6, 1, 0)),0)
                                , NVL(SUM(DECODE( GREATEST(NVL(cafa.nucleo_fam,0)
                                                          ,6)
                                                , cafa.nucleo_fam,1,0)),0)
                             INTO D_nucleo_2,D_nucleo_3,D_nucleo_4
                                , D_nucleo_5,D_nucleo_6,D_nucleo_n
                             FROM CARICHI_FAMILIARI cafa
                            WHERE anno = D_anno
                              AND mese = D_mese
                              AND ci  IN
                                 (SELECT ci
                                    FROM PERIODI_RETRIBUTIVI
                                   WHERE periodo  = D_fine_mese
                                     AND competenza = 'A'
                                     AND gestione  IN
                                        (SELECT codice FROM GESTIONI
                                         WHERE posizione_inps =
                                               CUR_AZ.gest_inps
                                        )
                                 )
                             AND EXISTS
                                (SELECT ci
                                   FROM AGGIUNTIVI_FAMILIARI        agfa
                                  WHERE agfa.codice = cafa.cond_fam
                                    AND agfa.dal    = CUR_SCA.dal
                                    AND GP4_INEX.GET_IPN_FAM ( cafa.ci, D_anno, D_mese )
                                        BETWEEN NVL(agfa.aggiuntivo,0) + D_sca_prec
                                            AND NVL(agfa.aggiuntivo,0) + CUR_SCA.scaglione
                                )
                           ;
                         END;
                         D_prog_rec := D_prog_rec + 1;
  -- dbms_output.put_line('tipo rec 3/4 '||D_prog_rec);
                         INSERT INTO a_appoggio_stampe
                        (no_prenotazione,no_passo,pagina,riga,testo)
                         VALUES ( prenotazione
                                , 1
                                , D_prog_rec
                                , D_prog_rec
                                , '3'||
                                  RPAD(CUR_AZ.gest_inps,10,' ')||
                                  LPAD(TO_CHAR(D_mese),2,'0')||
                                  SUBSTR(TO_CHAR(D_anno),3,2)||
                                  LPAD('0',12,'0')||
                                  LPAD(TO_CHAR(D_prog_rec),4,'0')||
                                  'X'||
                                  '**'||LPAD(TO_CHAR(D_prog_ass),2,'0')||
                                  LPAD(TO_CHAR(D_nucleo_2),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_3),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_4),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_5),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_6),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_n),12,'0')||
                                  LPAD(' ',10,' ')
                                );
                         D_nucleo_t2 := D_nucleo_t2 + NVL(D_nucleo_2,0);
                         D_nucleo_t3 := D_nucleo_t3 + NVL(D_nucleo_3,0);
                         D_nucleo_t4 := D_nucleo_t4 + NVL(D_nucleo_4,0);
                         D_nucleo_t5 := D_nucleo_t5 + NVL(D_nucleo_5,0);
                         D_nucleo_t6 := D_nucleo_t6 + NVL(D_nucleo_6,0);
                         D_nucleo_tn := D_nucleo_tn + NVL(D_nucleo_n,0);
                         D_nucleo_2 := 0;
                         D_nucleo_3 := 0;
                         D_nucleo_4 := 0;
                         D_nucleo_5 := 0;
                         D_nucleo_6 := 0;
                         D_nucleo_n := 0;
                         D_sca_prec := CUR_SCA.scaglione;
                         END IF; -- controllo D_prog_ass
                         IF D_sca_max  = CUR_SCA.scaglione THEN
                         BEGIN
                           SELECT NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 2, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 3, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 4, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 5, 1, 0)),0)
                                , NVL(SUM(DECODE( cafa.nucleo_fam
                                                , 6, 1, 0)),0)
                                , NVL(SUM(DECODE( GREATEST(NVL(cafa.nucleo_fam,0)
                                                          ,6)
                                                , cafa.nucleo_fam,1,0)),0)
                             INTO D_nucleo_2,D_nucleo_3,D_nucleo_4
                                , D_nucleo_5,D_nucleo_6,D_nucleo_n
                             FROM CARICHI_FAMILIARI cafa
                            WHERE anno = D_anno
                              AND mese = D_mese
                              AND ci  IN
                                 (SELECT ci
                                    FROM PERIODI_RETRIBUTIVI
                                   WHERE periodo  = D_fine_mese
                                     AND competenza = 'A'
                                     AND gestione  IN
                                        (SELECT codice FROM GESTIONI
                                         WHERE posizione_inps =
                                               CUR_AZ.gest_inps
                                        )
                                 )
                              AND EXISTS
                                 (SELECT 'x' FROM INFORMAZIONI_EXTRACONTABILI inex
                                               , AGGIUNTIVI_FAMILIARI        agfa
                                   WHERE anno        = D_anno
                                     AND agfa.codice = cafa.cond_fam
                                     AND agfa.dal    = CUR_SCA.dal
                                     AND DECODE( D_mese
                                               , 3, inex.ipn_fam_2ap
                                                  , inex.ipn_fam_1ap)
                                         BETWEEN NVL(agfa.aggiuntivo,0)
                                                +D_sca_prec
                                             AND NVL(agfa.aggiuntivo,0)
                                                +CUR_SCA.scaglione
                                     AND inex.ci = cafa.ci
                                 )
                           ;
                         END;
                         D_prog_rec  := D_prog_rec + 1;
  -- dbms_output.put_line('tipo rec 3/5 '||D_prog_rec);
                         INSERT INTO a_appoggio_stampe
                        (no_prenotazione,no_passo,pagina,riga,testo)
                         VALUES ( prenotazione
                                , 1
                                , D_prog_rec
                                , D_prog_rec
                                , '3'||
                                  RPAD(CUR_AZ.gest_inps,10,' ')||
                                  LPAD(TO_CHAR(D_mese),2,'0')||
                                  SUBSTR(TO_CHAR(D_anno),3,2)||
                                  LPAD('0',12,'0')||
                                  LPAD(TO_CHAR(D_prog_rec),4,'0')||
                                  'X'||
                                  '**12'||
                                  LPAD(TO_CHAR(D_nucleo_2),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_3),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_4),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_5),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_6),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_n),12,'0')||
                                  LPAD(' ',10,' ')
                                );
                         D_nucleo_t2 := D_nucleo_t2 + NVL(D_nucleo_2,0);
                         D_nucleo_t3 := D_nucleo_t3 + NVL(D_nucleo_3,0);
                         D_nucleo_t4 := D_nucleo_t4 + NVL(D_nucleo_4,0);
                         D_nucleo_t5 := D_nucleo_t5 + NVL(D_nucleo_5,0);
                         D_nucleo_t6 := D_nucleo_t6 + NVL(D_nucleo_6,0);
                         D_nucleo_tn := D_nucleo_tn + NVL(D_nucleo_n,0);
                         ELSE NULL;
                         END IF; -- controllo D_sca_max
                      END LOOP; -- CUR_SCA
                         D_prog_rec  := D_prog_rec + 1;
  -- dbms_output.put_line('tipo rec 3/6 '||D_prog_rec);
                         INSERT INTO a_appoggio_stampe
                        (no_prenotazione,no_passo,pagina,riga,testo)
                         VALUES ( prenotazione
                                , 1
                                , D_prog_rec
                                , D_prog_rec
                                , '3'||
                                  RPAD(CUR_AZ.gest_inps,10,' ')||
                                  LPAD(TO_CHAR(D_mese),2,'0')||
                                  TO_CHAR(D_anno)||
                                  LPAD('0',12,'0')||
                                  LPAD(TO_CHAR(D_prog_rec),4,'0')||
                                  'X'||
                                  '**13'||
                                  LPAD(TO_CHAR(D_nucleo_t2),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_t3),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_t4),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_t5),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_t6),12,'0')||
                                  LPAD(TO_CHAR(D_nucleo_tn),12,'0')||
                                  LPAD(' ',10,' ')
                                );
                         D_prog_ass  := 1;
                  END;
                  END IF; -- anno < 1999
                END;
                D_nucleo_t2 := 0;
                D_nucleo_t3 := 0;
                D_nucleo_t4 := 0;
                D_nucleo_t5 := 0;
                D_nucleo_t6 := 0;
                D_nucleo_tn := 0;
  --  dbms_output.put_line('tipo rec 2   '||D_dep_prog||'  - '||CUR_AZ.gest_inps);
               INSERT INTO a_appoggio_stampe
              (no_prenotazione,no_passo,pagina,riga,testo)
               VALUES ( prenotazione
                      , 1
                      , D_dep_prog
                      , D_dep_prog
                      , '2'||
                        LPAD(CUR_AZ.gest_inps,10,' ')||
                        LPAD(TO_CHAR(D_mese),2,'0')||
                        TO_CHAR(D_anno)||
                        LPAD(TO_CHAR(ABS(NVL(D_tot_az_a,0)
                                        -NVL(D_tot_az_b,0))),12,'0')||
                        LPAD(TO_CHAR(D_dep_prog),4,'0')||
                        RPAD(nvl(CUR_AZ.gest_cf,' '),16,' ')||
                        RPAD(nvl(CUR_AZ.gest_nome,' '),20,' ')||
                        LPAD(NVL(CUR_AZ.gest_csc,' '),5,'0')||
                        RPAD(NVL(CUR_AZ.gest_ca,' '),16,' ')||
                        LPAD(NVL(CUR_AZ.gest_zona,'0'),2,'0')||
                        LPAD(NVL(to_char(D_data_esecutivita,'ddmmyyyy'),' '),8,' ')||
                        DECODE( SIGN(ABS(NVL(D_tot_az_a,0))-ABS(NVL(D_tot_az_b,0)))
                              , -1, '2','1')||
                        LPAD(' ',1,' ')||
                        '0'||
                        '0'||
                        DECODE(Valuta,'E','1',' ')||
                        LPAD(' ',15,' ')
                      );
               UPDATE a_appoggio_stampe
                  SET testo = SUBSTR(testo,1,17)||
                              LPAD(TO_CHAR(ABS(NVL(D_tot_az_a,0)
                                              -NVL(D_tot_az_b,0))),12,'0')||
                              SUBSTR(testo,30)
                WHERE no_prenotazione = prenotazione
                  AND no_passo        = 1
                  AND pagina          > D_dep_prog
                  AND SUBSTR(testo,1,1)  = '3'
                  AND SUBSTR(testo,2,10) = RPAD(CUR_AZ.gest_inps,10,' ')
               ;
               D_nr_az    := D_nr_az + 1;
               D_tot_az   := NVL(D_tot_az,0) + (NVL(D_tot_az_a,0)-NVL(D_tot_az_b,0));
               BEGIN
  -- dbms_output.put_line('tipo rec 3/7 '||D_prog_rec||'  - '||CUR_AZ.gest_inps);
                INSERT INTO a_appoggio_stampe
                (no_prenotazione,no_passo,pagina,riga,testo)
                VALUES ( prenotazione
                       , 1
                       , D_prog_rec
                       , D_prog_rec
                       , '3'||
                         RPAD(CUR_AZ.gest_inps,10,' ')||
                         LPAD(TO_CHAR(D_mese),2,'0')||
                         TO_CHAR(D_anno)||
                         LPAD('0',12,'0')||
                         LPAD(TO_CHAR(D_prog_rec),4,'0')||
                         'A'||
                         '**01'||
                         LPAD(TO_CHAR(NVL(D_occupati,0)),12,'0')||
                         LPAD(TO_CHAR(NVL(D_occupati_td,0)),12,'0')||
                         LPAD('0',12,'0')||
                         LPAD('0',12,'0')||
                         LPAD('0',12,'0')||
                         LPAD('0',12,'0')||
                         LPAD(' ',10,' ')
                      );
                D_prog_rec := D_prog_rec + 1;
                D_dep_prog := D_prog_rec;
  -- dbms_output.put_line('DOPO tipo rec 3/7 '||D_prog_rec);
                END;
         END;
         END IF; -- fine controllo su presenza di record
         END LOOP; -- CUR_AZ
         BEGIN
           --
           --  Inserimento Dati CONSULENTE / AZIENDA
           --
           INSERT INTO a_appoggio_stampe
          (no_prenotazione,no_passo,pagina,riga,testo)
           VALUES ( prenotazione
                  , 1
                  , 1
                  , 1
                  , '1'||
                    '0001'||
                    LPAD(TO_CHAR(NVL(D_da_pagare,nvl(D_tot_az,0))),12,'0')||
                    LPAD(TO_CHAR(D_nr_az),6,'0')||
                    RPAD(NVL(D_cons_nome,' '),30,' ')||
                    RPAD(NVL(D_cons_cf,' '),16,' ')||
                    RPAD(' ',8,' ')||
                    LPAD(' ',4,' ')||
                    '1'||
                    LPAD(' ',35,' ')||
                    '2'||
                    LPAD(' ',2,' ')
                  )
           ;
         END;
  END;
COMMIT;
EXCEPTION
WHEN USCITA THEN
 NULL;
END;
COMMIT;
END;
END;
/
