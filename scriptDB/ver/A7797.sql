-- Cancellazione voci obsolete
delete from a_menu where voce_menu = 'PECSICUD';
delete from a_menu where voce_menu = 'PXXSICU4';

delete from a_voci_menu where voce_menu = 'NEWSMCUD';
delete from a_passi_proc where voce_menu = 'NEWSMCUD';
delete from a_selezioni where voce_menu = 'NEWSMCUD';
delete from a_menu where voce_menu = 'NEWSMCUD';
delete from a_catalogo_stampe where stampa  = 'NEWSMCUD';

delete from a_voci_menu where voce_menu = 'AMISMCUD';
delete from a_passi_proc where voce_menu = 'AMISMCUD';
delete from a_selezioni where voce_menu = 'AMISMCUD';
delete from a_menu where voce_menu = 'AMISMCUD';
delete from a_catalogo_stampe where stampa = 'AMISMCUD';


-- Inserimento voce di menu CUD su Buffetti ( senza abilitazione ) 

delete from a_voci_menu where voce_menu = 'PXXSMCUD';
delete from a_passi_proc where voce_menu = 'PXXSMCUD';
delete from a_selezioni where voce_menu = 'PXXSMCUD';
delete from a_menu where voce_menu = 'PXXSMCUD';

delete from a_voci_menu where voce_menu = 'PECSMCUD';
delete from a_passi_proc where voce_menu = 'PECSMCUD';
delete from a_selezioni where voce_menu = 'PECSMCUD';
delete from a_menu where voce_menu = 'PECSMCUD';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSMCUD','P00','SMCUD','Stampa Modulo Certificazione Redditi','F','D','ACAPARPR','FINE_ANNO',1,'P_INDI_S');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','1','Estrazione dati per Stampa CUD','Q','PECSMCUD','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','2','Lista Anomalie CUD','R','PECANCUD','','PECANCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','3','Stampa Modulo Certificazione Redditi','R','PECSMCUD','','PECSMCUD','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','4','Stampa Allegato Annotazioni','R','PECALCUD','','PECALCUD','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','5','Stampa Lista Firme','R','PECLMCUD','','PECLMCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','6','Stampa Etichette CUD','R','PECSECU3','','PECSECU3','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','7','Eliminazione registrazioni di lavoro','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCUD','8','Pulizia tabella tab_report_fine_anno','Q','PECDTBFA','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECSMCUD','1','Elaborazione:  Anno','4','N','N','','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECSMCUD','2','   Tipo','1','U','S','T','P_SM101','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECSMCUD','3','Individuale :  Codice','8','N','N','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PECSMCUD','4','Cessazione  :  Dal','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_AL','PECSMCUD','5','   Al','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ESTRAZIONE_I','PECSMCUD','6','Estrazione Individui:','1','U','N','','P_ESTR_I','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECSMCUD','7','Collettiva  :  Raggruppam. 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECSMCUD','8','   2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECSMCUD','9','   3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECSMCUD','10','   4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOTALI','PECSMCUD','11','Totali Generali:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ORDINAMENTO','PECSMCUD','12','Ordinamento come modello CUD','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ETICHETTE','PECSMCUD','13','Stampa Etichette','1','U','N','','P_SECU3','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DOMICILIO','PECSMCUD','14','Domicilio','1','U','N','X','P_X','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_STAMPA_ENTE','PECSMCUD','15','Stampa indirizzo per cessati','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PREVIDENZIALE','PECSMCUD','16','Non stampa dati Previdenziali','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_1','PECSMCUD','17','Note fisse : 1 Riga','70','C','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_2','PECSMCUD','18',' 2 Riga','70','C','N','','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013272','PECSMCUD','30','');  


-- Inserimento voce di menu CUD fincato ( senza abilitazione )

delete from a_voci_menu where voce_menu = 'PXXSMCU4';
delete from a_passi_proc where voce_menu = 'PXXSMCU4';
delete from a_selezioni where voce_menu = 'PXXSMCU4';
delete from a_menu where voce_menu = 'PXXSMCU4';

