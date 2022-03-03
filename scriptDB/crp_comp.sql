-- WHEN ERROR IGNORE 24344,00000 
CREATE OR REPLACE PACKAGE COMPETENZA IS
   FUNCTION SE_VALORE ( P_oggetto    VARCHAR2
					  , P_competenza VARCHAR2 ) RETURN NUMBER;
   FUNCTION VALORE ( P_oggetto    VARCHAR2 ) RETURN VARCHAR2;
   FUNCTION  VERSIONE                        RETURN VARCHAR2;
/******************************************************************************
   NAME:       COMPETENZA
   PURPOSE:    To calculate the desired information.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002             1. Created this package.
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:
   CALLED BY:
   CALLS:
   EXAMPLE USE:     NUMBER := COMPETENZA.MyFuncName(Number);
                    COMPETENZA.MyProcName(Number, Varchar2);
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
   Here is the complete list of available Auto Replace Keywords:
      Object Name:     COMPETENZA or COMPETENZA
      Sysdate:         18/07/2002
      Date/Time:       18/07/2002 15.59.23
      Date:            18/07/2002
      Time:            15.59.23
      Username:         (set in TOAD Options, Procedure Editor)
******************************************************************************/
END Competenza;
/

CREATE OR REPLACE PACKAGE BODY Competenza AS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;
   FUNCTION SE_VALORE ( P_oggetto    VARCHAR2
 			    , P_competenza VARCHAR2 ) RETURN NUMBER IS
   valore NUMBER;
 
BEGIN
   valore := 0;
   SELECT 1
     INTO valore
	 FROM a_competenze
	WHERE utente     = Si4.utente
	  AND ENTE       = Si4.ENTE
	  AND ambiente   = Si4.ambiente
	  AND oggetto    = P_oggetto
	  AND Competenza = P_competenza;
   RETURN valore;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       valore := 0;
   RETURN valore;
     WHEN OTHERS THEN
       valore := 0;
   RETURN valore;
END SE_VALORE;
FUNCTION VALORE ( P_oggetto    VARCHAR2 ) RETURN VARCHAR2 IS
   valore VARCHAR2(20);
BEGIN
   valore := NULL;
   SELECT Competenza
     INTO valore
	 FROM a_competenze
	WHERE utente     = Si4.utente
	  AND ENTE       = Si4.ENTE
	  AND ambiente   = Si4.ambiente
	  AND oggetto    = P_oggetto;
   RETURN valore;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       valore := NULL;
   RETURN valore;
     WHEN OTHERS THEN
       valore := NULL;
   RETURN valore;
END VALORE;
END Competenza;
/

