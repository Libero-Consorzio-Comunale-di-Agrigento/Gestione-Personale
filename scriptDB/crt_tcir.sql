REM  Objects being generated in this file are:-
REM TABLE
REM      TEMP_CC07_IPN_RIT
REM INDEX
REM      TCIR_IK

REM
REM      TCIR - Tabella di servizio per conguaglio cassa/competenza
REM
PROMPT 
PROMPT Creating Table TEMP_CC07_IPN_RIT

create table temp_cc07_ipn_rit
( CI                              NUMBER(8)     NOT NULL
, ANNO_LIQ                        NUMBER(4)     NOT NULL
, ANNO_RIF                        NUMBER(4)     NOT NULL
, ANNO_COMP                       NUMBER(4)     NOT NULL
, VOCE                            VARCHAR2(10)  NOT NULL
, SUB                             VARCHAR2(2)   NOT NULL
, IPN_MOCO                        NUMBER(15,5)
, IPN_MOCO_AP                     NUMBER(15,5)
, VOCE_IPN                        VARCHAR2(10)
, SUB_IPN                         VARCHAR2(2)
, RIT_MOCO                        NUMBER(15,5)
, RIT_MOCO_AP                     NUMBER(15,5)
, ALQ                             NUMBER(15,5)
, LIM_INF                         NUMBER(15,5)
, TIPO                            VARCHAR2(1)
)
;

COMMENT ON TABLE temp_cc07_ipn_rit
    IS 'TCIR - Tabella di servizio per conguaglio cassa/competenza';
REM
REM 

PROMPT Creating Index TCIR_IK on Table TEMP_CC07_IPN_RIT
CREATE INDEX TCIR_IK ON TEMP_CC07_IPN_RIT
(
      ci
    , anno_liq
    , anno_rif
    , anno_comp
    , voce
    , sub )
;
REM
REM  End of command file
REM
