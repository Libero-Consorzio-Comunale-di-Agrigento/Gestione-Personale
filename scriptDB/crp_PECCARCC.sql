CREATE OR REPLACE PACKAGE PECCARCC IS
/******************************************************************************
 NOME:         PECCARCC
 DESCRIZIONE:  Archiviazione per l'imputazione ai Centri di Costo.
               Questa funzione inserisce le registrazioni del periodo richiesto
               nella tabella IMPUTAZIONI_CENTRO_COSTO per il passaggio ...


 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI: Il PARAMETRO D_anno      contiene l'anno da elaborare.
              Il PARAMETRO D_da_mese   contiene l'indicazione del mese da cui elaborare.
              Il PARAMETRO D_a_mese    contiene l'indicazione del mese a cui elaborare.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 1.1  20/09/2004 MS     Mod. per attivita 7274
 1.2  18/07/2005 MS     Mod. per attivita 11916
 1.3  13/06/2006 MS     Mod. relazioni su storicizzazione ESVC
 1.4  19/07/2006 ML     Inseriti i cursori per gestire dei commit, altrimenti non termina (A16952)
 1.5  11/09/2006 MS     Mod. update ( A17444 )
 1.6  12/10/2006 ML     Modificato rapporto della quantità e dell'importo
                        alla percentuale di AASCO (A18024).
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCARCC IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.6 del 12/10/2006';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS

BEGIN
DECLARE

  D_anno       number;
  D_da_mese    number;
  D_a_mese     number;
  D_arretrati  varchar2(1);
  Par_quantita number(12,2);
  Par_valore   number(16,2);
  D_dat_da     varchar2(7);
  D_dat_a      varchar2(7);

BEGIN
   BEGIN                                   -- Preleva Anno di Elaborazione
      select to_number(substr(valore,1,4))
        into D_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          select anno
            into D_anno
            from riferimento_retribuzione
           where rire_id = 'RIRE'
          ;
   END;
   BEGIN                              -- Preleva Mese di inizio Elaborazione
      select to_number(substr(valore,1,2))
        into D_da_mese
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DA_MESE'
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_da_mese := 0;
   END;
   BEGIN                              -- Preleva Mese di fine Elaborazione
      select to_number(substr(valore,1,2))
        into D_a_mese
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_A_MESE'
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_a_mese := 0;
   END;
   BEGIN                              -- Preleva Flag per arretrati
      select substr(valore,1,1)
        into D_arretrati
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ARRETRATI'
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_arretrati := null;
   END;
   BEGIN
     select to_char(last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm') ),'j')   dat_da
          , to_char(last_day(to_date(D_anno||lpad(D_a_mese,2,0),'yyyymm') ),'j')    dat_a
       into D_dat_da, D_dat_a
       from dual;
   END;
   BEGIN  -- Cancellazione eventuali registrazioni dello stesso periodo
      lock table imputazioni_centro_costo in exclusive mode nowait
      ;
      delete from imputazioni_centro_costo
       where causale = 'AP'
         and dat_da  = D_dat_da
         and dat_a   = D_dat_a
--         and anno    = D_anno
      ;
      commit;
   END;
   BEGIN  -- Inserimento registrazioni periodiche

     FOR CUR_CI IN
        (select distinct ci
           from movimenti_fiscali
          where anno = D_anno
            and mese between D_da_mese and D_a_mese
        ) LOOP

            FOR CUR_PERIODI IN
               (select rifu.cdc                              cdc
                     , rtrim( decode( pere.tipo_rapporto
                                    , 'TD', nvl(rtrim(ltrim(qual.fattore_td)),rtrim(ltrim(figu.fattore_td)))
                                          , nvl(rtrim(ltrim(qual.fattore)),rtrim(ltrim(figu.fattore))))
                            , ' ')                           fattore_a
                     , pere.rap_ore                          rap_ore
                     , pere.competenza                       competenza
                     , round(nvl(pere.quota,1)
                            /nvl(pere.intero,1),2)           percentuale
                     , pere.dal
                     , pere.al
                     , pere.periodo
                  from ripartizioni_funzionali rifu
                     , qualifiche              qual
                     , figure                  figu
                     , periodi_retributivi     pere
                 where pere.ci = CUR_CI.ci
                   and pere.periodo between  last_day( to_date( to_char(D_anno)||
                                                       lpad(to_char(nvl(D_da_mese,12)),2,'0')
                                                     , 'yyyymm'))
                                        and  last_day( to_date( to_char(D_anno)||
                                                       lpad(to_char(nvl(D_a_mese,12)),2,'0')
                                                     , 'yyyymm'))
                   and rifu.settore (+) = pere.settore
                   and rifu.sede    (+) = nvl(pere.sede,0)
                   and qual.numero  (+) = pere.qualifica
                   and figu.numero  (+) = pere.figura
                   and pere.contratto   != '*'
                   and pere.gestione    != '*'
                   and pere.trattamento != '*'
               ) LOOP
                   FOR CUR_FATTORI IN
                      (select colonna
                            , sequenza
                            , rtrim(substr(descrizione,1,2),' ') fattore_b
                         from estrazione_valori_contabili
                        where estrazione = 'CDC'
                          and CUR_PERIODI.periodo between dal and nvl(al,to_date('3333333','j'))
                      ) LOOP

         FOR VACM IN
            (select decode( D_arretrati
                          ,'A',decode( to_char(vacm.anno)
                                     , to_char(vacm.riferimento,'yyyy'), vacm.anno
                                                                       , vacm.anno-1
                                     )
                          ,'C',to_char(vacm.riferimento,'yyyy')
                          ,'P',decode( to_char(vacm.anno)
                                     , to_char(vacm.riferimento,'yyyy'), vacm.anno
                                                                       , to_char(vacm.riferimento,'yyyy')
                                     )
                              ,vacm.anno
                          )                             anno
                  , decode( D_arretrati
                          ,'A',decode( to_char(vacm.anno)
                                     , to_char(vacm.riferimento,'yyyy'), decode( D_da_mese
                                                                               , D_a_mese, D_da_mese
                                                                                         , ceil(D_a_mese/3)
                                                                               )
                                                                       , decode( D_da_mese
                                                                               , D_a_mese, 12 -- mensile
                                                                                         , 4  -- trimestrale
                                                                               )
                                     )
                          ,'C',decode( D_da_mese
                                      , D_a_mese, to_char(vacm.riferimento,'mm')
                                                , lpad(ceil(to_char(vacm.riferimento,'mm')/3)
                                                      ,2,'0')
                                     )
                          ,'P',decode( to_char(vacm.anno)
                                     , to_char(vacm.riferimento,'yyyy'), decode( D_da_mese
                                                                                , D_a_mese, to_char(vacm.riferimento,'mm')
                                                                                           , lpad(ceil(to_char(vacm.riferimento,'mm')
                                                                                                      /3)
                                                                                                 ,2,'0')
                                                                                )
                                                                       , decode( D_da_mese
                                                                               , D_a_mese, 12
                                                                                         , 4
                                                                               )
                                     )
                             , decode( D_da_mese
                                     , D_a_mese, D_da_mese
                                               , ceil(D_a_mese/3)
                                     )
                         )                               periodo
                  , sum(decode( cur_fattori.sequenza
                              , 1, vacm.valore
                              , 2, vacm.valore
                              , 3, vacm.valore
                              , 4, vacm.valore
                              , 5, vacm.valore
                                 , 0)
                       )                                 qta
                  , sum(decode( cur_fattori.sequenza
                              , 1, 0
                              , 2, 0
                              , 3, 0
                              , 4, 0
                              , 5, 0
                                 , vacm.valore)
                       )                                  valore
                  , to_char
                    (last_day
                     (to_date
                      (decode( D_arretrati
                             ,'A',decode( to_char(vacm.anno)
                                        , to_char(vacm.riferimento,'yyyy'), lpad(decode( D_da_mese
                                                                                       , D_a_mese, D_da_mese
                                                                                                 , D_a_mese
                                                                                       ),2,'0')||to_char(vacm.anno)
                                                                                , 12||to_char(vacm.anno-1)
                                        )
                              ,'C',lpad(decode( D_da_mese
                                              , D_a_mese, to_char(vacm.riferimento,'mm')
                                                        , decode(ceil(to_char(vacm.riferimento,'mm')/3)
                                                                ,'1','3','2','6','3','9','4','12')
                                              )
                                       ,2,'0')||to_char(vacm.riferimento,'yyyy')
                              ,'P',decode( to_char(vacm.anno)
                                         , to_char(vacm.riferimento,'yyyy'), lpad(decode( D_da_mese
                                                                                         , D_a_mese, to_char(vacm.riferimento,'mm')
                                                                                                   , decode(ceil(to_char(vacm.riferimento,'mm')/3)
                                                                                                           ,'1','3','2','6','3','9','4','12')
                                                                                                           )
                                                                                 ,2,'0')||to_char(vacm.anno)
                                                                            , 12||to_char(vacm.riferimento,'yyyy')
                                         )
                                  , lpad(decode( D_da_mese
                                               , D_a_mese, D_da_mese
                                                         , D_a_mese
                                               ),2,'0')||to_char(vacm.anno)
                                        )
                      ,'mmyyyy'
                     )
                    ),'j')                            dat_doc
               from valori_contabili_mensili          vacm
              where (   cur_periodi.competenza in ('D','C','A')     and
                        vacm.input       = upper(vacm.input)
                     or cur_periodi.competenza in ('P','D')         and
                        vacm.input      != upper(vacm.input)
                     or cur_periodi.competenza in ('C','A')         and
                        vacm.input      != upper(vacm.input) and
                        not exists (select 'x' from periodi_retributivi
                                     where periodo = cur_periodi.periodo
                                       and ci      = cur_ci.ci
                                       and competenza = 'P'
                                       and vacm.riferimento between dal and al
                                   )
                    )
                and vacm.riferimento between cur_periodi.dal and cur_periodi.al
                and vacm.ci          = cur_ci.ci
                and vacm.anno        = D_anno
                and vacm.mese        between D_da_mese and D_a_mese
                and vacm.mese        = to_number(to_char(cur_periodi.periodo,'mm'))
                and vacm.mensilita  != '*AP'
                and vacm.estrazione  = 'CDC'
                and vacm.colonna     = cur_fattori.colonna
                and exists
                   (select 'x' from estrazione_righe_contabili
                     where estrazione = 'CDC'
                       and colonna    = cur_fattori.colonna
                       and vacm.riferimento between dal and nvl(al,to_date('3333333','j'))
                   )
              group by  decode( D_arretrati
                   ,'A',decode( to_char(vacm.anno)
                              , to_char(vacm.riferimento,'yyyy'), vacm.anno
                                                                , vacm.anno-1
                              )
                   ,'C',to_char(vacm.riferimento,'yyyy')
                   ,'P',decode( to_char(vacm.anno)
                              , to_char(vacm.riferimento,'yyyy'), vacm.anno
                                                                , to_char(vacm.riferimento,'yyyy')
                              )
                       ,vacm.anno
                   )
           , decode( D_arretrati
                   ,'A',decode( to_char(vacm.anno)
                              , to_char(vacm.riferimento,'yyyy'), decode( D_da_mese
                                                                        , D_a_mese, D_da_mese
                                                                                  , ceil(D_a_mese/3)
                                                                        )
                                                                , decode( D_da_mese
                                                                        , D_a_mese, 12 -- mensile
                                                                                  , 4  -- trimestrale
                                                                        )
                              )
                   ,'C',decode( D_da_mese
                              , D_a_mese, to_char(vacm.riferimento,'mm')
                                        , lpad(ceil(to_char(vacm.riferimento,'mm')/3)
                                              ,2,'0')
                              )
                   ,'P',decode( to_char(vacm.anno)
                              , to_char(vacm.riferimento,'yyyy'), decode( D_da_mese
                                                                        , D_a_mese, to_char(vacm.riferimento,'mm')
                                                                                  , lpad(ceil(to_char(vacm.riferimento,'mm')
                                                                                             /3)
                                                                                        ,2,'0')
                                                                        )
                                                                , decode( D_da_mese
                                                                        , D_a_mese, 12
                                                                                  , 4
                                                                        )
                              )
                       , decode( D_da_mese
                               , D_a_mese, D_da_mese
                                         , ceil(D_a_mese/3)
                               )
                   )
             ,to_char
              (last_day
               (to_date
                (decode( D_arretrati
                       ,'A',decode( to_char(vacm.anno)
                                  , to_char(vacm.riferimento,'yyyy'), lpad(decode( D_da_mese
                                                                                 , D_a_mese, D_da_mese
                                                                                           , D_a_mese
                                                                           ),2,'0')||to_char(vacm.anno)
                                                                    , 12||to_char(vacm.anno-1)
                                  )
                       ,'C',lpad(decode( D_da_mese
                                       , D_a_mese, to_char(vacm.riferimento,'mm')
                                                 , decode(ceil(to_char(vacm.riferimento,'mm')/3)
                                                         ,'1','3','2','6','3','9','4','12')
                                       )
                                 ,2,'0')||to_char(vacm.riferimento,'yyyy')
                       ,'P',decode( to_char(vacm.anno)
                                  , to_char(vacm.riferimento,'yyyy'), lpad(decode( D_da_mese
                                                                                 , D_a_mese, to_char(vacm.riferimento,'mm')
                                                                                           , decode(ceil(to_char(vacm.riferimento,'mm')/3)
                                                                                                   ,'1','3','2','6','3','9','4','12')
                                                                                                   )
                                                                          ,2,'0')||to_char(vacm.anno)
                                                                    , 12||to_char(vacm.riferimento,'yyyy')
                                  )
                           , lpad(decode( D_da_mese
                                        , D_a_mese, D_da_mese
                                                  , D_a_mese
                                        ),2,'0')||to_char(vacm.anno)
                       )
                ,'mmyyyy'
                )
               ),'j')
           ) LOOP
   Par_quantita := 0;
   Par_valore   := 0;
               select nvl(vacm.qta * decode(sign(cur_periodi.rap_ore),-1,-1,1)
                                   * decode(cur_periodi.competenza,'P',-1,1)
                                   * nvl(cur_periodi.percentuale,1)  ,0)          qta
                    , nvl(vacm.valore * decode(sign(cur_periodi.rap_ore),-1,-1,1)
                                      * decode(cur_periodi.competenza,'P',-1,1)
                                      * nvl(cUr_periodi.percentuale,1)  ,0)       valore
                 into par_quantita,par_valore
                 from dual;

               IF par_quantita != 0 or par_valore != 0 THEN

                  update imputazioni_centro_costo
                     set valore   = valore   + par_valore
                       , quantita = quantita + par_quantita
                   where anno    = vacm.anno
                     and periodo = vacm.periodo
                     and cc      = cur_periodi.cdc
                     and fp      = cur_periodi.fattore_A||cur_fattori.fattore_b
                     and dat_doc = vacm.dat_doc
                     and dat_da  = D_dat_a
                     and dat_a   = D_dat_a;

                  IF SQL%notfound THEN

                     insert into imputazioni_centro_costo
                           ( anno
                           , periodo
                           , cc
                           , fp
                           , quantita
                           , valore
                           , causale
                           , dat_mov
                           , dat_doc
                           , dat_da
                           , dat_a
                           )
                    select vacm.anno
                         , vacm.periodo
                         , nvl(cur_periodi.cdc,'XXXXXXXX')
                         , nvl(cur_periodi.fattore_a||cur_fattori.fattore_b,'XXXXXXXX')
                         , par_quantita
                         , par_valore
                         , 'AP'
                         , to_char(sysdate,'j')
                         , vacm.dat_doc
                         , D_dat_da
                         , D_dat_a
                      from dual;
                   END IF;

                 END IF;

                 delete from imputazioni_centro_costo
                  where nvl(valore,0) = 0
                    and nvl(quantita,0) = 0
                    and causale = 'AP'
                    and dat_da = D_dat_da
                    and dat_a  = D_dat_a
                    and anno   = vacm.anno
                    and periodo = vacm.periodo
                    and fp     = cur_periodi.fattore_a||cur_fattori.fattore_b
                  ;
               COMMIT;
             END LOOP;  -- cur_vacm
         END LOOP;  -- cur_fattori
       END LOOP;  -- cur_periodi
     END LOOP;  -- cur_ci

/* modifica record con valore nullo e fattore definito SOLO a valore su GP4 */
    update imputazioni_centro_costo
      set valore = 1
    where valore = 0
      and causale = 'AP'
      and dat_da = to_char (last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm')),'j')
      and dat_a  = to_char (last_day(to_date(D_anno||lpad(D_a_mese,2,0),'yyyymm')),'j')
      and anno   = D_anno
      and fp in
      (select rtrim( qual.fattore||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( qual.fattore_td||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore_td||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
      )
      and fp not in
      (select rtrim( qual.fattore||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( qual.fattore_td||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore_td||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
      )
   ;
/* modifica record con quantita nulla e fattore definito SOLO a quantita su GP4 */
   update imputazioni_centro_costo
      set quantita = 1
    where quantita = 0
      and causale = 'AP'
      and dat_da = to_char(last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm')),'j')
      and dat_a  = to_char(last_day(to_date(D_anno||lpad(D_a_mese,2,0),'yyyymm')),'j')
      and anno   = D_anno
      and fp in
      (select rtrim( qual.fattore||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( qual.fattore_td||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore_td||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza <= 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
      )
      and fp not in
      (select rtrim( qual.fattore||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( qual.fattore_td||substr(esvc.descrizione,1,2),' ')
         from qualifiche qual
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
       union
       select rtrim( figu.fattore_td||substr(esvc.descrizione,1,2),' ')
         from figure figu
            , estrazione_valori_contabili esvc
        where esvc.estrazione = 'CDC'
          and esvc.sequenza > 5
          and last_day(to_date(D_anno||lpad(D_da_mese,2,0),'yyyymm'))
              between esvc.dal AND nvl(esvc.al,to_date('3333333','j'))
      )
   ;
   END;

END;
END;
END;
/
