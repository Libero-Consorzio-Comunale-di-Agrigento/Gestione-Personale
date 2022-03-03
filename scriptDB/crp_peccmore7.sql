CREATE OR REPLACE PACKAGE peccmore7 IS
/******************************************************************************
 NOME:        Peccmore7
 DESCRIZIONE: Calcolo del Netto e determinazione delle Tariffe
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    16/03/2004 MF     Attivazione Nuova 13A con specifica RGA
 2    18/05/2004 MF     Rettifica condizione sui gg_fis nel caso di specifica RGA%.
                        Rettifica trattamento dei periodi < di anno/mese della
                        data di riferimento della voce in caso di tariffe con
                        tipo riferimento = 'P'.
                        Trattamento dei soli periodi competenza C e A (solo nel
                        rapporto ad ore) in caso di specifica RGA% per tariffe
                        con tipo riferimento = 'P'. 
 3    13/06/2004 MF     Diversa determinazione della tariffa per RGA13M.
 4    05/07/2004 MF     Calcolo Tariffa su voci di Movimenti Contabili con riferimento
                        della voce estratta o mese di riferimento indicato.
                        Introduzione richiami a Package PECCMORE_TARIFFA.
******************************************************************************/

revisione varchar2(30) := '4 del 05/07/2004';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE voci_netto
(
 p_ci      number
,p_al      date  --Data di Termine o Fine Mese
,p_anno    number
,p_mese    number
,p_mensilita   VARCHAR2
,p_fin_ela   date
,p_tipo    VARCHAR2
,p_istituto    VARCHAR2
,p_sportello   VARCHAR2
,p_netto_neg IN OUT VARCHAR2
--Voci Parametriche
, P_comp     VARCHAR2
, P_trat     VARCHAR2
, P_netto    VARCHAR2
--Parametri per Trace
,p_trc  IN   number   --Tipo di Trace
,p_prn  IN   number   --Numero di Prenotazione elaborazione
,p_pas  IN   number   --Numero di Passo procedurale
,p_prs  IN OUT number   --Numero progressivo di Segnalazione
,p_stp  IN OUT VARCHAR2   --Step elaborato
,p_tim  IN OUT VARCHAR2   --Time impiegato in secondi
);
  PROCEDURE voci_calc_tar
(
 p_ci    number
,p_al    date  --Data di Termine o Fine Mese
,p_anno    number
,p_mese    number
,p_mensilita  VARCHAR2
,p_fin_ela   date
,p_voce    VARCHAR2
,p_sub     VARCHAR2
,p_rif     date  --data di riferimento della voce
,p_tariffa IN OUT number
,p_tar_eff IN OUT number  --Tariffa per Imponibili Effettivi (ipn_eap)
,p_rif_tar IN OUT date  -- Data Riferimento calcolo Tariffa /* modifica 16/03/2004 */
,p_ore_mensili  number
,p_div_orario   number
,p_ore_gg    number
,p_gg_lavoro  number
,p_ore_lavoro   number
,p_specie    VARCHAR2
,p_input   VARCHAR2
,p_specifica  VARCHAR2
,p_base_ratei   VARCHAR2
--Parametri per Trace
,p_trc  IN   number   --Tipo di Trace
,p_prn  IN   number   --Numero di Prenotazione elaborazione
,p_pas  IN   number   --Numero di Passo procedurale
,p_prs  IN OUT number   --Numero progressivo di Segnalazione
,p_stp  IN OUT VARCHAR2   --Step elaborato
,p_tim  IN OUT VARCHAR2   --Time impiegato in secondi
) ;
END;
/

CREATE OR REPLACE PACKAGE BODY peccmore7 IS
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

