delete from a_voci_menu where voce_menu = 'PGMAPESU';                                                                                                                                                                                                                                                       

delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PGMAPESU');                                                                                                                                                                  

delete from a_passi_proc where voce_menu = 'PGMAPESU';                                                                                                                                                                                                                                                      

delete from a_selezioni where voce_menu = 'PGMAPESU';                                                                                                                                                                                                                                                       

delete from a_menu where voce_menu = 'PGMAPESU' and ruolo in ('*','AMM','PEC');                                                                                                                                                                                                                             

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PGMAPESU','P00','APESU','Subentro a Dipendenti Dimessi','A','F','PGMAPESU','',1,'');                                                                                                 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1004362','1020020','PGMAPESU','56','');      
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1004362','1020020','PGMAPESU','56','');                                                                                                                                                               
