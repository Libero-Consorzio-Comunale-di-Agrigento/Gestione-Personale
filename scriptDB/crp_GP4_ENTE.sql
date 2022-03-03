create or replace package gp4_ente is
   /******************************************************************************
    NOME:        GP4_ENTE
    DESCRIZIONE:
    ANNOTAZIONI: Versione V1.2
    REVISIONI:   MarcoFa - venerdi 14 gennaio 2005 18.01.20
    Rev.  Data        Autore  Descrizione
    ----  ----------  ------  ----------------------------------------------------
    0     18/07/2002  __      Creazione.
    1     04/02/2004 MF      Inserimento Funzione get_modifiche_DO.
    2     23/12/2004 MF      Nuove Funzioni per estrarre valori di Ente.
    2.1   05/02/2007 MM      Nuovo campo dividi_pegi_in_validazione             
   ******************************************************************************/
   revisione          varchar2(30) := 'V2.1 del 05/02/2007';
   d_rate_addizionali number(2);
   function versione
   /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
       RITORNA:     stringa VARCHAR2 contenente versione e data.
       NOTE:        Il secondo numero della versione corrisponde alla revisione
                    del package.
      ******************************************************************************/
    return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   procedure initialize(requery in varchar2 default 'NO');
   pragma restrict_references(initialize, wnds);
   function init
   /******************************************************************************
       NOME:        init
       DESCRIZIONE: Attiva la funzione di Initialize ritornando sempre NULL,
                    per consentire l'attivazione in una select in concatenazione con altra funzione.
      ******************************************************************************/
    return varchar2;
   pragma restrict_references(init, wnds);
   function get_base_ratei return varchar2;
   pragma restrict_references(get_base_ratei, wnds);
   function get_base_det return varchar2;
   pragma restrict_references(get_base_det, wnds);
   function get_mesi_irpef return number;
   pragma restrict_references(get_mesi_irpef, wnds);
   function get_base_cong return varchar2;
   pragma restrict_references(get_base_cong, wnds);
   function get_scad_cong return varchar2;
   pragma restrict_references(get_scad_cong, wnds);
   function get_rest_cong return varchar2;
   pragma restrict_references(get_rest_cong, wnds);
   function get_rate_addizionali return number;
   pragma restrict_references(get_rate_addizionali, wnds);
   function get_detrazioni_ap return varchar2;
   pragma restrict_references(get_detrazioni_ap, wnds);
   function get_nota_gestione
   /******************************************************************************
       NOME:        get_nota_gestione
       DESCRIZIONE: La nota descrittiva della gestione definita sull'ente
       PARAMETRI:
       RITORNA:     VARCHAR2
       REVISIONI:   MarcoFa - giovedi 30 dicembre 2004 12.05.39
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       0    18/07/2002 __       Creazione.
      ******************************************************************************/
    return varchar2;
   pragma restrict_references(get_nota_gestione, wnds);
   function get_modifiche_do
   /******************************************************************************
       NOME:        get_modifiche_do
       DESCRIZIONE: Indica se e possibile eseguire modifiche alla revisione attiva della dotazione organica.
      ******************************************************************************/
    return varchar2;
   pragma restrict_references(get_modifiche_do, wnds);
   function get_dividi_pegi_in_validazione
   /******************************************************************************
       NOME:        get_DIVIDI_PEGI_IN_VALIDAZIONE
       DESCRIZIONE: Indica se è necessario spezzare pegi in validazione di revisione di struttura
                    se è cambiato il codice della UO
      ******************************************************************************/
    return varchar2;
   pragma restrict_references(get_dividi_pegi_in_validazione, wnds);
