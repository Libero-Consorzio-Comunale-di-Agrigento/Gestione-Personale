CREATE OR REPLACE PACKAGE Pecconfr IS
/******************************************************************************
 NOME:          PECCONFR
 DESCRIZIONE:   Carica contributi Onaosi per periodi fuori dal rapporto di lavoro
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    29/11/2005 NN
 1.1  15/02/2006 NN     Passati anche voce e data al calcolo onaosi.
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY Pecconfr IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.1 del 15/02/2006';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
  D_ci                 NUMBER(8);
  D_dal                DATE;
  D_al                 DATE;
  D_anno               NUMBER(4);
  D_cod_mensilita      VARCHAR(3);
  D_errore             VARCHAR(200);
  D_dummy              VARCHAR(1);
  D_riga               NUMBER:=0;
  D_primo_mese         DATE;
  D_ultimo_mese        DATE;
  D_mese               NUMBER(2);
  D_mensilita          VARCHAR(4);
  D_imp                NUMBER:=0;
  D_mese_elab          DATE;
  D_riferimento        DATE;
  uscita               exception;
-- Parametri per Trace
  p_trc                NUMBER;        -- Tipo di Trace
  p_prn                NUMBER;        -- Numero di Prenotazione elaborazione
  p_pas                NUMBER;        -- Numero di Passo procedurale
  p_prs                NUMBER;        -- Numero progressivo di Segnalazione
  p_stp                VARCHAR(30);   -- Step elaborato
  p_tim                VARCHAR(30);   -- Time impiegato in secondi
--
-- Estrazione Parametri di Selezione della Prenotazione
--
 BEGIN
  BEGIN
    select valore
      into D_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ci := NULL;
  END;
  BEGIN
    select to_char(to_date(valore,'dd/mm/yyyy'),'dd-mon-yy')
      into D_dal
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DATA_INIZIO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_dal := NULL;
  END;
  BEGIN
    select to_char(to_date(valore,'dd/mm/yyyy'),'dd-mon-yy')
      into D_al
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DATA_FINE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_al := NULL;
  END;
  BEGIN
    select valore
      into D_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_anno := NULL;
  END;
  BEGIN
    select valore
      into D_cod_mensilita
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MENSILITA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_cod_mensilita := NULL;
  END;

   BEGIN -- controllo mensilita' indicata
        select mens.mese, mens.mensilita
          into D_mese, D_mensilita
          from RIFERIMENTO_RETRIBUZIONE rire
             , MENSILITA mens
         where rire.anno     <= D_anno
           and mens.codice = D_cod_mensilita
           and mens.tipo = 'N'
           and (  rire.anno  > D_anno 
               or rire.mese <= mens.mese)
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  d_mese := null;
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P05831',': '||D_cod_mensilita);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
   END;   -- controllo mensilita' indicata
  
  BEGIN --  Assesta il periodo
        select last_day(greatest(D_dal, to_date('3101'||D_anno,'ddmmyyyy')))
             , last_day(greatest(D_dal, to_date('3101'||D_anno,'ddmmyyyy')))
             , last_day(least(D_al, to_date('3112'||D_anno,'ddmmyyyy')))
          into D_primo_mese
             , D_mese_elab
             , D_ultimo_mese
          from dual
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  d_dummy := null;
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P00109',null);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
  END;
 
BEGIN 
  WHILE D_mese_elab between D_primo_mese and D_ultimo_mese     -- Ciclo mesi 
   LOOP
  FOR CURCI IN                 -- Loop CI / Voce /sub
    ( select ragi.ci       ci
           , voec.codice   voce
           , max(covo.sub) sub
           , to_char( to_date('3112'||
                      to_number(to_char(max(least(nvl(ragi.al,D_mese_elab),D_mese_elab))
                    , 'yyyy')) -1,'ddmmyyyy')) riferimento_onaosi
        from voci_economiche voec
           , contabilita_voce covo
           , rapporti_giuridici ragi
           , figure_giuridiche figi
       where voec.codice = covo.voce
         and voec.specifica = 'ONAOSI'
         and D_mese_elab between nvl(covo.dal,to_date('2222222','j'))
                             and nvl(covo.al,to_date('3333333','j'))
         and ragi.ci = nvl(D_ci,ragi.ci)
    group by ragi.ci, voec.codice
    )
  LOOP
  
   BEGIN  -- Verifica presenza documento MOD2
      select 'x'
        into D_dummy
        from documenti_giuridici x
       where ci = curci.ci
         and evento = 'MOD2'
         and D_mese_elab between dal and nvl(al,to_date('3333333','j'))
         and del = (select min(del) from documenti_giuridici
                     where ci     = curci.ci
                       and evento = 'MOD2'
                       and D_mese_elab between dal and nvl(al,to_date('3333333','j'))
                       and scd    = x.scd )
      ;
      Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
             d_dummy := null;
             D_riga := D_riga + 1;
             INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                              ,errore,precisazione)
             VALUES (prenotazione,1,D_riga,'P01140',null);
             update a_prenotazioni set prossimo_passo  = 91
                                     , errore          = 'P05808'
              where no_prenotazione = prenotazione
             ;
             COMMIT;
     RAISE uscita;
   END;

   BEGIN --  Calcola Riferimento Voci
     IF to_char(D_dal,'ddmm') = '0101' THEN   -- periodo pre-assunzione
        BEGIN
          select dal
            into D_riferimento
            from periodi_giuridici pegi
           where ci = CURCI.ci
             and rilevanza = 'P'
             and add_months(D_al,1) between dal and nvl(al ,to_date(3333333,'j'))
          ;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    d_dummy := null;
                    D_riga := D_riga + 1;
                    INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                     ,errore,precisazione)
                    VALUES (prenotazione,1,D_riga,'P07907',null);
                    update a_prenotazioni set prossimo_passo  = 91
                                            , errore          = 'P05808'
                     where no_prenotazione = prenotazione
                    ;
                    COMMIT;
          RAISE uscita;
        END;
     ELSIF to_char(D_al,'ddmm') = '3112' THEN   -- periodo post-cessazione
        BEGIN
          select al
            into D_riferimento
            from periodi_giuridici pegi
           where ci = CURCI.ci
             and rilevanza = 'P'
             and add_months(D_dal,-1) between dal and al
          ;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    d_dummy := null;
                    D_riga := D_riga + 1;
                    INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                     ,errore,precisazione)
                    VALUES (prenotazione,1,D_riga,'P07907',null);
                    update a_prenotazioni set prossimo_passo  = 91
                                            , errore          = 'P05808'
                     where no_prenotazione = prenotazione
                    ;
                    COMMIT;
          RAISE uscita;
        END;
     ELSE
        BEGIN
            d_dummy := null;
            D_riga := D_riga + 1;
            INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                             ,errore,precisazione)
            VALUES (prenotazione,1,D_riga,'P01069',null);
            update a_prenotazioni set prossimo_passo  = 91
                                    , errore          = 'P05808'
             where no_prenotazione = prenotazione
            ;
            COMMIT;
          RAISE uscita;
        END;
     END IF;
   END;     --  Calcola Riferimento Voci

   IF (to_char(D_dal,'ddmm') = '0101' and D_mese_elab < D_riferimento) OR    -- non in servizio
      (to_char(D_al,'ddmm')  = '3112' and D_mese_elab > D_riferimento) THEN
   BEGIN  -- elimina eventuali voci caricate con precedente conguaglio:
       delete from movimenti_contabili
        where ci = CURCI.ci
          and anno = D_anno
          and mese = D_mese
          and mensilita = D_mensilita
          and voce = CURCI.voce
          and data is not null
          and competenza = D_mese_elab
       ;
   END;   -- elimina eventuali voci caricate con precedente elaborazione

   BEGIN  -- inserisce la nuova voce:

       peccmore_onaosi.cal_onaosi ( CURCI.ci, D_anno, D_mese_elab, curci.riferimento_onaosi
                                  , curci.voce, curci.sub, sysdate, D_imp
                                  , p_trc, p_prn, p_pas, p_prs, p_stp, p_tim);
       insert into movimenti_contabili
                 ( ci, anno, mese, mensilita, voce, sub
                 , riferimento, competenza
                 , arr, input, data, tar_var, qta_var, imp_var)
       values (CURCI.ci, D_anno, D_mese, D_mensilita, curci.voce, curci.sub
            ,  D_riferimento, D_mese_elab
            , 'C', 'I', sysdate, null, null, D_imp) 
       ;
   END;      -- inserisce la nuova voce
   END IF;   -- non in servizio
  END LOOP;  -- Ciclo CI / Voce /sub

   BEGIN
   select last_day(add_months(d_mese_elab,1))
     into d_mese_elab
     from dual
   ;
   END;

 END LOOP;    -- Ciclo mesi 
   EXCEPTION
       WHEN uscita THEN
          NULL;
       WHEN OTHERS THEN
          D_errore := SUBSTR(SQLERRM,1,200);
          ROLLBACK;
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
            D_riga := D_riga +1;
            INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                             ,errore,precisazione)
            VALUES (prenotazione,1,D_riga,'P00109',substr(D_errore,1,50));
            update a_prenotazioni set prossimo_passo  = 91
                                    , errore          = 'P05808'
             where no_prenotazione = prenotazione
            ;
            COMMIT;
   END;
   COMMIT;

EXCEPTION
     WHEN uscita THEN
        NULL;
     WHEN OTHERS THEN
        RAISE;
END; 
END;
/