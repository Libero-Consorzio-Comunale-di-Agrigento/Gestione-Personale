/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     13/02/2003 11.22.15                          */
/*==============================================================*/


/*==============================================================*/
/* Table: AMMINISTRAZIONI                                       */
/*==============================================================*/

create table AMMINISTRAZIONI (
   CODICE_AMMINISTRAZIONE VARCHAR2(8)                      not null,
   DAL                  DATE                             not null,
   AL                   DATE,
   NI                   NUMBER(8),
   GRUPPO               VARCHAR2(4)
)
/


/*==============================================================*/
/* Index: AMMINISTRAZIONI_PK                                    */
/*==============================================================*/
create unique index AMMINISTRAZIONI_PK
on AMMINISTRAZIONI (
   DAL ASC,
   CODICE_AMMINISTRAZIONE ASC
)
/


/*==============================================================*/
/* Index: AMMI_SOGG_FK                                          */
/*==============================================================*/
create  index AMMI_SOGG_FK
on AMMINISTRAZIONI (
   NI ASC
)
/


/*==============================================================*/
/* Index: AMMI_GRAM_FK                                          */
/*==============================================================*/
create  index AMMI_GRAM_FK
on AMMINISTRAZIONI (
   GRUPPO ASC
)
/


/*==============================================================*/
/* Table: AOO                                                   */
/*==============================================================*/

create table AOO (
  CODICE_AMMINISTRAZIONE  VARCHAR2(8)           	    NOT NULL,
  AMM_DAL                 DATE                  	    NOT NULL,
  CODICE_AOO              VARCHAR2(8)           	    NOT NULL,
  DAL                     DATE                  	    NOT NULL,
  AL                      DATE,
  NI                      NUMBER(8),
  GRUPPO                  VARCHAR2(4),
  ENTE                    VARCHAR2(1)                       NOT NULL
)
/


/*==============================================================*/
/* Index: AOO_PK                                                */
/*==============================================================*/
create unique index AOO_PK
on AOO (
   CODICE_AMMINISTRAZIONE ASC,
   AMM_DAL ASC,
   CODICE_AOO ASC,
   DAL ASC
)
/


/*==============================================================*/
/* Index: AOO_SOGG_FK                                           */
/*==============================================================*/
create  index AOO_SOGG_FK
on AOO (
   NI ASC
)
/


/*==============================================================*/
/* Index: AOO_AMMI_FK                                           */
/*==============================================================*/
create  index AOO_AMMI_FK
on AOO (
   AMM_DAL ASC,
   CODICE_AMMINISTRAZIONE ASC
)
/


/*==============================================================*/
/* Index: AOO_GRAM_FK                                           */
/*==============================================================*/
create  index AOO_GRAM_FK
on AOO (
   GRUPPO ASC
)
/


/*==============================================================*/
/* Table: COMPONENTI                                            */
/*==============================================================*/

