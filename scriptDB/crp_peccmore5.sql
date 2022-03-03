CREATE OR REPLACE PACKAGE peccmore5 IS
/******************************************************************************
 NOME:        Peccmore5
 DESCRIZIONE: Emissione Voci ad Estrazione
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    16/03/2004 MF     Attivazione Nuova 13A con specifica RGA
 2    18/05/2004 MF     Rettifica condizione di estrazione voce RGA%. Non estraeva
                        le voci relative ai periodi precedenti in caso di cessati
                        nel mese senza conguaglio.
 2.1  15/06/2004 MF     Introduzione di OuterJoin su PERE
                        e Group By su pegi.al al posto di pegi.dal.
 3    28/04/2004 MF     Estrazione anche del TIPO delibera.
 4    21/10/2004 AM     Estrazione voci: lettura di PERE escludendo periodi fittizi;
                        modifica dell'estrazione 'RC'
 4.1  15/12/2004 AM     modifiche per miglior utilizzo degli indici
 5    28/06/2005 CB     Codice SIOPE
 6    26/07/2005 NN     Voci con specifica RGA% solo se mensilita' NON speciale
 6.1  12/06/2006 AM     Mod. gestione dell'arr. delle voci con specifica RGA% in caso di conguaglio
******************************************************************************/

revisione varchar2(30) := '6 del 26/07/2005';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

  PROCEDURE voci_estrazione
