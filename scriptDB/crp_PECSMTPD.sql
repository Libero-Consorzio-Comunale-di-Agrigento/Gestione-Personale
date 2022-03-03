CREATE OR REPLACE PACKAGE PECSMTPD IS
/******************************************************************************
 NOME:          PECSMTPD
 DESCRIZIONE:   Archiviazione arretrati Post Dimissione per SMT tabelle economiche
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:   Elenco delle segnalazioni e relativo codice - vedi PECCARSM
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  23/05/2007 CB     A20830
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMTPD IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 23/05/2007';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS

BEGIN
DECLARE
  P_anno               number(4);
  P_ini_a              varchar2(8);
  P_fin_a              varchar2(8);
  P_fin_ap             varchar2(8);
  P_gestione           varchar2(4);
  P_data_da            date;
  P_data_a             date;
  I_dal_arr            date;
  I_al_arr             date;
  D_utente             varchar2(8);
  D_ambiente           varchar2(8);
  D_ente               varchar2(4);
  Dep_ci               number(8)   := to_number(null);
  D_conta              number      := 0;
  D_int_com            varchar2(2);
  D_est_com            varchar2(2);
  D_tipo               varchar2(1);
  D_elab               varchar2(1);
  D_ci                 number(8);
  D_riga               number := 0;
  D_pagina             number := 0;
  P_competenza         varchar2(1); -- parametri per Sanita
  P_inizio_mese_liq    number; -- parametri per Sanita
  P_fine_mese_liq      number; -- parametri per Sanita
  D_cod_comparto       varchar2(6);
  V_testo              varchar2(500);   
  V_dal                date := null;

BEGIN
 BEGIN
  BEGIN
    select substr(valore,1,4)  D_gestione
      into P_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
      P_gestione := '%';
  END;
  BEGIN
    SELECT to_number(substr(valore,1,8))
      INTO D_ci
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ci := null;
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
    select to_date(valore,'dd/mm/yyyy') D_data_a
      into P_data_a
      from a_parametri
     where no_prenotazione=prenotazione
       and parametro='P_A'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    P_data_a := null;
  END;
  BEGIN
    select to_date(valore,'dd/mm/yyyy') D_data_da
      into P_data_da
      from a_parametri
     where no_prenotazione=prenotazione
       and parametro='P_DA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    P_data_da := null;
  END;
  BEGIN
    select substr(valore,1,4)  D_anno
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_ANNO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    select to_char(to_date
                  ('0101'||nvl(P_anno,anno),'ddmmyyyy')
                  ,'ddmmyyyy')                               
         , to_char(to_date
                  ('3112'||nvl(P_anno,anno),'ddmmyyyy')
                  ,'ddmmyyyy')                               
         , to_char(to_date
                  ('3112'||(nvl(P_anno,anno)-1),'ddmmyyyy')
                  ,'ddmmyyyy')                               
         , nvl(P_anno,anno)                                  
      into P_ini_a, P_fin_a, P_fin_ap, P_anno
      from riferimento_fine_anno
     where rifa_id = 'RIFA'
    ;
  END;
  BEGIN
    select ente,ambiente,utente
      into D_ente,D_ambiente,D_utente
      from a_prenotazioni
     where no_prenotazione = prenotazione;
  EXCEPTION
    when no_data_found then
      D_ente     := NULL;
      D_utente   := NULL;
      D_ambiente := NULL;
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
    select decode( nvl(P_competenza,'N')
                 , 'X', lpad(substr(valore,1,2),2,0)
                      , 1
                  )
      into P_inizio_mese_liq
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE_DA';
  EXCEPTION WHEN NO_DATA_FOUND THEN 
      P_inizio_mese_liq := 1;
  END;
  BEGIN
    select decode( nvl(P_competenza,'N')
                 , 'X', lpad(substr(valore,1,2),2,0)
                      , 12
                  )
      into P_fine_mese_liq
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE_A';
  EXCEPTION WHEN NO_DATA_FOUND THEN 
      P_fine_mese_liq   := 12;
  END;
 END; -- parametri di elaborazione
  BEGIN
    select max(nvl(pagina,0))+1
      into D_pagina
      from a_appoggio_stampe
     where no_prenotazione = prenotazione
       and passo = 4
    ;
  EXCEPTION WHEN OTHERS THEN
    D_pagina := 0;
  END;
 BEGIN 
   IF D_ELAB IN ('E','T') THEN
    BEGIN       
     FOR ARR IN
       ( select pegi.gestione                gestione
              , pegi.ci                      ci
              , pegi.dal                     dal
              , pegi.al                      al
              , clra.retributivo             retributivo
              , pegi.figura                  figura
              , pegi.qualifica               qualifica
              , pegi.posizione               posizione
              , pegi.tipo_rapporto           tipo_rapporto
              , anag.sesso                   sesso
           from periodi_giuridici            pegi
              , classi_rapporto              clra
              , rapporti_individuali         rain
              , anagrafici                   anag
          where pegi.rilevanza = 'S'
            and clra.giuridico = 'SI'
            and clra.presenza  = 'SI'
            and rain.rapporto  = clra.codice
            and pegi.ci        = rain.ci
            and rain.ni        = anag.ni
            and nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy'))
                between anag.dal and nvl(anag.al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
            and rain.dal      <= nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy'))
            and nvl(pegi.al,to_date('3333333','j'))
                                <= nvl(P_data_da-1,to_date(P_fin_ap,'ddmmyyyy'))
            and pegi.gestione        in
               (select codice
                  from gestioni
                 where codice like nvl(P_gestione,'%')
                   and gestito = 'SI')
            and not exists
               (select 'x'
                  from periodi_giuridici
                 where rilevanza = 'S'
                   and ci = pegi.ci
                   and dal <= nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy'))
                   and nvl(al,to_date('3333333','j')) >=
                       nvl(P_data_da-1,to_date(P_fin_ap,'ddmmyyyy'))
                      )
            and exists
              ( select 'x' 
                  from valori_contabili_mensili vacm
                 where vacm.anno = P_anno
                   and ci   = pegi.ci
                   and mensilita != '*AP'
                   and estrazione in ('SMT_TAB8A' , 'SMT_TAB8B', 'SMT_TAB13S' )
                   and riferimento between pegi.dal
                                       and nvl(pegi.al,to_date('3333333','j'))
                union
                select 'x' 
                  from valori_contabili_mensili vacm
                 where anno = P_anno + 1
                   and ci   = pegi.ci
                   and mese <= P_fine_mese_liq
                   and mensilita != '*AP'
                   and estrazione in ('SMT_TAB8A' , 'SMT_TAB8B', 'SMT_TAB13S' )                   
                   and nvl(P_competenza,'N') = 'X'
                   and riferimento between pegi.dal
                                       and nvl(pegi.al,to_date('3333333','j'))
               )
            AND ( D_tipo = 'T'
             or ( D_tipo in ('I','V','P')
            and ( not exists (select 'x' from smt_individui
                             where anno     = P_anno
                               and ci       = pegi.ci
                               and gestione = pegi.gestione
                               and nvl(tipo_agg,' ') = decode(D_tipo
                                                             ,'P',tipo_agg
                                                             ,D_tipo)
                              union
                               select 'x' from smt_periodi
                             where anno = P_anno
                               and ci   = pegi.ci
                               and gestione = pegi.gestione
                               and nvl(tipo_agg,' ') = decode(D_tipo
                                                             ,'P',tipo_agg
                                                             ,D_tipo)
                              union
                              select 'x' from smt_importi
                             where anno = P_anno
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
          order by 2
     ) LOOP
         D_cod_comparto  := null;
         BEGIN
           select nvl(qumi.comparto,lpad('9',6,'9'))
             into D_cod_comparto
             from righe_qualifica_ministeriale rqmi
                , qualifiche_ministeriali qumi
                , posizioni posi
           where to_date(P_fin_a,'ddmmyyyy') between rqmi.dal and nvl(rqmi.al,to_date('3333333','j'))
                                                 and nvl(rqmi.posizione,ARR.posizione) = ARR.posizione
            and (   (    rqmi.qualifica is null
                     and rqmi.figura     = ARR.figura)
                 or (    rqmi.figura    is null
                     and rqmi.qualifica  = ARR.qualifica)
                 or (    rqmi.qualifica is not null
                     and rqmi.figura    is not null
                     and rqmi.qualifica  = ARR.qualifica
                     and rqmi.figura     = ARR.figura)
                )
            and posi.codice = ARR.posizione
            and nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
            and nvl(rqmi.tempo_determinato,posi.tempo_determinato)
                                                   = posi.tempo_determinato
            and nvl(rqmi.formazione_lavoro,posi.contratto_formazione) 
                                                   = posi.contratto_formazione
            and nvl(rqmi.part_time,posi.part_time) = posi.part_time
            and nvl(rqmi.tipo_rapporto,nvl(ARR.tipo_rapporto,'NULL'))=
                nvl(ARR.tipo_rapporto,'NULL')
            and qumi.codice = rqmi.codice
            and qumi.dal = rqmi.dal
          ;
         EXCEPTION 
              WHEN NO_DATA_FOUND THEN D_cod_comparto := null;
              WHEN TOO_MANY_ROWS THEN 
                       BEGIN
                       IF D_pagina is null THEN D_pagina := 1;
                       END IF;
                       D_riga           := nvl(D_riga,0) + 1 ;
                       V_testo := lpad('Errore 026',10)||
                                lpad(nvl(ARR.gestione,' '),4,' ')||
                                lpad(nvl(ARR.ci,0),8,0)||
                                lpad(nvl(to_char(ARR.dal,'ddmmyyyy'),' '),8,' ')||
                                lpad(nvl(to_char(ARR.al,'ddmmyyyy'),' '),8,' ')||
                                rpad('Verificare Dipendente: Impossibile Archiviare periodo per Importi Arretrati',132,' ')
                               ;
                       insert into a_appoggio_stampe
                       (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                       select  prenotazione
                              , 4
                              , D_pagina
                              , D_riga
                              , V_testo
                         from dual
                        where not exists ( select 'x' 
                                             from a_appoggio_stampe
                                             where no_prenotazione = prenotazione
                                               and passo = 4
                                               and testo = V_testo
                                        )
                     ;
                     END;
         END;
         IF D_cod_comparto is not null THEN 
            IF ARR.ci = nvl(Dep_ci,0) THEN 
-- dbms_output.put_line('altro record: '||ARR.ci||' dep:'||Dep_ci);
              D_conta := D_conta + 1;
            ELSE Dep_ci := ARR.ci;
                 D_conta := 1;
-- dbms_output.put_line('primo record: '||ARR.ci||' dep:'||Dep_ci||' '||D_conta);
            END IF;
            IF D_conta = 1 THEN
-- dbms_output.put_line('CI ARRETRATO: '||ARR.ci||' '||ARR.dal||' '||ARR.al||' gest: '||ARR.gestione);
            --cancello registrazioni precedenti
            delete from smt_importi
             where ci       = ARR.ci
               and anno     = P_anno
               and gestione = ARR.gestione
             ;
            delete from smt_periodi
             where ci       = ARR.ci
               and anno     = P_anno
               and gestione = ARR.gestione
               and categoria = lpad('9',10,'9')
             ;
            commit;
            BEGIN -- determino i dal / al del periodi arretrato
            <<PERIODO_ARRETRATO>>
            select min(pegi.dal)
                 , max(pegi.al)
              into I_dal_arr
                 , I_al_arr
              from periodi_giuridici pegi
                 , righe_qualifica_ministeriale rqmi
                 , posizioni                    posi
             where pegi.rilevanza = 'S'
               and pegi.ci        = ARR.ci
               and pegi.gestione  = ARR.gestione
               and nvl(rqmi.posizione,pegi.posizione)=pegi.posizione
               and nvl(pegi.al,to_date('3333333','j'))
                                   <= nvl(P_data_da,to_date(P_ini_a,'ddmmyyyy'))
               and not exists (select 'x'
                                 from periodi_giuridici
                                where rilevanza = 'S'
                                  and ci = pegi.ci
                                  and dal <= nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy'))
                                  and nvl(al,to_date('3333333','j')) >=
                                      nvl(P_data_da,to_date(P_ini_a,'ddmmyyyy'))
                              )
               and posi.codice    = pegi.posizione
               and nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')) between rqmi.dal and nvl(rqmi.al,to_date('3333333','j'))
               and (   (    rqmi.qualifica is null
                        and rqmi.figura     = pegi.figura)
                    or (    rqmi.figura    is null
                        and rqmi.qualifica  = pegi.qualifica)
                    or (    rqmi.qualifica is not null
                        and rqmi.figura    is not null
                        and rqmi.qualifica  = pegi.qualifica
                        and rqmi.figura     = pegi.figura)
                   )
               and nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
               and nvl(rqmi.tempo_determinato,posi.tempo_determinato)
                                                      = posi.tempo_determinato
               and nvl(rqmi.formazione_lavoro,posi.contratto_formazione) 
                                                      = posi.contratto_formazione
               and nvl(rqmi.part_time,posi.part_time) = posi.part_time
               and nvl(rqmi.tipo_rapporto,nvl(pegi.tipo_rapporto,'NULL'))=
                       nvl(pegi.tipo_rapporto,'NULL')
            ; 
            END PERIODO_ARRETRATO;
            IF I_dal_arr is null THEN I_dal_arr := ARR.dal;
            END IF;
            IF I_al_arr is null THEN I_al_arr := ARR.al;
            END IF;
-- dbms_output.put_line('CI ARRETRATO: '||ARR.ci||' '||I_dal_arr||' '||I_al_arr||' Conta: '||D_conta);
            BEGIN
             --Determino se interno comandato
             D_int_com := PECSMTFC.INT_COM(ARR.ci,ARR.gestione,P_data_a,to_date(P_fin_a,'ddmmyyyy'),ARR.retributivo);
             --Determino se esterno comandato
             D_est_com := PECSMTFC.EST_COM(ARR.ci,ARR.gestione,P_data_a,to_date(P_fin_a,'ddmmyyyy'),ARR.retributivo);
-- dbms_output.put_line('Inserimento su smt_individui dip. con arretrati: '||ARR.ci);
               insert into SMT_INDIVIDUI
               (ANNO,CI,GESTIONE,SESSO,INT_COMANDATO,EST_COMANDATO,UTENTE,TIPO_AGG,DATA_AGG)
                select P_anno
                     , ARR.ci
                     , ARR.gestione
                     , ARR.sesso
                     , D_int_com
                     , D_est_com
                     , D_utente
                     , null
                     , sysdate
                  from dual
                 where not exists (select 'x' 
                                     from smt_individui
                                    where anno = P_anno
                                      and gestione = ARR.gestione
                                      and ci = ARR.ci 
                                  )
                    ;
              commit;
-- dbms_output.put_line('Inserimento su smt_periodi dip. con arretrati: '||ARR.ci||I_dal_arr);
              insert into smt_periodi
              (ANNO,CI,GESTIONE,DAL,AL, QUALIFICA, CATEGORIA
              ,UTENTE,TIPO_AGG,DATA_AGG
              )
              select P_anno
                   , ARR.ci
                   , ARR.gestione
                   , I_dal_arr
                   , I_al_arr
                   , D_cod_comparto
                   , lpad('9',10,'9') -- '9999999999'
                   , D_utente
                   , null
                   , sysdate
                from dual
               where not exists (select 'x' 
                                   from smt_periodi
                                  where anno = P_anno
                                    and ci = ARR.ci
                                    and gestione = ARR.gestione
                                    and dal = I_dal_arr
                                )
             ;
            commit;
            END; 
-- dbms_output.put_line('Fine Inserimento su dip. con arretrati');
          END IF; -- fine trattamento 1^ rec. per il CI
            BEGIN
            <<VACM>>
             FOR VACM_ARR_T12 IN
             ( select vacm.colonna                colonna
                     ,sum(nvl(vacm.valore,0))     importo
                from valori_contabili_mensili     vacm
               where vacm.anno between P_anno and P_anno+1 
                 and vacm.mensilita  != '*AP' 
                 and vacm.estrazione  = 'SMT_TAB8A'
                 and vacm.colonna in ('STIPENDI','IIS','RIA','13A','INDENNITA','RECUPERI')
                 and vacm.ci          = ARR.ci
                 and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                               and nvl(to_number(to_char(p_data_a,'mm')),12)
                 and ( nvl(P_competenza,'N') = 'N'
                       and vacm.anno              = P_anno
                       and vacm.riferimento  between ARR.dal
                            and nvl(ARR.al,to_date('3333333','j'))
                       or nvl(P_competenza,'N')= 'X'
                        and vacm.anno             = P_anno
                        and to_char(vacm.riferimento,'yyyy') = P_anno
                        and vacm.riferimento  between ARR.dal
                            and nvl(ARR.al,to_date('3333333','j'))
                      )
               group by vacm.ci
                      , vacm.colonna
              having nvl(sum(valore),0) != 0
              UNION
              select vacm.colonna                colonna
                   , sum(nvl(vacm.valore,0))     importo
                from valori_contabili_mensili     vacm
               where vacm.anno between P_anno and P_anno+1 
                and vacm.mensilita  != '*AP' 
                 and vacm.estrazione  = 'SMT_TAB8A'
                 and vacm.colonna     = 'ARRETRATI'
                 and vacm.ci          = ARR.ci
                 and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                               and nvl(to_number(to_char(p_data_a,'mm')),12)
                 and ( nvl(P_competenza,'N') = 'N'
                       and vacm.anno              = P_anno
                       and vacm.riferimento between ARR.dal
                            and nvl(ARR.al,to_date('3333333','j'))
                          or nvl(P_competenza,'N') = 'X'
                         and vacm.anno             = P_anno+1
                         and to_char(vacm.riferimento,'yyyy') = P_anno
                         and vacm.mese             <= P_fine_mese_liq
                         and vacm.riferimento  between ARR.dal
                            and nvl(ARR.al,to_date('3333333','j'))
                      )
               group by vacm.ci
                      , vacm.colonna
              having nvl(sum(valore),0) != 0
              UNION
              select vacm.colonna                colonna
                     ,sum(nvl(vacm.valore,0))     importo
                from valori_contabili_mensili     vacm
               where vacm.anno between P_anno and P_anno+1 
                and vacm.mensilita  != '*AP' 
                 and vacm.estrazione  = 'SMT_TAB8A'
                 and vacm.colonna     = 'ARRETRATI_AP'
                 and vacm.ci          = ARR.ci
                 and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                               and nvl(to_number(to_char(p_data_a,'mm')),12)
                 and ( nvl(P_competenza,'N') = 'N'
                       and vacm.anno              = P_anno
                       and vacm.riferimento between ARR.dal
                            and nvl(ARR.al,to_date('3333333','j'))
                       or ( nvl(P_competenza,'N')= 'X'
                        and vacm.anno             = P_anno
                        and vacm.riferimento between ARR.dal
                            and nvl(ARR.al,to_date('3333333','j'))
                        and to_char(vacm.riferimento,'yyyy') < P_anno
                        and vacm.mese             >= P_inizio_mese_liq
                          or nvl(P_competenza,'N') = 'X'
                         and vacm.anno             = P_anno+1
                         and to_char(vacm.riferimento,'yyyy') < P_anno
                         and vacm.mese             <= P_fine_mese_liq
                       and vacm.riferimento  between ARR.dal
                            and nvl(ARR.al,to_date('3333333','j'))
                          )
                      )
               group by vacm.ci
                      , vacm.colonna
              having nvl(sum(valore),0) != 0
              ) LOOP
              BEGIN 
-- dbms_output.put_line('Inserimento su smt_importi dip. con arretrati: '||ARR.ci);
-- dbms_output.put_line('colonna / importo : '||vacm_arr.colonna||' '||vacm_arr.importo);
               update smt_importi
                  set importo = nvl(importo,0) + nvl(VACM_ARR_T12.importo,0)
                where anno     = P_anno
                  and ci       = ARR.ci
                  and gestione = ARR.gestione
                  and tabella  = 'T12'
                  and dal      = I_dal_arr
                  and colonna = VACM_ARR_T12.colonna
                  and exists (select 'x' 
                                from smt_importi
                               where ci       = ARR.CI
                                 and anno     = P_anno
                                 and gestione = ARR.gestione
                                 and tabella  = 'T12'
                                 and dal      = I_dal_arr
                                 and colonna  = VACM_ARR_T12.colonna
                                 ); 
               commit;
-- dbms_output.put_line('Inserimento periodo arretrato : '||ARR.ci||' '|| I_dal_arr);
               insert into smt_importi
              (ANNO,CI,GESTIONE,DAL,TABELLA
              ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
              )
              select P_anno
                   , ARR.ci
                   , ARR.gestione
                   , I_dal_arr
                   , 'T12'
                   , VACM_ARR_T12.colonna
                   , VACM_ARR_T12.importo
                   , D_utente
                   , null
                   , sysdate
                from dual
                where not exists (select 'x' 
                                    from smt_importi
                                   where ci       = ARR.CI
                                     and anno     = P_anno
                                     and gestione = ARR.gestione
                                     and tabella  = 'T12'
                                     and dal      = I_dal_arr
                                     and colonna  = VACM_ARR_T12.colonna
                                 ); 
                commit;
                END;
             END LOOP; -- VACM_ARR_T12

             FOR VACM_ARR_T13 IN 
             (  select vacm.colonna colonna,
                       sum(nvl(vacm.valore,0)) importo
                  from rapporti_giuridici           ragi
                     , valori_contabili_mensili     vacm
                 where vacm.anno between P_anno and P_anno+1 
                   and vacm.mese             between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                 and nvl(to_number(to_char(p_data_a,'mm')),12)
                   and vacm.mensilita        != '*AP'
                   and ( ( D_cod_comparto = 'ELS' 
                        and vacm.estrazione       = 'SMT_TAB13S' 
                          )
                        or ( D_cod_comparto != 'ELS' 
                        and vacm.estrazione       = 'SMT_TAB8B' 
                           )
                      )
                   and vacm.colonna          in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '11', '12','13')
                   and vacm.ci               = ARR.ci
                   and vacm.ci               = ragi.ci
                   and ( nvl(P_competenza,'N') = 'N'
                         and vacm.anno              = P_anno
                         and vacm.riferimento between ARR.dal and nvl(ARR.al,to_date('3333333','j'))
                         or ( nvl(P_competenza,'N')= 'X'
                          and vacm.anno             = P_anno
                          and to_char(vacm.riferimento,'yyyy') = P_anno
                          and vacm.riferimento between ARR.dal and nvl(ARR.al,to_date('3333333','j'))
                            or nvl(P_competenza,'N')= 'X'
                           and vacm.anno             = P_anno+1
                           and to_char(vacm.riferimento,'yyyy') = P_anno
                           and vacm.mese             <= P_fine_mese_liq
                           and vacm.riferimento between ARR.dal and nvl(ARR.al,to_date('3333333','j'))
                            )
                        )
                group by vacm.ci
                       , vacm.colonna
                having nvl(sum(valore),0) != 0
                UNION
                select vacm.colonna colonna,
                       sum(nvl(vacm.valore,0)) importo
                  from rapporti_giuridici           ragi
                     , valori_contabili_mensili     vacm
                 where vacm.anno between P_anno and P_anno+1 
                   and vacm.mese             between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                 and nvl(to_number(to_char(p_data_a,'mm')),12)
                   and vacm.mensilita        != '*AP'
                   and ( ( D_cod_comparto = 'ELS' 
                        and vacm.estrazione       = 'SMT_TAB13S' 
                          )
                        or ( D_cod_comparto != 'ELS' 
                        and vacm.estrazione       = 'SMT_TAB8B' 
                           )
                      )
                   and vacm.colonna          = '10'
                   and vacm.ci               = ARR.ci
                   and vacm.ci               = ragi.ci
                   and (   nvl(P_competenza,'N') = 'N'
                       and vacm.anno              = P_anno
                       and vacm.riferimento between ARR.dal and nvl(ARR.al,to_date('3333333','j'))
                       or ( nvl(P_competenza,'N')= 'X'
                        and vacm.anno             = P_anno
                        and to_char(vacm.riferimento,'yyyy') < P_anno
                        and vacm.mese            >= P_inizio_mese_liq
                        and vacm.riferimento
                            between ARR.dal and nvl(ARR.al,to_date('3333333','j'))
                          or nvl(P_competenza,'N')= 'X'
                         and vacm.anno             = P_anno+1
                         and to_char(vacm.riferimento,'yyyy') < P_anno
                         and vacm.mese            <= P_fine_mese_liq
                         and vacm.riferimento between ARR.dal and nvl(ARR.al,to_date('3333333','j'))
                          )
                      )
                 group by vacm.ci
                      , vacm.colonna
                 having nvl(sum(valore),0) != 0
                ) LOOP
-- dbms_output.put_line('ARR: '||VACM_ARR_T13.colonna||' '||VACM_ARR_T13.importo);
                 BEGIN
                 update smt_importi
                    set importo = nvl(importo,0) + nvl(VACM_ARR_T13.importo,0)
                  where anno     = P_anno
                    and ci       = ARR.ci
                    and gestione = ARR.gestione
                    and tabella  = decode( D_cod_comparto, 'ELS', 'T13S', 'T13' )
                    and dal      = I_dal_arr
                    and colonna = VACM_ARR_T13.colonna
                    and exists (select 'x' 
                                  from smt_importi
                                 where ci       = ARR.CI
                                   and anno     = P_anno
                                   and gestione = ARR.gestione
                                   and tabella  = decode( D_cod_comparto, 'ELS', 'T13S', 'T13' )
                                   and dal      = I_dal_arr
                                   and colonna  = VACM_ARR_T13.colonna
                                   ); 
                 commit;
                 insert into smt_importi
                    (ANNO,CI,GESTIONE,DAL,TABELLA
                    ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                    )
                    select P_anno
                         , ARR.ci
                         , ARR.gestione
                         , I_dal_arr
                         , decode( D_cod_comparto, 'ELS', 'T13S', 'T13' )
                         , VACM_ARR_T13.colonna
                         , VACM_ARR_T13.importo
                         , D_utente
                         , null
                         , sysdate
                      from dual
                    where not exists (select 'x' 
                                        from smt_importi
                                       where ci       = ARR.CI
                                         and anno     = P_anno
                                         and gestione = ARR.gestione
                                         and tabella  = decode( D_cod_comparto, 'ELS', 'T13S', 'T13' )
                                         and dal      = I_dal_arr
                                         and colonna  = VACM_ARR_T13.colonna
                                     ); 
                 commit;
                 END;
              END LOOP;  -- VACM_ARR_T13
            END VACM;
          BEGIN
          <<CONTROLLI_T12>>
            FOR CUR_CONTROLLI_T12 IN
             (  select ci, dal, al, gestione
                  from smt_periodi  stpe
                 where ci        = ARR.ci
                   and anno      = P_anno
                   and gestione  = ARR.gestione
                   and exists ( select 'x'
                                  from smt_importi
                                 where ci             = stpe.ci
                                   and anno           = stpe.anno
                                   and tabella        = 'T12'
                                   and colonna       != 'GG'
                                   and gestione       = stpe.gestione
                                 group by ci, anno, gestione
                                having sum(nvl(importo,0)) = 0
                              )
                   and ( D_tipo in ('T','V','I','P')
                         or ( D_tipo = 'S' and stpe.ci = D_ci)
                       )
             ) LOOP
-- dbms_output.put_line('Cur_controlli_arr: '||CUR_CONTROLLI.ci);
               BEGIN
               IF D_pagina is null THEN D_pagina := 1;
               END IF;
               D_riga   := nvl(D_riga,0) + 1;
               V_testo := lpad('Errore 020',10)||
                          lpad(nvl(CUR_CONTROLLI_T12.gestione,' '),4,' ')||
                          lpad(nvl(CUR_CONTROLLI_T12.ci,0),8,0)||
                          lpad(nvl(to_char(CUR_CONTROLLI_T12.dal,'ddmmyyyy'),' '),8,' ')||
                          lpad(nvl(to_char(CUR_CONTROLLI_T12.al,'ddmmyyyy'),' '),8,' ')||
                          rpad('Verificare Correttezza Dipendente: Esistono Record con Importo Nullo in T12 ( Arr. PD )',132,' ')
                       ;
               insert into a_appoggio_stampe
               (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
               select   prenotazione
                      , 4
                      , D_pagina
                      , D_riga
                      , V_testo
                 from dual
                 where not exists ( select 'x' 
                                      from a_appoggio_stampe
                                     where no_prenotazione = prenotazione
                                       and passo = 4
                                       and testo = V_testo
                                 );
               END;
            END LOOP; -- cur_controlli_t12
          END CONTROLLI_T12;
          BEGIN
          <<CONTROLLI_T13>>
           FOR CUR_CONTROLLI_T13 IN
            ( select ci, dal, al, gestione
                from smt_periodi  stpe
               where ci        = ARR.ci
                 and anno      = P_anno
                 and gestione  = ARR.gestione
                 and exists ( select 'x'
                                from smt_importi
                               where ci             = stpe.ci
                                 and anno           = stpe.anno
                                 and tabella        in ('T13', 'T13S')
                                 and gestione       = stpe.gestione
                               group by ci, anno, gestione
                              having sum(nvl(importo,0)) = 0
                            )
                 and ( D_tipo in ('T','V','I','P')
                  or ( D_tipo = 'S' and stpe.ci = D_ci)
                     )
           ) LOOP
-- dbms_output.put_line('Cur_controlli_arr: '||CUR_CONTROLLI.ci);
-- dbms_output.put_line(' RG5: '||D_riga );
             BEGIN
             IF D_pagina is null THEN D_pagina := 1;
             END IF;
             D_riga   := D_riga + 1;
            V_testo := lpad('Errore 021',10)||
                      lpad(nvl(CUR_CONTROLLI_T13.gestione,' '),4,' ')||
                      lpad(nvl(CUR_CONTROLLI_T13.ci,0),8,0)||
                      lpad(nvl(to_char(CUR_CONTROLLI_T13.dal,'ddmmyyyy'),' '),8,' ')||
                      lpad(nvl(to_char(CUR_CONTROLLI_T13.al,'ddmmyyyy'),' '),8,' ')||
                      rpad('Verificare Correttezza Dipendente: Esistono Record con Importo Nullo in T13 o T13S ( Arr. PD )',132,' ')
                    ;
-- dbms_output.put_line(' RG6: '||D_riga );
             insert into a_appoggio_stampe
             (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
             select  prenotazione
                    , 4
                    , D_pagina
                    , D_riga
                    , V_testo
               from dual
              where not exists ( select 'x' 
                                   from a_appoggio_stampe
                                  where no_prenotazione = prenotazione
                                    and passo = 4
                                    and testo = V_testo
                               );
             END;
           END LOOP; -- cur_controlli
          END CONTROLLI_T13;
         END IF; -- D_cod_comparto
     END LOOP; -- ARR
    END;
    BEGIN
    <<ESTERNI>>
    FOR CUR_CI_PD in
     (  select distinct ci
         from smt_periodi smpe
        where smpe.anno   = P_anno
          and categoria   = lpad('9',10,'9')
          AND ( D_tipo = 'T'
             or ( D_tipo in ('I','V','P')
                  and ( not exists (select 'x' from smt_individui
                                   where anno     = P_anno
                                     and ci       = smpe.ci
                                     and nvl(tipo_agg,' ') = decode(D_tipo
                                                                   ,'P',tipo_agg
                                                                   ,D_tipo)
                                    union
                                     select 'x' from smt_periodi
                                   where anno = P_anno
                                     and ci   = smpe.ci
                                     and nvl(tipo_agg,' ') = decode(D_tipo
                                                                   ,'P',tipo_agg
                                                                   ,D_tipo)
                                    union
                                    select 'x' from smt_importi
                                   where anno = P_anno
                                     and ci   = smpe.ci
                                     and nvl(tipo_agg,' ') = decode(D_tipo
                                                                   ,'P',tipo_agg
                                                                   ,D_tipo)
                                 )
                      )
                )
             or ( D_tipo  = 'S'
                  and smpe.ci = D_ci )
            )
    ) LOOP
       BEGIN
         FOR CUR_ESTERNI_T12 in 
           (select distinct ci
              from smt_periodi smpe
             where smpe.anno            = P_anno
               and smpe.ci              = CUR_CI_PD.ci
               and exists (select 'x' 
                             from valori_contabili_mensili vacm
                            where ( nvl(P_competenza,'N') = 'N'
                               and vacm.anno              = P_anno
                               and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                  and nvl(to_number(to_char(p_data_a,'mm')),12)
                               or ( nvl(P_competenza,'N') = 'X'
                                and vacm.anno             = P_anno
                                and to_char(vacm.riferimento,'yyyy') = P_anno
                                  )
                              )
                              and vacm.mensilita        !=  '*AP'
                              and vacm.estrazione       = 'SMT_TAB8A'
                              and vacm.colonna in ('STIPENDI','IIS','RIA','13A','INDENNITA','RECUPERI')
                              and vacm.ci                = smpe.ci
                              and vacm.anno              = P_anno
                              and vacm.mensilita    != '*AP'
                              and not exists (select 'x' from smt_periodi smpe1
                                               where ci        = vacm.ci
                                                 and smpe1.anno            = P_anno
                                                 and vacm.anno             = P_anno
                                                 and ( nvl(P_competenza,'N') = 'N'
                                                 and vacm.anno              = P_anno
                                                 and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                    and nvl(to_number(to_char(p_data_a,'mm')),12)
                                                 and vacm.riferimento between dal 
                                                      and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                 or (  nvl(P_competenza,'N') = 'X'
                                                   and vacm.anno             = P_anno
                                                   and to_char(vacm.riferimento,'yyyy') = P_anno
                                                    and vacm.riferimento between dal 
                                                       and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                    )
                                                   )
                                              ) 
                          UNION 
                          select 'x' 
                             from valori_contabili_mensili vacm
                            where ( nvl(P_competenza,'N') = 'N'
                               and vacm.anno              = P_anno
                               and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                  and nvl(to_number(to_char(p_data_a,'mm')),12)
                               or ( nvl(P_competenza,'N') = 'X'
                                 and vacm.anno             = P_anno+1
                                 and to_char(vacm.riferimento,'yyyy') = P_anno
                                 and vacm.mese            <= P_fine_mese_liq
                                  )
                              )
                              and vacm.mensilita        !=  '*AP'
                              and vacm.estrazione       = 'SMT_TAB8A'
                              and vacm.colonna          = 'ARRETRATI'
                              and vacm.ci                = smpe.ci
                              and vacm.anno between P_anno and P_anno+1 
                              and vacm.mensilita    != '*AP'
                              and not exists (select 'x' from smt_periodi smpe1
                                               where ci        = vacm.ci
                                                 and smpe1.anno = P_anno
                                                 and vacm.anno between P_anno and P_anno+1 
                                                 and ( nvl(P_competenza,'N') = 'N'
                                                 and vacm.anno              = P_anno
                                                 and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                    and nvl(to_number(to_char(p_data_a,'mm')),12)
                                                 and vacm.riferimento between dal 
                                                      and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                 or (  nvl(P_competenza,'N') = 'X'
                                                   and vacm.anno             = P_anno+1
                                                   and to_char(vacm.riferimento,'yyyy') = P_anno
                                                   and vacm.mese            <= P_fine_mese_liq
                                                   and vacm.riferimento between dal 
                                                      and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                    )
                                                   )
                                              ) 
                          UNION 
      /* gestione degli arretrati ap */
                          select 'x' 
                             from valori_contabili_mensili vacm
                            where ( nvl(P_competenza,'N') = 'N'
                               and vacm.anno              = P_anno
                               and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                  and nvl(to_number(to_char(p_data_a,'mm')),12)
                               or ( nvl(P_competenza,'N') = 'X'
                                and vacm.anno             = P_anno
                                and to_char(vacm.riferimento,'yyyy') < P_anno
                                and vacm.mese            >= P_inizio_mese_liq
                                  or nvl(P_competenza,'N')= 'X'
                                 and vacm.anno             = P_anno+1
                                 and to_char(vacm.riferimento,'yyyy') < P_anno
                                 and vacm.mese             <= P_fine_mese_liq
                                  )
                              )
                              and vacm.mensilita        !=  '*AP'
                              and vacm.estrazione       = 'SMT_TAB8A'
                              and vacm.colonna          = 'ARRETRATI_AP'
                              and vacm.ci                = smpe.ci
                              and vacm.anno between P_anno and P_anno+1 
                              and vacm.mensilita    != '*AP'
                              and not exists ( select 'x' from smt_periodi smpe1
                                                where ci        = vacm.ci
                                                 and smpe1.anno = P_anno
                                                 and vacm.anno between P_anno and P_anno+1 
                                                 and ( nvl(P_competenza,'N') = 'N'
                                                 and vacm.anno              = P_anno
                                                 and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                    and nvl(to_number(to_char(p_data_a,'mm')),12)
                                                 and vacm.riferimento between dal 
                                                      and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                 or (  nvl(P_competenza,'N') = 'X'
                                                   and vacm.anno             = P_anno
                                                   and to_char(vacm.riferimento,'yyyy') < P_anno
                                                    and vacm.riferimento between dal 
                                                       and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                   and vacm.mese            >= P_inizio_mese_liq
                                                    or nvl(P_competenza,'N') = 'X'
                                                   and vacm.anno             = P_anno+1
                                                   and to_char(vacm.riferimento,'yyyy') < P_anno
                                                   and vacm.mese            <= P_fine_mese_liq
                                                   and vacm.riferimento between dal 
                                                       and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                    )
                                                   )
                                              ) 
                           )
          ) LOOP
      -- dbms_output.put_line('CUR ESTERNI: '||CUR_ESTERNI_T12.ci);
          BEGIN
            FOR CUR_VACM_EST_T12 IN (
            select vacm.colonna colonna, vacm.riferimento
                 , nvl(sum(nvl(vacm.valore,0)),0) importo                
              from valori_contabili_mensili    vacm
             where vacm.ci                = CUR_ESTERNI_T12.ci
  /* aggiunto per i tempi di elaborazione */
               and vacm.anno between P_anno and P_anno+1 
               and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                 and nvl(to_number(to_char(p_data_a,'mm')),12)
               and ( nvl(P_competenza,'N') = 'N'
                 and vacm.anno              = P_anno
                or ( nvl(P_competenza,'N') = 'X'
                 and vacm.anno             = P_anno
                 and to_char(vacm.riferimento,'yyyy') = P_anno
                    )
                   )
               and vacm.mensilita        != '*AP'
               and vacm.estrazione        = 'SMT_TAB8A'
               and vacm.colonna     in ('STIPENDI','IIS','RIA','13A','INDENNITA','RECUPERI')
               and not exists (select 'x' from smt_periodi
                                where ci        = CUR_ESTERNI_T12.ci
                                  and anno      = P_anno
                                  and ( nvl(P_competenza,'N') = 'N'
                                    and vacm.anno              = P_anno
  /* aggiunto per i tempi di elaborazione */
                                    and vacm.anno between P_anno and P_anno+1 
                                    and vacm.riferimento between dal
                                         and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                     or ( nvl(P_competenza,'N') = 'X'
                                      and vacm.anno             = P_anno
                                      and to_char(vacm.riferimento,'yyyy') = P_anno
                                      and vacm.riferimento between dal 
                                           and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                          )
                                        )
                                  )
               group by vacm.colonna, vacm.riferimento
            UNION
            select vacm.colonna colonna, vacm.riferimento
                 , nvl(sum(nvl(vacm.valore,0)),0) importo                
              from valori_contabili_mensili    vacm
             where vacm.ci                = CUR_ESTERNI_T12.ci
  /* aggiunto per i tempi di elaborazione */
               and vacm.anno between P_anno and P_anno+1 
               and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                 and nvl(to_number(to_char(p_data_a,'mm')),12)
               and ( nvl(P_competenza,'N') = 'N'
                 and vacm.anno              = P_anno
                or ( nvl(P_competenza,'N') = 'X'
                 and vacm.anno             = P_anno+1
                 and to_char(vacm.riferimento,'yyyy') = P_anno
                 and vacm.mese             <= P_fine_mese_liq
                    )
                   )
               and vacm.mensilita        != '*AP'
               and vacm.estrazione        = 'SMT_TAB8A'
               and vacm.colonna           = 'ARRETRATI'
               and not exists (select 'x' from smt_periodi
                                where ci        = CUR_ESTERNI_T12.ci
                                  and anno      = P_anno
                                  and ( nvl(P_competenza,'N') = 'N'
                                    and vacm.anno              = P_anno
  /* aggiunto per i tempi di elaborazione */
                                    and vacm.anno between P_anno and P_anno+1 
                                    and vacm.riferimento between dal
                                         and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                     or ( nvl(P_competenza,'N') = 'X'
                                      and vacm.anno             = P_anno+1
                                      and to_char(vacm.riferimento,'yyyy') = P_anno
                                      and vacm.mese            <= P_fine_mese_liq
                                      and vacm.riferimento between dal 
                                          and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                          )
                                        )
                                  )
               group by vacm.colonna, vacm.riferimento
            UNION
  /* gestione degli arretrati ap */
            select vacm.colonna colonna, vacm.riferimento
                 , nvl(sum(nvl(vacm.valore,0)),0) importo                
              from valori_contabili_mensili    vacm
             where vacm.ci                = CUR_ESTERNI_T12.ci
  /* aggiunto per i tempi di elaborazione */
               and vacm.anno between P_anno and P_anno+1 
               and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                 and nvl(to_number(to_char(p_data_a,'mm')),12)
               and ( nvl(P_competenza,'N') = 'N'
                 and vacm.anno              = P_anno
                or ( nvl(P_competenza,'N') = 'X'
                 and vacm.anno             = P_anno
                 and to_char(vacm.riferimento,'yyyy') < P_anno
                 and vacm.mese            >= P_inizio_mese_liq
                  or nvl(P_competenza,'N')= 'X'
                 and vacm.anno             = P_anno+1
                 and to_char(vacm.riferimento,'yyyy') < P_anno
                 and vacm.mese            <= P_fine_mese_liq
                    )
                   )
               and vacm.mensilita        != '*AP'
               and vacm.estrazione        = 'SMT_TAB8A'
               and vacm.colonna           = 'ARRETRATI_AP'
               and not exists (select 'x' from smt_periodi
                                where ci        = CUR_ESTERNI_T12.ci
                                  and anno      = P_anno
                                  and ( nvl(P_competenza,'N') = 'N'
                                    and vacm.anno              = P_anno
  /* aggiunto per i tempi di elaborazione */
                                    and vacm.anno between P_anno and P_anno+1 
                                    and vacm.riferimento between dal
                                         and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                     or ( nvl(P_competenza,'N') = 'X'
                                      and vacm.anno             = P_anno
                                      and to_char(vacm.riferimento,'yyyy') < P_anno
                                      and vacm.mese            >= P_inizio_mese_liq
                                      and vacm.riferimento between dal 
                                           and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                       or nvl(P_competenza,'N')= 'X'
                                      and vacm.anno             = P_anno+1
                                      and to_char(vacm.riferimento,'yyyy') < P_anno
                                      and vacm.mese            <= P_fine_mese_liq
                                      and vacm.riferimento between dal 
                                          and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                          )
                                        )
                                  )
               group by vacm.colonna, vacm.riferimento
            )LOOP
  -- dbms_output.put_line('ESTERNO1: '||CUR_VACM_EST_T12.colonna||' '||CUR_VACM_EST_T12.importo);
              V_dal := null;
              BEGIN
              select max(dal)
                into V_dal
                from smt_periodi
               where anno             = P_anno
                 and ci               = CUR_ESTERNI_T12.ci
                 and CUR_VACM_EST_T12.riferimento > nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                ;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                V_dal := null;
              END;
               IF V_dal is not null THEN
                 update smt_importi 
                    set importo = nvl(importo,0) + nvl(CUR_VACM_EST_T12.importo,0)
                  where anno        = P_anno
                    and ci          = CUR_ESTERNI_T12.ci
                    and dal         = V_dal
                    and tabella     = 'T12'
                    and colonna     = CUR_VACM_EST_T12.colonna
                    and exists (select 'x' 
                                  from smt_importi
                                 where ci       = CUR_ESTERNI_T12.ci
                                   and anno     = P_anno
                                   and tabella  = 'T12'
                                   and dal      = V_dal
                                   and colonna  = CUR_VACM_EST_T12.colonna
                                       ); 
  -- dbms_output.put_line('Inserimento periodo se manca colonna: '||CUR_ESTERNI_T12.ci||' '||CUR_VACM_EST_T12.colonna);
                 insert into smt_importi
                  (ANNO,CI,GESTIONE,DAL,TABELLA
                  ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                  )
                  select P_anno
                       , CUR_ESTERNI_T12.ci
                       , smpe.gestione
                       , smpe.dal
                       , 'T12'
                       , CUR_VACM_EST_T12.colonna
                       , CUR_VACM_EST_T12.importo
                       , D_utente
                       , null
                       , sysdate
                    from smt_periodi smpe
                  where anno = P_anno
                    and ci = CUR_ESTERNI_T12.ci
                    and dal = V_dal
                    and not exists (select 'x' 
                                      from smt_importi
                                     where ci       = CUR_ESTERNI_T12.ci
                                       and anno     = P_anno
                                       and tabella  = 'T12'
                                       and dal      = V_dal
                                       and colonna  = CUR_VACM_EST_T12.colonna
                                   ); 
                 commit;
               ELSE
                 BEGIN
                 select min(dal)
                   into V_dal
                   from smt_periodi
                  where anno             = P_anno
                    and ci               = CUR_ESTERNI_T12.ci
                    and CUR_VACM_EST_T12.riferimento < nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                   ;
                 EXCEPTION WHEN NO_DATA_FOUND THEN
                   V_dal := null;
                 END;
               IF V_dal is not null THEN
                  update smt_importi 
                    set importo = nvl(importo,0) + nvl(CUR_VACM_EST_T12.importo,0)
                  where anno        = P_anno
                    and ci          = CUR_ESTERNI_T12.ci
                    and dal         = V_dal
                    and tabella     = 'T12'
                    and colonna     = CUR_VACM_EST_T12.colonna
                    and exists (select 'x' 
                                  from smt_importi
                                 where ci       = CUR_ESTERNI_T12.ci
                                   and anno     = P_anno
                                   and tabella  = 'T12'
                                   and dal      = V_dal
                                   and colonna  = CUR_VACM_EST_T12.colonna
                                       ); 
  -- dbms_output.put_line('Inserimento periodo se manca colonna: '||CUR_ESTERNI.ci||' '||CUR_VACM_EST_T12.colonna);
                      insert into smt_importi
                      (ANNO,CI,GESTIONE,DAL,TABELLA
                      ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                      )
                      select P_anno
                           , CUR_ESTERNI_T12.ci
                           , smpe.gestione
                           , smpe.dal
                           , 'T12'
                           , CUR_VACM_EST_T12.colonna
                           , CUR_VACM_EST_T12.importo
                           , D_utente
                           , null
                           , sysdate
                        from smt_periodi smpe
                      where anno = P_anno
                        and ci = CUR_ESTERNI_T12.ci
                        and dal = V_dal
                        and not exists (select 'x' 
                                          from smt_importi
                                         where ci       = CUR_ESTERNI_T12.ci
                                           and anno     = P_anno
                                           and tabella  = 'T12'
                                           and dal      = V_dal
                                           and colonna  = CUR_VACM_EST_T12.colonna
                                       ); 
                    commit;
               ELSE
                  V_dal := null;
  -- non dovrebbe essere un caso esistente, trattasi di dipendente senza smt_periodi
               END IF ; -- dal successivo
               END IF; -- dal precedente
            END LOOP; -- CUR_VACM_EST  
          END;
         END LOOP; -- cur_esterni_T12
       END;
       BEGIN
       FOR CUR_ESTERNI_T13 in 
       (select DISTINCT smpe.ci
                      , nvl(qumi.comparto,nvl(smpe.qualifica,'%')) comparto
          from smt_periodi smpe
             , qualifiche_ministeriali qumi
         where smpe.anno            = P_anno
           and smpe.qualifica       = qumi.codice (+)
           and to_date('3112'||P_anno,'ddmmyyyy') between qumi.dal (+)
                                                      and nvl(qumi.al (+) ,to_date('3333333','j'))
           and smpe.ci              = CUR_CI_PD.ci
           and exists (select 'x' 
                         from valori_contabili_mensili vacm
                        where ( nvl(P_competenza,'N') = 'N'
                           and vacm.anno              = smpe.anno
                           and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                              and nvl(to_number(to_char(p_data_a,'mm')),12)
                           or ( nvl(P_competenza,'N') = 'X'
                            and vacm.anno             = P_anno
                            and to_char(vacm.riferimento,'yyyy') = P_anno
                              or nvl(P_competenza,'N')= 'X'
                             and vacm.anno             = P_anno+1
                             and to_char(vacm.riferimento,'yyyy') = P_anno
                             and vacm.mese             <= P_fine_mese_liq
                              )
                          )
                          and (  (  nvl(qumi.comparto,'%') != 'ELS' 
                               and vacm.estrazione        = 'SMT_TAB8B'
                                 )
                             or (  nvl(qumi.comparto,'%') = 'ELS' 
                               and vacm.estrazione        = 'SMT_TAB13S' )
                              )
                          and vacm.colonna          in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '11', '12','13')
                          and vacm.ci                = smpe.ci
/* aggiunto per i tempi di elaborazione */
                          and vacm.anno between P_anno and P_anno+1 
                          and vacm.mensilita        != '*AP'
                          and not exists (select 'x' from smt_periodi smpe1
                                           where ci        = vacm.ci
                                             and smpe1.anno = P_anno
/* aggiunto per i tempi di elaborazione */
                                            and vacm.anno between P_anno and P_anno+1 
                                            and ( nvl(P_competenza,'N') = 'N'
                                             and vacm.anno              = smpe1.anno
                                             and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                and nvl(to_number(to_char(p_data_a,'mm')),12)
                                             and vacm.riferimento 
                                                 between dal 
                                                     and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                             or (  nvl(P_competenza,'N') = 'X'
                                               and vacm.anno             = P_anno
                                               and to_char(vacm.riferimento,'yyyy') = P_anno
                                               and vacm.riferimento 
                                                   between dal 
                                                       and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                or nvl(P_competenza,'N')= 'X'
                                               and vacm.anno             = P_anno+1
                                               and to_char(vacm.riferimento,'yyyy') = P_anno
                                               and vacm.mese             <= P_fine_mese_liq
                                               and vacm.riferimento 
                                                   between dal 
                                                       and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                )
                                               )
                                          ) 
                       UNION
/* gestione degli arretrati ap */
                       select 'x' 
                         from valori_contabili_mensili vacm
                        where ( nvl(P_competenza,'N') = 'N'
                           and vacm.anno              = smpe.anno
                           and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                              and nvl(to_number(to_char(p_data_a,'mm')),12)
                           or ( nvl(P_competenza,'N') = 'X'
                            and vacm.anno             = P_anno
                            and to_char(vacm.riferimento,'yyyy') < P_anno
                            and vacm.mese            >= P_inizio_mese_liq
                              or nvl(P_competenza,'N')= 'X'
                            and vacm.anno             = P_anno+1
                            and to_char(vacm.riferimento,'yyyy') < P_anno
                            and vacm.mese            <= P_fine_mese_liq
                              )
                          )
                          and (  (  nvl(qumi.comparto,'%') != 'ELS' 
                               and vacm.estrazione        = 'SMT_TAB8B'
                                 )
                             or (  nvl(qumi.comparto,'%') = 'ELS' 
                               and vacm.estrazione        = 'SMT_TAB13S' )
                              )
                          and vacm.colonna           = '10'
                          and vacm.ci                = smpe.ci
/* aggiunto per i tempi di elaborazione */
                          and vacm.anno between P_anno and P_anno+1 
                          and vacm.mensilita        != '*AP'
                          and not exists (select 'x' from smt_periodi smpe1
                                           where ci        = vacm.ci
                                             and smpe1.anno = P_anno
/* aggiunto per i tempi di elaborazione */
                                            and vacm.anno between P_anno and P_anno+1 
                                            and ( nvl(P_competenza,'N') = 'N'
                                             and vacm.anno              = P_anno
                                             and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                and nvl(to_number(to_char(p_data_a,'mm')),12)
                                             and vacm.riferimento
                                                 between dal 
                                                     and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                             or (  nvl(P_competenza,'N') = 'X'
                                               and vacm.anno             = P_anno
                                               and to_char(vacm.riferimento,'yyyy') < P_anno
                                               and vacm.mese            >= P_inizio_mese_liq
                                               and vacm.riferimento 
                                                   between dal 
                                                       and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                or nvl(P_competenza,'N')= 'X'
                                               and vacm.anno             = P_anno+1
                                               and to_char(vacm.riferimento,'yyyy') < P_anno
                                               and vacm.mese            <= P_fine_mese_liq
                                               and vacm.riferimento 
                                                   between dal 
                                                       and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                )
                                               )
                                          ) 
                       )
      ) LOOP
