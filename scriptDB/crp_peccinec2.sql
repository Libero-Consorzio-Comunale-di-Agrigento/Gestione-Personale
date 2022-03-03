CREATE OR REPLACE PACKAGE peccinec2 IS
/******************************************************************************
 NOME:          P
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
 2    16/02/2004 AM     Revisione gestione Assenze              
 2.1  26/09/2005 ML	Modificata PEGI_ASSENZE per verifica storicita della qualifica (A12799)
 2.2  27/12/2006 AM     Introdotta la lettura per max(chiave) anche per le voci a progressione
 2.3  25/07/2007 AM     Corretto il legame INEC/PREC inserendo anche il tipo rapporto  
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE INEC_PROSSIMO
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
)
;
PROCEDURE INRE_PREC_ECCE
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
,errore in out varchar2
)
;
PROCEDURE INRE_BASE
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
);
PROCEDURE PEGI_ASSENZA
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
);
 PROCEDURE INRE_ANNULLA
(p_ci     number
,p_ini_ela  date
,p_d_inqe   date
,Pnulld   date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
);
END;
/

CREATE OR REPLACE PACKAGE BODY peccinec2 IS
form_trigger_failure exception;
--  Modifica Prossimo e Periodo in INQUADRAMENTI ECONOMICI
--
--  Aggiorna PERIODO attuale e data PROSSIMO periodo su INEC
--  per le registrazioni aggiornate nel mese corrente.
--
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V2.3 del 25/07/2007';
 END VERSIONE;
PROCEDURE INEC_PROSSIMO
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
BEGIN
 BEGIN --  Aggiorna PERIODO attuale e data PROSSIMO periodo su INEC
 --  per le registrazioni aggiornate nel mese corrente.
 --
 P_stp := 'INEC_PROSSIMO';
 update inquadramenti_economici inec
  set al = decode(inec.al,Pnulld,to_date(null),inec.al)
  ,( periodo, prossimo )=(select max(prec.periodo)
  , decode
  ( max(nvl(prec.fine,Pnulld))
  , inec.al, to_date(null)
  , decode
  ( sign( max(bavo.gg_periodo)
  - to_number(to_char(max(prec.fine)+1,'dd'))
  )
  , -1, decode
  ( max(to_char(bavo.gg_periodo)||
  bavo.beneficio_anzianita
 )
  , '0M', to_date
  ( '0101'||
  to_char(max(prec.fine)+1,'yyyy')
  , 'ddmmyyyy'
  )
  , last_day(max(prec.fine)+1) +1
  )
  , last_day
  ( add_months( max(prec.fine)+1
  , -1
  )
  ) +1
  )
  )
  from progressioni_economiche  prec
 , basi_voce  bavo
 , qualifiche_giuridiche  qugi
 where prec.ci  = inec.ci
 and prec.dal = inec.dal
 and prec.qualifica = inec.qualifica
 and prec.tipo_rapporto = inec.tipo_rapporto
 and prec.voce  = inec.voce
 and qugi.numero  = prec.qualifica
 and qugi.contratto = bavo.contratto
 and bavo.voce  = prec.voce
 and prec.dal between qugi.dal
  and nvl(qugi.al,Pnulld)
 and prec.dal between bavo.dal
  and nvl(bavo.al,Pnulld)
 and ( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.inizio,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
 , '0M', to_date
 ( '0101'||
 to_char(prec.inizio,'yyyy')
 , 'ddmmyyyy'
 )
 , last_day(prec.inizio)+1
 )
 , last_day(add_months(prec.inizio,-1))+1
 )
 <=
 least( nvl(inec.al-1,Pnulld)
  , greatest
  ( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(inec.dal,'dd'))
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  bavo.beneficio_anzianita
  , '0M', to_date
  ( '0101'||
  to_char(inec.dal,'yyyy')
  , 'ddmmyyyy'
  )
  , last_day(inec.dal)+1
  )
  , last_day(add_months(inec.dal,-1))+1
  )
  , p_ini_ela
  )
  )
  or prec.periodo = 0
 )
  )
 where inec.ci = p_ci
 and inec.prossimo = p_ini_ela
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
--  Inserisce Informazioni Retributive di Progressioni ed Eccedenza
--
-- Tratta le voci delle progressioni economiche
-- scartando le registrazioni da annullare (DATA_AGG != Pnulld)
--
PROCEDURE INRE_PREC_ECCE
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
,errore in out varchar2
) IS
  D_dummy VARCHAR2(1);
/* modifica del 27/11/96 */
  D_periodo_ecce number;
