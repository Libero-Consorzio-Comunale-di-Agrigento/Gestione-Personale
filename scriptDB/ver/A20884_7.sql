-- Inserimento posizione documenti per TFR che identifica più o meno 50 dipendenti

INSERT INTO POSIZIONI
( CODICE, DESCRIZIONE, SEQUENZA, POSIZIONE, RUOLO, STAGIONALE, CONTRATTO_FORMAZIONE, TEMPO_DETERMINATO, PART_TIME, DI_RUOLO
, TIPO_FORMAZIONE, TIPO_DETERMINATO, UNIVERSITARIO, COLLABORATORE, COPERTURA_PART_TIME, LSU, TIPO_PART_TIME, RUOLO_DO, CONTRATTO_OPERA,SOVRANNUMERO, AMM_CONS ) 
VALUES ( 'INPS', 'Gestione TFR > 50 dipendenti', 100, NULL, 'D', 'NO', 'NO', 'NO', 'NO', 'N'
, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NO', NULL); 
INSERT INTO POSIZIONI
( CODICE, DESCRIZIONE, SEQUENZA, POSIZIONE, RUOLO, STAGIONALE, CONTRATTO_FORMAZIONE, TEMPO_DETERMINATO, PART_TIME, DI_RUOLO
, TIPO_FORMAZIONE, TIPO_DETERMINATO, UNIVERSITARIO, COLLABORATORE, COPERTURA_PART_TIME, LSU, TIPO_PART_TIME, RUOLO_DO, CONTRATTO_OPERA,SOVRANNUMERO, AMM_CONS ) 
VALUES ( 'TFR', 'Gestione TFR < 50 dipendenti', 100, NULL, 'D', 'NO', 'NO', 'NO', 'NO', 'N'
, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NO', NULL); 

-- Inserimento evento giuridito per TFR a cui legare la posizione corretta defualt > 50

INSERT INTO EVENTI_GIURIDICI 
( CODICE, DESCRIZIONE, SEQUENZA, DELIBERA, CERTIFICABILE, PRESSO,
STATO_SERVIZIO, RILEVANZA, POSIZIONE, UNICO, CONTO_ANNUALE, CERT_SETT, ONAOSI, INPS )
VALUES ( 'TFR', 'Gestione TFR Finanziara 2007', 11, 'NO', 'NO', 'NO'
, 'NO', 'D', 'INPS', 'NO', NULL, 'NO', NULL, NULL);

-- Inserimento definizione sottocodici documento per TFR 

INSERT INTO SOTTOCODICI_DOCUMENTO 
( EVENTO, CODICE, DESCRIZIONE
, NOTA_DEL, NOTA_DESCRIZIONE,NOTA_NUMERO, NOTA_CATEGORIA, NOTA_PRESSO
, NOTA_N1, NOTA_N2, NOTA_A1, NOTA_A2, NOTA_N3, NOTA_A3,NOTA_N4, NOTA_A4 ) 
VALUES ( 'TFR', 'PREV', 'Destinazione TFR Previdenza Complemtare'
, 'Data Scelta', 'Tipo Scelta', NULL, NULL, NULL
, 'Forma Prev.', 'Quota', 'Iscr.Prev.Obbl.', 'Iscr.Prev.Compl', 'Alq. 31/12/2006', 'Tipo Quota', 'Alq. Minima', NULL); 
INSERT INTO SOTTOCODICI_DOCUMENTO
( EVENTO, CODICE, DESCRIZIONE
, NOTA_DEL, NOTA_DESCRIZIONE,NOTA_NUMERO, NOTA_CATEGORIA, NOTA_PRESSO
, NOTA_N1, NOTA_N2, NOTA_A1, NOTA_A2, NOTA_N3, NOTA_A3,NOTA_N4, NOTA_A4 ) 
VALUES ( 'TFR', 'TFR', 'Destinazione TFR Azienda / INPS'
, 'Data Scelta', 'Tipo Scelta', NULL, NULL, NULL
, NULL, NULL, 'Iscr.Prev.Obbl.', 'Iscr.Prev.Compl', NULL, NULL, NULL, NULL);

-- Inserimento ref_codes GESTIONE_TFR_EMENS.TIPO_SCELTA

delete from pec_ref_codes where rv_domain = 'GESTIONE_TFR_EMENS.TIPO_SCELTA';
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'T1','GESTIONE_TFR_EMENS.TIPO_SCELTA'
      , 'Scelta effettuata in modo esplicito utilizzando il mod.TFR1 (lavoratori occupati al 31/12/2006).'
      , 1);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'T2','GESTIONE_TFR_EMENS.TIPO_SCELTA'
      , substr('Scelta effettuata in modo esplicito utilizzando il mod.TFR2 ovvero secondo quanto previsto dal punto 1 '
             ||'della Delibera COVIP del 21/3/2007. (lavoratori il cui rapporto ha inizio in data successiva al '
             ||'31/12/2006 ovvero che rieffettuano la scelta per l''insorgere di nuove opportunita'' a seguito del '
             ||'cambio di rapporto di lavoro.',1,240)
      , 2);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'SA','GESTIONE_TFR_EMENS.TIPO_SCELTA'
      , 'Silenzio-assenso. (lavoratori che non hanno manifestato la loro volonta'' entro il '
      ||'termine del 30/6/2007, se occupati al 31/12/2006, ed entro sei mesi dalla data di assunzione '
      ||', se assunti successivamente al 31/12/2006)'
      , 3);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'SP','GESTIONE_TFR_EMENS.TIPO_SCELTA'
      , 'Scelta effettuata precedentemente al 31/12/2006 (lavoratori non tenuti alla compilazione del mod.TFR1 o TFR2)'
      , 4);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'VR','GESTIONE_TFR_EMENS.TIPO_SCELTA'
      , 'Variazione della scelta effettuata in precedenza nell''ambito dello stesso datore di lavoro'
      , 5);

