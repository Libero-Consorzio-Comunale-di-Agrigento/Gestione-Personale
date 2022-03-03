CREATE OR REPLACE FORCE VIEW PERIODI_SERVIZIO_PRESENZA
(CI, DAL, AL, SEGMENTO, DAL_RAPPORTO, 
 UFFICIO, GG_SET, MIN_GG, RILEVANZA, DAL_PERIODO, 
 FIGURA, DAL_FIGURA, CONTRATTO, DAL_CONTRATTO, QUALIFICA, 
 DAL_QUALIFICA, ORE, SEDE, SEDE_CDC, SETTORE, 
 PROFILO_PROFESSIONALE, POSIZIONE, ASSISTENZA, CDC)
AS 
select  rapa.ci  ci 
 ,peg1.al+1   dal 
 ,peg2.dal-1  al 
 ,'RM'  segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,rapa.gg_set gg_set 
 ,nvl(rapa.min_gg,1)   min_gg 
 ,null  rilevanza 
 ,to_date(null)  dal_periodo 
 ,to_number(null)   figura 
 ,to_date(null)  dal_figura 
 ,null  contratto 
 ,to_date(null)  dal_contratto 
 ,to_number(null)   qualifica 
 ,to_date(null)  dal_qualifica 
 ,to_number(null)   ore 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede_cdc 
 ,to_number(null)   settore 
 ,null  profilo_professionale 
 ,null  posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,to_char(null),to_char(null))) 
     assistenza 
 ,rapa.cdc    cdc 
  from  periodi_giuridici peg1 
 ,periodi_giuridici peg2 
 ,rapporti_presenza rapa 
 where  peg1.dal   <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg1.al,to_date('3333333','j')) 
    >= rapa.dal 
   and  peg1.ci  = rapa.ci 
   and  peg1.rilevanza = 'S' 
   and  peg2.dal   <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg2.al,to_date('3333333','j')) 
    >= rapa.dal 
   and  peg2.ci  = rapa.ci 
   and  peg2.rilevanza = 'S' 
   and  peg2.dal    = (select min(peg3.dal) 
    from periodi_giuridici peg3 
   where peg3.rilevanza = 'S' 
     and peg3.dal > peg1.dal 
     and peg3.ci  = rapa.ci 
    ) 
   and  peg2.dal    > peg1.al+1 
 union 
select  rapa.ci  ci 
 ,rapa.dal    dal 
 ,peg1.dal-1  al 
 ,'RI'  segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,rapa.gg_set gg_set 
 ,nvl(rapa.min_gg,1)   min_gg 
 ,null  rilevanza 
 ,to_date(null)  dal_periodo 
 ,to_number(null)   figura 
 ,to_date(null)  dal_figura 
 ,null  contratto 
 ,to_date(null)  dal_contratto 
 ,to_number(null)   qualifica 
 ,to_date(null)  dal_qualifica 
 ,to_number(null)   ore 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede_cdc 
 ,to_number(null)   settore 
 ,null  profilo_professionale 
 ,null  posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,to_char(null),to_char(null))) 
     assistenza 
 ,nvl(rapa.cdc,rifu.cdc) 
     cdc 
  from  periodi_giuridici peg1 
 ,ripartizioni_funzionali rifu 
 ,rapporti_presenza rapa 
 where  peg1.dal   <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg1.al,to_date('3333333','j')) 
    >= rapa.dal 
   and  peg1.rilevanza = 'S' 
   and  peg1.ci  = rapa.ci 
   and  peg1.dal    > rapa.dal 
   and  not exists 
 (select 'x' 
 from periodi_giuridici peg2 
   where peg2.dal  <= nvl(rapa.al,to_date('3333333','j')) 
  and nvl(peg2.al,to_date('3333333','j')) 
    >= rapa.dal 
  and peg2.rilevanza   = 'S' 
  and peg2.ci = rapa.ci 
  and peg2.dal   < peg1.dal 
 ) 
   and  rifu.settore  (+) = peg1.settore 
   and  rifu.sede  (+) = nvl(peg1.sede,0) 
 union 
