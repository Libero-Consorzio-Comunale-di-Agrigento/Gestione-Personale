alter table ente add CALCOLO_CAFA VARCHAR2(2);

update ente 
   set CALCOLO_CAFA = 'SI'
 where exists ( select 'x' 
                  from carichi_familiari
                 where anno >= 2010
              )
/
update ente 
   set CALCOLO_CAFA = 'NO'
 where CALCOLO_CAFA is null
/  

alter table ente modify CALCOLO_CAFA NOT NULL
/

insert into a_errori ( errore, descrizione )
values ( 'P05744','Impossibile Eseguire Calcolo Automatico')
/

start crp_pecccafa.sql