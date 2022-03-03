CREATE OR REPLACE PACKAGE CURSORE_CERTIFICATO IS
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
 0    31/10/2003 MS     Prima emissione.
 1.0  16/06/2005 ML     Eliminazione estrazione campo "IF_TESTO" visto che poi non viene mai utilizzato (A11680).
 1.1  20/09/2005 ML     Inserito di nuovi il campo if_testo, serve per comporre il testo sul perido originale
                        ad esempio nel caso in cui i periodi siano spezzati causa storicizzazione della figura (A12709).
 1.2  24/01/2006 ML     Estrazione dato ore_lavoro direttamente nel cursore (A14477).
 1.3  01/09/2006 ML     Modifica cursore per nuova gestione campo presso (A17426).
 1.4  06/03/2007 ML     Modifica per ripristino gestione storicizzazione della figura (A19437),
******************************************************************************/
CURSOR CUR_PERIODI ( Df_decorrenza    varchar2
                   , Df_note_ind      varchar2
                   , Df_servizio      VARCHAR2
                   , Df_ruolo         VARCHAR2
                   , Df_attivita      VARCHAR2
                   , Df_delibera      VARCHAR2
                   , Df_esecutivita   varchar2
                   , Df_durata        VARCHAR2
                   , Df_cessazione    VARCHAR2
                   , Df_assenze       VARCHAR2
                   , Df_economico     VARCHAR2
                   , Df_tempo_determinato VARCHAR2
                   , Df_part_time     VARCHAR2
                   , D_del            varchar2
                   , D_numero         varchar2
                   , D_esecutiva      varchar2
                   , D_ni             number
                   , D_prestato       varchar2
                   , D_presta         varchar2
                   , D_qualita        varchar2
                   , D_con            varchar2
                   , D_presso         varchar2
                   , D_contestual     varchar2
                   , D_ser_r          varchar2
                   , D_ser_nr         varchar2
                   , D_a              varchar2
                   , D_tp             varchar2
                   , D_td             varchar2
                   , D_em             varchar2
                   , D_ore            varchar2
                   , D_in_qualita     varchar2
                   , D_l_ruolo        varchar2
                   , D_l_profilo      varchar2
                   , D_l_pos_fun      varchar2
                   , D_l_figura       varchar2
                   , P_tipo_rapporto  varchar2
                   , D_qualifica      varchar2
                   , D_cessazione     VARCHAR2
                   , D_data_cessaz    VARCHAR2
                   , D_in_data        VARCHAR2
                   , D_assenza        VARCHAR2
                   , D_sottolinea     VARCHAR2
                   , D_decorre        VARCHAR2
                   , D_fino_a         VARCHAR2
                   , D_riferimento    DATE
                   , D_per_ni	      VARCHAR2
                   , D_ci             number
                   , D_tempo_det      varchar2
                   , D_tempo_indet    varchar2
                   , D_part_time      varchar2
                   , D_tempo_pieno    varchar2
                   , D_tempo_ridotto  varchar2
                   , D_settore        varchar2
                   , D_ore_cont       varchar2
                   , Df_u_presso      VARCHAR2
		   ) is
SELECT
--  TO_CHAR(GREATEST(pegi_dal,figi_dal),'j')||
--  DECODE(rilevanza,'Q',1,3)                ordina
--, TO_CHAR(GREATEST(pegi_dal,figi_dal),'j')||
--  DECODE(rilevanza,'Q',1,3)                ordina_2
decode ( GREATEST(pegi_dal,figi_dal)
       , figi_dal, to_char(pegi_dal,'j')||DECODE(rilevanza,'Q',2,5)
                 , TO_CHAR(pegi_dal,'j')||DECODE(rilevanza,'Q',1,4)
       ) ordina
, decode ( GREATEST(pegi_dal,figi_dal)
         , figi_dal, to_char(pegi_dal,'j')||DECODE(rilevanza,'Q',2,5)
                   , TO_CHAR(pegi_dal,'j')||DECODE(rilevanza,'Q',1,4)
       ) ordina_2
, ci                                       ci
, rilevanza                                rilevanza
, GREATEST(pegi_dal,figi_dal)              dal
, decode( LEAST( NVL(pegi_al,TO_DATE('3333333','j'))
               , NVL(figi_al,TO_DATE('3333333','j')))
        , to_date('3333333','j'), to_date(null)
                                , LEAST( NVL(pegi_al,TO_DATE('3333333','j'))
                                       , NVL(figi_al,TO_DATE('3333333','j')))
        )                                   al
