CREATE OR REPLACE TRIGGER PERIODI_GIURIDICI_TMA
   after INSERT or UPDATE on PERIODI_GIURIDICI
for each row
/******************************************************************************
 NOME:        PERIODI_GIURIDICI_TMA
 DESCRIZIONE: Trigger for Set REFERENTIAL Integrity
                       at INSERT or UPDATE on Table PERIODI_GIURIDICI
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
******************************************************************************/
declare  
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
   begin  -- Set REFERENTIAL Integrity on UPDATE
      if UPDATING then
         IntegrityPackage.NextNestLevel;
         --  Modify parent code of "PERIODI_GIURIDICI" for all children in "ATTRIBUTI_GIURIDICI"
         if (:OLD.CI != :NEW.CI) or
            (:OLD.RILEVANZA != :NEW.RILEVANZA) or
            (:OLD.DAL != :NEW.DAL) then
            update ATTRIBUTI_GIURIDICI
             set   CI = :NEW.CI,
                   RILEVANZA = :NEW.RILEVANZA,
                   DAL = :NEW.DAL
            where  CI = :OLD.CI
             and   RILEVANZA = :OLD.RILEVANZA
             and   DAL = :OLD.DAL;
         end if;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: PERIODI_GIURIDICI_TMA */

/ 