PROCEDURE voci_netto
/******************************************************************************
 NOME:        VOCI_NETTO
 DESCRIZIONE: Valorizzazione Voci di Arrotondamento e Netto
 ANNOTAZIONI: -
******************************************************************************/
(
 p_ci      number
,p_al      date  --Data di Termine o Fine Mese
,p_anno    number
,p_mese    number
,p_mensilita   VARCHAR2
,p_fin_ela   date
,p_tipo    VARCHAR2
,p_istituto    VARCHAR2
,p_sportello   VARCHAR2
,p_netto_neg IN OUT VARCHAR2
--Voci Parametriche
, P_comp     VARCHAR2
, P_trat     VARCHAR2
, P_netto    VARCHAR2
--Parametri per Trace
,p_trc  IN   number   --Tipo di Trace
,p_prn  IN   number   --Numero di Prenotazione elaborazione
,p_pas  IN   number   --Numero di Passo procedurale
,p_prs  IN OUT number   --Numero progressivo di Segnalazione
,p_stp  IN OUT VARCHAR2   --Step elaborato
,p_tim  IN OUT VARCHAR2   --Time impiegato in secondi
) IS
D_comp  number := 0;
D_trat  number := 0;
D_netto number := 0;
D_non_soggette    NUMBER;
D_deceduto        VARCHAR(1);
BEGIN
  BEGIN
    select 'x'
      into D_deceduto
      from dual
     where exists (select 'x'
                     from rapporti_diversi
                    where ci_erede = P_ci
                      and rilevanza = 'E'
                   )
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_deceduto := null;
  END;
  IF D_deceduto is not null THEN
    BEGIN
    P_stp := 'VOCI_NETTO-00';
    select NVL( SUM( nvl(caco.imp,0)
                * DECODE(covo.fiscale,'N',
                        decode(voec.tipo,'F',0,'Q',1,'T',1,'C',1),'E',1,'G',1,'T',1,'D',1,0)
                        )
                , 0 ) /* non_soggette */
     into D_NON_SOGGETTE
     FROM VOCI_ECONOMICHE voec
         , CONTABILITA_VOCE covo
         , CALCOLI_CONTABILI caco
     WHERE nvl(voec.specifica,' ')
           not in ('SOM_ERE','SOM_ERE_LI','SOM_ERE_RL','SOM_ERE_NS'
                  ,'SOM_ERE_CO','ADD_ERE_C','ADD_ERE_R','ADD_ERE_P'
                  )
       AND nvl(voec.automatismo,' ')
           not in ('IRPEF_LIQ','IRPEF_CON'
                  ,'ADD_COMU','ADD_COMUS'
                  ,'ADD_PROV','ADD_PROVS'
                  ,'ADD_IRPEF','ADD_IRPEFS'
                  )
       AND voec.codice = covo.voce
       AND covo.voce = caco.voce||''
       AND covo.sub  = caco.sub
       AND caco.riferimento
           BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
               AND NVL(covo.al ,TO_DATE(3333333,'j'))
       AND caco.ci = P_ci
    ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_NON_SOGGETTE :=0;
    END;
    BEGIN  -- Estrazione voci Somme Deceduto
      IF  nvl(D_NON_SOGGETTE,0) != 0 THEN
        P_stp := 'VOCI_NETTO-00.1';
        insert into calcoli_contabili
             ( ci, voce, sub
             , riferimento
             , arr
             , input
             , estrazione
             , imp
             )
        select P_ci, voec.codice, '*'
             , P_al
             , ''
             , 'C'
             , voec.classe||voec.estrazione
             ,  D_NON_SOGGETTE * -1
          from contabilita_voce    covo
             , voci_economiche     voec
         where voec.specifica     =  'SOM_ERE_NS'
           and covo.voce          = voec.codice||''
           and covo.sub           = '*'
           and P_fin_ela    between nvl(covo.dal,to_date(2222222,'j'))
                                and nvl(covo.al ,to_date(3333333,'j'))
           and not exists
              (select 'x'
                 from calcoli_contabili
                where voce = voec.codice
                  and sub  = '*'
                  and arr is null
                  and ci   = P_ci
              )
        ;
      END IF;
     END;
    END IF;
  BEGIN  --Emissione della voce di ARROTONDAMENTO ATTUALE
   P_stp := 'VOCI_NETTO-01';
   insert into calcoli_contabili
   ( ci, voce, sub
   , riferimento
   , input
   , estrazione
   , imp
   )
   select P_ci, voec.codice, '*'
   , P_al
   , 'C'
   , 'N'
   , decode( sign(sum(caco.imp))
      , -1, decode
        ( max(voec.automatismo)
        , 'ARR_ATT_N' , sum(caco.imp) * -1
        , 'ARR_ATT_SN', sum(caco.imp) * -1
            , decode
            ( sign( sum(caco.imp)
               + max(spor.arrotondamento)
               )
            , -1, 0
             , sum(caco.imp) * -1
            )
          )
        , trunc( sum(caco.imp)
          / max(spor.arrotondamento)
          + decode(sign(max(spor.arrotondamento))
           ,1,.9999
             ,0)
          )
        * max(spor.arrotondamento)
        - sum(caco.imp)
      )
   from voci_economiche voec
   , voci_economiche voecc
   , sportelli spor
   , calcoli_contabili caco
  where voec.automatismo in ( 'ARR_ATT'
           , 'ARR_ATT_N'
           , 'ARR_ATT_S'
           , 'ARR_ATT_SN'
           )
    and nvl(spor.arrotondamento,0) != 0
    and spor.istituto  = P_istituto
    and spor.sportello = P_sportello
    and voecc.tipo  in ( 'C', 'T' )
    and voecc.codice = caco.voce||''
    and (   voec.automatismo in ( 'ARR_ATT_S', 'ARR_ATT_SN' )
    or ( P_mese != 12 or P_tipo != 'N') and
      1 != (select nvl(max(decode( conguaglio
              , 5, 1
               ,conguaglio
              )),0)
         from periodi_retributivi
        where ci  = P_ci
        and periodo = P_fin_ela
       )
     )
    and   1 >= (select nvl(max(decode( conguaglio
              , 4, 0
              , 5, 1
               , conguaglio
              )),0)
        from periodi_retributivi
       where ci  = P_ci
        and periodo = P_fin_ela
       )
    and caco.ci = P_ci
   group by voec.codice
   ;
   peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Aggiornamento della voce di TOTALE COMPETENZE
    --TOTALE TRATTENUTE
    --NETTO CEDOLINO
   P_stp := 'VOCI_NETTO-02';
   BEGIN
    select sum( decode( voec.tipo, 'C', caco.imp, 0 ) )
    , sum( decode( voec.tipo, 'T', caco.imp, 0 ) )
    , sum( caco.imp )
   into D_comp
    , D_trat
    , D_netto
   from voci_economiche voec
    , calcoli_contabili caco
    where voec.tipo  in ('C','T')
    and voec.codice = caco.voce||''
    and caco.ci   = P_ci
    ;
    peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   EXCEPTION
    WHEN OTHERS THEN null;
   END;
   IF D_netto < 0 THEN
    P_netto_neg := 'SI';
   ELSIF
    D_netto = 0
   OR D_comp  = 0 THEN
    P_netto_neg := 'NN';
   END IF;
   BEGIN
    P_stp := 'VOCI_NETTO-03';
    update calcoli_contabili x
    set imp = decode( x.voce
        , P_comp , D_comp
        , P_trat , D_trat
        , P_netto, D_netto
        )
    where ci  = P_ci
    and voce in ( P_comp, P_trat, P_netto )
    ;
   END;
   peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/* modifica del 24/06/99 */
   BEGIN  --Emissione della voce di NETTO in EURO
    P_stp := 'VOCI_NETTO-04';
    insert into calcoli_contabili
    ( ci, voce, sub
    , riferimento
    , input
    , estrazione
    , tar
    , imp
    )
    select P_ci
    , voec.codice
    , '*'
    , P_al
    , 'C'
    , 'N'
    , round(caco.imp/to_number(substr(note,1,7)),2)
    , round(caco.imp/to_number(substr(note,1,7)),2)
   from calcoli_contabili caco
    , voci_economiche voec
    where caco.voce = (select codice from voci_economiche
          where automatismo = 'NETTO')
    and caco.ci = P_ci
    and voec.specifica = 'NETTO_EURO'
    ;
   END;
   peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/* fine modifica del 24/06/99 */
  END;
  peccmore.VOCI_TOTALE  --Totalizzazione delle Voci di Arrotondamento
   ( P_ci, P_al, P_fin_ela, P_tipo, 'N'
    , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
   );
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
   RAISE;
  WHEN OTHERS THEN
   peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
   RAISE FORM_TRIGGER_FAILURE;
