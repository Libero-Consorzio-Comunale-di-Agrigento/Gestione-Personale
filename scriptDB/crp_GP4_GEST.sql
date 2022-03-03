create or replace package gp4_gest is
   /******************************************************************************
    NOME:        GP4_GEST
    DESCRIZIONE: funzioni sulla tabella GESTIONI
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data        Autore   Descrizione
    ---- ----------  ------   ------------------------------------------------------
    0    27/08/2002           Prima emissione.
    1    04/06/2004           Aggiunta le funzione get_ore_do e get_sost_ruolo
    2    16/12/2005  CB       Aggiunta la function get_perc_copertura
    3    15/11/2005  MM       Aggiunta la function get_filtro_settori
    3.1  31/01/2007  MM       Aggiuna la funzione get_dotazione
   ******************************************************************************/
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   function get_controlli_do(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_controlli_do, wnds, wnps);
   function get_dotazione(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_dotazione, wnds, wnps);
   function get_sost_ruolo(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_sost_ruolo, wnds, wnps);
   function get_filtro_settori(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_filtro_settori, wnds, wnps);
   function get_ore_do(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_ore_do, wnds, wnps);
   function get_gg_sost_ante_assenza(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_gg_sost_ante_assenza, wnds, wnps);
   function get_gg_sost_post_assenza(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_gg_sost_post_assenza, wnds, wnps);
   function get_perc_copertura(p_codice in varchar2) return varchar2;
   pragma restrict_references(get_perc_copertura, wnds, wnps);
end gp4_gest;
/
create or replace package body gp4_gest as
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
      return 'V3.1 del 31/01/2007';
   end versione;
   --
   function get_controlli_do(p_codice in varchar2) return varchar2 is
      d_controlli_do gestioni.controlli_do%type;
      /******************************************************************************
       NOME:        GET_CONTROLLI_DO
       DESCRIZIONE: Restituisce il tipo di controllo sulla Dotazione Organica, previsto per
                    la gestione, dato il codice
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_controlli_do := to_char(null);
      begin
         select controlli_do into d_controlli_do from gestioni where codice = p_codice;
      exception
         when no_data_found then
            d_controlli_do := to_char(null);
      end;
      return d_controlli_do;
   end get_controlli_do;
   --
   function get_dotazione(p_codice in varchar2) return varchar2 is
      d_dotazione gestioni.dotazione%type;
      /******************************************************************************
       NOME:        GET_dotazione
       DESCRIZIONE: Restituisce il tipo di gestione sulla Dotazione Organica. 
                    SI = Gestione gestita in DO
                    NO = Gestione non gestita in DO
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_dotazione := to_char(null);
      begin
         select dotazione into d_dotazione from gestioni where codice = p_codice;
      exception
         when no_data_found then
            d_dotazione := to_char(null);
      end;
      return d_dotazione;
   end get_dotazione;
   --
   function get_sost_ruolo(p_codice in varchar2) return varchar2 is
      d_sostituzioni_non_ruolo gestioni.sostituzioni_non_ruolo%type;
      /******************************************************************************
       NOME:        GET_CONTROLLI_DO
       DESCRIZIONE: Restituisce il tipo di controllo sulla posizione giuridica dei sostituti
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_sostituzioni_non_ruolo := to_char(null);
      begin
         select sostituzioni_non_ruolo
           into d_sostituzioni_non_ruolo
           from gestioni
          where codice = p_codice;
      exception
         when no_data_found then
            d_sostituzioni_non_ruolo := to_char(null);
      end;
      return d_sostituzioni_non_ruolo;
   end get_sost_ruolo;
   --
   function get_filtro_settori(p_codice in varchar2) return varchar2 is
      d_filtro_settori gestioni.filtro_settori%type;
      /******************************************************************************
       NOME:        GET_CONTROLLI_DO
       DESCRIZIONE: Restituisce il tipo di filtro sul settore nella SDOEF
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_filtro_settori := to_char(null);
      begin
         select filtro_settori
           into d_filtro_settori
           from gestioni
          where codice = p_codice;
      exception
         when no_data_found then
            d_filtro_settori := to_char(null);
      end;
      return d_filtro_settori;
   end get_filtro_settori;
   --
   function get_ore_do(p_codice in varchar2) return varchar2 is
      d_ore_do gestioni.ore_do%type;
      /******************************************************************************
       NOME:        GET_ORE_DO
       DESCRIZIONE: Restituisce l'unita di misura adottata per in conteggio
                    dei dipendenti sulla dotazione organica, per
                    la gestione indicata, dato il codice
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_ore_do := to_char(null);
      begin
         select ore_do into d_ore_do from gestioni where codice like p_codice;
      exception
         when no_data_found or too_many_rows then
            d_ore_do := to_char(null);
      end;
      return nvl(d_ore_do, 'U');
   end get_ore_do;
   --
   function get_gg_sost_post_assenza(p_codice in varchar2) return varchar2 is
      d_gg_sost_post_assenza gestioni.gg_sost_post_assenza%type;
      /******************************************************************************
       NOME:        GET_GG_SOST_POST_ASSENZA
       DESCRIZIONE: Restituisce il numero di giorni per i quali e possibile posticipare
                    la sostituzione rispetto al periodo di assenza del titolare
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_gg_sost_post_assenza := to_char(null);
      begin
         select gg_sost_post_assenza
           into d_gg_sost_post_assenza
           from gestioni
          where codice like p_codice;
      exception
         when no_data_found or too_many_rows then
            d_gg_sost_post_assenza := to_char(null);
      end;
      return d_gg_sost_post_assenza;
   end get_gg_sost_post_assenza;
   --
   function get_gg_sost_ante_assenza(p_codice in varchar2) return varchar2 is
      d_gg_sost_ante_assenza gestioni.gg_sost_ante_assenza%type;
      /******************************************************************************
       NOME:        GET_GG_SOST_ANTE_ASSENZA
       DESCRIZIONE: Restituisce il numero di giorni per i quali e possibile posticipare
                    la sostituzione rispetto al periodo di assenza del titolare
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_gg_sost_ante_assenza := to_char(null);
      begin
         select gg_sost_ante_assenza
           into d_gg_sost_ante_assenza
           from gestioni
          where codice like p_codice;
      exception
         when no_data_found or too_many_rows then
            d_gg_sost_ante_assenza := to_char(null);
      end;
      return d_gg_sost_ante_assenza;
   end get_gg_sost_ante_assenza;
   --
   function get_perc_copertura(p_codice in varchar2) return varchar2 is
      d_perc_copertura gestioni.perc_copertura%type;
      /******************************************************************************
       NOME:        GET_COPERTURA
       DESCRIZIONE: Restituisce la perc_copertura dato il codice della gestione
       PARAMETRI:   --
      ******************************************************************************/
   begin
      d_perc_copertura := to_number(null);
      begin
         select perc_copertura
           into d_perc_copertura
           from gestioni
          where codice like p_codice;
      exception
         when no_data_found or too_many_rows then
            d_perc_copertura := to_number(null);
      end;
      return d_perc_copertura;
   end get_perc_copertura;
   --
end gp4_gest;
/* End Package Body: GP4_GEST */
/
