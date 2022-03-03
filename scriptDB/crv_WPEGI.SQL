create or replace view word_periodi_giuridici
( CI       
, RILEVANZA      
, DATA_ASSUNZIONE
, DATA_CESSAZIONE
, COD_ASSUNZIONE
, COD_CESSAZIONE
, DAL        
, AL             
, EVENTO     
, CERTIFICABILE  
, POSIZIONE    
, TIPO_RAPPORTO    
, SEDE_POSTO     
, ANNO_POSTO      
, NUMERO_POSTO 
, POSTO          
, SOSTITUTO       
, QUALIFICA        
, ORE             
, FIGURA           
, ATTIVITA      
, GESTIONE       
, SETTORE       
, SEDE              
, GRUPPO        
, ASSENZA         
, CONFERMATO     
, NOTE              
, NOTE_AL1      
, NOTE_AL2         
, SEDE_DEL           
, ANNO_DEL        
, NUMERO_DEL
, SEDE_ASS         
, ANNO_ASS        
, NUMERO_ASS
, SEDE_CESS           
, ANNO_CESS       
, NUMERO_CESS
, NOTE_P) as
select pegi.CI       
     , pegi.RILEVANZA
     , p.dal
     , p.al
     , p.evento
     , p.posizione      
     , pegi.DAL        
     , pegi.AL             
     , pegi.EVENTO       
     , evgi.certificabile
     , pegi.POSIZIONE    
     , pegi.TIPO_RAPPORTO    
     , pegi.SEDE_POSTO     
     , pegi.ANNO_POSTO      
     , pegi.NUMERO_POSTO 
     , pegi.POSTO          
     , pegi.SOSTITUTO       
     , pegi.QUALIFICA        
     , pegi.ORE             
     , pegi.FIGURA           
     , pegi.ATTIVITA      
     , pegi.GESTIONE       
     , pegi.SETTORE       
     , pegi.SEDE              
     , pegi.GRUPPO        
     , pegi.ASSENZA         
     , pegi.CONFERMATO     
     , pegi.NOTE              
     , pegi.NOTE_AL1      
     , pegi.NOTE_AL2         
     , pegi.SEDE_DEL           
     , pegi.ANNO_DEL        
     , pegi.NUMERO_DEL
     , p.SEDE_DEL           
     , p.ANNO_DEL        
     , p.NUMERO_DEL
     , p.SEDE_POSTO           
     , p.ANNO_POSTO      
     , p.NUMERO_POSTO
     , p.note
  from periodi_giuridici pegi
     , periodi_giuridici p
     , eventi_giuridici  evgi
 where p.ci = pegi.ci
   and p.rilevanza = 'P'
   and pegi.rilevanza != 'P'
   and pegi.dal between p.dal and nvl(p.al,to_date('3333333','j'))
   and evgi.codice = pegi.evento
/
 