CREATE OR REPLACE PACKAGE Ppocsido2 IS
/******************************************************************************
 NOME:          PPOCSIDO2
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
  PROCEDURE CC_NOMINATIVO (p_d_f IN VARCHAR2, p_data IN DATE, p_uso_interno IN VARCHAR2,
         p_prenotazione IN NUMBER, p_voce_menu IN VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY Ppocsido2 IS
-- FORM_TRIGGER_FAILURE EXCEPTION;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE CALCOLO_ETA_ANZIANITA (
P_CI          IN     NUMBER,
P_MM_ETA      IN OUT NUMBER,
P_AA_ETA      IN OUT NUMBER,
P_GG_ANZ      IN OUT NUMBER,
P_MM_ANZ      IN OUT NUMBER,
P_AA_ANZ      IN OUT NUMBER
                                ) IS
d_cndo_mm_eta    NUMBER(4);
d_cndo_aa_eta    NUMBER(4);
d_gg_anz         NUMBER(4);
d_mm_anz         NUMBER(4);
d_aa_anz         NUMBER(4);
d_cndo_gg_anz    NUMBER(4);
d_cndo_mm_anz    NUMBER(4);
d_cndo_aa_anz    NUMBER(4);
d_ci             NUMBER(8);
d_conta          NUMBER(6);
BEGIN
d_ci := P_CI;
SELECT  SUM((TRUNC((TRUNC(MONTHS_BETWEEN(LAST_DAY(NVL(PEGI.al
              ,rior.data
              ) + 1
          )
 ,LAST_DAY(PEGI.dal)
 )
                  ) * 30
             - LEAST(30,TO_NUMBER(TO_CHAR(PEGI.dal,'dd'
         )
  )
                    ) + 1
             + LEAST(30,TO_NUMBER(TO_CHAR(NVL(PEGI.al
             ,rior.data
             ) + 1,'dd'
         )
 ) - 1
                    )
            ) / 360
           ))
      * TO_NUMBER(DECODE(PEGI.rilevanza,'Q',1,-1))
     )        --  Anni di Anzianita`
 ,SUM((TRUNC((TRUNC(MONTHS_BETWEEN(LAST_DAY(NVL(PEGI.al
             ,rior.data
             ) + 1
         )
                                ,LAST_DAY(PEGI.dal)
                                )
                 ) * 30
            - LEAST(30,TO_NUMBER(TO_CHAR(PEGI.dal,'dd'
        )
                                )
                   ) + 1
            + LEAST(30,TO_NUMBER(TO_CHAR(NVL(PEGI.al
            ,rior.data
            ) + 1,'dd'
        )
                                ) - 1
                   )
           - TRUNC((TRUNC(MONTHS_BETWEEN(LAST_DAY(NVL(PEGI.al
                 ,rior.data
                     ) + 1
                 )
        ,LAST_DAY(PEGI.dal)
        )
                         ) * 30
                    - LEAST(30,TO_NUMBER(TO_CHAR(PEGI.dal,'dd'
                )
        )
                           ) + 1
                    + LEAST(30,TO_NUMBER(TO_CHAR(NVL(PEGI.al
                ,rior.data
                    ) + 1,'dd'
                )
        ) - 1
                           )
                   ) / 360
                  ) * 360
           ) / 30))
      * TO_NUMBER(DECODE(PEGI.rilevanza,'Q',1,-1))
     )   -- Mesi di Anzianita`
 ,SUM((
 TRUNC(MONTHS_BETWEEN( LAST_DAY(NVL(PEGI.al,rior.data)+1)
                      ,LAST_DAY(PEGI.dal)
                     )
      )*30
     -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.dal,'dd'))
           )+1
     +LEAST( 30,TO_NUMBER(TO_CHAR( NVL(PEGI.al,rior.data)+1
          ,'dd'))-1)   -
(TRUNC((TRUNC(MONTHS_BETWEEN( LAST_DAY( NVL(PEGI.al,rior.data)+1
      )
                             ,LAST_DAY(PEGI.dal)
                            )
             )*30
       -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.dal,'dd'))
             )+1
       +LEAST( 30,TO_NUMBER( TO_CHAR( NVL(PEGI.al,rior.data)+1
                            ,'dd'))
             -1))  / 360
      )  *360 )                            -
  TRUNC(
 (TRUNC(MONTHS_BETWEEN( LAST_DAY( NVL(PEGI.al,rior.data)+1
      )
                             ,LAST_DAY(PEGI.dal)
                            )
             )*30
       -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.dal,'dd'))
             )+1
       +LEAST( 30,TO_NUMBER( TO_CHAR( NVL(PEGI.al,rior.data)+1
                            ,'dd'))
             -1) -
 TRUNC((TRUNC(MONTHS_BETWEEN( LAST_DAY( NVL(PEGI.al,rior.data)+1
      )
                             ,LAST_DAY(PEGI.dal)
                            )
             )*30
       -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.dal,'dd'))
             )+1
       +LEAST( 30,TO_NUMBER( TO_CHAR( NVL(PEGI.al,rior.data)+1
                            ,'dd'))
             -1))  / 360
      ) * 360) / 30) * 30)
      * TO_NUMBER(DECODE(PEGI.rilevanza,'Q',1,-1))
 )   -- Giorni di Anzianita`
 ,MAX(TRUNC(MONTHS_BETWEEN(rior.data,anag.data_nas) / 12))
     -- Anni di Eta`
 ,MAX(TRUNC(MONTHS_BETWEEN(rior.data,anag.data_nas))
     -TRUNC(MONTHS_BETWEEN(rior.data,anag.data_nas) / 12)
     * 12)  -- Mesi di Eta`
,COUNT(*)
  INTO  d_aa_anz
       ,d_mm_anz
       ,d_gg_anz
       ,d_cndo_aa_eta
       ,d_cndo_mm_eta
       ,d_conta
  FROM  RAPPORTI_INDIVIDUALI               rain
       ,ANAGRAFICI                         anag
       ,PERIODI_GIURIDICI                  PEGI
       ,RIFERIMENTO_ORGANICO               rior
 WHERE  rain.ci                               = PEGI.ci
   AND  anag.ni                               = rain.ni
   AND  rior.data               BETWEEN anag.dal
      AND NVL(anag.al,
             TO_DATE('3333333','j'))
   AND  (    PEGI.rilevanza                  = 'Q'
   OR  PEGI.rilevanza                  = 'A'
   AND EXISTS
       (SELECT 'x'
          FROM ASTENSIONI aste
         WHERE aste.codice              = PEGI.assenza
           AND aste.SERVIZIO            = 0
       )
  )
   AND  PEGI.dal                            <= rior.data
   AND  PEGI.ci                         = d_ci
;
    d_cndo_gg_anz := MOD((d_gg_anz       +
                          d_mm_anz * 30  +
                          d_aa_anz * 360
                         ),30
                        );
    d_cndo_mm_anz := TRUNC(MOD((d_gg_anz       +
                                d_mm_anz * 30  +
                                d_aa_anz * 360
                               ),360
                              ) / 30
                          );
    d_cndo_aa_anz := TRUNC((d_gg_anz       +
                            d_mm_anz * 30  +
                            d_aa_anz * 360
                           ) / 360
                          );
IF d_conta = 0 THEN           -- No data found
   d_cndo_mm_eta := 0;
   d_cndo_aa_eta := 0;
   d_cndo_gg_anz := 0;
   d_cndo_mm_anz := 0;
   d_cndo_aa_anz := 0;
END IF;
P_MM_ETA := d_cndo_mm_eta;
P_AA_ETA := d_cndo_aa_eta;
P_GG_ANZ := d_cndo_gg_anz;
P_MM_ANZ := d_cndo_mm_anz;
P_AA_ANZ := d_cndo_aa_anz;
END;
  PROCEDURE CC_NOMINATIVO (p_d_f IN VARCHAR2, p_data IN DATE, p_uso_interno IN VARCHAR2,
         p_prenotazione IN NUMBER, p_voce_menu IN VARCHAR2)IS
d_errtext                       VARCHAR2(240);
d_prenotazione                   NUMBER(6);
d_conta_cursori                  NUMBER(2);
d_rilevanza                      NUMBER(2);
d_rior_data                        DATE;
d_popi_sede_posto               VARCHAR2(4);
d_popi_anno_posto                NUMBER(4);
d_popi_numero_posto              NUMBER(7);
d_popi_posto                     NUMBER(5);
d_popi_dal                         DATE;
d_popi_ricopribile              VARCHAR2(1);
d_popi_ore                       NUMBER(5,2);
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
d_ruol_sequenza                  NUMBER(3);
d_popi_attivita                 VARCHAR2(4);
d_atti_sequenza                  NUMBER(6);
d_pegi_posizione                VARCHAR2(4);
d_posi_sequenza                  NUMBER(3);
d_posi_ruolo                    VARCHAR2(2);
d_pegi_tipo_rapporto            VARCHAR2(4);
d_pegi_ore                       NUMBER(5,2);
d_pegi_ci                        NUMBER(8);
d_pegi_sostituto                 NUMBER(8);
d_anag_gruppo_ling              VARCHAR2(4);
d_pegi_rilevanza                VARCHAR2(1);
d_pegi_assenza                  VARCHAR2(4);
d_pegi_dal                         DATE;
d_pegi_al                          DATE;
d_cndo_mm_eta                    NUMBER(2);
d_cndo_aa_eta                    NUMBER(2);
d_cndo_gg_anz                    NUMBER(2);
d_cndo_mm_anz                    NUMBER(2);
d_cndo_aa_anz                    NUMBER(2);
d_popi_sede_posto_inc           VARCHAR2(4);
d_popi_anno_posto_inc            NUMBER(4);
d_popi_numero_posto_inc          NUMBER(7);
d_popi_posto_inc                 NUMBER(5);
d_pegi_tp                        NUMBER(5);
d_pegi_td                        NUMBER(5);
d_cndo_ruolo                     NUMBER(5);
d_cndo_incaricato                NUMBER(5);
d_cndo_mans_sup                  NUMBER(5);
d_cndo_inc_td                    NUMBER(5);
d_cndo_supplente                 NUMBER(5);
d_cndo_inc_aq                    NUMBER(5);
d_cndo_assente                   NUMBER(5);
d_cndo_aspettativa               NUMBER(5);
d_cndo_univ                      NUMBER(5);
d_cndo_vac_tit                   NUMBER(5);
d_cndo_vac_disp                  NUMBER(5);
d_cndo_sovr                      NUMBER(5);
d_cndo_disp_supp                 NUMBER(5);
d_ore                            NUMBER(5,2);
CURSOR periodi IS
SELECT 1
      ,pg.ore
      ,pg.posizione
      ,NVL(po.sequenza,999)
      ,pg.tipo_rapporto
      ,pg.figura
      ,NVL(pg.qualifica,fg.qualifica)
      ,pg.ATTIVITA
      ,pg.SETTORE
      ,pg.sede
      ,pg.sede_posto
      ,pg.anno_posto
      ,pg.numero_posto
      ,pg.posto
      ,pg.ci,NVL(pg.sostituto,pg.ci)
      ,pg.rilevanza,pg.assenza,pg.dal,pg.al
      ,po.ruolo,an.gruppo_ling
  FROM POSIZIONI             p2
      ,POSIZIONI             po
      ,FIGURE_GIURIDICHE     fg
      ,ANAGRAFICI            an
      ,RAPPORTI_INDIVIDUALI  ri
      ,PERIODI_GIURIDICI     pg
 WHERE d_rior_data       BETWEEN pg.dal
                         AND NVL(pg.al,TO_DATE('3333333','j'))
   AND d_rior_data       BETWEEN fg.dal
                         AND NVL(fg.al,TO_DATE('3333333','j'))
   AND fg.numero               = pg.figura
   AND (    pg.rilevanza      IN ('Q','I')
        AND p_d_f           = 'D'
        AND p_uso_interno   = 'X'
        OR  pg.rilevanza      IN ('S','E')
        AND p_d_f           = 'F'
        AND p_uso_interno   = 'X'
        OR  pg.rilevanza       = 'Q'
        AND po.ruolo           = 'SI'
        AND p_d_f           = 'D'
        AND p_uso_interno  IS NULL
        OR  pg.rilevanza       = 'S'
        AND po.ruolo           = 'SI'
        AND p_d_f           = 'F'
        AND p_uso_interno  IS NULL
       )
   AND d_rior_data BETWEEN an.dal AND NVL(an.al,TO_DATE('3333333','j'))
   AND an.ni               = ri.ni
   AND ri.ci               = pg.ci
   AND po.codice           = p2.posizione
   AND p2.codice           = pg.posizione
;
CURSOR assenze IS
SELECT 2
      ,p2.ore
      ,p2.posizione
      ,999
      ,p2.tipo_rapporto
      ,p2.figura
      ,NVL(p2.qualifica,fg.qualifica)
      ,p2.ATTIVITA
      ,p2.SETTORE
      ,p2.sede
      ,p2.sede_posto
      ,p2.anno_posto
      ,p2.numero_posto
      ,p2.posto
      ,pg.ci,NVL(p2.sostituto,pg.ci)
      ,pg.rilevanza,pg.assenza,pg.dal,pg.al
      ,NULL,an.gruppo_ling
  FROM POSIZIONI             pa
      ,POSIZIONI             po
      ,FIGURE_GIURIDICHE     fg
      ,ANAGRAFICI            an
      ,RAPPORTI_INDIVIDUALI  ri
      ,PERIODI_GIURIDICI     p2
      ,PERIODI_GIURIDICI     pg
 WHERE d_rior_data       BETWEEN pg.dal
                         AND NVL(pg.al,TO_DATE('3333333','j'))
   AND d_rior_data       BETWEEN p2.dal
                         AND NVL(p2.al,TO_DATE('3333333','j'))
   AND d_rior_data       BETWEEN fg.dal
                         AND NVL(fg.al,TO_DATE('3333333','j'))
   AND d_rior_data BETWEEN an.dal AND NVL(an.al,TO_DATE('3333333','j'))
   AND fg.numero           = p2.figura
   AND po.codice           = p2.posizione
   AND pa.codice           = po.posizione
   AND an.ni               = ri.ni
   AND ri.ci               = pg.ci
   AND p2.ci               = pg.ci
   AND pg.rilevanza        = 'A'
   AND (    p2.rilevanza   = 'Q'
        AND p_d_f       = 'D'
        AND NOT EXISTS
                (SELECT 1
                   FROM PERIODI_GIURIDICI p3
                  WHERE d_rior_data BETWEEN p3.dal
                                    AND NVL(p3.al,TO_DATE('3333333','j'))
                    AND p3.rilevanza      = 'I'
                    AND p3.ci             = p2.ci
                )
        OR  p2.rilevanza   = 'S'
        AND p_d_f       = 'F'
        AND NOT EXISTS
                (SELECT 1
                   FROM PERIODI_GIURIDICI p3
                  WHERE d_rior_data BETWEEN p3.dal
                                    AND NVL(p3.al,TO_DATE('3333333','j'))
                    AND p3.rilevanza      = 'E'
                    AND p3.ci             = p2.ci
                )
        OR  p2.rilevanza   = 'I'
        AND p_d_f       = 'D'
        OR  p2.rilevanza   = 'E'
        AND p_d_f       = 'F'
       )
   AND p_uso_interno    = 'X'
   AND pg.assenza    IN
       (SELECT aa.codice
          FROM ASTENSIONI aa
         WHERE aa.sostituibile = 1
       )
;
CURSOR vacanti IS
SELECT 3
      ,pp.ore
      ,NULL
      ,999
      ,NULL
      ,pp.figura
      ,fg.qualifica
      ,pp.ATTIVITA
      ,pp.SETTORE
      ,NULL
      ,pp.sede_posto
      ,pp.anno_posto
      ,pp.numero_posto
      ,pp.posto
      ,0,0
      ,NULL,NULL,pp.dal,pp.al
      ,NULL,NULL
  FROM FIGURE_GIURIDICHE   fg
      ,POSTI_PIANTA        pp
 WHERE d_rior_data BETWEEN pp.dal AND NVL(pp.al,TO_DATE('3333333','j'))
   AND d_rior_data BETWEEN fg.dal AND NVL(fg.al,TO_DATE('3333333','j'))
   AND pp.figura                 = fg.numero
   AND (    pp.stato             = 'A'
        AND pp.situazione        = 'R'
        OR  pp.stato            IN ('T','I','C')
       )
   AND NOT EXISTS
       (SELECT 1
          FROM PERIODI_GIURIDICI pg
         WHERE d_rior_data BETWEEN pg.dal
                               AND NVL(pg.al,TO_DATE('3333333','j'))
           AND pg.rilevanza      = 'Q'
           AND pg.sede_posto     = pp.sede_posto
           AND pg.anno_posto     = pp.anno_posto
           AND pg.numero_posto   = pp.numero_posto
           AND pg.posto          = pp.posto
           AND pg.posizione     IN (SELECT posi.codice
      FROM POSIZIONI posi
     WHERE posi.ruolo = 'SI'
   )
       )
;
BEGIN
  BEGIN
     SELECT p_data
       INTO d_rior_data
       FROM RIFERIMENTO_ORGANICO
     ;
  END;
  d_conta_cursori := 0;
  LOOP
  d_conta_cursori := d_conta_cursori + 1;
  IF d_conta_cursori > 3 THEN
     EXIT;
  END IF;
  IF d_conta_cursori = 1 THEN
  OPEN periodi;
  END IF;
  IF d_conta_cursori = 2 THEN
  OPEN assenze;
  END IF;
  IF d_conta_cursori = 3 THEN
  OPEN vacanti;
  END IF;
  LOOP
    IF d_conta_cursori = 1 THEN
    FETCH periodi INTO d_rilevanza,d_pegi_ore,
    d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
    d_popi_figura,d_figi_qualifica,d_popi_attivita,d_popi_settore,
    d_sett_sede,d_popi_sede_posto,d_popi_anno_posto,
    d_popi_numero_posto,d_popi_posto,
    d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
    d_pegi_assenza,d_pegi_dal,d_pegi_al,
    d_posi_ruolo,d_anag_gruppo_ling;
    EXIT WHEN periodi%NOTFOUND;
    END IF;
    IF d_conta_cursori = 2 THEN
    FETCH assenze INTO d_rilevanza,d_pegi_ore,
    d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
    d_popi_figura,d_figi_qualifica,d_popi_attivita,d_popi_settore,
    d_sett_sede,d_popi_sede_posto,d_popi_anno_posto,
    d_popi_numero_posto,d_popi_posto,
    d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
    d_pegi_assenza,d_pegi_dal,d_pegi_al,
    d_posi_ruolo,d_anag_gruppo_ling;
    EXIT WHEN assenze%NOTFOUND;
    END IF;
    IF d_conta_cursori = 3 THEN
    FETCH vacanti INTO d_rilevanza,d_pegi_ore,
    d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
    d_popi_figura,d_figi_qualifica,d_popi_attivita,d_popi_settore,
    d_sett_sede,d_popi_sede_posto,d_popi_anno_posto,
    d_popi_numero_posto,d_popi_posto,
    d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
    d_pegi_assenza,d_pegi_dal,d_pegi_al,
    d_posi_ruolo,d_anag_gruppo_ling;
    EXIT WHEN vacanti%NOTFOUND;
    END IF;
    d_cndo_mm_eta          := NULL;
    d_cndo_aa_eta          := NULL;
    d_cndo_gg_anz          := NULL;
    d_cndo_mm_anz          := NULL;
    d_cndo_aa_anz          := NULL;
    d_sett_sequenza        := NULL;
    d_sett_codice          := NULL;
    d_sett_suddivisione    := NULL;
    d_sett_settore_g       := NULL;
    d_setg_sequenza        := NULL;
    d_setg_codice          := NULL;
    d_sett_settore_a       := NULL;
    d_seta_sequenza        := NULL;
    d_seta_codice          := NULL;
    d_sett_settore_b       := NULL;
    d_setb_sequenza        := NULL;
    d_setb_codice          := NULL;
    d_sett_settore_c       := NULL;
    d_setc_sequenza        := NULL;
    d_setc_codice          := NULL;
    d_sett_gestione        := NULL;
    d_gest_prospetto_po    := NULL;
    d_gest_sintetico_po    := NULL;
    d_sedi_codice          := NULL;
    d_sedi_sequenza        := NULL;
    d_figi_dal             := NULL;
    d_figu_sequenza        := NULL;
    d_figi_codice          := NULL;
    d_qugi_dal             := NULL;
    d_qual_sequenza        := NULL;
    d_qugi_codice          := NULL;
    d_qugi_contratto       := NULL;
    d_cost_dal             := NULL;
    d_cont_sequenza        := NULL;
    d_cost_ore_lavoro      := NULL;
    d_qugi_livello         := NULL;
    d_figi_profilo         := NULL;
    d_prpr_sequenza        := NULL;
    d_prpr_suddivisione_po := NULL;
    d_figi_posizione       := NULL;
    d_pofu_sequenza        := NULL;
    d_qugi_ruolo           := NULL;
    d_ruol_sequenza        := NULL;
    d_popi_dal             := NULL;
    d_popi_gruppo          := NULL;
    d_popi_ore             := NULL;
    d_popi_pianta          := NULL;
    d_setp_codice          := NULL;
    d_setp_sequenza        := NULL;
   d_pegi_tp              := NULL;
   d_pegi_td              := NULL;
    d_cndo_ruolo           := NULL;
    d_cndo_incaricato      := NULL;
    d_cndo_mans_sup        := NULL;
    d_cndo_inc_td          := NULL;
    d_cndo_supplente       := NULL;
    d_cndo_inc_aq          := NULL;
    d_cndo_assente         := NULL;
    d_cndo_aspettativa     := NULL;
    d_cndo_univ            := NULL;
    d_cndo_vac_tit         := NULL;
    d_cndo_vac_disp        := NULL;
    d_cndo_sovr            := NULL;
    d_cndo_disp_supp       := NULL;
    IF  d_popi_sede_posto     IS NOT NULL
    AND d_popi_anno_posto     IS NOT NULL
    AND d_popi_numero_posto   IS NOT NULL
    AND d_popi_posto          IS NOT NULL THEN
       BEGIN
          SELECT dal
                ,gruppo
                ,pianta
                ,ore
                ,disponibilita
            INTO d_popi_dal
                ,d_popi_gruppo
                ,d_popi_pianta
                ,d_popi_ore
                ,d_popi_ricopribile
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
-- Copertura di dipendente di ruolo
       IF d_posi_ruolo = 'SI' AND d_pegi_rilevanza = 'Q' THEN
         d_cndo_ruolo := 1;
-- Dipendente di ruolo con incarico in altra qualifica
          BEGIN
          d_ore := NULL;
            SELECT NVL(SUM(NVL(PG.ORE,d_popi_ore)),0)
              INTO d_ore
              FROM POSIZIONI     PO
                  ,PERIODI_GIURIDICI    PG
             WHERE D_RIOR_DATA  BETWEEN PG.DAL
                                AND NVL(PG.AL,TO_DATE('3333333','J'))
               AND PG.RILEVANZA  = 'Q'
            AND pg.ci         = d_pegi_ci
               AND PO.RUOLO      = 'SI'
               AND PG.SEDE_POSTO = D_POPI_SEDE_POSTO
               AND PG.ANNO_POSTO = D_POPI_ANNO_POSTO
               AND PG.NUMERO_POSTO = D_POPI_NUMERO_POSTO
               AND PG.POSTO      = D_POPI_POSTO
               AND PO.CODICE     = PG.POSIZIONE
               AND EXISTS
                  (SELECT 1
                     FROM PERIODI_GIURIDICI P2
                    WHERE D_RIOR_DATA BETWEEN P2.DAL
                                      AND NVL(P2.AL,TO_DATE('3333333','J'))
                      AND P2.CI  = PG.CI
                      AND P2.RILEVANZA = 'I'
                      AND (    P2.SEDE_POSTO   <> D_POPI_SEDE_POSTO
                           OR  P2.ANNO_POSTO   <> D_POPI_ANNO_POSTO
                           OR  P2.NUMERO_POSTO <> D_POPI_NUMERO_POSTO
                           OR  P2.POSTO        <> D_POPI_POSTO
                          )
                      AND EXISTS
                         (SELECT 'x' 
                            FROM POSIZIONI
                           WHERE codice        = p2.posizione
                             AND ruolo         = 'SI'
                             AND di_ruolo      = 'F'
                         )
/*
                   AND EXISTS
                     (SELECT 'x'
                       FROM FIGURE_GIURIDICHE     FGPG
                           ,QUALIFICHE_GIURIDICHE QGPG
                           ,FIGURE_GIURIDICHE     FGP2
                           ,QUALIFICHE_GIURIDICHE QGP2
                           WHERE D_RIOR_DATA  BETWEEN FGPG.DAL
                                              AND NVL(FGPG.AL,TO_DATE('3333333','J'))
                        AND fgpg.numero    = pg.figura
                       AND fgpg.qualifica = qgpg.numero
                             AND D_RIOR_DATA  BETWEEN QGPG.DAL
                                              AND NVL(QGPG.AL,TO_DATE('3333333','J'))
                             AND D_RIOR_DATA  BETWEEN FGP2.DAL
                                              AND NVL(FGP2.AL,TO_DATE('3333333','J'))
                        AND fgp2.numero    = p2.figura
                       AND fgp2.qualifica = qgp2.numero
                             AND D_RIOR_DATA  BETWEEN QGP2.DAL
                                              AND NVL(QGP2.AL,TO_DATE('3333333','J'))
                       AND qgpg.ruolo     <> qgp2.ruolo
                    )
*/  
               )
          ;
          END;
          IF d_ore <> 0 THEN
             D_CNDO_INC_AQ := 1;
          END IF;
