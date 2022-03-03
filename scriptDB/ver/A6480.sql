-- Abilitazione CSMVB
delete from a_voci_menu where voce_menu = 'PECCSMVB';
delete from a_passi_proc where voce_menu = 'PECCSMVB'; 
delete from a_selezioni where voce_menu = 'PECCSMVB';  

delete from a_voci_menu where voce_menu = 'PEC4SMVB';
delete from a_passi_proc where voce_menu = 'PEC4SMVB'; 
delete from a_selezioni where voce_menu = 'PEC4SMVB';  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCSMVB','P00','CSMVB','Supporto Magnetico Versamenti Bancari','F','D','ACAPARPR','',1,'P_RIRE_S'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','1','Supporto Magnetico Versamenti Bancari','Q','PECCSMVB','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','2','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','3','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','4','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','5','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','6','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','7','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','8','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','9','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','10','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','11','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','12','Cancellazione appoggio stampe','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','13','Verifica presenza errori','Q','PECCSBSE','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','91','Segnalazione in elaborazione','R','ACARAPPR','','PECELASE','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMVB','92','Cancellazione segnalazioni','Q','ACACANRP','','','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PECCSMVB','0','Numero caratteri per substring','4','C','S','120','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ACCREDITI','PECCSMVB','3','Solo Accrediti','1','U','N','X','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCSMVB','1','Elaborazione: Anno','4','N','N','','','RIRE','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_BANCHE_ESTERE','PECCSMVB','4','Banche Estere','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_IBAN','PECCSMVB','5','Coordinate IBAN','1','U','N','','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECCSMVB','2','    Mensilita''','4','U','N','','','RIRE','1','2');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PECCSMVB','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PECCSMVB','0','Abilita upper','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECCSMVB','0','Nome TXT da produrre','80','C','S','PECCSMVB.txt','','','','');    

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
select 'GP4','PEC','1000552','1005842','PECCSMVB','7',''
from dual
where exists (select 'x' from a_menu where voce_menu in ('PECCSMVB','PEC4SMVB'))
; 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
select 'GP4','*','1000552','1005842','PECCSMVB','7',''
from dual
where exists (select 'x' from a_menu where voce_menu in ('PECCSMVB','PEC4SMVB'))
; 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
select 'GP4','AMM','1000552','1005842','PECCSMVB','7',''
from dual
where exists (select 'x' from a_menu where voce_menu in ('PECCSMVB','PEC4SMVB'))
; 

delete from a_menu
where voce_menu = 'PECCSMVB'
  and applicazione = 'GP4'
  and ruolo in ('*','AMM','PEC')
  and figlio != '1005842'
; 
delete from a_menu
where voce_menu = 'PEC4SMVB'
  and applicazione = 'GP4'
  and figlio != '1005842'
;

update a_menu set voce_menu = 'PECCSMVB'
where voce_menu = 'PEC4SMVB'
;

-- Abilitazione CSTVB
delete from a_voci_menu where voce_menu = 'PECCSTVB';  
delete from a_passi_proc where voce_menu = 'PECCSTVB'; 
delete from a_selezioni where voce_menu = 'PECCSTVB';  

delete from a_voci_menu where voce_menu = 'PEC4STVB';  
delete from a_passi_proc where voce_menu = 'PEC4STVB'; 
delete from a_selezioni where voce_menu = 'PEC4STVB';  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCSTVB','P00','CSTVB','Supporto Telematico Versamenti Bancari','F','D','ACAPARPR','',1,'P_RIRE_S');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','1','Supporto Magnetico Versamenti Bancari','Q','PECCSTVB','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','2','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','3','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','4','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','5','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','6','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','7','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','8','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','9','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','10','Supporto Magnetico Versamenti Bancari','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','11','Supporto Magnetico Versamenti Bancari','Q','PECCSBRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','12','Cancellazione appoggio stampe','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','13','Verifica presenza errori','Q','PECCSBSE','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','91','Segnalazione in elaborazione','R','ACARAPPR','','PECELASE','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSTVB','92','Cancellazione segnalazioni','Q','ACACANRP','','','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PECCSTVB','0','Caratteri per substring','4','C','S','120','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ACCREDITI','PECCSTVB','3','Solo Accrediti','1','U','N','X','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCSTVB','1','Elaborazione: Anno','4','N','N','','','RIRE','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_BANCHE_ESTERE','PECCSTVB','4','Banche Estere','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DATA_ESECUZIONE','PECCSTVB','5','Data di Esecuzione','10','D','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_IBAN','PECCSTVB','6','Coordinate IBAN','1','U','N','','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECCSTVB','2','    Mensilita''','4','U','N','','','RIRE','1','2');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PECCSTVB','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PECCSTVB','0','Abilita upper','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECCSTVB','0','Nome TXT da produrre','80','C','S','PECCSTVB.txt','','','','');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
select 'GP4','PEC','1000552','1012696','PECCSTVB','44',''
from dual
where exists (select 'x' from a_menu where voce_menu in ('PECCSTVB','PEC4STVB')) 
;
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
select 'GP4','*','1000552','1012696','PECCSTVB','44',''
from dual
where exists (select 'x' from a_menu where voce_menu in ('PECCSTVB','PEC4STVB'))
;
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
select 'GP4','AMM','1000552','1012696','PECCSTVB','44',''
from dual
where exists (select 'x' from a_menu where voce_menu in ('PECCSTVB','PEC4STVB'))
;

delete from a_menu 
where voce_menu = 'PECCSTVB'
  and applicazione = 'GP4'
  and ruolo in ('*','AMM','PEC')
  AND figlio != ('1012696')
;
delete from a_menu
where voce_menu = 'PEC4STVB'
  and applicazione = 'GP4'
  AND figlio != ('1012696')
;

update a_menu set voce_menu = 'PECCSTVB'
where voce_menu = 'PEC4STVB'
;