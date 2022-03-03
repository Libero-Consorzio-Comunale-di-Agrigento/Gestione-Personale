CREATE OR REPLACE PACKAGE Ppocsido3 IS
/******************************************************************************
 NOME:          PPOCSIDO3
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
  PROCEDURE RAGGR_POSTI (p_prenotazione IN NUMBER, p_voce_menu IN VARCHAR2) ;
  PROCEDURE CC_DOTAZIONE(p_d_f IN VARCHAR2, p_data IN DATE, p_uso_interno IN VARCHAR2,
         p_lingue IN VARCHAR2, p_prenotazione IN NUMBER, p_voce_menu IN VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY Ppocsido3 IS
-- form_trigger_failure EXCEPTION;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE CC_DOTAZIONE(p_d_f IN VARCHAR2, p_data IN DATE, p_uso_interno IN VARCHAR2,
         p_lingue IN VARCHAR2, p_prenotazione IN NUMBER, p_voce_menu IN VARCHAR2) IS
d_errtext                       VARCHAR2(240);
d_prenotazione                   NUMBER(6);
d_rior_data                        DATE;
d_popi_sede_posto               VARCHAR2(4);
d_popi_anno_posto                NUMBER(4);
d_popi_numero_posto              NUMBER(7);
d_popi_posto                     NUMBER(5);
d_popi_dal                         DATE;
d_popi_stato                    VARCHAR2(1);
d_popi_situazione               VARCHAR2(1);
d_popi_ricopribile              VARCHAR2(1);
d_popi_gruppo                   VARCHAR2(12);
d_popi_pianta                    NUMBER(6);
d_setp_sequenza                  NUMBER(6);
d_setp_codice                   VARCHAR2(15);
d_popi_settore                   NUMBER(6);
d_sett_sequenza                  NUMBER(6);
d_sett_codice                   VARCHAR2(15);
d_sett_suddivisione              NUMBER(1);
d_sett_settore_g                 NUMBER(6);
d_setg_sequenza                  NUMBER(6);
d_setg_codice                   VARCHAR2(15);
d_sett_settore_a                 NUMBER(6);
d_seta_sequenza                  NUMBER(6);
d_seta_codice                   VARCHAR2(15);
d_sett_settore_b                 NUMBER(6);
d_setb_sequenza                  NUMBER(6);
d_setb_codice                   VARCHAR2(15);
d_sett_settore_c                 NUMBER(6);
d_setc_sequenza                  NUMBER(6);
d_setc_codice                   VARCHAR2(15);
d_sett_gestione                 VARCHAR2(4);
d_gest_prospetto_po             VARCHAR2(1);
d_gest_sintetico_po             VARCHAR2(1);
d_sett_sede                      NUMBER(6);
d_sedi_codice                   VARCHAR2(8);
d_sedi_sequenza                  NUMBER(6);
d_popi_figura                    NUMBER(6);
d_figi_dal                         DATE;
d_figu_sequenza                  NUMBER(6);
d_figi_codice                   VARCHAR2(8);
d_figi_qualifica                 NUMBER(6);
d_qugi_dal                         DATE;
d_qual_sequenza                  NUMBER(6);
d_qugi_codice                   VARCHAR2(8);
d_qugi_contratto                VARCHAR2(4);
d_cost_dal                         DATE;
d_cont_sequenza                  NUMBER(3);
d_cost_ore_lavoro                NUMBER(5,2);
d_qugi_livello                  VARCHAR2(4);
d_figi_profilo                  VARCHAR2(4);
d_prpr_sequenza                  NUMBER(3);
d_prpr_suddivisione_po          VARCHAR2(1);
d_figi_posizione                VARCHAR2(4);
d_pofu_sequenza                  NUMBER(3);
d_qugi_ruolo                    VARCHAR2(4);
d_ruol_sequenza                  NUMBER(4);
d_popi_attivita                 VARCHAR2(4);
d_atti_sequenza                  NUMBER(6);
d_popi_ore                       NUMBER(5,2);
d_pegi_posizione                VARCHAR2(4);
d_posi_sequenza                  NUMBER(3);
d_posi_di_ruolo                  NUMBER(1);
d_pegi_tipo_rapporto            VARCHAR2(4);
d_pegi_ore                       NUMBER(5,2);
d_cado_previsti                  NUMBER(5);
d_cado_ore_previsti              NUMBER(5,2);
d_cado_in_pianta                 NUMBER(5);
d_cado_in_deroga                 NUMBER(5);
d_cado_in_sovrannumero           NUMBER(5);
d_cado_in_rilascio               NUMBER(5);
d_cado_in_istituzione            NUMBER(5);
d_cado_in_acquisizione           NUMBER(5);
d_cado_ass_ruolo_l1              NUMBER(5);
d_cado_ore_ass_ruolo_l1          NUMBER(5,2);
d_cado_ass_ruolo_l2              NUMBER(5);
d_cado_ore_ass_ruolo_l2          NUMBER(5,2);
d_cado_ass_ruolo_l3              NUMBER(5);
d_cado_ore_ass_ruolo_l3          NUMBER(5,2);
d_cado_ass_ruolo                 NUMBER(5);
d_cado_ore_ass_ruolo             NUMBER(5,2);
d_cado_assegnazioni              NUMBER(5);
d_cado_ore_assegnazioni          NUMBER(5,2);
d_cado_assenze_incarico          NUMBER(5);
d_cado_assenze_assenza           NUMBER(5);
d_cado_disponibili               NUMBER(5);
d_cado_ore_disponibili           NUMBER(5,2);
d_cado_coperti_ruolo_1           NUMBER(5);
d_cado_ore_coperti_ruolo_1       NUMBER(5,2);
d_cado_coperti_ruolo_2           NUMBER(5);
d_cado_ore_coperti_ruolo_2       NUMBER(5,2);
d_cado_coperti_ruolo_3           NUMBER(5);
d_cado_ore_coperti_ruolo_3       NUMBER(5,2);
d_cado_coperti_ruolo             NUMBER(5);
d_cado_ore_coperti_ruolo         NUMBER(5,2);
d_cado_coperti_no_ruolo          NUMBER(5);
d_cado_ore_coperti_no_ruolo      NUMBER(5,2);
d_cado_vacanti                   NUMBER(5);
d_cado_ore_vacanti               NUMBER(5,2);
d_cado_vacanti_coperti           NUMBER(5);
d_cado_ore_vacanti_coperti       NUMBER(5,2);
d_cado_vacanti_non_coperti       NUMBER(5);
d_cado_ore_vacanti_non_coperti   NUMBER(5,2);
d_cado_vacanti_non_ricopribili   NUMBER(5);
d_cado_dotazioni_ruolo           NUMBER(5);
d_cado_ore_dotazioni_ruolo       NUMBER(5,2);
d_cado_dotazioni_no_ruolo        NUMBER(5);
d_cado_ore_dotazioni_no_ruolo    NUMBER(5,2);
d_cado_straordinari              NUMBER(5);
d_cado_ore_straordinari          NUMBER(5,2);
d_cado_tp                        NUMBER(5);
d_cado_td                        NUMBER(5);
nOre                             NUMBER(5,2);
nOre_1                           NUMBER(5,2);
nOre_2                           NUMBER(5,2);
nOre_3                           NUMBER(5,2);
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
      ,pg.posizione
      ,NVL(po.sequenza,999)
      ,pg.tipo_rapporto
      ,pg.figura
      ,pg.qualifica
      ,pg.ATTIVITA
      ,pg.SETTORE
      ,pg.sede
      ,pg.sede_posto
      ,pg.anno_posto
      ,pg.numero_posto
      ,pg.posto
  FROM POSIZIONI         pa
      ,POSIZIONI         po
      ,PERIODI_GIURIDICI pg
 WHERE d_rior_data       BETWEEN pg.dal
                         AND NVL(pg.al,TO_DATE('3333333','j'))
   AND (    pg.rilevanza      IN ('Q','I')
        AND P_d_f           = 'D'
        AND p_uso_interno   = 'X'
        OR  pg.rilevanza      IN ('S','E')
        AND p_d_f           = 'F'
        AND P_uso_interno   = 'X'
        OR  pg.rilevanza       = 'Q'
        AND po.ruolo           = 'SI'
        AND P_d_f           = 'D'
        AND P_uso_interno  IS NULL
        OR  pg.rilevanza       = 'S'
        AND po.ruolo           = 'SI'
        AND p_d_f           = 'F'
        AND P_uso_interno  IS NULL
       )
   AND pa.codice               = pg.posizione
   AND po.codice               = pa.posizione
;
BEGIN
  BEGIN
     SELECT P_data
       INTO d_rior_data
       FROM RIFERIMENTO_ORGANICO
     ;
  END;
  OPEN dotazioni;
  LOOP
    d_cado_straordinari := 0;
   d_cado_ore_straordinari := 0;
   d_cado_tp := 0;
   d_cado_td := 0;
    FETCH dotazioni INTO d_pegi_ore,
                    d_cado_dotazioni_ruolo,d_cado_dotazioni_no_ruolo,
                    d_pegi_posizione,d_posi_sequenza,
                    d_pegi_tipo_rapporto,
                    d_popi_figura,d_figi_qualifica,
                    d_popi_attivita,d_popi_settore,d_sett_sede,
                    d_popi_sede_posto,d_popi_anno_posto,
                    d_popi_numero_posto,d_popi_posto;
    EXIT  WHEN dotazioni%NOTFOUND;
    d_popi_dal             := NULL;
    d_popi_stato           := NULL;
    d_popi_situazione      := NULL;
    d_popi_ricopribile     := NULL;
    d_popi_gruppo          := NULL;
    d_popi_ore             := NULL;
    d_popi_pianta          := NULL;
    d_setp_codice          := NULL;
    d_setp_sequenza        := NULL;
    IF  d_popi_sede_posto     IS NOT NULL
    AND d_popi_anno_posto     IS NOT NULL
    AND d_popi_numero_posto   IS NOT NULL
    AND d_popi_posto          IS NOT NULL THEN
       BEGIN
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
           WHERE sede_posto        = d_popi_sede_posto
             AND anno_posto        = d_popi_anno_posto
             AND numero_posto      = d_popi_numero_posto
             AND posto             = d_popi_posto
             AND d_rior_data BETWEEN dal
                             AND NVL(al,TO_DATE('3333333','j'))
          ;
       END;
       BEGIN
          SELECT NVL(sequenza,999999),codice
            INTO d_setp_sequenza,d_setp_codice
            FROM SETTORI
           WHERE numero = d_popi_pianta
          ;
       END;
    END IF;
    BEGIN
       SELECT NVL(S.sequenza,999999),S.codice,S.suddivisione,S.gestione,
              g.prospetto_po,NVL(g.sintetico_po,g.prospetto_po),
              S.settore_g,S.settore_a,
              S.settore_b,S.settore_c,g.sintetico_po
         INTO d_sett_sequenza,d_sett_codice,d_sett_suddivisione,
              d_sett_gestione,d_gest_prospetto_po,d_gest_sintetico_po,
              d_sett_settore_g,d_sett_settore_a,
              d_sett_settore_b,d_sett_settore_c,d_gest_sintetico_po
         FROM GESTIONI g,SETTORI S
        WHERE S.numero    = d_popi_settore
          AND g.codice    = S.gestione
       ;
    END;
    IF d_sett_suddivisione = 0 THEN
       d_sett_settore_g   := d_popi_settore;
       d_setg_sequenza    := d_sett_sequenza;
       d_setg_codice      := d_sett_codice;
       d_sett_settore_a   := d_popi_settore;
       d_seta_sequenza    := 0;
       d_seta_codice      := d_sett_codice;
       d_sett_settore_b   := d_popi_settore;
       d_setb_sequenza    := 0;
       d_setb_codice      := d_sett_codice;
       d_sett_settore_c   := d_popi_settore;
       d_setc_sequenza    := 0;
       d_setc_codice      := d_sett_codice;
    ELSE
       BEGIN
         SELECT NVL(sequenza,999999),codice
           INTO d_setg_sequenza,d_setg_codice
           FROM SETTORI
          WHERE numero = d_sett_settore_g
         ;
       END;
       IF d_sett_suddivisione = 1 THEN
          d_sett_settore_a   := d_popi_settore;
          d_seta_sequenza    := d_sett_sequenza;
          d_seta_codice      := d_sett_codice;
          d_sett_settore_b   := d_popi_settore;
          d_setb_sequenza    := 0;
          d_setb_codice      := d_sett_codice;
          d_sett_settore_c   := d_popi_settore;
          d_setc_sequenza    := 0;
          d_setc_codice      := d_sett_codice;
       ELSE
          BEGIN
            SELECT NVL(sequenza,999999),codice
              INTO d_seta_sequenza,d_seta_codice
              FROM SETTORI
             WHERE numero = d_sett_settore_a
            ;
          END;
          IF d_sett_suddivisione = 2 THEN
             d_sett_settore_b   := d_popi_settore;
             d_setb_sequenza    := d_sett_sequenza;
             d_setb_codice      := d_sett_codice;
             d_sett_settore_c   := d_popi_settore;
             d_setc_sequenza    := 0;
             d_setc_codice      := d_sett_codice;
          ELSE
            BEGIN
              SELECT NVL(sequenza,999999),codice
                INTO d_setb_sequenza,d_setb_codice
                FROM SETTORI
               WHERE numero = d_sett_settore_b
              ;
            END;
            IF d_sett_suddivisione = 3 THEN
               d_sett_settore_c   := d_popi_settore;
               d_setc_sequenza     := d_sett_sequenza;
               d_setc_codice      := d_sett_codice;
            ELSE
               BEGIN
                  SELECT NVL(sequenza,999999),codice
                    INTO d_setc_sequenza,d_setc_codice
                    FROM SETTORI
                   WHERE numero = d_sett_settore_c
                  ;
               END;
            END IF;
          END IF;
       END IF;
    END IF;
/*  elaborazione di diritto */
    IF p_d_f = 'D' THEN
       BEGIN
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
           FROM POSIZIONI_FUNZIONALI     pf,
                PROFILI_PROFESSIONALI    pr,
                RUOLI                    ru,
                CONTRATTI_STORICI        cs,
                CONTRATTI                co,
                QUALIFICHE_GIURIDICHE    qg,
                QUALIFICHE               qu,
                FIGURE_GIURIDICHE        fg,
                FIGURE                   fi
          WHERE d_rior_data         BETWEEN fg.dal
                                    AND NVL(fg.al,TO_DATE('3333333','j'))
            AND d_rior_data         BETWEEN qg.dal
                                    AND NVL(qg.al,TO_DATE('3333333','j'))
            AND d_rior_data         BETWEEN cs.dal
                                    AND NVL(cs.al,TO_DATE('3333333','j'))
            AND pf.profilo      (+) = fg.profilo
            AND pf.codice       (+) = fg.posizione
            AND pr.codice       (+) = fg.profilo
            AND ru.codice           = qg.ruolo
            AND cs.contratto        = qg.contratto
            AND co.codice           = qg.contratto
            AND qg.numero           = fg.qualifica
            AND qu.numero           = fg.qualifica
            AND fg.numero           = d_popi_figura
            AND fi.numero           = d_popi_figura
         ;
       END;
