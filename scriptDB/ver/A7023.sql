
delete from a_voci_menu where voce_menu = 'PECLTRCO';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_passi_proc where voce_menu = 'PECLTRCO';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

delete from a_selezioni where voce_menu = 'PECLTRCO';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_menu where voce_menu = 'PECLTRCO' and ruolo in ('*','AMM','PEC');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

delete from a_catalogo_stampe where stampa = 'PECLTRCO';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

delete from a_guide_o where voce_menu = 'PECLTRCO';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECLTRCO');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

delete from a_guide_v where guida_v in (select guida_v from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECLTRCO'));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PECLTRCO','P00','LTRCO','Lista Trattamenti Contabili','F','D','','',1,'');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECLTRCO','1','Lista Trattamenti Contabili','R','PECLTRCO','','PECLTRCO','N');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','PEC','1000599','1012921','PECLTRCO','40','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1000599','1012921','PECLTRCO','40','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1000599','1012921','PECLTRCO','40','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) values ('PECLTRCO','Lista Trattamenti Contabili','U','U','A_C','N','N','S');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
