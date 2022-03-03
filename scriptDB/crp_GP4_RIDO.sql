CREATE OR REPLACE PACKAGE GP4_RIDO IS
/******************************************************************************
 NOME:        GP4_RIDO
 DESCRIZIONE: <Descrizione Package>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/08/2002 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE                         RETURN VARCHAR2;
   FUNCTION  GET_DATA  (p_utente in varchar2) RETURN DATE;
END GP4_RIDO;
/

CREATE OR REPLACE PACKAGE BODY GP4_RIDO AS

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
FUNCTION GET_DATA  (p_utente in varchar2) RETURN date IS
d_data date;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la  data di interrogazione di default sulla dotazione organica,
              per l'utente indicato
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
  begin
   select data
     into d_data
	 from riferimento_dotazione
	where utente = p_utente
   ;
  exception
    when no_data_found then
	   d_data := sysdate;
	when others then
	   d_data := to_date(null);
  end;
  return d_data;
END GET_DATA;
--
end gp4_rido;
/

