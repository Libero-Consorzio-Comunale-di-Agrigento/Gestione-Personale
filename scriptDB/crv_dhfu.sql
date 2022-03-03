CREATE OR REPLACE VIEW DOTAZIONE_XORE_FATTO_UE ( UTENTE, 
DATA, REVISIONE, DOOR_ID, GESTIONE, 
ORE, NUM_PREV, ORE_PREV, EFFETTIVI, 
DI_RUOLO, ASSENTI, INCARICATI, NON_RUOLO, 
CONTRATTISTI, SOVRANNUMERO,NUMERO ) AS select rido.UTENTE 
      ,rido.data 
      ,redo.revisione 
      ,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione) door_id 
	  ,pegi.gestione 
      ,pegi.ore 
      ,max(gp4_door.get_numero(redo.revisione,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione))) num_prev 
      ,max(gp4_door.get_numero_ore(redo.revisione,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione))) ore_prev 
      ,round(decode( gp4_gest.get_ore_do(pegi.gestione) 
                    ,'U',sum( nvl( pegi.ore 
					             , gp4_cost.get_ore_lavoro( pegi.qualifica,pegi.dal) 
                                 ) / gp4_cost.get_ore_lavoro_divisione( pegi.qualifica,pegi.dal) 
                            ) 
					    ,count(ci) 
				   ),1 
			)			effettivi 
      ,sum(decode( gp4_posi.get_ruolo(pegi.POSIZIONE) 
	         ,'SI',round(decode( gp4_gest.get_ore_do(pegi.gestione) 
                                ,'U', nvl( pegi.ore 
					                         , gp4_cost.get_ore_lavoro( pegi.qualifica,pegi.dal) 
                                         ) / gp4_cost.get_ore_lavoro_divisione( pegi.qualifica,pegi.dal) 
					                ,1 
			        	      ),1 
			            ) 
				  ,0 
			  ) 
		   ) di_ruolo 
      ,sum(gp4gm.get_se_ASSENTE(pegi.ci,rido.DATA))             assenti 
      ,sum(gp4gm.get_se_incaricato(pegi.ci,rido.DATA))          incaricati 
      ,sum(decode( gp4_posi.get_ruolo(pegi.POSIZIONE) 
	              ,'NO',round(decode( gp4_gest.get_ore_do(pegi.gestione) 
                                ,'U', nvl( pegi.ore 
					                         , gp4_cost.get_ore_lavoro( pegi.qualifica,pegi.dal) 
                                         ) / gp4_cost.get_ore_lavoro_divisione( pegi.qualifica,pegi.dal) 
					                ,1 
			        	             ),1 
			                 ) 
				       ,0 
			     ) 
		  ) NON_RUOLO 
       ,sum(decode( gp4_posi.get_contratto_opera(pegi.POSIZIONE) 
	              ,'SI',round(decode( gp4_gest.get_ore_do(pegi.gestione) 
                                ,'U', nvl( pegi.ore 
					                         , gp4_cost.get_ore_lavoro( pegi.qualifica,pegi.dal) 
                                         ) / gp4_cost.get_ore_lavoro_divisione( pegi.qualifica,pegi.dal) 
					                ,1 
			        	             ),1 
			                 ) 
				       ,0 
			     ) 
		  ) CONTRATTISTI 
      ,sum(decode( gp4_posi.get_sovrannumero(pegi.POSIZIONE) 
	              ,'SI',round(decode( gp4_gest.get_ore_do(pegi.gestione) 
                                ,'U', nvl( pegi.ore 
					                         , gp4_cost.get_ore_lavoro( pegi.qualifica,pegi.dal) 
                                         ) / gp4_cost.get_ore_lavoro_divisione( pegi.qualifica,pegi.dal) 
					                ,1 
			        	             ),1 
			                 ) 
				       ,0 
			     ) 
		  ) SOVRANNUMERO 
	  ,round( decode( gp4_gest.get_ore_do(pegi.gestione) 
	         ,'U',sum( nvl( pegi.ore 
					             , gp4_cost.get_ore_lavoro( pegi.qualifica,pegi.dal) 
                                 ) / gp4_cost.get_ore_lavoro_divisione( pegi.qualifica,pegi.dal) 
                            ) 
				 ,sum( nvl( pegi.ore 
                          ,gp4_cost.get_ore_lavoro( pegi.qualifica,pegi.dal) 
                         ) 
                     ) 
					) 
	         ,1 
			) numero 
  from periodi_giuridici        pegi 
	  ,revisioni_dotazione      redo 
      ,riferimento_dotazione    rido 
 where pegi.rilevanza = 'S' 
   and rido.data between pegi.dal 
                     and nvl(pegi.al,to_date(3333333,'j')) 
 group by rido.utente 
         ,rido.data 
         ,redo.revisione 
		 ,pegi.gestione 
         ,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione) 
         ,pegi.ore
;

