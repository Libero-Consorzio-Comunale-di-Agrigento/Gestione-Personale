delete from a_voci_menu where voce_menu = 'PECAPOII';                                                                                                                                                                                                                                                       

delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECAPOII');                                                                                                                                                                  

delete from a_passi_proc where voce_menu = 'PECAPOII';                                                                                                                                                                                                                                                      

delete from a_selezioni where voce_menu = 'PECAPOII';                                                                                                                                                                                                                                                       

delete from a_menu where voce_menu = 'PECAPOII' and ruolo in ('*','AMM','PEC');                                                                                                                                                                                                                             

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PECAPOII','P00','APOII','Ponderazioni INAIL individuali','F','F','PECAPOII','',1,'');                                                                                                

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','PEC','1013640','1013896','PECAPOII','11','');                                                                                                                                                                
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1013640','1013896','PECAPOII','11','');                                                                                                                                                                  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1013640','1013896','PECAPOII','11','');                                                                                                                                                                


start crq_poii.sql

insert into a_errori ( errore, descrizione, descrizione_al1, descrizione_al2,proprieta ) values ('P05002', 'Esiste Voce di Ponderazioni INAIL Individuali collegata a', null, null, null); 
insert into a_errori ( errore, descrizione, descrizione_al1, descrizione_al2,proprieta ) values ('P05003', 'Ripartizione sulle voci di rischio errata', null, null, null);
insert into a_errori ( errore, descrizione, descrizione_al1, descrizione_al2,proprieta ) values ('P00707', 'Periodo esterno al periodo di ponderazione INAIL', null, null, null);

start crp_gp4_poii.sql