CREATE OR REPLACE PACKAGE GP4_DOOR IS
/******************************************************************************
 NOME:        GP4_DOOR
 DESCRIZIONE: Funzioni sulla tabella DOTAZIONE_ORGANICA

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/08/2002 __     Prima emissione.
 1    06/02/2004 __     Revisione per Altoadige
******************************************************************************/
   FUNCTION  VERSIONE                               RETURN VARCHAR2;
             PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
   FUNCTION  GET_SE_ORE     (p_revisione in number) RETURN number;
             PRAGMA RESTRICT_REFERENCES(GET_SE_ORE,wnds,wnps);
   FUNCTION  GET_NUMERO_ORE (p_revisione in number, p_door_id in number) RETURN number;
             PRAGMA RESTRICT_REFERENCES(GET_NUMERO_ORE,wnds,wnps);
   FUNCTION  GET_NUMERO     (p_revisione in number, p_door_id in number) RETURN number;
             PRAGMA RESTRICT_REFERENCES(GET_NUMERO,wnds,wnps);
   FUNCTION  GET_ID         ( p_revisione         in number
                             ,p_rilevanza         in varchar2
                             ,p_gestione          in varchar2
                             ,p_area              in varchar2
                             ,p_settore           in varchar2
                             ,p_ruolo             in varchar2
                             ,p_profilo           in varchar2
                             ,p_posizione         in varchar2
                             ,p_attivita          in varchar2
                             ,p_figura            in varchar2
                             ,p_qualifica         in varchar2
                             ,p_livello           in varchar2
                             ,p_tipo_rapporto     in varchar2
                             ,p_ore               in number
                            ) RETURN number;
             PRAGMA RESTRICT_REFERENCES(GET_ID,wnds,wnps);
   PROCEDURE CHK_DOOR_PEDO_DELETE ( p_revisione         in number
                                   ,p_door_id           in number
                                  ) ;
  PROCEDURE CHK_DOOR_PEDO_INSERT (  p_revisione         in number
                                   ,p_door_id           in number
                                   ,p_gestione          in varchar2
                                   ,p_area              in varchar2
                                   ,p_settore           in varchar2
                                   ,p_ruolo             in varchar2
                                   ,p_profilo           in varchar2
                                   ,p_posizione         in varchar2
                                   ,p_attivita          in varchar2
                                   ,p_figura            in varchar2
                                   ,p_qualifica         in varchar2
                                   ,p_livello           in varchar2
                                   ,p_tipo_rapporto     in varchar2
                                   ,p_ore               in number                             
                            ) ;
  PROCEDURE CHK_DOOR_PEDO_UPDATE (  p_revisione         in number
                                   ,p_door_id           in number
                                   ,p_gestione          in varchar2
                                   ,p_area              in varchar2
                                   ,p_settore           in varchar2
                                   ,p_ruolo             in varchar2
                                   ,p_profilo           in varchar2
                                   ,p_posizione         in varchar2
                                   ,p_attivita          in varchar2
                                   ,p_figura            in varchar2
                                   ,p_qualifica         in varchar2
                                   ,p_livello           in varchar2
                                   ,p_tipo_rapporto     in varchar2
                                   ,p_ore               in number   
                                   ,p_gestione_old      in varchar2
                                   ,p_area_old          in varchar2
                                   ,p_settore_old       in varchar2
                                   ,p_ruolo_old         in varchar2
                                   ,p_profilo_old       in varchar2
                                   ,p_posizione_old     in varchar2
                                   ,p_attivita_old      in varchar2
                                   ,p_figura_old        in varchar2
                                   ,p_qualifica_old     in varchar2
                                   ,p_livello_old       in varchar2
                                   ,p_tipo_rapporto_old in varchar2
                                   ,p_ore_old           in number                             
                            ) ;
END GP4_DOOR;
/
CREATE OR REPLACE PACKAGE BODY GP4_DOOR AS

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
   RETURN 'V2.0 del 06/02/2004';
END VERSIONE;
--
FUNCTION GET_SE_ORE  (p_revisione in number) RETURN number IS
d_SE_ORE number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce 1 se nella definizione della dotazione organica sono stati
              indicati il numero di individui per ore settimanali
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_se_ore := 0;
  begin
   select 1
     into d_SE_ORE
	 from dual
	where exists
	     (select 'x'
		    from dotazione_organica
		   where revisione = p_revisione
		     and ore is not null
		 )
   ;
  exception
    when no_data_found then
	   d_SE_ORE := 0;
  end;
  return d_SE_ORE;
END GET_SE_ORE;
--
FUNCTION GET_NUMERO_ORE  (p_revisione in number, p_door_id in number) RETURN number IS
d_NUMERO_ORE number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce il numero ore previste per la registrazione indicata
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_NUMERO_ORE := 0;
  begin
   select numero_ore
     into d_NUMERO_ORE
	 from dotazione_organica 
	where revisione = p_revisione
	  and door_id   = p_door_id
   ;
  exception
    when no_data_found then
	   d_NUMERO_ORE := 0;
  end;
  return d_NUMERO_ORE;
