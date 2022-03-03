CREATE OR REPLACE TRIGGER unor_inmo_tma
AFTER UPDATE ON unita_organizzative 
FOR EACH ROW
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
   if :new.revisione = gp4gm.get_revisione_a then
      begin
         a_istruzione := 'begin unor_inmo_tma_pu(' || nvl(:new.ni, :old.ni) || '); end;';
      end;
      dbms_output.put_line(substr(a_istruzione, 1, 250));
      integritypackage.set_postevent(a_istruzione, a_messaggio);
   end if;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/
