CREATE OR REPLACE PACKAGE PECCT730 IS
/******************************************************************************
 NOME:        PECCT730
 DESCRIZIONE: VERIFICA ESISTENZA TABELLA COM730.
              In caso di errore viene provocato SQLERROR.
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PECCT730 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
si4.sql_execute('truncate table com730');
end;
end;
/

