CREATE OR REPLACE PACKAGE PECCPERE IS
/******************************************************************************
 NOME:        Peccpere
 DESCRIZIONE: Calcolo Periodi
 
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1.0  29/07/2005 NN     Aggiunta segnalazione in caso di diversi trattamenti previdenziali
                        per lo stesso mese (al), su record C e P (BO11664).
 2.0  04/04/2007 AM     modificato il conteggio dei gg in caso contratto in 26esimi e di 
                        periodi spezzati: contando i gg di calendario dei vari segmenti si
                        verificava il caso di somma dei diversi segmenti comunque < di gg_con
                        Assestato quindi l'ultimo periodo come gg_con - parte precedente il 'dal'
 2.1 10/04/2007  CB     Aggiunto il controllo sul codice di competenza di RAIN sul C_SEL_RAGI
 2.2 21/05/2007  AM     Aggiunto il ruolo estratto dalla qualifica in caso di qualifica nulla
                        (in 'CALCOLO_CI-01')
 2.3 22/10/2007  NN     Gestito il nuovo campo pere.gg_df
******************************************************************************/

revisione varchar2(30) := '2.3 del 22/10/2007';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

  ERRORE	VARCHAR2(6);
  err_passo	varchar2(30);
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER);
PROCEDURE log_trace
(
 p_trc IN number --Tipo di Trace
,p_prn IN number --Numero di Prenotazione elaborazione
,p_pas IN number --Numero di Passo procedurale
,p_prs IN OUT number --Numero progressivo di Segnalazione
,p_stp IN VARCHAR2 --Identificazione dello Step in oggetto
,p_cnt IN number --Count delle row trattate
,p_tim IN OUT VARCHAR2 --Time impiegato in secondi
);
PROCEDURE err_trace
(
 p_trc  IN number  --Tipo di Trace
,p_prn  IN number  --Numero di Prenotazione elaborazione
,p_pas  IN number  --Numero di Passo procedurale
,p_prs  IN OUT number  --Numero progressivo di Segnalazione
,p_stp  IN VARCHAR2  --Identificazione dello Step in oggetto
,p_cnt  IN number  --Count delle row trattate
,p_tim  IN OUT VARCHAR2  --Time impiegato in secondi
);
PROCEDURE calcolo;
END;
/
CREATE OR REPLACE PACKAGE BODY PECCPERE IS
  w_prenotazione	number(10):=0;
  w_PASSO           NUMBER(5):=0;
  w_utente	        varchar2(10);
  w_ambiente	    varchar2(10);
  w_ente	        varchar2(10);
  w_lingua	        varchar2(1);
  w_dummy	        varchar2(1);
  form_trigger_failure exception;

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V2.'||revisione;
END VERSIONE;

--Trace di LOG su table Segnalazioni
--
--Richiamo della Trace
----------------------
--D_stp := 'XXXX_XXXXXXXXXX-01';
--...step...
--log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
--
PROCEDURE log_trace
        (
          p_trc IN number --Tipo di Trace
        , p_prn IN number --Numero di Prenotazione elaborazione
        , p_pas IN number --Numero di Passo procedurale
        , p_prs IN OUT number --Numero progressivo di Segnalazione
        , p_stp IN VARCHAR2 --Identificazione dello Step in oggetto
        , p_cnt IN number --Count delle row trattate
        , p_tim IN OUT VARCHAR2 --Time impiegato in secondi
        ) IS
          d_ora VARCHAR2(8); --Ora:minuti.secondi
          d_systime number;
BEGIN
 IF P_trc is not null THEN
    d_systime := to_number(to_char(sysdate,'sssss'));
    IF d_systime < to_number(P_tim) THEN
       P_tim := to_char(86400 - to_number(P_tim) + d_systime);
    ELSE
       P_tim := to_char( d_systime - to_number(P_tim));
    END IF;
    d_ora := to_char(sysdate,'hh24:mi.ss');
    P_prs := P_prs+1;
    IF P_trc = 0 THEN --Segnalazione di Start
       insert into a_segnalazioni_errore
       values(P_prn,P_pas,P_prs,'P05800',
              rpad(substr(P_stp,1,20),20)||
              ' h.'||d_ora
             );
    ELSIF
       P_trc = 1 THEN --Trace di singolo step
       insert into a_segnalazioni_errore
       values(P_prn,P_pas,P_prs,'P05801',
              rpad(substr(P_stp,1,20),20)||
              ' h.'||d_ora||' ('||P_tim||
              '") #<'||to_char(P_cnt)||'>'
             );
    ELSIF
       P_trc = 2 THEN --Segnalazione di Stop
       insert into a_segnalazioni_errore
       values(P_prn,P_pas,P_prs,'P05802',
              rpad(substr(P_stp,1,20),20)||
              ' h.'||d_ora||' ('||P_tim||'")'
             );
