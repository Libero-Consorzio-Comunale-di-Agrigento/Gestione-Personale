ALTER TABLE QUALIFICHE_MINISTERIALI ADD (COMPARTO VARCHAR2(10));

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ('ALTRO', NULL, NULL, 'QUALIFICHE_MINITERIALI.COMPARTO', 'Altro Personale', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ('EL', NULL, NULL, 'QUALIFICHE_MINITERIALI.COMPARTO', 'Enti Locali', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ('ELS', NULL, NULL, 'QUALIFICHE_MINITERIALI.COMPARTO', 'Enti Locali Personale Scuola', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ('SSN', NULL, NULL, 'QUALIFICHE_MINITERIALI.COMPARTO', 'Servizio Sanitario Nazionale', 'CFG', NULL, NULL); 

start crp_pecsmt12.sql
start crp_pecsmt13.sql

update qualifiche_ministeriali
set comparto = 'SSN'
where codice in 
( '0D0097', '0D0482', '0D0163', '0D0484', 'SD0E33', 'SD0N33', 'SD0E34', 
'SD0N34', 'SD0035', 'SD0036', 'SD0597', 'SD0E74', 'SD0N74', 'SD0E73', 
'SD0N73', 'SD0A73', 'SD0072', 'SD0598', 'SD0E49', 'SD0N49', 'SD0E48', 
'SD0N48', 'SD0A48', 'SD0047', 'SD0599', 'SD0E39', 'SD0N39', 'SD0E38', 
'SD0N38', 'SD0A38', 'SD0037', 'SD0600', 'SD0E13', 'SD0N13', 'SD0E12', 
'SD0N12', 'SD0A12', 'SD0011', 'SD0601', 'SD0E16', 'SD0N16', 'SD0E15', 
'SD0N15', 'SD0A15', 'SD0014', 'SD0602', 'SD0E42', 'SD0N42', 'SD0E41', 
'SD0N41', 'SD0A41', 'SD0040', 'SD0603', 'SD0E66', 'SD0N66', 'SD0E65', 
'SD0N65', 'SD0A65', 'SD0064', 'SD0604', 'SD0483', 'S18023', 'S16020', 
'S14056', 'S14E52', 'S13052', 'S18920', 'S16021', 'S14054', 'S18921', 
'S16022', 'S14055', 'S18922', 'S16019', 'S14053', 'S14E51', 'S13051', 
'S00062', 'PD0010', 'PD0S09', 'PD0A09', 'PD0605', 'PD0046', 'PD0S45', 
'PD0A45', 'PD0606', 'PD0004', 'PD0S03', 'PD0A03', 'PD0607', 'PD0044', 
'PD0S43', 'PD0A43', 'PD0608', 'P16006', 'P00062', 'TD0002', 'TD0S01', 
'TD0A01', 'TD0609', 'TD0071', 'TD0S70', 'TD0A70', 'TD0610', 'TD0068', 
'TD0S67', 'TD0A67', 'TD0611', 'T18025', 'T16024', 'T18027', 'T16026', 
'T14050', 'T14007', 'T14063', 'T14E59', 'T13059', 'T13660', 'T12057', 
'T12058', 'T11008', 'T00062', 'AD0032', 'AD0S31', 'AD0A31', 'AD0612', 
'A18029', 'A16028', 'A14005', 'A13018', 'A12017', 'A11030', 'A00062', 
'000061')
and dal in ( select max(dal) from validita_qualifica_ministero )
and comparto is null ;

update qualifiche_ministeriali
set comparto = 'EL'
where codice in 
( '0D0102', '0D0103', '0D0485', '0D0104', '0D0097', '0D0098', '0D0095', 
'0D0100', '0D0099', '0D6A00', '0D6000', '052486', '052487', '051488', 
'051489', '058000', '050000', '049000', '057000', '046000', '045000', 
'043000', '042000', '056000', '0B7A00', '0B7000', '038490', '038491', 
'037492', '037493', '036494', '036495', '055000', '034000', '032000', 
'054000', '0A5000', '028000', '027000', '025000', '053000', '000061', 
'000096')
and dal in ( select max(dal) from validita_qualifica_ministero )
and comparto is null ;

update qualifiche_ministeriali
set comparto = 'ELS'
where codice in 
( '0D0158',   '0D0E58',   '016132',   '016630',   '016135',   '016638', 
  '014154',   '014634',   '014155',   '014714',   '014143',   '014656', 
  '014646',   '013159',   '013498',   '013499',   '012117',   '012119', 
  '012125',   '098701',   '011121',   '016139',   '014138',   '016134', 
  '016631',   '016136',   '016639',   '014152',   '014635',   '014156', 
  '014643',   '014144',   '014657',   '014647',   '016802',   '014803', 
  '013160',   '013650',   '013653',   '012118',   '012120',   '012126', 
  '098708',   '011124',   '016133',   '016632',   '016137',   '016640', 
  '014153',   '014636',   '014157',   '014644',   '014145',   '014658', 
  '014648',   '016804',   '014805',   '013710',   '013651',   '013654', 
  '012613',   '012615',   '012621',   '098712',   '011617' )
and dal in ( select max(dal) from validita_qualifica_ministero )
and comparto is null ;

delete from a_domini_selezioni where dominio = 'COMPARTO';                                                                                                                                                                                                                                                  

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) values ('COMPARTO','%','','Tutti');                                                                                                                                                                                             
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) values ('COMPARTO','ALTRO','','Altro Personale');                                                                                                                                                                               
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) values ('COMPARTO','EL','','Enti Locali');                                                                                                                                                                                      
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) values ('COMPARTO','ELS','','Enti Locali Personale Scuola');                                                                                                                                                                    
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) values ('COMPARTO','SSN','','Servizio Sanitario Nazionale');                                                                                                                                                                    

