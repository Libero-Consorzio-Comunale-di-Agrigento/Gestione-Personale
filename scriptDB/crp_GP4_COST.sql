CREATE OR REPLACE PACKAGE GP4_COST IS
/******************************************************************************
 NOME:        GP4_COST
 DESCRIZIONE: Funzioni su CONTRATTI_STORICI

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/08/2002 __     Prima emissione.
 1    22/06/2005        A11756 
******************************************************************************/
   FUNCTION  VERSIONE          RETURN VARCHAR2;
             PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
   FUNCTION  GET_ORE_LAVORO  ( p_qualifica in number
                              ,p_data      in date
                             ) RETURN NUMBER;
             PRAGMA RESTRICT_REFERENCES(GET_ORE_LAVORO,wnds,wnps);
   FUNCTION  GET_ORE_LAVORO_DIVISIONE  ( p_qualifica in number
                                        ,p_data      in date
                             ) RETURN NUMBER;
             PRAGMA RESTRICT_REFERENCES(GET_ORE_LAVORO_DIVISIONE,wnds,wnps);
   FUNCTION  GET_ORE_MENSILI ( p_qualifica in number
                              ,p_data      in date
                             ) RETURN NUMBER;
             PRAGMA RESTRICT_REFERENCES(GET_ORE_MENSILI,wnds,wnps);
   FUNCTION  GET_DIV_ORARIO  ( p_qualifica in number
                              ,p_data      in date
                             ) RETURN NUMBER;
             PRAGMA RESTRICT_REFERENCES(GET_DIV_ORARIO,wnds,wnps);
   FUNCTION  GET_ORE_GG      ( p_qualifica in number
                              ,p_data      in date
                             ) RETURN NUMBER;
             PRAGMA RESTRICT_REFERENCES(GET_ORE_GG,wnds,wnps);
   FUNCTION  GET_GG_LAVORO  ( p_qualifica in number
                              ,p_data      in date
                             ) RETURN NUMBER;
             PRAGMA RESTRICT_REFERENCES(GET_GG_LAVORO,wnds,wnps);
END GP4_COST;
/
CREATE OR REPLACE PACKAGE BODY GP4_COST AS

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
   RETURN 'V1.1 del 22/06/2005';
END VERSIONE;
--
FUNCTION GET_ORE_LAVORO  (p_qualifica in number, p_data in date) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce le ore contrattuali data una qualifica
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
BEGIN
  begin
   select ore_lavoro
     into d_ore
	 from contratti_storici
	where contratto    = gp4_qugi.get_contratto(p_qualifica,p_data)
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
  exception
    when no_data_found then
	   d_ore := to_number(null);
	when others then
	   d_ore := to_number(null);
  end;
  return d_ore;
END GET_ORE_LAVORO;
--
FUNCTION GET_ORE_LAVORO_DIVISIONE  (p_qualifica in number, p_data in date) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce le ore contrattuali data una qualifica, se nulle le mette a 0
              Per A11756
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
BEGIN
  begin
   select DECODE(ore_lavoro,0,1,ORE_LAVORO)
     into d_ore
	 from contratti_storici
	where contratto    = gp4_qugi.get_contratto(p_qualifica,p_data)
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
  exception
    when no_data_found then
	   d_ore := to_number(null);
	when others then
	   d_ore := to_number(null);
  end;
  return d_ore;
END GET_ORE_LAVORO_DIVISIONE;

FUNCTION GET_ORE_MENSILI  (p_qualifica in number, p_data in date) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce le ore mensili contrattuali data una qualifica
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
BEGIN
  begin
   select ore_mensili
     into d_ore
	 from contratti_storici
	where contratto    = gp4_qugi.get_contratto(p_qualifica,p_data)
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
  exception
    when no_data_found then
	   d_ore := to_number(null);
	when others then
	   d_ore := to_number(null);
  end;
  return d_ore;
END GET_ORE_MENSILI;
--

FUNCTION GET_DIV_ORARIO  (p_qualifica in number, p_data in date) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce le ore contrattuali data una qualifica
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
BEGIN
  begin
   select div_orario
     into d_ore
	 from contratti_storici
	where contratto    = gp4_qugi.get_contratto(p_qualifica,p_data)
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
  exception
    when no_data_found then
	   d_ore := to_number(null);
	when others then
	   d_ore := to_number(null);
  end;
  return d_ore;
END GET_DIV_ORARIO;
--
FUNCTION GET_ORE_GG (p_qualifica in number, p_data in date) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce le ore contrattuali data una qualifica
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
BEGIN
  begin
   select ore_gg
     into d_ore
	 from contratti_storici
	where contratto    = gp4_qugi.get_contratto(p_qualifica,p_data)
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
  exception
    when no_data_found then
	   d_ore := to_number(null);
	when others then
	   d_ore := to_number(null);
  end;
  return d_ore;
END GET_ORE_GG;
--
FUNCTION GET_GG_LAVORO  (p_qualifica in number, p_data in date) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce le ore contrattuali data una qualifica
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
BEGIN
  begin
   select gg_lavoro
     into d_ore
	 from contratti_storici
	where contratto    = gp4_qugi.get_contratto(p_qualifica,p_data)
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
  exception
    when no_data_found then
	   d_ore := to_number(null);
	when others then
	   d_ore := to_number(null);
  end;
  return d_ore;
END GET_GG_LAVORO;
--



END GP4_COST;
/
