CREATE OR REPLACE PACKAGE pgmcdope IS
/******************************************************************************
 NOME:          PECCDOPE
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    11/07/2003 MV	Modifica per trace (difetto 551)
 2.1  03/07/2006 CB     Modifica campo evento - attività 14612
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
	
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PGMCDOPE IS

--form_trigger_failure EXCEPTION;
W_UTENTE	VARCHAR2(10);
W_AMBIENTE	VARCHAR2(10);
W_ENTE		VARCHAR2(10);
W_LINGUA	VARCHAR2(1);
W_PRENOTAZIONE	NUMBER(10);
w_voce_menu	VARCHAR2(10);
P_DATA		DATE;
P_D_F		VARCHAR2(1);
errore		VARCHAR2(6);
P_lingue	VARCHAR2(3);
W_PASSO	    NUMBER(5):= 0;

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V2.1 del 03/07/2006';
   END VERSIONE;

PROCEDURE RAGGR_POSTI
(--Parametri per Trace
  d_trc IN number --Tipo di Trace
, d_prn IN number --Numero di Prenotazione elaborazione
, d_pas IN number --Numero di Passo procedurale
, d_prs IN OUT number --Numero progressivo di Segnalazione
, d_stp IN OUT VARCHAR2 --Step elaborato
, d_tim IN OUT VARCHAR2 --Time impiegato in secondi
)  IS
--
--d_errtext VARCHAR2(240);
--d_prenotazione NUMBER(6);
BEGIN

   D_STP  :='RAGGR_POSTI';
   INSERT INTO CALCOLO_DOTAZIONE
   (cado_prenotazione,cado_rilevanza,cado_lingue,rior_data,
    popi_sede_posto,
    popi_anno_posto,popi_numero_posto,popi_posto,popi_dal,
    popi_ricopribile,popi_gruppo,
    popi_pianta,setp_sequenza,setp_codice,popi_settore,
    sett_sequenza,sett_codice,sett_suddivisione,sett_settore_g,
    setg_sequenza,setg_codice,sett_settore_a,seta_sequenza,
    seta_codice,sett_settore_b,setb_sequenza,setb_codice,
    sett_settore_c,setc_sequenza,setc_codice,
    sett_gestione,gest_prospetto_po,gest_sintetico_po,
    sett_sede,sedi_codice,sedi_sequenza,
    popi_figura,figi_dal,figu_sequenza,figi_codice,figi_qualifica,
    qugi_dal,qual_sequenza,qugi_codice,qugi_contratto,cost_dal,
    cont_sequenza,cost_ore_lavoro,qugi_livello,figi_profilo,
    prpr_sequenza,prpr_suddivisione_po,
    figi_posizione,pofu_sequenza,
    qugi_ruolo,ruol_sequenza,popi_attivita,atti_sequenza,
    pegi_posizione,posi_sequenza,pegi_tipo_rapporto,
    pegi_evento,pegi_sede_del,pegi_anno_del,pegi_numero_del,
    cado_ore_previsti,
    cado_coperti_ruolo,cado_coperti_no_ruolo,
    cado_assenze_incarico,cado_assenze_assenza)
SELECT
    cado_prenotazione,cado_rilevanza+5,MAX(cado_lingue),MAX(rior_data),
    NULL,NULL,NULL,NULL,NULL,NULL,
    popi_gruppo,popi_pianta,
    MAX(setp_sequenza),MAX(setp_codice),popi_settore,
    MAX(sett_sequenza),MAX(sett_codice),
    MAX(sett_suddivisione),MAX(sett_settore_g),
    MAX(setg_sequenza),MAX(setg_codice),
    MAX(sett_settore_a),MAX(seta_sequenza),
    MAX(seta_codice),MAX(sett_settore_b),
    MAX(setb_sequenza),MAX(setb_codice),
    MAX(sett_settore_c),MAX(setc_sequenza),
    MAX(setc_codice),MAX(sett_gestione),
    MAX(gest_prospetto_po),MAX(gest_sintetico_po),
    sett_sede,MAX(sedi_codice),MAX(sedi_sequenza),
    popi_figura,MAX(figi_dal),MAX(figu_sequenza),
    MAX(figi_codice),figi_qualifica,
    MAX(qugi_dal),MAX(qual_sequenza),
    MAX(qugi_codice),MAX(qugi_contratto),MAX(cost_dal),
    MAX(cont_sequenza),MAX(cost_ore_lavoro),
    MAX(qugi_livello),MAX(figi_profilo),
    MAX(prpr_sequenza),MAX(prpr_suddivisione_po),
    MAX(figi_posizione),MAX(pofu_sequenza),
    MAX(qugi_ruolo),MAX(ruol_sequenza),
    popi_attivita,MAX(atti_sequenza),
    pegi_posizione,MAX(posi_sequenza),pegi_tipo_rapporto,
    pegi_evento,pegi_sede_del,pegi_anno_del,pegi_numero_del,
    cado_ore_previsti,
    SUM(cado_coperti_ruolo),SUM(cado_coperti_no_ruolo),
    SUM(cado_assenze_incarico),SUM(cado_assenze_assenza)
  FROM CALCOLO_DOTAZIONE
 WHERE cado_prenotazione = w_prenotazione
   AND cado_rilevanza    < 6
 GROUP BY
    cado_prenotazione,cado_rilevanza,popi_pianta,popi_settore,sett_sede,
    popi_figura,figi_qualifica,popi_attivita,popi_gruppo,pegi_posizione,
    pegi_tipo_rapporto,pegi_evento,pegi_sede_del,
    pegi_anno_del,pegi_numero_del,cado_ore_previsti
;
--Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    /*d_errtext := SUBSTR(SQLERRM,1,240);
    d_prenotazione := w_prenotazione;
    Trace.ERR_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
    ROLLBACK;
    INSERT INTO ERRORI_POGM (prenotazione,voce_menu,data,errore)
    VALUES (d_prenotazione,w_VOCE_MENU ,SYSDATE,d_errtext)
    ;
    COMMIT;
    RAISE FORM_TRIGGER_FAILURE;*/
	 trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione
