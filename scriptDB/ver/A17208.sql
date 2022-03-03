-- Correzione del codice di errore P08013
-- Correzione del controllo di integrità referenziale sulle AREE

update a_errori
set descrizione = 'Utilizzati contemporaneamente attributi giuridici ed economici'
where errore = 'P08013';

start crf_gp4do.sql



























