/* modifica del 29/07/2005 */
    ELSIF
       P_trc = 6 THEN --per Trattamenti diversi
       insert into a_segnalazioni_errore
       values(P_prn,P_pas,P_prs,'P05854',
              rpad(substr(P_stp,1,30),30)
             );
/* fine modifica del 29/07/2005 */
    ELSIF
       P_trc = 7 THEN --per Giornate da Verificare
       insert into a_segnalazioni_errore
       values(P_prn,P_pas,P_prs,'P05828',
              rpad(substr(P_stp,1,20),20)
             );
    ELSIF
       P_trc = 8 THEN --per Warning
       insert into a_segnalazioni_errore
       values(P_prn,P_pas,P_prs,'P05808',
              rpad(substr(P_stp,1,20),20)||
              ' h.'||d_ora
             );
    END IF;
 END IF;
 P_tim := to_char(sysdate,'sssss');
END;
--Trace di Errore su table di Segnalazioni
--
PROCEDURE err_trace
        (
          p_trc  IN number  --Tipo di Trace
        , p_prn  IN number  --Numero di Prenotazione elaborazione
        , p_pas  IN number  --Numero di Passo procedurale
        , p_prs  IN OUT number  --Numero progressivo di Segnalazione
        , p_stp  IN VARCHAR2  --Identificazione dello Step in oggetto
        , p_cnt  IN number  --Count delle row trattate
        , p_tim  IN OUT VARCHAR2  --Time impiegato in secondi
        ) IS
          d_sqe VARCHAR2(50);  --Errore Oracle
BEGIN
  D_sqe := substr(SQLERRM,1,50);
  ROLLBACK;
  BEGIN  --Preleva numero max di segnalazioni rimaste causa ROLLBACK
   select nvl(max(progressivo),0)
     into P_prs
     from a_segnalazioni_errore
    where no_prenotazione = P_prn
      and passo = P_pas
   ;
  END;
  log_trace(1,P_prn,P_pas,P_prs,P_stp,P_cnt,P_tim);
  P_prs := P_prs+1;
  insert into a_segnalazioni_errore
  values(P_prn,P_pas,P_prs,'P05809',d_sqe);
  commit;
END;
--Calcolo Giornate Retributive su Tavola di Lavoro
--
PROCEDURE CARE_CALCOLO
        ( P_ci number
        , P_dal date
        , P_al date
        , P_cong_ind number
        , P_d_cong date
        , P_d_cong_al date
        , P_anno number
        , P_mese number
        , P_mensilita VARCHAR2
        , P_ini_ela date
        , P_fin_ela date
        , P_ini_per date
        --Parametri per Trace
        , p_trc IN number --Tipo di Trace
        , p_prn IN number --Numero di Prenotazione elaborazione
        , p_pas IN number --Numero di Passo procedurale
        , p_prs IN OUT number --Numero progressivo di Segnalazione
        , p_stp IN OUT VARCHAR2 --Step elaborato
        , p_tim IN OUT VARCHAR2 --Time impiegato in secondi
        ) IS
          D_giorno number(2); --Giorno progressivo del Mese
          D_giorni VARCHAR2(1); --Tipo del Giorno del mese
          D_gg_con periodi_retributivi.gg_con%type;
          D_gg_lav periodi_retributivi.gg_lav%type;
          D_gg_pre periodi_retributivi.gg_pre%type;
          D_gg_inp periodi_retributivi.gg_inp%type;
          D_st_inp periodi_retributivi.st_inp%type;
          D_qta_gg_con movimenti_contabili.qta%type;
          D_qta_gg_pre movimenti_contabili.qta%type;
          D_qta_gg_inp movimenti_contabili.qta%type;
          D_qta_st_inp movimenti_contabili.qta%type;
          D_qta_gg_af movimenti_contabili.qta%type;
--
--Estrazione dati per calcolo delle giornate da CALCOLI_RETRIBUTIVI
CURSOR C_SEL_CARE
 (C_ci number) IS
 select g_dal
      , g_al
      , to_number(to_char(al,'yyyy')) anno
      , to_number(to_char(al,'mm')) mese
      , gg_con
      , gg_inp
      , gg_pre
      , assenza
      , giorni
      , sede
      , rowid
   from calcoli_retributivi
  where ci = C_ci
  order by anno, mese, g_dal, g_al
 ;