delete from a_selezioni where voce_menu = 'PECSMTT1';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT1','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_DA','PECSMTT1','2','              Da','10','D','N','','','','','');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_A','PECSMTT1','3','              A','10','D','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT1','4','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT1','5','              Totale Generale','1','U','N','','P_SMTT','','','');                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT1','6','Comparto','10','U','N','%','COMPARTO','','','');                                                                      

delete from a_selezioni where voce_menu = 'PECSMTT2';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT2','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT2','2','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT2','3','              Totale Generale','1','U','N','','P_SMTT','','','');                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT2','4','Comparto','10','U','N','%','COMPARTO','','','');                                                                      

delete from a_selezioni where voce_menu = 'PECSMTT3';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT3','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT3','2','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT3','3','              Totale Generale','1','U','N','','P_SMTT','','','');                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT3','4','Comparto','10','U','N','%','COMPARTO','','','');                                                                      

delete from a_selezioni where voce_menu = 'PECSMTT4';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNI','PECSMTT4','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT4','2','Gestione:','4','U','S','%','','GEST','1','1');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT4','3','Totali Generali','1','U','N','','P_SMTT','','','');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT4','4','Comparto','10','U','N','%','COMPARTO','','','');                                                                      

delete from a_selezioni where voce_menu = 'PECSMTT5';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT5','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_DA','PECSMTT5','2','              Da','10','D','N','','','','','');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_A','PECSMTT5','3','              A','10','D','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT5','4','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT5','5','              Totale Generale','1','U','N','','P_SMTT','','','');                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT5','6','Comparto','10','U','N','%','COMPARTO','','','');                                                                      

delete from a_selezioni where voce_menu = 'PECSMTT6';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT6','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_DA','PECSMTT6','2','               Da','10','D','N','','','','','');                                                                       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_A','PECSMTT6','3','               A','10','D','N','','','','','');                                                                         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT6','4','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT6','5','              Totali Generali','1','U','N','','P_SMTT','','','');                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT6','6','Comparto','10','U','N','%','COMPARTO','','','');                                                                      


delete from a_selezioni where voce_menu = 'PECSMTT7';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT7','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT7','2','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT7','3','              Totali Generali','1','U','N','','P_SMTT','','','');                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT7','4','Comparto','10','U','N','%','COMPARTO','','','');                                                                      


delete from a_selezioni where voce_menu = 'PECSMTT8';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT8','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_DA','PECSMTT8','2','Da','10','D','N','','','','','');                                                                                      
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_A','PECSMTT8','3','A','10','D','N','','','','','');                                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT8','4','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT8','5','              Totali Generali','1','U','N','','P_SMTT','','','');                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT8','6','Comparto','10','U','N','%','COMPARTO','','','');                                                                      

delete from a_selezioni where voce_menu = 'PECSMTT9';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTT9','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTT9','2','Gestione:','4','U','S','%','','GEST','1','1');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMTT9','3','Totali Generali:','1','U','N','','P_SMTT','','','');                                                                       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTT9','4','Comparto','10','U','N','%','COMPARTO','','','');                                                                      


delete from a_selezioni where voce_menu = 'PECSMT11';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMT11','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_DA','PECSMT11','2','    Da','10','D','N','','','','','');                                                                                  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_A','PECSMT11','3','    A','10','D','N','','','','','');                                                                                    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMT11','4','Gestione:','4','U','S','%','','GEST','1','1');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMT11','5','Totali Generali:','1','U','N','','P_SMTT','','','');                                                                       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMT11','6','Comparto','10','U','N','%','COMPARTO','','','');                                                                      


delete from a_selezioni where voce_menu = 'PECSMT12';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMT12','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_DA','PECSMT12','2','Da','10','D','N','','','','','');                                                                                      
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_A','PECSMT12','3','A','10','D','N','','','','','');                                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GEST','PECSMT12','4','Gestione','4','U','S','%','','GEST','1','1');                                                                             
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMT12','5','Totali Generali','1','U','N','','P_SMTT','','','');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ARROTONDA','PECSMT12','6','Arrotonda','1','U','N','','P_X','','','');                                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMT12','7','Comparto','10','U','N','%','COMPARTO','','','');                                                                      


delete from a_selezioni where voce_menu = 'PECSMT13';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMT13','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_DA','PECSMT13','2','Da','10','D','N','','','','','');                                                                                      
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DATA_A','PECSMT13','3','A','10','D','N','','','','','');                                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMT13','4','Gestione','4','U','S','%','','GEST','1','1');                                                                         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TOT','PECSMT13','5','Totali Generali','1','U','N','','P_SMTT','','','');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ARROTONDA','PECSMT13','6','Arrotonda','1','U','N','','P_X','','','');                                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMT13','7','Comparto','10','U','N','%','COMPARTO','','','');                                                                      

delete from a_selezioni where voce_menu = 'PECSMTLA';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTLA','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO','PECSMTLA','2','              Tipo','1','U','S','T','P_TIPO_SMTLA','','','');                                                             
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTLA','3','Comparto','10','U','N','%','COMPARTO','','','');                                                                      


delete from a_selezioni where voce_menu = 'PECSMTN1';                                                                                                                                                                                                                                                       

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSMTN1','1','Elaborazione: Anno','4','N','N','','','','','');                                                                          
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECSMTN1','2','              Gestione','4','U','S','%','','GEST','1','1');                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('D_TIPO','PECSMTN1','3','Tipo Elaborazione','1','U','N','T','P_TIPO_SMT','','','');                                                                
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECSMTN1','4','Comparto','10','U','N','%','COMPARTO','','','');                                                                      
