alter table unita_organizzative modify (codice_uo varchar2(15));
update unita_organizzative unor
   set codice_uo = (select codice from settori_amministrativi
                     where ni        = unor.ni
		    	   )
 where ottica     = 'GP4'
   and codice_uo is null
;