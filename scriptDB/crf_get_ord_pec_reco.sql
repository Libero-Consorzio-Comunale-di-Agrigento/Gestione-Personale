CREATE OR REPLACE FUNCTION GET_ORD_PEC_RECO
( p_domain       VARCHAR2
, p_codice       VARCHAR2
) RETURN VARCHAR2 IS
/******************************************************************************
 NOME:         GET_ORD_PEC_RECO
 DESCRIZIONE:  

 ANNOTAZIONI:  Sostituito dal crp_pec_reco.sql

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  14/12/2005 MS     Prima Emissione
 1.1  03/01/2006 MS     DISMESSO
******************************************************************************/
d_valore         VARCHAR2(10) ;
BEGIN
   d_valore := '';
/*
   select max(nvl(rtrim(lpad(reco.rv_abbreviation,2,' '))
                 ,nvl(rv_low_value,'9'))) ord 
     into d_valore 
     from pec_ref_codes reco 
    where reco.rv_domain = p_domain
      and reco.rv_low_value(+) = p_codice
   ;
   RETURN d_valore;
EXCEPTION
   WHEN no_data_found THEN d_valore := 0;
*/
   return d_valore;
null;
END GET_ORD_PEC_RECO;
/