END;

PROCEDURE voci_calc_tar
/******************************************************************************
 NOME:        VOCI_CALC_TAR
 DESCRIZIONE: Calcolo della Tariffa delle Voci a Quantita` o a Calcolo
 ANNOTAZIONI: -
******************************************************************************/
(
 p_ci  number
,p_al  date  --Data di Termine o Fine Mese
,p_anno  number
,p_mese  number
,p_mensilita  VARCHAR2
,p_fin_ela date
,p_voce  VARCHAR2
,p_sub   VARCHAR2
,p_rif   date  --data di riferimento della voce
,p_tariffa IN OUT number
,p_tar_eff IN OUT number  -- Tariffa per Imponibili Effettivi (ipn_eap)
,p_rif_tar IN OUT date  -- Data Riferimento calcolo Tariffa /* modifica 16/03/2004 */
,p_ore_mensili  number
,p_div_orario number
,p_ore_gg  number
,p_gg_lavoro  number
,p_ore_lavoro number
,p_specie  VARCHAR2
,p_input VARCHAR2
,p_specifica  VARCHAR2
,p_base_ratei VARCHAR2
--Parametri per Trace
,p_trc  IN number --Tipo di Trace
,p_prn  IN number --Numero di Prenotazione elaborazione
,p_pas  IN number --Numero di Passo procedurale
,p_prs  IN OUT number --Numero progressivo di Segnalazione
,p_stp  IN OUT VARCHAR2 --Step elaborato
,p_tim  IN OUT VARCHAR2 --Time impiegato in secondi
) IS
D_rif_tar date;  --Riferimento per calcolo valore Tariffa
-- w_dummy varchar2(1); /* modifica del 31/03/2004 */
/* modifica del 16/03/2004 */
-- Determinazione del tipo di riferimento per la valorizzazione della voce
-- A    = Annuale
-- M    = Mansile
-- P    = Periodo
-- null = Globale
--
D_tipo_riferimento varchar2(1);
/* fine modifica del 16/03/2004 */