-- dbms_output.put_line('ci: '||CUR_ESTERNI_T13.ci);
          BEGIN
            FOR CUR_VACM_EST_T13 IN (
            select vacm.colonna colonna, vacm.riferimento
                 , nvl(sum(nvl(vacm.valore,0)),0) importo                
              from valori_contabili_mensili    vacm
             where vacm.ci                = CUR_ESTERNI_T13.ci
/* aggiunto per i tempi di elaborazione */
               and vacm.anno between P_anno and P_anno+1 
               and ( nvl(P_competenza,'N') = 'N'
                 and vacm.anno              = P_anno
                or ( nvl(P_competenza,'N') = 'X'
                 and vacm.anno             = P_anno
                 and to_char(vacm.riferimento,'yyyy') = P_anno
                  or nvl(P_competenza,'N')= 'X'
                 and vacm.anno             = P_anno+1
                 and to_char(vacm.riferimento,'yyyy') = P_anno
                 and vacm.mese             <= P_fine_mese_liq
                    )
                   )
               and vacm.mese             between nvl(to_number(to_char(p_data_da,'mm')),1)
                                             and nvl(to_number(to_char(p_data_a,'mm')),12)
               and vacm.mensilita        != '*AP'
               and (  (  nvl(CUR_ESTERNI_T13.comparto,'%') != 'ELS' 
                     and vacm.estrazione        = 'SMT_TAB8B'
                       )
                   or (  nvl(CUR_ESTERNI_T13.comparto,'%') = 'ELS' 
                     and vacm.estrazione        = 'SMT_TAB13S' )
                    )
               and vacm.colonna          in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '11', '12','13')
               and not exists (select 'x' from smt_periodi
                                where anno      = P_anno
                                  and ci        = CUR_ESTERNI_T13.ci
/* aggiunto per i tempi di elaborazione */
                                  and vacm.anno between P_anno and P_anno+1 
                                  and ( nvl(P_competenza,'N') = 'N'
                                    and vacm.anno              = P_anno
                                    and vacm.riferimento 
                                        between dal
                                            and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                     or ( nvl(P_competenza,'N') = 'X'
                                      and vacm.anno             = P_anno
                                      and to_char(vacm.riferimento,'yyyy') = P_anno
                                      and vacm.riferimento 
                                          between dal 
                                              and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                       or nvl(P_competenza,'N')= 'X'
                                      and vacm.anno             = P_anno+1
                                      and to_char(vacm.riferimento,'yyyy') = P_anno
                                      and vacm.mese             <= P_fine_mese_liq
                                      and vacm.riferimento 
                                          between dal 
                                              and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                          )
                                        )
                              )
               group by vacm.colonna, vacm.riferimento
            union
