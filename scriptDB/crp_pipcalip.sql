CREATE OR REPLACE PACKAGE pipcalip IS
/******************************************************************************
 NOME:          PIPCALIP
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO    IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY pipcalip IS
form_trigger_failure	exception;
W_UTENTE	VARCHAR2(10);
W_AMBIENTE	VARCHAR2(10);
W_ENTE		VARCHAR2(10);
W_LINGUA	VARCHAR2(1);
W_PRENOTAZIONE	NUMBER(10);
w_passo		number(5);
w_voce_menu	varchar2(8);
errore		varchar2(6);
err_passo	varchar2(30);
w_dummy varchar2(1);
-- Operazioni di Calcolo del Conguaglio
--
-- Emissione in negativo del percepito su Applicazione di Progetto
--  dell'Individuo
--
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE calc_conguaglio
( P_ci number
, P_progetto   VARCHAR2
, P_scp    VARCHAR2
, P_flag_cong  VARCHAR2
, P_d_cong date
, P_ini_raip   date
, P_fin_raip   date
, P_ini_ragi   date
, P_fin_ragi   date
, P_anno   number
, P_mese   number
, P_ini_mes    date
, P_fin_mes    date
-- Parametri per Trace
, P_trc IN number -- Tipo di Trace
, P_prn IN number -- Numero di Prenotazione elaborazione
, P_pas IN number -- Numero di Passo procedurale
, P_prs IN OUT number -- Numero progressivo di Segnalazione
, P_stp IN OUT VARCHAR2   -- Step elaborato
, P_tim IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
BEGIN
   IF P_ini_mes = nvl(P_d_cong,P_ini_mes)
   THEN  -- conguaglio non attivo per l'individuo in gestione
  null;
   ELSE
  BEGIN  -- Inserisce in Negativo gli importi Percepiti nei Periodi
 -- a Conguaglio
 P_stp := 'CALC_CONGUAGLIO-01';
 insert into movimenti_incentivo
  ( progetto, scp, ci
  , periodo, anno, mese
  , equipe, gruppo
  , ruolo, qualifica, tipo_rapporto
  , sede, settore
  , giorni, calcolo, ore, importo, liquidato, da_liquidare
  )
 select progetto, scp, ci
  , P_fin_mes, anno, mese
  , equipe, gruppo
  , ruolo, qualifica, tipo_rapporto
  , sede, settore
  , sum( giorni ) * -1
  , 'R'
  , null
  , null
  , sum( liquidato ) * -1
  , sum( da_liquidare * decode(calcolo,'S',0,1) ) * -1
   from movimenti_incentivo
  where progetto = P_progetto
    and scp  = P_scp
    and ci   = P_ci
    and periodo  < P_fin_mes
    and to_date( '01/'||to_char(mese)||'/'||to_char(anno)
   , 'dd/mm/yyyy'
   )
    not between P_ini_ragi and P_fin_ragi
    and to_date( '01/'||to_char(mese)||'/'||to_char(anno)
   , 'dd/mm/yyyy'
   )
    not between P_ini_raip and P_fin_raip
    and periodo    > nvl(P_d_cong,P_ini_mes)
    and to_date( '01/'||to_char(mese)||'/'||to_char(anno)
   , 'dd/mm/yyyy'
   )  >= nvl(P_d_cong,P_ini_mes)
 group by progetto, scp, ci
 , anno, mese
 , equipe, gruppo
 , ruolo, qualifica, tipo_rapporto
 , sede, settore
 ;
  END;
   END IF;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
  RAISE;
   WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Operazioni di Calcolo Liquidazione
--
-- Calcolo della Liquidazione della singola Applicazione di Progetto
--  dell'Individuo
--
PROCEDURE calc_liquidazione
( P_ci number
, P_progetto   VARCHAR2
, P_scp    VARCHAR2
, P_flag_cong  VARCHAR2
, P_d_cong date
, P_ini_raip   date
, P_fin_raip   date
, P_ini_ragi   date
, P_fin_ragi   date
, P_valorizzazione VARCHAR2
, P_anno   number
, P_mese   number
, P_ini_mes    date
, P_fin_mes    date
-- Parametri per Trace
, P_trc IN number -- Tipo di Trace
, P_prn IN number -- Numero di Prenotazione elaborazione
, P_pas IN number -- Numero di Passo procedurale
, P_prs IN OUT number -- Numero progressivo di Segnalazione
, P_stp IN OUT VARCHAR2   -- Step elaborato
, P_tim IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
D_giorni   number;
D_calcolo  VARCHAR2(1);
D_liquidato    number;
D_da_liquidare number;
D_non_liquidato    number  := 0;
D_liquidabile  number  := 0;
D_rapporto number;
D_liquidato_pd number;
D_da_liquid_pd number;
BEGIN  -- Tratta in ciclo periodi di competenza e di conguaglio
   FOR GSIP IN
  (select anno
    , mese
    , ini_mese
    , equipe, gruppo, inizio
    , ruolo, qualifica, tipo_rapporto
    , sede, settore
    , to_char(nvl(g_dal,1))||
  to_char(nvl(g_al,31)) dal_al
    , least(nvl(g_al,30),30)-nvl(g_dal,1)+1 giorni
    , fattore
    , assenza
    , incide
    , per_ret
    , prestazione
    , ore
    , importo
    , per_liq
 from giorni_servizio_incentivo
    where (    nvl(prestazione,'I') = 'R'
   or  nvl(prestazione,'I') = 'N'
   and (   incide is null
    or incide  = 'SI'
   )
   or  nvl(prestazione,'I') = 'I'
   and (    incide is null
    or  incide != 'NO'
    and incide != 'PO'
   )
   or  nvl(prestazione,'I') = 'O'
   and (    incide is null
    or  incide != 'NO'
    and incide != 'PI'
   )
   or  nvl(prestazione,'I') = 'E'
   and (    incide is null
    or  incide != 'NO'
    and incide != 'PI'
   )
  )
  and progetto = P_progetto
  and scp  = P_scp
  and ci   = P_ci
  and ini_mese >= nvl(P_d_cong,P_ini_mes)
  and ini_mese <= P_ini_mes
  and ini_mese
  not between P_ini_ragi and P_fin_ragi
  and ini_mese
  not between P_ini_raip and P_fin_raip
  )
   LOOP
   BEGIN  -- Calcolo Liquidato e da Liquidare
  P_stp := 'CALC_LIQUIDAZIONE-01';
  IF gsip.dal_al = '3131'
  THEN
 IF gsip.incide is null
 THEN
    D_giorni := 1 * gsip.fattore;
 ELSE
    D_giorni := 0;
 END IF;
  ELSE
 D_giorni := gsip.giorni * gsip.fattore;
  END IF;
  IF gsip.prestazione = 'R'
  THEN
 IF gsip.incide = 'SI'
 THEN
    D_giorni :=  D_giorni * -1;
 ELSIF
    gsip.incide is not null
 THEN
    D_giorni :=  D_giorni
   * ( nvl(gsip.per_ret,200) - 100 ) / 100
  ;
 END IF;
  ELSE
 IF gsip.incide is not null
 THEN
    D_giorni :=  D_giorni * -1;
 END IF;
  END IF;
  IF gsip.prestazione = 'O'
  THEN
 D_calcolo  := 'O';
 D_liquidato    :=  gsip.importo * 0.1
  * ( trunc( nvl(gsip.ore,0) )
    + ( trunc( mod( ( nvl(gsip.ore,0) * 100 )
  , 100
  )
 / 100 * 60
 )
  ) / 60
    )
  * D_giorni / 30
  * gsip.per_liq / 100
 ;
 D_da_liquidare :=  gsip.importo * 0.1
  * ( trunc( nvl(gsip.ore,0) )
    + ( trunc( mod( ( nvl(gsip.ore,0) * 100 )
  , 100
  )
 / 100 * 60
 )
  ) / 60
    )
  * D_giorni / 30
  * ( 100 - gsip.per_liq ) / 100
 ;
  ELSE
 D_calcolo  := 'I';
 IF gsip.ore = 0
 THEN
    D_liquidato    := 0;
    D_da_liquidare := 0;
 ELSE
    D_liquidato    :=  gsip.importo
 * D_giorni / 30
 * gsip.per_liq / 100
    ;
    D_da_liquidare :=  gsip.importo
 * D_giorni / 30
 * ( 100 - gsip.per_liq ) / 100
    ;
 END IF;
  END IF;
   END;
   BEGIN  -- Inserimento periodo per mese di Competenza e di Conguaglio
  P_stp := 'CALC_LIQUIDAZIONE-02';
  insert into movimenti_incentivo
   ( progetto, scp, ci
   , periodo, anno, mese
   , equipe, gruppo, dal
   , ruolo, qualifica, tipo_rapporto
   , sede, settore
   , giorni, calcolo, ore, importo, liquidato, da_liquidare
   )
 values( P_progetto, P_scp, P_ci, P_fin_mes
   , gsip.anno, gsip.mese
   , gsip.equipe, gsip.gruppo, gsip.inizio
   , gsip.ruolo, gsip.qualifica, gsip.tipo_rapporto
   , gsip.sede, gsip.settore
   , D_giorni
   , D_calcolo
   , gsip.ore
   , gsip.importo
   , D_liquidato
   , D_da_liquidare
   )
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
   IF gsip.incide = 'PD'
   THEN
  D_non_liquidato := D_liquidato * -1;
   BEGIN  -- Liquidazione Assenze con Incidenza 'PD' in Gruppo 'D'
  -- ripartita per i diversi Progetti dell'Individuo
  FOR GSAS IN
 (select to_char(nvl(g_dal,1))||
 to_char(nvl(g_al,31)) dal_al
   , least(nvl(g_al,30),30)-nvl(g_dal,1)+1 giorni
   , fattore
   , incide
   , prestazione
   , ore
   , importo
   , per_liq
    from giorni_servizio_incentivo
   where nvl(prestazione,'I') in ('O','E')
 and assenza  = gsip.assenza
 and ci   = P_ci
 and anno = gsip.anno
 and mese = gsip.mese
 and ini_mese = gsip.ini_mese
 )
  LOOP
  BEGIN  -- Calcolo Liquidabile Totale per Assenza sui Progetti
 P_stp := 'CALC_LIQUIDAZIONE-03';
 IF gsas.dal_al = '3131'
 THEN
    IF gsas.incide is null
    THEN
   D_giorni := 1 * gsas.fattore;
    ELSE
   D_giorni := 0;
    END IF;
 ELSE
    D_giorni := gsas.giorni * gsas.fattore;
 END IF;
 IF gsas.prestazione = 'O'
 THEN
    D_liquidabile :=  D_liquidabile
    + ( gsas.importo * 0.1
  * ( trunc( nvl(gsas.ore,0) )
    + ( trunc( mod( ( nvl(gsas.ore,0) * 100 )
  , 100
  )
 / 100 * 60
 )
  ) / 60
    )
  * D_giorni / 30
  * gsas.per_liq / 100
  )
    ;
 ELSE
    IF gsas.ore = 0
    THEN
   D_liquidabile := 0;
    ELSE
   D_liquidabile :=  D_liquidabile
   + ( gsas.importo
 * D_giorni / 30
 * gsas.per_liq / 100
 )
  ;
    END IF;
 END IF;
  END;
  END LOOP;
  BEGIN  -- Determinazione Rapporto di Valorizzazione in Gruppo 'D'
 D_rapporto := D_non_liquidato / nvl(D_liquidabile,0);
  END;
  BEGIN  -- Update del Flag Valorizzazione a 'D' per la lettura
 -- dalla vista delle assegnazioni abbinate al gruppo 'D'
 update applicazioni_incentivo
    set valorizzazione = 'D'
  where progetto = P_progetto
    and scp  = P_scp
 ;
  END;
  FOR GSPD IN
 (select anno, mese
   , equipe, gruppo, inizio
   , ruolo, qualifica, tipo_rapporto
   , sede, settore
   , to_char(nvl(g_dal,1))||
 to_char(nvl(g_al,31)) dal_al
   , least(nvl(g_al,30),30)-nvl(g_dal,1)+1 giorni
   , fattore
   , incide
   , prestazione
   , ore
   , importo
   , per_liq
    from giorni_servizio_incentivo
   where nvl(prestazione,'I') in ('O','E')
 and assenza  = gsip.assenza
 and progetto = P_progetto
 and scp  = P_scp
 and ci   = P_ci
 and anno = gsip.anno
 and mese = gsip.mese
 and ini_mese = gsip.ini_mese
 )
  LOOP
  BEGIN  -- Calcolo Valore Rapportato di Liquidazione Assenza
 P_stp := 'CALC_LIQUIDAZIONE-04';
 IF gspd.dal_al = '3131'
 THEN
    IF gspd.incide is null
    THEN
   D_giorni := 1 * gspd.fattore;
    ELSE
   D_giorni := 0;
    END IF;
 ELSE
    D_giorni := gspd.giorni * gspd.fattore;
 END IF;
 IF gspd.prestazione = 'O'
 THEN
    D_calcolo  := 'O';
    D_liquidato_pd :=  gspd.importo * 0.1
 * ( trunc( nvl(gspd.ore,0) )
   + ( trunc( mod( ( nvl(gspd.ore,0) * 100 )
 , 100
 )
    / 100 * 60
    )
 ) / 60
   )
 * D_rapporto
 * gspd.per_liq / 100
    ;
    D_da_liquid_pd :=  gspd.importo * 0.1
 * ( trunc( nvl(gspd.ore,0) )
   + ( trunc( mod( ( nvl(gspd.ore,0) * 100 )
 , 100
 )
    / 100 * 60
    )
 ) / 60
   )
 * D_rapporto
 * ( 100 - gspd.per_liq) / 100
    ;
 ELSE
    D_calcolo  := 'I';
    IF gspd.ore = 0
    THEN
   D_liquidato_pd := 0;
   D_da_liquid_pd := 0;
    ELSE
   D_liquidato_pd :=  gspd.importo
    * D_rapporto
    * gspd.per_liq / 100
   ;
   D_da_liquid_pd :=  gspd.importo
    * D_rapporto
    * ( 100 - gspd.per_liq) / 100
   ;
    END IF;
 END IF;
  END;
  BEGIN  -- Inserimento Liquidazione in Gruppo 'D' Rapportata
 P_stp := 'CALC_LIQUIDAZIONE-05';
 insert into movimenti_incentivo
  ( progetto, scp, ci
  , periodo, anno, mese
  , equipe, gruppo, dal
  , ruolo, qualifica, tipo_rapporto
  , sede, settore
  , giorni, calcolo, ore, importo, liquidato, da_liquidare
  )
    values( P_progetto, P_scp, P_ci, P_fin_mes
  , gspd.anno, gspd.mese
  , gspd.equipe, gspd.gruppo, gspd.inizio
  , gspd.ruolo, gspd.qualifica, gspd.tipo_rapporto
  , gspd.sede, gspd.settore
  , D_giorni
  , D_calcolo
  , gspd.ore
  , gspd.importo
  , D_liquidato_pd
  , D_da_liquid_pd
  )
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  END LOOP;
  BEGIN  -- Update del Flag Valorizzazione al valore precedente
 -- modificato per lettura dalla vista delle assegnazioni
 -- abbinate al gruppo 'D'
 update applicazioni_incentivo
    set valorizzazione = P_valorizzazione
  where progetto = P_progetto
    and scp  = P_scp
 ;
  END;
   END;
   END IF;
   END LOOP;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
  RAISE;
   WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Operazioni Annullo Liquidazione Precedente
--
-- Operazioni di allineamento degli archivi al momento precedente
--  l'elaborazione
--
PROCEDURE calc_annullo
( P_ci number
, P_progetto   VARCHAR2
, P_scp    VARCHAR2
, P_flag_cong  VARCHAR2
, P_d_cong date
, P_ini_raip   date
, P_fin_raip   date
, P_ini_ragi   date
, P_fin_ragi   date
, P_anno   number
, P_mese   number
, P_ini_mes    date
, P_fin_mes    date
-- Parametri per Trace
, P_trc IN number -- Tipo di Trace
, P_prn IN number -- Numero di Prenotazione elaborazione
, P_pas IN number -- Numero di Passo procedurale
, P_prs IN OUT number -- Numero progressivo di Segnalazione
, P_stp IN OUT VARCHAR2   -- Step elaborato
, P_tim IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
BEGIN
   BEGIN  -- Elimina precedenti registrazioni in MOVIMENTI
  P_stp := 'CALC_ANNULLO-01';
  delete from movimenti_incentivo
   where progetto = P_progetto
 and scp  = P_scp
 and ci   = P_ci
 and periodo  = P_fin_mes
 and to_date( '01/'||to_char(mese)||'/'||to_char(anno)
    , 'dd/mm/yyyy'
    )
 not between P_ini_ragi and P_fin_ragi
 and to_date( '01/'||to_char(mese)||'/'||to_char(anno)
    , 'dd/mm/yyyy'
    )
 not between P_ini_raip and P_fin_raip
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
  RAISE;
   WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
  RAISE FORM_TRIGGER_FAILURE;
END;
PROCEDURE calcolo_raip
( P_ci number
, P_progetto   VARCHAR2
, P_scp    VARCHAR2
, P_flag_cong  VARCHAR2
, P_d_cong date
, P_ini_raip   date
, P_fin_raip   date
, P_ini_ragi   date
, P_fin_ragi   date
, P_d_saldo    date
, P_valorizzazione VARCHAR2
, P_per_rag    number
, P_anno   number
, P_mese   number
, P_ini_mes    date
, P_fin_mes    date
-- Parametri per Trace
, p_trc IN number -- Tipo di Trace
, p_prn IN number -- Numero di Prenotazione elaborazione
, p_pas IN number -- Numero di Passo procedurale
, p_prs IN OUT number -- Numero progressivo di Segnalazione
, p_stp IN OUT VARCHAR2   -- Step elaborato
, p_tim IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
D_tim_pro VARCHAR2(5);    -- Time impiegato in secondi per Procedure
BEGIN
   D_tim_pro := to_char(sysdate,'sssss');
   CALC_ANNULLO  -- Operazioni Annullo Liquidazione Precedente
  ( P_ci, P_progetto, P_scp, P_flag_cong, P_d_cong
    , P_ini_raip , P_fin_raip
    , P_ini_ragi , P_fin_ragi
    , P_anno, P_mese, P_ini_mes, P_fin_mes
    , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
  );
   P_stp := 'CALC_ANNULLO-END';
   trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
   IF P_flag_cong != 'A' THEN
  CALC_LIQUIDAZIONE  -- Operazioni di Calcolo della Liquidazione
 ( P_ci, P_progetto, P_scp, P_flag_cong, P_d_cong
   , P_ini_raip , P_fin_raip
   , P_ini_ragi , P_fin_ragi
   , P_valorizzazione
   , P_anno, P_mese, P_ini_mes, P_fin_mes
   , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
  P_stp := 'CALC_LIQUIDAZIONE-END';
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  IF P_flag_cong in ('R','P') THEN
 CALC_CONGUAGLIO  -- Operazioni di Calcolo del Conguaglio
    ( P_ci, P_progetto, P_scp, P_flag_cong, P_d_cong
  , P_ini_raip , P_fin_raip
  , P_ini_ragi , P_fin_ragi
  , P_anno, P_mese, P_ini_mes, P_fin_mes
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
    );
 P_stp := 'CALC_CONGUAGLIO-END';
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  END IF;
  IF  P_flag_cong in('S','R','P')
  AND P_d_saldo is not null
  THEN
      pipcalip2.CALC_SALDO   ( P_ci, P_progetto, P_scp, P_flag_cong, P_d_cong
  , P_ini_raip , P_fin_raip
  , P_ini_ragi , P_fin_ragi
  , P_anno, P_mese, P_ini_mes, P_fin_mes
  , P_d_saldo, P_per_rag
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
    );
 P_stp := 'CALC_SALDO-END';
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  END IF;
   END IF;
   pipcalip2.CALC_TERMINE  -- Operazioni Finali di Calcolo
  ( P_ci, P_progetto, P_scp, P_flag_cong, P_d_cong
    , P_ini_raip , P_fin_raip
    , P_ini_ragi , P_fin_ragi
    , P_anno, P_mese, P_ini_mes, P_fin_mes
    , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
  );
   P_stp := 'CALC_TERMINE-END';
   trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
    RAISE ;
   WHEN OTHERS THEN
    trace.err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
    RAISE FORM_TRIGGER_FAILURE;
END;
-- Calcolo Liquidazioni
--
-- Procedura di Calcolo Movimenti Incentivo
--
PROCEDURE calcolo
IS
-- Dati per gestione TRACE
d_trc   NUMBER(1);  -- Tipo di Trace
d_prn   NUMBER(6);  -- Numero di Prenotazione
d_pas   NUMBER(2);  -- Numero di Passo procedurale
d_prs   NUMBER(10); -- Numero progressivo di Segnalazione
d_stp   VARCHAR2(40);   -- Identificazione dello Step in oggetto
d_cnt   NUMBER(5);  -- Count delle row trattate
d_tim   VARCHAR2(5);    -- Time impiegato in secondi
d_tim_apip  VARCHAR2(5);    -- Time impiegato su Applicazione Progetto
d_tim_raip  VARCHAR2(5);    -- Time impiegato su Rapporto Incentivo
d_tim_tot   VARCHAR2(5);    -- Time impiegato in secondi Totale
--
-- Dati per deposito informazioni generali
d_anno  movimenti_fiscali.anno%type;
d_mese  movimenti_fiscali.mese%type;
d_mensilita movimenti_fiscali.mensilita%type;
d_ini_mes   date;
d_fin_mes   date;
--
CURSOR C_SEL_APIP
( P_progetto_start VARCHAR2
, P_scp_start  VARCHAR2
) IS
select rowid
 , progetto
 , scp
 , dal
 , al
 , d_saldo
 , valorizzazione
 , per_rag
  from applicazioni_incentivo
 where flag_elab in ('T','I')
   and (    progetto = nvl(P_progetto_start,' ')
    and scp  = nvl(P_scp_start,' ')
    or  progetto = nvl(P_progetto_start,' ')
    and scp  > nvl(P_scp_start,' ')
    or  progetto > nvl(P_progetto_start,' ')
   )
 order by progetto,scp
;
CURSOR C_UPD_APIP
( P_rowid    VARCHAR2
, P_progetto VARCHAR2
, P_scp  VARCHAR2
) IS
select 'x'
  from applicazioni_incentivo
 where rowid = P_rowid
   and progetto  = P_progetto
   and scp   = P_scp
   and flag_elab in ('T','I')
   for update of flag_elab, d_elab , valorizzazione nowait
;
D_ROW_APIP    C_UPD_APIP%ROWTYPE;
--
CURSOR C_SEL_RAIP
( P_ci_start number
, P_progetto VARCHAR2
, P_scp  VARCHAR2
, P_ini_mes  date
, P_fin_mes  date
, P_apip_al  date
) IS
select raip.rowid
 , raip.ci
 , raip.progetto
 , raip.scp
 , raip.flag_cong
 , raip.d_cong
 , decode
   ( raip.fin_blocco
   , null, nvl(raip.ini_blocco,to_date('3333333','j'))
 , nvl(raip.ini_blocco,to_date('2222222','j'))
   ) ini_raip
 , decode
   ( raip.ini_blocco
   , null, nvl(raip.fin_blocco,to_date('2222222','j'))
 , nvl(raip.fin_blocco,to_date('3333333','j'))
   ) fin_raip
 , decode
   ( ragi.fin_blocco
   , null, nvl(ragi.ini_blocco,to_date('3333333','j'))
 , nvl(ragi.ini_blocco,to_date('2222222','j'))
   ) ini_ragi
 , decode
   ( ragi.ini_blocco
   , null, nvl(ragi.fin_blocco,to_date('2222222','j'))
 , nvl(ragi.fin_blocco,to_date('3333333','j'))
   ) fin_ragi
  from rapporti_giuridici ragi
 , rapporti_incentivo raip
 where ragi.ci    = raip.ci
   and raip.flag_elab = 'R'
   and raip.progetto  = P_progetto
   and raip.scp   = P_scp
   and raip.ci    > P_ci_start
   and (    decode
    ( ragi.fin_blocco
    , null, nvl(ragi.ini_blocco,to_date('3333333','j'))
  , nvl(ragi.ini_blocco,to_date('2222222','j'))
    ) > least( P_fin_mes
 , nvl(P_apip_al,to_date('3333333','j'))
 )
    or  decode
    ( ragi.ini_blocco
    , null, nvl(ragi.fin_blocco,to_date('2222222','j'))
  , nvl(ragi.fin_blocco,to_date('3333333','j'))
    ) < nvl(raip.d_cong,P_ini_mes)
   )
   and (    decode
    ( raip.fin_blocco
    , null, nvl(raip.ini_blocco,to_date('3333333','j'))
  , nvl(raip.ini_blocco,to_date('2222222','j'))
    ) > least( P_fin_mes
 , nvl(P_apip_al,to_date('3333333','j'))
 )
    or  decode
    ( raip.ini_blocco
    , null, nvl(raip.fin_blocco,to_date('2222222','j'))
  , nvl(raip.fin_blocco,to_date('3333333','j'))
    ) < nvl(raip.d_cong,P_ini_mes)
   )
;
CURSOR C_UPD_RAIP
( P_rowid VARCHAR2
, P_ci    number
) IS
select 'x'
  from rapporti_incentivo
 where rowid = P_rowid
   and ci    = P_ci
   and flag_elab = 'R'
   for update of flag_elab nowait
;
D_ROW_RAIP    C_UPD_RAIP%ROWTYPE;
BEGIN
   BEGIN  -- Assegnazioni Iniziali per Trace
  D_prn := w_prenotazione;
  D_pas := w_passo;
  IF D_prn = 0 THEN
 D_trc := 1;
 delete from a_segnalazioni_errore
  where no_prenotazione = D_prn
    and passo   = D_pas
 ;
  ELSE
 D_trc := null;
  END IF;
  BEGIN  -- Preleva numero max di segnalazione
 select nvl(max(progressivo),0)
   into D_prs
   from a_segnalazioni_errore
  where no_prenotazione = D_prn
    and passo   = D_pas
 ;
  END;
   END;
   BEGIN  -- Segnalazione Iniziale
  D_stp := 'PIPCALIP-Start';
  D_tim := to_char(sysdate,'sssss');
  D_tim_tot := to_char(sysdate,'sssss');
  trace.log_trace(0,D_prn,D_pas,D_prs,D_stp,0,D_tim);
  commit;
   END;
   BEGIN  -- Periodo in elaborazione
  D_stp := 'CALCOLO-01';
  select riip.anno, riip.mese
   , riip.ini_mes
   , riip.fin_mes
    into D_anno, D_mese
   , D_ini_mes
   , D_fin_mes
    from riferimento_incentivo riip
   where riip.riip_id   = 'RIIP'
  ;
  trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
   END;
   <<ciclo_loop>>
   DECLARE
   D_dep_progetto   VARCHAR2(8);    -- Codice Progetto    per Ripristino LOOP
   D_dep_scp    VARCHAR2(4);    -- Codice Scp per Ripristino LOOP
   D_dep_ci number; -- Codice Individuale per Ripristino LOOP
   D_progetto_start VARCHAR2(8);    -- Codice Progetto    di partenza LOOP
   D_scp_start  VARCHAR2(4);    -- Codice Scp di partenza LOOP
   D_ci_start   number; -- Codice Individuale di partenza LOOP
   D_count_ci   number; -- Contatore ciclico Individui trattati
   BEGIN  -- Ciclo su Applicazioni Incentivo
   D_dep_progetto   := ' ';  -- Disattivazione del Ripristino
   D_dep_scp    := ' ';
   D_dep_ci := 0;
   D_progetto_start := ' ';  -- Attivazione partenza Ciclo
   D_scp_start  := ' ';
   D_ci_start   := 0;
   D_count_ci   := 0;  -- Azzeramento iniziale contatore Individui
   LOOP  -- Ripristino Ciclo:
 -- - in caso di Errore su Individuo
 -- - in caso di LOOP ciclico per rilascio ROLLBACK_SEGMENTS
   FOR APIP IN C_SEL_APIP
  ( D_progetto_start, D_scp_start
  )
   LOOP
   <<ciclo_apip>>
   DECLARE
   D_cc  VARCHAR2(30);  -- Codice di Competenza individuale
   non_competente exception;
   --
   BEGIN  -- Ciclo su Rapporti Incentivo
  D_tim_apip := to_char(sysdate,'sssss');
  BEGIN  -- Allocazione Applicazione Progetto
 D_stp    := 'CALCOLO-02';
 OPEN C_UPD_APIP (apip.rowid,apip.progetto,apip.scp);
 FETCH C_UPD_APIP INTO D_ROW_APIP;
 IF C_UPD_APIP%NOTFOUND THEN
    RAISE TIMEOUT_ON_RESOURCE;
 END IF;
  EXCEPTION
 WHEN OTHERS THEN
    RAISE TIMEOUT_ON_RESOURCE;
  END;
  BEGIN  -- Trace per Inizio Applicazione Progetto
 IF D_progetto_start = ' '
 THEN  -- Ingresso in Progetto senza Ripristino
    D_stp := 'Start '||apip.progetto||'/'||apip.scp;
    trace.log_trace(0,D_prn,D_pas,D_prs,D_stp,0,D_tim);
 ELSE
    D_progetto_start := ' ';  -- Annulla Flag per emissione Start
 END IF;
  END;
  FOR RAIP IN C_SEL_RAIP
 ( D_ci_start, apip.progetto, apip.scp
 , D_ini_mes, D_fin_mes, apip.al
 )
  LOOP
  <<ciclo_raip>>
  BEGIN
 D_count_ci := D_count_ci + 1;
 D_tim_raip := to_char(sysdate,'sssss');
 BEGIN  -- Preleva Competenza sull'individuo
    D_stp    := 'CALCOLO-03';
    select cc
  into D_cc
  from rapporti_individuali
 where ci  = raip.ci
    ;
    trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
 RAISE non_competente;
 END;
 IF D_cc IS NOT NULL THEN
    BEGIN  -- Varifica Competenza sull'Individuo
   D_stp := 'CALCOLO-04';
   select 'x'
 into w_dummy
 from a_competenze
    where utente  = w_utente
  and ambiente    = w_ambiente
  and ente    = w_ente
  and competenza  = 'CI'
  and oggetto = D_cc
   ;
   RAISE TOO_MANY_ROWS;
    EXCEPTION
   WHEN TOO_MANY_ROWS THEN
    trace.log_trace
 (D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
   WHEN NO_DATA_FOUND THEN
    RAISE non_competente;
    END;
 END IF;
 BEGIN  -- Allocazione Rapporto Incentivo
    D_stp    := 'CALCOLO-05';
    OPEN C_UPD_RAIP (raip.rowid,raip.ci);
    FETCH C_UPD_RAIP INTO D_ROW_RAIP;
    IF C_UPD_RAIP%NOTFOUND THEN
   RAISE TIMEOUT_ON_RESOURCE;
    END IF;
 EXCEPTION
    WHEN OTHERS THEN
   RAISE TIMEOUT_ON_RESOURCE;
 END;
 BEGIN  -- Calcolo Rapporto Incentivo
    CALCOLO_RAIP  -- Calcolo liquidazione Rapporto Incentivo
   ( raip.ci
   , raip.progetto
   , raip.scp
   , raip.flag_cong
   , raip.d_cong
   , raip.ini_raip, raip.fin_raip
   , raip.ini_ragi, raip.fin_ragi
   , apip.d_saldo
   , apip.valorizzazione
   , apip.per_rag
   , D_anno, D_mese, D_ini_mes, D_fin_mes
   , D_trc, D_prn, D_pas, D_prs, D_stp, D_tim
   );
 EXCEPTION
    WHEN FORM_TRIGGER_FAILURE THEN
 BEGIN  -- Preleva numero max di segnalazione
    select nvl(max(progressivo),0)
  into D_prs
  from a_segnalazioni_errore
 where no_prenotazione = D_prn
   and passo   = D_pas
    ;
 END;
 D_stp := '!!! Error #'||to_char(raip.ci);
 trace.log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_raip);
 errore := 'P05809';   -- Errore in Elaborazione
 err_passo := D_stp;  -- Step Errato
 commit;
 CLOSE C_UPD_RAIP;
 CLOSE C_UPD_APIP;
 -- Attivazione Ripristino LOOP
 D_dep_ci   := raip.ci;
 D_dep_progetto := raip.progetto;
 D_dep_scp  := raip.scp;
 -- Uscita dal LOOP
 EXIT;
 END;
 BEGIN  -- Rilascio Individuo Elaborato
    D_stp := 'CALCOLO-06';
    update rapporti_incentivo
   set flag_elab = decode( flag_cong
 , 'A', null
  , 'L'
 )
 where current of C_UPD_RAIP
    ;
    trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
    CLOSE C_UPD_RAIP;
 END;
 BEGIN  -- Trace per Fine Individuo
    D_stp := 'Complete #'||to_char(raip.ci);
    trace.log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_raip);
 END;
 BEGIN  -- Validazione Individuo Elaborato
    commit;
 END;
  EXCEPTION
 WHEN non_competente THEN  -- Individuo non Competente
  null;
 WHEN TIMEOUT_ON_RESOURCE THEN
    D_stp := '!!! Reject #'||to_char(raip.ci);
    trace.log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_raip);
    IF errore != 'P05809' THEN  -- Errore in Elaborazione
   errore := 'P05808';  -- Segnalazione in Elab.
    END IF;
    commit;
    CLOSE C_UPD_RAIP;
  END ciclo_raip;
  D_trc := null;  -- Disattiva Trace dettagliata dopo primo Individuo
  BEGIN  -- Uscita dal ciclo ogni 10 Individui
 -- per rilascio ROLLBACK_SEGMENTS di Read_consistency
 -- cursor di select su RAPPORTI_INCENTIVO
 --   e APPLICAZIONI_INCENTIVO
 IF D_count_ci = 10 THEN
    D_count_ci := 0;
    -- Attivazione Ripristino LOOP
    D_dep_ci   := raip.ci;
    D_dep_progetto := raip.progetto;
    D_dep_scp  := raip.scp;
    -- Uscita dal LOOP
    EXIT;
 END IF;
  END;
  END LOOP;  -- Fine LOOP su Ciclo Rapporti Incentivo
  IF D_dep_ci != 0 THEN  -- Se Ripristino da attivare
 CLOSE C_UPD_APIP;
 EXIT;   -- esce dal LOOP Applicazioni Incentivo
  ELSE
 D_ci_start := 0;
  END IF;
  BEGIN  -- Rilascio Applicazione Progetto Elaborata
 D_stp := 'CALCOLO-07';
 BEGIN
    select 'x'
  into w_dummy
  from rapporti_incentivo
 where progetto  = apip.progetto
   and scp   = apip.scp
   and flag_elab = 'R'
    ;
    RAISE TOO_MANY_ROWS;
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
 update applicazioni_incentivo
    set flag_elab = null
  , d_elab    = D_fin_mes
  where current of C_UPD_APIP
 ;
    WHEN TOO_MANY_ROWS THEN
 update applicazioni_incentivo
    set d_elab    = D_fin_mes
  where current of C_UPD_APIP
 ;
 END;
 trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 CLOSE C_UPD_APIP;
  END;
  BEGIN  -- Trace per Fine Applicazione Progetto
 D_stp := 'End   '||apip.progetto||'/'||apip.scp;
 trace.log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_apip);
  END;
  BEGIN  -- Validazione Applicazione Progetto Elaborata
 commit;
  END;
   EXCEPTION
  WHEN TIMEOUT_ON_RESOURCE THEN
 D_stp := '!!! Reject '||apip.progetto||'/'||apip.scp;
 trace.log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_apip);
 IF errore != 'P05809' THEN  -- Errore in Elaborazione
    errore := 'P05808';  -- Segnalazione in Elab.
 END IF;
 commit;
 CLOSE C_UPD_APIP;
   END ciclo_apip;
   END LOOP;  -- Fine LOOP su Ciclo Applicazioni Incentivo
   IF D_dep_ci = 0 THEN   -- Se Ripristino non attivato
  EXIT;   -- esce dal LOOP di Ripristino
   ELSE
  D_ci_start   := D_dep_ci;
  D_progetto_start := D_dep_progetto;
  D_scp_start  := D_dep_scp;
  D_dep_progetto := ' ';
  D_dep_scp  := ' ';
  D_dep_ci   := 0;
   END IF;
   END LOOP;  -- Fine LOOP per Ripristino Ciclo
   BEGIN  -- Operazioni finali per Trace
  D_stp := 'PIPCALIP-Stop';
  trace.log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_tot);
  IF errore != 'P05809' AND   -- Errore
 errore != 'P05808' THEN  -- Segnalazione
 errore := 'P05802';  -- Elaborazione Completata
  END IF;
 commit;
   END;
   END ciclo_loop;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN  -- Errore gestito in sub-procedure
  errore := 'P05809';   -- Errore in Elaborazione
  err_passo := D_stp;  -- Step Errato
   WHEN OTHERS THEN
  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
  errore := 'P05809';   -- Errore in Elaborazione
  err_passo := D_stp;  -- Step Errato
END;
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO    IN NUMBER) is
  begin
   IF prenotazione != 0 THEN
  BEGIN  -- Preleva utente da depositare in campi Global
 select utente
  , ambiente
  , ente
  , gruppo_ling
   into w_utente
  , w_ambiente
  , w_ente
  , w_lingua
   from a_prenotazioni
  where no_prenotazione = prenotazione
 ;
  EXCEPTION
 WHEN OTHERS THEN null;
  END;
   END IF;
   w_prenotazione := prenotazione;
   w_passo := passo;
   errore := to_char(null);
   -- Memorizzato in caso di azzeramento per ROLLBACK
   -- viene riazzerato in Form chiamante per evitare Trasaction Completed
   CALCOLO;  -- Esecuzione del Calcolo Liquidazione
   IF w_prenotazione != 0 THEN
  IF errore = 'P05808' THEN
 update a_prenotazioni
    set errore = 'P05808'
  where no_prenotazione = w_prenotazione
 ;
 commit;
  ELSIF
 substr(errore,6,1) = '9' THEN
 update a_prenotazioni
    set errore   = 'P05809'
  , prossimo_passo = 91
  where no_prenotazione = w_prenotazione
 ;
 commit;
  END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
  BEGIN
 ROLLBACK;
 IF w_prenotazione != 0 THEN
    update a_prenotazioni
   set errore   = '*Abort*'
 , prossimo_passo = 99
    where no_prenotazione = w_prenotazione
    ;
    commit;
 END IF;
  EXCEPTION
 WHEN OTHERS THEN
    		null;
  END;
END;
END;
/

