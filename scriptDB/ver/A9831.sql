update rapporti_individuali
   set tipo_ni = 'I'
 where nome is not null
;
update rapporti_individuali
   set tipo_ni = 'E'
 where nome is null
;