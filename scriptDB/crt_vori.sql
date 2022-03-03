/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     30/12/2003 12.07.29                          */
/*==============================================================*/


/*==============================================================*/
/* Table: VOCI_RISCHIO_INAIL                                    */
/*==============================================================*/


create table VOCI_RISCHIO_INAIL  (
   VOCE_RISCHIO         VARCHAR2(5)                      not null,
   DESCRIZIONE          VARCHAR2(120)                    not null,
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120),
   UTENTE               VARCHAR2(8),
   DATA_AGG             DATE
);

comment on table VOCI_RISCHIO_INAIL is
'Registrazione storica delle aliquote di ponderazione tra le diverse voci di rischio, da applicare all''imponibile durante il calcolo del premio';

/*==============================================================*/
/* Index: VOCI_RISCHIO_INAIL_PK                                 */
/*==============================================================*/
create unique index VOCI_RISCHIO_INAIL_PK on VOCI_RISCHIO_INAIL (
   VOCE_RISCHIO ASC
);

