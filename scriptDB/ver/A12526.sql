insert into a_errori (errore, descrizione) values ('P00544','Codice Assenza non previsto o non ammesso');

delete from a_voci_menu where voce_menu = 'PECDIMAS';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_passi_proc where voce_menu = 'PECDIMAS';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

delete from a_selezioni where voce_menu = 'PECDIMAS';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_menu where voce_menu = 'PECDIMAS' and ruolo in ('*','AMM','PEC');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECDIMAS');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

delete from a_guide_o where voce_menu = 'PECDIMAS';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECDIMAS');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

delete from a_guide_v where guida_v in (select guida_v from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECDIMAS'));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PECDIMAS','P00','DIMAS','Imponibili prev. fig. in caso di assenza','F','F','PECDIMAS','',1,'P_DIMAS');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000350, 1013815, 'PECDIMAS', 16, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1000350, 1013815, 'PECDIMAS', 16, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'PEC', 1000350, 1013815, 'PECDIMAS', 16, NULL);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) values ('P_DIMAS','1','ASTE','A','Astens.','PGMDASTE','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) values ('P_DIMAS','2','IMVO','I','Imponib.','PECDIMVO','');   