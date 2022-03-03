delete from a_passi_proc where voce_menu = 'PECCEVPA';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCEVPA','1','Caricamento movimenti da gest. presenze','Q','PECCEVPA','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCEVPA','2','Verifica Presenza Errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCEVPA','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','ACARAPPR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCEVPA','92','Cancellazione errori','Q','ACACANRP','','','N');

start crp_peccevpa.sql