select  rapa.ci  ci 
 ,peg1.al+1   dal 
 ,rapa.al  al 
 ,'RF'  segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,rapa.gg_set gg_set 
 ,nvl(rapa.min_gg,1)   min_gg 
 ,null  rilevanza 
 ,to_date(null)  dal_periodo 
 ,to_number(null)   figura 
 ,to_date(null)  dal_figura 
 ,null  contratto 
 ,to_date(null)  dal_contratto 
 ,to_number(null)   qualifica 
 ,to_date(null)  dal_qualifica 
 ,to_number(null)   ore 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede_cdc 
 ,to_number(null)   settore 
 ,null  profilo_professionale 
 ,null  posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,to_char(null),to_char(null))) 
     assistenza 
 ,nvl(rapa.cdc,rifu.cdc) 
     cdc 
  from  periodi_giuridici peg1 
 ,ripartizioni_funzionali rifu 
 ,rapporti_presenza rapa 
 where  peg1.dal   <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg1.al,to_date('3333333','j')) 
    >= rapa.dal 
   and  peg1.rilevanza = 'S' 
   and  peg1.ci  = rapa.ci 
   and  nvl(peg1.al,to_date('3333333','j')) 
     < nvl(rapa.al,to_date('3333333','j')) 
   and  not exists 
 (select 'x' 
 from periodi_giuridici peg2 
   where peg2.dal  <= nvl(rapa.al,to_date('3333333','j')) 
  and nvl(peg2.al,to_date('3333333','j')) 
    >= rapa.dal 
  and peg2.rilevanza   = 'S' 
  and peg2.ci = rapa.ci 
  and peg2.dal   > peg1.dal 
 ) 
   and  rifu.settore  (+) = peg1.settore 
   and  rifu.sede  (+) = nvl(peg1.sede,0) 
union 
select  rapa.ci  ci 
 ,greatest(cost.dal 
 ,qugi.dal 
 ,figi.dal 
 ,rapa.dal 
 ,peg1.dal 
 ,peg2.al+1 
 )   dal 
 ,least(nvl(cost.al,to_date('3333333','j')) 
 ,nvl(qugi.al,to_date('3333333','j')) 
 ,nvl(figi.al,to_date('3333333','j')) 
 ,nvl(peg1.al,to_date('3333333','j')) 
 ,peg3.dal-1 
 )   al 
 ,'SM'  segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,nvl(rapa.gg_set,trunc(cost.ore_lavoro/decode(cost.ore_gg,0,1))) 
     gg_set 
 ,nvl(rapa.min_gg,trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1))*60 
  +round((cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1) 
  -trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1)))*60 
  ) 
  )  min_gg 
 ,peg1.rilevanza rilevanza 
 ,peg1.dal    dal_periodo 
 ,peg1.figura figura 
 ,figi.dal    dal_figura 
 ,qugi.contratto contratto 
 ,qugi.dal    dal_contratto 
 ,peg1.qualifica qualifica 
 ,qugi.dal    dal_qualifica 
 ,nvl(peg1.ore,cost.ore_lavoro) 
     ore 
 ,decode(nvl(rapa.sede,peg1.sede),0,null 
  ,nvl(rapa.sede,peg1.sede)) 
     sede 
 ,decode(peg1.sede,0,null,peg1.sede) 
     sede_cdc 
 ,peg1.settore   settore 
 ,figi.profilo   profilo_professionale 
 ,peg1.posizione posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,figi.profilo,peg1.posizione)) 
     assistenza 
 ,nvl(rapa.cdc,rifu.cdc) 
     cdc 
  from  contratti_storici cost 
 ,qualifiche_giuridiche   qugi 
 ,figure_giuridiche figi 
 ,periodi_giuridici peg3 
 ,periodi_giuridici peg2 
 ,periodi_giuridici peg1 
 ,ripartizioni_funzionali rifu 
 ,rapporti_presenza rapa 
 where  peg3.dal   <= nvl(peg1.al,to_date('3333333','j')) 
   and  nvl(peg3.al,to_date('3333333','j')) 
    >= peg1.dal 
   and  peg3.rilevanza = 'E' 
   and  peg3.ci  = rapa.ci 
   and  peg3.dal between greatest(peg1.dal,rapa.dal) 
   and least(nvl(rapa.al,to_date('3333333','j')) 
   ,nvl(peg1.al,to_date('3333333','j')) 
   ) 
   and  peg3.dal    = (select min(peg4.dal) 
    from periodi_giuridici peg4 
   where peg4.rilevanza = 'E' 
     and peg4.ci  = rapa.ci 
     and peg4.dal > peg2.dal 
    ) 
   and  peg2.dal   <= nvl(peg1.al,to_date('3333333','j')) 
   and  nvl(peg2.al,to_date('3333333','j')) 
    >= peg1.dal 
   and  peg2.rilevanza = 'E' 
   and  peg2.ci  = rapa.ci 
   and  nvl(peg2.al,to_date('3333333','j')) 
  between greatest(peg1.dal,rapa.dal) 
   and least(nvl(rapa.al,to_date('3333333','j')) 
   ,nvl(peg1.al,to_date('3333333','j')) 
   ) 
   and  peg3.dal    > peg2.al+1 
   and  peg1.dal   <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg1.al,to_date('3333333','j')) 
    >= rapa.dal 
   and  peg1.rilevanza = 'S' 
   and  peg1.ci  = rapa.ci 
   and  qugi.dal   <= least(nvl(rapa.al,to_date('3333333','j')) 
   ,peg3.dal-1 
   ) 
   and  nvl(qugi.al,to_date('3333333','j')) 
    >= greatest(rapa.dal,peg2.al +1) 
   and  qugi.numero = peg1.qualifica 
   and  figi.dal   <= least(nvl(rapa.al,to_date('3333333','j')) 
   ,peg3.dal-1 
   ) 
   and  nvl(figi.al,to_date('3333333','j')) 
    >= greatest(rapa.dal,peg2.al +1) 
   and  figi.numero = peg1.figura 
   and  cost.dal   <= least(nvl(rapa.al,to_date('3333333','j')) 
   ,peg3.dal-1 
   ) 
   and  nvl(cost.al,to_date('3333333','j')) 
    >= greatest(rapa.dal,peg2.al +1) 
   and  cost.contratto = qugi.contratto 
   and  rifu.settore  (+) = peg1.settore 
   and  rifu.sede  (+) = nvl(peg1.sede,0) 
