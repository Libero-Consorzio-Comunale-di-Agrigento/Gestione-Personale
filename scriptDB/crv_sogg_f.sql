REM
REM     SOGG - Soggetti che anno rapporto fiscale con l"ente
REM
PROMPT 
PROMPT Creating View SOGGETTI

CREATE OR REPLACE view soggetti
     ( soggetto
     , denominazione
     , denominazione_al1
     , denominazione_al2
     , codice_fiscale
     ) as
select prog
     , substr(cognome||'  '||nome,1)
     , substr(cognome||'  '||nome,1)
     , substr(cognome||'  '||nome,1)
     , codi_fiscale
  from f_soggetti
/ 

REM
REM  End of command file
REM
