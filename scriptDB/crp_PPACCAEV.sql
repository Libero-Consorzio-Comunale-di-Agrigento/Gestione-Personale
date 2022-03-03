CREATE OR REPLACE PACKAGE PPACCAEV IS
/******************************************************************************
 NOME:          PPACCAEV
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (p_prenotazione IN NUMBER, passo IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PPACCAEV IS

      w_prenotazione number(10);
	  errore		 varchar2(6);
	  P_al			 date;
	  P_dal			 date;
	  P_causale		 varchar2(8);
	  P_opzione		 varchar2(1);
	  w_utente		 varchar2(10);
	  w_ambiente	 varchar2(10);
	  w_ente		 varchar2(10);
	  w_lingua		 varchar2(1);
	  P_contratto	 varchar2(5);
	  P_livello		 varchar2(4);
	  P_qualifica	 varchar2(8);
	  P_di_ruolo	 varchar2(2);
	  P_posizione	 varchar2(4);
	  P_figura		 varchar2(8);
	  P_attivita	 varchar2(4);
	  P_gestione	 varchar2(4);
	  P_settore		 varchar2(15);
	  P_sede		 varchar2(8);
	  P_ruolo		 varchar2(4);
	  P_rapporto	 varchar2(4);
	  P_gruppo		 varchar2(12);
	  P_fattore		 varchar2(6);
	  P_cdc			 varchar2(8);
	  P_fascia		 varchar2(2);
 
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

	  -- Pulizia Tabella di lavoro
      PROCEDURE DELETE_TAB IS
      BEGIN
        delete from calcolo_prospetti_presenza
         where prenotazione = w_prenotazione;
      END;
	  -- Inserimento registrazioni di classe per Individui idonei
      PROCEDURE FASE_1 IS
      BEGIN
        insert into calcolo_prospetti_presenza
              (prenotazione
              ,tipo_record
              ,prpa_sequenza        -- Contiene la sequenza della Causale
              ,prpa_codice          -- Contiene il codice   della Causale
              ,prpa_descrizione     -- Contiene la gestione della Causale
              ,sede_codice
              ,sede_sequenza        -- Contiene Minuti Gg
              ,ceco_codice
              ,gest_codice
              ,sett_codice
              ,rain_cognome
              ,rain_nome
              ,rain_ci
              ,pspa_contratto
              ,pspa_dal_rapporto    -- Riempito da sysdate perche` not null
              ,cod_01               -- Contiene Codice della Causale
              ,ges_01               -- Contiene Gestione della Causale
              ,val_01               -- Contiene il Valore dell' Evento
                                    -- nella UM di Gestione della Classe
              ,cod_02               -- Contiene Livello
              ,val_02               -- Contiene Numero dell' Evento
              ,cod_03               -- Contiene Qualifica
              ,cod_04               -- Contiene Indicatore di Ruolo/No Ruolo
              ,cod_05               -- Contiene Posizione
              ,cod_06               -- Contiene Figura
              ,cod_07               -- Contiene Attivita`
              ,cod_08               -- Contiene Ruolo
              ,cod_09               -- Contiene Rapporto
              ,cod_10               -- Contiene Gruppo (char 1-10)
              ,cod_11               -- Contiene Gruppo (char(11-12)
              ,cod_12               -- Contiene Fascia
              ,cod_13               -- Contiene Fattore Produttivo
              ,cod_14               -- Contiene Assistenza
              ,cod_15               -- Contiene Sede del Periodo di Presenza
              ,cod_16               -- Contiene Cdc  del Periodo di Presenza
              )
        select w_prenotazione
              ,'01'
              ,caev.sequenza
              ,caev.codice
              ,caev.gestione
              ,sede.codice
              ,pspa.min_gg
              ,evpa.cdc
              ,gest.codice
              ,sett.codice
              ,rain.cognome
              ,rain.nome
              ,rain.ci
              ,pspa.contratto
              ,sysdate
              ,caev.codice
              ,caev.gestione
              ,evpa.valore
              ,qugi.livello
              ,evpa.evento
              ,qugi.codice
              ,posi.ruolo
              ,pegi.posizione
              ,figi.codice
              ,pegi.attivita
              ,qugi.ruolo
              ,rain.rapporto
              ,substr(rain.gruppo,1,10)
              ,substr(rain.gruppo,11,2)
              ,gest.fascia
              ,nvl(rapa.fattore_produttivo
                  ,decode(pegi.tipo_rapporto,'TD',qual.fattore_td
                                                 ,qual.fattore
                         )
                  )
              ,nvl(rapa.assistenza,trpr.assistenza)
              ,sedp.codice
              ,rifu.cdc
          from trattamenti_previdenziali     trpr
              ,rapporti_retributivi          rare
              ,ripartizioni_funzionali       rifu
              ,sedi                          sede
              ,sedi                          sedp
              ,settori                       sett
              ,gestioni                      gest
              ,qualifiche_giuridiche         qugi
              ,qualifiche                    qual
              ,figure_giuridiche             figi
              ,posizioni                     posi
              ,periodi_giuridici             pegi
              ,rapporti_presenza             rapa
              ,rapporti_individuali          rain
              ,causali_evento                caev
              ,eventi_presenza               evpa
              ,periodi_servizio_presenza     pspa
         where evpa.dal                  <=
               nvl(P_al ,to_date('3333333','j'))
           and nvl(evpa.al,to_date('3333333','j'))
                                         >=
               nvl(P_dal,to_date('2222222','j'))
           and evpa.dal             between pspa.dal
                                        and nvl(pspa.al,to_date('3333333','j'))
           and evpa.ci                    = pspa.ci
           and rain.ci                    = pspa.ci
           and rapa.ci                    = pspa.ci
           and rapa.dal                   = pspa.dal_rapporto
           and caev.codice                = evpa.causale
           and evpa.causale            like P_causale
           and decode(P_opzione,'E','E',caev.qualificazione)
                                          = P_opzione
           and pegi.ci                (+) = pspa.ci
           and pegi.rilevanza         (+) = pspa.rilevanza
           and pegi.dal               (+) = pspa.dal_periodo
           and qual.numero            (+) = pspa.qualifica
           and qugi.numero            (+) = pspa.qualifica
           and qugi.dal               (+) = pspa.dal_qualifica
           and figi.numero            (+) = pspa.figura
           and figi.dal               (+) = pspa.dal_figura
           and sett.numero            (+) = pspa.settore
           and sedp.numero            (+) = pspa.sede
           and sede.numero            (+) = evpa.sede
           and rifu.settore           (+) = pspa.settore
           and rifu.sede              (+) = nvl(pspa.sede_cdc,0)
           and gest.codice            (+) = sett.gestione
           and posi.codice            (+) = pegi.posizione
           and rare.ci                (+) = pspa.ci
           and trpr.codice            (+) = rare.trattamento
           and nvl(evpa.valore,0)        != 0
           and (    rain.cc                is null
                or  rain.cc                is not null
                and exists
                    (select 'x'
                       from a_competenze comp
                      where comp.ambiente   = w_ambiente
                        and comp.ente       = w_ente
                        and comp.utente     = w_utente
                        and comp.competenza = 'CI'
                        and comp.oggetto    = rain.cc
                    )
               )
           and exists
               (select 'x'
                  from classi_rapporto   clra
                 where clra.codice          = rain.rapporto
                   and clra.presenza        = 'SI'
               )
           and (    pspa.ufficio           is null
                or  pspa.ufficio           is not null
                and exists
                    (select 'x'
                       from a_competenze comp
                      where comp.ambiente   = w_ambiente
                        and comp.ente       = w_ente
                        and comp.utente     = w_utente
                        and comp.competenza = pspa.ufficio
                        and comp.oggetto    = 'UFFICIO_PRESENZA'
                    )
               )
        ;
      END;
      
	  -- Eliminazione degli Individui che non hanno attributi
      -- corrispondenti alla collettivita` selezionata ed
      -- emissione registrazioni di classe definitive
      PROCEDURE FASE_2 IS
      cursor indi is
      select capa.rain_ci
            ,capa.prpa_codice
        from calcolo_prospetti_presenza capa
       where capa.prenotazione = w_prenotazione
         and capa.tipo_record  = '01'
       order by capa.rain_ci
      ;
      d_ci               number(8);
      d_causale          varchar2(8);
      cursor capa is
      select nvl(capa.sede_codice,capa.cod_15)
            ,nvl(capa.ceco_codice,capa.cod_16)
            ,capa.gest_codice
            ,capa.sett_codice
            ,capa.pspa_contratto
            ,capa.cod_02
            ,capa.cod_03
            ,capa.cod_04
            ,capa.cod_05
            ,capa.cod_06
            ,capa.cod_07
            ,capa.cod_08
            ,capa.cod_09
            ,capa.cod_10||capa.cod_11
            ,capa.cod_12
            ,capa.cod_13
            ,capa.cod_14
        from calcolo_prospetti_presenza capa
       where capa.prenotazione             = w_prenotazione
         and capa.rain_ci                  = d_ci
         and capa.prpa_codice              = d_causale
         and capa.tipo_record              = '01'
      ;
      d_ok                 varchar2(2);
      d_contratto          varchar2(4);
      d_livello            varchar2(4);
      d_qualifica          varchar2(8);
      d_di_ruolo           varchar2(2);
      d_posizione          varchar2(4);
      d_figura             varchar2(8);
      d_attivita           varchar2(4);
      d_gestione           varchar2(4);
      d_settore            varchar2(15);
      d_sede               varchar2(8);
      d_ruolo              varchar2(4);
      d_rapporto           varchar2(4);
      d_gruppo             varchar2(12);
      d_fascia             varchar2(2);
      d_cdc                varchar2(8);
      d_fattore            varchar2(6);
      d_assistenza         varchar2(6);
      d_min_gg             number(4);
      d_ges_causale        varchar2(1);
      d_dal_evpa           date   ;
      d_al_evpa            date   ;
      d_evento             number(10);
      d_cognome            varchar2(36);
      d_nome               varchar2(36);
      BEGIN
        open indi;
        LOOP
          fetch indi into d_ci,d_causale;
          exit  when indi%NOTFOUND;
          d_ok := 'NO';
          open capa;
          LOOP
            fetch capa into d_sede,d_cdc,d_gestione,d_settore,d_contratto,
                            d_livello,d_qualifica,d_di_ruolo,d_posizione,
                            d_figura,d_attivita,d_ruolo,d_rapporto,d_gruppo,
                            d_fascia,d_fattore,d_assistenza;
            exit  when capa%NOTFOUND;
            IF  nvl(d_contratto ,' ')     like nvl(P_contratto ,'%')
            AND nvl(d_livello   ,' ')     like nvl(P_livello   ,'%')
            AND nvl(d_qualifica ,' ')     like nvl(P_qualifica ,'%')
            AND nvl(d_di_ruolo  ,' ')     like nvl(P_di_ruolo  ,'%')
            AND nvl(d_posizione ,' ')     like nvl(P_posizione ,'%')
            AND nvl(d_figura    ,' ')     like nvl(P_figura    ,'%')
            AND nvl(d_attivita  ,' ')     like nvl(P_attivita  ,'%')
            AND nvl(d_gestione  ,' ')     like nvl(P_gestione  ,'%')
            AND nvl(d_settore   ,' ')     like nvl(P_settore   ,'%')
            AND nvl(d_sede      ,' ')     like nvl(P_sede      ,'%')
            AND nvl(d_ruolo     ,' ')     like nvl(P_ruolo     ,'%')
            AND nvl(d_rapporto  ,' ')     like nvl(P_rapporto  ,'%')
            AND nvl(d_gruppo    ,' ')     like nvl(P_gruppo    ,'%')
            AND nvl(d_fascia    ,' ')     like nvl(P_fascia    ,'%')
            AND nvl(d_cdc       ,' ')     like nvl(P_cdc       ,'%')
            AND nvl(d_fattore   ,' ')     like nvl(P_fattore   ,'%')
                                          THEN
                d_ok := 'SI';
                exit;
            END IF;
          END LOOP;
          close capa;
          IF d_ok = 'SI' THEN
             update calcolo_prospetti_presenza capa
                set capa.tipo_record = '02'
              where capa.prpa_codice      = d_causale
                and capa.rain_ci          = d_ci
                and capa.prenotazione     = w_prenotazione
                and capa.tipo_record      = '01'
             ;
          ELSE
          delete from calcolo_prospetti_presenza capa
           where capa.prpa_codice      = d_causale
             and capa.rain_ci          = d_ci
             and capa.prenotazione     = w_prenotazione
             and capa.tipo_record      = '01'
            ;
          END IF;
        END LOOP;
        close indi;
      END;
      
      -- Procedura Generale di Calcolo
      PROCEDURE CALCOLO IS
      BEGIN
         IF P_al is null THEN
            BEGIN
              select ripa.fin_mes
                into P_al
                from riferimento_presenza ripa
               where ripa.ripa_id = 'RIPA'
                 and rownum       < 2
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                P_al := to_date(to_char(SYSDATE,'ddmmyyyy'),'ddmmyyyy');
            END;
         END IF;
         BEGIN
            DELETE_TAB;
            FASE_1;
            FASE_2;
            commit;
         END;
      END;

      
      
      
	  -- Ricezione Parametri indicati
      PROCEDURE SELEZIONA_PARAMETRI IS
      BEGIN
         BEGIN
           select to_date(para.valore
                         ,decode(nvl(length(translate(para.valore
                                                     ,'a0123456789/','a'
                                                     )
                                           ),0
                                    ),0,'dd/mm/yyyy','dd-mon-yy'
                                )
                         )
             into P_dal
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_DAL'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_dal            := null;
         END;
         BEGIN
           select to_date(para.valore
                         ,decode(nvl(length(translate(para.valore
                                                     ,'a0123456789/','a'
                                                     )
                                           ),0
                                    ),0,'dd/mm/yyyy','dd-mon-yy'
                                )
                         )
             into P_al
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_AL'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_al               := null;
         END;
         BEGIN
           select substr(para.valore,1,1)
             into P_opzione
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_OPZIONE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_opzione        := 'E';
         END;
         BEGIN
           select nvl(substr(para.valore,1,4),'%')
             into P_contratto
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_CONTRATTO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_contratto      := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,4),'%')
             into P_livello
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_LIVELLO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_livello        := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,8),'%')
             into P_qualifica
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_QUALIFICA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_qualifica      := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,2),'%')
             into P_di_ruolo
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_DI_RUOLO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_di_ruolo       := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,4),'%')
             into P_posizione
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_POSIZIONE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_posizione      := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,8),'%')
             into P_figura
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_FIGURA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_figura         := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,4),'%')
             into P_attivita
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_ATTIVITA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_attivita       := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,4),'%')
             into P_gestione
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_GESTIONE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_gestione       := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,15),'%')
             into P_settore
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_SETTORE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_settore        := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,8),'%')
             into P_sede
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_SEDE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_sede           := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,4),'%')
             into P_ruolo
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_RUOLO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_ruolo          := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,4),'%')
             into P_rapporto
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_RAPPORTO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_rapporto       := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,12),'%')
             into P_gruppo
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_GRUPPO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_gruppo         := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,2),'%')
             into P_fascia
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_FASCIA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_fascia         := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,8),'%')
             into P_cdc
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_CDC'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_cdc            := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,6),'%')
             into P_fattore
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_FATTORE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_fattore        := '%';
         END;
         BEGIN
           select nvl(substr(para.valore,1,8),'%')
             into P_causale
             from a_parametri para
            where para.no_prenotazione = w_prenotazione
              and para.parametro       = 'P_CAUSALE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_causale        := '%';
         END;
      END;
	  
	  PROCEDURE MAIN (p_prenotazione IN NUMBER, passo IN NUMBER) IS
	  BEGIN
            IF p_prenotazione != 0 THEN
                  BEGIN  -- Preleva utente da depositare in campi Global
                     select utente
                          , ambiente
                          , ente
                          , gruppo_ling
                       into w_utente
                          , w_ambiente
                          , w_ente
                          , w_lingua
                       from a_prenotazioni
                      where no_prenotazione = p_prenotazione
                     ;
                  EXCEPTION
                     WHEN OTHERS THEN null;
                  END;
               END IF;
               w_prenotazione := p_prenotazione;
               -- Memorizzato in caso di azzeramento per ROLLBACK
               SELEZIONA_PARAMETRI;
               -- viene riazzerato in Form chiamante per evitare Trasaction Completed
               CALCOLO;  -- Esecuzione del Calcolo
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
                        set errore       = 'P05809'
                          , prossimo_passo = 91
                      where no_prenotazione = w_prenotazione
                     ;
                     commit;
                  END IF;
               END IF;
               EXCEPTION
               WHEN OTHERS THEN
                  BEGIN
                     ROLLBACK;
                     IF w_prenotazione = 0 THEN
                        update a_prenotazioni
                           set errore       = '*Abort*'
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