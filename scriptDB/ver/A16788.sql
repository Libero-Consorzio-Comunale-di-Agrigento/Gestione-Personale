start crp_pecca730.sql

update a_selezioni 
   set valore_default = 'sysdate'
where voce_menu = 'PEC4A730'
  and parametro = 'P_DATA_RIC'
/