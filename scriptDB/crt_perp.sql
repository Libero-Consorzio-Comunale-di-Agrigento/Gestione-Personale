REM  Objects being generated in this file are:-
REM TABLE
REM      PERIODI_RETRIBUTIVI_BP
REM INDEX
REM      PERP_IK
REM      PERP_IK2

REM
REM    PERP - Caratteristiche contabili dei periodi giuridici retribuiti per Bilancio di Previsione
REM
PROMPT 
PROMPT Creating Table PERIODI_RETRIBUTIVI_BP
CREATE TABLE periodi_retributivi_bp(
 ci                              NUMBER (8,0)     NOT NULL,
 periodo                         DATE             NOT NULL,
 anno                            NUMBER (4,0)     NOT NULL,
 mese                            NUMBER (2,0)     NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NOT NULL,
 servizio                        VARCHAR(1)       NOT NULL,
 competenza                      VARCHAR(1)       NOT NULL,
 conguaglio                      NUMBER (1,0)     NULL,
 gg_con                          NUMBER (3,0)     NOT NULL,
 gg_lav                          NUMBER (3,0)     NOT NULL,
 gg_pre                          NUMBER (3,0)     NOT NULL,
 gg_inp                          NUMBER (3,0)     NOT NULL,
 st_inp                          NUMBER (2,0)     NOT NULL,
 gg_af                           NUMBER (3,0)     NOT NULL,
 gg_fis                          NUMBER (3,0)     NOT NULL,
 gg_rat                          NUMBER (3,0)     NOT NULL,
 gg_100                          NUMBER (3,0)     NOT NULL,
 gg_80                           NUMBER (3,0)     NOT NULL,
 gg_66                           NUMBER (3,0)     NOT NULL,
 gg_50                           NUMBER (3,0)     NOT NULL,
 gg_30                           NUMBER (3,0)     NOT NULL,
 gg_sa                           NUMBER (3,0)     NOT NULL,
 flag_reve                       VARCHAR(1)       NULL,
 gg_rid                          NUMBER (9,6)     NOT NULL,
 rap_ore                         NUMBER (9,6)     NULL,
 gg_rap                          NUMBER (9,6)     NOT NULL,
 rap_gg                          NUMBER (9,6)     NOT NULL,
 quota                           NUMBER (5,2)     NOT NULL,
 intero                          NUMBER (5,2)     NOT NULL,
 settore                         NUMBER (6,0)     NULL,
 sede                            NUMBER (6,0)     NULL,
 figura                          NUMBER (6,0)     NULL,
 attivita                        VARCHAR (4)      NULL,
 contratto                       VARCHAR (4)      NOT NULL,
 gestione                        VARCHAR (8)      NOT NULL,
 ruolo                           VARCHAR (4)      NULL,
 posizione                       VARCHAR (4)      NULL,
 qualifica                       NUMBER (6,0)     NULL,
 tipo_rapporto                   VARCHAR (4)      NULL,
 ore                             NUMBER (5,2)     NOT NULL,
 trattamento                     VARCHAR (4)      NOT NULL,
 sede_del                        VARCHAR (4)      NULL,
 anno_del                        NUMBER (4,0)     NULL,
 numero_del                      NUMBER (7,0)     NULL,
 gg_per                          NUMBER (3,0)     NULL,
 per_gg                          NUMBER (5,2)     NULL,
 cod_astensione                  VARCHAR (4)      NULL,
 gg_nsu                          NUMBER (3,0)     NULL,
 rateo_continuativo              number (1)       NULL,
 gg_det                          number(3)        NOT NULL,
 gg_365                          number(3)        NOT NULL,
 tipo                            varchar2(1),
 gg_df                           NUMBER (3)       NOT NULL
)
PCTFREE  10
PCTUSED  40
INITRANS 1
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx2200
  NEXT   &1DIMx1100 
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
         )
;

COMMENT ON TABLE periodi_retributivi_bp
    IS 'PERP - Caratteristiche contabili dei periodi giuridici retribuiti per Bilancio di Previsione';


REM
REM 
REM
REM 
REM

PROMPT
PROMPT Creating Index PERP_IK on Table PERIODI_RETRIBUTIVI_BP
CREATE INDEX PERP_IK ON PERIODI_RETRIBUTIVI_BP
(
      ci ,
      periodo )
PCTFREE  0
INITRANS 2
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx700      
  NEXT   &1DIMx350   
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
PROMPT Creating Index PERP_IK2 on Table PERIODI_RETRIBUTIVI_BP
CREATE INDEX PERP_IK2 ON PERIODI_RETRIBUTIVI_BP
(
      anno ,
      mese ,
      ci )
PCTFREE  0
INITRANS 2
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx700      
  NEXT   &1DIMx350   
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
         )
;

REM
REM  End of command file
REM
