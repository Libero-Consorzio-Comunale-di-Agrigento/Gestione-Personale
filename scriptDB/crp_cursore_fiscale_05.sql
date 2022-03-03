CREATE OR REPLACE PACKAGE CURSORE_FISCALE_05 IS
/******************************************************************************
 NOME:          CURSORE_FISCALE per elaborazione CUD2005 - redditi 2004

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  12/12/2005 MS     Prima emissione.
******************************************************************************/
cursor CUR_RPFA_05 (P_anno         number  
 , P_filtro_1     varchar2 , P_filtro_2     varchar2
 , P_filtro_3     varchar2 , P_filtro_4     varchar2
 , P_da_ci        number , P_a_ci         number
 , P_cod_fis      varchar2 , P_estrazione_i varchar2
 , P_voce_menu    varchar2 , P_ente         varchar2
 , P_ambiente     varchar2 , P_utente       varchar2  
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
     and sepr.posizione <=  decode(P_voce_menu,'770', 4,3)
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
     and sepr.posizione <=  decode(P_voce_menu,'770', 4,3)
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
  cursor CUR_INPS_05
  ( P_anno           number
  , P_ci             number
		      ,P_tipo_contratto varchar2
		      ,P_voce_menu      varchar2
		      ,P_decimali		  varchar2
			) is
  select lpad(decode(d1is.istituto
              ,'INPS',nvl(gest.posizione_inps,'0')
                     ,nvl(substr(esre.descrizione,1,10),'0')),10,'0') matr_az
       , decode(d1is.istituto
         ,'INPS',nvl(d1is.provincia
                ,gest.provincia_inps),' ') prov_lav
       , decode(p_voce_menu,'770',
           decode( d1is.assicurazioni
           , '1', '1', '5', '1', '6', '1'
           , '7', '1', '9', '1', ' ')
           ,decode( d1is.assicurazioni
           , '1', 'X', '5', 'X', '6', 'X'
           , '7', 'X', '9', 'X',' ')) ass_ivs
       , decode(p_voce_menu,'770',
           decode( d1is.assicurazioni
           , '2', '1', '5', '1', '7', '1'
           , '8', '1', '9', '1', ' ')                        
           ,decode( d1is.assicurazioni
           , '2', 'X', '5', 'X', '7', 'X'
           , '8', 'X', '9', 'X', ' ')) ass_ds
       , decode(p_voce_menu,'770',
           decode( d1is.assicurazioni
           , '4', '1', ' ')                        
           ,decode( d1is.assicurazioni
           , '4', 'X', ' '))  ass_altre
       , decode(p_voce_menu,'770',
           decode( d1is.assicurazioni
           , '3', '1', '7', '1', '6', '1'
           , '8', '1', ' ')                        
           ,decode( d1is.assicurazioni
           , '3', 'X', '7', 'X', '6', 'X'
           , '8', 'X', ' '))ass_fg
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_cc,0)),2)*100
                 ,round(sum(nvl(d1is.importo_cc,0)),0))) competenze_corr
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_ac,0)),2)*100
  		    ,round(sum(nvl(d1is.importo_ac,0)),0))) altre_competenze
       , to_char(sum(nvl(d1is.settimane,0))) settimane
       , to_char(sum(nvl(d1is.giorni,0))) giorni
       , decode( max(distinct nvl(substr(d1is.mesi,1,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,2,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,3,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,4,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,5,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,6,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,7,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,8,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,9,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,10,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,11,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,12,1),' '))
               , lpad('X',12,'X'),'1','0') tutti
       , decode( max(distinct nvl(substr(d1is.mesi,1,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,2,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,3,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,4,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,5,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,6,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,7,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,8,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,9,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,10,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,11,1),' '))||
                 max(distinct nvl(substr(d1is.mesi,12,1),' '))
               , lpad('X',12,'X'), ' '
               , decode( max(distinct nvl(substr(d1is.mesi,1,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,2,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,3,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,4,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,5,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,6,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,7,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,8,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,9,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,10,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,11,1),' ')), 'X', '1', '0')||
                 decode( max(distinct nvl(substr(d1is.mesi,12,1),' ')), 'X', '1', '0')) mesi
       , nvl(max(distinct d1is.contratto),' ') contratto
       , decode( P_tipo_contratto, 'X', ' ', P_tipo_contratto) tipo_con
       , max(distinct d1is.livello) livello
       , max(distinct decode( to_char(d1is.data_cessazione,'yyyy')
            , P_anno, d1is.data_cessazione, to_date(null))) data_cess
       , max(distinct decode( d1is.trasf_rapporto, 'SI', '1', '0')) trasf_rapp
       , to_char(sum(nvl(d1is.sett_utili,'0')))  sett_utili
       , '0' matr_az_prec
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_ap,0)),2)*100
 		    ,round(sum(nvl(d1is.importo_ap,0)),0))) importo_ap
       , max(distinct nvl(d1is.tabella_af,' ')) tabella_af
       , max(distinct nvl(to_char(d1is.nucleo_af),' ')) nucleo_af
       , max(distinct nvl(d1is.classe_af,' ')) classe_af
       , '0' altre_rp
       , max(distinct nvl(d1is.tipo_c1,' ')) tipo_c1
       , min(to_char(d1is.dal_c1,'ddmmyyyy')) dal_c1
       , max(distinct to_char(d1is.al_c1,'ddmmyyyy')) al_c1
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_c1,0)),2)*100
 		    ,round(sum(nvl(d1is.importo_c1,0)),0))) imp_c1
       , to_char(sum(nvl(d1is.sett_c1,0))) sett_c1
       , to_char(sum(nvl(d1is.gg_r_c1,0))) gg_r_c1
       , to_char(sum(nvl(d1is.gg_u_c1,0))) gg_u_c1
       , to_char(sum(nvl(d1is.gg_nr_c1,0))) gg_nr_c1
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_pen_c1,0)),2)*100
  	 	    ,round(sum(nvl(d1is.importo_pen_c1,0)),0))) imp_pen_c1
       , max(distinct nvl(d1is.tipo_c2,' ')) tipo_c2
       , min(to_char(d1is.dal_c2,'ddmmyyyy')) dal_c2
       , max(distinct to_char(d1is.al_c2,'ddmmyyyy')) al_c2
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_c2,0)),2)*100
    		    ,round(sum(nvl(d1is.importo_c2,0)),0))) imp_c2
       , to_char(sum(nvl(d1is.sett_c2,0))) sett_c2
       , to_char(sum(nvl(d1is.gg_r_c2,0))) gg_r_c2
       , to_char(sum(nvl(d1is.gg_u_c2,0))) gg_u_c2
       , to_char(sum(nvl(d1is.gg_nr_c2,0))) gg_nr_c2
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_pen_c2,0)),2)*100
  	 	    ,round(sum(nvl(d1is.importo_pen_c2,0)),0))) imp_pen_c2
       , max(distinct nvl(d1is.tipo_c3,' ')) tipo_c3
       , min(to_char(d1is.dal_c3,'ddmmyyyy')) dal_c3
       , max(distinct to_char(d1is.al_c3,'ddmmyyyy')) al_c3
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_c3,0)),2)*100
   		    ,round(sum(nvl(d1is.importo_c3,0)),0))) imp_c3
       , to_char(sum(nvl(d1is.sett_c3,0))) sett_c3
       , to_char(sum(nvl(d1is.gg_r_c3,0))) gg_r_c3
       , to_char(sum(nvl(d1is.gg_u_c3,0))) gg_u_c3
       , to_char(sum(nvl(d1is.gg_nr_c3,0))) gg_nr_c3
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_pen_c3,0)),2)*100
  		    ,round(sum(nvl(d1is.importo_pen_c3,0)),0))) imp_pen_c3
       , max(distinct nvl(d1is.tipo_c4,' ')) tipo_c4
       , min(to_char(d1is.dal_c4,'ddmmyyyy')) dal_c4
       , max(distinct to_char(d1is.al_c4,'ddmmyyyy')) al_c4
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_c4,0)),2)*100
  		    ,round(sum(nvl(d1is.importo_c4,0)),0))) imp_c4
       , to_char(sum(nvl(d1is.sett_c4,0))) sett_c4
       , to_char(sum(nvl(d1is.gg_r_c4,0))) gg_r_c4
       , to_char(sum(nvl(d1is.gg_u_c4,0))) gg_u_c4
       , to_char(sum(nvl(d1is.gg_nr_c4,0))) gg_nr_c4
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_pen_c4,0)),2)*100
	          ,round(sum(nvl(d1is.importo_pen_c4,0)),0))) imp_pen_c4
       , to_char(sum(nvl(d1is.sett_d,0))) sett_d
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_rid_d,0)),2)*100
	   	    ,round(sum(nvl(d1is.importo_rid_d,0)),0)))  imp_rid_d
       , to_char(decode(P_decimali,'X',round(sum(nvl(d1is.importo_cig_d,0)),2)*100
 		   ,round(sum(nvl(d1is.importo_cig_d,0)),0)))  imp_cig_d
       , min(d1is.dal) d1is_dal
       , min(d1is.gestione) gest
       , d1is.istituto istituto
       , min(d1is.qualifica)                      qual
       , min(d1is.assicurazioni)                  ass
       , min(d1is.tempo_pieno)                    tp
       , min(d1is.tempo_determinato)              td
       , min(d1is.tipo_rapporto)                  tipo_rapp
	 , max(distinct decode( d1is.qualifica
             , 'O', '1', 'Y', '2', 'D', '3'
             , 'C', '9', '9', null, d1is.qualifica)) qua_inps
       , max(distinct decode( d1is.tempo_pieno
             , 'SI', 'F', 'P' )) part_time
       , max(distinct decode(d1is.qualifica
             ,'9',null
                 ,decode( d1is.tempo_determinato
                  , 'SI', 'D', 'I')))tempo_det
	from denuncia_o1_inps d1is
         , estrazione_report  esre
         , gestioni           gest
         , dual
     where d1is.anno     = P_anno
       and d1is.ci in
           (select P_ci
              from dual
             union
            select ci_erede
              from RAPPORTI_DIVERSI radi
             where radi.ci = P_ci
               and radi.rilevanza in ('L','R')
               and radi.anno = P_anno
            )                        
       and d1is.gestione  = gest.codice
       and esre.estrazione (+) = substr(dual.dummy||'DENUNCIA_O1_INPS',2)
     group by d1is.istituto
       ,lpad(decode(d1is.istituto
            ,'INPS',nvl(gest.posizione_inps,'0')
                   ,nvl(substr(esre.descrizione,1,10),'0')),10,'0') 
       , decode(d1is.istituto
            ,'INPS',nvl(d1is.provincia
                   ,gest.provincia_inps),' ')                   
       , d1is.assicurazioni, d1is.qualifica
       , d1is.tempo_pieno, d1is.tempo_determinato
       , d1is.tipo_rapporto
     order by min(d1is.dal),max(distinct d1is.al)
    ;

cursor CUR_INPDAP_05
(P_anno    number ,P_ci    number ,P_ini_a date  ,P_fin_a date  ,P_decimali     varchar2) is
    select decode( nvl(stampa_cf_inpdap,'NO'),'SI',gest.codice_fiscale,null)
                                                 gest_cf
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
END;
/
CREATE OR REPLACE PACKAGE BODY cursore_fiscale_05 IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 12/12/2005';
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
END cursore_fiscale_05;
/



