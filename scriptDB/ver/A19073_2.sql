delete from a_voci_menu where voce_menu = 'PECFAF07';
delete from a_passi_proc where voce_menu = 'PECFAF07';
delete from a_selezioni where voce_menu = 'PECFAF07';
delete from a_menu where voce_menu = 'PECFAF07' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECFAF07','P00','FAF07','Inserimento Diz. Assegni Fam. 2007','F','D',null,'',1,'');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECFAF07','1','Dizionari Assegni Familiari 2007','Q','PECFAF07','','','N');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000351','1013868','PECFAF07','90','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000351','1013868','PECFAF07','90','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000351','1013868','PECFAF07','90','');

start ver\ins_asfa_07.sql
start ver\ins_scaf_07.sql
start crp_pecfaf07.sql 