/* fine modifica del 27/11/96 */
BEGIN
 BEGIN  -- Inserisce informazioni retributive di tipo PROGRESSIONE
 P_stp := 'INRE_PREC_ECCE-01';
 FOR curp IN
  ( select
  p_ci ci
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
  , decode
  ( prec.dal
  , prec.inizio, prec.inizio
 , decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.inizio,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
 , '0M', to_date
 ( '0101'||
 to_char(prec.inizio,'yyyy')
 , 'ddmmyyyy'
 )
 , last_day(prec.inizio)+1
 )
 , last_day(add_months(prec.inizio,-1))+1
 )
  )
  ) dal
  , decode
  ( greatest( nvl(prec.fine,Pnulld)
  , prec.inizio
  )
  , prec.inizio, prec.fine
  , least
  ( nvl(inre.al,Pnulld)
  , nvl(vpvo.al,Pnulld)
  , nvl
  ( decode
  ( least
  ( nvl(sopr.dal-1,Pnulld)
  , decode
  ( prec.fine
  , nvl(inec.al,Pnulld), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1,'dd')
 )
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  bavo.beneficio_anzianita
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
  , nvl(sopr.dal-1,Pnulld), inre.al
  , decode
  ( prec.fine
  , nvl(inec.al,Pnulld), inec.al
  , nvl( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.fine+1,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
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
 , Pnulld
 )
  )
  ) al
  , 'B' tipo
  , inre.qualifica
  , inre.tipo_rapporto
  , p_ini_ela data_agg
/* modifica del 11/06/96 */
  , bavo.voce_ecce
  , bavo.max_percentuale
  , inec.dal inec_dal
  , inec.eccedenza
/* fine modifica del 11/06/96 */
/* modifica del 27/11/96 */
  , prec.periodo
/* fine modifica del 27/11/96 */
 from valori_progressione_voce vpvo
  , progressioni_economiche  prec
  , sospensioni_progressione sopr
  , informazioni_retributive inre
  , basi_voce  bavo
  , qualifiche_giuridiche  qugi
  , inquadramenti_economici  inec
  , voci_economiche  voec
  where inec.ci = P_ci
  and vpvo.voce = bavo.voce
  and vpvo.contratto  = bavo.contratto
  and vpvo.dal  = bavo.dal
  and vpvo.periodo  = prec.periodo
/* modifica del 27/12/2006 - introdotta la lettura per max(chiave) */
-- vecchia lettura:
--  and qugi.livello like vpvo.livello
--  and nvl(inec.tipo_rapporto,' ')
-- like vpvo.tipo_rapporto
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
/* fine modifica del 27/12/2006 */
  and prec.ci = inec.ci
  and prec.voce = inec.voce
  and prec.dal  = inec.dal
  and prec.qualifica  = inec.qualifica
  and prec.tipo_rapporto  = inec.tipo_rapporto
/* modifica del 11/06/96 */
-- Entra nel LOOP anche per Periodo 0
-- per emissione eventuale Voce Eccedenza
--
--  and ( nvl(vpvo.per_pro,0)
--  + nvl(vpvo.imp_fis,0)
--  + decode( bavo.max_percentuale
--  , null, 0
--  , nvl(inec.eccedenza,0)
--  )
--  ) > 0
/* modifica del 11/06/96 */
  and inre.qualifica+0  = qugi.numero
  and nvl(inre.tipo_rapporto,' ') = nvl(inec.tipo_rapporto,' ')
  and inre.ci = inec.ci
  and inre.voce = bavo.voce_base
  and inec.dal  between bavo.dal
  and nvl(bavo.al,Pnulld)
  and bavo.voce = inec.voce
  and bavo.contratto  = qugi.contratto
  and voec.codice = bavo.voce
  and qugi.numero = inec.qualifica
  and qugi.dal <= nvl(inec.al,Pnulld)
  and nvl(qugi.al,Pnulld)  >= inec.dal
  and inec.data_agg  != Pnulld
  and decode
  ( prec.dal
  , prec.inizio, prec.inizio
 , decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.inizio,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
 , '0M', to_date
 ( '0101'||
 to_char(prec.inizio,'yyyy')
 , 'ddmmyyyy'
 )
 , last_day(prec.inizio)+1
 )
 , last_day(add_months(prec.inizio,-1))+1
 )
/* modifica del 18/04/97 */
  ) <= nvl(inre.al,Pnulld)
/* fine modifica del 18/04/97 */
  and nvl
  ( decode
  ( greatest( nvl(prec.fine,Pnulld)
  , prec.inizio
  )
  , prec.inizio, prec.fine
  , decode
  ( least
  ( nvl(sopr.dal-1,Pnulld)
  , decode
  ( prec.fine
  , nvl(inec.al,Pnulld), inec.al
  , nvl( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.fine+1
  ,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
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
 , last_day(add_months(prec.fine+1
  ,-1))
 )
 , inre.al
 )
  )
  )
  , nvl(sopr.dal-1,Pnulld), inre.al
  , decode
  ( prec.fine
  , nvl(inec.al,Pnulld), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1,'dd')
 )
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  bavo.beneficio_anzianita
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
  , Pnulld
  ) >= greatest(inre.dal,nvl(p_d_inqe,p_ini_ela))
  and decode
  ( prec.dal
  , prec.inizio, prec.inizio
 , decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.inizio,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
 , '0M', to_date
 ( '0101'||
 to_char(prec.inizio,'yyyy')
 , 'ddmmyyyy'
 )
 , last_day(prec.inizio)+1
 )
 , last_day(add_months(prec.inizio,-1))+1
 )
  ) <=
  nvl
  ( decode
  ( greatest( nvl(prec.fine,Pnulld)
  , prec.inizio
  )
  , prec.inizio, prec.fine
  , decode
  ( least
  ( nvl(sopr.dal-1,Pnulld)
  , decode
  ( prec.fine
  , nvl(inec.al,Pnulld), inec.al
  , nvl( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.fine+1
  ,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
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
 , last_day(add_months(prec.fine+1
  ,-1))
 )
 , inre.al
 )
  )
  )
  , nvl(sopr.dal-1,Pnulld), inre.al
  , decode
  ( prec.fine
  , nvl(inec.al,Pnulld), inec.al
 , nvl( decode
  ( sign( bavo.gg_periodo
  - to_number(to_char(prec.fine+1,'dd')
 )
  )
  , -1, decode
  ( to_char(bavo.gg_periodo)||
  bavo.beneficio_anzianita
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
  , Pnulld
  )
  and nvl(inre.al,Pnulld) >= nvl(p_d_inqe,p_ini_ela)
  and sopr.contratto||' '||sopr.gestione||sopr.ruolo
  ||sopr.livello||sopr.qualifica||to_char(sopr.dal,'j')
  = (select max(contratto||' '||gestione||ruolo
  ||livello||qualifica||to_char(dal,'j'))
 from sospensioni_progressione sopr2
  where qugi.contratto  like sopr2.contratto
  and exists
 (select 'x'
  from rapporti_giuridici
 where ci  = inec.ci
 and gestione like sopr2.gestione
 )
  and nvl(qugi.ruolo,' ') like sopr2.ruolo
  and qugi.livello  like sopr2.livello
  and qugi.codice like sopr2.qualifica
  )
/* modifica del 18/04/97 */
 order by decode
  ( prec.dal
  , prec.inizio, prec.inizio
 , decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.inizio,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
 , '0M', to_date
 ( '0101'||
 to_char(prec.inizio,'yyyy')
 , 'ddmmyyyy'
 )
 , last_day(prec.inizio)+1
 )
 , last_day(add_months(prec.inizio,-1))+1
 )
  )
/* fine modifica del 18/04/97 */
 ) LOOP
/* modifica del 11/06/96 */
 IF curp.tariffa > 0 THEN
/* fine modifica del 11/06/96 */
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
 errore := 'P05808'; -- Segnalazione in Elaborazione
 trace.log_trace(8,P_prn,P_pas,P_prs,'INRE-PREC: Duplicate',0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs,'CI : '||to_char(curp.ci),0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs,'VOCE: '||curp.voce||' ('||curp.sub||')',0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs,'DAL : '||to_char(curp.dal,'dd/mm/yyyy'),0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs,'AL  : '||to_char(curp.al,'dd/mm/yyyy'),0,P_tim,20);
 trace.log_trace(8,P_prn,P_pas,P_prs,'TARIFFA: '||to_char(curp.tariffa),0,P_tim,20);
  WHEN NO_DATA_FOUND  THEN
 insert into informazioni_retributive
  ( ci, voce, sequenza_voce, sub
  , tariffa, dal, al
  , tipo, qualifica, tipo_rapporto
  , data_agg
  )
/* modifica del 18/04/97 */
 select curp.ci, curp.voce, curp.sequenza, curp.sub
  , curp.tariffa, curp.dal
  , decode(curp.al,Pnulld,to_date(''),curp.al)
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
/* modifica del 11/06/96 */
  END;
 END IF;
 -- Se si tratta della prima progressione
 -- Se esiste una voce di appoggio e non e` stata definita una
 -- Max-Percentuale, nel qual caso Eccedenza e` una %
/* modifica del 27/11/96 */
 IF  curp.dal = curp.inec_dal
 AND curp.voce_ecce is not null
 AND curp.max_percentuale is null
 AND nvl(curp.eccedenza,0) != 0 THEN
 D_periodo_ecce := curp.periodo;
 END IF;
 IF  curp.periodo = D_periodo_ecce
 AND curp.voce_ecce is not null
 AND curp.max_percentuale is null
 AND nvl(curp.eccedenza,0) != 0 THEN
/* fine modifica del 27/11/96 */
  BEGIN -- Inserisce informazioni di ECCEDENZA
 insert into informazioni_retributive
  ( ci, voce, sequenza_voce, sub
  , tariffa, dal, al
  , tipo, qualifica, tipo_rapporto
  , data_agg
  )
 select curp.ci, curp.voce_ecce, voec.sequenza,curp.sub
  , curp.eccedenza, curp.dal
  , decode(curp.al,Pnulld,to_date(''),curp.al)
  , curp.tipo, curp.qualifica, curp.tipo_rapporto
  , curp.data_agg
 from voci_economiche voec
  where voec.codice = curp.voce_ecce
  and not exists
 (select 'x'
  from informazioni_retributive
 where ci = curp.ci
 and voce = curp.voce_ecce
 and sub  = curp.sub
 and dal  = curp.dal
 )
  ;
  END;
 END IF;
/* fine modifica del 11/06/96 */
 END LOOP;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
/* modifica del 11/06/96 */
 /* INIBITO per nuovo meccanismo di inserimento
 BEGIN -- Inserisce informazioni di tipo Base Voci ECCEDENZA
 -- Se esiste una voce si appoggio e non e` stata definita una
 -- Max-Percentuale, nel qual caso Eccedenza e` una %
 P_stp := 'INRE_PREC_ECCE-02';
 insert into informazioni_retributive
  ( ci, voce, sequenza_voce, sub
  , tariffa, dal, al
  , tipo, qualifica, tipo_rapporto
  , data_agg
  )
 select p_ci
  , bavo.voce_ecce
  , voec.sequenza
  , '*'
  , inec.eccedenza
  , inec.dal
  , decode
  ( greatest( nvl(prec.fine,Pnulld)
  , prec.inizio
  )
  , prec.inizio, prec.fine
  , least
  ( nvl(inec.al,Pnulld)
  , decode
  ( least
  ( nvl(sopr.dal-1,Pnulld)
  , nvl( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.fine+1,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
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
 , inec.al
 )
  )
  , nvl(sopr.dal-1,Pnulld), to_date(null)
  , nvl( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.fine+1,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
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
 , inec.al
 )
  )
  )
  ) al
  , 'B' tipo
  , qugi.numero qualifica
  , inec.tipo_rapporto
  , p_ini_ela
 from sospensioni_progressione  sopr
  , progressioni_economiche prec
  , basi_voce bavo
  , qualifiche_giuridiche qugi
  , inquadramenti_economici inec
  , voci_economiche voec
  where inec.ci  = P_ci
  and prec.ci  = inec.ci
  and prec.dal = inec.dal
  and prec.qualifica = inec.qualifica
  and prec.tipo_rapporto = inec.tipo_rapporto
  and prec.voce  = inec.voce
  and prec.periodo = trunc( ( inec.aa * 12
  + inec.mm - bavo.mm_inizio
  ) / bavo.mm_periodo
  )
  and bavo.voce  = inec.voce
  and bavo.contratto = qugi.contratto
  and inec.dal between bavo.dal and nvl(bavo.al,Pnulld)
  and bavo.voce_ecce  is not null
  and bavo.max_percentuale is null
  and voec.codice  = bavo.voce_ecce
  and qugi.numero  = inec.qualifica
  and inec.dal between qugi.dal and nvl(qugi.al,Pnulld)
  and nvl(inec.eccedenza,0) != 0
  and inec.data_agg != Pnulld
  and decode
  ( greatest( nvl(prec.fine,Pnulld), prec.inizio )
  , prec.inizio, prec.fine
  , least
  ( nvl(inec.al,Pnulld)
  , decode
  ( least
  ( nvl(sopr.dal-1,Pnulld)
  , nvl( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.fine+1,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
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
 , Pnulld
 )
  )
  , nvl(sopr.dal-1,Pnulld), Pnulld
  , nvl( decode
 ( sign( bavo.gg_periodo
 - to_number(to_char(prec.fine+1,'dd'))
 )
 , -1, decode
 ( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
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
 , Pnulld
 )
  )
  )
  ) >= nvl(p_d_inqe,p_ini_ela)
  and sopr.contratto||' '||sopr.gestione||sopr.ruolo
  ||sopr.livello||sopr.qualifica||to_char(sopr.dal,'j')
  = (select max(contratto||' '||gestione||ruolo
  ||livello||qualifica||to_char(dal,'j'))
 from sospensioni_progressione sopr2
  where qugi.contratto  like sopr2.contratto
  and exists
 (select 'x'
  from rapporti_giuridici
 where ci  = inec.ci
 and gestione like sopr2.gestione
 )
  and nvl(qugi.ruolo,' ') like sopr2.ruolo
  and qugi.livello  like sopr2.livello
  and qugi.codice like sopr2.qualifica
  )
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
*/
/* fine modifica del 11/06/96 */
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
--  Inserisce Informazioni Retributive Base
--
--
-- Inserisce informazioni retributive di tipo BASE
-- a partire dalla data D_INQE
--
PROCEDURE INRE_BASE
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
BEGIN
 BEGIN  -- Inserisce informazioni Base
 P_stp := 'INRE_BASE';
 insert into informazioni_retributive
  ( ci, voce, sequenza_voce, sub
  , tariffa, dal, al
  , tipo, qualifica, tipo_rapporto
  , data_agg
  )
 select p_ci
  , vbvo.voce
  , voec.sequenza
  , decode(pegi.rilevanza,'S','Q','I')
  , round( nvl(vbvo.valore,0)
 * nvl(bavo.moltiplica,1)
 / nvl(bavo.divide,1)
 , nvl(bavo.decimali,0)
 ) tariffa
  , greatest(pegi.dal,qugi.dal,vbvo.dal) dal
  , decode( least( nvl(pegi.al,Pnulld)
 , nvl(qugi.al,Pnulld)
 , nvl(vbvo.al,Pnulld)
 )
  , Pnulld, to_date(null)
  , least( nvl(pegi.al,Pnulld)
 , nvl(qugi.al,Pnulld)
 , nvl(vbvo.al,Pnulld)
 )
  ) al
  , 'B' tipo
  , qugi.numero qualifica
  , pegi.tipo_rapporto
  , p_ini_ela data_agg
 from periodi_giuridici pegi
  , qualifiche_giuridiche qugi
  , valori_base_voce  vbvo
  , basi_voce bavo
  , voci_economiche voec
  where pegi.ci  = p_ci
  and pegi.rilevanza  in ('S','E')
  and nvl(pegi.al,Pnulld) >= nvl(p_d_inqe,p_ini_ela)
  and qugi.numero  = pegi.qualifica
  and qugi.dal  <= nvl(pegi.al,Pnulld)
  and nvl(qugi.al,Pnulld) >= greatest( pegi.dal
 , nvl(p_d_inqe,p_ini_ela)
 )
  and bavo.voce  = vbvo.voce
  and bavo.contratto = vbvo.contratto
  and bavo.voce_ecce  is NULL
  and bavo.dal = vbvo.dal
  and nvl(bavo.al,Pnulld)  = nvl(vbvo.al,Pnulld)
  and voec.codice  = bavo.voce
  and voec.tipo != 'Q'
  and vbvo.contratto = qugi.contratto
  and vbvo.dal  <= least( nvl(qugi.al,Pnulld)
  , nvl(pegi.al,Pnulld)
  )
  and nvl(vbvo.al,Pnulld) >= greatest( qugi.dal
 , pegi.dal
 , nvl(p_d_inqe,p_ini_ela)
 )
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
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
--  Modifica le progressioni considerando le assenze
--
PROCEDURE PEGI_ASSENZA
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
BEGIN -- Calcolo Assenze
  DECLARE
 CURSOR CUR_INEC IS
  select inec.dal,decode( inec.al
  , Pnulld, to_date(null)
  , inec.al
  ) al
  ,inec.voce,inec.qualifica,inec.tipo_rapporto
  ,greatest(inec.dal,nvl(p_d_inqe,p_ini_ela)) data_inqe
  from inquadramenti_economici inec
 where inec.ci = p_ci
 and inec.prossimo = p_ini_ela
 and inec.data_agg  != Pnulld
/* modifica del 09/06/95 */
  -- and inec.dal >= nvl(p_d_inqe,p_ini_ela)
 and nvl(inec.al,Pnulld) >= nvl(p_d_inqe,p_ini_ela)
/* fine modifica del 09/06/95 */
 and exists (select 'x'
 from periodi_assenza_inec peai
  where peai.ci = inec.ci
--  and nvl(pegi.al,Pnulld)  >= inec.dal
 and nvl(peai.al,Pnulld) >=
    (select min(dal) from inquadramenti_economici
      where ci = inec.ci
        and voce = inec.voce
/* modifica del 25/11/2005 */
        and (   qualifica in (select numero from qualifiche_giuridiche
                               where contratto in (select contratto from qualifiche_giuridiche
                                                    where numero = inec.qualifica) )
            and peai.provenienza = 'B'
            or  qualifica = inec.qualifica and nvl(tipo_rapporto,' ') = nvl(inec.tipo_rapporto,' ')
            and peai.provenienza = 'G'
            )
/* fine modifica del 25/11/2005 */
    )
  and peai.dal <= nvl(inec.al,Pnulld)
  and exists (select 'x'
 from astensioni aste
  where codice  = peai.assenza
  and mat_anz = 0
 )
  )
 ;
 CURSOR CUR_PEGI (inec_dal date,inec_al date,inec_voce varchar,inec_qualifica number,inec_tipo_rapporto varchar) IS
 select dal  dal
  , al+1 al
  , trunc(months_between( last_day(nvl(al+1,Pnulld))
-- ,last_day(greatest(dal,inec_dal))
  ,last_day(dal)
  )
 ) * 30
 -least( 30
-- , to_number(to_char(greatest(dal,inec_dal),'dd'))
 , to_number(to_char(dal,'dd'))
 ) + 1
 +least( 30
 , to_number(to_char(nvl(al+1,Pnulld),'dd')) - 1
 ) gg
 from periodi_assenza_inec peai
  where  ci = p_ci
-- and nvl(al,Pnulld)  >= inec_dal
 and nvl(peai.al,Pnulld) >= 
    (select min(dal) from inquadramenti_economici
      where ci = p_ci
        and voce = inec_voce
/* modifica del 25/11/2005 */
        and (   qualifica in (select numero from qualifiche_giuridiche
                               where contratto in (select contratto from qualifiche_giuridiche
                                                    where numero = inec_qualifica) )
            and peai.provenienza = 'B'
            or  qualifica = inec_qualifica and nvl(tipo_rapporto,' ') = nvl(inec_tipo_rapporto,' ')
            and peai.provenienza = 'G'
            )
/* fine modifica del 25/11/2005 */
    )
 and dal <= nvl(inec_al,Pnulld)
 and exists (select 'x'
 from astensioni aste
  where codice  = peai.assenza
  and mat_anz = 0
  )
  order by dal
 ;
  BEGIN  -- Modifica data fine Inquadramento
--
-- Ciclo per Inquadramenti economici in cui e' presente una assenza
-- che non matura anzianita'
--
 P_stp := 'PEGI_ASSENZA';
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 FOR R_INEC IN CUR_INEC LOOP
  --
  -- Ciclo sulle assenze dei periodi giuridici
  --
  FOR R_PEGI IN CUR_PEGI (R_INEC.dal,R_INEC.al,R_INEC.voce,R_INEC.qualifica,R_INEC.tipo_rapporto) LOOP
 BEGIN -- Modifica inizio progressioni
  update progressioni_economiche prec
/* modifica del 20/11/95 */
 set inizio = add_months( inizio
  , trunc(R_PEGI.gg / 30)
  )
  + round( R_PEGI.gg
 - trunc(R_PEGI.gg / 30) * 30
 )
/* Vecchia versione
 set inizio = add_months( to_date( '01'||to_char(inizio,'mmyyyy')
  ,'ddmmyyyy')
 ,trunc(( R_PEGI.gg
 +to_number(to_char(inizio,'dd'))
 -1
  )/30)
  )
 +round( R_PEGI.gg
  +to_number(to_char(inizio,'dd'))-1
  -trunc(( R_PEGI.gg
  +to_number(to_char(inizio,'dd'))-1
 )/30
  )*30
 )
*/
/* fine modifica del 20/11/95 */
 where ci =  p_ci
 and dal  =  R_INEC.dal
 and voce =  R_INEC.voce
 and qualifica  =  R_INEC.qualifica
 and tipo_rapporto  =  R_INEC.tipo_rapporto
 and inizio  !=  R_INEC.dal
 and inizio >  R_PEGI.dal
  ;
 END;
 BEGIN -- Modifica fine progressioni
  update progressioni_economiche prec
/* modifica del 20/11/95 */
 set fine =
 least( nvl(R_INEC.al,Pnulld)
  , decode
  ( fine
  , null, R_INEC.al
  , add_months
  ( fine
  , trunc(R_PEGI.gg / 30)
  )
  + round( R_PEGI.gg
 - trunc(R_PEGI.gg / 30) * 30
 )
  )
  )
/* Vecchia versione
 set fine
 = least( nvl(R_INEC.al,Pnulld)
 ,decode( fine
 ,null,R_INEC.al
 ,add_months
 ( to_date( '01'||to_char(fine,'mmyyyy')
 ,'ddmmyyyy')
  ,trunc(( R_PEGI.gg
  +to_number(to_char(fine,'dd'))-1
 )/30)
 )
 +round( R_PEGI.gg
  +to_number(to_char(fine,'dd'))-1
  -trunc(( R_PEGI.gg
  +to_number(to_char( fine
 ,'dd'))-1
 )/30
  )*30
 )
  -1
  )
  )
*/
/* fine modifica del 20/11/95 */
 where ci  =  p_ci
 and dal =  R_INEC.dal
 and voce  =  R_INEC.voce
 and qualifica =  R_INEC.qualifica
 and nvl(fine,Pnulld) >=  R_PEGI.dal
 ;
 END;
  END LOOP; -- Fine ciclo sulle assenze
  BEGIN -- Cancellazione Progressioni che sono diventate obsolete
  delete from progressioni_economiche
 where  ci  = p_ci
 and  dal = R_INEC.dal
 and  voce  = R_INEC.voce
 and  qualifica = R_INEC.qualifica
 and  tipo_rapporto  =  R_INEC.tipo_rapporto
 and  inizio  > fine
  ;
  END;
 END LOOP; -- Fine ciclo sulle progressioni economiche
  END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
  --  Cancella Informazioni Retributive Base,Progressione,Eccedenza
--
-- Annulla le Informazioni di tipo BASE su informazioni Retributive
-- a partire dalla data D_INQE
--
PROCEDURE INRE_ANNULLA
(p_ci     number
,p_ini_ela  date
,p_d_inqe   date
,Pnulld   date  -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
BEGIN
 BEGIN
 P_stp := 'INRE_ANNULLA';
 delete
 from informazioni_retributive inre
  where inre.ci  = p_ci
  and inre.tipo  = 'B'
  and nvl(inre.al,Pnulld) >= nvl(p_d_inqe,p_ini_ela)
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

