alter table  denuncia_inail add dein_id  NUMBER(10);

start crq_dein.sql

update denuncia_inail set dein_id = DEIN_SQ.nextval;

alter table  denuncia_inail modify dein_id NOT NULL;

CREATE UNIQUE INDEX DEIN_PK ON DENUNCIA_INAIL
( dein_id )
;

start crp_PECCADNA.sql

insert into a_errori ( errore, descrizione)
values( 'P00199','Assegnazione Sequenza Progressiva Fallita');