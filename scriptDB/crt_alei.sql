/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     30/12/2003 12.07.29                          */
/*==============================================================*/


/*==============================================================*/
/* Table: ALIQUOTE_ESENZIONE_INAIL                              */
/*==============================================================*/


create table ALIQUOTE_ESENZIONE_INAIL  (
   ESENZIONE            VARCHAR2(4)                      not null,
   ANNO                 NUMBER(4)                        not null,
   ALIQUOTA             NUMBER(5,2)                      not null,
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
);

comment on table ALIQUOTE_ESENZIONE_INAIL is
'Registrazione storica delle aliquote di esenzione';

comment on column ALIQUOTE_ESENZIONE_INAIL.ESENZIONE is
'Codice di esenzione';

/*==============================================================*/
/* Index: ALIQUOTE_ESENZIONE_INAIL_PK                           */
/*==============================================================*/
create unique index ALIQUOTE_ESENZIONE_INAIL_PK on ALIQUOTE_ESENZIONE_INAIL (
   ESENZIONE ASC,
   ANNO ASC
);

/*==============================================================*/
/* Index: ALEI_ESIN_FK                                          */
/*==============================================================*/
create index ALEI_ESIN_FK on ALIQUOTE_ESENZIONE_INAIL (
   ESENZIONE ASC
);

