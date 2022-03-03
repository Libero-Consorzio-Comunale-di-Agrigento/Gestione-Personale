/*==============================================================*/
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     25/11/2003 16.57.33                          */
/*==============================================================*/


create or replace procedure ACCONTI_EROGATI_PI
/******************************************************************************
 NOME:        ACCONTI_EROGATI_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table ACCONTI_EROGATI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger ACCONTI_EROGATI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_riri_id IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "RICHIESTE_RIMBORSO"
   cursor cpk1_acconti_erogati(var_riri_id number) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
   --  Dichiarazione di InsertTooManyChildren per la tabella padre "RICHIESTE_RIMBORSO"
   cursor cmc1_acconti_erogati(var_riri_id number) is
      select count(1)
      from   ACCONTI_EROGATI
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "RICHIESTE_RIMBORSO" deve esistere quando si inserisce su "ACCONTI_EROGATI"
         if NEW_RIRI_ID is not null then
            open  cpk1_acconti_erogati(NEW_RIRI_ID);
            fetch cpk1_acconti_erogati into dummy;
            found := cpk1_acconti_erogati%FOUND; /* %FOUND */
            close cpk1_acconti_erogati;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su RICHIESTE_RIMBORSO. La registrazione ACCONTI_EROGATI non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  La cardinality di "RICHIESTE_RIMBORSO" in "ACCONTI_EROGATI" non deve eccedere 1
         if NEW_RIRI_ID is not null then
            open  cmc1_acconti_erogati(NEW_RIRI_ID);
            fetch cmc1_acconti_erogati into cardinality;
            close cmc1_acconti_erogati;
            if cardinality >= 1 then
          errno  := -20008;
          errmsg := 'Il numero di ACCONTI_EROGATI assegnato a RICHIESTE_RIMBORSO non e'' ammesso. La registrazione non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Statement di Insert MultiRow
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
/* End Procedure: ACCONTI_EROGATI_PI */
/

create or replace procedure ACCONTI_EROGATI_PU
/******************************************************************************
 NOME:        ACCONTI_EROGATI_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table ACCONTI_EROGATI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ACCONTI_EROGATI_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_ci IN number
 , old_data_acconto IN date
 , old_numero_acconto IN number
 , old_riri_id IN number
 , new_ci IN number
 , new_data_acconto IN date
 , new_numero_acconto IN number
 , new_riri_id IN number
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
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "RICHIESTE_RIMBORSO"
   cursor cpk1_acconti_erogati(var_riri_id number) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
   --  Declaration of UpdateParentRestrict constraint for "RICHIESTE_RIMBORSO"
   cursor cfk1_richieste_rimborso(var_ci number,
                   var_data_acconto date,
                   var_numero_acconto number) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  CI = var_ci
       and   DATA_ACCONTO = var_data_acconto
       and   NUMERO_ACCONTO = var_numero_acconto
       and   var_ci is not null
       and   var_data_acconto is not null
       and   var_numero_acconto is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "RICHIESTE_RIMBORSO" deve esistere quando si modifica "ACCONTI_EROGATI"
         if  NEW_RIRI_ID is not null and ( seq = 0 )
         and (   (NEW_RIRI_ID != OLD_RIRI_ID or OLD_RIRI_ID is null) ) then
            open  cpk1_acconti_erogati(NEW_RIRI_ID);
            fetch cpk1_acconti_erogati into dummy;
            found := cpk1_acconti_erogati%FOUND; /* %FOUND */
            close cpk1_acconti_erogati;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su RICHIESTE_RIMBORSO. La registrazione ACCONTI_EROGATI non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "ACCONTI_EROGATI" non modificabile se esistono referenze su "RICHIESTE_RIMBORSO"
      if (OLD_CI != NEW_CI) or
         (OLD_DATA_ACCONTO != NEW_DATA_ACCONTO) or
         (OLD_NUMERO_ACCONTO != NEW_NUMERO_ACCONTO) then
         open  cfk1_richieste_rimborso(OLD_CI,
                        OLD_DATA_ACCONTO,
                        OLD_NUMERO_ACCONTO);
         fetch cfk1_richieste_rimborso into dummy;
         found := cfk1_richieste_rimborso%FOUND; /* %FOUND */
         close cfk1_richieste_rimborso;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RICHIESTE_RIMBORSO. La registrazione di ACCONTI_EROGATI non e'' modificabile.';
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
/* End Procedure: ACCONTI_EROGATI_PU */
/

create or replace trigger ACCONTI_EROGATI_TMB
   before INSERT or UPDATE on ACCONTI_EROGATI
for each row
/******************************************************************************
 NOME:        ACCONTI_EROGATI_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table ACCONTI_EROGATI
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure ACCONTI_EROGATI_PI e ACCONTI_EROGATI_PU
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
         ACCONTI_EROGATI_PU(:OLD.CI
                       , :OLD.DATA_ACCONTO
                       , :OLD.NUMERO_ACCONTO
                       , :OLD.RIRI_ID
                         , :NEW.CI
                         , :NEW.DATA_ACCONTO
                         , :NEW.NUMERO_ACCONTO
                         , :NEW.RIRI_ID
                         );
         null;
      end if;
      if INSERTING then
         ACCONTI_EROGATI_PI(:NEW.RIRI_ID);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "ACCONTI_EROGATI"
            cursor cpk_acconti_erogati(var_CI number,
                            var_DATA_ACCONTO date,
                            var_NUMERO_ACCONTO number) is
               select 1
                 from   ACCONTI_EROGATI
                where  CI = var_CI and
                       DATA_ACCONTO = var_DATA_ACCONTO and
                       NUMERO_ACCONTO = var_NUMERO_ACCONTO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "ACCONTI_EROGATI"
               if :new.CI is not null and
                  :new.DATA_ACCONTO is not null and
                  :new.NUMERO_ACCONTO is not null then
                  open  cpk_acconti_erogati(:new.CI,
                                 :new.DATA_ACCONTO,
                                 :new.NUMERO_ACCONTO);
                  fetch cpk_acconti_erogati into dummy;
                  found := cpk_acconti_erogati%FOUND;
                  close cpk_acconti_erogati;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.CI||' '||
                               :new.DATA_ACCONTO||' '||
                               :new.NUMERO_ACCONTO||
                               '" gia'' presente in ACCONTI_EROGATI. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: ACCONTI_EROGATI_TMB */
/

