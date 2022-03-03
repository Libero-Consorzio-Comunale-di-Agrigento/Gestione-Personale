CREATE OR REPLACE PACKAGE CURSORE_DMA IS
/******************************************************************************
 NOME:          CURSORE_DMA
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 0    14/04/2005 MS     Prima emissione.
 1.0  19/04/2005 AM     modifiche come da problema BO
 1.1  26/04/2004 AM     modifiche varie come da problemi
 1.2  04/05/2005 AM     eliminata lettura mensilita' *AP
 1.3  11/05/2005 ML	    modificata group by union cur_dip_dma (da to_char(moco.riferimento,'yyyymm') a moco.riferimento
                        perdeva dei record in caso di riferimenti in giorni deiversi dello stesso mese
 1.4  24/05/2005 ML	    modificata determinazione cassa_pensione (A11246)
 2    07/10/2005 ML	    Rideterminazione dei record V1 in caso di recupero giornate (es.: conguaglio per recupero giorni in
                        caso di cessazione non comunicata tempestivamente) (A12362).
 2.1  25/10/2005 ML     Eliminazione gestione nvl sul tipo_part_time (A13185).
 2.2  16/12/2005 ML     Modificato il controllo sul pere.tipo, adesso esclude anche in tipo 'R' (A14010)
 3.0  24/01/2006 ML	    Eliminazioni parti commentate.
 3.1  01/03/2006 ML     Gestione della data di competenza solo se precedente il 1997 (A13924).
 4.0  19/06/2007 ML     Gestione tipo aliquota Cassa / Competenza (A21496)
 4.1  24/09/2007 ML     Inserita procedure DETERMINA_QUALIFICA_DMA copiata da DENUNCIA_INPDAP
                        aggiunta la exception per too_many rows mancante (A22835)
******************************************************************************/
cursor CUR_DIP_DMA
      ( P_ci        number
      , P_anno      number
      , P_mese      number
      , P_gestione  varchar2
      ) is
select pere.ci ci
     , pere.periodo
     , pere.competenza
     , pere.gestione
     , pere.trattamento
     , greatest( pere.dal
               , to_date('01'||to_char(pere.al,'mmyyyy'),'ddmmyyyy')
               , nvl(pegi.dal,to_date('01'||to_char(pere.al,'mmyyyy'),'ddmmyyyy'))
               ) dal
     , pere.dal pere_dal
     , pere.al
     , DECODE( posi.contratto_formazione
             , 'NO', DECODE
                     ( posi.stagionale
                     , 'GG', '2'
                           , DECODE
                             ( posi.part_time
                             , 'SI', decode(posi.tempo_determinato
                                           ,'NO', '8'
                                                ,'18')
                                   , DECODE
                                     ( NVL(pere.ore,cost.ore_lavoro)
                                     , cost .ore_lavoro, decode(posi.tempo_determinato
                                                               ,'SI', '17'
                                                                    , '1')
                                                       , '9')
           		           )
		         )
			 , posi.tipo_formazione)                   impiego
     , DECODE( nvl(pere.ore,cost.ore_lavoro)
             , cost.ore_lavoro, decode( least(P_Anno,2000)
                                      ,2000, '4', '11')
                              , decode(posi.part_time
                                      , 'SI', DECODE( LEAST(P_Anno,2000)
	                                              , 2000, '5', '12')
                                            , decode ( LEAST(P_anno,2000)
          	                                         ,2000, '4', '11'))
             )                                                          servizio
          , posi.part_time                                              part_time
          , posi.tipo_part_time                                         tipo_part_time
          , figi.profilo                profilo
          , pere.ore                    ore
          , cost.ore_lavoro             ore_lavoro
          , pere.posizione
          , pere.figura
          , pere.qualifica
          , pere.contratto
          , pere.cod_astensione
          , pere.tipo_rapporto
 from periodi_retributivi   pere
    , posizioni             posi
    , figure_giuridiche     figi
    , contratti_storici     cost
    , periodi_giuridici     pegi
