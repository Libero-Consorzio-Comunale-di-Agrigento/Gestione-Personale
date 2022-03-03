CREATE OR REPLACE PACKAGE PDOCMODO IS
/******************************************************************************
 NOME:        PDOCMODO
 DESCRIZIONE: Inserimento fittizio delle date di inizio e fine su RIFERIMENTO_DOTAZIONE

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    01/10/2002 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE              RETURN varchar2;
   PROCEDURE MAIN  (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END PDOCMODO;
/

CREATE OR REPLACE PACKAGE BODY PDOCMODO AS

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 01/10/2002';
END VERSIONE;
--
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
/******************************************************************************
 NOME:        MAIN
 DESCRIZIONE: Inserisce su RIFERIMENTO_DOTAZIONE due registrazioni per utenti fittizi
              con codice fisso, in modo da poter utilizzare le viste delle DO nel report
			  PDOSMODO
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    01/10/2002 __     Prima emissione.
******************************************************************************/
   d_data1 date;
   d_data2 date;
   d_utente1 riferimento_dotazione.utente%type;
   d_utente2 riferimento_dotazione.utente%type;
BEGIN
  BEGIN
    select to_date(substr(valore,1,10),'dd/mm/yyyy')
      into d_data1
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_DATA_INIZIO'
    ;
	exception
      when no_data_found then
          d_data1 := sysdate;
   END;
   BEGIN		  
    select to_date(substr(valore,1,10),'dd/mm/yyyy')
      into d_data2
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_DATA_FINE'
    ;
   exception
      when no_data_found then
          d_data2 := sysdate;
   END;
  d_utente1 := 'P1'||prenotazione;
  d_utente2 := 'P2'||prenotazione;
  insert into riferimento_dotazione
  values (d_data1,d_utente1);
  insert into riferimento_dotazione
  values (d_data2,d_utente2);
END MAIN;

END PDOCMODO;
/* End Package Body: PDOCMODO */
/

