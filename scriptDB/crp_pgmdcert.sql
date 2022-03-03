CREATE OR REPLACE PACKAGE PGMDCERT IS
PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY PGMDCERT IS
	   procedure main (p_prenotazione in number,
	   			 	   passo in number) is
	   begin
--
-- Cancella Appoggio Certificati
--
  delete from appoggio_certificati
   where prenotazione = p_prenotazione
;
--
-- Cancella Calcolo Nominativo Posti in Pianta
--
  delete from cert_long
   where prenotazione = p_prenotazione
;
COMMIT
;
end;
end;
/

