CREATE TABLE GP4_PERSONALIZZAZIONI ( 
  CLIENTE    VARCHAR2(10)  NOT NULL, 
  NODO       VARCHAR2(10)  , 
  SI         VARCHAR2(6)   , 
  PROCEDURA  VARCHAR2(6)   , 
  TIPO       VARCHAR2(1)   NOT NULL, 
  VOCE_MENU  VARCHAR2(8)   NOT NULL, 
  NOTE       VARCHAR2(30)) 
;
create index pers_ik on gp4_personalizzazioni (cliente);