END;
PROCEDURE DEL_DETT_POSTI
(--Parametri per Trace
  d_trc IN number --Tipo di Trace
, d_prn IN number --Numero di Prenotazione elaborazione
, d_pas IN number --Numero di Passo procedurale
, d_prs IN OUT number --Numero progressivo di Segnalazione
, d_stp IN OUT VARCHAR2 --Step elaborato
, d_tim IN OUT VARCHAR2 --Time impiegato in secondi
) IS

--d_errtext VARCHAR2(240);
--d_prenotazione NUMBER(6);
BEGIN
   D_STP  :='DEL_DET_POSTI';
   DELETE FROM CALCOLO_DOTAZIONE
    WHERE cado_prenotazione    = w_prenotazione
      AND cado_rilevanza       < 6
   ;
--Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
COMMIT;
EXCEPTION
  WHEN OTHERS THEN
   /* d_errtext := SUBSTR(SQLERRM,1,240);
    d_prenotazione := w_prenotazione;
    Trace.ERR_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
    ROLLBACK;
    INSERT INTO ERRORI_POGM (prenotazione,voce_menu,data,errore)
    VALUES (d_prenotazione,w_VOCE_MENU ,SYSDATE,d_errtext)
    ;
    COMMIT;
    RAISE FORM_TRIGGER_FAILURE;*/
	 trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

END;
PROCEDURE CC_DOTAZIONE
(--Parametri per Trace
  d_trc IN number --Tipo di Trace
, d_prn IN number --Numero di Prenotazione elaborazione
, d_pas IN number --Numero di Passo procedurale
, d_prs IN OUT number --Numero progressivo di Segnalazione
, d_stp IN OUT VARCHAR2 --Step elaborato
, d_tim IN OUT VARCHAR2 --Time impiegato in secondi
) IS

--d_errtext VARCHAR2(256);
--d_prenotazione NUMBER(6);
d_conta_cursori  NUMBER(6);
d_rior_data  DATE;
d_popi_sede_posto VARCHAR2(4);
d_popi_anno_posto  NUMBER(4);
d_popi_numero_posto  NUMBER(7);
d_popi_posto NUMBER(5);
d_popi_dal DATE;
d_popi_stato  VARCHAR2(1);
d_popi_situazione VARCHAR2(1);
d_popi_ricopribile  VARCHAR2(1);
d_popi_gruppo VARCHAR2(12);
d_popi_pianta  NUMBER(6);
d_setp_sequenza  NUMBER(6);
d_setp_codice VARCHAR2(15);
d_popi_settore NUMBER(6);
d_sett_sequenza  NUMBER(6);
d_sett_codice VARCHAR2(15);
d_sett_suddivisione  NUMBER(1);
d_sett_settore_g NUMBER(6);
d_setg_sequenza  NUMBER(6);
d_setg_codice VARCHAR2(15);
d_sett_settore_a NUMBER(6);
d_seta_sequenza  NUMBER(6);
d_seta_codice VARCHAR2(15);
d_sett_settore_b NUMBER(6);
d_setb_sequenza  NUMBER(6);
d_setb_codice VARCHAR2(15);
d_sett_settore_c NUMBER(6);
d_setc_sequenza  NUMBER(6);
d_setc_codice VARCHAR2(15);
d_sett_gestione VARCHAR2(4);
d_gest_prospetto_po VARCHAR2(1);
d_gest_sintetico_po VARCHAR2(1);
d_sett_sede  NUMBER(6);
d_sedi_codice VARCHAR2(8);
d_sedi_sequenza  NUMBER(6);
d_popi_figura  NUMBER(6);
d_figi_dal DATE;
d_figu_sequenza  NUMBER(6);
d_figi_codice VARCHAR2(8);
d_figi_qualifica NUMBER(6);
d_qugi_dal DATE;
d_qual_sequenza  NUMBER(6);
d_qugi_codice VARCHAR2(8);
d_qugi_contratto  VARCHAR2(4);
d_cost_dal DATE;
d_cont_sequenza  NUMBER(3);
d_cost_ore_lavoro  NUMBER(5,2);
d_qugi_livello  VARCHAR2(4);
d_figi_profilo  VARCHAR2(4);
d_prpr_sequenza  NUMBER(3);
d_prpr_suddivisione_po  VARCHAR2(1);
d_figi_posizione  VARCHAR2(4);
d_pofu_sequenza  NUMBER(3);
d_qugi_ruolo  VARCHAR2(4);
d_ruol_sequenza  NUMBER(4);
d_popi_attivita VARCHAR2(4);
d_atti_sequenza  NUMBER(6);
d_popi_ore NUMBER(5,2);
d_pegi_posizione  VARCHAR2(4);
d_posi_sequenza  NUMBER(3);
d_posi_di_ruolo  NUMBER(1);
d_pegi_tipo_rapporto  VARCHAR2(4);
d_pegi_ore NUMBER(5,2);
d_pegi_evento VARCHAR2(6);
d_pegi_sede_del VARCHAR2(4);
d_pegi_anno_del  NUMBER(4);
d_pegi_numero_del  NUMBER(7);
d_cado_previsti  NUMBER(5);
d_cado_ore_previsti  NUMBER(5,2);
d_cado_in_pianta NUMBER(5);
d_cado_in_deroga NUMBER(5);
d_cado_in_sovrannumero NUMBER(5);
d_cado_in_rilascio NUMBER(5);
d_cado_in_istituzione  NUMBER(5);
d_cado_in_acquisizione NUMBER(5);
d_cado_ass_ruolo_l1  NUMBER(5);
d_cado_ore_ass_ruolo_l1  NUMBER(5,2);
d_cado_ass_ruolo_l2  NUMBER(5);
d_cado_ore_ass_ruolo_l2  NUMBER(5,2);
d_cado_ass_ruolo_l3  NUMBER(5);
d_cado_ore_ass_ruolo_l3  NUMBER(5,2);
d_cado_ass_ruolo NUMBER(5);
d_cado_ore_ass_ruolo NUMBER(5,2);
d_cado_assegnazioni  NUMBER(5);
d_cado_ore_assegnazioni  NUMBER(5,2);
d_cado_assenze_incarico  NUMBER(5);
d_cado_assenze_assenza NUMBER(5);
d_cado_disponibili NUMBER(5);
d_cado_ore_disponibili NUMBER(5,2);
d_cado_coperti_ruolo_1 NUMBER(5);
d_cado_ore_coperti_ruolo_1 NUMBER(5,2);
d_cado_coperti_ruolo_2 NUMBER(5);
d_cado_ore_coperti_ruolo_2 NUMBER(5,2);
d_cado_coperti_ruolo_3 NUMBER(5);
d_cado_ore_coperti_ruolo_3 NUMBER(5,2);
d_cado_coperti_ruolo NUMBER(5);
d_cado_ore_coperti_ruolo NUMBER(5,2);
d_cado_coperti_no_ruolo  NUMBER(5);
d_cado_ore_coperti_no_ruolo  NUMBER(5,2);
d_cado_vacanti NUMBER(5);
d_cado_ore_vacanti NUMBER(5,2);
d_cado_vacanti_coperti NUMBER(5);
d_cado_ore_vacanti_coperti NUMBER(5,2);
d_cado_vacanti_non_coperti NUMBER(5);
d_cado_ore_vacanti_non_coperti NUMBER(5,2);
d_cado_vacanti_non_ricopribili NUMBER(5);
d_cado_dotazioni_ruolo NUMBER(5);
d_cado_ore_dotazioni_ruolo NUMBER(5,2);
d_cado_dotazioni_no_ruolo  NUMBER(5);
d_cado_ore_dotazioni_no_ruolo  NUMBER(5,2);
nOre NUMBER(5,2);
nOre_1 NUMBER(5,2);
nOre_2 NUMBER(5,2);
nOre_3 NUMBER(5,2);
CURSOR dotazioni IS
SELECT pg.ore
  ,DECODE(po.ruolo
 ,'SI',DECODE(pg.rilevanza
 ,'Q',1
 ,'S',1
 ,0
 )
  ,0
 )
  ,DECODE(po.ruolo
 ,'SI',DECODE(pg.rilevanza
 ,'Q',0
 ,'S',0
 ,1
 )
  ,1
 )
  ,0
  ,0
  ,pg.posizione
  ,NVL(po.sequenza,999)
  ,pg.tipo_rapporto
  ,pg.figura
  ,pg.qualifica
  ,pg.ATTIVITA
  ,pg.settore
  ,pg.sede
  ,pg.sede_posto
  ,pg.anno_posto
  ,pg.numero_posto
  ,pg.posto
  ,pg.evento
  ,pg.sede_del
  ,pg.anno_del
  ,pg.numero_del
  FROM POSIZIONI pa
  ,POSIZIONI po
  ,PERIODI_GIURIDICI pg
 WHERE d_rior_data BETWEEN pg.dal
 AND NVL(pg.al,TO_DATE('3333333','j'))
 AND (  pg.rilevanza  IN ('Q','I')
  AND p_d_f = 'D'
  OR  pg.rilevanza  IN ('S','E')
  AND p_d_f = 'F'
 )
 AND pa.codice = pg.posizione
 AND po.codice = pa.posizione
