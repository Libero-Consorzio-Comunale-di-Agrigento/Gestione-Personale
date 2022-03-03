CREATE OR REPLACE PACKAGE PECCARST IS
/******************************************************************************
 NOME:          PECCARST
 DESCRIZIONE:   CARICAMENTO ARCHIVIO STATISTICHE TRIMESTRALI
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Elenco delle segnalazioni e relativo codice
               Errore 001: Estrazione record doppi nel mese XX verificare DQUST
               Errore 002: Individui con Tempo Pieno NO e part time 100 nel mese XX
               Errore 003: Verificare Correttezza Dipendente nel mese XX: possibile cessazione non rilevata
               Errore 004: Verificare Correttezza Dipendente nel mese XX: possibile assunzione non rilevata
               Errore 005: Dipendente in Astensione nel mese XX: Nessun Importo Archiviato
               Errore 010: Colonna Arretrati non Definita nel mese XX per colonna YY
               Errore 011: Verificare Correttezza Dipendente nel mese XX: Nessun Importo Archiviato
               Errore 012: Verificare Dip. nel mese XX: Importo Non Valorizzato per colonna / voce

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    09/12/2003
 1.2  16/06/2004 AM     Assestamento estrazione dati economici
 1.3  29/06/2004 AM     Gestione colonna aggiuntiva 'IRAP'
 1.4  13/07/2004 GM     Gestione di segnlazione in elaborazione
 1.5  16/07/2004 GM     Svincolato il package alle colonne fisse nella parte economica
 1.6  12/01/2005 MS     Modifica per att 9166
 1.7  15/02/2005 MS     Modifica per att. 9705
 1.8  12/07/2005 MS     Modifica per att. 11963
 1.9  12/07/2005 AM     Modifica per att. 11977: cambiata  posizione della delete degli importi
                        per gestire il caso di più periodi su qualifiche diverse per lo stesso CI
 1.10 13/07/2005 AM     mod. gestione assenze con coto_annuale = 99 per gestire in particolare
                        le assenze con al nullo; riallineato il codice
 1.11 21/07/2005 ML     Modificato assestamento assunzioni (A12109)
                        Gestione segnalazioni per il mancato rilevamento di assunzioni e/o cessazioni
 1.12 27/09/2005 MS     Mod. gestione di cessazioni e riassunzioni a cavallo di mese 
 1.13 24/10/2005 MS     Mod. cursori di segnalazioni
 1.14 28/10/2005 MS     Mod. per archiviazione periodica e per competenza att A12801
 1.15 02/11/2005 MS     Mod. per riferimenti esterni - A12127
 1.16 28/11/2005 MS     Mod. estrazione contratto rif. A13699
 1.17 09/02/2006 MS     Mod. gestione assenze e mod. rif. esterni - Att.14804 e 14826
 1.18 18/04/2006 ML     Aggiunta condizione sul mese in insert su smttr_importi  (A15804)
 1.19 19/04/2006 ML     Modificate le condizioni in like sulla gestione mettendole con uguale (A15819).
 1.20 26/04/2006 MS     Modificata la insert degli arretrati post-dimissioni (A15833).
 1.21 16/05/2006 MS     Modificata la gestione delle segnalazioni (A15842) e ordinamento delle stesse
 1.22 19/05/2006 MS     Migliorie alla gestione delle segnalazioni nuove (A15842.1)
 1.23 19/05/2006 MS     Gestione degli arretrati AP se Comp. Econ. ( A15844 )
 1.24 04/07/2006 MS     Sistemazioni per CEBF Galliera ( A15844.1 )
 1.25 27/10/2006 MS     Modifica estrazione ripresi per arretrati ( A18128 )
 1.26 02/04/2007 MS     Modifica formato assunzione e cessazione ( A20411 )
 1.27 10/04/2007 MS     Inserimento nuovi parametri di selezione ( A20440 )
 1.28 10/04/2007 MS     Esclusione delle assenze con conto annuale = 0 ( A20442 )
 1.29 12/04/2007 MS     Sistemazione tempi cur_arr ed errore su gruppo ( A20440.2 )

corretto errore apam ... da inserire nella prox modifica al CARST ....

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCARST IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.29 del 12/04/2007';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
DECLARE
--
-- Depositi e Contatori Vari
--
  D_ente        varchar2(4);
  D_ambiente    varchar2(8);
  D_utente      varchar2(8);
  D_anno        number;
  D_ini_mes     date;
  D_fin_mes     date;
  D_fin_mp      date;
  D_gestione    varchar2(4);
  D_fascia      varchar(2);
  D_rapporto    varchar2(4);
  D_gruppo      varchar2(12);
  D_tipo        varchar2(1);
  D_mese        number;
  D_anno_prec   number;
  D_mese_prec   number;
  D_elab        varchar2(1);
  D_ci          number;

  D_mese_da     number;
  D_mese_a      number;
  D_ini_mese_da date;
  D_ini_mese_a  date;
  D_fin_mese_da date;
  D_fin_mese_a  date;
  P_competenza  varchar2(1);

-- variabili di appoggio
  D_pagina      number := 0;
  D_riga        number;
  V_colonna_arr varchar2(30);
  V_testo       varchar2(500);
  V_dal         date;
  V_al          date := to_date(null);
  V_segnala     varchar2(1);
  D_int_com     varchar2(2);
  D_est_com     varchar2(2);
  D_trovato     number := 0;
  D_conta       number := 0;
  D_controllo   varchar2(1);
  D_gg_ass      number;
  D_cod_qua     varchar2(8);
  D_cod_fig     varchar2(8);
  D_tipo_rapp   varchar2(4);
  D_di_ruolo    varchar2(1);
  D_con_for     varchar2(6);
  D_qua_min     varchar2(6);
  D_tem_det     varchar2(2);
  D_part_time   varchar2(2);
  D_perc_part_time number(5,2);
  D_assunzione  PERIODI_GIURIDICI.evento%TYPE;
  D_cessazione  PERIODI_GIURIDICI.evento%TYPE;
  D_conta_periodi number := 0;
  D_dal         date;
  D_al          date;
  D_dal_a       date;
  D_al_a        date;
  D_dal_p       date;
  D_al_p        date;
  T_dal         date;
  T_al          date;
  T_temp_det    SMTTR_PERIODI.tempo_determinato%TYPE;
  T_qualifica   SMTTR_PERIODI.qualifica%TYPE;
  P_numeratore  number(8);
  errore        exception;

  cursor CUR_PER(p_ci number, p_anno number, p_mese number, p_gestione varchar2) is
     select dal,al,tempo_determinato
       from smttr_periodi
      where ci       = p_ci
        and anno     = p_anno
        and mese     = p_mese
        and gestione = p_gestione
      order by dal
     ;
  cursor CUR_ESTERNI
  ( P_ci number, P_anno number, P_mese number , P_gestione varchar2, P_inizio date
  , P_fine date ) is            
     ( select distinct ci
        from smttr_periodi stpe
       where stpe.anno     = P_anno
         and stpe.mese     = P_mese
         and stpe.ci       = P_ci
         and stpe.gestione = P_gestione
         and exists (select 'x' 
                       from valori_contabili_mensili vacm
                      where vacm.anno              = P_anno
                        and vacm.mese              = P_mese
                        and vacm.mensilita        !=  'AP'
                        and vacm.estrazione        = 'SMTTRI'
                        and vacm.ci                = P_ci
                        and vacm.mensilita    != 'AP'
                        and not exists (select 'X'
                                          from smttr_periodi           stpe1
                                             , smttr_periodi           stpe2
                                         where stpe1.ci              = P_ci
                                           and stpe1.ci              = stpe2.ci
                                           and stpe1.anno            = stpe2.anno
                                           and stpe1.mese            = stpe2.mese
                                           and stpe1.anno            = P_anno
                                           and stpe1.mese            = P_mese
                                           and stpe1.gestione        = P_gestione
                                           and stpe2.gestione        = stpe1.gestione
                                           and stpe1.dal             <= P_fine
                                           and nvl(stpe1.al,to_date('3333333','j')) >= P_inizio
                                           and stpe2.dal             = ( select min(dal) from smttr_periodi
                                                                          where ci    = stpe2.ci
                                                                            and anno  = stpe2.anno
                                                                            and mese  = stpe2.mese
                                                                            and gestione = stpe2.gestione
                                                                            and dal  <= P_fine
                                                                            and nvl(al,to_date('3333333','j')) 
                                                                                >= P_inizio
                                                                         ) 
                                          and vacm.riferimento 
                                              between decode( stpe1.dal
                                                            , stpe2.dal , to_date('2222222','j')
                                                                        , stpe1.dal
                                                             )              
                                                  and least(P_fine,nvl(stpe1.al,to_date('3333333','j')))
                                        )
                   having sum(nvl(vacm.valore,0)) != 0
                     )
           );
-- Estrazione Parametri di Selezione della Prenotazione
  BEGIN  
   BEGIN
-- dbms_output.put_line('Inizio estrazione parametri');
    BEGIN
      SELECT ENTE     D_ente
           , utente   D_utente
           , ambiente D_ambiente
        INTO D_ente,D_utente,D_ambiente
        FROM a_prenotazioni
       WHERE no_prenotazione = prenotazione
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_ente     := NULL;
        D_utente   := NULL;
        D_ambiente := NULL;
    END;
       BEGIN
      SELECT valore
        INTO D_tipo
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro       = 'P_TIPO'
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_tipo := 'T';
    END;
    BEGIN
        BEGIN
        SELECT valore
          INTO D_elab
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro       = 'P_ELAB'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          D_elab := 'T';
      END;
      BEGIN
        SELECT valore
          INTO D_gestione
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro       = 'P_GESTIONE'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          D_gestione := '%';
      END;
     BEGIN
        select valore
          into D_fascia
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro    = 'P_FASCIA'
        ;
     EXCEPTION WHEN NO_DATA_FOUND THEN D_fascia := '%';
     END;
     BEGIN
        select valore
          into D_rapporto
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro    = 'P_RAPPORTO'
        ;
     EXCEPTION WHEN NO_DATA_FOUND THEN D_rapporto := '%';
     END;
     BEGIN
        select valore
          into D_gruppo
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro    = 'P_GRUPPO'
        ;
     EXCEPTION WHEN NO_DATA_FOUND THEN D_gruppo := '%';
     END;
      BEGIN
        SELECT substr(valore,1,4)
          INTO D_anno
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro       = 'P_ANNO'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          SELECT anno
            INTO D_anno
            FROM riferimento_retribuzione
           WHERE rire_id = 'RIRE';
      END;

      BEGIN
          SELECT valore
            INTO P_competenza
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_COMPETENZA'
          ;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
           P_competenza := null;
      END;
  /* estrazione mese inizio trimestre */
      BEGIN
          SELECT lpad(substr(valore,1,2),2,0)
                ,to_date('01'||lpad(substr(valore,1,2),2,0)||to_char(D_anno),'ddmmyyyy')
                ,last_day(to_date(lpad(substr(valore,1,2),2,0)||to_char(D_anno),'mmyyyy'))
            INTO D_mese_da, D_ini_mese_da, D_fin_mese_da
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_MESE_DA'
          ;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            SELECT mese
                  ,to_date('01'||lpad(to_char(mese),2,'0')||to_char(D_anno),'ddmmyyyy')
                  ,last_day(to_date(lpad(to_char(mese),2,'0')||to_char(D_anno),'mmyyyy'))
              INTO D_mese_da, D_ini_mese_da, D_fin_mese_da
              FROM riferimento_retribuzione
             WHERE rire_id = 'RIRE'
            ;
      END;
  /* estrazione mese fine trimestre */
      BEGIN
          SELECT lpad(substr(valore,1,2),2,0)
                ,to_date('01'||lpad(substr(valore,1,2),2,0)||to_char(D_anno),'ddmmyyyy')
                ,last_day(to_date(lpad(substr(valore,1,2),2,0)||to_char(D_anno),'mmyyyy'))
            INTO D_mese_a, D_ini_mese_a, D_fin_mese_a
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_MESE_A'
          ;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            D_mese_a := D_mese_da;
            D_ini_mese_a := D_ini_mese_da;
            D_fin_mese_a := D_fin_mese_da;
      END;

      /* Controllo sui parametri per competenza */
      IF ( P_competenza = 'X' AND  ( D_mese_a - D_mese_da ) + 1 != 3
       or P_competenza = 'X' AND  D_mese_a not in ( 3,6,9,12 )
       or P_competenza = 'X' AND  D_mese_da not in ( 1, 4, 7, 10 ) 
       or P_competenza is null and D_mese_a < D_mese_da ) THEN
       raise errore;
      END IF;

      BEGIN
        SELECT to_number(substr(valore,1,8))
          INTO D_ci
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro       = 'P_CI'
        ;
-- dbms_output.put_line('tipo/ci '||D_tipO||' '||D_ci);
        IF D_tipo in ('T','P','I','V') and D_ci is not null THEN
          raise errore;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          IF D_tipo = 'S' then
            raise errore;
          END IF;
      END;
   END; -- fine estrazione parametri

   D_mese := null;
   D_ini_mes := to_date(null);
   D_fin_mes := to_date(null);
   D_fin_mp := to_date(null);

   FOR VAR_MESE in D_mese_da .. D_mese_a LOOP
-- dbms_output.put_line('cursore mese giuridico ');
     BEGIN
       select lpad(substr(VAR_MESE,1,2),2,0)
              ,to_date('01'||lpad(substr(VAR_MESE,1,2),2,0)||to_char(D_anno),'ddmmyyyy')
              ,last_day(to_date(lpad(substr(VAR_MESE,1,2),2,0)||to_char(D_anno),'mmyyyy'))
              ,to_date('01'||lpad(substr(VAR_MESE,1,2),2,0)||to_char(D_anno),'ddmmyyyy')-1
         INTO D_mese, D_ini_mes, D_fin_mes, D_fin_mp
         FROM DUAL;
