-- Nuovi codici di errore per i controlli sulle sostituzioni giuridiche
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P08073', 'Esistono periodi di sostituzione. Incarico non eliminabile', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P08072', 'Esistono periodi di sostituzione. Inquadramento non eliminabile', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P08071', 'Ore di sostituzione coperte solo dalle ore di Incarico del sostituto', null, null, null);

--Correzione del controllo delle ore lavorate in chk_sostituzioni
start crp_gp4do.sql