;
CURSOR assenze IS
SELECT pg.ore
  ,0
  ,0
  ,DECODE(p2.rilevanza,'I',1,0)
  ,DECODE(p2.rilevanza,'A',1,0)
  ,pg.posizione
  ,NVL(po.sequenza,999)
  ,pg.tipo_rapporto
  ,pg.figura
  ,pg.qualifica
  ,pg.ATTIVITA
  ,pg.settore
  ,pg.sede
  ,pg.sede_posto
  ,pg.anno_posto
  ,pg.numero_posto
  ,pg.posto
  ,pg.evento
  ,pg.sede_del
  ,pg.anno_del
  ,pg.numero_del
  FROM POSIZIONI pa
  ,POSIZIONI po
  ,PERIODI_GIURIDICI p2
  ,PERIODI_GIURIDICI pg
 WHERE d_rior_data BETWEEN pg.dal
 AND NVL(pg.al,TO_DATE('3333333','j'))
 AND d_rior_data BETWEEN p2.dal
 AND NVL(p2.al,TO_DATE('3333333','j'))
 AND p2.ci = pg.ci
 AND (  pg.rilevanza = 'Q'
  AND (  p2.rilevanza  = 'A'
 AND p2.assenza IN (SELECT aa.codice
  FROM ASTENSIONI aa
 WHERE aa.sostituibile = 1
 )
 AND NOT EXISTS (SELECT 1
 FROM PERIODI_GIURIDICI p3
  WHERE d_rior_data BETWEEN p3.dal AND
  NVL(p3.al,TO_DATE('3333333','j'))
  AND p3.rilevanza = 'I'
  AND p3.ci  = pg.ci
  )
 OR  p2.rilevanza  = 'I'
  )
  AND p_d_f = 'D'
  OR  pg.rilevanza = 'I'
  AND p2.rilevanza = 'A'
  AND p2.assenza  IN (SELECT aa.codice
  FROM ASTENSIONI aa
 WHERE aa.sostituibile = 1
 )
  AND P_d_f = 'D'
  OR  pg.rilevanza = 'S'
  AND (  p2.rilevanza  = 'A'
 AND p2.assenza IN (SELECT aa.codice
  FROM ASTENSIONI aa
 WHERE aa.sostituibile = 1
 )
 AND NOT EXISTS (SELECT 1
 FROM PERIODI_GIURIDICI p3
  WHERE d_rior_data BETWEEN p3.dal AND
  NVL(p3.al,TO_DATE('3333333','j'))
  AND p3.rilevanza = 'E'
  AND p3.ci  = pg.ci
  )
 OR  p2.rilevanza  = 'E'
  )
  AND p_d_f = 'F'
  OR  pg.rilevanza = 'E'
  AND p2.rilevanza = 'A'
  AND p2.assenza  IN (SELECT aa.codice
  FROM ASTENSIONI aa
 WHERE aa.sostituibile = 1
 )
  AND p_d_f = 'F'
 )
 AND pa.codice = pg.posizione
 AND po.codice = pa.posizione
