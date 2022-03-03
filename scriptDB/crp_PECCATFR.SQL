CREATE OR REPLACE PACKAGE PECCATFR IS

/******************************************************************************
 NOME:          PECCATFR
 DESCRIZIONE:   CARICAMENTO ARCHIVIO TFR

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 1.2  16/06/2004 MS     Revisione 770/2004
 1.3  06/09/2004 MS     mod. come da attivita
 1.4  21/09/2004 MM     mod. come da attività (percentuale di minor abbattimento C96)
 1.5  23/09/2004 MS     Mod. per attivita 7448 ( cessazione ) 
 1.6  08/10/2004 MS     Mod. per attivita 7317.2
 1.7  11/10/2004 MS     Mod. per attività 7275
 1.8  01/06/2005 MS     Mod. per attività 11497 ( Rev 770/2005 )
 1.9  08/06/2005 MS     Mod. per attività 11928.1
 1.10 10/08/2005 NN     Corretta estrazione alq_liq da progressivi_fiscali ( 12348 )
 2.0  25/08/2005 MS     Mod. per attivita 12405
 2.1  26/08/2005 MS     Mod. per attivita 12419
 2.2  30/08/2005 MS     Mod. per attivita 12348.1
 3.0  29/05/2006 MS     Adeguamento per 770/06 (Att. 16251)
 3.1  07/07/2006 MS     Mod. gestione Eredi ( Att. 16907 )
 3.2  18/07/2006 MS     Sistemazione segnalazioni varie da test
 3.3  24/07/2006 MS     Correzione Errore oracle D_gg_red_rif ( Att. 17084 )
 4.0  27/03/2007 MS     Adeguamento per 770/07 ( Att. 19776 )
 4.1  02/08/2007 MS     Correzione e inserimento nuova segnalazione per regime TFR/TFS
 4.2  03/09/2007 MS     Correzione caselle per eredi.
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE CALCOLA_ANZIANITA 
(  D_ci        in number 
 , D_anno      in number
 , D_mofi_anno in number
 , D_mofi_mese in number
 , D_gg_anz_t  out number
 , D_gg_anz_i  out number
 , D_gg_anz_r  out number
 , D_gg_anz_t_2000  out number
 , D_gg_anz_i_2000  out number
 , D_gg_anz_r_2000  out number
);
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
  V_importo         number;

END;
/
CREATE OR REPLACE PACKAGE BODY PECCATFR IS
 
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V4.2 del 03/09/2007';
   END VERSIONE;
PROCEDURE CALCOLA_ANZIANITA 
(  D_ci        in number 
 , D_anno      in number
 , D_mofi_anno in number
 , D_mofi_mese in number
 , D_gg_anz_t  out number
 , D_gg_anz_i  out number
 , D_gg_anz_r  out number
 , D_gg_anz_t_2000  out number
 , D_gg_anz_i_2000  out number
 , D_gg_anz_r_2000  out number
)  IS
BEGIN
  BEGIN
      SELECT sum(nvl(mofi.gg_anz_t,0))        gg_anz_t
           , sum(nvl(mofi.gg_anz_i,0))        gg_anz_i
           , sum(nvl(mofi.gg_anz_r,0))        gg_anz_r
           , sum(nvl(mofi.gg_anz_t_2000,0))   gg_anz_t_2000
           , sum(nvl(mofi.gg_anz_i_2000,0))   gg_anz_i_2000
           , sum(nvl(mofi.gg_anz_r_2000,0))   gg_anz_r_2000
        INTO D_gg_anz_t
           , D_gg_anz_i
           , D_gg_anz_r
           , D_gg_anz_t_2000
           , D_gg_anz_i_2000
           , D_gg_anz_r_2000
      FROM progressivi_fiscali    mofi
     WHERE mofi.ci in (select D_ci
                         from dual
                        union
                       select ci_erede
                         from RAPPORTI_DIVERSI radi
                        where radi.ci = D_ci
                          and radi.rilevanza in ('L','R')
                          and radi.anno = D_anno
                       )
       AND mofi.anno       = D_mofi_anno
       AND mofi.mese       = D_mofi_mese
       AND mofi.mensilita  = (select max(mensilita)
                                from mensilita
                               where mese = mofi.mese
                                 and tipo in ('A','S','N')
                              )
        ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        D_gg_anz_t      := null;
        D_gg_anz_i      := null;
        D_gg_anz_r      := null;
        D_gg_anz_t_2000 := null;
        D_gg_anz_i_2000 := null;
        D_gg_anz_r_2000 := null;
     END;
END CALCOLA_ANZIANITA;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE
--
-- Depositi e Contatori Vari
--
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
  D_ente            varchar2(4);
  D_ambiente        varchar2(8);
  D_utente          varchar2(8);
  D_errore          varchar2(50);
  D_riga            number;
  D_gestione        varchar2(4);
  D_da_ci           number;
  D_a_ci            number;
  D_fin_rap         date;
  D_ini_rap         date;
  D_quota_erede     number;
  D_data_richiesta  date;
  D_mofi_anno       number;
  D_mofi_mese       number;
  D_gg_anz_t        number;
  D_gg_anz_i        number;
  D_gg_anz_r        number;
  D_alq_liq_m       number;
  D_anni_tot        number;
  D_mesi_tot        number;
  D_anni_con        number;
  D_mesi_con        number;
  D_perc            number;
  D_anni            number;
  D_mesi            number;
  D_lor_liq         number;
  D_ipn_liq         number;
  D_lor_acc         number;
  D_lor_acc_2000    number;
  D_fdo_tfr_2000    number;
  D_ant_acc_2000    number;
  D_fdo_tfr_ap      number;
  D_riv_tfr_netto   number;
  D_ant_acc_ap      number;
  D_ipt_liq_ap      number;
  D_ipt_liq         number;
  D_det_liq         number;
  D_rid_tot         number;
  D_alq_liq         number;
  D_ant_liq_ap      number;
  D_qta_tfr_ac      number;
  D_tempo_det       number;
  D_giorni_sosp     number;
  D_anno_rif_equip  number(4);
  D_anno_rif_tfr    number(4);
  D_anno_rif_ind    number(4);
  D_anno_rif_ind_2001 number(4);
  D_tfr_01          number;
  D_tfr_02          number;
  D_tfr_03          number;
  D_tfr_fp_3112     number;
  D_ind_equip       number;
  D_altre_ind       number;
  D_perc_tfr_fp     number;
  D_tfr_mat_3112    number;
  D_tfr_mat_0101    number;
  D_tfr_fp_0101     number;
  D_tfr_0101        number;
  D_imp_equip       number;
  D_imp_3112        number;
  D_imp_0101        number;
  D_mofi_gg_anz_t   number;
  D_max_mese        number;
  D_red_rif         number;
  D_gg_anz_t_2000   number;
  D_gg_anz_i_2000   number;
  D_gg_anz_r_2000   number;
  D_imp_red_rif     number;
  D_gg_red_rif      number;
  D_valorizza       number;
  D_regime_tfr      varchar2(2);
  D_temp            varchar2(1);
  prossimo          exception;
  V_select          varchar2(200);
  V_colonna         varchar2(4);
  BEGIN
  -- Estrazione Parametri di Selezione della Prenotazione
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
        INTO D_anno,D_ini_a,D_fin_a
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro       = 'P_ANNO'
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT anno
             , to_date('01'||to_char(anno),'mmyyyy')
             , to_date('3112'||to_char(anno),'ddmmyyyy')
          INTO D_anno,D_ini_a,D_fin_a
          FROM riferimento_fine_anno
         WHERE rifa_id = 'RIFA'
        ;
    END;
    BEGIN
      SELECT to_number(substr(valore,1,8))
           , to_number(substr(valore,1,8))
        INTO D_da_ci, D_a_ci
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro       = 'P_CI'
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_da_ci := 0;
        D_a_ci  := 99999999;
    END;
    BEGIN
      FOR CUR_CI IN
        (SELECT distinct mofi.ci           ci
           FROM movimenti_fiscali    mofi
              , rapporti_individuali rain
          WHERE mofi.ci BETWEEN D_da_ci AND D_a_ci
            and exists ( select 'x' 
                           FROM PERIODI_RETRIBUTIVI
                          WHERE gestione LIKE D_gestione
                            and ci = mofi.ci
                            and periodo between D_ini_a and D_fin_a
                        )
            AND mofi.ci = rain.ci
            and mofi.anno = D_anno
            and mofi.mensilita != '*AP'
            and (   rain.cc is null
                 or exists
                         (select 'x'
                           from a_competenze
                           where ente        = d_ente
                             and ambiente    = d_ambiente
                             and utente      = d_utente
                             and competenza  = 'CI'
                             and oggetto     = rain.cc
                         )
                 )
          GROUP BY mofi.ci
         HAVING (nvl(sum(mofi.lor_liq),0) != 0
                 OR nvl(sum(mofi.lor_acc),0) +
                    nvl(sum(mofi.lor_acc_2000),0)!= 0
                )
         ) LOOP

-- dbms_output.put_line('ci: '||CUR_CI.ci );
        BEGIN
        SELECT 'x'
          INTO D_temp
          FROM dual
         where exists ( select 'x' 
                          from rapporti_diversi
                         WHERE ci_erede = CUR_CI.ci
                           AND anno = D_anno
                           AND rilevanza = 'E'
                      )
         ;
        RAISE prossimo;
        EXCEPTION
             WHEN too_many_rows THEN
                  RAISE prossimo;
             WHEN no_data_found THEN

-- dbms_output.put_line('Elaboro');
       BEGIN
       FOR CUR_DATI IN
       ( SELECT sum(nvl(prfi.lor_liq,0))        lor_liq
              , sum(nvl(prfi.ipn_liq,0))        ipn_liq
              , sum(nvl(prfi.lor_acc,0))        lor_acc
              , sum(nvl(prfi.lor_acc_2000,0))   lor_acc_2000
              , sum(nvl(prfi.fdo_tfr_2000,0))   fdo_tfr_2000
              , sum(nvl(prfi.ant_acc_2000,0))   ant_acc_2000
              , sum(nvl(prfi.fdo_tfr_ap,0))     fdo_tfr_ap
              , sum(nvl(prfi.rit_tfr,0))        rit_tfr
              , sum(nvl(prfi.riv_tfr,0))        riv_tfr
              , sum(nvl(prfi.riv_tfr_ap,0))     riv_tfr_ap
              , sum(nvl(prfi.ant_acc_ap,0))     ant_acc_ap
              , sum(nvl(prfi.ipt_liq_ap,0))     ipt_liq_ap
              , sum(nvl(prfi.ipt_liq,0))        ipt_liq
              , sum(nvl(prfi.det_liq,0))        det_liq
              , sum(nvl(prfi.dtp_liq,0))        dtp_liq
              , sum(nvl(prfi.rid_liq,0)
                  + nvl(prfi.rtp_liq,0))        rid_tot
              , sum(nvl(prfi.alq_liq,0))        alq_liq
              , sum(nvl(prfi.ant_liq_ap,0))     ant_liq_ap
              , sum(nvl(prfi.qta_tfr_ac,0))     qta_tfr_ac
              , max(nvl(prfi.gg_anz_c,0))       gg_anz_c
              , sum(nvl(lor_acc,0) + 
                   (nvl(riv_tfr_liq,0) + 
                    nvl(riv_tfr_ap_liq,0)))     tfr_0101
           FROM progressivi_fiscali prfi
          WHERE prfi.ci   in ( select CUR_CI.ci
                                 from dual
                                where not exists ( select 'x' 
                                                     from rapporti_diversi
                                                    where ci = CUR_CI.ci
                                                      and anno = D_anno
                                                      and rilevanza = 'E'
                                                 )
                                union
                               select ci_erede
                                 from rapporti_diversi
                                where ci = CUR_CI.ci
                                  and anno = D_anno
                                  and rilevanza = 'E'
                             )
            AND prfi.anno = D_anno
            AND prfi.mese = 12
            AND prfi.mensilita in ( select max(mensilita) mensilita
                                      from mensilita 
                                     where    mese = 12
                                       AND tipo in ('S','N','A') 
                                  )
         HAVING (nvl(sum(prfi.lor_liq),0) != 0
                 OR nvl(sum(prfi.lor_acc),0) +
                    nvl(sum(prfi.lor_acc_2000),0)!= 0
                )
         ) LOOP
           D_fin_rap         := null;
           D_ini_rap         := null;
           D_quota_erede     := to_number(null);
           D_data_richiesta  := to_date(null);
           D_gg_anz_t        := to_number(null);
           D_gg_anz_i        := to_number(null);
           D_gg_anz_r        := to_number(null);
           D_alq_liq_m       := to_number(null);
           D_anni_tot        := to_number(null);
           D_mesi_tot        := to_number(null);
           D_anni_con        := to_number(null);
           D_mesi_con        := to_number(null);
           D_perc            := to_number(null);
           D_anni            := to_number(null);
           D_mesi            := to_number(null);
           D_lor_liq         := to_number(null);
           D_lor_acc         := to_number(null);
           D_lor_acc_2000    := to_number(null);
           D_fdo_tfr_2000    := to_number(null);
           D_ant_acc_2000    := to_number(null);
           D_fdo_tfr_ap      := to_number(null);
           D_riv_tfr_netto   := to_number(null);
           D_ant_acc_ap      := to_number(null);
           D_ipt_liq_ap      := to_number(null);
           D_ipt_liq         := to_number(null);
           D_det_liq         := to_number(null);
           D_rid_tot         := to_number(null);
           D_alq_liq         := to_number(null);
           D_ant_liq_ap      := to_number(null);
           D_qta_tfr_ac      := to_number(null);
           D_tempo_det       := to_number(null);
           D_giorni_sosp     := to_number(null);
           D_anno_rif_equip  := to_number(null);
           D_anno_rif_tfr    := to_number(null);
           D_anno_rif_ind    := to_number(null);
           D_anno_rif_ind_2001 := to_number(null);
           D_tfr_01          := to_number(null);
           D_tfr_02          := to_number(null);
           D_tfr_03          := to_number(null);
           D_tfr_fp_3112     := to_number(null);
           D_ind_equip       := to_number(null);
           D_altre_ind       := to_number(null);
           D_perc_tfr_fp     := to_number(null);
           D_tfr_mat_3112    := to_number(null);
           D_tfr_mat_0101    := to_number(null);
           D_tfr_0101        := to_number(null);
           D_tfr_fp_0101     := to_number(null);
           D_imp_equip       := to_number(null);
           D_imp_3112        := to_number(null);
           D_imp_0101        := to_number(null);
           D_mofi_gg_anz_t   := to_number(null);
           D_max_mese        := to_number(null);
           D_red_rif         := to_number(null);
           D_gg_anz_t_2000   := to_number(null);
           D_gg_anz_i_2000   := to_number(null);
           D_gg_anz_r_2000   := to_number(null);
           D_imp_red_rif     := to_number(null);
           D_gg_red_rif      := to_number(null);
           D_valorizza       := 0;

           BEGIN
           SELECT quota_erede
             INTO D_quota_erede
             FROM RAPPORTI_DIVERSI radi
            WHERE ci = CUR_CI.ci
              AND rilevanza = 'E'
              AND anno = D_anno
            ;
           EXCEPTION
            WHEN NO_DATA_FOUND THEN
              D_quota_erede := null;
           END;
             --
             --  Estrazione Date di Inizio e Fine Rapporto
             --
               BEGIN
                 SELECT max(moco.riferimento)
                   INTO D_fin_rap
                   FROM movimenti_contabili moco
                  WHERE moco.ci in (select CUR_CI.ci
                                      from dual
                                     where not exists ( select 'x' 
                                                          from rapporti_diversi
                                                         where ci = CUR_CI.ci
                                                           and anno = D_anno
                                                           and rilevanza = 'E'
                                                      )
                                     union
                                    select ci_erede
                                      from RAPPORTI_DIVERSI radi
                                     where radi.ci = CUR_CI.ci
                                       and radi.rilevanza in ('L','R')
                                       and radi.anno = D_anno
                                     union
                                     select ci_erede
                                       from rapporti_diversi
                                      where ci = CUR_CI.ci
                                        and anno = D_anno
                                        and rilevanza = 'E'
                                    )
                    AND moco.anno = D_anno
                    AND moco.imp != 0
                    AND moco.voce in (select voce
                                        from contabilita_voce
                                       where fiscale in ('A','L','V')
                                     )
                 ;
-- dbms_output.put_line('D_fin_rap '||D_fin_rap);
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    D_fin_rap := null;
               END;
               BEGIN
               SELECT min(pegi.dal)
                 INTO D_ini_rap
                 FROM periodi_giuridici pegi
                WHERE pegi.ci in (select CUR_CI.ci
                                    from dual
                                   where not exists ( select 'x' 
                                                        from rapporti_diversi
                                                       where ci = CUR_CI.ci
                                                         and anno = D_anno
                                                         and rilevanza = 'E'
                                                    )
                                   union
                                  select ci_erede
                                    from RAPPORTI_DIVERSI radi
                                   where radi.ci = CUR_CI.ci
                                     and radi.rilevanza in ('L','R')
                                     and radi.anno = D_anno
                                   union
                                  select ci_erede
                                    from rapporti_diversi
                                   where ci = CUR_CI.ci
                                     and anno = D_anno
                                     and rilevanza = 'E'
                                 )
                  AND pegi.evento != 'PASS'
                  AND pegi.rilevanza = 'P'
                  and pegi.dal = (select min(dal)
                                    from periodi_giuridici pegi1
                                   where pegi.ci = pegi1.ci
                                     and pegi1.rilevanza = 'P'
                                     AND pegi1.evento != 'PASS'
                                     AND pegi1.dal <= nvl(D_fin_rap,D_fin_a)
                                  )
               ;
-- dbms_output.put_line('D_ini_rap '||D_ini_rap);
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 D_ini_rap := '';
             END;
-- dbms_output.put_line('Passo 2');
             BEGIN
                 SELECT decode(posi.tipo_determinato,'SI','1','0')
                   INTO D_tempo_det
                   FROM posizioni posi
                      , periodi_giuridici pegi
                  WHERE pegi.ci = CUR_CI.ci
                    AND pegi.rilevanza = 'S'
                    AND posi.codice = pegi.posizione
                    AND pegi.dal = (select max(dal)
                                          from periodi_giuridici
                                         where ci = CUR_CI.ci
                                           and rilevanza = 'S'
                                           and dal <= D_fin_a
                                           and nvl(al,to_date(3333333,'j')) >= D_ini_a
                                       )
                 ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  d_tempo_det := null;
              END;
                IF D_tempo_det != 0 THEN
--  dbms_output.put_line('Estrazione giorni sospesi');
                BEGIN
                SELECT sum(  nvl(clpa.al, D_fin_a) - nvl(clpa.dal, D_ini_a) + 1 ) giorni
                  INTO D_giorni_sosp
                  FROM classi_presenza clpa
                 WHERE nvl(D_ini_rap,D_ini_a) <= clpa.al
                   AND nvl(D_fin_rap,D_fin_a) >= clpa.dal
                   AND ci                                  = CUR_CI.ci
                   AND exists
                          ( select 'x'
                              from ripartizione_causali rica
                             where classe                  = clpa.classe
                               and exists
                                   ( select 'x'
                                       from voci_contabili_evento vcev
                                      where causale                  = rica.causale
                                        and exists
                                            (select 'x'
                                               from voci_economiche voec
                                              where codice             = vcev.voce
                                                and specifica         in
                                                   ( select 'CUDO1M_S15' from dual
                                                      union
                                                     select 'CUDO1M_S18' from dual
                                                      union
                                                     select 'CUDO1M_S1M' from dual
                                                      union
                                                     select 'CUDO1M_S1T' from dual
                                                      union
                                                     select 'CUDO1M_S25' from dual
                                                      union
                                                     select 'CUDO1M_S28' from dual
                                                      union
                                                     select 'CUDO1M_S2M' from dual
                                                      union
                                                     select 'CUDO1M_S2T' from dual
                                                      union
                                                     select 'CUDO1M_S50' from dual
                                                      union
                                                     select 'CUDO1M_S51' from dual
                                                   )
                                          )
                                 )
                          )
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  D_giorni_sosp := null;
              END;
              END IF;
-- dbms_output.put_line('Estrazione TFR_01, TFR_01, TFR_03');
              SELECT sum(decode(vaca.colonna,'TFR_01',valore,to_number(null)))
                   , sum(decode(vaca.colonna,'TFR_02',valore,to_number(null)))
                   , sum(decode(vaca.colonna,'TFR_03',valore,to_number(null)))
                INTO D_tfr_01
                   , D_tfr_02
                   , D_tfr_03
                FROM valori_contabili_annuali vaca
               WHERE vaca.anno       = D_anno
                 AND vaca.mese       = 12
                 AND vaca.mensilita  = (select max(mensilita)
                                          from mensilita
                                         where mese = 12
                                           and tipo in ('A','N','S')
                                       )
                 AND vaca.estrazione = 'DENUNCIA_CUD'
                 AND vaca.colonna    in ('TFR_01','TFR_02','TFR_03')
                 AND vaca.ci         in ( select CUR_CI.ci
                                            from dual
                                           where not exists ( select 'x' 
                                                                from rapporti_diversi
                                                               where ci = CUR_CI.ci
                                                                 and anno = D_anno
                                                                 and rilevanza = 'E'
                                                           )
                                           union
                                          select ci_erede
                                            from rapporti_diversi
                                           where ci = CUR_CI.ci
                                             and anno = D_anno
                                             and rilevanza = 'E'
                                         )
              ;
--  dbms_output.put_line('Prima IF');
              IF nvl(D_tfr_01,0) != 0 and nvl(D_tfr_02,0) + nvl(D_tfr_03,0) != 0 THEN
                D_ind_equip := D_tfr_01;
                D_altre_ind := CUR_DATI.lor_liq - CUR_DATI.lor_acc - CUR_DATI.lor_acc_2000 - nvl(D_tfr_01,0);
                D_valorizza := 1;
              ELSIF nvl(D_tfr_01,0) != 0 and nvl(D_tfr_02,0) + nvl(D_tfr_03,0) = 0 THEN
                D_ind_equip := nvl(D_tfr_01,0);
                D_altre_ind := 0;
                D_valorizza := 1;
              ELSIF nvl(D_tfr_01,0) = 0 and nvl(D_tfr_02,0) + nvl(D_tfr_03,0) != 0 THEN
                D_ind_equip := 0;
                D_altre_ind := CUR_DATI.lor_liq - CUR_DATI.lor_acc - CUR_DATI.lor_acc_2000;
                  D_valorizza := 2;
                IF nvl(D_tfr_03,0) = 0 THEN
                  D_tfr_02 :=  CUR_DATI.lor_liq - CUR_DATI.lor_acc - CUR_DATI.lor_acc_2000;
                ELSE
                  D_tfr_03 :=  CUR_DATI.lor_liq - CUR_DATI.lor_acc - CUR_DATI.lor_acc_2000;
                END IF;
              ELSE
                D_ind_equip := 0;
                D_altre_ind := 0;
                D_valorizza := 3;
              END IF;

              IF nvl(D_tfr_01,0) != 0 THEN
               BEGIN
               select max(anno)
                 INTO D_anno_rif_equip
                 FROM valori_contabili_annuali vaca
                WHERE vaca.anno       < D_anno
                  AND vaca.mese       = 12
                  AND vaca.mensilita  = (select max(mensilita)
                                           from mensilita
                                          where mese = 12
                                            and tipo in ('A','N','S')
                                        )
                 AND vaca.estrazione = 'DENUNCIA_CUD'
                 AND vaca.colonna    = 'TFR_01'
                 AND vaca.ci        in ( select CUR_CI.ci
                                           from dual
                                          where not exists ( select 'x' 
                                                               from rapporti_diversi
                                                              where ci = CUR_CI.ci
                                                                and anno = D_anno
                                                                and rilevanza = 'E'
                                                           )
                                           union
                                          select ci_erede
                                            from rapporti_diversi
                                           where ci = CUR_CI.ci
                                             and anno = D_anno
                                             and rilevanza = 'E'
                                       )
                group by ci
                having sum(nvl(valore,0)) != 0
               ;
               EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                         D_anno_rif_equip  := to_number(null);
               END;
              END IF; -- su tfr_01

              IF nvl(D_tfr_02,0) != 0 THEN
               BEGIN
               select max(anno)
                 INTO D_anno_rif_tfr
                 FROM valori_contabili_annuali vaca
                WHERE vaca.anno       < D_anno
                  AND vaca.mese       = 12
                  AND vaca.mensilita  = (select max(mensilita)
                                           from mensilita
                                          where mese = 12
                                            and tipo in ('A','N','S')
                                        )
                 AND vaca.estrazione = 'DENUNCIA_CUD'
                 AND vaca.colonna    = 'TFR_02'
                 AND vaca.ci         in ( select CUR_CI.ci
                                            from dual
                                          where not exists ( select 'x' 
                                                               from rapporti_diversi
                                                              where ci = CUR_CI.ci
                                                                and anno = D_anno
                                                                and rilevanza = 'E'
                                                           )
                                           union
                                          select ci_erede
                                            from rapporti_diversi
                                           where ci = CUR_CI.ci
                                             and anno = D_anno
                                             and rilevanza = 'E'
                                       )
                group by ci
                having sum(nvl(valore,0)) != 0
               ;
               EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                         D_anno_rif_tfr  := to_number(null);
               END;
              END IF; -- su tfr_02

              IF D_valorizza = 3 THEN
               BEGIN
               select max(anno)
                 INTO D_anno_rif_ind
                 FROM movimenti_fiscali mofi
                WHERE mofi.anno       < D_anno
                  AND mofi.ci        in ( select CUR_CI.ci
                                            from dual
                                          where not exists ( select 'x' 
                                                               from rapporti_diversi
                                                              where ci = CUR_CI.ci
                                                                and anno = D_anno
                                                                and rilevanza = 'E'
                                                           )
                                           union
                                          select ci_erede
                                            from rapporti_diversi
                                           where ci = CUR_CI.ci
                                             and anno = D_anno
                                             and rilevanza = 'E'
                                       )
                  and mofi.mensilita  != '*AP'
                  and nvl(ipn_liq,0)  != 0
               ;
               EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                         D_anno_rif_ind  := to_number(null);
               END;
               BEGIN
               select max(anno)
                 INTO D_anno_rif_ind_2001
                 FROM progressivi_fiscali prfi
                WHERE prfi.anno       < D_anno
                  AND prfi.ci        in ( select CUR_CI.ci
                                            from dual
                                          where not exists ( select 'x' 
                                                               from rapporti_diversi
                                                              where ci = CUR_CI.ci
                                                                and anno = D_anno
                                                                and rilevanza = 'E'
                                                           )
                                           union
                                          select ci_erede
                                            from rapporti_diversi
                                           where ci = CUR_CI.ci
                                             and anno = D_anno
                                             and rilevanza = 'E'
                                       )
                  and prfi.mese       = 12
                  AND prfi.mensilita  = (select max(mensilita)
                                           from mensilita
                                          where mese = 12
                                            and tipo in ('A','N','S')
                                        )
                  and nvl(prfi.ipn_liq_ap,0)  != 0
               ;
               EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                         D_anno_rif_ind_2001  := to_number(null);
               END;
              END IF; -- 


              D_tfr_mat_3112 := nvl(CUR_DATI.fdo_tfr_2000,0) + nvl(CUR_DATI.ant_acc_2000,0)
                              + nvl(fondi_tfr_anno(CUR_CI.ci,2000,12),0);
              D_tfr_fp_3112  := nvl(fondi_tfr_anno(CUR_CI.ci,2000,12),0);

 
      BEGIN
       select round((  (309.87 * 13.5 / 100) * decode(inre.tariffa,7.41,7.4074,inre.tariffa) ) / 12
                *  months_between( to_date('31122000','ddmmyyyy'),inre.dal-1 )/309.87*100,2)
         INTO D_perc_tfr_fp
                 from informazioni_retributive inre
                where ci    = CUR_CI.ci
                  and voce in (select codice from voci_economiche where specifica = 'RID_FONDI')
          and inre.dal < to_date('31122000','ddmmyyyy')
       ;
      EXCEPTION WHEN NO_DATA_FOUND THEN D_perc_tfr_fp := 0;
      END;
        IF D_ind_equip != 0 THEN
          D_imp_equip := D_ind_equip + CUR_DATI.ant_acc_2000 + CUR_DATI.ant_acc_ap - CUR_DATI.rid_tot;
        ELSIF nvl(D_tfr_01,0) = 0 and D_tfr_02 != 0 and nvl(D_tfr_03,0) = 0 THEN
              D_imp_equip := D_altre_ind + CUR_DATI.ant_acc_2000 + CUR_DATI.ant_acc_ap;
        END IF;

       IF D_valorizza = 2 and (nvl(D_lor_liq,0) - nvl(D_ipn_liq,0)) = 0 THEN
         D_imp_3112 := nvl(CUR_DATI.lor_acc_2000,0) + nvl(CUR_DATI.ant_acc_2000,0) + nvl(CUR_DATI.ant_acc_ap,0) + nvl(CUR_DATI.ant_liq_ap,0);
       ELSE
         D_imp_3112 := nvl(CUR_DATI.lor_acc_2000,0) + nvl(CUR_DATI.ant_acc_2000,0) + nvl(CUR_DATI.ant_acc_ap,0) + nvl(CUR_DATI.ant_liq_ap,0) - nvl(CUR_DATI.rid_tot,0);
       END IF;
       D_imp_0101 := CUR_DATI.lor_liq + CUR_DATI.lor_acc;

           BEGIN
                SELECT max(mofi.mese)
                  INTO D_max_mese
                  FROM movimenti_fiscali   mofi
                 WHERE mofi.ci in   ( select CUR_CI.ci
                                        from dual
                                       where not exists ( select 'x' 
                                                            from rapporti_diversi
                                                           where ci = CUR_CI.ci
                                                             and anno = D_anno
                                                             and rilevanza = 'E'
                                                        )
                                       union
                                      select ci_erede
                                        from rapporti_diversi
                                       where ci = CUR_CI.ci
                                         and anno = D_anno
                                         and rilevanza = 'E'
                                       )
                 AND mofi.anno = D_anno
                   and (   nvl(mofi.ipt_liq,0) != 0
                        or nvl(mofi.rtp_liq,0) != 0
                        or nvl(mofi.rid_liq,0) != 0
                       )
           ;

--  dbms_output.put_line('CUR_CI.ci - D_anno - D_max_mese : '||CUR_CI.ci||'-'||D_anno||'-'||D_max_mese);

/*  Ridetermina le rivalutazioni al mese di liquidazione anziche al mese di dicembre 
    per andar dietro ad una duplice una errata interpretazione della Marta */


               IF get_se_cessato(CUR_CI.ci,D_anno,nvl(D_max_mese,12)) = 0 THEN
             --
             --  Estrazione Valori Fiscali Mensili
             --
               BEGIN -- caso di dipendente in servizio
              <<SERVIZIO>>
