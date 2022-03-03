CREATE OR REPLACE VIEW rapporti_retributivi AS
 (SELECT
 		 ci                              
 		,matricola                       
 		,istituto                        
 		,sportello                       
 		,conto_corrente 
            ,COD_NAZIONE
                                ,CIN_EUR 
                                ,CIN_ITA 
 		,delega                          
 		,spese                           
 		,ulteriori                       
 		,posizione_inail                 
 		,data_inail                      
 		,trattamento                     
 		,codice_cpd                      
 		,posizione_cpd                   
 		,data_cpd                        
 		,codice_cps                      
 		,posizione_cps                   
 		,data_cps                        
 		,codice_inps                     
 		,codice_iad                      
 		,data_iad                        
 		,ci_erede                        
 		,quota_erede                     
 		,statistico1                     
 		,statistico2                     
 		,statistico3                     
 		,utente                          
 		,data_agg                        
 		,tipo_erede                      
 		,tipo_ulteriori                  
  FROM  RAPPORTI_RETRIBUTIVI_STORICI     RARS
 WHERE  rars.dal      =
       (select max(dal)
          from RAPPORTI_RETRIBUTIVI_STORICI     
         where ci       = rars.ci
       )
 ); 
	
		


