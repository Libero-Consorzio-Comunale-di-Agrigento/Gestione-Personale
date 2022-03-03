delete from a_voci_menu where voce_menu = 'PECECAEA';   
delete from a_menu where voce_menu = 'PECECAEA' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECECAEA','P00','ECAEA','Acquisizione Variabili dall''Esterno','N','M','','',1,'');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000500','1013789','PECECAEA','9',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000500','1013789','PECECAEA','9',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000500','1013789','PECECAEA','9',''); 

delete from a_voci_menu where voce_menu = 'PECDORVA';  
delete from a_menu where voce_menu = 'PECDORVA' and ruolo in ('*','AMM','PEC'); 
delete from a_guide_o where voce_menu = 'PECDORVA';    

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECDORVA','P00','DORVA','Definizione Origini Variabili Mensili','F','F','PECDORVA','',1,'');    

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1013789','1013804','PECDORVA','1','');    
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1013789','1013804','PECDORVA','1',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1013789','1013804','PECDORVA','1','');    

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_RVAES','1','VAES','O','Origini','PECDORVA',''); 

delete from a_voci_menu where voce_menu = 'PECRVAES';  
delete from a_menu where voce_menu = 'PECRVAES' and ruolo in ('*','AMM','PEC'); 
delete from a_guide_o where voce_menu = 'PECRVAES';    
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECRVAES');   

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECRVAES','P00','RVAES','Ricerca Variabili Esterne','F','F','PECRVAES','',1,'P_RVAES');    

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1013789','1013807','PECRVAES','2','');    
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1013789','1013807','PECRVAES','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1013789','1013807','PECRVAES','2','');    

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_RVAES','1','VAES','O','Origini','PECDORVA',''); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_DIVA','1','DEVE','R','Ricerca','PECRVAES','');  

delete from a_voci_menu where voce_menu = 'PECEDIVA';  
delete from a_menu where voce_menu = 'PECEDIVA' and ruolo in ('*','AMM','PEC'); 
delete from a_guide_o where voce_menu = 'PECEDIVA';    
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECEDIVA');   

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECEDIVA','P00','EDIVA','Elenco Disponibilita'' Variabili Mensili','F','F','PECEDIVA','',1,'P_DIVA'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1013789','1013805','PECEDIVA','3','');    
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1013789','1013805','PECEDIVA','3',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1013789','1013805','PECEDIVA','3','');    

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_DIVA','1','DEVE','R','Ricerca','PECRVAES','');  

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CMOCO','1','DEVE','M','or.Mov.','PECEDIVA',''); 

delete from a_voci_menu where voce_menu = 'PECCMOCO';  
delete from a_passi_proc where voce_menu = 'PECCMOCO'; 
delete from a_selezioni where voce_menu = 'PECCMOCO';  
delete from a_menu where voce_menu = 'PECCMOCO' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECCMOCO');  
delete from a_guide_o where voce_menu = 'PECCMOCO';    
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECCMOCO');   

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECCMOCO','P00','CMOCO','Caricamento variabili Economiche','F','D','ACAPARPR','',1,'P_CMOCO');  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCMOCO','1','Caricamento variabili economiche','Q','PECCMOCO','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCMOCO','2','Caricamento Variabili Economiche','R','PECLVAES','','PECLVAES','N');    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCMOCO','3','Elimina Registrazioni','Q','ACACANAS','','','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ORIGINE','PECCMOCO','1','Codice Origine da Acquisire','10','U','N','%','','DEVE','1','1');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANOMALIE','PECCMOCO','2','Non stampa gli Inserimenti','1','U','N','','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TOTALI','PECCMOCO','3','Non stampa i Totali','1','U','N','','P_X','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CONTROLLI','PECCMOCO','4','Esegui SOLO controlli','1','U','N','','P_X','','','');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1013789','1013808','PECCMOCO','4','');    
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1013789','1013808','PECCMOCO','4',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1013789','1013808','PECCMOCO','4','');    

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PECLVAES','Stampa Variabili Economiche','U','U','A_C','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CMOCO','1','DEVE','M','or.Mov.','PECEDIVA',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CMOCO','2','PREN','P','Prenot.','ACAEPRPA','*');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_X','X','','Conferma della condizione proposta');
