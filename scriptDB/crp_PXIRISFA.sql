create or replace package pxirisfa is
   function versione return varchar2;

   function individuo_presente(p_ci in number) return varchar2;

   function rilevanza_utile(p_ci in number) return varchar2;

   function get_cdc
   (
      p_settore in number
     ,p_sede    in number
   ) return varchar2;

   function get_datamax
   (
      p_ci        in number
     ,p_rilevanza in varchar2
   ) return date;

   function get_dataaperta
   (
      p_ci        in number
     ,p_rilevanza in varchar2
   ) return date;

   function get_matricola_familiare
   (
      p_cognome        in varchar2
     ,p_nome           in varchar2
     ,p_codice_fiscale in varchar2
   ) return number;
end;
/
create or replace package body pxirisfa is
   function versione return varchar2 is
   begin
      return 'V1.0 del 22/08/2006';
   end versione;

   function individuo_presente(p_ci in number) return varchar2 is
      d_presente varchar2(2) := 'NO';
   begin
      begin
         select 'SI'
           into d_presente
           from classi_rapporto
          where codice = gp4_rain.get_rapporto(p_ci)
            and presenza = 'SI';
      
         return d_presente;
      exception
         when no_data_found then
            return d_presente;
      end;
   end;

   function rilevanza_utile(p_ci in number) return varchar2 is
      d_rilevanza  periodi_giuridici.rilevanza%type := 'X';
      d_presente   classi_rapporto.presenza%type := 'NO';
      d_retribuito classi_rapporto.retributivo%type := 'NO';
   begin
      begin
         select presenza
               ,retributivo
           into d_presente
               ,d_retribuito
           from classi_rapporto
          where codice = gp4_rain.get_rapporto(p_ci);
      
         if d_presente = 'SI' and d_retribuito = 'SI' then
            d_rilevanza := 'S';
         elsif d_presente = 'SI' and d_retribuito = 'NO' then
            d_rilevanza := 'Q';
         end if;
      
         return d_rilevanza;
      exception
         when no_data_found then
            return d_rilevanza;
      end;
   end;

   function get_datamax
   (
      p_ci        in number
     ,p_rilevanza in varchar2
   ) return date is
      d_datamax date;
   begin
      begin
         select max(dal) datamax
           into d_datamax
           from periodi_giuridici
          where rilevanza = p_rilevanza
            and ci = p_ci;
      
         return d_datamax;
      exception
         when no_data_found then
            return to_date(null);
      end;
   end;

   function get_dataaperta
   (
      p_ci        in number
     ,p_rilevanza in varchar2
   ) return date is
      d_dataaperta date;
   begin
      begin
         select nvl(max(dal), to_date('31123999', 'DDMMYYYY')) dataaperta
           into d_dataaperta
           from periodi_giuridici
          where rilevanza = p_rilevanza
            and ci = p_ci
            and al is null;
      
         return d_dataaperta;
      exception
         when no_data_found then
            return to_date(null);
      end;
   end;

   function get_cdc
   (
      p_settore in number
     ,p_sede    in number
   ) return varchar2 is
      d_cdc ripartizioni_funzionali.cdc%type := to_char(null);
   begin
      begin
         select rifu.cdc
           into d_cdc
           from ripartizioni_funzionali rifu
          where settore = p_settore
            and sede = p_sede;
      
         return d_cdc;
      exception
         when no_data_found then
            return d_cdc;
      end;
   end;
   function get_matricola_familiare
   (
      p_cognome        in varchar2
     ,p_nome           in varchar2
     ,p_codice_fiscale in varchar2
   ) return number is
      d_ni anagrafici.ni%type := to_number(null);
   begin
      begin
         select ni
           into d_ni
           from anagrafe
          where cognome = p_cognome
            and nome = p_nome
            and codice_fiscale = p_codice_fiscale;
      
         return d_ni;
      exception
         when no_data_found then
            return d_ni;
      end;
   end;
end;
/
