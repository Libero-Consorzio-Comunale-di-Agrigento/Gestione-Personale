alter table IMPONIBILI_VOCE
  add  cassa_competenza      VARCHAR(2)    DEFAULT 'NO'
;

alter table RAPPORTI_GIURIDICI
  add  cassa_competenza      VARCHAR(2)    DEFAULT 'NO'
;

update IMPONIBILI_VOCE
   set cassa_competenza = 'NO'
 where cassa_competenza is null
;

start crp_peccmore.sql
start crp_peccmore1.sql
start crp_peccmore4.sql
start crp_peccmore8.sql
start crp_peccmore9.sql
start crp_peccmore_ritenuta.sql
