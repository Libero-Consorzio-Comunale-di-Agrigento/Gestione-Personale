CREATE OR REPLACE PACKAGE pgmcevpa IS
  /******************************************************************************
   NOME:          PGMCEVPA
   DESCRIZIONE:
   ARGOMENTI:
   RITORNA:
   ECCEZIONI:
   ANNOTAZIONI:
   REVISIONI:
   Rev. Data       Autore Descrizione
   ---- ---------- ------ --------------------------------------------------------
   1    30/06/2000
   1.1  03/07/2006 CB     Modifica campo evento - attivita 14612
   1.2  03/07/2006 MM     Attivita 18200
  
  ******************************************************************************/
  s_gestione gestioni.codice%TYPE := '%';
  FUNCTION versione RETURN VARCHAR2;
  PROCEDURE main
  (
    prenotazione IN NUMBER
   ,passo        IN NUMBER
  );
END;
/
CREATE OR REPLACE PACKAGE BODY pgmcevpa IS
  form_trigger_failure EXCEPTION;
  w_utente       VARCHAR2(10);
  w_ambiente     VARCHAR2(10);
  w_ente         VARCHAR2(10);
  w_lingua       VARCHAR2(1);
  w_prenotazione NUMBER(10);
  FUNCTION versione RETURN VARCHAR2 IS
  BEGIN
    RETURN 'V1.0 del 20/01/2003';
  END versione;
  PROCEDURE chk_copertura_posto
  (
    p_dal    IN DATE
   ,p_al     IN DATE
   ,p_sede   IN VARCHAR2
   ,p_numero IN NUMBER
   ,p_anno   IN NUMBER
   ,p_posto  IN NUMBER
   ,p_rowid  IN VARCHAR2
  ) IS
    nonok EXCEPTION;
  BEGIN
    IF p_sede IS NOT NULL AND p_numero IS NOT NULL AND p_anno IS NOT NULL AND p_posto IS NOT NULL
    THEN
      BEGIN
        DECLARE
          d_ci          NUMBER(8);
          d_ci_ass      NUMBER(8);
          d_dal_periodo DATE;
          d_dal         DATE;
          d_dal_ass     DATE;
          d_al_periodo  DATE;
          d_al          DATE;
          d_al_ass      DATE;
          d_al_prec     DATE;
          d_cont        NUMBER(1);
          d_data_prec   DATE;
          d_data_att    DATE;
          d_nota_prec   VARCHAR2(3);
          d_nota_att    VARCHAR2(3);
          CURSOR pegi_periodi IS
            SELECT greatest(p_dal, pegi.dal)
                  ,'DAL'
              FROM periodi_giuridici pegi
             WHERE pegi.dal <= nvl(p_al, to_date('3333333', 'j'))
               AND nvl(pegi.al, to_date('3333333', 'j')) >= p_dal
               AND pegi.sede_posto = p_sede
               AND pegi.anno_posto = p_anno
               AND pegi.numero_posto = p_numero
               AND pegi.posto = p_posto
               AND pegi.rilevanza IN ('Q', 'I')
            UNION
            SELECT least(nvl(p_al, to_date('3333333', 'j')), nvl(pegi.al, to_date('3333333', 'j')))
                  ,'AL'
              FROM periodi_giuridici pegi
             WHERE pegi.dal <= nvl(p_al, to_date('3333333', 'j'))
               AND nvl(pegi.al, to_date('3333333', 'j')) >= p_dal
               AND pegi.sede_posto = p_sede
               AND pegi.anno_posto = p_anno
               AND pegi.numero_posto = p_numero
               AND pegi.posto = p_posto
               AND pegi.rilevanza IN ('Q', 'I')
             ORDER BY 1;
          CURSOR pegi_qi IS
            SELECT pegi.ci
                  ,greatest(pegi.dal, d_dal_periodo)
                  ,least(nvl(pegi.al, to_date('3333333', 'j')), nvl(d_al_periodo, to_date('3333333', 'j')))
              FROM periodi_giuridici pegi
             WHERE pegi.sede_posto = p_sede
               AND pegi.numero_posto = p_numero
               AND pegi.anno_posto = p_anno
               AND pegi.posto = p_posto
               AND pegi.rilevanza IN ('Q', 'I')
               AND pegi.dal <= nvl(d_al_periodo, to_date('3333333', 'j'))
               AND nvl(pegi.al, to_date('3333333', 'j')) >= d_dal_periodo
             ORDER BY pegi.dal;
          CURSOR pegi_ai IS
            SELECT pegi2.ci
                  ,greatest(pegi2.dal, d_dal_periodo)
                  ,least(nvl(pegi2.al, to_date('3333333', 'j')), nvl(d_al_periodo, to_date('3333333', 'j')))
              FROM periodi_giuridici pegi2
             WHERE pegi2.ci = d_ci
               AND pegi2.dal <= nvl(d_al, to_date('3333333', 'j'))
               AND nvl(pegi2.al, to_date('3333333', 'j')) >= d_dal
               AND (pegi2.rilevanza = 'I' AND
                   (nvl(pegi2.sede_posto, ' ') != p_sede OR nvl(pegi2.numero_posto, 0) != p_numero OR
                   nvl(pegi2.anno_posto, 0) != p_anno OR nvl(pegi2.posto, 0) != p_posto) OR
                   pegi2.rilevanza = 'A' AND EXISTS (SELECT 'x'
                                                       FROM astensioni
                                                      WHERE codice = pegi2.assenza
                                                        AND sostituibile = 1))
             ORDER BY pegi2.dal;
        BEGIN
          OPEN pegi_periodi;
          FETCH pegi_periodi
            INTO d_data_prec, d_nota_prec;
          IF pegi_periodi%FOUND
          THEN
            LOOP
              FETCH pegi_periodi
                INTO d_data_att, d_nota_att;
              EXIT WHEN pegi_periodi%NOTFOUND;
              IF d_nota_prec = 'DAL'
              THEN
                IF d_nota_att = 'DAL'
                THEN
                  d_dal_periodo := d_data_prec;
                  d_al_periodo  := d_data_att - 1;
                ELSE
                  d_dal_periodo := d_data_prec;
                  d_al_periodo  := d_data_att;
                END IF;
              ELSE
                IF d_nota_att = 'DAL'
                THEN
                  d_dal_periodo := d_data_prec + 1;
                  d_al_periodo  := d_data_att - 1;
                ELSE
                  d_dal_periodo := d_data_prec + 1;
                  d_al_periodo  := d_data_att;
                END IF;
              END IF;
              d_data_prec := d_data_att;
              d_nota_prec := d_nota_att;
              d_cont      := 0;
              OPEN pegi_qi;
              LOOP
                FETCH pegi_qi
                  INTO d_ci, d_dal, d_al;
                EXIT WHEN pegi_qi%NOTFOUND;
                OPEN pegi_ai;
                d_al_prec := d_dal - 1;
                LOOP
                  FETCH pegi_ai
                    INTO d_ci_ass, d_dal_ass, d_al_ass;
                  IF pegi_ai%NOTFOUND
                  THEN
                    IF d_al_prec = nvl(d_al, to_date('3333333', 'j'))
                    THEN
                      EXIT;
                    ELSE
                      IF d_cont = 0
                      THEN
                        d_cont := 1;
                        EXIT;
                      ELSE
                        CLOSE pegi_ai;
                        CLOSE pegi_qi;
                        CLOSE pegi_periodi;
                        RAISE nonok;
                      END IF;
                    END IF;
                  ELSE
                    IF d_al_prec < d_dal_ass - 1
                    THEN
                      IF d_cont = 0
                      THEN
                        d_cont := 1;
                        EXIT;
                      ELSE
                        CLOSE pegi_ai;
                        CLOSE pegi_qi;
                        CLOSE pegi_periodi;
                        RAISE nonok;
                      END IF;
                    ELSE
                      d_al_prec := nvl(d_al_ass, to_date('3333333', 'j'));
                    END IF;
                  END IF;
                END LOOP;
                CLOSE pegi_ai;
              END LOOP;
              CLOSE pegi_qi;
            END LOOP;
          END IF;
          CLOSE pegi_periodi;
        END;
      END;
    END IF;
  EXCEPTION
    WHEN nonok THEN
      RAISE form_trigger_failure;
    WHEN OTHERS THEN
      RAISE form_trigger_failure;
  END;
  -- Errore bloccante
  PROCEDURE registra_errore(p_errore IN VARCHAR2) IS
  BEGIN
    ROLLBACK;
    UPDATE a_prenotazioni
       SET errore         = p_errore
          ,prossimo_passo = 99
     WHERE no_prenotazione = w_prenotazione;
    COMMIT;
  END;
  PROCEDURE controllo IS
    fine_step EXCEPTION;
    d_errore             NUMBER(2);
    d_comodo             VARCHAR2(1);
    d_dep_variabili_gape NUMBER(1);
    d_dep_periodo_ggpe   VARCHAR2(1);
    d_anno               NUMBER(4);
    d_mese               NUMBER(2);
    d_mensilita          VARCHAR2(3);
    d_ini_ela            DATE;
    d_fin_ela            DATE;
    d_ci                 NUMBER(8);
    d_assenza            deposito_eventi_presenza.assenza%TYPE;
    d_sostituibile       NUMBER(1);
    d_confermato         NUMBER(1);
    d_assenza_prec       periodi_giuridici.assenza%TYPE;
    d_sostituibile_prec  NUMBER(1);
    d_confermato_prec    NUMBER(1);
    d_data               DATE;
    d_operazione         VARCHAR2(1);
    d_dal                DATE;
    d_al                 DATE;
    d_dal_prec           DATE;
    d_al_prec            DATE;
    d_ini_periodo        DATE;
    d_fin_periodo        DATE;
    d_ini_periodo2       DATE;
    d_fin_periodo2       DATE;
    d_utente             VARCHAR2(8);
    d_data_agg           DATE;
    d_evento             VARCHAR2(6);
    d_sede_del           VARCHAR2(2);
    d_anno_del           NUMBER(4);
    d_numero_del         NUMBER(7);
    d_delibera           VARCHAR2(2);
    d_unico              VARCHAR2(2);
    d_mat_anz            NUMBER(1);
    d_sede_posto         VARCHAR2(2);
    d_anno_posto         NUMBER(4);
    d_numero_posto       NUMBER(7);
    d_posto              NUMBER(4);
    d_incentivi          VARCHAR2(2);
    d_data_ragi          DATE;
    d_economica          VARCHAR2(2);
    d_pianta_organica    VARCHAR2(2);
    d_rowid              VARCHAR2(30);
    p_gestione           VARCHAR2(4);
    CURSOR depa IS
      SELECT depa.ci
            ,depa.assenza
            ,depa.data
            ,depa.operazione
            ,depa.dal
            ,depa.al
            ,depa.sede
            ,depa.anno
            ,depa.numero
            ,depa.utente
            ,depa.data_agg
        FROM deposito_eventi_presenza depa
       WHERE depa.operazione != 'C'
         AND depa.rilevanza IN ('R', 'P')
         AND EXISTS (SELECT ragi.ci
                FROM rapporti_giuridici ragi
               WHERE gestione LIKE s_gestione)
      
       ORDER BY depa.data_agg
               ,depa.assenza
               ,depa.ci
               ,depa.data
               ,depa.operazione;
    CURSOR posti IS
      SELECT pegi.sede_posto
            ,pegi.anno_posto
            ,pegi.numero_posto
            ,pegi.posto
        FROM periodi_giuridici pegi
       WHERE pegi.sede_posto IS NOT NULL
         AND pegi.anno_posto IS NOT NULL
         AND pegi.numero_posto IS NOT NULL
         AND pegi.posto IS NOT NULL
         AND pegi.ci = d_ci
         AND pegi.dal <= nvl(d_fin_periodo, to_date('3333333', 'j'))
         AND nvl(pegi.al, to_date('3333333', 'j')) >= nvl(d_ini_periodo, to_date('2222222', 'j'))
       ORDER BY pegi.sede_posto
               ,pegi.anno_posto
               ,pegi.numero_posto
               ,pegi.posto;
  BEGIN
    /*
     Memorizzazione variabili e indicatori di gestione della
     tabella  ENTE.
    */
    BEGIN
      SELECT nvl(ente.variabili_gape, 0) * -1
            ,nvl(ente.periodo_ggpe, 'T')
            ,ente.incentivazione
            ,ente.economica
            ,ente.pianta_organica
        INTO d_dep_variabili_gape
            ,d_dep_periodo_ggpe
            ,d_incentivi
            ,d_economica
            ,d_pianta_organica
        FROM ente
       WHERE ente.ente_id = 'ENTE';
    EXCEPTION
      WHEN too_many_rows THEN
        registra_errore('A00003');
        RAISE fine_step;
      WHEN no_data_found THEN
        /* Manca integrazione tra sottosistemi */
        registra_errore('P00531');
        RAISE fine_step;
    END;
    /*
     Se prevista la gestione economica si memorizzano i dati
     del periodo di riferimento dal riferimento retribuzione,
     altrimenti, se prevista, si memorizzano i suddetti dati
     dal riferimento per l' incentivazione, altrimenti si e-
     samina il riferimento giuridico.
    */
    IF d_economica = 'SI'
    THEN
      BEGIN
        SELECT anno
              ,mese
              ,ini_ela
              ,fin_ela
          INTO d_anno
              ,d_mese
              ,d_ini_ela
              ,d_fin_ela
          FROM riferimento_retribuzione
         WHERE rire_id = 'RIRE';
      EXCEPTION
        WHEN too_many_rows THEN
          registra_errore('A00003');
          RAISE fine_step;
        WHEN no_data_found THEN
          /* Riferimento Retribuzione non presente */
          registra_errore('P05140');
          RAISE fine_step;
      END;
      --  ELSIF
      -- d_incentivi = 'SI' THEN
      -- BEGIN
      --  SELECT  anno,mese,ini_mes,fin_mes
      --  INTO  d_anno,d_mese,d_ini_ela,d_fin_ela
      --  FROM  RIFERIMENTO_INCENTIVO
      -- WHERE  riip_id = 'RIIP'
      --   ;
      -- EXCEPTION
      --   WHEN TOO_MANY_ROWS THEN
      --  REGISTRA_ERRORE('A00003');
      --  RAISE FINE_STEP;
      --   WHEN NO_DATA_FOUND THEN
      --  /* Riferimento Incentivazione non presente */
      --  REGISTRA_ERRORE('P06000');
      --  RAISE FINE_STEP;
      -- END;
    ELSE
      BEGIN
        SELECT anno
              ,mese
              ,ini_mes
              ,fin_mes
          INTO d_anno
              ,d_mese
              ,d_ini_ela
              ,d_fin_ela
          FROM riferimento_giuridico;
      EXCEPTION
        WHEN too_many_rows THEN
          registra_errore('A00003');
          RAISE fine_step;
        WHEN no_data_found THEN
          /* Riferimento Giuridico non presente */
          registra_errore('P04540');
          RAISE fine_step;
      END;
    END IF;
    /*
     Aggiornamento operazione su Deposito Eventi Presenza per
     le registrazioni non ancora trattate se il trattamento e`
     a riferimento.
    */
    BEGIN
      UPDATE deposito_eventi_presenza
         SET operazione = 'U'
       WHERE operazione = 'C'
         AND rilevanza IN ('R', 'P');
    END;
    /*
      +---------------- Loop controlli ed elaborazioni -----------+
    */
    BEGIN
      OPEN depa;
      LOOP
        /*
        Controlli di integrita` relazionale
        */
        FETCH depa
          INTO d_ci, d_assenza, d_data, d_operazione, d_dal, d_al, d_sede_del, d_anno_del, d_numero_del, d_utente, d_data_agg;
        EXIT WHEN depa%NOTFOUND;
        IF (d_dep_periodo_ggpe = 'T' -- Trattamento Totale
           OR d_dep_periodo_ggpe = 'R' -- Trattamento a Riferimento
           AND d_data <= add_months(d_dep_variabili_gape, d_fin_ela))
        THEN
          d_errore := 0;
          /*
           Normalizzazione data al per gestione a riferimento.
          */
          IF d_dep_periodo_ggpe = 'R'
          THEN
            d_al := least(nvl(d_al, to_date('3333333', 'j')), add_months(d_fin_ela, d_dep_variabili_gape));
          END IF;
          /*
           Controllo Dizionario Astensioni
          */
          IF d_errore = 0
          THEN
            BEGIN
              SELECT aste.evento
                    ,aste.mat_anz
                    ,aste.sostituibile
                    ,aste.conferma
                INTO d_evento
                    ,d_mat_anz
                    ,d_sostituibile
                    ,d_confermato
                FROM astensioni aste
               WHERE aste.codice = d_assenza;
            EXCEPTION
              WHEN too_many_rows THEN
                registra_errore('A00003');
                RAISE fine_step;
              WHEN no_data_found THEN
                d_errore := 1;
                /* Evento di assenza non codificato */
            END;
          END IF; -- Fine IF su d_errore se = 0
          /* Controllo Dizionario Eventi Giuridici  */
          IF d_errore = 0
          THEN
            BEGIN
              SELECT evgi.delibera
                    ,evgi.unico
                INTO d_delibera
                    ,d_unico
                FROM eventi_giuridici evgi
               WHERE evgi.codice = d_evento;
            EXCEPTION
              WHEN too_many_rows THEN
                registra_errore('A00003');
                RAISE fine_step;
              WHEN no_data_found THEN
                d_errore := 2;
                /* Evento giuridico non codificato */
            END;
          END IF; -- Fine IF su d_errore se = 0
          /*
           Controllo Unicita` dell' evento.
          */
          IF d_errore = 0
          THEN
            IF d_unico = 'SI' AND d_al IS NULL
            THEN
              d_errore := 3;
              /* Data Al obbligatoria in Evento Unico */
            END IF;
          END IF; -- Fine IF su d_errore se = 0
          /*
           Controllo obbligatorieta` della delibera sull' evento.
          */
          IF d_errore = 0
          THEN
            IF d_sede_del || to_char(d_anno_del) || to_char(d_numero_del) IS NOT NULL AND d_delibera != 'SI' OR
               d_sede_del || to_char(d_anno_del) || to_char(d_numero_del) IS NULL AND d_delibera = 'SI'
            THEN
              d_errore := 4;
              /* Incongruenza tra evento e provvedimento deliberativo */
            END IF;
          END IF; -- Fine IF su d_errore se = 0
          /*
           Controllo Esistenza Periodo di Inquadramento
          */
          IF d_errore = 0
          THEN
            BEGIN
              SELECT 'x'
                INTO d_comodo
                FROM periodi_giuridici pegi
               WHERE pegi.rilevanza = 'Q'
                 AND pegi.ci = d_ci
                 AND pegi.dal <= d_dal
                 AND nvl(pegi.al, to_date('3333333', 'j')) >= d_al;
            EXCEPTION
              WHEN too_many_rows THEN
                registra_errore('A00003');
                RAISE fine_step;
              WHEN no_data_found THEN
                d_errore := 5;
                /* Manca periodo di inquadramento */
            END;
          END IF; -- Fine IF su d_errore se = 0
          /*
           Controllo Esistenza Periodo da Modificare o Eliminare
          */
          IF d_errore = 0
          THEN
            IF d_operazione IN ('U', 'D')
            THEN
              BEGIN
                SELECT pegi.dal
                      ,pegi.al
                      ,pegi.assenza
                      ,aste.sostituibile
                      ,pegi.ROWID
                  INTO d_dal_prec
                      ,d_al_prec
                      ,d_assenza_prec
                      ,d_sostituibile_prec
                      ,d_rowid
                  FROM astensioni        aste
                      ,periodi_giuridici pegi
                 WHERE pegi.rilevanza = 'A'
                   AND pegi.ci = d_ci
                   AND pegi.dal = d_data
                   AND aste.codice = pegi.assenza;
              EXCEPTION
                WHEN too_many_rows THEN
                  registra_errore('A00003');
                  RAISE fine_step;
                WHEN no_data_found THEN
                  d_errore := 6;
                  /* Manca periodo da aggiornare o eliminare */
              END;
            END IF;
          END IF; -- Fine IF su d_errore se = 0
          /*
           Controllo intersezione periodi di assenza
          */
          IF d_errore = 0
          THEN
            IF d_operazione IN ('U', 'I')
            THEN
              BEGIN
                SELECT 'x'
                  INTO d_comodo
                  FROM periodi_giuridici pegi
                 WHERE pegi.rilevanza = 'A'
                   AND pegi.ci = d_ci
                   AND (pegi.dal != d_data AND d_operazione = 'U' OR d_operazione = 'I')
                   AND nvl(pegi.al, to_date('3333333', 'j')) >= d_dal
                   AND pegi.dal <= d_al;
                RAISE too_many_rows;
              EXCEPTION
                WHEN no_data_found THEN
                  NULL;
                WHEN too_many_rows THEN
                  d_errore := 7;
                  /* Intersezione tra Assenze dello stesso individuo */
              END;
            END IF;
          END IF; -- Fine IF su d_errore se = 0
          /*
           Controllo Copertura Posti di Pianta Organica limitatamen-
           te ai periodi di assenza non piu` validi dopo la elimina-
           zione o la variazione del periodo.
          */
          IF d_errore = 0
          THEN
            IF d_pianta_organica = 'SI'
            THEN
              BEGIN
                d_ini_periodo  := NULL;
                d_fin_periodo  := NULL;
                d_ini_periodo2 := NULL;
                d_fin_periodo2 := NULL;
                IF d_operazione = 'U' AND d_sostituibile = 0 AND d_sostituibile_prec = 1 OR
                   d_operazione = 'D'
                THEN
                  d_ini_periodo := d_dal_prec;
                  d_fin_periodo := d_al_prec;
                END IF;
                IF d_operazione = 'U' AND
                   (nvl(d_al, to_date('3333333', 'j')) < nvl(d_dal_prec, to_date('2222222', 'j')) OR
                   nvl(d_dal, to_date('2222222', 'j')) > nvl(d_al_prec, to_date('3333333', 'j'))) AND
                   d_sostituibile_prec = 1 AND d_sostituibile = 1
                THEN
                  d_ini_periodo := d_dal_prec;
                  d_fin_periodo := d_al_prec;
                END IF;
                IF d_operazione = 'U' AND d_sostituibile_prec = 1 AND d_sostituibile = 1 AND
                   d_dal BETWEEN nvl(d_dal_prec, to_date('2222222', 'j')) AND
                   nvl(d_al_prec, to_date('3333333', 'j')) AND
                   nvl(d_al_prec, to_date('3333333', 'j')) > nvl(d_al, to_date('3333333', 'j'))
                THEN
                  d_ini_periodo := nvl(d_al + 1, to_date('3333333', 'j'));
                  d_fin_periodo := nvl(d_al_prec, to_date('3333333', 'j'));
                END IF;
                IF d_operazione = 'U' AND d_sostituibile_prec = 1 AND d_sostituibile = 1 AND
                   nvl(d_al, to_date('3333333', 'j')) BETWEEN nvl(d_dal_prec, to_date('2222222', 'j')) AND
                   nvl(d_al_prec, to_date('3333333', 'j')) AND
                   nvl(d_dal_prec, to_date('2222222', 'j')) < nvl(d_dal, to_date('2222222', 'j'))
                THEN
                  d_ini_periodo2 := nvl(d_dal_prec, to_date('2222222', 'j'));
                  d_fin_periodo2 := nvl(d_dal - 1, to_date('2222222', 'j'));
                END IF;
                IF (d_ini_periodo IS NOT NULL OR d_fin_periodo IS NOT NULL) AND
                   nvl(d_ini_periodo, to_date('2222222', 'j')) <= nvl(d_fin_periodo, to_date('3333333', 'j')) OR
                   (d_ini_periodo2 IS NOT NULL OR d_fin_periodo2 IS NOT NULL) AND
                   nvl(d_ini_periodo2, to_date('2222222', 'j')) <=
                   nvl(d_fin_periodo2, to_date('3333333', 'j'))
                THEN
                  OPEN posti;
                  LOOP
                    FETCH posti
                      INTO d_sede_posto, d_anno_posto, d_numero_posto, d_posto;
                    EXIT WHEN posti%NOTFOUND;
                    BEGIN
                      IF (d_ini_periodo IS NOT NULL OR d_fin_periodo IS NOT NULL) AND
                         nvl(d_ini_periodo, to_date('2222222', 'j')) <=
                         nvl(d_fin_periodo, to_date('3333333', 'j'))
                      THEN
                        chk_copertura_posto(d_ini_periodo, d_fin_periodo, d_sede_posto, d_numero_posto, d_anno_posto, d_posto, d_rowid);
                      END IF;
                      IF (d_ini_periodo2 IS NOT NULL OR d_fin_periodo2 IS NOT NULL) AND
                         nvl(d_ini_periodo2, to_date('2222222', 'j')) <=
                         nvl(d_fin_periodo2, to_date('3333333', 'j'))
                      THEN
                        chk_copertura_posto(d_ini_periodo2, d_fin_periodo2, d_sede_posto, d_numero_posto, d_anno_posto, d_posto, d_rowid);
                      END IF;
                    EXCEPTION
                      WHEN too_many_rows THEN
                        CLOSE posti;
                        RAISE too_many_rows;
                    END;
                  END LOOP;
                  CLOSE posti;
                END IF;
              EXCEPTION
                WHEN too_many_rows THEN
                  d_errore := 8;
                  /* Posti coperti da piu` individui contemporaneamente */
              END;
            END IF; -- Fine IF su gestione di Pianta Organica
          END IF; -- Fine IF su d_errore se = 0
          IF d_errore = 0
          THEN
            /*
            In assenza di errori, viene eseguita l' operazione indi-
            cata sui periodi giuridici.
            */
            IF d_operazione = 'I'
            THEN
              -- >>> INSERIMENTO <<< --
              INSERT INTO periodi_giuridici
                (ci
                ,rilevanza
                ,dal
                ,al
                ,evento
                ,assenza
                ,confermato
                ,utente
                ,data_agg
                ,note)
                SELECT d_ci
                      ,'A'
                      ,d_dal
                      ,decode(d_dep_periodo_ggpe, 'T', d_al, decode(least(nvl(d_al, to_date('3333333', 'j')), add_months(d_fin_ela, d_dep_variabili_gape)), to_date('3333333', 'j'), to_date(NULL), least(nvl(d_al, to_date('3333333', 'j')), add_months(d_fin_ela, d_dep_variabili_gape))))
                      ,d_evento
                      ,d_assenza
                      ,1
                      ,d_utente
                      ,to_date(to_char(SYSDATE, 'ddmmyyyy'), 'ddmmyyyy')
                      ,'[Caricamento da Presenze/Assenze]'
                  FROM dual;
              d_data_ragi := d_dal;
            ELSIF d_operazione = 'U'
            THEN
              -- >>> AGGIORNAMENTO <<< --
              UPDATE periodi_giuridici pegi
                 SET (pegi.dal, pegi.al, pegi.utente, pegi.data_agg, pegi.evento, pegi.assenza) = (SELECT d_dal
                                                                                                         ,decode(d_dep_periodo_ggpe, 'T', d_al, decode(least(nvl(d_al, to_date('3333333', 'j')), add_months(d_fin_ela, d_dep_variabili_gape)), to_date('3333333', 'j'), to_date(NULL), least(nvl(d_al, to_date('3333333', 'j')), add_months(d_fin_ela, d_dep_variabili_gape))))
                                                                                                         ,d_utente
                                                                                                         ,to_date(to_char(SYSDATE, 'ddmmyyyy'), 'ddmmyyyy')
                                                                                                         ,d_evento
                                                                                                         ,d_assenza
                                                                                                     FROM dual)
               WHERE pegi.ci = d_ci
                 AND pegi.rilevanza = 'A'
                 AND pegi.dal = d_data;
              d_data_ragi := d_data;
            ELSIF d_operazione = 'D'
            THEN
              -- >>> ELIMINAZIONE <<< --
              DELETE FROM periodi_giuridici pegi
               WHERE pegi.ci = d_ci
                 AND pegi.rilevanza = 'A'
                 AND pegi.dal = d_data;
              d_data_ragi := d_dal;
            END IF;
            IF SQL%FOUND
            THEN
              /* Se l' operazione sui Periodi Giuridici e` stata eseguita,
              si attualizzano gli indicatori su Rapporti Giuridici.
              */
              UPDATE rapporti_giuridici ragi
                 SET ragi.d_cong    = least(nvl(ragi.d_cong, to_date('3333333', 'j')), to_date('01' ||
                                                     to_char(d_data_ragi, 'mmyyyy'), 'ddmmyyyy'))
                    ,ragi.d_inqe    = decode(d_mat_anz, '0', least(nvl(ragi.d_inqe, to_date('3333333', 'j')), d_dal), ragi.d_inqe)
                    ,ragi.flag_inqe = decode(d_mat_anz, '0', 'A', ragi.flag_inqe)
               WHERE ragi.ci = d_ci;
              /* Se per l'individuo in esame esistono periodi di assenza
               da confermare si pone il flag elab = 'A' per bloccare il
                 calcolo dell'individuo.
                 update rapporti_giuridici ragi
                 set ragi.flag_elab   = 'A'
               where not exists
                  (select 'x'
                  from periodi_giuridici pegi
                 where pegi.ci  = d_ci
                and pegi.rilevanza = 'A'
                and pegi.confermato   = 0
                  )
                 and ragi.ci = d_ci
                 ;
              */
              /* Se l' operazione sui Periodi Giuridici e` stata eseguita,
                 si attualizzano gli indicatori su Rapporti Incentivo se
                 prevista la relative gestione.
              */
              --   IF d_incentivi = 'SI' THEN
              --   UPDATE RAPPORTI_INCENTIVO raip
              --   SET raip.d_rett
              --  = TO_DATE('01'||TO_CHAR(d_dal,'mmyyyy')
              --    ,'ddmmyyyy')
              --   ,raip.flag_elab
              --  = DECODE(raip.flag_elab,'L',NULL,raip.flag_elab)
              --    WHERE raip.ci  = d_ci
              --   AND NVL(raip.d_rett,TO_DATE('3333333','j'))
              --    > TO_DATE('01'||
              --     TO_CHAR(d_dal,'mmyyyy')
              --    ,'ddmmyyyy')
              --   ;
              --   END IF;
              /*
               Se l' operazione sui Periodi Giuridici e` stata eseguita,
               si elimina Deposito Eventi Presenza se si e` operata una
               eliminazione o se il tipo trattamento e` totale, si varia
               l' indicatore di operazione per gli altri casi.
              */
              IF d_operazione IN ('U', 'I') AND d_dep_periodo_ggpe = 'R'
              THEN
                UPDATE deposito_eventi_presenza depa
                   SET depa.data_agg   = SYSDATE
                      ,depa.operazione = 'C'
                      ,depa.data       = depa.dal
                 WHERE depa.data_agg = d_data_agg
                   AND depa.assenza = d_assenza
                   AND depa.ci = d_ci
                   AND depa.operazione = d_operazione
                   AND depa.data = d_data
                   AND depa.rilevanza IN ('R', 'P');
              END IF;
              IF d_operazione = 'D' OR d_dep_periodo_ggpe = 'T'
              THEN
                DELETE FROM deposito_eventi_presenza depa
                 WHERE depa.data_agg = d_data_agg
                   AND depa.assenza = d_assenza
                   AND depa.ci = d_ci
                   AND depa.operazione = d_operazione
                   AND depa.data = d_data
                   AND depa.rilevanza IN ('R', 'P');
              END IF;
            END IF; -- Fine IF per operazione eseguita
            -- sui Periodi Giuridici
          END IF; -- Fine IF su d_errore se = 0
          /* Aggiorna il codice di errore sulla registrazione esamina-
          ta.  */
          BEGIN
            UPDATE deposito_eventi_presenza depa
               SET depa.errore = d_errore
             WHERE depa.data_agg = d_data_agg
               AND depa.assenza = d_assenza
               AND depa.ci = d_ci
               AND depa.operazione = d_operazione
               AND depa.data = d_data
               AND depa.rilevanza IN ('R', 'P');
          EXCEPTION
            WHEN too_many_rows THEN
              registra_errore('A00003');
              RAISE fine_step;
            WHEN no_data_found THEN
              registra_errore('A00001');
              RAISE fine_step;
          END;
        END IF; -- Fine IF per trattamento movimento
        -- secondo il tipo di trattamento
      END LOOP;
      CLOSE depa;
    END;
    /* Vengono eliminati da Deposito Eventi Presenza tutte quel-
       le registrazioni che sono state gia` elaborate o quelle
       che non hanno in Rapporti Giuridici il rispettivo periodo
       da trattare. Questa fase e` eseguita solo se il tipo di
       trattamento e` a riferimento.
    */
    BEGIN
      IF d_dep_periodo_ggpe = 'R'
      THEN
        DELETE FROM deposito_eventi_presenza depa
         WHERE depa.rilevanza IN ('R', 'P')
           AND depa.operazione = 'C'
           AND (d_dep_periodo_ggpe = 'T' -- potrebbe essere stato
               OR d_dep_periodo_ggpe = 'R' -- variato il tipo di
               AND depa.data <= -- trattamento
               add_months(d_fin_ela, d_dep_variabili_gape))
           AND (EXISTS (SELECT 'x'
                          FROM periodi_giuridici pegi
                         WHERE pegi.ci = depa.ci
                           AND pegi.rilevanza = 'A'
                           AND pegi.dal = depa.dal
                           AND nvl(pegi.al, to_date('3333333', 'j')) = nvl(depa.al, to_date('3333333', 'j'))
                           AND pegi.assenza = depa.assenza) OR NOT EXISTS
                (SELECT 'x'
                   FROM periodi_giuridici pegi
                  WHERE pegi.ci = depa.ci
                    AND pegi.rilevanza = 'A'
                    AND pegi.dal = depa.data));
      END IF;
    END;
    /*  Se non ci sono errori, si salta il passo di stampa anomalie. */
    BEGIN
      SELECT 'x'
        INTO d_comodo
        FROM deposito_eventi_presenza depa
       WHERE depa.rilevanza IN ('R', 'P')
         AND depa.errore != 0;
      RAISE too_many_rows;
    EXCEPTION
      WHEN too_many_rows THEN
        NULL;
      WHEN no_data_found THEN
        UPDATE a_prenotazioni
           SET prossimo_passo = 99
         WHERE no_prenotazione = w_prenotazione;
    END;
  EXCEPTION
    WHEN fine_step THEN
      NULL;
  END;
  PROCEDURE main
  (
    prenotazione IN NUMBER
   ,passo        IN NUMBER
  ) IS
  BEGIN
    DECLARE
      p_gestione VARCHAR2(4);
    BEGIN
      BEGIN
        SELECT nvl(substr(valore, 1, 4), '%') d_gestione
          INTO s_gestione
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro = 'P_GESTIONE';
      EXCEPTION
        WHEN no_data_found THEN
          s_gestione := '%';
      END;
      IF prenotazione != 0
      THEN
        BEGIN
          -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
          SELECT utente
                ,ambiente
                ,ente
                ,gruppo_ling
            INTO w_utente
                ,w_ambiente
                ,w_ente
                ,w_lingua
            FROM a_prenotazioni
           WHERE no_prenotazione = prenotazione;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      w_prenotazione := prenotazione;
      controllo; -- ESECUZIONE DEL CONTROLLO EVENTI
      COMMIT;
    END;
  END;
END;
/
