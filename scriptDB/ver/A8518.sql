-- Abilitazione selezioni CSMVB
delete from a_selezioni where voce_menu = 'PECCSMVB';  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PECCSMVB','0','Numero caratteri per substring','4','C','S','120','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PECCSMVB','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PECCSMVB','0','Abilita upper','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECCSMVB','0','Nome TXT da produrre','80','C','S','PECCSMVB.txt','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCSMVB','1','Elaborazione: Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECCSMVB','2','    Mensilita''','4','U','N','','','RIRE','1','2');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FASCIA','PECCSMVB','3','Fascia','2','U','N','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ACCREDITI','PECCSMVB','4','Solo Accrediti','1','U','N','X','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_BANCHE_ESTERE','PECCSMVB','5','Banche Estere','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_IBAN','PECCSMVB','6','Coordinate IBAN','1','U','N','','P_X','','','');    
   

-- Abilitazione selezioni CSTVB
delete from a_selezioni where voce_menu = 'PECCSTVB';  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PECCSTVB','0','Caratteri per substring','4','C','S','120','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PECCSTVB','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PECCSTVB','0','Abilita upper','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECCSTVB','0','Nome TXT da produrre','80','C','S','PECCSTVB.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCSTVB','1','Elaborazione: Anno','4','N','N','','','RIRE','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECCSTVB','2','    Mensilita''','4','U','N','','','RIRE','1','2');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FASCIA','PECCSTVB','3','Fascia','2','U','N','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ACCREDITI','PECCSTVB','4','Solo Accrediti','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_BANCHE_ESTERE','PECCSTVB','5','Banche Estere','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DATA_ESECUZIONE','PECCSTVB','6','Data di Esecuzione','10','D','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_IBAN','PECCSTVB','7','Coordinate IBAN','1','U','N','','P_X','','','');    

start crp_peccsmvb.sql
start crp_peccstvb.sql
start crp_peccsbse.sql