/* gestione degli arretrati ap */
            select vacm.colonna colonna, vacm.riferimento
                 , nvl(sum(nvl(vacm.valore,0)),0) importo                
              from valori_contabili_mensili    vacm
             where vacm.ci                = CUR_ESTERNI_T13.ci
/* aggiunto per i tempi di elaborazione */
               and vacm.anno between P_anno and P_anno+1 
               and ( nvl(P_competenza,'N') = 'N'
                 and vacm.anno              = P_anno
                or ( nvl(P_competenza,'N') = 'X'
                 and vacm.anno             = P_anno
                 and to_char(vacm.riferimento,'yyyy') < P_anno
                 and vacm.mese            >= P_inizio_mese_liq
                  or nvl(P_competenza,'N')= 'X'
                 and vacm.anno             = P_anno+1
                 and to_char(vacm.riferimento,'yyyy') < P_anno
                 and vacm.mese            <= P_fine_mese_liq
                    )
                   )
               and vacm.mese             between nvl(to_number(to_char(p_data_da,'mm')),1)
                                             and nvl(to_number(to_char(p_data_a,'mm')),12)
               and vacm.mensilita        != '*AP'
               and (  (  nvl(CUR_ESTERNI_T13.comparto,'%') != 'ELS' 
                     and vacm.estrazione        = 'SMT_TAB8B'
                       )
                   or (  nvl(CUR_ESTERNI_T13.comparto,'%') = 'ELS' 
                     and vacm.estrazione        = 'SMT_TAB13S' )
                    )
               and vacm.colonna           = '10'
               and not exists (select 'x' from smt_periodi
                                where anno      = P_anno
                                  and ci        = CUR_ESTERNI_T13.ci
/* aggiunto per i tempi di elaborazione */
                                  and vacm.anno between P_anno and P_anno+1 
                                  and ( nvl(P_competenza,'N') = 'N'
                                    and vacm.anno              = P_anno
                                    and vacm.riferimento 
                                        between dal
                                            and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                     or ( nvl(P_competenza,'N') = 'X'
                                      and vacm.anno             = P_anno
                                      and to_char(vacm.riferimento,'yyyy') < P_anno
                                      and vacm.mese            >= P_inizio_mese_liq
                                      and vacm.riferimento
                                          between dal 
                                              and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                       or nvl(P_competenza,'N') = 'X'
                                      and vacm.anno             = P_anno+1
                                      and to_char(vacm.riferimento,'yyyy') < P_anno
                                      and vacm.mese            <= P_fine_mese_liq
                                      and vacm.riferimento 
                                          between dal 
                                              and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                          )
                                        )
                              )
               group by vacm.colonna, vacm.riferimento
            )LOOP
