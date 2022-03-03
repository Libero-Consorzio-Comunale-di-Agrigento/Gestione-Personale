alter table movimenti_fiscali
add ( det_con_ac number(12,2)
    , det_fig_ac number(12,2)
    , det_alt_ac number(12,2)
    , det_spe_ac number(12,2));

alter table validita_fiscale
add ( VAL_CONV_DET_FAM     NUMBER(12,2)
    , VAL_CONV_DET_AGG_FIG NUMBER(12,2)
    , VAL_CONV_DET_DIP     NUMBER(12,2)
    , VAL_CONV_DET_PEN1    NUMBER(12,2)
    , VAL_CONV_DET_PEN2    NUMBER(12,2)
    , VAL_MIN_DET_DIP      NUMBER(12,2)
    , VAL_MIN_DET_PEN1     NUMBER(12,2)
    , VAL_MIN_DET_PEN2     NUMBER(12,2));

--
-- REF_CODES
--
insert into PEC_REF_CODES 
      (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN
      ,RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('DET_NGOD', null, '300', 'VOCI_ECONOMICHE.AUTOMATISMO'
       ,'Detrazione fiscale NON Goduta', 'CFG', null, null);
update pec_ref_codes set rv_meaning = 'Detrazioni Dipendente' 
where rv_domain= 'DETRAZIONI_FISCALI.TIPO' and rv_low_value = 'DD';
update pec_ref_codes set rv_meaning = 'Detrazioni Pens. < 75 anni' 
where rv_domain= 'DETRAZIONI_FISCALI.TIPO' and rv_low_value = 'DP';
update pec_ref_codes set rv_meaning = 'Detrazioni Pens. > 75 anni' 
where rv_domain= 'DETRAZIONI_FISCALI.TIPO' and rv_low_value = 'P2';
insert into PEC_REF_CODES 
      (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN
      ,RV_MEANING,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('DA', null, null, 'DETRAZIONI_FISCALI.TIPO'
       ,'Detrazioni Assimilati', 'CFG', null, null);
update pec_ref_codes
   set rv_meaning = 'Detr.: Attr. Minimo garantito. Ded.: Base Intera e Agg. in 365esimi'
 where rv_domain = 'RAPPORTI_RETRIBUTIVI.ATTRIBUZIONE_SPESE'
   and rv_low_value = '1';
update pec_ref_codes
   set rv_meaning = 'Detrazioni Assimilati per intero. Deduzioni: solo Base Intera'
 where rv_domain = 'RAPPORTI_RETRIBUTIVI.ATTRIBUZIONE_SPESE'
   and rv_low_value = '2';

--
-- NUOVA VOCE
--
INSERT INTO VOCI_ECONOMICHE ( CODICE, OGGETTO, OGGETTO_AL1, OGGETTO_AL2, SEQUENZA, CLASSE,
ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, MESE, MENSILITA,
NOTE )
select 'DET.NGOD', 'Detrazioni Annue NON Godute', NULL, NULL, sequenza+1, 'A', NULL, NULL, 'F', 'DET_NGOD',NULL
, NULL, 'A', NULL, NULL, NULL
from voci_economiche
where sequenza =(select min(sequenza) from voci_economiche x
where not exists (select 'x' from voci_economiche where sequenza = x.sequenza+1)
and sequenza > (select sequenza from voci_economiche where automatismo = 'DET_GOD')
);
INSERT INTO VOCI_CONTABILI (VOCE,SUB,ALIAS,TITOLO)
VALUES ('DET.NGOD','*','DET.NGOD','DETRAZIONI ANNUE NON GODUTE');

INSERT INTO CONTABILITA_VOCE (VOCE,SUB,DESCRIZIONE,DES_ABB,FISCALE,STAMPA_TAR,STAMPA_QTA,
                              STAMPA_IMP,STARIE_TAR,STARIE_QTA,STARIE_IMP,STAMPA_FR)
VALUES ('DET.NGOD','*','DETRAZIONI ANNUE NON GODUTE','DET.NGOD','N','N','N','Q','N','N','Q','F');


--
-- ERRORI
--

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P00605', 'Valore non ammesso in Attribuzione in relazione a Tipo Detrazioni', NULL
, NULL, NULL);

--
-- MENU	
--

-- Aggiornamento descrizione DDEFI
update a_voci_menu 
   set titolo = 'Altre Detrazioni Fiscali'
 where voce_menu = 'PECDDEFI';

-- Aggiornamento descrizione DDECF
update a_voci_menu 
   set titolo = 'Detrazione Fiscale per Carico Familiare'
 where voce_menu = 'PECDDECF';

-- Abilitazione solo da acronimo di DSCDF
delete from a_menu where voce_menu = 'PECDSCDF' and ruolo in ('*','AMM','PEC');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1004365','19705','PECDSCDF','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1004365','19705','PECDSCDF','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1004365','19705','PECDSCDF','99','');

-- Eliminazione F2005
delete from a_voci_menu where voce_menu = 'PECF2005';
delete from a_passi_proc where voce_menu = 'PECF2005';
delete from a_selezioni where voce_menu = 'PECF2005';
delete from a_menu where voce_menu = 'PECF2005' and ruolo in ('*','AMM','PEC');

-- Eliminazione F0502                                                                                    
delete from a_voci_menu where voce_menu = 'PECF0502';
delete from a_passi_proc where voce_menu = 'PECF0502';
delete from a_selezioni where voce_menu = 'PECF0502';
delete from a_menu where voce_menu = 'PECF0502' and ruolo in ('*','AMM','PEC');

-- Inserimento voce F2007
delete from a_voci_menu where voce_menu = 'PECF2007';
delete from a_passi_proc where voce_menu = 'PECF2007';
delete from a_selezioni where voce_menu = 'PECF2007';
delete from a_menu where voce_menu = 'PECF2007' and ruolo in ('*','AMM','PEC');
insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PECF2007','P00','F2007','Definizione Diz. Fiscali Finanz. 2007','F','D','ACAPARPR','',1,'');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo) values
('PECF2007',1,'Definizione Diz. Fiscali Finanz.2007','Q','PECF2007');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stampa) values
('PECF2007',2,'Definizione Diz. Fiscali Finanz.2007','R','PECSAPST','PECLCAFA');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio) values
('P_SCAGLIONI','PECF2007',1,'Eliminazione scaglioni ACAFA',1,'U','N','X','P_X');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','PEC','1000548','19706','PECF2007','2','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1000548','19706','PECF2007','2','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1000548','19706','PECF2007','2','');  