BEGIN
   D_rif_tar := least(P_al,P_rif);
/* modifica del 16/03/2004 */
   IF P_specifica = 'RGA13M' THEN
/* modifica del 13/06/2004 */
      -- Determinazione della data di Riferimento Tariffa sulla base del Rapporto di Lavoro
      select least( nvl(max(pegi.al), P_al)
                  , P_fin_ela
                  , to_date('31/12/'||to_char(D_rif_tar,'yyyy'),'dd/mm/yyyy')
                  )
        into D_rif_tar
        from periodi_giuridici pegi
       where pegi.ci         = P_ci
         and pegi.rilevanza  = 'P'
         and D_rif_tar between nvl(pegi.dal, to_date('2222222','j'))
                           and nvl(pegi.al,  to_date('3333333','j'))
      ;
/* fine modifica del 13/06/2004 */
   END IF;
/* modifica del 16/03/2004 */
   -- Salva la Data di Riferimento per memorizzarla su Calcoli Contabili in uscita dalla procedure
   P_rif_tar := D_rif_tar;
/* fine modifica del 16/03/2004 */ 

/* modifica 05/07/2004 */
   <<tratta_voce>>
   DECLARE
   D_rapporto     varchar2(1);
   D_decimali     number(1);
   D_val_voce_qta varchar2(1);
   D_cod_voce_qta varchar2(10);
   D_is_tar_mov   number;      -- Indicatore Tariffa su movimenti del mese (non usato)
   BEGIN  --Trattamento voce a Tariffa
      PECCMORE_TARIFFA.CALCOLO( P_ci 
                              , P_al, P_anno, P_mese, P_mensilita, P_fin_ela 
                              , P_voce, P_sub, P_rif, D_rif_tar 
                              , P_tariffa, D_is_tar_mov
                              , P_ore_mensili, P_div_orario, P_ore_gg, P_gg_lavoro, P_ore_lavoro
                              , P_input, P_stp
                              );
      IF P_tariffa != 0 THEN 
         BEGIN  --Preleva dati di Assestamento Tariffa
            P_stp := 'VOCI_CALC_TAR-01';
            select covo.rapporto
                 , decode( nvl(tavo.arrotonda,0)
                         , 0, tavo.decimali
                            , decode( tavo.decimali, 0, 0, null )
                         ) decimali
                 , tavo.val_voce_qta
                 , tavo.cod_voce_qta
              into D_rapporto
                 , D_decimali
                 , D_val_voce_qta
                 , D_cod_voce_qta
              from contabilita_voce covo
                 , tariffe_voce tavo
             where covo.voce = P_voce
               and covo.sub  = P_sub
               and P_rif between nvl(covo.dal,to_date(2222222,'j'))
                    and nvl(covo.al ,to_date(3333333,'j'))
               and tavo.voce = P_voce
               and P_rif between tavo.dal
                         and nvl(tavo.al ,to_date(3333333,'j'))
            ;
         END;
