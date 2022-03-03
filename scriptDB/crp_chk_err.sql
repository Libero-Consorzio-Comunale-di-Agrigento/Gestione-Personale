CREATE OR REPLACE PACKAGE CHK_ERR IS
/******************************************************************************
 NOME:          
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY CHK_ERR IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE MAIN	(prenotazione  IN number,passo in number) IS
BEGIN
 update a_prenotazioni set prossimo_passo  = 91
                        , errore          = 'P05808'
 where no_prenotazione = prenotazione
   and exists
      (select 'x' from a_segnalazioni_errore
        where no_prenotazione = prenotazione
      )
;
  commit;
END;
END;
/