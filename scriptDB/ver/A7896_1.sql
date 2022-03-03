delete from a_voci_menu where voce_menu = 'PECSINFO';   
delete from a_passi_proc where voce_menu = 'PECSINFO';  
delete from a_selezioni where voce_menu = 'PECSINFO';   
delete from a_menu where voce_menu = 'PECSINFO' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa = 'PECSINFO';  
delete from a_guide_o where guida_o = 'P_SINFO';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSINFO','P00','SINFO','Scheda Individuale Infortuni','F','D','ACAPARPR','',1,'P_SINFO');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSINFO','1','Scheda Individuale Infortuni','R','PECSINFO','','PECSINFO','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECSINFO','1','Codice Individuale:','8','N','S','','','RAIN','0','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DATA','PECSINFO','2','Data Infortunio:','10','D','N','','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NUMERO','PECSINFO','3','Numero Progressivo Infortunio','8','N','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FINCATO','PECSINFO','4','Stampa su foglio pre-fincato','1','U','N','','P_X','','','');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013427','1013706','PECSINFO','40','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013427','1013706','PECSINFO','40','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013427','1013706','PECSINFO','40','');  

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSINFO','SCHEDA INDIVIDUALE INFORTUNI','U','U','A_A','N','N','S');   

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_SINFO','1','RAIN','R','Ricerca','P00RANAG',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_SINFO','2','PREN','P','Prenot.','ACAEPRPA','*');
