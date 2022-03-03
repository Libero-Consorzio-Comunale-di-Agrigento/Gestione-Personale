CREATE OR REPLACE PACKAGE CURSORE_FISCALE_06 IS
/******************************************************************************
 NOME:          CURSORE_FISCALE per elaborazione CUD2006 - redditi 2005

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  08/01/2007 MS     Prima emissione.
******************************************************************************/
  cursor CUR_RPFA2 
  ( P_anno         number
  , P_filtro_1     varchar2
  , P_filtro_2     varchar2
  , P_filtro_3     varchar2
  , P_filtro_4     varchar2
  , P_da_ci        number
  , P_a_ci         number
  , P_cod_fis      varchar2
  , P_estrazione_i varchar2
  , P_voce_menu    varchar2
  , P_ente         varchar2
  , P_ambiente     varchar2
  , P_utente       varchar2  
) is

-- Dipendenti con previdenziale e fiscale 
  select  max(distinct rpfa.s1)              s1
                , max(distinct rpfa.s2)              s2
                , max(distinct rpfa.s3)              s3
                , max(distinct rpfa.s4)              s4
                , max(distinct decode(RAIND.nome,'',1,0)||RAIND.cognome||'  '||RAIND.nome||decode(RAIND.ci,RAIN.ci,1,
                      decode(RAIND.ci,RADI.ci,0,2))||RAIN.cognome||'  '||RAIN.nome) S5
                , max(distinct rpfa.s6)              s6
                , max(distinct rpfa.c1)              c1
                , rpfa.ci                                        ci
                , rain.cognome
                , rain.nome
                , anag.codice_fiscale                            cod_fis
                , max(distinct clra.cat_fiscale)                          cat_fiscale
                , to_number(radi.ci_erede)                       ci_erede
                , max(distinct radi.quota_erede)                          quota_erede
                , max(distinct anag.ni)                                   ni
                , max(distinct substr(to_char(anag.data_nas
                                ,'ddmmyyyy'),1,8))               data_nas
                , max(distinct anag.sesso)                                sesso
                , max(distinct anag.comune_nas)                           comune_nas
                , max(distinct anag.provincia_nas)                        provincia_nas
				, max(distinct rpad(nvl( P_cod_fis
                      , ltrim(nvl( gest.codice_fiscale
                                  ,gest.partita_iva))),16))  ente_cf
                ,min(sepr.posizione) pos_minima
	from gestioni            gest
       , anagrafici            anag
       , rapporti_individuali  rain
       , rapporti_individuali  raind
       , classi_rapporto       clra
       , rapporti_diversi      radi
       , tab_report_fine_anno  rpfa
       , selezione_previdenziale sepr
   where gest.codice (+)          = rpfa.c1
     and rpfa.anno                = P_anno
     and nvl(rpfa.c1,' ')      like P_filtro_1
     and nvl(rpfa.c2,' ')      like P_filtro_2
     and nvl(rpfa.c3,' ')      like P_filtro_3
     and nvl(rpfa.c4,' ')      like P_filtro_4
     and rpfa.ci            between P_da_ci and P_a_Ci
     and anag.ni                  = rain.ni
     and anag.al                 is null
     and rain.ci                  = rpfa.ci
     and rain.ci not in (select ci_erede
                           from RAPPORTI_DIVERSI radi
                          where radi.rilevanza in ('L','R')
                            and radi.anno = P_anno
                         ) 
     and raind.ci = nvl(radi.ci_erede,rain.ci)
     and radi.ci (+) = rpfa.ci
     and radi.rilevanza (+) = 'E'
     and radi.anno (+) = P_anno
     and rain.rapporto            = clra.codice
     and clra.cat_fiscale        in ('1','10','15','2','20','25')
     and sepr.ci = rain.ci 
     and sepr.anno = P_anno
     and sepr.posizione <=  decode(P_voce_menu,'770',7,6)
     and ( P_anno = 2005
       and sepr.posizione != 2
        or P_anno != 2005
         )
     and radi.ci (+) = rpfa.ci
     and nvl(P_estrazione_i,'1')  = '1'
     AND EXISTS
         (SELECT 'x'
            FROM RAPPORTI_INDIVIDUALI rain
           WHERE rain.ci = rpfa.ci
             AND (   rain.CC IS NULL
                  OR EXISTS
                    (SELECT 'x'
                       FROM a_competenze
                      WHERE ENTE        = p_ente
                        AND ambiente    = p_ambiente
                        AND utente      = p_utente
                        AND competenza  = 'CI'
                        AND oggetto     = rain.CC
                    )
                 )
           )
   group by rpfa.ci
          , rain.cognome
          , rain.nome
          , anag.codice_fiscale
          , to_number(radi.ci_erede)
  union