, DECODE( GREATEST(pegi_dal,figi_dal)
        , pegi_dal, pegi_dal
                  , TO_DATE(NULL))         pegi_deco
, DECODE(evgi_presso
        ,'NO',NULL,evgi_presso)            presso
, DECODE
  ( GREATEST(pegi_dal,figi_dal)
  , pegi_dal, DECODE
             ( Df_decorrenza
              , 'DD', DECODE
                      ( rilevanza
                      , 'Q', DECODE( GREATEST(NVL(pegi_al,D_riferimento+1),D_riferimento)
                                   , D_riferimento, D_prestato
                                         , D_presta
                                   )||' '||D_qualita
                           , NULL
                      )
              , 'AS', DECODE
                      ( Df_attivita
                      , 'SI', DECODE
                              ( rilevanza
                              , 'Q', DECODE( GREATEST(NVL(pegi_al,D_riferimento+1),D_riferimento)
                                            , D_riferimento, D_prestato
                                                     , D_presta
                                           )
                                   , D_con||' '||evgi_descrizione
                              )||
                              DECODE(evgi_presso
                                    , 'NO', NULL , ' '||D_presso||
                                                   ' '||presso)
                            , NULL
                            )||', '||D_qualita
                    , DECODE( rilevanza
                            , 'I', D_contestual||' '
                                 , NULL)||
                      DECODE(evgi_certificabile
                            ,'SP',posi_descrizione
                                 ,DECODE(Df_servizio
                                        , 'NO', evgi_descrizione
                                              , DECODE
                                                ( rilevanza
                                                , 'I', DECODE
                                                      ( posi_ruolo
                                                      , 'SI', ', '||LOWER(D_ser_r)||' '||evgi_descrizione
                                                            , ', '||LOWER(D_ser_nr)||' '||evgi_descrizione)
                                                    , DECODE
                                                      ( posi_ruolo
                                                      , 'SI', D_ser_r||' '||evgi_descrizione
                                                            , D_ser_nr||' '||evgi_descrizione)
                                                )
                                              ))
               ||decode(df_tempo_determinato
                               ,'SI', decode(posi_tempo_determinato
					 		   ,'SI', ', '||lower(D_tempo_det)
                                                  , ', '||lower(D_tempo_indet)
                                            )
                                    , null)
               ||decode(df_part_time
		  	       ,'SI', decode(posi_part_time
					        ,'SI',', '||lower(D_part_time)
                                           ,decode(pegi_ore
                                                  , null, ', '||lower(D_tempo_pieno)
                                                        , ', '||lower(D_tempo_ridotto)
                                                  )
                                       )
                               , null  )
               ||' '||DECODE( pegi_ore
                            , NULL, NULL
                                  ,' '||D_a||' '||TO_CHAR(pegi_ore)||' '||D_ore||
                                   ' '||D_ore_cont||' '||to_char(cost_ore_lavoro)
                            )
          )
            , ' ')                                                             pegi_testo
       , D_in_qualita                                                          in_qualita
       , DECODE
              ( Df_decorrenza
              , 'DD', DECODE
                      ( rilevanza
                      , 'Q', DECODE( GREATEST(NVL(pegi_al,D_riferimento+1),D_riferimento)
                                   , D_riferimento, D_prestato
                                            , D_presta
                                   )||' '||D_qualita
                           , NULL
                      )
              , 'AS', DECODE
                      ( Df_attivita
                      , 'SI', DECODE
                              ( rilevanza
                              , 'Q', DECODE( GREATEST(NVL(pegi_al,D_riferimento+1),D_riferimento)
                                           , D_riferimento, D_prestato
                                                    , D_presta
                                           )
                                   , D_con||' '||evgi_descrizione
                              )||
                              DECODE(evgi_presso
                                    , 'NO', NULL , ' '||D_presso||
                                                   ' '||presso)
                            , NULL
                            )||', '||D_qualita
                    , DECODE( rilevanza
                            , 'I', D_contestual||' '
                                 , NULL)||
                      DECODE(evgi_certificabile
                            ,'SP',posi_descrizione
                                 ,DECODE(Df_servizio
                                        , 'NO', evgi_descrizione
                                              , DECODE
                                                ( rilevanza
                                                , 'I', DECODE
                                                      ( posi_ruolo
                                                      , 'SI', ', '||LOWER(D_ser_r)||' '||evgi_descrizione
                                                            , ', '||LOWER(D_ser_nr)||' '||evgi_descrizione)
                                                    , DECODE
                                                      ( posi_ruolo
                                                      , 'SI', D_ser_r||' '||evgi_descrizione
                                                            , D_ser_nr||' '||evgi_descrizione)
                                                )
                                              ))
               ||decode(df_tempo_determinato
                               ,'SI', decode(posi_tempo_determinato
					 		   ,'SI', ', '||lower(D_tempo_det)
                                                  , ', '||lower(D_tempo_indet)
                                            )
                                    , null)
               ||decode(df_part_time
		  	       ,'SI', decode(posi_part_time
					        ,'SI',', '||lower(D_part_time)
                                           ,decode(pegi_ore
                                                  , null, ', '||lower(D_tempo_pieno)
                                                        , ', '||lower(D_tempo_ridotto)
                                                  )
                                       )
                               , null  )
               ||' '||DECODE( pegi_ore
                            , NULL, NULL
                                  ,' '||D_a||' '||TO_CHAR(pegi_ore)||' '||D_ore||' '||D_ore_cont||
                                   ' '||to_char(cost_ore_lavoro)
                            )
               )                                     if_testo
             , decode( DF_U_presso
                     , 'SI', presso
                           , decode(evgi_presso
                                   , 'NO', ' ' ,presso)
                     )         t_presso
             , decode(evgi_cert_sett
                            ,'SI',' '||decode(evgi_presso
                                              ,'SI',', settore '
                                                     , D_settore)
                                     ||' '||upper(sett_descrizione)||' '
                                 , NULL
                             )                       t_settore