;
BEGIN
 BEGIN
     d_rior_data := p_data;
  END;
  d_conta_cursori := 0;
  LOOP
  d_conta_cursori := d_conta_cursori + 1;
  IF d_conta_cursori > 2 THEN
     EXIT;
  END IF;
  IF d_conta_cursori = 1 THEN
     OPEN dotazioni;
  ELSE
     OPEN assenze;
  END IF;
  LOOP
  IF d_conta_cursori = 1 THEN
      FETCH dotazioni INTO d_pegi_ore,
      d_cado_dotazioni_ruolo,d_cado_dotazioni_no_ruolo,
      d_cado_assenze_incarico,d_cado_assenze_assenza,
      d_pegi_posizione,d_posi_sequenza,
      d_pegi_tipo_rapporto,
      d_popi_figura,d_figi_qualifica,
      d_popi_attivita,d_popi_settore,d_sett_sede,
      d_popi_sede_posto,d_popi_anno_posto,
      d_popi_numero_posto,d_popi_posto,
      d_pegi_evento,d_pegi_sede_del,
      d_pegi_anno_del,d_pegi_numero_del;
      EXIT  WHEN dotazioni%NOTFOUND;
  ELSE
      FETCH assenze INTO d_pegi_ore,
      d_cado_dotazioni_ruolo,d_cado_dotazioni_no_ruolo,
      d_cado_assenze_incarico,d_cado_assenze_assenza,
      d_pegi_posizione,d_posi_sequenza,
      d_pegi_tipo_rapporto,
      d_popi_figura,d_figi_qualifica,
      d_popi_attivita,d_popi_settore,d_sett_sede,
      d_popi_sede_posto,d_popi_anno_posto,
      d_popi_numero_posto,d_popi_posto,
      d_pegi_evento,d_pegi_sede_del,
      d_pegi_anno_del,d_pegi_numero_del;
      EXIT  WHEN assenze%NOTFOUND;
  END IF;
  d_popi_dal := NULL;
  d_popi_stato := NULL;
  d_popi_situazione  := NULL;
  d_popi_ricopribile := NULL;
  d_popi_gruppo  := NULL;
  d_popi_ore := NULL;
  d_popi_pianta  := NULL;
  d_setp_codice  := NULL;
  d_setp_sequenza  := NULL;
  IF  d_popi_sede_posto IS NOT NULL
  AND d_popi_anno_posto IS NOT NULL
  AND d_popi_numero_posto IS NOT NULL
  AND d_popi_posto  IS NOT NULL THEN

 BEGIN
  D_stp := 'CC_DOTAZIONE-01';
  SELECT dal
  ,stato
  ,situazione
  ,disponibilita
  ,gruppo
  ,pianta
  ,ore
  INTO d_popi_dal
  ,d_popi_stato
  ,d_popi_situazione
  ,d_popi_ricopribile
  ,d_popi_gruppo
  ,d_popi_pianta
  ,d_popi_ore
  FROM POSTI_PIANTA
 WHERE sede_posto  = d_popi_sede_posto
 AND anno_posto  = d_popi_anno_posto
 AND numero_posto  = d_popi_numero_posto
 AND posto = d_popi_posto
 AND d_rior_data BETWEEN dal
 AND NVL(al,TO_DATE('3333333','j'))
  ;
 -- Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  EXCEPTION WHEN OTHERS THEN
           /*   d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione
  END;

 BEGIN
  D_stp := 'CC_DOTAZIONE-02';
  SELECT NVL(sequenza,999999),codice
  INTO d_setp_sequenza,d_setp_codice
  FROM SETTORI
 WHERE numero = d_popi_pianta
  ;
-- Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 EXCEPTION WHEN OTHERS THEN
            /*  d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione
 END;
 END IF;
  BEGIN
  D_stp := 'CC_DOTAZIONE-03';
 SELECT NVL(s.sequenza,999999),s.codice,s.suddivisione,s.gestione,
  g.prospetto_po,NVL(g.sintetico_po,g.prospetto_po),
  s.settore_g,s.settore_a,
  s.settore_b,s.settore_c,g.sintetico_po
 INTO d_sett_sequenza,d_sett_codice,d_sett_suddivisione,
  d_sett_gestione,d_gest_prospetto_po,d_gest_sintetico_po,
  d_sett_settore_g,d_sett_settore_a,
  d_sett_settore_b,d_sett_settore_c,d_gest_sintetico_po
 FROM GESTIONI g,SETTORI s
  WHERE s.numero  = d_popi_settore
  AND g.codice  = s.gestione
 ;
--  Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  EXCEPTION
  WHEN OTHERS THEN
             /* d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
			  errore := 'P05809';   -- Errore in Elaborazione

  END;

  IF d_sett_suddivisione = 0 THEN
 d_sett_settore_g := d_popi_settore;
 d_setg_sequenza  := d_sett_sequenza;
 d_setg_codice  := d_sett_codice;
 d_sett_settore_a := d_popi_settore;
 d_seta_sequenza  := 0;
 d_seta_codice  := d_sett_codice;
 d_sett_settore_b := d_popi_settore;
 d_setb_sequenza  := 0;
 d_setb_codice  := d_sett_codice;
 d_sett_settore_c := d_popi_settore;
 d_setc_sequenza  := 0;
 d_setc_codice  := d_sett_codice;
  ELSE
  BEGIN
 D_stp := 'CC_DOTAZIONE-04';
 SELECT NVL(sequenza,999999),codice
 INTO d_setg_sequenza,d_setg_codice
 FROM SETTORI
  WHERE numero = d_sett_settore_g
 ;
-- Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 EXCEPTION WHEN OTHERS THEN
              /*d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione
 END;
 IF d_sett_suddivisione = 1 THEN
  d_sett_settore_a := d_popi_settore;
  d_seta_sequenza  := d_sett_sequenza;
  d_seta_codice  := d_sett_codice;
  d_sett_settore_b := d_popi_settore;
  d_setb_sequenza  := 0;
  d_setb_codice  := d_sett_codice;
  d_sett_settore_c := d_popi_settore;
  d_setc_sequenza  := 0;
  d_setc_codice  := d_sett_codice;
 ELSE
  BEGIN
  D_stp := 'CC_DOTAZIONE-05';
  SELECT NVL(sequenza,999999),codice
  INTO d_seta_sequenza,d_seta_codice
  FROM SETTORI
  WHERE numero = d_sett_settore_a
  ;
 -- Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  EXCEPTION WHEN OTHERS THEN
             /* d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione
  END;

 IF d_sett_suddivisione = 2 THEN
 d_sett_settore_b := d_popi_settore;
 d_setb_sequenza  := d_sett_sequenza;
 d_setb_codice  := d_sett_codice;
 d_sett_settore_c := d_popi_settore;
 d_setc_sequenza  := 0;
 d_setc_codice  := d_sett_codice;
 ELSE
  BEGIN
  D_stp := 'CC_DOTAZIONE-06';
  SELECT NVL(sequenza,999999),codice
  INTO d_setb_sequenza,d_setb_codice
  FROM SETTORI
 WHERE numero = d_sett_settore_b
  ;
--  Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  EXCEPTION WHEN OTHERS THEN
            /*  d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione
  END;

 IF d_sett_suddivisione = 3 THEN
 d_sett_settore_c := d_popi_settore;
 d_setc_sequenza := d_sett_sequenza;
 d_setc_codice  := d_sett_codice;
 ELSE
  BEGIN
  D_stp := 'CC_DOTAZIONE-07';
  SELECT NVL(sequenza,999999),codice
  INTO d_setc_sequenza,d_setc_codice
  FROM SETTORI
  WHERE numero = d_sett_settore_c
  ;
--  Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  EXCEPTION WHEN OTHERS THEN
             /* d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

  END;
  END IF;
  END IF;
 END IF;
  END IF;
  IF p_d_f = 'D' THEN
  BEGIN
 D_stp := 'CC_DOTAZIONE-08';
 SELECT fg.dal,NVL(fi.sequenza,999999),fg.codice,
  fg.qualifica,qg.dal,NVL(qu.sequenza,999999),qg.codice,
  qg.contratto,cs.dal,NVL(co.sequenza,999),cs.ore_lavoro,
  qg.livello,qg.ruolo,NVL(ru.sequenza,999),
  fg.profilo,NVL(pr.sequenza,999),
  DECODE(fg.profilo,NULL,'F',
 DECODE(d_gest_sintetico_po,NULL,'F'
 ,'Q' ,'F'
 ,'L' ,'F'
 ,pr.suddivisione_po
 )
  ),
  fg.posizione,NVL(pf.sequenza,999)
 INTO d_figi_dal,d_figu_sequenza,d_figi_codice,
  d_figi_qualifica,d_qugi_dal,
  d_qual_sequenza,d_qugi_codice,
  d_qugi_contratto,d_cost_dal,d_cont_sequenza,
  d_cost_ore_lavoro,d_qugi_livello,d_qugi_ruolo,
  d_ruol_sequenza,d_figi_profilo,d_prpr_sequenza,
  d_prpr_suddivisione_po,d_figi_posizione,d_pofu_sequenza
 FROM POSIZIONI_FUNZIONALI pf,
  PROFILI_PROFESSIONALI  pr,
  RUOLI  ru,
  CONTRATTI_STORICI  cs,
  CONTRATTI  co,
  QUALIFICHE_GIURIDICHE  qg,
  QUALIFICHE qu,
  FIGURE_GIURIDICHE  fg,
  FIGURE fi
  WHERE d_rior_data BETWEEN fg.dal
  AND NVL(fg.al,TO_DATE('3333333','j'))
  AND d_rior_data BETWEEN qg.dal
  AND NVL(qg.al,TO_DATE('3333333','j'))
  AND d_rior_data BETWEEN cs.dal
  AND NVL(cs.al,TO_DATE('3333333','j'))
  AND pf.profilo  (+) = fg.profilo
  AND pf.codice (+) = fg.posizione
  AND pr.codice (+) = fg.profilo
  AND ru.codice = qg.ruolo
  AND cs.contratto  = qg.contratto
  AND co.codice = qg.contratto
  AND qg.numero = fg.qualifica
  AND qu.numero = fg.qualifica
  AND fg.numero = d_popi_figura
  AND fi.numero = d_popi_figura
 ;
-- Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 EXCEPTION WHEN OTHERS THEN
           /*   d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

 END;

 BEGIN
 D_stp := 'CC_DOTAZIONE-09';
  SELECT s.sede,d.codice,NVL(d.sequenza,999999)
  INTO d_sett_sede,d_sedi_codice,d_sedi_sequenza
  FROM SEDI d
  ,SETTORI  s
 WHERE s.numero = d_popi_settore
 AND s.sede = d.numero (+)
  ;
 -- Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  EXCEPTION WHEN OTHERS THEN
           /*   d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

  END;
  END IF;

 IF p_d_f = 'F' THEN
 BEGIN
 D_stp := 'CC_DOTAZIONE-10';
 SELECT fg.dal,NVL(fi.sequenza,999999),fg.codice,
  qg.dal,NVL(qu.sequenza,999999),qg.codice,
  qg.contratto,cs.dal,NVL(co.sequenza,999),cs.ore_lavoro,
  qg.livello,qg.ruolo,NVL(ru.sequenza,999),
  fg.profilo,NVL(pr.sequenza,999),
  DECODE(fg.profilo,NULL,'F',
 DECODE(d_gest_sintetico_po,NULL,'F'
 ,'Q' ,'F'
 ,'L' ,'F'
 ,pr.suddivisione_po
 )
  ),
  fg.posizione,NVL(pf.sequenza,999)
 INTO d_figi_dal,d_figu_sequenza,d_figi_codice,
  d_qugi_dal,d_qual_sequenza,d_qugi_codice,
  d_qugi_contratto,d_cost_dal,d_cont_sequenza,
  d_cost_ore_lavoro,d_qugi_livello,d_qugi_ruolo,
  d_ruol_sequenza,d_figi_profilo,d_prpr_sequenza,
  d_prpr_suddivisione_po,d_figi_posizione,d_pofu_sequenza
 FROM POSIZIONI_FUNZIONALI pf,
  PROFILI_PROFESSIONALI  pr,
  RUOLI  ru,
  CONTRATTI_STORICI  cs,
  CONTRATTI  co,
  QUALIFICHE_GIURIDICHE  qg,
  QUALIFICHE qu,
  FIGURE_GIURIDICHE  fg,
  FIGURE fi
  WHERE d_rior_data BETWEEN fg.dal
  AND NVL(fg.al,TO_DATE('3333333','j'))
  AND d_rior_data BETWEEN qg.dal
  AND NVL(qg.al,TO_DATE('3333333','j'))
  AND d_rior_data BETWEEN cs.dal
  AND NVL(cs.al,TO_DATE('3333333','j'))
  AND pf.profilo  (+) = fg.profilo
  AND pf.codice (+) = fg.posizione
  AND pr.codice (+) = fg.profilo
  AND ru.codice = qg.ruolo
  AND cs.contratto  = qg.contratto
  AND co.codice = qg.contratto
  AND qg.numero = d_figi_qualifica
  AND qu.numero = qg.numero
  AND fg.numero = d_popi_figura
  AND fi.numero = d_popi_figura
 ;
-- Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 EXCEPTION WHEN OTHERS THEN
           /*   d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

 END;

 BEGIN
 D_stp := 'CC_DOTAZIONE-11';
  SELECT d.codice,NVL(d.sequenza,999999)
  INTO d_sedi_codice,d_sedi_sequenza
  FROM SEDI d
 WHERE d.numero = d_sett_sede
  ;
--  Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
 d_sedi_codice := NULL;
 d_sedi_sequenza := 999999;

  WHEN OTHERS THEN
              /*d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

  END;
  END IF;

  BEGIN
   D_stp := 'CC_DOTAZIONE-12';
  SELECT NVL(sequenza,999999)
  INTO d_atti_sequenza
  FROM ATTIVITA
 WHERE codice  = d_popi_attivita
  ;
--  Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
  d_atti_sequenza := 999999;
  WHEN OTHERS THEN
           /*   d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

  END;
--
  d_cado_ore_previsti :=
  NVL(d_pegi_ore,NVL(d_popi_ore,d_cost_ore_lavoro));
--
--  Inserimento Registrazione Dotazione.
--

  BEGIN
  D_stp := 'CC_DOTAZIONE-13';
IF d_cado_dotazioni_ruolo  + d_cado_dotazioni_no_ruolo +
  d_cado_assenze_incarico + d_cado_assenze_assenza > 0 THEN
 INSERT INTO CALCOLO_DOTAZIONE
 (cado_prenotazione,cado_rilevanza,cado_lingue,
  rior_data,popi_sede_posto,
  popi_anno_posto,popi_numero_posto,popi_posto,popi_dal,
  popi_ricopribile,popi_gruppo,
  popi_pianta,setp_sequenza,setp_codice,popi_settore,
  sett_sequenza,sett_codice,sett_suddivisione,sett_settore_g,
  setg_sequenza,setg_codice,sett_settore_a,seta_sequenza,
  seta_codice,sett_settore_b,setb_sequenza,setb_codice,
  sett_settore_c,setc_sequenza,setc_codice,sett_gestione,
  gest_prospetto_po,gest_sintetico_po,
  sett_sede,sedi_codice,sedi_sequenza,
  popi_figura,figi_dal,figu_sequenza,figi_codice,figi_qualifica,
  qugi_dal,qual_sequenza,qugi_codice,qugi_contratto,cost_dal,
  cont_sequenza,cost_ore_lavoro,qugi_livello,figi_profilo,
  prpr_sequenza,prpr_suddivisione_po,
  figi_posizione,pofu_sequenza,
  qugi_ruolo,ruol_sequenza,popi_attivita,atti_sequenza,
  pegi_posizione,posi_sequenza,pegi_tipo_rapporto,
  pegi_evento,pegi_sede_del,pegi_anno_del,pegi_numero_del,
  cado_previsti,cado_ore_previsti,cado_in_pianta,cado_in_deroga,
  cado_in_sovrannumero,cado_in_rilascio,cado_in_acquisizione,
  cado_in_istituzione,cado_assegnazioni_ruolo_l1,
  cado_ore_assegnazioni_ruolo_l1,cado_assegnazioni_ruolo_l2,
  cado_ore_assegnazioni_ruolo_l2,cado_assegnazioni_ruolo_l3,
  cado_ore_assegnazioni_ruolo_l3,cado_assegnazioni_ruolo,
  cado_vacanti,cado_vacanti_coperti,
  cado_coperti_ruolo,cado_coperti_no_ruolo,
  cado_assenze_incarico,cado_assenze_assenza)
 VALUES
 (w_prenotazione,1,p_lingue,d_rior_data,d_popi_sede_posto,
  d_popi_anno_posto,d_popi_numero_posto,d_popi_posto,d_popi_dal,
  d_popi_ricopribile,d_popi_gruppo,d_popi_pianta,
  d_setp_sequenza,d_setp_codice,d_popi_settore,
  d_sett_sequenza,d_sett_codice,
  d_sett_suddivisione,d_sett_settore_g,
  d_setg_sequenza,d_setg_codice,d_sett_settore_a,d_seta_sequenza,
  d_seta_codice,d_sett_settore_b,d_setb_sequenza,d_setb_codice,
  d_sett_settore_c,d_setc_sequenza,d_setc_codice,
  d_sett_gestione,d_gest_prospetto_po,d_gest_sintetico_po,
  d_sett_sede,d_sedi_codice,d_sedi_sequenza,
  d_popi_figura,d_figi_dal,
  d_figu_sequenza,d_figi_codice,d_figi_qualifica,
  d_qugi_dal,d_qual_sequenza,d_qugi_codice,
  d_qugi_contratto,d_cost_dal,
  d_cont_sequenza,d_cost_ore_lavoro,
  d_qugi_livello,d_figi_profilo,
  d_prpr_sequenza,d_prpr_suddivisione_po,
  d_figi_posizione,d_pofu_sequenza,
  d_qugi_ruolo,d_ruol_sequenza,d_popi_attivita,d_atti_sequenza,
  d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
  d_pegi_evento,d_pegi_sede_del,
  d_pegi_anno_del,d_pegi_numero_del,
  0,d_cado_ore_previsti,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  d_cado_dotazioni_ruolo,d_cado_dotazioni_no_ruolo,
  d_cado_assenze_incarico,d_cado_assenze_assenza)
 ;
--  Trace.log_trace(D_trc,D_prn,D_pas,D_prs,D_stp,SQL%ROWCOUNT,D_tim)
  END IF;
  EXCEPTION WHEN OTHERS THEN
           /*   d_errtext := substr(SQLERRM,1,240);
              d_prenotazione := w_prenotazione;
              TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              ROLLBACK;
              insert into errori_pogm (prenotazione,voce_menu,data,errore)
              values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
              COMMIT;
              RAISE FORM_TRIGGER_FAILURE;*/
			  trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione

  END;
  END LOOP;
