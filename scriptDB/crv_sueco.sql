create or replace view stampa_utente_esenti_comunale
( ci
, nominativo
, comune
, esenzione
, no_esenzione
, acconto
, reddito
) AS
select rain.ci,max(rain.cognome||'  '||rain.nome) nominativo
     , max(comu.descrizione||' ('||comu.sigla_provincia||')') comune
     , max(adic.esenzione) esenzione
     , max(inex.rinuncia_esenzione_add_com) no_esenzione
     , max(inre.imp_tot) acconto
     , greatest( nvl(sum(ipn_ac),0) - sum(nvl(ded_con_ac,0)+nvl(ded_fig_ac,0)+nvl(ded_alt_ac,0))
               , 0
               ) reddito
  from progressivi_fiscali         prfi
     , comuni                      comu
     , informazioni_extracontabili inex
     , informazioni_retributive    inre
     , addizionale_irpef_comunale  adic
     , anagrafici                  anag
     , rapporti_individuali        rain
     , riferimento_retribuzione    rire
 where rire.rire_id = 'RIRE'
   and prfi.anno    = rire.anno - 1
   and prfi.ci      = rain.ci
   and prfi.mese    = 12
   and prfi.mensilita =
      (select max(mensilita) from mensilita
        where mese = 12
          and tipo in ('S','N','A'))
   and anag.ni      = rain.ni
   and to_date('0101'||rire.anno,'ddmmyyyy') between anag.dal
                                                 and nvl(anag.al,to_date('3333333','j'))
   and comu.COD_PROVINCIA (+) = anag.provincia_res
   and comu.cod_comune    (+) = anag.comune_res
   and adic.COD_PROVINCIA (+) = anag.provincia_res
   and adic.cod_comune    (+) = anag.comune_res
   and to_date('0101'||rire.anno,'ddmmyyyy') between adic.dal
                                                 and nvl(adic.al,to_date('3333333','j'))
   and inre.ci            (+) = rain.ci
   and inre.voce          (+) = 'ADD.COM.AC'
   and inre.sub           (+) = '07'
   and inex.anno              = rire.anno
   and inex.ci                = rain.ci
group by rain.ci
having greatest( nvl(sum(ipn_ac),0) - sum(nvl(ded_con_ac,0)+nvl(ded_fig_ac,0)+nvl(ded_alt_ac,0))
               , 0
               ) <= max(adic.esenzione)
   and nvl(max(inre.imp_tot),0) != 0
/
