ALTER TABLE ISTITUTI_CREDITO
ADD (PRONTA_CASSA VARCHAR2(2) DEFAULT 'NO' NOT NULL);

update istituti_credito set pronta_cassa='SI'
where  substr(codice,1,2)='PC';

start crf_carica_rain_rare.sql

-- il package gpx_rare NON deve mai essere startato
-- start crp_gpx_rare.sql