union 
select  rapa.ci  ci 
 ,greatest(rapa.dal 
 ,peg1.dal 
 ,qugi.dal 
 ,figi.dal 
 ,cost.dal 
 )   dal 
 ,least(nvl(rapa.al,to_date('3333333','j')) 
 ,nvl(peg1.al,to_date('3333333','j')) 
 ,nvl(qugi.al,to_date('3333333','j')) 
 ,nvl(figi.al,to_date('3333333','j')) 
 ,nvl(cost.al,to_date('3333333','j')) 
 ,peg2.dal-1 
 )   al 
 ,'SI'  segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,nvl(rapa.gg_set,trunc(cost.ore_lavoro/decode(cost.ore_gg,0,1))) 
     gg_set 
 ,nvl(rapa.min_gg,trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1))*60 
  +round((cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1) 
  -trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1)))*60 
  ) 
  )  min_gg 
 ,peg1.rilevanza rilevanza 
 ,peg1.dal    dal_periodo 
 ,peg1.figura figura 
 ,figi.dal    dal_figura 
 ,qugi.contratto contratto 
 ,qugi.dal    dal_contratto 
 ,peg1.qualifica qualifica 
 ,qugi.dal    dal_qualifica 
 ,nvl(peg1.ore,cost.ore_lavoro) 
     ore 
 ,decode(nvl(rapa.sede,peg1.sede),0,null 
  ,nvl(rapa.sede,peg1.sede)) 
     sede 
 ,decode(peg1.sede,0,null,peg1.sede) 
     sede_cdc 
 ,peg1.settore   settore 
 ,figi.profilo   profilo_professionale 
 ,peg1.posizione posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,figi.profilo,peg1.posizione)) 
     assistenza 
 ,nvl(rapa.cdc,rifu.cdc) 
     cdc 
  from  qualifiche_giuridiche   qugi 
 ,figure_giuridiche figi 
 ,contratti_storici cost 
 ,periodi_giuridici peg2 
 ,periodi_giuridici peg1 
 ,ripartizioni_funzionali rifu 
 ,rapporti_presenza rapa 
 where  peg1.dal  <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg1.al,to_date('3333333','j')) 
   >= rapa.dal 
   and  peg1.rilevanza   = 'S' 
   and  peg1.ci    = rapa.ci 
   and  peg2.dal  <= nvl(peg1.al,to_date('3333333','j')) 
   and  nvl(peg2.al,to_date('3333333','j')) 
   >= peg1.dal 
   and  peg2.rilevanza   = 'E' 
   and  peg2.ci    = rapa.ci 
   and  peg2.dal   > peg1.dal 
   and  not exists 
 (select 'x' 
 from periodi_giuridici peg3 
   where peg3.dal <= nvl(peg1.al,to_date('3333333','j')) 
  and nvl(peg3.al,to_date('3333333','j')) 
   >= peg1.dal 
  and peg3.dal  < peg2.dal 
  and peg3.rilevanza  = 'E' 
  and peg3.ci   = rapa.ci 
 ) 
   and  qugi.dal  <= least(nvl(rapa.al,to_date('3333333','j')) 
     ,nvl(peg1.al,to_date('3333333','j')) 
     ,peg2.dal-1 
     ) 
   and  nvl(qugi.al,to_date('3333333','j')) 
   >= greatest(rapa.dal,peg1.dal) 
   and  qugi.numero   = peg1.qualifica 
   and  figi.dal  <= least(nvl(rapa.al,to_date('3333333','j')) 
     ,nvl(peg1.al,to_date('3333333','j')) 
     ,peg2.dal-1 
     ) 
   and  nvl(figi.al,to_date('3333333','j')) 
   >= greatest(rapa.dal,peg1.dal) 
   and  figi.numero   = peg1.figura 
   and  cost.dal  <= least(nvl(rapa.al,to_date('3333333','j')) 
     ,nvl(peg1.al,to_date('3333333','j')) 
     ,peg2.dal-1 
     ) 
   and  nvl(cost.al,to_date('3333333','j')) 
   >= greatest(rapa.dal,peg1.dal) 
   and  cost.contratto   = qugi.contratto 
   and  rifu.settore  (+) = peg1.settore 
   and  rifu.sede  (+) = nvl(peg1.sede,0) 
