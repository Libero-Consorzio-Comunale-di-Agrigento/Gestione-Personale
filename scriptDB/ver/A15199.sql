update rapporti_retributivi_storici rars
   set al = null
  where dal in ( select max(dal) 
                   from rapporti_retributivi_storici
                  where ci = rars.ci
                )
    and not exists ( select 'x' 
                      from rapporti_retributivi_storici
                     where ci = rars.ci
                       and al is null
                   )
    and al is not null;

start crp_peccdnag.sql