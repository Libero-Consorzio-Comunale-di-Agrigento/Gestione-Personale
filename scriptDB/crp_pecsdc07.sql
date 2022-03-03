CREATE OR REPLACE PACKAGE PECSDC07 IS
/******************************************************************************
 NOME:        PECSDC07
 DESCRIZIONE: STAMPA DIFFERENZE CONTRIBUTI SU CUMULO.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    17/09/2007   NN   Prima emissione
******************************************************************************/
FUNCTION  VERSIONE                RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSDC07 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1 del 17/09/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
declare
  D_anno_liq                  number;
  D_dettaglio                 varchar2(1);
  D_progressivo               number := 0;
  D_anno_old                  number := 0;
  D_tot_diff                  number := 0;

BEGIN
  BEGIN
    select valore
      into D_anno_liq
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_ANNO_LIQ';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select valore
      into D_dettaglio
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_DETTAGLIO';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;

  BEGIN
  delete from temp_cc07_ipn_rit;
  END;
  BEGIN
  delete from temp_cc07_cng;
  END;

  COMMIT;

-- INSERISCE VOCI DI IMPONIBILE E RITENUTA LIQUIDATE A PARTIRE DALL'ANNO RICHIESTO NELLA TABELLA TEMP_CC07_IPN_RIT

-- determina le voci di imponibile da trattare
  FOR CUR_VOCI in 
     (select imvo.voce
           , to_char(min(imvo.dal),'yyyy') anno_dal
        from IMPONIBILI_VOCE imvo
       where imvo.cassa_competenza = 'SI'
       group by imvo.voce
     ) LOOP

    FOR CUR_ANNI in
       (select distinct anno 
          from CALENDARI
         where anno >= nvl(D_anno_liq,cur_voci.anno_dal)
       ) LOOP

dbms_output.put_line ('VOCE '||cur_voci.voce||' ANNO '||cur_anni.anno);

      FOR CUR_CI in
         (select distinct ci 
            from MOVIMENTI_FISCALI mofi
           where anno = cur_anni.anno
             and mensilita not like '%*%'
         ) LOOP

    BEGIN -- estrae le voci di imponibile aggregate per cassa/ competenza
    insert into TEMP_CC07_IPN_RIT
    (CI
    ,ANNO_LIQ
    ,ANNO_RIF
    ,ANNO_COMP
    ,VOCE
    ,SUB
    ,IPN_MOCO
    ,IPN_MOCO_AP 
    ,TIPO
    )
    select cur_ci.ci ci
         , cur_anni.anno
         , to_char(moco.riferimento,'yyyy') anno_rif
         , least( to_char(moco.riferimento,'yyyy')
                , to_char(nvl(moco.competenza,moco.riferimento),'yyyy')  
                ) anno_comp
         , cur_voci.voce
         , '*'
         , sum(moco.imp) ipn_moco
         , sum(moco.ipn_p) ipn_moco_ap
         , 'I'
      from MOVIMENTI_CONTABILI moco
     WHERE moco.voce    = cur_voci.voce
       AND moco.sub     = '*'
       AND moco.ci      = cur_ci.ci
       AND moco.anno    = cur_anni.anno
       AND least( to_char(riferimento,'yyyy')
                , to_char(nvl(competenza,riferimento),'yyyy')  
                )      >= cur_voci.anno_dal
       AND least( to_char(riferimento,'yyyy')
                , to_char(nvl(competenza,riferimento),'yyyy')  
                )      >= cur_anni.anno
       AND exists (select 'x' from MOVIMENTI_CONTABILI
                        where ci = moco.ci
                          and ANNO = cur_anni.anno
                          and (VOCE,SUB) in
                              (select voce, sub
                                 from RITENUTE_VOCE rivo
                                where cod_voce_ipn  = cur_voci.voce
                                  and sub_voce_ipn = '*'
                                  and to_date('0101'||cur_anni.anno,'ddmmyyyy') 
                                      between nvl(dal,to_date('2222222','j'))
                                          and nvl(al,to_date('3333333','j'))
                                  and exists 
                                    (select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                                      where (   rivo.voce = contr_voce and rivo.sub = contr_sub
                                             or rivo.voce = rit_voce and rivo.sub = rit_sub
                                            )
                                    )
                              )
                      )
     group by to_char(riferimento,'yyyy') 
            , least( to_char(riferimento,'yyyy')
                   , to_char(nvl(competenza,riferimento),'yyyy')  
                   ) 
    ;
    END;

        FOR CUR_RIT in
           (select voce
                 , sub
              from RITENUTE_VOCE rivo
             where cod_voce_ipn = cur_voci.voce
               and sub_voce_ipn = '*'
               and to_date(cur_anni.anno,'yyyy') between nvl(dal,to_date('2222222','j'))
                                                     and nvl(al,to_date('3333333','j'))
               and exists (select 'x' from DEF_ISTITUTI_PREVIDENZIALI
                            where (   rivo.voce = contr_voce and rivo.sub = contr_sub
                                   or rivo.voce = rit_voce and rivo.sub = rit_sub
                                  )
                          )
             order by voce,sub,dal
           ) LOOP

              BEGIN -- estrae le voci di ritenuta aggregate per cassa / competenza
              insert into TEMP_CC07_IPN_RIT
              (CI
              ,ANNO_LIQ
              ,ANNO_RIF
              ,ANNO_COMP
              ,VOCE
              ,SUB
              ,IPN_MOCO
              ,IPN_MOCO_AP 
              ,RIT_MOCO
              ,RIT_MOCO_AP
              ,VOCE_IPN
              ,SUB_IPN
              ,TIPO
              )
              select cur_ci.ci ci
                   , cur_anni.anno
                   , to_char(moco.riferimento,'yyyy') anno_rif
                   , least( to_char(moco.riferimento,'yyyy')
                          , to_char(nvl(moco.competenza,moco.riferimento),'yyyy')  
                          ) anno_comp 
                   , cur_rit.voce
                   , cur_rit.sub
