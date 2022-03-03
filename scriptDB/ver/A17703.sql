insert into a_errori ( errore, descrizione )
select 'P05474','Rilevata Gestione priva di dipendenti'
from dual;

update a_voci_menu
   set guida_o = 'P_CADNA'
 where voce_menu = 'PECCADNA';

delete from a_guide_o where guida_o = 'P_CADNA';

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CADNA','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CADNA','2','GEST','G','Gestioni','PGMEGEST','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CADNA','3','ASIN','A','Ass.Inail','PECDASIN','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CADNA','4','RAIN','I','Individui','P00RANAG','');


delete from a_selezioni where voce_menu = 'PECCADNA';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO_DENUNCIA','PECCADNA','0','Tipo Denuncia','10','U','N','770','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECCADNA','1','Elaborazione: Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_POS_INAIL','PECCADNA','2','              Posizione INAIL','12','U','S','%','','ASIN','1','2');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE','PECCADNA','3','              Gestione','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECCADNA','4','Archiviazione','1','U','S','T','P_TIPO_CADNA','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECCADNA','5','Codice Individuale','8','N','N','','','RAIN','1','1');


start crp_peccadna.sql