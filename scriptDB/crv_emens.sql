SET SCAN OFF
REM
REM VIEW
REM     VISTA_DENUNCIA_EMENS
REM     DENUNCIA I.N.P.S. EMENS
REM     creazione della vista dettagliata con la suddivisione per anno mese e periodo di denuncia
REM

PROMPT 
PROMPT Creating View VISTA_DENUNCIA_EMENS

CREATE OR REPLACE VIEW VISTA_DENUNCIA_EMENS
as select 
   demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , demi.rettifica
 , decode(demi.rettifica,'E','S',null)                                      elimina
 , decode(demi.rettifica
         ,'E', null
             , decode( demi.rilevanza, 'P', 'S'))                           tipo_consolidamento
 , gest.codice                                                              gestione
 , anag1.codice_fiscale                                                     cf_mittente_fisico
 , gest.codice_fiscale                                                      cf_mittente
 , gest.nome                                                                ragione_sociale 
 , nvl(ente.cf_software,gest.codice_fiscale)                                cf_software
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')    sede_inps
 , demi.anno, demi.mese
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
                                                                            periodo
 , gest.codice_fiscale                                                      cf_azienda  
 , gest.nome                                                                ragione_sociale_azienda
 , decode(demi.specie_rapporto, 'DIP', substr(gest.posizione_inps,1,10), null)
                                                                            posizione_dm
 , decode(demi.specie_rapporto, 'DIP', gest.csc_dm10, null)                 csc
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,1,2), null)          ca1
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,3,2), null)          ca2
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,5,2), null)          ca3
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,7,2), null)          ca4
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,9,2), null)          ca5
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,11,2), null)         ca6
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,13,2), null)         ca7
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,15,2), null)         ca8
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,17,2), null)         ca9
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,19,2), null)         ca10
 , anag.codice_fiscale                                                      cfis_lavoratore
 , substr(anag.cognome,1,30)                                                cognome
 , substr(anag.nome,1,20)                                                   nome
 , decode(demi.specie_rapporto, 'DIP', demi.qualifica1, null )                         qualifica1
 , decode(demi.specie_rapporto, 'DIP', decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica2 ), null ) qualifica2
 , decode(demi.specie_rapporto, 'DIP', decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica3 ), null ) qualifica3
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_contribuzione, null )                 tipo_contribuzione
 , nvl(demi.codice_catasto,comu1.codice_catasto)                                       codice_comune
 , decode(demi.specie_rapporto, 'DIP', demi.codice_contratto, null)                    codice_contratto
 , decode(demi.specie_rapporto, 'DIP', demi.giorno_assunzione, null)                   giorno_assunzione
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_assunzione, null)                     tipo_assunzione
 , decode(demi.specie_rapporto, 'DIP', demi.giorno_cessazione, null)                   giorno_cessazione
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_cessazione, null)                     tipo_cessazione
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_lavoratore, null)                     tipo_lavoratore
 , max(demi2.imponibile)                                                               imponibile
 , max(decode(demi.specie_rapporto, 'DIP', demi2.giorni_retribuiti, null))             giorni_retribuiti
 , max(decode(demi.specie_rapporto, 'DIP', least(demi2.settimane_utili*100,600), null)) settimane_utili
 , decode(demi.specie_rapporto, 'DIP', null, aliquota*100)                             aliquota
 , decode(demi.specie_rapporto, 'DIP', vaie.anno_rif , null)                           anno_rif_var
 , decode(demi.specie_rapporto, 'DIP', to_char(vaie.dal,'mm'), null )                  mese_dal
 , decode(demi.specie_rapporto, 'DIP', to_char(vaie.al,'mm'),null)                     mese_al
 , sum(round(decode(demi.specie_rapporto, 'DIP', vaie.aum_imponibile, null)))          aum_imponibile
 , sum(round(decode(demi.specie_rapporto, 'DIP', vaie.dim_imponibile, null)))          dim_imponibile
 , decode(demi.specie_rapporto, 'DIP', sett.id_settimana, null )                       id_settimana
 , decode(demi.specie_rapporto, 'DIP', sett.tipo_copertura, null )                     tipo_copertura
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento1, null )                     codice_evento1
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento2, null )                     codice_evento2
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento3, null )                     codice_evento3
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento4, null )                     codice_evento4
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento5, null )                     codice_evento5
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento6, null )                     codice_evento6
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento7, null )                     codice_evento7
 , decode(demi.specie_rapporto, 'DIP', sett3.codice, null )                            codice_evento_tot
 , decode(demi.specie_rapporto, 'DIP', decode(sett3.diff_accredito,0,null,sett3.diff_accredito ), null ) 
                                                                                       diff_accredito_tot
 , decode(demi.specie_rapporto, 'DIP', decode(sett3.sett_accredito,0,null,sett3.sett_accredito ), null )
                                                                                       sett_accredito_tot
 , sum(round(decode(demi.specie_rapporto, 'DIP', dapa1.ipn_preavviso )))               ipn_preavviso
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_preavviso )                           dal_preavviso
 , decode(demi.specie_rapporto, 'DIP', dapa1.al_preavviso )                            al_preavviso
 , sum(decode(demi.specie_rapporto, 'DIP', dapa1.sett_preavviso ))                     sett_preavviso
 , sum(decode(demi.specie_rapporto, 'DIP', least(dapa1.sett_utili_preavviso*100,600))) sett_utili_preavviso
 , sum(round(decode(demi.specie_rapporto, 'DIP', dapa1.ipn_bonus )))                   ipn_bonus
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_bonus )                               dal_bonus
 , decode(demi.specie_rapporto, 'DIP', dapa1.tipo_estero )                             tipo_estero
 , sum(round(decode(demi.specie_rapporto, 'DIP', dapa1.ipn_estero )))                  ipn_estero
 , sum(round(decode(demi.specie_rapporto, 'DIP', dapa1.ipn_atipica )))                 ipn_atipica
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_atipica )                             dal_atipica 
 , decode(demi.specie_rapporto, 'DIP', dapa1.al_atipica)                               al_atipica
 , decode(demi.specie_rapporto, 'DIP', dapa1.sett_atipica)                             sett_atipica
 , decode(demi.specie_rapporto, 'DIP', dapa1.anno_sindacali)                           anno_sindacali
 , sum(round(decode(demi.specie_rapporto, 'DIP', dapa1.ipn_sindacali)))                ipn_sindacali
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_sindacali)                            dal_sindacali
 , decode(demi.specie_rapporto, 'DIP', dapa1.al_sindacali)                             al_sindacali
 , decode(demi.specie_rapporto,'DIP',demi.tab_anf, null)                               tab_anf
 , decode(demi.specie_rapporto,'DIP',demi.num_anf, null)                               num_anf 
 , decode(demi.specie_rapporto,'DIP',demi.classe_anf, null)                            classe_anf
 , decode(demi.specie_rapporto, 'DIP', demi.tfr, null )                                tfr
 , decode(demi.specie_rapporto, 'DIP', null, gest.cap )                                cap
 , decode(demi.specie_rapporto, 'DIP', null, lpad(gest.codice_attivita,5,'0'))         istat
 , decode(demi.specie_rapporto, 'COCO', demi.tipo_rapporto, null )                     tipo_rapporto
 , decode(demi.specie_rapporto, 'COCO', demi.cod_attivita, null )                      cod_attivita
 , decode(demi.specie_rapporto, 'COCO', demi.altra_ass, null )                         altra_ass
 , decode(demi.specie_rapporto, 'DIP', null, to_char(demi.dal,'yyyy-mm-dd') )          dal
 , decode(demi.specie_rapporto, 'DIP', null, to_char(demi.al,'yyyy-mm-dd') )           al
 , sum(decode(demi.specie_rapporto, 'COCO', demi.imp_agevolazione, null))              imp_agevolazione
 , decode(demi.specie_rapporto, 'COCO', demi.tipo_agevolazione, null)                  tipo_agevolazione
 , decode(demi.specie_rapporto, 'DIP', demi.cod_calamita, null )                       cod_calamita
 , sum(decode(demi.specie_rapporto, 'DIP', fose1.retr_pens , null))                    retr_pens_tot
 , sum(decode(demi.specie_rapporto, 'DIP', fose1.gg_non_retr , null))                  gg_non_retr
 , decode(demi.specie_rapporto, 'DIP', fose1.anno_rif, null)                           anno_rif
 , sum(decode(demi.specie_rapporto, 'DIP', fose1.arretrati, null))                     retr_pens_arr
 , decode(demi.specie_rapporto, 'DIP', fose1.dal,null)                                 dal_fondi
 , decode(demi.specie_rapporto, 'DIP', fose1.al,null)                                  al_fondi
 , sum(decode(demi.specie_rapporto, 'DIP', fose1.contr_sind, null))                    retr_pens_sind
 , sum(nvl(gete.base_calcolo,0)*100)                                                   base_calcolo_tfr
 , sum(gete.base_calcolo_prev_compl*100)                                               base_calcolo_prev_compl
 , sum(nvl(round(gete.imp_corrente),0))                                                importo_corrente
 , sum(nvl(round(gete.imp_pregresso),0))                                               importo_pregresso
 , sum(nvl(round(gete.imp_liquidazione),0))                                            importo_liquidazione
 , sum(nvl(round(gete.imp_anticipazione),0))                                           importo_anticipazione
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')                                              data_scelta
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')                                            data_adesione
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100                                                           quota_prev_compl
from ente
   , denuncia_emens              demi
   , rapporti_individuali        rain
   , rapporti_individuali        rain1
   , anagrafici                  anag
   , anagrafici                  anag1
   , gestioni                    gest
   , comuni                      comu1
   , settimane_emens             sett
   , variabili_emens             vaie
   , gestione_tfr_emens          gete
   , ( select demi1.deie_id
            , demi1.riferimento
            , sum(imponibile) imponibile
            , sum(giorni_retribuiti) giorni_retribuiti
            , sum(settimane_utili) settimane_utili
      from denuncia_emens demi1
     group by demi1.deie_id, demi1.riferimento
      ) demi2
   , ( select dapa.deie_id
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.imponibile, null ),0))     ipn_preavviso
            , max(decode(dapa.identificatore, 'PREAVVISO',to_char(dapa.dal,'yyyy-mm-dd'),null))
                                                                                              dal_preavviso
            , max(decode(dapa.identificatore, 'PREAVVISO',to_char(dapa.al,'yyyy-mm-dd'),null))
                                                                                              al_preavviso
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.num_settimane, null ),0))  sett_preavviso
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.settimane_utili, null ),0)) sett_utili_preavviso
            , sum(nvl(decode(dapa.identificatore, 'BONUS',dapa.imponibile, null ),0))         ipn_bonus
            , max(decode(dapa.identificatore, 'BONUS',to_char(dapa.dal,'yyyy')||'-'||to_char(dapa.dal,'mm'), null ))
                                                                                              dal_bonus
            , max(decode(dapa.identificatore, 'ESTERO','04',null))                            tipo_estero
            , sum(nvl(decode(dapa.identificatore, 'ESTERO',dapa.imponibile, null ),0))        ipn_estero
            , sum(nvl(decode(dapa.identificatore, 'ATIPICA',dapa.imponibile, null ) ,0))      ipn_atipica
            , max(decode(dapa.identificatore, 'ATIPICA',to_char(dapa.dal,'yyyy-mm-dd'),null))
                                                                                              dal_atipica
            , max(decode(dapa.identificatore, 'ATIPICA',to_char(dapa.al,'yyyy-mm-dd'),null))
                                                                                              al_atipica
            , sum(nvl(decode(dapa.identificatore, 'ATIPICA',dapa.num_settimane, null ),0))    sett_atipica
            , max(decode(dapa.identificatore, 'SINDACALI',dapa.anno_rif, to_number(null)))    anno_sindacali
            , sum(nvl(decode(dapa.identificatore, 'SINDACALI',dapa.imponibile, null ),0))     ipn_sindacali
            , max(decode(dapa.identificatore, 'SINDACALI', '--'||to_char(dapa.dal,'mm-dd'),null))
                                                                                              dal_sindacali
            , max(decode(dapa.identificatore, 'SINDACALI','--'||to_char(dapa.al,'mm-dd'),null))
                                                                                              al_sindacali
      from dati_particolari_emens      dapa
     group by  dapa.deie_id
      ) dapa1
   , ( select  fose.deie_id
             , sum(nvl(fose.retr_pens,0))       retr_pens
             , sum(nvl(fose.gg_non_retr,0))     gg_non_retr
             , fose.anno_rif                    anno_rif
             , sum(nvl(fose.arretrati,0))       arretrati
             , to_char(fose.dal,'mm')           dal
             , to_char(fose.al,'mm')            al
             , sum(nvl(fose.contr_sind,0))      contr_sind
         from  fondi_speciali_emens fose
        group by fose.deie_id, fose.anno_rif
               , to_char(fose.dal,'mm') , to_char(fose.al,'mm')
     )        fose1
   , ( select sett1.deie_id
            , max(sett2.id_settimana) id_settimana2
            , substr(ltrim(rtrim(peco.rv_low_value)),1,3) codice
            , sum( nvl(decode(sett1.codice_evento1, peco.rv_low_value, sett1.diff_accredito1, null),0)
                 + nvl(decode(sett1.codice_evento2, peco.rv_low_value, sett1.diff_accredito2, null),0)
                 + nvl(decode(sett1.codice_evento3, peco.rv_low_value, sett1.diff_accredito3, null),0)
                 + nvl(decode(sett1.codice_evento4, peco.rv_low_value, sett1.diff_accredito4, null),0)
                 + nvl(decode(sett1.codice_evento5, peco.rv_low_value, sett1.diff_accredito5, null),0)
                 + nvl(decode(sett1.codice_evento6, peco.rv_low_value, sett1.diff_accredito6, null),0)
                 + nvl(decode(sett1.codice_evento7, peco.rv_low_value, sett1.diff_accredito7, null),0)
                 ) diff_accredito
            , sum( nvl(decode(sett1.codice_evento1, peco.rv_low_value, sett1.sett_accredito1, null),0)
                 + nvl(decode(sett1.codice_evento2, peco.rv_low_value, sett1.sett_accredito2, null),0)
                 + nvl(decode(sett1.codice_evento3, peco.rv_low_value, sett1.sett_accredito3, null),0)
                 + nvl(decode(sett1.codice_evento4, peco.rv_low_value, sett1.sett_accredito4, null),0)
                 + nvl(decode(sett1.codice_evento5, peco.rv_low_value, sett1.sett_accredito5, null),0)
                 + nvl(decode(sett1.codice_evento6, peco.rv_low_value, sett1.sett_accredito6, null),0)
                 + nvl(decode(sett1.codice_evento7, peco.rv_low_value, sett1.sett_accredito7, null),0)
                 ) sett_accredito
  from settimane_emens sett1
     , pec_ref_codes peco
     , settimane_emens sett2
 where peco.rv_domain = 'SETTIMANE_EMENS.CODICE_EVENTO'
   and ( sett1.codice_evento1 = peco.rv_low_value
    or   sett1.codice_evento2 = peco.rv_low_value
    or   sett1.codice_evento3 = peco.rv_low_value
    or   sett1.codice_evento4 = peco.rv_low_value
    or   sett1.codice_evento5 = peco.rv_low_value
    or   sett1.codice_evento6 = peco.rv_low_value
    or   sett1.codice_evento7 = peco.rv_low_value
       )
   and sett1.ci = sett2.ci
   and sett1.anno = sett2.anno
   and sett1.mese = sett2.mese
   and sett1.dal = sett2.dal
group by  sett1.deie_id
        , peco.rv_low_value
     ) sett3
