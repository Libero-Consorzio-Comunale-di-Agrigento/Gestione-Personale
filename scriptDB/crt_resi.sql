/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     30/12/2003 12.07.29                          */
/*==============================================================*/


/*==============================================================*/
/* Table: RIGHE_ESENZIONE_INAIL                                 */
/*==============================================================*/


create table RIGHE_ESENZIONE_INAIL  (
   ESIN_ID              NUMBER                           not null,
   ESENZIONE            VARCHAR2(4)                      not null,
   ANNO                 NUMBER(4)                        not null,
   POSIZIONE            VARCHAR2(4),
   TRATTAMENTO          VARCHAR2(4),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
);

comment on table RIGHE_ESENZIONE_INAIL is
'Definizione delle associazioni dei codici di esenzione alla posizione giuridica e al trattamento previdenziale';

comment on column RIGHE_ESENZIONE_INAIL.ESIN_ID is
'Progressivo numerico';

comment on column RIGHE_ESENZIONE_INAIL.ESENZIONE is
'Codice di esenzione';

comment on column RIGHE_ESENZIONE_INAIL.POSIZIONE is
'Posizione Giuridica';

comment on column RIGHE_ESENZIONE_INAIL.TRATTAMENTO is
'Trattamento Previdenziale';

/*==============================================================*/
/* Index: RIGHE_ESENZIONE_INAIL_PK                              */
/*==============================================================*/
create unique index RIGHE_ESENZIONE_INAIL_PK on RIGHE_ESENZIONE_INAIL (
   ESIN_ID ASC
);

/*==============================================================*/
/* Index: RESI_TRPR_FK                                          */
/*==============================================================*/
create index RESI_TRPR_FK on RIGHE_ESENZIONE_INAIL (
   TRATTAMENTO ASC
);

/*==============================================================*/
/* Index: RESI_POSI_FK                                          */
/*==============================================================*/
create index RESI_POSI_FK on RIGHE_ESENZIONE_INAIL (
   POSIZIONE ASC
);

/*==============================================================*/
/* Index: RESI_ESIN_FK                                          */
/*==============================================================*/
create index RESI_ESIN_FK on RIGHE_ESENZIONE_INAIL (
   ESENZIONE ASC
);

