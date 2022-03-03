delete from a_domini_selezioni
where dominio = 'P_MAL_PRIVATI';

insert into a_domini_selezioni 
(dominio,valore_low,valore_high,descrizione) 
values ('P_MAL_PRIVATI','C','','Mese Corrente');
insert into a_domini_selezioni 
(dominio,valore_low,valore_high,descrizione) 
values ('P_MAL_PRIVATI','P','','Mese Precedente');

update a_selezioni 
set dominio = 'P_MAL_PRIVATI'
where voce_menu = 'PECCADMI'
  and parametro = 'P_MAL_PRIVATI';

start crp_cursore_emens.sql
start crp_peccadmi.sql