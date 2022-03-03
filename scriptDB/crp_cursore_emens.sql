CREATE OR REPLACE PACKAGE CURSORE_EMENS IS
/******************************************************************************
 NOME:          CURSORE_EMENS
 DESCRIZIONE:   
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  03/05/2005 MS     Prima emissione.
 1.1  04/05/2005 MS     Mod. per att. 11038
 1.2  12/05/2005 MS     Mod. per att. 10872.1
 1.3  13/05/2005 MS     Mod. per att. 10895.1
 1.4  17/05/2005 MS     Mod. per att. 11204
 1.5  25/05/2005 MS     Mod. per att. 11344
 1.6  01/07/2005 MS     Mod. per att. 11753 + 11766 + 11801 + 11753
 1.7  11/07/2005 MS     Mod. per att. 11915
 1.8  07/11/2005 MS     Aggiunta NVL in update per att. 13379
 1.9  19/12/2005 MS     Aggiunti campi  per CUD: ritenuta e contributo
 2.0  12/01/2006 MS     Aggiunta colonna BONUS - Att.14331
 2.1  15/02/2006 MS     Gestito NVL in posi.collaboratore = NO - Att.14905
 2.2  16/02/2006 MS     Mod. per attivita 14846
 2.3  23/02/2006 MS     Implemetazioni controlli negativi - attivita 14963
 2.4  06/03/2006 MS     Mod. gestione collaboratori ( Att.15156 )
 2.5  20/03/2006 MS     Mod. function e lettura dati per calcolo giorni ( Att.15416 )
 2.6  15/05/2006 MS     Integrazione per enti privati ( att.16002 )
 2.7  20/07/2006 MS     Sistemazione segnalazioni varie ( A17035 )
 2.8  19/09/2006 MS     Aggiunto controllo su rilevanza in cur_var ( A17740 )
 2.9  20/12/2006 MS     Mod.controllo per calcolo sett. solo DIP e solo se gg ret != 0
 2.10 19/03/2007 MS     Mod. ordinamento cur_emens_emens ( mancava il ci ) 
                        Aggiunta segnalazione errore per record senza codice catasto
 2.11 22/05/2007 MS     Correzione accorpamento per personale anticipato
 2.12 23/05/2007 MS     Aggiunta gestione della gestione alternativa 
                        Aggiunta archiviazione per Gruppo ( Att. 20885 )
 3.0  01/06/2007 MS     Adeguamento versione 2.1 ( Att. 20884 )
 3.1  06/06/2007 MS     Aggiunto controllo su colonna MALATTIE ( Att. 21533 )
 3.2  14/06/2007 MS     Aggiunta segnalazione per gestione TFR
 3.3  11/09/2007 MS     Eliminata segnalazione per gestione TFR
******************************************************************************/
FUNCTION VERSIONE                   RETURN VARCHAR2;
cursor CUR_CI_EMENS
      ( P_tipo      varchar2
      , P_ci        number
      , P_ruolo     varchar2
      , P_anno      number
      , P_mese      number
      , P_posizione varchar2
      , P_gestione  varchar2
      , P_fascia    varchar2
      , P_rapporto  varchar2
      , P_gruppo    varchar2
      , P_tipo_gg   varchar2
      , P_sfasato   varchar2
      , D_anno_den  varchar2
      , D_mese_den  varchar2
      , P_ente      varchar2
      , P_ambiente  varchar2
      , P_utente    varchar2
      ) is
-- estrazione record per dipendenti
     select pere.ci
          , pere.gestione
          , pere.posizione
          , pere.contratto
          , pere.dal                                         dal
          , pere.al                                          al
          , decode( posi.collaboratore, 'SI', 'COCO', 'DIP') specie_rapporto
          , GET_QUALIFICA1_EMENS(pere.qualifica)             qualifica1
          , GET_QUALIFICA2_EMENS(pere.posizione)             qualifica2
          , GET_QUALIFICA3_EMENS(pere.posizione)             qualifica3
          , GET_TIPO_CONTRIBUZIONE_EMENS(trpr.contribuzione) tipo_contribuzione
          , trpr.contribuzione                               codice_contribuzione
          , cost.con_inps                                    codice_contratto
          , rare.codice_inps                                 cod_inps
          , ''                                               tipo_rapporto
          , ''                                               attivita
          , decode( trpr.contribuzione
                  , 99,to_number(null)
                      ,decode( P_tipo_gg,'I',pere.gg_inp ,pere.gg_con )
                  )                                          gg_ret
          , decode( trpr.contribuzione
                  , 99,to_number(null)
                      ,decode( posi.part_time 
                              , 'NO',to_number(null)
                                    ,e_round(( ( nvl(cost.ore_gg,6) 
                                               * decode( P_tipo_gg,'I',pere.gg_inp ,pere.gg_con)
                                     ) * ( pere.ore / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro) ) 
                                   ) / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)
                                 ,'I')
                    ))                                          sett_utili    
      from  rapporti_individuali        rain
          , periodi_retributivi         pere
          , rapporti_retributivi        rare
          , posizioni                   posi
          , gestioni                    gest
          , contratti_storici           cost
          , trattamenti_previdenziali   trpr
     where rain.ci        = pere.ci
       and (    posi.di_ruolo      = P_ruolo
             or P_ruolo            = '%'
             or P_tipo = 'S' )
       and nvl(posi.collaboratore,'NO')      = 'NO'
       and trpr.codice    (+) = pere.trattamento
       and cost.contratto (+) = pere.contratto
       and pere.periodo between cost.dal
                            and nvl(cost.al,to_date('3333333','j'))
       and pere.periodo       = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
       and to_char(pere.al,'yyyy') <= P_anno
       and pere.competenza in ('C','A')
       and pere.posizione      like P_posizione 
       and pere.gestione       like P_gestione 
       and pere.gestione   in (select codice
                                 from gestioni
                                where nvl(fascia,'%') like P_fascia)
       and rain.rapporto       like P_rapporto
       and nvl(rain.gruppo,' ') like P_gruppo
       and gest.codice        (+)  = pere.gestione
       and posi.codice        (+)  = pere.posizione
       and rare.ci (+)             = pere.ci
       and pere.ci                 = nvl(P_ci,pere.ci)
       and (   P_tipo = 'T'
          or ( P_tipo = 'S' and pere.ci = P_ci )
          or ( P_tipo in ('I','V','P')
               and ( not exists (select 'x' from denuncia_emens 
                                  where anno = P_anno and  mese = P_mese 
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from settimane_emens 
                                  where anno = P_anno and  mese = P_mese 
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from variabili_emens 
                                  where anno = P_anno and  mese = P_mese
                                     and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from dati_particolari_emens 
                                  where anno = P_anno and  mese = P_mese
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from fondi_speciali_emens 
                                  where anno = P_anno and  mese = P_mese
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from gestione_tfr_emens 
                                  where anno = P_anno and  mese = P_mese
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                     )
                          )
                       )
               )
        and exists
           (select 'x' from movimenti_contabili
             where anno = to_char(pere.periodo,'yyyy')
               and mese = to_char(pere.periodo,'mm')
               and ci   = pere.ci
               and (voce,nvl(sub,'*')) in
                  (select voce,nvl(sub,'*')
                     from estrazione_righe_contabili
                    where estrazione = 'DENUNCIA_EMENS'
                      and colonna   in ('IMPONIBILE', 'IMPONIBILE_01', 'BONUS', 'MALATTIE')
                      and to_date('3112'||P_anno,'ddmmyyyy')
                          between dal and nvl(al,to_date('3333333','j'))
                  )
            )
        and rain.ci = pere.ci
         and (   rain.cc is null
              or exists
                ( select 'x'
                   from a_competenze
                  where ente        = P_ente
                    and ambiente    = P_ambiente
                    and utente      = P_utente
                    and competenza  = 'CI'
                    and oggetto     = rain.cc
                 )
             )
     union
