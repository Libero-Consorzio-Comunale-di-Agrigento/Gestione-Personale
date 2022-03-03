CREATE OR REPLACE PACKAGE PECLISDO IS
/******************************************************************************
 NOME:          PECLISDO
 DESCRIZIONE:   Elaborazione per l'esposizione della lista nominativa per la denuncia
                annuale ONAOSI.
                Questa fase produce un elenco ...
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Il PARAMETRO D_anno indica l'anno di riferimento da elaborare.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
 2.0  08/02/2005 MS     Modifiche per att. 7307
 2.1  03/07/2006 CB     Modifica campo evento - attività 14612
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY Peclisdo IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.1 del 03/07/2006';
END VERSIONE;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
 P_Ente    		VARCHAR2(4);
 P_ambiente 	VARCHAR2(8);
 P_utente 		VARCHAR2(8);
 P_anno 		VARCHAR2(4);
 P_ini_ela 		VARCHAR2(8);
 P_fin_ela 		VARCHAR2(8);
 P_previsione   varchar2(1);
 P_progressivo    number;

 BEGIN
 P_progressivo := 0;
    SELECT ENTE      D_ente
         , utente    D_utente
         , ambiente  D_ambiente
	  INTO P_Ente, P_utente, P_ambiente
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  BEGIN
    SELECT MAX(SUBSTR(valore,1,4))                        D_anno
	 , MAX(TO_CHAR(TO_DATE('01'||SUBSTR(valore,1,4),'mmyyyy')
                      ,'ddmmyyyy'))                                  D_ini_ela
	 , MAX(TO_CHAR(LAST_DAY
                       (TO_DATE('12'||SUBSTR(valore,1,4),'mmyyyy'))
                      ,'ddmmyyyy'))                                  D_fin_ela
      INTO P_anno, P_ini_ela, P_fin_ela
	  FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
	exception
	  when no_data_found then
            SELECT NVL(P_anno,anno)                                     D_anno
	          , NVL(P_ini_ela
                       ,TO_CHAR(TO_DATE('01'||TO_CHAR(anno),'mmyyyy'),'ddmmyyyy'))             D_ini_ela
	          , NVL(P_fin_ela
	                   ,TO_CHAR(LAST_DAY(TO_DATE('12'||TO_CHAR(anno),'mmyyyy')),'ddmmyyyy'))   D_fin_ela
	            INTO P_anno, P_ini_ela, P_fin_ela
                FROM RIFERIMENTO_FINE_ANNO
                WHERE rifa_id = 'RIFA';
   END;
   BEGIN
   select valore
     into P_previsione
    from a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_PREVISIONE';
    EXCEPTION WHEN NO_DATA_FOUND THEN P_PREVISIONE := null;
   END;
-- dbms_output.put_line('PAR: '||P_previsione);
DECLARE
  P_pagina       NUMBER := 0;
  P_riga         NUMBER := 0;
  P_conta        NUMBER := 0;
  P_dep_anno     NUMBER;
  P_ipn_prev     NUMBER;
  P_rit_prev     NUMBER;
  P_ipn_prev_ap  NUMBER;
  P_rit_prev_ap  NUMBER;
  P_ipn_prev_ac  NUMBER;
  P_rit_prev_ac  NUMBER;
  P_ipn          NUMBER;
  P_rit_calc     NUMBER;
  P_rit          NUMBER;
  P_qualifica    VARCHAR2(8);
  P_gg_lavoro    NUMBER(2);
  P_eta          NUMBER(3);
  P_rit_eta      NUMBER;

BEGIN
  BEGIN
    FOR CURS_ONA IN
/* Determina le persone da trattare controllando se hanno voci significative per l'ONAOSI per l'anno
   di denuncia o per l'anno successivo */
       (SELECT rain.ci                             ci
             , anag.cognome                        cognome
             , anag.nome                           nome
             , MAX(anag.indirizzo_dom)             indirizzo
             , MAX(comu.descrizione)               comune
  	       , MAX(comu.sigla_provincia)           provincia
             , MAX(comu.cap)                       cap
             , max(to_char(anag.data_nas,'dd/mm/yyyy'))                  data_nas
          FROM comuni                        comu
             , ANAGRAFICI                    anag
	     , RAPPORTI_INDIVIDUALI          rain
         WHERE anag.ni         = rain.ni
	   AND anag.al        IS NULL
	   AND comu.cod_comune     = anag.comune_dom
	   AND comu.cod_provincia  = anag.provincia_dom
	   AND EXISTS
	      (SELECT 'x' FROM MOVIMENTI_CONTABILI
		WHERE anno = P_anno
		  AND ci   = rain.ci
		  AND voce IN
		     (SELECT voce
		        FROM ESTRAZIONE_RIGHE_CONTABILI
                       WHERE estrazione = 'DENUNCIA_ONAOSI'
			 AND colonna    = 'IPN'
			 AND al        IS NULL)
/* Eliminato perchè la den. del 2003 NON deve far riferimento al 2004
               UNION
	       SELECT 'x' FROM MOVIMENTI_CONTABILI
		WHERE anno = P_anno+1
		  AND ci   = rain.ci
		  AND voce IN
		     (SELECT voce
		        FROM ESTRAZIONE_RIGHE_CONTABILI
                       WHERE estrazione = 'DENUNCIA_ONAOSI'
			 AND colonna    = 'IPN'
			 AND al        IS NULL)
*/
              )
         GROUP BY anag.cognome,anag.nome,rain.ci
       ) LOOP
