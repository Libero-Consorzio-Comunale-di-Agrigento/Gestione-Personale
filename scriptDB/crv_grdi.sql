CREATE OR REPLACE VIEW gruppi_disponibilita
(
     gruppo
    ,rilevanza
    ,descrizione
    ,descrizione_al1
    ,descrizione_al2
    ,note
    ,note_al1
    ,note_al2
    ,dal
    ,al
    ,sede
    ,anno
    ,numero
)
AS SELECT
       gruppo                                          
     , rilevanza                                       
     , descrizione, descrizione_al1, descrizione_al2   
     , note, note_al1, note_al2                        
     , dal                                             
     , al                                              
     , sede                                            
     , anno                                            
     , numero                                          
FROM
    gruppi_rapporto  grra
 where rilevanza in ('PPO','PGC')
;
