CREATE OR REPLACE PACKAGE peccovar IS
/******************************************************************************
 NOME:          PECCOVAR  CONTROLLO VARIABILI CARICATE

 DESCRIZIONE:   
      Questa funzione controlla che non siano state caricate variabili       
      doppie e che non siano state caricate determinate voci a dipendenti     
      part-time. 

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  
     Creazione di una stampa di controllo delle variabili caricate.

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
CREATE OR REPLACE PACKAGE BODY peccovar IS
 
  FUNCTION VERSIONE  RETURN VARCHAR2 IS
  BEGIN
  RETURN 'V1.0 del 20/01/2003';
  END VERSIONE;

	   procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	DECLARE
  p_anno         number;
  p_mese         number;
  p_mensilita    VARCHAR2(3);
  progr_riga     number;
BEGIN
  progr_riga  := 0;
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
  FOR sel_moco in (select moco.ci,voco.titolo
                     from movimenti_contabili moco,
                          voci_contabili voco
                    where moco.anno = p_anno
                      and moco.mese = p_mese
                      and moco.mensilita = p_mensilita
                      and moco.input not in ('R','C','A')
                      and voco.voce = moco.voce
                      and voco.sub  = moco.sub
                    group by moco.ci,moco.voce,moco.sub, voco.titolo,
                          nvl(moco.qta_var,0),nvl(moco.imp_var,0)
                   having count(*) > 1)
  LOOP
       progr_riga := progr_riga + 1;
       insert into a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
       values (prenotazione,passo,progr_riga,'P00874',to_char(sel_moco.ci)||' / '||
               sel_moco.titolo);
  END LOOP;
  FOR sel_moco in (select moco.ci,voco.titolo
                     from movimenti_contabili        moco,
                          estrazione_righe_contabili esrc,
                          voci_contabili             voco,
                          periodi_giuridici          pegi1,
                          periodi_giuridici          pegi2,
                          posizioni                  posi
                    where moco.anno       = p_anno
                      and moco.mese       = p_mese
                      and moco.mensilita  = p_mensilita
                      and esrc.estrazione = 'ESTRAZIONE_CHK_VAR'
                      and esrc.voce       = moco.voce
                      and esrc.sub        = moco.sub
                      and voco.voce       = moco.voce
                      and voco.sub        = moco.sub
                      and pegi1.ci        = moco.ci
                      and pegi1.rilevanza = 'S'
                      and pegi1.dal       < moco.riferimento
                      and nvl(pegi1.al,to_date('3333333','j'))
                                          > moco.riferimento
                      and pegi2.ci (+)        = moco.ci
                      and pegi2.rilevanza (+) = 'E'
                      and pegi2.dal (+)       < moco.riferimento
                      and nvl(pegi2.al(+),to_date('3333333','j'))
                                              > moco.riferimento
                      and posi.codice    = nvl(pegi2.posizione,pegi1.posizione)
                      and posi.part_time = 'SI'
                    order by moco.ci,voco.titolo   )
  LOOP
       progr_riga := progr_riga + 1;
       insert into a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
       values (prenotazione,passo,progr_riga,'P00875',to_char(sel_moco.ci)||' / '||
               sel_moco.titolo);
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