where gest.comune_res    = comu1.cod_comune
  and gest.provincia_res = comu1.cod_provincia
  and anag.ni            = rain.ni
  and anag1.ni           = rain1.ni
  and rain1.ci           = gest.mittente_emens
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag.dal and nvl(anag.al,to_date('3333333','j'))
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag1.dal and nvl(anag1.al,to_date('3333333','j'))
  and demi.ci            = rain.ci
  and gest.codice        = nvl(demi.gestione_alternativa,demi.gestione)
  and demi.deie_id       = sett.deie_id (+)
  and demi.deie_id       = demi2.deie_id (+)
  and demi.riferimento   = demi2.riferimento (+)
  and demi.deie_id       = dapa1.deie_id (+)
  and demi.deie_id       = vaie.deie_id (+)
  and demi.deie_id       = gete.deie_id (+)
  and demi.deie_id       = fose1.deie_id (+)
  and sett.deie_id       = sett3.deie_id (+)
  and sett.id_settimana  = sett3.id_settimana2 (+)
group by demi.ci , demi.specie_rapporto , demi.rilevanza , demi.rettifica
 , decode(demi.rettifica,'E','S',null) , decode(demi.rettifica,'E',null, demi.rettifica)
 , gest.codice , anag1.codice_fiscale  , gest.codice_fiscale , gest.nome
 , nvl(ente.cf_software,gest.codice_fiscale)
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')
 , demi.anno, demi.mese
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,0))
 , gest.codice_fiscale , gest.nome
 , decode(demi.specie_rapporto, 'DIP', substr(gest.posizione_inps,1,10), null)
 , decode(demi.specie_rapporto, 'DIP', gest.csc_dm10, null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,1,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,3,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,5,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,7,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,9,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,11,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,13,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,15,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,17,2), null)
 , decode(demi.specie_rapporto, 'DIP', substr(aut_dm10,19,2), null)
 , anag.codice_fiscale , substr(anag.cognome,1,30) , substr(anag.nome,1,20)
 , decode(demi.specie_rapporto, 'DIP', demi.qualifica1, null )
 , decode(demi.specie_rapporto, 'DIP', decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica2 ), null )
 , decode(demi.specie_rapporto, 'DIP', decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica3 ), null )
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_contribuzione, null )
 , nvl(demi.codice_catasto,comu1.codice_catasto)  
 , decode(demi.specie_rapporto, 'DIP', demi.codice_contratto, null)
 , decode(demi.specie_rapporto, 'DIP', demi.giorno_assunzione, null)
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_assunzione, null)
 , decode(demi.specie_rapporto, 'DIP', demi.giorno_cessazione, null)
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_cessazione, null)
 , decode(demi.specie_rapporto, 'DIP', demi.tipo_lavoratore, null)
 , decode(demi.specie_rapporto, 'DIP', null, aliquota*100)
 , decode(demi.specie_rapporto, 'DIP', vaie.anno_rif , null)
 , decode(demi.specie_rapporto, 'DIP', to_char(vaie.dal,'mm'), null )
 , decode(demi.specie_rapporto, 'DIP', to_char(vaie.al,'mm'),null)
 , decode(demi.specie_rapporto, 'DIP', sett.id_settimana, null )
 , decode(demi.specie_rapporto, 'DIP', sett.tipo_copertura, null )
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento1, null )
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento2, null )
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento3, null )
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento4, null )
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento5, null )
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento6, null )
 , decode(demi.specie_rapporto, 'DIP', sett.codice_evento7, null )
 , decode(demi.specie_rapporto, 'DIP', sett3.codice, null )
 , decode(demi.specie_rapporto, 'DIP', decode(sett3.diff_accredito,0,null,sett3.diff_accredito ), null ) 
 , decode(demi.specie_rapporto, 'DIP', decode(sett3.sett_accredito,0,null,sett3.sett_accredito ), null )
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_preavviso )
 , decode(demi.specie_rapporto, 'DIP', dapa1.al_preavviso )
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_bonus )
 , decode(demi.specie_rapporto, 'DIP', dapa1.tipo_estero )
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_atipica )
 , decode(demi.specie_rapporto, 'DIP', dapa1.al_atipica)
 , decode(demi.specie_rapporto, 'DIP', dapa1.sett_atipica)
 , decode(demi.specie_rapporto, 'DIP', dapa1.anno_sindacali)
 , decode(demi.specie_rapporto, 'DIP', dapa1.dal_sindacali)
 , decode(demi.specie_rapporto, 'DIP', dapa1.al_sindacali)
 , decode(demi.specie_rapporto,'DIP',demi.tab_anf, null)
 , decode(demi.specie_rapporto,'DIP',demi.num_anf, null)
 , decode(demi.specie_rapporto,'DIP',demi.classe_anf, null)
 , decode(demi.specie_rapporto, 'DIP', demi.tfr, null )
 , decode(demi.specie_rapporto, 'DIP', null, gest.cap )
 , decode(demi.specie_rapporto, 'DIP', null, lpad(gest.codice_attivita,5,'0'))
 , decode(demi.specie_rapporto, 'COCO', demi.tipo_rapporto, null )
 , decode(demi.specie_rapporto, 'COCO', demi.cod_attivita, null )
 , decode(demi.specie_rapporto, 'COCO', demi.altra_ass, null )
 , decode(demi.specie_rapporto, 'DIP', null, to_char(demi.dal,'yyyy-mm-dd') )
 , decode(demi.specie_rapporto, 'DIP', null, to_char(demi.al,'yyyy-mm-dd') )
 , decode(demi.specie_rapporto, 'COCO', demi.tipo_agevolazione, null)
 , decode(demi.specie_rapporto, 'DIP', demi.cod_calamita, null )
 , decode(demi.specie_rapporto, 'DIP', fose1.anno_rif, null)
 , decode(demi.specie_rapporto, 'DIP', fose1.dal,null)
 , decode(demi.specie_rapporto, 'DIP', fose1.al,null)
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100
;

