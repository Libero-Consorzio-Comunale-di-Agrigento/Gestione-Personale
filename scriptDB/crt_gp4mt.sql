/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4)                     */
/* Created on:     16/04/2004 11:45:30                          */
/*==============================================================*/


/*==============================================================*/
/* Table: ACCONTI_EROGATI                                       */
/*==============================================================*/


create table ACCONTI_EROGATI  (
   CI                   NUMBER(8)                        not null,
   DATA_ACCONTO         DATE                             not null,
   NUMERO_ACCONTO       NUMBER(8)                        not null,
   IMPORTO              NUMBER(12,2),
   RIRI_ID              NUMBER(8)
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
/* Index: ACER_RIRI_FK2                                         */
/*==============================================================*/
create index ACER_RIRI_FK2 on ACCONTI_EROGATI (
   RIRI_ID ASC
);

/*==============================================================*/
/* Index: ACCONTI_EROGATI_PK                                    */
/*==============================================================*/
create unique index ACCONTI_EROGATI_PK on ACCONTI_EROGATI (
   CI ASC,
   DATA_ACCONTO ASC,
   NUMERO_ACCONTO ASC
);

/*==============================================================*/
/* Table: LIMITI_IMPORTO_SPESA                                  */
/*==============================================================*/


create table LIMITI_IMPORTO_SPESA  (
   TIPO_SPESA           VARCHAR2(4)                      not null,
   GESTIONE             VARCHAR2(8)                      not null,
   CONTRATTO            VARCHAR2(4)                      not null,
   QUALIFICA            VARCHAR2(8)                      not null,
   LIVELLO              VARCHAR2(4)                      not null,
   DAL                  DATE                             not null,
   AL                   DATE,
   IMPORTO_MASSIMALE    NUMBER(12,2)
);

/*==============================================================*/
/* Index: LIMITI_IMPORTO_SPESA_PK                               */
/*==============================================================*/
create unique index LIMITI_IMPORTO_SPESA_PK on LIMITI_IMPORTO_SPESA (
   TIPO_SPESA ASC,
   GESTIONE ASC,
   CONTRATTO ASC,
   QUALIFICA ASC,
   LIVELLO ASC,
   DAL ASC
);

/*==============================================================*/
/* Index: LIIS_TISP_FK                                          */
/*==============================================================*/
create index LIIS_TISP_FK on LIMITI_IMPORTO_SPESA (
   TIPO_SPESA ASC
);

/*==============================================================*/
/* Table: PARAMETRI_MISSIONI                                    */
/*==============================================================*/


create table PARAMETRI_MISSIONI  (
   SE_MODIFICA_RICHIESTE_IN_EC NUMBER(1),
   SE_GESTIONE_ACCONTI  NUMBER(1),
   VOCE_ECONOMICA_ACCONTO VARCHAR2(10),
   SUB_ACCONTO          VARCHAR2(2),
   SEGNO_ACCONTO_IN_EC  VARCHAR2(1),
   MINUTI_ARROTONDAMENTO NUMBER(2)
);


/*==============================================================*/
/* Table: REGOLE_DIARIA                                         */
/*==============================================================*/


create table REGOLE_DIARIA  (
   REDI_ID              NUMBER(8)                        not null,
   GESTIONE             VARCHAR2(8),
   CONTRATTO            VARCHAR2(4),
   MIN_ORE              NUMBER(4),
   MAX_ORE              NUMBER(4),
   SE_RIMBORSO_ALLOGGIO NUMBER(1),
   SE_RIMBORSO_VITTO    NUMBER(1),
   PERC_DIARIA          NUMBER(5,2)
);

/*==============================================================*/
/* Index: REGOLE_DIARIA_PK                                      */
/*==============================================================*/
create unique index REGOLE_DIARIA_PK on REGOLE_DIARIA (
   REDI_ID ASC
);

/*==============================================================*/
/* Index: RIDI_IK                                               */
/*==============================================================*/
create index RIDI_IK on REGOLE_DIARIA (
   GESTIONE ASC,
   CONTRATTO ASC
);


/*==============================================================*/
/* Table: TARIFFE                                               */
/*==============================================================*/


create table TARIFFE  (
   TIPO_SPESA           VARCHAR2(4)                      not null,
   GESTIONE             VARCHAR2(8)                      not null,
   CONTRATTO            VARCHAR2(4)                      not null,
   QUALIFICA            VARCHAR2(8)                      not null,
   LIVELLO              VARCHAR2(4)                      not null,
   DAL                  DATE                             not null,
   AL                   DATE,
   TARIFFA              NUMBER(15,5)
);

/*==============================================================*/
/* Index: TARIFFE_PK                                            */
/*==============================================================*/
create unique index TARIFFE_PK on TARIFFE (
   TIPO_SPESA ASC,
   GESTIONE ASC,
   CONTRATTO ASC,
   QUALIFICA ASC,
   LIVELLO ASC,
   DAL ASC
);

/*==============================================================*/
/* Index: TARI_TISP_FK                                          */
/*==============================================================*/
create index TARI_TISP_FK on TARIFFE (
   TIPO_SPESA ASC
);

/*==============================================================*/
/* Table: TIPI_MISSIONE                                         */
/*==============================================================*/


create table TIPI_MISSIONE  (
   TIPO_MISSIONE        VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(30),
   DESCRIZIONE_AL1      VARCHAR2(30),
   DESCRIZIONE_AL2      VARCHAR2(30),
   SE_DIARIA            NUMBER(1),
   SE_DIARIA_IN_COMUNE_LAVORO NUMBER(1),
   SE_DIARIA_IN_COMUNE_RESIDENZA NUMBER(1),
   MIN_GG_PER_DIARIA_SUL_TOTALE NUMBER(2)
);

/*==============================================================*/
/* Index: TIPI_MISSIONE_PK                                      */
/*==============================================================*/
create unique index TIPI_MISSIONE_PK on TIPI_MISSIONE (
   TIPO_MISSIONE ASC
);

/*==============================================================*/
/* Table: TIPI_SPESA                                            */
/*==============================================================*/


create table TIPI_SPESA  (
   TIPO_SPESA           VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(30),
   DESCRIZIONE_AL1      VARCHAR2(30),
   DESCRIZIONE_AL2      VARCHAR2(30),
   DAL                  DATE                             not null,
   AL                   DATE,
   SEQUENZA             NUMBER(3),
   VOCE_ECONOMICA       VARCHAR2(10),
   SUB                  VARCHAR2(2),
   CAUSALE_SPESA        VARCHAR2(2),
   SE_ESTREMI_DOC       NUMBER(1),
   SE_TARIFFA           NUMBER(1),
   SE_QTA               NUMBER(1),
   SE_LIQUIDABILE       NUMBER(1),
   SE_SOSTITUIBILE_DA_FORFAIT NUMBER(1),
   PERC_MAGGIORAZIONE   NUMBER(5,2),
   MINIMALE_ORARIO      NUMBER(4),
   NOTE                 VARCHAR2(2000),
   NOTE_AL1             VARCHAR2(2000),
   NOTE_AL2             VARCHAR2(2000)
);

/*==============================================================*/
/* Index: TIPI_SPESA_PK                                         */
/*==============================================================*/
create unique index TIPI_SPESA_PK on TIPI_SPESA (
   TIPO_SPESA ASC,
   DAL ASC
);

