PROMPT 
PROMPT Creating Table STRUTTURA_MODELLI_STAMPA
CREATE TABLE struttura_modelli_stampa
(codice       VARCHAR2(8) not null,
 sequenza     NUMBER(2)   not null,
 tipo_riga    VARCHAR2(1) not null,
 flag_stampa  VARCHAR2(1) not null,
 riga         VARCHAR2(2000))
/
PROMPT
PROMPT Creating Index STMS_PK on Table STRUTTURA_MODELLI_STAMPA
CREATE UNIQUE INDEX STSM_PK ON STRUTTURA_MODELLI_STAMPA
(codice,
 sequenza,
 flag_stampa )
PCTFREE  10
;


