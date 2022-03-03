/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECCSMFB IS
/******************************************************************************
 NOME:         PECCSMFB
 DESCRIZIONE:  Creazione del flusso per la Denuncia Fiscale 770 / SB su
               supporto magnetico(nastri a bobina o dischetti - ASCII - lung. 4000 crt.).
               Questa fase produce un file secondo un tracciato concordato a livello
               aziendale per via dei limiti di ORACLE che permette di creare record
               di max 250 crt. Una ulteriore elaborazione adeguera' questi files al
               tracciato imposto dal Ministero delle Finanze.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: La gestione che deve risultare come intestataria della denuncia
              deve essere stata inserita in << DGEST >> in modo tale che la
              ragione sociale (campo nome) risulti essere la minore di tutte
              le altre eventualmente inserite.
              Lo stesso risultato si raGgiunge anche inserendo un BLANK prima
              del nome di tutte le gestioni che devono essere escluse.

              Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
              da elaborare.
              Il PARAMETRO D_filtro_1 indica i dipendenti da elaborare.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY PECCSMFB IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN 
DECLARE 
-- Depositi e Contataori Vari
  D_dummy           varchar2(1);
  D_r1              varchar2(20);
  D_filtro_1        varchar2(15);
  D_pagina          number;
  D_riga            number;
  D_modulo          number;
  D_num_ord         number;
-- Variabili di Periodo
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
  D_gg_a            number;
-- Variabili di Ente
  D_cod_fis_dic     varchar2(16);
  D_ente_cf         varchar2(16);
-- Variabili di Dettaglio
  D_cod_fis         varchar2(16);
  D_dep_cod_fis     varchar2(16);
  D_cf_dec          varchar2(16);
  D_ini_rap         varchar2(8);
  D_fin_rap         varchar2(8);
  D_cal_anz         varchar2(10);
  D_gg_anz_t        number;
  D_gg_anz_i        number;
  D_gg_anz_r        number;
  D_gg_anz_c        number;
  D_ratei_anz       number;
  D_alq_liq_m       number;
  D_mese_tfr        varchar2(2);
  D_mese_as         varchar2(2);
  D_anni_tot        varchar2(2);
  D_mesi_tot        varchar2(2);
  D_anni_con        varchar2(2);
  D_mesi_con        varchar2(2);
  D_perc            varchar2(7);
  D_anni            varchar2(2);
  D_mesi            varchar2(2);
  D_red_rif         varchar2(11);
  D_lor_tfr         varchar2(11);
  D_lor_as          varchar2(11);
  D_rit_liq         varchar2(11);
  D_ant_ccnl        varchar2(11);
  D_ant_acc_ap      varchar2(11);
  D_ant_liq_ap      varchar2(11);
  D_ind_tot         varchar2(11);
  D_rid_tot         varchar2(11);
  D_ipn_red_rif     varchar2(11);
  D_alq_fissa       varchar2(6);
  D_alq_liq         varchar2(6);
  D_ipn_tfr         varchar2(11);
  D_ipn_as          varchar2(11);
  D_ipn_ac          varchar2(11);
  D_ipn_liq         varchar2(11);
  D_ipt_liq_ap      varchar2(11);
  D_ipt_ric         varchar2(11);
  D_ipt_tot         varchar2(11);
  D_ipt_sosp        varchar2(11);
  D_diff            varchar2(11);
  D_lor_acc         varchar2(11);
  D_lor_liq         varchar2(11);
  D_ipt_liq         varchar2(11);
  D_tit_ero_1       varchar2(1);
  D_tit_ero_2       varchar2(1);
  D_ind_ere         varchar2(11);
  D_ipt_ere         varchar2(11);
  D_ipt_ere_sosp    varchar2(11);
  I_tit_ero_1       varchar2(1);
  I_tit_ero_2       varchar2(1);

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
      select rpad(ltrim(substr(valore,1,16)),16,' ')
        into D_cod_fis_dic
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_COD_FIS'      
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_cod_fis_dic := null;
      END;
      BEGIN
      select specifica
        into D_cal_anz
        from voci_economiche
       where automatismo = 'IRPEF_LIQ'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_cal_anz := null;
      END;
      BEGIN
      select upper(chiave)  
        into D_r1
        from relazione_chiavi_estrazione 
       where estrazione = 'FISCALE_ANNO'
         and sequenza = 1
      ;
             IF D_r1 = 'GESTIONE' THEN 
                null;
             ELSE 
                select ltrim(nvl(ente.codice_fiscale,ente.partita_iva))
                  into D_cod_fis
                  from ente ente
               ;
             END IF;
      END;
      BEGIN
         D_num_ord       := 0;
         D_modulo        := 1;
         D_pagina        := 0;
         D_riga          := 0;
         FOR CUR_RPFA IN
            (select max(rpad(nvl( D_cod_fis
                            , ltrim(nvl( gest.codice_fiscale
                                        ,gest.partita_iva))),16))  ente_cf
                  , tbfa.ci                                        ci_st
                  , decode( anag.codice_fiscale
                          , anag_p.codice_fiscale, ''
                                                 , radi.ci_erede)  ci_erede
                  , decode( anag.codice_fiscale
                          , anag_p.codice_fiscale, tbfa.ci
                                                 , nvl(radi.ci_erede,tbfa.ci)
                          )                                        ci
                  , translate(to_char(max(radi.quota_erede)),'.',',') quota_erede
                  , decode( anag.codice_fiscale
                          , anag_p.codice_fiscale, ''
                                                 , nvl(radi.tipo_erede,'1')
                          )                                        tipo_erede
                  , anag.codice_fiscale                            cod_fis
                  , max(upper(anag.cognome))                       cognome
                  , nvl(max(upper(anag.nome)),' ')                 nome
                  , max(substr(to_char(anag.data_nas
                                      ,'ddmmyyyy'),1,8))           data_nas
                  , max(anag.sesso)                                sesso
                  , max(upper(comu_n.descrizione))                 com_nas
                  , max(substr( decode( sign(199-comu_n.cod_provincia)
                                  , -1, '  '
                                      , comu_n.sigla_provincia)
                          ,1,2))                                   prov_nas
                  , max(upper(comu_r.descrizione))                 com_res
                  , max(substr(comu_r.sigla_provincia,1,2))        prov_res
                  , max(upper(anag.indirizzo_res))                 ind_res
               from comuni                comu_n
                  , comuni                comu_r
                  , gestioni              gest
                  , rapporti_diversi      radi
                  , anagrafici            anag
                  , anagrafici            anag_p
                  , tabella_fiscale_anno  tbfa
              where gest.codice (+)          = tbfa.c1
                and tbfa.anno                = D_anno
                and nvl(tbfa.c1,' ')      like D_filtro_1
                and anag.ni           =
                   (select ni from rapporti_individuali
                     where ci = tbfa.ci
                   )
                and anag.al                 is null
                and radi.ci             (+)  = tbfa.ci
                and comu_n.cod_comune        = anag.comune_nas
                and comu_n.cod_provincia     = anag.provincia_nas
                and comu_r.cod_comune        = anag.comune_res
                and comu_r.cod_provincia     = anag.provincia_res
                and exists (select 'x' from progressivi_fiscali        prfi
                             where prfi.anno    = tbfa.anno
                               and prfi.mese      = 12
                               and prfi.mensilita =
                                  (select max(mensilita) from mensilita
                                    where mese = 12
                                      and tipo in ('N','A','S'))
                               and prfi.ci = tbfa.ci
                             group by prfi.ci
                            having nvl(sum(prfi.lor_liq),0) +
                                   nvl(sum(prfi.lor_acc),0) != 0
                           )
                and anag_p.ni           =
                   (select ni from rapporti_individuali
                     where ci = nvl(radi.ci_erede,tbfa.ci)
                   )
                and anag_p.al                 is null
              group by tbfa.ci
                     , decode( anag.codice_fiscale
                             , anag_p.codice_fiscale, ''
                                                    , radi.ci_erede)
                     , decode( anag.codice_fiscale
                             , anag_p.codice_fiscale, tbfa.ci
                                                  , nvl(radi.ci_erede,tbfa.ci)
                             )
                     , decode( anag.codice_fiscale
                             , anag_p.codice_fiscale, ''
                                                    , nvl(radi.tipo_erede,'1')
                             )
                     , anag.codice_fiscale
              order by 1,8,9
            ) LOOP

              BEGIN

                D_pagina        := D_pagina  + 1;
                D_num_ord       := D_num_ord + 1;
                D_ente_cf       := CUR_RPFA.ente_cf;

                IF D_num_ord = 6
                   THEN D_num_ord := 1;
                        D_modulo  := D_modulo + 1;
                   ELSE null;
                END IF;

                IF D_num_ord = 1
                   THEN
                     --
                     --  Inserimento Primo Record
                     --
                     D_riga   := 10;
                     D_num_ord := D_num_ord + 1;
                     insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                     values ( prenotazione
                            , 1
                            , D_pagina
                            , D_riga
                            , 'E'||
                              rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                  , 16, ' ')||
                              lpad(to_char(D_modulo),8,'0')||
                              lpad(' ',3,' ')||
                              lpad(' ',25,' ')||
                              lpad('0',8,'0')||
                              lpad(' ',12,' ')||
                              lpad(' ',16,' ')||
                              'SB001001'||
                              rpad(decode(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                         ,CUR_RPFA.ente_cf,' '
                                                          ,CUR_RPFA.ente_cf)
                                  ,16,' ')||
                              '}'
                            )
                     ;
                     D_pagina := D_pagina + 1;
                     D_riga   := 0;
                END IF;

                BEGIN

                D_ini_rap    := null;
                D_fin_rap    := null;
                D_gg_anz_t   := null;
                D_gg_anz_i   := null;
                D_gg_anz_r   := null;
                D_gg_anz_c   := null;
                D_ratei_anz  := null;
                D_mese_tfr   := null;
                D_mese_as    := null;
                D_anni_tot   := null;
                D_mesi_tot   := null;
                D_anni_con   := null;
                D_mesi_con   := null;
                D_perc       := null;
                D_anni       := null;
                D_mesi       := null;
                D_lor_tfr    := null;
                D_lor_as     := null;
                D_rit_liq    := null;
                D_ant_ccnl   := null;
                D_ant_acc_ap := null;
                D_ant_liq_ap := null;
                D_ind_tot    := null;
                D_rid_tot    := null;
                D_red_rif    := null;
                D_ipn_red_rif := null;
                D_alq_fissa  := null;
                D_alq_liq    := null;
                D_alq_liq_m  := null;
                D_ipn_tfr    := null;
                D_ipn_as     := null;
                D_ipn_ac     := null;
                D_ipn_liq    := null;
                D_ipt_liq_ap := null;
                D_ipt_ric    := null;
                D_ipt_tot    := null;
                D_ipt_sosp   := null;
                D_diff       := null;
                D_lor_acc    := null;
                D_lor_liq    := null;
                D_ipt_liq    := null;
                D_tit_ero_1  := null;
                D_tit_ero_2  := null;
                D_ind_ere    := null;
                D_ipt_ere    := null;
                D_ipt_ere_sosp := null;
                D_cf_dec     := null;
                I_tit_ero_1  := null;
                I_tit_ero_2  := null;

                --
                -- Inserimento Primo Record Dipendente
                --

                D_riga   := D_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 1
                       , D_pagina
                       , 0
                       , lpad(to_char(CUR_RPFA.ci_st),8,'0')||
                         lpad(to_char(D_num_ord),2,'0')
                       )
                ;

                D_riga   := D_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 1
                       , D_pagina
                       , D_riga
                       , 'E'||
                         rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                             , 16, ' ')||
                         lpad(to_char(D_modulo),8,'0')||
                         lpad(' ',3,' ')||
                         lpad(' ',25,' ')||
                         lpad('0',8,'0')||
                         lpad(' ',12,' ')||
                         lpad(' ',16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'001'||
                         rpad(CUR_RPFA.cod_fis,16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'002'||
                         rpad(substr(CUR_RPFA.cognome,1,16),16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'002'||
                         decode( greatest(16,length(CUR_RPFA.cognome))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.cognome,17,15)
                                              ,15,' ')
                               )||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'002'||
                         decode( greatest(31,length(CUR_RPFA.cognome))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.cognome,32)
                                              ,'15',' ')
                               )||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'003'||
                         rpad(substr(CUR_RPFA.nome,1,16),16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'003'||
                         decode( greatest(16,length(CUR_RPFA.nome))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.nome,17,15)
                                              ,15,' ')
                               )||
                         '{'
                       )
                ;
                --
                -- Inserimento Secondo Record Dipendente
                --
                D_riga   := D_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 1
                       , D_pagina
                       , D_riga
                       , 'SB'||lpad(to_char(D_num_ord),3,'0')||'003'||
                         decode( greatest(31,length(CUR_RPFA.nome))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.nome,32)
                                              ,'15',' ')
                               )||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'004'||
                         rpad(CUR_RPFA.sesso,16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'005'||
                         lpad(CUR_RPFA.data_nas,16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'006'||
                         rpad(substr(CUR_RPFA.com_nas,1,16),16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'006'||
                         decode( greatest(16,length(CUR_RPFA.com_nas))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.com_nas,17,15)
                                              ,15,' ')
                               )||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'006'||
                         decode( greatest(31,length(CUR_RPFA.com_nas))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.com_nas,32)
                                              ,'15',' ')
                               )||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'007'||
                         rpad(CUR_RPFA.prov_nas,16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'008'||
                         rpad(substr(CUR_RPFA.com_res,1,16),16,' ')||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'008'||
                         decode( greatest(16,length(CUR_RPFA.com_res))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.com_res,17,15)
                                              ,15,' ')
                               )||
                         'SB'||lpad(to_char(D_num_ord),3,'0')||'008'||
                         decode( greatest(31,length(CUR_RPFA.com_res))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(CUR_RPFA.com_res,32)
                                              ,'15',' ')
                               )||
                         '{'
                       )
                ;

                IF CUR_RPFA.ci_erede is null
                   THEN
                    --
                    --  Estrazione Valori Vista
                    --
                    BEGIN
                      select nvl(sum(valore),0)
                        into D_ant_ccnl
                        from valori_contabili_annuali
                       where anno         = D_anno
                         and estrazione   = 'DENUNCIA_102'
                         and colonna      = 'ANT_CCNL'
                         and ci           = CUR_RPFA.ci
                      ;
                      EXCEPTION
                         WHEN NO_DATA_FOUND THEN null
                      ;
                    END;

                    --
                    --  Estrazione Valori Fiscali Mensili
                    --
                    BEGIN
                    select sum(mofi.gg_anz_t)        gg_anz_t
                         , sum(mofi.gg_anz_i)        gg_anz_i
                         , sum(mofi.gg_anz_r)        gg_anz_r
                         , max(mofi.alq_liq)         alq_liq
                      into D_gg_anz_t
                         , D_gg_anz_i
                         , D_gg_anz_r
                         , D_alq_liq_m
                      from progressivi_fiscali    mofi
                     where mofi.ci         = nvl(CUR_RPFA.ci_erede
                                                ,CUR_RPFA.ci)
                       and mofi.anno       = D_anno
                       and mese            =
                          (select max(mese)
                             from movimenti_fiscali
                            where ci   = mofi.ci
                              and anno = mofi.anno
                              and nvl(lor_liq,0) +
                                  nvl(lor_acc,0) != 0
                          )
                       and mensilita       =
                          (select max(mensilita)
                             from mensilita
                            where mese = mofi.mese
                              and tipo in ('A','S','N'))
                    ;
                    EXCEPTION WHEN NO_DATA_FOUND THEN D_gg_anz_t  := null;
                                                      D_gg_anz_i  := null;
                                                      D_gg_anz_r  := null;
                                                      D_alq_liq_m := null;
                    END;

                    BEGIN
                    select titolo_tfr
                         , titolo_as
                      into I_tit_ero_1
                         , I_tit_ero_2
                      from informazioni_extracontabili
                     where ci         = nvl(CUR_RPFA.ci_erede
                                           ,CUR_RPFA.ci)
                       and anno       = D_anno
                    ;
                    EXCEPTION WHEN NO_DATA_FOUND THEN I_tit_ero_1  := null;
                                                      I_tit_ero_2  := null;
                    END;
                    --
                    --  Estrazione Dati Fiscali Dipendente
                    --
                    select nvl(max(prfi.gg_anz_c),0)
                         , (trunc(round(( nvl(D_gg_anz_t,0)
                                      +nvl(max(prfi.gg_anz_c),0))/30)
                                    /12)
                              )                                       anni_tot
                         , greatest(0,(round(( ( nvl(D_gg_anz_t,0)
                                        +nvl(max(prfi.gg_anz_c),0)
                                       )-trunc(round((nvl(D_gg_anz_t,0)
                                                     +nvl(max(prfi.gg_anz_c),0))
                                                    /30)
                                               /12)*360
                                     )/30)
                              ))                                      mesi_tot
                         , (trunc(round(nvl(max(prfi.gg_anz_c),0)
                                    / 30)/12))                        anni_con
                         , (round(( nvl(max(prfi.gg_anz_c),0)
                                      -trunc(round(nvl(max(prfi.gg_anz_c),0)
                                                  /30)/12)*360
                                     )/ 30))                          mesi_con
                         , decode
                            ( nvl(D_gg_anz_t,0)
                            , nvl(D_gg_anz_i,0), null
                                     , translate(to_char(
                                                 round( nvl(D_gg_anz_r,0)
                                                    /(nvl(D_gg_anz_t,0)
                                                      -nvl(D_gg_anz_i,0)
                                                     )
                                                    ,4) * 100),'.',',')
                            )                                          perc
                         , (trunc(round( ( nvl(D_gg_anz_t,0)
                                             -nvl(D_gg_anz_i,0))
                                    / 30)/12))                         anni
                         , (round(( ( nvl(D_gg_anz_t,0)
                                        -nvl(D_gg_anz_i,0)
                                       )
                                      -trunc(round( ( nvl(D_gg_anz_t,0)
                                                     -nvl(D_gg_anz_i,0))
                                            / 30)/12) * 360
                                     ) / 30))                          mesi
                         , ( nvl(sum(prfi.lor_acc),0))      lor_tfr
                         , ( nvl(sum(prfi.lor_liq),0)
                               +nvl(sum(prfi.rit_liq),0)
                              )                                lor_as
                         , (nvl(sum(prfi.rit_liq),0))  rit_liq
                         , (( nvl(sum(prfi.ant_acc_ap),0)
                                +nvl(D_ant_ccnl,0))
                                    )                           ant_acc_ap
                         , (nvl(sum(prfi.ant_liq_ap),0)
                                    )                           ant_liq_ap
                         , ((  nvl(sum(prfi.lor_liq),0)
                                      + nvl(sum(prfi.lor_acc),0)
                                      +nvl(sum(prfi.ant_liq_ap),0)
                                      +nvl(sum(prfi.ant_acc_ap),0)
                                     ) )                       ind_tot
                         , (  nvl(sum(prfi.rid_liq),0)
                               + nvl(sum(prfi.rtp_liq),0))            rid_tot
                         , ((
                               decode( nvl(sum(prfi.lor_acc),0)
                                     , 0, nvl(sum(prfi.lor_liq),0)
                                        , nvl(sum(prfi.lor_acc),0)
                                     )
                                   + nvl(sum(prfi.ant_acc_ap),0)
                                     ) )                       ipn_red_rif
                         , translate(to_char((D_alq_liq_m)),'.',',') alq_liq
                         , (  nvl(sum(prfi.ipn_liq),0)
                               -(nvl(sum(prfi.lor_liq),0)
                                +nvl(sum(prfi.ant_liq_ap),0))
                              )                             ipn_tfr
                         , ( nvl(sum(prfi.lor_liq),0)
                               +nvl(sum(prfi.ant_liq_ap),0)
                              )                              ipn_as
                         , (( nvl(sum(prfi.ipn_liq),0)
                                -decode( sum(prfi.ipn_liq_ap)
                                       , 0, to_number('')
                                          , sum(prfi.ipn_liq_ap)
                                       )) )                    ipn_ac
                         , (nvl(sum(prfi.ipn_liq),0))       ipn_liq
                         , (nvl(sum(prfi.ipt_liq_ap),0))    ipt_liq_ap
                         , (
                               decode
                                ( greatest( 2
                                          , ( e_round(nvl(sum(prfi.ipn_liq),0)
                                                       *nvl(D_alq_liq_m,0)
                                                       /100,'I')
                                                -( nvl(sum(prfi.ipt_liq),0)
                                                  +nvl(sum(prfi.ipt_liq_ap),0)
                                                 )))
                                , 2, nvl(sum(prfi.ipt_liq),0)
                                    +nvl(sum(prfi.ipt_liq_ap),0)
                                   , e_round(nvl(sum(prfi.ipn_liq),0)
                                          *nvl(D_alq_liq_m,0)/100,'I')
                                ) )                         ipt_ric
                         , ( nvl(sum(prfi.ipt_liq),0))   ipt_tot
                         , (
                               decode
                                ( greatest( 2
                                          , ( nvl(sum(prfi.ipt_liq),0)
                                             +nvl(sum(prfi.ipt_liq_ap),0))
                                           -e_round( nvl(sum(prfi.ipn_liq),0)
                                                  *nvl(D_alq_liq_m,0)/100,'I')
                                                 )
                                , 2, 0
                                   , ( nvl(sum(prfi.ipt_liq),0)
                                      +nvl(sum(prfi.ipt_liq_ap),0))
                                    -e_round( nvl(sum(prfi.ipn_liq),0)
                                           *nvl(D_alq_liq_m,0)/100,'I')
                                ) ) *
                           decode( nvl(sum(prfi.fdo_tfr_ap),0)
                                 , 0, 1, 0)                 diff
                         , (nvl(sum(prfi.lor_acc),0))    lor_acc
                         , (nvl(sum(prfi.lor_liq),0))    lor_liq
                         , (nvl(sum(prfi.ipt_liq),0))    ipt_liq
                         , (nvl(sum(prfi.somme_19),0))      ipt_sosp
                         , nvl(I_tit_ero_1
                              ,decode( nvl(sum(prfi.lor_acc),0)
                                     , 0, null
                                        , decode
                                          ( nvl(sum(prfi.fdo_tfr_ap),0)
                                           -nvl(sum(prfi.fdo_tfr_ap_liq),0)
                                          , 0, 'B'
                                             , decode( D_fin_rap
                                                     , null, 'A'
                                                           , 'C')
                                          )
                                     ))                               tit_ero_1
                         , nvl(I_tit_ero_2
                              ,decode( nvl(sum(prfi.lor_liq),0)
                                 , 0, null
                                    , decode( nvl(sum(prfi.fdo_tfr_ap),0)
                                             -nvl(sum(prfi.fdo_tfr_ap_liq),0)
                                            , 0, 'B'
                                               , decode( D_fin_rap
                                                       , null, 'A'
                                                             , 'C')
                                            )
                                 ))                                tit_ero_2
                      into D_gg_anz_c
                         , D_anni_tot
                         , D_mesi_tot
                         , D_anni_con
                         , D_mesi_con
                         , D_perc
                         , D_anni
                         , D_mesi
                         , D_lor_tfr
                         , D_lor_as
                         , D_rit_liq
                         , D_ant_acc_ap
                         , D_ant_liq_ap
                         , D_ind_tot
                         , D_rid_tot
                         , D_ipn_red_rif
                         , D_alq_liq
                         , D_ipn_tfr
                         , D_ipn_as
                         , D_ipn_ac
                         , D_ipn_liq
                         , D_ipt_liq_ap
                         , D_ipt_ric
                         , D_ipt_tot
                         , D_diff
                         , D_lor_acc
                         , D_lor_liq
                         , D_ipt_liq
                         , D_ipt_sosp
                         , D_tit_ero_1
                         , D_tit_ero_2
                      from progressivi_fiscali   prfi
                     where prfi.anno         = D_anno
                       and prfi.mese         = 12
                       and prfi.mensilita    =
                          (select max(mensilita) from mensilita
                            where mese = 12
                              and tipo in ('S','N','A'))
                       and prfi.ci           = CUR_RPFA.ci
                    having (   nvl(sum(prfi.lor_liq),0) != 0
                            or nvl(sum(prfi.lor_acc),0) != 0)
                    ;
                    IF D_cal_anz = 'FRR'
                       THEN D_ratei_anz :=  trunc( ( D_gg_anz_c +D_gg_anz_t)
                                                 / 360 )
                                          + ( round( mod( ( D_gg_anz_c
                                                          + D_gg_anz_t)
                                                        , 360 )
                                                   / 30 )
                                            / 12 )
                                            ;
                            IF D_ratei_anz = 0
                               THEN D_ratei_anz := 1;
                            END IF;
                       ELSE D_ratei_anz := greatest( 1
                                                   ,
                                            trunc( ( D_gg_anz_c +D_gg_anz_t)
                                                 / 360 )
                                          + ( round( mod( ( D_gg_anz_c
                                                          + D_gg_anz_t)
                                                        , 360 )
                                                   / 30 )
                                            / 12 )
                                                   )
                                                   ;
                    END IF;
                    BEGIN
                    select to_char(perc_irpef_liq)
                      into D_alq_fissa
                      from informazioni_extracontabili
                     where anno = D_anno
                       and ci   = CUR_RPFA.ci
                    ;
                    END;
                    BEGIN
                    select decode( nvl(D_alq_fissa,'0')
                                 , '0', e_round(decode(to_number(D_lor_acc)+
                                                     to_number(D_ant_acc_ap)
                                                    ,0,to_number(D_lor_liq)+
                                                       to_number(D_ant_liq_ap)
                                                      ,to_number(D_lor_acc)+
                                                       to_number(D_ant_acc_ap))
                                             * 12 / D_ratei_anz,'I')
                                      , '0')
                      into D_red_rif
                      from dual
                    ;
                    END;
                    BEGIN
                    select max(decode( nvl(D_lor_acc,0)
                                     , 0, 0
                                        , decode( nvl(mofi.lor_acc,0)
                                                , 0, 0, mofi.mese))) mese_tfr
                         , max(decode( nvl(D_lor_liq,0)
                                     , 0, 0
                                        , decode( nvl(mofi.lor_liq,0)
                                                , 0, 0, mofi.mese))) mese_as
                      into D_mese_tfr
                         , D_mese_as
                      from movimenti_fiscali mofi
                     where mofi.ci       = CUR_RPFA.ci_st
                       and mofi.anno     = D_anno
                       and (   nvl(mofi.lor_liq,0) != 0
                            or nvl(mofi.lor_acc,0) != 0)
                    ;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            D_mese_tfr := 0;
                            D_mese_as  := 0;
                    END;
                    --
                    --  Estrazione Date di Inizio e Fine Rapporto
                    --
                    BEGIN
                    BEGIN
					  select 'x'
                      into d_dummy
                      from dual
                     where not exists(select 'x'
                                    from voci_economiche
                                   where automatismo = 'LOR_TFR')
                      ;
                      select to_char(max(moco.riferimento),'ddmmyyyy')
                       into D_fin_rap
                       from movimenti_contabili moco
                      where moco.ci = decode(CUR_RPFA.ci
                                            ,CUR_RPFA.ci_erede,null,CUR_RPFA.ci)
                        and moco.anno = D_anno
                        and moco.imp != 0
                        and moco.voce in
                            (select voce from contabilita_voce
                              where fiscale in ('A','L') )
                      ;
					EXCEPTION
                      WHEN NO_DATA_FOUND THEN 
					    D_fin_rap := null;
                    END;
                    select to_char(min(pegi.dal),'ddmmyyyy')
                         , to_char(nvl(to_date(D_fin_rap,'ddmmyyyy'),
                               max(pegi.al)),'ddmmyyyy')
                      into D_ini_rap,D_fin_rap
                      from periodi_giuridici pegi
                     where pegi.ci = decode(CUR_RPFA.ci
                                           ,CUR_RPFA.ci_erede,null,CUR_RPFA.ci)
                       and pegi.rilevanza = 'P'
                       and pegi.dal < nvl(to_date(D_fin_rap,'ddmmyyyy'),D_fin_a)
                       and nvl(pegi.al,to_date('3333333','j'))
                           >= to_date('0101'||
                              nvl(to_char(to_date(D_fin_rap,'ddmmyyyy'),'yyyy')
                                 ,D_anno)
                                     ,'ddmmyyyy')
                    ;
					EXCEPTION WHEN NO_DATA_FOUND THEN D_ini_rap := '0';
                                                      D_fin_rap := '0';
                    END;


                    BEGIN
                    select decode(max('x'),null,D_ipt_tot,0)
                      into D_ipt_tot
                      from rapporti_diversi radi
                     where ci_erede = CUR_RPFA.ci
                       and exists
                          (select 'x' from rapporti_individuali
                                        , classi_rapporto
                            where rapporto = codice
                              and presenza = 'NO'
                              and ci       = radi.ci)
                    ;
                    END;
                  BEGIN
                  --
                  --  Inserimento Terzo Record Dipendente
                  --
                  D_riga   := D_riga   + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'009'||
                           rpad(CUR_RPFA.prov_res,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           rpad(substr(CUR_RPFA.ind_res,1,16),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           decode( greatest(16,length(CUR_RPFA.ind_res))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.ind_res,17,15)
                                                ,15,' ')
                                 )||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           decode( greatest(31,length(CUR_RPFA.ind_res))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.ind_res,32)
                                                ,'15',' ')
                                 )||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'011'||
                           lpad(nvl(D_ini_rap,'00000000'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'012'||
                           lpad(nvl(D_fin_rap,'00000000'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'A13'||
                           lpad(lpad(nvl(D_anni_tot,'0'),2,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'B13'||
                           lpad(lpad(nvl(D_mesi_tot,'0'),2,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'A14'||
                           lpad(lpad(nvl(D_anni_con,'0'),2,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'B14'||
                           lpad(lpad(nvl(D_mesi_con,'0'),2,'0'),16,' ')||
                           '{'
                         )
                  ;

                  --
                  --  Inserimento Quarto Quinto Sesto e Settimo Records dip.
                  --

                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'A15'||
                           lpad(lpad(nvl(D_anni,'0'),2,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'B15'||
                           lpad(lpad(nvl(D_mesi,'0'),2,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'016'||
                           lpad(decode( nvl(D_anni,'0')||nvl(D_mesi,'0')
                                       ,'00',' '
                                            ,decode(D_perc,null,' ',D_perc))
                               ,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'017'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'018'||
                           lpad(nvl(D_mese_tfr,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'019'||
                           rpad(decode(D_tit_ero_1
                                      ,'',' '
                                         ,decode(D_dummy,'x','B',D_tit_ero_1)
                                      )
                               ,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'020'||
                           rpad(' ',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'021'||
                           lpad(D_lor_tfr,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'022'||
                           lpad(D_mese_as,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'023'||
                           rpad(decode(D_tit_ero_2
                                      ,'',' '
                                         ,decode(D_dummy,'x','B',D_tit_ero_2)
                                      )
                               ,16,' ')||
                           '{'
                         )
                  ;
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'024'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'025'||
                           lpad(D_lor_as,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'026'||
                           lpad(D_rit_liq,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'027'||
                           lpad(D_ant_acc_ap,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'028'||
                           lpad(D_ant_liq_ap,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'029'||
                           lpad(D_ind_tot,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'030'||
                           lpad(D_rid_tot,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'031'||
                           lpad(D_red_rif,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'032'||
                           lpad(decode(D_alq_liq,null,' ',D_alq_liq),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'033'||
                           lpad('0',16,' ')||
                           '{'
                         )
                  ;
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'034'||
                           rpad(' ',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'035'||
                           lpad(D_ipn_tfr,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'036'||
                           lpad(D_ipn_as,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'037'||
                           lpad(nvl(D_ipn_ac,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'038'||
                           lpad(D_ipn_liq,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'039'||
                           lpad(D_ipt_liq_ap,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'040'||
                           lpad(D_ipt_ric,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'041'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'042'||
                           lpad(D_ipt_tot,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'043'||
                           lpad(D_ipt_sosp,16,' ')||
                           '{'
                         )
                  ;
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'044'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'045'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'046'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'047'||
                           lpad(' ',16,' ')||
                           '}'
                         )
                  ;
                    END;

                    ELSE
                    --
                    --  Estrazione Dati Fiscali Erede
                    --

                    BEGIN
                    select ( nvl(sum(prfi.lor_acc),0)
                               +nvl(sum(prfi.lor_liq),0)
                               -nvl(sum(prfi.rit_liq),0)
                              )                                ind_ere
                         , (nvl(sum(prfi.ipt_liq),0))       ipt_ere
                         , (nvl(sum(prfi.somme_19),0))      ipt_sosp
                      into D_ind_ere
                         , D_ipt_ere
                         , D_ipt_ere_sosp
                      from progressivi_fiscali   prfi
                     where prfi.anno         = D_anno
                       and prfi.mese         = 12
                       and prfi.mensilita    =
                          (select max(mensilita) from mensilita
                            where mese = 12
                              and tipo in ('S','N','A'))
                       and prfi.ci           = CUR_RPFA.ci_st
                       and (   nvl(prfi.lor_liq,0) != 0
                            or nvl(prfi.lor_acc,0) != 0)
                    ;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                              D_ind_ere := 0;
                              D_ipt_tot := 0;
                    END;

                    --
                    --  Estrazione Codice Fiscale Dipendente
                    --

                    BEGIN
                    select codice_fiscale
                      into D_cf_dec
                      from anagrafici
                     where ni =
                          (select ni from rapporti_individuali
                            where ci = CUR_RPFA.ci_erede
                          )
                       and al                 is null
                    ;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            D_cf_dec   := ' ';
                    END;

                  --
                  --  Inserimento Terzo Record Erede
                  --

                  D_riga   := D_riga   + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'009'||
                           rpad(CUR_RPFA.prov_res,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           rpad(substr(CUR_RPFA.ind_res,1,16),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           decode( greatest(16,length(CUR_RPFA.ind_res))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.ind_res,17,15)
                                                ,15,' ')
                                 )||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           decode( greatest(31,length(CUR_RPFA.ind_res))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.ind_res,32)
                                                ,'15',' ')
                                 )||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'011'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'012'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'A13'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'B13'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'A14'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'B14'||
                           lpad('0',16,' ')||
                           '{'
                         )
                  ;

                  --
                  --  Inserimento Quarto Quinto Sesto e Settimo Records Erede
                  --

                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'A15'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'B15'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'016'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'017'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'018'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'019'||
                           rpad(' ',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'020'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'021'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'022'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'023'||
                           rpad(' ',16,' ')||
                           '{'
                         )
                  ;
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'024'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'025'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'026'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'027'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'028'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'029'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'030'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'031'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'032'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'033'||
                           lpad('0',16,' ')||
                           '{'
                         )
                  ;
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'034'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'035'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'036'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'037'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'038'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'039'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'040'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'041'||
                           lpad('0',16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'042'||
                           lpad(D_ipt_ere,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'043'||
                           lpad(D_ipt_ere_sosp,16,' ')||
                           '{'
                         )
                  ;
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SB'||lpad(to_char(D_num_ord),3,'0')||'044'||
                           lpad(nvl(CUR_RPFA.tipo_erede,'0'),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'045'||
                           lpad(decode
                               (CUR_RPFA.quota_erede
                               ,null,' '
                                    ,CUR_RPFA.quota_erede
                               ),16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'046'||
                           lpad(D_ind_ere,16,' ')||
                           'SB'||lpad(to_char(D_num_ord),3,'0')||'047'||
                           rpad(nvl(D_cf_dec,' '),16,' ')||
                           '}'
                         )
                  ;

                END IF;
                END;
                D_riga := 0;
                D_dep_cod_fis := D_cod_fis;
                END;
              END LOOP;

              --
              --  Inserimento Primo Record Totale
              --
      END;
COMMIT;
END;
end;
end;
/
