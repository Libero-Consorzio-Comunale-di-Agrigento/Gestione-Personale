-- cancellazione voci di menù estemporanea anni precedenti

delete from a_voci_menu where voce_menu = 'PECXAC40';
delete from a_passi_proc where voce_menu = 'PECXAC40';
delete from a_selezioni where voce_menu = 'PECXAC40';
delete from a_menu where voce_menu = 'PECXAC40';

-- CUD 2006

delete from a_voci_menu where voce_menu = 'PECCUD06';
delete from a_passi_proc where voce_menu = 'PECCUD06';
delete from a_selezioni where voce_menu = 'PECCUD06';   
delete from a_menu where voce_menu = 'PECCUD06' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECCUD06');  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECCUD06','P00','CUD06','Stampa Modello CUD/2006 - Redditi 2005','F','D','ACAPARPR','FINE_ANNO',1,'P_INDI_S');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD06','1','Estrazione dati per Stampa CUD','Q','PECCUD06','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD06','2','Stampa Modulo Certificazione Redditi','R','PECCUD06','P_TIPO_DESFORMAT','PECCUD06','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD06','3','Controllo per Stampa Terza Pagina', 'Q', 'P00UPDPP', '','', 'N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD06','4','Stampa Terza Pagina CUD', 'R', 'PECSP306', 'P_TIPO_DESFORMAT', 'PECSP306', 'N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD06','5','Stampa Allegato Annotazioni','R','PECALC06','','PECALC06','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD06','6','Eliminazione registrazioni di lavoro','Q','ACACANAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD06','7','Pulizia tabella tab_report_fine_anno','Q','PECDTBFA','','','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DESFORMAT','PECCUD06','0','Tipo Stampa','4','U','S','PDF','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCUD06','1','Elaborazione:  Anno','4','N','N','2005','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCUD06','2','  Tipo','1','U','S','T','P_SM101','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCUD06','3','Individuale :  Codice','8','N','N','','','RAIN','0','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PECCUD06','4','Cessazione  :  Dal','10','D','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_AL','PECCUD06','5','  Al','10','D','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ESTRAZIONE_I','PECCUD06','6','Estrazione Individui:','1','U','N','','P_ESTR_I','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECCUD06','7','Collettiva  :  Raggruppam. 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECCUD06','8',' 2)','15','U','S','%','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECCUD06','9',' 3)','15','U','S','%','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECCUD06','10',' 4)','15','U','S','%','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOTALI','PECCUD06','11','Totali Generali:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DICITURA','PECCUD06','12','Originale/Copia:','1','U','N','','P_DICI','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DOMICILIO','PECCUD06','13','Domicilio','1','U','N','X','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_STAMPA_ENTE','PECCUD06','14','Stampa indirizzo per cessati','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PREVIDENZIALE','PECCUD06','15','Non stampa dati Previdenziali','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TERZA_PAGINA','PECCUD06','16','Stampa Terza Pagina','1','U','S','','D_TERZA_PAGINA','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_1','PECCUD06','17','Note fisse : 1 Riga','70','C','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_2','PECCUD06','18','2 Riga','70','C','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RIBASSATE','PECCUD06','19','Stampa note ribassate','2','U','S','NO','P_SI_NO','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013825','1013863','PECCUD06','3',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013825','1013863','PECCUD06','3',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013825','1013863','PECCUD06','3',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECALC06','ALLEGATO CUD PER ANNOTAZIONI','U','U','A_A','N','N','S');   
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCUD06','STAMPA MODULO CERTIFICAZIONE REDDITI','U','U','PDF','N','N','S');   
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSP306','STAMPA TERZA PAGINA DEL CUD','U','U','PDF','N','N','S');   

start crp_cursore_fiscale_06.sql
start crp_peccud06.sql
start crp_p00updpp.sql
