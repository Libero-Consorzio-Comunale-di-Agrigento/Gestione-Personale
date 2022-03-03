delete from A_ERRORI_APPLICAZIONI 
  where ap_errore in ( 'FRM-41049', 'FRM-40602')
    and ambiente = 'P00'
/
insert into A_ERRORI_APPLICAZIONI 
( ap_errore, errore, stile, AMBIENTE)
values ('FRM-41049','A00021','B', 'P00')
/

insert into A_ERRORI_APPLICAZIONI 
( ap_errore, errore, stile, AMBIENTE)
values ( 'FRM-40602', 'A00018', NULL, 'P00')
/