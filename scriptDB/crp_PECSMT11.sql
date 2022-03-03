CREATE OR REPLACE PACKAGE PECSMT11 IS
/******************************************************************************
 NOME:          PECSMT11
 DESCRIZIONE:   Archiviazione in APST delle assenze ( Per Statistiche Ministero )
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  06/04/2006 MS     Prima Emissione ( att. 15597 )
 1.1  06/04/2006 MS     Adeguamento Normativo ( att. 15597 )
 1.2  10/04/2007 MS     Esclusione delle assenze con conto annuale = 0 ( A20442 )
 2.0  15/11/2007 CB     A20817
 2.1  11/06/2007 MS     Mod. controlli per categoria SUPAN ( att. 21575 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (VERSIONE , WNDS, WNPS);

FUNCTION GET_GIORNI ( P_al date, P_dal date, P_gg_cont number ) RETURN NUMBER;
PRAGMA RESTRICT_REFERENCES (GET_GIORNI , WNDS);

 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMT11 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 10/04/2007';
END VERSIONE;

FUNCTION GET_GIORNI ( P_al date, P_dal date, P_gg_cont number ) RETURN NUMBER IS
  D_giorno    NUMBER := 1;
  D_gg_fine   NUMBER := 31;
  D_gg_lav    NUMBER := 0;
  D_gg_lav_tot  NUMBER := 0;
BEGIN
    FOR CUR_CALE IN 
     ( select anno
            , mese 
            , last_day( to_date('01'||lpad(mese,2,'0')||anno,'ddmmyyyy')) fin_mes 
         from calendari
        where to_date('01'||lpad(mese,2,'0')||anno,'ddmmyyyy')
              between to_date( '01'||to_char(P_dal,'mmyyyy'),'ddmmyyyy')
                  and last_day(P_al)
          and calendario = '*'
        order by anno, mese
     ) LOOP
        BEGIN
        select decode(lpad(CUR_CALE.mese,2,'0')||CUR_CALE.anno
                      , to_char(P_al,'mmyyyy'), to_char(P_al,'dd') 
                                              , to_char(CUR_CALE.fin_mes,'dd')
                     )
             , decode(lpad(CUR_CALE.mese,2,'0')||CUR_CALE.anno
                     , to_char(P_dal,'mmyyyy'), to_char(P_dal,'dd') 
                                              , 1
                     )
          into D_gg_fine
             , D_giorno
          from dual;
        END;

       WHILE D_giorno <= D_gg_fine LOOP

        BEGIN --Estrazione del giorno da Calendario
          select decode( substr(giorni,D_giorno,1)
                       , 'F', 0
                       , 'D', 0
                       , 'd', 0
                       , 'S', 0
                       , 's', decode( P_gg_cont, 6, 1, 0 )
                            , 1
                       ) 
            into D_gg_lav
            from calendari
           where calendario = '*'
             and anno = CUR_CALE.anno
             and mese = CUR_CALE.mese
           ;
        EXCEPTION 
             WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                  D_gg_lav := 0 ;
        END;
      
        D_giorno := nvl(D_giorno,0) + 1 ;
        D_gg_lav_tot := nvl(D_gg_lav_tot,0) + D_gg_lav;

       END LOOP;
    END LOOP ; -- cur_cale
 RETURN D_gg_lav_tot;
END GET_GIORNI;

 PROCEDURE MAIN (prenotazione in number, passo in number) IS

BEGIN
DECLARE

  P_anno       number(4);
  P_comparto   varchar2(10);
  P_ini_a      date;
  P_fin_a      date;
  P_gestione   varchar2(4);
  P_data_da    date;
  P_data_a     date;

  D_riga       number := 0;

BEGIN
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
    select substr(valore,1,10)  D_comparto
      into P_comparto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_COMPARTO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
      P_gestione := '%';
  END;
  BEGIN
    select nvl(P_data_da, to_date ('0101'||nvl(P_anno,anno),'ddmmyyyy') ) 
         , nvl(P_data_a, to_date ('3112'||nvl(P_anno,anno),'ddmmyyyy') )                               
         , nvl(P_anno,anno)                                  
      into P_ini_a
         , P_fin_a
         , P_anno
      from riferimento_fine_anno
     where rifa_id = 'RIFA'
    ;
  END;
   BEGIN
    FOR CUR_GEST in  -- q_gest
      ( select codice
          from gestioni gest
         where codice like P_gestione
           and exists (select 'x' 
                        from periodi_giuridici pegi_a
                       where pegi_a.rilevanza = 'A'
                         and pegi_a.dal        <= P_fin_a
                         and nvl(pegi_a.al,to_date('3333333','j')) >= P_ini_a
                         and exists (select 'x' from smt_periodi
                                      where ci        = pegi_a.ci
                                        and pegi_a.dal between dal and nvl(al,to_date('3333333','j'))
                                        and gestione  = gest.codice
                                     )
                       union
                       select 'x' 
                         from eventi_presenza evpa
                        where  evpa.dal        <= P_fin_a
                          and nvl(evpa.al,to_date('3333333','j')) >= P_ini_a
                          and exists (select 'x' 
                                        from causali_evento
                                       where codice = evpa.causale and qualificazione = 'A'
                                     )
                          and exists (select 'x' 
                                        from smt_periodi
                                       where ci        = evpa.ci
                                         and evpa.dal between dal and nvl(al,to_date('3333333','j'))
                                         and gestione  = gest.codice
                                    )
                      )
      ) LOOP
      BEGIN
      FOR CUR_QUMI in -- Q_QUMI
        ( select codice
            from qualifiche_ministeriali
           where P_fin_a between dal and nvl(al,to_date('3333333','j'))
             and nvl(comparto,'%') like nvl(P_comparto,'%')
            order by sequenza
        ) LOOP
        BEGIN
        FOR CUR_ASTE in 
        ( select count(distinct decode(smin.sesso,'M',smpe.ci,0))
                              - decode(min(smin.sesso),'F',1,0)                      pegi_m
               , count(distinct decode(smin.sesso,'F',smpe.ci,0))
                              - decode(max(smin.sesso),'M',1,0)                      pegi_f
               , round( sum(decode(smin.sesso
                                   ,'M', ( get_giorni( least( nvl(smpe.al,to_date('3333333','j'))
                                                            , nvl(pegi.al,to_date('3333333','j'))
                                                            , P_fin_a 
                                                            )
                                                     , greatest( smpe.dal
                                                               , pegi.dal
                                                               , P_ini_a 
                                                               )
                                                     , nvl(cost.ore_lavoro,36) / nvl(cost.ore_gg,1)
                                                     ) 
                                          )/100*decode(posi.part_time
                                                           ,'SI', round(nvl(pegi_s.ore,cost.ore_lavoro)/cost.ore_lavoro,2)*100
                                                                , 100
                                                           )
                                       , 0)),2)                                                gg_m
               , round(sum(decode(smin.sesso
                                 ,'F',( get_giorni ( least( nvl(smpe.al,to_date('3333333','j'))
                                                          , nvl(pegi.al,to_date('3333333','j'))
                                                          , P_fin_a
                                                          )
                                                   , greatest( smpe.dal
                                                             , pegi.dal
                                                             , P_ini_a 
                                                             )
                                                   , nvl(cost.ore_lavoro,36) / nvl(cost.ore_gg,1)
                                                   )
                                        ) /100*decode(posi.part_time
                                                         , 'SI', round(nvl(pegi_s.ore,cost.ore_lavoro)/cost.ore_lavoro,2)*100
                                                                , 100
                                                         )
                                     , 0)),2)                                        gg_f
              , nvl(pgco.rv_low_value,evgi.codice)                                   cod_evgi
              , max(nvl(pgco.rv_meaning,evgi.descrizione))                           des_evgi
           from eventi_giuridici             evgi
              , contratti_storici            cost
              , pgm_ref_codes                pgco
              , smt_individui                smin
              , smt_periodi                  smpe
              , periodi_giuridici            pegi
              , periodi_giuridici            pegi_s
              , rapporti_giuridici           ragi
              , posizioni                    posi
              , qualifiche_giuridiche        qugi
           where pgco.rv_domain (+) = 'EVENTI_GIURIDICI.CONTO_ANNUALE'
             and pgco.rv_low_value (+) = nvl(evgi.conto_annuale,9)
             and nvl(evgi.conto_annuale,9) != 0
             and pegi.ci            = smpe.ci
             and pegi_s.ci          = smpe.ci
             and ragi.ci            = smpe.ci
             and evgi.codice       (+)    = nvl(pegi.evento,' ')
             and pegi.dal           <= least(nvl(smpe.al,to_date('3333333','j')), P_fin_a)
             and nvl(pegi.al,to_date('3333333','j')) >= greatest(smpe.dal,P_ini_a)
             and smpe.dal             <= P_fin_a
             and nvl(smpe.al,to_date('3333333','j')) >= P_ini_a
             and cost.contratto (+) = qugi.contratto
             and qugi.numero  = pegi_s.qualifica
             and nvl(pegi_s.al, to_date('3333333','j'))  between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
             and nvl(pegi_s.al, to_date('3333333','j'))  between cost.dal and nvl(cost.al,to_date('3333333','j'))
             and smin.ci            = smpe.ci
             and smin.anno          = smpe.anno
             and smin.gestione      = smpe.gestione
             and smpe.gestione      like CUR_GEST.codice
             and smpe.qualifica     = CUR_QUMI.codice
             and ( smpe.TEMPO_DETERMINATO='NO' or smpe.categoria in ('DIREL','DIRSAN','SUPAN') )
             and nvl(smpe.universitario,'NO') ='NO'
             and nvl(smin.est_comandato,'NO') ='NO'
             and smin.anno          = P_anno 
             and pegi.rilevanza     = 'A'
             and pegi_s.rilevanza   = 'S'
             and pegi_s.posizione   = posi.codice (+)
             and nvl(pegi.al,to_date('3333333','j')) between nvl(pegi_s.dal,to_date('2222222','j')) 
                                                         and nvl(pegi_s.al,to_date('3333333','j'))
           group by nvl(pgco.rv_low_value,evgi.codice)
          having nvl(sum(decode(smin.sesso,'M',1,0)),0) != 0
              or nvl(sum(decode(smin.sesso,'F',1,0)),0) != 0
          union
          select count(distinct decode(smin.sesso,'M',smpe.ci,0))
                              - decode(min(smin.sesso),'F',1,0)                      pegi_m
               , count(distinct decode(smin.sesso,'F',smpe.ci,0))
                              - decode(max(smin.sesso),'M',1,0)                      pegi_f
               , round(sum(decode(smin.sesso
                          ,'M', decode( caev.gestione
                                       , 'O', round(round(evpa.valore / 60, 2) 
                                                   /decode(nvl(cost.ore_gg,1)
                                                          ,0, 1, nvl(cost.ore_gg,1)
                                                          )
                                                    )
                                       , 'H', round(round(evpa.valore / 60, 2)
                                                   /decode(nvl(cost.ore_gg,1)
                                                          ,0, 1, nvl(cost.ore_gg,1)
                                                          )
                                                   )
                                            , ( get_giorni ( least( nvl(smpe.al,to_date('3333333','j'))
                                                                  , nvl(nvl(evpa.al,trunc(sysdate)),to_date('3333333','j'))
                                                                  , P_fin_a
                                                                  ) 
                                                           , greatest( smpe.dal
                                                                     , evpa.dal
                                                                     , P_ini_a
                                                                     ) 
                                                           , nvl(cost.ore_lavoro,36) / nvl(cost.ore_gg,1)
                                                           ) 
                                             )/100*decode(posi.part_time
                                                              ,'SI' ,round(nvl(pegi_s.ore,cost.ore_lavoro)/cost.ore_lavoro,2)*100
                                                                    ,100
                                                              )
                                      )
                              , 0)),2)                                                gg_m
               , round(sum(decode(smin.sesso
                           ,'F',decode( caev.gestione
                                       , 'O', round(round(evpa.valore / 60, 2) 
                                                   /decode(nvl(cost.ore_gg,1)
                                                          ,0, 1, nvl(cost.ore_gg,1)
                                                          )
                                                    )
                                       , 'H', round(round(evpa.valore / 60, 2)
                                                   /decode(nvl(cost.ore_gg,1)
                                                          ,0, 1, nvl(cost.ore_gg,1)
                                                          )
                                                   )
                                            , ( get_giorni ( least( nvl(smpe.al,to_date('3333333','j'))
                                                                  , nvl(nvl(evpa.al,trunc(sysdate)),to_date('3333333','j'))
                                                                  , P_fin_a
                                                                  ) 
                                                           , greatest( smpe.dal
                                                                     , evpa.dal
                                                                     , P_ini_a
                                                                     ) 
                                                           , nvl(cost.ore_lavoro,36) / nvl(cost.ore_gg,1)
                                                           ) 
                                             )/100*decode(posi.part_time
                                                              ,'SI' ,round(nvl(pegi_s.ore,cost.ore_lavoro)/cost.ore_lavoro,2)*100
                                                                    ,100
                                                              )
                                      )
                              , 0)),2)                                                gg_f
               , nvl(pgco.rv_low_value,nvl(pgc1.rv_low_value,nvl(evgi.codice,caev.codice)))               cod_evgi
               , max(nvl(pgco.rv_meaning,nvl(pgc1.rv_meaning,nvl(evgi.descrizione,caev.descrizione))))    des_evgi
            from eventi_giuridici             evgi
               , contratti_storici            cost
               , causali_evento               caev
               , pgm_ref_codes                pgco
               , pgm_ref_codes                pgc1
               , smt_individui                smin
               , smt_periodi                  smpe
               , eventi_presenza              evpa
               , astensioni                   aste
               , rapporti_giuridici           ragi
               , periodi_giuridici            pegi_s
               , posizioni                    posi
               , qualifiche_giuridiche qugi
           where pgco.rv_domain (+)    = 'EVENTI_GIURIDICI.CONTO_ANNUALE'
             and pgc1.rv_domain (+)    = 'EVENTI_GIURIDICI.CONTO_ANNUALE'
             and pgco.rv_low_value (+) = nvl(evgi.conto_annuale,9)
             and pgc1.rv_low_value (+) = nvl(caev.conto_annuale,9)
             and nvl(evgi.conto_annuale,9) != 0
             and nvl(caev.conto_annuale,9) != 0
             and evpa.ci               = smpe.ci
             and ragi.ci               = smpe.ci
             and pegi_s.ci             = smpe.ci
             and evgi.codice       (+) = nvl(aste.evento,' ')
             and caev.codice       (+) = nvl(evpa.causale,' ')
             and evpa.causale          = caev.codice
             and caev.qualificazione   = 'A'
             and caev.assenza          = aste.codice (+)
             and (   caev.riferimento  = 'M'
                  or caev.riferimento  = 'G'
                 and not exists ( select 'x'
                                    from periodi_giuridici 
                                   where ci = evpa.ci
                                     and rilevanza = 'A'
                                     and nvl(al,trunc(sysdate)) >= evpa.dal
                                     and dal             <= nvl(evpa.al,trunc(sysdate))
                                ) 
                 )
             and evpa.dal <= least(nvl(smpe.al,to_date('3333333','j')) , P_fin_a)
             and nvl(nvl(evpa.al,trunc(sysdate)),to_date('3333333','j')) >= greatest(smpe.dal,P_ini_a)
             and smpe.dal             <= P_fin_a
             and nvl(smpe.al,to_date('3333333','j')) >= P_ini_a
             and nvl(evpa.al,to_date('3333333','j')) between nvl(pegi_s.dal,to_date('2222222','j'))
                                                         and nvl(pegi_s.al,to_date('3333333','j'))
             and cost.contratto (+)    = qugi.contratto
             and qugi.numero           = pegi_s.qualifica
             and nvl(pegi_s.al, to_date('3333333','j'))  between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
             and nvl(pegi_s.al, to_date('3333333','j'))  between cost.dal and nvl(cost.al,to_date('3333333','j'))
             and smpe.gestione      like CUR_GEST.codice
             and smpe.qualifica        = CUR_QUMI.codice
             and smin.ci               = smpe.ci
             and smin.anno             = smpe.anno
             and smin.gestione=smpe.gestione 
             and (smpe.TEMPO_DETERMINATO='NO' or smpe.categoria in ('DIREL','DIRSAN','SUPAN'))
             and nvl(smpe.universitario,'NO') ='NO'
             and nvl(smin.est_comandato,'NO') ='NO'
             and smin.anno             = P_anno 
             and pegi_s.rilevanza      = 'S'
             and pegi_s.posizione      = posi.codice (+)
           group by nvl(pgco.rv_low_value,nvl(pgc1.rv_low_value,nvl(evgi.codice,caev.codice)))
          having nvl(sum(decode(smin.sesso,'M',1,0)),0) != 0
              or nvl(sum(decode(smin.sesso,'F',1,0)),0) != 0
           order by 5
       ) LOOP
         D_riga := nvl(D_riga,0) + 1;
         BEGIN
            insert into a_appoggio_stampe
            ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
            select prenotazione
                 , 1
                 , 1
                 , D_riga
                 , rpad(CUR_GEST.codice,8,' ')
                 ||rpad(CUR_QUMI.codice,8,' ')
                 ||lpad(nvl(CUR_ASTE.pegi_m,0),8,'0')
                 ||lpad(nvl(CUR_ASTE.pegi_f,0),8,'0')
                 ||decode( nvl(CUR_ASTE.gg_m,0)
                         ,-1, lpad('0',8,'0')
                            , lpad(nvl(trunc(nvl(CUR_ASTE.gg_m,0))||rpad( lpad( ( nvl(CUR_ASTE.gg_m,0) - trunc( nvl(CUR_ASTE.gg_m,0) ) ) * 100,2,'0') ,2,'0'),'0')
                                  ,8,'0')
                         )
                 ||decode( nvl(CUR_ASTE.gg_f,0)
                         ,-1, lpad('0',8,'0')
                            , lpad(nvl(trunc(nvl(CUR_ASTE.gg_f,0))||rpad( lpad( ( nvl(CUR_ASTE.gg_f,0) - trunc( nvl(CUR_ASTE.gg_f,0) ) ) * 100,2,'0') ,2,'0'),'0')
                                  ,8,'0')
                         )
                 ||rpad(nvl(CUR_ASTE.cod_evgi,' '),8,' ')
                 ||rpad(nvl(CUR_ASTE.des_evgi,' '),120,' ')
                 ||'X' -- eof
              from dual
            ;
            commit;
         END;
       END LOOP; -- CUR_ASTE
       END;
      END LOOP; -- CUR_QUMI
      END;
    END LOOP; -- CUR_GEST
   END;
 END;
END;
END;
/