END GET_NUMERO_ORE;
--
FUNCTION GET_NUMERO  (p_revisione in number, p_door_id in number) RETURN number IS
d_NUMERO number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce il numero ore previste per la registrazione indicata
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_NUMERO := 0;
  begin
   select numero
     into d_NUMERO
	 from dotazione_organica 
	where revisione = p_revisione
	  and door_id   = p_door_id
   ;
  exception
    when no_data_found then
	   d_NUMERO := 0;
  end;
  return d_NUMERO;
END GET_NUMERO;
--
FUNCTION GET_ID  ( p_revisione         in number
                  ,p_rilevanza         in varchar2
                  ,p_gestione          in varchar2
                  ,p_area              in varchar2
                  ,p_settore           in varchar2
                  ,p_ruolo             in varchar2
                  ,p_profilo           in varchar2
                  ,p_posizione         in varchar2
                  ,p_attivita          in varchar2
                  ,p_figura            in varchar2
                  ,p_qualifica         in varchar2
                  ,p_livello           in varchar2
                  ,p_tipo_rapporto     in varchar2
                  ,p_ore               in number
                 ) RETURN number IS
d_door_id number;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce l'ID del record di DOOR identificato dagli attributi
              giuridici indicati.
 PARAMETRI:   --
******************************************************************************/
BEGIN
   d_door_id := 0;
   if    p_rilevanza in ('Q','I') then
      begin
         select door.door_id
           into d_door_id
           from dotazione_organica door
          where door.revisione                   = p_revisione
            and nvl(p_gestione,'%')           like door.gestione
            and nvl(p_area,'%')               like door.area
            and nvl(p_settore,'%')            like door.settore
            and nvl(p_profilo,'%')            like door.profilo
            and nvl(p_posizione,'%')          like door.posizione
            and nvl(p_figura,'%')             like door.figura
            and nvl(p_attivita,'%')           like door.attivita
            and nvl(p_tipo_rapporto,'%')      like door.tipo_rapporto
            and nvl(p_ruolo,'%')              like door.ruolo
            and nvl(p_livello,'%')            like door.livello
            and nvl(p_qualifica,'%')          like door.qualifica
            and nvl(p_ore,0)                     = nvl(door.ore,nvl(p_ore,0))
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
   elsif p_rilevanza in ('S','E') then
      begin
         select door.door_id
           into d_door_id
           from dotazione_organica door
          where door.revisione                   = p_revisione
            and nvl(p_gestione,'%')           like door.gestione
            and nvl(p_area,'%')               like door.area
            and nvl(p_settore,'%')            like door.settore
            and nvl(p_profilo,'%')            like door.profilo
            and nvl(p_posizione,'%')          like door.posizione
            and nvl(p_figura,'%')             like door.figura
            and nvl(p_attivita,'%')           like door.attivita
            and nvl(p_tipo_rapporto,'%')      like door.tipo_rapporto
            and nvl(p_ruolo,'%')              like door.ruolo
            and nvl(p_livello,'%')            like door.livello
            and nvl(p_qualifica,'%')          like door.qualifica
            and nvl(p_ore,0)                     = nvl(door.ore,nvl(p_ore,0))
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
   end if;
   return d_door_id;
END GET_ID;
--
PROCEDURE CHK_DOOR_PEDO_DELETE   ( p_revisione         in number
                                  ,p_door_id           in number
                                  )  IS
/******************************************************************************
   NAME:       CHK_DOOR_PEDO_DELETE
   PURPOSE:    Aggiorna PERIODI_DOTAZIONE se cancello un record da DOTAZIONE_ORGANICA
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        04/03/2005                 1. Created this procedure
******************************************************************************/
BEGIN
update periodi_dotazione
set    door_id                  =    0
where  door_id                  =    p_door_id
and    rilevanza                in   ('Q','S','I','E')
and    revisione                =    p_revisione
         ;
END CHK_DOOR_PEDO_DELETE ;

PROCEDURE CHK_DOOR_PEDO_INSERT   ( p_revisione         in number
                                  ,p_door_id           in number
                                  ,p_gestione          in varchar2
                                  ,p_area              in varchar2
                                  ,p_settore           in varchar2
                                  ,p_ruolo             in varchar2
                                  ,p_profilo           in varchar2
                                  ,p_posizione         in varchar2
                                  ,p_attivita          in varchar2
                                  ,p_figura            in varchar2
                                  ,p_qualifica         in varchar2
                                  ,p_livello           in varchar2
                                  ,p_tipo_rapporto     in varchar2
                                  ,p_ore               in number
                            )  IS