IF d_conta_cursori = 1 THEN
 COMMIT;
 CLOSE dotazioni;
ELSE
 COMMIT;
 CLOSE assenze;
END IF;
  END LOOP;

/*EXCEPTION
  WHEN OTHERS THEN
  d_errtext := substr(SQLERRM,1,240);
  d_prenotazione := w_prenotazione;
  TRACE.ERR_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
  ROLLBACK;
  insert into errori_pogm (prenotazione,voce_menu,data,errore)
  values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
  ;
  COMMIT;
  RAISE FORM_TRIGGER_FAILURE;*/
END;
-- Determina la sequenza dei gruppi linguistici
PROCEDURE SEQ_LINGUA IS
d_lingua_1 VARCHAR2(1);
d_lingua_2 VARCHAR2(1);
d_lingua_3 VARCHAR2(1);
d_lingua VARCHAR2(1);
d_conta  NUMBER(2);
CURSOR  GRUPPI_LING IS
  SELECT gruppo_al
  FROM a_gruppi_linguistici
 WHERE gruppo  = w_lingua
 AND ROWNUM  < 4
 ORDER BY sequenza,gruppo_al;
BEGIN
 IF w_lingua != '*' THEN
  OPEN GRUPPI_LING;
  d_conta := 1;
  d_lingua_1  := '?';
  d_lingua_2  := '?';
  d_lingua_3  := '?';
  LOOP
  FETCH GRUPPI_LING INTO d_lingua;
  EXIT WHEN GRUPPI_LING%NOTFOUND;
  IF d_conta = 1 THEN
 d_lingua_1 := d_lingua;
  ELSIF
 d_conta = 2 THEN
 d_lingua_2 := d_lingua;
  ELSE
 d_lingua_3 := d_lingua;
  END IF;
  IF d_conta = 3 THEN
 EXIT;
  END IF;
  d_conta := d_conta + 1;
  END LOOP;
  CLOSE GRUPPI_LING;
 ELSE
  d_lingua_1 := 'I';
  d_lingua_2 := '?';
  d_lingua_3 := '?';
 END IF;
 p_lingue := d_lingua_1||d_lingua_2||d_lingua_3;
