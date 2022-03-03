delete from pec_ref_codes
 where rv_domain =  'DENUNCIA_ONAOSI.EVENTO' 
   AND rv_low_value in ('18','19')
/
insert into pec_ref_codes
       (rv_low_value,rv_meaning,rv_domain)
values ('18', 'Reddito complessivo per l''''anno di rif. < di 14000 euro (mod.1)','DENUNCIA_ONAOSI.EVENTO')
/
insert into pec_ref_codes
       (rv_low_value,rv_meaning,rv_domain)
values ('19', 'Reddito complessivo per l''''anno di rif. tra 14000 e 28000 euro (mod.1)','DENUNCIA_ONAOSI.EVENTO')
/
start crp_peccardo.sql
