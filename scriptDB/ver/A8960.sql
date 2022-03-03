-- Abilitazione MENU
delete from a_voci_menu where voce_menu = 'PECECFDE';   
delete from a_menu where voce_menu = 'PECECFDE' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECECFDE','P00','ECFDE','Denuncia EMENS I.N.P.S.','N','M','','',1,'');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000553','1013748','PECECFDE','21',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000553','1013748','PECECFDE','21',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000553','1013748','PECECFDE','21',''); 

-- Abilitazione Fase di Archiviazione CADMI
delete from a_voci_menu where voce_menu = 'PECCADMI';   
delete from a_passi_proc where voce_menu = 'PECCADMI';  
delete from a_selezioni where voce_menu = 'PECCADMI';   
delete from a_domini_selezioni where dominio = 'P_CADMI';
delete from a_guide_o where guida_o = 'P_CADMI';
delete from a_menu where voce_menu = 'PECCADMI' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa = 'PECCADMI';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCADMI','P00','CADMI','Caricamento Archivio EMENS','F','D','ACAPARPR','',1,'P_CADMI');  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','1','Caricamento Archivio EMENS','Q','PECCADMI','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','2','Verifica Presenza Errori','Q','CHK_ERR','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCADMI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADMI','92','Cancellazione errori','Q','ACACANRP','','','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCADMI','1','Elaborazione: Anno','4','N','N','','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE','PECCADMI','2','                      Mese','2','N','N','','','|','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCADMI','3','Tipo Elaborazione :','1','U','S','T','P_CADMI','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCADMI','4','Singolo Individuo: Codice','8','N','N','','','RAIN','0','1');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCADMI','5','Gestione :','8','U','N','%','','GEST','1','1');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FASCIA','PECCADMI','6','Fascia :','2','U','N','%','','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PECCADMI','7','Rapporto :','4','U','N','%','','CLRA','0','1');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RUOLO','PECCADMI','8','Identificativo Flag Ruolo :','1','U','N','N','P_RUOLO','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_GG','PECCADMI','9','Tipo Giorni :','1','U','S','I','P_TIPO_GG','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PRIVATI','PECCADMI','10','Accantonamento TFR PRIVATI:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SFASATO','PECCADMI','11','Mese Previdenziale Sfasato:','1','U','N','','P_X','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013748','1013749','PECCADMI','1',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013748','1013749','PECCADMI','1',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013748','1013749','PECCADMI','1',''); 

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CADMI','I','','Non altera Inseriti manualmente');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CADMI','P','','Parziale(non altera variazioni manuali)');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CADMI','S','','Singolo Individuo');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CADMI','T','','Totale'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CADMI','V','','Non altera Variati manualmente'); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','2','RAIN','I','Individui','P00RANAG','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','3','GEST','G','Gestioni','PGMEGEST','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','4','CLRA','R','Rapporti','PAMDCLRA','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCADMI','SEGNALAZIONI ARCHIVIAZIONE EMENS','U','U','A_C','N','N','S');

-- Abilitazione Form AADMI
delete from a_voci_menu where voce_menu = 'PECAADMI';   
delete from a_menu where voce_menu = 'PECAADMI' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECAADMI','P00','AADMI','Aggiornamento Archivio I.N.P.S. - EMENS','F','F','PECAADMI','',1,'P_AO1M'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013748','1013750','PECAADMI','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013748','1013750','PECAADMI','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013748','1013750','PECAADMI','2',''); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_AO1M','1','GEST','G','Gestioni','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_AO1M','2','RIRE','M','Mese','PECRMERE','');

insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_GEST','1','','','Definizione','PGMDGEST','');
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_GEST','2','','','Elenco','PGMEGEST','PGMDGEST');

-- Abilitazione Report LNDMI
delete from a_voci_menu where voce_menu = 'PECLNDMI';   
delete from a_passi_proc where voce_menu = 'PECLNDMI';  
delete from a_selezioni where voce_menu = 'PECLNDMI';   
delete from a_menu where voce_menu = 'PECLNDMI' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa = 'PECLNDMI';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECLNDMI','P00','LNDMI','Lista Nom. Denuncia I.N.P.S. - EMENS','F','D','ACAPARPR','',1,'P_PARA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECLNDMI','1','Lista Nom. Denuncia I.N.P.S. - EMENS','R','PECLNDMI','','PECLNDMI','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECLNDMI','1','Elaborazione: Anno','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE','PECLNDMI','2','  Mese','2','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECLNDMI','3', '  Gestione', 4, 'U', 'S', '%', '', 'GEST', 1, 1); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOTALI','PECLNDMI','4','Stampa Totali','1','U','N','','P_X','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013748','1013751','PECLNDMI','3',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013748','1013751','PECLNDMI','3',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013748','1013751','PECLNDMI','3',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLNDMI','LISTA NOMINATIVA DENUNCIA EMENS','U','U','A_C','N','N','S');

