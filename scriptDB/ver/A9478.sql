update a_selezioni set dominio = 'P_CARTOLARIZZAZIONE'
                     , obbligo = 'S'
 where voce_menu = 'PECSMDPM'
   and parametro = 'P_CARTOLARIZZAZIONE'
;

insert into a_domini_selezioni
       (dominio,valore_low,descrizione)
values ('P_CARTOLARIZZAZIONE','C','Solo Dati Cartolarizzazione')
/
insert into a_domini_selezioni
       (dominio,valore_low,descrizione)
values ('P_CARTOLARIZZAZIONE','E','Entrambi')
/
insert into a_domini_selezioni
       (dominio,valore_low,descrizione)
values ('P_CARTOLARIZZAZIONE','D','Solo Dati INPDAP')
/

start crp_pecsmdpm.sql