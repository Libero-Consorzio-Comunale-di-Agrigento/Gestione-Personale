/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECCF770 IS
/******************************************************************************
 NOME:          crp_peccf770
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    30/01/2004 MS     Modifiche per Cartolarizzazione 
 3    02/08/2004 MS     Modifiche per 770SC            
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione number, passo number);
END;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY PECCF770 IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V3.0 del 02/08/2004';
   END VERSIONE;

PROCEDURE MAIN (prenotazione number, passo number) IS
BEGIN
DECLARE
V_controllo varchar2(1);
cursor stampa (p_prenotazione number)is
select * from a_appoggio_stampe
 where no_prenotazione = p_prenotazione
   and riga != 0
   and riga != 300
  order by pagina, riga;
v_pagina number:= -1;
v_testo a_appoggio_stampe.testo%TYPE;
v_testo_r a_appoggio_stampe.testo%TYPE;
v_numero_campi number := 0;
v_posizione number;
v_riga number := 1;
v_lunghezza_riga number:= 1897;
v_caratteri_controllo varchar2(1):= 'A';
PROCEDURE inserisci_dato IS
BEGIN
   insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
   values (prenotazione,passo,v_pagina,v_riga,rpad(v_testo,v_lunghezza_riga,' ')||v_caratteri_controllo);
END;
PROCEDURE leggi_riga (p_testo varchar2) IS
BEGIN
WHILE v_posizione +1 <= length (p_testo) 
 LOOP
    IF lpad(rtrim(substr(p_testo,v_posizione+8,16),'0'),16, ' ')  != lpad(' ',16,' ')
     THEN
        v_testo := v_testo || substr(p_testo,v_posizione,24);
        v_numero_campi := v_numero_campi +1;
     IF v_numero_campi = 75 THEN -- raggiunto max di 75 campi
        v_numero_campi := 0;
	  inserisci_dato;
	  v_riga := v_riga +1;
	  v_testo := v_testo_r;
     END IF;
    ELSE -- i dati non vanno riportati
      null;
    END IF;
   v_posizione := v_posizione + 24;
 END LOOP;
END leggi_riga;
BEGIN
 FOR v_stampa in stampa (prenotazione) 
 LOOP
  IF substr(v_stampa.testo,1,1) not in ('A','B','Z') or substr(v_stampa.testo,1,2) = 'AU'
   THEN
   IF v_stampa.pagina != v_pagina THEN -- cambio pagina prendo i dati dell'individuo
  	-- inserisco in a_appoggio_stampe la riga ricavata fino ad ora.
	IF v_numero_campi > 0 THEN --non prima pagina
	  inserisci_dato;
	END IF; -- fine controllo su numero campi
      v_pagina := v_stampa.pagina;
      v_numero_campi := 0;
      v_riga := 1;
      v_testo := substr(v_stampa.testo,1,89); -- dovrebbe sempre essere la riga 1
      v_testo_r := v_testo;
	v_posizione := 90;
	leggi_riga (v_stampa.testo);
   ELSE -- sempre lo stesso record
   v_posizione:= 1;
   -- continuo a scrivere nella variabile v_testo finchè non ho messo 75 campi al massimo.    
   WHILE v_posizione +1 <= length (v_stampa.testo)
    LOOP
    leggi_riga (v_stampa.testo);
    END loop;    
  END IF; -- controllo su cambio pagina
  ELSIF substr(v_stampa.testo,1,1) in ('A','B') and substr(v_stampa.testo,1,2) != 'AU'
   THEN   -- tratto i record di tipo A - B ( testata )
     v_pagina := v_stampa.pagina;
     v_riga := v_stampa.riga;
     insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,passo,v_pagina,v_riga,v_stampa.testo);
     v_riga := v_riga + 1;
  ELSIF substr(v_stampa.testo,1,1) = 'Z' 
   THEN -- tratto i record di tipo Z ( record di coda )
     v_controllo := 'X';
     inserisci_dato;
     v_pagina := v_pagina + 1;
     v_riga := v_stampa.riga;
     insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,passo,v_pagina,v_riga,v_stampa.testo);
     v_riga := v_riga + 1;
 END IF; --non inizia per a,b,z
END LOOP;
-- scrittura ultima riga
  IF nvl(V_controllo,' ') != 'X' THEN
   inserisci_dato;
  END IF; 	   
END;
END;
END;
/
