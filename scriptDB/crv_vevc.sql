CREATE OR REPLACE VIEW VISTA_ESVC_ANNI 
      (ESTRAZIONE             
      ,COLONNA                
      ,DAL                    
      ,AL                     
      ,DESCRIZIONE            
      ,DESCRIZIONE_AL1        
      ,DESCRIZIONE_AL2        
      ,SEQUENZA               
      ,NOTE                   
      ,MOLTIPLICA             
      ,ARROTONDA              
      ,DIVIDE                 
      ) AS 
select esvc.ESTRAZIONE             
      ,esvc.COLONNA                
      ,greatest(esvc.DAL
               ,to_date('0101'||mesi.anno,'ddmmyyyy')) dal
      ,least(nvl(AL,to_date('3112'||mesi.anno,'ddmmyyyy'))
            ,to_date('3112'||mesi.anno,'ddmmyyyy')) al                      
      ,esvc.DESCRIZIONE            
      ,esvc.DESCRIZIONE_AL1        
      ,esvc.DESCRIZIONE_AL2        
      ,esvc.SEQUENZA               
      ,esvc.NOTE                   
      ,esvc.MOLTIPLICA             
      ,esvc.ARROTONDA              
      ,esvc.DIVIDE                 
 from  mesi                        mesi
    ,  estrazione_valori_contabili esvc
where  mesi.mese = 1
  and  esvc.dal                                      <= to_date('3112'||mesi.anno,'ddmmyyyy')
  and  nvl(esvc.al,to_date(3333333,'j')) >= to_date('0101'||mesi.anno,'ddmmyyyy')
/
