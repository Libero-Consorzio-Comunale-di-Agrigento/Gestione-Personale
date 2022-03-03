REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      MONO_SQ

REM
REM Sequenza per numerazione automatica delle Note 
REM
PROMPT 
PROMPT Creating Sequence MONO_SQ
CREATE SEQUENCE MONO_SQ 
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

