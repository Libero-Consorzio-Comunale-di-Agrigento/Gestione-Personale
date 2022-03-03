create table individui_modificati
( ni                number(8),
  progressivo       number(10),
  tabella           varchar2(30),
  rilevanza         varchar2(1),
  dal               date,
  al                date,
  operazione        varchar2(1),
  utente            varchar2(10),
  data_agg          date,
  sindacato         varchar2(10),
  ci                number(8)
)
/