SET SCAN OFF
REM
REM VIEW
REM     VISTA_SCHEMATICA_EMENS
REM     DENUNCIA I.N.P.S. EMENS
REM     creazione della vista schematica per identificare i record da trattare in fase di produzione di un file
REM     con la somma per periodo di denuncia - sotituzione in denuncia del ministero 
REM

PROMPT 
PROMPT Creating View VISTA_SCHEMATICA_EMENS

create or replace view VISTA_SCHEMATICA_EMENS
( deie_id_1, anno_rif, mese_rif
, anno_1, mese_1, dal_1
, deie_id, ci, anno, mese, dal, riferimento, rettifica
, flag ) 
as
select deie_id, substr(riferimento,3,4) , substr(riferimento,1,2)
       , anno, mese, dal
       , deie_id, ci, anno, mese, dal, riferimento, rettifica, 'A'
from denuncia_emens deie1
where nvl(deie1.rettifica,'X') = 'X'
union
select deie.deie_id, substr(deie.riferimento,3,4) , substr(deie.riferimento,1,2)
     , deie.anno, deie.mese, deie.dal
     , deie2.deie_id, deie2.ci, deie2.anno, deie2.mese, deie2.dal
     , deie2.riferimento, deie2.rettifica, 'B'
from denuncia_emens deie2, denuncia_emens deie
where deie.ci = deie2.ci
  and deie.riferimento = deie2.riferimento
  and nvl(deie.rettifica,'X') = 'S';

SET SCAN OFF
REM
REM VIEW
REM     VISTA_PROGRESSIVA_EMENS
REM     DENUNCIA I.N.P.S. EMENS
REM     creazione della vista progressiva per periodo di denuncia - sotituzione in denuncia del ministero 
REM

PROMPT 
PROMPT Creating View VISTA_PROGRESSIVA_EMENS