-- Dipendenti inseriti manualmente in selezione previdenziale 
  select null                                           s1
              , null                                           s2
              , null                                           s3
              , null                                           s4
              , max(distinct decode(RAIND.nome,'',1,0)||RAIND.cognome||'  '||RAIND.nome||decode(RAIND.ci,RAIN.ci,1,
                    decode(RAIND.ci,RADI.ci,0,2))||RAIN.cognome||'  '||RAIN.nome) S5
              , null                                           s6
  	        , null                                           c1
              , rain.ci                                        ci
              , rain.cognome
              , rain.nome
              , anag.codice_fiscale                            cod_fis
              , max(distinct clra.cat_fiscale)                          cat_fiscale
              , to_number(radi.ci_erede)                       ci_erede
              , max(distinct radi.quota_erede)                          quota_erede
              , max(distinct anag.ni)                                   ni
              , max(distinct substr(to_char(anag.data_nas
                              ,'ddmmyyyy'),1,8))               data_nas
              , max(distinct anag.sesso)                                sesso
              , max(distinct anag.comune_nas)                           comune_nas
              , max(distinct anag.provincia_nas)                        provincia_nas
			  , max(distinct rpad(nvl( P_cod_fis
                      , ltrim(nvl( gest.codice_fiscale
                                  ,gest.partita_iva))),16))  ente_cf
              ,min(sepr.posizione) pos_minima
	from gestioni              gest
       , anagrafici            anag
       , rapporti_individuali  rain
       , rapporti_individuali  raind
       , classi_rapporto       clra
       , rapporti_diversi      radi
       , rapporti_giuridici    ragi
       , selezione_previdenziale sepr
   where gest.codice (+)          = ragi.gestione
     and anag.ni                  = rain.ni
     and anag.al                 is null
     and rain.ci            between P_da_ci and P_a_Ci
     and rain.ci                  = ragi.ci (+)
     and raind.ci = nvl(radi.ci_erede,rain.ci)
     and radi.ci (+) = rain.ci
     and rain.ci not in (select ci_erede
                           from RAPPORTI_DIVERSI radi
                          where radi.rilevanza in ('L','R')
                            and radi.anno = P_anno
                         ) 
     and radi.rilevanza (+) = 'E'
     and radi.anno (+) = P_anno
     and rain.rapporto            = clra.codice
     and clra.cat_fiscale        in ('1','10','15','2','20','25')
     and sepr.ci = rain.ci 
     and sepr.anno = P_anno
     and sepr.posizione <=  decode(P_voce_menu,'770',7,6)
     and ( P_anno = 2005
       and sepr.posizione != 2
        or P_anno != 2005
         )
     and not exists (select 'x'
                       from tab_report_fine_anno rpfa
                      where rpfa.anno = P_anno
                        and rpfa.ci = rain.ci
                    )
     and not exists (select 'x'
                       from periodi_retributivi pere
                      where pere.anno = P_anno
                        and pere.ci = rain.ci
                    )
     and nvl(P_estrazione_i,'2')  = '2'
     AND  (   rain.CC IS NULL
                  OR EXISTS
                    (SELECT 'x'
                       FROM a_competenze
                      WHERE ENTE        = p_ente
                        AND ambiente    = p_ambiente
                        AND utente      = p_utente
                        AND competenza  = 'CI'
                        AND oggetto     = rain.CC
                    )
           )
   group by rain.ci
          , rain.cognome
          , rain.nome
          , anag.codice_fiscale
          , to_number(radi.ci_erede)
   union
