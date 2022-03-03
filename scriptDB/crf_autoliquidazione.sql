/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     30/12/2003 15.03.30                          */
/*==============================================================*/



create or replace trigger ALIQUOTE_ESENZIONE_INAIL_TIU
   before INSERT or UPDATE on ALIQUOTE_ESENZIONE_INAIL
for each row
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_TIU
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check UNIQUE Integrity on PK
                          Set FUNCTIONAL Integrity
                       at INSERT or UPDATE on Table ALIQUOTE_ESENZIONE_INAIL
 ECCEZIONI:  -20007, Identificazione CHIAVE presente in TABLE
 ANNOTAZIONI: -  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
    0 __/__/____ __     
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity
      begin  -- Check UNIQUE Integrity on PK of "ALIQUOTE_ESENZIONE_INAIL"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_aliquote_esenzione_inail(var_ESENZIONE varchar,
                            var_ANNO number) is
               select 1
                 from   ALIQUOTE_ESENZIONE_INAIL
                where  ESENZIONE = var_ESENZIONE and
                       ANNO = var_ANNO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ESENZIONE is not null and
                  :new.ANNO is not null then
                  open  cpk_aliquote_esenzione_inail(:new.ESENZIONE,
                                 :new.ANNO);
                  fetch cpk_aliquote_esenzione_inail into dummy;
                  found := cpk_aliquote_esenzione_inail%FOUND;
                  close cpk_aliquote_esenzione_inail;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ESENZIONE||' '||
                               :new.ANNO||
                               '" gia'' presente in ALIQUOTA_ESENZIONE_INAIL. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
   end;
   begin  -- Set FUNCTIONAL Integrity
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ALIQUOTE_ESENZIONE_INAIL_TIU */
/

-- Create Check REFERENTIAL Integrity Procedure on INSERT
create or replace procedure ALIQUOTE_ESENZIONE_INAIL_PI
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ALIQUOTE_ESENZIONE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ALIQUOTE_ESENZIONE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_esenzione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "ESENZIONI_INAIL"
   cursor cpk1_aliquote_esenzione_inail(var_esenzione varchar) is
      select 1
      from   ESENZIONI_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ESENZIONI_INAIL" deve esistere quando si inserisce su "ALIQUOTE_ESENZIONE_INAIL"
         if NEW_ESENZIONE is not null then
            open  cpk1_aliquote_esenzione_inail(NEW_ESENZIONE);
            fetch cpk1_aliquote_esenzione_inail into dummy;
            found := cpk1_aliquote_esenzione_inail%FOUND; /* %FOUND */
            close cpk1_aliquote_esenzione_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ESENZIONI_INAIL. La registrazione ALIQUOTA_ESENZIONE_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ALIQUOTE_ESENZIONE_INAIL_PI */
/
   
-- Create Check REFERENTIAL Integrity Procedure on UPDATE
create or replace procedure ALIQUOTE_ESENZIONE_INAIL_PU
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ALIQUOTE_ESENZIONE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ALIQUOTE_ESENZIONE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_esenzione IN varchar
, old_anno IN number
, new_esenzione IN varchar
, new_anno IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "ESENZIONI_INAIL"
   cursor cpk1_aliquote_esenzione_inail(var_esenzione varchar) is
      select 1
      from   ESENZIONI_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
   --  Declaration of UpdateParentRestrict constraint for "RETRIBUZIONI_INAIL"
   cursor cfk1_retribuzioni_inail(var_esenzione varchar,
                   var_anno number) is
      select 1
      from   RETRIBUZIONI_INAIL
      where  ESENZIONE = var_esenzione
       and   ANNO = var_anno
       and   var_esenzione is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ESENZIONI_INAIL" deve esistere quando si modifica "ALIQUOTE_ESENZIONE_INAIL"
         if  NEW_ESENZIONE is not null and ( seq = 0 )
         and (   (NEW_ESENZIONE != OLD_ESENZIONE or OLD_ESENZIONE is null) ) then
            open  cpk1_aliquote_esenzione_inail(NEW_ESENZIONE);
            fetch cpk1_aliquote_esenzione_inail into dummy;
            found := cpk1_aliquote_esenzione_inail%FOUND; /* %FOUND */
            close cpk1_aliquote_esenzione_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ESENZIONI_INAIL. La registrazione ALIQUOTA_ESENZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "ALIQUOTE_ESENZIONE_INAIL" non modificabile se esistono referenze su "RETRIBUZIONI_INAIL"
      if (OLD_ESENZIONE != NEW_ESENZIONE) or
         (OLD_ANNO != NEW_ANNO) then
         open  cfk1_retribuzioni_inail(OLD_ESENZIONE,
                        OLD_ANNO);
         fetch cfk1_retribuzioni_inail into dummy;
         found := cfk1_retribuzioni_inail%FOUND; /* %FOUND */
         close cfk1_retribuzioni_inail;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RETRIBUZIONI_INAIL. La registrazione di ALIQUOTA_ESENZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ALIQUOTE_ESENZIONE_INAIL_PU */
/

create or replace trigger ALIQUOTE_ESENZIONE_INAIL_TMB
   before INSERT or UPDATE on ALIQUOTE_ESENZIONE_INAIL
for each row
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ALIQUOTE_ESENZIONE_INAIL
 ANNOTAZIONI: Richiama Procedure ALIQUOTE_ESENZIONE_INAIL_PI e ALIQUOTE_ESENZIONE_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         ALIQUOTE_ESENZIONE_INAIL_PI( :NEW.ESENZIONE );
         null;
      end if;
      if UPDATING then
         ALIQUOTE_ESENZIONE_INAIL_PU( :OLD.ESENZIONE
                        , :OLD.ANNO
                        , :NEW.ESENZIONE
                        , :NEW.ANNO );
         null;
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
/* End Trigger: ALIQUOTE_ESENZIONE_INAIL_TMB */
/

create or replace trigger ALIQUOTE_ESENZIONE_INAIL_TB
   before INSERT or UPDATE or DELETE on ALIQUOTE_ESENZIONE_INAIL
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table ALIQUOTE_ESENZIONE_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: ALIQUOTE_ESENZIONE_INAIL_TB */
/

create or replace trigger ALIQUOTE_ESENZIONE_INAIL_TC
   after INSERT or UPDATE or DELETE on ALIQUOTE_ESENZIONE_INAIL
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table ALIQUOTE_ESENZIONE_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: ALIQUOTE_ESENZIONE_INAIL_TC */
/


-- Create Check REFERENTIAL Integrity Procedure on DELETE
create or replace procedure ALIQUOTE_ESENZIONE_INAIL_PD
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table ALIQUOTE_ESENZIONE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ALIQUOTE_ESENZIONE_INAIL_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_esenzione IN varchar
, old_anno IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "RETRIBUZIONI_INAIL"
   cursor cfk1_retribuzioni_inail(var_esenzione varchar,
                   var_anno number) is
      select 1
      from   RETRIBUZIONI_INAIL
      where  ESENZIONE = var_esenzione
       and   ANNO = var_anno
       and   var_esenzione is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "ALIQUOTE_ESENZIONE_INAIL" if children still exist in "RETRIBUZIONI_INAIL"
      open  cfk1_retribuzioni_inail(OLD_ESENZIONE,
                     OLD_ANNO);
      fetch cfk1_retribuzioni_inail into dummy;
      found := cfk1_retribuzioni_inail%FOUND; /* %FOUND */
      close cfk1_retribuzioni_inail;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su RETRIBUZIONI_INAIL. La registrazione di ALIQUOTA_ESENZIONE_INAIL non e'' eliminabile.';
          raise integrity_error;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ALIQUOTE_ESENZIONE_INAIL_PD */
