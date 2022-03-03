-- Abilitazione stampa LSETT per clienti in grafica
delete from a_voci_menu where voce_menu = 'PGMLSETT';
delete from a_passi_proc where voce_menu = 'PGMLSETT';  
delete from a_selezioni where voce_menu = 'PGMLSETT';
delete from a_menu where voce_menu = 'PGMLSETT' and ruolo in ('*','AMM','PEC'); 
delete from a_guide_o where guida_o = 'P_LSETT';
delete from a_catalogo_stampe where stampa = 'PGMLSETT';  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGMLSETT','P00','LSETT','Lista Suddivisioni Settoriali (grafica)','F','D','','',1,'P_LSETT');  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGMLSETT','1','Lista Suddivisioni Settoriali','R','PGMLSETT','','PGMLSETT','N'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1000231','1000235','PGMLSETT','4',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000231','1000235','PGMLSETT','4','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000231','1000235','PGMLSETT','4','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013238','1013242','PGMLSETT','4',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013238','1013242','PGMLSETT','4','');  

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGMLSETT','LISTA SUDDIVISIONI SETTORIALI','U','U','A_C','N','N','S'); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_LSETT','1','GEST','G','Gestioni','PGMEGEST','');

-- Abilitazione stampa LSET6 per clienti in WEB 

delete from a_voci_menu where voce_menu = 'PGMLSET6';
delete from a_passi_proc where voce_menu = 'PGMLSET6';  
delete from a_selezioni where voce_menu = 'PGMLSET6';
delete from a_menu where voce_menu = 'PGMLSET6' and ruolo in ('*','AMM','PEC'); 
delete from a_guide_o where guida_o = 'P_LSETT';
delete from a_catalogo_stampe where stampa = 'PGMLSET6';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGMLSET6','P00','LSET6','Lista Suddivisioni Settoriali ( WEB )','F','D','ACAPARPR','',1,'P_LSETT');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGMLSET6','1','Lista Suddivisioni Settoriali','R','PGMLSETT','','PGMLSET6','N'); 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_REVISIONE','PGMLSET6','1','Revisione','8','N','N','','','LSETT','0','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RILEVANZA','PGMLSET6','2','Rilevanza','1','U','S','Q','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_COMPONENTI','PGMLSET6','3','Componenti','1','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ASSEGNATI','PGMLSET6','4','Assegnati','1','U','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_IN_SERVIZIO','PGMLSET6','5','In Servizio','1','U','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PGMLSET6','6','Gestione','4','U','N','%','','GEST','1','1');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000231','1013761','PGMLSET6','4',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000231','1013761','PGMLSET6','4','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000231','1013761','PGMLSET6','4','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013238','1013762','PGMLSET6','4','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013238','1013762','PGMLSET6','4','');  

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGMLSET6','LISTA SUDDIVISIONI SETTORIALI','U','U','PDF','N','N','S'); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_LSETT','1','GEST','G','Gestioni','PGMEGEST','');

commit;