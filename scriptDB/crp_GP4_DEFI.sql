CREATE OR REPLACE PACKAGE GP4_DEFI IS
/******************************************************************************
 NOME:        GP4_DEFI
 DESCRIZIONE:
 ANNOTAZIONI: Versione V1.0
 REVISIONI:   Nadia - martedi 4 gennaio 2005 10.00.07
 Rev.  Data        Autore  Descrizione
 ----  ----------  ------  ----------------------------------------------------
 0     __/__/____  __      Creazione.
******************************************************************************/
revisione varchar2(30) := 'V1.0';
Function  VERSIONE
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 RITORNA:     stringa VARCHAR2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
RETURN VARCHAR2;
Pragma restrict_references(VERSIONE, WNDS, WNPS);
Procedure initialize
( P_data IN DATE
, Requery IN VARCHAR2 DEFAULT 'NO');
Pragma restrict_references(initialize, WNDS);
Function init
( P_data IN DATE)
RETURN VARCHAR2;
Pragma restrict_references(init, WNDS);
Function get_val_conv_ded_div
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_ded_div, WNDS);
Function get_val_conv_ded_fam
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_ded_fam, WNDS);
Function get_ded_fis_base
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_ded_fis_base, WNDS);
Function get_ded_fis_agg
( P_data IN DATE
, P_tipo_spese IN VARCHAR2
, P_scaglione IN NUMBER)
RETURN NUMBER;
Pragma restrict_references(get_ded_fis_agg, WNDS);
Function get_val_conv_det_fam
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_det_fam, WNDS);
Function get_val_conv_det_fig
( P_data IN DATE
, P_figli IN NUMBER)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_det_fig, WNDS);
Function get_val_conv_det_agg_fig
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_det_agg_fig, WNDS);
Function get_val_min_det_dip
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_min_det_dip, WNDS);
Function get_val_min_det_pen1
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_min_det_pen1, WNDS);
Function get_val_min_det_pen2
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_min_det_pen2, WNDS);
Function get_val_conv_det_dip
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_det_dip, WNDS);
Function get_val_conv_det_pen1
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_det_pen1, WNDS);
Function get_val_conv_det_pen2
( P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_det_pen2, WNDS);
Function get_imp_aum
( P_anno       IN NUMBER
, P_mese       IN NUMBER
, P_condizione IN VARCHAR2
, P_specie     IN VARCHAR2
, P_scaglione  IN NUMBER
, P_numero     IN NUMBER
, P_imponibile IN NUMBER
, P_conguaglio IN NUMBER
, P_divisore   IN NUMBER DEFAULT 12
, P_ci         IN NUMBER
, P_campo      IN VARCHAR2
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER;
/*
Function get_importo
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_scaglione IN NUMBER
, P_numero IN NUMBER
, P_imponibile IN NUMBER
, P_conguaglio IN NUMBER
, P_divisore IN NUMBER DEFAULT 12
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER;
*/
/*
Function get_aumento
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_scaglione IN NUMBER
, P_numero IN NUMBER
, P_imponibile IN NUMBER
, P_conguaglio IN NUMBER
, P_divisore IN NUMBER DEFAULT 12
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER;
*/
-- Pragma restrict_references(get_importo, WNDS);
Function get_nr_scaglione
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_numero IN NUMBER
, P_conguaglio IN NUMBER
, P_scaglione IN NUMBER
, P_imponibile IN NUMBER
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER;
FUNCTION get_det_per_div
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_scaglione IN NUMBER
, P_numero IN NUMBER
, P_imponibile IN NUMBER
, P_conguaglio IN NUMBER
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER;
FUNCTION get_diff_det_con
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_numero IN NUMBER
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER;
FUNCTION get_scaglione_10
( P_data IN DATE
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER;
END GP4_DEFI;
/
CREATE OR REPLACE PACKAGE BODY GP4_DEFI IS
D_val_conv_ded_div   NUMBER;
D_val_conv_ded_fam   NUMBER;
D_ded_fis_base   NUMBER;
D_val_conv_det_fam  NUMBER;
D_val_conv_det_fig  NUMBER;
D_val_conv_det_agg_fig  NUMBER;
D_val_min_det_dip NUMBER;
D_val_min_det_pen1 NUMBER;
D_val_min_det_pen2 NUMBER;
D_val_conv_det_dip  NUMBER;
D_val_conv_det_pen1  NUMBER;
D_val_conv_det_pen2  NUMBER;
D_data   DATE;
Function  VERSIONE
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 RITORNA:     stringa VARCHAR2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
RETURN VARCHAR2
IS
BEGIN
   RETURN revisione;
END VERSIONE;
Procedure initialize
( P_data IN DATE
, Requery IN VARCHAR2 DEFAULT 'NO')
IS
BEGIN
   IF D_data  != P_data OR D_data is null
   OR Requery != 'NO'
   THEN
      D_data := P_data;
      select val_conv_ded
           , val_conv_ded_fam
           , ded_fis_base
           , val_conv_det_fam
           , val_conv_det_agg_fig
           , val_conv_det_dip
           , val_conv_det_pen1
           , val_conv_det_pen2
           , val_min_det_dip
           , val_min_det_pen1
           , val_min_det_pen2
        into D_val_conv_ded_div
           , D_val_conv_ded_fam
           , D_ded_fis_base
           , D_val_conv_det_fam
           , D_val_conv_det_agg_fig
           , D_val_conv_det_dip
           , D_val_conv_det_pen1
           , D_val_conv_det_pen2
           , D_val_min_det_dip
           , D_val_min_det_pen1
           , D_val_min_det_pen2
        from validita_fiscale
       where P_data BETWEEN dal
                        AND nvl(al ,TO_DATE(3333333,'j'))
      ;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      D_val_conv_ded_div := null;
      D_val_conv_ded_fam := null;
      D_ded_fis_base     := null;
      D_val_conv_det_fam := null;
      D_val_conv_det_fig := null;
      D_val_conv_det_dip := null;
      D_val_conv_det_pen1 := null;
      D_val_conv_det_pen2 := null;
      D_val_min_det_dip   := null;
      D_val_min_det_pen1  := null;
      D_val_min_det_pen2  := null;
END initialize;
Function init
( P_data IN DATE)
RETURN VARCHAR2
IS
BEGIN
   Initialize(P_data, 'YES');
   RETURN null;
END init;
Function get_val_conv_ded_div
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_conv_ded_div;
END get_val_conv_ded_div;
Function get_val_conv_ded_fam
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_conv_ded_fam;
END get_val_conv_ded_fam;
Function get_ded_fis_base
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_ded_fis_base;
END get_ded_fis_base;
Function get_ded_fis_agg
( P_data IN DATE
, P_tipo_spese IN VARCHAR2
, P_scaglione IN NUMBER)
RETURN NUMBER
IS
D_val_ded_fis_agg NUMBER;
BEGIN
   select defi.importo
     into D_val_ded_fis_agg
     from detrazioni_fiscali  defi
    where P_data BETWEEN defi.dal
                     AND nvl(defi.al ,TO_DATE(3333333,'j'))
          and defi.tipo = P_tipo_spese
          and decode( sign( P_scaglione - 50)
                    , -1, P_scaglione
                        , decode( P_scaglione
                                , 99, 99
                                    , P_scaglione - 50
                                )
                    ) = defi.scaglione
   ;
   RETURN D_val_ded_fis_agg;
END get_ded_fis_agg;
Function get_val_conv_det_fam
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_conv_det_fam;
END get_val_conv_det_fam;
Function get_val_conv_det_fig
( P_data IN DATE
, P_figli IN NUMBER)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
--   IF P_figli > 1 THEN
   D_val_conv_det_fig := D_val_conv_det_fam +
                       ( D_val_conv_det_agg_fig * P_figli);
--   END IF;
   RETURN D_val_conv_det_fig;
END get_val_conv_det_fig;
Function get_val_conv_det_agg_fig
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_conv_det_agg_fig;
END get_val_conv_det_agg_fig;
Function get_val_conv_det_dip
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_conv_det_dip;
END get_val_conv_det_dip;
Function get_val_min_det_dip
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_min_det_dip;
END get_val_min_det_dip;
Function get_val_min_det_pen1
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_min_det_pen1;
END get_val_min_det_pen1;
Function get_val_min_det_pen2
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_min_det_pen2;
END get_val_min_det_pen2;
Function get_val_conv_det_pen1
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_conv_det_pen1;
END get_val_conv_det_pen1;
Function get_val_conv_det_pen2
( P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   Initialize(P_data);
   RETURN D_val_conv_det_pen2;
END get_val_conv_det_pen2;
Function get_imp_aum
( P_anno        IN NUMBER
, P_mese        IN NUMBER
, P_condizione  IN VARCHAR2
, P_specie      IN VARCHAR2
, P_scaglione   IN NUMBER
, P_numero      IN NUMBER
, P_imponibile  IN NUMBER
, P_conguaglio  IN NUMBER
, P_divisore    IN NUMBER DEFAULT 12
, P_ci          IN NUMBER
, P_campo       IN VARCHAR2
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER
IS
D_mesi_irpef NUMBER;
D_importo    NUMBER;
D_aumento    NUMBER;
BEGIN
   IF     P_numero is null
   AND (  P_specie = 'CN'
       OR P_specie = 'FG'
       OR P_specie = 'FD'
       OR P_specie = 'FM'
       OR P_specie = 'MD'
       OR P_specie = 'FH'
       OR P_specie = 'HD'
       OR P_specie = 'AL'
       )
   THEN
      D_importo := 0;  -- Sempre 0 se si tratta di carico Familare senza NUMERO
      D_aumento := 0;
   ELSE
    D_mesi_irpef := GP4_RARE.get_mesi_deduzione(P_ci,last_day( to_date( to_char(P_anno)||'/'||
                                                               to_char(P_mese),'yyyy/mm')));
    BEGIN
-- dbms_output.put_line('????Anno '||P_anno||'/'||P_mese||' P_condizione '||P_condizione||' P_specie '||P_specie);
-- dbms_output.put_line('????P_scaglione '||P_scaglione||' P_numero '||P_numero||' P_imponibile '||P_imponibile||' P_conguaglio '||P_conguaglio);
-- dbms_output.put_line('????P_divisore '||P_divisore||' mesi irpef '||D_mesi_irpef||' P_ci '||P_ci);
     BEGIN
       select e_round(defi.importo / P_divisore,'I')
            , nvl(aumento,0)
         into d_importo,d_aumento
         from detrazioni_fiscali defi
        where defi.codice = P_condizione
          and defi.tipo   = P_specie
          and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
               between defi.dal
                   and nvl(defi.al ,to_date(3333333,'j'))
          and  P_scaglione != 99
          and defi.scaglione = P_scaglione
          and nvl(defi.numero,0) = nvl(P_numero,0)
          and p_conguaglio = 0
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         BEGIN
           select e_round(defi.importo / P_divisore,'I')
                , nvl(aumento,0)
             into d_importo,d_aumento
             from detrazioni_fiscali defi
            where defi.codice = P_condizione
              and defi.tipo   = P_specie
              and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
                   between defi.dal
                       and nvl(defi.al ,to_date(3333333,'j'))
              and defi.scaglione = P_scaglione - 50
              and nvl(defi.numero,0) = nvl(P_numero,0)
              and P_scaglione between 51
                                  and 98
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             BEGIN
                select e_round(defi.importo / P_divisore,'I')
                     , nvl(aumento,0)
                  into d_importo,d_aumento
                  from detrazioni_fiscali defi
                 where defi.codice = P_condizione
                   and defi.tipo   = P_specie
                   and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
                       between defi.dal
                           and nvl(defi.al ,to_date(3333333,'j'))
                   and nvl(P_scaglione,99) = 99
                   and nvl(defi.numero,0) = nvl(P_numero,0)
                   and defi.scaglione not between 51
                                              and 98
                   and nvl(defi.imponibile,0) = (select nvl(max(d.imponibile),0)
                                                   from detrazioni_fiscali d
                                                  where d.codice = P_condizione
                                                    and d.tipo   = P_specie
                                                    and d.scaglione not between 51
                                                                            and 98
                                                    and nvl(d.numero,0) = nvl(P_numero,0)
                                                    and last_day( to_date( to_char(P_anno)||'/'||
                                                                to_char(P_mese),'yyyy/mm'))
                                                        between d.dal
                                                            and nvl(d.al ,to_date(3333333,'j'))
                                                    and nvl(d.imponibile,0) <= decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
                                                )
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 BEGIN
                   select e_round(defi.importo / P_divisore,'I')
                        , nvl(aumento,0)
                     into d_importo,d_aumento
                     from detrazioni_fiscali defi
                    where defi.codice = P_condizione
                      and defi.tipo   = P_specie
                      and last_day( to_date( to_char(P_anno)||'/'||
                                    to_char(P_mese),'yyyy/mm'))
                          between defi.dal
                              and nvl(defi.al ,to_date(3333333,'j'))
                      and P_scaglione is not null
                      and nvl(defi.numero,0) = nvl(P_numero,0)
                      and p_conguaglio != 0
                      and defi.scaglione not between 51
                                                 and 98
                      and nvl(defi.imponibile,0) = (select nvl(max(d.imponibile),0)
                                                      from detrazioni_fiscali d
                                                     where d.codice = P_condizione
                                                       and d.tipo   = P_specie
                                                       and d.scaglione not between 51
                                                                               and 98
                                                       and nvl(d.numero,0) = nvl(P_numero,0)
                                                       and last_day( to_date( to_char(P_anno)||'/'||
                                                                     to_char(P_mese),'yyyy/mm'))
                                                           between d.dal
                                                               and nvl(d.al ,to_date(3333333,'j'))
                                                       and nvl(d.imponibile,0) <= decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
                                                   )
                   ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     d_importo := 0;
                 END;
             END;
         END;
     END;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        P_stp := '!!! #'||TO_CHAR(P_ci)||' '||P_condizione||' '||P_specie;
        Peccmore.log_trace(6,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmore.w_errore := 'P05342';  -- Segnalazione Detrazioni/Deduzioni Incongruente
    END;
   END IF;
   IF P_campo = 'A' THEN
        RETURN D_aumento;
   ELSE RETURN D_importo;
   END IF;
END get_imp_aum;
/*
Function get_importo
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_scaglione IN NUMBER
, P_numero IN NUMBER
, P_imponibile IN NUMBER
, P_conguaglio IN NUMBER
, P_divisore IN NUMBER DEFAULT 12
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER
IS
D_mesi_irpef NUMBER;
D_importo    NUMBER;
BEGIN
   IF     P_numero is null
   AND (  P_specie = 'CN'
       OR P_specie = 'FG'
       OR P_specie = 'FD'
       OR P_specie = 'FM'
       OR P_specie = 'MD'
       OR P_specie = 'FH'
       OR P_specie = 'HD'
       OR P_specie = 'AL'
       )
   THEN
      D_importo := 0;  -- Sempre 0 se si tratta di carico Familare senza NUMERO
   ELSE
    D_mesi_irpef := GP4_RARE.get_mesi_deduzione(P_ci,last_day( to_date( to_char(P_anno)||'/'||
                                                               to_char(P_mese),'yyyy/mm')));
    BEGIN
-- dbms_output.put_line('????Anno '||P_anno||'/'||P_mese||' P_condizione '||P_condizione||' P_specie '||P_specie);
-- dbms_output.put_line('????P_scaglione '||P_scaglione||' P_numero '||P_numero||' P_imponibile '||P_imponibile||' P_conguaglio '||P_conguaglio);
-- dbms_output.put_line('????P_divisore '||P_divisore||' mesi irpef '||D_mesi_irpef||' P_ci '||P_ci);
     BEGIN
       select e_round(defi.importo / P_divisore,'I')
         into d_importo
         from detrazioni_fiscali defi
        where defi.codice = P_condizione
          and defi.tipo   = P_specie
          and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
               between defi.dal
                   and nvl(defi.al ,to_date(3333333,'j'))
          and  P_scaglione != 99
          and defi.scaglione = P_scaglione
          and nvl(defi.numero,0) = nvl(P_numero,0)
          and p_conguaglio = 0
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         BEGIN
           select e_round(defi.importo / P_divisore,'I')
             into d_importo
             from detrazioni_fiscali defi
            where defi.codice = P_condizione
              and defi.tipo   = P_specie
              and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
                   between defi.dal
                       and nvl(defi.al ,to_date(3333333,'j'))
              and defi.scaglione = P_scaglione - 50
              and nvl(defi.numero,0) = nvl(P_numero,0)
              and P_scaglione between 51
                                  and 98
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             BEGIN
               select e_round(defi.importo / P_divisore,'I')
                 into d_importo
                 from detrazioni_fiscali defi
                 where defi.codice = P_condizione
                   and defi.tipo   = P_specie
                   and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
                       between defi.dal
                           and nvl(defi.al ,to_date(3333333,'j'))
                   and nvl(P_scaglione,99) = 99
                   and nvl(defi.numero,0) = nvl(P_numero,0)
                   and defi.scaglione not between 51
                                              and 98
                   and nvl(defi.imponibile,0) = (select nvl(max(d.imponibile),0)
                                                   from detrazioni_fiscali d
                                                  where d.codice = P_condizione
                                                    and d.tipo   = P_specie
                                                    and d.scaglione not between 51
                                                                            and 98
                                                    and nvl(d.numero,0) = nvl(P_numero,0)
                                                    and last_day( to_date( to_char(P_anno)||'/'||
                                                                to_char(P_mese),'yyyy/mm'))
                                                        between d.dal
                                                            and nvl(d.al ,to_date(3333333,'j'))
                                                    and nvl(d.imponibile,0) <= decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
                                                )
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 BEGIN
                   select e_round(defi.importo / P_divisore,'I')
                     into d_importo
                     from detrazioni_fiscali defi
                    where defi.codice = P_condizione
                      and defi.tipo   = P_specie
                      and last_day( to_date( to_char(P_anno)||'/'||
                                    to_char(P_mese),'yyyy/mm'))
                          between defi.dal
                              and nvl(defi.al ,to_date(3333333,'j'))
                      and P_scaglione is not null
                      and nvl(defi.numero,0) = nvl(P_numero,0)
                      and p_conguaglio != 0
                      and defi.scaglione not between 51
                                                 and 98
                      and nvl(defi.imponibile,0) = (select nvl(max(d.imponibile),0)
                                                      from detrazioni_fiscali d
                                                     where d.codice = P_condizione
                                                       and d.tipo   = P_specie
                                                       and d.scaglione not between 51
                                                                               and 98
                                                       and nvl(d.numero,0) = nvl(P_numero,0)
                                                       and last_day( to_date( to_char(P_anno)||'/'||
                                                                     to_char(P_mese),'yyyy/mm'))
                                                           between d.dal
                                                               and nvl(d.al ,to_date(3333333,'j'))
                                                       and nvl(d.imponibile,0) <= decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
                                                   )
                   ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     d_importo := 0;
                 END;
             END;
         END;
     END;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        P_stp := '!!! #'||TO_CHAR(P_ci)||' '||P_condizione||' '||P_specie;
        Peccmore.log_trace(6,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmore.w_errore := 'P05342';  -- Segnalazione Detrazioni/Deduzioni Incongruente
    END;
   END IF;
   RETURN D_importo;
END get_importo;
*/
/*
Function get_aumento
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_scaglione IN NUMBER
, P_numero IN NUMBER
, P_imponibile IN NUMBER
, P_conguaglio IN NUMBER
, P_divisore IN NUMBER DEFAULT 12
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER
IS
D_mesi_irpef NUMBER;
D_aumento    NUMBER;
BEGIN
   IF     P_numero is null
   AND (  P_specie = 'CN'
       OR P_specie = 'FG'
       OR P_specie = 'FD'
       OR P_specie = 'FM'
       OR P_specie = 'MD'
       OR P_specie = 'FH'
       OR P_specie = 'HD'
       OR P_specie = 'AL'
       )
   THEN
      D_aumento := 0;  -- Sempre 0 se si tratta di carico Familare senza NUMERO
   ELSE
    D_mesi_irpef := GP4_RARE.get_mesi_deduzione(P_ci,last_day( to_date( to_char(P_anno)||'/'||
                                                               to_char(P_mese),'yyyy/mm')));
    BEGIN
-- dbms_output.put_line('????Anno '||P_anno||'/'||P_mese||' P_condizione '||P_condizione||' P_specie '||P_specie);
-- dbms_output.put_line('????P_scaglione '||P_scaglione||' P_numero '||P_numero||' P_imponibile '||P_imponibile||' P_conguaglio '||P_conguaglio);
-- dbms_output.put_line('????P_divisore '||P_divisore||' mesi irpef '||D_mesi_irpef||' P_ci '||P_ci);
     BEGIN
       select nvl(aumento,0)
         into d_aumento
         from detrazioni_fiscali defi
        where defi.codice = P_condizione
          and defi.tipo   = P_specie
          and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
               between defi.dal
                   and nvl(defi.al ,to_date(3333333,'j'))
          and  P_scaglione != 99
          and defi.scaglione = P_scaglione
          and nvl(defi.numero,0) = nvl(P_numero,0)
          and p_conguaglio = 0
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         BEGIN
           select nvl(aumento,0)
             into d_aumento
             from detrazioni_fiscali defi
            where defi.codice = P_condizione
              and defi.tipo   = P_specie
              and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
                   between defi.dal
                       and nvl(defi.al ,to_date(3333333,'j'))
              and defi.scaglione = P_scaglione - 50
              and nvl(defi.numero,0) = nvl(P_numero,0)
              and P_scaglione between 51
                                  and 98
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             BEGIN
               select nvl(aumento,0)
                 into d_aumento
                 from detrazioni_fiscali defi
                 where defi.codice = P_condizione
                   and defi.tipo   = P_specie
                   and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
                       between defi.dal
                           and nvl(defi.al ,to_date(3333333,'j'))
                   and nvl(P_scaglione,99) = 99
                   and nvl(defi.numero,0) = nvl(P_numero,0)
                   and defi.scaglione not between 51
                                              and 98
                   and nvl(defi.imponibile,0) = (select nvl(max(d.imponibile),0)
                                                   from detrazioni_fiscali d
                                                  where d.codice = P_condizione
                                                    and d.tipo   = P_specie
                                                    and d.scaglione not between 51
                                                                            and 98
                                                    and nvl(d.numero,0) = nvl(P_numero,0)
                                                    and last_day( to_date( to_char(P_anno)||'/'||
                                                                to_char(P_mese),'yyyy/mm'))
                                                        between d.dal
                                                            and nvl(d.al ,to_date(3333333,'j'))
                                                    and nvl(d.imponibile,0) <= decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
                                                )
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 BEGIN
                   select nvl(aumento,0)
                     into d_aumento
                     from detrazioni_fiscali defi
                    where defi.codice = P_condizione
                      and defi.tipo   = P_specie
                      and last_day( to_date( to_char(P_anno)||'/'||
                                    to_char(P_mese),'yyyy/mm'))
                          between defi.dal
                              and nvl(defi.al ,to_date(3333333,'j'))
                      and P_scaglione is not null
                      and nvl(defi.numero,0) = nvl(P_numero,0)
                      and p_conguaglio != 0
                      and defi.scaglione not between 51
                                                 and 98
                      and nvl(defi.imponibile,0) = (select nvl(max(d.imponibile),0)
                                                      from detrazioni_fiscali d
                                                     where d.codice = P_condizione
                                                       and d.tipo   = P_specie
                                                       and d.scaglione not between 51
                                                                               and 98
                                                       and nvl(d.numero,0) = nvl(P_numero,0)
                                                       and last_day( to_date( to_char(P_anno)||'/'||
                                                                     to_char(P_mese),'yyyy/mm'))
                                                           between d.dal
                                                               and nvl(d.al ,to_date(3333333,'j'))
                                                       and nvl(d.imponibile,0) <= decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
                                                   )
                   ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     d_aumento := 0;
                 END;
             END;
         END;
     END;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        P_stp := '!!! #'||TO_CHAR(P_ci)||' '||P_condizione||' '||P_specie;
        Peccmore.log_trace(6,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmore.w_errore := 'P05342';  -- Segnalazione Detrazioni/Deduzioni Incongruente
    END;
   END IF;
   RETURN D_aumento;
END get_aumento;
*/
Function get_nr_scaglione
( P_anno       IN NUMBER
, P_mese       IN NUMBER
, P_condizione IN VARCHAR2
, P_specie     IN VARCHAR2
, P_numero     IN NUMBER
, P_conguaglio IN NUMBER
, p_scaglione  IN NUMBER
, P_imponibile IN NUMBER
, P_ci         IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER
IS
D_mesi_irpef    NUMBER;
D_nr_scaglione  NUMBER;
BEGIN
  D_mesi_irpef := GP4_RARE.get_mesi_deduzione(P_ci,last_day( to_date( to_char(P_anno)||'/'||
                                                             to_char(P_mese),'yyyy/mm')));
-- dbms_output.put_line('P_imponibile '||P_imponibile||' P_conguaglio '||P_conguaglio);
     IF P_Scaglione between 51 and 98
        THEN D_nr_scaglione := P_scaglione;
     ELSE
        BEGIN
          select nvl(max(scaglione),0)
            into d_nr_scaglione
            from detrazioni_fiscali defi
           where defi.codice = P_condizione
             and defi.tipo   = P_specie
             and last_day( to_date( to_char(P_anno)||'/'||
                                    to_char(P_mese),'yyyy/mm'))
                  between defi.dal
                      and nvl(defi.al ,to_date(3333333,'j'))
             and nvl(defi.numero,0) = nvl(P_numero,0)
             and nvl(defi.imponibile,0) < decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
          ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN D_nr_scaglione := 0;
        END;
     END IF;
   RETURN D_nr_scaglione;
END get_nr_scaglione;
Function get_det_per_div
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_scaglione IN NUMBER
, P_numero IN NUMBER
, P_imponibile IN NUMBER
, P_conguaglio IN NUMBER
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER
IS
D_mesi_irpef        NUMBER;
D_diff_scaglioni    NUMBER;
D_imp_scaglione     NUMBER;
D_det_per_div       NUMBER;
D_scaglione         NUMBER;
BEGIN
    D_mesi_irpef := GP4_RARE.get_mesi_deduzione(P_ci,last_day( to_date( to_char(P_anno)||'/'||
                                                               to_char(P_mese),'yyyy/mm')));
-- dbms_output.put_line('P_condizione '||P_condizione||' P_specie '||P_specie||' P_scaglione '||P_scaglione||' P_numero '||P_numero);
    BEGIN
     BEGIN
       select nvl(defi2.imponibile,0) - nvl(defi.imponibile,0)
            , nvl(defi2.imponibile,0)
            , defi.scaglione
         into d_diff_scaglioni,d_imp_scaglione,d_scaglione
         from detrazioni_fiscali defi
            , detrazionI_fiscali defi2
        where defi.codice = P_condizione
          and defi.tipo   = P_specie
          and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
               between defi.dal
                   and nvl(defi.al ,to_date(3333333,'j'))
          and nvl(defi.numero,0) = nvl(P_numero,0)
          and defi.scaglione not between 51
                                     and 98
          and defi2.codice = P_condizione
          and defi2.tipo   = P_specie
          and defi2.dal    = defi.dal
          and (    (    P_scaglione != 99
                    and defi.scaglione in (0,10,20,30)
                    and defi.scaglione = trunc(P_scaglione/10)*10
                   )
               or  (    P_scaglione = 99
                   and nvl(defi.imponibile,0) = (select nvl(max(d.imponibile),0)
                                                   from detrazioni_fiscali d
                                                  where d.codice = P_condizione
                                                    and d.tipo   = P_specie
                                                    and scaglione in (0,10,20,30)
                                                    and defi.scaglione not between 51
                                                                               and 98
                                                    and nvl(d.numero,0) = nvl(P_numero,0)
                                                    and last_day( to_date( to_char(P_anno)||'/'||
                                                                to_char(P_mese),'yyyy/mm'))
                                                        between d.dal
                                                            and nvl(d.al ,to_date(3333333,'j'))
                                                    and nvl(d.imponibile,0) <= decode(P_conguaglio,0,P_imponibile * D_mesi_irpef,P_imponibile)
                                                )
                    )
              )
          and defi2.scaglione = defi.scaglione + 10
          and nvl(defi2.numero,0) = nvl(P_numero,0)
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            d_diff_scaglioni := 0;
            d_imp_scaglione  := 0;
            d_scaglione      := 0;
     END;
     D_det_per_div := 0;
-- dbms_output.put_line('d_diff_scaglioni '||d_diff_scaglioni||' d_imp_scaglione '||d_imp_scaglione||' d_scaglione '||d_scaglione||' P_imponibile '||P_imponibile||' D_mesi_irpef '||D_mesi_irpef);
     IF d_scaglione in (10,20)
        THEN
           BEGIN
             select greatest
                    ( 0
                    , least
                     ( trunc
                       ( ( D_imp_scaglione
                          - (   P_imponibile * decode(P_conguaglio,0,D_mesi_irpef,1) )
                            ) / D_diff_scaglioni * 100
                         , 2
                       )
                     , 100
                     )
                   )
              into D_det_per_div
              from dual;
           END ;
           IF D_scaglione = 10
              THEN d_det_per_div := d_det_per_div + 1000;
           END IF;
        ELSE
          D_det_per_div := 100;
     END IF;
     IF d_scaglione = 0 AND P_specie = 'CN' THEN
       BEGIN
-- dbms_output.put_line('--------------------------- D_diff_scaglioni '||D_diff_scaglioni);
          select greatest
                  ( 0
                  , least
                   ( trunc
                     ( (      P_imponibile * decode(P_conguaglio,0,D_mesi_irpef,1)
                          ) / D_diff_scaglioni * 100
                       , 2
                     )
                   , 100
                   )
                 )
            into D_det_per_div
            from dual;
       END ;
     END IF;
-- dbms_output.put_line('D_det_per_div '||D_det_per_div);
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        P_stp := '!!! #'||TO_CHAR(P_ci)||' '||P_condizione||' '||P_specie;
        Peccmore.log_trace(6,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmore.w_errore := 'P05342';  -- Segnalazione Detrazioni/Deduzioni Incongruente
    END;
   RETURN D_det_per_div;
END get_det_per_div;
Function get_diff_det_con
( P_anno IN NUMBER
, P_mese IN NUMBER
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_numero IN NUMBER
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER
IS
D_diff_det_con  NUMBER;
BEGIN
  BEGIN
     BEGIN
       select nvl(defi.importo,0) - nvl(defi2.importo,0)
         into d_diff_det_con
         from detrazioni_fiscali defi
            , detrazionI_fiscali defi2
        where defi.codice = P_condizione
          and defi.tipo   = P_specie
          and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
               between defi.dal
                   and nvl(defi.al ,to_date(3333333,'j'))
          and nvl(defi.numero,0) = nvl(P_numero,0)
          and defi.scaglione = 0
          and defi2.codice = P_condizione
          and defi2.tipo   = P_specie
          and defi2.dal    = defi.dal
          and defi2.scaglione = 10
          and nvl(defi2.numero,0) = nvl(P_numero,0)
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            d_diff_det_con := 0;
     END;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        P_stp := '!!! #'||TO_CHAR(P_ci)||' '||P_condizione||' '||P_specie;
        Peccmore.log_trace(6,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmore.w_errore := 'P05342';  -- Segnalazione Detrazioni/Deduzioni Incongruente
    END;
   RETURN D_diff_det_con;
END get_diff_det_con;
Function get_scaglione_10
( P_data IN DATE
, P_condizione IN VARCHAR2
, P_specie IN VARCHAR2
, P_ci IN NUMBER
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
)
RETURN NUMBER
IS
D_valore    NUMBER;
BEGIN
-- dbms_output.put_line('????Anno '||P_anno||'/'||P_mese||' P_condizione '||P_condizione||' P_specie '||P_specie);
-- dbms_output.put_line('????P_scaglione '||P_scaglione||' P_numero '||P_numero||' P_imponibile '||P_imponibile||' P_conguaglio '||P_conguaglio);
-- dbms_output.put_line('????P_divisore '||P_divisore||' mesi irpef '||D_mesi_irpef||' P_ci '||P_ci);
     BEGIN
       select imponibile
         into d_valore
         from detrazioni_fiscali defi
        where defi.codice = P_condizione
          and defi.tipo   = P_specie
          and P_data between defi.dal
                         and nvl(defi.al ,to_date(3333333,'j'))
          and defi.scaglione = 10
       ;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        P_stp := '!!! #'||TO_CHAR(P_ci)||' '||P_condizione||' '||P_specie;
        Peccmore.log_trace(6,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmore.w_errore := 'P05342';  -- Segnalazione Detrazioni/Deduzioni Incongruente
    END;
   RETURN D_valore;
END get_scaglione_10;
END GP4_DEFI;
/