CREATE OR REPLACE VIEW VISTA_PROGRESSIVA_EMENS
as select 
-- dati dei dipendenti senza eliminativi
   demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , null                                                        rettifica
 , null                                                        elimina
 , decode( demi.rilevanza, 'P', 'S')                           tipo_consolidamento
 , gest.codice                                                 gestione
 , anag1.codice_fiscale                                        cf_mittente_fisico
 , gest.codice_fiscale                                         cf_mittente
 , gest.nome                                                   ragione_sociale 
 , nvl(ente.cf_software,gest.codice_fiscale)                   cf_software
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')    
                                                               sede_inps
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
                                                               periodo
 , to_number(null)                                             anno
 , to_number(null)                                             mese
 , gest.codice_fiscale                                         cf_azienda  
 , gest.nome                                                   ragione_sociale_azienda
 , substr(gest.posizione_inps,1,10)                            posizione_dm
 , gest.csc_dm10                                               csc
 , substr(aut_dm10,1,2)                                        ca1
 , substr(aut_dm10,3,2)                                        ca2
 , substr(aut_dm10,5,2)                                        ca3
 , substr(aut_dm10,7,2)                                        ca4
 , substr(aut_dm10,9,2)                                        ca5
 , substr(aut_dm10,11,2)                                       ca6
 , substr(aut_dm10,13,2)                                       ca7
 , substr(aut_dm10,15,2)                                       ca8
 , substr(aut_dm10,17,2)                                       ca9
 , substr(aut_dm10,19,2)                                       ca10
 , anag.codice_fiscale                                         cfis_lavoratore
 , substr(anag.cognome,1,30)                                   cognome
 , substr(anag.nome,1,20)                                      nome
 , demi.qualifica1                                             qualifica1
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica2 ) qualifica2
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica3 ) qualifica3
 , demi.tipo_contribuzione                                     tipo_contribuzione
 , nvl(demi.codice_catasto,comu1.codice_catasto)               codice_comune
 , demi.codice_contratto                                       codice_contratto
 , min(demi.giorno_assunzione)                                 giorno_assunzione
 , min(demi.tipo_assunzione)                                   tipo_assunzione
 , max(demi.giorno_cessazione)                                 giorno_cessazione
 , max(demi.tipo_cessazione)                                   tipo_cessazione
 , demi.tipo_lavoratore                                        tipo_lavoratore
 , max(demi2.imponibile)                                       imponibile
 , max(demi2.giorni_retribuiti)                                giorni_retribuiti
 , max(least(demi2.settimane_utili*100,600))                   settimane_utili
 , to_number(null)                                             aliquota
 , vaie.anno_rif                                               anno_rif_var
 , to_char(vaie.dal,'mm')                                      mese_dal
 , to_char(vaie.al,'mm')                                       mese_al
 , sum(round(vaie.aum_imponibile))                             aum_imponibile
 , sum(round(vaie.dim_imponibile))                             dim_imponibile
 , sett.id_settimana                                           id_settimana
 , sett.tipo_copertura                                         tipo_copertura
 , sett.codice_evento1                                         codice_evento1
 , sett.codice_evento2                                         codice_evento2
 , sett.codice_evento3                                         codice_evento3
 , sett.codice_evento4                                         codice_evento4
 , sett.codice_evento5                                         codice_evento5
 , sett.codice_evento6                                         codice_evento6
 , sett.codice_evento7                                         codice_evento7
 , sett3.codice                                                codice_evento_tot
 , decode(sett3.diff_accredito,0,null,sett3.diff_accredito )   diff_accredito_tot
 , decode(sett3.sett_accredito,0,null,sett3.sett_accredito )   sett_accredito_tot
 , sum(round(dapa1.ipn_preavviso ))                            ipn_preavviso
 , dapa1.dal_preavviso                                         dal_preavviso
 , dapa1.al_preavviso                                          al_preavviso
 , sum(dapa1.sett_preavviso )                                  sett_preavviso
 , sum(least(dapa1.sett_utili_preavviso*100,600))              sett_utili_preavviso
 , sum(round(dapa1.ipn_bonus ))                                ipn_bonus
 , dapa1.dal_bonus                                             dal_bonus
 , dapa1.tipo_estero                                           tipo_estero
 , sum(round(dapa1.ipn_estero ))                               ipn_estero
 , sum(round(dapa1.ipn_atipica ))                              ipn_atipica
 , dapa1.dal_atipica                                           dal_atipica 
 , dapa1.al_atipica                                            al_atipica
 , dapa1.sett_atipica                                          sett_atipica
 , dapa1.anno_sindacali                                        anno_sindacali
 , sum(round(dapa1.ipn_sindacali))                             ipn_sindacali
 , dapa1.dal_sindacali                                         dal_sindacali
 , dapa1.al_sindacali                                          al_sindacali
 , demi.tab_anf                                                tab_anf
 , demi.num_anf                                                num_anf 
 , demi.classe_anf                                             classe_anf
 , demi.tfr                                                    tfr
 , null                                                        cap
 , null                                                        istat
 , null                                                        tipo_rapporto
 , null                                                        cod_attivita
 , null                                                        altra_ass
 , null                                                        dal
 , null                                                        al
 , to_number(null)                                             imp_agevolazione
 , null                                                        tipo_agevolazione
 , demi.cod_calamita                                           cod_calamita
 , sum(fose1.retr_pens)                                        retr_pens_tot
 , sum(fose1.gg_non_retr)                                      gg_non_retr
 , fose1.anno_rif                                              anno_rif
 , sum(fose1.arretrati)                                        retr_pens_arr
 , fose1.dal                                                   dal_fondi
 , fose1.al                                                    al_fondi
 , sum(fose1.contr_sind)                                       retr_pens_sind
 , sum(nvl(gete.base_calcolo,0)*100)                           base_calcolo_tfr
 , sum(gete.base_calcolo_prev_compl*100)                       base_calcolo_prev_compl
 , sum(nvl(round(gete.imp_corrente),0))                        importo_corrente
 , sum(nvl(round(gete.imp_pregresso),0))                       importo_pregresso
 , sum(nvl(round(gete.imp_liquidazione),0))                    importo_liquidazione
 , sum(nvl(round(gete.imp_anticipazione),0))                   importo_anticipazione
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')                      data_scelta
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')                    data_adesione
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100                                   quota_prev_compl
from ente
   , vista_schematica_emens      vsem
   , denuncia_emens              demi
   , rapporti_individuali        rain
   , rapporti_individuali        rain1
   , anagrafici                  anag
   , anagrafici                  anag1
   , gestioni                    gest
   , comuni                      comu1
   , settimane_emens             sett
   , variabili_emens             vaie
   , gestione_tfr_emens          gete
   , ( select demi1.ci
            , demi1.riferimento
            , demi1.qualifica1
            , demi1.qualifica2
            , demi1.qualifica3
            , nvl(demi1.gestione_alternativa,demi1.gestione) gestione
            , nvl(demi1.rilevanza,'C') rilevanza
            , sum(imponibile) imponibile
            , sum(giorni_retribuiti) giorni_retribuiti
            , sum(settimane_utili) settimane_utili
      from denuncia_emens demi1
      where nvl(rettifica,'X') != 'E'
        and demi1.specie_rapporto = 'DIP'
     group by demi1.ci, demi1.riferimento, demi1.qualifica1, demi1.qualifica2, demi1.qualifica3
            , nvl(demi1.gestione_alternativa,demi1.gestione), nvl(demi1.rilevanza,'C')
      ) demi2
   , ( select dapa.deie_id
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.imponibile, null ),0))     ipn_preavviso
            , max(decode(dapa.identificatore, 'PREAVVISO',to_char(dapa.dal,'yyyy-mm-dd'),null))
                                                                                              dal_preavviso
            , max(decode(dapa.identificatore, 'PREAVVISO',to_char(dapa.al,'yyyy-mm-dd'),null))
                                                                                              al_preavviso
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.num_settimane, null ),0))  sett_preavviso
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.settimane_utili, null ),0))  sett_utili_preavviso
            , sum(nvl(decode(dapa.identificatore, 'BONUS',dapa.imponibile, null ),0))         ipn_bonus
            , max(decode(dapa.identificatore, 'BONUS',to_char(dapa.dal,'yyyy')||'-'||to_char(dapa.dal,'mm'), null ))
                                                                                              dal_bonus
            , max(decode(dapa.identificatore, 'ESTERO','04',null))                            tipo_estero
            , sum(nvl(decode(dapa.identificatore, 'ESTERO',dapa.imponibile, null ),0))        ipn_estero
            , sum(nvl(decode(dapa.identificatore, 'ATIPICA',dapa.imponibile, null ) ,0))      ipn_atipica
            , max(decode(dapa.identificatore, 'ATIPICA',to_char(dapa.dal,'yyyy-mm-dd'),null))
                                                                                              dal_atipica
            , max(decode(dapa.identificatore, 'ATIPICA',to_char(dapa.al,'yyyy-mm-dd'),null))
                                                                                              al_atipica
            , sum(nvl(decode(dapa.identificatore, 'ATIPICA',dapa.num_settimane, null ),0))    sett_atipica
            , max(decode(dapa.identificatore, 'SINDACALI',dapa.anno_rif, to_number(null)))    anno_sindacali
            , sum(nvl(decode(dapa.identificatore, 'SINDACALI',dapa.imponibile, null ),0))     ipn_sindacali
            , max(decode(dapa.identificatore, 'SINDACALI', '--'||to_char(dapa.dal,'mm-dd'),null))
                                                                                              dal_sindacali
            , max(decode(dapa.identificatore, 'SINDACALI','--'||to_char(dapa.al,'mm-dd'),null))
                                                                                              al_sindacali
      from dati_particolari_emens      dapa
     group by  dapa.deie_id
      ) dapa1
   , ( select  fose.deie_id
             , sum(nvl(fose.retr_pens,0))       retr_pens
             , sum(nvl(fose.gg_non_retr,0))     gg_non_retr
             , fose.anno_rif                    anno_rif
             , sum(nvl(fose.arretrati,0))       arretrati
             , to_char(fose.dal,'mm')           dal
             , to_char(fose.al,'mm')            al
             , sum(nvl(fose.contr_sind,0))      contr_sind
         from  fondi_speciali_emens fose
        group by fose.deie_id, fose.anno_rif
               , to_char(fose.dal,'mm') , to_char(fose.al,'mm')
     )        fose1
   , ( select sett1.deie_id
            , max(sett2.id_settimana) id_settimana2
            , substr(ltrim(rtrim(peco.rv_low_value)),1,3) codice
            , sum( nvl(decode(sett1.codice_evento1, peco.rv_low_value, sett1.diff_accredito1, null),0)
                 + nvl(decode(sett1.codice_evento2, peco.rv_low_value, sett1.diff_accredito2, null),0)
                 + nvl(decode(sett1.codice_evento3, peco.rv_low_value, sett1.diff_accredito3, null),0)
                 + nvl(decode(sett1.codice_evento4, peco.rv_low_value, sett1.diff_accredito4, null),0)
                 + nvl(decode(sett1.codice_evento5, peco.rv_low_value, sett1.diff_accredito5, null),0)
                 + nvl(decode(sett1.codice_evento6, peco.rv_low_value, sett1.diff_accredito6, null),0)
                 + nvl(decode(sett1.codice_evento7, peco.rv_low_value, sett1.diff_accredito7, null),0)
                 ) diff_accredito
            , sum( nvl(decode(sett1.codice_evento1, peco.rv_low_value, sett1.sett_accredito1, null),0)
                 + nvl(decode(sett1.codice_evento2, peco.rv_low_value, sett1.sett_accredito2, null),0)
                 + nvl(decode(sett1.codice_evento3, peco.rv_low_value, sett1.sett_accredito3, null),0)
                 + nvl(decode(sett1.codice_evento4, peco.rv_low_value, sett1.sett_accredito4, null),0)
                 + nvl(decode(sett1.codice_evento5, peco.rv_low_value, sett1.sett_accredito5, null),0)
                 + nvl(decode(sett1.codice_evento6, peco.rv_low_value, sett1.sett_accredito6, null),0)
                 + nvl(decode(sett1.codice_evento7, peco.rv_low_value, sett1.sett_accredito7, null),0)
                 ) sett_accredito
  from settimane_emens sett1
     , pec_ref_codes peco
     , settimane_emens sett2
 where peco.rv_domain = 'SETTIMANE_EMENS.CODICE_EVENTO'
   and ( sett1.codice_evento1 = peco.rv_low_value
    or   sett1.codice_evento2 = peco.rv_low_value
    or   sett1.codice_evento3 = peco.rv_low_value
    or   sett1.codice_evento4 = peco.rv_low_value
    or   sett1.codice_evento5 = peco.rv_low_value
    or   sett1.codice_evento6 = peco.rv_low_value
    or   sett1.codice_evento7 = peco.rv_low_value
       )
   and sett1.ci = sett2.ci
   and sett1.anno = sett2.anno
   and sett1.mese = sett2.mese
   and sett1.dal = sett2.dal
group by  sett1.deie_id
        , peco.rv_low_value
     ) sett3
