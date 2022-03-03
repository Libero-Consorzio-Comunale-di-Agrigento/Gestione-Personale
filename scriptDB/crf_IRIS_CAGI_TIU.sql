create or replace trigger IRIS_CAGI_TIU
   before UPDATE on CAUSALI_GIUSTIFICATIVO
for each row
/******************************************************************************
 NOME:        CAUSALI_GIUSTIFICATIVO_TIU
******************************************************************************/
declare
   functionalnestlevel integer;
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;
begin
   functionalnestlevel := integritypackage.getnestlevel;
   /***************************************************************************
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ---------------------------------------------------
    0    28/06/2007 MM
   ***************************************************************************/
   begin
      begin
         if integritypackage.getnestlevel = 0 then
            declare
               cursor cpk_giustificativi(var_giustificativo varchar2) is
                  select 1
                    from iris_pagheads iris
                   where iris.codpaghe = var_giustificativo
                     and nvl(iris.chiuso, 'NO') = 'NO';
               mutating exception;
               pragma exception_init(mutating, -4091);
            begin
               if :old.causale is not null then
                  open cpk_giustificativi(:old.codice);
                  fetch cpk_giustificativi
                     into dummy;
                  found := cpk_giustificativi%found;
                  close cpk_giustificativi;
                  if found then
                     errno  := -20007;
                     errmsg := 'Giustificativo "' || :old.codice ||
                               '" presente in PAGHEADS. La registrazione  non puo'' essere modificata.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when mutating then
                  null;
            end;
         end if;
      end;
      null;
   end;
   begin
      -- Set FUNCTIONAL Integrity
      if functionalnestlevel = 0 then
         integritypackage.nextnestlevel;
         begin
            -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */
            null;
         end;
         integritypackage.previousnestlevel;
      end if;
      integritypackage.nextnestlevel;
      integritypackage.previousnestlevel;
   end;
exception
   when integrity_error then
      integritypackage.initnestlevel;
      raise_application_error(errno, errmsg);
   when others then
      integritypackage.initnestlevel;
      raise;
end;
/
