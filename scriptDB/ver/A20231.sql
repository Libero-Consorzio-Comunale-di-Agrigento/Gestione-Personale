delete from pec_ref_codes
 where rv_domain = 'DENUNCIA_CUD.ANNOTAZIONI'
  and rv_low_value in ( 'AO_9', 'AO_10');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AO_9','AO', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'L'' addizionale comunale e'' stata interamente trattenuta.');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AO_10','AO', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'L'' addizionale comunale e'' stata trattenuta per un importo pari a Euro ');

start crp_peccnocu.sql