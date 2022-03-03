CREATE OR REPLACE PACKAGE pecsmcud IS
/******************************************************************************
 NOME:          PECSMCUD
 DESCRIZIONE:   Estrazione dati per STAMPA MODELLO CUD

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
 2    26/01/2004 AM     Adeguamento modifiche per CUD 2004  
 3.0  20/01/2005 MS     Adeguamento modifiche per CUD 2005 
 3.1  20/01/2005 MS     Mod. per attivita 8890 
 3.2  08/02/2005 GM     Mod. per attività 9623
 3.3  02/03/2005 MS     Mod. per attivita 9946
 3.4  23/03/2005 AM     Mod. per attivita 11115
 3.5  29/03/2005 MS     Mod. per attivita 10142
 3.6  12/01/2006 MS     Adeguamento modifiche per CUD 2006 - Att. 12954
 3.7  30/01/2006 MS     Correzioni da test ( att. 13956 )
 3.8  03/02/2006 MS     Aggiunto parametro per stampa previdenziale ( att. 14676 )
 3.9  23/02/2006 MS     Mod. gestione D_versamento ( att. 15062 )
 4.0  27/02/2006 MS     Mod. Estrazione dati EMENS ( Att. 15079 )
 4.1  07/03/2006 MS     Mod. Estrazione mesi EMENS ( Att. 15234 )
 4.2  07/04/2006 MS     Mod. coll. agevolati ( att. 15658 )
 4.3  23/05/2006 MS     Mod. per adeguamento prg 770/2006 ( att. 16250 )
 4.4  30/08/2006 MS     Modifiche cursore DMA ( att. 17255 )
 5.0  19/01/2007 MS     Modifica per Adeguamento CUD/2007 ( att. 19136 + 16555 )
 5.1  31/01/2007 MS     Correzioni da test priorità 1
 5.2  14/02/2007 MS     Correzioni varie ( att. 19637 )
 5.3  16/02/2007 MS     Gestione su CUD Rapporti Precedenti con Liq. ( 17900.1 )
 5.4  13/03/2007 MS     Mod. estrazione D_versamento ( A20120 )
 5.5  13/03/2007 AD     Gestione CUD da Portale
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY pecsmcud IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V5.4 del 13/03/2007';
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
  D_previdenziale   varchar2(1);

  D_dal             date;
  D_al              date;
  D_da_ci           number;
  D_a_ci            number;
  D_pagina          number := 0;
  D_pagina_emens    number := 0;
  D_pagina_inpdap   number := 0;
  D_pagina_dma      number := 0;
  D_riga            number := 0;
  D_ipost           varchar2(1) := '';
  D_conta_inpdap    number := 0;
  D_conta_emens     number := 0;
  D_conta_dma       number := 0;
  D_stampa_cont_sosp number := 0;

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

  D_mese_1          varchar2(1);
  D_mese_2          varchar2(1);
  D_mese_3          varchar2(1);
  D_mese_4          varchar2(1);
  D_mese_5          varchar2(1);
  D_mese_6          varchar2(1);
  D_mese_7          varchar2(1);
  D_mese_8          varchar2(1);
  D_mese_9          varchar2(1);
  D_mese_10         varchar2(1);
  D_mese_11         varchar2(1);
  D_mese_12         varchar2(1);
  D_bonus_L243      varchar2(11);
  D_tutti           varchar2(1);
  D_mesi            varchar2(12); 
  D_versamento      varchar2(11);
  D_dma_ass         varchar2(1);

  D_contr_sospesi_2002 varchar2(11);
  D_contr_sospesi_2003 varchar2(11);
  D_contr_sospesi_2004 varchar2(11);
  D_contr_sospesi_2005 varchar2(11);
  D_contr_sospesi_2006 varchar2(11);  
  D_causa_cessazione varchar2(2);
  D_pre_com          varchar2(1);
  D_evento_eccezionale varchar2(1);
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
  D_contributi_inpdap number;
  D_contributi_tfs    number;
  D_contributi_tfr    number;
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
  utente_portale  varchar2(20); 
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
        into D_previdenziale
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_PREVIDENZIALE'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_previdenziale := null;
      END;

      BEGIN
        select substr(valore,1,1)
          into D_dma_ass
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro       = 'P_DMA_ASS'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          D_dma_ass := ' ';
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

         BEGIN
         select nvl(max(user_oracle),'XXX') 
/* XXX quando non c'è il portale */
           into utente_portale
           from ad4_istanze
          where progetto = 'GP4WEB'
            and ente = d_ente
            ;
         END;

       IF utente_portale != user then 
/* se sto elaborando da P00 lancio la fase altrimenti l'ho già fatto */
        LOCK TABLE TAB_REPORT_FINE_ANNO IN EXCLUSIVE MODE NOWAIT;
        cursore_fiscale.PULISCI_TAB_REPORT_FINE_ANNO;
        cursore_fiscale.INSERT_TAB_REPORT_FINE_ANNO (D_anno,D_da_ci,D_a_ci);
        commit;
       END IF;
 
        LOCK TABLE TAB_REPORT_FINE_ANNO IN EXCLUSIVE MODE NOWAIT;
        FOR CUR_RPFA in cursore_fiscale.CUR_RPFA2 ( D_anno
                                                  , D_filtro_1
                                                  , D_filtro_2
                                                  , D_filtro_3
                                                  , D_filtro_4
                                                  , D_da_ci
                                                  , D_a_ci
                                                  , ''
                                                  , D_estrazione_i
                                                  , 'CUD'
                                                  , D_ente
                                                  , D_ambiente
                                                  , D_utente)
   	   LOOP
               D_versamento := null;
               D_contr_sospesi_2002 :=null;
               D_contr_sospesi_2003 :=null;
               D_contr_sospesi_2004 :=null;
               D_contr_sospesi_2005 :=null;
               D_contr_sospesi_2006 :=null;
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
               select decode( length(ltrim(rtrim(C103)))
                            , 1, C103
                               , '')
                    , decode( length(ltrim(rtrim(C104)))
                            , 1, C104
                               , '')
                 into D_pre_com, D_evento_eccezionale
                 from denuncia_fiscale
                where ci = CUR_RPFA.ci
                  and anno = D_anno
                  and rilevanza = 'T'
                ;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    D_pre_com  := ' ';
                    D_evento_eccezionale := ' ';
                END;

                 D_pagina  := D_pagina + 1;
                 D_riga    := 1;
