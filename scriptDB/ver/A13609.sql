alter table ente add
CHIUSURA_RAIN  VARCHAR2(2) DEFAULT 'SI' NOT NULL
/
start crf_rire_cambio_anno.sql


insert into a_errori ( errore, descrizione )
values ( 'P05358','Esiste Riga di Add. Regionale collegata a');
insert into a_errori ( errore, descrizione )
values ( 'P05378','Esiste Riga di Add. Comunale collegata a');