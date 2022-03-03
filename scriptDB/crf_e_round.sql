CREATE OR REPLACE FUNCTION E_ROUND
(p_importo		  number
,p_tipo 	  	  varchar)
RETURN NUMBER IS
/******************************************************************************
 NOME:        E_ROUND 
 DESCRIZIONE: Esegue la funzione di round tenendo un numero di decimali che 
 			  dipende dalla valuta utilizzata (lire o Euro) e dal tipo di dato 
			  trattato (Importo, Tariffa, Aliquota) 

 PARAMETRI:   p_importo number  valore da arrotondare
              p_tipo    varchar tipo di arrotondamento da eseguire 
			  					I = Importo, T = Tariffa, A = Aliquota 

 RITORNA:     nImp		number	valore arrotondato con i seguenti criteri: 
 			  					Tipo = I se valuta L 0 decimali se E 2 decimali
								Tipo = T se valuta L 2 decimali se E 5 decimali
								Tipo = A se valuta L 2 decimali se E 5 decimali
								
 ECCEZIONI:   nnnnn, <Descrizione eccezione>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    18/05/2001 __     Prima emissione.
******************************************************************************/
nImp   		  	  NUMBER;

BEGIN
  IF p_tipo = 'I'
     THEN IF valuta = 'L'
	         THEN nImp := round(p_importo,0);
			 ELSE nImp := round(p_importo,2);
		  END IF;
	 ELSIF p_tipo = 'T'
     THEN IF valuta = 'L'
	         THEN nImp := round(p_importo,2);
			 ELSE nImp := round(p_importo,5);
		  END IF;
	 ELSIF p_tipo = 'A'
     THEN IF valuta = 'L'
	         THEN nImp := round(p_importo,2);
			 ELSE nImp := round(p_importo,5);
		  END IF;
  END IF;
  return nImp;
END E_ROUND;
/

