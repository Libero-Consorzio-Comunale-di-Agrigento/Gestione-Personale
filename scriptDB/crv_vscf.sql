create or replace view vista_scaglioni_fiscali
(dal
,al
,scaglione
,aliquota
,imposta
)
as
select dal
     , al
     , scaglione
     , aliquota
     , imposta
  from scaglioni_fiscali
union
select dal
     , al
     , 9999999
     , 100
     , 100
  from scaglioni_fiscali
 group by dal,al
/