-- Salvataggio RARE e Modifica record "nuovi"
create table RARE_ANTE_18405 as select * from rapporti_retributivi;
create table RARS_ANTE_18405 as select * from rapporti_retributivi_storici;
alter table rapporti_retributivi disable all triggers;
alter table rapporti_retributivi_storici disable all triggers;
  update rapporti_retributivi rare
     set TIPO_ULTERIORI = ''
   where TIPO_ULTERIORI is not null
     and exists ( select 'x' 
                    from rapporti_retributivi_storici
                  where ci = rare.ci 
                    and dal >= to_date('01012007','ddmmyyyy')
                    and TIPO_ULTERIORI is not null
                )
  ;
  update rapporti_retributivi_storici
     set TIPO_ULTERIORI = ''
   where dal >= to_date('01012007','ddmmyyyy')
     and TIPO_ULTERIORI is not null
  ;
alter table rapporti_retributivi enable all triggers;
alter table rapporti_retributivi_storici enable all triggers;

start crp_gp4_defi.sql
start crp_gp4_rare.sql
start crp_peccmore_autofam.sql
start crp_peccmore12.sql
start crp_peccmore11.sql
start crp_peccmore10.sql
start crp_peccmore3.sql
start crp_peccmore2.sql
start crp_peccmore1.sql
start crp_pecf2007.sql
start crv_su_cafa2007.sql
start crv_su_rare2007.sql
start crf_carica_rain_rare.sql