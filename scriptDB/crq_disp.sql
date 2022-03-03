REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      DISP_SQ

REM
REM Sequenza per numerazione automatica
REM
PROMPT 
PROMPT Creating Sequence DISP_SQ
CREATE SEQUENCE DISP_SQ
 INCREMENT BY 1
 START WITH 1
 MINVALUE 1
 MAXVALUE 999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

REM
REM  End of command file
REM