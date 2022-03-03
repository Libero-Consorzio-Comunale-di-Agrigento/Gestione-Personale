CREATE OR REPLACE PACKAGE Peccmore_onaosi IS
/******************************************************************************
 NOME:        PECCMORE_ONAOSI
 DESCRIZIONE: Colcolo ritenuta ONAOSI.
 ANNOTAZIONI: 

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    14/09/2005 ML     Prima emissione.
 1    15/02/2006 NN     Non valorizza la voce se già presente in MOCO e non è una variabile (test P_data).
 1.1  20/07/2006 NN     Attivate variabili anche per gli importi.
 1.2  12/03/2007 AM     DIfferenziati i valori per 2006 e 2007
******************************************************************************/

revisione varchar2(30) := '1.2  12/03/2007';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE Cal_onaosi
( P_ci                NUMBER
, P_anno              NUMBER
, P_riferimento       DATE
, P_riferimento_ona   DATE
, P_voce              VARCHAR2
, P_sub               VARCHAR2
, P_data              DATE
, P_imp        IN OUT NUMBER
-- Parametri per Trace
, p_trc        IN     NUMBER     -- Tipo di Trace
, p_prn        IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas        IN     NUMBER     -- Numero di Passo procedurale
, p_prs        IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp        IN OUT VARCHAR2   -- Step elaborato
, p_tim        IN OUT VARCHAR2   -- Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY Peccmore_onaosi IS
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
   RETURN revisione;
END VERSIONE;

PROCEDURE Cal_onaosi
/******************************************************************************
 NOME:        CALCOLO RITENUTA ONAOSI
 DESCRIZIONE: Calcolo della ritenuta ONAOSI sulla base della nuova circolare del 7/7/2005

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    13/04/2004 MF     Prima emissione.
******************************************************************************/
( P_ci                     NUMBER
, P_anno                   NUMBER
, P_riferimento            DATE
, P_riferimento_ona        DATE
, P_voce                   VARCHAR2
, P_sub                    VARCHAR2
, P_data                   DATE
, P_imp        IN OUT      NUMBER
-- Parametri per Trace
, p_trc IN     NUMBER     -- Tipo di Trace
, p_prn IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas IN     NUMBER     -- Numero di Passo procedurale
, p_prs IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp IN OUT VARCHAR2   -- Step elaborato
, p_tim IN OUT VARCHAR2   -- Time impiegato in secondi
) IS

V_reddito_min           number := 14000;
V_reddito_max           number := 28000;
V_eta_min               number := 33;
V_eta_max               number := 67;
V_imp_1                 Number;
V_imp_2                 Number;
V_imp_3                 Number;
V_imp_4                 Number;

D_gia_liquidato_moco    number;
D_gia_liquidato         number;
D_eta                   number;
D_albo                  number;
D_corso                 varchar2(1);
D_ipn_ac                number;
D_ipn_onaosi_magg       number;
D_reddito               number;


BEGIN 
  BEGIN -- inizializzai valori per l'anno 
  IF to_number(to_char(P_riferimento,'yyyy')) < 2007 THEN
     V_imp_1                 := 1;
     V_imp_2                 := 3;
     V_imp_3                 := 6;
     V_imp_4                 := 10;
  ELSE
     V_imp_1                 := 1.04;
     V_imp_2                 := 3.11;
     V_imp_3                 := 6.22;
     V_imp_4                 := 10.37;

  END IF; 
  END;
-- dbms_output.put_line ('CMORE_ONAOSI P_data '||P_data||' P_voce '||P_voce||' P_riferimento '||P_riferimento);
  BEGIN  -- Verifica periodo già liquidato in altra mensilita'
     P_stp := 'ONAOSI.CAL_ONAOSI-00a';
     SELECT 1, 0
       INTO D_gia_liquidato_moco, P_imp
       FROM movimenti_contabili
      WHERE ci = P_ci
        AND voce = P_voce
        AND sub = P_sub
        AND anno >= to_number(to_char(P_riferimento,'yyyy'))
        AND P_data is null
        AND to_number(to_char(riferimento,'yyyymm')) = 
            to_number(to_char(P_riferimento,'yyyymm'))
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_gia_liquidato_moco := 0;
          P_imp := 0;
     WHEN TOO_MANY_ROWS THEN
          D_gia_liquidato_moco := 1;
          P_imp := 0;
  END;
-- dbms_output.put_line ('CMORE_ONAOSI D_gia_liquidato_moco '||D_gia_liquidato_moco);
 IF D_gia_liquidato_moco = 0 THEN
  BEGIN  -- Verifica periodo già liquidato
     P_stp := 'ONAOSI.CAL_ONAOSI-00b';
     SELECT 1, 0
       INTO D_gia_liquidato, P_imp
       FROM documenti_giuridici x
      WHERE ci = P_ci
        AND evento = 'MOD3'
        AND P_riferimento between dal and nvl(al,to_date('3333333','j'))
        AND del = (select min(del) from documenti_giuridici
                    where ci     = P_ci
                      and evento = 'MOD3'
                      and P_riferimento between dal and nvl(al,to_date('3333333','j'))
                      and scd    = x.scd )
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_gia_liquidato := 0;
          P_imp := 0;
  END;
 IF D_gia_liquidato = 0 THEN
   BEGIN  -- Calcola eta del dipendente
      P_stp := 'ONAOSI.CAL_ONAOSI-01';
      SELECT trunc(months_between(P_riferimento_ona,data_nas)/12)
        INTO D_eta
        FROM RAPPORTI_INDIVIDUALI
       WHERE ci = P_ci
      ;
      Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           D_eta := null;
   END;
 IF D_eta  >= V_eta_max THEN
    BEGIN  -- 67 anni di eta'        
      select 0
        into P_imp
        from documenti_giuridici x
       where ci = P_ci
         and evento = 'ONA'
         and trunc(months_between(P_riferimento_ona,del)/12) >= 30
         and del = (select min(del) from documenti_giuridici
                     where ci     = P_ci
                       and evento = 'ONA'
                       and scd    = x.scd )
       ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN P_imp := V_imp_1;
    END;  -- 67 anni di eta'
 ELSE
   BEGIN  -- Verifica iscrizione all albo
      P_stp := 'ONAOSI.CAL_ONAOSI-02';
      SELECT trunc(months_between(P_riferimento_ona,del)/12)
        INTO D_albo
        FROM documenti_giuridici x
       WHERE ci     = P_ci
         and evento = 'ALBO'
         and del = (select min(del) from documenti_giuridici
                     where ci     = P_ci
                       and evento = 'ALBO'
                       and scd    = x.scd )
      ;
      Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           D_albo := null;
   END;

   IF nvl(D_albo,10) < 5 THEN 
      P_imp := V_imp_1;
   ELSE
     BEGIN  -- Verifica frequenza corso
        P_stp := 'ONAOSI.CAL_ONAOSI-03';
        SELECT 'x'
          INTO D_corso
          FROM documenti_giuridici x
         WHERE ci = P_ci
           AND P_riferimento_ona between dal and nvl(al,to_date('3333333','j'))
           AND dato_a1 = 'SI'
           AND del = (select min(del) from documenti_giuridici
                       where ci     = P_ci
                         and P_riferimento_ona between dal and nvl(al,to_date('3333333','j'))
                         and dato_a1 = 'SI'
                         and scd    = x.scd )
        ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             D_corso := null;
     END;  
     IF D_corso is not null THEN 
        P_imp := V_imp_1;
     ELSE
       BEGIN  -- Estrae Reddito AP
          P_stp := 'ONAOSI.CAL_ONAOSI-04';
          SELECT nvl(sum(nvl(ipn_ac,0)),0)
            INTO D_ipn_ac
            FROM PROGRESSIVI_FISCALI
           WHERE ci = P_ci
             AND anno = P_anno -1
             AND mese = 12
             AND mensilita = (SELECT max(mensilita)
                                FROM MENSILITA
                               WHERE mese = 12
                                 AND tipo IN ('A','N','S'))
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
               D_ipn_ac := 0;
       END;
       BEGIN  -- Estrae Maggiorazione Onaosi
          P_stp := 'ONAOSI.CAL_ONAOSI-05';
          SELECT nvl(ipn_onaosi_magg,0)
            INTO D_ipn_onaosi_magg
            FROM informazioni_extracontabili
           WHERE ci = P_ci
             AND anno = P_anno
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
               D_ipn_onaosi_magg := 0;
       END;
       D_reddito := D_ipn_ac + D_ipn_onaosi_magg;
       IF D_reddito < V_reddito_min THEN
          P_imp := V_imp_1;
       ELSIF D_eta < V_eta_min THEN
             IF D_reddito > V_reddito_max THEN
                P_imp := V_imp_4;
             ELSE
                P_imp := V_imp_2;
             END IF;
       ELSIF D_eta < V_eta_max THEN 
             IF D_reddito > v_reddito_max THEN
                P_imp := V_imp_4;
             ELSE
                P_imp := V_imp_3;
             END IF;
       END IF;    -- reddito minore
     END IF;      -- corso
   END IF;        -- albo
 END IF;          -- 67 anni
 END IF;          -- gia liquidato
 END IF;          -- gia liquidato moco
END cal_onaosi;
END;
/