-- Dipendenti senza selezione previdenziale e presenti in denuncia caaf 
  select null                                           s1
       , null                                           s2
       , null                                           s3
       , null                                           s4
       , null                                           s5
       , null                                           s6
   	 , null     	 	 	 	 	   	       c1
	 , tbfa.ci                                        ci
       , rain.cognome
       , rain.nome
       , anag.codice_fiscale                            cod_fis
       , max(distinct clra.cat_fiscale)                      cat_fiscale
       , max(distinct radi.ci_erede)                             ci_erede
	 , max(distinct radi.quota_erede)                          quota_erede
       , max(distinct anag.ni)                                   ni
       , max(distinct substr(to_char(anag.data_nas
                       ,'ddmmyyyy'),1,8))               data_nas
       , max(distinct anag.sesso)                                sesso
       , max(distinct anag.comune_nas)                           comune_nas
       , max(distinct anag.provincia_nas)                        provincia_nas
	   ,max(distinct rpad(nvl( P_cod_fis
                      , ltrim(nvl( gest.codice_fiscale
                                  ,gest.partita_iva))),16))  ente_cf
       , 5 pos_minima
	from gestioni              gest
       , anagrafici            anag
       , rapporti_individuali  rain
       , classi_rapporto       clra
       , rapporti_diversi      radi
	 , report_770_abis       tbfa
   where gest.codice (+)          = tbfa.c1
     and tbfa.anno                = P_anno
     and tbfa.ci            between P_da_ci and P_a_Ci
     and nvl(tbfa.c1,' ')      like P_filtro_1
     and nvl(tbfa.c2,' ')      like P_filtro_2
     and nvl(tbfa.c3,' ')      like P_filtro_3
     and nvl(tbfa.c4,' ')      like P_filtro_4
     and anag.ni                  = rain.ni
     and anag.al                 is null
     and rain.ci                  = tbfa.ci
     and rain.ci not in (select ci_erede
                           from RAPPORTI_DIVERSI radi
                          where radi.rilevanza in ('L','R')
                            and radi.anno = P_anno
                         ) 
     and rain.rapporto            = clra.codice
     and clra.cat_fiscale        in ('1','10','15','2','20','25')
     and radi.ci (+) = tbfa.ci
     and exists
             (select 'x' from denuncia_caaf
               where anno (+) = P_anno - 1
                 and ci   (+) = tbfa.ci
                 and tipo (+) = 0
                 and (  nvl(conguaglio_1r,' ') != ' '
                     or nvl(conguaglio_2r,' ') != ' ')
              union
              select 'x' from movimenti_contabili
               where anno     = tbfa.anno
                 and mese    >= 5
                 and ci       = tbfa.ci
                 and voce    in
                    (select codice from voci_economiche
                      where specifica in
                                 ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
                                 ,'IRPEF_AP','IRPEF_APC','ADD_R_DBC'
                                 ,'ADD_R_DB','ADD_R_CR','ADD_R_CRC'
                                 ,'ADD_R_RAS','ADD_R_RASC','ADD_R_RIS'
                                 ,'ADD_R_RISC','ADD_R_INT','ADD_R_INTC'
                                 ,'IRPEF_SINT','IRPEF_1INT'
                                 ,'IRPEF_AINT','IRPEF_AINC','IRPEF_2R'
                                 ,'IRPEF_2INT'
                                 ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
                                 ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
                                 ,'IRPEF_RAPC','IRPEF_RIAC'
                                 ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP'
                                 ,'ADD_C_CR','ADD_C_DB','ADD_C_RAS'
                                 ,'ADD_C_INT','ADD_C_RIS','ADD_C_CRC'
                                 ,'ADD_C_DBC','ADD_C_RASC','ADD_C_INTC'
                                 ,'ADD_C_RISC','IRPEF_1RC','IRPEF_2RC'
                                 ,'IRPEF_1INC','IRPEF_1SOC','IRPEF_2INC'
                                 ,'IRPEF_2SOC','IRPEF_RA1C','IRPEF_RI1C')))
   	 and not exists (select ci
                         from selezione_previdenziale   -- prima leggeva da tab_report_fine_anno
                        where anno = P_anno
                          and ci = tbfa.ci)
      and P_voce_menu = '770'
      and nvl(P_estrazione_i,'2')  = '2' 
     AND EXISTS
         (SELECT 'x'
            FROM RAPPORTI_INDIVIDUALI rain
           WHERE rain.ci = tbfa.ci
             AND (   rain.CC IS NULL
                  OR EXISTS
                    (SELECT 'x'
                       FROM a_competenze
                      WHERE ENTE        = p_ente
                        AND ambiente    = p_ambiente
                        AND utente      = p_utente
                        AND competenza  = 'CI'
                        AND oggetto     = rain.CC
                    )
                 )
           )
    group by tbfa.ci
          , rain.cognome
          , rain.nome
          , anag.codice_fiscale 
   order by 1,2,3,4,5,6,21 
  ;
  cursor CUR_EMENS 
  ( P_anno           number
  , P_ci             number
  , P_voce_menu      varchar2
  , P_decimali       varchar2
  ) is
  select gest.posizione_inps
       , deie.specie_rapporto
       , min(deie.mese) mese_da
       , max(deie.mese) mese_a
       , decode(dape.identificatore,'BONUS',1,0) bonus_id
       , decode(nvl(deie.tipo_contribuzione,'00')
               ,'0', 'X' ,'00','X' ,'48','X' ,'49','X' ,'52','X' 
               ,'53','X' ,'54','X' ,'56','X' ,'58','X'
               ,'61','X' ,'62','X' ,'63','X' ,'65','X'
               ,'67','X' ,'68','X' ,'69','X' ,'76','X'
               ,'77','X' ,'99','') inps
       , decode(nvl(deie.tipo_contribuzione,'00')
               ,'03','X' ,'10','X' ,'64','X' ,'66','X'
               ,'70','X' ,'71','X' ,'72','X' ,'73','X' ,'' ) altro
       , to_char(decode(P_decimali
                       ,'X', round(sum(nvl(deie.imponibile,0)*decode(deie.rettifica,'E',-1,1)),2)*100
                           , round(sum(nvl(deie.imponibile,0)*decode(deie.rettifica,'E',-1,1)),0)
                       )) imponibile
       , to_char(decode(P_decimali
                       ,'X', round(sum(nvl(deie.ritenuta,0)*decode(deie.rettifica,'E',-1,1)),2)*100
                           , round(sum(nvl(deie.ritenuta,0)*decode(deie.rettifica,'E',-1,1)),0)
                       )) ritenuta
       , to_char(decode(P_decimali
                       ,'X', round(sum(nvl(deie.contributo,0)*decode(deie.rettifica,'E',-1,1)),2)*100
                           , round(sum(nvl(deie.contributo,0)*decode(deie.rettifica,'E',-1,1)),0)
                       )) contributo
       , to_char(decode(P_decimali
                       ,'X', round(sum(nvl(deie.imp_agevolazione,0)*decode(deie.rettifica,'E',-1,1)),2)*100
                           , round(sum(nvl(deie.imp_agevolazione,0)*decode(deie.rettifica,'E',-1,1)),0)
                       )) imp_agevolazione
       , max(deie.tipo_agevolazione) tipo_agevolazione
      from denuncia_emens deie
         , gestioni       gest
         , dati_particolari_emens dape
     where dape.deie_id (+)       = deie.deie_id
       and nvl(to_number(substr(deie.riferimento,3,4)),P_anno) = P_anno
       and deie.ci in
           (select P_ci
              from dual
             union
            select ci_erede
              from RAPPORTI_DIVERSI radi
             where radi.ci = P_ci
               and radi.rilevanza in ('L','R')
               and radi.anno = P_anno
            )                        
       and deie.gestione  = gest.codice
     group by  gest.posizione_inps
             , deie.specie_rapporto
             , decode(dape.identificatore,'BONUS',1,0)
             , decode(nvl(deie.tipo_contribuzione,'00')
                         ,'0', 'X' ,'00','X' ,'48','X' ,'49','X' ,'52','X' 
                         ,'53','X' ,'54','X' ,'56','X' ,'58','X'
                         ,'61','X' ,'62','X' ,'63','X' ,'65','X'
                         ,'67','X' ,'68','X' ,'69','X' ,'76','X'
                         ,'77','X' ,'99','')
             , decode(nvl(deie.tipo_contribuzione,'00')
                         ,'03','X' ,'10','X' ,'64','X' ,'66','X'
                         ,'70','X' ,'71','X' ,'72','X' ,'73','X' ,'')
   order by 2,3
