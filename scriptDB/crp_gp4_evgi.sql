CREATE OR REPLACE PACKAGE GP4_EVGI IS
/******************************************************************************
 NOME:        GP4_EVGI
 DESCRIZIONE: Funzioni su EVENTI_GIURIDICI

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/08/2002 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE          RETURN VARCHAR2;
             PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
   FUNCTION  GET_DESCRIZIONE  ( p_evento in varchar2) RETURN varchar2;
             PRAGMA RESTRICT_REFERENCES(GET_DESCRIZIONE,wnds,wnps);
END GP4_EVGI;
/
CREATE OR REPLACE PACKAGE BODY GP4_EVGI AS

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 24/07/2002';
END VERSIONE;

--
FUNCTION GET_DESCRIZIONE  ( p_evento in varchar2) RETURN varchar2 IS
d_descrizione eventi_giuridici.descrizione%type;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la descrizione dell'evento giuridico dato
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
BEGIN
  begin
   select descrizione
     into d_descrizione
	 from eventi_giuridici
	where codice = p_evento
   ;
  exception
    when no_data_found then
	   d_descrizione := to_char(null);
	when others then
	   d_descrizione := to_char(null);
  end;
  return d_descrizione;
END GET_DESCRIZIONE;
--



END GP4_EVGI;
/
