delete from a_selezioni where voce_menu = 'PECCIMCO';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCIMCO','1','Elaborazione: Anno','4','N','N','','','RIRE','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECCIMCO','2','  Mensilita`','4','U','N','','','RIRE','1','2');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SEZIONE','PECCIMCO','3','  Sezione','4','U','N','%','','GESS','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DIVISIONE','PECCIMCO','4','  Divisione','4','U','N','%','','GESD','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FUNZIONALE','PECCIMCO','5','  Funzionale','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ALIMENTA','PECCIMCO','6','Acquisisci Impegni da Cont.','1','U','N','X','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ESCLUDI','PECCIMCO','7','Escludi Capitoli a 0','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CAUSALE','PECCIMCO','8','Descrizione Causale','1','U','N','R','P_CIMCO','','','');  

delete from a_guide_o where guida_o = 'P_IMCO_S';

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_IMCO_S','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_IMCO_S','2','RIRE','M','Mese','PECRMERE','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_IMCO_S','3','GESS','S','Sezioni','PGMEGEST','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_IMCO_S','4','GESD','D','Divisioni','PGMEGEST','');

start crp_peccimco.sql