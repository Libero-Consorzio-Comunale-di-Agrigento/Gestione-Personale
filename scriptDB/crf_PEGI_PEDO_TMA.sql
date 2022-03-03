CREATE OR REPLACE TRIGGER pegi_pedo_tma
   AFTER DELETE OR INSERT OR UPDATE
   ON periodi_giuridici
   FOR EACH ROW
declare
   d_door_id               dotazione_organica.door_id%type;
   d_door_id_prec          dotazione_organica.door_id%type;
   d_settore               settori_amministrativi.codice%type;
   d_area                  aree.area%type;
   d_ruolo                 ruoli.codice%type;
   d_profilo               profili_professionali.codice%type;
   d_posizione             posizioni_funzionali.codice%type;
   d_figura                figure_giuridiche.codice%type;
   d_qualifica             qualifiche_giuridiche.codice%type;
   d_qualifica_figura      qualifiche_giuridiche.numero%type;
   d_qualifica_figura_prec qualifiche_giuridiche.numero%type;
   d_contratto             qualifiche_giuridiche.codice%type;
   d_ore_lavoro            contratti_storici.ore_lavoro%type;
   d_livello               qualifiche_giuridiche.livello%type;
   d_gestione              dotazione_organica.gestione%type;
   d_attivita              dotazione_organica.attivita%type;
   d_tipo_rapporto         dotazione_organica.tipo_rapporto%type;
   d_ore                   dotazione_organica.ore%type;
   d_incarico              eventi_giuridici.codice%type;
   d_di_ruolo              posizioni.ruolo_do%type;
   d_part_time             posizioni.part_time%type;
   d_tipo_part_time        posizioni.tipo_part_time%type;
   d_tipo_part_time_note   posizioni.tipo_part_time%type;
   d_contrattista          posizioni.contratto_opera%type;
   d_sovrannumero          posizioni.sovrannumero%type;
   d_unita_ni              unita_organizzative.ni%type;
   d_ue                    number;
   d_perc_copertura        gestioni.perc_copertura%type;
   d_settore_prec          settori_amministrativi.codice%type;
   d_area_prec             aree.area%type;
   d_ruolo_prec            ruoli.codice%type;
   d_profilo_prec          profili_professionali.codice%type;
   d_posizione_prec        posizioni_funzionali.codice%type;
   d_figura_prec           figure_giuridiche.codice%type;
   d_qualifica_prec        qualifiche_giuridiche.codice%type;
   d_contratto_prec        qualifiche_giuridiche.codice%type;
   d_ore_lavoro_prec       contratti_storici.ore_lavoro%type;
   d_livello_prec          qualifiche_giuridiche.livello%type;
   d_gestione_prec         dotazione_organica.gestione%type;
   d_attivita_prec         dotazione_organica.attivita%type;
   d_tipo_rapporto_prec    dotazione_organica.tipo_rapporto%type;
   d_ore_prec              dotazione_organica.ore%type;
   d_di_ruolo_prec         posizioni.ruolo_do%type;
   d_part_time_prec        posizioni.part_time%type;
   d_tipo_part_time_prec   posizioni.tipo_part_time%type;
   d_contrattista_prec     posizioni.contratto_opera%type;
   d_sovrannumero_prec     posizioni.sovrannumero%type;
   d_unita_ni_prec         unita_organizzative.ni%type;
   d_al                    date;
   d_al_prec               date;
   d_esegui                number(1) := 0;
   d_gestito               number(1) := 0;
   d_classe                classi_rapporto.codice%type;
   d_rowid                 rowid;
   situazione_anomala exception;
   non_gestito exception;
   /******************************************************************************
      NAME:         PEGI_PEDO_TMA
      PURPOSE:      Aggiorna PERIODI_DOTAZIONE a fronte di modifiche
                    su PERIODI_GIURIDICI
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        10/08/2004                   1. Created this trigger.
      1.1        25/02/2005  AM               rivisto il join pegi/pedo
      1.2        06/04/2005  MM               Attivita 10553.3
      1.3        19/04/2005  CB               A10729
      1.4        09/08/2005  MM               A12332
      1.5        26/04/2006  MM               Attivita 15389 - 13361
      1.6        31/01/2007  MM               Attivita 16255
      1.7        11/05/2007  MM               Attivita 21104
   
   ******************************************************************************/
