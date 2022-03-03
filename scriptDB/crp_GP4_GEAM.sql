CREATE OR REPLACE PACKAGE GP4_GEAM IS
/******************************************************************************
 NOME:        GP4_GEAM
 DESCRIZIONE: Funzioni sulla tabella GESTIONI_AMMINISTRATIVE
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    22/08/2002 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE                                RETURN VARCHAR2;
   FUNCTION  GET_DENOMINAZIONE  (p_codice in varchar2) RETURN varchar2;
   FUNCTION  GET_GESTITO        (p_codice in varchar2) RETURN varchar2;
             PRAGMA RESTRICT_REFERENCES(GET_GESTITO,wnds,wnps);
END GP4_GEAM;
/
CREATE OR REPLACE PACKAGE BODY GP4_GEAM AS
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
   RETURN 'V1.0 del 22/08/2002';
END VERSIONE;
--
FUNCTION GET_DENOMINAZIONE  (p_codice in varchar2) RETURN varchar2 IS
d_DENOMINAZIONE gestioni_amministrative.DENOMINAZIONE%type;
/******************************************************************************
 NOME:        GET_DENOMINAZIONE
 DESCRIZIONE: Restituisce la denominazione della gestione amministrativa dato
              il codice
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_DENOMINAZIONE := to_char(null);
  begin
   select denominazione
     into d_DENOMINAZIONE
    from gestioni_amministrative
   where codice = p_codice
   ;
  exception
    when no_data_found then
      d_DENOMINAZIONE := to_char(null);
  end;
  return d_DENOMINAZIONE;
END GET_DENOMINAZIONE;
--
FUNCTION GET_GESTITO  (p_codice in varchar2) RETURN varchar2 IS
d_GESTITO gestioni_amministrative.GESTITO%type;
/******************************************************************************
 NOME:        GET_GESTITO
 DESCRIZIONE: Indica se la gestione e interna oppure no
              il codice
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_GESTITO := to_char(null);
  begin
   select GESTITO
     into d_GESTITO
    from gestioni_amministrative
   where codice = p_codice
   ;
  exception
    when no_data_found then
      d_GESTITO := to_char(null);
  end;
  return d_GESTITO;
END GET_GESTITO;
--
END GP4_GEAM;
/* End Package Body: GP4_GEAM */
/
