start crt_dged.sql

delete from a_voci_menu where voce_menu = 'PGMDGEDE';
delete from a_menu where voce_menu = 'PGMDGEDE' and ruolo in ('*','AMM','PEC');
delete from a_guide_o where guida_o in ( select guida_o from a_voci_menu where voce_menu = 'PGMDGEDE' );

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
 values ('PGMDGEDE','P00','DGEDE','Definizione Gestione per Denunce','F','F','PGMDGEDE','',1,'P_GEDE'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000221','1013883','PGMDGEDE','14','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000221','1013883','PGMDGEDE','14','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000221','1013883','PGMDGEDE','14','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GEDE','1','CONT','C','Contratti','','PGMDCONT','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GEDE','2','POSI','P','Posizioni','','PGMDPOSI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_GEDE','3','GEST','G','Gestioni','','PGMEGEST','','');
