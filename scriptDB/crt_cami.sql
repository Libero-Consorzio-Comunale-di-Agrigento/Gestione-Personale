create table categorie_ministeriali
(codice varchar2(10) not null,
descrizione varchar2(39),
sequenza number(4));

create unique index cami_pk
on categorie_ministeriali (codice);