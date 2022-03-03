alter table addizionale_irpef_comunale
  add ( esenzione   NUMBER(15,5)    NULL,
        scaglione   NUMBER(15,5)    NULL,
        imposta     NUMBER(15,5)    NULL)
/

update addizionale_irpef_comunale set scaglione = 0
/

drop index AICO_PK
/

CREATE UNIQUE INDEX AICO_PK ON ADDIZIONALE_IRPEF_COMUNALE
(cod_provincia ,
 cod_comune ,
 dal ,
 scaglione)
/

-- start crp_peccmore_addizionali.sql inclusa in A20420
-- start crp_peccraad.sql inclusa in A20420
