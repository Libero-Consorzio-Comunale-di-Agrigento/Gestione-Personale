delete from a_voci_menu where voce_menu = 'PPAEEVEC'; 
delete from a_passi_proc where voce_menu = 'PPAEEVEC';
delete from a_selezioni where voce_menu = 'PPAEEVEC'; 
delete from a_menu where voce_menu = 'PPAEEVEC' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
 values ('PPAEEVEC','P00','EEVEC','Estrazione Movimenti per Economico','F','D','ACAPARPR','',1,'A_PARA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PPAEEVEC','1','Estrazione Movimenti per Economico','Q','PPAEEVEC','','','N'); 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_OPZIONE','PPAEEVEC','1','Sel. Rif. Estr. Voci a Valore','1','U','S','P','P_LIM_ESTR','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ARRETRATO','PPAEEVEC','2','Arretrato per riferimenti A.P.','1','U','N','','P_ARR','','',''); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1004572','1004754','PPAEEVEC','30','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1004572','1004754','PPAEEVEC','30','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('A_PARA','1','PREN','P','Prenot...','','ACAEPRPA','*','X');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_ARR','P','','Conferma della condizione proposta'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LIM_ESTR','E','','Data di Riferimento Economico-Contabile'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LIM_ESTR','P','','Data di Riferimento Presenze-Assenze');

start crp_ppaeevec.sql

