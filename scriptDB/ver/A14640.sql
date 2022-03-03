-- Attività 14640

UPDATE a_errori
   SET descrizione = 'Part-time con ore lavorate non definibili'
 WHERE errore = 'P05673';

INSERT INTO a_errori
VALUES      ('P05689', 'Part-time con ore lavorate modificate ', NULL, NULL, NULL);

Insert into a_errori
   (ERRORE, DESCRIZIONE)
 Values   ('P05693', 'Imputazione contabile non prevista');

start crp_peccrein.sql

