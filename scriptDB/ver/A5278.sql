
delete from a_voci_menu where voce_menu = 'PGMCEVPA';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_passi_proc where voce_menu = 'PGMCEVPA';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

delete from a_selezioni where voce_menu = 'PGMCEVPA';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_menu where ruolo in ('AMM','PEC') and  voce_menu = 'PGMCEVPA';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

delete from a_catalogo_stampe where stampa = 'PGMCEVPA';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PGMCEVPA','P00','CASPA','Alimentazione da Gestione Presenze','F','D','ACAPARPR','',1,'A_PARA');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PGMCEVPA','1','Alimentazione da Gestione Presenze','F','PGMCEVPA','','','N');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PGMCEVPA','2','Alimentazione da Gestione Presenze','R','PGMLANPA','','PGMLANPA','N');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PGMCEVPA','1','Gestione','4','U','N','%','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1000187','1004756','PGMCEVPA','30','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1000187','1004756','PGMCEVPA','30','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) values ('PGMLANPA','ANOMALIE ALIMENTAZIONE DA PRESENZE','U','U','A_C','N','N','S');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) values ('A_PARA','1','PREN','P','Prenot...','ACAEPRPA','*');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