create table COMPONENTI (
   COMPONENTE           NUMBER(8)                        not null,
   DAL                  DATE                             not null,
   AL                   DATE,
   CODICE_AMMINISTRAZIONE VARCHAR2(8),
   AMM_DAL              DATE,
   UNITA_OTTICA         VARCHAR2(4),
   UNITA_NI             NUMBER(8),
   UNITA_DAL            DATE,
   DENOMINAZIONE        VARCHAR2(60),
   DENOMINAZIONE_AL1    VARCHAR2(60),
   DENOMINAZIONE_AL2    VARCHAR2(60),
   NI                   NUMBER(8),
   INCARICO             VARCHAR2(4),
   TITOLO               VARCHAR2(4),
   CODICE_FISCALE       VARCHAR2(16),
   TELEFONO             VARCHAR2(20),
   FAX                  VARCHAR2(20),
   E_MAIL               VARCHAR2(2000),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
)
storage
(
    initial &1DIMx500
    next &1DIMx250
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: COMPONENTI_PK                                         */
/*==============================================================*/
create unique index COMPONENTI_PK
on COMPONENTI (
   COMPONENTE ASC,
   DAL ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: COMP_UNOR_FK                                          */
/*==============================================================*/
create  index COMP_UNOR_FK
on COMPONENTI (
   UNITA_NI ASC,
   UNITA_OTTICA ASC,
   UNITA_DAL ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: COMP_SOGG_FK                                          */
/*==============================================================*/
create  index COMP_SOGG_FK
on COMPONENTI (
   NI ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: COMP_TIIN_FK                                          */
/*==============================================================*/
create  index COMP_TIIN_FK
on COMPONENTI (
   INCARICO ASC
)
/


/*==============================================================*/
/* Index: COMP_TITI_FK                                          */
/*==============================================================*/
create  index COMP_TITI_FK
on COMPONENTI (
   TITOLO ASC
)
/


/*==============================================================*/
/* Index: COMP_AMMI_FK                                          */
/*==============================================================*/
create  index COMP_AMMI_FK
on COMPONENTI (
   AMM_DAL ASC,
   CODICE_AMMINISTRAZIONE ASC
)
/

/*==============================================================*/
/* Table: DATI_ANAGRAFICI                                       */
/*==============================================================*/

create table DATI_ANAGRAFICI (
   NI                   NUMBER(8)                        not null,
   DAL                  DATE                             not null,
   STATO_CIVILE         VARCHAR2(4),
   COGNOME_CONIUGE      VARCHAR2(36),
   TITOLO_STUDIO        VARCHAR2(4),
   TITOLO               VARCHAR2(20),
   CATEGORIA_PROTETTA   VARCHAR2(4),
   TESSERA_SAN          VARCHAR2(10),
   NUMERO_USL           VARCHAR2(40),
   PROVINCIA_USL        VARCHAR2(3),
   TIPO_DOC             VARCHAR2(4),
   NUMERO_DOC           VARCHAR2(16),
   PROVINCIA_DOC        NUMBER(3),
   COMUNE_DOC           NUMBER(3),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE,
   AL                   DATE
)
/


/*==============================================================*/
/* Index: DATI_ANAGRAFICI_PK                                    */
/*==============================================================*/
create unique index DATI_ANAGRAFICI_PK
on DATI_ANAGRAFICI (
   NI ASC,
   DAL ASC
)
/

/*==============================================================*/
/* Table: GESTIONI_AMMINISTRATIVE                               */
/*==============================================================*/

create table GESTIONI_AMMINISTRATIVE (
   CODICE               VARCHAR2(8)                      not null,
   NI                   NUMBER(8),
   DENOMINAZIONE        VARCHAR2(60),
   GESTITO              VARCHAR2(2),
   NOTE                 VARCHAR2(2000),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
)
/


/*==============================================================*/
/* Index: GESTIONI_AMMINISTRATIVE_PK                            */
/*==============================================================*/
create unique index GESTIONI_AMMINISTRATIVE_PK
on GESTIONI_AMMINISTRATIVE (
   CODICE ASC
)
/


/*==============================================================*/
/* Index: GEAM_SOGG_FK                                          */
/*==============================================================*/
create  index GEAM_SOGG_FK
on GESTIONI_AMMINISTRATIVE (
   NI ASC
)
/


/*==============================================================*/
/* Table: GRUPPI_AMMINISTRAZIONI                                */
/*==============================================================*/

create table GRUPPI_AMMINISTRAZIONI (
   GRUPPO               VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(120),
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120)
)
/


/*==============================================================*/
/* Index: GRUPPI_AMMINISTRAZIONI_PK                             */
/*==============================================================*/
create unique index GRUPPI_AMMINISTRAZIONI_PK
on GRUPPI_AMMINISTRAZIONI (
   GRUPPO ASC
)
/


/*==============================================================*/
/* Table: ORGANIGRAMMA                                          */
/*==============================================================*/

create table ORGANIGRAMMA (
   UNITA                NUMBER(8),
   UNITA_PADRE          NUMBER(8),
   CI                   NUMBER(9),
   CI_PADRE             NUMBER(9),
   CI_RESPONSABILE      NUMBER(9),
   SEQUENZA             NUMBER(2,1)
)
/


/*==============================================================*/
/* Table: OTTICHE                                               */
/*==============================================================*/

create table OTTICHE (
   OTTICA               VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(120),
   SEQUENZA             NUMBER(6),
   NOTE                 VARCHAR2(2000)
)
/


/*==============================================================*/
/* Index: OTTICHE_PK                                            */
/*==============================================================*/
create unique index OTTICHE_PK
on OTTICHE (
   OTTICA ASC
)
/


/*==============================================================*/
/* Table: REVISIONI_STRUTTURA                                   */
/*==============================================================*/

create table REVISIONI_STRUTTURA (
   REVISIONE            NUMBER(8)                        not null,
   OTTICA               VARCHAR2(4)                      not null,
   SEDE_DEL             VARCHAR2(4),
   ANNO_DEL             NUMBER(4),
   NUMERO_DEL           NUMBER(8),
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
create index REST_DOCU_FK
on REVISIONI_STRUTTURA
( SEDE_DEL ASC,
  ANNO_DEL ASC,
  NUMERO_DEL ASC
)
/


/*==============================================================*/
/* Table: SEDI_AMMINISTRATIVE                                   */
/*==============================================================*/

create table SEDI_AMMINISTRATIVE (
   NUMERO               NUMBER(8)                        not null,
   NI                   NUMBER(8),
   CODICE               VARCHAR2(8),
   DENOMINAZIONE        VARCHAR2(60),
   DENOMINAZIONE_AL1    VARCHAR2(60),
   DENOMINAZIONE_AL2    VARCHAR2(60),
   SEQUENZA             NUMBER(6),
   CALENDARIO           VARCHAR2(4),
   NOTE                 VARCHAR2(2000),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
)
/


/*==============================================================*/
/* Index: SEDI_AMMINISTRATIVE_PK                                */
/*==============================================================*/
create unique index SEDI_AMMINISTRATIVE_PK
on SEDI_AMMINISTRATIVE (
   NUMERO ASC
)
/


/*==============================================================*/
/* Index: SDAM_SOGG_FK                                          */
/*==============================================================*/
create  index SDAM_SOGG_FK
on SEDI_AMMINISTRATIVE (
   NI ASC
)
/


/*==============================================================*/
/* Table: SETTORI_AMMINISTRATIVI                                */
/*==============================================================*/

create table SETTORI_AMMINISTRATIVI (
   NUMERO               NUMBER(8)                        not null,
   NI                   NUMBER(8)                        not null,
   CODICE               VARCHAR2(15)                     not null,
   DENOMINAZIONE        VARCHAR2(60)                     not null,
   DENOMINAZIONE_AL1    VARCHAR2(60),
   DENOMINAZIONE_AL2    VARCHAR2(60),
   SEQUENZA             NUMBER(6),
   GESTIONE             VARCHAR2(8)                      not null,
   SEDE                 NUMBER(8),
   ASSEGNABILE          VARCHAR2(2)                      not null,
   NOTE                 VARCHAR2(2000),
   DATA_AGG             DATE,
   UTENTE               VARCHAR2(8)
)
/

/*==============================================================*/
/* Index: SETTORI_AMMINISTRATIVI_PK                             */
/*==============================================================*/
create unique index SETTORI_AMMINISTRATIVI_PK
on SETTORI_AMMINISTRATIVI (
   NUMERO ASC
)
/

/*==============================================================*/
/* Index: STAM_SEDA_FK                                          */
/*==============================================================*/
create  index STAM_SEDA_FK
on SETTORI_AMMINISTRATIVI (
   SEDE ASC
)
/

/*==============================================================*/
/* Index: STAM_GEAM_FK                                          */
/*==============================================================*/
create  index STAM_GEAM_FK
on SETTORI_AMMINISTRATIVI (
   GESTIONE ASC
)
/

/*==============================================================*/
/* Index: STAM_SOGG_FK                                          */
/*==============================================================*/
create  index STAM_SOGG_FK
on SETTORI_AMMINISTRATIVI (
   NI ASC
)
/

/*==============================================================*/
/* Index: SETTORI_AMMINISTRATIVI_AK                             */
/*==============================================================*/
create unique index SETTORI_AMMINISTRATIVI_AK
on SETTORI_AMMINISTRATIVI (GESTIONE,
   CODICE ASC
)
/


/*==============================================================*/
/* Table: SUDDIVISIONI_STRUTTURA                                */
/*==============================================================*/

create table SUDDIVISIONI_STRUTTURA (
   OTTICA               VARCHAR2(4)                      not null,
   LIVELLO              VARCHAR2(8)                      not null,
   SEQUENZA             NUMBER(6),
   DENOMINAZIONE        VARCHAR2(60),
   DENOMINAZIONE_AL1    VARCHAR2(60),
   DENOMINAZIONE_AL2    VARCHAR2(60),
   DES_ABB              VARCHAR2(8),
   DES_ABB_AL1          VARCHAR2(8),
   DES_ABB_AL2          VARCHAR2(8),
   ICONA                VARCHAR2(60),
   NOTE                 VARCHAR2(2000),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
)
/


/*==============================================================*/
/* Index: SUDDIVISIONI_STRUTTURA_PK                             */
/*==============================================================*/
create unique index SUDDIVISIONI_STRUTTURA_PK
on SUDDIVISIONI_STRUTTURA (
   OTTICA ASC,
   LIVELLO ASC
)
/


/*==============================================================*/
/* Table: TIPI_INCARICO                                         */
/*==============================================================*/

create table TIPI_INCARICO (
   INCARICO             VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(120)                    not null,
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120),
   RESPONSABILE         VARCHAR2(2)                      not null
)
/


/*==============================================================*/
/* Index: TIPI_INCARICO_PK                                      */
/*==============================================================*/
create unique index TIPI_INCARICO_PK
on TIPI_INCARICO (
   INCARICO ASC
)
/

/*==============================================================*/
/* Table: TIPI_SOGGETTO                                         */
/*==============================================================*/

create table TIPI_SOGGETTO (
   TIPO_SOGGETTO        VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(120),
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120)
)
/


/*==============================================================*/
/* Index: TIPI_SOGGETTO_PK                                      */
/*==============================================================*/
create unique index TIPI_SOGGETTO_PK
on TIPI_SOGGETTO (
   TIPO_SOGGETTO ASC
)
/

/*==============================================================*/
/* Table: UNITA_ORGANIZZATIVE                                   */
/*==============================================================*/

create table UNITA_ORGANIZZATIVE (
   OTTICA               VARCHAR2(4)                      not null,
   NI                   NUMBER(8)                        not null,
   DAL                  DATE                             not null,
   CODICE_AMMINISTRAZIONE VARCHAR2(8),
   AMM_DAL              DATE,
   CODICE_AOO           VARCHAR2(8),
   AOO_DAL              DATE,
   CODICE_UO            VARCHAR2(15),
   UNITA_PADRE          NUMBER(8),
   UNITA_PADRE_OTTICA   VARCHAR2(4),
   UNITA_PADRE_DAL      DATE,
   DESCRIZIONE          VARCHAR2(120),
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120),
   AL                   DATE,
   TIPO                 VARCHAR2(1),
   SETTORE              VARCHAR2(4),
   SETTORE_UNITA        VARCHAR2(4),
   SEDE                 NUMBER(8),
   SUDDIVISIONE         VARCHAR2(8),
   REVISIONE            NUMBER(8),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
)
STORAGE  (
  INITIAL   &1DIMx500
  NEXT   &1DIMx250
  MINEXTENTS  1
  MAXEXTENTS  99
  PCTINCREASE  50
  )
/


/*==============================================================*/
/* Index: UNITA_ORGANIZZATIVE_PK                                */
/*==============================================================*/
create unique index UNITA_ORGANIZZATIVE_PK
on UNITA_ORGANIZZATIVE (
   NI ASC,
   OTTICA ASC,
   DAL ASC,
   REVISIONE ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: UNOR_UNOR_FK                                          */
/*==============================================================*/
create  index UNOR_UNOR_FK
on UNITA_ORGANIZZATIVE (
   UNITA_PADRE ASC,
   UNITA_PADRE_OTTICA ASC,
   UNITA_PADRE_DAL ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: UNOR_REST_FK                                          */
/*==============================================================*/
create  index UNOR_REST_FK
on UNITA_ORGANIZZATIVE (
   REVISIONE ASC,
   OTTICA ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: UNOR_SUST_FK                                          */
/*==============================================================*/
create  index UNOR_SUST_FK
on UNITA_ORGANIZZATIVE (
   OTTICA ASC,
   SUDDIVISIONE ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: UNOR_SOGG_FK                                          */
/*==============================================================*/
create  index UNOR_SOGG_FK
on UNITA_ORGANIZZATIVE (
   SEDE ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: UNOR_OTTI_FK                                          */
/*==============================================================*/
create  index UNOR_OTTI_FK
on UNITA_ORGANIZZATIVE (
   OTTICA ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


/*==============================================================*/
/* Index: UNOR_AMMI_FK                                          */
/*==============================================================*/
create  index UNOR_AMMI_FK
on UNITA_ORGANIZZATIVE (
   AMM_DAL ASC,
   CODICE_AMMINISTRAZIONE ASC
)
/


/*==============================================================*/
/* Index: UNOR_AOO_FK                                           */
/*==============================================================*/
create  index UNOR_AOO_FK
on UNITA_ORGANIZZATIVE (
   CODICE_AMMINISTRAZIONE ASC,
   AMM_DAL ASC,
   CODICE_AOO ASC,
   AOO_DAL ASC
)
/


/*==============================================================*/
/* Index: UNOR_SOGG_2_FK                                        */
/*==============================================================*/
create  index UNOR_SOGG_2_FK
on UNITA_ORGANIZZATIVE (
   NI ASC
)
storage
(
    initial &1DIMx50
    next &1DIMx25
    minextents 1
    maxextents 99
    pctincrease 50
)
/


