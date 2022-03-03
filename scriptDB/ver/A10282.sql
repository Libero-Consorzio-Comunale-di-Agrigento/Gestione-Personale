start crp_pecssnsm.sql
start crp_pecssnrf.sql

-- Ablitazione voce di menu
delete from a_voci_menu where voce_menu = 'PECSSNSM';            
delete from a_passi_proc where voce_menu = 'PECSSNSM';           
delete from a_selezioni where voce_menu = 'PECSSNSM';            
delete from a_menu where voce_menu = 'PECSSNSM' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECSSNSM','P00','SSNSM','Supporto Magnetico SMT Sanita','F','D','ACAPARPR','',1,'P_SMT_S');     

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','1','Supporto Magnetico SMT Sanita','Q','PECSSNSM','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','2','Produzione File','R','SI4V3WAS','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','3','Rinomina File','Q','PECSSNRF','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','4','Produzione File','R','SI4V3WAS','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','5','Rinomina File','Q','PECSSNRF','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','6','Produzione File','R','SI4V3WAS','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','7','Rinomina File','Q','PECSSNRF','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','8','Produzione File','R','SI4V3WAS','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','9','Rinomina File','Q','PECSSNRF','','','N');       
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','10','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','11','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','12','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','13','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','14','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','15','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','16','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','17','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','18','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','19','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','20','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','21','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','22','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','23','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','24','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','25','Rinomina File','Q','PECSSNRF','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','26','Produzione File','R','SI4V3WAS','','','N');      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','27','Rinomina File','Q','PECSSNRF','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','28','Cancellazione Appoggio Stampe','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('NUM_CARATTERI','PECSSNSM','0','Numero caratteri per substring','4','C','S','171','','','','');            
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_SUBSTR','PECSSNSM','0','Abilita substring','2','C','S','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_UPPER','PECSSNSM','0','Abilita upper','2','C','S','','','','','');       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECSSNSM','0','Nome TXT da produrre','80','C','S','tab1A1.txt','','','','');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECSSNSM','1','Elaborazione : Anno','4','N','N','','','RIRE','1','1');            
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE','PECSSNSM','2','   Gestione','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_REG','PECSSNSM','3','Codice Regione:','3','U','S','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_AZIENDA','PECSSNSM','4','Codice Azienda:','3','U','S','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_COMPARTO','PECSSNSM','5','Codice Comparto:','2','U','S','01','','','','');           

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1012804','1013778','PECSSNSM','16','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1012804','1013778','PECSSNSM','16','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1012804','1013778','PECSSNSM','16','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_SMT_S','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_SMT_S','2','GEST','G','Gestioni','PGMEGESE','');