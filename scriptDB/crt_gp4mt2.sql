/*==============================================================*/
/* Table: RIGHE_RICHIESTA_RIMBORSO                              */
/*==============================================================*/

create table RIGHE_RICHIESTA_RIMBORSO  (
   RIRR_ID              NUMBER(8)                        not null,
   RIRI_ID              NUMBER(8)                        not null,
   RIFERIMENTO_RIGA     NUMBER(8),
   PROGRESSIVO          NUMBER(4),
   TIPO_SPESA           VARCHAR2(4)                      not null,
   DATA_DOCUMENTO       DATE,
   NUMERO_DOCUMENTO     NUMBER(8),
   TARIFFA              NUMBER(15,5),
   QUANTITA             NUMBER(5,2),
   IMPORTO              NUMBER(12,2),
   IMPORTO_MAGGIORAZIONE NUMBER(12,2),
   NOTE                 VARCHAR2(2000),
   NOTE_AL1             VARCHAR2(2000),
   NOTE_AL2             VARCHAR2(2000),
   BUTTON_DIARIA        NUMBER(1)                      default 0,
   SEDE_DEL               VARCHAR2(4),
   NUMERO_DEL             NUMBER(7),
   ANNO_DEL               NUMBER(4),
   RISORSA_INTERVENTO     VARCHAR2(7),
   CAPITOLO               VARCHAR2(14),
   ARTICOLO               VARCHAR2(14),
   CONTO                  VARCHAR2(2),
   IMPEGNO                NUMBER(5),
   ANNO_IMPEGNO           NUMBER(4),
   SUB_IMPEGNO            NUMBER(5),
   ANNO_SUB_IMPEGNO       NUMBER(4),
   CODICE_SIOPE           NUMBER(4)
)
storage
(
    initial &1DIMx2k
    next &1DIMx1k
    minextents 1
    maxextents 99
    pctincrease 50
);

/*==============================================================*/
/* Index: RIRR_RIRI_FK                                          */
/*==============================================================*/
create index RIRR_RIRI_FK on RIGHE_RICHIESTA_RIMBORSO (
   RIRI_ID ASC
);

/*==============================================================*/
/* Index: RIRR_TISP_FK                                          */
/*==============================================================*/
create index RIRR_TISP_FK on RIGHE_RICHIESTA_RIMBORSO (
   TIPO_SPESA ASC
);

/*==============================================================*/
/* Index: RIGHE_RICHIESTA_RIMBORSO_PK                           */
/*==============================================================*/
create unique index RIGHE_RICHIESTA_RIMBORSO_PK on RIGHE_RICHIESTA_RIMBORSO (
   RIRR_ID ASC
);

