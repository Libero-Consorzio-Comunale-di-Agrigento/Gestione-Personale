delete from a_passi_proc where voce_menu = 'PECCDNAG';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','1','Creazione file','Q','PECCDNAG','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','2','Creazione file','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','3','Creazione Prima Stampa','R','PECSAPST','','PECSAPST','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','4','Creazione Seconda Stampa','R','PECSAPST','','PECSAPST','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','5','Cancellazione appoggio stampe','Q','ACACANAS','','','N');

start crp_peccdnag.sql