CREATE OR REPLACE FORCE VIEW VISTA_ESENZIONI_INAIL ( GESTIONE, 
ANNO, TIPO, POSIZIONE, VOCE, 
ESENZIONE, DES_ESENZIONE, ALIQUOTA, QUOTA_ESENTE
 ) AS select  trei.gestione                                                   gestione 
       ,trei.anno                                                       anno 
	   ,trei.tipo_ipn                                                   tipo 
	   ,trei.posizione_inail                                            posizione 
	   ,poin.voce_rischio                                               voce 
	   ,trei.esenzione                                                  esenzione 
	   ,max(gp4_esin.get_descrizione(trei.esenzione))                   des_esenzione 
	   ,max(gp4_alei.get_aliquota(trei.esenzione,trei.anno))            aliquota 
	   ,sum(trei.imponibile * poin.aliquota / 100) * 
	    max(gp4_alei.get_aliquota(trei.esenzione,trei.anno) / 100)      quota_esente 
  from  totali_retribuzioni_inail                                       trei 
       ,ponderazione_inail                                              poin 
 where  poin.posizione_inail                                               = trei.posizione_inail 
   and  poin.anno                                                          = trei.anno 
   and  trei.esenzione                                                    is not null 
 group  by  trei.gestione 
           ,trei.anno 
	       ,trei.tipo_ipn 
	       ,trei.posizione_inail 
	       ,poin.voce_rischio 
	       ,trei.esenzione
;

