create or replace view dati_movimenti_contabili as
select  moco.CI                     
,moco.ANNO                   
,moco.MESE                   
,moco.MENSILITA              
,moco.VOCE                   
,moco.SUB                    
,moco.RIFERIMENTO            
,moco.ARR                    
,moco.INPUT                  
,moco.DATA                   
,moco.QUALIFICA              
,moco.TIPO_RAPPORTO          
,moco.ORE                    
,moco.TAR                    
,moco.QTA                    
,moco.IMP                    
,moco.TAR_VAR                
,moco.QTA_VAR                
,moco.IMP_VAR                
,moco.SEDE_DEL               
,moco.ANNO_DEL               
,moco.NUMERO_DEL             
,moco.DELIBERA               
,moco.CAPITOLO               
,moco.ARTICOLO               
,moco.CONTO                  
,moco.IPN_P                  
,moco.IPN_EAP                
,moco.COMPETENZA             
,to_date(
lpad(to_char(mens.giorno),2,'0')||
                    lpad(to_char(mens.mese_liq),2,'0')||
                     to_char(decode( sign(mens.mese_liq - moco.mese)
                                          , -1, moco.anno + 1
                                              , moco.anno
                                          ))
,'ddmmyyyy') valuta
, last_day(moco.riferimento) periodo
, to_char(riferimento,'yyyy') anno_riferimento
from mensilita mens,movimenti_contabili moco
where mens.mese = moco.mese
and mens.mensilita = moco.mensilita
/