union 
select  rapa.ci  ci 
 ,greatest(rapa.dal 
 ,peg1.dal 
 ,peg2.al+1 
 ,qugi.dal 
 ,figi.dal 
 ,cost.dal 
 )   dal 
 ,decode(least(nvl(rapa.al,to_date('3333333','j')) 
    ,nvl(peg1.al,to_date('3333333','j')) 
    ,nvl(qugi.al,to_date('3333333','j')) 
    ,nvl(figi.al,to_date('3333333','j')) 
    ,nvl(cost.al,to_date('3333333','j')) 
    ),to_date('3333333','j'),to_date(null), 
  least(nvl(rapa.al,to_date('3333333','j')) 
    ,nvl(peg1.al,to_date('3333333','j')) 
    ,nvl(qugi.al,to_date('3333333','j')) 
    ,nvl(figi.al,to_date('3333333','j')) 
    ,nvl(cost.al,to_date('3333333','j')) 
    ) 
    ) 
 ,'SF'  segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,nvl(rapa.gg_set,trunc(cost.ore_lavoro/decode(cost.ore_gg,0,1))) 
     gg_set 
 ,nvl(rapa.min_gg,trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1))*60 
  +round((cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1) 
  -trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1)))*60 
  ) 
  )  min_gg 
 ,peg1.rilevanza rilevanza 
 ,peg1.dal    dal_periodo 
 ,peg1.figura figura 
 ,figi.dal    dal_figura 
 ,qugi.contratto contratto 
 ,qugi.dal    dal_contratto 
 ,peg1.qualifica qualifica 
 ,qugi.dal    dal_qualifica 
 ,nvl(peg1.ore,cost.ore_lavoro) 
     ore 
 ,decode(nvl(rapa.sede,peg1.sede),0,null 
  ,nvl(rapa.sede,peg1.sede)) 
     sede 
 ,decode(peg1.sede,0,null,peg1.sede) 
     sede_cdc 
 ,peg1.settore   settore 
 ,figi.profilo   profilo_professionale 
 ,peg1.posizione posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,figi.profilo,peg1.posizione)) 
     assistenza 
 ,nvl(rapa.cdc,rifu.cdc) 
     cdc 
  from  qualifiche_giuridiche   qugi 
 ,figure_giuridiche figi 
 ,contratti_storici cost 
 ,periodi_giuridici peg2 
 ,periodi_giuridici peg1 
 ,ripartizioni_funzionali rifu 
 ,rapporti_presenza rapa 
 where  peg1.dal  <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg1.al,to_date('3333333','j')) 
   >= rapa.dal 
   and  peg1.rilevanza   = 'S' 
   and  peg1.ci    = rapa.ci 
   and  peg2.dal  <= nvl(peg1.al,to_date('3333333','j')) 
   and  nvl(peg2.al,to_date('3333333','j')) 
   >= peg1.dal 
   and  peg2.rilevanza   = 'E' 
   and  peg2.ci    = rapa.ci 
   and  nvl(peg2.al,to_date('3333333','j')) 
    < nvl(peg1.al,to_date('3333333','j')) 
   and  not exists 
 (select 'x' 
 from periodi_giuridici peg3 
   where peg3.dal <= nvl(peg1.al,to_date('3333333','j')) 
  and nvl(peg3.al,to_date('3333333','j')) 
   >= peg1.dal 
  and peg3.dal  > peg2.dal 
  and peg3.rilevanza  = 'E' 
  and peg3.ci   = rapa.ci 
 ) 
   and  qugi.dal  <= least(nvl(rapa.al,to_date('3333333','j')) 
     ,nvl(peg1.al,to_date('3333333','j')) 
     ) 
   and  nvl(qugi.al,to_date('3333333','j')) 
   >= greatest(rapa.dal,peg2.al+1,peg1.dal) 
   and  qugi.numero   = peg1.qualifica 
   and  figi.dal  <= least(nvl(rapa.al,to_date('3333333','j')) 
     ,nvl(peg1.al,to_date('3333333','j')) 
     ) 
   and  nvl(figi.al,to_date('3333333','j')) 
   >= greatest(rapa.dal,peg2.al+1,peg1.dal) 
   and  figi.numero   = peg1.figura 
   and  cost.dal  <= least(nvl(rapa.al,to_date('3333333','j')) 
     ,nvl(peg1.al,to_date('3333333','j')) 
     ) 
   and  nvl(cost.al,to_date('3333333','j')) 
   >= greatest(rapa.dal,peg2.al+1,peg1.dal) 
   and  cost.contratto   = qugi.contratto 
   and  rifu.settore  (+) = peg1.settore 
   and  rifu.sede  (+) = nvl(peg1.sede,0) 