, DECODE(Df_decorrenza
        ,'DD',NULL,DECODE(Df_ruolo
                         ,'SI',DECODE
                              ( ruol_descrizione
                              , NULL, NULL
                                    , D_l_ruolo||' '||
                                      ruol_descrizione)
                              , NULL))                    pegi_ruolo
, DECODE(Df_decorrenza
        ,'DD',NULL,DECODE(Df_ruolo
                         ,'NO',NULL
                         ,'PF',NULL
                              ,DECODE(prpr_descrizione
                                     ,NULL,NULL
                                          ,D_l_profilo||' '||
                                           prpr_descrizione)))  pegi_profilo
, DECODE(Df_decorrenza
        ,'DD',NULL,DECODE(Df_ruolo
                         ,'NO',NULL
                         ,'PR',NULL
                              , DECODE(pofu_descrizione
                                      ,NULL,NULL
                                           ,D_l_pos_fun||' '||
                                            pofu_descrizione)))  pegi_pos_fun
, decode(df_ruolo
        , 'NO',ltrim(D_l_figura)
              ,decode(df_decorrenza
                     ,'DD',ltrim(D_l_figura)
                          ,D_l_figura))||' '||UPPER(figi_descrizione)||
  DECODE( Df_decorrenza
        , 'AS', DECODE( evgi_certificabile
                      , 'SP', ' '||posi_descrizione||' '
                            , NULL)
              , NULL)||
  DECODE(Df_attivita
        ,'SI',DECODE(figi_cert_att,'SI',' '||UPPER(atti_descrizione),NULL)
             ,NULL)||
  DECODE
   ( Df_attivita
   ,'SI',DECODE( figi_cert_set
                ,'A',' '||D_presso||' '||UPPER(sett1_descrizione)
                ,'B',' '||D_presso||' '||UPPER(sett2_descrizione)
                ,'C',' '||D_presso||' '||UPPER(sett3_descrizione)
                ,'S',' '||D_presso||' '||UPPER(sett_descrizione)
                    ,NULL)
        ,NULL)                                            pegi_figura
, DECODE(Df_decorrenza,'DD',NULL
        , DECODE(GREATEST(pegi_dal,figi_dal)
                ,pegi_dal,NULL,figi_note))                figi_note
, DECODE(P_tipo_rapporto,'SI',tira_descrizione,null) tira_descrizione
, DECODE(P_tipo_rapporto,'SI',tira_note,null) tira_note
, DECODE(Df_decorrenza
        ,'DD',NULL
             ,DECODE
              (GREATEST(pegi_dal,figi_dal)
              ,pegi_dal,DECODE(Df_delibera
                              ,'SI',DECODE(sede_del,NULL,NULL,sede_del)||
                                    DECODE(numero_del,NULL,NULL,' '||D_numero||' '||numero_del)||
                                    DECODE(deli_data
                                          ,NULL,DECODE(anno_del,NULL,NULL,' '||D_del||' '||anno_del)
                                               ,' '||D_del||' '||TO_CHAR(deli_data,'dd/mm/yy')
                              )||DECODE(deli_note,NULL,NULL,' '||deli_note)
                            , NULL)
                    , NULL)
  )                                                       pegi_delibera