(
 p_ci             number
, p_anno_ret       number
, p_al             date    -- Data di Termine o Fine Mese
, P_cong_ind       number
, P_d_cong         date
, p_anno           number
, p_mese           number
, p_mensilita       VARCHAR2
, p_fin_ela        date
, p_tipo           VARCHAR2
, p_conguaglio      number
, p_mens_codice     VARCHAR2
, p_periodo        VARCHAR2
, p_posizione_inail VARCHAR2
, p_data_inail      date
-- Parametri per Trace
, p_trc    IN     number     -- Tipo di Trace
, p_prn    IN     number     -- Numero di Prenotazione elaborazione
, p_pas    IN     number     -- Numero di Passo procedurale
, p_prs    IN OUT number     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       -- Step elaborato
, p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY peccmore5 IS
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
   RETURN 'V1.'||revisione;
END VERSIONE;

-- Emissione Voci ad Estrazione Condizionata
--
PROCEDURE voci_estrazione
(
 p_ci             number
, p_anno_ret       number
, p_al             date    -- Data di Termine o Fine Mese
, P_cong_ind       number
, P_d_cong         date
, p_anno           number
, p_mese           number
, p_mensilita       VARCHAR2
, p_fin_ela        date
, p_tipo           VARCHAR2
, p_conguaglio      number
, p_mens_codice     VARCHAR2
, p_periodo        VARCHAR2
, p_posizione_inail VARCHAR2
, p_data_inail      date
-- Parametri per Trace
, p_trc    IN     number     -- Tipo di Trace
, p_prn    IN     number     -- Numero di Prenotazione elaborazione
, p_pas    IN     number     -- Numero di Passo procedurale
, p_prs    IN OUT number     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       -- Step elaborato
, p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
BEGIN
  BEGIN  -- Estrazione voci a Quantita` su Variabili RETRIBUTIVE del mese
     P_stp := 'VOCI_ESTRAZIONE-00';
insert into calcoli_contabili
( ci, voce, sub
, riferimento
, competenza
, arr
, input
, estrazione
, tar
, qta
, imp
, sede_del, anno_del, numero_del, delibera  -- modifica del 28/04/2004
, risorsa_intervento, capitolo, articolo, conto
, impegno, anno_impegno, sub_impegno, anno_sub_impegno,codice_siope
)
select P_ci, tavo.voce, '*'
    , caco.riferimento
    , caco.competenza
    , caco.arr
    , 'A'
    , 'Q'
    , null tar
    , decode( tavo.val_voce_qta
           , 'I', caco.imp
               , caco.qta
           ) * decode( voec.tipo, 'T', -1, 1 ) qta
    , null
    , caco.sede_del, caco.anno_del, caco.numero_del, caco.delibera  -- modifica del 28/04/2004
    , caco.risorsa_intervento, caco.capitolo, caco.articolo, caco.conto
    , caco.impegno, caco.anno_impegno, caco.sub_impegno, caco.anno_sub_impegno,caco.codice_siope
 from contabilita_voce  covo
    , voci_economiche   voec
    , calcoli_contabili caco
    , tariffe_voce      tavo
 where voec.classe       = 'Q'
  and voec.estrazione    = 'C'
  and caco.riferimento between nvl(tavo.dal,to_date(2222222,'j'))
                        and nvl(tavo.al ,to_date(3333333,'j'))
  and tavo.voce         = voec.codice
  and tavo.val_voce_qta is not null
  and caco.voce         = tavo.cod_voce_qta
  and caco.sub          = tavo.sub_voce_qta
  and covo.voce         = tavo.voce
  and covo.sub          = '*'
  and caco.riferimento between nvl(covo.dal,to_date(2222222,'j'))
                        and nvl(covo.al ,to_date(3333333,'j'))
  and caco.ci           = P_ci
  and not exists
        (select 'x'
           from calcoli_contabili
          where voce = tavo.voce
            and sub  = '*'
            and nvl(arr,' ') = nvl(caco.arr,' ')
            and ci   = P_ci
        )
  and exists
        (select 'x'
          from estrazioni_voce esvo
             , periodi_retributivi pere
         where pere.ci            = P_ci
           and pere.periodo       = P_fin_ela
           and pere.competenza    in ('C','A')
           and esvo.voce          = covo.voce
           and esvo.sub           = covo.sub
           and pere.gestione    like esvo.gestione
           and pere.contratto   like esvo.contratto
           and pere.trattamento like esvo.trattamento
           and (   esvo.condizione = 'S'
               or esvo.condizione = 'F' and P_mese = 12 and
                                         P_tipo = 'N'
               or P_mens_codice like esvo.condizione
               or substr(esvo.condizione,1,1) = 'P' and
                  substr(esvo.condizione,2,1) = P_periodo
               or esvo.condizione = 'C' and P_conguaglio = 2
               or esvo.condizione = 'RA' and P_conguaglio = 3
               or esvo.condizione = 'I' and P_conguaglio in (1,2,3)
               or esvo.condizione = 'N' and P_anno != P_anno_ret
               or esvo.condizione = 'M' and P_tipo       = 'N' and
                                         pere.gg_fis != 0
               or exists
                 (select 'x'
                    from periodi_retributivi
                   where  ci      = P_ci
                     and  periodo = P_fin_ela
                     and to_number( to_char(mese)||to_char(anno) )
                                =
                        to_number( to_char(P_fin_ela,'mmyyyy') )
                  having (    esvo.condizione    = 'R'
                         and P_tipo            = 'N'
                         and sum(nvl(gg_rat,0)) > 14
                         or  esvo.condizione    = 'G'
                         and sum(nvl(gg_rid,0)) > 0
/* modifica del 20/01/99 */
                         and P_tipo           != 'S'
/* fine modifica del 20/01/99 */
                        )
                 )
               )
        )
;
     peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  -- Estrazione voci a Quantita` su Giorni di Astensione
     P_stp := 'VOCI_ESTRAZIONE-00a';
insert into calcoli_contabili
( ci, voce, sub
, riferimento
, arr
, input
, estrazione
, tar
, qta
, imp
)
select P_ci, voec.codice, '*'
    , pere.al
    , ''
    , 'A'
    , 'Q'
    , null tar
    , nvl(sum(nvl(pere.gg_per,0)),0) qta
    , null imp
 from contabilita_voce    covo
    , periodi_retributivi pere
    , voci_economiche     voec
 where voec.classe        = 'Q'
  and voec.specifica   like 'ASTE%'
  and covo.voce          = voec.codice||''
  and covo.sub           = '*'
  and p_fin_ela     between nvl(covo.dal,to_date(2222222,'j'))
                      and nvl(covo.al ,to_date(3333333,'j'))
  and pere.ci            = P_ci
  and pere.periodo       = P_fin_ela
  and pere.competenza     = lower(pere.competenza)
  and pere.cod_astensione = rtrim(substr(voec.specifica,5))
  and not exists
        (select 'x'
           from calcoli_contabili
          where voce = voec.codice
            and sub  = '*'
            and arr is null
            and ci   = P_ci
        )
  and P_tipo = 'N'
 group by pere.al, voec.codice
;
     peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  -- Inserimento delle voci ad ESTRAZIONE CONDIZIONATA
        --   di classe C = Calcolo
        -- e di classe R = Ritenuta su  Importi Progressivi
        --                     o con Riduzione di importo
     P_stp := 'VOCI_ESTRAZIONE-01';
     FOR CURR IN
        (select esvo.voce
             , esvo.sub
             , max(voec.classe) classe
             , max(voec.estrazione) estrazione
             , max(voec.tipo) tipo
             , max(voec.specifica) specifica
             , least( P_al, max(pere.al) ) al
             , max(pere.servizio) servizio
             , max(tavo.val_voce_qta) val_voce_qta  -- modifica 16/03/2004
          from contabilita_voce    covo
             , tariffe_voce        tavo
             , periodi_retributivi pere
             , estrazioni_voce     esvo
             , voci_economiche     voec
             , periodi_giuridici   pegi
         where covo.voce = esvo.voce||''
           and covo.sub  = esvo.sub
           and least(P_al,pere.al)
                  between nvl(covo.dal, to_date('2222222','j'))
                      and nvl(covo.al , to_date('3333333','j'))
/* modifica del 16/03/2004 */
           and tavo.voce (+) = esvo.voce||''
           and least(P_al,pere.al)
                  between nvl(tavo.dal, to_date('2222222','j'))
                      and nvl(tavo.al , to_date('3333333','j'))
           and pegi.ci(+)        = pere.ci
           and pegi.rilevanza(+) = 'P'
           and pere.al     between nvl(pegi.dal(+), to_date('2222222','j'))
                               and nvl(pegi.al(+), to_date('3333333','j'))
           and pere.ci           = P_ci
           and pere.competenza  in ('C','A')
           and pere.periodo     >= to_date('01/01/'||to_char(P_d_cong,'yyyy'),'dd/mm/yyyy')
           and pere.periodo     <= P_fin_ela
           and (   nvl(voec.specifica,' ') not like 'RGA%'
               and pere.periodo   = P_fin_ela
              or   nvl(voec.specifica,' ') = 'RGAC'
               and last_day(pere.al) >= P_d_cong
              or  nvl(voec.specifica,' ') like 'RGA%' and nvl(voec.specifica,' ') != 'RGAC'
               and to_number(to_char(pere.al,'yyyy')) >= to_number(to_char(P_d_cong,'yyyy'))
               and periodo = 
--                    (select max(periodo)
--                       from periodi_retributivi
--                      where ci   = pere.ci
--                        and anno = pere.anno
--                        and mese = pere.mese
--                        and periodo <= P_fin_ela
                  (select max(periodo)
                    from periodi_retributivi
                    where ci = P_ci
                      and periodo >= to_date('01/01/'||to_char(pere.al,'yyyy'),'dd/mm/yyyy')
                      and periodo <= P_fin_ela
                      and to_char(al,'mm/yyyy') = to_char(pere.al,'mm/yyyy')
/* modifica del 21/10/2004 */
                      and nvl(tipo,' ') not in ('R','F')
/* fine modifica del 21/10/2004 */
                  )
               )
/* eliminazione 16/03/2004 */
--           and (   pere.periodo     = P_fin_ela
--               and pere.ci          = P_ci
-- /* modifica del 2/7/2002 */
--              or (   nvl(voec.specifica,' ') = 'RGAC'
--                 and pere.ci                 = P_ci
--                 and last_day(to_date(to_char(pere.anno)||'/'||to_char(pere.mese),'yyyy/mm'))
--                     >= P_d_cong
--                or  nvl(voec.specifica,' ') like 'RGA%' and nvl(voec.specifica,' ') != 'RGAC'
--                 and pere.ci    = P_ci
--                 and pere.anno >= to_number(to_char(P_d_cong,'yyyy'))
--                 and pere.anno <= P_anno
-- /* fine modifica del 2/7/2002 */
--                 and pere.periodo =
--                    (select max(periodo)
--                       from periodi_retributivi
--                      where ci   = pere.ci
--                        and anno = pere.anno
--                        and mese = pere.mese
-- /* modifica del 2/7/2002 */
--                        and periodo <= P_fin_ela
-- /* fine modifica del 2/7/2002 */
--                    )
--                  )
--               )
--           and pere.competenza in ('C','A')
--
/* fine modifica del 16/03/2004 */
           and voec.classe     in (select 'R' from dual
                                 union
                                select 'C' from dual
                               )
           and esvo.voce          = voec.codice||''
           and esvo.richiesta      = 'C'
           and pere.gestione    like esvo.gestione
           and pere.contratto   like esvo.contratto
           and pere.trattamento like esvo.trattamento
/* modifica del 26/07/2005 */
           and (   nvl(voec.specifica,' ') not like 'RGA%'
                or P_tipo != 'S'
               )
/* modifica del 26/07/2005 */
           and (  esvo.condizione = 'S'
/* modifica del 16/03/2004 */
		   or (    nvl(voec.specifica,' ') like 'RGA%'
                   and to_number(to_char(pere.al,'yyyy')) != P_anno
                   and (   esvo.condizione in ('S','M','F')
                      or   esvo.condizione like '___%'
                      or   esvo.condizione = 'C'
                       and pere.conguaglio in (2,6)
                       )
                  )
               or (   nvl(voec.specifica,' ') like 'RGA%'
/* eliminazione del 18/05/2004 */
--                   and last_day(P_d_cong) != P_fin_ela
/* fine eliminazione del 18/05/2004 */
                   and to_number(to_char(pere.al,'yyyy')) = P_anno
                   and esvo.condizione = 'C' 
                   and exists
                      (select 'x'
                         from periodi_retributivi
                        where ci       = P_ci
                          and periodo >= to_date('01/01/'||to_char(pere.al,'yyyy'),'dd/mm/yyyy')
                          and periodo <= P_fin_ela
                          and conguaglio in (2,6)
                          and al      >= pere.al
                      )
                  )
               or (    esvo.condizione = 'I'
                   and pere.conguaglio in (1,2,3,5,6,7)
                  or   esvo.condizione = 'RA'
                   and pere.conguaglio in (3,7)
                  )
/* eliminazione 16/03/2004 */
/*
		   or (    nvl(voec.specifica,' ') like 'RGA%'
                   and to_number(to_char(pere.al,'yyyy')) != P_anno
--                 and pere.anno != P_anno
                   and (  esvo.condizione in ('S','M','F')
                       or esvo.condizione like '___%'
                       )
                  )
               or (    nvl(voec.specifica,' ') like 'RGA%'
                   and esvo.condizione = 'C'
                   and pere.conguaglio in (2,6)
                  or
                       esvo.condizione = 'I'
                   and pere.conguaglio in (1,2,3,5,6,7)
                  or   esvo.condizione = 'RA'
                   and pere.conguaglio in (3,7)
                  )
*/
/* modifica del 16/03/2004 */
               or esvo.condizione = 'F' and P_mese = 12 and P_tipo = 'N'
               or P_mens_codice like esvo.condizione
               or substr(esvo.condizione,1,1) = 'P' and
                  substr(esvo.condizione,2,1) = P_periodo
               or esvo.condizione = 'C' and pere.conguaglio in (2,6) -- P_conguaglio = 2
               or esvo.condizione = 'RA' and pere.conguaglio in (3,7) -- P_conguaglio = 3
               or esvo.condizione = 'I' and pere.conguaglio in (1,2,3,5,6,7) -- P_conguaglio in (1,2,3)
               or esvo.condizione = 'N' and P_anno != P_anno_ret
               or esvo.condizione = 'M' and P_tipo  = 'N' and pere.gg_fis != 0
               or esvo.condizione = 'R' and
                  P_tipo         = 'N' and exists
                 (select 'x'
                    from periodi_retributivi
                   where  ci      = P_ci
                     and  periodo = P_fin_ela
                     and  competenza in ('P','C','A')
                     and  servizio = 'Q'
                  group by to_char(al,'yyyymm')
--                  group by anno,mese
                  having
             round( sum( gg_rat
                      * decode(competenza,'A',1,'C',1,0)
                      ) / 30
                 ) + round( sum( gg_rat
                             * decode(competenza,'P',1,0)
                             ) / 30
                         ) >= 1
                 )
/* modifica del 19/06/02 */
         or esvo.condizione = 'RC' and
            P_tipo         = 'N' and 
/* modifica del 21/10/2004 */
            pere.rateo_continuativo = 1
--        and exists (select 'x'
--              from periodi_retributivi
--             where  ci      = P_ci
--               and  periodo = P_fin_ela
--               and  to_char(al,'yyyymm') = to_char(pere.al,'yyyymm')
--               and  competenza in ('C','A')
--               and  servizio = 'Q'
--               and  rateo_continuativo = 1
--               and (competenza != 'A' or competenza = 'A' 
--               and to_char(al,'yyyymm') = to_char(P_fin_ela,'yyyymm'))
--                )
/* fine modifica del 21/10/2004 */
/* fine modifica del 19/06/02 */
               or esvo.condizione = 'G' and exists
                 (select 'x'
                    from periodi_retributivi
                   where  ci      = P_ci
                     and  periodo = P_fin_ela
                     and to_number( to_char(mese)||to_char(anno) )
                                =
                        to_number( to_char(P_fin_ela,'mmyyyy') )
                  having sum(nvl(gg_rid,0)) > 0
                 )
/* modifica del 20/01/99 */
                  and P_tipo           != 'S'
/* fine modifica del 20/01/99 */
               )
        and not exists
             (select 'x'
               from calcoli_contabili
              where voce = esvo.voce
               and sub  = esvo.sub
               and arr is null
               and ci   = P_ci
             )
        group by esvo.voce, esvo.sub
/* modifica del 16/03/2004 */
              , decode
               ( voec.classe
               , 'C', decode
                      ( covo.rapporto
                      , null, decode
                              ( tavo.cod_voce_qta||decode(tavo.val_voce_qta,'V','V',null) 
                              , null, nvl(pegi.al, P_al)  -- 15/06/2004 (pegi.dal)
                                    , null
                              )
                            , nvl(pegi.al, P_al)  -- 15/06/2004 (pegi.dal)
                      )
                    , null
               )
/* fine modifica del 16/03/2004 */
/*
  Per i casi di voci a Calcolo con Rapporto a Giornate:
  Emette una voce a CALCOLO di specie = 'T' per ogni singolo periodo
  di PERIODI RETRIBUTIVI (diviso per tipo di Servizio) per avere la
  valorizzazione della voce ad ogni singola variazione di attributi
  giuridici.
*/
              , decode
               ( voec.classe
               , 'C', decode
                      ( nvl(covo.rapporto,'O')
                      , 'O', null
                           , decode
                             ( substr(voec.specifica,1,3)
                             , 'RGA', null
                                    , decode
                                      ( nvl(voec.specie,'T')
                                      , 'T', pere.servizio
                                           , null
                                      )
                             )
                      )
                    , null
               )
/* modifica del 19/06/2002 */
/* modifica 16/03/2004 */
--            , decode
--            ( voec.classe
--            , 'C', decode
--                 ( voec.specifica
--                 , 'RGA13A', to_char(least(P_al,pere.al),'yyyy')
--                 , 'RGA13M', to_char(least(P_al,pere.al),'yyyymm')
--                 , 'RGA'   , decode
--                             ( nvl(voec.specie,'T')
--                             , 'T', decode
--                                    ( nvl(covo.rapporto,'O')
--                                    , 'O', to_char(least(P_al,pere.al),'yyyymm')
--                                         , to_char(least(P_al,pere.al),'yyyymmdd')
--                                    )
--                             , to_char( least(P_al,pere.al),'yyyy')
--                             )
/* modifica del 2/7/2002 */
--                 , 'RGAC'   , decode
--                             ( nvl(voec.specie,'T')
--                             , 'T', decode
--                                    ( nvl(covo.rapporto,'O')
--                                    , 'O', to_char(least(P_al,pere.al),'yyyymm')
--                                         , to_char(least(P_al,pere.al),'yyyymmdd')
--                                    )
--                             , to_char( least(P_al,pere.al),'yyyy')
--                             )
/* fine modifica del 2/7/2002 */
            , decode
            ( voec.classe
            , 'C', decode
                 ( substr(voec.specifica,1,3)
                 , 'RGA', decode
                          ( voec.specifica
                          , 'RGA13A', to_char(least(P_al,pere.al),'yyyy')
                          , 'RGA13M', to_char(least(P_al,pere.al),'yyyymm')
                          , decode
                            ( nvl(voec.specie,'T')
                            , 'T', decode
                                   ( nvl(covo.rapporto,'O')
                                   , 'O', decode
                                          ( tavo.cod_voce_qta||decode(tavo.val_voce_qta,'V','V',null) 
                                          , null, to_char(least(P_al,pere.al),'yyyymmdd')
                                                , to_char(least(P_al,pere.al),'yyyymm')
                                          )
                                        , to_char(least(P_al,pere.al),'yyyymmdd')
                                   )
                            , to_char( least(P_al,pere.al),'yyyy')
                            )
                          )
                 , decode
                   ( nvl(voec.specie,'T')
                   , 'T', decode
                          ( covo.rapporto
                          , 'O' , decode
                                  ( tavo.cod_voce_qta||decode(tavo.val_voce_qta,'V','V',null) 
                                  , null, to_char(least(P_al,pere.al),'yyyymmdd')
                                        , null
                                  )
                          , null, null
                                , to_char(least(P_al,pere.al),'yyyymmdd')
                          )
                        , null
                   )
                 --, decode
                 --  ( nvl(covo.rapporto,'O')
                 --  , 'O', null
                 --       , decode
                 --         ( nvl(voec.specie,'T')
                 --         , 'T', to_char(least(P_al,pere.al),'yyyymmdd')
                 --              , null
                 --         )
                 --  )
/* fine modifica 16/03/2004 */
                 )
                 , null
                )
/* fine modifica del 19/06/2002 */
        ) LOOP
        P_stp := 'VOCI_ESTRAZIONE-01';
IF CURR.voce like '13A%' THEN NULL;
-- dbms_output.put_line('CMORE5 voce: '||CURR.voce||' AL '||to_char(CURR.al,'dd/mm/yyyy'));
END IF;
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        DECLARE
        D_val_voce_ipn varchar2(1);
        D_cod_voce_ipn varchar2(10);
        D_sub_voce_ipn varchar2(2);
        D_per_rit_ac   number;
        D_per_rit_ap   number;
        D_val_voce_qta varchar2(1);
        BEGIN
          IF curr.classe = 'R' THEN
             --
             --  Emissione voci di Estrazione a RITENUTA
             --
             BEGIN  -- verifica classe Ritenuta su Progressivo
                   --          o con Riduzione 'P' o 'I'
                   -- se contabilizzazione attiva alla data P_al
                   -- se Voce INAIL da emettere
               P_stp := 'VOCI_ESTRAZIONE-02';
               select rivo.val_voce_ipn
                    , rivo.cod_voce_ipn
                    , rivo.sub_voce_ipn
                    , rivo.per_rit_ac
                    , rivo.per_rit_ap
                 into D_val_voce_ipn
                    , D_cod_voce_ipn
                    , D_sub_voce_ipn
                    , D_per_rit_ac
                    , D_per_rit_ap
                 from voci_inail       voin
                    , contabilita_voce covo
                    , ritenute_voce    rivo
                where rivo.voce           = curr.voce
                  and rivo.sub            = curr.sub
                  and P_al between nvl(rivo.dal,to_date(2222222,'j'))
                             and nvl(rivo.al ,to_date(3333333,'j'))
                  and (   rivo.val_voce_ipn = 'P'
                      or nvl(rivo.val_voce_rid,'C') != 'C'
                      )
                  and covo.voce = curr.voce
                  and covo.sub  = curr.sub
                  and P_al
                       between nvl(covo.dal,to_date(2222222,'j'))
                           and nvl(covo.al ,to_date(3333333,'j'))
                  and voin.voce (+) = covo.voce
                  and voin.sub  (+) = covo.sub
                  and nvl( voin.codice
                        , decode( P_data_inail
                               , null, 'x'
                                    , nvl( P_posizione_inail,'x')
                               )
                        ) = decode( P_data_inail
                                 , null, 'x'
                                      , nvl( P_posizione_inail
                                           , nvl(voin.codice,'x')
                                           )
                                 )
               ;
           peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             END;
             BEGIN  -- Inserimento voce a Ritenuta
             IF D_val_voce_ipn = 'P' THEN  -- su imponibile progressivo
               P_stp := 'VOCI_ESTRAZIONE-03';
               insert into calcoli_contabili
               ( ci, voce, sub
               , riferimento
               , competenza
               , input
               , estrazione
               , tar
               , qta
               , ipn_s
               , ipn_p
               , ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
               )
               select P_ci, curr.voce, curr.sub
                    , P_al
                    , max(prco.competenza)
                    , 'C'
                    , 'R'||nvl(curr.estrazione,'I')
                    , nvl(sum(prco.p_imp),0)
                    , 0 qta
                    , 0 ipn_s
                    , nvl(sum(prco.p_ipn_p),0) ipn_p
                    , 0, 0, 0, 0, 0
                 from progressivi_contabili prco
                where prco.voce      = D_cod_voce_ipn
                  and prco.sub       = D_sub_voce_ipn
                  and decode( to_char( nvl( prco.competenza
                                        ,prco.riferimento
                                       )
                                    ,'yyyy')
                           , P_anno, 'C'
                                  , 'P'
                           ) like decode( D_per_rit_ac
                                      , 0, 'P'
                                         , decode( D_per_rit_ap
                                                , 0, 'C'
                                                  , '%'
                                                )
                                      )
                  and prco.ci       = P_ci
                  and prco.anno      = P_anno
                  and prco.mese      = P_mese
                  and prco.mensilita = P_mensilita
               ;
           peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             ELSE  -- voce con riduzione di importo
               P_stp := 'VOCI_ESTRAZIONE-04';
               insert into calcoli_contabili
               ( ci, voce, sub
               , riferimento
               , input
               , estrazione
               , tar
               , qta
               , ipn_s
               , ipn_p
               , ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
               )
               values( P_ci, curr.voce, curr.sub
                    , P_al
                    , 'C'
                    , 'R'||nvl(curr.estrazione,'I')
                    , 0
                    , 0
                    , 0
                    , 0
                    , 0, 0, 0, 0, 0
                    )
               ;
           peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             END IF;
             END;
          ELSE
             --
             --  Emissione voci di Estrazione a CALCOLO
             --
             BEGIN  -- Verifica esistenza voce quantita`
                   -- per classe Calcolo
               P_stp := 'VOCI_ESTRAZIONE-05';
               select val_voce_qta
                 into D_val_voce_qta
                 from tariffe_voce tavo
                where voce = curr.voce
                  and curr.al between nvl(dal,to_date(2222222,'j'))
                                and nvl(al ,to_date(3333333,'j'))
                  and (   nvl(val_voce_qta,'V') = 'V'
/* modifica 16/03/2004 */
                   -- or (val_voce_qta = 'D' and
                   --     cod_voce_qta is null)
                      or cod_voce_qta is null
/* fine modifica 16/03/2004 */
                      or exists
                        (select 'x'
                           from voci_economiche
                          where codice   = tavo.cod_voce_qta
                            and classe  in('C','I','R','T')
                        )
                      or exists
                        (select 'x'
                           from calcoli_contabili
                          where voce     = tavo.cod_voce_qta
                            and sub      = tavo.sub_voce_qta
/* modifica del 15/12/2004 */
                            and ci+0       = P_ci
/* fine modifica del 15/12/2004 */
                        )
                      or val_voce_qta in ('P','M','D') and
                         exists
                        (select 'x'
                           from progressivi_contabili
                          where voce = tavo.cod_voce_qta
                            and sub  = tavo.sub_voce_qta
                            and ci   = P_ci
                            and anno = P_anno
                            and mese = P_mese
                            and mensilita = P_mensilita
                        )
                      )
               ;
           peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             END;
             BEGIN  -- Inserimento voce a Calcolo
                   -- se contabilizzazione attiva
   IF CURR.voce = '13AMNDR' THEN NULL;
-- dbms_output.put_line('Inserimento voce se rapporto giorni (?): '||CURR.voce||' rif. '||CURR.al);
-- dbms_output.put_line('CURR AL '||CURR.al||' P_cong_ind '||P_cong_ind||' P_d_cong '||p_d_cong);
   END IF;
               P_stp := 'VOCI_ESTRAZIONE-06';
               insert into calcoli_contabili
               ( ci, voce, sub
               , riferimento
               , arr
               , input
               , estrazione
               )
               select P_ci, curr.voce, curr.sub
                    , curr.al  -- Emette una Voce per ogni data di PERE
                             -- se Specie = 'T' e Rapporto a Giorni
                    , decode
                      ( to_number(to_char(to_date(curr.al),'yyyy'))
                      , P_anno, decode
                              ( curr.specifica
                              , 'RGA13M', null
                                , decode
                                  ( to_number(to_char(to_date(curr.al),'mm'))
                                  , P_mese, to_char(null)
                                         ,'C'
                                  )
                              )
                             , decode(P_cong_ind,2,'C',4,'C','P')
                      )
                    , decode
                      ( substr(curr.specifica,1,3)
                      , 'RGA', 'C'
                             /* Attivati a 'C' per evitare
                                inibizione emissione in negativo
                                dello step successivo.
                                Rimesso ad 'A' in valorizzazione.
                             */
                            , decode( nvl(rapporto,'O')
                                   , 'O', 'A'
                                       , lower(curr.servizio)
                                   )
                      )
                    , 'C'||nvl(curr.estrazione,'B')
                 from contabilita_voce
                where voce = curr.voce
                  and sub  = curr.sub
                  and curr.al between nvl(dal,to_date(2222222,'j'))
                                and nvl(al ,to_date(3333333,'j'))
                  and not exists
                     (select 'x'
                      from periodi_retributivi pere
                         , calcoli_contabili caco
                      where caco.ci   = P_ci
                       and caco.voce = curr.voce
                       and caco.sub  = curr.sub
/* modifica 16/03/2004 */
                        -- and upper (input) != 'A'	
                        and upper (input) not in ('A', 'C')
/* fine modifica 16/03/2004 */
                        and nvl(caco.arr,' ') =
                               decode
                               ( to_number(to_char(curr.al,'yyyy'))
                               , P_anno, decode
                                         ( curr.specifica
                                         , 'RGA13M', ' '
                                           , decode
                                             ( to_number(to_char(curr.al,'mm'))
                                             , P_mese, ' '
                                                     ,'C'
                                             )
                                         )
                                       , decode(P_cong_ind,2,'C',4,'C','P')
                               )
                       and caco.riferimento
                              between pere.dal
                                  and pere.al
                       and pere.ci         = P_ci
                       and pere.competenza in ('P','C','A')
/* modifica 16/03/2004 */
                       -- and pere.periodo     = P_fin_ela
 --                      and (       nvl(curr.specifica,' ') not like 'RGA%'
 --                              and pere.periodo      = P_fin_ela
 --                           or     nvl(curr.specifica,' ') = 'RGAC'
 --                              and last_day
 --                                  (to_date(to_char(pere.anno)||'/'||to_char(pere.mese),'yyyy/mm'))
 --                                  >= P_d_cong
 --                           or     nvl(curr.specifica,' ') like 'RGA%' and nvl(curr.specifica,' ') != 'RGAC'
 --                              and pere.anno >= to_number(to_char(P_d_cong,'yyyy'))
 --                              and pere.anno <= P_anno
 --                          )
                       and pere.periodo >= to_date('01/01/'||to_char(curr.al,'yyyy'),'dd/mm/yyyy')
                       and pere.periodo <= P_fin_ela
                       and (   nvl(curr.specifica,' ') not like 'RGA%'
                           and pere.periodo = P_fin_ela
                          or   nvl(curr.specifica,' ')     like 'RGA%'
                           and to_number(to_char(pere.al,'yyyy')) >= to_number(to_char(P_d_cong,'yyyy'))
                           )
/* fine modifica 16/03/2004 */
/* modifica 16/03/2004*/
                       -- Se esiste una sola variabile comunicata per Specifica 'RGA13M'
                       -- non estrae nessuna voce (indipendentemente dalla data di riferimento)
                       -- 
                       --and exists
                       and 
                       (   curr.specifica = 'RGA13M'
                       or exists
/* fine modifica 16/03/2004 */
                          (select 'x'
                             from periodi_retributivi
                            where ci          = P_ci
                              and competenza in ('P','C','A')
/* modifica 16/03/2004 */
                              -- and periodo    = P_fin_ela
                              and pere.periodo >= to_date('01/01/'||to_char(curr.al,'yyyy'),'dd/mm/yyyy')
                              and pere.periodo <= P_fin_ela
                              and (   nvl(curr.specifica,' ') not like 'RGA%'
                                  and pere.periodo = P_fin_ela
                                 or   nvl(curr.specifica,' ')     like 'RGA%'
                                  and to_number(to_char(pere.al,'yyyy')) >= to_number(to_char(P_d_cong,'yyyy'))
                                  )
/* fine modifica 16/03/2004 */
                             and curr.al between pere.dal
                                           and pere.al
                             and greatest
                                 ( dal
                                 , to_date
                                   (to_char(pere.al,'yyyymm'),'yyyymm')
                                 )  <= pere.al
                             and al >=
                                 greatest
                                 ( pere.dal
                                 , to_date
                                   (to_char(pere.al,'yyyymm'),'yyyymm')
                                 )
                          )
                       )
                     )
               ;
           peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             END;
/* modifica 16/03/2004 */
--             IF  substr(curr.specifica,1,3) = 'RGA' and P_cong_ind in (1,2,3,4) THEN
             IF  substr(curr.specifica,1,3) = 'RGA' and curr.val_voce_qta != 'D' THEN
/* fine modifica 16/03/2004 */
               BEGIN  -- Emette in negativo movimenti precedenti.
                      -- Attivo una sola volta per ogni voce
                      --  in quanto verifica non esistenza
                      --  stessa voce con INPUT = 'A'
                  P_stp := 'VOCI_ESTRAZIONE-06.1';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , competenza
        , arr
        , input
        , estrazione
        , tar
        , qta
        , imp
        , ipn_eap
        )
select
 P_ci, moco.voce, moco.sub
, moco.riferimento
, moco.competenza  -- modifica 16/03/2004
/* modifica del 12/06/2006 */
--, decode( moco.anno
, decode( to_char(moco.riferimento,'yyyy')
/* fine modifica del 12/06/2006 */
       , P_anno, nvl(moco.arr, 'C')
              , decode(P_cong_ind,2,'C',4,'C','P')
       )
, decode( sign(moco.riferimento - P_d_cong)
       , 1, 'a'
         , 'A'
       )
, 'C'||nvl(curr.estrazione,'B')
, moco.tar  -- * -1 non emettiamo la tariffa in negativo per ottenere una informazione congruente
, moco.qta * -1
, moco.imp * -1
, moco.ipn_eap * -1
 from movimenti_contabili moco
/* modifica del 15/12/2004 */
-- where moco.voce        = curr.voce
--   and moco.sub         = curr.sub
/* fine modifica del 15/12/2004 */
where to_char(moco.riferimento,'yyyy') >= to_char(P_d_cong,'yyyy')
  and nvl(moco.tar,0) != 0
/* modifica del 15/12/2004 */
  and (moco.anno, moco.mese+0, moco.ci, moco.voce, moco.sub) in
     (select distinct anno, mese, ci, curr.voce, curr.sub
/* fine modifica del 15/12/2004 */
        from movimenti_fiscali
       where ci    = P_ci
/*
        and anno >= to_number(to_char(P_d_cong,'yyyy'))
        and last_day
            (to_date(to_char(anno)||'/'||to_char(mese),'yyyy/mm'))
                >= P_d_cong
        and last_day
            (to_date(to_char(anno)||'/'||to_char(mese),'yyyy/mm'))
                <= P_fin_ela
*/
        and anno >= to_number(to_char(P_d_cong,'yyyy'))
        and last_day(to_date(to_char(anno)||'/'||to_char(mese),'yyyy/mm'))
            <= P_fin_ela
     )
  and not exists
        (select 'x'
           from calcoli_contabili
          where voce = moco.voce
            and sub  = moco.sub
            and nvl(arr,' ') =
/* modifica del 12/06/2006 */
--               decode( moco.anno
                 decode( to_char(moco.riferimento,'yyyy')
/* fine modifica del 12/06/2006 */
                     , P_anno, nvl(moco.arr, 'C')
                            , decode(P_cong_ind,2,'C',4,'C','P')
                     )
            and upper(input) not in ('R','C')
            and ci   = P_ci
        )
     ;
     peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
               END;
             END IF;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN  -- Voce da non estrarre
             null;
        END;
     END LOOP;
     BEGIN  -- Emette in negativo movimenti precedenti
            -- se non verifica esistenza
            -- stessa voce con INPUT = 'A'
            -- per specifica 'RGA%' con estrazione 'R' 'RC' 'G'
        P_stp := 'VOCI_ESTRAZIONE-06.2';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , competenza
        , arr
        , input
        , estrazione
        , tar
        , qta
        , imp
        , ipn_eap
        )
select
 P_ci, moco.voce, moco.sub
, moco.riferimento
, moco.competenza -- modifica 16/03/2004
, decode( moco.anno
       , P_anno, nvl(moco.arr, 'C')
              , decode(P_cong_ind,2,'C',4,'C','P')
       )
, decode( sign(moco.riferimento - P_d_cong)
       , 1, 'a'
         , 'A'
       )
, 'C'||nvl(voec.estrazione,'B')
, moco.tar --  * -1 non emettiamo la tariffa in negativo per ottenere una informazione congruente
, moco.qta * -1
, moco.imp * -1
, moco.ipn_eap * -1
 from voci_economiche     voec
    , movimenti_contabili moco
	, movimenti_fiscali   mofi
 where voec.specifica like 'RGA%'
   and voec.classe in (select 'R' from dual
                        union
                       select 'C' from dual
                      )
   and voec.codice = moco.voce
   and moco.anno = mofi.anno
/* modifica del 15/12/2004 */
   and moco.mese+0 = mofi.mese
/* fine modifica del 15/12/2004 */
   and moco.ci   = mofi.ci
   and mofi.ci    = P_ci
   and mofi.anno >= to_number(to_char(P_d_cong,'yyyy'))
   and last_day(to_date(to_char(mofi.anno)||'/'||to_char(mofi.mese),'yyyy/mm'))
       <= P_fin_ela
   and (nvl(voec.specifica,' ') = 'RGAC'
        and last_day(to_date(to_char(mofi.anno)||'/'||to_char(mofi.mese),'yyyy/mm'))
            >= P_d_cong
        or nvl(voec.specifica,' ') != 'RGAC'
        )
   and exists (select 'x'
         from contabilita_voce    covo
            , estrazioni_voce     esvo
        where covo.voce = esvo.voce||''
          and covo.sub  = esvo.sub
		  and moco.voce = esvo.voce
		  and moco.sub  = esvo.sub
          and esvo.voce          = covo.voce
          and esvo.richiesta      = 'C'
          and (esvo.condizione in ('R','RC')
               and P_tipo         = 'N'
              or
               esvo.condizione = 'G'
               and P_tipo           != 'S'
              )
       )
   and to_char(moco.riferimento,'yyyy') >= to_char(P_d_cong,'yyyy')
   and nvl(moco.tar,0) != 0
   and not exists
         (select 'x'
            from calcoli_contabili
           where voce = moco.voce
             and sub  = moco.sub
             and nvl(arr,' ') =
                decode( moco.anno
                      , P_anno, nvl(moco.arr, 'C')
                             , decode(P_cong_ind,2,'C',4,'C','P')
                      )
             and upper(input) not in ('R','C')
             and ci   = P_ci
         )
     ;
     peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
    END;
  END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
