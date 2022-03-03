INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'ETL', 'NO', NULL, 'VOCI_ECONOMICHE.ORIGINE', 'ETL: Flusso J-Link', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'MT', 'NO', NULL, 'VOCI_ECONOMICHE.ORIGINE', 'MT: Missioni e Trasferte', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'PA', 'SI', NULL, 'VOCI_ECONOMICHE.ORIGINE', 'PA: Presenze-Assenze', 'CFG', NULL, NULL);

alter table voci_economiche add (CONTROLLO_DISPONIBILITA VARCHAR2 (1));
                                
alter table voci_economiche add (LIVELLO_CONTROLLO VARCHAR2 (1));
                                
alter table voci_economiche add (ORIGINE VARCHAR2 (5));
                                
alter table voci_economiche add (NOME_FLUSSO VARCHAR2 (60));
                                
alter table voci_economiche add (ESCLUSIVO VARCHAR2 (1));                                                                                                                                                                