-- estrazione record per collaboratori
     select pere.ci
          , pere.gestione
          , pere.posizione
          , pere.contratto          
          , min(decode( least( greatest( pere.dal
                                       , to_date(lpad(pere.mese,2,0)||
                                                 pere.anno,'mmyyyy')
                                       )
                         , nvl(pere.al,to_date('3333333','j')))
                  , nvl(pere.al,to_date('3333333','j')), pere.dal
                       , greatest( pere.dal
                                 , to_date(lpad(pere.mese,2,0)||
                                           pere.anno,'mmyyyy')
                                 ))
                  )                                          dal
          , max(pere.al)                                     al
          , decode( posi.collaboratore, 'SI', 'COCO', 'DIP') specie_rapporto
          , null                                             qualifica1
          , null                                             qualifica2
          , null                                             qualifica3
          , GET_TIPO_CONTRIBUZIONE_EMENS(trpr.contribuzione) tipo_contribuzione
          , to_number(null)                                  codice_contribuzione
          , null                                             codice_contratto
          , rare.codice_inps                                 cod_inps
          , pere.tipo_rapporto                               tipo_rapporto
          , pere.attivita                                    attivita
          , to_number(null)                                  gg_ret
          , to_number(null)                                  sett_utili
      from  rapporti_individuali        rain
          , periodi_retributivi         pere
          , rapporti_retributivi        rare
          , posizioni                   posi
          , gestioni                    gest
          , contratti_storici           cost
          , trattamenti_previdenziali   trpr
     where rain.ci        = pere.ci
       and posi.collaboratore      = 'SI'
       and trpr.codice    (+) = pere.trattamento
       and trpr.contribuzione != 99
       and trpr.previdenza    = 'INPS'
       and cost.contratto (+) = pere.contratto
       and pere.periodo between cost.dal
                            and nvl(cost.al,to_date('3333333','j'))
       and pere.periodo       = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
       and to_char(pere.al,'yyyy') <= P_anno
       and pere.competenza in ('C','A')
       and pere.posizione      like P_posizione
       and pere.gestione       like P_gestione 
       and pere.gestione   in (select codice
                                 from gestioni
                                where nvl(fascia,'%') like P_fascia)
       and rain.rapporto       like P_rapporto
       and nvl(rain.gruppo,' ') like P_gruppo
       and gest.codice        (+)  = pere.gestione
       and posi.codice        (+)  = pere.posizione
       and rare.ci (+)             = pere.ci
       and pere.ci                 = nvl(P_ci,pere.ci)
       and (   P_tipo = 'T'
          or ( P_tipo = 'S' and pere.ci = P_ci )
          or ( P_tipo in ('I','V','P')
               and ( not exists (select 'x' from denuncia_emens 
                                  where anno = P_anno and  mese = P_mese 
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from settimane_emens 
                                  where anno = P_anno and  mese = P_mese 
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from variabili_emens 
                                  where anno = P_anno and  mese = P_mese 
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from dati_particolari_emens 
                                  where anno = P_anno and  mese = P_mese 
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from fondi_speciali_emens 
                                  where anno = P_anno and  mese = P_mese 
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                  union
                                 select 'x' from gestione_tfr_emens 
                                  where anno = P_anno and  mese = P_mese
                                    and ci       = pere.ci
                                    and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                     or (P_tipo     = 'P' and tipo_agg is not null) )
                                     )
                          )
                       )
               )
        and ( exists ( select 'x' from movimenti_contabili
                        where anno = to_char(pere.periodo,'yyyy')
                          and mese = to_char(pere.periodo,'mm')
                          and ci   = pere.ci
                          and (voce,nvl(sub,'*')) in ( select voce,nvl(sub,'*')
                                                         from estrazione_righe_contabili
                                                        where estrazione = 'DENUNCIA_EMENS'
                                                          and colonna   = 'COMPENSO'
                                                          and riferimento between pere.dal
                                                                              and nvl(pere.al,to_date('3333333','j'))
                                                      )
                     )
           or not exists ( select 'x' 
                             from estrazione_righe_contabili
                            where estrazione = 'DENUNCIA_EMENS'
                              and colonna   = 'COMPENSO'
                         ) 
              and exists ( select 'x' from movimenti_contabili
                            where anno = to_char(pere.periodo,'yyyy')
                              and mese = to_char(pere.periodo,'mm')
                              and ci   = pere.ci
                              and (voce,nvl(sub,'*')) in ( select voce,nvl(sub,'*')
                                                             from estrazione_righe_contabili
                                                            where estrazione = 'DENUNCIA_EMENS'
                                                              and colonna   in ('IMPONIBILE', 'IMPONIBILE_01' )
                                                              and to_date('3112'||P_anno,'ddmmyyyy')
                                                                  between dal and nvl(al,to_date('3333333','j'))
                                                         )
                        )
            )
        and rain.ci = pere.ci
         and (   rain.cc is null
              or exists
                ( select 'x'
                   from a_competenze
                  where ente        = P_ente
                    and ambiente    = P_ambiente
                    and utente      = P_utente
                    and competenza  = 'CI'
                    and oggetto     = rain.cc
                 )
             )
   group by pere.ci
          , pere.gestione
          , pere.posizione
          , pere.contratto
          , decode( posi.collaboratore, 'SI', 'COCO', 'DIP')
          , GET_TIPO_CONTRIBUZIONE_EMENS(trpr.contribuzione) 
          , rare.codice_inps
          , pere.tipo_rapporto
          , pere.attivita
   order by 1,3,4
  ;
CURSOR CUR_DIP_EMENS
      ( P_tipo      varchar2
      , P_ci        number
      , P_anno      number
      , P_mese      number
      , P_posizione varchar2
      , P_gestione  varchar2
      , P_fascia    varchar2
      , P_ruolo     varchar2
      , P_rapporto  varchar2
      , P_gruppo    varchar2
      , P_ente      varchar2
      , P_ambiente  varchar2
      , P_utente    varchar2
      , P_settimane varchar2
      ) is
     select ci, dal, al, deie_id, giorni_retribuiti, specie_rapporto, qualifica1, qualifica2, qualifica3
       from denuncia_emens deie
      where anno = P_anno
        and mese = P_mese
        and rilevanza = 'C'
        and ( P_settimane = 'N'
            or ( P_settimane = 'S'
             and nvl(giorni_retribuiti,0) != 0
              and specie_rapporto = 'DIP'
               )
            )
        and (    P_tipo = 'T'
             or ( P_tipo = 'S' and deie.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    ( select 'x' from denuncia_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from gestione_tfr_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                    )
                )
            )
         and exists (select 'x' 
                       from periodi_retributivi pere
                          , posizioni posi
                      where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                        and competenza in ('P','C','A')
                        and servizio   in ('Q','I','N')
                        and ci          = deie.ci
                        and pere.posizione like P_posizione
                        and gestione       like P_gestione 
                        and pere.gestione   in (select codice
                                                  from gestioni
                                                 where nvl(fascia,'%') like P_fascia)
                        and pere.posizione  = posi.codice
                        and ( posi.di_ruolo = P_ruolo
                           or ( P_tipo = 'S' and pere.ci = P_ci )
                           or P_ruolo            = '%'
                           or posi.collaboratore = 'SI'
                            )
                      )
         and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = deie.ci
                 and rain.rapporto       like P_rapporto
                 and nvl(rain.gruppo,' ') like P_gruppo
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = P_ente
                            and ambiente    = P_ambiente
                            and utente      = P_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                      )
                   )
           )
  order by 1,2,3