-- dbms_output.put_line('CI: '||CURS_ONA.ci);
           BEGIN

             SELECT x.codice,cost.gg_lavoro
               INTO P_qualifica,P_gg_lavoro
               FROM QUALIFICHE_GIURIDICHE x,
			        CONTRATTI_STORICI cost
              WHERE x.numero =
                   (SELECT SUBSTR(MAX(TO_CHAR(dal,'yyyymmdd')||qualifica),9)
                      FROM PERIODI_GIURIDICI
                     WHERE rilevanza = 'S'
                       AND ci        = CURS_ONA.ci
                       AND dal      <= TO_DATE('3112'||P_anno,'ddmmyyyy')
                   )
                AND x.dal = (SELECT MAX(dal) FROM QUALIFICHE_GIURIDICHE
                            WHERE numero = x.numero
                              AND dal <= TO_DATE('3112'||P_anno,'ddmmyyyy'))
                AND cost.dal = (SELECT MAX(dal) FROM CONTRATTI_STORICI c
                                                WHERE c.contratto = cost.contratto
                                                AND dal <= TO_DATE('3112'||P_anno,'ddmmyyyy'))
                                        AND x.contratto = cost.contratto
             ;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
			 BEGIN
             SELECT x.codice,cost.gg_lavoro
               INTO P_qualifica,P_gg_lavoro
               FROM QUALIFICHE_GIURIDICHE x,
			        CONTRATTI_STORICI cost
              WHERE x.numero =
                   (SELECT SUBSTR(MIN(TO_CHAR(dal,'yyyymmdd')||qualifica),9)
                      FROM PERIODI_GIURIDICI
                     WHERE rilevanza = 'S'
                       AND ci        = CURS_ONA.ci
                       AND dal      <= TO_DATE('3112'||P_anno+1,'ddmmyyyy')
                       AND dal      >= TO_DATE('3112'||P_anno,'ddmmyyyy')
                   )
                AND x.dal = (SELECT MAX(dal) FROM QUALIFICHE_GIURIDICHE
                            WHERE numero = x.numero
                              AND dal <= TO_DATE('3112'||P_anno+1,'ddmmyyyy'))
                AND cost.dal = (SELECT MAX(dal) FROM CONTRATTI_STORICI c
                                                                   WHERE c.contratto = cost.contratto
                                                                   AND dal <= TO_DATE('3112'||P_anno+1,'ddmmyyyy'))
                                          AND x.contratto = cost.contratto
             ;
             EXCEPTION
			      WHEN NO_DATA_FOUND THEN
                      P_progressivo := P_Progressivo + 1;
                      INSERT INTO A_SEGNALAZIONI_ERRORE(no_prenotazione,passo,progressivo,errore,precisazione)
                        VALUES(prenotazione,passo,p_progressivo,'P04080',
                          'Qualifica retributiva non prevista'||' '||'Cod.Ind.'||' '||CURS_ONA.ci)
                       ;
					   p_gg_lavoro :=1;
					--   p_qualifica:=' ';
					  
		END;
           END;
