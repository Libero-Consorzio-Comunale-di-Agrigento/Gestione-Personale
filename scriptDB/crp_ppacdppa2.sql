CREATE OR REPLACE PACKAGE ppacdppa2 IS
/******************************************************************************
 NOME:          PPACDPPA2
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
  PROCEDURE INSERT_4 (w_prenotazione in number, p_data in date);
END;
/
CREATE OR REPLACE PACKAGE BODY ppacdppa2 IS
  -- Periodi di Incarico sul Servizio (segmento = e)
	FORM_TRIGGER_FAILURE exception;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE INSERT_4 (w_prenotazione in number, p_data in date) IS
BEGIN
  insert  into DEPOSITO_PERIODI_PRESENZA
  ( prenotazione
  , data
  , ci
  , dal
  , al
  , ufficio
  , badge
  , sede
  , cod_sede
  , seq_sede
  , cartellino
  , gestione
  , matricola
  , gg_set
  , min_gg
  , ore_min_gg
  , minuti_min_gg
  , cdc
  , fattore_produttivo
  , assistenza
  , automatismo
  , rilevanza
  , inizio
  , segmento
  , evento
  , seq_evento
  , posizione
  , seq_posizione
  , ruolo
  , seq_ruolo
  , figura
  , cod_figura
  , seq_figura
  , attivita
  , seq_attivita
  , contratto
  , seq_contratto
  , qualifica
  , cod_qualifica
  , seq_qualifica
  , tipo_rapporto
  , ore
  , settore
  , cod_settore
  , seq_settore
  , funzionale
  , seq_funzionale
  , classe_rapporto
  , seq_classe_rapporto
  )
  select  w_prenotazione
  , p_data
  , rapa.ci
  , greatest( pein.dal
  , rapa.dal
  , cost.dal
  , qugi.dal
  , figi.dal
  )
  , decode  (least ( nvl(pein.al,to_date('3333333','j'))
 , nvl(rapa.al,to_date('3333333','j'))
 , nvl(cost.al,to_date('3333333','j'))
 , nvl(qugi.al,to_date('3333333','j'))
 , nvl(figi.al,to_date('3333333','j'))
 ),to_date('3333333','j'),null,
 least ( nvl(pein.al,to_date('3333333','j'))
 , nvl(rapa.al,to_date('3333333','j'))
 , nvl(cost.al,to_date('3333333','j'))
 , nvl(qugi.al,to_date('3333333','j'))
 , nvl(figi.al,to_date('3333333','j'))
 )
  )
  , rapa.ufficio
  , rapa.badge
  , nvl(rapa.sede,pein.sede)
  , sedi.codice
  , sedi.sequenza
  , rapa.cartellino
  , sett.gestione
  , rare.matricola
  , nvl(rapa.gg_set,trunc(cost.ore_lavoro/cost.ore_gg))
  , nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
 +round((cost.ore_gg
  * nvl(pein.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
 )
  , trunc(
  nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
 +round((cost.ore_gg
  * nvl(pein.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
 )
  / 60)
  , nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
 +round((cost.ore_gg
  * nvl(pein.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
 )
  -
  trunc(
  nvl(rapa.min_gg,trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 ) * 60
 +round((cost.ore_gg
  * nvl(pein.ore,cost.ore_lavoro)
  / cost.ore_lavoro
  - trunc(cost.ore_gg
 * nvl(pein.ore,cost.ore_lavoro)
 / cost.ore_lavoro
 )
  ) * 60
 )
 )
  / 60) * 60
  , nvl(rapa.cdc,rifu.cdc)
  , nvl(rapa.fattore_produttivo
 ,decode(pein.tipo_rapporto,'TD',qual.fattore_td
  ,qual.fattore
  )
 )
  , nvl(rapa.assistenza,trpr.assistenza)
  , rapa.automatismo
  , pein.rilevanza
  , pein.dal
  , 'e'
  , pein.evento
  , evgi.sequenza
  , pein.posizione
  , posi.sequenza
  , qugi.ruolo
  , ruol.sequenza
  , pein.figura
  , figi.codice
  , figu.sequenza
  , pein.attivita
  , atti.sequenza
  , qugi.contratto
  , cont.sequenza
  , pein.qualifica
  , qugi.codice
  , qual.sequenza
  , pein.tipo_rapporto
  , nvl(pein.ore,cost.ore_lavoro)
  , pein.settore
  , sett.codice
  , sett.sequenza
  , rifu.funzionale
  , clfu.sequenza
  , rain.rapporto
  , clra.sequenza
  from settori  sett
 , sedi sedi
 , ripartizioni_funzionali  rifu
 , contratti  cont
 , contratti_storici  cost
 , qualifiche_giuridiche  qugi
 , qualifiche qual
 , trattamenti_previdenziali  trpr
 , rapporti_retributivi rare
 , rapporti_individuali rain
 , classi_rapporto  clra
 , eventi_giuridici evgi
 , posizioni  posi
 , ruoli  ruol
 , figure figu
 , figure_giuridiche  figi
 , attivita atti
 , classificazioni_funzionali clfu
 , periodi_giuridici  pein
 , rapporti_presenza  rapa
 where pein.rilevanza = 'E'
 and sett.numero  = pein.settore
 and sedi.numero (+)  = pein.sede
 and rifu.settore = pein.settore
 and rifu.sede  = nvl(pein.sede,0)
 and cont.codice  = qugi.contratto
 and cost.contratto = qugi.contratto
 and qugi.numero  = qual.numero
 and qual.numero  = pein.qualifica
 and pein.figura  = figi.numero
 and pein.figura  = figu.numero
 and atti.codice (+)  = pein.attivita
 and ruol.codice  = qugi.ruolo
 and evgi.codice  = pein.evento
 and posi.codice  = pein.posizione
 and clfu.codice (+)  = rifu.funzionale
 and trpr.codice (+)  = rare.trattamento
 and rare.ci (+)  = pein.ci
 and pein.ci  = rapa.ci
 and rain.ci  = rapa.ci
 and clra.codice  = rain.rapporto
 and p_data  between greatest(pein.dal
  ,rapa.dal
  ,cost.dal
  ,qugi.dal
  ,figi.dal
  )
  and least(nvl(pein.al,to_date('3333333','j'))
 ,nvl(rapa.al,to_date('3333333','j'))
 ,nvl(cost.al,to_date('3333333','j'))
 ,nvl(qugi.al,to_date('3333333','j'))
 ,nvl(figi.al,to_date('3333333','j'))
 )
  ;
EXCEPTION
  WHEN OTHERS THEN
  RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

