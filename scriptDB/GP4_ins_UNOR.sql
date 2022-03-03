DECLARE
  tmpVar NUMBER;
  dep_ni number;
  dep_revisione number;
  integrity_error  exception;
  errno            integer;
  errmsg           char(200);
  dummy            integer;
  found            boolean;
  dep_ni_g         number;
  dep_ni_a         number;
  dep_ni_b         number;
  dep_ni_c         number;
BEGIN 
  dep_ni_g         := to_number(null);
  dep_ni_a         := to_number(null);
  dep_ni_b         := to_number(null);
  dep_ni_c         := to_number(null);
  dep_ni           := to_number(null);
    /* Determino il revisione attiva delle struttura organizzativa */
  begin
    select  revisione
   	  into  dep_revisione
   	  from  revisioni_struttura
   	 where  stato = 'A'
   	;
  	exception
      when no_data_found then
                  errno  := -20999;
                  errmsg := 'Non esiste alcuna Revisione di Struttura Organizzativa attiva';
                    raise integrity_error;
      when too_many_rows then
                  errno  := -20999;
                  errmsg := 'Esiste piu di una Revisione di Struttura Organizzativa attiva';
                    raise integrity_error;
  end;
  FOR GEST IN
     ( select  gest.CODICE                                 
              ,sett.DESCRIZIONE                            
              ,sett.DESCRIZIONE_AL1                        
              ,sett.DESCRIZIONE_AL2                        
              ,sett.NUMERO                          
              ,sett.SEQUENZA                               
              ,sett.SUDDIVISIONE                           
              ,sett.GESTIONE                               
              ,sett.ASSEGNABILE                            
              ,sett.SEDE                                   
              ,sett.COD_REG                                
	     from  settori  sett
                 , gestioni gest       
		where  sett.suddivisione = 0
                  and gest.codice = sett.gestione
	    order  by sequenza, gest.codice
     ) LOOP
	   /* Inserire la UO della GESTIONE */
	   -- 
          /* Determino il numero individuale del nuovo settore */
            select  indi_sq.nextval
        	  into  dep_ni_g
        	  from  dual
        	;
          /* Inserimento del soggetto anagrafico relativo alla nuova unità organizzativa */
	         insert into anagrafici
             ( NI
              ,COGNOME
              ,DAL
              ,UTENTE
              ,DATA_AGG
              ,DENOMINAZIONE
              ,TIPO_SOGGETTO
             )
      values ( dep_ni_g
              ,GEST.DESCRIZIONE
              ,to_date('01011900','ddmmyyyy')
              ,'Aut.SETT'
              ,sysdate
              ,GEST.DESCRIZIONE
              ,'S'
             )
      ;
        /* Inserisce l'Unita Organizzativa della Gestione (radice dell'albero) */
    	 insert into unita_organizzative
    	       ( ottica
    		    ,ni
    			,dal
    			,unita_padre
    			,unita_padre_ottica
    			,unita_padre_dal
    			,descrizione
                        ,descrizione_al1
                        ,descrizione_al2
    			,tipo
    			,suddivisione
    			,revisione
    			,utente
    			,data_agg
    		   )
    	  values
    	       ( 'GP4'
    		,dep_ni_g
                ,to_date('01011900','ddmmyyyy')
    	        ,0
    	        ,'GP4'
                ,to_date('01011900','ddmmyyyy')
                ,GEST.DESCRIZIONE
                ,GEST.DESCRIZIONE_AL1
                ,GEST.DESCRIZIONE_AL2
    		,'P'
    		,0
    		,dep_revisione
                ,'Aut.SETT'
                ,sysdate
               )
    	 ;
	 insert into gestioni_amministrative
	       ( CODICE
            ,NI
            ,DENOMINAZIONE
            ,GESTITO
            ,NOTE
            ,UTENTE
            ,DATA_AGG
		   )
	  values
	       ( gest.codice
		,dep_ni_g
                ,GEST.descrizione
		,'SI'
		,to_char(null)
                ,'Aut.UNOR'
                ,sysdate
           )
	 ;
        /* Inserisce il settore amministrativo della Gestione (radice dell'albero) */
          insert into settori_amministrativi
          ( numero
           ,ni
           ,codice
           ,denominazione
           ,denominazione_al1
	   ,denominazione_al2
           ,sequenza
           ,gestione
           ,assegnabile
           ,sede
           ,data_agg
           ,utente
          )
          values ( GEST.numero
                  ,dep_ni_g
            	  ,GEST.codice
            	  ,GEST.descrizione 
                  ,GEST.descrizione_al1
                  ,GEST.descrizione_al2
                  ,GEST.sequenza
            	  ,GEST.codice
            	  ,GEST.assegnabile
                  ,GEST.sede
            	  ,sysdate
            	  ,'Aut.SETT'
                 )
           ;
	   FOR SETT_A IN
	      (  select    CODICE                                 
                      ,DESCRIZIONE                            
                      ,DESCRIZIONE_AL1                        
                      ,DESCRIZIONE_AL2                        
                      ,NUMERO                          
                      ,SEQUENZA                               
                      ,SUDDIVISIONE                           
                      ,GESTIONE    
					  ,SETTORE_G                           
                      ,ASSEGNABILE                            
                      ,SEDE                                   
                      ,COD_REG                                
        	     from  settori
        		where  suddivisione = 1
				  and  settore_g    = GEST.NUMERO
        	    order  by sequenza,codice
		  ) LOOP
            -- Inserire la UO del settore A
          /* Determino il numero individuale del nuovo settore */
            select  indi_sq.nextval
        	  into  dep_ni_a
        	  from  dual
        	;
          /* Inserimento del soggetto anagrafico relativo alla nuova unità organizzativa */
	         insert into anagrafici
             ( NI
              ,COGNOME
              ,DAL
              ,UTENTE
              ,DATA_AGG
              ,DENOMINAZIONE
              ,TIPO_SOGGETTO
             )
      values ( dep_ni_a
              ,sett_a.DESCRIZIONE
              ,to_date('01011900','ddmmyyyy')
              ,'Aut.SETT'
              ,sysdate
              ,sett_a.DESCRIZIONE
              ,'S'
             )
      ;
        /* Inserisce l'Unita Organizzativa della Gestione (radice dell'albero) */
    	 insert into unita_organizzative
    	       ( ottica
    		    ,ni
    			,dal
    			,unita_padre
    			,unita_padre_ottica
    			,unita_padre_dal
    			,descrizione
                        ,descrizione_al1
                        ,descrizione_al2
    			,tipo
    			,suddivisione
    			,revisione
    			,utente
    			,data_agg
    		   )
    	  values
    	       ( 'GP4'
    		    ,dep_ni_a
                ,to_date('01011900','ddmmyyyy')
    			,dep_ni_g
    			,'GP4'
                ,to_date('01011900','ddmmyyyy')
                ,SETT_A.DESCRIZIONE
                ,SETT_A.DESCRIZIONE_AL1
                ,SETT_A.DESCRIZIONE_AL2
    			,'P'
    			,1
    			,dep_revisione
                ,'Aut.SETT'
                ,sysdate
               )
    	 ;
        /* Inserisce il settore amministrativo della Gestione (radice dell'albero) */
          insert into settori_amministrativi
          ( numero
           ,ni
           ,codice
           ,denominazione
           ,denominazione_al1
           ,denominazione_al2
           ,sequenza
           ,gestione
           ,assegnabile
           ,sede
           ,data_agg
           ,utente
          )
          values ( SETT_A.numero
                  ,dep_ni_a
            	  ,SETT_A.codice
            	  ,SETT_A.descrizione
                  ,SETT_A.descrizione_al1
                  ,SETT_A.descrizione_al2
                  ,SETT_A.sequenza
            	  ,GEST.codice
            	  ,SETT_A.assegnabile
                  ,SETT_A.sede
            	  ,sysdate
            	  ,'Aut.SETT'
                 )
           ;
			  FOR SETT_B in
			     ( select  CODICE                                 
                          ,DESCRIZIONE                            
                          ,DESCRIZIONE_AL1                        
                          ,DESCRIZIONE_AL2                        
                          ,NUMERO                          
                          ,SEQUENZA                               
                          ,SUDDIVISIONE                           
                          ,GESTIONE    
    					  ,SETTORE_G               
						  ,SETTORE_A            
                          ,ASSEGNABILE                            
                          ,SEDE                                   
                          ,COD_REG                                
            	     from  settori
            		where  suddivisione = 2
    				  and  settore_g    = GEST.NUMERO
					  and  settore_a    = SETT_A.numero
            	    order  by sequenza,codice
				 ) LOOP
				   -- Inserire la UO del settore B 
                  /* Determino il numero individuale del nuovo settore */
                    select  indi_sq.nextval
                	  into  dep_ni_b
                	  from  dual
                	;
                  /* Inserimento del soggetto anagrafico relativo alla nuova unità organizzativa */
        	         insert into anagrafici
                     ( NI
                      ,COGNOME
                      ,DAL
                      ,UTENTE
                      ,DATA_AGG
                      ,DENOMINAZIONE
                      ,TIPO_SOGGETTO
                     )
              values ( dep_ni_b
                      ,SETT_B.DESCRIZIONE
                      ,to_date('01011900','ddmmyyyy')
                      ,'Aut.SETT'
                      ,sysdate
                      ,SETT_B.DESCRIZIONE
                      ,'S'
                     )
              ;
                /* Inserisce l'Unita Organizzativa del settore B */
            	 insert into unita_organizzative
            	       ( ottica
            		    ,ni
            			,dal
            			,unita_padre
            			,unita_padre_ottica
            			,unita_padre_dal
            			,descrizione
                                ,descrizione_al1
                                ,descrizione_al2
            			,tipo
            			,suddivisione
            			,revisione
            			,utente
            			,data_agg
            		   )
            	  values
            	       ( 'GP4'
            		    ,dep_ni_b
                        ,to_date('01011900','ddmmyyyy')
            			,dep_ni_a
            			,'GP4'
                        ,to_date('01011900','ddmmyyyy')
                        ,SETT_B.DESCRIZIONE
                        ,SETT_B.DESCRIZIONE_AL1
                        ,SETT_B.DESCRIZIONE_AL2
            			,'P'
            			,2
            			,dep_revisione
                        ,'Aut.SETT'
                        ,sysdate
                       )
            	 ;
                /* Inserisce il settore amministrativo della Gestione (radice dell'albero) */
                  insert into settori_amministrativi
                  ( numero
                   ,ni
                   ,codice
                   ,denominazione
                   ,denominazione_al1
                   ,denominazione_al2
                   ,sequenza
                   ,gestione
                   ,assegnabile
                   ,sede
                   ,data_agg
                   ,utente
                  )
                  values ( SETT_B.numero
                          ,dep_ni_b
                    	  ,SETT_B.codice
                    	  ,SETT_B.descrizione
                          ,SETT_B.descrizione_al1
                          ,SETT_B.descrizione_al2
                          ,SETT_B.sequenza
                    	  ,GEST.codice
                    	  ,SETT_B.assegnabile
                          ,SETT_B.sede
                    	  ,sysdate
                    	  ,'Aut.SETT'
                         )
                   ;
        			  FOR SETT_C in
        			     ( select  CODICE                                 
                                  ,DESCRIZIONE                            
                                  ,DESCRIZIONE_AL1                        
                                  ,DESCRIZIONE_AL2                        
                                  ,NUMERO                          
                                  ,SEQUENZA                               
                                  ,SUDDIVISIONE                           
                                  ,GESTIONE    
            					  ,SETTORE_G               
        						  ,SETTORE_A  
								  ,SETTORE_B          
                                  ,ASSEGNABILE                            
                                  ,SEDE                                   
                                  ,COD_REG                                
                    	     from  settori
                    		where  suddivisione = 3
            				  and  settore_g    = GEST.NUMERO
        					  and  settore_a    = SETT_A.numero
							  and  settore_b    = SETT_B.numero
                    	    order  by sequenza,codice
        				 ) LOOP
          			 	   -- Inserire la UO del settore C 
                          /* Determino il numero individuale del nuovo settore */
                            select  indi_sq.nextval
                        	  into  dep_ni_c
                        	  from  dual
                        	;
                          /* Inserimento del soggetto anagrafico relativo alla nuova unità organizzativa */
                	         insert into anagrafici
                             ( NI
                              ,COGNOME
                              ,DAL
                              ,UTENTE
                              ,DATA_AGG
                              ,DENOMINAZIONE
                              ,TIPO_SOGGETTO
                             )
                      values ( dep_ni_c
                              ,SETT_C.DESCRIZIONE
                              ,to_date('01011900','ddmmyyyy')
                              ,'Aut.SETT'
                              ,sysdate
                              ,SETT_C.DESCRIZIONE
                              ,'S'
                             )
                      ;
                        /* Inserisce l'Unita Organizzativa del settore B */
                    	 insert into unita_organizzative
                    	       ( ottica
                    		    ,ni
                    			,dal
                    			,unita_padre
                    			,unita_padre_ottica
                    			,unita_padre_dal
                    			,descrizione
                    			,tipo
                    			,suddivisione
                    			,revisione
                    			,utente
                    			,data_agg
                    		   )
                    	  values
                    	       ( 'GP4'
                    		    ,dep_ni_c
                                ,to_date('01011900','ddmmyyyy')
                    			,dep_ni_b
                    			,'GP4'
                                ,to_date('01011900','ddmmyyyy')
                                ,SETT_C.DESCRIZIONE
                    			,'P'
                    			,3
                    			,dep_revisione
                                ,'Aut.SETT'
                                ,sysdate
                               )
                    	 ;
                        /* Inserisce il settore amministrativo della Gestione (radice dell'albero) */
                          insert into settori_amministrativi
                          ( numero
                           ,ni
                           ,codice
                           ,denominazione
                           ,denominazione_al1
                           ,denominazione_al2
                           ,sequenza
                           ,gestione
                           ,assegnabile
                           ,sede
                           ,data_agg
                           ,utente
                          )
                          values ( SETT_C.numero
                                  ,dep_ni_c
                            	  ,SETT_C.codice
                            	  ,SETT_C.descrizione
				  ,SETT_c.descrizione_al1
                                  ,SETT_c.descrizione_al2
                                  ,SETT_C.sequenza
                            	  ,GEST.codice
                            	  ,SETT_C.assegnabile
                                  ,SETT_C.sede
                            	  ,sysdate
                            	  ,'Aut.SETT'
                                 )
                           ;
                			  FOR SETT in
                			     ( select  CODICE                                 
                                          ,DESCRIZIONE                            
                                          ,DESCRIZIONE_AL1                        
                                          ,DESCRIZIONE_AL2                       
                                          ,NUMERO                          
                                          ,SEQUENZA                               
                                          ,SUDDIVISIONE                           
                                          ,GESTIONE    
                    					  ,SETTORE_G               
                						  ,SETTORE_A  
        								  ,SETTORE_B
										  ,SETTORE_C          
                                          ,ASSEGNABILE                            
                                          ,SEDE                                   
                                          ,COD_REG                                
                            	     from  settori
                            		where  suddivisione = 4
                    				  and  settore_g    = GEST.NUMERO
                					  and  settore_a    = SETT_A.numero
        							  and  settore_b    = SETT_B.numero
									  and  settore_c    = SETT_C.numero
                            	    order  by sequenza,codice
                				 ) LOOP
                  			 	   -- Inserire la UO del settore 
                                  /* Determino il numero individuale del nuovo settore */
                                    select  indi_sq.nextval
                                	  into  dep_ni
                                	  from  dual
                                	;
                                  /* Inserimento del soggetto anagrafico relativo alla nuova unità organizzativa */
                        	         insert into anagrafici
                                     ( NI
                                      ,COGNOME
                                      ,DAL
                                      ,UTENTE
                                      ,DATA_AGG
                                      ,DENOMINAZIONE
                                      ,TIPO_SOGGETTO
                                     )
                              values ( dep_ni
                                      ,SETT.DESCRIZIONE
                                      ,to_date('01011900','ddmmyyyy')
                                      ,'Aut.SETT'
                                      ,sysdate
                                      ,SETT.DESCRIZIONE
                                      ,'S'
                                     )
                              ;
                                /* Inserisce l'Unita Organizzativa del settore B */
                            	 insert into unita_organizzative
                            	       ( ottica
                            		    ,ni
                            			,dal
                            			,unita_padre
                            			,unita_padre_ottica
                            			,unita_padre_dal
                            			,descrizione
                                             	,descrizione_al1
						,descrizione_al2
                            			,tipo
                            			,suddivisione
                            			,revisione
                            			,utente
                            			,data_agg
                            		   )
                            	  values
                            	       ( 'GP4'
                            		    ,dep_ni
                                        ,to_date('01011900','ddmmyyyy')
                            			,dep_ni_c
                            			,'GP4'
                                        ,to_date('01011900','ddmmyyyy')
                                        ,SETT.DESCRIZIONE
					,SETT.DESCRIZIONE_AL1
                                        ,SETT.DESCRIZIONE_AL2
                            			,'P'
                            			,4
                            			,dep_revisione
                                        ,'Aut.SETT'
                                        ,sysdate
                                       )
                            	 ;
                                /* Inserisce il settore amministrativo del settore */
                                  insert into settori_amministrativi
                                  ( numero
                                   ,ni
                                   ,codice
                                   ,denominazione
                                   ,denominazione_al1
                                   ,denominazione_al2
                                   ,sequenza
                                   ,gestione
                                   ,assegnabile
                                   ,sede
                                   ,data_agg
                                   ,utente
                                  )
                                  values ( SETT.numero
                                          ,dep_ni
                                    	  ,SETT.codice
                                    	  ,SETT.descrizione
			                  ,SETT.descrizione_al1
                                          ,SETT.descrizione_al2
                                          ,SETT.sequenza
                                    	  ,GEST.codice
                                    	  ,SETT.assegnabile
                                          ,SETT.sede
                                    	  ,sysdate
                                    	  ,'Aut.SETT'
                                         )
                                   ;
                                   END LOOP;
                           END LOOP;
				   END LOOP;
		    END LOOP;
	   END LOOP;
/* Aggiornamento del codice_uo di UNOR con l'unico valore esistente */
  update unita_organizzative unor
     set codice_uo = (select codice 
                        from settori_amministrativi
                       where ni        = unor.ni
		     )
   where ottica     = 'GP4'
     and codice_uo is null
  ;
COMMIT;
END;
/
