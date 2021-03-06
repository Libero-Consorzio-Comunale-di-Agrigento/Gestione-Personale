REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  04-JAN-94
REM
REM For application system GIP version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ENTE
REM INDEX
REM      ENTE_PK

REM
REM     ENTE - Dati anagrafici e fiscali dell"ente
REM
PROMPT 
PROMPT Creating Table ENTE
CREATE TABLE ente(
 ente_id                         VARCHAR(4)       NOT NULL,
 nome                            VARCHAR(40)      NOT NULL,
 sesso                           VARCHAR(1)       NULL,
 data_nas                        DATE             NULL,
 provincia_nas                   NUMBER(3,0)      NULL,
 comune_nas                      NUMBER(3,0)      NULL,
 indirizzo_res                   VARCHAR(25)      NOT NULL,
 indirizzo_res_al1               VARCHAR(25)      NULL,
 indirizzo_res_al2               VARCHAR(25)      NULL,
 numero_civico                   VARCHAR(5)       NOT NULL,
 provincia_res                   NUMBER(3,0)      NOT NULL,
 comune_res                      NUMBER(3,0)      NOT NULL,
 cap                             VARCHAR(5)       NOT NULL,
 codice_attivita                 VARCHAR(5)       NOT NULL,
 codice_fiscale                  VARCHAR(16)      NOT NULL,
 partita_iva                     VARCHAR(11)      NOT NULL,
 nota_gestione                   VARCHAR(15)      NULL,
 nota_gestione_al1               VARCHAR(15)      NULL,
 nota_gestione_al2               VARCHAR(15)      NULL,
 nota_settore_a                  VARCHAR(15)      NULL,
 nota_settore_a_al1              VARCHAR(15)      NULL,
 nota_settore_a_al2              VARCHAR(15)      NULL,
 nota_settore_b                  VARCHAR(15)      NULL,
 nota_settore_b_al1              VARCHAR(15)      NULL,
 nota_settore_b_al2              VARCHAR(15)      NULL,
 nota_settore_c                  VARCHAR(15)      NULL,
 nota_settore_c_al1              VARCHAR(15)      NULL,
 nota_settore_c_al2              VARCHAR(15)      NULL,
 nota_settore                    VARCHAR(15)      NULL,
 nota_settore_al1                VARCHAR(15)      NULL,
 nota_settore_al2                VARCHAR(15)      NULL,
 nota_sede                       VARCHAR(15)      NULL,
 nota_sede_al1                   VARCHAR(15)      NULL,
 nota_sede_al2                   VARCHAR(15)      NULL,
 detrazioni                      VARCHAR(1)       NOT NULL,
 ratei                           VARCHAR(1)       NOT NULL,
 scad_cong                       VARCHAR(1)       NOT NULL,
 rest_cong                       VARCHAR(1)       NOT NULL,
 base_cong                       VARCHAR(1)       NOT NULL,
 mesi_irpef                      NUMBER(2,0)      NOT NULL,
 variabili_gepe                  NUMBER(1,0)      NULL,
 variabili_gape                  NUMBER(1,0)      NULL,
 periodo_ggpe                    VARCHAR(1)       NOT NULL,
 delibere                        VARCHAR(2)       NOT NULL,
 incentivazione                  VARCHAR(2)       NOT NULL,
 economica                       VARCHAR(2)       NOT NULL,
 pianta_organica                 VARCHAR(2)       NOT NULL,
 assenze                         VARCHAR(2)       NOT NULL,
 concorsi                        VARCHAR(2)       NOT NULL,
 giuridica                       VARCHAR(2)       NOT NULL,
 legame_po                       VARCHAR(2)       NOT NULL,
 variabili_gipe                  NUMBER(1,0)      NULL,
 tel_res                         VARCHAR(12)      NULL,
 rate_addizionali                NUMBER(2,0)      NOT NULL,
 detrazioni_ap                   VARCHAR(2)       NOT NULL,
 d_min_con                       DATE             NULL,
 fax_res                         VARCHAR(12)      NULL,
 e_mail                          VARCHAR(2000)    NULL,
 riferimento_modulo_ap           NUMBER(1)        NULL,
 prg_cedolino                    NUMBER(10)       NULL,
 contabilita                     VARCHAR(1)       NULL,
 controllo_gestione              VARCHAR2(2)      NOT NULL,
 esercizio                       NUMBER(4)        NULL,
 MODIFICHE_DO                    VARCHAR2 (2)     NULL, 
 PERC_GRLI_I                     NUMBER (5,2)     NULL, 
 PERC_GRLI_D                     NUMBER (5,2)     NULL, 
 PERC_GRLI_L                     NUMBER (5,2)     NULL,
 CF_SOFTWARE                     VARCHAR2(16)     NULL,
 RILEVAZIONE_PRESENZE            VARCHAR2(1)      DEFAULT 'C' NOT NULL
      constraint RILEVAZIONE_PRESENZE_CC check (RILEVAZIONE_PRESENZE in ('C','M','N')) ,
 CHIUSURA_RAIN                   VARCHAR2(2)      DEFAULT 'SI' NOT NULL,
 CALCOLO_IRPEF                   VARCHAR2(1)      DEFAULT 'A' NOT NULL,
 CALCOLO_CAFA                    VARCHAR2(2)      NOT NULL,
 OGGETTO_E_MAIL                  VARCHAR2(2000)   NULL,
 CORPO_E_MAIL                    VARCHAR2(2000)   NULL,
 DIVIDI_PEGI_IN_VALIDAZIONE      VARCHAR2(2)      default 'NO',
 INVIO_CEDOLINO                  VARCHAR2(1)      DEFAULT 'P',
 PUBBLICAZIONE_CEDOLINO          NUMBER(1),
 SAC                             VARCHAR2(2)      default 'NO'
)
;

COMMENT ON TABLE ente
    IS 'ENTE - Dati anagrafici e fiscali dell"ente';

comment on column ENTE.DIVIDI_PEGI_IN_VALIDAZIONE
  is 'Se SI, in validazione di revisione di struttura, vengono spezzati i periodi giuridici a cavallo della data REVISIONI_STRUTTURA.DAL';
  
comment on column ENTE.SAC
  is 'Se SI, indica che ? attiva la gestione del salario accessorio';


REM
REM 
REM
PROMPT
PROMPT Creating Index ENTE_PK on Table ENTE
CREATE UNIQUE INDEX ENTE_PK ON ENTE
(
      ente_id )
PCTFREE  10
;

REM
REM  End of command file
REM