/* Estrae gli importi a CONSUNTIVO per l'anno di denuncia */
           BEGIN
             SELECT SUM( DECODE( vaca.colonna
                               , 'IPN', vaca.valore
                                      , 0)
                       )                                ipn
                  , E_Round( SUM( DECODE( vaca.colonna
                                      , 'RIT_CALC', vaca.valore
                                                  , 0))
                         / nvl(MAX( DECODE( vaca.colonna
                                      , 'RIT_CALC', NVL(esvc.arrotonda,0.01)
                                                  , '')),1)
                         ,'I') * nvl(MAX( DECODE( vaca.colonna
                                        , 'RIT_CALC', NVL(esvc.arrotonda,0.01)
                                                    , '')),1)      rit_calc
                  , E_Round( SUM( DECODE( vaca.colonna
                                      , 'RIT', vaca.valore
                                             , 0))
                         / nvl(MAX( DECODE( vaca.colonna
                                      , 'RIT', NVL(esvc.arrotonda,0.01)
                                             , '')),1)
                         ,'I') * nvl(MAX( DECODE( vaca.colonna
                                        , 'RIT', NVL(esvc.arrotonda,0.01)
                                               , '')),1)      rit
               INTO P_ipn,P_rit_calc,P_rit
               FROM valori_contabili_annuali vaca
                  , ESTRAZIONE_VALORI_CONTABILI esvc
              WHERE vaca.estrazione = 'DENUNCIA_ONAOSI'
		AND vaca.colonna   IN ('IPN','RIT_CALC','RIT')
		AND vaca.anno       = P_anno
--		AND vaca.mese       = 12
/* sostituito per trattare solo gli importi fino a luglio 2003 compreso */
		AND vaca.mese       = 7
		AND vaca.MENSILITA IN (SELECT MAX(MENSILITA)
					 FROM MENSILITA
--					WHERE mese = 12 -- v. sopra
					WHERE mese = 7
					  AND tipo IN ('A','N','S'))
                AND vaca.ci         = CURS_ONA.ci
                AND esvc.estrazione = vaca.estrazione
                AND esvc.colonna    = vaca.colonna
--                AND TO_DATE('3112'||P_anno,'ddmmyyyy') -- v. sopra
                AND TO_DATE('3107'||P_anno,'ddmmyyyy')
                    BETWEEN esvc.dal AND NVL(esvc.al,TO_DATE('3333333','j'))
           ;
           EXCEPTION
         WHEN NO_DATA_FOUND THEN P_ipn :=0;
					   P_rit_calc :=0;
					   P_rit :=0;
	   END;