where gest.comune_res    = comu1.cod_comune
  and gest.provincia_res = comu1.cod_provincia
  and anag.ni            = rain.ni
  and anag1.ni           = rain1.ni
  and rain1.ci           = gest.mittente_emens
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag.dal and nvl(anag.al,to_date('3333333','j'))
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag1.dal and nvl(anag1.al,to_date('3333333','j'))
  and demi.ci            = rain.ci
  and gest.codice        = nvl(demi.gestione_alternativa,demi.gestione)
  and demi.deie_id       = sett.deie_id (+)
  and demi.ci            = demi2.ci (+)
  and demi.riferimento   = demi2.riferimento (+)
  and demi.rilevanza     = demi2.rilevanza (+)
  and nvl(demi.qualifica1,' ')    = nvl(demi2.qualifica1,' ')
  and nvl(demi.qualifica2,' ')    = nvl(demi2.qualifica2,' ')
  and nvl(demi.qualifica3,' ')    = nvl(demi2.qualifica3,' ')
  and nvl(demi.gestione_alternativa, nvl(demi.gestione,' ')) = nvl(demi2.gestione,' ')
  and nvl(demi.rettifica,'S') != 'E'
  and demi.deie_id       = dapa1.deie_id (+)
  and demi.deie_id       = vaie.deie_id (+)
  and demi.deie_id       = gete.deie_id (+)
  and demi.deie_id       = fose1.deie_id (+)
  and sett.deie_id       = sett3.deie_id (+)
  and sett.id_settimana  = sett3.id_settimana2 (+)
  and demi.ci  = vsem.ci
  and demi.deie_id       = vsem.deie_id
  and demi.specie_rapporto = 'DIP'
