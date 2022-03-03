CREATE OR REPLACE PACKAGE PDODMODO IS
/******************************************************************************
 NOME:        PDOCMODO
 DESCRIZIONE: Elimina le registrazioni fittizie delle date di inizio e fine su
              RIFERIMENTO_DOTAZIONE
              inserite da PDOCMODO per il report SMODO

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/10/2002 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE              RETURN varchar2;
   PROCEDURE MAIN  (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END PDODMODO;
/

CREATE OR REPLACE PACKAGE BODY PDODMODO AS

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
   RETURN 'V1.0 del 02/10/2002';
END VERSIONE;
--
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
/******************************************************************************
 NOME:        MAIN
 DESCRIZIONE: elimina da RIFERIMENTO_DOTAZIONE le due registrazioni per utenti fittizi
              con codice dipendente dalla prenotazione inserite al passo 1 da PDOCMODO
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/10/2002 __     Prima emissione.
******************************************************************************/
   d_data1 date;
   d_data2 date;
   d_utente1 riferimento_dotazione.utente%type;
   d_utente2 riferimento_dotazione.utente%type;
BEGIN
  d_utente1 := 'P1'||prenotazione;
  d_utente2 := 'P2'||prenotazione;
  delete from riferimento_dotazione
  where utente = d_utente1;
  delete from riferimento_dotazione
  where utente = d_utente2;
END MAIN;

END PDODMODO;
/* End Package Body: PDODMODO */
/

