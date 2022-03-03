PROMPT Creating Table CALCOLI_CONTABILI_BP
CREATE TABLE calcoli_contabili_bp (
 ci                              NUMBER(8,0)      NOT NULL,
 voce                            VARCHAR(10)      NOT NULL,
 sub                             VARCHAR(2)       NOT NULL,
 riferimento                     DATE             NOT NULL,
 arr                             VARCHAR(1)       NULL,
 input                           VARCHAR(1)       NOT NULL,
 estrazione                      VARCHAR(2)       NOT NULL,
 data                            DATE             NULL,
 qualifica                       NUMBER(6,0)      NULL,
 tipo_rapporto                   VARCHAR(4)       NULL,
 ore                             NUMBER(5,2)      NULL,
 tar                             NUMBER(14,4)     NULL,
 qta                             NUMBER(14,4)     NULL,
 imp                             NUMBER(10,0)     NULL,
 sede_del                        VARCHAR(4)       NULL,
 anno_del                        NUMBER(4,0)      NULL,
 numero_del                      NUMBER(7,0)      NULL,
 risorsa_intervento              VARCHAR(7)       NULL,
 capitolo                        VARCHAR(14)      NULL,
 articolo                        VARCHAR(14)      NULL,
 impegno                         NUMBER(5)        NULL,
 conto                           VARCHAR(2)       NULL,
 ipn_c                           NUMBER(10,0)     NULL,
 ipn_s                           NUMBER(10,0)     NULL,
 ipn_p                           NUMBER(10,0)     NULL,
 ipn_l                           NUMBER(10,0)     NULL,
 ipn_e                           NUMBER(10,0)     NULL,
 ipn_t                           NUMBER(10,0)     NULL,
 ipn_eap                         NUMBER(10,0)     NULL,
 competenza                      DATE             NULL,
 ipn_a                           NUMBER(10,0)     NULL,
 ipn_ap                          NUMBER(10,0)     NULL,
 anno_impegno                    NUMBER(4)        NULL,
 sub_impegno                     NUMBER(5)        NULL,
 anno_sub_impegno                NUMBER(4)        NULL,
 codice_siope		         NUMBER(4)        NULL
)
;

REM
REM 
REM
PROMPT
PROMPT Creating Index CABP_IK on Table CALCOLI_CONTABILI_BP
CREATE INDEX CABP_IK ON CALCOLI_CONTABILI_BP
(
      ci )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CABP_IK2 on Table CALCOLI_CONTABILI_BP
CREATE INDEX CABP_IK2 ON CALCOLI_CONTABILI_BP
(
      estrazione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CABP_VOCO_FK on Table CALCOLI_CONTABILI_BP
CREATE INDEX CABP_VOCO_FK ON CALCOLI_CONTABILI_BP
(
      voce ,
      sub )
PCTFREE  10
;

REM
REM  End of command file
REM
