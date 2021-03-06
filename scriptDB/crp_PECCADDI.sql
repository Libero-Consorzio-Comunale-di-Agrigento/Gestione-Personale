CREATE OR REPLACE PACKAGE PECCADDI IS
/******************************************************************************
 NOME:        PECCADMI
 DESCRIZIONE: Creazione delle registrazioni individuali per la
              produzione della dichiarazione di Disoccupazione
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO P_tipo     determina il tipo di elaborazione da effettuare.
 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  31/08/2005 GM       Prima emissione
 2.0  02/10/2005 GM       Sistemazione difetti vari
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN   (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCADDI IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.0 del 02/10/2006';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
D_ente            varchar2(4);
D_ambiente        varchar2(8);
D_utente          varchar2(8);
D_tipo            varchar2(1);
D_dal             periodi_giuridici.dal%type;
D_al              periodi_giuridici.al%type;
D_ci              rapporti_individuali.ci%type;
TOT_assenze       number;
D_gg_lav          number;
D_rap_orario      number;
D_retr_mens_gio   number;
D_tredicesima_gio number;
D_retribuzione    number :=0;
istruzione        varchar2(2000);
BEGIN
-- Estrazione Parametri di Selezione
   BEGIN
     select ente     D_ente
          , utente   D_utente
          , ambiente D_ambiente
       into D_ente, D_utente, D_ambiente
       from a_prenotazioni
      where no_prenotazione = prenotazione
     ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
       D_ente     := null;
       D_ambiente := null;
       D_utente   := null;
   END;
   BEGIN
    select to_number(valore)
       into D_ci
       from a_parametri
      where no_prenotazione = prenotazione
        and parametro    = 'P_CI'
     ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
    D_ci := to_number(null);
   END;
   BEGIN
    select to_date(valore,'dd/mm/yyyy')
       into D_dal
       from a_parametri
      where no_prenotazione = prenotazione
        and parametro    = 'P_DAL'
     ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
    D_dal := to_date(null);
   END;
   BEGIN
    select to_date(valore,'dd/mm/yyyy')
       into D_al
       from a_parametri
      where no_prenotazione = prenotazione
        and parametro    = 'P_AL'
     ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
    D_al := to_date(null);
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
     FOR CUR_CI IN (
       select pegi_p.ci              ci
             ,pegi_s.gestione        gestione
             ,pegi_p.dal             data_assunzione
             ,pegi_p.al              data_interruzione
             ,pegi_s.qualifica       qualifica
             ,pegi_s.posizione       posizione
             ,qugi.descrizione       des_qualifica
             ,qugi.contratto         cod_contratto
             ,qual.qua_inps          qual_inps
             ,posi.tempo_determinato tempo_determinato
             ,posi.part_time         part_time
             ,posi.tipo_part_time    tipo_part_time
             ,posi.stagionale        stagionale
             ,cost.ore_lavoro        cont_ore
             ,pegi_p.posizione       evento_interruzione
             ,evra.descrizione       motivo_interruzione
             ,evra.inps              int_inps
         from periodi_giuridici      pegi_s
            , periodi_giuridici      pegi_p
            , qualifiche_giuridiche  qugi
            , qualifiche             qual
            , posizioni              posi
            , contratti_storici      cost
            , eventi_rapporto        evra
            , rapporti_individuali   rain
        where pegi_p.rilevanza = 'P'
          and pegi_s.rilevanza = 'S'
          and pegi_s.ci        = pegi_p.ci
          and rain.ci          = pegi_p.ci
          and pegi_p.dal       = (select max(dal)
                                    from periodi_giuridici pegi
                                   where rilevanza = 'P'
                                     and ci = pegi_p.ci
                                     and nvl(al,to_date('3333333','j')) between nvl(D_dal,to_date('2222222','J'))
                                                                        and nvl(D_al,sysdate)
                                     and not exists (select 'x'
                                                       from periodi_giuridici
                                                      where rilevanza = 'P'
                                                        and ci = pegi.ci
                                                        and dal > pegi.dal
                                                        and al is null)
                                 )
          and nvl(pegi_p.al,to_date('3333333','J')) != to_date('3333333','J')
          and pegi_p.al        between pegi_s.dal
                               and nvl(pegi_s.al,to_date('3333333','J'))
          and qual.numero      = qugi.numero
          and pegi_s.qualifica = qual.numero
          and pegi_s.dal       between nvl(qugi.dal,to_date('2222222','j'))
                               and nvl(qugi.al,to_date('3333333','j'))
          and posi.codice      = pegi_s.posizione
          and qugi.contratto   = cost.contratto
          and pegi_s.dal       between cost.dal
                               and nvl(cost.al,to_date('3333333','j'))
          and pegi_p.posizione = evra.codice
          and evra.rilevanza = 'T'
      and (rain.cc is null
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
          and ( D_tipo = 'T'
                   or ( D_tipo in ('I','V','P')
                        and ( not exists (select 'x' from dichiarazione_dis
                                         where ci       = pegi_p.ci
                                           and nvl(tipo_agg,' ') = decode(D_tipo
                                                                         ,'P',tipo_agg
                                                                         ,D_tipo)
                                          union
                                           select 'x' from dichiarazione_dis_assenze
                                         where ci   = pegi_p.ci
                                           and nvl(tipo_agg,' ') = decode(D_tipo
                                                                         ,'P',tipo_agg
                                                                         ,D_tipo)
                                          union
                                          select 'x' from dichiarazione_dis_importi
                                         where ci   = pegi_p.ci

                                           and nvl(tipo_agg,' ') = decode(D_tipo
                                                                         ,'P',tipo_agg
                                                                         ,D_tipo)
                                       )
                            )
                      )
                   or ( D_tipo  = 'S'
                        and pegi_p.ci = D_ci )
                 )
        order by pegi_p.ci
      ) LOOP
        -- fase di cancellazione
        BEGIN
         LOCK TABLE dichiarazione_dis_importi IN EXCLUSIVE MODE NOWAIT;
         DELETE
           FROM dichiarazione_dis_importi
          WHERE ci = CUR_CI.ci
         ;
         LOCK TABLE dichiarazione_dis_assenze IN EXCLUSIVE MODE NOWAIT;
         DELETE
           FROM dichiarazione_dis_assenze
          WHERE ci = CUR_CI.ci
         ;
         LOCK TABLE dichiarazione_dis IN EXCLUSIVE MODE NOWAIT;
         DELETE
           FROM dichiarazione_dis
          WHERE ci = CUR_CI.ci
         ;
         COMMIT;
        END;
        BEGIN
          INSERT INTO DICHIARAZIONE_DIS
             ( ddis_id, gestione, ci, qua_inps
             , tempo_determinato, stagionale
             , part_time, tipo_part_time
             , cont_ore, data_ass, data_int
             , int_inps, mot_int, imp_compl, gg_lav
             , imp_gior, gg_mot1, gg_mot2, gg_mot3
             , gg_mot4, gg_mot5, gg_mot6, gg_mot7
             , utente, tipo_agg, data_agg)
          SELECT DDIS_SQ.nextval, CUR_CI.gestione, CUR_CI.CI, CUR_CI.qual_inps
               , CUR_CI.tempo_determinato, CUR_CI.stagionale
               , CUR_CI.part_time, CUR_CI.tipo_part_time
               , CUR_CI.cont_ore, CUR_CI.data_assunzione, CUR_CI.data_interruzione
               , CUR_CI.int_inps, CUR_CI.motivo_interruzione, to_number(null), to_number(null)
               , to_number(null) , to_number(null), to_number(null), to_number(null)
               , to_number(null) , to_number(null), to_number(null), to_number(null)
               , D_utente, null, sysdate
            FROM DUAL;
          commit;
        END;
        -- estrazione delle assenze
        BEGIN
          FOR CUR_ASSENZE IN (
            select greatest(dal,add_months(CUR_CI.data_interruzione,-24)) dal
                 , least(al,CUR_CI.data_interruzione) al
                 , rv_meaning descrizione
              from periodi_giuridici pegi
                 , astensioni        aste
     , pgm_ref_codes     refc     
             where rilevanza = 'A'
               and ci = CUR_CI.ci 
      and rv_domain = 'ASTENSIONI.DISOCCUPAZIONE_INPS'  
      and aste.disoccupazione_inps (+) = refc.rv_low_value                       
               and rownum <= 7
               and dal <= CUR_CI.data_interruzione
               and al  >= add_months(CUR_CI.data_interruzione,-24)
               and aste.codice = pegi.assenza
            order by pegi.dal
          ) LOOP
            BEGIN
              INSERT INTO DICHIARAZIONE_DIS_ASSENZE
                 ( ddis_id
                 , ci
                 , dal
                 , al
                 , motivo
                 , utente
                 , tipo_agg
                 , data_agg
                 )
              SELECT DDIS_SQ.currval
                   , CUR_CI.CI
                   , CUR_ASSENZE.dal
                   , CUR_ASSENZE.al
                   , CUR_ASSENZE.descrizione
                   , D_utente
                   , null
                   , sysdate
                FROM DUAL;
              commit;
            END;
          END LOOP; -- CUR_ASSENZE
        END;
        -- estrazione dei motivi
        TOT_assenze := 0;
        BEGIN
          FOR CUR_MOTIVI IN (
            select aste.disoccupazione_inps motivo
                 , sum(least(al,CUR_CI.data_interruzione)-greatest(dal,add_months(CUR_CI.data_interruzione,-3))+1) giorni
              from periodi_giuridici pegi
                 , astensioni        aste
             where rilevanza = 'A'
               and pegi.assenza = aste.codice
               and ci = CUR_CI.ci
               and dal <= CUR_CI.data_interruzione
               and al  >= add_months(CUR_CI.data_interruzione,-3)
             group by aste.disoccupazione_inps
             order by aste.disoccupazione_inps
           ) LOOP
             BEGIN
               tot_assenze := tot_assenze + CUR_MOTIVI.giorni;
               istruzione  := 'update dichiarazione_dis set gg_mot'||CUR_MOTIVI.motivo|| ' = ' ||CUR_MOTIVI.giorni|| ' where ci = ' ||CUR_CI.ci;
               BEGIN
                 SI4.SQL_EXECUTE(istruzione);
               EXCEPTION
                 WHEN OTHERS then
                   null;  -- possibile gestione di segnalazioni
               END;
               commit;
             END;
          END LOOP; -- CUR_MOTIVI
        END;
        -- calcolo il rapporto orario
        BEGIN
          select nvl(pegi_s.ore,cost.ore_lavoro) / cost.ore_lavoro rapporto_orario
            into D_rap_orario
            from periodi_giuridici  pegi_s
               , contratti_storici  cost
           where cost.contratto  IN 
                 (select contratto 
                    from qualifiche_giuridiche qugi
                   where numero = pegi_s.qualifica
                    and CUR_CI.data_interruzione BETWEEN qugi.dal AND NVL(qugi.al,TO_DATE(3333333,'j'))
                 )
             and CUR_CI.data_interruzione BETWEEN cost.dal AND NVL(cost.al,TO_DATE(3333333,'j'))      
             and pegi_s.al = CUR_CI.data_interruzione
             and rilevanza = 'S'
             and pegi_s.ci = CUR_CI.ci
          ;
        END;
        -- calcolo la retribuzione mensile giornaliera
        BEGIN
          SELECT   ( SUM( DISTINCT decode( covo_r.rapporto
                                                                        ,'R',inre_r.tariffa * D_rap_orario    
                                                                        ,'O',inre_r.tariffa * D_rap_orario    
                                                                            ,inre_r.tariffa
                                                                ) 
                                               )
                         ) / 30 retr_mensile_dec
              INTO D_retr_mens_gio
              FROM informazioni_retributive    inre_r
                  ,contabilita_voce            covo_r
             WHERE covo_r.voce  = inre_r.voce
               AND covo_r.sub   = inre_r.sub
               AND inre_r.ci    = CUR_CI.ci
               AND ( inre_r.voce, inre_r.sub ) in ( select voce, sub 
                                                      from estrazione_righe_contabili 
                                                     where estrazione = 'DISOCCUPAZIONE_INPS'
                                                       and colonna in ('EMOLUMENTI')
                                                  ) 
               AND (   (    inre_r.tipo != 'B')
                    OR (    inre_r.tipo  = 'B'
                        AND NOT EXISTS
                                     ( SELECT 1
                                       FROM informazioni_retributive inre2
                                           ,voci_contabili           voco
                                      WHERE inre2.ci     = inre_r.ci
                                        AND inre2.voce   = inre_r.voce
                                        AND inre2.ROWID != inre_r.ROWID
                                        AND voco.voce    = inre_r.voce
                                        AND inre2.sub   != 'Q'
                                        AND CUR_CI.data_interruzione BETWEEN NVL(inre2.dal,TO_DATE('2222222','j'))
                                                        AND NVL(inre2.al,TO_DATE('3333333','j'))
                                     ))
                   )
               AND CUR_CI.data_interruzione BETWEEN NVL(inre_r.dal,TO_DATE('2222222','j'))
                               AND NVL(inre_r.al,TO_DATE('3333333','j'))
          ;
        END;
        -- calcolo il rateo di tedicesima
        BEGIN
          SELECT   ( SUM( DISTINCT decode( covo_r.rapporto
                                                                        ,'R',inre_r.tariffa * D_rap_orario    
                                                                        ,'O',inre_r.tariffa * D_rap_orario    
                                                                            ,inre_r.tariffa
                                                                ) 
                                               )
                         ) / 30 retr_mensile_dec
              INTO D_tredicesima_gio
              FROM informazioni_retributive    inre_r
                  ,contabilita_voce            covo_r
             WHERE covo_r.voce  = inre_r.voce
               AND covo_r.sub   = inre_r.sub
               AND inre_r.ci    = CUR_CI.ci
               AND ( inre_r.voce, inre_r.sub ) in ( select voce, sub 
                                                      from estrazione_righe_contabili 
                                                     where estrazione = 'DISOCCUPAZIONE_INPS'
                                                       and colonna in ('EMOLUMENTI_13A')
                                                  ) 
               AND (   (    inre_r.tipo != 'B')
                    OR (    inre_r.tipo  = 'B'
                        AND NOT EXISTS
                                     ( SELECT 1
                                       FROM informazioni_retributive inre2
                                           ,voci_contabili           voco
                                      WHERE inre2.ci     = inre_r.ci
                                        AND inre2.voce   = inre_r.voce
                                        AND inre2.ROWID != inre_r.ROWID
                                        AND voco.voce    = inre_r.voce
                                        AND inre2.sub   != 'Q'
                                        AND CUR_CI.data_interruzione BETWEEN NVL(inre2.dal,TO_DATE('2222222','j'))
                                                        AND NVL(inre2.al,TO_DATE('3333333','j'))
                                     ))
                   )
               AND CUR_CI.data_interruzione BETWEEN NVL(inre_r.dal,TO_DATE('2222222','j'))
                               AND NVL(inre_r.al,TO_DATE('3333333','j'))
          ;
        END;
        -- calcolo i giorni lavorati
        BEGIN
          select sum(least(al,CUR_CI.data_interruzione)-greatest(dal,add_months(CUR_CI.data_interruzione,-3))+1) gg_lav
            into D_gg_lav 
            from periodi_giuridici pegi
           where rilevanza = 'S' 
             and ci  = CUR_CI.ci
             and dal <= CUR_CI.data_interruzione
             and al  >= add_months(CUR_CI.data_interruzione,-3)
           order by dal
          ;
        END;
        -- aggiorno i campi IMPORTO_COMPLESSIVO, IMPORTO_GIORNALIERO, GIONATE_LAVORATE 
        BEGIN
          update dichiarazione_dis
             set gg_lav     = D_gg_lav - TOT_assenze
               , imp_compl  = (D_retr_mens_gio * D_gg_lav) + (D_tredicesima_gio / 12 * round(D_gg_lav))
               , imp_gior   = D_retr_mens_gio + (D_tredicesima_gio / 12)
           where ci = CUR_CI.ci
          ;     
        END;
        BEGIN
          FOR CUR_IMPORTI IN (
     select sum(st_inp)            settimane
          , pere.anno              anno
       , pere.mese              mese
       from periodi_retributivi    pere
      where pere.ci = CUR_CI.CI
        and upper(competenza) in ('A','C','P')
        and months_between(last_day(CUR_CI.data_interruzione)
                          ,last_day(to_date(lpad(to_char(pere.mese),2,0)||to_char(pere.anno),'mmyyyy'))) between 0 and 24                    
        and periodo >= add_months(last_day(CUR_CI.data_interruzione),-24)
     and al >= add_months(last_day(CUR_CI.data_interruzione),-24)
      group by pere.anno,pere.mese    
          ) LOOP
            BEGIN
              -- calcolo la retribuzione
              BEGIN     
    select sum(valore)              retribuzione
      into D_retribuzione
      from valori_contabili_mensili vacm
     where estrazione = 'DISOCCUPAZIONE_INPS'
       and colonna    = 'DS22'
       and vacm.ci    = CUR_CI.CI
       and vacm.anno  = CUR_IMPORTI.anno
       and vacm.mese  = CUR_IMPORTI.mese
                ;
              END;
              -- Inserisco IMPORTI
              INSERT INTO DICHIARAZIONE_DIS_IMPORTI
                 ( ddis_id
                 , anno
                 , mese
                 , ci
                 , retribuzione
                 , retribuzione_spe
                 , settimane
                 , gg_lav
                 , gg_nlav
                 , utente
                 , data_agg
                 , tipo_agg
                 )
              SELECT DDIS_SQ.currval
                   , CUR_IMPORTI.anno
                   , CUR_IMPORTI.mese
                   , CUR_CI.CI
                   , D_retribuzione
                   , to_number(null)
                   , CUR_IMPORTI.settimane
                   , to_number(null)
                   , to_number(null)
                   , D_utente
                   , sysdate
                   , null
                FROM DUAL;
              commit;
            END;
          END LOOP;  -- CUR_IMPORTI
        END;
      END LOOP; -- CUR_CI
   END;
END;
END;
/