;
CURSOR CUR_EVENTO
      ( P_ci        number
      , P_anno      number
      , P_mese      number
      , P_evento    number
      ) is
      select dal 
           , al
           , decode( P_evento
                   , 1, codice_evento1
                   , 2, codice_evento2
                   , 3, codice_evento3
                   , 4, codice_evento4
                   , 5, codice_evento5
                   , 6, codice_evento6
                   , 7, codice_evento7
                   ) codice_evento
        from settimane_emens seie
       where anno = P_anno
         and mese = P_mese
         and ci   = P_ci
         and decode( P_evento
                   , 1, codice_evento1
                   , 2, codice_evento2
                   , 3, codice_evento3
                   , 4, codice_evento4
                   , 5, codice_evento5
                   , 6, codice_evento6
                   , 7, codice_evento7
                   ) is not null
;
CURSOR CUR_ACCORPA_EMENS 
      ( P_tipo      varchar2
      , P_ci        number
      , P_anno      number
      , P_mese      number
      , P_posizione varchar2
      , P_gestione  varchar2
      , P_fascia    varchar2
      , P_ruolo     varchar2
      , P_rapporto  varchar2
      , P_gruppo    varchar2
      , P_ente      varchar2
      , P_ambiente  varchar2
      , P_utente    varchar2
      ) is
       select distinct ci, specie_rapporto
        from denuncia_emens deie
       where anno = P_anno
         and mese = P_mese
         and rilevanza = 'C'
         and (    P_tipo = 'T'
           or ( P_tipo = 'S' and deie.ci = P_ci )
           or ( P_tipo in ('P','V','I')
               and not exists
                    ( select 'x' from denuncia_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from gestione_tfr_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                    )
              )
          )
         and exists (select 'x'
                       from periodi_retributivi pere
                          , posizioni posi
                      where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                        and competenza in ('P','C','A')
                        and servizio   in ('Q','I','N')
                        and ci          = deie.ci
                        and pere.posizione like P_posizione
                        and gestione       like P_gestione
                        and pere.gestione   in (select codice
                                                  from gestioni
                                                 where nvl(fascia,'%') like P_fascia)
                        and pere.posizione  = posi.codice
                        and ( posi.di_ruolo = P_ruolo
                           or ( P_tipo = 'S' and pere.ci = P_ci )
                           or P_ruolo            = '%'
                           or posi.collaboratore = 'SI'
                            )
                      )
         and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = deie.ci
                 and rain.rapporto       like P_rapporto
                 and nvl(rain.gruppo,' ') like P_gruppo
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = P_ente
                            and ambiente    = P_ambiente
                            and utente      = P_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                      )
                   )
                )
     order by 1
;
cursor CUR_EMENS_EMENS
      ( P_tipo      varchar2
      , P_ci        number
      , P_ruolo     varchar2
      , P_anno      number
      , P_mese      number
      , P_posizione varchar2
      , P_gestione  varchar2
      , P_fascia    varchar2
      , P_rapporto  varchar2
      , P_gruppo    varchar2
      , P_ente      varchar2
      , P_ambiente  varchar2
      , P_utente    varchar2
      ) is
select ci, dal, al , deie_id, giorni_retribuiti, rilevanza, specie_rapporto, riferimento, gestione
     from denuncia_emens deie
    where anno = P_anno
      and mese = P_mese
      and rilevanza = 'C'
      and (    P_tipo = 'T'
           or ( P_tipo = 'S' and deie.ci = P_ci )
           or ( P_tipo in ('P','V','I')
               and not exists
                    ( select 'x' from denuncia_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from gestione_tfr_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                   )
              )
          )
         and exists (select 'x' 
                       from periodi_retributivi pere
                          , posizioni posi
                      where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                        and competenza in ('P','C','A')
                        and servizio   in ('Q','I','N')
                        and ci          = deie.ci
                        and pere.posizione like P_posizione
                        and gestione       like P_gestione 
                        and pere.gestione   in (select codice
                                                  from gestioni
                                                 where nvl(fascia,'%') like P_fascia)
                        and pere.posizione  = posi.codice
                        and ( posi.di_ruolo = P_ruolo
                           or ( P_tipo = 'S' and pere.ci = P_ci )
                           or P_ruolo            = '%'
                           or posi.collaboratore = 'SI'
                            )
                      )
         and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = deie.ci
                 and rain.rapporto       like P_rapporto
                 and nvl(rain.gruppo,' ') like P_gruppo
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = P_ente
                            and ambiente    = P_ambiente
                            and utente      = P_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                      )
                   )
           )
   order by 1,2,3
;
CURSOR CUR_ERRORI_EMENS 
      ( P_tipo      varchar2
      , P_ci        number
      , P_anno      number
      , P_mese      number
      ) is
        select distinct ci, dal, 'P05197' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens
         where anno = P_anno and  mese = P_mese 
          and dal > al 
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
-- Incongruenza tra Giorni e Settimane
        select distinct ci, dal, 'P07063' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(giorni_retribuiti,0) != 0 
          and not exists  ( select 'x' from settimane_emens
                             where deie_id  = deie.deie_id
                          )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P07063' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(giorni_retribuiti,0) = 0 
          and   exists  ( select 'x' from settimane_emens
                             where deie_id  = deie.deie_id
                          )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
-- Esistono Valori Negativi
        select distinct ci,dal, 'P05840' errore
             , ' - (Giorni) per CI: '||ci
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(giorni_retribuiti,0) < 0 
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P05840' errore
             , ' - (Imponibile) per CI: '||ci
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(imponibile,0) < 0 
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P05840' errore
             , ' - (Ritenuta) per CI: '||ci
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(ritenuta,0) < 0 
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P05840' errore
             , ' - (Contributo) per CI: '||ci
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(contributo,0) < 0 
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P05840' errore
             , ' - (Diff. Accredito) per CI: '||ci
          from settimane_emens deie
         where anno = P_anno and  mese = P_mese 
          and ( nvl(diff_accredito1,0) < 0 
             or nvl(diff_accredito2,0) < 0 
             or nvl(diff_accredito3,0) < 0 
             or nvl(diff_accredito4,0) < 0 
             or nvl(diff_accredito5,0) < 0 
             or nvl(diff_accredito6,0) < 0 
             or nvl(diff_accredito7,0) < 0 
              )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P05840' errore
             , ' - (Variabili) per CI: '||ci
          from variabili_emens deie
         where anno = P_anno and  mese = P_mese 
          and ( nvl(aum_imponibile,0) < 0 
             or nvl(dim_imponibile,0) < 0 
              )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P05840' errore
             , ' - (Dati Particolari) per CI: '||ci
          from dati_particolari_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(imponibile,0) < 0 
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal, 'P05840' errore
             , ' - (Fondi Speciali) per CI: '||ci
          from fondi_speciali_emens deie
         where anno = P_anno and  mese = P_mese 
          and ( nvl(retr_pens,0) < 0 
             or nvl(arretrati,0) < 0 
             or nvl(contr_sind,0) < 0 
              )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
        select distinct ci,dal_emens, 'P05840' errore
             , ' - (Gestione TFR) per CI: '||ci
          from gestione_tfr_emens gede
         where anno = P_anno and  mese = P_mese 
          and ( nvl(base_calcolo,0) < 0 
             or nvl(imp_corrente,0) < 0 
             or nvl(imp_pregresso,0) < 0 
             or nvl(imp_liquidazione,0) < 0 
             or nvl(imp_anticipazione,0) < 0 
              )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
