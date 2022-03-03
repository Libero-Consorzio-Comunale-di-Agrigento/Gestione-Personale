update anagrafici 
set    denominazione = cognome
where  denominazione is null
and    tipo_soggetto = 'E'
;