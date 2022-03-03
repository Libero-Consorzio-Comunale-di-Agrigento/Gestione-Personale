CREATE OR REPLACE PACKAGE PGPCSCON IS

/******************************************************************************
 NOME:          PGPCSCON TABELLA SERVIZI CON ONERE
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP ServCon.txt
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO D_gestione      indica la gestione da elaborare
               Il PARAMETRO D_cassa         indica il tipo di cassa previdenziale
               Il PARAMETRO D_cessati       indica la data minima di cessazione
               Il PARAMETRO D_ci            indica il singolo dipendente da elaborare
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003
 2    10/06/2004     AM Revisioni varie a seguito dei test sul Modulo
 3    28/06/2004     ML Gestione CI in coda al record, azzeramento progressivo per NI
                        e modifica accesso a INRE, secondo la chiave standard.
 3.1  12/10/2007 MS     Modifica gestione DOGI
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione IN NUMBER,passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY Pgpcscon IS

FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V3.1 del 12/10/2007';
END VERSIONE;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
  P_pagina       NUMBER;
  P_riga         NUMBER;
  P_ente         VARCHAR2(4);
  P_ambiente     VARCHAR2(8);
  P_utente       VARCHAR2(8);
  P_lingua       VARCHAR2(1);
  P_gestione     VARCHAR2(4);
  P_cassa        VARCHAR2(5);
  P_cessati      DATE;
  P_ci           NUMBER;
  d_progressivo  number;
  dep_ni         number;
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    SELECT ENTE
         , utente
         , ambiente
         , gruppo_ling
      INTO P_ente,P_utente,P_ambiente,P_lingua
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT TO_NUMBER(SUBSTR(valore,1,4))
      INTO P_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,5)
      INTO P_cassa
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CASSA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,10)
      INTO P_cessati
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CESSATI'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,8)
      INTO P_ci
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CI'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT ENTE
         , utente
         , ambiente
         , gruppo_ling
      INTO P_ente,P_utente,P_ambiente,P_lingua
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  P_pagina := 1;
  P_riga   := 1;
  dep_ni   := 0;
  BEGIN
    FOR DIP IN
       (SELECT i.ci                          ci
             , rain.ni                       ni
             , i.codice_fiscale              cf
             , i.previdenza                  previdenza
          FROM INPDAP i, rapporti_individuali rain
         WHERE rain.ci = i.ci
           AND EXISTS
              (SELECT 'x'
                 FROM DOCUMENTI_GIURIDICI
                WHERE ci                     = i.ci
                  AND evento                 = 'SCON'
              )
         ORDER BY rain.ni,i.ci
       ) LOOP
         IF DIP.ni != dep_ni THEN
            d_progressivo := 0;
            dep_ni        := DIP.ni;
         END IF;
         BEGIN
           FOR SER IN
           (SELECT NVL(dogi.dato_n1,0)                anni
                 , NVL(dogi.dato_n2,0)                MESI
                 , NVL(dogi.dato_n3,0)                giorni
                 , dogi.scd                           tipo
                 , NVL(E_ROUND(inre.imp_tot,'I'),0)   ammontare
                 , NVL(E_ROUND(inre.tariffa,'I'),0)   rata_mensile
                 , NVL(dogi.dal,inre.dal)             prima_rata
                 , NVL(dogi.al,inre.al)               ultima_rata
                 , NVL(dogi.dato_n4,0)                contributo_unico
                 , NVL(dogi.numero,' ')               numero
                 , NVL(inre.data,dogi.del)            data
                 , DECODE(INSTR(dogi.note,'ANTICIPATA'),0,0,'',0,1) anticipata
              FROM DOCUMENTI_GIURIDICI                dogi
                 , INFORMAZIONI_RETRIBUTIVE           inre
             WHERE  dogi.ci         = inre.ci          (+)
               AND  dogi.del        = inre.data        (+)
               AND  dogi.evento     = substr(inre.numero,1,instr(inre.numero,'/') - 1) 	
               AND  dogi.scd        = substr(inre.numero,instr(inre.numero,'/')+1) 	
               AND  dogi.ci         = DIP.ci
            UNION
            SELECT NVL(dogi.dato_n1,0)                anni
                 , NVL(dogi.dato_n2,0)                MESI
                 , NVL(dogi.dato_n3,0)                giorni
                 , dogi.scd                           tipo
                 , 0                                  ammontare
                 , 0                                  rata_mensile
                 , dogi.dal                           prima_rata
                 , dogi.al                            ultima_rata
                 , NVL(dogi.dato_n4,0)                contributo_unico
                 , NVL(dogi.numero,' ')               numero
                 , dogi.del                           data
                 , DECODE(INSTR(dogi.note,'ANTICIPATA'),0,0,'',0,1) anticipata
              FROM DOCUMENTI_GIURIDICI                dogi
             WHERE  evento = 'SCON'
               AND  dogi.ci         = DIP.ci
               AND  NOT EXISTS (select 'x' 
                                  from informazioni_retributive 
                                 where ci = dogi.ci 
                                   AND data = dogi.del
                                   and numero = dogi.evento||'/'||dogi.scd
                               ) 
           ) LOOP
            d_progressivo := d_progressivo + 1;
           BEGIN
           INSERT INTO a_appoggio_stampe
           (no_prenotazione,no_passo,pagina,riga,testo)
           SELECT prenotazione
                , 1
                , P_pagina
                , P_riga
                , dip.cf||
                  RPAD(DECODE(VALUTA,'E',1,0),3,' ')||
                  RPAD(d_progressivo,3,' ')||
                  RPAD(SER.anni,3,' ')||
                  RPAD(SER.MESI,3,' ')||
                  RPAD(SER.giorni,3,' ')||
                  RPAD(SER.tipo,3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD('0',3,' ')||
                  RPAD(translate(to_char(E_ROUND(SER.ammontare,'I')),'.',','),21,' ')||
                  RPAD(translate(to_char(E_ROUND(SER.rata_mensile,'I')),'.',','),21,' ')||
                  LPAD(NVL(TO_CHAR(SER.prima_rata,'dd/mm/yyyy'),' '),10,' ')||
                  LPAD(NVL(TO_CHAR(SER.ultima_rata,'dd/mm/yyyy'),' '),10,' ')||
                  RPAD(translate(to_char(E_ROUND(SER.contributo_unico,'I')),'.',','),21,' ')||
                  '1'||
                  LPAD(SER.numero,14,' ')||
                  LPAD(NVL(TO_CHAR(SER.data,'dd/mm/yyyy'),' '),10,' ')||
                  SER.anticipata||
                  lpad(to_char(DIP.ci),8,'0')
             FROM dual
           ;
           P_riga := P_riga + 1 ;
             EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
             END;
             END LOOP;
         P_pagina := P_pagina + 1;
         P_riga   := 1           ;
         END;
         END LOOP;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
END;
END;
END;
/
