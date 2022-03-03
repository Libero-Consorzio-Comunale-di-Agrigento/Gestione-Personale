alter table detrazioni_fiscali add AUMENTO number(15,5);

create table defi_ante_20236 as select * from detrazioni_fiscali;

update detrazioni_fiscali
   set importo = 690, aumento = importo - 690
 where dal = to_date('01012007','ddmmyyyy')
   and codice = 'CC' and tipo = 'CN' and scaglione in (11,12,13,14,15)
   and not exists 
      (select 'x' from detrazioni_fiscali
        where nvl(aumento,0) != 0
          and codice = 'CC'
      )
;

update detrazioni_fiscali
   set importo = 1338, aumento = importo - 1338
 where dal = to_date('01012007','ddmmyyyy')
   and codice = '*' and tipo = 'DD' and scaglione in (21,22,23,24,25)
   and not exists 
      (select 'x' from detrazioni_fiscali
        where nvl(aumento,0) != 0
          and codice = '*'
      )
;

start crp_gp4_defi.sql
start crp_gp4_rare.sql
-- start crp_peccmore_autofam.sql inclusa in A20237
start crp_peccmore12.sql
-- start crp_peccmore3.sql inclusa in A20237
start crf_rire_cambio_anno.sql