-- segnalazioni su tipo assunzione
        select distinct ci,dal, 'P04172' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
           and ( nvl(giorno_assunzione,0) != 0 and nvl(tipo_assunzione,'X') = 'X'
            or nvl(tipo_assunzione,'X') != 'X' and nvl(giorno_assunzione,0) = 0 )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
-- segnalazioni su tipo cessazione
        select distinct ci,dal, 'P04171' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
           and ( nvl(giorno_cessazione,0) != 0 and nvl(tipo_cessazione,'X') = 'X'
            or nvl(tipo_cessazione,'X') != 'X'and nvl(giorno_cessazione,0) = 0 )
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
-- segnalazioni su mancanza campo scaglione assegno familiare
        select distinct ci,dal, 'P05380' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
           and tab_anf is not null
           and num_anf is not null
           and classe_anf is null
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
       union
-- segnalazioni per cambio di gestione
        select distinct ci,dal, 'P05195' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
           and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
           and exists ( select 'x' 
                          from denuncia_emens
                         where ci = deie.ci
                           and riferimento = deie.riferimento
                           and gestione != deie.gestione
                      )
       union
-- segnalazioni per cambio di gestione alternativa
        select distinct ci,dal, 'P05195' errore
             , ' alternativa per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese
           and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
           and exists ( select 'x'
                          from denuncia_emens
                         where ci = deie.ci
                           and riferimento = deie.riferimento
                           and nvl(gestione_alternativa,' ') != nvl(deie.gestione_alternativa,' ')
                      )
       union
-- segnalazioni su imponibili in record con riferimento != denuncia
        select distinct ci,dal, 'P05183' errore
             , ' - per CI: '||ci||' '||' ( riferimento '||substr(riferimento,3,4)||' )' precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and nvl(imponibile,0) != 0 
          and substr(riferimento,3,4) != P_anno
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
        union
-- segnalazione per Codice Comune non Codificato        
        select distinct ci,dal, 'P01088' errore
             , ' per CI: '||ci precisazione
          from denuncia_emens deie
         where anno = P_anno and  mese = P_mese 
          and lpad(nvl(codice_catasto,'0'),4,'0') = lpad('0',4,'0')
          and ( P_tipo = 'T' or P_tipo = 'S' and ci = P_ci )
      order by 1,2
;
CURSOR CUR_VAR_EMENS 
      ( P_ci        number
      , P_anno      number
      , P_mese      number
      , P_dal       date
      ) is
    select to_char(riferimento,'yyyy')        anno_rif
         , min(riferimento)                   dal_rif
         , max(riferimento)                   al_rif
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'VARIABILI', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'VARIABILI', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'VARIABILI', nvl(esvc.arrotonda,0.01)
                                          , '')),1) importo
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('VARIABILI')
       and vacm.anno            = P_anno
       and vacm.mese            = P_mese
       and vacm.ci              = P_ci
       and P_dal = ( select min(dal) from denuncia_emens
                      where anno = P_anno
                        and mese = P_mese
                        and ci   = P_ci
                        and rilevanza = 'C'
                        and riferimento = lpad(P_mese,2,'0')||P_anno
                   )
       and to_char(vacm.riferimento,'yyyy') < P_anno
       and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    group by to_char(riferimento,'yyyy') 
    having round( sum(vacm.valore*decode( vacm.colonna
                                        , 'VARIABILI', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'VARIABILI', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'VARIABILI', nvl(esvc.arrotonda,0.01)
                                          , '')),1) != 0
;
CURSOR CUR_DATIP_EMENS 
      ( P_ci        number
      , P_anno      number
      , P_mese      number
      , P_dal       date
      , P_al        date
      ) is
