create or replace package gp4_reuo is
   /******************************************************************************
    NOME:        GP4_REUO
    DESCRIZIONE: <Descrizione Package>
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    0    09/05/2005    CB     Prima emissione.
    1    23/01/2006    MM     Nuova function get_ni_padre
    1.1  08/02/2007    MM     Nuova function get_ni_padre_livello
    1.2  28/08/2007    MM     Att.22092
   ******************************************************************************/
   function versione return varchar2;
   function get_codice_padre
   (
      p_revisione          in number
     ,p_codice_figlio      varchar2
     ,p_suddivisione_padre in number
   ) return varchar2;
   function get_ni_padre
   (
      p_revisione          in number
     ,p_ni_figlio          in number
     ,p_suddivisione_padre in number
   ) return number;
   function get_ni_padre_livello
   (
      p_revisione     in number
     ,p_ni_figlio     in number
     ,p_livello_padre in number
   ) return number;
end gp4_reuo;
/
create or replace package body gp4_reuo as
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
      return 'V1.2 del 28/08/2007';
   end versione;
   --
   function get_codice_padre
   (
      p_revisione          in number
     ,p_codice_figlio      varchar2
     ,p_suddivisione_padre in number
   ) return varchar2 is
      d_codice_padre varchar2(20);
      /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce il codice padre
       PARAMETRI:   --
       RITORNA:
       NOTE:
      ******************************************************************************/
   begin
      begin
         select codice_padre
           into d_codice_padre
           from relazioni_uo
          where revisione = p_revisione
            and codice_figlio = p_codice_figlio
            and livello_padre = p_suddivisione_padre;
      exception
         when no_data_found then
            d_codice_padre := null;
         when others then
            d_codice_padre := null;
      end;
      return d_codice_padre;
   end get_codice_padre;
   --
   function get_ni_padre
   (
      p_revisione          in number
     ,p_ni_figlio          in number
     ,p_suddivisione_padre in number
   ) return number is
      d_ni_padre number;
      /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce l'NI del padre del livello dato
      ******************************************************************************/
   begin
      begin
         select padre
           into d_ni_padre
           from relazioni_uo
          where revisione = p_revisione
            and figlio = p_ni_figlio
            and livello_padre = p_suddivisione_padre;
      exception
         when no_data_found then
            d_ni_padre := null;
         when others then
            d_ni_padre := null;
      end;
      return d_ni_padre;
   end get_ni_padre;
   --
   function get_ni_padre_livello
   (
      p_revisione     in number
     ,p_ni_figlio     in number
     ,p_livello_padre in number
   ) return number is
      d_ni_padre number;
      /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce l'NI del padre del livello dato
      ******************************************************************************/
   begin
      begin
         select padre
           into d_ni_padre
           from relazioni_uo
          where revisione = p_revisione
            and figlio = p_ni_figlio
            and livello_padre = p_livello_padre;
      exception
         when no_data_found then
            d_ni_padre := null;
         when others then
            d_ni_padre := null;
      end;
      return d_ni_padre;
   end get_ni_padre_livello;
   --
end gp4_reuo;
/
