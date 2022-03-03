CREATE OR REPLACE PACKAGE Gp4_Prfi IS
/******************************************************************************
 NOME:        GP4_PRFI
 DESCRIZIONE: <Descrizione Package>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/08/02 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE                RETURN VARCHAR2;
   FUNCTION  ANNI_TOT  ( P_CI IN  NUMBER
                       , P_ANNO IN NUMBER
				       , P_MESE IN NUMBER
					   , P_MENSILITA IN VARCHAR2)            RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES(anni_tot,wnds);
   FUNCTION  MESI_TOT  ( P_CI IN  NUMBER
                       , P_ANNO IN NUMBER
				       , P_MESE IN NUMBER
					   , P_MENSILITA IN VARCHAR2)            RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES(mesi_tot,wnds);
   FUNCTION  GG_TOT    ( P_CI IN  NUMBER
                       , P_ANNO IN NUMBER
				       , P_MESE IN NUMBER
					   , P_MENSILITA IN VARCHAR2)            RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES(gg_tot,wnds);
   PROCEDURE ANZIANITA ( P_CI IN  NUMBER
                       , P_ANNO IN NUMBER
				       , P_MESE IN NUMBER
					   , P_MENSILITA IN VARCHAR2
					   , P_MESI_TOT OUT NUMBER
					   , P_ANNI_TOT OUT NUMBER
                       );
   PRAGMA RESTRICT_REFERENCES(anzianita,wnds);
END Gp4_Prfi;
/

CREATE OR REPLACE PACKAGE BODY Gp4_Prfi AS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 29/08/2002';
END VERSIONE;
FUNCTION ANNI_TOT  ( P_CI IN  NUMBER
                   , P_ANNO IN NUMBER
				   , P_MESE IN NUMBER
				   , P_MENSILITA IN VARCHAR2) RETURN NUMBER IS
/******************************************************************************
 NOME:        ANNI_TOT
 DESCRIZIONE: Restituisce il numero di anni di anzianita totale
 PARAMETRI:   Chiede in input il codice individuale, l'anno, il mese e la mensilita
              a cui calcolare l'anzianita
 RITORNA:
 NOTE:
******************************************************************************/
d_anni NUMBER;
BEGIN
  BEGIN
  SELECT TRUNC(trunc(( NVL(SUM(prfi.gg_anz_t),0)+NVL(MAX(prfi.gg_anz_c),0))/30)
                                    /12)                              anni_tot
	INTO d_anni
    FROM progressivi_fiscali prfi
   WHERE PRFI.ci = P_CI
     AND PRFI.anno = P_ANNO
     AND PRFI.mese = P_MESE
     AND PRFI.MENSILITA = P_MENSILITA;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  	  d_anni := TO_NUMBER(NULL);
		  RETURN d_anni;
	WHEN TOO_MANY_ROWS THEN
		  d_anni := TO_NUMBER(NULL);
	      RETURN d_anni;
   END;
RETURN d_anni;
END ANNI_TOT;
FUNCTION MESI_TOT  ( P_CI IN  NUMBER
                   , P_ANNO IN NUMBER
				   , P_MESE IN NUMBER
				   , P_MENSILITA IN VARCHAR2) RETURN NUMBER IS
/******************************************************************************
 NOME:        MESI_TOT
 DESCRIZIONE: Restituisce il numero di mesi di anzianita totale
 PARAMETRI:   Chiede in input il codice individuale, l'anno, il mese e la mensilita
              a cui calcolare l'anzianita
 RITORNA:
 NOTE:
******************************************************************************/
d_mesi NUMBER;
BEGIN
  BEGIN
  SELECT GREATEST(0,TRUNC((( NVL(SUM(prfi.gg_anz_t),0)
                             +NVL(MAX(prfi.gg_anz_c),0)
                            )-TRUNC(TRUNC(( NVL(SUM(prfi.gg_anz_t),0)
                                           +NVL(MAX(prfi.gg_anz_c),0)
										   )
                                         /30)
                                    /12)*360)
                           /30)
                  )        mesi_tot
	INTO d_mesi
    FROM progressivi_fiscali prfi
   WHERE PRFI.ci = P_CI
     AND PRFI.anno = P_ANNO
     AND PRFI.mese = P_MESE
     AND PRFI.MENSILITA = P_MENSILITA;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  	  d_mesi := TO_NUMBER(NULL);
		  RETURN d_mesi;
	WHEN TOO_MANY_ROWS THEN
		  d_mesi := TO_NUMBER(NULL);
	      RETURN d_mesi;
   END;