, DECODE(Df_decorrenza
        ,'DD',NULL
             ,DECODE(GREATEST(pegi_dal,figi_dal)
                    ,pegi_dal,DECODE(Df_esecutivita
                                    ,'SI',DECODE(numero_ese||data_ese
                                                ,NULL,DECODE(tipo_ese
                                                            ,NULL,NULL
                                                                 ,D_esecutiva||' '||
                                                                  SUBSTR(tipo_ese,1,23))
                                         ,DECODE(numero_ese,NULL,NULL
                                                ,D_esecutiva||' '||D_numero||' '||
                                                  numero_ese)||
                                          DECODE(data_ese
                                                ,NULL,NULL,' '||D_del||' '||
                                                           TO_CHAR(data_ese,'dd/mm/yy')))
                           ,NULL)
                    ,NULL)
  )                                                       pegi_esecutiva
, DECODE
  ( GREATEST(pegi_dal,figi_dal)
  , pegi_dal, DECODE(Df_decorrenza,'DD',NULL
                      , DECODE(Df_note_ind
                              ,'NO',NULL,pegi_note))
            , null)                                    pegi_note
, DECODE(Df_decorrenza,'DD',TO_NUMBER(NULL),pegi_gg)   pegi_gg
  FROM pegi_qi
 WHERE ci IN (SELECT rain.ci FROM RAPPORTI_INDIVIDUALI rain
               WHERE rain.ni = D_ni
                 AND   (rain.ci=D_ci or D_per_ni='X'))
   AND rilevanza    IN (SELECT 'Q' FROM dual
                         UNION
                        SELECT 'I' FROM dual
                         WHERE Df_decorrenza != 'DD')
   AND evgi_certificabile IN ('SI','SP')
   AND (   (    Df_decorrenza NOT IN ('DD','AS')
            AND pegi_dal         <= D_riferimento)
        OR (    Df_decorrenza  IN ('DD','AS')
            AND GREATEST(pegi_dal,figi_dal) =
               (SELECT MAX(GREATEST(pegi_dal,figi_dal)) FROM pegi_qi
                 WHERE rilevanza IN (SELECT 'Q' FROM dual
                                      UNION
                                     SELECT 'I' FROM dual
                                      WHERE Df_decorrenza != 'DD')
                   AND ci IN (SELECT rain.ci FROM RAPPORTI_INDIVIDUALI rain
                               WHERE rain.ni = D_ni
							   AND   (rain.ci=D_ci or D_per_ni='X')))
            AND EXISTS
               (SELECT 'x' FROM RAPPORTI_GIURIDICI
                 WHERE ci = pegi_qi.ci
                   AND NVL(al,TO_DATE('3333333','j'))
                       BETWEEN pegi_dal
                           AND NVL(pegi_al,TO_DATE('3333333','j'))
               )
           )
       )
