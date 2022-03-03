create table assenze_iris_log
( 
  ci                     number(8)
, OPERAZIONE             VARCHAR2(1)
, DAL                    DATE
, AL                     DATE
, ASSENZA                VARCHAR2(5)
, DATA_AGG               DATE
, note                   varchar2(250) 
, prenotazione           number(8)
, data_prenotazione      date
)
;
create index asil_pk on assenze_iris_log (ci)
;
