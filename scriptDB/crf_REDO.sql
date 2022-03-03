-- Trigger di controllo su REVISIONI_DOTAZIONE
-- Non può esistere più di una revisione in Modifica
-- Non può esistere più di una revisione Attiva

CREATE OR REPLACE TRIGGER REDO_TB 
   before INSERT or UPDATE on REVISIONI_DOTAZIONE 
BEGIN 
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel; 
   END IF; 
END;
/

CREATE OR REPLACE TRIGGER REDO_TC 
   after INSERT or UPDATE on REVISIONI_DOTAZIONE 
BEGIN 
   IntegrityPackage.Exec_PostEvent; 
END;
/

CREATE OR REPLACE TRIGGER REDO_CHK
 before INSERT OR UPDATE ON REVISIONI_DOTAZIONE
FOR EACH ROW
/******************************************************************************
   NAME:       REDO_CHK
   PURPOSE:    Controllo di consistenza dello stato su REVISIONI_DOTAZIONE
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   d_ci             number(8);
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
      -- Set PostEvent Check REFERENTIAL Integrity on DELETE
   DECLARE a_istruzione  varchar2(2000);
           a_messaggio   varchar2(2000);
           d_revisione   number(8);
           d_stato       varchar2(1);
   BEGIN
      d_revisione := :NEW.revisione;
      d_stato     := :NEW.stato;
      a_istruzione :=  
'select 0'|| 
'  from REVISIONI_DOTAZIONE '||
' where stato      = '||''''||d_stato||''''||
'   and stato      = ''A'''||
'   and revisione <> '||d_revisione||'';
      a_messaggio  := 'Esiste gia una Revisione Attiva';
      IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
      a_istruzione :=  
'select 0'|| 
'  from REVISIONI_DOTAZIONE '||
' where stato      = '||''''||d_stato||''''||
'   and stato      = ''M'''||
'   and revisione <> '||d_revisione||'';
      a_messaggio  := 'Esiste gia una Revisione in modifica';
      IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
   END;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise_application_error(-20007,'Errore di inserimento su REVISIONI_DOTAZIONE.');
        raise;
end;
/