create or replace procedure ACCONTI_EROGATI_PD
/******************************************************************************
 NOME:        ACCONTI_EROGATI_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table ACCONTI_EROGATI
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger ACCONTI_EROGATI_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_ci IN number,
 old_data_acconto IN date,
 old_numero_acconto IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "RICHIESTE_RIMBORSO"
   cursor cfk1_richieste_rimborso(var_ci number,
                   var_data_acconto date,
                   var_numero_acconto number) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  CI = var_ci
       and   DATA_ACCONTO = var_data_acconto
       and   NUMERO_ACCONTO = var_numero_acconto
       and   var_ci is not null
       and   var_data_acconto is not null
       and   var_numero_acconto is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "ACCONTI_EROGATI" if children still exist in "RICHIESTE_RIMBORSO"
      open  cfk1_richieste_rimborso(OLD_CI,
                     OLD_DATA_ACCONTO,
                     OLD_NUMERO_ACCONTO);
      fetch cfk1_richieste_rimborso into dummy;
      found := cfk1_richieste_rimborso%FOUND; /* %FOUND */
      close cfk1_richieste_rimborso;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su RICHIESTE_RIMBORSO. La registrazione di ACCONTI_EROGATI non e'' eliminabile.';
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
/* End Procedure: ACCONTI_EROGATI_PD */
/

create or replace trigger ACCONTI_EROGATI_TDB
   before DELETE on ACCONTI_EROGATI
for each row
/******************************************************************************
 NOME:        ACCONTI_EROGATI_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table ACCONTI_EROGATI
 ANNOTAZIONI: Richiama Procedure ACCONTI_EROGATI_TD
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
      ACCONTI_EROGATI_PD(:OLD.CI,
                    :OLD.DATA_ACCONTO,
                    :OLD.NUMERO_ACCONTO);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ACCONTI_EROGATI_TDB */
/

create or replace procedure LIMITI_IMPORTO_SPESA_PI
/******************************************************************************
 NOME:        LIMITI_IMPORTO_SPESA_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table LIMITI_IMPORTO_SPESA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger LIMITI_IMPORTO_SPESA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_tipo_spesa IN varchar,
 new_dal IN date,
 new_al IN date)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "TIPI_SPESA"
   cursor cpk1_limiti_importo_spesa(var_tipo_spesa varchar,var_dal date,var_al date) is
      select 1
      from   TIPI_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   var_dal between dal and nvl(al,to_date('3333333','j'))
       and   nvl(var_al,to_date('3333333','j')) between dal and nvl(al,to_date('3333333','j'));
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "TIPI_SPESA" deve esistere quando si inserisce su "LIMITI_IMPORTO_SPESA"
         if NEW_TIPO_SPESA is not null then
            open  cpk1_limiti_importo_spesa(NEW_TIPO_SPESA,NEW_DAL,NEW_AL);
            fetch cpk1_limiti_importo_spesa into dummy;
            found := cpk1_limiti_importo_spesa%FOUND; /* %FOUND */
            close cpk1_limiti_importo_spesa;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su TIPI_SPESA. La registrazione LIMITI_IMPORTO_SPESA non puo'' essere inserita.';
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
/* End Procedure: LIMITI_IMPORTO_SPESA_PI */
/

create or replace procedure LIMITI_IMPORTO_SPESA_PU
/******************************************************************************
 NOME:        LIMITI_IMPORTO_SPESA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table LIMITI_IMPORTO_SPESA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger LIMITI_IMPORTO_SPESA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_tipo_spesa IN varchar
 , old_gestione IN varchar
 , old_contratto IN varchar
 , old_qualifica IN varchar
 , old_livello IN varchar
 , old_dal IN date
 , old_al IN date
 , new_tipo_spesa IN varchar
 , new_gestione IN varchar
 , new_contratto IN varchar
 , new_qualifica IN varchar
 , new_livello IN varchar
 , new_dal IN date
 , new_al IN date
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
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "TIPI_SPESA"
   cursor cpk1_limiti_importo_spesa(var_tipo_spesa varchar,var_dal date,var_al date) is
      select 1
      from   TIPI_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   var_dal between dal and nvl(al,to_date('3333333','j'))
       and   nvl(var_al,to_date('3333333','j')) between dal and nvl(al,to_date('3333333','j'));
 begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "TIPI_SPESA" deve esistere quando si modifica "LIMITI_IMPORTO_SPESA"
         if  NEW_TIPO_SPESA is not null and ( seq = 0 )
         and (   (NEW_TIPO_SPESA != OLD_TIPO_SPESA or
                  NEW_DAL != OLD_DAL or
                  nvl(NEW_AL,to_date('3333333','j')) != nvl(OLD_AL,to_date('3333333','j')) or
                  OLD_TIPO_SPESA is null) ) then
            open  cpk1_limiti_importo_spesa(NEW_TIPO_SPESA,NEW_DAL,NEW_AL);
            fetch cpk1_limiti_importo_spesa into dummy;
            found := cpk1_limiti_importo_spesa%FOUND; /* %FOUND */
            close cpk1_limiti_importo_spesa;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su TIPI_SPESA. La registrazione LIMITI_IMPORTO_SPESA non e'' modificabile.';
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
/* End Procedure: LIMITI_IMPORTO_SPESA_PU */
/

create or replace trigger LIMITI_IMPORTO_SPESA_TMB
   before INSERT or UPDATE on LIMITI_IMPORTO_SPESA
for each row
/******************************************************************************
 NOME:        LIMITI_IMPORTO_SPESA_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table LIMITI_IMPORTO_SPESA
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure LIMITI_IMPORTO_SPESA_PI e LIMITI_IMPORTO_SPESA_PU
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
         LIMITI_IMPORTO_SPESA_PU(:OLD.TIPO_SPESA
                       , :OLD.GESTIONE
                       , :OLD.CONTRATTO
                       , :OLD.QUALIFICA
                       , :OLD.LIVELLO
                       , :OLD.DAL
                       , :OLD.AL
                         , :NEW.TIPO_SPESA
                         , :NEW.GESTIONE
                         , :NEW.CONTRATTO
                         , :NEW.QUALIFICA
                         , :NEW.LIVELLO
                         , :NEW.DAL
                         , :NEW.AL
                         );
         null;
      end if;
      if INSERTING then
         LIMITI_IMPORTO_SPESA_PI(:NEW.TIPO_SPESA,:NEW.DAL,:NEW.AL);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "LIMITI_IMPORTO_SPESA"
            cursor cpk_limiti_importo_spesa(var_TIPO_SPESA varchar,
                            var_GESTIONE varchar,
                            var_CONTRATTO varchar,
                            var_QUALIFICA varchar,
                            var_LIVELLO varchar,
                            var_DAL date) is
               select 1
                 from   LIMITI_IMPORTO_SPESA
                where  TIPO_SPESA = var_TIPO_SPESA and
                       GESTIONE = var_GESTIONE and
                       CONTRATTO = var_CONTRATTO and
                       QUALIFICA = var_QUALIFICA and
                       LIVELLO = var_LIVELLO and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "LIMITI_IMPORTO_SPESA"
               if :new.TIPO_SPESA is not null and
                  :new.GESTIONE is not null and
                  :new.CONTRATTO is not null and
                  :new.QUALIFICA is not null and
                  :new.LIVELLO is not null and
                  :new.DAL is not null then
                  open  cpk_limiti_importo_spesa(:new.TIPO_SPESA,
                                 :new.GESTIONE,
                                 :new.CONTRATTO,
                                 :new.QUALIFICA,
                                 :new.LIVELLO,
                                 :new.DAL);
                  fetch cpk_limiti_importo_spesa into dummy;
                  found := cpk_limiti_importo_spesa%FOUND;
                  close cpk_limiti_importo_spesa;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.TIPO_SPESA||' '||
                               :new.GESTIONE||' '||
                               :new.CONTRATTO||' '||
                               :new.QUALIFICA||' '||
                               :new.LIVELLO||' '||
                               :new.DAL||
                               '" gia'' presente in LIMITI_IMPORTO_SPESA. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: LIMITI_IMPORTO_SPESA_TMB */
