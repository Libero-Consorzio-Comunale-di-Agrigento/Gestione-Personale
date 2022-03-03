CREATE OR REPLACE PACKAGE PECCFDMA IS
/******************************************************************************
 NOME:          crp_peccfdma
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  29/12/2004
 1.1	01/06/2005	ML	Gestione frontespizi diversi
 1.2  24/08/2005  ML	Gestione invii multipli (A12373).
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione number, passo number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCFDMA IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.2 del 24/08/2005';
   END VERSIONE;
PROCEDURE MAIN (prenotazione number, passo number) IS
BEGIN
DECLARE
V_controllo varchar2(1);
V_conta_B   number := 0;
V_conta_C   number := 0;
V_conta_D   number := 0;
cursor stampa (p_prenotazione number)is
select * from a_appoggio_stampe
 where no_prenotazione = p_prenotazione
   and no_passo = passo - 1
   and riga != 0
  order by pagina, riga;
v_pagina number:= -1;
v_testo a_appoggio_stampe.testo%TYPE;
v_testo_r a_appoggio_stampe.testo%TYPE;
v_numero_campi number := 0;
v_posizione number;
v_riga number := 1;
v_lunghezza_riga number:= 1897;
v_caratteri_controllo varchar2(1):= 'A';
D_carattere varchar2(1);
PROCEDURE inserisci_dato IS
BEGIN
           --
           -- Ricalcola il totale dei record C e D che potrebbe cambiare per il compattamento dei campi nulli.
           --
           IF substr(v_testo,1,1) = 'C' THEN
              V_conta_C := V_conta_C + 1;
           ELSIF substr(v_testo,1,1) = 'D' THEN
              V_conta_D := V_conta_D + 1;
           END IF;
   --
   -- Aggiorna sul testo dell ultimo record il valore del totale dei record C e D
   --
   IF substr(v_testo,1,1) = 'Z' THEN
      v_testo:= substr(v_testo,1,15)||lpad(to_char(V_conta_B),9,'0')||lpad(to_char(V_conta_C),9,'0')||lpad(to_char(V_conta_D),9,'0')||
                substr(v_testo,43);
   END IF;
   insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
   values (prenotazione,passo+1,v_pagina,v_riga,rpad(v_testo,v_lunghezza_riga,' ')||v_caratteri_controllo);
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
 D_carattere := substr(v_stampa.testo,1,1);
  IF D_carattere in ('A','B') THEN
     IF v_numero_campi > 0 THEN --non prima pagina
	      inserisci_dato;
  	 END IF; -- fine controllo su numero campi
     v_numero_campi := 0;
     v_pagina := v_stampa.pagina;
     v_riga := v_stampa.riga;
     IF D_carattere = 'B' THEN
        V_conta_b := V_conta_b + 1;
     END IF;
     insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,passo+1,v_pagina,v_riga,v_stampa.testo);
     v_riga := v_riga + 1;
     ELSIF D_carattere not in ('A','B') or
          (D_carattere = 'Z' and v_stampa.pagina != 950000) THEN
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
                 -- continuo a scrivere nella variabile v_testo finche non ho messo 75 campi al massimo.
              WHILE v_posizione +1 <= length (v_stampa.testo)
                    LOOP
                      leggi_riga (v_stampa.testo);
                    END loop;
            END IF; -- controllo su cambio pagina
-- 	END IF; -- fine controllo su numero campi
--     v_numero_campi := 0;
--     v_pagina := v_stampa.pagina;
--     v_riga := v_stampa.riga;
--     insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
--     values (prenotazione,passo,v_pagina,v_riga,v_stampa.testo);
--     v_riga := v_riga + 1;
  ELSIF substr(v_stampa.testo,1,1) = 'Z' and v_stampa.pagina = 950000
   THEN -- tratto i record di tipo Z record di coda
     v_controllo := 'X';
     inserisci_dato;
     v_pagina := v_pagina + 1;
     v_riga := v_stampa.riga;
     insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,passo+1,v_pagina,v_riga,v_stampa.testo);
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