--
BEGIN --Ciclo di calcolo delle giornate su CALCOLI_RETRIBUTIVI
 FOR CURC IN C_SEL_CARE
 (P_ci
 ) LOOP
 D_giorno := 1;
 D_gg_con := 0;
 D_gg_lav := 0;
 D_gg_pre := 0;
 D_gg_inp := 0;
 D_st_inp := 0;
 WHILE D_giorno <= 31 LOOP
 BEGIN --Estrazione del giorno da Calendario
   select substr(giorni,D_giorno,1)
     into D_giorni
     from calendari
    where calendario = (select nvl(max(calendario),'*')
                          from sedi
                         where numero = curc.sede
                       )
      and anno = curc.anno
      and mese = curc.mese
 ;
 EXCEPTION
 WHEN NO_DATA_FOUND
   OR TOO_MANY_ROWS THEN
      null;
 END;
 --Calcolo Giorni CONTRATTO
 IF curc.gg_con = 0 AND
    curc.giorni = 30 AND
    (    to_char(curc.g_al)||curc.assenza = ' ' AND
         D_giorno < nvl(curc.g_dal,1)
      OR to_char(curc.g_al)||curc.assenza != ' ' AND
         D_giorno between nvl(curc.g_dal,1) AND nvl(curc.g_al,31)
    ) AND
     D_giorni != '*'
 THEN
     D_gg_con := D_gg_con+1;
 ELSIF
     curc.gg_con = 0 AND
     curc.giorni not in (30,0) AND -- vecchia versione: curc.giorni != 0 AND
