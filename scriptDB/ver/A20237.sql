update detrazioni_fiscali
   set aumento = 200 * numero
     , importo = decode(greatest(numero,3)
                       , 3, importo
                          ,  importo - (200* numero))
 where dal = to_date('01012007','ddmmyyyy')
   and codice = 'AC' and tipo = 'FG'
   and not exists 
      (select 'x' from detrazioni_fiscali
        where nvl(aumento,0) != 0
          and codice = 'AC' and tipo = 'FG'
      )
;
update detrazioni_fiscali
   set aumento = 200 * numero
     , importo = decode(greatest(numero,3)
                       , 3, importo
                          ,  importo - (200* numero))
 where dal = to_date('01012007','ddmmyyyy')
   and codice = 'CC' and tipo = 'FG'
   and not exists 
      (select 'x' from detrazioni_fiscali
        where nvl(aumento,0) != 0
          and codice = 'CC' and tipo = 'FG'
      )
;
update detrazioni_fiscali
   set aumento = 200 * numero
     , importo = decode(greatest(numero,3)
                       , 3, importo
                          ,  importo - (200* numero))
 where dal = to_date('01012007','ddmmyyyy')
   and codice = 'CC' and tipo = 'FD'
   and not exists 
      (select 'x' from detrazioni_fiscali
        where nvl(aumento,0) != 0
          and codice = 'CC' and tipo = 'FD'
      )
;
update detrazioni_fiscali
   set aumento = 200 * numero
     , importo = decode(greatest(numero,3)
                       , 3, importo
                          ,  importo - (200* numero))
 where dal = to_date('01012007','ddmmyyyy')
   and codice = 'NC' and tipo = 'FD'
   and not exists 
      (select 'x' from detrazioni_fiscali
        where nvl(aumento,0) != 0
          and codice = 'NC' and tipo = 'FD'
      )
;
update detrazioni_fiscali
   set aumento = 100 * numero
     , importo = decode(greatest(numero,3)
                       , 3, importo
                          ,  importo - (100* numero))
 where dal = to_date('01012007','ddmmyyyy')
   and codice = 'NC' and tipo = 'FG'
   and not exists 
      (select 'x' from detrazioni_fiscali
        where nvl(aumento,0) != 0
          and codice = 'NC' and tipo = 'FG'
      )
;

-- contiene start anche per attivita 20236 - 18831.1

start crp_peccmore3.sql
start crp_peccmore_autofam.sql


