/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     13/02/2003 10.43.45                          */
/*==============================================================*/

create or replace procedure AREE_PU
/******************************************************************************
 NOME:        AREE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table AREE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AREE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_area IN varchar
 , new_area IN varchar
)
is  
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of UpdateParentRestrict constraint for "DOTAZIONE_ORGANICA"
   cursor cfk1_dotazione_organica(var_area varchar) is
      select 1
      from   DOTAZIONE_ORGANICA
      where  AREA = var_area
       and   var_area is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Chiave di "AREE" non modificabile se esistono referenze su "DOTAZIONE_ORGANICA"
      if (OLD_AREA != NEW_AREA) then
         open  cfk1_dotazione_organica(OLD_AREA);
         fetch cfk1_dotazione_organica into dummy;
         found := cfk1_dotazione_organica%FOUND; /* %FOUND */
         close cfk1_dotazione_organica;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Dotazione Organica. La registrazione di Aree non e'' modificabile.';
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
/* End Procedure: AREE_PU */
/

create or replace trigger AREE_TMB
   before INSERT or UPDATE on AREE
for each row
/******************************************************************************
 NOME:        AREE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table AREE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure AREE_PI e AREE_PU
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
         AREE_PU(:OLD.AREA
                         , :NEW.AREA
                         );
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "AREE"
            cursor cpk_aree(var_AREA varchar) is
               select 1
                 from   AREE
                where  AREA = var_AREA;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "AREE"
               if :new.AREA is not null then
                  open  cpk_aree(:new.AREA);
                  fetch cpk_aree into dummy;
                  found := cpk_aree%FOUND;
                  close cpk_aree;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.AREA||
                               '" gia'' presente in Aree. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: AREE_TMB */
/

create or replace procedure AREE_PD
/******************************************************************************
 NOME:        AREE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table AREE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger AREE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_area IN varchar)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "DOTAZIONE_ORGANICA"
   cursor cfk1_dotazione_organica(var_area varchar) is
      select 1
      from   DOTAZIONE_ORGANICA
      where  AREA = var_area
       and   var_area <> '%'
       and   var_area is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "AREE" if children still exist in "DOTAZIONE_ORGANICA"
      open  cfk1_dotazione_organica(OLD_AREA);
      fetch cfk1_dotazione_organica into dummy;
      found := cfk1_dotazione_organica%FOUND; /* %FOUND */
      close cfk1_dotazione_organica;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Dotazione Organica. La registrazione di Aree non e'' eliminabile.';
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
/* End Procedure: AREE_PD */
/

create or replace trigger AREE_TDB
   before DELETE on AREE
for each row
/******************************************************************************
 NOME:        AREE_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table AREE
 ANNOTAZIONI: Richiama Procedure AREE_TD
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
      AREE_PD(:OLD.AREA);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: AREE_TDB */
/

CREATE OR REPLACE PROCEDURE dotazione_organica_pi 
/******************************************************************************
 NOME:        DOTAZIONE_ORGANICA_PI
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at INSERT on Table DOTAZIONE_ORGANICA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20002, Non esiste riferimento su TABLE
             -20008, Numero di CHILD assegnato a TABLE non ammesso
 ANNOTAZIONI: Richiamata da Trigger DOTAZIONE_ORGANICA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(
   new_revisione              IN       NUMBER
  ,new_gestione               IN       VARCHAR
  ,new_settore                IN       VARCHAR
  ,new_ruolo                  IN       VARCHAR
  ,new_profilo                IN       VARCHAR
  ,new_posizione              IN       VARCHAR
  ,new_attivita               IN       VARCHAR
  ,new_figura                 IN       VARCHAR
  ,new_qualifica              IN       VARCHAR
  ,new_livello                IN       VARCHAR
  ,new_tipo_rapporto          IN       VARCHAR
) IS
   integrity_error   EXCEPTION;
   errno             INTEGER;
   errmsg            CHAR (200);
   dummy             INTEGER;
   d_dummy           CHAR (1);
   FOUND             BOOLEAN;
   CARDINALITY       INTEGER;
   mutating          EXCEPTION;
   PRAGMA EXCEPTION_INIT (mutating, -4091);

   --  Dichiarazione di InsertChildParentExist per la tabella padre "REVISIONI_DOTAZIONE"
   CURSOR cpk1_dotazione_organica (
      var_revisione                       NUMBER
   ) IS
      SELECT 1
        FROM revisioni_dotazione
       WHERE revisione = var_revisione
         AND var_revisione IS NOT NULL;
BEGIN
   BEGIN                                                             -- Check REFERENTIAL Integrity
      BEGIN
         --  Parent "REVISIONI_DOTAZIONE" deve esistere quando si inserisce su "DOTAZIONE_ORGANICA"
         IF new_revisione IS NOT NULL THEN
            OPEN cpk1_dotazione_organica (new_revisione);

            FETCH cpk1_dotazione_organica
             INTO dummy;

            FOUND            := cpk1_dotazione_organica%FOUND;                          /* %FOUND */

            CLOSE cpk1_dotazione_organica;

            IF NOT FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su Revisioni Dotazione. La registrazione Dotazione Organica non puo'' essere inserita.';
               RAISE integrity_error;
            END IF;
         END IF;
      EXCEPTION
         WHEN mutating THEN
            NULL;                                            -- Ignora Check su Relazioni Ricorsive
      END;

      --null;
      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM gestioni_amministrative
             WHERE codice LIKE new_gestione;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su GESTIONI AMMINISTRATIVE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

