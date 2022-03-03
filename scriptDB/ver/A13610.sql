start crt_disp.sql
start crq_disp.sql
start crf_get_ord_pec_reco.sql
start crp_pecdprev.sql

insert into a_errori ( errore, descrizione )
values ('P05687','Impossibile Inserire il record: Definire almeno una voce');
insert into a_errori ( errore, descrizione )
values ('P05688','Impossibile Eseguire La fase: Istituti Incompleti');

-- Inserimento dei ref codes 

delete from PEC_REF_CODES where RV_DOMAIN = 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO';

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'CPDEL', '1', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Cassa Pensione Dipendenti Enti Locali'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'CPI', '2', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Cassa Pensione Insegnanti'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'CPS', '3', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Cassa Pensione Sanitari'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'CPSTAT', '4', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Cassa Pensione Statali'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'CPFPC', '5', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Fondo Previdenza e Credito CPDEL'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'CPFPCI', '6', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Fondo Previdenza e Credito CPI'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'CPFPCS', '7', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Fondo Previdenza e Credito CPS'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'INADEL', '8', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Istituto Nazionale per Dipendenti degli Enti Locali'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'TFR', '9', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Trattamento di Fine Rapporto'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'INPS', '10', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Istituto Nazionale Previdenza Sociale'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'INPS.COCO', '11', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Istituto Nazionale Previdenza Sociale ( Collaboratori )'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'INAIL', '12', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Istituto Nazionale Assicurazioni Infortuni sul Lavoro'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'INAIL.COCO', '13', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Istituto Nazionale Assicurazioni Infortuni sul Lavoro ( Collaboratori )'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'ONAOSI', '14', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Opera Nazionale Assistenza Orfani Sanitari Italiani'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'IRAP', '15', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Imposta Regionale sulle Attivita Produttive'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'ENPAM', '16', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Ente Nazionale Prev. E Ass. Medici e Odontoiatri'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
VALUES ( 'ENPDEP', '17', 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO', 'Ente Naz. di Prev. per i Dip. da enti di Diritto Pubblico');

-- Inizializzazione del dizionario
-- delete from DEF_ISTITUTI_PREVIDENZIALI;
-- prompt ' Inserimento previdenza '
insert into DEF_ISTITUTI_PREVIDENZIALI
( DISP_ID, ISTITUTO, SCAGLIONE, CONTR_VOCE, CONTR_SUB, RIT_VOCE, RIT_SUB)
select DISP_SQ.nextval
     , rv_low_value
     , decode(rivo_c.sub,'1',1,'2',2,0)
     , rivo_c.voce,rivo_c.sub
     , rivo_r.voce,rivo_r.sub
 from ritenute_voce rivo_c
    , ritenute_voce rivo_r
    , voci_economiche voec_c
    , voci_economiche voec_r
    , pec_ref_codes reco
where rivo_c.al is null
  and rivo_c.voce = voec_c.codice
  and voec_c.tipo = 'F'
  and voec_c.classe = 'R'
  and voec_c.estrazione = 'I'
  and rivo_r.al is null
  and rivo_r.voce = voec_r.codice
  and voec_r.tipo = 'T'
  and voec_r.classe = 'R' 
  and voec_r.estrazione = 'I'
  and rivo_c.sub = rivo_r.sub
  and rivo_c.sub in ( '1','2' )
  and instr(rivo_c.voce,'.')  = instr(rivo_r.voce,'.')
  and rtrim(substr(rivo_c.voce,instr(rivo_c.voce,'.')+1))
    = rtrim(substr(rivo_r.voce,instr(rivo_r.voce,'.')+1))
  and reco.rv_domain = 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO'
  and rv_low_value = rtrim(substr(rivo_c.voce,instr(rivo_c.voce,'.')+1))
  and rv_low_value in ( 'CPDEL','CPI','CPS','INADEL','ENPAM')
  and not exists ( select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                    where istituto = rv_low_value
                      and scaglione = decode(rivo_c.sub,'1',1,'2',2,0)
                      and contr_voce = rivo_c.voce
                      and contr_sub = rivo_c.sub
                      and rit_voce = rivo_r.voce
                      and rit_sub = rivo_r.sub
                  )
;
-- prompt ' Inserimento fondo credito '
insert into DEF_ISTITUTI_PREVIDENZIALI
( DISP_ID, ISTITUTO, SCAGLIONE, CONTR_VOCE, CONTR_SUB, RIT_VOCE, RIT_SUB)
select DISP_SQ.nextval
     , decode( rv_low_value
             , 'CPDEL','CPFPC'
             , 'CPI','CPFPCI'
             , 'CPS','CPFPCS'
             )
     , 1
     , rivo_c.voce,rivo_c.sub
     , rivo_r.voce,rivo_r.sub
 from ritenute_voce rivo_c
    , ritenute_voce rivo_r
    , voci_economiche voec_c
    , voci_economiche voec_r
    , pec_ref_codes reco
where rivo_c.al is null
  and rivo_c.voce = voec_c.codice
  and voec_c.tipo = 'F'
  and voec_c.classe = 'R'
  and voec_c.estrazione = 'I'
  and rivo_r.al is null
  and rivo_r.voce = voec_r.codice
  and voec_r.tipo = 'T'
  and voec_r.classe = 'R' 
  and voec_r.estrazione = 'I'
  and rivo_c.sub = rivo_r.sub
  and rivo_c.sub = '4'
  and instr(rivo_c.voce,'.')  = instr(rivo_r.voce,'.')
  and rtrim(substr(rivo_c.voce,instr(rivo_c.voce,'.')+1))
    = rtrim(substr(rivo_r.voce,instr(rivo_r.voce,'.')+1))
  and reco.rv_domain = 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO'
  and rv_low_value = rtrim(substr(rivo_c.voce,instr(rivo_c.voce,'.')+1))
  and rv_low_value in ( 'CPDEL','CPI','CPS')
  and not exists ( select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                    where istituto = decode( rv_low_value
                                           , 'CPDEL','CPFPC'
                                           , 'CPI','CPFPCI'
                                           , 'CPS','CPFPCS'
                                           )
                      and scaglione = 1
                      and contr_voce = rivo_c.voce
                      and contr_sub = rivo_c.sub
                      and rit_voce = rivo_r.voce
                      and rit_sub = rivo_r.sub
                  )
;
-- prompt ' Inserimento CP Statali '
insert into DEF_ISTITUTI_PREVIDENZIALI
( DISP_ID, ISTITUTO, SCAGLIONE, CONTR_VOCE, CONTR_SUB, RIT_VOCE, RIT_SUB)
select DISP_SQ.nextval, 'CPSTAT'
     , decode(rivo_c.sub,'1',1,'2',2,0)
     , rivo_c.voce,rivo_c.sub
     , rivo_r.voce,rivo_r.sub
 from ritenute_voce rivo_c
    , ritenute_voce rivo_r
    , voci_economiche voec_c
    , voci_economiche voec_r
where rivo_c.al is null
  and rivo_c.voce = voec_c.codice
  and voec_c.tipo = 'F'
  and voec_c.classe = 'R'
  and voec_c.estrazione = 'I'
  and rivo_r.al is null
  and rivo_r.voce = voec_r.codice
  and voec_r.tipo = 'T'
  and voec_r.classe = 'R' 
  and voec_r.estrazione = 'I'
  and rivo_c.sub = rivo_r.sub
  and rivo_c.sub in ('1','2')
  and instr(rivo_c.voce,'.')  = instr(rivo_r.voce,'.')
  and rtrim(substr(rivo_c.voce,instr(rivo_c.voce,'.')+1)) like '%STATO%'
  and rtrim(substr(rivo_c.voce,instr(rivo_c.voce,'.')+1))
    = rtrim(substr(rivo_r.voce,instr(rivo_r.voce,'.')+1))
  and not exists ( select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                    where istituto = 'CPSTAT'
                      and scaglione = decode(rivo_c.sub,'1',1,'2',2,0)
                      and contr_voce = rivo_c.voce
                      and contr_sub = rivo_c.sub
                      and rit_voce = rivo_r.voce
                      and rit_sub = rivo_r.sub
                  )
;
-- prompt 'inserimento ritenuta tfr'
insert into DEF_ISTITUTI_PREVIDENZIALI
( DISP_ID, ISTITUTO, SCAGLIONE, RIT_VOCE, RIT_SUB)
select DISP_SQ.nextval, rv_low_value
     , decode(rivo_r.sub,'1',1,'2',2,0)
     , rivo_r.voce,rivo_r.sub
 from ritenute_voce rivo_r
    , voci_economiche voec_r
    , pec_ref_codes reco
where rivo_r.al is null
  and rivo_r.voce = voec_r.codice
  and voec_r.tipo in ( 'C', 'T' )
  and voec_r.classe = 'R' 
  and voec_r.estrazione = 'I'
  and rivo_r.sub in ( '1','2' )
  and reco.rv_domain = 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO'
  and rv_low_value = rtrim(substr(rivo_r.voce,instr(rivo_r.voce,'.')+1))
  and rv_low_value in ('TFR')
  and not exists ( select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                    where istituto = rv_low_value
                      and scaglione = decode(rivo_r.sub,'1',1,'2',2,0)
                      and rit_voce = rivo_r.voce
                      and rit_sub = rivo_r.sub
                  )
;
-- prompt ' Inserimento contributi '
insert into DEF_ISTITUTI_PREVIDENZIALI
( DISP_ID, ISTITUTO, SCAGLIONE, CONTR_VOCE, CONTR_SUB )
select DISP_SQ.nextval 
     , rv_low_value
     , 1
     , rivo_c.voce
     , rivo_c.sub
 from ritenute_voce rivo_c
    , voci_economiche voec_c
    , pec_ref_codes reco
where rivo_c.al is null
  and rivo_c.voce = voec_c.codice
  and voec_c.tipo = 'F'
  and voec_c.classe = 'R'
  and exists ( select 'x' from estrazioni_voce
                where voce = rivo_c.voce
                  and sub = rivo_c.sub 
             )
  and reco.rv_domain = 'DEF_ISTITUTI_PREVIDENZIALI.ISTITUTO'
  and rv_low_value = rtrim(substr(rivo_c.voce,instr(rivo_c.voce,'.')+1))
  and rv_low_value in ( 'INPS','IRAP','INAIL' )
  and not exists ( select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                    where istituto = rv_low_value
                      and scaglione = 1
                      and contr_voce = rivo_c.voce
                      and contr_sub = rivo_c.sub
                  )
;

-- prompt ' Inserimento ONAOSI '
insert into DEF_ISTITUTI_PREVIDENZIALI
( DISP_ID, ISTITUTO, SCAGLIONE, CONTR_VOCE, CONTR_SUB, RIT_VOCE, RIT_SUB)
select DISP_SQ.nextval 
     ,'ONAOSI', 1
     , covo_c.voce,covo_c.sub
     , covo_r.voce,covo_r.sub
 from contabilita_voce covo_c
    , contabilita_voce covo_r
where covo_c.voce in ( select codice 
                         from voci_economiche
                        where specifica = 'ONAOSI' 
                          and tipo = 'F' and classe = 'R' ) 
  and covo_r.voce in ( select codice 
                         from voci_economiche
                        where specifica = 'ONAOSI' 
                          and tipo = 'T' and classe = 'R')
  and not exists ( select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                    where istituto = 'ONAOSI'
                      and scaglione = 1
                      and contr_voce = covo_c.voce
                      and contr_sub = covo_c.sub
                      and rit_voce = covo_r.voce
                      and rit_sub = covo_r.sub
                  )
;
-- prompt 'Fine Inserimento'
-- Creazione delle voci di menu

delete from a_voci_menu where voce_menu = 'PECDISPR';
delete from a_menu where voce_menu = 'PECDISPR' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECDISPR','P00','DISPR','Definizione Istituti Previdenziali','F','F','PECDISPR','',1,'P_DISP');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000350','1013823','PECDISPR','18','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000350','1013823','PECDISPR','18','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000350','1013823','PECDISPR','18','');

