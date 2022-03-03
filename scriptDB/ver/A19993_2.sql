start crp_pecamore.sql
-- start crp_peccraad.sql inclusa in A20420

delete from a_passi_proc where voce_menu = 'PECCRAAD';                                
                                        
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCRAAD','1','Caricamento Rate Addizionali','Q','CHK_SCAD','','','N');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCRAAD','2','Caricamento Rate Addizionali','Q','PECCRAAD','','','N');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCRAAD','3','Stampa Caricamento Rate Addizionali','R','PECSAPST','','PECSAPST','N');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCRAAD','4','Stampa Caricamento Rate Addizionali','Q','ACACANAS','','','N');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCRAAD','91','Stampa Segnalazioni','R','ACARAPPR','','PECCALSE','N');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCRAAD','92','Stampa Segnalazioni','Q','ACACANRP','','','N');