-- dbms_output.put_line('importo est: '||CUR_VACM_EST_T13.importo||' '||CUR_VACM_EST_T13.colonna||' '||CUR_VACM_EST_T13.riferimento);
              V_dal := null;
              BEGIN
              select max(dal)
                into V_dal
                from smt_periodi
               where anno             = P_anno
                and ci               = CUR_ESTERNI_T13.ci
                and CUR_VACM_EST_T13.riferimento > nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                ;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                V_dal := null;
              END;
               IF V_dal is not null THEN
                 update smt_importi 
                    set importo = nvl(importo,0) + nvl(CUR_VACM_EST_T13.importo,0)
                  where anno        = P_anno
                    and ci          = CUR_ESTERNI_T13.ci
                    and dal         = V_dal
                    and tabella     = decode(nvl(CUR_ESTERNI_T13.comparto,'%'),'ELS', 'T13S', 'T13')
                    and colonna     = CUR_VACM_EST_T13.colonna
                    and exists (select 'x' 
                                  from smt_importi
                                 where ci       = CUR_ESTERNI_T13.ci
                                   and anno     = P_anno
                                   and tabella  = decode(nvl(CUR_ESTERNI_T13.comparto,'%'),'ELS', 'T13S', 'T13')
                                   and dal      = V_dal
                                   and colonna  = CUR_VACM_EST_T13.colonna
                               )
                 ;
                 insert into smt_importi
                 (ANNO,CI,GESTIONE,DAL,TABELLA
                 ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                 )
                 select P_anno
                      , CUR_ESTERNI_T13.ci
                      , smpe.gestione
                      , V_dal
                      , decode(nvl(CUR_ESTERNI_T13.comparto,'%'), 'ELS', 'T13S', 'T13' )
                      , CUR_VACM_EST_T13.colonna
                      , CUR_VACM_EST_T13.importo
                      , D_utente
                      , null
                      , sysdate
                   from smt_periodi smpe
                 where anno = P_anno
                   and ci = CUR_ESTERNI_T13.ci
                   and dal = V_dal
                   and not exists (select 'x' 
                                     from smt_importi
                                    where ci       = CUR_ESTERNI_T13.ci
                                      and anno     = P_anno
                                      and tabella  = decode(nvl(CUR_ESTERNI_T13.comparto,'%'),'ELS', 'T13S', 'T13')
                                      and dal      = V_dal
                                      and colonna  = CUR_VACM_EST_T13.colonna
                                  );
                 commit;
               ELSE
                 BEGIN
                 select min(dal)
                   into V_dal
                   from smt_periodi
                  where anno             = P_anno
                    and ci               = CUR_ESTERNI_T13.ci
                    and CUR_VACM_EST_T13.riferimento < nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                   ;
                 EXCEPTION WHEN NO_DATA_FOUND THEN
                   V_dal := null;
                 END;
               IF V_dal is not null THEN
                 update smt_importi 
                    set importo = nvl(importo,0) + nvl(CUR_VACM_EST_T13.importo,0)
                  where anno        = P_anno
                    and ci          = CUR_ESTERNI_T13.ci
                    and dal         = V_dal
                    and tabella     = decode(nvl(CUR_ESTERNI_T13.comparto,'%'),'ELS', 'T13S', 'T13')
                    and colonna     = CUR_VACM_EST_T13.colonna
                    and exists (select 'x' 
                                  from smt_importi
                                 where ci       = CUR_ESTERNI_T13.ci
                                   and anno     = P_anno
                                   and tabella  = decode(nvl(CUR_ESTERNI_T13.comparto,'%'),'ELS', 'T13S', 'T13')
                                   and dal      = V_dal
                                   and colonna  = CUR_VACM_EST_T13.colonna
                               )
                 ;
                 insert into smt_importi
                 (ANNO,CI,GESTIONE,DAL,TABELLA
                 ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                 )
                 select P_anno
                      , CUR_ESTERNI_T13.ci
                      , smpe.gestione
                      , V_dal
                      , decode(nvl(CUR_ESTERNI_T13.comparto,'%'),'ELS', 'T13S', 'T13')
                      , CUR_VACM_EST_T13.colonna
                      , CUR_VACM_EST_T13.importo
                      , D_utente
                      , null
                      , sysdate
                   from smt_periodi smpe
                 where anno = P_anno
                   and ci = CUR_ESTERNI_T13.ci
                   and dal = V_dal
                   and not exists (select 'x' 
                                     from smt_importi
                                    where ci       = CUR_ESTERNI_T13.ci
                                      and anno     = P_anno
                                      and tabella  = decode(nvl(CUR_ESTERNI_T13.comparto,'%'),'ELS', 'T13S', 'T13')
                                      and dal      = V_dal
                                      and colonna  = CUR_VACM_EST_T13.colonna
                                  );
                 commit;
                   ELSE
                     V_dal := null;
-- non dovrebbe essere un caso esistente, trattasi di dipendente senza smt_periodi
                     commit;
                   END IF ; -- dal successivo
              END IF; -- dal precedente
             END LOOP; -- CUR_VACM_EST  
          END;
        END LOOP; --cur_esterni
       END;
    END LOOP; -- cur_ci1
    END ESTERNI;
   END IF; -- p_tipo_elab
 END;
 COMMIT;
END;
END;
END;
/
