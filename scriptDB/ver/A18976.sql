drop index REST_DOCU_FK;

create index REST_DOCU_FK
on REVISIONI_STRUTTURA
( SEDE_DEL ASC,
  ANNO_DEL ASC,
  NUMERO_DEL ASC
)
/

start indici_paghe.sql
start indici_paghe_col.sql