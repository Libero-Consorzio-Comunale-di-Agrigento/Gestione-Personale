CREATE OR REPLACE PACKAGE GP4_RDRE
/******************************************************************************
 NOME:        GP4_RDRE
 DESCRIZIONE: Vengono letti i dati da righe_delibere_retributive e vengono
              restituiti solo se  la concatenazione dei campi :risorsa_intervento,
              capitolo,impegno e sub_impegno non e nulla
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    01/02/2005 __    Prima emissione.
 1.1  07/02/2005 AM    Modifica per attivita 9535
 1.2  14/07/2005 MS    Modifica per attivita 12006
******************************************************************************/
IS
   FUNCTION CAPITOLO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN VARCHAR2;
      PRAGMA restrict_references(CAPITOLO,WNDS,WNPS);
   FUNCTION ARTICOLO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN VARCHAR2;
      PRAGMA restrict_references(ARTICOLO,WNDS,WNPS);
   FUNCTION RISORSA_INTERVENTO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN VARCHAR2;
      PRAGMA restrict_references(RISORSA_INTERVENTO,WNDS,WNPS);
   FUNCTION CONTO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN VARCHAR2;
      PRAGMA restrict_references(CONTO,WNDS,WNPS);
   FUNCTION IMPEGNO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN NUMBER;
      PRAGMA restrict_references(IMPEGNO,WNDS,WNPS);
   FUNCTION ANNO_IMPEGNO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN NUMBER;
      PRAGMA restrict_references(ANNO_IMPEGNO,WNDS,WNPS);
   FUNCTION ANNO_SUB_IMPEGNO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN NUMBER;
      PRAGMA restrict_references(ANNO_SUB_IMPEGNO,WNDS,WNPS);
   FUNCTION SUB_IMPEGNO (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN NUMBER;
      PRAGMA restrict_references(SUB_IMPEGNO,WNDS,WNPS);
   FUNCTION CODICE_SIOPE (
      P_SEDE_DEL     VARCHAR2,
      P_ANNO_DEL     NUMBER,
      P_NUMERO_DEL   NUMBER,
      P_DELIBERA     VARCHAR2,
      P_BILANCIO     VARCHAR2
   )
      RETURN VARCHAR2;
      PRAGMA restrict_references(CODICE_SIOPE,WNDS,WNPS);
END;
/
CREATE OR REPLACE package body gp4_rdre
is
cursor c_rdre (p_sede_del VARCHAR2
,p_anno_del NUMBER
,p_numero_del NUMBER
,p_delibera VARCHAR2
,p_bilancio VARCHAR2) is
select rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno esiste
     , capitolo
     , articolo
     , risorsa_intervento
     , conto
     , impegno
     , anno_impegno
     , sub_impegno
     , anno_sub_impegno
     , codice_siope
from righe_delibera_retributiva rdre
where rdre.sede      = p_sede_del
   and rdre.anno     = p_anno_del
   and rdre.numero   = p_numero_del
   and rdre.tipo     = p_delibera
   and rdre.bilancio = p_bilancio  
;
FUNCTION CAPITOLO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return varchar2
IS
v_capitolo varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_capitolo := v_rdre.capitolo;
end if;
close c_rdre;
return v_capitolo;
end;
FUNCTION ARTICOLO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return varchar2
IS
v_articolo varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_articolo := v_rdre.articolo;
end if;
close c_rdre;
return v_articolo;
end;
FUNCTION RISORSA_INTERVENTO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return varchar2
IS
v_risorsa_intervento varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_risorsa_intervento := v_rdre.risorsa_intervento;
end if;
close c_rdre;
return v_risorsa_intervento;
end;
FUNCTION CONTO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return varchar2
IS
v_conto varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_conto := v_rdre.conto;
end if;
close c_rdre;
return v_conto;
end;
FUNCTION IMPEGNO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return number
IS
v_impegno varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_impegno := v_rdre.impegno;
end if;
close c_rdre;
return v_impegno;
end;
FUNCTION ANNO_IMPEGNO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return number
IS
v_anno_impegno varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_anno_impegno := v_rdre.anno_impegno;
end if;
close c_rdre;
return v_anno_impegno;
end;
FUNCTION ANNO_SUB_IMPEGNO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return number
IS
v_anno_sub_impegno varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_anno_sub_impegno := v_rdre.anno_sub_impegno;
end if;
close c_rdre;
return v_anno_sub_impegno;
end;
FUNCTION SUB_IMPEGNO
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return number
IS
v_sub_impegno varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_sub_impegno := v_rdre.sub_impegno;
end if;
close c_rdre;
return v_sub_impegno;
end;
FUNCTION CODICE_SIOPE
(p_sede_del varchar2
,p_anno_del number
,p_numero_del number
,p_delibera varchar2
,p_bilancio varchar2)
return varchar2
IS
v_codice_siope varchar2(32000);
v_rdre c_rdre%ROWTYPE;
BEGIN
open c_rdre (p_sede_del
,p_anno_del
,p_numero_del
,p_delibera
,p_bilancio);
fetch c_rdre into v_rdre;
if c_rdre%FOUND and v_rdre.esiste is not null then
  v_codice_siope := v_rdre.codice_siope;
end if;
close c_rdre;
return v_codice_siope;
end;
END;
/