insert into a_guide_o ( guida_o, sequenza, alias, lettera, titolo, guida_v, voce_menu, voce_rif,proprieta, titolo_esteso ) 
values ( 'P_DISP', 1, 'VOCO', 'V', 'Voci', 'P_VOCO', NULL, NULL, NULL, NULL); 
insert into a_guide_v ( guida_v, sequenza, alias, lettera, titolo, voce_menu, voce_rif, proprieta ) 
values ( 'P_VOCO', 1, NULL, 'C', 'Contabilizzazione', 'PECECOVO', NULL, NULL); 
insert into a_guide_v ( guida_v, sequenza, alias, lettera, titolo, voce_menu, voce_rif, proprieta ) 
values ( 'P_VOCO', 2, NULL, 'V', 'Voci contabili', 'PECEVOCO', NULL, NULL); 
insert into a_guide_v ( guida_v, sequenza, alias, lettera, titolo, voce_menu, voce_rif, proprieta ) 
values ( 'P_VOCO', 3, NULL, 'E', 'voci Economiche', 'PECEVOEC', NULL, NULL); 
insert into a_guide_v ( guida_v, sequenza, alias, lettera, titolo, voce_menu, voce_rif, proprieta ) 
values ( 'P_VOCO', 4, NULL, 'D', 'Definizione', 'PECDVOEC', NULL, NULL); 

delete from a_voci_menu where voce_menu = 'PECDPREV';
delete from a_passi_proc where voce_menu = 'PECDPREV';  
delete from a_selezioni where voce_menu = 'PECDPREV';
delete from a_menu where voce_menu = 'PECDPREV' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECDPREV','P00','DPREV','Duplica Tabelle Previdenziali','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECDPREV','1','Duplica Tabelle Previdenziali','Q','PECDPREV','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000350','1013824','PECDPREV','19','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000350','1013824','PECDPREV','19','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000350','1013824','PECDPREV','19','');