-- Dipendente di ruolo con mansioni superiori
          BEGIN
            SELECT NVL(SUM(NVL(PG.ORE,d_popi_ore)),0)
              INTO d_ore
              FROM POSIZIONI     PO
                  ,PERIODI_GIURIDICI    PG
             WHERE D_RIOR_DATA  BETWEEN PG.DAL
                                AND NVL(PG.AL,TO_DATE('3333333','J'))
               AND PG.RILEVANZA  = 'Q'
               AND PO.RUOLO      = 'SI'
            AND PG.CI         = d_pegi_ci
               AND PG.SEDE_POSTO = D_POPI_SEDE_POSTO
               AND PG.ANNO_POSTO = D_POPI_ANNO_POSTO
               AND PG.NUMERO_POSTO = D_POPI_NUMERO_POSTO
               AND PG.POSTO      = D_POPI_POSTO
               AND PO.CODICE     = PG.POSIZIONE
               AND EXISTS
                  (SELECT 1
                     FROM PERIODI_GIURIDICI P2
                    WHERE D_RIOR_DATA BETWEEN P2.DAL
                                      AND NVL(P2.AL,TO_DATE('3333333','J'))
                      AND P2.CI  = PG.CI
                      AND P2.RILEVANZA = 'I'
                      AND (    P2.SEDE_POSTO   <> D_POPI_SEDE_POSTO
                           OR  P2.ANNO_POSTO   <> D_POPI_ANNO_POSTO
                           OR  P2.NUMERO_POSTO <> D_POPI_NUMERO_POSTO
                           OR  P2.POSTO        <> D_POPI_POSTO
                          )
                      AND EXISTS
                         (SELECT 'x'
                            FROM POSIZIONI
                           WHERE codice        = p2.posizione
                             AND ruolo         = 'SI'
                             AND di_ruolo      = 'R'
                         )
               )
            ;
          END;
          IF d_ore <> 0 THEN
             d_cndo_mans_sup := 1;
            END IF;
       END IF;
      IF d_posi_ruolo = 'NO' THEN
