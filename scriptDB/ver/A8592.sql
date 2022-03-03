update astensioni aste
   set per_ret = 100
 where per_ret != 100
   and exists (select 'x' from periodi_giuridici pegi1
                where pegi1.assenza = aste.codice
                  and pegi1.rilevanza = 'A'
                  and nvl(ore,0) != 0)
   and not exists (select 'x' from periodi_giuridici pegi2
                    where pegi2.assenza = aste.codice
                      and pegi2.rilevanza = 'A'
                      and nvl(ore,0) = 0);


start crp_peccmore.sql
start crp_peccmore8.sql
start crp_peccmore9.sql
start crp_peccmore_ritenuta.sql
