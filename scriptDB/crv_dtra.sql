create or replace view dip_trasferte
( ci
, cognome
, nome
, codice_fiscale
)
as
select rain.ci 
     , substr(rain.cognome,1,24) cognome
     , substr(rain.nome,1,20) nome
     , anag.codice_fiscale
  from anagrafici anag
     , rapporti_individuali rain
 where anag.ni = rain.ni
   and anag.al is null
   and rain.rapporto in (select codice from classi_rapporto
		          where presenza = 'SI')
   and exists (select 'x' from periodi_giuridici
		where rilevanza = 'P'
		  and ci = rain.ci)
/