-- Copertura di dipendente non di ruolo incaricato
          BEGIN
            d_ore := 0;
             SELECT NVL(SUM(NVL(PG.ORE,d_popi_ore)),0)
               INTO d_ore
               FROM POSIZIONI  PO
                   ,PERIODI_GIURIDICI PG
              WHERE D_RIOR_DATA  BETWEEN PG.DAL
                                 AND NVL(PG.AL,TO_DATE('3333333','J'))
                AND PO.CODICE       = PG.POSIZIONE
                AND PO.RUOLO        = 'NO'
                AND PG.RILEVANZA    = 'Q'
                AND pg.ci           = d_pegi_ci
                AND PG.SEDE_POSTO   = D_POPI_SEDE_POSTO
                AND PG.ANNO_POSTO   = D_POPI_ANNO_POSTO
                AND PG.NUMERO_POSTO = D_POPI_NUMERO_POSTO
                AND PG.POSTO        = D_POPI_POSTO
                AND NOT EXISTS
                   (SELECT 1
                      FROM PERIODI_GIURIDICI P3
                     WHERE D_RIOR_DATA BETWEEN P3.DAL
                                       AND NVL(P3.AL,TO_DATE('3333333','J'))
                       AND P3.CI = PG.CI
                       AND (    P3.RILEVANZA = 'I'
                            AND P3.ROWID <> PG.ROWID
                            OR  P3.RILEVANZA = 'A'
                            AND EXISTS
                               (SELECT 1
                                  FROM ASTENSIONI AA
                                 WHERE AA.SOSTITUIBILE = 1
                                   AND AA.CODICE  = P3.ASSENZA
                               )
                           )
                   )
                AND NOT EXISTS
                   (SELECT 1
                      FROM PERIODI_GIURIDICI P2
                      ,POSIZIONI         POSI
					/* vecchie condizioni
                     WHERE D_RIOR_DATA BETWEEN P2.DAL
                                       AND NVL(P2.AL,TO_DATE('3333333','J'))
					*/
                     WHERE pg.dal         <= NVL(p2.al,TO_DATE(3333333,'j'))
                       AND NVL(pg.al,TO_DATE(3333333,'j'))
                                          >= p2.dal
                       AND P2.CI          <> PG.CI
                       AND P2.SEDE_POSTO   = D_POPI_SEDE_POSTO
                       AND P2.ANNO_POSTO   = D_POPI_ANNO_POSTO
                       AND P2.NUMERO_POSTO = D_POPI_NUMERO_POSTO
                       AND P2.POSTO        = D_POPI_POSTO
                       AND POSI.CODICE     = P2.POSIZIONE
                       AND POSI.RUOLO      = 'SI'
                   )
             ;
          END;
          IF d_ore > 0 THEN
             D_CNDO_INCARICATO     := 1;
          END IF;