delete from a_voci_menu where voce_menu = 'PECSMCU4';   
delete from a_passi_proc where voce_menu = 'PECSMCU4';  
delete from a_selezioni where voce_menu = 'PECSMCU4';   
delete from a_menu where voce_menu = 'PECSMCU4' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSMCU4','P00','SMCU4','Stampa Modulo Certificazione Redditi','F','D','ACAPARPR','FINE_ANNO',1,'P_INDI_S'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','1','Estrazione dati per Stampa CUD','Q','PECSMCUD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','2','Lista Anomalie CUD','R','PECANCUD','','PECANCUD','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','3','Stampa Modulo Certificazione Redditi','R','PECSMCU4','','PECSMCU4','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','4','Stampa Allegato Annotazioni','R','PECALCUD','','PECALCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','5','Stampa Lista Firme','R','PECLMCUD','','PECLMCUD','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','6','Stampa Etichette CUD','R','PECSECU4','','PECSECU4','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','7','Eliminazione registrazioni di lavoro','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU4','8','Pulizia tabella tab_report_fine_anno','Q','PECDTBFA','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECSMCU4','1','Elaborazione:  Anno','4','N','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECSMCU4','2','  Tipo','1','U','S','T','P_SM101','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECSMCU4','3','Individuale :  Codice','8','N','N','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PECSMCU4','4','Cessazione  :  Dal','10','D','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_AL','PECSMCU4','5','  Al','10','D','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ESTRAZIONE_I','PECSMCU4','6','Estrazione Individui:','1','U','N','','P_ESTR_I','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECSMCU4','7','Collettiva  :  Raggruppam. 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECSMCU4','8',' 2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECSMCU4','9',' 3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECSMCU4','10',' 4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOTALI','PECSMCU4','11','Totali Generali:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ORDINAMENTO','PECSMCU4','12','Ordinamento come modello CUD','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ETICHETTE','PECSMCU4','13','Stampa Etichette','1','U','N','','P_SECU3','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DICITURA','PECSMCU4','14','Originale/Copia:','1','U','N','','P_DICI','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DOMICILIO','PECSMCU4','15','Domicilio','1','U','N','X','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_STAMPA_ENTE','PECSMCU4','16','Stampa indirizzo per cessati','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PREVIDENZIALE','PECSMCU4','17','Non stampa dati Previdenziali','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_1','PECSMCU4','18','Note fisse : 1 Riga','70','C','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_2','PECSMCU4','19','2 Riga','70','C','N','','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013829','PECSMCU4','30','');  

-- Inserimento voce di menu CUD "misto" ( con abilitazione )

