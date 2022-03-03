-- start crp_PECCARSM.sql gia presente in A21201 per patch
start crp_PECSMT12.sql
-- contiene start crp_PECSMT13.sql anche per A21338
start crp_PECSMT13.sql
start crp_PECSMTPD.sql

delete from a_passi_proc where voce_menu = 'PECCARSM';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARSM','1','Caricamento Archivio Stat. Ministeriali','Q','PECCARSM','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARSM','2','Archiviazione T12 Stat. Ministeriali','Q','PECSMT12','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARSM','3','Archiviazione T13 Stat. Ministeriali','Q','PECSMT13','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARSM','4','Archiviazione Arr.PD Stat. Ministeriali','Q','PECSMTPD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARSM','5','Stampa Anomalie Archiviazione','R','PECSMTSA','','PECSMTSA','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARSM','6','Verifica Presenza Segnalazioni','Q','CHK_APST','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARSM','81','Stampa Segnalazioni','Q','ACACANAS','','','N');
