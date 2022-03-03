CREATE OR REPLACE PACKAGE peccmore6 IS
/******************************************************************************
 NOME:        Peccmore6
 DESCRIZIONE: Determinazione Voci a Quantità e a Calcolo
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    16/03/2004 MF     Attivazione Nuova 13A con specifica RGA
 2    28/04/2004 MF     Estrazione anche del TIPO delibera.
 3    05/07/2004 MF     Limitazione periodo retribuito nel caso di tipo_rife-
                        rimento = 'G' su estrazione giorni
 4    26/10/2004 AM     Estrazione della qta per le voci di 13ma in caso di 
                        maternità post-cessazione
 5    30/11/2004 AM     In caso di estrazione dei gg_365 per il mese di febbraio
                        limita a 28 il nr. di gg trattati (per evitare di conteggiare
                        366 gg in un anno)
 5.1  15/12/2004 AM     modifiche per miglior utilizzo degli indici
 6    28/06/2005  CB    Codice SIOPE
 6.1  28/10/2005  NN    Corretto calcolo qta x voci con specifica RGA% e cod_voce.
******************************************************************************/

revisione varchar2(30) := '6.1 del 28/10/2005';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE voci_calc_qta
(
 p_ci        number
,p_al        date    --Data di Termine o Fine Mese
,p_anno       number
,p_mese       number
,p_mensilita  VARCHAR2
,p_fin_ela    date
,p_estrazione VARCHAR2
,p_voce       VARCHAR2
,p_sub       VARCHAR2
,p_rif       date
,p_qta_voce IN OUT number
,p_ore_mensili     number
,p_div_orario      number
,p_ore_gg          number
,p_gg_lavoro       number
,p_ore_lavoro      number
,p_specie          varchar2
,p_input           varchar2
,p_specifica       varchar2
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
);
PROCEDURE voci_calc_val
(
 p_ci           number
,p_al           date    --Data di Termine o Fine Mese
,p_anno         number
,p_mese         number
,p_mensilita     VARCHAR2
,p_fin_ela       date
,p_estrazione    VARCHAR2
,p_numero_voci IN OUT number --Numero Voci presenti
,p_base_ratei    VARCHAR2
--Parametri per Trace
,p_trc    IN     number      --Tipo di Trace
,p_prn    IN     number      --Numero di Prenotazione elaborazione
,p_pas    IN     number      --Numero di Passo procedurale
,p_prs    IN OUT number      --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
);
PROCEDURE voci_quantita
(
 p_ci       number
,p_al       date    --Data di Termine o Fine Mese
,p_anno      number
,p_mese      number
,p_mensilita VARCHAR2
,p_fin_ela   date
,p_tipo      VARCHAR2
, p_base_ratei    VARCHAR2
, p_anno_ret       number
, P_cong_ind       number
, P_d_cong         date
, p_conguaglio      number
, p_mens_codice     VARCHAR2
, p_periodo        VARCHAR2
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
);
PROCEDURE voci_calcolo
(
 p_ci           number
, p_al           date    -- Data di Termine o Fine Mese
, p_anno         number
, p_mese         number
, p_mensilita     VARCHAR2
, p_fin_ela       date
, p_tipo         VARCHAR2
, p_estrazione    VARCHAR2
, p_base_ratei    VARCHAR2
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

CREATE OR REPLACE PACKAGE BODY peccmore6 IS
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

--Determinazione delle Quantita` per le Voci a Calcolo
--Attribuzione del valore della colonna Quantita` delle Voci a Calcolo
PROCEDURE voci_calc_qta
(
 p_ci        number
,p_al        date    --Data di Termine o Fine Mese
,p_anno       number
,p_mese       number
,p_mensilita  VARCHAR2
,p_fin_ela    date
,p_estrazione VARCHAR2
,p_voce       VARCHAR2
,p_sub       VARCHAR2
,p_rif       date
,p_qta_voce IN OUT number
,p_ore_mensili     number
,p_div_orario      number
,p_ore_gg          number
,p_gg_lavoro       number
,p_ore_lavoro      number
/* modifica 16/03/2004 */
,p_specie          varchar2
,p_input           varchar2
,p_specifica       varchar2
/* fine modifica 16/03/2004 */
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
D_tipo           varchar2(1);
D_memorizza      varchar2(1);
/* modifica 16/03/2004 */
D_rapporto       varchar2(1);
D_astensione     varchar2(10);
/* fine modifica 16/03/2004 */
D_val_voce       varchar2(1);
D_cod_voce       varchar2(10);
D_sub_voce       varchar2(2);
D_quantita       number(12,2);
D_tipo_moltiplica varchar2(2);
D_moltiplica      number;
D_tipo_divide     varchar2(2);
D_divide         number;
D_decimali       number(1);
D_condizione      varchar2(1);
D_valore         number(12,2);
/* modifica del 16/03/2004 */
-- Determinazione del tipo di riferimento per la valorizzazione della voce
-- A    = Annuale
-- M    = Mansile
-- P    = Periodo
-- null = Globale
--
D_tipo_riferimento varchar2(1);
Function tipo_riferimento
( a_rapporto     varchar2
, a_specie       varchar2
, a_specifica    varchar2
, a_val_voce_qta varchar2
, a_cod_voce_qta varchar2
) RETURN varchar2
is
r_value varchar2(1);
BEGIN
   IF A_specifica = 'RGA13A' THEN
      R_value := 'A';
   ELSIF A_specifica = 'RGA13M' THEN
      R_value := 'M';
   ELSIF A_specifica like 'RGA%' THEN
      IF nvl(A_specie,'T') = 'T' THEN
         IF nvl(A_rapporto,'O') = 'O' THEN
            IF A_cod_voce_qta is NULL AND A_val_voce_qta != 'V' THEN
               R_value := 'P';
            ELSE 
               R_value := 'M';
            END IF;
         ELSE
            R_value := 'P';
         END IF;
      ELSE
         R_value := 'A';
      END IF;
   ELSE
      IF A_rapporto is null THEN
         R_value := null;
      ELSE
         IF nvl(A_specie,'T') = 'T' THEN
            R_value := 'P';
         ELSE
            R_value := null;
	     END IF;
      END IF;
   END IF;
   RETURN R_value;
END tipo_riferimento;
/* fine modifica del 16/03/2004 */
BEGIN
  BEGIN  --Preleva dati di valorizzazione Quantita`
     P_stp := 'VOCI_CALC_QTA-01';
     select voec.tipo
         , voec.memorizza
/* modifica 16/03/2004 */
         , covo.rapporto
         , tavo.astensione
/* fine modifica 16/03/2004 */
         , tavo.val_voce_qta
         , tavo.cod_voce_qta
         , tavo.sub_voce_qta
         , tavo.quantita
         , tavo.tipo_moltiplica_qta
         , tavo.moltiplica_qta
         , tavo.tipo_divide_qta
         , tavo.divide_qta
         , tavo.decimali_qta
       into D_tipo
         , D_memorizza
         , D_rapporto
         , D_astensione
         , D_val_voce
         , D_cod_voce
         , D_sub_voce
         , D_quantita
         , D_tipo_moltiplica
         , D_moltiplica
         , D_tipo_divide
         , D_divide
         , D_decimali
       from tariffe_voce tavo
         , voci_economiche voec
/* modifica 16/03/2004 */
         , contabilita_voce covo
/* fine modifica 16/03/2004 */
      where tavo.voce = P_voce
        and P_rif between tavo.dal
                      and nvl(tavo.al ,to_date(3333333,'j'))
        and voec.codice = P_voce
/* modifica 16/03/2004 */
        and covo.voce = P_voce
        and covo.sub  = P_sub
        and P_rif
            between nvl(covo.dal,to_date(2222222,'j'))
                and nvl(covo.al ,to_date(3333333,'j'))
/* fine modifica 16/03/2004 */
     ;
  END;
/* modifica 16/03/2004 */
/* eliminazione 16/03/2004
  IF D_val_voce = 'D'   AND
     D_cod_voce is null THEN
     BEGIN
       select nvl(sum(nvl(pere.gg_per,0)),0)
        into P_qta_voce
        from periodi_retributivi pere
        where ci   = P_ci
         and periodo    between
             decode(D_tipo_moltiplica,
              'GA',to_date('01/01/'||to_char(P_anno),'dd/mm/yyyy'),
              'GT',to_date('01/01/'||to_char(P_anno),'dd/mm/yyyy'),
              'GM',to_date('01/'||to_char(P_mese)||'/'||to_char(P_anno)
                         ,'dd/mm/yyyy'))
                          and
             P_fin_ela
         and competenza = lower(competenza)
         and per_gg     = D_moltiplica
         and anno+0     = decode(D_tipo_moltiplica,
                        'GA',P_anno,
                        'GM',P_anno,
                        'GT',pere.anno)
         and mese       = decode(D_tipo_moltiplica,
                        'GA',pere.mese  ,
                        'GM',pere.mese  ,
                        'GT',pere.mese);
     END;
*/
/* fine eliminazione 16/03/2004 */
  IF D_cod_voce is null          AND
     nvl(D_val_voce,'V') != 'V'  AND
     D_tipo_moltiplica   != 'VL' THEN
     BEGIN  -- Trattamento Tipo e Specie Quantita:
       --
       -- Tipo:   A = Giorni effettivi per Astensione
       --         C = Giornate Contrattuali per Astensione
       --         E = Giorni Effettivi
       --         G = Giornate Contrattuali
       --         M = Mesi annuali completi
       --         R = Ratei annuali
       --
       -- Specie: M = Mese
       --         A = Anno
       --         T = Totali
       --         R = Residuali
       --         I = Orario Intero
       --         P = Orario Ridotto (Part/Time)
       --
       -- Codici aggiuntivi: 
       --        GL = Giorni Lavorabili
       --        OL = Ore Lavorabili   

       D_tipo_riferimento := tipo_riferimento( D_rapporto, P_specie, P_specifica, D_val_voce, D_cod_voce);
       select nvl(
              sum( decode
                   ( substr(D_tipo_moltiplica,1,1)
/* modifica del 30/11/2004 */
                   , 'C', sum( r.gg_per )
--                   , 'A', sum( r.gg_365 )
                   , 'A', decode( to_char(r.al,'mm')
                                , 2, least(28,sum( r.gg_365 ))
                                   , sum( r.gg_365 )
                                )
--                   , 'E', sum( r.gg_365 )
                   , 'E', decode( to_char(r.al,'mm')
                                , 2, least(28,sum( r.gg_365 ))
                                   , sum( r.gg_365 )
                                )
/* fine modifica del 30/11/2004 */
                   , 'G', decode( substr(D_tipo_moltiplica,2,1)
                                , 'L', sum( r.gg_lav )
                                     , decode( D_moltiplica
                                              , null, sum( r.gg_con )
                                                    , sum( r.gg_per )
                                             )
                                )
                   , 'O', sum( r.gg_lav * P_ore_gg )
                   , 'M', decode( sum( r.gg_365 ), to_number(to_char(last_day(max(r.al)),'dd')), 1, 0 )
                   --
                   -- Calcolo dei ratei interi o parziali,
                   -- con assestamento in caso di rateo spettante
                   -- ma entrambi inferiori a 15, erogando un Rateo Parziale
                   --
                   , 'R', decode( substr(D_tipo_moltiplica,2,1)
                                , 'A', decode( sign(sum(r.gg_fis ) - 15 )
                                             , -1, 0
                                                 , 1
                                             )
                                , 'P', decode( sign(sum(decode( abs(r.rap_ore), 1,0,r.gg_fis )) - 15 )
                                             , -1, decode( sign( sum(r.gg_fis) - 15), -1, 0, 1)
                                                 , 1
                                             )
                                , 'I', decode( sign(sum(decode( abs(r.rap_ore), 1,r.gg_fis,0 )) - 15 )
                                             , -1, 0
                                                 , 1
                                             )
                                )
                   , 0
                   )
                 )
              , 0)
   into P_qta_voce
   from periodi_retributivi r
      , periodi_giuridici   p
  where r.ci   = P_ci
    and p.ci(+)   = r.ci
    and p.rilevanza(+) = 'P'
    and r.al between nvl(p.dal(+),to_date('2222222','j'))
                 and nvl(p.al(+),to_date('3333333','j'))
    and P_rif between nvl(p.dal,to_date('2222222','j'))
                   and nvl(p.al,to_date('3333333','j'))
/* modifica del 26/10/2004 */ 
-- Per la gestione delle aspettative per maternità post-cessazione:
-- poichè nel mese di cessazione vengono letti sia il rapporto di lavoro reale che 
-- quello fittizio derivante da (+), verifica che non esista un rec. di PEGI reale 
-- che contiene il riferimento della voce da valorizzare se sta trattando il rec. derivante da (+)
    and (   p.dal is not null
	 or not exists (select 'x' from periodi_giuridici
	                 where ci = P_ci
	                   and rilevanza = 'P'
			   and P_rif between dal and nvl(al,to_date('3333333','j'))
		      )
	)
/* fine modifica del 26/10/2004 */ 
     --
     -- Condizioni per Tipo Quantita (A,C,E,G,M,R)
     --
    and (   substr(D_tipo_moltiplica,1,1) in ('A', 'C')
        and r.competenza = lower(r.competenza) -- periodi Assenza
        and r.cod_astensione = D_astensione
       or   substr(D_tipo_moltiplica,1,1) in ('E', 'G')
        and (   D_moltiplica is not null
            and r.competenza = lower(r.competenza) -- periodi Assenza
            and r.per_gg     = D_moltiplica
           or   D_moltiplica is null
            and r.competenza = upper(r.competenza) -- periodi Presenza
            )
       or   substr(D_tipo_moltiplica,1,1) not in ('A', 'C', 'E', 'G')
        and r.competenza = upper(r.competenza) -- periodi Presenza
        )
    and (   r.competenza  = lower(r.competenza)
       or   r.competenza in ('P','C','A')
        and P_input    != lower(P_input)
       or   r.competenza in ('C','A')
        and P_input     = lower(P_input)
        )
     --
     -- Condizioni per Specie Quantita (M,A,T)
     --
    and r.periodo
        between decode
                ( substr(D_tipo_moltiplica,2,1)
                , 'M', to_date('01/'||to_char(P_rif,'mm/yyyy'),'dd/mm/yyyy')
                     , to_date('01/01/'||to_char(P_rif,'yyyy'),'dd/mm/yyyy')
                )
            and decode
                ( substr(D_tipo_moltiplica,2,1)
                , 'M', last_day(to_date(to_char(P_rif,'mm/yyyy'),'mm/yyyy'))
                     , P_fin_ela
                )
    and to_number(to_char(r.al,'yyyy'))
            = decode ( substr(D_tipo_moltiplica,2,1)
                     , 'M', to_number(to_char(P_rif,'yyyy'))
                     , 'A', to_number(to_char(P_rif,'yyyy'))
                          , to_number(to_char(r.al,'yyyy')) 
                     )
     --
     -- Condizioni per Specie Quantita (I,P) escluso Tipo R (ratei)
     -- che viene trattato nella determinazione della qta (nella select)
     --
    and (   substr(D_tipo_moltiplica,2,1) not in ('I', 'P')
       or   substr(D_tipo_moltiplica,1,1) = 'R'
       or   substr(D_tipo_moltiplica,2,1) = 'I'
        and abs(r.rap_ore)  = 1
       or   substr(D_tipo_moltiplica,2,1) = 'P'
        and abs(r.rap_ore)  != 1
        )
     --
     -- Condizioni per riferimento della voce Anno, Mese, Periodo o Globale
     --
  and (   nvl(D_tipo_riferimento,'G') = 'G'
      and r.periodo                   = P_fin_ela      -- 05/07/2004
     or   D_tipo_riferimento = 'A'
      and to_number(to_char(r.al,'yyyy')) = to_number(to_char(P_rif,'yyyy'))
     or   D_tipo_riferimento = 'M'
      and to_number(to_char(r.al,'mmyyyy')) = to_number(to_char(P_rif,'mmyyyy'))
     or   D_tipo_riferimento = 'P'
      and to_number(to_char(r.al,'yyyymm')) <= to_number(to_char(P_rif,'yyyymm'))
      and (   P_rif between r.dal and r.al
         or   exists
             (select 'x'
                from periodi_retributivi
               where periodo     = P_fin_ela
                 and ci          = P_ci
                 and competenza  = 'P'
                 and P_rif between dal and al
                 and dal        <= r.al
                 and al         >= r.dal
             )
	    )
	and (   P_input in ('q','i','n')
          and r.servizio = upper(P_input)
         or   P_input not in ('q','i','n')
          )
      )
 group by to_char(r.al,'yyyy'),to_char(r.al,'mm')
   --
   -- Esclusione mesi interi se Specie Quantita e Residuale ('R')
   -- ed esclusi i ratei part-time in presenza di ratei interi per lo stesso mese
   --
 having substr(D_tipo_moltiplica,2,1) != 'R'
    and (   D_tipo_moltiplica         not in ('RP', 'MP')
       or   D_tipo_moltiplica              = 'RP'
        and sum( decode(abs(r.rap_ore),1,r.gg_fis,0) ) < 15
       or   D_tipo_moltiplica              = 'MP'
        and sum( decode(abs(r.rap_ore),1,r.gg_365,0) ) != to_number(to_char(last_day(max(r.al)),'dd'))
        )
     or   substr(D_tipo_moltiplica,2,1)  = 'R'
      and sum( r.gg_365 ) != to_number(to_char(last_day(max(r.al)),'dd'));
   IF P_voce = '13AMNDR' THEN NULL;
-- dbms_output.put_line('CMORE6: voce '||P_voce||' qta '||to_char(P_qta_voce)||' rif. '||to_char(p_rif)); 
   END IF;  
     END;
/* fine modifica 16/03/2004 */
  ELSIF
     D_val_voce in ('P','M','D') THEN
     BEGIN  --Estrazione  -Voce Quantita'-  dai Progressivi
        P_stp := 'VOCI_CALC_QTA-02';
        select 	nvl( sum( nvl(prco.p_qta,0)
                     * decode( D_val_voce, 'D', 1, 'M', 1, 0 )
                     + nvl(prco.p_imp,0)
                     * decode( D_val_voce, 'P', 1, 0 )
                     )
                * decode( D_tipo, 'T', -1, 1 )
                , 0
                )
         into P_qta_voce
         from progressivi_contabili prco
        where prco.ci        = P_ci
/* modifica 28/10/2005 */
          and (  (    nvl(P_specifica,' ') not like 'RGA%'
                  and prco.anno      = P_anno
                  and prco.mese      = P_mese
                  and prco.mensilita = P_mensilita )
               or(    nvl(P_specifica,' ') like 'RGA%'
                  and to_number(to_char( P_rif, 'yyyy')) = P_anno
                  and prco.anno      = P_anno
                  and prco.mese      = P_mese
                  and prco.mensilita = P_mensilita )
               or(    nvl(P_specifica,' ') like 'RGA%'
                  and to_number(to_char( P_rif, 'yyyy')) != P_anno
                  and prco.anno      = to_number(to_char( P_rif, 'yyyy'))
                  and prco.mese      = 12 
                  and prco.mensilita =
                    ( select max(mensilita) mensilita
                        from mensilita 
                         where mese = 12
                           AND tipo in ('S','N','A') ) )
              )
/* fine modifica 28/10/2005 */
          and prco.voce      = D_cod_voce
          and prco.sub       = D_sub_voce
        ;
	 END;
  ELSE
     P_qta_voce := 0;
  END IF;
  IF D_val_voce      in ('Q','I')
  OR D_val_voce      in ('M','P','D') AND
     D_cod_voce  is not null          AND
     D_memorizza not in ('M','S')     THEN
     BEGIN  --Estrazione  -Voce Quantita'-  dal mese Corrente
        P_stp := 'VOCI_CALC_QTA-03';
        select P_qta_voce
            + nvl( sum( nvl(caco.qta,0)
                     * decode( D_val_voce
                            , 'Q', 1
                            , 'D', 1
                            , 'M', 1
                                , 0
                            )
                     + nvl(caco.imp,0)
                     * decode( D_val_voce
                            , 'I', 1
                            , 'P', 1
                                , 0
                            )
                     )
                , 0
                ) * decode( D_tipo, 'T', -1, 1 )
         into P_qta_voce
         from calcoli_contabili caco
/* modifica del 15/12/2004 */
        where caco.ci+0   = P_ci
/* fine modifica del 15/12/2004 */
          and caco.voce = D_cod_voce
          and caco.sub  = D_sub_voce
/* modifica 28/10/2005 */
          and (       nvl(P_specifica,' ') not like 'RGA%'
               or(    nvl(P_specifica,' ') like 'RGA%'
                  and to_number(to_char( P_rif, 'yyyy'))     = P_anno
                  and to_number(to_char(riferimento,'yyyy')) = P_anno )
               or(    nvl(P_specifica,' ') like 'RGA%'
                  and to_number(to_char( P_rif, 'yyyy'))    != P_anno
                  and to_number(to_char(riferimento,'yyyy')) = to_number(to_char( P_rif, 'yyyy')))
              ) 
/* fine modifica 28/10/2005 */
        ;
     END;
  END IF;
/* modifica 16/03/2004 */
--IF D_val_voce = 'D' AND
--   D_cod_voce is null THEN
--   NULL;
--ELSIF
--   D_val_voce = 'V' THEN
--   IF D_tipo  = 'T' THEN
--      P_qta_voce := nvl(D_quantita,1) * -1;
--   ELSE
--      P_qta_voce := nvl(D_quantita,1);
--   END IF;
--ELSIF
--   nvl(D_val_voce,'V') != 'V'  AND
--   D_quantita      is not null THEN
--
  IF D_val_voce = 'V' THEN
     P_qta_voce := nvl(D_quantita,1);
  END IF; 
  IF D_val_voce = 'V' 
  OR D_cod_voce is null THEN
     IF D_tipo  = 'T' THEN
        P_qta_voce := P_qta_voce * -1;
     END IF;
  END IF;
  IF nvl(D_val_voce,'V') != 'V'  AND
     D_quantita      is not null THEN
/* fine modifica 16/03/2004 */
     BEGIN  --Verifica Condizioni sulla Quantita`
        P_stp := 'VOCI_CALC_QTA-04';
        D_condizione := substr
                      ( to_char(D_quantita,'9999999999.99')
                      , 2, 1
                      );
        D_valore    := abs(D_quantita);
        IF D_condizione = '9' THEN
          D_valore := D_valore - 9000000000;
        ELSIF
          D_condizione = '8' THEN
          D_valore := D_valore - 8000000000;
        ELSIF
          D_condizione = '7' THEN
          D_valore := D_valore - 7000000000;
        ELSIF
          D_condizione = '6' THEN
          D_valore := D_valore - 6000000000;
        ELSIF
          D_condizione = '5' THEN
          D_valore := D_valore - 5000000000;
        ELSIF
          D_condizione = '4' THEN
          D_valore := D_valore - 4000000000;
        ELSIF
          D_condizione = '3' THEN
          D_valore := D_valore - 3000000000;
        ELSIF
          D_condizione = '2' THEN
          D_valore := D_valore - 2000000000;
        ELSE
          D_condizione := '1';
        END IF;
        IF D_quantita < 0 THEN
          D_valore     := D_valore * - 1;
        END IF;
        IF D_condizione = '1' THEN       --Assegnazione Valore
          IF P_qta_voce != 0 THEN       --se Voce non a ZERO
             P_qta_voce := D_valore;
          ELSE
             P_qta_voce := 0;
          END IF;
        ELSIF
          D_condizione = '2' THEN        --Se Voce  '>'  di Valore
          IF P_qta_voce > D_valore THEN   --valorizza tariffa
             P_qta_voce := 1;
/* modifica del 08/06/99 */
          ELSE
             P_qta_voce := 0;
/* fine modifica del 08/06/99 */
          END IF;
        ELSIF
          D_condizione = '3' THEN        --Se Voce  '<'  di Valore
          IF P_qta_voce < D_valore THEN   --valorizza tariffa
             P_qta_voce := 1;
/* modifica del 08/06/99 */
          ELSE
             P_qta_voce := 0;
/* fine modifica del 08/06/99 */
          END IF;
        ELSIF
          D_condizione = '4' THEN        --Se Voce  '='  a  Valore
          IF P_qta_voce = D_valore THEN   --valorizza tariffa
             P_qta_voce := 1;
/* modifica del 08/06/99 */
          ELSE
             P_qta_voce := 0;
/* fine modifica del 08/06/99 */
          END IF;
        ELSIF
          D_condizione = '5' THEN        --Se Voce  '#'  da Valore
          IF P_qta_voce != D_valore THEN  --valorizza tariffa
             P_qta_voce := 1;
/* modifica del 08/06/99 */
          ELSE
             P_qta_voce := 0;
/* fine modifica del 08/06/99 */
          END IF;
        ELSIF
          D_condizione = '6' THEN        --Se Voce  '>'  di Valore
          IF P_qta_voce <= D_valore THEN  --valorizza con quantita`
             P_qta_voce := 0;
          END IF;
        ELSIF
          D_condizione = '7' THEN        --Se Voce  '<'  di Valore
          IF P_qta_voce >= D_valore THEN  --valorizza con quantita`
             P_qta_voce := 0;
          END IF;
        ELSIF
          D_condizione = '8' THEN        --Se Voce  '='  a Valore
          IF P_qta_voce != D_valore THEN  --valorizza con quantita`
             P_qta_voce := 0;
          END IF;
        ELSIF
          D_condizione = '9' THEN        --Se Voce  '#'  da Valore
          IF P_qta_voce = D_valore THEN   --valorizza con quantita`
             P_qta_voce := 0;
          END IF;
        END IF;
     END;
  END IF;
  IF P_qta_voce != 0 THEN
     BEGIN  --Assestamento Quantita'
        P_stp := 'VOCI_CALC_QTA-05';
        --Trunc per Decimali = 0
        select round
              ( trunc( P_qta_voce
/* modifica 16/03/2004 */
                    * decode( D_tipo_moltiplica
                           , 'OM', P_ore_mensili
                           , 'OG', P_ore_gg
                           , 'GG', P_gg_lavoro
                           , 'VL', decode(D_moltiplica
                                  ,1, 1 / (P_qta_voce * P_qta_voce)
                                    , nvl( D_moltiplica,1 ))
                                 , 1
                           )
                    / decode( D_tipo_divide
                           , 'OM', P_div_orario
                           , 'OG', decode(P_ore_gg,0,1,P_ore_gg)
                           , 'GG', P_gg_lavoro
                           , 'VL', decode(D_divide
                                  ,1, P_qta_voce * P_qta_voce
                                    , nvl( D_divide,1 ))
                                 , 1
                           )
/* eliminazione 16/03/2004 */
/*
                    * decode( D_tipo_moltiplica
                           , 'OM', P_ore_mensili
                           , 'OG', P_ore_gg
                           , 'GG', P_gg_lavoro
                           , 'GA', 1
                           , 'GT', 1
                           , 'GM', 1
                                , decode(D_moltiplica
                                  ,1, 1 / (P_qta_voce * P_qta_voce)
                                    , nvl( D_moltiplica,1 ))
                           )
                    / decode( D_tipo_divide
                           , 'OM', P_div_orario
                           , 'OG', decode(P_ore_gg,0,1,P_ore_gg)
                           , 'GG', P_gg_lavoro
                                , decode(D_divide
                                  ,1, P_qta_voce * P_qta_voce
                                    , nvl( D_divide,1 ))
                           )
*/
/* fine eliminazione 16/03/2004 */
/* fine modifica 16/03/2004 */
                   , decode(D_decimali,0,0,10)
                   )
              , nvl( D_decimali,0)
              )
         into P_qta_voce
         from dual
        ;
     END;
  END IF;
/* modifica 16/03/2004 */
--IF D_val_voce = 'D'   AND
--   D_cod_voce is not null THEN
  IF D_val_voce = 'D' THEN
/* fine modifica 16/03/2004 */
     BEGIN  --Estrazione  -Quantita' Precedente-  da Progressivi
           --per le voci con  -Valore Quantita`-  = 'D'
           --(differenza progressiva)
        P_stp := 'VOCI_CALC_QTA-06';
        select P_qta_voce - nvl( sum(prco.p_qta), 0 )
         into P_qta_voce
         from progressivi_contabili prco
        where prco.ci        = P_ci
          and prco.anno      = P_anno
          and prco.mese      = P_mese
          and prco.mensilita = P_mensilita
          and prco.voce      = P_voce
          and prco.sub       = P_sub
--esclude voci erogate per conguaglio
          and prco.input     = upper(prco.input)
/* modifica 16/03/2004 */
/* modifica del 08/05/2000 */
-- esclude voci comunicate da variabili e riferite ad anni precedenti
          --and to_char(prco.riferimento,'yyyy') = P_anno
/* fine modifica del 08/05/2000 */
          and (   nvl(D_tipo_riferimento,'A') = 'A'
              and to_char(prco.riferimento,'yyyy') = to_char(P_rif,'yyyy')
             or   D_tipo_riferimento = 'M'
              and to_char(prco.riferimento,'mmyyyy') = to_char(P_rif,'mmyyyy')
             or   D_tipo_riferimento = 'P'
              and to_char(prco.riferimento,'yyyymm') <= to_char(P_rif,'yyyymm')
              and exists
                 (select 'x'
                    from periodi_retributivi
                   where periodo     = P_fin_ela
                     and ci          = P_ci
                     and competenza in ('P', 'C', 'A')
                     and prco.riferimento between dal and al
                     and P_rif between dal and al
                 )
	        )
/* fine modifica 16/03/2004 */
        ;
     END;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN  --Voce non valorizzabile
     null;
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
--Valorizzazione delle voci a Tariffa
--
--Determinazione della Quantita` per le voci a Calcolo
--Calcolo della Tariffa delle Voci a Quantita` o a Calcolo
--e valorizzazione dell'importo
--
PROCEDURE voci_calc_val
(
 p_ci           number
,p_al           date    --Data di Termine o Fine Mese
,p_anno         number
,p_mese         number
,p_mensilita     VARCHAR2
,p_fin_ela       date
,p_estrazione    VARCHAR2
,p_numero_voci IN OUT number --Numero Voci presenti
,p_base_ratei    VARCHAR2
--Parametri per Trace
,p_trc    IN     number      --Tipo di Trace
,p_prn    IN     number      --Numero di Prenotazione elaborazione
,p_pas    IN     number      --Numero di Passo procedurale
,p_prs    IN OUT number      --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
BEGIN
  P_numero_voci := 0;
  P_stp := 'VOCI_CALC_VAL-01';
  FOR CURV IN
     (select caco.voce
          , caco.sub
          , caco.riferimento
          , caco.input
          , caco.tar
          , caco.qta
          , caco.imp
          , caco.rowid
          , voec.specie
          , voec.specifica
        from voci_economiche   voec
          , calcoli_contabili caco
       where voec.codice     = caco.voce
        and caco.estrazione = P_estrazione
        and caco.ci        = P_ci
     )
  LOOP
  P_numero_voci := P_numero_voci + 1;
  IF curv.imp           is null AND
     (   P_estrazione     = 'Q'  AND
        nvl(curv.qta,0) != 0
      OR P_estrazione    != 'Q'
     )   THEN
     P_stp := 'VOCI_CALC_VAL-01';
     peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     <<tratta_voce>>
     DECLARE
     D_quantita    number(19,9);
     D_tariffa     number(19,9);
     D_tar_eff     number(19,9);  -- Tariffa Imponibili Effettivi
     D_rif_tar     date;  -- Data di Riferimento per calcolo Tariffa /* modifica 16/03/2004 */
     D_ore_mensili number(5,2);
     D_div_orario  number(5,2);
     D_ore_gg      number(5,2);
     D_gg_lavoro   number(5,2);
     D_ore_lavoro  number(5,2);
     BEGIN  --Trattamento della singola voce
        BEGIN  --Preleva dati di contratto per assestamento
          P_stp := 'VOCI_CALC_VAL-02';
          select ore_mensili
               , decode(div_orario,0,1,div_orario)
               , ore_gg
               , decode(gg_lavoro,0,1,gg_lavoro)
               , decode(ore_lavoro,0,1,ore_lavoro)
            into D_ore_mensili
               , D_div_orario
               , D_ore_gg
               , D_gg_lavoro
               , D_ore_lavoro
            from contratti_storici cost
           where cost.contratto =
               (select contratto
                  from qualifiche_giuridiche qugi
                 where numero =
                    (select substr( min(competenza)||
                                  to_char(max(qualifica))
                                , 2
                                )
                      from periodi_retributivi pere
                      where pere.ci         = P_ci
                       and pere.periodo     = P_fin_ela
                       and pere.competenza in ('P','C','A')
                       and pere.servizio    = 'Q'
                       and curv.riferimento
                                    between pere.dal
                                        and pere.al
                    )
                   and curv.riferimento
                      between nvl(qugi.dal,to_date(2222222,'j'))
                          and nvl(qugi.al ,to_date(3333333,'j'))
               )
             and curv.riferimento
                between cost.dal
                    and nvl(cost.al ,to_date(3333333,'j'))
          ;
          peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             D_ore_mensili := 0;
             D_div_orario := 1;
             D_ore_gg := 0;
             D_gg_lavoro := 1;
             D_ore_lavoro := 1;
        END;
        D_quantita := curv.qta;  --Quantita` in campo di lavoro
        IF substr( P_estrazione,1,1) = 'C' AND
          D_quantita is null THEN
          P_stp := 'VOCI_CALC_VAL-03';
          VOCI_CALC_QTA  --Determinazione Quantita`
             ( P_ci, P_al
                  , P_anno, P_mese, P_mensilita
                  , P_fin_ela, P_estrazione
                  , curv.voce, curv.sub, curv.riferimento
                  , D_quantita
                  , D_ore_mensili, D_div_orario
                  , D_ore_gg, D_gg_lavoro, D_ore_lavoro
/* modifica 16/03/2004 */
                  , curv.specie
                  , curv.input
                  , curv.specifica
/* fine modifica 16/03/2004 */
                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
             );
          peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END IF;
        D_tariffa := curv.tar;  --Tariffa in campo di lavoro
        D_tar_eff := null;      --Inizializza Tariffa Effettiva
        D_rif_tar := null;      --Inizializza Data Riferimento calcolo Tariffa /* modifica 16/03/2004 */
        IF substr(P_estrazione,1,1) = 'C'  AND
          D_quantita             != 0    AND
          D_tariffa              is null
        OR substr(P_estrazione,1,1) = 'Q'  AND
          D_tariffa              is null THEN
          P_stp := 'VOCI_CALC_VAL-04';
          BEGIN  --Determinazione del valore della Tariffa
             peccmore7.VOCI_CALC_TAR  --Calcolo della Tariffa
               ( P_ci, P_al
                     , P_anno, P_mese, P_mensilita, P_fin_ela
                     , curv.voce, curv.sub, curv.riferimento
                     , D_tariffa, D_tar_eff, D_rif_tar  /* modifica 16/03/2004 */
                     , D_ore_mensili, D_div_orario
                     , D_ore_gg, D_gg_lavoro, D_ore_lavoro
                     , curv.specie
                     , curv.input
                     , curv.specifica
                     , P_base_ratei
                     , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
               );
          EXCEPTION
             WHEN OTHERS THEN
                 P_stp := '!!! Tar.: '||curv.voce;
                 RAISE;
          END;
          peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END IF;
        IF D_tariffa  != nvl(curv.tar,0)
        OR D_quantita != nvl(curv.qta,0) THEN
          P_stp := 'VOCI_CALC_VAL-05';
          BEGIN  --Aggiornamento della Tariffa e Quantita` sulla voce
                --e calcolo Importo
/* modifica del 15/12/2004 - sostituita e_round con round */
             update calcoli_contabili caco
             set tar     = D_tariffa
               , qta     = decode( input
                                 , 'i', 0
                                 , 'n', 0
                                      , D_quantita
                                 )
               , imp     = round( D_quantita
                                  * D_tariffa
                                  , 2)
               , ipn_eap = round( D_quantita
                                   * D_tar_eff
                                  , 2 )
               , riferimento = decode
                             ( curv.specifica
                             , 'RGA13M', decode  -- diverse solo in caso di calcolo con Rapporto Giorni
                                       ( round(D_tariffa,5)
                                       , round(D_tar_eff,5)
                                         , P_al
                                         , curv.riferimento
                                       )
                                     , curv.riferimento
                             )
               , input = decode( input
                               , 'C', 'A'  --Specifica 'RGA%'
                               , 'q', 'A'
                               , 'i', 'A'  --Rapporto a Giorni
                               , 'n', 'A'  --Specie = 'T'
                                   , input
                               )
/* modifica 16/03/2004 */
               , competenza = D_rif_tar
/* fine modifica 16/03/2004 */
              where rowid = curv.rowid
             ;
          EXCEPTION
             WHEN OTHERS THEN
                 P_stp := '!!! Imp.: '||curv.voce;
                 RAISE;
          END;
          peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END IF;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN  --voce non valorizzabile
          null;
     END tratta_voce;
  END IF;  --trattamento voci non valorizzate
  END LOOP;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
--Valorizzazione Voci a Calcolo
--
PROCEDURE voci_calcolo
(
 p_ci           number
, p_al           date    --Data di Termine o Fine Mese
, p_anno         number
, p_mese         number
, p_mensilita     VARCHAR2
, p_fin_ela       date
, p_tipo         VARCHAR2
, p_estrazione    VARCHAR2
, p_base_ratei    VARCHAR2
--Parametri per Trace
, p_trc    IN     number     --Tipo di Trace
, p_prn    IN     number     --Numero di Prenotazione elaborazione
, p_pas    IN     number     --Numero di Passo procedurale
, p_prs    IN OUT number     --Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       --Step elaborato
, p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
D_numero_voci     number;    --Numero Voci a Calcolo presenti
BEGIN
  D_numero_voci := 0;
  P_stp := 'VOCI_CALCOLO-01';
  VOCI_CALC_VAL  --Determinazione Quantita` e Calcolo Tariffa
     ( P_ci, P_al
          , P_anno, P_mese, P_mensilita, P_fin_ela, P_estrazione
          , D_numero_voci, P_base_ratei
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  IF D_numero_voci != 0 THEN
     peccmore.VOCI_TOTALE  --Totalizzazione delle Voci a Calcolo
        ( P_ci, P_al, P_fin_ela, P_tipo, P_estrazione
             , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
  END IF;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
  --Valorizzazione Voci a Quantita`
--
PROCEDURE voci_quantita
(
 p_ci       number
,p_al       date    --Data di Termine o Fine Mese
,p_anno      number
,p_mese      number
,p_mensilita VARCHAR2
,p_fin_ela   date
,p_tipo      VARCHAR2
, p_base_ratei    VARCHAR2
, p_anno_ret       number
, P_cong_ind       number
, P_d_cong         date
, p_conguaglio      number
, p_mens_codice     VARCHAR2
, p_periodo        VARCHAR2
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
D_numero_voci    number;    --Numero Voci a Quantita` presenti
BEGIN
  BEGIN  --Estrazione voci a Quantita` su Voci gia' emesse nel mese
     P_stp := 'VOCI_QUANTITA-00';
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
  D_numero_voci := 0;
  P_stp := 'VOCI_QUANTITA-01';
  VOCI_CALC_VAL  --Calcolo Tariffe voci a QUANTITA' non valorizzate
     ( p_ci, p_al
          , p_anno, p_mese, p_mensilita , p_fin_ela, 'Q'
          , D_numero_voci, P_base_ratei
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  IF D_numero_voci != 0 THEN
     peccmore.VOCI_TOTALE  --Totalizzazione delle Voci a Quantita`
        (P_ci, P_al, P_fin_ela, P_tipo, 'Q'
            , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
  END IF;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

