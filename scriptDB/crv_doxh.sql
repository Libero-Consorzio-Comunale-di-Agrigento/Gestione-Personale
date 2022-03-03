CREATE OR REPLACE FORCE VIEW DOTAZIONE_XORE_DIRITTO
(UTENTE, DATA, REVISIONE, DOOR_ID, GESTIONE, 
 ORE, NUM_PREV, ORE_PREV, EFFETTIVI, DI_RUOLO, 
 ASSENTI, INCARICATI, NON_RUOLO, CONTRATTISTI, SOVRANNUMERO, 
 NUMERO)
AS 
select rido.UTENTE  
      ,rido.data  
      ,redo.revisione  
      ,pedo.door_id door_id  
	  ,pedo.gestione  
      ,nvl(pedo.ore,pedo.ore_lavoro) ore  
      ,max(gp4_door.get_numero(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) num_prev  
      ,max(gp4_door.get_numero_ore(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) ore_prev  
      ,count(ci)                                                          effettivi  
      ,sum(decode(pedo.di_ruolo,'SI',1,0)) di_ruolo  
      ,sum(gp4gm.get_se_ASSENTE(pedo.ci,rido.DATA))             assenti  
      ,sum(gp4gm.get_se_incaricato(pedo.ci,rido.DATA))          incaricati  
      ,sum(decode(gp4_posi.get_ruolo(pedo.POSIZIONE),'NO',1,0)) NON_RUOLO  
      ,sum(decode(pedo.contrattista,'NO',1,0)) contrattisti  
      ,sum(decode(pedo.sovrannumero,'NO',1,0))    sovrannumero 
      ,count(ci)                                                          numero  
  from periodi_dotazione        pedo  
	  ,revisioni_dotazione      redo  
      ,riferimento_dotazione    rido  
 where pedo.rilevanza = 'Q'  
   and rido.data between pedo.dal  
                     and nvl(pedo.al,to_date(3333333,'j')) 
   and pedo.revisione = redo.revisione 
 group by rido.utente  
         ,rido.data  
         ,redo.revisione  
         ,pedo.gestione  
         ,pedo.door_id
         ,nvl(pedo.ore,pedo.ore_lavoro)
/
CREATE OR REPLACE FORCE VIEW DOTAZIONE_XORE_DIRITTO_UE
(UTENTE, DATA, REVISIONE, DOOR_ID, GESTIONE, 
 ORE, NUM_PREV, ORE_PREV, EFFETTIVI, DI_RUOLO, 
 ASSENTI, INCARICATI, NON_RUOLO, CONTRATTISTI, SOVRANNUMERO, 
 NUMERO)
AS 
select rido.UTENTE  
      ,rido.data  
      ,redo.revisione  
      ,pedo.door_id door_id  
	  ,pedo.gestione  
      ,nvl(pedo.ore,pedo.ore_lavoro) ore  
      ,max(gp4_door.get_numero(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) num_prev  
      ,max(gp4_door.get_numero_ore(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) ore_prev  
      ,round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                    ,'U',sum( nvl( pedo.ore  
					             , gp4_cost.get_ore_lavoro( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                                 ) / gp4_cost.get_ore_lavoro_divisione( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                            )  
					    ,count(ci)  
				   ),1  
			)			effettivi  
      ,sum(decode( pedo.di_ruolo 
	         ,'SI',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
					                ,1  
			        	      ),1  
			            )  
				  ,0  
			  )  
		   ) di_ruolo  
      ,sum(gp4gm.get_se_ASSENTE(pedo.ci,rido.DATA))             assenti  
      ,sum(gp4gm.get_se_incaricato(pedo.ci,rido.DATA))          incaricati  
      ,sum(decode( gp4_posi.get_ruolo(pedo.POSIZIONE)  
	              ,'NO',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
					                ,1  
			        	             ),1  
			                 )  
				       ,0  
			     )  
		  ) NON_RUOLO  
      ,sum(decode( pedo.contrattista 
	              ,'SI',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
					                ,1  
			        	             ),1  
			                 )  
				       ,0  
			     )  
		  ) contrattisti  
      ,sum(decode( pedo.sovrannumero 
	              ,'SI',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
					                ,1  
			        	             ),1  
			                 )  
				       ,0  
			     )  
		  ) sovrannumero 
