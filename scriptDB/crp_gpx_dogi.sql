CREATE OR REPLACE PACKAGE GPX_DOGI IS
/******************************************************************************
 NOME:        GPX_DOGI
 DESCRIZIONE: Controlli personalizzati Documenti Giuridici

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
     Il package prevede: controlli sui documenti con codice SCON (Servizi con Onere passati al procedura INPDAP Sonar)
				 - il campo dato_n2 che corrisponde ai mese non puo avere un valore superiore a 11
				 - il campo dato_a1 che corrisponde ai giorni non puo avere un valore superiore a 30

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  25/06/2004  ML
 1.1  11/10/2007  MS    Modifica procedure

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
  PROCEDURE CHK_SCON_DATO_N2(par_stringa number);
  PROCEDURE CHK_SCON_DATO_N3(par_stringa number);
END;
/
CREATE OR REPLACE PACKAGE BODY GPX_DOGI IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 11/10/2007';
END VERSIONE;

PROCEDURE CHK_SCON_DATO_N2 (par_stringa in number) IS
BEGIN
  if par_stringa > 11 then
     raise_application_error(-20999,'MESI: Valore non consentito');
  end if;
END;

PROCEDURE CHK_SCON_DATO_N3 (par_stringa in number) IS
BEGIN
  if par_stringa > 30 then
     raise_application_error(-20999,'GIORNI: Valore non consentito');
  end if;
END;

END;
/