-- non tratta la tariffa delle voci caricate dalla fase di assestamento sub 1-2 x cumulo
--                   , sum(moco.tar*decode(sede_del,'X',0,'Y',0,1)) ipn_moco
                   , sum(moco.tar) ipn_moco
                   , sum(moco.ipn_eap) ipn_moco_ap
                   , sum(moco.imp) rit_moco
                   , sum(moco.ipn_p) rit_moco_ap
                   , cur_voci.voce
                   , '*'
                   , 'R'
                from MOVIMENTI_CONTABILI moco
               WHERE moco.voce    = cur_rit.voce
                 AND moco.sub     = cur_rit.sub
                 AND moco.ci      = cur_ci.ci
                 AND moco.anno    = cur_anni.anno
                 AND least( to_char(riferimento,'yyyy')
                          , to_char(nvl(competenza,riferimento),'yyyy')  
                          )      >= cur_voci.anno_dal
                 AND least( to_char(riferimento,'yyyy')
                          , to_char(nvl(competenza,riferimento),'yyyy')  
                          )      >= cur_anni.anno
               group by to_char(riferimento,'yyyy') 
                      , least( to_char(riferimento,'yyyy')
                             , to_char(nvl(competenza,riferimento),'yyyy')  
                             ) 
              ;
              END;

        END LOOP; -- cur_rit

      END LOOP; -- cur_ci

    END LOOP; -- cur_anni

  END LOOP; -- cur_voci

BEGIN

-- ORIZZONTALIZZA LE VOCI DI IMPONIBILE E RITENUTA NELLA TABELLA TEMP_CC07_CNG

