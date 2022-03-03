create or replace package gp4_pegi is
   /******************************************************************************
    NOME:        GP4_PEGI
    DESCRIZIONE: Funzioni sulla tabella PERIODI_GIURIDICI
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    0    28/08/2002 __     Prima emissione.
    1.1  03/02/2005 MM     Allineamento delle modifiche a febbraio 2005
    1.2  26/04/2006 MM     Attività 13631
    1.3  10/04/2007 ML     Nuova function per estrarre note concatenate di periodi diversi 
    1.4  11/06/2007 MM     Nuove funzioni per la estrazione del tipo part-time
                           e della percentuale dalle note individuali di PEGI (A21104)
   ******************************************************************************/
   function get_posizione
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2;
   pragma restrict_references(get_posizione, wnds, wnps);
   function get_ultimo_dal
   (
      p_ci        in number
     ,p_rilevanza in varchar2
   ) return date;
   pragma restrict_references(get_ultimo_dal, wnds, wnps);
   function get_ultima_cessazione(p_ci in number) return date;
   pragma restrict_references(get_ultima_cessazione, wnds, wnps);
   function get_assunzione
   (
      p_ci   in number
     ,p_data in date
   ) return date;
   pragma restrict_references(get_assunzione, wnds, wnps);
   function get_al
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return date;
   pragma restrict_references(get_al, wnds, wnps);
   function get_gestione
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2;
   pragma restrict_references(get_gestione, wnds, wnps);
   function get_settore
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number;
   pragma restrict_references(get_settore, wnds, wnps);
   function get_attivita
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2;
   pragma restrict_references(get_attivita, wnds, wnps);
   function get_assenza
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2;
   function get_incarico
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2;
   pragma restrict_references(get_assenza, wnds, wnps);
   function get_tipo_rapporto
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2;
   pragma restrict_references(get_tipo_rapporto, wnds, wnps);
   function get_figura
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number;
   pragma restrict_references(get_figura, wnds, wnps);
   function get_ore
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number;
   pragma restrict_references(get_ore, wnds, wnps);
   function get_qualifica
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number;
   pragma restrict_references(get_qualifica, wnds, wnps);
   function get_note_concatenate
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_dal       in date
     ,p_al        in date
   ) return varchar2;
   pragma restrict_references(get_ore, wnds, wnps);
   function get_pegi_door_id
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_revisione in number
   ) return number;
   pragma restrict_references(get_pegi_door_id, wnds, wnps);
   function get_assunto_part_time
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2;
   pragma restrict_references(get_assunto_part_time, wnds, wnps);
   function get_tipo_part_time
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2;
   pragma restrict_references(get_tipo_part_time, wnds, wnps);
   function get_perc_part_time
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2;
   pragma restrict_references(get_perc_part_time, wnds, wnps);
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   procedure chk_pegi_unor_1
   (
      p_settore      in number
     ,p_dal          in date
     ,p_rilevanza    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   procedure chk_pegi_unor_2
   (
      p_settore      in number
     ,p_al           in date
     ,p_rilevanza    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   procedure chk_pegi_unor_3
   (
      p_settore      in number
     ,p_dal          in date
     ,p_al           in date
     ,p_rilevanza    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
end gp4_pegi;
/
create or replace package body gp4_pegi as
   function versione return varchar2 is
      /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
       PARAMETRI:   --
       RITORNA:     stringa varchar2 contenente versione e data.
       NOTE:        Il secondo numero della versione corrisponde alla revisione
                    del package.
      ******************************************************************************/
   begin
      return 'V1.4 del 11/06/2007';
   end versione;
   --
   procedure chk_pegi_unor_1
   (
      p_settore      in number
     ,p_dal          in date
     ,p_rilevanza    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_PEGI_UNOR_1
         PURPOSE:    Controlla che il periodo giuridico sia interamente (buco all'inizio)
                     coperto da unita organizzative
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        06/10/2003
      ******************************************************************************/
      d_dal date;
      d_ni  number(8);
      form_trigger_failure exception;
   begin
      p_errore       := null;
      p_segnalazione := null;
      begin
         select min(unor.dal)
               ,unor.ni
           into d_dal
               ,d_ni
           from settori_amministrativi stam
               ,unita_organizzative    unor
          where p_settore = stam.numero
            and stam.ni = unor.ni
            and unor.tipo = 'P'
          group by unor.ni;
         raise too_many_rows;
      exception
         when too_many_rows then
            if p_dal < d_dal then
               p_errore       := 'P08053';
               p_segnalazione := si4.get_error(p_errore) || ' ' ||
                                 to_char(d_dal, 'dd/mm/yyyy');
               -- Unita Organizzativa valida dal '
               raise form_trigger_failure;
            else
               null;
            end if;
         when no_data_found then
            p_errore       := 'P08054';
            p_segnalazione := si4.get_error(p_errore); -- Non ci sono revisioni Valide
            raise form_trigger_failure;
      end;
   exception
      when form_trigger_failure then
         null;
   end chk_pegi_unor_1;
   procedure chk_pegi_unor_2
   (
      p_settore      in number
     ,p_al           in date
     ,p_rilevanza    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_PEGI_UNOR_1
         PURPOSE:    Controlla che il periodo giuridico sia interamente (buco alla fine)
                     coperto da unita organizzative
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        06/10/2003
      ******************************************************************************/
      d_revisione number(8);
      app         varchar2(1);
      d_ni        number(8);
      d_min_dal   date;
      d_max_dal   date;
      form_trigger_failure exception;
   begin
      p_errore       := null;
      p_segnalazione := null;
      begin
         select revisione
           into d_revisione
           from revisioni_struttura
          where dal = (select max(dal)
                         from revisioni_struttura
                        where dal <= nvl(p_al, to_date('3333333', 'j'))
                          and stato in ('A', 'O'));
         begin
            select dal
              into d_max_dal
              from revisioni_struttura
             where revisione = d_revisione;
         end;
         begin
            select distinct unor.ni
                           ,min(unor.dal)
              into d_ni
                  ,d_min_dal
              from settori_amministrativi stam
                  ,unita_organizzative    unor
             where p_settore = stam.numero
               and stam.ni = unor.ni
               and unor.tipo = 'P'
             group by unor.ni;
         exception
            when no_data_found then
               p_errore       := 'P08054';
               p_segnalazione := si4.get_error(p_errore); -- Non ci sono revisioni Valide
               raise form_trigger_failure;
         end;
         select 'x'
           into app
           from unita_organizzative unor
          where unor.tipo = 'P'
            and revisione = d_revisione
            and ni = d_ni;
         raise too_many_rows;
      exception
         when too_many_rows then
            null;
         when no_data_found then
            p_errore       := 'P08053';
            p_segnalazione := si4.get_error(p_errore) || ' ' ||
                              to_char(d_min_dal, 'dd/mm/yyyy') || ' al ' ||
                              to_char(d_max_dal - 1, 'dd/mm/yyyy');
            -- Unita Organizzativa valida dal /al'
            raise form_trigger_failure;
      end;
   exception
      when form_trigger_failure then
         null;
   end chk_pegi_unor_2;
   ---
   procedure chk_pegi_unor_3
   (
      p_settore      in number
     ,p_dal          in date
     ,p_al           in date
     ,p_rilevanza    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_PEGI_UNOR_2
         PURPOSE:    Controlla che il periodo giuridico sia interamente (buchi interni)
                     coperto da unita organizzative
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        06/10/2003
      ******************************************************************************/
      d_dal       date;
      d_revisione number(8);
      app         varchar2(1);
      d_ni        number(8);
      d_min_dal   date;
      form_trigger_failure exception;
   begin
      p_errore       := null;
      p_segnalazione := null;
      begin
         d_revisione := gp4gm.get_revisione(p_dal);
         begin
            select distinct unor.ni
                           ,min(unor.dal)
              into d_ni
                  ,d_min_dal
              from settori_amministrativi stam
                  ,unita_organizzative    unor
             where p_settore = stam.numero
               and stam.ni = unor.ni
               and unor.tipo = 'P'
             group by unor.ni;
         exception
            when no_data_found then
               p_errore       := 'P08054';
               p_segnalazione := si4.get_error(p_errore); -- Non ci sono revisioni Valide
               raise form_trigger_failure;
         end;
         begin
            select dal into d_dal from revisioni_struttura where revisione = d_revisione;
         end;
         begin
            for cur in (select revisione
                              ,dal
                              ,stato
                          from revisioni_struttura
                         where stato in ('A', 'O')
                           and dal >= d_dal
                           and d_dal <= nvl(p_al, to_date('3333333', 'j'))
                           and dal <= nvl(p_al, to_date('3333333', 'j'))
                         order by dal)
            loop
               begin
                  select 'x'
                    into app
                    from unita_organizzative
                   where tipo = 'P'
                     and ni = d_ni
                     and revisione = cur.revisione;
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     null;
                  when no_data_found then
                     p_errore       := 'P08053';
                     p_segnalazione := si4.get_error(p_errore) || ' ' ||
                                       to_char(d_min_dal, 'dd/mm/yyyy') || ' al ' ||
                                       to_char(cur.dal - 1, 'dd/mm/yyyy');
                     -- Unita Organizzativa valida dal / al'
                     raise form_trigger_failure;
               end;
            end loop;
         end;
      end;
   exception
      when form_trigger_failure then
         null;
   end chk_pegi_unor_3;
   --
   function get_posizione
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2 is
      d_posizione periodi_giuridici.posizione%type;
      /******************************************************************************
         NAME:       GET_posizione
         PURPOSE:    Fornire la posizione giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_posizione := to_char(null);
      begin
         select pegi.posizione
           into d_posizione
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_posizione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_posizione := to_char(null);
            end;
      end;
      return d_posizione;
   end get_posizione;
   --
   function get_al
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return date is
      d_al periodi_giuridici.al%type;
      /******************************************************************************
         NAME:       GET_al
         PURPOSE:    Fornire la data di fine del periodo giuridico dell'individuo
                     valido ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_al := to_date(null);
      begin
         select pegi.al
           into d_al
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_al := to_date(null);
            end;
         when too_many_rows then
            begin
               d_al := to_date(null);
            end;
      end;
      return d_al;
   end get_al;
   --
   function get_ultimo_dal
   (
      p_ci        in number
     ,p_rilevanza in varchar2
   ) return date is
      d_dal periodi_giuridici.al%type;
      /******************************************************************************
         NAME:       GET_dal
         PURPOSE:    Fornire la data di inizio dell'ultimo periodo giuridico dell'individuo
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_dal := to_date(null);
      begin
         select pegi.dal
           into d_dal
           from periodi_giuridici pegi
          where ci = p_ci
            and dal = (select max(dal)
                         from periodi_giuridici
                        where ci = p_ci
                          and rilevanza = p_rilevanza)
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_dal := to_date(null);
            end;
         when too_many_rows then
            begin
               d_dal := to_date(null);
            end;
      end;
      return d_dal;
   end get_ultimo_dal;
   --
   function get_ultima_cessazione(p_ci in number) return date is
      d_al periodi_giuridici.al%type;
      /******************************************************************************
         NAME:       GET_ultima_cessazione
         PURPOSE:    Fornire l'ultima data di termine di rapporto di lavoro
                     dell'individuo
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        04/12/2002
      ******************************************************************************/
   begin
      d_al := to_date(null);
      begin
         select max(nvl(pegi.al, to_date(3333333, 'j')))
           into d_al
           from periodi_giuridici pegi
          where ci = p_ci
            and pegi.rilevanza = 'P';
      exception
         when no_data_found then
            begin
               d_al := to_date(null);
            end;
         when too_many_rows then
            begin
               d_al := to_date(null);
            end;
      end;
      return d_al;
   end get_ultima_cessazione;
   --
   function get_assunzione
   (
      p_ci   in number
     ,p_data in date
   ) return date is
      d_data periodi_giuridici.al%type;
      /******************************************************************************
        NAME:       GET_assunzione
        PURPOSE:    La data di inizio del rapporto di lavoro valido alla data
        REVISIONS:
      ******************************************************************************/
   begin
      d_data := to_date(null);
      begin
         select dal
           into d_data
           from periodi_giuridici pegi
          where ci = p_ci
            and pegi.rilevanza = 'P'
            and p_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            begin
               d_data := to_date(null);
            end;
         when too_many_rows then
            begin
               d_data := to_date(null);
            end;
      end;
      return d_data;
   end get_assunzione;
   --
   function get_gestione
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2 is
      d_gestione periodi_giuridici.gestione%type;
      /******************************************************************************
         NAME:       GET_gestione
         PURPOSE:    Fornire la gestione giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_gestione := to_char(null);
      begin
         select pegi.gestione
           into d_gestione
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_gestione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_gestione := to_char(null);
            end;
      end;
      return d_gestione;
   end get_gestione;
   --
   function get_settore
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number is
      d_settore periodi_giuridici.settore%type;
      /******************************************************************************
         NAME:       GET_settore
         PURPOSE:    Fornire la settore giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_settore := to_number(null);
      begin
         select pegi.settore
           into d_settore
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_settore := to_number(null);
            end;
         when too_many_rows then
            begin
               d_settore := to_number(null);
            end;
      end;
      return d_settore;
   end get_settore;
   --
   function get_attivita
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2 is
      d_attivita periodi_giuridici.attivita%type;
      /******************************************************************************
         NAME:       GET_attivita
         PURPOSE:    Fornire la attivita giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_attivita := to_char(null);
      begin
         select pegi.attivita
           into d_attivita
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_attivita := to_char(null);
            end;
         when too_many_rows then
            begin
               d_attivita := to_char(null);
            end;
      end;
      return d_attivita;
   end get_attivita;
   --
   function get_assenza
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2 is
      d_assenza periodi_giuridici.assenza%type;
      /******************************************************************************
         NAME:       GET_assenza
         PURPOSE:    Riporta il codice dell'eventuale assenza sostituibile alla data
      ******************************************************************************/
   begin
      d_assenza := to_char(null);
      begin
         select pegi.assenza
           into d_assenza
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = 'A'
            and exists (select 'x'
                   from astensioni
                  where codice = pegi.assenza
                    and sostituibile = 1);
      exception
         when no_data_found then
            begin
               d_assenza := to_char(null);
            end;
         when too_many_rows then
            begin
               d_assenza := to_char(null);
            end;
      end;
      return d_assenza;
   end get_assenza;
   --
   function get_incarico
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2 is
      d_incarico periodi_giuridici.evento%type;
      /******************************************************************************
         NAME:       GET_incarico
         PURPOSE:    Riporta il codice dell'eventuale incarico  alla data
      ******************************************************************************/
   begin
      d_incarico := to_char(null);
      begin
         select pegi.evento
           into d_incarico
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = 'I';
      exception
         when no_data_found then
            begin
               d_incarico := to_char(null);
            end;
         when too_many_rows then
            begin
               d_incarico := to_char(null);
            end;
      end;
      return d_incarico;
   end get_incarico;
   --
   function get_figura
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number is
      d_figura periodi_giuridici.figura%type;
      /******************************************************************************
         NAME:       GET_figura
         PURPOSE:    Fornire la figura giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_figura := to_number(null);
      begin
         select pegi.figura
           into d_figura
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_figura := to_number(null);
            end;
         when too_many_rows then
            begin
               d_figura := to_number(null);
            end;
      end;
      return d_figura;
   end get_figura;
   --
   function get_qualifica
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number is
      d_qualifica periodi_giuridici.qualifica%type;
      /******************************************************************************
         NAME:       GET_qualifica
         PURPOSE:    Fornire la qualifica giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_qualifica := to_char(null);
      begin
         select pegi.qualifica
           into d_qualifica
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_qualifica := to_number(null);
            end;
         when too_many_rows then
            begin
               d_qualifica := to_number(null);
            end;
      end;
      return d_qualifica;
   end get_qualifica;
   --
   function get_note_concatenate
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_dal       in date
     ,p_al        in date
   ) return varchar2 is
      d_note periodi_giuridici.note%type;
      /******************************************************************************
         NAME:       GET_note_tutte
         PURPOSE:    Fornire le note concatenate delle registrazioni comprese nel periodo 
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/04/2007  ML               Prima emissione
      ******************************************************************************/
   begin
      d_note := to_char(null);
      begin
         for cur in (select note
                       from periodi_giuridici
                      where ci = p_ci
                        and rilevanza = p_rilevanza
                        and dal >= p_dal
                        and nvl(al, to_date('3333333', 'j')) <=
                            nvl(p_al, to_date('3333333', 'j')))
         loop
            d_note := nvl(d_note, ' ') || ' ' || cur.note;
         end loop;
      end;
      return substr(ltrim(d_note), 1, 3900);
   end get_note_concatenate;
   --
   function get_tipo_part_time
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2 is
      d_tipo_part_time posizioni.tipo_part_time%type;
      d_note           periodi_giuridici.note%type;
      /******************************************************************************
         NAME:       get_tipo_part_time
         PURPOSE:    Fornire il tipo di part-time dell'individuo ad una certa data,
                     in base a quanto indicato nelle note.
      
      ******************************************************************************/
   begin
      d_tipo_part_time := to_char(null);
      begin
         select note
           into d_note
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
         if d_note like '%VERTICALE:%' then
            d_tipo_part_time := 'V';
         elsif d_note like '%MISTO:%' then
            d_tipo_part_time := 'M';
         else
            d_tipo_part_time := '';
         end if;
      exception
         when no_data_found then
            begin
               d_tipo_part_time := to_char(null);
            end;
         when too_many_rows then
            begin
               d_tipo_part_time := to_char(null);
            end;
      end;
      return d_tipo_part_time;
   end get_tipo_part_time;
   --
   function get_perc_part_time
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2 is
      d_perc_part_time varchar2(5);
      d_note           periodi_giuridici.note%type;
      /***********************************************************************************
         NAME:       get_perc_part_time
         PURPOSE:    Fornire la percentuale di part-time dell'individuo ad una certa data,
                     in base a quanto indicato nelle note.
      
      ***********************************************************************************/
   begin
      d_perc_part_time := to_char(null);
      begin
         select note
           into d_note
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      
         if d_note like '%VERTICALE:%' then
            d_perc_part_time := nvl(substr(ltrim(substr(d_note
                                                       ,instr(d_note, 'VERTICALE:') + 10))
                                          ,1
                                          ,5)
                                   ,0);
         elsif d_note like '%MISTO:%' then
            d_perc_part_time := nvl(substr(ltrim(substr(d_note
                                                       ,instr(d_note, 'MISTO:') + 6))
                                          ,1
                                          ,5)
                                   ,0);
         else
            d_perc_part_time := '';
         end if;
      exception
         when no_data_found then
            begin
               d_perc_part_time := to_char(null);
            end;
         when too_many_rows then
            begin
               d_perc_part_time := to_char(null);
            end;
      end;
      return d_perc_part_time;
   end get_perc_part_time;
   --
   function get_assunto_part_time
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2 is
      d_part_time varchar2(2) := to_char(null);
      d_data_ass  date;
      /******************************************************************************
         NAME:       get_assunto_part_time
         PURPOSE:    Indica se l'individuo e stato assunto come part-time
                     Individua il rapporto di lavoro valido alla data
                  Verifica se il primo periodo di inquadramento di tale rapporto
                  aveva data di inzio coincidente con il rapporto stesso ed era in
                  posizione di part-time
      ******************************************************************************/
   begin
      d_data_ass := gp4_pegi.get_assunzione(p_ci, p_data);
      begin
         select 'SI'
           into d_part_time
           from periodi_giuridici pegi
          where 1 = 1
            and exists (select 'x'
                   from posizioni
                  where codice = pegi.posizione
                    and part_time = 'SI')
            and ci = p_ci
            and pegi.rilevanza = 'Q'
            and pegi.dal = d_data_ass;
      exception
         when no_data_found then
            d_part_time := 'NO';
         when too_many_rows then
            d_part_time := to_char(null);
      end;
      return d_part_time;
   end get_assunto_part_time;
   --
   function get_pegi_door_id
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_revisione in number
   ) return number is
      d_door_id       dotazione_organica.door_id%type;
      d_settore       settori_amministrativi.codice%type;
      d_area          aree.area%type;
      d_ruolo         ruoli.codice%type;
      d_profilo       profili_professionali.codice%type;
      d_posizione     posizioni_funzionali.codice%type;
      d_figura        figure_giuridiche.codice%type;
      d_qualifica     qualifiche_giuridiche.codice%type;
      d_livello       qualifiche_giuridiche.livello%type;
      d_gestione      dotazione_organica.gestione%type;
      d_attivita      dotazione_organica.attivita%type;
      d_tipo_rapporto dotazione_organica.tipo_rapporto%type;
      d_ore           dotazione_organica.ore%type;
      d_dal_a         date;
      situazione_anomala exception;
      /******************************************************************************
         NAME:       GET_pegi_door_id
         PURPOSE:    Fornire il door_id corrispondente al record di PEGI
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0
      ******************************************************************************/
   begin
      d_door_id := to_number(null);
      d_area    := to_char(null);
      begin
         select gp4_stam.get_codice(gp4_stam.get_ni_numero(pegi.settore)) settore
               ,pegi.gestione
               ,pegi.attivita
               ,pegi.tipo_rapporto
               ,pegi.ore
               ,gp4_qugi.get_ruolo(nvl(pegi.qualifica
                                      ,gp4_figi.get_qualifica(pegi.figura, pegi.dal))
                                  ,pegi.dal) ruolo
               ,gp4_figi.get_profilo(pegi.figura, pegi.dal) profilo
               ,gp4_figi.get_posizione(pegi.figura, pegi.dal) posizione
               ,gp4_figi.get_codice(pegi.figura, pegi.dal) figura
               ,gp4_qugi.get_codice(nvl(pegi.qualifica
                                       ,gp4_figi.get_qualifica(pegi.figura, pegi.dal))
                                   ,pegi.dal) qualifica
               ,gp4_qugi.get_livello(nvl(pegi.qualifica
                                        ,gp4_figi.get_qualifica(pegi.figura, pegi.dal))
                                    ,pegi.dal)
           into d_settore
               ,d_gestione
               ,d_attivita
               ,d_tipo_rapporto
               ,d_ore
               ,d_ruolo
               ,d_profilo
               ,d_posizione
               ,d_figura
               ,d_qualifica
               ,d_livello
           from periodi_giuridici pegi
          where ci = p_ci
            and rilevanza = p_rilevanza
            and dal = p_data;
         d_door_id := gp4_door.get_id(p_revisione
                                     ,p_rilevanza
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
      exception
         when no_data_found then
            begin
               d_door_id := to_number(null);
            end;
         when too_many_rows then
            begin
               d_door_id := to_number(null);
            end;
      end;
      return d_door_id;
   end get_pegi_door_id;
   --
   function get_tipo_rapporto
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return varchar2 is
      d_tipo_rapporto periodi_giuridici.tipo_rapporto%type;
      /******************************************************************************
         NAME:       GET_tipo_rapporto
         PURPOSE:    Fornire la tipo_rapporto giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_tipo_rapporto := to_char(null);
      begin
         select pegi.tipo_rapporto
           into d_tipo_rapporto
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_tipo_rapporto := to_char(null);
            end;
         when too_many_rows then
            begin
               d_tipo_rapporto := to_char(null);
            end;
      end;
      return d_tipo_rapporto;
   end get_tipo_rapporto;
   --
   function get_ore
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_data      in date
   ) return number is
      d_ore periodi_giuridici.ore%type;
      /******************************************************************************
         NAME:       GET_ore
         PURPOSE:    Fornire la ore giuridica dell'individuo ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
      ******************************************************************************/
   begin
      d_ore := to_number(null);
      begin
         select pegi.ore
           into d_ore
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and pegi.rilevanza = p_rilevanza;
      exception
         when no_data_found then
            begin
               d_ore := to_number(null);
            end;
         when too_many_rows then
            begin
               d_ore := to_number(null);
            end;
      end;
      return d_ore;
   end get_ore;
   --
end gp4_pegi;
/
