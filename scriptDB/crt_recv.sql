/*==============================================================*/
/* Table: REGOLE_CONVERSIONI                                    */
/*==============================================================*/

create table REGOLE_CONVERSIONI (
   USER_PROVENIENZA     VARCHAR2(30) not null,
   TABELLA_PROVENIENZA  VARCHAR2(30) not null,
   COLONNA_PROVENIENZA  VARCHAR2(30) not null,
   USER_DESTINAZIONE    VARCHAR2(30) not null,
   TABELLA_DESTINAZIONE VARCHAR2(30),
   COLONNA_DESTINAZIONE VARCHAR2(30),
   CODIFICA_VALORE      VARCHAR2(4000),
   CODIFICA_VALORE_PRECEDENTE VARCHAR2(4000)
)
/


comment on table REGOLE_CONVERSIONI is
'Tabella nella quale vengono definite le corrispondenze tra gli oggetti dei due ambienti'
/


/*==============================================================*/
/* Index: RECV_PK                                               */
/*==============================================================*/
create index RECV_PK
on REGOLE_CONVERSIONI (
   USER_PROVENIENZA,
   TABELLA_PROVENIENZA ,
   COLONNA_PROVENIENZA 
)
/