/

create or replace trigger ALIQUOTE_ESENZIONE_INAIL_TDB
   before DELETE on ALIQUOTE_ESENZIONE_INAIL
for each row
/******************************************************************************
 NOME:        ALIQUOTE_ESENZIONE_INAIL_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table ALIQUOTE_ESENZIONE_INAIL
 ANNOTAZIONI: Richiama Procedure ALIQUOTE_ESENZIONE_INAIL_TD
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
   begin  -- Check REFERENTIAL Integrity on DELETE
      ALIQUOTE_ESENZIONE_INAIL_PD( :OLD.ESENZIONE
                   , :OLD.ANNO );
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ALIQUOTE_ESENZIONE_INAIL_TDB */
/

-- Create Check REFERENTIAL Integrity Procedure on INSERT
create or replace procedure ALIQUOTE_INAIL_PI
/******************************************************************************
 NOME:        ALIQUOTE_INAIL_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ALIQUOTE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ALIQUOTE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ALIQUOTE_INAIL_PI */
/
   
-- Create Check REFERENTIAL Integrity Procedure on UPDATE
create or replace procedure ALIQUOTE_INAIL_PU
/******************************************************************************
 NOME:        ALIQUOTE_INAIL_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ALIQUOTE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ALIQUOTE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_posizione_inail IN varchar
, old_anno IN number
, new_posizione_inail IN varchar
, new_anno IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "RETRIBUZIONI_INAIL"
   cursor cfk1_retribuzioni_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   RETRIBUZIONI_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
   --  Declaration of UpdateParentRestrict constraint for "PONDERAZIONE_INAIL"
   cursor cfk2_ponderazione_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   PONDERAZIONE_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "ALIQUOTE_INAIL" non modificabile se esistono referenze su "RETRIBUZIONI_INAIL"
      if (OLD_POSIZIONE_INAIL != NEW_POSIZIONE_INAIL) or
         (OLD_ANNO != NEW_ANNO) then
         open  cfk1_retribuzioni_inail(OLD_POSIZIONE_INAIL,
                        OLD_ANNO);
         fetch cfk1_retribuzioni_inail into dummy;
         found := cfk1_retribuzioni_inail%FOUND; /* %FOUND */
         close cfk1_retribuzioni_inail;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RETRIBUZIONI_INAIL. La registrazione di ALIQUOTE_INAIL non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "ALIQUOTE_INAIL" non modificabile se esistono referenze su "PONDERAZIONE_INAIL"
      if (OLD_POSIZIONE_INAIL != NEW_POSIZIONE_INAIL) or
         (OLD_ANNO != NEW_ANNO) then
         open  cfk2_ponderazione_inail(OLD_POSIZIONE_INAIL,
                        OLD_ANNO);
         fetch cfk2_ponderazione_inail into dummy;
         found := cfk2_ponderazione_inail%FOUND; /* %FOUND */
         close cfk2_ponderazione_inail;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su PONDERAZIONE_INAIL. La registrazione di ALIQUOTE_INAIL non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ALIQUOTE_INAIL_PU */
/

create or replace trigger ALIQUOTE_INAIL_TMB
   before INSERT or UPDATE on ALIQUOTE_INAIL
for each row
/******************************************************************************
 NOME:        ALIQUOTE_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ALIQUOTE_INAIL
 ANNOTAZIONI: Richiama Procedure ALIQUOTE_INAIL_PI e ALIQUOTE_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         null;
      end if;
      if UPDATING then
         ALIQUOTE_INAIL_PU( :OLD.POSIZIONE_INAIL
                        , :OLD.ANNO
                        , :NEW.POSIZIONE_INAIL
                        , :NEW.ANNO );
         null;
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
/* End Trigger: ALIQUOTE_INAIL_TMB */
/

-- Create Check REFERENTIAL Integrity Procedure on DELETE
create or replace procedure ALIQUOTE_INAIL_PD
/******************************************************************************
 NOME:        ALIQUOTE_INAIL_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table ALIQUOTE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ALIQUOTE_INAIL_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_posizione_inail IN varchar
, old_anno IN number )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "RETRIBUZIONI_INAIL"
   cursor cfk1_retribuzioni_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   RETRIBUZIONI_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
   --  Declaration of DeleteParentRestrict constraint for "PONDERAZIONE_INAIL"
   cursor cfk2_ponderazione_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   PONDERAZIONE_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "ALIQUOTE_INAIL" if children still exist in "RETRIBUZIONI_INAIL"
      open  cfk1_retribuzioni_inail(OLD_POSIZIONE_INAIL,
                     OLD_ANNO);
      fetch cfk1_retribuzioni_inail into dummy;
      found := cfk1_retribuzioni_inail%FOUND; /* %FOUND */
      close cfk1_retribuzioni_inail;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su RETRIBUZIONI_INAIL. La registrazione di ALIQUOTE_INAIL non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "ALIQUOTE_INAIL" if children still exist in "PONDERAZIONE_INAIL"
      open  cfk2_ponderazione_inail(OLD_POSIZIONE_INAIL,
                     OLD_ANNO);
      fetch cfk2_ponderazione_inail into dummy;
      found := cfk2_ponderazione_inail%FOUND; /* %FOUND */
      close cfk2_ponderazione_inail;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su PONDERAZIONE_INAIL. La registrazione di ALIQUOTE_INAIL non e'' eliminabile.';
          raise integrity_error;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ALIQUOTE_INAIL_PD */
/

create or replace trigger ALIQUOTE_INAIL_TDB
   before DELETE on ALIQUOTE_INAIL
for each row
/******************************************************************************
 NOME:        ALIQUOTE_INAIL_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table ALIQUOTE_INAIL
 ANNOTAZIONI: Richiama Procedure ALIQUOTE_INAIL_TD
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
   begin  -- Check REFERENTIAL Integrity on DELETE
      ALIQUOTE_INAIL_PD( :OLD.POSIZIONE_INAIL
                   , :OLD.ANNO );
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ALIQUOTE_INAIL_TDB */
/

create or replace trigger ALIQUOTE_INAIL_TB
   before INSERT or UPDATE or DELETE on ALIQUOTE_INAIL
/******************************************************************************
 NOME:        ALIQUOTE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table ALIQUOTE_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: ALIQUOTE_INAIL_TB */
/

create or replace trigger ALIQUOTE_INAIL_TC
   after INSERT or UPDATE or DELETE on ALIQUOTE_INAIL
/******************************************************************************
 NOME:        ALIQUOTE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table ALIQUOTE_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: ALIQUOTE_INAIL_TC */
/



create or replace trigger CALCOLI_RETRIBUZIONI_INAIL_TMB
   before INSERT or UPDATE on CALCOLI_RETRIBUZIONI_INAIL
