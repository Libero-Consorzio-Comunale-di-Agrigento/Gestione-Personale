CREATE OR REPLACE VIEW riepilogo_movimenti_incentivo
(
     progetto
    ,scp
    ,anno
    ,mese
    ,equipe
    ,gruppo
    ,ruolo
    ,qualifica
    ,tipo_rapporto
    ,liquidato
    ,saldo
    ,da_liquidare
    ,nr_individui
)
AS SELECT
       moip.progetto                                   
     , moip.scp                                        
     , moip.anno                                       
     , moip.mese                                       
     , moip.equipe                                     
     , moip.gruppo                                     
     , moip.ruolo                                      
     , moip.qualifica                                  
     , moip.tipo_rapporto                              
     , nvl(sum(moip.liquidato),0)                      
     , nvl(sum(moip.saldo),0)                          
     , nvl(sum(moip.da_liquidare),0)                   
     , nvl(count(distinct ci),0)                       
FROM
    movimenti_incentivo  moip
 group by moip.progetto, moip.scp
        , moip.anno, moip.mese
        , moip.equipe, moip.gruppo, moip.ruolo
        , moip.qualifica, moip.tipo_rapporto
;
