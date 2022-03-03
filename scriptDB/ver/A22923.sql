start crp_chk_scad.sql

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
values ('PECCADNA','6','Elimina segnalazioni del passo 2','Q','ACACANRP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECELASE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADNA','92','Elimina segnalazioni del passo 1','Q','ACACANRP','','','N');