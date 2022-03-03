create table rico2006 as 
select * from ripartizioni_contabili where arr in ('C','P')
/
update rico2006 
   set arr = decode(arr,'P','S','C','A')
     , chiave = GESTIONE||RUOLO||DI_RUOLO||FUNZIONALE||BILANCIO||
                decode(arr,'P','S','C','A')
/
insert into ripartizioni_contabili select * from rico2006 
/
start crv_mobi.sql

