CREATE OR REPLACE PACKAGE peccinep3 IS
/******************************************************************************
 NOME:          PECCINEP3
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 1.1  27/12/2006 AM     Introdotta la lettura per max(chiave) anche per le voci a progressione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
  PROCEDURE INRE_PREC
( P_contratto  VARCHAR2
, P_voce   VARCHAR2
, P_dal    date
, P_ci     number
, P_nulldal  date  -- Data null (to_date('2222222','j'))
, P_nullal   date  -- Data null (to_date('3333333','j'))
, P_ini_ela  date
-- Parametri per Trace
, p_trc  IN  number  -- Tipo di Trace
, p_prn  IN  number  -- Numero di Prenotazione elaborazione
, p_pas  IN  number  -- Numero di Passo procedurale
, p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
, p_stp  IN OUT  VARCHAR2  -- Step elaborato
, p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
, p_errore in out varchar2
);
END;
/
CREATE OR REPLACE PACKAGE BODY peccinep3 IS
form_trigger_failure exception;
  -- Inserisce Informazioni Retributive di Progressione
--
-- Tratta le voci delle progressioni economiche
--  di tutti gli individui che hanno le caratteristiche di attribuzione
--  della voce o del singolo individuo richiesto,
--  per tutte le voci di PROGRESSIONE modificate sul dizionario VOCI
--
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.1 del 27/12/2006';
 END VERSIONE;
PROCEDURE INRE_PREC
( P_contratto  VARCHAR2
, P_voce   VARCHAR2
, P_dal    date
, P_ci     number
, P_nulldal  date  -- Data null (to_date('2222222','j'))
, P_nullal   date  -- Data null (to_date('3333333','j'))
, P_ini_ela  date
-- Parametri per Trace
, p_trc  IN  number  -- Tipo di Trace
, p_prn  IN  number  -- Numero di Prenotazione elaborazione
, p_pas  IN  number  -- Numero di Passo procedurale
, p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
, p_stp  IN OUT  VARCHAR2  -- Step elaborato
, p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
, p_errore in out varchar2
) IS
  D_dummy VARCHAR2(1);
BEGIN
 P_stp := 'INRE-PREC';
 IF P_ci is null THEN
 FOR curp IN (
 select inre.ci
    , vpvo.voce
    , voec.sequenza
    , inre.sub
    , round( ( nvl(inre.tariffa,0)
       * least( nvl(bavo.max_percentuale,9999)
        , ( nvl(vpvo.per_pro,0)
          + decode( bavo.max_percentuale
            , null, 0
              , nvl(inec.eccedenza,0)
            )
          )
        ) / 100
       )
     + ( nvl(vpvo.imp_fis,0)
       * least( nvl(bavo.max_percentuale,9999)
        , ( decode( nvl(vpvo.per_pro,0)
            , 0, 100
             , vpvo.per_pro
            )
          + decode( bavo.max_percentuale
            , null, 0
              , nvl(inec.eccedenza,0)
            )
          )
        ) / 100
       )
     , nvl(bavo.decimali,0)
     )
    + decode( bavo.voce_ecce
      , null, decode( bavo.max_percentuale
          , null, nvl(inec.eccedenza,0)
            , 0
          )
        , 0
      ) tariffa
    , greatest
    ( inre.dal
    , decode( prec.dal
      , prec.inizio, prec.inizio
        , decode( sign( bavo.gg_periodo
            - to_number(to_char(prec.inizio,'dd'))
            )
          , -1, decode
            ( to_char(bavo.gg_periodo)||
            bavo.beneficio_anzianita
            , '0M', to_date
              ( '0101'||
                to_char( prec.inizio,'yyyy')
              , 'ddmmyyyy'
              )
              , last_day(prec.inizio)+1
            )
            , last_day(add_months(prec.inizio,-1))+1
          )
      )
    ) dal
    , decode
    ( greatest( nvl(prec.fine,P_nullal)
        , prec.inizio
        )
    , prec.inizio, prec.fine
    , least
      ( nvl(inre.al,P_nullal)
      , nvl(inec.al,P_nullal)
      , decode
      ( least
      ( nvl(sopr.dal-1,P_nullal)
      , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
           beneficio_anzianita
           , '0M', add_months
             ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
             , -12
             )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
      , nvl(sopr.dal-1,P_nullal), inre.al
      , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
           beneficio_anzianita
           , '0M', add_months
             ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
             , -12
             )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
      )
    ) al
    , 'B' tipo
    , inre.qualifica
    , inre.tipo_rapporto
    , P_ini_ela data_agg
   from basi_voce_bp      bavo
    , voci_economiche     voec
    , inquadramenti_economici   inec
    , progressioni_economiche   prec
    , valori_progressione_voce_bp vpvo
    , sospensioni_progressione  sopr
    , informazioni_retributive_bp inre
    , qualifiche_giuridiche   qugi
  where   bavo.contratto    = P_contratto
  and   bavo.voce     = P_voce
  and   bavo.dal     >= P_dal
  and   voec.codice     =   bavo.voce
  and   inec.dal    between   bavo.dal
            and nvl(bavo.al,P_nullal)
  and   inec.voce     =   bavo.voce
  and   prec.ci       =   inec.ci
  and   prec.voce     =   inec.voce
  and   prec.dal      =   inec.dal
  and   prec.qualifica    =   inec.qualifica
  and   prec.periodo    > 0
  and   vpvo.voce     =   bavo.voce
  and   vpvo.contratto    =   bavo.contratto
  and   vpvo.dal      =   bavo.dal
  and   vpvo.periodo    =   prec.periodo
  and   inre.ci       =   inec.ci
  and   inre.voce     =   bavo.voce_base
  and   inre.qualifica    =   inec.qualifica
  and nvl(inre.tipo_rapporto,' ') = nvl(inec.tipo_rapporto,' ')
  and   inre.dal     <= least( nvl(inec.al,P_nullal)
               , nvl(bavo.al,P_nullal)
               )
  and nvl(inre.al,P_nullal)  >= greatest( inec.dal, bavo.dal )
  and   qugi.numero     =   inec.qualifica
  and   qugi.dal     <= nvl(inec.al,P_nullal)
  and nvl(qugi.al,P_nullal)  >=   inec.dal
/* modifica del 27/12/2006 - introdotta la lettura per max(chiave) */
-- vecchia lettura:
--  and nvl(inec.tipo_rapporto,' ') like  vpvo.tipo_rapporto
--  and   qugi.livello   like   vpvo.livello
-- nuova lettura:
 and vpvo.livello||vpvo.tipo_rapporto =
 (select max(vpvo2.livello||vpvo2.tipo_rapporto)
    from valori_progressione_voce_bp vpvo2
   where vpvo2.voce = vpvo.voce
     and vpvo2.contratto = vpvo.contratto
     and vpvo2.dal = vpvo.dal
     and vpvo2.periodo = vpvo.periodo
     and qugi.livello like vpvo2.livello
     and nvl(inec.tipo_rapporto,' ') like vpvo2.tipo_rapporto
 )
