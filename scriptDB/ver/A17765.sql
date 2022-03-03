alter table RELAZIONI_UO add SEQUENZA_FIGLIO NUMBER(6);
alter table RELAZIONI_UO add SEQUENZA_PADRE NUMBER(6);
alter table RELAZIONI_UO add DESCRIZIONE_FIGLIO VARCHAR2(120);
alter table RELAZIONI_UO add DESCRIZIONE_PADRE VARCHAR2(120);
alter table RELAZIONI_UO add LIVELLO_FIGLIO NUMBER(2);
alter table RELAZIONI_UO add LIVELLO_PADRE NUMBER(2);
start crp_gp4gm.sql
start crv_pegi_a.sql
start crv_pegi_d.sql
start crv_pegi_qi.sql
start crv_pegi_se.sql