create table smttr_individui
(anno number(4) not null,
 mese number(2) not null,
 ci   number(8) not null,
 gestione      varchar2(4) not null,
 int_comandato varchar2(2) null,
 est_comandato varchar2(2) null,
 utente        varchar2(8) null,
 tipo_agg      varchar2(1) null,
 data_agg      date        null);


create unique index stin_pk on smttr_individui
(anno, mese, ci, gestione);