delete from a_voci_menu where voce_menu = 'PECEMOCA';   
delete from a_menu where voce_menu = 'PECEMOCA' and ruolo in ('*','AMM','PEC'); 
delete from a_guide_o where guida_o = 'P_MOCA';
delete from a_guide_v where guida_v = 'P_VOCO';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECEMOCA','P00','EMOCA','Elenco Movimenti Contabili Annuali','F','F','PECEMOCA','',1,'P_MOCA');          

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1001028','1013578','PECEMOCA','15','');          
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1001028','1013578','PECEMOCA','15','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1001028','1013578','PECEMOCA','15','');          

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_MOCA','1','RIRE','M','Mese','','PECRMERE','','');     
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_MOCA','2','VOEC','V','Voci','P_VOCO','','','');       

insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_VOCO','1','','C','Contabilizzazione','PECECOVO','');        
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_VOCO','2','','V','Voci contabili','PECEVOCO','');           
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_VOCO','3','','E','voci Economiche','PECEVOEC','');          
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_VOCO','4','','D','Definizione','PECDVOEC','');  
