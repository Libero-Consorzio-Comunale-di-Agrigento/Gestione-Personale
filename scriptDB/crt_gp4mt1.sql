/*==============================================================*/
/* Table: RICHIESTE_RIMBORSO                                    */
/*==============================================================*/


create table RICHIESTE_RIMBORSO  (
   RIRI_ID              NUMBER(8)                        not null,
   CI                   NUMBER(8),
   DATA_INIZIO          DATE,
   COMUNE_INIZIO        NUMBER(3),
   PROVINCIA_INIZIO     NUMBER(3),
   DATA_FINE            DATE,
   COMUNE_FINE          NUMBER(3),
   PROVINCIA_FINE       NUMBER(3),
   COD_RECORD           NUMBER(1),
   STATO_RICHIESTA      VARCHAR2(4)                      not null,
   SEQUENZA             NUMBER(2),
   TIPO_MISSIONE        VARCHAR2(4)                      not null,
   DATA_ACCONTO         DATE,
   NUMERO_ACCONTO       NUMBER(8),
   IMPORTO_ACCONTO      NUMBER(12,2),
   PRIMA_RICHIESTA      NUMBER(8),
   NOTE_1               VARCHAR2(2000),
   NOTE_1_AL1           VARCHAR2(2000),
   NOTE_1_AL2           VARCHAR2(2000),
   NOTE_2               VARCHAR2(2000),
   NOTE_2_AL1           VARCHAR2(2000),
   NOTE_2_AL2           VARCHAR2(2000),
   DATA_DISTINTA        DATE,
   NUMERO_DISTINTA      NUMBER(8),
   RIFERIMENTO_ECONOMICO DATE,
   DATA_AGG             DATE,
   UTENTE               VARCHAR2(8),
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
/* Index: RIRI_TIMI_FK                                          */
/*==============================================================*/
create index RIRI_TIMI_FK on RICHIESTE_RIMBORSO (
   TIPO_MISSIONE ASC
);

/*==============================================================*/
/* Index: RIRI_IK                                               */
/*==============================================================*/
create index RIRI_IK on RICHIESTE_RIMBORSO (
   CI ASC
);

/*==============================================================*/
/* Index: RIRI_IK2                                              */
/*==============================================================*/
create index RIRI_IK2 on RICHIESTE_RIMBORSO (
   PRIMA_RICHIESTA ASC
);

/*==============================================================*/
/* Index: RICHIESTE_RIMBORSO_PK                                 */
/*==============================================================*/
create unique index RICHIESTE_RIMBORSO_PK on RICHIESTE_RIMBORSO (
   RIRI_ID ASC
);

/*==============================================================*/
/* Index: RIRI_ACER_FK                                          */
/*==============================================================*/
create index RIRI_ACER_FK on RICHIESTE_RIMBORSO (
   CI ASC,
   DATA_ACCONTO ASC,
   NUMERO_ACCONTO ASC
);

/*==============================================================*/
/* Index: RIRI_STRR_FK                                          */
/*==============================================================*/
create index RIRI_STRR_FK on RICHIESTE_RIMBORSO (
   STATO_RICHIESTA ASC
);
