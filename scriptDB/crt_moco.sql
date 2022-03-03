REM  Objects being generated in this file are:-
REM TABLE
REM      MOVIMENTI_CONTABILI
REM INDEX
REM      MOCO_IK
REM      MOCO_IK2
REM      MOCO_IK3

REM
REM     MOCO - Movimenti contabili che costituiscono la retribuzione individual
REM - e
REM
PROMPT 
PROMPT Creating Table MOVIMENTI_CONTABILI
CREATE TABLE movimenti_contabili(
 ci                              NUMBER(8,0)      NOT NULL,
 anno                            NUMBER(4,0)      NOT NULL,
 mese                            NUMBER(2,0)      NULL,
 mensilita                       VARCHAR(3)       NULL,
 voce                            VARCHAR(10)      NOT NULL,
 sub                             VARCHAR(2)       NOT NULL,
 riferimento                     DATE             NOT NULL,
 arr                             VARCHAR(1)       NULL,
 input                           VARCHAR(1)       NOT NULL,
 data                            DATE             NULL,
 qualifica                       NUMBER(6,0)      NULL,
 tipo_rapporto                   VARCHAR(4)       NULL,
 ore                             NUMBER(5,2)      NULL,
 tar                             NUMBER(15,5)     NULL,
 qta                             NUMBER(14,4)     NULL,
 imp                             NUMBER(12,2)     NULL,
 tar_var                         NUMBER(15,5)     NULL,
 qta_var                         NUMBER(14,4)     NULL,
 imp_var                         NUMBER(12,2)     NULL,
 sede_del                        VARCHAR(4)       NULL,
 anno_del                        NUMBER(4,0)      NULL,
 numero_del                      NUMBER(7,0)      NULL,
 delibera                        VARCHAR(4)       NULL,
 risorsa_intervento              VARCHAR(7)       NULL,
 capitolo                        VARCHAR(14)      NULL,
 articolo                        VARCHAR(14)      NULL,
 impegno                         NUMBER(5)        NULL,
 conto                           VARCHAR(2)       NULL,
 ipn_p                           NUMBER(12,2)     NULL,
 ipn_eap                         NUMBER(12,2)     NULL,
 competenza                      DATE             NULL,
 anno_impegno                    NUMBER(4)        NULL,
 sub_impegno                     NUMBER(5)        NULL,
 anno_sub_impegno                NUMBER(4)        NULL,
 codice_siope		         NUMBER(4)        NULL
)
STORAGE  (
  INITIAL   &1DIMx120000
  NEXT   &1DIMx60000  
  MINEXTENTS  2
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE movimenti_contabili
    IS 'MOCO - Movimenti contabili che costituiscono la retribuzione individuale';


REM
REM 
REM
PROMPT
PROMPT Creating Index MOCO_IK on Table MOVIMENTI_CONTABILI
CREATE INDEX MOCO_IK ON MOVIMENTI_CONTABILI
(
      ci ,
      voce ,
      anno )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx65000    
  NEXT   &1DIMx33000    
  MINEXTENTS  2
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index MOCO_IK2 on Table MOVIMENTI_CONTABILI
CREATE INDEX MOCO_IK2 ON MOVIMENTI_CONTABILI
(
      input )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx40000    
  NEXT   &1DIMx20000 
  MINEXTENTS  2
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

REM
REM 
REM
PROMPT
PROMPT Creating Index MOCO_IK3 on Table MOVIMENTI_CONTABILI
CREATE INDEX MOCO_IK3 ON MOVIMENTI_CONTABILI
(
      anno ,
      ci ,
      mese )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx60000     
  NEXT   &1DIMx30000     
  MINEXTENTS  2
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

REM
REM  End of command file
REM
