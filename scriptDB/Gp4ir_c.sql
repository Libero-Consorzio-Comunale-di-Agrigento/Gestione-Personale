-- creazione delle tabelle del modulo
start crt_asil.sql

-- creazione delle viste del modulo
-- drop cautelativa (potrebbero dare errore)
drop table deposito_eventi_rilevazione;
drop table assenze_iris;
start crv_iris.sql

-- creazione di tutte le funzioni , trigger e package di integrazione
start crf_iris.sql
start crp_pxirisfa.sql
start crp_pxiriscv.sql
start crp_pxirisca.sql
start crf_pxirisdr.sql
