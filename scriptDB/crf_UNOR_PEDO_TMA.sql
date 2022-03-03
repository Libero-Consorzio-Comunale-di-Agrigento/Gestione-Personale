create or replace trigger unor_pedo_tma
   after insert or update of codice_uo on unita_organizzative
   for each row
/******************************************************************************
   NAME:      Aggiorna PERIODI_DOTAZIONE a fronte di una modifica del CODICE_UO
              di una unita organizzativa preesistente
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/02/2005
   1.1        15/06/2007  MM               A21621
******************************************************************************/
begin
   update periodi_dotazione
      set codice_uo = :new.codice_uo
    where unita_ni = :new.ni
      and nvl(al, to_date(3333333, 'j')) between :new.dal and
          nvl(:new.al, to_date(3333333, 'j'));
exception
   when others then
      -- Consider logging the error and then re-raise
      raise;
end;
/