-- dbms_output.put_line('Sto per inserire il CI: '||CUR_RPFA.ci);
               --
               --  Inserimento Primo Record Dipendente
               --
                 insert into a_appoggio_stampe
                 ( no_prenotazione, no_passo, pagina, riga, testo )
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
                 ( no_prenotazione, no_passo, pagina, riga, testo )
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , 150
                         , '}'
                         )
                 ;
-- dbms_output.put_line('Fatta insert2 per il CI: '||CUR_RPFA.ci);
   	           D_riga := 3;
/* Inserimento dati generali per parte A */
                 insert into a_appoggio_stampe
                 ( no_prenotazione, no_passo, pagina, riga, testo )
                 values ( prenotazione
                        , 1
                        , D_pagina
                        , D_riga
                        , rpad('A1',5,' ')||rpad(CUR_RPFA.cod_fis,16,' ')||
                          rpad('A2',5,' ')||rpad(CUR_RPFA.cognome,40,' ')||
                          rpad('A3',5,' ')||rpad(nvl(CUR_RPFA.nome,' '),36,' ')||
                          rpad('A5',5,' ')||lpad(CUR_RPFA.data_nas,8,' ')||
                          rpad('A4',5,' ')||rpad(nvl(CUR_RPFA.sesso,' '),1,' ')||
                          rpad('A6',5,' ')||rpad(D_com_nas,40,' ')||
                          rpad('A7',5,' ')||rpad(D_prov_nas,2,' ')||
	                  rpad('A8',5,' ')||rpad(nvl(D_pre_com,' '),1,' ')||
	                  rpad('A10',5,' ')||rpad(nvl(D_evento_eccezionale,' '),1,' ')||
                          '{'
                        )
                 ;
-- dbms_output.put_line('Fatta insert3 per il CI: '||CUR_RPFA.ci);
               --
               --  Trattamento dati INPS
               --
                D_riga         := 60;
                D_conta_emens  := 0;
                D_pagina_emens := D_pagina;
                D_mese_1       := null; 
                D_mese_2       := null; 
                D_mese_3       := null; 
                D_mese_4       := null; 
                D_mese_5       := null; 
                D_mese_6       := null; 
                D_mese_7       := null; 
                D_mese_8       := null; 
                D_mese_9       := null; 
                D_mese_10      := null; 
                D_mese_11      := null; 
                D_mese_12      := null; 
                D_tutti        := null;

  IF nvl(D_previdenziale,'Y') != 'X' and nvl(CUR_RPFA.flag_solo_liq,'NO') = 'NO' THEN

    FOR CUR_EMENS in cursore_fiscale.CUR_EMENS ( D_anno, CUR_RPFA.ci,'CUD','')  LOOP