--  dbms_output.put_line('Estrazione valori fiscali mensili');
               D_data_richiesta := data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese);
               IF to_char(D_data_richiesta ,'yyyy') < D_anno THEN
                  D_mofi_anno := to_char(D_data_richiesta ,'yyyy');
                  D_mofi_mese := to_char(D_data_richiesta ,'mm');
                CALCOLA_ANZIANITA ( CUR_CI.ci , D_anno, D_mofi_anno, D_mofi_mese , D_gg_anz_t , D_gg_anz_i 
                                  , D_gg_anz_r , D_gg_anz_t_2000 , D_gg_anz_i_2000 , D_gg_anz_r_2000 );
               ELSE
                  D_mofi_anno := D_anno;
                  D_mofi_mese := least(D_max_mese,to_char(D_data_richiesta ,'mm'));
                CALCOLA_ANZIANITA ( CUR_CI.ci , D_anno, D_mofi_anno, D_mofi_mese , D_gg_anz_t , D_gg_anz_i 
                                  , D_gg_anz_r , D_gg_anz_t_2000 , D_gg_anz_i_2000 , D_gg_anz_r_2000 );
              END IF; -- controllo su anno di riferimento della data_richiesta
--  dbms_output.put_line('D_gg_anz_t '||D_gg_anz_t||' - D_gg_anz_i '||D_gg_anz_i||' - 'D_gg_anz_r '||D_gg_anz_r);
--  dbms_output.put_line('D_gg_anz_t_2000 '||D_gg_anz_t_2000||' - D_gg_anz_i_2000 '||D_gg_anz_i_2000||' - D_gg_anz_r_2000 '||D_gg_anz_r_2000);
               BEGIN
--  dbms_output.put_line('Estrazione aliquota di liquidazione 1');
                D_alq_liq_m := null;
                 SELECT max(nvl(mofi.alq_liq,0))         alq_liq
                   INTO D_alq_liq_m
                   FROM movimenti_fiscali    mofi
                  WHERE ( mofi.ci , mofi.anno ) 
                                in (select CUR_CI.ci, D_anno
                                      from dual
                                     where not exists ( select 'x' 
                                                          from rapporti_diversi
                                                         where ci = CUR_CI.ci
                                                           and anno = D_anno
                                                           and rilevanza = 'E'
                                                     )
                                    union
                                    select ci_erede, D_anno
                                      from RAPPORTI_DIVERSI radi
                                     where radi.ci = CUR_CI.ci
                                       and radi.rilevanza in ('L','R')
                                       and radi.anno = D_anno
                                    union
                                    select ci_erede, D_anno
                                      from RAPPORTI_DIVERSI radi
                                     where radi.ci = CUR_CI.ci
                                       and radi.rilevanza = 'E'
                                       and radi.anno = D_anno
                                   )
                    AND mofi.mese       = ( select max(mese) 
                                              from movimenti_fiscali
                                             where ci = mofi.ci
                                               and anno = mofi.anno
                                               and nvl(alq_liq,0) != 0
                                               and nvl(ipt_liq,0) != 0
                                          )
                    AND mofi.mensilita  = ( select max(mensilita)
                                              from mensilita mens
                                             where mese = mofi.mese
                                               and tipo in ('A','S','N')
                                               and exists (select 'x' from movimenti_fiscali mofi1
                                                            where ci = mofi.ci
                                                              and anno = mofi.anno
                                                              and mensilita = mens.mensilita
                                                              and nvl(mofi1.alq_liq,0) != 0
                                                              and nvl(mofi1.ipt_liq,0) != 0
                                                           )
                                          )
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   D_alq_liq_m     := null;
               END;
-- dbms_output.put_line('D_alq_liq_m '||D_alq_liq_m);
                  select (nvl(sum( nvl(prfi.fdo_tfr_ap,0)
                         + nvl(prfi.fdo_tfr_2000,0)
                         + nvl(prfi.ant_acc_ap,0)
                         + nvl(prfi.ant_acc_2000,0)
                         + nvl(prfi.qta_tfr_ac,0)
                         - nvl(prfi.rit_tfr,0)
                         )
                         ,0)
                         + fondi_tfr_progressivi (CUR_CI.ci,D_anno,least(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                                                         )
                                                  )
                         ) * 12
                    into D_imp_red_rif
                    from progressivi_fiscali prfi
                   where anno = to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                     and ci = CUR_CI.ci
                     and mese = to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                     and mensilita = (select max(mensilita)
                                        from mensilita
                                       where tipo in ('N','A','S')
                                         and mese = to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                     )
                   ;
                  select sum(nvl(gg_anz_t,0)) / 360
                     - max(nvl( giorni_richiesta_tfr (CUR_CI.ci,D_anno,greatest(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')))
                                  , 0) / 360
                          )
                    into D_gg_red_rif
                    from progressivi_fiscali prfi
                   where anno = D_anno
                     and ci = CUR_CI.ci
                     and mese = D_max_mese
                     and mensilita = (select max(mensilita)
                                        from mensilita
                                       where tipo in ('N','A','S')
                                         and mese = D_max_mese
                                     )
                  ;
                  select sum(nvl(prfi.fdo_tfr_ap,0) +  
                               nvl(prfi.qta_tfr_ac,0) -
                               nvl(prfi.rit_tfr,0))
                    into D_tfr_mat_0101
                    from progressivi_fiscali prfi
                   where anno = to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                     and ci = CUR_CI.ci
                     and mese = to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                     and mensilita = (select max(mensilita)
                                        from mensilita
                                       where tipo in ('N','A','S')
                                         and mese = to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                     )
                   ;
                 D_tfr_0101 := CUR_DATI.lor_acc;
                 D_tfr_mat_0101 := D_tfr_mat_0101 
                                 + fondi_tfr_anno(CUR_CI.ci,D_anno,least(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))) 
                                 - fondi_tfr_anno(CUR_CI.ci,2000,12);
                 D_tfr_fp_0101  := fondi_tfr_anno(CUR_CI.ci,D_anno,least(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))) - fondi_tfr_anno(CUR_CI.ci,2000,12);

/* calcolo rivalutazione TFR per dipendente in servizio */
/*  Ridetermina le rivalutazioni al mese di liquidazione anziche al mese di dicembre 
    per andar dietro ad una duplice una errata interpretazione della Marta */
        SELECT sum( nvl(prfi.riv_tfr_liq,0)
                  + nvl(prfi.riv_tfr_ap_liq,0)
                  )
          into D_riv_tfr_netto
           FROM progressivi_fiscali prfi
          WHERE prfi.anno         = D_anno
              and prfi.ci           = CUR_CI.ci
            AND prfi.mese         = least(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))
            AND prfi.mensilita    = (SELECT max(mensilita)
                                       FROM mensilita mens
                                      WHERE mese = least(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))
                                        AND tipo in ('S','N','A')
                                        and exists
                                                      (select 'x' from movimenti_fiscali mofi1
                                            where ci = prfi.ci
                                              and anno = prfi.anno
                                              and mensilita = mens.mensilita
                                          )
                                    )
             ;
               END SERVIZIO; -- caso di dipendente in servizio
               ELSE 
               BEGIN -- caso di dipendente cessato 
               <<CESSATO>>
             --
             --  Estrazione Valori Fiscali Mensili
             --
