alter table codici_bilancio add
( NOTE                                     VARCHAR2(2000)
, NOTE_AL1                                 VARCHAR2(2000)
, NOTE_AL2                                 VARCHAR2(2000)
);

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
values ('P_CAUSALE','PECCIMCO','6','Descrizione Causale','1','U','N','R','P_CIMCO','','','');  

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CIMCO','R','','Descrizione Cod.Bil. e Ruolo');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CIMCO','N','','Descrizione Cod.Bil. e Note');

start crp_peccimco.sql