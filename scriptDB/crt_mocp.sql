REM  Objects being generated in this file are:-
REM TABLE
REM      MOVIMENTI_CONTABILI_PREVISIONE
REM INDEX
REM      MOCP_IK
REM      MOCP_RARE_FK

REM
REM    MOCP - Movimenti contabili di retribuzione individuale per Bilancio di Previsione
REM
PROMPT 
PROMPT Creating Table MOVIMENTI_CONTABILI_PREVISIONE
CREATE TABLE movimenti_contabili_previsione(
 ci                              NUMBER (8,0)     NOT NULL,
 anno                            NUMBER (4,0)     NOT NULL,
 mese                            NUMBER (2,0)     NOT NULL,
 mensilita                       VARCHAR (3)      NOT NULL,
 bilancio                        VARCHAR (2)      NOT NULL,
 budget                          VARCHAR (4)      NOT NULL,
 riferimento                     DATE             NOT NULL,
 arr                             VARCHAR(1)       NULL,
 tar                             NUMBER (15,5)    NULL,
 qta                             NUMBER (12,2)    NULL,
 imp                             NUMBER (12,2)    NULL,
 sede_del                        VARCHAR (4)      NULL,
 anno_del                        NUMBER (4,0)     NULL,
 numero_del                      NUMBER (7,0)     NULL,
 DELIBERA                        VARCHAR2(4)      NULL,
 risorsa_intervento              VARCHAR (7)      NULL,
 capitolo                        VARCHAR (14)     NULL,
 articolo                        VARCHAR (14)     NULL,
 impegno                         NUMBER (5)       NULL,
 conto                           VARCHAR (2)      NULL,
 ipn_p                           NUMBER (12,2)    NULL,
 ipn_eap                         NUMBER (12,2)    NULL,
 nr_voci                         NUMBER (5,0)     NULL,
 settore                         NUMBER (6)       NULL,
 sede                            NUMBER (6)       NULL,
 anno_impegno                    NUMBER(4)        NULL,
 sub_impegno                     NUMBER(5)        NULL,
 anno_sub_impegno                NUMBER(4)        NULL,
 codice_siope		         NUMBER(4)        NULL
)
PCTFREE  10
PCTUSED  40
INITRANS 1
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx8000
  NEXT   &1DIMx4000
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE movimenti_contabili_previsione
    IS 'MOCP - Movimenti contabili di retribuzione individuale per Bilancio di Previsione';


REM
REM 
REM
REM 
REM

PROMPT
PROMPT Creating Index MOCP_IK on Table MOVIMENTI_CONTABILI_PREVISIONE
CREATE INDEX MOCP_IK ON MOVIMENTI_CONTABILI_PREVISIONE
(
      anno ,
      mese ,
      ci )
PCTFREE  50
INITRANS 2
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx4400      
  NEXT   &1DIMx2200   
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
REM 
REM

PROMPT
PROMPT Creating Index MOCP_RARE_FK on Table MOVIMENTI_CONTABILI_PREVISIONE
CREATE INDEX MOCP_RARE_FK ON MOVIMENTI_CONTABILI_PREVISIONE
(
      ci )
PCTFREE  50
INITRANS 2
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx2600     
  NEXT   &1DIMx1300    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

REM
REM  End of command file
REM
