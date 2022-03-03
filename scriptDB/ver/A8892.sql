-- Nuovo parametro per privati
delete from a_selezioni 
where voce_menu = 'PECCAO1M' and  parametro = 'P_PRIVATI';
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_PRIVATI', 'PECCAO1M', 12, 'Accantonamento TFR PRIVATI', NULL, NULL, 1, 'U', 'N'
, NULL, 'P_X', NULL, NULL, NULL); 

-- Distribuizione voce di menu per privati
delete from a_voci_menu where voce_menu = 'PECCO1MD';  
delete from a_passi_proc where voce_menu = 'PECCO1MD'; 
delete from a_selezioni where voce_menu = 'PECCO1MD';  
delete from a_menu where voce_menu = 'PECCO1MD' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCO1MD','P00','CO1MD','Calcolo valori per quadro D Mod. O1/M','F','D','ACAPARPR','',1,'');    

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCO1MD','1','Calcolo valori per quadro D Mod. O1/M','Q','CHK_SCAD','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCO1MD','2','Calcolo valori per quadro D Mod. O1/M','Q','PECCO1MD','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCO1MD','91','Stampa segnalazioni','R','ACARAPPR','','PECCALSE','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCO1MD','92','Cancella segnalazioni','Q','ACACANRP','','','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECCO1MD','0','Tipo Denuncia','10','U','N','770','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCO1MD','1','Gestione:','4','U','S','%','','GEST','1','1');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCO1MD','2','Archiviazione: Tipo','1','U','S','P','P_CARCP','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GENNAIO','PECCO1MD','3','Competenza','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PECCO1MD','4','Periodo cessazione: Dal','10','D','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_AL','PECCO1MD','5','Al','10','D','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RUOLO','PECCO1MD','6','Solo Personale non di Ruolo:','1','U','N','X','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_INCARICO','PECCO1MD','7','Periodi di Incarico:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCO1MD','8','Singolo Individuo : Codice','8','N','N','','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_GG','PECCO1MD','9','Tipo Giorni:','1','U','S','I','P_TIPO_GG','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RETRIBUZIONE','PECCO1MD','10','Calcolo Retribuzione Ridotta','1','U','S','F','P_RETRIBUZIONE','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ASSESTAMENTO','PECCO1MD','11','Assestemanto dati Quadro D','1','U','N','X','P_X','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1001044','1012866','PECCO1MD','10','');   
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1001044','1012866','PECCO1MD','10','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1001044','1012866','PECCO1MD','10','');   

start crp_peccao1m.sql
start crp_pecco1md.sql