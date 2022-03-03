CREATE OR REPLACE PACKAGE pgmaapea IS
/******************************************************************************
 NOME:          PGMAAPEA
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 1.1  03/07/2006 CB     Modifica campo evento - attività 14612
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY pgmaapea IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.1 del 03/07/2006';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number)IS
 BEGIN

DECLARE

  D_dummy    varchar2(4);
  P_assenza  varchar2(4);
  P_evento   varchar2(6);
  Uscita     exception;
  D_prs      number;

BEGIN
  BEGIN -- Estrazione Parametri di Selezione della Prenotazione
      select valore
        into P_assenza
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ASSENZA'
      ;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN P_assenza := '%';
  END;
  BEGIN
      select valore
        into P_evento
        from a_parametri
       where no_prenotazione =  prenotazione
         and parametro       = 'P_EVENTO'
      ;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN P_evento := '%';
  END;
    
  BEGIN
    select 'x'
      into D_dummy
      from eventi_giuridici
     where codice like P_evento
     and rilevanza = 'A';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	
	    insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                     ,errore,precisazione)
        values (prenotazione,1,1,'P04180','');
	     
         update a_prenotazioni
            set errore = 'P04180'
			 , PROSSIMO_PASSO = 91
          where no_prenotazione =  prenotazione;
         commit;
         RAISE USCITA;
    WHEN TOO_MANY_ROWS THEN null;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from astensioni
     where codice like P_assenza;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	    insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                     ,errore,precisazione)
        values (prenotazione,1,1,'P07060','');
         update a_prenotazioni
            set errore = 'P07060'
			    , PROSSIMO_PASSO = 91
          where no_prenotazione =  prenotazione;
         commit;
         RAISE USCITA;
    WHEN TOO_MANY_ROWS THEN null;
  END;
  BEGIN
    update astensioni
       set evento = P_evento
     where codice = P_assenza
    ;
  END;
  BEGIN
    update periodi_giuridici pegi
       set pegi.evento = P_evento
     where pegi.rilevanza = 'A'
       and pegi.assenza   = P_assenza;
  END;
EXCEPTION
  WHEN USCITA THEN null;
END;
END;
END;
/

