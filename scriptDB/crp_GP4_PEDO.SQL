CREATE OR REPLACE PACKAGE GP4_PEDO IS
/******************************************************************************
 NOME:        GP4_PEDO
 DESCRIZIONE: Funzioni sulla tabella PERIODI_DOTAZIONE

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    11/08/2004 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE                               RETURN VARCHAR2;
   FUNCTION  GET_DOOR_ID    ( p_revisione         in number
                             ,p_ci                in number
                             ,p_rilevanza         in varchar2
                             ,p_dal               in date
                            ) RETURN number;
END GP4_PEDO;
/

CREATE OR REPLACE PACKAGE BODY GP4_PEDO AS

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
   RETURN 'V1.0 del 11/08/2004';
END VERSIONE;
--
   FUNCTION  GET_DOOR_ID    ( p_revisione         in number
                             ,p_ci                in number
                             ,p_rilevanza         in varchar2
                             ,p_dal               in date
                            ) RETURN number IS
d_door_id number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce l'ID del record di PEDO identificato dal record di PEGI
 PARAMETRI:   --
******************************************************************************/
BEGIN
   d_door_id := 0;
      begin
         select pedo.door_id
           into d_door_id
           from periodi_dotazione pedo
          where ci               = p_ci
		    and rilevanza        = p_rilevanza
			and dal              = p_dal
			and revisione        = p_revisione
         ;
      exception when no_data_found then
         begin
           d_door_id := 0;
         end;
                 when too_many_rows then
         begin
           d_door_id := 0;
         end;
     end;
   return d_door_id;
END GET_DOOR_ID;
--

--
END GP4_PEDO;
/

