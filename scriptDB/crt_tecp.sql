REM  Objects being generated in this file are:-
REM TABLE
REM      TEMP_CACO_PERE
REM INDEX
REM      TECP_IK

REM
REM    TECP - Tabella di servizio per calcolo cedolino
REM
PROMPT 
PROMPT Creating Table TEMP_CACO_PERE

create table temp_caco_pere
( CI                                       NUMBER(8)  NOT NULL
, RIFERIMENTO                              DATE       NOT NULL
, PERIODO                                  DATE       NOT NULL
)
;

COMMENT ON TABLE temp_caco_pere
    IS 'TECP - Tabella di servizio per calcolo cedolino';
REM
REM 

PROMPT Creating Index TECP_IK on Table TEMP_CACO_PERE
CREATE INDEX TECP_IK ON TEMP_CACO_PERE
(
      ci ,
      riferimento)
;
REM
REM  End of command file
REM
