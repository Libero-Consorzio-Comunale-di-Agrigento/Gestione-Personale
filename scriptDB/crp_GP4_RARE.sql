CREATE OR REPLACE PACKAGE GP4_RARE IS
/******************************************************************************
 NOME:        GP4_RARE
 DESCRIZIONE: Funzioni di gestione del Rapproto retributivo dell'Individuo.
 ANNOTAZIONI: Versione V1.0
 REVISIONI:   Nadia - martedi 18 gennaio 2005 10.22.42
 Rev.  Data        Autore  Descrizione
 ----  ----------  ------  ----------------------------------------------------
 0     __/__/____  __      Creazione.
******************************************************************************/
revisione varchar2(30) := 'V1.0';
D_data   DATE;
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
/******************************************************************************
 NOME:        initialize
 DESCRIZIONE: Inizializza i dati del Rapporto retributivo sulle variabili di Package.
******************************************************************************/
( P_ci IN NUMBER
, Requery IN VARCHAR2 DEFAULT 'NO');
Pragma restrict_references(initialize, WNDS);
Function init
/******************************************************************************
 NOME:        init
 DESCRIZIONE: Funzione richiamabile da SELECT per inizializzare le variabili di Package.
******************************************************************************/
( P_ci IN NUMBER)
RETURN VARCHAR2;
Pragma restrict_references(init, WNDS);
Procedure VAFI_initialize
/******************************************************************************
 NOME:        VAFI_initialize
 DESCRIZIONE: Inizializzazione dei valori di Validita Fiscale sulle variabili di Package.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE);
Pragma restrict_references(VAFI_initialize, WNDS);
Procedure set_conguaglio
/******************************************************************************
 NOME:        set_conguaglio
 DESCRIZIONE: Funzione Privata richiamata da "is_mese-conguaglio".
              Memorizza il valore di Conguaglio individuale per le funzioni locali a cui interessa:
              - get_giorni_detrazioni
              - get_mesi_detrazioni
******************************************************************************/
( P_ci IN NUMBER
, P_valore IN NUMBER);
Pragma restrict_references(set_conguaglio, WNDS);
Function is_mese_conguaglio
/******************************************************************************
 NOME:        is_mese_conguaglio
 DESCRIZIONE: Ritorna TRUE se e mese di conguaglio per l'individuo.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_tipo IN VARCHAR2 DEFAULT null
, P_conguaglio IN NUMBER DEFAULT null)
RETURN BOOLEAN;
Pragma restrict_references(is_mese_conguaglio, WNDS);
Function get_spese
( P_ci IN NUMBER)
RETURN NUMBER;
Pragma restrict_references(get_spese, WNDS);
Function get_tipo_spese
( P_ci IN NUMBER)
RETURN VARCHAR2;
Pragma restrict_references(get_tipo_spese, WNDS);
Function get_attribuzione_spese
( P_ci IN NUMBER)
RETURN NUMBER;
Pragma restrict_references(get_attribuzione_spese, WNDS);
Function get_ulteriori
( P_ci IN NUMBER)
RETURN NUMBER;
Pragma restrict_references(get_ulteriori, WNDS);
Function get_tipo_ulteriori
( P_ci IN NUMBER)
RETURN VARCHAR2;
Pragma restrict_references(get_tipo_ulteriori, WNDS);
Function get_posizione_inail
( P_ci IN NUMBER)
RETURN VARCHAR2;
Pragma restrict_references(get_posizione_inail, WNDS);
Function get_data_inail
( P_ci IN NUMBER)
RETURN DATE;
Pragma restrict_references(get_data_inail, WNDS);
Function get_istituto
( P_ci IN NUMBER)
RETURN VARCHAR2;
Pragma restrict_references(get_istituto, WNDS);
Function get_sportello
( P_ci IN NUMBER)
RETURN VARCHAR2;
Pragma restrict_references(get_sportello, WNDS);
Function get_giorni_detrazioni
/******************************************************************************
 NOME:        get_giorni_detrazioni
 DESCRIZIONE: Ottiene in numero di Giorni validi per le Detrazioni del mese o dell'anno.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER;
Pragma restrict_references(get_giorni_detrazioni, WNDS);
Function get_mesi_detrazioni
/******************************************************************************
 NOME:        get_mesi_detrazioni
 DESCRIZIONE: Ottiene in numero di Giorni validi per le Detrazioni del mese o dell'anno.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER;
Pragma restrict_references(get_mesi_detrazioni, WNDS);
Function get_mesi_deduzione
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_mesi_deduzione, WNDS);
Function get_val_conv_ded_div
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_ded_div, WNDS);
Function get_val_conv_ded_fam
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_ded_fam, WNDS);
Function get_val_ded_fis_base
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_ded_fis_base, WNDS);
Function get_val_ded_fis_agg
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn IN NUMBER)
RETURN NUMBER;
Pragma restrict_references(get_val_ded_fis_agg, WNDS);
Function get_ded_per_div
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER;
Pragma restrict_references(get_ded_per_div, WNDS);
Function get_ded_fis_div
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_is_mese_conguaglio IN BOOLEAN DEFAULT false)
RETURN NUMBER;
Pragma restrict_references(get_ded_fis_div, WNDS);
Function get_ded_fis_base
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_is_mese_conguaglio IN BOOLEAN DEFAULT false)
RETURN NUMBER;
Pragma restrict_references(get_ded_fis_base, WNDS);
Function get_ded_fis_agg
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_is_mese_conguaglio IN BOOLEAN DEFAULT false)
RETURN NUMBER;
Pragma restrict_references(get_ded_fis_agg, WNDS);
Function get_ded_per_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_val_ded_fis_fam IN NUMBER
, P_imponibile IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER;
Function get_det_per_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_val_conv IN NUMBER
, P_imponibile IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER;
Function get_det_spe
( P_ci IN NUMBER
, P_data IN DATE
, P_anno IN NUMBER
, P_mese IN NUMBER
, P_spese IN NUMBER
, p_tipo_spese IN VARCHAR2
, P_ipn_ord IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_conguaglio IN NUMBER
, P_regime_fiscale  IN VARCHAR2
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2   --Step elaborato
,p_tim    IN OUT VARCHAR2   --Time impiegato in secondi
)
RETURN NUMBER;
Pragma restrict_references(get_ded_per_fam, WNDS);
Function get_val_conv_det_fam
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER;
Pragma restrict_references(get_val_conv_det_fam, WNDS);
Procedure set_ipn_ded_fis_fam
( P_ci IN NUMBER
, P_imponibile IN NUMBER
, P_somme_deducibili IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M');
Procedure set_ipn_det_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_imponibile IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M');
Function set_val_ded_fis_fam
/******************************************************************************
 NOME:        set_val_ded_fis_fam
 DESCRIZIONE: Memorizzazione degli attributi relativi alle Deduzioni di Imponibile.
              Quando viene memorizzato il valore Mansile il Valore Annuale viene annullato.
              Ritorna la Percentuale di deduzione suilla base dei valori in ingresso.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_val_ded_con IN NUMBER
, P_val_ded_fig IN NUMBER
, P_val_ded_alt IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER;
Procedure set_val_det_fis_fam
/******************************************************************************
 NOME:        set_val_det_fis_fam
 DESCRIZIONE: Memorizzazione degli attributi relativi alle Detrazioni L.Fin. 2007
              Quando viene memorizzato il valore Mansile il Valore Annuale viene annullato.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_det_per_con IN NUMBER
, P_det_per_fig IN NUMBER
, P_det_per_alt IN NUMBER
, P_det_per_con_ac IN NUMBER
, P_det_per_fig_ac IN NUMBER
, P_det_per_alt_ac IN NUMBER
, P_val_det_con IN NUMBER
, P_val_det_fc  IN NUMBER
, P_val_det_ft  IN NUMBER
, P_val_det_fig IN NUMBER
, P_val_det_alt IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M');
Procedure lkp_ded_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_ded_con IN OUT NUMBER
, P_ded_fig IN OUT NUMBER
, P_ded_alt IN OUT NUMBER
, P_ded_per_fam IN OUT NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M');
Procedure lkp_det_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_det_con IN OUT NUMBER
, P_det_fc IN OUT NUMBER
, P_det_ft IN OUT NUMBER
, P_det_fig IN OUT NUMBER
, P_det_alt IN OUT NUMBER);
Procedure lkp_ipn_det_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, p_anno IN NUMBER
, p_mese IN NUMBER
, p_mensilita IN VARCHAR2
, P_ipn_ac IN OUT NUMBER);
END GP4_RARE;
/
CREATE OR REPLACE PACKAGE BODY GP4_RARE IS
D_ci   NUMBER;
D_VAFI   NUMBER := 0;
D_conguaglio   NUMBER;
D_spese   rapporti_retributivi.spese%type;
D_tipo_spese   rapporti_retributivi.tipo_spese%type;
D_attribuzione_spese   rapporti_retributivi.attribuzione_spese%type;
D_ulteriori   rapporti_retributivi.ulteriori%type;
D_tipo_ulteriori   rapporti_retributivi.tipo_ulteriori%type;
D_posizione_inail   rapporti_retributivi.posizione_inail%type;
D_data_inail   rapporti_retributivi.data_inail%type;
D_istituto   rapporti_retributivi.istituto%type;
D_sportello   rapporti_retributivi.sportello%type;
D_val_conv_ded_div   NUMBER;
D_val_ded_fis_base   NUMBER;
D_val_conv_ded_fam   NUMBER;
D_val_conv_det_fam   NUMBER;
D_val_min_det_dip    NUMBER;
D_val_min_det_pen1    NUMBER;
D_val_min_det_pen2    NUMBER;
-- Memorizza 1 se gli attributi di Deduzione sono gia stati calcolati per il CI
D_ded_LKP_data   DATE;
D_ded_con   NUMBER;
D_ded_fig   NUMBER;
D_ded_alt   NUMBER;
D_ded_per_fam   NUMBER;
D_ded_con_ac   NUMBER;
D_ded_fig_ac   NUMBER;
D_ded_alt_ac   NUMBER;
D_ded_per_fam_ac   NUMBER;
D_ipn_ord   NUMBER;
D_ipn_ord_ac   NUMBER;
D_somme_od   NUMBER;
D_somme_od_ac   NUMBER;
D_det_con   NUMBER;
D_det_fig   NUMBER;
D_det_alt   NUMBER;
D_det_per_con   NUMBER;
D_det_per_fig   NUMBER;
D_det_per_alt   NUMBER;
D_det_con_ac   NUMBER;
D_det_fc_ac    NUMBER;
D_det_ft_ac    NUMBER;
D_det_fig_ac   NUMBER;
D_det_alt_ac   NUMBER;
D_det_per_con_ac   NUMBER;
D_det_per_fig_ac   NUMBER;
D_det_per_alt_ac   NUMBER;
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
/******************************************************************************
 NOME:        initialize
 DESCRIZIONE: Inizializza i dati del Rapporto retributivo sulle variabili di Package.
******************************************************************************/
( P_ci IN NUMBER
, Requery IN VARCHAR2 DEFAULT 'NO')
IS
BEGIN
   IF D_ci    != P_ci OR D_ci is null
   OR ReQuery != 'NO'
   THEN
      -- Svuotamenti
      D_data        := null;
      D_VAFI        := 0;
      D_ipn_ord     := null;
      D_ipn_ord_ac  := null;
      D_somme_od    := null;
      D_somme_od_ac := null;
      D_ci := P_ci;
      select rare.spese
           , rare.tipo_spese
           , nvl(attribuzione_spese,0)
           , rare.ulteriori
           , rare.tipo_ulteriori
           , rare.posizione_inail
           , rare.data_inail
           , rare.istituto
           , rare.sportello
        into D_spese
           , D_tipo_spese
           , D_attribuzione_spese
           , D_ulteriori
           , D_tipo_ulteriori
           , D_posizione_inail
           , D_data_inail
           , D_istituto
           , D_sportello
        from rapporti_retributivi rare
       where rare.ci = P_ci
      ;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      d_spese              := null;
      d_tipo_spese         := null;
      d_attribuzione_spese := 0;
