CREATE OR REPLACE package peccimce is

/******************************************************************************
 NOME:          PECCIMCE
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  30/06/2000
 1.1  09/09/2004 AM     Estratti i dati sempre per ultimo ruolo             
 1.2  07/12/2004 MS     Modifica per att. 8042
 1.3  10/11/2005 MS     Introduzione del campo Contratto ( att.13376 )
 1.4  16/12/2005 MS     Mod. Causale introducendo la descrizione del contratto ( att.13981 )
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,PASSO        IN NUMBER);
PROCEDURE INSERT_SEGNALAZIONE
( P_PRN IN NUMBER, P_PAS IN NUMBER, v_prg in number, v_ruolo in varchar2, v_contratto in varchar2
, v_funzionale in varchar2, v_causale in varchar2 );
end;
/
create or replace package body PECCIMCE is
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
    RETURN 'V1.2 del 07/12/2004';
 END VERSIONE;
PROCEDURE INSERT_SEGNALAZIONE
( P_PRN IN NUMBER, P_PAS IN NUMBER, v_prg in number, v_ruolo in varchar2, v_contratto in varchar2
, v_funzionale in varchar2, v_causale in varchar2 ) IS
BEGIN
   insert into a_segnalazioni_errore
   ( NO_PRENOTAZIONE, PASSO, PROGRESSIVO, ERRORE, PRECISAZIONE )
   values (  P_PRN , P_PAS , v_prg, 'P05798'
            , substr('Per Ruol/Contr/Funz/Caus: '||v_ruolo||'-'||v_contratto||'-'||v_funzionale||'-'||v_causale,1,50)
          ) ;
END;
PROCEDURE CARICA	is
-- DATI PER GESTIONE TRACE
D_TRC           NUMBER(1);  -- TIPO DI TRACE
D_PRN           NUMBER(6);  -- NUMERO DI PRENOTAZIONE
D_PAS           NUMBER(2);  -- NUMERO DI PASSO PROCEDURALE
D_PRS           NUMBER(10); -- NUMERO PROGRESSIVO DI SEGNALAZIONE
D_STP           varchar2(40);   -- IDENTIFICAZIONE DELLO STEP IN OGGETTO
D_TIM           varchar2(5);    -- TIME IMPIEGATO IN SECONDI
D_TIM_TOT       varchar2(5);    -- TIME IMPIEGATO IN SECONDI IN TOTALE
--
-- DATI PER DEPOSITO INFORMAZIONI GENERALI
  d_esercizio     movimenti_fiscali.anno%type;
  d_mese          movimenti_fiscali.mese%type;
  d_mensilita     movimenti_fiscali.mensilita%type;
  d_codice_mens   mensilita.codice%type;
  d_fin_ela       date;
  d_divisione     varchar2(4);
  d_data          date;
  d_delete        varchar2(1);
  d_conto         movimenti_bilancio.capitolo%type;
  d_d_a           varchar2(1);
  d_importo       number;
  v_prg           number:= 10000;
  
-- Variabili di appoggio
app varchar2(4);

BEGIN
   BEGIN  -- ASSEGNAZIONI INIZIALI PER TRACE
      D_PRN := W_prenOTAZIONE;
      D_PAS := W_passo;
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
      D_STP     := 'PECCIMCE-START';
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
     EXCEPTION WHEN NO_DATA_FOUND THEN D_ESERCIZIO := null;
     END; 

-- Estrazione della mensilita 

     BEGIN
      SELECT SUBSTR(VALORE,1,4)
        INTO D_CODICE_MENS
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_MENSILITA';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_CODICE_MENS := null;
     END;

     BEGIN
      SELECT to_date(VALORE,'dd/mm/yyyy')
        INTO D_DATA
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_DATA';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_DATA := null;
     END; 

     BEGIN
     SELECT nvl(D_esercizio,rire.anno) 
          , nvl(d_data
               ,last_day(to_date('01'||lpad(mens.mese,2,'0')||nvl(D_esercizio,rire.anno)
                                ,'ddmmyyyy')))         
          , mens.mese           
          , mens.mensilita
          , last_day(to_date(nvl(D_esercizio,rire.anno) ||lpad(mens.mese,2,0),'yyyymm'))
       into D_esercizio,D_data,D_mese,D_mensilita,D_fin_ela
       FROM MENSILITA MENS
	      , riferimento_retribuzione rire
      where rire.rire_id    = 'RIRE'
       and (   mens.codice  = D_codice_mens
	      or mens.mensilita = rire.mensilita and 
	         mens.mese      = rire.mese      and 
               D_codice_mens is null
           );
     EXCEPTION WHEN NO_DATA_FOUND THEN D_MENSILITA := null;
     END; 

   IF D_mensilita is null THEN 
      raise uscita_mensilita;
   END IF;
    BEGIN
      SELECT VALORE
        INTO D_delete
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_DELETE';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_DELETE := null;
     END; 

     TRACE.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
   END;
  BEGIN  -- Verifica Mensilità già elaborata
      select to_char(max(data),'dd/mm/yyyy')
        into d_crt_data
        from imputazioni_cont_economica
       where esercizio  = D_esercizio
         and mese       = D_mese
         and mensilita  = D_mensilita
         and azienda like D_divisione
         and d_delete  is null 
      ;
      IF D_crt_data is null
         THEN null;
         ELSE raise segnala_esci;
      END IF;
  END;
  BEGIN  -- ANNULLA PRECEDENTE IMPUTAZIONE CON STESSA IMPUTAZIONE
      D_STP := 'CARICA-03';
      DELETE FROM IMPUTAZIONI_CONT_ECONOMICA
       WHERE esercizio = D_esercizio
         and mese = d_mese
         and mensilita = D_mensilita
         and (   DATA  = D_DATA
              or d_delete is not null)
         AND AZIENDA LIKE D_DIVISIONE
      ;
      TRACE.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
   END;
   BEGIN  -- CICLO SU MOVIMENTI DI BILANCIO
      D_STP := 'CARICA-04';
      FOR CURB IN
     (select nvl(mobi.divisione,mobi.gestione)  azienda
           , pere.ruolo      ruolo
           , pere.contratto  contratto
           , mobi.funzionale funzionale
           , mobi.cdc        cdc
           , mobi.di_ruolo   di_ruolo
           , mobi.capitolo   capitolo
           , mobi.articolo   articolo
           , cobi.costo      costo
		   , last_day(mobi.riferimento) riferimento
           , sum(mobi.importo
                 * decode(cobi.tipo,'E',-1,'A',-1,1)) importo
           , substr(cobi.descrizione||' '||ruol.descrizione||' '||cont.descrizione,1,60) causale
        from periodi_retributivi pere
           , movimenti_bilancio mobi
           , ruoli              ruol
           , contratti          cont
           , codici_bilancio    cobi
       where pere.ci   = mobi.ci
         and pere.periodo = D_fin_ela
         and pere.competenza = 'A'
         and mobi.anno = D_esercizio
         and mobi.mese = D_mese
         and mobi.mensilita = D_mensilita
         and nvl(mobi.divisione,mobi.gestione) like D_divisione
         and ruol.codice = pere.ruolo
         and cont.codice = pere.contratto
         and cobi.codice = mobi.bilancio
   group by nvl(mobi.divisione,mobi.gestione)
           , pere.ruolo
           , pere.contratto
           , mobi.funzionale
           , mobi.cdc
           , mobi.di_ruolo
           , mobi.capitolo   
           , mobi.articolo  
           , cobi.costo
	     , last_day(mobi.riferimento)  
           , substr(cobi.descrizione||' '||ruol.descrizione||' '||cont.descrizione,1,60) 
  having  sum(nvl(importo,0) * decode(cobi.tipo,'E',-1,'A',-1,1)) != 0
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
       ELSIF nvl(CURB.capitolo,'0') = 0 THEN
          V_prg := nvl(V_prg,0) + 1;
          INSERT_SEGNALAZIONE(D_PRN, D_PAS, V_prg, CURB.ruolo, CURB.contratto, CURB.funzionale, CURB.causale );
          D_d_a := 'D';
          D_importo := CURB.importo;
       END IF;
       END;
       BEGIN  -- CARICA NUOVA IMPUTAZIONE
       D_STP := 'CARICA-08';
       insert into imputazioni_cont_economica
       (data, azienda, esercizio, mese, mensilita, ruolo, contratto, funzionale, cdc, di_ruolo,
        conto, d_a, costo, importo, causale, inizio_competenza, fine_competenza
       )
       values ( D_data
              , CURB.azienda
              , D_esercizio
              , D_mese
              , D_mensilita
              , CURB.ruolo
              , CURB.contratto
              , CURB.funzionale
              , CURB.cdc
              , CURB.di_ruolo
              , nvl(D_conto,'0')
              , D_d_a
              , CURB.costo
              , D_importo
              , CURB.causale
 	        , CURB.riferimento
		  , null
              )
       ;
             TRACE.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
             END;
             end;
      END LOOP;
      BEGIN  -- OPERAZIONI FINALI PER TRACE
         D_STP := 'PECCIMCE-STOP';
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
PROCEDURE MAIN	(prenotazione  IN number, PASSO IN number) is
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
       update a_prenotazioni set errore = 'Mensilita'' gia'' elaborata in data '||d_crt_data
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
