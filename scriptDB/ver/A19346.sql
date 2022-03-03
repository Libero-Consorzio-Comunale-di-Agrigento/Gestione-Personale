start crp_peccstvb.sql
start crp_peccsmvb.sql

insert into a_selezioni 
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PECCSTVB','8','Rapporto','4','U','N','%','','CLRA','1','1')
;
insert into a_selezioni
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GRUPPO','PECCSTVB','9','Gruppo','12','U','N','%','','GRRA','1','1')
;

insert into a_selezioni 
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PECCSMVB','8','Rapporto','4','U','N','%','','CLRA','1','1')
;
insert into a_selezioni
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GRUPPO','PECCSMVB','9','Gruppo','12','U','N','%','','GRRA','1','1')
;
