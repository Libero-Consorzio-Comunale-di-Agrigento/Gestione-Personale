CREATE OR REPLACE PACKAGE PECSMFA2 IS
/******************************************************************************
 NOME:          PECSMFA2 CREAZIONE SUPPORTO MAGNETICO 770/SA

 DESCRIZIONE:
      Questa fase produce un file secondo un tracciato concordato a livello
      aziendale per via dei limiti di ORACLE che permette di creare record
      di max 250 crt. Una ulteriore elaborazione adeguera' questi files al
      tracciato imposto dal Ministero delle Finanze.
      Il file prodotto si trovera' nella directory \\dislocazione\sta del report server con il nome
      PECCSMFA.txt .

      N.B.: La gestione che deve risultare come intestataria della denuncia
            deve essere stata inserita in << DGEST >> in modo tale che la
            ragione sociale (campo nome) risulti essere la minore di tutte
            le altre eventualmente inserite.
            Lo stesso risultato si raGgiunge anche inserendo un BLANK prima
            del nome di tutte le gestioni che devono essere escluse.

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
      Creazione del flusso per la Denuncia Fiscale 770 / SA su
      supporto magnetico
      (nastri a bobina o dischetti - ASCII - lung. 4000 crt.).

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 2    30/06/2003 DM     Rilascio Patch 770/2003
 2    16/06/2004 MS     Rilascio Patch 770/2004
 3.1  30/07/2004 AM     Correzioni da test di validazione
 3.2  14/09/2004 MS     Modifica per Attivita 7327
 3.3  28/09/2004 AM     Girato il segno del dato estratto per cas. 8 parte D (ass. fiscale)
 3.4  12/01/2005 MS     Modifica per Attivita 8888
 4    25/05/2005 GM     Revisione per 770/2005
 4.1  12/07/2005 MS     Modifica att 11764.4 ( aggiunta solo annotazione )
 4.2  30/08/2005 MS     Modifica per att. 12428
 5.0  25/05/2006 MS     Revisione per 770/2006
 5.1  07/06/2006 MS     Revisione per 770/2006 - parte D ( att. 11279 )
 5.2  13/06/2006 MS     Mod. casella "integrativo" - parte D
 5.3  13/06/2006 MS     Miglioria alle segnalazioni
 5.4  22/06/2006 MS     Mod. su segnalazione test ( att. 16484.1 )
 5.5  05/07/2006 MS     Mod. su segnalazione test ( att. 16484.1 )
 5.6  24/07/2006 MS     Correzione casella 8 - Prev. Compl ( Att. 17080 )
 5.7  24/08/2006 MS     Correzione casella 72/D - Data ricezione 730 ( Att. 17364 )
 6.0  23/03/2007 MS     Revisione per 770/2007
 6.1  12/06/2007 MS     Correzioni da test
 6.2  05/07/2007 MS     Correzioni da test ( evento eccezionale )
 6.3  24/07/2007 CB     Correzione msg 
 6.4  03/09/2007 MS     Nuova segnalazione per parte D
 6.5  20/09/2007 MS     Sistemazione errore su residenza estero
******************************************************************************/

 FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMFA2 IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V6.5 del 20/09/2007';
   END VERSIONE;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE
-- Depositi e Contatori Vari
  D_riga            number := 0;
  D_dummy           varchar2(1);
  D_non_terminato   varchar2(1);
  D_ci              number := 0;
-- Variabili di Periodo
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
  D_fin_a_prec      date;
  D_gg_a            number;
  D_decimali        varchar2(1);
  D_dom_fiscale     varchar2(1);
-- Variabili di Ente
  D_cod_fis_dic     varchar2(16);
  D_ente_cf         varchar2(16);
-- Variabili di Anagrafe
  D_codice_fiscale  varchar2(16);
  D_cognome         varchar2(40);
  D_nome            varchar2(40);
  D_data_nas        varchar2(8);
  D_sesso           varchar2(1);
  D_indirizzo_res   varchar2(40);
  D_qua_fiscale     varchar2(1);
  D_comune_nas      number;
  D_provincia_nas   number;
  D_comune_res      number;
  D_provincia_res   number;
  D_com_nas         varchar2(40);
  D_prov_nas        varchar2(5);
  D_pre_com         varchar2(1);
  D_evento_eccezionale varchar2(1);
  D_valore_C103     varchar2(20);
  D_valore_C104     varchar2(20);
  D_com_cess        varchar2(40);
  D_prov_cess       varchar2(5);
  D_cod_catasto     varchar2(4);
  D_com_cess_0101    varchar2(40);
  D_prov_cess_0101   varchar2(5);
  D_cod_catasto_0101 varchar2(4);

-- Variabili parte fiscale B
  D_74  VARCHAR2(10);
  D_75  VARCHAR2(10);
  D_76  number;
  D_77  number;
  D_78  varchar2(16);
  D_79  varchar2(16);
  D_A80 number;
  D_B80 number;
  D_A81 number;
  D_B81 number;
  D_A82 number;
  D_B82 number;
  D_83  number;
  D_84  number;
  D_85  number;
  D_86  varchar2(16);
  D_87  number;
  D_88  varchar2(1);
  D_89  number;
  D_90  varchar2(16);
  D_91  varchar2(16);
  D_A92 number;
  D_B92 number;
  D_A93 number;
  D_B93 number;
  D_A94 number;
  D_B94 number;
  D_95  number;
  D_96  number;
  D_97  number;
  D_98  varchar2(1);
  D_99  number;
  D_100 varchar2(16);
  D_101 number;
  D_102 number;
  D_103 number;
  D_104 number;
  D_105 varchar2(1);
  D_106 number;
  D_107 varchar2(16);
  D_108 number;
  D_109 varchar2(1);
  D_110 number;  
  D_111 varchar2(16);
  D_A112 number;
  D_B112 number;
  D_A113 number;
  D_B113 number;
  D_A114 number;
  D_B114 number;
  D_115 number;
  D_116 number;
  D_117 number;
  D_118 varchar2(1);
  D_119 number;
  D_120 varchar2(16);
  D_121 number;
  D_122 number;
  D_123 varchar2(1);
  D_124 number;
  D_125 varchar2(16);
  D_126 number;
  D_127 varchar2(1);
  D_128 number;
  D_129 varchar2(16);  
  D_150 number;
  D_151 number;
  D_152 number;
  D_153 number;
  D_154 number;
  D_155 number;
  D_156 number;
  D_157 number;
  D_158 number;
  D_159 number;
  D_160 number;
  D_161 number;
  D_162 number;
  
  D_titolo_tfr       varchar(2);
  D_fdo_tfr_2000     number;
  D_fdo_tfr_ap       number;
  D_fdo_tfr_ap_liq   number;
  D_fdo_tfr_2000_liq number;
  D_errore           varchar(200);
  D_step             varchar(50);
  D_riga_e number;
-- Variabili di Exception
  NO_QUALIFICA EXCEPTION;
-- variabili di dettaglio
  D_esito_cong      varchar2(1);
  D_cong_2r         varchar2(1);
  D_esito_2r        varchar2(1);
  D_caaf_nome       varchar2(40);
  D_caaf_cod_fis    varchar2(16);
  D_caaf_nr_albo    varchar2(16);
  D_data_ric        varchar2(16);
  D_data_ric_int    varchar2(16);
  D_data_prima_ric  varchar2(16);
  D_cod_reg_dic     varchar2(16);
  D_cod_reg_con     varchar2(16);
  D_cod_com_dic     varchar2(16);
  D_cod_com_con     varchar2(16);
  D_c_tipo_cong     varchar2(16);
  D_c_rett          varchar2(16);
  D_st_tipo         varchar2(16);
  -- variabili per conguaglio non terminato
  D_irpef_1r_int    number;
  D_irpef_ri1r      number;
  D_irpef_ret_1r    number;
  D_add_r_int       number;
  D_add_r_ris       number;
  D_add_r_intc      number;
  D_irpef_ris       number;
  D_irpef_int       number;
  D_mese            number;
  D_irpef_cr        number;
  D_irpef_db        number;
  D_irpef_1r        number;
  D_irpef_2r        number;
  D_irpef_2r_int    number;
  D_irpef_ret_2r    number;
  D_irpef_ap        number;
  D_add_r_cr        number;
  D_add_r_db        number;
  D_add_r_crc       number;
  D_add_r_dbc       number;
  D_add_c_dbc       number;
  D_add_c_db        number;
  D_add_c_cr        number;
  D_add_c_crc       number;
  D_add_c_int       number;
  D_add_c_intc      number;
  D_irpef_ap_int    number;
  D_irpef_riap      number;
  D_irpef_ret_ap    number;
  D_r_mese          number;
  D_rt_mese1        number;
  D_rt_mese2        number;
  D_r_irpef_db      number;
  D_r_irpef_1r      number;
  D_r_irpef_2r      number;
  D_r_irpef_ap      number;
  D_r_add_r_db      number;
  D_r_add_r_dbc     number;
  D_r_add_c_db      number;
  D_r_add_c_dbc     number;
  T_irpef_cr        number;
  T_irpef_db        number;
  T_irpef_1r_cr     number;
  T_irpef_1r_db     number;
  T_irpef_2r_cr     number;
  T_irpef_2r_db     number;
  T_irpef_ap_cr     number;
  T_irpef_ap_db     number;
  T_add_r_cr        number;
  T_add_r_db        number;
  T_add_r_crc       number;
  T_add_r_dbc       number;
  T_add_c_cr        number;
  T_add_c_db        number;
  T_add_c_crc       number;
  T_add_c_dbc       number;
  D_casella5        varchar2(1);
  D_casella9        varchar2(1);
  D_casella13       varchar2(1);
  D_casella18       varchar2(1);
  D_casella23       varchar2(1);
  D_casella28       varchar2(1);
  D_casella33       varchar2(1);
