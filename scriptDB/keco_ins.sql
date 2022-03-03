/******************************************************************************
 NOME:        keco_ins.sql
 DESCRIZIONE: Predisposizione minimale "Base Dati Appoggio" per gestione Constraint Error e Multilinguismo.

 ANNOTAZIONI: Modificata rispetto alla versione standard afcKCDef.sql per sostituire l'errore A00001
              (già utilizzato) con l'errore A02201.
 REVISIONI:
 Rev.  Data        Autore  Descrizione
 ----  ----------  ------  ----------------------------------------------------
 1     18/09/2006  MF      Prima versione.

 ******************************************************************************/

 -- Inserimento KEY_CONSTRAINT_TYPE di Default

insert into key_constraint_type (db_error, tipo_errore) values('1','UK');
insert into key_constraint_type (db_error, tipo_errore) values('2290','CC');
insert into key_constraint_type (db_error, tipo_errore) values('2291','FK');
insert into key_constraint_type (db_error, tipo_errore) values('2292','FR');

-- Inserimento KEY_CONSTRAINT_ERROR di Default

insert into key_constraint_error (nome, tipo_errore, errore) values('UK','UK','A02201');
insert into key_constraint_error (nome, tipo_errore, errore) values('CC','CC','A02290');
insert into key_constraint_error (nome, tipo_errore, errore) values('FK','FK','A02291');
insert into key_constraint_error (nome, tipo_errore, errore) values('FR','FR','A02292');

-- Inserimento KEY_ERROR di Default

insert into key_error (errore, descrizione, tipo) values('A02201','Registrazione gia'' presente $table:in','E');
insert into key_error (errore, descrizione, tipo) values('A02290','Registrazione $table:in con informazioni incongruenti','E');
insert into key_error (errore, descrizione, tipo) values('A02291','Riferimento $table:di non presente $ref_table:in','E');
insert into key_error (errore, descrizione, tipo) values('A02292','Esistono riferimenti $table:in alla registrazione $ref_table:di', 'E');

-- La variabile "$table:in" viene sostituita con "... in <nome Tabella> ...".
-- "$table" viene sostituito con il nome della tabella propritaria del DB Constraint.
-- "$ref_table" viene sostituito con il nome della tabella a cui il DB Constraint si riferisce.
-- Il DB Constraint name viene individuato nel testo del messaggio di errore "ORA-nnnnn".
-- Se esiste variabile "$$" viene sostituita con eventuale precisazione aggiunta al codice applicativo di errore.