/*  elaborazione di diritto */
       BEGIN
          SELECT S.sede,d.codice,NVL(d.sequenza,999999)
            INTO d_sett_sede,d_sedi_codice,d_sedi_sequenza
            FROM SEDI     d
                ,SETTORI  S
           WHERE S.numero = d_popi_settore
             AND S.sede   = d.numero (+)
          ;
       END;
   END IF;
   IF P_d_f = 'F' THEN
       BEGIN
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
           FROM POSIZIONI_FUNZIONALI     pf,
                PROFILI_PROFESSIONALI    pr,
                RUOLI                    ru,
                CONTRATTI_STORICI        cs,
                CONTRATTI                co,
                QUALIFICHE_GIURIDICHE    qg,
                QUALIFICHE               qu,
                FIGURE_GIURIDICHE        fg,
                FIGURE                   fi
          WHERE d_rior_data         BETWEEN fg.dal
                                    AND NVL(fg.al,TO_DATE('3333333','j'))
            AND d_rior_data         BETWEEN qg.dal
                                    AND NVL(qg.al,TO_DATE('3333333','j'))
            AND d_rior_data         BETWEEN cs.dal
                                    AND NVL(cs.al,TO_DATE('3333333','j'))
            AND pf.profilo      (+) = fg.profilo
            AND pf.codice       (+) = fg.posizione
            AND pr.codice       (+) = fg.profilo
            AND ru.codice           = qg.ruolo
            AND cs.contratto        = qg.contratto
            AND co.codice           = qg.contratto
            AND qg.numero           = d_figi_qualifica
            AND qu.numero           = qg.numero
            AND fg.numero           = d_popi_figura
            AND fi.numero           = d_popi_figura
         ;
       END;
       BEGIN
          SELECT d.codice,NVL(d.sequenza,999999)
            INTO d_sedi_codice,d_sedi_sequenza
            FROM SEDI     d
           WHERE d.numero = d_sett_sede
          ;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             d_sedi_codice   := NULL;
             d_sedi_sequenza := 999999;
       END;
    END IF;
    BEGIN
      SELECT NVL(sequenza,999999)
        INTO d_atti_sequenza
        FROM ATTIVITA
       WHERE codice    = d_popi_attivita
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        d_atti_sequenza := 999999;
    END;
