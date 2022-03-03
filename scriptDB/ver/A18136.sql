insert into a_errori ( errore, descrizione )
values ( 'P20003', 'Riferimento $ref_table non previsto per la registrazione $table');

delete from a_errori where errore in ( 'P08000', 'P08001');

insert into a_errori ( errore, descrizione )
values ( 'P07997', 'Non esistono revisioni struttura in stato attivo');
insert into a_errori ( errore, descrizione )
values ( 'P07998', 'Esistono più revisioni struttura in stato attivo');
insert into a_errori ( errore, descrizione )
values ( 'P08000', 'Non esistono revisioni struttura in stato di modifica');
insert into a_errori ( errore, descrizione )
values ( 'P08001', 'Esistono più revisioni struttura in stato di modifica');
insert into a_errori ( errore, descrizione )
values ('P04029','Impossibile modificare la Gestione');