-- Inserimento ref_codes GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_OBBLIGATORIA

delete from pec_ref_codes where rv_domain = 'GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_OBBLIGATORIA';
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'A93','GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_OBBLIGATORIA'
      , 'Anteriormente al 29/4/1993', 1);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'P93','GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_OBBLIGATORIA'
      , 'Successivamente al 28/4/1993', 2);

-- Inserimento ref_codes GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_COMPLEMENTARE

delete from pec_ref_codes where rv_domain = 'GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_COMPLEMENTARE';
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'S1','GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_COMPLEMENTARE'
      , 'Iscritto a Previdenza complementare ante 31/12/2006, con versamento integrale o di una quota di TFR'
      , 1);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'S2','GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_COMPLEMENTARE'
      , 'Iscritto a Previdenza complementare ante 31/12/2006, senza versamento integrale o di una quota di TFR'
      , 2);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'NO','GESTIONE_TFR_EMENS.ISCR_PREVIDENZA_COMPLEMENTARE'
      , 'NON iscritto a Previdenza complementare al 31/12/2006'
      , 3);


-- Inserimento ref_codes GESTIONE_TFR_EMENS.FONDO_TESORERIA
delete from pec_ref_codes where rv_domain = 'GESTIONE_TFR_EMENS.FONDO_TESORERIA';
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'SI','GESTIONE_TFR_EMENS.FONDO_TESORERIA'
      , 'Versamento al Fondo di Tesoreria in quanto azienda con almeno 50 dipendenti, '
      ||'o comunque lavoratore per il quale il datore di lavoro e'' tenuto al versamento in seguito a trasferimento '
      ||'societario'
      , 1);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'NO','GESTIONE_TFR_EMENS.FONDO_TESORERIA'
      , substr('Accantonamento in azienda, in quanto trattasi di azienda con meno di 50 dipendenti, '
             ||'o comunque di lavoratore per il quale non sussiste l’obbligo del versamento al Fondo di Tesoreria '
             ||'(es. lavoratore a domicilio, lavoratore a tempo determinato inferiore a 3 mesi, ecc.)',1,240)
      , 2);

-- Inserimento ref_codes GESTIONE_TFR_EMENS.FORMA_PREVIDENZA_COMPLEMENTARE

delete from pec_ref_codes where rv_domain = 'GESTIONE_TFR_EMENS.FORMA_PREVIDENZA_COMPLEMENTARE';
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( '139','GESTIONE_TFR_EMENS.FORMA_PREVIDENZA_COMPLEMENTARE'
      , 'FONDO PENSIONE NAZIONALE DI PREVIDENZA COMPLEMENTARE PER I LAVORATORI ADDETTI '
      ||'AI SERVIZI DI TRASPORTO PUBBLICO E PER I LAVORATORI DEI SETTORI AFFINI'
      , 1);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( '1417','GESTIONE_TFR_EMENS.FORMA_PREVIDENZA_COMPLEMENTARE'
      , 'PREVINDAI - FONDO PENSIONE'
      , 2);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( '5025','GESTIONE_TFR_EMENS.FORMA_PREVIDENZA_COMPLEMENTARE'
      ,'TAXBENEFIT NEW - PIANO INDIVIDUALE PENSIONISTICO DI TIPO ASSICURATIVO - FONDO PENSIONE'
      , 3);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( '9999','GESTIONE_TFR_EMENS.FORMA_PREVIDENZA_COMPLEMENTARE'
      , 'FONDINPS - FONDO COMPLEMENTARE INPS'
      , 4);

-- Inserimento ref_codes GESTIONE_TFR_EMENS.TIPO_QUOTA_PREV_COMPLEMENTARE

delete from pec_ref_codes where rv_domain = 'GESTIONE_TFR_EMENS.TIPO_QUOTA_PREV_COMPLEMENTARE';
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'QTFR','GESTIONE_TFR_EMENS.TIPO_QUOTA_PREV_COMPLEMENTARE'
      , 'Quota percentuale del TFR'
      , 1);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'QRUT','GESTIONE_TFR_EMENS.TIPO_QUOTA_PREV_COMPLEMENTARE'
      , 'Quota percentuale della retribuzione utile o convenzionale'
      , 2);
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation )
values( 'QFIS','GESTIONE_TFR_EMENS.TIPO_QUOTA_PREV_COMPLEMENTARE'
      , 'Quota fissa'
      , 3);

