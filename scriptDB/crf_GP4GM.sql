/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     17/06/2003 15.05.37                          */
/*==============================================================*/

create or replace procedure AMMINISTRAZIONI_PI
/******************************************************************************
 NOME:        AMMINISTRAZIONI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table AMMINISTRAZIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger AMMINISTRAZIONI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ni IN number,
 new_gruppo IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk1_amministrazioni(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "GRUPPI_AMMINISTRAZIONI"
   cursor cpk2_amministrazioni(var_gruppo varchar) is
      select 1
      from   GRUPPI_AMMINISTRAZIONI
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "AMMINISTRAZIONI"
         if NEW_NI is not null then
            open  cpk1_amministrazioni(NEW_NI);
            fetch cpk1_amministrazioni into dummy;
            found := cpk1_amministrazioni%FOUND; /* %FOUND */
            close cpk1_amministrazioni;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Amministrazioni non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GRUPPI_AMMINISTRAZIONI" deve esistere quando si inserisce su "AMMINISTRAZIONI"
         if NEW_GRUPPO is not null then
            open  cpk2_amministrazioni(NEW_GRUPPO);
            fetch cpk2_amministrazioni into dummy;
            found := cpk2_amministrazioni%FOUND; /* %FOUND */
            close cpk2_amministrazioni;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Gruppi Amministrazioni. La registrazione Amministrazioni non puo'' essere inserita.';
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
/* End Procedure: AMMINISTRAZIONI_PI */
/
create or replace procedure AMMINISTRAZIONI_PU
/******************************************************************************
 NOME:        AMMINISTRAZIONI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table AMMINISTRAZIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AMMINISTRAZIONI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_codice_amministrazione IN varchar
 , old_dal IN date
 , old_ni IN number
 , old_gruppo IN varchar
 , new_codice_amministrazione IN varchar
 , new_dal IN date
 , new_ni IN number
 , new_gruppo IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk1_amministrazioni(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "GRUPPI_AMMINISTRAZIONI"
   cursor cpk2_amministrazioni(var_gruppo varchar) is
      select 1
      from   GRUPPI_AMMINISTRAZIONI
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  AMM_DAL = var_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_dal is not null
       and   var_codice_amministrazione is not null;
   --  Declaration of UpdateParentRestrict constraint for "AOO"
   cursor cfk2_aoo(var_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AOO
      where  AMM_DAL = var_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_dal is not null
       and   var_codice_amministrazione is not null;
   --  Declaration of UpdateParentRestrict constraint for "COMPONENTI"
   cursor cfk3_componenti(var_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   COMPONENTI
      where  AMM_DAL = var_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_dal is not null
       and   var_codice_amministrazione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "AMMINISTRAZIONI"
         if  NEW_NI is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null) ) then
            open  cpk1_amministrazioni(NEW_NI);
            fetch cpk1_amministrazioni into dummy;
            found := cpk1_amministrazioni%FOUND; /* %FOUND */
            close cpk1_amministrazioni;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Amministrazioni non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GRUPPI_AMMINISTRAZIONI" deve esistere quando si modifica "AMMINISTRAZIONI"
         if  NEW_GRUPPO is not null and ( seq = 0 )
         and (   (NEW_GRUPPO != OLD_GRUPPO or OLD_GRUPPO is null) ) then
            open  cpk2_amministrazioni(NEW_GRUPPO);
            fetch cpk2_amministrazioni into dummy;
            found := cpk2_amministrazioni%FOUND; /* %FOUND */
            close cpk2_amministrazioni;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Gruppi Amministrazioni. La registrazione Amministrazioni non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if (OLD_CODICE_AMMINISTRAZIONE != NEW_CODICE_AMMINISTRAZIONE) or
         (OLD_DAL != NEW_DAL) then
         open  cfk1_unita_organizzative(OLD_DAL,
                        OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk1_unita_organizzative into dummy;
         found := cfk1_unita_organizzative%FOUND; /* %FOUND */
         close cfk1_unita_organizzative;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Amministrazioni non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "AOO"
      if (OLD_CODICE_AMMINISTRAZIONE != NEW_CODICE_AMMINISTRAZIONE) or
         (OLD_DAL != NEW_DAL) then
         open  cfk2_aoo(OLD_DAL,
                        OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk2_aoo into dummy;
         found := cfk2_aoo%FOUND; /* %FOUND */
         close cfk2_aoo;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su AOO. La registrazione di Amministrazioni non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "AMMINISTRAZIONI" non modificabile se esistono referenze su "COMPONENTI"
      if (OLD_CODICE_AMMINISTRAZIONE != NEW_CODICE_AMMINISTRAZIONE) or
         (OLD_DAL != NEW_DAL) then
         open  cfk3_componenti(OLD_DAL,
                        OLD_CODICE_AMMINISTRAZIONE);
         fetch cfk3_componenti into dummy;
         found := cfk3_componenti%FOUND; /* %FOUND */
         close cfk3_componenti;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Componenti. La registrazione di Amministrazioni non e'' modificabile.';
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
/* End Procedure: AMMINISTRAZIONI_PU */
/
create or replace trigger AMMINISTRAZIONI_TMB
   before INSERT or UPDATE on AMMINISTRAZIONI
for each row
/******************************************************************************
 NOME:        AMMINISTRAZIONI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table AMMINISTRAZIONI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure AMMINISTRAZIONI_PI e AMMINISTRAZIONI_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         AMMINISTRAZIONI_PU(:OLD.CODICE_AMMINISTRAZIONE
                       , :OLD.DAL
                       , :OLD.NI
                       , :OLD.GRUPPO
                         , :NEW.CODICE_AMMINISTRAZIONE
                         , :NEW.DAL
                         , :NEW.NI
                         , :NEW.GRUPPO
                         );
         null;
      end if;
      if INSERTING then
         AMMINISTRAZIONI_PI(:NEW.NI,
                         :NEW.GRUPPO);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "AMMINISTRAZIONI"
            cursor cpk_amministrazioni(var_CODICE_AMMINISTRAZIONE varchar,
                            var_DAL date) is
               select 1
                 from   AMMINISTRAZIONI
                where  CODICE_AMMINISTRAZIONE = var_CODICE_AMMINISTRAZIONE and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "AMMINISTRAZIONI"
               if :new.CODICE_AMMINISTRAZIONE is not null and
                  :new.DAL is not null then
                  open  cpk_amministrazioni(:new.CODICE_AMMINISTRAZIONE,
                                 :new.DAL);
                  fetch cpk_amministrazioni into dummy;
                  found := cpk_amministrazioni%FOUND;
                  close cpk_amministrazioni;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.CODICE_AMMINISTRAZIONE||' '||
                               :new.DAL||
                               '" gia'' presente in Amministrazioni. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: AMMINISTRAZIONI_TMB */
/
create or replace procedure AMMINISTRAZIONI_PD
/******************************************************************************
 NOME:        AMMINISTRAZIONI_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table AMMINISTRAZIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AMMINISTRAZIONI_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_codice_amministrazione IN varchar,
 old_dal IN date)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  AMM_DAL = var_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_dal is not null
       and   var_codice_amministrazione is not null;
   --  Declaration of DeleteParentRestrict constraint for "AOO"
   cursor cfk2_aoo(var_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AOO
      where  AMM_DAL = var_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_dal is not null
       and   var_codice_amministrazione is not null;
   --  Declaration of DeleteParentRestrict constraint for "COMPONENTI"
   cursor cfk3_componenti(var_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   COMPONENTI
      where  AMM_DAL = var_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_dal is not null
       and   var_codice_amministrazione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk1_unita_organizzative(OLD_DAL,
                     OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk1_unita_organizzative into dummy;
      found := cfk1_unita_organizzative%FOUND; /* %FOUND */
      close cfk1_unita_organizzative;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Amministrazioni non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "AOO"
      open  cfk2_aoo(OLD_DAL,
                     OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk2_aoo into dummy;
      found := cfk2_aoo%FOUND; /* %FOUND */
      close cfk2_aoo;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su AOO. La registrazione di Amministrazioni non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "AMMINISTRAZIONI" if children still exist in "COMPONENTI"
      open  cfk3_componenti(OLD_DAL,
                     OLD_CODICE_AMMINISTRAZIONE);
      fetch cfk3_componenti into dummy;
      found := cfk3_componenti%FOUND; /* %FOUND */
      close cfk3_componenti;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Componenti. La registrazione di Amministrazioni non e'' eliminabile.';
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
/* End Procedure: AMMINISTRAZIONI_PD */
/
create or replace trigger AMMINISTRAZIONI_TDB
   before DELETE on AMMINISTRAZIONI
for each row
/******************************************************************************
 NOME:        AMMINISTRAZIONI_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table AMMINISTRAZIONI
 ANNOTAZIONI: Richiama Procedure AMMINISTRAZIONI_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      AMMINISTRAZIONI_PD(:OLD.CODICE_AMMINISTRAZIONE,
                    :OLD.DAL);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: AMMINISTRAZIONI_TDB */
/

create or replace procedure ANAGRAFICI_PI
/******************************************************************************
 NOME:        ANAGRAFICI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ANAGRAFICI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ANAGRAFICI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_tipo_soggetto IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "TIPI_SOGGETTO"
   cursor cpk1_anagrafici(var_tipo_soggetto varchar) is
      select 1
      from   TIPI_SOGGETTO
      where  TIPO_SOGGETTO = var_tipo_soggetto
       and   var_tipo_soggetto is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "TIPI_SOGGETTO" deve esistere quando si inserisce su "ANAGRAFICI"
         if NEW_TIPO_SOGGETTO is not null then
            open  cpk1_anagrafici(NEW_TIPO_SOGGETTO);
            fetch cpk1_anagrafici into dummy;
            found := cpk1_anagrafici%FOUND; /* %FOUND */
            close cpk1_anagrafici;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Tipi Soggetto. La registrazione Anagrafici (ANAGRAFE_SOGGETTI) non puo'' essere inserita.';
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
/* End Procedure: ANAGRAFICI_PI */
/

create or replace procedure ANAGRAFICI_PU
/******************************************************************************
 NOME:        ANAGRAFICI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ANAGRAFICI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ANAGRAFICI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_ni IN number
 , old_dal IN date
 , old_tipo_soggetto IN varchar
 , new_ni IN number
 , new_dal IN date
 , new_tipo_soggetto IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "TIPI_SOGGETTO"
   cursor cpk1_anagrafici(var_tipo_soggetto varchar) is
      select 1
      from   TIPI_SOGGETTO
      where  TIPO_SOGGETTO = var_tipo_soggetto
       and   var_tipo_soggetto is not null;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ni number) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  SEDE = var_ni
       and   var_ni is not null;
   --  Declaration of UpdateParentRestrict constraint for "DATI_ANAGRAFICI"
   cursor cfk2_dati_anagrafici(var_ni number,
                   var_dal date) is
      select 1
      from   DATI_ANAGRAFICI
      where  NI = var_ni
       and   DAL = var_dal
       and   var_ni is not null
       and   var_dal is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "TIPI_SOGGETTO" deve esistere quando si modifica "ANAGRAFICI"
         if  NEW_TIPO_SOGGETTO is not null and ( seq = 0 )
         and (   (NEW_TIPO_SOGGETTO != OLD_TIPO_SOGGETTO or OLD_TIPO_SOGGETTO is null) ) then
            open  cpk1_anagrafici(NEW_TIPO_SOGGETTO);
            fetch cpk1_anagrafici into dummy;
            found := cpk1_anagrafici%FOUND; /* %FOUND */
            close cpk1_anagrafici;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Tipi Soggetto. La registrazione Anagrafici (ANAGRAFE_SOGGETTI) non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "ANAGRAFICI" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if (OLD_NI != NEW_NI) or
         (OLD_DAL != NEW_DAL) then
         open  cfk1_unita_organizzative(OLD_NI);
         fetch cfk1_unita_organizzative into dummy;
         found := cfk1_unita_organizzative%FOUND; /* %FOUND */
         close cfk1_unita_organizzative;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Anagrafici (ANAGRAFE_SOGGETTI) non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "ANAGRAFICI" non modificabile se esistono referenze su "DATI_ANAGRAFICI"
      if (OLD_NI != NEW_NI) or
         (OLD_DAL != NEW_DAL) then
         open  cfk2_dati_anagrafici(OLD_NI,
                        OLD_DAL);
         fetch cfk2_dati_anagrafici into dummy;
         found := cfk2_dati_anagrafici%FOUND; /* %FOUND */
         close cfk2_dati_anagrafici;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su DATI_ANAGRAFICI (ANAGRAFICI). La registrazione di Anagrafici (ANAGRAFE_SOGGETTI) non e'' modificabile.';
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
/* End Procedure: ANAGRAFICI_PU */
/

create or replace trigger ANAGRAFICI_TMB
   before INSERT or UPDATE on ANAGRAFICI
for each row
/******************************************************************************
 NOME:        ANAGRAFICI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ANAGRAFICI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure ANAGRAFICI_PI e ANAGRAFICI_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         ANAGRAFICI_PU(:OLD.NI
                       , :OLD.DAL
                       , :OLD.TIPO_SOGGETTO
                         , :NEW.NI
                         , :NEW.DAL
                         , :NEW.TIPO_SOGGETTO
                         );
         null;
      end if;
      if INSERTING then
         ANAGRAFICI_PI(:NEW.TIPO_SOGGETTO);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "ANAGRAFICI"
            cursor cpk_anagrafici(var_NI number,
                            var_DAL date) is
               select 1
                 from   ANAGRAFICI
                where  NI = var_NI and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "ANAGRAFICI"
               if :new.NI is not null and
                  :new.DAL is not null then
                  open  cpk_anagrafici(:new.NI,
                                 :new.DAL);
                  fetch cpk_anagrafici into dummy;
                  found := cpk_anagrafici%FOUND;
                  close cpk_anagrafici;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.NI||' '||
                               :new.DAL||
                               '" gia'' presente in Anagrafici (ANAGRAFE_SOGGETTI). La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: ANAGRAFICI_TMB */
/

create or replace procedure ANAGRAFICI_PD
/******************************************************************************
 NOME:        ANAGRAFICI_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table ANAGRAFICI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ANAGRAFICI_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_ni IN number,
 old_dal IN date)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ni number) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  SEDE = var_ni
       and   var_ni is not null;
   --  Declaration of DeleteParentRestrict constraint for "DATI_ANAGRAFICI"
   cursor cfk2_dati_anagrafici(var_ni number,
                   var_dal date) is
      select 1
      from   DATI_ANAGRAFICI
      where  NI = var_ni
       and   DAL = var_dal
       and   var_ni is not null
       and   var_dal is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "ANAGRAFICI" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk1_unita_organizzative(OLD_NI);
      fetch cfk1_unita_organizzative into dummy;
      found := cfk1_unita_organizzative%FOUND; /* %FOUND */
      close cfk1_unita_organizzative;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Anagrafici (ANAGRAFE_SOGGETTI) non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "ANAGRAFICI" if children still exist in "DATI_ANAGRAFICI"
      open  cfk2_dati_anagrafici(OLD_NI,
                     OLD_DAL);
      fetch cfk2_dati_anagrafici into dummy;
      found := cfk2_dati_anagrafici%FOUND; /* %FOUND */
      close cfk2_dati_anagrafici;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su DATI_ANAGRAFICI (ANAGRAFICI). La registrazione di Anagrafici (ANAGRAFE_SOGGETTI) non e'' eliminabile.';
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
/* End Procedure: ANAGRAFICI_PD */
/

create or replace trigger ANAGRAFICI_TDB
   before DELETE on ANAGRAFICI
for each row
/******************************************************************************
 NOME:        ANAGRAFICI_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table ANAGRAFICI
 ANNOTAZIONI: Richiama Procedure ANAGRAFICI_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      ANAGRAFICI_PD(:OLD.NI,
                    :OLD.DAL);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANAGRAFICI_TDB */
/

create or replace procedure AOO_PI
/******************************************************************************
 NOME:        AOO_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table AOO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger AOO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_codice_amministrazione IN varchar,
 new_amm_dal IN date,
 new_ni IN number,
 new_gruppo IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk1_aoo(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "AMMINISTRAZIONI"
   cursor cpk2_aoo(var_amm_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  DAL = var_amm_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_amm_dal is not null
       and   var_codice_amministrazione is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "GRUPPI_AMMINISTRAZIONI"
   cursor cpk3_aoo(var_gruppo varchar) is
      select 1
      from   GRUPPI_AMMINISTRAZIONI
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "AOO"
         if NEW_NI is not null then
            open  cpk1_aoo(NEW_NI);
            fetch cpk1_aoo into dummy;
            found := cpk1_aoo%FOUND; /* %FOUND */
            close cpk1_aoo;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione AOO non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si inserisce su "AOO"
         if NEW_AMM_DAL is not null and
            NEW_CODICE_AMMINISTRAZIONE is not null then
            open  cpk2_aoo(NEW_AMM_DAL,
                           NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk2_aoo into dummy;
            found := cpk2_aoo%FOUND; /* %FOUND */
            close cpk2_aoo;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione AOO non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GRUPPI_AMMINISTRAZIONI" deve esistere quando si inserisce su "AOO"
         if NEW_GRUPPO is not null then
            open  cpk3_aoo(NEW_GRUPPO);
            fetch cpk3_aoo into dummy;
            found := cpk3_aoo%FOUND; /* %FOUND */
            close cpk3_aoo;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Gruppi Amministrazioni. La registrazione AOO non puo'' essere inserita.';
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
/* End Procedure: AOO_PI */
/
create or replace procedure AOO_PU
/******************************************************************************
 NOME:        AOO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table AOO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AOO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_codice_amministrazione IN varchar
 , old_amm_dal IN date
 , old_codice_aoo IN varchar
 , old_dal IN date
 , old_ni IN number
 , old_gruppo IN varchar
 , new_codice_amministrazione IN varchar
 , new_amm_dal IN date
 , new_codice_aoo IN varchar
 , new_dal IN date
 , new_ni IN number
 , new_gruppo IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk1_aoo(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "AMMINISTRAZIONI"
   cursor cpk2_aoo(var_amm_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  DAL = var_amm_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_amm_dal is not null
       and   var_codice_amministrazione is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "GRUPPI_AMMINISTRAZIONI"
   cursor cpk3_aoo(var_gruppo varchar) is
      select 1
      from   GRUPPI_AMMINISTRAZIONI
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_codice_amministrazione varchar,
                   var_amm_dal date,
                   var_codice_aoo varchar,
                   var_dal date) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   AMM_DAL = var_amm_dal
       and   CODICE_AOO = var_codice_aoo
       and   AOO_DAL = var_dal
       and   var_codice_amministrazione is not null
       and   var_amm_dal is not null
       and   var_codice_aoo is not null
       and   var_dal is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "AOO"
         if  NEW_NI is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null) ) then
            open  cpk1_aoo(NEW_NI);
            fetch cpk1_aoo into dummy;
            found := cpk1_aoo%FOUND; /* %FOUND */
            close cpk1_aoo;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione AOO non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "AOO"
         if  NEW_AMM_DAL is not null and
             NEW_CODICE_AMMINISTRAZIONE is not null and ( seq = 0 )
         and (   (NEW_AMM_DAL != OLD_AMM_DAL or OLD_AMM_DAL is null)
              or (NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE or OLD_CODICE_AMMINISTRAZIONE is null) ) then
            open  cpk2_aoo(NEW_AMM_DAL,
                           NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk2_aoo into dummy;
            found := cpk2_aoo%FOUND; /* %FOUND */
            close cpk2_aoo;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione AOO non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GRUPPI_AMMINISTRAZIONI" deve esistere quando si modifica "AOO"
         if  NEW_GRUPPO is not null and ( seq = 0 )
         and (   (NEW_GRUPPO != OLD_GRUPPO or OLD_GRUPPO is null) ) then
            open  cpk3_aoo(NEW_GRUPPO);
            fetch cpk3_aoo into dummy;
            found := cpk3_aoo%FOUND; /* %FOUND */
            close cpk3_aoo;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Gruppi Amministrazioni. La registrazione AOO non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "AOO" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if (OLD_CODICE_AMMINISTRAZIONE != NEW_CODICE_AMMINISTRAZIONE) or
         (OLD_AMM_DAL != NEW_AMM_DAL) or
         (OLD_CODICE_AOO != NEW_CODICE_AOO) or
         (OLD_DAL != NEW_DAL) then
         open  cfk1_unita_organizzative(OLD_CODICE_AMMINISTRAZIONE,
                        OLD_AMM_DAL,
                        OLD_CODICE_AOO,
                        OLD_DAL);
         fetch cfk1_unita_organizzative into dummy;
         found := cfk1_unita_organizzative%FOUND; /* %FOUND */
         close cfk1_unita_organizzative;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di AOO non e'' modificabile.';
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
/* End Procedure: AOO_PU */
/
create or replace trigger AOO_TMB
   before INSERT or UPDATE on AOO
for each row
/******************************************************************************
 NOME:        AOO_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table AOO
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure AOO_PI e AOO_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         AOO_PU(:OLD.CODICE_AMMINISTRAZIONE
                       , :OLD.AMM_DAL
                       , :OLD.CODICE_AOO
                       , :OLD.DAL
                       , :OLD.NI
                       , :OLD.GRUPPO
                         , :NEW.CODICE_AMMINISTRAZIONE
                         , :NEW.AMM_DAL
                         , :NEW.CODICE_AOO
                         , :NEW.DAL
                         , :NEW.NI
                         , :NEW.GRUPPO
                         );
         null;
      end if;
      if INSERTING then
         AOO_PI(:NEW.CODICE_AMMINISTRAZIONE,
                         :NEW.AMM_DAL,
                         :NEW.NI,
                         :NEW.GRUPPO);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "AOO"
            cursor cpk_aoo(var_CODICE_AMMINISTRAZIONE varchar,
                            var_AMM_DAL date,
                            var_CODICE_AOO varchar,
                            var_DAL date) is
               select 1
                 from   AOO
                where  CODICE_AMMINISTRAZIONE = var_CODICE_AMMINISTRAZIONE and
                       AMM_DAL = var_AMM_DAL and
                       CODICE_AOO = var_CODICE_AOO and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "AOO"
               if :new.CODICE_AMMINISTRAZIONE is not null and
                  :new.AMM_DAL is not null and
                  :new.CODICE_AOO is not null and
                  :new.DAL is not null then
                  open  cpk_aoo(:new.CODICE_AMMINISTRAZIONE,
                                 :new.AMM_DAL,
                                 :new.CODICE_AOO,
                                 :new.DAL);
                  fetch cpk_aoo into dummy;
                  found := cpk_aoo%FOUND;
                  close cpk_aoo;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.CODICE_AMMINISTRAZIONE||' '||
                               :new.AMM_DAL||' '||
                               :new.CODICE_AOO||' '||
                               :new.DAL||
                               '" gia'' presente in AOO. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: AOO_TMB */
/
create or replace procedure AOO_PD
/******************************************************************************
 NOME:        AOO_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table AOO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AOO_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_codice_amministrazione IN varchar,
 old_amm_dal IN date,
 old_codice_aoo IN varchar,
 old_dal IN date)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_codice_amministrazione varchar,
                   var_amm_dal date,
                   var_codice_aoo varchar,
                   var_dal date) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   AMM_DAL = var_amm_dal
       and   CODICE_AOO = var_codice_aoo
       and   AOO_DAL = var_dal
       and   var_codice_amministrazione is not null
       and   var_amm_dal is not null
       and   var_codice_aoo is not null
       and   var_dal is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "AOO" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk1_unita_organizzative(OLD_CODICE_AMMINISTRAZIONE,
                     OLD_AMM_DAL,
                     OLD_CODICE_AOO,
                     OLD_DAL);
      fetch cfk1_unita_organizzative into dummy;
      found := cfk1_unita_organizzative%FOUND; /* %FOUND */
      close cfk1_unita_organizzative;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di AOO non e'' eliminabile.';
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
/* End Procedure: AOO_PD */
/
create or replace trigger AOO_TDB
   before DELETE on AOO
for each row
/******************************************************************************
 NOME:        AOO_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table AOO
 ANNOTAZIONI: Richiama Procedure AOO_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      AOO_PD(:OLD.CODICE_AMMINISTRAZIONE,
                    :OLD.AMM_DAL,
                    :OLD.CODICE_AOO,
                    :OLD.DAL);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: AOO_TDB */
/
create or replace trigger COMPONENTI_TC
   after INSERT or UPDATE or DELETE on COMPONENTI
/******************************************************************************
 NOME:        COMPONENTI_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table COMPONENTI

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    __/__/____ __     Prima emissione.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: COMPONENTI_TC */
/
create or replace trigger COMPONENTI_TB
   before INSERT or UPDATE or DELETE on COMPONENTI
/******************************************************************************
 NOME:        COMPONENTI_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table COMPONENTI
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    __/__/____ __     Prima emissione.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: COMPONENTI_TB */
/
create or replace trigger COMPONENTI_TMA
   after INSERT or UPDATE on COMPONENTI
for each row
/******************************************************************************
 NOME:        COMPONENTI_TMA
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                       at INSERT or UPDATE on Table COMPONENTI
 
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
   begin -- Set FUNCTIONAL Integrity 
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   DECLARE a_istruzione  varchar2(2000);
           a1  varchar2(2000);
		   a2  varchar2(2000);
           a_messaggio   varchar2(2000);
           d_dal         varchar2(12);
           d_al          varchar2(12);
           d_dal_n       number;
           d_al_n        number;
   BEGIN
      --
      -- Controllo di univocita del responsabile per una Unita Organizzativa
      --
      d_dal := ''''||:NEW.dal||'''';
      d_al  := ''''||:NEW.al||'''';
	  d_dal_n := to_number(to_char(:NEW.dal,'j'));
	  d_al_n  := nvl(to_number(to_char(:NEW.al,'j')),3333333);
	  a_istruzione := 'select 0 from componenti x where unita_ni = '||:NEW.unita_ni||
	                  ' and dal<=nvl(to_date('||d_al_n||',''j''),to_date(3333333,''j'')) '||
					  ' and nvl(al,to_date(3333333,''j''))>=to_date('||d_dal_n||',''j'')'||
					  ' and unita_ottica = ''GP4'''||
					  ' and exists (select 1 from tipi_incarico tiin where tiin.incarico=x.incarico and responsabile=''SI'')'||
                      ' and ni <> '||:NEW.ni||
					  ' and exists (select 1 from tipi_incarico tiin where tiin.incarico='''||:NEW.incarico||''' and responsabile=''SI'')';
a1:=substr(a_istruzione,1,250);
a2:=substr(a_istruzione,251,250);
dbms_output.put_line(a1);
dbms_output.put_line(a2);
      a_messaggio := si4.get_error('P08004');
      IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
   END;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: COMPONENTI_TMA */
/
create or replace procedure COMPONENTI_PI
/******************************************************************************
 NOME:        COMPONENTI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table COMPONENTI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger COMPONENTI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_codice_amministrazione IN varchar,
 new_amm_dal IN date,
 new_unita_ottica IN varchar,
 new_unita_ni IN number,
 new_unita_dal IN date,
 new_ni IN number,
 new_incarico IN varchar,
 new_titolo IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "UNITA_ORGANIZZATIVE"
   cursor cpk1_componenti(var_unita_ni number,
                   var_unita_ottica varchar,
                   var_unita_dal date) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  NI = var_unita_ni
       and   OTTICA = var_unita_ottica
       and   DAL = var_unita_dal
       and   var_unita_ni is not null
       and   var_unita_ottica is not null
       and   var_unita_dal is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk2_componenti(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "TIPI_INCARICO"
   cursor cpk3_componenti(var_incarico varchar) is
      select 1
      from   TIPI_INCARICO
      where  INCARICO = var_incarico
       and   var_incarico is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "TIPI_TITOLO"
   cursor cpk4_componenti(var_titolo varchar) is
      select 1
      from   TIPI_TITOLO
      where  TITOLO = var_titolo
       and   var_titolo is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "AMMINISTRAZIONI"
   cursor cpk5_componenti(var_amm_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  DAL = var_amm_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_amm_dal is not null
       and   var_codice_amministrazione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "UNITA_ORGANIZZATIVE" deve esistere quando si inserisce su "COMPONENTI"
         if NEW_UNITA_NI is not null and
            NEW_UNITA_OTTICA is not null and
            NEW_UNITA_DAL is not null then
            open  cpk1_componenti(NEW_UNITA_NI,
                           NEW_UNITA_OTTICA,
                           NEW_UNITA_DAL);
            fetch cpk1_componenti into dummy;
            found := cpk1_componenti%FOUND; /* %FOUND */
            close cpk1_componenti;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Unità Organizzative. La registrazione Componenti non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "COMPONENTI"
         if NEW_NI is not null then
            open  cpk2_componenti(NEW_NI);
            fetch cpk2_componenti into dummy;
            found := cpk2_componenti%FOUND; /* %FOUND */
            close cpk2_componenti;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Componenti non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "TIPI_INCARICO" deve esistere quando si inserisce su "COMPONENTI"
         if NEW_INCARICO is not null then
            open  cpk3_componenti(NEW_INCARICO);
            fetch cpk3_componenti into dummy;
            found := cpk3_componenti%FOUND; /* %FOUND */
            close cpk3_componenti;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Tipi Incarico. La registrazione Componenti non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "TIPI_TITOLO" deve esistere quando si inserisce su "COMPONENTI"
         if NEW_TITOLO is not null then
            open  cpk4_componenti(NEW_TITOLO);
            fetch cpk4_componenti into dummy;
            found := cpk4_componenti%FOUND; /* %FOUND */
            close cpk4_componenti;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Tipi Titolo. La registrazione Componenti non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si inserisce su "COMPONENTI"
         if NEW_AMM_DAL is not null and
            NEW_CODICE_AMMINISTRAZIONE is not null then
            open  cpk5_componenti(NEW_AMM_DAL,
                           NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk5_componenti into dummy;
            found := cpk5_componenti%FOUND; /* %FOUND */
            close cpk5_componenti;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Componenti non puo'' essere inserita.';
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
/* End Procedure: COMPONENTI_PI */
/
create or replace procedure COMPONENTI_PU
/******************************************************************************
 NOME:        COMPONENTI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table COMPONENTI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger COMPONENTI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_componente IN number
 , old_dal IN date
 , old_codice_amministrazione IN varchar
 , old_amm_dal IN date
 , old_unita_ottica IN varchar
 , old_unita_ni IN number
 , old_unita_dal IN date
 , old_ni IN number
 , old_incarico IN varchar
 , old_titolo IN varchar
 , new_componente IN number
 , new_dal IN date
 , new_codice_amministrazione IN varchar
 , new_amm_dal IN date
 , new_unita_ottica IN varchar
 , new_unita_ni IN number
 , new_unita_dal IN date
 , new_ni IN number
 , new_incarico IN varchar
 , new_titolo IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk1_componenti(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "TIPI_INCARICO"
   cursor cpk2_componenti(var_incarico varchar) is
      select 1
      from   TIPI_INCARICO
      where  INCARICO = var_incarico
       and   var_incarico is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "TIPI_TITOLO"
   cursor cpk3_componenti(var_titolo varchar) is
      select 1
      from   TIPI_TITOLO
      where  TITOLO = var_titolo
       and   var_titolo is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "AMMINISTRAZIONI"
   cursor cpk4_componenti(var_amm_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  DAL = var_amm_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_amm_dal is not null
       and   var_codice_amministrazione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "COMPONENTI"
         if  NEW_NI is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null) ) then
            open  cpk1_componenti(NEW_NI);
            fetch cpk1_componenti into dummy;
            found := cpk1_componenti%FOUND; /* %FOUND */
            close cpk1_componenti;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Componenti non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "TIPI_INCARICO" deve esistere quando si modifica "COMPONENTI"
         if  NEW_INCARICO is not null and ( seq = 0 )
         and (   (NEW_INCARICO != OLD_INCARICO or OLD_INCARICO is null) ) then
            open  cpk2_componenti(NEW_INCARICO);
            fetch cpk2_componenti into dummy;
            found := cpk2_componenti%FOUND; /* %FOUND */
            close cpk2_componenti;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Tipi Incarico. La registrazione Componenti non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "TIPI_TITOLO" deve esistere quando si modifica "COMPONENTI"
         if  NEW_TITOLO is not null and ( seq = 0 )
         and (   (NEW_TITOLO != OLD_TITOLO or OLD_TITOLO is null) ) then
            open  cpk3_componenti(NEW_TITOLO);
            fetch cpk3_componenti into dummy;
            found := cpk3_componenti%FOUND; /* %FOUND */
            close cpk3_componenti;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Tipi Titolo. La registrazione Componenti non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "COMPONENTI"
         if  NEW_AMM_DAL is not null and
             NEW_CODICE_AMMINISTRAZIONE is not null and ( seq = 0 )
         and (   (NEW_AMM_DAL != OLD_AMM_DAL or OLD_AMM_DAL is null)
              or (NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE or OLD_CODICE_AMMINISTRAZIONE is null) ) then
            open  cpk4_componenti(NEW_AMM_DAL,
                           NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk4_componenti into dummy;
            found := cpk4_componenti%FOUND; /* %FOUND */
            close cpk4_componenti;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Componenti non e'' modificabile.';
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
/* End Procedure: COMPONENTI_PU */
/
create or replace trigger COMPONENTI_TMB
   before INSERT or UPDATE on COMPONENTI
for each row
/******************************************************************************
 NOME:        COMPONENTI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table COMPONENTI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure COMPONENTI_PI e COMPONENTI_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if nvl(:NEW.UTENTE,' ') = nvl(:OLD.UTENTE,' ') then
        :NEW.UTENTE := SI4.UTENTE;
      end if;
      if nvl(:NEW.DATA_AGG,SYSDATE) = nvl(:OLD.DATA_AGG,SYSDATE) then
        :NEW.DATA_AGG := SYSDATE;
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         COMPONENTI_PU(:OLD.COMPONENTE
                       , :OLD.DAL
                       , :OLD.CODICE_AMMINISTRAZIONE
                       , :OLD.AMM_DAL
                       , :OLD.UNITA_OTTICA
                       , :OLD.UNITA_NI
                       , :OLD.UNITA_DAL
                       , :OLD.NI
                       , :OLD.INCARICO
                       , :OLD.TITOLO
                         , :NEW.COMPONENTE
                         , :NEW.DAL
                         , :NEW.CODICE_AMMINISTRAZIONE
                         , :NEW.AMM_DAL
                         , :NEW.UNITA_OTTICA
                         , :NEW.UNITA_NI
                         , :NEW.UNITA_DAL
                         , :NEW.NI
                         , :NEW.INCARICO
                         , :NEW.TITOLO
                         );
         null;
      end if;
	if INSERTING then
         COMPONENTI_PI(:NEW.CODICE_AMMINISTRAZIONE,
                         :NEW.AMM_DAL,
                         :NEW.UNITA_OTTICA,
                         :NEW.UNITA_NI,
                         :NEW.UNITA_DAL,
                         :NEW.NI,
                         :NEW.INCARICO,
                         :NEW.TITOLO);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "COMPONENTI"
            cursor cpk_componenti(var_COMPONENTE number,
                            var_DAL date) is
               select 1
                 from   COMPONENTI
                where  COMPONENTE = var_COMPONENTE and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "COMPONENTI"
               if :new.COMPONENTE is not null and
                  :new.DAL is not null then
                  open  cpk_componenti(:new.COMPONENTE,
                                 :new.DAL);
                  fetch cpk_componenti into dummy;
                  found := cpk_componenti%FOUND;
                  close cpk_componenti;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.COMPONENTE||' '||
                               :new.DAL||
                               '" gia'' presente in Componenti. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: COMPONENTI_TMB */
/
create or replace procedure DATI_ANAGRAFICI_PI
/******************************************************************************
 NOME:        DATI_ANAGRAFICI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table DATI_ANAGRAFICI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger DATI_ANAGRAFICI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ni IN number,
 new_dal IN date)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFICI"
   cursor cpk1_dati_anagrafici(var_ni number,
                   var_dal date) is
      select 1
      from   ANAGRAFICI
      where  NI = var_ni
       and   DAL = var_dal
       and   var_ni is not null
       and   var_dal is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ANAGRAFICI" deve esistere quando si inserisce su "DATI_ANAGRAFICI"
         if NEW_NI is not null and
            NEW_DAL is not null then
            open  cpk1_dati_anagrafici(NEW_NI,
                           NEW_DAL);
            fetch cpk1_dati_anagrafici into dummy;
            found := cpk1_dati_anagrafici%FOUND; /* %FOUND */
            close cpk1_dati_anagrafici;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Anagrafici (ANAGRAFE_SOGGETTI). La registrazione DATI_ANAGRAFICI (ANAGRAFICI) non puo'' essere inserita.';
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
/* End Procedure: DATI_ANAGRAFICI_PI */
/

create or replace procedure DATI_ANAGRAFICI_PU
/******************************************************************************
 NOME:        DATI_ANAGRAFICI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table DATI_ANAGRAFICI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger DATI_ANAGRAFICI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_ni IN number
 , old_dal IN date
 , new_ni IN number
 , new_dal IN date
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFICI"
   cursor cpk1_dati_anagrafici(var_ni number,
                   var_dal date) is
      select 1
      from   ANAGRAFICI
      where  NI = var_ni
       and   DAL = var_dal
       and   var_ni is not null
       and   var_dal is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFICI" deve esistere quando si modifica "DATI_ANAGRAFICI"
         if  NEW_NI is not null and
             NEW_DAL is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null)
              or (NEW_DAL != OLD_DAL or OLD_DAL is null) ) then
            open  cpk1_dati_anagrafici(NEW_NI,
                           NEW_DAL);
            fetch cpk1_dati_anagrafici into dummy;
            found := cpk1_dati_anagrafici%FOUND; /* %FOUND */
            close cpk1_dati_anagrafici;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Anagrafici (ANAGRAFE_SOGGETTI). La registrazione DATI_ANAGRAFICI (ANAGRAFICI) non e'' modificabile.';
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
/* End Procedure: DATI_ANAGRAFICI_PU */
/

create or replace trigger DATI_ANAGRAFICI_TMB
   before INSERT or UPDATE on DATI_ANAGRAFICI
for each row
/******************************************************************************
 NOME:        DATI_ANAGRAFICI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table DATI_ANAGRAFICI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure DATI_ANAGRAFICI_PI e DATI_ANAGRAFICI_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if nvl(:NEW.UTENTE,' ') = nvl(:OLD.UTENTE,' ') then
        :NEW.UTENTE := SI4.UTENTE;
      end if;
      if nvl(:NEW.DATA_AGG,SYSDATE) = nvl(:OLD.DATA_AGG,SYSDATE) then
        :NEW.DATA_AGG := SYSDATE;
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         DATI_ANAGRAFICI_PU(:OLD.NI
                       , :OLD.DAL
                         , :NEW.NI
                         , :NEW.DAL
                         );
         null;
      end if;
	if INSERTING then
         DATI_ANAGRAFICI_PI(:NEW.NI,
                         :NEW.DAL);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "DATI_ANAGRAFICI"
            cursor cpk_dati_anagrafici(var_NI number,
                            var_DAL date) is
               select 1
                 from   DATI_ANAGRAFICI
                where  NI = var_NI and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "DATI_ANAGRAFICI"
               if :new.NI is not null and
                  :new.DAL is not null then
                  open  cpk_dati_anagrafici(:new.NI,
                                 :new.DAL);
                  fetch cpk_dati_anagrafici into dummy;
                  found := cpk_dati_anagrafici%FOUND;
                  close cpk_dati_anagrafici;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.NI||' '||
                               :new.DAL||
                               '" gia'' presente in DATI_ANAGRAFICI (ANAGRAFICI). La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: DATI_ANAGRAFICI_TMB */
/

CREATE OR REPLACE TRIGGER ENTE_TMA
AFTER UPDATE ON ENTE
FOR EACH ROW
begin
if IntegrityPackage.GetNestLevel = 0 then
     IntegrityPackage.NEXTNESTLEVEL; 
     if updating  then
       if (:new.nota_gestione <> :old.nota_gestione) then
	 	   	update SUDDIVISIONI_STRUTTURA
			   set denominazione = :new.nota_gestione
			 where livello = 0;
	   end if;
	   if (:new.nota_settore_a <> :old.nota_settore_a) then
	 	   	update SUDDIVISIONI_STRUTTURA
			   set denominazione = :new.nota_settore_a
			 where livello = 1;
	   end if;
	   if (:new.nota_settore_b <> :old.nota_settore_b) then
	 	   	update SUDDIVISIONI_STRUTTURA
			   set denominazione = :new.nota_settore_b
			 where livello = 2;
	   end if;
	   if (:new.nota_settore_c <> :old.nota_settore_c) then
	 	   	update SUDDIVISIONI_STRUTTURA
			   set denominazione = :new.nota_settore_c
			 where livello = 3;
	   end if;
	   if (:new.nota_settore <> :old.nota_settore) then
	 	   	update SUDDIVISIONI_STRUTTURA
			   set denominazione = :new.nota_settore
			 where livello = 4;
	   end if;
     end if;
     IntegrityPackage.PREVIOUSNESTLEVEL;
end if;
exception
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
   commit;
end;
/
CREATE OR REPLACE TRIGGER GESTIONI_TMA
 AFTER INSERT OR UPDATE OR DELETE ON GESTIONI
FOR EACH ROW
/******************************************************************************
 NOME:        GESTIONI_TMA
 DESCRIZIONE: Allineamento in caso di inserimento nella tabella GESTIONI

 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    16/10/2002 __     Prima emissione.
 1.0  09/11/2006 MS     Mod. insert in anagrafici 
******************************************************************************/
DECLARE
  tmpVar NUMBER;
  dep_ni number;
  dep_revisione number;
  integrity_error  exception;
  errno            integer;
  errmsg           char(200);
  dummy            integer;
  found            boolean;
BEGIN
 IF INSERTING THEN
  BEGIN
      tmpVar := 0;
    /* Determino il numero individuale della nuova Gestione Amministrativa */
      select  indi_sq.nextval
  	  into  dep_ni
  	  from  dual
  	;
    /* Inserisce il soggetto anagrafico della Gestione Amministrativa  */
      insert into anagrafici
             ( NI
              ,COGNOME
              ,DAL
              ,UTENTE
              ,DATA_AGG
              ,DENOMINAZIONE
              ,TIPO_SOGGETTO
             )
      values ( dep_ni
              ,:NEW.nome
              ,to_date('01011900','ddmmyyyy')
              ,'Aut.GP4'
              ,sysdate
              ,:NEW.nome
              ,'S'
             )
      ;
    /* Inserisce la Gestione Amminstrativa */
	 insert into gestioni_amministrative
	       ( CODICE
            ,NI
            ,DENOMINAZIONE
            ,GESTITO
            ,NOTE
            ,UTENTE
            ,DATA_AGG
		   )
	  values
	       ( :NEW.codice
		    ,dep_ni
            ,:NEW.nome
			,:NEW.GESTITO
			,:NEW.note
            ,'Aut.GP4'
            ,sysdate
           )
	 ;
  exception
     when integrity_error then
          IntegrityPackage.InitNestLevel;
          raise_application_error(errno, errmsg);
     when others then
          IntegrityPackage.InitNestLevel;
          raise;
  end;
 END IF; /* fine inserting */
 IF UPDATING THEN
    update gestioni_amministrative
	   set DENOMINAZIONE = :NEW.nome
	     , GESTITO       = :NEW.GESTITO
		 , NOTE          = :NEW.note
		 , UTENTE        = 'Aut.GP4'
		 , DATA_AGG      = sysdate
     where codice        = :NEW.CODICE
	;
 END IF; /* fine updating */
 IF DELETING THEN
    dummy := 0;
    /* Eliminiamo GEAM, STAM, UNOR e ANAG se non esistono altre registrazioni diverse da quelle automatiche */
    BEGIN
      select count(*)
	    into dummy
		from unita_organizzative
	   where ni in
	        (select ni
			   from settori_amministrativi
			  where gestione = :OLD.CODICE
			    and utente  <> 'Aut.GP4'
			)
	  ;
    EXCEPTION WHEN NO_DATA_FOUND THEN dummy := 0;
	END;
	IF dummy = 0 THEN
    	delete from ANAGRAFICI
    	 where ni in
            (select ni
			   from settori_amministrativi
			  where gestione = :OLD.CODICE
			)
		;
    	delete from UNITA_ORGANIZZATIVE
    	 where ni in
            (select ni
			   from settori_amministrativi
			  where gestione = :OLD.CODICE
			)
		;
    	delete from SETTORI_AMMINISTRATIVI
    	 where gestione = :OLD.CODICE
		;
    	delete from GESTIONI_AMMINISTRATIVE
    	 where codice = :OLD.CODICE
		;
     END IF;
 END IF; /* fine deleting */
END GESTIONI_TMA;
/
create or replace procedure GESTIONI_PU
/******************************************************************************
 NOME:        GESTIONI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table GESTIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger GESTIONI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_codice IN varchar
 , new_codice IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "GESTIONI_AMMINISTRATIVE"
   cursor cfk1_gestioni_amministrative(var_codice varchar) is
      select 1
      from   GESTIONI_AMMINISTRATIVE
      where  CODICE = var_codice
       and   var_codice is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "GESTIONI" non modificabile se esistono referenze su "GESTIONI_AMMINISTRATIVE"
      if (OLD_CODICE != NEW_CODICE) then
         open  cfk1_gestioni_amministrative(OLD_CODICE);
         fetch cfk1_gestioni_amministrative into dummy;
         found := cfk1_gestioni_amministrative%FOUND; /* %FOUND */
         close cfk1_gestioni_amministrative;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Gestioni Amministrative. La registrazione di GESTIONI non e'' modificabile.';
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
/* End Procedure: GESTIONI_PU */
/
create or replace trigger GESTIONI_TMB
   before INSERT or UPDATE on GESTIONI
for each row
/******************************************************************************
 NOME:        GESTIONI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table GESTIONI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure GESTIONI_PI e GESTIONI_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         GESTIONI_PU(:OLD.CODICE
                         , :NEW.CODICE
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "GESTIONI"
            cursor cpk_gestioni(var_CODICE varchar) is
               select 1
                 from   GESTIONI
                where  CODICE = var_CODICE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "GESTIONI"
               if :new.CODICE is not null then
                  open  cpk_gestioni(:new.CODICE);
                  fetch cpk_gestioni into dummy;
                  found := cpk_gestioni%FOUND;
                  close cpk_gestioni;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.CODICE||
                               '" gia'' presente in GESTIONI. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: GESTIONI_TMB */
/
create or replace procedure GESTIONI_PD
/******************************************************************************
 NOME:        GESTIONI_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table GESTIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger GESTIONI_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_codice IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
/*   .DeclDeleteParentRestrict */
      cursor cfk1_gestioni_amministrative(var_codice varchar) is
      select 1
      from   GESTIONI_AMMINISTRATIVE
      where  CODICE = var_codice
	    and exists
		   (select 'x' from settori_amministrativi
		     where gestione = var_codice
			   and utente  <> 'Aut.GP4'
		   )
       and   var_codice is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "GESTIONI" if children still exist in "GESTIONI_AMMINISTRATIVE"
      open  cfk1_gestioni_amministrative(OLD_CODICE);
      fetch cfk1_gestioni_amministrative into dummy;
      found := cfk1_gestioni_amministrative%FOUND; /* %FOUND */
      close cfk1_gestioni_amministrative;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Gestioni Amministrative. La registrazione di GESTIONI non e'' eliminabile.';
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
/* End Procedure: GESTIONI_PD */
/
create or replace trigger GESTIONI_TDB
   before DELETE on GESTIONI
for each row
/******************************************************************************
 NOME:        GESTIONI_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table GESTIONI
 ANNOTAZIONI: Richiama Procedure GESTIONI_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      GESTIONI_PD(:OLD.CODICE);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: GESTIONI_TDB */
/
CREATE OR REPLACE TRIGGER gestioni_amministrative_tma
   AFTER INSERT OR UPDATE
   ON gestioni_amministrative
   FOR EACH ROW
DECLARE
   tmpvar            NUMBER;
   dep_ni            NUMBER;
   dep_numero        NUMBER;
   dep_revisione_m   NUMBER;
   dep_revisione_a   NUMBER;
   dep_revisione_o   NUMBER;
   dep_dal_a         DATE;
   dep_dal_m         DATE;
   dep_dal_o         DATE;
   integrity_error   EXCEPTION;
   errno             INTEGER;
   errmsg            CHAR (200);
   dummy             INTEGER;
   FOUND             BOOLEAN;
BEGIN
   IF INSERTING THEN
      BEGIN
         tmpvar           := 0;

         /* Determino il numero individuale del nuovo settore */
         SELECT indi_sq.NEXTVAL
           INTO dep_ni
           FROM DUAL;

         /* Inserisce il soggetto anagrafico del settore amministrativo  e della UO*/
         INSERT INTO anagrafici
                     (ni, cognome, dal, provincia_res, comune_res
                     ,cap_res, provincia_dom, comune_dom, cap_dom, utente, data_agg, denominazione
                     ,tipo_soggetto)
            SELECT dep_ni
                  ,:NEW.denominazione
                  ,TO_DATE ('01011900', 'ddmmyyyy')
                  ,provincia_res
                  ,comune_res
                  ,cap
                  ,provincia_res
                  ,comune_res
                  ,cap
                  ,:NEW.utente
                  ,:NEW.data_agg
                  ,:NEW.denominazione
                  ,'S'
              FROM ente;

         FOR rest IN (SELECT   revisione
                              ,stato
                              ,dal
                              ,DATA
                          FROM revisioni_struttura
                      ORDER BY dal)
         LOOP
            INSERT INTO unita_organizzative
                        (ottica, ni, codice_uo, dal, unita_padre, unita_padre_ottica
                        ,unita_padre_dal, descrizione, tipo, suddivisione, revisione, utente
                        ,data_agg)
               SELECT 'GP4'
                     ,dep_ni
                     ,:NEW.codice
                     ,NVL (rest.dal, rest.DATA)
                     ,0
                     ,'GP4'
                     ,NVL (rest.dal, rest.DATA)
                     ,:NEW.denominazione
                     ,DECODE (rest.stato, 'M', 'T', 'P')
                     ,0
                     ,rest.revisione
                     ,:NEW.utente
                     ,:NEW.data_agg
                 FROM DUAL;
         END LOOP;

         /* Inserisce il settore amministrativo della Gestione (radice dell'albero) */
         SELECT sett_sq.NEXTVAL
           INTO dep_numero
           FROM DUAL;

         INSERT INTO settori_amministrativi
                     (numero, ni, codice, denominazione, gestione, assegnabile, data_agg, utente)
            SELECT dep_numero
                  ,dep_ni
                  ,:NEW.codice
                  ,:NEW.denominazione
                  ,:NEW.codice
                  ,'SI'
                  ,:NEW.data_agg
                  ,:NEW.utente
              FROM DUAL
             WHERE NOT EXISTS (SELECT 'x'
                                 FROM settori_amministrativi
                                WHERE codice = :NEW.codice);

         INSERT INTO settori
                     (gestione, codice, descrizione, numero, suddivisione, assegnabile)
            SELECT :NEW.codice
                  ,:NEW.codice
                  ,SUBSTR (:NEW.denominazione, 1, 30)
                  ,dep_numero
                  ,0
                  ,'NO'
              FROM DUAL
             WHERE NOT EXISTS (SELECT 'x'
                                 FROM settori
                                WHERE codice = :NEW.codice);
      /*
         Select MySeq.NextVal into tmpVar from dual;
         :NEW.SequenceColumn := tmpVar;
         :NEW.CreatedDate := Sysdate;
         :NEW.CreatedUser := User;
         EXCEPTION
           WHEN OTHERS THEN
             Null;
      */
      EXCEPTION
         WHEN integrity_error THEN
            integritypackage.initnestlevel;
            raise_application_error (errno, errmsg);
         WHEN OTHERS THEN
            integritypackage.initnestlevel;
            RAISE;
      END;
   END IF;                                                                         -- fine inserting

   IF UPDATING THEN
      dep_ni           := gp4_stam.get_ni (:NEW.codice);

      UPDATE unita_organizzative
         SET descrizione = :NEW.denominazione
            ,utente = :NEW.utente
            ,data_agg = :NEW.data_agg
            ,codice_uo = :NEW.codice
       WHERE ni = dep_ni;

      UPDATE settori_amministrativi
         SET denominazione = :NEW.denominazione
            ,gestione = :NEW.codice
            ,data_agg = :NEW.data_agg
            ,utente = :NEW.utente
       WHERE ni = dep_ni;
   END IF;                                                                          -- fine updating
END;
/
create or replace procedure GESTIONI_AMMINISTRATIVE_PI
/******************************************************************************
 NOME:        GESTIONI_AMMINISTRATIVE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table GESTIONI_AMMINISTRATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger GESTIONI_AMMINISTRATIVE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_codice IN varchar,
 new_ni IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk1_gestioni_amministrative(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "GESTIONI"
   cursor cpk2_gestioni_amministrative(var_codice varchar) is
      select 1
      from   GESTIONI
      where  CODICE = var_codice
       and   var_codice is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "GESTIONI_AMMINISTRATIVE"
         if NEW_NI is not null then
            open  cpk1_gestioni_amministrative(NEW_NI);
            fetch cpk1_gestioni_amministrative into dummy;
            found := cpk1_gestioni_amministrative%FOUND; /* %FOUND */
            close cpk1_gestioni_amministrative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Gestioni Amministrative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GESTIONI" deve esistere quando si inserisce su "GESTIONI_AMMINISTRATIVE"
         if NEW_CODICE is not null then
            open  cpk2_gestioni_amministrative(NEW_CODICE);
            fetch cpk2_gestioni_amministrative into dummy;
            found := cpk2_gestioni_amministrative%FOUND; /* %FOUND */
            close cpk2_gestioni_amministrative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su GESTIONI. La registrazione Gestioni Amministrative non puo'' essere inserita.';
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
/* End Procedure: GESTIONI_AMMINISTRATIVE_PI */
/
create or replace procedure GESTIONI_AMMINISTRATIVE_PU
/******************************************************************************
 NOME:        GESTIONI_AMMINISTRATIVE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table GESTIONI_AMMINISTRATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger GESTIONI_AMMINISTRATIVE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_codice IN varchar
 , old_ni IN number
 , new_codice IN varchar
 , new_ni IN number
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk1_gestioni_amministrative(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "GESTIONI"
   cursor cpk2_gestioni_amministrative(var_codice varchar) is
      select 1
      from   GESTIONI
      where  CODICE = var_codice
       and   var_codice is not null;
   --  Declaration of UpdateParentRestrict constraint for "SETTORI_AMMINISTRATIVI"
   cursor cfk1_settori_amministrativi(var_codice varchar) is
      select 1
      from   SETTORI_AMMINISTRATIVI
      where  GESTIONE = var_codice
       and   var_codice is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "GESTIONI_AMMINISTRATIVE"
         if  NEW_NI is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null) ) then
            open  cpk1_gestioni_amministrative(NEW_NI);
            fetch cpk1_gestioni_amministrative into dummy;
            found := cpk1_gestioni_amministrative%FOUND; /* %FOUND */
            close cpk1_gestioni_amministrative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Gestioni Amministrative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GESTIONI" deve esistere quando si modifica "GESTIONI_AMMINISTRATIVE"
         if  NEW_CODICE is not null and ( seq = 0 )
         and (   (NEW_CODICE != OLD_CODICE or OLD_CODICE is null) ) then
            open  cpk2_gestioni_amministrative(NEW_CODICE);
            fetch cpk2_gestioni_amministrative into dummy;
            found := cpk2_gestioni_amministrative%FOUND; /* %FOUND */
            close cpk2_gestioni_amministrative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su GESTIONI. La registrazione Gestioni Amministrative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "GESTIONI_AMMINISTRATIVE" non modificabile se esistono referenze su "SETTORI_AMMINISTRATIVI"
      if (OLD_CODICE != NEW_CODICE) then
         open  cfk1_settori_amministrativi(OLD_CODICE);
         fetch cfk1_settori_amministrativi into dummy;
         found := cfk1_settori_amministrativi%FOUND; /* %FOUND */
         close cfk1_settori_amministrativi;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Settori Amministrativi. La registrazione di Gestioni Amministrative non e'' modificabile.';
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
/* End Procedure: GESTIONI_AMMINISTRATIVE_PU */
/
create or replace trigger GESTIONI_AMMINISTRATIVE_TMB
   before INSERT or UPDATE on GESTIONI_AMMINISTRATIVE
for each row
/******************************************************************************
 NOME:        GESTIONI_AMMINISTRATIVE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table GESTIONI_AMMINISTRATIVE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure GESTIONI_AMMINISTRATIVE_PI e GESTIONI_AMMINISTRATIVE_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if nvl(:NEW.UTENTE,' ') = nvl(:OLD.UTENTE,' ') then
        :NEW.UTENTE := SI4.UTENTE;
      end if;
      if nvl(:NEW.DATA_AGG,SYSDATE) = nvl(:OLD.DATA_AGG,SYSDATE) then
        :NEW.DATA_AGG := SYSDATE;
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         GESTIONI_AMMINISTRATIVE_PU(:OLD.CODICE
                       , :OLD.NI
                         , :NEW.CODICE
                         , :NEW.NI
                         );
         null;
      end if;
	if INSERTING then
         GESTIONI_AMMINISTRATIVE_PI(:NEW.CODICE,
                         :NEW.NI);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "GESTIONI_AMMINISTRATIVE"
            cursor cpk_gestioni_amministrative(var_CODICE varchar) is
               select 1
                 from   GESTIONI_AMMINISTRATIVE
                where  CODICE = var_CODICE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "GESTIONI_AMMINISTRATIVE"
               if :new.CODICE is not null then
                  open  cpk_gestioni_amministrative(:new.CODICE);
                  fetch cpk_gestioni_amministrative into dummy;
                  found := cpk_gestioni_amministrative%FOUND;
                  close cpk_gestioni_amministrative;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.CODICE||
                               '" gia'' presente in Gestioni Amministrative. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: GESTIONI_AMMINISTRATIVE_TMB */
/
create or replace procedure GESTIONI_AMMINISTRATIVE_PD
/******************************************************************************
 NOME:        GESTIONI_AMMINISTRATIVE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table GESTIONI_AMMINISTRATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger GESTIONI_AMMINISTRATIVE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_codice IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "SETTORI_AMMINISTRATIVI"
   cursor cfk1_settori_amministrativi(var_codice varchar) is
      select 1
      from   SETTORI_AMMINISTRATIVI
      where  GESTIONE = var_codice
       and   var_codice is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "GESTIONI_AMMINISTRATIVE" if children still exist in "SETTORI_AMMINISTRATIVI"
      open  cfk1_settori_amministrativi(OLD_CODICE);
      fetch cfk1_settori_amministrativi into dummy;
      found := cfk1_settori_amministrativi%FOUND; /* %FOUND */
      close cfk1_settori_amministrativi;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Settori Amministrativi. La registrazione di Gestioni Amministrative non e'' eliminabile.';
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
/* End Procedure: GESTIONI_AMMINISTRATIVE_PD */
/
create or replace trigger GESTIONI_AMMINISTRATIVE_TDB
   before DELETE on GESTIONI_AMMINISTRATIVE
for each row
/******************************************************************************
 NOME:        GESTIONI_AMMINISTRATIVE_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table GESTIONI_AMMINISTRATIVE
 ANNOTAZIONI: Richiama Procedure GESTIONI_AMMINISTRATIVE_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      GESTIONI_AMMINISTRATIVE_PD(:OLD.CODICE);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: GESTIONI_AMMINISTRATIVE_TDB */
/
create or replace procedure GRUPPI_AMMINISTRAZIONI_PU
/******************************************************************************
 NOME:        GRUPPI_AMMINISTRAZIONI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table GRUPPI_AMMINISTRAZIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger GRUPPI_AMMINISTRAZIONI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_gruppo IN varchar
 , new_gruppo IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "AMMINISTRAZIONI"
   cursor cfk1_amministrazioni(var_gruppo varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
   --  Declaration of UpdateParentRestrict constraint for "AOO"
   cursor cfk2_aoo(var_gruppo varchar) is
      select 1
      from   AOO
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "GRUPPI_AMMINISTRAZIONI" non modificabile se esistono referenze su "AMMINISTRAZIONI"
      if (OLD_GRUPPO != NEW_GRUPPO) then
         open  cfk1_amministrazioni(OLD_GRUPPO);
         fetch cfk1_amministrazioni into dummy;
         found := cfk1_amministrazioni%FOUND; /* %FOUND */
         close cfk1_amministrazioni;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Amministrazioni. La registrazione di Gruppi Amministrazioni non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "GRUPPI_AMMINISTRAZIONI" non modificabile se esistono referenze su "AOO"
      if (OLD_GRUPPO != NEW_GRUPPO) then
         open  cfk2_aoo(OLD_GRUPPO);
         fetch cfk2_aoo into dummy;
         found := cfk2_aoo%FOUND; /* %FOUND */
         close cfk2_aoo;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su AOO. La registrazione di Gruppi Amministrazioni non e'' modificabile.';
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
/* End Procedure: GRUPPI_AMMINISTRAZIONI_PU */
/
create or replace trigger GRUPPI_AMMINISTRAZIONI_TMB
   before INSERT or UPDATE on GRUPPI_AMMINISTRAZIONI
for each row
/******************************************************************************
 NOME:        GRUPPI_AMMINISTRAZIONI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table GRUPPI_AMMINISTRAZIONI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure GRUPPI_AMMINISTRAZIONI_PI e GRUPPI_AMMINISTRAZIONI_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         GRUPPI_AMMINISTRAZIONI_PU(:OLD.GRUPPO
                         , :NEW.GRUPPO
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "GRUPPI_AMMINISTRAZIONI"
            cursor cpk_gruppi_amministrazioni(var_GRUPPO varchar) is
               select 1
                 from   GRUPPI_AMMINISTRAZIONI
                where  GRUPPO = var_GRUPPO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "GRUPPI_AMMINISTRAZIONI"
               if :new.GRUPPO is not null then
                  open  cpk_gruppi_amministrazioni(:new.GRUPPO);
                  fetch cpk_gruppi_amministrazioni into dummy;
                  found := cpk_gruppi_amministrazioni%FOUND;
                  close cpk_gruppi_amministrazioni;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.GRUPPO||
                               '" gia'' presente in Gruppi Amministrazioni. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: GRUPPI_AMMINISTRAZIONI_TMB */
/
create or replace procedure GRUPPI_AMMINISTRAZIONI_PD
/******************************************************************************
 NOME:        GRUPPI_AMMINISTRAZIONI_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table GRUPPI_AMMINISTRAZIONI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger GRUPPI_AMMINISTRAZIONI_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_gruppo IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "AMMINISTRAZIONI"
   cursor cfk1_amministrazioni(var_gruppo varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
   --  Declaration of DeleteParentRestrict constraint for "AOO"
   cursor cfk2_aoo(var_gruppo varchar) is
      select 1
      from   AOO
      where  GRUPPO = var_gruppo
       and   var_gruppo is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "GRUPPI_AMMINISTRAZIONI" if children still exist in "AMMINISTRAZIONI"
      open  cfk1_amministrazioni(OLD_GRUPPO);
      fetch cfk1_amministrazioni into dummy;
      found := cfk1_amministrazioni%FOUND; /* %FOUND */
      close cfk1_amministrazioni;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Amministrazioni. La registrazione di Gruppi Amministrazioni non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "GRUPPI_AMMINISTRAZIONI" if children still exist in "AOO"
      open  cfk2_aoo(OLD_GRUPPO);
      fetch cfk2_aoo into dummy;
      found := cfk2_aoo%FOUND; /* %FOUND */
      close cfk2_aoo;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su AOO. La registrazione di Gruppi Amministrazioni non e'' eliminabile.';
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
/* End Procedure: GRUPPI_AMMINISTRAZIONI_PD */
/
create or replace trigger GRUPPI_AMMINISTRAZIONI_TDB
   before DELETE on GRUPPI_AMMINISTRAZIONI
for each row
/******************************************************************************
 NOME:        GRUPPI_AMMINISTRAZIONI_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table GRUPPI_AMMINISTRAZIONI
 ANNOTAZIONI: Richiama Procedure GRUPPI_AMMINISTRAZIONI_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      GRUPPI_AMMINISTRAZIONI_PD(:OLD.GRUPPO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: GRUPPI_AMMINISTRAZIONI_TDB */
/
create or replace procedure OTTICHE_PU
/******************************************************************************
 NOME:        OTTICHE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table OTTICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger OTTICHE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_ottica IN varchar
 , new_ottica IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ottica varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  OTTICA = var_ottica
       and   var_ottica is not null;
   --  Declaration of UpdateParentRestrict constraint for "SUDDIVISIONI_STRUTTURA"
   cursor cfk2_suddivisioni_struttura(var_ottica varchar) is
      select 1
      from   SUDDIVISIONI_STRUTTURA
      where  OTTICA = var_ottica
       and   var_ottica is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "OTTICHE" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if (OLD_OTTICA != NEW_OTTICA) then
         open  cfk1_unita_organizzative(OLD_OTTICA);
         fetch cfk1_unita_organizzative into dummy;
         found := cfk1_unita_organizzative%FOUND; /* %FOUND */
         close cfk1_unita_organizzative;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Ottiche non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "OTTICHE" non modificabile se esistono referenze su "SUDDIVISIONI_STRUTTURA"
      if (OLD_OTTICA != NEW_OTTICA) then
         open  cfk2_suddivisioni_struttura(OLD_OTTICA);
         fetch cfk2_suddivisioni_struttura into dummy;
         found := cfk2_suddivisioni_struttura%FOUND; /* %FOUND */
         close cfk2_suddivisioni_struttura;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Suddivisioni Struttura. La registrazione di Ottiche non e'' modificabile.';
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
/* End Procedure: OTTICHE_PU */
/
create or replace trigger OTTICHE_TMB
   before INSERT or UPDATE on OTTICHE
for each row
/******************************************************************************
 NOME:        OTTICHE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table OTTICHE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure OTTICHE_PI e OTTICHE_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         OTTICHE_PU(:OLD.OTTICA
                         , :NEW.OTTICA
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "OTTICHE"
            cursor cpk_ottiche(var_OTTICA varchar) is
               select 1
                 from   OTTICHE
                where  OTTICA = var_OTTICA;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "OTTICHE"
               if :new.OTTICA is not null then
                  open  cpk_ottiche(:new.OTTICA);
                  fetch cpk_ottiche into dummy;
                  found := cpk_ottiche%FOUND;
                  close cpk_ottiche;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.OTTICA||
                               '" gia'' presente in Ottiche. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: OTTICHE_TMB */
/
create or replace procedure OTTICHE_PD
/******************************************************************************
 NOME:        OTTICHE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table OTTICHE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger OTTICHE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_ottica IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ottica varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  OTTICA = var_ottica
       and   var_ottica is not null;
   --  Declaration of DeleteParentRestrict constraint for "SUDDIVISIONI_STRUTTURA"
   cursor cfk2_suddivisioni_struttura(var_ottica varchar) is
      select 1
      from   SUDDIVISIONI_STRUTTURA
      where  OTTICA = var_ottica
       and   var_ottica is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "OTTICHE" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk1_unita_organizzative(OLD_OTTICA);
      fetch cfk1_unita_organizzative into dummy;
      found := cfk1_unita_organizzative%FOUND; /* %FOUND */
      close cfk1_unita_organizzative;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Ottiche non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "OTTICHE" if children still exist in "SUDDIVISIONI_STRUTTURA"
      open  cfk2_suddivisioni_struttura(OLD_OTTICA);
      fetch cfk2_suddivisioni_struttura into dummy;
      found := cfk2_suddivisioni_struttura%FOUND; /* %FOUND */
      close cfk2_suddivisioni_struttura;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Suddivisioni Struttura. La registrazione di Ottiche non e'' eliminabile.';
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
/* End Procedure: OTTICHE_PD */
/
create or replace trigger OTTICHE_TDB
   before DELETE on OTTICHE
for each row
/******************************************************************************
 NOME:        OTTICHE_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table OTTICHE
 ANNOTAZIONI: Richiama Procedure OTTICHE_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      OTTICHE_PD(:OLD.OTTICA);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: OTTICHE_TDB */
/
create or replace procedure REVISIONI_STRUTTURA_PI
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table REVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_STRUTTURA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ottica IN varchar,
 new_sede_del IN varchar,
 new_anno_del IN number,
 new_numero_del IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
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
/* End Procedure: REVISIONI_STRUTTURA_PI */
/
create or replace procedure REVISIONI_STRUTTURA_PU
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table REVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_STRUTTURA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_revisione IN number
 , old_ottica IN varchar
 , old_sede_del IN varchar
 , old_anno_del IN number
 , old_numero_del IN number
 , new_revisione IN number
 , new_ottica IN varchar
 , new_sede_del IN varchar
 , new_anno_del IN number
 , new_numero_del IN number
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_revisione number,
                   var_ottica varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  REVISIONE = var_revisione
       and   OTTICA = var_ottica
       and   var_revisione is not null
       and   var_ottica is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      --  Chiave di "REVISIONI_STRUTTURA" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if (OLD_REVISIONE != NEW_REVISIONE) or
         (OLD_OTTICA != NEW_OTTICA) then
         open  cfk1_unita_organizzative(OLD_REVISIONE,
                        OLD_OTTICA);
         fetch cfk1_unita_organizzative into dummy;
         found := cfk1_unita_organizzative%FOUND; /* %FOUND */
         close cfk1_unita_organizzative;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Revisioni Struttura non e'' modificabile.';
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
/* End Procedure: REVISIONI_STRUTTURA_PU */
/
create or replace trigger REVISIONI_STRUTTURA_TMB
   before INSERT or UPDATE on REVISIONI_STRUTTURA
for each row
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table REVISIONI_STRUTTURA
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure REVISIONI_STRUTTURA_PI e REVISIONI_STRUTTURA_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if nvl(:NEW.UTENTE,' ') = nvl(:OLD.UTENTE,' ') then 
        :NEW.UTENTE := SI4.UTENTE; 
      end if; 
      if nvl(:NEW.DATA_AGG,SYSDATE) = nvl(:OLD.DATA_AGG,SYSDATE) then 
        :NEW.DATA_AGG := SYSDATE; 
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         REVISIONI_STRUTTURA_PU(:OLD.REVISIONE
                       , :OLD.OTTICA
                       , :OLD.SEDE_DEL
                       , :OLD.ANNO_DEL
                       , :OLD.NUMERO_DEL
                         , :NEW.REVISIONE
                         , :NEW.OTTICA
                         , :NEW.SEDE_DEL
                         , :NEW.ANNO_DEL
                         , :NEW.NUMERO_DEL
                         );
         null;
      end if;
	if INSERTING then
         REVISIONI_STRUTTURA_PI(:NEW.OTTICA,
                         :NEW.SEDE_DEL,
                         :NEW.ANNO_DEL,
                         :NEW.NUMERO_DEL);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "REVISIONI_STRUTTURA"
            cursor cpk_revisioni_struttura(var_REVISIONE number,
                            var_OTTICA varchar) is
               select 1
                 from   REVISIONI_STRUTTURA
                where  REVISIONE = var_REVISIONE and
                       OTTICA = var_OTTICA;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "REVISIONI_STRUTTURA"
               if :new.REVISIONE is not null and
                  :new.OTTICA is not null then
                  open  cpk_revisioni_struttura(:new.REVISIONE,
                                 :new.OTTICA);
                  fetch cpk_revisioni_struttura into dummy;
                  found := cpk_revisioni_struttura%FOUND;
                  close cpk_revisioni_struttura;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.REVISIONE||' '||
                               :new.OTTICA||
                               '" gia'' presente in Revisioni Struttura. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: REVISIONI_STRUTTURA_TMB */
/
create or replace procedure REVISIONI_STRUTTURA_PD
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table REVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_STRUTTURA_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_revisione IN number,
 old_ottica IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_revisione number,
                   var_ottica varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  REVISIONE = var_revisione
       and   OTTICA = var_ottica
       and   var_revisione is not null
       and   var_ottica is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "REVISIONI_STRUTTURA" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk1_unita_organizzative(OLD_REVISIONE,
                     OLD_OTTICA);
      fetch cfk1_unita_organizzative into dummy;
      found := cfk1_unita_organizzative%FOUND; /* %FOUND */
      close cfk1_unita_organizzative;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Revisioni Struttura non e'' eliminabile.';
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
/* End Procedure: REVISIONI_STRUTTURA_PD */
/
create or replace trigger REVISIONI_STRUTTURA_TDB
   before DELETE on REVISIONI_STRUTTURA
for each row
/******************************************************************************
 NOME:        REVISIONI_STRUTTURA_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table REVISIONI_STRUTTURA
 ANNOTAZIONI: Richiama Procedure REVISIONI_STRUTTURA_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      REVISIONI_STRUTTURA_PD(:OLD.REVISIONE,
                    :OLD.OTTICA);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: REVISIONI_STRUTTURA_TDB */
/
CREATE OR REPLACE TRIGGER SEDI_TMA
 AFTER INSERT OR UPDATE OR DELETE ON SEDI
FOR EACH ROW
/******************************************************************************
 NOME:        SEDI_TMA
 DESCRIZIONE: Allineamento di SEDI_AMMINISTRATIVE a fronte di modifiche a SEDI:
              Utile nel caso in cui, dopo l'aggiornamento del DB al nuovo disegno
			  siano ancora in uso le forms in 4.5
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    16/10/2002     __     Prima emissione.
******************************************************************************/
DECLARE
d_valore NUMBER;
begin
    if IntegrityPackage.GetNestLevel = 0 then
       IntegrityPackage.NEXTNESTLEVEL;
       BEGIN
         IF INSERTING THEN -- Inserimento su SEDI_AMMINISTRATIVE
    	   insert into sedi_amministrative
    	   ( NUMERO
            ,CODICE
            ,DENOMINAZIONE
            ,DENOMINAZIONE_AL1
            ,DENOMINAZIONE_AL2
            ,SEQUENZA
            ,CALENDARIO
            ,UTENTE
            ,DATA_AGG
           ) values
    	   ( :NEW.numero
            ,:NEW.CODICE
            ,:NEW.DESCRIZIONE
            ,:NEW.DESCRIZIONE_AL1
            ,:NEW.DESCRIZIONE_AL2
            ,:NEW.SEQUENZA
            ,:NEW.CALENDARIO
            ,'Aut.SEDI'
    		,sysdate
    	   );
    	 END IF;
         IF UPDATING THEN -- Modifiche su SEDI_AMMINISTRATIVE
    	   update sedi_amministrative
    	   set
        	   ( NUMERO
                ,CODICE
                ,DENOMINAZIONE
                ,DENOMINAZIONE_AL1
                ,DENOMINAZIONE_AL2
                ,SEQUENZA
                ,CALENDARIO
                ,UTENTE
                ,DATA_AGG
               ) =
    		   (select
            	     :NEW.numero
                    ,:NEW.CODICE
                    ,:NEW.DESCRIZIONE
                    ,:NEW.DESCRIZIONE_AL1
                    ,:NEW.DESCRIZIONE_AL2
                    ,:NEW.SEQUENZA
                    ,:NEW.CALENDARIO
                    ,'Aut.SEDI'
            		,sysdate
                  from dual
    		   )
    		where numero = :OLD.NUMERO
        	;
    	 END IF;
         IF DELETING THEN -- Eliminazione da SEDI_AMMINISTRATIVE
    	   delete from sedi_amministrative
    		where numero = :OLD.NUMERO
        	;
    	 END IF;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20999,'<Messaggio>');
       END;
   IntegrityPackage.PREVIOUSNESTLEVEL;
end if;
exception
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
END SEDI_TMA;
/
create or replace procedure SEDI_AMMINISTRATIVE_PI
/******************************************************************************
 NOME:        SEDI_AMMINISTRATIVE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table SEDI_AMMINISTRATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger SEDI_AMMINISTRATIVE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ni IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk1_sedi_amministrative(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "SEDI_AMMINISTRATIVE"
         if NEW_NI is not null then
            open  cpk1_sedi_amministrative(NEW_NI);
            fetch cpk1_sedi_amministrative into dummy;
            found := cpk1_sedi_amministrative%FOUND; /* %FOUND */
            close cpk1_sedi_amministrative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Sedi Amministrative non puo'' essere inserita.';
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
/* End Procedure: SEDI_AMMINISTRATIVE_PI */
/
create or replace procedure SEDI_AMMINISTRATIVE_PU
/******************************************************************************
 NOME:        SEDI_AMMINISTRATIVE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table SEDI_AMMINISTRATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SEDI_AMMINISTRATIVE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_numero IN number
 , old_ni IN number
 , new_numero IN number
 , new_ni IN number
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk1_sedi_amministrative(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Declaration of UpdateParentRestrict constraint for "SETTORI_AMMINISTRATIVI"
   cursor cfk1_settori_amministrativi(var_numero number) is
      select 1
      from   SETTORI_AMMINISTRATIVI
      where  SEDE = var_numero
       and   var_numero is not null;
   --  Declaration of UpdateParentRestrict constraint for "PERIODI_GIURIDICI"
   cursor cfk2_periodi_giuridici(var_numero number) is
      select 1
      from   PERIODI_GIURIDICI
      where  SEDE = var_numero
       and   var_numero is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "SEDI_AMMINISTRATIVE"
         if  NEW_NI is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null) ) then
            open  cpk1_sedi_amministrative(NEW_NI);
            fetch cpk1_sedi_amministrative into dummy;
            found := cpk1_sedi_amministrative%FOUND; /* %FOUND */
            close cpk1_sedi_amministrative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Sedi Amministrative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "SEDI_AMMINISTRATIVE" non modificabile se esistono referenze su "SETTORI_AMMINISTRATIVI"
      if (OLD_NUMERO != NEW_NUMERO) then
         open  cfk1_settori_amministrativi(OLD_NUMERO);
         fetch cfk1_settori_amministrativi into dummy;
         found := cfk1_settori_amministrativi%FOUND; /* %FOUND */
         close cfk1_settori_amministrativi;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Settori Amministrativi. La registrazione di Sedi Amministrative non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "SEDI_AMMINISTRATIVE" non modificabile se esistono referenze su "PERIODI_GIURIDICI"
      if (OLD_NUMERO != NEW_NUMERO) then
         open  cfk2_periodi_giuridici(OLD_NUMERO);
         fetch cfk2_periodi_giuridici into dummy;
         found := cfk2_periodi_giuridici%FOUND; /* %FOUND */
         close cfk2_periodi_giuridici;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su PERIODI_GIURIDICI. La registrazione di Sedi Amministrative non e'' modificabile.';
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
/* End Procedure: SEDI_AMMINISTRATIVE_PU */
/
create or replace trigger SEDI_AMMINISTRATIVE_TMB
   before INSERT or UPDATE on SEDI_AMMINISTRATIVE
for each row
/******************************************************************************
 NOME:        SEDI_AMMINISTRATIVE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table SEDI_AMMINISTRATIVE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure SEDI_AMMINISTRATIVE_PI e SEDI_AMMINISTRATIVE_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if nvl(:NEW.UTENTE,' ') = nvl(:OLD.UTENTE,' ') then
        :NEW.UTENTE := SI4.UTENTE;
      end if;
      if nvl(:NEW.DATA_AGG,SYSDATE) = nvl(:OLD.DATA_AGG,SYSDATE) then
        :NEW.DATA_AGG := SYSDATE;
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         SEDI_AMMINISTRATIVE_PU(:OLD.NUMERO
                       , :OLD.NI
                         , :NEW.NUMERO
                         , :NEW.NI
                         );
         null;
      end if;
	if INSERTING then
         SEDI_AMMINISTRATIVE_PI(:NEW.NI);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "SEDI_AMMINISTRATIVE"
            cursor cpk_sedi_amministrative(var_NUMERO number) is
               select 1
                 from   SEDI_AMMINISTRATIVE
                where  NUMERO = var_NUMERO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "SEDI_AMMINISTRATIVE"
               if :new.NUMERO is not null then
                  open  cpk_sedi_amministrative(:new.NUMERO);
                  fetch cpk_sedi_amministrative into dummy;
                  found := cpk_sedi_amministrative%FOUND;
                  close cpk_sedi_amministrative;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.NUMERO||
                               '" gia'' presente in Sedi Amministrative. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: SEDI_AMMINISTRATIVE_TMB */
/
create or replace procedure SEDI_AMMINISTRATIVE_PD
/******************************************************************************
 NOME:        SEDI_AMMINISTRATIVE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table SEDI_AMMINISTRATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SEDI_AMMINISTRATIVE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_numero IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "SETTORI_AMMINISTRATIVI"
   cursor cfk1_settori_amministrativi(var_numero number) is
      select 1
      from   SETTORI_AMMINISTRATIVI
      where  SEDE = var_numero
       and   var_numero is not null;
   --  Declaration of DeleteParentRestrict constraint for "PERIODI_GIURIDICI"
   cursor cfk2_periodi_giuridici(var_numero number) is
      select 1
      from   PERIODI_GIURIDICI
      where  SEDE = var_numero
       and   var_numero is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "SEDI_AMMINISTRATIVE" if children still exist in "SETTORI_AMMINISTRATIVI"
      open  cfk1_settori_amministrativi(OLD_NUMERO);
      fetch cfk1_settori_amministrativi into dummy;
      found := cfk1_settori_amministrativi%FOUND; /* %FOUND */
      close cfk1_settori_amministrativi;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Settori Amministrativi. La registrazione di Sedi Amministrative non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "SEDI_AMMINISTRATIVE" if children still exist in "PERIODI_GIURIDICI"
      open  cfk2_periodi_giuridici(OLD_NUMERO);
      fetch cfk2_periodi_giuridici into dummy;
      found := cfk2_periodi_giuridici%FOUND; /* %FOUND */
      close cfk2_periodi_giuridici;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su PERIODI_GIURIDICI. La registrazione di Sedi Amministrative non e'' eliminabile.';
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
/* End Procedure: SEDI_AMMINISTRATIVE_PD */
/
create or replace trigger SEDI_AMMINISTRATIVE_TDB
   before DELETE on SEDI_AMMINISTRATIVE
for each row
/******************************************************************************
 NOME:        SEDI_AMMINISTRATIVE_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table SEDI_AMMINISTRATIVE
 ANNOTAZIONI: Richiama Procedure SEDI_AMMINISTRATIVE_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      SEDI_AMMINISTRATIVE_PD(:OLD.NUMERO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: SEDI_AMMINISTRATIVE_TDB */
/
CREATE OR REPLACE TRIGGER SEDI_AMMINISTRATIVE_TMA
 AFTER INSERT OR UPDATE OR DELETE ON SEDI_AMMINISTRATIVE
FOR EACH ROW
/******************************************************************************
 NOME:        SEDI_AMMINISTRATIVE_TMA
 DESCRIZIONE: Allineamento di SEDI a fronte di modifiche a SEDI_AMMINISTRATIVE:
              Utile nel caso in cui, dopo l'aggiornamento del DB al nuovo disegno
			  siano ancora gia uso le forms in 6.0
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    16/10/2002     __     Prima emissione.
******************************************************************************/
DECLARE
d_valore NUMBER;
BEGIN
   if IntegrityPackage.GetNestLevel = 0 then
      IntegrityPackage.NEXTNESTLEVEL;
   BEGIN
     IF INSERTING THEN -- Inserimento su SEDI

	   insert into sedi
	   ( CODICE
        ,DESCRIZIONE
        ,DESCRIZIONE_AL1
        ,DESCRIZIONE_AL2
        ,SEQUENZA
        ,NUMERO
        ,CALENDARIO
       ) values
	   ( :NEW.CODICE
        ,:NEW.DENOMINAZIONE
        ,:NEW.DENOMINAZIONE_AL1
        ,:NEW.DENOMINAZIONE_AL2
        ,:NEW.SEQUENZA
        ,:NEW.numero
        ,:NEW.CALENDARIO
	   );
	 END IF;
     IF UPDATING THEN -- Modifiche su SEDI
	    update sedi
    	   set
    	   ( CODICE
            ,DESCRIZIONE
            ,DESCRIZIONE_AL1
            ,DESCRIZIONE_AL2
            ,SEQUENZA
            ,NUMERO
            ,CALENDARIO
           ) =
		   (select
        	     :NEW.CODICE
                ,:NEW.DENOMINAZIONE
                ,:NEW.DENOMINAZIONE_AL1
                ,:NEW.DENOMINAZIONE_AL2
                ,:NEW.SEQUENZA
				,:NEW.NUMERO
                ,:NEW.CALENDARIO
              from dual
		   )
		where numero = :OLD.NUMERO
    	;
	 END IF;
     IF DELETING THEN -- Eliminazione da SEDI
	   delete from sedi
		where numero = :OLD.NUMERO
    	;
	 END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20999,'<Messaggio>');
   END;
   IntegrityPackage.PREVIOUSNESTLEVEL;
end if;
exception
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
END SEDI_AMMINISTRATIVE_TMA;
/

CREATE OR REPLACE TRIGGER SETTORI_TMA
AFTER INSERT OR UPDATE OR DELETE ON SETTORI
FOR EACH ROW
/******************************************************************************
 NOME:        SETTORI_TMA
 DESCRIZIONE: Allineamento in caso di inserimento nella tabella SETTORI

 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    16/10/2002 __     Prima emissione.
 1.0  09/11/2006 MS     Mod. insert in anagrafici 
******************************************************************************/
declare
   dep_ni                  number(8);
   dep_revisione        number;
   dep_dal_revisione    date;
   dep_al            date;
   dep_anag_ni          number(8);
   d_dummy varchar2(1);
   situazione_anomala exception;
begin
if IntegrityPackage.GetNestLevel = 0 then
     IntegrityPackage.NEXTNESTLEVEL;
     dep_revisione := gp4gm.get_revisione_a;
     dep_dal_revisione := gp4_rest.get_dal_rest_attiva('GP4');
     if inserting then
        begin
        select 'x'
          into d_dummy
          from settori_amministrativi
         where numero = :new.numero
		;
	     exception when no_data_found then
		 begin
        select  indi_sq.nextval
          into  dep_ni
          from  dual
           ;
         insert into ANAGRAFICI
         ( NI
          ,COGNOME
          ,DAL
          ,UTENTE
          ,DATA_AGG
          ,DENOMINAZIONE
          ,TIPO_SOGGETTO
         )
        values
        (
          dep_ni
         ,:NEW.descrizione
         ,dep_dal_revisione
          ,'Aut.SETT'
          ,sysdate
          ,:NEW.DESCRIZIONE
          ,'S'
        )
         ;
        insert into UNITA_ORGANIZZATIVE
        (
          ottica
         ,ni
        ,codice_uo
         ,dal
         ,unita_padre
         ,unita_padre_ottica
         ,unita_padre_dal
         ,descrizione
         ,al
         ,tipo
         ,suddivisione
         ,revisione
         ,utente
         ,data_agg
        )
        values
        (
         'GP4'
         ,DEP_NI
        ,:NEW.codice
         ,dep_dal_revisione
         ,nvl(gp4_stam.get_ni_numero(
                                     decode(:new.settore_c,to_number(null),
                                         decode(:new.settore_b,to_number(null),
                                              decode(:new.settore_a,to_number(null),
                                                    :new.settore_g,:new.settore_a
                                                 )
                                            ,:new.settore_b
                                             )
                                       ,:new.settore_c
                                        )
                          ),0)
          ,'GP4'
          ,dep_dal_revisione
          ,:new.descrizione
          ,to_date(null)
          ,'P'
          ,:new.suddivisione
          ,dep_revisione
          ,'Aut.SETT'
          ,sysdate
        )
        ;
        insert into SETTORI_AMMINISTRATIVI
        (
           numero
          ,ni
          ,codice
          ,denominazione
          ,denominazione_al1
          ,denominazione_al2
          ,sequenza
          ,gestione
          ,sede
          ,assegnabile
          ,note
          ,data_agg
          ,utente
        )
        select
          :new.numero
         ,dep_ni
         ,:new.codice
         ,:new.descrizione
         ,:new.descrizione_al1
         ,:new.descrizione_al2
         ,:new.sequenza
         ,:new.gestione
         ,:new.sede
         ,:new.assegnabile
         ,to_char(null)
         ,sysdate
         ,'Aut.SETT'
         from dual
        ;
		end;
	    end;
       end if;   -- inserting
       if updating then
       dep_anag_ni  := gp4_stam.get_ni_numero(:old.numero);
       update ANAGRAFICI set
                COGNOME         =  :NEW.descrizione
               ,DENOMINAZIONE   =  :new.descrizione
       where ni  = dep_anag_ni
         and dal = dep_dal_revisione
         ;
        update UNITA_ORGANIZZATIVE set
          unita_padre = nvl(gp4_stam.get_ni_numero(
                                              decode(:new.settore_c,to_number(null),
                                                      decode(:new.settore_b,to_number(null),
                                                           decode(:new.settore_a,to_number(null),
                                                                  :new.settore_g,:new.settore_a
                                                                )
                                                          ,:new.settore_b
                                                           )
                                                  ,:new.settore_c
                                                 )
                                          ),0)
         ,descrizione                    = :new.descrizione
         ,suddivisione                     = :new.suddivisione
         ,codice_uo = :NEW.codice
         where ottica                     = 'GP4'
           and ni                        = dep_anag_ni
          and dal                        = dep_dal_revisione
        ;
        update SETTORI_AMMINISTRATIVI set
          codice                       = :new.codice
          ,denominazione                = :new.descrizione
          ,denominazione_al1             = :new.descrizione_al1
          ,denominazione_al2             = :new.descrizione_al2
          ,sequenza                   = :new.sequenza
          ,gestione                   = :new.gestione
          ,sede                      = :new.sede
          ,assegnabile                   = :new.assegnabile
        where numero                   = :old.numero
        ;
       end if;
       if deleting then
        dep_al:=sysdate;
          update ANAGRAFICI set
               al         =  dep_al
       where ni  = dep_anag_ni
         and dal = dep_dal_revisione
        ;
       update UNITA_ORGANIZZATIVE set
                al          = dep_al
         where ottica      = 'GP4'
           and ni         = dep_anag_ni
          and dal         = dep_dal_revisione
        ;
       /*update SETTORI_AMMINISTRATIVI set
                al          = dep_al
        where numero       = :old.numero
       ;*/
       end if;
       IntegrityPackage.PREVIOUSNESTLEVEL;
   end if;
   exception
   when situazione_anomala then null;
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/
create or replace procedure SETTORI_AMMINISTRATIVI_PI
/******************************************************************************
 NOME:        SETTORI_AMMINISTRATIVI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table SETTORI_AMMINISTRATIVI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger SETTORI_AMMINISTRATIVI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ni IN number,
 new_gestione IN varchar,
 new_sede IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "SEDI_AMMINISTRATIVE"
   cursor cpk1_settori_amministrativi(var_sede number) is
      select 1
      from   SEDI_AMMINISTRATIVE
      where  NUMERO = var_sede
       and   var_sede is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "GESTIONI_AMMINISTRATIVE"
   cursor cpk2_settori_amministrativi(var_gestione varchar) is
      select 1
      from   GESTIONI_AMMINISTRATIVE
      where  CODICE = var_gestione
       and   var_gestione is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk3_settori_amministrativi(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "SEDI_AMMINISTRATIVE" deve esistere quando si inserisce su "SETTORI_AMMINISTRATIVI"
         if NEW_SEDE is not null then
            open  cpk1_settori_amministrativi(NEW_SEDE);
            fetch cpk1_settori_amministrativi into dummy;
            found := cpk1_settori_amministrativi%FOUND; /* %FOUND */
            close cpk1_settori_amministrativi;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Sedi Amministrative. La registrazione Settori Amministrativi non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GESTIONI_AMMINISTRATIVE" deve esistere quando si inserisce su "SETTORI_AMMINISTRATIVI"
         if NEW_GESTIONE is not null then
            open  cpk2_settori_amministrativi(NEW_GESTIONE);
            fetch cpk2_settori_amministrativi into dummy;
            found := cpk2_settori_amministrativi%FOUND; /* %FOUND */
            close cpk2_settori_amministrativi;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Gestioni Amministrative. La registrazione Settori Amministrativi non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "SETTORI_AMMINISTRATIVI"
         if NEW_NI is not null then
            open  cpk3_settori_amministrativi(NEW_NI);
            fetch cpk3_settori_amministrativi into dummy;
            found := cpk3_settori_amministrativi%FOUND; /* %FOUND */
            close cpk3_settori_amministrativi;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Settori Amministrativi non puo'' essere inserita.';
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
/* End Procedure: SETTORI_AMMINISTRATIVI_PI */
/
create or replace procedure SETTORI_AMMINISTRATIVI_PU
/******************************************************************************
 NOME:        SETTORI_AMMINISTRATIVI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table SETTORI_AMMINISTRATIVI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SETTORI_AMMINISTRATIVI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_numero IN number
 , old_ni IN number
 , old_codice IN varchar
 , old_gestione IN varchar
 , old_sede IN number
 , new_numero IN number
 , new_ni IN number
 , new_codice IN varchar
 , new_gestione IN varchar
 , new_sede IN number
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "SEDI_AMMINISTRATIVE"
   cursor cpk1_settori_amministrativi(var_sede number) is
      select 1
      from   SEDI_AMMINISTRATIVE
      where  NUMERO = var_sede
       and   var_sede is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "GESTIONI_AMMINISTRATIVE"
   cursor cpk2_settori_amministrativi(var_gestione varchar) is
      select 1
      from   GESTIONI_AMMINISTRATIVE
      where  CODICE = var_gestione
       and   var_gestione is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk3_settori_amministrativi(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Declaration of UpdateParentRestrict constraint for "PERIODI_GIURIDICI"
   cursor cfk1_periodi_giuridici(var_numero number) is
      select 1
      from   PERIODI_GIURIDICI
      where  SETTORE = var_numero
       and   var_numero is not null
       and   exists
             (select 'x' 
                from ripartizioni_funzionali rifu
               where settore = rifu.settore
                 and nvl(sede,0) = rifu.sede
             )
       ;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "SEDI_AMMINISTRATIVE" deve esistere quando si modifica "SETTORI_AMMINISTRATIVI"
         if  NEW_SEDE is not null and ( seq = 0 )
         and (   (NEW_SEDE != OLD_SEDE or OLD_SEDE is null) ) then
            open  cpk1_settori_amministrativi(NEW_SEDE);
            fetch cpk1_settori_amministrativi into dummy;
            found := cpk1_settori_amministrativi%FOUND; /* %FOUND */
            close cpk1_settori_amministrativi;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Sedi Amministrative. La registrazione Settori Amministrativi non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "GESTIONI_AMMINISTRATIVE" deve esistere quando si modifica "SETTORI_AMMINISTRATIVI"
         if  NEW_GESTIONE is not null and ( seq = 0 )
         and (   (NEW_GESTIONE != OLD_GESTIONE or OLD_GESTIONE is null) ) then
            open  cpk2_settori_amministrativi(NEW_GESTIONE);
            fetch cpk2_settori_amministrativi into dummy;
            found := cpk2_settori_amministrativi%FOUND; /* %FOUND */
            close cpk2_settori_amministrativi;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Gestioni Amministrative. La registrazione Settori Amministrativi non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "SETTORI_AMMINISTRATIVI"
         if  NEW_NI is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null) ) then
            open  cpk3_settori_amministrativi(NEW_NI);
            fetch cpk3_settori_amministrativi into dummy;
            found := cpk3_settori_amministrativi%FOUND; /* %FOUND */
            close cpk3_settori_amministrativi;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Settori Amministrativi non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "SETTORI_AMMINISTRATIVI" non modificabile se esistono referenze su "PERIODI_GIURIDICI"
      if (OLD_NUMERO != NEW_NUMERO) then
         open  cfk1_periodi_giuridici(OLD_NUMERO);
         fetch cfk1_periodi_giuridici into dummy;
         found := cfk1_periodi_giuridici%FOUND; /* %FOUND */
         close cfk1_periodi_giuridici;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su PERIODI_GIURIDICI. La registrazione di Settori Amministrativi non e'' modificabile.';
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
/* End Procedure: SETTORI_AMMINISTRATIVI_PU */
/
create or replace trigger SETTORI_AMMINISTRATIVI_TMB
   before INSERT or UPDATE on SETTORI_AMMINISTRATIVI
for each row
/******************************************************************************
 NOME:        SETTORI_AMMINISTRATIVI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table SETTORI_AMMINISTRATIVI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure SETTORI_AMMINISTRATIVI_PI e SETTORI_AMMINISTRATIVI_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         SETTORI_AMMINISTRATIVI_PU(:OLD.NUMERO
                       , :OLD.NI
                       , :OLD.CODICE
                       , :OLD.GESTIONE
                       , :OLD.SEDE
                         , :NEW.NUMERO
                         , :NEW.NI
                         , :NEW.CODICE
                         , :NEW.GESTIONE
                         , :NEW.SEDE
                         );
         null;
      end if;
      if INSERTING then
         SETTORI_AMMINISTRATIVI_PI(:NEW.NI,
                         :NEW.GESTIONE,
                         :NEW.SEDE);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "SETTORI_AMMINISTRATIVI"
            cursor cpk_settori_amministrativi(var_NUMERO number) is
               select 1
                 from   SETTORI_AMMINISTRATIVI
                where  NUMERO = var_NUMERO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "SETTORI_AMMINISTRATIVI"
               if :new.NUMERO is not null then
                  open  cpk_settori_amministrativi(:new.NUMERO);
                  fetch cpk_settori_amministrativi into dummy;
                  found := cpk_settori_amministrativi%FOUND;
                  close cpk_settori_amministrativi;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.NUMERO||
                               '" gia'' presente in Settori Amministrativi. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: SETTORI_AMMINISTRATIVI_TMB */
/
create or replace procedure SETTORI_AMMINISTRATIVI_PD
/******************************************************************************
 NOME:        SETTORI_AMMINISTRATIVI_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table SETTORI_AMMINISTRATIVI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SETTORI_AMMINISTRATIVI_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_numero IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "PERIODI_GIURIDICI"
   cursor cfk1_periodi_giuridici(var_numero number) is
      select 1
      from   PERIODI_GIURIDICI
      where  SETTORE = var_numero
       and   var_numero is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "SETTORI_AMMINISTRATIVI" if children still exist in "PERIODI_GIURIDICI"
      open  cfk1_periodi_giuridici(OLD_NUMERO);
      fetch cfk1_periodi_giuridici into dummy;
      found := cfk1_periodi_giuridici%FOUND; /* %FOUND */
      close cfk1_periodi_giuridici;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su PERIODI_GIURIDICI. La registrazione di Settori Amministrativi non e'' eliminabile.';
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
/* End Procedure: SETTORI_AMMINISTRATIVI_PD */
/
create or replace trigger SETTORI_AMMINISTRATIVI_TDB
   before DELETE on SETTORI_AMMINISTRATIVI
for each row
/******************************************************************************
 NOME:        SETTORI_AMMINISTRATIVI_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table SETTORI_AMMINISTRATIVI
 ANNOTAZIONI: Richiama Procedure SETTORI_AMMINISTRATIVI_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      SETTORI_AMMINISTRATIVI_PD(:OLD.NUMERO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: SETTORI_AMMINISTRATIVI_TDB */
/
CREATE OR REPLACE TRIGGER SETTORI_AMMINISTRATIVI_TMA
 AFTER INSERT OR UPDATE OR DELETE ON SETTORI_AMMINISTRATIVI
FOR EACH ROW
declare
   integrity_error exception;
   dummy      integer;
   found_asco boolean := false;
   found_pegi boolean := false;
   found_pere boolean := false;
   cursor cfk1_assegnazioni_contabili(var_settore number, var_sede number) is
      select 1
        from assegnazioni_contabili
       where settore = var_settore
         and sede = var_sede;
   cursor cfk2_periodi_giuridici(var_settore number, var_sede number) is
      select 1
        from periodi_giuridici
       where settore = var_settore
         and nvl(sede, 0) = var_sede
         and rilevanza in ('S', 'E');
   cursor cfk3_periodi_retributivi(var_settore number, var_sede number) is
      select 1
        from periodi_retributivi
       where settore = var_settore
         and sede = var_sede;
begin
   /* Creazione di un nuovo settore amministrativo. Inseriamo su Ripartizioni funzionali */
   if inserting then
      insert into ripartizioni_funzionali
         (settore
         ,sede)
         select :new.numero
               ,nvl(:new.sede, 0)
           from dual
          where not exists (select 'x'
                   from ripartizioni_funzionali
                  where settore = :new.numero
                    and sede = nvl(:new.sede, 0));
   end if;
   /* Att. 12602.0.7 - Modifica della sede primaria: se la precedente combinazione è utilizzata
      non viene eseguita l'update di RIFU ma un nuovo inserimento con la sede modificata
   */
   if updating then
      if (nvl(:old.sede, 0) != nvl(:new.sede, 0)) then
         open cfk1_assegnazioni_contabili(:old.numero, nvl(:old.sede, 0));
         fetch cfk1_assegnazioni_contabili
            into dummy;
         found_asco := cfk1_assegnazioni_contabili%found;
         close cfk1_assegnazioni_contabili;
         open cfk2_periodi_giuridici(:old.numero, :old.sede);
         fetch cfk2_periodi_giuridici
            into dummy;
         found_pegi := cfk2_periodi_giuridici%found;
         close cfk2_periodi_giuridici;
         open cfk3_periodi_retributivi(:old.numero, nvl(:old.sede, 0));
         fetch cfk3_periodi_retributivi
            into dummy;
         found_pere := cfk3_periodi_retributivi%found;
         close cfk3_periodi_retributivi;
      end if;
      if found_asco
         or found_pegi
         or found_pere then
         insert into ripartizioni_funzionali
            (settore
            ,sede)
            select :new.numero
                  ,nvl(:new.sede, 0)
              from dual
             where not exists (select 'x'
                      from ripartizioni_funzionali
                     where settore = :new.numero
                       and sede = nvl(:new.sede, 0));
      else
         update ripartizioni_funzionali rifu
            set sede = nvl(:new.sede, 0)
          where settore = :new.numero
            and sede = nvl(:old.sede, 0)
            and not exists (select 'x'
                   from ripartizioni_funzionali
                  where settore = :new.numero
                    and sede = nvl(:new.sede, 0));
      end if;
   end if;
   if deleting then
      delete from ripartizioni_funzionali
       where settore = :old.numero
         and sede = nvl(:old.sede, 0);
   end if;
end settori_amministrativi_tma;
/
create or replace procedure SUDDIVISIONI_STRUTTURA_PU
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table SUDDIVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_STRUTTURA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_ottica IN varchar
 , old_livello IN varchar
 , new_ottica IN varchar
 , new_livello IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "OTTICHE"
   cursor cpk1_suddivisioni_struttura(var_ottica varchar) is
      select 1
      from   OTTICHE
      where  OTTICA = var_ottica
       and   var_ottica is not null;
   --  Declaration of UpdateParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ottica varchar,
                   var_livello varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  OTTICA = var_ottica
       and   SUDDIVISIONE = var_livello
       and   var_ottica is not null
       and   var_livello is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "OTTICHE" deve esistere quando si modifica "SUDDIVISIONI_STRUTTURA"
         if  NEW_OTTICA is not null and ( seq = 0 )
         and (   (NEW_OTTICA != OLD_OTTICA or OLD_OTTICA is null) ) then
            open  cpk1_suddivisioni_struttura(NEW_OTTICA);
            fetch cpk1_suddivisioni_struttura into dummy;
            found := cpk1_suddivisioni_struttura%FOUND; /* %FOUND */
            close cpk1_suddivisioni_struttura;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Ottiche. La registrazione Suddivisioni Struttura non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "SUDDIVISIONI_STRUTTURA" non modificabile se esistono referenze su "UNITA_ORGANIZZATIVE"
      if (OLD_OTTICA != NEW_OTTICA) or
         (OLD_LIVELLO != NEW_LIVELLO) then
         open  cfk1_unita_organizzative(OLD_OTTICA,
                        OLD_LIVELLO);
         fetch cfk1_unita_organizzative into dummy;
         found := cfk1_unita_organizzative%FOUND; /* %FOUND */
         close cfk1_unita_organizzative;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Suddivisioni Struttura non e'' modificabile.';
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
/* End Procedure: SUDDIVISIONI_STRUTTURA_PU */
/
create or replace trigger SUDDIVISIONI_STRUTTURA_TMB
   before INSERT or UPDATE on SUDDIVISIONI_STRUTTURA
for each row
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table SUDDIVISIONI_STRUTTURA
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure SUDDIVISIONI_STRUTTURA_PI e SUDDIVISIONI_STRUTTURA_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if nvl(:NEW.UTENTE,' ') = nvl(:OLD.UTENTE,' ') then 
        :NEW.UTENTE := SI4.UTENTE; 
      end if; 
      if nvl(:NEW.DATA_AGG,SYSDATE) = nvl(:OLD.DATA_AGG,SYSDATE) then 
        :NEW.DATA_AGG := SYSDATE; 
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         SUDDIVISIONI_STRUTTURA_PU(:OLD.OTTICA
                       , :OLD.LIVELLO
                         , :NEW.OTTICA
                         , :NEW.LIVELLO
                         );
         null;
      end if;
	if INSERTING then
         SUDDIVISIONI_STRUTTURA_PI(:NEW.OTTICA);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "SUDDIVISIONI_STRUTTURA"
            cursor cpk_suddivisioni_struttura(var_OTTICA varchar,
                            var_LIVELLO varchar) is
               select 1
                 from   SUDDIVISIONI_STRUTTURA
                where  OTTICA = var_OTTICA and
                       LIVELLO = var_LIVELLO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "SUDDIVISIONI_STRUTTURA"
               if :new.OTTICA is not null and
                  :new.LIVELLO is not null then
                  open  cpk_suddivisioni_struttura(:new.OTTICA,
                                 :new.LIVELLO);
                  fetch cpk_suddivisioni_struttura into dummy;
                  found := cpk_suddivisioni_struttura%FOUND;
                  close cpk_suddivisioni_struttura;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.OTTICA||' '||
                               :new.LIVELLO||
                               '" gia'' presente in Suddivisioni Struttura. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: SUDDIVISIONI_STRUTTURA_TMB */
/
create or replace procedure SUDDIVISIONI_STRUTTURA_PI
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table SUDDIVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_STRUTTURA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ottica IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "OTTICHE"
   cursor cpk1_suddivisioni_struttura(var_ottica varchar) is
      select 1
      from   OTTICHE
      where  OTTICA = var_ottica
       and   var_ottica is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "OTTICHE" deve esistere quando si inserisce su "SUDDIVISIONI_STRUTTURA"
         if NEW_OTTICA is not null then
            open  cpk1_suddivisioni_struttura(NEW_OTTICA);
            fetch cpk1_suddivisioni_struttura into dummy;
            found := cpk1_suddivisioni_struttura%FOUND; /* %FOUND */
            close cpk1_suddivisioni_struttura;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Ottiche. La registrazione Suddivisioni Struttura non puo'' essere inserita.';
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
/* End Procedure: SUDDIVISIONI_STRUTTURA_PI */
/
create or replace procedure SUDDIVISIONI_STRUTTURA_PD
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table SUDDIVISIONI_STRUTTURA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger SUDDIVISIONI_STRUTTURA_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_ottica IN varchar,
 old_livello IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "UNITA_ORGANIZZATIVE"
   cursor cfk1_unita_organizzative(var_ottica varchar,
                   var_livello varchar) is
      select 1
      from   UNITA_ORGANIZZATIVE
      where  OTTICA = var_ottica
       and   SUDDIVISIONE = var_livello
       and   var_ottica is not null
       and   var_livello is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "SUDDIVISIONI_STRUTTURA" if children still exist in "UNITA_ORGANIZZATIVE"
      open  cfk1_unita_organizzative(OLD_OTTICA,
                     OLD_LIVELLO);
      fetch cfk1_unita_organizzative into dummy;
      found := cfk1_unita_organizzative%FOUND; /* %FOUND */
      close cfk1_unita_organizzative;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Unità Organizzative. La registrazione di Suddivisioni Struttura non e'' eliminabile.';
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
/* End Procedure: SUDDIVISIONI_STRUTTURA_PD */
/
create or replace trigger SUDDIVISIONI_STRUTTURA_TDB
   before DELETE on SUDDIVISIONI_STRUTTURA
for each row
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table SUDDIVISIONI_STRUTTURA
 ANNOTAZIONI: Richiama Procedure SUDDIVISIONI_STRUTTURA_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      SUDDIVISIONI_STRUTTURA_PD(:OLD.OTTICA,
                    :OLD.LIVELLO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: SUDDIVISIONI_STRUTTURA_TDB */
/
CREATE OR REPLACE TRIGGER SUDDIVISIONI_STRUTTURA_TMA
AFTER INSERT OR UPDATE OR DELETE ON SUDDIVISIONI_STRUTTURA
FOR EACH ROW
/******************************************************************************
 NOME:        SUDDIVISIONI_STRUTTURA_TMA
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                       at INSERT or UPDATE on Table SUDDIVISIONI_STRUTTURA
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generato in automatico.
 1.1  17/11/2006 MS     Sistemazione substr
******************************************************************************/
declare
	dep_nota			varchar2(14);
	dep_nota_o			varchar2(14);
begin
if IntegrityPackage.GetNestLevel = 0 then
     IntegrityPackage.NEXTNESTLEVEL;
	 dep_nota 				:= 'NOTA_';
	 dep_nota_o				:= 'NOTA_';
	 if (:new.livello = 0) then dep_nota:=dep_nota||'GESTIONE';
	 elsif (:new.livello = 1) then dep_nota:=dep_nota||'SETTORE_A';
	 elsif (:new.livello = 2) then dep_nota:=dep_nota||'SETTORE_B';
	 elsif (:new.livello = 3) then dep_nota:=dep_nota||'SETTORE_C';
	 elsif (:new.livello = 4) then dep_nota:=dep_nota||'SETTORE';
	 end if;
	 if (:old.livello = 0) then dep_nota_o:=dep_nota_o||'GESTIONE';
	 elsif (:old.livello = 1) then dep_nota_o:=dep_nota_o||'SETTORE_A';
	 elsif (:old.livello = 2) then dep_nota_o:=dep_nota_o||'SETTORE_B';
	 elsif (:old.livello = 3) then dep_nota_o:=dep_nota_o||'SETTORE_C';
	 elsif (:old.livello = 4) then dep_nota_o:=dep_nota_o||'SETTORE';
	 end if;
	 if (:old.ottica = 'GP4') then
     if inserting and (:new.livello < 5) then
        SI4.SQL_EXECUTE('update ENTE set '||dep_nota||' = ' ||''''||replace(substr(:new.denominazione,1,15),'''','''''')||'''');
     end if;
     if updating and (:old.livello < 5) then
       if (:new.livello < 5) then
         SI4.SQL_EXECUTE('update ENTE set '||dep_nota||' = ' ||''''||replace(substr(:new.denominazione,1,15),'''','''''')||'''');
       end if;
     end if;
     if deleting then
        if (:old.livello < 5) then
          SI4.SQL_EXECUTE('update ENTE set '||dep_nota_o||' = ' ||'TO_CHAR(null)');
        end if;
      end if;
	 end if;
       IntegrityPackage.PREVIOUSNESTLEVEL;
   end if;
   exception
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/


create or replace procedure TIPI_INCARICO_PU
/******************************************************************************
 NOME:        TIPI_INCARICO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table TIPI_INCARICO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_INCARICO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_incarico IN varchar
 , new_incarico IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "COMPONENTI"
   cursor cfk1_componenti(var_incarico varchar) is
      select 1
      from   COMPONENTI
      where  INCARICO = var_incarico
       and   var_incarico is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "TIPI_INCARICO" non modificabile se esistono referenze su "COMPONENTI"
      if (OLD_INCARICO != NEW_INCARICO) then
         open  cfk1_componenti(OLD_INCARICO);
         fetch cfk1_componenti into dummy;
         found := cfk1_componenti%FOUND; /* %FOUND */
         close cfk1_componenti;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Componenti. La registrazione di Tipi Incarico non e'' modificabile.';
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
/* End Procedure: TIPI_INCARICO_PU */
/
create or replace trigger TIPI_INCARICO_TMB
   before INSERT or UPDATE on TIPI_INCARICO
for each row
/******************************************************************************
 NOME:        TIPI_INCARICO_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table TIPI_INCARICO
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure TIPI_INCARICO_PI e TIPI_INCARICO_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         TIPI_INCARICO_PU(:OLD.INCARICO
                         , :NEW.INCARICO
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "TIPI_INCARICO"
            cursor cpk_tipi_incarico(var_INCARICO varchar) is
               select 1
                 from   TIPI_INCARICO
                where  INCARICO = var_INCARICO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "TIPI_INCARICO"
               if :new.INCARICO is not null then
                  open  cpk_tipi_incarico(:new.INCARICO);
                  fetch cpk_tipi_incarico into dummy;
                  found := cpk_tipi_incarico%FOUND;
                  close cpk_tipi_incarico;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.INCARICO||
                               '" gia'' presente in Tipi Incarico. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: TIPI_INCARICO_TMB */
/
create or replace procedure TIPI_INCARICO_PD
/******************************************************************************
 NOME:        TIPI_INCARICO_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table TIPI_INCARICO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_INCARICO_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_incarico IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "COMPONENTI"
   cursor cfk1_componenti(var_incarico varchar) is
      select 1
      from   COMPONENTI
      where  INCARICO = var_incarico
       and   var_incarico is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "TIPI_INCARICO" if children still exist in "COMPONENTI"
      open  cfk1_componenti(OLD_INCARICO);
      fetch cfk1_componenti into dummy;
      found := cfk1_componenti%FOUND; /* %FOUND */
      close cfk1_componenti;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Componenti. La registrazione di Tipi Incarico non e'' eliminabile.';
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
/* End Procedure: TIPI_INCARICO_PD */
/
create or replace trigger TIPI_INCARICO_TDB
   before DELETE on TIPI_INCARICO
for each row
/******************************************************************************
 NOME:        TIPI_INCARICO_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table TIPI_INCARICO
 ANNOTAZIONI: Richiama Procedure TIPI_INCARICO_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      TIPI_INCARICO_PD(:OLD.INCARICO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: TIPI_INCARICO_TDB */
/

create or replace procedure TIPI_SOGGETTO_PU
/******************************************************************************
 NOME:        TIPI_SOGGETTO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table TIPI_SOGGETTO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_SOGGETTO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_tipo_soggetto IN varchar
 , new_tipo_soggetto IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "ANAGRAFICI"
   cursor cfk1_anagrafici(var_tipo_soggetto varchar) is
      select 1
      from   ANAGRAFICI
      where  TIPO_SOGGETTO = var_tipo_soggetto
       and   var_tipo_soggetto is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "TIPI_SOGGETTO" non modificabile se esistono referenze su "ANAGRAFICI"
      if (OLD_TIPO_SOGGETTO != NEW_TIPO_SOGGETTO) then
         open  cfk1_anagrafici(OLD_TIPO_SOGGETTO);
         fetch cfk1_anagrafici into dummy;
         found := cfk1_anagrafici%FOUND; /* %FOUND */
         close cfk1_anagrafici;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Anagrafici (ANAGRAFE_SOGGETTI). La registrazione di Tipi Soggetto non e'' modificabile.';
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
/* End Procedure: TIPI_SOGGETTO_PU */
/

create or replace trigger TIPI_SOGGETTO_TMB
   before INSERT or UPDATE on TIPI_SOGGETTO
for each row
/******************************************************************************
 NOME:        TIPI_SOGGETTO_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table TIPI_SOGGETTO
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure TIPI_SOGGETTO_PI e TIPI_SOGGETTO_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         TIPI_SOGGETTO_PU(:OLD.TIPO_SOGGETTO
                         , :NEW.TIPO_SOGGETTO
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "TIPI_SOGGETTO"
            cursor cpk_tipi_soggetto(var_TIPO_SOGGETTO varchar) is
               select 1
                 from   TIPI_SOGGETTO
                where  TIPO_SOGGETTO = var_TIPO_SOGGETTO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "TIPI_SOGGETTO"
               if :new.TIPO_SOGGETTO is not null then
                  open  cpk_tipi_soggetto(:new.TIPO_SOGGETTO);
                  fetch cpk_tipi_soggetto into dummy;
                  found := cpk_tipi_soggetto%FOUND;
                  close cpk_tipi_soggetto;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.TIPO_SOGGETTO||
                               '" gia'' presente in Tipi Soggetto. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: TIPI_SOGGETTO_TMB */
/

create or replace procedure TIPI_SOGGETTO_PD
/******************************************************************************
 NOME:        TIPI_SOGGETTO_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table TIPI_SOGGETTO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_SOGGETTO_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_tipo_soggetto IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ANAGRAFICI"
   cursor cfk1_anagrafici(var_tipo_soggetto varchar) is
      select 1
      from   ANAGRAFICI
      where  TIPO_SOGGETTO = var_tipo_soggetto
       and   var_tipo_soggetto is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "TIPI_SOGGETTO" if children still exist in "ANAGRAFICI"
      open  cfk1_anagrafici(OLD_TIPO_SOGGETTO);
      fetch cfk1_anagrafici into dummy;
      found := cfk1_anagrafici%FOUND; /* %FOUND */
      close cfk1_anagrafici;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Anagrafici (ANAGRAFE_SOGGETTI). La registrazione di Tipi Soggetto non e'' eliminabile.';
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
/* End Procedure: TIPI_SOGGETTO_PD */
/

create or replace trigger TIPI_SOGGETTO_TDB
   before DELETE on TIPI_SOGGETTO
for each row
/******************************************************************************
 NOME:        TIPI_SOGGETTO_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table TIPI_SOGGETTO
 ANNOTAZIONI: Richiama Procedure TIPI_SOGGETTO_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      TIPI_SOGGETTO_PD(:OLD.TIPO_SOGGETTO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: TIPI_SOGGETTO_TDB */
/

create or replace procedure TIPI_TITOLO_PU
/******************************************************************************
 NOME:        TIPI_TITOLO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table TIPI_TITOLO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_TITOLO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_titolo IN varchar
 , new_titolo IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "COMPONENTI"
   cursor cfk1_componenti(var_titolo varchar) is
      select 1
      from   COMPONENTI
      where  TITOLO = var_titolo
       and   var_titolo is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "TIPI_TITOLO" non modificabile se esistono referenze su "COMPONENTI"
      if (OLD_TITOLO != NEW_TITOLO) then
         open  cfk1_componenti(OLD_TITOLO);
         fetch cfk1_componenti into dummy;
         found := cfk1_componenti%FOUND; /* %FOUND */
         close cfk1_componenti;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Componenti. La registrazione di Tipi Titolo non e'' modificabile.';
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
/* End Procedure: TIPI_TITOLO_PU */
/
create or replace trigger TIPI_TITOLO_TMB
   before INSERT or UPDATE on TIPI_TITOLO
for each row
/******************************************************************************
 NOME:        TIPI_TITOLO_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table TIPI_TITOLO
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure TIPI_TITOLO_PI e TIPI_TITOLO_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      /* NONE */ null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         TIPI_TITOLO_PU(:OLD.TITOLO
                         , :NEW.TITOLO
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "TIPI_TITOLO"
            cursor cpk_tipi_titolo(var_TITOLO varchar) is
               select 1
                 from   TIPI_TITOLO
                where  TITOLO = var_TITOLO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "TIPI_TITOLO"
               if :new.TITOLO is not null then
                  open  cpk_tipi_titolo(:new.TITOLO);
                  fetch cpk_tipi_titolo into dummy;
                  found := cpk_tipi_titolo%FOUND;
                  close cpk_tipi_titolo;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.TITOLO||
                               '" gia'' presente in Tipi Titolo. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: TIPI_TITOLO_TMB */
/
create or replace procedure TIPI_TITOLO_PD
/******************************************************************************
 NOME:        TIPI_TITOLO_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table TIPI_TITOLO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_TITOLO_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_titolo IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "COMPONENTI"
   cursor cfk1_componenti(var_titolo varchar) is
      select 1
      from   COMPONENTI
      where  TITOLO = var_titolo
       and   var_titolo is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "TIPI_TITOLO" if children still exist in "COMPONENTI"
      open  cfk1_componenti(OLD_TITOLO);
      fetch cfk1_componenti into dummy;
      found := cfk1_componenti%FOUND; /* %FOUND */
      close cfk1_componenti;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Componenti. La registrazione di Tipi Titolo non e'' eliminabile.';
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
/* End Procedure: TIPI_TITOLO_PD */
/
create or replace trigger TIPI_TITOLO_TDB
   before DELETE on TIPI_TITOLO
for each row
/******************************************************************************
 NOME:        TIPI_TITOLO_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table TIPI_TITOLO
 ANNOTAZIONI: Richiama Procedure TIPI_TITOLO_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      TIPI_TITOLO_PD(:OLD.TITOLO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: TIPI_TITOLO_TDB */
/
create or replace procedure UNITA_ORGANIZZATIVE_PU
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table UNITA_ORGANIZZATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger UNITA_ORGANIZZATIVE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_ottica IN varchar
 , old_revisione IN number
 , old_ni IN number
 , old_dal IN date
 , old_codice_amministrazione IN varchar
 , old_amm_dal IN date
 , old_codice_aoo IN varchar
 , old_aoo_dal IN date
 , old_unita_padre IN number
 , old_unita_padre_ottica IN varchar
 , old_unita_padre_dal IN date
 , old_sede IN number
 , old_suddivisione IN varchar
 , new_ottica IN varchar
 , new_revisione IN number
 , new_ni IN number
 , new_dal IN date
 , new_codice_amministrazione IN varchar
 , new_amm_dal IN date
 , new_codice_aoo IN varchar
 , new_aoo_dal IN date
 , new_unita_padre IN number
 , new_unita_padre_ottica IN varchar
 , new_unita_padre_dal IN date
 , new_sede IN number
 , new_suddivisione IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "REVISIONI_STRUTTURA"
   cursor cpk2_unita_organizzative(var_revisione number,
                   var_ottica varchar) is
      select 1
      from   REVISIONI_STRUTTURA
      where  REVISIONE = var_revisione
       and   OTTICA = var_ottica
       and   var_revisione is not null
       and   var_ottica is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "SUDDIVISIONI_STRUTTURA"
   cursor cpk3_unita_organizzative(var_ottica varchar,
                   var_suddivisione varchar) is
      select 1
      from   SUDDIVISIONI_STRUTTURA
      where  OTTICA = var_ottica
       and   LIVELLO = var_suddivisione
       and   var_ottica is not null
       and   var_suddivisione is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk4_unita_organizzative(var_sede number) is
      select 1
      from   ANAGRAFE
      where  NI = var_sede
       and   var_sede is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "OTTICHE"
   cursor cpk5_unita_organizzative(var_ottica varchar) is
      select 1
      from   OTTICHE
      where  OTTICA = var_ottica
       and   var_ottica is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "AMMINISTRAZIONI"
   cursor cpk6_unita_organizzative(var_amm_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  DAL = var_amm_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_amm_dal is not null
       and   var_codice_amministrazione is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "AOO"
   cursor cpk7_unita_organizzative(var_codice_amministrazione varchar,
                   var_amm_dal date,
                   var_codice_aoo varchar,
                   var_aoo_dal date) is
      select 1
      from   AOO
      where  CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   AMM_DAL = var_amm_dal
       and   CODICE_AOO = var_codice_aoo
       and   DAL = var_aoo_dal
       and   var_codice_amministrazione is not null
       and   var_amm_dal is not null
       and   var_codice_aoo is not null
       and   var_aoo_dal is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFE"
   cursor cpk8_unita_organizzative(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ANAGRAFICI"
   cursor cpk9_unita_organizzative(var_sede number) is
      select 1
      from   ANAGRAFICI
      where  NI = var_sede
       and   var_sede is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_REVISIONE is not null and
             NEW_OTTICA is not null and ( seq = 0 )
         and (   (NEW_REVISIONE != OLD_REVISIONE or OLD_REVISIONE is null)
              or (NEW_OTTICA != OLD_OTTICA or OLD_OTTICA is null) ) then
            open  cpk2_unita_organizzative(NEW_REVISIONE,
                           NEW_OTTICA);
            fetch cpk2_unita_organizzative into dummy;
            found := cpk2_unita_organizzative%FOUND; /* %FOUND */
            close cpk2_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Unità Organizzative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "SUDDIVISIONI_STRUTTURA" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_OTTICA is not null and
             NEW_SUDDIVISIONE is not null and ( seq = 0 )
         and (   (NEW_OTTICA != OLD_OTTICA or OLD_OTTICA is null)
              or (NEW_SUDDIVISIONE != OLD_SUDDIVISIONE or OLD_SUDDIVISIONE is null) ) then
            open  cpk3_unita_organizzative(NEW_OTTICA,
                           NEW_SUDDIVISIONE);
            fetch cpk3_unita_organizzative into dummy;
            found := cpk3_unita_organizzative%FOUND; /* %FOUND */
            close cpk3_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Suddivisioni Struttura. La registrazione Unità Organizzative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_SEDE is not null and ( seq = 0 )
         and (   (NEW_SEDE != OLD_SEDE or OLD_SEDE is null) ) then
            open  cpk4_unita_organizzative(NEW_SEDE);
            fetch cpk4_unita_organizzative into dummy;
            found := cpk4_unita_organizzative%FOUND; /* %FOUND */
            close cpk4_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Unità Organizzative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "OTTICHE" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_OTTICA is not null and ( seq = 0 )
         and (   (NEW_OTTICA != OLD_OTTICA or OLD_OTTICA is null) ) then
            open  cpk5_unita_organizzative(NEW_OTTICA);
            fetch cpk5_unita_organizzative into dummy;
            found := cpk5_unita_organizzative%FOUND; /* %FOUND */
            close cpk5_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Ottiche. La registrazione Unità Organizzative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_AMM_DAL is not null and
             NEW_CODICE_AMMINISTRAZIONE is not null and ( seq = 0 )
         and (   (NEW_AMM_DAL != OLD_AMM_DAL or OLD_AMM_DAL is null)
              or (NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE or OLD_CODICE_AMMINISTRAZIONE is null) ) then
            open  cpk6_unita_organizzative(NEW_AMM_DAL,
                           NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk6_unita_organizzative into dummy;
            found := cpk6_unita_organizzative%FOUND; /* %FOUND */
            close cpk6_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Unità Organizzative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AOO" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_CODICE_AMMINISTRAZIONE is not null and
             NEW_AMM_DAL is not null and
             NEW_CODICE_AOO is not null and
             NEW_AOO_DAL is not null and ( seq = 0 )
         and (   (NEW_CODICE_AMMINISTRAZIONE != OLD_CODICE_AMMINISTRAZIONE or OLD_CODICE_AMMINISTRAZIONE is null)
              or (NEW_AMM_DAL != OLD_AMM_DAL or OLD_AMM_DAL is null)
              or (NEW_CODICE_AOO != OLD_CODICE_AOO or OLD_CODICE_AOO is null)
              or (NEW_AOO_DAL != OLD_AOO_DAL or OLD_AOO_DAL is null) ) then
            open  cpk7_unita_organizzative(NEW_CODICE_AMMINISTRAZIONE,
                           NEW_AMM_DAL,
                           NEW_CODICE_AOO,
                           NEW_AOO_DAL);
            fetch cpk7_unita_organizzative into dummy;
            found := cpk7_unita_organizzative%FOUND; /* %FOUND */
            close cpk7_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su AOO. La registrazione Unità Organizzative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_NI is not null and ( seq = 0 )
         and (   (NEW_NI != OLD_NI or OLD_NI is null) ) then
            open  cpk8_unita_organizzative(NEW_NI);
            fetch cpk8_unita_organizzative into dummy;
            found := cpk8_unita_organizzative%FOUND; /* %FOUND */
            close cpk8_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Unità Organizzative non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFICI" deve esistere quando si modifica "UNITA_ORGANIZZATIVE"
         if  NEW_SEDE is not null and ( seq = 0 )
         and (   (NEW_SEDE != OLD_SEDE or OLD_SEDE is null) ) then
            open  cpk9_unita_organizzative(NEW_SEDE);
            fetch cpk9_unita_organizzative into dummy;
            found := cpk9_unita_organizzative%FOUND; /* %FOUND */
            close cpk9_unita_organizzative;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su Anagrafici (ANAGRAFE_SOGGETTI). La registrazione Unità Organizzative non e'' modificabile.';
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
/* End Procedure: UNITA_ORGANIZZATIVE_PU */
/
create or replace trigger UNITA_ORGANIZZATIVE_TMB
   before INSERT or UPDATE on UNITA_ORGANIZZATIVE
for each row
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table UNITA_ORGANIZZATIVE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure UNITA_ORGANIZZATIVE_PI e UNITA_ORGANIZZATIVE_PU
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
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if nvl(:NEW.UTENTE,' ') = nvl(:OLD.UTENTE,' ') then
        :NEW.UTENTE := SI4.UTENTE;
      end if;
      if nvl(:NEW.DATA_AGG,SYSDATE) = nvl(:OLD.DATA_AGG,SYSDATE) then
        :NEW.DATA_AGG := SYSDATE;
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         UNITA_ORGANIZZATIVE_PU(:OLD.OTTICA
                       , :OLD.REVISIONE
                       , :OLD.NI
                       , :OLD.DAL
                       , :OLD.CODICE_AMMINISTRAZIONE
                       , :OLD.AMM_DAL
                       , :OLD.CODICE_AOO
                       , :OLD.AOO_DAL
                       , :OLD.UNITA_PADRE
                       , :OLD.UNITA_PADRE_OTTICA
                       , :OLD.UNITA_PADRE_DAL
                       , :OLD.SEDE
                       , :OLD.SUDDIVISIONE
                         , :NEW.OTTICA
                         , :NEW.REVISIONE
                         , :NEW.NI
                         , :NEW.DAL
                         , :NEW.CODICE_AMMINISTRAZIONE
                         , :NEW.AMM_DAL
                         , :NEW.CODICE_AOO
                         , :NEW.AOO_DAL
                         , :NEW.UNITA_PADRE
                         , :NEW.UNITA_PADRE_OTTICA
                         , :NEW.UNITA_PADRE_DAL
                         , :NEW.SEDE
                         , :NEW.SUDDIVISIONE
                         );
         null;
      end if;
	if INSERTING then
         UNITA_ORGANIZZATIVE_PI(:NEW.OTTICA,
                         :NEW.REVISIONE,
                         :NEW.NI,
                         :NEW.CODICE_AMMINISTRAZIONE,
                         :NEW.AMM_DAL,
                         :NEW.CODICE_AOO,
                         :NEW.AOO_DAL,
                         :NEW.UNITA_PADRE,
                         :NEW.UNITA_PADRE_OTTICA,
                         :NEW.UNITA_PADRE_DAL,
                         :NEW.SEDE,
                         :NEW.SUDDIVISIONE);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "UNITA_ORGANIZZATIVE"
            cursor cpk_unita_organizzative(var_OTTICA varchar,
                            var_REVISIONE number,
                            var_NI number,
                            var_DAL date) is
               select 1
                 from   UNITA_ORGANIZZATIVE
                where  OTTICA = var_OTTICA and
                       REVISIONE = var_REVISIONE and
                       NI = var_NI and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "UNITA_ORGANIZZATIVE"
               if :new.OTTICA is not null and
                  :new.REVISIONE is not null and
                  :new.NI is not null and
                  :new.DAL is not null then
                  open  cpk_unita_organizzative(:new.OTTICA,
                                 :new.REVISIONE,
                                 :new.NI,
                                 :new.DAL);
                  fetch cpk_unita_organizzative into dummy;
                  found := cpk_unita_organizzative%FOUND;
                  close cpk_unita_organizzative;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.OTTICA||' '||
                               :new.REVISIONE||' '||
                               :new.NI||' '||
                               :new.DAL||
                               '" gia'' presente in Unità Organizzative. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
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
/* End Trigger: UNITA_ORGANIZZATIVE_TMB */
/
create or replace trigger UNITA_ORGANIZZATIVE_TB
   before INSERT or UPDATE or DELETE on UNITA_ORGANIZZATIVE
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_TB
 DESCRIZIONE: Trigger for Custom Functional Check
                       at INSERT or UPDATE or DELETE on Table UNITA_ORGANIZZATIVE
              
 ANNOTAZIONI: Esegue inizializzazione tabella di POST Event. 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    __/__/____ __     Prima emissione.
******************************************************************************/
BEGIN
   /* RESET PostEvent for Custom Functional Check */
   IF IntegrityPackage.GetNestLevel = 0 THEN 
      IntegrityPackage.InitNestLevel;
   END IF;
END;
/* End Trigger: UNITA_ORGANIZZATIVE_TB */
/
create or replace trigger UNITA_ORGANIZZATIVE_TC
   after INSERT or UPDATE or DELETE on UNITA_ORGANIZZATIVE
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_TC
 DESCRIZIONE: Trigger for Custom Functional Check
                    after INSERT or UPDATE or DELETE on Table UNITA_ORGANIZZATIVE

 ANNOTAZIONI: Esegue operazioni di POST Event prenotate.  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    __/__/____ __     Prima emissione.
******************************************************************************/
BEGIN
   /* EXEC PostEvent for Custom Functional Check */
   IntegrityPackage.Exec_PostEvent;
END;
/* End Trigger: UNITA_ORGANIZZATIVE_TC */
/
create or replace procedure UNITA_ORGANIZZATIVE_PI
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table UNITA_ORGANIZZATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger UNITA_ORGANIZZATIVE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ottica IN varchar,
 new_revisione IN number,
 new_ni IN number,
 new_codice_amministrazione IN varchar,
 new_amm_dal IN date,
 new_codice_aoo IN varchar,
 new_aoo_dal IN date,
 new_unita_padre IN number,
 new_unita_padre_ottica IN varchar,
 new_unita_padre_dal IN date,
 new_sede IN number,
 new_suddivisione IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "REVISIONI_STRUTTURA"
   cursor cpk2_unita_organizzative(var_revisione number,
                   var_ottica varchar) is
      select 1
      from   REVISIONI_STRUTTURA
      where  REVISIONE = var_revisione
       and   OTTICA = var_ottica
       and   var_revisione is not null
       and   var_ottica is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "SUDDIVISIONI_STRUTTURA"
   cursor cpk3_unita_organizzative(var_ottica varchar,
                   var_suddivisione varchar) is
      select 1
      from   SUDDIVISIONI_STRUTTURA
      where  OTTICA = var_ottica
       and   LIVELLO = var_suddivisione
       and   var_ottica is not null
       and   var_suddivisione is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk4_unita_organizzative(var_sede number) is
      select 1
      from   ANAGRAFE
      where  NI = var_sede
       and   var_sede is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "OTTICHE"
   cursor cpk5_unita_organizzative(var_ottica varchar) is
      select 1
      from   OTTICHE
      where  OTTICA = var_ottica
       and   var_ottica is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "AMMINISTRAZIONI"
   cursor cpk6_unita_organizzative(var_amm_dal date,
                   var_codice_amministrazione varchar) is
      select 1
      from   AMMINISTRAZIONI
      where  DAL = var_amm_dal
       and   CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   var_amm_dal is not null
       and   var_codice_amministrazione is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "AOO"
   cursor cpk7_unita_organizzative(var_codice_amministrazione varchar,
                   var_amm_dal date,
                   var_codice_aoo varchar,
                   var_aoo_dal date) is
      select 1
      from   AOO
      where  CODICE_AMMINISTRAZIONE = var_codice_amministrazione
       and   AMM_DAL = var_amm_dal
       and   CODICE_AOO = var_codice_aoo
       and   DAL = var_aoo_dal
       and   var_codice_amministrazione is not null
       and   var_amm_dal is not null
       and   var_codice_aoo is not null
       and   var_aoo_dal is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFE"
   cursor cpk8_unita_organizzative(var_ni number) is
      select 1
      from   ANAGRAFE
      where  NI = var_ni
       and   var_ni is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ANAGRAFICI"
   cursor cpk9_unita_organizzative(var_sede number) is
      select 1
      from   ANAGRAFICI
      where  NI = var_sede
       and   var_sede is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "REVISIONI_STRUTTURA" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_REVISIONE is not null and
            NEW_OTTICA is not null then
            open  cpk2_unita_organizzative(NEW_REVISIONE,
                           NEW_OTTICA);
            fetch cpk2_unita_organizzative into dummy;
            found := cpk2_unita_organizzative%FOUND; /* %FOUND */
            close cpk2_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Revisioni Struttura. La registrazione Unità Organizzative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "SUDDIVISIONI_STRUTTURA" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_OTTICA is not null and
            NEW_SUDDIVISIONE is not null then
            open  cpk3_unita_organizzative(NEW_OTTICA,
                           NEW_SUDDIVISIONE);
            fetch cpk3_unita_organizzative into dummy;
            found := cpk3_unita_organizzative%FOUND; /* %FOUND */
            close cpk3_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Suddivisioni Struttura. La registrazione Unità Organizzative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_SEDE is not null then
            open  cpk4_unita_organizzative(NEW_SEDE);
            fetch cpk4_unita_organizzative into dummy;
            found := cpk4_unita_organizzative%FOUND; /* %FOUND */
            close cpk4_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Unità Organizzative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "OTTICHE" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_OTTICA is not null then
            open  cpk5_unita_organizzative(NEW_OTTICA);
            fetch cpk5_unita_organizzative into dummy;
            found := cpk5_unita_organizzative%FOUND; /* %FOUND */
            close cpk5_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Ottiche. La registrazione Unità Organizzative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AMMINISTRAZIONI" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_AMM_DAL is not null and
            NEW_CODICE_AMMINISTRAZIONE is not null then
            open  cpk6_unita_organizzative(NEW_AMM_DAL,
                           NEW_CODICE_AMMINISTRAZIONE);
            fetch cpk6_unita_organizzative into dummy;
            found := cpk6_unita_organizzative%FOUND; /* %FOUND */
            close cpk6_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Amministrazioni. La registrazione Unità Organizzative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "AOO" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_CODICE_AMMINISTRAZIONE is not null and
            NEW_AMM_DAL is not null and
            NEW_CODICE_AOO is not null and
            NEW_AOO_DAL is not null then
            open  cpk7_unita_organizzative(NEW_CODICE_AMMINISTRAZIONE,
                           NEW_AMM_DAL,
                           NEW_CODICE_AOO,
                           NEW_AOO_DAL);
            fetch cpk7_unita_organizzative into dummy;
            found := cpk7_unita_organizzative%FOUND; /* %FOUND */
            close cpk7_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su AOO. La registrazione Unità Organizzative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFE" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_NI is not null then
            open  cpk8_unita_organizzative(NEW_NI);
            fetch cpk8_unita_organizzative into dummy;
            found := cpk8_unita_organizzative%FOUND; /* %FOUND */
            close cpk8_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ANAGRAFE. La registrazione Unità Organizzative non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ANAGRAFICI" deve esistere quando si inserisce su "UNITA_ORGANIZZATIVE"
         if NEW_SEDE is not null then
            open  cpk9_unita_organizzative(NEW_SEDE);
            fetch cpk9_unita_organizzative into dummy;
            found := cpk9_unita_organizzative%FOUND; /* %FOUND */
            close cpk9_unita_organizzative;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su Anagrafici (ANAGRAFE_SOGGETTI). La registrazione Unità Organizzative non puo'' essere inserita.';
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
/* End Procedure: UNITA_ORGANIZZATIVE_PI */
/
create or replace procedure UNITA_ORGANIZZATIVE_PD
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table UNITA_ORGANIZZATIVE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger UNITA_ORGANIZZATIVE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_ottica IN varchar,
 old_revisione IN number,
 old_ni IN number,
 old_dal IN date)
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
/* End Procedure: UNITA_ORGANIZZATIVE_PD */
/
create or replace trigger UNITA_ORGANIZZATIVE_TDB
   before DELETE on UNITA_ORGANIZZATIVE
for each row
/******************************************************************************
 NOME:        UNITA_ORGANIZZATIVE_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table UNITA_ORGANIZZATIVE
 ANNOTAZIONI: Richiama Procedure UNITA_ORGANIZZATIVE_TD
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
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
      UNITA_ORGANIZZATIVE_PD(:OLD.OTTICA,
                    :OLD.REVISIONE,
                    :OLD.NI,
                    :OLD.DAL);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: UNITA_ORGANIZZATIVE_TDB */
/
create or replace procedure ripartizioni_funzionali_pu
/******************************************************************************
    NOME:        RIPARTIZIONI_FUNZIONALI_PU
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                    MM     Att. 12602.0.4
                    MM     Att. 12602.0.7
   ******************************************************************************/
(
   old_settore in number
  ,old_sede    in number
  ,new_settore in number
  ,new_sede    in number
) is
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;
   seq    number;
   mutating exception;
   pragma exception_init(mutating, -4091);
   cursor cfk1_assegnazioni_contabili(var_settore number, var_sede number) is
      select 1
        from assegnazioni_contabili
       where settore = var_settore
         and sede = var_sede;
   cursor cfk2_periodi_giuridici(var_settore number, var_sede number) is
      select 1
        from periodi_giuridici
       where settore = var_settore
         and nvl(sede, 0) = var_sede
         and rilevanza in ('S', 'E');
   cursor cfk3_periodi_retributivi(var_settore number, var_sede number) is
      select 1
        from periodi_retributivi
       where settore = var_settore
         and sede = var_sede;
begin
   begin
      seq := integritypackage.getnestlevel;
      if (old_settore != new_settore or old_sede != new_sede) then
         open cfk1_assegnazioni_contabili(old_settore, old_sede);
         fetch cfk1_assegnazioni_contabili
            into dummy;
         found := cfk1_assegnazioni_contabili%found;
         close cfk1_assegnazioni_contabili;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Assegnazioni Contabili. La registrazione di Ripartizioni Funzionali non e'' modificabile.';
            raise integrity_error;
         end if;
         open cfk2_periodi_giuridici(old_settore, old_sede);
         fetch cfk2_periodi_giuridici
            into dummy;
         found := cfk2_periodi_giuridici%found;
         close cfk2_periodi_giuridici;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Periodi Giuridici. La registrazione di Ripartizioni Funzionali non e'' modificabile.';
            raise integrity_error;
         end if;
         open cfk3_periodi_retributivi(old_settore, old_sede);
         fetch cfk3_periodi_retributivi
            into dummy;
         found := cfk3_periodi_retributivi%found;
         close cfk3_periodi_retributivi;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su Periodi Retributivi. La registrazione di Ripartizioni Funzionali non e'' modificabile.';
            raise integrity_error;
         end if;
      end if;
      null;
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
create or replace procedure ripartizioni_funzionali_pd
/******************************************************************************
    NOME:        RIPARTIZIONI_FUNZIONALI_PD
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
                    MM     Att. 12602.0.4
   ******************************************************************************/
(
   old_settore in number
  ,old_sede    in number
) is
   integrity_error exception;
   errno  integer;
   errmsg char(200);
   dummy  integer;
   found  boolean;
   cursor cfk1_assegnazioni_contabili(var_settore number, var_sede number) is
      select 1
        from assegnazioni_contabili
       where settore = var_settore
         and sede = var_sede;
   cursor cfk2_periodi_giuridici(var_settore number, var_sede number) is
      select 1
        from periodi_giuridici
       where settore = var_settore
         and nvl(sede, 0) = var_sede
         and rilevanza in ('S', 'E');
   cursor cfk3_periodi_retributivi(var_settore number, var_sede number) is
      select 1
        from periodi_retributivi
       where settore = var_settore
         and sede = var_sede;
begin
   begin
      open cfk1_assegnazioni_contabili(old_settore, old_sede);
      fetch cfk1_assegnazioni_contabili
         into dummy;
      found := cfk1_assegnazioni_contabili%found;
      close cfk1_assegnazioni_contabili;
      if found then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Assegnazioni Contabili. La registrazione di Ripartizioni Funzionali non e'' eliminabile.';
         raise integrity_error;
      end if;
      open cfk2_periodi_giuridici(old_settore, old_sede);
      fetch cfk2_periodi_giuridici
         into dummy;
      found := cfk2_periodi_giuridici%found;
      close cfk2_periodi_giuridici;
      if found then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Periodi Giuridici. La registrazione di Ripartizioni Funzionali non e'' eliminabile.';
         raise integrity_error;
      end if;
      open cfk3_periodi_retributivi(old_settore, old_sede);
      fetch cfk3_periodi_retributivi
         into dummy;
      found := cfk3_periodi_retributivi%found;
      close cfk3_periodi_retributivi;
      if found then
         errno  := -20006;
         errmsg := 'Esistono riferimenti su Periodi Retributivi. La registrazione di Ripartizioni Funzionali non e'' eliminabile.';
         raise integrity_error;
      end if;
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
create or replace trigger RIPARTIZIONI_FUNZIONALI_TMB
   before UPDATE on RIPARTIZIONI_FUNZIONALI
for each row
/******************************************************************************
 NOME:        RIPARTIZIONI_FUNZIONALI_TMB
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                 MM     Att. 12602.0.4
******************************************************************************/
declare
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin

   begin
      if updating then
         ripartizioni_funzionali_pu(:old.settore
                                   ,:old.sede
                                   ,:new.settore
                                   ,:new.sede);
      end if;
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
create or replace trigger RIPARTIZIONI_FUNZIONALI_TDB
   before DELETE on RIPARTIZIONI_FUNZIONALI
for each row
/******************************************************************************
 NOME:        RIPARTIZIONI_FUNZIONALI_TDB
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                 MM
******************************************************************************/
declare
   integrity_error exception;
   errno  integer;
   errmsg char(200);
begin
   begin
      -- Set FUNCTIONAL Integrity on DELETE
      if integritypackage.getnestlevel = 0 then
         integritypackage.nextnestlevel;
         integritypackage.previousnestlevel;
      end if;
   end;
   begin
      -- Check REFERENTIAL Integrity on DELETE
      ripartizioni_funzionali_pd(:old.settore, :old.sede);
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
/*==============================================================*/
/* Crezione trigger di intergity scorporati da questo file      */
/*==============================================================*/

start crf_redo.sql
start crf_rest.sql

/*===============================================================*/
/* Crezione trigger di intergita referenziale tra tabelle del DB */
/*===============================================================*/

start crf_COST_PEDO_TMA.sql
start crf_GEST_PEDO_TMA.sql
start crf_FIGI_PEDO_TMA.sql
start crf_PEGI_DOES_TMA.sql
start crf_PEGI_PEDO_TMA.sql
start crf_PEGI_SOGI_TMA.sql
start crf_POSI_PEDO_TMA.sql
start crf_QUGI_PEDO_TMA.sql
start crf_UNOR_PEDO_TMA.sql
start crf_UNOR_REUO_TMA.sql
start crf_SUST_REUO_TMA.sql
start crf_STAM_REUO_TMA.sql