BEGIN
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
      select to_date('3112'||to_char(D_anno-1),'ddmmyyyy')
        into D_fin_a_prec
        from dual;
      END;
      BEGIN
      select 365
        into D_gg_a
        from dual;
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
      select substr(valore,1,1)
        into D_dom_fiscale
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DOM_FISCALE'
      ;
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
        D_dom_fiscale := null;
      END;
      BEGIN
      select substr(valore,1,1)
        into D_decimali
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DECIMALI'
      ;
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
        D_decimali := null;
      END;
  END; -- parametri
      BEGIN
        FOR CUR_ANA IN
           (select distinct to_number(substr(apst.testo,1,8))         ci
                 , substr(apst.testo,9,8)                    modulo
                 , to_number(substr(apst.testo,17,2))        num_ord
                 , substr(apst.testo,19,16)                  ente_cf
                 , to_number(decode(substr(apst.testo,56,8)
                                    ,'00000000',null
                                               ,substr(apst.testo,56,8))) ci_erede
                 , apst.pagina                               pagina
                 , substr(apst.testo,53,1)                   dummy_f
                 , substr(apst.testo,54,2)                   cat_fiscale
              from a_appoggio_stampe        apst
             where apst.no_prenotazione     = prenotazione
               and apst.no_passo            = 2
               and apst.riga                = 0
               order by apst.pagina
           ) LOOP

            D_step := 'INIZIO LOOP';

             D_pre_com         := null;
             D_evento_eccezionale := null;
             D_valore_C103     := null;
             D_valore_C104     := null;
             D_74    := null;
             D_75    := null;
             D_76    := to_number(null);
             D_77    := to_number(null);
             D_78    := null;
             D_79    := null;
             D_A80   := to_number(null);
             D_B80   := to_number(null);
             D_A81   := to_number(null);
             D_B81   := to_number(null);
             D_A82   := to_number(null);
             D_B82   := to_number(null);
             D_83    := to_number(null);
             D_84    := to_number(null);
             D_85    := to_number(null);
             D_86    := null;
             D_87    := to_number(null);
             D_88    := null;
             D_89    := to_number(null);
             D_90    := null;
             D_91    := null;
             D_A92   := to_number(null);
             D_B92   := to_number(null);
             D_A93   := to_number(null);
             D_B93   := to_number(null);
             D_A94   := to_number(null);
             D_B94   := to_number(null);
             D_95    := to_number(null);
             D_96    := to_number(null);
             D_97    := to_number(null);
             D_98    := null;
             D_99    := to_number(null);
             D_100   := null;
             D_101   := to_number(null);
             D_102   := to_number(null);
             D_103   := to_number(null);
             D_104   := to_number(null);
             D_105   := null;
             D_106   := to_number(null);
             D_107   := null;
             D_108   := to_number(null);
             D_109   := null;
             D_110   := to_number(null);  
             D_111   := null;
             D_A112   := to_number(null);
             D_B112   := to_number(null);
             D_A113   := to_number(null);
             D_B113   := to_number(null);
             D_A114   := to_number(null);
             D_B114   := to_number(null);
             D_115   := to_number(null);
             D_116   := to_number(null);
             D_117   := to_number(null);
             D_118   := null;
             D_119   := to_number(null);
             D_120   := null;
             D_121   := to_number(null);
             D_122   := to_number(null);
             D_123   := null;
             D_124   := to_number(null);
             D_125   := null;
             D_126   := to_number(null);
             D_127   := null;
             D_128   := to_number(null);
             D_129   := null;
             D_150   := to_number(null);
             D_151   := to_number(null);
             D_152   := to_number(null);
             D_153   := to_number(null);
             D_154   := to_number(null);
             D_155   := to_number(null);
             D_156   := to_number(null);
             D_157   := to_number(null);
             D_158   := to_number(null);
             D_159   := to_number(null);
             D_160   := to_number(null);
             D_161   := to_number(null);
             D_162   := to_number(null);

             D_codice_fiscale := null;
             D_cognome := null;
             D_nome := null;
             D_data_nas := null;
             D_sesso := null;
             D_indirizzo_res := null;
             D_comune_nas := null;
             D_provincia_nas := null;
             D_comune_res  := null;
             D_provincia_res  := null;
             D_com_nas  := null;
             D_prov_nas := null;
             D_riga_e := CUR_ANA.pagina * 100;

             D_mese            := 0;
             D_irpef_cr        := 0;
             D_irpef_db        := 0;
             D_irpef_int       := 0;
             D_irpef_1r        := 0;
             D_irpef_1r_int    := 0;
             D_irpef_ret_1r    := 0;
             D_add_r_cr        := 0;
             D_add_r_db        := 0;
             D_add_r_int       := 0;
             D_cod_reg_dic     := null;
             D_add_r_crc       := 0;
             D_add_r_dbc       := 0;
             D_add_r_intc      := 0;
             D_cod_reg_con     := null;
             D_add_c_cr        := 0;
             D_add_c_db        := 0;
             D_add_c_int       := 0;
             D_cod_com_dic     := null;
             D_add_c_crc       := 0;
             D_add_c_dbc       := 0;
             D_add_c_intc      := 0;
             D_cod_com_con     := null;
             D_irpef_ap        := 0;
             D_irpef_ap_int    := 0;
             D_irpef_ret_ap    := 0;
             D_c_tipo_cong     := null;
             D_c_rett          := null;
             D_st_tipo         := null;
             D_r_mese          := 0;
             D_irpef_2r        := 0;
             D_irpef_2r_int    := 0;
             D_irpef_ret_2r    := 0;
             D_esito_2r        := null;
             D_rt_mese1        := 0;
             D_r_irpef_db      := 0;
             D_r_irpef_1r      := 0;
             D_r_add_r_db      := 0;
             D_r_add_r_dbc     := 0;
             D_r_add_c_db      := 0;
             D_r_add_c_dbc     := 0;
             D_r_irpef_ap      := 0;
             D_rt_mese2        := 0;
             D_r_irpef_2r      := 0;
             T_irpef_cr        := 0;
             T_irpef_db        := 0;
             T_irpef_1r_cr     := 0;
             T_irpef_1r_db     := 0;
             T_add_r_cr        := 0;
             T_add_r_db        := 0;
             T_add_r_crc       := 0;
             T_add_r_dbc       := 0;
             T_add_c_cr        := 0;
             T_add_c_db        := 0;
             T_add_c_crc       := 0;
             T_add_c_dbc       := 0;
             T_irpef_ap_cr     := 0;
             T_irpef_ap_db     := 0;
             T_irpef_2r_cr     := 0;
             T_irpef_2r_db     := 0;
             D_data_ric        := null;
             D_cong_2r         := null;

             BEGIN
               D_step := 'Select Dati Anagrafici';
               select anag.codice_fiscale
                    , upper(anag.cognome)
                    , upper(anag.nome)
                    , substr(to_char(anag.data_nas,'ddmmyyyy'),1,8)
                    , anag.sesso
                    , upper(anag.indirizzo_res)
                    , anag.comune_nas
                    , anag.provincia_nas
                    , anag.comune_res
                    , anag.provincia_res
                 into D_codice_fiscale
                    , D_cognome
                    , D_nome
                    , D_data_nas
                    , D_sesso
                    , D_indirizzo_res
                    , D_comune_nas
                    , D_provincia_nas
                    , D_comune_res
                    , D_provincia_res
                 from anagrafici               anag
                    , rapporti_individuali     rain
                where anag.ni  = rain.ni
                  and anag.dal =
                     (select max(dal)
                        from anagrafici
                       where ni  = anag.ni
                         and dal <= D_fin_a)
                  and rain.ci = CUR_ANA.ci
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  D_codice_fiscale := ' ';
                  D_cognome := ' ';
                  D_nome := ' ';
                  D_data_nas := ' ';
                  D_sesso := ' ';
                  D_indirizzo_res := ' ';
                  D_comune_nas   := null;
                  D_provincia_nas := null;
                  D_comune_res  := null;
                  D_provincia_res  := null;
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Val. anagrafica succ. all'' anno di denuncia';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
             END;
            IF D_nome is null or D_data_nas is null or D_sesso is null or D_indirizzo_res is null
            THEN
              D_errore := ' Verificare dati Anagrafici';
              PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
            END IF;
                D_riga := 1;
                D_step := 'Prima Insert';
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                 values ( prenotazione
                         , 2
                         , CUR_ANA.pagina
                         , D_riga
                         , 'G'||
                           rpad(nvl(D_cod_fis_dic,CUR_ANA.ente_cf),16,' ')||
                           lpad(ltrim(CUR_ANA.modulo,0),8,'0')||
                           lpad(' ',4,' ')||
                           rpad(D_codice_fiscale,16,' ')||
                           lpad(' ',44,' ')||
                           '{'
                         )
                  ;
          BEGIN
            IF CUR_ANA.ci != D_ci THEN
               BEGIN
                 D_step := 'Select Comune Nascita';
                 select upper(comu_n.descrizione)
                      , substr( decode( sign(199-comu_n.cod_provincia)
                              , -1, '  '
                                  , comu_n.sigla_provincia),1,2)
                   into D_com_nas,
                        D_prov_nas
                   from comuni comu_n
                  where comu_n.cod_comune = D_comune_nas
                    and comu_n.cod_provincia  = D_provincia_nas
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    D_com_nas  := ' ';
                    D_prov_nas := ' ';
                    D_riga_e := D_riga_e + 1;
                    D_errore := ' Comune di Nascita non codificato';
                    PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
               END;
               BEGIN
                D_step := 'Select Comune Residenza';
                select nvl(comu.descrizione ,' ')    com_cess,
                       decode(  sign(199-comu.cod_provincia)
                              , -1, '  '
                                  , nvl(comu.sigla_provincia,' ')
                              ) prov_cess,
                       decode( sign(199-comu.cod_provincia)
                              , -1, '  '
                              , nvl(comu.codice_catasto,' '))
                  into D_com_cess,
                       D_prov_cess,
                       D_cod_catasto
                  from comuni comu
                 where comu.cod_comune = D_comune_res
                   and comu.cod_provincia = D_provincia_res
                 ;
               EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     D_com_cess := ' ';
                     D_prov_cess := ' ';
                     D_cod_catasto := ' ';
                     D_riga_e := D_riga_e + 1;
                     D_errore := ' Comune di Residenza non codificato';
                    PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
               END;
               BEGIN
               D_step := 'Select Dati Anagrafici Domicilio 01/01';
               select  nvl(comu.descrizione ,' ')    com_cess,
                       decode(  sign(199-comu.cod_provincia)
                              , -1, '  '
                                  , nvl(comu.sigla_provincia,' ')
                              ) prov_cess,
                       decode( sign(199-comu.cod_provincia)
                              , -1, '  '
                              , nvl(comu.codice_catasto,' '))
                 into D_com_cess_0101,
                      D_prov_cess_0101,
                      D_cod_catasto_0101
                 from anagrafici               anag
                    , rapporti_individuali     rain
                    , comuni comu
                where anag.ni  = rain.ni
                  and anag.dal = ( select max(dal)
                                     from anagrafici
                                    where ni  = anag.ni
                                      and dal <= D_fin_a+1)
                  and rain.ci = CUR_ANA.ci
                  and comu.cod_comune = anag.comune_res
                  and comu.cod_provincia = anag.provincia_res
                  and ( D_dom_fiscale  = 'X'
                    or exists ( select 'x' 
                                 from periodi_giuridici pegi
                                where rilevanza = 'Q'
                                  and ci = rain.ci
                                  and D_fin_a+1 between dal and nvl(al,to_date('3333333','j'))
                             )
                      )
               ;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      D_com_cess_0101    := ' ';
                      D_prov_cess_0101   := ' ';
                      D_cod_catasto_0101 := ' ';
                      D_riga_e := D_riga_e + 1;
                      IF D_dom_fiscale  = 'X' THEN
                         D_errore := ' Comune di Residenza 01/01 non codificato';
                         PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
                      END IF;
               END;               
               IF nvl(D_cod_catasto,' ') = ' '  THEN
                   D_riga_e := D_riga_e + 1;
                   D_errore := ' Codice Catasto Non Codificato';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
               END IF; -- cod_catasto
               IF D_dom_fiscale  = 'X' and nvl(D_cod_catasto_0101,' ') = ' ' 
               THEN
                   D_riga_e := D_riga_e + 1;
                   D_errore := ' Codice Catasto 01/01 Non Codificato';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
               END IF; -- cod_catasto_0101

               IF  (    nvl(ltrim(rtrim(D_prov_cess)),'EE') = 'EE' 
                   or ( D_dom_fiscale = 'X' and nvl(ltrim(rtrim(D_prov_cess_0101)),'EE') = 'EE' 
                      ) 
                   ) THEN
                   D_riga_e := D_riga_e + 1;
                   D_errore := ' Verificare Residenza Fiscale Estero';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, null );
               END IF; -- residenza all'estero

               BEGIN
                 D_step := 'Select Qualifica Fiscale';
                 select decode(instr(nvl(upper(pegi.note),' '),'INTRAMURARIA')
                               ,0,substr(qual.cat_fiscale,1,1)
                                 ,'R')
                   into D_qua_fiscale
                   from qualifiche             qual
                      , periodi_giuridici      pegi
                  where qual.numero    = pegi.qualifica
                    and pegi.rilevanza = 'S'
                    and pegi.ci        = CUR_ANA.ci
                    and pegi.dal       = ( select max(p2.dal)
                                             from periodi_giuridici p2
                                            where p2.rilevanza = 'S'
                                              and p2.ci        = CUR_ANA.ci
                                              and p2.dal      <= D_fin_a
                                          )
                        ;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   BEGIN
                     select decode(instr(nvl(upper(pegi.note),' '),'INTRAMURARIA')
                                  ,'0', substr(qual.cat_fiscale,1,1)
                                      ,'R')
                       into D_qua_fiscale
                       from qualifiche             qual
                          , periodi_giuridici      pegi
                      where pegi.rilevanza = 'Q'
                        and pegi.ci        = CUR_ANA.ci
                        and pegi.dal       = ( select max(p2.dal)
                                                 from periodi_giuridici p2
                                                where p2.rilevanza = 'Q'
                                                  and p2.ci        = CUR_ANA.ci
                                                  and p2.dal      <= D_fin_a)
                                                  and qual.numero    = ( select qualifica
                                                                           from figure_giuridiche
                                                                          where numero = pegi.figura
                                                                            and least( nvl(pegi.al,to_date('3333333','j'))
                                                                                     , D_fin_a)
                                                                                between dal
                                                                                    and nvl(al,to_date('3333333','j'))
                                                                       )
                     ;
                   EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      D_qua_fiscale := ' ';
                   END;
               END;
               BEGIN
                  D_step := 'Select Prev. Compl. e Evento Eccezionale ';
                  select decode(length(ltrim(rtrim(c103)))
                               , 1, C103
                                  , ' ' 
                               )
                       , decode(length(ltrim(rtrim(c104)))
                               , 1, C104
                                  , ' '
                               )
                       , C103, C104
                    into D_pre_com, D_evento_eccezionale
                       , D_valore_C103,  D_valore_C104
                    from denuncia_fiscale
                   where ci = CUR_ANA.ci
                     and anno = D_anno
                     and rilevanza = 'T'
                     and C103 is not null
                ;
               EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  D_pre_com  := ' ';
                  D_evento_eccezionale := ' ';
                  D_valore_C103 := ' ';
                  D_valore_C104 := ' ';
               END;
