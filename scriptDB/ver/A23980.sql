alter table periodi_retributivi_bp
  add gg_df    number (3)
;

update periodi_retributivi_bp
   set gg_df = 0
 where gg_df is null
;

alter table periodi_retributivi_bp modify (gg_df not null);

start crp_peccperp.sql
start crp_peccperp2.sql
start crp_peccperp3.sql
