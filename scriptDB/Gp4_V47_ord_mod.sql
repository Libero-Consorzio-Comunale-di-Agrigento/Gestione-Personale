update a_menu
set sequenza = decode( voce_menu
                      ,'PAMAM',10
                      ,'PGMGM',15
                      ,'PECEC',20
                      ,'PDODO',25
                      ,'PPAPA',30
                      ,'PPOPO',35
                      ,0)
where applicazione = 'GP4'
  and voce_menu in ('PAMAM','PGMGM','PECEC','PDODO','PPAPA','PPOPO')
/