-- dbms_output.put_line('EMENS');
-- dbms_output.put_line('CI: '||CUR_RPFA.ci);
-- dbms_output.put_line('da/a '||CUR_EMENS.mese_da||' '||CUR_EMENS.mese_a);
-- dbms_output.put_line('INPS/ALTRO: '||CUR_EMENS.inps||' / '||CUR_EMENS.altro);
-- dbms_output.put_line('Posizione: '||CUR_EMENS.posizione_inps);
-- dbms_output.put_line('RIGA: '||D_riga);
-- dbms_output.put_line('PG: '||D_pagina);
-- dbms_output.put_line('PG_IN: '||D_pagina_emens);
               BEGIN
               select decode( nvl(c141,'X')
                             ,'X', decode( nvl(CUR_EMENS.imponibile,'0'),'0',null, '5')
                                 , c141
                             )
                 into D_versamento
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
               EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                      BEGIN
                        select decode( nvl(CUR_EMENS.imponibile,'0'),'0',null, '5')
                          into D_versamento
                          from dual;
                      EXCEPTION WHEN NO_DATA_FOUND THEN D_versamento := null;
                      END;
                    WHEN TOO_MANY_ROWS THEN
                      BEGIN
                       select max(decode( nvl(c141,'X')
                                     ,'X', decode( nvl(CUR_EMENS.imponibile,'0'),'0',null, '5')
                                         , c141
                                     ))
                         into D_versamento
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
                      END;
               END;

             IF CUR_EMENS.bonus_id = 1 THEN
               BEGIN
               select round(sum(nvl(dape.imponibile,0)),0)
                 into D_bonus_l243
                 from dati_particolari_emens dape
                where anno = D_anno
                  and ci =  CUR_RPFA.ci
                  and identificatore = 'BONUS'
                  ;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                   D_bonus_l243 := null;
               END;
             ELSE D_bonus_l243 := null;
             END IF;
 
            BEGIN
             select max(decode( substr(riferimento,1,2),'01','Y','X'))
                  , max(decode( substr(riferimento,1,2),'02','Y','X'))
                  , max(decode( substr(riferimento,1,2),'03','Y','X'))
                  , max(decode( substr(riferimento,1,2),'04','Y','X'))
                  , max(decode( substr(riferimento,1,2),'05','Y','X'))
                  , max(decode( substr(riferimento,1,2),'06','Y','X'))
                  , max(decode( substr(riferimento,1,2),'07','Y','X'))
                  , max(decode( substr(riferimento,1,2),'08','Y','X'))
                  , max(decode( substr(riferimento,1,2),'09','Y','X'))
                  , max(decode( substr(riferimento,1,2),'10','Y','X'))
                  , max(decode( substr(riferimento,1,2),'11','Y','X'))
                  , max(decode( substr(riferimento,1,2),'12','Y','X'))
               into D_mese_1, D_mese_2, D_mese_3, D_mese_4, D_mese_5, D_mese_6
                  , D_mese_7, D_mese_8, D_mese_9, D_mese_10, D_mese_11, D_mese_12
               from denuncia_emens deie
                  , gestioni       gest
              where deie.ci in ( select CUR_RPFA.ci from dual
                                 union
                                 select ci_erede
                                   from RAPPORTI_DIVERSI radi
                                  where radi.ci = CUR_RPFA.ci
                                    and radi.rilevanza in ('L','R')
                                    and radi.anno = D_anno
                                )
                and nvl(to_number(substr(riferimento,3,4)),D_anno) = D_anno
                and deie.mese between CUR_EMENS.mese_da and CUR_EMENS.mese_a
                and deie.gestione  = GEST.codice
                and deie.specie_rapporto = CUR_EMENS.specie_rapporto
                and nvl(gest.posizione_inps,'X') = nvl(CUR_EMENS.posizione_inps,'X')
                and nvl(decode(nvl(deie.tipo_contribuzione,'00')
                         ,'0', 'X' ,'00','X' ,'48','X' ,'49','X' ,'52','X' 
                         ,'53','X' ,'54','X' ,'56','X' ,'58','X'
                         ,'61','X' ,'62','X' ,'63','X' ,'65','X'
                         ,'67','X' ,'68','X' ,'69','X' ,'76','X'
                         ,'77','X' ,'99',''),'Y') = nvl(CUR_EMENS.inps,'Y')
                and nvl(decode(nvl(deie.tipo_contribuzione,'00')
                         ,'03','X' ,'10','X' ,'64','X' ,'66','X'
                         ,'70','X' ,'71','X' ,'72','X' ,'73','X' ,''),'Y') = nvl(CUR_EMENS.altro,'Y')
             ;
           EXCEPTION WHEN NO_DATA_FOUND THEN 
                D_mese_1       := null; 
                D_mese_2       := null; 
                D_mese_3       := null; 
                D_mese_4       := null; 
                D_mese_5       := null; 
                D_mese_6       := null; 
                D_mese_7       := null; 
                D_mese_8       := null; 
                D_mese_9       := null; 
                D_mese_10      := null; 
                D_mese_11      := null; 
                D_mese_12      := null; 
                D_tutti        := null; 
           END;

-- dbms_output.put_line('mese 1: '||D_mese_1);
-- dbms_output.put_line('mese 2: '||D_mese_2);
-- dbms_output.put_line('mese 3: '||D_mese_3);
-- dbms_output.put_line('mese 4: '||D_mese_4);
-- dbms_output.put_line('mese 5: '||D_mese_5);
-- dbms_output.put_line('mese 6: '||D_mese_6);
-- dbms_output.put_line('mese 7: '||D_mese_7);
-- dbms_output.put_line('mese 8: '||D_mese_8);
-- dbms_output.put_line('mese 9: '||D_mese_9);
-- dbms_output.put_line('mese 10: '||D_mese_10);
-- dbms_output.put_line('mese 11: '||D_mese_11);
-- dbms_output.put_line('mese 12: '||D_mese_12);

           BEGIN
             select decode(D_mese_1,'Y',' ',D_mese_1)
                  ||decode(D_mese_2,'Y',' ',D_mese_2)
                  ||decode(D_mese_3,'Y',' ',D_mese_3)
                  ||decode(D_mese_4,'Y',' ',D_mese_4)
                  ||decode(D_mese_5,'Y',' ',D_mese_5)
                  ||decode(D_mese_6,'Y',' ',D_mese_6)
                  ||decode(D_mese_7,'Y',' ',D_mese_7)
                  ||decode(D_mese_8,'Y',' ',D_mese_8)
                  ||decode(D_mese_9,'Y',' ',D_mese_9)
                  ||decode(D_mese_10,'Y',' ',D_mese_10)
                  ||decode(D_mese_11,'Y',' ',D_mese_11)
                  ||decode(D_mese_12,'Y',' ',D_mese_12)
               into D_mesi 
               from dual;

                IF   D_mesi = lpad(' ',12,' ') THEN D_tutti := 'X';
                 ELSE D_tutti := ' '; 
                END IF;