;

cursor CUR_DMA
  ( P_anno         number
  , P_ci           number
  , P_decimali     varchar2
  , P_dma_ass      varchar2
  , P_forza_importi varchar2
  ) is
    select dma1.gest_cf            gest_cf
         , dma1.prog_inpdap        prog_inpdap
         , dma1.cassa_pensione     cassa_pensione
         , dma1.cassa_previdenza   cassa_previdenza
         , dma1.cassa_credito      cassa_credito
         , dma1.cassa_enpdedp      cassa_enpdedp
         , dma1.anno_rif           anno_rif
         , to_char(sum(nvl(dma1.ipn_pens,0)))             ipn_pens
         , to_char(sum(nvl(dma1.contr_pens,0)))           contr_pens
         , to_char(sum(nvl(dma1.ipn_tfs,0)))              ipn_tfs
         , to_char(sum(nvl(dma1.contr_tfs,0)))            contr_tfs
         , to_char(sum(nvl(dma1.ipn_tfr,0)))              ipn_tfr
         , to_char(sum(nvl(dma1.contr_tfr,0)))            contr_tfr
         , to_char(sum(nvl(dma1.ipn_cassa_credito,0)))    ipn_cassa_credito
         , to_char(sum(nvl(dma1.contr_cassa_credito,0)))  contr_cassa_credito
         , to_char(sum(nvl(dma1.ipn_enpdedp,0)))          ipn_enpdedp
         , to_char(sum(nvl(dma1.contr_enpdedp,0)))        contr_enpdedp
         , to_char(sum(nvl(dma1.contr_calamita,0)))       contr_calamita
    from 
  ( select dma.gest_cf            gest_cf
         , dma.prog_inpdap        prog_inpdap
         , dma.cassa_pensione     cassa_pensione
         , dma.cassa_previdenza   cassa_previdenza
         , decode( nvl( decode( P_forza_importi
                         , 'A', decode( sum(nvl(dma.contr_cassa_credito,0))
                                       , 0, 0 
                                          , sum(nvl(dma.ipn_cassa_credito,0))
                                       )
                              , sum(nvl(dma.ipn_cassa_credito,0))
                        ),0 )
                + nvl(decode( P_forza_importi
                        , 'F', decode( sum(nvl(dma.contr_cassa_credito,0))
                                      , 0, decode(sum(nvl(dma.ipn_cassa_credito,0))
                                                 ,0, null
                                                   , decode(P_decimali
                                                           ,'X', decode( sign( abs(sum(nvl(dma.ipn_cassa_credito,0)))-50)
                                                                        ,-1, null
                                                                           , 1 * sign(sum(nvl(dma.ipn_cassa_credito,0)))
                                                                       )
                                                               , decode( sum(nvl(dma.ipn_cassa_credito,0))
                                                                       ,0, null
                                                                         , 1 * sign(sum(nvl(dma.ipn_cassa_credito,0)))
                                                                       )
                                                             )
                                                 )
                                        , sum(nvl(dma.contr_cassa_credito,0))
                                      )
                             , sum(nvl(dma.contr_cassa_credito,0))
                       ),0)
                 ,0, null
                   , '9' )          cassa_credito
         , decode( nvl(decode( P_forza_importi
                          , 'A', decode( sum(nvl(dma.contr_enpdedp,0))
                                        , 0, 0 
                                           , sum(nvl(dma.ipn_enpdedp,0))
                                        )
                               , sum(nvl(dma.ipn_enpdedp,0))
                         ),0) 
                + nvl(decode( P_forza_importi
                        , 'F', decode( sum(nvl(dma.contr_enpdedp,0))
                                     , 0, decode( sum(nvl(dma.ipn_enpdedp,0))
                                                 ,0, null
                                                   , decode(P_decimali
                                                            ,'X', decode( sign( abs(sum(nvl(dma.ipn_enpdedp,0)))-50)
                                                                        ,-1, null
                                                                            , 1 * sign(sum(nvl(dma.ipn_enpdedp,0)))
                                                                        )
                                                                , decode(sum(nvl(dma.ipn_enpdedp,0))
                                                                        ,0, null
                                                                          , 1 * sign(sum(nvl(dma.ipn_enpdedp,0)))
                                                                       )
                                                             )
                                                 )
                                        , sum(nvl(dma.contr_enpdedp,0))
                                     )
                             , sum(nvl(dma.contr_enpdedp,0))
                         ),0)
                 ,0, null
                   , '8' )
                                  cassa_enpdedp
         , dma.anno_rif           anno_rif
         , decode( P_forza_importi
                 , 'A', decode( sum(nvl(dma.contr_pens,0))
                              , 0, 0 
                                 , sum(nvl(dma.ipn_pens,0))
                              )
                      , sum(nvl(dma.ipn_pens,0))
                 )                ipn_pens
         , decode( P_forza_importi
                 , 'F', decode( sum(nvl(dma.contr_pens,0))
                               , 0, decode(P_decimali
                                          ,'X', decode( sign( abs(sum(nvl(dma.ipn_pens,0)))-50)
                                                        ,-1, null
                                                           , 1 * sign(sum(nvl(dma.ipn_pens,0)))
                                                      )
                                              , decode(sum(nvl(dma.ipn_pens,0))
                                                      ,0, null
                                                        , 1 * sign(sum(nvl(dma.ipn_pens,0)))
                                                      )
                                          )
                                  , sum(nvl(dma.contr_pens,0))
                               )
                      , sum(nvl(dma.contr_pens,0))
                 )                contr_pens
         , decode( P_forza_importi
                 , 'A', decode( sum(nvl(dma.contr_tfs,0))
                              , 0, 0 
                                 , sum(nvl(dma.ipn_tfs,0))
                              )
                      , sum(nvl(dma.ipn_tfs,0))
                 )                ipn_tfs
         , decode( P_forza_importi
                 , 'F', decode( sum(nvl(dma.contr_tfs,0))
                               , 0, decode(P_decimali
                                          ,'X', decode( sign( abs(sum(nvl(dma.ipn_tfs,0)))-50)
                                                        ,-1, null
                                                           , 1 * sign(sum(nvl(dma.ipn_tfs,0)))
                                                      )
                                              , decode(sum(nvl(dma.ipn_tfs,0))
                                                      ,0, null
                                                        , 1 * sign(sum(nvl(dma.ipn_tfs,0)))
                                                      )
                                          )
                                  , sum(nvl(dma.contr_tfs,0))
                               )
                      , sum(nvl(dma.contr_tfs,0))
                 )             contr_tfs
         , decode( P_forza_importi
                 , 'A', decode( sum(nvl(dma.contr_tfr,0))
                              , 0, 0 
                                 , sum(nvl(dma.ipn_tfr,0))
                              )
                      , sum(nvl(dma.ipn_tfr,0))
                 )                ipn_tfr
         , decode( P_forza_importi
                 , 'F', decode( sum(nvl(dma.contr_tfr,0))
                               , 0, decode(P_decimali
                                          ,'X', decode( sign( abs(sum(nvl(dma.ipn_tfr,0)))-50)
                                                        ,-1, null
                                                           , 1 * sign(sum(nvl(dma.ipn_tfr,0)))
                                                      )
                                              , decode(sum(nvl(dma.ipn_tfr,0))
                                                      ,0, null
                                                        , 1 * sign(sum(nvl(dma.ipn_tfr,0)))
                                                      )
                                          )
                                  , sum(nvl(dma.contr_tfr,0))
                               )
                      , sum(nvl(dma.contr_tfr,0))
                 )             contr_tfr
         , decode( P_forza_importi
                 , 'A', decode( sum(nvl(dma.contr_cassa_credito,0))
                              , 0, 0 
                                 , sum(nvl(dma.ipn_cassa_credito,0))
                              )
                      , sum(nvl(dma.ipn_cassa_credito,0))
                 )    ipn_cassa_credito
         , decode( P_forza_importi
                 , 'F', decode( sum(nvl(dma.contr_cassa_credito,0))
                               , 0, decode(P_decimali
                                          ,'X', decode( sign( abs(sum(nvl(dma.ipn_cassa_credito,0)))-50)
                                                        ,-1, null
                                                           , 1 * sign(sum(nvl(dma.ipn_cassa_credito,0)))
                                                      )
                                              , decode(sum(nvl(dma.ipn_cassa_credito,0))
                                                      ,0, null
                                                        , 1 * sign(sum(nvl(dma.ipn_cassa_credito,0)))
                                                      )
                                          )
                                  , sum(nvl(dma.contr_cassa_credito,0))
                               )
                      , sum(nvl(dma.contr_cassa_credito,0))
                 )             contr_cassa_credito
         , decode( P_forza_importi
                 , 'A', decode( sum(nvl(dma.contr_enpdedp,0))
                              , 0, 0 
                                 , sum(nvl(dma.ipn_enpdedp,0))
                              )
                      , sum(nvl(dma.ipn_enpdedp,0))
                 )                ipn_enpdedp
         , decode( P_forza_importi
                 , 'F', decode( sum(nvl(dma.contr_enpdedp,0))
                               , 0, decode(P_decimali
                                          ,'X', decode( sign( abs(sum(nvl(dma.ipn_enpdedp,0)))-50)
                                                        ,-1, null
                                                           , 1 * sign(sum(nvl(dma.ipn_enpdedp,0)))
                                                      )
                                              , decode(sum(nvl(dma.ipn_enpdedp,0))
                                                      ,0, null
                                                        , 1 * sign(sum(nvl(dma.ipn_enpdedp,0)))
                                                      )
                                          )
                                  , sum(nvl(dma.contr_enpdedp,0))
                               )
                      , sum(nvl(dma.contr_enpdedp,0))
                 )             contr_enpdedp
        , sum(nvl(dma.contr_calamita,0))     contr_calamita
      from ( select gest.codice_fiscale       gest_cf
                  , gest.progressivo_inpdap   prog_inpdap
                  , max(ddma.cassa_pensione)  cassa_pensione
                  , max(decode(ddma.cassa_previdenza
                          ,null,null
                               ,ddma.cassa_previdenza||lpad(nvl(ddma.fine_servizio,0),3,0)
                          ))                 cassa_previdenza
                  , max(ddma.cassa_credito)  cassa_credito
                  , max(ddma.cassa_enpdedp)  cassa_enpdedp
                  , substr(lpad(nvl(ddma.riferimento,P_anno),6,' '),3,4)       anno_rif
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.ipn_pens_periodo,0)),2)*100
                              , round(sum(nvl(ddma.ipn_pens_periodo,0)),0)
                          )        ipn_pens
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_pens_periodo,0) + nvl(contr_su_eccedenza,0)),2)*100
                              , round(sum(nvl(ddma.contr_pens_periodo,0) + nvl(contr_su_eccedenza,0)),0)
                          )        contr_pens
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.ipn_tfs,0)),2)*100
                              , round(sum(nvl(ddma.ipn_tfs,0)),0)
                          )        ipn_tfs
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_tfs,0)),2)*100
                              , round(sum(nvl(ddma.contr_tfs,0)),0)
                          )        contr_tfs
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.ipn_tfr,0)),2)*100
                              , round(sum(nvl(ddma.ipn_tfr,0)),0)
                          )        ipn_tfr
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_ipn_tfr,0)),2)*100
                              , round(sum(nvl(ddma.contr_ipn_tfr,0)),0)
                          )        contr_tfr
                  , decode( nvl(max(ddma.cassa_credito),0)
                           ,0, 0
                             , decode(P_decimali
                                      ,'X', round(sum(nvl(ddma.ipn_cassa_credito,0)),2)*100
                                          , round(sum(nvl(ddma.ipn_cassa_credito,0)),0)
                                      )
                           )        ipn_cassa_credito
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_cassa_credito,0)),2)*100
                              , round(sum(nvl(ddma.contr_cassa_credito,0)),0)
                          )    contr_cassa_credito
                  , decode( nvl(max(ddma.cassa_enpdedp),0)
                           ,0, 0
                             , decode(P_decimali
                                     ,'X', round(sum(nvl(ddma.ipn_cassa_credito,0)),2)*100
                                         , round(sum(nvl(ddma.ipn_cassa_credito,0)),0)
                                     )
                          )        ipn_enpdedp
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_enpdedp,0)),2)*100
                              , round(sum(nvl(ddma.contr_enpdedp,0)),0)
                          )        contr_enpdedp
                  , decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_pens_calamita,0) + nvl(contr_prev_calamita,0)),2)*100
                              , round(sum(nvl(ddma.contr_pens_calamita,0) + nvl(contr_prev_calamita,0)),0)
                          )        contr_calamita
               from denuncia_dma    ddma
                  , gestioni        gest
              where ddma.anno     = P_anno
                and ddma.ci in
                            (select P_ci
                               from dual
                              union
                             select ci_erede
                               from RAPPORTI_DIVERSI radi
                              where radi.ci = P_ci
                                and radi.rilevanza in ('L','R')
                                and radi.anno = P_anno
                            )
                and ddma.gestione  = gest.codice
          group by gest.codice_fiscale 
                 , gest.progressivo_inpdap
                 , decode(P_dma_ass,'X',ddma.cassa_pensione)
                 , decode(P_dma_ass,'X',decode(ddma.cassa_previdenza
                                               ,null,null
                                                    ,ddma.cassa_previdenza||lpad(nvl(ddma.fine_servizio,0),3,0)
                                              )
                                       ,'')
                 , decode(P_dma_ass,'X',ddma.cassa_credito,'')
                 , decode(P_dma_ass,'X',ddma.cassa_enpdedp,'')
                 , substr(lpad(nvl(ddma.riferimento,P_anno),6,' '),3,4)
             having decode(P_decimali
                          ,'X', round(sum(nvl(ddma.ipn_pens_periodo,0)),2)*100
                              , round(sum(nvl(ddma.ipn_pens_periodo,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_pens_periodo,0) + nvl(contr_su_eccedenza,0)),2)*100
                              , round(sum(nvl(ddma.contr_pens_periodo,0) + nvl(contr_su_eccedenza,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.ipn_tfs,0)),2)*100
                              , round(sum(nvl(ddma.ipn_tfs,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_tfs,0)),2)*100
                              , round(sum(nvl(ddma.contr_tfs,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.ipn_tfr,0)),2)*100
                              , round(sum(nvl(ddma.ipn_tfr,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_ipn_tfr,0)),2)*100
                              , round(sum(nvl(ddma.contr_ipn_tfr,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.ipn_cassa_credito,0)),2)*100
                              , round(sum(nvl(ddma.ipn_cassa_credito,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_cassa_credito,0)),2)*100
                              , round(sum(nvl(ddma.contr_cassa_credito,0)),0)
                          )
                  + decode( sum(nvl(ddma.contr_enpdedp,0))
                           ,0, 0
                             , decode(P_decimali
                                     ,'X', round(sum(nvl(ddma.ipn_cassa_credito,0)),2)*100
                                         , round(sum(nvl(ddma.ipn_cassa_credito,0)),0)
                                     )
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_enpdedp,0)),2)*100
                              , round(sum(nvl(ddma.contr_enpdedp,0)),0)
                          )
                  + decode(P_decimali
                          ,'X', round(sum(nvl(ddma.contr_pens_calamita,0) + nvl(contr_prev_calamita,0)),2)*100
                              , round(sum(nvl(ddma.contr_pens_calamita,0) + nvl(contr_prev_calamita,0)),0)
                          )  != 0
      ) dma
   group by dma.gest_cf
          , dma.prog_inpdap
          , dma.cassa_pensione
          , dma.cassa_previdenza
          , dma.anno_rif
 ) dma1