/*
BEGIN
  BEGIN
    select 'x'
     into d_dummy
     from aree
    where area like NEW_area
   ;
  EXCEPTION when too_many_rows then null;
            when no_data_found then
                 errno  := -20002;
                 errmsg := 'Non esiste riferimento su AREE. La registrazione non puo'' essere inserita.';
                 raise integrity_error;
  END;
END;
*/
      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM unita_organizzative
             WHERE codice_uo LIKE new_settore;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su UNITA ORGANIZZATIVE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM ruoli
             WHERE codice LIKE new_ruolo;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                     'Non esiste riferimento su RUOLI. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM profili_professionali
             WHERE codice LIKE new_profilo;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su PROFILI PROFESSIONALI. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM posizioni_funzionali
             WHERE codice LIKE new_posizione
               AND profilo LIKE new_profilo;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su POSIZIONI FUNZIONALI. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM attivita
             WHERE codice LIKE new_attivita
                OR new_attivita = 'NULL';
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su ATTIVITA. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM figure_giuridiche
             WHERE codice LIKE new_figura;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su FIGURE GIURIDICHE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM qualifiche_giuridiche
             WHERE codice LIKE new_qualifica;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su QUALIFICHE GIURIDICHE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM qualifiche_giuridiche
             WHERE livello LIKE new_livello;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su QUALIFICHE GIURIDICHE (LIVELLO). La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM tipi_rapporto
             WHERE codice LIKE new_tipo_rapporto
                OR new_tipo_rapporto = 'NULL';
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su TIPI RAPPORTO. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;
   END;
EXCEPTION
   WHEN integrity_error THEN
      integritypackage.initnestlevel;
      raise_application_error (errno, errmsg);
   WHEN OTHERS THEN
      integritypackage.initnestlevel;
      RAISE;
END;
/* End Procedure: DOTAZIONE_ORGANICA_PI */
/

