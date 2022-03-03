CREATE OR REPLACE PACKAGE GP4_CACO IS
/******************************************************************************
 NOME:        GP4_CACO
 DESCRIZIONE: Operazioni su CALCOLI_CONTABILI

 ANNOTAZIONI: Versione V1.0

 REVISIONI:   MarcoFa - lunedì 3 gennaio 2005 17.59.17
 Rev.  Data        Autore  Descrizione
 ----  ----------  ------  ----------------------------------------------------
 0     __/__/____  __      Creazione.
******************************************************************************/

revisione varchar2(30) := 'V1.0';

Function  VERSIONE
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.

 RITORNA:     stringa VARCHAR2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione 
              del package.
******************************************************************************/
RETURN VARCHAR2;
Pragma restrict_references(VERSIONE, WNDS, WNPS);

Function get_imp
/******************************************************************************
 NOME:        get_imp
 DESCRIZIONE: Estrae valore generato nel mese di elaborazione per la Voce indicata.
******************************************************************************/
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null)
RETURN NUMBER;
Pragma restrict_references(get_imp, WNDS, WNPS);

Function get_imp_mp
/******************************************************************************
 NOME:        get_imp_mp
 DESCRIZIONE: Estrae il valore già emesso mei movimenti mensili dei mesi precedenti pe la Voce indicata.
******************************************************************************/
( P_ci IN NUMBER
, P_anno IN NUMBER
, P_mese IN NUMBER
, P_mensilita IN VARCHAR2
, P_voce IN VARCHAR2
, P_arr IN VARCHAR2 DEFAULT null
, P_sub IN VARCHAR2 DEFAULT null)
RETURN NUMBER;
Pragma restrict_references(get_imp_mp, WNDS, WNPS);

Procedure set_input
( P_input IN VARCHAR2);

Procedure set_estrazione
( P_estrazione IN VARCHAR2);

Procedure insert_voce
/******************************************************************************
 NOME:        insert_voce
 DESCRIZIONE: Inserisce in Calcoli Contabili la voce indicata con solo IMPORTO
******************************************************************************/
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2
, P_riferimento IN DATE
, P_tar IN NUMBER
, P_qta IN NUMBER
, P_imp IN NUMBER
, P_input IN VARCHAR2 DEFAULT null
, P_estrazione IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null);

Procedure insert_voce
/******************************************************************************
 NOME:        insert_voce
 DESCRIZIONE: Inserisce in Calcoli Contabili la voce indicata con solo IMPORTO
******************************************************************************/
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2
, P_riferimento IN DATE
, P_imp IN NUMBER
, P_input IN VARCHAR2 DEFAULT null
, P_estrazione IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null);

Procedure insert_voce
/******************************************************************************
 NOME:        insert_voce
 DESCRIZIONE: Inserisce in Calcoli Contabili la voce indicata con solo IMPORTO
******************************************************************************/
( P_ci IN NUMBER
, P_automatismo IN VARCHAR2
, P_riferimento IN DATE
, P_tar IN NUMBER
, P_qta IN NUMBER
, P_imp IN NUMBER
, P_input IN VARCHAR2 DEFAULT null
, P_estrazione IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null);

Function exists_voce
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2
, P_arr IN VARCHAR2 DEFAULT null)
RETURN BOOLEAN;
Pragma restrict_references(exists_voce, WNDS);

END GP4_CACO;
/

CREATE OR REPLACE PACKAGE BODY GP4_CACO IS
D_default_input   VARCHAR2(1);
D_default_estrazione   VARCHAR2(2);

Function  VERSIONE
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.

 RITORNA:     stringa VARCHAR2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione 
              del package.
******************************************************************************/
RETURN VARCHAR2
IS
BEGIN
   RETURN revisione;
END VERSIONE;

Function get_imp
/******************************************************************************
 NOME:        get_imp
 DESCRIZIONE: Estrae valore generato nel mese di elaborazione per la Voce indicata.
******************************************************************************/
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null)
RETURN NUMBER
IS
D_imp NUMBER;
BEGIN
   SELECT NVL(SUM(imp),0)
     INTO D_imp
     FROM CALCOLI_CONTABILI
    WHERE ci              = P_ci
      AND voce         like P_voce
      AND nvl(sub,' ') like nvl(P_sub, nvl(sub,' '))
      AND nvl(arr,' ') like nvl(P_arr, nvl(arr,' '))
   ;
   
   RETURN D_imp;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 0;
END get_imp;