/

create or replace trigger PARAMETRI_MISSIONI_TX
   before INSERT or UPDATE on PARAMETRI_MISSIONI
for each row
/******************************************************************************
 NOME:        PARAMETRI_MISSIONI_TX
 DESCRIZIONE: Trigger for Set DATA Integrity
                          Set FUNCTIONAL Integrity
                       on Table PARAMETRI_MISSIONI
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
    _ __/__/____
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   found            boolean;
begin
   begin  -- Set DATA Integrity
      /* NONE */ null;
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
/* End Trigger: PARAMETRI_MISSIONI_TX */
/


create or replace trigger REGOLE_DIARIA_TX
   before INSERT or UPDATE on REGOLE_DIARIA
for each row
/******************************************************************************
 NOME:        REGOLE_DIARIA_TX
 DESCRIZIONE: Trigger for Set DATA Integrity
                          Set FUNCTIONAL Integrity
                       on Table REGOLE_DIARIA
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
    _ __/__/____
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   found            boolean;
begin
   begin  -- Set DATA Integrity
      /* NONE */ null;
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
/* End Trigger: REGOLE_DIARIA_TX */
/


create or replace procedure RICHIESTE_RIMBORSO_PI
/******************************************************************************
 NOME:        RICHIESTE_RIMBORSO_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table RICHIESTE_RIMBORSO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger RICHIESTE_RIMBORSO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_ci IN number,
 new_tipo_missione IN varchar,
 new_data_acconto IN date,
 new_numero_acconto IN number)
is
   integrity_error     exception;
   errno               integer;
   errmsg              char(200);
   dummy               integer;
   found               boolean;
   cardinality         integer;
   mutating            exception;
   se_gestione_acconti number(1);
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "TIPI_MISSIONE"
   cursor cpk1_richieste_rimborso(var_tipo_missione varchar) is
      select 1
      from   TIPI_MISSIONE
      where  TIPO_MISSIONE = var_tipo_missione
       and   var_tipo_missione is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "ACCONTI_EROGATI"
   cursor cpk2_richieste_rimborso(var_ci number,
                   var_data_acconto date,
                   var_numero_acconto number) is
      select 1
      from   ACCONTI_EROGATI
      where  CI = var_ci
       and   DATA_ACCONTO = var_data_acconto
       and   NUMERO_ACCONTO = var_numero_acconto
       and   var_ci is not null
       and   var_data_acconto is not null
       and   var_numero_acconto is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      begin
            select se_gestione_acconti
              into se_gestione_acconti
              from PARAMETRI_MISSIONI;
      end;
      begin  --  Parent "TIPI_MISSIONE" deve esistere quando si inserisce su "RICHIESTE_RIMBORSO"
         if NEW_TIPO_MISSIONE is not null then
            open  cpk1_richieste_rimborso(NEW_TIPO_MISSIONE);
            fetch cpk1_richieste_rimborso into dummy;
            found := cpk1_richieste_rimborso%FOUND; /* %FOUND */
            close cpk1_richieste_rimborso;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su TIPI_MISSIONE. La registrazione RICHIESTE_RIMBORSO non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ACCONTI_EROGATI" deve esistere quando si inserisce su "RICHIESTE_RIMBORSO"
         if nvl(se_gestione_acconti,0) = 1 and
            NEW_CI is not null and
            NEW_DATA_ACCONTO is not null and
            NEW_NUMERO_ACCONTO is not null then
            open  cpk2_richieste_rimborso(NEW_CI,
                           NEW_DATA_ACCONTO,
                           NEW_NUMERO_ACCONTO);
            fetch cpk2_richieste_rimborso into dummy;
            found := cpk2_richieste_rimborso%FOUND; /* %FOUND */
            close cpk2_richieste_rimborso;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su ACCONTI_EROGATI. La registrazione RICHIESTE_RIMBORSO non puo'' essere inserita.';
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
/* End Procedure: RICHIESTE_RIMBORSO_PI */
/

