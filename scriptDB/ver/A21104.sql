start crp_gp4_pegi.sql
start crf_pegi_pedo_tma.sql
start crf_posi_pedo_tma.sql

alter table periodi_giuridici disable all triggers;
alter trigger pegi_pedo_tma enable;

update periodi_giuridici
   set ci = ci + 0
 where rilevanza in ('Q','S','I','E')
   and posizione in (select codice 
                       from posizioni 
                      where part_time = 'SI'
                    )
;

alter table periodi_giuridici enable all triggers;
  
