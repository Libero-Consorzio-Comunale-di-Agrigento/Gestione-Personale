REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  29-JUL-93
REM
REM For application system PAM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      INDI_SQ


REM
REM Sequenza per la numerazione individuale anagrafe del Personale
REM
PROMPT 
PROMPT Creating Sequence INDI_SQ
CREATE SEQUENCE indi_sq
 INCREMENT BY 1
 START WITH 1
 MINVALUE 1
 MAXVALUE 99999999
 NOCYCLE 
 CACHE 2
 NOORDER
;

REM
REM  End of command file
REM