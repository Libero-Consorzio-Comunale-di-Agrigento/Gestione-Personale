CREATE OR REPLACE PACKAGE trace IS
/******************************************************************************
 NOME:          TRACE
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
  procedure err_trace (P_TRC IN NUMBER,
		  			 P_PRN IN NUMBER,
					 P_PAS IN NUMBER,
					 P_PRS IN OUT NUMBER,
					 P_STP IN varchar2,
					 P_CNT IN NUMBER,
					 P_TIM IN OUT varchar2,
					 lsegn in number default 30);
procedure log_trace (P_TRC IN NUMBER,
		  			 P_PRN IN NUMBER,
					 P_PAS IN NUMBER,
					 P_PRS IN OUT NUMBER,
					 P_STP IN varchar2,
					 P_CNT IN NUMBER,
					 P_TIM IN OUT varchar2,
					 lsegn in number default 30);
END;
/

CREATE OR REPLACE PACKAGE BODY trace IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;
  procedure err_trace (P_TRC IN NUMBER,
		  			 P_PRN IN NUMBER,
					 P_PAS IN NUMBER,
					 P_PRS IN OUT NUMBER,
					 P_STP IN varchar2,
					 P_CNT IN NUMBER,
					 P_TIM IN OUT varchar2,
					 lsegn in number default 30) is
D_SQE varchar2(50);  -- ERRORE ORACLE
BEGIN
   D_SQE := SUBSTR(SQLERRM,1,50);
   ROLLBACK;
   BEGIN  -- PRELEVA NUMERO MAX DI SEGNALAZIONI RIMASTE CAUSA ROLLBACK
      SELECT NVL(MAX(PROGRESSIVO),0)
        INTO P_PRS
        FROM A_SEGNALAZIONI_ERRORE
       WHERE NO_PRENOTAZIONE = P_PRN
         AND PASSO           = P_PAS
      ;
   END;
   LOG_TRACE(1,P_PRN,P_PAS,P_PRS,P_STP,P_CNT,P_TIM,lsegn);
   P_PRS := P_PRS+1;
   INSERT INTO A_SEGNALAZIONI_ERRORE(NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
          VALUES(P_PRN,P_PAS,P_PRS,'P05809',D_SQE);
   commit;
END;
procedure log_trace (P_TRC IN NUMBER,
		  			 P_PRN IN NUMBER,
					 P_PAS IN NUMBER,
					 P_PRS IN OUT NUMBER,
					 P_STP IN varchar2,
					 P_CNT IN NUMBER,
					 P_TIM IN OUT varchar2,
					 lsegn in number default 30) is
D_SYSTIME       NUMBER;
 D_ORA           varchar2(8); -- ORA:MINUTI.SECONDI
BEGIN
 IF P_TRC IS NOT NULL THEN
   D_SYSTIME := TO_NUMBER(TO_CHAR(SYSDATE,'SSSSS'));
   IF D_SYSTIME < TO_NUMBER(P_TIM) THEN
      P_TIM := TO_CHAR(86400 - TO_NUMBER(P_TIM) + D_SYSTIME);
   ELSE
      P_TIM := TO_CHAR( D_SYSTIME - TO_NUMBER(P_TIM));
   END IF;
   D_ORA := TO_CHAR(SYSDATE,'HH24:MI.SS');
   P_PRS := P_PRS+1;
   IF P_TRC = 0 THEN  -- SEGNALAZIONE DI START
      INSERT INTO A_SEGNALAZIONI_ERRORE(NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
             VALUES(P_PRN,P_PAS,P_PRS,'P05800',
                    RPAD(SUBSTR(P_STP,1,lsegn),lsegn)||
                    ' H.'||D_ORA
                   );
   ELSIF
      P_TRC = 1 THEN  -- TRACE DI SINGOLO STEP
      INSERT INTO A_SEGNALAZIONI_ERRORE(NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
             VALUES(P_PRN,P_PAS,P_PRS,'P05801',
                    substr(RPAD(SUBSTR(P_STP,1,30),30)||
                    ' H.'||D_ORA||' ('||P_TIM||
                    '") #<'||TO_CHAR(P_CNT)||'>',1,50)
                   );
   ELSIF
      P_TRC = 2 THEN  -- SEGNALAZIONE DI STOP
      INSERT INTO A_SEGNALAZIONI_ERRORE(NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
             VALUES(P_PRN,P_PAS,P_PRS,'P05802',
                    RPAD(SUBSTR(P_STP,1,lsegn),lsegn)||
                    ' H.'||D_ORA||' ('||P_TIM||'")'
                   );
   ELSIF
      P_TRC = 7 THEN  -- PER NETTI NEGATIVI
      INSERT INTO A_SEGNALAZIONI_ERRORE(NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
             VALUES(P_PRN,P_PAS,P_PRS,'P05830',
                    RPAD(SUBSTR(P_STP,1,lsegn),lsegn)
                   );
   ELSIF
      P_TRC = 8 THEN  -- PER WARNING
      INSERT INTO A_SEGNALAZIONI_ERRORE(NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
             VALUES(P_PRN,P_PAS,P_PRS,'P05808',
                    RPAD(SUBSTR(P_STP,1,lsegn),lsegn)||
                    ' H.'||D_ORA
                   );
   END IF;
 END IF;
   P_TIM := TO_CHAR(SYSDATE,'SSSSS');
END;
END;
/

