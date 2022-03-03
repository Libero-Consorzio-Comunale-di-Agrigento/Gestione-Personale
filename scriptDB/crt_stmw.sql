/*==============================================================*/
/* Table: STRUTTURA_MODELLI_WORD                                */
/*==============================================================*/

create table STRUTTURA_MODELLI_WORD (
   DOCUMENTO       VARCHAR2(30)   NOT NULL,
   PARAGRAFO       VARCHAR2(30)   NOT NULL,
   VISTA           VARCHAR2(30)   NOT NULL,
   CONDIZIONI      VARCHAR2(2000) NULL,
   SOTTODOCUMENTO  VARCHAR2(120)  NOT NULL,
   SEQUENZA        NUMBER
)
/

comment on table STRUTTURA_MODELLI_WORD is
'Tabella nella quale è possibile definire le tipologie dei documenti word'
/


/*==============================================================*/
/* Index: STMW_PK                                               */
/*==============================================================*/
create unique index STMW_PK
on STRUTTURA_MODELLI_WORD (
   DOCUMENTO, 
   PARAGRAFO
)
/