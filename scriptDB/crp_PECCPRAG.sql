CREATE OR REPLACE PACKAGE peccprag IS
/******************************************************************************
 NOME:        PECCPRAG
 DESCRIZIONE: Cancellazione di Previsioni aggiuntive e/o di un certo badget.


 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1   02/10/2003  MV

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccprag IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 02/10/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
D_tipo   varchar2(1);
D_ci     number(8);
D_budget varchar2(4);
ESCI 	 exception;
begin

BEGIN
    select substr(valore,1,1)
      into D_tipo
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TIPO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_tipo := null;
END;

BEGIN
    select substr(valore,1,8)
      into D_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_ci := null;
END;

BEGIN
    select substr(valore,1,4)
      into D_budget
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_BUDGET'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_budget := null;
END;

if D_ci is null and D_budget is not null then
   delete from movimenti_contabili_previsione
   where budget = D_budget
   and ci >= 99980000;
end if;

if D_ci is not null and D_ci < 99980000 then
     update a_prenotazioni set errore = 'XXXXXX'
                            , prossimo_passo = 99
     where no_prenotazione = prenotazione;
	 raise esci;
	 
elsif D_ci is not null and D_ci >= 99980000 then
   if D_budget is not null then
      delete from movimenti_contabili_previsione
      where ci   = D_ci
      and budget = D_budget
      and ci >= 99980000;
   else
      delete from movimenti_contabili_previsione
      where ci   = D_ci
      and ci >= 99980000;
   end if;

  delete from periodi_retributivi_bp
  where ci = D_ci
  and ci >= 99980000
  ;
  delete from informazioni_retributive_bp
  where ci = D_ci
  and ci >= 99980000
  ;
  delete from informazioni_extracontabili
  where ci = D_ci
  and ci >= 99980000
  ;
  delete from rapporti_retributivi
  where ci = D_ci
  and ci >= 99980000
  ;
  delete from rapporti_giuridici
  where ci = D_ci
  and ci >= 99980000
  ;
end if;


if D_tipo = 'X' and D_ci is null then 
  delete from movimenti_contabili_previsione
  where ci >= 99980000
  ;
  delete from periodi_retributivi_bp
  where  ci >= 99980000
  ;
  delete from informazioni_retributive_bp
  where ci >= 99980000
  ;
  delete from informazioni_extracontabili
  where ci >= 99980000
  ;
  delete from rapporti_retributivi
  where ci >= 99980000
  ;
  delete from rapporti_giuridici
  where ci >= 99980000
  ;
end if;

exception WHEN ESCI THEN NULL;
end;
end;
/

