/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     30/12/2003 12.07.29                          */
/*==============================================================*/


/*==============================================================*/
/* Table: ESENZIONI_INAIL                                       */
/*==============================================================*/


create table ESENZIONI_INAIL  (
   ESENZIONE            VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(120)                    not null,
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
);

comment on table ESENZIONI_INAIL is
'Definizione dei codici di esenzione, da applicare agli imponibili individuali in base alla posizione giuridica e al trattamento previdenziale';

comment on column ESENZIONI_INAIL.ESENZIONE is
'Codice di esenzione';

/*==============================================================*/
/* Index: ESENZIONI_INAIL_PK                                    */
/*==============================================================*/
create unique index ESENZIONI_INAIL_PK on ESENZIONI_INAIL (
   ESENZIONE ASC
);