--   dbms_output.put_line('Estrazione valori fiscali mensili');

               D_data_richiesta := data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese);
               IF to_char(D_data_richiesta ,'yyyy') < D_anno THEN
                  D_mofi_anno := to_char(D_data_richiesta ,'yyyy');
                  D_mofi_mese := to_char(D_data_richiesta ,'mm');
                CALCOLA_ANZIANITA ( CUR_CI.ci , D_anno, D_mofi_anno, D_mofi_mese , D_gg_anz_t , D_gg_anz_i 
                                  , D_gg_anz_r , D_gg_anz_t_2000 , D_gg_anz_i_2000 , D_gg_anz_r_2000 );
               ELSE
                  D_mofi_anno := D_anno;
                  D_mofi_mese := greatest(D_max_mese,to_char(D_data_richiesta,'mm'));
                CALCOLA_ANZIANITA ( CUR_CI.ci , D_anno, D_mofi_anno, D_mofi_mese , D_gg_anz_t , D_gg_anz_i 
                                  , D_gg_anz_r , D_gg_anz_t_2000 , D_gg_anz_i_2000 , D_gg_anz_r_2000 );
               END IF;
--  dbms_output.put_line('D_gg_anz_t '||D_gg_anz_t||' - D_gg_anz_i '||D_gg_anz_i||' - 'D_gg_anz_r '||D_gg_anz_r);
--  dbms_output.put_line('D_gg_anz_t_2000 '||D_gg_anz_t_2000||' - D_gg_anz_i_2000 '||D_gg_anz_i_2000||' - D_gg_anz_r_2000 '||D_gg_anz_r_2000);
               BEGIN
--  dbms_output.put_line('Estrazione Aliquota di Liquidazione 2');
                 SELECT max(nvl(mofi.alq_liq,0))         alq_liq
                   INTO D_alq_liq_m
                   FROM progressivi_fiscali    mofi
                  WHERE ( mofi.ci , mofi.anno ) 
                                in (select CUR_CI.ci, D_anno
                                      from dual
                                     where not exists ( select 'x' 
                                                          from rapporti_diversi
                                                         where ci = CUR_CI.ci
                                                           and anno = D_anno
                                                           and rilevanza = 'E'
                                                      )
                                    union
                                    select ci_erede, D_anno
                                      from RAPPORTI_DIVERSI radi
                                     where radi.ci = CUR_CI.ci
                                       and radi.rilevanza in ('L','R')
                                       and radi.anno = D_anno
                                    union
                                    select ci_erede, D_anno
                                      from RAPPORTI_DIVERSI radi
                                     where radi.ci = CUR_CI.ci
                                       and radi.rilevanza = 'E'
                                       and radi.anno = D_anno
                                   )
                    AND mofi.mese       = ( select max(mese) 
                                              from movimenti_fiscali
                                             where ci = mofi.ci
                                               and anno = mofi.anno
                                               and nvl(alq_liq,0) != 0
                                               and nvl(ipt_liq,0) != 0
                                          )
                    AND mofi.mensilita  = ( select max(mensilita)
                                              from mensilita mens
                                             where mese = mofi.mese
                                               and tipo in ('A','S','N')
                                               and exists (select 'x' from movimenti_fiscali mofi1
                                                            where ci = mofi.ci
                                                              and anno = mofi.anno
                                                              and mensilita = mens.mensilita
                                                              and nvl(mofi1.alq_liq,0) != 0
                                                              and nvl(mofi1.ipt_liq,0) != 0
                                                           )
                                          )
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   D_alq_liq_m     := null;
               END;
-- dbms_output.put_line('D_alq_liq_m '||D_alq_liq_m);
-- dbms_output.put_line('D_max_mese '||D_max_mese);
                select (nvl(sum( nvl(prfi.fdo_tfr_ap,0)
                               + nvl(prfi.fdo_tfr_2000,0)
                               + nvl(prfi.ant_acc_ap,0)
                               + nvl(prfi.ant_acc_2000,0)
                               + nvl(prfi.qta_tfr_ac,0)
                               - nvl(prfi.rit_tfr,0)
                               )
                           ,0)
                        + fondi_tfr_progressivi (CUR_CI.ci,D_anno,greatest(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                                                           )
                                                 )
                       ) * 12
                 into D_imp_red_rif
                 from progressivi_fiscali prfi
                where anno = decode( nvl(D_ind_equip,0)
                                     , 0, D_anno
                                        , to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                                   )
                  and ci = CUR_CI.ci
                  and mese = decode( nvl(D_ind_equip,0)
                                     , 0, decode( to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                                                , D_anno, greatest(D_max_mese
                                                                  ,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                                                  )
                                                        , D_max_mese
                                               )
                                        , to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                   )
                  and mensilita = (select max(mensilita)
                                     from mensilita
                                    where tipo in ('N','A','S')
                                      and mese =  decode( nvl(D_ind_equip,0)
                                                         , 0, decode( to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                                                                    , D_anno, greatest(D_max_mese
                                                                                      ,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                                                                      )
                                                                            , D_max_mese
                                                                     )
                                                             , to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')
                                                         )
                                   )
                ;
                select sum(nvl(prfi.fdo_tfr_ap,0) +  
                             nvl(prfi.qta_tfr_ac,0) -
                             nvl(prfi.rit_tfr,0))                     
                 into D_tfr_mat_0101
                 from progressivi_fiscali prfi
                where anno = D_anno
                  and ci = CUR_CI.ci
                  and mese = decode( to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                                   , D_anno, greatest(D_max_mese, to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))
                                           , D_max_mese
                                   )
                  and mensilita = (select max(mensilita)
                                     from mensilita
                                    where tipo in ('N','A','S')
                                      and mese = decode( to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                                                       , D_anno, greatest(D_max_mese, to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))
                                                               , D_max_mese
                                                      )
                                  )
                ;
