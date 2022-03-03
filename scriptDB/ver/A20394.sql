delete from a_passi_proc where voce_menu = 'PECCADNA';  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','1','Caricamento Archivio Denuncia I.N.A.I.L.','Q','CHK_SCAD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','2','Caricamento Archivio Denuncia I.N.A.I.L.','Q','PECCADNA','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','3','Lista Anomalie Denuncia I.N.A.I.L.','Q','PECLADNA','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','4','Lista Anomalie Denuncia I.N.A.I.L.','R','PECLADNA','','PECLADNA','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','5','Cancellazione registrazioni temporanee','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','6','Elimina segnalazioni','Q','ACACANRP','','','N');  

insert into a_guide_o 
( guida_o, sequenza, alias, lettera, titolo, guida_v, voce_menu, voce_rif, proprieta, titolo_esteso )
values ('P_DEIN_W', 4, 'REIN', 'P', 'Posizioni', '', 'PECDASIN', '', '', '');

start crp_peccadna.sql
start crp_pecladna.sql