/* fine modifica del 27/12/2006 */
/* modifica del 15/12/94 */
  and   qugi.contratto    =   P_contratto
/* fine modifica del 15/12/94 */
  and decode( prec.dal
      , prec.inizio, prec.inizio
      , decode( sign( bavo.gg_periodo
            - to_number(to_char(prec.inizio,'dd'))
            )
          , -1, decode
            ( to_char(bavo.gg_periodo)||
            bavo.beneficio_anzianita
            , '0M', to_date
              ( '0101'||
              to_char( prec.inizio,'yyyy')
              , 'ddmmyyyy'
              )
              , last_day(prec.inizio)+1
            )
          , last_day(add_months(prec.inizio,-1))+1
          )
/* modifica del 18/04/97 */
      ) <=  nvl(inre.al,P_nullal)
/* fine modifica del 18/04/97 */
  and nvl
    ( decode
    ( greatest( nvl(prec.fine,P_nullal)
        , prec.inizio
        )
    , prec.inizio, prec.fine
      , least
      ( nvl(inec.al,P_nullal)
      , decode
      ( least
        ( nvl(sopr.dal-1,P_nullal)
        , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
             beneficio_anzianita
           , '0M', add_months
               ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
               , -12
               )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
        )
      , nvl(sopr.dal-1,P_nullal), inre.al
        , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
             beneficio_anzianita
           , '0M', add_months
               ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
               , -12
               )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
      )
    )
    , P_nullal
    ) >= inre.dal
  and decode( prec.dal
      , prec.inizio, prec.inizio
      , decode( sign( bavo.gg_periodo
            - to_number(to_char(prec.inizio,'dd'))
            )
          , -1, decode
            ( to_char(bavo.gg_periodo)||
            bavo.beneficio_anzianita
            , '0M', to_date
              ( '0101'||
              to_char( prec.inizio,'yyyy')
              , 'ddmmyyyy'
              )
              , last_day(prec.inizio)+1
            )
          , last_day(add_months(prec.inizio,-1))+1
          )
      ) <=
    nvl
    ( decode
    ( greatest( nvl(prec.fine,P_nullal)
        , prec.inizio
        )
    , prec.inizio, prec.fine
      , least
      ( nvl(inec.al,P_nullal)
      , decode
      ( least
        ( nvl(sopr.dal-1,P_nullal)
        , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
             beneficio_anzianita
           , '0M', add_months
               ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
               , -12
               )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
        )
      , nvl(sopr.dal-1,P_nullal), inre.al
        , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
             beneficio_anzianita
           , '0M', add_months
               ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
               , -12
               )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
      )
    )
    , P_nullal
    )
  and sopr.contratto||' '||sopr.gestione||sopr.ruolo
    ||sopr.livello||sopr.qualifica||to_char(sopr.dal,'j')
    = (select max(contratto||' '||gestione||ruolo
      ||livello||qualifica||to_char(dal,'j'))
     from sospensioni_progressione sopr2
    where   qugi.contratto  like sopr2.contratto
      and exists
       (select 'x'
        from rapporti_giuridici
       where ci      = inre.ci
       and gestione   like sopr2.gestione
       )
      and nvl(qugi.ruolo,' ') like sopr2.ruolo
      and   qugi.livello  like sopr2.livello
      and   qugi.codice   like sopr2.qualifica
  )
   order by inre.ci
