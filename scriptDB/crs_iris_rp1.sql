-- &1 = user di installazione normalmente P00
-- &2 = user di Iris  normalmente MondoEdp

-- acquisizione periodi di assenza di rilevanza giuridica
--              periodi di assenza per part-time verticali
--              causali di presenza

create synonym iris_v042_periodiassenza for &2.v042_periodiassenza;
create synonym iris_v010_calendari for &2.v010_calendari;
create synonym iris_t430_storico for &2.t430_storico;
create synonym iris_t030_anagrafico for &2.t030_anagrafico;
create synonym iris_t460_parttime for &2.t460_parttime;
create synonym timbrature_giornaliere for &2.v100_timbrature;

-- acquisizione variazioni di settore
start crt_devs.sql

-- acquisizione variabili economiche
start crt_pagheads.sql
start crf_pagheads_tiu.sql

-- Grant/Revoke object privileges a MondoEdp
grant select, insert, update, delete on DEPOSITO_VARIAZIONI_SETTORE to &2;
grant select, insert, update, delete on PAGHEADS to &2;

-- Grant/Revoke object privileges a p00
grant select, insert, update, delete, references, alter, index on DEPOSITO_VARIAZIONI_SETTORE to &1;
grant select, insert, update, delete, references, alter, index on PAGHEADS to &1;



