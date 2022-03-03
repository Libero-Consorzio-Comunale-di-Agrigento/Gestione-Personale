CREATE OR REPLACE FORCE VIEW KEY_ERROR
(ERRORE, DESCRIZIONE, TIPO, KEY)
AS 
select errore
     , descrizione
     , decode(proprieta
             , 'S','I'
             , 'I','I'
             , 'B','E'
             , 'X','E'
                  ,'E'
             ) tipo
     , to_char(null) key
from a_errori
;