RETURN d_mesi;
END MESI_TOT;
FUNCTION GG_TOT    ( P_CI IN  NUMBER
                   , P_ANNO IN NUMBER
				   , P_MESE IN NUMBER
				   , P_MENSILITA IN VARCHAR2) RETURN NUMBER IS
/******************************************************************************
 NOME:        MESI_TOT
 DESCRIZIONE: Restituisce il numero di mesi di anzianita totale
 PARAMETRI:   Chiede in input il codice individuale, l'anno, il mese e la mensilita
              a cui calcolare l'anzianita
 RITORNA:
 NOTE:
******************************************************************************/
d_gg NUMBER;
BEGIN
  BEGIN
  SELECT (  NVL(SUM(prfi.gg_anz_t),0)
               + NVL(MAX(prfi.gg_anz_c),0))
		    -(TRUNC(TRUNC(( NVL(SUM(prfi.gg_anz_t),0)+NVL(MAX(prfi.gg_anz_c),0))/30)
                                    /12))*30*12
			-(GREATEST(0,TRUNC((( NVL(SUM(prfi.gg_anz_t),0)
                             +NVL(MAX(prfi.gg_anz_c),0)
                            )-TRUNC(TRUNC(( NVL(SUM(prfi.gg_anz_t),0)
                                           +NVL(MAX(prfi.gg_anz_c),0)
										   )
                                         /30)
                                    /12)*360)
                           /30)
                  )*30)
	INTO d_gg
    FROM progressivi_fiscali prfi
   WHERE PRFI.ci = P_CI
     AND PRFI.anno = P_ANNO
     AND PRFI.mese = P_MESE
     AND PRFI.MENSILITA = P_MENSILITA;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  	  d_gg := TO_NUMBER(NULL);
		  RETURN d_gg;
	WHEN TOO_MANY_ROWS THEN
		  d_gg := TO_NUMBER(NULL);
	      RETURN d_gg;
   END;
RETURN d_gg;
END GG_TOT;
PROCEDURE ANZIANITA
/******************************************************************************
 NOME:        ANZIANITA
 DESCRIZIONE: Restituisce il numero di anni e mesi di anzianita totale
 ARGOMENTI:   P_anno       IN     NUMBER   Anno di elaborazione
              P_mese       IN     NUMBER   Mese di elaborazione
			  P_mensilita  IN     VARCHAR2 Mensilita di elaborazione
			  P_ci         IN     NUMBER   Codice Individuale richiesto
			  P_anni_tot  OUT     NUMBER   Numero di anni di anzianita totale
			  P_mesi_tot  OUT     NUMBER   Numero di mesi di anzianita totale
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/08/02 __     Prima emissione.
******************************************************************************/
( P_CI IN  NUMBER
                     , P_ANNO IN NUMBER
					 , P_MESE IN NUMBER
					 , P_MENSILITA IN VARCHAR2
					 , P_MESI_TOT OUT NUMBER
					 , P_ANNI_TOT OUT NUMBER
) IS
BEGIN
SELECT TRUNC(ROUND(( NVL(SUM(prfi.gg_anz_t),0)+NVL(MAX(prfi.gg_anz_c),0))/30)
                                    /12)                              anni_tot
                         , GREATEST(0,(ROUND(( NVL(SUM(prfi.gg_anz_t),0)+NVL(MAX(prfi.gg_anz_c),0)
                                       )-TRUNC(ROUND((NVL(MAX(prfi.gg_anz_c),0))
                                                    /30)
                                               /12)*360
                                     )/30)
                              )                                      mesi_tot
INTO P_anni_tot, P_mesi_tot
FROM progressivi_fiscali prfi
WHERE PRFI.ci = P_CI
AND PRFI.anno = P_ANNO
AND PRFI.mese = P_MESE
AND PRFI.MENSILITA = P_MENSILITA;
EXCEPTION
   WHEN NO_DATA_FOUND THEN P_mesi_tot := 0;
                           P_anni_tot := 0;
        RAISE;
END ANZIANITA;
END Gp4_Prfi;
/* End Package Body: GP4_PRFI */
/

