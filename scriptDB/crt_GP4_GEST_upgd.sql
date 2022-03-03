/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     28/01/2003 14.40.10                          */
/*==============================================================*/


/*==============================================================*/
/* Table: GESTIONI                                              */
/*==============================================================*/


alter table GESTIONI add controlli_do VARCHAR2(1);
alter table GESTIONI add perc_ore_lavorate number(4,2);
alter table GESTIONI modify CODICE VARCHAR2(8);
alter table GESTIONI modify NOTE VARCHAR2(2000);
alter table GESTIONI modify NOTE_AL1 VARCHAR2(2000);
alter table GESTIONI modify NOTE_AL2 VARCHAR2(2000);
alter table GESTIONI modify INDIRIZZO_RES VARCHAR2(40);
alter table GESTIONI modify INDIRIZZO_RES_AL1 VARCHAR2(40);
alter table GESTIONI modify INDIRIZZO_RES_AL2 VARCHAR2(40):


