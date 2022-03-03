CREATE or replace VIEW progressivi_contabili
(
     ci
    ,anno
    ,mese
    ,mensilita
    ,voce
    ,sub
    ,arr
    ,riferimento
    ,competenza
    ,moco_mese
    ,moco_mensilita
    ,moco_rowid
    ,tar
    ,qta
    ,imp
    ,ipn_p
    ,ipn_eap
    ,p_tar
    ,p_qta
    ,p_imp
    ,p_ipn_p
    ,p_ipn_eap
    ,input
    ,sede_del
    ,anno_del
    ,numero_del
    ,delibera
    ,classe
)
AS SELECT
       moco.ci                                         
     , moco.anno                                       
     , mens.mese                                       
     , mens.mensilita                                  
     , moco.voce                                       
     , moco.sub                                        
     , moco.arr                                        
     , moco.riferimento                                
     , moco.competenza                                
     , moco.mese
     , moco.mensilita
     , moco.rowid
     , decode( lpad(moco.mese,2,'0')||moco.mensilita   
             , lpad(mens.mese,2,'0')||mens.mensilita, tar
                                                    , 0
             )                                         
     , decode( lpad(moco.mese,2,'0')||moco.mensilita   
             , lpad(mens.mese,2,'0')||mens.mensilita, qta
                                                    , 0
             )                                         
     , decode( lpad(moco.mese,2,'0')||moco.mensilita   
             , lpad(mens.mese,2,'0')||mens.mensilita, imp
                                                    , 0
             )                                         
     , decode( lpad(moco.mese,2,'0')||moco.mensilita   
             , lpad(mens.mese,2,'0')||mens.mensilita, ipn_p
                                                    , 0
             )                                         
     , decode( lpad(moco.mese,2,'0')||moco.mensilita   
             , lpad(mens.mese,2,'0')||mens.mensilita, ipn_eap
                                                    , 0
             )                                         
     , decode( voec.memorizza                          
             , 'M', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, tar)
             , 'S', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, tar)
                  , tar                                
             )                                         
     , decode( voec.memorizza                          
             , 'M', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, qta)
             , 'S', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, qta)
                  , qta                                
             )                                         
     , decode( voec.memorizza                          
             , 'M', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, imp)
             , 'S', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, imp)
                  , imp                                
             )                                         
     , decode( voec.memorizza                          
             , 'M', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, ipn_p)
             , 'S', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, ipn_p)
                  , ipn_p                              
             )                                         
     , decode( voec.memorizza                          
             , 'M', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, ipn_eap)
             , 'S', decode( lpad(moco.mese,2,'0')||moco.mensilita
                          , lpad(mens.mese,2,'0')||mens.mensilita, 0, ipn_eap)
                  , ipn_eap                            
             )                                         
     , moco.input
     , sede_del
     , anno_del
     , numero_del
     , delibera
     , voec.classe
FROM
    voci_economiche  voec,
    movimenti_contabili  moco,
    mensilita  mens
 where voec.codice = moco.voce||''
   and moco.input != 'S'
   and lpad(moco.mese,2,'0')||moco.mensilita
                  <= lpad(mens.mese,2,'0')||mens.mensilita
   and (   mens.mese < voec.mese
        or lpad(moco.mese,2,'0')||moco.mensilita
                  >= lpad(nvl(voec.mese,0),2,'0')||voec.mensilita
       )
   and (   voec.memorizza not in ('S','M')
        or (    voec.memorizza = 'M'
            and lpad(moco.mese,2,'0')||moco.mensilita
                      >=
               (select max(lpad(mese,2,'0')||mensilita)
                  from movimenti_contabili
                 where ci   = moco.ci
                   and voce = moco.voce
                   and anno = moco.anno
                   and lpad(mese,2,'0')||mensilita
                            < lpad(mens.mese,2,'0')||mens.mensilita
               )
           )
        or (    voec.memorizza = 'S'
            and lpad(moco.mese,2,'0')||moco.mensilita
                      >=
               (select max(lpad(mese,2,'0')||mensilita)
                  from movimenti_contabili
                 where ci   = moco.ci
                   and voce = moco.voce
                   and anno = moco.anno
                   and lpad(mese,2,'0')||mensilita
                            <= lpad(mens.mese,2,'0')||mens.mensilita
               )       
           )
        )
;