--     ,count(ci)                                                                          numero  
	  ,round( decode( gp4_gest.get_ore_do(pedo.gestione)  
	         ,'U',sum( nvl( pedo.ore  
					             , gp4_cost.get_ore_lavoro( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                                 ) / gp4_cost.get_ore_lavoro_divisione( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                            )  
				 ,sum( nvl( pedo.ore  
                          ,gp4_cost.get_ore_lavoro( gp4_figi.GET_QUALIFICA(pedo.figura,pedo.dal),pedo.dal)  
                         )  
                     )  
					)  
	         ,1  
			) numero  
  from periodi_dotazione        pedo  
	  ,revisioni_dotazione      redo  
      ,riferimento_dotazione    rido  
 where pedo.rilevanza = 'Q'  
   and rido.data between pedo.dal  
                     and nvl(pedo.al,to_date(3333333,'j')) 
   and pedo.revisione=redo.revisione 
 group by rido.utente  
         ,rido.data  
         ,redo.revisione  
		 ,pedo.gestione  
         ,pedo.door_id 
         ,nvl(pedo.ore,pedo.ore_lavoro)
/
CREATE OR REPLACE FORCE VIEW DOTAZIONE_XORE_FATTO
(UTENTE, DATA, REVISIONE, DOOR_ID, GESTIONE, 
 ORE, NUM_PREV, ORE_PREV, EFFETTIVI, DI_RUOLO, 
 ASSENTI, INCARICATI, NON_RUOLO, CONTRATTISTI, SOVRANNUMERO, 
 NUMERO)
AS 
select rido.UTENTE  
      ,rido.data  
      ,redo.revisione  
      ,pedo.door_id door_id  
	  ,pedo.gestione  
      ,nvl(pedo.ore,pedo.ore_lavoro) ore  
      ,max(gp4_door.get_numero(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) num_prev  
      ,max(gp4_door.get_numero_ore(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) ore_prev  
      ,count(ci)                                                          effettivi  
      ,sum(decode(pedo.di_ruolo,'SI',1,0)) di_ruolo  
      ,sum(gp4gm.get_se_ASSENTE(pedo.ci,rido.DATA))             assenti  
      ,sum(gp4gm.get_se_incaricato(pedo.ci,rido.DATA))          incaricati  
      ,sum(decode(gp4_posi.get_ruolo(pedo.POSIZIONE),'NO',1,0)) NON_RUOLO  
      ,sum(decode(pedo.contrattista,'NO',1,0)) contrattisti  
      ,sum(decode(pedo.sovrannumero,'NO',1,0))    sovrannumeero 
      ,count(ci)                                                          numero  
  from periodi_dotazione        pedo  
	  ,revisioni_dotazione      redo  
      ,riferimento_dotazione    rido  
 where pedo.rilevanza = 'S'  
   and rido.data between pedo.dal  
                     and nvl(pedo.al,to_date(3333333,'j'))  
   and pedo.revisione=redo.revisione
 group by rido.utente  
         ,rido.data  
         ,redo.revisione  
	     ,pedo.gestione  
         ,pedo.door_id 
         ,nvl(pedo.ore,pedo.ore_lavoro)
/
CREATE OR REPLACE FORCE VIEW DOTAZIONE_XORE_FATTO_UE
(UTENTE, DATA, REVISIONE, DOOR_ID, GESTIONE, 
 ORE, NUM_PREV, ORE_PREV, EFFETTIVI, DI_RUOLO, 
 ASSENTI, INCARICATI, NON_RUOLO, CONTRATTISTI, SOVRANNUMERO, 
 NUMERO)
AS 
select rido.UTENTE  
      ,rido.data  
      ,redo.revisione  
      ,pedo.door_id door_id  
	  ,pedo.gestione  
      ,nvl(pedo.ore,pedo.ore_lavoro) ore  
      ,max(gp4_door.get_numero(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) num_prev  
      ,max(gp4_door.get_numero_ore(redo.revisione,gp4_pegi.get_pegi_door_id(pedo.ci,pedo.rilevanza,pedo.dal,redo.revisione))) ore_prev  
      ,round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                    ,'U',sum( nvl( pedo.ore  
					             , gp4_cost.get_ore_lavoro( pedo.qualifica,pedo.dal)  
                                 ) / gp4_cost.get_ore_lavoro_divisione( pedo.qualifica,pedo.dal)  
                            )  
					    ,count(ci)  
				   ),1  
			)			effettivi  
      ,sum(decode( pedo.di_ruolo  
	         ,'SI',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( pedo.qualifica,pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( pedo.qualifica,pedo.dal)  
					                ,1  
			        	      ),1  
			            )  
				  ,0  
			  )  
		   ) di_ruolo  
      ,sum(gp4gm.get_se_ASSENTE(pedo.ci,rido.DATA))             assenti  
      ,sum(gp4gm.get_se_incaricato(pedo.ci,rido.DATA))          incaricati  
      ,sum(decode( gp4_posi.get_ruolo(pedo.POSIZIONE)  
	              ,'NO',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( pedo.qualifica,pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( pedo.qualifica,pedo.dal)  
					                ,1  
			        	             ),1  
			                 )  
				       ,0  
			     )  
		  ) NON_RUOLO  
       ,sum(decode( pedo.contrattista  
	              ,'SI',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( pedo.qualifica,pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( pedo.qualifica,pedo.dal)  
					                ,1  
			        	             ),1  
			                 )  
				       ,0  
			     )  
		  ) CONTRATTISTI  
      ,sum(decode( pedo.sovrannumero  
	              ,'SI',round(decode( gp4_gest.get_ore_do(pedo.gestione)  
                                ,'U', nvl( pedo.ore  
					                         , gp4_cost.get_ore_lavoro( pedo.qualifica,pedo.dal)  
                                         ) / gp4_cost.get_ore_lavoro_divisione( pedo.qualifica,pedo.dal)  
					                ,1  
			        	             ),1  
			                 )  
				       ,0  
			     )  
		  ) SOVRANNUMERO  
	  ,round( decode( gp4_gest.get_ore_do(pedo.gestione)  
	         ,'U',sum( nvl( pedo.ore  
					             , gp4_cost.get_ore_lavoro( pedo.qualifica,pedo.dal)  
                                 ) / gp4_cost.get_ore_lavoro_divisione( pedo.qualifica,pedo.dal)  
                            )  
				 ,sum( nvl( pedo.ore  
                          ,gp4_cost.get_ore_lavoro( pedo.qualifica,pedo.dal)  
                         )  
                     )  
					)  
	         ,1  
			) numero  
  from periodi_dotazione        pedo  
	  ,revisioni_dotazione      redo  
      ,riferimento_dotazione    rido  
 where pedo.rilevanza = 'S'  
   and rido.data between pedo.dal  
                     and nvl(pedo.al,to_date(3333333,'j'))  
 group by rido.utente  
         ,rido.data  
         ,redo.revisione  
		 ,pedo.gestione  
         ,pedo.door_id 
         ,nvl(pedo.ore,pedo.ore_lavoro)
/