CREATE OR REPLACE FORCE VIEW DOTAZIONE_GESTIONI_DIRITTO
(UTENTE, REVISIONE, PROVENIENZA, GESTIONE, NUMERO, 
 NUMERO_ORE, EFFETTIVI, DI_RUOLO, ASSENTI, INCARICATI, 
 NON_RUOLO, DIFF_NUMERO, DIFF_ORE)
AS 
select
 rido.UTENTE
,door.revisione
,'D'
,door.GESTIONE
,sum(door.NUMERO)
,sum(door.NUMERO_ORE)
,round(decode( gp4_gest.get_ore_do(door.gestione)
        ,'U',sum(gp4do.conta_dot_ore ( door.revisione
                                ,'Q'
                                ,rido.data
                                ,door.gestione
                                ,door.door_id
                                ,gp4do.get_ore_lavoro_ue(rido.data,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello)
								     )
				)
            ,sum(gp4do.conta_dotazione ( door.revisione
                                    ,'Q'
                                    ,rido.data
                                    ,door.gestione
                                    ,door.door_id
                                       )
				 )
	 ),1) effettivi
,round(decode( gp4_gest.get_ore_do(door.gestione)
        ,'U',sum(gp4do.conta_dot_ruolo_ore ( door.revisione
                                ,'Q'
                                ,rido.data
                                ,door.gestione
                                ,door.door_id
                                ,gp4do.get_ore_lavoro_ue(rido.data,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello)
								     )
				)
            ,sum(gp4do.conta_dot_ruolo ( door.revisione
                                    ,'Q'
                                    ,rido.data
                                    ,door.gestione
                                    ,door.door_id
                                       )
				 )
	 ),1) ruolo
,round(decode( gp4_gest.get_ore_do(door.gestione)
        ,'U',sum(gp4do.conta_ore_assenti ( door.revisione
                                ,'Q'
                                ,rido.data
                                ,door.gestione
                                ,door.door_id
                                ,gp4do.get_ore_lavoro_ue(rido.data,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello)
								     )
				)
            ,sum(gp4do.conta_dot_assenti ( door.revisione
                                    ,'Q'
                                    ,rido.data
                                    ,door.gestione
                                    ,door.door_id
                                       )
				 )
	 ),1) assenti
,round(decode( gp4_gest.get_ore_do(door.gestione)
        ,'U',sum(gp4do.conta_ore_incaricati ( door.revisione
                                ,'Q'
                                ,rido.data
                                ,door.gestione
                                ,door.door_id
                                ,gp4do.get_ore_lavoro_ue(rido.data,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello)
								     )
				)
            ,sum(gp4do.conta_dot_incaricati ( door.revisione
                                    ,'Q'
                                    ,rido.data
                                    ,door.gestione
                                    ,door.door_id
                                       )
				 )
	 ),1) incaricati
,round(decode( gp4_gest.get_ore_do(door.gestione)
        ,'U',sum(gp4do.conta_ore_non_ruolo ( door.revisione
                                ,'Q'
                                ,rido.data
                                ,door.gestione
                                ,door.door_id
                                ,gp4do.get_ore_lavoro_ue(rido.data,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello)
								     )
				)
            ,sum(gp4do.conta_dot_non_ruolo ( door.revisione
                                    ,'Q'
                                    ,rido.data
                                    ,door.gestione
                                    ,door.door_id
                                       )
				 )
	 ),1) non_ruolo
,sum(gp4do.conta_dotazione ( door.revisione
                        ,'Q'
                        ,rido.data
                        ,door.gestione
                        ,door.door_id
                       ) - numero) diff_numero
,round(sum(gp4do.conta_dot_ORE   ( revisione
                        ,'Q'
                        ,rido.data
                        ,gestione
                        ,door.door_id
                        ,gp4do.get_ore_lavoro_ue(rido.data,door.ruolo,door.profilo,door.posizione,door.figura,door.qualifica,door.livello)
						) - numero_ore),1) diff_ore
from dotazione_organica     door
    ,riferimento_dotazione  rido
group by  rido.UTENTE
         ,door.revisione
         ,door.GESTIONE
union
select rido.UTENTE
      ,pedo.revisione
      ,'G'
      ,pedo.gestione
      ,0
      ,0
      ,round(decode( gp4_gest.get_ore_do(pedo.gestione)
                    ,'U',sum( pedo.ue
                            )
					    ,count(ci)
				   ),1
			)			effettivi
      ,sum(decode( pedo.di_ruolo
	         ,'SI',round(decode( gp4_gest.get_ore_do(pedo.gestione)
                                ,'U', pedo.ue
					                ,1
			        	      ),1
			            )
				  ,0
			  )
		   ) di_ruolo
      ,sum(decode( gp4_gest.get_ore_do(pedo.gestione)
                  ,'U',decode( gp4gm.get_se_ASSENTE(pedo.ci,rido.DATA), 1,pedo.ue
							   ,0
							 )
					  ,gp4gm.get_se_ASSENTE(pedo.ci,rido.DATA)
			     )
	      )                                                     assenti
      ,sum(decode( gp4_gest.get_ore_do(pedo.gestione)
                  ,'U',decode( gp4gm.get_se_incaricato(pedo.ci,rido.DATA), 1,pedo.ue
							   ,0
							 )
					  ,gp4gm.get_se_incaricato(pedo.ci,rido.DATA)
			     )
	      )                                                     incaricati
      ,sum(decode( pedo.di_ruolo
	              ,'NO',round(decode( gp4_gest.get_ore_do(pedo.gestione)
                                ,'U', pedo.ue					                ,1
			        	             ),1
			                 )
				       ,0
			     )
		  ) NON_RUOLO
      ,count(ci)
	  ,round( decode( gp4_gest.get_ore_do(pedo.gestione)
	         ,'U',sum( pedo.ue  )
				 ,sum( pedo.ore )
					)
	         ,1
			) ore
  from periodi_dotazione        pedo
      ,riferimento_dotazione    rido
 where pedo.rilevanza = 'Q'
   and rido.data between pedo.dal
                     and nvl(pedo.al,to_date(3333333,'j'))
   and pedo.door_id   = 0
 group by rido.utente
         ,pedo.revisione
         ,pedo.gestione
/


