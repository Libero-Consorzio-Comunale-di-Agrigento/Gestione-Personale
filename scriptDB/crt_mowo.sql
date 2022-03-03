/*==============================================================*/
/* Table: MODELLI_WORD                                          */
/*==============================================================*/

create table MODELLI_WORD (
   CODICE            VARCHAR2(30) NOT NULL,
   DESCRIZIONE       VARCHAR2(120)    NULL,
   DESCRIZIONE_AL1   VARCHAR2(120)    NULL,
   DESCRIZIONE_AL2   VARCHAR2(120)    NULL
)
/


comment on table MODELLI_WORD is
'Tabella nella quale è possibile definire le tipologie dei documenti word'
/


/*==============================================================*/
/* Index: MOWO_PK                                               */
/*==============================================================*/
create unique index MOWO_PK
on MODELLI_WORD (
   CODICE
)
/