-- dbms_output.put_line('mese giur: '||D_mese||' '||D_fin_mes||' fin mes p : '||D_fin_mp);
      IF D_elab in ('T','G') THEN
      BEGIN
        FOR CUR_CI IN
        (  SELECT rain.ci  ci
                , pegi.gestione  gestione
                , max(clra.retributivo) retributivo
                , max(clra.codice) cla_rap
             FROM rapporti_individuali rain
                , anagrafici           anag
                , periodi_giuridici    pegi
                , classi_rapporto      clra
                , gestioni             gest
            WHERE anag.ni        = rain.ni
              AND pegi.ci        = rain.ci
              AND gest.codice    = pegi.gestione
              AND gest.gestito   = 'SI'
              AND rain.rapporto  = clra.codice
              AND rain.rapporto         LIKE D_rapporto
              AND nvl(rain.gruppo,' ')  LIKE D_gruppo
              AND pegi.gestione  LIKE D_gestione
              AND pegi.gestione  in ( select codice
                                        from gestioni
                                       where nvl(fascia,' ') like D_fascia
                                    )
              AND pegi.rilevanza = 'S'
              AND pegi.dal       <= D_fin_mes
              AND nvl(pegi.al,to_date('3333333','j')) >= D_fin_mp
              AND clra.giuridico = 'SI'
              AND clra.presenza  = 'SI'
              AND rain.dal       <= D_fin_mes
              AND nvl(rain.al,to_date('3333333','j')) >= D_fin_mp
              AND exists ( select 'x' 
                             from periodi_giuridici   pegi2
                            where pegi2.rilevanza  in ('S','E')
                              and pegi2.dal        <= D_fin_mes
                              and nvl(pegi2.al,to_date('3333333','j')) >= D_fin_mp
                              and pegi2.gestione   like D_gestione
                              and pegi2.ci = pegi.ci
                         )
              AND (rain.cc is null
                     or exists
                       (select 'x'
                          from a_competenze
                         where ente        = D_ente
                           and ambiente    = D_ambiente
                           and utente      = D_utente
                           and competenza  = 'CI'
                           and oggetto     = rain.cc
                       )
                    )
              AND ( D_tipo = 'T'
                 or ( D_tipo in ('I','V','P')
                       and ( not exists ( select 'x' 
                                            from smttr_individui
                                           where anno     = D_anno
                                             and mese     = D_mese
                                             and ci       = pegi.ci
                                             and gestione = pegi.gestione
                                             and nvl(tipo_agg,' ') = decode(D_tipo
                                                                           ,'P',tipo_agg
                                                                           ,D_tipo)
                                          union
                                          select 'x' 
                                            from smttr_periodi
                                           where anno = D_anno
                                             and mese     = D_mese
                                             and ci   = pegi.ci
                                             and gestione = pegi.gestione
                                             and nvl(tipo_agg,' ') = decode(D_tipo
                                                                           ,'P',tipo_agg
                                                                           ,D_tipo)
                                          union
                                          select 'x' 
                                            from smttr_importi
                                           where anno = D_anno
                                             and mese = D_mese
                                             and ci   = pegi.ci
                                             and gestione = pegi.gestione
                                             and nvl(tipo_agg,' ') = decode(D_tipo
                                                                           ,'P',tipo_agg
                                                                           ,D_tipo)
                                       )
                          )
                    )
                 or ( D_tipo  = 'S'
                      and pegi.ci = D_ci )
               )
           GROUP BY pegi.gestione,rain.ci
         ORDER BY pegi.gestione,rain.ci
        ) LOOP
-- dbms_output.put_line('Elaborazione CI: '||CUR_CI.ci||' '||cur_ci.gestione);
-- cancello eventuali archiviazioni precedenti
        LOCK TABLE SMTTR_INDIVIDUI IN EXCLUSIVE MODE NOWAIT
        ;
        DELETE from SMTTR_INDIVIDUI
         WHERE anno        = D_anno
           AND mese        = D_mese
           AND gestione    = CUR_CI.gestione
           AND ci          = CUR_CI.ci 
        ;
        LOCK TABLE SMTTR_PERIODI IN EXCLUSIVE MODE NOWAIT
        ;
        DELETE from SMTTR_PERIODI
         WHERE anno        = D_anno
           AND mese        = D_mese
           AND gestione    = CUR_CI.gestione
           AND ci          = CUR_CI.ci
        ;
        COMMIT;
        BEGIN
         D_pagina         := D_pagina + 1;
         D_riga           := 0;
         D_int_com        := null;
         D_est_com        := null;
         D_assunzione     := null;
         D_cessazione     := null;
         D_conta          := null;
         D_trovato        := null;
         D_qua_min        := null;
         D_tem_det        := null;
         D_part_time      := null;
         D_perc_part_time := null;
         D_controllo      := null;
         D_dal            := null;
         D_al             := null;
         D_dal_a          := null;
         D_al_a           := null;
         D_dal_p          := null;
         D_al_p           := null;
         D_gg_ass         := null;
         T_dal            := null;
         T_al             := null;
         T_temp_det       := null;
         T_qualifica      := null;
-- Determino se interno comandato
         D_int_com := PECSMTFC.INT_COM(CUR_CI.ci,CUR_CI.gestione,null,D_fin_mes,CUR_CI.retributivo);
-- dbms_output.put_line('Interno Comandato: '||D_int_com);
-- Determino se esterno comandato
         D_est_com := PECSMTFC.EST_COM(CUR_CI.ci,CUR_CI.gestione,null,D_fin_mes,CUR_CI.retributivo);
-- dbms_output.put_line('Esterno Comandato: '||D_est_com);
-- Inserisco i record di testata
-- dbms_output.put_line('Inserisco individuo: '||CUR_CI.ci);
            insert into SMTTR_INDIVIDUI
            ( ANNO,MESE,CI,GESTIONE,INT_COMANDATO,EST_COMANDATO,UTENTE,TIPO_AGG,DATA_AGG )
            values ( D_anno
                   , D_mese
                   , CUR_CI.ci
                   , CUR_CI.gestione
                   , D_int_com
                   , D_est_com
                   , D_utente, null, sysdate
                   )
                    ;
             commit;               
