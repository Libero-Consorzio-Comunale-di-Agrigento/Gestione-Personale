CREATE OR REPLACE PACKAGE PPOCSIDF IS
/******************************************************************************
 NOME:          PPOCSIDF
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

CREATE OR REPLACE PACKAGE BODY PPOCSIDF IS
form_trigger_failure	exception;
	W_UTENTE	VARCHAR2(10);
	W_AMBIENTE	VARCHAR2(10);
	W_ENTE		VARCHAR2(10);
	W_LINGUA	VARCHAR2(1);
	W_PRENOTAZIONE	NUMBER(10);
	w_voce_menu	varchar2(8);
	errore		varchar2(6);
	P_LIVELLO	NUMBER(1);
	p_lingue	VARCHAR2(3);
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
 -- PULIZIA TABELLA DI LAVORO
      PROCEDURE DELETE_TAB IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
        DELETE FROM CALCOLO_DOTAZIONE
         WHERE CADO_PRENOTAZIONE = W_PRENOTAZIONE;
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
      PROCEDURE DEL_DETT_POSTI IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
         DELETE FROM CALCOLO_DOTAZIONE
          WHERE CADO_PRENOTAZIONE    = w_PRENOTAZIONE
            AND CADO_RILEVANZA       < 6
         ;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := w_PRENOTAZIONE;
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
               WHERE GRUPPO  = W_LINGUA
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
       p_LINGUE := D_LINGUA_1||D_LINGUA_2||D_LINGUA_3;
      END;
     PROCEDURE RAGGR_POSTI IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
         INSERT INTO CALCOLO_DOTAZIONE
         (CADO_PRENOTAZIONE,CADO_RILEVANZA,RIOR_DATA,
          POPI_GRUPPO,POPI_SETTORE,SETT_SEQUENZA,SETT_CODICE,
          SETT_SUDDIVISIONE,SETT_SETTORE_G,
          SETG_SEQUENZA,SETG_CODICE,SETT_GESTIONE,
          POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,FIGI_CODICE,
          POPI_ATTIVITA,ATTI_SEQUENZA,
          PEGI_SETTORE_COMPL,SETT_SEQUENZA_COMPL,SETT_CODICE_COMPL,
          PEGI_FIGURA_COMPL,FIGI_DAL_COMPL,FIGU_SEQUENZA_COMPL,
          FIGI_CODICE_COMPL,PEGI_ATTIVITA_COMPL,ATTI_SEQUENZA_COMPL,
          PEGI_ORE,PEGI_ORE_COMPL,
          PEGI_RILEVANZA,
          CADO_PREVISTI,CADO_ORE_PREVISTI,CADO_IN_PIANTA,CADO_IN_DEROGA,
          CADO_IN_SOVRANNUMERO,CADO_IN_RILASCIO,CADO_IN_ACQUISIZIONE,
          CADO_IN_ISTITUZIONE,
          CADO_COPERTI_RUOLO,CADO_COPERTI_NO_RUOLO,
          CADO_VACANTI_COPERTI,CADO_VACANTI_NON_COPERTI,
          CADO_VACANTI_NON_RICOPRIBILI
         )
      SELECT
          CADO_PRENOTAZIONE,CADO_RILEVANZA+5,MAX(RIOR_DATA),
          POPI_GRUPPO,POPI_SETTORE,
          MAX(SETT_SEQUENZA),MAX(SETT_CODICE),MAX(SETT_SUDDIVISIONE),
          MAX(SETT_SETTORE_G),MAX(SETG_SEQUENZA),MAX(SETG_CODICE),
          MAX(SETT_GESTIONE),
          POPI_FIGURA,MAX(FIGI_DAL),MAX(FIGU_SEQUENZA),
          MAX(FIGI_CODICE),
          POPI_ATTIVITA,MAX(ATTI_SEQUENZA),
          PEGI_SETTORE_COMPL,MAX(SETT_SEQUENZA_COMPL),
          MAX(SETT_CODICE_COMPL),PEGI_FIGURA_COMPL,MAX(FIGI_DAL_COMPL),
          MAX(FIGU_SEQUENZA_COMPL),MAX(FIGI_CODICE_COMPL),
          PEGI_ATTIVITA_COMPL,MAX(ATTI_SEQUENZA_COMPL),
          PEGI_ORE,PEGI_ORE_COMPL,
          PEGI_RILEVANZA,
          SUM(CADO_PREVISTI),CADO_ORE_PREVISTI,
          SUM(CADO_IN_PIANTA),SUM(CADO_IN_DEROGA),
          SUM(CADO_IN_SOVRANNUMERO),SUM(CADO_IN_RILASCIO),
          SUM(CADO_IN_ACQUISIZIONE),SUM(CADO_IN_ISTITUZIONE),
          SUM(CADO_COPERTI_RUOLO),SUM(CADO_COPERTI_NO_RUOLO),
          SUM(CADO_VACANTI_COPERTI),
          SUM(CADO_VACANTI_NON_COPERTI),SUM(CADO_VACANTI_NON_RICOPRIBILI)
        FROM CALCOLO_DOTAZIONE
       WHERE CADO_PRENOTAZIONE = W_PRENOTAZIONE
         AND CADO_RILEVANZA    < 6
       GROUP BY
          CADO_PRENOTAZIONE,CADO_RILEVANZA,POPI_GRUPPO,POPI_SETTORE,
          POPI_FIGURA,POPI_ATTIVITA,PEGI_SETTORE_COMPL,PEGI_FIGURA_COMPL,
          PEGI_ATTIVITA_COMPL,PEGI_RILEVANZA,PEGI_ORE,PEGI_ORE_COMPL,
          CADO_ORE_PREVISTI
      ;
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
      PROCEDURE CC_DOTAZIONE IS
      D_ERRTEXT                       VARCHAR2(240);
      D_PRENOTAZIONE                   NUMBER(6);
      D_CONTA_CURSORI                  NUMBER(1);
      D_RIOR_DATA                        DATE;
      D_PEGI_RILEVANZA                VARCHAR2(1);
      D_PEGI_ORE                       NUMBER(5,2);
      D_POPI_SEDE_POSTO               VARCHAR2(2);
      D_POPI_ANNO_POSTO                NUMBER(4);
      D_POPI_NUMERO_POSTO              NUMBER(7);
      D_POPI_POSTO                     NUMBER(5);
      D_POPI_GRUPPO                   VARCHAR2(12);
      D_POPI_ORE                       NUMBER(5,2);
      D_POPI_SETTORE                   NUMBER(6);
      D_SETT_GESTIONE                 VARCHAR2(4);
      D_SETT_SEQUENZA                  NUMBER(6);
      D_SETT_CODICE                   VARCHAR2(15);
      D_POPI_SETTORE_COMPL             NUMBER(6);
      D_SETT_SUDDIVISIONE              NUMBER(1);
      D_SETT_SEQUENZA_COMPL            NUMBER(6);
      D_SETT_CODICE_COMPL             VARCHAR2(15);
      D_SETT_SETTORE_G                 NUMBER(6);
      D_SETG_SEQUENZA                  NUMBER(6);
      D_SETG_CODICE                   VARCHAR2(15);
      D_POPI_FIGURA                    NUMBER(6);
      D_FIGI_DAL                         DATE;
      D_FIGU_SEQUENZA                  NUMBER(6);
      D_FIGI_CODICE                   VARCHAR2(8);
      D_PEGI_ORE_COMPL                 NUMBER(5,2);
      D_POPI_FIGURA_COMPL              NUMBER(6);
      D_FIGI_DAL_COMPL                   DATE;
      D_FIGU_SEQUENZA_COMPL            NUMBER(6);
      D_FIGI_CODICE_COMPL             VARCHAR2(8);
      D_FIGI_QUALIFICA                 NUMBER(6);
      D_FIGI_QUALIFICA_COMPL           NUMBER(6);
      D_COST_ORE_LAVORO                NUMBER(5,2);
      D_COST_ORE_LAVORO_COMPL          NUMBER(5,2);
      D_POPI_ATTIVITA                 VARCHAR2(4);
      D_ATTI_SEQUENZA                  NUMBER(6);
      D_POPI_ATTIVITA_COMPL           VARCHAR2(4);
      D_ATTI_SEQUENZA_COMPL            NUMBER(6);
      D_CADO_ORE_PREVISTI              NUMBER(5,2);
      D_CADO_PREVISTI                  NUMBER(5);
      D_CADO_IN_PIANTA                 NUMBER(5);
      D_CADO_IN_DEROGA                 NUMBER(5);
      D_CADO_IN_SOVRANNUMERO           NUMBER(5);
      D_CADO_IN_RILASCIO               NUMBER(5);
      D_CADO_IN_ACQUISIZIONE           NUMBER(5);
      D_CADO_IN_ISTITUZIONE            NUMBER(5);
      D_CADO_VACANTI_COPERTI           NUMBER(5);
      D_CADO_VACANTI_NON_COPERTI       NUMBER(5);
      D_CADO_VACANTI_NON_RICOPRIBILI   NUMBER(5);
      D_CADO_DOTAZIONI_RUOLO           NUMBER(5);
      D_CADO_DOTAZIONI_NO_RUOLO        NUMBER(5);
      CURSOR DIR_FAT IS
      SELECT PG.RILEVANZA
            ,PG.ORE
            ,PG.FIGURA
            ,NULL
            ,PG.ATTIVITA
            ,PG.SETTORE
            ,P2.ORE
            ,P2.FIGURA
            ,P2.QUALIFICA
            ,P2.ATTIVITA
            ,P2.SETTORE
            ,PG.SEDE_POSTO
            ,PG.ANNO_POSTO
            ,PG.NUMERO_POSTO
            ,PG.POSTO
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,1
            ,0
        FROM PERIODI_GIURIDICI      P2
            ,PERIODI_GIURIDICI      PG
       WHERE D_RIOR_DATA       BETWEEN PG.DAL
                               AND NVL(PG.AL,TO_DATE('3333333','J'))
         AND D_RIOR_DATA       BETWEEN P2.DAL
                               AND NVL(P2.AL,TO_DATE('3333333','J'))
         AND P2.CI             = PG.CI
         AND PG.RILEVANZA      = 'Q'
         AND PG.POSIZIONE     IN (SELECT PO.CODICE
                                    FROM POSIZIONI PO
                                   WHERE PO.RUOLO   = 'SI'
                                 )
         AND (    P2.RILEVANZA = 'E'
              OR  P2.RILEVANZA = 'S'
              AND NOT EXISTS
                  (SELECT 1
                     FROM PERIODI_GIURIDICI P3
                    WHERE D_RIOR_DATA  BETWEEN P3.DAL
                                       AND NVL(P3.AL,TO_DATE('3333333','J'))
                      AND P3.RILEVANZA = 'E'
                      AND P3.CI        = P2.CI
                  )
             )
         AND EXISTS
             (SELECT 1
                FROM SETTORI S, GESTIONI G
               WHERE S.NUMERO         = PG.SETTORE
                 AND G.CODICE         = S.GESTIONE
                 AND G.GESTITO        = 'SI'
                 AND NVL(G.PROSPETTO_PO,' ')
                                     <> 'N'
             )
      ;
      CURSOR DIR IS
      SELECT PG.RILEVANZA
            ,PG.ORE
            ,PG.FIGURA
            ,NULL
            ,PG.ATTIVITA
            ,PG.SETTORE
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,PG.SEDE_POSTO
            ,PG.ANNO_POSTO
            ,PG.NUMERO_POSTO
            ,PG.POSTO
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,1
            ,0
        FROM PERIODI_GIURIDICI      PG
       WHERE D_RIOR_DATA       BETWEEN PG.DAL
                               AND NVL(PG.AL,TO_DATE('3333333','J'))
         AND PG.RILEVANZA      = 'Q'
         AND PG.POSIZIONE     IN (SELECT PO.CODICE
                                    FROM POSIZIONI PO
                                   WHERE PO.RUOLO   = 'SI'
                                 )
         AND NOT EXISTS
             (SELECT 1
                FROM PERIODI_GIURIDICI P3
               WHERE D_RIOR_DATA  BETWEEN P3.DAL
                                  AND NVL(P3.AL,TO_DATE('3333333','J'))
                 AND P3.RILEVANZA IN ('S','E')
                 AND P3.CI        = PG.CI
             )
         AND EXISTS
             (SELECT 1
                FROM SETTORI S, GESTIONI G
               WHERE S.NUMERO         = PG.SETTORE
                 AND G.CODICE         = S.GESTIONE
                 AND G.GESTITO        = 'SI'
                 AND NVL(G.PROSPETTO_PO,' ')
                                     <> 'N'
             )
      ;
      CURSOR FAT_DIR IS
      SELECT PG.RILEVANZA
            ,PG.ORE
            ,PG.FIGURA
            ,PG.QUALIFICA
            ,PG.ATTIVITA
            ,PG.SETTORE
            ,P2.ORE
            ,P2.FIGURA
            ,NULL
            ,P2.ATTIVITA
            ,P2.SETTORE
            ,P2.SEDE_POSTO
            ,P2.ANNO_POSTO
            ,P2.NUMERO_POSTO
            ,P2.POSTO
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,1
        FROM PERIODI_GIURIDICI      P2
            ,PERIODI_GIURIDICI      PG
       WHERE D_RIOR_DATA       BETWEEN PG.DAL
                               AND NVL(PG.AL,TO_DATE('3333333','J'))
         AND D_RIOR_DATA       BETWEEN P2.DAL
                               AND NVL(P2.AL,TO_DATE('3333333','J'))
         AND P2.CI             = PG.CI
         AND P2.RILEVANZA      = 'Q'
         AND P2.POSIZIONE     IN (SELECT PO.CODICE
                                    FROM POSIZIONI PO
                                   WHERE PO.RUOLO   = 'SI'
                                 )
         AND (    PG.RILEVANZA = 'E'
              OR  PG.RILEVANZA = 'S'
              AND NOT EXISTS
                  (SELECT 1
                     FROM PERIODI_GIURIDICI P3
                    WHERE D_RIOR_DATA  BETWEEN P3.DAL
                                       AND NVL(P3.AL,TO_DATE('3333333','J'))
                      AND P3.RILEVANZA = 'E'
                      AND P3.CI        = PG.CI
                  )
             )
         AND EXISTS
             (SELECT 1
                FROM SETTORI S, GESTIONI G
               WHERE S.NUMERO         = PG.SETTORE
                 AND G.CODICE         = S.GESTIONE
                 AND G.GESTITO        = 'SI'
                 AND NVL(G.PROSPETTO_PO,' ')
                                     <> 'N'
             )
      ;
      CURSOR VACANTI IS
      SELECT 'C'
            ,PP.ORE
            ,PP.FIGURA
            ,NULL
            ,PP.ATTIVITA
            ,PP.SETTORE
            ,PP.ORE
            ,PP.FIGURA
            ,NULL
            ,PP.ATTIVITA
            ,PP.SETTORE
            ,PP.SEDE_POSTO
            ,PP.ANNO_POSTO
            ,PP.NUMERO_POSTO
            ,PP.POSTO
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,1
            ,0
            ,0
            ,0
            ,0
        FROM POSTI_PIANTA           PP
       WHERE D_RIOR_DATA       BETWEEN PP.DAL
                               AND NVL(PP.AL,TO_DATE('3333333','J'))
         AND (    PP.STATO           = 'A'
              AND PP.SITUAZIONE      = 'R'
              OR  PP.STATO          IN ('T','I','C')
             )
         AND NOT EXISTS
             (SELECT 1
                FROM PERIODI_GIURIDICI PG
               WHERE D_RIOR_DATA BETWEEN PG.DAL
                                 AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PG.RILEVANZA    = 'Q'
                 AND PG.POSIZIONE   IN (SELECT PS.CODICE
                                          FROM POSIZIONI PS
                                         WHERE PS.RUOLO  = 'SI'
                                       )
                 AND PG.SEDE_POSTO    = PP.SEDE_POSTO
                 AND PG.ANNO_POSTO    = PP.ANNO_POSTO
                 AND PG.NUMERO_POSTO  = PP.NUMERO_POSTO
                 AND PG.POSTO         = PP.POSTO
             )
         AND EXISTS
             (SELECT 1
                FROM PERIODI_GIURIDICI PG
               WHERE D_RIOR_DATA BETWEEN PG.DAL
                                 AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PG.RILEVANZA    IN ('Q','I')
                 AND PG.SEDE_POSTO    = PP.SEDE_POSTO
                 AND PG.ANNO_POSTO    = PP.ANNO_POSTO
                 AND PG.NUMERO_POSTO  = PP.NUMERO_POSTO
                 AND PG.POSTO         = PP.POSTO
                 AND NOT EXISTS
                     (SELECT 1
                        FROM PERIODI_GIURIDICI P2
                       WHERE D_RIOR_DATA BETWEEN PG.DAL
                                         AND NVL(PG.AL,TO_DATE('3333333','J'))
                         AND P2.ROWID     <> PG.ROWID
                         AND P2.CI         = PG.CI
                         AND (    P2.RILEVANZA = 'I'
                              OR  P2.RILEVANZA = 'A'
                              AND EXISTS
                                  (SELECT 1
                                     FROM ASTENSIONI A2
                                    WHERE A2.SOSTITUIBILE = 1
                                      AND A2.CODICE       = P2.ASSENZA
                                  )
                             )
                     )
             )
         AND EXISTS
             (SELECT 1
                FROM SETTORI S, GESTIONI G
               WHERE S.NUMERO         = PP.SETTORE
                 AND G.CODICE         = S.GESTIONE
                 AND G.GESTITO        = 'SI'
                 AND NVL(G.PROSPETTO_PO,' ')
                                     <> 'N'
             )
       UNION
      SELECT DECODE(PP.DISPONIBILITA,'R','R','N')
            ,PP.ORE
            ,PP.FIGURA
            ,NULL
            ,PP.ATTIVITA
            ,PP.SETTORE
            ,PP.ORE
            ,PP.FIGURA
            ,NULL
            ,PP.ATTIVITA
            ,PP.SETTORE
            ,PP.SEDE_POSTO
            ,PP.ANNO_POSTO
            ,PP.NUMERO_POSTO
            ,PP.POSTO
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,DECODE(PP.DISPONIBILITA,'R',1,0)
            ,DECODE(PP.DISPONIBILITA,'R',0,1)
            ,0
            ,0
        FROM POSTI_PIANTA           PP
       WHERE D_RIOR_DATA       BETWEEN PP.DAL
                               AND NVL(PP.AL,TO_DATE('3333333','J'))
         AND (    PP.STATO           = 'A'
              AND PP.SITUAZIONE      = 'R'
              OR  PP.STATO          IN ('T','I','C')
             )
         AND NOT EXISTS
             (SELECT 1
                FROM PERIODI_GIURIDICI PG
               WHERE D_RIOR_DATA BETWEEN PG.DAL
                                 AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PG.RILEVANZA    = 'Q'
                 AND PG.POSIZIONE   IN (SELECT PS.CODICE
                                          FROM POSIZIONI PS
                                         WHERE PS.RUOLO  = 'SI'
                                       )
                 AND PG.SEDE_POSTO    = PP.SEDE_POSTO
                 AND PG.ANNO_POSTO    = PP.ANNO_POSTO
                 AND PG.NUMERO_POSTO  = PP.NUMERO_POSTO
                 AND PG.POSTO         = PP.POSTO
             )
         AND NOT EXISTS
             (SELECT 1
                FROM PERIODI_GIURIDICI PG
               WHERE D_RIOR_DATA BETWEEN PG.DAL
                                 AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PG.RILEVANZA    IN ('Q','I')
                 AND PG.SEDE_POSTO    = PP.SEDE_POSTO
                 AND PG.ANNO_POSTO    = PP.ANNO_POSTO
                 AND PG.NUMERO_POSTO  = PP.NUMERO_POSTO
                 AND PG.POSTO         = PP.POSTO
                 AND NOT EXISTS
                     (SELECT 1
                        FROM PERIODI_GIURIDICI P2
                       WHERE D_RIOR_DATA BETWEEN PG.DAL
                                         AND NVL(PG.AL,TO_DATE('3333333','J'))
                         AND P2.ROWID     <> PG.ROWID
                         AND P2.CI         = PG.CI
                         AND (    P2.RILEVANZA = 'I'
                              OR  P2.RILEVANZA = 'A'
                              AND EXISTS
                                  (SELECT 1
                                     FROM ASTENSIONI A2
                                    WHERE A2.SOSTITUIBILE = 1
                                      AND A2.CODICE       = P2.ASSENZA
                                  )
                             )
                     )
             )
         AND EXISTS
             (SELECT 1
                FROM SETTORI S, GESTIONI G
               WHERE S.NUMERO         = PP.SETTORE
                 AND G.CODICE         = S.GESTIONE
                 AND G.GESTITO        = 'SI'
                 AND NVL(G.PROSPETTO_PO,' ')
                                     <> 'N'
             )
      ;
      CURSOR POSTI IS
      SELECT 'P'
            ,NULL
            ,PP.FIGURA
            ,NULL
            ,PP.ATTIVITA
            ,PP.SETTORE
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,PP.SEDE_POSTO
            ,PP.ANNO_POSTO
            ,PP.NUMERO_POSTO
            ,PP.POSTO
            ,DECODE(PP.SITUAZIONE,'A',0,'I',0,1)
            ,DECODE(PP.SITUAZIONE,'P',1,0)
            ,DECODE(PP.SITUAZIONE,'D',1,0)
            ,DECODE(PP.SITUAZIONE,'S',1,0)
            ,DECODE(PP.SITUAZIONE,'R',1,0)
            ,DECODE(PP.SITUAZIONE,'A',1,0)
            ,DECODE(PP.SITUAZIONE,'I',1,0)
            ,0
            ,0
            ,0
            ,0
            ,0
        FROM POSTI_PIANTA           PP
       WHERE D_RIOR_DATA       BETWEEN PP.DAL
                               AND NVL(PP.AL,TO_DATE('3333333','J'))
         AND (    PP.STATO           = 'A'
              AND PP.SITUAZIONE     IN ('R','I','A')
              OR  PP.STATO          IN ('T','I','C')
             )
         AND EXISTS
             (SELECT 1
                FROM SETTORI S, GESTIONI G
               WHERE S.NUMERO         = PP.SETTORE
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
        D_CONTA_CURSORI := 0;
        LOOP
        D_CONTA_CURSORI := D_CONTA_CURSORI + 1;
        IF D_CONTA_CURSORI > 5 THEN
           EXIT;
        END IF;
        IF D_CONTA_CURSORI = 1 THEN
           OPEN DIR_FAT;
        END IF;
        IF D_CONTA_CURSORI = 2 THEN
           OPEN DIR;
        END IF;
        IF D_CONTA_CURSORI = 3 THEN
           OPEN FAT_DIR;
        END IF;
        IF D_CONTA_CURSORI = 4 THEN
           OPEN VACANTI;
        END IF;
        IF D_CONTA_CURSORI = 5 THEN
           OPEN POSTI;
        END IF;
        LOOP
           IF D_CONTA_CURSORI = 1 THEN
              FETCH DIR_FAT INTO D_PEGI_RILEVANZA,
              D_PEGI_ORE,D_POPI_FIGURA,D_FIGI_QUALIFICA,
              D_POPI_ATTIVITA,D_POPI_SETTORE,
              D_PEGI_ORE_COMPL,D_POPI_FIGURA_COMPL,D_FIGI_QUALIFICA_COMPL,
              D_POPI_ATTIVITA_COMPL,D_POPI_SETTORE_COMPL,
              D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
              D_POPI_NUMERO_POSTO,D_POPI_POSTO,
              D_CADO_PREVISTI,D_CADO_IN_PIANTA,D_CADO_IN_DEROGA,
              D_CADO_IN_SOVRANNUMERO,D_CADO_IN_RILASCIO,
              D_CADO_IN_ACQUISIZIONE,D_CADO_IN_ISTITUZIONE,
              D_CADO_VACANTI_COPERTI,D_CADO_VACANTI_NON_COPERTI,
              D_CADO_VACANTI_NON_RICOPRIBILI,
              D_CADO_DOTAZIONI_RUOLO,D_CADO_DOTAZIONI_NO_RUOLO;
              EXIT WHEN DIR_FAT%NOTFOUND;
           END IF;
           IF D_CONTA_CURSORI = 2 THEN
              FETCH DIR INTO D_PEGI_RILEVANZA,
              D_PEGI_ORE,D_POPI_FIGURA,D_FIGI_QUALIFICA,
              D_POPI_ATTIVITA,D_POPI_SETTORE,
              D_PEGI_ORE_COMPL,D_POPI_FIGURA_COMPL,D_FIGI_QUALIFICA_COMPL,
              D_POPI_ATTIVITA_COMPL,D_POPI_SETTORE_COMPL,
              D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
              D_POPI_NUMERO_POSTO,D_POPI_POSTO,
              D_CADO_PREVISTI,D_CADO_IN_PIANTA,D_CADO_IN_DEROGA,
              D_CADO_IN_SOVRANNUMERO,D_CADO_IN_RILASCIO,
              D_CADO_IN_ACQUISIZIONE,D_CADO_IN_ISTITUZIONE,
              D_CADO_VACANTI_COPERTI,D_CADO_VACANTI_NON_COPERTI,
              D_CADO_VACANTI_NON_RICOPRIBILI,
              D_CADO_DOTAZIONI_RUOLO,D_CADO_DOTAZIONI_NO_RUOLO;
              EXIT WHEN DIR%NOTFOUND;
           END IF;
           IF D_CONTA_CURSORI = 3 THEN
              FETCH FAT_DIR INTO D_PEGI_RILEVANZA,
              D_PEGI_ORE,D_POPI_FIGURA,D_FIGI_QUALIFICA,
              D_POPI_ATTIVITA,D_POPI_SETTORE,
              D_PEGI_ORE_COMPL,D_POPI_FIGURA_COMPL,D_FIGI_QUALIFICA_COMPL,
              D_POPI_ATTIVITA_COMPL,D_POPI_SETTORE_COMPL,
              D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
              D_POPI_NUMERO_POSTO,D_POPI_POSTO,
              D_CADO_PREVISTI,D_CADO_IN_PIANTA,D_CADO_IN_DEROGA,
              D_CADO_IN_SOVRANNUMERO,D_CADO_IN_RILASCIO,
              D_CADO_IN_ACQUISIZIONE,D_CADO_IN_ISTITUZIONE,
              D_CADO_VACANTI_COPERTI,D_CADO_VACANTI_NON_COPERTI,
              D_CADO_VACANTI_NON_RICOPRIBILI,
              D_CADO_DOTAZIONI_RUOLO,D_CADO_DOTAZIONI_NO_RUOLO;
              EXIT WHEN FAT_DIR%NOTFOUND;
           END IF;
           IF D_CONTA_CURSORI = 4 THEN
              FETCH VACANTI INTO D_PEGI_RILEVANZA,
              D_PEGI_ORE,D_POPI_FIGURA,D_FIGI_QUALIFICA,
              D_POPI_ATTIVITA,D_POPI_SETTORE,
              D_PEGI_ORE_COMPL,D_POPI_FIGURA_COMPL,D_FIGI_QUALIFICA_COMPL,
              D_POPI_ATTIVITA_COMPL,D_POPI_SETTORE_COMPL,
              D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
              D_POPI_NUMERO_POSTO,D_POPI_POSTO,
              D_CADO_PREVISTI,D_CADO_IN_PIANTA,D_CADO_IN_DEROGA,
              D_CADO_IN_SOVRANNUMERO,D_CADO_IN_RILASCIO,
              D_CADO_IN_ACQUISIZIONE,D_CADO_IN_ISTITUZIONE,
              D_CADO_VACANTI_COPERTI,D_CADO_VACANTI_NON_COPERTI,
              D_CADO_VACANTI_NON_RICOPRIBILI,
              D_CADO_DOTAZIONI_RUOLO,D_CADO_DOTAZIONI_NO_RUOLO;
              EXIT WHEN VACANTI%NOTFOUND;
           END IF;
           IF D_CONTA_CURSORI = 5 THEN
              FETCH POSTI INTO D_PEGI_RILEVANZA,
              D_PEGI_ORE,D_POPI_FIGURA,D_FIGI_QUALIFICA,
              D_POPI_ATTIVITA,D_POPI_SETTORE,
              D_PEGI_ORE_COMPL,D_POPI_FIGURA_COMPL,D_FIGI_QUALIFICA_COMPL,
              D_POPI_ATTIVITA_COMPL,D_POPI_SETTORE_COMPL,
              D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
              D_POPI_NUMERO_POSTO,D_POPI_POSTO,
              D_CADO_PREVISTI,D_CADO_IN_PIANTA,D_CADO_IN_DEROGA,
              D_CADO_IN_SOVRANNUMERO,D_CADO_IN_RILASCIO,
              D_CADO_IN_ACQUISIZIONE,D_CADO_IN_ISTITUZIONE,
              D_CADO_VACANTI_COPERTI,D_CADO_VACANTI_NON_COPERTI,
              D_CADO_VACANTI_NON_RICOPRIBILI,
              D_CADO_DOTAZIONI_RUOLO,D_CADO_DOTAZIONI_NO_RUOLO;
              EXIT WHEN POSTI%NOTFOUND;
           END IF;
           BEGIN
              SELECT ORE
                    ,DECODE(D_PEGI_RILEVANZA,'R','N',GRUPPO,NULL)
                INTO D_POPI_ORE
                    ,D_POPI_GRUPPO
                FROM POSTI_PIANTA
               WHERE D_RIOR_DATA BETWEEN DAL AND NVL(AL,TO_DATE('3333333','J'))
                 AND SEDE_POSTO        = D_POPI_SEDE_POSTO
                 AND ANNO_POSTO        = D_POPI_ANNO_POSTO
                 AND NUMERO_POSTO      = D_POPI_NUMERO_POSTO
                 AND POSTO             = D_POPI_POSTO
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 D_POPI_ORE    := NULL;
                 D_POPI_GRUPPO := NULL;
           END;
           BEGIN
              SELECT NVL(SEQUENZA,999999)
                INTO D_ATTI_SEQUENZA
                FROM ATTIVITA
               WHERE CODICE = D_POPI_ATTIVITA
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 D_ATTI_SEQUENZA := 999999;
           END;
           BEGIN
              SELECT NVL(SEQUENZA,999999)
                INTO D_ATTI_SEQUENZA_COMPL
                FROM ATTIVITA
               WHERE CODICE = D_POPI_ATTIVITA_COMPL
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 D_ATTI_SEQUENZA_COMPL := 999999;
           END;
           BEGIN
              SELECT NVL(FIGU.SEQUENZA,999999)
                    ,FIGI.CODICE
                    ,FIGI.DAL
                    ,COST.ORE_LAVORO
                INTO D_FIGU_SEQUENZA
                    ,D_FIGI_CODICE
                    ,D_FIGI_DAL
                    ,D_COST_ORE_LAVORO
                FROM CONTRATTI_STORICI       COST
                    ,QUALIFICHE_GIURIDICHE   QUGI
                    ,FIGURE_GIURIDICHE       FIGI
                    ,FIGURE                  FIGU
               WHERE D_RIOR_DATA          BETWEEN
                     COST.DAL AND NVL(COST.AL,TO_DATE('3333333','J'))
                 AND D_RIOR_DATA          BETWEEN
                     QUGI.DAL AND NVL(QUGI.AL,TO_DATE('3333333','J'))
                 AND D_RIOR_DATA          BETWEEN
                     FIGI.DAL AND NVL(FIGI.AL,TO_DATE('3333333','J'))
                 AND COST.CONTRATTO             = QUGI.CONTRATTO
                 AND QUGI.NUMERO                =
                     DECODE(D_PEGI_RILEVANZA,'Q',FIGI.QUALIFICA
                                            ,'C',FIGI.QUALIFICA
                                            ,'R',FIGI.QUALIFICA
                                            ,'N',FIGI.QUALIFICA
                                            ,'P',FIGI.QUALIFICA
                                                ,D_FIGI_QUALIFICA
                           )
                 AND FIGI.NUMERO                = FIGU.NUMERO
                 AND FIGU.NUMERO                = D_POPI_FIGURA
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 D_FIGU_SEQUENZA          := 999999;
                 D_FIGI_CODICE            := NULL;
                 D_FIGI_DAL               := NULL;
                 D_COST_ORE_LAVORO        := NULL;
           END;
           BEGIN
              SELECT NVL(FIGU.SEQUENZA,999999)
                    ,FIGI.CODICE
                    ,FIGI.DAL
                    ,COST.ORE_LAVORO
                INTO D_FIGU_SEQUENZA_COMPL
                    ,D_FIGI_CODICE_COMPL
                    ,D_FIGI_DAL_COMPL
                    ,D_COST_ORE_LAVORO_COMPL
                FROM CONTRATTI_STORICI       COST
                    ,QUALIFICHE_GIURIDICHE   QUGI
                    ,FIGURE_GIURIDICHE       FIGI
                    ,FIGURE                  FIGU
               WHERE D_RIOR_DATA          BETWEEN
                     COST.DAL AND NVL(COST.AL,TO_DATE('3333333','J'))
                 AND D_RIOR_DATA          BETWEEN
                     QUGI.DAL AND NVL(QUGI.AL,TO_DATE('3333333','J'))
                 AND D_RIOR_DATA          BETWEEN
                     FIGI.DAL AND NVL(FIGI.AL,TO_DATE('3333333','J'))
                 AND COST.CONTRATTO             = QUGI.CONTRATTO
                 AND QUGI.NUMERO                =
                     DECODE(D_PEGI_RILEVANZA,'Q',D_FIGI_QUALIFICA_COMPL
                                            ,'C',FIGI.QUALIFICA
                                            ,'R',FIGI.QUALIFICA
                                            ,'N',FIGI.QUALIFICA
                                            ,'P',FIGI.QUALIFICA
                                                ,FIGI.QUALIFICA
                           )
                 AND FIGI.NUMERO                = FIGU.NUMERO
                 AND FIGU.NUMERO                = D_POPI_FIGURA_COMPL
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 D_FIGU_SEQUENZA_COMPL    := 999999;
                 D_FIGI_CODICE_COMPL      := NULL;
                 D_FIGI_DAL_COMPL         := NULL;
                 D_COST_ORE_LAVORO_COMPL  := NULL;
           END;
           IF D_PEGI_RILEVANZA = 'R'
           OR D_PEGI_RILEVANZA = 'N'
           OR D_PEGI_RILEVANZA = 'C' THEN
              D_PEGI_ORE       :=
              NVL(D_POPI_ORE,D_COST_ORE_LAVORO);
              D_PEGI_ORE_COMPL := D_PEGI_ORE;
           ELSIF D_PEGI_RILEVANZA = 'P' THEN
              D_PEGI_ORE       :=
              NVL(D_POPI_ORE,D_COST_ORE_LAVORO);
              D_PEGI_ORE_COMPL := NULL;
           ELSIF D_PEGI_RILEVANZA = 'Q' THEN
              D_PEGI_ORE       :=
              NVL(D_PEGI_ORE,NVL(D_POPI_ORE,D_COST_ORE_LAVORO));
              D_PEGI_ORE_COMPL :=
              NVL(D_PEGI_ORE_COMPL,D_COST_ORE_LAVORO_COMPL);
           ELSE
              D_PEGI_ORE       :=
              NVL(D_PEGI_ORE,D_COST_ORE_LAVORO);
              D_PEGI_ORE_COMPL :=
              NVL(D_PEGI_ORE_COMPL,NVL(D_POPI_ORE,D_COST_ORE_LAVORO_COMPL));
           END IF;
           D_CADO_ORE_PREVISTI := D_PEGI_ORE;
           BEGIN
              SELECT SETG.NUMERO
                    ,SETG.CODICE
                    ,NVL(SETG.SEQUENZA,999999)
                    ,SETL.NUMERO
                    ,SETL.CODICE
                    ,NVL(SETL.SEQUENZA,999999)
                    ,SETT.GESTIONE
                    ,SETL.SUDDIVISIONE
                INTO D_SETT_SETTORE_G
                    ,D_SETG_CODICE
                    ,D_SETG_SEQUENZA
                    ,D_POPI_SETTORE
                    ,D_SETT_CODICE
                    ,D_SETT_SEQUENZA
                    ,D_SETT_GESTIONE
                    ,D_SETT_SUDDIVISIONE
                FROM SETTORI SETG
                    ,SETTORI SETL
                    ,SETTORI SETT
               WHERE SETT.NUMERO      = D_POPI_SETTORE
                 AND SETG.NUMERO      = NVL(SETT.SETTORE_G,SETT.NUMERO)
                 AND SETL.NUMERO      =
                     DECODE(SIGN(P_LIVELLO - SETT.SUDDIVISIONE)
                           ,1,SETT.NUMERO
                           ,0,SETT.NUMERO
                             ,DECODE(P_LIVELLO,1,SETT.SETTORE_A
                                                 ,2,SETT.SETTORE_B
                                                 ,3,SETT.SETTORE_C
                                                   ,SETT.NUMERO
                                    )
                           )
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 D_SETT_SETTORE_G        := NULL;
                 D_SETG_CODICE           := NULL;
                 D_SETG_SEQUENZA         := 999999;
                 D_POPI_SETTORE          := NULL;
                 D_SETT_CODICE           := NULL;
                 D_SETT_SEQUENZA         := 999999;
                 D_SETT_GESTIONE         := NULL;
                 D_SETT_SUDDIVISIONE     := NULL;
           END;
           BEGIN
              SELECT SETL.NUMERO
                    ,SETL.CODICE
                    ,NVL(SETL.SEQUENZA,999999)
                INTO D_POPI_SETTORE_COMPL
                    ,D_SETT_CODICE_COMPL
                    ,D_SETT_SEQUENZA_COMPL
                FROM SETTORI SETG
                    ,SETTORI SETL
                    ,SETTORI SETT
               WHERE SETT.NUMERO      = D_POPI_SETTORE_COMPL
                 AND SETG.NUMERO      = NVL(SETT.SETTORE_G,SETT.NUMERO)
                 AND SETL.NUMERO      =
                     DECODE(SIGN(P_LIVELLO - SETT.SUDDIVISIONE)
                           ,1,SETT.NUMERO
                           ,0,SETT.NUMERO
                             ,DECODE(P_LIVELLO,1,SETT.SETTORE_A
                                                 ,2,SETT.SETTORE_B
                                                 ,3,SETT.SETTORE_C
                                                   ,SETT.NUMERO
                                    )
                           )
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 D_POPI_SETTORE_COMPL    := NULL;
                 D_SETT_CODICE_COMPL     := NULL;
                 D_SETT_SEQUENZA_COMPL   := 999999;
           END;
      --
      --  INSERIMENTO REGISTRAZIONE DOTAZIONE.
      --
           BEGIN
             IF D_CADO_PREVISTI+D_CADO_IN_PIANTA+D_CADO_IN_DEROGA+
                D_CADO_IN_SOVRANNUMERO+D_CADO_IN_RILASCIO+
                D_CADO_IN_ACQUISIZIONE+D_CADO_IN_ISTITUZIONE+
                D_CADO_VACANTI_COPERTI+D_CADO_VACANTI_NON_COPERTI+
                D_CADO_VACANTI_NON_RICOPRIBILI+
                D_CADO_DOTAZIONI_RUOLO+D_CADO_DOTAZIONI_NO_RUOLO > 0 THEN
               INSERT INTO CALCOLO_DOTAZIONE
               (CADO_PRENOTAZIONE,CADO_RILEVANZA,
                RIOR_DATA,POPI_GRUPPO,POPI_SETTORE,
                SETT_SEQUENZA,SETT_CODICE,SETT_SUDDIVISIONE,SETT_SETTORE_G,
                SETG_SEQUENZA,SETG_CODICE,SETT_GESTIONE,
                POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,FIGI_CODICE,
                POPI_ATTIVITA,ATTI_SEQUENZA,
                PEGI_SETTORE_COMPL,SETT_SEQUENZA_COMPL,SETT_CODICE_COMPL,
                PEGI_FIGURA_COMPL,FIGI_DAL_COMPL,FIGU_SEQUENZA_COMPL,
                FIGI_CODICE_COMPL,PEGI_ATTIVITA_COMPL,ATTI_SEQUENZA_COMPL,
                PEGI_ORE,PEGI_ORE_COMPL,PEGI_RILEVANZA,
                CADO_PREVISTI,CADO_ORE_PREVISTI,CADO_IN_PIANTA,CADO_IN_DEROGA,
                CADO_IN_SOVRANNUMERO,CADO_IN_RILASCIO,CADO_IN_ACQUISIZIONE,
                CADO_IN_ISTITUZIONE,
                CADO_VACANTI_COPERTI,CADO_VACANTI_NON_COPERTI,
                CADO_VACANTI_NON_RICOPRIBILI,
                CADO_COPERTI_RUOLO,CADO_COPERTI_NO_RUOLO)
               VALUES
               (W_PRENOTAZIONE,1,D_RIOR_DATA,
                D_POPI_GRUPPO,D_POPI_SETTORE,D_SETT_SEQUENZA,D_SETT_CODICE,
                D_SETT_SUDDIVISIONE,
                D_SETT_SETTORE_G,D_SETG_SEQUENZA,D_SETG_CODICE,
                D_SETT_GESTIONE,D_POPI_FIGURA,D_FIGI_DAL,
                D_FIGU_SEQUENZA,D_FIGI_CODICE,
                D_POPI_ATTIVITA,D_ATTI_SEQUENZA,
                D_POPI_SETTORE_COMPL,D_SETT_SEQUENZA_COMPL,D_SETT_CODICE_COMPL,
                D_POPI_FIGURA_COMPL,D_FIGI_DAL_COMPL,D_FIGU_SEQUENZA_COMPL,
                D_FIGI_CODICE_COMPL,D_POPI_ATTIVITA_COMPL,
                D_ATTI_SEQUENZA_COMPL,D_PEGI_ORE,D_PEGI_ORE_COMPL,
                D_PEGI_RILEVANZA,
                D_CADO_PREVISTI,D_CADO_ORE_PREVISTI,
                D_CADO_IN_PIANTA,D_CADO_IN_DEROGA,
                D_CADO_IN_SOVRANNUMERO,D_CADO_IN_RILASCIO,
                D_CADO_IN_ACQUISIZIONE,D_CADO_IN_ISTITUZIONE,
                D_CADO_VACANTI_COPERTI,D_CADO_VACANTI_NON_COPERTI,
                D_CADO_VACANTI_NON_RICOPRIBILI,
                D_CADO_DOTAZIONI_RUOLO,D_CADO_DOTAZIONI_NO_RUOLO
               )
               ;
             END IF;
            END;
        END LOOP;
        IF D_CONTA_CURSORI = 1 THEN
           CLOSE DIR_FAT;
        END IF;
        IF D_CONTA_CURSORI = 2 THEN
           CLOSE DIR;
        END IF;
        IF D_CONTA_CURSORI = 3 THEN
           CLOSE FAT_DIR;
        END IF;
        IF D_CONTA_CURSORI = 4 THEN
           CLOSE VACANTI;
        END IF;
        IF D_CONTA_CURSORI = 5 THEN
           CLOSE POSTI;
        END IF;
        END LOOP;
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
            SEQ_LINGUA;
            CC_DOTAZIONE;
            RAGGR_POSTI;
            DEL_DETT_POSTI;
	    COMMIT;
	 EXCEPTION WHEN FORM_TRIGGER_FAILURE THEN
		RAISE;
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
                          , w_VOCE_MENU
                       FROM A_PRENOTAZIONI
                      WHERE NO_PRENOTAZIONE = PRENOTAZIONE
                     ;
                  EXCEPTION
                     WHEN OTHERS THEN NULL;
                  END;
               END IF;
               BEGIN
                 SELECT TO_NUMBER(SUBSTR(PARA.VALORE,1,1))
                   INTO P_LIVELLO
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_LIVELLO'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_LIVELLO := 1;
               END;
               W_PRENOTAZIONE := PRENOTAZIONE;
               -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
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
               WHEN FORM_TRIGGER_FAILURE THEN
			NULL;
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
NULL;
                  END;
            END;
END;
/