for each row
/******************************************************************************
 NOME:        CALCOLI_RETRIBUZIONI_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table CALCOLI_RETRIBUZIONI_INAIL
 ANNOTAZIONI: Richiama Procedure CALCOLI_RETRIBUZIONI_INAIL_PI e CALCOLI_RETRIBUZIONI_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         null;
      end if;
      if UPDATING then
         null;
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
/* End Trigger: CALCOLI_RETRIBUZIONI_INAIL_TMB */
/


create or replace trigger CALCOLI_RETRIBUZIONI_INAIL_TB
   before INSERT or UPDATE or DELETE on CALCOLI_RETRIBUZIONI_INAIL
/******************************************************************************
 NOME:        CALCOLI_RETRIBUZIONI_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table CALCOLI_RETRIBUZIONI_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: CALCOLI_RETRIBUZIONI_INAIL_TB */
/

create or replace trigger CALCOLI_RETRIBUZIONI_INAIL_TC
   after INSERT or UPDATE or DELETE on CALCOLI_RETRIBUZIONI_INAIL
/******************************************************************************
 NOME:        CALCOLI_RETRIBUZIONI_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table CALCOLI_RETRIBUZIONI_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: CALCOLI_RETRIBUZIONI_INAIL_TC */
/


-- Create Check REFERENTIAL Integrity Procedure on INSERT
create or replace procedure ESENZIONI_INAIL_PI
/******************************************************************************
 NOME:        ESENZIONI_INAIL_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ESENZIONI_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ESENZIONI_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ESENZIONI_INAIL_PI */
/
   
-- Create Check REFERENTIAL Integrity Procedure on UPDATE
create or replace procedure ESENZIONI_INAIL_PU
/******************************************************************************
 NOME:        ESENZIONI_INAIL_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ESENZIONI_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ESENZIONI_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_esenzione IN varchar
, new_esenzione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "ALIQUOTE_ESENZIONE_INAIL"
   cursor cfk1_aliquote_esenzione_inail(var_esenzione varchar) is
      select 1
      from   ALIQUOTE_ESENZIONE_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
   --  Declaration of UpdateParentRestrict constraint for "RIGHE_ESENZIONE_INAIL"
   cursor cfk2_righe_esenzione_inail(var_esenzione varchar) is
      select 1
      from   RIGHE_ESENZIONE_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "ESENZIONI_INAIL" non modificabile se esistono referenze su "ALIQUOTE_ESENZIONE_INAIL"
      if (OLD_ESENZIONE != NEW_ESENZIONE) then
         open  cfk1_aliquote_esenzione_inail(OLD_ESENZIONE);
         fetch cfk1_aliquote_esenzione_inail into dummy;
         found := cfk1_aliquote_esenzione_inail%FOUND; /* %FOUND */
         close cfk1_aliquote_esenzione_inail;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su ALIQUOTA_ESENZIONE_INAIL. La registrazione di ESENZIONI_INAIL non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "ESENZIONI_INAIL" non modificabile se esistono referenze su "RIGHE_ESENZIONE_INAIL"
      if (OLD_ESENZIONE != NEW_ESENZIONE) then
         open  cfk2_righe_esenzione_inail(OLD_ESENZIONE);
         fetch cfk2_righe_esenzione_inail into dummy;
         found := cfk2_righe_esenzione_inail%FOUND; /* %FOUND */
         close cfk2_righe_esenzione_inail;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RIGHE_ESENZIONE_INAIL. La registrazione di ESENZIONI_INAIL non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ESENZIONI_INAIL_PU */
/

create or replace trigger ESENZIONI_INAIL_TMB
   before INSERT or UPDATE on ESENZIONI_INAIL
for each row
/******************************************************************************
 NOME:        ESENZIONI_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ESENZIONI_INAIL
 ANNOTAZIONI: Richiama Procedure ESENZIONI_INAIL_PI e ESENZIONI_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         null;
      end if;
      if UPDATING then
         ESENZIONI_INAIL_PU( :OLD.ESENZIONE
                        , :NEW.ESENZIONE );
         null;
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
/* End Trigger: ESENZIONI_INAIL_TMB */
/

-- Create Check REFERENTIAL Integrity Procedure on DELETE
create or replace procedure ESENZIONI_INAIL_PD
/******************************************************************************
 NOME:        ESENZIONI_INAIL_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table ESENZIONI_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ESENZIONI_INAIL_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_esenzione IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ALIQUOTE_ESENZIONE_INAIL"
   cursor cfk1_aliquote_esenzione_inail(var_esenzione varchar) is
      select 1
      from   ALIQUOTE_ESENZIONE_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
   --  Declaration of DeleteParentRestrict constraint for "RIGHE_ESENZIONE_INAIL"
   cursor cfk2_righe_esenzione_inail(var_esenzione varchar) is
      select 1
      from   RIGHE_ESENZIONE_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "ESENZIONI_INAIL" if children still exist in "ALIQUOTE_ESENZIONE_INAIL"
      open  cfk1_aliquote_esenzione_inail(OLD_ESENZIONE);
      fetch cfk1_aliquote_esenzione_inail into dummy;
      found := cfk1_aliquote_esenzione_inail%FOUND; /* %FOUND */
      close cfk1_aliquote_esenzione_inail;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su ALIQUOTA_ESENZIONE_INAIL. La registrazione di ESENZIONI_INAIL non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "ESENZIONI_INAIL" if children still exist in "RIGHE_ESENZIONE_INAIL"
      open  cfk2_righe_esenzione_inail(OLD_ESENZIONE);
      fetch cfk2_righe_esenzione_inail into dummy;
      found := cfk2_righe_esenzione_inail%FOUND; /* %FOUND */
      close cfk2_righe_esenzione_inail;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su RIGHE_ESENZIONE_INAIL. La registrazione di ESENZIONI_INAIL non e'' eliminabile.';
          raise integrity_error;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: ESENZIONI_INAIL_PD */
/

create or replace trigger ESENZIONI_INAIL_TDB
   before DELETE on ESENZIONI_INAIL
for each row
/******************************************************************************
 NOME:        ESENZIONI_INAIL_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table ESENZIONI_INAIL
 ANNOTAZIONI: Richiama Procedure ESENZIONI_INAIL_TD
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
   begin  -- Check REFERENTIAL Integrity on DELETE
      ESENZIONI_INAIL_PD( :OLD.ESENZIONE );
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ESENZIONI_INAIL_TDB */
/

create or replace trigger ESENZIONI_INAIL_TB
   before INSERT or UPDATE or DELETE on ESENZIONI_INAIL
/******************************************************************************
 NOME:        ESENZIONI_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table ESENZIONI_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: ESENZIONI_INAIL_TB */
/

create or replace trigger ESENZIONI_INAIL_TC
   after INSERT or UPDATE or DELETE on ESENZIONI_INAIL
/******************************************************************************
 NOME:        ESENZIONI_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table ESENZIONI_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: ESENZIONI_INAIL_TC */
/


/*==============================================================*/
/* DBMS name:      ORACLE 8 for SI4 (Rev.4-NH)                  */
/* Created on:     31/12/2003 10.40.08                          */
/*==============================================================*/



