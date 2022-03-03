CREATE OR REPLACE TRIGGER PEGI_SOGI_TMA
 AFTER UPDATE of AL ON PERIODI_GIURIDICI
FOR EACH ROW
/******************************************************************************
   NAME:       PEGI_SOGI_TMA
   PURPOSE:    Registra la cessazione dell'individuo su SOSTITUZIONI_GIURIDICHE
               per poter gestire i subentri
   V2.1   del  12/02/2007
******************************************************************************/
declare
   subentrato       exception;
   errno            integer;
   d_ci             number(8);
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   d_di_ruolo       varchar2(2) := 'NO';
begin

   if :NEW.rilevanza = 'P' then
   
     BEGIN                                     /* Verifica se il cessato e' di ruolo. Se non e' di ruolo
	                                              non deve essere trattato */
         select RUOLO
    	   into d_di_ruolo
    	   from posizioni
    	  where codice = (select posizione
    	                    from periodi_dotazione pedo
    					   where ci        = :NEW.ci
    					     and rilevanza = 'Q'
							 and revisione = (select revisione
                                       from revisioni_dotazione
                                       where stato='A')
    						 and dal       = (select max(dal)
    						                    from periodi_dotazione
    										   where ci = :NEW.ci
    										     and rilevanza = 'Q'
    											 and dal <= nvl(:NEW.al,to_date(3333333,'j'))
    									     )
    					 )
    	 ;
	 EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
	 END;
     BEGIN
	 
	   if d_di_ruolo = 'SI' THEN
	 
    	   if :NEW.al is not null then             /* chiusura del periodo giuridico, indica una cessazione */
		   
    	      begin                                /* controlla se la nuova chiusura interseca un subentro 
    		                                          gia registrato. In questo caso esce segnalando il sostituto e
    												  la data di inizio del subentro */
        		     select gp4_rain.get_nominativo(:NEW.CI)||             
        			        ' e stato sostituito da '||
        					gp4_rain.get_nominativo(sostituto)||
        					' dal '||to_char(dal,'dd/mm/yyyy')
        			   into errmsg
        			   from sostituzioni_giuridiche
        			  where titolare              = :NEW.CI
        		        and rilevanza_astensione  = 'S'
						and dal_astensione        = :OLD.al
        				and sostituto            <> 0
    					and dal                  <= :NEW.al
        			 ;
        			 errno := -20006;
        			 raise subentrato;
        		  exception                                         /* se non e stato indicato alcun subentro, modifichiamo
    			                                                       l'eventuale registrazione gia presente per il CI del
    																   dimesso */
        		     when no_data_found then 
            		    update sostituzioni_giuridiche
            			   set dal_astensione = :NEW.AL
            		     where rilevanza_astensione = 'S'
            			   and titolare             = :NEW.CI
						   and dal_astensione       = :OLD.AL
            			;
            			if SQL%NOTFOUND then                       /* se si tratta di una nuova cessazione, inseriamo il record su 
    					                                              SOGI, indicando un subentrante indefinito (ci=0) */
                             insert into sostituzioni_giuridiche
                    		       ( sogi_id
                    			    ,titolare
                    			    ,dal_astensione
                    				,rilevanza_astensione
                    				,ore_sostituibili
                    				,sostituto
                    				,dal
                    				,rilevanza_sostituzione
                    				,ore_sostituzione
                                                ,utente
				                ,data_agg
                    			   ) 
                    		 select  sogi_sq.nextval
                    		        ,:NEW.CI
                    				,:NEW.AL
                    				,'S'
                    				,0
                    				,0
                    				,:NEW.AL + 1
                    				,'S'
                    				,0
                                                ,:NEW.UTENTE
                                                ,sysdate
                    		   from  dual
                    		  where  not exists
                    		        (select 'x'
                    				   from sostituzioni_giuridiche
                    				  where rilevanza_astensione   = 'S'
    								    and rilevanza_sostituzione = 'S'
                    				    and titolare               = :NEW.CI
										and dal_astensione         = :NEW.al
                    			    )
                    		  ; 
            			 end if;
    		  end;
    	   else /* riapertura del periodo, correzione di una precedente modifica. Elimina il record di SOGI
    	           se non abbiamo indicato un subentro.                                                      */ 
    		  begin
    		     select gp4_rain.get_nominativo(:NEW.CI)||
    			        ' e gia stato sostituito da '||gp4_rain.get_nominativo(sostituto)
    			   into errmsg
    			   from sostituzioni_giuridiche
    			  where titolare               = :NEW.CI
    		        and rilevanza_astensione   = 'S'
					and dal_astensione         = :OLD.AL
    				and rilevanza_sostituzione = 'S'
    				and sostituto             <> 0
    			 ;
    			 errno := -20006;
    			 raise subentrato;
    		  exception
    		     when no_data_found then 
            		  delete from sostituzioni_giuridiche
            		   where titolare               = :NEW.CI
            		     and rilevanza_astensione   = 'S'
    	 			     and rilevanza_sostituzione = 'S'
						 and dal_astensione         = :OLD.AL
            		  ;
    		  end;
    	   end if;
	   end if;  	    
     END;
   end if;
exception
		     when subentrato then 
                  IntegrityPackage.InitNestLevel;
                  raise_application_error(errno, errmsg);
end;
/