-- controllo sulla casella 8 previdenza complementare
                IF nvl(ltrim(D_pre_com),'1') not in ( '1', '2', '3', '4', 'A' ) THEN
                  D_pre_com := null;
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Prev.Compl. ( 1/2/3/4/A ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_valore_C103 );
                END IF; -- casella D_pre_com


                D_riga := 3;
                D_step := 'Seconda Insert';
                --  Inserimento Primo Record Dipendente
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 2
                       , CUR_ANA.pagina
                       , D_riga
                       , 'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'001'||
                         rpad(D_codice_fiscale,16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'002'||
                         rpad(substr(D_cognome,1,16),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'002'||
                         decode( greatest(16,length(D_cognome))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_cognome,17,15)
                                              ,15,' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'002'||
                         decode( greatest(31,length(D_cognome))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_cognome,32)
                                              ,'15',' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'003'||
                         rpad(substr(D_nome,1,16),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'003'||
                         decode( greatest(16,length(D_nome))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_nome,17,15)
                                              ,15,' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'003'||
                         decode( greatest(31,length(D_nome))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_nome,32)
                                              ,'15',' ')
                               )||
                         '{'
                       )
                ;
                --  Inserimento Secondo Record Dipendente
                D_riga   := D_riga   + 1;
                D_step := 'Terza Insert';
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 2
                       , CUR_ANA.pagina
                       , D_riga
                       , 'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'004'||
                         rpad(D_sesso,16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'005'||
                         lpad(D_data_nas,16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'006'||
                         rpad(substr(D_com_nas,1,16),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'006'||
                         decode( greatest(16,length(D_com_nas))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_com_nas,17,15)
                                              ,15,' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'006'||
                         decode( greatest(31,length(D_com_nas))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_com_nas,32)
                                              ,'15',' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'007'||
                         rpad(D_prov_nas,16,' ')||
                                           'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'008'||
                         rpad(nvl(D_pre_com,' '),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'009'||
                         rpad(nvl(D_qua_fiscale,' '),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'010'||
                         rpad(nvl(D_evento_eccezionale,' '),16,' ')||
                         '{'
                       )
                ;
                --  Inserimento Terzo Record Dipendente
                D_riga   := D_riga   + 1;
                D_step := 'Quarta Insert';
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 2
                       , CUR_ANA.pagina
                       , D_riga
                       , 'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'011'||
                         rpad(substr(D_com_cess,1,16),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'011'||
                         decode( greatest(16,length(D_com_cess))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_com_cess,17,15)
                                              ,15,' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'011'||
                         decode( greatest(31,length(D_com_cess))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_com_cess,32)
                                              ,'15',' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'012'||
                         rpad(nvl(D_prov_cess,' '),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'013'||
                         rpad(nvl(D_cod_catasto,' '),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'014'||
                         rpad(substr(D_com_cess_0101,1,16),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'014'||
                         decode( greatest(16,length(D_com_cess_0101))
                               , 16, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_com_cess_0101,17,15)
                                              ,15,' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'014'||
                         decode( greatest(31,length(D_com_cess_0101))
                               , 31, rpad(' ',16,' ')
                                   , '+'||rpad(substr(D_com_cess_0101,32)
                                              ,'15',' ')
                               )||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'015'||
                         rpad(nvl(D_prov_cess_0101,' '),16,' ')||
                         'DA'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'016'||
                         rpad(nvl(D_cod_catasto_0101,' '),16,' ')||
                         '{'
                       )
                ;
--
-- Parte fiscale TFR
--
                BEGIN
                  select titolo_tfr
                    into D_titolo_tfr
                    from informazioni_extracontabili
                   where ci   = CUR_ANA.ci
                     and anno = D_anno
                  ;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     D_titolo_tfr := null;
                END;
                BEGIN
                  select sum(nvl(fdo_tfr_ap,0)), sum(nvl(fdo_tfr_2000,0)),
                         sum(nvl(fdo_tfr_ap_liq,0)), sum(nvl(fdo_tfr_2000_liq,0))
                   into D_fdo_tfr_ap, D_fdo_tfr_2000,
                        D_fdo_tfr_ap_liq, D_fdo_tfr_2000_liq
                   from progressivi_fiscali   prfi
                     where prfi.anno         = D_anno
                       and prfi.mese         = 12
                       and prfi.mensilita    = ( select max(mensilita) from mensilita
                                                  where mese = 12
                                                    and tipo in ('S','N','A')
                                               )
                       and prfi.ci           = CUR_ANA.ci
                      having (   nvl(sum(prfi.lor_liq),0) != 0
                              or nvl(sum(prfi.lor_acc),0) +
                                nvl(sum(prfi.lor_acc_2000),0)!= 0);
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          D_fdo_tfr_ap:= 0;
                          D_fdo_tfr_2000:= 0;
                          D_fdo_tfr_ap_liq:= 0;
                          D_fdo_tfr_2000_liq:= 0;
                END;
                
                BEGIN
                <<DEFS_TFR>>
                D_step := 'Select da Denuncia Fiscale - TFR';
                        select nvl(to_char(c108,'ddmmyyyy'),' ')                                       -- c74
                             , nvl(to_char(c109,'ddmmyyyy'),' ')                                       -- c75
                             , decode(D_decimali, 'X',trunc(nvl(c74,0),2)*100,trunc(nvl(c74,0),0))     -- c76
                             , nvl(c75,0)                                                              -- c77
                             , nvl(c76,0)                                                              -- c78
                             , nvl(c142,' ')                                                           -- c79
                             , trunc(round( nvl(c77,0) / 30 ) /12)                                     -- c80A
                             , round(( nvl(c77,0) - trunc(round(nvl(c77,0) / 30 ) /12 ) * 360 ) / 30)  -- c80B
                             , trunc(round( nvl(c78,0) / 30 ) /12)                                     -- c81A
                             , round(( nvl(c78,0) - trunc(round(nvl(c78,0) / 30 ) /12 ) * 360 ) / 30)  -- c81B
                             , trunc(round( nvl(c79,0) / 30 ) /12)                                     -- c82A
                             , round(( nvl(c79,0) - trunc(round(nvl(c79,0) / 30 ) /12 ) * 360 ) / 30)  -- c82B
                             , nvl(c80,0)                                                              -- c83
                             , decode(D_decimali, 'X',trunc(nvl(c81,0),2)*100,trunc(nvl(c81,0),0))     -- c84
                             , decode(D_decimali, 'X',trunc(nvl(c82,0),2)*100,trunc(nvl(c82,0),0))     -- c85
                             , nvl(to_char(c83),' ')                                                   -- c86
                             , decode(D_decimali, 'X',trunc(nvl(c84,0),2)*100,trunc(nvl(c84,0),0))     -- c87
                             , decode( decode(D_decimali, 'X',trunc(nvl(c84,0),2)*100,trunc(nvl(c84,0),0))
                                      , 0, null
                                         , 'B' )                                                       -- c88
                             , decode(D_decimali, 'X',trunc(nvl(c85,0),2)*100,trunc(nvl(c85,0),0))     -- c89
                             , nvl(to_char(c86),' ')                                                   -- c90
                             , nvl(c143,' ')                                                           -- c91
                             , trunc(round( nvl(c87,0) / 30 ) /12)                                     -- c92A
                             , round(( nvl(c87,0) - trunc(round(nvl(c87,0) / 30 ) /12 ) * 360 ) / 30)  -- c92B
                             , trunc(round( nvl(c88,0) / 30 ) /12)                                     -- c93A
                             , round(( nvl(c88,0) - trunc(round(nvl(c88,0) / 30 ) /12 ) * 360 ) / 30)  -- c93B
                             , trunc(round( nvl(c89,0) / 30 ) /12)                                     -- c94A
                             , round(( nvl(c89,0) - trunc(round(nvl(c89,0) / 30 ) /12 ) * 360 ) / 30)  -- c94B
                             , nvl(c90,0)                                                              -- c95
                             , decode(D_decimali, 'X',trunc(nvl(c91,0),2)*100,trunc(nvl(c91,0),0))     -- c96
                             , decode(D_decimali, 'X',trunc(nvl(c92,0),2)*100,trunc(nvl(c92,0),0))     -- c97
                             , decode( decode(D_decimali, 'X',trunc(nvl(c92,0),2)*100,trunc(nvl(c92,0),0))
                                      , 0, null
                                         , decode( nvl(D_titolo_tfr,'X')
                                                 , 'X', decode( nvl(D_fdo_tfr_ap,0) - nvl(D_fdo_tfr_ap_liq,0)
                                                              ,0,'B','A')
                                                      , D_titolo_tfr)
                                     )                                                                 -- c98
                             , decode(D_decimali, 'X',trunc(nvl(c93,0),2)*100,trunc(nvl(c93,0),0))     -- c99
                             , nvl(to_char(c94),' ')                                                   -- c100
                             , decode(D_decimali, 'X',trunc(nvl(c95,0),2)*100,trunc(nvl(c95,0),0))     -- c101
                             , nvl(c96,0)                                                              -- c102
                             , decode(D_decimali, 'X',trunc(nvl(c97,0),2)*100,trunc(nvl(c97,0),0))     -- c103
                             , decode(D_decimali, 'X',trunc(nvl(c98,0),2)*100,trunc(nvl(c98,0),0))     -- c104
                             , decode( decode(D_decimali, 'X',trunc(nvl(c98,0),2)*100,trunc(nvl(C98,0),0))
                                      , 0, null
                                         , 'B' )                                                       -- c105
                             , decode(D_decimali, 'X',trunc(nvl(c99,0),2)*100,trunc(nvl(c99,0),0))     -- c106
                             , nvl(to_char(c100),' ')                                                  -- c107
                             , decode(D_decimali, 'X',trunc(nvl(c111,0),2)*100,trunc(nvl(c111,0),0))   -- c108
                             , decode( decode(D_decimali, 'X',trunc(nvl(c111,0),2)*100,trunc(nvl(C111,0),0))
                                      , 0, null
                                         , 'B' )                                                       -- c109
                             , decode(D_decimali, 'X',trunc(nvl(c112,0),2)*100,trunc(nvl(c112,0),0))   -- c110
                             , nvl(c144,' ')                                                           -- c111
                             , trunc(round( nvl(c113,0) / 30 ) /12)                                      -- c112A
                             , round(( nvl(c113,0) - trunc(round(nvl(c113,0) / 30 ) /12 ) * 360 ) / 30)  -- c112B
                             , trunc(round( nvl(c114,0) / 30 ) /12)                                      -- c113A
                             , round(( nvl(c114,0) - trunc(round(nvl(c114,0) / 30 ) /12 ) * 360 ) / 30)  -- c113B
                             , trunc(round( nvl(c115,0) / 30 ) /12)                                      -- c114A
                             , round(( nvl(c115,0) - trunc(round(nvl(c115,0) / 30 ) /12 ) * 360 ) / 30)  -- c114B
                             , nvl(c116,0)                                                             -- c115
                             , decode(D_decimali, 'X',trunc(nvl(c117,0),2)*100,trunc(nvl(c117,0),0))   -- c116
                             , decode(D_decimali, 'X',trunc(nvl(c118,0),2)*100,trunc(nvl(c118,0),0))   -- c117
                             , decode( decode(D_decimali, 'X',trunc(nvl(c118,0),2)*100,trunc(nvl(C118,0),0))
                                      , 0, null
                                         , decode( nvl(D_titolo_tfr,'X')
                                                 , 'X', decode( nvl(D_fdo_tfr_ap,0) - nvl(D_fdo_tfr_ap_liq,0)
                                                              ,0,'B','A')
                                                      , D_titolo_tfr)
                                     )                                                                 -- c118
                             , decode(D_decimali, 'X',trunc(nvl(c119,0),2)*100,trunc(nvl(c119,0),0))   -- c119
                             , nvl(to_char(c120),' ')                                                  -- c120
                             , decode(D_decimali, 'X',trunc(nvl(c121,0),2)*100,trunc(nvl(c121,0),0))   -- c121
                             , decode(D_decimali, 'X',trunc(nvl(c122,0),2)*100,trunc(nvl(c122,0),0))   -- c122
                             , decode( decode(D_decimali, 'X',trunc(nvl(c122,0),2)*100,trunc(nvl(C122,0),0))
                                      , 0, null
                                         , 'B' )                                                       -- c123
                             , decode(D_decimali, 'X',trunc(nvl(c123,0),2)*100,trunc(nvl(c123,0),0))   -- c124
                             , nvl(to_char(c124),' ')                                                  -- c125
                             , decode(D_decimali, 'X',trunc(nvl(c125,0),2)*100,trunc(nvl(c125,0),0))   -- c126
                             , decode( decode(D_decimali, 'X',trunc(nvl(c125,0),2)*100,trunc(nvl(C125,0),0))
                                      , 0, null
                                         , 'B' )                                                       -- c127
                             , decode(D_decimali, 'X',trunc(nvl(c126,0),2)*100,trunc(nvl(c126,0),0))   -- c128
                             , nvl(c146,' ')                                                           -- c129
                             , decode(D_decimali, 'X',trunc(nvl(c127,0),2)*100,trunc(nvl(c127,0),0))   -- c150
                             , nvl(c128,0)                                                             -- c151
                             , nvl(c129,0)                                                             -- c152
                             , decode(D_decimali, 'X',trunc(nvl(c130,0),2)*100,trunc(nvl(c130,0),0))   -- c153
                             , decode(D_decimali, 'X',trunc(nvl(c131,0),2)*100,trunc(nvl(c131,0),0))   -- c154
                             , decode(D_decimali, 'X',trunc(nvl(c132,0),2)*100,trunc(nvl(c132,0),0))   -- c155
                             , decode(D_decimali, 'X',trunc(nvl(c133,0),2)*100,trunc(nvl(c133,0),0))   -- c156
                             , decode(D_decimali, 'X',trunc(nvl(c134,0),2)*100,trunc(nvl(c134,0),0))   -- c157
                             , decode(D_decimali, 'X',trunc(nvl(c135,0),2)*100,trunc(nvl(c135,0),0))   -- c158
                             , decode(D_decimali, 'X',trunc(nvl(c136,0),2)*100,trunc(nvl(c136,0),0))   -- c159
                             , decode(D_decimali, 'X',trunc(nvl(c137,0),2)*100,trunc(nvl(c137,0),0))   -- c160
                             , decode(D_decimali, 'X',trunc(nvl(c138,0),2)*100,trunc(nvl(c138,0),0))   -- c161
                             , decode(D_decimali, 'X',trunc(nvl(c140,0),2)*100,trunc(nvl(c140,0),0))   -- c162
                          into  D_74, D_75, D_76, D_77, D_78, D_79
                              , D_A80, D_B80, D_A81, D_B81, D_A82, D_B82, D_83, D_84, D_85, D_86
                              , D_87, D_88, D_89, D_90, D_91
                              , D_A92, D_B92, D_A93, D_B93, D_A94, D_B94, D_95, D_96, D_97, D_98
                              , D_99, D_100, D_101, D_102, D_103
                              , D_104, D_105, D_106, D_107, D_108, D_109, D_110, D_111
                              , D_A112, D_B112, D_A113, D_B113, D_A114, D_B114, D_115, D_116, D_117, D_118
                              , D_119, D_120, D_121
                              , D_122, D_123, D_124, D_125, D_126, D_127, D_128, D_129
                              , D_150, D_151, D_152, D_153, D_154
                              , D_155, D_156, D_157, D_158
                              , D_159, D_160, D_161, D_162
                          from denuncia_fiscale
                         where ci = CUR_ANA.ci
                           and anno = D_anno
                           and rilevanza = 'T'
                           and nvl(c73,0) + nvl(c80,0) + nvl(c84,0) + nvl(c86,0) + nvl(c88,0)
                             + nvl(c95,0) + nvl(c96,0) + nvl(c98,0) + nvl(c100,0) + nvl(c112,0)
                             + nvl(c114,0) + nvl(c116,0) + nvl(c117,0) + nvl(c123,0) + nvl(c124,0)
                             + nvl(c126,0) + nvl(c128,0) + nvl(c129,0) + nvl(c131,0) + nvl(c133,0)
                             + nvl(c134,0) + nvl(c135,0) + nvl(c138,0) + nvl(c139,0) + nvl(c140,0)
                             + nvl(c151,0) + nvl(c152,0) + nvl(c153,0) + nvl(c154,0) + nvl(c155,0)
                             + nvl(c156,0) + nvl(c157,0) != 0
                              ;
-- controllo su casella 78 ( campo C76 )
                IF nvl(D_78,'0') not in ('0','1') THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 78 ( 0 o 1 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_78 );
                END IF;
-- controllo sui mesi della casella 80 ( campo C77 )
                IF nvl(D_B80,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 80 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B80 );
                END IF;
-- controllo sui mesi della casella 81 ( campo C78 )
                IF nvl(D_B81,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 81 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B81 );
                END IF;
-- controllo sui mesi della casella 82 ( campo C79 )
                IF nvl(D_B82,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 82 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B82 );
                END IF;
-- controllo su casella 83 ( campo C80 )
                IF nvl(D_83,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Casella 83 maggiore di 100: ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_83 );
                  COMMIT;
                END IF;
-- controllo sulla casella 86 ( campo C83 )
                IF length(nvl(to_number(rtrim(D_86)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(D_86)),D_anno-1) >= D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 86 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_86 );
                END IF;
-- controllo sulla casella 88
                IF nvl(D_88,'B') not in ( 'A', 'B', 'C', 'D', 'E', 'F' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 88 ( A/B/C/D/E/F ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_88 );
                END IF;
-- controllo sulla casella 90 ( campo C86 )
                IF length(nvl(to_number(rtrim(D_90)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(D_90)),D_anno-1) >= D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 90 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_90 );
                END IF;
-- controllo sui mesi della casella 92 ( campo C87 )
                IF nvl(D_B92,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 92 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B92 );
                END IF;
-- controllo sui mesi della casella 93 ( campo C88 )
                IF nvl(D_B93,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 93 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B93 );
                END IF;
-- controllo sui mesi della casella 94 ( campo C89 )
                IF nvl(D_B94,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 94 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B94 );
                END IF;
-- controllo su casella 95 ( campo C90 )
                IF nvl(D_95,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Casella 95 maggiore di 100: ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_95 );
                  COMMIT;
                END IF;
-- controllo sulla casella 98 ( campo in inex  )
                IF nvl(D_98,'B') not in ( 'A', 'B', 'C' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 98 ( A/B/C ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_98 );
                END IF;
-- controllo sulla casella 100 ( campo C94 )
                IF length(nvl(to_number(rtrim(D_100)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(D_100)),D_anno-1) >= D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 99 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_100 );
                END IF;
-- controllo su casella 102 ( campo C96 )
                IF nvl(D_102,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Casella 102 maggiore di 100: ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_102 );
                  COMMIT;
                END IF;
-- controllo sulla casella 105
                IF nvl(D_105,'B') not in ( 'A', 'B', 'C', 'D', 'E', 'F' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 105 ( A/B/C/D/E/F ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_105 );
                END IF;
-- controllo sulla casella 107 ( campo C100 )
                IF length(nvl(to_number(rtrim(D_107)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(D_107)),D_anno-1) >= D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 107 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_107 );
                END IF;
-- controllo sulla casella 109
                IF nvl(D_109,'B') not in ( 'B', 'C' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 109 ( B/C ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_109 );
                END IF;
-- controllo sui mesi della casella 112 ( campo C113 )
                IF nvl(D_B112,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 112 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B112 );
                END IF;
-- controllo sui mesi della casella 113 ( campo C114 )
                IF nvl(D_B113,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 113 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B113 );
                END IF;
-- controllo sui mesi della casella 114 ( campo C115 )
                IF nvl(D_B114,0) > 11 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 114 ( da 1 a 11 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_B114 );
                END IF;
-- controllo su casella 115 ( campo C116 )
                IF nvl(D_115,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Casella 115 maggiore di 100: ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_115 );
                  COMMIT;
                END IF;
-- controllo sulla casella 118 ( campo in inex  )
                IF nvl(D_118,'B') not in ( 'A', 'B', 'C' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 118 ( A/B/C ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_118 );
                END IF;
-- controllo sulla casella 120 ( campo C120 )
                IF length(nvl(to_number(rtrim(D_120)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(D_120)),D_anno-1) >= D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 120 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_120 );
                END IF;
-- controllo sulla casella 123
                IF nvl(D_123,'B') not in ( 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'L' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 123 ( A/B/C/D/E/F/G/H/L ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_123 );
                END IF;
-- controllo sulla casella 125 ( campo C124 )
                IF length(nvl(to_number(rtrim(D_125)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(D_125)),D_anno-1) >= D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 125 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_125 );
                END IF;
-- controllo sulla casella 127
                IF nvl(D_127,'B') not in ( 'B', 'C' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' per Casella 127 ( B/C ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_127 );
                END IF;
-- controllo sulla casella 151 ( campo C128 )
                IF ( nvl(D_151,0) != 0 and nvl(D_84,0) = 0 and nvl(D_97,0) = 0 and nvl(D_117,0) = 0 
                  or nvl(D_151,0) = 0 and nvl(D_84,0) != 0
                  or nvl(D_151,0) = 0 and nvl(D_97,0) != 0
                  or nvl(D_151,0) = 0 and nvl(D_117,0) != 0
                   )
                THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 151 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_151 );
                END IF;
                IF nvl(D_151,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Casella 151 maggiore di 100: ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_151 );
                  COMMIT;
                END IF;
-- controllo sulla casella 152 ( campo C129 )
                IF ( nvl(D_152,0) != 0 and nvl(D_87,0) = 0 and nvl(D_104,0) = 0 
                                       and nvl(D_108,0) = 0 and nvl(D_122,0) = 0 and nvl(D_126,0) = 0
                  or nvl(D_152,0) = 0 and nvl(D_87,0) != 0
                  or nvl(D_152,0) = 0 and nvl(D_104,0) != 0
                  or nvl(D_152,0) = 0 and nvl(D_108,0) != 0
                  or nvl(D_152,0) = 0 and nvl(D_122,0) != 0
                  or nvl(D_152,0) = 0 and nvl(D_126,0) != 0
                   )
                THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Verificare valore casella 152 ( TFR ): ';
                  PECSMFA1.INS_SEER ( prenotazione, cur_ana.ci, D_riga_e, D_errore, D_152 );
                END IF;
                IF nvl(D_152,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_errore := ' Casella 152 maggiore di 100: ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_ANA.ci, D_riga_e, D_errore, D_152 );
                  COMMIT;
                END IF;

                  BEGIN
                   D_riga   := 20;
                   D_step := '1 Insert dati TFR';
                     insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                      values ( prenotazione
                             , 2
                             , CUR_ANA.pagina
                             , D_riga
                             , 'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'074'||
                               lpad(nvl(D_74,' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'075'||
                               lpad(nvl(D_75,' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'076'||
                               lpad(to_char(D_76),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'077'||
                               lpad(to_char(D_77),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'078'||
                               lpad(nvl(substr(D_78,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'079'||
                               rpad(D_79,16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A80'||
                               lpad(to_char(D_A80),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B80'||
                               lpad(to_char(D_B80),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A81'||
                               lpad(to_char(D_A81),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B81'||
                               lpad(to_char(D_B81),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A82'||
                               lpad(to_char(D_A82),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B82'||
                               lpad(to_char(D_B82),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'083'||
                               lpad(translate(to_char(D_83),'.',','),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'084'||
                               lpad(to_char(D_84),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'085'||
                               lpad(to_char(D_85),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'086'||
                               lpad(nvl(rtrim(D_86),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'087'||
                                lpad(to_char(D_87),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'088'||
                               lpad(nvl(substr(D_88,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'089'||
                                lpad(to_char(D_89),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'090'||
                               lpad(nvl(rtrim(D_90),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'091'||
                               rpad(D_91,16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A92'||
                               lpad(to_char(D_A92),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B92'||
                               lpad(to_char(D_B92),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A93'||
                               lpad(to_char(D_A93),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B93'||
                               lpad(to_char(D_B93),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A94'||
                               lpad(to_char(D_A94),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B94'||
                               lpad(to_char(D_B94),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'095'||
                               lpad(translate(to_char(D_95),'.',','),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'096'||
                               lpad(to_char(D_96),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'097'||
                               lpad(to_char(D_97),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'098'||
                               lpad(nvl(substr(D_98,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'099'||
                               lpad(to_char(D_99),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'100'||
                               lpad(nvl(rtrim(D_100),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'101'||
                               lpad(to_char(D_101),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'102'||
                               lpad(translate(to_char(D_102),'.',','),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'103'||
                               lpad(to_char(D_103),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'104'||
                               lpad(to_char(D_104),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'105'||
                               lpad(nvl(substr(D_105,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'106'||
                               lpad(to_char(D_106),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'107'||
                               lpad(nvl(rtrim(D_107),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'108'||
                               lpad(to_char(D_108),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'109'||
                               lpad(nvl(substr(D_109,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'110'||
                               lpad(to_char(D_110),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'111'||
                               rpad(D_111,16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A12'||
                               lpad(to_char(D_A112),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B12'||
                               lpad(to_char(D_B112),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A13'||
                               lpad(to_char(D_A113),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B13'||
                               lpad(to_char(D_B113),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'A14'||
                               lpad(to_char(D_A114),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'B14'||
                               lpad(to_char(D_B114),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'115'||
                               lpad(translate(to_char(D_95),'.',','),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'116'||
                               lpad(to_char(D_116),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'117'||
                               lpad(to_char(D_117),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'118'||
                               lpad(nvl(substr(D_118,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'119'||
                               lpad(to_char(D_119),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'120'||
                               lpad(nvl(rtrim(D_120),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'121'||
                               lpad(to_char(D_121),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'122'||
                               lpad(to_char(D_122),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'123'||
                               lpad(nvl(substr(D_123,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'124'||
                               lpad(to_char(D_124),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'125'||
                               lpad(nvl(rtrim(D_125),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'126'||
                               lpad(to_char(D_126),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'127'||
                               lpad(nvl(substr(D_127,1,1),' '),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'128'||
                               lpad(to_char(D_128),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'129'||
                               rpad(D_129,16,' ')||
                               '{'
                            );

                     D_riga   := D_riga +1;
                     D_step := '2 Insert dati TFR';
                     insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                      values ( prenotazione
                             , 2
                             , CUR_ANA.pagina
                             , D_riga
                             , 'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'150'||
                               lpad(to_char(D_150),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'151'||
                               lpad(translate(to_char(D_151),'.',','),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'152'||
                               lpad(translate(to_char(D_152),'.',','),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'153'||
                               lpad(to_char(D_153),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'154'||
                               lpad(to_char(D_154),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'155'||
                               lpad(to_char(D_155),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'156'||
                               lpad(to_char(D_156),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'157'||
                               lpad(to_char(D_157),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'158'||
                               lpad(to_char(D_158),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'159'||
                               lpad(to_char(D_159),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'160'||
                               lpad(to_char(D_160),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'161'||
                               lpad(to_char(D_161),16,' ')||
                               'DB'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'162'||
                               lpad(to_char(D_162),16,' ')||
                              '{'
                            )
                     ;
                  END; -- fine insert dati TFR
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN null;
                END DEFS_TFR;
--
-- Dati assistenziali parte D
--
              BEGIN
              <<PARTE_D>>
              D_step := 'Select dati Assistenziali';
               select 'x'
                 into d_dummy
                 from dual
                where exists (select 'x'
                                from archivio_assistenza_fiscale asfi
                               where anno (+) = D_anno
                                 and ci in (select CUR_ANA.ci
                                              from dual
                                             union
                                            select ci_erede
                                              from RAPPORTI_DIVERSI radi
                                             where radi.ci = CUR_ANA.ci
                                               and radi.rilevanza in ('L','R')
                                               and radi.anno = D_anno
                                           )
                             )
               ;
               D_ente_cf       := CUR_ana.ente_cf;
               --
               --  Estrazione Dati 730 da ASFI
               --
                 BEGIN
                 D_step := 'Select dati da Archivio Assistenza Fiscale';
                 select max(nvl(asfi.moco_mese1,0))           mese
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n1),0),2)*100,trunc(nvl(sum(moco_n1),0),0))   irpef_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n2),0),2)*100,trunc(nvl(sum(moco_n2),0),0))   irpef_db
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n3),0),2)*100,trunc(nvl(sum(moco_n3),0),0))   irpef_int
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n4),0),2)*100,trunc(nvl(sum(moco_n4),0),0))   irpef_1r
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n5),0),2)*100,trunc(nvl(sum(moco_n5),0),0))   irpef_1r_int
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n6),0),2)*100,trunc(nvl(sum(moco_n6),0),0))   irpef_ret_1r
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n7),0),2)*100,trunc(nvl(sum(moco_n7),0),0))   add_r_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n8),0),2)*100,trunc(nvl(sum(moco_n8),0),0))   add_r_db
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n9),0),2)*100,trunc(nvl(sum(moco_n9),0),0))   add_r_int
                      , max(nvl(asfi.deca_c1,'0'))            cod_reg_dic
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n10),0),2)*100,trunc(nvl(sum(moco_n10),0),0)) add_r_crc
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n11),0),2)*100,trunc(nvl(sum(moco_n11),0),0)) add_r_dbc
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n12),0),2)*100,trunc(nvl(sum(moco_n12),0),0)) add_r_intc
                      , max(nvl(asfi.deca_c2,'0'))            cod_reg_con
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n13),0),2)*100,trunc(nvl(sum(moco_n13),0),0)) add_c_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n14),0),2)*100,trunc(nvl(sum(moco_n14),0),0)) add_c_db
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n15),0),2)*100,trunc(nvl(sum(moco_n15),0),0)) add_c_int
                      , max(nvl(asfi.deca_c3,'0'))            cod_com_dic
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n16),0),2)*100,trunc(nvl(sum(moco_n16),0),0)) add_c_crc
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n17),0),2)*100,trunc(nvl(sum(moco_n17),0),0)) add_c_dbc
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n18),0),2)*100,trunc(nvl(sum(moco_n18),0),0)) add_c_intc
                      , max(nvl(asfi.deca_c4,'0'))            cod_com_con
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n19),0),2)*100,trunc(nvl(sum(moco_n19),0),0)) irpef_ap
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n20),0),2)*100,trunc(nvl(sum(moco_n20),0),0)) irpef_ap_int
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n21),0),2)*100,trunc(nvl(sum(moco_n21),0),0)) irpef_ret_ap
                      , max(asfi.deca_c5)                     tipo_cong
                      , max(asfi.deca_c6)                     rettificativo
                      , max(asfi.deca_c7)                     integrativo
                      , max(nvl(asfi.moco_mese2,0))           r_mese
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n22),0),2)*100,trunc(nvl(sum(moco_n22),0),0)) irpef_2r
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n23),0),2)*100,trunc(nvl(sum(moco_n23),0),0)) irpef_2r_int
                      , decode(D_decimali,'X',trunc(nvl(sum(moco_n24),0),2)*100,trunc(nvl(sum(moco_n24),0),0)) irpef_ret_2r
                      , max(asfi.deca_c8)                     esito_2r
                      , max(nvl(asfi.moco_mese3,0))           rt_mese1
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n1),0),2)*100,trunc(nvl(sum(deca_n1),0),0))   r_irpef_db
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n2),0),2)*100,trunc(nvl(sum(deca_n2),0),0))   r_irpef_1r
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n3),0),2)*100,trunc(nvl(sum(deca_n3),0),0))   r_add_r_db
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n4),0),2)*100,trunc(nvl(sum(deca_n4),0),0))   r_add_r_dbc
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n5),0),2)*100,trunc(nvl(sum(deca_n5),0),0))   r_add_c_db
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n6),0),2)*100,trunc(nvl(sum(deca_n6),0),0))   r_add_c_dbc
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n7),0),2)*100,trunc(nvl(sum(deca_n7),0),0))   r_irpef_ap
                      , max(nvl(asfi.moco_mese4,0))           rt_mese2
                      , decode(D_decimali,'X',trunc(nvl(sum(deca_n8),0),2)*100,trunc(nvl(sum(deca_n8),0),0))   r_irpef_2r
                      , max(asfi.deca_c9)                     esito_cong
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n1),0),2)*100,trunc(nvl(sum(diff_n1),0),0))   T_irpef_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n2),0),2)*100,trunc(nvl(sum(diff_n2),0),0))   T_irpef_db
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n3),0),2)*100,trunc(nvl(sum(diff_n3),0),0))   T_irpef_1r_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n4),0),2)*100,trunc(nvl(sum(diff_n4),0),0))   T_irpef_1r_db
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n5),0),2)*100,trunc(nvl(sum(diff_n5),0),0))   T_add_r_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n6),0),2)*100,trunc(nvl(sum(diff_n6),0),0))   T_add_r_db
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n7),0),2)*100,trunc(nvl(sum(diff_n7),0),0))   T_add_r_crc
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n8),0),2)*100,trunc(nvl(sum(diff_n8),0),0))   T_add_r_dbc
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n9),0),2)*100,trunc(nvl(sum(diff_n9),0),0))   T_add_c_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n10),0),2)*100,trunc(nvl(sum(diff_n10),0),0)) T_add_c_db
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n11),0),2)*100,trunc(nvl(sum(diff_n11),0),0)) T_add_c_crc
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n12),0),2)*100,trunc(nvl(sum(diff_n12),0),0)) T_add_c_dbc
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n13),0),2)*100,trunc(nvl(sum(diff_n13),0),0)) T_irpef_ap_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n14),0),2)*100,trunc(nvl(sum(diff_n14),0),0)) T_irpef_ap_db
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n15),0),2)*100,trunc(nvl(sum(diff_n15),0),0)) T_irpef_2r_cr
                      , decode(D_decimali,'X',trunc(nvl(sum(diff_n16),0),2)*100,trunc(nvl(sum(diff_n16),0),0)) T_irpef_2r_db
                   into D_mese
                      , D_irpef_cr
                      , D_irpef_db
                      , D_irpef_int
                      , D_irpef_1r
                      , D_irpef_1r_int
                      , D_irpef_ret_1r
                      , D_add_r_cr
                      , D_add_r_db
                      , D_add_r_int
                      , D_cod_reg_dic
                      , D_add_r_crc
                      , D_add_r_dbc
                      , D_add_r_intc
                      , D_cod_reg_con
                      , D_add_c_cr
                      , D_add_c_db
                      , D_add_c_int
                      , D_cod_com_dic
                      , D_add_c_crc
                      , D_add_c_dbc
                      , D_add_c_intc
                      , D_cod_com_con
                      , D_irpef_ap
                      , D_irpef_ap_int
                      , D_irpef_ret_ap
                      , D_c_tipo_cong
                      , D_c_rett
                      , D_st_tipo
                      , D_r_mese
                      , D_irpef_2r
                      , D_irpef_2r_int
                      , D_irpef_ret_2r
                      , D_esito_2r
                      , D_rt_mese1
                      , D_r_irpef_db
                      , D_r_irpef_1r
                      , D_r_add_r_db
                      , D_r_add_r_dbc
                      , D_r_add_c_db
                      , D_r_add_c_dbc
                      , D_r_irpef_ap
                      , D_rt_mese2
                      , D_r_irpef_2r
                      , D_esito_cong
                      , T_irpef_cr
                      , T_irpef_db
                      , T_irpef_1r_cr
                      , T_irpef_1r_db
                      , T_add_r_cr
                      , T_add_r_db
                      , T_add_r_crc
                      , T_add_r_dbc
                      , T_add_c_cr
                      , T_add_c_db
                      , T_add_c_crc
                      , T_add_c_dbc
                      , T_irpef_ap_cr
                      , T_irpef_ap_db
                      , T_irpef_2r_cr
                      , T_irpef_2r_db
                   from archivio_assistenza_fiscale asfi
                  where asfi.anno      = D_anno
                    and asfi.ci in (select CUR_ANA.ci
                                      from dual
                                     union
                                    select ci_erede
                                      from RAPPORTI_DIVERSI radi
                                     where radi.ci = CUR_ANA.ci
                                       and radi.rilevanza in ('L','R')
                                       and radi.anno = D_anno
                                    )
                 ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN 
                       D_mese            := 0;
                       D_irpef_cr        := 0;
                       D_irpef_db        := 0;
                       D_irpef_int       := 0;
                       D_irpef_1r        := 0;
                       D_irpef_1r_int    := 0;
                       D_irpef_ret_1r    := 0;
                       D_add_r_cr        := 0;
                       D_add_r_db        := 0;
                       D_add_r_int       := 0;
                       D_cod_reg_dic     := null;
                       D_add_r_crc       := 0;
                       D_add_r_dbc       := 0;
                       D_add_r_intc      := 0;
                       D_cod_reg_con     := null;
                       D_add_c_cr        := 0;
                       D_add_c_db        := 0;
                       D_add_c_int       := 0;
                       D_cod_com_dic     := null;
                       D_add_c_crc       := 0;
                       D_add_c_dbc       := 0;
                       D_add_c_intc      := 0;
                       D_cod_com_con     := null;
                       D_irpef_ap        := 0;
                       D_irpef_ap_int    := 0;
                       D_irpef_ret_ap    := 0;
                       D_c_tipo_cong     := null;
                       D_c_rett          := null;
                       D_st_tipo         := null;
                       D_r_mese          := 0;
                       D_irpef_2r        := 0;
                       D_irpef_2r_int    := 0;
                       D_irpef_ret_2r    := 0;
                       D_esito_2r        := null;
                       D_rt_mese1        := 0;
                       D_r_irpef_db      := 0;
                       D_r_irpef_1r      := 0;
                       D_r_add_r_db      := 0;
                       D_r_add_r_dbc     := 0;
                       D_r_add_c_db      := 0;
                       D_r_add_c_dbc     := 0;
                       D_r_irpef_ap      := 0;
                       D_rt_mese2        := 0;
                       D_r_irpef_2r      := 0;
                       T_irpef_cr        := 0;
                       T_irpef_db        := 0;
                       T_irpef_1r_cr     := 0;
                       T_irpef_1r_db     := 0;
                       T_add_r_cr        := 0;
                       T_add_r_db        := 0;
                       T_add_r_crc       := 0;
                       T_add_r_dbc       := 0;
                       T_add_c_cr        := 0;
                       T_add_c_db        := 0;
                       T_add_c_crc       := 0;
                       T_add_c_dbc       := 0;
                       T_irpef_ap_cr     := 0;
                       T_irpef_ap_db     := 0;
                       T_irpef_2r_cr     := 0;
                       T_irpef_2r_db     := 0;
                 END;

                 BEGIN
                 D_step := '1 Select dati caaf';
                 select max(decode(conguaglio_2r,'F',' ','P','F',conguaglio_2r))  conguaglio_2r
                      , max( decode( caaf.codice_fiscale
                                   , rtrim(CUR_ana.ente_cf), ' '
                                                     , upper(caaf.cognome))
                            )                            caaf_nome
                      , max( decode( caaf.codice_fiscale
                                   , rtrim(CUR_ana.ente_cf), ' '
                                                     , caaf.codice_fiscale)
                             )                     caaf_cod_fis
                      , max( decode( caaf.codice_fiscale
                                   , rtrim(CUR_ana.ente_cf), '0'
                                            , substr(ltrim(rtrim(caaf.numero_doc)),1,5))
                            )                     caaf_nr_albo
                      , to_char(max( decode( caaf.codice_fiscale
                                           , rtrim(CUR_ana.ente_cf), to_date(null)
                                                  , decode( deca.rettifica
                                                          , 'A', to_date(null)
                                                               , data_ricezione))
                                    ),'ddmm')                    data_ric
                   into D_cong_2r
                      , D_caaf_nome
                      , D_caaf_cod_fis
                      , D_caaf_nr_albo
                      , D_data_ric
                   from anagrafici     caaf
                      , denuncia_caaf  deca
                  where deca.anno      = D_anno - 1
                    and rettifica     != 'M'
                    and deca.ci in (select CUR_ANA.ci
                                      from dual
                                     union
                                    select ci_erede
                                      from RAPPORTI_DIVERSI radi
                                     where radi.ci = CUR_ANA.ci
                                       and radi.rilevanza in ('L','R')
                                       and radi.anno = D_anno
                                    )
                    and deca.tipo      = 0
                    and caaf.ni        =
                       (select ni from rapporti_individuali
                         where ci = deca.ci_caaf)
                    and caaf.al       is null
                 ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        D_cong_2r       := ' ';
                        D_caaf_nome     := ' ';
                        D_caaf_cod_fis  := ' ';
                        D_caaf_nr_albo  := ' ';
                        D_data_ric      := '0';
                 END;
  
                 BEGIN
                 D_step := '2 Select dati caaf';
                 select to_char(min( decode( caaf.codice_fiscale
                                           , rtrim(CUR_ANA.ente_cf), to_date(null)
                                                  , data_ricezione)
                                    ),'ddmm')                    data_ric_int
                   into D_data_ric_int
                   from anagrafici     caaf
                      , denuncia_caaf  deca
                  where deca.anno      = D_anno - 1
                    and rettifica      in ('B','F')
                    and deca.ci in (select CUR_ANA.ci
                                       from dual
                                      union
                                     select ci_erede
                                       from RAPPORTI_DIVERSI radi
                                      where radi.ci = CUR_ANA.ci
                                        and radi.rilevanza in ('L','R')
                                        and radi.anno = D_anno
                                    )
                    and deca.tipo      = 0
                    and caaf.ni        =
                       (select ni from rapporti_individuali
                         where ci = deca.ci_caaf)
                    and caaf.al       is null
                 ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN D_data_ric_int := '0';
                 END;
  
                 BEGIN
                 D_step := '3 Select dati caaf';
                 select to_char(min( decode( caaf.codice_fiscale
                                           , rtrim(CUR_ANA.ente_cf), to_date(null)
                                                                   , data_ricezione)
                                   ),'ddmm')               data_prima_ric
                   into D_data_prima_ric
                   from anagrafici     caaf
                      , denuncia_caaf  deca
                  where deca.anno      = D_anno - 1
                    and rettifica      = 'M'
                    and deca.ci in (select CUR_ANA.ci
                                      from dual
                                     union
                                     select ci_erede
                                       from RAPPORTI_DIVERSI radi
                                      where radi.ci = CUR_ANA.ci
                                        and radi.rilevanza in ('L','R')
                                        and radi.anno = D_anno
                                    )
                   and deca.tipo      = 0
                    and caaf.ni        =
                       (select ni from rapporti_individuali
                         where ci = deca.ci_caaf)
                    and caaf.al       is null
                 ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN D_data_prima_ric:= '';
                 END;
  
                 IF nvl(D_irpef_cr,0) + nvl(D_irpef_db,0) + nvl(D_irpef_int,0) +
                     nvl(D_irpef_1r,0) + nvl(D_irpef_1r_int,0) + nvl(D_irpef_ret_1r,0) +
                     nvl(D_add_r_cr,0) + nvl(D_add_r_db,0) + nvl(D_add_r_int,0) + 
                     nvl(D_add_r_crc,0) + nvl(D_add_r_dbc,0) + nvl(D_add_r_intc,0) +
                     nvl(D_add_c_cr,0) + nvl(D_add_c_db,0) + nvl(D_add_c_int,0) +
                     nvl(D_add_c_crc,0) + nvl(D_add_c_dbc,0) + nvl(D_add_c_intc,0) +
                     nvl(D_irpef_ap,0) + nvl(D_irpef_ap_int,0) + nvl(D_irpef_ret_ap,0) = 0 then
                      D_mese := null;
                 END IF;
  
                 D_casella5  := null;
                 D_casella9  := null;
                 D_casella13 := null;
                 D_casella18 := null;
                 D_casella23 := null;
                 D_casella28 := null;
                 D_casella33 := null;
                
                 IF (nvl(D_irpef_cr,0)!=0 and nvl(D_irpef_cr,0) < 1) and  (nvl(D_irpef_db,0)!=0 and nvl(D_irpef_db,0) < 1) and (nvl(D_irpef_int + D_irpef_ris,0)!=0 and nvl(D_irpef_int + D_irpef_ris,0) <1) THEN
                    D_casella5 := '1';
                 END IF;
                 IF (nvl(D_irpef_1r,0)!=0 and nvl(D_irpef_1r,0) <1) and (nvl(D_irpef_1r_int+D_irpef_ri1r,0)!=0 and nvl(D_irpef_1r_int+D_irpef_ri1r,0) <1) and (nvl(D_irpef_ret_1r,0)!=0 and nvl(D_irpef_ret_1r,0) <1) THEN
                     D_casella9 := '1';
                 END IF;
                 IF (nvl(D_add_r_cr,0)!=0 and nvl(D_add_r_cr,0) <1) and (nvl(D_add_r_db,0)!=0 and nvl(D_add_r_db,0)<1) and (nvl(D_add_r_int+D_add_r_ris,0)!=0 and nvl(D_add_r_int+D_add_r_ris,0)<1) THEN
                     D_casella13 := '1';
                 END IF;
                 IF (nvl(D_add_r_crc,0)!=0 and nvl(D_add_r_crc,0)<1) and (nvl(D_add_r_dbc,0)!=0 and nvl(D_add_r_dbc,0)<1) and (nvl(D_add_r_intc,0)!=0 and nvl(D_add_r_intc,0)<1) THEN
                     D_casella18 := '1';
                 END IF;
                 IF (nvl(D_add_c_cr,0)!=0 and nvl(D_add_c_cr,0)<1) and (nvl(D_add_c_db,0)!=0 and nvl(D_add_c_db,0)<1) and (nvl(D_add_c_int,0)!=0 and nvl(D_add_c_int,0)<1) THEN
                     D_casella23 := '1';
                 END IF;
                 IF (nvl(D_add_c_crc,0)!=0 and nvl(D_add_c_crc,0)<1) and (nvl(D_add_c_dbc,0)!=0 and nvl(D_add_c_dbc,0)<1) and (nvl(D_add_c_intc,0)!=0 and nvl(D_add_c_intc,0)<1) THEN
                     D_casella28 := '1';
                 END IF;
                 IF (nvl(D_irpef_ap,0)!=0 and nvl(D_irpef_ap,0)<1) and (nvl(D_irpef_ap_int+D_irpef_riap,0)!=0 and nvl(D_irpef_ap_int+D_irpef_riap,0)<1) and (nvl(D_irpef_ret_ap,0)!=0 and nvl(D_irpef_ret_ap,0)<1) THEN
                     D_casella33 := '1';
                 END IF;
                 IF nvl(D_irpef_2r,0)+nvl(D_irpef_2r_int,0)+nvl(D_irpef_ret_2r,0) = 0 THEN
                    D_r_mese := null;
                 END IF;
                 /* la casella 42 e settata a B se la somma delle caselle 39,40,41 e < 1 */
                 IF nvl(D_esito_2r,' ') != 'A' and (nvl(D_irpef_2r,0) + nvl(D_irpef_2r_int,0) + nvl(D_irpef_ret_2r,0)) < 1 and (nvl(D_irpef_2r,0) + nvl(D_irpef_2r_int,0) + nvl(D_irpef_ret_2r,0)) != 0 THEN
                    D_esito_2r := 'B';
                 END IF;
  
                BEGIN
                D_riga := 60;
                D_step := '1 Insert dati Denuncia Caaf';
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                      , 2
                      , CUR_ANA.pagina
                      , D_riga
                      , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'001'||
                        lpad(nvl(lpad(to_char(D_mese),2,'0'),' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'002'||
                        lpad(nvl(to_char(decode(nvl(D_irpef_cr,0),0,null,D_irpef_cr)),' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'003'||
                        lpad(nvl(to_char(decode(nvl(D_irpef_db,0),0,null,D_irpef_db)),' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'004'||
                        lpad(nvl(to_char(decode(nvl(D_irpef_int,0),0,null,D_irpef_int)),' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'005'||
                        lpad(nvl(D_casella5,' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'006'||
                        lpad(nvl(to_char(decode(nvl(D_irpef_1r,0),0,null,D_irpef_1r)),' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'007'||
                        lpad(nvl(to_char(decode(nvl(D_irpef_1r_int,0),0,null,D_irpef_1r_int)),' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'008'||
                        lpad(nvl(to_char(decode(nvl(D_irpef_ret_1r,0),0,null,D_irpef_ret_1r)),' '),16,' ')||
                        'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'009'||
                        lpad(nvl(D_casella9,' '),16,' ')||
                        '{'
                      )
                ;
                D_step := '2 Insert dati Denuncia Caaf';
                D_riga := D_riga + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 2
                       , CUR_ANA.pagina
                       , D_riga
                       , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'010'||
                         lpad(nvl(to_char(decode(nvl(D_add_r_cr,0),0,null,D_add_r_cr)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'011'||
                         lpad(nvl(to_char(decode(nvl(D_add_r_db,0),0,null,D_add_r_db)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'012'||
                         lpad(nvl(to_char(decode(nvl(D_add_r_int,0),0,null,D_add_r_int)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'013'||
                         lpad(nvl(D_casella13,' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'014'||
                         lpad(decode(nvl(D_cod_reg_dic,'0'),'0',' ',D_cod_reg_dic),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'015'||
                         lpad(nvl(to_char(decode(nvl(D_add_r_crc,0),0,null,D_add_r_crc)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'016'||
                         lpad(nvl(to_char(decode(nvl(D_add_r_dbc,0),0,null,D_add_r_dbc)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'017'||
                         lpad(nvl(to_char(decode( nvl(D_add_r_intc,0),0,null,D_add_r_intc)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'018'||
                         lpad(nvl(D_casella18,' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'019'||
                         lpad(decode(nvl(D_cod_reg_con,'0'),'0',' ',D_cod_reg_con),16,' ')||
                         '{'
                       )
                ;
                D_step := '3 Insert dati Denuncia Caaf';
                D_riga := D_riga + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 2
                       , CUR_ANA.pagina
                       , D_riga
                       , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'020'||
                         lpad(nvl(to_char(decode(nvl(D_add_c_cr,0),0,null,D_add_c_cr)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'021'||
                         lpad(nvl(to_char(decode(nvl(D_add_c_db,0),0,null,D_add_c_db)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'022'||
                         lpad(nvl(to_char(decode(nvl(D_add_c_int,0),0,null,nvl(D_add_c_int,0))),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'023'||
                         lpad(nvl(D_casella23,' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'024'||
                         lpad(decode(nvl(D_cod_com_dic,'0'),'0',' ',D_cod_com_dic),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'025'||
                         lpad(nvl(to_char(decode(nvl(D_add_c_crc,0),0,null,D_add_c_crc)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'026'||
                         lpad(nvl(to_char(decode(nvl(D_add_c_dbc,0),0,null,D_add_c_dbc)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'027'||
                         lpad(nvl(to_char(decode(nvl(D_add_c_intc,0),0,null,D_add_c_intc)),' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'028'||
                         lpad(nvl(D_casella28,' '),16,' ')||
                         'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'029'||
                         lpad(decode(nvl(D_cod_com_con,'0'),'0',' ',D_cod_com_con),16,' ')||
                         '{'
                       )
                ;
                  D_step := '4 Insert dati Denuncia Caaf';
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 2
                         , CUR_ANA.pagina
                         , D_riga
                         , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'030'||
                           lpad(nvl(to_char(decode(nvl(D_irpef_ap,0),0,null,D_irpef_ap)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'031'||
                           lpad(nvl(to_char(decode(nvl(D_irpef_ap_int,0),0, null, D_irpef_ap_int)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'032'||
                           lpad(nvl(to_char(decode(nvl(D_irpef_ret_ap,0),0,null,D_irpef_ret_ap)),' '),16,' ')||
                          'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'033'||
                           lpad(nvl(D_casella33,' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'034'||
                           rpad(nvl(D_c_tipo_cong,' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'035'||
                           rpad(nvl(D_c_rett,' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'036'||
                           rpad(nvl(D_st_tipo,' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'037'||
                           lpad(' ',16,' ')||
                           '{'
                         )
                  ;
                  D_step := '5 Insert dati Denuncia Caaf';
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 2
                         , CUR_ANA.pagina
                         , D_riga
                         , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'038'||
                           lpad(nvl(lpad(to_char(D_r_mese),2,'0'),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'039'||
                           lpad(nvl(to_char(decode(nvl(D_irpef_2r,0),0,null,D_irpef_2r)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'040'||
                           lpad(nvl(to_char(decode(nvl(D_irpef_2r_int,0),0,null,D_irpef_2r_int)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'041'||
                           lpad(nvl(to_char(decode(nvl(D_irpef_ret_2r,0),0,null,D_irpef_ret_2r)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'042'||
                           rpad(nvl(D_esito_2r,' '),16,' ')||
                           '{'
                         )
                  ;
                  D_step := '6 Insert dati Denuncia Caaf';
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 2
                         , CUR_ANA.pagina
                         , D_riga
                         , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'043'||
                           lpad(nvl(lpad(to_char(D_rt_mese1),2,'0'),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'044'||
                           lpad(nvl(to_char(decode(nvl(D_r_irpef_db,0),0,null,D_r_irpef_db)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'045'||
                           lpad(nvl(to_char(decode(nvl(D_r_irpef_1r,0),0,null,D_r_irpef_1r)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'046'||
                           lpad(nvl(to_char(decode(nvl(D_r_add_r_db,0),0,null,D_r_add_r_db)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'047'||
                           lpad(nvl(to_char(decode(nvl(D_r_add_r_dbc,0),0,null,D_r_add_r_dbc)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'048'||
                           lpad(nvl(to_char(decode(nvl(D_r_add_c_db,0),0,null,D_r_add_c_db)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'049'||
                           lpad(nvl(to_char(decode(nvl(D_r_add_c_dbc,0),0,null,D_r_add_c_dbc)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'050'||
                           lpad(nvl(to_char(decode(nvl(D_r_irpef_ap,0),0,null,D_r_irpef_ap)),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'051'||
                           lpad(nvl(lpad(to_char(D_rt_mese2),2,'0'),' '),16,' ')||
                           'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'052'||
                           lpad(nvl(to_char(decode(nvl(D_r_irpef_2r,0),0,null,D_r_irpef_2r)),' '),16,' ')||
                           '{'
                         )
                  ;
                   BEGIN
                      select 'Y'
                        into D_non_terminato
                        from denuncia_caaf
                       where anno = D_anno - 1
                         and ci in (select CUR_ANA.ci
                                     from dual
                                    union
                                   select ci_erede
                                     from RAPPORTI_DIVERSI radi
                                    where radi.ci = CUR_ANA.ci
                                      and radi.rilevanza in ('L','R')
                                      and radi.anno = D_anno
                                  )
                         and rettifica = 'A'
                      ;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                      BEGIN
                        select 'X'
                          into D_non_terminato
                          from dual
                         where nvl(T_irpef_cr,0) != 0
                            or nvl(T_irpef_db,0) != 0
                            or nvl(T_irpef_1r_cr,0) != 0
                            or nvl(T_irpef_1r_db,0) != 0
                            or nvl(T_irpef_2r_cr,0) != 0
                            or nvl(T_irpef_2r_db,0) != 0
                            or nvl(T_irpef_ap_cr,0) != 0
                            or nvl(T_irpef_ap_db,0) != 0
                            or nvl(T_add_r_cr,0) != 0
                            or nvl(T_add_r_db,0) != 0
                            or nvl(T_add_c_cr,0) != 0
                            or nvl(T_add_c_db,0) != 0
                            or nvl(T_add_r_crc,0) != 0
                            or nvl(T_add_r_dbc,0) != 0
                            or nvl(T_add_c_crc,0) != 0
                            or nvl(T_add_c_dbc,0) != 0
                        ;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          D_non_terminato := null;
                      END;
                    END;
                    IF nvl(D_non_terminato,' ') = 'Y' 
                    and (  D_esito_cong is not null 
                        or nvl(T_irpef_cr,0) != 0
                        or nvl(T_irpef_db,0) != 0
                        or nvl(T_irpef_1r_cr,0) != 0
                        or nvl(T_irpef_1r_db,0) != 0
                        or nvl(T_irpef_2r_cr,0) != 0
                        or nvl(T_irpef_2r_db,0) != 0
                        or nvl(T_irpef_ap_cr,0) != 0
                        or nvl(T_irpef_ap_db,0) != 0
                        or nvl(T_add_r_cr,0) != 0
                        or nvl(T_add_r_db,0) != 0
                        or nvl(T_add_c_cr,0) != 0
                        or nvl(T_add_c_db,0) != 0
                        or nvl(T_add_r_crc,0) != 0
                        or nvl(T_add_r_dbc,0) != 0
                        or nvl(T_add_c_crc,0) != 0
                        or nvl(T_add_c_dbc,0) != 0
                        )
                    THEN
                       D_errore := 'possibile inconguenza tra Rettificativi ed Integrativi';
                       D_riga_e := D_riga_e + 1;
                      INSERT INTO a_segnalazioni_errore
                      (no_prenotazione,passo,progressivo,errore,precisazione)
                      VALUES (prenotazione,2,D_riga_e,'P06716'     -- Attenzione: i dati sono incongruenti, verificare
                             ,D_errore||SUBSTR(' per Dip.:'||TO_CHAR(CUR_ANA.ci),1,50));
                    END IF;
                      BEGIN
                        D_step := '7 Insert dati Denuncia Caaf';
                        D_riga := D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values ( prenotazione
                               , 2
                               , CUR_ANA.pagina
                               , D_riga
                               , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'053'||
                                 rpad(nvl(D_esito_cong,' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'054'||
                                 lpad(nvl(to_char(decode(nvl(T_irpef_cr,0),0,null,T_irpef_cr)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'055'||
                                 lpad(nvl(to_char(decode(nvl(T_irpef_db,0),0,null,T_irpef_db)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'056'||
                                 lpad(nvl(to_char(decode(nvl(T_irpef_1r_cr,0),0,null,T_irpef_1r_cr)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'057'||
                                 lpad(nvl(to_char(decode(nvl(T_irpef_1r_db,0),0,null,T_irpef_1r_db)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'058'||
                                 lpad(nvl(to_char(decode(nvl(T_add_r_cr,0),0,null,T_add_r_cr)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'059'||
                                 lpad(nvl(to_char(decode(nvl(T_add_r_db,0),0,null,T_add_r_db)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'060'||
                                 lpad(nvl(to_char(decode(nvl(T_add_r_crc,0),0,null,T_add_r_crc)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'061'||
                                 lpad(nvl(to_char(decode(nvl(T_add_r_dbc,0),0,null,T_add_r_dbc)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'062'||
                                 lpad(nvl(to_char(decode(nvl(T_add_c_cr,0),0,null,T_add_c_cr)),' '),16,' ')||
                                 '{'
                               )
                        ;
                        D_step := '8 Insert dati Denuncia Caaf';
                        D_riga := D_riga + 1;
                        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                        values ( prenotazione
                               , 2
                               , CUR_ANA.pagina
                               , D_riga
                               , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'063'||
                                 lpad(nvl(to_char(decode(nvl(T_add_c_db,0),0,null,T_add_c_db)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'064'||
                                 lpad(nvl(to_char(decode(nvl(T_add_c_crc,0),0,null,T_add_c_crc)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'065'||
                                 lpad(nvl(to_char(decode(nvl(T_add_c_dbc,0),0,null,T_add_c_dbc)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'066'||
                                 lpad(nvl(to_char(decode(nvl(T_irpef_ap_cr,0),0,null,T_irpef_ap_cr)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'067'||
                                 lpad(nvl(to_char(decode(nvl(T_irpef_ap_db,0),0,null,T_irpef_ap_db)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'068'||
                                 lpad(nvl(to_char(decode(nvl(T_irpef_2r_cr,0),0,null,T_irpef_2r_cr)),' '),16,' ')||
                                 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'069'||
                                 lpad(nvl(to_char(decode(nvl(D_cong_2r,' ')
                                                        ,' ',null
                                                            , decode(nvl(T_irpef_2r_db,0),0,null,T_irpef_2r_db)
                                                        ))
                                                        ,' '),16,' ')||
                                 '{'
                               )
                        ;
                      END;
                  D_step := '9 Insert dati Denuncia Caaf';
                  D_riga := 68;--D_riga +1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                    values ( prenotazione
                           , 2
                           , CUR_ANA.pagina
                           , D_riga
                           , 'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'070'||
                             rpad(nvl(D_caaf_cod_fis,' '),16,' ')||
                             'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'071'||
                             lpad(nvl(lpad(D_caaf_nr_albo,5,'0'),' '),16,' ')||
                             'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'072'||
                             lpad(nvl(D_data_prima_ric,nvl(D_data_ric,'0')),16,' ')||
                             'DD'||lpad(to_char(CUR_ANA.num_ord),3,'0')||'073'||
                             lpad(nvl(D_data_ric_int,'0'),16,' ')||
                             '}'
                           )
                    ;
  
                END; -- insert dati assistenzali
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 null;
              END PARTE_D;
            END IF; -- controllo su ana.ci != D_ci
         EXCEPTION
         WHEN OTHERS THEN
           D_errore := SUBSTR(SQLERRM,1,200);
           D_riga_e := D_riga_e + 1;
           INSERT INTO a_segnalazioni_errore
           (no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES (prenotazione,2,D_riga_e,'P05832',SUBSTR('Dip.:'||TO_CHAR(CUR_ANA.ci)||' '||D_step,1,50));
           D_riga_e := D_riga_e + 1;
           INSERT INTO a_segnalazioni_errore
           (no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES (prenotazione,2,D_riga_e,'P05832',SUBSTR(D_errore,1,50));
           COMMIT;
         END;
           INSERT INTO a_segnalazioni_errore
           (no_prenotazione,passo,progressivo,errore,precisazione)
           select prenotazione,2,D_riga_e + rownum,
                  'P05840',SUBSTR('Dip.: '||TO_CHAR(CUR_ANA.ci)||' Nei dati '||
                           decode(substr(lpad(apst.riga,2,0),1,1)
                                 , 1, 'Fiscali'
                                 , 2, 'Fiscali TFR'
                                 , 3, decode(substr(lpad(apst.riga,2,0),1,2)
                                            , 31, 'Prev. EMENS'
                                            , 32, 'Prev. EMENS'
                                            , 35, 'Prev. DMA')
                                 , 6,'Ass. Fiscale'),1,50)
             from a_appoggio_stampe apst
            where apst.no_prenotazione = prenotazione
              and apst.pagina = CUR_ANA.pagina
              and apst.riga not between 40
                                    and 49
              and apst.riga >= 10
              and instr(apst.testo,'-') != 0
           ;
           COMMIT;
        D_ci := CUR_ANA.ci;
       END LOOP; -- cur_ana
      END;
EXCEPTION
WHEN NO_QUALIFICA THEN
     null;
END; -- main
end;
end;
/
