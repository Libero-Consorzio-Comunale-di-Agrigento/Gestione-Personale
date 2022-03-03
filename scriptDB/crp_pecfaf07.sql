CREATE OR REPLACE PACKAGE PECFAF07 IS
/******************************************************************************
 NOME:        PECXLF07
 DESCRIZIONE: DEFIZIONE DIZIONARI FISCALI PER LEGGE FINANZIARIA 2007
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  07/12/2006   ML   Prima emissione
 1.1  04/02/2007   MS   Modifica per tempi di elaborazione patch
 1.2  29/05/2007   ML   Modifica tabelle Circolare 88 al 18-5-2007 (A21297).
******************************************************************************/
FUNCTION  VERSIONE                RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECFAF07 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 29/05/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
declare
  D_dummy       varchar2(1);
  D_codice      varchar2(2);
  D_tabella     varchar2(3);
  D_tab_inps    varchar2(3);
  D_tabelle     varchar2(1);
  esci_condizioni exception;
  esci_scaglione  exception;
  esci_eseguito   exception;
BEGIN
BEGIN
  select valore
    into D_tabelle
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro      = 'P_TABELLE';
END;
BEGIN
    select 'x'
      into D_dummy
      from validita_assegni_familiari
     where dal = to_date('01012007','ddmmyyyy')
       and al is null
    ;
BEGIN
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'I'
       and tabella        = '2'
       and tabella_inps   = '14'
       and codice         = 'IN';
       raise too_many_rows;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN null;
       WHEN TOO_MANY_ROWS THEN
            D_codice  := 'I';
            D_tabella  := '2';
            D_tab_inps := '14';
            RAISE esci_eseguito;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'L'
       and tabella        = '4'
       and tabella_inps   = '15'
       and codice         = 'SCIN';
       raise too_many_rows;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN null;
       WHEN TOO_MANY_ROWS THEN
            D_codice  := 'L';
            D_tabella  := '4';
            D_tab_inps := '15';
            RAISE esci_eseguito;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'A'
       and tabella        = '1'
       and tabella_inps   = '11';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice  := 'A';
            D_tabella  := '1';
            D_tab_inps := '11';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'B'
       and tabella        = '3'
       and tabella_inps   = '12';
   EXCEPTION WHEN NO_DATA_FOUND THEN
              D_codice   := 'B';
              D_tabella  := '3';
              D_tab_inps := '12';
              RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'C'
       and tabella        = '2'
       and tabella_inps   = '14';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'C';
            D_tabella  := '2';
            D_tab_inps := '14';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'C'
       and tabella        = '5'
       and tabella_inps   = '17';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'C';
            D_tabella  := '5';
            D_tab_inps := '17';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'D'
       and tabella        = '4'
       and tabella_inps   = '15';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'D';
            D_tabella  := '4';
            D_tab_inps := '15';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'D'
       and tabella        = '6'
       and tabella_inps   = '18';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'D';
            D_tabella  := '6';
            D_tab_inps := '18';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'E'
       and tabella        = '7'
       and tabella_inps   = '21A';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'E';
            D_tabella  := '7';
            D_tab_inps := '21A';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'F'
       and tabella        = '11'
       and tabella_inps   = '21B';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'F';
            D_tabella  := '11';
            D_tab_inps := '21B';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'G'
       and tabella        = '12'
       and tabella_inps   = '21C';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'G';
            D_tabella  := '12';
            D_tab_inps := '21C';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'G'
       and tabella        = '8'
       and tabella_inps   = '20A';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'G';
            D_tabella  := '8';
            D_tab_inps := '20A';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'H'
       and tabella        = '10'
       and tabella_inps   = '20B';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'H';
            D_tabella  := '10';
            D_tab_inps := '20B';
            RAISE esci_condizioni;
  END;
  BEGIN
    select 'x'
      into D_dummy
      from CONDIZIONI_FAMILIARI
     where cod_scaglione  = 'H'
       and tabella        = '9'
       and tabella_inps   = '21D';
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_codice   := 'H';
            D_tabella  := '9';
            D_tab_inps := '21D';
            RAISE esci_condizioni;
  END;
  --
  -- eliminazioni registrazioni 2007
  --
