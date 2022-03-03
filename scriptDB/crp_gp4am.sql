create or replace package gp4am is
   /******************************************************************************
    NOME:        GP4EC
    DESCRIZIONE: <Descrizione Package>
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    0    11/09/2006 __     Prima emissione.
   ******************************************************************************/
   function versione return varchar2;

   function get_telefono
   (
      p_ni   in number
     ,p_tipo in varchar2
     ,p_data in date
   ) return varchar2;

   function get_fax
   (
      p_ni   in number
     ,p_tipo in varchar2
     ,p_data in date
   ) return varchar2;

   function get_email
   (
      p_ni   in number
     ,p_tipo in varchar2
     ,p_data in date
   ) return varchar2;

   function get_comune_nascita(p_codice_fiscale in varchar2) return varchar2;
end gp4am;
/
create or replace package body gp4am as
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
      return 'V1.0 del 11/09/2006';
   end versione;

   --
   function get_telefono
   (
      p_ni   in number
     ,p_tipo in varchar2
     ,p_data in date
   ) return varchar2 is
      d_telefono varchar2(30) := to_char(null);
      d_ci       rapporti_individuali.ci%type;
   begin
      if p_tipo = 'RES' then
         begin
            select tel_res
              into d_telefono
              from anagrafici
             where ni = p_ni
               and p_data between dal and nvl(al, to_date(3333333, 'j'));
         exception
            when no_data_found then
               d_telefono := 'ANAGRAFE NON PRESENTE';
         end;
      elsif p_tipo = 'DOM' then
         begin
            select tel_dom
              into d_telefono
              from anagrafici
             where ni = p_ni
               and p_data between dal and nvl(al, to_date(3333333, 'j'));
         exception
            when no_data_found then
               d_telefono := 'ANAGRAFE NON PRESENTE';
         end;
      elsif p_tipo = 'UFF' then
         /* Ricerca il telefono ufficio di maggior dettaglio, seguendo la priorita:
           1. Rapporto Individuale (RAIN)
           2. Anagrafe             (ANAG)
           3. Unita Organizzativa  (UNOR)
           4. Sede dell'UO         (SEDI)
           5. Gestione             (GEST)
           6. Componenti           (COMP)
         */
      
         -- dal rapporto individuale, con ricerca il CI valido alla p_data
         begin
            select ci
                  ,telefono_ufficio
              into d_ci
                  ,d_telefono
              from rapporti_individuali
             where ni = p_ni
               and p_data between dal and nvl(al, to_date(3333333, 'j'))
               and rapporto <> '*';
         exception
            when no_data_found then
               null;
            when too_many_rows then
               d_telefono := 'RAPPORTI INDIVIDUALI MULTIPLI';
               return d_telefono;
         end;
      
         -- dall' anagrafe individuale
         if d_telefono is null then
            begin
               select telefono_ufficio
                 into d_telefono
                 from anagrafici
                where ni = p_ni
                  and p_data between dal and nvl(al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  d_telefono := 'ANAGRAFE NON PRESENTE';
               when too_many_rows then
                  d_telefono := 'ANAGRAFE MULTIPLA';
                  return d_telefono;
            end;
         end if;
      
         -- dall'unita organizzativa
         if d_telefono is null
            and d_ci is not null then
            begin
               select telefono_ufficio
                 into d_telefono
                 from anagrafici
                where ni =
                      (select ni
                         from unita_organizzative
                        where ni =
                              (select ni
                                 from settori_amministrativi
                                where numero =
                                      (select settore
                                         from periodi_giuridici
                                        where rilevanza = 'S'
                                          and ci = d_ci
                                          and p_data between dal and
                                              nvl(al, to_date(3333333, 'j')))))
                  and p_data between dal and nvl(al, to_date(3333333, 'j'));
            exception
               when no_data_found then
                  null;
               when too_many_rows then
                  d_telefono := 'UN.ORGANIZZATIVE MULTIPLE';
                  return d_telefono;
            end;
         
            -- dalla sede dell'unita organizzativa
            if d_telefono is null then
               select telefono_ufficio
                 into d_telefono
                 from anagrafici
                where ni =
                      (select sede
                         from unita_organizzative
                        where ni =
                              (select ni
                                 from settori_amministrativi
                                where numero =
                                      (select settore
                                         from periodi_giuridici
                                        where rilevanza = 'S'
                                          and ci = d_ci
                                          and p_data between dal and
                                              nvl(al, to_date(3333333, 'j')))))
                  and p_data between dal and nvl(al, to_date(3333333, 'j'));
            end if;
         
            if d_telefono is null then
               select tel_res
                 into d_telefono
                 from gestioni
                where codice =
                      (select gestione
                         from periodi_giuridici
                        where rilevanza = 'S'
                          and ci = d_ci
                          and p_data between dal and
                              nvl(al, to_date(3333333, 'j')));
            end if;
         end if;
      
         -- dai componenti
         if d_telefono is null then
            begin
               select telefono
                 into d_telefono
                 from componenti
                where ni = p_ni
                  and p_data between dal and nvl(al, to_date(3333333, 'j'));
            
               return d_telefono;
            exception
               when no_data_found then
                  null;
               when too_many_rows then
                  d_telefono := 'COMPONENTI MULTIPLI';
                  return d_telefono;
            end;
         end if;
      end if;
   
      return d_telefono;
   end;

   function get_fax
   (
      p_ni   in number
     ,p_tipo in varchar2
     ,p_data in date
   ) return varchar2 is
      d_telefono varchar2(30);
   begin
      return d_telefono;
   end;

   function get_email
   (
      p_ni   in number
     ,p_tipo in varchar2
     ,p_data in date
   ) return varchar2 is
      d_telefono varchar2(30);
   begin
      return d_telefono;
   end;

   function get_comune_nascita(p_codice_fiscale in varchar2) return varchar2 is
      d_codice_nascita varchar2(6);
   begin
      begin
         select lpad(comu.cod_provincia, 3, '0') ||
                lpad(comu.cod_comune, 3, '0')
           into d_codice_nascita
           from comuni comu
          where comu.codice_catasto = substr(p_codice_fiscale, 12, 4);
      exception
         when no_data_found
              or too_many_rows then
            d_codice_nascita := null;
      end;
      return d_codice_nascita;
   end;
end gp4am;
/