declare
  d_IPN number;
  d_IPN_AP number;
  d_IPN_RIT number;
  d_IPN_RIT_AP number;
  d_RIT number;
  d_RIT_AP number;

    BEGIN
      FOR CUR_CI_ANNI in 
        ( select distinct ci
               , anno_rif
            from TEMP_CC07_IPN_RIT
        ) LOOP

          FOR CUR_CI_VOCI in
            ( select distinct voce,sub,voce_ipn,sub_ipn
                from TEMP_CC07_IPN_RIT
               where ci       = cur_ci_anni.ci
                 and anno_rif = cur_ci_anni.anno_rif
                 and tipo     = 'R'
             ) LOOP

               d_IPN := 0;
               d_IPN_AP := 0;
               d_IPN_RIT := 0;
               d_IPN_RIT_AP := 0;
               d_RIT := 0;
               d_RIT_AP := 0;

               BEGIN
                 select sum(temp_r.ipn_moco) IPN_RIT                
                      , sum(temp_r.ipn_moco_ap) IPN_RIT_AP             
                      , sum(temp_r.rit_moco) RIT                    
                      , sum(temp_r.rit_moco_ap) RIT_AP
                   into d_IPN_RIT
                      , d_IPN_RIT_AP
                      , d_RIT
                      , d_RIT_AP
                   from TEMP_CC07_IPN_RIT temp_r
                  where temp_r.ci = cur_ci_anni.ci
                    and temp_r.anno_rif = cur_ci_anni.anno_rif
                    and temp_r.tipo = 'R'
                    and temp_r.voce = cur_ci_voci.voce
                    and temp_r.sub  = cur_ci_voci.sub
                    and temp_r.voce_ipn = cur_ci_voci.voce_ipn
                    and temp_r.sub_ipn  = cur_ci_voci.sub_ipn
               ;
               END;
               BEGIN
                 select sum(temp_i.IPN_moco)                    
                      , sum(temp_i.IPN_MOCO_AP)
                   into d_IPN
                      , d_IPN_AP
                   from TEMP_CC07_IPN_RIT temp_i
                  where temp_i.ci = cur_ci_anni.ci
                    and temp_i.anno_rif = cur_ci_anni.anno_rif
                    and temp_i.tipo = 'I'
                    and temp_i.voce = cur_ci_voci.voce_ipn
                    and temp_i.sub  = cur_ci_voci.sub_ipn
                 ;
               END;
               BEGIN
                 insert into TEMP_CC07_CNG
                 (CI
                 ,ANNO_RIF               
                 ,VOCE_IPN               
                 ,SUB_IPN                
                 ,IPN                    
                 ,IPN_AP                 
                 ,VOCE_RIT               
                 ,SUB_RIT                
                 ,IPN_RIT                
                 ,IPN_RIT_AP             
                 ,RIT                    
                 ,RIT_AP
                 )
                 values 
                 (cur_ci_anni.ci
                 ,cur_ci_anni.anno_rif
                 ,cur_ci_voci.voce_ipn
                 ,cur_ci_voci.sub_ipn
                 ,d_IPN
                 ,d_IPN_AP
                 ,cur_ci_voci.voce
                 ,cur_ci_voci.sub
                 ,d_IPN_RIT                
                 ,d_IPN_RIT_AP             
                 ,d_RIT                    
                 ,d_RIT_AP
                 )
                 ;
               END;
 
          END LOOP; -- cur_ci_voci

      END LOOP; --  cur_ci_anni

END;
END;

BEGIN    -- Memorizza dati di dizionario
  update TEMP_CC07_CNG x
     set (alq,lim_inf) = 
         (select per_rit_ac,lim_inf
            from RITENUTE_VOCE
           where voce = x.voce_rit
             and sub = x.sub_rit
             and to_date(x.anno_rif,'yyyy') between nvl(dal,to_date('2222222','j'))
                                                and nvl(al,to_date('3333333','j'))
         )
  ;
END;

