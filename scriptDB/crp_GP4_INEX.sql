create or replace package gp4_inex is
   /******************************************************************************
    NOME:        GP4_INEX
    DESCRIZIONE:
    ANNOTAZIONI: Versione V1.0
    REVISIONI:   MarcoFa - lunedi 27 dicembre 2004 16.39.57
    Rev.  Data        Autore  Descrizione
    ----  ----------  ------  ----------------------------------------------------
    1.0   12/01/2005  NN      Creazione.
    1.1   11/03/2005  NN      Introdotta Funzione get_ipn_ded
    1.2   17/05/2005  NN      Introdotta Funzione get_ipn_ded_magg
    1.3   17/10/2005  MS      Introdotta Funzione get_ipn_fam
    1.4   28/11/2006  MM      Introdotta funzione get_riv_tfr_ap (att. 18651)
    1.5   04/04/2007  ML      Introdotta funzione get_esente_comu (A20420)
    1.6   18/04/2007  ML      Invertire il significato del flag esenzione in get_esente_comu (A20631)
   ******************************************************************************/
   revisione varchar2(30) := 'V1.6';
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
   procedure initialize
   (
      p_ci    in number
     ,p_anno  in number
     ,requery in varchar2 default 'NO'
   );
   pragma restrict_references(initialize, wnds);
   function init
   /******************************************************************************
       NOME:        init
       DESCRIZIONE: Attiva la funzione di Initialize ritirnando sempre NULL,
                    per consentire l'attivazione in una select in concatenazione con altra funzione.
      ******************************************************************************/
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2;
   pragma restrict_references(init, wnds);
   function get_effe_cong
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2;
   pragma restrict_references(get_effe_cong, wnds);
   function get_ipn_ded
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2;
   pragma restrict_references(get_ipn_ded, wnds);
   function get_ipn_ded_magg
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2;
   pragma restrict_references(get_ipn_ded_magg, wnds);
   function get_ipn_fam
   (
      p_ci   in number
     ,p_anno in number
     ,p_mese in number
   ) return number;
   pragma restrict_references(get_ipn_fam, wnds);
   function get_riv_tfr_ap
   (
      p_ci   in number
     ,p_anno in number
   ) return number;
   pragma restrict_references(get_riv_tfr_ap, wnds);
   function get_esente_comu
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2;
   pragma restrict_references(get_ipn_ded_magg, wnds);
   
end gp4_inex;
/
create or replace package body gp4_inex is
   d_effe_cong    varchar2(1);
   d_ipn_ded      number;
   d_ipn_ded_magg number;
   d_esente_comu  varchar2(2);
   d_ci           number;
   d_anno         number;
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
   procedure initialize
   (
      p_ci    in number
     ,p_anno  in number
     ,requery in varchar2 default 'NO'
   ) is
   begin
      if d_ci != p_ci
         or d_ci is null
         or d_anno != p_anno
         or d_anno is null
         or requery != 'NO' then
         d_ci   := p_ci;
         d_anno := p_anno;
         select effe_cong
               ,ipn_ded
               ,ipn_ded_magg
--inverte il contenuto del flag, pechè deve esprimese se il ci ha diritto all'esenzione. Morena
               ,decode( nvl(rinuncia_esenzione_add_com,'NO')
                      , 'NO', 'SI'
                            , 'NO')
           into d_effe_cong
               ,d_ipn_ded
               ,d_ipn_ded_magg
               ,d_esente_comu
           from informazioni_extracontabili
          where ci = p_ci
            and anno = p_anno;
      end if;
   exception
      when no_data_found then
         d_effe_cong    := null;
         d_ipn_ded      := null;
         d_ipn_ded_magg := null;
   end initialize;
   function init
   /******************************************************************************
       NOME:        init
       DESCRIZIONE: Attiva la funzione di Initialize ritornando sempre NULL,
                    per consentire l'attivazione in una select in concatenazione con altra funzione.
      ******************************************************************************/
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2 is
   begin
      initialize(p_ci, p_anno, 'YES');
      return null;
   end init;
   function get_effe_cong
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2 is
   begin
      initialize(p_ci, p_anno);
      return d_effe_cong;
   end get_effe_cong;
   function get_ipn_ded
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2 is
   begin
      initialize(p_ci, p_anno);
      return d_ipn_ded;
   end get_ipn_ded;
   function get_ipn_ded_magg
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2 is
   begin
      initialize(p_ci, p_anno);
      return d_ipn_ded_magg;
   end get_ipn_ded_magg;
   function get_ipn_fam
   (
      p_ci   in number
     ,p_anno in number
     ,p_mese in number
   ) return number is
      d_ipn_fam number := 0;
   begin
      begin
         select decode(p_mese
                      ,1
                      ,nvl(ipn_fam_1, ipn_fam_2ap)
                      ,2
                      ,nvl(ipn_fam_2, ipn_fam_2ap)
                      ,3
                      ,nvl(ipn_fam_3, ipn_fam_2ap)
                      ,4
                      ,nvl(ipn_fam_4, ipn_fam_2ap)
                      ,5
                      ,nvl(ipn_fam_5, ipn_fam_2ap)
                      ,6
                      ,nvl(ipn_fam_6, ipn_fam_2ap)
                      ,7
                      ,nvl(ipn_fam_7, ipn_fam_1ap)
                      ,8
                      ,nvl(ipn_fam_8, ipn_fam_1ap)
                      ,9
                      ,nvl(ipn_fam_9, ipn_fam_1ap)
                      ,10
                      ,nvl(ipn_fam_10, ipn_fam_1ap)
                      ,11
                      ,nvl(ipn_fam_11, ipn_fam_1ap)
                      ,12
                      ,nvl(ipn_fam_12, ipn_fam_1ap))
           into d_ipn_fam
           from informazioni_extracontabili
          where ci = p_ci
            and anno = p_anno;
      exception
         when no_data_found then
            d_ipn_fam := null;
      end;
      return d_ipn_fam;
   end get_ipn_fam;
   --
   function get_riv_tfr_ap
   (
      p_ci   in number
     ,p_anno in number
   ) return number is
      d_riv_tfr_ap number := 0;
   begin
      begin
         select nvl(riv_tfr_ap, 0)
           into d_riv_tfr_ap
           from informazioni_extracontabili
          where ci = p_ci
            and anno = p_anno;
      exception
         when no_data_found then
            d_riv_tfr_ap := null;
      end;
      return d_riv_tfr_ap;
   end get_riv_tfr_ap;
   function get_esente_comu
   (
      p_ci   in number
     ,p_anno in number
   ) return varchar2 is
   begin
      initialize(p_ci, p_anno,'SI');
      return d_esente_comu;
   end get_esente_comu;
end gp4_inex;
/
