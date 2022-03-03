CREATE OR REPLACE PACKAGE PAMXRAPP IS

/******************************************************************************
 NOME:          PAMARAPP
 DESCRIZIONE:   Riapertura rapporti_individuali

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  27/12/2004 MS     Prima Emissione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PAMXRAPP IS

FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
  RETURN 'V1.0 del 27/12/2004';
 END VERSIONE;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
 DECLARE
  D_anno    VARCHAR(4);
 BEGIN
  BEGIN
    SELECT valore
      INTO D_anno
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN D_anno := 1900;
  END;
   BEGIN
   update rapporti_individuali
      set al = ''
    where al = to_date ('3112'||D_anno-1,'ddmmyyyy');
   commit;
   END;
  END;
 END;
END;
/
