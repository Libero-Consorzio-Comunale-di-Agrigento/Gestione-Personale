-- include start per attivita 15842
alter table SMTTR_IMPORTI add ANNO_RIF NUMBER(4) NULL;

start crp_peccarst.sql
start crp_pecstrsm.sql

delete from a_selezioni where voce_menu = 'PECSTRSM'
and parametro = 'P_MESE_COMP';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_MESE_COMP','PECSTRSM','6','Mese di Comp.Economica','1','U','N','','P_X','','','');