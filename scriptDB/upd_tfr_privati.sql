update denuncia_o1_inps dein set importo_ap = 
(select   round(  sum(nvl(prfi.fdo_tfr_ap,0)) 
                + sum(nvl(prfi.fdo_tfr_2000,0)) 
                - sum(distinct nvl(fondi_tfr_ac(prfi.ci,rifa.anno,12),0)) 
--                - e_round(sum(distinct nvl(riv_tfr_progr(rifa.anno,prfi.ci),0)) * .11,'I') 
                - e_round(sum(distinct nvl(prfi.riv_tfr_ap,0)) * .11,'I') 
                + sum(nvl(prfi.qta_tfr_ac,0)) 
                - sum(nvl(prfi.rit_tfr,0)) 
                + sum(nvl(prfi.riv_tfr,0)) 
                + sum(nvl(prfi.riv_tfr_ap,0)) 
                - e_round(sum(nvl(prfi.riv_tfr,0)) * 11/100,'I')
                - least (    sum(nvl(prfi.fdo_tfr_ap,0)) 
                           + sum(nvl(prfi.fdo_tfr_2000,0))
--                           - sum(distinct nvl(riv_tfr_progr(rifa.anno,prfi.ci),0))
                           - least( sum(nvl(prfi.fdo_tfr_ap,0)) 
                           + sum(nvl(prfi.fdo_tfr_2000,0))
                         , sum(distinct nvl(fondi_tfr_ac(prfi.ci,rifa.anno,12),0)))
                         ,   greatest( sum(nvl(prfi.fdo_tfr_ap_liq,0)) 
                           + sum(nvl(prfi.fdo_tfr_2000_liq,0))
--                           - sum(distinct nvl(riv_tfr_progr(rifa.anno,prfi.ci),0)) 
                           - decode(  (sum(nvl(prfi.lor_acc_2000,0)) + sum(nvl(prfi.lor_acc,0)))
                                    , 0 ,sum(distinct nvl(fondi_tfr_ac(prfi.ci,rifa.anno,12),0)) 
                                    , 0 
                                   )
                         , 0
                        )
               )     -  sum(nvl(riv_tfr_ap_liq,0))  
                     -  sum(nvl(prfi.riv_tfr_liq,0))
                     -  sum(nvl(prfi.qta_tfr_ac_liq,0))
)
	from progressivi_fiscali   prfi
         , riferimento_fine_anno rifa
     where prfi.anno       = dein.anno
       and dein.anno       = rifa.anno
       and rifa.rifa_id = 'RIFA'
       and prfi.mese       = 12
       and prfi.mensilita  = 
          (select max(mensilita) from mensilita
            where mese  = 12 
              and tipo in ('S','N','A'))
       and prfi.ci         = dein.ci)
where anno = (select anno
                from riferimento_fine_anno
               where rifa_id = 'RIFA'
             )
/