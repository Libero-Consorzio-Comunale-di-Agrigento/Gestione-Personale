CREATE OR REPLACE FUNCTION GET_ESISTE_IMAS 
( p_voce          VARCHAR2
, p_assenza       VARCHAR2
, p_riferimento   DATE
) RETURN NUMBER IS
/******************************************************************************
 NOME:        GET_ESISTE_IMAS
 DESCRIZIONE: <Descrizione function>

 PARAMETRI:   voce, assenza, riferimento

 RITORNA:     1 esiste combinazione voce imponibile / assenza in IMAS
              0 NON esiste combinazione voce imponibile / assenza in IMAS

 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    07/09/2005   NN    Prima emissione.
******************************************************************************/
d_valore         NUMBER;
BEGIN
   d_valore := 0;
   select 1
     into d_valore
     from dual
    where exists
         ( select 'x'
             from imponibili_assenza
            where voce = p_voce
              and assenza = p_assenza
              and p_riferimento
                  between nvl(dal, TO_DATE('2222222','j'))
                      and nvl(al, TO_DATE('3333333','j')))
   ;
   RETURN d_valore;
EXCEPTION
   WHEN no_data_found THEN d_valore := 0;
   return d_valore;
END GET_ESISTE_IMAS;
/