CREATE OR REPLACE PROCEDURE dotazione_organica_pu 
/******************************************************************************
 NOME:        DOTAZIONE_ORGANICA_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table DOTAZIONE_ORGANICA
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger DOTAZIONE_ORGANICA_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(
   old_revisione              IN       NUMBER
  ,old_gestione               IN       VARCHAR
  ,old_area                   IN       VARCHAR
  ,old_settore                IN       VARCHAR
  ,old_ruolo                  IN       VARCHAR
  ,old_profilo                IN       VARCHAR
  ,old_posizione              IN       VARCHAR
  ,old_attivita               IN       VARCHAR
  ,old_figura                 IN       VARCHAR
  ,old_qualifica              IN       VARCHAR
  ,old_livello                IN       VARCHAR
  ,old_tipo_rapporto          IN       VARCHAR
  ,old_ore                    IN       NUMBER
  ,new_revisione              IN       NUMBER
  ,new_gestione               IN       VARCHAR
  ,new_area                   IN       VARCHAR
  ,new_settore                IN       VARCHAR
  ,new_ruolo                  IN       VARCHAR
  ,new_profilo                IN       VARCHAR
  ,new_posizione              IN       VARCHAR
  ,new_attivita               IN       VARCHAR
  ,new_figura                 IN       VARCHAR
  ,new_qualifica              IN       VARCHAR
  ,new_livello                IN       VARCHAR
  ,new_tipo_rapporto          IN       VARCHAR
  ,new_ore                    IN       NUMBER
) IS
   integrity_error   EXCEPTION;
   errno             INTEGER;
   errmsg            CHAR (200);
   dummy             INTEGER;
   d_dummy           CHAR (1);
   FOUND             BOOLEAN;
   seq               NUMBER;
   mutating          EXCEPTION;
   PRAGMA EXCEPTION_INIT (mutating, -4091);

   --  Dichiarazione UpdateChildParentExist constraint per la tabella "REVISIONI_DOTAZIONE"
   CURSOR cpk1_dotazione_organica (
      var_revisione                       NUMBER
   ) IS
      SELECT 1
        FROM revisioni_dotazione
       WHERE revisione = var_revisione
         AND var_revisione IS NOT NULL;
BEGIN
   BEGIN                                                             -- Check REFERENTIAL Integrity
      seq              := integritypackage.getnestlevel;

      BEGIN  --  Parent "REVISIONI_DOTAZIONE" deve esistere quando si modifica "DOTAZIONE_ORGANICA"
         IF     new_revisione IS NOT NULL
            AND (seq = 0)
            AND ( (   new_revisione != old_revisione
                   OR old_revisione IS NULL) ) THEN
            OPEN cpk1_dotazione_organica (new_revisione);

            FETCH cpk1_dotazione_organica
             INTO dummy;

            FOUND            := cpk1_dotazione_organica%FOUND;                          /* %FOUND */

            CLOSE cpk1_dotazione_organica;

            IF NOT FOUND THEN
               errno            := -20003;
               errmsg           :=
                  'Non esiste riferimento su Revisioni Dotazione. La registrazione Dotazione Organica non e'' modificabile.';
               RAISE integrity_error;
            END IF;
         END IF;
      EXCEPTION
         WHEN mutating THEN
            NULL;                                            -- Ignora Check su Relazioni Ricorsive
      END;

      --null;
      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM gestioni_amministrative
             WHERE codice LIKE new_gestione;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su GESTIONI AMMINISTRATIVE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM aree
             WHERE area LIKE new_area;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                      'Non esiste riferimento su AREE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM unita_organizzative
             WHERE codice_uo LIKE new_settore;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su UNITA ORGANIZZATIVE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM ruoli
             WHERE codice LIKE new_ruolo;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                     'Non esiste riferimento su RUOLI. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM profili_professionali
             WHERE codice LIKE new_profilo;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su PROFILI PROFESSIONALI. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM posizioni_funzionali
             WHERE codice LIKE new_posizione
               AND profilo LIKE new_profilo;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su POSIZIONI FUNZIONALI. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM attivita
             WHERE codice LIKE new_attivita
                OR new_attivita = 'NULL';
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su ATTIVITA. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM figure_giuridiche
             WHERE codice LIKE new_figura;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su FIGURE GIURIDICHE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM qualifiche_giuridiche
             WHERE codice LIKE new_qualifica;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su QUALIFICHE GIURIDICHE. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM qualifiche_giuridiche
             WHERE livello LIKE new_livello;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su QUALIFICHE GIURIDICHE (LIVELLO). La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;

      BEGIN
         BEGIN
            SELECT 'x'
              INTO d_dummy
              FROM tipi_rapporto
             WHERE codice LIKE new_tipo_rapporto
                OR new_tipo_rapporto = 'NULL';
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               NULL;
            WHEN NO_DATA_FOUND THEN
               errno            := -20002;
               errmsg           :=
                  'Non esiste riferimento su TIPI RAPPORTO. La registrazione non puo'' essere inserita.';
               RAISE integrity_error;
         END;
      END;
   END;
EXCEPTION
   WHEN integrity_error THEN
      integritypackage.initnestlevel;
      raise_application_error (errno, errmsg);
   WHEN OTHERS THEN
      integritypackage.initnestlevel;
      RAISE;
END;
/* End Procedure: DOTAZIONE_ORGANICA_PU */
/

create or replace trigger DOTAZIONE_ORGANICA_TMB
   before INSERT or UPDATE on DOTAZIONE_ORGANICA
