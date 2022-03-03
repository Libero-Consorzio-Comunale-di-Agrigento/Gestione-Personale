-- Eliminazione voci di menu obsolete

delete from a_voci_menu where voce_menu = 'PXIRISCD'; 
delete from a_passi_proc where voce_menu = 'PXIRISCD';
delete from a_selezioni where voce_menu = 'PXIRISCD'; 
delete from a_menu where voce_menu = 'PXIRISCD';  

delete from a_voci_menu where voce_menu = 'PXVE07CD'; 
delete from a_passi_proc where voce_menu = 'PXVE07CD';
delete from a_selezioni where voce_menu = 'PXVE07CD'; 
delete from a_menu where voce_menu = 'PXVE07CD';  

-- Abilitazione nuova voce PPACDERI

delete from a_voci_menu where voce_menu = 'PPACDERI';
delete from a_passi_proc where voce_menu = 'PPACDERI';
delete from a_selezioni where voce_menu = 'PPACDERI';
delete from a_menu where voce_menu = 'PPACDERI' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PPACDERI','P00','CDERI','Caricamento eventi rilevazione','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PPACDERI','1','Caricamento eventi rilevazione','Q','PPACDERI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PPACDERI','2','Segnalazioni in Elaborazione','R','ACARAPPR','','ACARAPPR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PPACDERI','3','Cancellazione errori','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SOFTWARE','PPACDERI','0','Codice software rilevazione','8','U','S','%','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1004572','1007130','PPACDERI','87','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1004572','1007130','PPACDERI','87','');