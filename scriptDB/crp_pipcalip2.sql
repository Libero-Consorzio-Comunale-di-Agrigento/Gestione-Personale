CREATE OR REPLACE PACKAGE pipcalip2 IS
/******************************************************************************
 NOME:          PIPCALIP2
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
PROCEDURE calc_termine
( P_ci             number
, P_progetto       VARCHAR2
, P_scp            VARCHAR2
, P_flag_cong      VARCHAR2
, P_d_cong         date
, P_ini_raip       date
, P_fin_raip       date
, P_ini_ragi       date
, P_fin_ragi       date
, P_anno           number
, P_mese           number
, P_ini_mes        date
, P_fin_mes        date
-- Parametri per Trace
, P_trc     IN     number     -- Tipo di Trace
, P_prn     IN     number     -- Numero di Prenotazione elaborazione
, P_pas     IN     number     -- Numero di Passo procedurale
, P_prs     IN OUT number     -- Numero progressivo di Segnalazione
, P_stp     IN OUT VARCHAR2       -- Step elaborato
, P_tim     IN OUT VARCHAR2       -- Time impiegato in secondi
);
  PROCEDURE calc_saldo
( P_ci             number
, P_progetto       VARCHAR2
, P_scp            VARCHAR2
, P_flag_cong      VARCHAR2
, P_d_cong         date
, P_ini_raip       date
, P_fin_raip       date
, P_ini_ragi       date
, P_fin_ragi       date
, P_anno           number
, P_mese           number
, P_ini_mes        date
, P_fin_mes        date
, P_d_saldo        date
, P_per_rag        number
-- Parametri per Trace
, P_trc     IN     number     -- Tipo di Trace
, P_prn     IN     number     -- Numero di Prenotazione elaborazione
, P_pas     IN     number     -- Numero di Passo procedurale
, P_prs     IN OUT number     -- Numero progressivo di Segnalazione
, P_stp     IN OUT VARCHAR2       -- Step elaborato
, P_tim     IN OUT VARCHAR2       -- Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY pipcalip2 IS
  form_trigger_failure exception;
-- Operazioni Finali del Calcolo
--
-- Operazioni finali sulla singola Applicazione di Progetto
--  dell'Individuo
--
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE calc_termine
( P_ci             number
, P_progetto       VARCHAR2
, P_scp            VARCHAR2
, P_flag_cong      VARCHAR2
, P_d_cong         date
, P_ini_raip       date
, P_fin_raip       date
, P_ini_ragi       date
, P_fin_ragi       date
, P_anno           number
, P_mese           number
, P_ini_mes        date
, P_fin_mes        date
-- Parametri per Trace
, P_trc     IN     number     -- Tipo di Trace
, P_prn     IN     number     -- Numero di Prenotazione elaborazione
, P_pas     IN     number     -- Numero di Passo procedurale
, P_prs     IN OUT number     -- Numero progressivo di Segnalazione
, P_stp     IN OUT VARCHAR2       -- Step elaborato
, P_tim     IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
BEGIN
   BEGIN  -- Elimina eventuali registrazioni con valori a ZERO
      delete from movimenti_incentivo
       where periodo   = P_fin_mes
         and progetto  = P_progetto
         and scp       = P_scp
         and ci        = P_ci
         and (   anno != P_anno
              or mese != P_mese
             )
         and nvl(liquidato,0)    = 0
         and nvl(saldo,0)        = 0
         and nvl(da_liquidare,0) = 0
      ;
   END;
   BEGIN  -- Elimina eventuali registrazioni con somma = a ZERO
      delete from movimenti_incentivo
       where periodo   = P_fin_mes
         and progetto  = P_progetto
         and scp       = P_scp
         and ci        = P_ci
         and (   anno != P_anno
              or mese != P_mese
             )
         and ( anno, mese
             , equipe, gruppo
             , ruolo, qualifica, nvl(tipo_rapporto,' ')
             , nvl(sede,0), settore
             , calcolo
             ) in
             (select anno, mese
                   , equipe, gruppo
                   , ruolo, qualifica, nvl(tipo_rapporto,' ')
                   , nvl(sede,0), settore
                   , calcolo
                from movimenti_incentivo
               where periodo   = P_fin_mes
                 and progetto  = P_progetto
                 and scp       = P_scp
                 and ci        = P_ci
                 and (   anno != P_anno
                      or mese != P_mese
                     )
              group by anno,mese
                     , equipe, gruppo
                     , ruolo, qualifica, tipo_rapporto
                     , sede, settore
                     , calcolo
              having nvl(sum(liquidato),0)    = 0
                 and nvl(sum(saldo),0)        = 0
                 and nvl(sum(da_liquidare),0) = 0
             )
      ;
   END;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
      RAISE;
   WHEN OTHERS THEN
      trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
      RAISE FORM_TRIGGER_FAILURE;
END;
  PROCEDURE calc_saldo
( P_ci             number
, P_progetto       VARCHAR2
, P_scp            VARCHAR2
, P_flag_cong      VARCHAR2
, P_d_cong         date
, P_ini_raip       date
, P_fin_raip       date
, P_ini_ragi       date
, P_fin_ragi       date
, P_anno           number
, P_mese           number
, P_ini_mes        date
, P_fin_mes        date
, P_d_saldo        date
, P_per_rag        number
-- Parametri per Trace
, P_trc     IN     number     -- Tipo di Trace
, P_prn     IN     number     -- Numero di Prenotazione elaborazione
, P_pas     IN     number     -- Numero di Passo procedurale
, P_prs     IN OUT number     -- Numero progressivo di Segnalazione
, P_stp     IN OUT VARCHAR2       -- Step elaborato
, P_tim     IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
D_moltiplica       number(1);
D_calcolo          VARCHAR2(1)       := 'S';
D_calcolo_sel      number(1);
D_liquidato        number;
BEGIN -- Inserisce gli importi di Saldo
   P_stp := 'CALC_SALDO-01';
   insert into movimenti_incentivo
        ( progetto, scp, ci
        , periodo
        , anno
        , mese
        , equipe, gruppo
        , ruolo, qualifica, tipo_rapporto
        , sede, settore
        , calcolo
        , saldo
        , da_liquidare
        )
   select P_progetto, P_scp, P_ci
        , P_fin_mes
        , to_number(to_char(max(P_d_saldo),'yyyy'))
        , to_number(to_char(max(P_d_saldo),'mm'))
        , moip.equipe, moip.gruppo
        , moip.ruolo, moip.qualifica,moip.tipo_rapporto
        , moip.sede, moip.settore
        , 'S'
        , sum( ( nvl(moip.liquidato,0)
               + nvl(moip.saldo,0)
               + nvl(moip.da_liquidare,0)
               )
             * decode(moip.calcolo,'S',0,1)
             ) * max(P_per_rag)/100
               - sum( nvl(moip.liquidato,0)
                    + nvl(moip.saldo,0)
                    )
        , nvl(sum(moip.da_liquidare),0) * -1
     from movimenti_incentivo moip
    where (    to_date( '01/'||to_char(moip.mese)||
                        '/'||to_char(moip.anno)
                      , 'dd/mm/yyyy'
                      )
                   not between P_ini_ragi and P_fin_ragi
           and moip.calcolo != 'S'
           and to_date( '01/'||to_char(moip.mese)||
                        '/'||to_char(moip.anno)
                       , 'dd/mm/yyyy'
                      )
                   not between P_ini_raip and P_fin_raip
          )
      and moip.progetto = P_progetto
      and moip.scp      = P_scp
      and moip.ci       = P_ci
    group by moip.equipe, moip.gruppo
           , moip.ruolo, moip.qualifica, moip.tipo_rapporto
           , moip.sede, moip.settore
   ;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
      RAISE;
   WHEN OTHERS THEN
      trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
      RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

