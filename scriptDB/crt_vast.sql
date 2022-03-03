/*==============================================================*/
/* Table: VARIAZIONI_STORICHE                                   */
/*==============================================================*/

create table VARIAZIONI_STORICHE (
   ID_VARIAZIONE        NUMBER                           not null,
   PROGRESSIVO          NUMBER                           not null,
   OPERAZIONE           VARCHAR2(1)                      not null,
   TABELLA              VARCHAR2(30)                     not null,
   COLONNA              VARCHAR2(30)                     not null,
   VALORE               VARCHAR2(4000),
   VALORE_PRECEDENTE    VARCHAR2(4000),
   CAUSALE              VARCHAR2(1)                      not null,
   MODIFICATO           NUMBER(1)                        not null,
   USER_PROVENIENZA     VARCHAR2(30)                     not null,
   USER_DESTINAZIONE    VARCHAR2(30)                     not null,
   DATA_AGG             DATE                             not null
)
/


comment on table VARIAZIONI_STORICHE is
'Storico della tabella nella quale è possibile reperire tutte le modifche effettuate nel formato richiesto dall''ambiente esterno'
/


/*==============================================================*/
/* Index: VAST_PK                                               */
/*==============================================================*/
create index VAST_PK
on VARIAZIONI_STORICHE (
   ID_VARIAZIONE,
   PROGRESSIVO 
)
/
