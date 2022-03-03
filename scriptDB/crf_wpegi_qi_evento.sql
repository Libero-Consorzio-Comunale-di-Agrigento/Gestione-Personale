CREATE OR REPLACE FUNCTION wpegi_qi_evento RETURN VARCHAR IS
appoggio varchar(10);
BEGIN
  select '8'
    into appoggio
    from dual
  ;
return appoggio;
END;
/