/* modifica del 04/04/2007 */
     (    to_char(curc.g_al) is null AND   -- vecchia versione: ||curc.assenza = ' ' AND
          D_giorno < nvl(curc.g_dal,1)
       OR to_char(curc.g_al) is not null AND   -- vecchia versione: ||curc.assenza != ' ' AND
/* fine modifica del 04/04/2007 */
          D_giorno between nvl(curc.g_dal,1) AND nvl(curc.g_al,31)
     ) AND
     (    curc.giorni in (25,26) AND
          D_giorni in ('f','F','s','S')
       OR curc.giorni not in (25,26) AND
          D_giorni in ('f','F')
     )
 THEN
     D_gg_con := D_gg_con+1;
 END IF;
 --Calcolo Giorni LAVORABILI teorici del mese intero
 IF curc.giorni = 26 AND
    D_giorni in ('f','s')
 OR curc.giorni not in (30,26) AND
    D_giorni = 'f'
 THEN
    D_gg_lav := D_gg_lav+1;
 END IF;
 --Calcolo Giorni di PRESENZA
 IF curc.gg_pre = 0 AND
   (curc.giorni = 30 AND
    curc.g_al is null AND
    D_giorno < nvl(curc.g_dal,1) AND
    D_giorni in ('f','F','s','S')
 OR curc.giorni = 30 AND
    curc.g_al is not null AND
    D_giorno between nvl(curc.g_dal,1) AND
    nvl(curc.g_al,31) AND
    D_giorni in ('f','F','s','S')
 OR curc.giorni = 26 AND
    D_giorno between nvl(curc.g_dal,1) AND
    nvl(curc.g_al,31) AND
    D_giorni in ('f','s')
 OR curc.giorni not in (30,26) AND
    D_giorno between nvl(curc.g_dal,1) AND
    nvl(curc.g_al,31) AND
    D_giorni = 'f'
   ) THEN
    D_gg_pre := D_gg_pre+1;
 END IF;
 --Calcolo Giorni INPS
 IF curc.gg_inp = 0 AND
   (curc.g_al is null AND
    D_giorno < nvl(curc.g_dal,1)
 OR curc.g_al is not null AND
    D_giorno between nvl(curc.g_dal,1) AND
    curc.g_al
   ) AND
    D_giorni in ('f','F','s','S') THEN
    D_gg_inp := D_gg_inp+1;
 END IF;
 --Calcolo Settimane INPS
 IF D_giorno between nvl(curc.g_dal,1) AND
    nvl(curc.g_al,31) AND
    D_giorni in ('s','S') THEN
    D_st_inp := D_st_inp+1;
 END IF;
    D_giorno := D_giorno+1;
 END LOOP;
 BEGIN --Estrazione dati per attivare i Giorni
       --CONTRATTO, PRESENZA, INPS e ASS.FAM
       --al valore proveniente dalla GESTIONE PRESENZE
       --(INPUT = 'M'- solo gg_con,gg_pre,gg_inp)
 select sum(decode(voec.automatismo,'GG_CON', moco.qta, null))
      , sum(decode(voec.automatismo,'GG_PRE', moco.qta, null))
      , sum(decode(voec.automatismo,'GG_INP', moco.qta, null))
      , sum(decode(voec.automatismo,'ST_INP', moco.qta, null))
      , sum(decode(voec.automatismo,'ASS_FAM',moco.qta, null))
   into D_qta_gg_con
      , D_qta_gg_pre
      , D_qta_gg_inp
      , D_qta_st_inp
      , D_qta_gg_af
   from voci_economiche voec
      , movimenti_contabili moco
  where moco.input = 'M'
    and moco.ci = P_ci
    and moco.anno = curc.anno
    and moco.mese = curc.mese
    and voec.codice = moco.voce
    and voec.automatismo in( 'GG_CON'
                           , 'GG_PRE'
                           , 'GG_INP'
                           , 'ST_INP'
                           , 'ASS_FAM'
                           )
 ;
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
      D_qta_gg_con := null;
      D_qta_gg_pre := null;
      D_qta_gg_inp := null;
      D_qta_st_inp := null;
      D_qta_gg_af := null;
 END;
 BEGIN --Aggiorna dati in CALCOLI_RETRIBUTIVI
 update calcoli_retributivi
        set gg_con =
            decode( D_qta_gg_con
                  , null, decode( gg_con
                                , 0, decode( giorni
                                           , 30, decode( to_char(g_al)||assenza
                                                       , ' ', greatest( 0, 30 - D_gg_con)
                                                            , least( 30, D_gg_con)
                                                       )
/* modifica del 04/04/2007 */
--                                               , decode( to_char(g_al)||assenza
--                                                       , ' ', greatest( 0, giorni - D_gg_con)
                                               , decode( to_char(g_al)
                                                       , '', greatest( 0, giorni - D_gg_con)
/* fine modifica del 04/04/2007 */
                                                           , least( giorni, D_gg_con)
                                                       )
                                           )
                                   , gg_con
                                )
                        , D_qta_gg_con * decode(assenza,' ',1,0)
                                       * decode( al, least( nvl(P_al,to_date(3333333,'j'))
                                                          , last_day( to_date( to_char(anno)||
                                                                               to_char(mese)
                                                                             , 'yyyymm'
                                                                             )
                                                                    )
                                                          ), 1
                                                           , 0
                                               )
                  )
          , gg_lav = decode( giorni, 30, 26, D_gg_lav )
          , gg_pre =
            decode( D_qta_gg_pre
                  , null, decode( gg_pre
                                , 0, decode( giorni
                                           , 30, decode( g_al
                                                       , null, greatest( 0, 26 - D_gg_pre
                                                                       )
                                                             , least( 26, D_gg_pre )
                                                       )
                                               , D_gg_pre
                                           )
                                   , gg_pre
                                )
                        , D_qta_gg_pre
                        * decode(assenza,' ',1,0)
                        * decode( al
                                , least( nvl(P_al,to_date(3333333,'j'))
                                       , last_day( to_date( to_char(anno)||
                                                            to_char(mese)
                                                          , 'yyyymm'
                                                          )
                                                 )
                                       ), 1
                                        , 0
                                )
                  )
          , gg_inp =
            decode( D_qta_gg_inp
                  , null, decode( gg_inp
                                , 0, decode( g_al
                                           , null, greatest( 0, 26 - D_gg_inp )
                                                 , least( 26, D_gg_inp )
                                           )
                                   , gg_inp
                                )
                        , D_qta_gg_inp
                        * decode(assenza,' ',1,0)
                        * decode( al
                                , least( nvl(P_al,to_date(3333333,'j'))
                                       , last_day( to_date( to_char(anno)||
                                                            to_char(mese)
                                                          , 'yyyymm'
                                                          )
                                                 )
                                       ), 1
                                        , 0
                                )
                 )
          , st_inp =
            decode( D_qta_st_inp
                  , null, D_st_inp
                        , D_qta_st_inp
                        * decode(assenza,' ',1,0)
                        * decode( al
                                , least( nvl(P_al,to_date(3333333,'j'))
                                , last_day( to_date( to_char(anno)||
                                                     to_char(mese)
                                                   , 'yyyymm'
                                                   )
                                          )
                                        ), 1
                                         , 0
                                )
                 )
          , gg_af =
            decode( D_qta_gg_af
                  , null, decode( giorni
                                , 30, decode( gg_con
                                            , 0, decode( to_char(g_al)||assenza
                                                       , ' ', greatest( 0, 30 - D_gg_con)
                                                            , least( 30, D_gg_con )
                                                       )
                                               , least( 30, gg_con)
                                            )
                                    , decode( gg_inp
                                            , 0, decode( g_al
                                                       , null, greatest( 0, 26 - D_gg_inp)
                                                             , least( 26, D_gg_inp )
                                                       )
                                               , gg_inp
                                            )
                                )
                        , D_qta_gg_af
                        * decode(assenza,' ',1,0)
                        * decode( al
                                , least( nvl(P_al,to_date(3333333,'j'))
                                       , last_day( to_date( to_char(anno)||
                                                            to_char(mese)
                                                          , 'yyyymm'
                                                          )
                                                 )
                                       ), 1
                                        , 0
                               )
                  )
          , gg_df =
            decode( giorni
                  , 30, decode( gg_con
                              , 0, decode( to_char(g_al)||assenza
                                         , ' ', greatest( 0, 30 - D_gg_con)
                                              , least( 30, D_gg_con )
                                         )
                                  , least( 30, gg_con)
                              )
                      , decode( gg_inp
                              , 0, decode( g_al
                                         , null, greatest( 0, 26 - D_gg_inp)
                                               , least( 26, D_gg_inp )
                                         )
                                 , gg_inp
                              )
                  )
  where rowid = curc.rowid
 ;
 END;
 END LOOP; --Fine calcolo delle giornate su CALCOLI_RETRIBUTIVI
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
 RAISE;
 WHEN OTHERS THEN
 err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
 RAISE FORM_TRIGGER_FAILURE;
END;
--Calcolo periodi individuali
--
PROCEDURE calcolo_ci
        ( P_ci number
        , P_dal date
        , P_al date
        , P_cong_ind number
        , P_d_cong date
        , P_d_cong_al date
        , P_settore number
        , P_sede number
        , P_figura number
        , P_attivita VARCHAR2
        , P_gestione VARCHAR2
        , P_contratto IN OUT VARCHAR2
        , P_ruolo IN OUT VARCHAR2
        , P_posizione VARCHAR2
        , P_qualifica IN OUT number
        , P_tipo_rapporto VARCHAR2
        , P_ore number
        , P_anno number
        , P_mese number
        , P_mensilita VARCHAR2
        , P_tipo VARCHAR2
        , P_ini_ela date
        , P_fin_ela date
        , P_ini_per date
        --Parametri per Trace
        , p_trc IN number --Tipo di Trace
        , p_prn IN number --Numero di Prenotazione elaborazione
        , p_pas IN number --Numero di Passo procedurale
        , p_prs IN OUT number --Numero progressivo di Segnalazione
        , p_stp IN OUT VARCHAR2 --Step elaborato
        , p_tim IN OUT VARCHAR2 --Time impiegato in secondi
        ) IS
          D_dummy VARCHAR2(1);
BEGIN
 BEGIN
 delete from calcoli_retributivi
  where ci = P_ci
 ;
 END;
 IF P_qualifica is null
    AND P_figura is not null
 THEN
 BEGIN
 P_stp := 'CALCOLO_CI-01';
 select qugi.contratto
      , figi.qualifica
      , qugi.ruolo
   into P_contratto
      , P_qualifica
      , P_ruolo
   from qualifiche_giuridiche qugi
      , figure_giuridiche figi
  where qugi.numero = figi.qualifica
    and nvl(P_al, P_fin_ela)
        between nvl(qugi.dal,to_date('2222222','j'))
            and nvl(qugi.al ,to_date('3333333','j'))
    and figi.numero = P_figura
    and nvl(P_al, P_fin_ela)
        between nvl(figi.dal,to_date('2222222','j'))
            and nvl(figi.al ,to_date('3333333','j'))
 ;
 log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 EXCEPTION
 WHEN OTHERS THEN null;
 END;
 END IF;
 BEGIN --Inserimento in PERIODI_RETRIBUTIVI del dipendente trattato
       --nel caso di mensilita' != 'S'.
       --Se mensilita' = 'S' esegue solo in caso non esistano altre
       --mensilita' elaborate nello stesso mese.
 select 'x'
   into D_dummy
   from movimenti_fiscali
  where ci = P_ci
    and anno = P_anno
    and mese = P_mese
    and mensilita != P_mensilita
    and mensilita not like '*%'
    and P_tipo = 'S'
 ;
 RAISE TOO_MANY_ROWS;
 EXCEPTION
 WHEN TOO_MANY_ROWS THEN
 null;
 WHEN OTHERS THEN
 peccpere2.CARE_INSERT --Inserimento Periodi da Calcolare
         ( P_ci, P_dal, P_al
         , P_cong_ind, P_d_cong, P_d_cong_al
         , P_anno, P_mese, P_mensilita
         , P_ini_ela, P_fin_ela, P_ini_per
         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
         );
 CARE_CALCOLO --Calcolo Giornate da Retribuire
         ( P_ci, P_dal, P_al
         , P_cong_ind, P_d_cong, P_d_cong_al
         , P_anno, P_mese, P_mensilita
         , P_ini_ela, P_fin_ela, P_ini_per
         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
         );
 peccpere3.PERE_INSERT --Inserimento Periodi da Retribuire
         ( P_ci, P_dal, P_al
         , P_cong_ind, P_d_cong, P_d_cong_al
         , P_settore, P_sede, P_figura, P_attivita
         , P_gestione, P_contratto, P_ruolo, P_posizione
         , P_qualifica, P_tipo_rapporto, P_ore
         , P_anno, P_mese, P_mensilita
         , P_ini_ela, P_fin_ela, P_ini_per
         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
         );
 peccpere3.PERE_CHECK --Verifica giornate effettive
         ( P_ci, P_fin_ela 
         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
         );
 END;
 BEGIN --Svuotamento Table di appoggio CALCOLI_RETRIBUTIVI
 IF nvl(P_trc,0) != 1 THEN --In caso di Trace non svuota Tabella lavoro
    P_stp := 'CALCOLO_CI-02';
 delete from calcoli_retributivi
  where ci = P_ci
 ;
 log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END IF;
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
 RAISE;
 WHEN OTHERS THEN
      err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
 RAISE FORM_TRIGGER_FAILURE;
END;
--Calcolo Periodi Retributivi
--
--Procedura di Calcolo Periodi Retributivi
--
PROCEDURE calcolo IS
          --Dati per gestione TRACE
          d_trc NUMBER(1);  --Tipo di Trace
          d_prn NUMBER(6);  --Numero di Prenotazione
          d_pas NUMBER(2);  --Numero di Passo procedurale
          d_prs NUMBER(10); --Numero progressivo di Segnalazione
          d_stp VARCHAR2(30); --Identificazione dello Step in oggetto
          d_cnt NUMBER(5);  --Count delle row trattate
          d_tim VARCHAR2(5);  --Time impiegato in secondi
          d_tim_ci  VARCHAR2(5);  --Time impiegato in secondi del Cod.Ind.
          d_tim_tot VARCHAR2(5);  --Time impiegato in secondi Totale
          --
          --Dati per deposito informazioni generali
          d_anno  movimenti_fiscali.anno%type;
          d_mese  movimenti_fiscali.mese%type;
          d_mensilita movimenti_fiscali.mensilita%type;
          d_tipo  mensilita.tipo%type;
          d_ini_ela date;
          d_fin_ela date;
          d_ini_per date;  --Inizio periodo di Calcolo
                         --
CURSOR C_SEL_RAGI
     ( P_ci_start number
     ) IS
       select ragi.rowid
            , ragi.ci
            , ragi.dal
            , ragi.al
            , ragi.cong_ind
            , d_cong
            , d_cong_al
            , ragi.settore
            , ragi.sede
            , ragi.figura
            , ragi.attivita
            , ragi.contratto
            , ragi.gestione
            , ragi.ruolo
            , ragi.posizione
            , ragi.qualifica
            , ragi.tipo_rapporto
            , ragi.ore
         from rapporti_giuridici ragi,
		      rapporti_individuali rain
        where ragi.flag_elab = 'S'
          and ragi.ci  > P_ci_start
		  and ragi.ci  = rain.ci
		  and (rain.cc is null
		       or exists
			   (select 'x'
			    from   a_competenze
				where  ente       = w_ente
				and    ambiente   = w_ambiente
				and    utente     = w_utente
				and    competenza ='CI'
				and    oggetto    = rain.cc
				)
			)
		   order by ragi.ci
		 ;
CURSOR C_UPD_RAGI
     ( p_rowid VARCHAR2
     , p_ci number
     ) IS
       select 'x'
         from rapporti_giuridici
        where rowid = P_rowid
          and ci  = P_ci
          and flag_elab = 'S'
   for update of flag_elab nowait
;
D_ROW_RAGI  C_UPD_RAGI%ROWTYPE;
BEGIN
  BEGIN  --Assegnazioni Iniziali per Trace
  D_prn := w_prenotazione;
  D_pas := w_passo;
  IF D_prn = 0 THEN
    D_trc := 1;
	delete from a_segnalazioni_errore
	 where no_prenotazione = D_prn
	   and passo = D_pas
	;
  ELSE
	 D_trc := null;
  END IF;
  BEGIN  --Preleva numero max di segnalazione
  select nvl(max(progressivo),0)
    into D_prs
    from a_segnalazioni_errore
   where no_prenotazione = D_prn
     and passo = D_pas
  ;
  END;
 END;
 BEGIN  --Segnalazione Iniziale
  D_stp := 'PECCPERE-Start';
  D_tim := to_char(sysdate,'sssss');
  D_tim_tot := to_char(sysdate,'sssss');
  log_trace(0,D_prn,D_pas,D_prs,D_stp,0,D_tim);
  commit;
 END;
 BEGIN  --Periodo in elaborazione
  D_stp := 'CALCOLO-01';
  select rire.anno, rire.mese, rire.mensilita
       , rire.ini_ela, rire.fin_ela
       , mens.tipo
    into D_anno, D_mese, D_mensilita
       , D_ini_ela, D_fin_ela
       , D_tipo
    from riferimento_retribuzione rire
       , mensilita mens
   where mens.mese  = rire.mese
     and mens.mensilita = rire.mensilita
  ;
  log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 END;
 <<ciclo_ci>>
 DECLARE
 D_dep_ci number;  --Codice Individuale per Ripristino LOOP
 D_ci_start number;  --Codice Individuale partenza LOOP
 D_cc VARCHAR2(30);  --Codice di Competenza individuale
 D_count_ci number;  --Contatore ciclico Individui trattati
 non_competente exception;
 --
 BEGIN  --Ciclo su Individui
  D_dep_ci := 0;  --Inizializzazione Codice Individuale Ripristino
  D_ci_start := 0;  --Attivazione iniziale partenza Ciclo Individui
  D_count_ci := 0;  --Azzeramento iniziale contatore Individui
  LOOP  --Ripristino Ciclo su Individui:
        --- in caso di Errore su Individuo
        --- in caso di LOOP ciclico per rilascio ROLLBACK_SEGMENTS
   FOR RAGI IN C_SEL_RAGI (D_ci_start)
  LOOP
  <<tratta_ci>>

  BEGIN
   D_count_ci := D_count_ci + 1;
 BEGIN  --Preleva Competenza sull'individuo
  D_stp  := 'CALCOLO-02';
  select cc
    into d_cc
    from rapporti_individuali
   where ci  = ragi.ci
  ;
  log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
 RAISE non_competente;
 END;
-- dbms_output.put_line('Trattando: '||to_char(ragi.ci)||W_UTENTE);
 IF D_cc is not null THEN
  BEGIN  --Varifica competenza su Individuo
 D_stp := 'CALCOLO-03';
 select 'x'
   into w_dummy
   from a_competenze
  where utente  = w_utente
    and ambiente  = w_ambiente
    and ente  = w_ente
    and competenza  = 'CI'
    and oggetto = D_cc
 ;
 RAISE TOO_MANY_ROWS;
  EXCEPTION
 WHEN TOO_MANY_ROWS THEN
  log_trace
 (D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 WHEN NO_DATA_FOUND THEN
  RAISE non_competente;
  END;
 END IF;
 BEGIN  --Allocazione individuo
  D_stp  := 'CALCOLO-04';
  D_tim_ci := to_char(sysdate,'sssss');
  OPEN C_UPD_RAGI (ragi.rowid,ragi.ci);
  FETCH C_UPD_RAGI INTO D_ROW_RAGI;
  IF C_UPD_RAGI%NOTFOUND THEN
 RAISE TIMEOUT_ON_RESOURCE;
  END IF;
  IF nvl(ragi.cong_ind,0) != 0 THEN
     D_ini_per := least(nvl(ragi.d_cong,D_ini_ela),D_ini_ela);
  ELSE
     D_ini_per := D_ini_ela;
  END IF;
 EXCEPTION
  WHEN OTHERS THEN
 RAISE TIMEOUT_ON_RESOURCE;
 END;
 BEGIN  --Elabora Individuo
  D_stp := 'CALCOLO-05';
  IF ragi.dal is null THEN
 RAISE TIMEOUT_ON_RESOURCE;
  END IF;
  CALCOLO_CI  --Calcolo periodi individuali
           ( ragi.ci, ragi.dal, ragi.al
           , ragi.cong_ind, ragi.d_cong, ragi.d_cong_al
           , ragi.settore, ragi.sede
           , ragi.figura, ragi.attivita
           , ragi.gestione, ragi.contratto
           , ragi.ruolo, ragi.posizione
           , ragi.qualifica, ragi.tipo_rapporto, ragi.ore
           , D_anno, D_mese, D_mensilita, D_tipo
           , D_ini_ela, D_fin_ela, D_ini_per
           , D_trc, D_prn, D_pas, D_prs, D_stp, D_tim
           );
 EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
   BEGIN  --Preleva numero max di segnalazione
    select nvl(max(progressivo),0)
      into D_prs
      from a_segnalazioni_errore
     where no_prenotazione = D_prn
       and passo = D_pas
    ;
   END;
   D_stp := '!!! Error #'||to_char(ragi.ci);
   log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci);
   peccpere.errore := 'P05809';  --Errore in Elaborazione
   err_passo := D_stp; --Step Errato
   commit;
   CLOSE C_UPD_RAGI;
   D_dep_ci := ragi.ci;
   EXIT;  --Uscita dal LOOP per Ripristino Ciclo Individui
 END;
 BEGIN  --Rilascio Individuo elaborato
   D_stp := 'CALCOLO-06';
  update rapporti_giuridici
     set flag_elab = 'P'
   where current of C_UPD_RAGI
  ;
  log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  CLOSE C_UPD_RAGI;
 END;
 BEGIN  --Trace per Fine Individuo
  D_stp := 'Complete #'||to_char(ragi.ci);
  log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci);
 END;
 BEGIN  --Validazione Individuo Elaborato
  commit;
 END;
  EXCEPTION
 WHEN non_competente THEN  --Individuo non Competente
  null;
 WHEN TIMEOUT_ON_RESOURCE THEN
  D_stp := '!!! Reject #'||to_char(ragi.ci);
  log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci);
  IF peccpere.errore != 'P05809' THEN  --Errore in Elaborazione
	 peccpere.errore := 'P05808';  --Segnalazione in Elab.
  END IF;
  commit;
  CLOSE C_UPD_RAGI;
  END tratta_ci;
  D_trc := null;  --Disattiva Trace dettagliata dopo primo Individuo
  BEGIN  --Uscita dal ciclo ogni 10 Individui
 --per rilascio ROLLBACK_SEGMENTS di Read_consistency
 --cursor di select su RAPPORTI_GIURIDICI
 IF D_count_ci = 10 THEN
    D_count_ci := 0;
    D_dep_ci := ragi.ci;  --Attivazione Ripristino LOOP
  EXIT; --Uscita dal LOOP
 END IF;
  END;
  END LOOP;  --Fine LOOP su Ciclo Individui
  IF D_dep_ci = 0 THEN
 EXIT;
  ELSE
   D_ci_start := D_dep_ci;
   D_dep_ci := 0;
  END IF;
  END LOOP;  --Fine LOOP su Ripristino Ciclo Individui
  BEGIN  --Operazioni finali per Trace
   D_stp := 'PECCPERE-Stop';
   log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_tot);
 IF peccpere.errore != 'P05809' AND --Errore in Elaborazione
    peccpere.errore != 'P05808' AND --Segnalazione in Elab.
    peccpere.errore != 'P05828' AND  --Giornate da Verificare
