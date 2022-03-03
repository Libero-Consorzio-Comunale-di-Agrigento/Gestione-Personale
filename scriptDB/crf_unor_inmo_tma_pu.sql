create or replace procedure unor_inmo_tma_pu(p_ni in number) is
   d_revisione revisioni_struttura.revisione%type;
   d_data      date;
begin
   d_revisione := gp4gm.get_revisione_a;
   d_data      := gp4_rest.get_dal(d_revisione);
   for cur_unor in (select unor.ni
                          ,unor.codice_uo
                      from unita_organizzative unor
                     where unor.ottica = 'GP4'
                       and unor.revisione = d_revisione
                       and d_data between unor.dal and nvl(unor.al, to_date(3333333, 'j'))
                     start with unor.ni = p_ni
                            and unor.ottica = 'GP4'
                            and unor.revisione = d_revisione
                    connect by prior unor.ni = unor.unita_padre
                           and unor.ottica = 'GP4'
                           and unor.revisione = d_revisione)
   loop
      insert into individui_modificati
         (ni
         ,progressivo
         ,tabella
         ,dal
         ,operazione
         ,data_agg
         ,ci)
         select rain.ni
               ,evpa_sq.nextval
               ,'SETTORI'
               ,pegi.dal
               ,'U'
               ,sysdate
               ,pegi.ci
           from periodi_giuridici      pegi
               ,rapporti_individuali   rain
               ,settori_amministrativi stam
          where rain.ci = pegi.ci
            and pegi.rilevanza = 'S'
            and pegi.settore = stam.numero
            and stam.ni = cur_unor.ni
            and pegi.dal = (select min(dal)
                              from periodi_giuridici
                             where ci = pegi.ci
                               and rilevanza = pegi.rilevanza
                               and settore = pegi.settore
                               and nvl(al, to_date(3333333, 'j')) >= d_data)
            and pegi.dal between rain.dal and nvl(rain.al, to_date('3333333', 'j'))
            and pxirisfa.individuo_presente(pegi.ci) = 'SI'
            and not exists (select 'x'
                   from individui_modificati
                  where ni = rain.ni
                    and tabella = 'SETTORI');
   end loop;
end unor_inmo_tma_pu;
/
