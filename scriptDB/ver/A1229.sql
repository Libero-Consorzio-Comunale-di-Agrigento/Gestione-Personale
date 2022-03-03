delete from a_voci_menu where voce_menu = 'PECCMORP';
delete from a_passi_proc where voce_menu = 'PECCMORP';
delete from a_selezioni where voce_menu = 'PECCMORP';
delete from a_menu where voce_menu = 'PECCMORP';

delete from a_voci_menu where voce_menu = 'PECCEVPA';
delete from a_passi_proc where voce_menu = 'PECCEVPA';
delete from a_selezioni where voce_menu = 'PECCEVPA';
delete from a_menu where voce_menu = 'PECCEVPA';


delete from a_passi_proc where voce_menu = 'PPAEEVEC';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PPAEEVEC','1','Estrazione Movimenti per Economico','Q','PPAEEVEC','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PPAEEVEC','2','Verifica Presenza Errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PPAEEVEC','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','ACARAPPR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PPAEEVEC','92','Cancellazione errori','Q','ACACANRP','','','N');