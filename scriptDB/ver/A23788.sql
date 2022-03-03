DECLARE
V_tipo varchar2(10);
V_comando varchar2(100);
BEGIN
select tabtype 
  into V_tipo
  from tab
where tname = 'SOGGETTI';
   IF V_tipo = 'TABLE' THEN
      V_comando := 'alter table soggetti modify ( divisione varchar2(4) ) ';
      si4.sql_execute(V_comando);
   ELSE null;
   END IF;
END;
/


alter table SIA_DEFAULT_INDICI_COL modify ( COLUMN_NAME varchar2(4000) );
