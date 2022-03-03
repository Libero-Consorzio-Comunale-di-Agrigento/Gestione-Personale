create or replace force view vista_premi_inail_ruolo as
select distinct gestione gestione
               ,ruolo
               ,anno anno
               ,' ' tipo
               ,posizione_inail posizione
               ,nvl(peccrein.premi_inail_ruolo(anno
                                              ,gestione
                                              ,ruolo
                                              ,posizione_inail
                                              ,'C')
                   ,0) premio_ricalcolato
               ,nvl(peccrein.premi_inail_ruolo(anno
                                              ,gestione
                                              ,ruolo
                                              ,posizione_inail
                                              ,'P')
                   ,0) rata_pagata
               ,nvl(peccrein.premi_inail_ruolo(anno + 1
                                              ,gestione
                                              ,ruolo
                                              ,posizione_inail
                                              ,'P')
                   ,0) rata_anticipata
               ,nvl(peccrein.premi_inail_ruolo(anno
                                              ,gestione
                                              ,ruolo
                                              ,posizione_inail
                                              ,'C')
                   ,0) - nvl(peccrein.premi_inail_ruolo(anno
                                                       ,gestione
                                                       ,ruolo
                                                       ,posizione_inail
                                                       ,'P')
                            ,0) regolazione
  from totali_retribuzioni_inail;
  

