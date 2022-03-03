create or replace trigger sedi_inmo_tma
   after update of codice on sedi
   for each row
declare
   d_data_agg date := sysdate;
begin
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
         and sede = :new.numero
         and nvl(pegi.al, to_date('3333333', 'j')) between rain.dal and
             nvl(rain.al, to_date('3333333', 'j'))
         and pxirisfa.individuo_presente(pegi.ci) = 'SI'
         and not exists (select 'x'
                from individui_modificati
               where ci = pegi.ci
                 and tabella = 'PERIODI_GIURIDICI');
end;
/
/
