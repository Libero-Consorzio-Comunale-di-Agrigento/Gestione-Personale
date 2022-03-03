CREATE OR REPLACE VIEW PERIODI_ASSENZA 
(  CI
 , RILEVANZA
 , GESTIONE
 , SPECIE
 , DAL
 , AL
 , RIFERIMENTO
 , ASSENZA
 , EVENTO
 , CAUSALE
 , VALORE
 , SEDE_DEL
 , ANNO_DEL
 , NUMERO_DEL
 , NOTE
 , UTENTE
 , DATA_AGG
 ) AS select  pegi.ci
          ,'GM'
          ,'G'
          ,'C'
          ,pegi.dal
          ,pegi.al
          ,pegi.al
          ,pegi.assenza
          ,pegi.evento
          ,to_char(null)  
          ,nvl(pegi.al,trunc(sysdate)) - pegi.dal + 1
          ,pegi.sede_del
          ,pegi.anno_del
          ,pegi.numero_del
          ,pegi.note
          ,pegi.utente
          ,pegi.data_agg
   from  periodi_giuridici     pegi
 where   pegi.rilevanza = 'A'
 union
select evpa.ci
         ,'AP'
         ,caev.gestione
         ,nvl(caev.specie,'C')
         ,evpa.dal
         ,nvl(evpa.al,trunc(sysdate))
         ,evpa.riferimento
         ,caev.assenza
         ,aste.evento
         ,evpa.causale
         ,decode ( caev.gestione
		          ,'H',round(evpa.valore / 60, 2) 
				  ,'O',round(evpa.valore / 60, 2)
				  ,evpa.valore
				 )
         ,to_char(null)
         ,to_number(null)
         ,to_number(null)
         ,evpa.note
         ,evpa.utente
         ,evpa.data_agg
  from     eventi_presenza           evpa
          ,astensioni                     aste
          ,causali_evento             caev
 where   evpa.causale            = caev.codice
     and caev.qualificazione   = 'A'
     and caev.assenza          = aste.codice (+)
     and (    caev.riferimento  = 'M'
           or caev.riferimento  = 'G'
          and not exists
	    ( select 'x'
	        from periodi_giuridici 
               where ci = evpa.ci
		 and rilevanza = 'A'
		 and nvl(al,trunc(sysdate)) >= evpa.dal
		 and dal             <= nvl(evpa.al,trunc(sysdate))
	    ) 
         )
/