-- dbms_output.put_line('CMORE7: voce '||P_voce||' tar. '||to_char(P_tariffa)||' 7 '||to_char(p_rif));
/* fine modifica 05/07/2004 */

/* modifica del 16/03/2004 */
         D_tipo_riferimento := PECCMORE_TARIFFA.TIPO_RIFERIMENTO
                                               ( D_rapporto
                                               , P_specie, P_specifica
                                               , D_val_voce_qta, D_cod_voce_qta
                                               );
/* fine modifica del 16/03/2004 */
         IF D_rapporto is null
      -- AND nvl(P_specifica,' ') not in ('RGA13M','RGA13A') THEN -- /* modifica del 16/03/2004 */
         THEN
            P_tariffa := round( P_tariffa, nvl(D_decimali,0) );
            P_tar_eff := null;
         ELSIF D_rapporto = 'O' THEN
            BEGIN  -- Rapporto Tariffa ad ORE
                   -- Estratta sempre come unica voce alla max data AL
               P_stp := 'VOCI_CALC_TAR-02';
               PECCMORE_TARIFFA.RAPPORTO_ORE
                               ( P_ci
                               , P_fin_ela
                               , P_rif, P_tariffa, P_tar_eff
                               , P_gg_lavoro, P_base_ratei
                               , D_rapporto, D_decimali, P_specifica, D_tipo_riferimento 
                               , P_input
                               );
            END;
         ELSIF P_specifica = 'RGA13M' THEN
            BEGIN -- Se D_rapporto = 'R' 
                  --    Rapporto Tariffa sul Periodo effettivo per Specifica 'RGA13M'
                  --    calcolato sulla Base dei giorni "gg_rat".
                  -- altrimenti
                  --    Rapporto Tariffa sul Periodo effettivo per Specifica 'RGA13M'
                  --    calcolato con ricalcolo sui giorni contrattuali.
               P_stp := 'VOCI_CALC_TAR-03';
               PECCMORE_TARIFFA.RGA13M
                               ( P_ci
                               , P_fin_ela
                               , P_rif, P_tariffa, P_tar_eff
                               , P_gg_lavoro, P_base_ratei
                               , D_rapporto, D_decimali, P_specifica, D_tipo_riferimento 
                               , P_input
                               );
            END;
         ELSIF P_specifica = 'RGA13A' THEN
            BEGIN  -- Rapporto Tariffa sul Periodo effettivo per specifica "RGA13A"
               P_stp := 'VOCI_CALC_TAR-04';
               PECCMORE_TARIFFA.RGA13A
                               ( P_ci
                               , P_fin_ela
                               , P_rif, P_tariffa, P_tar_eff
                               , P_gg_lavoro, P_base_ratei
                               , D_rapporto, D_decimali, P_specifica, D_tipo_riferimento 
                               , P_input
                               );
            END;
         ELSE
            BEGIN  -- Rapporto Tariffa sul Periodo effettivo
                   -- o sui periodi dell'anno in caso di voce
                   -- a calcolo non di Specie = 'T'
               P_stp := 'VOCI_CALC_TAR-05';
               PECCMORE_TARIFFA.RAPPORTO_PERIODO
                               ( P_ci
                               , P_fin_ela
                               , P_rif, P_tariffa, P_tar_eff
                               , P_gg_lavoro, P_base_ratei
                               , D_rapporto, D_decimali, P_specifica, D_tipo_riferimento 
                               , P_input
                               );
            END;
         END IF;
      END IF;
-- dbms_output.put_line('CMORE7: voce '||P_voce||' tar. '||to_char(P_tariffa)||' '||to_char(p_rif));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         P_tariffa := 0;
         P_tar_eff := null;
   END tratta_voce;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN RAISE;
   WHEN OTHERS THEN
      peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
      RAISE FORM_TRIGGER_FAILURE;
END; -- Procedure voci_calc_tar

END; -- Package PECCMORE7
/