Function get_imp_mp
/******************************************************************************
 NOME:        get_imp_mp
 DESCRIZIONE: Estrae il valore già emesso mei movimenti mensili dei mesi precedenti pe la Voce indicata.
******************************************************************************/
( P_ci IN NUMBER
, P_anno IN NUMBER
, P_mese IN NUMBER
, P_mensilita IN VARCHAR2
, P_voce IN VARCHAR2
, P_arr IN VARCHAR2 DEFAULT null
, P_sub IN VARCHAR2 DEFAULT null)
RETURN NUMBER
IS
D_imp_mp NUMBER;
BEGIN
   SELECT NVL(SUM(p_imp),0)
     INTO D_imp_mp
     FROM progressivi_contabili
    WHERE ci              = P_ci
      AND anno            = P_anno
      AND mese            = P_mese
      AND mensilita       = P_mensilita
      AND voce         like P_voce
      AND nvl(sub,' ') like nvl(P_sub, nvl(sub,' '))
      AND nvl(arr,' ') like nvl(P_arr, nvl(arr,' '))
   ;
   
   RETURN D_imp_mp;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 0;
END get_imp_mp;

Procedure set_input
( P_input IN VARCHAR2)
IS
BEGIN
   D_default_input := P_input;
END set_input;

Procedure set_estrazione
( P_estrazione IN VARCHAR2)
IS
BEGIN
   D_default_estrazione := P_estrazione;
END set_estrazione;

Procedure insert_voce
/******************************************************************************
 NOME:        insert_voce
 DESCRIZIONE: Inserisce in Calcoli Contabili la voce indicata con solo IMPORTO
******************************************************************************/
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2
, P_riferimento IN DATE
, P_tar IN NUMBER
, P_qta IN NUMBER
, P_imp IN NUMBER
, P_input IN VARCHAR2 DEFAULT null
, P_estrazione IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null)
IS
BEGIN
   INSERT INTO CALCOLI_CONTABILI
         ( ci
         , voce
         , sub
         , riferimento
         , input
         , estrazione
         , arr
         , tar
         , qta
         , imp
         )
   VALUES( P_ci
         , P_voce
         , nvl(P_sub,'*')
         , P_riferimento
         , nvl(P_input, D_default_input)
         , nvl(P_estrazione, D_default_estrazione)
         , P_arr
         , P_tar
         , P_qta
         , P_imp
         )
   ;
   
END insert_voce;

Procedure insert_voce
/******************************************************************************
 NOME:        insert_voce
 DESCRIZIONE: Inserisce in Calcoli Contabili la voce indicata con solo IMPORTO
******************************************************************************/
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2
, P_riferimento IN DATE
, P_imp IN NUMBER
, P_input IN VARCHAR2 DEFAULT null
, P_estrazione IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null)
IS
BEGIN
   insert_voce
         ( P_ci
         , P_voce
         , P_sub
         , P_riferimento
         , null
         , null
         , P_imp
         , P_input
         , P_estrazione
         , P_arr
         )
   ;
   
END insert_voce;

Procedure insert_voce
/******************************************************************************
 NOME:        insert_voce
 DESCRIZIONE: Inserisce in Calcoli Contabili la voce indicata con solo IMPORTO
******************************************************************************/
( P_ci IN NUMBER
, P_automatismo IN VARCHAR2
, P_riferimento IN DATE
, P_tar IN NUMBER
, P_qta IN NUMBER
, P_imp IN NUMBER
, P_input IN VARCHAR2 DEFAULT null
, P_estrazione IN VARCHAR2 DEFAULT null
, P_arr IN VARCHAR2 DEFAULT null)
IS
D_codice VARCHAR2(10);
BEGIN
   select codice
     into D_codice
     from voci_economiche
    where automatismo = P_automatismo
      and (  P_tar != 0
          or P_qta != 0
          or P_imp != 0
          ) 
   ;
   
   insert_voce
         ( P_ci
         , D_codice
         , '*'
         , P_riferimento
         , P_tar
         , P_qta
         , P_imp
         , P_input
         , P_estrazione
         , P_arr
         )
   ;
   
EXCEPTION
   WHEN NO_DATA_FOUND
      THEN null;
END insert_voce;

Function exists_voce
( P_ci IN NUMBER
, P_voce IN VARCHAR2
, P_sub IN VARCHAR2
, P_arr IN VARCHAR2 DEFAULT null)
RETURN BOOLEAN
IS
D_return number;
BEGIN
   D_return := 0;
   
   select count(1)
     into D_return
     from calcoli_contabili
    where ci   = P_ci
      and voce = P_voce
      and sub  = P_sub
      and nvl(arr,' ') = nvl(P_arr,nvl(arr,' '))
   ;
   if d_return > 0 then
   	return true;
   else 
   	return false;
   end if;
END exists_voce;

END GP4_CACO;
/
