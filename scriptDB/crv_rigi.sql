CREATE OR REPLACE VIEW riferimento_giuridico
(
     anno
    ,mese
    ,ini_mes
    ,fin_mes
)
AS SELECT
       to_number(to_char(sysdate,'yyyy'))              
     , to_number(to_char(sysdate,'mm'))                
     , to_date(to_char(sysdate,'mmyyyy'),'mmyyyy')     
     , last_day(sysdate)                               
FROM
    ente  ente
;
