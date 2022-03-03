CREATE OR REPLACE PACKAGE pecla101 IS
/******************************************************************************
 NOME:         PECLA101
 DESCRIZIONE:  Creazione del flusso per la Denuncia Fiscale 770 / A su supporto magnetico
              (nastri a bobina o dischetti - ASCII - lung. 900 crt.).
               Questa fase produce un file secondo i tracciati imposti dal Ministero
               delle Finanze.
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  La gestione che deve risultare come intestataria della denuncia
               deve essere stata inserita in << DGEST >> in modo tale che la
               ragione sociale (campo nome) risulti essere la minore di tutte
               le altre eventualmente inserite.
               Lo stesso risultato si raGgiunge anche inserendo un BLANK prima
               del nome di tutte le gestioni che devono essere escluse.
               Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
               da elaborare.
               Il PARAMETRO D_filtro_1 indica i dipendenti da elaborare.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pecla101 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
DECLARE
  D_anno            number;
   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
      BEGIN
      select substr(valore,1,4)
        into D_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              select anno
                into D_anno
                from riferimento_fine_anno
               where rifa_id = 'RIFA';
      END;
BEGIN
update a_appoggio_stampe apst
   set apst.no_passo = 3
 where apst.no_prenotazione = prenotazione
   and exists
      (select 'x'
         from movimenti_contabili   moco
        where moco.anno       = D_anno
          and moco.ci         = to_number(substr(apst.testo,1,8))
          and (moco.voce,moco.sub) in
              (select voce,sub
                 from estrazione_righe_contabili
                where estrazione = 'AGGIUNTIVA_101')
      )
   and exists
      (select 'x'
         from periodi_giuridici
         where rilevanza = 'P'
           and ci        = to_number(substr(apst.testo,1,8))
           and dal      <= to_date('3112'||to_char(D_anno),'ddmmyyyy')
           and nvl(al,to_date('3333333','j')) >=
                           to_date('01'||to_char(D_anno),'mmyyyy')
      )
;
IF SQL%ROWCOUNT = 0
   THEN update a_prenotazioni
           set prossimo_passo = 5
         where no_prenotazione = prenotazione;
END IF;
END;
END;
end;
end;
/

