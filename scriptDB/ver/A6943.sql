INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P08059', 'Nuovo livello di suddivisione non definito', NULL, NULL, NULL);

-- start GP4_ins_rest.sql
-- TOLTO PERCHE' E' IL FILE DI INSTALLAZIONE!!!!

INSERT INTO pgm_ref_codes 
( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
VALUES ('M',NULL,NULL,'REVISIONI_STRUTTURA.STATO','in Modifica','CFG',NULL,NULL);
INSERT INTO pgm_ref_codes
( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
VALUES ('O',NULL,NULL,'REVISIONI_STRUTTURA.STATO','Obsoleta','CFG',NULL,NULL);
INSERT INTO pgm_ref_codes
( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
VALUES ('A',NULL,NULL,'REVISIONI_STRUTTURA.STATO','Attiva','CFG',NULL,NULL);

-- inclusa nel A10730
-- start crp_GP4DO.sql

start crv_gp4gm_1.sql

-- Rigenerazione viste
-- start crv_vido.sql
-- start crv_asso.sql
start crv_dodi.sql
start crv_dodu.sql
start crv_dofa.sql
start crv_dofu.sql
start crv_dogd.sql
start crv_dogf.sql
start crv_DOGL.sql
start crv_doxh.sql
start crv_dndi.sql
start crv_dnfa.sql
-- start crv_gp4do.sql
start crv_gp4do1.sql
start crv_gp4do2.sql

