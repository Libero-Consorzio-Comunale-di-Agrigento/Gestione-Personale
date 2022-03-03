alter TABLE informazioni_extracontabili
add perc_car_fam NUMBER(2) NULL
;

insert into a_errori ( errore, descrizione )
values ( 'P05743','Percentuale Carico Fiscale non Ammessa');

start crp_pecccafa.sql