REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      POSIZIONI
REM INDEX
REM      POSI_PK
REM      POSI_POSI_FK

REM
REM     POSI - Posizioni giuridiche e di stato matricolare
REM
PROMPT 
PROMPT Creating Table POSIZIONI
CREATE TABLE posizioni(
 codice                          VARCHAR2(4)       NOT NULL,
 descrizione                     VARCHAR2(30)      NULL,
 descrizione_al1                 VARCHAR2(30)      NULL,
 descrizione_al2                 VARCHAR2(30)      NULL,
 sequenza                        NUMBER(3,0)       NULL,
 posizione                       VARCHAR2(4)       NULL,
 ruolo                           VARCHAR2(2)       NOT NULL,
 stagionale                      VARCHAR2(2)       NOT NULL,
 contratto_formazione            VARCHAR2(2)       NOT NULL,
 tempo_determinato               VARCHAR2(2)       NOT NULL,
 part_time                       VARCHAR2(2)       NOT NULL,
 copertura_part_time             VARCHAR2(2)       NULL,
 tipo_part_time                  VARCHAR2(2)       NULL,
 di_ruolo                        VARCHAR2(1)       NOT NULL,
 tipo_formazione                 VARCHAR2(1)       NULL,
 tipo_determinato                VARCHAR2(2)       NULL,
 universitario 			 VARCHAR2(2)       NULL, 
 collaboratore 			 VARCHAR2(2)       NULL,
 lsu                             VARCHAR2(2)       NULL,
 ruolo_do                        varchar2(2)       NULL,
 amm_cons                        VARCHAR2(2)       NULL,
 contratto_opera                 varchar2(2)       NULL,
 sovrannumero                    VARCHAR2(2) DEFAULT 'NO' NULL
)
;

COMMENT ON TABLE posizioni
    IS 'POSI - Posizioni giuridiche e di stato matricolare';


REM
REM 
REM
PROMPT
PROMPT Creating Index POSI_PK on Table POSIZIONI
CREATE UNIQUE INDEX POSI_PK ON POSIZIONI
(
      codice )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index POSI_POSI_FK on Table POSIZIONI
CREATE INDEX POSI_POSI_FK ON POSIZIONI
(
      posizione )
PCTFREE  10
;

REM
REM  End of command file
REM
