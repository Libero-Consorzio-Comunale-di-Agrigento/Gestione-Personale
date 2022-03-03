delete from a_voci_menu where voce_menu = 'PRPRP';
delete from a_passi_proc where voce_menu = 'PRPRP';    
delete from a_selezioni where voce_menu = 'PRPRP';
delete from a_menu where voce_menu = 'PRPRP';  

delete from a_voci_menu where voce_menu = 'PRPRPDC';   
delete from a_passi_proc where voce_menu = 'PRPRPDC';  
delete from a_selezioni where voce_menu = 'PRPRPDC';   
delete from a_menu where voce_menu = 'PRPRPDC';

delete from a_voci_menu where voce_menu = 'PRPRPDCE';  
delete from a_passi_proc where voce_menu = 'PRPRPDCE'; 
delete from a_selezioni where voce_menu = 'PRPRPDCE';  
delete from a_menu where voce_menu = 'PRPRPDCE' ;    

delete from a_voci_menu where voce_menu = 'PRPRPDCS';  
delete from a_passi_proc where voce_menu = 'PRPRPDCS'; 
delete from a_selezioni where voce_menu = 'PRPRPDCS';  
delete from a_menu where voce_menu = 'PRPRPDCS' ;    

delete from a_voci_menu where voce_menu = 'PRPRPEP';   
delete from a_passi_proc where voce_menu = 'PRPRPEP';  
delete from a_selezioni where voce_menu = 'PRPRPEP';   
delete from a_menu where voce_menu = 'PRPRPEP' ;

delete from a_voci_menu where voce_menu = 'PRPRPLP';   
delete from a_passi_proc where voce_menu = 'PRPRPLP';  
delete from a_selezioni where voce_menu = 'PRPRPLP';   
delete from a_menu where voce_menu = 'PRPRPLP' ;

delete from a_voci_menu where voce_menu = 'PRPLCAEV';  
delete from a_passi_proc where voce_menu = 'PRPLCAEV'; 
delete from a_selezioni where voce_menu = 'PRPLCAEV';  
delete from a_menu where voce_menu = 'PRPLCAEV' ;    

delete from a_voci_menu where voce_menu = 'PRPLCLEV';  
delete from a_passi_proc where voce_menu = 'PRPLCLEV'; 
delete from a_selezioni where voce_menu = 'PRPLCLEV';  
delete from a_menu where voce_menu = 'PRPLCLEV' ;    

delete from a_voci_menu where voce_menu = 'PRPLMOEV';  
delete from a_passi_proc where voce_menu = 'PRPLMOEV'; 
delete from a_selezioni where voce_menu = 'PRPLMOEV';  
delete from a_menu where voce_menu = 'PRPLMOEV' ; 

delete from a_voci_menu where voce_menu = 'PPALMOEV';  
delete from a_passi_proc where voce_menu = 'PPALMOEV'; 
delete from a_selezioni where voce_menu = 'PPALMOEV';  
delete from a_menu where voce_menu = 'PPALMOEV' ;   

delete from a_voci_menu where voce_menu = 'PRPLRAPA';  
delete from a_passi_proc where voce_menu = 'PRPLRAPA'; 
delete from a_selezioni where voce_menu = 'PRPLRAPA';  
delete from a_menu where voce_menu = 'PRPLRAPA' ;    

delete from a_voci_menu where voce_menu = 'PRPLRICA';  
delete from a_passi_proc where voce_menu = 'PRPLRICA'; 
delete from a_selezioni where voce_menu = 'PRPLRICA';  
delete from a_menu where voce_menu = 'PRPLRICA' ;    

delete from a_voci_menu where voce_menu = 'PRPAGIRP';  
delete from a_passi_proc where voce_menu = 'PRPAGIRP'; 
delete from a_selezioni where voce_menu = 'PRPAGIRP';  
delete from a_menu where voce_menu = 'PRPAGIRP' ;   

delete from a_voci_menu where voce_menu = 'PPAAGIRP';  
delete from a_passi_proc where voce_menu = 'PPAAGIRP'; 
delete from a_selezioni where voce_menu = 'PPAAGIRP';  
delete from a_menu where voce_menu = 'PPAAGIRP' ; 
delete a_guide_o where guida_o='P_GIUS';
insert into a_guide_o ( guida_o, sequenza, alias, lettera, titolo,guida_v, voce_menu, voce_rif, proprieta, titolo_esteso ) values ('P_GIUS', 1, 'RAIN', 'I', 'Individui', null, 'PAMERAIN', null, null, null); 
insert into a_guide_o ( guida_o, sequenza, alias, lettera,titolo, guida_v, voce_menu, voce_rif, proprieta, titolo_esteso) values ('P_GIUS', 2, 'GIUS', 'G', 'Giustif.', null, 'PPADGIUS', null, null, null); 
insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PPAAGIRP','P00','AGIRP','Aggiornamento registrazioni da R.P.','F','F','PPAAGIRP','',1,'P_GIUS');                                                                                     
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1004572','1004730','PPAAGIRP','80','');                                                                                                                                                                
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1004572','1004730','PPAAGIRP','80','');                                                                                                                                                              

