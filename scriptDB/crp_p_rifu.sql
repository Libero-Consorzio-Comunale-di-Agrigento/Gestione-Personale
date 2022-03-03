CREATE OR REPLACE PACKAGE P_Rifu IS
/******************************************************************************
 NOME:          CRP_P_RIFU.sql
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

  PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY P_Rifu IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	NUMBER := 1;
	contarighe  NUMBER;
PROCEDURE insert_intestazione(contarighe IN OUT NUMBER, pagina IN NUMBER) IS
	BEGIN
		contarighe:=contarighe+1;
		INSERT INTO a_appoggio_stampe
		 VALUES ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, NULL
	           )
			   ;
		contarighe:=contarighe+1;
		INSERT INTO a_appoggio_stampe
		 VALUES ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, LPAD('VERIFICA INTEGRITA` REFERENZIALE RIPARTIZIONI_FUNZIONALI',(132-LENGTH('VERIFICA INTEGRITA` REFERENZIALE RIPARTIZIONI_FUNZIONALI'))/2+(LENGTH('VERIFICA INTEGRITA` REFERENZIALE RIPARTIZIONI_FUNZIONALI')))
	           )
			   ;
		contarighe:=contarighe+1;
		INSERT INTO a_appoggio_stampe
		 VALUES ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, NULL
	           )
			   ;
		contarighe:=contarighe+1;
		INSERT INTO a_appoggio_stampe
		 VALUES ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, 'Settore Sede   Cl. Funzionale Centro di Costo Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		INSERT INTO a_appoggio_stampe
		 VALUES ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------- ------- ------------- --------------- ------------------------------'
	           )
			   ;
		COMMIT;
		END;
BEGIN
	SELECT NVL(MAX(riga),0)
	  INTO contarighe
	  FROM a_appoggio_stampe
	 WHERE no_prenotazione = prenotazione
	 ;
	FOR cur_riga IN (SELECT settore, sede, '        ' cdc, '      ' funzionale,
       'SETTORI' tabella
FROM RIPARTIZIONI_FUNZIONALI rifu
WHERE NOT EXISTS
  (SELECT 1 FROM SETTORI sett
    WHERE sett.numero = rifu.settore)
UNION
SELECT settore, sede, '        ' cdc, '      ' funzionale,
       'SEDI' tabella
FROM RIPARTIZIONI_FUNZIONALI rifu
WHERE sede != '0'
  AND NOT EXISTS
  (SELECT 1 FROM SEDI sede
    WHERE sede.numero = rifu.sede)
UNION
SELECT settore, sede, cdc, '      ' funzionale,
       'CENTRI_COSTO' tabella
FROM RIPARTIZIONI_FUNZIONALI rifu
WHERE cdc IS NOT NULL
  AND NOT EXISTS
  (SELECT 1 FROM CENTRI_COSTO ceco
    WHERE ceco.codice = rifu.cdc)
UNION
SELECT settore, sede, '        ' cdc, funzionale,
       'CLASSIFICAZIONI_FUNZIONALI' tabella
FROM RIPARTIZIONI_FUNZIONALI rifu
WHERE funzionale IS NOT NULL
  AND NOT EXISTS
  (SELECT 1 FROM CLASSIFICAZIONI_FUNZIONALI clfu
    WHERE clfu.codice = rifu.funzionale)
ORDER BY 5,3,4,1,2
       				) LOOP
		IF MOD(contarighe,57)= 0 THEN
			   insert_intestazione(contarighe,p_pagina);
		END IF;
		contarighe:=contarighe+1;
		INSERT INTO a_appoggio_stampe
		 VALUES ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, RPAD(NVL(TO_CHAR(cur_riga.settore),' '),7)||' '
				  ||RPAD(NVL(TO_CHAR(cur_riga.sede),' '),6)||' '
				  ||RPAD(NVL(cur_riga.funzionale,' '),14)||' '
  				  ||RPAD(NVL(cur_riga.cdc,' '),15)||' '
				  ||cur_riga.tabella
		        );
	END LOOP;
	WHILE TRUE LOOP
		IF MOD(contarighe,57)= 0 THEN EXIT; END IF;
		contarighe := contarighe+1;
		INSERT INTO a_appoggio_stampe
		VALUES ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, NULL
		        );
	END LOOP;
	COMMIT;
END MAIN;
END P_Rifu;
/

