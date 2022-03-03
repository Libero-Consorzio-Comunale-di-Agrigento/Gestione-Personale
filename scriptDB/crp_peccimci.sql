CREATE OR REPLACE package peccimci is

/******************************************************************************
 NOME:          PECCIMCI
 DESCRIZIONE:   Imputazione a contabilita economica dell'autoliquidazione INAIL
 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data        Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    05/12/2003
 1.1  20/12/2005 MS     Correzione errore ORA in a_segnalazioni_errore
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
end;
/
CREATE OR REPLACE package body PECCIMCI is
w_prenotazione	number(10);
W_PASSO NUMBER(5);
ERRORE	VARCHAR2(6);
err_passo varchar2(30);
  d_crt_data      varchar2(10);
  segnala_esci    exception;
  esci            exception;
  uscita          exception;
  uscita_mensilita          exception;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.1 del 20/12/2005';
 END VERSIONE;
PROCEDURE CARICA	is
-- DATI PER GESTIONE TRACE
D_TRC           NUMBER(1);  -- TIPO DI TRACE
D_PRN           NUMBER(6);  -- NUMERO DI PRENOTAZIONE
D_PAS           NUMBER(2);  -- NUMERO DI PASSO PROCEDURALE
D_PRS           NUMBER(10); -- NUMERO PROGRESSIVO DI SEGNALAZIONE
D_STP           varchar2(40);   -- IDENTIFICAZIONE DELLO STEP IN OGGETTO
D_CNT           NUMBER(5);  -- COUNT DELLE ROW TRATTATE
D_TIM           varchar2(5);    -- TIME IMPIEGATO IN SECONDI
D_TIM_TOT       varchar2(5);    -- TIME IMPIEGATO IN SECONDI IN TOTALE
--
-- DATI PER DEPOSITO INFORMAZIONI GENERALI
  d_esercizio     retribuzioni_inail.anno%type;
  d_mese          movimenti_fiscali.mese%type;
  d_mensilita     varchar2(4);
  d_fin_ela       date;
  d_divisione     varchar2(4);
  d_data          date;
  d_delete        varchar2(1);
  d_conto         movimenti_bilancio.capitolo%type;
  d_d_a           varchar2(1);
  d_anticipazione number;
  d_anticipazione_cont number;
  d_importo       number;
  d_numero       number;

-- Variabili di appoggio
app varchar2(4);

BEGIN
   BEGIN  -- ASSEGNAZIONI INIZIALI PER TRACE
      D_PRN := W_PRENOTAZIONE;
      D_PAS := W_PASSO;
      IF D_PRN = 0 THEN
         D_TRC := 1;
         DELETE FROM A_SEGNALAZIONI_ERRORE
          WHERE NO_PRENOTAZIONE = D_PRN
            AND PASSO           = D_PAS
         ;
      ELSE
         D_TRC := NULL;
      END IF;
      BEGIN  -- PRELEVA NUMERO MAX DI SEGNALAZIONE
         SELECT NVL(MAX(PROGRESSIVO),0)
           INTO D_PRS
           FROM A_SEGNALAZIONI_ERRORE
          WHERE NO_PRENOTAZIONE = D_PRN
            AND PASSO           = D_PAS
         ;
      END;
   END;
   BEGIN  -- SEGNALAZIONE INIZIALE
      D_STP     := 'PECCIMCI-START';
      D_TIM     := TO_CHAR(SYSDATE,'SSSSS');
      D_TIM_TOT := TO_CHAR(SYSDATE,'SSSSS');
      TRACE.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
      commit;
   END;
   BEGIN  -- PERIODO IN ELABORAZIONE
      D_STP := 'CARICA-01';
     BEGIN
      SELECT VALORE
        INTO D_DIVISIONE
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_DIVISIONE';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_DIVISIONE := '%';
     END;

  if D_divisione != '%' then
	 begin
	 select codice
	  into app
	 from gestioni
	 where codice = D_divisione;

	 exception
	   when no_data_found then
	   	        raise uscita;
	 end;
   end if;


     BEGIN
      SELECT VALORE
        INTO D_ESERCIZIO
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_ANNO';
     EXCEPTION WHEN NO_DATA_FOUND THEN raise segnala_esci;
     END;
     
     BEGIN
      SELECT to_date(VALORE,'dd/mm/yyyy')
        INTO D_DATA
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_DATA';
     EXCEPTION WHEN NO_DATA_FOUND THEN raise segnala_esci;
     END;
     BEGIN
      SELECT VALORE
        INTO D_delete
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_DELETE';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_DELETE := null;
     END;

	 D_mensilita := 'AulI';
     TRACE.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
   END;
  BEGIN  -- Verifica Mensilita gia elaborata
      select to_char(max(data),'dd/mm/yyyy')
        into d_crt_data
        from imputazioni_cont_economica
       where (   (esercizio  = D_esercizio and mese = 1)
	          or (esercizio  = D_esercizio-1 and mese = 2)
			 )
         and mensilita  = D_mensilita
         and azienda like D_divisione
         and d_delete  is null
      ;
      IF D_crt_data is null
         THEN null;
         ELSE raise segnala_esci;
      END IF;
  END;  
  BEGIN -- Verifica la presenza di conti non definiti
      select distinct('x') 
	    into app
		from movimenti_bilancio_inail
       where (   (anno  = D_esercizio and tipo_ipn = 'P')
	          or (anno  = D_esercizio-1 and tipo_ipn = 'C')
			 )
		 and capitolo is null
		 and articolo is null
	  ;     
	  IF app = 'x' then    -- inserimento su a_segnalazioni errore dei conti non definiti.
        insert into a_segnalazioni_errore
      (no_prenotazione,passo,progressivo,errore,precisazione)
      select w_prenotazione
	        ,1
			,rownum*1000
			,'P05798'
            , substr ( 'Anno:'||mbii.anno||
              ' Gest:'||Gestione||
			  decode(mbii.tipo_ipn,'P',' Antic.','C',' Regol.')||
			  ' Ruolo:'||mbii.ruolo||
			  ' Funz.:'||mbii.funzionale
                     ,1,50)
        from movimenti_bilancio_inail mbii
       where (   (anno  = D_esercizio and tipo_ipn = 'P')
	          or (anno  = D_esercizio-1 and tipo_ipn = 'C')
			 )
         and gestione like D_divisione
		 and capitolo is null
		 and articolo is null
       ;		
	  raise segnala_esci;
	  END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN  -- ANNULLA PRECEDENTE IMPUTAZIONE CON STESSA IMPUTAZIONE
      D_STP := 'CARICA-03';
      DELETE FROM IMPUTAZIONI_CONT_ECONOMICA
       where (   (esercizio  = D_esercizio and mese = 1)
	          or (esercizio  = D_esercizio-1 and mese = 2)
			 )
         and mensilita = D_mensilita
         and (   DATA  = D_DATA
              or d_delete is not null)
         AND AZIENDA LIKE D_DIVISIONE
      ;
      TRACE.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
   END;
   BEGIN  -- CICLO SU MOVIMENTI DI BILANCIO INAIL
          -- Carica le registrazioni dell'anticipazione dell'anno in corso
      D_STP := 'CARICA-04';
      FOR CURB IN
     (select nvl(mbii.divisione,mbii.gestione)  azienda
           , mbii.ruolo      ruolo
           , mbii.funzionale funzionale
           , mbii.cdc        cdc
           , '%'             di_ruolo
           , mbii.capitolo   capitolo
           , mbii.articolo   articolo
           , 'A'             costo
		   , to_date('0101'||mbii.anno,'ddmmyyyy') inizio_competenza
		   , to_date('3112'||mbii.anno,'ddmmyyyy') fine_competenza
           , sum(mbii.importo) importo
           , substr('Anticipazione Autoliquidazione'||ruol.descrizione,1,60) causale
        from movimenti_bilancio_inail  mbii
           , ruoli                     ruol
       where mbii.anno        = D_esercizio
	     and mbii.tipo_ipn    = 'P'
         and mbii.gestione like D_divisione
         and ruol.codice = mbii.ruolo
   group by nvl(mbii.divisione,mbii.gestione)
           , mbii.ruolo
           , mbii.funzionale
           , mbii.cdc
           , mbii.capitolo
           , mbii.articolo
		   , to_date('0101'||mbii.anno,'ddmmyyyy') 
		   , to_date('3112'||mbii.anno,'ddmmyyyy') 
           , substr('Anticipazione Autoliquidazione'||ruol.descrizione,1,60)
  having sum(importo) != 0
         ) LOOP
         <<TRATTA_BIL>>
         BEGIN
            BEGIN  -- DETERMINA GESTIONE DI BILANCIO
               D_STP := 'CARICA-05';
               D_Conto := '';
               D_conto := '';
               IF     nvl(CURB.capitolo,'0') != '0' AND CURB.importo > 0 THEN
                  D_conto := CURB.capitolo;
                  D_d_a   := 'D';
                  D_importo := CURB.importo;
               ELSIF nvl(CURB.articolo,'0') != '0'  AND CURB.importo < 0  THEN
                  D_conto := CURB.articolo;
                  D_d_a   := 'D';
                  D_importo := CURB.importo*-1;
               ELSIF nvl(CURB.articolo,'0') != '0' AND CURB.importo > 0  THEN
                  D_conto := CURB.articolo;
                  D_d_a   := 'A';
                  D_importo := CURB.importo;
               ELSIF nvl(CURB.capitolo,'0') != '0' AND CURB.importo < 0  THEN
                  D_conto := CURB.capitolo;
                  D_d_a   := 'A';
                  D_importo := CURB.importo*-1;
               END IF;
            END;
            BEGIN  -- CARICA NUOVA IMPUTAZIONE
               D_STP := 'CARICA-08';
               insert into imputazioni_cont_economica
               (data, azienda, esercizio, mese, mensilita, ruolo, funzionale, cdc, di_ruolo,
                conto, d_a, costo, importo, causale, inizio_competenza, fine_competenza
               )
               values ( D_data
                      , CURB.azienda
                      , D_esercizio
                      , 1
                      , D_mensilita
                      , CURB.ruolo
                      , CURB.funzionale
                      , CURB.cdc
                      , CURB.di_ruolo
                      , D_conto
                      , D_d_a
                      , CURB.costo
                      , D_importo
                      , CURB.causale
        			  , CURB.inizio_competenza
        			  , CURB.fine_competenza
                      )
               ;
             TRACE.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
             END;
             end;
      END LOOP;
          -- CICLO SU MOVIMENTI DI BILANCIO INAIL
          -- Carica le registrazioni della regolazione dell'anno precedente
      D_STP := 'CARICA-05';
      FOR CURB IN
     (select nvl(mbii.divisione,mbii.gestione)  azienda
           , mbii.ruolo      ruolo
           , mbii.funzionale funzionale
           , mbii.cdc        cdc
           , '%'             di_ruolo
           , mbii.capitolo   capitolo
           , mbii.articolo   articolo
           , 'A'             costo
		   , to_date('0101'||mbii.anno,'ddmmyyyy') inizio_competenza
		   , to_date('3112'||mbii.anno,'ddmmyyyy') fine_competenza
           , sum(mbii.importo) importo
           , substr('Regolazione Autoliquidazione '||ruol.descrizione,1,60) causale
        from movimenti_bilancio_inail  mbii
           , ruoli                     ruol
       where mbii.anno        = D_esercizio - 1
	     and mbii.tipo_ipn    = 'C'
         and mbii.gestione like D_divisione
         and ruol.codice = mbii.ruolo
   group by nvl(mbii.divisione,mbii.gestione)
           , mbii.ruolo
           , mbii.funzionale
           , mbii.cdc
           , mbii.capitolo
           , mbii.articolo
		   , to_date('0101'||mbii.anno,'ddmmyyyy') 
		   , to_date('3112'||mbii.anno,'ddmmyyyy') 
           , substr('Regolazione Autoliquidazione '||ruol.descrizione,1,60)
  having sum(importo) != 0
         ) LOOP
         <<TRATTA_BIL>>
         BEGIN
            BEGIN  -- DETERMINA GESTIONE DI BILANCIO
               D_STP := 'CARICA-05';
               D_Conto := '';
               D_conto := '';
               IF     nvl(CURB.capitolo,'0') != '0' AND CURB.importo > 0 THEN
                  D_conto := CURB.capitolo;
                  D_d_a   := 'D';
                  D_importo := CURB.importo;
               ELSIF nvl(CURB.articolo,'0') != '0'  AND CURB.importo < 0  THEN
                  D_conto := CURB.articolo;
                  D_d_a   := 'D';
                  D_importo := CURB.importo*-1;
               ELSIF nvl(CURB.articolo,'0') != '0' AND CURB.importo > 0  THEN
                  D_conto := CURB.articolo;
                  D_d_a   := 'A';
                  D_importo := CURB.importo;
               ELSIF nvl(CURB.capitolo,'0') != '0' AND CURB.importo < 0  THEN
                  D_conto := CURB.capitolo;
                  D_d_a   := 'A';
                  D_importo := CURB.importo*-1;
               END IF;
            END;
			-- Determina l'importo da registrare, calcolando la differenza tra la regolazione e
			-- l'eventuale imputazione di anticipazione eseguita l'anno precedente sullo stesso conto. 
			-- La possiamo determinare o da RETRIBUZIONI_INAIL oppure da IMPUTAZIONI_CONT_ECONOMICA.
			-- Nel caso che i due valori siano diversi, diamo una segnalazione non bloccante.
			d_anticipazione      := 0;
			d_anticipazione_cont := 0;
			BEGIN
    			/* Anticipazione da IMPUTAZIONI_CONT_ECONOMICA gia passata alla contabilita */
    			select sum(nvl(importo,0))
    			  into d_anticipazione_cont
    			  from imputazioni_cont_economica
    			 where esercizio           = D_esercizio - 1
    			   and azienda             = CURB.azienda
    			   and nvl(ruolo,' ')      = nvl(CURB.ruolo,' ')
    			   and nvl(funzionale,' ') = nvl(CURB.funzionale,' ')
    			   and mese                = 1
    			   and mensilita           = 'AulI'
    			   and conto               = D_conto 
    			;
			EXCEPTION
			  WHEN NO_DATA_FOUND THEN D_anticipazione_cont := 0;
			END;
		    BEGIN
    			/* Anticipazione da TOTALI_RETRIBUZIONI_INAIL */
                select sum(mbii.importo) importo
                  into d_anticipazione
                  from movimenti_bilancio_inail  mbii
                 where mbii.anno        = D_esercizio - 1
           	       and mbii.tipo_ipn    = 'P'
                   and mbii.gestione like D_divisione
				   and nvl(mbii.ruolo,' ')       = nvl(CURB.ruolo,' ')
				   and nvl(mbii.funzionale,' ')  = nvl(CURB.funzionale,' ')
				   and nvl(mbii.capitolo,' ')    = nvl(CURB.capitolo,' ')
				   and nvl(mbii.articolo,' ')    = nvl(CURB.articolo,' ')
                ;
			EXCEPTION
			  WHEN NO_DATA_FOUND THEN D_anticipazione := 0;
			END;
			IF nvl(D_anticipazione,0) <> nvl(D_anticipazione_cont,0) THEN
                SELECT NVL(MAX(PROGRESSIVO),0) + 100
                  INTO D_numero
                  FROM A_SEGNALAZIONI_ERRORE
                 WHERE NO_PRENOTAZIONE = w_prenotazione
                   AND PASSO           = 1
                ;
                insert into a_segnalazioni_errore
                      (no_prenotazione,passo,progressivo,errore,precisazione)
                select w_prenotazione
          	         ,1
          			 ,d_numero
          			 ,'P05799'
                     , substr( 'Anno:'||to_char(D_esercizio-1)||
                       ' Gest:'||D_divisione||
          			   ' Conto:'||D_conto||
          			   ' Imp.:'||nvl(D_anticipazione_cont,0)||
 					   ' Calc.:'||nvl(D_anticipazione,0)
                              , 1,50 )
                  from dual
                ;		
			END IF;
   			D_importo := nvl(D_importo,0) - nvl(D_anticipazione,0);
            BEGIN  -- CARICA NUOVA IMPUTAZIONE
               D_STP := 'CARICA-08';
               insert into imputazioni_cont_economica
               (data, azienda, esercizio, mese, mensilita, ruolo, funzionale, cdc, di_ruolo,
                conto, d_a, costo, importo, causale, inizio_competenza, fine_competenza
               )
               values ( D_data
                      , CURB.azienda
                      , D_esercizio-1
                      , 2
                      , D_mensilita
                      , CURB.ruolo
                      , CURB.funzionale
                      , CURB.cdc
                      , CURB.di_ruolo
                      , D_conto
                      , D_d_a
                      , CURB.costo
                      , D_importo
                      , CURB.causale
        			  , CURB.inizio_competenza
        			  , CURB.fine_competenza
                      )
               ;
             TRACE.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
             END;
             end;
      END LOOP;
      BEGIN  -- OPERAZIONI FINALI PER TRACE
         D_STP := 'PECCIMCI-STOP';
         TRACE.LOG_TRACE(2,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM_TOT);
         IF errore != 'P05808' THEN  -- SEGNALAZIONE
            errore := 'P05802';      -- ELABORAZIONE COMPLETATA
         END IF;
        COMMIT;
      END;
