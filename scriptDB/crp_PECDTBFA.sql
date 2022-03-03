CREATE OR REPLACE PACKAGE PECDTBFA IS
/******************************************************************************
 NOME:          PECDTBFA
 DESCRIZIONE:   Pulisce la tabella TAB_REPORT_FINE_ANNO
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    08/02/2005 GM     Prima Emissione
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
   PROCEDURE Main (prenotazione IN NUMBER, passo IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PECDTBFA IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 08/02/2005';
 END VERSIONE;
   PROCEDURE Main (prenotazione IN NUMBER, passo IN NUMBER) is
BEGIN
LOCK TABLE TAB_REPORT_FINE_ANNO IN EXCLUSIVE MODE NOWAIT;
cursore_fiscale.PULISCI_TAB_REPORT_FINE_ANNO;
COMMIT;
END;
END;
/





