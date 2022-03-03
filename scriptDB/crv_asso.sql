CREATE OR REPLACE FORCE VIEW ASTENSIONI_SOSTITUIBILI
(CI_ASSENTE, NOMINATIVO_ASSENTE, RILEVANZA, ASSENZA, DES_ASSENZA, 
 DAL, AL, ORE_SOSTITUIBILI, CI_SOSTITUTO, NOMINATIVO_SOSTITUTO, 
 DAL_SOSTITUTO, AL_SOSTITUTO, ORE_SOSTITUZIONE, TIPO_ASSENZA)
AS 
select
        pegi.ci
       ,gp4_rain.get_nominativo(pegi.ci)  nominativo_assente
       ,pegi.rilevanza
	   ,pegi.assenza
	   ,gp4_aste.GET_DESCRIZIONE(pegi.assenza)                des_assenza
	   ,pegi.dal
	   ,pegi.al
       ,gp4do.get_ore_sostituibili(pegi.ci, pegi.dal)         ore_sostituibili
	   ,gp4do.get_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j'))) sostituto
	   ,gp4_rain.get_nominativo(gp4do.get_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j')))) nominativo_sostituto
	   ,gp4do.get_dal_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j'))) dal_sostituto
	   ,gp4do.get_al_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j')))   al_sostituto
       ,0 ore_sostituzione
       ,1 tipo_assenza -- assenze non sostituite
  from  periodi_giuridici pegi
 where  rilevanza            = 'A'
   and  exists
       (select 'x' from astensioni
	     where codice       = pegi.assenza
		   and sostituibile = 1
       )
   and not exists (select '1'
                   from sostituzioni_giuridiche
                   where titolare           = pegi.ci
                   and dal_astensione       = pegi.dal
                   and rilevanza_astensione = pegi.rilevanza
                   )
union
select
        pegi.ci
       ,gp4_rain.get_nominativo(pegi.ci)  nominativo_assente
       ,pegi.rilevanza
	   ,pegi.evento
	   ,'Incarico : '||gp4_evgi.GET_DESCRIZIONE(pegi.evento)  des_assenza
	   ,pegi.dal
	   ,pegi.al
       ,gp4do.get_ore_sostituibili(pegi.ci, pegi.dal)         ore_sostituibili
	   ,gp4do.get_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j'))) sostituto
	   ,gp4_rain.get_nominativo(gp4do.get_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j')))) nominativo_sostituto
	   ,gp4do.get_dal_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j'))) dal_sostituto
	   ,gp4do.get_al_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j')))   al_sostituto
       ,0 ore_sostituzione
       ,4 tipo_assenza -- incarico non sostituito
  from  periodi_giuridici pegi
  where  rilevanza            = 'I'
  and not exists (select '1'
                  from sostituzioni_giuridiche
                  where titolare           = pegi.ci
                  and dal_astensione       = pegi.dal
                  and rilevanza_astensione = pegi.rilevanza
                  )
union
select
        pegi.ci
       ,gp4_rain.get_nominativo(pegi.ci)  nominativo_assente
       ,pegi.rilevanza
	   ,pegi.assenza
	   ,gp4_aste.GET_DESCRIZIONE(pegi.assenza)                des_assenza
	   ,pegi.dal
	   ,pegi.al
       ,gp4do.get_ore_sostituibili(pegi.ci, pegi.dal)        ore_sostituibili
	   ,sogi.sostituto
       ,gp4_rain.get_nominativo(sogi.sostituto)||' '||
decode(gp4_posi.get_contratto_opera(gp4_pegi.get_posizione(sogi.sostituto, 'Q', sogi.dal)),'SI','( Contrattista )')  nominativo_sostituto
       ,sogi.dal - nvl(gp4_gest.GET_GG_SOST_ANTE_ASSENZA(pegi.gestione),0) dal_sostituto
       ,sogi.al  + nvl(gp4_gest.GET_GG_SOST_POST_ASSENZA(pegi.gestione),0) al_sostituto
       ,sogi.ore_sostituzione
       ,decode(gp4do.get_ore_sostituibili(sogi.titolare, sogi.dal_astensione),
               gp4do.get_ore_sostituite(sogi.titolare, sogi.dal_astensione, sogi.dal),
               decode(gp4_posi.get_contratto_opera(gp4_pegi.get_posizione(sogi.sostituto, 'Q', sogi.dal)),'SI', 7, 3),
               decode(gp4_posi.get_contratto_opera(gp4_pegi.get_posizione(sogi.sostituto, 'Q', sogi.dal)),'SI', 8, 2))
         -- assenze sostituite o parzialmente
               tipo_assenza
  from  periodi_giuridici pegi, sostituzioni_giuridiche sogi
 where  pegi.rilevanza = 'A'
   and  pegi.ci        = sogi.titolare
   and  pegi.dal       = sogi.dal_astensione
   and  pegi.rilevanza = sogi.rilevanza_astensione
   and  exists
       (select 'x' from astensioni
	     where codice       = pegi.assenza
		   and sostituibile = 1
       )
union
select
        pegi.ci
       ,gp4_rain.get_nominativo(pegi.ci)  nominativo_assente
       ,pegi.rilevanza
	   ,pegi.evento
	   ,'Incarico : '||gp4_evgi.GET_DESCRIZIONE(pegi.evento)  des_assenza
	   ,pegi.dal
	   ,pegi.al
       ,gp4do.get_ore_sostituibili(pegi.ci, pegi.dal) ore_sostituibili
       ,sogi.sostituto
       ,gp4_rain.get_nominativo(sogi.sostituto)||' '||
decode(gp4_posi.get_contratto_opera(gp4_pegi.get_posizione(sogi.sostituto, 'Q', sogi.dal)),'SI','( Contrattista )')  nominativo_sostituto
       ,sogi.dal - nvl(gp4_gest.GET_GG_SOST_ANTE_ASSENZA(pegi.gestione),0) dal_sostituto
       ,sogi.al  + nvl(gp4_gest.GET_GG_SOST_POST_ASSENZA(pegi.gestione),0) al_sostituto
       ,sogi.ore_sostituzione
       ,decode(gp4do.get_ore_sostituibili(sogi.titolare, sogi.dal_astensione),
                gp4do.get_ore_sostituite(sogi.titolare, sogi.dal_astensione, sogi.dal) ,
                decode(gp4_posi.get_contratto_opera(gp4_pegi.get_posizione(sogi.sostituto, 'Q', sogi.dal)),'SI', 9, 6),
                decode(gp4_posi.get_contratto_opera(gp4_pegi.get_posizione(sogi.sostituto, 'Q', sogi.dal)),'SI', 10, 5)
               )
        tipo_assenza -- incarichi sostituiti o parzialmente
  from  periodi_giuridici pegi, sostituzioni_giuridiche sogi
 where  pegi.rilevanza = 'I'
   and  pegi.ci        = sogi.titolare
   and  pegi.dal       = sogi.dal_astensione
   and  pegi.rilevanza = sogi.rilevanza_astensione
/


