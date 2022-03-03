REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      GP4MT_DEVE_ID


REM
REM Sequenza per numerazione automatica righe caricate in Deposito_variabili_economiche (deve_id)
REM di competenza e gestione del modulo Missioni e Trasferte
REM
PROMPT 
PROMPT Creating Sequence GP4MT_DEVE_ID
CREATE SEQUENCE gp4mt_deve_id
 INCREMENT BY 1
 START WITH 1
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

REM
REM  End of command file
REM
