CREATE OR REPLACE PACKAGE peccinec IS
/******************************************************************************
 NOME:          PECCINEC   INQUADRAMENTO ECONOMICO COLLETTIVO
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
 3    22/07/2004 AM     Revisione gestione persaonale che scatta nel mese corrente
 3.1  27/12/2006 AM     Introdotta la lettura per max(chiave) anche per le voci a progressione
 3.2  25/07/2007 AM     Corretto il legame INEC/PREC inserendo anche il tipo rapporto              
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
ERRORE VARCHAR2(6);
PASSO_ERR VARCHAR2(30);
   PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER
					);
PROCEDURE INEC_COLLETTIVO
( p_ci  number,
  w_a_alias_pk in varchar2
);
END;
/

CREATE OR REPLACE PACKAGE BODY peccinec IS
form_trigger_failure exception;
w_prenotazione number(10);
w_passo	number(3);
w_a_alias_pk	varchar2(4);
-- Elimina e reinserisce le progressioni
--
-- Genera le nule progressioni economiche
-- relative alla nuova situazione di inquadramento (PROSSIMO = INI_ELA)
-- NUOVE = inserite nella fase corrente
-- PRECEDENTI = da ricalcolare causa aspettative
-- progressioni di periodo
-- Non valide (DATA_AGG = Pnulld)
--
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V3.2 del 25/07/2007';
 END VERSIONE;
PROCEDURE PREC_INSERT
(p_ci number
,p_ini_ela date
,p_d_inqe date
,Pnulld date -- Data null (to_date('3333333','j'))
-- Parametri per Trace
,p_trc IN number -- Tipo di Trace
,p_prn IN number -- Numero di Prenotazione elaborazione
,p_pas IN number -- Numero di Passo procedurale
,p_prs IN OUT number -- Numero progressivo di Seqnalazione
,p_stp IN OUT VARCHAR2 -- Step elaborato
,p_tim IN OUT VARCHAR2 -- Time impiegato in secondi
) IS
BEGIN
 BEGIN -- Eliminazione registrazioni di progressione
 -- relative alla nuova situazione di inquadramento
 -- (PROSSIMO = INI_ELA)
 --
 P_stp := 'PREC_INSERT-01';
 delete
 from progressioni_economiche prec
 where (ci,dal,qualifica,tipo_rapporto,voce)
 in (select ci,dal,qualifica,tipo_rapporto,voce
 from inquadramenti_economici inec
 where inec.ci = p_ci
 and ( prossimo = p_ini_ela
 or data_agg = Pnulld
 )
 )
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
 BEGIN -- Ricalcolo progressioni periodo
 P_stp := 'PREC_INSERT-02';
 insert into progressioni_economiche
 ( ci, dal, qualifica, voce, tipo_rapporto
 , inizio, fine, periodo
 )
 select inec.ci
 , inec.dal
 , inec.qualifica
 , inec.voce
 , inec.tipo_rapporto
 , greatest( inec.dal
 , add_months( inec.dal
 , ( nvl(bavo.mm_inizio,0)
 + bavo.mm_periodo * vpvo.periodo
 - ( inec.aa * 12 + inec.mm )
 - decode( sign(inec.gg)
 , 1, 1
 , 0
 )
 )
 )
 + decode( sign(inec.gg)
 , 0 , 0
 , -1, -inec.gg
 , ( 30 - inec.gg )
 )
 )
 , least( nvl(inec.al,Pnulld)
 , decode( vpvo.periodo
 , nvl( inec.max_periodi
 , nvl(bavo.min_periodi,bavo.max_periodi)
 )
 , decode( inec.al
 , Pnulld, to_date(null)
 , inec.al
 )
 , add_months( inec.dal
 , ( nvl(bavo.mm_inizio,0)
 + bavo.mm_periodo
 * (vpvo.periodo+1)
 - ( inec.aa *12 + inec.mm)
 - decode(sign(inec.gg), 1, 1, 0)
 )
 )
 + decode( sign(inec.gg)
 , 0, 0
 , -1, -1 * inec.gg
 , ( 30 - inec.gg )
 )
 - 1
 )
 )
 , vpvo.periodo
 from valori_progressione_voce vpvo
 , basi_voce bavo
 , qualifiche_giuridiche qugi
 , inquadramenti_economici inec
 where inec.ci = p_ci
 and inec.prossimo = p_ini_ela
 and inec.data_agg != Pnulld
 and inec.dal between qugi.dal and nvl(qugi.al,Pnulld)
 and vpvo.voce = bavo.voce
 and vpvo.contratto = bavo.contratto
 and vpvo.dal = bavo.dal
 and vpvo.periodo <= nvl( inec.max_periodi
 , nvl( bavo.min_periodi
 , bavo.max_periodi
 )
 )
/* modifica del 27/12/2006 - introdotta la lettura per max(chiave) */
-- vecchia lettura:
-- and qugi.livello like vpvo.livello
-- and nvl(inec.tipo_rapporto,' ')
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
 and bavo.voce = inec.voce
 and bavo.classe = 'P'
 and bavo.contratto = qugi.contratto
 and inec.dal between bavo.dal and nvl(bavo.al,Pnulld)
 and qugi.numero = inec.qualifica
 and ( ( ( nvl(bavo.mm_inizio,0)
 + bavo.mm_periodo * (vpvo.periodo+1)
 ) * 30
 - ( inec.aa * 12 + inec.mm ) * 30
 - inec.gg
 ) > 0
 or vpvo.periodo = nvl( inec.max_periodi
 , nvl( bavo.min_periodi
 , bavo.max_periodi
 )
 )
 )
 and ( add_months( inec.dal
 , ( nvl(bavo.mm_inizio,0)
 + bavo.mm_periodo * (vpvo.periodo+1)
 - ( inec.aa * 12 + inec.mm )
 - decode(sign(inec.gg),1,1,0)
 )
 ) + decode( sign(inec.gg)
 , 0, 0
 , -1, -inec.gg
 , ( 30 - inec.gg )
 ) - 1
 <=
 add_months( nvl( decode( inec.al
 , Pnulld, to_date(null)
 , inec.al
 ) - 1
 , p_ini_ela
 + decode( bavo.gg_periodo
 , 0 , 0
 , least
 ( bavo.gg_periodo
 , to_char
 ( last_day(p_ini_ela)
 , 'dd'
 )
 ) - 1
 )
 )
 , decode( to_char(bavo.gg_periodo)||
 bavo.beneficio_anzianita
 , '0M', bavo.mm_periodo
 , 0
 ) + bavo.mm_periodo * 2
 )
 or vpvo.periodo = 0
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
--  Identificazione Progressioni con Assenze
--
--  Attiva PROSSIMO = inizio mese per tutte le registrazioni
--  che contengono periodi di assenza che non maturano anzianita'
--
PROCEDURE INEC_UPDATE_ASS
(p_ci number
,p_ini_ela  date
,p_d_inqe date
,Pnulld date  -- Data null (to_date('3333333','j'))
/* modifica del 09/06/95 */
,P_flag_inqe  VARCHAR2
/* fine modifica del 09/06/95 */
-- Parametri di Output
,P_inec_ass OUT number  -- INEC che hanno assenze
-- Parametri per Trace
,p_trc  IN  number  -- Tipo di Trace
,p_prn  IN  number  -- Numero di Prenotazione elaborazione
,p_pas  IN  number  -- Numero di Passo procedurale
,p_prs  IN OUT  number  -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2  -- Step elaborato
,p_tim  IN OUT  VARCHAR2  -- Time impiegato in secondi
) IS
BEGIN
 BEGIN --  Attiva Prossimo = p_ini_ela
 P_stp := 'INEC-UPDATE_ASS';
 update inquadramenti_economici inec
  set inec.prossimo = p_ini_ela
 ,inec.al = nvl(inec.al,Pnulld)
  where inec.ci  = p_ci
  and nvl(inec.al,Pnulld) >= p_d_inqe
  and inec.data_agg  != Pnulld
/* modifica del 09/06/95 */
  and ( P_flag_inqe = 'A'
 or exists
 (select 'x'
  from periodi_assenza_inec peai
 where peai.ci = inec.ci
-- and nvl(pegi.al,Pnulld) >= inec.dal
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
 and exists  (select 'x'
  from astensioni aste
 where codice  = peai.assenza
 and mat_anz = 0
 )
 )
  )
/* fine modifica del 09/06/95 */
  ;
  P_inec_ass := SQL%ROWCOUNT;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
--  Modifica al di registrazione INQUADRAMENTI ECONOMICI
--
--
--  Produce la data di fine Inquadramento attivandola a Pnulld
--  sulle registrazioni con  PROSSIMO = inizio mese
--  - Registrazioni di inquadramento appena generate
--  - Inquadramenti che progrediscono nel mese in corso
--  in cui attiva anche DATA_AGG = inizio mese
--
PROCEDURE INEC_UPDATE
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
 BEGIN  -- Modifica data fine Inquadramento
  P_stp := 'INEC_UPDATE';
  update inquadramenti_economici inec
 set inec.al
  = (select least( min(nvl(pegi.al,Pnulld))
  ,min(nvl(qugi.al,Pnulld))
  ,min(nvl(bavo.al,Pnulld))
 )
 from basi_voce bavo
 ,qualifiche_giuridiche qugi
 ,periodi_giuridici pegi
  where pegi.ci = inec.ci
  and pegi.rilevanza in ('E','S')
  and pegi.qualifica  = inec.qualifica
  and nvl(pegi.tipo_rapporto,' ')
  = nvl(inec.tipo_rapporto,' ')
  and bavo.voce = inec.voce
  and least( nvl(pegi.al,Pnulld)
  ,nvl(qugi.al,Pnulld)
  ,nvl(bavo.al,Pnulld)
  )  >= inec.dal
  and bavo.contratto  = qugi.contratto
  and bavo.dal <= least( nvl(qugi.al,Pnulld)
  ,nvl(pegi.al,Pnulld)
 )
  and nvl(bavo.al,Pnulld)
 >= greatest(qugi.dal,pegi.dal)
  and qugi.dal <= nvl(pegi.al,Pnulld)
  and nvl(qugi.al,Pnulld)  >= pegi.dal
  and qugi.numero = pegi.qualifica
  and not exists
 (select 'x'
  from periodi_giuridici pegi2
 where pegi2.ci =  pegi.ci
 and pegi2.rilevanza in ('E','S')
 and pegi2.qualifica  =  pegi.qualifica
 and nvl(pegi2.tipo_rapporto,' ')
 = nvl(pegi.tipo_rapporto,' ')
 and (  pegi2.dal  =  pegi.al+1
  and nvl(pegi.al,Pnulld)
 <  least( nvl(qugi.al,Pnulld)
 , nvl(bavo.al,Pnulld)
 )
  or  pegi.rilevanza  = 'E'
  and pegi2.rilevanza = 'S'
  and pegi.dal between pegi2.dal
 and nvl(pegi2.al,Pnulld)
 )
 )
 )
 ,data_agg = p_ini_ela
 where inec.ci = p_ci
 and inec.prossimo = p_ini_ela
 and inec.data_agg  != Pnulld
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Reinquadramento Economico
--
-- - Genera registrazioni in INQUADRAMENTI ECONOMICI
--
PROCEDURE INEC_INSERT
(p_ci IN number
,p_ini_ela IN date
,p_d_inqe  IN date
,Pnulld IN date -- Data null (to_date('3333333','j'))
-- Dati di Output
,P_inec_old  IN OUT number -- Inquadramenti Old
,P_inec_old_del IN OUT number -- Inquadramenti Old cancellati
-- Parametri per Trace
,p_trc  IN number -- Tipo di Trace
,p_prn  IN number -- Numero di Prenotazione elaborazione
,p_pas  IN number -- Numero di Passo procedurale
,p_prs  IN OUT  number -- Numero progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2 -- Step elaborato
,p_tim  IN OUT  VARCHAR2 -- Time impiegato in secondi
) IS
BEGIN
 BEGIN -- Attiva con DATA_AGG = Pnulld le registrazioni
 -- di progressioni_economiche
 -- Le progressioni economiche che rimarranno con tale data di
 -- aggiornamento dovranno essere eliminate individualmente
 -- dall'utente dopo averle consultate.
 --
 P_stp := 'INEC_INSERT-01';
 update inquadramenti_economici inec
 set inec.data_agg  = Pnulld
 where inec.ci  = P_ci
 ;
 P_inec_old := SQL%ROWCOUNT;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
 BEGIN -- Inserimento progressioni economiche dai periodi giuridici
 --  Genera le progressioni con PROSSIMO e DATA_AGG = p_ini_ela
 --  per modificare l'al nello steP_ini_elae
 --
 P_stp := 'INEC_INSERT-02';
 insert into inquadramenti_economici
  ( ci, dal
  , qualifica, tipo_rapporto, voce
  , aa, mm, gg
  , eccedenza
  , periodo, prossimo, data_agg
  )
 select P_ci, greatest(qugi.dal,bavo.dal,pegi.dal)
  , pegi.qualifica, pegi.tipo_rapporto, bavo.voce
  , 0, 0, 0
  , decode(max(bavo.voce_ecce), null, 0, null)
  , 0, P_ini_ela, P_ini_ela
  from periodi_giuridici pegi
  , basi_voce  bavo
  , qualifiche_giuridiche  qugi
 where  pegi.ci  = P_ci
 and  pegi.rilevanza in ('E','S')
 and  qugi.dal <= nvl(pegi.al,Pnulld)
 and nvl(qugi.al,Pnulld)  >=  pegi.dal
 and  qugi.numero =  pegi.qualifica
 and  bavo.contratto =  qugi.contratto
 and  bavo.dal <= least( nvl(qugi.al,Pnulld)
 ,nvl(pegi.al,Pnulld)
 )
 and nvl(bavo.al,Pnulld)  >= greatest(qugi.dal,pegi.dal)
 and bavo.voce_base in
 (select distinct voce
 from valori_base_voce vbvo
  where  vbvo.contratto =  qugi.contratto
 and  vbvo.dal  <= least( nvl(qugi.al,Pnulld)
 ,nvl(pegi.al,Pnulld)
 )
 and nvl(vbvo.al,Pnulld) >= greatest( qugi.dal
 ,pegi.dal)
/* modifica del 27/12/2006 - introdotta lettura per chiave massima */
-- vecchia lettura:
-- and  pegi.gestione like vbvo.gestione
-- and nvl(qugi.ruolo,' ')  like vbvo.ruolo
-- and  qugi.livello  like vbvo.livello
-- and  qugi.codice like vbvo.qualifica
-- and nvl(pegi.tipo_rapporto,' ')
--  like vbvo.tipo_rapporto
-- nuova lettura:
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
/* fine modifica del 27/12/2006 */
 )
 and exists
 (select 'x'
 from valori_progressione_voce vpvo
  where  vpvo.voce = bavo.voce
 and  vpvo.contratto = bavo.contratto
 and  vpvo.dal = bavo.dal
/* modifica del 27/12/2006 - introdotta la lettura per max(chiave) */
-- vecchia lettura:
-- and  qugi.livello like vpvo.livello
-- and nvl(pegi.tipo_rapporto,' ') like vpvo.tipo_rapporto
-- nuova lettura:
 and vpvo.livello||vpvo.tipo_rapporto =
 (select max(vpvo2.livello||vpvo2.tipo_rapporto)
    from valori_progressione_voce vpvo2
   where vpvo2.voce = vpvo.voce
     and vpvo2.contratto = vpvo.contratto
     and vpvo2.dal = vpvo.dal
     and vpvo2.periodo = vpvo.periodo
     and qugi.livello like vpvo2.livello
     and nvl(pegi.tipo_rapporto,' ') like vpvo2.tipo_rapporto
 )
/* fine modifica del 27/12/2006 */
 )
 and not exists
 (select 'x'
 from periodi_giuridici pegi2
  where  pegi2.ci  = pegi.ci
 and  pegi2.rilevanza in ('E','S')
 and  pegi2.qualifica = pegi.qualifica
 and nvl(pegi2.tipo_rapporto,' ')
 = nvl(pegi.tipo_rapporto,' ')
 and (  pegi2.al = pegi.dal-1
 and  pegi.dal not in (qugi.dal,bavo.dal)
 and nvl(pegi2.al,Pnulld) >= bavo.dal
 or pegi.rilevanza  = 'E'
 and  pegi2.rilevanza = 'S'
 and  pegi.dal  between  pegi2.dal
 and nvl(pegi2.al,Pnulld)
  )
 )
 group by greatest(qugi.dal,bavo.dal,pegi.dal)
 , pegi.qualifica, pegi.tipo_rapporto, bavo.voce
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
 BEGIN
 INEC_UPDATE  -- Modifica data al degli inquadramenti inseriti
 (P_ci, P_ini_ela, P_d_inqe, Pnulld
 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 END;
 BEGIN -- Aggiornamento registrazioni in Inquadramenti Economici
 -- (PROSSIMO = inizio mese) con i dati
 --  della precedente registrazione (se esistevano)
 -- Se non esistono variazioni alla data di FINE periodo
 -- riporta in PROSSIMO la data precedente,
 -- e rimette NULL in data AL se = Pnulld
 -- In DATA_AGG rimane la data di inizio mese elaborazione
 -- per distinguere le registrazioni dell' inquadramento
 --
 -- Aggiornamenti:
 --  11/11/1993 Controllo esistenza data AL = 3333300
 -- introdotta in TRASCODIFICA per ricalcolo
 -- delle Progressioni di Inquadramento
 --
  IF P_inec_old > 0 THEN -- se esistevano precedenti registrazioni
 P_stp := 'INEC_INSERT-03';
 update inquadramenti_economici inec
 set ( periodo
  , aa, mm, gg
  , eccedenza
  , max_periodi
  , prossimo
  , al
  )
 = (select inec2.periodo
  , inec2.aa, inec2.mm, inec2.gg
  , inec2.eccedenza
  , inec2.max_periodi
  , decode( nvl(inec2.al,Pnulld)
 , inec.al, inec2.prossimo
 , P_ini_ela
 )
  , decode( decode( nvl(inec2.al,Pnulld)
 , inec.al, inec2.prossimo
 , P_ini_ela
 )
 , P_ini_ela, inec.al
 , decode( inec.al
  , Pnulld, to_date(null)
 , inec.al
  )
 )
  from inquadramenti_economici inec2
 where inec2.ci  = inec.ci
 and inec2.qualifica = inec.qualifica
 and inec2.voce = inec.voce
 and inec2.dal = inec.dal
 and inec2.data_agg  = Pnulld
  )
  where inec.ci  = P_ci
 and inec.prossimo  = P_ini_ela
 and inec.data_agg != Pnulld
 and(exists
 (select 'x'
 from inquadramenti_economici inec3
 where inec3.ci  = inec.ci
  and inec3.qualifica = inec.qualifica
  and inec3.voce = inec.voce
  and inec3.dal = inec.dal
  and inec3.data_agg  = Pnulld
 )
 or exists
 (select 'x'
 from inquadramenti_economici inec3
 where inec3.ci  = inec.ci
  and inec3.qualifica = inec.qualifica
  and inec3.voce = inec.voce
  and inec3.dal = inec.dal
  and inec3.data_agg  = Pnulld
  and inec3.al  = to_date('3333300','j')
 )
 )
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
  END IF;
 END;
 BEGIN -- Calcolo AUTOMATICO dell'anzianita' e dell'eccedenza per le
 -- registrazioni di inquadramento inserite nella fase corrente
 -- (PROSSIMO = inizio mese) con i dati dei precedenti periodi.
 -- Riporta i dati di AA MM GG ECCEDENZA.
 -- Eseguito solo se la reegistrazione non e` identica ad una
 -- precedente, per la quale Beneficio ed Eccedenza sono gia`
 -- state registrate.
 -- Eseguito solo in caso di BENEFICIO_ANZIANITA = 'A'
  P_stp := 'INEC_INSERT-04';
  FOR INEC in
 (select ci,voce,dal,qualifica,tipo_rapporto,data_agg,eccedenza
 from inquadramenti_economici inec
 where inec.ci = P_ci
  and inec.prossimo = P_ini_ela
  and nvl(inec.aa,0)+nvl(inec.mm,0)+nvl(inec.gg,0)
  +nvl(inec.eccedenza,0)
  = 0
  and exists
  (select 'x'
  from inquadramenti_economici inec3
 where  inec3.ci =  inec.ci
 and  inec3.voce =  inec.voce
 and  inec3.dal  <  inec.dal
 and nvl(inec3.al,Pnulld) >=  inec.dal-1
 and  inec3.data_agg  != Pnulld
  )
  and exists
  (select 'x'
  from basi_voce bavo
 where nvl(bavo.beneficio_anzianita,'A') = 'A'
 and bavo.voce = inec.voce
 and bavo.contratto =
 (select max(contratto)
 from qualifiche_giuridiche qugi
  where qugi.numero = inec.qualifica
 and inec.dal between nvl( qugi.dal
 , to_date('2222222','j')
 )
 and nvl( qugi.al
 , to_date('3333333','j')
 )
 )
 and inec.dal between nvl( bavo.dal
 , to_date('2222222','j')
 )
  and nvl( bavo.al
 , to_date('3333333','j')
 )
 )
  order by voce,dal
 )
  LOOP
  update inquadramenti_economici
 set ( aa, mm, gg
 , eccedenza
 , max_periodi
 )
 =
(select trunc( sum( trunc(months_between( last_day(inec.dal)
  ,last_day(inec2.dal))
 )*30
 -least(30,to_number(to_char(inec2.dal,'dd')))+1
 +least(30,to_number(to_char(inec.dal,'dd')))-1
 +nvl(inec2.aa,0)*360+nvl(inec2.mm,0)*30+nvl(inec2.gg,0)
 )
  / 360) aa
  ,trunc(mod( sum( trunc(months_between( last_day(inec.dal)
 ,last_day(inec2.dal))
 )*30
 -least(30,to_number(to_char(inec2.dal,'dd')))+1
 +least(30,to_number(to_char(inec.dal,'dd')))-1
  +nvl(inec2.aa,0)*360+nvl(inec2.mm,0)*30+nvl(inec2.gg,0)
  )
 , 360
 )/30) mm
,trunc(mod( mod( sum( trunc(months_between( last_day(inec.dal)
 ,last_day(inec2.dal))
 )*30
 -least(30,to_number(to_char(inec2.dal,'dd')))+1
 +least(30,to_number(to_char(inec.dal,'dd')))-1
 +nvl(inec2.aa,0)*360+nvl(inec2.mm,0)*30+nvl(inec2.gg,0)
  )
 , 360)
 ,30)) gg
 , decode( inec.eccedenza
  , 0, sum(inec2.eccedenza)
  , null
  ) eccedenza
 , min(inec2.max_periodi) max_periodi
 from inquadramenti_economici inec2
  where  inec2.ci  = inec.ci
 and  inec2.voce = inec.voce
 and  inec2.data_agg != Pnulld
 and  inec2.dal
 =  (select max(inec3.dal)
 from inquadramenti_economici inec3
  where  inec3.ci  =  inec.ci
 and  inec3.voce =  inec.voce
 and  inec3.data_agg !=  Pnulld
 and  inec3.dal <  inec.dal
 and nvl(inec3.al,Pnulld)  >=  inec.dal-1
 )
)
 where ci = inec.ci
  and dal = inec.dal
  and voce = inec.voce
  and qualifica = inec.qualifica
  and nvl(tipo_rapporto,' ') = nvl(inec.tipo_rapporto,' ')
  and data_agg = inec.data_agg
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END LOOP;
 END;
 BEGIN -- Eliminazione precedenti registrazioni di inquadramento
 -- duplicate DATA_AGG = Pnulld
 --
 IF P_inec_old = 0 THEN
 P_inec_old_del := 0;
 ELSE
 P_stp := 'INEC_INSERT-05';
 delete inquadramenti_economici inec
  where inec.ci = P_ci
 and data_agg = Pnulld
 and exists (select 'x'
 from inquadramenti_economici inec2
  where inec2.ci = inec.ci
 and inec2.qualifica  = inec.qualifica
 and inec2.voce = inec.voce
 and inec2.dal  = inec.dal
 and inec2.data_agg  != Pnulld
 )
  ;
 P_inec_old_del := SQL%ROWCOUNT;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END IF;
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN RAISE;
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
  RAISE FORM_TRIGGER_FAILURE;
END;
-- Aggiornamento Posizione Giuridica Individuale
--
PROCEDURE RAGI_UPDATE_POS
(P_ci number
,P_fin_ela date
,P_stp  IN OUT  VARCHAR2 -- Step elaborato
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
 where posi.codice = pegi.posizione
 and qugi.numero (+)  = pegi.qualifica
 and least(nvl(pegi.al,to_date('3333333','j')),P_fin_ela)
 between
 nvl(qugi.dal,to_date('2222222','j'))
 and
 nvl(qugi.al ,to_date('3333333','j'))
 and pegi.ci = P_ci
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
 and pegi.ci = P_ci
 and pegi.rilevanza  = 'E'
 and pegi.dal  = (select max(dal)
 from periodi_giuridici
 where ci  = P_ci
  and rilevanza = 'E'
  and dal <= P_fin_ela
 )
 and ( nvl(pegi.al,to_date('3333333','j')) >=
  nvl(ragi.al,to_date('3333333','j'))
  or P_fin_ela
 between pegi.dal
 and nvl(pegi.al,to_date('3333333','j'))
 )
  )
  where ragi.ci = P_ci
 and exists
 (select 'x'
 from periodi_giuridici
 where ci  = P_ci
  and rilevanza = 'E'
  and dal = (select max(dal)
 from periodi_giuridici
  where ci  = P_ci
 and rilevanza = 'E'
 and dal <= P_fin_ela
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
-- Inquadramento Economico per ogni Individuo
--
--
PROCEDURE INEC_INDIVIDUALE
(p_ci  number
,p_ini_ela date
,p_fin_ela date
-- Parametri per Trace
,p_trc  IN number -- Tipo di Trace
,p_prn  IN number -- Num. di Prenotazione elaborazione
,p_pas  IN number -- Num. di Passo procedurale
,p_prs  IN OUT  number -- Num. progressivo di Seqnalazione
,p_stp  IN OUT  VARCHAR2 -- Step elaborato
,p_tim  IN OUT  VARCHAR2 -- Time impiegato in sec.
,errore in out varchar2
) IS
BEGIN
 DECLARE
 d_nulld  DATE := to_date('3333333','j');
 d_inec_old  NUMBER := 0;
 d_inec_old_del NUMBER := 0;
 d_inec_ass  NUMBER := 0;
 d_flag_inqe RAPPORTI_GIURIDICI.FLAG_INQE%TYPE;
 d_d_inqe RAPPORTI_GIURIDICI.D_INQE%TYPE;
 CURSOR CUR_RAGI (S_ci number) IS
 select ci,flag_inqe,d_inqe
 from rapporti_giuridici ragi
  where ci = S_ci
 and flag_inqe in ('M','A','R','I')
 FOR UPDATE OF FLAG_INQE NOWAIT;
 R_RAGI CUR_RAGI%ROWTYPE;
 BEGIN  -- Apertura Cursore e calcolo inquadramento
 P_stp := 'INEC_INDIVIDUALE-01';
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
commit;
 OPEN  CUR_RAGI (P_ci);
 FETCH CUR_RAGI INTO R_RAGI;
 IF CUR_RAGI%FOUND THEN
 RAGI_UPDATE_POS  -- Consolida l'ultima situazione giuridica
 -- ( per tutela del dato corretto )
 (P_ci,P_fin_ela,P_stp);
 D_flag_inqe := R_RAGI.FLAG_INQE;
 D_d_inqe := nvl(R_RAGI.D_INQE,P_ini_ela);
 IF D_flag_inqe in ('M','A') THEN
 INEC_INSERT  -- Registrazione inquadramenti economici
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
  , d_inec_old, d_inec_old_del
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 ELSIF D_flag_inqe = 'R' THEN
 INEC_UPDATE  -- Determinazione data AL per gli inquadramenti
  --  che scattano
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 END IF;
 IF D_flag_inqe != 'I' THEN
-- IF D_flag_inqe in ('M','A') THEN
 INEC_UPDATE_ASS -- Attiva prossimo su INEC per assenze
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
  , D_flag_inqe, D_inec_ass
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
-- END IF;
-- IF D_flag_inqe != 'I' THEN
 PREC_INSERT  -- Progressioni Economiche
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 IF D_inec_ass > 0 THEN
    peccinec2.PEGI_ASSENZA -- Nuova progressione per assenze
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 END IF;
 peccinec2.INRE_ANNULLA  -- Cancella le informazioni retributive
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 peccinec2.INRE_BASE  -- Registra informazioni retributive BASE
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 peccinec2.INRE_PREC_ECCE -- Informazioni Retributive Progr. Eccedenza
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim,errore
 );
 peccinec2.INEC_PROSSIMO -- Aggiorna Periodo e Prossimo su INEC
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 peccinec3.INRE_BASE_TOT -- Registra informazioni BASE su Totali
 (P_ci, P_ini_ela, D_d_inqe, D_nulld
 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
 );
 END IF;
 IF D_flag_inqe = 'I' THEN
 BEGIN
 select 'I'
 into D_flag_inqe
 from inquadramenti_economici
  where ci = P_ci
 and data_agg in (P_ini_ela, to_date(3333333,'j'))
 ;
 RAISE TOO_MANY_ROWS;
 EXCEPTION
 WHEN TOO_MANY_ROWS THEN
 D_flag_inqe := 'I';
 WHEN OTHERS THEN
 D_flag_inqe := null;
 END;
 ELSIF
 D_inec_old - D_inec_old_del > 0 THEN
 D_flag_inqe := 'I'; -- Se rimangono progressioni da
 -- riguardare
 ELSE
 D_flag_inqe := null;
 END IF;
 BEGIN
 P_stp := 'INEC_INDIVIDUALE-02';
 update rapporti_giuridici ragi
 set d_inqe = to_date(null)
 ,flag_inqe = D_flag_inqe
 where CURRENT OF CUR_RAGI
 ;
 trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
 END;
 END IF;
 CLOSE CUR_RAGI;
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
  RAISE; -- Errore gia` gestito in sub-procedure
 WHEN OTHERS THEN
  trace.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim,20);
commit;
  RAISE FORM_TRIGGER_FAILURE;
END;
--  Routine di Inquadramento Economico
--
--
PROCEDURE INEC_COLLETTIVO
( p_ci  number,
  w_a_alias_pk in varchar2 ) IS
-- Dati per gestione TRACE
d_trc NUMBER(1);  -- Tipo di Trace
d_prn NUMBER(6);  -- Numero di Prenotazione
d_pas NUMBER(2);  -- Numero di Passo procedurale
d_prs NUMBER(10); -- Numero progressivo di Segnalazione
d_stp VARCHAR2(30); -- Identificazione dello Step in oggetto
d_cnt NUMBER(5);  -- Count delle row trattate
d_tim VARCHAR2(5);  -- Time impiegato in secondi
d_tim_ci  VARCHAR2(5);  -- Time impiegato in secondi del Cod.Ind.
d_tim_tot VARCHAR2(5);  -- Time impiegato in secondi Totale
--
-- Dati per deposito informazioni generali
--
d_ini_ela  RIFERIMENTO_RETRIBUZIONE.INI_ELA%TYPE;
d_fin_ela  RIFERIMENTO_RETRIBUZIONE.FIN_ELA%TYPE;
BEGIN
BEGIN  -- Assegnazioni Iniziali per Trace
D_prn := nvl(w_prenotazione,0);
D_pas := nvl(w_passo,0);
IF w_a_alias_pk = 'RAGI' THEN  -- Attiva solo in collettiva
	D_trc := null;
ELSIF
	D_prn = 0 THEN
 	D_trc := 1;
 	delete from a_segnalazioni_errore
  	 where no_prenotazione = D_prn
  	 and passo = D_pas
;
ELSE
	D_trc := null;
END IF;
BEGIN  -- Preleva numero max di segnalazione
 select nvl(max(progressivo),0)
 into D_prs
 from a_segnalazioni_errore
  where no_prenotazione = D_prn
  and passo = D_pas
 ;
  END;
 END;
 D_tim := to_char(sysdate,'sssss');
 D_tim_tot := to_char(sysdate,'sssss');
 IF w_a_alias_pk = 'RAGI' THEN  -- Attiva solo in collettiva
  null;
 ELSE
  D_stp := 'PECCINEC-Start';
  trace.log_trace(0,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
commit;
 END IF;
 BEGIN
 D_stp := 'INEC_COLLETTIVO';
 select ini_ela
  , fin_ela
 into d_ini_ela
  , d_fin_ela
 from riferimento_retribuzione
 ;
 trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
 END;
 IF P_ci is not null THEN
  INEC_INDIVIDUALE
 (P_ci,D_ini_ela,D_fin_ela,D_trc,D_prn,D_pas,D_prs,D_stp,D_tim,errore);
  commit;
 ELSE
  <<ciclo_ci>>
  DECLARE
  D_dep_ci  number;  -- Codice Individuale per Ripristino LOOP
  D_ci_start  number;  -- Codice Individuale di partenza LOOP
  D_count_ci  number;  -- Contatore ciclico Individui trattati
  --
  BEGIN  -- Ciclo su Individui
  D_dep_ci := 0;  -- Disattivazione iniziale del Ripristino
  D_ci_start := 0;  -- Attivazione partenza del Ciclo Individui
  D_count_ci := 0;  -- Azzeramento iniziale contatore Individui
  LOOP  -- Ripristino Ciclo su Individui:
  -- - in caso di Errore Individuale
  -- - in caso di LOOP ciclico per rilascio ROLLBACK_SEGMENTS
  FOR CURI IN
 (select ci
  from rapporti_giuridici
 where flag_inqe in ('M','A','R','I')
 and ci > D_ci_start
 )
  LOOP
  <<tratta_ci>>
  BEGIN
  D_count_ci := D_count_ci + 1;
  D_tim_ci := to_char( to_number(to_char(sysdate,'sssss')));
  INEC_INDIVIDUALE
 (CURI.CI,D_ini_ela,D_fin_ela,D_trc,D_prn,D_pas,D_prs,D_stp,D_tim,errore);
  EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
 BEGIN  -- Preleva numero max di segnalazione
 select nvl(max(progressivo),0)
 into D_prs
 from a_segnalazioni_errore
 where no_prenotazione = D_prn
 and passo = D_pas
 ;
 END;
 D_stp := '!!! Error #'||to_char(CURI.CI);
  trace.log_trace(8,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci,20);
 errore := 'P05809'; -- Errore in Elaborazione
 passo_err := D_stp;  -- Step Errato
 commit;
 D_dep_ci := curi.ci;  -- Attivazione Ripristino LOOP
 EXIT; -- Uscita dal LOOP
  END tratta_ci;
  D_stp := 'Complete #'||to_char(CURI.CI);
 trace.log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_ci,20);
  commit;
  D_trc := null;  -- Disattiva Trace dettagliata
 -- dopo primo Individuo
  BEGIN  -- Uscita dal ciclo ogni 10 Individui
 -- per rilascio ROLLBACK_SEGMENTS di Read_consistency
 -- cursor di select su RAPPORTI_GIURIDICI
 IF D_count_ci = 10 THEN
  D_count_ci := 0;
  D_dep_ci := curi.ci;  -- Attivazione Ripristino LOOP
  EXIT; -- Uscita dal LOOP
 END IF;
  END;
  END LOOP;  -- Fine LOOP su Ciclo Individui
  IF D_dep_ci = 0 THEN
 EXIT;
  ELSE
 D_ci_start := D_dep_ci;
 D_dep_ci := 0;
  END IF;
  END LOOP;  -- Fine LOOP per Ripristino Ciclo Individui
  END ciclo_ci;
 END IF;
 BEGIN  -- Operazioni finali per Trace
  IF w_a_alias_pk = 'RAGI' THEN
 null;
  ELSE
 D_stp := 'PECCINEC-Stop';
 trace.log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_tot,20);
 commit;
  END IF;
  IF errore != 'P05809' AND -- Errore in Elaborazione
 errore != 'P05808' THEN  -- Segnalazione
 errore := 'P05802';  -- Elaborazione Completata
  END IF;
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN  -- Errore gestito in sub-procedure
  errore := 'P05809'; -- Errore in Elaborazione
  passo_err := D_stp;  -- Step Errato
 WHEN OTHERS THEN
 trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim,20);
  errore := 'P05809'; -- Errore in Elaborazione
  passo_err := D_stp;  -- Step Errato
END;
 PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER
					) is
BEGIN
 w_prenotazione := nvl(prenotazione,0);
 w_a_alias_pk := null;
 w_passo := passo;
 errore  := to_char(null);
 INEC_COLLETTIVO(null,w_a_alias_pk);  --Inquadramento Collettivo
 IF w_prenotazione != 0 THEN
 IF substr(errore,6,1) = '8' THEN
 update a_prenotazioni
 set errore = 'P05808'
 where no_prenotazione = w_prenotazione
 ;
 commit;
 ELSIF
 substr(errore,6,1) = '9' THEN
 update a_prenotazioni
 set errore = 'P05809'
  , prossimo_passo = 91
 where no_prenotazione =w_prenotazione
 ;
 commit;
 END IF;
 END IF;
EXCEPTION
 WHEN OTHERS THEN
 BEGIN
 ROLLBACK;
 IF w_prenotazione != 0 THEN
 update a_prenotazioni
 set errore = '*Abort*'
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

