
/*==============================================================*/
/* Table: TIPI_TITOLO                                           */
/*==============================================================*/

create table TIPI_TITOLO (
   TITOLO               VARCHAR2(4)                      not null,
   DESCRIZIONE          VARCHAR2(120),
   DESCRIZIONE_AL1      VARCHAR2(120),
   DESCRIZIONE_AL2      VARCHAR2(120)
)
/


/*==============================================================*/
/* Index: TIPI_TITOLO_PK                                        */
/*==============================================================*/
create unique index TIPI_TITOLO_PK
on TIPI_TITOLO (
   TITOLO ASC
)
/
