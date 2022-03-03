/* --------------------------------------------------------------------------

   Crea i sinonimmi da Mondo Edp a P00

   &1 = user di Iris normalmente MondoEdp
   &2 = user Intermedio normalmente P00RP

*/ --------------------------------------------------------------------------

-- creazione sinonimi da MondoEdp

create synonym iris_v042_periodiassenza for &1.v042_periodiassenza;
create synonym iris_t030_anagrafico for &1.t030_anagrafico;
create synonym iris_t430_storico for &1.t430_storico;
create synonym iris_v010_calendari for &1.v010_calendari;
create synonym iris_t460_parttime for &1.t460_parttime;


-- creazione sinonimi da p00rp

-- drop cautelativa (potrebbe dare errore)
drop table deposito_variazioni_settore;
create synonym deposito_variazioni_settore for &2.deposito_variazioni_settore;
create synonym iris_pagheads for &2.pagheads;
create synonym iris_timbrature for &2.timbrature_giornaliere;