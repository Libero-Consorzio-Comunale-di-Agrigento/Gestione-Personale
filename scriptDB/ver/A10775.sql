-- passa sul 2004 i rec. di assestamento della CSTOR (1^ parte - quella che inserisce lo storno
-- in modo che i successivi calcoli non li rideterminino); li riconosce perchè
-- si tratta di *R* sul mese 1 del 2005 con rif. < 2005 e von voci/sub calcolati a Cumulo
-- hanno la qta != 0 perche' attivata con la per rit di DRIVO dal CSTOR
-- non hanno un "corrispondente" sul mese 12/2004 come i rec. inseriti dalla CSTRO 2^ parte
-- (quella che assesta gli storni già fatti dai calcoli di gen-apr)
update movimenti_contabili moco
set anno = 2004
  , mese = 12
where anno = 2005
  and mese = 1
  and mensilita = '*R*'
  and (voce,sub) in (select voce,sub from ritenute_voce
                      where val_voce_ipn = 'C')
  and to_char(riferimento,'yyyy') < 2005
  and qta != 0
  and not exists (select 'x' from movimenti_contabili
                   where ci = moco.ci
                     and anno = 2004
                     and mese = 12
                     and mensilita = '*R*'
                     and voce = moco.voce
                     and sub = moco.sub
                     and to_char(riferimento,'yyyy') = to_char(moco.riferimento,'yyyy')
                     and sede_del = 'CSTO'
                  ) 
/
