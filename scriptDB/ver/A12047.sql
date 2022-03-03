start crp_pecstrsm.sql

-- Creazione del menu per le statistiche trimestrali

delete from a_voci_menu where voce_menu = 'PECECCST';   
delete from a_menu where voce_menu = 'PECECCST' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECECCST','P00','ECCST','Statistiche Trimestrali','N','M','','',1,'');     

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000552','1013809','PECECCST','99','');    
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000552','1013809','PECECCST','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000552','1013809','PECECCST','99','');    

-- Abilitazione archiviazione
delete from a_menu where voce_menu = 'PECCARST' and ruolo in ('*','AMM','PEC');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013809','1013810','PECCARST','1','');     
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013809','1013810','PECCARST','1',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013809','1013810','PECCARST','1','');     

-- Abilitazione form
delete from a_menu where voce_menu = 'PECAARST' and ruolo in ('*','AMM','PEC'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013809','1013811','PECAARST','2','');     
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013809','1013811','PECAARST','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013809','1013811','PECAARST','2','');     

-- Abilitazione report
delete from a_menu where voce_menu = 'PECSSMTR' and ruolo in ('*','AMM','PEC');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013809','1013812','PECSSMTR','3','');     
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013809','1013812','PECSSMTR','3',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013809','1013812','PECSSMTR','3','');     

-- Creazione nuova voce di menu PECSTRSM
delete from a_voci_menu where voce_menu = 'PECSTRSM';
delete from a_passi_proc where voce_menu = 'PECSTRSM';     
delete from a_selezioni where voce_menu = 'PECSTRSM';
delete from a_menu where voce_menu = 'PECSTRSM' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECSTRSM','P00','STRSM','Supporto Magnetico Stat.Trim. Sanita','F','D','ACAPARPR','',1,'P_SMT_S');     

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSTRSM','1','Supporto Magnetico Stat.Trim. Sanita','Q','PECSTRSM','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSTRSM','2','Produzione File','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSTRSM','3','Cancellazione Appoggio Stampe','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('NUM_CARATTERI','PECSTRSM','0','Numero caratteri per substring','4','C','S','127','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_SUBSTR','PECSTRSM','0','Abilita substring','2','C','S','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_UPPER','PECSTRSM','0','Abilita upper','2','C','S','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECSTRSM','0','Nome TXT da produrre','80','C','S','MODCM.txt','','','','');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECSTRSM','1','Elaborazione : Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_MESE','PECSTRSM','2','                       Mese','2','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE','PECSTRSM','3','   Gestione','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_REG','PECSTRSM','4','Codice Regione:','3','U','S','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_AZIENDA','PECSTRSM','5','Codice Azienda:','3','U','S','','','','','');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013809','1013813','PECSTRSM','4','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013809','1013813','PECSTRSM','4','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013809','1013813','PECSTRSM','4','');     

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_SMT_S','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_SMT_S','2','GEST','G','Gestioni','PGMEGESE','');