-- dbms_output.put_line('D_mesi: '||D_mesi);
-- dbms_output.put_line('D_tutti: '||D_tutti);
              END;

                      D_conta_emens  := D_conta_emens  + 1;
                       --
                       -- Se ci sono più mod. per l'EMENS emette più volte i dai anagrafici (uno per modello)
                       --
                       IF D_conta_emens != 1
                        THEN
                            D_pagina_emens  := D_pagina_emens + 1;
                            insert into a_appoggio_stampe
                            ( no_prenotazione, no_passo, pagina, riga, testo )
                            select  prenotazione
                                  , 1
                                  , D_pagina_emens
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
                                      and pagina          = D_pagina_emens
                                      and riga            = 1)
                            ;
                            insert into a_appoggio_stampe
                            ( no_prenotazione, no_passo, pagina, riga, testo )
                            select  prenotazione
                                  , 1
                                  , D_pagina_emens
                                  , 150
                                  , '}'
                              from dual
                             where not exists
                                  (select 'x' from a_appoggio_stampe
                                    where no_prenotazione = prenotazione
                                      and no_passo        = 1
                                      and pagina          = D_pagina_emens
                                      and riga            = 150)
                            ;
                            insert into a_appoggio_stampe
                           ( no_prenotazione, no_passo, pagina, riga, testo )
                            values ( prenotazione
                                   , 1
                                   , D_pagina_emens
                                   , 3
                                   , rpad('A1',5,' ')||rpad(CUR_RPFA.cod_fis,16,' ')||
                                     rpad('A2',5,' ')||rpad(CUR_RPFA.cognome,40,' ')||
                                     rpad('A3',5,' ')||rpad(nvl(CUR_RPFA.nome,' '),36,' ')||
                                     rpad('A5',5,' ')||lpad(CUR_RPFA.data_nas,8,' ')||
                                     rpad('A4',5,' ')||rpad(nvl(CUR_RPFA.sesso,' '),1,' ')||
                                     rpad('A6',5,' ')||rpad(D_com_nas,40,' ')||
                                     rpad('A7',5,' ')||rpad(D_prov_nas,2,' ')||
	                             rpad('A8',5,' ')||rpad(nvl(D_pre_com,' '),1,' ')||
	                             '{'
                                   )
                            ;
                         D_riga := 60;
                        END IF; -- fine inserimento anagrafici in caso di più modelli EMENS

-- dbms_output.put_line('SR: '||CUR_EMENS.specie_rapporto);
/* aumento la D_riga di 1 comunque, poi la aumenterò ulteriormente se è un COCO
   quindi è corretto prima della IF 
*/
                   D_riga:= D_riga + 1;
                   IF CUR_EMENS.specie_rapporto = 'DIP' THEN
                        insert into a_appoggio_stampe
                       ( no_prenotazione, no_passo, pagina, riga, testo )
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_emens
                        , D_riga
                        , rpad('C1',5,' ')||rpad(nvl(CUR_EMENS.posizione_inps,' '),16,' ')||
                          rpad('C2',5,' ')||rpad(nvl(CUR_EMENS.inps,' '),1,' ')||
                          rpad('C3',5,' ')||rpad(nvl(CUR_EMENS.altro,' '),1,' ')||
                          rpad('C4',5,' ')||lpad(decode(nvl(CUR_EMENS.imponibile,0)
                                                        ,0, ' '
                                                          , nvl(CUR_EMENS.imponibile,' ')
                                                       )
                                                ,16,' ')||
                          rpad('C5',5,' ')||rpad(decode(nvl(D_versamento,' '),'5','X',' '),1,' ')||
                          rpad('C6',5,' ')||rpad(decode(nvl(D_versamento,' '),'6','X',' '),1,' ')||
                          rpad('C7',5,' ')||rpad(decode(nvl(D_versamento,' '),'7','X',' '),1,' ')||
                          rpad('C8',5,' ')||lpad(decode(nvl(CUR_EMENS.ritenuta,0)
                                                        ,0, ' '
                                                          , nvl(CUR_EMENS.ritenuta,' ')
                                                       )
                                                ,16,' ')||
                          rpad('C9',5,' ')||lpad(decode(nvl(D_bonus_l243,'0')
                                                        ,0, ' '
                                                          , nvl(D_bonus_l243,' ')
                                                       )
                                                ,16,' ')||
                          rpad('C10',5,' ')||rpad(nvl(D_tutti,' '),1,' ')||
                          rpad('C11',5,' ')||rpad(nvl(D_mesi,' '),12,' ')||
                          '{'
                        )
                        ;
                   END IF;
                   IF CUR_EMENS.specie_rapporto = 'COCO' THEN
                        D_riga:= D_riga + 1;
                        insert into a_appoggio_stampe
                        ( no_prenotazione, no_passo, pagina, riga, testo )
                        values
                        ( prenotazione
                        , 1
                        , D_pagina_emens
                        , D_riga
                        , rpad('C12',5,' ')||lpad(decode(nvl(CUR_EMENS.imponibile,0)
                                                        ,0, ' '
                                                          , nvl(CUR_EMENS.imponibile,' ')
                                                        )
                                                ,16,' ')||
                          rpad('C13',5,' ')||lpad(decode(nvl(CUR_EMENS.contributo,0)
                                                        ,0, ' '
                                                          , nvl(CUR_EMENS.contributo,' ')
                                                        )
                                                ,16,' ')||
                          rpad('C14',5,' ')||lpad(decode(nvl(CUR_EMENS.ritenuta,0)
                                                        ,0, ' '
                                                          , nvl(CUR_EMENS.ritenuta,' ')
                                                        )
                                                ,16,' ')||
                          rpad('C15',5,' ')||lpad(decode(CUR_EMENS.tipo_agevolazione
                                                        ,null, decode(nvl(CUR_EMENS.contributo,0)
                                                                      ,0, ' '
                                                                        , nvl(CUR_EMENS.contributo,' ')
                                                                      )
                                                             , decode (   nvl(to_number(CUR_EMENS.contributo),0)
                                                                        - nvl(to_number(CUR_EMENS.imp_agevolazione),0)
                                                                      ,0, ' '
                                                                        , nvl(to_char( nvl(to_number(CUR_EMENS.contributo),0)
                                                                                     - nvl(to_number(CUR_EMENS.imp_agevolazione),0))
                                                                             , ' ')
                                                                     )
                                                        )
                                                 ,16,' ')||
                          rpad('C16',5,' ')||rpad(nvl(D_tutti,' '),1,' ')||
                          rpad('C17',5,' ')||rpad(nvl(D_mesi,' '),12,' ')||
                          '{'
                        )
                        ;
