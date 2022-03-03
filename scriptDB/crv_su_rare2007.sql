create or replace view stampa_utente_rare2007 as
select rain.ci ci
     , substr(rain.cognome||'  '||rain.nome,1,50) nominativo
     , rare.tipo_spese
     , substr(ref1.RV_MEANING,1,30) des_tipo
     , rare.spese
     , rare.attribuzione_spese
     , substr(ref2.RV_MEANING,1,30) des_attribuzione
  from rapporti_retributivi rare
     , rapporti_individuali rain
     , pec_ref_codes ref1
     , pec_ref_codes ref2
where rain.ci   = rare.ci
  and exists (select 'x' from periodi_giuridici
               where ci = rare.ci
                 and nvl(al,to_date('3333333','j')) >=
                     to_date('01012007','ddmmyyyy')
             )
  and ref1.rv_domain(+) = 'DETRAZIONI_FISCALI.TIPO'
  and ref1.rv_low_value(+) = RARE.TIPO_SPESE
  and ref2.rv_domain(+) = 'RAPPORTI_RETRIBUTIVI.ATTRIBUZIONE_SPESE'
  and ref2.rv_low_value(+) = RARE.ATTRIBUZIONE_SPESE
  and (   RARE.ATTRIBUZIONE_SPESE is not null
       or nvl(RARE.TIPO_SPESE,' ') not in ('DD','DP') 
       or nvl(rare.spese,0) != 99
      )
/

create or replace view stampa_utente_rare2007_bis as
select rain.ci ci
     , substr(rain.cognome||'  '||rain.nome,1,50) nominativo
     , rare.tipo_spese
     , rare.spese
     , rare.attribuzione_spese
  from rapporti_retributivi rare
     , rapporti_individuali rain
where rain.ci   = rare.ci
  and exists (select 'x' from periodi_giuridici
               where ci = rare.ci
                 and nvl(al,to_date('3333333','j')) >=
                     to_date('01012007','ddmmyyyy')
             )
/
