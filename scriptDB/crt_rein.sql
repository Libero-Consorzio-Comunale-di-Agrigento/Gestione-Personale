/*==============================================================*/
/* Table: RETRIBUZIONI_INAIL                                    */
/*==============================================================*/


create table RETRIBUZIONI_INAIL  (
  IMIN_ID             NUMBER                    NOT NULL,
  CI                  NUMBER(8)                 NOT NULL,
  ANNO                NUMBER(4)                 NOT NULL,
  GESTIONE            VARCHAR2(8)               NOT NULL,
  POSIZIONE_INAIL     VARCHAR2(4)               NOT NULL,
  ESENZIONE           VARCHAR2(4),
  CAPITOLO            VARCHAR2(14),
  ARTICOLO            VARCHAR2(14),
  CONTO               VARCHAR2(2),
  CDC                 VARCHAR2(8),
  TIPO_IPN            VARCHAR2(1)               NOT NULL,
  IMPONIBILE          NUMBER(12,2),
  PREMIO              NUMBER(12,2),
  MANUALE             VARCHAR2(1),
  UTENTE              VARCHAR2(8),
  DATA_AGG            DATE,
  FUNZIONALE          VARCHAR2(8),
  RUOLO               VARCHAR2(4),
  RISORSA_INTERVENTO  VARCHAR2(7),
  IMPEGNO             NUMBER(5),
  ANNO_IMPEGNO        NUMBER(4),
  SUB_IMPEGNO         NUMBER(5),
  ANNO_SUB_IMPEGNO    NUMBER(4),
  CODICE_SIOPE        NUMBER(4)
);

comment on table RETRIBUZIONI_INAIL is
'Registrazione storica degli imponibili individuali, raggruppati per esigenza di calcolo dei premi e dell''imputazione contabile';

comment on column RETRIBUZIONI_INAIL.IMIN_ID is
'Chiave primaria fittizia (progressivo numerico)';

comment on column RETRIBUZIONI_INAIL.ESENZIONE is
'Codice di esenzione, determinata per difetto da ESENZIONI_INAIL';

comment on column RETRIBUZIONI_INAIL.RUOLO is
'Ruolo di bilancio';

comment on column RETRIBUZIONI_INAIL.FUNZIONALE is
'Classificazione Funzionale';

comment on column RETRIBUZIONI_INAIL.TIPO_IPN is
'P=Preventivo, C=Consuntivo';

comment on column RETRIBUZIONI_INAIL.MANUALE is
'X o null, indica la forzatura manuale del record';

/*==============================================================*/
/* Index: RETRIBUZIONI_INAIL_PK                                 */
/*==============================================================*/
create unique index RETRIBUZIONI_INAIL_PK on RETRIBUZIONI_INAIL (
   IMIN_ID ASC
);

/*==============================================================*/
/* Index: REIN_ALIN_FK                                          */
/*==============================================================*/
create index REIN_ALIN_FK on RETRIBUZIONI_INAIL (
   POSIZIONE_INAIL ASC,
   ANNO ASC
);

/*==============================================================*/
/* Index: REIN_CECO_FK                                          */
/*==============================================================*/
create index REIN_CECO_FK on RETRIBUZIONI_INAIL (
   CDC ASC
);

/*==============================================================*/
/* Index: REIN_CLFU_FK                                          */
/*==============================================================*/
create index REIN_CLFU_FK on RETRIBUZIONI_INAIL (
   FUNZIONALE ASC
);

/*==============================================================*/
/* Index: REIN_AK                                          */
/*==============================================================*/
create index rein_ak on retribuzioni_inail
(ci,anno,tipo_ipn);