create or replace procedure RICHIESTE_RIMBORSO_PU
/******************************************************************************
 NOME:        RICHIESTE_RIMBORSO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table RICHIESTE_RIMBORSO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RICHIESTE_RIMBORSO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_riri_id IN number
 , old_ci IN number
 , old_tipo_missione IN varchar
 , old_data_acconto IN date
 , old_numero_acconto IN number
 , old_data_inizio IN date
 , new_riri_id IN number
 , new_ci IN number
 , new_tipo_missione IN varchar
 , new_data_acconto IN date
 , new_numero_acconto IN number
 , new_data_inizio IN date
)
is  
   integrity_error     exception;
   errno               integer;
   errmsg              char(200);
   dummy               integer;
   found               boolean;
   seq                 number;
   mutating            exception;
   se_gestione_acconti number(1);
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "TIPI_MISSIONE"
   cursor cpk1_richieste_rimborso(var_tipo_missione varchar) is
      select 1
      from   TIPI_MISSIONE
      where  TIPO_MISSIONE = var_tipo_missione
       and   var_tipo_missione is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "ACCONTI_EROGATI"
   cursor cpk2_richieste_rimborso(var_ci number,
                   var_data_acconto date,
                   var_numero_acconto number) is
      select 1
      from   ACCONTI_EROGATI
      where  CI = var_ci
       and   DATA_ACCONTO = var_data_acconto
       and   NUMERO_ACCONTO = var_numero_acconto
       and   var_ci is not null
       and   var_data_acconto is not null
       and   var_numero_acconto is not null;
   --  Declaration of UpdateParentRestrict constraint for "ACCONTI_EROGATI"
   cursor cfk1_acconti_erogati(var_riri_id number) is
      select 1
      from   ACCONTI_EROGATI
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
   --  Declaration of UpdateParentRestrict constraint for "RIGHE_RICHIESTA_RIMBORSO"
   cursor cfk2_righe_richiesta_rimborso(var_riri_id number) is
      select 1
      from   RIGHE_RICHIESTA_RIMBORSO
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
   --  Declaration of UpdateParentRestrict constraint for "RIGHE_RICHIESTA_RIMBORSO"
   cursor cfk3_righe_richiesta_rimborso(var_riri_id number,var_dal date) is
      select 1
      from   RIGHE_RICHIESTA_RIMBORSO rirr, TIPI_SPESA tisp
      where  rirr.tipo_spesa = tisp.tipo_spesa
       and   RIRI_ID = var_riri_id
       and   var_riri_id is not null
       and   var_dal not between dal and nvl(al,to_date('3333333','j'))
       and   not exists (select 1
                           from TIPI_SPESA tisp2
                          where tisp2.tipo_spesa = tisp.tipo_spesa
                            and var_dal between tisp2.dal and nvl(tisp2.al,to_date('3333333','j')));
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      select se_gestione_acconti
        into se_gestione_acconti
        from PARAMETRI_MISSIONI;
      begin  --  Parent "TIPI_MISSIONE" deve esistere quando si modifica "RICHIESTE_RIMBORSO"
         if  NEW_TIPO_MISSIONE is not null and ( seq = 0 )
         and (   (NEW_TIPO_MISSIONE != OLD_TIPO_MISSIONE or OLD_TIPO_MISSIONE is null) ) then
            open  cpk1_richieste_rimborso(NEW_TIPO_MISSIONE);
            fetch cpk1_richieste_rimborso into dummy;
            found := cpk1_richieste_rimborso%FOUND; /* %FOUND */
            close cpk1_richieste_rimborso;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su TIPI_MISSIONE. La registrazione RICHIESTE_RIMBORSO non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "ACCONTI_EROGATI" deve esistere quando si modifica "RICHIESTE_RIMBORSO"
         if  nvl(se_gestione_acconti,0) = 1 and
             NEW_CI is not null and
             NEW_DATA_ACCONTO is not null and
             NEW_NUMERO_ACCONTO is not null and ( seq = 0 )
         and (   (NEW_CI != OLD_CI or OLD_CI is null)
              or (NEW_DATA_ACCONTO != OLD_DATA_ACCONTO or OLD_DATA_ACCONTO is null)
              or (NEW_NUMERO_ACCONTO != OLD_NUMERO_ACCONTO or OLD_NUMERO_ACCONTO is null) ) then
            open  cpk2_richieste_rimborso(NEW_CI,
                           NEW_DATA_ACCONTO,
                           NEW_NUMERO_ACCONTO);
            fetch cpk2_richieste_rimborso into dummy;
            found := cpk2_richieste_rimborso%FOUND; /* %FOUND */
            close cpk2_richieste_rimborso;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su ACCONTI_EROGATI. La registrazione RICHIESTE_RIMBORSO non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      --  Chiave di "RICHIESTE_RIMBORSO" non modificabile se esistono referenze su "ACCONTI_EROGATI"
      if nvl(se_gestione_acconti,0) = 1 and
         (OLD_RIRI_ID != NEW_RIRI_ID) then
         open  cfk1_acconti_erogati(OLD_RIRI_ID);
         fetch cfk1_acconti_erogati into dummy;
         found := cfk1_acconti_erogati%FOUND; /* %FOUND */
         close cfk1_acconti_erogati;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su ACCONTI_EROGATI. La registrazione di RICHIESTE_RIMBORSO non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "RICHIESTE_RIMBORSO" non modificabile se esistono referenze su "RIGHE_RICHIESTA_RIMBORSO"
      if (OLD_RIRI_ID != NEW_RIRI_ID) then
         open  cfk2_righe_richiesta_rimborso(OLD_RIRI_ID);
         fetch cfk2_righe_richiesta_rimborso into dummy;
         found := cfk2_righe_richiesta_rimborso%FOUND; /* %FOUND */
         close cfk2_righe_richiesta_rimborso;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RIGHE_RICHIESTA_RIMBORSO. La registrazione di RICHIESTE_RIMBORSO non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Data Inizio di "RICHIESTE_RIMBORSO" non modificabile se esistono referenze su "RIGHE_RICHIESTA_RIMBORSO"
      if (OLD_DATA_INIZIO != NEW_DATA_INIZIO) then
         open  cfk3_righe_richiesta_rimborso(OLD_RIRI_ID,NEW_DATA_INIZIO);
         fetch cfk3_righe_richiesta_rimborso into dummy;
         found := cfk3_righe_richiesta_rimborso%FOUND; /* %FOUND */
         close cfk3_righe_richiesta_rimborso;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RIGHE_RICHIESTA_RIMBORSO. La registrazione di RICHIESTE_RIMBORSO non e'' modificabile.';
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
/* End Procedure: RICHIESTE_RIMBORSO_PU */
/

create or replace trigger RICHIESTE_RIMBORSO_TMB
   before INSERT or UPDATE on RICHIESTE_RIMBORSO
for each row
/******************************************************************************
 NOME:        RICHIESTE_RIMBORSO_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table RICHIESTE_RIMBORSO
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure RICHIESTE_RIMBORSO_PI e RICHIESTE_RIMBORSO_PU
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
         RICHIESTE_RIMBORSO_PU(:OLD.RIRI_ID
                       , :OLD.CI
                       , :OLD.TIPO_MISSIONE
                       , :OLD.DATA_ACCONTO
                       , :OLD.NUMERO_ACCONTO
                       , :OLD.DATA_INIZIO
                         , :NEW.RIRI_ID
                         , :NEW.CI
                         , :NEW.TIPO_MISSIONE
                         , :NEW.DATA_ACCONTO
                         , :NEW.NUMERO_ACCONTO
                         , :NEW.DATA_INIZIO
                         );
         null;
      end if;
      if INSERTING then
         RICHIESTE_RIMBORSO_PI(:NEW.CI,
                         :NEW.TIPO_MISSIONE,
                         :NEW.DATA_ACCONTO,
                         :NEW.NUMERO_ACCONTO);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "RICHIESTE_RIMBORSO"
            cursor cpk_richieste_rimborso(var_RIRI_ID number) is
               select 1
                 from   RICHIESTE_RIMBORSO
                where  RIRI_ID = var_RIRI_ID;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "RICHIESTE_RIMBORSO"
               if :new.RIRI_ID is not null then
                  open  cpk_richieste_rimborso(:new.RIRI_ID);
                  fetch cpk_richieste_rimborso into dummy;
                  found := cpk_richieste_rimborso%FOUND;
                  close cpk_richieste_rimborso;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.RIRI_ID||
                               '" gia'' presente in RICHIESTE_RIMBORSO. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: RICHIESTE_RIMBORSO_TMB */
/

create or replace procedure RICHIESTE_RIMBORSO_PD
/******************************************************************************
 NOME:        RICHIESTE_RIMBORSO_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table RICHIESTE_RIMBORSO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RICHIESTE_RIMBORSO_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_riri_id IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "ACCONTI_EROGATI"
   cursor cfk1_acconti_erogati(var_riri_id number) is
      select 1
      from   ACCONTI_EROGATI
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
   --  Declaration of DeleteParentRestrict constraint for "RIGHE_RICHIESTA_RIMBORSO"
   cursor cfk2_righe_richiesta_rimborso(var_riri_id number) is
      select 1
      from   RIGHE_RICHIESTA_RIMBORSO
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "RICHIESTE_RIMBORSO" if children still exist in "ACCONTI_EROGATI"
      open  cfk1_acconti_erogati(OLD_RIRI_ID);
      fetch cfk1_acconti_erogati into dummy;
      found := cfk1_acconti_erogati%FOUND; /* %FOUND */
      close cfk1_acconti_erogati;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su ACCONTI_EROGATI. La registrazione di RICHIESTE_RIMBORSO non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "RICHIESTE_RIMBORSO" if children still exist in "RIGHE_RICHIESTA_RIMBORSO"
      open  cfk2_righe_richiesta_rimborso(OLD_RIRI_ID);
      fetch cfk2_righe_richiesta_rimborso into dummy;
      found := cfk2_righe_richiesta_rimborso%FOUND; /* %FOUND */
      close cfk2_righe_richiesta_rimborso;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su RIGHE_RICHIESTA_RIMBORSO. La registrazione di RICHIESTE_RIMBORSO non e'' eliminabile.';
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
/* End Procedure: RICHIESTE_RIMBORSO_PD */
/