group by demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , decode( demi.rilevanza, 'P', 'I')
 , gest.codice
 , anag1.codice_fiscale
 , gest.codice_fiscale
 , gest.nome
 , nvl(ente.cf_software,gest.codice_fiscale)
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')    
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
 , gest.codice_fiscale
 , gest.nome
 , substr(gest.posizione_inps,1,10)
 , gest.csc_dm10
 , substr(aut_dm10,1,2)
 , substr(aut_dm10,3,2)
 , substr(aut_dm10,5,2)
 , substr(aut_dm10,7,2)
 , substr(aut_dm10,9,2)
 , substr(aut_dm10,11,2)
 , substr(aut_dm10,13,2)
 , substr(aut_dm10,15,2)
 , substr(aut_dm10,17,2)
 , substr(aut_dm10,19,2)
 , anag.codice_fiscale
 , substr(anag.cognome,1,30)
 , substr(anag.nome,1,20)
 , demi.qualifica1
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica2 )
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica3 )
 , demi.tipo_contribuzione
 , nvl(demi.codice_catasto,comu1.codice_catasto)
 , demi.codice_contratto
 , demi.tipo_lavoratore
 , vaie.anno_rif
 , to_char(vaie.dal,'mm')
 , to_char(vaie.al,'mm')
 , sett.id_settimana
 , sett.tipo_copertura
 , sett.codice_evento1
 , sett.codice_evento2
 , sett.codice_evento3
 , sett.codice_evento4
 , sett.codice_evento5
 , sett.codice_evento6
 , sett.codice_evento7
 , sett3.codice
 , decode(sett3.diff_accredito,0,null,sett3.diff_accredito )
 , decode(sett3.sett_accredito,0,null,sett3.sett_accredito )
 , dapa1.dal_preavviso
 , dapa1.al_preavviso
 , dapa1.dal_bonus
 , dapa1.tipo_estero
 , dapa1.dal_atipica
 , dapa1.al_atipica
 , dapa1.sett_atipica
 , dapa1.anno_sindacali
 , dapa1.dal_sindacali
 , dapa1.al_sindacali
 , demi.tab_anf
 , demi.num_anf
 , demi.classe_anf
 , demi.tfr
 , demi.cod_calamita
 , fose1.anno_rif
 , fose1.dal
 , fose1.al
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100
UNION
select 
-- dati dei dipendenti solo eliminativi
   demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , 'E'                                                         rettifica
 , 'S'                                                         elimina
 , null                                                        tipo_consolidamento
 , gest.codice                                                 gestione
 , anag1.codice_fiscale                                        cf_mittente_fisico
 , gest.codice_fiscale                                         cf_mittente
 , gest.nome                                                   ragione_sociale 
 , nvl(ente.cf_software,gest.codice_fiscale)                   cf_software
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')    
                                                               sede_inps
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
                                                               periodo
 , to_number(null)                                             anno
 , to_number(null)                                             mese
 , gest.codice_fiscale                                         cf_azienda  
 , gest.nome                                                   ragione_sociale_azienda
 , substr(gest.posizione_inps,1,10)                            posizione_dm
 , gest.csc_dm10                                               csc
 , substr(aut_dm10,1,2)                                        ca1
 , substr(aut_dm10,3,2)                                        ca2
 , substr(aut_dm10,5,2)                                        ca3
 , substr(aut_dm10,7,2)                                        ca4
 , substr(aut_dm10,9,2)                                        ca5
 , substr(aut_dm10,11,2)                                       ca6
 , substr(aut_dm10,13,2)                                       ca7
 , substr(aut_dm10,15,2)                                       ca8
 , substr(aut_dm10,17,2)                                       ca9
 , substr(aut_dm10,19,2)                                       ca10
 , anag.codice_fiscale                                         cfis_lavoratore
 , substr(anag.cognome,1,30)                                   cognome
 , substr(anag.nome,1,20)                                      nome
 , demi.qualifica1                                             qualifica1
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica2 ) qualifica2
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica3 ) qualifica3
 , demi.tipo_contribuzione                                     tipo_contribuzione
 , nvl(demi.codice_catasto,comu1.codice_catasto)               codice_comune
 , demi.codice_contratto                                       codice_contratto
 , min(demi.giorno_assunzione)                                 giorno_assunzione
 , min(demi.tipo_assunzione)                                   tipo_assunzione
 , max(demi.giorno_cessazione)                                 giorno_cessazione
 , max(demi.tipo_cessazione)                                   tipo_cessazione
 , demi.tipo_lavoratore                                        tipo_lavoratore
 , max(demi2.imponibile)                                       imponibile
 , max(demi2.giorni_retribuiti)                                giorni_retribuiti
 , max(least(demi2.settimane_utili*100,600))                   settimane_utili
 , to_number(null)                                             aliquota
 , vaie.anno_rif                                               anno_rif_var
 , to_char(vaie.dal,'mm')                                      mese_dal
 , to_char(vaie.al,'mm')                                       mese_al
 , sum(round(vaie.aum_imponibile))                             aum_imponibile
 , sum(round(vaie.dim_imponibile))                             dim_imponibile
 , sett.id_settimana                                           id_settimana
 , sett.tipo_copertura                                         tipo_copertura
 , sett.codice_evento1                                         codice_evento1
 , sett.codice_evento2                                         codice_evento2
 , sett.codice_evento3                                         codice_evento3
 , sett.codice_evento4                                         codice_evento4
 , sett.codice_evento5                                         codice_evento5
 , sett.codice_evento6                                         codice_evento6
 , sett.codice_evento7                                         codice_evento7
 , sett3.codice                                                codice_evento_tot
 , decode(sett3.diff_accredito,0,null,sett3.diff_accredito )   diff_accredito_tot
 , decode(sett3.sett_accredito,0,null,sett3.sett_accredito )   sett_accredito_tot
 , sum(round(dapa1.ipn_preavviso ))                            ipn_preavviso
 , dapa1.dal_preavviso                                         dal_preavviso
 , dapa1.al_preavviso                                          al_preavviso
 , sum(dapa1.sett_preavviso )                                  sett_preavviso
 , sum(least(dapa1.sett_utili_preavviso*100,600))              sett_utili_preavviso
 , sum(round(dapa1.ipn_bonus ))                                ipn_bonus
 , dapa1.dal_bonus                                             dal_bonus
 , dapa1.tipo_estero                                           tipo_estero
 , sum(round(dapa1.ipn_estero ))                               ipn_estero
 , sum(round(dapa1.ipn_atipica ))                              ipn_atipica
 , dapa1.dal_atipica                                           dal_atipica 
 , dapa1.al_atipica                                            al_atipica
 , dapa1.sett_atipica                                          sett_atipica
 , dapa1.anno_sindacali                                        anno_sindacali
 , sum(round(dapa1.ipn_sindacali))                             ipn_sindacali
 , dapa1.dal_sindacali                                         dal_sindacali
 , dapa1.al_sindacali                                          al_sindacali
 , demi.tab_anf                                                tab_anf
 , demi.num_anf                                                num_anf 
 , demi.classe_anf                                             classe_anf
 , demi.tfr                                                    tfr
 , null                                                        cap
 , null                                                        istat
 , null                                                        tipo_rapporto
 , null                                                        cod_attivita
 , null                                                        altra_ass
 , null                                                        dal
 , null                                                        al
 , to_number(null)                                             imp_agevolazione
 , null                                                        tipo_agevolazione
 , demi.cod_calamita                                           cod_calamita
 , sum(fose1.retr_pens)                                        retr_pens_tot
 , sum(fose1.gg_non_retr)                                      gg_non_retr
 , fose1.anno_rif                                              anno_rif
 , sum(fose1.arretrati)                                        retr_pens_arr
 , fose1.dal                                                   dal_fondi
 , fose1.al                                                    al_fondi
 , sum(fose1.contr_sind)                                       retr_pens_sind
 , sum(nvl(gete.base_calcolo,0)*100)                           base_calcolo_tfr
 , sum(gete.base_calcolo_prev_compl*100)                       base_calcolo_prev_compl
 , sum(nvl(round(gete.imp_corrente),0))                        importo_corrente
 , sum(nvl(round(gete.imp_pregresso),0))                       importo_pregresso
 , sum(nvl(round(gete.imp_liquidazione),0))                    importo_liquidazione
 , sum(nvl(round(gete.imp_anticipazione),0))                   importo_anticipazione
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')                      data_scelta
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')                    data_adesione
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100                                   quota_prev_compl
from ente
   , vista_schematica_emens      vsem
   , denuncia_emens              demi
   , rapporti_individuali        rain
   , rapporti_individuali        rain1
   , anagrafici                  anag
   , anagrafici                  anag1
   , gestioni                    gest
   , comuni                      comu1
   , settimane_emens             sett
   , variabili_emens             vaie
   , gestione_tfr_emens          gete
   , ( select demi1.ci
            , demi1.riferimento
            , demi1.qualifica1
            , demi1.qualifica2
            , demi1.qualifica3
            , nvl(demi1.gestione_alternativa,demi1.gestione) gestione
            , nvl(demi1.rilevanza,'C') rilevanza
            , sum(imponibile) imponibile
            , sum(giorni_retribuiti) giorni_retribuiti
            , sum(settimane_utili) settimane_utili
      from denuncia_emens demi1
      where nvl(rettifica,'X') = 'E'
        and specie_rapporto = 'DIP'
     group by demi1.ci, demi1.riferimento, demi1.qualifica1, demi1.qualifica2, demi1.qualifica3
            , nvl(demi1.gestione_alternativa,demi1.gestione), nvl(demi1.rilevanza,'C')
      ) demi2
   , ( select dapa.deie_id
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.imponibile, null ),0))     ipn_preavviso
            , max(decode(dapa.identificatore, 'PREAVVISO',to_char(dapa.dal,'yyyy-mm-dd'),null))
                                                                                              dal_preavviso
            , max(decode(dapa.identificatore, 'PREAVVISO',to_char(dapa.al,'yyyy-mm-dd'),null))
                                                                                              al_preavviso
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.num_settimane, null ),0))  sett_preavviso
            , sum(nvl(decode(dapa.identificatore, 'PREAVVISO',dapa.settimane_utili, null ),0))  sett_utili_preavviso
            , sum(nvl(decode(dapa.identificatore, 'BONUS',dapa.imponibile, null ),0))         ipn_bonus
            , max(decode(dapa.identificatore, 'BONUS',to_char(dapa.dal,'yyyy')||'-'||to_char(dapa.dal,'mm'), null ))
                                                                                              dal_bonus
            , max(decode(dapa.identificatore, 'ESTERO','04',null))                            tipo_estero
            , sum(nvl(decode(dapa.identificatore, 'ESTERO',dapa.imponibile, null ),0))        ipn_estero
            , sum(nvl(decode(dapa.identificatore, 'ATIPICA',dapa.imponibile, null ) ,0))      ipn_atipica
            , max(decode(dapa.identificatore, 'ATIPICA',to_char(dapa.dal,'yyyy-mm-dd'),null))
                                                                                              dal_atipica
            , max(decode(dapa.identificatore, 'ATIPICA',to_char(dapa.al,'yyyy-mm-dd'),null))
                                                                                              al_atipica
            , sum(nvl(decode(dapa.identificatore, 'ATIPICA',dapa.num_settimane, null ),0))    sett_atipica
            , max(decode(dapa.identificatore, 'SINDACALI',dapa.anno_rif, to_number(null)))    anno_sindacali
            , sum(nvl(decode(dapa.identificatore, 'SINDACALI',dapa.imponibile, null ),0))     ipn_sindacali
            , max(decode(dapa.identificatore, 'SINDACALI', '--'||to_char(dapa.dal,'mm-dd'),null))
                                                                                              dal_sindacali
            , max(decode(dapa.identificatore, 'SINDACALI','--'||to_char(dapa.al,'mm-dd'),null))
                                                                                              al_sindacali
      from dati_particolari_emens      dapa
     group by  dapa.deie_id
      ) dapa1
   , ( select  fose.deie_id
             , sum(nvl(fose.retr_pens,0))       retr_pens
             , sum(nvl(fose.gg_non_retr,0))     gg_non_retr
             , fose.anno_rif                    anno_rif
             , sum(nvl(fose.arretrati,0))       arretrati
             , to_char(fose.dal,'mm')           dal
             , to_char(fose.al,'mm')            al
             , sum(nvl(fose.contr_sind,0))      contr_sind
         from  fondi_speciali_emens fose
        group by fose.deie_id, fose.anno_rif
               , to_char(fose.dal,'mm') , to_char(fose.al,'mm')
     )        fose1
   , ( select sett1.deie_id
            , max(sett2.id_settimana) id_settimana2
            , substr(ltrim(rtrim(peco.rv_low_value)),1,3) codice
            , sum( nvl(decode(sett1.codice_evento1, peco.rv_low_value, sett1.diff_accredito1, null),0)
                 + nvl(decode(sett1.codice_evento2, peco.rv_low_value, sett1.diff_accredito2, null),0)
                 + nvl(decode(sett1.codice_evento3, peco.rv_low_value, sett1.diff_accredito3, null),0)
                 + nvl(decode(sett1.codice_evento4, peco.rv_low_value, sett1.diff_accredito4, null),0)
                 + nvl(decode(sett1.codice_evento5, peco.rv_low_value, sett1.diff_accredito5, null),0)
                 + nvl(decode(sett1.codice_evento6, peco.rv_low_value, sett1.diff_accredito6, null),0)
                 + nvl(decode(sett1.codice_evento7, peco.rv_low_value, sett1.diff_accredito7, null),0)
                 ) diff_accredito
            , sum( nvl(decode(sett1.codice_evento1, peco.rv_low_value, sett1.sett_accredito1, null),0)
                 + nvl(decode(sett1.codice_evento2, peco.rv_low_value, sett1.sett_accredito2, null),0)
                 + nvl(decode(sett1.codice_evento3, peco.rv_low_value, sett1.sett_accredito3, null),0)
                 + nvl(decode(sett1.codice_evento4, peco.rv_low_value, sett1.sett_accredito4, null),0)
                 + nvl(decode(sett1.codice_evento5, peco.rv_low_value, sett1.sett_accredito5, null),0)
                 + nvl(decode(sett1.codice_evento6, peco.rv_low_value, sett1.sett_accredito6, null),0)
                 + nvl(decode(sett1.codice_evento7, peco.rv_low_value, sett1.sett_accredito7, null),0)
                 ) sett_accredito
  from settimane_emens sett1
     , pec_ref_codes peco
     , settimane_emens sett2
 where peco.rv_domain = 'SETTIMANE_EMENS.CODICE_EVENTO'
   and ( sett1.codice_evento1 = peco.rv_low_value
    or   sett1.codice_evento2 = peco.rv_low_value
    or   sett1.codice_evento3 = peco.rv_low_value
    or   sett1.codice_evento4 = peco.rv_low_value
    or   sett1.codice_evento5 = peco.rv_low_value
    or   sett1.codice_evento6 = peco.rv_low_value
    or   sett1.codice_evento7 = peco.rv_low_value
       )
   and sett1.ci = sett2.ci
   and sett1.anno = sett2.anno
   and sett1.mese = sett2.mese
   and sett1.dal = sett2.dal
group by  sett1.deie_id
        , peco.rv_low_value
     ) sett3
where gest.comune_res    = comu1.cod_comune
  and gest.provincia_res = comu1.cod_provincia
  and anag.ni            = rain.ni
  and anag1.ni           = rain1.ni
  and rain1.ci           = gest.mittente_emens
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag.dal and nvl(anag.al,to_date('3333333','j'))
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag1.dal and nvl(anag1.al,to_date('3333333','j'))
  and demi.ci            = rain.ci
  and gest.codice        = nvl(demi.gestione_alternativa,demi.gestione)
  and demi.deie_id       = sett.deie_id (+)
  and demi.ci            = demi2.ci (+)
  and demi.riferimento   = demi2.riferimento (+)
  and demi.rilevanza     = demi2.rilevanza (+)
  and nvl(demi.qualifica1,' ')    = nvl(demi2.qualifica1,' ')
  and nvl(demi.qualifica2,' ')    = nvl(demi2.qualifica2,' ')
  and nvl(demi.qualifica3,' ')    = nvl(demi2.qualifica3,' ')
  and nvl(demi.gestione_alternativa,nvl(demi.gestione,' '))    = nvl(demi2.gestione,' ')
  and nvl(demi.rettifica,'X')      = 'E'
  and demi.deie_id       = dapa1.deie_id (+)
  and demi.deie_id       = vaie.deie_id (+)
  and demi.deie_id       = gete.deie_id (+)
  and demi.deie_id       = fose1.deie_id (+)
  and sett.deie_id       = sett3.deie_id (+)
  and sett.id_settimana  = sett3.id_settimana2 (+)
  and demi.ci  = vsem.ci
  and demi.deie_id       = vsem.deie_id
  and demi.specie_rapporto = 'DIP'
