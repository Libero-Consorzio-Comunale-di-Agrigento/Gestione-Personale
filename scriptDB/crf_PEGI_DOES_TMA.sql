CREATE OR REPLACE TRIGGER PEGI_DOES_TMA
 AFTER UPDATE of AL ON PERIODI_GIURIDICI
FOR EACH ROW
/******************************************************************************
   NAME:       PEGI_DOES_TMA
   PURPOSE:    Registra la cessazione dell'individuo su DOTAZIONE_ESAURIMENTO
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   d_ci             number(8);
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   if :NEW.rilevanza = 'P' then
      BEGIN
         update dotazione_esaurimento
		    set data_cessazione = greatest(nvl(data_cessazione,to_date(2222222,'j')),:NEW.AL)
		  where ci              = :NEW.CI
         ;
      END;
   end if;
exception
   when others then null;
end;
/
