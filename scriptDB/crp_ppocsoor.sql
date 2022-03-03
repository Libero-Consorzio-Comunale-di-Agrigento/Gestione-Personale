CREATE OR REPLACE PACKAGE PPOCSOOR IS
/******************************************************************************
 NOME:          PPOCSOOR
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
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PPOCSOOR IS
form_trigger_failure	exception;
W_UTENTE	VARCHAR2(10);
W_AMBIENTE	VARCHAR2(10);
W_ENTE		VARCHAR2(10);
W_LINGUA	VARCHAR2(1);
W_PRENOTAZIONE	NUMBER(10);
w_voce_menu	varchar2(8);
errore		varchar2(6);
P_D_F		VARCHAR2(1);
P_voce_menu	varchar2(8);
p_uso_interno	varchar2(1);
P_LIVELLO	NUmBER(1);
p_lingue	VARCHAR2(3);
      -- PULIZIA TABELLA DI LAVORO
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE RAGGR_POSTI IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
         INSERT INTO CALCOLO_DOTAZIONE
         (CADO_PRENOTAZIONE,CADO_RILEVANZA,CADO_LINGUE,RIOR_DATA,
          POPI_SEDE_POSTO,
          POPI_ANNO_POSTO,POPI_NUMERO_POSTO,POPI_POSTO,POPI_DAL,
          POPI_RICOPRIBILE,POPI_GRUPPO,
          POPI_PIANTA,SETP_SEQUENZA,SETP_CODICE,POPI_SETTORE,
          SETT_SEQUENZA,SETT_CODICE,SETT_SUDDIVISIONE,SETT_SETTORE_G,
          SETG_SEQUENZA,SETG_CODICE,SETT_SETTORE_A,SETA_SEQUENZA,
          SETA_CODICE,SETT_SETTORE_B,SETB_SEQUENZA,SETB_CODICE,
          SETT_SETTORE_C,SETC_SEQUENZA,SETC_CODICE,
          SETT_GESTIONE,GEST_PROSPETTO_PO,GEST_SINTETICO_PO,
          POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,FIGI_CODICE,FIGI_QUALIFICA,
          QUGI_DAL,QUAL_SEQUENZA,QUGI_CODICE,QUGI_CONTRATTO,COST_DAL,
          CONT_SEQUENZA,COST_ORE_LAVORO,QUGI_LIVELLO,FIGI_PROFILO,
          PRPR_SEQUENZA,PRPR_SUDDIVISIONE_PO,
          FIGI_POSIZIONE,POFU_SEQUENZA,
          QUGI_RUOLO,RUOL_SEQUENZA,POPI_ATTIVITA,ATTI_SEQUENZA,
          PEGI_POSIZIONE,POSI_SEQUENZA,PEGI_TIPO_RAPPORTO,
          CADO_PREVISTI,CADO_ORE_PREVISTI,CADO_IN_PIANTA,CADO_IN_DEROGA,
          CADO_IN_SOVRANNUMERO,CADO_IN_RILASCIO,CADO_IN_ACQUISIZIONE,
          CADO_IN_ISTITUZIONE,CADO_ASSEGNAZIONI_RUOLO,
          CADO_ORE_ASSEGNAZIONI_RUOLO,CADO_COPERTI_RUOLO,
          CADO_ORE_COPERTI_RUOLO,CADO_COPERTI_NO_RUOLO,
          CADO_ORE_COPERTI_NO_RUOLO,CADO_VACANTI,CADO_ORE_VACANTI,
          CADO_VACANTI_COPERTI,CADO_ORE_VACANTI_COPERTI)
      SELECT
          CADO_PRENOTAZIONE,CADO_RILEVANZA+5,MAX(CADO_LINGUE),MAX(RIOR_DATA),
          NULL,NULL,NULL,NULL,NULL,NULL,
          POPI_GRUPPO,POPI_PIANTA,
          MAX(SETP_SEQUENZA),MAX(SETP_CODICE),POPI_SETTORE,
          MAX(SETT_SEQUENZA),MAX(SETT_CODICE),
          MAX(SETT_SUDDIVISIONE),MAX(SETT_SETTORE_G),
          MAX(SETG_SEQUENZA),MAX(SETG_CODICE),
          MAX(SETT_SETTORE_A),MAX(SETA_SEQUENZA),
          MAX(SETA_CODICE),MAX(SETT_SETTORE_B),
          MAX(SETB_SEQUENZA),MAX(SETB_CODICE),
          MAX(SETT_SETTORE_C),MAX(SETC_SEQUENZA),
          MAX(SETC_CODICE),MAX(SETT_GESTIONE),
          MAX(GEST_PROSPETTO_PO),MAX(GEST_SINTETICO_PO),
          POPI_FIGURA,MAX(FIGI_DAL),MAX(FIGU_SEQUENZA),
          MAX(FIGI_CODICE),FIGI_QUALIFICA,
          MAX(QUGI_DAL),MAX(QUAL_SEQUENZA),
          MAX(QUGI_CODICE),MAX(QUGI_CONTRATTO),MAX(COST_DAL),
          MAX(CONT_SEQUENZA),COST_ORE_LAVORO,
          MAX(QUGI_LIVELLO),MAX(FIGI_PROFILO),
          MAX(PRPR_SEQUENZA),MAX(PRPR_SUDDIVISIONE_PO),
          MAX(FIGI_POSIZIONE),MAX(POFU_SEQUENZA),
          MAX(QUGI_RUOLO),MAX(RUOL_SEQUENZA),
          POPI_ATTIVITA,MAX(ATTI_SEQUENZA),
          PEGI_POSIZIONE,MAX(POSI_SEQUENZA),PEGI_TIPO_RAPPORTO,
          SUM(CADO_PREVISTI),CADO_ORE_PREVISTI,
          SUM(CADO_IN_PIANTA),SUM(CADO_IN_DEROGA),
          SUM(CADO_IN_SOVRANNUMERO),SUM(CADO_IN_RILASCIO),
          SUM(CADO_IN_ACQUISIZIONE),SUM(CADO_IN_ISTITUZIONE),
          SUM(CADO_ASSEGNAZIONI_RUOLO),CADO_ORE_ASSEGNAZIONI_RUOLO,
          SUM(CADO_COPERTI_RUOLO),CADO_ORE_COPERTI_RUOLO,
          SUM(CADO_COPERTI_NO_RUOLO),CADO_ORE_COPERTI_NO_RUOLO,
          SUM(CADO_VACANTI),CADO_ORE_VACANTI,
          SUM(CADO_VACANTI_COPERTI),CADO_ORE_VACANTI_COPERTI
        FROM CALCOLO_DOTAZIONE
       WHERE CADO_PRENOTAZIONE = w_PRENOTAZIONE
         AND CADO_RILEVANZA    < 6
       GROUP BY
          CADO_PRENOTAZIONE,CADO_RILEVANZA,POPI_PIANTA,POPI_SETTORE,
          POPI_FIGURA,FIGI_QUALIFICA,POPI_ATTIVITA,POPI_GRUPPO,PEGI_POSIZIONE,
          PEGI_TIPO_RAPPORTO,COST_ORE_LAVORO,CADO_ORE_PREVISTI,
          CADO_ORE_ASSEGNAZIONI_RUOLO,CADO_ORE_COPERTI_RUOLO,
          CADO_ORE_COPERTI_NO_RUOLO,CADO_ORE_VACANTI,CADO_ORE_VACANTI_COPERTI
      ;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := W_PRENOTAZIONE;
          ROLLBACK;
          INSERT INTO ERRORI_POGM (PRENOTAZIONE,VOCE_MENU,DATA,ERRORE)
          VALUES (D_PRENOTAZIONE,w_VOCE_MENU ,SYSDATE,D_ERRTEXT)
          ;
          COMMIT;
          RAISE FORM_TRIGGER_FAILURE;
      END;
-- DETERMINA LA SEQUENZA DEI GRUPPI LINGUISTICI
PROCEDURE SEQ_LINGUA IS
D_LINGUA_1     VARCHAR2(1);
D_LINGUA_2     VARCHAR2(1);
      D_LINGUA_3     VARCHAR2(1);
      D_LINGUA       VARCHAR2(1);
      D_CONTA        NUMBER(2);
      CURSOR  GRUPPI_LING IS
              SELECT GRUPPO_AL
                FROM GRUPPI_LINGUISTICI
               WHERE GRUPPO  = w_LINGUA
                 AND ROWNUM  < 4
               ORDER BY SEQUENZA,GRUPPO_AL;
      BEGIN
       IF w_LINGUA != '*' THEN
        OPEN GRUPPI_LING;
        D_CONTA     := 1;
        D_LINGUA_1  := '?';
        D_LINGUA_2  := '?';
        D_LINGUA_3  := '?';
        LOOP
          FETCH GRUPPI_LING INTO D_LINGUA;
          EXIT WHEN GRUPPI_LING%NOTFOUND;
          IF D_CONTA = 1 THEN
             D_LINGUA_1 := D_LINGUA;
          ELSIF
             D_CONTA = 2 THEN
             D_LINGUA_2 := D_LINGUA;
          ELSE
             D_LINGUA_3 := D_LINGUA;
          END IF;
          IF D_CONTA = 3 THEN
             EXIT;
          END IF;
          D_CONTA := D_CONTA + 1;
        END LOOP;
        CLOSE GRUPPI_LING;
       ELSE
        D_LINGUA_1 := 'I';
        D_LINGUA_2 := '?';
        D_LINGUA_3 := '?';
       END IF;
       P_LINGUE := D_LINGUA_1||D_LINGUA_2||D_LINGUA_3;
      END;
     /* GENERAZIONE DELLA TABELLA DI APPOGGIO PER SITUAZIONE POSTI */
      PROCEDURE CC_POSTI IS
      D_ERRTEXT                       VARCHAR2(240);
      D_PRENOTAZIONE                   NUMBER(6);
      D_RIOR_DATA                        DATE;
      D_POPI_SEDE_POSTO               VARCHAR2(2);
      D_POPI_ANNO_POSTO                NUMBER(4);
      D_POPI_NUMERO_POSTO              NUMBER(7);
      D_POPI_POSTO                     NUMBER(5);
      D_POPI_DAL                         DATE;
      D_POPI_STATO                    VARCHAR2(1);
      D_POPI_SITUAZIONE               VARCHAR2(1);
      D_POPI_RICOPRIBILE              VARCHAR2(1);
      D_POPI_GRUPPO                   VARCHAR2(12);
      D_POPI_PIANTA                    NUMBER(6);
      D_SETP_SEQUENZA                  NUMBER(6);
      D_SETP_CODICE                   VARCHAR2(15);
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
      D_PEGI_POSIZIONE                VARCHAR2(4);
      D_POSI_SEQUENZA                  NUMBER(3);
      D_POSI_DI_RUOLO                  NUMBER(1);
      D_PEGI_TIPO_RAPPORTO            VARCHAR2(2);
      D_PEGI_ORE                       NUMBER(5,2);
      D_CADO_PREVISTI                  NUMBER(5);
      D_CADO_ORE_PREVISTI              NUMBER(5,2);
      D_CADO_IN_PIANTA                 NUMBER(5);
      D_CADO_IN_DEROGA                 NUMBER(5);
      D_CADO_IN_SOVRANNUMERO           NUMBER(5);
      D_CADO_IN_RILASCIO               NUMBER(5);
      D_CADO_IN_ISTITUZIONE            NUMBER(5);
      D_CADO_IN_ACQUISIZIONE           NUMBER(5);
      D_CADO_ASS_RUOLO_L1              NUMBER(5);
      D_CADO_ORE_ASS_RUOLO_L1          NUMBER(5,2);
      D_CADO_ASS_RUOLO_L2              NUMBER(5);
      D_CADO_ORE_ASS_RUOLO_L2          NUMBER(5,2);
      D_CADO_ASS_RUOLO_L3              NUMBER(5);
      D_CADO_ORE_ASS_RUOLO_L3          NUMBER(5,2);
      D_CADO_ASS_RUOLO                 NUMBER(5);
      D_CADO_ORE_ASS_RUOLO             NUMBER(5,2);
      D_CADO_ASSEGNAZIONI              NUMBER(5);
      D_CADO_ORE_ASSEGNAZIONI          NUMBER(5,2);
      D_CADO_ASSENZE_INCARICO          NUMBER(5);
      D_CADO_ASSENZE_ASSENZA           NUMBER(5);
      D_CADO_DISPONIBILI               NUMBER(5);
      D_CADO_ORE_DISPONIBILI           NUMBER(5,2);
      D_CADO_COPERTI_RUOLO_1           NUMBER(5);
      D_CADO_ORE_COPERTI_RUOLO_1       NUMBER(5,2);
      D_CADO_COPERTI_RUOLO_2           NUMBER(5);
      D_CADO_ORE_COPERTI_RUOLO_2       NUMBER(5,2);
      D_CADO_COPERTI_RUOLO_3           NUMBER(5);
      D_CADO_ORE_COPERTI_RUOLO_3       NUMBER(5,2);
      D_CADO_COPERTI_RUOLO             NUMBER(5);
      D_CADO_ORE_COPERTI_RUOLO         NUMBER(5,2);
      D_CADO_COPERTI_NO_RUOLO          NUMBER(5);
      D_CADO_ORE_COPERTI_NO_RUOLO      NUMBER(5,2);
      D_CADO_VACANTI                   NUMBER(5);
      D_CADO_ORE_VACANTI               NUMBER(5,2);
      D_CADO_VACANTI_COPERTI           NUMBER(5);
      D_CADO_ORE_VACANTI_COPERTI       NUMBER(5,2);
      D_CADO_VACANTI_NON_COPERTI       NUMBER(5);
      D_CADO_ORE_VACANTI_NON_COPERTI   NUMBER(5,2);
      D_CADO_VACANTI_NON_RICOPRIBILI   NUMBER(5);
      D_CADO_SOST_TITOLARI             NUMBER(5);
      D_CADO_ORE_SOST_TITOLARI         NUMBER(5,2);
      NORE                             NUMBER(5,2);
      NORE_1                           NUMBER(5,2);
      NORE_2                           NUMBER(5,2);
      NORE_3                           NUMBER(5,2);
      CURSOR POSTI IS
      SELECT P.SEDE_POSTO,P.ANNO_POSTO,P.NUMERO_POSTO,P.POSTO,P.DAL,P.GRUPPO,
             P.STATO,P.SITUAZIONE,NVL(P.DISPONIBILITA,'N'),P.PIANTA,P.SETTORE,
             P.FIGURA,P.ATTIVITA,P.ORE
        FROM POSTI_PIANTA P
       WHERE D_RIOR_DATA             BETWEEN NVL(P.DAL,TO_DATE('2222222','J'))
                                         AND NVL(P.AL ,TO_DATE('3333333','J'))
         AND (    P.STATO            IN ('T','I','C')
              OR  P.STATO             = 'A'
              AND P.SITUAZIONE        = 'R'
              OR  P.SITUAZIONE       IN ('I','A')
             )
         AND EXISTS
             (SELECT 1
                FROM SETTORI S, GESTIONI G
               WHERE S.NUMERO         = P.SETTORE
                 AND G.CODICE         = S.GESTIONE
                 AND G.GESTITO        = 'SI'
                 AND NVL(G.PROSPETTO_PO,' ')
                                     <> 'N'
             )
      ;
      BEGIN
        BEGIN
           SELECT DATA
             INTO D_RIOR_DATA
             FROM RIFERIMENTO_ORGANICO
           ;
        END;
        OPEN POSTI;
        LOOP
          FETCH POSTI INTO D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
                           D_POPI_NUMERO_POSTO,D_POPI_POSTO,D_POPI_DAL,
                           D_POPI_GRUPPO,
                           D_POPI_STATO,D_POPI_SITUAZIONE,D_POPI_RICOPRIBILE,
                           D_POPI_PIANTA,D_POPI_SETTORE,D_POPI_FIGURA,
                           D_POPI_ATTIVITA,D_POPI_ORE;
          EXIT  WHEN POSTI%NOTFOUND;
          BEGIN
             SELECT NVL(SEQUENZA,999999),CODICE
               INTO D_SETP_SEQUENZA,D_SETP_CODICE
               FROM SETTORI
              WHERE NUMERO = D_POPI_PIANTA
             ;
          END;
          BEGIN
             SELECT NVL(S.SEQUENZA,999999),S.CODICE,S.SUDDIVISIONE,S.GESTIONE,
                    G.PROSPETTO_PO,NVL(G.SINTETICO_PO,G.PROSPETTO_PO),
                    S.SETTORE_G,S.SETTORE_A,
                    S.SETTORE_B,S.SETTORE_C,G.SINTETICO_PO
               INTO D_SETT_SEQUENZA,D_SETT_CODICE,D_SETT_SUDDIVISIONE,
                    D_SETT_GESTIONE,D_GEST_PROSPETTO_PO,D_GEST_SINTETICO_PO,
                    D_SETT_SETTORE_G,D_SETT_SETTORE_A,
                    D_SETT_SETTORE_B,D_SETT_SETTORE_C,D_GEST_SINTETICO_PO
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
                   QG.CONTRATTO,CS.DAL,NVL(CO.SEQUENZA,999),CS.ORE_LAVORO,
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
                   D_FIGI_QUALIFICA,D_QUGI_DAL,D_QUAL_SEQUENZA,D_QUGI_CODICE,
                   D_QUGI_CONTRATTO,D_COST_DAL,D_CONT_SEQUENZA,
                   D_COST_ORE_LAVORO,D_QUGI_LIVELLO,D_QUGI_RUOLO,
                   D_RUOL_SEQUENZA,D_FIGI_PROFILO,D_PRPR_SEQUENZA,
                   D_PRPR_SUDDIVISIONE_PO,D_FIGI_POSIZIONE,D_POFU_SEQUENZA
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
      --  QUALIFICAZIONE DEL POSTO.
      --
          D_CADO_PREVISTI          := 0;
          D_CADO_IN_PIANTA         := 0;
          D_CADO_IN_DEROGA         := 0;
          D_CADO_IN_SOVRANNUMERO   := 0;
          D_CADO_IN_ACQUISIZIONE   := 0;
          D_CADO_IN_RILASCIO       := 0;
          D_CADO_IN_ISTITUZIONE    := 0;
          D_CADO_ORE_PREVISTI      := NVL(D_POPI_ORE,D_COST_ORE_LAVORO);
          IF    D_POPI_SITUAZIONE           = 'I' THEN
                D_CADO_IN_ISTITUZIONE      := 1;
          ELSIF D_POPI_SITUAZIONE           = 'A' THEN
                D_CADO_IN_ACQUISIZIONE     := 1;
          ELSIF D_POPI_SITUAZIONE           = 'R' THEN
                D_CADO_IN_RILASCIO         := 1;
                D_CADO_PREVISTI            := 1;
          ELSIF D_POPI_SITUAZIONE           = 'S' THEN
                D_CADO_IN_SOVRANNUMERO     := 1;
                D_CADO_PREVISTI            := 1;
          ELSIF D_POPI_SITUAZIONE           = 'D' THEN
                D_CADO_IN_DEROGA           := 1;
                D_CADO_PREVISTI            := 1;
          ELSE
                D_CADO_IN_PIANTA           := 1;
                D_CADO_PREVISTI            := 1;
          END IF;
          D_CADO_ASS_RUOLO_L1              := 0;
          D_CADO_ORE_ASS_RUOLO_L1          := 0;
          D_CADO_ASS_RUOLO_L2              := 0;
          D_CADO_ORE_ASS_RUOLO_L2          := 0;
          D_CADO_ASS_RUOLO_L3              := 0;
          D_CADO_ORE_ASS_RUOLO_L3          := 0;
          D_CADO_ASS_RUOLO                 := 0;
          D_CADO_ORE_ASS_RUOLO             := 0;
          D_CADO_DISPONIBILI               := 0;
          D_CADO_ORE_DISPONIBILI           := 0;
          D_CADO_COPERTI_RUOLO_1           := 0;
          D_CADO_ORE_COPERTI_RUOLO_1       := 0;
          D_CADO_COPERTI_RUOLO_2           := 0;
          D_CADO_ORE_COPERTI_RUOLO_2       := 0;
          D_CADO_COPERTI_RUOLO_3           := 0;
          D_CADO_ORE_COPERTI_RUOLO_3       := 0;
          D_CADO_COPERTI_RUOLO             := 0;
          D_CADO_ORE_COPERTI_RUOLO         := 0;
          D_CADO_COPERTI_NO_RUOLO          := 0;
          D_CADO_ORE_COPERTI_NO_RUOLO      := 0;
          D_CADO_VACANTI                   := 0;
          D_CADO_ORE_VACANTI               := 0;
          D_CADO_VACANTI_COPERTI           := 0;
          D_CADO_ORE_VACANTI_COPERTI       := 0;
          D_CADO_VACANTI_NON_COPERTI       := 0;
          D_CADO_ORE_VACANTI_NON_COPERTI   := 0;
          D_CADO_VACANTI_NON_RICOPRIBILI   := 0;
          D_CADO_SOST_TITOLARI             := 0;
          D_CADO_ORE_SOST_TITOLARI         := 0;
      --
      --  RICOPRIBILITA` DEL POSTO.
      --
          IF D_POPI_RICOPRIBILE      = 'N' THEN
             IF D_POPI_SITUAZIONE    = 'I'
             OR D_POPI_SITUAZIONE    = 'A' THEN
                NULL;
             ELSE
                D_CADO_VACANTI_NON_RICOPRIBILI  := 1;
             END IF;
          ELSE
      --
      --  COPERTURA DI TITOLARE.
      --
            BEGIN
              SELECT NVL(SUM(NVL(PG.ORE,D_CADO_ORE_PREVISTI)),0)
                    ,NVL(SUM(DECODE(NVL(AN.GRUPPO_LING,'I')
                                   ,SUBSTR(P_LINGUE,1,1)
                                   ,NVL(PG.ORE,D_CADO_ORE_PREVISTI)
                                   ,0
                            )),0)
                    ,NVL(SUM(DECODE(NVL(AN.GRUPPO_LING,'I')
                                   ,SUBSTR(P_LINGUE,2,1)
                                   ,NVL(PG.ORE,D_CADO_ORE_PREVISTI)
                                   ,0
                            )),0)
                    ,NVL(SUM(DECODE(NVL(AN.GRUPPO_LING,'I')
                                   ,SUBSTR(P_LINGUE,3,1)
                                   ,NVL(PG.ORE,D_CADO_ORE_PREVISTI)
                                   ,0
                            )),0)
                INTO NORE,NORE_1,NORE_2,NORE_3
                FROM ANAGRAFICI           AN
                    ,RAPPORTI_INDIVIDUALI RI
                    ,POSIZIONI            PO
                    ,PERIODI_GIURIDICI    PG
               WHERE D_RIOR_DATA  BETWEEN PG.DAL
                                  AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PG.RILEVANZA       = 'Q'
                 AND PG.SEDE_POSTO      = D_POPI_SEDE_POSTO
                 AND PG.ANNO_POSTO      = D_POPI_ANNO_POSTO
                 AND PG.NUMERO_POSTO    = D_POPI_NUMERO_POSTO
                 AND PG.POSTO           = D_POPI_POSTO
                 AND PO.CODICE          = PG.POSIZIONE
                 AND PO.RUOLO           = 'SI'
                 AND D_RIOR_DATA  BETWEEN NVL(AN.DAL,TO_DATE('2222222','J'))
                                      AND NVL(AN.AL ,TO_DATE('3333333','J'))
                 AND AN.NI              = RI.NI
                 AND RI.CI              = PG.CI
                 AND NOT EXISTS
                     (SELECT 1
                        FROM PERIODI_GIURIDICI P2
                       WHERE D_RIOR_DATA BETWEEN P2.DAL
                                         AND NVL(P2.AL,TO_DATE('3333333','J'))
                         AND P2.CI       = PG.CI
                         AND (    P2.RILEVANZA = 'I'
                              AND P2.ROWID    <> PG.ROWID
                              OR  P2.RILEVANZA = 'A'
                              AND EXISTS
                                  (SELECT 1
                                     FROM ASTENSIONI AA
                                    WHERE AA.CODICE       = P2.ASSENZA
                                      AND AA.SOSTITUIBILE = 1
                                  )
                             )
                     )
              ;
            END;
            IF NORE_1 <> 0 THEN
               D_CADO_COPERTI_RUOLO_1       := 1;
               D_CADO_ORE_COPERTI_RUOLO_1   := NORE_1;
            END IF;
            IF NORE_2 <> 0 THEN
               D_CADO_COPERTI_RUOLO_2       := 1;
               D_CADO_ORE_COPERTI_RUOLO_2   := NORE_2;
            END IF;
            IF NORE_3 <> 0 THEN
               D_CADO_COPERTI_RUOLO_3       := 1;
               D_CADO_ORE_COPERTI_RUOLO_3   := NORE_3;
            END IF;
            IF NORE <> 0 THEN
               D_CADO_COPERTI_RUOLO         := 1;
               D_CADO_ORE_COPERTI_RUOLO     := NORE;
            END IF;
      --
      --  COPERTURA NON DI TITOLARE.
      --
            BEGIN
              SELECT NVL(SUM(NVL(PG.ORE,D_CADO_ORE_PREVISTI)),0)
                INTO NORE
                FROM POSIZIONI            PO
                    ,PERIODI_GIURIDICI    PG
               WHERE D_RIOR_DATA  BETWEEN PG.DAL
                                  AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND (    PG.RILEVANZA  = 'Q'
                      AND NVL(PO.RUOLO,'NO')
                                       <> 'SI'
                      OR  PG.RILEVANZA  = 'I'
                     )
                 AND PG.SEDE_POSTO      = D_POPI_SEDE_POSTO
                 AND PG.ANNO_POSTO      = D_POPI_ANNO_POSTO
                 AND PG.NUMERO_POSTO    = D_POPI_NUMERO_POSTO
                 AND PG.POSTO           = D_POPI_POSTO
                 AND PO.CODICE          = PG.POSIZIONE
                 AND NOT EXISTS
                     (SELECT 1
                        FROM PERIODI_GIURIDICI P2
                       WHERE D_RIOR_DATA BETWEEN P2.DAL
                                         AND NVL(P2.AL,TO_DATE('3333333','J'))
                         AND P2.CI       = PG.CI
                         AND (    P2.RILEVANZA = 'I'
                              AND P2.ROWID    <> PG.ROWID
                              OR  P2.RILEVANZA = 'A'
                              AND EXISTS
                                  (SELECT 1
                                     FROM ASTENSIONI AA
                                    WHERE AA.CODICE       = P2.ASSENZA
                                      AND AA.SOSTITUIBILE = 1
                                  )
                             )
                     )
              ;
            END;
            IF NORE <> 0 THEN
               D_CADO_COPERTI_NO_RUOLO      := 1;
               D_CADO_ORE_COPERTI_NO_RUOLO  := NORE;
            END IF;
      --
      -- ORE DI ASSEGNAZIONE DI TITOLARI.
      --
            BEGIN
              SELECT NVL(SUM(NVL(PG.ORE,D_CADO_ORE_PREVISTI)),0)
                    ,NVL(SUM(DECODE(NVL(AN.GRUPPO_LING,'I')
                                   ,SUBSTR(P_LINGUE,1,1)
                                   ,NVL(PG.ORE,D_CADO_ORE_PREVISTI)
                                   ,0
                            )),0)
                    ,NVL(SUM(DECODE(NVL(AN.GRUPPO_LING,'I')
                                   ,SUBSTR(P_LINGUE,2,1)
                                   ,NVL(PG.ORE,D_CADO_ORE_PREVISTI)
                                   ,0
                            )),0)
                    ,NVL(SUM(DECODE(NVL(AN.GRUPPO_LING,'I')
                                   ,SUBSTR(P_LINGUE,3,1)
                                   ,NVL(PG.ORE,D_CADO_ORE_PREVISTI)
                                   ,0
                            )),0)
                INTO NORE,NORE_1,NORE_2,NORE_3
                FROM POSIZIONI             PO
                    ,RAPPORTI_INDIVIDUALI  RI
                    ,ANAGRAFICI            AN
                    ,PERIODI_GIURIDICI     PG
               WHERE D_RIOR_DATA   BETWEEN PG.DAL
                                       AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND D_RIOR_DATA   BETWEEN AN.DAL
                                       AND NVL(AN.AL,TO_DATE('3333333','J'))
                 AND AN.NI               = RI.NI
                 AND RI.CI               = PG.CI
                 AND PG.RILEVANZA        = 'Q'
                 AND PO.CODICE           = PG.POSIZIONE
                 AND PO.RUOLO            = 'SI'
                 AND PG.SEDE_POSTO       = D_POPI_SEDE_POSTO
                 AND PG.ANNO_POSTO       = D_POPI_ANNO_POSTO
                 AND PG.NUMERO_POSTO     = D_POPI_NUMERO_POSTO
                 AND PG.POSTO            = D_POPI_POSTO
              ;
            END;
            IF NORE_1 > 0 THEN
               D_CADO_ORE_ASS_RUOLO_L1  := NORE_1;
               D_CADO_ASS_RUOLO_L1      := 1;
            END IF;
            IF NORE_2 > 0 THEN
               D_CADO_ORE_ASS_RUOLO_L2  := NORE_2;
               D_CADO_ASS_RUOLO_L2      := 1;
            END IF;
            IF NORE_3 > 0 THEN
               D_CADO_ORE_ASS_RUOLO_L3  := NORE_3;
               D_CADO_ASS_RUOLO_L3      := 1;
            END IF;
            IF NORE > 0 THEN
               D_CADO_ORE_ASS_RUOLO     := NORE;
               D_CADO_ASS_RUOLO         := 1;
            END IF;
      --
      --  ORE DI COPERTURA O DI SOSTITUZIONE DI TITOLARI
      --  OVVERO CON SOSTITUITO INQUADRATO IN RUOLO.
      --
            BEGIN
              SELECT NVL(SUM(NVL(PG.ORE,D_CADO_ORE_PREVISTI)),0)
                INTO NORE_3
                FROM POSIZIONI         PO
                    ,PERIODI_GIURIDICI P2
                    ,PERIODI_GIURIDICI PG
               WHERE D_RIOR_DATA  BETWEEN P2.DAL
                                      AND NVL(P2.AL,TO_DATE('3333333','J'))
                 AND D_RIOR_DATA  BETWEEN PG.DAL
                                      AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PO.CODICE          = P2.POSIZIONE
                 AND PO.RUOLO           = 'SI'
                 AND P2.RILEVANZA       = 'Q'
                 AND PG.RILEVANZA      IN ('Q','I')
                 AND PG.SEDE_POSTO      = D_POPI_SEDE_POSTO
                 AND PG.ANNO_POSTO      = D_POPI_ANNO_POSTO
                 AND PG.NUMERO_POSTO    = D_POPI_NUMERO_POSTO
                 AND PG.POSTO           = D_POPI_POSTO
                 AND P2.SEDE_POSTO      = PG.SEDE_POSTO
                 AND P2.ANNO_POSTO      = PG.ANNO_POSTO
                 AND P2.NUMERO_POSTO    = PG.NUMERO_POSTO
                 AND P2.POSTO           = PG.POSTO
                 AND P2.CI              = PG.SOSTITUTO
                 AND NOT EXISTS
                     (SELECT 1
                        FROM PERIODI_GIURIDICI P3
                       WHERE D_RIOR_DATA BETWEEN P3.DAL
                                         AND NVL(P3.AL,TO_DATE('3333333','J'))
                         AND P3.CI             = PG.CI
                         AND (    P3.RILEVANZA = 'I'
                              AND P3.ROWID    <> PG.ROWID
                              OR  P3.RILEVANZA = 'A'
                              AND EXISTS
                                  (SELECT 1
                                     FROM ASTENSIONI AA
                                    WHERE AA.SOSTITUIBILE = 1
                                      AND AA.CODICE       = P3.ASSENZA
                                  )
                             )
                     )
              ;
            END;
            IF NORE_3 > 0 THEN
               D_CADO_SOST_TITOLARI     := 1;
               D_CADO_ORE_SOST_TITOLARI := NORE_3;
            END IF;
      --
      --  DISPONIBILITA` = ORE PREVISTI - ORE DI COPERTURA DI RUOLO E N/RUOLO.
      --
            BEGIN
              IF (D_CADO_ORE_PREVISTI - D_CADO_ORE_COPERTI_RUOLO
                                      - D_CADO_ORE_COPERTI_NO_RUOLO) <> 0 THEN
                 D_CADO_DISPONIBILI       := 1;
                 D_CADO_ORE_DISPONIBILI   := D_CADO_ORE_PREVISTI -
                                             D_CADO_ORE_COPERTI_RUOLO -
                                             D_CADO_ORE_COPERTI_NO_RUOLO;
              END IF;
            END;
      --
      --  ORE VACANTI = ORE POSTO - ORE ASSEGNATE A TITOLARI.
      --
            BEGIN
              IF (D_CADO_ORE_PREVISTI - D_CADO_ORE_ASS_RUOLO) > 0 THEN
                 D_CADO_ORE_VACANTI     := D_CADO_ORE_PREVISTI -
                                           D_CADO_ORE_ASS_RUOLO;
                 D_CADO_VACANTI         := 1;
              END IF;
            END;
      --
      --  VACANTI COPERTI OVVERO COPERTURE NON DI RUOLO CHE NON SONO
      --  SOSTITUZIONI DI TITOLARI.
      --
            BEGIN
              SELECT NVL(SUM(NVL(PG.ORE,D_CADO_ORE_PREVISTI)),0)
                INTO NORE_3
                FROM POSIZIONI         PO
                    ,PERIODI_GIURIDICI PG
               WHERE D_RIOR_DATA  BETWEEN PG.DAL
                                      AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PO.CODICE          = PG.POSIZIONE
                 AND (    PG.RILEVANZA  = 'Q'
                      AND NVL(PO.RUOLO,'NO')
                                       <> 'SI'
                      OR  PG.RILEVANZA  = 'I'
                     )
                 AND (    NVL(PG.SOSTITUTO,PG.CI)
                                        = PG.CI
                      OR  NOT EXISTS
                          (SELECT 1
                             FROM PERIODI_GIURIDICI P3
                            WHERE D_RIOR_DATA BETWEEN P3.DAL AND
                                              NVL(P3.AL,TO_DATE('3333333','J'))
                              AND P3.POSIZIONE   IN (SELECT PS.CODICE
                                                       FROM POSIZIONI PS
                                                      WHERE PS.RUOLO = 'SI'
                                                    )
                              AND P3.RILEVANZA    = 'Q'
                              AND P3.CI           = PG.SOSTITUTO
                              AND P3.SEDE_POSTO   = D_POPI_SEDE_POSTO
                              AND P3.ANNO_POSTO   = D_POPI_ANNO_POSTO
                              AND P3.NUMERO_POSTO = D_POPI_NUMERO_POSTO
                              AND P3.POSTO        = D_POPI_POSTO
                          )
                     )
                 AND PG.SEDE_POSTO      = D_POPI_SEDE_POSTO
                 AND PG.ANNO_POSTO      = D_POPI_ANNO_POSTO
                 AND PG.NUMERO_POSTO    = D_POPI_NUMERO_POSTO
                 AND PG.POSTO           = D_POPI_POSTO
                 AND NOT EXISTS
                     (SELECT 1
                        FROM PERIODI_GIURIDICI P3
                       WHERE D_RIOR_DATA BETWEEN P3.DAL
                                         AND NVL(P3.AL,TO_DATE('3333333','J'))
                         AND P3.CI             = PG.CI
                         AND (    P3.RILEVANZA = 'I'
                              AND P3.ROWID    <> PG.ROWID
                              OR  P3.RILEVANZA = 'A'
                              AND EXISTS
                                  (SELECT 1
                                     FROM ASTENSIONI AA
                                    WHERE AA.SOSTITUIBILE = 1
                                      AND AA.CODICE       = P3.ASSENZA
                                  )
                             )
                     )
              ;
            END;
            IF NORE_3 > 0 THEN
               D_CADO_VACANTI_COPERTI      := 1;
               D_CADO_ORE_VACANTI_COPERTI  := NORE_3;
            END IF;
      --
      --  SE LE ORE DI SOSTITUZIONE DI TITOLARI SUPERANO LE ORE DI ASSEGNAZIONE
      --  DEI MEDESIMI, LA DIFFERENZA VA AD INCREMENTARE I VACANTI COPERTI.
      --
           IF (D_CADO_ORE_COPERTI_RUOLO + D_CADO_ORE_SOST_TITOLARI) >
              D_CADO_ORE_ASS_RUOLO THEN
              D_CADO_ORE_VACANTI_COPERTI := D_CADO_ORE_VACANTI_COPERTI +
                                            D_CADO_ORE_COPERTI_RUOLO   +
                                            D_CADO_ORE_SOST_TITOLARI   -
                                            D_CADO_ORE_ASS_RUOLO;
           END IF;
           IF D_CADO_ORE_VACANTI_COPERTI  > 0 THEN
              D_CADO_VACANTI_COPERTI := 1;
           END IF;
      --
      --  VACANTI NON COPERTI OVVERO VACANTI - VACANTI COPERTI.
      --  SE I VACANTI COPERTI SUPERANO I VACANTI, SI PONGONO
      --  I VACANTI COPERTI = AI VACANTI ED I VACANTI NON COPERTI = ZERO.
      --
            BEGIN
              IF (D_CADO_ORE_VACANTI - D_CADO_ORE_VACANTI_COPERTI) < 0 THEN
                 D_CADO_ORE_VACANTI_COPERTI      := D_CADO_ORE_VACANTI;
                 IF D_CADO_ORE_VACANTI_COPERTI = 0 THEN
                    D_CADO_VACANTI_COPERTI       := 0;
                 END IF;
              ELSIF (D_CADO_ORE_VACANTI - D_CADO_ORE_VACANTI_COPERTI) > 0 THEN
                 D_CADO_VACANTI_NON_COPERTI      := 1;
                 D_CADO_ORE_VACANTI_NON_COPERTI  := D_CADO_ORE_VACANTI -
                                                    D_CADO_ORE_VACANTI_COPERTI;
              END IF;
            END;
          END IF;
      --
      --  INSERIMENTO REGISTRAZIONI POSTO.
      --
          BEGIN
             IF D_CADO_PREVISTI + D_CADO_IN_PIANTA + D_CADO_IN_DEROGA +
                D_CADO_IN_SOVRANNUMERO + D_CADO_IN_RILASCIO +
                D_CADO_IN_ACQUISIZIONE + D_CADO_IN_ISTITUZIONE +
                D_CADO_ASS_RUOLO + D_CADO_VACANTI + D_CADO_VACANTI_COPERTI
                                        > 0 THEN
               INSERT INTO CALCOLO_DOTAZIONE
               (CADO_PRENOTAZIONE,CADO_RILEVANZA,CADO_LINGUE,
                RIOR_DATA,POPI_SEDE_POSTO,
                POPI_ANNO_POSTO,POPI_NUMERO_POSTO,POPI_POSTO,POPI_DAL,
                POPI_RICOPRIBILE,POPI_GRUPPO,
                POPI_PIANTA,SETP_SEQUENZA,SETP_CODICE,POPI_SETTORE,
                SETT_SEQUENZA,SETT_CODICE,SETT_SUDDIVISIONE,SETT_SETTORE_G,
                SETG_SEQUENZA,SETG_CODICE,SETT_SETTORE_A,SETA_SEQUENZA,
                SETA_CODICE,SETT_SETTORE_B,SETB_SEQUENZA,SETB_CODICE,
                SETT_SETTORE_C,SETC_SEQUENZA,SETC_CODICE,SETT_GESTIONE,
                GEST_PROSPETTO_PO,GEST_SINTETICO_PO,
                POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,FIGI_CODICE,FIGI_QUALIFICA,
                QUGI_DAL,QUAL_SEQUENZA,QUGI_CODICE,QUGI_CONTRATTO,COST_DAL,
                CONT_SEQUENZA,COST_ORE_LAVORO,QUGI_LIVELLO,FIGI_PROFILO,
                PRPR_SEQUENZA,PRPR_SUDDIVISIONE_PO,
                FIGI_POSIZIONE,POFU_SEQUENZA,
                QUGI_RUOLO,RUOL_SEQUENZA,POPI_ATTIVITA,ATTI_SEQUENZA,
                PEGI_POSIZIONE,POSI_SEQUENZA,PEGI_TIPO_RAPPORTO,
                CADO_PREVISTI,CADO_ORE_PREVISTI,CADO_IN_PIANTA,CADO_IN_DEROGA,
                CADO_IN_SOVRANNUMERO,CADO_IN_RILASCIO,CADO_IN_ACQUISIZIONE,
                CADO_IN_ISTITUZIONE,CADO_ASSEGNAZIONI_RUOLO,
                CADO_ORE_ASSEGNAZIONI_RUOLO,CADO_VACANTI,CADO_ORE_VACANTI,
                CADO_VACANTI_COPERTI,CADO_ORE_VACANTI_COPERTI,
                CADO_COPERTI_RUOLO,CADO_ORE_COPERTI_RUOLO,
                CADO_COPERTI_NO_RUOLO,CADO_ORE_COPERTI_NO_RUOLO)
               VALUES
               (W_PRENOTAZIONE,1,P_LINGUE,D_RIOR_DATA,D_POPI_SEDE_POSTO,
                D_POPI_ANNO_POSTO,D_POPI_NUMERO_POSTO,D_POPI_POSTO,D_POPI_DAL,
                D_POPI_RICOPRIBILE,D_POPI_GRUPPO,D_POPI_PIANTA,
                D_SETP_SEQUENZA,D_SETP_CODICE,D_POPI_SETTORE,
                D_SETT_SEQUENZA,D_SETT_CODICE,
                D_SETT_SUDDIVISIONE,D_SETT_SETTORE_G,
                D_SETG_SEQUENZA,D_SETG_CODICE,D_SETT_SETTORE_A,D_SETA_SEQUENZA,
                D_SETA_CODICE,D_SETT_SETTORE_B,D_SETB_SEQUENZA,D_SETB_CODICE,
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
                D_QUGI_RUOLO,D_RUOL_SEQUENZA,D_POPI_ATTIVITA,D_ATTI_SEQUENZA,
                NULL,0,NULL,
                D_CADO_PREVISTI,D_CADO_ORE_PREVISTI,
                D_CADO_IN_PIANTA,D_CADO_IN_DEROGA,
                D_CADO_IN_SOVRANNUMERO,D_CADO_IN_RILASCIO,
                D_CADO_IN_ACQUISIZIONE,D_CADO_IN_ISTITUZIONE,
                D_CADO_ASS_RUOLO,D_CADO_ORE_ASS_RUOLO,
                D_CADO_VACANTI,D_CADO_ORE_VACANTI,
                D_CADO_VACANTI_COPERTI,D_CADO_ORE_VACANTI_COPERTI,
                0,0,0,0
                )
               ;
             END IF;
          END;
        END LOOP;
        CLOSE POSTI;
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
PPOCSOOR2.DELETE_TAB(w_PRENOTAZIONE,W_VOCE_menu);
SEQ_LINGUA;
CC_POSTI;
PPOCSOOR2.CC_DOTAZIONE(P_D_F,P_USO_INTERNO,W_PRENOTAZIONE,P_LINGUE,P_VOCE_MENU);
PPOCSOOR3.CC_NOMINATIVO(P_D_F,P_USO_INTERNO,W_PRENOTAZIONE,P_LINGUE,P_VOCE_MENU);
            RAGGR_POSTI;
