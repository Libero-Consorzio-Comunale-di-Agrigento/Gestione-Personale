CREATE OR REPLACE PACKAGE PECF2007 IS
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
 1    07/12/2006   ML   Prima emissione
******************************************************************************/
FUNCTION  VERSIONE                RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECF2007 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1 del 07/12/2006';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
declare
  D_dummy     varchar2(1);
  D_scaglioni varchar2(1);
  D_progressivo number := 0;
  BEGIN
    select 'x'
      into D_dummy
      from validita_fiscale
     where dal = to_date('01012007','ddmmyyyy')
    ;
  BEGIN
    select valore
      into D_scaglioni
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_SCAGLIONI';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  --
  -- detrazioni fiscali
  --
  delete from detrazioni_fiscali
  where to_char(dal,'yyyy') = '2007';
  update detrazioni_fiscali
  set al = to_date('31122006','ddmmyyyy')
  where to_char(dal,'yyyy') = '2006' and al is null;
  
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 21, 1348, 23000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 1, 1, 750, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 1, 1, 375, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 2, 1, 1500, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 2, 1, 1500, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 2, 1, 750, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 3, 1, 2250, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 3, 1, 2250, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 3, 1, 1125, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 4, 1, 3000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 4, 1, 3000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 4, 1, 1500, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 0, 800, 0);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FD', 1, 1, 800, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FD', 2, 1, 1600, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FD', 3, 1, 2400, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FD', 4, 1, 4000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FD', 5, 1, 5000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 1, 1, 110, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 2, 1, 220, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 3, 1, 330, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 1, 1, 800, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 1, 1, 800, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 1, 1, 400, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 2, 1, 1600, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 2, 1, 1600, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 2, 1, 800, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 3, 1, 2400, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 3, 1, 2400, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 3, 1, 1200, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 4, 1, 4000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 4, 1, 4000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 4, 1, 2000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 5, 1, 5000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 5, 1, 5000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 5, 1, 2500, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 6, 1, 6000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 6, 1, 6000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 6, 1, 3000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 7, 1, 7000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 7, 1, 7000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 7, 1, 3500, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 8, 1, 8000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 8, 1, 8000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FG', 8, 1, 4000, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 2, 1, 440, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 1, 1, 220, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 4, 1, 440, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 3, 1, 660, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 4, 1, 880, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 10, 690, 15000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 20, 690, 40000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 30, 0, 80000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 11, 700, 29000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 12, 710, 29200);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 13, 720, 34700);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 14, 710, 35000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 15, 700, 35100);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'CN', 1, 16, 690, 35200);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'P2', null, 0, 1783, 0);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 1, 1, 100, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 1, 1, 100, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 1, 1, 50, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 2, 1, 200, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 2, 1, 200, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 2, 1, 100, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 3, 1, 300, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 3, 1, 300, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FM', 3, 1, 150, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'P2', null, 10, 1297, 7750);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'P2', null, 20, 1297, 15000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 22, 1358, 24000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('AC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'AL', 1, 1, 750, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 30, 0, 55000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 20, 1338, 15000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 10, 1338, 8000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 23, 1368, 25000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'HD', 2, 1, 440, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'HD', 3, 1, 660, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'HD', 4, 1, 880, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 24, 1378, 26000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 25, 1363, 27700);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 26, 1338, 28000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DP', null, 0, 1725, 0);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DP', null, 10, 1255, 7500);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DP', null, 20, 1255, 15000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DP', null, 30, 0, 55000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'P2', null, 30, 0, 55000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'HD', 1, 1, 220, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'MD', 1, 1, 100, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DA', null, 20, 1104, 4800);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'MD', 2, 1, 200, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DD', null, 0, 1840, 0);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DA', null, 30, 0, 55000);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('*', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'DA', null, 0, 1104, 0);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 1, 1, 220, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 2, 1, 440, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 3, 1, 660, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('CC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'FH', 4, 1, 880, null);
insert into DETRAZIONI_FISCALI (CODICE, DAL, AL, TIPO, NUMERO, SCAGLIONE, IMPORTO, IMPONIBILE)
values ('NC', to_date('01-01-2007', 'dd-mm-yyyy'), null, 'MD', 3, 1, 300, null);
  --
  -- scaglioni fiscali
  --
  delete from scaglioni_fiscali
  where to_char(dal,'yyyy') = '2007';
  update scaglioni_fiscali
  set al = to_date('31122006','ddmmyyyy')
  where to_char(dal,'yyyy') = '2006' and al is null;
  insert into SCAGLIONI_FISCALI (DAL, AL, SCAGLIONE, ALIQUOTA, IMPOSTA)
  values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 0, 23, 0);
  insert into SCAGLIONI_FISCALI (DAL, AL, SCAGLIONE, ALIQUOTA, IMPOSTA)
  values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15000, 27, 3450);
  insert into SCAGLIONI_FISCALI (DAL, AL, SCAGLIONE, ALIQUOTA, IMPOSTA)
  values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28000, 38, 6960);
  insert into SCAGLIONI_FISCALI (DAL, AL, SCAGLIONE, ALIQUOTA, IMPOSTA)
  values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55000, 41, 17220);
  insert into SCAGLIONI_FISCALI (DAL, AL, SCAGLIONE, ALIQUOTA, IMPOSTA)
  values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75000, 43, 25420);
  --
  -- validita fiscale
  --
  delete from validita_fiscale
  where to_char(dal,'yyyy') = '2007';
  update validita_fiscale
  set al = to_date('31122006','ddmmyyyy')
  where to_char(dal,'yyyy') = '2006' and al is null;
  insert into VALIDITA_FISCALE
        ( DAL, AL, NOTE, ALIQUOTA_IRPEF_COMUNALE, ALIQUOTA_IRPEF_REGIONALE, ALIQUOTA_IRPEF_PROVINCIALE
        , RIDUZIONI_TFR, DETRAZIONI_TFR, VAL_CONV_DED, DED_FIS_BASE, VAL_CONV_DED_FAM
        , VAL_CONV_DET_FAM, VAL_CONV_DET_AGG_FIG, VAL_CONV_DET_DIP, VAL_CONV_DET_PEN1, VAL_CONV_DET_PEN2
        , VAL_MIN_DET_DIP, VAL_MIN_DET_PEN1, VAL_MIN_DET_PEN2)
  values ( to_date('01-01-2007', 'dd-mm-yyyy'), null, null, null, .9, null
         , 309.87, null, null, null, null
         , 80000, 15000, 502, 470, 486, 690, 690, 713);
  --
  -- carichi_familiari
  --
  update carichi_familiari
     set scaglione_coniuge = null
       , scaglione_figli   = null
   where anno = 2007
     and nvl(scaglione_coniuge,0) + nvl(scaglione_figli,0) != 0
     and D_scaglioni is not null
  ;
           D_progressivo := D_progressivo + 1;
           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,D_progressivo,
                   lpad(' ',34,' ')||'LISTA CARICHI FAMILIARI   2007'
                  );
           D_progressivo := D_progressivo + 1;
           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,D_progressivo,
                   lpad(' ',34,' ')||'------------------------------'
                  );
           D_progressivo := D_progressivo + 1;
           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,D_progressivo,
                   lpad(' ',30,' ')
                  );
           D_progressivo := D_progressivo + 1;
           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,D_progressivo,
                   lpad(' ',30,' ')
                  );
                  
           D_progressivo := D_progressivo + 1;
           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,D_progressivo,
                   'COD.IND.'||'  '||
                   rpad('NOMINATIVO',40,' ')||'  '||
                   'MESE'||'  '||
                   'FIGLI '||'  '||
                   'INTERI'||'  '||
                   'TOTALE'
                  );

           D_progressivo := D_progressivo + 1;
           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,D_progressivo,
                   '--------'||'  '||
                   rpad('-',40,'-')||'  '||
                   '----'||'  '||
                   '------'||'  '||
                   '------'||'  '||
                   '------'
                  );
  
  FOR CUR_CAFA IN
     (select rain.ci ci
           , rain.cognome||'  '||rain.nome nominativo
           , cafa.mese
           , nvl(to_char(cafa.figli),' ') figli
           , nvl(to_char(cafa.figli_dd),' ') interi
           , nvl(cafa.figli,0) + nvl(cafa.figli_dd,0) totale
        from carichi_familiari cafa
           , rapporti_individuali rain
       where rain.ci   = cafa.ci
         and cafa.anno = 2007 
         and nvl(cafa.figli,0) + nvl(cafa.figli_dd,0) != 0
       order by nvl(cafa.figli,0) + nvl(cafa.figli_dd,0) desc
              , rain.cognome||'  '||rain.nome, cafa.mese
     ) LOOP 
         BEGIN
           D_progressivo := D_progressivo + 1;
           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,D_progressivo,
                   lpad(to_char(cur_cafa.ci),8,' ')||'  '||
                   rpad(cur_cafa.nominativo,40,' ')||'  '||
                   lpad(to_char(cur_cafa.mese),4,' ')||'  '||
                   lpad(cur_cafa.figli,6,' ')||'  '||
                   lpad(cur_cafa.interi,6,' ')||'  '||
                   lpad(to_char(cur_cafa.totale),6,' ')
                  );
         END;
       END LOOP;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    update a_prenotazioni
       set errore = 'Validita'' Fiscale 01/01/2007 non presente - Fase non eseguita'
     where no_prenotazione = prenotazione;
  END; -- select into
end main; -- declaration
end PECF2007;
/
