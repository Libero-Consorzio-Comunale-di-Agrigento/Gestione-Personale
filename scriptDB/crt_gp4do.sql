/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     13/02/2003 10.34.09                          */
/*==============================================================*/


/*==============================================================*/
/* Table: AREE                                                  */
/*==============================================================*/

create table AREE (
   AREA                 VARCHAR2(8)                      not null,
   DESCRIZIONE          VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120),
   DESCRIZIONE_AL1      VARCHAR2(120),
   SEQUENZA             NUMBER(6)
)
/


/*==============================================================*/
/* Index: AREE_PK                                               */
/*==============================================================*/
create unique index AREE_PK
on AREE (
   AREA ASC
)
/


/*==============================================================*/
/* Table: DOTAZIONE_ORGANICA                                    */
/*==============================================================*/

create table DOTAZIONE_ORGANICA (
   REVISIONE            NUMBER(8)                        not null,
   GESTIONE             VARCHAR2(4)                      not null,
   AREA                 VARCHAR2(8)                      not null,
   SETTORE              VARCHAR2(15)                     not null,
   RUOLO                VARCHAR2(4)                      not null,
   PROFILO              VARCHAR2(4)                      not null,
   POSIZIONE            VARCHAR2(4)                      not null,
   ATTIVITA             VARCHAR2(4)                      not null,
   FIGURA               VARCHAR2(8)                      not null,
   QUALIFICA            VARCHAR2(8)                      not null,
   LIVELLO              VARCHAR2(4)                      not null,
   TIPO_RAPPORTO        VARCHAR2(4)                      not null,
   ORE                  NUMBER,
   NUMERO               NUMBER(8),
   NUMERO_ORE           NUMBER(9,2),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE,
   TIPO                 VARCHAR2(1),
   DOOR_ID              NUMBER (10)
)
storage
(
    initial &1DIMx400
    next &1DIMx200
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: DOTAZIONE_ORGANICA_PK                                 */
/*==============================================================*/
create unique index DOTAZIONE_ORGANICA_PK
on DOTAZIONE_ORGANICA (
   REVISIONE ASC,
   DOOR_ID ASC
)
storage
(
    initial &1DIMx400
    next &1DIMx200
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: DOOR_REDO_FK                                          */
/*==============================================================*/
create  index DOOR_REDO_FK
on DOTAZIONE_ORGANICA (
   REVISIONE ASC
)
/


/*==============================================================*/
/* Table: REVISIONI_DOTAZIONE                                   */
/*==============================================================*/

create table REVISIONI_DOTAZIONE (
   REVISIONE            NUMBER(8)                        not null,
   DESCRIZIONE          VARCHAR2(120)                    not null,
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120),
   NOTE                 VARCHAR2(2000),
   DAL                  DATE                             not null,
   DATA                 DATE                             ,
   SEDE_DEL             VARCHAR2(4),
   NUMERO_DEL           NUMBER(8),
   ANNO_DEL             NUMBER(4),
   STATO                VARCHAR2(1),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
)
/


/*==============================================================*/
/* Index: REVISIONI_DOTAZIONE_PK                                */
/*==============================================================*/
create unique index REVISIONI_DOTAZIONE_PK
on REVISIONI_DOTAZIONE (
   REVISIONE ASC
)
/


/*==============================================================*/
/* Table: RIFERIMENTO_DOTAZIONE                                 */
/*==============================================================*/

create table RIFERIMENTO_DOTAZIONE (
   DATA                 DATE                             not null,
   UTENTE               VARCHAR2(8)                      not null
)
/


/*==============================================================*/
/* Index: RIFERIMENTO_DOTAZIONE_PK                              */
/*==============================================================*/
create unique index RIFERIMENTO_DOTAZIONE_PK
on RIFERIMENTO_DOTAZIONE (
   UTENTE ASC
)
/

/*==============================================================*/
/* Table: SOSTITUZIONI_GIURIDICHE                               */
/*==============================================================*/

start crt_sogi.sql

/*==============================================================*/
/* Table: DOTAZIONE_ESAURIMENTO                                 */
/*==============================================================*/

start crt_does.sql

/*==============================================================*/
/* Table: GRUPPI_DOTAZIONE                                */
/*==============================================================*/

start crt_grdo.sql

/*==============================================================*/
/* Table: RIGHE_GRUPPI_DOTAZIONE                                */
/*==============================================================*/

start crt_rgdo.sql

/*==============================================================*/
/* Table: RIPARTIZIONE_GRUPPI_DOTAZIONE                        */
/*==============================================================*/

start crt_rigd.sql


/*==============================================================*/
/* Table: CALCOLI_DO                                            */
/*==============================================================*/

start crt_calo.sql