-- dbms_output.put_line('Ho scritto la seconda dei COCO EMENS');
                      END IF;
                  END LOOP; -- CUR_EMENS
-- dbms_output.put_line('Tratto i dati DMA per il CI: '||CUR_RPFA.ci);
                D_riga         := 70;
                D_conta_dma    := 0;
                D_pagina_dma   := D_pagina;

      FOR CUR_DMA in cursore_fiscale.CUR_DMA (D_anno, CUR_RPFA.ci, '', D_dma_ass, 'N' )
      LOOP
      D_conta_dma := D_conta_dma + 1;

   IF D_conta_dma != 1  THEN
      D_pagina_dma  := D_pagina_dma + 1;
-- dbms_output.put_line('PG_IN: '||D_pagina_dma);
           --
           -- Se ci sono più mod. per la DMA emette più volte i dai anagrafici (uno per modello)
           --
        insert into a_appoggio_stampe
       ( no_prenotazione, no_passo, pagina, riga, testo )
        select  prenotazione
              , 1
              , D_pagina_dma
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
                  and pagina          = D_pagina_dma
                  and riga            = 1)
        ;
        insert into a_appoggio_stampe
       ( no_prenotazione, no_passo, pagina, riga, testo )
        select  prenotazione
              , 1
              , D_pagina_dma
              , 150
              , '}'
          from dual
         where not exists
              (select 'x' from a_appoggio_stampe
                where no_prenotazione = prenotazione
                  and no_passo        = 1
                  and pagina          = D_pagina_dma
                  and riga            = 150)
        ;
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
        select   prenotazione
               , 1
               , D_pagina_dma
               , 3
               , rpad('A1',5,' ')||rpad(CUR_RPFA.cod_fis,16,' ')||
                 rpad('A2',5,' ')||rpad(CUR_RPFA.cognome,40,' ')||
                 rpad('A3',5,' ')||rpad(nvl(CUR_RPFA.nome,' '),36,' ')||
                 rpad('A5',5,' ')||lpad(CUR_RPFA.data_nas,8,' ')||
                 rpad('A4',5,' ')||rpad(nvl(CUR_RPFA.sesso,' '),1,' ')||
                 rpad('A6',5,' ')||rpad(D_com_nas,40,' ')||
                 rpad('A7',5,' ')||rpad(D_prov_nas,2,' ')||
                 rpad('A8',5,' ')||rpad(nvl(D_pre_com,' '),1,' ')||
                '{'
           from dual
         where not exists
              (select 'x' from a_appoggio_stampe
                where no_prenotazione = prenotazione
                  and no_passo        = 1
                  and pagina          = D_pagina_dma
                  and riga            = 3)
        ;
        D_conta_dma  := 1;
        D_riga := 70;
    END IF; -- fine inserimento dati anagrafici in caso di più modelli DMA 

    D_riga:= D_riga + 1;
-- dbms_output.put_line('INPDAP: RIGA1: '||D_riga);
-- dbms_output.put_line('PG1: '||D_pagina);
-- dbms_output.put_line('PG_IN1: '||D_pagina_dma);
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
        values
        ( prenotazione
        , 1
        , D_pagina_dma
        , D_riga
        , rpad('C18',5,' ')||rpad(nvl(CUR_DMA.gest_cf,' '),16,' ')||
          rpad('C19',5,' ')||rpad(nvl(to_char(CUR_DMA.prog_inpdap),' '),16,' ')||
          rpad('C21',5,' ')||rpad(nvl(CUR_DMA.cassa_pensione,' '),16,' ')||
          rpad('C22',5,' ')||rpad(nvl(CUR_DMA.cassa_previdenza,' '),16,' ')||
          rpad('C23',5,' ')||rpad(nvl(CUR_DMA.cassa_credito,' '),16,' ')||
          rpad('C24',5,' ')||rpad(nvl(CUR_DMA.cassa_enpdedp,' '),16,' ')||
          rpad('C25',5,' ')||rpad(nvl(CUR_DMA.anno_rif,' '),16,' ')||
          rpad('C26',5,' ')||rpad(decode(nvl(CUR_DMA.ipn_pens,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.ipn_pens,' ')),16,' ')||
          rpad('C27',5,' ')||rpad(decode(nvl(CUR_DMA.contr_pens,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.contr_pens,' ')),16,' ')||
          rpad('C28',5,' ')||rpad(decode(nvl(CUR_DMA.ipn_tfs,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.ipn_tfs,' ')),16,' ')||
          rpad('C29',5,' ')||rpad(decode(nvl(CUR_DMA.contr_tfs,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.contr_tfs,' ')),16,' ')||
          rpad('C30',5,' ')||rpad(decode(nvl(CUR_DMA.ipn_tfr,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.ipn_tfr,' ')),16,' ')||
          rpad('C31',5,' ')||rpad(decode(nvl(CUR_DMA.contr_tfr,'0')
                                        ,'0', ' ' 
                                            , nvl(CUR_DMA.contr_tfr,' ')),16,' ')||
          rpad('C32',5,' ')||rpad(decode(nvl(CUR_DMA.ipn_cassa_credito,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.ipn_cassa_credito,' ')),16,' ')||
          rpad('C33',5,' ')||rpad(decode(nvl(CUR_DMA.contr_cassa_credito,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.contr_cassa_credito,' ')),16,' ')||
          rpad('C34',5,' ')||rpad(decode(nvl(CUR_DMA.ipn_enpdedp,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.ipn_enpdedp,' ')),16,' ')||
          rpad('C35',5,' ')||rpad(decode(nvl(CUR_DMA.contr_enpdedp,'0')
                                        ,'0', ' '
                                            , nvl(CUR_DMA.contr_enpdedp,' ')),16,' ')||
          '{'
        );
    END LOOP; -- CUR_DMA
                --
                -- Trattamento dati IPOST 
                --
