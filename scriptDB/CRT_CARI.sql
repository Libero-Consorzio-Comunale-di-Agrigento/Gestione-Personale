/*==============================================================*/
/* Table: CALCOLI_RETRIBUZIONI_INAIL                            */
/*==============================================================*/


create table CALCOLI_RETRIBUZIONI_INAIL  
(
   CI                   NUMBER(8)                        not null,
   ANNO                 NUMBER(4)                        not null,
   MESE                 NUMBER(2)                        not null,
   DAL                  DATE                             not null,
   AL                   DATE,
   GIORNI               NUMBER(2)                        not null,
   GESTIONE             VARCHAR2(8)                      not null,
   POSIZIONE            VARCHAR2(4),
   FIGURA               NUMBER(8),
   CONTRATTO            VARCHAR2(4),
   QUALIFICA            NUMBER(8),
   ORE                  NUMBER(5,2),
   TRATTAMENTO          VARCHAR2(4),
   SETTORE              NUMBER(8),
   SEDE                 NUMBER(8),
   POSIZIONE_INAIL      VARCHAR2(4)                      not null,
   ESENZIONE            VARCHAR2(4),
   RUOLO                VARCHAR2(4),
   FUNZIONALE           VARCHAR2(8),
   CDC                  VARCHAR2(8),
   BILANCIO             VARCHAR2(2),
   VOCE_CONTRIBUTO      VARCHAR2(10),
   SUB_CONTRIBUTO       VARCHAR2(2),
   QUOTA                NUMBER,
   INTERO               NUMBER,
   TIPO_IPN             VARCHAR2(1)                      not null,
   IMPONIBILE           Number(12,2),
   PREMIO               Number(12,2),
   COMPETENZA           VARCHAR2(1),
   PROGRESSIVO          NUMBER(6)                        not null,
   SEDE_DEL             VARCHAR2(4), 
   ANNO_DEL             NUMBER(4), 
   NUMERO_DEL           NUMBER(7),
   ARRETRATO            varchar2(1)
);

comment on table CALCOLI_RETRIBUZIONI_INAIL is
'Tabella di lavoro per il calcolo dell''imponibile e del premio ';

comment on column CALCOLI_RETRIBUZIONI_INAIL.POSIZIONE is
'Posizione giuridica';

comment on column CALCOLI_RETRIBUZIONI_INAIL.ORE is
'Ore Lavorate (part-time) Null=full-time';

comment on column CALCOLI_RETRIBUZIONI_INAIL.TRATTAMENTO is
'Trattamento previdenziale';

comment on column CALCOLI_RETRIBUZIONI_INAIL.ESENZIONE is
'Codice di esenzione, determinata per difetto da ESENZIONI_INAIL';

comment on column CALCOLI_RETRIBUZIONI_INAIL.VOCE_CONTRIBUTO is
'Codice della voce di contributo';

comment on column CALCOLI_RETRIBUZIONI_INAIL.SUB_CONTRIBUTO is
'Sub della voce di contributo';

comment on column CALCOLI_RETRIBUZIONI_INAIL.TIPO_IPN is
'P=Preventivo, C=Consuntivo';

comment on column CALCOLI_RETRIBUZIONI_INAIL.COMPETENZA is
'G=Giuridico ,  C=Contabile';

/*==============================================================*/
/* Index: CARI_PK                                               */
/*==============================================================*/
create unique index CARI_PK on CALCOLI_RETRIBUZIONI_INAIL 
(  CI ASC,
   ANNO ASC,
   MESE ASC,
   DAL ASC,
   PROGRESSIVO
);