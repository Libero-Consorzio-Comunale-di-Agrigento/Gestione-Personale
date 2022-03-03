insert into a_domini_selezioni (dominio,valore_low,descrizione)
values ('P_ARR','P','Conferma della condizione proposta');

update a_selezioni set dominio = 'P_ARR'
where voce_menu = 'PECCEVPA';