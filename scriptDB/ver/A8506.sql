insert into centri_costo
( codice, descrizione )
select cdc, 'Centro:'||cdc
from ripartizioni_funzionali rifu
where cdc is not null
and not exists ( select 'x' from centri_costo
where codice = rifu.cdc )
/