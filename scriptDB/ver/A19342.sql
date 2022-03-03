start crp_chk_scad.sql
start crp_pxxcnper.sql

delete from a_voci_menu where voce_menu = 'PXXCNPER';   
delete from a_passi_proc where voce_menu = 'PXXCNPER';  
delete from a_selezioni where voce_menu = 'PXXCNPER';   
delete from a_menu where voce_menu = 'PXXCNPER' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PXXCNPER','P00','CNPER','Caricamento Personalizzato Note CUD','F','D','ACAPARPR','',1,'P_CNPER'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PXXCNPER','1','Verifica Scadenza denuncia','Q','CHK_SCAD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PXXCNPER','2','Caricamento Personalizzato Note CUD ','Q','PXXCNPER','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PXXCNPER','3','Verifica Presenza Errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PXXCNPER','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCNOCU','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PXXCNPER','92','Cancellazione Segnalazioni','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PXXCNPER','0','Tipo Denuncia','10','U','N','CUD','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PXXCNPER','1','Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PXXCNPER','2','Gestione ....:','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PXXCNPER','3','Rapporto ....:','4','U','S','COCO','','CLRA','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PXXCNPER','4','Archiviazione:','1','U','S','T','P_S_T','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PXXCNPER','5','Singolo Individuo : Codice','8','N','N','','','RAIN','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PER_EFFE','PXXCNPER','6','Annotazione Periodi ','2','U','U','PG','P_PER','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO_SFASATO','PXXCNPER','7','Anno Prev.da Nov.(note gg.det)','1','U','N','','P_X','','',''); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1004365','1013867','PXXCNPER','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1004365','1013867','PXXCNPER','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1004365','1013867','PXXCNPER','99','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CNPER','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CNPER','2','RAIN','I','Individui','P00RANAG','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CNPER','3','GEST','G','Gestioni','PGMEGEST','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CNPER','4','CLRA','R','Rapporti','PAMDCLRA','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_PER','PG','','Periodi Effettivi Solo se Giorni < 365');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_PER','PS','','Periodi Effettivi Sempre');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_PER','AG','','Periodo Annuale Solo se Giorni < 365');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_PER','AS','','Periodo Annuale Sempre');