CREATE OR REPLACE PACKAGE PECCARSM IS

/******************************************************************************
 NOME:          PECCARSM
 DESCRIZIONE:   CARICAMENTO ARCHIVIO STATISTICHE MINISTERIALI

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:  Elenco delle segnalazioni e relativo codice
               Errore 001: Individui e/o periodi non Archiviati
               Errore 002: Individui con posizioni giuridiche anomale: Tempo Determinato, Formazione lavoro ed Lsu
               Errore 003: Individui con periodi anomali: Formazione lavoro, Lsu, Interinale e Telelavoro
               Errore 004: Eventi di assunzione o cessazione attivati al valore di default
               Errore 005: Individui con Periodi sovrapposti
               Errore 006: Individui con Record di rilevanza E
               Errore 007: Individui con periodi anomali: Interno comandato, Interno fuori ruolo, Esterno comandato ed Esterno fuori ruolo
               Errore 008: Estrazione record doppi: verificare DQUMI
               Errore 009: Individui con Tempo Pieno NO e part time 100
               Errore 010: Dipendente in Astensione per tutto il periodo : Dati Non Archiviati
               Errore 011: Dipendente con cambio di comparto senza APERL: verificare
               Errore 012: Dipendente con cambio di comparto con APERL: verificare
               Errore 015: Dipendenti Da Verificare: Confronto Record al 31/12/
               
               Specifici del package PECSMT12
               Errore 020: Verificare Correttezza Dipendente: Esistono Record con Importo Nullo in T12
               Errore 022: Verificare Importi: riferimento attuale non archiviato in T12
               Errore 024: Dipendenti con cambio di qualifica all''interno del mese

               Specifici del package PECSMT13
               Errore 021: Verificare Correttezza Dipendente: Esistono Record con Importo Nullo in T13 o T13S 
               Errore 023: Verificare Importi: riferimento attuale non archiviato in T13 o T13S 
               Errore 027: Verificare Dipendente: Impossibile Determinare Importi Arretrati in T13 o T13S 

               Specifici del package PECSMTPD
               Errore 026: Verificare Dipendente: Impossibile Archiviare periodo per Importi Arretrati
               Errore 020: Verificare Correttezza Dipendente: Esistono Record con Importo Nullo in T12 ( Arr. PD )
               Errore 021: Verificare Correttezza Dipendente: Esistono Record con Importo Nullo in T13 o T13S  ( Arr. PD )

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    08/03/2004 GM     Revisione SMT 2004
 3    18/03/2005 GM     Revisione SMT 2005
 3.1  06/06/2005 MS     Mod. per Att. 11535
                 MS     Sistemazione layout package
 3.2  03/04/2006 MS     Sistemazione cursore principale ( Att.10955 )
 3.3  04/04/2006 MS     Anzianita precedente / Pregressa ( Att.15595 )
 3.4  07/04/2006 MS     Possibilita di leggere PEGI o PERE ( Att.15596)
 3.5  07/04/2006 MS     Adeguamenti Normativi per SSN ( att. 15598 + 15599 )
 3.6  20/04/2006 MS     Correzioni varie per SMT 2006 ( A15666 )
 3.7  21/04/2006 MS     Aggiunta nuova segnalazione ( Att. 10283 )
 3.8  28/04/2006 MS     Sistemato NVL in nuova segnalazione ( Att. 10283.1 )
 3.9  28/04/2006 MS     Aggiunta LEAST in estrazione anzianita ( Att. 15595.1 )
 3.10 08/05/2006 MS     Mod. gestione parametro P_decorrenza ( Att. 16140 )
 3.11 19/05/2006 MS     Ripristino parametro P_decorrenza corretto ( Att. 16324 )
 3.12 24/05/2006 MS     Ripristino parametro P_decorrenza corretto ( Att. 16391 )
 3.13 13/07/2006 MS     Nuova segnalazione + Modifica gestione segnalazioni ( A16329 )
 3.14 05/09/2006 MS     Mod. update per assenze che terminano nel periodo ( A16329.1 )
 3.15 21/03/2007 CB     Gestione di rqmi.posizione per A20251
 3.16 08/05/2007 MS     Correzione di rqmi.posizione per lettura da pere
 3.17 14/05/2007 MS     Correzione data AL data impostata fissa per lettura da pere
 3.18 18/05/2007 MS     Aggiunta nuova segnalazione e miglioria per passaggio di comparto
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCARSM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V3.18 del 18/05/2007';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number)IS
 BEGIN
DECLARE
--
-- Depositi e Contatori Vari
--
  D_anno        number;
  D_ini_a       date;
  D_fin_a       date;
  D_fin_ap      date;
  D_ente        varchar2(4);
  D_ambiente    varchar2(8);
  D_utente      varchar2(8);
  D_tipo        varchar2(1);
  D_elab        varchar2(1);
  D_gestione    varchar2(4);
  D_da          date;
  D_a           date;
  D_ci          number;
  D_pagina      number := 0;
  D_riga        number := 0;
  D_int_com     SMT_INDIVIDUI.int_comandato%TYPE;
  D_est_com     SMT_INDIVIDUI.est_comandato%TYPE;
  D_anz_gg      number := 0;
  D_anz_gg_a    number := 0;
  D_anz_gg_tot  number := 0;
  D_anz_tot_aa  SMT_INDIVIDUI.anzianita%TYPE;
  D_anz_tot_mm  SMT_INDIVIDUI.anzianita_mm%TYPE;
  D_anz_tot_gg  SMT_INDIVIDUI.anzianita_gg%TYPE;
  D_anz_prec_aa SMT_INDIVIDUI.anzianita_prec%TYPE;
  D_anz_prec_mm SMT_INDIVIDUI.anzianita_prec_mm%TYPE;
  D_anz_prec_gg SMT_INDIVIDUI.anzianita_prec_gg%TYPE;
  D_eta         SMT_INDIVIDUI.eta%TYPE;
  D_assunzione  PERIODI_GIURIDICI.evento%TYPE;
  D_cessazione  PERIODI_GIURIDICI.evento%TYPE;
  D_conta       number := 0;
  D_trovato     number := 0;
  D_qua_min     varchar2(6);
  D_cat_min     varchar2(10);
  D_fascia      number(1) := 0;
  D_fig_min     varchar2(6);
  D_fig_min_01  varchar2(6);
  D_pro_min     varchar2(6);
  D_tem_det     varchar2(2);
  D_part_time   varchar2(2);
  D_perc_part_time number(5,2);
  D_uni         varchar2(2);
  D_con_for     varchar2(2);
  D_lsu         varchar2(2);
  D_exist       varchar2(1);
  D_controllo   varchar2(1);
  D_dal         date;
  D_al          date;
  D_dal_a       date;
  D_al_a        date;
  D_dal_p       date;
  D_al_p        date;
  T_dal         date;
  T_al          date;
  P_decorrenza  varchar2(1);
  P_competenza        varchar2(1); -- parametri per Sanita
  P_inizio_mese_liq   number;      -- parametri per Sanita
  P_fine_mese_liq     number;      -- parametri per Sanita
  T_temp_det    SMT_PERIODI.tempo_determinato%TYPE;
  T_qualifica   SMT_PERIODI.qualifica%TYPE;
  errore        exception;
  V_testo       varchar2(500);

  cursor CUR_PER 
  (p_ci number, p_anno number, p_gestione varchar2) is
  select dal,al,tempo_determinato,qualifica,formazione,lsu,interinale,telelavoro
    from smt_periodi
   where ci = p_ci
     and anno = p_anno
     and gestione = p_gestione
  order by dal
  ;

   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
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
          D_utente   := NULL;  --da definire
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
        SELECT substr(valore,1,4)
             , to_date('01'||substr(valore,1,4),'mmyyyy')
             , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
                                     , to_date('3112'||to_char(valore-1),'ddmmyyyy')
          INTO D_anno,D_ini_a,D_fin_a,D_fin_ap
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro       = 'P_ANNO'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          SELECT anno
               , to_date('01'||to_char(anno),'mmyyyy')
               , to_date('3112'||to_char(anno),'ddmmyyyy')
                                       , to_date('3112'||to_char(anno-1),'ddmmyyyy')
            INTO D_anno,D_ini_a,D_fin_a,D_fin_ap
            FROM riferimento_fine_anno
           WHERE rifa_id = 'RIFA';
      END;
      BEGIN
        SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/',
               'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
          INTO D_da
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro       = 'P_DA'
        ;
        SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/',
               'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
          INTO D_a
          FROM a_parametri
         WHERE no_prenotazione = prenotazione
           AND parametro       = 'P_A'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
                          D_da := null;
                          D_a  := null;
      END;
      BEGIN
      SELECT to_number(substr(valore,1,8))
        INTO D_ci
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro       = 'P_CI'
      ;
      IF D_tipo in ('T','P','I','V') and D_ci is not null THEN
        raise errore;
      END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          IF D_tipo = 'S' then
            raise errore;
          END IF;
      END;
     BEGIN
       select valore
         into P_decorrenza
         from a_parametri
        where no_prenotazione = prenotazione
          and parametro    = 'P_DECORRENZA'
        ;
     EXCEPTION WHEN NO_DATA_FOUND THEN 
      P_decorrenza := null;
     END;

     BEGIN
       select valore
         into P_competenza
         from a_parametri
        where no_prenotazione = prenotazione
          and parametro    = 'P_COMPETENZA'
        ;
     EXCEPTION WHEN NO_DATA_FOUND THEN 
      P_competenza := 'N';
     END;
     BEGIN
       select lpad(substr(valore,1,2),2,0)
         into P_inizio_mese_liq
         from a_parametri
        where no_prenotazione = prenotazione
          and parametro       = 'P_MESE_DA';
     EXCEPTION WHEN NO_DATA_FOUND THEN 
         P_inizio_mese_liq := to_number(null);
     END;
     BEGIN
       select lpad(substr(valore,1,2),2,0)
         into P_fine_mese_liq
         from a_parametri
        where no_prenotazione = prenotazione
          and parametro       = 'P_MESE_A';
     EXCEPTION WHEN NO_DATA_FOUND THEN 
         P_fine_mese_liq   := to_number(null);
     END;
     IF nvl(P_competenza,'N') = 'X' and nvl(P_inizio_mese_liq,0) = 1 and nvl(P_fine_mese_liq,0) = 12 THEN
       raise errore;
     END IF;

     BEGIN
     IF D_elab in ('T','G') THEN
-- dbms_output.put_line('Inizio');
-- dbms_output.put_line('Ente-Utente-Ambiente '|| D_ente||' '||D_utente||' '||D_ambiente);
-- dbms_output.put_line('Tipo '||D_tipo);
-- dbms_output.put_line('Gestione '||D_gestione);
-- dbms_output.put_line('Anno '||to_char(D_anno));
-- dbms_output.put_line('Inizio anno '||to_char(D_ini_a,'dd/mm/yyyy')||' Fine anno '||to_char(D_fin_a,'dd/mm/yyyy')||' Fine anno prec. '||to_char(D_fin_ap,'dd/mm/yyyy'));
-- dbms_output.put_line('Dal CI: '||to_char(D_da_ci)||' al CI: '||to_char(D_a_ci));
-- cancello eventuali archiviazioni precedenti
         FOR CUR_CI IN
         ( SELECT rain.ci  ci
                , pegi.gestione         gestione
                , max(anag.sesso)       sesso
                , max(anag.data_nas)    data_nas
                , max(clra.retributivo) retributivo
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
              AND pegi.gestione  LIKE D_gestione
              AND pegi.rilevanza = 'S'
              AND pegi.dal       <= nvl(D_a,D_fin_a)
              AND nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
              AND clra.giuridico = 'SI'
              AND clra.presenza  = 'SI'
              AND rain.dal       <= nvl(D_a,D_fin_a)
              AND nvl(rain.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
              AND exists (select 'x' from periodi_giuridici   pegi2
                           where pegi2.rilevanza  in ('S','E')
                             and pegi2.dal        <= nvl(D_a,D_fin_a)
                             and nvl(pegi2.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                             and pegi2.gestione      like D_gestione
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
                      and ( not exists (select 'x' from smt_individui
                                       where anno     = D_anno
                                         and ci       = pegi.ci
                                         and gestione = pegi.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                         select 'x' from smt_periodi
                                       where anno = D_anno
                                         and ci   = pegi.ci
                                         and gestione = pegi.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                        select 'x' from smt_importi
                                       where anno = D_anno
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

         LOCK TABLE SMT_INDIVIDUI IN EXCLUSIVE MODE NOWAIT;
-- dbms_output.put_line('CI: '||CUR_CI.ci);
              DELETE from SMT_INDIVIDUI
               WHERE anno        = D_anno
                 AND gestione    = CUR_CI.gestione
                 AND ci = CUR_CI.ci
               ;

         LOCK TABLE SMT_PERIODI IN EXCLUSIVE MODE NOWAIT;

              DELETE from SMT_PERIODI
               WHERE anno        = D_anno
                 AND gestione    = CUR_CI.gestione
                 AND ci = CUR_CI.ci
              ;
          COMMIT;
               BEGIN
                  D_pagina := D_pagina + 1;
                  D_riga := 0;
                  D_int_com :=null;
                  D_est_com :=null;
                  D_anz_gg  :=null;
                  D_anz_gg_a :=null;
                  D_anz_tot_aa := null;
                  D_anz_tot_mm := null;
                  D_anz_tot_gg := null;
                  D_anz_prec_aa := null;
                  D_anz_prec_mm := null;
                  D_anz_prec_gg := null;
                  D_eta :=null;
                  D_assunzione :=null;
                  D_cessazione :=null;
                  D_conta :=null;
                  D_trovato :=null;
                  D_qua_min :=null;
                  D_fascia  := null;
                  D_cat_min :=null;
                  D_fig_min :=null;
                  D_fig_min_01 :=null;
                  D_pro_min :=null;
                  D_tem_det :=null;
                  D_part_time :=null;
                  D_perc_part_time :=null;
                  D_uni :=null;
                  D_con_for :=null;
                  D_lsu :=null;
                  D_exist :=null;
                  D_controllo :=null;
                  D_dal :=null;
                  D_al :=null;
                  D_dal_a :=null;
                  D_al_a :=null;
                  D_dal_p :=null;
                  D_al_p :=null;
                  T_dal :=null;
                  T_al :=null;
                  T_temp_det :=null;
                  T_qualifica :=null;

            -- Determino se interno comandato
            D_int_com := PECSMTFC.INT_COM(CUR_CI.ci,CUR_CI.gestione,D_a,D_fin_a,CUR_CI.retributivo);
-- dbms_output.put_line('Interno Comandato: '||D_int_com);

            -- Determino se esterno comandato
            D_est_com := PECSMTFC.EST_COM(CUR_CI.ci,CUR_CI.gestione,D_a,D_fin_a,CUR_CI.retributivo);
-- dbms_output.put_line('Esterno Comandato: '||D_est_com);

            -- Determino l'Eta e l'Anzianita
                  BEGIN
                  select sum(least(nvl(pegi2.al,D_fin_a),D_fin_a) +1 - pegi2.dal) 
                       , trunc(months_between(nvl(D_a,D_fin_a) +1, CUR_CI.data_nas )
                              / 12 )
                   into D_anz_gg
                      , D_eta
                   from (SELECT pegi.ci  ci
                              , pegi.dal dal
                              , pegi.al  al
                              , 'Q' rilevanza
                           FROM periodi_giuridici pegi
                          WHERE pegi.rilevanza = 'Q'
                            AND pegi.posizione IN (SELECT codice FROM posizioni WHERE di_ruolo in ('R','F'))
                          UNION
                         SELECT pegi.ci  ci
                              , pegi.dal dal
                              , pegi.al  al
                              , 'Q' rilevanza
                           FROM periodi_giuridici pegi
                          WHERE pegi.rilevanza = 'Q'
                            AND pegi.posizione IN (SELECT codice FROM posizioni WHERE di_ruolo = 'N')
                            AND f_contiguo_r(pegi.ci, NVL(pegi.al,D_fin_a))= 1
                         ) pegi2
                    where pegi2.ci = CUR_CI.ci
                      and pegi2.rilevanza       = 'Q'
                      and pegi2.dal            <= D_fin_a
                      and exists (select 'x'
                                    from periodi_giuridici
                                   where ci = CUR_CI.ci
                                     and rilevanza = 'S'
                                     and dal = (select max(dal) from periodi_giuridici
                                                 where rilevanza = 'S'
                                                   and ci = CUR_CI.ci
                                                   and dal <= D_fin_a
                                                )
                                     and gestione = CUR_CI.gestione
                                   )
                   ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
-- dbms_output.put_line('Sono in no_data_found');
                    D_anz_gg := null;
                    D_eta := null;
                  END;
-- dbms_output.put_line('Eta '||to_char(D_eta));
-- dbms_output.put_line('Anzianita PEGI '||to_char(D_anz_gg));
                  BEGIN
                  select sum( least ( nvl(pegi.al,D_fin_a),D_fin_a)  - pegi.dal)
                    into D_anz_gg_a
                    from periodi_giuridici pegi
                   where rilevanza = 'A'
                     and evento in (select codice
                                      from eventi_giuridici
                                     where rilevanza = 'A'
                                       and nvl(conto_annuale,0) = 99
                                   )
                     and ci = CUR_CI.ci
                     and dal <= D_fin_a;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
-- dbms_output.put_line('Sono in no_data_found');
                    D_anz_gg_a := null;
                  END;
                D_anz_gg_tot := nvl(D_anz_gg,0) - nvl(D_anz_gg_a,0);
-- dbms_output.put_line('Anzianita Totale '||to_char(D_anz_gg_tot));

                IF D_anz_gg_tot != 0 THEN
                   SELECT DECODE( NVL(TRUNC( D_anz_gg_tot/365),0)
                                 ,0, NULL
                                   , TO_CHAR(TRUNC(D_anz_gg_tot/365))
                                )
                        , DECODE(NVL(TRUNC( ( D_anz_gg_tot
                                            - TRUNC(D_anz_gg_tot/365)*365)/30),0)
                                 ,0, NULL
                                   , TO_CHAR(TRUNC((D_anz_gg_tot-TRUNC(D_anz_gg_tot/365)*365)/30))
                                )
                        , DECODE(NVL((D_anz_gg_tot
                                         -TRUNC(D_anz_gg_tot/365)*365
                                         -TRUNC((D_anz_gg_tot
                                                -TRUNC(D_anz_gg_tot/365)
                                                *365)/30)*30),0)
                                 ,0, NULL
                                   , TO_CHAR((D_anz_gg_tot
                                              -TRUNC(D_anz_gg_tot/365)*365
                                              -TRUNC((D_anz_gg_tot
                                              -TRUNC(D_anz_gg_tot/365)*365)/30)
                                              *30)))
                      into D_anz_tot_aa
                         , D_anz_tot_mm
                         , D_anz_tot_gg
                      from dual;
                  END IF;

-- dbms_output.put_line('Anzianita Anni '||to_char(D_anz_tot_aa));
-- dbms_output.put_line('Anzianita Mesi '||to_char(D_anz_tot_mm));
-- dbms_output.put_line('Anzianita Giorni '||to_char(D_anz_tot_gg));
                  BEGIN
                  select sum(nvl(dato_n1,0)), sum(nvl(dato_n2,0)), sum(nvl(dato_n3,0))
                    into D_anz_prec_aa
                       , D_anz_prec_mm
                       , D_anz_prec_gg
                    from archivio_documenti_giuridici adog
                   where adog.ci = CUR_CI.ci
                     and adog.del <= D_fin_a
                     and adog.evento = 'ANZP'
                     and scd = 'ANZP'
                  ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
-- dbms_output.put_line('Sono in no_data_found');
                    D_anz_prec_aa := null;
                    D_anz_prec_mm := null;
                    D_anz_prec_gg := null;                                        
                  END;

            -- Inserisco i record di testata
-- dbms_output.put_line('Inserisco in SMT_INDIVIDUI per il CI: '||to_char(CUR_CI.ci));
                  insert into SMT_INDIVIDUI
                  (ANNO,CI,GESTIONE,SESSO,ETA
                 , ANZIANITA, ANZIANITA_MM, ANZIANITA_GG
                 , ANZIANITA_PREC, ANZIANITA_PREC_MM, ANZIANITA_PREC_GG
                 , INT_COMANDATO,INT_FUORI_RUOLO
                 , EST_COMANDATO,EST_FUORI_RUOLO,UTENTE,TIPO_AGG,DATA_AGG)
                  values (D_anno
                        , CUR_CI.ci
                        , CUR_CI.gestione
                        , CUR_CI.sesso
                        , D_eta
                        , D_anz_tot_aa
                        , D_anz_tot_mm
                        , D_anz_tot_gg
                        , D_anz_prec_aa
                        , D_anz_prec_mm
                        , D_anz_prec_gg
                        , D_int_com
                        , null      --interno_fuori_ruolo
                        , D_est_com
                        , null      --esterno_fuori_ruolo
                        , D_utente
                        , null
                        , sysdate
                        )
                 ;
                   BEGIN
                   <<PERIODI>>
                    D_trovato := 0;
                    D_conta   := 0;
                    D_dal     := to_date(null);
                   FOR CUR_PEGI IN
                  ( SELECT pegi.dal dal_periodo
                         , pegi.al al_periodo
                         , greatest(pegi.dal,figi.dal) dal
                         , to_date(to_char(decode( least( nvl(pegi.al, to_date('3333333','j'))
                                                        , nvl(figi.al, to_date('3333333','j')))
                                                 , to_date('3333333','j'), to_date(null)
                                                                         , least( nvl(pegi.al, to_date('3333333','j'))
                                                                                , nvl(figi.al, to_date('3333333','j')))
                                                  ),'dd/mm/yyyy' ),'dd/mm/yyyy' )  al
                         , rqmi.codice                 qua_min
                         , qumi.categoria              cat_min
                         , decode(nvl(cost.conto_annuale,9)
                                  ,1 , decode( pegi.tipo_rapporto
                                              , null, 0
                                                    , nvl(tira.conto_annuale,0)
                                             )
                                     , to_number(null)
                                 )                     fascia
                         , figi.codice_ministero       fig_min
                         , figi.codice_ministero_01    fig_min_01
                         , prpr.codice_ministero       pro_min
                         , posi.tempo_determinato      tem_det
                         , posi.part_time              part_time
                         , decode(posi.part_time
                                 ,'SI', round(PEGI.ore/cost.ore_lavoro*100,2)
                                      , null )         perc_part_time
                         , posi.universitario          uni
                         , posi.contratto_formazione   con_for
                         , posi.lsu                    lsu
                         , 1                            flag
                   FROM periodi_giuridici pegi
                      , posizioni posi
                      , tipi_rapporto     tira
                      , figure_giuridiche figi
                      , qualifiche_ministeriali qumi
                      , righe_qualifica_ministeriale rqmi
                      , profili_professionali prpr
                      , contratti_storici cost
                  WHERE nvl(P_decorrenza, 'Y') = 'X'
                    AND pegi.ci          = CUR_CI.ci
                    AND pegi.rilevanza   = 'S'
                    AND pegi.dal         <= nvl(D_a,D_fin_a)
                    AND nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                    AND pegi.gestione    = CUR_CI.gestione
                    AND posi.codice      = pegi.posizione
                    AND tira.codice (+)  = pegi.tipo_rapporto
                    AND pegi.figura      = figi.numero
                    AND pegi.posizione   = nvl(rqmi.posizione,pegi.posizione)
                    AND figi.dal         <= nvl(pegi.al,to_date('3333333','j'))
                    AND nvl(figi.al,to_date('3333333','j')) >= pegi.dal
                    AND prpr.codice (+)  = figi.profilo
                    AND nvl(D_a,D_fin_a) between qumi.dal and nvl(qumi.al,to_date('3333333','j'))
                    AND rqmi.codice    = qumi.codice
                    AND rqmi.dal       = qumi.dal
                    AND (   (    rqmi.qualifica is null
                             and rqmi.figura     = pegi.figura)
                         or (    rqmi.figura    is null
                             and rqmi.qualifica  = pegi.qualifica)
                         or (    rqmi.qualifica is not null
                             and rqmi.figura    is not null
                             and rqmi.qualifica  = pegi.qualifica
                             and rqmi.figura     = pegi.figura)
                         or (    rqmi.qualifica is null
                             and rqmi.figura    is null)
                        )
                    AND nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                    AND nvl(rqmi.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
                    AND nvl(rqmi.formazione_lavoro,posi.contratto_formazione) = posi.contratto_formazione
                    AND nvl(rqmi.part_time,posi.part_time) = posi.part_time
                    AND nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqmi.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
                    AND exists (select 'x'
                                  from rapporti_individuali
                                 where ci        = pegi.ci
                                   and rapporto in ( select codice
                                  from classi_rapporto
                                 where giuridico = 'SI'
                                   and retributivo = 'SI')
                               )
                    AND  cost.contratto    =
                         (select contratto
                            from QUALIFICHE_GIURIDICHE
                           where numero = pegi.qualifica
                             and PEGI.dal between dal  and NVL(al,TO_DATE('3333333','j'))
                          )
                    and nvl(pegi.al,D_fin_a)
                        between cost.dal and nvl(cost.al,to_date('3333333','j'))
                   union
/* casi particolari personale universitario non gestito in DQUMI ma solo in DFIGU */
                    SELECT pegi.dal dal_periodo
                         , pegi.al al_periodo 
                         , greatest(pegi.dal,figi.dal) dal
                         , to_date(to_char(decode( least( nvl(pegi.al, to_date('3333333','j'))
                                                        , nvl(figi.al, to_date('3333333','j')))
                                                 , to_date('3333333','j'), to_date(null)
                                                                         , least( nvl(pegi.al, to_date('3333333','j'))
                                                                                , nvl(figi.al, to_date('3333333','j')))
                                                  ),'dd/mm/yyyy' ),'dd/mm/yyyy' )  al
                         , ''                          qua_min
                         , ''                          cat_min
                         , decode(nvl(cost.conto_annuale,9)
                                  ,1 , decode( pegi.tipo_rapporto
                                              , null, 0
                                                    , nvl(tira.conto_annuale,0)
                                             )
                                     , to_number(null)
                                 )                     fascia
                         , figi.codice_ministero       fig_min
                         , figi.codice_ministero_01    fig_min_01
                         , prpr.codice_ministero       pro_min
                         , posi.tempo_determinato      tem_det
                         , posi.part_time              part_time
                         , decode(posi.part_time
                                 ,'SI', round(PEGI.ore/cost.ore_lavoro*100,2)
                                      , null )         perc_part_time
                         , posi.universitario          uni
                         , posi.contratto_formazione   con_for
                         , posi.lsu                    lsu
                         , 2                           flag
                   FROM periodi_giuridici pegi
                      , posizioni posi
                      , tipi_rapporto     tira
                      , figure_giuridiche figi
                      , profili_professionali prpr
                      , contratti_storici cost
                  WHERE nvl(P_decorrenza, 'Y') = 'X'
                    AND pegi.ci          = CUR_CI.ci
                    AND pegi.rilevanza   = 'S'
                    AND pegi.dal         <= nvl(D_a,D_fin_a)
                    AND nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                    AND pegi.gestione    = CUR_CI.gestione
                    AND posi.codice      = pegi.posizione
                    AND tira.codice (+)  = pegi.tipo_rapporto
                    AND pegi.figura      = figi.numero
                    AND figi.dal         <= nvl(pegi.al,to_date('3333333','j'))
                    AND nvl(figi.al,to_date('3333333','j')) >= pegi.dal
                    AND prpr.codice (+)  = figi.profilo
                    AND prpr.codice_ministero is not null 
                    and posi.universitario = 'SI'
                    AND not exists ( select 'x'
                                       from righe_qualifica_ministeriale rqmi1
                                          , qualifiche_ministeriali qumi1
                                      where nvl(D_a,D_fin_a) 
                                            between qumi1.dal and nvl(qumi1.al,to_date('3333333','j'))
                                        and rqmi1.codice    = qumi1.codice
                                        AND rqmi1.dal       = qumi1.dal
                                        AND (   (    rqmi1.qualifica is null
                                                 and rqmi1.figura     = pegi.figura)
                                             or (    rqmi1.figura    is null
                                                 and rqmi1.qualifica  = pegi.qualifica)
                                             or (    rqmi1.qualifica is not null
                                                 and rqmi1.figura    is not null
                                                 and rqmi1.qualifica  = pegi.qualifica
                                                 and rqmi1.figura     = pegi.figura)
                                             or (    rqmi1.qualifica is null
                                                 and rqmi1.figura    is null)
                                            )
                                        AND pegi.posizione   = nvl(rqmi1.posizione,pegi.posizione)
                                        AND nvl(rqmi1.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                                        AND nvl(rqmi1.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
                                        AND nvl(rqmi1.formazione_lavoro,posi.contratto_formazione) = posi.contratto_formazione
                                        AND nvl(rqmi1.part_time,posi.part_time) = posi.part_time
                                        AND nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqmi1.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
                                   )
                    AND exists (select 'x'
                                 from rapporti_individuali
                                             where ci        = pegi.ci
                                             and rapporto in ( select codice
                                                     from classi_rapporto
                                                    where giuridico = 'SI'
                                                      and retributivo = 'SI')
                                           )
                    AND  cost.contratto    =
                         (select contratto
                            from QUALIFICHE_GIURIDICHE
                           where numero = pegi.qualifica
                             and PEGI.dal between dal  and NVL(al,TO_DATE('3333333','j'))
                          )
                    and nvl(pegi.al,D_fin_a)
                        between cost.dal and nvl(cost.al,to_date('3333333','j'))
                   union
/* Lettura dei dati per applicazione */ 
                    SELECT greatest( to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy')
                                   , pere.dal ) dal_periodo
                         , pere.al  al_periodo
                         , greatest( greatest( nvl( pegi_p.dal, to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy'))
                                             , pere.dal 
                                             , to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy')
                                             ) 
                                   , figi.dal) dal
                         , to_date(to_char(decode( least( nvl(pere.al, to_date('3333333','j'))
                                                        , nvl(figi.al, to_date('3333333','j')))
                                                 , to_date('3333333','j'), to_date(null)
                                                                         , least( nvl(pere.al, to_date('3333333','j'))
                                                                                , nvl(figi.al, to_date('3333333','j')))
                                                  ),'dd/mm/yyyy' ),'dd/mm/yyyy' )  al
                         , rqmi.codice                 qua_min
                         , qumi.categoria              cat_min
                         , decode(nvl(cost.conto_annuale,9)
                                  ,1 , decode( pere.tipo_rapporto
                                              , null, 0
                                                    , nvl(tira.conto_annuale,0)
                                             )
                                     , to_number(null)
                                 )                     fascia
                         , figi.codice_ministero       fig_min
                         , figi.codice_ministero_01    fig_min_01
                         , prpr.codice_ministero       pro_min
                         , posi.tempo_determinato      tem_det
                         , posi.part_time              part_time
                         , decode(posi.part_time
                                 ,'SI', round(pere.ore/cost.ore_lavoro*100,2)
                                      , null )         perc_part_time
                         , posi.universitario          uni
                         , posi.contratto_formazione   con_for
                         , posi.lsu                    lsu
                         , 3                           flag
                   FROM periodi_retributivi          pere
                      , periodi_giuridici            pegi_p
                      , posizioni                    posi
                      , tipi_rapporto                tira
                      , figure_giuridiche            figi
                      , qualifiche_ministeriali      qumi
                      , righe_qualifica_ministeriale rqmi
                      , profili_professionali        prpr
                      , contratti_storici            cost
                      , mesi
                  WHERE nvl(P_decorrenza, 'Y') = 'Y'
                    AND pere.ci          = CUR_CI.ci
                    AND pere.competenza in ('A','C')
                    and pere.servizio     = 'Q'
                    AND nvl(pere.tipo,' ') not in ('R','F') 
                    AND pere.periodo between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                    AND pere.al      between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                    AND pere.periodo = (select max(periodo)
                                          from periodi_retributivi 
                                         where ci       = pere.ci
                                           and periodo >= to_date(mesi.anno||lpad(mesi.mese,2,0),'yyyymm')
                                           and periodo <= nvl(D_a,D_fin_a)
                                           and to_char(al,'yyyymm') = mesi.anno||lpad(mesi.mese,2,0)
                                           and nvl(tipo,' ') not in ('R','F') 
                                           and competenza in ('A','C')
                                           and servizio     = 'Q'
                                       ) 
                    AND mesi.anno = to_char(pere.al,'yyyy')
                    AND mesi.mese = to_char(pere.al,'mm')
                    AND pere.gestione       = CUR_CI.gestione
                    and pegi_p.ci(+)        = pere.ci
                    and pegi_p.rilevanza(+) = 'P'
                    and pere.al between nvl(pegi_p.dal(+), to_date('2222222','j'))
                                    and nvl(pegi_p.al(+), to_date('3333333','j'))
                    AND posi.codice      = pere.posizione
                    AND tira.codice (+)  = pere.tipo_rapporto
                    AND pere.figura      = figi.numero
                    AND pere.posizione   = nvl(rqmi.posizione,pere.posizione)
                    AND figi.dal         <= nvl(pere.al,to_date('3333333','j'))
                    AND nvl(figi.al,to_date('3333333','j')) 
                                         >= greatest(pere.dal, to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy'))
                    AND prpr.codice (+)  = figi.profilo
                    AND nvl(D_a,D_fin_a) between qumi.dal and nvl(qumi.al,to_date('3333333','j'))
                    AND rqmi.codice    = qumi.codice
                    AND rqmi.dal       = qumi.dal
                    AND (   (    rqmi.qualifica is null
                             and rqmi.figura     = pere.figura)
                         or (    rqmi.figura    is null
                             and rqmi.qualifica  = pere.qualifica)
                         or (    rqmi.qualifica is not null
                             and rqmi.figura    is not null
                             and rqmi.qualifica  = pere.qualifica
                             and rqmi.figura     = pere.figura)
                         or (    rqmi.qualifica is null
                             and rqmi.figura    is null)
                        )
                    AND nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                    AND nvl(rqmi.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
                    AND nvl(rqmi.formazione_lavoro,posi.contratto_formazione) = posi.contratto_formazione
                    AND nvl(rqmi.part_time,posi.part_time) = posi.part_time
                    AND nvl(pere.tipo_rapporto,'NULL')     = nvl(rqmi.tipo_rapporto, nvl(pere.tipo_rapporto,'NULL'))
                    AND exists (select 'x'
                                  from rapporti_individuali
                                 where ci        = pere.ci
                                   and rapporto in ( select codice
                                  from classi_rapporto
                                 where giuridico = 'SI'
                                   and retributivo = 'SI')
                               )
                    AND cost.contratto    = pere.contratto
                    and nvl(pere.al,D_fin_a)
                        between cost.dal and nvl(cost.al,to_date('3333333','j'))
                   union
/*  Lettura dei dati per applicazione: casi particolari personale universitario non gestito in DQUMI ma solo in DFIGU */
                    SELECT greatest( to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy')
                                   , pere.dal ) dal_periodo
                         , pere.al  al_periodo
                         , greatest( greatest( nvl( pegi_p.dal, to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy'))
                                             , pere.dal 
                                             , to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy') 
                                             )
                                   , figi.dal ) dal
                         , to_date(to_char(decode( least( nvl(pere.al, to_date('3333333','j'))
                                                        , nvl(figi.al, to_date('3333333','j')))
                                                 , to_date('3333333','j'), to_date(null)
                                                                         , least( nvl(pere.al, to_date('3333333','j'))
                                                                                , nvl(figi.al, to_date('3333333','j')))
                                                  ),'dd/mm/yyyy' ),'dd/mm/yyyy' )  al
                         , ''                          qua_min
                         , ''                          cat_min
                         , decode(nvl(cost.conto_annuale,9)
                                  ,1 , decode( pere.tipo_rapporto
                                              , null, 0
                                                    , nvl(tira.conto_annuale,0)
                                             )
                                     , to_number(null)
                                 )                     fascia
                         , figi.codice_ministero       fig_min
                         , figi.codice_ministero_01    fig_min_01
                         , prpr.codice_ministero       pro_min
                         , posi.tempo_determinato      tem_det
                         , posi.part_time              part_time
                         , decode(posi.part_time
                                 ,'SI', round(pere.ore/cost.ore_lavoro*100,2)
                                      , null )         perc_part_time
                         , posi.universitario          uni
                         , posi.contratto_formazione   con_for
                         , posi.lsu                    lsu
                         , 4                           flag
                   FROM periodi_retributivi          pere
                      , periodi_giuridici            pegi_p
                      , posizioni                    posi
                      , tipi_rapporto                tira
                      , figure_giuridiche            figi
                      , profili_professionali        prpr
                      , contratti_storici            cost
                      , mesi
                  WHERE nvl(P_decorrenza, 'Y') = 'Y'
                    AND pere.ci          = CUR_CI.ci
                    AND pere.competenza in ('A','C')
                    and pere.servizio     = 'Q'
                    AND nvl(pere.tipo,' ') not in ('R','F') 
                    AND pere.periodo between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                    AND pere.al      between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                    AND pere.periodo = (select max(periodo)
                                          from periodi_retributivi 
                                         where ci       = pere.ci
                                           and periodo >= to_date(mesi.anno||lpad(mesi.mese,2,0),'yyyymm')
                                           and periodo <= nvl(D_a,D_fin_a)
                                           and to_char(al,'yyyymm') = mesi.anno||lpad(mesi.mese,2,0)
                                           and nvl(tipo,' ') not in ('R','F') 
                                           and competenza in ('A','C')
                                           and servizio     = 'Q'
                                       ) 
                    AND mesi.anno = to_char(pere.al,'yyyy')
                    AND mesi.mese = to_char(pere.al,'mm')
                    AND pere.gestione       = CUR_CI.gestione
                    and pegi_p.ci(+)        = pere.ci
                    and pegi_p.rilevanza(+) = 'P'
                    and pere.al between nvl(pegi_p.dal(+), to_date('2222222','j'))
                                    and nvl(pegi_p.al(+), to_date('3333333','j'))
                    AND posi.codice      = pere.posizione
                    AND tira.codice (+)  = pere.tipo_rapporto
                    AND pere.figura      = figi.numero
                    AND figi.dal         <= nvl(pere.al,to_date('3333333','j'))
                    AND nvl(figi.al,to_date('3333333','j')) 
                                         >= greatest(pere.dal, to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy'))
                    AND prpr.codice (+)  = figi.profilo
                    AND prpr.codice_ministero is not null 
                    and posi.universitario = 'SI'
                    AND not exists ( select 'x'
                                       from righe_qualifica_ministeriale rqmi1
                                          , qualifiche_ministeriali qumi1
                                      where nvl(D_a,D_fin_a) 
                                            between qumi1.dal and nvl(qumi1.al,to_date('3333333','j'))
                                        and rqmi1.codice    = qumi1.codice
                                        AND rqmi1.dal       = qumi1.dal
                                        AND pere.posizione  = nvl(rqmi1.posizione,pere.posizione)
                                        AND (   (    rqmi1.qualifica is null
                                                 and rqmi1.figura     = pere.figura)
                                             or (    rqmi1.figura    is null
                                                 and rqmi1.qualifica  = pere.qualifica)
                                             or (    rqmi1.qualifica is not null
                                                 and rqmi1.figura    is not null
                                                 and rqmi1.qualifica  = pere.qualifica
                                                 and rqmi1.figura     = pere.figura)
                                             or (    rqmi1.qualifica is null
                                                 and rqmi1.figura    is null)
                                            )
                                        AND nvl(rqmi1.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                                        AND nvl(rqmi1.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
                                        AND nvl(rqmi1.formazione_lavoro,posi.contratto_formazione) = posi.contratto_formazione
                                        AND nvl(rqmi1.part_time,posi.part_time) = posi.part_time
                                        AND nvl(pere.tipo_rapporto,'NULL')     = nvl(rqmi1.tipo_rapporto, nvl(pere.tipo_rapporto,'NULL'))
                                   )
                    AND exists (select 'x'
                                 from rapporti_individuali
                                             where ci        = pere.ci
                                             and rapporto in ( select codice
                                                     from classi_rapporto
                                                    where giuridico = 'SI'
                                                      and retributivo = 'SI')
                                           )
                    AND cost.contratto    = pere.contratto
                    and nvl(pere.al,D_fin_a)
                        between cost.dal and nvl(cost.al,to_date('3333333','j'))
                   union
/*  Lettura dei dati per applicazione: estrazione dipendenti NON elaborati in caso di archiviazione effettiva */
                    SELECT pegi.dal dal_periodo
                         , pegi.al al_periodo
                         , greatest(pegi.dal,figi.dal) dal
                         , to_date(to_char(decode( least( nvl(pegi.al, to_date('3333333','j'))
                                                        , nvl(figi.al, to_date('3333333','j')))
                                                 , to_date('3333333','j'), to_date(null)
                                                                         , least( nvl(pegi.al, to_date('3333333','j'))
                                                                                , nvl(figi.al, to_date('3333333','j')))
                                                  ),'dd/mm/yyyy' ),'dd/mm/yyyy' )  al
                         , rqmi.codice                 qua_min
                         , qumi.categoria              cat_min
                         , decode(nvl(cost.conto_annuale,9)
                                  ,1 , decode( pegi.tipo_rapporto
                                              , null, 0
                                                    , nvl(tira.conto_annuale,0)
                                             )
                                     , to_number(null)
                                 )                     fascia
                         , figi.codice_ministero       fig_min
                         , figi.codice_ministero_01    fig_min_01
                         , prpr.codice_ministero       pro_min
                         , posi.tempo_determinato      tem_det
                         , posi.part_time              part_time
                         , decode(posi.part_time
                                 ,'SI', round(PEGI.ore/cost.ore_lavoro*100,2)
                                      , null )         perc_part_time
                         , posi.universitario          uni
                         , posi.contratto_formazione   con_for
                         , posi.lsu                    lsu
                         , 5                           flag
                   FROM periodi_giuridici pegi
                      , posizioni posi
                      , tipi_rapporto     tira
                      , figure_giuridiche figi
                      , qualifiche_ministeriali qumi
                      , righe_qualifica_ministeriale rqmi
                      , profili_professionali prpr
                      , contratti_storici cost
                  WHERE nvl(P_decorrenza, 'Y') = 'Y'
                    AND pegi.ci          = CUR_CI.ci
                    AND pegi.rilevanza   = 'S'
                    AND pegi.dal         <= nvl(D_a,D_fin_a)
                    AND nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                    AND pegi.gestione    = CUR_CI.gestione
                    AND posi.codice      = pegi.posizione
                    AND tira.codice (+)  = pegi.tipo_rapporto
                    AND pegi.figura      = figi.numero
                    AND pegi.posizione   = nvl(rqmi.posizione,pegi.posizione)
                    AND figi.dal         <= nvl(pegi.al,to_date('3333333','j'))
                    AND nvl(figi.al,to_date('3333333','j')) >= pegi.dal
                    AND prpr.codice (+)  = figi.profilo
                    AND nvl(D_a,D_fin_a) between qumi.dal and nvl(qumi.al,to_date('3333333','j'))
                    AND rqmi.codice    = qumi.codice
                    AND rqmi.dal       = qumi.dal
                    AND (   (    rqmi.qualifica is null
                             and rqmi.figura     = pegi.figura)
                         or (    rqmi.figura    is null
                             and rqmi.qualifica  = pegi.qualifica)
                         or (    rqmi.qualifica is not null
                             and rqmi.figura    is not null
                             and rqmi.qualifica  = pegi.qualifica
                             and rqmi.figura     = pegi.figura)
                         or (    rqmi.qualifica is null
                             and rqmi.figura    is null)
                        )
                    AND nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                    AND nvl(rqmi.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
                    AND nvl(rqmi.formazione_lavoro,posi.contratto_formazione) = posi.contratto_formazione
                    AND nvl(rqmi.part_time,posi.part_time) = posi.part_time
                    AND nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqmi.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
                    AND exists (select 'x'
                                  from rapporti_individuali
                                 where ci        = pegi.ci
                                   and rapporto in ( select codice
                                  from classi_rapporto
                                 where giuridico = 'SI'
                                   and retributivo = 'SI')
                               )
                    AND  cost.contratto    =
                         (select contratto
                            from QUALIFICHE_GIURIDICHE
                           where numero = pegi.qualifica
                             and PEGI.dal between dal  and NVL(al,TO_DATE('3333333','j'))
                          )
                    and nvl(pegi.al,D_fin_a)
                        between cost.dal and nvl(cost.al,to_date('3333333','j'))
                    AND not exists ( select 'x'
                                       from periodi_retributivi pere
                                      where pere.ci  = pegi.ci
                                        AND pere.competenza in ('A','C')
                                        and pere.servizio     = 'Q'
                                        AND nvl(pere.tipo,' ') not in ('R','F') 
                                        AND pere.periodo between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                                        AND pere.al      between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                                   ) 
                   union
/*  Lettura dei dati per applicazione: estrazione dipendenti NON elaborati in caso di archiviazione effettiva
 casi particolari personale universitario non gestito in DQUMI ma solo in DFIGU e/o DPRPR ) */
                    SELECT pegi.dal dal_periodo
                         , pegi.al al_periodo 
                         , greatest(pegi.dal,figi.dal) dal
                         , to_date(to_char(decode( least( nvl(pegi.al, to_date('3333333','j'))
                                                        , nvl(figi.al, to_date('3333333','j')))
                                                 , to_date('3333333','j'), to_date(null)
                                                                         , least( nvl(pegi.al, to_date('3333333','j'))
                                                                                , nvl(figi.al, to_date('3333333','j')))
                                                  ),'dd/mm/yyyy' ),'dd/mm/yyyy' )  al
                         , ''                          qua_min
                         , ''                          cat_min
                         , decode(nvl(cost.conto_annuale,9)
                                  ,1 , decode( pegi.tipo_rapporto
                                              , null, 0
                                                    , nvl(tira.conto_annuale,0)
                                             )
                                     , to_number(null)
                                 )                     fascia
                         , figi.codice_ministero       fig_min
                         , figi.codice_ministero_01    fig_min_01
                         , prpr.codice_ministero       pro_min
                         , posi.tempo_determinato      tem_det
                         , posi.part_time              part_time
                         , decode(posi.part_time
                                 ,'SI', round(PEGI.ore/cost.ore_lavoro*100,2)
                                      , null )         perc_part_time
                         , posi.universitario          uni
                         , posi.contratto_formazione   con_for
                         , posi.lsu                    lsu
                         , 6                           flag
                   FROM periodi_giuridici pegi
                      , posizioni posi
                      , tipi_rapporto     tira
                      , figure_giuridiche figi
                      , profili_professionali prpr
                      , contratti_storici cost
                  WHERE nvl(P_decorrenza, 'Y') = 'Y'
                    AND pegi.ci          = CUR_CI.ci
                    AND pegi.rilevanza   = 'S'
                    AND pegi.dal         <= nvl(D_a,D_fin_a)
                    AND nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                    AND pegi.gestione    = CUR_CI.gestione
                    AND posi.codice      = pegi.posizione
                    AND tira.codice (+)  = pegi.tipo_rapporto
                    AND pegi.figura      = figi.numero
                    AND figi.dal         <= nvl(pegi.al,to_date('3333333','j'))
                    AND nvl(figi.al,to_date('3333333','j')) >= pegi.dal
                    AND prpr.codice (+)  = figi.profilo
                    AND prpr.codice_ministero is not null 
                    and posi.universitario = 'SI'
                    AND not exists ( select 'x'
                                       from righe_qualifica_ministeriale rqmi1
                                          , qualifiche_ministeriali qumi1
                                      where nvl(D_a,D_fin_a) 
                                            between qumi1.dal and nvl(qumi1.al,to_date('3333333','j'))
                                        and rqmi1.codice    = qumi1.codice
                                        AND rqmi1.dal       = qumi1.dal
                                        AND pegi.posizione   = nvl(rqmi1.posizione,pegi.posizione)
                                        AND (   (    rqmi1.qualifica is null
                                                 and rqmi1.figura     = pegi.figura)
                                             or (    rqmi1.figura    is null
                                                 and rqmi1.qualifica  = pegi.qualifica)
                                             or (    rqmi1.qualifica is not null
                                                 and rqmi1.figura    is not null
                                                 and rqmi1.qualifica  = pegi.qualifica
                                                 and rqmi1.figura     = pegi.figura)
                                             or (    rqmi1.qualifica is null
                                                 and rqmi1.figura    is null)
                                            )
                                        AND nvl(rqmi1.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
                                        AND nvl(rqmi1.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
                                        AND nvl(rqmi1.formazione_lavoro,posi.contratto_formazione) = posi.contratto_formazione
                                        AND nvl(rqmi1.part_time,posi.part_time) = posi.part_time
                                        AND nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqmi1.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
                                   )
                    AND exists (select 'x'
                                 from rapporti_individuali
                                             where ci        = pegi.ci
                                             and rapporto in ( select codice
                                                     from classi_rapporto
                                                    where giuridico = 'SI'
                                                      and retributivo = 'SI')
                                           )
                    AND  cost.contratto    =
                         (select contratto
                            from QUALIFICHE_GIURIDICHE
                           where numero = pegi.qualifica
                             and PEGI.dal between dal  and NVL(al,TO_DATE('3333333','j'))
                          )
                    and nvl(pegi.al,D_fin_a)
                        between cost.dal and nvl(cost.al,to_date('3333333','j'))
                    AND not exists ( select 'x'
                                       from periodi_retributivi pere
                                      where pere.ci  = pegi.ci
                                        AND pere.competenza in ('A','C')
                                        and pere.servizio     = 'Q'
                                        AND nvl(pere.tipo,' ') not in ('R','F') 
                                        AND pere.periodo between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                                        AND pere.al      between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                                   ) 
                    ORDER BY 1,2
                 ) LOOP

                  D_controllo := null;
-- dbms_output.put_line('Cursore sui periodi '||CUR_PEGI.dal||' '||CUR_PEGI.al||' flag: '||CUR_PEGI.flag);
                  BEGIN
                   D_trovato  := 1;
                   D_conta    := D_conta + 1;
-- dbms_output.put_line('Conta '||to_char(D_conta));
                   IF D_conta = 1 THEN -- Se primo recod memorizza i dati da confrontare con i record successivi
                      D_qua_min        := CUR_PEGI.qua_min;
                      D_cat_min        := CUR_PEGI.cat_min;
                      D_fascia         := CUR_PEGI.fascia;
                      D_fig_min        := CUR_PEGI.fig_min;
                      D_fig_min_01     := CUR_PEGI.fig_min_01;
                      D_pro_min        := CUR_PEGI.pro_min;
                      D_tem_det        := CUR_PEGI.tem_det;
                      D_part_time      := CUR_PEGI.part_time;
                      D_perc_part_time := CUR_PEGI.perc_part_time;
                      D_uni            := CUR_PEGI.uni;
                      D_con_for        := CUR_PEGI.con_for;
                      D_lsu            := CUR_PEGI.lsu;
                      D_dal            := CUR_PEGI.dal;
                      D_al             := CUR_PEGI.al;
-- Dal secondo record in poi confronta i dati correnti con quelli del record precedente
                    ELSIF nvl(D_qua_min,' ')      = nvl(CUR_PEGI.qua_min,' ')
                      AND nvl(D_cat_min,' ')      = nvl(CUR_PEGI.cat_min,' ')
                      AND nvl(D_fascia,9)         = nvl(CUR_PEGI.fascia,9)
                      AND nvl(D_fig_min,' ')      = nvl(CUR_PEGI.fig_min,' ')
                      AND nvl(D_fig_min_01,' ')   = nvl(CUR_PEGI.fig_min_01,' ')
                      AND nvl(D_pro_min,' ')      = nvl(CUR_PEGI.pro_min,' ')
                      AND nvl(D_tem_det,' ')      = nvl(CUR_PEGI.tem_det,' ')
                      AND nvl(D_part_time,' ')    = nvl(CUR_PEGI.part_time ,' ')
                      AND nvl(D_perc_part_time,0) = nvl(CUR_PEGI.perc_part_time,0)
                      AND nvl(D_uni,' ')          = nvl(CUR_PEGI.uni,' ')
                      AND nvl(D_con_for,' ')      = nvl(CUR_PEGI.con_for,' ')
                      AND nvl(D_lsu,' ')          = nvl(CUR_PEGI.lsu,' ')
                      AND CUR_PEGI.dal = D_al + 1 
                     THEN
-- dbms_output.put_line(' dati uguali e date consecutive ');
-- Se dati uguali e date consecutive unifica il perido
                       D_al   := CUR_PEGI.al;
                    ELSE
-- dbms_output.put_line(' dati NON uguali o date NON consecutive ');
-- dbms_output.put_line('Dal: '||D_dal);
-- Se dati non uguali e date non consecutive, inserisce primo record e memorizza dati record corrente
-- dbms_output.put_line('Periodi del Cursore '||to_char(CUR_PEGI.dal,'dd/mm/yyyy')||' - '||to_char(CUR_PEGI.al,'dd/mm/yyyy')||' Per il CI: '||to_char(CUR_CI.ci));
                      BEGIN
                        select 'x'
                          into D_controllo
                          from SMT_PERIODI
                         where anno     = D_anno
                           and ci       = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                           and dal      = D_dal
                       ;
-- dbms_output.put_line('Controllo: '||D_controllo);
                       raise too_many_rows;
                      EXCEPTION
                        WHEN no_data_found THEN
-- dbms_output.put_line('Inserisco il periodo A '||to_char(CUR_PEGI.dal,'dd/mm/yyyy')||' - '||to_char(CUR_PEGI.al,'dd/mm/yyyy')||' Per il CI: '||to_char(CUR_CI.ci));
                      IF  nvl(P_decorrenza, 'Y') = 'Y' and D_al = nvl(D_a, D_fin_a) THEN
                        BEGIN
                          select to_date(null)
                            into D_al
                            from dual
                           where exists ( select 'x' 
                                            from periodi_giuridici
                                           where ci = CUR_CI.ci
                                             and rilevanza = 'P'
                                             and nvl(D_a,D_fin_a) between dal 
                                                                      and nvl(al,to_date('3333333','j'))-1 
                                        )
                         ;
                        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
                        END;
                      END IF;
-- dbms_output.put_line('Date Caricate1  '||D_dal||' - '||D_al);
                              insert into SMT_PERIODI
                              ( ANNO,CI,GESTIONE,DAL,AL,QUALIFICA,CATEGORIA,FASCIA,FIGURA,PROFILO_01,PROFILO
                              , TEMPO_DETERMINATO,TEMPO_PIENO,PART_TIME,UNIVERSITARIO,FORMAZIONE
                              , LSU,INTERINALE,TELELAVORO,ASSUNZIONE,CESSAZIONE,DA_QUALIFICA
                              , UTENTE,TIPO_AGG,DATA_AGG )
                              values (D_anno
                                    , CUR_CI.ci
                                    , CUR_CI.gestione
                                    , D_dal
                                    , D_al
                                    , D_qua_min
                                    , D_cat_min
                                    , D_fascia
                                    , D_fig_min
                                    , D_fig_min_01
                                    , D_pro_min
                                    , D_tem_det
                                    , decode(D_part_time,'SI','NO','SI')
                                    , nvl(D_perc_part_time,decode(D_part_time,'SI',100,D_perc_part_time))
                                    , D_uni
                                    , D_con_for
                                    , D_lsu
                                    , null -- interinale
                                    , null -- telelavoro
                                    , null -- assunzione
                                    , null -- cessazione
                                    , null -- da_qualifica
                                    , D_utente
                                    , null
                                    , sysdate
                                    )
                           ;
                            D_qua_min        := CUR_PEGI.qua_min;
                            D_cat_min        := CUR_PEGI.cat_min;
                            D_fascia         := CUR_PEGI.fascia;
                            D_fig_min        := CUR_PEGI.fig_min;
                            D_fig_min_01     := CUR_PEGI.fig_min_01;
                            D_pro_min        := CUR_PEGI.pro_min;
                            D_tem_det        := CUR_PEGI.tem_det;
                            D_part_time      := CUR_PEGI.part_time;
                            D_perc_part_time := CUR_PEGI.perc_part_time;
                            D_uni            := CUR_PEGI.uni;
                            D_con_for        := CUR_PEGI.con_for;
                            D_lsu            := CUR_PEGI.lsu;
                            D_dal            := CUR_PEGI.dal;
                            D_al             := CUR_PEGI.al;
                        WHEN too_many_rows THEN
                          d_riga := D_riga + 1;
                          V_testo := lpad('Errore 008',10)||
                                     lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                     lpad(nvl(CUR_CI.ci,0),8,0)||
                                     lpad(nvl(to_char(D_dal,'ddmmyyyy'),' '),8,' ')||
                                     lpad(nvl(to_char(D_al,'ddmmyyyy'),' '),8,' ')||
                                     rpad('Estrazione record doppi: verificare DQUMI',132,' ');
                            insert into a_appoggio_stampe
                             (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                            select  prenotazione
                                   , 1
                                   , D_pagina
                                   , D_riga
                                   , V_testo
                               from dual
                              where not exists ( select 'x' 
                                                   from a_appoggio_stampe
                                                  where no_prenotazione = prenotazione
                                                    and passo = 1
                                                    and testo = V_testo
                                                  )
                             ;
                        END;
                   END IF;
                 END;
               END LOOP; -- CUR_PEGI
               -- Inserimento ultimo record CUR_PEGI
-- dbms_output.put_line('D_trovato '||to_char(D_trovato));
               IF D_trovato = 1 THEN
                  BEGIN
                        select 'x'
                          into D_controllo
                          from SMT_PERIODI
                         where anno     = D_anno
                           and ci       = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                           and dal      = D_dal
                       ;
                   raise too_many_rows;
                   EXCEPTION
                        WHEN no_data_found THEN
-- dbms_output.put_line('Inserisco il periodo B '||to_char(D_dal,'dd/mm/yyyy')||' - '||to_char(D_al,'dd/mm/yyyy')||' Per il CI: '||to_char(CUR_CI.ci));
                      IF  nvl(P_decorrenza, 'Y') = 'Y' and D_al = nvl(D_a, D_fin_a) THEN
                        BEGIN
                          select to_date(null)
                            into D_al
                            from dual
                           where exists ( select 'x' 
                                            from periodi_giuridici
                                           where ci = CUR_CI.ci
                                             and rilevanza = 'P'
                                             and nvl(D_a,D_fin_a) between dal 
                                                                      and nvl(al,to_date('3333333','j'))-1 
                                        )
                         ;
                        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
                        END;
                      END IF;
-- dbms_output.put_line('Date Caricate1  '||D_dal||' - '||D_al);
                              insert into SMT_PERIODI
                              ( ANNO,CI,GESTIONE,DAL,AL,QUALIFICA,CATEGORIA,FASCIA,FIGURA,PROFILO_01,PROFILO
                              , TEMPO_DETERMINATO,TEMPO_PIENO,PART_TIME,UNIVERSITARIO,FORMAZIONE
                              , LSU,INTERINALE,TELELAVORO,ASSUNZIONE,CESSAZIONE,DA_QUALIFICA
                              , UTENTE,TIPO_AGG,DATA_AGG )
                              values (D_anno
                                    , CUR_CI.ci
                                    , CUR_CI.gestione
                                    , D_dal
                                    , D_al
                                    , D_qua_min
                                    , D_cat_min
                                    , D_fascia
                                    , D_fig_min
                                    , D_fig_min_01
                                    , D_pro_min
                                    , D_tem_det
                                    , decode(D_part_time,'SI','NO','SI')
                                    , nvl(D_perc_part_time,decode(D_part_time,'SI',100,D_perc_part_time))
                                    , D_uni
                                    , D_con_for
                                    , D_lsu
                                    , null -- interinale
                                    , null -- telelavoro
                                    , null -- assunzione
                                    , null -- cessazione
                                    , null -- da_qualifica
                                    , D_utente
                                    , null
                                    , sysdate
                                    )
                                 ;
                        WHEN too_many_rows THEN
                             d_riga := D_riga + 1;
                             V_testo := lpad('Errore 008',10)||
                                      lpad(CUR_CI.gestione,4)||
                                      lpad(CUR_CI.ci,8,0)||
                                      lpad(nvl(to_char(D_dal,'ddmmyyyy'),' '),8,' ')||
                                      lpad(nvl(to_char(D_al,'ddmmyyyy'),' '),8,' ')||
                                      rpad('Estrazione record doppi: verificare DQUMI',132);
                             insert into a_appoggio_stampe
                             (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                             select  prenotazione
                                    , 1
                                    , D_pagina
                                    , D_riga
                                    , V_testo
                               from dual
                              where not exists ( select 'x' 
                                                   from a_appoggio_stampe
                                                  where no_prenotazione = prenotazione
                                                    and passo = 1
                                                    and testo = V_testo
                                               )
                                     ;
                  END;
                END IF;
               END PERIODI;
   COMMIT;
-- dbms_output.put_line('Fine Caricamento periodi');
              -- segnalazione periodi di PEGI non archiviati
                 BEGIN
                 <<ANOMALIE1>>
                   FOR CUR_ANOM IN
                        (select pegi.dal
                              , pegi.al
                              , pegi.qualifica
                              , qugi.codice               cod_qua
                              , tipo_rapporto
                              , di_ruolo
                              , tempo_determinato
                              , part_time
                              , contratto_formazione
                              , clra.codice               cod_cla
                              , figi.codice               cod_fig
                           from periodi_giuridici pegi
                              , posizioni posi
                              , classi_rapporto clra
                              , rapporti_individuali rain
                              , qualifiche_giuridiche qugi
                              , figure_giuridiche figi
                         where nvl(P_decorrenza, 'Y') = 'X'
                           and rilevanza = 'S'
                           and pegi.ci = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                           and rain.rapporto  = clra.codice
                           and rain.ci = pegi.ci
                           and posi.codice      = pegi.posizione
                           and pegi.qualifica = qugi.numero
                           and pegi.figura = figi.numero
                           and pegi.dal between figi.dal and nvl(figi.al,to_date('3333333','j'))
                           and pegi.dal between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
                           and not exists (select 'x'
                                             from smt_periodi
                                            where ci = pegi.ci
                                              and anno = D_anno
                                              and gestione = pegi.gestione
                                              and greatest( dal, D_fin_ap) <= greatest( pegi.dal, D_fin_ap)
                                              and least(nvl(al,to_date('3333333','j')),D_fin_a)
                                                  >= least( nvl(pegi.al,to_date('3333333','j')),D_fin_a)
                                           )
                          and pegi.dal       <= nvl(D_a,D_fin_a)
                          and nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                          and exists (select 'x' from smt_individui smin
                                       where ci = pegi.ci
                                         and gestione = pegi.gestione
                                         and anno = D_anno
                                         and nvl(est_comandato,'NO') = 'NO'
                                     )
                        union
/* segnalazione da periodi retributivi */
                         select to_date(null) dal
                              , to_date(null) al
                              , pere.qualifica
                              , qugi.codice               cod_qua
                              , tipo_rapporto
                              , di_ruolo
                              , tempo_determinato
                              , part_time
                              , contratto_formazione
                              , clra.codice               cod_cla
                              , figi.codice               cod_fig
                           from periodi_retributivi pere
                              , posizioni posi
                              , classi_rapporto clra
                              , rapporti_individuali rain
                              , qualifiche_giuridiche qugi
                              , figure_giuridiche figi
                              , mesi
                         where nvl(P_decorrenza, 'Y') = 'Y'
                           and pere.ci = CUR_CI.ci
                           AND pere.competenza in ('A','C')
                           and pere.servizio     = 'Q'
                           AND nvl(pere.tipo,' ') not in ('R','F') 
                           AND pere.periodo between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                           AND pere.al      between nvl(D_da-1,D_fin_ap) and nvl(D_a,D_fin_a)
                           AND pere.periodo = (select max(periodo)
                                                 from periodi_retributivi 
                                                where ci       = pere.ci
                                                  and periodo >= to_date(mesi.anno||lpad(mesi.mese,2,0),'yyyymm')
                                                  and periodo <= nvl(D_a,D_fin_a)
                                                  and to_char(al,'yyyymm') = mesi.anno||lpad(mesi.mese,2,0)
                                                  and nvl(tipo,' ') not in ('R','F') 
                                                  and competenza in ('A','C')
                                                  and servizio     = 'Q'
                                               ) 
                           AND mesi.anno = to_char(pere.al,'yyyy')
                           AND mesi.mese = to_char(pere.al,'mm')
                           and gestione = CUR_CI.gestione
                           and rain.rapporto  = clra.codice
                           and rain.ci = pere.ci
                           and posi.codice      = pere.posizione
                           and pere.qualifica = qugi.numero
                           and pere.figura = figi.numero
                           AND figi.dal         <= nvl(pere.al,to_date('3333333','j'))
                           AND nvl(figi.al,to_date('3333333','j')) 
                               >= greatest(pere.dal, to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy'))
                           AND qugi.dal         <= nvl(pere.al,to_date('3333333','j'))
                           AND nvl(qugi.al,to_date('3333333','j')) 
                               >= greatest(pere.dal, to_date('01'||lpad(mesi.mese,2,'0')||mesi.anno,'ddmmyyyy'))
                           and not exists (select 'x'
                                             from smt_periodi
                                            where ci = pere.ci
                                              and anno = D_anno
                                              and gestione = pere.gestione
                                              and least(nvl(pere.al,to_date('3333333','j')),D_fin_a)
                                                  between dal and least(nvl(al,to_date('3333333','j')),D_fin_a)
                                           )
                           and exists (select 'x' from smt_individui smin
                                        where ci = pere.ci
                                          and gestione = pere.gestione
                                          and anno = D_anno
                                          and nvl(est_comandato,'NO') = 'NO'
                                      )
                        order by 1
                        ) LOOP
-- dbms_output.put_line('Cursore Anomalie 1 : '||to_char(D_pagina)||' '||to_char(D_riga));
-- dbms_output.put_line('Dal: '||to_char(CUR_ANOM.dal,'ddmmyyyy')||' Al: '||to_char(CUR_ANOM.al,'ddmmyyyy'));
                         BEGIN
                           d_riga := D_riga + 1;
                           V_testo := lpad('Errore 001',10)||
                                      lpad(CUR_CI.gestione,4)||
                                      lpad(CUR_CI.ci,8,0)||
                                      lpad(nvl(to_char(CUR_ANOM.dal,'ddmmyyyy'),' '),8,' ')||
                                      lpad(nvl(to_char(CUR_ANOM.al,'ddmmyyyy'),' '),8,' ')||
                                      rpad('Individui e/o periodi non Archiviati',132)||
                                      lpad(nvl(CUR_ANOM.cod_qua,' '),8,' ')||
                                      lpad(nvl(CUR_ANOM.cod_fig,' '),8,' ')||
                                      lpad(nvl(CUR_ANOM.tipo_rapporto,' '),4,' ')||
                                      lpad(nvl(CUR_ANOM.di_ruolo,' '),1,' ')||
                                      lpad(nvl(CUR_ANOM.tempo_determinato,' '),2,' ')||
                                      lpad(nvl(CUR_ANOM.part_time,' '),2,' ')||
                                      lpad(nvl(CUR_ANOM.contratto_formazione,' '),2,' ')||
                                      lpad(nvl(CUR_ANOM.cod_cla,' '),4,' ');
                            insert into a_appoggio_stampe
                            (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                             select  prenotazione
                                    , 1
                                    , D_pagina
                                    , D_riga
                                    , V_testo
                               from dual
                              where not exists ( select 'x' 
                                                   from a_appoggio_stampe
                                                  where no_prenotazione = prenotazione
                                                    and passo = 1
                                                    and testo = V_testo
                                                  )
                             ;
                            END;
                   END LOOP; -- CUR_ANOM
                 END ANOMALIE1;
              BEGIN
-- dbms_output.put_line('Elaborazione periodi di assenza');
               FOR CUR_ASSENZE in
                (SELECT pegi.dal, pegi.al
                   FROM periodi_giuridici pegi
                  WHERE rilevanza = 'A'
                    AND evento in (select codice from eventi_giuridici
                                    where nvl(conto_annuale,0 ) = 99
                                  )
                    AND pegi.dal       <= nvl(D_a,D_fin_a)
                    AND nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                    AND pegi.ci = CUR_CI.ci
                ) LOOP

                  BEGIN
                    D_dal_a := CUR_ASSENZE.dal;
                    D_al_a := CUR_ASSENZE.al;
-- dbms_output.put_line('cursore delle assenze');
-- dbms_output.put_line('Periodo di assenza dal/al '||to_char(D_dal_a,'dd/mm/yyyy')||'/'||to_char(D_al_a,'dd/mm/yyyy'));

                  FOR CUR_PERIODI in
                      (SELECT greatest(dal,nvl(D_da-1,D_fin_ap)) dal_p
                            , least(al,nvl(D_a,D_fin_a))         al_p
                            , dal, al
                         FROM smt_periodi
                        WHERE ci = CUR_CI.ci
                          and gestione = CUR_CI.gestione
                          and anno = D_anno
                          AND (   D_dal_a between dal and nvl(al,to_date('3333333','j'))
                               or nvl(D_al_a,to_date('3333333','j')) between dal and nvl(al,to_date('3333333','j'))
                              )
                      ) LOOP
                       BEGIN
                          D_dal_p := CUR_PERIODI.dal_p;
                          D_al_p := CUR_PERIODI.al_p;
-- dbms_output.put_line('Periodo di smt_periodi dal-al '||to_char(D_dal_p,'dd/mm/yyyy')||' - '||to_char(D_al_p,'dd/mm/yyyy'));
                          IF D_dal_a <= D_dal_p
                             and nvl(D_al_a,to_date('3333333','j')) >= nvl(D_al_p,to_date('3333333','j'))
                          THEN
-- periodo incluso in un periodo di assenza: i dal/al del periodo di assenza coincidono con il dal/al del periodo 
-- oppure assenza che copre tutto il periodo archiviato
-- quindi cancello
-- dbms_output.put_line('Caso 1');
                            BEGIN
                            delete from smt_periodi
                             where ci = CUR_CI.ci
                               and anno = D_anno
                               and gestione = CUR_CI.gestione
                               and dal = CUR_PERIODI.dal
                               and nvl(al,to_date('3333333','j')) = nvl(CUR_PERIODI.al,to_date('3333333','j'))
                            ;
                            D_riga := nvl(D_riga,0) + 1;
                            V_testo := lpad('Errore 010',10)||
                                       lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                       lpad(nvl(CUR_CI.ci,0),8,0)||
                                       lpad(nvl(to_char(D_dal_a,'ddmmyyyy'),' '),8,' ')||
                                       lpad(nvl(to_char(D_al_a,'ddmmyyyy'),' '),8,' ')||
                                       rpad('Dipendente in Astensione per tutto il periodo : Dati Non Archiviati',132,' ')
                                    ;
                            insert into a_appoggio_stampe(NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                            select prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , V_testo
                              from dual
                             where not exists ( select 'x' 
                                                  from a_appoggio_stampe
                                                 where no_prenotazione = prenotazione
                                                   and no_passo = 1
                                                   and pagina = D_pagina
                                                   and testo = V_testo
                                              ) 
                             ;
                            commit;
                            END;
                          ELSIF D_dal_a > D_dal_p THEN
-- periodo di assenza coperto da un periodo
-- l'assenza inizia all' interno del periodo archiviato che quindi cesso il giorno prima
-- dbms_output.put_line('Caso 2');
                            update smt_periodi
                               set al = D_dal_a-1
                                 , cessazione = 'ASP'
                             where ci = CUR_CI.ci
                               and gestione = CUR_CI.gestione
                               and anno = D_anno
                               and dal = CUR_PERIODI.dal
                               and nvl(al,to_date('3333333','j')) = nvl(CUR_PERIODI.al,to_date('3333333','j'))
                           ;
                           commit;
                           IF nvl(D_al_a,to_date('3333333','j')) < nvl(D_al_p,to_date('3333333','j')) THEN
-- dbms_output.put_line('Caso 2a');
-- assenza che inizia all'interno del periodo SMT di conclude anche quindi inserisco il pezzo seguente con assunzione
-- dbms_output.put_line('Inserisco il periodo D '||to_char(D_al_a+1,'dd/mm/yyyy')||' - '||to_char(D_al_p,'dd/mm/yyyy')||' Per il CI: '||to_char(CUR_CI.ci));
                               insert  into smt_periodi
                              ( ANNO,CI,GESTIONE,DAL,AL,QUALIFICA,CATEGORIA,FASCIA,FIGURA,PROFILO_01,PROFILO
                              , TEMPO_DETERMINATO,TEMPO_PIENO,PART_TIME,UNIVERSITARIO,FORMAZIONE
                              , LSU,INTERINALE,TELELAVORO,ASSUNZIONE,CESSAZIONE,DA_QUALIFICA
                              , UTENTE,TIPO_AGG,DATA_AGG )
                               select anno
                                    , ci
                                    , gestione
                                    , D_al_a+1
                                    , D_al_p
                                    , qualifica
                                    , categoria
                                    , fascia
                                    , figura
                                    , profilo_01
                                    , profilo
                                    , tempo_determinato
                                    , tempo_pieno
                                    , part_time
                                    , universitario
                                    , formazione
                                    , lsu
                                    , interinale
                                    , telelavoro
                                    , 'TASP'
                                    , null
                                    , da_qualifica
                                    , D_utente
                                    , null
                                    , sysdate
                                from smt_periodi
                               where ci = CUR_CI.ci
                                 and gestione = CUR_CI.gestione
                                 and anno = D_anno
                                 and dal = CUR_PERIODI.dal
                              ;
                            END IF; -- periodo D
                          ELSIF nvl(D_al_a,to_date('3333333','j'))
                                between D_dal_p and nvl(D_al_p,to_date('3333333','j')) THEN
-- dbms_output.put_line('Caso 3');
-- assenza che finisce all'interno del periodo SMT e inzia prima
                            update smt_periodi
                               set dal = nvl(D_al_a,D_fin_ap)+1
                                 , assunzione = 'TASP'
                             where ci = CUR_CI.ci
                               and gestione = CUR_CI.gestione
                               and anno = D_anno
                               and dal = CUR_PERIODI.dal
                               and nvl(al,to_date('3333333','j')) = nvl(CUR_PERIODI.al,to_date('3333333','j'))
                            ;
                          END IF; -- caso1
                        END;
                  END LOOP; -- CUR_PERIODI
                 END;
               END LOOP; -- CUR_ASSENZE
-- dbms_output.put_line('Fine elaborazione periodi di assenza');
              END;
              BEGIN
              <<ASS_CESS>>
-- dbms_output.put_line('Assegnazione di Assunzione - Cessazione - Da_qualifica');
-- dbms_output.put_line('CI '||to_char(CUR_CI.ci));
                FOR V_PER in CUR_PER(to_number(CUR_CI.ci), D_anno, CUR_CI.gestione) LOOP
-- dbms_output.put_line('dal/al: '||V_PER.dal||' '||V_PER.al);
                   --evento di assunzione
                   BEGIN
                       SELECT evento
                         INTO D_assunzione
                         FROM periodi_giuridici pegi
                         WHERE pegi.rilevanza = 'P'
                           AND pegi.ci  = CUR_CI.ci
                           AND pegi.dal = V_PER.dal
                           AND exists (select 'x'
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
                           AND pegi.ci  = CUR_CI.ci
                           AND nvl(pegi.al,to_date('3333333','j')) = nvl(V_PER.al,to_date('3333333','j'))
                           AND exists (select 'x'
                                         from eventi_rapporto evra
                                        where evra.codice = pegi.posizione
                                          and evra.rilevanza = 'T'
                                      )
                          ;
                   EXCEPTION
                        WHEN no_data_found then
                              D_cessazione := 'CESS';
                   END;
-- dbms_output.put_line('Cessazione '||D_cessazione);
                   IF CUR_PER%rowcount = 1 and V_PER.dal > D_fin_ap THEN
                      -- sono sul primo periodo
-- dbms_output.put_line('Aggiorno il primo periodo');
                          update smt_periodi
                             set assunzione = D_assunzione
                           where dal = V_PER.dal
                             and ci = CUR_CI.ci
                             and gestione = CUR_CI.gestione
                             and anno = D_anno
                             and not exists (select 'x'
                                               from periodi_giuridici
                                              where rilevanza = 'S'
                                                and ci = CUR_CI.ci
                                                and V_PER.dal-1 between dal and nvl(al,to_date('3333333','j'))
                                             )
                             and nvl(assunzione,'ASS') = 'ASS'
                            ;
                    ELSE    --non sono sul primo periodo, controllo se ho un periodo precedente
-- dbms_output.put_line('Sono sugli altri periodi');
                        IF V_PER.dal != T_al+1 THEN
-- dbms_output.put_line('Ho un periodo immediatamente precedente');
                            update smt_periodi
                               set assunzione = D_assunzione
                             where dal = V_PER.dal
                               and ci = CUR_CI.ci
                               and gestione = CUR_CI.gestione
                               and anno = D_anno
                               and nvl(assunzione,'ASS') = 'ASS'
                            ;
                          ELSE
                            update smt_periodi
                               set assunzione = D_assunzione
                             where dal = V_PER.dal
                               and ci = CUR_CI.ci
                               and gestione = CUR_CI.gestione
                               and anno = D_anno
                               and nvl(assunzione,'ASS') = 'ASS'
                               and exists (select 'x'
                                             from periodi_giuridici
                                            where rilevanza = 'P'
                                              and ci = CUR_CI.ci
                                              and V_PER.dal = dal
                                           )
                             ;
                        END IF;
                        IF V_PER.tempo_determinato = 'NO' and V_PER.dal = T_al+1 and T_temp_det = 'SI' THEN
-- dbms_output.put_line('Altri periodi con tempo determinato NO');
                            update smt_periodi
                               set assunzione = (select nvl(evento,'ASS')
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
                               and assunzione is null
                             ;
                             update smt_periodi
                                set cessazione = (select evento
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
                        END IF; -- fine controllo tempi determinati
                        -- qualifica di provenienza
                        IF V_PER.dal = T_al+1 and T_qualifica != V_PER.qualifica THEN
                            update smt_periodi
                               set da_qualifica = T_qualifica
                             where ci  = CUR_CI.ci
                               and gestione = CUR_CI.gestione
                               and anno = D_anno
                               and dal = V_PER.dal
                             ;
                        END IF; -- fine controllo qualifica di provenienza
                   END IF; -- fine controllo su primo periodo
-- Tratto la cessazione su ogni periodo (anche il primo)
                            update smt_periodi
                              set cessazione = D_cessazione
                             where nvl(al,to_date('3333333','j')) = V_PER.al
                               and ci = CUR_CI.ci
                               and gestione = CUR_CI.gestione
                               and anno = D_anno
                               and nvl(cessazione,'CESS') = 'CESS'
                               and ( not exists (select 'x'
                                                   from periodi_giuridici
                                                  where rilevanza = 'S'
                                                    and ci = CUR_CI.ci
                                                    and nvl(V_PER.al,to_date('3333333','j'))+1 between dal
                                                    and nvl(al,to_date('3333333','j'))
                                                 )
                                      or exists (select 'x'
                                                   from periodi_giuridici
                                                  where rilevanza = 'P'
                                                    and ci = CUR_CI.ci
                                                    and V_PER.al = al
                                                )
                                   )
                                ;
             -- conservo le variabili per il periodo precedente
                   T_dal       := V_PER.dal;
                   T_al        := V_PER.al;
                   T_temp_det  := V_PER.tempo_determinato;
                   T_qualifica := V_PER.qualifica;
-- dbms_output.put_line('Periodo dal '||to_char(V_PER.dal,'dd/mm/yyyy'));
-- dbms_output.put_line('Periodo  al '||to_char(V_PER.al,'dd/mm/yyyy'));
                END LOOP; -- CUR_PER
-- dbms_output.put_line('Ultimo periodo');
-- dbms_output.put_line('Periodo precedente dal '||T_dal);
-- dbms_output.put_line('Periodo precedente  al '||T_al);

            -- se ho piu periodi per un CI esco per l'ultimo periodo del CI e lo devo trattare
                      update smt_periodi
                         set cessazione = D_cessazione
                       where dal = T_dal
                         and ci = CUR_CI.ci
                         and gestione = CUR_CI.gestione
                         and anno = D_anno
                         and nvl(al,to_date('3333333','j')) < D_fin_a
                         and not exists (select 'x'
                                           from periodi_giuridici
                                          where rilevanza = 'S'
                                            and ci = CUR_CI.ci
                                            and T_al+1 between dal and nvl(al,to_date('3333333','j'))
                                        )
                         and nvl(cessazione,'CESS') = 'CESS'
                        ;
              END ASS_CESS;
              BEGIN
-- dbms_output.put_line('prima della anomalie 2: '||CUR_CI.ci||' '||CUR_CI.gestione||' '||D_anno);
              <<ANOMALIE2>>
                 FOR CUR_ANOM2 IN
                    (select 'Errore 002' errore, dal, al
                          , 'Individui con posizioni giuridiche anomale: Tempo Determinato, Formazione lavoro ed Lsu' testo
                          , null det
                       from smt_periodi
                      where ci       = CUR_CI.ci
                        and gestione = CUR_CI.gestione
                        and anno = D_anno
                        and tempo_determinato    = 'NO'
                        and ( formazione           = 'SI'
                        or lsu             = 'SI')
                      UNION
                      select 'Errore 003',dal,al
                           , 'Individui con periodi anomali: Formazione lavoro, Lsu, Interinale e Telelavoro'
                           , null
                        from smt_periodi
                       where ci       = CUR_CI.ci
                         and anno = D_anno
                         and gestione = CUR_CI.gestione
                         and nvl(formazione,'NO')||nvl(lsu,'NO')||nvl(interinale,'NO')||nvl(telelavoro,'NO') like '%S%S%'
                      UNION
                      select 'Errore 004',dal,al
                           , 'Eventi di assunzione o cessazione attivati al valore di default'
                           , 'Assunzione'
                        from smt_periodi
                       where ci       = CUR_CI.ci
                         and anno = D_anno
                         and gestione = CUR_CI.gestione
                         and assunzione = 'ASS'
                         and dal between D_fin_ap and D_fin_a
                      UNION
                      select 'Errore 004',dal,al
                           , 'Eventi di assunzione o cessazione attivati al valore di default'
                           , 'Cessazione'
                        from smt_periodi
                       where ci       = CUR_CI.ci
                         and anno = D_anno
                         and gestione = CUR_CI.gestione
                         and cessazione = 'CESS'
                         and al between D_fin_ap and D_fin_a
                      UNION
                      select 'Errore 005',dal,al
                           , 'Individui con Periodi sovrapposti'
                           , null
                        from smt_periodi smpe
                       where ci       = CUR_CI.ci
                         and anno = D_anno
                         and gestione = CUR_CI.gestione
                         and exists (select 'x' from smt_periodi
                                      where ci = smpe.ci
                                        and anno = smpe.anno
                                        and gestione = smpe.gestione
                                        and dal <= NVL(smpe.al,TO_DATE(3333333,'j'))
                                        and nvl(al,TO_DATE(3333333,'j')) >= smpe.dal
                                        and rowid != smpe.rowid
                                   )
                      UNION
                      select 'Errore 006',dal,al
                           , 'Individui con Record di rilevanza ''E'''
                           , null
                        from periodi_giuridici pegi
                       where pegi.rilevanza = 'E'
                         and pegi.dal <= nvl(D_a,D_fin_a)
                         and nvl(pegi.al,to_date('3333333','j')) >= nvl(D_da-1,D_fin_ap)
                         and pegi.gestione      like D_gestione
                         and pegi.ci = CUR_CI.ci
                      UNION
                      select 'Errore 009' errore,dal,al
                           , 'Individui con Tempo Pieno NO e part time 100' testo
                           , null det
                        from smt_periodi
                       where ci       = CUR_CI.ci
                         and gestione = CUR_CI.gestione
                         and anno = D_anno
                         and tempo_pieno          = 'NO'
                         and part_time            = 100
                ) LOOP
-- dbms_output.put_line('Cursore Anomalie 2 '||CUR_ANOM2.errore||' '||to_char(D_pagina)||' '||to_char(D_riga));
-- dbms_output.put_line('CI '||to_char(CUR_CI.ci)||' '||to_char(CUR_ANOM2.dal,'ddmmyyyy')||' '||to_char(CUR_ANOM2.al,'ddmmyyyy'));
                    BEGIN
                     d_riga := D_riga + 1;
                     V_testo := lpad(CUR_ANOM2.errore,10)||
                                lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                lpad(nvl(CUR_CI.ci,0),8,0)||
                                lpad(nvl(to_char(CUR_ANOM2.dal,'ddmmyyyy'),' '),8,' ')||
                                lpad(nvl(to_char(CUR_ANOM2.al,'ddmmyyyy'),' '),8,' ')||
                                rpad(CUR_ANOM2.testo,132,' ')||
                                lpad(' ',31)||
                                lpad(CUR_ANOM2.det,10)
                             ;
                       insert into a_appoggio_stampe 
                       (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                        select  prenotazione
                              , 1
                              , D_pagina
                              , D_riga
                              , V_testo
                         from dual
                        where not exists ( select 'x' 
                                             from a_appoggio_stampe
                                            where no_prenotazione = prenotazione
                                              and passo = 1
                                              and testo = V_testo
                                         )
                             ;
                      END;
                    END LOOP; -- CUR_ANOM2
                   END ANOMALIE2;
                END;
                BEGIN
                <<FINALE>>
                  --controllo anomalia su SMT_INDIVIDUI
                     BEGIN
                      select 'x'
                        into D_exist
                        from smt_individui
                       where ci       = CUR_CI.ci
                         and gestione = CUR_CI.gestione
                         and anno     = D_anno
                         and nvl(int_comandato,'NO')||nvl(int_fuori_ruolo,'NO')||nvl(est_comandato,'NO')||nvl(est_fuori_ruolo,'NO') like '%S%S%'
                      ;
                      D_riga := D_riga + 1;
                      V_testo := lpad('Errore 007',10)||
                                 lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                 lpad(nvl(CUR_CI.ci,0),8,0)||
                                 lpad(' ',8,' ')||
                                 lpad(' ',8,' ')||
                                 rpad('Individui con periodi anomali: Interno comandato, Interno fuori ruolo, Esterno comandato ed Esterno fuori ruolo',132)
                                ;
                         insert into a_appoggio_stampe
                         (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                          select   prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , V_testo
                            from dual
                           where not exists ( select 'x' 
                                                from a_appoggio_stampe
                                               where no_prenotazione = prenotazione
                                                 and passo = 1
                                                 and testo = V_testo
                                            )
                             ;
                          EXCEPTION
                            WHEN no_data_found THEN null;
                          END;
                          -- cancello tutti i record di testata che non hanno record di dettaglio
                          BEGIN
                            select 'x'
                              into D_controllo
                              from smt_individui smin
                             where ci = CUR_CI.ci
                               and gestione = CUR_CI.gestione
                               and anno = D_anno
                               and not exists (select 'x'
                                                 from smt_periodi smpe
                                                where smpe.ci = smin.ci
                                                  and smpe.anno = smin.anno
                                                  and smpe.gestione = smin.gestione
                                              )
                               and nvl(est_comandato,'NO') = 'NO'
                            ;
                             raise too_many_rows;
                          EXCEPTION
                            WHEN no_data_found THEN null;
                            WHEN too_many_rows THEN
-- dbms_output.put_line('Cancello la testata');
                              delete
                                from smt_individui smin
                               where ci = CUR_CI.ci
                                 and gestione = CUR_CI.gestione
                                 and anno = D_anno
                                 and not exists (select 'x'
                                                   from smt_periodi smpe
                                                  where smpe.ci = smin.ci
                                                    and smpe.anno = smin.anno
                                                    and smpe.gestione = smin.gestione
                                                )
                                 and nvl(est_comandato,'NO') = 'NO'
                              ;
                          END;
-- Cancellazione periodi esterni all'anno di denuncia
                          BEGIN
                            delete from smt_periodi
                             where ci = CUR_CI.ci
                              and gestione = CUR_CI.gestione
                              and anno = D_anno
                              and dal > D_fin_a
                           ;
                            delete from smt_periodi
                             where ci = CUR_CI.ci
                              and gestione = CUR_CI.gestione
                              and anno = D_anno
                              and al < D_fin_ap
                           ;
                          END;
                  -- controllo differenze su periodo 31/12/AP
                      FOR CUR_DIFF in 
                      ( ( select distinct qualifica, categoria 
                          from smt_periodi
                         where anno = D_anno-1
                           and D_fin_ap between dal and nvl(al,D_ini_a)
                           and ci  = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                         minus
                        select distinct qualifica, categoria
                          from smt_periodi
                         where anno = D_anno
                           and D_fin_ap between dal and nvl(al,D_fin_a)
                           and ci  = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                       )
                      union
                      ( select distinct qualifica, categoria
                          from smt_periodi
                         where anno = D_anno
                           and D_fin_ap between dal and nvl(al,D_fin_a)
                           and ci  = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                         minus
                        select distinct qualifica, categoria 
                          from smt_periodi
                         where anno = D_anno-1
                           and D_fin_ap between dal and nvl(al,D_ini_a)
                           and ci  = CUR_CI.ci
                           and gestione = CUR_CI.gestione
                       )
                      ) LOOP
                      BEGIN
                      D_riga := D_riga + 1;
                      V_testo := lpad('Errore 015',10)||
                                 lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                 lpad(nvl(CUR_CI.ci,0),8,0)||
                                 lpad(' ',8,' ')||
                                 lpad(' ',8,' ')||
                                 rpad('Dipendenti Da Verificare: Confronto Record al 31/12/'||to_char(D_anno-1),132)||
                                 lpad(' ',41,' ')||
                                 lpad(nvl(CUR_DIFF.qualifica,' '),8,' ')||nvl(CUR_DIFF.categoria,' ')
                                ;
                      insert into a_appoggio_stampe
                      (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                          select   prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , V_testo
                            from dual
                           where not exists ( select 'x' 
                                                from a_appoggio_stampe
                                               where no_prenotazione = prenotazione
                                                 and passo = 1
                                                 and testo = V_testo
                                            )
                             ;
                     END;
                     END LOOP; -- CUR_DIFF
                END FINALE;
               BEGIN -- dipendenti con cambio di comparto
               <<ANOMALIE3>>
               FOR CUR_ANOM3 IN
              ( select smpe.ci
                     , smpe.dal
                     , smpe.al
                     , smpe.qualifica
                     , '1' errore                -- senza aperl
                  from smt_periodi smpe
                     , qualifiche_ministeriali qumi
                 where smpe.anno = D_anno
                   and smpe.ci   = CUR_CI.ci
                   and smpe.qualifica = qumi.codice
                   and nvl(D_a,D_fin_a)
                       between qumi.dal and nvl(qumi.al,to_date('3333333','j'))
                   and exists ( select 'x' 
                                  from smt_periodi smpe1
                                     , qualifiche_ministeriali qumi1
                                 where smpe1.ci   = smpe.ci
                                   and smpe1.anno = smpe.anno
                                   and smpe1.dal  = smpe.al+1
                                   and smpe1.qualifica = qumi1.codice
                                   and nvl(qumi1.comparto,'%') != nvl(qumi.comparto,'%')
                                   and nvl(D_a,D_fin_a)
                                       between qumi1.dal and nvl(qumi1.al,to_date('3333333','j'))
                              )
                   and not exists ( select 'x' 
                                      from periodi_giuridici pegi
                                     where pegi.rilevanza = 'P'
                                       and pegi.dal = smpe.al+1
                                       and pegi.ci = smpe.ci
                                  )
                union
                select smpe.ci
                     , smpe.dal
                     , smpe.al
                     , smpe.qualifica
                     , '2' errore                -- con aperl
                  from smt_periodi smpe
                     , qualifiche_ministeriali qumi
                 where smpe.anno = D_anno
                   and smpe.ci   = CUR_CI.ci
                   and smpe.qualifica = qumi.codice
                   and nvl(D_a,D_fin_a)
                       between qumi.dal and nvl(qumi.al,to_date('3333333','j'))
                   and exists ( select 'x' 
                                  from smt_periodi smpe1
                                     , qualifiche_ministeriali qumi1
                                 where smpe1.ci   = smpe.ci
                                   and smpe1.anno = smpe.anno
                                   and smpe1.dal  = smpe.al+1
                                   and smpe1.qualifica = qumi1.codice
                                   and nvl(qumi1.comparto,'%') != nvl(qumi.comparto,'%')
                                   and nvl(D_a,D_fin_a)
                                       between qumi1.dal and nvl(qumi1.al,to_date('3333333','j'))
                              )
                   and exists ( select 'x' 
                                  from periodi_giuridici pegi
                                 where pegi.rilevanza = 'P'
                                   and pegi.dal = smpe.al+1
                                   and pegi.ci = smpe.ci
                              )
               ) LOOP
                 BEGIN
/* attivo sul primo periodo la cessazione con valore di default se nulla                       
   attivo sul secondo periodo l'assunzione con valore di default se nulla 
   e svuoto la qualifica di provenienza */
                  update smt_periodi
                     set cessazione = decode(nvl(cessazione,'XXX'),'XXX','CESS',cessazione)
                   where ci = CUR_CI.ci
                     and gestione = CUR_CI.gestione
                     and dal = CUR_ANOM3.dal
                   ;
                  update smt_periodi
                     set da_qualifica = ''
                       , assunzione = decode(nvl(assunzione,'XXX'),'XXX','ASS',assunzione)
                   where ci = CUR_CI.ci
                     and gestione = CUR_CI.gestione
                     and dal = CUR_ANOM3.al + 1
                   ;
                   IF CUR_ANOM3.errore = '1' THEN
                      BEGIN
                      D_riga := D_riga + 1;
                      V_testo := lpad('Errore 011',10)||
                                 lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                 lpad(nvl(CUR_CI.ci,0),8,0)||
                                 lpad(nvl(to_char(CUR_ANOM3.dal,'ddmmyyyy'),' '),8,' ')||
                                 lpad(nvl(to_char(CUR_ANOM3.al,'ddmmyyyy'),' '),8,' ')||
                                 rpad('Dipendente Da Verificare: passaggio di comparto consecutivo senza APERL',132,' ')||
                                 lpad(' ',41,' ')||
                                 lpad(nvl(CUR_ANOM3.qualifica,' '),8,' ')
                                ;
                      insert into a_appoggio_stampe
                      (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                          select   prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , V_testo
                            from dual
                           where not exists ( select 'x' 
                                                from a_appoggio_stampe
                                               where no_prenotazione = prenotazione
                                                 and passo = 1
                                                 and testo = V_testo
                                            )
                             ;
                       commit;
                      END;
                   ELSIF CUR_ANOM3.errore = '2' THEN
                      BEGIN
                      D_riga := D_riga + 1;
                      V_testo := lpad('Errore 012',10)||
                                 lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                                 lpad(nvl(CUR_CI.ci,0),8,0)||
                                 lpad(nvl(to_char(CUR_ANOM3.dal,'ddmmyyyy'),' '),8,' ')||
                                 lpad(nvl(to_char(CUR_ANOM3.al,'ddmmyyyy'),' '),8,' ')||
                                 rpad('Dipendente Da Verificare: passaggio di comparto consecutivo con APERL',132,' ')||
                                 lpad(' ',41,' ')||
                                 lpad(nvl(CUR_ANOM3.qualifica,' '),8,' ')
                                ;
                      insert into a_appoggio_stampe
                      (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                          select   prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , V_testo
                            from dual
                           where not exists ( select 'x' 
                                                from a_appoggio_stampe
                                               where no_prenotazione = prenotazione
                                                 and passo = 1
                                                 and testo = V_testo
                                            )
                             ;
                       commit;
                      END;
                   END IF;
                 END;
              END LOOP; -- cur_anom3
             END;
         END LOOP; -- CUR_CI
      IF D_elab = 'G' then
       update a_prenotazioni
          set prossimo_passo = 4
        where no_prenotazione = prenotazione;
       commit;
      END IF;
     ELSE
       update a_prenotazioni
          set prossimo_passo = 2
        where no_prenotazione = prenotazione;
       commit;
     END IF; -- D_elab
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
