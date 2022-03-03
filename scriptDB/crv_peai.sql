CREATE OR REPLACE VIEW periodi_assenza_inec (
 ci,                              
 rilevanza,                      
 dal,                             
 al,                              
 evento,                         
 posizione,                       
 tipo_rapporto,                   
 sede_posto,                      
 anno_posto,                      
 numero_posto,                   
 posto,                          
 sostituto ,                      
 qualifica,                      
 ore,                           
 figura,                          
 attivita,                        
 gestione,                        
 settore,                         
 sede,                            
 gruppo,                          
 assenza,                         
 confermato,                      
 note,                            
 note_al1,                        
 note_al2,                        
 sede_del,                        
 anno_del,                        
 numero_del,                      
 utente,                         
 data_agg,
 provenienza                        
) as 
  select ci, rilevanza, dal, al,  evento, posizione, tipo_rapporto,  sede_posto, anno_posto,  numero_posto,
            posto, sostituto, qualifica, ore,  figura, attivita, gestione, settore, sede, gruppo, assenza, confermato, 
			note, note_al1, note_al2, sede_del, anno_del, numero_del, utente, data_agg      
       , 'G'
  from periodi_giuridici
  where rilevanza = 'A'
  union
  select ci, 'A', dal , al ,evento, null, null, null,to_number(null), to_number(null), to_number(null), 
         to_number(null), to_number(null), to_number(null), to_number(null), null,
         null, to_number(null), to_number(null), null, assenza, 1, null, null, null, null, to_number(null),
		 to_number(null), utente, data_agg
        , 'B'
  from periodi_blocco;