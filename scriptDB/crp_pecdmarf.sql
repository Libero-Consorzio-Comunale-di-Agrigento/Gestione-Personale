CREATE OR REPLACE PACKAGE pecdmarf IS
/******************************************************************************
 NOME:          PECDMARF RINOMINA FILE IN CASO DI INVII MULTIPLI
 DESCRIZIONE:   Questa fase gestisce l'assegnazione del nome dei file generati.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI.
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  24/08/2005 ML     Prima Emissione.
                        Introdotto con att. A12373 per gestione invii multipli.
 1.1  11/04/2006 ML     Aumentato il numero dei passi per produrre piu' di 5 file (A15661).
 1.2  12/01/2007 ML     Modificata la select di max(no_passo) per scartare il passo 99 
                        che non deve essere considerato (A18927).
 1.3  06/09/2007 ML     Esclusione passo 98 dalla selezione dei passi che identificano i
                        file da produrre (A22670).
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
CREATE OR REPLACE PACKAGE BODY pecdmarf IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.3 del 06/09/2007';
   END VERSIONE;
   PROCEDURE Main ( prenotazione Number, passo Number ) is
BEGIN
  DECLARE
  tot_passi  number;
  D_anno     number;
  BEGIN
    BEGIN
      select max(no_passo)
        into tot_passi
        from a_appoggio_stampe
       where no_prenotazione = prenotazione
         and no_passo        < 98
         and riga            = 0; -- specifico riga 0 perche voglio solo i passi scritti da smdma
    END;
    BEGIN
      select valore
        into D_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro = 'P_ANNO'
     ;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
       select anno
         into D_anno
         from riferimento_retribuzione
        where rire_id = 'RIRE';
    END;
    IF ceil(tot_passi/3) < passo/3 THEN
       update a_prenotazioni
          set prossimo_passo  = 47
        where no_prenotazione = prenotazione;
    END IF;
    IF tot_passi = 1 THEN
    null;
    ELSE
   	UPDATE a_selezioni
 	     SET valore_default = substr(valore_default,1,instr(valore_default,D_anno)+3)||
                            '-'||passo/3||'.txt'
  	 WHERE voce_menu = 'PECSMDMA'
	     AND parametro = 'TXTFILE'
	  ;
    END IF;
END;
END;
END;
/