select esvc.colonna
              , min(to_date('01'||to_char(riferimento,'mmyyyy'),'ddmmyyyy'))  dal
              , max(riferimento)                                              al
              , round( sum(vacm.valore*decode( vacm.colonna
                                            , 'PREAVVISO', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'PREAVVISO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'PREAVVISO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)                           preavviso
              , round( sum(vacm.valore*decode( vacm.colonna
                                            , 'BONUS', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'BONUS', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'BONUS', nvl(esvc.arrotonda,0.01)
                                          , '')),1)                           bonus
              , round( sum(vacm.valore*decode( vacm.colonna
                                            , 'ESTERO', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'ESTERO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'ESTERO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)                           estero
              , round( sum(vacm.valore*decode( vacm.colonna
                                            , 'ATIPICA', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'ATIPICA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'ATIPICA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)                           atipica
              , round( sum(vacm.valore*decode( vacm.colonna
                                            , 'SINDACALI', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'SINDACALI', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'SINDACALI', nvl(esvc.arrotonda,0.01)
                                          , '')),1)                           sindacali
	     from valori_contabili_mensili    vacm
              , estrazione_valori_contabili esvc
	    where vacm.estrazione = 'DENUNCIA_EMENS'
		and vacm.colonna in ('PREAVVISO', 'BONUS', 'ESTERO', 'ATIPICA', 'SINDACALI')
            and vacm.anno            = P_anno
            and vacm.mese            = P_mese
            and vacm.ci              = P_ci
            and vacm.riferimento between P_dal and P_al
            and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
            and nvl(vacm.valore,0) != 0
            and esvc.estrazione     = vacm.estrazione
            and esvc.colonna        = vacm.colonna
           group by esvc.colonna
         having  round( sum(vacm.valore*decode( vacm.colonna
                                            , 'PREAVVISO', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'PREAVVISO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'PREAVVISO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
              + round( sum(vacm.valore*decode( vacm.colonna
                                            , 'BONUS', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'BONUS', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'BONUS', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
              + round( sum(vacm.valore*decode( vacm.colonna
                                            , 'ESTERO', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'ESTERO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'ESTERO', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
              + round( sum(vacm.valore*decode( vacm.colonna
                                            , 'ATIPICA', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'ATIPICA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'ATIPICA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
              + round( sum(vacm.valore*decode( vacm.colonna
                                            , 'SINDACALI', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'SINDACALI', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'SINDACALI', nvl(esvc.arrotonda,0.01)
                                          , '')),1)  != 0
;
CURSOR CUR_FONDI_EMENS
      ( P_tipo      varchar2
      , P_ci        number
      , P_anno      number
      , P_mese      number
      , P_posizione varchar2
      , P_gestione  varchar2
      , P_fascia    varchar2
      ) is
    select null                               anno_rif
         , to_date(null)                      dal_rif
         , to_date(null)                      al_rif
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'FONDI_ANTE95', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95', nvl(esvc.arrotonda,0.01)
                                            , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95', nvl(esvc.arrotonda,0.01)
                                            , '')),1) importo
         , to_number(null)                    importo_arr
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('FONDI_ANTE95')
       and vacm.anno            = P_anno
       and vacm.mese            = P_mese
       and vacm.ci              = P_ci
       and exists   (select 'x' 
                       from periodi_retributivi pere
                          , posizioni posi
                      where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                        and competenza in ('P','C','A')
                        and servizio   in ('Q','I','N')
                        and ci              = vacm.ci
                        and pere.posizione like P_posizione 
                        and gestione       like P_gestione
                        and pere.gestione   in (select codice
                                                  from gestioni
                                                 where nvl(fascia,'%') like P_fascia)
                        and pere.posizione  = posi.codice
                        and pere.trattamento not in ( 'R96' , 'RI96')
                        and pere.ci = P_ci
                      )
       and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    having round( sum(vacm.valore*decode( vacm.colonna
                                        , 'FONDI_ANTE95', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95', nvl(esvc.arrotonda,0.01)
                                            , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95', nvl(esvc.arrotonda,0.01)
                                            , '')),1) != 0
    union
    select to_char(riferimento,'yyyy')        anno_rif
         , min(riferimento)                   dal_rif
         , max(riferimento)                   al_rif
         , to_number(null)                    importo
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'FONDI_ANTE95_ARR', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95_ARR', nvl(esvc.arrotonda,0.01)
                                            , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95_ARR', nvl(esvc.arrotonda,0.01)
                                            , '')),1) importo_arr
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('FONDI_ANTE95_ARR')
       and vacm.anno            = P_anno
       and vacm.mese            = P_mese
       and vacm.ci              = P_ci
       and to_char(vacm.riferimento,'yyyy') < P_anno
       and exists   (select 'x' 
                       from periodi_retributivi pere
                          , posizioni posi
                      where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                        and competenza in ('P','C','A')
                        and servizio   in ('Q','I','N')
                        and ci              = vacm.ci
                        and pere.posizione like P_posizione
                        and gestione       like P_gestione 
                        and pere.gestione   in (select codice
                                                  from gestioni
                                                 where nvl(fascia,'%') like P_fascia)
                        and pere.posizione  = posi.codice
                        and pere.trattamento not in ( 'R96' , 'RI96')
                        and pere.ci = P_ci
                      )
       and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    group by to_char(riferimento,'yyyy') 
    having round( sum(vacm.valore*decode( vacm.colonna
                                        , 'FONDI_ANTE95_ARR', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95_ARR', nvl(esvc.arrotonda,0.01)
                                            , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'FONDI_ANTE95_ARR', nvl(esvc.arrotonda,0.01)
                                            , '')),1) != 0
;
PROCEDURE ACCORPA_EMENS 
      ( P_CI in number
      , P_ANNO in number
      , P_MESE in number 
      , P_sfasato in varchar2
      );
PROCEDURE ACCORPA_EMENS_UGUALI
      ( P_CI in number
      , P_ANNO in number
      , P_MESE in number 
      , D_ANNO_DEN in number
      , D_MESE_DEN in number 
      , P_sfasato in varchar2
      );
END;
/
CREATE OR REPLACE PACKAGE BODY CURSORE_EMENS IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V3.3 del 11/09/2007';
 END VERSIONE;

PROCEDURE ACCORPA_EMENS 
( P_CI in number
, P_ANNO in number
, P_MESE in number 
, P_sfasato in varchar2
) IS
BEGIN
DECLARE
P_CONTA               number := 0;
P_RILEVANZA           VARCHAR2(1);
P_GESTIONE            VARCHAR2(8);
P_GESTIONE_ALT        VARCHAR2(8);
P_RIFERIMENTO         VARCHAR2(6);
P_SPECIE_RAPPORTO     VARCHAR2(4);
P_QUALIFICA1          VARCHAR2(1);
P_QUALIFICA2          VARCHAR2(1);
P_QUALIFICA3          VARCHAR2(1);
P_TIPO_CONTRIBUZIONE  VARCHAR2(2);
P_CODICE_CONTRATTO    VARCHAR2(3);
P_GIORNO_ASSUNZIONE   NUMBER(2);
P_TIPO_ASSUNZIONE     VARCHAR2(2);
P_TAB_ANF             VARCHAR2(3);
P_NUM_ANF             NUMBER(2);
P_CLASSE_ANF          NUMBER(3);
P_TIPO_RAPPORTO       VARCHAR2(2);
P_COD_ATTIVITA        VARCHAR2(2);
P_ALTRA_ASS           VARCHAR2(3);
P_TIPO_AGEVOLAZIONE   VARCHAR2(2);
P_IMPONIBILE          NUMBER(11,2);
P_RITENUTA            NUMBER(11,2);
P_CONTRIBUTO          NUMBER(11,2);
P_ALIQUOTA            NUMBER(5,2);
P_GIORNI_RETRIBUITI   NUMBER(2);
P_SETTIMANE_UTILI     NUMBER(5,2);
P_TFR                 NUMBER(11,2);
P_IMP_AGEVOLAZIONE    NUMBER(11,2);
P_DAL                 DATE;
P_AL                  DATE;
P_ID                  NUMBER(10);
P_DEL_ID              NUMBER(10);

BEGIN
FOR CUR_PERIODI IN (
select DEIE_ID, DAL, AL , RILEVANZA, GESTIONE, GESTIONE_ALTERNATIVA
     , RIFERIMENTO, SPECIE_RAPPORTO, QUALIFICA1
     , QUALIFICA2, QUALIFICA3, TIPO_CONTRIBUZIONE, CODICE_CONTRATTO
     , GIORNO_ASSUNZIONE, TIPO_ASSUNZIONE, GIORNO_CESSAZIONE, TIPO_CESSAZIONE
     , TAB_ANF, NUM_ANF, CLASSE_ANF, TIPO_RAPPORTO, COD_ATTIVITA, ALTRA_ASS
     , TIPO_AGEVOLAZIONE, IMP_AGEVOLAZIONE
     , IMPONIBILE, RITENUTA, CONTRIBUTO, ALIQUOTA, GIORNI_RETRIBUITI, SETTIMANE_UTILI, TFR
  FROM DENUNCIA_EMENS
 WHERE ANNO       = P_ANNO
   AND CI         = P_CI
   AND MESE       = P_MESE
   and ( P_sfasato is null 
      or P_sfasato = 'X' and to_char(dal,'mmyyyy') != lpad(P_mese,2,'0')||lpad(P_anno,4,'0') 
       )
 order by 1,2
 ) LOOP
-- dbms_output.put_line(' CI: '||P_ci||' - '||cur_periodi.dal||' - '||cur_periodi.al);
 P_conta := nvl(P_conta,0) + 1;
 BEGIN
   IF P_conta = 1 
   THEN
-- memorizzo i dati per confronto
-- dbms_output.put_line('memorizzo i dati per confronto');
      P_RILEVANZA          := CUR_PERIODI.rilevanza;
      P_GESTIONE           := CUR_PERIODI.gestione;
      P_GESTIONE_ALT       := CUR_PERIODI.gestione_alternativa;
      P_RIFERIMENTO        := CUR_PERIODI.riferimento;
      P_SPECIE_RAPPORTO    := CUR_PERIODI.specie_rapporto;
      P_QUALIFICA1         := CUR_PERIODI.qualifica1;
      P_QUALIFICA2         := CUR_PERIODI.qualifica2;
      P_QUALIFICA3         := CUR_PERIODI.qualifica3;
      P_TIPO_CONTRIBUZIONE := CUR_PERIODI.tipo_contribuzione;
      P_CODICE_CONTRATTO   := CUR_PERIODI.codice_contratto;
      P_TAB_ANF            := CUR_PERIODI.tab_anf;
      P_NUM_ANF            := CUR_PERIODI.num_anf;
      P_CLASSE_ANF         := CUR_PERIODI.classe_anf;
      P_TIPO_RAPPORTO      := CUR_PERIODI.tipo_rapporto;
      P_COD_ATTIVITA       := CUR_PERIODI.cod_attivita;
      P_ALTRA_ASS          := CUR_PERIODI.altra_ass;
      P_TIPO_AGEVOLAZIONE  := CUR_PERIODI.tipo_agevolazione;
      P_IMPONIBILE         := CUR_PERIODI.imponibile;
      P_RITENUTA           := CUR_PERIODI.ritenuta;
      P_CONTRIBUTO         := CUR_PERIODI.contributo;
      P_ALIQUOTA           := CUR_PERIODI.aliquota;
      P_GIORNI_RETRIBUITI  := CUR_PERIODI.giorni_retribuiti;
      P_SETTIMANE_UTILI    := CUR_PERIODI.settimane_utili;
      P_TFR                := CUR_PERIODI.tfr;
      P_IMP_AGEVOLAZIONE   := CUR_PERIODI.imp_agevolazione;
      P_DAL                := CUR_PERIODI.dal;
      P_ID                 := CUR_PERIODI.deie_id;
      P_AL                 := CUR_PERIODI.al;
-- memorizzo eventualmente la prima assunzione
      P_GIORNO_ASSUNZIONE  := CUR_PERIODI.giorno_assunzione;
      P_TIPO_ASSUNZIONE    := CUR_PERIODI.tipo_assunzione;
    ELSIF
            nvl(P_RILEVANZA,'C')        = nvl(CUR_PERIODI.rilevanza,'C')
        and P_GESTIONE                  = CUR_PERIODI.gestione
        and nvl(P_GESTIONE_ALT ,' ')    = nvl(CUR_PERIODI.gestione_alternativa,' ')
        and nvl(P_RIFERIMENTO,' ')      = nvl(CUR_PERIODI.riferimento,' ')
        and P_SPECIE_RAPPORTO           = CUR_PERIODI.specie_rapporto
        and nvl(P_QUALIFICA1,' ')       = nvl(CUR_PERIODI.qualifica1,' ')
        and nvl(P_QUALIFICA2,' ')       = nvl(CUR_PERIODI.qualifica2,' ')
        and nvl(P_QUALIFICA3,' ')       = nvl(CUR_PERIODI.qualifica3,' ')
        and nvl(P_TIPO_CONTRIBUZIONE,' ') = nvl(CUR_PERIODI.tipo_contribuzione,' ')
        and nvl(P_CODICE_CONTRATTO,' ') = nvl(CUR_PERIODI.codice_contratto,' ')
        and nvl(P_TAB_ANF,' ')          = nvl(CUR_PERIODI.tab_anf,' ')
        and nvl(P_NUM_ANF,0)            = nvl(CUR_PERIODI.num_anf,0)
        and nvl(P_CLASSE_ANF,0)         = nvl(CUR_PERIODI.classe_anf,0)
        and nvl(P_TIPO_RAPPORTO,' ')    = nvl(CUR_PERIODI.tipo_rapporto,' ')
        and nvl(P_COD_ATTIVITA,' ')     = nvl(CUR_PERIODI.cod_attivita,' ')
        and nvl(P_ALTRA_ASS,' ')        = nvl(CUR_PERIODI.altra_ass,' ')
        and nvl(P_TIPO_AGEVOLAZIONE,' ') = nvl(CUR_PERIODI.tipo_agevolazione,' ')
        and nvl(P_ALIQUOTA,0)           = nvl(CUR_PERIODI.aliquota,0)
        AND CUR_PERIODI.dal             > P_al
        and ( to_char(P_al,'MMYYYY')      = to_char(CUR_PERIODI.AL,'MMYYYY')    
           or P_sfasato = 'X' and to_char(P_al,'MMYYYY') = to_char(add_months(CUR_PERIODI.AL,-1),'MMYYYY') )
       THEN -- se sono uguali e sono consecutivi anche NON contigui memorizzo i dati per accorpamento
-- dbms_output.put_line(' uguali e sono consecutivi ');
               P_IMPONIBILE         := nvl(P_IMPONIBILE,0) + NVL(CUR_PERIODI.imponibile,0);
               P_RITENUTA           := nvl(P_RITENUTA,0) + NVL(CUR_PERIODI.ritenuta,0);
               P_CONTRIBUTO         := nvl(P_CONTRIBUTO,0) + NVL(CUR_PERIODI.contributo,0);
               P_GIORNI_RETRIBUITI  := nvl(P_GIORNI_RETRIBUITI,0) + nvl(CUR_PERIODI.giorni_retribuiti,0);
               P_SETTIMANE_UTILI    := nvl(P_SETTIMANE_UTILI,0) + nvl(CUR_PERIODI.settimane_utili,0);
               P_TFR                := nvl(P_TFR,0) + nvl(CUR_PERIODI.tfr,0);
               P_IMP_AGEVOLAZIONE   := nvl(P_IMP_AGEVOLAZIONE,0) + nvl(CUR_PERIODI.imp_agevolazione,0);
               P_del_id             := CUR_PERIODI.deie_id;

             update denuncia_emens 
                 set al                = CUR_PERIODI.al
                   , deie_id           = P_id
                   , imponibile        = decode(P_imponibile,0,null,P_imponibile)
                   , ritenuta          = decode(P_ritenuta,0,null,P_ritenuta)
                   , contributo        = decode(P_contributo,0,null,P_contributo)
                   , giorni_retribuiti = least(decode(P_giorni_retribuiti,0,null,P_giorni_retribuiti),99)
                   , settimane_utili   = decode(P_settimane_utili,0,null,P_settimane_utili)
                   , tfr               = decode(P_tfr,0,null,P_tfr)
                   , imp_agevolazione  = decode(P_imp_agevolazione,0,null,P_imp_agevolazione)
                   , tipo_assunzione   = P_TIPO_ASSUNZIONE
                   , giorno_assunzione = P_GIORNO_ASSUNZIONE
                   , tipo_cessazione   = CUR_PERIODI.tipo_cessazione
                   , giorno_cessazione = CUR_PERIODI.giorno_cessazione
              where deie_id   = P_id
             ;
-- dbms_output.put_line('UPDATE CI: '||SQL%ROWCOUNT);
             update settimane_emens
                set dal_emens = P_dal
                  , deie_id   = P_id
              where deie_id   = P_del_id
             ;
-- dbms_output.put_line('UPDATE CI: '||SQL%ROWCOUNT);
             delete from denuncia_emens 
              where deie_id   = P_del_id
             ;
-- dbms_output.put_line('DELETE CI: '||SQL%ROWCOUNT);
             P_al := CUR_PERIODI.al;
             commit;

        ELSE 
-- dbms_output.put_line('memorizzo i dati per un successivo confronto');
-- memorizzo i dati per un successivo confronto
          P_RILEVANZA          := CUR_PERIODI.rilevanza;
          P_GESTIONE           := CUR_PERIODI.gestione;
          P_GESTIONE_ALT       := CUR_PERIODI.gestione_alternativa;
          P_RIFERIMENTO        := CUR_PERIODI.riferimento;
          P_SPECIE_RAPPORTO    := CUR_PERIODI.specie_rapporto;
          P_QUALIFICA1         := CUR_PERIODI.qualifica1;
          P_QUALIFICA2         := CUR_PERIODI.qualifica2;
          P_QUALIFICA3         := CUR_PERIODI.qualifica3;
          P_TIPO_CONTRIBUZIONE := CUR_PERIODI.tipo_contribuzione;
          P_CODICE_CONTRATTO   := CUR_PERIODI.codice_contratto;
          P_TAB_ANF            := CUR_PERIODI.tab_anf;
          P_NUM_ANF            := CUR_PERIODI.num_anf;
          P_CLASSE_ANF         := CUR_PERIODI.classe_anf;
          P_TIPO_RAPPORTO      := CUR_PERIODI.tipo_rapporto;
          P_COD_ATTIVITA       := CUR_PERIODI.cod_attivita;
          P_ALTRA_ASS          := CUR_PERIODI.altra_ass;
          P_TIPO_AGEVOLAZIONE  := CUR_PERIODI.tipo_agevolazione;
          P_IMPONIBILE         := CUR_PERIODI.imponibile;
          P_RITENUTA           := CUR_PERIODI.ritenuta;
          P_CONTRIBUTO         := CUR_PERIODI.contributo;
          P_ALIQUOTA           := CUR_PERIODI.aliquota;
          P_GIORNI_RETRIBUITI  := CUR_PERIODI.giorni_retribuiti;
          P_SETTIMANE_UTILI    := CUR_PERIODI.settimane_utili;
          P_TFR                := CUR_PERIODI.tfr;
          P_IMP_AGEVOLAZIONE   := CUR_PERIODI.imp_agevolazione;
          P_DAL              := CUR_PERIODI.dal; 
          P_ID               := CUR_PERIODI.deie_id; 
          P_AL               := CUR_PERIODI.al;
          P_GIORNO_ASSUNZIONE  := CUR_PERIODI.giorno_assunzione;
          P_TIPO_ASSUNZIONE    := CUR_PERIODI.tipo_assunzione;
-- memorizzo eventualmente l'ultima cessazione
        END IF;
 END;
END LOOP; -- CUR_PERIODI 
END;
END ACCORPA_EMENS;

PROCEDURE ACCORPA_EMENS_UGUALI
      ( P_CI in number
      , P_ANNO in number
      , P_MESE in number 
      , D_ANNO_DEN in number
      , D_MESE_DEN in number 
      , P_sfasato in varchar2
      ) IS
BEGIN
DECLARE
P_GIORNO_CESSAZIONE   NUMBER(2);
P_TIPO_CESSAZIONE     VARCHAR2(2);
P_IMPONIBILE          NUMBER(11,2);
P_RITENUTA            NUMBER(11,2);
P_CONTRIBUTO          NUMBER(11,2);
P_GIORNI_RETRIBUITI   NUMBER(2);
P_SETTIMANE_UTILI     NUMBER(5,2);
P_TFR                 NUMBER(11,2);
P_MAX_DAL             DATE;
P_MAX_AL              DATE;
V_controllo           varchar2(1);
P_CONTA               number := 0;

BEGIN
-- dbms_output.put_line('seconda');
FOR CUR_DATI1 IN (
select DEIE_ID, DAL, AL , RILEVANZA, GESTIONE, GESTIONE_ALTERNATIVA, RIFERIMENTO, QUALIFICA1
     , QUALIFICA2, QUALIFICA3, TIPO_CONTRIBUZIONE, CODICE_CONTRATTO
  FROM DENUNCIA_EMENS
 WHERE ANNO       = P_ANNO
   AND CI         = P_CI
   AND MESE       = P_MESE
   and ( P_sfasato is null 
      or P_sfasato = 'X' and to_char(dal,'mmyyyy') != lpad(P_mese,2,'0')||lpad(P_anno,4,'0')  
       )
 order by 1,2
 ) LOOP
-- dbms_output.put_line(' CI: '||P_ci||' - '||cur_dati1.dal||' - '||cur_dati1.al);
   P_IMPONIBILE := 0;
   P_RITENUTA   := 0;
   P_CONTRIBUTO := 0;
   P_GIORNI_RETRIBUITI :=0;
   P_SETTIMANE_UTILI := 0;
   P_TFR := 0;
   BEGIN
   select 'S' 
     into V_controllo
     from dual
    where exists ( select 'x' from denuncia_emens
                    where ci = P_ci
                      and ANNO = P_anno
                      and mese = P_mese
                      and nvl(rilevanza,' ') = nvl(CUR_DATI1.rilevanza,' ')
                      and gestione = CUR_DATI1.gestione
                      and nvl(gestione_alternativa,' ') = nvl(CUR_DATI1.gestione_alternativa,' ')
                      and nvl(qualifica1,' ') = nvl(CUR_DATI1.qualifica1,' ')
                      and nvl(qualifica2,' ') = nvl(CUR_DATI1.qualifica2,' ')
                      and nvl(qualifica3,' ') = nvl(CUR_DATI1.qualifica3,' ')
                      and nvl(tipo_contribuzione,' ') = nvl(CUR_DATI1.tipo_contribuzione,' ')
                      and nvl(codice_contratto,' ') = nvl(CUR_DATI1.codice_contratto,' ')
                      and nvl(riferimento,' ') = nvl(CUR_DATI1.riferimento,' ')
                      and dal < CUR_DATI1.dal 
                 );
   EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := 'N';
   END;
-- dbms_output.put_line('Controllo: '||V_controllo);
    IF V_controllo = 'N' THEN
     BEGIN
     select sum(imponibile), sum(ritenuta), sum(contributo), sum(giorni_retribuiti), sum(settimane_utili), sum(tfr)
       into P_IMPONIBILE, P_RITENUTA, P_CONTRIBUTO, P_GIORNI_RETRIBUITI, P_SETTIMANE_UTILI, P_TFR
       from denuncia_emens
      where ci = P_ci
        and ANNO = P_anno
        and mese = P_mese
        and nvl(rilevanza,' ') = nvl(CUR_DATI1.rilevanza,' ')
        and gestione = CUR_DATI1.gestione
        and nvl(gestione_alternativa,' ') = nvl(CUR_DATI1.gestione_alternativa,' ')
        and nvl(qualifica1,' ') = nvl(CUR_DATI1.qualifica1,' ')
        and nvl(qualifica2,' ') = nvl(CUR_DATI1.qualifica2,' ')
        and nvl(qualifica3,' ') = nvl(CUR_DATI1.qualifica3,' ')
        and nvl(tipo_contribuzione,' ') = nvl(CUR_DATI1.tipo_contribuzione,' ')
        and nvl(codice_contratto,' ') = nvl(CUR_DATI1.codice_contratto,' ')
        and nvl(riferimento,' ') = nvl(CUR_DATI1.riferimento,' ')
        and dal > CUR_DATI1.dal 
        and ( P_sfasato is null 
           or P_sfasato = 'X' and to_char(dal,'mmyyyy') != lpad(P_mese,2,'0')||lpad(P_anno,4,'0') 
            )
      ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
-- dbms_output.put_line('no data found1');
         P_IMPONIBILE := 0;
         P_RITENUTA := 0;
         P_CONTRIBUTO := 0;
         P_GIORNI_RETRIBUITI :=0;
         P_SETTIMANE_UTILI := 0;
         P_TFR := 0;
     END;
-- dbms_output.put_line('ipn: '||P_IMPONIBILE);
  IF ( nvl(P_IMPONIBILE,0) + nvl(P_RITENUTA,0) + nvl(P_CONTRIBUTO,0) 
   +  nvl(P_GIORNI_RETRIBUITI,0) + nvl(P_SETTIMANE_UTILI,0) + nvl(P_TFR,0) ) != 0 THEN
-- dbms_output.put_line('estraggo1');
     BEGIN
     select max(al)
       into P_max_al
       from denuncia_emens
      where ci = P_ci
        and ANNO = P_anno
        and mese = P_mese
        and nvl(rilevanza,' ') = nvl(CUR_DATI1.rilevanza,' ')
        and gestione = CUR_DATI1.gestione
        and nvl(gestione_alternativa,' ') = nvl(CUR_DATI1.gestione_alternativa,' ')
        and nvl(qualifica1,' ') = nvl(CUR_DATI1.qualifica1,' ')
        and nvl(qualifica2,' ') = nvl(CUR_DATI1.qualifica2,' ')
        and nvl(qualifica3,' ') = nvl(CUR_DATI1.qualifica3,' ')
        and nvl(tipo_contribuzione,' ') = nvl(CUR_DATI1.tipo_contribuzione,' ')
        and nvl(codice_contratto,' ') = nvl(CUR_DATI1.codice_contratto,' ')
        and nvl(riferimento,' ') = nvl(CUR_DATI1.riferimento,' ')
        and ( P_sfasato is null 
           or P_sfasato = 'X'  and to_char(dal,'mmyyyy') != lpad(P_mese,2,'0')||lpad(P_anno,4,'0') 
            )
      ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        select last_day(decode(P_sfasato
                              ,'X',to_date(lpad(D_mese_den,2,'0')||D_anno_den,'mmyyyy')
                                  ,to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy')))
          into P_max_al from dual;
     END;

     BEGIN
     select max(dal)
       into P_max_dal
       from denuncia_emens
      where ci = P_ci
        and ANNO = P_anno
        and mese = P_mese
        and nvl(rilevanza,' ') = nvl(CUR_DATI1.rilevanza,' ')
        and gestione = CUR_DATI1.gestione
        and nvl(gestione_alternativa,' ') = nvl(CUR_DATI1.gestione_alternativa,' ')
        and nvl(qualifica1,' ') = nvl(CUR_DATI1.qualifica1,' ')
        and nvl(qualifica2,' ') = nvl(CUR_DATI1.qualifica2,' ')
        and nvl(qualifica3,' ') = nvl(CUR_DATI1.qualifica3,' ')
        and nvl(tipo_contribuzione,' ') = nvl(CUR_DATI1.tipo_contribuzione,' ')
        and nvl(codice_contratto,' ') = nvl(CUR_DATI1.codice_contratto,' ')
        and nvl(riferimento,' ') = nvl(CUR_DATI1.riferimento,' ')
        and ( P_sfasato is null 
           or P_sfasato = 'X' and to_char(dal,'mmyyyy') != lpad(P_mese,2,'0')||lpad(P_anno,4,'0')
            )
      ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
-- dbms_output.put_line('no data found dal');
        select decode(P_sfasato
                     ,'X',to_date('01'||lpad(D_mese_den,2,'0')||D_anno_den,'ddmmyyyy')
                         ,to_date('01'||lpad(P_mese,2,'0')||P_anno,'ddmmyyyy'))
          into P_max_dal from dual;
     END;
-- dbms_output.put_line('max dal/al: '||P_max_dal||' '||P_max_al);
     BEGIN 
     select tipo_cessazione, giorno_cessazione
       into P_tipo_cessazione, P_giorno_cessazione
       from denuncia_emens
      where ci = P_ci
        and ANNO = P_anno
        and mese = P_mese
        and nvl(rilevanza,' ') = nvl(CUR_DATI1.rilevanza,' ')
        and gestione = CUR_DATI1.gestione
        and nvl(gestione_alternativa,' ') = nvl(CUR_DATI1.gestione_alternativa,' ')
        and nvl(qualifica1,' ') = nvl(CUR_DATI1.qualifica1,' ')
        and nvl(qualifica2,' ') = nvl(CUR_DATI1.qualifica2,' ')
        and nvl(qualifica3,' ') = nvl(CUR_DATI1.qualifica3,' ')
        and nvl(tipo_contribuzione,' ') = nvl(CUR_DATI1.tipo_contribuzione,' ')
        and nvl(codice_contratto,' ') = nvl(CUR_DATI1.codice_contratto,' ')
        and nvl(riferimento,' ') = nvl(CUR_DATI1.riferimento,' ')
        and dal = P_max_dal and al = P_max_al
      ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
         P_tipo_cessazione  := null;
         P_giorno_cessazione  := null;
     END;
     P_conta := 0;
       FOR CUR_DATI2 IN 
       ( select distinct dal,al, riferimento, deie_id
           from denuncia_emens
          where ci = P_ci
            and ANNO = P_anno
            and mese = P_mese
            and nvl(rilevanza,' ') = nvl(CUR_DATI1.rilevanza,' ')
            and gestione = CUR_DATI1.gestione
            and nvl(gestione_alternativa,' ') = nvl(CUR_DATI1.gestione_alternativa,' ')
            and nvl(qualifica1,' ') = nvl(CUR_DATI1.qualifica1,' ')
            and nvl(qualifica2,' ') = nvl(CUR_DATI1.qualifica2,' ')
            and nvl(qualifica3,' ') = nvl(CUR_DATI1.qualifica3,' ')
            and nvl(tipo_contribuzione,' ') = nvl(CUR_DATI1.tipo_contribuzione,' ')
            and nvl(codice_contratto,' ') = nvl(CUR_DATI1.codice_contratto,' ')
            and nvl(riferimento,' ') = nvl(CUR_DATI1.riferimento,' ')
            and dal > CUR_DATI1.DAL
            and ( P_sfasato is null
               or P_sfasato = 'X' and to_char(dal,'mmyyyy') != lpad(P_mese,2,'0')||lpad(P_anno,4,'0')
                )
       ) LOOP
-- dbms_output.put_line(' due: '||P_ci||' - '||cur_dati2.dal||' - '||cur_dati2.al);
      P_conta := nvl(P_conta,0) + 1;
      IF P_conta = 1 THEN
         update denuncia_emens 
            set al               = P_max_al
              , imponibile        = nvl(imponibile,0) + nvl(P_imponibile,0)
              , ritenuta          = nvl(ritenuta,0) + nvl(P_ritenuta,0)
              , contributo        = nvl(contributo,0) + nvl(P_contributo,0)
              , giorni_retribuiti = least ( nvl(giorni_retribuiti,0) + nvl(P_giorni_retribuiti,0),99)
              , settimane_utili   = nvl(settimane_utili,0) + nvl(P_settimane_utili,0)
              , tfr               = decode( nvl(tfr,0) + nvl(P_tfr,0), 0, null, nvl(tfr,0) + nvl(P_tfr,0) )
              , tipo_cessazione   = P_tipo_cessazione
              , giorno_cessazione = P_giorno_cessazione
          where anno      = P_anno
            and mese      = P_mese
            and ci        = P_CI
            and dal       = CUR_DATI1.DAL
            and deie_id   = CUR_DATI1.deie_id
            and riferimento = CUR_DATI1.riferimento;
      END IF;

      update settimane_emens
         set dal_emens = CUR_DATI1.dal
           , deie_id   = CUR_DATI1.deie_id
       where deie_id   = CUR_DATI2.deie_id;

      delete from denuncia_emens deie 
       where deie_id   = CUR_DATI2.deie_id;
      commit;
-- dbms_output.put_line('UPDATE CI: '||cur_dati2.dal);
      END LOOP; --cur_dati2
     END IF; --controllo importi
    END IF; -- V_controllo
  END LOOP; -- CUR_dati1
END;
END ACCORPA_EMENS_UGUALI;

END cursore_emens;
/
