delete from a_selezioni where voce_menu = 'PECCARST'; 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCARST','1','Elaborazione Anno:','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE_DA','PECCARST','2',' Mese Da:','2','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE_A','PECCARST','3',' Mese A:','2','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ELAB','PECCARST','4','Tipo Elaborazione:','1','U','S','T','P_CARSM','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_COMPETENZA','PECCARST','5','Competenza Economica:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCARST','6','Archiviazione','1','U','S','T','P_TIPO_CARSM','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCARST','7','Codice individuale','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCARST','8','Gestione:','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FASCIA','PECCARST','9','Fascia :','2','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PECCARST','10','Rapporto :','4','U','S','%','','CLRA','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GRUPPO','PECCARST','11','Gruppo :','12','U','S','%','','GRRA','1','1');

delete from a_guide_o where guida_o = 'P_CARST';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CARST','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CARST','2','RAIN','I','Individui','P00RANAG','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CARST','3','GEST','G','Gestioni','PGMEGEST',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CARST','4','CLRA','R','Rapporti','PAMDCLRA',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CARST','5','GRRA','R','Gruppi','PAMDGRRA',''); 

update a_voci_menu
   set guida_o = 'P_CARST'
 where voce_menu = 'PECCARST';

start crp_peccarst.sql