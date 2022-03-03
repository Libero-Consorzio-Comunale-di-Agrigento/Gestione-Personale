CREATE OR REPLACE PACKAGE Peccmocp_Ritenuta IS
/******************************************************************************
 NOME:        PECCMOCP_RITENUTA
 DESCRIZIONE: Gestione delle Voci di Ritenuta. - Previsione 
 ANNOTAZIONI: Procedure SCORPORO: 
              - Scorporo dei contributi sulle voci di ritenuta sulla base della
                Delibera Retributiva.
              - Frazionamento ritenute per data di riferimento
                in caso di calcolo su Imponibile Progressivo identificato da flag.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    13/04/2004 MF     Prima emissione.
 1    09/07/2004 NN     Impone la data di competenza della voce di provenienza
                        e corretta errata emissione delle voci a ritenuta
                        determinate sull' importo di una voce (e non sul progressivo)
                        che moltiplicava lo scorporo per ogni singola voce generata. 
 2    01/12/2004 NN     Frazionamento ritenute per data di riferimento in caso 
                        di calcolo su Imponibile Progressivo identificato da flag.
******************************************************************************/

revisione varchar2(30) := '2 del 01/12/2004';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE scorporo
( P_ci         NUMBER
, P_al         DATE    -- Data di Termine o Fine Mese
, P_anno       NUMBER
, P_mese       NUMBER
, P_mensilita  VARCHAR2
, P_fin_ela    DATE
, P_tipo       VARCHAR2
-- Parametri per Trace
, p_trc    IN     NUMBER     -- Tipo di Trace
, p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas    IN     NUMBER     -- Numero di Passo procedurale
, p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2   -- Step elaborato
, p_tim    IN OUT VARCHAR2   -- Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY Peccmocp_Ritenuta IS
form_trigger_failure EXCEPTION;

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

PROCEDURE scorporo_contributi
/******************************************************************************
 NOME:        SCORPORO_CONTRIBUTI
 DESCRIZIONE: Calcolo dello scorporo dei contributi sulle voci di Ritenuta con estrazione "RX". 
              Ricalcalo della ritenuta usando come imponibile solo le singole voci che fanno
              parte dell’imponibile e sono state attribuite alla delibera in esame.
              Le voci così ricalcolate vanno emesse:
              - in positivo con le caratteristiche della delibera della voce che ha fatto da imponibile parziale, 
              - in negativo con le caratteristiche della ritenuta originale.

 ANNOTAZIONI: Richiamata da procedure SCORPORO dello stesso Package 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    13/04/2004 MF     Prima emissione.
******************************************************************************/
( P_ci                     NUMBER
, P_al                     DATE    -- Data di Termine o Fine Mese
, P_anno                   NUMBER
, P_mese                   NUMBER
, P_mensilita              VARCHAR2
, P_fin_ela                DATE
, P_tipo                   VARCHAR2
, P_estrazione             VARCHAR2      -- 01/12/2004
, P_voce                   VARCHAR2
, P_sub                    VARCHAR2
, P_riferimento            DATE
, P_competenza             DATE
, P_riferimento_effettivo  DATE          -- 01/12/2004
-- 09/07/2004
-- , P_sede_del               VARCHAR2 
-- , P_anno_del               NUMBER
-- , P_numero_del             NUMBER
-- , P_delibera               VARCHAR2
, P_sede_del_new           VARCHAR2
, P_anno_del_new           NUMBER
, P_numero_del_new         NUMBER
, P_delibera_new           VARCHAR2
-- Parametri per Trace
, p_trc IN     NUMBER     -- Tipo di Trace
, p_prn IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas IN     NUMBER     -- Numero di Passo procedurale
, p_prs IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp IN OUT VARCHAR2   -- Step elaborato
, p_tim IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
D_val_voce_ipn   RITENUTE_VOCE.val_voce_ipn%TYPE;
D_cod_voce_ipn   RITENUTE_VOCE.cod_voce_ipn%TYPE;
D_sub_voce_ipn   RITENUTE_VOCE.sub_voce_ipn%TYPE;
D_per_rit_ac     RITENUTE_VOCE.per_rit_ac%TYPE;
D_per_rit_ap     RITENUTE_VOCE.per_rit_ap%TYPE;
BEGIN -- Calcolo ritenute di scorporo usando come imponibile solo le singole voci che
      -- fanno parte dell’imponibile e sono state attribuite alla delibera in esame.
   BEGIN  -- Preleva parametri di valorizzazione Ritenuta
      P_stp := 'RITENUTA.SCO_CON-01';
-- dbms_output.put_line('RITENUTA.SCORPORO_CONT-01');
      SELECT rivo.val_voce_ipn
           , rivo.cod_voce_ipn
           , rivo.sub_voce_ipn
           , rivo.per_rit_ac
           , rivo.per_rit_ap
        INTO D_val_voce_ipn
           , D_cod_voce_ipn
           , D_sub_voce_ipn
           , D_per_rit_ac
           , D_per_rit_ap
        FROM RITENUTE_VOCE rivo
       WHERE rivo.voce    = P_voce
         AND rivo.sub     = P_sub
         AND P_riferimento BETWEEN nvl(rivo.dal,to_date(2222222,'j'))
                               AND nvl(rivo.al ,to_date(3333333,'j'))
      ;
      Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           D_val_voce_ipn := ' ';
   END;
   FOR CURS IN  -- (cursore creato solo per deposito variabili)
      (select max(prco.competenza)     competenza
            , nvl(sum(prco.p_imp),0)   tar
            , nvl(sum(prco.p_ipn_p),0) ipn_p
         from progressivi_contabili prco
        where prco.voce              = D_cod_voce_ipn
          and prco.sub               = D_sub_voce_ipn
/* Eliminazione del 21/06/2004 - Annalena
          and prco.sede_del          = P_sede_del  
          and prco.anno_del          = P_anno_del  
          and prco.numero_del        = P_numero_del
          and nvl(prco.delibera,'*') = P_delibera  
*/
          and decode( to_char(nvl(prco.competenza,prco.riferimento),'yyyy')
                    , P_anno, 'C'
                            , 'P'
                    ) like decode( D_per_rit_ac
                                 , 0, 'P'
                                    , decode(D_per_rit_ap, 0, 'C', '%')
                                 )
          and prco.ci        = P_ci
          and prco.anno      = P_anno
          and prco.mese      = P_mese
          and prco.mensilita = P_mensilita
       )
   LOOP
         BEGIN -- D_val_voce_ipn  = 'P' Voce Ritenuta su Imponibile Progressivo
               -- D_val_voce_ipn != 'P' Voce Ritenuta su Importo Mese Corrente
               -- Emissione in positivo con estremi delibera della voce imponibile (parziale). 
            P_stp := 'RITENUTA.SCO_CON-02.1';
-- dbms_output.put_line('RITENUTA.SCORPORO_CONT-02.1 voce '||P_voce||' su '||CURS.tar);
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
                  , sede_del
                  , anno_del
                  , numero_del
                  , delibera
                  )
            values( P_ci, P_voce, P_sub
                  , P_riferimento
--                  , P_al
                  , P_competenza          
--                  , decode(D_val_voce_ipn, 'P', CURS.competenza, null)  --09/07/2004
                  , 'C'
                  , P_estrazione   -- 01/12/2004
                  , decode(D_val_voce_ipn, 'P', CURS.tar, 0)
                  , 0
                  , 0
                  , decode(D_val_voce_ipn, 'P', CURS.ipn_p, 0)
                  , 0, 0, 0, 0, 0
                  , P_sede_del_new
                  , P_anno_del_new
                  , P_numero_del_new
                  , P_delibera_new                  
                  )
            ;
            peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
         END;
         BEGIN -- Emissione input = 'N' per il negativo con caratteristiche della ritenuta originale
            P_stp := 'RITENUTA.SCO_CON-02.2';
-- dbms_output.put_line('RITENUTA.SCORPORO_CONT-02.2');
            insert into calcoli_contabili
                  ( ci, voce, sub
                  , riferimento
                  , competenza
                  , data
                  , input
                  , estrazione
                  , tar
                  , qta
                  , ipn_s
                  , ipn_p
                  , ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
                  , sede_del
                  , anno_del
                  , numero_del
                  , delibera
                  )
            values( P_ci, P_voce, P_sub
                  , P_riferimento
--                  , P_al
                  , P_competenza
--                  , decode(D_val_voce_ipn, 'P', CURS.competenza, null)
                  , P_riferimento_effettivo                             -- 01/12/2004
                  , 'N'
                  , P_estrazione   -- 01/12/2004
                  , decode(D_val_voce_ipn, 'P', CURS.tar, 0)
                  , 0
                  , 0
                  , decode(D_val_voce_ipn, 'P', CURS.ipn_p, 0)
                  , 0, 0, 0, 0, 0
                  , P_sede_del_new
                  , P_anno_del_new
                  , P_numero_del_new
                  , P_delibera_new                  
                  )
            ;
            peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
         END;
   END LOOP;
END scorporo_contributi;
PROCEDURE scorporo
/******************************************************************************
 NOME:        SCORPORO
 DESCRIZIONE: Scorporo dei contributi sulle voci di ritenuta sulla base della
              Delibera Retributiva e Frazionamento ritenute per data di riferimento
              in caso di calcolo su Imponibile Progressivo identificato da flag.
              Esegue:
              - Scarico degli estremi di Delibera da Periodi Retributivi e da Voci Contabili.
              - Scarico degli estremi di Delibera dalle Variabili comunicate.
              - Calcolo ritenute frazionate per data riferimento.
              - Calcolo contributi scorporati per voci con estremi di Delibera.

 ANNOTAZIONI: Richiamata in fase di chiusura del calcolo da Package PECCMOCP1.
******************************************************************************/
( P_ci         NUMBER
, P_al         DATE    -- Data di Termine o Fine Mese
, P_anno       NUMBER
, P_mese       NUMBER
, P_mensilita  VARCHAR2
, P_fin_ela    DATE
, P_tipo       VARCHAR2
-- Parametri per Trace
, p_trc    IN     NUMBER     -- Tipo di Trace
, p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas    IN     NUMBER     -- Numero di Passo procedurale
, p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2   -- Step elaborato
, p_tim    IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
D_sede_del   calcoli_contabili.sede_del%Type;
D_anno_del   calcoli_contabili.anno_del%Type;
D_numero_del calcoli_contabili.numero_del%Type;
D_delibera   calcoli_contabili.delibera%Type;
no_operation EXCEPTION;
found        BOOLEAN;
BEGIN
   BEGIN  -- Scarico degli estremi di Delibera da Periodi Retributivi e da Voci Contabili:
          -- -----------------------------------------------------------------------------
          -- trasferimento degli estremi di delibera indicati in tabella PERIODI_RETRIBUTIVI_BP,
          -- o degli estremi di delibera indicati in tabella CONTABILITA_VOCI, ove presenti,
          -- su tutte le voci presenti nella tabella temporanea CALCOLI_CONTABILI.
      P_stp := 'RITENUTA.SCO-01.1';
-- dbms_output.put_line('RITENUTA.SCORPORO-01.1');
      FOR CURR IN 
       (select rdre.sede, rdre.anno, rdre.numero
             , caco.rowid
          from periodi_retributivi_bp     pere
             , voci_economiche            voec
             , contabilita_voce           covo
             , codici_bilancio            cobi
             , calcoli_contabili          caco
             , righe_delibera_retributiva rdre
         where caco.ci                = P_ci
           and cobi.codice            = covo.bilancio
           and voec.codice            = covo.voce
           and covo.voce              = caco.voce
           and covo.sub               = caco.sub
           and caco.riferimento between nvl(covo.dal, to_date(2222222,'j'))
                                    and nvl(covo.al , to_date(3333333,'j'))
           and pere.ci                = caco.ci
           and pere.periodo           = P_fin_ela
           and rdre.sede              = nvl(covo.sede_del,
                                            decode(cobi.imputazione_delibera, 'SI', pere.sede_del, null))
           and rdre.anno              = nvl(covo.anno_del,
                                            decode(cobi.imputazione_delibera, 'SI', pere.anno_del, null))
           and rdre.numero            = nvl(covo.numero_del,
                                            decode(cobi.imputazione_delibera, 'SI', pere.numero_del, null))
           and rdre.tipo              = '*'
           and rdre.bilancio          = cobi.codice
           and caco.numero_del        is null
           and caco.riferimento between pere.dal and pere.al
           and (   voec.classe           != 'R'
                or voec.classe            = 'R'
                and not exists
                   (select 'x' 
                      from periodi_retributivi_bp
                     where periodo     = pere.periodo
                       and ci          = pere.ci
                       and competenza in ('C','A')
                       and numero_del is null 
                   )
               )
           and (    caco.input        = upper(caco.input)
                and pere.competenza  in ('C','A')
                or  caco.input       != upper(caco.input)
                and pere.competenza   = 'P'
                or  caco.input       != upper(caco.input)
                and pere.competenza  in ('C','A')
                and not exists
                   (select 'x' from periodi_retributivi_bp
                     where periodo    = pere.periodo
                       and ci         = pere.ci
                       and competenza = 'P'
                       and caco.riferimento between dal and al)
               )
           for update
       )
      LOOP
      UPDATE calcoli_contabili caco
         SET sede_del           = CURR.sede
           , anno_del           = CURR.anno
           , numero_del         = CURR.numero
       WHERE rowid      = CURR.rowid
      ;
      END LOOP;
      Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
   BEGIN  -- Attribuzione estremi di delibera dei Rapporti di Lavoro sulle voci di CACO che 
          -- compongono l'imponibile delle ritenute, non trattati precedentemente in quanto
          -- non imputabili contabilmente a bilancio.
      P_stp := 'RITENUTA.SCO-01.2';
-- dbms_output.put_line('RITENUTA.SCORPORO-01.2');
      FOR CURI IN 
       (select nvl(covo.sede_del,   pere.sede_del)   sede_del
             , nvl(covo.anno_del,   pere.anno_del)   anno_del
             , nvl(covo.numero_del, pere.numero_del) numero_del
             , caci.rowid
          from periodi_retributivi_bp pere
             , contabilita_voce     covo
             , calcoli_contabili    caco
             , calcoli_contabili    caci
             , ritenute_voce        rivo
             , voci_economiche      voec
         where caco.ci               = P_ci
           and caci.ci               = caco.ci
           and caci.voce             = rivo.cod_voce_ipn
           and caci.sub              = rivo.sub_voce_ipn
           and caci.numero_del       is null
           and nvl(covo.numero_del, pere.numero_del)  is not null
           and rivo.voce             = caco.voce
           and rivo.sub              = caco.sub
           and voec.codice           = caco.voce
           and voec.classe           = 'R'
           and caco.riferimento between nvl(rivo.dal,to_date('2222222','j'))
                                    and nvl(rivo.al,to_date('3333333','j'))
           and caci.riferimento between nvl(rivo.dal,to_date('2222222','j'))
                                    and nvl(rivo.al,to_date('3333333','j'))
           and covo.voce              = caco.voce
           and covo.sub               = caco.sub
           and caco.riferimento between nvl(covo.dal, to_date(2222222,'j'))
                                    and nvl(covo.al , to_date(3333333,'j'))
           and pere.ci                = caci.ci
           and pere.periodo           = P_fin_ela
           and caci.riferimento between pere.dal and pere.al
           and (    caci.input        = upper(caci.input)
                and pere.competenza  in ('C','A')
                or  caci.input       != upper(caci.input)
                and pere.competenza   = 'P'
                or  caci.input       != upper(caci.input)
                and pere.competenza  in ('C','A')
                and not exists
                   (select 'x' from periodi_retributivi_bp
                     where periodo    = pere.periodo
                       and ci         = pere.ci
                       and competenza = 'P'
                       and caci.riferimento between dal and al)
               )
           for update
       )
      LOOP
      UPDATE CALCOLI_CONTABILI
         SET sede_del   = CURI.sede_del
           , anno_del   = CURI.anno_del
           , numero_del = CURI.numero_del
       WHERE rowid = CURI.rowid
      ;
      END LOOP;
      Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
   DECLARE -- Scarico degli estremi di Delibera dalle Variabili comunicate:
           -- -------------------------------------------------------------
           -- trasferimento estremi di delibera imputata su variabile (input 'D')
           -- con data di riferimento maggiore su tutte le voci di ritenuta (Classe 'R')
           -- da eseguire SOLO SE gli imponibili su cui sono calcolate le ritenute
           -- sono stati prodotti solo da voci che hanno la delibera,
           -- e la ritenuta ha un codice di bilancio indicato nella tabella RIGHE_DELIBERA_RETRIBUTIVA.
      cursor c_ultima_delibera -- delibera imputata sulla variabile (input 'D') con data di riferimento maggiore
            (var_ci number) is
             select sede_del, anno_del, numero_del, delibera
               from calcoli_contabili
              where ci = var_ci
                and input = 'D'
                and numero_del is not null
                and riferimento = 
                   (select max(riferimento)
                      from calcoli_contabili
                     where ci = P_ci
                       and input = 'D'
                       and numero_del is not null
                   )
             ;
   BEGIN
    BEGIN  -- Preleva Delidera di imputazione sulla variabile con data di riferimento maggiore
      P_stp := 'RITENUTA.SCO-02';
      OPEN  c_ultima_delibera(P_ci);
      FETCH c_ultima_delibera into D_sede_del, D_anno_del, D_numero_del, D_delibera;
      found := c_ultima_delibera%FOUND;
      CLOSE c_ultima_delibera;
      Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
      IF not found then
         RAISE no_operation;
      END IF;
    END;
    BEGIN -- Identifica voci Ritenuta che sono state calcolate SOLO su voci attribuite a delibera
         -- e la Ritenuta ha un codice di bilancio indicato nella tabella RIGHE_DELIBERA_RETRIBUTIVA.
-- dbms_output.put_line('PRIMA DI CURD');
      FOR CURD IN
         (select caco.rowid
            from CALCOLI_CONTABILI          caco
               , CONTABILITA_VOCE           covo
               , RIGHE_DELIBERA_RETRIBUTIVA rdre
               , VOCI_ECONOMICHE            voec
           where caco.ci          = P_ci
             and voec.classe      = 'R'
             and caco.voce        = voec.codice
             and covo.voce        = caco.voce
             and covo.sub         = caco.sub
             and caco.riferimento between nvl(covo.dal, to_date(2222222,'j'))
                                      and nvl(covo.al , to_date(3333333,'j'))
             and caco.numero_del is null
/* modifica del 21/06/2004 - Annalena (sostituito caco. con D_) */
             and rdre.sede        = D_sede_del
             and rdre.anno        = D_anno_del
             and rdre.numero      = D_numero_del
             and rdre.tipo        = nvl(D_delibera, '*')
             and rdre.bilancio    = covo.bilancio
             and not exists
                (select 'x'
                   from CALCOLI_CONTABILI vard
                      , RITENUTE_VOCE     rivo 
                  where vard.ci          = P_ci
                    and vard.voce        = rivo.cod_voce_ipn
                    and vard.sub         = rivo.sub_voce_ipn
                    and vard.riferimento between nvl(rivo.dal, to_date(2222222,'j'))
                                             and nvl(rivo.al , to_date(3333333,'j'))
                    and rivo.voce        = caco.voce
                    and rivo.sub         = caco.sub
                    and caco.riferimento between nvl(rivo.dal, to_date(2222222,'j'))
                                             and nvl(rivo.al , to_date(3333333,'j'))
                   and vard.numero_del   is null

                )
             and not exists
                (select 'x'
                   from CALCOLI_CONTABILI   vard
                      , TOTALIZZAZIONI_VOCE tovo
                      , RITENUTE_VOCE       rivo 
                  where vard.ci          = P_ci
                    and vard.voce        = tovo.voce
                    and vard.sub         = nvl(tovo.sub,vard.sub)
                    and vard.riferimento between nvl(rivo.dal, to_date(2222222,'j'))
                                             and nvl(rivo.al , to_date(3333333,'j'))
                    and tovo.voce_acc    = rivo.cod_voce_ipn
                    and nvl(tovo.dal, to_date(2222222,'j')) <= nvl(rivo.al , to_date(3333333,'j'))
                    and nvl(tovo.al , to_date(3333333,'j')) >= nvl(rivo.dal, to_date(2222222,'j'))
                    and rivo.voce        = caco.voce
                    and rivo.sub         = caco.sub
                    and caco.riferimento between nvl(rivo.dal, to_date(2222222,'j'))
                                             and nvl(rivo.al , to_date(3333333,'j'))
                    and vard.numero_del  is null
                )
             for update
         ) LOOP
         P_stp := 'RITENUTA.SCO-03';
-- dbms_output.put_line('RITENUTA.SCORPORO-03');
         Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
         BEGIN  -- Registra la delibera sulle Voci di Ritenuta identificate
            UPDATE CALCOLI_CONTABILI
               SET sede_del   = D_sede_del
                 , anno_del   = D_anno_del
                 , numero_del = D_numero_del
                 , delibera   = D_delibera
             WHERE rowid = CURD.rowid
            ;
         END;
      END LOOP;
    END;
   EXCEPTION
      WHEN no_operation THEN
           null;
   END;
   BEGIN  -- Calcolo contributi scorporati su voci con estremi di Delibera:
          -----------------------------------------------------------------
          -- Esegue LOOP su ogni voce di Ritenuta il cui Codice Bilancio
          -- è definito per la delibera esaminata su RIGHE_DELIBERA_RETRIBUTIVA.
      FOR CURR IN
         (select caco.voce
               , caco.sub
               , to_date(substr(max(to_char(caco.riferimento,'yyyymmdd')||to_char(caco.competenza,'yyyymmdd')),1,8),'yyyymmdd') riferimento
               , to_date(substr(max(to_char(caco.riferimento,'yyyymmdd')||to_char(caco.competenza,'yyyymmdd')),9,8),'yyyymmdd') competenza
--  09/07/2004
--               , caco.riferimento
--               , caco.competenza
--               , caco.sede_del, caco.anno_del, caco.numero_del, caco.delibera, covo.bilancio
               , rdre.sede     sede_del_new
               , rdre.anno     anno_del_new
               , rdre.numero   numero_del_new
               , rdre.tipo     delibera_new
            from CALCOLI_CONTABILI          caco
               , CALCOLI_CONTABILI          caci
               , RITENUTE_VOCE              rivo
               , CONTABILITA_VOCE           covo
               , RIGHE_DELIBERA_RETRIBUTIVA rdre
               , VOCI_ECONOMICHE            voec
           where caco.ci          = P_ci
             and caci.ci          = caco.ci
             and caci.voce        = rivo.cod_voce_ipn
             and caci.sub         = rivo.sub_voce_ipn
             and rivo.voce        = caco.voce
             and rivo.sub         = caco.sub
             and caco.riferimento between nvl(rivo.dal,to_date('2222222','j'))
                                      and nvl(rivo.al,to_date('3333333','j'))
             and caci.riferimento between nvl(rivo.dal,to_date('2222222','j'))
                                      and nvl(rivo.al,to_date('3333333','j'))
             and voec.classe      = 'R'
             and caco.voce        = voec.codice
             and covo.voce        = caco.voce
             and covo.sub         = caco.sub
             and caco.riferimento between nvl(covo.dal, to_date(2222222,'j'))
                                      and nvl(covo.al , to_date(3333333,'j'))
             and caci.numero_del is not null
             and rdre.sede        = caci.sede_del
             and rdre.anno        = caci.anno_del
             and rdre.numero      = caci.numero_del
             and rdre.tipo        = nvl(caci.delibera,'*')
             and rdre.bilancio    = covo.bilancio
             and (nvl(caco.sede_del,' ') != caci.sede_del or
                  nvl(caco.anno_del,0)   != caci.anno_del or
                  nvl(caco.numero_del,0) != caci.numero_del)
           group by caco.voce, caco.sub, caco.qta                    -- 09/07/2004
                  , rdre.sede, rdre.anno, rdre.numero, rdre.tipo     
         ) LOOP
         P_stp := 'RITENUTA.SCO-04';
         Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
         BEGIN  -- Estrazione contributi differenziati per la singola voce
                -- con emissione voci Ritenuta ad estrazione "RX"
            SCORPORO_CONTRIBUTI ( P_ci, P_al
                                , P_anno, P_mese, P_mensilita, P_fin_ela, P_tipo
                                , 'RX'
                                , CURR.voce, CURR.sub
                                , CURR.riferimento, CURR.competenza
                                , null                               -- 01/12/2004
                                , CURR.sede_del_new, CURR.anno_del_new, CURR.numero_del_new, CURR.delibera_new
                                , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                                );
         END;
      END LOOP;
   END;
   P_stp := 'RITENUTA.SCO-05';
   Peccmocp9.VOCI_RITENUTA  -- Determinazione voci a RITENUTA "X" (x Scorporo Contribiti)
      ( P_ci, P_anno, P_al
            , P_anno, P_mese, P_mensilita, P_fin_ela, P_tipo
            , null, null, null, 'RX'
            , null, null
            , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
      );
   Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   BEGIN  -- Riporta estremi delibera della ritenuta totale su voci registrate con INPUT = 'N'
      P_stp := 'RITENUTA.SCO-06';
      UPDATE CALCOLI_CONTABILI x
         SET (anno_del, numero_del, sede_del, delibera) =
             (select anno_del, numero_del, sede_del, delibera
                from CALCOLI_CONTABILI 
               where ci          = x.ci
                 and voce        = x.voce
                 and sub         = x.sub
                 and riferimento = x.riferimento
                 and estrazione  like 'R%'
                 and estrazione  != 'RX'
                 and rownum      < 2)
       WHERE ci         = P_ci
         and input      = 'N'
         and estrazione = 'RX'
      ;
      Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
/* modifica del 01/12/2004 */
   BEGIN  -- Calcolo ritenute frazionate per riferimento in caso di ritenuta
          -- su progressivo di imponibile con flag.
          -----------------------------------------------------------------
          -- Esegue LOOP su ogni voce di Ritenuta.
      FOR CURR IN
         (select caco.voce
               , caco.sub
               , max(caco.riferimento) riferimento
               , max(caco.competenza)  competenza
               , max(caci.riferimento) riferimento_imp
               , max(caci.competenza)  competenza_imp
            from CALCOLI_CONTABILI          caco
               , CALCOLI_CONTABILI          caci
               , RITENUTE_VOCE              rivo
               , VOCI_ECONOMICHE            voec
           where caco.ci           = P_ci
             and caco.estrazione   like 'R%'
             and caco.estrazione  != 'RX'
             and caci.ci           = caco.ci
             and caci.voce         = rivo.cod_voce_ipn
             and caci.sub          = rivo.sub_voce_ipn
             and rivo.voce         = caco.voce
             and rivo.sub          = caco.sub
             and rivo.val_voce_ipn in ('C','P')     -- 01/12/2004
--             and rivo.val_voce_ipn = 'P'
             and caco.riferimento between nvl(rivo.dal,to_date('2222222','j'))
                                      and nvl(rivo.al,to_date('3333333','j'))
             and caci.riferimento between nvl(rivo.dal,to_date('2222222','j'))
                                      and nvl(rivo.al,to_date('3333333','j'))
             and voec.codice       = rivo.cod_voce_ipn
             and voec.specie       = 'T'      -- flag di frazionamento ritenute
        group by caco.voce, caco.sub, nvl(caci.competenza, caci.riferimento)
         ) LOOP
      P_stp := 'RITENUTA.SCO-07';
         Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
         BEGIN  -- Estrazione ritenute differenziate per la singola voce
                -- con emissione voci Ritenuta ad estrazione "RY"
            SCORPORO_CONTRIBUTI ( P_ci, P_al
                                , P_anno, P_mese, P_mensilita, P_fin_ela, P_tipo
                                , 'RY'
                                , CURR.voce, CURR.sub
                                , nvl(CURR.competenza_imp, CURR.riferimento_imp), CURR.competenza_imp
                                , CURR.riferimento
                                , null, null, null, null
                                , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                                );
         END;
      END LOOP;
   END;
   P_stp := 'RITENUTA.SCO-08';
   Peccmocp9.VOCI_RITENUTA  -- Determinazione voci a RITENUTA "Y" (x Frazionamento Ritenute)
      ( P_ci, P_anno, P_al
            , P_anno, P_mese, P_mensilita, P_fin_ela, P_tipo
            , null, null, null, 'RY'
            , null, null
            , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
      );
   Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   BEGIN  -- Aggiorna la data di Riferimento su voci registrate con INPUT = 'N'
          -- sovrapponendo il campo DATA in cui è stato memorizzato 
          -- il Riferimento della voce originale della ritenuta totale 
      P_stp := 'RITENUTA.SCO-09';
      UPDATE CALCOLI_CONTABILI x
         SET riferimento = data
           , data        = null
       WHERE ci         = P_ci
         and input      = 'N'
         and estrazione = 'RY'
      ;
      Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
/* fine modifica del 01/12/2004 */

   BEGIN  -- Modifica in NEGATIVO Voci Ritenuta registrate con INPUT = 'N' 
          -- eseguito per entrambe le estrazioni 'RX' e 'RY'
      P_stp := 'RITENUTA.SCO-10';
      UPDATE CALCOLI_CONTABILI
         SET input   = 'C'
           , imp     = imp     * -1
           , tar     = tar     * -1
           , ipn_eap = ipn_eap * -1
           , ipn_c   = ipn_c   * -1
           , ipn_s   = ipn_s   * -1
           , ipn_p   = ipn_p   * -1
           , ipn_l   = ipn_l   * -1
           , ipn_e   = ipn_e   * -1
           , ipn_t   = ipn_t   * -1
           , ipn_a   = ipn_a   * -1
           , ipn_ap  = ipn_ap  * -1
       WHERE ci         = P_ci
         and input      = 'N'
         and estrazione in ('RX','RY')
      ;
      Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
   WHEN OTHERS THEN
      Peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
      RAISE FORM_TRIGGER_FAILURE;
END scorporo;

END;
/
