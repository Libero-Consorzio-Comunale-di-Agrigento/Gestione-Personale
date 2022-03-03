CREATE OR REPLACE PACKAGE pecuragi IS
/******************************************************************************
 NOME:          PECURAGI
 DESCRIZIONE:   Aggiornamento FLAG_ELAB di RAPPORTI_GIURIDICI da condizione
                Elaborati ('E') a condizione Conclusi ('C').
                Questa step viene lanciato come secondo passo dopo la fase PECSMORE.rep
                che elabora la stampa di tutti i cedolini elaborati e non ancora stampati
                dalla fase in oggetto, per cui ancora con FLAG_ELAB = 'E'.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003  
 1.1  10/04/2007      CB Aggiunto il controllo sul codice di competenza di RAIN            

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/
CREATE OR REPLACE PACKAGE BODY pecuragi IS
  w_utente	        varchar2(10);
  w_ambiente	    varchar2(10);
  w_ente	        varchar2(10);
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 10/04/2007';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
IF prenotazione != 0 THEN
      BEGIN  --Preleva utente da depositare in campi Global
         select utente
              , ambiente
              , ente
           into w_utente
              , w_ambiente
              , w_ente
           from a_prenotazioni
          where no_prenotazione = prenotazione
         ;
      EXCEPTION
         WHEN OTHERS THEN null;
      END;
END IF;
 update rapporti_giuridici set flag_elab = 'C'
   where flag_elab = 'E'
   and   ci in (select rain.ci 
                     from   rapporti_individuali rain
					 where    rain.cc is null
					 or exists
					    (select 'x'
						 from   a_competenze
						 where  ente = w_ente
						 and    utente = w_utente
						 and    ambiente = w_ambiente
						 and    competenza='CI'
						 and    oggetto  = rain.cc
						 ) 
					 )
   			 
;
COMMIT;
end;
end;
/

