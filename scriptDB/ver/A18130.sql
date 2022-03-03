alter table stati_civili 
add presenza_coniuge VARCHAR(2);

update stati_civili
set presenza_coniuge = 'SI'
where codice in ( 'CN' );

update stati_civili
set presenza_coniuge = 'NO'
where codice in ( 'SL', 'DV');

update stati_civili
set presenza_coniuge = ''
where  codice not in ( 'CN', 'SL', 'DV');

start crp_PECCCAFA.sql
