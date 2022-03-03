/*==============================================================*/
/* Table: VARIAZIONI                                            */
/*==============================================================*/

create table VARIAZIONI (
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
   DATA_AGG             DATE                             not null,
   AGGIORNATO           NUMBER(1)                        not null
)
/


comment on table VARIAZIONI is
'Tabella nella quale è possibile reperire tutte le modifche effettuate nel formato richiesto dall''ambiente esterno'
/


/*==============================================================*/
/* Index: VARI_PK                                               */
/*==============================================================*/
create index VARI_PK
on VARIAZIONI (
   ID_VARIAZIONE,
   PROGRESSIVO 
)
/