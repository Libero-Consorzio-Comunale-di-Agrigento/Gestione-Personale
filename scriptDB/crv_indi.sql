CREATE OR REPLACE VIEW individui
(
     ni
    ,cognome
    ,nome
    ,sesso
    ,data_nas
)
AS SELECT
       ni                                              
     , cognome                                         
     , nome
     , sesso                                            
     , data_nas                                        
FROM
    anagrafici  anag
 where al is null
;
