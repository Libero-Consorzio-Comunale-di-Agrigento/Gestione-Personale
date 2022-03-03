REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      REIN_SQ

REM
REM Sequenza per numerazione automatica
REM
PROMPT 
PROMPT Creating Sequence REIN_SQ
CREATE SEQUENCE REIN_SQ
 INCREMENT BY 1
 START WITH 53
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

REM
REM  End of command file
REM