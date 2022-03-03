-- Inserimento nuovi ref_codes DENUNCIA_EMENS.TIPO_CESSAZIONE

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('1D', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE'
       , 'Licenziamento per giusta causa o giustificato motivo soggettivo'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('4', NULL, NULL, 'DENUNCIA_EMENS.TIPO_CESSAZIONE', 'Decesso', NULL, NULL, NULL);

-- Inserimento nuovi ref_codes SETTIMANE_EMENS.CODICE_EVENTO

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('SOL', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO'
       , 'Contratto di solidarietà (art. 1 Legge 29 dicembre 1984, n.863).'||
         'Per l’anno 2005 l’evento potrà essere gestito congiuntamente '||
         'agli eventi di Cassa Integrazione. A decorrere dal 1/1/2006 '||
         'dovrà essere gestito distintamente.'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning,RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('DMO', NULL, NULL, 'SETTIMANE_EMENS.CODICE_EVENTO'
       , 'Assenza per donazione di midollo osseo. Può essere presente dal 1/1/2006.'
       , NULL, NULL, NULL); 


-- Inserimento nuovi ref_codes DENUNCIA_O1_INPS.TIPO_RAPPORTO per tipo di contribuzione

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('F5', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratori frontalieri divenuti disoccupati in Svizzera e iscritti nelle liste di mobilita''.... art. 25, comma 9, legge 223/1991'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('F6', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratori frontalieri divenuti disoccupati in Svizzera e iscritti nelle '||
          'liste di mobilita''.... art. 8, comma 2, legge 223/1991'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('F7', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratori frontalieri divenuti disoccupati in Svizzera e iscritti nelle '||
         'liste di mobilita''.... art. 8, comma 2, legge 223/1991'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('G0', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratore con contratto di lavoro intermittente a tempo indeterminato.'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('H0', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratore con contratto di lavoro intermittente a tempo determinato.'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('P5', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratori iscritti in deroga nelle liste di mobilità, assunti con contratto a tempo indeterminato '||
	'per i quali i contributi sono dovuti nella misura prevista per gli apprendisti per 18 mesi.'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('P6', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratori iscritti in deroga nelle liste di mobilità, assunti con contratto a tempo determinato per '||
	'i quali spetta il versamento della contribuzione come per gli apprendisti per 12 mesi.'
       , NULL, NULL, NULL); 

insert into pec_ref_codes
( rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 )
values ('P7', NULL, NULL, 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
       , 'Lavoratori iscritti in deroga nelle liste di mobilità, assunti con contratto a tempo determinato '||
	'e trasformato a tempo indeterminato, per i quali spetta il versamento della contribuzione '||
	'come per gli apprendisti per ulteriori 12 mesi.'
       , NULL, NULL, NULL);


alter table dati_particolari_emens add  settimane_utili    NUMBER(5,2);

start crp_cursore_emens.sql
start crv_emens.sql