delete from a_voci_menu where voce_menu = 'PRPARAPA';  
delete from a_passi_proc where voce_menu = 'PRPARAPA'; 
delete from a_selezioni where voce_menu = 'PRPARAPA';  
delete from a_menu where voce_menu = 'PRPARAPA' ;    

delete from a_voci_menu where voce_menu = 'PRPDCAEV';  
delete from a_passi_proc where voce_menu = 'PRPDCAEV'; 
delete from a_selezioni where voce_menu = 'PRPDCAEV';  
delete from a_menu where voce_menu = 'PRPDCAEV' ;    

delete from a_voci_menu where voce_menu = 'PRPDCLEV';  
delete from a_passi_proc where voce_menu = 'PRPDCLEV'; 
delete from a_selezioni where voce_menu = 'PRPDCLEV';  
delete from a_menu where voce_menu = 'PRPDCLEV' ;    

delete from a_voci_menu where voce_menu = 'PRPDMOEV';  
delete from a_passi_proc where voce_menu = 'PRPDMOEV'; 
delete from a_selezioni where voce_menu = 'PRPDMOEV';  
delete from a_menu where voce_menu = 'PRPDMOEV' ;    

delete from a_voci_menu where voce_menu = 'PRPDRICA';  
delete from a_passi_proc where voce_menu = 'PRPDRICA'; 
delete from a_selezioni where voce_menu = 'PRPDRICA';  
delete from a_menu where voce_menu = 'PRPDRICA' ;    

delete from a_voci_menu where voce_menu = 'PRPDRIMO';  
delete from a_passi_proc where voce_menu = 'PRPDRIMO'; 
delete from a_selezioni where voce_menu = 'PRPDRIMO';  
delete from a_menu where voce_menu = 'PRPDRIMO' ;    

delete from a_voci_menu where voce_menu = 'PRPECAEV';  
delete from a_passi_proc where voce_menu = 'PRPECAEV'; 
delete from a_selezioni where voce_menu = 'PRPECAEV';  
delete from a_menu where voce_menu = 'PRPECAEV' ;    

delete from a_voci_menu where voce_menu = 'PRPECLEV';  
delete from a_passi_proc where voce_menu = 'PRPECLEV'; 
delete from a_selezioni where voce_menu = 'PRPECLEV';  
delete from a_menu where voce_menu = 'PRPECLEV' ;    

delete from a_voci_menu where voce_menu = 'PRPEMOEV';  
delete from a_passi_proc where voce_menu = 'PRPEMOEV'; 
delete from a_selezioni where voce_menu = 'PRPEMOEV';  
delete from a_menu where voce_menu = 'PRPEMOEV' ;    

delete from a_voci_menu where voce_menu = 'PRPEPSPA';  
delete from a_passi_proc where voce_menu = 'PRPEPSPA'; 
delete from a_selezioni where voce_menu = 'PRPEPSPA';  
delete from a_menu where voce_menu = 'PRPEPSPA' ;    

delete from a_voci_menu where voce_menu = 'PRPERAPA';  
delete from a_passi_proc where voce_menu = 'PRPERAPA'; 
delete from a_selezioni where voce_menu = 'PRPERAPA';  
delete from a_menu where voce_menu = 'PRPERAPA' ;    

delete from a_voci_menu where voce_menu = 'PRPRPSPA';  
delete from a_passi_proc where voce_menu = 'PRPRPSPA'; 
delete from a_selezioni where voce_menu = 'PRPRPSPA';  
delete from a_menu where voce_menu = 'PRPRPSPA' ;    

delete from a_voci_menu where voce_menu = 'PRPRRICA';  
delete from a_passi_proc where voce_menu = 'PRPRRICA'; 
delete from a_selezioni where voce_menu = 'PRPRRICA';  
delete from a_menu where voce_menu = 'PRPRRICA' ;    

delete from a_voci_menu where voce_menu = 'PRPRRIMO';  
delete from a_passi_proc where voce_menu = 'PRPRRIMO'; 
delete from a_selezioni where voce_menu = 'PRPRRIMO';  
delete from a_menu where voce_menu = 'PRPRRIMO' ;   

delete from a_voci_menu where voce_menu = 'PPACGIRP';  
delete from a_passi_proc where voce_menu = 'PPACGIRP'; 
delete from a_selezioni where voce_menu = 'PPACGIRP';  
delete from a_menu where voce_menu = 'PPACGIRP' ;   

delete from a_voci_menu where voce_menu = 'PRPCGIRP';  
delete from a_passi_proc where voce_menu = 'PRPCGIRP'; 
delete from a_selezioni where voce_menu = 'PRPCGIRP';  
delete from a_menu where voce_menu = 'PRPCGIRP' ;   

