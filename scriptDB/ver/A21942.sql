--
-- Eliminazione parametri da SMDMA
--
delete from a_selezioni
 where voce_menu = 'PECSMDMA'
   and parametro = 'P_INVII'
/
delete from a_selezioni
 where voce_menu = 'PECSMDMA'
   and parametro = 'P_FORZA_CREDITO'
/

--
-- Inserimento nuovo parametro in CADMA
--
insert into a_selezioni
       (parametro,voce_menu,sequenza,descrizione,lunghezza,formato
       ,obbligo,valore_default,dominio)
values ('P_FORZA_CREDITO','PECCADMA',12
       ,'Forza Contr. Cassa Credito',1,'U','S','N','P_FORZA_CREDITO')
/

--
-- Inserimento nuovo passo in CADMA
--
insert into a_passi_proc
       (voce_menu,passo,titolo,tipo,modulo)
values ('PECCADMA',3,'Calcolo Totali DMA','Q','PECCTDMA')
/

--
-- Inserimento nuove segnalazioni
--
insert into a_errori (errore,descrizione)
values ('P00115','Rieseguire Calcolo Totali DMA: informazioni individuali modificate')
/
insert into a_errori (errore,descrizione)
values ('P00118','Superato numero massimo di file')
/

--
-- Modifiche sequenze voci di menù
--
update a_menu set sequenza = 10
where voce_menu = 'PECCADMA'
/
update a_menu set sequenza = 20
where voce_menu = 'PECAADMA'
/
update a_menu set sequenza = 30
where voce_menu = 'PECAADMQ'
/
update a_menu set sequenza = 60
where voce_menu = 'PECAVDMA'
/
update a_menu set sequenza = 70
where voce_menu = 'PECSMDMA'
/
update a_menu set sequenza = 80
where voce_menu = 'PECLNDMA'
/
update a_menu set sequenza = 100
where voce_menu = 'PECUADMA'
/
update a_menu set sequenza = 110
where voce_menu = 'PXINPDMA'
/
update a_menu set sequenza = 90
where voce_menu = 'PECLVADM'
/

--
-- Inserimento voce ATDMA
--
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECATDMA');

delete from a_guide_v where guida_v in (select guida_v from a_guide_o 
 where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECATDMA'));

delete from a_voci_menu where voce_menu = 'PECATDMA';                                                                                           
delete from a_passi_proc where voce_menu = 'PECATDMA';

delete from a_selezioni where voce_menu = 'PECATDMA';

delete from a_menu where voce_menu = 'PECATDMA' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECATDMA','P00','ATDMA','Aggiornamento Totali DMA','F','F','PECATDMA','',1,'P_ATDMA');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1013754','19959','PECATDMA',50,'');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013754','19959','PECATDMA',50,'');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013754','19959','PECATDMA',50,'');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ATDMA','1','RIRE','M','Mese','','PECRMERE','','');

--
-- Inserimento voce CTDMA
--

delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECCTDMA');

delete from a_guide_v 
where guida_v in (select guida_v from a_guide_o 
                   where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECCTDMA'));

delete from a_voci_menu where voce_menu = 'PECCTDMA';

delete from a_passi_proc where voce_menu = 'PECCTDMA';

delete from a_selezioni where voce_menu = 'PECCTDMA';

delete from a_menu where voce_menu = 'PECCTDMA' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCTDMA','P00','CTDMA','Calcolo Totali DMA','F','D','ACAPARPR','',1,'P_CCADMA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCTDMA','1','Calcolo Totali DMA','Q','PECCTDMA','','','N');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCTDMA','93','Errori di Elaborazione','R','ACARAPPR','','PECCADMA','N');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCTDMA','94','Cancellazione errori','Q','ACACANRP','','','N');

insert into a_selezioni
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCTDMA','1','Elaborazione: Anno','4','N','N','','','','','');

insert into a_selezioni
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE','PECCTDMA','2','                      Mese','2','N','N','','','','','');

insert into a_selezioni
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCTDMA','3','Gestione','8','U','N','%','','GEST','1','1');

insert into a_selezioni
(parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FORZA_CREDITO','PECCTDMA','4','Forza Contr. Cassa Credito','1','U','S','N','P_FORZA_CREDITO','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013754','19979','PECCTDMA','40','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013754','19979','PECCTDMA','40','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013754','19979','PECCTDMA','40','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','1','PREN','P','Pren.','','ACAEPRPA','*','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','2','RAIN','I','Individuo','','P00RANAG','','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','3','GEST','G','Gestioni','','PGMEGEST','','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','4','CLRA','R','Rapporti','','PAMDCLRA','','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta)
values ('P_CCADMA','5','GRRA','U','grUppi','','PAMDGRRA','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_FORZA_CREDITO','A','','Azzera Imponibile Cassa Credito');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_FORZA_CREDITO','F','','Forza Contributo Cassa Credito');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_FORZA_CREDITO','N','','Lascia Valori Originali');

--
-- Modifiche alle tabelle e vista
-- vedi start in A21749

-- drop view totali_versamenti_dma; 
-- la drop non serve nel crv c'è la CREATE OR REPLACE 
start crv_tdma.sql

--
-- Creazione package
--
start crp_pecctdma.sql
start crp_pecsmdma.sql
-- start crp_peccadma.sql inclusa in A20945
start crf_ddma_tma.sql
start crf_ddmq_tma.sql
start crf_ddma_tb.sql
start crf_ddma_tc.sql

