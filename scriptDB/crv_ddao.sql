CREATE OR REPLACE VIEW ASSENZE_A_ORE
(CI, DAL, AL, DISOCCUPAZIONE_INPS, VOCE, 
 SUB, ORE, GIORNI)
AS 
select          moco.ci
              , moco.riferimento dal
              , moco.riferimento al
              , rtrim(substr(voec.note,instr(voec.note,'[ASSENZA')+17,2),' ') disoccupazione_inps
              , moco.voce
              , moco.sub
              , sum(moco.qta)
     , round( sum(moco.qta)
            / decode( gp4_cale.get_giorno((moco.riferimento+1),max(ragi.sede))
           , 's',4
              , 'S',4
                   ,8)
       ) giorni
from rapporti_giuridici ragi
   , movimenti_contabili moco
   , voci_economiche voec
where ragi.ci = moco.ci
and moco.voce = voec.codice
and voec.note like '%[ASSENZA DS INPS%]%'
group by moco.ci
              , moco.riferimento
              , moco.riferimento
              , rtrim(substr(voec.note,instr(voec.note,'[ASSENZA')+17,2),' ')
              , moco.voce
              , moco.sub
/