create or replace trigger RICHIESTE_RIMBORSO_TDB
   before DELETE on RICHIESTE_RIMBORSO
for each row
/******************************************************************************
 NOME:        RICHIESTE_RIMBORSO_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table RICHIESTE_RIMBORSO
 ANNOTAZIONI: Richiama Procedure RICHIESTE_RIMBORSO_TD
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
      RICHIESTE_RIMBORSO_PD(:OLD.RIRI_ID);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: RICHIESTE_RIMBORSO_TDB */
/

create or replace procedure RIGHE_RICHIESTA_RIMBORSO_PI
/******************************************************************************
 NOME:        RIGHE_RICHIESTA_RIMBORSO_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table RIGHE_RICHIESTA_RIMBORSO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger RIGHE_RICHIESTA_RIMBORSO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_riri_id IN number,
 new_tipo_spesa IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   riri_data_inizio date;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "RICHIESTE_RIMBORSO"
   cursor cpk1_righe_richiesta_rimborso(var_riri_id number) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
   --  Dichiarazione di InsertChildParentExist per la tabella padre "TIPI_SPESA"
   cursor cpk2_righe_richiesta_rimborso(var_tipo_spesa varchar,var_dal date) is
      select 1
      from   TIPI_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   var_dal between dal and nvl(al,to_date('3333333','j'));
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "RICHIESTE_RIMBORSO" deve esistere quando si inserisce su "RIGHE_RICHIESTA_RIMBORSO"
         if NEW_RIRI_ID is not null then
            open  cpk1_righe_richiesta_rimborso(NEW_RIRI_ID);
            fetch cpk1_righe_richiesta_rimborso into dummy;
            found := cpk1_righe_richiesta_rimborso%FOUND; /* %FOUND */
            close cpk1_righe_richiesta_rimborso;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su RICHIESTE_RIMBORSO. La registrazione RIGHE_RICHIESTA_RIMBORSO non puo'' essere inserita.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "TIPI_SPESA" deve esistere quando si inserisce su "RIGHE_RICHIESTA_RIMBORSO"
         if NEW_TIPO_SPESA is not null then
            select data_inizio
              into riri_data_inizio
              from RICHIESTE_RIMBORSO
             where riri_id = new_riri_id;
            open  cpk2_righe_richiesta_rimborso(NEW_TIPO_SPESA,RIRI_DATA_INIZIO);
            fetch cpk2_righe_richiesta_rimborso into dummy;
            found := cpk2_righe_richiesta_rimborso%FOUND; /* %FOUND */
            close cpk2_righe_richiesta_rimborso;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su TIPI_SPESA. La registrazione RIGHE_RICHIESTA_RIMBORSO non puo'' essere inserita.';
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
/* End Procedure: RIGHE_RICHIESTA_RIMBORSO_PI */
/

create or replace procedure RIGHE_RICHIESTA_RIMBORSO_PU
/******************************************************************************
 NOME:        RIGHE_RICHIESTA_RIMBORSO_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table RIGHE_RICHIESTA_RIMBORSO
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger RIGHE_RICHIESTA_RIMBORSO_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_rirr_id IN number
 , old_riri_id IN number
 , old_tipo_spesa IN varchar
 , new_rirr_id IN number
 , new_riri_id IN number
 , new_tipo_spesa IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   riri_data_inizio date;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "RICHIESTE_RIMBORSO"
   cursor cpk1_righe_richiesta_rimborso(var_riri_id number) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  RIRI_ID = var_riri_id
       and   var_riri_id is not null;
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "TIPI_SPESA"
   cursor cpk2_righe_richiesta_rimborso(var_tipo_spesa varchar,var_dal date) is
      select 1
      from   TIPI_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   var_dal between dal and nvl(al,to_date('3333333','j'));
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "RICHIESTE_RIMBORSO" deve esistere quando si modifica "RIGHE_RICHIESTA_RIMBORSO"
         if  NEW_RIRI_ID is not null and ( seq = 0 )
         and (   (NEW_RIRI_ID != OLD_RIRI_ID or OLD_RIRI_ID is null) ) then
            open  cpk1_righe_richiesta_rimborso(NEW_RIRI_ID);
            fetch cpk1_righe_richiesta_rimborso into dummy;
            found := cpk1_righe_richiesta_rimborso%FOUND; /* %FOUND */
            close cpk1_righe_richiesta_rimborso;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su RICHIESTE_RIMBORSO. La registrazione RIGHE_RICHIESTA_RIMBORSO non e'' modificabile.';
          raise integrity_error;
            end if;
         end if;
      exception
         when MUTATING then null;  -- Ignora Check su Relazioni Ricorsive
      end;
      begin  --  Parent "TIPI_SPESA" deve esistere quando si modifica "RIGHE_RICHIESTA_RIMBORSO"
         if  NEW_TIPO_SPESA is not null and ( seq = 0 )
         and (   (NEW_TIPO_SPESA != OLD_TIPO_SPESA or OLD_TIPO_SPESA is null) ) then
                  select data_inizio
                    into riri_data_inizio
                    from RICHIESTE_RIMBORSO
                   where riri_id = new_riri_id;
            open  cpk2_righe_richiesta_rimborso(NEW_TIPO_SPESA,RIRI_DATA_INIZIO);
            fetch cpk2_righe_richiesta_rimborso into dummy;
            found := cpk2_righe_richiesta_rimborso%FOUND; /* %FOUND */
            close cpk2_righe_richiesta_rimborso;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su TIPI_SPESA. La registrazione RIGHE_RICHIESTA_RIMBORSO non e'' modificabile.';
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
/* End Procedure: RIGHE_RICHIESTA_RIMBORSO_PU */
/

create or replace trigger RIGHE_RICHIESTA_RIMBORSO_TMB
   before INSERT or UPDATE on RIGHE_RICHIESTA_RIMBORSO
