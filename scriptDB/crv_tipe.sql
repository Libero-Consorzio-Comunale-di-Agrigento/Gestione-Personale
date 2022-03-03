create or replace view titoli_personali
( sequenza
, titolo )
as
select titolo
     , descrizione 
  from tipi_titolo
/

