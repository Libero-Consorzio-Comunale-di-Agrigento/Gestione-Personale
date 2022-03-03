CREATE OR REPLACE TRIGGER UNOR_REUO_TMA
AFTER DELETE OR INSERT OR UPDATE
ON UNITA_ORGANIZZATIVE
for each row
   /******************************************************************************
      NAME:
      PURPOSE:   Mantiene l'allineamento tra UNITA_ORGANIZZATIVE e RELAZIONI_UO
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        03/02/2005
      1.1        11/03/2005  MM               Attivita 10116
      1.2        17/10/2006  MS               Mod. Insert
      1.3        24/01/2007  MM               Attivita 4442
   ******************************************************************************/
declare
   integrity_error exception;
   errno        integer;
   errmsg       char(200);
   a_istruzione varchar2(2000);
   a_messaggio  varchar2(2000);
begin
   begin
      if integritypackage.getnestlevel = 0 then
         integritypackage.nextnestlevel;
         begin
            /* NONE */
            null;
         end;
         integritypackage.previousnestlevel;
      end if;
   end;
   if inserting or updating then
      begin
         a_istruzione := 'begin gp4gm.aggiorna_reuo(' || nvl(:new.ni, :old.ni) || ',' ||
                         nvl(:old.ni, :new.ni) || ',' ||
                         nvl(:new.unita_padre, :old.unita_padre) || ',' ||
                         nvl(:old.unita_padre, :new.unita_padre) || ',' ||
                         nvl(:new.revisione, :old.revisione) || ',' ||
                         nvl(:old.revisione, :new.revisione) || ',' || '''I''' || '); end;';
      end;
   elsif deleting then
      begin
         a_istruzione := 'begin gp4gm.aggiorna_reuo(' || nvl(:new.ni, :old.ni) || ',' ||
                         nvl(:old.ni, :new.ni) || ',' ||
                         nvl(:new.unita_padre, :old.unita_padre) || ',' ||
                         nvl(:old.unita_padre, :new.unita_padre) || ',' ||
                         nvl(:new.revisione, :old.revisione) || ',' ||
                         nvl(:old.revisione, :new.revisione) || ',' || '''D''' || '); end;';
      end;
   end if;
   dbms_output.put_line(substr(a_istruzione, 1, 250));
   integritypackage.set_postevent(a_istruzione, a_messaggio);
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/