-- Copertura di dipendente supplente
          BEGIN
            d_ore := 0;
            SELECT NVL(SUM(NVL(PG.ORE,d_popi_ore)),0)
              INTO d_ore
              FROM POSIZIONI  PO
                  ,PERIODI_GIURIDICI PG
             WHERE D_RIOR_DATA  BETWEEN PG.DAL
                                AND NVL(PG.AL,TO_DATE('3333333','J'))
               AND PO.CODICE       = PG.POSIZIONE
               AND PO.RUOLO        = 'NO'
               AND PG.RILEVANZA    = 'Q'
               AND PG.SEDE_POSTO   = D_POPI_SEDE_POSTO
               AND PG.ANNO_POSTO   = D_POPI_ANNO_POSTO
               AND PG.NUMERO_POSTO = D_POPI_NUMERO_POSTO
               AND PG.POSTO        = D_POPI_POSTO
            AND pg.ci           = d_pegi_ci
               AND NOT EXISTS
                  (SELECT 1
                     FROM PERIODI_GIURIDICI P3
                    WHERE D_RIOR_DATA BETWEEN P3.DAL
                                      AND NVL(P3.AL,TO_DATE('3333333','J'))
                      AND P3.CI = PG.CI
                      AND (    P3.RILEVANZA = 'I'
                           AND P3.ROWID <> PG.ROWID
                           OR  P3.RILEVANZA = 'A'
                           AND EXISTS
                              (SELECT 1
                                 FROM ASTENSIONI AA
                                WHERE AA.SOSTITUIBILE = 1
                                  AND AA.CODICE  = P3.ASSENZA
                              )
                          )
                  )
               AND EXISTS
                  (SELECT 1
                     FROM PERIODI_GIURIDICI P2
                     ,POSIZIONI         POSI
					 /* vecchie condizioni di supplenza
                    WHERE D_RIOR_DATA BETWEEN P2.DAL
                                      AND NVL(P2.AL,TO_DATE('3333333','J'))
					 */
					WHERE pg.dal         <= NVL(p2.al,TO_DATE(3333333,'j'))
					  AND NVL(pg.al,TO_DATE(3333333,'j'))
					                     >= p2.dal
                      AND P2.CI          <> PG.CI
                      AND P2.SEDE_POSTO   = D_POPI_SEDE_POSTO
                      AND P2.ANNO_POSTO   = D_POPI_ANNO_POSTO
                      AND P2.NUMERO_POSTO = D_POPI_NUMERO_POSTO
                      AND P2.POSTO        = D_POPI_POSTO
                      AND POSI.CODICE     = P2.POSIZIONE
                      AND POSI.RUOLO      = 'SI'
                  AND EXISTS
                     (SELECT 1
                       FROM PERIODI_GIURIDICI P4
					   /* vecchie condizioni
                           WHERE D_RIOR_DATA BETWEEN P4.DAL
                                             AND NVL(P4.AL,TO_DATE('3333333','J'))
					   */
                           WHERE p4.dal         <= NVL(pg.al,TO_DATE(3333333,'j'))
					         AND NVL(p4.al,TO_DATE(3333333,'j'))
					                            >= pg.dal
                             AND P4.CI          <> P2.CI
                             AND (    P4.RILEVANZA = 'I'
                                  OR  P4.RILEVANZA = 'A'
                                  AND EXISTS
                                     (SELECT 1
                                        FROM ASTENSIONI AA
                                       WHERE AA.SOSTITUIBILE = 1
                                         AND AA.CODICE  = P4.ASSENZA
                              )
                                 )
                         )
                  )
            ;
          END;
          IF d_ore > 0 THEN
            d_cndo_supplente     := 1;
          END IF;
       END IF;
    END IF;
