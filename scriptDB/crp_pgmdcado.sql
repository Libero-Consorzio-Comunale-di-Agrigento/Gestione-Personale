CREATE OR REPLACE PACKAGE pgmdcado IS
/******************************************************************************
 NOME:          PGMDCADO
 DESCRIZIONE:   Eliminazione delle registrazioni calcolate
                relative alla prenotazione in elaborazione.
                Questa funzione viene eseguita come passo successivo alla fase di
                emissione dell'elaborato che preleva le informazioni calcolate
                sulla dotazione
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE  MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pgmdcado IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 21/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	delete from calcolo_dotazione
   where cado_prenotazione = prenotazione;
--
-- Cancella Calcolo Nominativo Dotazione del Personale
--
  delete from calcolo_nominativo_dotazione
   where cndo_prenotazione = prenotazione;
COMMIT
;
end;
end;
/