END initialize;
Function init
/******************************************************************************
 NOME:        init
 DESCRIZIONE: Funzione richiamabile da SELECT per inizializzare le variabili di Package.
******************************************************************************/
( P_ci IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
   Initialize(P_ci, 'YES');
   RETURN null;
END init;
Procedure VAFI_initialize
/******************************************************************************
 NOME:        VAFI_initialize
 DESCRIZIONE: Inizializzazione dei valori di Validita Fiscale sulle variabili di Package.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE)
IS
BEGIN
   IF D_ci   != P_ci   OR D_ci   is null
   OR D_data != P_data OR D_data is null
   OR D_VAFI != 1
   THEN
      Initialize(P_ci);
      D_val_conv_ded_div   := GP4_DEFI.get_val_conv_ded_div(P_data);
      D_val_conv_ded_fam   := GP4_DEFI.get_val_conv_ded_fam(P_data);
      D_val_conv_det_fam   := GP4_DEFI.get_val_conv_det_fam(P_data);
      D_val_min_det_dip    := GP4_DEFI.get_val_min_det_dip(P_data);
      D_val_min_det_pen1    := GP4_DEFI.get_val_min_det_pen1(P_data);
      D_val_min_det_pen2    := GP4_DEFI.get_val_min_det_pen2(P_data);
      IF D_spese = 0 THEN
         D_val_ded_fis_base := null;
         D_val_conv_ded_div := null;
      ELSE
         IF D_attribuzione_spese = 4 THEN
            D_val_ded_fis_base := null;
         ELSE
            D_val_ded_fis_base := GP4_DEFI.get_ded_fis_base(P_data);
         END IF;
      END IF;
      D_data := P_data;
      D_VAFI := 1;
   END IF;
END VAFI_initialize;
Procedure set_conguaglio
/******************************************************************************
 NOME:        set_conguaglio
 DESCRIZIONE: Funzione Privata richiamata da "is_mese-conguaglio".
              Memorizza il valore di Conguaglio individuale per le funzioni locali a cui interessa:
              - get_giorni_detrazioni
              - get_mesi_detrazioni
******************************************************************************/
( P_ci IN NUMBER
, P_valore IN NUMBER)
IS
BEGIN
   Initialize(P_ci);
   D_conguaglio := P_valore;
END set_conguaglio;
Function is_mese_conguaglio
/******************************************************************************
 NOME:        is_mese_conguaglio
 DESCRIZIONE: Ritorna TRUE se e mese di conguaglio per l'individuo.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_tipo IN VARCHAR2 DEFAULT null
, P_conguaglio IN NUMBER DEFAULT null)
RETURN BOOLEAN
IS
D_effe_cong INFORMAZIONI_EXTRACONTABILI.effe_cong%TYPE;
D_mese      NUMBER;
D_tipo      VARCHAR2(1);
BEGIN
   IF not (D_ci = P_ci)
   OR P_conguaglio is not null
   THEN
      set_conguaglio(P_ci,P_conguaglio);
   END IF;
   IF P_tipo is null
   THEN
      IF D_tipo is null
      THEN
         D_tipo := 'N';
      END IF;
   ELSE
      D_tipo := P_tipo;
   END IF;
-- dbms_output.put_line('========================== chiamo GP4_INEX.get_effe_cong');
   D_effe_cong := GP4_INEX.get_effe_cong(P_ci, to_number(to_char(P_data,'yyyy')));
   D_mese      := to_char(P_data, 'mm');
   IF     D_conguaglio != 0
      AND nvl(D_effe_cong,' ')  != 'N'
   OR     nvl(D_effe_cong,gp4_ente.get_scad_cong) = 'M'
   OR     D_mese = 12
      AND nvl(D_effe_cong,gp4_ente.get_scad_cong) = 'A'
      AND D_tipo IN ( 'S', 'N' )
   THEN
-- dbms_output.put_line('========================== true: D_effe_cong'||D_effe_cong||' D_conguaglio '||D_conguaglio||' P_data '||P_data);
      RETURN true;
   else
-- dbms_output.put_line('========================  false: D_effe_cong'||D_effe_cong||' D_conguaglio '||D_conguaglio||' P_data '||P_data);
      RETURN false;
   END IF;
END is_mese_conguaglio;
Function get_spese
( P_ci IN NUMBER)
RETURN NUMBER
IS
BEGIN
   Initialize(P_ci);
   RETURN D_spese;
END get_spese;
Function get_tipo_spese
( P_ci IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
   Initialize(P_ci);
   RETURN D_tipo_spese;
END get_tipo_spese;
Function get_attribuzione_spese
( P_ci IN NUMBER)
RETURN NUMBER
IS
BEGIN
   Initialize(P_ci);
   RETURN nvl(D_attribuzione_spese,0);
END get_attribuzione_spese;
Function get_ulteriori
( P_ci IN NUMBER)
RETURN NUMBER
IS
BEGIN
   Initialize(P_ci);
   return D_ulteriori;
END get_ulteriori;
Function get_tipo_ulteriori
( P_ci IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
   Initialize(P_ci);
   return D_tipo_ulteriori;
END get_tipo_ulteriori;
Function get_posizione_inail
( P_ci IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
   Initialize(P_ci);
   return D_posizione_inail;
END get_posizione_inail;
Function get_data_inail
( P_ci IN NUMBER)
RETURN DATE
IS
BEGIN
   Initialize(P_ci);
   return D_data_inail;
END get_data_inail;
Function get_istituto
( P_ci IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
   Initialize(P_ci);
   return D_istituto;
END get_istituto;
Function get_sportello
( P_ci IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
   Initialize(P_ci);
   return D_sportello;
END get_sportello;
Function get_giorni_detrazioni
/******************************************************************************
 NOME:        get_giorni_detrazioni
 DESCRIZIONE: Ottiene in numero di Giorni validi per le Detrazioni del mese o dell'anno.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER
IS
D_mese          NUMBER;
D_anno          NUMBER;
D_inizio_anno   DATE;
D_detrazioni_ap VARCHAR2(2);
D_gg_det        NUMBER;
BEGIN
   Initialize(P_ci);
   D_mese          := to_number(to_char(P_data,'mm'));
   D_anno          := to_number(to_char(P_data,'yyyy'));
   D_inizio_anno   := to_date('0101'||D_anno,'ddmmyyyy');
   D_detrazioni_ap := GP4_ENTE.get_detrazioni_ap;
   select sum(pere.gg_det)
     into D_gg_det
     from periodi_retributivi pere
    where exists
         (select 'x' from dual
           where P_tipo_calcolo = 'M'
             and pere.periodo   = P_data
           union all
          select 'x' from dual
           where P_tipo_calcolo = 'A'
             and pere.periodo+0 between D_inizio_anno
                                     and P_data
         )
      and pere.competenza in ('P','C','A')
      and pere.servizio     = 'Q'
      and pere.ci in
         (select P_ci
            from dual
          union
          select ci_erede
            from rapporti_diversi
           where ci = P_ci
             and rilevanza = 'L'
             and anno = D_anno
         )
      and (to_char(pere.al,'yyyy') = D_anno or D_detrazioni_ap = 'SI')
      and pere.anno+0 = D_anno
   ;
   RETURN D_gg_det;
END get_giorni_detrazioni;
Function get_mesi_detrazioni
/******************************************************************************
 NOME:        get_mesi_detrazioni
 DESCRIZIONE: Ottiene in numero di Giorni validi per le Detrazioni del mese o dell'anno.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER
IS
D_mese          NUMBER;
D_anno          NUMBER;
D_inizio_anno   DATE;
D_detrazioni_ap VARCHAR2(2);
D_mesi_det      NUMBER;
BEGIN
   Initialize(P_ci);
   D_mese          := to_number(to_char(P_data,'mm'));
   D_anno          := to_number(to_char(P_data,'yyyy'));
   D_inizio_anno   := to_date('0101'||D_anno,'ddmmyyyy');
   D_detrazioni_ap := GP4_ENTE.get_detrazioni_ap;
   select sum( decode(sum(pere.gg_det), 0, 0, 1) )
     into D_mesi_det
     from periodi_retributivi pere
    where exists
         (select 'x' from dual
           where P_tipo_calcolo = 'M'
             and pere.periodo   = P_data
           union all
          select 'x' from dual
           where D_conguaglio != 0
             and P_tipo_calcolo = 'A'
             and pere.periodo+0 between D_inizio_anno
                                     and P_data
         )
      and pere.competenza in ('P','C','A')
      and pere.servizio     = 'Q'
      and pere.ci in
         (select P_ci
            from dual
          union
          select ci_erede
            from rapporti_diversi
           where ci = P_ci
             and rilevanza = 'L'
             and anno = D_anno
         )
      and (to_char(pere.al,'yyyy') = D_anno or D_detrazioni_ap = 'SI')
      and pere.anno+0 = D_anno
   group by pere.anno, pere.mese
   ;
   RETURN D_mesi_det;
END get_mesi_detrazioni;
Function get_mesi_deduzione
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER
IS
D_mesi_deduzione NUMBER(2);
BEGIN
   Initialize(P_ci);
   select mesi_deduzioni
     into D_mesi_deduzione
     from contratti_storici
    where contratto = (select contratto from periodi_retributivi
                        where periodo = P_data
                          and competenza = 'A'
                          and ci = P_ci
                      )
      and P_data between dal and nvl(al,to_date('3333333','j'))
   ;
   IF D_mesi_deduzione IS NULL THEN
      D_mesi_deduzione := GP4_ENTE.get_mesi_irpef;
   END IF;
   RETURN D_mesi_deduzione;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       RETURN GP4_ENTE.get_mesi_irpef;
END get_mesi_deduzione;
Function get_val_conv_ded_div
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   VAFI_Initialize(P_ci, P_data);
   RETURN D_val_conv_ded_div;
END get_val_conv_ded_div;
Function get_val_conv_ded_fam
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   VAFI_Initialize(P_ci, P_data);
   RETURN D_val_conv_ded_fam;
END get_val_conv_ded_fam;
Function get_val_ded_fis_base
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   VAFI_Initialize(P_ci, P_data);
   RETURN D_val_ded_fis_base;
END get_val_ded_fis_base;
Function get_val_ded_fis_agg
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn IN NUMBER)
RETURN NUMBER
IS
D_val_ded_fis_agg    NUMBER;
BEGIN
   Initialize(P_ci);
   D_val_ded_fis_agg := GP4_DEFI.get_ded_fis_agg(P_data, D_tipo_spese, D_spese);
   select decode( greatest( P_ipn , 0)
                , 0, 0
                   , decode(D_attribuzione_spese
                           , 2, 0
                           , 3, 0
                              , D_val_ded_fis_agg
                           )
                )
     into D_val_ded_fis_agg
     from dual
   ;
   RETURN D_val_ded_fis_agg;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 0;
END get_val_ded_fis_agg;
Function get_ded_per_div
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER
IS
D_attribuzione_spese NUMBER;
D_val_conv_ded_div   NUMBER;
D_val_ded_fis_base   NUMBER;
D_val_ded_fis_agg    NUMBER;
D_mesi_deduzione     NUMBER;
D_gg_det             NUMBER;
D_ded_per_div        NUMBER;
BEGIN
   D_val_conv_ded_div   := get_val_conv_ded_div(P_ci, P_data);
   D_val_ded_fis_base   := get_val_ded_fis_base(P_ci, P_data);
   D_val_ded_fis_agg    := get_val_ded_fis_agg(P_ci, P_data, P_ipn_ord - P_ipn_ass);
   D_attribuzione_spese := get_attribuzione_spese(P_ci);
   D_mesi_deduzione     := get_mesi_deduzione(P_ci, P_data);
   D_gg_det             := get_giorni_detrazioni(P_ci, P_data, P_tipo_calcolo);
   select greatest
          ( 0
          , least
            ( trunc
              ( ( D_val_conv_ded_div
                + decode
                  ( P_tipo_calcolo
                  , 'M', nvl(D_val_ded_fis_base,0)
                       , decode
                         ( D_attribuzione_spese
                         , 1, nvl(D_val_ded_fis_base,0)
                         , 2, nvl(D_val_ded_fis_base,0)
                            , nvl(e_round( D_val_ded_fis_base/365*least(365,D_gg_det),'I'),0)
                         )
                  )
                + decode
                  ( P_tipo_calcolo
                  ,'M', nvl(D_val_ded_fis_agg,0)
                      , nvl(e_round( D_val_ded_fis_agg/365*least(365,D_gg_det) , 'I'),0)
                  )
                - ( (P_ipn_ord + P_somme_od) * decode(P_tipo_calcolo,'M',D_mesi_deduzione,1) )
                + ( P_somme_od * decode(P_tipo_calcolo,'M',12,1) )
                ) / D_val_conv_ded_div * 100
              , 2
              )
            , 100
            )
          )
     into D_ded_per_div
     from dual
   ;
   RETURN D_ded_per_div;
END get_ded_per_div;
Function get_ded_fis_div
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_is_mese_conguaglio IN BOOLEAN DEFAULT false)
RETURN NUMBER
IS
D_spese              NUMBER;
D_val_ded_fis_base   NUMBER;
D_val_ded_fis_agg    NUMBER;
D_mesi_deduzione     NUMBER;
D_gg_det             NUMBER;
D_ded_fis_div        NUMBER;
BEGIN
   IF get_tipo_spese(P_ci) is not null THEN
      D_spese     := get_spese(P_ci);
      IF nvl(D_spese,0) != 0
      OR D_spese is null and P_is_mese_conguaglio
      THEN
         D_val_ded_fis_base := get_val_ded_fis_base(P_ci, P_data);
         D_val_ded_fis_agg  := get_val_ded_fis_agg(P_ci, P_data, P_ipn_ord - P_ipn_ass);
         D_mesi_deduzione := get_mesi_deduzione(P_ci, P_data);
         D_gg_det  := get_giorni_detrazioni(P_ci, P_data, P_tipo_calcolo);
         D_attribuzione_spese := get_attribuzione_spese(P_ci);
         select e_round
          ( ( decode( D_attribuzione_spese
                    , 1, nvl(D_val_ded_fis_base,0) / decode(P_tipo_calcolo,'M',D_mesi_deduzione,1)
                    , 2, nvl(D_val_ded_fis_base,0) / decode(P_tipo_calcolo,'M',D_mesi_deduzione,1)
                       , nvl(e_round((D_val_ded_fis_base / 365) * least(365,D_gg_det) , 'I'),0)
                    )
            + nvl(e_round( (D_val_ded_fis_agg / 365) * least(365,D_gg_det) , 'I'),0)
            ) * get_ded_per_div(P_ci, P_data, P_ipn_ord, P_ipn_ass, P_somme_od, P_tipo_calcolo) / 100
          , 'I'
          )
           into D_ded_fis_div
           from dual
         ;
      ELSE
         D_ded_fis_div := 0;
      END IF;
   ELSE
      D_ded_fis_div := 0;
   END IF;
   RETURN D_ded_fis_div;
END get_ded_fis_div;
Function get_ded_fis_base
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_is_mese_conguaglio IN BOOLEAN DEFAULT false)
RETURN NUMBER
IS
D_spese              NUMBER;
D_val_ded_fis_base   NUMBER;
D_mesi_deduzione     NUMBER;
D_gg_det             NUMBER;
D_ded_fis_base       NUMBER;
BEGIN
   IF get_tipo_spese(P_ci) is not null and d_attribuzione_spese != 4 THEN
      D_spese := get_spese(P_ci);
      IF nvl(D_spese,0) != 0
      OR D_spese is null and P_is_mese_conguaglio
      THEN
         D_val_ded_fis_base := get_val_ded_fis_base(P_ci, P_data);
         D_mesi_deduzione   := get_mesi_deduzione(P_ci, P_data);
         D_gg_det           := get_giorni_detrazioni(P_ci, P_data, P_tipo_calcolo);
         select e_round
          ( ( decode( get_attribuzione_spese(P_ci)
                    , 1, D_val_ded_fis_base / decode(P_tipo_calcolo,'M',D_mesi_deduzione,1)
                    , 2, D_val_ded_fis_base / decode(P_tipo_calcolo,'M',D_mesi_deduzione,1)
                       , e_round((D_val_ded_fis_base / 365) * least(365,D_gg_det) , 'I')
                    )
            ) * get_ded_per_div(P_ci, P_data, P_ipn_ord, P_ipn_ass, P_somme_od, P_tipo_calcolo)
              / 100
          , 'I'
          )
           into D_ded_fis_base
           from dual
         ;
      ELSE
         D_ded_fis_base := 0;
      END IF;
   ELSE
      D_ded_fis_base := 0;
   END IF;
   RETURN D_ded_fis_base;
END get_ded_fis_base;
Function get_ded_fis_agg
( P_ci IN NUMBER
, P_data IN DATE
, P_ipn_ord IN NUMBER
, P_ipn_ass IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_is_mese_conguaglio IN BOOLEAN DEFAULT false)
RETURN NUMBER
IS
D_ded_fis_div    NUMBER;
D_ded_fis_base   NUMBER;
D_ded_fis_agg    NUMBER;
BEGIN
   D_ded_fis_div  := get_ded_fis_div
                     ( P_ci, P_data
                     , P_ipn_ord, P_ipn_ass, P_somme_od
                     , P_tipo_calcolo, P_is_mese_conguaglio);
   D_ded_fis_base := get_ded_fis_base
                     ( P_ci, P_data
                     , P_ipn_ord, P_ipn_ass, P_somme_od
                     , P_tipo_calcolo, P_is_mese_conguaglio);
   IF nvl(D_ded_fis_div,0) = 0 then
      D_ded_fis_agg := 0;
   ELSE
      D_ded_fis_agg  := nvl(D_ded_fis_div,0) - nvl(D_ded_fis_base,0);
   END IF;
   RETURN D_ded_fis_agg;
END get_ded_fis_agg;
Function get_ded_per_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_val_ded_fis_fam IN NUMBER
, P_imponibile IN NUMBER
, P_somme_od IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER
IS
D_val_conv_ded_fam   NUMBER;
D_mesi_deduzione     NUMBER;
D_ded_per_fam        NUMBER;
BEGIN
   D_val_conv_ded_fam := get_val_conv_ded_fam(P_ci, P_data);
   D_mesi_deduzione   := get_mesi_deduzione(P_ci, P_data);
   select greatest
          ( 0
          , least
            ( trunc
              ( ( D_val_conv_ded_fam
                + P_val_ded_fis_fam
                - ( (P_imponibile + P_somme_od) * decode(P_tipo_calcolo,'M',D_mesi_deduzione,1) )
                + ( P_somme_od * decode(P_tipo_calcolo,'M',12,1) )
                ) / D_val_conv_ded_fam * 100
              , 2
              )
            , 100
            )
          )
     into D_ded_per_fam
     from dual
   ;
   RETURN D_ded_per_fam;
END get_ded_per_fam;
Function get_det_per_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_val_conv IN NUMBER
, P_imponibile IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER
IS
D_mesi_detrazione    NUMBER;
D_det_per_fam        NUMBER;
BEGIN
   D_mesi_detrazione  := get_mesi_deduzione(P_ci, P_data); -- utilizza la stessa lettura dei mesi di deduzione
   select greatest
          ( 0
          , least
            ( trunc
              ( ( P_val_conv
                - (   P_imponibile * decode(P_tipo_calcolo,'M',D_mesi_detrazione,1) )
                ) / P_val_conv * 100
              , 2
              )
            , 100
            )
          )
     into D_det_per_fam
     from dual
   ;
-- dbms_output.put_Line('GP4_RARE.get_det_per_fam: D_mesi_detrazione '||D_mesi_detrazione||
--                     ' P_val_conv '||P_val_conv||' P_imponibile '||P_imponibile||
--                     ' P_tipo_calcolo '||P_tipo_calcolo||' D_det_per_fam '||D_det_per_fam);
   RETURN D_det_per_fam;
END get_det_per_fam;
Function get_det_spe
( P_ci IN NUMBER
, P_data IN DATE
, P_anno IN NUMBER
, P_mese IN NUMBER
, P_spese IN NUMBER
, p_tipo_spese IN VARCHAR2
, P_ipn_ord IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M'
, P_conguaglio   IN NUMBER
, P_regime_fiscale IN VARCHAR2
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2   --Step elaborato
,p_tim    IN OUT VARCHAR2   --Time impiegato in secondi
)
RETURN NUMBER
IS
D_det_fis_div        NUMBER;
D_val_det_div        NUMBER;
D_det_per_div        NUMBER;
D_conguaglio         NUMBER;
D_spese              NUMBER;
D_aggiuntivo         NUMBER;
BEGIN
   IF get_tipo_spese(P_ci) is not null THEN
      IF nvl(P_spese,0) != 0
      OR P_spese is null and P_conguaglio != 0
      THEN
         IF P_tipo_calcolo = 'M' THEN
            D_conguaglio := P_conguaglio;
         ELSE
            D_conguaglio := 1;
         END IF;
         D_val_det_div := gp4_defi.get_imp_aum
                                     ( P_anno, P_mese, '*', P_tipo_spese
                                     , P_spese, '', P_ipn_ord, D_conguaglio, 1
                                     , P_ci, 'I'
                                     , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
-- dbms_output.put_line('***P_tipo_spese '||P_tipo_spese||' P_spese '||P_spese||' P_ipn_ord '||P_ipn_ord||' P_congualio '||P_conguaglio);
-- dbms_output.put_line(' D_val_det_div '||D_val_det_div||' P_tipo_calcolo '||P_tipo_calcolo);
         IF P_regime_fiscale = 'F'
            THEN
               IF P_spese between 51 and 98
                  THEN D_spese := P_spese - 50;
                  ELSIF P_conguaglio = 1
                        THEN D_spese := 99;
                        ELSE D_spese := P_spese;
               END IF;
               D_det_per_div := GP4_DEFI.get_det_per_div
                                         ( P_anno, P_mese, '*', P_tipo_spese
                                         , D_spese, '', P_ipn_ord, D_conguaglio
                                         , P_ci
                                         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
               IF P_tipo_spese = 'DD'
                  THEN D_aggiuntivo := nvl(gp4_defi.get_val_conv_det_dip(P_data),0);
               ELSIF P_tipo_spese = 'DP'
                  THEN D_aggiuntivo := nvl(gp4_defi.get_val_conv_det_pen1(P_data),0);
               ELSIF P_tipo_spese = 'P2'
                  THEN D_aggiuntivo := nvl(gp4_defi.get_val_conv_det_pen2(P_data),0);
                  ELSE D_aggiuntivo := 0;
               END IF;
               IF D_det_per_div < 1000
                  THEN
-- dbms_output.put_line('D_det_fis_div '||D_val_det_div||' D_det_per_div '||D_det_per_div);
                  D_val_det_div := e_round(D_val_det_div * D_det_per_div / 100, 'I');
-- dbms_output.put_line('D_val_det_div '||D_val_det_div);
                  ELSE D_val_det_div :=D_val_det_div + e_round(D_aggiuntivo * (D_det_per_div-1000) / 100,'I');
               END IF;
         END IF;
       ELSE
        D_val_det_div := 0;
       END IF;
     ELSE
        D_val_det_div := 0;
     END IF;
   RETURN D_val_det_div;
END get_det_spe;
Function get_val_conv_det_fam
( P_ci IN NUMBER
, P_data IN DATE)
RETURN NUMBER
IS
BEGIN
   VAFI_Initialize(P_ci, P_data);
   RETURN D_val_conv_det_fam;
END get_val_conv_det_fam;
Procedure set_ipn_ded_fis_fam
( P_ci IN NUMBER
, P_imponibile IN NUMBER
, P_somme_deducibili IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
IS
BEGIN
   Initialize(P_ci);
   IF P_tipo_calcolo = 'M'
   THEN
      D_ipn_ord     := P_imponibile;
      D_somme_od    := P_somme_deducibili;
   ELSE
      D_ipn_ord_ac  := P_imponibile;
      D_somme_od_ac := P_somme_deducibili;
   END IF;
END set_ipn_ded_fis_fam;
Procedure set_ipn_det_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_imponibile IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
IS
BEGIN
   Initialize(P_ci);
   D_ded_LKP_data := P_data;
-- dbms_output.put_line('P_tipo_calcolo '||P_tipo_calcolo||' P_imponibile '||P_imponibile);
   IF P_tipo_calcolo = 'M'
   THEN
      D_ipn_ord     := P_imponibile;
   ELSE
      D_ipn_ord_ac  := P_imponibile;
   END IF;
END set_ipn_det_fis_fam;
Function set_val_ded_fis_fam
/******************************************************************************
 NOME:        set_val_ded_fis_fam
 DESCRIZIONE: Memorizzazione degli attributi relativi alle Deduzioni di Imponibile.
              Quando viene memorizzato il valore Mansile il Valore Annuale viene annullato.
              Ritorna la Percentuale di deduzione suilla base dei valori in ingresso.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_val_ded_con IN NUMBER
, P_val_ded_fig IN NUMBER
, P_val_ded_alt IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
RETURN NUMBER
IS
BEGIN
   Initialize(P_ci);
   D_ded_LKP_data := P_data;
   IF P_tipo_calcolo = 'M'
   THEN
      D_ded_per_fam := get_ded_per_fam
                       ( P_ci, P_data
                       , P_val_ded_con + P_val_ded_fig + P_val_ded_alt
                       , D_ipn_ord, D_somme_od, 'M');
      D_ded_con     := P_val_ded_con /12 * D_ded_per_fam / 100;
      D_ded_fig     := P_val_ded_fig /12 * D_ded_per_fam / 100;
      D_ded_alt     := P_val_ded_alt /12 * D_ded_per_fam / 100;
      D_ded_per_fam_ac := null;
      D_ded_con_ac  := null;
      D_ded_fig_ac  := null;
      D_ded_alt_ac  := null;
      RETURN D_ded_per_fam;
   ELSE
      D_ded_per_fam_ac := get_ded_per_fam
                          ( P_ci, P_data
                          , P_val_ded_con + P_val_ded_fig + P_val_ded_alt
                          , D_ipn_ord_ac, D_somme_od_ac, 'A');
      D_ded_con_ac     := P_val_ded_con * D_ded_per_fam_ac / 100;
      D_ded_fig_ac     := P_val_ded_fig * D_ded_per_fam_ac / 100;
      D_ded_alt_ac     := P_val_ded_alt * D_ded_per_fam_ac / 100;
      RETURN D_ded_per_fam_ac;
   END IF;
END set_val_ded_fis_fam;
Procedure set_val_det_fis_fam
/******************************************************************************
 NOME:        set_val_det_fis_fam
 DESCRIZIONE: Memorizzazione degli attributi relativi alle Detrazioni L.Fin. 2007
              Quando viene memorizzato il valore Mansile il Valore Annuale viene annullato.
******************************************************************************/
( P_ci IN NUMBER
, P_data IN DATE
, P_det_per_con IN NUMBER
, P_det_per_fig IN NUMBER
, P_det_per_alt IN NUMBER
, P_det_per_con_ac IN NUMBER
, P_det_per_fig_ac IN NUMBER
, P_det_per_alt_ac IN NUMBER
, P_val_det_con IN NUMBER
, P_val_det_fc  IN NUMBER
, P_val_det_ft  IN NUMBER
, P_val_det_fig IN NUMBER
, P_val_det_alt IN NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
IS
BEGIN
   Initialize(P_ci);
   D_ded_LKP_data := P_data;
   IF P_tipo_calcolo = 'M'
   THEN
-- dbms_output.put_line('P_val_det_con '||P_val_det_con);
      D_det_con     := P_val_det_con /12 * P_det_per_con / 100;
-- dbms_output.put_line('D_det_con '||d_det_con);
      D_det_fig     := P_val_det_fig /12 * P_det_per_fig / 100;
      D_det_alt     := P_val_det_alt /12 * P_det_per_alt / 100;
      D_det_con_ac  := null;
      D_det_fig_ac  := null;
      D_det_alt_ac  := null;
   ELSE
-- dbms_output.put_line('P_val_det_con '||P_val_det_con);
      D_det_con_ac     := P_val_det_con; -- * P_det_per_con_ac / 100;
      D_det_fc_ac      := P_val_det_fc; -- * P_det_per_con_ac / 100;
      D_det_ft_ac      := P_val_det_ft; -- * P_det_per_con_ac / 100;
-- dbms_output.put_line('D_det_con_ac '||d_det_con_ac);
      D_det_fig_ac     := P_val_det_fig; -- * P_det_per_fig_ac / 100;
      D_det_alt_ac     := P_val_det_alt; -- * P_det_per_alt_ac / 100;
   END IF;
END set_val_det_fis_fam;
Procedure lkp_ded_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_ded_con IN OUT NUMBER
, P_ded_fig IN OUT NUMBER
, P_ded_alt IN OUT NUMBER
, P_ded_per_fam IN OUT NUMBER
, P_tipo_calcolo IN VARCHAR2 DEFAULT 'M')
IS
BEGIN
   IF D_ci = P_ci AND D_ded_LKP_data = P_data
   THEN  -- gli attributi sono stati calcolati
      IF P_tipo_calcolo = 'M'
      THEN
         P_ded_con     := D_ded_con;
         P_ded_fig     := D_ded_fig;
         P_ded_alt     := D_ded_alt;
         P_ded_per_fam := D_ded_per_fam;
      ELSE
         P_ded_con     := D_ded_con_ac;
         P_ded_fig     := D_ded_fig_ac;
         P_ded_alt     := D_ded_alt_ac;
         P_ded_per_fam := D_ded_per_fam_ac;
      END IF;
   ELSE  -- gli attributi non sono stati calcolati: vengono prelevati da MOFI
      IF D_ci != P_ci then
         Initialize(P_ci);
      END IF;
      IF P_tipo_calcolo = 'M'
      THEN
      select ded_con
           , ded_fig
           , ded_alt
           , ded_per_fam
        into P_ded_con
           , P_ded_fig
           , P_ded_alt
           , P_ded_per_fam
           from movimenti_fiscali
          where ci = P_ci
            and anno = to_number(to_char(P_data,'yyyy'))
            and lpad(to_char(mese),2)||mensilita =
               (select max(lpad(to_char(mese),2)||mensilita)
                  from movimenti_fiscali
                 where ci   = P_ci
                   and anno = to_number(to_char(P_data,'yyyy'))
                   and mensilita not like '*%'
                   and mese <= to_number(to_char(P_data,'mm'))
               )
         ;
      ELSE
         select ded_con_ac
              , ded_fig_ac
              , ded_alt_ac
              , ded_per_fam_ac
           into P_ded_con
              , P_ded_fig
              , P_ded_alt
              , P_ded_per_fam
           from movimenti_fiscali
          where ci = P_ci
            and anno = to_number(to_char(P_data,'yyyy'))
            and lpad(to_char(mese),2)||mensilita =
               (select max(lpad(to_char(mese),2)||mensilita)
                  from movimenti_fiscali
                 where ci   = P_ci
                   and anno = to_number(to_char(P_data,'yyyy'))
                   and mensilita not like '*%'
                   and mese <= to_number(to_char(P_data,'mm'))
               )
         ;
      END IF;
   END IF;
END lkp_ded_fis_fam;
Procedure lkp_det_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, P_det_con IN OUT NUMBER
, P_det_fc  IN OUT NUMBER
, P_det_ft  IN OUT NUMBER
, P_det_fig IN OUT NUMBER
, P_det_alt IN OUT NUMBER)
IS
BEGIN
   IF D_ci = P_ci AND D_ded_LKP_data = P_data
   THEN  -- gli attributi sono stati calcolati
       P_det_con     := D_det_con_ac;
       P_det_fc      := D_det_fc_ac;
       P_det_ft      := D_det_ft_ac;
       P_det_fig     := D_det_fig_ac;
       P_det_alt     := D_det_alt_ac;
   ELSE  -- gli attributi non sono stati calcolati: vengono prelevati da MOFI
      IF D_ci != P_ci then
         Initialize(P_ci);
      END IF;
       select det_con_ac
            , D_det_fc_ac
            , D_det_ft_ac
            , det_fig_ac
            , det_alt_ac
         into P_det_con
            , P_Det_fc
            , P_Det_ft
            , P_det_fig
            , P_det_alt
         from movimenti_fiscali
        where ci = P_ci
          and anno = to_number(to_char(P_data,'yyyy'))
          and lpad(to_char(mese),2)||mensilita =
             (select max(lpad(to_char(mese),2)||mensilita)
                from movimenti_fiscali
               where ci   = P_ci
                 and anno = to_number(to_char(P_data,'yyyy'))
                 and mensilita not like '*%'
                 and mese <= to_number(to_char(P_data,'mm'))
             )
       ;
   END IF;