-- dbms_output.put_line('Inserimento avvenuto '||CUR_CI.ci); 
            BEGIN
              D_trovato := 0;
              D_conta   := 0;
              FOR CUR_PEGI IN
                (SELECT greatest(pegi.dal,figi.dal) dal
                      , to_date(to_char(decode( least( nvl(pegi.al, to_date('3333333','j')) 
                                                     , nvl(figi.al, to_date('3333333','j'))
                                                      )
                                              , to_date('3333333','j'), to_date(null)
                                                                      , least( nvl(pegi.al, to_date('3333333','j'))
                                                                             , nvl(figi.al, to_date('3333333','j')))
                                        ),'dd/mm/yyyy'),'dd/mm/yyyy')  al
                      , rqst.codice                 qua_min
                      , posi.tempo_determinato      tem_det
                      , posi.part_time              part_time
                      , decode(posi.part_time
                              ,'SI',round(PEGI.ore/cost.ore_lavoro*100,2)
                                   ,null
                               )                    perc_part_time
                      , posi.contratto_formazione   con_for
                      , qugi.codice                 cod_qual
                      , figi.codice                 cod_fig
                      , pegi.tipo_rapporto          tipo_rapporto
                      , posi.di_ruolo               di_ruolo
                   FROM  periodi_giuridici            pegi
                       , posizioni                    posi
                       , figure_giuridiche            figi
                       , qualifiche_giuridiche        qugi
                       , righe_qualifiche_statistiche rqst
                       , contratti_storici            cost
                  WHERE pegi.ci          = CUR_CI.ci
                    AND pegi.rilevanza   = 'S'
                    AND pegi.dal         <= D_fin_mes
                    AND nvl(pegi.al,to_date('3333333','j')) >= D_fin_mp
                    AND pegi.gestione    like CUR_CI.gestione
                    AND posi.codice      = pegi.posizione
                    AND pegi.figura      = figi.numero
                    AND figi.dal         <= nvl(pegi.al,to_date('3333333','j'))
                    AND nvl(figi.al,to_date('3333333','j')) >= pegi.dal
                    AND pegi.qualifica   = qugi.numero
                    AND PEGI.dal between qugi.dal
                                     AND nvl(qugi.al,to_date('3333333','j'))
                    AND rqst.statistica = 'SMTTRI'
                    AND (     (    rqst.qualifica is null
                               and rqst.figura     = pegi.figura)
                           or (    rqst.figura    is null
                               and rqst.qualifica  = pegi.qualifica)
                           or (    rqst.qualifica is not null
                               and rqst.figura    is not null
                               and rqst.qualifica  = pegi.qualifica
                               and rqst.figura     = pegi.figura)
                           or (    rqst.qualifica is null
                               and rqst.figura    is null)
                          )
                    AND nvl(rqst.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                    AND nvl(rqst.tempo_determinato,posi.tempo_determinato)    = posi.tempo_determinato
                    AND nvl(rqst.formazione_lavoro,posi.contratto_formazione) = posi.contratto_formazione
                    AND nvl(rqst.part_time,posi.part_time) = posi.part_time
                    AND nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqst.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
                    AND exists ( select 'x' from rapporti_individuali
                                  where ci        = pegi.ci
                                    and rapporto in
                                        (select codice from classi_rapporto
                                          where giuridico   = 'SI'
                                            and retributivo = 'SI')
                               )
                    AND cost.contratto    = qugi.contratto
                    and D_fin_mes between cost.dal
                                      and nvl(cost.al,to_date('3333333','j'))
                  ORDER BY pegi.dal,pegi.al
            ) LOOP
-- dbms_output.put_line('cursore pegi periodo: '||CUR_PEGI.dal||' '||CUR_PEGI.al);
              BEGIN
                D_trovato  := 1;
                D_conta    := D_conta + 1;
-- dbms_output.put_line('Conta '||to_char(D_conta));
-- memorizza i dati per segnalazioni di errore
                D_cod_qua := CUR_PEGI.cod_qual;
                D_cod_fig := CUR_PEGI.cod_fig;
                D_tipo_rapp := CUR_PEGI.tipo_rapporto;
                D_di_ruolo  := CUR_PEGI.di_ruolo;
                D_con_for   := CUR_PEGI.con_for;

               IF D_conta = 1 THEN
-- Se primo recod memorizza i dati da confrontare con i record successivi
                  D_qua_min        := CUR_PEGI.qua_min;
                  D_tem_det        := CUR_PEGI.tem_det;
                  D_part_time      := CUR_PEGI.part_time;
                  D_perc_part_time := CUR_PEGI.perc_part_time;
                  D_dal            := CUR_PEGI.dal;
                  D_al             := CUR_PEGI.al;
-- Dal secondo record in poi confronta i dati correnti con quelli del record precedente
               ELSIF  nvl(D_qua_min,' ')      = nvl(CUR_PEGI.qua_min,' ')      AND
                      nvl(D_tem_det,' ')      = nvl(CUR_PEGI.tem_det,' ')      AND
                      nvl(D_part_time,' ')    = nvl(CUR_PEGI.part_time ,' ')   AND
                      nvl(D_perc_part_time,0) = nvl(CUR_PEGI.perc_part_time,0) AND
                      CUR_PEGI.dal = D_al + 1
                      and D_al != D_fin_mp
               THEN
-- Se dati uguali e date consecutive unifica il perido
                 D_al   := CUR_PEGI.al;
               ELSE
-- Se dati non uguali e date non consecutive, inserisce primo record e memorizza dati record corrente
-- dbms_output.put_line('Periodi del Cursore '||to_char(CUR_PEGI.dal,'dd/mm/yyyy')||' - '||to_char(CUR_PEGI.al,'dd/mm/yyyy'));
              BEGIN
                select 'x'
                  into D_controllo
                  from SMTTR_PERIODI
                 where anno     = D_anno
                   and mese     = D_mese
                   and ci       = CUR_CI.ci
                   and gestione = CUR_CI.gestione
                   and dal      = D_dal
                  ;
-- dbms_output.put_line('Controllo 1: '||D_controllo||' '||CUR_CI.ci);
-- dbms_output.put_line('Dal: '||D_dal);
                  raise too_many_rows;
              EXCEPTION
                WHEN no_data_found THEN
-- dbms_output.put_line('Inserisco il periodo A'||to_char(CUR_PEGI.dal,'dd/mm/yyyy')||' - '||to_char(CUR_PEGI.al,'dd/mm/yyyy'));
                 insert into SMTTR_PERIODI 
                 ( ANNO,MESE,CI,GESTIONE,DAL,AL,QUALIFICA,TEMPO_DETERMINATO,TEMPO_PIENO
                 , PART_TIME,ASSUNZIONE,CESSAZIONE,GG_ASSENZA,UTENTE,TIPO_AGG,DATA_AGG)
                 values ( D_anno
                        , D_mese
                        , CUR_CI.ci
                        , CUR_CI.gestione
                        , D_dal
                        , D_al
                        , D_qua_min
                        , D_tem_det
                        , decode(D_part_time,'SI','NO','SI')
                        , nvl(D_perc_part_time,decode(D_part_time,'SI',100,D_perc_part_time))
                        , null -- assunzione
                        , null -- cessazione
                        , null -- assenze
                        , D_utente
                        , null -- tipo
                        , sysdate
                        )
                    ;
                  commit;
                  D_qua_min        := CUR_PEGI.qua_min;
                  D_tem_det        := CUR_PEGI.tem_det;
                  D_part_time      := CUR_PEGI.part_time;
                  D_perc_part_time := CUR_PEGI.perc_part_time;
                  D_dal            := CUR_PEGI.dal;
                  D_al             := CUR_PEGI.al;
                WHEN too_many_rows THEN
-- dbms_output.put_line('Estrazione doppia');
                    d_riga := nvl(D_riga,0) + 1;
                    V_testo := lpad('Errore 001',10)||
                               lpad('Mese '||D_mese,7,' ')||
                               lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                               lpad(nvl(CUR_CI.ci,0),8,0)||
                               lpad(nvl(to_char(D_dal,'ddmmyyyy'),' '),8,' ')||
                               lpad(nvl(to_char(D_al,'ddmmyyyy'),' '),8,' ')||
                               rpad('Estrazione record doppi nel mese '||D_mese||': verificare DQUST',132,' ')||
                               rpad(D_cod_qua,8,' ')||
                               rpad(D_cod_fig,8,' ')||
                               rpad(D_tipo_rapp,4,' ')||
                               rpad(D_di_ruolo,1,' ')||
                               rpad(D_tem_det,2,' ')||
                               rpad(D_part_time,2,' ')||
                               rpad(D_con_for,2,' ')||
                               rpad(CUR_CI.cla_rap,4,' ')
                              ;
                       insert into a_appoggio_stampe(NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                       select prenotazione
                            , 2
                            , D_pagina
                            , D_riga
                            , V_testo
                         from dual
                        where not exists ( select 'x' 
                                             from a_appoggio_stampe
                                            where no_prenotazione = prenotazione
                                              and no_passo = 2
                                              and pagina = D_pagina
                                              and testo = V_testo
                                         ) 
                        ;
                       commit;
                 END;
               END IF; -- D_conta
              END;
              END LOOP; -- CUR_PEGI
-- dbms_output.put_line('fine cursore pegi');
-- Inserimento ultimo record CUR_PEGI
-- dbms_output.put_line('D_trovato '||to_char(D_trovato));
              IF D_trovato = 1 THEN
                BEGIN
                select 'x'
                  into D_controllo
                  from SMTTR_PERIODI
                 where anno     = D_anno
                   and mese     = D_mese
                   and ci       = CUR_CI.ci
                   and gestione = CUR_CI.gestione
                   and dal      = D_dal
                    ;
-- dbms_output.put_line('Controllo 2: '||D_controllo||' '||CUR_CI.ci);
-- dbms_output.put_line('Dal: '||D_dal);
                raise too_many_rows;
                EXCEPTION
                    WHEN no_data_found THEN
-- dbms_output.put_line('Inserisco il periodo B '||to_char(D_dal,'dd/mm/yyyy')||' - '||to_char(D_al,'dd/mm/yyyy'));
                    insert into SMTTR_PERIODI 
                    ( ANNO,MESE,CI,GESTIONE,DAL,AL,QUALIFICA,TEMPO_DETERMINATO,TEMPO_PIENO
                    , PART_TIME,ASSUNZIONE,CESSAZIONE,GG_ASSENZA,UTENTE,TIPO_AGG,DATA_AGG)
                    values( D_anno
                          , D_mese
                          , CUR_CI.ci
                          , CUR_CI.gestione
                          , D_dal
                          , D_al
                          , D_qua_min
                          , D_tem_det
                          , decode(D_part_time,'SI','NO','SI')
                          , nvl(D_perc_part_time,decode(D_part_time,'SI',100,D_perc_part_time))
                          , null -- assunzione
                          , null -- cessazione
                          , null -- assenze
                          , D_utente
                          , null -- tipo
                          , sysdate
                          )
                          ;
                      commit;
-- dbms_output.put_line('Periodo inserito');
                    WHEN too_many_rows THEN
-- dbms_output.put_line('Estrazione doppia ultimo periodo');
                    d_riga := nvl(D_riga,0) + 1;
-- dbms_output.put_line('D_pagina '||D_pagina);
-- dbms_output.put_line('D_riga '||D_riga);
                        V_testo := lpad('Errore 001',10)||
                                   lpad('Mese '||D_mese,7,' ')||
                                   lpad(CUR_CI.gestione,4)||
                                   lpad(CUR_CI.ci,8,0)||
                                   lpad(nvl(to_char(D_dal,'ddmmyyyy'),' '),8,' ')||
                                   lpad(nvl(to_char(D_al,'ddmmyyyy'),' '),8,' ')||
                                   rpad('Estrazione record doppi nel mese '||D_mese||': verificare DQUST',132)||
                                   rpad(D_cod_qua,8,' ')||
                                   rpad(D_cod_fig,8,' ')||
                                   rpad(D_tipo_rapp,4,' ')||
                                   rpad(D_di_ruolo,1,' ')||
                                   rpad(D_tem_det,2,' ')||
                                   rpad(D_part_time,2,' ')||
                                   rpad(D_con_for,2,' ')||
                                   rpad(CUR_CI.cla_rap,4,' ')
                                 ;
                       insert into a_appoggio_stampe(NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                       select prenotazione
                            , 2
                            , D_pagina
                            , D_riga
                            , V_testo
                         from dual
                        where not exists ( select 'x' 
                                             from a_appoggio_stampe
                                            where no_prenotazione = prenotazione
                                              and no_passo = 2
                                              and pagina = D_pagina
                                              and testo = V_testo
                                         ) 
                        ;
                       commit;
                      END;
                    END IF; -- D_trovato
                  END;
-- dbms_output.put_line('Fine Caricamento periodi');
            BEGIN
-- dbms_output.put_line('Elaborazione periodi di assenza');
                FOR CUR_ASSENZE in
                   ( SELECT pegi.dal, pegi.al
                       FROM periodi_giuridici pegi
                      WHERE rilevanza = 'A'
                        AND evento in (select codice from eventi_giuridici
                                        where nvl(conto_annuale,0 ) = 99
                                      )
                        AND pegi.dal                            <= D_fin_mes
                        AND nvl(pegi.al,to_date('3333333','j')) >= D_fin_mp
                        AND pegi.ci = CUR_CI.ci
                    )  LOOP
-- dbms_output.put_line('cursore assenze');
                    V_segnala := '';
                    BEGIN
                    D_dal_a := CUR_ASSENZE.dal;
                    D_al_a  := CUR_ASSENZE.al;
-- dbms_output.put_line('Periodo di assenza dal/al'||to_char(D_dal_a,'dd/mm/yyyy')||' '||to_char(D_al_a,'dd/mm/yyyy'));
                    FOR CUR_PERIODI in
                     ( SELECT greatest(dal,D_fin_mp) dal_p
                            , least(nvl(al,to_date('3333333','j')),D_fin_mes) al_p
                            , dal, al
                         FROM smttr_periodi
                        WHERE ci = CUR_CI.ci
                          and gestione = CUR_CI.gestione
                          and anno = D_anno
                          and mese = D_mese
                          AND (   D_dal_a between dal and nvl(al,to_date('3333333','j'))
                               or nvl(D_al_a,to_date('3333333','j')) between dal and nvl(al,to_date('3333333','j'))
                              )
                      ) LOOP
-- dbms_output.put_line(' cursore periodi ');
                      BEGIN
                      D_dal_p := CUR_PERIODI.dal_p;
                      D_al_p  := CUR_PERIODI.al_p;
-- dbms_output.put_line('Periodo di smttr_periodi dal/al'||to_char(D_dal_p,'dd/mm/yyyy')||' '||to_char(D_al_p,'dd/mm/yyyy'));
                      IF D_dal_a <= D_dal_p and nvl(D_al_a,to_date('3333333','j')) >= nvl(D_al_p,to_date('3333333','j')) 
                       THEN
-- periodo incluso in un periodo di assenza o assenza che copre tutto il mese di rilevazione, quindi viene cancellato
-- dbms_output.put_line('Caso 1');
                       delete from smttr_periodi
                        where ci = CUR_CI.ci
                          and anno = D_anno
                          and mese = D_mese
                          and gestione = CUR_CI.gestione
                          and dal = CUR_PERIODI.dal
                          and nvl(al,to_date('3333333','j')) = nvl(CUR_PERIODI.al,to_date('3333333','j'))
                     ;
                       BEGIN
                        BEGIN
                         select 'X'
                           into V_segnala
                           from dual
                           where exists ( select 'x' 
                                            from valori_contabili_mensili     vacm
                                           where vacm.anno       = D_anno
                                             and mese            = D_mese
                                             and vacm.mensilita  != '*AP'
                                             and vacm.estrazione = 'SMTTRI'
                                             and vacm.ci         = CUR_CI.ci
                                             having nvl(sum(valore),0) != 0
                                         );
                         EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
                         END;
                          IF V_segnala = 'X' THEN 
                             BEGIN
                              D_riga := nvl(D_riga,0) + 1;
                              V_testo := lpad('Errore 005',10)||
                                         lpad('Mese '||D_mese,7,' ')||
                                         lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                         lpad(nvl(CUR_CI.ci,0),8,0)||
                                         lpad(nvl(to_char(D_dal_a,'ddmmyyyy'),' '),8,' ')||
                                         lpad(nvl(to_char(D_al_a,'ddmmyyyy'),' '),8,' ')||
                                         rpad('Dipendente in Astensione nel mese '||D_mese||': Nessun Importo Archiviato',132,' ')
                                         ;
                                   insert into a_appoggio_stampe(NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                                   select prenotazione
                                        , 2
                                        , D_pagina
                                        , D_riga
                                        , V_testo
                                     from dual
                                    where not exists ( select 'x' 
                                                         from a_appoggio_stampe
                                                        where no_prenotazione = prenotazione
                                                          and no_passo = 2
                                                          and pagina = D_pagina
                                                          and testo = V_testo
                                                     ) 
                                    ;
                                   commit;
                              END;
                           END IF;
                       END;
                      ELSIF D_dal_a > D_dal_p THEN
-- periodo di assenza coperto da un periodo
-- dbms_output.put_line('Caso 2');
                       update smttr_periodi
                          set al = D_dal_a-1
                            , cessazione = 'ASP'
                        where ci = CUR_CI.ci
                          and gestione = CUR_CI.gestione
                          and anno = D_anno
                          and mese = D_mese
                          and dal = CUR_PERIODI.dal
                          and nvl(al,to_date('3333333','j')) = nvl(CUR_PERIODI.al,to_date('3333333','j'))
                     ;
                       commit;
                       IF nvl(D_al_a,to_date('3333333','j')) < nvl(D_al_p,to_date('3333333','j')) THEN
-- dbms_output.put_line('Inserisco il periodo D '||to_char(D_al_a+1,'dd/mm/yyyy')||' - '||to_char(D_al_p,'dd/mm/yyyy'));
                          insert into smttr_periodi
                          ( anno,mese,ci,gestione,dal,al,qualifica,tempo_determinato
                          , tempo_pieno,part_time,assunzione,cessazione,gg_assenza,utente,tipo_agg,data_agg)
                          select anno,mese,ci,gestione,D_al_a+1,D_al_p,qualifica,tempo_determinato
                               , tempo_pieno,part_time,'TASP',null,gg_assenza,D_utente,null,sysdate
                            from smttr_periodi
                           where ci = CUR_CI.ci
                             and gestione = CUR_CI.gestione
                             and anno = D_anno
                             and mese = D_mese
                             and dal = CUR_PERIODI.dal
                          ;
                       commit;
                       END IF; -- periodo D
                      ELSIF nvl(D_al_a,to_date('3333333','j')) between D_dal_p and nvl(D_al_p,to_date('3333333','j')) THEN
-- dbms_output.put_line('Caso 3');
                       update smttr_periodi
                          set dal = nvl(D_al_a, D_fin_mp) +1
                            , assunzione = 'TASP'
                        where ci   = CUR_CI.ci
                          and gestione = CUR_CI.gestione
                          and anno = D_anno
                          and mese = D_mese
                          and dal  = CUR_PERIODI.dal
                          and nvl(al,to_date('3333333','j')) = nvl(CUR_PERIODI.al,to_date('3333333','j'))
                        ;
                       commit;
                      END IF; -- caso1
                  END;
                  END LOOP; -- CUR_PERIODI
-- dbms_output.put_line('fine cursore periodi');
                END;
                END LOOP; -- CUR_ASSENZE
-- dbms_output.put_line('fine cursore assenze');
-- dbms_output.put_line('Fine elaborazione periodi di assenza');
            END;
            BEGIN
-- dbms_output.put_line('Assegnazione di Assunzione - Cessazione - Da_qualifica');
              FOR V_PER in CUR_PER ( to_number(CUR_CI.ci), D_anno, D_mese, CUR_CI.gestione ) LOOP
-- dbms_output.put_line('dal/al: '||V_PER.dal||' '||V_PER.al);
-- evento di assunzione
                  BEGIN
                    SELECT evento
                      INTO D_assunzione
                      FROM periodi_giuridici pegi
                     WHERE pegi.rilevanza = 'P'
                       AND pegi.ci  = CUR_CI.ci
                       AND pegi.dal = V_PER.dal
                       AND exists ( select 'x'
                                      from eventi_rapporto evra
                                     where evra.codice = pegi.evento
                                       and evra.rilevanza = 'I'
                                  )
                     ;
                  EXCEPTION
                      WHEN no_data_found then
                        D_assunzione := 'ASS';
                  END;
-- dbms_output.put_line('Assunzione '||D_assunzione);
-- evento di cessazione
                  BEGIN
                    SELECT posizione
                      INTO D_cessazione
                      FROM periodi_giuridici pegi
                     WHERE pegi.rilevanza = 'P'
                       AND pegi.ci        = CUR_CI.ci
                       AND nvl(pegi.al,to_date('3333333','j')) 
                           = least(nvl(V_PER.al,to_date('3333333','j')),D_fin_mes-1)
                       AND exists ( select 'x'
                                      from eventi_rapporto evra
                                     where evra.codice    = pegi.posizione
                                       and evra.rilevanza = 'T')
                     ;
                  EXCEPTION
                    WHEN no_data_found then
                      D_cessazione := 'CESS';
                  END;
-- dbms_output.put_line('Cessazione '||D_cessazione);
                  IF CUR_PER%rowcount = 1 and V_PER.dal > D_fin_mp THEN
-- sono sul primo periodo
-- dbms_output.put_line('Aggiorno il primo periodo');
                      update smttr_periodi
                         set assunzione = D_assunzione
                       where dal = V_PER.dal
                         and ci  = CUR_CI.ci
                         and gestione = CUR_CI.gestione
                         and anno     = D_anno
                         and mese     = D_mese
                         and not exists ( select 'x'
                                            from periodi_giuridici
                                           where rilevanza = 'S'
                                             and ci = CUR_CI.ci
                                             and V_PER.dal-1 between dal and nvl(al,to_date('3333333','j'))
                                         )
                         and nvl(assunzione,'ASS') = 'ASS'
                        ;
                      commit;
                  ELSE
-- non sono sul primo periodo, controllo se ho un periodo precedente
-- dbms_output.put_line('Sono sugli altri periodi');
                      IF V_PER.dal != T_al+1 THEN
-- dbms_output.put_line('Ho un periodo immediatamente precedente');
                          update smttr_periodi
                             set assunzione = D_assunzione
                           where dal = V_PER.dal
                             and ci  = CUR_CI.ci
                             and gestione = CUR_CI.gestione
                             and anno = D_anno
                             and mese = D_mese
                             and nvl(assunzione,'ASS') = 'ASS'
                          ;
                         commit;
                      ELSE
                         update smttr_periodi
                           set assunzione = D_assunzione
                         where dal = V_PER.dal
                           and ci  = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                           and anno = D_anno
                           and mese = D_mese
                           and nvl(assunzione,'ASS') = 'ASS'
                           and exists ( select 'x'
                                          from periodi_giuridici
                                         where rilevanza = 'P'
                                           and ci = CUR_CI.ci
                                           and V_PER.dal = dal
                                       )
                          ;
                          commit;
                      END IF; -- periodo precedente
      -- Tratto la cessazione
                      update smttr_periodi
                         set cessazione = D_cessazione
                       where nvl(al,to_date('3333333','j')) = V_PER.al
                         and ci = CUR_CI.ci
                         and gestione = CUR_CI.gestione
                         and anno = D_anno
                         and mese = D_mese
                         and nvl(al,to_date('3333333','j')) < D_fin_mes
                         and nvl(cessazione,'CESS') = 'CESS'
                         and ( not exists ( select 'x'
                                              from periodi_giuridici
                                             where rilevanza = 'S'
                                               and ci = CUR_CI.ci
                                               and nvl(V_PER.al,to_date('3333333','j'))+1 between dal
                                                                                              and nvl(al,to_date('3333333','j'))
                                           )
                               or exists ( select 'x'
                                             from periodi_giuridici
                                            where rilevanza = 'P'
                                              and ci = CUR_CI.ci
                                              and V_PER.al = al
                                         )
                             )
                      ;
                      commit;
                    IF V_PER.tempo_determinato = 'NO' and V_PER.dal = T_al+1 and T_temp_det = 'SI' THEN
-- dbms_output.put_line('Altri periodi con tempo determinato NO');
                      update smttr_periodi
                         set assunzione = ( select nvl(evento,'ASS')
                                              from periodi_giuridici pegi
                                                 , eventi_giuridici evgi
                                            where pegi.rilevanza = 'S'
                                              and dal = V_PER.dal
                                              and ci  = CUR_CI.ci
                                              and evgi.codice (+) = pegi.evento
                                          )
                       where dal = V_PER.dal
                         and ci  = CUR_CI.ci
                         and gestione = CUR_CI.gestione
                         and anno = D_anno
                         and mese = D_mese
                         and assunzione is null
                      ;
                      commit;
                      update smttr_periodi
                         set cessazione = ( select evento
                                              from periodi_giuridici pegi
                                                 , eventi_giuridici evgi
                                             where pegi.rilevanza = 'S'
                                               and dal = T_al+1
                                               and ci  = CUR_CI.ci
                                               and evgi.codice (+) = pegi.evento
                                          )
                       where nvl(al,to_date('3333333','j')) = V_PER.dal-1
                         and ci  = CUR_CI.ci
                         and gestione = CUR_CI.gestione
                         and anno = D_anno
                         and cessazione is null
                      ;
                      commit;
                    END IF; -- tempo determinato
                  END IF; -- primo periodo
      -- conservo le variabili per il periodo precedente
                  T_dal       := V_PER.dal;
                  T_al        := V_PER.al;
                  T_temp_det  := V_PER.tempo_determinato;
-- dbms_output.put_line('Periodo dal/al '||to_char(V_PER.dal,'dd/mm/yyyy')||' '||to_char(V_PER.al,'dd/mm/yyyy'));
              END LOOP; -- CUR_PER
-- dbms_output.put_line('Ultimo periodo - Periodo precedente dal/al '||T_dal||' '||T_al);
-- se ho piu periodi per un CI esco per l'ultimo periodo del CI e lo devo trattare
              update smttr_periodi
                 set cessazione = D_cessazione
               where dal = T_dal
                 and ci = CUR_CI.ci
                 and gestione = CUR_CI.gestione
                 and anno = D_anno
                 and mese = D_mese
                 and nvl(al,to_date('3333333','j')) < D_fin_mes
                 and nvl(cessazione,'CESS') = 'CESS'
                 and not exists ( select 'x'
                                    from periodi_giuridici
                                   where rilevanza = 'S'
                                     and ci = CUR_CI.ci
                                     and T_al+1 between dal and nvl(al,to_date('3333333','j'))
                                )
                ;
            commit;
            END;
            BEGIN
              FOR V_PER in CUR_PER(to_number(CUR_CI.ci), D_anno, D_mese, CUR_CI.gestione) LOOP
              BEGIN
-- dbms_output.put_line('Periodo in elab calcolo assenze '||to_char(V_PER.dal,'dd/mm/yyyy')||' - '||to_char(V_PER.al,'dd/mm/yyyy'));
                select sum(least( nvl(V_PER.al,to_date('3333333','j'))
                                        , nvl(pegi.al,to_date('3333333','j'))
                                        , D_fin_mes
                                        ) -
                                   greatest( V_PER.dal
                                           , pegi.dal
                                           , D_ini_mes
                                           ) + 1
                                           )         gg
                 into D_gg_ass
                 from periodi_giuridici            pegi
                    , pgm_ref_codes                pgco
                    , eventi_giuridici             evgi
                where pegi.ci               = CUR_CI.ci
                  and pgco.rv_domain (+)    = 'EVENTI_GIURIDICI.CONTO_ANNUALE'
                  and pgco.rv_low_value (+) = nvl(evgi.conto_annuale,9)
                  and evgi.codice       (+) = nvl(pegi.evento,' ')
                  and nvl(evgi.conto_annuale,9) != 0
                  and pegi.rilevanza = 'A'
                  and pegi.dal             <= least(nvl(V_PER.al,to_date('3333333','j'))
                                                   ,D_fin_mes)
                  and nvl(pegi.al,to_date('3333333','j')) >= greatest(V_PER.dal,D_ini_mes)
                  and V_PER.dal           <= D_fin_mes
                  and nvl(V_PER.al,to_date('3333333','j')) >= D_ini_mes
                  and nvl(D_est_com,'NO')  = 'NO'
                ;
-- dbms_output.put_line('Giorni Assenza '||to_char(D_gg_ass));
                update smttr_periodi
                   set gg_assenza = D_gg_ass
                 where dal = V_PER.dal
                   and ci = CUR_CI.ci
                   and gestione = CUR_CI.gestione
                   and anno = D_anno
                   and mese = D_mese
                ;
               commit;
              EXCEPTION
                when no_data_found then
                  D_gg_ass := null;
              END;
              END LOOP; -- V_PER
            END;
-- Sistemo le date e elimino eventuali periodi "vecchi" (Annalena)
              BEGIN
              update smttr_periodi
                 set dal = greatest(dal,D_ini_mes)
                   , al = least(nvl(al,to_date('3333333','j')),D_fin_mes)
               where ci = CUR_CI.ci
                 and gestione = CUR_CI.gestione
                 and anno = D_anno
                 and mese = D_mese
                 and dal <= D_fin_mes
                 and nvl(al,to_date('3333333','j')) >= D_ini_mes
              ;
              commit;
              END;
              BEGIN
              delete from smttr_periodi
               where ci = CUR_CI.ci
                 and gestione = CUR_CI.gestione
                 and anno = D_anno
                 and mese = D_mese
                 and ( dal > D_fin_mes
                    or nvl(al,to_date('3333333','j')) < D_fin_mp)
              ;
              END;
              BEGIN
              delete from smttr_periodi
               where ci = CUR_CI.ci
                 and gestione = CUR_CI.gestione
                 and anno = D_anno
                 and mese = D_mese
                 and al = D_fin_mp
                 and nvl(cessazione,' ') = ' '
                 and not exists ( select 'x' 
                                    from periodi_giuridici pegi
                                   where rilevanza = 'P'
                                     and ci = CUR_CI.ci
                                     and al = D_fin_mp )
              ;
              END;
-- cursore anomalie
        BEGIN
         FOR CUR_ANOM2 IN
            ( select 'Errore 002' errore,dal,al,'Individui con Tempo Pieno NO e part time 100 nel mese '||D_mese testo
                from smttr_periodi
               where ci          = CUR_CI.ci
                and gestione     = CUR_CI.gestione
                and anno         = D_anno
                and mese         = D_mese
                and tempo_pieno  = 'NO'
                and part_time    = 100
            ) LOOP
-- dbms_output.put_line('CI Anomalie'||CUR_CI.ci);
              d_riga := nvl(D_riga,0) + 1;
              V_testo := lpad(CUR_ANOM2.errore,10)||
                         lpad('Mese '||D_mese,7,' ')||
                         lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                         lpad(nvl(CUR_CI.ci,0),8,0)||
                         lpad(nvl(to_char(CUR_ANOM2.dal,'ddmmyyyy'),' '),8,' ')||
                         lpad(nvl(to_char(CUR_ANOM2.al,'ddmmyyyy'),' '),8,' ')||
                         rpad(CUR_ANOM2.testo,132,' ')||
                         lpad(' ',31)||
                         lpad(' ',10,' ')
                         ;
                       insert into a_appoggio_stampe(NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                       select prenotazione
                            , 2
                            , D_pagina
                            , D_riga
                            , V_testo
                         from dual
                        where not exists ( select 'x' 
                                             from a_appoggio_stampe
                                            where no_prenotazione = prenotazione
                                              and no_passo = 2
                                              and pagina = D_pagina
                                              and testo = V_testo
                                         ) 
                        ;
                       commit;
         END LOOP; -- cur_anom2
        END;
-- cancello tutti i record di testata che non hanno record di dettaglio
        BEGIN
            select 'x'
              into D_controllo
              from smttr_individui smin
             where ci = CUR_CI.ci
               and gestione = CUR_CI.gestione
               and anno = D_anno
               and mese = D_mese
               and not exists (select 'x'
                                 from smttr_periodi smpe
                                where smpe.ci = smin.ci
                                  and smpe.anno = smin.anno
                                  and smpe.mese = smin.mese
                                  and smpe.gestione = smin.gestione
                             )
               and nvl(est_comandato,'NO') = 'NO'
            ;
             raise too_many_rows;
        EXCEPTION
             WHEN no_data_found THEN
                  null;
             WHEN too_many_rows THEN
-- dbms_output.put_line('Cancello la testata');
                  delete
                    from smttr_individui smin
                   where ci = CUR_CI.ci
                     and gestione = CUR_CI.gestione
                     and anno = D_anno
                     and mese = D_mese
                     and not exists (select 'x'
                                         from smttr_periodi smpe
                                          where smpe.ci = smin.ci
                                            and smpe.anno = smin.anno
                                            and smpe.mese = smin.mese
                                            and smpe.gestione = smin.gestione
                                   )
                     and nvl(est_comandato,'NO') = 'NO'
                  ;
        END;
-- assestamento assunzioni
        BEGIN
        update smttr_periodi smtp
           set assunzione = null
         where ci = CUR_CI.ci
           and anno = D_anno
           and mese = D_mese
           and assunzione != 'TASP'
           and gestione = CUR_CI.gestione
           and not exists (select 'x' 
                             from periodi_giuridici
                            where ci = smtp.ci
                              and rilevanza = 'P'
                              and dal = smtp.dal
                            union
                           select 'x' from smttr_periodi
                            where ci = CUR_CI.ci
                              and anno = D_anno
                              and mese = D_mese
                              and gestione = CUR_CI.gestione
                              and al       = smtp.dal - 1
                              and smtp.tempo_determinato = 'NO'
                              and tempo_determinato = 'SI'
                          );
         commit;
         END;
           END;
         END LOOP; -- CUR_CI
       END;
      END IF; -- D_elab giuridico
    END;
   END LOOP; -- var_mese
-- Trattamento parte economica
-- dbms_output.put_line('D_elab '||D_elab);
      IF D_elab in ('T','E') THEN
-- dbms_output.put_line('Economica');
       BEGIN
        COMMIT;
        P_numeratore :=0;
        BEGIN
        select nvl(max(STRM_ID),0)
          into P_numeratore
          from smttr_importi
        ;
        END;
      
      -- cancello eventuali archiviazioni precedenti
       LOCK TABLE SMTTR_importi IN EXCLUSIVE MODE NOWAIT ;
-- dbms_output.put_line('Cancello gli importi ');
       DELETE from SMTTR_importi smim
        WHERE anno        = D_anno
          and mese between D_mese_da and D_mese_a 
          AND gestione LIKE nvl(D_gestione,'%')
          AND gestione  in ( select codice
                               from gestioni
                              where nvl(fascia,' ') like D_fascia
                           )
          and ci in ( select ci 
                        from rapporti_individuali rain
                       where rain.rapporto         LIKE D_rapporto
                         and nvl(rain.gruppo,' ')  LIKE D_gruppo
                         and (  rain.cc is null
                             or exists
                               (select 'x'
                                  from a_competenze
                                 where ente        = D_ente
                                   and ambiente    = D_ambiente
                                   and utente      = D_utente
                                   and competenza  = 'CI'
                                   and oggetto     = rain.cc
                               )
                            )
                     )
          AND (  D_tipo = 'T'
                 or ( D_tipo in ('I','V','P')
                      and ( not exists (select 'x' from smttr_individui
                                         where anno     = D_anno
                                           and mese     between D_mese_da and D_mese_a 
                                           and ci       = smim.ci
                                           and gestione = smim.gestione
                                           and nvl(tipo_agg,' ') = decode(D_tipo ,'P',tipo_agg ,D_tipo)
                                        union
                                        select 'x' from smttr_periodi
                                         where anno = D_anno
                                           and mese     between D_mese_da and D_mese_a 
                                           and ci       = smim.ci
                                           and gestione = smim.gestione
                                           and nvl(tipo_agg,' ') = decode(D_tipo ,'P',tipo_agg ,D_tipo)
                                        union
                                        select 'x' from smttr_importi
                                         where anno = D_anno
                                           and mese     between D_mese_da and D_mese_a 
                                           and ci       = smim.ci
                                           and gestione = smim.gestione
                                           and nvl(tipo_agg,' ') = decode(D_tipo ,'P',tipo_agg ,D_tipo)
                                     )
                          )
                    )
                 or ( D_tipo  = 'S'
                      and smim.ci = D_ci )
               )
       ;
       commit;
       FOR VAR_MESE in D_mese_da .. D_mese_a LOOP
        BEGIN
         select lpad(substr(VAR_MESE,1,2),2,0)
              , to_date('01'||lpad(substr(VAR_MESE,1,2),2,0)||to_char(D_anno),'ddmmyyyy')
              , last_day(to_date(lpad(substr(VAR_MESE,1,2),2,0)||to_char(D_anno),'mmyyyy'))
              , to_date('01'||lpad(substr(VAR_MESE,1,2),2,0)||to_char(D_anno),'ddmmyyyy')-1
           INTO D_mese, D_ini_mes, D_fin_mes, D_fin_mp
           FROM DUAL;
-- dbms_output.put_line('var_mese econ: '||VAR_MESE||' mese: '||D_mese||' '||D_fin_mes||' '||D_fin_mp);
          FOR GEST IN
          ( select codice  codice
              from gestioni
             where codice like nvl(D_gestione,'%')
               and gestito   = 'SI'
               and codice  in ( select codice
                                  from gestioni
                                 where nvl(fascia,' ') like D_fascia
                              )
          ) LOOP
           FOR CUR_CI1 IN
           ( select distinct smpe.gestione  gestione
                           , smpe.ci        ci
               from smttr_periodi           smpe
              where smpe.gestione        = GEST.codice
                and gestione  in ( select codice
                                     from gestioni
                                     where nvl(fascia,' ') like D_fascia
                                 )
                and smpe.anno            = D_anno
                and ( P_competenza is null and smpe.mese            = D_mese
                   or P_competenza = 'X' and smpe.mese between D_mese_da and D_mese_a )
                and smpe.dal             <= D_fin_mes
                and nvl(smpe.al,to_date('3333333','j')) >= D_ini_mes
                and smpe.ci in ( select ci 
                                   from rapporti_individuali rain
                                  where rain.rapporto         LIKE D_rapporto
                                    and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                    and ( rain.cc is null
                                       or exists
                                         (select 'x'
                                            from a_competenze
                                           where ente        = D_ente
                                             and ambiente    = D_ambiente
                                             and utente      = D_utente
                                             and competenza  = 'CI'
                                             and oggetto     = rain.cc
                                         )
                                      )
                                )
                AND ( D_tipo = 'T'
                       or ( D_tipo in ('I','V','P')
                            and ( not exists (select 'x' from smttr_individui
                                               where anno     = D_anno
                                                 and mese     = D_mese
                                                 and ci       = smpe.ci
                                                 and gestione = smpe.gestione
                                                 and nvl(tipo_agg,' ') = decode(D_tipo
                                                                               ,'P',tipo_agg
                                                                               ,D_tipo)
                                              union
                                              select 'x' from smttr_periodi
                                               where anno = D_anno
                                                 and mese     = D_mese
                                                 and ci   = smpe.ci
                                                 and gestione = smpe.gestione
                                                 and nvl(tipo_agg,' ') = decode(D_tipo
                                                                               ,'P',tipo_agg
                                                                               ,D_tipo)
                                              union
                                              select 'x' from smttr_importi
                                               where anno = D_anno
                                                 and mese     = D_mese
                                                 and ci   = smpe.ci
                                                 and gestione = smpe.gestione
                                                 and nvl(tipo_agg,' ') = decode(D_tipo
                                                                               ,'P',tipo_agg
                                                                               ,D_tipo)
                                           )
                                )
                          )
                       or ( D_tipo  = 'S'
                            and smpe.ci = D_ci )
                     )
               order by ci
           ) LOOP
-- dbms_output.put_line('CI del CURS1: '||CUR_CI1.ci||' '||CUR_CI1.gestione );
      /* spostata la delete fuori dal cursore */
             D_conta_periodi := 0;
             FOR QUST IN
              ( select x.codice
                  from qualifiche_statistiche x
                 where x.statistica = 'SMTTRI'
               ) LOOP
                 FOR CURS IN
                 ( select smpe.gestione                gestione
                        , smpe.ci                      ci
                        , smpe.dal                     dal_originale
                        , decode
                          ( smpe.dal
                          , smpe1.dal , to_date('2222222','j')
                                      , smpe.dal
                          )                            dal
                        , least(D_fin_mes
                               ,nvl(smpe.al,to_date('3333333','j')))    al
                     from smttr_periodi           smpe
                        , smttr_periodi           smpe1
                    where smpe.ci              = CUR_CI1.ci
                      and smpe.ci              = smpe1.ci
                      and smpe.anno            = smpe1.anno
                      and smpe.mese            = smpe1.mese
                      and smpe.gestione        = GEST.codice
                      and smpe.qualifica       = QUST.codice
                      and smpe.anno            = D_anno
                      and smpe.mese            = D_mese
                      and smpe.dal             <= D_fin_mes
                      and nvl(smpe.al,to_date('3333333','j')) >= D_ini_mes
                      and smpe1.dal             =
                         (select min(dal) from smttr_periodi
                           where ci        = smpe1.ci
                             and anno      = smpe1.anno
                             and mese      = smpe1.mese
                             and dal             <= D_fin_mes
                             and nvl(al,to_date('3333333','j')) >= D_ini_mes
                         )
                      AND ( D_tipo = 'T'
                       or ( D_tipo in ('I','V','P')
                            and ( not exists (select 'x' from smttr_individui
                                               where anno     = D_anno
                                                 and mese     = D_mese
                                                 and ci       = smpe.ci
                                                 and gestione = smpe.gestione
                                                 and nvl(tipo_agg,' ') = decode(D_tipo
                                                                               ,'P',tipo_agg
                                                                               ,D_tipo)
                                              union
                                              select 'x' from smttr_periodi
                                               where anno = D_anno
                                                 and mese     = D_mese
                                                 and ci   = smpe.ci
                                                 and gestione = smpe.gestione
                                                 and nvl(tipo_agg,' ') = decode(D_tipo
                                                                               ,'P',tipo_agg
                                                                               ,D_tipo)
                                              union
                                              select 'x' from smttr_importi
                                               where anno = D_anno
                                                 and mese     = D_mese
                                                 and ci   = smpe.ci
                                                 and gestione = smpe.gestione
                                                 and nvl(tipo_agg,' ') = decode(D_tipo
                                                                               ,'P',tipo_agg
                                                                               ,D_tipo)
                                           )
                                )
                          )
                       or ( D_tipo  = 'S'
                            and smpe.ci = D_ci )
                          )
                      and exists
                        ( select 'x' from movimenti_contabili
                           where anno = D_anno
                             and ( P_competenza is null and mese = D_mese
                                 or P_competenza ='X' and mese between D_mese_da and D_mese_a 
                                 )
                             and ci   = smpe.ci
                             and riferimento between decode( smpe.dal
                                                           , smpe1.dal , to_date('2222222','j')
                                                                       , smpe.dal
                                                           )
                                                 and least( D_fin_mes
                                                          , nvl(smpe.al,to_date('3333333','j')))
                      )
                 order by 4,5
                 ) LOOP
                 D_conta_periodi := nvl(D_conta_periodi,0) + 1;
-- dbms_output.put_line('economico / ci - gestione - dal/al: '||CURS.CI||' '||curs.gestione||' '||curs.dal||' '||CURS.AL);
-- dbms_output.put_line('dal: '||CURS.dal_originale);
                  FOR VACM IN
                  ( select vacm.colonna
                         , vacm.voce
                         , vacm.sub
                         , sum( nvl(vacm.valore,0) )  importo
                         , lpad(d_mese,2,'0')||D_anno  rif
                      from valori_contabili_mensili     vacm
                     where vacm.anno             = D_anno
                       and vacm.mensilita  != '*AP'
                       and vacm.estrazione       = 'SMTTRI'
                       and vacm.ci               = CURS.ci
                       and P_competenza is null 
                       and vacm.mese             = D_mese
                       and vacm.riferimento between CURS.dal and nvl(CURS.al,to_date('3333333','j'))
                    group by vacm.ci
                           , vacm.colonna
                           , vacm.voce
                           , vacm.sub
                    having nvl(sum(valore),0) != 0
                    UNION
                    select vacm.colonna
                         , vacm.voce
                         , vacm.sub
                         , sum( nvl(vacm.valore,0) ) importo
                         , to_char(vacm.riferimento,'mmyyyy') rif
                      from valori_contabili_mensili     vacm
                     where vacm.anno             = D_anno
                       and vacm.mensilita  != '*AP'
                       and vacm.estrazione       = 'SMTTRI'
                       and vacm.ci               = CURS.ci
                       and P_competenza = 'X'
                       and ( vacm.mese between D_mese_da and D_mese_a
                       and vacm.riferimento between CURS.dal and nvl(CURS.al,to_date('3333333','j'))
                         and to_char(vacm.riferimento,'mmyyyy') = lpad(D_mese,2,'0')||D_anno
                          or vacm.mese             = D_mese
                         and to_char(vacm.riferimento,'mm') < lpad(D_mese_da,2,'0')
                         and D_conta_periodi       = 1
                          or vacm.mese             = D_mese
                         and to_char(vacm.riferimento,'yyyy') < D_anno
                         and D_conta_periodi       = 1
                           ) 
                    group by vacm.ci
                           , vacm.colonna
                           , vacm.voce
                           , vacm.sub
                           , to_char(vacm.riferimento,'mmyyyy') 
                    having nvl(sum(valore),0) != 0
                  ) LOOP
                    P_numeratore := nvl(P_numeratore,0) + 1;
                    BEGIN
-- dbms_output.put_line('Insert1 - ID: '||' '||P_numeratore);
-- dbms_output.put_line('anno/mese: '||d_anno||' '||d_mese);
-- dbms_output.put_line('cursore VACM - importo: '||VACM.rif||' '||VACM.voce||' '||VACM.sub||' '||VACM.importo);
                     IF ( P_competenza is null 
                       or P_competenza = 'X' and VACM.rif = lpad(d_mese,2,'0')||D_anno
                        ) THEN 
                        update smttr_importi
                        set importo = nvl(importo,0) + VACM.importo
                          , utente = D_utente 
                          , data_agg = sysdate
                        where anno = D_anno
                          and mese = substr(VACM.rif,1,2)
                          and ci = CURS.CI
                          and gestione = CURS.gestione
                          and dal = CURS.dal_originale
                          and voce = VACM.voce
                          and sub = VACM.sub
                          and colonna =  VACM.colonna
                          and exists ( select 'x' 
                                         from smttr_importi
                                        where anno = D_anno
                                          and mese = substr(VACM.rif,1,2)
                                          and ci = CURS.ci
                                          and gestione = CURS.gestione
                                          and dal = CURS.dal_originale
                                          and colonna = VACM.colonna
                                          and voce = VACM.voce
                                          and sub = VACM.sub
                                      ) 
                        ;
                        insert into smttr_importi
                        (STRM_ID,ANNO,MESE,CI,GESTIONE,DAL,AL
                        ,COLONNA,VOCE,SUB,IMPORTO,UTENTE,DATA_AGG
                        )
                        select P_numeratore
                             , D_anno
                             , substr(VACM.rif,1,2)
                             , CURS.ci
                             , CURS.gestione
                             , CURS.dal_originale
                             , CURS.al
                             , VACM.colonna
                             , VACM.voce
                             , VACM.sub
                             , VACM.importo
                             , D_utente
                             , sysdate
                          from dual
                        where not exists ( select 'x' 
                                             from smttr_importi
                                            where anno = D_anno
                                              and mese = substr(VACM.rif,1,2)
                                              and ci = CURS.ci
                                              and gestione = CURS.gestione
                                              and dal = CURS.dal_originale
                                              and colonna = VACM.colonna
                                              and voce = VACM.voce
                                              and sub = VACM.sub
                                       ) 
                        ;
                        commit;
                      ELSE 
-- ricerco colonna arretrati
                      V_colonna_arr := '';
                      V_testo := '';
                       BEGIN
                          select esvc.colonna
                            into V_colonna_arr
                            from estrazione_valori_contabili esvc
                           where estrazione       = 'SMTTRI'
                             and VACM.colonna     = substr(note, instr(note,'<ARR:')+5
                                                               , instr(note,'>')- ( instr(note,'<ARR:') +5 ))
                             and to_date('01'||lpad(d_mese,2,'0')||D_anno,'ddmmyyyy')
                                between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
                          ;
                       EXCEPTION WHEN NO_DATA_FOUND THEN
                        D_riga := nvl(D_riga,0) + 1;
                        V_testo := lpad('Errore 010',10)||
                                   lpad('Mese '||D_mese,7,' ')||
                                   lpad(nvl(CURS.gestione,' '),4,' ')||
                                   lpad(nvl(CURS.ci,0),8,0)||
                                   lpad(nvl(to_char(CURS.dal_originale,'ddmmyyyy'),' '),8,' ')||
                                   lpad(nvl(to_char(CURS.al,'ddmmyyyy'),' '),8,' ')||
                                   rpad('Colonna Arretrati non Definita nel mese '||D_mese||' per colonna '||VACM.colonna,132,' ')
                                   ;
-- dbms_output.put_line('testo: '||V_testo);
                         insert into a_appoggio_stampe
                         (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                         select   prenotazione
                                 , 2
                                 , D_pagina
                                 , D_riga
                                 , V_testo
                          from dual
                         where not exists ( select 'x' 
                                              from a_appoggio_stampe
                                             where no_prenotazione = prenotazione
                                               and no_passo = 2
                                               and pagina = D_pagina
                                               and testo = V_testo
                                           ) ;
-- dbms_output.put_line('inserimento: '||sql%rowcount); 
                       commit;
                       END;
-- dbms_output.put_line('voce/sub: '||VACM.voce||' '||VACM.sub||' rif: '||VACM.rif||' colonna arr: '||V_colonna_arr);
                        IF V_colonna_arr is not null THEN
/* gestione arretrati AC e AP scorporati */
                        update smttr_importi
                           set importo = nvl(importo,0) + VACM.importo
                             , utente = D_utente 
                             , data_agg = sysdate
                        where anno = D_anno
                          and mese = D_mese
                          and ci = CURS.CI
                          and gestione = CURS.gestione
                          and dal = CURS.dal_originale
                          and colonna =  V_colonna_arr
                          and voce = VACM.voce
                          and sub = VACM.sub
                          and nvl(anno_rif,D_anno) = substr(VACM.rif,3,4)
                          and exists ( select 'x' 
                                         from smttr_importi
                                        where anno = D_anno
                                          and mese = D_mese
                                          and ci = CURS.ci
                                          and gestione = CURS.gestione
                                          and dal = CURS.dal_originale
                                          and colonna = V_colonna_arr
                                          and voce = VACM.voce
                                          and sub = VACM.sub
                                          and nvl(anno_rif,D_anno) = substr(VACM.rif,3,4)
                                      ) 
                        ;
-- dbms_output.put_line('update: '||sql%rowcount);
                        insert into smttr_importi
                        (STRM_ID,ANNO,MESE,CI,GESTIONE,DAL,AL
                        ,COLONNA,VOCE,SUB,IMPORTO,ANNO_RIF, UTENTE,DATA_AGG
                        )
                        select P_numeratore
                             , D_anno
                             , D_mese
                             , CURS.ci
                             , CURS.gestione
                             , CURS.dal_originale
                             , CURS.al
                             , V_colonna_arr
                             , VACM.voce
                             , VACM.sub
                             , VACM.importo
                             , decode( substr(VACM.rif,3,4), D_anno, null, substr(VACM.rif,3,4))
                             , D_utente
                             , sysdate
                          from dual
                        where not exists ( select 'x' 
                                             from smttr_importi
                                            where anno = D_anno
                                              and mese = D_mese
                                              and ci = CURS.ci
                                              and gestione = CURS.gestione
                                              and dal = CURS.dal_originale
                                              and colonna = V_colonna_arr
                                              and voce = VACM.voce
                                              and sub = VACM.sub
                                              and nvl(anno_rif,D_anno) = substr(VACM.rif,3,4)
                                      ) 
                        ;
-- dbms_output.put_line('insert: '||sql%rowcount);
                        commit;
                        END IF; -- controllo su v_colonna_arr 
                      END IF; -- controllo su competenza per insert
                    END;
                  END LOOP; -- VACM
                 END LOOP; -- CURS
             END LOOP; -- QUST
      
      /* Tratto i riferimento Esterni per i periodi attuali */
      
        P_numeratore :=0;
        BEGIN
        select nvl(max(STRM_ID),0)
          into P_numeratore
          from smttr_importi
        ;
        END;
             BEGIN
             <<ESTERNI>>
                 FOR V_ESTERNI in CUR_ESTERNI ( CUR_CI1.ci, D_anno, D_mese, CUR_CI1.gestione, D_ini_mes, D_fin_mes ) LOOP
-- dbms_output.put_line('CUR ESTERNI: '||V_ESTERNI.ci||' '||D_mese);
                 BEGIN
                   FOR VACM_EST IN 
                    ( select vacm.colonna
                           , vacm.voce
                           , vacm.sub
                           , vacm.riferimento
                           , lpad(d_mese,2,'0')||d_anno rif
                           , sum( nvl(vacm.valore,0) ) importo              
                        from valori_contabili_mensili    vacm
                       where vacm.ci                = V_ESTERNI.ci
                         and vacm.anno              = D_anno 
                         and vacm.mese              = D_mese
                         and vacm.mensilita        != 'AP'
                         and vacm.estrazione        = 'SMTTRI'
                         and P_competenza          is null
                         and not exists (select 'X'
                                           from smttr_periodi           stpe1
                                              , smttr_periodi           stpe2
                                          where stpe1.ci              = CUR_CI1.ci
                                            and stpe1.ci              = stpe2.ci
                                            and stpe1.anno            = stpe2.anno
                                            and stpe1.mese            = stpe2.mese
                                            and stpe1.anno            = D_anno
                                            and stpe1.mese            = D_mese
                                            and stpe1.gestione        = CUR_CI1.gestione
                                            and stpe2.gestione        = stpe1.gestione
                                            and stpe1.dal             <= D_fin_mes
                                            and nvl(stpe1.al,to_date('3333333','j')) >= D_ini_mes
                                            and stpe2.dal             = ( select min(dal) from smttr_periodi
                                                                          where ci    = stpe2.ci
                                                                             and anno  = stpe2.anno
                                                                             and mese  = stpe2.mese
                                                                             and gestione = stpe2.gestione
                                                                             and dal  <= D_fin_mes
                                                                             and nvl(al,to_date('3333333','j')) >= D_ini_mes
                                                                         ) 
                                           and vacm.riferimento between decode( stpe1.dal
                                                                              , stpe2.dal , to_date('2222222','j')
                                                                                          , stpe1.dal
                                                                               )              
                                                                    and least(D_fin_mes,nvl(stpe1.al,to_date('3333333','j')))
                                          )
                       group by vacm.colonna, vacm.voce, vacm.sub, vacm.riferimento
                      having sum(nvl(vacm.valore,0)) != 0
                      union
                      select vacm.colonna
                           , vacm.voce
                           , vacm.sub
                           , vacm.riferimento         
                           , to_char(vacm.riferimento,'mmyyyy') rif
                           , sum( nvl(vacm.valore,0) ) importo              
                        from valori_contabili_mensili    vacm
                       where vacm.ci                = V_ESTERNI.ci
                         and vacm.anno              = D_anno 
                         and vacm.mensilita        != 'AP'
                         and vacm.estrazione        = 'SMTTRI'
                         and P_competenza           = 'X'
                         and ( vacm.mese between D_mese_da and D_mese_a
                           and to_char(vacm.riferimento,'mmyyyy') = lpad(D_mese,2,'0')||D_anno
                           or vacm.mese             = D_mese
                           and to_char(vacm.riferimento,'mm') < lpad(D_mese_da,2,'0')
                           or vacm.mese             = D_mese
                           and to_char(vacm.riferimento,'yyyy') < D_anno
                             ) 
                         and not exists (select 'X'
                                           from smttr_periodi           stpe1
                                              , smttr_periodi           stpe2
                                          where stpe1.ci              = CUR_CI1.ci
                                            and stpe1.ci              = stpe2.ci
                                            and stpe1.anno            = stpe2.anno
                                            and stpe1.mese            = stpe2.mese
                                            and stpe1.anno            = D_anno
                                            and stpe1.mese            = D_mese
                                            and stpe1.gestione        = CUR_CI1.gestione
                                            and stpe2.gestione        = stpe1.gestione
                                            and stpe1.dal             <= D_fin_mes
                                            and nvl(stpe1.al,to_date('3333333','j')) >= D_ini_mes
                                            and stpe2.dal             = ( select min(dal) from smttr_periodi
                                                                          where ci    = stpe2.ci
                                                                             and anno  = stpe2.anno
                                                                             and mese  = stpe2.mese
                                                                             and gestione = stpe2.gestione
                                                                             and dal  <= D_fin_mes
                                                                             and nvl(al,to_date('3333333','j')) >= D_ini_mes
                                                                         ) 
                                           and vacm.riferimento between decode( stpe1.dal
                                                                              , stpe2.dal , to_date('2222222','j')
                                                                                          , stpe1.dal
                                                                               )              
                                                                    and least(D_fin_mes,nvl(stpe1.al,to_date('3333333','j')))
                                          )
                       group by vacm.colonna, vacm.voce, vacm.sub, vacm.riferimento, to_char(vacm.riferimento,'mmyyyy')
                      having sum(nvl(vacm.valore,0)) != 0
                   ) LOOP
-- dbms_output.put_line('ESTERNO '||VACM_EST.colonna||' '||VACM_EST.importo);
                      V_dal := null;
    /* cerco il dal precedente */
                      BEGIN
                      select max(dal)
                        into V_dal
                        from smttr_periodi
                       where anno    = D_anno
                         and mese    = D_mese
                         and ci      = V_ESTERNI.ci
                         and gestione = CUR_CI1.gestione
                         and VACM_EST.riferimento > nvl(dal,D_ini_mes)
                        ;
                      EXCEPTION WHEN NO_DATA_FOUND THEN
  /* cerco eventualmente il dal successivo */
                         BEGIN
                         select min(dal)
                           into V_dal
                           from smttr_periodi
                          where anno             = D_anno
                            and mese             = D_mese
                            and ci               = V_ESTERNI.ci
                            and gestione = CUR_CI1.gestione
                            and VACM_EST.riferimento < nvl(al,D_fin_mes)
                           ;
                         EXCEPTION WHEN NO_DATA_FOUND THEN
                           V_dal := null;
  /* Segnalazione per riferimenti esternin non gestibili */
                         END;
                      END;
-- dbms_output.put_line('dal: '||V_dal);
                     IF V_dal is not null THEN
                      IF ( P_competenza is null 
                        or P_competenza = 'X' and VACM_EST.rif = lpad(d_mese,2,'0')||D_anno
                         ) 
                      THEN 
                       update smttr_importi 
                          set importo = nvl(importo,0) + nvl(VACM_EST.importo,0)
                            , utente = D_utente 
                            , data_agg = sysdate
                        where anno        = D_anno
                          and mese        = substr(VACM_EST.rif,1,2)
                          and ci          = V_ESTERNI.ci
                          and dal         = V_dal
                          and colonna     = VACM_EST.colonna
                          and voce        = VACM_EST.voce
                          and sub         = VACM_EST.sub
                          and gestione    = CUR_CI1.gestione
                          and exists (select 'x' 
                                        from smttr_importi
                                       where ci       = V_ESTERNI.ci
                                         and anno     = D_anno
                                         and mese     = substr(VACM_EST.rif,1,2)
                                         and gestione = CUR_CI1.gestione
                                         and dal      = V_dal
                                         and colonna  = VACM_EST.colonna
                                         and voce     = VACM_EST.voce
                                         and sub      = VACM_EST.sub
                                       );
                         P_numeratore := nvl(P_numeratore,0) + 1;
                         insert into smttr_importi
                          (STRM_ID,ANNO,MESE,CI,GESTIONE,DAL,AL
                          ,COLONNA,VOCE,SUB,IMPORTO,UTENTE,DATA_AGG
                          )                          
                         select P_numeratore
                              , D_anno
                              , substr(VACM_EST.rif,1,2)
                              , V_ESTERNI.ci
                              , stpe.gestione
                              , stpe.dal
                              , stpe.al
                              , VACM_EST.colonna
                              , VACM_EST.voce
                              , VACM_EST.sub
                              , VACM_EST.importo
                              , D_utente
                              , sysdate
                           from smttr_periodi stpe
                          where anno = D_anno
                            and mese = D_mese
                            and ci = V_ESTERNI.ci
                            and dal = V_dal
                            and gestione = CUR_CI1.gestione
                            and not exists (select 'x' 
                                              from smttr_importi
                                             where ci       = V_ESTERNI.ci
                                               and anno     = D_anno
                                               and mese     = substr(VACM_EST.rif,1,2)
                                               and dal      = V_dal
                                               and gestione = CUR_CI1.gestione
                                               and colonna  = VACM_EST.colonna
                                               and voce     = VACM_EST.voce
                                               and sub      = VACM_EST.sub
                                             ); 
                           commit;
                      ELSE
-- ricerco colonna arretrati
                        V_colonna_arr := '';
                        V_testo := '';
                         BEGIN
                            select esvc.colonna
                              into V_colonna_arr
                              from estrazione_valori_contabili esvc
                             where estrazione       = 'SMTTRI'
                               and VACM_EST.colonna     = substr(note, instr(note,'<ARR:')+5
                                                                 , instr(note,'>')- ( instr(note,'<ARR:') +5 ))
                               and to_date('01'||lpad(d_mese,2,'0')||D_anno,'ddmmyyyy')
                                   between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
                            ;
                         EXCEPTION WHEN NO_DATA_FOUND THEN
                          D_riga := nvl(D_riga,0) + 1;
                          V_testo := lpad('Errore 010',10)||
                                     lpad('Mese '||D_mese,7,' ')||
                                     lpad(nvl(CUR_CI1.gestione,' '),4,' ')||
                                     lpad(nvl(CUR_CI1.ci,0),8,0)||
                                     lpad(nvl(to_char(V_dal,'ddmmyyyy'),' '),8,' ')||
                                     lpad(nvl(to_char(V_al,'ddmmyyyy'),' '),8,' ')||
                                     rpad('Colonna Arretrati non Definita nel mese '||D_mese||' per colonna '||VACM_EST.colonna,132,' ')
                                     ;
-- dbms_output.put_line('testo esterno: '||V_testo);
                           insert into a_appoggio_stampe
                           (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                           select   prenotazione
                                   , 2
                                   , D_pagina
                                   , D_riga
                                   , V_testo
                            from dual
                           where not exists ( select 'x' 
                                                from a_appoggio_stampe
                                               where no_prenotazione = prenotazione
                                                 and no_passo = 2
                                                 and pagina = D_pagina
                                                 and testo = V_testo
                                             );
-- dbms_output.put_line('inserimento: '||sql%rowcount); 
                          commit;
                         END;
                      IF V_colonna_arr is not null THEN
/* gestione arretrati AC e AP scorporati */
                       update smttr_importi 
                          set importo = nvl(importo,0) + nvl(VACM_EST.importo,0)
                            , utente = D_utente 
                            , data_agg = sysdate
                        where anno        = D_anno
                          and mese        = D_mese
                          and ci          = V_ESTERNI.ci
                          and gestione    = CUR_CI1.gestione
                          and dal         = V_dal
                          and colonna     = V_colonna_arr
                          and voce        = VACM_EST.voce
                          and sub         = VACM_EST.sub
                          and nvl(anno_rif,D_anno) = substr(VACM_EST.rif,3,4)
                          and exists (select 'x' 
                                        from smttr_importi
                                       where ci       = V_ESTERNI.ci
                                         and anno     = D_anno
                                         and mese     = D_mese
                                         and gestione = CUR_CI1.gestione
                                         and dal      = V_dal
                                         and colonna =  V_colonna_arr
                                         and voce     = VACM_EST.voce
                                         and sub      = VACM_EST.sub
                                         and nvl(anno_rif,D_anno) = substr(VACM_EST.rif,3,4)
                                       );
                         P_numeratore := nvl(P_numeratore,0) + 1;
                         insert into smttr_importi
                          (STRM_ID,ANNO,MESE,CI,GESTIONE,DAL,AL
                          ,COLONNA,VOCE,SUB,IMPORTO,ANNO_RIF, UTENTE,DATA_AGG
                          )                          
                         select P_numeratore
                              , D_anno
                              , D_mese
                              , V_ESTERNI.ci
                              , stpe.gestione
                              , stpe.dal
                              , stpe.al
                              , V_colonna_arr
                              , VACM_EST.voce
                              , VACM_EST.sub
                              , VACM_EST.importo
                              , decode( substr(VACM_EST.rif,3,4), D_anno, null, substr(VACM_EST.rif,3,4))
                              , D_utente
                              , sysdate
                           from smttr_periodi stpe
                          where anno = D_anno
                            and ci = V_ESTERNI.ci
                            and dal = V_dal
                            and gestione = CUR_CI1.gestione
                            and not exists (select 'x' 
                                              from smttr_importi
                                             where ci       = V_ESTERNI.ci
                                               and anno     = D_anno
                                               and mese     = D_mese
                                               and dal      = V_dal
                                               and gestione = CUR_CI1.gestione
                                               and colonna  = V_colonna_arr
                                               and voce     = VACM_EST.voce
                                               and sub      = VACM_EST.sub
                                               and nvl(anno_rif,D_anno) = substr(VACM_EST.rif,3,4)
                                             ); 
                           commit;
-- dbms_output.put_line('insert: '||sql%rowcount);
                          END IF; -- controllo su v_colonna_arr 
                      END IF; -- controllo su competenza per insert
                     END IF; -- V_dal
                   END LOOP; -- VACM_EST  
                 END;
                END LOOP; -- V_ESTERNI
             END ESTERNI;
           END LOOP; -- CUR_CI1

           BEGIN
             BEGIN
               select decode(D_mese,1,D_anno-1,D_anno)
                    , decode(D_mese,1,12,D_mese)
                 into D_anno_prec,D_mese_prec
                 from dual
                where exists
                     (select 'x' 
                        from smttr_periodi
                       where anno = decode(D_mese,1,D_anno-1,D_anno)
                         and mese = decode(D_mese,1,12,D_mese)
                     );
             EXCEPTION
                WHEN NO_DATA_FOUND THEN D_anno_prec := null;
                                        D_mese_prec := null;
             END;
             IF D_anno_prec is not null THEN
                FOR CUR_CTR_CESS IN 
                 ( select ci
                     from smttr_periodi
                    where anno = D_anno_prec
                      and mese = D_mese_prec
                      and gestione  = GEST.codice
                      and gestione  in ( select codice
                                           from gestioni
                                          where nvl(fascia,' ') like D_fascia
                                       )
                      and ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )
                       and last_day(to_date(lpad(D_mese_prec,2,0)||D_anno_prec,'mmyyyy'))
                           between nvl(dal,to_date('2222222','j'))
                               and nvl(al,to_date('3333333','j'))
                       AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                   union
                   select ci
                     from smttr_periodi
                    where anno = D_anno
                      and mese = D_mese
                      and gestione  = GEST.codice
                      and gestione  in ( select codice
                                           from gestioni
                                          where nvl(fascia,' ') like D_fascia
                                       )
                      and ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )
                       and assunzione is not null
                       AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                     minus
                    select ci
                      from smttr_periodi
                     where anno = D_anno
                       and mese = D_mese
                       and gestione  = GEST.codice
                       and cessazione is not null
                       AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                   minus
                   select ci
                     from smttr_periodi
                    where anno = D_anno
                      and mese = D_mese
                      and gestione  = GEST.codice
                      and gestione  in ( select codice
                                           from gestioni
                                          where nvl(fascia,' ') like D_fascia
                                       )
                      and ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )                       
                      and last_day(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy'))
                          between nvl(dal,to_date('2222222','j'))
                              and nvl(al,to_date('3333333','j'))
                      AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                   ) LOOP
                       BEGIN
                         BEGIN
                         select lpad('Errore 003',10)||
                                lpad('Mese '||D_mese,7,' ')||
                                lpad(nvl(gestione,' '),4,' ')||
                                lpad(nvl(ci,0),8,0)||
                                lpad(nvl(to_char(dal,'ddmmyyyy'),' '),8,' ')||
                                lpad(nvl(to_char(al,'ddmmyyyy'),' '),8,' ')||
                                rpad('Verificare Correttezza Dipendente nel mese '||D_mese||': possibile cessazione non rilevata',132,' ')
                           into V_testo
                           from smttr_periodi
                          where anno = D_anno  
                            and mese = D_mese
                            and ci = CUR_CTR_CESS.ci
                            and gestione  = GEST.codice
                            and dal = (select max(dal) from smttr_periodi
                                        where anno = D_anno 
                                          and mese = D_mese
                                          and gestione  = GEST.codice
                                          and ci   = CUR_CTR_CESS.ci)
                         ;
                         EXCEPTION WHEN NO_DATA_FOUND THEN V_testo := null;
                         END;
                         IF V_testo is not null THEN
                         D_riga := nvl(D_riga,0) + 1;
                         insert into a_appoggio_stampe
                         (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                         select prenotazione
                              , 2
                              , D_pagina
                              , D_riga
                              , V_testo
                           from dual
                          where not exists ( select 'x' 
                                               from a_appoggio_stampe
                                              where no_prenotazione = prenotazione
                                                and no_passo = 2
                                                and pagina = D_pagina
                                                and testo = V_testo
                                            ) ;
                         commit;
                         END IF;
                       END;
                     END LOOP; -- ctr_cess
                FOR CUR_CTR_ASS IN 
                   (select ci
                     from smttr_periodi
                    where anno = D_anno
                      and mese = D_mese
                      and gestione  = GEST.codice
                      and gestione  in ( select codice
                                           from gestioni
                                          where nvl(fascia,' ') like D_fascia
                                       )
                      and ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )
                      and last_day(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')) 
                          between nvl(dal,to_date('2222222','j'))
                              and nvl(al,to_date('3333333','j'))
                       AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                    union
                   select ci
                     from smttr_periodi
                    where anno = D_anno
                      and mese = D_mese
                      and gestione  = GEST.codice
                      and gestione  in ( select codice
                                           from gestioni
                                          where nvl(fascia,' ') like D_fascia
                                       )
                      and ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )
                      and cessazione is not null
                       AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                    minus
                   select ci
                     from smttr_periodi
                    where anno = D_anno
                      and mese = D_mese
                      and gestione  = GEST.codice
                      and gestione  in ( select codice
                                           from gestioni
                                          where nvl(fascia,' ') like D_fascia
                                       )
                      and ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )
                      and assunzione is not null
                       AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                    minus
                   select ci
                     from smttr_periodi
                    where anno = D_anno_prec
                      and mese = D_mese_prec
                      and gestione  = GEST.codice
                      and gestione  in ( select codice
                                           from gestioni
                                          where nvl(fascia,' ') like D_fascia
                                       )
                      and ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )
                      and last_day(to_date(lpad(D_mese_prec,2,0)||D_anno_prec,'mmyyyy')) 
                          between nvl(dal,to_date('2222222','j'))
                              and nvl(al,to_date('3333333','j'))
                       AND ( D_tipo in ('T','I','V','P')
                         or  D_tipo = 'S' and ci =D_ci )
                   ) LOOP
                       BEGIN
                         BEGIN
                         select lpad('Errore 004',10)||
                                lpad('Mese '||D_mese,7,' ')||
                                lpad(nvl(gestione,' '),4,' ')||
                                lpad(nvl(ci,0),8,0)||
                                lpad(nvl(to_char(dal,'ddmmyyyy'),' '),8,' ')||
                                lpad(nvl(to_char(al,'ddmmyyyy'),' '),8,' ')||
                                rpad('Verificare Correttezza Dipendente nel mese '||D_mese||': possibile assunzione non rilevata',132,' ')
                           into V_testo
                           from smttr_periodi
                          where anno = D_anno  
                            and mese = D_mese
                            and ci = CUR_CTR_ASS.ci
                            and gestione  = GEST.codice
                            and dal = (select max(dal) from smttr_periodi
                                        where anno = D_anno 
                                          and mese = D_mese
                                          and gestione  = GEST.codice
                                          and ci   = CUR_CTR_ASS.ci)
                         ;
                         EXCEPTION WHEN NO_DATA_FOUND THEN V_testo := null;
                         END;
                         IF V_testo is not null THEN
                         D_riga := nvl(D_riga,0) + 1;
                         insert into a_appoggio_stampe
                         (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                         select prenotazione
                              , 2
                              , D_pagina
                              , D_riga
                              , V_testo
                           from dual
                          where not exists ( select 'x' 
                                               from a_appoggio_stampe
                                              where no_prenotazione = prenotazione
                                                and no_passo = 2
                                                and pagina = D_pagina
                                                and testo = V_testo
                                            ) ;
                         END IF;
                       END;
                     END LOOP; -- ctr_ass
             END IF; -- D_anno_prec
           END;
           BEGIN
           D_conta   := 0;
      /* Gestione ripresi per Arretrati */
              FOR ARR IN
                 ( select pegi.gestione                gestione
                        , pegi.ci                      ci
                        , greatest(pegi.dal,figi.dal)  dal
                        , least( nvl(pegi.al, to_date('3333333','j'))
                               , nvl(figi.al, to_date('3333333','j'))
                          )                            al
                        , clra.retributivo             retributivo
                        , rqst.codice                  qua_min
                        , posi.tempo_determinato       tem_det
                        , posi.part_time               part_time
                        , decode(posi.part_time,'SI',round(PEGI.ore/cost.ore_lavoro*100,2)
                                                    ,null
                                 )                     perc_part_time
                     from periodi_giuridici            pegi
                        , righe_qualifiche_statistiche rqst
                        , posizioni                    posi
                        , classi_rapporto              clra
                        , rapporti_individuali         rain
                        , contratti_storici            cost
                        , figure_giuridiche            figi
                    where pegi.rilevanza        = 'S'
                      and nvl(pegi.al,to_date('3333333','j'))
                                          <= D_fin_mes
                      and clra.giuridico = 'SI'
                      and clra.presenza  = 'SI'
                      and rain.rapporto  = clra.codice
                      and pegi.ci        = rain.ci
                      and rain.dal      <= D_fin_mes
                      and pegi.figura    = figi.numero
                      and figi.dal      <= nvl(pegi.al,to_date('3333333','j'))
                      and nvl(figi.al,to_date('3333333','j')) >= pegi.dal
                      and cost.contratto = (select contratto
                                              from QUALIFICHE_GIURIDICHE
                                             where numero = pegi.qualifica
                                               and greatest(pegi.dal,figi.dal) between dal
                                                                                   and NVL(al,TO_DATE('3333333','j'))
                                           )
                      and D_fin_mes between cost.dal
                                         and nvl(cost.al,to_date('3333333','j'))
                      and not exists
                         (select 'x'
                            from periodi_giuridici
                           where rilevanza = 'S'
                             and ci = pegi.ci
                             and dal <= D_fin_mes
                             and nvl(al,to_date('3333333','j')) > D_fin_mp
                                )
                      and posi.codice           = pegi.posizione
                      and pegi.gestione        in
                         (select codice
                            from gestioni
                           where codice = GEST.codice
                             and gestito = 'SI')
                      and rain.rapporto||''         LIKE D_rapporto
                      and nvl(rain.gruppo,' ')||''  LIKE D_gruppo
                      and ( rain.cc is null
                          or exists
                            (select 'x'
                               from a_competenze
                              where ente        = D_ente
                                and ambiente    = D_ambiente
                                and utente      = D_utente
                                and competenza  = 'CI'
                                and oggetto     = rain.cc
                            )
                          )
                      and exists
                         (select 'x' from movimenti_contabili moco
                           where anno = D_anno
                             and mese = D_mese
                             and ci   = pegi.ci
                             and mensilita != '*AP'
                             and riferimento between greatest(pegi.dal,figi.dal)
                                                 and least( nvl(pegi.al, to_date('3333333','j'))
                                                          , nvl(figi.al, to_date('3333333','j'))
                                                          )
                             and exists  ( select 'X'
                                             from estrazione_righe_contabili esrc
                                            where estrazione       = 'SMTTRI'
                                              and moco.riferimento between esrc.dal
                                                                       and nvl(esrc.al,to_date('3333333','j'))
                                              and voce = moco.voce
                                              and sub = moco.sub
                                          )
                      and ( P_competenza is null 
                         or P_competenza = 'X'
                        and to_char(moco.riferimento,'yyyy') = D_anno
                        and to_char(moco.riferimento,'mm') not between D_mese_da and D_mese_a 
                         or P_competenza = 'X'
                        and to_char(moco.riferimento,'yyyy') < D_anno
                          )
                         )
                      and rqst.statistica = 'SMTTRI'
                      and (   (    rqst.qualifica is null
                               and rqst.figura     = pegi.figura)
                           or (    rqst.figura    is null
                               and rqst.qualifica  = pegi.qualifica)
                           or (    rqst.qualifica is not null
                               and rqst.figura    is not null
                               and rqst.qualifica  = pegi.qualifica
                               and rqst.figura     = pegi.figura)
                          )
                      and nvl(rqst.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                      and nvl(rqst.tempo_determinato,posi.tempo_determinato)
                                                             = posi.tempo_determinato
                      and nvl(rqst.formazione_lavoro,posi.contratto_formazione)
                                                             = posi.contratto_formazione
                      and nvl(rqst.part_time,posi.part_time) = posi.part_time
                      and nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqst.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
                 AND ( D_tipo = 'T'
                 or ( D_tipo in ('I','V','P')
                      and ( not exists (select 'x' from smttr_individui
                                       where anno     = D_anno
                                         and mese     = D_mese
                                         and ci       = pegi.ci
                                         and gestione = pegi.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                         select 'x' from smttr_periodi
                                       where anno     = D_anno
                                         and mese     = D_mese
                                         and ci       = pegi.ci
                                         and gestione = pegi.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                        select 'x' from smttr_importi
                                       where anno     = D_anno
                                         and mese     = D_mese
                                         and ci       = pegi.ci
                                         and gestione = pegi.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                     )
                          )
                    )
                 or ( D_tipo  = 'S'
                      and pegi.ci = D_ci )
               )
               order by pegi.ci,pegi.dal,pegi.al
              ) LOOP
-- dbms_output.put_line('CI arretrato '||ARR.ci);
      -- Determino se interno comandato
                D_int_com := PECSMTFC.INT_COM(ARR.ci,ARR.gestione,null,D_fin_mes,ARR.retributivo);
      -- Determino se esterno comandato
                D_est_com := PECSMTFC.INT_COM(ARR.ci,ARR.gestione,null,D_fin_mes,ARR.retributivo);
-- dbms_output.put_line('Inserimento individuo con arretrati: '||ARR.ci);
                insert into SMTTR_INDIVIDUI
                (ANNO,MESE,CI,GESTIONE,INT_COMANDATO,EST_COMANDATO,UTENTE,TIPO_AGG,DATA_AGG)
                  select D_anno
                       , D_mese
                       , ARR.ci
                       , ARR.gestione
                       , D_int_com
                       , D_est_com
                       , D_utente
                       , null
                       , sysdate
                     from dual
                    where not exists (select 'x' from smttr_individui
                                       where anno = D_anno
                                         and mese = D_mese
                                         and gestione = ARR.gestione
                                         and ci = ARR.ci )
                  ;
                  commit;
-- dbms_output.put_line('Inserimento periodi per arretrati del mese: '||D_mese||' '||ARR.dal||' '||ARR.al);
                  insert into SMTTR_PERIODI
                  ( ANNO,MESE,CI,GESTIONE,DAL,AL,QUALIFICA,TEMPO_DETERMINATO,TEMPO_PIENO
                  , PART_TIME,ASSUNZIONE,CESSAZIONE,GG_ASSENZA,UTENTE,TIPO_AGG,DATA_AGG)
                  select D_anno
                       , D_mese
                       , ARR.ci
                       , ARR.gestione
                       , ARR.dal
                       , ARR.al
                       , ARR.qua_min
                       , ARR.tem_det
                       , decode(ARR.part_time,'SI','NO','SI')
                       , ARR.perc_part_time
                       , null -- assunzione
                       , null -- cessazione
                       , null -- assenze
                       , D_utente
                       , null -- tipo
                       , sysdate
                     from dual
                    where not exists (select 'x' from smttr_periodi
                                       where anno = D_anno
                                         and mese = D_mese
                                         and ci = ARR.ci 
                                         and gestione = ARR.gestione
                                         and dal = ARR.dal )
                   ;
-- dbms_output.put_line('righe inserite: '||sql%rowcount);
                    commit;
-- dbms_output.put_line('Inserimento periodo individuo con arretrati: '||ARR.ci||' '||ARR.dal||' '||ARR.al);
                    FOR VACM_ARR IN
                   (select vacm.colonna
                         , vacm.voce
                         , vacm.sub
                         , sum( nvl(vacm.valore,0) ) importo
                         , decode( P_competenza
                                 , 'X', to_char(vacm.riferimento,'mmyyyy') 
                                      , lpad(d_mese,2,'0')||D_anno) rif
                        from rapporti_giuridici           ragi
                           , valori_contabili_mensili     vacm
                       where vacm.anno             = D_anno
                         and vacm.mese             = D_mese
                         and vacm.mensilita  != '*AP'
                         and vacm.estrazione       = 'SMTTRI'
                         and vacm.ci               = ARR.ci
                         and vacm.ci               = ragi.ci
                         and ( P_competenza is null 
                            or P_competenza = 'X'
                           and to_char(vacm.riferimento,'yyyy') = D_anno
                           and to_char(vacm.riferimento,'mm') not between D_mese_da and D_mese_a 
                            or P_competenza = 'X'
                           and to_char(vacm.riferimento,'yyyy') < D_anno
                             )
                         and least(vacm.riferimento
                                  ,nvl(ragi.al,to_date('3333333','j')))
                             between ARR.dal
                                 and nvl(ARR.al,to_date('3333333','j'))
                    group by colonna, voce, sub
                           , decode( P_competenza
                                   , 'X', to_char(vacm.riferimento,'mmyyyy') 
                                        , lpad(d_mese,2,'0')||D_anno)
                    having sum(nvl(vacm.valore,0)) != 0
                    ) LOOP
-- dbms_output.put_line('Cursore VACM ARR'); 
                    P_numeratore := nvl(P_numeratore,0) + 1;
                    BEGIN
-- dbms_output.put_line('Insert2 - ID: '||' '||P_numeratore);
-- dbms_output.put_line('anno/mese: '||d_anno||' '||d_mese);
-- dbms_output.put_line('arr ci: '||arr.CI||' '||ARR.dal||' '||ARR.al);
-- dbms_output.put_line('gestione: '||arr.gestione);
-- dbms_output.put_line('dati: '||VACM_ARR.colonna||' '||VACM_ARR.voce||' '||vacm_arr.rif);
-- dbms_output.put_line('importo: '||VACM_ARR.importo);
-- dbms_output.put_line('Inserimento periodi per arretrati 1 : '||ARR.dal||' '||ARR.al);
                     insert into SMTTR_PERIODI
                     ( ANNO,MESE,CI,GESTIONE,DAL,AL,QUALIFICA,TEMPO_DETERMINATO,TEMPO_PIENO
                     , PART_TIME,UTENTE,DATA_AGG)
                      select D_anno
                           , D_mese
                           , ARR.ci
                           , ARR.gestione
                           , ARR.dal
                           , ARR.al
                           , ARR.qua_min
                           , ARR.tem_det
                           , decode(ARR.part_time,'SI','NO','SI')
                           , ARR.perc_part_time
                           , D_utente
                           , sysdate
                        from dual
                       where not exists (select 'x' from smttr_periodi
                                          where anno = D_anno
                                            and mese = D_mese
                                            and ci = ARR.ci 
                                            and gestione = ARR.gestione
                                            and dal = ARR.dal )
                        ;
-- dbms_output.put_line('righe inserite: '||sql%rowcount);
                       IF ( P_competenza is null 
                         or P_competenza = 'X' and VACM_ARR.rif = lpad(D_mese,2,'0')||D_anno
                          ) THEN 
-- dbms_output.put_line('inserimento dati e rif. attuali');
                         update smttr_importi
                            set importo = nvl(importo,0) + VACM_ARR.importo
                              , utente = D_utente 
                              , data_agg = sysdate
                          where anno = D_anno
                            and mese = D_mese
                            and ci = ARR.CI
                            and gestione = ARR.gestione
                            and dal = ARR.dal
                            and voce = VACM_ARR.voce
                            and sub = VACM_ARR.sub
                            and colonna =  VACM_ARR.colonna
                            and exists ( select 'x' 
                                           from smttr_importi
                                          where anno = D_anno
                                            and mese = D_mese
                                            and ci = ARR.ci
                                            and gestione = ARR.gestione
                                            and dal = ARR.DAL
                                            and colonna = VACM_ARR.colonna
                                            and voce = VACM_ARR.voce
                                            and sub = VACM_ARR.sub
                                        ) 
                          ;
                          insert into smttr_importi
                          (STRM_ID,ANNO,MESE,CI,GESTIONE,DAL,AL
                          ,COLONNA,VOCE,SUB,IMPORTO,UTENTE,DATA_AGG
                          )
                          select P_numeratore
                               , D_anno
                               , D_mese
                               , ARR.ci
                               , ARR.gestione
                               , ARR.dal
                               , ARR.al
                               , VACM_ARR.colonna
                               , VACM_ARR.voce
                               , VACM_ARR.sub
                               , VACM_ARR.importo
                               , D_utente
                               , sysdate
                            from dual
                          where not exists ( select 'x' 
                                               from smttr_importi
                                              where anno = D_anno
                                                and mese = D_mese
                                                and ci = ARR.ci
                                                and gestione = ARR.gestione
                                                and dal = ARR.DAL
                                                and colonna = VACM_ARR.colonna
                                                and voce = VACM_ARR.voce
                                                and sub = VACM_ARR.sub
                                         ) 
                          ;
                       commit;
                       ELSE
-- dbms_output.put_line('inserimento arretrati ');
                        V_colonna_arr := '';
                        V_testo := '';
                         BEGIN
                            select esvc.colonna
                              into V_colonna_arr
                              from estrazione_valori_contabili esvc
                             where estrazione       = 'SMTTRI'
                               and VACM_ARR.colonna     = rtrim(substr(note, instr(note,'<ARR:')+5
                                                                 , instr(note,'>')- ( instr(note,'<ARR:') +5 )))
                               and to_date('01'||lpad(d_mese,2,'0')||D_anno,'ddmmyyyy')
                                   between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
                            ;
                         EXCEPTION WHEN NO_DATA_FOUND THEN
                          V_testo := lpad('Errore 010',10)||
                                     lpad('Mese '||D_mese,7,' ')||
                                     lpad(nvl(ARR.gestione,' '),4,' ')||
                                     lpad(nvl(ARR.ci,0),8,0)||
                                     lpad(nvl(to_char(ARR.dal,'ddmmyyyy'),' '),8,' ')||
                                     lpad(nvl(to_char(ARR.al,'ddmmyyyy'),' '),8,' ')||
                                     rpad('Colonna Arretrati non Definita nel mese '||D_mese||' per colonna '||VACM_ARR.colonna,132,' ')
                                     ;
-- dbms_output.put_line('testo arr: '||V_testo);
                           D_riga := nvl(D_riga,0) + 1;
                           insert into a_appoggio_stampe
                           (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                           select  prenotazione
                                   , 2
                                   , D_pagina
                                   , D_riga
                                   , V_testo
                            from dual
                           where not exists ( select 'x' from a_appoggio_stampe
                                               where no_prenotazione = prenotazione
                                                 and no_passo = 2
                                                 and pagina = D_pagina
                                                 and testo = V_testo
                                            ) 
                           ;
-- dbms_output.put_line('inserimento: '||sql%rowcount);
                          commit;
                         END;
                        IF V_colonna_arr is not null THEN
/* gestione arretrati AC e AP scorporati */
                         update smttr_importi
                            set importo = nvl(importo,0) + VACM_ARR.importo
                              , utente = D_utente 
                              , data_agg = sysdate
                          where anno = D_anno
                            and mese = D_mese
                            and ci = ARR.CI
                            and gestione = ARR.gestione
                            and dal = ARR.dal
                            and voce = VACM_ARR.voce
                            and sub = VACM_ARR.sub
                            and colonna =  V_colonna_arr
                            and nvl(anno_rif,D_anno) = substr(VACM_ARR.rif,3,4)
                            and exists ( select 'x' 
                                           from smttr_importi
                                          where anno = D_anno
                                            and mese = D_mese
                                            and ci = ARR.ci
                                            and gestione = ARR.gestione
                                            and dal = ARR.DAL
                                            and colonna = V_colonna_arr
                                            and voce = VACM_ARR.voce
                                            and sub = VACM_ARR.sub
                                            and nvl(anno_rif,D_anno) = substr(VACM_ARR.rif,3,4)
                                        )
                          ;
-- dbms_output.put_line('update 1 : '||sql%rowcount);
                          insert into smttr_importi
                          (STRM_ID,ANNO,MESE,CI,GESTIONE,DAL,AL
                          ,COLONNA,VOCE,SUB,IMPORTO,ANNO_RIF, UTENTE,DATA_AGG
                          )
                          select P_numeratore
                               , D_anno
                               , D_mese
                               , ARR.ci
                               , ARR.gestione
                               , ARR.dal
                               , ARR.al
                               , V_colonna_arr
                               , VACM_ARR.voce
                               , VACM_ARR.sub
                               , VACM_ARR.importo
                               , decode( substr(VACM_ARR.rif,3,4), D_anno, null, substr(VACM_ARR.rif,3,4))
                               , D_utente
                               , sysdate
                            from dual
                          where not exists ( select 'x' 
                                               from smttr_importi
                                              where anno = D_anno
                                                and mese = D_mese
                                                and ci = ARR.ci
                                                and gestione = ARR.gestione
                                                and dal = ARR.DAL
                                                and colonna = V_colonna_arr
                                                and voce = VACM_ARR.voce
                                                and sub = VACM_ARR.sub
                                                and nvl(anno_rif,D_anno) = substr(VACM_ARR.rif,3,4)
                                         ) 
                          ;
-- dbms_output.put_line('insert 1: '||sql%rowcount);
                       commit;
                       END IF; -- controllo su V_colonna_arr
                      END IF; -- controllo su competenza per insert
                      END;
                    END LOOP; -- VACM_ARR
              END LOOP; -- ARR
              END;
             END LOOP; -- GEST
           END;
         END LOOP; -- var_mese
         BEGIN
          FOR CUR_IMPORTI_0 IN 
           (  select distinct ci, dal, al, gestione, mese
                from smttr_periodi stpe
               where anno       = D_anno
                 and stpe.mese  between D_mese_da and D_mese_a
                 and stpe.gestione  in ( select codice  codice
                                           from gestioni
                                          where codice like nvl(D_gestione,'%')
                                            and gestito   = 'SI'
                                            and nvl(fascia,' ') like D_fascia
                                        )
                 and ci in ( select ci 
                              from rapporti_individuali rain
                             where rain.rapporto         LIKE D_rapporto
                               and nvl(rain.gruppo,' ')  LIKE D_gruppo
                               and (  rain.cc is null
                                   or exists
                                     (select 'x'
                                        from a_competenze
                                       where ente        = D_ente
                                         and ambiente    = D_ambiente
                                         and utente      = D_utente
                                         and competenza  = 'CI'
                                         and oggetto     = rain.cc
                                     )
                                  )
                           )
                 and exists ( select 'x' 
                                from smttr_importi
                                where ci             = stpe.ci
                                  and anno           = stpe.anno
                                  and mese           = stpe.mese
                                  and gestione       = stpe.gestione
                               having sum(nvl(importo,0)) = 0
                            ) 
                 AND ( D_tipo in ('T','I','V','P')
                   or  D_tipo = 'S' and ci = D_ci )
              union
               select distinct ci, dal, al, gestione, mese
                from smttr_periodi stpe
               where anno       = D_anno
                 and stpe.mese      between D_mese_da and D_mese_a
                 and stpe.gestione  in ( select codice  codice
                                           from gestioni
                                          where codice like nvl(D_gestione,'%')
                                            and gestito   = 'SI'
                                            and nvl(fascia,' ') like D_fascia
                                       )
                 and ci in ( select ci 
                              from rapporti_individuali rain
                             where rain.rapporto         LIKE D_rapporto
                               and nvl(rain.gruppo,' ')  LIKE D_gruppo
                               and (  rain.cc is null
                                   or exists
                                     (select 'x'
                                        from a_competenze
                                       where ente        = D_ente
                                         and ambiente    = D_ambiente
                                         and utente      = D_utente
                                         and competenza  = 'CI'
                                         and oggetto     = rain.cc
                                     )
                                  )
                           )
                 and not exists ( select 'x' 
                                    from smttr_importi
                                   where ci             = stpe.ci
                                     and anno           = stpe.anno
                                     and mese           = stpe.mese
                                     and gestione       = stpe.gestione
                            ) 
                 AND ( D_tipo in ('T','I','V','P')
                   or  D_tipo = 'S' and ci =D_ci )
              order by 1, 4, 2, 3
           ) LOOP
             BEGIN
             D_riga := nvl(D_riga,0) + 1;
             V_testo := lpad('Errore 011',10)||
                        lpad('Mese '||CUR_IMPORTI_0.mese,7,' ')||
                        lpad(nvl(CUR_IMPORTI_0.gestione,' '),4,' ')||
                        lpad(nvl(CUR_IMPORTI_0.ci,0),8,0)||
                        lpad(nvl(to_char(CUR_IMPORTI_0.dal,'ddmmyyyy'),' '),8,' ')||
                        lpad(nvl(to_char(CUR_IMPORTI_0.al,'ddmmyyyy'),' '),8,' ')||
                        rpad('Verificare Correttezza Dipendente nel mese '||CUR_IMPORTI_0.mese||': Nessun Importo Archiviato',132,' ')
                        ;
              insert into a_appoggio_stampe
              (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
              select  prenotazione
                      , 2
                      , D_pagina
                      , D_riga
                      , V_testo
                from dual
               where not exists ( select 'x' 
                                    from a_appoggio_stampe
                                   where no_prenotazione = prenotazione
                                     and no_passo = 2
                                     and pagina = D_pagina
                                     and testo = V_testo
                                ) ;
             commit;
             END;
           END LOOP; -- cur_importi_0
          FOR CUR_IMPORTI_0 IN 
           (  select distinct stpe.ci, stpe.dal, stpe.al, stpe.gestione
                   , stim.colonna, stim.voce, stim.mese
                from smttr_periodi stpe
                   , smttr_importi stim
               where stpe.anno      = D_anno
                 and stpe.mese      between D_mese_da and D_mese_a
                 and stim.ci             = stpe.ci
                 and stim.anno           = stpe.anno
                 and stim.mese           = stpe.mese
                 and stim.gestione       = stpe.gestione
                 and stpe.gestione  in ( select codice  codice
                                           from gestioni
                                          where codice like nvl(D_gestione,'%')
                                            and gestito   = 'SI'
                                            and nvl(fascia,' ') like D_fascia
                                       )
                 and stpe.ci in ( select ci 
                                    from rapporti_individuali rain
                                   where rain.rapporto         LIKE D_rapporto
                                     and nvl(rain.gruppo,' ')  LIKE D_gruppo
                                     and (  rain.cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente        = D_ente
                                               and ambiente    = D_ambiente
                                               and utente      = D_utente
                                               and competenza  = 'CI'
                                               and oggetto     = rain.cc
                                           )
                                        )
                                 )
                 AND ( D_tipo in ('T','I','V','P')
                   or  D_tipo = 'S' and stpe.ci =D_ci )
               group by stpe.ci, stpe.dal, stpe.al, stpe.gestione
                      , stim.colonna, stim.voce, stim.mese
              having sum(nvl(importo,0)) = 0
              order by stpe.ci, stim.mese, stpe.dal, stpe.al
           ) LOOP
             BEGIN
             D_riga := nvl(D_riga,0) + 1;
             V_testo := lpad('Errore 012',10)||
                        lpad('Mese '||CUR_IMPORTI_0.mese,7,' ')||
                        lpad(nvl(CUR_IMPORTI_0.gestione,' '),4,' ')||
                        lpad(nvl(CUR_IMPORTI_0.ci,0),8,0)||
                        lpad(nvl(to_char(CUR_IMPORTI_0.dal,'ddmmyyyy'),' '),8,' ')||
                        lpad(nvl(to_char(CUR_IMPORTI_0.al,'ddmmyyyy'),' '),8,' ')||
                        rpad('Verificare Dip. nel mese '||CUR_IMPORTI_0.mese||': Importo Non Valorizzato per colonna / voce', 132,' ')||
                        rpad(' ',41,' ')||
                        rpad(CUR_IMPORTI_0.colonna,20,' ')||
                        rpad(CUR_IMPORTI_0.voce,20,' ')
                        ;
              insert into a_appoggio_stampe
              (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
              select    prenotazione
                      , 2
                      , D_pagina
                      , D_riga
                      , V_testo
                from dual
               where not exists ( select 'x' 
                                    from a_appoggio_stampe
                                   where no_prenotazione = prenotazione
                                     and no_passo = 2
                                     and pagina = D_pagina
                                     and testo = V_testo
                                ) ;
             commit;
             END;
           END LOOP; -- cur_importi_0
           BEGIN
      /* cancellazione importi a 0 */
            delete from smttr_importi stim
             where stim.anno      = D_anno
               and stim.mese      between D_mese_da and D_mese_a
               and stim.gestione  in ( select codice  codice
                                         from gestioni
                                        where codice like nvl(D_gestione,'%')
                                           and gestito   = 'SI'
                                           and nvl(fascia,' ') like D_fascia
                                       )
                 and ci in ( select ci 
                              from rapporti_individuali rain
                             where rain.rapporto         LIKE D_rapporto
                               and nvl(rain.gruppo,' ')  LIKE D_gruppo
                               and (  rain.cc is null
                                   or exists
                                     (select 'x'
                                        from a_competenze
                                       where ente        = D_ente
                                         and ambiente    = D_ambiente
                                         and utente      = D_utente
                                         and competenza  = 'CI'
                                         and oggetto     = rain.cc
                                     )
                                  )
                           )
               and nvl(importo,0) = 0
               AND ( D_tipo in ('T','I','V','P')
                 or  D_tipo = 'S' and ci =D_ci )
             ;
           commit;
           END; 
           END;
        END;
      END IF; -- D_elab economica
      update a_prenotazioni 
         set prossimo_passo = 91
           , errore         = 'P00108'
       where no_prenotazione = prenotazione
         and exists (select 'x'
                       from a_appoggio_stampe
                      where no_prenotazione = prenotazione
                    )
      ;
      commit;
 END;
EXCEPTION
     WHEN errore then
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = 'A05721'
       where no_prenotazione = prenotazione;
      commit;
END;
END;
END;
/