UNION
SELECT TO_CHAR(pegi_dal,'j')||
       DECODE(rilevanza,'S',3,6)        ordina
     , TO_CHAR(pegi_dal,'j')||
       DECODE(rilevanza,'S',3,6)        ordina_2
     , ci                               ci
     , rilevanza                        rilevanza
     , GREATEST(pegi_dal,qugi_dal)      dal
     , decode( LEAST( NVL(pegi_al,TO_DATE('3333333','j'))
                    , NVL(qugi_al,TO_DATE('3333333','j')))
              , to_date('3333333','j'), to_date(null)
                                      , LEAST( NVL(pegi_al,TO_DATE('3333333','j'))
                                             , NVL(qugi_al,TO_DATE('3333333','j')))
              )                         al
     , pegi_dal                         pegi_deco
     , DECODE(evgi_presso
             ,'NO',NULL,evgi_presso)    presso
     , DECODE( rilevanza
             , 'E', D_contestual||' '
                  , NULL)||
       DECODE( evgi_certificabile
             , 'SP' , posi_descrizione
                    , DECODE( Df_servizio
                            ,'NO',evgi_descrizione
                                 ,DECODE
                                  ( rilevanza
                                  ,'E',DECODE( posi_ruolo
                                             ,'SI',','||LOWER(D_ser_r)||' '||evgi_descrizione
                                                  ,','||LOWER(D_ser_nr)||' '||evgi_descrizione)
                                      ,DECODE( posi_ruolo
                                             ,'SI',','||D_ser_r||' '||evgi_descrizione
                                                  ,','||D_ser_nr||' '||evgi_descrizione))))
       ||decode(df_tempo_determinato,
		     'SI',decode(posi_tempo_determinato,
				    'SI',','||lower(D_tempo_det)
                                ,','||lower(D_tempo_indet))
                     , null)
		||' '||
            decode(df_part_time,
  	         'SI',decode(posi_part_time,
	 			 'SI',','||lower(D_part_time)
                             ,decode(pegi_ore
                                     ,null,','||lower(D_tempo_pieno)
                                          ,','||lower(D_tempo_ridotto)) )
                     , null   ) ||' '||DECODE( pegi_ore
                           ,NULL,NULL
                                ,' '||D_a||' '||TO_CHAR(pegi_ore)||
                                 ' '||D_ore)   pegi_testo
     ,  D_qualifica
     , DECODE( rilevanza
             , 'E', D_contestual||' '
                  , NULL)||
       DECODE( evgi_certificabile
             , 'SP' , posi_descrizione
                    , DECODE( Df_servizio
                            ,'NO',evgi_descrizione
                                 ,DECODE
                                  ( rilevanza
                                  ,'E',DECODE( posi_ruolo
                                             ,'SI',','||LOWER(D_ser_r)||' '||evgi_descrizione
                                                  ,','||LOWER(D_ser_nr)||' '||evgi_descrizione)
                                      ,DECODE( posi_ruolo
                                             ,'SI',','||D_ser_r||' '||evgi_descrizione
                                                  ,','||D_ser_nr||' '||evgi_descrizione))))
       ||decode(df_tempo_determinato,
		     'SI',decode(posi_tempo_determinato,
				    'SI',','||lower(D_tempo_det)
                                ,','||lower(D_tempo_indet))
                     , null)
		||' '||
            decode(df_part_time,
  	         'SI',decode(posi_part_time,
	 			 'SI',','||lower(D_part_time)
                             ,decode(pegi_ore
                                     ,null,','||lower(D_tempo_pieno)
                                          ,','||lower(D_tempo_ridotto)) )
                     , null   ) ||' '||DECODE( pegi_ore
                           ,NULL,NULL
                                ,' '||D_a||' '||TO_CHAR(pegi_ore)||
                                 ' '||D_ore)    if_testo
     ,              decode( DF_U_presso
                     , 'SI', presso
                           , decode(evgi_presso
                                   , 'NO', ' ' ,presso)
                           )   t_presso
    , decode(evgi_cert_sett,
              'SI',' '||decode(evgi_presso,
                               'SI',', settore '
                                   ,D_settore)||' '||upper(sett_descrizione)||' '
                  ,NULL )
     , NULL         pegi_ruolo
     , NULL         pegi_profilo
     , NULL         pegi_pos_fun
     , decode(df_ruolo
             , 'NO',ltrim(D_l_figura)
                   ,decode(df_decorrenza
                          ,'DD',ltrim(D_l_figura)
                               ,D_l_figura))||' '||UPPER(qugi_descrizione) pegi_figura
     , NULL                        figi_note
     , DECODE(P_tipo_rapporto,'SI',tira_descrizione,null) tira_descrizione
     , DECODE(P_tipo_rapporto,'SI',tira_note,null) tira_note
     , DECODE( Df_delibera
              ,'SI',DECODE( sede_del
                           ,NULL,NULL
                                ,sede_del)||
                    DECODE( numero_del
                           ,NULL,NULL
                                ,' '||D_numero||' '||numero_del)||
                    DECODE( deli_data
                          ,NULL,DECODE(anno_del,NULL,NULL,' '||D_del||' '||anno_del)
                                ,' '||D_del||' '||
                                 TO_CHAR(deli_data,'dd/mm/yy')
                          )||DECODE( deli_note
                                   , NULL, NULL
                                         , ' '||deli_note)
                   ,NULL)                                    pegi_delibera
     , DECODE(Df_esecutivita
             ,'SI',DECODE(numero_ese||data_ese
                         ,NULL,DECODE(tipo_ese,NULL,NULL,D_esecutiva||' '||
                                                         SUBSTR(tipo_ese,1,23))
                              ,DECODE(numero_ese,NULL,NULL,D_esecutiva||' '||
                                                           D_numero||' '||numero_ese)||
                               DECODE(data_ese,NULL,NULL,' '||D_del||' '||
                                                         TO_CHAR(data_ese,'dd/mm/yy')))
                  ,NULL)                                     pegi_esecutiva
     , DECODE(Df_decorrenza,'DD',NULL
     , DECODE(Df_note_ind
               ,'NO',NULL,pegi_note))                 pegi_note
     , pegi_gg                                         pegi_gg
  FROM pegi_se
 WHERE ci  IN (SELECT rain.ci FROM RAPPORTI_INDIVIDUALI rain
                WHERE rain.ni = D_ni
                  AND   (rain.ci=D_ci or D_per_ni='X'))
   AND 1 = 2
   AND (   (    Df_decorrenza NOT IN ('AS','DD')
            AND pegi_dal         <= D_riferimento)
        OR (    Df_decorrenza  = 'AS'
            AND EXISTS
               (SELECT 'x' FROM RAPPORTI_GIURIDICI
                 WHERE ci = pegi_se.ci
                   AND NVL(al,TO_DATE('3333333','j'))
                       BETWEEN pegi_dal
                           AND NVL(pegi_al,TO_DATE('3333333','j'))
               )
           )
       )
