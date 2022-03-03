INSERT INTO RAPPORTI_RETRIBUTIVI_STORICI 
SELECT
 	    RARE.CI                             
	   ,RAIN.DAL
	   ,RAIN.AL
	   ,RARE.MATRICOLA                      
	   ,RARE.ISTITUTO                         
	   ,RARE.SPORTELLO                      
	   ,RARE.CONTO_CORRENTE                 
	   ,RARE.DELEGA                         
	   ,RARE.SPESE                          
	   ,RARE.ULTERIORI                      
	   ,RARE.POSIZIONE_INAIL                
	   ,RARE.DATA_INAIL                     
	   ,RARE.TRATTAMENTO                    
	   ,RARE.CODICE_CPD                     
	   ,RARE.POSIZIONE_CPD                  
	   ,RARE.DATA_CPD                       
	   ,RARE.CODICE_CPS                     
	   ,RARE.POSIZIONE_CPS                  
	   ,RARE.DATA_CPS                       
	   ,RARE.CODICE_INPS                    
	   ,RARE.CODICE_IAD                     
	   ,RARE.DATA_IAD                       
	   ,RARE.CI_EREDE                       
	   ,RARE.QUOTA_EREDE                    
	   ,RARE.STATISTICO1                    
	   ,RARE.STATISTICO2                    
	   ,RARE.STATISTICO3                    
	   ,RARE.UTENTE                         
	   ,RARE.DATA_AGG                       
	   ,RARE.TIPO_EREDE                     
	   ,RARE.TIPO_ULTERIORI                 
  FROM  RAPPORTI_RETRIBUTIVI    RARE
       ,RAPPORTI_INDIVIDUALI    RAIN
 WHERE  RARE.CI    =   RAIN.CI
 ;
