start crp_peccstor.sql

delete from a_voci_menu where voce_menu = 'PECCSTOR';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_passi_proc where voce_menu = 'PECCSTOR';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

delete from a_selezioni where voce_menu = 'PECCSTOR';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

delete from a_menu where voce_menu = 'PECCSTOR' and ruolo in ('*','AMM','PEC');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECCSTOR');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

delete from a_guide_o where voce_menu = 'PECCSTOR';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECCSTOR');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

delete from a_guide_v where guida_v in (select guida_v from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECCSTOR'));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PECCSTOR','P00','CSTOR','Caricamento Storno contributi','F','D','ACAPARPR','',1,'A_PARA');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCSTOR','1','Caricamento Storno COntributi','Q','PECCSTOR','','','N');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCSTOR','2','Stampa Dipendenti Trattati','R','PECSAPST','','PECSAPST','N');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_VOCE1','PECCSTOR','1','Voce 1^ scaglione','10','U','S','','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_SUB1','PECCSTOR','2','Sub 1^ scaglione','3','U','S','','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_VOCE2','PECCSTOR','3','Voce 2^ scaglione','10','U','S','','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_SUB2','PECCSTOR','4','Sub 2^ scaglione','3','U','S','','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DAL','PECCSTOR','5','Calcolo a partire dal','10','D','N','','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','PEC','1000548','19202','PECCSTOR','2','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1000548','19202','PECCSTOR','2','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1000548','19202','PECCSTOR','2','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) values ('A_PARA','1','PREN','P','Prenot...','ACAEPRPA','*');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
