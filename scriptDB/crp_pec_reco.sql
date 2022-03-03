CREATE OR REPLACE PACKAGE PEC_RECO IS
/******************************************************************************
 NOME:          PEC_RECO
 DESCRIZIONE:   Raggruppa una serie di funcion / procedure per la lettura dei
                ref_codes
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  29/12/2005 MS     Prima Emissione
 1.1  19/01/2006 MS     Aggiunta function per estrarre ordinamento
 1.2  19/06/2006 MS     Aggiunta function per controllo sui ref_codes
******************************************************************************/
FUNCTION VERSIONE      RETURN VARCHAR2;

FUNCTION GET_RV_MEANING
( p_domain       in  VARCHAR2 
, P_rv_low_value in  VARCHAR2
, P_lingua_utente  in  VARCHAR2
, P_lingua_dip     in  VARCHAR2
) RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(GET_RV_MEANING ,wnds,wnps);

FUNCTION GET_ORD_PEC_RECO 
( P_domain  in VARCHAR2  
, P_codice  in VARCHAR2 
) RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(GET_ORD_PEC_RECO ,wnds,wnps);

FUNCTION CHK_PEC_RECO 
( P_domain  in VARCHAR2
, P_codice  in VARCHAR2
) RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(CHK_PEC_RECO ,wnds,wnps);

END;
/

CREATE OR REPLACE PACKAGE BODY PEC_RECO IS

 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 29/12/2005';
 END VERSIONE;

 FUNCTION GET_RV_MEANING 
( p_domain       in  VARCHAR2 
, P_rv_low_value in  VARCHAR2
, P_lingua_utente  in  VARCHAR2
, P_lingua_dip     in  VARCHAR2
)  RETURN VARCHAR2 IS
 d_valore         VARCHAR2(240) ;
 BEGIN
   d_valore := '';
   BEGIN
   select decode( P_lingua_dip
                , grli1.gruppo_al, nvl(rv_meaning, nvl(rv_meaning_al1,rv_meaning_al2))
                , grli2.gruppo_al, nvl(rv_meaning_al1, nvl(rv_meaning,rv_meaning_al2))
                , grli3.gruppo_al, nvl(rv_meaning_al2, nvl(rv_meaning,rv_meaning_al1))
                                 , nvl(rv_meaning, nvl(rv_meaning_al1,rv_meaning_al2))
                )
     into d_valore 
     from ente
        , gruppi_linguistici grli1
        , gruppi_linguistici grli2
        , gruppi_linguistici grli3
        , pec_ref_codes reco 
    where ente.ente_id       = 'ENTE'
      and grli1.gruppo (+)    = decode( ente.ente_id||upper(P_lingua_utente)
                                       , 'ENTE*', 'I'
                                                , upper(P_lingua_utente)
                                      )
      and grli1.sequenza      = 1
      and grli2.gruppo (+)    = decode( ente.ente_id||upper(P_lingua_utente)
                                       , 'ENTE*', 'I'
                                                , upper(P_lingua_utente)
                                      )
      and grli2.sequenza      = 2
      and grli3.gruppo (+)    = decode( ente.ente_id||upper(P_lingua_utente)
                                       , 'ENTE*', 'I'
                                                , upper(P_lingua_utente)
                                      )
      and grli3.sequenza      = 3
      and reco.rv_domain = P_domain
      and reco.rv_low_value = P_rv_low_value
   ;
   EXCEPTION
    WHEN no_data_found THEN d_valore := null;
   END;
  return d_valore;
 END GET_RV_MEANING;

FUNCTION GET_ORD_PEC_RECO  ( p_domain   in  VARCHAR2 , p_codice in  VARCHAR2 )  RETURN VARCHAR2 IS
 d_valore         VARCHAR2(10) ;
 BEGIN
   d_valore := '';
   BEGIN
   select max(nvl(rtrim(lpad(reco.rv_abbreviation,2,' '))
                 ,nvl(rv_low_value,'9'))) ord 
     into d_valore 
     from pec_ref_codes reco 
    where reco.rv_domain = p_domain
      and reco.rv_low_value(+) = p_codice
   ;
   EXCEPTION
    WHEN no_data_found THEN d_valore := 0;
   END;
    return d_valore;
 END GET_ORD_PEC_RECO;

FUNCTION CHK_PEC_RECO  ( p_domain   in  VARCHAR2 , p_codice in  VARCHAR2 )  RETURN VARCHAR2 IS
 d_esiste   VARCHAR2(2) := '';
 BEGIN
   BEGIN
   select 'SI'
     into d_esiste
     from pec_ref_codes reco 
    where reco.rv_domain    = p_domain
      and reco.rv_low_value = p_codice
   ;
   EXCEPTION
    WHEN no_data_found THEN d_esiste := 'NO';
   END;
    return d_esiste;
 END CHK_PEC_RECO;

END PEC_RECO;
/

