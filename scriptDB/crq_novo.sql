REM Sequenza per numerazione automatica dell'ID su NORMATIVA_VOCE

CREATE SEQUENCE NOVO_SQ
 INCREMENT BY 1
 START WITH 1
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;