UNION
SELECT TO_CHAR(dogi_del,'j')||7   ordina
     , TO_CHAR(dogi_del,'j')||7   ordina_2
     , ci                         ci
     , 'D'                        rilevanza
     , DECODE( Df_decorrenza
             , 'NO', NVL(dogi_dal,dogi_del)
                   , dogi_dal)    dal
     , dogi_al                    al
     , dogi_del                   pegi_deco
     , NULL                       presso
     , evgi_descrizione||
       DECODE( sodo_descrizione
              ,NULL,NULL
                   ,' '||sodo_descrizione)  pegi_testo
     , ' '
     , evgi_descrizione||
       DECODE( sodo_descrizione
              ,NULL,NULL
                   ,' '||sodo_descrizione)  if_testo
     , ' '
     , ' '
     , NULL          pegi_ruolo
     , NULL          pegi_profilo
     , NULL          pegi_pos_fun
     , NULL          pegi_figura
     , NULL          figi_note
     , null          tira_descrizione
     , null          tira_note
     , DECODE( Df_delibera
              ,'SI',DECODE(sede_del,NULL,NULL,sede_del)||
                    DECODE(numero_del,NULL,NULL,' '||D_numero||' '||numero_del)||
                    DECODE(deli_data,NULL,DECODE(anno_del
                                                ,NULL,NULL,' '||D_del||' '||anno_del)
                                         ,' '||D_del||' '||TO_CHAR(deli_data,'dd/mm/yy')
                          )||DECODE(deli_note,NULL,NULL,' '||deli_note)
                   ,NULL)                                    pegi_delibera
     , DECODE( Df_esecutivita
             ,'SI',DECODE(numero_ese||data_ese
                         ,NULL,DECODE(tipo_ese,NULL,NULL,D_esecutiva||' '||
                                                         SUBSTR(tipo_ese,1,23))
                              ,DECODE(numero_ese,NULL,NULL,D_esecutiva||' '||
                                                           D_numero||' '||numero_ese)||
                               DECODE(data_ese,NULL,NULL,' '||D_del||' '||
                                                         TO_CHAR(data_ese,'dd/mm/yy')))
                  ,NULL)                                    pegi_esecutiva
      , DECODE(Df_decorrenza,'DD', NULL
                                 , DECODE(Df_note_ind
                                          ,'NO',NULL
                                               ,dogi_note)) pegi_note
     , dogi_gg                                              pegi_gg
  FROM pegi_d
 WHERE ci IN (SELECT rain.ci FROM RAPPORTI_INDIVIDUALI rain
               WHERE  rain.ni = D_ni
                 AND (rain.ci=D_ci or D_per_ni='X'))
   AND Df_decorrenza NOT IN ('AS','DD')
   AND nvl(D_riferimento,to_date('3333333','j'))
           between nvl(pegi_d.dogi_dal,to_date('2222222','j')) and nvl(pegi_d.dogi_al,to_date('3333333','j'))
