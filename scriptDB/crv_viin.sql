create or replace view vista_infortuni as
select    evin.ci
         ,rain.cognome                    
         ,rain.nome
         ,evin.data
         ,evin.progressivo
         ,evin.settore                          num_settore
         ,vise.codice                           cod_settore
         ,vise.descrizione                      des_settore
         ,vise.codice_g                         cod_gestione
         ,vise.codice_a                         cod_sett_a
         ,vise.codice_b                         cod_sett_b
         ,vise.codice_c                         cod_sett_c
         ,sett.cod_reg                          cod_settore_reg
         ,evin.figura                           num_figura
         ,figi.codice                           cod_figura
         ,figi.descrizione                      des_figura
         ,figi.profilo                          cod_prof_prof
         ,prpr.descrizione                      des_prof_prof
         ,figi.posizione                        cod_pos_funz
         ,pofu.descrizione                      des_pos_funz
         ,evin.area                             cod_area
         ,atti.descrizione                      des_area
         ,evin.causa                            cod_causa
         ,cain.descrizione                      des_causa
         ,evin.sub_causa                        cod_sub_causa
         ,suci.descrizione                      des_sub_causa
         ,evin.agente                           cod_agente
         ,agin.descrizione                      des_agente
         ,evin.attivita                         cod_attivita
         ,atin.descrizione                      des_attivita
         ,evin.parte1                           cod_parte1
         ,paan1.descrizione                     des_parte1
         ,evin.parte2                           cod_parte2
         ,paan2.descrizione                     des_parte2
         ,evin.parte3                           cod_parte3
         ,paan3.descrizione                     des_parte3
--
  from    eventi_infortunio                     evin
         ,rapporti_individuali                  rain
         ,vista_settori                         vise
         ,settori                               sett
         ,figure_giuridiche                     figi
         ,profili_professionali                 prpr
         ,posizioni_funzionali                  pofu
         ,attivita                              atti
         ,cause_infortunio                      cain
         ,sub_cause_infortunio                  suci
         ,agenti_infortunio                     agin
         ,attivita_infortunio                   atin
         ,parti_anatomiche                      paan1
         ,parti_anatomiche                      paan2
         ,parti_anatomiche                      paan3
 where    evin.ci                               = rain.ci
   and    evin.settore                          = vise.numero
   and    evin.settore                          = sett.numero
   and    evin.figura                           = figi.numero
   and    evin.data                       between figi.dal
                                              and nvl(figi.al,to_date(3333333,'j'))
   and    prpr.codice                           = figi.profilo   
   and    pofu.profilo                          = figi.profilo   (+)
   and    pofu.codice                           = figi.posizione (+)
   and    evin.area      (+)                    = atti.codice 
   and    evin.causa                            = cain.causa
   and    evin.causa                            = suci.causa
   and    evin.sub_causa                        = suci.sub
   and    evin.causa                            = agin.causa               (+)
   and    evin.agente                           = agin.agente              (+)    
   and    evin.attivita_infortunio              = atin.attivita            (+)
   and    evin.parte1                           = paan1.parte              (+)
   and    evin.parte2                           = paan2.parte              (+)
   and    evin.parte3                           = paan3.parte              (+)
/