END;
PROCEDURE DELETE_TAB
(--Parametri per Trace
  d_trc IN number --Tipo di Trace
, d_prn IN number --Numero di Prenotazione elaborazione
, d_pas IN number --Numero di Passo procedurale
, d_prs IN OUT number --Numero progressivo di Segnalazione
, d_stp IN OUT VARCHAR2 --Step elaborato
, d_tim IN OUT VARCHAR2 --Time impiegato in secondi
) IS

--
--d_errtext VARCHAR2(240);
--d_prenotazione NUMBER(6);
BEGIN
  D_STP  :='DELETE_TAB';
       BEGIN
       DELETE FROM CALCOLO_DOTAZIONE
            WHERE cado_prenotazione = w_prenotazione;
      -- Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
	   END;
	   BEGIN
	   DELETE FROM CALCOLO_NOMINATIVO_DOTAZIONE
            WHERE cndo_prenotazione = w_prenotazione;
      -- Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
	   END;
	   COMMIT;
	   EXCEPTION
           WHEN OTHERS THEN
      /*
       d_errtext := SUBSTR(SQLERRM,1,240);
       d_prenotazione := w_prenotazione;
       Trace.ERR_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
       ROLLBACK;
       INSERT INTO ERRORI_POGM (prenotazione,voce_menu,data,errore)
       VALUES (d_prenotazione,w_VOCE_MENU ,SYSDATE,d_errtext)
       ;
       COMMIT;
       RAISE FORM_TRIGGER_FAILURE;*/
	    trace.err_trace(D_trc,D_prn,D_pas,D_prs,D_stp,0,D_tim);
              errore := 'P05809';   -- Errore in Elaborazione


