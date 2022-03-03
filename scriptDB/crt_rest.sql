/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     28/10/2002 15.09.14                          */
/*==============================================================*/


/*==============================================================*/
/* Table: REVISIONI_STRUTTURA                                   */
/*==============================================================*/

create table REVISIONI_STRUTTURA (
   REVISIONE            NUMBER(8)                        not null,
   OTTICA               VARCHAR2(4)                      not null,
   TIPO_REGISTRO        VARCHAR2(1),
   ANNO                 NUMBER(4),
   NUMERO               NUMBER(8),
   DESCRIZIONE          VARCHAR2(120),
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120),
   DATA                 DATE,
   DAL                  DATE,
   NOTE                 VARCHAR2(2000),
   STATO                VARCHAR2(1),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
)
/


/*==============================================================*/
/* Index: REVISIONI_STRUTTURA_PK                                */
/*==============================================================*/
create unique index REVISIONI_STRUTTURA_PK
on REVISIONI_STRUTTURA (
   REVISIONE ASC,
   OTTICA ASC
)
/


/*==============================================================*/
/* Index: REVISIONI_STRUTTURA_AK                                */
/*==============================================================*/
create index REVISIONI_STRUTTURA_AK
on REVISIONI_STRUTTURA (STATO)
/



/*==============================================================*/
/* Index: REST_DOCU_FK                                          */
/*==============================================================*/
create  index REST_DOCU_FK
on REVISIONI_STRUTTURA (
   TIPO_REGISTRO ASC,
   ANNO ASC,
   NUMERO ASC
)
/


