delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PGMSPINS');                                                                                                                                                                                                      

delete from a_voci_menu where voce_menu = 'PGMSPINS';   

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) values ('P_SPINS','1','PREN','P','Prenot.','','ACAEPRPA','*','');                                                                                                                                        

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PGMSPINS','P00','SPINS','Stampa Personale in Servizio','F','D','ACAPARPR','',1,'P_SPINS');                                                                                           