UNION
SELECT TO_CHAR(pegi_al,'j')||8                ordina
     , TO_CHAR(pegi_al,'j')||8                ordina_2
     , ci                                     ci
     , 'P'                                    rilevanza
     , pegi_dal                               dal
     , pegi_al                                al
     , pegi_al                                pegi_deco
     , NULL                                   presso
     , D_cessazione||' '||evra_descrizione||
       DECODE( D_data_cessaz
             , 'X', ' '||D_in_data||' '||
                    TO_CHAR(pegi_al,'dd/mm/yyyy')
                  , NULL)                     pegi_testo
     , ' '
     , D_cessazione||' '||evra_descrizione||
       DECODE( D_data_cessaz
             , 'X', ' '||D_in_data||' '||
                    TO_CHAR(pegi_al,'dd/mm/yyyy')
                  , NULL)                     if_testo
     , ' '
     , ' '
     , NULL     pegi_ruolo
     , NULL     pegi_profilo
     , NULL     pegi_pos_fun
     , NULL     pegi_figura
     , NULL     figi_note
     , NULL     tira_descrizione
     , null     tira_note
     , DECODE( Df_delibera
              ,'SI',DECODE(sede_del,NULL,NULL,sede_del)||
                    DECODE(numero_del,NULL,NULL,' '||D_numero||' '||numero_del)||
                    DECODE(deli_data
                          ,NULL,DECODE(anno_del,NULL,NULL,' '||D_del||' '||anno_del)
                               ,' '||D_del||' '||TO_CHAR(deli_data,'dd/mm/yy')
                          )||DECODE(deli_note,NULL,NULL,' '||deli_note)
                   ,NULL)                                    pegi_delibera
     , DECODE(Df_esecutivita
             ,'SI',DECODE(numero_ese||data_ese
                         , NULL,DECODE(tipo_ese,NULL,NULL,D_esecutiva||' '||
                                                          SUBSTR(tipo_ese,1,23))
                               , DECODE(numero_ese,NULL,NULL,D_esecutiva||' '||
                                                             D_numero||' '||numero_ese)||
                                 DECODE(data_ese,NULL,NULL,' '||D_del||' '||
                                                           TO_CHAR(data_ese,'dd/mm/yy')))
                  ,NULL)        pegi_esecutiva
, DECODE(Df_decorrenza,'DD',NULL
        , DECODE(Df_note_ind
                ,'NO',NULL,pegi_note))                 pegi_note
     , TO_NUMBER(NULL)          pegi_gg
  FROM pegi_p
 WHERE ci IN (SELECT rain.ci FROM RAPPORTI_INDIVIDUALI rain
               WHERE  rain.ni = D_ni
                 AND (rain.ci=D_ci or D_per_ni='X'))
   AND NVL(pegi_p.pegi_al,TO_DATE('3333333','j'))<D_riferimento
   AND Df_decorrenza NOT IN ('AS','DD')
   AND Df_cessazione      = 'SI'
   AND EXISTS
      (SELECT 'x' FROM PERIODI_GIURIDICI
        WHERE ci = pegi_p.ci
          AND rilevanza != 'P'
          and pegi_p.pegi_al between dal and nvl(al,D_riferimento)
          and evento    in (select codice
                              from eventi_giuridici
                             where certificabile in (select 'SI' from dual
                                                      union
                                                     select 'SP' from dual))
      )
UNION
SELECT '99999996'
     , NULL
     , TO_NUMBER(NULL)
     , NULL
     , TO_DATE(NULL)
     , TO_DATE(NULL)
     , TO_DATE(NULL)
     , NULL
     , ' '       pegi_testo
     , ' '
     , ' '       if_testo
     , ' '
     , ' '
     , NULL pegi_ruolo
     , NULL pegi_profilo
     , NULL pegi_pos_fun
     , NULL
     , D_assenza
     , NULL  tira_descrizione
     , NULL  tira_note
     , D_sottolinea, ' ', NULL, TO_NUMBER(NULL)
  FROM dual
 WHERE Df_assenze = 'SI'
   AND EXISTS
      (SELECT 'x' FROM PERIODI_GIURIDICI         pegi
                     , RIFERIMENTO_RETRIBUZIONE  rire
        WHERE rire.rire_id = 'RIRE'
          AND pegi.ci IN (SELECT rain.ci FROM RAPPORTI_INDIVIDUALI rain
                           WHERE rain.ni = D_ni
						   AND   (rain.ci=D_ci or D_per_ni='X'))
          AND pegi.rilevanza     = 'A'
          AND pegi.evento       IN (SELECT codice FROM EVENTI_GIURIDICI
                                     WHERE rilevanza = 'A'
                                       AND certificabile IN ('SI','SP'))
          AND (   (    Df_decorrenza != 'AS'
                   AND pegi.dal          < D_riferimento)
               OR (    Df_decorrenza = 'AS'
                   AND Df_durata     = 'SI')
               OR (    Df_decorrenza = 'AS'
                   AND pegi.dal <= rire.fin_ela
                   AND NVL(pegi.al,TO_DATE('3333333','j')) >= rire.ini_ela
                  )
              )
      )