delete from a_voci_menu where voce_menu = 'PRPLANRP';  
delete from a_passi_proc where voce_menu = 'PRPLANRP'; 
delete from a_selezioni where voce_menu = 'PRPLANRP';  
delete from a_menu where voce_menu = 'PRPLANRP' ;  

delete from a_voci_menu where voce_menu = 'PPALANRP';  
delete from a_passi_proc where voce_menu = 'PPALANRP'; 
delete from a_selezioni where voce_menu = 'PPALANRP';  
delete from a_menu where voce_menu = 'PPALANRP' ; 
         
delete from a_voci_menu where voce_menu = 'PRPLGIRP';  
delete from a_passi_proc where voce_menu = 'PRPLGIRP'; 
delete from a_selezioni where voce_menu = 'PRPLGIRP';  
delete from a_menu where voce_menu = 'PRPLGIRP' ;

delete from a_voci_menu where voce_menu = 'PPALGIUS';  
delete from a_passi_proc where voce_menu = 'PPALGIUS'; 
delete from a_selezioni where voce_menu = 'PPALGIUS';  
delete from a_menu where voce_menu = 'PPALGIUS' ; 

delete from a_voci_menu where voce_menu = 'PRPLPRAS';  
delete from a_passi_proc where voce_menu = 'PRPLPRAS'; 
delete from a_selezioni where voce_menu = 'PRPLPRAS';  
delete from a_menu where voce_menu = 'PRPLPRAS' ;    

delete from a_voci_menu where voce_menu = 'PRPLRIMO';  
delete from a_passi_proc where voce_menu = 'PRPLRIMO'; 
delete from a_selezioni where voce_menu = 'PRPLRIMO';  
delete from a_menu where voce_menu = 'PRPLRIMO' ; 

delete from a_voci_menu where voce_menu = 'PPALRIMO';  
delete from a_passi_proc where voce_menu = 'PPALRIMO'; 
delete from a_selezioni where voce_menu = 'PPALRIMO';  
delete from a_menu where voce_menu = 'PPALRIMO' ; 

delete from a_voci_menu where voce_menu = 'PPASGIUS';  
delete from a_passi_proc where voce_menu = 'PPASGIUS'; 
delete from a_selezioni where voce_menu = 'PPASGIUS';  
delete from a_menu where voce_menu = 'PPASGIUS'; 

delete from a_voci_menu where voce_menu = 'PRPSGIRP';  
delete from a_passi_proc where voce_menu = 'PRPSGIRP'; 
delete from a_selezioni where voce_menu = 'PRPSGIRP';  
delete from a_menu where voce_menu = 'PRPSGIRP' ; 

delete from a_voci_menu where voce_menu = 'PRPDGIRP';  
delete from a_passi_proc where voce_menu = 'PRPDGIRP'; 
delete from a_selezioni where voce_menu = 'PRPDGIRP';  
delete from a_menu where voce_menu = 'PRPDGIRP' ; 

delete from a_voci_menu where voce_menu = 'PRPRGIRP';  
delete from a_passi_proc where voce_menu = 'PRPRGIRP'; 
delete from a_selezioni where voce_menu = 'PRPRGIRP';  
delete from a_menu where voce_menu = 'PRPRGIRP' ;

delete from a_voci_menu where voce_menu = 'PPADGIUS';                                                                                                                                                                                                                                                       
delete from a_passi_proc where voce_menu = 'PPADGIUS';                                                                                                                                                                                                                                                      
delete from a_selezioni where voce_menu = 'PPADGIUS';                                                                                                                                                                                                                                                       
delete from a_menu where voce_menu = 'PPADGIUS' ;                                                                                                                                                                                                                           
insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PPADGIUS','P00','DGIUS','Definizione giustificativi','F','F','PPADGIUS','',1,'P_GIUS');                                                                                              
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1004573','1004628','PPADGIUS','70','');                                                                                                                                                                
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1004573','1004628','PPADGIUS','70','');                                                                                                                                                              

delete from a_voci_menu where voce_menu = 'PPARGIUS';                                                                                                                                                                                                                                                       
delete from a_passi_proc where voce_menu = 'PPARGIUS';                                                                                                                                                                                                                                                      
delete from a_selezioni where voce_menu = 'PPARGIUS';                                                                                                                                                                                                                                                       
delete from a_menu where voce_menu = 'PPARGIUS';                                                                                                                                                                                                                             
insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PPARGIUS','P00','RGIUS','Ricerca giustificativi','F','F','PPARGIUS','',1,'P_GIUS_Q');                                                                                                
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1004631','1004639','PPARGIUS','70','');                                                                                                                                                                
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1004631','1004639','PPARGIUS','70','');                                                                                                                                                              
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) values ('P_GIUS_Q','1','GIUS','D','Definiz.','','PPADGIUS','','');                                                                                                                                       
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) values ('P_GIUS_Q','2','CAEV','C','Causale','','PPAECAEV','','');                                                                                                                                        
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) values ('P_GIUS_Q','3','MOEV','M','Motivi','','PPAEMOEV','','');                                                                                                                                         