end;
EXCEPTION
   WHEN uscita THEN raise uscita;
   WHEN uscita_mensilita THEN raise uscita_mensilita;
   WHEN SEGNALA_ESCI THEN raise esci;
    WHEN OTHERS THEN
       TRACE.ERR_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
       errore := 'P05809';   -- ERRORE IN ELABORAZIONE
       err_passo := D_stp;   -- Step errato
END;
PROCEDURE MAIN	(prenotazione  IN number,
		  		 PASSO 		   IN number) is
BEGIN
  W_PRENOTAZIONE := PRENOTAZIONE;
  W_PASSO	     := PASSO;
  ERRORE         := to_char(null);
  CARICA;  -- ESECUZIONE DEL CARICAMENTO IMPUTAZIONI CONTABILI
   IF W_PRENOTAZIONE != 0 THEN
      IF errore = 'P05808' THEN
         UPDATE A_PRENOTAZIONI
            SET ERRORE = 'P05808'
          WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
         ;
        Commit;
      ELSIF
         SUBSTR(errore,6,1) = '9' THEN
         UPDATE A_PRENOTAZIONI
            SET ERRORE       = 'P05809'
              , PROSSIMO_PASSO = 91
          WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
         ;
         Commit;
      END IF;
   END IF;
EXCEPTION
  WHEN uscita_mensilita THEN
   begin
      update a_prenotazioni set errore = 'Mensilita non codificata', prossimo_passo = 99
      where no_prenotazione = W_PRENOTAZIONE;
   end;
  WHEN uscita THEN
   begin
        update a_prenotazioni set errore = 'Gestione non codificata', prossimo_passo = 99
        where no_prenotazione = W_PRENOTAZIONE;
   end;
  WHEN ESCI THEN
       BEGIN
       update a_prenotazioni set errore = 'Mensilita'' gia'' elaborata in data o parametri incompleti'||d_crt_data
                 , PROSSIMO_PASSO = 99
        WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
            ;
       COMMIT;
       END;
  WHEN OTHERS THEN
      BEGIN
         ROLLBACK;
         IF W_PRENOTAZIONE != 0 THEN
            UPDATE A_PRENOTAZIONI
               SET ERRORE       = '*ABORT*'
                 , PROSSIMO_PASSO = 99
            WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
            ;
            COMMIT;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
		null;
      END;
END;
end;
/