union 
select  rapa.ci  ci 
 ,greatest(rapa.dal,peg1.dal,qugi.dal,figi.dal,cost.dal) 
     dal 
 ,decode(least(nvl(rapa.al,to_date('3333333','j')) 
    ,nvl(peg1.al,to_date('3333333','j')) 
    ,nvl(qugi.al,to_date('3333333','j')) 
    ,nvl(figi.al,to_date('3333333','j')) 
    ,nvl(cost.al,to_date('3333333','j')) 
    ),to_date('3333333','j'),to_date(null) 
    ,least(nvl(rapa.al,to_date('3333333','j')) 
    ,nvl(peg1.al,to_date('3333333','j')) 
    ,nvl(qugi.al,to_date('3333333','j')) 
    ,nvl(figi.al,to_date('3333333','j')) 
    ,nvl(cost.al,to_date('3333333','j')) 
    ) 
    ) 
 ,decode(peg1.rilevanza,'S','SI','EI') 
     segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,nvl(rapa.gg_set,trunc(cost.ore_lavoro/decode(cost.ore_gg,0,1))) 
     gg_set 
 ,nvl(rapa.min_gg,trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1))*60 
  +round((cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1) 
  -trunc(cost.ore_gg*nvl(peg1.ore,cost.ore_lavoro) 
  /decode(cost.ore_lavoro,0,1)))*60 
  ) 
  )  min_gg 
 ,peg1.rilevanza rilevanza 
 ,peg1.dal    dal_periodo 
 ,peg1.figura figura 
 ,figi.dal    dal_figura 
 ,qugi.contratto contratto 
 ,qugi.dal    dal_contratto 
 ,peg1.qualifica qualifica 
 ,qugi.dal    dal_qualifica 
 ,nvl(peg1.ore,cost.ore_lavoro) 
     ore 
 ,decode(nvl(rapa.sede,peg1.sede),0,null 
  ,nvl(rapa.sede,peg1.sede)) 
     sede 
 ,decode(peg1.sede,0,null,peg1.sede) 
     sede_cdc 
 ,peg1.settore   settore 
 ,figi.profilo   profilo_professionale 
 ,peg1.posizione posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,figi.profilo,peg1.posizione)) 
     assistenza 
 ,nvl(rapa.cdc,rifu.cdc) 
     cdc 
  from  qualifiche_giuridiche   qugi 
 ,figure_giuridiche figi 
 ,contratti_storici cost 
 ,periodi_giuridici peg1 
 ,ripartizioni_funzionali rifu 
 ,rapporti_presenza rapa 
 where  peg1.dal  <= nvl(rapa.al,to_date('3333333','j')) 
   and  nvl(peg1.al,to_date('3333333','j')) 
   >= rapa.dal 
   and ( peg1.rilevanza  = 'S' 
  and not exists 
  (select 'x' 
  from periodi_giuridici peg2 
 where peg2.dal   <= nvl(peg1.al,to_date('3333333','j')) 
   and nvl(peg2.al,to_date('3333333','j')) 
   >= peg1.dal 
   and peg2.rilevanza = 'E' 
   and peg2.ci  = peg1.ci 
  ) 
  or  peg1.rilevanza  = 'E' 
 ) 
   and  peg1.ci    = rapa.ci 
   and  qugi.dal  <= least(nvl(peg1.al,to_date('3333333','j')) 
     ,nvl(rapa.al,to_date('3333333','j')) 
     ) 
   and  nvl(qugi.al,to_date('3333333','j')) 
   >= greatest(peg1.dal,rapa.dal) 
   and  qugi.numero   = peg1.qualifica 
   and  figi.dal  <= least(nvl(peg1.al,to_date('3333333','j')) 
     ,nvl(rapa.al,to_date('3333333','j')) 
     ) 
   and  nvl(figi.al,to_date('3333333','j')) 
   >= greatest(peg1.dal,rapa.dal) 
   and  figi.numero   = peg1.figura 
   and  cost.dal  <= least(nvl(peg1.al,to_date('3333333','j')) 
     ,nvl(rapa.al,to_date('3333333','j')) 
     ) 
   and  nvl(cost.al,to_date('3333333','j')) 
   >= greatest(peg1.dal,rapa.dal) 
   and  cost.contratto    = qugi.contratto 
   and  rifu.settore  (+) = peg1.settore 
   and  rifu.sede  (+) = nvl(peg1.sede,0) 
