update movimenti_fiscali mofi
   set det_spe = 
      (select mofi.det_spe +
              nvl(sum(det_fis),0) - ( nvl(sum(det_con),0) + nvl(sum(det_fig),0) +
                                      nvl(sum(det_alt),0) + nvl(sum(det_spe),0) +
                                      nvl(sum(det_ult),0)
                                    )
         from movimenti_fiscali
        where anno = mofi.anno
          and ci   = mofi.ci
        group by ci
       )
 where mese = 12
   and mensilita = '*R*'
   and exists 
      (select mofi.det_spe +
              nvl(sum(det_fis),0) - ( nvl(sum(det_con),0) + nvl(sum(det_fig),0) +
                                      nvl(sum(det_alt),0) + nvl(sum(det_spe),0) +
                                      nvl(sum(det_ult),0)
                                    )
         from movimenti_fiscali
        where anno = mofi.anno
          and ci   = mofi.ci
        group by ci
 having abs(nvl(sum(det_fis),0) - ( nvl(sum(det_con),0) + nvl(sum(det_fig),0) +
                         nvl(sum(det_alt),0) + nvl(sum(det_spe),0) +
                         nvl(sum(det_ult),0)
                      )) between 0.005 and 0.30
       )
/
insert into movimenti_fiscali
( ci         
, anno                    
, mese               
, mensilita       
, rit_ord     
, ipn_ord     
, alq_ord      
, ipt_ord       
, alq_ac    
, ipt_ac       
, det_fis  
, det_con      
, det_fig     
, det_alt     
, det_spe    
, det_ult       
, det_god    
, con_fis         
, rit_ap        
, ipn_ap        
, alq_ap             
, ipt_ap      
, lor_liq           
, lor_acc         
, rit_liq         
, rid_liq         
, rtp_liq    
, ipn_liq          
, alq_liq    
, ipt_liq          
, gg_anz_t    
, gg_anz_i            
, gg_anz_r              
, lor_tra           
, rit_tra               
, ipn_tra              
)
select ci,anno,12,'*R*',0,0,0,0,0,0,0,0,0,0,
              nvl(sum(det_fis),0) - ( nvl(sum(det_con),0) + nvl(sum(det_fig),0) +
                                      nvl(sum(det_alt),0) + nvl(sum(det_spe),0) +
                                      nvl(sum(det_ult),0)
                                    )
     , 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  from movimenti_fiscali mofi
 where not exists
      (select 'x' from movimenti_fiscali
        where anno = mofi.anno 
          and mese = 12 
          and mensilita = '*R*'
          and ci = mofi.ci)
 group by ci, anno
having abs(nvl(sum(det_fis),0) - ( nvl(sum(det_con),0) + nvl(sum(det_fig),0) +
                                   nvl(sum(det_alt),0) + nvl(sum(det_spe),0) +
                                   nvl(sum(det_ult),0)
                                 )) between 0.005 and 0.30
/