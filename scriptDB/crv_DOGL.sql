CREATE OR REPLACE FORCE VIEW DOTAZIONE_GRUPPI_LING_DIRITTO
(GRUPPO, DES_GRUPPO, DAL, AL, UE_I, 
 UE_D, UE_L, REVISIONE, DI_RUOLO_I, DI_RUOLO_D, 
 DI_RUOLO_L, DOTAZIONE_I, DOTAZIONE_D, DOTAZIONE_L)
AS 
select grdo.gruppo 
      ,max(grdo.descrizione)                     des_gruppo 
	  ,rigd.dal                                  dal 
	  ,rigd.al                                   al 
      ,max(rigd.numero_ore_i)                    ue_i 
      ,max(rigd.numero_ore_d)                    ue_d 
      ,max(rigd.numero_ore_l)                    ue_l 
	  ,rgdo.revisione                            revisione 
	  ,sum(gp4do.conta_dotazione_ling_ruolo ( door.revisione 
                                   ,'I' 
                                   ,'Q' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             di_ruolo_I 
	  ,sum(gp4do.conta_dotazione_ling_ruolo ( door.revisione 
                                   ,'D' 
                                   ,'Q' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             di_ruolo_D 
	  ,sum(gp4do.conta_dotazione_ling_ruolo ( door.revisione 
                                   ,'L' 
                                   ,'Q' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             di_ruolo_L 
	  ,sum(gp4do.conta_dotazione_ling ( door.revisione 
                                   ,'I' 
                                   ,'Q' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             dotazione_I 
	  ,sum(gp4do.conta_dotazione_ling ( door.revisione 
                                   ,'D' 
                                   ,'Q' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             dotazione_D 
	  ,sum(gp4do.conta_dotazione_ling ( door.revisione 
                                   ,'L' 
                                   ,'Q' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             dotazione_L 
  from gruppi_dotazione                          grdo 
      ,ripartizione_gruppi_dotazione             rigd 
	  ,dotazione_organica                        door 
	  ,righe_gruppi_dotazione                    rgdo 
 where grdo.gruppo                               = rigd.gruppo 
   and rigd.rigd_id                              = rgdo.rigd_id 
   and door.door_id                              = rgdo.door_id 
   and door.revisione                            = rgdo.revisione 
 group by  grdo.gruppo 
    	  ,rigd.dal 
    	  ,rigd.al 
          ,rgdo.revisione
/
CREATE OR REPLACE FORCE VIEW DOTAZIONE_GRUPPI_LING_FATTO
(GRUPPO, DES_GRUPPO, DAL, AL, UE_I, 
 UE_D, UE_L, REVISIONE, DI_RUOLO_I, DI_RUOLO_D, 
 DI_RUOLO_L, DOTAZIONE_I, DOTAZIONE_D, DOTAZIONE_L)
AS 
select grdo.gruppo 
      ,max(grdo.descrizione)                     des_gruppo 
	  ,rigd.dal                                  dal 
	  ,rigd.al                                   al 
      ,max(rigd.numero_ore_i)                    ue_i 
      ,max(rigd.numero_ore_d)                    ue_d 
      ,max(rigd.numero_ore_l)                    ue_l 
	  ,rgdo.revisione                            revisione 
	  ,sum(gp4do.conta_dotazione_ling_ruolo ( door.revisione 
                                   ,'I' 
                                   ,'S' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             di_ruolo_I 
	  ,sum(gp4do.conta_dotazione_ling_ruolo ( door.revisione 
                                   ,'D' 
                                   ,'S' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             di_ruolo_D 
	  ,sum(gp4do.conta_dotazione_ling_ruolo ( door.revisione 
                                   ,'L' 
                                   ,'S' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             di_ruolo_L 
	  ,sum(gp4do.conta_dotazione_ling ( door.revisione 
                                   ,'I' 
                                   ,'S' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             dotazione_I 
	  ,sum(gp4do.conta_dotazione_ling ( door.revisione 
                                   ,'D' 
                                   ,'S' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             dotazione_D 
	  ,sum(gp4do.conta_dotazione_ling ( door.revisione 
                                   ,'L' 
                                   ,'S' 
                                   ,nvl(rigd.dal,to_date(3333333,'j')) 
                                   ,door.gestione 
                                   ,door.door_id 
                                   ,gp4do.get_ore_lavoro_ue(rigd.dal,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello) 
                                   ))             dotazione_L 
  from gruppi_dotazione                          grdo 
      ,ripartizione_gruppi_dotazione             rigd 
	  ,dotazione_organica                        door 
	  ,righe_gruppi_dotazione                    rgdo 
 where grdo.gruppo                               = rigd.gruppo 
   and rigd.rigd_id                              = rgdo.rigd_id 
   and door.door_id                              = rgdo.door_id 
   and door.revisione                            = rgdo.revisione 
 group by  grdo.gruppo 
    	  ,rigd.dal 
    	  ,rigd.al 
	  ,rgdo.revisione
/






