alter table denuncia_emens add ( 
 contributo         NUMBER(12,2)       NULL,
 ritenuta           NUMBER(12,2)       NULL,
 bonus              NUMBER(12,2)       NULL
);

-- delete from  ESTRAZIONE_VALORI_CONTABILI
-- where estrazione = 'DENUNCIA_EMENS'
-- and colonna in ('CONTRIBUTO_COCO_01','CONTRIBUTO_COCO_02'
-- ,'RITENUTA', 'RITENUTA_COCO_01', 'RITENUTA_COCO_02');

INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_EMENS', 'CONTRIBUTO_COCO_01',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Contributo INPS a carico Coll. - 10% e 15% e Primo Scaglione', 2, NULL, NULL
, 1, NULL);
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_EMENS', 'CONTRIBUTO_COCO_02',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Contributo INPS a carico Collaboratore - Secondo Scaglione', 2, NULL, NULL
, 1, NULL);
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_EMENS', 'RITENUTA',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Ritenuta INPS a carico Dipendente', 1, NULL, NULL
, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_EMENS', 'RITENUTA_COCO_01',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Ritenuta INPS a carico Coll. - 10% e 15% e Primo Scaglione', 2, NULL, NULL
, 1, NULL);
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_EMENS', 'RITENUTA_COCO_02',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Ritenuta INPS a carico Collaboratore - Secondo Scaglione', 2, NULL, NULL
, 1, NULL); 

-- Abilitazione voce di menu estemporanea per aggiornamento ritenute e contributi

delete from a_voci_menu where voce_menu = 'PECXADMI';
delete from a_passi_proc where voce_menu = 'PECXADMI';  
delete from a_selezioni where voce_menu = 'PECXADMI';
delete from a_domini_selezioni where dominio = 'P_SPECIE_EMENS';
delete from a_menu where voce_menu = 'PECXADMI' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECXADMI','P00','XADMI','Aggiornamento Rit/Contr EMENS','F','D','ACAPARPR','',1,'P_XADMI');  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXADMI','1','Aggiornamento Rit/Contr EMENS','Q','PECXADMI','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECXADMI','1','Elaborazione: Anno','4','N','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE','PECXADMI','2','  Mese','2','N','N','','','|','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECXADMI','3','Tipo Elaborazione :','1','U','S','T','P_CADMI','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECXADMI','4','Singolo Individuo: Codice','8','N','N','','','RAIN','0','1');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECXADMI','5','Gestione :','4','U','N','%','','GEST','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SPECIE','PECXADMI','6','Specie Rapporto :','4','U','N','%','P_SPECIE_EMENS','','',''); 

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SPECIE_EMENS','%','','Entrambi');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SPECIE_EMENS','COCO','','Solo Collaboratori');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_SPECIE_EMENS','DIP','','Solo Dipendenti');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_XADMI','1','PREN','P','Prenot.','','ACAEPRPA','*','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_XADMI','2','RAIN','I','Individui','','P00RANAG','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_XADMI','3','GEST','G','Gestioni','','PGMEGEST','','');


insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013748','1013827','PECXADMI','5','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013748','1013827','PECXADMI','5','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013748','1013827','PECXADMI','5','');

start crp_cursore_emens.sql
start crp_peccadmi.sql
start crp_pecxadmi.sql