/* Aggiungo un controllo per verificare se è necessario altrimenti non eseguo la parte di codice */
               BEGIN
                 select 'X' 
                   into D_ipost
                   from dual
                  where exists ( select 'x' 
                                   from denuncia_inpdap
                                  where anno = D_anno
                                    and ci = CUR_RPFA.ci
                                    and previdenza = 'POSTE')
                  ;
               EXCEPTION WHEN NO_DATA_FOUND THEN 
                    D_ipost := '';
               END;
        IF D_ipost = 'X' THEN
-- dbms_output.put_line('Tratto i dati IPOST per il CI: '||CUR_RPFA.ci);
            D_riga         := 80;
            D_conta_inpdap := 0;
            D_pagina_inpdap:= D_pagina;
            D_num_inpdap   := 0;
            D_stampa_cont_sosp   := 1;

            BEGIN
                select sum(nvl(c160,0)), sum(nvl(c161,0)), sum(nvl(c162,0))
                     , sum(nvl(c163,0)), sum(nvl(c164,0))
                  into D_contr_sospesi_2002, D_contr_sospesi_2003, D_contr_sospesi_2004
                     , D_contr_sospesi_2005, D_contr_sospesi_2006
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
                    D_contr_sospesi_2002 := null;
                    D_contr_sospesi_2003 := null;
                    D_contr_sospesi_2004 := null;
                    D_contr_sospesi_2005 := null;
                    D_contr_sospesi_2006 := null;
            END;

      FOR CUR_INPDAP IN cursore_fiscale.CUR_INPDAP (D_anno, CUR_RPFA.ci, D_ini_a, D_fin_a, '')
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
                  D_contributi_inpdap   := CUR_INPDAP.rit_inpdap;
                  D_contributi_tfs := CUR_INPDAP.rit_tfs;
                  D_contributi_tfr := CUR_INPDAP.contr_tfr;
                  D_ipn_tfr        := CUR_INPDAP.ipn_tfr;
                  D_gg_mag_1       := CUR_INPDAP.gg_mag_1;
                  D_gg_mag_2       := CUR_INPDAP.gg_mag_2;
                  D_gg_mag_3       := CUR_INPDAP.gg_mag_3;
                  D_gg_mag_4       := CUR_INPDAP.gg_mag_4;
                  D_data_opz_tfr :=   CUR_INPDAP.data_opz_tfr;
                  D_cf_amm_fisse :=   CUR_inpdap.cf_amm_fisse;
                  D_cf_amm_acc   :=   CUR_inpdap.cf_amm_acc;
                  D_num_inpdap     := D_num_inpdap + 1;
              ELSIF ( CUR_INPDAP.rilevanza = 'S' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ') and
                        nvl(D_inpdap_imp ,' ') = nvl(CUR_INPDAP.tipo_impiego,' ') and
                        nvl(D_inpdap_serv ,' ') = nvl(CUR_INPDAP.tipo_servizio,' ') and
                        nvl(D_inpdap_perc_l300 ,0) = nvl(CUR_INPDAP.perc_l300,0)
                     or CUR_INPDAP.rilevanza = 'A' and
                        nvl(D_inpdap_cf,' ') = nvl(CUR_INPDAP.gest_cf,' ') and
                        nvl(D_inpdap_ril,' ') = nvl(CUR_INPDAP.rilevanza,' ')
                    )
               THEN
-- dbms_output.put_line('Tratto un rec. uguale al precedente per il CI: '||CUR_RPFA.ci);
                  D_inpdap_comparto := CUR_INPDAP.comparto;
                  D_inpdap_sottocomparto := CUR_INPDAP.sottocomparto;
                  D_inpdap_qualifica := CUR_INPDAP.qualifica;
                  D_inpdap_cess      := CUR_INPDAP.data_cess;
                  D_inpdap_c_cess    := CUR_INPDAP.causa_cess;
                  D_inpdap_al        := CUR_INPDAP.al;
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
                  D_contributi_inpdap := D_contributi_inpdap + CUR_INPDAP.rit_inpdap;
                  D_contributi_tfs := D_contributi_tfs + CUR_INPDAP.rit_tfs;
                  D_contributi_tfr := D_contributi_tfr + CUR_INPDAP.contr_tfr;
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
   D_conta_inpdap  := D_conta_inpdap  + 1;
   IF D_conta_inpdap != 1  THEN
      D_pagina_inpdap  := D_pagina_inpdap + 1;