create or replace trigger PONDERAZIONE_INAIL_TIU
   before INSERT or UPDATE on PONDERAZIONE_INAIL
for each row
/******************************************************************************
 NOME:        PONDERAZIONE_INAIL_TIU
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check UNIQUE Integrity on PK
                          Set FUNCTIONAL Integrity
                       at INSERT or UPDATE on Table PONDERAZIONE_INAIL
 ECCEZIONI:  -20007, Identificazione CHIAVE presente in TABLE
 ANNOTAZIONI: -  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
    0 __/__/____ __     
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity
      begin  -- Check UNIQUE Integrity on PK of "PONDERAZIONE_INAIL"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_ponderazione_inail(var_POSIZIONE_INAIL varchar,
                            var_ANNO number,
                            var_VOCE_RISCHIO varchar) is
               select 1
                 from   PONDERAZIONE_INAIL
                where  POSIZIONE_INAIL = var_POSIZIONE_INAIL and
                       ANNO = var_ANNO and
                       VOCE_RISCHIO = var_VOCE_RISCHIO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.POSIZIONE_INAIL is not null and
                  :new.ANNO is not null and
                  :new.VOCE_RISCHIO is not null then
                  open  cpk_ponderazione_inail(:new.POSIZIONE_INAIL,
                                 :new.ANNO,
                                 :new.VOCE_RISCHIO);
                  fetch cpk_ponderazione_inail into dummy;
                  found := cpk_ponderazione_inail%FOUND;
                  close cpk_ponderazione_inail;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.POSIZIONE_INAIL||' '||
                               :new.ANNO||' '||
                               :new.VOCE_RISCHIO||
                               '" gia'' presente in PONDERAZIONE_INAIL. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
   end;
   begin  -- Set FUNCTIONAL Integrity
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: PONDERAZIONE_INAIL_TIU */
/

-- Create Check REFERENTIAL Integrity Procedure on INSERT
create or replace procedure PONDERAZIONE_INAIL_PI
/******************************************************************************
 NOME:        PONDERAZIONE_INAIL_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table PONDERAZIONE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger PONDERAZIONE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_posizione_inail IN varchar
, new_anno IN number
, new_voce_rischio IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "VOCI_RISCHIO_INAIL"
   cursor cpk1_ponderazione_inail(var_voce_rischio varchar) is
      select 1
      from   VOCI_RISCHIO_INAIL
      where  VOCE_RISCHIO = var_voce_rischio
       and   var_voce_rischio is not null;
   --  Declaration of InsertChildParentExist constraint for the parent "ASSICURAZIONI_INAIL"
   cursor cpk2_ponderazione_inail(var_posizione_inail varchar) is
      select 1
      from   ASSICURAZIONI_INAIL
      where  CODICE = var_posizione_inail
       and   var_posizione_inail is not null;
   --  Declaration of InsertChildParentExist constraint for the parent "ALIQUOTE_INAIL"
   cursor cpk3_ponderazione_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   ALIQUOTE_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "VOCI_RISCHIO_INAIL" deve esistere quando si inserisce su "PONDERAZIONE_INAIL"
         if NEW_VOCE_RISCHIO is not null then
            open  cpk1_ponderazione_inail(NEW_VOCE_RISCHIO);
            fetch cpk1_ponderazione_inail into dummy;
            found := cpk1_ponderazione_inail%FOUND; /* %FOUND */
            close cpk1_ponderazione_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su VOCI_RISCHIO_INAIL. La registrazione PONDERAZIONE_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ASSICURAZIONI_INAIL" deve esistere quando si inserisce su "PONDERAZIONE_INAIL"
         if NEW_POSIZIONE_INAIL is not null then
            open  cpk2_ponderazione_inail(NEW_POSIZIONE_INAIL);
            fetch cpk2_ponderazione_inail into dummy;
            found := cpk2_ponderazione_inail%FOUND; /* %FOUND */
            close cpk2_ponderazione_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ASSICURAZIONI_INAIL. La registrazione PONDERAZIONE_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ALIQUOTE_INAIL" deve esistere quando si inserisce su "PONDERAZIONE_INAIL"
         if NEW_POSIZIONE_INAIL is not null and
            NEW_ANNO is not null then
            open  cpk3_ponderazione_inail(NEW_POSIZIONE_INAIL,
                           NEW_ANNO);
            fetch cpk3_ponderazione_inail into dummy;
            found := cpk3_ponderazione_inail%FOUND; /* %FOUND */
            close cpk3_ponderazione_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ALIQUOTE_INAIL. La registrazione PONDERAZIONE_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: PONDERAZIONE_INAIL_PI */
/
   
-- Create Check REFERENTIAL Integrity Procedure on UPDATE
create or replace procedure PONDERAZIONE_INAIL_PU
/******************************************************************************
 NOME:        PONDERAZIONE_INAIL_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table PONDERAZIONE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger PONDERAZIONE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_posizione_inail IN varchar
, old_anno IN number
, old_voce_rischio IN varchar
, new_posizione_inail IN varchar
, new_anno IN number
, new_voce_rischio IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "VOCI_RISCHIO_INAIL"
   cursor cpk1_ponderazione_inail(var_voce_rischio varchar) is
      select 1
      from   VOCI_RISCHIO_INAIL
      where  VOCE_RISCHIO = var_voce_rischio
       and   var_voce_rischio is not null;
   --  Declaration of UpdateChildParentExist constraint for the parent "ASSICURAZIONI_INAIL"
   cursor cpk2_ponderazione_inail(var_posizione_inail varchar) is
      select 1
      from   ASSICURAZIONI_INAIL
      where  CODICE = var_posizione_inail
       and   var_posizione_inail is not null;
   --  Declaration of UpdateChildParentExist constraint for the parent "ALIQUOTE_INAIL"
   cursor cpk3_ponderazione_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   ALIQUOTE_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "VOCI_RISCHIO_INAIL" deve esistere quando si modifica "PONDERAZIONE_INAIL"
         if  NEW_VOCE_RISCHIO is not null and ( seq = 0 )
         and (   (NEW_VOCE_RISCHIO != OLD_VOCE_RISCHIO or OLD_VOCE_RISCHIO is null) ) then
            open  cpk1_ponderazione_inail(NEW_VOCE_RISCHIO);
            fetch cpk1_ponderazione_inail into dummy;
            found := cpk1_ponderazione_inail%FOUND; /* %FOUND */
            close cpk1_ponderazione_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su VOCI_RISCHIO_INAIL. La registrazione PONDERAZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ASSICURAZIONI_INAIL" deve esistere quando si modifica "PONDERAZIONE_INAIL"
         if  NEW_POSIZIONE_INAIL is not null and ( seq = 0 )
         and (   (NEW_POSIZIONE_INAIL != OLD_POSIZIONE_INAIL or OLD_POSIZIONE_INAIL is null) ) then
            open  cpk2_ponderazione_inail(NEW_POSIZIONE_INAIL);
            fetch cpk2_ponderazione_inail into dummy;
            found := cpk2_ponderazione_inail%FOUND; /* %FOUND */
            close cpk2_ponderazione_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ASSICURAZIONI_INAIL. La registrazione PONDERAZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ALIQUOTE_INAIL" deve esistere quando si modifica "PONDERAZIONE_INAIL"
         if  NEW_POSIZIONE_INAIL is not null and
             NEW_ANNO is not null and ( seq = 0 )
         and (   (NEW_POSIZIONE_INAIL != OLD_POSIZIONE_INAIL or OLD_POSIZIONE_INAIL is null)
              or (NEW_ANNO != OLD_ANNO or OLD_ANNO is null) ) then
            open  cpk3_ponderazione_inail(NEW_POSIZIONE_INAIL,
                           NEW_ANNO);
            fetch cpk3_ponderazione_inail into dummy;
            found := cpk3_ponderazione_inail%FOUND; /* %FOUND */
            close cpk3_ponderazione_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ALIQUOTE_INAIL. La registrazione PONDERAZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: PONDERAZIONE_INAIL_PU */