-- Dipendente di ruolo senza posto ( sovrannumerario )
   IF d_posi_ruolo = 'SI' AND d_pegi_rilevanza = 'Q' AND d_popi_posto IS NULL THEN
      d_cndo_sovr := 1;
   END IF;
-- Dipendente non di ruolo senza posto (straordinario o inc.t.d.)
   IF d_posi_ruolo = 'NO' AND d_pegi_rilevanza = 'Q' AND d_popi_posto IS NULL THEN
      d_cndo_inc_td := 1;
   END IF;
-- Dipendente universitario
   IF d_posi_ruolo = 'NO' AND d_pegi_rilevanza = 'Q' THEN
       d_ore := NULL;
      BEGIN
         SELECT 1
           INTO d_ore
           FROM FIGURE_GIURIDICHE fg
          WHERE fg.numero          = d_popi_figura
            AND d_rior_data BETWEEN fg.dal
                                AND NVL(fg.al,TO_DATE(3333333,'j'))
            AND EXISTS
 		      (SELECT 'x' FROM QUALIFICHE_GIURIDICHE qg
                 WHERE qg.numero          = fg.qualifica
                   AND d_rior_data BETWEEN qg.dal
                                       AND NVL(qg.al,TO_DATE(3333333,'j'))
				   AND qg.ruolo          = 'UNIV'
 			  )
		;
      EXCEPTION WHEN NO_DATA_FOUND THEN d_ore := NULL;
      END;
      IF d_ore > 0 THEN
          d_cndo_univ            := 1;
          d_cndo_ruolo           := NULL;
          d_cndo_incaricato      := NULL;
          d_cndo_mans_sup        := NULL;
          d_cndo_inc_td          := NULL;
          d_cndo_supplente       := NULL;
          d_cndo_inc_aq          := NULL;
          d_cndo_assente         := NULL;
          d_cndo_aspettativa     := NULL;
          d_cndo_vac_tit         := NULL;
          d_cndo_vac_disp        := NULL;
          d_cndo_sovr            := NULL;
          d_cndo_disp_supp       := NULL;
       END IF;
   END IF;
