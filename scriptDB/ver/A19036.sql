prompt cancellazione vecchia voce LADIR - 4ADIR
delete from a_voci_menu where voce_menu = 'PEC4ADIR';
delete from a_passi_proc where voce_menu = 'PEC4ADIR';  
delete from a_selezioni where voce_menu = 'PEC4ADIR';
delete from a_menu where voce_menu = 'PEC4ADIR' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PEC4ADIR');  

prompt abilitazione nuova voce LADIR
delete from a_voci_menu where voce_menu = 'PECLADIR';
delete from a_passi_proc where voce_menu = 'PECLADIR';  
delete from a_selezioni where voce_menu = 'PECLADIR';
delete from a_menu where voce_menu = 'PECLADIR' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECLADIR');  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECLADIR','P00','LADIR','Stampa Riepilogativa Regioni Residenza','F','D','ACAPARPR','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECLADIR','1','Lista Comuni per addizionale IRPEF','R','PECLADIR','','PECLADIR','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECLADIR','1','Elaborazione: Anno','4','N','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_MENSILITA','PECLADIR','2','  Mensilita''','4','U','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECLADIR','3','Tipo Elaborazione:','1','U','S','T','P_LADIC','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOMINATIVA','PECLADIR','4','Elenco Nominativo:','2','U','S','SI','P_SI_NO','','',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLADIR','Stamp Riepilogativa Regioni Residenza','U','U','A_C','N','N','S');  

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LADIC','C','','Solo Individui Cessati nel Mese'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LADIC','E','','Solo Individui Elaborati nel Mese');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LADIC','T','','Tutti gli Individui'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SI_NO','NO','','Negativo');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SI_NO','SI','','Affermativo');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
 values ('GP4','PEC','1012412','1013052','PECLADIR','2','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012412','1013052','PECLADIR','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012412','1013052','PECLADIR','2','');  


prompt cancellazione vecchia voce LADIR - 4ADIC
delete from a_voci_menu where voce_menu = 'PEC4ADIC';
delete from a_passi_proc where voce_menu = 'PEC4ADIC';  
delete from a_selezioni where voce_menu = 'PEC4ADIC';
delete from a_menu where voce_menu = 'PEC4ADIC' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PEC4ADIC');  

prompt abilitazione nuova voce LADIC
delete from a_voci_menu where voce_menu = 'PECLADIC';
delete from a_passi_proc where voce_menu = 'PECLADIC';  
delete from a_selezioni where voce_menu = 'PECLADIC';
delete from a_menu where voce_menu = 'PECLADIC' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECLADIC');  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECLADIC','P00','LADIC','Lista Comuni per addizionale IRPEF','F','D','ACAPARPR','',1,''); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECLADIC','1','Lista Comuni per addizionale IRPEF','R','PECLADIC','','PECLADIC','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECLADIC','1','Elaborazione: Anno','4','N','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECLADIC','2','  Mensilita''','4','U','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECLADIC','3','Tipo Elaborazione:','1','U','S','T','P_LADIC','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOMINATIVA','PECLADIC','4','Elenco Nominativo:','2','U','S','SI','P_SI_NO','','',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLADIC','Lista Comuni per addizionale IRPEF','U','U','A_C','N','N','S');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012412','1012413','PECLADIC','1',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012412','1012413','PECLADIC','1','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1012412','1012413','PECLADIC','1','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LADIC','C','','Solo Individui Cessati nel Mese'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LADIC','E','','Solo Individui Elaborati nel Mese');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LADIC','T','','Tutti gli Individui'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SI_NO','NO','','Negativo');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SI_NO','SI','','Affermativo');  