PPOCSOOR2.DEL_DETT_POSTI(w_PRENOTAZIONE,W_VOCE_menu);
            COMMIT;
	 exception when form_trigger_failure then
		raise;
         END;
      END;
 PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER) IS
  BEGIN
    ERRORE := to_char(null);
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
                 SELECT SUBSTR(PARA.VALORE,1,8)
                   INTO P_VOCE_MENU
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_VOCE_MENU'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_VOCE_MENU := ' ';
               END;
               BEGIN
                 SELECT to_number(SUBSTR(PARA.VALORE,1,1))
                   INTO P_LIVELLO
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_APPR_LIVELLO'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_LIVELLO := 1;
               END;
               BEGIN
                 SELECT SUBSTR(PARA.VALORE,1,1)
                   INTO P_D_F
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_DF'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_D_F := 'D';
               END;
               BEGIN
                 SELECT SUBSTR(PARA.VALORE,1,1)
                   INTO P_USO_INTERNO
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_USO_INTERNO'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_USO_INTERNO := 'X';
               END;
               W_PRENOTAZIONE := PRENOTAZIONE;
               -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
               -- VIENE RIAZZERATO IN FORM CHIAMANTE PER EVITARE TRASACTION COMPLETED
               CALCOLO;  -- ESECUZIONE DEL CALCOLO POSTI
               IF W_PRENOTAZIONE != 0 THEN
                  IF SUBSTR(ERRORE,6,1) = '8' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE = 'P05808'
                      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                     ;
                     COMMIT;
                  ELSIF
                     SUBSTR(ERRORE,6,1) = '9' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE       = 'P05809'
                          , PROSSIMO_PASSO = 91
                      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                     ;
                     COMMIT;
                  END IF;
               END IF;
            EXCEPTION
	       when form_trigger_failure then
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