/* Estrae gli importi a PREVENTIVO ciclando 2 volte: una per l'anno di denuncia e una per l'anno successivo */
           BEGIN
	     P_dep_anno := P_anno;
	     FOR P_dep_anno IN TO_NUMBER(P_anno)..TO_NUMBER(P_anno) LOOP
	       BEGIN
		   BEGIN
                 SELECT NVL(SUM( DECODE(colonna,'IPN_MENS',valore,0)) +
                       ( SUM(DECODE(colonna,'IPN_MENS',valore,0))
                        /DECODE( NVL(SUM(DECODE(colonna,'GG',valore,0)),0)
                               , 0, P_gg_lavoro
                                  , SUM(DECODE(colonna,'GG',valore,0))
                               )
                        *P_gg_lavoro
                       )*11,0)
                      , NVL(SUM( DECODE(colonna,'RIT_MENS',valore,0)) +
                       ( SUM(DECODE(colonna,'RIT_MENS',valore,0))
                        /DECODE( NVL(SUM(DECODE(colonna,'GG',valore,0)),0)
                               , 0, P_gg_lavoro
                                  , SUM(DECODE(colonna,'GG',valore,0))
                               )
                        *P_gg_lavoro
                       )*11,0)
                      , trunc(to_number(months_between( TO_DATE('3112'||(P_dep_anno-1),'ddmmyyyy')
                                                      , to_date(CURS_ONA.data_nas,'dd/mm/yyyy') ) ) / 12) 
                   INTO P_ipn_prev,P_rit_prev,P_eta
                   FROM valori_contabili_mensili
                  WHERE estrazione = 'DENUNCIA_ONAOSI'
                    AND colonna   IN ('GG','RIT_MENS','IPN_MENS')
                    AND anno       = P_dep_anno
                    AND mese       = 1
                    AND MENSILITA  = (SELECT 'GEN' FROM dual
                                       WHERE EXISTS
                                            (SELECT 'x' FROM MOVIMENTI_FISCALI
                                              WHERE anno = P_dep_anno
                                                AND mese = 1
                                                AND MENSILITA = 'GEN'
                                                AND ci = CURS_ONA.ci)
                                       UNION
                                      SELECT '*R*' FROM dual
                                       WHERE NOT EXISTS
                                            (SELECT 'x' FROM MOVIMENTI_FISCALI
                                              WHERE anno = P_dep_anno
                                                AND mese = 1
                                                AND MENSILITA = 'GEN'
                                                AND ci = CURS_ONA.ci))
                    AND ci         = CURS_ONA.ci
                    ;
            EXCEPTION
        WHEN NO_DATA_FOUND THEN P_ipn_PREV :=0;
					   P_rit_PREV :=0;
	   END;
         BEGIN
         select sum(max(decode( greatest(P_eta,68)
                              , P_eta, 1.5
                                     , decode( greatest(P_eta,33)
                                             , P_eta, 12
                                                    , 3
                                             )
                              )
                       )
                    )
           into P_rit_eta
           from periodi_retributivi pere
         where pere.anno = 2003 and pere.mese > 7
           and pere.periodo between to_date('31082003','ddmmyyyy') and to_date('31122003','ddmmyyyy')
           and pere.al > to_date('31072003','ddmmyyyy')
           and pere.ci = CURS_ONA.ci
          group by to_char(pere.al,'yyyymm')
         having sum(gg_con) > 0
         ;
           EXCEPTION
         WHEN NO_DATA_FOUND THEN P_rit_eta :=0;
         END;
-- dbms_output.put_line('P_dep_anno '||P_dep_anno);
-- dbms_output.put_line('data nas '||CURS_ONA.data_nas);
           SELECT ROUND( P_rit_prev
                       /  NVL(arrotonda,0.01)
                       ) * NVL(arrotonda,0.01)
             INTO P_rit_prev
             FROM ESTRAZIONE_VALORI_CONTABILI
            WHERE estrazione = 'DENUNCIA_ONAOSI'
              AND colonna = 'RIT_MENS'
              AND TO_DATE('3112'||P_anno,'ddmmyyyy')
                  BETWEEN dal AND NVL(al,TO_DATE('3333333','j'))
           ;
	       IF P_dep_anno = P_anno THEN
		  P_ipn_prev_ap := P_ipn_prev;
		  P_rit_prev_ap := P_rit_prev;
	       ELSE
		  P_ipn_prev_ac := P_ipn_prev;
		  P_rit_prev_ac := P_rit_prev;
	       END IF;

-- dbms_output.put_line('IPN: '||nvl(P_ipn,0));
-- dbms_output.put_line('IPN_P: '||nvl(P_ipn_prev,0));
       if nvl(P_ipn,0) + nvl(P_ipn_prev,0) = 0 and nvl(P_rit_eta,0) = 0 then 
          null;
