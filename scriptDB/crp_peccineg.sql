CREATE OR REPLACE Package peccineg IS
/******************************************************************************
 NOME:          PECCINEG
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
errore varchar2(6);
passo_ERR varchar2(30);
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER);
PROCEDURE INEC_GENERALE;
END;
/

CREATE OR REPLACE PACKAGE BODY peccineg IS
form_trigger_failure exception;
w_prenotazione number(6);
w_passo	number(2);
w_dummy varchar2(1);
-- Inserisce Informazioni Retributive di Progressione
--
-- Tratta le voci delle progressioni economiche
-- per tutte le voci di PROGRESSIONE modificate sul dizionario VOCI
--
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.1 del 27/12/2006';
 END VERSIONE;
PROCEDURE INRE_PREC
( P_contratto  VARCHAR2
, P_voce VARCHAR2
, P_dal  date
, P_nulldal  date  -- Data null (to_date('2222222','j'))
, P_nullal date  -- Data null (to_date('3333333','j'))
, P_ini_ela  date
-- Parametri per Trace
, p_trc  IN  number  -- Tipo di Trace
, p_prn  IN  number  -- Numero di Prenotazione elaborazione
, p_pas  IN  number  -- Numero di Passo procedurale
, p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
, p_stp  IN OUT  VARCHAR2  -- Step elaborato
, p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
  D_dummy VARCHAR2(1);
BEGIN
 P_stp := 'INRE-PREC';
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
  , decode
  ( least
  ( nvl(sopr.dal-1,P_nullal)
  , decode
  ( prec.fine
  , nvl(inec.al,P_nullal), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1
   ,'dd'))
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  beneficio_anzianita
  , '0M', add_months
  ( to_date
  ( '3112'||
  to_char(prec.fine+1
   ,'yyyy')
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
  , nvl(sopr.dal-1,P_nullal), inre.al
  , decode
  ( prec.fine
  , nvl(inec.al,P_nullal), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1,'dd')
   )
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  beneficio_anzianita
  , '0M', add_months
  ( to_date
  ( '3112'||
  to_char(prec.fine+1
   ,'yyyy')
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
  ) al
  , 'B' tipo
  , inre.qualifica
  , inre.tipo_rapporto
  , P_ini_ela data_agg
 from basi_voce  bavo
  , voci_economiche  voec
  , inquadramenti_economici  inec
  , progressioni_economiche  prec
  , valori_progressione_voce vpvo
  , sospensioni_progressione sopr
  , informazioni_retributive inre
  , qualifiche_giuridiche  qugi
  where bavo.contratto  = P_contratto
  and bavo.voce = P_voce
  and bavo.dal >= P_dal
  and voec.codice = bavo.voce
  and inec.dal  between bavo.dal
  and nvl(bavo.al,P_nullal)
  and inec.voce = bavo.voce
  and prec.ci = inec.ci
  and prec.voce = inec.voce
  and prec.dal  = inec.dal
  and prec.qualifica  = inec.qualifica
  and prec.periodo  > 0
  and vpvo.voce = bavo.voce
  and vpvo.contratto  = bavo.contratto
  and vpvo.dal  = bavo.dal
  and vpvo.periodo  = prec.periodo
  and inre.ci = inec.ci
  and inre.voce = bavo.voce_base
  and inre.qualifica  = inec.qualifica
  and nvl(inre.tipo_rapporto,' ') = nvl(inec.tipo_rapporto,' ')
  and inre.dal <= least( nvl(inec.al,P_nullal)
   , nvl(bavo.al,P_nullal)
   )
  and nvl(inre.al,P_nullal)  >= greatest( inec.dal, bavo.dal )
  and qugi.numero = inec.qualifica
  and qugi.dal <= nvl(inec.al,P_nullal)
  and nvl(qugi.al,P_nullal)  >= inec.dal
/* modifica del 27/12/2006 - introdotta la lettura per max(chiave) */
-- vecchia lettura:
--  and qugi.livello like vpvo.livello
--  and nvl(inec.tipo_rapporto,' ') ike vpvo.tipo_rapporto
-- nuova lettura:
 and vpvo.livello||vpvo.tipo_rapporto =
 (select max(vpvo2.livello||vpvo2.tipo_rapporto)
    from valori_progressione_voce vpvo2
   where vpvo2.voce = vpvo.voce
     and vpvo2.contratto = vpvo.contratto
     and vpvo2.dal = vpvo.dal
     and vpvo2.periodo = vpvo.periodo
     and qugi.livello like vpvo2.livello
     and nvl(inec.tipo_rapporto,' ') like vpvo2.tipo_rapporto
 )
