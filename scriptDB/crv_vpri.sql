CREATE OR REPLACE FORCE VIEW VISTA_PREMI_INAIL
(GESTIONE, ANNO, TIPO, POSIZIONE, PREMIO_RICALCOLATO, 
 RATA_PAGATA, RATA_ANTICIPATA, REGOLAZIONE)
AS 
select distinct 
       gestione                                                             gestione 
      ,anno                                                                 anno 
      ,' '                                                             tipo 
      ,posizione_inail                                                      posizione 
      ,nvl(peccrein.premi_inail(anno,gestione,posizione_inail,'C'),0)       premio_ricalcolato 
      ,nvl(peccrein.premi_inail(anno,gestione,posizione_inail,'P'),0)       rata_pagata 
      ,nvl(peccrein.premi_inail(anno+1,gestione,posizione_inail,'P'),0)     rata_anticipata 
      ,nvl(peccrein.premi_inail(anno,gestione,posizione_inail,'C'),0) - 
       nvl(peccrein.premi_inail(anno,gestione,posizione_inail,'P'),0)       regolazione 
  from totali_retribuzioni_inail; 