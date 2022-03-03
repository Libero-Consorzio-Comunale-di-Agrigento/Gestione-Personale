SET TERMOUT OFF 

REM ============================================================
REM    Extract TABLE :   PEB_REF_CODES
REM ============================================================

WHENEVER SQLERROR EXIT

ALTER TABLE peb_ref_codes DISABLE ALL TRIGGERS;

DELETE FROM peb_ref_codes;

WHENEVER SQLERROR CONTINUE

INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('PR',NULL,NULL,'PARAMETRI_BADGE.TIPO_NUMERAZIONE','Progressivo',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('PM',NULL,NULL,'PARAMETRI_BADGE.TIPO_NUMERAZIONE','Progressivo per Matricola',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('MT',NULL,NULL,'PARAMETRI_BADGE.TIPO_NUMERAZIONE','Matricola',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('AL',NULL,NULL,'PARAMETRI_BADGE.TIPO_NUMERAZIONE','Algoritmo personalizzato',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('ASU','A',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_ATTRIBUZIONE','Assunzione',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('SOT','A',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_ATTRIBUZIONE','Sostituzione',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('ASE','S',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_ATTRIBUZIONE','Assenza',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('COM','S',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_ATTRIBUZIONE','Comando',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('RIA','A',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_ATTRIBUZIONE','Riattivazione',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('SOP','C',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_CHIUSURA','Sospensione',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('RIE','C',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_CHIUSURA','Rientro in Servizio',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('ROT','C',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_CHIUSURA','Rottura',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('CES','C',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_CHIUSURA','Cessazione',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('SMA','E',NULL,'ASSEGNAZIONI_BADGE.CAUSALE_CHIUSURA','Smarrimento',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('A',NULL,NULL,'ASSEGNAZIONI_BADGE.STATO','Attivo',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('S',NULL,NULL,'ASSEGNAZIONI_BADGE.STATO','Sospeso',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('E',NULL,NULL,'ASSEGNAZIONI_BADGE.STATO','Eliminato',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('NO',NULL,'N','SINO','Negazione',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('SI',NULL,'S','SINO','Conferma',NULL,NULL,NULL);
INSERT INTO peb_ref_codes ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2) VALUES ('C',NULL,NULL,'ASSEGNAZIONI_BADGE.STATO','Cessato',NULL,NULL,NULL);

WHENEVER SQLERROR EXIT

ALTER TABLE peb_ref_codes ENABLE ALL TRIGGERS;

WHENEVER SQLERROR CONTINUE