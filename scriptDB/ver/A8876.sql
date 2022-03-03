update a_selezioni
set descrizione =  substr(replace(descrizione,'Mensil','Cod.Mensil')
                         ,decode(sign((length( replace(descrizione,'Mensil','Cod.Mensil') )-29))
                                ,-1,1,length( replace(descrizione,'Mensil','Cod.Mensil') )-29
                                )
                          )
where descrizione like '%ensilit%'
  and instr(descrizione,'Cod.Mensil') = 0
  and substr(voce_menu,1,3) in ( 'PAM','PGM','PEC','PGP', 'PPA', 'PMT')
/