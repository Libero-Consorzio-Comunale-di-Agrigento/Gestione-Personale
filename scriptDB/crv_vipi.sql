CREATE OR REPLACE FORCE VIEW VISTA_PONDERAZIONI_INAIL ( GESTIONE, 
ANNO, TIPO, POSIZIONE, VOCE, 
DES_VOCE, ALIQUOTA, RETRIBUZIONE, PARZ_ESENTE, 
TOT_ESENTE ) AS select  vrei.gestione                                     gestione 
       ,vrei.anno                                         anno 
	   ,vrei.tipo                                         tipo 
	   ,vrei.posizione                                    posizione 
	   ,poin.voce_rischio                                 voce 
	   ,gp4_vori.get_descrizione(poin.voce_rischio)       des_voce 
	   ,max(poin.aliquota)                                aliquota 
	   ,sum(vrei.retribuzione) * max(poin.aliquota) / 100 retribuzione 
	   ,sum(vrei.parz_esente) * max(poin.aliquota) / 100  parz_esente 
	   ,sum(vrei.tot_esente) * max(poin.aliquota) / 100   tot_esente 
  from  vista_retribuzioni_inail  vrei 
       ,ponderazione_inail        poin 
 where  poin.posizione_inail         = vrei.posizione 
   and  poin.anno                    = vrei.anno 
   and  exists 
       (select 'x' 
	      from ponderazione_inail 
	     where posizione_inail         = vrei.posizione 
		   and anno                    = vrei.anno 
	   ) 
 group  by vrei.gestione 
          ,vrei.anno 
	      ,vrei.tipo 
	      ,vrei.posizione 
	      ,poin.voce_rischio 
union 
select  vrei.gestione                                     gestione 
       ,vrei.anno                                         anno 
	   ,vrei.tipo                                         tipo 
	   ,vrei.posizione                                    posizione 
	   ,to_char(null)                                     voce 
	   ,'Posizione non ponderata'                         des_voce 
	   ,to_number(null)                                   aliquota 
	   ,sum(vrei.retribuzione)                            retribuzione 
	   ,sum(vrei.parz_esente)                             parz_esente 
	   ,sum(vrei.tot_esente)                              tot_esente 
  from  vista_retribuzioni_inail  vrei 
 where  not exists 
       (select 'x' 
	      from ponderazione_inail 
	     where posizione_inail         = vrei.posizione 
		   and anno                    = vrei.anno 
	   ) 
 group  by vrei.gestione 
          ,vrei.anno 
	      ,vrei.tipo 
	      ,vrei.posizione
;
