CREATE OR REPLACE PACKAGE CHK_APST IS
/******************************************************************************
 NOME:          
 DESCRIZIONE: salta al passo 81 se esistono record in a_appoggio_stampe
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/12/2003 MS            
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY CHK_APST IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 30/12/2003';
 END VERSIONE;
PROCEDURE MAIN	(prenotazione  IN number,passo in number) IS
BEGIN
 update a_prenotazioni set prossimo_passo  = 81
                        , errore          = 'P05808'
 where no_prenotazione = prenotazione
   and exists
      (select 'x' from a_appoggio_stampe
        where no_prenotazione = prenotazione
      )
;
  commit;
END;
END;
/