-- Dipendente con assenza sostituibile
    d_ore := NULL;
   IF d_rilevanza = '2' AND d_pegi_assenza IS NOT NULL THEN
      d_cndo_assente := 1;
-- Dipendente con apettativa non retribuita
       BEGIN
          SELECT per_ret
            INTO d_ore
           FROM ASTENSIONI
          WHERE codice = d_pegi_assenza
          ;
      END;
       IF d_ore = 0 THEN
         d_cndo_aspettativa := 1;
      END IF;
   END IF;
-- Posto vacante
    IF d_rilevanza = 3 THEN
      d_cndo_vac_tit := 1;
   END IF;
    BEGIN
       SELECT NVL(S.sequenza,999999),S.codice
             ,S.suddivisione,S.gestione,
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
    IF p_d_f = 'D' OR d_pegi_rilevanza IS NULL THEN
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
       BEGIN
          SELECT S.sede,d.codice,NVL(d.sequenza,999999)
            INTO d_sett_sede,d_sedi_codice,d_sedi_sequenza
            FROM SEDI       d
                ,SETTORI    S
           WHERE S.numero   = d_popi_settore
             AND S.sede     = d.numero (+)
          ;
       END;
      IF d_pegi_tipo_rapporto LIKE 'TP%'
      THEN
        d_pegi_tp := 1;
      END IF;
      IF d_pegi_tipo_rapporto LIKE 'TD%'
      THEN
        d_pegi_td := 1;
      END IF;
   END IF;
   IF p_d_f = 'F' AND d_pegi_rilevanza IS NOT NULL THEN
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
       IF d_pegi_rilevanza IS NULL THEN
          BEGIN
             SELECT S.sede,d.codice,NVL(d.sequenza,999999)
               INTO d_sett_sede,d_sedi_codice,d_sedi_sequenza
               FROM SEDI       d
                   ,SETTORI    S
              WHERE S.numero   = d_popi_settore
                AND S.sede     = d.numero (+)
             ;
          END;
       ELSE
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
    IF NVL(d_pegi_rilevanza,' ') <> 'A' THEN
       CALCOLO_ETA_ANZIANITA(d_pegi_ci,d_cndo_mm_eta,d_cndo_aa_eta,
                             d_cndo_gg_anz,d_cndo_mm_anz,d_cndo_aa_anz
                            );
    END IF;
    INSERT INTO CALCOLO_NOMINATIVO_DOTAZIONE
    (cndo_prenotazione,cndo_rilevanza,rior_data,
     popi_sede_posto,popi_anno_posto,popi_numero_posto,popi_posto,
     popi_gruppo,popi_dal,popi_ricopribile,popi_pianta,
     setp_sequenza,setp_codice,popi_settore,sett_sequenza,
     sett_codice,sett_suddivisione,sett_settore_g,setg_sequenza,
     setg_codice,sett_settore_a,seta_sequenza,seta_codice,
     sett_settore_b,setb_sequenza,setb_codice,sett_settore_c,
     setc_sequenza,setc_codice,sett_gestione,gest_prospetto_po,
     gest_sintetico_po,sett_sede,sedi_codice,sedi_sequenza,
     popi_figura,figi_dal,figu_sequenza,
     figi_codice,figi_qualifica,qugi_dal,qual_sequenza,qugi_codice,
     qugi_contratto,cost_dal,cont_sequenza,cost_ore_lavoro,
     qugi_livello,figi_profilo,prpr_sequenza,prpr_suddivisione_po,
     figi_posizione,pofu_sequenza,qugi_ruolo,ruol_sequenza,
     popi_attivita,atti_sequenza,pegi_posizione,posi_sequenza,
     pegi_tipo_rapporto,pegi_ci,pegi_sostituto,pegi_rilevanza,pegi_ore,
     pegi_assenza,pegi_gruppo_ling,cndo_mm_eta,cndo_aa_eta,
     cndo_gg_anz,cndo_mm_anz,cndo_aa_anz,cndo_dal,cndo_al,
     popi_sede_posto_inc,popi_anno_posto_inc,popi_numero_posto_inc,
     popi_posto_inc,CNDO_TP,CNDO_TD,CNDO_RUOLO,CNDO_INCARICATO,
     CNDO_MANS_SUP,CNDO_INC_TD,CNDO_SUPPLENTE,CNDO_INC_AQ,CNDO_ASSENTE,
     CNDO_ASPETTATIVA,CNDO_UNIV,CNDO_VAC_TIT,CNDO_SOVR
   )
    VALUES
    (p_prenotazione,d_rilevanza,d_rior_data,
     d_popi_sede_posto,d_popi_anno_posto,
     d_popi_numero_posto,d_popi_posto,
     d_popi_gruppo,d_popi_dal,d_popi_ricopribile,d_popi_pianta,
     d_setp_sequenza,d_setp_codice,d_popi_settore,d_sett_sequenza,
     d_sett_codice,d_sett_suddivisione,
     d_sett_settore_g,d_setg_sequenza,
     d_setg_codice,d_sett_settore_a,d_seta_sequenza,d_seta_codice,
     d_sett_settore_b,d_setb_sequenza,d_setb_codice,d_sett_settore_c,
     d_setc_sequenza,d_setc_codice,d_sett_gestione,d_gest_prospetto_po,
     d_gest_sintetico_po,d_sett_sede,d_sedi_codice,d_sedi_sequenza,
     d_popi_figura,d_figi_dal,d_figu_sequenza,
     d_figi_codice,d_figi_qualifica,d_qugi_dal,
     d_qual_sequenza,d_qugi_codice,
     d_qugi_contratto,d_cost_dal,d_cont_sequenza,d_cost_ore_lavoro,
     d_qugi_livello,d_figi_profilo,
     d_prpr_sequenza,d_prpr_suddivisione_po,
     d_figi_posizione,d_pofu_sequenza,d_qugi_ruolo,d_ruol_sequenza,
     d_popi_attivita,d_atti_sequenza,d_pegi_posizione,d_posi_sequenza,
     d_pegi_tipo_rapporto,d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
     NVL(d_pegi_ore,NVL(d_popi_ore,d_cost_ore_lavoro)),
     d_pegi_assenza,d_anag_gruppo_ling,d_cndo_mm_eta,d_cndo_aa_eta,
     d_cndo_gg_anz,d_cndo_mm_anz,d_cndo_aa_anz,d_pegi_dal,d_pegi_al,
     d_popi_sede_posto_inc,d_popi_anno_posto_inc,
     d_popi_numero_posto_inc,d_popi_posto_inc,d_pegi_TP,d_pegi_TD,
    d_CNDO_RUOLO,d_CNDO_INCARICATO,d_CNDO_MANS_SUP,d_CNDO_INC_TD,
    d_CNDO_SUPPLENTE,d_CNDO_INC_AQ,d_CNDO_ASSENTE,
     d_CNDO_ASPETTATIVA,d_CNDO_UNIV,d_CNDO_VAC_TIT,d_CNDO_SOVR)
    ;
  END LOOP;
  IF d_conta_cursori = 1 THEN
  CLOSE periodi;
  END IF;
  IF d_conta_cursori = 2 THEN
  CLOSE assenze;
  END IF;
  IF d_conta_cursori = 3 THEN
  CLOSE vacanti;
  END IF;
  END LOOP;
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
END;
/

