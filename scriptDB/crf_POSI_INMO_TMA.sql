create or replace trigger posi_inmo_tma
   after update of ruolo, di_ruolo, tempo_determinato, part_time on posizioni
   for each row
declare
   d_data_agg date := sysdate;
begin
   if :old.ruolo <> :new.ruolo then
      insert into individui_modificati
         (ni
         ,progressivo
         ,tabella
         ,rilevanza
         ,dal
         ,operazione
         ,data_agg
         ,ci)
         select rain.ni
               ,inmo_sq.nextval
               ,'PERIODI_GIURIDICI'
               ,pegi.rilevanza
               ,pegi.dal
               ,'U'
               ,d_data_agg
               ,pegi.ci
           from periodi_giuridici    pegi
               ,rapporti_individuali rain
          where rain.ci = pegi.ci
            and pegi.rilevanza = 'S'
            and posizione = :new.codice
            and nvl(pegi.al, to_date('3333333', 'j')) between rain.dal and
                nvl(rain.al, to_date('3333333', 'j'))
            and pxirisfa.individuo_presente(pegi.ci) = 'SI'
            and not exists (select 'x'
                   from individui_modificati
                  where ci = pegi.ci
                    and tabella = 'PERIODI_GIURIDICI');
   end if;

   if :old.di_ruolo <> :new.di_ruolo or :old.tempo_determinato <> :new.tempo_determinato or
      :old.part_time <> :new.part_time then
      insert into individui_modificati
         (ni
         ,progressivo
         ,tabella
         ,rilevanza
         ,dal
         ,operazione
         ,data_agg
         ,ci)
         select rain.ni
               ,inmo_sq.nextval
               ,'CODICI_MINIST'
               ,pegi.rilevanza
               ,pegi.dal
               ,'U'
               ,d_data_agg
               ,pegi.ci
           from periodi_giuridici    pegi
               ,rapporti_individuali rain
          where rain.ci = pegi.ci
            and pegi.rilevanza = 'S'
            and posizione = :new.codice
            and nvl(pegi.al, to_date('3333333', 'j')) between rain.dal and
                nvl(rain.al, to_date('3333333', 'j'))
            and pxirisfa.individuo_presente(pegi.ci) = 'SI'
            and not exists (select 'x'
                   from individui_modificati
                  where ci = pegi.ci
                    and tabella = 'CODICI_MINIST');
   end if;
end;
/
/
