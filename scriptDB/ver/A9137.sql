delete from a_voci_menu where voce_menu = 'PECF2005';
delete from a_passi_proc where voce_menu = 'PECF2005';
delete from a_selezioni where voce_menu = 'PECF2005';
delete from a_menu where voce_menu = 'PECF2005' and ruolo in ('*','AMM','PEC');
delete from a_catalogo_stampe where stampa = 'PECSAPST';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECF2005','P00','F2005','Calcolo deduzioni Gennaio 2005','F','D','ACAPARPR','',1,'A_PARA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECF2005','1','Calcolo deduzioni Gennaio 2005','Q','PECF2005','','','N');    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECF2005','2','Stampa Dipendenti Trattati','R','PECSAPST','','PECSAPST','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECF2005','3','Cancellazione appoggio stampe','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_VOCE','PECF2005','1','Codice della Voce','10','U','S','','','','','');    

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000548','1013758','PECF2005','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000548','1013758','PECF2005','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000548','1013758','PECF2005','2',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');    

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('A_PARA','1','PREN','P','Prenot...','ACAEPRPA','*');

insert into a_errori (errore, descrizione, descrizione_al1,  descrizione_al2, proprieta )
values ('P00603','Impossibile Elaborare la Fase', null, null, null );

start crt_wf05.sql
start crp_pecf2005.sql
