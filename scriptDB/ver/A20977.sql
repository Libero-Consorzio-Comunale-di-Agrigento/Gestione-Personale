start crp_peccstvb.sql
start crp_peccsmvb.sql


ALTER TABLE CLASSI_RAPPORTO ADD (TIPO_COMPENSO VARCHAR2(15));
ALTER TABLE CLASSI_RAPPORTO ADD (TIPO_COMPENSO_AL1 VARCHAR2(15));
ALTER TABLE CLASSI_RAPPORTO ADD (TIPO_COMPENSO_AL2 VARCHAR2(15));

UPDATE CLASSI_RAPPORTO SET TIPO_COMPENSO='COMPENSI' WHERE CODICE != 'DIP';
UPDATE CLASSI_RAPPORTO SET TIPO_COMPENSO_AL1='VERGUETUNG' WHERE CODICE != 'DIP'; 
UPDATE CLASSI_RAPPORTO SET TIPO_COMPENSO_AL2='VERGUETUNG' WHERE CODICE != 'DIP'; 