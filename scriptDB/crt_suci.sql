-- crezione della tabella SUB_CAUSE_INFORTUNIO 

CREATE TABLE SUB_CAUSE_INFORTUNIO ( 
  CAUSA        VARCHAR2 (6)  NOT NULL, 
  SUB          VARCHAR2 (6)  NOT NULL, 
  DESCRIZIONE  VARCHAR2 (120)  NOT NULL, 
  SEQUENZA     NUMBER (4), 
  STATISTICO   VARCHAR2 (6));

create index suci_pk on SUB_CAUSE_INFORTUNIO (causa,sub);