for each row
/******************************************************************************
 NOME:        RIGHE_RICHIESTA_RIMBORSO_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table RIGHE_RICHIESTA_RIMBORSO
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure RIGHE_RICHIESTA_RIMBORSO_PI e RIGHE_RICHIESTA_RIMBORSO_PU
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
         RIGHE_RICHIESTA_RIMBORSO_PU(:OLD.RIRR_ID
                       , :OLD.RIRI_ID
                       , :OLD.TIPO_SPESA
                         , :NEW.RIRR_ID
                         , :NEW.RIRI_ID
                         , :NEW.TIPO_SPESA
                         );
         null;
      end if;
      if INSERTING then
         RIGHE_RICHIESTA_RIMBORSO_PI(:NEW.RIRI_ID,
                         :NEW.TIPO_SPESA);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "RIGHE_RICHIESTA_RIMBORSO"
            cursor cpk_righe_richiesta_rimborso(var_RIRR_ID number) is
               select 1
                 from   RIGHE_RICHIESTA_RIMBORSO
                where  RIRR_ID = var_RIRR_ID;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "RIGHE_RICHIESTA_RIMBORSO"
               if :new.RIRR_ID is not null then
                  open  cpk_righe_richiesta_rimborso(:new.RIRR_ID);
                  fetch cpk_righe_richiesta_rimborso into dummy;
                  found := cpk_righe_richiesta_rimborso%FOUND;
                  close cpk_righe_richiesta_rimborso;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.RIRR_ID||
                               '" gia'' presente in RIGHE_RICHIESTA_RIMBORSO. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: RIGHE_RICHIESTA_RIMBORSO_TMB */
/

create or replace procedure TARIFFE_PI
/******************************************************************************
 NOME:        TARIFFE_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table TARIFFE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger TARIFFE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(new_tipo_spesa IN varchar,
 new_dal IN date,
 new_al IN date)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   cardinality      integer;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   --  Dichiarazione di InsertChildParentExist per la tabella padre "TIPI_SPESA"
   cursor cpk1_tariffe(var_tipo_spesa varchar,var_dal date,var_al date) is
      select 1
      from   TIPI_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   var_dal between dal and nvl(al,to_date('3333333','j'))
       and   nvl(var_al,to_date('3333333','j')) between dal and nvl(al,to_date('3333333','j'));
begin
   begin  -- Check REFERENTIAL Integrity
      begin  --  Parent "TIPI_SPESA" deve esistere quando si inserisce su "TARIFFE"
         if NEW_TIPO_SPESA is not null then
            open  cpk1_tariffe(NEW_TIPO_SPESA,NEW_DAL,NEW_AL);
            fetch cpk1_tariffe into dummy;
            found := cpk1_tariffe%FOUND; /* %FOUND */
            close cpk1_tariffe;
            if not found then
          errno  := -20002;
          errmsg := 'Non esiste riferimento su TIPI_SPESA. La registrazione TARIFFE non puo'' essere inserita.';
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
/* End Procedure: TARIFFE_PI */
/

create or replace procedure TARIFFE_PU
/******************************************************************************
 NOME:        TARIFFE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table TARIFFE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TARIFFE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_tipo_spesa IN varchar
 , old_gestione IN varchar
 , old_contratto IN varchar
 , old_qualifica IN varchar
 , old_livello IN varchar
 , old_dal IN date
 , old_al IN date
 , new_tipo_spesa IN varchar
 , new_gestione IN varchar
 , new_contratto IN varchar
 , new_qualifica IN varchar
 , new_livello IN varchar
 , new_dal IN date
 , new_al IN date
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
   --  Dichiarazione UpdateChildParentExist constraint per la tabella "TIPI_SPESA"
   cursor cpk1_tariffe(var_tipo_spesa varchar,var_dal date,var_al date) is
      select 1
      from   TIPI_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   var_dal between dal and nvl(al,to_date('3333333','j'))
       and   nvl(var_al,to_date('3333333','j')) between dal and nvl(al,to_date('3333333','j'));
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      begin  --  Parent "TIPI_SPESA" deve esistere quando si modifica "TARIFFE"
         if  NEW_TIPO_SPESA is not null and ( seq = 0 )
         and (   (NEW_TIPO_SPESA != OLD_TIPO_SPESA or
                  NEW_DAL != OLD_DAL or
                  nvl(NEW_AL,to_date('3333333','j')) != nvl(OLD_AL,to_date('3333333','j')) or
                  OLD_TIPO_SPESA is null) ) then
            open  cpk1_tariffe(NEW_TIPO_SPESA,NEW_DAL,NEW_AL);
            fetch cpk1_tariffe into dummy;
            found := cpk1_tariffe%FOUND; /* %FOUND */
            close cpk1_tariffe;
            if not found then
          errno  := -20003;
          errmsg := 'Non esiste riferimento su TIPI_SPESA. La registrazione TARIFFE non e'' modificabile.';
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
/* End Procedure: TARIFFE_PU */
/

create or replace trigger TARIFFE_TMB
   before INSERT or UPDATE on TARIFFE
for each row
/******************************************************************************
 NOME:        TARIFFE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table TARIFFE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure TARIFFE_PI e TARIFFE_PU
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
         TARIFFE_PU(:OLD.TIPO_SPESA
                       , :OLD.GESTIONE
                       , :OLD.CONTRATTO
                       , :OLD.QUALIFICA
                       , :OLD.LIVELLO
                       , :OLD.DAL
                       , :OLD.AL
                         , :NEW.TIPO_SPESA
                         , :NEW.GESTIONE
                         , :NEW.CONTRATTO
                         , :NEW.QUALIFICA
                         , :NEW.LIVELLO
                         , :NEW.DAL
                         , :NEW.AL
                         );
         null;
      end if;
      if INSERTING then
         TARIFFE_PI(:NEW.TIPO_SPESA,:NEW.DAL,:NEW.AL);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "TARIFFE"
            cursor cpk_tariffe(var_TIPO_SPESA varchar,
                            var_GESTIONE varchar,
                            var_CONTRATTO varchar,
                            var_QUALIFICA varchar,
                            var_LIVELLO varchar,
                            var_DAL date) is
               select 1
                 from   TARIFFE
                where  TIPO_SPESA = var_TIPO_SPESA and
                       GESTIONE = var_GESTIONE and
                       CONTRATTO = var_CONTRATTO and
                       QUALIFICA = var_QUALIFICA and
                       LIVELLO = var_LIVELLO and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "TARIFFE"
               if :new.TIPO_SPESA is not null and
                  :new.GESTIONE is not null and
                  :new.CONTRATTO is not null and
                  :new.QUALIFICA is not null and
                  :new.LIVELLO is not null and
                  :new.DAL is not null then
                  open  cpk_tariffe(:new.TIPO_SPESA,
                                 :new.GESTIONE,
                                 :new.CONTRATTO,
                                 :new.QUALIFICA,
                                 :new.LIVELLO,
                                 :new.DAL);
                  fetch cpk_tariffe into dummy;
                  found := cpk_tariffe%FOUND;
                  close cpk_tariffe;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.TIPO_SPESA||' '||
                               :new.GESTIONE||' '||
                               :new.CONTRATTO||' '||
                               :new.QUALIFICA||' '||
                               :new.LIVELLO||' '||
                               :new.DAL||
                               '" gia'' presente in TARIFFE. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: TARIFFE_TMB */
