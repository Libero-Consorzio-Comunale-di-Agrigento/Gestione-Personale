REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      DIST_SQ


REM
REM Sequenza per numerazione automatica dei Numeri Distinta
REM per le Richieste di Rimborso per Missioni
REM
PROMPT 
PROMPT Creating Sequence DIST_SQ
CREATE SEQUENCE dist_sq
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