/* modifica del 15/12/94 */
  and qugi.contratto  = P_contratto
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
  ) <= nvl(inre.al,P_nullal)
/* fine modifica del 18/04/97 */
  and nvl
  ( decode
  ( greatest( nvl(prec.fine,P_nullal)
  , prec.inizio
  )
  , prec.inizio, prec.fine
  , decode
  ( least
  ( nvl(sopr.dal-1,P_nullal)
  , decode
  ( prec.fine
  , nvl(inec.al,P_nullal), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1
   ,'dd'))
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  beneficio_anzianita
  , '0M', add_months
  ( to_date
  ( '3112'||
  to_char(prec.fine+1
   ,'yyyy')
  , 'ddmmyyyy'
   )
  , -12
  )
  , last_day(prec.fine+1)
  )
  , last_day(add_months(prec.fine+1,-1)
  )
  )
  , inre.al
  )
  )
  )
  , nvl(sopr.dal-1,P_nullal), inre.al
  , decode
  ( prec.fine
  , nvl(inec.al,P_nullal), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1,'dd')
   )
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  beneficio_anzianita
  , '0M', add_months
  ( to_date
  ( '3112'||
  to_char(prec.fine+1
   ,'yyyy')
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
  , decode
  ( least
  ( nvl(sopr.dal-1,P_nullal)
  , decode
  ( prec.fine
  , nvl(inec.al,P_nullal), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1
   ,'dd'))
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  beneficio_anzianita
  , '0M', add_months
  ( to_date
  ( '3112'||
  to_char(prec.fine+1
   ,'yyyy')
  , 'ddmmyyyy'
   )
  , -12
  )
  , last_day(prec.fine+1)
  )
  , last_day(add_months(prec.fine+1,-1)
  )
  )
  , inre.al
  )
  )
  )
  , nvl(sopr.dal-1,P_nullal), inre.al
  , decode
  ( prec.fine
  , nvl(inec.al,P_nullal), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1,'dd')
   )
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  beneficio_anzianita
  , '0M', add_months
  ( to_date
  ( '3112'||
  to_char(prec.fine+1
   ,'yyyy')
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
  where qugi.contratto  like sopr2.contratto
  and exists
 (select 'x'
  from rapporti_giuridici
 where ci  = inre.ci
 and gestione like sopr2.gestione
 )
  and nvl(qugi.ruolo,' ') like sopr2.ruolo
  and qugi.livello  like sopr2.livello
  and qugi.codice like sopr2.qualifica
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
  from informazioni_retributive
 where ci = curp.ci
 and voce = curp.voce
 and sub  = curp.sub
 and dal  = curp.dal
  ;
  RAISE TOO_MANY_ROWS;
 EXCEPTION
  WHEN TOO_MANY_ROWS  THEN
 peccineg.errore := 'P05808';  -- Segnalazione in Elaborazione
 trace.log_trace(8,P_prn,P_pas,P_prs
  ,'INRE-PREC: Duplicate'
  ,0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs
  ,'CI : '||to_char(curp.ci)
  ,0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs
  ,'VOCE: '||curp.voce||' ('||curp.sub||')'
  ,0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs
  ,'DAL : '||to_char(curp.dal,'dd/mm/yyyy')
  ,0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs
  ,'AL  : '||to_char(curp.al,'dd/mm/yyyy')
  ,0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs
  ,'TARIFFA: '||to_char(curp.tariffa)
  ,0,P_tim,20);
  WHEN NO_DATA_FOUND  THEN
 insert into informazioni_retributive
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
 nvl(dal,to_date('3333333','j')) and
 nvl(al,to_date('2222222','j'))
 )
/* fine modifica del 18/04/97 */
 ;
 END;
 END LOOP;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Inserisce Informazioni Retributive Base
--
--
-- Inserisce informazioni retributive di tipo BASE
-- per tutte le voci BASE modificate sul dizionario VOCI
--
PROCEDURE INRE_BASE
( P_contratto  VARCHAR2
, P_voce VARCHAR2
, P_dal  date
, P_nulldal  date  -- Data null (to_date('2222222','j'))
, P_nullal date  -- Data null (to_date('3333333','j'))
, P_ini_ela  date
-- Parametri per Trace
, p_trc  IN  number  -- Tipo di Trace
, p_prn  IN  number  -- Numero di Prenotazione elaborazione
, p_pas  IN  number  -- Numero di Passo procedurale
, p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
, p_stp  IN OUT  VARCHAR2  -- Step elaborato
, p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
BEGIN
 BEGIN  -- Inserisce informazioni Base
 P_stp := 'INRE-BASE';
 insert into informazioni_retributive
  ( ci, voce, sequenza_voce, sub
  , tariffa, dal, al
  , tipo, qualifica, tipo_rapporto
  , data_agg
  )
 select pegi.ci
  , vbvo.voce
  , voec.sequenza
  , decode(pegi.rilevanza,'S','Q','I')
  , round( nvl(vbvo.valore,0)
 * nvl(bavo.moltiplica,1) / nvl(bavo.divide,1)
 , nvl(bavo.decimali,0)
 ) tariffa
  , greatest(pegi.dal, qugi.dal, vbvo.dal) dal
  , decode( least( nvl(pegi.al,P_nullal)
 , nvl(qugi.al,P_nullal)
 , nvl(vbvo.al,P_nullal)
 )
  , P_nullal, to_date(null)
  , least( nvl(pegi.al,P_nullal)
 , nvl(qugi.al,P_nullal)
 , nvl(vbvo.al,P_nullal)
 )
  ) al
  , 'B' tipo
  , qugi.numero qualifica
  , pegi.tipo_rapporto
  , P_ini_ela data_agg
 from valori_base_voce  vbvo
  , basi_voce bavo
  , voci_economiche voec
  , periodi_giuridici pegi
  , qualifiche_giuridiche qugi
  where vbvo.contratto = P_contratto
  and vbvo.voce  = P_voce
  and vbvo.dal  >= P_dal
  and bavo.voce  = vbvo.voce
  and bavo.contratto = vbvo.contratto
  and bavo.dal = vbvo.dal
  and voec.codice  = bavo.voce
  and voec.tipo != 'Q'
  and pegi.rilevanza  in ('S','E')
  and pegi.dal  <= nvl(bavo.al,P_nullal)
  and nvl(pegi.al,P_nullal) >= bavo.dal
  and qugi.numero  = pegi.qualifica
  and qugi.dal  <= least( nvl(pegi.al,P_nullal)
  , nvl(bavo.al,p_nullal)
  )
  and nvl(qugi.al,P_nullal) >= greatest( pegi.dal
 , bavo.dal
 )
  and qugi.contratto = bavo.contratto
  and vbvo.gestione||' '||vbvo.ruolo
  ||' '||vbvo.livello||' '
  ||vbvo.qualifica||' '||vbvo.tipo_rapporto
  = (select max(vbvo2.gestione||' '||vbvo2.ruolo
  ||' '||vbvo2.livello||' '
  ||vbvo2.qualifica||' '||vbvo2.tipo_rapporto
 )
 from valori_base_voce  vbvo2
  where pegi.gestione  like vbvo2.gestione
  and nvl(qugi.ruolo,' ')  like vbvo2.ruolo
  and qugi.livello like vbvo2.livello
  and qugi.codice  like vbvo2.qualifica
  and nvl(pegi.tipo_rapporto,' ')
 like vbvo2.tipo_rapporto
  and vbvo2.dal = vbvo.dal
  and vbvo2.contratto = vbvo.contratto
  and vbvo2.voce  = vbvo.voce
  )
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Cancella Informazioni Retributive Base,Progressione,Eccedenza
--
-- Annulla le Informazioni di tipo BASE su informazioni Retributive
-- a partire dalla minor data di modifica su dizionario VOCI
--
PROCEDURE INRE_ANNULLA
( P_contratto  VARCHAR2
, P_voce VARCHAR2
, P_dal  date
, P_nulldal  date  -- Data null (to_date('2222222','j'))
, P_nullal date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
, p_trc  IN  number  -- Tipo di Trace
, p_prn  IN  number  -- Numero di Prenotazione elaborazione
, p_pas  IN  number  -- Numero di Passo procedurale
, p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
, p_stp  IN OUT  VARCHAR2  -- Step elaborato
, p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
BEGIN
 P_stp := 'INRE-ANNULLA';
 delete
 from informazioni_retributive inre
  where inre.tipo  = 'B'
  and nvl(inre.al,P_nullal) >= P_dal
  and inre.voce  = P_voce
  and inre.qualifica  in
 (select distinct qugi.numero
  from qualifiche_giuridiche qugi
 where qugi.contratto = P_contratto
 and nvl(qugi.al,P_nullal) >= P_dal
 )
  and exists
 (select 'x'
  from qualifiche_giuridiche qugi
 where qugi.numero  = inre.qualifica
 and nvl(qugi.dal,P_nulldal) <= nvl(inre.al,P_nullal)
 and nvl(qugi.al, P_nullal ) >= inre.dal
 and qugi.contratto = P_contratto
 )
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
  RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Calcolo Inquadramento Generale
--
--
PROCEDURE INEG_CALCOLO
( p_ini_ela  date
, p_fin_ela  date
-- Parametri per Trace
, p_trc  IN  number  -- Tipo di Trace
, p_prn  IN  number  -- Numero di Prenotazione elaborazione
, p_pas  IN  number  -- Numero di Passo procedurale
, p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
, p_stp  IN OUT  VARCHAR2  -- Step elaborato
, p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
D_nulldal  DATE := to_date('2222222','j');
D_nullal DATE := to_date('3333333','j');
D_tim_voc  VARCHAR2(5);  -- Time impiegato in secondi per voce
BEGIN
 BEGIN  -- Ciclo su Voci Aggiornate e calcolo reinquadramento
  P_stp  := 'INEG_CALCOLO-01';
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  FOR CURV IN
 (select contratto
 , decode( classe
 , 'B', decode( voce_ecce
  , null, 'B'
  , 'T'
  )
  , 'P'
 ) classe
 , voce
 , min(dal) dal
  from basi_voce
 where flag_inqv = 'R'
 group by contratto, classe, voce_ecce, voce
  union
  select contratto
 , 'P' classe
 , voce
 , min(dal) dal
  from basi_voce bavo
 where (contratto,voce_base) in
  (select distinct contratto, voce
 from basi_voce
  where flag_inqv = 'R'
  and classe = 'B'
  )
 and nvl(al,to_date('3333333','j')) >=
  (select min(dal)
 from basi_voce
  where voce  = bavo.voce_base
  and contratto = bavo.contratto
  and flag_inqv = 'R'
  )
 group by contratto, voce
  union
  select bavo.contratto
 , 'T' classe
 , bavo.voce
 , min(bavo2.dal) dal
  from basi_voce bavo
 , basi_voce bavo2
 , totalizzazioni_voce tovo
 where bavo.contratto  = bavo2.contratto
 and bavo.voce_ecce  = tovo.voce_acc
 and bavo2.flag_inqv = 'R'
 and bavo2.voce  = tovo.voce
 and bavo2.dal
  <= nvl(tovo.al,to_date('3333333','j'))
 and nvl(bavo2.al,to_date('3333333','j'))
  >= nvl(tovo.dal,to_date('2222222','j'))
 and tovo.voce_acc  in
  (select distinct voce_ecce
 from basi_voce
  where classe = 'B'
  and voce_ecce is not null
  )
 group by bavo.contratto, bavo.voce
 order by 1, 2, 3
 ) LOOP
 D_tim_voc := to_char(sysdate,'sssss');
 INRE_ANNULLA  -- Cancella le informazioni retributive
 (curv.contratto, curv.voce, curv.dal
  , D_nulldal, D_nullal
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 IF curv.classe = 'B' THEN
  INRE_BASE  -- Registra informazioni retributive BASE
  (curv.contratto, curv.voce, curv.dal
   , D_nulldal, D_nullal
   , P_ini_ela
   , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
  );
 ELSE
 IF curv.classe = 'P' THEN
  INRE_PREC  -- Informazioni Retributive Progr. Eccedenza
  (curv.contratto, curv.voce, curv.dal
   , D_nulldal, D_nullal
   , P_ini_ela
   , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim );
 ELSE
  peccineg2.INRE_BASE_TOT  -- Registra informazioni BASE su Totale
  (curv.contratto, curv.voce, curv.dal
   , D_nulldal, D_nullal
   , P_ini_ela
   , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
  );
 END IF;
 END IF;
 BEGIN  -- Disattiva Flag di modifica sul dizionario VOCI
  P_stp  := 'INEG_CALCOLO-02';
  update basi_voce
 set flag_inqv = null
 where voce  = curv.voce
 and contratto = curv.contratto
 and flag_inqv = 'R'
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
 END;
 P_stp := 'Complete '||curv.contratto||' '||curv.voce;
 trace.log_trace(2,P_prn,P_pas,P_prs,P_stp,0,D_tim_voc,20);
commit;
  END LOOP;
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
  RAISE; -- Errore gia` gestito in sub-procedure
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
commit;
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Aggiornamento Posizione Giuridica Individuale
--
PROCEDURE RAGI_UPDATE_POS
(P_ci  number
,P_fin_ela date
,P_stp  IN OUT  VARCHAR2  -- Step elaborato
) IS
BEGIN
/*  Memorizzazione posizione giuridica alla data di elaborazione */
BEGIN
 P_stp := 'UPDATE_RAGI_POS-01';
 update rapporti_giuridici
  set (dal,al,posizione,di_ruolo,contratto,qualifica,ruolo,livello
  ,tipo_rapporto,ore,attivita,figura,gestione,settore,sede
  ) =
  (select max(pegi.dal),max(pegi.al),max(pegi.posizione),
  max(posi.ruolo),max(qugi.contratto),
  max(pegi.qualifica),max(qugi.ruolo),max(qugi.livello),
  max(pegi.tipo_rapporto),max(pegi.ore),max(pegi.attivita),
  max(pegi.figura),max(pegi.gestione),max(pegi.settore),
  max(pegi.sede)
 from periodi_giuridici pegi,
  qualifiche_giuridiche qugi,
  posizioni posi
  where posi.codice  = pegi.posizione
  and qugi.numero (+)  = pegi.qualifica
  and least(nvl(pegi.al,to_date('3333333','j')),P_fin_ela)
  between
  nvl(qugi.dal,to_date('2222222','j'))
 and
  nvl(qugi.al ,to_date('3333333','j'))
  and pegi.ci  = P_ci
  and (pegi.dal,pegi.rilevanza)
   in
  (select max(dal),substr(max(to_char(dal,'yyyy/mm/dd')||
  pegi2.rilevanza),11,1)
 from periodi_giuridici pegi2
  where pegi2.ci = P_ci
  and pegi2.rilevanza in ('S','Q')
  and pegi2.dal <= P_fin_ela
  )
  )
  where ci = P_ci
 ;
END;
BEGIN
 P_stp := 'UPDATE_RAGI_POS-02';
 update rapporti_giuridici ragi
  set (dal,al,posizione,di_ruolo,contratto,qualifica,ruolo,livello
  ,tipo_rapporto,ore,attivita,figura,gestione,settore,sede
  ) =
  (select pegi.dal,pegi.al,pegi.posizione,
  posi.ruolo,
  qugi.contratto,pegi.qualifica,qugi.ruolo,qugi.livello,
  pegi.tipo_rapporto,pegi.ore,pegi.attivita,pegi.figura,
  pegi.gestione,pegi.settore,pegi.sede
 from periodi_giuridici pegi,
  qualifiche_giuridiche qugi,
  posizioni posi
  where posi.codice  = pegi.posizione
  and qugi.numero  = pegi.qualifica
  and least(nvl(pegi.al,to_date('3333333','j')),P_fin_ela)
  between qugi.dal
  and nvl(qugi.al,to_date('3333333','j'))
  and pegi.ci  = P_ci
  and pegi.rilevanza = 'E'
  and pegi.dal = (select max(dal)
  from periodi_giuridici
   where ci  = P_ci
   and rilevanza = 'E'
   and dal  <= P_fin_ela
   )
  and ( nvl(pegi.al,to_date('3333333','j')) >=
  nvl(ragi.al,to_date('3333333','j'))
 or P_fin_ela
 between pegi.dal
 and nvl(pegi.al,to_date('3333333','j'))
  )
  )
  where ragi.ci  = P_ci
  and exists
 (select 'x'
  from periodi_giuridici
 where ci  = P_ci
 and rilevanza = 'E'
 and dal = (select max(dal)
  from periodi_giuridici
   where ci  = P_ci
   and rilevanza = 'E'
   and dal  <= P_fin_ela
   )
 and ( nvl(al,to_date('3333333','j')) >=
 nvl(ragi.al,to_date('3333333','j'))
  or P_fin_ela
 between dal
   and nvl(al,to_date('3333333','j'))
 )
 )
 ;
END;
END;
PROCEDURE INEC_GENERALE  IS
-- Dati per gestione TRACE
d_trc   NUMBER(1);  -- Tipo di Trace
d_prn   NUMBER(6);  -- Numero di Prenotazione
d_pas   NUMBER(2);  -- Numero di Passo procedurale
d_prs   NUMBER(10); -- Numero progressivo di Segnalazione
d_stp   VARCHAR2(30); -- Identificazione dello Step in oggetto
d_cnt   NUMBER(5);  -- Count delle row trattate
d_tim   VARCHAR2(5);  -- Time impiegato in secondi
d_tim_tot VARCHAR2(5);  -- Time impiegato in secondi Totale
--
-- Dati per deposito informazioni generali
--
d_ini_ela  RIFERIMENTO_RETRIBUZIONE.INI_ELA%TYPE;
d_fin_ela  RIFERIMENTO_RETRIBUZIONE.FIN_ELA%TYPE;
--
BEGIN
 BEGIN  -- Assegnazioni Iniziali per Trace
  D_prn := nvl(w_prenotazione,0);
  D_pas := nvl(w_passo,0);
  IF D_prn = 0 THEN
	 D_trc := 1;
	 delete from a_segnalazioni_errore
	  where no_prenotazione = D_prn
	  and passo   = D_pas
	 ;
  ELSE
	 D_trc := null;
  END IF;
  BEGIN  -- Preleva numero max di segnalazione
	 select nvl(max(progressivo),0)
	   into D_prs
	   from a_segnalazioni_errore
	  where no_prenotazione = D_prn
	  and passo   = D_pas
 	;
  END;
 END;
 D_stp := 'PECCINEG-Start';
 D_tim := to_char(sysdate,'sssss');
 D_tim_tot := to_char(sysdate,'sssss');
 trace.log_trace(0,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
 commit;
 BEGIN
 D_stp := 'INEC_GENERALE-01';
 select ini_ela
  , fin_ela
 into d_ini_ela
  , d_fin_ela
 from riferimento_retribuzione
 ;
 trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
 END;
 BEGIN  -- Ciclo su individui in RAPPORTI_GIURIDICI
  --  per aggiornamento della situazione Giuridica attuale
  --  degli individui in rapporto individuale nell'anno
  D_stp  := 'INEC_GENERALE-02';
  trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
  FOR CURS IN
 (select ragi.ci
  from rapporti_individuali rain
   , rapporti_giuridici ragi
   where ragi.ci = rain.ci
   and rain.dal <= D_fin_ela
   and nvl(rain.al , to_date('3333333','j'))
    >= to_date( to_char( D_ini_ela
       , 'mmyyyy'
       )
      , 'mmyyyy'
      )
 ) LOOP
 BEGIN
  RAGI_UPDATE_POS  -- Aggiornamento Posizione Giuridica
  ( curs.ci, D_fin_ela
   , D_stp
  );
 END;
  END LOOP;
commit;
 END;
 BEGIN  -- Verifica esistenza Voci da Trattare
  D_stp  := 'INEC_GENERALE-03';
  trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim,20);
  select 'x'
  into w_dummy
  from basi_voce
 where flag_inqv = 'R'
  ;
  RAISE TOO_MANY_ROWS;
 EXCEPTION
  WHEN TOO_MANY_ROWS THEN
   INEG_CALCOLO
   (D_ini_ela,D_fin_ela
    ,D_trc,D_prn,D_pas,D_prs,D_stp,D_tim
   );
  WHEN NO_DATA_FOUND THEN
  	D_stp := '!!!';
	trace.log_trace(5,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
	peccineg.errore := 'P05805';  -- Non esistono registrazioni
	commit;
  WHEN OTHERS THEN
   null;
 END;
 BEGIN  -- Operazioni finali per Trace
  D_stp := 'PECCINEG-Stop';
  trace.log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_tot,20);
  IF  	peccineg.errore != 'P05805' -- No Registrazioni
  AND 	peccineg.errore != 'P05808' THEN  -- Segnalazione
  	peccineg.errore := 'P05802';  -- Elaborazione Completata
  END IF;
commit;
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN  -- Errore gestito in sub-procedure
  peccineg.errore := 'P05809'; -- Errore in Elaborazione
  passo_err := D_stp;  -- Step Errato
 WHEN OTHERS THEN
  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
  peccineg.errore := 'P05809'; -- Errore in Elaborazione
  passo_err := D_stp;  -- Step Errato
END;
   PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER) is
BEGIN
   w_prenotazione := prenotazione;
   w_passo := passo;
   errore  := to_char(null);
   -- Memorizzato in caso di azzeramento per ROLLBACK
   INEC_GENERALE; -- Inquadramento Generale
   IF w_prenotazione != 0 THEN
      IF substr(errore,6,1) = '5' THEN
         update a_prenotazioni
            set errore = 'P05805'
          where no_prenotazione = w_prenotazione
         ;
	commit;
      ELSIF
         substr(errore,6,1) = '8' THEN
         update a_prenotazioni
            set errore = 'P05808'
          where no_prenotazione = w_prenotazione
         ;
commit;
      ELSIF
         substr(errore,6,1) = '9' THEN
         update a_prenotazioni
            set errore         = 'P05809'
              , prossimo_passo = 91
          where no_prenotazione = w_prenotazione
         ;
         commit;
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      BEGIN
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

