CREATE OR REPLACE PACKAGE peccinec3 IS
/******************************************************************************
 NOME:          PECCINEC3
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
  PROCEDURE INRE_BASE_TOT
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
END;
/
CREATE OR REPLACE PACKAGE BODY peccinec3 IS
form_trigger_failure exception;
  --  Inserisce Informazioni Base su Totali
--
--
-- Inserisce informazioni retributive BASE su voci di Totalizzazione
-- a partire dalla data D_INQE
--
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;

PROCEDURE INRE_BASE_TOT
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
/* modifica del 26/06/95 */
 BEGIN  -- Inserisce voci Totale per informazioni Base su Totale
  P_stp := 'INRE_BASE_TOT_INS';
 FOR CURS in
 (select distinct
 tovo.voce_acc
 , decode(inre.tipo,'B',inre.sub,'*') rilevanza
 , decode( greatest( nvl(inre.dal,to_date('2222222','j'))
 , nvl(tovo.dal,to_date('2222222','j'))
 )
 , to_date('2222222','j'), to_date(null)
 , greatest( nvl(inre.dal,to_date('2222222','j'))
 , nvl(tovo.dal,to_date('2222222','j'))
 )
 ) dal
  from totalizzazioni_voce  tovo
 , informazioni_retributive inre
 where tovo.voce_acc in
  (select distinct voce_ecce
 from basi_voce
  where classe = 'B'
  and voce_ecce is not null
  )
 and tovo.voce =  inre.voce||''
 and nvl(tovo.sub, inre.sub) = inre.sub
 and nvl(tovo.dal,to_date('2222222','j'))
  <= nvl(inre.al , to_date('3333333','j'))
 and nvl(tovo.al ,to_date('3333333','j'))
  >= nvl(inre.dal, to_date('2222222','j'))
 and inre.ci = P_ci
 and nvl(inre.al,Pnulld) >= nvl(p_d_inqe,p_ini_ela)
  UNION
  select distinct
 tovo.voce_acc
 , decode(inre.tipo,'B',inre.sub,'*') rilevanza
 , least( nvl(inre.al,to_date('3333333','j'))
  , nvl(tovo.al,to_date('3333333','j'))
  ) + 1 dal
  from totalizzazioni_voce  tovo
 , informazioni_retributive inre
 where tovo.voce_acc in
  (select distinct voce_ecce
 from basi_voce
  where classe = 'B'
  and voce_ecce is not null
  )
 and tovo.voce =  inre.voce||''
 and nvl(tovo.sub, inre.sub) = inre.sub
 and nvl(tovo.dal,to_date('2222222','j'))
  <= nvl(inre.al , to_date('3333333','j'))
 and nvl(tovo.al ,to_date('3333333','j'))
  >= nvl(inre.dal, to_date('2222222','j'))
 and ( inre.al  is not NULL
  or tovo.al  is not NULL
 )
 /* modifica del 08/11/95 */
 and nvl(inre.al+1,Pnulld) >
  (select nvl(max(dal),to_date('2222222','j'))
 from informazioni_retributive
  where ci = P_ci
  and tipo = 'B'
  )
  -- and nvl(inre.al,Pnulld) >= nvl(p_d_inqe,p_ini_ela)
 /* fine modifica del 08/11/95 */
 and inre.ci = P_ci
 ) LOOP
  BEGIN
 /* modifica del 20/10/95 */
 IF curs.rilevanza = '*' THEN
  insert into informazioni_retributive
 ( ci
 , voce
 , sub
 , sequenza_voce
 , dal
 , tipo
 )
 select  P_ci
 , curs.voce_acc
 , 'Q'
 , 0
 , curs.dal
 , 't'
 from dual
  where not exists
 (select 'x'
  from informazioni_retributive
 where ci = P_ci
 and voce = curs.voce_acc
 and sub  = 'Q'
 and dal = curs.dal
 )
  ;
  insert into informazioni_retributive
 ( ci
 , voce
 , sub
 , sequenza_voce
 , dal
 , tipo
 )
 select  P_ci
 , curs.voce_acc
 , 'I'
 , 0
 , curs.dal
 , 't'
 from dual
  where not exists
 (select 'x'
  from informazioni_retributive
 where ci = P_ci
 and voce = curs.voce_acc
 and sub  = 'I'
 and dal = curs.dal
 )
  ;
 ELSE
  insert into informazioni_retributive
 ( ci
 , voce
 , sub
 , sequenza_voce
 , dal
 , tipo
 )
 select P_ci
 , curs.voce_acc
 , curs.rilevanza
 , 0
 , curs.dal
 , 't'
 from dual
  where not exists
 (select 'x'
  from informazioni_retributive
 where ci = P_ci
 and voce = curs.voce_acc
 and sub  = curs.rilevanza
 and dal = curs.dal
 )
  ;
 END IF;
 /* fine modifica del 20/10/95 */
  END;
 END LOOP;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
