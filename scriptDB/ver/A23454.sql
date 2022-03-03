alter table calcoli_retributivi
  add  gg_df   number (3)
;

alter table periodi_retributivi
  add gg_df    number (3)
;

alter table astensioni
  add  mat_detfam   number (1)
;

update calcoli_retributivi
   set gg_df = gg_af
 where gg_df is null
;

update periodi_retributivi
   set gg_df = gg_af
 where gg_df is null
;

update astensioni
   set mat_detfam = mat_assfam
 where mat_detfam is null
;

alter table calcoli_retributivi modify (gg_df not null);
alter table periodi_retributivi modify (gg_df not null);
alter table astensioni          modify (mat_detfam not null);

start crv_ast2.sql

start crp_peccpere.sql
start crp_peccpere2.sql
start crp_peccpere3.sql
start crp_pecupere.sql

start crp_peccmore3.sql
start crp_peccmore_autofam.sql

 