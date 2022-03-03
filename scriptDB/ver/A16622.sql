
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PGMEREDO');                                                                                                                                                                                                      

delete from a_guide_v where guida_v in (select guida_v from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PGMEREDO'));                                                                                                                                                     

delete from a_voci_menu where voce_menu = 'PGMEREDO';                                                                                                                                                                                                                                                       

delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PGMEREDO');                                                                                                                                                                  

delete from a_passi_proc where voce_menu = 'PGMEREDO';                                                                                                                                                                                                                                                      

delete from a_selezioni where voce_menu = 'PGMEREDO';                                                                                                                                                                                                                                                       

delete from a_menu where voce_menu = 'PGMEREDO' and ruolo in ('*','AMM','PEC');                                                                                                                                                                                                                             

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PGMEREDO','P00','EREDO','Elenco Revisioni Dotazione','F','F','PGMEREDO','',1,'P_REDO_F');                                                                                            

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1000187','20001','PGMEREDO','94','');                                                                                                                                                                  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1000187','20001','PGMEREDO','94','');                                                                                                                                                                
                                                                                                                                    

INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ('A', NULL, NULL, 'REVISIONI_DOTAZIONE.STATO', 'Attiva', 'CFG', NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ('M', NULL, NULL, 'REVISIONI_DOTAZIONE.STATO', 'in Modifica', 'CFG', NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ('O', NULL, NULL, 'REVISIONI_DOTAZIONE.STATO', 'Obsoleta', 'CFG', NULL, NULL);

start crp_gp4_redo.sql
start crp_gp4do.sql