for each row
/******************************************************************************
 NOME:        DOTAZIONE_ORGANICA_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table DOTAZIONE_ORGANICA
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure DOTAZIONE_ORGANICA_PI e DOTAZIONE_ORGANICA_PU
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
         DOTAZIONE_ORGANICA_PU(:OLD.REVISIONE
                       , :OLD.GESTIONE
                       , :OLD.AREA
                       , :OLD.SETTORE
                       , :OLD.RUOLO
                       , :OLD.PROFILO
                       , :OLD.POSIZIONE
                       , :OLD.ATTIVITA
                       , :OLD.FIGURA
                       , :OLD.QUALIFICA
                       , :OLD.LIVELLO
                       , :OLD.TIPO_RAPPORTO
                       , :OLD.ORE
                         , :NEW.REVISIONE
                         , :NEW.GESTIONE
                         , :NEW.AREA
                         , :NEW.SETTORE
                         , :NEW.RUOLO
                         , :NEW.PROFILO
                         , :NEW.POSIZIONE
                         , :NEW.ATTIVITA
                         , :NEW.FIGURA
                         , :NEW.QUALIFICA
                         , :NEW.LIVELLO
                         , :NEW.TIPO_RAPPORTO
                         , :NEW.ORE
                         );
         null;
      end if;
      if INSERTING then
         DOTAZIONE_ORGANICA_PI(:NEW.REVISIONE,:NEW.GESTIONE, :NEW.SETTORE, :NEW.RUOLO, :NEW.PROFILO, :NEW.POSIZIONE, :NEW.ATTIVITA, :NEW.FIGURA, :NEW.QUALIFICA, :NEW.LIVELLO, :NEW.TIPO_RAPPORTO);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "DOTAZIONE_ORGANICA"
            cursor cpk_dotazione_organica(var_REVISIONE number,
                            var_GESTIONE varchar,
                            var_AREA varchar,
                            var_SETTORE varchar,
                            var_RUOLO varchar,
                            var_PROFILO varchar,
                            var_POSIZIONE varchar,
                            var_ATTIVITA varchar,
                            var_FIGURA varchar,
                            var_QUALIFICA varchar,
                            var_LIVELLO varchar,
                            var_TIPO_RAPPORTO varchar,
                            var_ORE number) is
               select 1
                 from   DOTAZIONE_ORGANICA
                where  REVISIONE = var_REVISIONE and
                       GESTIONE = var_GESTIONE and
                       AREA = var_AREA and
                       SETTORE = var_SETTORE and
                       RUOLO = var_RUOLO and
                       PROFILO = var_PROFILO and
                       POSIZIONE = var_POSIZIONE and
                       ATTIVITA = var_ATTIVITA and
                       FIGURA = var_FIGURA and
                       QUALIFICA = var_QUALIFICA and
                       LIVELLO = var_LIVELLO and
                       TIPO_RAPPORTO = var_TIPO_RAPPORTO and
                       ORE = var_ORE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "DOTAZIONE_ORGANICA"
               if :new.REVISIONE is not null and
                  :new.GESTIONE is not null and
                  :new.AREA is not null and
                  :new.SETTORE is not null and
                  :new.RUOLO is not null and
                  :new.PROFILO is not null and
                  :new.POSIZIONE is not null and
                  :new.ATTIVITA is not null and
                  :new.FIGURA is not null and
                  :new.QUALIFICA is not null and
                  :new.LIVELLO is not null and
                  :new.TIPO_RAPPORTO is not null and
                  :new.ORE is not null then
                  open  cpk_dotazione_organica(:new.REVISIONE,
                                 :new.GESTIONE,
                                 :new.AREA,
                                 :new.SETTORE,
                                 :new.RUOLO,
                                 :new.PROFILO,
                                 :new.POSIZIONE,
                                 :new.ATTIVITA,
                                 :new.FIGURA,
                                 :new.QUALIFICA,
                                 :new.LIVELLO,
                                 :new.TIPO_RAPPORTO,
                                 :new.ORE);
                  fetch cpk_dotazione_organica into dummy;
                  found := cpk_dotazione_organica%FOUND;
                  close cpk_dotazione_organica;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.REVISIONE||' '||
                               :new.GESTIONE||' '||
                               :new.AREA||' '||
                               :new.SETTORE||' '||
                               :new.RUOLO||' '||
                               :new.PROFILO||' '||
                               :new.POSIZIONE||' '||
                               :new.ATTIVITA||' '||
                               :new.FIGURA||' '||
                               :new.QUALIFICA||' '||
                               :new.LIVELLO||' '||
                               :new.TIPO_RAPPORTO||' '||
                               :new.ORE||
                               '" gia'' presente in Dotazione Organica. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity;
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
/* End Trigger: DOTAZIONE_ORGANICA_TMB */
/