-- dbms_output.put_line(D_tfr_mat_0101);
                select sum(nvl(gg_anz_t,0)) / 360
                     - max(decode(get_se_cessato(CUR_CI.ci,D_anno,nvl(D_max_mese,12))
                           ,0 ,nvl( giorni_richiesta_tfr (CUR_CI.ci,D_anno,least(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm')))
                              , 0)
                          , 0) / 360
                          )
                  into D_gg_red_rif
                  from progressivi_fiscali prfi
                 where anno = D_anno
                   and ci = CUR_CI.ci
                   and mese = D_max_mese
                   and mensilita = (select max(mensilita)
                                      from mensilita
                                     where tipo in ('N','A','S')
                                       and mese = D_max_mese
                                    )
                ;
                D_tfr_0101 := CUR_DATI.lor_acc;
                D_tfr_mat_0101 := D_tfr_mat_0101 
                                 + fondi_tfr_anno(CUR_CI.ci,D_anno,greatest(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))) 
                                 - fondi_tfr_anno(CUR_CI.ci,2000,12);
                D_tfr_fp_0101  := fondi_tfr_anno(CUR_CI.ci,D_anno,greatest(D_max_mese,to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))) - fondi_tfr_anno(CUR_CI.ci,2000,12);
/* calcolo rivalutazione TFR per dipendente cessato*/
/*  Ridetermina le rivalutazioni al mese di liquidazione anziche al mese di dicembre 
    per andar dietro ad una duplice una errata interpretazione della Marta */

        SELECT sum( nvl(prfi.riv_tfr_liq,0)
                  + nvl(prfi.riv_tfr_ap_liq,0)
                  )
          into D_riv_tfr_netto
          FROM progressivi_fiscali prfi
          WHERE prfi.anno         = D_anno
            and prfi.ci           = CUR_CI.ci
            AND prfi.mese         = decode( to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                                          , D_anno, greatest(D_max_mese, to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))
                                                  , D_max_mese
                                           )
            AND prfi.mensilita    = (SELECT max(mensilita)
                                       FROM mensilita mens
                                      WHERE mese = decode( to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'yyyy')
                                                         , D_anno, greatest(D_max_mese, to_char(data_richiesta_tfr(CUR_CI.ci,D_anno,D_max_mese),'mm'))
                                                                 , D_max_mese
                                                         )
                                        AND tipo in ('S','N','A')
                                        and exists
                                                      (select 'x' from movimenti_fiscali mofi1
                                            where ci = prfi.ci
                                              and anno = prfi.anno
                                              and mensilita = mens.mensilita
                                          )
                                    )
             ;
               END CESSATO;
             END IF; -- caso di dipendente cessato
             IF nvl(D_gg_red_rif,0) = 0 and ( nvl(D_imp_3112,0) + nvl(D_imp_0101,0) + nvl(D_tfr_03,0)) > 0 
              THEN
                D_riga := nvl(D_riga,0) + 1;
                D_errore := ' : GG Anz.Non Presenti ';
                INSERT INTO a_segnalazioni_errore
                (no_prenotazione,passo,progressivo,errore,precisazione)
                VALUES (prenotazione,1,D_riga,'P05052','Per il CI: '||SUBSTR(TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
                COMMIT;
             ELSE
               IF nvl(D_gg_red_rif,0) != 0  THEN
                  D_red_rif := e_round(D_imp_red_rif / D_gg_red_rif,'I');
               ELSE
                  D_red_rif := e_round(D_imp_red_rif,'I');
               END IF;
             END IF;
           EXCEPTION
                WHEN no_data_found THEN
  -- dbms_output.put_line('no_data_found Estrazione MAX_MESE');
                     D_red_rif := 0;
           END;
           
           BEGIN
             select decode(nvl(trpr.fine_servizio,9),1,'SI','NO')
               into D_regime_tfr
               from periodi_retributivi        pere
                  , trattamenti_previdenziali  trpr
              where pere.ci         = CUR_CI.ci
                and pere.competenza = 'A'
                and pere.servizio   = 'Q'
                and to_char(pere.periodo,'yyyy') = D_anno 
                and to_char(pere.al,'mm')        = lpad(D_max_mese,2,'0')
                and nvl(tipo,' ') not in ( 'R', 'F')
                and pere.periodo = ( select max(periodo) 
                                       from periodi_retributivi
                                      where competenza = 'A'
                                        and servizio = 'Q'
                                        and ci = pere.ci
                                        and to_char(periodo,'yyyy') = D_anno 
                                        and to_char(pere.al,'mm')        = lpad(D_max_mese,2,'0')
                                        and nvl(tipo,' ') not in ( 'R', 'F')
                                   )
                and pere.trattamento = trpr.codice (+)
                and pere.trattamento != '*' -- eslcudo record di pddl 
             ; 
           EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                  D_regime_tfr := 'NO';
           END;

           D_temp := '';
           BEGIN
             select decode(count(*),0,'','X')
               into D_temp
               from periodi_retributivi        pere
                  , trattamenti_previdenziali  trpr
              where pere.ci         = CUR_CI.ci
                and pere.competenza = 'A'
                and pere.servizio   = 'Q'
                and to_char(pere.periodo,'yyyy') = D_anno 
                and nvl(tipo,' ') not in ( 'R', 'F' )
                and exists ( select 'x'
                               from periodi_retributivi  pere1
                                  , trattamenti_previdenziali trpr1
                              where pere1.competenza = 'A'
                                and pere1.servizio = 'Q'
                                and pere1.ci = pere.ci
                                and to_char(pere1.periodo,'yyyy') = D_anno 
                                and nvl(pere1.tipo,' ') not in ( 'R', 'F')
                                and pere1.trattamento = trpr1.codice
                                and pere1.rowid != pere.rowid
                                and decode(nvl(trpr.fine_servizio,9),1,'SI','NO') 
                                 != decode(nvl(trpr1.fine_servizio,9),1,'SI','NO')
                           )
                and pere.trattamento = trpr.codice
             ; 
           EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                  D_temp := '';
           END;
           IF  D_temp = 'X' THEN
            D_riga := nvl(D_riga,0) + 1;
            D_errore := ' : Passaggio da TFR o TFS o viceversa ';
            INSERT INTO a_segnalazioni_errore
            (no_prenotazione,passo,progressivo,errore,precisazione)
            VALUES (prenotazione,1,D_riga,'P05479','Per il CI: '||SUBSTR(TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
            COMMIT;
           END IF;
           BEGIN
-- dbms_output.put_line('Provo a fare update');
            UPDATE denuncia_fiscale
               set C108 = nvl(D_ini_rap, D_ini_a)
                 , C109 = nvl(D_fin_rap, D_data_richiesta)
                 , C75  = decode(D_valorizza,3,D_giorni_sosp,null)
                 , C76  = decode(D_valorizza,3,decode(D_tempo_det,0, null, D_tempo_det),null)
                 , C77  = decode(nvl(D_ind_equip,0),0,null, D_gg_anz_t)
                 , C78  = decode(nvl(D_ind_equip,0),0,null, decode( CUR_DATI.gg_anz_c, 0, null , CUR_DATI.gg_anz_c ) )
                 , C79  = decode(nvl(D_ind_equip,0),0,null, decode( nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0)
                                                                  ,0,null,nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0)))
                 , C80  = decode(nvl(D_ind_equip,0)
                                ,0,null, decode(nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0)
                                               ,0,null,decode( nvl(D_gg_anz_t,0)
                                                             , nvl(D_gg_anz_i,0), null
                                                                                , round( nvl(D_gg_anz_r,0)
                                                                                       /(nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0))
                                                                                        ,4) * 100
                                                              )))
                 , C81  = decode(nvl(D_ind_equip,0),0,null,D_ind_equip)
                 , C82  = decode(D_valorizza
                                ,1, decode(nvl(D_quota_erede, 100)
                                          , 100, decode( CUR_DATI.ant_acc_2000,0, null,CUR_DATI.ant_acc_2000)
                                               , e_round(decode( CUR_DATI.ant_acc_2000,0, null,CUR_DATI.ant_acc_2000)/100*D_quota_erede,'I' )
                                          )
                                  , null )
                 , C83  = decode(nvl(decode(D_valorizza,1,CUR_DATI.ant_acc_2000),0),0,null,D_anno_rif_equip)
                 , C84  = decode(D_regime_tfr
                                ,'NO',decode(nvl(D_quota_erede, 100)
                                            , 100, decode( D_altre_ind,0 , null, D_altre_ind )
                                                 , e_round( decode( D_altre_ind,0, null, D_altre_ind )/100*D_quota_erede,'I' )
                                            )
                                     , null)
                 , C85  = decode(D_valorizza
                                 ,2, decode(D_regime_tfr
                                            ,'NO', decode(nvl(D_quota_erede, 100)
                                                         , 100, decode( CUR_DATI.ant_liq_ap,0,null, CUR_DATI.ant_liq_ap )
                                                              , e_round(decode( CUR_DATI.ant_liq_ap,0,null, CUR_DATI.ant_liq_ap )/100*D_quota_erede,'I' )
                                                         )
                                                 , null)
                                   , null)
                 , C86  = decode(nvl(decode(D_valorizza,2, decode(D_regime_tfr,'NO', CUR_DATI.ant_liq_ap, null), null),0)
                                ,0,null,D_anno_rif_tfr)
                 , C87  = decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0),0,null,D_gg_anz_t_2000)
                 , C88  = decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0)
                                ,0,null,decode(CUR_DATI.gg_anz_c,0,null,CUR_DATI.gg_anz_c))
                 , C89  = decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0)
                                ,0,null,decode( nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0)
                                              ,0,null,nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0)))
                 , C90  = decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0)
                                ,0,null,decode(nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0)
                                               ,0,null,decode( nvl(D_gg_anz_t_2000,0)
                                                             , nvl(D_gg_anz_i_2000,0), null
                                                                                     , round( nvl(D_gg_anz_r_2000,0)
                                                                                            /(nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0))
                                                                                           ,4) * 100
                                                              )))
                 , C91  = decode(D_valorizza,1,null,2,null,decode(D_tfr_mat_3112,0,null,D_tfr_mat_3112))
                 , C92  = decode(D_valorizza,1,null,2,null,decode(CUR_DATI.lor_acc_2000,0,null,CUR_DATI.lor_acc_2000))
                 , C93  = decode(D_valorizza,3,decode(CUR_DATI.ant_acc_2000,0,null,CUR_DATI.ant_acc_2000),null)
                 , C94  = decode(nvl(decode(D_valorizza,3,CUR_DATI.ant_acc_2000,null),0),0,null,D_anno_rif_ind)
                 , C113 = decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                                ,0,null,decode( nvl(D_gg_anz_t,0) - nvl(D_gg_anz_t_2000,0)
                                               ,0,null,nvl(D_gg_anz_t,0) - nvl(D_gg_anz_t_2000,0)))
                 , C114 = decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                                ,0,null,decode(CUR_DATI.gg_anz_c,0,null,CUR_DATI.gg_anz_c))
                 , C115 = decode(D_valorizza                                ,1,null
                                ,2,null
                                  ,decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                                         ,0,null, decode( ( (D_gg_anz_t - D_gg_anz_i) - (D_gg_anz_t_2000 - D_gg_anz_i_2000) )
                                                        ,0,null, (D_gg_anz_t - D_gg_anz_i) - (D_gg_anz_t_2000 - D_gg_anz_i_2000) )
                                         ))
                 , C116 = decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                                         ,0,null, decode((D_gg_anz_t - D_gg_anz_i) - (D_gg_anz_t_2000 - D_gg_anz_i_2000)
                                                         ,0,null, decode( nvl(D_gg_anz_t,0)
                                                                        , nvl(D_gg_anz_i,0), null
                                                                                           , round( nvl(D_gg_anz_r,0)
                                                                                                  /(nvl(D_gg_anz_t,0)
                                                                                                  - nvl(D_gg_anz_i,0))
                                                                                                  ,4) * 100
                                                                         ))))
                 , C117 = decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(D_quota_erede, 100)
                                         , 100, D_tfr_mat_0101
                                              , e_round(D_tfr_mat_0101/100*D_quota_erede,'I' )
                                         )
                                )
                 , C118 = decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(D_quota_erede, 100)
                                         , 100, D_tfr_0101
                                              , e_round(D_tfr_0101/100*D_quota_erede,'I' )
                                         )
                                )
                 , C119 = decode(D_valorizza
                                ,3,decode(nvl(D_quota_erede, 100)
                                         , 100, decode(CUR_DATI.ant_acc_ap,0,null,CUR_DATI.ant_acc_ap)
                                              , e_round(decode(CUR_DATI.ant_acc_ap,0,null,CUR_DATI.ant_acc_ap)/100*D_quota_erede,'I' )
                                         )
                                  ,null
                                )
                 , C120 = decode(nvl(decode(D_valorizza,3,CUR_DATI.ant_acc_ap),0),0,null,D_anno_rif_ind_2001)
                 , C121 = decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(D_quota_erede, 100)
                                         , 100, decode(D_tfr_fp_0101,0,null,D_tfr_fp_0101)
                                              , e_round(decode(D_tfr_fp_0101,0,null,D_tfr_fp_0101)/100*D_quota_erede,'I' )
                                         )
                                )
                 , C122 = decode(D_regime_tfr
                                ,'SI',decode(nvl(D_quota_erede, 100)
                                            , 100, decode(nvl(D_tfr_02,0),0,null, D_altre_ind)
                                                 , e_round(decode(nvl(D_tfr_02,0),0,null, D_altre_ind)/100*D_quota_erede,'I' )
                                            )
                                     , null)
                 , C123 = decode(D_regime_tfr
                                ,'SI',decode(nvl(D_quota_erede, 100)
                                            , 100, decode(nvl(D_tfr_02,0),0,null, CUR_DATI.ant_liq_ap)/100*D_quota_erede,'I' )
                                                 , e_round(decode(nvl(D_tfr_02,0),0,null, CUR_DATI.ant_liq_ap)/100*D_quota_erede,'I' )
                                     , null)
                 , C124 = decode(D_regime_tfr
                                ,'SI',decode(nvl(D_tfr_02,0)
                                             ,0,null
                                               ,decode(CUR_DATI.ant_liq_ap,0,null,D_anno_rif_tfr)
                                            )
                                     , null)
                 , C127 = decode ( sign ( greatest( nvl(D_imp_3112,0) + nvl(D_imp_0101,0) + nvl(D_tfr_03,0), 0) )
                                  , 0, null , decode( D_red_rif, 0, null, D_red_rif) )
                 , C145 = null
                 , C146 = null
                 , C130 = decode(nvl(D_quota_erede, 100)
                                , 100, decode( D_valorizza
                                             , 1, decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                             , 2, decode( (nvl(D_lor_liq,0) - nvl(D_ipn_liq,0))
                                                        ,0, null
                                                          , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                                        )
                                                , decode(sign(D_imp_3112)
                                                        , -1, decode( (CUR_DATI.rid_tot - abs(D_imp_3112))
                                                                    ,0, null, CUR_DATI.rid_tot - abs(D_imp_3112) )
                                                            , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot ) )
                                             )
                                     , e_round( decode( D_valorizza
                                                      , 1, decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                                      , 2, decode( (nvl(D_lor_liq,0) - nvl(D_ipn_liq,0))
                                                                 ,0, null
                                                                   , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                                                 )
                                                         , decode(sign(D_imp_3112)
                                                                 , -1, decode( (CUR_DATI.rid_tot - abs(D_imp_3112))
                                                                             ,0, null, CUR_DATI.rid_tot - abs(D_imp_3112) )
                                                                     , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot ) )
                                                       )
                                              /100*D_quota_erede,'I')
                                 )
                 , C131 = decode(nvl(D_quota_erede, 100)
                                , 100, greatest( nvl(D_imp_3112,0) + nvl(D_imp_0101,0) , 0)
                                     , e_round(greatest( nvl(D_imp_3112,0) + nvl(D_imp_0101,0) , 0)
                                              /100*D_quota_erede,'I')
                                )
                 , C132 = decode(nvl(D_quota_erede, 100)
                                , 100, CUR_DATI.ipt_liq + CUR_DATI.ipt_liq_ap
                                     , e_round( (CUR_DATI.ipt_liq + CUR_DATI.ipt_liq_ap)
                                              /100*D_quota_erede,'I')
                                )
                 , C133 = decode(nvl(D_quota_erede, 100)
                                , 100, decode( CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0)
                                             , 0, null, CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0) )
                                     , e_round(decode( CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0)
                                                     , 0, null, CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0) )
                                              /100*D_quota_erede,'I')
                                )
                 , C134 = decode(nvl(D_quota_erede, 100)
                                , 100, decode( CUR_DATI.ipt_liq_ap, 0, null, CUR_DATI.ipt_liq_ap)
                                     , e_round(decode( CUR_DATI.ipt_liq_ap, 0, null, CUR_DATI.ipt_liq_ap)
                                              /100*D_quota_erede,'I')
                                )
                 , C136 = decode(nvl(D_quota_erede, 100)
                                , 100, nvl(CUR_DATI.ipt_liq,0)-nvl(CUR_DATI.det_liq,0) - nvl(CUR_DATI.dtp_liq,0)
                                     , e_round((nvl(CUR_DATI.ipt_liq,0)-nvl(CUR_DATI.det_liq,0) - nvl(CUR_DATI.dtp_liq,0))
                                              /100*D_quota_erede,'I')
                                 )
                 , C140 = decode(nvl(D_quota_erede, 100)
                                , 100, decode( D_riv_tfr_netto, 0, null, D_riv_tfr_netto )
                                     , e_round(decode( D_riv_tfr_netto, 0, null, D_riv_tfr_netto )
                                              /100*D_quota_erede,'I')
                                )
                 , utente   = D_utente
                 , data_agg = sysdate
             WHERE ci = CUR_CI.ci
               AND anno = D_anno
               AND rilevanza = 'T'
            ;
             IF SQL%ROWCOUNT = 0 THEN
              LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT;
              INSERT INTO denuncia_fiscale 
              ( ANNO, CI, RILEVANZA
              , C108, C109, C75, C76
              , C77, C78, C79, C80, C81, C82, C83, C84, C85, C86
              , C87, C88, C89, C90, C91, C92, C93, C94
              , C113, C114, C115, C116, C117, C118, C119, C120, C121
              , C122, C123, C124
              , C127, C130, C131, C132, C133, C134, C136, C140
              , UTENTE, DATA_AGG )
              VALUES ( D_anno, CUR_CI.ci, 'T'
                     , nvl(D_ini_rap, D_ini_a)                                                -- C108 casella 74
                     , nvl(D_fin_rap, nvl(D_data_richiesta,D_fin_a))                          -- C109 casella 75
                     , decode(D_valorizza,3,D_giorni_sosp,null)                               -- C75 casella 77
                     , decode(D_valorizza,3,decode(D_tempo_det,0, null, D_tempo_det),null)    -- C76 casella 78
                     , decode(nvl(D_ind_equip,0),0,null, D_gg_anz_t)                          -- C77 casella 80
                     , decode(nvl(D_ind_equip,0)
                             ,0,null
                               , decode( CUR_DATI.gg_anz_c, 0, null , CUR_DATI.gg_anz_c ))    -- C78 casella 81
                     , decode(nvl(D_ind_equip,0),0,null, decode( nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0)
                                                               ,0,null,nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0)))  
                                                                                              -- C79 casella 82
                     , decode(nvl(D_ind_equip,0)
                              ,0,null, decode(nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0)
                                               ,0,null,decode( nvl(D_gg_anz_t,0)
                                                                 , nvl(D_gg_anz_i,0), null
                                                                                    , round( nvl(D_gg_anz_r,0)
                                                                                       /(nvl(D_gg_anz_t,0) - nvl(D_gg_anz_i,0))
                                                                                        ,4) * 100
                                                              )))                             -- C80 casella 83
                     , decode(nvl(D_ind_equip,0),0,null,D_ind_equip)                          -- C81 casella 84
                     , decode(D_valorizza
                                ,1, decode(nvl(D_quota_erede, 100)
                                          , 100, decode( CUR_DATI.ant_acc_2000,0, null,CUR_DATI.ant_acc_2000)
                                               , e_round(decode( CUR_DATI.ant_acc_2000,0, null,CUR_DATI.ant_acc_2000)/100*D_quota_erede,'I' )
                                          )
                                  , null )                                                    -- C82 casella 85
                     , decode(nvl(decode(D_valorizza,1,CUR_DATI.ant_acc_2000),0),0,null,D_anno_rif_equip)     -- C83 casella 86
                     , decode(D_regime_tfr
                             ,'NO',decode(nvl(D_quota_erede, 100)
                                         , 100, decode( D_altre_ind,0, null, D_altre_ind )
                                              , e_round( decode( D_altre_ind,0, null, D_altre_ind )/100*D_quota_erede,'I' ))
                                  , null)                                                     -- C84 casella 87
                     , decode(D_valorizza
                                 ,2, decode(D_regime_tfr
                                            ,'NO', decode(nvl(D_quota_erede, 100)
                                                         , 100, decode( CUR_DATI.ant_liq_ap,0,null, CUR_DATI.ant_liq_ap )
                                                              , e_round(decode( CUR_DATI.ant_liq_ap,0,null, CUR_DATI.ant_liq_ap )/100*D_quota_erede,'I' )
                                                         )
                                                 , null)
                                   , null)                                                    -- C85 casella 89
                     , decode(nvl(decode(D_valorizza,2, decode(D_regime_tfr,'NO', CUR_DATI.ant_liq_ap, null), null),0)
                                ,0,null,D_anno_rif_tfr)                                       -- C86 casella 90
                     , decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0),0,null,D_gg_anz_t_2000) -- C87 casella 92
                     , decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0)
                             ,0,null,decode(CUR_DATI.gg_anz_c,0,null,CUR_DATI.gg_anz_c))      -- C88 casella 93
                     , decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0)
                                ,0,null,decode( nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0)
                                              ,0,null,nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0)))       -- C89 casella 94
                     , decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_mat_3112),0)
                              ,0,null,decode(nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0)
                                             ,0,null,decode( nvl(D_gg_anz_t_2000,0)
                                                            , nvl(D_gg_anz_i_2000,0), null
                                                                                    , round( nvl(D_gg_anz_r_2000,0)
                                                                                           /(nvl(D_gg_anz_t_2000,0) - nvl(D_gg_anz_i_2000,0))
                                                                                           ,4) * 100
                                                              )))                             -- C90 casella 95
                     , decode(D_valorizza,1,null,2,null,decode(D_tfr_mat_3112,0,null,D_tfr_mat_3112))               -- C91 casella 96
                     , decode(D_valorizza,1,null,2,null,decode(CUR_DATI.lor_acc_2000,0,null,CUR_DATI.lor_acc_2000)) -- C92 casella 97
                     , decode(D_valorizza,3,decode(CUR_DATI.ant_acc_2000,0,null,CUR_DATI.ant_acc_2000))             -- C93 casella 99
                     , decode(nvl(decode(D_valorizza,3,CUR_DATI.ant_acc_2000,null),0),0,null,D_anno_rif_ind)        -- C94 casella 100
                     , decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                                ,0,null,decode( nvl(D_gg_anz_t,0) - nvl(D_gg_anz_t_2000,0)
                                               ,0,null,nvl(D_gg_anz_t,0) - nvl(D_gg_anz_T_2000,0)))                 -- C113 casella 112
                     , decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                             ,0,null,decode(CUR_DATI.gg_anz_c,0,null,CUR_DATI.gg_anz_c))                            -- C114 casella 113
                     , decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                                         ,0,null, decode( ((D_gg_anz_t - D_gg_anz_i) - (D_gg_anz_t_2000 - D_gg_anz_i_2000) )
                                                        ,0,null, (D_gg_anz_t - D_gg_anz_i) - (D_gg_anz_t_2000 - D_gg_anz_i_2000)
                                                        )
                                         ))                                                                        -- C115 casella 114
                     , decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(decode(D_valorizza,1,null,2,null,D_tfr_0101),0)
                                         ,0,null, decode((D_gg_anz_t - D_gg_anz_i) - (D_gg_anz_t_2000 - D_gg_anz_i_2000)
                                                         ,0,null, decode( nvl(D_gg_anz_t,0)
                                                                            , nvl(D_gg_anz_i,0), null
                                                                                               , round( nvl(D_gg_anz_r,0)
                                                                                                  /(nvl(D_gg_anz_t,0)
                                                                                                  - nvl(D_gg_anz_i,0))
                                                                                                  ,4) * 100
                                                                         ))))                                    -- C116 casella 115
                     , decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(D_quota_erede, 100)
                                         , 100, D_tfr_mat_0101
                                              , e_round(D_tfr_mat_0101/100*D_quota_erede,'I' )
                                         )
                                )                                                                                -- C117 casella 116
                     , decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(D_quota_erede, 100)
                                         , 100, D_tfr_0101
                                              , e_round(D_tfr_0101/100*D_quota_erede,'I' )
                                         )
                                )                                                                                -- C118 casella 117
                     , decode(D_valorizza
                                ,3,decode(nvl(D_quota_erede, 100)
                                         , 100, decode(CUR_DATI.ant_acc_ap,0,null,CUR_DATI.ant_acc_ap)
                                              , e_round(decode(CUR_DATI.ant_acc_ap,0,null,CUR_DATI.ant_acc_ap)/100*D_quota_erede,'I' )
                                         )
                                  ,null
                                )                                                                                -- C119 casella 119
                     , decode(nvl(decode(D_valorizza,3,CUR_DATI.ant_acc_ap),0),0,null,D_anno_rif_ind_2001)       -- C120 casella 120
                     , decode(D_valorizza
                                ,1,null
                                ,2,null
                                  ,decode(nvl(D_quota_erede, 100)
                                         , 100, decode(D_tfr_fp_0101,0,null,D_tfr_fp_0101)
                                              , e_round(decode(D_tfr_fp_0101,0,null,D_tfr_fp_0101)/100*D_quota_erede,'I' )
                                         )
                                )                                                                                -- C121 casella 121
                     , decode(D_regime_tfr
                                ,'SI',decode(nvl(D_quota_erede, 100)
                                            , 100, decode(nvl(D_tfr_02,0),0,null, D_altre_ind)
                                                 , e_round(decode(nvl(D_tfr_02,0),0,null, D_altre_ind)/100*D_quota_erede,'I' )
                                            )
                                     , null)                                                                     -- C122 casella 122
                     , decode(D_regime_tfr
                                ,'SI',decode(nvl(D_quota_erede, 100)
                                            , 100, decode(nvl(D_tfr_02,0),0,null, CUR_DATI.ant_liq_ap)/100*D_quota_erede,'I' )
                                                 , e_round(decode(nvl(D_tfr_02,0),0,null, CUR_DATI.ant_liq_ap)/100*D_quota_erede,'I' )
                                     , null)                                                                     -- C123 casella 124
                     , decode(D_regime_tfr
                                ,'SI',decode(nvl(D_tfr_02,0)
                                             ,0,null
                                               ,decode(CUR_DATI.ant_liq_ap,0,null,D_anno_rif_tfr)
                                            )
                                         , null)                                                                -- C124 casella 125
                     , decode ( sign ( greatest( nvl(D_imp_3112,0) + nvl(D_imp_0101,0) + nvl(D_tfr_03,0), 0) )
                                      , 0, null , decode( D_red_rif, 0, null, D_red_rif) )                      -- C127 casella 150
                     , decode(nvl(D_quota_erede, 100)
                                , 100, decode( D_valorizza
                                             , 1, decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                             , 2, decode( (nvl(D_lor_liq,0) - nvl(D_ipn_liq,0))
                                                        ,0, null
                                                          , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                                        )
                                                , decode(sign(D_imp_3112)
                                                        , -1, decode( (CUR_DATI.rid_tot - abs(D_imp_3112))
                                                                    ,0, null, CUR_DATI.rid_tot - abs(D_imp_3112) )
                                                            , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot ) )
                                             )
                                     , e_round( decode( D_valorizza
                                                      , 1, decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                                      , 2, decode( (nvl(D_lor_liq,0) - nvl(D_ipn_liq,0))
                                                                 ,0, null
                                                                   , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot )
                                                                 )
                                                         , decode(sign(D_imp_3112)
                                                                 , -1, decode( (CUR_DATI.rid_tot - abs(D_imp_3112))
                                                                             ,0, null, CUR_DATI.rid_tot - abs(D_imp_3112) )
                                                                     , decode( CUR_DATI.rid_tot,0, null, CUR_DATI.rid_tot ) )
                                                       )
                                              /100*D_quota_erede,'I')
                                 )                                                                              -- C130 casella 153
                     , decode(nvl(D_quota_erede, 100)
                                , 100, greatest( nvl(D_imp_3112,0) + nvl(D_imp_0101,0) , 0)
                                     , e_round(greatest( nvl(D_imp_3112,0) + nvl(D_imp_0101,0) , 0)/100*D_quota_erede 
                                               ,'I'))                                                           -- C131 casella 154
                     , decode(nvl(D_quota_erede, 100)
                                , 100, CUR_DATI.ipt_liq + CUR_DATI.ipt_liq_ap
                                     , e_round( ( CUR_DATI.ipt_liq + CUR_DATI.ipt_liq_ap )/100*D_quota_erede
                                              ,'I'))                                                            -- C132 casella 155
                     , decode(nvl(D_quota_erede, 100)
                                , 100, decode( CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0)
                                             , 0, null, CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0) )
                                     , e_round(decode( CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0)
                                                     , 0, null, CUR_DATI.det_liq + nvl(CUR_DATI.dtp_liq,0) )
                                              /100*D_quota_erede,'I')
                                )                                                                               -- C133 casella 156
                     ,  decode(nvl(D_quota_erede, 100)
                                , 100, decode( CUR_DATI.ipt_liq_ap, 0, null, CUR_DATI.ipt_liq_ap)
                                     , e_round(decode( CUR_DATI.ipt_liq_ap, 0, null, CUR_DATI.ipt_liq_ap)
                                              /100*D_quota_erede,'I')
                                )                                                                               -- C134 casella 157
                     , decode(nvl(D_quota_erede, 100)
                                , 100, nvl(CUR_DATI.ipt_liq,0)-nvl(CUR_DATI.det_liq,0) - nvl(CUR_DATI.dtp_liq,0)
                                     , e_round((nvl(CUR_DATI.ipt_liq,0)-nvl(CUR_DATI.det_liq,0) - nvl(CUR_DATI.dtp_liq,0))
                                              /100*D_quota_erede,'I'))                                          -- C136 casella 159
                     , decode(nvl(D_quota_erede, 100)
                                , 100, decode( D_riv_tfr_netto, 0, null, D_riv_tfr_netto )
                                     , e_round(decode( D_riv_tfr_netto, 0, null, D_riv_tfr_netto )
                                              /100*D_quota_erede,'I')
                                )                                                                               -- C140 casella 162
                     , D_utente, SYSDATE
                     )
             ;
             END IF;
             commit;

