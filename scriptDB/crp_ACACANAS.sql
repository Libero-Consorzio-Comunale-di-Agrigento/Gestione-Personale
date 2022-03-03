CREATE OR REPLACE PACKAGE ACACANAS IS
/******************************************************************************
 NOME:          ACACANAS
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 2	  28/06/2006 AD		Introdotta cancellazione per rowid per risolvere problema
 	  			 		BO14422
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
   PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
CREATE OR REPLACE PACKAGE BODY acacanas IS
/******************************************************************************
 NOME:          ACACANAS
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 2	  28/06/2006 AD		Introdotta cancellazione per rowid per risolvere problema
 	  			 		BO14422
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2 is
begin
	 return ('V1.1 del 28/06/2006');
end versione;	 


PROCEDURE Main ( prenotazione Number, passo Number ) is
    wambiente	  varchar2(8);
	freq_commit number:=5000;
	n number :=0;
begin

	 SELECT max(VALORE)
	   INTO wambiente
	   from a_parametri
	  where parametro = 'P_AMBIENTE'
	    and no_prenotazione = prenotazione
		;
	if wambiente is null then
	   FOR DATI IN (select rowid 
	   	   		   	  from a_appoggio_stampe
           		     where no_prenotazione = prenotazione
                  order by 1
				   ) LOOP
			   DELETE FROM A_APPOGGIO_STAMPE
	    	    where rowid = dati.rowid;
			   n:=n+1;	  
			   if n mod freq_commit = 0 then
			   	  COMMIT;
			   end if;	  
		END LOOP;
	else
	    FOR DATI IN (select aas.rowid 
			  		   from a_appoggio_stampe aas, a_prenotazioni ap
					  where ap.no_prenotazione = aas.no_prenotazione
						and ap.ambiente like wambiente
						order by 1
					) LOOP
			   DELETE FROM A_APPOGGIO_STAMPE
	    	    WHERE  rowid = dati.rowid;
			   n:=n+1;	  
			   if n mod freq_commit = 0 then
			   	  COMMIT;
			   end if;		END LOOP;
	end if;
COMMIT;
end;
END;
/


