create or replace procedure crea_organigramma is
begin
   delete from relazioni_componenti;
   for revisioni in (select revisione from revisioni_struttura where revisione = 7)
   loop
      dbms_output.put_line('Revisione: ' || revisioni.revisione);
      for unita in (select level - 1 livello
                          ,codice_uo
                          ,ni
                          ,dal
                          ,al
                          ,gp4gm.get_ci_responsabile_uo(ni, dal) responsabile
                          ,gp4_stam.get_gestione(ni) gestione
                          ,gp4_stam.get_numero(ni) numero
                          ,revisione
                      from unita_organizzative
                     where ottica = 'GP4'
                       and revisione = revisioni.revisione
                     start with unita_padre = 0
                            and ottica = 'GP4'
                            and revisione = revisioni.revisione
                    connect by prior ni = unita_padre
                           and ottica = 'GP4'
                           and dal = unita_padre_dal
                           and revisione = revisioni.revisione
                     order by gestione
                             ,gp4gm.ordertree(level
                                             ,nvl(lpad((nvl(lpad(gp4_stam.get_sequenza(ni)
                                                                ,6
                                                                ,'0')
                                                           ,'999999') ||
                                                       rpad(codice_uo, 15, ' '))
                                                      ,21
                                                      ,'0')
                                                 ,'999999' || gp4_stam.get_codice(ni))))
      loop
         dbms_output.put_line('--- Gestione: ' || unita.gestione || ' Codice: ' ||
                              unita.codice_uo || ' Responsabile: ' || unita.responsabile);
         /* determinazione dei responsabili */
         for responsabili in (select comp.componente
                                    ,comp.ni
                                    ,comp.dal
                                    ,comp.al
                                    ,rain.ci responsabile
                                from componenti           comp
                                    ,rapporti_individuali rain
                                    ,classi_rapporto      clra
                                    ,tipi_incarico        tiin
                               where comp.unita_ni = unita.ni
                                 and comp.unita_ottica = 'GP4'
                                 and comp.unita_dal = unita.dal
                                 and comp.dal >= unita.dal
                                 and nvl(comp.al, to_date(3333333, 'j')) <=
                                     nvl(unita.al, to_date(3333333, 'j'))
                                 and rain.ni = comp.ni
                                 and tiin.incarico = comp.incarico
                                 and tiin.responsabile = 'SI'
                                 and clra.codice = rain.rapporto
                                 and clra.giuridico = 'SI'
                                 and clra.concorso = 'NO'
                                 and rain.dal = (select max(dal)
                                                   from rapporti_individuali
                                                       ,classi_rapporto
                                                  where ni = rain.ni
                                                    and rapporto = codice
                                                    and giuridico = 'SI'
                                                    and concorso = 'NO')
                                 and comp.dal >= rain.dal
                                 and nvl(comp.al, to_date(3333333, 'j')) <=
                                     nvl(rain.al, to_date(3333333, 'j')))
         loop
            dbms_output.put_line('------- Responsabile: ' || responsabili.responsabile || '/' ||
                                 responsabili.ni || ' dal-al: ' || responsabili.dal ||
                                 ' - ' || responsabili.al);
            insert into relazioni_componenti
               (gestione
               ,responsabile_id
               ,ni_responsabile
               ,ci_responsabile
               ,ni
               ,ci
               ,revisione_uo
               ,uo
               ,componente
               ,tipo
               ,dal
               ,al
               ,rilevanza
               ,livello_uo)
            values
               (unita.gestione
               ,responsabili.componente
               ,responsabili.ni
               ,responsabili.responsabile
               ,0
               ,0
               ,unita.revisione
               ,unita.ni
               ,0
               ,'R'
               ,responsabili.dal
               ,responsabili.al
               ,''
               ,unita.livello);
            /* determinazione dei dipendenti (giuridici) */
            for dipendenti in (select ci
                                     ,dal
                                     ,al
                                     ,rilevanza
                                     ,gp4_rain.get_ni(ci) ni
                                 from periodi_giuridici pegi
                                where settore in
                                      (select numero
                                         from settori_amministrativi
                                        where ni in (select figlio
                                                       from relazioni_uo
                                                      where revisione = revisioni.revisione
                                                        and gestione = unita.gestione
                                                        and padre = unita.ni))
                                  and dal <= nvl(responsabili.al, to_date(3333333, 'j'))
                                  and nvl(al, to_date(3333333, 'j')) >= responsabili.dal)
            loop
               dbms_output.put_line('----------- Dipendente: ' || dipendenti.ci || '/' ||
                                    dipendenti.ni || ' dal-al: ' || dipendenti.dal ||
                                    ' - ' || dipendenti.al);
               insert into relazioni_componenti
                  (gestione
                  ,responsabile_id
                  ,ni_responsabile
                  ,ci_responsabile
                  ,ni
                  ,ci
                  ,revisione_uo
                  ,uo
                  ,componente
                  ,tipo
                  ,dal
                  ,al
                  ,rilevanza
                  ,livello_uo)
               values
                  (unita.gestione
                  ,responsabili.componente
                  ,responsabili.ni
                  ,responsabili.responsabile
                  ,dipendenti.ni
                  ,dipendenti.ci
                  ,unita.revisione
                  ,unita.ni
                  ,0
                  ,'D'
                  ,dipendenti.dal
                  ,dipendenti.al
                  ,dipendenti.rilevanza
                  ,unita.livello);
            end loop;
            /* determinazione dei dipendenti (componenti) */
            for componenti in (select comp.componente
                                     ,comp.ni
                                     ,comp.dal
                                     ,comp.al
                                     ,rain.ci
                                 from componenti           comp
                                     ,rapporti_individuali rain
                                     ,classi_rapporto      clra
                                where comp.unita_ni = unita.ni
                                  and comp.unita_ottica = 'GP4'
                                  and comp.unita_dal = unita.dal
                                  and comp.dal <=
                                      nvl(responsabili.al, to_date(3333333, 'j'))
                                  and nvl(comp.al, to_date(3333333, 'j')) >=
                                      responsabili.dal
                                  and rain.ni = comp.ni
                                  and clra.codice = rain.rapporto
                                  and clra.giuridico = 'SI'
                                  and clra.concorso = 'NO'
                                  and comp.dal >= rain.dal
                                  and nvl(comp.al, to_date(3333333, 'j')) <=
                                      nvl(rain.al, to_date(3333333, 'j')))
            loop
               insert into relazioni_componenti
                  (gestione
                  ,responsabile_id
                  ,ni_responsabile
                  ,ci_responsabile
                  ,ni
                  ,ci
                  ,revisione_uo
                  ,uo
                  ,componente
                  ,tipo
                  ,dal
                  ,al
                  ,rilevanza
                  ,livello_uo)
               values
                  (unita.gestione
                  ,responsabili.componente
                  ,responsabili.ni
                  ,responsabili.responsabile
                  ,componenti.ni
                  ,componenti.ci
                  ,unita.revisione
                  ,unita.ni
                  ,componenti.componente
                  ,'C'
                  ,componenti.dal
                  ,componenti.al
                  ,'C'
                  ,unita.livello);
            end loop;
         end loop;
      end loop;
   end loop;
end crea_organigramma;
/
