CREATE OR REPLACE view soggetti as 
select CODICE         
     , RAGIONE_SOCIALE
     , INDIRIZZO     
     , CAP          
     , PROVINCIA   
     , COMUNE     
     , TELEFONO  
     , CODICE_FISCALE   
     , PARTITA_IVA     
     , TELEX          
     , CATEGORIA     
     , TIPO_PAGAMENTO     
     , DATA_NASCITA      
     , SESSO            
     , PROVINCIA_NASCITA
     , COMUNE_NASCITA   
     , STATO_ESTERO    
     , ENTE_DATORE_LAV
     , DOMICILIO     
     , COMUNE_DOMICILIO        
     , PROVINCIA_DOMICILIO    
     , CAP_DOMICILIO         
  from ctfsan.ben
/