--
    d_cado_ore_previsti :=
    NVL(d_pegi_ore,NVL(d_popi_ore,d_cost_ore_lavoro));
   IF d_cado_dotazioni_no_ruolo > 0 AND d_popi_posto IS NULL
   THEN
     d_cado_straordinari := 1;
     d_cado_ore_straordinari := d_cado_ore_previsti;
   END IF;
   IF d_pegi_tipo_rapporto LIKE 'TP%' AND d_popi_posto IS NULL
   THEN
     d_cado_tp := 1;
   END IF;
   IF d_pegi_tipo_rapporto LIKE 'TD%' AND d_popi_posto IS NULL
   THEN
     d_cado_td := 1;
   END IF;
--
--  Inserimento Registrazione Dotazione.
--
    BEGIN
       IF d_cado_dotazioni_ruolo + d_cado_dotazioni_no_ruolo > 0 AND
          p_uso_interno = 'X' OR d_cado_dotazioni_ruolo > 0 AND
          p_uso_interno IS NULL THEN
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
          cado_previsti,cado_ore_previsti,cado_in_pianta,cado_in_deroga,
          cado_in_sovrannumero,cado_in_rilascio,cado_in_acquisizione,
          cado_in_istituzione,cado_assegnazioni_ruolo_l1,
          cado_ore_assegnazioni_ruolo_l1,cado_assegnazioni_ruolo_l2,
          cado_ore_assegnazioni_ruolo_l2,cado_assegnazioni_ruolo_l3,
          cado_ore_assegnazioni_ruolo_l3,cado_assegnazioni_ruolo,
          cado_vacanti,cado_vacanti_coperti,
          cado_coperti_ruolo,cado_coperti_no_ruolo,
          cado_straordinari,cado_tp,cado_td)
         VALUES
         (P_prenotazione,1,P_lingue,d_rior_data,d_popi_sede_posto,
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
          NULL,0,NULL,
          0,d_cado_ore_previsti,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          d_cado_dotazioni_ruolo,d_cado_dotazioni_no_ruolo,
        d_cado_straordinari,d_cado_tp,d_cado_td)
         ;
      END IF;
    END;
  END LOOP;
  CLOSE dotazioni;
