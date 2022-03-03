delete from a_selezioni 
where voce_menu = 'PECCADMI'
and parametro = 'P_TFR'; 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TFR','PECCADMI','14','Inserimento TFR Febbraio','1','U','N','','P_01','','','');


insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_01','0','','Assume il valore 0');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_01','1','','Assume il valore 1');


-- inclusa nel file A15416
-- start crp_peccadmi.sql 
