CREATE OR REPLACE PACKAGE ppadcapa IS
/******************************************************************************
 NOME:          PPADCAPA
 DESCRIZIONE:   Eliminazione delle registrazioni calcolate nella fase PPACCAPA.frm
                relative alla prenotazione in elaborazione.
                Questa funzione viene eseguita come passo successivo alla fase di
                emissione dell'elaborato che preleva le informazioni calcolate su-
                gli eventi dalla fase PPACCAPA.frm.

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
PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY ppadcapa IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 22/01/2003';
END VERSIONE;
procedure main (p_prenotazione in number,
	   			 	   passo in number) is
	begin
	 delete from calcolo_prospetti_presenza
   where prenotazione = p_prenotazione
;
COMMIT
;
end;
end;
/

