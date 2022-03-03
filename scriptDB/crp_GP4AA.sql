create or replace package gp4aa is
   /******************************************************************************
    NOME:        GP4_AA
    DESCRIZIONE: funzioni di Ambiente Applicativo
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    0    19/05/2006 ML     Prima emissione.
   ******************************************************************************/
   function versione return varchar2;

   pragma restrict_references(versione, wnds, wnps);

   function elimina_tag
   (
      p_stringa in varchar2
     ,p_inizio  in varchar2
     ,p_fine    in varchar2
   ) return varchar2;

   function mintoqta(p_minuti in number) return number;

   pragma restrict_references(elimina_tag, wnds, wnps);
end gp4aa;
/
create or replace package body gp4aa is
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
      return 'V2.0 del 06/09/2006';
   end versione;

   --
   function elimina_tag
   (
      p_stringa in varchar2
     ,p_inizio  in varchar2
     ,p_fine    in varchar2
   ) return varchar2 is
      v_testo varchar2(4000);
   begin
      v_testo := p_stringa;
   
      if instr(v_testo, p_inizio) > 0
         and instr(v_testo, p_fine) > 0 then
         v_testo := elimina_tag(substr(v_testo
                                      ,1
                                      ,instr(v_testo, p_inizio) - 1) ||
                                substr(v_testo, instr(v_testo, p_fine) + 1)
                               ,p_inizio
                               ,p_fine);
      end if;
   
      return v_testo;
   end elimina_tag;

   --
   function mintoqta(p_minuti in number) return number is
      d_qta movimenti_contabili.qta%type;
   begin
      d_qta := trunc(p_minuti / 60) + mod(p_minuti, 60) / 60;
      return d_qta;
   end mintoqta;
   --
end gp4aa;
/