/* modifica del 18/04/97 */
    , decode( prec.dal
      , prec.inizio, prec.inizio
      , decode( sign( bavo.gg_periodo
            - to_number(to_char(prec.inizio,'dd'))
            )
          , -1, decode
            ( to_char(bavo.gg_periodo)||
            bavo.beneficio_anzianita
            , '0M', to_date
              ( '0101'||
              to_char( prec.inizio,'yyyy')
              , 'ddmmyyyy'
              )
              , last_day(prec.inizio)+1
            )
          , last_day(add_months(prec.inizio,-1))+1
          )
     )
/* fine modifica del 18/04/97 */
 ) LOOP
   BEGIN
    select 'x'
    into D_dummy
    from informazioni_retributive_bp
   where ci = curp.ci
     and voce = curp.voce
     and sub  = curp.sub
     and dal  = curp.dal
    ;
    RAISE TOO_MANY_ROWS;
   EXCEPTION
    WHEN TOO_MANY_ROWS    THEN
     p_errore := 'P05808';  -- Segnalazione in Elaborazione
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'INRE-PREC: Duplicate'
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'CI   : '||to_char(curp.ci)
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'VOCE: '||curp.voce||' ('||curp.sub||')'
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'DAL : '||to_char(curp.dal,'dd/mm/yyyy')
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'AL  : '||to_char(curp.al,'dd/mm/yyyy')
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'TARIFFA: '||to_char(curp.tariffa)
        ,0,P_tim);
    WHEN NO_DATA_FOUND    THEN
     insert into informazioni_retributive_bp
      ( ci, voce, sequenza_voce, sub
      , tariffa, dal, al
      , tipo, qualifica, tipo_rapporto
      , data_agg
      )
/* modifica del 18/04/97 */
     select curp.ci, curp.voce, curp.sequenza, curp.sub
      , curp.tariffa, curp.dal, curp.al
      , curp.tipo, curp.qualifica, curp.tipo_rapporto
      , curp.data_agg
     from dual
      where not exists
       (select 'x' from informazioni_retributive
       where ci = curp.ci
         and voce = curp.voce
         and sub  = curp.sub
         and tipo = curp.tipo
         and curp.dal between
         nvl(dal,to_date('2222222','j')) and
         nvl(al,to_date('3333333','j'))
       )
