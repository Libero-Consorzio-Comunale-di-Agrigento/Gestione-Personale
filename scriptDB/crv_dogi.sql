create or replace view documenti_giuridici as
select * 
  from archivio_documenti_giuridici ADOG
 where not exists (select 'x'
                     from a_oggetti
                    where oggetto = 'GP.EVENTO.PROTETTO.'||ADOG.EVENTO
	               AND   competenza.se_valore('GP.VISIONE.EVENTI','SI') = 0
                  )
;
