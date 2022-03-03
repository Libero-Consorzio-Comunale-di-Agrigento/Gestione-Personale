CREATE OR REPLACE VIEW riepilogo_individui_incentivo
(
     ci
    ,progetto
    ,scp
    ,liquidato
    ,saldo
    ,da_liquidare
    ,nr_mensilita
)
AS SELECT
       moip.ci                                         
     , moip.progetto                                   
     , moip.scp                                        
     , nvl(sum(moip.liquidato),0)                      
     , nvl(sum(moip.saldo),0)                          
     , nvl(sum(moip.da_liquidare),0)                   
     , nvl(count(distinct anno||mese),0)               
FROM
    movimenti_incentivo  moip
 group by moip.ci, moip.progetto, moip.scp
;
