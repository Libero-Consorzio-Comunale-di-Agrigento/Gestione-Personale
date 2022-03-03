alter table sportelli add modalita_pagamento number(1);

update sportelli set modalita_pagamento = decode( sportello
                                                , 'AC', '2'
                                                , 'ACNT', '3'
                                                        , '4')                                          
 where istituto = 'PC';

insert  into pec_ref_codes
       (rv_low_value,rv_domain,rv_meaning) 
values ('1','SPORTELLI.MODALITA_PAGAMENTO','Bonifico/giroconto');
insert  into pec_ref_codes
       (rv_low_value,rv_domain,rv_meaning) 
values ('2','SPORTELLI.MODALITA_PAGAMENTO','Assegno Circolare 1');
insert  into pec_ref_codes
       (rv_low_value,rv_domain,rv_meaning) 
values ('3','SPORTELLI.MODALITA_PAGAMENTO','Assegno Circolare non Trasferibile 2');
insert  into pec_ref_codes
       (rv_low_value,rv_domain,rv_meaning) 
values ('4','SPORTELLI.MODALITA_PAGAMENTO','Assegno di Quietanza 3 (F.A.D.)');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) values ('P_ACCREDITI_CSTVB','A','','Solo Assegni e Pronta Cassa');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) values ('P_ACCREDITI_CSTVB','X','','Solo Accrediti in c/c');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

delete from a_selezioni where voce_menu = 'PECCSTVB'
   and parametro ='P_ACCREDITI'; 

delete from a_selezioni where voce_menu = 'PECCSTVB'
   and parametro ='P_ACCREDITI'; 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ACCREDITI','PECCSTVB','4','Solo Accrediti','1','U','N','X','P_ACCREDITI_CSTVB','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ACCREDITI','PECCSTVB','4','Solo Accrediti','1','U','N','X','P_ACCREDITI_CSTVB','','','');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

start crp_peccstvb.sql
start crp_peccsbrf.sql