END;
PROCEDURE calcolo
IS
-- Dati per gestione TRACE
d_trc          NUMBER(1);  -- Tipo di Trace
d_prn          NUMBER(6);  -- Numero di Prenotazione
d_pas          NUMBER(2);  -- Numero di Passo procedurale
d_prs          NUMBER(10); -- Numero progressivo di Segnalazione
d_stp          VARCHAR2(30);   -- Identificazione dello Step in oggetto
d_cnt          NUMBER(5);  -- Count delle row trattate
d_tim          VARCHAR2(5);    -- Time impiegato in secondi
d_tim_tot       VARCHAR2(5);    -- Time impiegato in secondi Totale
--
BEGIN
BEGIN  -- Assegnazioni Iniziali per Trace
     D_prn := w_prenotazione;
     D_pas := w_passo;
    IF D_prn = 0 THEN
	    D_trc := 1;
        DELETE FROM a_segnalazioni_errore
        WHERE no_prenotazione = D_prn
          AND passo          = D_pas
        ;
     END IF;
     BEGIN  -- Preleva numero max di segnalazione
        SELECT NVL(MAX(progressivo),0)
         INTO D_prs
         FROM a_segnalazioni_errore
        WHERE no_prenotazione = D_prn
          AND passo          = D_pas
        ;
     END;
  END;
  BEGIN  -- Segnalazione Iniziale
     D_stp     := 'Pgmcdope-START';
     D_tim     := TO_CHAR(SYSDATE,'sssss');
     D_tim_tot := TO_CHAR(SYSDATE,'sssss');
     Trace.log_trace(0,D_prn,D_pas,D_prs,D_stp,0,D_tim);
	 COMMIT;
  END;
