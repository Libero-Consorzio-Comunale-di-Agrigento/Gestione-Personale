REM  Objects being generated in this file are:-
REM TABLE
REM      W_PERIODI
REM INDEX
REM      WPER_IK

REM
REM    WPER - Tabella di servizio per calcolo cedolino
REM
PROMPT 
PROMPT Creating Table W_PERIODI

create table w_periodi
( CI                                       NUMBER(8)  NOT NULL
, RIFERIMENTO                              DATE       NOT NULL
, PERIODO                                  DATE       NOT NULL
)
;

COMMENT ON TABLE w_periodi
    IS 'WPER - Tabella di servizio per calcolo cedolino';
REM
REM 

PROMPT Creating Index WPER_IK on Table W_PERIODI
CREATE INDEX WPER_IK ON W_PERIODI
(
      ci ,
      riferimento)
;
REM
REM  End of command file
REM
