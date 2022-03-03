-- Distribuzione DGIUS
delete from a_guide_o where guida_o in ( select guida_o from a_voci_menu where voce_menu = 'PPADGIUS');
delete from a_voci_menu where voce_menu = 'PPADGIUS';
delete from a_menu where voce_menu = 'PPADGIUS';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PPADGIUS','P00','DGIUS','Definizione giustificativi','F','F','PRPDGIRP','',1,'P_GIUS');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1004573','1004628','PPADGIUS','70','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1004573','1004628','PPADGIUS','70',''); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GIUS','1','CAEV','C','Causale','','PPAECAEV','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GIUS','2','MOEV','M','Motivi','','PPADMOEV','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GIUS','3','GIUS','R','Ricerca','','PPARGIUS','','');

-- Distribuzione RGIUS
delete from a_guide_o where guida_o in ( select guida_o from a_voci_menu where voce_menu = 'PPARGIUS');
delete from a_voci_menu where voce_menu = 'PPARGIUS';
delete from a_menu where voce_menu = 'PPARGIUS' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PPARGIUS','P00','RGIUS','Ricerca giustificativi','F','F','PRPRGIRP','',1,'P_GIUS_Q');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1004631','1004639','PPARGIUS','70','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1004631','1004639','PPARGIUS','70',''); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GIUS_Q','1','GIUS','D','Definiz.','','PPADGIUS','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GIUS_Q','2','CAEV','C','Causale','','PPAECAEV','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GIUS_Q','3','MOEV','M','Motivi','','PPAEMOEV','',''); 

-- Distribuzione DCAEV
delete from a_guide_v where guida_v in (select guida_v from a_guide_o 
where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PPADCAEV'));
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PPADCAEV');  
delete from a_voci_menu where voce_menu = 'PPADCAEV';
delete from a_menu where voce_menu = 'PPADCAEV' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PPADCAEV','P00','DCAEV','Definizione causali di evento','F','F','PPADCAEV','',1,'P_CAEV');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1004573','1004622','PPADCAEV','10','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1004573','1004622','PPADCAEV','10',''); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','1','CAEV','E','Elenco','','PPAECAEV','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','2','ASTE','A','Astens.','','PGMDASTE','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','3','CLDE','D','cl.Delib.','','PECDCLDE','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','4','VOCO','V','Voci','','PECDVOEC','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','5','VCEV','C','voCi ev.','','PPADVCEV','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','6','CAEV','S','cauSali','','PPAECAEV','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','7','CLBU','B','cl.Budget','','PECDCLBU','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CAEV','8','CAGI', 'G', 'Giustif.', 'P_CAGI', '', '','');

insert into a_guide_v ( guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif,proprieta)
values ('P_CAGI', 1, '', 'R', 'Ricerca', 'PPARGIUS', '', ''); 
insert into a_guide_v ( guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif,proprieta)
values ('P_CAGI', 2, '', 'R', 'Aggiornamento', 'PPADGIUS', '', ''); 