where ( pere.periodo
      , to_char(greatest(pere.dal,to_date('01'||to_char(pere.al,'mmyyyy'),'ddmmyyyy')),'yyyymm')
      ) in
     (select nvl(max(periodo),last_day(to_date(lpad(to_char(P_mese),2,0)||to_char(P_anno),'mmyyyy')))
           , nvl(substr( max(to_char(periodo,'yyyymmdd')||
                             to_char(greatest( pere1.dal
                                             ,to_date('01'||to_char(pere1.al,'mmyyyy'),'ddmmyyyy')
                                             ),'yyyymm')
                             )
                       ,9)
                ,to_char(P_anno)||lpad(to_char(P_mese),2,0) )
        from periodi_retributivi pere1
           , movimenti_contabili moco
       where pere1.ci = P_ci
         and upper(pere1.competenza) not in ('P','D')
         and upper(pere1.competenza)       = pere1.competenza
         and pere1.servizio               = 'Q'
         and NVL(PERE1.TIPO,' ')       not in ('F','R')
         and pere1.periodo <= last_day(to_date(lpad(to_char(P_mese),2,0)||to_char(P_anno),'mmyyyy'))
         and moco.anno = P_anno
         and moco.mese = P_mese
         and moco.mensilita != '*AP'
         and moco.ci   = P_ci
         and to_char(moco.riferimento,'yyyymm') = to_char(pere1.al,'yyyymm')
         and (moco.voce,moco.sub) in (select voce,sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_DMA'
                                         and to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy')
                                             between dal and nvl(al,to_date('3333333','j'))
                                     )
       group by to_char(moco.riferimento,'yyyymm')
     )
  and pere.ci                     = P_ci
  and pegi.ci(+)        = P_ci
  and pegi.rilevanza(+) = 'P'
  and pere.al     between nvl(pegi.dal(+), to_date('2222222','j'))
                      and nvl(pegi.al(+), to_date('3333333','j'))
  and upper(pere.competenza) not in ('P','D')
  and upper(pere.competenza)      = pere.competenza
  and pere.servizio               = 'Q'
  and pere.gestione            like P_gestione
  and NVL(PERE.TIPO,' ')     not in ('F','R')
  and posi.codice (+) = pere.posizione
  and figi.numero         = pere.figura
  AND cost.contratto      = pere.contratto
  and pere.al between figi.dal and nvl(figi.al,to_date('3333333','j'))
  and pere.al between cost.dal and nvl(cost.al,to_date('3333333','j'))
order by 6
    ;
