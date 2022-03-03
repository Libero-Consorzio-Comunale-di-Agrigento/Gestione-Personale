delete from a_voci_menu where voce_menu = 'PECCCSTO';           
delete from a_passi_proc where voce_menu = 'PECCCSTO';          
delete from a_selezioni where voce_menu = 'PECCCSTO';
delete from a_menu where voce_menu = 'PECCCSTO' and ruolo in ('*','AMM','PEC');        
delete from a_catalogo_stampe where stampa = 'PECSAPST';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCCSTO','P00','CCSTO','Modifica voce/sub su movimenti contabili','F','D','ACAPARPR','',1,'A_PARA');     

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCCSTO','1','Modifica voce/sub su movimenti contabili','Q','PECCCSTO','','','N');          
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCCSTO','2','Stampa Dipendenti Trattati','R','PECSAPST','','PECSAPST','N');    

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_VOCE1_DA','PECCCSTO','1','Voce Contributo da Modificare','10','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SUB1_DA','PECCCSTO','2','SUB Contributo da Modificare','3','U','N','','','','','');         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_VOCE1_A','PECCCSTO','3','Nuova Voce del Contributo','10','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SUB1_A','PECCCSTO','4','Nuovo SUB del Contributo','3','U','N','','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_VOCE2_DA','PECCCSTO','5','Voce Ritenuta da Modificare','10','U','N','','','','','');        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SUB2_DA','PECCCSTO','6','SUB Ritenuta da Modificare','3','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_VOCE2_A','PECCCSTO','7','Nuova Voce della Ritenuta','10','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SUB2_A','PECCCSTO','8','Nuovo SUB della Ritenuta','3','U','N','','','','','');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000548','1013740','PECCCSTO','1','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000548','1013740','PECCCSTO','1','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000548','1013740','PECCCSTO','1','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');     

start crp_PECCCSTO.sql