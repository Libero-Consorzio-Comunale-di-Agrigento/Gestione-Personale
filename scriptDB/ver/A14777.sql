-- Abilitazione SORP6
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PDOSORPE');                      

delete from a_guide_v where guida_v in (select guida_v from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu in ('PDOSORPE','PXHMOND6')));                     

delete from a_voci_menu where voce_menu in ('PDOSORPE','PXHMOND6');                               

delete from a_passi_proc where voce_menu in ('PDOSORPE','PXHMOND6');                              

delete from a_selezioni where voce_menu in ('PDOSORPE','PXHMOND6');                               

delete from a_menu where voce_menu in ('PDOSORPE','PXHMOND6') and ruolo in ('*','AMM','PEC');                             

delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu in ('PDOSORPE','PXHMOND6'));                  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PDOSORPE','P00','SORPE','Dotazione Organica del Personale','F','D','ACAPARPR','',1,'P_SIDO_S');              

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PDOSORPE','1','Situazione parametrica di Dotazione','F','PDOCCADO','','','N');                    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PDOSORPE','2','Situazione parametrica di Dotazione','R','PDOSORPE','','PDOSORPE','N');                    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PDOSORPE','3','Situazione parametrica di Dotazione','Q','PGMDCADO','','','N');                    

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_ASSEGNAZIONE','PDOSORPE','0','Codice Assegnazione','15','U','S','%','','SETT','1','2');        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_ATTIVITA','PDOSORPE','0','Codice Attivita` o Area Att.','4','U','S','%','','','','');          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_CONTRATTO','PDOSORPE','0','Codice Contratto di Lavoro','4','U','S','%','','','','');           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_FIGURA','PDOSORPE','0','Codice Figura Giuridica','8','U','S','%','','FIGU','1','5');           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_LIVELLO','PDOSORPE','0','Livello Retributivo','4','U','S','%','','','','');            
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_ORE','PDOSORPE','0','Ore di Lavoro','5','U','S','%','','','','');              
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_POS_FUNZ','PDOSORPE','0','Codice Posizione Funzionale','4','U','S','%','','POFU','1','2');             
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_PROFILO','PDOSORPE','0','Codice Profilo Professionale','4','U','S','%','','POFU','1','1');             
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_QUALIFICA','PDOSORPE','0','Codice Qualifica Retributiva','8','U','S','%','','QUAL','1','5');           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_USO_INTERNO','PDOSORPE','0','Per Uso Interno','1','U','N','X','P_X','','','');          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_RUOLO','PDOSORPE','0','Codice Ruolo Retributivo','4','U','S','%','','','','');         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('PP_SEDE','PDOSORPE','0','Codice Sede','8','U','S','%','','SEDE','1','2');         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DF','PDOSORPE','0','Situazione di Diritto/Fatto','1','U','S','D','P_DF','','','');              
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GEST','PDOSORPE','0','Codice Gestione','15','U','S','%','','SETG','1','2');             
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RIFERIMENTO','PDOSORPE','1','Data di Riferimento','10','D','S','SYSDATE','','','','');          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SETTORE','PDOSORPE','2','Codice Settore','15','U','S','%','','','','');         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SE_NOMINATIVA','PDOSORPE','3','Situazione Nominativa','1','U','N','','P_X','','','');           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PDOSORPE','10','Codice Gestione','15','U','S','HMON','','SETG','1','2');             

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1013508','1013895','PDOSORPE','60','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1013508','1013895','PDOSORPE','60','');                   

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PDOSORPE','SITUAZ. PARAMETRICA DI DOTAZIONE','U','U','PDF','N','N','S');               

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','1','PREN','P','Prenot.','','ACAEPRPA','*','X');                      
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','2','SETG','G','Gestioni','','PPOEGESI','','X');                      
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','3','FIGU','F','Figure','','PGMEFIGU','','X');                
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','4','QUAL','Q','Qualif.','','PGMEQUAL','','X');               
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','5','SETT','S','sudd.Sett','','PGMESETT','','X');                     
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','6','SEDE','D','seDi','','PGMESEDE','','X');                  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','7','POFU','R','pRof.prof','','PGMEPOFU','','X');                     
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','8','POFU','Z','pos.funZ.','','PGMEPOFU','','X');                     
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SIDO_S','9','RUOL','U','rUoli   .','','PGMDRUOL','','X');                     

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_DF','D','','Dotazione di Diritto');                          
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_DF','F','','Dotazione di Fatto');                    
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_X','X','','Conferma della condizione proposta');                     

start crt_cndo.sql
start crp_pdoccado.sql
