-- Eliminazione Tavola KEY_ERROR per creazione vista su Table A_ERRORI di DB User A00 
-- Rimuove eventuale Table KEY_ERROR creata da script standard di AD4
-- (in caso di lancio in upgrade igrorare l'errore di drop table inesistente)

drop table KEY_ERROR
;

start crv_kerr.sql


begin
   utilitypackage.compile_all;
end;
/

-- Inserimento KEY_ERROR di Default quindi gli stessi errori della keco_in 
-- devono essere inseriti su a_errori
insert into a_errori (errore, descrizione, proprieta) values('A02201','Registrazione gia'' presente $table:in','B');
insert into a_errori (errore, descrizione, proprieta) values('A02290','Registrazione $table:in con informazioni incongruenti','B');
insert into a_errori (errore, descrizione, proprieta) values('A02291','Riferimento $table:di non presente $ref_table:in','B');
insert into a_errori (errore, descrizione, proprieta) values('A02292','Esistono riferimenti $table:in alla registrazione $ref_table:di','B');

-- La variabile "$table:in" viene sostituita con "... in <nome Tabella> ...".
-- "$table" viene sostituito con il nome della tabella propritaria del DB Constraint.
-- "$ref_table" viene sostituito con il nome della tabella a cui il DB Constraint si riferisce.
-- Il DB Constraint name viene individuato nel testo del messaggio di errore "ORA-nnnnn".
-- Se esiste variabile "$$" viene sostituita con eventuale precisazione aggiunta al codice applicativo di errore.