-- dbms_output.put_line('Passo1');
       else
          if (P_previsione = 'X' and nvl(P_ipn_prev,0) != 0)
            or P_previsione is null
          then 
-- dbms_output.put_line('Passo2');
             BEGIN
               P_pagina   := P_pagina + 1;
               P_riga     := P_riga   + 1;

/* A seconda dell'anno in trattamento emette gli importi di :
   1) anno di denuncia: effettivo + preventivo AP + differenze (passo 1)
   2) anno successivo a quello di denuncia: solo preventivo (passo 5)
*/
             INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
             VALUES
	       ( prenotazione
               , DECODE(P_dep_anno,P_anno,1,5)
               , P_pagina
               , P_riga
               , DECODE ( P_dep_anno
	                   , P_anno, LPAD(TO_CHAR(CURS_ONA.ci),8,' ')||
                                   RPAD(CURS_ONA.cognome||' '||CURS_ONA.nome,30,' ')||
                                   RPAD(CURS_ONA.data_nas,10,' ')||
                                   LPAD(nvl(P_eta,0),2,0)||
                                   RPAD(NVL(SUBSTR(P_qualifica,1,1),' '),1,' ')||
                                   DECODE( SIGN(P_ipn)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(ABS(P_ipn)),'0'),13,'0')||
                                   DECODE( SIGN(P_ipn_prev)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(E_Round(ABS(P_ipn_prev),'I')),'0'),13,'0')||
                                   DECODE( SIGN(P_ipn-P_ipn_prev)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(E_Round(ABS(  P_ipn - P_ipn_prev),'I')),'0'),11,'0')||
                                   DECODE( SIGN(P_rit_calc)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(ABS(P_rit_calc)),'0'),11,'0')||
                                   DECODE( SIGN(P_rit_eta)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(ABS(P_rit_eta)),'0'),11,'0')||
                                   DECODE( SIGN(P_rit_prev)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(ABS(P_rit_prev)),'0'),11,'0')||
                                   DECODE( SIGN(P_rit_calc + P_rit_eta - P_rit_prev)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(ABS(  P_rit_calc + P_rit_eta - P_rit_prev)),'0'),11,'0')||
                                   DECODE( SIGN(P_rit*-1)
                                           , -1, '-'
                                               , '+')||
                                   LPAD(NVL(TO_CHAR(ABS(P_rit)),'0'),13,'0')
                          , LPAD(TO_CHAR(CURS_ONA.ci),8,' ')||
                            RPAD(CURS_ONA.cognome||' '||CURS_ONA.nome,30,' ')||
                            RPAD(CURS_ONA.data_nas,10,' ')||
                            LPAD(nvl(P_eta,0),2,0)||
                            rpad(NVL(SUBSTR(P_qualifica,1,1),' '),1,' ')||
                            DECODE( SIGN(P_ipn_prev)
                                           , -1, '-'
                                               , '+')||
                            LPAD(NVL(TO_CHAR(E_Round(ABS(P_ipn_prev),'I')),'0'),13,'0')||
                            DECODE( SIGN(P_rit_prev*-1)
                                           , -1, '-'
                                               , '+')||
                            LPAD(NVL(TO_CHAR(ABS(P_rit_prev)),'0'),11,'0')
            ));
            END;
       END IF;
     END IF;
    END;
	     END LOOP;
