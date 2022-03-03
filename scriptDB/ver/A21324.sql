update estrazione_valori_contabili 
   set sequenza = decode( colonna
                        , '01', 1
                        , '02', 2
                        , '03', 3
                        , '04', 4
                        , '05', 5
                        , '06', 6
                        , '07', 7
                        , '08', 8
                        , '09', 9
                        , '10', 10
                        , '11', 11
                        , '12', 12
                        , '13', 13
                              , 99
                        )
 where estrazione  = 'SMT_TAB8B'
   and sequenza is null
;