/

create or replace trigger PONDERAZIONE_INAIL_TMB
   before INSERT or UPDATE on PONDERAZIONE_INAIL
for each row
/******************************************************************************
 NOME:        PONDERAZIONE_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table PONDERAZIONE_INAIL
 ANNOTAZIONI: Richiama Procedure PONDERAZIONE_INAIL_PI e PONDERAZIONE_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         PONDERAZIONE_INAIL_PI( :NEW.POSIZIONE_INAIL
                        , :NEW.ANNO
                        , :NEW.VOCE_RISCHIO );
         null;
      end if;
      if UPDATING then
         PONDERAZIONE_INAIL_PU( :OLD.POSIZIONE_INAIL
                        , :OLD.ANNO
                        , :OLD.VOCE_RISCHIO
                        , :NEW.POSIZIONE_INAIL
                        , :NEW.ANNO
                        , :NEW.VOCE_RISCHIO );
         null;
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
/* End Trigger: PONDERAZIONE_INAIL_TMB */
/

create or replace trigger PONDERAZIONE_INAIL_TB
   before INSERT or UPDATE or DELETE on PONDERAZIONE_INAIL
/******************************************************************************
 NOME:        PONDERAZIONE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table PONDERAZIONE_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: PONDERAZIONE_INAIL_TB */
/

create or replace trigger PONDERAZIONE_INAIL_TC
   after INSERT or UPDATE or DELETE on PONDERAZIONE_INAIL
/******************************************************************************
 NOME:        PONDERAZIONE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table PONDERAZIONE_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: PONDERAZIONE_INAIL_TC */
/

create or replace trigger RETRIBUZIONI_INAIL_TIU
   before INSERT or UPDATE on RETRIBUZIONI_INAIL
for each row
/******************************************************************************
 NOME:        RETRIBUZIONI_INAIL_TIU
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check UNIQUE Integrity on PK
                          Set FUNCTIONAL Integrity
                       at INSERT or UPDATE on Table RETRIBUZIONI_INAIL
 ECCEZIONI:  -20007, Identificazione CHIAVE presente in TABLE
 ANNOTAZIONI: -  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
    0 __/__/____ __     
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity
      begin  -- Check UNIQUE Integrity on PK of "RETRIBUZIONI_INAIL"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_retribuzioni_inail(var_IMIN_ID number) is
               select 1
                 from   RETRIBUZIONI_INAIL
                where  IMIN_ID = var_IMIN_ID;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.IMIN_ID is not null then
                  open  cpk_retribuzioni_inail(:new.IMIN_ID);
                  fetch cpk_retribuzioni_inail into dummy;
                  found := cpk_retribuzioni_inail%FOUND;
                  close cpk_retribuzioni_inail;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.IMIN_ID||
                               '" gia'' presente in RETRIBUZIONI_INAIL. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
   end;
   begin  -- Set FUNCTIONAL Integrity
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: RETRIBUZIONI_INAIL_TIU */
/

-- Create Check REFERENTIAL Integrity Procedure on INSERT
create or replace procedure RETRIBUZIONI_INAIL_PI
/******************************************************************************
 NOME:        RETRIBUZIONI_INAIL_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table RETRIBUZIONI_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger RETRIBUZIONI_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_anno IN number
, new_posizione_inail IN varchar
, new_esenzione IN varchar
, new_funzionale IN varchar
, new_cdc IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "ALIQUOTE_INAIL"
   cursor cpk1_retribuzioni_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   ALIQUOTE_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
   --  Declaration of InsertChildParentExist constraint for the parent "CENTRI_COSTO"
   cursor cpk2_retribuzioni_inail(var_cdc varchar) is
      select 1
      from   CENTRI_COSTO
      where  CODICE = var_cdc
       and   var_cdc is not null;
   --  Declaration of InsertChildParentExist constraint for the parent "CLASSIFICAZIONI_FUNZIONALI"
   cursor cpk3_retribuzioni_inail(var_funzionale varchar) is
      select 1
      from   CLASSIFICAZIONI_FUNZIONALI
      where  CODICE = var_funzionale
       and   var_funzionale is not null;
   --  Declaration of InsertChildParentExist constraint for the parent "ALIQUOTE_ESENZIONE_INAIL"
   cursor cpk4_retribuzioni_inail(var_esenzione varchar,
                   var_anno number) is
      select 1
      from   ALIQUOTE_ESENZIONE_INAIL
      where  ESENZIONE = var_esenzione
       and   ANNO = var_anno
       and   var_esenzione is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ALIQUOTE_INAIL" deve esistere quando si inserisce su "RETRIBUZIONI_INAIL"
         if NEW_POSIZIONE_INAIL is not null and
            NEW_ANNO is not null then
            open  cpk1_retribuzioni_inail(NEW_POSIZIONE_INAIL,
                           NEW_ANNO);
            fetch cpk1_retribuzioni_inail into dummy;
            found := cpk1_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk1_retribuzioni_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ALIQUOTE_INAIL. La registrazione RETRIBUZIONI_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "CENTRI_COSTO" deve esistere quando si inserisce su "RETRIBUZIONI_INAIL"
         if NEW_CDC is not null then
            open  cpk2_retribuzioni_inail(NEW_CDC);
            fetch cpk2_retribuzioni_inail into dummy;
            found := cpk2_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk2_retribuzioni_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su CENTRI_COSTO. La registrazione RETRIBUZIONI_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "CLASSIFICAZIONI_FUNZIONALI" deve esistere quando si inserisce su "RETRIBUZIONI_INAIL"
         if NEW_FUNZIONALE is not null then
            open  cpk3_retribuzioni_inail(NEW_FUNZIONALE);
            fetch cpk3_retribuzioni_inail into dummy;
            found := cpk3_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk3_retribuzioni_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su CLASSIFICAZIONI_FUNZIONALI. La registrazione RETRIBUZIONI_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ALIQUOTE_ESENZIONE_INAIL" deve esistere quando si inserisce su "RETRIBUZIONI_INAIL"
         if NEW_ESENZIONE is not null and
            NEW_ANNO is not null then
            open  cpk4_retribuzioni_inail(NEW_ESENZIONE,
                           NEW_ANNO);
            fetch cpk4_retribuzioni_inail into dummy;
            found := cpk4_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk4_retribuzioni_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ALIQUOTA_ESENZIONE_INAIL. La registrazione RETRIBUZIONI_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: RETRIBUZIONI_INAIL_PI */
