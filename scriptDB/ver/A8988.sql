delete from a_voci_menu where voce_menu = 'PAMXRAPP';
delete from a_passi_proc where voce_menu = 'PAMXRAPP';  
delete from a_selezioni where voce_menu = 'PAMXRAPP';
delete from a_menu where voce_menu = 'PAMXRAPP' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PAMXRAPP','P00','XRAPP','Riapertura Rapporti Individuali','F','D','ACAPARPR','',1,'A_PARA'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAMXRAPP','1','Riapertura Rapporti Individuali','Q','PAMXRAPP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PAMXRAPP','1','Anno di Elaborazione:','4','N','S','','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000548','1013752','PAMXRAPP','11','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000548','1013752','PAMXRAPP','11','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000548','1013752','PAMXRAPP','11','');

start crp_pamxrapp.sql