UNION
SELECT '99999997'                   ordina
     , TO_CHAR(pegi_dal,'j')||7     ordina_2
     , ci                           ci
     , 'A'                          rilevanza
     , pegi_dal                     dal
     , pegi_al                      al
     , pegi_dal                     pegi_deco
     , NULL                         presso
     , DECODE( Df_decorrenza
             , 'AS', D_decorre||' '||
                     TO_CHAR(pegi_dal,'dd/mm/yyyy')||', '||
                     DECODE( pegi_al
                           , NULL, NULL
                                 , D_fino_a||' '||
                                   TO_CHAR(pegi_al,'dd/mm/yyyy')||', '
                            )||aste_descrizione
                   , aste_descrizione)             pegi_testo
     , ' '
     , DECODE( Df_decorrenza
             , 'AS', D_decorre||' '||
                     TO_CHAR(pegi_dal,'dd/mm/yyyy')||', '||
                     DECODE( pegi_al
                           , NULL, NULL
                                 , D_fino_a||' '||
                                   TO_CHAR(pegi_al,'dd/mm/yyyy')||', '
                            )||aste_descrizione
                   , aste_descrizione)             if_testo
     , ' '
     , ' '
     , NULL      pegi_ruolo
     , NULL      pegi_profilo
     , NULL      pegi_pos_fun
     , NULL      pegi_figura
     , NULL      figi_note
     , NULL      tira_descrizione
     , NULL      tira_note
     , DECODE
       (Df_delibera
       ,'SI',DECODE(sede_del,NULL,NULL,sede_del)||
             DECODE(numero_del,NULL,NULL,' '||D_numero||' '||numero_del)||
             DECODE(deli_data,NULL,DECODE(anno_del,NULL,NULL,' '||D_del||' '||anno_del)
                                  ,' '||D_del||' '||TO_CHAR(deli_data,'dd/mm/yy')
                   )||DECODE(deli_note,NULL,NULL,' '||deli_note)
            ,NULL)  pegi_delibera
     , DECODE
       (Df_esecutivita
       ,'SI',DECODE(numero_ese||data_ese
                   ,NULL,DECODE(tipo_ese,NULL,NULL,D_esecutiva||' '||
                                                   SUBSTR(tipo_ese,1,23))
                        ,DECODE(numero_ese,NULL,NULL,D_esecutiva||' '||
                                                     D_numero||' '||numero_ese)||
                         DECODE(data_ese,NULL,NULL,' '||D_del||' '||
                                                   TO_CHAR(data_ese,'dd/mm/yy')))
            ,NULL)                                          pegi_esecutiva
      , DECODE(Df_decorrenza,'DD', NULL
                                 , DECODE(Df_note_ind
                                         ,'NO', NULL
                                              , pegi_note)) pegi_note
      , pegi_gg                                             pegi_gg
  FROM pegi_a
     , RIFERIMENTO_RETRIBUZIONE rire
 WHERE rire.rire_id       = 'RIRE'
   AND Df_assenze      = 'SI'
   AND Df_decorrenza  != 'DD'
   AND ci           IN (SELECT rain.ci FROM RAPPORTI_INDIVIDUALI rain
                         WHERE rain.ni = D_ni
						 AND   (rain.ci=D_ci or D_per_ni='X'))
   AND (    (             pegi_dal < D_riferimento
             AND (        Df_decorrenza != 'AS'
                  OR (    Df_decorrenza ='AS'
                      AND Df_durata = 'SI')
                 )
            )
        OR (    Df_decorrenza  = 'AS'
            AND Df_durata      = 'NO'
            AND pegi_dal <= rire.fin_ela
            AND NVL(pegi_al,TO_DATE('3333333','j')) >= rire.ini_ela
           )
       )
 ORDER BY 1,2;
END;
/
CREATE OR REPLACE PACKAGE BODY CURSORE_CERTIFICATO IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.4 del 20/02/2007';
 END VERSIONE;
END CURSORE_CERTIFICATO;
/
