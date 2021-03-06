REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PAM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CATEGORIA_STATI_ESTERI
REM INDEX
REM      GRRA_IK
REM      GRRA_IK2

REM
REM     CASE - Categoria Fiscale per Stati Esteri 
REM            deve essere espposta su mod. 770/99    
REM
PROMPT 
PROMPT Creating Table CATEGORIA_STATI_ESTERI
CREATE TABLE categoria_stati_esteri
            (provincia_stato    NUMBER(3)    NOT NULL,
             cittadinanza       VARCHAR(3)       NULL,
             codice             VARCHAR(3)       NULL
)
;

COMMENT ON TABLE categoria_stati_esteri
    IS 'CASE - Categoria Fiscale per Stati Esteri';


REM
REM 
REM
PROMPT
PROMPT Creating Index CASE_IK on Table CATEGORIA_STATI_ESTERI
CREATE INDEX CASE_IK ON CATEGORIA_STATI_ESTERI
(
      provincia_stato)
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CASE_IK2 on Table CATEGORIA_STATI_ESTERI
CREATE UNIQUE INDEX CASE_IK2 ON CATEGORIA_STATI_ESTERI
(
      cittadinanza )
PCTFREE  10
;

REM
REM  End of command file
REM