group by dma1.gest_cf
       , dma1.prog_inpdap
       , dma1.cassa_pensione
       , dma1.cassa_previdenza
       , dma1.cassa_enpdedp
       , dma1.anno_rif
       , dma1.cassa_credito
;

  cursor CUR_INPDAP 
  ( P_anno         number
  , P_ci           number
  , P_ini_a        date
  , P_fin_a        date
  , P_decimali     varchar2
  ) is
    select gest.codice_fiscale                   gest_cf
         , dedp.data_cessazione                  data_cess
         , dedp.causa_cessazione                 causa_cess
         , dedp.assicurazioni                    ass
         , dedp.maggiorazioni                    mag
         , nvl(dedp.tipo_impiego,'0')            tipo_impiego
         , nvl(dedp.tipo_servizio,'0')           tipo_servizio
         , nvl(dedp.perc_l300,0)                 perc_l300
         , dedp.dal                              dal
         , dedp.al                               al
         , decode
           ( dedp.rilevanza
            ,'S','1'
                ,decode(dedp.competenza
                       ,dedp.riferimento,'1','2')) cassa_comp
         , nvl(dedp.gg_utili,0)                    gg_utili
         , decode(P_decimali,'X',round(nvl(dedp.comp_fisse,0),2) *100
		                        ,round(nvl(dedp.comp_fisse,0),0)
		         ) comp_fisse
         , decode(P_decimali,'X',round(nvl(dedp.comp_accessorie,0),2) *100
		                        ,round(nvl(dedp.comp_accessorie,0),0)  
				 )         comp_accessorie
         , decode(P_decimali,'X',round(nvl(dedp.comp_inadel,0),2)*100
		   						,round(nvl(dedp.comp_inadel,0),0) 
				 )         comp_inadel
         , decode(P_decimali,'X',round(nvl(dedp.comp_tfr,0),2) *100
		                        ,round(nvl(dedp.comp_tfr,0),0)  
				 )         comp_tfr
         , decode(P_decimali,'X',round(nvl(dedp.premio_prod,0),2) *100 
		   						,round(nvl(dedp.premio_prod,0),0)
				 )	       premio_prod
         , dedp.rilevanza                        rilevanza
         , dedp.riferimento                      riferimento
         , decode(dedp.rilevanza,'S',1,2)        ord
  	   , l_388                                 legge_388
  	   , data_decorrenza                       data_dec
 	   , nvl(gg_tfr,0)                         gg_tfr
  	   , decode(P_decimali,'X',round(nvl(ind_non_a,0),2)*100
	                          ,round(nvl(ind_non_a,0),0)  
				)             ind_non_a
 	   , decode(P_decimali,'X',round(nvl(l_165,0),2)*100 
	                          ,round(nvl(l_165,0),0) 
				)                  l_165
 	   , decode(P_decimali,'X',round(nvl(comp_18,0),2)*100
	   	 					  ,round(nvl(comp_18,0),0) 
				)                comp_18
 	   , decode(P_decimali,'X',round(nvl(dedp.tredicesima,0),2)*100
	   	 					  ,round(nvl(dedp.tredicesima,0),0) 
				)                tredicesima
         , nvl(gg_mag_1,0)               gg_mag_1
         , nvl(gg_mag_2,0)               gg_mag_2
         , nvl(gg_mag_3,0)               gg_mag_3
         , nvl(gg_mag_4,0)               gg_mag_4
         , data_opz_tfr                   
         , cf_amm_fisse                  
         , cf_amm_acc
         , dedp.comparto
         , dedp.sottocomparto
         , qualifica
         , decode(P_decimali,'X',round(nvl(dedp.iis_conglobata,0),2) *100
		                        ,round(nvl(dedp.iis_conglobata,0),0)
		         ) iis_conglobata
         , decode(P_decimali,'X',round(nvl(dedp.ipn_tfr,0),2) *100
		                        ,round(nvl(dedp.ipn_tfr,0),0)
		         ) ipn_tfr
         , decode(P_decimali,'X',round(nvl(dedp.rit_inpdap,0),2) *100
		                        ,round(nvl(dedp.rit_inpdap,0),0)
		         ) rit_inpdap
         , decode(P_decimali,'X',round(nvl(dedp.rit_tfs,0),2) *100
		                        ,round(nvl(dedp.rit_tfs,0),0)
		         ) rit_tfs
         , decode(P_decimali,'X',round(nvl(dedp.contr_tfr,0),2) *100
		                        ,round(nvl(dedp.contr_tfr,0),0)
		         ) contr_tfr
      from denuncia_inpdap  dedp
         , gestioni         gest
     where dedp.anno     = P_anno
       and dedp.previdenza = 'POSTE'
       and dedp.dal     <= P_fin_a
       and dedp.ci in
                   (select P_ci
                      from dual
                     union
                    select ci_erede
                      from RAPPORTI_DIVERSI radi
                     where radi.ci = P_ci
                       and radi.rilevanza in ('L','R')
                       and radi.anno = P_anno
                   )
       and dedp.gestione  = gest.codice
     union
    select DECODE('SI','SI','Z',null)                           gest_cf
         , to_date(null)                 data_cess
         , null                          causa_cess
         , null                          ass
         , null                          mag
         , null                          tipo_impiego
         , null                          tipo_servizio
         , to_number(null)               perc_l300
         , to_date(null)                 dal
         , to_date(null)                 al
         , null                          cassa_comp
         , to_number(null)               gg_utili
         , to_number(null)               comp_fisse
         , to_number(null)               comp_accessorie
         , to_number(null)               comp_inadel
         , to_number(null)               comp_tfr
         , to_number(null)               premio_prod
         , null                          rilevanza
         , to_number(null)               riferimento
         , 3                             ord
         , null                          legge_388
	   , to_date(null)                 data_dec
	   , to_number(null)               gg_tfr
  	   , to_number(null)               ind_non_a
	   , to_number(null)               l_165
	   , to_number(null)               comp_18
	   , to_number(null)               tredicesima
  	   , to_number(null)               gg_mag_1
	   , to_number(null)               gg_mag_2
	   , to_number(null)               gg_mag_3
	   , to_number(null)               gg_mag_4
         , to_date(null)                 data_opz_tfr                   
         , null                          cf_amm_fisse                  
         , null                          cf_amm_acc
         , null                          comparto
         , null                          sottocomparto
         , null                          qualifica
         , to_number(null)               iis_conglobata
         , to_number(null)               ipn_tfr
         , to_number(null)               rit_inpdap
         , to_number(null)               rit_tfs
         , to_number(null)               contr_tfr
      from dual
     where exists
          (select 'x' from denuncia_inpdap
            where anno = P_anno
              and previdenza = 'POSTE'
              and ci in
                     (select P_ci
                        from dual
                       union
                      select ci_erede
                        from RAPPORTI_DIVERSI radi
                       where radi.ci = P_ci
                         and radi.rilevanza in ('L','R')
                         and radi.anno = P_anno
                     )
          )
     order by 20,9
    ;
