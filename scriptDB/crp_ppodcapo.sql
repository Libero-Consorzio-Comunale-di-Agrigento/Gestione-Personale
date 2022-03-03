CREATE OR REPLACE PACKAGE ppodcapo IS
/******************************************************************************
 NOME:          PPODCAPO
 DESCRIZIONE:   Eliminazione delle registrazioni calcolate
                relative alla prenotazione in elaborazione.
                Questa funzione viene eseguita come passo successivo alla fase di
                emissione dell'elaborato che preleva le informazioni calcolate sui
                posti.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    22/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY ppodcapo IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 22/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	--
-- Cancella Calcolo Posti in Pianta
--
  delete from calcolo_posti
   where capo_prenotazione = prenotazione
;
--
-- Cancella Calcolo Nominativo Posti in Pianta
--
  delete from calcolo_Nominativo_posti
   where cnpo_prenotazione = prenotazione
;
COMMIT
;
end;
end;
/

