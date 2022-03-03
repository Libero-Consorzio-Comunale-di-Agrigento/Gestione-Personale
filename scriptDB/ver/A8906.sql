alter table gestioni add mittente_emens number(8);
alter table eventi_rapporto add inps varchar2(3);
alter table eventi_giuridici add inps varchar2(3);

start crq_deie.sql
start crt_deie.sql
start crt_seie.sql
start crt_dape.sql
start crt_vaie.sql
start crt_fose.sql
start crv_emens.sql

-- Inserimento codici di errore
insert into a_errori ( errore, descrizione )
values ('P07063','Incongruenza tra Giorni e Settimane');
insert into a_errori ( errore, descrizione )
values ('P07064','Verificare Assenza');

-- Aggiunta codice in ref_codes DENUNCIA_O1_INPS.QUALIFICA
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'9', NULL, NULL, 'DENUNCIA_O1_INPS.QUALIFICA', 'Dirigenti di aziende ind. assunti dall''01/01/2003 iscritti al F.P.L.D.'
, 'CFG', NULL, NULL); 

-- Inserimento ref_codes DENUNCIA_EMENS.TIPO_ASSUNZIONE
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.TIPO_ASSUNZIONE';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('1', NULL, NULL, 'DENUNCIA_EMENS.TIPO_ASSUNZIONE', 'Assunzione', NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('2', NULL, NULL, 'DENUNCIA_EMENS.TIPO_ASSUNZIONE', 'Variazioni societarie che comportano il cambio della matricola INPS'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3', NULL, NULL, 'DENUNCIA_EMENS.TIPO_ASSUNZIONE', 'Rientro Sospensione', NULL
, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3E', NULL, NULL, 'DENUNCIA_EMENS.TIPO_ASSUNZIONE', 'Rientro da aspettativa elettorale'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3S', NULL, NULL, 'DENUNCIA_EMENS.TIPO_ASSUNZIONE', 'Rientro da aspettativa sindacale'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('9', NULL, NULL, 'DENUNCIA_EMENS.TIPO_ASSUNZIONE', 'Altre motivazioni', NULL
, NULL, NULL); 

