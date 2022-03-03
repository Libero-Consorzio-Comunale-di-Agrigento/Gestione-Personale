alter table ripartizioni_contabili 
add ( contratto  VARCHAR2(4)      NULL);

alter table ripartizioni_contabili 
modify chiave varchar2(24);

alter table imputazioni_cont_economica
add ( contratto  VARCHAR2(4)      NULL);

drop index RICO_PK;

CREATE UNIQUE INDEX RICO_PK ON RIPARTIZIONI_CONTABILI
(gestione , ruolo , contratto , di_ruolo , funzionale , bilancio , arr , input_bilancio )
;

update ripartizioni_contabili
set contratto = '%';

alter table ripartizioni_contabili modify contratto not null;

update ripartizioni_contabili
set chiave = gestione||ruolo||contratto||di_ruolo||funzionale||bilancio||arr;

start crv_mobi.sql
start crv_mopr.sql