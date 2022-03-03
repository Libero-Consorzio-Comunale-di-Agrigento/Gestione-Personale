create table smttr_periodi
(anno number(4) not null,
 mese number(2) not null,
 ci   number(8) not null,
 gestione      varchar2(4) not null,
 dal           date        not null,
 al            date        null,
 qualifica     varchar2(6) null,
 tempo_determinato varchar2(2) null,
 tempo_pieno       varchar2(2) null,
 part_time         number(5,2) null,
 assunzione        varchar2(6) null,
 cessazione        varchar2(6) null,
 gg_assenza        number(5,2) null,
 utente            varchar2(8) null,
 tipo_agg          varchar2(1) null,
 data_agg          date        null);

create unique index stpe_pk on smttr_periodi
(anno, mese, ci, gestione, dal);