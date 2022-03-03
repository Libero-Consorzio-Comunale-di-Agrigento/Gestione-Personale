CREATE OR REPLACE PACKAGE PECCVECO IS
 PROCEDURE DELETE_TAB(P_ANNO IN NUMBER,P_MESE IN NUMBER,P_MENSILITA IN VARCHAR2,P_RUOLO IN VARCHAR2,P_contributo IN VARCHAR2);
 PROCEDURE INSERT_TAB(P_ANNO IN NUMBER,P_MESE IN NUMBER,P_MENSILITA IN VARCHAR2,P_RUOLO IN VARCHAR2,P_contributo IN VARCHAR2);
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER); 
END;
/

CREATE OR REPLACE PACKAGE BODY PECCVECO IS
 FORM_TRIGGER_FAILURE EXCEPTION;
 
 PROCEDURE DELETE_TAB(P_ANNO IN NUMBER,P_MESE IN NUMBER,P_MENSILITA IN VARCHAR2,P_RUOLO IN VARCHAR2,P_contributo IN VARCHAR2) IS
 BEGIN
 DELETE FROM VERSAMENTI_CONTRIBUTIVI
 WHERE ANNO=P_ANNO 
 AND   MESE=P_MESE
 AND   MENSILITA=P_MENSILITA
 AND   RUOLO LIKE P_RUOLO
 AND   contributo LIKE P_contributo;
 EXCEPTION
 WHEN OTHERS THEN ROLLBACK;
 COMMIT;
 RAISE FORM_TRIGGER_FAILURE;
 END;
 
 PROCEDURE INSERT_TAB(P_ANNO IN NUMBER,P_MESE IN NUMBER,P_MENSILITA IN VARCHAR2,P_RUOLO IN VARCHAR2,P_contributo IN VARCHAR2) IS
 BEGIN
  INSERT INTO VERSAMENTI_CONTRIBUTIVI
  (ANNO,
   MESE,
   MENSILITA,
   CI,
   istituto,
   RUOLO,
   ANNO_RIF,
   LORDO,
   IMPONIBILE,
   CONTRIBUTO, 
   RITENUTA ,
   TITOLO )
  SELECT MOCO.ANNO,MOCO.MESE,MOCO.MENSILITA,MOCO.CI
     , MAX(SUBSTR(ESRC.COLONNA,INSTR(ESRC.COLONNA,'*')+1
                    ,INSTR(ESRC.COLONNA,'_')-(INSTR(ESRC.COLONNA,'*')+1))) 
     , PERE.RUOLO
     , TO_CHAR(MOCO.RIFERIMENTO,'YYYY') 
     , SUM( ( DECODE(INSTR(ESRC.COLONNA,'LORDO')
                    , 0, NULL, MOCO.IMP) 
             * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
              / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
              + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0))
     , SUM( ( DECODE(INSTR(ESRC.COLONNA,'IPN')
                    , 0, NULL,MOCO.TAR) 
             * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
              / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
              + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0))
     , SUM( ( DECODE(INSTR(ESRC.COLONNA,'CONTR')
                    , 0, NULL,MOCO.IMP) 
             * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
              / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
              + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0))
     , SUM( ( DECODE(INSTR(ESRC.COLONNA,'RIT')
                    , 0, NULL,MOCO.IMP) 
             * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
              / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
              + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0))
     , ESVC.NOTE
  FROM MOVIMENTI_CONTABILI MOCO
     , PERIODI_RETRIBUTIVI PERE
     , ESTRAZIONE_RIGHE_CONTABILI ESRC
     , ESTRAZIONE_VALORI_CONTABILI ESVC
 WHERE ESRC.ESTRAZIONE = 'VOCI_VERSAMENTI'
   AND ESVC.ESTRAZIONE = ESRC.ESTRAZIONE
   AND ESVC.COLONNA    = ESRC.COLONNA
   AND MOCO.ANNO       = P_ANNO
   AND MOCO.MENSILITA  = P_MENSILITA
   AND PERE.RUOLO     LIKE P_RUOLO
   AND ESVC.COLONNA LIKE '%'||P_contributo||'%'
   AND PERE.PERIODO = LAST_DAY(TO_DATE(LPAD(MOCO.MESE,2,'0')||MOCO.ANNO,'MMYYYY'))
   AND PERE.COMPETENZA = 'A'
   AND PERE.CI = MOCO.CI
   AND SUBSTR(ESRC.COLONNA,INSTR(ESRC.COLONNA,'_')+1) 
        IN ('LORDO','IPN','CONTR','RIT')
   AND MOCO.VOCE = ESRC.VOCE
   AND MOCO.SUB  = ESRC.SUB
   AND EXISTS 
      (SELECT 'X' FROM ESTRAZIONI_VOCE
        WHERE TRATTAMENTO = PERE.TRATTAMENTO
          AND (VOCE,SUB) IN
             (SELECT VOCE,SUB FROM ESTRAZIONE_RIGHE_CONTABILI
               WHERE ESTRAZIONE = ESRC.ESTRAZIONE
                 AND COLONNA = SUBSTR(ESRC.COLONNA,1,INSTR(ESRC.COLONNA,'_')-1)||
                               '_COND'))
 GROUP BY MOCO.ANNO,MOCO.MESE,MOCO.MENSILITA,MOCO.CI, 
                PERE.RUOLO,SUBSTR(ESRC.COLONNA,1,INSTR(ESRC.COLONNA,'_')-1) 
                ,TO_CHAR(MOCO.RIFERIMENTO,'YYYY')
                ,ESVC.NOTE
 HAVING NVL(SUM( ( DECODE(INSTR(ESRC.COLONNA,'RIT')
                    , 0, NULL,MOCO.IMP) 
             * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
              / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
              + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0))
           ,0) +
        NVL(SUM( ( DECODE(INSTR(ESRC.COLONNA,'IPN')
                    , 0, NULL,MOCO.TAR) 
             * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
              / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
              + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0))
           ,0) +
        NVL(SUM( ( DECODE(INSTR(ESRC.COLONNA,'CONTR')
                    , 0, NULL,MOCO.IMP) 
             * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
              / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
              + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0))
           ,0) != 0;

 END;
 
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER,PASSO IN NUMBER) IS
BEGIN
DECLARE