/* modifica del 29/07/2005 */
    peccpere.errore != 'P05854' THEN --Diveri Trattamenti
/* fine modifica del 29/07/2005 */
    peccpere.errore := 'P05802';  --Elaborazione Completata
 END IF;
 commit;
  END;
 END ciclo_ci;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN  --Errore gestito in sub-procedure
      peccpere.errore := 'P05809'; --Errore in Elaborazione
      err_passo := D_stp;  --Step Errato
 WHEN OTHERS THEN
      err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
      peccpere.errore := 'P05809'; --Errore in Elaborazione
      err_passo := D_stp;  --Step Errato
END CALCOLO;
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER) is
  begin
   IF prenotazione != 0 THEN
      BEGIN  --Preleva utente da depositare in campi Global
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
   CALCOLO;  --Esecuzione del Calcolo Periodi
   IF w_prenotazione != 0 THEN
      IF peccpere.errore = 'P05808' THEN
         update a_prenotazioni
            set errore = 'P05808'
          where no_prenotazione = w_prenotazione
         ;
         commit;
      ELSIF
         peccpere.errore = 'P05828' THEN
         update a_prenotazioni
            set errore = 'P05828'
          where no_prenotazione = w_prenotazione
         ;
         commit;
/* modifica del 29/07/2005 */
      ELSIF
         peccpere.errore = 'P05854' THEN
         update a_prenotazioni
            set errore = 'P05854'
          where no_prenotazione = w_prenotazione
         ;
         commit;
/* fine modifica del 29/07/2005 */
      ELSIF
         substr(peccpere.errore,6,1) = '9' THEN
         update a_prenotazioni
            set errore       = 'P05809'
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
               set errore       = '*Abort*'
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