/
   
-- Create Check REFERENTIAL Integrity Procedure on UPDATE
create or replace procedure RETRIBUZIONI_INAIL_PU
/******************************************************************************
 NOME:        RETRIBUZIONI_INAIL_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table RETRIBUZIONI_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RETRIBUZIONI_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_imin_id IN number
, old_anno IN number
, old_posizione_inail IN varchar
, old_esenzione IN varchar
, old_funzionale IN varchar
, old_cdc IN varchar
, new_imin_id IN number
, new_anno IN number
, new_posizione_inail IN varchar
, new_esenzione IN varchar
, new_funzionale IN varchar
, new_cdc IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "ALIQUOTE_INAIL"
   cursor cpk1_retribuzioni_inail(var_posizione_inail varchar,
                   var_anno number) is
      select 1
      from   ALIQUOTE_INAIL
      where  POSIZIONE_INAIL = var_posizione_inail
       and   ANNO = var_anno
       and   var_posizione_inail is not null
       and   var_anno is not null;
   --  Declaration of UpdateChildParentExist constraint for the parent "CENTRI_COSTO"
   cursor cpk2_retribuzioni_inail(var_cdc varchar) is
      select 1
      from   CENTRI_COSTO
      where  CODICE = var_cdc
       and   var_cdc is not null;
   --  Declaration of UpdateChildParentExist constraint for the parent "CLASSIFICAZIONI_FUNZIONALI"
   cursor cpk3_retribuzioni_inail(var_funzionale varchar) is
      select 1
      from   CLASSIFICAZIONI_FUNZIONALI
      where  CODICE = var_funzionale
       and   var_funzionale is not null;
   --  Declaration of UpdateChildParentExist constraint for the parent "ALIQUOTE_ESENZIONE_INAIL"
   cursor cpk4_retribuzioni_inail(var_esenzione varchar,
                   var_anno number) is
      select 1
      from   ALIQUOTE_ESENZIONE_INAIL
      where  ESENZIONE = var_esenzione
       and   ANNO = var_anno
       and   var_esenzione is not null
       and   var_anno is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ALIQUOTE_INAIL" deve esistere quando si modifica "RETRIBUZIONI_INAIL"
         if  NEW_POSIZIONE_INAIL is not null and
             NEW_ANNO is not null and ( seq = 0 )
         and (   (NEW_POSIZIONE_INAIL != OLD_POSIZIONE_INAIL or OLD_POSIZIONE_INAIL is null)
              or (NEW_ANNO != OLD_ANNO or OLD_ANNO is null) ) then
            open  cpk1_retribuzioni_inail(NEW_POSIZIONE_INAIL,
                           NEW_ANNO);
            fetch cpk1_retribuzioni_inail into dummy;
            found := cpk1_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk1_retribuzioni_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ALIQUOTE_INAIL. La registrazione RETRIBUZIONI_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "CENTRI_COSTO" deve esistere quando si modifica "RETRIBUZIONI_INAIL"
         if  NEW_CDC is not null and ( seq = 0 )
         and (   (NEW_CDC != OLD_CDC or OLD_CDC is null) ) then
            open  cpk2_retribuzioni_inail(NEW_CDC);
            fetch cpk2_retribuzioni_inail into dummy;
            found := cpk2_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk2_retribuzioni_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su CENTRI_COSTO. La registrazione RETRIBUZIONI_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "CLASSIFICAZIONI_FUNZIONALI" deve esistere quando si modifica "RETRIBUZIONI_INAIL"
         if  NEW_FUNZIONALE is not null and ( seq = 0 )
         and (   (NEW_FUNZIONALE != OLD_FUNZIONALE or OLD_FUNZIONALE is null) ) then
            open  cpk3_retribuzioni_inail(NEW_FUNZIONALE);
            fetch cpk3_retribuzioni_inail into dummy;
            found := cpk3_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk3_retribuzioni_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su CLASSIFICAZIONI_FUNZIONALI. La registrazione RETRIBUZIONI_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ALIQUOTE_ESENZIONE_INAIL" deve esistere quando si modifica "RETRIBUZIONI_INAIL"
         if  NEW_ESENZIONE is not null and
             NEW_ANNO is not null and ( seq = 0 )
         and (   (NEW_ESENZIONE != OLD_ESENZIONE or OLD_ESENZIONE is null)
              or (NEW_ANNO != OLD_ANNO or OLD_ANNO is null) ) then
            open  cpk4_retribuzioni_inail(NEW_ESENZIONE,
                           NEW_ANNO);
            fetch cpk4_retribuzioni_inail into dummy;
            found := cpk4_retribuzioni_inail%FOUND; /* %FOUND */
            close cpk4_retribuzioni_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ALIQUOTA_ESENZIONE_INAIL. La registrazione RETRIBUZIONI_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: RETRIBUZIONI_INAIL_PU */
/

create or replace trigger RETRIBUZIONI_INAIL_TMB
   before INSERT or UPDATE on RETRIBUZIONI_INAIL
for each row
/******************************************************************************
 NOME:        RETRIBUZIONI_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table RETRIBUZIONI_INAIL
 ANNOTAZIONI: Richiama Procedure RETRIBUZIONI_INAIL_PI e RETRIBUZIONI_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         RETRIBUZIONI_INAIL_PI( :NEW.ANNO
                        , :NEW.POSIZIONE_INAIL
                        , :NEW.ESENZIONE
                        , :NEW.FUNZIONALE
                        , :NEW.CDC );
         null;
      end if;
      if UPDATING then
         RETRIBUZIONI_INAIL_PU( :OLD.IMIN_ID
                        , :OLD.ANNO
                        , :OLD.POSIZIONE_INAIL
                        , :OLD.ESENZIONE
                        , :OLD.FUNZIONALE
                        , :OLD.CDC
                        , :NEW.IMIN_ID
                        , :NEW.ANNO
                        , :NEW.POSIZIONE_INAIL
                        , :NEW.ESENZIONE
                        , :NEW.FUNZIONALE
                        , :NEW.CDC );
         null;
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
/* End Trigger: RETRIBUZIONI_INAIL_TMB */
/

create or replace trigger RETRIBUZIONI_INAIL_TB
   before INSERT or UPDATE or DELETE on RETRIBUZIONI_INAIL
/******************************************************************************
 NOME:        RETRIBUZIONI_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table RETRIBUZIONI_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: RETRIBUZIONI_INAIL_TB */
/

create or replace trigger RETRIBUZIONI_INAIL_TC
   after INSERT or UPDATE or DELETE on RETRIBUZIONI_INAIL
/******************************************************************************
 NOME:        RETRIBUZIONI_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table RETRIBUZIONI_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: RETRIBUZIONI_INAIL_TC */
/


create or replace trigger RIGHE_ESENZIONE_INAIL_TIU
   before INSERT or UPDATE on RIGHE_ESENZIONE_INAIL