/* fine modifica del 18/04/97 */
     ;
   END;
 END LOOP;
 ELSE
 FOR curp IN (
 select inre.ci
    , vpvo.voce
    , voec.sequenza
    , inre.sub
    , round( ( nvl(inre.tariffa,0)
       * least( nvl(bavo.max_percentuale,9999)
        , ( nvl(vpvo.per_pro,0)
          + decode( bavo.max_percentuale
            , null, 0
              , nvl(inec.eccedenza,0)
            )
          )
        ) / 100
       )
     + ( nvl(vpvo.imp_fis,0)
       * least( nvl(bavo.max_percentuale,9999)
        , ( decode( nvl(vpvo.per_pro,0)
            , 0, 100
             , vpvo.per_pro
            )
          + decode( bavo.max_percentuale
            , null, 0
              , nvl(inec.eccedenza,0)
            )
          )
        ) / 100
       )
     , nvl(bavo.decimali,0)
     )
    + decode( bavo.voce_ecce
      , null, decode( bavo.max_percentuale
          , null, nvl(inec.eccedenza,0)
            , 0
          )
        , 0
      ) tariffa
    , greatest
    ( inre.dal
    , decode( prec.dal
      , prec.inizio, prec.inizio
        , decode( sign( bavo.gg_periodo
            - to_number(to_char(prec.inizio,'dd'))
            )
          , -1, decode
            ( to_char(bavo.gg_periodo)||
            bavo.beneficio_anzianita
            , '0M', to_date
              ( '0101'||
                to_char( prec.inizio,'yyyy')
              , 'ddmmyyyy'
              )
              , last_day(prec.inizio)+1
            )
            , last_day(add_months(prec.inizio,-1))+1
          )
      )
    ) dal
    , least
    ( nvl(inre.al,P_nullal)
    , decode
    ( prec.fine
    , nvl(inec.al,P_nullal), inec.al
      , decode
      ( least
      ( nvl(sopr.dal-1,P_nullal)
      , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
           beneficio_anzianita
           , '0M', add_months
             ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
             , -12
             )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
      , nvl(sopr.dal-1,P_nullal), inre.al
      , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
           beneficio_anzianita
           , '0M', add_months
             ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
             , -12
             )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
    )
    ) al
    , 'B' tipo
    , inre.qualifica
    , inre.tipo_rapporto
    , P_ini_ela data_agg
   from basi_voce_bp      bavo
    , voci_economiche     voec
    , inquadramenti_economici   inec
    , progressioni_economiche   prec
    , valori_progressione_voce_bp vpvo
    , sospensioni_progressione  sopr
    , informazioni_retributive_bp inre
    , qualifiche_giuridiche   qugi
  where   inec.ci       = P_ci
  and   bavo.contratto    = P_contratto
  and   bavo.voce     = P_voce
  and   bavo.dal     >= P_dal
  and   voec.codice     =   bavo.voce
  and   inec.dal    between   bavo.dal
            and nvl(bavo.al,P_nullal)
  and   inec.voce     =   bavo.voce
  and   prec.ci       =   inec.ci
  and   prec.voce     =   inec.voce
  and   prec.dal      =   inec.dal
  and   prec.qualifica    =   inec.qualifica
  and   prec.periodo    > 0
  and   vpvo.voce     =   bavo.voce
  and   vpvo.contratto    =   bavo.contratto
  and   vpvo.dal      =   bavo.dal
  and   vpvo.periodo    =   prec.periodo
  and nvl(inec.tipo_rapporto,' ')
             like   vpvo.tipo_rapporto
  and   inre.ci       =   inec.ci
  and   inre.voce     =   bavo.voce_base
  and   inre.qualifica    =   inec.qualifica
  and nvl(inre.tipo_rapporto,' ') = nvl(inec.tipo_rapporto,' ')
  and   inre.dal     <= least( nvl(inec.al,P_nullal)
               , nvl(bavo.al,P_nullal)
               )
  and nvl(inre.al,P_nullal)  >= greatest( inec.dal, bavo.dal )
  and   qugi.numero     =   inec.qualifica
  and   qugi.dal     <= nvl(inec.al,P_nullal)
  and nvl(qugi.al,P_nullal)  >=   inec.dal
  and   qugi.livello   like   vpvo.livello
  and decode( prec.dal
      , prec.inizio, prec.inizio
      , decode( sign( bavo.gg_periodo
            - to_number(to_char(prec.inizio,'dd'))
            )
          , -1, decode
            ( to_char(bavo.gg_periodo)||
            bavo.beneficio_anzianita
            , '0M', to_date
              ( '0101'||
              to_char( prec.inizio,'yyyy')
              , 'ddmmyyyy'
              )
              , last_day(prec.inizio)+1
            )
          , last_day(add_months(prec.inizio,-1))+1
          )
      ) <= least( nvl(inre.al,P_nullal)
          , nvl(sopr.dal-1,P_nullal)
          )
  and nvl
    ( decode
    ( prec.fine
    , nvl(inec.al,P_nullal), inec.al
      , decode
      ( least
      ( nvl(sopr.dal-1,P_nullal)
      , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
           beneficio_anzianita
           , '0M', add_months
             ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
             , -12
             )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
      , nvl(sopr.dal-1,P_nullal), inre.al
      , nvl( decode
         ( sign( bavo.gg_periodo
           - to_number(to_char(prec.fine+1,'dd'))
           )
         , -1, decode
           ( to_char(bavo.gg_periodo)||
           beneficio_anzianita
           , '0M', add_months
             ( to_date
               ( '3112'||
               to_char(prec.fine+1,'yyyy')
               , 'ddmmyyyy'
               )
             , -12
             )
             , last_day(prec.fine+1)
           )
           , last_day(add_months(prec.fine+1,-1))
         )
         , inre.al
         )
      )
    )
    , P_nullal
    ) >= inre.dal
  and sopr.contratto||' '||sopr.gestione||sopr.ruolo
    ||sopr.livello||sopr.qualifica||to_char(sopr.dal,'j')
    = (select max(contratto||' '||gestione||ruolo
      ||livello||qualifica||to_char(dal,'j'))
     from sospensioni_progressione sopr2
    where   qugi.contratto  like sopr2.contratto
      and exists
       (select 'x'
        from rapporti_giuridici
       where ci      = inre.ci
       and gestione   like sopr2.gestione
       )
      and nvl(qugi.ruolo,' ') like sopr2.ruolo
      and   qugi.livello  like sopr2.livello
      and   qugi.codice   like sopr2.qualifica
  )
 ) LOOP
   BEGIN
    select 'x'
    into D_dummy
    from informazioni_retributive_bp
   where ci = curp.ci
     and voce = curp.voce
     and sub  = curp.sub
     and dal  = curp.dal
    ;
    RAISE TOO_MANY_ROWS;
   EXCEPTION
    WHEN TOO_MANY_ROWS    THEN
     p_errore := 'P05808';  -- Segnalazione in Elaborazione
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'INRE-PREC: Duplicate'
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'CI   : '||to_char(curp.ci)
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'VOCE: '||curp.voce||' ('||curp.sub||')'
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'DAL : '||to_char(curp.dal,'dd/mm/yyyy')
        ,0,P_tim);
     trace.log_trace(8,P_prn,P_pas,P_prs
        ,'AL  : '||to_char(curp.al,'dd/mm/yyyy')
        ,0,P_tim);
  	trace.log_trace(8,P_prn,P_pas,P_prs
        ,'TARIFFA: '||to_char(curp.tariffa)
        ,0,P_tim);
    WHEN NO_DATA_FOUND    THEN
     insert into informazioni_retributive_bp
      ( ci, voce, sequenza_voce, sub
      , tariffa, dal, al
      , tipo, qualifica, tipo_rapporto
      , data_agg
      )
     values
      ( curp.ci, curp.voce, curp.sequenza, curp.sub
      , curp.tariffa, curp.dal, curp.al
      , curp.tipo, curp.qualifica, curp.tipo_rapporto
      , curp.data_agg
      )
     ;
   END;
 END LOOP;
 END IF;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS     THEN
    trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
    RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

