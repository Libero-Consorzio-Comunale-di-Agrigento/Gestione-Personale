CREATE OR REPLACE PACKAGE PECCUD05 IS
/******************************************************************************
 NOME:          PECCUD05 
 DESCRIZIONE:   Estrazione dati per STAMPA MODELLO CUD 2005 - Redditi 2004

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  12/12/2005 MS     Prima Emissione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCUD05 IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 12/12/2005';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number)IS
 BEGIN
DECLARE
--
-- Depositi e Contatori Vari
--
  D_ente            VARCHAR2(4);
  D_ambiente        VARCHAR2(8);
  D_utente          VARCHAR2(8);
  D_dummy           varchar2(1);
  D_dummy_f         varchar2(1);
  D_r1              varchar2(20);
  D_filtro_1        varchar2(15);
  D_filtro_2        varchar2(15);
  D_filtro_3        varchar2(15);
  D_filtro_4        varchar2(15);
  D_tipo            varchar2(1);
  D_estrazione_i    varchar2(1);
  D_tipo_contratto  varchar2(1);
  D_dal             date;
  D_al              date;
  D_min_dal         date;
  D_max_al          date;
  D_max_ass         varchar2(6);
  D_max_d_cess      date;
  D_max_C_cess      varchar2(2);
  D_max_ass_arr     varchar2(6);
  D_min_dal_arr     date;
  D_max_al_arr      date;
  D_da_ci           number;
  D_a_ci            number;
  D_servizio        varchar2(1);
  D_arretrati       varchar2(1);
  D_pagina          number := 0;
  D_pagina_inps     number := 0;
  D_pagina_inpdap   number := 0;
  D_riga            number := 0;
  D_conta_inps      number := 0;
  D_conta_inpdap    number := 0;
  D_stampa_cont_sosp number := 0;
  D_stampa_inq      varchar2(1);
--
-- Variabili di Periodo
--
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
--
-- Variabili di Dettaglio
--
  D_com_nas         varchar2(40);
  D_prov_nas        varchar2(2);
  D_contributi_inpdai varchar2(11);
  D_contributi_inps varchar2(11);
  D_bonus_L243      varchar2(11);
  D_versamento      varchar2(11);
  D_contributi_inpdap varchar2(11);
  D_contributi_tfs  varchar2(11);
  D_contributi_tfr  varchar2(11);
  D_contr_sospesi_2002 varchar2(11);
  D_contr_sospesi_2003 varchar2(11);
  D_contr_sospesi_2004 varchar2(11);
  D_causa_cessazione varchar2(2);
  D_coco_dal         varchar2(8);
  D_coco_al          varchar2(8);
  D_coco_01          varchar2(11);
  D_coco_02          varchar2(11);
  D_coco_03          varchar2(11);
  D_coco_04          varchar2(11);
  D_s1_mal_d         varchar2(2);
  D_s2_mal_d         varchar2(2);
  D_s1_mat_d         varchar2(2);
  D_s2_mat_d         varchar2(2);
  D_s1_m88_d         varchar2(2);
  D_s2_m88_d         varchar2(2);
  D_s1_cig_d         varchar2(2);
  D_s2_cig_d         varchar2(2);
  D_s2_dds_d         varchar2(2);
  D_s1_dl151_d       varchar2(2);
  D_s2_dl151_d       varchar2(2);
  D_s1_m53_d         varchar2(2);
  D_s2_m53_d         varchar2(2);
  D_pre_com          varchar2(1);
  D_num_inpdap      number;
  D_inpdap_cf       varchar2(16);
  D_inpdap_comparto varchar2(2);
  D_inpdap_sottocomparto varchar2(2);
  D_inpdap_qualifica varchar2(6);
  D_inpdap_serv     varchar2(2);
  D_inpdap_perc_l300 number;
  D_inpdap_imp      varchar2(2);
  D_inpdap_cess     date;
  D_inpdap_c_cess   varchar2(2);
  D_inpdap_ass      varchar2(6);
  D_inpdap_mag      varchar2(12);
  D_inpdap_dal      date;
  D_inpdap_al       date;
  D_inpdap_cassa    varchar2(1);
  D_inpdap_gg       number;
  D_inpdap_fisse    number;
  D_inpdap_acce     number;
  D_inpdap_inadel   number;
  D_inpdap_tfr      number;
  D_inpdap_ind_non_a number;
  D_inpdap_premio   number;
  D_inpdap_ril      varchar2(2);
  D_inpdap_rif      number;
  D_inpdap_l_388    varchar2(1);
  D_inpdap_data_decorrenza date;
  D_inpdap_gg_tfr   number;
  D_inpdap_l_165    number;
  D_inpdap_comp_18  number;
  D_tredicesima    number;
  D_iis_conglobata number;
  D_ipn_tfr        number;
  D_gg_mag_1       number;
  D_gg_mag_2       number;
  D_gg_mag_3       number;
  D_gg_mag_4       number;
  D_data_opz_tfr date;
  D_cf_amm_fisse varchar2(16);
  D_cf_amm_acc   varchar2(16);
  D_note_a_r_cr    number;
  D_note_a_r_crc  number;
  D_note_cr       number;
  D_note_a_c_cr   number;
  D_note_a_c_crc  number;
  D_nominativo    varchar2(120);

--
-- Variabili di Exception
--
  NO_101       EXCEPTION;
--
-- Lettura parametri
--
   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
      BEGIN
      select substr(valore,1,4)
           , to_date('01'||substr(valore,1,4),'mmyyyy')
           , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
        into D_anno,D_ini_a,D_fin_a
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              select anno
                   , to_date('01'||to_char(anno),'mmyyyy')
                   , to_date('3112'||to_char(anno),'ddmmyyyy')
                into D_anno,D_ini_a,D_fin_a
                from riferimento_fine_anno
               where rifa_id = 'RIFA';
      END;
      BEGIN
      select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/','a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
        into D_dal
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DAL'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_dal := null;
      END;
      BEGIN
      select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/','a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
        into D_al
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_AL'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_al := null;
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_1
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_1'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_1 := '%';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_2
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_2'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_2 := '%';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_3
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_3'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_3 := '%';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_4
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_4'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_4 := '%';
      END;
      BEGIN
      select substr(valore,1,1)
        into D_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_TIPO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_tipo := null;
      END;
      BEGIN
      select substr(valore,1,1)
        into D_estrazione_i
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ESTRAZIONE_I'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_estrazione_i := null;
      END;
      BEGIN
      select to_number(substr(valore,1,8))
           , to_number(substr(valore,1,8))
        into D_da_ci, D_a_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_CI'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              IF D_tipo = 'S' THEN 
                 D_da_ci := 0;
                 D_a_ci := 0;
              ELSE
                 D_da_ci := 0;
                 D_a_ci  := 99999999;
              END IF;
      END;
      BEGIN
      select substr(valore,1,1)
        into D_tipo_contratto
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_CONTRATTO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_tipo_contratto := null;
      END;
      BEGIN
      select substr(valore,1,1)
        into D_servizio
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_SERVIZIO'
      ;
      END;
      BEGIN
      select substr(valore,1,1)
        into D_arretrati
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ARRETRATI'
      ;
      END;
      BEGIN
      select substr(valore,1,1)
        into D_stampa_inq
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_STAMPA_INQ'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_stampa_inq := null;
      END;
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
      select upper(chiave)
        into D_r1
        from relazione_chiavi_estrazione
       where estrazione = 'FINE_ANNO'
         and sequenza = 1
      ;
      END;

      BEGIN
        D_pagina        := 0;
        D_riga          := 0;
-- dbms_output.put_line('entro nel cursore');
        LOCK TABLE TAB_REPORT_FINE_ANNO IN EXCLUSIVE MODE NOWAIT;
        cursore_fiscale_05.PULISCI_TAB_REPORT_FINE_ANNO;
        cursore_fiscale_05.INSERT_TAB_REPORT_FINE_ANNO (D_anno,D_da_ci,D_a_ci);
        commit;
        LOCK TABLE TAB_REPORT_FINE_ANNO IN EXCLUSIVE MODE NOWAIT;
        FOR CUR_RPFA in cursore_fiscale_05.CUR_RPFA_05 
           (D_anno ,D_filtro_1,D_filtro_2  ,D_filtro_3,D_filtro_4
           ,D_da_ci,D_a_ci,'',D_estrazione_i,'CUD',D_ente,D_ambiente,D_utente)
   	   LOOP
               D_contributi_inps :=null;
               D_contributi_inpdai :=null;
               D_bonus_L243 := null;
               D_versamento := null;
               D_contributi_inpdap :=null;
               D_contributi_tfs :=null;
               D_contributi_tfr :=null;
               D_contr_sospesi_2002 :=null;
               D_contr_sospesi_2003 :=null;
               D_contr_sospesi_2004 :=null;
               D_coco_dal := null;
               D_coco_al  := null;
               D_coco_01  := null;
               D_coco_02  := null;
               D_coco_03  := null;
               D_coco_04  := null;
-- dbms_output.put_line('Trattamento CI: '||CUR_RPFA.ci);
               BEGIN
                 BEGIN
                   select 'x'
                     into D_dummy
                     from classi_rapporto clra
                        , rapporti_individuali rain
                    where rain.ci  = CUR_RPFA.ci
                      and codice   = rain.rapporto
                    ;
                 EXCEPTION
                   WHEN TOO_MANY_ROWS THEN null;
                   WHEN NO_DATA_FOUND THEN RAISE no_101;
                 END;
                 IF D_tipo = 'C' THEN
                   BEGIN
                     select 'x'
                       into D_dummy
                       from riferimento_retribuzione rire
                          , periodi_giuridici pegi
                      where rire.rire_id        = 'RIRE'
                        and pegi.rilevanza = 'P'
                        and pegi.ci         = CUR_RPFA.ci
                        and pegi.dal        =
                           (select max(dal) from periodi_giuridici
                             where rilevanza = 'P'
                               and ci        = pegi.ci
                               and dal      <= nvl(D_al,rire.fin_ela)
                           )
                        and pegi.al between nvl(D_dal,rire.ini_ela)
                                        and nvl(D_al,rire.fin_ela)
                     ;
                   EXCEPTION
                     WHEN TOO_MANY_ROWS THEN null;
                     WHEN NO_DATA_FOUND THEN
                       BEGIN
                         select 'x'
                           into D_dummy
                           from riferimento_retribuzione  rire
                              , periodi_giuridici pegi
                          where rire.rire_id        = 'RIRE'
                            and pegi.rilevanza = 'P'
                            and pegi.ci        = CUR_RPFA.ci
                            and pegi.dal       =
                                (select max(dal) from periodi_giuridici
                                  where rilevanza = 'P'
                                    and ci        = pegi.ci
                                    and dal      <= nvl(D_al,rire.fin_ela)
                                )
                            and pegi.al <=
                                (select last_day
                                        (to_date
                                         (max(lpad(to_char(mese),2,'0')||
                                              to_char(anno)),'mmyyyy'))
                                   from movimenti_fiscali
                                  where ci       = pegi.ci
                                    and last_day
                                        (to_date
                                         (lpad(to_char(mese),2,'0')||
                                          to_char(anno),'mmyyyy'))
                                        between nvl(D_dal,rire.ini_ela)
                                            and nvl(D_al,rire.fin_ela)
                                    and nvl(ipn_ord,0)  + nvl(ipn_liq,0)
                                       +nvl(ipn_ap,0)   + nvl(lor_liq,0)
                                       +nvl(lor_acc,0) != 0
                                    and mensilita != '*AP'
                                );
                       EXCEPTION
                         WHEN TOO_MANY_ROWS THEN null;
                         WHEN NO_DATA_FOUND THEN RAISE no_101;
                       END;
                   END;
                 ELSIF D_tipo = 'A' THEN
                   BEGIN
                     select 'x'
                       into D_dummy
                       from periodi_giuridici pegi
                      where pegi.rilevanza = 'P'
                        and pegi.ci        = CUR_RPFA.ci
                        and pegi.dal      <= D_fin_a
                        and nvl(pegi.al,to_date('3333333','j')) > nvl(D_al,D_fin_a)
                     ;
                   EXCEPTION
                     WHEN TOO_MANY_ROWS THEN null;
                     WHEN NO_DATA_FOUND THEN RAISE no_101;
                   END;
                 END IF;  -- fine verifiche sul D_tipo

                 BEGIN
                   select 'x'
                     into D_dummy_f
                     from progressivi_fiscali        prfi
                    where prfi.anno      = D_anno
                      and prfi.mese      = 12
                      and prfi.mensilita =
                         (select max(mensilita) from mensilita
                           where mese = 12
                             and tipo in ('N','A','S'))
                             and prfi.ci = CUR_RPFA.ci
                           group by prfi.ci
                          having nvl(sum(prfi.ipn_ac),0) +
                                 nvl(sum(prfi.ipn_ap),0) +
                                 nvl(sum(prfi.lor_liq),0) +
                                 nvl(sum(prfi.lor_acc),0) != 0;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN D_dummy_f := null;
                 END;
                 BEGIN
                 select sum(decode(voec.specifica,'ADD_R_CR' , nvl(moco.imp,0),null)),
                        sum(decode(voec.specifica,'ADD_R_CRC', nvl(moco.imp,0),null)), 
                        sum(decode(voec.specifica,'IRPEF_CR' , nvl(moco.imp,0),null)),
                        sum(decode(voec.specifica,'ADD_C_CR' , nvl(moco.imp,0),null)),
                        sum(decode(voec.specifica,'ADD_R_CRC', nvl(moco.imp,0),null))
                 into   D_note_a_r_cr,
                        D_note_a_r_crc,
                        D_note_cr,
                        D_note_a_c_cr,
                        D_note_a_c_crc  
                 from   voci_economiche voec,
                        movimenti_contabili moco
                 where  voec.codice = moco.voce
                 and    moco.ci     = CUR_RPFA.ci
                 and    moco.anno   = D_anno
                 and    voec.specifica in ('ADD_R_CR','ADD_R_CRC','IRPEF_CR','ADD_C_CR','ADD_C_CRC');
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN 
                        D_note_a_r_cr  :=null;
                        D_note_a_r_crc :=null;
                        D_note_cr      :=null;
                        D_note_a_c_cr  :=null;
                        D_note_a_c_crc :=null;  
                 END;
  
                 BEGIN
                 select cognome||' '||nome
                 into d_nominativo
                 from rapporti_individuali 
                 where ci= CUR_RPFA.ci;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN d_nominativo:=' ';
                 END;

                 if  D_tipo = 'T' and D_dummy_f is null and 
                    (D_note_a_r_cr is not null or D_note_a_r_crc is not null or D_note_cr is not null 
                     or D_note_a_c_cr is not null or D_note_a_c_crc is not null) then
                    update a_prenotazioni 
                    set    errore          = 'Esistono importi relativi ad ass. fiscale da certificare per: ' 
                    where  no_prenotazione = prenotazione
                    and nvl(errore,' ')=' ';
                 end if; 

                 if  D_tipo = 'T' and D_dummy_f is null and 
                    (D_note_a_r_cr is not null or D_note_a_r_crc is not null or D_note_cr is not null 
                     or D_note_a_c_cr is not null or D_note_a_c_crc is not null) then
                    update a_prenotazioni 
                    set    errore          = substr(ERRORE||' '||d_nominativo,1,120)
                    where  no_prenotazione = prenotazione;
                 end if; 

-- dbms_output.put_line('Leggo il CI: '||CUR_RPFA.ci);

                 BEGIN
                   select upper(comu.descrizione)                 com_nas
                        , substr( decode( sign(199-comu.cod_provincia)
                                , -1, '  '
                                    , comu.sigla_provincia),1,2)  prov_nas
                     into D_com_nas
                        , D_prov_nas
                     from comuni comu
                    where comu.cod_comune        = CUR_RPFA.comune_nas
                      and comu.cod_provincia     = CUR_RPFA.provincia_nas
                   ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     D_com_nas := ' ';
                     D_prov_nas := ' ';
                 END;

-- dbms_output.put_line('Leggo DEFI del CI: '||CUR_RPFA.ci);

               BEGIN
               select to_char(c106,'ddmmyyyy'),to_char(c107,'ddmmyyyy'),
                      c77,c78,
                      c79,c80,
                      c103
                 into D_coco_dal,D_coco_al,
                      D_coco_01,D_coco_02,
                      D_coco_03,D_coco_04,
                      D_pre_com
                 from denuncia_fiscale
                where ci = CUR_RPFA.ci
                  and anno = D_anno
                  and rilevanza = 'T'
                ;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    D_coco_dal := null;
                    D_coco_al  := null;
                    D_coco_01  := null;
                    D_coco_02  := null;
                    D_coco_03  := null;
                    D_coco_04  := null;
                    D_pre_com  := ' ';
                END;

                 D_pagina  := D_pagina + 1;
                 D_riga    := 1;
-- dbms_output.put_line('Sto per inserire il CI: '||CUR_RPFA.ci);
               --
               --  Inserimento Primo Record Dipendente
               --
                 insert into a_appoggio_stampe
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , lpad(to_char(CUR_RPFA.ci),8,'0')||
                           lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                           lpad(' ',18,' ')||
                           nvl(D_dummy_f,' ')||
                           lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                           rpad(D_r1,20,' ')||
                           rpad(nvl(CUR_RPFA.c1,' '),15,' ')||
                           lpad(to_char(nvl(CUR_RPFA.quota_erede,0)),5,'0')||
                           lpad(to_char(CUR_RPFA.ni),8,'0')
                         )
                 ;
-- dbms_output.put_line('Fatta insert1 per il CI: '||CUR_RPFA.ci);
                 insert into a_appoggio_stampe
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , 150
                         , '}'
                         )
                 ;
-- dbms_output.put_line('Fatta insert2 per il CI: '||CUR_RPFA.ci);
   	           D_riga := 3;
                 insert into a_appoggio_stampe
                 values ( prenotazione
                        , 1
                        , D_pagina
                        , D_riga
                        , rpad(CUR_RPFA.cod_fis,16,' ')||
                          rpad(CUR_RPFA.cognome,40,' ')||
                          rpad(nvl(CUR_RPFA.nome,' '),36,' ')||
                          lpad(CUR_RPFA.data_nas,8,' ')||
                          rpad(nvl(CUR_RPFA.sesso,' '),1,' ')||
                          rpad(D_com_nas,40,' ')||
                          rpad(D_prov_nas,2,' ')||
	                    rpad(nvl(D_pre_com,' '),1,' ')||
                          '{'
                        )
                 ;
-- dbms_output.put_line('Fatta insert3 per il CI: '||CUR_RPFA.ci);
               --
               --  Trattamento dati INPS
               --
                D_riga         := 60;
                D_conta_inps   := 0;
                D_pagina_inps  := D_pagina;
                BEGIN
		    select sum(nvl(c75,0)), sum(nvl(c76,0)), sum(nvl(c135,0)), max(nvl(c141,' '))
                 into D_contributi_inps,D_contributi_inpdai
                    , D_bonus_l243, D_versamento
                 from denuncia_fiscale
                where anno = D_anno
			and rilevanza ='T'
			and ci in (select CUR_RPFA.ci from dual
                              union
                             select ci_erede
                               from RAPPORTI_DIVERSI radi
                              where radi.ci = CUR_RPFA.ci
                                and radi.rilevanza in ('L','R')
                                and radi.anno = D_anno
                            )
                  ;
			EXCEPTION WHEN NO_DATA_FOUND THEN
              		D_contributi_inps :=null;
               		D_contributi_inpdai :=null;
                        D_bonus_l243 := null;
                        D_versamento := null;
			END;
            FOR CUR_INPS in cursore_fiscale_05.CUR_INPS_05 
               (D_anno, CUR_RPFA.ci, D_tipo_contratto, 'CUD', '')
             LOOP
-- dbms_output.put_line('INPS');
-- dbms_output.put_line('CI: '||CUR_RPFA.ci);
-- dbms_output.put_line('RIGA: '||D_riga);
-- dbms_output.put_line('PG: '||D_pagina);
-- dbms_output.put_line('PG_IN: '||D_pagina_inps);
                       BEGIN
                         select to_char(sum(nvl(d1is.sett1_mal_d,0)))    s1_mal_d
                              , to_char(sum(nvl(d1is.sett2_mal_d,0)))    s2_mal_d
                              , to_char(sum(nvl(d1is.sett1_mat_d,0)))    s1_mat_d
                              , to_char(sum(nvl(d1is.sett2_mat_d,0)))    s2_mat_d
                              , to_char(sum(nvl(d1is.sett1_m88_d,0)))    s1_m88_d
                              , to_char(sum(nvl(d1is.sett2_m88_d,0)))    s2_m88_d
                              , to_char(sum(nvl(d1is.sett1_cig_d,0)))    s1_cig_d
                              , to_char(sum(nvl(d1is.sett2_cig_d,0)))    s2_cig_d
                              , to_char(sum(nvl(d1is.sett2_dds_d,0)))    s2_dds_d
                              , to_char(sum(nvl(d1is.sett1_dl151_d,0)))  s1_dl151_d
                              , to_char(sum(nvl(d1is.sett2_dl151_d,0)))  s2_dl151_d
                              , to_char(sum(nvl(d1is.sett1_m53_d,0)))    s1_m53_d
                              , to_char(sum(nvl(d1is.sett2_m53_d,0)))    s2_m53_d
                           into D_s1_mal_d,D_s2_mal_d
                              , D_s1_mat_d,D_s2_mat_d
                              , D_s1_m88_d,D_s2_m88_d
                              , D_s1_cig_d,D_s2_cig_d
                              , D_s2_dds_d
                              , D_s1_dl151_d,D_s2_dl151_d
                              , D_s1_m53_d,D_s2_m53_d
                           from denuncia_o1_inps d1is
                          where d1is.anno     = D_anno
                            and d1is.gestione = CUR_INPS.gest
                            and d1is.qualifica = CUR_INPS.qual
                            and d1is.assicurazioni = CUR_INPS.ass
                            and d1is.tempo_pieno = CUR_INPS.tp
                            and d1is.tempo_determinato = CUR_INPS.td
                            and nvl(d1is.tipo_rapporto,' ') = nvl(CUR_INPS.tipo_rapp,' ')
                            and d1is.ci      in (select CUR_RPFA.ci from dual
                                                  union
                                                 select ci_erede
                                                   from RAPPORTI_DIVERSI radi
                                                  where radi.ci = CUR_RPFA.ci
                                                    and radi.rilevanza in ('L','R')
                                                    and radi.anno = D_anno
                                                 )
                          ;
                       END;
                       D_conta_inps  := D_conta_inps  + 1;
                       --
                       -- Se ci sono più mod. per l'INPS emette più volte i dai anagrafici (uno per modello)
                       --
                       IF D_conta_inps != 1
                        THEN
                            D_pagina_inps  := D_pagina_inps + 1;
                            insert into a_appoggio_stampe
                            select  prenotazione
                                  , 1
                                  , D_pagina_inps
                                  , 1
                                  , lpad(to_char(CUR_RPFA.ci),8,'0')||
                                    lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                                    lpad(' ',18,' ')||
                                    ' '||
                                    lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                                    rpad(D_r1,20,' ')||
                                    rpad(nvl(CUR_RPFA.c1,' '),15,' ')
                              from dual
                             where not exists
                                  (select 'x' from a_appoggio_stampe
                                    where no_prenotazione = prenotazione
                                      and no_passo        = 1
                                      and pagina          = D_pagina_inps
                                      and riga            = 1)
                            ;
                            insert into a_appoggio_stampe
                            select  prenotazione
                                  , 1
                                  , D_pagina_inps
                                  , 150
                                  , '}'
                              from dual
                             where not exists
                                  (select 'x' from a_appoggio_stampe
                                    where no_prenotazione = prenotazione
                                      and no_passo        = 1
                                      and pagina          = D_pagina_inps
                                      and riga            = 150)
                            ;
                            insert into a_appoggio_stampe
                            values ( prenotazione
                                   , 1
                                   , D_pagina_inps
                                   , 3
                                   , rpad(CUR_RPFA.cod_fis,16,' ')||
                                     rpad(CUR_RPFA.cognome,40,' ')||
                                     rpad(nvl(CUR_RPFA.nome,' '),36,' ')||
                                     lpad(CUR_RPFA.data_nas,8,' ')||
                                     rpad(nvl(CUR_RPFA.sesso,' '),1,' ')||
                                     rpad(D_com_nas,40,' ')||
                                     rpad(D_prov_nas,2,' ')||
				             rpad(nvl(D_pre_com,' '),1,' ')||
						 '{'
                                   )
                            ;
                            D_riga := 60;
                        END IF; -- fine inserimento anagrafici in caso di più modelli INPS

                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS01'||
                          rpad(nvl(CUR_INPS.qua_inps,' '),16,' ')||
                          'INPS02'||
                          rpad(nvl(decode(CUR_INPS.tp,'SI','F','P'),' '),16,' ')||
                          'INPS03'||
                          rpad(nvl(CUR_INPS.tempo_det,' '),16,' ')||
                          'INPS04'||
                          rpad(nvl(CUR_INPS.matr_az,' '),16,' ')||
                          'INPS05'||
                          rpad(nvl(CUR_INPS.prov_lav,' '),16,' ')||
                          'INPS06'||
                          rpad(nvl(CUR_INPS.ass_ivs,' '),16,' ')||
                          'INPS07'||
                          rpad(nvl(CUR_INPS.ass_ds,' '),16,' ')||
                          'INPS08'||
                          rpad(nvl(CUR_INPS.ass_altre,' '),16,' ')||
                          'INPS09'||
                          lpad(nvl(CUR_INPS.competenze_corr,' '),16,' ')||
                          'INPS10'||
                          lpad(nvl(CUR_INPS.altre_competenze,' '),16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS11'||
                          lpad(nvl(CUR_INPS.settimane,' '),16,' ')||
                          'INPS12'||
                          lpad(nvl(CUR_INPS.sett_utili,' '),16,' ')||
                          'INPS13'||
                          lpad(nvl(CUR_INPS.giorni,' '),16,' ')||
                          'INPS14'||
                          rpad(CUR_INPS.tutti,16,' ')||
                          'INPS15'||
                          lpad(CUR_INPS.mesi,16,' ')||
                          'INPS16'||
                          rpad(nvl(CUR_INPS.contratto,' '),16,' ')||
                          'INPS17'||
                          rpad(nvl(CUR_INPS.tipo_con,' '),16,' ')||
                          'INPS18'||
                          rpad(nvl(CUR_INPS.livello,' '),16,' ')||
                          'INPS19'||
                          rpad(nvl(to_char(CUR_INPS.data_cess,'ddmmyyyy'),' '),16,' ')||
                          'INPS20'||
                          lpad(nvl(CUR_INPS.tipo_rapp,' '),16,' ')||
                          '{'
                        )
                        ;
-- dbms_output.put_line('Ho scritto la prima riga INPS');
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS21'||
                          rpad(nvl(CUR_INPS.trasf_rapp,' '),16,' ')||
                          'INPS22'||
                          lpad(nvl(CUR_INPS.importo_ap,' '),16,' ')||
                          'INPS23'||
                          rpad(nvl(CUR_INPS.tabella_af,' '),16,' ')||
                          'INPS24'||
                          rpad(nvl(CUR_INPS.nucleo_af,' '),16,' ')||
                          'INPS25'||
                          rpad(CUR_INPS.classe_af,16,' ')||
                          'INPS26'||
                          rpad(CUR_INPS.tipo_c1,16,' ')||
                          'INPS27'||
                          lpad(nvl(CUR_INPS.dal_c1,'0'),16,'0')||
                          'INPS28'||
                          lpad(nvl(CUR_INPS.al_c1,'0'),16,'0')||
                          'INPS29'||
                          lpad(CUR_INPS.imp_c1,16,' ')||
                          'INPS30'||
                          lpad(CUR_INPS.sett_c1,16,' ')||
                          '{'
                        )
                        ;
-- dbms_output.put_line('Ho scritto la seconda riga INPS');
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS31'||
                          lpad(CUR_INPS.gg_r_c1,16,' ')||
                          'INPS32'||
                          lpad(CUR_INPS.gg_u_c1,16,' ')||
                          'INPS33'||
                          lpad(CUR_INPS.gg_nr_c1,16,' ')||
                          'INPS34'||
                          lpad(CUR_INPS.imp_pen_c1,16,' ')||
                          'INPS36'||
                          rpad(CUR_INPS.tipo_c2,16,' ')||
                          'INPS37'||
                          lpad(nvl(CUR_INPS.dal_c2,'0'),16,'0')||
                          'INPS38'||
                          lpad(nvl(CUR_INPS.al_c2,'0'),16,'0')||
                          'INPS39'||
                          lpad(CUR_INPS.imp_c2,16,' ')||
                          'INPS40'||
                          lpad(CUR_INPS.sett_c2,16,' ')||
                          'INPS41'||
                          lpad(CUR_INPS.gg_r_c2,16,' ')||
                          'INPS42'||
                          lpad(CUR_INPS.gg_u_c2,16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS43'||
                          lpad(CUR_INPS.gg_nr_c2,16,' ')||
                          'INPS44'||
                          lpad(CUR_INPS.imp_pen_c2,16,' ')||
                          'INPS46'||
                          rpad(CUR_INPS.tipo_c3,16,' ')||
                          'INPS47'||
                          lpad(nvl(CUR_INPS.dal_c3,'0'),16,'0')||
                          'INPS48'||
                          lpad(nvl(CUR_INPS.al_c3,'0'),16,'0')||
                          'INPS49'||
                          lpad(CUR_INPS.imp_c3,16,' ')||
                          'INPS50'||
                          lpad(CUR_INPS.sett_c3,16,' ')||
                          'INPS51'||
                          lpad(CUR_INPS.gg_r_c3,16,' ')||
                          'INPS52'||
                          lpad(CUR_INPS.gg_u_c3,16,' ')||
                          'INPS53'||
                          lpad(CUR_INPS.gg_nr_c3,16,' ')||
                          'INPS54'||
                          lpad(CUR_INPS.imp_pen_c3,16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS56'||
                          rpad(CUR_INPS.tipo_c4,16,' ')||
                          'INPS57'||
                          lpad(nvl(CUR_INPS.dal_c4,'0'),16,'0')||
                          'INPS58'||
                          lpad(nvl(CUR_INPS.al_c4,'0'),16,'0')||
                          'INPS59'||
                          lpad(CUR_INPS.imp_c4,16,' ')||
                          'INPS60'||
                          lpad(CUR_INPS.sett_c4,16,' ')||
                          'INPS61'||
                          lpad(CUR_INPS.gg_r_c4,16,' ')||
                          'INPS62'||
                          lpad(CUR_INPS.gg_u_c4,16,' ')||
                          'INPS63'||
                          lpad(CUR_INPS.gg_nr_c4,16,' ')||
                          'INPS64'||
                          lpad(CUR_INPS.imp_pen_c4,16,' ')||
                          'INPS65'||
                          lpad(CUR_INPS.sett_d,16,' ')||
                          'INPS66'||
                          lpad(CUR_INPS.imp_rid_d,16,' ')||
                          '{'
                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS67'||
                          lpad(CUR_INPS.imp_cig_d,16,' ')||
                          'INPS68'||
                          lpad(D_s1_mal_d,16,' ')||
                          'INPS69'||
                          lpad(D_s2_mal_d,16,' ')||
                          'INPS70'||
                          lpad(D_s1_mat_d,16,' ')||
                          'INPS71'||
                          lpad(D_s2_mat_d,16,' ')||
                          'INPS72'||
                          lpad(D_s1_dl151_d,16,' ')||
                          'INPS73'||
                          lpad(D_s2_dl151_d,16,' ')||
                          'INPS74'||
                          lpad(D_s1_m88_d,16,' ')||
                          'INPS75'||
                          lpad(D_s2_m88_d,16,' ')||
                          'INPS76'||
                          lpad(D_s1_cig_d,16,' ')||
                          '{'

                        )
                        ;
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_inps
                        , D_riga
                        , 'INPS77'||
                          lpad(D_s2_cig_d,16,' ')||
                          'INPS78'||
                          lpad(D_s1_m53_d,16,' ')||
                          'INPS79'||
                          lpad(D_s2_m53_d,16,' ')||
                          'INPS80'||
                          lpad(D_s2_dds_d,16,' ')||
                          'INPS81'||
                          lpad(decode(CUR_INPS.istituto
                                      ,'INPS',decode( D_conta_inps
                                                   ,1,nvl(D_contributi_inps,'0')
                                                     ,'0')
                                             ,nvl(D_contributi_inpdai,0)),16,' ')||
                          'INPS55'||
                          lpad(decode( D_conta_inps
                                      ,1, nvl(D_bonus_l243,'0')
                                        ,'0'),16,' ')||
                          'INPS99'||
                          lpad(nvl(D_versamento,'0'),16,' ')||
                          '{'
                        )
                        ;
                  END LOOP; -- CUD_INPS
                --
                -- Trattamento dati CO.CO.CO.
                --
                IF D_coco_01 != 0 and D_coco_dal is not null  THEN
-- dbms_output.put_line('Tratto i dati COCO per il CI: '||CUR_RPFA.ci);
                   D_riga:= 70;
                   insert into a_appoggio_stampe
                    values
                    ( prenotazione
                    , 1
                    , D_pagina
                    , D_riga
                    , 'COCO01'||
                     rpad(nvl(D_coco_dal,' '),16,' ')||
                     'COCO02'||
                     rpad(nvl(D_coco_al,' '),16,' ')||
                     'COCO03'||
                     lpad(nvl(D_coco_01,'0'),16,' ')||
                     'COCO04'||
                     lpad(nvl(D_coco_02,'0'),16,' ')||
                     'COCO05'||
                     lpad(nvl(D_coco_03,'0'),16,' ')||
                     'COCO06'||
                     lpad(nvl(D_coco_04,'0'),16,' ')||
                     '{'
                    )
                  ;
                END IF; -- fine trattamento dati CO.CO.CO.
                --
                -- Trattamento dati INPDAP
                --
-- dbms_output.put_line('Tratto i dati INPDAP per il CI: '||CUR_RPFA.ci);
                D_riga         := 80;
                D_conta_inpdap := 0;
                D_pagina_inpdap:= D_pagina;
                D_num_inpdap   := 0;
                D_stampa_cont_sosp   := 1;
		    BEGIN
			select sum(nvl(c81,0)),sum(nvl(c82,0)),sum(nvl(c83,0))
                       , sum(nvl(c136,0)), sum(nvl(c137,0)), sum(nvl(c138,0))
                 into D_contributi_inpdap,D_contributi_tfs,D_contributi_tfr
                    , D_contr_sospesi_2002, D_contr_sospesi_2003, D_contr_sospesi_2004
                 from denuncia_fiscale
                where anno = D_anno
			and rilevanza ='T'
			and ci in (select CUR_RPFA.ci from dual
                              union
                             select ci_erede
                               from RAPPORTI_DIVERSI radi
                              where radi.ci = CUR_RPFA.ci
                                and radi.rilevanza in ('L','R')
                                and radi.anno = D_anno
                             )
                  ;
			EXCEPTION WHEN NO_DATA_FOUND THEN
               		D_contributi_inpdap :=null;
               		D_contributi_tfs :=null;
               		D_contributi_tfr := null;
                        D_contr_sospesi_2002 := null;
                        D_contr_sospesi_2003 := null;
                        D_contr_sospesi_2004 := null;
                END;
		    BEGIN
                  select min(dedp.dal), max(dedp.al)
                       , substr(max(to_number(ltrim(dedp.assicurazioni))),1,1)||
                         substr(max(to_number(ltrim(dedp.assicurazioni))),2,1)||
                         substr(max(to_number(ltrim(dedp.assicurazioni))),3,1)||
                         substr(max(to_number(ltrim(dedp.assicurazioni))),4,1)
                       , max(dedp.data_cessazione)
                       , max(dedp.causa_cessazione)
                    into d_min_dal, d_max_al, d_max_ass, d_max_d_cess, d_max_c_cess
                    from denuncia_inpdap  dedp
                   where dedp.anno = D_anno
                     and dedp.dal <= D_fin_a
                     and dedp.ci   = CUR_RPFA.ci
                  ;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                      D_min_dal :=null;
                      D_max_al  :=null;
                      d_max_ass :=null;
                      d_max_d_cess :=null;
                      d_max_C_cess :=null;
                END;
		    BEGIN
                  select min(dedp.dal), max(dedp.al)
                       , substr(max(to_number(ltrim(dedp.assicurazioni))),1,1)||
                         substr(max(to_number(ltrim(dedp.assicurazioni))),2,1)||
                         substr(max(to_number(ltrim(dedp.assicurazioni))),3,1)||
                         substr(max(to_number(ltrim(dedp.assicurazioni))),4,1)
                    into d_min_dal_arr, d_max_al_arr, d_max_ass_arr
                    from denuncia_inpdap  dedp
                   where dedp.anno = D_anno
                     and dedp.dal <= D_fin_a
                     and dedp.rilevanza = 'A'
                     and dedp.ci   = CUR_RPFA.ci
                  ;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                      D_min_dal_arr :=null;
                      D_max_al_arr  :=null;
                      d_max_ass_arr :=null;
                END;

            FOR CUR_INPDAP IN cursore_fiscale_05.CUR_INPDAP_05
                (D_anno, CUR_RPFA.ci,  D_ini_a, D_fin_a,'')
		LOOP
		 D_num_inpdap      := D_num_inpdap  + 1;
             IF D_num_inpdap = 1 THEN
-- dbms_output.put_line('Tratto il 1^ rec. letto per il CI: '||CUR_RPFA.ci);
                D_inpdap_cf      := CUR_INPDAP.gest_cf;
                D_inpdap_comparto:= CUR_INPDAP.comparto;
                D_inpdap_sottocomparto:= CUR_INPDAP.sottocomparto;
                D_inpdap_qualifica:= CUR_INPDAP.qualifica;
                D_inpdap_serv    := CUR_INPDAP.tipo_servizio;
                D_inpdap_perc_l300   := CUR_INPDAP.perc_l300;
                D_inpdap_imp     := CUR_INPDAP.tipo_impiego;
                D_inpdap_cess    := CUR_INPDAP.data_cess;
                D_inpdap_c_cess  := CUR_INPDAP.causa_cess;
                D_inpdap_ass     := CUR_INPDAP.ass;
                D_inpdap_mag     := CUR_INPDAP.mag;
                D_inpdap_dal     := CUR_INPDAP.dal;
                D_inpdap_al      := CUR_INPDAP.al;
                D_inpdap_cassa   := CUR_INPDAP.cassa_comp;
                D_inpdap_gg      := CUR_INPDAP.gg_utili;
                D_inpdap_fisse   := CUR_INPDAP.comp_fisse;
                D_inpdap_acce    := CUR_INPDAP.comp_accessorie;
                D_inpdap_inadel  := CUR_INPDAP.comp_inadel;
                D_inpdap_tfr     := CUR_INPDAP.comp_tfr;
                D_inpdap_premio  := CUR_INPDAP.premio_prod;
                D_inpdap_ril     := CUR_INPDAP.rilevanza;
                D_inpdap_rif     := CUR_INPDAP.riferimento;
                D_inpdap_ind_non_a := CUR_INPDAP.ind_non_a;
                D_inpdap_l_388     := CUR_INPDAP.legge_388;
        	    D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
 	          D_inpdap_gg_tfr  := CUR_INPDAP.gg_tfr;
	          D_inpdap_l_165   := CUR_INPDAP.l_165;
	          D_inpdap_comp_18 := CUR_INPDAP.comp_18;
	   	    D_tredicesima    := CUR_INPDAP.tredicesima;
	   	    D_iis_conglobata := CUR_INPDAP.iis_conglobata;
	   	    D_ipn_tfr        := CUR_INPDAP.ipn_tfr;
		    D_gg_mag_1       := CUR_INPDAP.gg_mag_1;
		    D_gg_mag_2       := CUR_INPDAP.gg_mag_2;
		    D_gg_mag_3       := CUR_INPDAP.gg_mag_3;
		    D_gg_mag_4       := CUR_INPDAP.gg_mag_4;
		    D_data_opz_tfr :=   CUR_INPDAP.data_opz_tfr;
		    D_cf_amm_fisse :=   CUR_inpdap.cf_amm_fisse;
		    D_cf_amm_acc   :=   CUR_inpdap.cf_amm_acc;
                D_num_inpdap     := D_num_inpdap + 1;
              ELSIF (   D_servizio = '1' and
                        D_arretrati = '1' and 
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ')
                     or D_servizio = '1' and
                        D_arretrati != '1' and CUR_INPDAP.rilevanza = 'S' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') 
                     or D_servizio = '2' and CUR_INPDAP.rilevanza = 'S' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') and
                        nvl(D_inpdap_ass,' ')= nvl(CUR_INPDAP.ass,' ')
                     or D_servizio = '3' and CUR_INPDAP.rilevanza = 'S' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') and
                        nvl(D_inpdap_ass,' ')= nvl(CUR_INPDAP.ass,' ') and
                        nvl(D_inpdap_imp ,' ') = nvl(CUR_INPDAP.tipo_impiego,' ')
                     or D_servizio = '4' and CUR_INPDAP.rilevanza = 'S' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') and
                        nvl(D_inpdap_ass,' ')= nvl(CUR_INPDAP.ass,' ') and
                        nvl(D_inpdap_imp ,' ') = nvl(CUR_INPDAP.tipo_impiego,' ') and
                        nvl(D_inpdap_serv ,' ') = nvl(CUR_INPDAP.tipo_servizio,' ') and
                        nvl(D_inpdap_perc_l300 ,0) = nvl(CUR_INPDAP.perc_l300,0)
                     or D_servizio = '5' and CUR_INPDAP.rilevanza = 'S' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') and
                        nvl(D_inpdap_ass,' ')= nvl(CUR_INPDAP.ass,' ') and
                        nvl(D_inpdap_imp ,' ') = nvl(CUR_INPDAP.tipo_impiego,' ') and
                        nvl(D_inpdap_serv ,' ') = nvl(CUR_INPDAP.tipo_servizio,' ') and
                        nvl(D_inpdap_perc_l300 ,0) = nvl(CUR_INPDAP.perc_l300,0) and
                        nvl(D_inpdap_mag, ' ') = nvl(CUR_INPDAP.mag,' ')
                     or D_servizio = '6' and CUR_INPDAP.rilevanza = 'S' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') and
                        nvl(D_inpdap_ass,' ')= nvl(CUR_INPDAP.ass,' ') and
                        nvl(D_inpdap_imp ,' ') = nvl(CUR_INPDAP.tipo_impiego,' ') and
                        nvl(D_inpdap_serv ,' ') = nvl(CUR_INPDAP.tipo_servizio,' ') and
                        nvl(D_inpdap_perc_l300 ,0) = nvl(CUR_INPDAP.perc_l300,0) and
                        nvl(D_inpdap_mag, ' ') = nvl(CUR_INPDAP.mag,' ') and
                        nvl(D_inpdap_al,to_date('3333333','j')) = CUR_INPDAP.dal - 1 and
                        nvl(to_char(D_inpdap_al,'yyyy'),d_inpdap_rif) = 
                            nvl(to_char(CUR_INPDAP.dal,'yyyy'),CUR_INPDAP.riferimento) 
-- in caso di servizio = '6' somma solo iperiodi identici e consecutivi
                     or D_servizio != '1' and
                        D_arretrati = '1' and CUR_INPDAP.rilevanza = 'A' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ')
                     or D_arretrati = '2' and CUR_INPDAP.rilevanza = 'A' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ')
                     or D_arretrati = '3' and CUR_INPDAP.rilevanza = 'A' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') and
                        nvl(D_inpdap_rif,0) = nvl(CUR_INPDAP.riferimento,0) and
                        nvl(D_inpdap_cassa,' ')= nvl(CUR_INPDAP.cassa_comp,' ')
                    )
               THEN
-- dbms_output.put_line('Tratto un rec. uguale al precedente per il CI: '||CUR_RPFA.ci);
                D_inpdap_comparto:= CUR_INPDAP.comparto;
                D_inpdap_sottocomparto:= CUR_INPDAP.sottocomparto;
                D_inpdap_qualifica:= CUR_INPDAP.qualifica;
                IF D_servizio = '1' and D_arretrati = '1' THEN 
                   D_inpdap_ass       := d_max_ass;
                   D_inpdap_cess      := d_max_d_cess;
                   D_inpdap_c_cess    := d_max_c_cess;
                   D_inpdap_dal       := D_min_dal;
                   D_inpdap_al        := D_max_al;
                   IF CUR_INPDAP.rilevanza = 'S' THEN
                      D_inpdap_imp       := CUR_INPDAP.tipo_impiego;
                      D_inpdap_serv      := CUR_INPDAP.tipo_servizio;
                      D_inpdap_perc_l300 := CUR_INPDAP.perc_l300;
                   END IF;
                ELSIF D_arretrati = '2'  and CUR_INPDAP.rilevanza = 'A' THEN
                   D_inpdap_ass       := d_max_ass_arr;
                   D_inpdap_dal       := D_min_dal_arr;
                   D_inpdap_al        := D_max_al_arr;
                   D_inpdap_imp       := CUR_INPDAP.tipo_impiego;
                   D_inpdap_serv      := CUR_INPDAP.tipo_servizio;
                   D_inpdap_perc_l300 := CUR_INPDAP.perc_l300;
                ELSE
                   D_inpdap_ass       := CUR_INPDAP.ass;
                   D_inpdap_cess      := CUR_INPDAP.data_cess;
                   D_inpdap_c_cess    := CUR_INPDAP.causa_cess;
                   D_inpdap_al        := CUR_INPDAP.al;
                END IF;
                D_inpdap_mag       := CUR_INPDAP.mag;
                D_inpdap_gg        := D_inpdap_gg     + CUR_INPDAP.gg_utili;
                D_inpdap_fisse     := D_inpdap_fisse  + CUR_INPDAP.comp_fisse;
                D_inpdap_acce      := D_inpdap_acce   + CUR_INPDAP.comp_accessorie;
                D_inpdap_inadel    := D_inpdap_inadel + CUR_INPDAP.comp_inadel;
                D_inpdap_tfr       := D_inpdap_tfr + CUR_INPDAP.comp_tfr;
                D_inpdap_premio    := D_inpdap_premio + CUR_INPDAP.premio_prod;
                D_inpdap_ind_non_a := D_inpdap_ind_non_a + CUR_INPDAP.ind_non_a;
                D_inpdap_l_388     := CUR_INPDAP.legge_388;
        	    D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
		    D_inpdap_gg_tfr  := D_inpdap_gg_tfr + CUR_INPDAP.gg_tfr;
		    D_inpdap_l_165   := D_inpdap_l_165 + CUR_INPDAP.l_165;
		    D_inpdap_comp_18 := D_inpdap_comp_18 + CUR_INPDAP.comp_18;
		    D_tredicesima    := D_tredicesima  + CUR_INPDAP.tredicesima;
		    D_iis_conglobata := D_iis_conglobata  + CUR_INPDAP.iis_conglobata;
		    D_ipn_tfr        := D_ipn_tfr  + CUR_INPDAP.ipn_tfr;
		    D_gg_mag_1       := D_gg_mag_1 + CUR_INPDAP.gg_mag_1;
		    D_gg_mag_2       := D_gg_mag_2 + CUR_INPDAP.gg_mag_2;
		    D_gg_mag_3       := D_gg_mag_3 + CUR_INPDAP.gg_mag_3;
		    D_gg_mag_4       := D_gg_mag_4 + CUR_INPDAP.gg_mag_4;
		    D_data_opz_tfr :=   CUR_INPDAP.data_opz_tfr;
		    D_cf_amm_fisse :=   CUR_inpdap.cf_amm_fisse;
		    D_cf_amm_acc   :=   CUR_inpdap.cf_amm_acc;
                D_num_inpdap := D_num_inpdap + 1;
              ELSE
-- dbms_output.put_line('Tratto un rec. diverso dal precedente per il CI: '||CUR_RPFA.ci);
                D_conta_inpdap := D_conta_inpdap + 1;
-- dbms_output.put_line('INPDAP');
-- dbms_output.put_line('CI: '||CUR_RPFA.ci);
-- dbms_output.put_line('DAL: '||CUR_INPDAP.dal);
-- dbms_output.put_line('RIGA: '||D_riga);
-- dbms_output.put_line('PG: '||D_pagina);
-- dbms_output.put_line('PG_IN: '||D_pagina_inpdap);
   BEGIN
     IF D_inpdap_cess is not null
        and D_inpdap_c_cess is null THEN
       BEGIN
         select evra.cat_inpdap
           into D_causa_cessazione
           from periodi_giuridici pegi,
                eventi_rapporto   evra
          where pegi.rilevanza = 'P'
            and pegi.ci        = CUR_RPFA.ci
            and pegi.posizione    = evra.codice
            and pegi.dal       =
                (select max(dal) from periodi_giuridici
                  where rilevanza = 'P'
                    and ci        = CUR_RPFA.ci
                    and dal      <= D_fin_a)
         ;
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
          D_causa_cessazione := ' ';
       END;
     ELSE
       D_causa_cessazione := D_inpdap_c_cess;
     END IF;
   END;
--   D_conta_inpdap  := D_conta_inpdap  + 1;
   IF D_conta_inpdap != 1  THEN
      D_pagina_inpdap  := D_pagina_inpdap + 1;
-- dbms_output.put_line('PG_IN: '||D_pagina_inpdap);
        insert into a_appoggio_stampe
        select  prenotazione
              , 1
              , D_pagina_inpdap
              , 1
              , lpad(to_char(CUR_RPFA.ci),8,'0')||
                lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                lpad(' ',18,' ')||
                ' '||
                lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                rpad(D_r1,20,' ')||
                rpad(nvl(CUR_RPFA.c1,' '),15,' ')
          from dual
         where not exists
              (select 'x' from a_appoggio_stampe
                where no_prenotazione = prenotazione
                  and no_passo        = 1
                  and pagina          = D_pagina_inpdap
                  and riga            = 1)
        ;
-- dbms_output.put_line('Fatta Insert1 (INPDAP)');
        insert into a_appoggio_stampe
        select  prenotazione
              , 1
              , D_pagina_inpdap
              , 150
              , '}'
          from dual
         where not exists
              (select 'x' from a_appoggio_stampe
                where no_prenotazione = prenotazione
                  and no_passo        = 1
                  and pagina          = D_pagina_inpdap
                  and riga            = 150)
        ;
-- dbms_output.put_line('Fatta Insert2 (INPDAP)');
        insert into a_appoggio_stampe
        select   prenotazione
               , 1
               , D_pagina_inpdap
               , 3
               , rpad(CUR_RPFA.cod_fis,16,' ')||
                 rpad(CUR_RPFA.cognome,40,' ')||
                 rpad(nvl(CUR_RPFA.nome,' '),36,' ')||
                 lpad(CUR_RPFA.data_nas,8,' ')||
                 rpad(nvl(CUR_RPFA.sesso,' '),1,' ')||
                 rpad(D_com_nas,40,' ')||
                 rpad(D_prov_nas,2,' ')||
		     rpad(nvl(D_pre_com,' '),1,' ')||
		    '{'
           from dual
         where not exists
              (select 'x' from a_appoggio_stampe
                where no_prenotazione = prenotazione
                  and no_passo        = 1
                  and pagina          = D_pagina_inpdap
                  and riga            = 3)
        ;
-- dbms_output.put_line('Fatta Insert3 (INPDAP)');
        D_conta_inpdap  := 1;
        D_riga := 80;
    END IF; -- fine inserimento dati anagrafici in caso di più modelli INPDAP
    D_riga:= D_riga + 1;
-- dbms_output.put_line('INPDAP: RIGA1: '||D_riga);
-- dbms_output.put_line('PG1: '||D_pagina);
-- dbms_output.put_line('PG_IN1: '||D_pagina_inpdap);
        insert into a_appoggio_stampe
        values
        ( prenotazione
        , 1
        , D_pagina_inpdap
        , D_riga
        , 'INPDAP62'||
          decode( D_stampa_inq
                 ,'X', decode( instr(d_inpdap_ass,'1')
                              , 0, rpad(' ',16,' ')
                              ,'1',rpad(rpad(nvl(D_inpdap_comparto,' '),2,' ')||lpad(' ',1,' ')|| 
                                        rpad(nvl(D_inpdap_sottocomparto,' '),2,' ')||lpad(' ',1,' ')||
                                        rpad(nvl(D_inpdap_qualifica,' '),6,' '),16,' ')
                              )
                     , rpad(rpad(nvl(D_inpdap_comparto,' '),2,' ')||lpad(' ',1,' ')|| 
                            rpad(nvl(D_inpdap_sottocomparto,' '),2,' ')||lpad(' ',1,' ')||
                            rpad(nvl(D_inpdap_qualifica,' '),6,' '),16,' ')
                 )||
          'INPDAP63'||
          rpad(nvl(D_inpdap_cf,' '),16,' ')||
          'INPDAP64'||
          rpad(nvl(to_char(d_inpdap_data_decorrenza,'ddmmyyyy'),' '),16,' ')||
          'INPDAP65'||
          rpad(nvl(to_char(d_inpdap_dal,'ddmmyyyy'),' '),16,' ')||
          'INPDAP66'||
          rpad(nvl(to_char(D_inpdap_al,'ddmmyyyy'),' '),16,' ')||
          'INPDAP67'||
          lpad(nvl(d_inpdap_gg_tfr,'0'),16,' ')||
          'INPDAP68'||
          lpad(nvl(D_causa_cessazione,' '),16,' ')||
          'INPDAP69'||
          rpad(nvl(d_inpdap_ass,' '),16,' ')||
          'INPDAP73'||
          lpad(nvl(d_inpdap_imp,' '),16,' ')||
          'INPDAP74'||
          lpad(nvl(d_inpdap_serv,' '),16,' ')||
          'INPDAP75'||
          rpad(nvl(d_inpdap_cassa,' '),16,' ')||
          '{'
        )
        ;
        D_riga:= D_riga + 1;
-- dbms_output.put_line('INPDAP: RIGA2: '||D_riga);
-- dbms_output.put_line('PG2: '||D_pagina);
-- dbms_output.put_line('PG_IN2: '||D_pagina_inpdap);
        insert into a_appoggio_stampe
        values
         ( prenotazione
         , 1
         , D_pagina_inpdap
         , D_riga
         , 'INPDAP76'||
          lpad(nvl(d_inpdap_gg,'0'),16,' ')||
          'INPDAP77'||
          rpad(substr(nvl(d_inpdap_mag,' '),2,2)||' '||
               decode(substr(nvl(d_inpdap_mag,' '),2,2),null,' ',to_char(nvl(d_gg_mag_1,0))),16,' ')||
          'INPDAP79'||
          rpad(substr(nvl(d_inpdap_mag,' '),5,2)||' '||
               decode(substr(nvl(d_inpdap_mag,' '),5,2),null,' ',to_char(nvl(d_gg_mag_2,0))),16,' ')||
          'INPDAP81'||
          rpad(substr(nvl(d_inpdap_mag,' '),8,2)||' '||
               decode(substr(nvl(d_inpdap_mag,' '),8,2),null,' ',to_char(nvl(d_gg_mag_3,0))),16,' ')||
          'INPDAP83'||
          rpad(substr(nvl(d_inpdap_mag,' '),11,2)||' '||
               decode(substr(nvl(d_inpdap_mag,' '),11,2),null,' ',to_char(nvl(d_gg_mag_4,0))),16,' ')||
          'INPDAP85'||
          lpad(nvl(d_inpdap_fisse,'0'),16,' ')||
          'INPDAP86'||
          lpad(nvl(d_inpdap_acce,'0'),16,' ')||
          'INPDAP87'||
          lpad(nvl(d_inpdap_comp_18,'0'),16,' ')||
          'INPDAP88'||
          lpad(nvl(d_inpdap_inadel,'0'),16,' ')||
          'INPDAP89'||
          lpad(nvl(d_inpdap_tfr,'0'),16,' ')||
          'INPDAP90'||
          lpad(nvl(d_inpdap_premio,'0'),16,' ')||
          'INPDAP91'||
          lpad(nvl(d_inpdap_ind_non_a,'0'),16,' ')||
          '{'
          )
        ;
        D_riga:= D_riga + 1;
-- dbms_output.put_line('INPDAP: RIGA3: '||D_riga);
-- dbms_output.put_line('PG3: '||D_pagina);
-- dbms_output.put_line('PG_IN3: '||D_pagina_inpdap);
        insert into a_appoggio_stampe
        values
         ( prenotazione
         , 1
         , D_pagina_inpdap
         , D_riga
         ,'INPDAP92'||
          lpad(nvl(d_inpdap_l_165,'0'),16,' ')||
          'INPDAP93'||
          lpad(nvl(d_tredicesima,'0'),16,' ')||
          'INPDAP94'||
          rpad(nvl(to_char(d_data_opz_tfr,'ddmmyyyy'),' '),16,' ')||
          'INPDAP95'||
          rpad(nvl(D_cf_amm_fisse,' '),16,' ')||
          'INPDAP96'||
          rpad(nvl(D_cf_amm_acc,' '),16,' ')||
          'INPDAP10'||
          rpad(nvl(d_inpdap_l_388,' '),16,' ')||
          'INPDAP11'||
          lpad(nvl(d_iis_conglobata,'0'),16,' ')||
          'INPDAP12'||
          lpad(nvl(d_ipn_tfr,'0'),16,' ')||
          'INPDAP13'||
          lpad(decode( D_stampa_cont_sosp ,1, nvl(D_contr_sospesi_2002,'0'),'0'),16,' ')||
          'INPDAP14'||
          lpad(decode( D_stampa_cont_sosp ,1, nvl(D_contr_sospesi_2003,'0'),'0'),16,' ')||
          'INPDAP15'||
          lpad(decode( D_stampa_cont_sosp ,1, nvl(D_contr_sospesi_2004,'0'),'0'),16,' ')||
          'INPDAP16'||
          lpad(nvl(D_inpdap_perc_l300,'0'),16,' ')||
          'INPDAP17'||
          rpad('01',16,' ')||
          '{'
          )
        ;
        D_stampa_cont_sosp := 0;
                IF CUR_INPDAP.gest_cf = 'Z'
                   THEN null;
                ELSE D_inpdap_cf      := CUR_INPDAP.gest_cf;
                     D_inpdap_comparto:= CUR_INPDAP.comparto;
                     D_inpdap_sottocomparto:= CUR_INPDAP.sottocomparto;
                     D_inpdap_qualifica:= CUR_INPDAP.qualifica;
                     D_inpdap_serv    := CUR_INPDAP.tipo_servizio;
                     D_inpdap_perc_l300 := CUR_INPDAP.perc_l300;
                     D_inpdap_imp     := CUR_INPDAP.tipo_impiego;
                     D_inpdap_cess    := CUR_INPDAP.data_cess;
                     D_inpdap_c_cess  := CUR_INPDAP.causa_cess;
                     D_inpdap_ass     := CUR_INPDAP.ass;
                     D_inpdap_mag     := CUR_INPDAP.mag;
                     D_inpdap_dal     := CUR_INPDAP.dal;
                     D_inpdap_al      := CUR_INPDAP.al;
                     D_inpdap_cassa   := CUR_INPDAP.cassa_comp;
                     D_inpdap_gg      := CUR_INPDAP.gg_utili;
                     D_inpdap_fisse   := CUR_INPDAP.comp_fisse;
                     D_inpdap_acce    := CUR_INPDAP.comp_accessorie;
                     D_inpdap_inadel  := CUR_INPDAP.comp_inadel;
                     D_inpdap_tfr     := CUR_INPDAP.comp_tfr;
                     D_inpdap_premio  := CUR_INPDAP.premio_prod;
                     D_inpdap_ril     := CUR_INPDAP.rilevanza;
                     D_inpdap_rif     := CUR_INPDAP.riferimento;
                     D_inpdap_ind_non_a := CUR_INPDAP.ind_non_a;
                     D_inpdap_l_388     := CUR_INPDAP.legge_388;
           	         D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
		         D_inpdap_gg_tfr := CUR_INPDAP.gg_tfr;
		         D_inpdap_l_165   := CUR_INPDAP.l_165;
		         D_inpdap_comp_18 := CUR_INPDAP.comp_18;
			   D_tredicesima    := CUR_INPDAP.tredicesima;
			   D_iis_conglobata := CUR_INPDAP.iis_conglobata;
			   D_ipn_tfr        := CUR_INPDAP.ipn_tfr;
			   D_gg_mag_1       := CUR_INPDAP.gg_mag_1;
			   D_gg_mag_2       := CUR_INPDAP.gg_mag_2;
			   D_gg_mag_3       := CUR_INPDAP.gg_mag_3;
			   D_gg_mag_4       := CUR_INPDAP.gg_mag_4;
			   D_data_opz_tfr :=   CUR_INPDAP.data_opz_tfr;
			   D_cf_amm_fisse :=   CUR_inpdap.cf_amm_fisse;
			   D_cf_amm_acc   :=   CUR_inpdap.cf_amm_acc;
                END IF;
              END IF;
  END LOOP; -- CUR_INPDAP
--
-- Trattamento contributi INPDAP
-- 
  D_riga:= 90;
-- dbms_output.put_line('INPDAP: RIGA4: '||D_riga);
-- dbms_output.put_line('PG4: '||D_pagina);
-- dbms_output.put_line('PG_IN4: '||D_pagina_inpdap);
  insert into a_appoggio_stampe
  values
       ( prenotazione
       , 1
       , D_pagina
       , D_riga
       , 'INPDAP95'||
         lpad(nvl(D_contributi_inpdap,'0'),16,' ')||
         'INPDAP96'||
         lpad(nvl(D_contributi_tfs,'0'),16,' ')||
         'INPDAP97'||
         lpad(nvl(D_contributi_tfr,'0'),16,' ')||
      '{'
       )
       ;
  D_pagina  := greatest(D_pagina_inps,D_pagina_inpdap,D_pagina);
  D_pagina  := D_pagina + 1;
  D_riga    := 0;
  EXCEPTION
    WHEN NO_101 THEN null;
  END;
COMMIT;
END LOOP; -- CUR_RPFA
COMMIT;
END;
END;
END;
END;
/
