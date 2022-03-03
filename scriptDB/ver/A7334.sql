alter table condizioni_familiari add (cod_scaglione varchar2(2));

update condizioni_familiari
set cod_scaglione = '99';

alter table condizioni_familiari modify (cod_scaglione varchar2(2) not null);

alter table condizioni_familiari modify (tabella varchar2(3));

alter table scaglioni_assegno_familiare add (cod_scaglione varchar2(2));

update scaglioni_assegno_familiare
set cod_scaglione = '99';

alter table scaglioni_assegno_familiare modify (cod_scaglione varchar2(2) not null);

alter table scaglioni_assegno_familiare add (numero_fascia number(2));

alter table assegni_familiari add (numero_fascia number(2));

start update_numero_fascia.sql

BEGIN
 UPDATE_NUMERO_FASCIA;
END;
/

drop procedure UPDATE_NUMERO_FASCIA;

alter table scaglioni_assegno_familiare modify (numero_fascia number(2) not null);

alter table assegni_familiari modify (numero_fascia number(2) not null);

alter table assegni_familiari modify (tabella varchar2(3));

DROP INDEX SCAF_PK;

CREATE UNIQUE INDEX SCAF_PK ON SCAGLIONI_ASSEGNO_FAMILIARE
(DAL, COD_SCAGLIONE, NUMERO_FASCIA);

DROP INDEX ASFA_PK;

CREATE INDEX ASFA_PK ON ASSEGNI_FAMILIARI
(DAL, TABELLA, NUMERO_FASCIA, NUMERO);



	