/

create or replace procedure TIPI_MISSIONE_PU
/******************************************************************************
 NOME:        TIPI_MISSIONE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table TIPI_MISSIONE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_MISSIONE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_tipo_missione IN varchar
 , new_tipo_missione IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "RICHIESTE_RIMBORSO"
   cursor cfk1_richieste_rimborso(var_tipo_missione varchar) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  TIPO_MISSIONE = var_tipo_missione
       and   var_tipo_missione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "TIPI_MISSIONE" non modificabile se esistono referenze su "RICHIESTE_RIMBORSO"
      if (OLD_TIPO_MISSIONE != NEW_TIPO_MISSIONE) then
         open  cfk1_richieste_rimborso(OLD_TIPO_MISSIONE);
         fetch cfk1_richieste_rimborso into dummy;
         found := cfk1_richieste_rimborso%FOUND; /* %FOUND */
         close cfk1_richieste_rimborso;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RICHIESTE_RIMBORSO. La registrazione di TIPI_MISSIONE non e'' modificabile.';
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
/* End Procedure: TIPI_MISSIONE_PU */
/

create or replace trigger TIPI_MISSIONE_TMB
   before INSERT or UPDATE on TIPI_MISSIONE
for each row
/******************************************************************************
 NOME:        TIPI_MISSIONE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table TIPI_MISSIONE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure TIPI_MISSIONE_PI e TIPI_MISSIONE_PU
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
         TIPI_MISSIONE_PU(:OLD.TIPO_MISSIONE
                         , :NEW.TIPO_MISSIONE
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "TIPI_MISSIONE"
            cursor cpk_tipi_missione(var_TIPO_MISSIONE varchar) is
               select 1
                 from   TIPI_MISSIONE
                where  TIPO_MISSIONE = var_TIPO_MISSIONE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "TIPI_MISSIONE"
               if :new.TIPO_MISSIONE is not null then
                  open  cpk_tipi_missione(:new.TIPO_MISSIONE);
                  fetch cpk_tipi_missione into dummy;
                  found := cpk_tipi_missione%FOUND;
                  close cpk_tipi_missione;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.TIPO_MISSIONE||
                               '" gia'' presente in TIPI_MISSIONE. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: TIPI_MISSIONE_TMB */
/

create or replace procedure TIPI_MISSIONE_PD
/******************************************************************************
 NOME:        TIPI_MISSIONE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table TIPI_MISSIONE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_MISSIONE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_tipo_missione IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "RICHIESTE_RIMBORSO"
   cursor cfk1_richieste_rimborso(var_tipo_missione varchar) is
      select 1
      from   RICHIESTE_RIMBORSO
      where  TIPO_MISSIONE = var_tipo_missione
       and   var_tipo_missione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "TIPI_MISSIONE" if children still exist in "RICHIESTE_RIMBORSO"
      open  cfk1_richieste_rimborso(OLD_TIPO_MISSIONE);
      fetch cfk1_richieste_rimborso into dummy;
      found := cfk1_richieste_rimborso%FOUND; /* %FOUND */
      close cfk1_richieste_rimborso;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su RICHIESTE_RIMBORSO. La registrazione di TIPI_MISSIONE non e'' eliminabile.';
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
/* End Procedure: TIPI_MISSIONE_PD */
/

create or replace trigger TIPI_MISSIONE_TDB
   before DELETE on TIPI_MISSIONE
for each row
/******************************************************************************
 NOME:        TIPI_MISSIONE_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table TIPI_MISSIONE
 ANNOTAZIONI: Richiama Procedure TIPI_MISSIONE_TD
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
      TIPI_MISSIONE_PD(:OLD.TIPO_MISSIONE);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: TIPI_MISSIONE_TDB */
/

create or replace procedure TIPI_SPESA_PU
/******************************************************************************
 NOME:        TIPI_SPESA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table TIPI_SPESA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_SPESA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_tipo_spesa IN varchar
 , old_dal IN date
 , old_al IN date
 , new_tipo_spesa IN varchar
 , new_dal IN date
 , new_al IN date
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   riri_data_inizio date;
   --  Declaration of UpdateParentRestrict constraint for "LIMITI_IMPORTO_SPESA"
   cursor cfk1_limiti_importo_spesa(var_tipo_spesa varchar,var_dal_old date,var_al_old date
                                                          ,var_dal_new date,var_al_new date) is
      select 1
      from   LIMITI_IMPORTO_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   dal between var_dal_old
                     and nvl(var_al_old,to_date('3333333','j'))
       and   nvl(al,to_date('3333333','j')) between var_dal_old
                                                and nvl(var_al_old,to_date('3333333','j'))
       and   (dal not between var_dal_new
                          and nvl(var_al_new,to_date('3333333','j'))
          or
              nvl(al,to_date('3333333','j')) not between var_dal_new
                                                     and nvl(var_al_new,to_date('3333333','j')));
   --  Declaration of UpdateParentRestrict constraint for "TARIFFE"
   cursor cfk2_tariffe(var_tipo_spesa varchar,var_dal_old date,var_al_old date
                                             ,var_dal_new date,var_al_new date) is
      select 1
      from   TARIFFE
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   dal between var_dal_old
                     and nvl(var_al_old,to_date('3333333','j'))
       and   nvl(al,to_date('3333333','j')) between var_dal_old
                                                and nvl(var_al_old,to_date('3333333','j'))
       and   (dal not between var_dal_new
                          and nvl(var_al_new,to_date('3333333','j'))
          or
              nvl(al,to_date('3333333','j')) not between var_dal_new
                                                     and nvl(var_al_new,to_date('3333333','j')));
   --  Declaration of UpdateParentRestrict constraint for "RIGHE_RICHIESTA_RIMBORSO"
   cursor cfk3_righe_richiesta_rimborso(var_tipo_spesa varchar,var_dal_old date,var_al_old date
                                                              ,var_dal_new date,var_al_new date) is
      select 1
      from   RICHIESTE_RIMBORSO riri,
             RIGHE_RICHIESTA_RIMBORSO rirr
      where  riri.riri_id = rirr.riri_id
       and   rirr.TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   riri.data_inizio between var_dal_old
                                  and nvl(var_al_old,to_date('3333333','j'))
       and   (riri.data_inizio not between var_dal_new
                                       and nvl(var_al_new,to_date('3333333','j')));
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "TIPI_SPESA" non modificabile se esistono referenze su "LIMITI_IMPORTO_SPESA"
      if (OLD_TIPO_SPESA != NEW_TIPO_SPESA) or
         (OLD_DAL != NEW_DAL) or
         ((nvl(OLD_AL,to_date('3333333','j')) != nvl(NEW_AL,to_date('3333333','j')) and
           OLD_AL is not null and NEW_AL is not null)) then
         open  cfk1_limiti_importo_spesa(OLD_TIPO_SPESA,OLD_DAL,OLD_AL,NEW_DAL,NEW_AL);
         fetch cfk1_limiti_importo_spesa into dummy;
         found := cfk1_limiti_importo_spesa%FOUND; /* %FOUND */
         close cfk1_limiti_importo_spesa;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su LIMITI_IMPORTO_SPESA. La registrazione di TIPI_SPESA non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "TIPI_SPESA" non modificabile se esistono referenze su "TARIFFE"
      if (OLD_TIPO_SPESA != NEW_TIPO_SPESA) or
         (OLD_DAL != NEW_DAL) or
         ((nvl(OLD_AL,to_date('3333333','j')) != nvl(NEW_AL,to_date('3333333','j')) and
           OLD_AL is not null and NEW_AL is not null)) then
         open  cfk2_tariffe(OLD_TIPO_SPESA,OLD_DAL,OLD_AL,NEW_DAL,NEW_AL);
         fetch cfk2_tariffe into dummy;
         found := cfk2_tariffe%FOUND; /* %FOUND */
         close cfk2_tariffe;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su TARIFFE. La registrazione di TIPI_SPESA non e'' modificabile.';
          raise integrity_error;
         end if;
      end if;
      --  Chiave di "TIPI_SPESA" non modificabile se esistono referenze su "RIGHE_RICHIESTA_RIMBORSO"
      if (OLD_TIPO_SPESA != NEW_TIPO_SPESA) or
         (OLD_DAL != NEW_DAL)  or
         ((nvl(OLD_AL,to_date('3333333','j')) != nvl(NEW_AL,to_date('3333333','j')) and
           OLD_AL is not null and NEW_AL is not null)) then
         open  cfk3_righe_richiesta_rimborso(OLD_TIPO_SPESA,OLD_DAL,OLD_AL,NEW_DAL,NEW_AL);
         fetch cfk3_righe_richiesta_rimborso into dummy;
         found := cfk3_righe_richiesta_rimborso%FOUND; /* %FOUND */
         close cfk3_righe_richiesta_rimborso;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su RIGHE_RICHIESTA_RIMBORSO. La registrazione di TIPI_SPESA non e'' modificabile.';
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
/* End Procedure: TIPI_SPESA_PU */
/