CURSOR ARR_DMA
      ( P_ci        number
      , P_anno_moco number
      , P_mese_moco number
      , P_anno      number
      , P_mese      number
      , P_cassa     varchar2
      , P_dal       date
      , P_al        date
      ) IS
      select   decode(esvc.dal
                      , to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                  ,decode(esvc.al,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                                    ,to_char(vaca.riferimento,'yyyy')
	                                     ,to_char(esvc.al,'mmyyyy'))
  				     ,to_char(esvc.al,'mmyyyy'))                        I_anno_rif
              , to_char(P_anno_moco)	  		                                        I_anno_comp
              , to_char(max(distinct vaca.riferimento),'ddmmyyyy')                               I_riferimento
              , round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                       / nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                  I_comp_fisse
              , round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                             I_comp_acc
              , round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                        I_comp_18
              , round( sum(decode(vaca.colonna
                                 ,'IND_NON_A',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      )* nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_ind_non_a
             , round( sum(decode(vaca.colonna
                                 ,'IIS_CONGLOBATA',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_iis_congl
             , round( sum(decode(vaca.colonna
                                ,'IPN_PENS',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                            , '')),1)                                        I_ipn_pens
             , round( sum(decode(vaca.colonna
                                ,'CONTR_PENS',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_contr_pens
             , round( sum(decode(vaca.colonna
                                ,'CONTR_AGG',decode( voec.classe||P_cassa
                                                             , 'RX', nvl(vaca.ipn_eap,0)
                                                                   , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                            I_contr_agg
             , round( sum(decode(vaca.colonna
                                ,'IPN_TFS',decode( voec.classe||P_cassa
                                                          , 'RX', nvl(vaca.ipn_eap,0)
                                                                , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                               I_ipn_tfs
             , round( sum(decode(vaca.colonna
                                ,'CONTR_TFS',decode( voec.classe||P_cassa
                                               , 'RX', nvl(vaca.ipn_eap,0)
                                                     , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                             I_contr_tfs
           	 , round( sum(decode(vaca.colonna
                                ,'IPN_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_ipn_tfr
             , round( sum(decode(vaca.colonna
                                ,'CONTR_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_contr_tfr
             , round( sum(decode(vaca.colonna
                                ,'IPN_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_ipn_cassa_cr
             , round( sum(decode(vaca.colonna
                                ,'CONTR_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_con_cassa_cr
             , round( sum(decode(vaca.colonna
                                ,'CONTR_ENPDEDP',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_con_enpdedp
             , round( sum(decode(vaca.colonna
                                ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_tredicesima
             , round( sum(decode(vaca.colonna
                                ,'TEORICO_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_teorico_tfr
             , round( sum(decode(vaca.colonna
                                ,'COMP_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_comp_tfr
            , round( sum(decode(vaca.colonna
                                ,'QUOTA_L166',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_quota_l166
            , round( sum(decode(vaca.colonna
                                ,'CONTR_L166',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_contr_l166
            , round( sum(decode(vaca.colonna
                                ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                   I_comp_premio
            , round( sum(decode(vaca.colonna
                                ,'CONTR_L135',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_contr_l135
            , round( sum(decode(vaca.colonna
                                ,'CONTR_PENS_SOSPESI',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_contr_pens_s
            , round( sum(decode(vaca.colonna
                                ,'CONTR_PREV_SOSPESI',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_contr_prev_s
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_PENS',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                   I_sanz_pens
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_PREV',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_sanz_prev
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_CRED',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                   I_sanz_cred
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_ENPDEDP',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                   I_sanz_enpdedp
           from VISTA_ESVC_ANNI esvc
             , valori_contabili_annuali   vaca
             , voci_economiche            voec
         where esvc.estrazione        = vaca.estrazione
           and esvc.colonna           = vaca.colonna
           and vaca.riferimento
                     between esvc.dal
                         and nvl(esvc.al,to_date('3333333','j'))
           and vaca.anno              = P_anno_moco
           and vaca.mese              = P_mese_moco
           and vaca.mensilita         = (select max(mensilita)
                                           from mensilita
                                          where mese  = P_mese_moco
                                            and tipo in ('A','N','S'))
           and vaca.moco_mese         = P_mese_moco
           and vaca.mensilita        != '*AP'
           and vaca.estrazione        = 'DENUNCIA_DMA'
           and vaca.colonna          in ( 'COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_18','IND_NON_A','IIS_CONGLOBATA'
                                         ,'IPN_PENS','CONTR_PENS','CONTR_AGG','IPN_TFS'
                                         ,'CONTR_TFS','IPN_TFR','CONTR_TFR','IPN_CASSA_CREDITO'
                                         ,'CONTR_CASSA_CREDITO','CONTR_ENPDEDP','TREDICESIMA'
                                         ,'TEORICO_TFR','COMP_TFR','QUOTA_L166','CONTR_L166'
                                         ,'COMP_PREMIO','CONTR_L135','CONTR_PENS_SOSPESI'
                                         ,'CONTR_PREV_SOSPESI','SANZIONE_PENS','SANZIONE_PREV'
                                         ,'SANZIONE_CRED','SANZIONE_ENPDEDP' )
           and vaca.ci                = P_ci
           and vaca.riferimento       < TO_DATE('01'||LPAD(to_char(P_mese),2,0)||to_char(P_anno),'ddmmyyyy')
           and (    P_cassa = 'X' and
                   (    voec.classe != 'R' and nvl(vaca.arr,' ') = 'P'
                     or voec.classe = 'R' and nvl(vaca.ipn_eap,0) != 0
                   )
                or  P_cassa is null and
                    decode(greatest('1997',to_char(vaca.riferimento,'yyyy'))
                          , '1997', to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy')
                                  , to_char(vaca.riferimento,'yyyy'))   = P_anno_moco
               )
           and vaca.riferimento between P_dal
                                    and P_al
           and vaca.voce = voec.codice
  group by decode(esvc.dal
                 ,to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                        ,decode(esvc.al ,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy'),to_char(vaca.riferimento,'yyyy')
                                        ,to_char(esvc.al,'mmyyyy'))
		,to_char(esvc.al,'mmyyyy'))
 having  round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                       / nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
              + round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
               + round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
              + round( sum(decode(vaca.colonna
                                 ,'IND_NON_A',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                 ,'IIS_CONGLOBATA',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'IPN_PENS',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'CONTR_PENS',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'CONTR_AGG',decode( voec.classe||P_cassa
                                                             , 'RX', nvl(vaca.ipn_eap,0)
                                                                   , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'IPN_TFS',decode( voec.classe||P_cassa
                                                          , 'RX', nvl(vaca.ipn_eap,0)
                                                                , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'CONTR_TFS',decode( voec.classe||P_cassa
                                               , 'RX', nvl(vaca.ipn_eap,0)
                                                     , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'IPN_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'IPN_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_ENPDEDP',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'TEORICO_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'COMP_TFR',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'QUOTA_L166',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_L166',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_L135',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'CONTR_PENS_SOSPESI',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'CONTR_PREV_SOSPESI',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_PENS',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_PREV',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_VRED',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_ENPDEDP',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             != 0
         union
         select  decode(esvc.dal
                       ,to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                              ,decode(esvc.al,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                             ,to_char(vaca.riferimento,'yyyy')
                                     ,to_char(esvc.al,'mmyyyy'))
                       ,to_char(esvc.al,'mmyyyy'))                                      I_anno_rif
              , decode(greatest('1997',to_char(vaca.riferimento,'yyyy'))
                       , '1997', to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy')
                               , to_char(vaca.riferimento,'yyyy'))                      I_anno_comp
              , to_char(max(distinct vaca.riferimento),'ddmmyyyy')                      I_riferimento
              , round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                       / nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      )* nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1) arr_fisse
              , round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      )* nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_comp_acc
              , round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      )* nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_comp_18
              , round( sum(decode(vaca.colonna
                                 ,'IND_NON_A',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_ind_non_a
             , round( sum(decode(vaca.colonna
                                 ,'IIS_CONGLOBATA',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_iis_congl
             , round( sum(decode(vaca.colonna
                                ,'IPN_PENS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_ipn_pens
             , round( sum(decode(vaca.colonna
                                ,'CONTR_PENS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                          I_contr_pens
             , round( sum(decode(vaca.colonna
                                ,'CONTR_AGG',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                            I_contr_agg
             , round( sum(decode(vaca.colonna
                                ,'IPN_TFS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                             I_ipn_tfs
             , round( sum(decode(vaca.colonna
                                ,'CONTR_TFS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                            I_contr_tfs
           	 , round( sum(decode(vaca.colonna
                                ,'IPN_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                    I_ipn_tfr
             , round( sum(decode(vaca.colonna
                                ,'CONTR_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                  I_contr_tfr
             , round( sum(decode(vaca.colonna
                                ,'IPN_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                  I_ipn_cassa_cr
             , round( sum(decode(vaca.colonna
                                ,'CONTR_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                        I_con_cassa_cr
             , round( sum(decode(vaca.colonna
                                ,'CONTR_ENPDEDP',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_con_enpdedp
             , round( sum(decode(vaca.colonna
                                ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                         I_tredicesima
             , round( sum(decode(vaca.colonna
                                ,'TEORICO_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                             I_teorico_tfr
             , round( sum(decode(vaca.colonna
                                ,'COMP_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                             I_comp_tfr
            , round( sum(decode(vaca.colonna
                                ,'QUOTA_L166',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                       I_quota_l166
            , round( sum(decode(vaca.colonna
                                ,'CONTR_L166',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                 I_contr_l166
            , round( sum(decode(vaca.colonna
                                ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_comp_premio
            , round( sum(decode(vaca.colonna
                                ,'CONTR_L135',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                           I_contr_l135
            , round( sum(decode(vaca.colonna
                                ,'CONTR_PENS_SOSPESI',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                               I_contr_pens_s
            , round( sum(decode(vaca.colonna
                                ,'CONTR_PREV_SOSPESI',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                I_contr_prev_s
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_PENS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                        I_sanz_pens
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_PREV',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                                  I_sanz_prev
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_CRED',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                              I_sanz_cred
           , round( sum(decode(vaca.colonna
                                ,'SANZIONE_ENPDEDP',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)                          I_sanz_enpdedp
          from VISTA_ESVC_ANNI esvc
             , valori_contabili_annuali   vaca
             , voci_economiche            voec
         where esvc.estrazione        = vaca.estrazione
           and esvc.colonna           = vaca.colonna
           and vaca.riferimento
                     between esvc.dal
                         and nvl(esvc.al,to_date('3333333','j'))
           and vaca.anno              = P_anno_moco
           and vaca.mese              = P_mese_moco
           and vaca.mensilita         = (select max(mensilita)
                                           from mensilita
                                          where mese  = P_mese_moco
                                            and tipo in ('A','N','S'))
           and vaca.moco_mese         = P_mese_moco
           and vaca.mensilita        != '*AP'
           and vaca.estrazione        = 'DENUNCIA_DMA'
           and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_18','IND_NON_A','IIS_CONGLOBATA'
                                         ,'IPN_PENS','CONTR_PENS','CONTR_AGG','IPN_TFS'
                                         ,'CONTR_TFS','IPN_TFR','CONTR_TFR','IPN_CASSA_CREDITO'
                                         ,'CONTR_CASSA_CREDITO','CONTR_ENPDEDP','TREDICESIMA'
                                         ,'TEORICO_TFR','COMP_TFR','QUOTA_L166','CONTR_L166'
                                         ,'COMP_PREMIO','CONTR_L135','CONTR_PENS_SOSPESI'
                                         ,'CONTR_PREV_SOSPESI','SANZIONE_PENS','SANZIONE_PREV'
                                         ,'SANZIONE_CRED','SANZIONE_ENPDEDP')
           and vaca.ci                = P_ci
           and vaca.riferimento       < TO_DATE('01'||LPAD(to_char(P_mese),2,0)||to_char(P_anno),'ddmmyyyy')
           and (    P_cassa = 'X' and
                   (    voec.classe != 'R' and nvl(vaca.arr,'C') = 'C'
                    or voec.classe  = 'R' and (nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)) != 0
                   )
                or  P_cassa is null and
                    decode(greatest('1997',to_char(vaca.riferimento,'yyyy'))
                          , '1997', to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy')
                                  , to_char(vaca.riferimento,'yyyy'))   != P_anno_moco
               )
           and vaca.riferimento between P_dal
                                    and P_al
           and voec.codice            = vaca.voce
  group by decode(esvc.dal, to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                              ,decode(esvc.al,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                             ,to_char(vaca.riferimento,'yyyy')
                                     ,to_char(esvc.al,'mmyyyy'))
                       ,to_char(esvc.al,'mmyyyy'))
             , decode(greatest('1997',to_char(vaca.riferimento,'yyyy'))
                       , '1997', to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy')
                               , to_char(vaca.riferimento,'yyyy'))
   having round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
								                   ,0))
                       / nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
               + round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
              + round( sum(decode(vaca.colonna
                                 ,'IND_NON_A',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                 ,'IIS_CONGLOBATA',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                 , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'IPN_PENS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'CONTR_PENS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'CONTR_AGG',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'IPN_TFS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      )  * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'CONTR_TFS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'IPN_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      )  * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'IPN_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_CASSA_CREDITO',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_ENPDEDP',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'TEORICO_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'COMP_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'QUOTA_L166',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_L166',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
            + round( sum(decode(vaca.colonna
                               ,'CONTR_L135',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'CONTR_PENS_SOSPESI',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'CONTR_PREV_SOSPESI',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_PENS',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_PREV',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_VRED',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )  * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
           + round( sum(decode(vaca.colonna
                               ,'SANZIONE_ENPDEDP',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      ) * nvl(max(distinct decode( vaca.colonna
                                , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      != 0
 ;
CURSOR ARR_DMA2
      ( P_ci        number
      , P_anno_moco number
      , P_mese_moco number
      , P_anno      number
      , P_mese      number
      , P_dal       date
      , P_al        date
      ) IS
      select decode( esvc.dal
                   , to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                  ,decode(esvc.al,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                                    ,to_char(vaca.riferimento,'yyyy')
	                                     ,to_char(esvc.al,'mmyyyy'))
  				 , to_char(esvc.al,'mmyyyy'))                          I_anno_rif
           , decode( esvc.dal
                   , to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                  ,decode(esvc.al,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                                    ,to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy')
	                                     ,to_char(esvc.al,'mmyyyy'))
  				 , to_char(esvc.al,'mmyyyy'))                          I_anno_comp
           , to_char(max(distinct vaca.riferimento),'ddmmyyyy')  I_riferimento
           , round( sum(decode(vaca.colonna
                              ,'COMP_FISSE', nvl(vaca.valore,0)
                                           ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)                                  I_comp_fisse
           , round( sum(decode(vaca.colonna
                              ,'COMP_ACCESSORIE', nvl(vaca.valore,0)
                                                ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                                , '')),1)                             I_comp_acc
           , round( sum(decode(vaca.colonna
                              ,'COMP_18', nvl(vaca.valore,0)
                                        ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                              , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)                                        I_comp_18
           , round( sum(decode(vaca.colonna
                              ,'IND_NON_A',nvl(vaca.valore,0)
                                          ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                  )* nvl(max(distinct decode( vaca.colonna
                                            , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)                                    I_ind_non_a
           , round( sum(decode(vaca.colonna
                              ,'IIS_CONGLOBATA',nvl(vaca.valore,0)
                                               ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                               , '')),1)                                    I_iis_congl
           , round( sum(decode(vaca.colonna
                              ,'IPN_PENS',nvl(vaca.valore,0)
                                         ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)                                        I_ipn_pens
           , round( sum(decode(vaca.colonna
                              ,'CONTR_PENS',nvl(vaca.valore,0)
                                           ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)                                    I_contr_pens
           , round( sum(decode(vaca.colonna
                              ,'CONTR_AGG',nvl(vaca.valore,0)
                                          ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)                            I_contr_agg
           , round( sum(decode(vaca.colonna
                              ,'IPN_TFS',nvl(vaca.valore,0)
                                        ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                              , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)                               I_ipn_tfs
           , round( sum(decode(vaca.colonna
                              ,'CONTR_TFS',nvl(vaca.valore,0)
                                          ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)                             I_contr_tfs
         	 , round( sum(decode(vaca.colonna
                              ,'IPN_TFR',nvl(vaca.valore,0)
                                        ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)                                    I_ipn_tfr
           , round( sum(decode(vaca.colonna
                              ,'CONTR_TFR',nvl(vaca.valore,0)
                                          ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)                                    I_contr_tfr
           , round( sum(decode(vaca.colonna
                              ,'IPN_CASSA_CREDITO',nvl(vaca.valore,0)
                                                  ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)                                    I_ipn_cassa_cr
           , round( sum(decode(vaca.colonna
                              ,'CONTR_CASSA_CREDITO',nvl(vaca.valore,0)
                                                    ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                    , '')),1)                                    I_con_cassa_cr
           , round( sum(decode(vaca.colonna
                              ,'CONTR_ENPDEDP',nvl(vaca.valore,0)
                                              ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                            , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)                                    I_con_enpdedp
           , round( sum(decode(vaca.colonna
                                ,'TREDICESIMA',nvl(vaca.valore,0)
                                              ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)                                    I_tredicesima
           , round( sum(decode(vaca.colonna
                              ,'TEORICO_TFR',nvl(vaca.valore,0)
                                            ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                            , '')),1)                                    I_teorico_tfr
           , round( sum(decode(vaca.colonna
                              ,'COMP_TFR',nvl(vaca.valore,0)
                                         ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)                                    I_comp_tfr
           , round( sum(decode(vaca.colonna
                              ,'QUOTA_L166',nvl(vaca.valore,0)
                                           ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)                                    I_quota_l166
           , round( sum(decode(vaca.colonna
                              ,'CONTR_L166',nvl(vaca.valore,0)
                                           ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)                                    I_contr_l166
           , round( sum(decode(vaca.colonna
                              ,'COMP_PREMIO',nvl(vaca.valore,0)
                                            ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                            , '')),1)                                   I_comp_premio
           , round( sum(decode(vaca.colonna
                              ,'CONTR_L135',nvl(vaca.valore,0)
                                           ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)                                    I_contr_l135
           , round( sum(decode(vaca.colonna
                              ,'CONTR_PENS_SOSPESI',nvl(vaca.valore,0)
                                                   ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                 , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                   , '')),1)                                    I_contr_pens_s
           , round( sum(decode(vaca.colonna
                              ,'CONTR_PREV_SOSPESI',nvl(vaca.valore,0)
                                                   ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                 , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                   , '')),1)                                    I_contr_prev_s
           , round( sum(decode(vaca.colonna
                              ,'SANZIONE_PENS',nvl(vaca.valore,0)
                                              ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                            , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)                                   I_sanz_pens
           , round( sum(decode(vaca.colonna
                              ,'SANZIONE_PREV',nvl(vaca.valore,0)
                                              ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                            , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)                                    I_sanz_prev
           , round( sum(decode(vaca.colonna
                              ,'SANZIONE_CRED',nvl(vaca.valore,0)
                                              ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                            , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)                                   I_sanz_cred
           , round( sum(decode(vaca.colonna
                              ,'SANZIONE_ENPDEDP',nvl(vaca.valore,0)
                                                 ,0))
                  / nvl(max(distinct decode( vaca.colonna
                                           , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                               , '')),1)
                  ) * nvl(max(distinct decode( vaca.colonna
                                             , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                                 , '')),1)                                   I_sanz_enpdedp
       from VISTA_ESVC_ANNI esvc
          , valori_contabili_annuali   vaca
          , voci_economiche            voec
      where esvc.estrazione        = vaca.estrazione
        and esvc.colonna           = vaca.colonna
        and vaca.riferimento between esvc.dal
                                 and nvl(esvc.al,to_date('3333333','j'))
        and vaca.anno              = P_anno_moco
        and vaca.mese              = P_mese_moco
        and vaca.mensilita         = (select max(mensilita)
                                        from mensilita
                                       where mese  = P_mese_moco
                                         and tipo in ('A','N','S'))
        and vaca.moco_mese         = P_mese_moco
        and vaca.mensilita        != '*AP'
        and vaca.estrazione        = 'DENUNCIA_DMA'
        and vaca.colonna          in ( 'COMP_FISSE','COMP_ACCESSORIE'
                                     ,'COMP_18','IND_NON_A','IIS_CONGLOBATA'
                                     ,'IPN_PENS','CONTR_PENS','CONTR_AGG','IPN_TFS'
                                     ,'CONTR_TFS','IPN_TFR','CONTR_TFR','IPN_CASSA_CREDITO'
                                     ,'CONTR_CASSA_CREDITO','CONTR_ENPDEDP','TREDICESIMA'
                                     ,'TEORICO_TFR','COMP_TFR','QUOTA_L166','CONTR_L166'
                                     ,'COMP_PREMIO','CONTR_L135','CONTR_PENS_SOSPESI'
                                     ,'CONTR_PREV_SOSPESI','SANZIONE_PENS','SANZIONE_PREV'
                                     ,'SANZIONE_CRED','SANZIONE_ENPDEDP' )
        and vaca.ci                = P_ci
        and vaca.riferimento       < TO_DATE('01'||LPAD(to_char(P_mese),2,0)||to_char(P_anno),'ddmmyyyy')
        and vaca.riferimento between P_dal and P_al
        and vaca.voce = voec.codice
      group by decode( esvc.dal
                   , to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                  ,decode(esvc.al,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                                    ,to_char(vaca.riferimento,'yyyy')
	                                     ,to_char(esvc.al,'mmyyyy'))
  				 , to_char(esvc.al,'mmyyyy')) 
           , decode( esvc.dal
                   , to_date('0101'||TO_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                  ,decode(esvc.al,to_date('3112'||to_char(esvc.dal,'yyyy'),'ddmmyyyy')
                                                    ,to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy')
	                                     ,to_char(esvc.al,'mmyyyy'))
  				 , to_char(esvc.al,'mmyyyy'))   
     having round( sum(decode(vaca.colonna
                             ,'COMP_FISSE',nvl(vaca.valore,0)
                                          ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'COMP_ACCESSORIE',nvl(vaca.valore,0)
                                               ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                               , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'COMP_18',nvl(vaca.valore,0)
                                       ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                     , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'IND_NON_A',nvl(vaca.valore,0)
                                         ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'IIS_CONGLOBATA',nvl(vaca.valore,0)
                                              ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                            , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'IPN_PENS',nvl(vaca.valore,0)
                                        ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_PENS',nvl(vaca.valore,0)
                                          ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_AGG',nvl(vaca.valore,0)
                                         ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'IPN_TFS',nvl(vaca.valore,0)
                                       ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                     , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_TFS',nvl(vaca.valore,0)
                                         ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'IPN_TFR',nvl(vaca.valore,0)
                                       ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                     , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_TFR',nvl(vaca.valore,0)
                                         ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'IPN_CASSA_CREDITO',nvl(vaca.valore,0)
                                                 ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                               , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                 , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_CASSA_CREDITO',nvl(vaca.valore,0)
                                                  ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                 , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                   , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_ENPDEDP', nvl(vaca.valore,0)
                                             ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'TREDICESIMA',nvl(vaca.valore,0)
                                           ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'TEORICO_TFR',nvl(vaca.valore,0)
                                           ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'COMP_TFR',nvl(vaca.valore,0)
                                        ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'QUOTA_L166',nvl(vaca.valore,0)
                                          ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_L166',nvl(vaca.valore,0)
                                          ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'COMP_PREMIO',nvl(vaca.valore,0)
                                           ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_L135',nvl(vaca.valore,0)
                                          ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_PENS_SOSPESI',nvl(vaca.valore,0)
                                                  ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'CONTR_PREV_SOSPESI',nvl(vaca.valore,0)
                                                  ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'SANZIONE_PENS',nvl(vaca.valore,0)
                                             ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'SANZIONE_PREV',nvl(vaca.valore,0)
                                             ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'SANZIONE_CRED',nvl(vaca.valore,0)
                                             ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
          + round( sum(decode(vaca.colonna
                             ,'SANZIONE_ENPDEDP',nvl(vaca.valore,0)
                                                ,0))
                 / nvl(max(distinct decode( vaca.colonna
                                          , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)
                 ) * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                                , '')),1)
             != 0
 ;
FUNCTION  VERSIONE                   RETURN VARCHAR2;
 PROCEDURE DETERMINA_QUALIFICA_DMA
( D_ANNO          in varchar2,
  D_MESE          in varchar2,
  P_CI            in number,
  D_figura        in number,
  D_qual_pere     in number,
  D_posizione     in varchar2,
  D_tipo_rapporto in varchar2,
  D_dal_rqmi      in varchar2,
  D_dal           in varchar2,
  D_al            in varchar2,
  D_qualifica     in out varchar2,
  D_pr_err_1      in out number,
  D_pr_err_1b     in out number,
  P_prenotazione  in number
);
END;
/
CREATE OR REPLACE PACKAGE BODY CURSORE_DMA IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V4.1 del 24/09/2007';
 END VERSIONE;
PROCEDURE DETERMINA_QUALIFICA_DMA
( D_ANNO          in varchar2,
  D_MESE          in varchar2,
  P_CI            in number,
  D_figura        in number,
  D_qual_pere     in number,
  D_posizione     in varchar2,
  D_tipo_rapporto in varchar2,
  D_dal_rqmi      in varchar2,
  D_dal           in varchar2,
  D_al            in varchar2,
  D_qualifica     in out varchar2,
  D_pr_err_1      in out number,
  D_pr_err_1b     in out number,
  P_prenotazione  in number
) IS
BEGIN

   D_qualifica := null;
     BEGIN
      SELECT rqmi.codice          qua_min
      into D_qualifica
      FROM posizioni posi
         , righe_qualifica_ministeriale rqmi
      WHERE posi.codice      = D_posizione
        AND to_date(D_dal_rqmi,'ddmmyyyy')
            between rqmi.dal and nvl(rqmi.al,to_date('3333333','j'))
         AND nvl(rqmi.posizione,D_posizione)=D_posizione
        AND (   (    rqmi.qualifica is null
                 and rqmi.figura     = D_figura)
             or (    rqmi.figura    is null
                 and rqmi.qualifica  = D_qual_pere)
             or (    rqmi.qualifica is not null
                 and rqmi.figura    is not null
                 and rqmi.qualifica  = d_qual_pere
                 and rqmi.figura     = D_figura)
             or (    rqmi.qualifica is null
                 and rqmi.figura    is null)
                             )
        AND nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
        AND nvl(rqmi.tempo_determinato,posi.tempo_determinato)
                                     = posi.tempo_determinato
        AND nvl(rqmi.formazione_lavoro,posi.contratto_formazione)
                                     = posi.contratto_formazione
        AND nvl(rqmi.part_time,posi.part_time) = posi.part_time
        AND nvl(D_tipo_rapporto,'NULL')     = nvl(rqmi.tipo_rapporto, nvl(D_tipo_rapporto,'NULL'))
        ;
     EXCEPTION
       when no_data_found then
       BEGIN
          SELECT rqmi.codice          qua_min
          into D_qualifica
          FROM posizioni posi
             , righe_qualifica_ministeriale rqmi
          WHERE posi.codice      = D_posizione
            AND to_date(D_dal,'ddmmyyyy') <= nvl(rqmi.al,to_date('3333333','j'))
            AND to_date(D_al,'ddmmyyyy')  >= nvl(rqmi.dal,to_date('2222222','j'))
            AND nvl(rqmi.posizione,D_posizione)=D_posizione
            AND (   (    rqmi.qualifica is null
                     and rqmi.figura     = D_figura)
                 or (    rqmi.figura    is null
                     and rqmi.qualifica  = D_qual_pere)
                 or (    rqmi.qualifica is not null
                     and rqmi.figura    is not null
                     and rqmi.qualifica  = d_qual_pere
                     and rqmi.figura     = D_figura)
                 or (    rqmi.qualifica is null
                     and rqmi.figura    is null)
                                 )
            AND nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
            AND nvl(rqmi.tempo_determinato,posi.tempo_determinato)
                                         = posi.tempo_determinato
            AND nvl(rqmi.formazione_lavoro,posi.contratto_formazione)
                                         = posi.contratto_formazione
            AND nvl(rqmi.part_time,posi.part_time) = posi.part_time
            AND nvl(D_tipo_rapporto,'NULL')     = nvl(rqmi.tipo_rapporto, nvl(D_tipo_rapporto,'NULL'))
            ;
     EXCEPTION
       when no_data_found then
       BEGIN
        D_pr_err_1 := D_pr_err_1 + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_1
             , ' '
             , null
       from dual;
        D_pr_err_1 := D_pr_err_1 + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_1
             , 'P05986'
             , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
               'Dal '||TO_CHAR(to_date(D_dal,'ddmmyyyy'),'dd/mm/yyyy')||'  '||
                'Al '||TO_CHAR(to_date(D_al,'ddmmyyyy'),'dd/mm/yyyy')
       from dual
       where not exists (select 'x' from a_segnalazioni_errore
                          where no_prenotazione = P_prenotazione
                            and passo           = 1
                            and errore          = 'P05986'
                            and precisazione    = 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
                                                  'Dal '||TO_CHAR(to_date(D_dal,'ddmmyyyy'),'dd/mm/yyyy')||'  '||
                                                  'Al '||TO_CHAR(to_date(D_al,'ddmmyyyy'), 'dd/mm/yyyy')
                         );
       END;
      when too_many_rows then
       BEGIN
        D_pr_err_1b := D_pr_err_1b + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_1b
             , ' '
             , null
        from dual;
        D_pr_err_1b := D_pr_err_1b + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_1b
             , 'P05985'
             , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
               'Dal '||TO_CHAR(to_date(D_dal,'ddmmyyyy'),'dd/mm/yyyy')||'  '||
                'Al '||TO_CHAR(to_date(D_al,'ddmmyyyy'), 'dd/mm/yyyy')
       from dual
       where not exists (select 'x' from a_segnalazioni_errore
                          where no_prenotazione = P_prenotazione
                            and passo          = 1
                            and errore         = 'P05985'
                            and precisazione   = 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
                                                 'Dal '||TO_CHAR(to_date(D_dal,'ddmmyyyy'),'dd/mm/yyyy')||'  '||
                                                 'Al '||TO_CHAR(to_date(D_al,'ddmmyyyy'), 'dd/mm/yyyy')
                         );
       END;
       END;
      when too_many_rows then
       BEGIN
        D_pr_err_1b := D_pr_err_1b + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_1b
             , ' '
             , null
        from dual;
        D_pr_err_1b := D_pr_err_1b + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_1b
             , 'P05985'
             , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
               'Dal '||TO_CHAR(to_date(D_dal,'ddmmyyyy'),'dd/mm/yyyy')||'  '||
                'Al '||TO_CHAR(to_date(D_al,'ddmmyyyy'), 'dd/mm/yyyy')
       from dual
       where not exists (select 'x' from a_segnalazioni_errore
                          where no_prenotazione = P_prenotazione
                            and passo          = 1
                            and errore         = 'P05985'
                            and precisazione   = 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
                                                 'Dal '||TO_CHAR(to_date(D_dal,'ddmmyyyy'),'dd/mm/yyyy')||'  '||
                                                 'Al '||TO_CHAR(to_date(D_al,'ddmmyyyy'), 'dd/mm/yyyy')
                         );
       END;
     END;
END DETERMINA_QUALIFICA_DMA;
END cursore_dma;
/