group by demi.ci 
 , demi.specie_rapporto
 , demi.rilevanza
 , gest.codice
 , anag1.codice_fiscale
 , gest.codice_fiscale
 , gest.nome
 , nvl(ente.cf_software,gest.codice_fiscale)
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')    
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
 , gest.codice_fiscale
 , gest.nome
 , substr(gest.posizione_inps,1,10)
 , gest.csc_dm10
 , substr(aut_dm10,1,2)
 , substr(aut_dm10,3,2)
 , substr(aut_dm10,5,2)
 , substr(aut_dm10,7,2)
 , substr(aut_dm10,9,2)
 , substr(aut_dm10,11,2)
 , substr(aut_dm10,13,2)
 , substr(aut_dm10,15,2)
 , substr(aut_dm10,17,2)
 , substr(aut_dm10,19,2)
 , anag.codice_fiscale
 , substr(anag.cognome,1,30)
 , substr(anag.nome,1,20)
 , demi.qualifica1
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica2 )
 , decode ( demi.qualifica1,'A',null,'B',null,demi.qualifica3 )
 , demi.tipo_contribuzione
 , nvl(demi.codice_catasto,comu1.codice_catasto)
 , demi.codice_contratto
 , demi.tipo_lavoratore
 , vaie.anno_rif
 , to_char(vaie.dal,'mm')
 , to_char(vaie.al,'mm')
 , sett.id_settimana
 , sett.tipo_copertura
 , sett.codice_evento1
 , sett.codice_evento2
 , sett.codice_evento3
 , sett.codice_evento4
 , sett.codice_evento5
 , sett.codice_evento6
 , sett.codice_evento7
 , sett3.codice
 , decode(sett3.diff_accredito,0,null,sett3.diff_accredito )
 , decode(sett3.sett_accredito,0,null,sett3.sett_accredito )
 , dapa1.dal_preavviso
 , dapa1.al_preavviso
 , dapa1.dal_bonus
 , dapa1.tipo_estero
 , dapa1.dal_atipica
 , dapa1.al_atipica
 , dapa1.sett_atipica
 , dapa1.anno_sindacali
 , dapa1.dal_sindacali
 , dapa1.al_sindacali
 , demi.tab_anf
 , demi.num_anf
 , demi.classe_anf
 , demi.tfr
 , demi.cod_calamita
 , fose1.anno_rif
 , fose1.dal
 , fose1.al
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100
union
-- dati per collaboratori senza eliminativi
 select 
   demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , null                                                        rettifica
 , null                                                        elimina
 , decode( demi.rilevanza, 'P', 'S')                           tipo_consolidamento
 , gest.codice                                                              gestione
 , anag1.codice_fiscale                                                     cf_mittente_fisico
 , gest.codice_fiscale                                                      cf_mittente
 , gest.nome                                                                ragione_sociale 
 , nvl(ente.cf_software,gest.codice_fiscale)                                cf_software
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')    sede_inps
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
                                                                            periodo
 , to_number(null) anno, to_number(null) mese
 , gest.codice_fiscale                                                      cf_azienda  
 , gest.nome                                                                ragione_sociale_azienda
 , NULL                                                                     posizione_dm
 , NULL                                                                     csc
 , NULL                                                                     ca1
 , NULL                                                                     ca2
 , NULL                                                                     ca3
 , NULL                                                                     ca4
 , NULL                                                                     ca5
 , NULL                                                                     ca6
 , NULL                                                                     ca7
 , NULL                                                                     ca8
 , NULL                                                                     ca9
 , NULL                                                                     ca10
 , anag.codice_fiscale                                                      cfis_lavoratore
 , substr(anag.cognome,1,30)                                                cognome
 , substr(anag.nome,1,20)                                                   nome
 , NULL                                                                     qualifica1
 , NULL                                                                     qualifica2
 , NULL                                                                     qualifica3
 , NULL                                                                     tipo_contribuzione
 , nvl(demi.codice_catasto,comu1.codice_catasto)                            codice_comune
 , NULL                                                                     codice_contratto
 , to_number(NULL)                                                          giorno_assunzione
 , NULL                                                                     tipo_assunzione
 , to_number(NULL)                                                          giorno_cessazione
 , NULL                                                                     tipo_cessazione
 , NULL                                                                     tipo_lavoratore
 , sum(demi.imponibile)                                                     imponibile
 , to_number(null)                                                          giorni_retribuiti
 , to_number(null)                                                          settimane_utili
 , demi.aliquota*100                                                        aliquota
 , NULL                                                                     anno_rif_var
 , NULL                                                                     mese_dal
 , NULL                                                                     mese_al
 , to_number(NULL)                                                          aum_imponibile
 , to_number(NULL)                                                          dim_imponibile
 , to_number(NULL)                                                          id_settimana
 , NULL                                                                     tipo_copertura
 , NULL                                                                     codice_evento1
 , NULL                                                                     codice_evento2
 , NULL                                                                     codice_evento3
 , NULL                                                                     codice_evento4
 , NULL                                                                     codice_evento5
 , NULL                                                                     codice_evento6
 , NULL                                                                     codice_evento7
 , NULL                                                                     codice_evento_tot
 , NULL                                                                     diff_accredito_tot
 , NULL                                                                     sett_accredito_tot
 , to_number(NULL)                                                          ipn_preavviso
 , NULL                                                                     dal_preavviso
 , NULL                                                                     al_preavviso
 , to_number(NULL)                                                          sett_preavviso
 , to_number(NULL)                                                          sett_utili_preavviso
 , to_number(NULL)                                                          ipn_bonus
 , NULL                                                                     dal_bonus
 , NULL                                                                     tipo_estero
 , to_number(NULL)                                                          ipn_estero
 , to_number(NULL)                                                          ipn_atipica
 , NULL                                                                     dal_atipica 
 , NULL                                                                     al_atipica
 , to_number(NULL)                                                          sett_atipica
 , to_number(NULL)                                                          anno_sindacali
 , to_number(NULL)                                                          ipn_sindacali
 , NULL                                                                     dal_sindacali
 , NULL                                                                     al_sindacali
 , NULL                                                                     tab_anf
 , to_number(NULL)                                                          num_anf 
 , to_number(NULL)                                                          classe_anf
 , to_number(NULL)                                                          tfr
 , gest.cap                                                                 cap
 , lpad(gest.codice_attivita,5,'0')                                         istat
 , demi.tipo_rapporto                                                       tipo_rapporto
 , demi.cod_attivita                                                        cod_attivita
 , demi.altra_ass                                                           altra_ass
 , to_char(min(demi.dal),'yyyy-mm-dd')                                      dal
 , to_char(max(demi.al),'yyyy-mm-dd')                                       al
 , sum(demi.imp_agevolazione)                                               imp_agevolazione
 , demi.tipo_agevolazione                                                   tipo_agevolazione
 , NULL                                                                     cod_calamita
 , to_number(NULL)                                                          retr_pens_tot
 , to_number(NULL)                                                          gg_non_retr
 , NULL                                                                     anno_rif
 , to_number(NULL)                                                          retr_pens_arr
 , NULL                                                                     dal_fondi
 , NULL                                                                     al_fondi
 , to_number(NULL)                                                          retr_pens_sind
 , sum(nvl(gete.base_calcolo,0)*100)                                        base_calcolo_tfr
 , sum(gete.base_calcolo_prev_compl*100)                                    base_calcolo_prev_compl
 , sum(nvl(round(gete.imp_corrente),0))                                     importo_corrente
 , sum(nvl(round(gete.imp_pregresso),0))                                    importo_pregresso
 , sum(nvl(round(gete.imp_liquidazione),0))                                 importo_liquidazione
 , sum(nvl(round(gete.imp_anticipazione),0))                                importo_anticipazione
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')                                   data_scelta
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')                                 data_adesione
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100                                                quota_prev_compl
from ente
   , vista_schematica_emens      vsem
   , denuncia_emens              demi
   , rapporti_individuali        rain
   , rapporti_individuali        rain1
   , anagrafici                  anag
   , anagrafici                  anag1
   , gestioni                    gest
   , comuni                      comu1
   , gestione_tfr_emens          gete
where gest.comune_res    = comu1.cod_comune
  and gest.provincia_res = comu1.cod_provincia
  and anag.ni            = rain.ni
  and anag1.ni           = rain1.ni
  and rain1.ci        = gest.mittente_emens
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag.dal and nvl(anag.al,to_date('3333333','j'))
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag1.dal and nvl(anag1.al,to_date('3333333','j'))
  and demi.ci            = rain.ci
  and gest.codice        = nvl(demi.gestione_alternativa,demi.gestione)
  and demi.specie_rapporto = 'COCO'
  and nvl(demi.rettifica,'S') != 'E'
  and demi.ci  = vsem.ci
  and demi.deie_id       = vsem.deie_id
  and demi.deie_id       = gete.deie_id (+)
