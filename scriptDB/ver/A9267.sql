alter table denuncia_inpdap add PERC_L300  NUMBER(5,2) NULL
;
insert into a_errori ( errore, descrizione ) 
values ('P05184','Verificare Tipo Servizio');

start crp_DENUNCE_INPDAP.sql
start crp_peccaedp.sql
start crp_peccadpm.sql
start crp_peccardp.sql
start crp_cursore_fiscale.sql
start crp_pecsmcud.sql
