start crp_pecsmdma.sql

delete from a_errori 
where errore in ('P00110','P00113');

insert into a_errori (errore,descrizione)
values ('P00110','Il Codice Gestione identifica Amministrazioni Dichiaranti diverse');

insert into a_errori (errore,descrizione)
values ('P00113','La Provenienza non deve essere uguale alla Gestione');

insert into a_errori (errore,descrizione)
values ('P00114','Codice Gestione senza indicazione del firmatario della denuncia DMA');

