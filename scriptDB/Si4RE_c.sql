/*==============================================================*/
/* Database name:  REGISTRO                                     */
/* DBMS name:      ORACLE V8 Version for Si4                    */
/* Created on:     17/10/2002 17.52.58                          */
/*==============================================================*/


/*==============================================================*/
/* Table: REGISTRO                                              */
/*==============================================================*/


create table REGISTRO  (
   CHIAVE               VARCHAR2(512)                    not null,
   STRINGA              VARCHAR2(100)                    not null,
   COMMENTO             VARCHAR2(2000),
   VALORE               VARCHAR2(2000),
   constraint REGISTRO_PK primary key (CHIAVE, STRINGA)
)
/


