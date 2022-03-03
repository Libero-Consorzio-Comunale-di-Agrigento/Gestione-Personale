REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM SEQUENCE
REM      IMIM_SQ

REM
REM Sequenza per numerazione automatica delle Regole per il calcolo della Diaria per le Missioni
REM
PROMPT 
PROMPT Creating Sequence IMIM_SQ
CREATE SEQUENCE IMIN_SQ 
 INCREMENT BY 1
 START WITH 1
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

create synonym reti_sq for imin_sq;