END lkp_det_fis_fam;
Procedure lkp_ipn_det_fis_fam
( P_ci IN NUMBER
, P_data IN DATE
, p_anno IN NUMBER
, p_mese IN NUMBER
, p_mensilita IN VARCHAR2
, P_ipn_ac IN OUT NUMBER)
IS
BEGIN
-- dbms_output.put_line('sono in rare lkp ipn inizio '||D_ci||' '||P_ci||' dlkp '||D_ded_LKP_data||' p_data '||P_data);
   IF D_ci = P_ci AND D_ded_LKP_data = P_data
   THEN  -- gli attributi sono stati calcolati
       P_ipn_ac      := D_ipn_ord_ac;
-- dbms_output.put_line('sono in rare lkp ipn - P_ipn_ac '||P_ipn_ac||' D_ipn_ord_ac '||D_ipn_ord_ac);
   ELSE  -- gli attributi non sono stati calcolati: vengono prelevati da MOFI
      IF D_ci != P_ci then
         Initialize(P_ci);
      END IF;
       select NVL(SUM(ipn_ac ),0)
--              NVL( SUM( ipn_ord + NVL(ipn_sep,0) ), 0 )
         into D_ipn_ord_ac
         from progressivi_fiscali
        where ci = P_ci
          and anno = P_anno
          and mese = P_mese
          and mensilita = P_mensilita
       ;
   END IF;
END lkp_ipn_det_fis_fam;
END GP4_RARE;
/