for each row
/******************************************************************************
 NOME:        RIGHE_ESENZIONE_INAIL_TIU
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check UNIQUE Integrity on PK
                          Set FUNCTIONAL Integrity
                       at INSERT or UPDATE on Table RIGHE_ESENZIONE_INAIL
 ECCEZIONI:  -20007, Identificazione CHIAVE presente in TABLE
 ANNOTAZIONI: -  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
    0 __/__/____ __     
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity
      begin  -- Check UNIQUE Integrity on PK of "RIGHE_ESENZIONE_INAIL"
         if IntegrityPackage.GetNestLevel = 0 and not DELETING then
            declare
            cursor cpk_righe_esenzione_inail(var_ESIN_ID number) is
               select 1
                 from   RIGHE_ESENZIONE_INAIL
                where  ESIN_ID = var_ESIN_ID;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin 
               if :new.ESIN_ID is not null then
                  open  cpk_righe_esenzione_inail(:new.ESIN_ID);
                  fetch cpk_righe_esenzione_inail into dummy;
                  found := cpk_righe_esenzione_inail%FOUND;
                  close cpk_righe_esenzione_inail;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.ESIN_ID||
                               '" gia'' presente in RIGHE_ESENZIONE_INAIL. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end;
      null;
   end;
   begin  -- Set FUNCTIONAL Integrity
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: RIGHE_ESENZIONE_INAIL_TIU */
/

-- Create Check REFERENTIAL Integrity Procedure on INSERT
create or replace procedure RIGHE_ESENZIONE_INAIL_PI
/******************************************************************************
 NOME:        RIGHE_ESENZIONE_INAIL_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table RIGHE_ESENZIONE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger RIGHE_ESENZIONE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( new_esenzione IN varchar
, new_posizione IN varchar
, new_trattamento IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of InsertChildParentExist constraint for the parent "TRATTAMENTI_PREVIDENZIALI"
   cursor cpk1_righe_esenzione_inail(var_trattamento varchar) is
      select 1
      from   TRATTAMENTI_PREVIDENZIALI
      where  CODICE = var_trattamento
       and   var_trattamento is not null;
   --  Declaration of InsertChildParentExist constraint for the parent "POSIZIONI"
   cursor cpk2_righe_esenzione_inail(var_posizione varchar) is
      select 1
      from   POSIZIONI
      where  CODICE = var_posizione
       and   var_posizione is not null;
   --  Declaration of InsertChildParentExist constraint for the parent "ESENZIONI_INAIL"
   cursor cpk3_righe_esenzione_inail(var_esenzione varchar) is
      select 1
      from   ESENZIONI_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "TRATTAMENTI_PREVIDENZIALI" deve esistere quando si inserisce su "RIGHE_ESENZIONE_INAIL"
         if NEW_TRATTAMENTO is not null then
            open  cpk1_righe_esenzione_inail(NEW_TRATTAMENTO);
            fetch cpk1_righe_esenzione_inail into dummy;
            found := cpk1_righe_esenzione_inail%FOUND; /* %FOUND */
            close cpk1_righe_esenzione_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su TRATTAMENTI_PREVIDENZIALI. La registrazione RIGHE_ESENZIONE_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "POSIZIONI" deve esistere quando si inserisce su "RIGHE_ESENZIONE_INAIL"
         if NEW_POSIZIONE is not null then
            open  cpk2_righe_esenzione_inail(NEW_POSIZIONE);
            fetch cpk2_righe_esenzione_inail into dummy;
            found := cpk2_righe_esenzione_inail%FOUND; /* %FOUND */
            close cpk2_righe_esenzione_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su POSIZIONI. La registrazione RIGHE_ESENZIONE_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ESENZIONI_INAIL" deve esistere quando si inserisce su "RIGHE_ESENZIONE_INAIL"
         if NEW_ESENZIONE is not null then
            open  cpk3_righe_esenzione_inail(NEW_ESENZIONE);
            fetch cpk3_righe_esenzione_inail into dummy;
            found := cpk3_righe_esenzione_inail%FOUND; /* %FOUND */
            close cpk3_righe_esenzione_inail;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ESENZIONI_INAIL. La registrazione RIGHE_ESENZIONE_INAIL non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: RIGHE_ESENZIONE_INAIL_PI */
/
   
-- Create Check REFERENTIAL Integrity Procedure on UPDATE
create or replace procedure RIGHE_ESENZIONE_INAIL_PU
/******************************************************************************
 NOME:        RIGHE_ESENZIONE_INAIL_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table RIGHE_ESENZIONE_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RIGHE_ESENZIONE_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_esin_id IN number
, old_esenzione IN varchar
, old_posizione IN varchar
, old_trattamento IN varchar
, new_esin_id IN number
, new_esenzione IN varchar
, new_posizione IN varchar
, new_trattamento IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateChildParentExist constraint for the parent "TRATTAMENTI_PREVIDENZIALI"
   cursor cpk1_righe_esenzione_inail(var_trattamento varchar) is
      select 1
      from   TRATTAMENTI_PREVIDENZIALI
      where  CODICE = var_trattamento
       and   var_trattamento is not null;
   --  Declaration of UpdateChildParentExist constraint for the parent "POSIZIONI"
   cursor cpk2_righe_esenzione_inail(var_posizione varchar) is
      select 1
      from   POSIZIONI
      where  CODICE = var_posizione
       and   var_posizione is not null;
   --  Declaration of UpdateChildParentExist constraint for the parent "ESENZIONI_INAIL"
   cursor cpk3_righe_esenzione_inail(var_esenzione varchar) is
      select 1
      from   ESENZIONI_INAIL
      where  ESENZIONE = var_esenzione
       and   var_esenzione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "TRATTAMENTI_PREVIDENZIALI" deve esistere quando si modifica "RIGHE_ESENZIONE_INAIL"
         if  NEW_TRATTAMENTO is not null and ( seq = 0 )
         and (   (NEW_TRATTAMENTO != OLD_TRATTAMENTO or OLD_TRATTAMENTO is null) ) then
            open  cpk1_righe_esenzione_inail(NEW_TRATTAMENTO);
            fetch cpk1_righe_esenzione_inail into dummy;
            found := cpk1_righe_esenzione_inail%FOUND; /* %FOUND */
            close cpk1_righe_esenzione_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su TRATTAMENTI_PREVIDENZIALI. La registrazione RIGHE_ESENZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "POSIZIONI" deve esistere quando si modifica "RIGHE_ESENZIONE_INAIL"
         if  NEW_POSIZIONE is not null and ( seq = 0 )
         and (   (NEW_POSIZIONE != OLD_POSIZIONE or OLD_POSIZIONE is null) ) then
            open  cpk2_righe_esenzione_inail(NEW_POSIZIONE);
            fetch cpk2_righe_esenzione_inail into dummy;
            found := cpk2_righe_esenzione_inail%FOUND; /* %FOUND */
            close cpk2_righe_esenzione_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su POSIZIONI. La registrazione RIGHE_ESENZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ESENZIONI_INAIL" deve esistere quando si modifica "RIGHE_ESENZIONE_INAIL"
         if  NEW_ESENZIONE is not null and ( seq = 0 )
         and (   (NEW_ESENZIONE != OLD_ESENZIONE or OLD_ESENZIONE is null) ) then
            open  cpk3_righe_esenzione_inail(NEW_ESENZIONE);
            fetch cpk3_righe_esenzione_inail into dummy;
            found := cpk3_righe_esenzione_inail%FOUND; /* %FOUND */
            close cpk3_righe_esenzione_inail;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ESENZIONI_INAIL. La registrazione RIGHE_ESENZIONE_INAIL non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: RIGHE_ESENZIONE_INAIL_PU */