group by    demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , decode( demi.rilevanza, 'P', 'I')
 , gest.codice
 , anag1.codice_fiscale
 , gest.codice_fiscale
 , gest.nome
 , nvl(ente.cf_software,gest.codice_fiscale) 
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
 , gest.codice_fiscale
 , gest.nome
 , anag.codice_fiscale
 , substr(anag.cognome,1,30)
 , substr(anag.nome,1,20)
 , nvl(demi.codice_catasto,comu1.codice_catasto)
 , demi.aliquota*100
 , gest.cap
 , lpad(gest.codice_attivita,5,'0')
 , demi.tipo_rapporto
 , demi.cod_attivita
 , demi.altra_ass
 , demi.tipo_agevolazione
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100
UNION
-- dati per collaboratori solo eliminativi
select 
   demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , 'E'                                                                      rettifica
 , 'S'                                                                      elimina
 , null                                                                     tipo_consolidamento
 , gest.codice                                                              gestione
 , anag1.codice_fiscale                                                     cf_mittente_fisico
 , gest.codice_fiscale                                                      cf_mittente
 , gest.nome                                                                ragione_sociale 
 , nvl(ente.cf_software,gest.codice_fiscale)                                cf_software
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')    sede_inps
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
                                                                            periodo
 , to_number(null) anno, to_number(null) mese
 , gest.codice_fiscale                                                      cf_azienda  
 , gest.nome                                                                ragione_sociale_azienda
 , NULL                                                                     posizione_dm
 , NULL                                                                     csc
 , NULL                                                                     ca1
 , NULL                                                                     ca2
 , NULL                                                                     ca3
 , NULL                                                                     ca4
 , NULL                                                                     ca5
 , NULL                                                                     ca6
 , NULL                                                                     ca7
 , NULL                                                                     ca8
 , NULL                                                                     ca9
 , NULL                                                                     ca10
 , anag.codice_fiscale                                                      cfis_lavoratore
 , substr(anag.cognome,1,30)                                                cognome
 , substr(anag.nome,1,20)                                                   nome
 , NULL                                                                     qualifica1
 , NULL                                                                     qualifica2
 , NULL                                                                     qualifica3
 , NULL                                                                     tipo_contribuzione
 , nvl(demi.codice_catasto,comu1.codice_catasto)                            codice_comune
 , NULL                                                                     codice_contratto
 , to_number(NULL)                                                          giorno_assunzione
 , NULL                                                                     tipo_assunzione
 , to_number(NULL)                                                          giorno_cessazione
 , NULL                                                                     tipo_cessazione
 , NULL                                                                     tipo_lavoratore
 , sum(demi.imponibile)                                                     imponibile
 , to_number(null)                                                          giorni_retribuiti
 , to_number(null)                                                          settimane_utili
 , demi.aliquota*100                                                        aliquota
 , NULL                                                                     anno_rif_var
 , NULL                                                                     mese_dal
 , NULL                                                                     mese_al
 , to_number(NULL)                                                          aum_imponibile
 , to_number(NULL)                                                          dim_imponibile
 , to_number(NULL)                                                          id_settimana
 , NULL                                                                     tipo_copertura
 , NULL                                                                     codice_evento1
 , NULL                                                                     codice_evento2
 , NULL                                                                     codice_evento3
 , NULL                                                                     codice_evento4
 , NULL                                                                     codice_evento5
 , NULL                                                                     codice_evento6
 , NULL                                                                     codice_evento7
 , NULL                                                                     codice_evento_tot
 , NULL                                                                     diff_accredito_tot
 , NULL                                                                     sett_accredito_tot
 , to_number(NULL)                                                          ipn_preavviso
 , NULL                                                                     dal_preavviso
 , NULL                                                                     al_preavviso
 , to_number(NULL)                                                          sett_preavviso
 , to_number(NULL)                                                          sett_utili_preavviso
 , to_number(NULL)                                                          ipn_bonus
 , NULL                                                                     dal_bonus
 , NULL                                                                     tipo_estero
 , to_number(NULL)                                                          ipn_estero
 , to_number(NULL)                                                          ipn_atipica
 , NULL                                                                     dal_atipica 
 , NULL                                                                     al_atipica
 , to_number(NULL)                                                          sett_atipica
 , to_number(NULL)                                                          anno_sindacali
 , to_number(NULL)                                                          ipn_sindacali
 , NULL                                                                     dal_sindacali
 , NULL                                                                     al_sindacali
 , NULL                                                                     tab_anf
 , to_number(NULL)                                                          num_anf 
 , to_number(NULL)                                                          classe_anf
 , to_number(NULL)                                                          tfr
 , gest.cap                                                                 cap
 , lpad(gest.codice_attivita,5,'0')                                         istat
 , demi.tipo_rapporto                                                       tipo_rapporto
 , demi.cod_attivita                                                        cod_attivita
 , demi.altra_ass                                                           altra_ass
 , to_char(min(demi.dal),'yyyy-mm-dd')                                      dal
 , to_char(max(demi.al),'yyyy-mm-dd')                                       al
 , sum(demi.imp_agevolazione)                                               imp_agevolazione
 , demi.tipo_agevolazione                                                   tipo_agevolazione
 , NULL                                                                     cod_calamita
 , to_number(NULL)                                                          retr_pens_tot
 , to_number(NULL)                                                          gg_non_retr
 , NULL                                                                     anno_rif
 , to_number(NULL)                                                          retr_pens_arr
 , NULL                                                                     dal_fondi
 , NULL                                                                     al_fondi
 , to_number(NULL)                                                          retr_pens_sind
 , sum(nvl(gete.base_calcolo,0)*100)                                        base_calcolo_tfr
 , sum(gete.base_calcolo_prev_compl*100)                                    base_calcolo_prev_compl
 , sum(nvl(round(gete.imp_corrente),0))                                     importo_corrente
 , sum(nvl(round(gete.imp_pregresso),0))                                    importo_pregresso
 , sum(nvl(round(gete.imp_liquidazione),0))                                 importo_liquidazione
 , sum(nvl(round(gete.imp_anticipazione),0))                                importo_anticipazione
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')                                   data_scelta
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')                                 data_adesione
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100                                                quota_prev_compl
from ente
   , vista_schematica_emens      vsem
   , denuncia_emens              demi
   , rapporti_individuali        rain
   , rapporti_individuali        rain1
   , anagrafici                  anag
   , anagrafici                  anag1
   , gestioni                    gest
   , comuni                      comu1
   , gestione_tfr_emens          gete
where gest.comune_res    = comu1.cod_comune
  and gest.provincia_res = comu1.cod_provincia
  and anag.ni            = rain.ni
  and anag1.ni           = rain1.ni
  and rain1.ci        = gest.mittente_emens
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag.dal and nvl(anag.al,to_date('3333333','j'))
  and last_day(to_date(lpad(demi.mese,2,'0')||demi.anno,'mmyyyy'))
      between anag1.dal and nvl(anag1.al,to_date('3333333','j'))
  and demi.ci            = rain.ci
  and gest.codice        = nvl(demi.gestione_alternativa,demi.gestione)
  and demi.specie_rapporto = 'COCO'
  and nvl(demi.rettifica,'X')      = 'E'
  and demi.ci  = vsem.ci
  and demi.deie_id       = vsem.deie_id
  and demi.deie_id       = gete.deie_id (+)
group by  demi.ci
 , demi.specie_rapporto
 , demi.rilevanza
 , decode( demi.rilevanza, 'P', 'I')
 , gest.codice
 , anag1.codice_fiscale
 , gest.codice_fiscale
 , gest.nome
 , nvl(ente.cf_software,gest.codice_fiscale) 
 , lpad(gest.provincia_sede_inps,2,'0')||lpad(gest.zona_sede_inps,2,'0')
 , nvl(substr(demi.riferimento,3,4),demi.anno)||'-'||nvl(substr(demi.riferimento,1,2),lpad(demi.mese,2,'0'))
 , gest.codice_fiscale
 , gest.nome
 , anag.codice_fiscale
 , substr(anag.cognome,1,30)
 , substr(anag.nome,1,20)
 , nvl(demi.codice_catasto,comu1.codice_catasto)
 , demi.aliquota*100
 , gest.cap
 , lpad(gest.codice_attivita,5,'0')
 , demi.tipo_rapporto
 , demi.cod_attivita
 , demi.altra_ass
 , demi.tipo_agevolazione
 , gete.tipo_scelta
 , to_char(gete.data_scelta,'yyyy-mm-dd')
 , gete.iscr_prev_obbl
 , gete.iscr_prev_compl
 , gete.fondo_tesoreria
 , to_char(gete.data_adesione,'yyyy-mm-dd')
 , gete.forma_prev_compl
 , gete.tipo_quota_prev_compl
 , gete.quota_prev_compl*100
;