create or replace trigger TIPI_SPESA_TMB
   before INSERT or UPDATE on TIPI_SPESA
for each row
/******************************************************************************
 NOME:        TIPI_SPESA_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table TIPI_SPESA
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure TIPI_SPESA_PI e TIPI_SPESA_PU
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
         TIPI_SPESA_PU(:OLD.TIPO_SPESA
                       , :OLD.DAL
                       , :OLD.AL
                         , :NEW.TIPO_SPESA
                         , :NEW.DAL
                         , :NEW.AL
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "TIPI_SPESA"
            cursor cpk_tipi_spesa(var_TIPO_SPESA varchar,
                            var_DAL date) is
               select 1
                 from   TIPI_SPESA
                where  TIPO_SPESA = var_TIPO_SPESA and
                       DAL = var_DAL;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "TIPI_SPESA"
               if :new.TIPO_SPESA is not null and
                  :new.DAL is not null then
                  open  cpk_tipi_spesa(:new.TIPO_SPESA,
                                 :new.DAL);
                  fetch cpk_tipi_spesa into dummy;
                  found := cpk_tipi_spesa%FOUND;
                  close cpk_tipi_spesa;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.TIPO_SPESA||' '||
                               :new.DAL||
                               '" gia'' presente in TIPI_SPESA. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: TIPI_SPESA_TMB */
/

create or replace procedure TIPI_SPESA_PD
/******************************************************************************
 NOME:        TIPI_SPESA_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table TIPI_SPESA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger TIPI_SPESA_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_tipo_spesa IN varchar,
 old_dal IN date,
 old_al IN date)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "LIMITI_IMPORTO_SPESA"
   cursor cfk1_limiti_importo_spesa(var_tipo_spesa varchar,var_dal date,var_al date) is
      select 1
      from   LIMITI_IMPORTO_SPESA
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   dal between var_dal and nvl(var_al,to_date('3333333','j'));
   --  Declaration of DeleteParentRestrict constraint for "TARIFFE"
   cursor cfk2_tariffe(var_tipo_spesa varchar,var_dal date,var_al date) is
      select 1
      from   TARIFFE
      where  TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   dal between var_dal and nvl(var_al,to_date('3333333','j'));
   --  Declaration of DeleteParentRestrict constraint for "RIGHE_RICHIESTA_RIMBORSO"
   cursor cfk3_righe_richiesta_rimborso(var_tipo_spesa varchar,var_dal date,var_al date) is
      select 1
      from   RIGHE_RICHIESTA_RIMBORSO rirr, RICHIESTE_RIMBORSO riri
      where  rirr.riri_id = riri.riri_id
       and   rirr.TIPO_SPESA = var_tipo_spesa
       and   var_tipo_spesa is not null
       and   riri.data_inizio between var_dal and nvl(var_al,to_date('3333333','j'));
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "TIPI_SPESA" if children still exist in "LIMITI_IMPORTO_SPESA"
      open  cfk1_limiti_importo_spesa(OLD_TIPO_SPESA,OLD_DAL,OLD_AL);
      fetch cfk1_limiti_importo_spesa into dummy;
      found := cfk1_limiti_importo_spesa%FOUND; /* %FOUND */
      close cfk1_limiti_importo_spesa;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su LIMITI_IMPORTO_SPESA. La registrazione di TIPI_SPESA non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "TIPI_SPESA" if children still exist in "TARIFFE"
      open  cfk2_tariffe(OLD_TIPO_SPESA,OLD_DAL,OLD_AL);
      fetch cfk2_tariffe into dummy;
      found := cfk2_tariffe%FOUND; /* %FOUND */
      close cfk2_tariffe;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su TARIFFE. La registrazione di TIPI_SPESA non e'' eliminabile.';
          raise integrity_error;
      end if;
      --  Cannot delete parent "TIPI_SPESA" if children still exist in "RIGHE_RICHIESTA_RIMBORSO"
      open  cfk3_righe_richiesta_rimborso(OLD_TIPO_SPESA,OLD_DAL,OLD_AL);
      fetch cfk3_righe_richiesta_rimborso into dummy;
      found := cfk3_righe_richiesta_rimborso%FOUND; /* %FOUND */
      close cfk3_righe_richiesta_rimborso;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su RIGHE_RICHIESTA_RIMBORSO. La registrazione di TIPI_SPESA non e'' eliminabile.';
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
/* End Procedure: TIPI_SPESA_PD */
/

create or replace trigger TIPI_SPESA_TDB
   before DELETE on TIPI_SPESA
for each row
/******************************************************************************
 NOME:        TIPI_SPESA_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table TIPI_SPESA
 ANNOTAZIONI: Richiama Procedure TIPI_SPESA_TD
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
      TIPI_SPESA_PD(:OLD.TIPO_SPESA,
                    :OLD.DAL,
                    :OLD.AL);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: TIPI_SPESA_TDB */
/