/*
EXCEPTION
  WHEN OTHERS THEN
    d_errtext := SUBSTR(SQLERRM,1,240);
    d_prenotazione := p_prenotazione;
    ROLLBACK;
    INSERT INTO ERRORI_POGM (prenotazione,voce_menu,data,errore)
    VALUES (d_prenotazione,p_VOCE_MENU ,SYSDATE,d_errtext)
    ;
    COMMIT;
--    RAISE FORM_TRIGGER_FAILURE;
*/
END;
PROCEDURE RAGGR_POSTI (p_prenotazione IN NUMBER, p_voce_menu IN VARCHAR2) IS
d_errtext VARCHAR2(240);
d_prenotazione NUMBER(6);
BEGIN
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
    cado_previsti,cado_ore_previsti,cado_in_pianta,cado_in_deroga,
    cado_in_sovrannumero,cado_in_rilascio,cado_in_acquisizione,
    cado_in_istituzione,cado_assegnazioni_ruolo_l1,
    cado_ore_assegnazioni_ruolo_l1,cado_assegnazioni_ruolo_l2,
    cado_ore_assegnazioni_ruolo_l2,cado_assegnazioni_ruolo_l3,
    cado_ore_assegnazioni_ruolo_l3,cado_assegnazioni_ruolo,
    cado_coperti_ruolo,cado_coperti_no_ruolo,
    cado_vacanti,cado_vacanti_coperti,cado_straordinari,
   cado_sostituibili,cado_supplenti,cado_incaricati,cado_tp,cado_td,
   cado_mansioni_sup,cado_inc_aq,cado_assenze_assenza,cado_assenze_non_retr,
   cado_universitari)
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
    SUM(cado_previsti),cado_ore_previsti,
    SUM(cado_in_pianta),SUM(cado_in_deroga),
    SUM(cado_in_sovrannumero),SUM(cado_in_rilascio),
    SUM(cado_in_acquisizione),SUM(cado_in_istituzione),
    SUM(cado_assegnazioni_ruolo_l1),cado_ore_assegnazioni_ruolo_l1,
    SUM(cado_assegnazioni_ruolo_l2),cado_ore_assegnazioni_ruolo_l2,
    SUM(cado_assegnazioni_ruolo_l3),cado_ore_assegnazioni_ruolo_l3,
    SUM(cado_assegnazioni_ruolo),
    SUM(cado_coperti_ruolo),SUM(cado_coperti_no_ruolo),
    SUM(cado_vacanti),SUM(cado_vacanti_coperti),
   SUM(cado_straordinari),SUM(cado_sostituibili),SUM(cado_supplenti),
   SUM(cado_incaricati),SUM(cado_tp),SUM(cado_td),
   SUM(cado_mansioni_sup),SUM(cado_inc_aq),SUM(cado_assenze_assenza),
   SUM(cado_assenze_non_retr),SUM(cado_universitari)
  FROM CALCOLO_DOTAZIONE
 WHERE cado_prenotazione = p_prenotazione
   AND cado_rilevanza    < 6
 GROUP BY
    cado_prenotazione,cado_rilevanza,popi_pianta,popi_settore,sett_sede,
    popi_figura,figi_qualifica,popi_attivita,popi_gruppo,pegi_posizione,
    pegi_tipo_rapporto,cado_ore_previsti,
    cado_ore_assegnazioni_ruolo_l1,cado_ore_assegnazioni_ruolo_l2,
    cado_ore_assegnazioni_ruolo_l3
;
/*
EXCEPTION
  WHEN OTHERS THEN
    d_errtext := SUBSTR(SQLERRM,1,240);
    d_prenotazione := p_prenotazione;
    ROLLBACK;
    INSERT INTO ERRORI_POGM (prenotazione,voce_menu,data,errore)
    VALUES (d_prenotazione,P_VOCE_MENU ,SYSDATE,d_errtext)
    ;
    COMMIT;
--    RAISE FORM_TRIGGER_FAILURE;
*/
END;
END;
/

