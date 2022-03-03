CREATE OR REPLACE PACKAGE peccepre IS
/******************************************************************************
 NOME:        PECCEPRE
 DESCRIZIONE: Controllo della elaborabilita` del report richiesto, con la fase SEPRE
              (solo dati numerici).
              Questa funzione emette una segnalazione di errore nel caso in cui
              il report richiesto preveda dati alfabetici.
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
 1.1  21/02/2007			 
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccepre IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 21/02/2007';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
DECLARE
  D_estrazione VARCHAR2(20);
  D_x          VARCHAR2(1);
  D_errore     VARCHAR2(6) := '';
BEGIN
  BEGIN  -- Estrazione richiesta
    select rtrim(substr(valore,1,20),' ')
      into D_estrazione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro = 'P_ESTRAZIONE'
    ;
  END;
  BEGIN  -- Controllo di Esistenza dell'Estrazione richiesta
    select 'x'
      into D_x
      from estrazione_report
     where nvl(sequenza,999) != 999
       and estrazione = D_estrazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_errore := 'P05870';
         RAISE NO_DATA_FOUND;
  END;
  BEGIN  -- Controllo di Compatibilita` dell'Estrazione richiesta
    select 'x'
      into D_x
      from relazione_attr_estrazione
     where estrazione = D_estrazione
       and alias not in ( 'CI', 'ANNO', 'MESE','MENSILITA'
                        , 'COL1', 'COL2', 'COL3', 'COL4', 'COL5'
                        , 'COL6', 'COL7', 'COL8', 'COL9', 'COL10'
                        , 'COL11', 'COL12', 'COL13', 'COL14'
                        )
    ;
    RAISE TOO_MANY_ROWS;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
         D_errore := 'P05874';
         RAISE NO_DATA_FOUND;
    WHEN NO_DATA_FOUND THEN
         null;
  END;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    update a_prenotazioni 
       set errore = D_errore||decode(D_errore,'P05870',' (','')
                            ||nvl(D_estrazione,'...')
                            ||decode(D_errore,'P05870',')','')
         , prossimo_passo = 99
     where no_prenotazione = prenotazione
    ;
    COMMIT;
END;
end;
end;
/