/* Estrae gli elenchi relativi ai medici cessati e li emette in a_appoggio_stampe (passo 2) */
             BEGIN
               FOR CURS_PEGI1 IN
                  (SELECT pegi.dal
                        , pegi.al
                        , pegi.posizione
                        , evra.descrizione
                     FROM EVENTI_RAPPORTO    evra
	        	, PERIODI_GIURIDICI  pegi
                    WHERE pegi.ci        = CURS_ONA.ci
	              AND pegi.rilevanza = 'P'
        	      AND NVL(pegi.al,TO_DATE('3333333','j'))
        		  BETWEEN TO_DATE(P_ini_ela,'ddmmyyyy')
        		      AND TO_DATE(P_fin_ela,'ddmmyyyy')
                      AND evra.rilevanza = 'T'
	              AND evra.codice    = pegi.posizione
                  )  LOOP
                     P_pagina   := P_pagina + 1;
                     P_riga     := P_riga   + 1;
                     INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                     SELECT prenotazione
                          , 2
                          , P_pagina
                          , P_riga
                          , LPAD(TO_CHAR(CURS_ONA.ci),8,' ')||
                            RPAD(CURS_ONA.cognome||' '||CURS_ONA.nome,30,' ')||
                            RPAD(CURS_ONA.data_nas,10,' ')||
                             LPAD(nvl(P_eta,0),2,0)||
                            rpad(TO_CHAR(CURS_PEGI1.dal,'dd/mm/yy'),8,' ')||
                            rpad(nvl(TO_CHAR(CURS_PEGI1.al,'dd/mm/yy'),' '),8,' ')||
	                    RPAD(CURS_PEGI1.posizione,4,' ')||' '||
	                    RPAD(CURS_PEGI1.descrizione,30,' ')
                       FROM dual
                     ;
                     END LOOP;
             END;
/* Estrae gli elenchi relativi ai medici assunti e li emette in a_appoggio_stampe (passo 3) */
             BEGIN
               FOR CURS_PEGI2 IN
                  (SELECT pegi.dal
                        , pegi.al
                        , pegi.EVENTO
                        , evra.descrizione
                     FROM EVENTI_RAPPORTO    evra
	        	, PERIODI_GIURIDICI  pegi
                    WHERE pegi.ci        = CURS_ONA.ci
	              AND pegi.rilevanza = 'P'
	              AND pegi.dal     BETWEEN TO_DATE(P_ini_ela,'ddmmyyyy')
        		                   AND TO_DATE(P_fin_ela,'ddmmyyyy')
                    AND evra.rilevanza = 'I'
	              AND evra.codice    = pegi.EVENTO
                  ) LOOP
                    P_pagina   := P_pagina + 1;
                    P_riga     := P_riga   + 1;
                     INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                     SELECT prenotazione
                          , 3
                          , P_pagina
                          , P_riga
                          , LPAD(TO_CHAR(CURS_ONA.ci),8,' ')||
                            RPAD(CURS_ONA.cognome||' '||CURS_ONA.nome,30,' ')||
                            RPAD(CURS_ONA.data_nas,10,' ')||
                            LPAD(nvl(P_eta,0),2,0)||
                            rpad(TO_CHAR(CURS_PEGI2.dal,'dd/mm/yy'),8,' ')||
                            rpad(nvl(TO_CHAR(CURS_PEGI2.al,'dd/mm/yy'),' '),8,' ') ||
	                    RPAD(CURS_PEGI2.evento,6,' ')||' '||
	                    RPAD(CURS_PEGI2.descrizione,30,' ')
                       FROM dual
                     ;
					
                    END LOOP;
             END;
/* Estrae gli elenchi relativi ai medici assenti e li emette in a_appoggio_stampe (passo 4) */
			  BEGIN
               FOR CUR_PEGI_A IN
                  (SELECT pegi.dal
                        , pegi.al
                        , pegi.assenza
                        , aste.descrizione
                     FROM ASTENSIONI aste
	        	, PERIODI_GIURIDICI  pegi
                    WHERE pegi.ci        = CURS_ONA.ci
	              AND pegi.rilevanza = 'A'
                    AND pegi.assenza   = aste.codice
                    AND aste.per_ret   < 100
        	        AND pegi.dal     <= TO_DATE(P_fin_ela,'ddmmyyyy')
        		  AND NVL(pegi.al,TO_DATE('3333333','j')) >= TO_DATE(P_ini_ela,'ddmmyyyy')
                   )  LOOP
                     P_pagina   := P_pagina + 1;
                     P_riga     := P_riga   + 1;
                     INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                     SELECT prenotazione
                          , 4
                          , P_pagina
                          , P_riga
                          , LPAD(TO_CHAR(CURS_ONA.ci),8,' ')||
                            RPAD(CURS_ONA.cognome||' '||CURS_ONA.nome,30,' ')||
                            RPAD(CURS_ONA.data_nas,10,' ')||
                            LPAD(P_eta,2,0)||
                            rpad(TO_CHAR(CUR_PEGI_A.dal,'dd/mm/yy'),8,' ')||
                            rpad(nvl(TO_CHAR(CUR_PEGI_A.al,'dd/mm/yy'),' '),8,' ')||
	                    RPAD(CUR_PEGI_A.assenza,4,' ')||' '||
	                    RPAD(CUR_PEGI_A.descrizione,30,' ')
                       FROM dual
                     ;
                     END LOOP;
             END;
