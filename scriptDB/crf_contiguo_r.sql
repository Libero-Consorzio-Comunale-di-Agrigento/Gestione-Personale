CREATE OR REPLACE FUNCTION f_contiguo_R 
(p_ci NUMBER, p_al DATE) RETURN NUMBER IS
CURSOR c_pegi IS
SELECT dal, al, rilevanza, di_ruolo 
  FROM PERIODI_GIURIDICI pegi,
  	   POSIZIONI
 WHERE ci = p_ci
   AND dal > p_al
   AND rilevanza = 'Q'
   AND pegi.posizione = codice   
 ORDER BY dal;         
v_dal DATE := TO_DATE(NULL);
v_al  DATE := p_al;
trovato BOOLEAN := FALSE;
v_pegi c_pegi%ROWTYPE;
BEGIN
OPEN c_pegi;
WHILE NOT trovato LOOP
FETCH c_pegi INTO v_pegi;
EXIT WHEN c_pegi%NOTFOUND;
	IF v_pegi.dal = v_al+1 THEN
	   -- record contiguo
	   v_dal := v_pegi.dal;
   	   v_al := v_pegi.al;
	   IF v_pegi.di_ruolo = 'R' THEN
	   	  trovato := TRUE;
	   END IF;
	END IF;
END LOOP;
IF  TROVATO THEN
	RETURN 1;
ELSE
	RETURN 0;
END IF;
END f_contiguo_R;
/