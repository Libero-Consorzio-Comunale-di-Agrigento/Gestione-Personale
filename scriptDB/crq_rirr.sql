REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      RIRR_SQ


REM
REM Sequenza per numerazione automatica dei Dettagli delle Richieste di Rimborso per Missioni
REM
PROMPT 
PROMPT Creating Sequence RIRR_SQ
CREATE SEQUENCE rirr_sq
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
