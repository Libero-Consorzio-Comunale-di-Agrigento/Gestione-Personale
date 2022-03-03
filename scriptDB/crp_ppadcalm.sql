CREATE OR REPLACE PACKAGE ppadcalm IS
/******************************************************************************
 NOME:          PPADCALM
 DESCRIZIONE:   Eliminazione delle registrazioni calcolate nella fase PPACCALM.frm
                relative alla prenotazione in elaborazione.
                Questa funzione viene eseguita come passo successivo alla fase di
                emissione dell'elaborato che preleva le informazioni calcolate sui
                posti dalla fase PPACCALM.frm.

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

CREATE OR REPLACE PACKAGE BODY ppadcalm IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 22/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	delete from calcolo_liquidazione_malattie
   where calm_prenotazione = prenotazione
;
COMMIT;
end;
end;
/