/

create or replace trigger RIGHE_ESENZIONE_INAIL_TMB
   before INSERT or UPDATE on RIGHE_ESENZIONE_INAIL
for each row
/******************************************************************************
 NOME:        RIGHE_ESENZIONE_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table RIGHE_ESENZIONE_INAIL
 ANNOTAZIONI: Richiama Procedure RIGHE_ESENZIONE_INAIL_PI e RIGHE_ESENZIONE_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         RIGHE_ESENZIONE_INAIL_PI( :NEW.ESENZIONE
                        , :NEW.POSIZIONE
                        , :NEW.TRATTAMENTO );
         null;
      end if;
      if UPDATING then
         RIGHE_ESENZIONE_INAIL_PU( :OLD.ESIN_ID
                        , :OLD.ESENZIONE
                        , :OLD.POSIZIONE
                        , :OLD.TRATTAMENTO
                        , :NEW.ESIN_ID
                        , :NEW.ESENZIONE
                        , :NEW.POSIZIONE
                        , :NEW.TRATTAMENTO );
         null;
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
/* End Trigger: RIGHE_ESENZIONE_INAIL_TMB */
/

create or replace trigger RIGHE_ESENZIONE_INAIL_TB
   before INSERT or UPDATE or DELETE on RIGHE_ESENZIONE_INAIL
/******************************************************************************
 NOME:        RIGHE_ESENZIONE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table RIGHE_ESENZIONE_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: RIGHE_ESENZIONE_INAIL_TB */
/

create or replace trigger RIGHE_ESENZIONE_INAIL_TC
   after INSERT or UPDATE or DELETE on RIGHE_ESENZIONE_INAIL
/******************************************************************************
 NOME:        RIGHE_ESENZIONE_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table RIGHE_ESENZIONE_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: RIGHE_ESENZIONE_INAIL_TC */
/


-- Create Check REFERENTIAL Integrity Procedure on INSERT
create or replace procedure VOCI_RISCHIO_INAIL_PI
/******************************************************************************
 NOME:        VOCI_RISCHIO_INAIL_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table VOCI_RISCHIO_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger VOCI_RISCHIO_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check REFERENTIAL Integrity
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: VOCI_RISCHIO_INAIL_PI */
/
   
-- Create Check REFERENTIAL Integrity Procedure on UPDATE
create or replace procedure VOCI_RISCHIO_INAIL_PU
/******************************************************************************
 NOME:        VOCI_RISCHIO_INAIL_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table VOCI_RISCHIO_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger VOCI_RISCHIO_INAIL_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_voce_rischio IN varchar
, new_voce_rischio IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "PONDERAZIONE_INAIL"
   cursor cfk1_ponderazione_inail(var_voce_rischio varchar) is
      select 1
      from   PONDERAZIONE_INAIL
      where  VOCE_RISCHIO = var_voce_rischio
       and   var_voce_rischio is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "VOCI_RISCHIO_INAIL" non modificabile se esistono referenze su "PONDERAZIONE_INAIL"
      if (OLD_VOCE_RISCHIO != NEW_VOCE_RISCHIO) then
         open  cfk1_ponderazione_inail(OLD_VOCE_RISCHIO);
         fetch cfk1_ponderazione_inail into dummy;
         found := cfk1_ponderazione_inail%FOUND; /* %FOUND */
         close cfk1_ponderazione_inail;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su PONDERAZIONE_INAIL. La registrazione di VOCI_RISCHIO_INAIL non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: VOCI_RISCHIO_INAIL_PU */
/

create or replace trigger VOCI_RISCHIO_INAIL_TMB
   before INSERT or UPDATE on VOCI_RISCHIO_INAIL
for each row
/******************************************************************************
 NOME:        VOCI_RISCHIO_INAIL_TMB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table VOCI_RISCHIO_INAIL
 ANNOTAZIONI: Richiama Procedure VOCI_RISCHIO_INAIL_PI e VOCI_RISCHIO_INAIL_PU
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
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if INSERTING then
         null;
      end if;
      if UPDATING then
         VOCI_RISCHIO_INAIL_PU( :OLD.VOCE_RISCHIO
                        , :NEW.VOCE_RISCHIO );
         null;
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
/* End Trigger: VOCI_RISCHIO_INAIL_TMB */
/

-- Create Check REFERENTIAL Integrity Procedure on DELETE
create or replace procedure VOCI_RISCHIO_INAIL_PD
/******************************************************************************
 NOME:        VOCI_RISCHIO_INAIL_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table VOCI_RISCHIO_INAIL
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger VOCI_RISCHIO_INAIL_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
( old_voce_rischio IN varchar )
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "PONDERAZIONE_INAIL"
   cursor cfk1_ponderazione_inail(var_voce_rischio varchar) is
      select 1
      from   PONDERAZIONE_INAIL
      where  VOCE_RISCHIO = var_voce_rischio
       and   var_voce_rischio is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "VOCI_RISCHIO_INAIL" if children still exist in "PONDERAZIONE_INAIL"
      open  cfk1_ponderazione_inail(OLD_VOCE_RISCHIO);
      fetch cfk1_ponderazione_inail into dummy;
      found := cfk1_ponderazione_inail%FOUND; /* %FOUND */
      close cfk1_ponderazione_inail;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su PONDERAZIONE_INAIL. La registrazione di VOCI_RISCHIO_INAIL non e'' eliminabile.';
          raise integrity_error;
      end if;
      null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Procedure: VOCI_RISCHIO_INAIL_PD */
/

create or replace trigger VOCI_RISCHIO_INAIL_TDB
   before DELETE on VOCI_RISCHIO_INAIL
for each row
/******************************************************************************
 NOME:        VOCI_RISCHIO_INAIL_TDB
 DESCRIZIONE: Trigger for Check REFERENTIAL Integrity
                       at DELETE on Table VOCI_RISCHIO_INAIL
 ANNOTAZIONI: Richiama Procedure VOCI_RISCHIO_INAIL_TD
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
   begin  -- Check REFERENTIAL Integrity on DELETE
      VOCI_RISCHIO_INAIL_PD( :OLD.VOCE_RISCHIO );
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: VOCI_RISCHIO_INAIL_TDB */
/

create or replace trigger VOCI_RISCHIO_INAIL_TB
   before INSERT or UPDATE or DELETE on VOCI_RISCHIO_INAIL
/******************************************************************************
 NOME:        VOCI_RISCHIO_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table VOCI_RISCHIO_INAIL
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: VOCI_RISCHIO_INAIL_TB */
/

create or replace trigger VOCI_RISCHIO_INAIL_TC
   after INSERT or UPDATE or DELETE on VOCI_RISCHIO_INAIL
/******************************************************************************
 NOME:        VOCI_RISCHIO_INAIL_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table VOCI_RISCHIO_INAIL

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: VOCI_RISCHIO_INAIL_TC */
/

