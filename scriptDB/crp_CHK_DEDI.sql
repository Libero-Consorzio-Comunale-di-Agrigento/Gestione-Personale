CREATE OR REPLACE PACKAGE CHK_DEDI IS
/******************************************************************************
 NOME:
 DESCRIZIONE: Gestisce le stampe da lanciare in base al parametro scelto
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    16/10/2006 GM
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN  (prenotazione in number,passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY CHK_DEDI IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 16/12/2006';
 END VERSIONE;
 
PROCEDURE MAIN (prenotazione  IN number,passo in number) IS
D_modello varchar2(4);
BEGIN
  BEGIN
    select valore
      into D_modello
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_MODELLO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       null;
  END;
  BEGIN
    if passo = 1 and D_modello = 'SR18' then
      update a_prenotazioni 
	     set prossimo_passo  = 4
       where no_prenotazione = prenotazione
      ;
	elsif passo = 3 and D_modello = 'DS22' then
	  update a_prenotazioni 
	     set prossimo_passo  = 99
       where no_prenotazione = prenotazione
      ;
	  end if;  
    commit;
  END;
END;
END;
/