-- dbms_output.put_line('PG_IN: '||D_pagina_inpdap);
                       --
                       -- Se ci sono più mod. per l'IPOST emette più volte i dai anagrafici (uno per modello)
                       --
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
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
        ( no_prenotazione, no_passo, pagina, riga, testo )
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
        ( no_prenotazione, no_passo, pagina, riga, testo )
        select   prenotazione
               , 1
               , D_pagina_inpdap
               , 3
               , rpad('A1',5,' ')||rpad(CUR_RPFA.cod_fis,16,' ')||
                 rpad('A2',5,' ')||rpad(CUR_RPFA.cognome,40,' ')||
                 rpad('A3',5,' ')||rpad(nvl(CUR_RPFA.nome,' '),36,' ')||
                 rpad('A5',5,' ')||lpad(CUR_RPFA.data_nas,8,' ')||
                 rpad('A4',5,' ')||rpad(nvl(CUR_RPFA.sesso,' '),1,' ')||
                 rpad('A6',5,' ')||rpad(D_com_nas,40,' ')||
                 rpad('A7',5,' ')||rpad(D_prov_nas,2,' ')||
                 rpad('A8',5,' ')||rpad(nvl(D_pre_com,' '),1,' ')||
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
-- dbms_output.put_line('inserimento record: ');
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
        values
        ( prenotazione
        , 1
        , D_pagina_inpdap
        , D_riga
        , rpad('C36',5,' ')||rpad(rpad(nvl(D_inpdap_comparto,' '),2,' ')||lpad(' ',1,' ')|| 
                             rpad(nvl(D_inpdap_sottocomparto,' '),2,' ')||lpad(' ',1,' ')||
                             rpad(nvl(D_inpdap_qualifica,' '),6,' '),16,' ')||
          rpad('C37',5,' ')||rpad(nvl(D_inpdap_cf,' '),16,' ')||
          rpad('C38',5,' ')||rpad(nvl(to_char(d_inpdap_data_decorrenza,'ddmmyyyy'),' '),16,' ')||
          rpad('C39',5,' ')||rpad(nvl(to_char(d_inpdap_dal,'ddmmyyyy'),' '),16,' ')||
          rpad('C40',5,' ')||rpad(nvl(to_char(D_inpdap_al,'ddmmyyyy'),' '),16,' ')||
          rpad('C41',5,' ')||lpad(decode(nvl(to_char(d_inpdap_gg_tfr),'0'),'0',' ',nvl(to_char(d_inpdap_gg_tfr),' ')),16,' ')||
          rpad('C42',5,' ')||lpad(nvl(D_causa_cessazione,' '),16,' ')||
          rpad('C43',5,' ')||lpad(nvl(d_inpdap_imp,' '),16,' ')||
          rpad('C44',5,' ')||lpad(nvl(d_inpdap_serv,' '),16,' ')||
          rpad('C45',5,' ')||rpad(nvl(d_inpdap_cassa,' '),16,' ')||
          rpad('C46',5,' ')||lpad(decode(nvl(to_char(d_inpdap_gg),'0'),'0',' ',nvl(to_char(d_inpdap_gg),' ')),16,' ')||
          '{'
        )
        ;
        D_riga:= D_riga + 1;
-- dbms_output.put_line('INPDAP: RIGA2: '||D_riga);
-- dbms_output.put_line('PG2: '||D_pagina);
-- dbms_output.put_line('PG_IN2: '||D_pagina_inpdap);
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
        values
         ( prenotazione
         , 1
         , D_pagina_inpdap
         , D_riga
         ,rpad('C47',5,' ')||rpad(nvl(substr(nvl(d_inpdap_mag,' '),2,2),' '),16,' ')||
          rpad('C48',5,' ')||lpad(decode(substr(nvl(d_inpdap_mag,' '),2,2),null,' ',to_char(nvl(d_gg_mag_1,0))),16,' ')||
          rpad('C49',5,' ')||rpad(nvl(substr(nvl(d_inpdap_mag,' '),5,2),' '),16,' ')||
          rpad('C50',5,' ')||lpad(decode(substr(nvl(d_inpdap_mag,' '),5,2),null,' ',to_char(nvl(d_gg_mag_2,0))),16,' ')||
          rpad('C51',5,' ')||rpad(nvl(substr(nvl(d_inpdap_mag,' '),8,2),' '),16,' ')||
          rpad('C52',5,' ')||lpad(decode(substr(nvl(d_inpdap_mag,' '),8,2),null,' ',to_char(nvl(d_gg_mag_3,0))),16,' ')||
          rpad('C53',5,' ')||rpad(nvl(substr(nvl(d_inpdap_mag,' '),11,2),' '),16,' ')||
          rpad('C54',5,' ')||lpad(decode(substr(nvl(d_inpdap_mag,' '),11,2),null,' ',to_char(nvl(d_gg_mag_4,0))),16,' ')||
          rpad('C55',5,' ')||lpad(decode(nvl(to_char(d_inpdap_fisse),'0'),'0',' ',nvl(to_char(d_inpdap_fisse),' ')),16,' ')||
          rpad('C56',5,' ')||lpad(decode(nvl(to_char(d_inpdap_acce),'0'),'0',' ',nvl(to_char(d_inpdap_acce),' ')),16,' ')||
          rpad('C57',5,' ')||lpad(decode(nvl(to_char(d_inpdap_comp_18),'0'),'0',' ',nvl(to_char(d_inpdap_comp_18),' ')),16,' ')||
          rpad('C58',5,' ')||lpad(decode(nvl(to_char(d_inpdap_inadel),'0'),'0',' ',nvl(to_char(d_inpdap_inadel),' ')),16,' ')||
          rpad('C59',5,' ')||lpad(decode(nvl(to_char(d_inpdap_tfr),'0'),'0',' ',nvl(to_char(d_inpdap_tfr),' ')),16,' ')||
          rpad('C60',5,' ')||lpad(decode(nvl(to_char(d_inpdap_premio),'0'),'0',' ',nvl(to_char(d_inpdap_premio),' ')),16,' ')||
          rpad('C61',5,' ')||lpad(decode(nvl(to_char(d_inpdap_ind_non_a),'0'),'0',' ',nvl(to_char(d_inpdap_ind_non_a),' ')),16,' ')||
          '{'
          )
        ;
        D_riga:= D_riga + 1;
