REM  Objects being generated in this file are:-
REM TABLE
REM      TEMP_CC07_CNG
REM INDEX
REM      TCCN_IK

REM
REM      TCCN - Tabella di servizio per conguaglio cassa/competenza
REM
PROMPT 
PROMPT Creating Table TEMP_CC07_CNG

create table temp_cc07_cng
( CI                              NUMBER(8)     NOT NULL
, ANNO_RIF                        NUMBER(4)     NOT NULL
, VOCE_IPN                        VARCHAR2(10)  NOT NULL
, SUB_IPN                         VARCHAR2(2)   NOT NULL
, IPN                             NUMBER(15,5)
, IPN_AP                          NUMBER(15,5)
, VOCE_RIT                        VARCHAR2(10)
, SUB_RIT                         VARCHAR2(2)
, IPN_RIT                         NUMBER(15,5)
, IPN_RIT_AP                      NUMBER(15,5)
, RIT                             NUMBER(15,5)
, RIT_AP                          NUMBER(15,5)
, ALQ                             NUMBER(7,4)
, LIM_INF                         NUMBER(15,5)
)
;

COMMENT ON TABLE temp_cc07_cng
    IS 'TCCN - Tabella di servizio per conguaglio cassa/competenza';
REM
REM 

PROMPT Creating Index TCCN_IK on Table TEMP_CC07_CNG
CREATE INDEX TCCN_IK ON TEMP_CC07_CNG
(     anno_rif
    , voce_ipn
    , sub_ipn
    , voce_rit
    , sub_rit
    , ci )
;
REM
REM  End of command file
REM
