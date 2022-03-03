REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      DDMQ_SQ

REM
REM Sequenza per numerazione automatica
REM
PROMPT 
PROMPT Creating Sequence DDMQ_SQ
CREATE SEQUENCE DDMQ_SQ
 INCREMENT BY 1
 START WITH 1
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

REM
REM  End of command file
REM