delete from a_voci_menu where voce_menu = 'PECSMCU6';   
delete from a_passi_proc where voce_menu = 'PECSMCU6';  
delete from a_selezioni where voce_menu = 'PECSMCU6';   
delete from a_menu where voce_menu = 'PECSMCU6' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa = 'PECSMCU6';
delete from a_domini_selezioni where dominio = 'P_SMCU6';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECSMCU6','P00','SMCU6','Stampa Modulo Certificazione Redditi','F','D','ACAPARPR','FINE_ANNO',1,'P_INDI_S'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','1','Estrazione dati per Stampa CUD','Q','PECSMCUD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','2','Lista Anomalie CUD','R','PECANCUD','','PECANCUD','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','3','Stampa Modulo Certificazione Redditi','R','PECSMCU6','P_TIPO_DESFORMAT','PECSMCU6','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','4','Stampa Allegato Annotazioni','R','PECALCUD','','PECALCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','5','Stampa Lista Firme','R','PECLMCUD','','PECLMCUD','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','6','Controllo per Stampa Etichette','Q','P00UPDPP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','7','Stampa Etichette CUD','R','PECSECU4','','PECSECU4','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','8','Controllo per Stampa Etichette','Q','P00UPDPP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','9','Stampa Etichette CUD','R','PECSECU3','','PECSECU3','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','10','Eliminazione registrazioni di lavoro','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','11','Pulizia tabella tab_report_fine_anno','Q','PECDTBFA','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECSMCU6','1','Elaborazione:  Anno','4','N','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECSMCU6','2','  Tipo','1','U','S','T','P_SM101','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECSMCU6','3','Individuale :  Codice','8','N','N','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DAL','PECSMCU6','4','Cessazione  :  Dal','10','D','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_AL','PECSMCU6','5','  Al','10','D','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONE_I','PECSMCU6','6','Estrazione Individui:','1','U','N','','P_ESTR_I','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECSMCU6','7','Collettiva  :  Raggruppam. 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_2','PECSMCU6','8',' 2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_3','PECSMCU6','9',' 3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECSMCU6','10',' 4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TOTALI','PECSMCU6','11','Totali Generali:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO_DESFORMAT','PECSMCU6','12','Tipo Stampa','4','U','S','','P_SMCU6','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ORDINAMENTO','PECSMCU6','13','Ordinamento come modello CUD','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ETICHETTE','PECSMCU6','14','Stampa Etichette','1','U','N','','P_SECU3','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DICITURA','PECSMCU6','15','Originale/Copia:','1','U','N','','P_DICI','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DOMICILIO','PECSMCU6','16','Domicilio','1','U','N','X','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_STAMPA_ENTE','PECSMCU6','17','Stampa indirizzo per cessati','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PREVIDENZIALE','PECSMCU6','18','Non stampa dati Previdenziali','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_NOTE_1','PECSMCU6','19','Note fisse : 1 Riga','70','C','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_NOTE_2','PECSMCU6','20','2 Riga','70','C','N','','','','',''); 
 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013830','PECSMCU6','30','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000555','1013830','PECSMCU6','30','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000555','1013830','PECSMCU6','30','');

-- Inserimento a_catalogo_stampe per tutti i report

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECALCUD','ALLEGATO CUD PER ANNOTAZIONI','U','U','A_A','N','N','S'); 
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECANCUD','LISTA ANOMALIE CUD','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLMCUD','Stampa Nominativi CUD','U','U','A_C','N','N','S'); 
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSECU3','STAMPA ETICHETTE CUD','U','U','A_D','N','N','S');  
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSECU4','STAMPA ETICHETTE CUD','U','U','PDF','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMCUD','STAMPA MODULO CERTIFICAZIONE REDDITI','U','U','A_B','N','N','S');  
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMCU4','STAMPA MODULO CERTIFICAZIONE REDDITI','U','U','PDF','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PECSMCU6','STAMPA MODULO CERTIFICAZIONE REDDITI','U','U','PDF','N','N','S');

-- Inserimento guide_o per tutte le fasi

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_INDI_S','1','PREN','P','Prenot.','','ACAEPRPA','*','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_INDI_S','2','RAIN','I','Individuo','','P00RANAG','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_INDI_S','3','RECE','G','raGgrupp.','','PECERECE','',''); 

-- Inserimento domini selezione per tutti i parametri utilizzati

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_ESTR_I','1','','Tutti car. Automatici dati Fiscali');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_ESTR_I','2','','Tutti i car. Man Fiscali / Solo Prev.');   
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SECU3','I','','1 etichetta per individuo');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SECU3','M','','1 etichetta per modulo'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SM101','A','','Personale in servizio');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SM101','C','','Personale cessato nel periodo'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SM101','S','','Individuale');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SM101','T','','Totale');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_X','X','','Conferma della condizione proposta');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_DICI','C','','Copia');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_DICI','O','','Originale');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SMCU6','A_B','','Stampa Modulo Buffetti o Postalizzazione');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SMCU6','PDF','','Stampa con Fincatura');

start crp_p00updpp.sql

