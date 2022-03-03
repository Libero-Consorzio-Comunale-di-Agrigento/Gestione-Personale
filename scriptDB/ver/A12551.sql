alter table imputazioni_contabili add
( UTENTE      VARCHAR2(8)
, DATA_AGG    DATE
)
;

start crp_peccimco.sql