/* fine modifica del 26/06/95 */
 BEGIN  -- Aggiorna Data AL su Informazioni Base su Totale
  P_stp := 'INRE_BASE_TOT_UPD.1';
  update informazioni_retributive x
 set al =
  (select min(inre.dal) - 1
 from informazioni_retributive inre
  where inre.ci = P_ci
  and inre.voce = x.voce
/* modifica del 26/06/95 */
  and inre.sub  = x.sub
/* fine modifica del 26/06/95 */
  and inre.tipo = 't'
  and inre.dal  > nvl(x.dal,to_date('2222222','j'))
  )
  where ci = P_ci
  and tipo = 't'
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
 BEGIN  -- Aggiorna Tariffa su Informazioni Base su Totale
  P_stp := 'INRE_BASE_TOT_UPD.2';
  update informazioni_retributive x
 set tariffa =
  (select nvl
  ( sum
  ( decode
  ( max(inre.tipo)
  , 'B', decode
 ( min(inre.sub)
/* modifica del 02/02/96 */
 , 'I', sum( nvl(inre.tariffa,0)
 * decode(inre.sub,'I',1,0)
 )
  , sum(nvl(inre.tariffa,0))
/* fine modifica del 02/02/96 */
 )
 , decode
 ( min(inre.tipo)
 , 'B', sum( nvl(inre.tariffa,0)
 * decode(inre.sub,'Q',0,'I',0,1)
 )
  , sum(nvl(inre.tariffa,0))
 )
  )
  * max(nvl(tovo.per_tot,100)) / 100
  )
  , 0
  )
 from informazioni_retributive inre
  , totalizzazioni_voce  tovo
  where inre.ci = P_ci
  and inre.voce = tovo.voce||''
  and nvl(tovo.sub, inre.sub) = inre.sub
/* modifica del 26/06/95 */
  and (  inre.tipo <> 'B'
 or  inre.tipo  = 'B'
/* modifica del 02/02/96 */
 and (  inre.sub = x.sub
 or inre.sub = '*'
 )
/* fine modifica del 02/02/96 */
  )
/* fine modifica del 26/06/95 */
  and greatest( nvl(inre.dal,to_date('2222222','j'))
  , nvl(tovo.dal,to_date('2222222','j'))
  )  <= nvl(x.al , to_date('3333333','j'))
  and least( nvl(inre.al ,to_date('3333333','j'))
 , nvl(tovo.al ,to_date('3333333','j'))
 ) >= nvl(x.dal, to_date('2222222','j'))
  and tovo.voce_acc = x.voce
  group by inre.voce
  )
  where ci = P_ci
  and tipo = 't'
  ;
  trace.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim,20);
 END;
 BEGIN  -- Inserisce informazioni Base
 P_stp := 'INRE_BASE_TOT';
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
  , round( nvl(vbvo.valore,0) * nvl(inre.tariffa,0)
 * nvl(bavo.moltiplica,1)
 / nvl(bavo.divide,1)
 , nvl(bavo.decimali,0)
 ) tariffa
  , greatest( nvl(inre.dal,to_date('2222222','j'))
  , pegi.dal
  , qugi.dal
  , vbvo.dal
  ) dal
  , decode( least( nvl(inre.al,Pnulld)
 , nvl(pegi.al,Pnulld)
 , nvl(qugi.al,Pnulld)
 , nvl(vbvo.al,Pnulld)
 )
  , Pnulld, to_date(null)
  , least( nvl(inre.al,Pnulld)
 , nvl(pegi.al,Pnulld)
 , nvl(qugi.al,Pnulld)
 , nvl(vbvo.al,Pnulld)
 )
  ) al
  , 'B' tipo
  , qugi.numero qualifica
  , pegi.tipo_rapporto
  , p_ini_ela data_agg
 from informazioni_retributive inre
  , periodi_giuridici  pegi
  , qualifiche_giuridiche  qugi
  , valori_base_voce vbvo
  , basi_voce  bavo
  , voci_economiche  voec
  where least( nvl(inre.al,Pnulld)
 , nvl(pegi.al,Pnulld)
 , nvl(qugi.al,Pnulld)
 , nvl(vbvo.al,Pnulld)
 )  >= nvl(p_d_inqe,p_ini_ela)
  and inre.ci  = P_ci
  and inre.voce  = bavo.voce_ecce
/* modifica del 26/06/95 */
  and inre.sub = decode(pegi.rilevanza,'S','Q','I')
/* fine modifica del 26/06/95 */
  and inre.tariffa  != 0
  and nvl(inre.dal,to_date('2222222','j'))
  <= least( nvl(vbvo.al,Pnulld)
  , nvl(qugi.al,Pnulld)
  , nvl(pegi.al,Pnulld)
  )
  and nvl(inre.al,Pnulld) >= greatest( vbvo.dal
 , qugi.dal
 , pegi.dal
 , nvl(p_d_inqe,p_ini_ela)
 )
  and pegi.ci  = P_ci
  and pegi.rilevanza  in ('S','E')
  and nvl(pegi.al,Pnulld) >= nvl(p_d_inqe,p_ini_ela)
  and qugi.numero  = pegi.qualifica
  and qugi.dal  <= nvl(pegi.al,Pnulld)
  and nvl(qugi.al,Pnulld) >= greatest( pegi.dal
 , nvl(p_d_inqe,p_ini_ela)
 )
  and bavo.voce  = vbvo.voce
  and bavo.contratto = vbvo.contratto
  and bavo.voce_ecce  is not NULL
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
 BEGIN  -- Elimina Informazioni di Totalizzazione
  P_stp := 'INRE_BASE_TOT_DEL';
  delete from informazioni_retributive
 where ci = P_ci
 and tipo = 't'
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