/* Assestamento Aliquote caselle 151 e 152 modello 770/06 */
             BEGIN
              UPDATE denuncia_fiscale
                 set C128 = D_alq_liq_m
               WHERE ci = CUR_CI.ci
                 AND anno = D_anno
                 AND rilevanza = 'T'
                 and nvl(C81,0) + nvl(C92,0) + nvl(C118,0) != 0 -- controllo su caselle 84, 97, 117
              ;
              UPDATE denuncia_fiscale
                 set C129 = D_alq_liq_m
               WHERE ci = CUR_CI.ci
                 AND anno = D_anno
                 AND rilevanza = 'T'
                 and ( nvl(C84,0) + nvl(C98,0) + nvl(C111,0) + nvl(C118,0) + nvl(C125,0) != 0 
                   and nvl(C128,0) = 0 -- controllo su caselle 87, 104, 108, 117, 126, 151
                  or nvl(D_alq_liq_m,0) != 0 and nvl(C128,0) = 0
                     )
              ;
             commit;
             END;
           END;
              BEGIN -- controllo importi negativi
               FOR V_CAMPO IN 
                ( select column_name
                    from user_tab_columns
                   where table_name = 'DENUNCIA_FISCALE'
                     and column_name in ( 'C77', 'C78', 'C79', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86'
                                        , 'C87', 'C88', 'C89', 'C90', 'C91', 'C92', 'C93', 'C94'
                                        , 'C113', 'C114', 'CC15', 'C116', 'C117', 'C118', 'C119', 'C120', 'C121'
                                        , 'C122', 'C123', 'C124'
                                        , 'C127', 'C130', 'C131', 'C132', 'C133', 'C134', 'C135', 'C136', 'C137', 'C138', 'C140'
                                        )
                     and data_type = 'NUMBER'
                    order by column_id
                ) LOOP
                 BEGIN
                   v_select := 'BEGIN select '||V_CAMPO.column_name
                             ||' into peccatfr.V_IMPORTO from denuncia_fiscale where ci = '||cur_ci.ci
                             ||' and rilevanza = ''T'' and anno = '||D_anno||'; END;';
                   si4.sql_execute(v_select);
                   IF nvl(V_IMPORTO,0) < 0 THEN
                      select decode ( V_campo.column_name
                                    , 'C77', '80'
                                    , 'C78', '81'
                                    , 'C79', '82'
                                    , 'C80', '83'
                                    , 'C81', '84'
                                    , 'C82', '85'
                                    , 'C83', '86'
                                    , 'C84', '87'
                                    , 'C85', '89'
                                    , 'C86', '90'
                                    , 'C87', '92'
                                    , 'C88', '93'
                                    , 'C89', '94'
                                    , 'C90', '95'
                                    , 'C91', '96'
                                    , 'C92', '97'
                                    , 'C93', '99'
                                    , 'C94', '100'
                                    , 'C113', '112'
                                    , 'C114', '113'
                                    , 'CC15', '114'
                                    , 'C116', '115'
                                    , 'C117', '116'
                                    , 'C118', '117'
                                    , 'C119', '119'
                                    , 'C120', '120'
                                    , 'C121', '121'
                                    , 'C122', '122'
                                    , 'C123', '124'
                                    , 'C124', '125'
                                    , 'C127', '150'
                                    , 'C130', '153'
                                    , 'C131', '154'
                                    , 'C132', '155'
                                    , 'C133', '156'
                                    , 'C134', '157'
                                    , 'C135', '158'
                                    , 'C136', '159'
                                    , 'C137', '160'
                                    , 'C138', '161'
                                    , 'C140', '162'
                                    , substr( V_campo.column_name, 2 )
                                   )
                        into V_colonna
                       from dual;
                      D_riga := nvl(D_riga,0) + 1;
                      D_errore := ' : Verificare Casella '||V_colonna;
                      INSERT INTO a_segnalazioni_errore
                      (no_prenotazione,passo,progressivo,errore,precisazione)
                      VALUES (prenotazione,1,D_riga,'P05840','Per il CI: '||SUBSTR(TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
                      COMMIT;
                   END IF;
                   END;
               END LOOP; -- v_campo
              END;
           END LOOP; -- CUR_DATI
          END; -- se erede
        WHEN prossimo THEN  null;
        WHEN OTHERS THEN
          D_errore := SUBSTR(SQLERRM,1,30);
          ROLLBACK;
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
          D_riga := nvl(D_riga,0) + 1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES (prenotazione,1,D_riga,'P00109','CI: '||SUBSTR(TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
           COMMIT;
          END;
         END LOOP; -- CUR_CI
         COMMIT;
    END;
  END;
END;
END;
/