-- dbms_output.put_line('INPDAP: RIGA3: '||D_riga);
-- dbms_output.put_line('PG3: '||D_pagina);
-- dbms_output.put_line('PG_IN3: '||D_pagina_inpdap);
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
        values
         ( prenotazione
         , 1
         , D_pagina_inpdap
         , D_riga
         ,rpad('C62',5,' ')||lpad(decode(nvl(to_char(d_inpdap_l_165),'0'),'0',' ',nvl(to_char(d_inpdap_l_165),' ')),16,' ')||
          rpad('C63',5,' ')||lpad(decode(nvl(to_char(d_tredicesima),'0'),'0',' ',nvl(to_char(d_tredicesima),' ')),16,' ')||
          rpad('C64',5,' ')||rpad(nvl(to_char(d_data_opz_tfr,'ddmmyyyy'),' '),16,' ')||
          rpad('C65',5,' ')||rpad(nvl(D_cf_amm_fisse,' '),16,' ')||
          rpad('C66',5,' ')||rpad(nvl(D_cf_amm_acc,' '),16,' ')||
          rpad('C67',5,' ')||lpad(decode(nvl(to_char(d_contributi_inpdap),'0'),'0',' ',nvl(to_char(d_contributi_inpdap),' ')),16,' ')||
          rpad('C68',5,' ')||lpad(decode(nvl(to_char(d_contributi_tfs),'0'),'0',' ',nvl(to_char(d_contributi_tfs),' ')),16,' ')||
          rpad('C69',5,' ')||lpad(decode(nvl(to_char(d_contributi_tfr),'0'),'0',' ',nvl(to_char(d_contributi_tfr),' ')),16,' ')||
          rpad('C70',5,' ')||rpad(nvl(d_inpdap_l_388,' '),16,' ')||
          rpad('C71',5,' ')||lpad(decode(nvl(to_char(d_iis_conglobata),'0'),'0',' ',nvl(to_char(d_iis_conglobata),' ')),16,' ')||
          rpad('C72',5,' ')||lpad(decode(nvl(to_char(d_ipn_tfr),'0'),'0',' ',nvl(to_char(d_ipn_tfr),' ')),16,' ')||
          rpad('C73',5,' ')||lpad(decode( D_stampa_cont_sosp 
                                         ,1, decode( nvl(D_contr_sospesi_2002,'0'),'0',' ',nvl(D_contr_sospesi_2002,' '))
                                           ,' '),16,' ')||
          rpad('C74',5,' ')||lpad(decode( D_stampa_cont_sosp 
                                         ,1, decode( nvl(D_contr_sospesi_2003,'0'),'0',' ',nvl(D_contr_sospesi_2003,' '))
                                           ,' '),16,' ')||
          rpad('C75',5,' ')||lpad(decode( D_stampa_cont_sosp 
                                         ,1, decode( nvl(D_contr_sospesi_2004,'0'),'0',' ',nvl(D_contr_sospesi_2004,' '))
                                           ,' '),16,' ')||
          rpad('C76',5,' ')||lpad(decode( D_stampa_cont_sosp 
                                         ,1, decode( nvl(D_contr_sospesi_2005,'0'),'0',' ',nvl(D_contr_sospesi_2005,' '))
                                           ,' '),16,' ')||
          rpad('C77',5,' ')||lpad(decode( D_stampa_cont_sosp 
                                         ,1, decode( nvl(D_contr_sospesi_2006,'0'),'0',' ',nvl(D_contr_sospesi_2006,' '))
                                           ,' '),16,' ')||
           rpad('C78',5,' ')||lpad(decode(nvl(to_char(D_inpdap_perc_l300),'0'),'0',' ',nvl(to_char(D_inpdap_perc_l300),' ')),16,' ')||
          '{'
          )
        ;
        D_stampa_cont_sosp := 0;
                IF CUR_INPDAP.gest_cf = 'Z'
                   THEN null;
                ELSE 
                  D_inpdap_cf      := CUR_INPDAP.gest_cf;
                  D_inpdap_comparto:= CUR_INPDAP.comparto;
                  D_inpdap_sottocomparto:= CUR_INPDAP.sottocomparto;
                  D_inpdap_qualifica:= CUR_INPDAP.qualifica;
                  D_inpdap_serv    := CUR_INPDAP.tipo_servizio;
                  D_inpdap_perc_l300 := CUR_INPDAP.perc_l300;
                  D_inpdap_imp     := CUR_INPDAP.tipo_impiego;
                  D_inpdap_cess    := CUR_INPDAP.data_cess;
                  D_inpdap_c_cess  := CUR_INPDAP.causa_cess;
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
                  D_contributi_inpdap   := CUR_INPDAP.rit_inpdap;
                  D_contributi_tfs := CUR_INPDAP.rit_tfs;
                  D_contributi_tfr := CUR_INPDAP.contr_tfr;
                  D_ipn_tfr        := CUR_INPDAP.ipn_tfr;
                  D_gg_mag_1       := CUR_INPDAP.gg_mag_1;
                  D_gg_mag_2       := CUR_INPDAP.gg_mag_2;
                  D_gg_mag_3       := CUR_INPDAP.gg_mag_3;
                  D_gg_mag_4       := CUR_INPDAP.gg_mag_4;
                  D_data_opz_tfr :=   CUR_INPDAP.data_opz_tfr;
                  D_cf_amm_fisse :=   CUR_inpdap.cf_amm_fisse;
                  D_cf_amm_acc   :=   CUR_inpdap.cf_amm_acc;
                END IF;
            END IF; -- controllo su record successivo
         END LOOP; -- CUR_INPDAP
        END IF; -- controllo su D_ipost
 END IF; -- controlli su  D_previdenziale
  D_pagina  := greatest(D_pagina_emens, D_pagina_inpdap, D_pagina_dma, D_pagina);
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
