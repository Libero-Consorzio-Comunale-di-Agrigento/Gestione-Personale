delete from a_passi_proc where voce_menu = 'PECCADMA';
delete from a_passi_proc where voce_menu = 'PECCADMI';
delete from a_passi_proc where voce_menu = 'PECXADMI'; 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMA','1','Caricamento Archivio DMA','Q','CHK_SCAD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMA','2','Caricamento Archivio DMA','Q','PECCADMA','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMA','91','Errori di Elaborazione','R','ACARAPPR','','PECCADMA','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMA','92','Cancellazione errori','Q','ACACANRP','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMA','93','Lista Segnalazioni Denuncia DMA','R','PECLSDMA','','PECLSDMA','N');    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMA','94','Cancellazione errori','Q','ACACANAS','','','N');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','1','Caricamento Archivio EMENS','Q','CHK_SCAD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','2','Caricamento Archivio EMENS','Q','PECCADMI','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCADMI','3','Verifica Presenza Errori','Q','CHK_ERR','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCADMI','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','92','Cancellazione errori','Q','ACACANRP','','','N');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXADMI','1','Aggiornamento Rit/Contr EMENS','Q','CHK_SCAD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXADMI','2','Aggiornamento Rit/Contr EMENS','Q','PECXADMI','','','N');

start crp_chk_scad.sql