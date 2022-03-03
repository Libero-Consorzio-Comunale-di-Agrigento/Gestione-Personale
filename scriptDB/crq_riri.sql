REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      RIRI_SQ


REM
REM Sequenza per numerazione automatica delle Testate delle Richieste di Rimborso per Missioni
REM
PROMPT 
PROMPT Creating Sequence RIRI_SQ
CREATE SEQUENCE riri_sq
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