BEGIN    -- Genera la stampa
  
  BEGIN     -- Stampa Totali Voci Imponibile e Ritenuta

     D_anno_old  := 0;

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,1,D_progressivo,
             lpad(' ',40,' ')||'TOTALI VOCI IMPONIBILE E RITENUTA'
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,1,D_progressivo,
             lpad(' ',40,' ')||'---------------------------------'
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,1,D_progressivo,
             lpad(' ',40,' ')
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,1,D_progressivo,
             lpad(' ',40,' ')
            );
                  
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,1,D_progressivo,
             'ANNO RIF.'||' '||
             rpad('VOCE',10,' ')||' '||
             rpad('DESCRIZIONE',34,' ')||' '||
             rpad('IPN RIT',11,' ')||' '||
             rpad('IPN RIT AP',11,' ')||' '||
             rpad('RITEN.',11,' ')||' '||
             rpad('RITEN. AP',11,' ')||' '||
             rpad('IMPONIB.',11,' ')||' '||
             rpad('IMPONIB.AP',11,' ')
            );

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,1,D_progressivo,
             '---------'||' '||
             '----------'||' '||
             rpad('-',34,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')
            ); 

     FOR CUR_VOCI IN
        (select anno_rif
              , voce
              , sub
              , max(substr(voec.oggetto,1,34)) oggetto
              , sum(decode(tcir.tipo,'R',nvl(ipn_moco,0),0)) ipn_rit
              , sum(decode(tcir.tipo,'R',nvl(ipn_moco_ap,0),0)) ipn_rit_ap
              , sum(nvl(rit_moco,0)) rit_moco
              , sum(nvl(rit_moco_ap,0)) rit_moco_ap
              , sum(decode(tcir.tipo,'I',nvl(ipn_moco,0),0)) ipn
              , sum(decode(tcir.tipo,'I',nvl(ipn_moco_ap,0),0)) ipn_ap
           from TEMP_CC07_IPN_RIT tcir
              , VOCI_ECONOMICHE voec
          where tcir.voce = voec.codice
       group by anno_rif, voce, sub
         ) LOOP 
           IF cur_voci.anno_rif != D_anno_old and D_anno_old != 0 THEN
              D_progressivo := D_progressivo + 1;
                insert into a_appoggio_stampe
                       (no_prenotazione,no_passo,pagina,riga,testo)
                values (prenotazione,1,1,D_progressivo,
                        lpad(' ',40,' ')
                       );
           END IF;
             BEGIN
               D_progressivo := D_progressivo + 1;
                 insert into a_appoggio_stampe
                        (no_prenotazione,no_passo,pagina,riga,testo)
                 values (prenotazione,1,1,D_progressivo,
                         rpad(to_char(cur_voci.anno_rif),9,' ')||' '||
                         rpad(cur_voci.voce||'/'||cur_voci.sub,10,' ')||' '||
                         rpad(cur_voci.oggetto,34,' ')||
                         lpad(to_char(cur_voci.ipn_rit,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci.ipn_rit_ap,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci.rit_moco,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci.rit_moco_ap,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci.ipn,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci.ipn_ap,'99999999.00'),12,' ')
                        );
              D_anno_old := cur_voci.anno_rif;
             END;
     END LOOP;

  END;         -- Stampa Totali Voci Imponibile e Ritenuta

  BEGIN        -- Stampa Dipendenti squadrati sui totali x anno di riferimento SENZA sub 2

     D_tot_diff := 0;

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             lpad(' ',20,' ')||'DIPENDENTI SQUADRATI SUI TOTALI PER ANNO RIFERIMENTO SENZA SCAGLIONE AGGIUNTIVO'
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             lpad(' ',20,' ')||'-------------------------------------------------------------------------------'
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             lpad(' ',40,' ')
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             lpad(' ',40,' ')
            );
                  
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             rpad('INDIVIDUO',50,' ')||' '||
             'LIQ.'||' '||
             'RIF.'||' '||
             'COMP'||' '||
             rpad('VOCE IPN',10,' ')||' '||
             rpad('IMPON.',11,' ')||' '||
             rpad('VOCE RIT',10,' ')||' '||
             rpad('IPN RIT',11,' ')||' '||
             rpad('DIFFERENZA',11,' ')
            );

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             rpad('-',50,'-')||' '||
             '----'||' '||
             '----'||' '||
             '----'||' '||
             rpad('-',10,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',10,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')
            ); 

     FOR CUR_VOCI_LIQ IN
        (select ci
              , max(rpad(substr(rtrim(cognome)||' '||nome,1,40),40,' ')) nome
              , anno_rif
              , voce_ipn
              , sub_ipn
              , sum(nvl(ipn,0)) ipn
              , voce_rit
              , sub_rit
              , sum(nvl(ipn_rit,0)) ipn_rit
              , sum(nvl(IPN,0) - nvl(IPN_RIT,0)) * -1 diff
           from TEMP_CC07_CNG tccn
              , ANAGRAFICI anag
          where lim_inf is null
            and ni = (select max(ni)
                        from RAPPORTI_INDIVIDUALI rain
                       where rain.ci = tccn.ci)
            and trunc(sysdate) between anag.dal and nvl(anag.al,to_date(3333333,'j'))
       group by ci, anno_rif, voce_ipn, sub_ipn, voce_rit, sub_rit
         having abs(sum(nvl(ipn,0) - nvl(ipn_rit,0))) != 0
         ) LOOP 
             BEGIN
               D_progressivo := D_progressivo + 1;
                 insert into a_appoggio_stampe
                        (no_prenotazione,no_passo,pagina,riga,testo)
                 values (prenotazione,1,3,D_progressivo,
                         rpad(to_char(cur_voci_liq.ci),8,' ')||' '||
                         lpad(cur_voci_liq.nome,40,' ')||'  '||
                         rpad(' ',4,' ')||' '||
                         rpad(to_char(cur_voci_liq.anno_rif),4,' ')||' '||
                         rpad(' ',4,' ')||' '||
                         rpad(cur_voci_liq.voce_ipn||'/'||cur_voci_liq.sub_ipn,10,' ')||
                         lpad(to_char(cur_voci_liq.ipn,'99999999.00'),12,' ')||' '||
                         rpad(cur_voci_liq.voce_rit||'/'||cur_voci_liq.sub_rit,10,' ')||
                         lpad(to_char(cur_voci_liq.ipn_rit,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci_liq.diff,'99999999.00'),12,' ')
                        );
               D_tot_diff := D_tot_diff + cur_voci_liq.diff;
             END;
             IF nvl(D_dettaglio,' ') = 'X' THEN
                FOR CUR_VOCI_DET IN
                   (select anno_liq
                         , anno_comp
                         , nvl(ipn_moco,0) + nvl(ipn_moco_ap,0) ipn_moco
                      from TEMP_CC07_IPN_RIT tcir
                     where ci       = cur_voci_liq.ci
                       and anno_rif = cur_voci_liq.anno_rif
                       and voce     = cur_voci_liq.voce_rit
                       and sub      = cur_voci_liq.sub_rit
                       and voce_ipn = cur_voci_liq.voce_ipn
                       and sub_ipn  = cur_voci_liq.sub_ipn
                       and tipo     = 'R'
                     order by anno_liq, anno_comp
                   ) LOOP 
                       BEGIN
                         D_progressivo := D_progressivo + 1;
                           insert into a_appoggio_stampe
                                  (no_prenotazione,no_passo,pagina,riga,testo)
                           values (prenotazione,1,3,D_progressivo,
                                   rpad(' ',8,' ')||' '||
                                   lpad(' ',40,' ')||'  '||
                                   rpad(to_char(cur_voci_det.anno_liq),4,' ')||' '||
                                   rpad(to_char(cur_voci_liq.anno_rif),4,' ')||' '||
                                   rpad(to_char(cur_voci_det.anno_comp),4,' ')||' '||
                                   rpad(' ',10,' ')||
                                   lpad(' ',12,' ')||' '||
                                   rpad(' ',10,' ')||
                                   lpad(to_char(cur_voci_det.ipn_moco,'99999999.00'),12,' ')||
                                   lpad(' ',12,' ')
                                  );
                       END;
                     END LOOP;
                BEGIN
                  D_progressivo := D_progressivo + 1;
                    insert into a_appoggio_stampe
                           (no_prenotazione,no_passo,pagina,riga,testo)
                    values (prenotazione,1,3,D_progressivo,
                            rpad(' ',8,' ')||' '||
                            rpad(' ',40,' ')||'  '||
                            rpad(' ',4,' ')||' '||
                            rpad(' ',4,' ')||' '||
                            rpad(' ',4,' ')||' '||
                            rpad(' ',10,' ')||
                            rpad(' ',12,' ')||' '||
                            rpad(' ',10,' ')||
                            rpad(' ',12,' ')||
                            rpad(' ',12,' ')
                           );
                END;
             END IF;
     END LOOP;

     BEGIN      -- Stampa totali
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             rpad(' ',49)||' '||
             rpad(' ',4)||' '||
             rpad(' ',4)||' '||
             rpad(' ',4)||' '||
             rpad(' ',10)||' '||
             rpad(' ',11)||' '||
             rpad(' ',10)||' '||
             rpad(' ',12)||' '||
             rpad('-',11,'-')
            ); 

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,3,D_progressivo,
             rpad(' ',50)||
             rpad(' ',5)||
             rpad(' ',5)||
             rpad(' ',5)||
             rpad(' ',11)||
             rpad(' ',12)||
             rpad(' ',11)||
             rpad(' ',12)||
             lpad(to_char(D_tot_diff,'99999999.00'),12,' ')
            );
     END;      -- Stampa totali

  END;         -- Stampa Dipendenti squadrati sui totali x anno di riferimento SENZA sub 2

  BEGIN        -- Stampa Dipendenti squadrati sui totali x anno di riferimento SOLO sub 2)

     D_tot_diff := 0;

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             lpad(' ',20,' ')||'DIPENDENTI SQUADRATI SUI TOTALI PER ANNO RIFERIMENTO SOLO SCAGLIONE AGGIUNTIVO'
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             lpad(' ',20,' ')||'------------------------------------------------------------------------------'
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             lpad(' ',40,' ')
            );
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             lpad(' ',40,' ')
            );

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             rpad('INDIVIDUO',30,' ')||' '||
             'LIQ.'||' '||
             'RIF.'||' '||
             'COMP'||' '||
             rpad('VOCE IPN',10,' ')||' '||
             rpad('IMPON.',11,' ')||' '||
             rpad('SCAGLIONE',11,' ')||' '||
             rpad('ECCEDENZA',11,' ')||' '||
             rpad('VOCE RIT',10,' ')||' '||
             rpad('IPN RIT',11,' ')||' '||
             rpad('DIFFERENZA',11,' ')
            );

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             rpad('-',30,'-')||' '||
             '----'||' '||
             '----'||' '||
             '----'||' '||
             rpad('-',10,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',10,'-')||' '||
             rpad('-',11,'-')||' '||
             rpad('-',11,'-')
            ); 

     FOR CUR_VOCI_DIF IN
        (select ci
              , max(rpad(substr(rtrim(cognome)||' '||nome,1,20),20,' ')) nome
              , anno_rif
              , voce_ipn
              , sub_ipn
              , sum(nvl(ipn,0)) ipn
              , min(nvl(lim_inf,0)) scaglione
              , greatest(0, sum(nvl(ipn,0)) - min(nvl(lim_inf,0))) eccedenza
              , voce_rit
              , sub_rit
              , sum(nvl(ipn_rit,0)) ipn_rit
              , greatest(0, sum(nvl(ipn,0)) - min(nvl(lim_inf,0))) - sum(ipn_rit) * -1 diff
           from TEMP_CC07_CNG tccn
              , ANAGRAFICI anag
          where lim_inf is not null
            and ni = (select max(ni)
                        from RAPPORTI_INDIVIDUALI rain
                       where rain.ci = tccn.ci)
            and trunc(sysdate) between anag.dal and nvl(anag.al,to_date(3333333,'j'))
       group by ci, anno_rif, voce_ipn, sub_ipn, voce_rit, sub_rit
         having abs(sum(nvl(ipn,0)) - min(nvl(lim_inf,0)) - sum(nvl(ipn_rit,0))) != 0
            and (  sum(nvl(ipn,0)) - min(nvl(lim_inf,0)) > 0
                or sum(nvl(ipn_rit,0)) != 0
                )  
         ) LOOP 
             BEGIN
               D_progressivo := D_progressivo + 1;
                 insert into a_appoggio_stampe
                        (no_prenotazione,no_passo,pagina,riga,testo)
                 values (prenotazione,1,4,D_progressivo,
                         rpad(to_char(cur_voci_dif.ci),8,' ')||' '||
                         lpad(cur_voci_dif.nome,20,' ')||'  '||
                         rpad(' ',4,' ')||' '||
                         rpad(to_char(cur_voci_dif.anno_rif),4,' ')||' '||
                         rpad(' ',4,' ')||' '||
                         rpad(cur_voci_dif.voce_ipn||'/'||cur_voci_dif.sub_ipn,10,' ')||
                         lpad(to_char(cur_voci_dif.ipn,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci_dif.scaglione,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci_dif.eccedenza,'99999999.00'),12,' ')||' '||
                         rpad(cur_voci_dif.voce_rit||'/'||cur_voci_dif.sub_rit,10,' ')||
                         lpad(to_char(cur_voci_dif.ipn_rit,'99999999.00'),12,' ')||
                         lpad(to_char(cur_voci_dif.diff,'99999999.00'),12,' ')
                        );
               D_tot_diff := D_tot_diff + cur_voci_dif.diff;
             END;
             IF nvl(D_dettaglio,' ') = 'X' THEN
                FOR CUR_VOCI_DET IN
                   (select anno_liq
                         , anno_comp
                         , nvl(ipn_moco,0) + nvl(ipn_moco_ap,0) ipn_moco
                      from TEMP_CC07_IPN_RIT tcir
                     where ci       = cur_voci_dif.ci
                       and anno_rif = cur_voci_dif.anno_rif
                       and voce     = cur_voci_dif.voce_rit
                       and sub      = cur_voci_dif.sub_rit
                       and voce_ipn = cur_voci_dif.voce_ipn
                       and sub_ipn  = cur_voci_dif.sub_ipn
                       and tipo     = 'R'
                     order by anno_liq, anno_comp
                   ) LOOP 
                       BEGIN
                         D_progressivo := D_progressivo + 1;
                           insert into a_appoggio_stampe
                                  (no_prenotazione,no_passo,pagina,riga,testo)
                           values (prenotazione,1,4,D_progressivo,
                                   rpad(' ',8,' ')||' '||
                                   lpad(' ',20,' ')||'  '||
                                   rpad(to_char(cur_voci_det.anno_liq),4,' ')||' '||
                                   rpad(to_char(cur_voci_dif.anno_rif),4,' ')||' '||
                                   rpad(to_char(cur_voci_det.anno_comp),4,' ')||' '||
                                   rpad(' ',10,' ')||
                                   lpad(' ',12,' ')||
                                   lpad(' ',12,' ')||
                                   lpad(' ',12,' ')||' '||
                                   rpad(' ',10,' ')||
                                   lpad(to_char(cur_voci_det.ipn_moco,'99999999.00'),12,' ')||
                                   lpad(' ',12,' ')
                                  );
                       END;
                     END LOOP;
                BEGIN
                  D_progressivo := D_progressivo + 1;
                    insert into a_appoggio_stampe
                           (no_prenotazione,no_passo,pagina,riga,testo)
                    values (prenotazione,1,4,D_progressivo,
                            rpad(' ',8,' ')||' '||
                            rpad(' ',20,' ')||'  '||
                            rpad(' ',4,' ')||' '||
                            rpad(' ',4,' ')||' '||
                            rpad(' ',4,' ')||' '||
                            rpad(' ',10,' ')||
                            rpad(' ',12,' ')||
                            rpad(' ',12,' ')||
                            rpad(' ',12,' ')||' '||
                            rpad(' ',10,' ')||
                            rpad(' ',12,' ')||
                            rpad(' ',12,' ')
                           );
                END;
             END IF;
     END LOOP;

     BEGIN      -- Stampa totali
     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             rpad(' ',29)||' '||
             rpad(' ',4)||' '||
             rpad(' ',4)||' '||
             rpad(' ',4)||' '||
             rpad(' ',10)||' '||
             rpad(' ',11)||' '||
             rpad(' ',11)||' '||
             rpad(' ',11)||' '||
             rpad(' ',10)||' '||
             rpad(' ',12)||' '||
             rpad('-',11,'-')
            ); 

     D_progressivo := D_progressivo + 1;
     insert into a_appoggio_stampe
            (no_prenotazione,no_passo,pagina,riga,testo)
     values (prenotazione,1,4,D_progressivo,
             rpad(' ',30)||
             rpad(' ',5)||
             rpad(' ',5)||
             rpad(' ',5)||
             rpad(' ',11)||
             rpad(' ',12)||
             rpad(' ',12)||
             rpad(' ',12)||
             rpad(' ',11)||
             rpad(' ',12)||
             lpad(to_char(D_tot_diff,'99999999.00'),12,' ')
            );
     END;      -- Stampa totali

  END;         -- Stampa Dipendenti squadrati sui totali x anno di riferimento SOLO sub 2)

END;

END;
END;
END;
/
