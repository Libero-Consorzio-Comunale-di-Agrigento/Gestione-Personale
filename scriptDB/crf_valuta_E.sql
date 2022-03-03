CREATE OR REPLACE FUNCTION VALUTA RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VALUTA
 DESCRIZIONE: Indica la valuta utilizzata 

 PARAMETRI:   

 RITORNA:     E = Euro, L = Lire 

 ECCEZIONI:   nnnnn, <Descrizione eccezione>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    18/05/2001 __     Prima emissione.
******************************************************************************/
BEGIN
   RETURN 'E';
END VALUTA;
/

