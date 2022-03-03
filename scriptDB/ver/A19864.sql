-- include start anche per attivita 19858 e 19864.1

delete from a_errori where errore = 'P05191'
/
insert into a_errori (errore,descrizione)
values ('P05191','Assegnazione automatica previdenza e fine servizio per')
/
start crp_peccadma.sql