IF D_tabelle = 'T' THEN
  delete from assegni_familiari
  where to_char(dal,'yyyy') = '2007';
  delete from scaglioni_assegno_familiare
  where to_char(dal,'yyyy') = '2007';
  insert into ASSEGNI_FAMILIARI
  (DAL, AL, SCAGLIONE, NUMERO, TABELLA, IMPORTO, IMPORTO2, INTEGRATIVO, AUMENTO, NUMERO_FASCIA)
  select DAL, AL, SCAGLIONE, NUMERO, TABELLA, IMPORTO, IMPORTO2, INTEGRATIVO, AUMENTO, NUMERO_FASCIA
     from asfa_lfin_2007;
  insert into SCAGLIONI_ASSEGNO_FAMILIARE
  (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
  select DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA
     from scaf_lfin_2007;
ELSIF D_tabelle = 'V' THEN
      BEGIN
         select 'x'
          into D_dummy
          from CONDIZIONI_FAMILIARI
         where cod_scaglione  = 'I'
           and codice        != 'IN';
         raise too_many_rows;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN null;
        WHEN TOO_MANY_ROWS THEN
             D_codice   := 'I';
             RAISE esci_scaglione;
      END;
      BEGIN
         select 'x'
          into D_dummy
          from CONDIZIONI_FAMILIARI
         where cod_scaglione  = 'L'
           and codice        != 'SCIN';
         raise too_many_rows;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN null;
        WHEN TOO_MANY_ROWS THEN
                D_codice   := 'L';
                RAISE esci_scaglione;
      END;
      update CONDIZIONI_FAMILIARI cofa
         set COD_SCAGLIONE  = 'I'
       where TABELLA_INPS = 14
         and codice = 'IN'
         and COD_SCAGLIONE  = 'C'
         and tabella = 2
      ;
      delete from scaglioni_assegno_familiare
       where cod_scaglione = 'I'
         and dal           = to_date('01012007','ddmmyyyy')
      ;
      insert into scaglioni_assegno_familiare
            (DAL
            ,AL
            ,SCAGLIONE
            ,COD_SCAGLIONE
            ,NUMERO_FASCIA
            )
      select dal,al,scaglione,cod_scaglione,numero_fascia
        from SCAF_200705
       where cod_scaglione = 'I'
      ;
      delete from assegni_familiari
       where dal = to_date('01012007','ddmmyyyy')
         and tabella = 2
      ;
      insert into assegni_familiari
            (DAL
            ,AL
            ,SCAGLIONE
            ,NUMERO
            ,TABELLA
            ,IMPORTO
            ,NUMERO_FASCIA
            )
      select DAL,AL,SCAGLIONE,NUMERO,TABELLA,IMPORTO,NUMERO_FASCIA
        from asfa_200705
       where tabella = 2
      ;
      update CONDIZIONI_FAMILIARI cofa
         set COD_SCAGLIONE  = 'L'
       where TABELLA_INPS = 15
         and codice = 'SCIN'
         and COD_SCAGLIONE  = 'D'
         and tabella = 4
      ;
      delete from scaglioni_assegno_familiare
       where cod_scaglione = 'L'
         and dal           = to_date('01012007','ddmmyyyy')
      ;
      insert into scaglioni_assegno_familiare
            (DAL
            ,AL
            ,SCAGLIONE
            ,COD_SCAGLIONE
            ,NUMERO_FASCIA
            )
      select dal,al,scaglione,cod_scaglione,numero_fascia
        from SCAF_200705
       where cod_scaglione = 'L'
      ;
      delete from assegni_familiari
       where dal = to_date('01012007','ddmmyyyy')
         and tabella = 4
      ;
      insert into assegni_familiari
            (DAL
            ,AL
            ,SCAGLIONE
            ,NUMERO
            ,TABELLA
            ,IMPORTO
            ,NUMERO_FASCIA
            )
      select DAL,AL,SCAGLIONE,NUMERO,TABELLA,IMPORTO,NUMERO_FASCIA
        from asfa_200705
       where tabella = 4
      ;
END IF;
EXCEPTION
 WHEN ESCI_SCAGLIONE THEN
      update a_prenotazioni
         set errore = 'Scaglione attualmente in uso: '||D_codice||' - Fase non eseguita'
       where no_prenotazione = prenotazione;
 WHEN ESCI_CONDIZIONI THEN
      update a_prenotazioni
         set errore = 'Condizioni Assegni familiari '||D_codice||'/'||D_tabella||'/'||D_tab_inps||' non definite - Fase non eseguita'
       where no_prenotazione = prenotazione;
 WHEN ESCI_ESEGUITO THEN
      update a_prenotazioni
         set errore = 'Condizione Ass.Fam. gia'' presente '||D_codice||'/'||D_tabella||'/'||D_tab_inps||' aggiornamento eleborato precedentemente'
       where no_prenotazione = prenotazione;
END;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    update a_prenotazioni
       set errore = 'Validita'' Assegni Familiari 01/01/2007 non presente - Fase non eseguita'
     where no_prenotazione = prenotazione;
  END;
  END;
end main;
end PECFAF07;
/
