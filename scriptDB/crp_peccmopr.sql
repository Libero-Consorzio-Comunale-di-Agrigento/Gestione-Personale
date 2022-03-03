CREATE OR REPLACE PACKAGE peccmopr IS
/******************************************************************************
 NOME:        PECCMOPR
 DESCRIZIONE: Consolidamento dei movimenti contabili di Previsione nella
              tabella MOVIMENTI_BILANCIO_PREVISIONE.


 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.1  20/01/2003
 1.2  08/09/2004 MS     Revisione Integrazione con CF4
 1.3  07/02/2006 MS     Mod. per codice siope

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccmopr IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.3 del 07/02/2006';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
D_cancella   varchar2(1);
begin

BEGIN
    select substr(valore,1,1)
      into D_cancella
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CANCELLA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_cancella := null;
END;


delete from movimenti_bilancio_previsione
 where (anno,mese,mensilita) in (select distinct anno,mese,mensilita
                                   from movimenti_contabili_previsione
                                )
;
insert into movimenti_bilancio_previsione
     ( anno
	 , mese
	 , mensilita
	 , divisione
	 , sezione
	 , gestione
	 , settore
	 , sede
	 , funzionale
	 , cdc
	 , ruolo
	 , di_ruolo
	 , livello
	 , contratto
	 , qualifica
	 , tipo_rapporto
	 , ore
	 , trattamento
	 , figura
	 , attivita
	 , bilancio
	 , budget
	 , anno_rif
	 , arr
	 , sede_del
	 , anno_del
	 , numero_del
         , risorsa_intervento
	 , capitolo
	 , articolo
	 , conto
         , impegno
         , anno_impegno
         , sub_impegno
         , anno_sub_impegno
	 , codice_siope
	 , importo
	 , imponibile
	 , quantita
	 , nr_voci
	 )
select mopr.anno
     , mopr.mese
     , mopr.mensilita
     , mopr.divisione
     , mopr.sezione
     , mopr.gestione
     , mopr.settore
     , mopr.sede
     , mopr.funzionale
     , mopr.cdc
     , mopr.ruolo
     , mopr.di_ruolo
     , qual.livello
     , mopr.contratto
     , mopr.qualifica
     , mopr.tipo_rapporto
     , mopr.ore
     , mopr.trattamento
     , mopr.figura
     , mopr.attivita
     , mopr.bilancio
     , mopr.budget
     , to_char(mopr.riferimento,'yyyy')
     , mopr.arr
     , mopr.sede_del
     , mopr.anno_del
     , mopr.numero_del
     , mopr.risorsa_intervento
     , mopr.capitolo
     , mopr.articolo
     , mopr.conto
     , mopr.impegno
     , mopr.anno_impegno
     , mopr.sub_impegno
     , mopr.anno_sub_impegno
     , mopr.codice_siope
     , sum(mopr.importo)
     , sum(mopr.imponibile)
     , sum(mopr.quantita)
     , sum(mopr.nr_voci)
  from qualifiche_giuridiche qual
     , movimenti_previsione  mopr
 where qual.numero = mopr.qualifica
   and nvl(mopr.riferimento,to_date('3333333','j'))
       between qual.dal and nvl(qual.al,to_date('3333333','j'))
group by mopr.anno
       , mopr.mese
       , mopr.mensilita
       , mopr.divisione
       , mopr.sezione
       , mopr.gestione
       , mopr.settore
       , mopr.sede
       , mopr.funzionale
       , mopr.cdc
       , mopr.ruolo
       , mopr.di_ruolo
       , qual.livello
       , mopr.contratto
       , mopr.qualifica
       , mopr.tipo_rapporto
       , mopr.ore
       , mopr.trattamento
       , mopr.figura
       , mopr.attivita
       , mopr.bilancio
       , mopr.budget
       , to_char(mopr.riferimento,'yyyy')
       , mopr.arr
       , mopr.sede_del
       , mopr.anno_del
       , mopr.numero_del
       , mopr.risorsa_intervento
       , mopr.capitolo
       , mopr.articolo
       , mopr.conto
       , mopr.impegno
       , mopr.anno_impegno
       , mopr.sub_impegno
       , mopr.anno_sub_impegno
       , mopr.codice_siope
;

if D_cancella = 'X' then
  delete from periodi_retributivi_bp
  ;
  delete from movimenti_contabili_previsione
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

update rapporti_giuridici
   set flag_elab = null
 where flag_elab = 'C'
;
end;
end;
/