-- Inserimento ref_codes DENUNCIA_EMENS.TIPO_CESSAZIONE
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.TIPO_CESSAZIONE';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('1A', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Licenziamento', NULL, NULL
, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('1B', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Dimissioni', NULL, NULL
, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('1C', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Fine Contratto', NULL, NULL
, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('2', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Variazioni societarie che comportano il cambio della matricola INPS'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Sospensione', NULL, NULL
, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3E', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Sospensione per aspettativa elettorale'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3S', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Sospensione per aspettativa sindacale'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('9', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Altre Motivazioni', NULL
, NULL, NULL); 


-- Inserimento ref_codes EVENTI_GIURIDICI.CODICE_INPS
delete from pec_ref_codes where rv_domain = 'EVENTI_GIURIDICI.CODICE_INPS';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3', NULL, NULL, 'EVENTI_GIURIDICI.CODICE_INPS', 'Sospensione', NULL
, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3E', NULL, NULL, 'EVENTI_GIURIDICI.CODICE_INPS', 'Aspettativa elettorale'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('3S', NULL, NULL, 'EVENTI_GIURIDICI.CODICE_INPS', 'Aspettativa sindacale'
, NULL, NULL, NULL); 

-- Inserimento ref_codes DENUNCIA_EMENS.RILEVANZA
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.RILEVANZA';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('C', NULL, NULL, 'DENUNCIA_EMENS.RILEVANZA', 'Corrente', NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('P', NULL, NULL, 'DENUNCIA_EMENS.RILEVANZA', 'Precedente', NULL, NULL, NULL); 

-- Inserimento ref_codes DENUNCIA_EMENS.SPECIE_RAPPORTO
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.SPECIE_RAPPORTO';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('ASSO', NULL, NULL, 'DENUNCIA_EMENS.SPECIE_RAPPORTO', 'Associato', NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('COCO', NULL, NULL, 'DENUNCIA_EMENS.SPECIE_RAPPORTO', 'Collaboratore', NULL, NULL
, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('DIP', NULL, NULL, 'DENUNCIA_EMENS.SPECIE_RAPPORTO', 'Dipendente', NULL, NULL, NULL); 

-- Inserimento ref_codes DENUNCIA_EMENS.QUALIFICA2
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.QUALIFICA2';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('F', NULL, NULL, 'DENUNCIA_EMENS.QUALIFICA2', 'Tempo Pieno', NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('M', NULL, NULL, 'DENUNCIA_EMENS.QUALIFICA2', 'Tempo parziale di tipo Misto', NULL
, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('P', NULL, NULL, 'DENUNCIA_EMENS.QUALIFICA2', 'Tempo parziale di tipo Orizzontale'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('V', NULL, NULL, 'DENUNCIA_EMENS.QUALIFICA2', 'Tempo parziale di tipo Verticale', NULL
, NULL, NULL); 

-- Inserimento ref_codes DENUNCIA_EMENS.QUALIFICA3
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.QUALIFICA3';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('D', NULL, NULL, 'DENUNCIA_EMENS.QUALIFICA3', 'Tempo Determinato o Contratto a Termine'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('I', NULL, NULL, 'DENUNCIA_EMENS.QUALIFICA3', 'Tempo Indeterminato', NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('S', NULL, NULL, 'DENUNCIA_EMENS.QUALIFICA3', 'Stagionale', NULL, NULL, NULL); 

-- Inserimento ref_codes SETTIMANE_EMENS.CODICE_EVENTO
delete from pec_ref_codes where rv_domain = 'SETTIMANE_EMENS.CODICE_EVENTO';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('ACT', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Legge n. 88/1987', NULL
, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('CGO', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Cassa Integrazione Guadagni Ordinaria'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('CGS', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Cassa Integrazione Guadagni Straordinaria'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('DON', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Assenza per donazione di sangue (art. 13 della Legge 04/05/1990 n. 107)'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('INF', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Infortunio, per eventi di durata non inferiore a sette giorni'
, NULL, NULL, NULL);
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MA1', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Periodi di congedo di maternita'' e paternita'' ex artt. 16, 17, 20 e 28, D.Lgs. n. 151/2001'
, NULL, NULL, NULL);
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MA2', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Periodi di congedo paternale disciplinati dall'' art. 35, comma 1, D.Lgs. n. 151/2001, (6 mesi entro i 3 anni di vita del bambino)'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MA3', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Periodi di congedo per malattia del bambino di eta'' inferiore a 3 anni, disciplinati dall'' art. 49, comma 1, D.Lgs. n. 151/2001'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MA4', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Prolungamento del congedo parentale fino a 3 anni di vita del bambino con handicap, disciplinato dall'' art. 33, comma 1, D.Lgs. n. 151/2001 (art. 33, comma 1, legge n. 104 del 1992)'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MA5', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Permessi mensili per figli con handicap gravi, disciplinati dall'' art. 42, commi 2 e 3, D.Lgs. n. 151/2001 (art. 33, co. 3, L.104/1992)'
, NULL, NULL, NULL);
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MA6', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Permessi mensili art. 33, co. 6, legge n. 104 per lavoratore con handicap grave'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MA7', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Permessi mensili per assistere parenti ed affini entro il terzo grado, portatori di handicap grave, ex art. 33, comma 3, Legge n. 104/1992'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MAL', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Malattia, per eventi di durata non inferiore a sette giorni'
, NULL, NULL, NULL);
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MB1', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Riposi giornalieri fino al primo anno di vita del bambino, disciplinati dagli artt. 39 e 40 del D.Lgs. n. 151/2001 ex permessi per allattamento'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MB2', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Congedi parentali disciplinati dall'' art.35, comma 2, D.Lgs. n. 151/2001 (oltre i 6 mesi entro i 3 anni di vita del bambino ovvero fruiti tra il terzo e l'' ottavo anno)'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MB3', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Riposi giornalieri per figli con handicap gravi (fino al 3 anno di vita del bambino), disciplinati dall'' art. 42, comma 1, D.Lgs. n. 151/2001 (art.33, co. 2, L. 104/1992)'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MB4', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Congedi per malattia del bambino di eta'' compresa fra i 3 e gli 8 anni (fruibili alternativamente, nel limite di 5 giorni l'' anno per ciascun genitore), disciplinati dall'' art. 47, comma 2, D.Lgs. n. 151/2001'
, NULL, NULL, NULL);
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MB5', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Riposi giornalieri per lavoratore portatore di handicap grave (art. 33, co. 6, L. 104/1992)'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('MC1', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO', 'Congedi di cui all'' art. 42, comma 5, D.Lgs. n. 151/2001'
, NULL, NULL, NULL); 

-- Inserimento ref_codes SETTIMANE_EMENS.TIPO_COPERTURA
delete from pec_ref_codes where rv_domain = 'SETTIMANE_EMENS.TIPO_COPERTURA';
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('1', NULL, NULL, 'SETTIMANE_EMENS.TIPO_COPERTURA', 'Totalmente NON Retribuita'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('2', NULL, NULL, 'SETTIMANE_EMENS.TIPO_COPERTURA', 'Parzialmente Retribuita'
, NULL, NULL, NULL); 
insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('X', NULL, NULL, 'SETTIMANE_EMENS.TIPO_COPERTURA', 'Totalmente Retribuita', NULL
, NULL, NULL); 
COMMIT;

-- Aggiornamento ref_codes DENUNCIA_IMPORTI_GLA.ASSICURAZIONI
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,RV_TYPE )
VALUES ( '107', NULL, NULL, 'DENUNCIA_IMPORTI_GLA.ASSICURAZIONI', 'Fondi Speciali', 'CFG'); 

-- Inserimento TESTATA del DESRE e DESVC
INSERT INTO ESTRAZIONE_REPORT ( ESTRAZIONE, DESCRIZIONE, SEQUENZA, OGGETTO, NUM_RIC, NOTE ) 
VALUES ( 'DENUNCIA_EMENS', 'Estrazione per Denuncia EMENS', NULL, 'RAGI', 0, 'PECCADMI'); 

INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'ALIQUOTA',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Aliquota INPS - Collaboratori 10 % e 15%', 1, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'IMPONIBILE',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Imponibile INPS Dip. Non di Ruolo e Collaboratori 10 % e 15%', 1, NULL, NULL
, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'ALIQUOTA_01',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Aliquota INPS - Collaboratori aliquota 17.50  + 0.50', 2, '<18.00><19.00>'
, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'IMPONIBILE_01',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Imponibile INPS - Collaboratori aliquota 17.50 + 0.50', 2, '<38641><84049>', NULL
, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'AGEVOLAZIONE',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Agevolazioni Collaboratori', 3, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'VARIABILI',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Variabili Retributive', 3, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'PREAVVISO',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Indennita sostitutiva del Preavviso', 4, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'BONUS',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Lavoratori interessati all''incentivo L. 243/2004', 5, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'ESTERO',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Lavoratori Inviati all''Estero', 6, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'ATIPICA',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Contribuzione Atipica EX INPDAI', 7, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'SINDACALI',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Contribuzione Aggiuntiva per aspettativa Sindacale', 8, NULL, NULL, 1, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE,
MOLTIPLICA, ARROTONDA, DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'COMPENSO',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Compenso Collaboratori', 10, NULL, NULL, 1, NULL); 
COMMIT;