CREATE OR REPLACE PACKAGE PPOCEVPO IS

/******************************************************************************
 NOME:          PPOCEVPO
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY ppocevpo IS
	form_trigger_failure	exception;
	W_UTENTE	VARCHAR2(10);
	W_AMBIENTE	VARCHAR2(10);
	W_ENTE		VARCHAR2(10);
	W_LINGUA	VARCHAR2(1);
	W_PRENOTAZIONE	NUMBER(10);
	w_voce_menu	varchar2(8);
	errore		varchar2(6);
	p_stato		varchar2(1);
	p_situazione	varchar2(1);
	p_disponibilita	varchar2(1);
	P_dal		date;
	P_al		date;
   
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;
 
-- PULIZIA TABELLA DI LAVORO
      PROCEDURE DELETE_TAB IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
        DELETE FROM CALCOLO_POSTI
         WHERE CAPO_PRENOTAZIONE = W_PRENOTAZIONE;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := W_PRENOTAZIONE;
          ROLLBACK;
          INSERT INTO ERRORI_POGM (PRENOTAZIONE,VOCE_MENU,DATA,ERRORE)
          VALUES (D_PRENOTAZIONE,W_VOCE_MENU ,SYSDATE,D_ERRTEXT)
          ;
          COMMIT;
          RAISE FORM_TRIGGER_FAILURE;
      END;
      PROCEDURE CC_POSTI IS
      D_ERRTEXT                       VARCHAR2(240);
      D_PRENOTAZIONE                   NUMBER(6);
      D_CONTA                          NUMBER(5);
      D_RIOR_DATA                        DATE;
      D_SEDE_POSTO                    VARCHAR2(2);
      D_ANNO_POSTO                     NUMBER(4);
      D_NUMERO_POSTO                   NUMBER(7);
      D_POSTO                          NUMBER(5);
      D_DELIBERA                      VARCHAR2(13);
      D_DELIBERA_01                   VARCHAR2(13);
      D_DELIBERA_02                   VARCHAR2(13);
      D_DELIBERA_03                   VARCHAR2(13);
      D_DELIBERA_04                   VARCHAR2(13);
      D_DELIBERA_05                   VARCHAR2(13);
      D_DELIBERA_06                   VARCHAR2(13);
      D_DELIBERA_07                   VARCHAR2(13);
      D_DELIBERA_08                   VARCHAR2(13);
      D_DELIBERA_09                   VARCHAR2(13);
      D_DELIBERA_10                   VARCHAR2(13);
      D_DELIBERA_11                   VARCHAR2(13);
      D_DELIBERA_12                   VARCHAR2(13);
      D_DAL                              DATE;
      D_POPI_SETTORE                   NUMBER(6);
      D_SETT_SEQUENZA                  NUMBER(6);
      D_SETT_CODICE                   VARCHAR2(15);
      D_SETT_SUDDIVISIONE              NUMBER(1);
      D_SETT_SETTORE_G                 NUMBER(6);
      D_SETG_SEQUENZA                  NUMBER(6);
      D_SETG_CODICE                   VARCHAR2(15);
      D_SETT_SETTORE_A                 NUMBER(6);
      D_SETA_SEQUENZA                  NUMBER(6);
      D_SETA_CODICE                   VARCHAR2(15);
      D_SETT_SETTORE_B                 NUMBER(6);
      D_SETB_SEQUENZA                  NUMBER(6);
      D_SETB_CODICE                   VARCHAR2(15);
      D_SETT_SETTORE_C                 NUMBER(6);
      D_SETC_SEQUENZA                  NUMBER(6);
      D_SETC_CODICE                   VARCHAR2(15);
      D_SETT_GESTIONE                 VARCHAR2(4);
      D_GEST_PROSPETTO_PO             VARCHAR2(1);
      D_GEST_SINTETICO_PO             VARCHAR2(1);
      D_POPI_FIGURA                    NUMBER(6);
      D_FIGI_DAL                         DATE;
      D_FIGU_SEQUENZA                  NUMBER(6);
      D_FIGI_CODICE                   VARCHAR2(8);
      D_FIGI_QUALIFICA                 NUMBER(6);
      D_QUGI_DAL                         DATE;
      D_QUAL_SEQUENZA                  NUMBER(6);
      D_QUGI_CODICE                   VARCHAR2(8);
      D_QUGI_CONTRATTO                VARCHAR2(4);
      D_COST_DAL                         DATE;
      D_CONT_SEQUENZA                  NUMBER(3);
      D_COST_ORE_LAVORO                NUMBER(5,2);
      D_QUGI_LIVELLO                  VARCHAR2(4);
      D_FIGI_PROFILO                  VARCHAR2(4);
      D_PRPR_SEQUENZA                  NUMBER(3);
      D_PRPR_SUDDIVISIONE_PO          VARCHAR2(1);
      D_FIGI_POSIZIONE                VARCHAR2(4);
      D_POFU_SEQUENZA                  NUMBER(3);
      D_QUGI_RUOLO                    VARCHAR2(4);
      D_RUOL_SEQUENZA                  NUMBER(4);
      D_POPI_ATTIVITA                 VARCHAR2(4);
      D_ATTI_SEQUENZA                  NUMBER(6);
      D_POPI_ORE                       NUMBER(5,2);
      D_CAPO_INIZIALI                  NUMBER(5);
      D_CAPO_POSTI_01                  NUMBER(5);
      D_CAPO_POSTI_02                  NUMBER(5);
      D_CAPO_POSTI_03                  NUMBER(5);
      D_CAPO_POSTI_04                  NUMBER(5);
      D_CAPO_POSTI_05                  NUMBER(5);
      D_CAPO_POSTI_06                  NUMBER(5);
      D_CAPO_POSTI_07                  NUMBER(5);
      D_CAPO_POSTI_08                  NUMBER(5);
      D_CAPO_POSTI_09                  NUMBER(5);
      D_CAPO_POSTI_10                  NUMBER(5);
      D_CAPO_POSTI_11                  NUMBER(5);
      D_CAPO_POSTI_12                  NUMBER(5);
      D_CAPO_OLTRE                     NUMBER(5);
      D_VALORE                         NUMBER(5);
      CURSOR GEST IS
      SELECT G.CODICE
        FROM GESTIONI G
       WHERE G.GESTITO                      = 'SI'
         AND NVL(G.PROSPETTO_PO,' ')       <> 'N'
         AND EXISTS
             (SELECT 1
                FROM SETTORI
                    ,POSTI_PIANTA
               WHERE POSTI_PIANTA.DAL                 <= P_AL
                 AND SETTORI.NUMERO               = POSTI_PIANTA.SETTORE
                 AND SETTORI.GESTIONE             = G.CODICE
                 AND NVL(POSTI_PIANTA.DISPONIBILITA,'N')
                                         LIKE P_DISPONIBILITA
                 AND (    P_STATO||P_SITUAZIONE
                                           <> '%%'
                      AND POSTI_PIANTA.STATO        LIKE P_STATO
                      AND POSTI_PIANTA.SITUAZIONE   LIKE P_SITUAZIONE
                      OR  P_STATO||P_SITUAZIONE
                                            = '%%'
                      AND (    POSTI_PIANTA.STATO     IN ('T','I','C')
                           OR  POSTI_PIANTA.STATO      = 'A'
                           AND POSTI_PIANTA.SITUAZIONE = 'R'
                          )
                     )
             )
      ;
      CURSOR DELIBERE IS
      SELECT RPAD(NVL(P.SEDE_PROV,' '),2,' ')||
             LPAD(NVL(TO_CHAR(P.NUMERO_PROV),' '),7,' ')||
             LPAD(NVL(TO_CHAR(P.ANNO_PROV),' '),4,' ')
            ,MIN(P.DAL)
        FROM POSTI_PIANTA P
       WHERE P.DAL                    <= P_AL
         AND NVL(P.AL,TO_DATE('3333333','J'))
                                      >= P_DAL
         AND NVL(P.DISPONIBILITA,'N')
                                    LIKE P_DISPONIBILITA
         AND (    P_STATO||P_SITUAZIONE
                                      <> '%%'
              AND P.STATO           LIKE P_STATO
              AND P.SITUAZIONE      LIKE P_SITUAZIONE
              OR  P_STATO||P_SITUAZIONE
                                       = '%%'
              AND (    P.STATO        IN ('T','I','C')
                   OR  P.STATO         = 'A'
                   AND P.SITUAZIONE    = 'R'
                  )
             )
         AND P.SETTORE                IN
             (SELECT S.NUMERO
                FROM SETTORI S
               WHERE S.GESTIONE        = D_SETT_GESTIONE
             )
       GROUP BY
             RPAD(NVL(P.SEDE_PROV,' '),2,' ')||
             LPAD(NVL(TO_CHAR(P.NUMERO_PROV),' '),7,' ')||
             LPAD(NVL(TO_CHAR(P.ANNO_PROV),' '),4,' ')
       ORDER BY
             2,1
      ;
      CURSOR POSTI IS
      SELECT 'IIIIIIIIIIIII',
             P.SEDE_POSTO,P.ANNO_POSTO,P.NUMERO_POSTO,P.POSTO,
             P.SETTORE,P.FIGURA,P.ATTIVITA,P.ORE,
             DECODE(P.DISPONIBILITA,'R',1,0)
        FROM POSTI_PIANTA P
       WHERE P_DAL                  < NVL(P.AL,TO_DATE('3333333','J'))
         AND P_DAL                  > P.DAL
         AND P.DISPONIBILITA           = 'R'
         AND NVL(P.DISPONIBILITA,'N')
                                    LIKE P_DISPONIBILITA
         AND (    P_STATO||P_SITUAZIONE
                                      <> '%%'
              AND P.STATO           LIKE P_STATO
              AND P.SITUAZIONE      LIKE P_SITUAZIONE
              OR  P_STATO||P_SITUAZIONE
                                       = '%%'
              AND (    P.STATO        IN ('T','I','C')
                   OR  P.STATO         = 'A'
                   AND P.SITUAZIONE    = 'R'
                  )
             )
         AND P.SETTORE                IN
             (SELECT S.NUMERO
                FROM SETTORI S
               WHERE S.GESTIONE        = D_SETT_GESTIONE
             )
       UNION
      SELECT RPAD(NVL(P.SEDE_PROV,' '),2,' ')||
             LPAD(NVL(TO_CHAR(P.NUMERO_PROV),' '),7,' ')||
             LPAD(NVL(TO_CHAR(P.ANNO_PROV),' '),4,' '),
             P.SEDE_POSTO,P.ANNO_POSTO,P.NUMERO_POSTO,P.POSTO,
             P.SETTORE,P.FIGURA,P.ATTIVITA,P.ORE,
             DECODE(P.DISPONIBILITA,'R',1,0)
        FROM POSTI_PIANTA P
       WHERE P.DAL               BETWEEN P_DAL AND P_AL
         AND NVL(P.DISPONIBILITA,'N')
                                    LIKE P_DISPONIBILITA
         AND (    P_STATO||P_SITUAZIONE
                                      <> '%%'
              AND P.STATO           LIKE P_STATO
              AND P.SITUAZIONE      LIKE P_SITUAZIONE
              OR  P_STATO||P_SITUAZIONE
                                       = '%%'
              AND (    P.STATO        IN ('T','I','C')
                   OR  P.STATO         = 'A'
                   AND P.SITUAZIONE    = 'R'
                  )
             )
         AND P.SETTORE                IN
             (SELECT S.NUMERO
                FROM SETTORI S
               WHERE S.GESTIONE        = D_SETT_GESTIONE
             )
       UNION
      SELECT RPAD(NVL(P.SEDE_PROV,' '),2,' ')||
             LPAD(NVL(TO_CHAR(P.NUMERO_PROV),' '),7,' ')||
             LPAD(NVL(TO_CHAR(P.ANNO_PROV),' '),4,' '),
             P.SEDE_POSTO,P.ANNO_POSTO,P.NUMERO_POSTO,P.POSTO,
             P.SETTORE,P.FIGURA,P.ATTIVITA,P.ORE,
             DECODE(P.DISPONIBILITA,'R',-1,0)
        FROM POSTI_PIANTA P
       WHERE NVL(P.AL,TO_DATE('3333333','J'))
                                 BETWEEN P_DAL AND P_AL
         AND NVL(P.DISPONIBILITA,'N')
                                    LIKE P_DISPONIBILITA
         AND (    P_STATO||P_SITUAZIONE
                                      <> '%%'
              AND P.STATO           LIKE P_STATO
              AND P.SITUAZIONE      LIKE P_SITUAZIONE
              OR  P_STATO||P_SITUAZIONE
                                       = '%%'
              AND (    P.STATO        IN ('T','I','C')
                   OR  P.STATO         = 'A'
                   AND P.SITUAZIONE    = 'R'
                  )
             )
         AND P.SETTORE                IN
             (SELECT S.NUMERO
                FROM SETTORI S
               WHERE S.GESTIONE        = D_SETT_GESTIONE
             )
       ORDER BY 2,3,4,5
      ;
      BEGIN
        BEGIN
           SELECT DATA
             INTO D_RIOR_DATA
             FROM RIFERIMENTO_ORGANICO
           ;
        END;
        OPEN GEST;
        LOOP
          FETCH GEST INTO D_SETT_GESTIONE;
          EXIT  WHEN GEST%NOTFOUND;
          D_DELIBERA_01   := '.';
          D_DELIBERA_02   := '.';
          D_DELIBERA_03   := '.';
          D_DELIBERA_04   := '.';
          D_DELIBERA_05   := '.';
          D_DELIBERA_06   := '.';
          D_DELIBERA_07   := '.';
          D_DELIBERA_08   := '.';
          D_DELIBERA_09   := '.';
          D_DELIBERA_10   := '.';
          D_DELIBERA_11   := '.';
          D_DELIBERA_12   := '.';
          D_CONTA         := 0;
          OPEN DELIBERE;
          LOOP
             FETCH DELIBERE INTO D_DELIBERA,D_DAL;
             EXIT WHEN DELIBERE%NOTFOUND;
             D_CONTA := D_CONTA + 1;
             IF D_CONTA > 12 THEN
                EXIT;
             END IF;
             IF    D_CONTA = 1 THEN
                   D_DELIBERA_01 := D_DELIBERA;
             ELSIF D_CONTA = 2 THEN
                   D_DELIBERA_02 := D_DELIBERA;
             ELSIF D_CONTA = 3 THEN
                   D_DELIBERA_03 := D_DELIBERA;
             ELSIF D_CONTA = 4 THEN
                   D_DELIBERA_04 := D_DELIBERA;
             ELSIF D_CONTA = 5 THEN
                   D_DELIBERA_05 := D_DELIBERA;
             ELSIF D_CONTA = 6 THEN
                   D_DELIBERA_06 := D_DELIBERA;
             ELSIF D_CONTA = 7 THEN
                   D_DELIBERA_07 := D_DELIBERA;
             ELSIF D_CONTA = 8 THEN
                   D_DELIBERA_08 := D_DELIBERA;
             ELSIF D_CONTA = 9 THEN
                   D_DELIBERA_09 := D_DELIBERA;
             ELSIF D_CONTA = 10 THEN
                   D_DELIBERA_10 := D_DELIBERA;
             ELSIF D_CONTA = 11 THEN
                   D_DELIBERA_11 := D_DELIBERA;
             ELSIF D_CONTA = 12 THEN
                   D_DELIBERA_12 := D_DELIBERA;
             END IF;
          END LOOP;
          CLOSE DELIBERE;
          OPEN POSTI;
          LOOP
             FETCH POSTI INTO D_DELIBERA,
                              D_SEDE_POSTO,D_ANNO_POSTO,D_NUMERO_POSTO,D_POSTO,
                              D_POPI_SETTORE,D_POPI_FIGURA,
                              D_POPI_ATTIVITA,D_POPI_ORE,D_VALORE;
             IF POSTI%NOTFOUND THEN
                EXIT;
             END IF;
             BEGIN
                SELECT DECODE(D_DELIBERA,'IIIIIIIIIIIII',D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_01,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_02,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_03,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_04,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_05,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_06,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_07,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_08,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_09,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_10,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_11,D_VALORE,0)
                      ,DECODE(D_DELIBERA,D_DELIBERA_12,D_VALORE,0)
                      ,DECODE(D_DELIBERA
                             ,'IIIIIIIIIIIII',0
                             ,D_DELIBERA_01,0
                             ,D_DELIBERA_02,0
                             ,D_DELIBERA_03,0
                             ,D_DELIBERA_04,0
                             ,D_DELIBERA_05,0
                             ,D_DELIBERA_06,0
                             ,D_DELIBERA_07,0
                             ,D_DELIBERA_08,0
                             ,D_DELIBERA_09,0
                             ,D_DELIBERA_10,0
                             ,D_DELIBERA_11,0
                             ,D_DELIBERA_12,0
                                           ,D_VALORE
                             )
                  INTO D_CAPO_INIZIALI
                      ,D_CAPO_POSTI_01
                      ,D_CAPO_POSTI_02
                      ,D_CAPO_POSTI_03
                      ,D_CAPO_POSTI_04
                      ,D_CAPO_POSTI_05
                      ,D_CAPO_POSTI_06
                      ,D_CAPO_POSTI_07
                      ,D_CAPO_POSTI_08
                      ,D_CAPO_POSTI_09
                      ,D_CAPO_POSTI_10
                      ,D_CAPO_POSTI_11
                      ,D_CAPO_POSTI_12
                      ,D_CAPO_OLTRE
                  FROM DUAL
                ;
             END;
             BEGIN
                SELECT NVL(S.SEQUENZA,999999),S.CODICE,S.SUDDIVISIONE,
                       G.PROSPETTO_PO,NVL(G.SINTETICO_PO,G.PROSPETTO_PO),
                       S.SETTORE_G,S.SETTORE_A,
                       S.SETTORE_B,S.SETTORE_C,G.SINTETICO_PO
                  INTO D_SETT_SEQUENZA,D_SETT_CODICE,D_SETT_SUDDIVISIONE,
                       D_GEST_PROSPETTO_PO,D_GEST_SINTETICO_PO,
                       D_SETT_SETTORE_G,D_SETT_SETTORE_A,
                       D_SETT_SETTORE_B,D_SETT_SETTORE_C,
                       D_GEST_SINTETICO_PO
                  FROM GESTIONI G,SETTORI S
                 WHERE S.NUMERO    = D_POPI_SETTORE
                   AND G.CODICE    = S.GESTIONE
                ;
             END;
             IF D_SETT_SUDDIVISIONE = 0 THEN
                D_SETT_SETTORE_G   := D_POPI_SETTORE;
                D_SETG_SEQUENZA    := D_SETT_SEQUENZA;
                D_SETG_CODICE      := D_SETT_CODICE;
                D_SETT_SETTORE_A   := D_POPI_SETTORE;
                D_SETA_SEQUENZA    := 0;
                D_SETA_CODICE      := D_SETT_CODICE;
                D_SETT_SETTORE_B   := D_POPI_SETTORE;
                D_SETB_SEQUENZA    := 0;
                D_SETB_CODICE      := D_SETT_CODICE;
                D_SETT_SETTORE_C   := D_POPI_SETTORE;
                D_SETC_SEQUENZA    := 0;
                D_SETC_CODICE      := D_SETT_CODICE;
             ELSE
                BEGIN
                  SELECT NVL(SEQUENZA,999999),CODICE
                    INTO D_SETG_SEQUENZA,D_SETG_CODICE
                    FROM SETTORI
                   WHERE NUMERO = D_SETT_SETTORE_G
                  ;
                END;
                IF D_SETT_SUDDIVISIONE = 1 THEN
                   D_SETT_SETTORE_A   := D_POPI_SETTORE;
                   D_SETA_SEQUENZA    := D_SETT_SEQUENZA;
                   D_SETA_CODICE      := D_SETT_CODICE;
                   D_SETT_SETTORE_B   := D_POPI_SETTORE;
                   D_SETB_SEQUENZA    := 0;
                   D_SETB_CODICE      := D_SETT_CODICE;
                   D_SETT_SETTORE_C   := D_POPI_SETTORE;
                   D_SETC_SEQUENZA    := 0;
                   D_SETC_CODICE      := D_SETT_CODICE;
                ELSE
                   BEGIN
                     SELECT NVL(SEQUENZA,999999),CODICE
                       INTO D_SETA_SEQUENZA,D_SETA_CODICE
                       FROM SETTORI
                      WHERE NUMERO = D_SETT_SETTORE_A
                     ;
                   END;
                   IF D_SETT_SUDDIVISIONE = 2 THEN
                      D_SETT_SETTORE_B   := D_POPI_SETTORE;
                      D_SETB_SEQUENZA    := D_SETT_SEQUENZA;
                      D_SETB_CODICE      := D_SETT_CODICE;
                      D_SETT_SETTORE_C   := D_POPI_SETTORE;
                      D_SETC_SEQUENZA    := 0;
                      D_SETC_CODICE      := D_SETT_CODICE;
                   ELSE
                     BEGIN
                       SELECT NVL(SEQUENZA,999999),CODICE
                         INTO D_SETB_SEQUENZA,D_SETB_CODICE
                         FROM SETTORI
                        WHERE NUMERO = D_SETT_SETTORE_B
                       ;
                     END;
                     IF D_SETT_SUDDIVISIONE = 3 THEN
                        D_SETT_SETTORE_C   := D_POPI_SETTORE;
                        D_SETC_SEQUENZA     := D_SETT_SEQUENZA;
                        D_SETC_CODICE      := D_SETT_CODICE;
                     ELSE
                        BEGIN
                           SELECT NVL(SEQUENZA,999999),CODICE
                             INTO D_SETC_SEQUENZA,D_SETC_CODICE
                             FROM SETTORI
                            WHERE NUMERO = D_SETT_SETTORE_C
                           ;
                        END;
                     END IF;
                   END IF;
                END IF;
             END IF;
             BEGIN
               SELECT FG.DAL,NVL(FI.SEQUENZA,999999),FG.CODICE,
                      FG.QUALIFICA,QG.DAL,NVL(QU.SEQUENZA,999999),QG.CODICE,
                      QG.CONTRATTO,CS.DAL,NVL(CO.SEQUENZA,999),
                      CS.ORE_LAVORO,
                      QG.LIVELLO,QG.RUOLO,NVL(RU.SEQUENZA,999),
                      FG.PROFILO,NVL(PR.SEQUENZA,999),
                      DECODE(FG.PROFILO,NULL,'F',
                             DECODE(D_GEST_SINTETICO_PO,NULL,'F'
                                                       ,'Q' ,'F'
                                                       ,'L' ,'F'
                                                       ,PR.SUDDIVISIONE_PO
                                   )
                           ),
                      FG.POSIZIONE,NVL(PF.SEQUENZA,999)
                 INTO D_FIGI_DAL,D_FIGU_SEQUENZA,D_FIGI_CODICE,
                      D_FIGI_QUALIFICA,D_QUGI_DAL,
                      D_QUAL_SEQUENZA,D_QUGI_CODICE,
                      D_QUGI_CONTRATTO,D_COST_DAL,D_CONT_SEQUENZA,
                      D_COST_ORE_LAVORO,D_QUGI_LIVELLO,D_QUGI_RUOLO,
                      D_RUOL_SEQUENZA,D_FIGI_PROFILO,D_PRPR_SEQUENZA,
                      D_PRPR_SUDDIVISIONE_PO,
                      D_FIGI_POSIZIONE,D_POFU_SEQUENZA
                 FROM POSIZIONI_FUNZIONALI     PF,
                      PROFILI_PROFESSIONALI    PR,
                      RUOLI                    RU,
                      CONTRATTI_STORICI        CS,
                      CONTRATTI                CO,
                      QUALIFICHE_GIURIDICHE    QG,
                      QUALIFICHE               QU,
                      FIGURE_GIURIDICHE        FG,
                      FIGURE                   FI
                WHERE D_RIOR_DATA         BETWEEN FG.DAL
                                      AND NVL(FG.AL,TO_DATE('3333333','J'))
                  AND D_RIOR_DATA         BETWEEN QG.DAL
                                      AND NVL(QG.AL,TO_DATE('3333333','J'))
                  AND D_RIOR_DATA         BETWEEN CS.DAL
                                      AND NVL(CS.AL,TO_DATE('3333333','J'))
                  AND PF.PROFILO      (+) = FG.PROFILO
                  AND PF.CODICE       (+) = FG.POSIZIONE
                  AND PR.CODICE       (+) = FG.PROFILO
                  AND RU.CODICE           = QG.RUOLO
                  AND CS.CONTRATTO        = QG.CONTRATTO
                  AND CO.CODICE           = QG.CONTRATTO
                  AND QG.NUMERO           = FG.QUALIFICA
                  AND QU.NUMERO           = FG.QUALIFICA
                  AND FG.NUMERO           = D_POPI_FIGURA
                  AND FI.NUMERO           = D_POPI_FIGURA
               ;
             END;
             BEGIN
               SELECT NVL(SEQUENZA,999999)
                 INTO D_ATTI_SEQUENZA
                 FROM ATTIVITA
                WHERE CODICE    = D_POPI_ATTIVITA
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 D_ATTI_SEQUENZA := 999999;
             END;
      --
      --  INSERIMENTO REGISTRAZIONE POSTO.
      --
             BEGIN
               INSERT INTO CALCOLO_POSTI
               (CAPO_PRENOTAZIONE,CAPO_RILEVANZA,RIOR_DATA,
                POPI_SEDE_POSTO,POPI_ANNO_POSTO,POPI_NUMERO_POSTO,POPI_POSTO,
                POPI_SETTORE,
                SETT_SEQUENZA,SETT_CODICE,SETT_SUDDIVISIONE,SETT_SETTORE_G,
                SETG_SEQUENZA,SETG_CODICE,SETT_SETTORE_A,SETA_SEQUENZA,
                SETA_CODICE,SETT_SETTORE_B,SETB_SEQUENZA,SETB_CODICE,
                SETT_SETTORE_C,SETC_SEQUENZA,SETC_CODICE,SETT_GESTIONE,
                GEST_PROSPETTO_PO,GEST_SINTETICO_PO,
                POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,
                FIGI_CODICE,FIGI_QUALIFICA,
                QUGI_DAL,QUAL_SEQUENZA,QUGI_CODICE,QUGI_CONTRATTO,COST_DAL,
                CONT_SEQUENZA,COST_ORE_LAVORO,QUGI_LIVELLO,FIGI_PROFILO,
                PRPR_SEQUENZA,PRPR_SUDDIVISIONE_PO,
                FIGI_POSIZIONE,POFU_SEQUENZA,
                QUGI_RUOLO,RUOL_SEQUENZA,
                POPI_ATTIVITA,ATTI_SEQUENZA,CAPO_ORE_PREVISTI,
                CAPO_PREVISTI,CAPO_IN_PIANTA,CAPO_IN_DEROGA,
                CAPO_IN_SOVRANNUMERO,CAPO_IN_RILASCIO,CAPO_IN_ACQUISIZIONE,
                CAPO_IN_ISTITUZIONE,CAPO_ASSEGNAZIONI_RUOLO_L1,
                CAPO_ASSEGNAZIONI_RUOLO_L2,CAPO_ASSEGNAZIONI_RUOLO_L3,
                CAPO_ASSEGNAZIONI_RUOLO,CAPO_ASSEGNAZIONI,
                CAPO_ASSENZE_INCARICO,CAPO_ASSENZE_ASSENZA,CAPO_DISPONIBILI,
                POPI_DELIBERA_01,POPI_DELIBERA_02,POPI_DELIBERA_03,
                POPI_DELIBERA_04,POPI_DELIBERA_05,POPI_DELIBERA_06,
                POPI_DELIBERA_07,POPI_DELIBERA_08,POPI_DELIBERA_09,
                POPI_DELIBERA_10,POPI_DELIBERA_11,POPI_DELIBERA_12
               )
               VALUES
               (W_PRENOTAZIONE,6,D_RIOR_DATA,
                D_SEDE_POSTO,D_ANNO_POSTO,D_NUMERO_POSTO,D_POSTO,
                D_POPI_SETTORE,
                D_SETT_SEQUENZA,D_SETT_CODICE,
                D_SETT_SUDDIVISIONE,D_SETT_SETTORE_G,
                D_SETG_SEQUENZA,D_SETG_CODICE,
                D_SETT_SETTORE_A,D_SETA_SEQUENZA,
                D_SETA_CODICE,D_SETT_SETTORE_B,
                D_SETB_SEQUENZA,D_SETB_CODICE,
                D_SETT_SETTORE_C,D_SETC_SEQUENZA,D_SETC_CODICE,
                D_SETT_GESTIONE,D_GEST_PROSPETTO_PO,D_GEST_SINTETICO_PO,
                D_POPI_FIGURA,D_FIGI_DAL,
                D_FIGU_SEQUENZA,D_FIGI_CODICE,D_FIGI_QUALIFICA,
                D_QUGI_DAL,D_QUAL_SEQUENZA,D_QUGI_CODICE,
                D_QUGI_CONTRATTO,D_COST_DAL,
                D_CONT_SEQUENZA,D_COST_ORE_LAVORO,
                D_QUGI_LIVELLO,D_FIGI_PROFILO,
                D_PRPR_SEQUENZA,D_PRPR_SUDDIVISIONE_PO,
                D_FIGI_POSIZIONE,D_POFU_SEQUENZA,
                D_QUGI_RUOLO,D_RUOL_SEQUENZA,
                D_POPI_ATTIVITA,D_ATTI_SEQUENZA,
                NVL(D_POPI_ORE,D_COST_ORE_LAVORO),
                D_CAPO_INIZIALI,D_CAPO_POSTI_01,D_CAPO_POSTI_02,
                D_CAPO_POSTI_03,D_CAPO_POSTI_04,D_CAPO_POSTI_05,
                D_CAPO_POSTI_06,D_CAPO_POSTI_07,D_CAPO_POSTI_08,
                D_CAPO_POSTI_09,D_CAPO_POSTI_10,D_CAPO_POSTI_11,
                D_CAPO_POSTI_12,D_CAPO_OLTRE,D_VALORE,
                D_DELIBERA_01,D_DELIBERA_02,D_DELIBERA_03,
                D_DELIBERA_04,D_DELIBERA_05,D_DELIBERA_06,
                D_DELIBERA_07,D_DELIBERA_08,D_DELIBERA_09,
                D_DELIBERA_10,D_DELIBERA_11,D_DELIBERA_12
                )
               ;
             END;
          END LOOP;
          CLOSE POSTI;
        END LOOP;
        CLOSE GEST;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := W_PRENOTAZIONE;
          ROLLBACK;
          INSERT INTO ERRORI_POGM (PRENOTAZIONE,VOCE_MENU,DATA,ERRORE)
          VALUES (D_PRENOTAZIONE,W_VOCE_MENU ,SYSDATE,D_ERRTEXT)
          ;
          COMMIT;
          RAISE FORM_TRIGGER_FAILURE;
      END;
      -- CALCOLO
      PROCEDURE CALCOLO
      IS
      BEGIN
         BEGIN
            DELETE_TAB;
            CC_POSTI;
            COMMIT;
	 exception when form_trigger_failure then
		raise;
         END;
      END;
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER) is
BEGIN
               IF PRENOTAZIONE != 0 THEN
                  BEGIN  -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
                     SELECT UTENTE
                          , AMBIENTE
                          , ENTE
                          , GRUPPO_LING
                          , VOCE_MENU
                       INTO W_UTENTE
                          , W_AMBIENTE
                          , W_ENTE
                          , W_LINGUA
                          , W_VOCE_MENU
                       FROM A_PRENOTAZIONI
                      WHERE NO_PRENOTAZIONE = PRENOTAZIONE
                     ;
                  EXCEPTION
                     WHEN OTHERS THEN NULL;
                  END;
               END IF;
               BEGIN
                 SELECT SUBSTR(PARA.VALORE,1,1)
                   INTO P_STATO
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_STATO'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    P_STATO := '%';
               END;
               BEGIN
                 SELECT SUBSTR(PARA.VALORE,1,1)
                   INTO P_SITUAZIONE
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_SITUAZIONE'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    P_SITUAZIONE := '%';
               END;
               BEGIN
                 SELECT SUBSTR(PARA.VALORE,1,1)
                   INTO P_DISPONIBILITA
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_DISPONIBILITA'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    P_DISPONIBILITA := '%';
               END;
               BEGIN
                 SELECT TO_DATE(PARA.VALORE,'DD/MM/YYYY')
                   INTO P_DAL
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_DAL'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_DAL := TO_DATE('01011997','DDMMYYYY');
            --     BEGIN
            --        SELECT
            --          TO_DATE('0101'||TO_CHAR(RIOR.DATA,'YYYY'),'DDMMYYYY')
            --          INTO P_DAL
            --          FROM RIFERIMENTO_ORGANICO RIOR
            --        ;
            --     EXCEPTION
            --        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            --          P_DAL :=
            --          TO_DATE('0101'||TO_CHAR(SYSDATE,'YYYY'),'DDMMYYYY');
            --     END;
               END;
               BEGIN
                 SELECT TO_DATE(PARA.VALORE,'DD/MM/YYYY')
                   INTO P_AL
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_AL'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    P_AL := TO_DATE('31121998','DDMMYYYY');
            --     BEGIN
            --        SELECT
            --          TO_DATE('3112'||TO_CHAR(RIOR.DATA,'YYYY'),'DDMMYYYY')
            --          INTO P_AL
            --          FROM RIFERIMENTO_ORGANICO RIOR
            --        ;
            --     EXCEPTION
            --        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            --           P_AL :=
            --           TO_DATE('3112'||TO_CHAR(SYSDATE,'YYYY'),'DDMMYYYY');
            --     END;
               END;
               W_PRENOTAZIONE := PRENOTAZIONE;
               ERRORE := to_char(null); 
               -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
               CALCOLO;  -- ESECUZIONE DEL CALCOLO POSTI
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
                        SET ERRORE       = 'P05809'
                          , PROSSIMO_PASSO = 91
                      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                     ;
                     COMMIT;
                  END IF;
               END IF;
            EXCEPTION when form_trigger_failure then
			null;
               WHEN OTHERS THEN
                  BEGIN
                     ROLLBACK;
                     IF W_PRENOTAZIONE != 0 THEN
                        UPDATE A_PRENOTAZIONI
                           SET ERRORE       = '*ABORT*'
                             , PROSSIMO_PASSO = 99
                        WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                        ;
                        COMMIT;
                     END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
				null;
                  END;
            END;
END;
/

