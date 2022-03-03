CREATE OR REPLACE PACKAGE peccoced IS

/******************************************************************************
 NOME:          PECCOCED CONTROLLO POST-CEDOLINO                                   
 DESCRIZIONE:   
      Questa funzione controlla che non esistano dipendenti cessati con
      un particolare codice, specificato da parametri, e con il netto
      significativo.

 ARGOMENTI:   

 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  
      Creazione di una stampa di controllo post-cedolino   
 
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
CREATE OR REPLACE PACKAGE BODY peccoced IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
	   procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	DECLARE
  p_anno          number;
  p_mese          number;
  p_mensilita     VARCHAR2(3);
  p_cod_posizione VARCHAR2(4);
  progr_riga      number;
BEGIN
  progr_riga  := 0;
  BEGIN
    select valore
      into p_cod_posizione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro = 'CODICE'
    ;
  END;
  -- Legge mensilita' di riferimento
  BEGIN
    select anno, mese, mensilita
      into p_anno, p_mese, p_mensilita
      from riferimento_retribuzione
     where rire_id = 'RIRE';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       progr_riga := progr_riga + 1;
       insert into a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
       values (prenotazione,passo,progr_riga,'P05140','');
       GOTO FINE;
    WHEN TOO_MANY_ROWS THEN
       progr_riga := progr_riga + 1;
       insert into a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
       values (prenotazione,passo,progr_riga,'A00003','RIFERIMENTO_RETRIBUZIONE');
       GOTO FINE;
  END;
  FOR sel_moco in (select moco.ci
                     from movimenti_contabili moco,
                          voci_economiche voec,
                          periodi_giuridici pegi
                    where moco.anno        = p_anno
                      and moco.mese        = p_mese
                      and moco.mensilita   = p_mensilita
                      and moco.imp         > 0
                      and voec.codice      = moco.voce
                      and voec.automatismo = 'NETTO'
                      and pegi.ci          = moco.ci
                      and pegi.rilevanza   = 'P'
                      and pegi.posizione   = p_cod_posizione
                    order by moco.ci)
  LOOP
       progr_riga := progr_riga + 1;
       insert into a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
       values (prenotazione,passo,progr_riga,'P00876',to_char(sel_moco.ci));
  END LOOP;
  <<FINE>>
     update a_prenotazioni
        set prossimo_passo = 91,
            errore         = 'P05808'
      where no_prenotazione = prenotazione
        and exists (select 'x' from a_segnalazioni_errore
                     where no_prenotazione = prenotazione)
     ;
     commit;
END;
end;
end;
/