begin
   begin
      begin
         select 1
           into d_esegui
           from revisioni_dotazione
          where utente <> 'Aut.POPI'
            and nvl(:new.rilevanza, :old.rilevanza) in ('Q', 'S', 'I', 'E');
      exception
         when too_many_rows then
            d_esegui := 1;
         when no_data_found then
            raise non_gestito;
      end;
      begin
         select codice
               ,1
           into d_classe
               ,d_gestito
           from classi_rapporto
          where codice = gp4_rain.get_rapporto(nvl(:new.ci, :old.ci))
            and dotazione = 'SI'
            and gp4_gest.get_dotazione(nvl(:new.gestione, :old.gestione)) = 'SI';
      exception
         when too_many_rows then
            d_gestito := 1;
         when no_data_found then
            raise non_gestito;
      end;
      --      raise too_many_rows;
   exception
      when no_data_found or non_gestito then
         null;
   end;
   /*   dbms_output.put_line('ci:' || :new.ci || ' rilevanza ' ||
                           nvl(:new.rilevanza, :old.rilevanza) || ' ' ||
                           nvl(:new.gestione, :old.gestione) || ' ' || d_classe || ' ' ||
                           d_gestito || ' ' || d_esegui);
   */
   if d_gestito = 1 and d_esegui = 1 then
      begin
         /* Valorizza gli attributi giuridici utili ad individuare il door_id */
         d_al := nvl(:new.al, to_date(3333333, 'j'));
      
         /*         dbms_output.put_line('Esegue ..... ' || :new.ci || ' ' || :new.rilevanza || ' ' ||
                                       :new.dal || :new.gestione);
         */
         if inserting or updating then
            /* attributi attuali */
            d_unita_ni       := gp4_stam.get_ni_numero(:new.settore);
            d_settore        := gp4_unor.get_codice_uo(d_unita_ni, 'GP4', d_al);
            d_gestione       := :new.gestione;
            d_perc_copertura := gp4_gest.get_perc_copertura(d_gestione);
            d_attivita       := nvl(:new.attivita, 'NULL');
            d_tipo_rapporto  := nvl(:new.tipo_rapporto, 'NULL');
         
            begin
               select codice
                     ,qualifica
                     ,profilo
                     ,posizione
                 into d_figura
                     ,d_qualifica_figura
                     ,d_profilo
                     ,d_posizione
                 from figure_giuridiche
                where numero = :new.figura
                  and d_al between dal and nvl(al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  d_figura           := null;
                  d_qualifica_figura := null;
                  d_profilo          := null;
                  d_posizione        := null;
            end;
         
            begin
               select codice
                     ,ruolo
                     ,contratto
                     ,livello
                 into d_qualifica
                     ,d_ruolo
                     ,d_contratto
                     ,d_livello
                 from qualifiche_giuridiche
                where numero = nvl(:new.qualifica, d_qualifica_figura)
                  and d_al between dal and nvl(al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  d_qualifica := null;
                  d_ruolo     := null;
                  d_contratto := null;
                  d_livello   := null;
            end;
         
            d_ore_lavoro := gp4_cost.get_ore_lavoro(nvl(:new.qualifica
                                                       ,d_qualifica_figura)
                                                   ,d_al);
            d_ore        := nvl(:new.ore, d_ore_lavoro);
         
            if d_ore_lavoro = 0 then
               d_ue := 1;
            else
               d_ue := d_ore / d_ore_lavoro;
            end if;
         
            if d_perc_copertura is null then
               d_ue := d_ue;
            else
               if d_ue > d_perc_copertura / 100 then
                  d_ue := 1;
               else
                  d_ue := 1 / 2;
               end if;
            end if;
         
            if :new.note like '%VERTICALE:%' then
               d_tipo_part_time_note := 'V';
            elsif :new.note like '%MISTO:%' then
               d_tipo_part_time_note := 'M';
            else
               d_tipo_part_time_note := '';
            end if;
            begin
               select nvl(ruolo_do, ruolo)
                     ,part_time
                     ,nvl(d_tipo_part_time_note
                         ,nvl(tipo_part_time, decode(part_time, 'SI', 'O', '')))
                     ,nvl(contratto_opera, 'NO')
                     ,nvl(sovrannumero, 'NO')
                 into d_di_ruolo
                     ,d_part_time
                     ,d_tipo_part_time
                     ,d_contrattista
                     ,d_sovrannumero
                 from posizioni
                where codice = :new.posizione;
            exception
               when no_data_found then
                  d_di_ruolo       := null;
                  d_part_time      := null;
                  d_tipo_part_time := null;
                  d_contrattista   := null;
                  d_sovrannumero   := null;
            end;
         
            d_area := '%';
            --
            /* attributi precedenti */
            --
            d_al_prec := nvl(:old.al, to_date(3333333, 'j'));
         
            begin
               select codice
                     ,qualifica
                     ,profilo
                     ,posizione
                 into d_figura_prec
                     ,d_qualifica_figura_prec
                     ,d_profilo_prec
                     ,d_posizione_prec
                 from figure_giuridiche
                where numero = :old.figura
                  and d_al_prec between dal and nvl(al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  d_figura_prec           := null;
                  d_qualifica_figura_prec := null;
                  d_profilo_prec          := null;
                  d_posizione_prec        := null;
            end;
         
            begin
               select codice
                     ,ruolo
                     ,contratto
                     ,livello
                 into d_qualifica_prec
                     ,d_ruolo_prec
                     ,d_contratto_prec
                     ,d_livello_prec
                 from qualifiche_giuridiche
                where numero = nvl(:old.qualifica, d_qualifica_figura)
                  and d_al_prec between dal and nvl(al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  d_qualifica_prec := null;
                  d_ruolo_prec     := null;
                  d_livello_prec   := null;
            end;
         
            d_unita_ni_prec      := gp4_stam.get_ni_numero(:old.settore);
            d_settore_prec       := gp4_unor.get_codice_uo(d_unita_ni_prec
                                                          ,'GP4'
                                                          ,d_al_prec);
            d_gestione_prec      := :old.gestione;
            d_attivita_prec      := nvl(:old.attivita, 'NULL');
            d_tipo_rapporto_prec := nvl(:old.tipo_rapporto, 'NULL');
         
            if :old.note like '%VERTICALE:%' then
               d_tipo_part_time_note := 'V';
            elsif :old.note like '%MISTO:%' then
               d_tipo_part_time_note := 'M';
            else
               d_tipo_part_time_note := '';
            end if;
         
            begin
               select nvl(ruolo_do, ruolo)
                     ,part_time
                     ,nvl(d_tipo_part_time_note
                         ,nvl(tipo_part_time, decode(part_time, 'SI', 'O', '')))
                     ,nvl(contratto_opera, 'NO')
                     ,nvl(sovrannumero, 'NO')
                 into d_di_ruolo_prec
                     ,d_part_time_prec
                     ,d_tipo_part_time_prec
                     ,d_contrattista_prec
                     ,d_sovrannumero_prec
                 from posizioni
                where codice = :old.posizione;
            exception
               when no_data_found then
                  null;
            end;
         
            d_ore_lavoro_prec := gp4_cost.get_ore_lavoro(nvl(:old.qualifica
                                                            ,d_qualifica_figura_prec)
                                                        ,d_al_prec);
            d_ore_prec        := nvl(:old.ore, d_ore_lavoro_prec);
            d_area_prec       := '%';
         
         end if;
      
         if inserting then
            /* Inserisco su PERIODI_DOTAZIONE una registrazione per ogni revisione interessata dal
            periodo giuridico inserito */
            for redo in (select revisione
                           from revisioni_dotazione
                         /* eliminata la condizione parziale sulla storicita di REDO per ottenere un join cartesiano - AM */
                         --         where dal <= nvl(:NEW.al,to_date(3333333,'j'))
                         )
            loop
               /* determino il door_id corrispondente al periodo giuridico nella revisione corrente */
               d_door_id      := gp4_door.get_id(redo.revisione
                                                ,:new.rilevanza
                                                ,d_gestione
                                                ,d_area
                                                ,d_settore
                                                ,d_ruolo
                                                ,d_profilo
                                                ,d_posizione
                                                ,d_attivita
                                                ,d_figura
                                                ,d_qualifica
                                                ,d_livello
                                                ,d_tipo_rapporto
                                                ,d_ore);
               d_door_id_prec := gp4_door.get_id(redo.revisione
                                                ,:new.rilevanza
                                                ,d_gestione_prec
                                                ,d_area_prec
                                                ,d_settore_prec
                                                ,d_ruolo_prec
                                                ,d_profilo_prec
                                                ,d_posizione_prec
                                                ,d_attivita_prec
                                                ,d_figura_prec
                                                ,d_qualifica_prec
                                                ,d_livello_prec
                                                ,d_tipo_rapporto_prec
                                                ,d_ore_prec);
            
               if :new.rilevanza in ('I', 'E') then
                  d_incarico := :new.evento;
               end if;
            
               insert into periodi_dotazione
                  (ci
                  ,rilevanza
                  ,dal
                  ,al
                  ,gestione
                  ,evento
                  ,posizione
                  ,ore
                  ,ue
                  ,figura
                  ,qualifica
                  ,settore
                  ,attivita
                  ,tipo_rapporto
                  ,area
                  ,codice_uo
                  ,ruolo
                  ,profilo
                  ,pos_funz
                  ,cod_figura
                  ,cod_qualifica
                  ,livello
                  ,di_ruolo
                  ,part_time
                  ,tipo_part_time
                  ,contrattista
                  ,sovrannumero
                  ,assenza
                  ,incarico
                  ,unita_ni
                  ,contratto
                  ,ore_lavoro
                  ,revisione
                  ,door_id
                  ,door_id_prec)
               values
                  (:new.ci
                  ,:new.rilevanza
                  ,:new.dal
                  ,:new.al
                  ,d_gestione
                  ,:new.evento
                  ,:new.posizione
                  ,d_ore
                  ,d_ue
                  ,:new.figura
                  ,nvl(:new.qualifica, d_qualifica_figura)
                  ,:new.settore
                  ,d_attivita
                  ,d_tipo_rapporto
                  ,d_area
                  ,d_settore
                  ,d_ruolo
                  ,d_profilo
                  ,d_posizione
                  ,d_figura
                  ,d_qualifica
                  ,d_livello
                  ,d_di_ruolo
                  ,d_part_time
                  ,d_tipo_part_time
                  ,d_contrattista
                  ,d_sovrannumero
                  ,:new.assenza
                  ,d_incarico
                  ,d_unita_ni
                  ,d_contratto
                  ,d_ore_lavoro
                  ,redo.revisione
                  ,d_door_id
                  ,nvl(d_door_id_prec, d_door_id));
            end loop;
         elsif updating then
            /* Esegue l'aggiornamento di tutte le registrazioni di PERIODI_DOTAZIONE relative
            al periodo giuridico modificato, nelle varie revisioni */
            for pedo in (select redo.revisione from revisioni_dotazione redo)
            loop
               /* determino il door_id corrispondente al periodo giuridico nella revisione corrente */
               d_door_id := gp4_door.get_id(pedo.revisione
                                           ,:old.rilevanza
                                           ,d_gestione
                                           ,d_area
                                           ,d_settore
                                           ,d_ruolo
                                           ,d_profilo
                                           ,d_posizione
                                           ,d_attivita
                                           ,d_figura
                                           ,d_qualifica
                                           ,d_livello
                                           ,d_tipo_rapporto
                                           ,d_ore);
            
               begin
                  select rowid
                    into d_rowid
                    from periodi_dotazione
                   where ci = :old.ci
                     and rilevanza || '' = :old.rilevanza
                     and dal = :old.dal
                     and revisione = pedo.revisione;
               
                  raise too_many_rows;
               exception
                  when no_data_found then
                     if :new.rilevanza in ('I', 'E') then
                        d_incarico := :new.evento;
                     end if;
                  
                     insert into periodi_dotazione
                        (ci
                        ,rilevanza
                        ,dal
                        ,al
                        ,gestione
                        ,evento
                        ,posizione
                        ,ore
                        ,ue
                        ,figura
                        ,qualifica
                        ,settore
                        ,attivita
                        ,tipo_rapporto
                        ,area
                        ,codice_uo
                        ,ruolo
                        ,profilo
                        ,pos_funz
                        ,cod_figura
                        ,cod_qualifica
                        ,livello
                        ,di_ruolo
                        ,part_time
                        ,tipo_part_time
                        ,contrattista
                        ,sovrannumero
                        ,assenza
                        ,incarico
                        ,unita_ni
                        ,contratto
                        ,ore_lavoro
                        ,revisione
                        ,door_id
                        ,door_id_prec)
                     values
                        (:new.ci
                        ,:new.rilevanza
                        ,:new.dal
                        ,:new.al
                        ,d_gestione
                        ,:new.evento
                        ,:new.posizione
                        ,d_ore
                        ,d_ue
                        ,:new.figura
                        ,nvl(:new.qualifica, d_qualifica_figura)
                        ,:new.settore
                        ,d_attivita
                        ,d_tipo_rapporto
                        ,d_area
                        ,d_settore
                        ,d_ruolo
                        ,d_profilo
                        ,d_posizione
                        ,d_figura
                        ,d_qualifica
                        ,d_livello
                        ,d_di_ruolo
                        ,d_part_time
                        ,d_tipo_part_time
                        ,d_contrattista
                        ,d_sovrannumero
                        ,:new.assenza
                        ,d_incarico
                        ,d_unita_ni
                        ,d_contratto
                        ,d_ore_lavoro
                        ,pedo.revisione
                        ,d_door_id
                        ,nvl(d_door_id_prec, d_door_id));
                  when too_many_rows then
                     update periodi_dotazione
                        set ci             = :new.ci
                           ,rilevanza      = :new.rilevanza
                           ,dal            = :new.dal
                           ,al             = :new.al
                           ,evento         = :new.evento
                           ,settore        = :new.settore
                           ,attivita       = d_attivita
                           ,tipo_rapporto  = d_tipo_rapporto
                           ,area           = d_area
                           ,codice_uo      = d_settore
                           ,ruolo          = d_ruolo
                           ,profilo        = d_profilo
                           ,pos_funz       = d_posizione
                           ,cod_figura     = d_figura
                           ,cod_qualifica  = d_qualifica
                           ,livello        = d_livello
                           ,di_ruolo       = d_di_ruolo
                           ,part_time      = d_part_time
                           ,tipo_part_time = d_tipo_part_time
                           ,contrattista   = d_contrattista
                           ,sovrannumero   = d_sovrannumero
                           ,assenza        = :new.assenza
                           ,unita_ni       = d_unita_ni
                           ,door_id_prec   = door_id
                           ,door_id        = d_door_id
                           ,gestione       = d_gestione
                           ,posizione      = :new.posizione
                           ,ore            = d_ore
                           ,ue             = d_ue
                           ,figura         = :new.figura
                           ,qualifica      = nvl(:new.qualifica, d_qualifica_figura)
                           ,contratto      = d_contratto
                           ,ore_lavoro     = d_ore_lavoro
                           ,incarico       = d_incarico
                      where rowid = d_rowid;
               end;
            end loop;
         elsif deleting then
            /* Elimina tutte le registrazioni di PERIODI_DOTAZIONE relative
            al periodo giuridico cancellato, nelle varie revisioni */
            delete from periodi_dotazione
             where ci = :old.ci
               and rilevanza = :old.rilevanza
               and dal = :old.dal;
         end if;
      exception
         when situazione_anomala then
            -- Consider logging the error and then re-raise
            raise;
      end;
   end if;
end;
/
