/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     30/12/2003 15.48.57                          */
/*==============================================================*/


/*==============================================================*/
/* Table: PONDERAZIONE_INAIL                                    */
/*==============================================================*/


create table PONDERAZIONE_INAIL  (
   POSIZIONE_INAIL      VARCHAR2(4)                      not null,
   ANNO                 NUMBER(4)                        not null,
   VOCE_RISCHIO         VARCHAR2(5)                      not null,
   ALIQUOTA             NUMBER(5,2),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE,
   ALQ_PRESUNTA         NUMBER(5,2),
   ALQ_EFFETTIVA        NUMBER(5,2)
);

comment on table PONDERAZIONE_INAIL is
'Registrazione storica delle aliquote di ponderazione tra le diverse voci di rischio, da applicare all''imponibile durante il calcolo del premio';

/*==============================================================*/
/* Index: PONDERAZIONE_INAIL_PK                                 */
/*==============================================================*/
create unique index PONDERAZIONE_INAIL_PK on PONDERAZIONE_INAIL (
   POSIZIONE_INAIL ASC,
   ANNO ASC,
   VOCE_RISCHIO ASC
);

/*==============================================================*/
/* Index: POIN_VORI_FK                                          */
/*==============================================================*/
create index POIN_VORI_FK on PONDERAZIONE_INAIL (
   VOCE_RISCHIO ASC
);

/*==============================================================*/
/* Index: POIN_ASIN_FK                                          */
/*==============================================================*/
create index POIN_ASIN_FK on PONDERAZIONE_INAIL (
   POSIZIONE_INAIL ASC
);

