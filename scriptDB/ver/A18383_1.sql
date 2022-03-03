alter table SIA_DEFAULT_INDICI 
add UNIQUENESS  VARCHAR2(9);

CREATE TABLE SIA_DEFAULT_INDICI_COL
( TABLE_NAME        VARCHAR2(30), 
  INDEX_NAME        VARCHAR2(30),
  COLUMN_NAME       VARCHAR2(2000),
  COLUMN_POSITION   NUMBER
) ;

start SIA_IDX_DIIN_CRV.sql

start indici_paghe.sql
start indici_paghe_col.sql

commit;