/******************************************************************************
   NAME:       CHK_DOOR_PEDO_INSERT
   PURPOSE:    Aggiorna PERIODI_DOTAZIONE se inserisco un record su DOTAZIONE_ORGANICA
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        04/03/2005                 1. Created this procedure
******************************************************************************/
BEGIN
update periodi_dotazione
set    door_id                           =    p_door_id
where  door_id                           =    0
and    rilevanza                         in   ('Q','S','I','E')
and    revisione                         =    p_revisione
and    nvl(gestione ,'%')                like nvl(p_gestione,'%')       
and    nvl(area ,'%')                    like nvl(p_area,'%')              
and    nvl(codice_uo,'%')                like nvl(p_settore,'%')        
and    nvl(profilo ,'%')                 like nvl(p_profilo,'%')          
and    nvl(pos_funz  ,'%')               like nvl(p_posizione,'%')        
and    nvl(cod_figura  ,'%')             like nvl(p_figura,'%')            
and    nvl(attivita   ,'%')              like nvl(p_attivita,'%')           
and    nvl(tipo_rapporto ,'%')           like nvl(p_tipo_rapporto,'%') 
and    nvl(ruolo   ,'%')                 like nvl(p_ruolo,'%')             
and    nvl(livello  ,'%')                like nvl(p_livello,'%')     
and    nvl(cod_qualifica ,'%')           like nvl(p_qualifica,'%')        
and    ore                               =    nvl(p_ore,ORE)                  
         ;
END CHK_DOOR_PEDO_INSERT ;

PROCEDURE CHK_DOOR_PEDO_UPDATE   ( p_revisione         in number
                                  ,p_door_id           in number
                                  ,p_gestione          in varchar2
                                  ,p_area              in varchar2
                                  ,p_settore           in varchar2
                                  ,p_ruolo             in varchar2
                                  ,p_profilo           in varchar2
                                  ,p_posizione         in varchar2
                                  ,p_attivita          in varchar2
                                  ,p_figura            in varchar2
                                  ,p_qualifica         in varchar2
                                  ,p_livello           in varchar2
                                  ,p_tipo_rapporto     in varchar2
                                  ,p_ore               in number
                                  ,p_gestione_old      in varchar2
                                  ,p_area_old          in varchar2
                                  ,p_settore_old       in varchar2
                                  ,p_ruolo_old         in varchar2
                                  ,p_profilo_old       in varchar2
                                  ,p_posizione_old     in varchar2
                                  ,p_attivita_old      in varchar2
                                  ,p_figura_old        in varchar2
                                  ,p_qualifica_old     in varchar2
                                  ,p_livello_old       in varchar2
                                  ,p_tipo_rapporto_old in varchar2
                                  ,p_ore_old           in number 
                            )  IS
/******************************************************************************
   NAME:       CHK_DOOR_PEDO_UPDATE
   PURPOSE:    Aggiorna PERIODI_DOTAZIONE se modifico un record su DOTAZIONE_ORGANICA
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        04/03/2005                 1. Created this procedure
******************************************************************************/
BEGIN
update periodi_dotazione
set    door_id                           =    0
where  door_id                           =    p_door_id
and    rilevanza                         in   ('Q','S','I','E')
and    revisione                         =    p_revisione
and    nvl(gestione ,'%')                like nvl(p_gestione_old,'%')       
and    nvl(area ,'%')                    like nvl(p_area_old,'%')             
and    nvl(codice_uo,'%')                like nvl(p_settore_old,'%')        
and    nvl(profilo ,'%')                 like nvl(p_profilo_old,'%')          
and    nvl(pos_funz  ,'%')               like nvl(p_posizione_old,'%')        
and    nvl(cod_figura  ,'%')             like nvl(p_figura_old,'%')            
and    nvl(attivita   ,'%')              like nvl(p_attivita_old,'%')           
and    nvl(tipo_rapporto ,'%')           like nvl(p_tipo_rapporto_old,'%') 
and    nvl(ruolo   ,'%')                 like nvl(p_ruolo_old,'%')             
and    nvl(livello  ,'%')                like nvl(p_livello_old,'%')     
and    nvl(cod_qualifica ,'%')           like nvl(p_qualifica_old,'%')        
and    ore                               =    nvl(p_ore_old,ORE)                  
         ;

update periodi_dotazione
set    door_id                           =    p_door_id
where  door_id                           =    0
and    rilevanza                         in   ('Q','S','I','E')
and    revisione                         =    p_revisione
and    nvl(gestione ,'%')                like nvl(p_gestione,'%')       
and    nvl(area ,'%')                    like nvl(p_area,'%')              
and    nvl(codice_uo,'%')                like nvl(p_settore,'%')        
and    nvl(profilo ,'%')                 like nvl(p_profilo,'%')          
and    nvl(pos_funz  ,'%')               like nvl(p_posizione,'%')        
and    nvl(cod_figura  ,'%')             like nvl(p_figura,'%')            
and    nvl(attivita   ,'%')              like nvl(p_attivita,'%')           
and    nvl(tipo_rapporto ,'%')           like nvl(p_tipo_rapporto,'%') 
and    nvl(ruolo   ,'%')                 like nvl(p_ruolo,'%')             
and    nvl(livello  ,'%')                like nvl(p_livello,'%')     
and    nvl(cod_qualifica ,'%')           like nvl(p_qualifica,'%')        
and    ore                               =    nvl(p_ore,ORE)               
         ;
END CHK_DOOR_PEDO_UPDATE ;



END GP4_DOOR;
/* End Package Body: GP4_DOOR */
/
