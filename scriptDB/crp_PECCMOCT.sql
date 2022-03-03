CREATE OR REPLACE PACKAGE PECCMOCT IS

/******************************************************************************
 NOME:          PECCMOCT
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
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER,PASSO IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PECCMOCT IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
	si4.sql_execute('truncate table calcoli_contabili_dep');
end;
end;
/