end gp4_ente;
/
create or replace package body gp4_ente is
   d_ente_id                    varchar2(4);
   d_base_ratei                 varchar2(1);
   d_base_det                   varchar2(1);
   d_mesi_irpef                 number(2) := 0;
   d_base_cong                  varchar2(1);
   d_scad_cong                  varchar2(1);
   d_rest_cong                  varchar2(1);
   d_detrazioni_ap              varchar2(2);
   d_nota_gestione              ente.nota_gestione%type;
   d_modifiche_do               ente.modifiche_do%type;
   d_dividi_pegi_in_validazione ente.dividi_pegi_in_validazione%type;
   function versione
   /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
       RITORNA:     stringa VARCHAR2 contenente versione e data.
       NOTE:        Il secondo numero della versione corrisponde alla revisione
                    del package.
      ******************************************************************************/
    return varchar2 is
   begin
      return revisione;
   end versione;
   procedure initialize(requery in varchar2 default 'NO') is
   begin
      if d_ente_id is null or requery != 'NO' then
         select ente_id
               ,ratei
               ,detrazioni
               ,nvl(mesi_irpef, 12)
               ,base_cong
               ,scad_cong
               ,rest_cong
               ,rate_addizionali
               ,detrazioni_ap
               ,nota_gestione
               ,modifiche_do
               ,dividi_pegi_in_validazione
           into d_ente_id
               ,d_base_ratei
               ,d_base_det
               ,d_mesi_irpef
               ,d_base_cong
               ,d_scad_cong
               ,d_rest_cong
               ,d_rate_addizionali
               ,d_detrazioni_ap
               ,d_nota_gestione
               ,d_modifiche_do
               ,d_dividi_pegi_in_validazione
           from ente
          where ente_id = 'ENTE';
      end if;
   exception
      when no_data_found or too_many_rows then
         d_ente_id                    := null;
         d_base_ratei                 := null;
         d_base_det                   := null;
         d_mesi_irpef                 := 0;
         d_base_cong                  := null;
         d_scad_cong                  := null;
         d_rest_cong                  := null;
         d_rate_addizionali           := null;
         d_detrazioni_ap              := null;
         d_nota_gestione              := null;
         d_modifiche_do               := 'NO';
         d_dividi_pegi_in_validazione := 'NO';
   end initialize;
   function init
   /******************************************************************************
       NOME:        init
       DESCRIZIONE: Attiva la funzione di Initialize ritornando sempre NULL,
                    per consentire l'attivazione in una select in concatenazione con altra funzione.
      ******************************************************************************/
    return varchar2 is
   begin
      initialize('YES');
      return null;
   end init;
   function get_base_ratei return varchar2 is
   begin
      initialize;
      return d_base_ratei;
   end get_base_ratei;
   function get_base_det return varchar2 is
   begin
      initialize;
      return d_base_det;
   end get_base_det;
   function get_mesi_irpef return number is
   begin
      initialize;
      return d_mesi_irpef;
   end get_mesi_irpef;
   function get_base_cong return varchar2 is
   begin
      initialize;
      return d_base_cong;
   end get_base_cong;
   function get_scad_cong return varchar2 is
   begin
      initialize;
      return d_scad_cong;
   end get_scad_cong;
   function get_rest_cong return varchar2 is
   begin
      initialize;
      return d_rest_cong;
   end get_rest_cong;
   function get_rate_addizionali return number is
   begin
      initialize;
      return d_rate_addizionali;
   end get_rate_addizionali;
   function get_detrazioni_ap return varchar2 is
   begin
      initialize;
      return d_detrazioni_ap;
   end get_detrazioni_ap;
   function get_nota_gestione
   /******************************************************************************
       NOME:        get_nota_gestione
       DESCRIZIONE: La nota descrittiva della gestione definita sull'ente
       PARAMETRI:
       RITORNA:     VARCHAR2
       REVISIONI:   MarcoFa - giovedi 30 dicembre 2004 12.05.39
       Rev.  Data        Autore  Descrizione
       ----  ----------  ------  ----------------------------------------------------
       0    18/07/2002 __       Creazione.
      ******************************************************************************/
    return varchar2 is
   begin
      initialize;
      return d_nota_gestione;
   end get_nota_gestione;
   function get_modifiche_do
   /******************************************************************************
       NOME:        get_modifiche_do
       DESCRIZIONE: Indica se e possibile eseguire modifiche alla revisione attiva della dotazione organica.
      ******************************************************************************/
    return varchar2 is
   begin
      initialize;
      return d_modifiche_do;
   end get_modifiche_do;
   function get_dividi_pegi_in_validazione
   /******************************************************************************
       NOME:        get_DIVIDI_PEGI_IN_VALIDAZIONE
       DESCRIZIONE: Indica se è necessario spezzare pegi in validazione di revisione di struttura
                    se è cambiato il codice della UO
      ******************************************************************************/
    return varchar2 is
   begin
      initialize;
      return d_dividi_pegi_in_validazione;
   end get_dividi_pegi_in_validazione;
end gp4_ente;
/
