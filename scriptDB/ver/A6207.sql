start crp_gp4do.sql
start crp_gp4_posi.sql
start crv_gp4do1.sql

alter table posizioni add (RUOLO_DO varchar2(2), CONTRATTO_OPERA varchar2(2));

-- aggiorna il nuovo campo posizioni.ruolo_do con il valore del campo ruolo

update posizioni
set ruolo_do=ruolo
where ruolo in ('SI','NO');

start crv_dodi.sql
start crv_dodu.sql
start crv_dofa.sql
start crv_dofu.sql
start crv_asso.sql

