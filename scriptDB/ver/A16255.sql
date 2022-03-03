-- Filtri per dotazione organica su Gestioni e Classi di Rapporto
-- Aggiunge nuovi campi alle tabelle

alter table CLASSI_RAPPORTO add DOTAZIONE VARCHAR2(2) default 'SI' not null;

alter table GESTIONI add DOTAZIONE VARCHAR2(2) default 'SI';

-- Nuovo ref code per clra.dotazione
insert into PAM_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('NO', null, 'N', 'CLASSI_RAPPORTO.DOTAZIONE', 'Rapporto non visibile su Dotazione Organica', 'CFG', null, null);
insert into PAM_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('SI', null, 'N', 'CLASSI_RAPPORTO.DOTAZIONE', 'Rapporto visibile su Dotazione Organica', 'CFG', null, null);

start crf_GEST_PEDO_TMA.sql
start crf_pegi_pedo_tma.sql

start crf_aggiorna_pedo.sql

start crp_GP4_GEST.sql