create or replace procedure REVISIONI_DOTAZIONE_PU
/******************************************************************************
 NOME:        REVISIONI_DOTAZIONE_PU
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at UPDATE on Table REVISIONI_DOTAZIONE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20001, Informazione COLONNA non modificabile
             -20003, Non esiste riferimento su PARENT TABLE
             -20004, Identificazione di TABLE non modificabile
             -20005, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_DOTAZIONE_TMB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(  old_revisione IN number
 , new_revisione IN number
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
   --  Declaration of UpdateParentRestrict constraint for "DOTAZIONE_ORGANICA"
   cursor cfk1_dotazione_organica(var_revisione number) is
      select 1
      from   DOTAZIONE_ORGANICA
      where  REVISIONE = var_revisione
       and   var_revisione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      seq := IntegrityPackage.GetNestLevel;
      --  Chiave di "REVISIONI_DOTAZIONE" non modificabile se esistono referenze su "DOTAZIONE_ORGANICA"
      if (OLD_REVISIONE != NEW_REVISIONE) then
         open  cfk1_dotazione_organica(OLD_REVISIONE);
         fetch cfk1_dotazione_organica into dummy;
         found := cfk1_dotazione_organica%FOUND; /* %FOUND */
         close cfk1_dotazione_organica;
         if found then
          errno  := -20005;
          errmsg := 'Esistono riferimenti su Dotazione Organica. La registrazione di Revisioni Dotazione non e'' modificabile.';
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
/* End Procedure: REVISIONI_DOTAZIONE_PU */
/

create or replace trigger REVISIONI_DOTAZIONE_TMB
   before INSERT or UPDATE on REVISIONI_DOTAZIONE
for each row
/******************************************************************************
 NOME:        REVISIONI_DOTAZIONE_TMB
 DESCRIZIONE: Trigger for Check DATA Integrity
                          Check REFERENTIAL Integrity
                       at INSERT or UPDATE on Table REVISIONI_DOTAZIONE
 ECCEZIONI:   -20007, Identificazione CHIAVE presente in TABLE 
 ANNOTAZIONI: Richiama Procedure REVISIONI_DOTAZIONE_PI e REVISIONI_DOTAZIONE_PU
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
         REVISIONI_DOTAZIONE_PU(:OLD.REVISIONE
                         , :NEW.REVISIONE
                         );
         null;
      end if;
	if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "REVISIONI_DOTAZIONE"
            cursor cpk_revisioni_dotazione(var_REVISIONE number) is
               select 1
                 from   REVISIONI_DOTAZIONE
                where  REVISIONE = var_REVISIONE;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "REVISIONI_DOTAZIONE"
               if :new.REVISIONE is not null then
                  open  cpk_revisioni_dotazione(:new.REVISIONE);
                  fetch cpk_revisioni_dotazione into dummy;
                  found := cpk_revisioni_dotazione%FOUND;
                  close cpk_revisioni_dotazione;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.REVISIONE||
                               '" gia'' presente in Revisioni Dotazione. La registrazione  non puo'' essere inserita.';
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
/* End Trigger: REVISIONI_DOTAZIONE_TMB */
/

create or replace procedure REVISIONI_DOTAZIONE_PD
/******************************************************************************
 NOME:        REVISIONI_DOTAZIONE_PD
 DESCRIZIONE: Procedure for Check REFERENTIAL Integrity
                         at DELETE on Table REVISIONI_DOTAZIONE
 ARGOMENTI:   Rigenerati in automatico.
 ECCEZIONI:  -20006, Esistono riferimenti su CHILD TABLE
 ANNOTAZIONI: Richiamata da Trigger REVISIONI_DOTAZIONE_TDB
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
                        Generata in automatico.
******************************************************************************/
(old_revisione IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   --  Declaration of DeleteParentRestrict constraint for "DOTAZIONE_ORGANICA"
   cursor cfk1_dotazione_organica(var_revisione number) is
      select 1
      from   DOTAZIONE_ORGANICA
      where  REVISIONE = var_revisione
       and   var_revisione is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      --  Cannot delete parent "REVISIONI_DOTAZIONE" if children still exist in "DOTAZIONE_ORGANICA"
      open  cfk1_dotazione_organica(OLD_REVISIONE);
      fetch cfk1_dotazione_organica into dummy;
      found := cfk1_dotazione_organica%FOUND; /* %FOUND */
      close cfk1_dotazione_organica;
      if found then
          errno  := -20006;
          errmsg := 'Esistono riferimenti su Dotazione Organica. La registrazione di Revisioni Dotazione non e'' eliminabile.';
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
/* End Procedure: REVISIONI_DOTAZIONE_PD */
/

create or replace trigger REVISIONI_DOTAZIONE_TDB
   before DELETE on REVISIONI_DOTAZIONE
for each row
/******************************************************************************
 NOME:        REVISIONI_DOTAZIONE_TDB
 DESCRIZIONE: Trigger for Set FUNCTIONAL Integrity
                        Check REFERENTIAL Integrity
                       at DELETE on Table REVISIONI_DOTAZIONE
 ANNOTAZIONI: Richiama Procedure REVISIONI_DOTAZIONE_TD
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
      REVISIONI_DOTAZIONE_PD(:OLD.REVISIONE);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: REVISIONI_DOTAZIONE_TDB */
/