FUNCTION  VERSIONE                   RETURN VARCHAR2;
PROCEDURE INSERT_TAB_REPORT_FINE_ANNO (P_anno number, P_da_ci number, P_a_ci number);
PROCEDURE PULISCI_TAB_REPORT_FINE_ANNO;
END CURSORE_FISCALE_06;
/
CREATE OR REPLACE PACKAGE BODY CURSORE_FISCALE_06 IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 08/01/2007';
 END VERSIONE;
 PROCEDURE INSERT_TAB_REPORT_FINE_ANNO (P_anno  number, P_da_ci number, P_a_ci number) IS
 BEGIN
 declare
  non_esiste_indice exception;
  pragma exception_init(non_esiste_indice,-01418);
  begin 
   si4.sql_execute ('drop index trpfa_ik');
   exception
  when non_esiste_indice then null;
  end;
   si4.sql_execute ('insert into tab_report_fine_anno (ci,anno,s1,c1,d1,s2,c2,d2,s3,c3,d3,s4,c4,d4,s5,c5,d5,s6,c6,d6)
                     select ci,anno,substr(s1,1,15),substr(c1,1,15),substr(d1,1,60),substr(s2,1,15),substr(c2,1,15),substr(d2,1,60),
                            substr(s3,1,15),substr(c3,1,15),substr(d3,1,60),substr(s4,1,15),substr(c4,1,15),substr(d4,1,60),
                            substr(s5,1,100),substr(c5,1,100),substr(d5,1,100),substr(s6,1,100),substr(c6,1,100),substr(d6,1,100)
                       from report_fine_anno
                      where anno ='||P_anno||
                      ' and ci between '||P_da_ci||' and '||P_a_ci);
   si4.sql_execute ('create index trpfa_ik on tab_report_fine_anno (ci)');
 END INSERT_TAB_REPORT_FINE_ANNO; 
 PROCEDURE PULISCI_TAB_REPORT_FINE_ANNO IS
 BEGIN
   si4.sql_execute ('truncate table tab_report_fine_anno');
 END PULISCI_TAB_REPORT_FINE_ANNO;
END CURSORE_FISCALE_06;
/
