/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     30/12/2003 12.07.29                          */
/*==============================================================*/


/*==============================================================*/
/* Table: ALIQUOTE_INAIL                                        */
/*==============================================================*/


create table ALIQUOTE_INAIL  (
   POSIZIONE_INAIL      VARCHAR2(4)                      not null,
   ANNO                 NUMBER(4)                        not null,
   ALQ_PRESUNTA         NUMBER(8,5),
   ALQ_EFFETTIVA        NUMBER(8,5),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
);

comment on table ALIQUOTE_INAIL is
'Registrazione storica delle aliquote applicate dall''INAIL';

/*==============================================================*/
/* Index: ALIQUOTE_INAIL_PK                                     */
/*==============================================================*/
create unique index ALIQUOTE_INAIL_PK on ALIQUOTE_INAIL (
   POSIZIONE_INAIL ASC,
   ANNO ASC
);

