CREATE OR REPLACE package acacanrp is
/******************************************************************************
 NOME:        ACACANRP
 DESCRIZIONE: Cancellazione delle righe di segnalazione errore per le 
              procedure differite.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
end;
/

CREATE OR REPLACE package body acacanrp is
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN	(prenotazione  IN number,
		  		 PASSO 		   IN number) is
BEGIN
 DELETE FROM A_SEGNALAZIONI_ERRORE
  WHERE no_prenotazione = prenotazione
  ;
  commit;
END;
end;
/

