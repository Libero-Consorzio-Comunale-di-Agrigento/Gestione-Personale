delete from a_selezioni where voce_menu = 'PECCIMCO';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCIMCO','1','Elaborazione: Anno','4','N','N','','','RIRE','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECCIMCO','2','  Mensilita`','4','U','N','','','RIRE','1','2');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SEZIONE','PECCIMCO','3','  Sezione','4','U','N','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FUNZIONALE','PECCIMCO','4','  Funzionale','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ALIMENTA','PECCIMCO','5','Acquisisci Impegni da Cont.','1','U','N','X','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ESCLUDI','PECCIMCO','6','Escludi Capitoli a 0','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CAUSALE','PECCIMCO','7','Descrizione Causale','1','U','N','R','P_CIMCO','','','');  

start crp_peccimco.sql