/* Emette i dati relativi all'elenco generale (passo 6), con:
   1) le sole differenze tra preventivo AP ed effettivo dell'anno di denuncia per ipn e rit
   2) il preventivo AC per ipn e rit
   3) la ritenuta da versare (punto 1 + punto 2)
*/
           P_pagina   := P_pagina + 1;
           P_riga     := P_riga   + 1;
           P_conta    := P_conta  + 1;
           INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           VALUES ( prenotazione
                  , 6
                  , P_pagina
                  , P_riga
                  , LPAD(TO_CHAR(CURS_ONA.ci),8,' ')||
                    RPAD(CURS_ONA.cognome||' '||CURS_ONA.nome,30,' ')||
                    RPAD(CURS_ONA.data_nas,10,' ')||
                    LPAD(nvl(P_eta,0),2,0)||
		              RPAD(SUBSTR(CURS_ONA.indirizzo||' '||
				        CURS_ONA.comune||', '||CURS_ONA.cap||' ('||
				        CURS_ONA.provincia||')',1,81),81,' ')||
                    LPAD(TO_CHAR(P_conta),4)||
                    rpad(NVL(SUBSTR(P_qualifica,1,1),' '),1,' ')||
                    DECODE( SIGN(P_ipn - P_ipn_prev_ap)
                          , -1, '-'
                              , '+')||
                    LPAD(NVL(TO_CHAR(E_Round(ABS(  P_ipn
				               - P_ipn_prev_ap),'I')),'0'),11,'0')||
                    DECODE( SIGN(nvl(P_rit_calc,0) + nvl(P_rit_eta,0) - nvl(P_rit_prev_ap,0))
                          , -1, '-'
                              , '+')||
                    LPAD(NVL(TO_CHAR(ABS(  nvl(P_rit_calc,0)
                                        + nvl(P_rit_eta,0)
	  			                - nvl(P_rit_prev_ap,0))
                                           ),'0'),11,'0')||
                    DECODE( SIGN(P_ipn_prev_ac)
                          , -1, '-'
                              , '+')||
                    LPAD(NVL(TO_CHAR(E_Round(ABS(P_ipn_prev_ac),'I')),'0'),11,'0')||
                    DECODE( SIGN(P_rit_prev_ac)
                          , -1, '-'
                              , '+')||
                    LPAD(NVL(TO_CHAR(ABS(P_rit_prev_ac)
                                           ),'0'),11,'0')||
                    DECODE( SIGN(  nvl(P_rit_calc,0)
                                 + nvl(P_rit_eta,0)
                                 - nvl(P_rit_prev_ap,0)
                                 + nvl(P_rit_prev_ac,0))
                          , -1, '-'
                              , '+')||
                    LPAD(NVL(TO_CHAR(ABS(  NVL(P_rit_calc,0)
	                                        + NVL(P_rit_eta,0)
	                                        - NVL(P_rit_prev_ap,0)
                                                + NVL(P_rit_prev_ac,0))
                                           ),'0'),11,'0')
                 )
                 ;
	    END;
		--commit;
		END LOOP;
  END;
END;
END;
END;
END;
/