P_anno number(4);
P_mese number(2);
P_mensilita varchar2(4);
P_ruolo varchar2(4);
P_contributo varchar2(10);

BEGIN

BEGIN
SELECT TO_NUMBER(SUBSTR(VALORE,1,4))
INTO P_ANNO
FROM A_PARAMETRI
WHERE NO_PRENOTAZIONE=PRENOTAZIONE
AND PARAMETRO = 'P_ANNO';
EXCEPTION
 WHEN NO_DATA_FOUND THEN NULL;
END;

BEGIN
SELECT SUBSTR(VALORE,1,4)
INTO P_MENSILITA
FROM A_PARAMETRI
WHERE NO_PRENOTAZIONE=PRENOTAZIONE
AND PARAMETRO = 'P_MENSILITA';
EXCEPTION
 WHEN NO_DATA_FOUND THEN NULL;
END;

BEGIN
SELECT NVL(P_ANNO,RIRE.ANNO),
	   MENS.MESE,
	   NVL(P_MENSILITA,MENS.MENSILITA)
INTO P_ANNO,P_MESE,P_MENSILITA
FROM RIFERIMENTO_RETRIBUZIONE RIRE,
     MENSILITA MENS
WHERE RIRE.RIRE_ID='RIRE'
      AND MENS.MENSILITA=NVL(P_MENSILITA,RIRE.MENSILITA);
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;

BEGIN
SELECT VALORE D_RUOLO
INTO P_RUOLO
FROM A_PARAMETRI
WHERE NO_PRENOTAZIONE=PRENOTAZIONE
AND PARAMETRO = 'P_RUOLO';
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
BEGIN
SELECT VALORE D_contributo
INTO P_contributo
FROM A_PARAMETRI
WHERE NO_PRENOTAZIONE=PRENOTAZIONE
AND PARAMETRO = 'P_CONTRIBUTO';
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
DELETE_TAB(P_ANNO,P_MESE,P_MENSILITA,P_RUOLO,P_contributo);
INSERT_TAB(P_ANNO,P_MESE,P_MENSILITA,P_RUOLO,P_contributo);
END;
END;
END;
/