BEGIN
    D_trc := 1;
	DELETE_TAB(D_trc,D_prn,D_pas,D_prs,D_stp,D_tim);
	SEQ_LINGUA;
	CC_DOTAZIONE(D_trc,D_prn,D_pas,D_prs,D_stp,D_tim);
	Pgmcdope2.CC_NOMINATIVO(P_D_F,P_DATA,W_VOCE_MENU,D_trc,D_prn,D_pas,D_prs,D_stp);
	RAGGR_POSTI(D_trc,D_prn,D_pas,D_prs,D_stp,D_tim);
	DEL_DETT_POSTI(D_trc,D_prn,D_pas,D_prs,D_stp,D_tim);
	BEGIN
	    -- Operazioni finali per Trace
        D_stp := 'PGMCDOPE-Stop';
		TRACE.log_trace(2,D_prn,D_pas,D_prs,D_stp,0,D_tim_TOT);
		IF errore != 'P05809' AND   -- Errore
           errore != 'P05830' AND   -- Netti Negativi
           errore != 'P05808' THEN  -- Segnalazione
           errore := 'P05802';      -- Elaborazione Completata
		   COMMIT;
        END IF;
     END;

  END;
END;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
IF PRENOTAZIONE != 0 THEN
 BEGIN  -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
   SELECT UTENTE
  , AMBIENTE
  , ENTE
  , GRUPPO_LING
  , VOCE_MENU
  INTO W_UTENTE
  , W_AMBIENTE
  , W_ENTE
  , W_LINGUA
  , W_VOCE_MENU
  FROM A_PRENOTAZIONI
    WHERE NO_PRENOTAZIONE = PRENOTAZIONE
   ;
   EXCEPTION
   WHEN OTHERS THEN NULL;
 END;
END IF;
BEGIN
  SELECT TO_DATE(PARA.VALORE,'dd/mm/yyyy')
    INTO P_DATA
    FROM A_PARAMETRI PARA
   WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
  AND PARA.PARAMETRO = 'P_RIFERIMENTO'
  ;
   EXCEPTION
  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    P_DATA := SYSDATE;
END;
BEGIN
  SELECT SUBSTR(PARA.VALORE,1,1)
    INTO P_D_F
    FROM A_PARAMETRI PARA
   WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
  AND PARA.PARAMETRO = 'P_DF'
  ;
   EXCEPTION
  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    P_D_F := 'D';
END;
w_prenotazione := prenotazione;
w_passo := passo;
ERRORE := TO_CHAR(NULL);
   -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
   -- VIENE RIAZZERATO IN FORM CHIAMANTE PER EVITARE TRASACTION COMPLETED
      CALCOLO;  -- ESECUZIONE DEL CALCOLO POSTI
IF W_PRENOTAZIONE != 0 THEN
   IF SUBSTR(errore,6,1) = '8' THEN
     UPDATE A_PRENOTAZIONI
      SET ERRORE = 'P05808'
       WHERE NO_PRENOTAZIONE = w_PRENOTAZIONE
        ;
   COMMIT;
 ELSIF SUBSTR(errore,6,1) = '9' THEN
   UPDATE A_PRENOTAZIONI
      SET ERRORE = 'P05809'
      , PROSSIMO_PASSO = 91
      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
      ;
   COMMIT;
  END IF;
END IF;
   EXCEPTION
   WHEN OTHERS THEN

   BEGIN
   ROLLBACK;
   IF W_PRENOTAZIONE != 0 THEN
   UPDATE A_PRENOTAZIONI
   SET ERRORE = '*ABORT*'
  , PROSSIMO_PASSO = 99
   WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
   ;
   COMMIT;
   END IF;
   EXCEPTION
   WHEN OTHERS THEN
	NULL;
   END;
   END;

END;
/

