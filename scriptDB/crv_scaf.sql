CREATE OR REPLACE FORCE VIEW scaglioni_as_familiari
(dal, al, cod_scaglione) as
select distinct  dal, al, cod_scaglione 
from scaglioni_assegno_familiare
-- order by dal desc , cod_scaglione asc
;