union 
select  rapa.ci  ci 
 ,rapa.dal    dal 
 ,rapa.al  al 
 ,'RV'  segmento 
 ,rapa.dal    dal_rapporto 
 ,rapa.ufficio   ufficio 
 ,rapa.gg_set gg_set 
 ,nvl(rapa.min_gg,1)   min_gg 
 ,null  rilevanza 
 ,to_date(null)  dal_periodo 
 ,to_number(null)   figura 
 ,to_date(null)  dal_figura 
 ,null  contratto 
 ,to_date(null)  dal_contratto 
 ,to_number(null)   qualifica 
 ,to_date(null)  dal_qualifica 
 ,to_number(null)   ore 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede 
 ,decode(rapa.sede,0,null,rapa.sede) 
     sede_cdc 
 ,to_number(null)   settore 
 ,null  profilo_professionale 
 ,null  posizione 
 ,nvl(rapa.assistenza,f_assistenza(rapa.ci,to_char(null),to_char(null))) 
     assistenza 
 ,rapa.cdc    cdc 
  from  rapporti_presenza rapa 
 where  not  exists 
 (select 'x' 
 from periodi_giuridici peg1 
   where peg1.dal  <= nvl(rapa.al,to_date('3333333','j')) 
  and nvl(peg1.al,to_date('3333333','j')) 
    >= rapa.dal 
  and peg1.ci = rapa.ci 
  and peg1.rilevanza  in ('S','E') 
 )
/

