create or replace package gp4_asin is
   /******************************************************************************
    NOME:        GP4_ASIN
    DESCRIZIONE: Funzioni su ASSICURAZIONI_INAIL
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    1.0  07/08/2003        Prima emissione
    1.1  03/04/2007 MM     Att.19716 Nuova funzione get_posizione
   ******************************************************************************/
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   function get_descrizione(p_posizione in varchar2) return varchar2;
   pragma restrict_references(get_descrizione, wnds, wnps);
   function get_posizione(p_posizione in varchar2) return varchar2;
   pragma restrict_references(get_posizione, wnds, wnps);
end gp4_asin;
/
create or replace package body gp4_asin as
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
      return 'V1.1 del 03/04/2007';
   end versione;
   --
   function get_descrizione(p_posizione in varchar2) return varchar2 is
      d_descrizione assicurazioni_inail.descrizione%type;
      /******************************************************************************
         NAME:       GET_DESCRIZIONE
         PURPOSE:    Restituire la descrizione della tipologia di posizione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        07/08/2003          1. Created this function.
      ******************************************************************************/
   begin
      begin
         select descrizione
           into d_descrizione
           from assicurazioni_inail asin
          where asin.codice = p_posizione;
      exception
         when no_data_found then
            d_descrizione := to_char(null);
         when too_many_rows then
            d_descrizione := to_char(null);
      end;
      return d_descrizione;
   end get_descrizione;
   --
   function get_posizione(p_posizione in varchar2) return varchar2 is
      d_posizione assicurazioni_inail.posizione%type;
      /******************************************************************************
         NAME:       GET_posizione
         PURPOSE:    Restituire la PAT
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        03/04/2007  MM
      ******************************************************************************/
   begin
      begin
         select posizione
           into d_posizione
           from assicurazioni_inail asin
          where asin.codice = p_posizione;
      exception
         when no_data_found then
            d_posizione := to_char(null);
         when too_many_rows then
            d_posizione := to_char(null);
      end;
      return d_posizione;
   end get_posizione;
   --
end gp4_asin;
/* End Package Body: GP4_ASIN */
/
