--
-- Modifica parametri CRAAD
--

delete from a_selezioni where voce_menu = 'PECCRAAD';                                                                         

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECCRAAD','1','Gestione','8','U','N','%','','GEST','1','1');                                                                         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_FASCIA','PECCRAAD','2','Fascia','1','U','N','%','','','','');                                                                                   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_RAPPORTO','PECCRAAD','3','Rapporto','4','U','N','%','','CLRA','1','1');                                                                         
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GRUPPO','PECCRAAD','4','Gruppo','12','U','N','%','','GRRA','1','1');                                                                            
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CI','PECCRAAD','5','Cod.Ind.','8','N','N','','','RAIN','0','1');                                                                                
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO_RATE','PECCRAAD','6','Tipo Rate','1','U','S','','P_CRAAD_RATE','','','');                                                                  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_RATE','PECCRAAD','7','Numero Rate','2','N','S','','','','','');                                                                                 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_MESE','PECCRAAD','8','Mese decorrenza rate','2','N','S','','','','','');                                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO','PECCRAAD','9','Tipo Elaborazione','1','U','S','T','P_CRAAD','','','');   

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
                        values ('P_CRAAD_RATE','A','','Acconto Anno Corrente');                                                         
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
                        values ('P_CRAAD_RATE','S','','Saldo Anno Precedente');                                                           
alter  table addizionale_irpef_comunale 
modify ( dal date not null
       , scaglione number(15,5) not null)
;

start crp_peccraad.sql
start crp_peccmore_addizionali.sql         
start crp_peccmore10.sql
start crp_peccmore4.sql                    
