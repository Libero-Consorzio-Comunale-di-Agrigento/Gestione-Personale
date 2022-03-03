CREATE OR REPLACE PACKAGE pecdcava IS
/******************************************************************************
 NOME:        PECDCAVA
 DESCRIZIONE: Rimozione delle registrazioni precalcolate per la fase di stampa
              delle ESTRAZIONI PARAMETRICHE.
              Una fase precedente ha inserito nella tavola di lavoro CALCOLO_VALORI le
              registrazioni estratte dalle viste generate in modo parametrico sui
              valori contabili della mensilita` richiesta.
              Un passo successivo produrra` la stampa della Estrazione Parametrica
              richiesta.
              La fase attuale si occupera` della eliminazione delle registrazioni
              inserite nella tavola CALCOLO_VALORI.
              
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
PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pecdcava IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (P_prenotazione in number,
	   			 	   passo in number) is
begin
delete from calcolo_valori
   where prenotazione = p_prenotazione;
   end;
   end;
/

