CREATE or replace force view deposito_eventi_rilevazione 
as
select   to_char('')             evento
      ,  matricola               ci
      ,  codpaghe                giustificativo
      ,  to_char(null)           motivo
      ,  dal
      ,  al
      ,  riferimento
      ,  chiuso
      ,  input
      ,  classe
      ,  dalle
      ,  alle
      ,  valore
      ,  cdc
      ,  sede
      ,  note
      ,  utente
      ,  data_agg
  from   pagheads@dbl_mondoedp
/
