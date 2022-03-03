CREATE OR REPLACE PACKAGE PECSMFA1 IS
/******************************************************************************
 NOME:          PECSMFA1 CREAZIONE SUPPORTO MAGNETICO 770/SA

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
 2    30/06/2003        Rilascio Patch 770/2003
 3    14/06/2004 CB
 3.1  30/07/2004 AM     Correzioni da test di validazione
 3.2  17/09/2004 AM     Non compatta i periodi INPDAP in caso di cessazione anche se contigui
 3.3  20/01/2005 MS     Modifica per revisione CUD
 4    25/05/2005 GM     Revisione per 770/2005
 4.1  10/06/2005 GM     Modifica attivita suddivisione INPDAP (A11280)
 4.2  14/06/2005 MS     Modifica per att. 11654
 4.3  29/06/2005 MS     Modifica per att. 11764.2
 4.4  30/08/2005 MS     Modifica casella 62 - inpdap
 4.5  15/09/2005 MS     Modifica casella 75 - quadro B
 4.6  27/09/2005 MS     Modifica inpdap per dip. che passano da TFS a TFR ( att. 12837 )
 5.0  25/05/2006 MS     Revisione per 770/2006 ( att. 16250 )
 5.1  13/06/2006 MS     Corretto errore pos_inail e migliorie segnalazioni
 5.2  19/06/2006 MS     Nuova gestione qualifica INAIL ( Att. 16720 )
 5.3  05/07/2006 MS     Modifica su segnalazioni test per Bonus e Ipost ( Att .16484.4 )
 5.4  07/07/2006 MS     Corretto errore su defunti ( Att. 16907 )
 5.5  17/08/2006 MS     Corretto errore su progressivo INPDAP ( Att. 17252 )
 5.6  30/08/2006 MS     Corretto errore su defunti ( Att. 17439 )
 5.7  31/08/2006 MS     Modifiche cursore DMA ( att. 17255 )
 5.8  29/09/2006 MS     Sistemata lettura D_versamento ( att. 17899 )
 6.0  23/03/2007 MS     Revisione per 770/2007
 6.1  12/06/2007 MS     Correzioni da test
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
  
 PROCEDURE INS_SEER
 (  P_prn       in number
  , P_ci        in number 
  , P_riga      in number
  , P_errore    in varchar2
  , P_valore    in varchar2
 );

 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMFA1 IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V6.1 del 12/06/2007';
   END VERSIONE;

 PROCEDURE INS_SEER
 (  P_prn       in number
  , P_ci        in number 
  , P_riga      in number
  , P_errore    in varchar2
  , P_valore    in varchar2
 ) IS
BEGIN
  INSERT INTO a_segnalazioni_errore
  ( no_prenotazione,passo,progressivo,errore,precisazione )
  VALUES ( P_prn, 1, P_riga, 'P00505', SUBSTR('Dip.: '||TO_CHAR(P_ci)||' '||P_errore||P_valore,1,200));
  commit;
END INS_SEER;

 PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
DECLARE
-- parametri di elaborazione
  D_ente            VARCHAR2(4);
  D_ambiente        VARCHAR2(8);
  D_utente          VARCHAR2(8);
  D_dummy_f         varchar2(1);
  D_step            varchar2(50);
  D_descr_errore    VARCHAR2(200);
  D_r1              varchar2(20);
  D_estrazione_i    varchar2(1);
  D_filtro_1        varchar2(15);
  D_filtro_2        varchar2(15);
  D_filtro_3        varchar2(15);
  D_filtro_4        varchar2(15);
  D_tipo            varchar2(1);
  D_da_ci           number;
  D_a_ci            number;
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
  D_decimali        varchar2(1);
  D_dma_ass         varchar2(1);
  D_forza_importi   VARCHAR2(1);
  D_ipost           varchar2(1);
-- variabili per insert
  D_pagina          number := 0;
  D_pagina_prec     number := 0;
  D_pagina_emens    number := 0;
  D_pagina_dma      number := 0;
  D_pagina_inpdap   number := 0;
  D_pagina_inail    number := 0;
  D_riga            number := 0;
  D_riga_e          number := 0;
  D_modulo          number := 0;
  D_modulo_prec     number := 0;
  D_modulo_inail    number := 0;
  D_num_ord         number := 0;
  D_num_ord_emens   number := 0;
  D_num_ord_dma     number := 0;
  D_num_ord_inpdap  number := 0;
  D_num_ord_inail   number := 0;
  D_conta_ere       number := 0;
  D_pagina_ere      number := 0;
  D_modulo_ere      number := 0;
  D_num_ord_ere     number := 0;
  D_conta_emens     number := 0;
  D_conta_dma       number := 0;
  D_num_inpdap      number := 0;
  D_conta_inpdap    number := 0;
  D_conta_inail     number := 0;
  D_num_inail       number := 0;
  D_conta_det       number := 0;
  D_pagina_det      number := 0;
  D_num_ord_det     number := 0;
-- deposito codice fiscale
  D_cod_fis_dic     varchar2(16);
  D_ente_cf         varchar2(16);
  D_cod_fis         varchar2(16);
  D_cf_prec         varchar2(16);
  D_cf_ere          varchar2(16);
-- variabili di deposito per fiscale
  D_evento_eccezionale varchar2(1);
  D_valore_C104     varchar2(20);
  D_tot_sospese     number;
  D_c1              number;
  D_c2              number;
  D_c3              number;
  D_c4              number;
  D_c5              number;
  D_c6              number;
  D_c7              number;
  D_c7bis           number;
  D_c8              number;
  D_c9              number;
  D_c10             number;
  D_c10bis          number;
  D_c11             number;
  D_c12             number;
  D_c13             number;
  D_c14             number;
  D_c15             number;
  D_c16             number;
  D_c17             number;
  D_c18             number;
  D_c19             number;
  D_c20             number;
  D_c21             number;
  D_c22             number;
  D_c23             varchar2(20);
  D_c24             number;
  D_c25             number;
  D_c26             number;
  D_c27             number;
  D_c28             number;
  D_c29             number;
  D_c30             number;
  D_c31             number;
  D_c32             varchar2(20);
  D_c33             number;
  D_c34             varchar2(20);
  D_c35             varchar2(20);
  D_c36             varchar2(20);
  D_c38             number;
  D_c39             number;
  D_c40             number;
  D_c41             number;
  D_c42             number;
  D_c43             number;
  D_c44             number;
  D_c45             number;
  D_c46             number;
  D_c57             number;
  D_c58             number;
  D_c59             number;
  D_c60             number;
  D_c61             varchar2(20);
  d_c69             number;
  d_c70             number;
  d_c71             number;
  d_c72             number;
  d_c73             number;
  D_tot_c61         number;
  D_tot_c62         number;
  D_tot_c63         number;
  D_tot_c64         number;
  D_tot_c65         number;
  D_annotazioni     varchar2(200);
-- variabili per emens
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
  D_bonus_L243      number;
  D_tutti           varchar2(1);
  D_mesi            varchar2(12); 
  D_versamento      varchar2(11);
-- variabili per ipost
  D_inpdap_comparto varchar2(2);
  D_inpdap_sottocomparto varchar2(2);
  D_inpdap_qualifica varchar2(6);
  D_inpdap_cf       varchar2(16);
  D_inpdap_serv     varchar2(2);
  D_inpdap_imp      varchar2(2);
  D_inpdap_cess     date;
  D_inpdap_c_cess   varchar2(2);
  D_inpdap_mag      varchar2(12);
  D_inpdap_prov     varchar2(2);
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
  D_inpdap_iis      number;
  D_inpdap_ipn_tfr  number;
  D_contributi_inpdap number;
  D_contributi_tfs    number;
  D_contributi_tfr    number;
  D_tredicesima    number;
  D_gg_mag_1       number;
  D_gg_mag_2       number;
  D_gg_mag_3       number;
  D_gg_mag_4       number;
  D_data_opz_tfr date;
  D_cf_amm_fisse varchar2(16);
  D_cf_amm_acc   varchar2(16);
  D_contr_sospesi_2002 number;
  D_contr_sospesi_2003 number;
  D_contr_sospesi_2004 number;
  D_contr_sospesi_2005 number;
  D_contr_sospesi_2006 number;
  D_inpdap_perc_l300   number;
  D_pos_ass         varchar2(12);
  D_cod_cat         varchar2(4);
  D_qual_inail      varchar2(2);
  D_inail_dal       date;
  D_inail_al        date;
  NO_QUALIFICA      EXCEPTION;
  USCITA            EXCEPTION;
  NO_CODICEFISCALE  EXCEPTION;
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
      D_tipo := 'T';
  END;
  BEGIN
    select substr(valore,1,8)
      into D_da_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_da_ci := 0;
  END;
  BEGIN
    select substr(valore,1,8)
      into D_a_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_a_ci := 99999999;
  END;
  IF D_tipo = 'T' and D_da_ci != 0 and D_a_ci != 99999999 THEN
     RAISE USCITA;
  END IF;
  IF D_tipo = 'S' and D_da_ci = 0 and D_a_ci = 99999999 THEN
     RAISE USCITA;
  END IF;
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
      into D_decimali
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DECIMALI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_decimali := ' ';
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
    select valore
      into D_forza_importi
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FORZA_IMPORTI'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_forza_importi := 'N';
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
    IF D_r1 = 'GESTIONE' THEN
       D_cod_fis := null;
    ELSE
       select ltrim(nvl(ente.codice_fiscale,ente.partita_iva))
         into D_cod_fis
         from ente ente
       ;
    END IF;
  END;

  BEGIN
    D_modulo        := 0;
    D_pagina        := 0;
    D_riga          := 0;
    LOCK TABLE TAB_REPORT_FINE_ANNO IN EXCLUSIVE MODE NOWAIT;
    cursore_fiscale.PULISCI_TAB_REPORT_FINE_ANNO;
    cursore_fiscale.INSERT_TAB_REPORT_FINE_ANNO (D_anno,D_da_ci,D_a_ci);
    commit;
    LOCK TABLE TAB_REPORT_FINE_ANNO IN EXCLUSIVE MODE NOWAIT;
    FOR CUR_RPFA in cursore_fiscale.CUR_RPFA2 ( D_anno , D_filtro_1, D_filtro_2, D_filtro_3, D_filtro_4
                                              , D_da_ci, D_a_ci, D_cod_fis, D_estrazione_i, '770'
                                              , D_ente, D_ambiente, D_utente)
   LOOP
-- dbms_output.put_line ( ' cursore RPFA ' );
    D_num_ord := 1;
    D_modulo  := D_modulo + 1;
    D_pagina  := D_pagina + 1;
    D_riga    := 1;
    D_evento_eccezionale := null;
    D_valore_c104        := null;
    D_tot_sospese        :=0;
    d_c1 := 0;
    d_c2 := 0;
    d_c3 := 0;
    d_c4 := 0;
    d_c5 := 0;
    d_c6 := 0;
    d_c7 := 0;
    d_c7bis := 0;
    d_c8 := 0;
    d_c9 := 0;
    d_c10:= 0;
    d_c10bis:= 0;
    d_c11:= 0;
    d_c12:= 0;
    d_c13:= 0;
    d_c14:= 0;
    d_c15:= 0;
    d_c16:= 0;
    d_c17:= 0;
    d_c18:= 0;
    d_c19:= 0;
    d_c20:= 0;
    D_c21:= 0;
    d_c22:= 0;
    d_c23:= null;
    d_c24:= 0;
    d_c25:= 0;
    d_c26:= 0;
    d_c27:= 0;
    d_c28:= 0;
    d_c29:= 0;
    d_c30:= 0;
    d_c31:= 0;
    d_c32:= null;
    d_c33:= 0;
    d_c34:= null;
    d_c35:= null;
    d_c36:= null;
    d_c38:= 0;
    d_c39:= 0;
    d_c40:= 0;
    d_c41:= 0;
    d_c42:= 0;
    d_c43:= 0;
    d_c44:= 0;
    d_c45:= 0;
    d_c46:= 0;
    d_c57:= 0;
    d_c58:= 0;
    d_c59:= 0;
    d_c60:= 0;
    d_c61:= null;
    d_c69:= 0;
    d_c70:= 0;
    d_c71:= 0;
    d_c72:= 0;
    d_c73:= 0;
    d_contr_sospesi_2002 :=0;
    d_contr_sospesi_2003 :=0;
    d_contr_sospesi_2004 :=0;
    d_contr_sospesi_2005 :=0;
    d_contr_sospesi_2006 :=0;
    d_tot_c61 := 0;
    d_tot_c62 := 0;
    d_tot_c63 := 0;
    d_tot_c64 := 0;
    d_tot_c65 := 0;
    D_step := 'INIZIO LOOP';
    BEGIN
              IF rpad(ltrim(rtrim(CUR_RPFA.cod_fis)),16,'X') = lpad('X',16,'X') then
                raise NO_CODICEFISCALE;
              end if;
              --
              --  Estrazione Codice Fiscale Defunto
              --
              BEGIN
                select anag.codice_fiscale
                  into D_cf_ere
                  from anagrafici anag
                 where anag.ni = (select ni
                                    from rapporti_individuali
                                    where ci = CUR_RPFA.ci_erede)
                   and anag.dal = (select max(dal)
                                     from anagrafici
                                    where ni = anag.ni)
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  D_cf_ere  := ' ';
              END;
              D_cf_prec       := ' ';
              D_ente_cf       := CUR_RPFA.ente_cf;
              D_step := 'Prima Insert';
              --
              --  Inserimento Primo Record Dipendente
              --
-- dbms_output.put_line('riga 0 per modulo 1 principale : '||D_modulo);
-- dbms_output.put_line('ci e ci_erede : '||CUR_RPFA.ci||' '||nvl(CUR_RPFA.ci_erede,99999));
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              values ( prenotazione
                     , 2
                     , D_pagina
                     , 0
                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                       lpad(to_char(D_modulo),8,'0')||
                       lpad(to_char(D_num_ord),2,'0')||
                       rpad(nvl(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),' '),16,' ')||
                       lpad(' ',18,' ')||
                       nvl(D_dummy_f,' ')||
                       lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                       lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                       rpad(nvl(CUR_RPFA.c1,' '),15,' ')||
                       lpad(to_char(CUR_RPFA.ci),8,'0')
                     )
              ;
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              values ( prenotazione
                     , 2
                     , D_pagina
                     , 300
                     , '}'
                     )
              ;
              commit;
              BEGIN
              <<LEGGI_DEFS>>
              D_step := 'Select da Denuncia Fiscale';

              select decode(D_decimali, 'X',trunc(nvl(c1,0),2)*100,trunc(nvl(c1,0),0))          -- d_c1
                   , decode(D_decimali, 'X',trunc(nvl(c2,0),2)*100,trunc(nvl(c2,0),0))          -- d_c2
                   , nvl(c3,0)                                                                  -- d_c3
                   , nvl(c4,0)                                                                  -- d_c4
                   , decode(D_decimali, 'X',trunc(nvl(c5,0),2)*100,trunc(nvl(c5,0),0))          -- d_c5
                   , decode(D_decimali, 'X',trunc(nvl(c6,0),2)*100,trunc(nvl(c6,0),0))          -- d_c6
                   , decode(D_decimali, 'X',trunc(nvl(c7,0),2)*100,trunc(nvl(c7,0),0))          -- d_c7
                   , decode(D_decimali, 'X',trunc(nvl(c32,0),2)*100,trunc(nvl(c32,0),0))        -- d_c7bis                   
                   , decode(D_decimali, 'X',trunc(nvl(c8,0),2)*100,trunc(nvl(c8,0),0))          -- d_c8
                   , decode(D_decimali, 'X',trunc(nvl(c9,0),2)*100,trunc(nvl(c9,0),0))          -- d_c9
                   , decode(D_decimali, 'X',trunc(nvl(c10,0),2)*100,trunc(nvl(c10,0),0))        -- d_c10
                   , decode(D_decimali, 'X',trunc(nvl(c37,0),2)*100,trunc(nvl(c37,0),0))        -- d_c10bis
                   , decode(D_decimali, 'X',trunc(nvl(c11,0),2)*100,trunc(nvl(c11,0),0))        -- d_c11
                   , decode(D_decimali, 'X',trunc(nvl(c12,0),2)*100,trunc(nvl(c12,0),0))        -- d_c12
                   , decode(D_decimali, 'X',trunc(nvl(c13,0),2)*100,trunc(nvl(c13,0),0))        -- d_c13
                   , decode(D_decimali, 'X',trunc(nvl(c14,0),2)*100,trunc(nvl(c14,0),0))        -- d_c14
                   , decode(D_decimali, 'X',trunc(nvl(c15,0),2)*100,trunc(nvl(c15,0),0))        -- d_c15
                   , decode(D_decimali, 'X',trunc(nvl(c16,0),2)*100,trunc(nvl(c16,0),0))        -- d_c16
                   , decode(D_decimali, 'X',trunc(nvl(c17,0),2)*100,trunc(nvl(c17,0),0))        -- d_c17
                   , decode(D_decimali, 'X',trunc(nvl(c18,0),2)*100,trunc(nvl(c18,0),0))        -- d_c18
                   , decode(D_decimali, 'X',trunc(nvl(c19,0),2)*100,trunc(nvl(c19,0),0))        -- d_c19
                   , decode(D_decimali, 'X',trunc(nvl(c20,0),2)*100,trunc(nvl(c20,0),0))        -- d_c20
                   , decode(D_decimali, 'X',trunc(nvl(c21,0),2)*100,trunc(nvl(c21,0),0))        -- d_c21
                   , decode(D_decimali, 'X',trunc(nvl(c22,0),2)*100,trunc(nvl(c22,0),0))        -- d_c22
                   , nvl(to_char(c23),' ')                                                      -- d_c23
                   , decode(D_decimali, 'X',trunc(nvl(c24,0),2)*100,trunc(nvl(c24,0),0))        -- d_c24
                   , decode(D_decimali, 'X',trunc(nvl(c25,0),2)*100,trunc(nvl(c25,0),0))        -- d_c25
                   , decode(D_decimali, 'X',trunc(nvl(c26,0),2)*100,trunc(nvl(c26,0),0))        -- d_c26
                   , decode(D_decimali, 'X',trunc(nvl(c27,0),2)*100,trunc(nvl(c27,0),0))        -- d_c27
                   , decode(D_decimali, 'X',trunc(nvl(c28,0),2)*100,trunc(nvl(c28,0),0))        -- d_c28
                   , decode(D_decimali, 'X',trunc(nvl(c29,0),2)*100,trunc(nvl(c29,0),0))        -- d_c29
                   , decode(D_decimali, 'X',trunc(nvl(c30,0),2)*100,trunc(nvl(c30,0),0))        -- d_c30
                   , decode(D_decimali, 'X',trunc(nvl(c31,0),2)*100,trunc(nvl(c31,0),0))        -- d_c31
                   , nvl(c101,' ')                                                              -- d_c32
                   , decode(D_decimali, 'X',trunc(nvl(c33,0),2)*100,trunc(nvl(c33,0),0))        -- d_c33
                   , decode( decode(D_decimali, 'X',trunc(nvl(c34,0),2)*100,trunc(nvl(c34,0),0))
                            ,0,' ','1')                                                         -- d_c34
                   , decode( decode(D_decimali, 'X',trunc(nvl(c35,0),2)*100,trunc(nvl(c35,0),0))
                            ,0,' ','1')                                                         -- d_c35
                   , decode( decode(D_decimali, 'X',trunc(nvl(c36,0),2)*100,trunc(nvl(c36,0),0))
                            ,0,' ','1')                                                         -- d_c36
                   , trunc(nvl(c38,0))                                                          -- d_c38
                   , decode(D_decimali, 'X',trunc(nvl(c39,0),2)*100,trunc(nvl(c39,0),0))        -- d_c39
                   , decode(D_decimali, 'X',trunc(nvl(c40,0),2)*100,trunc(nvl(c40,0),0))        -- d_c40
                   , decode(D_decimali, 'X',trunc(nvl(c41,0),2)*100,trunc(nvl(c41,0),0))        -- d_c41
                   , trunc(nvl(c42,0))                                                          -- d_c42
                   , decode(D_decimali, 'X',trunc(nvl(c43,0),2)*100,trunc(nvl(c43,0),0))        -- d_c43
                   , decode(D_decimali, 'X',trunc(nvl(c44,0),2)*100,trunc(nvl(c44,0),0))        -- d_c44
                   , decode(D_decimali, 'X',trunc(nvl(c45,0),2)*100,trunc(nvl(c45,0),0))        -- d_c45
                   , decode(D_decimali, 'X',trunc(nvl(c46,0),2)*100,trunc(nvl(c46,0),0))        -- d_c46
                   , decode(D_decimali, 'X',trunc(nvl(c57,0),2)*100,trunc(nvl(c57,0),0))        -- d_c57
                   , decode(D_decimali, 'X',trunc(nvl(c58,0),2)*100,trunc(nvl(c58,0),0))        -- d_c58
                   , decode(D_decimali, 'X',trunc(nvl(c59,0),2)*100,trunc(nvl(c59,0),0))        -- d_c59
                   , decode(D_decimali, 'X',trunc(nvl(c60,0),2)*100,trunc(nvl(c60,0),0))        -- d_c60
                   , nvl(c145,' ')                                                              -- d_c61
                   , decode(D_decimali, 'X',trunc(nvl(c69,0),2)*100,trunc(nvl(c69,0),0))        -- d_c69
                   , decode(D_decimali, 'X',trunc(nvl(c70,0),2)*100,trunc(nvl(c70,0),0))        -- d_c70
                   , decode(D_decimali, 'X',trunc(nvl(c71,0),2)*100,trunc(nvl(c71,0),0))        -- d_c71
                   , decode(D_decimali, 'X',trunc(nvl(c72,0),2)*100,trunc(nvl(c72,0),0))        -- d_c72
                   , nvl(c73,0)                                                                 -- d_c73
                   , decode(length(ltrim(rtrim(c104))), 1, C104, 0, ' ', 'X' )                  -- D_evento_eccezionale
                   , C104                                                                       -- D_valore_C104
                into d_c1, d_c2, d_c3, d_c4
                   , d_c5, d_c6, d_c7, d_c7bis
                   , d_c8, d_c9, d_c10, d_c10bis
                   , d_c11, d_c12, d_c13
                   , d_c14, d_c15, d_c16
                   , d_c17, d_c18, d_c19
                   , d_c20, d_c21, d_c22
                   , d_c23, d_c24, d_c25
                   , d_c26, d_c27, d_c28, d_c29
                   , d_c30, d_c31, d_c32, d_c33
                   , d_c34, d_c35, d_c36
                   , d_c38, d_c39, d_c40, d_c41, d_c42
                   , d_c43, d_c44, d_c45, d_c46
                   , d_c57, d_c58, d_c59, d_c60, d_c61
                   , d_c69, d_c70, d_c71, d_c72, d_c73
                   , D_evento_eccezionale, D_valore_c104
                from denuncia_fiscale
               where rilevanza = 'T'
                 and anno      = d_anno
                 and ci = CUR_RPFA.ci
                 and nvl(c1,0) + nvl(c2,0) + nvl(c3,0) + nvl(c4,0)
                   + nvl(c5,0) + nvl(c6,0) + nvl(c7,0) + nvl(c32,0) 
                   + nvl(c8,0) + nvl(c9,0) + nvl(c10,0) + nvl(c37,0) 
                   + nvl(c11,0) + nvl(c12,0) + nvl(c13,0)
                   + nvl(c14,0) + nvl(c15,0) + nvl(c16,0)
                   + nvl(c17,0) + nvl(c18,0) + nvl(c19,0)
                   + nvl(c20,0) + nvl(c21,0) + nvl(c22,0)
                   + nvl(c23,0) + nvl(c24,0) + nvl(c25,0)
                   + nvl(c26,0) + nvl(c27,0) + nvl(c28,0) + nvl(c29,0)
                   + nvl(c30,0) + nvl(c31,0) + nvl(c33,0)
                   + nvl(c39,0) + nvl(c40,0) + nvl(c41,0)
                   + nvl(c43,0) + nvl(c44,0) + nvl(c45,0) + nvl(c46,0)
                   + nvl(c57,0) + nvl(c58,0) + nvl(c59,0) + nvl(c60,0)
                   + nvl(c69,0) + nvl(c70,0) + nvl(c71,0) + nvl(c72,0) + nvl(c73,0)
                   != 0
                  ;
-- controllo su casella 3 giorni da lavoro dipendente
                IF to_number(nvl(d_c3,'0')) > 365 or to_number(nvl(d_c3,'0')) < 0 THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 3: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, d_c3 );
                END IF;
-- controllo su casella 4 giorni pensione
                IF to_number(nvl(d_c4,'0')) > 365 or to_number(nvl(d_c4,'0')) < 0 THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 4: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, d_c4 );
                END IF;
-- controllo su caselle 3 e 4 giorni deduzione 
                IF to_number(nvl(d_c3,'0')) + to_number(nvl(d_c4,'0')) > 365  THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' somma casella 3 e 4 errata: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, nvl(d_c3,0)+nvl(d_c4,0) );
                END IF;
-- controllo su casella 23 anno di percezione reddito estero
                IF length(nvl(to_number(rtrim(d_c23)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(d_c23)),D_anno-1) > D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' Verificare valore casella 23: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, d_c23 );
                END IF;
-- controllo su casella 34 presenza assicurazioni
                IF nvl(rtrim(d_c34),'0') not in ('0','1') THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 34 ( 0 o 1 ): ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, d_c34 );
               END IF;
-- controllo su casella 35 maggiore ritenuta
                IF nvl(rtrim(d_c35),'0') not in ('0','1') THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 35 ( 0 o 1 ): ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, d_c35 );
               END IF;
-- controllo su casella 36 non applicazione deduzione
                IF nvl(rtrim(d_c36),'0') not in ('0','1') THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 36 ( 0 o 1 ): ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, d_c36 );
                END IF;
-- controllo su casella 61 anno apertura successione
                IF length(nvl(to_number(rtrim(d_c61)),D_anno-1)) != 4 
                or nvl(to_number(rtrim(d_c61)),D_anno-1) > D_anno THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' Verificare valore casella 61: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, d_c61 );
                END IF;
-- controllo su casella 73 quota spettante per eredi
                IF nvl(D_c73,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' Casella 73 maggiore di 100 ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null );
                  COMMIT;
                END IF;

-- totalizzatore per controllo sulla casella 10 eventi eccezionali
               D_tot_sospese := nvl(d_c8,0) + nvl(d_c9,0) + nvl(d_c10bis,0) + nvl(d_c13,0) +  nvl(d_c60,0);
               D_step := 'Insert di Denuncia Fiscale';
               D_riga := 10;
               insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                values
                ( prenotazione
                , 2
                , D_pagina
                , D_riga
                , 'DB'||lpad(to_char(D_num_ord),3,'0')||'001'
                      ||lpad(nvl(to_char(d_c1),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'002'
                      ||lpad(nvl(to_char(d_c2),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'003'
                      ||lpad(nvl(lpad(to_char(d_c3),3,'0'),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'004'
                      ||lpad(nvl(lpad(to_char(d_c4),3,'0'),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'005'
                      ||lpad(nvl(to_char(d_c5),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'006'
                      ||lpad(nvl(to_char(d_c6),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'007'
                      ||lpad(nvl(to_char(d_c7),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'A07'
                      ||lpad(nvl(to_char(d_c7bis),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'008'
                      ||lpad(nvl(to_char(d_c8),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'009'
                      ||lpad(nvl(to_char(d_c9),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'010'
                      ||lpad(nvl(to_char(d_c10),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'A10'
                      ||lpad(nvl(to_char(d_c10bis),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'011'
                      ||lpad(nvl(to_char(d_c11),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'012'
                      ||lpad(nvl(to_char(d_c12),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'013'
                      ||lpad(nvl(to_char(d_c13),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'014'
                      ||lpad(nvl(to_char(d_c14),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'015'
                      ||lpad(nvl(to_char(d_c15),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'016'
                      ||lpad(nvl(to_char(d_c16),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'017'
                      ||lpad(nvl(to_char(d_c17),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'018'
                      ||lpad(nvl(to_char(d_c18),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'019'
                      ||lpad(nvl(to_char(d_c19),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'020'
                      ||lpad(nvl(to_char(d_c20),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'021'
                      ||lpad(nvl(to_char(d_c21),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'022'
                      ||lpad(nvl(to_char(d_c22),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'023'
                      ||lpad(nvl(rtrim(d_c23),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'024'
                      ||lpad(nvl(to_char(d_c24),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'025'
                      ||lpad(nvl(to_char(d_c25),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'026'
                      ||lpad(nvl(to_char(d_c26),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'027'
                      ||lpad(nvl(to_char(d_c27),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'028'
                      ||lpad(nvl(to_char(d_c28),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'029'
                      ||lpad(nvl(to_char(d_c29),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'030'
                      ||lpad(nvl(to_char(d_c30),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'031'
                      ||lpad(nvl(to_char(d_c31),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'032'
                      ||rpad(nvl(d_c32,' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'033'
                      ||lpad(nvl(to_char(d_c33),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'034'
                      ||lpad(nvl(d_c34,' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'035'
                      ||lpad(nvl(d_c35,' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'036'
                      ||lpad(nvl(d_c36,' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'038'
                      ||lpad(nvl(to_char(d_c38),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'039'
                      ||lpad(nvl(to_char(d_c39),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'040'
                      ||lpad(nvl(to_char(d_c40),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'041'
                      ||lpad(nvl(to_char(d_c41),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'042'
                      ||lpad(nvl(to_char(d_c42),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'043'
                      ||lpad(nvl(to_char(d_c43),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'044'
                      ||lpad(nvl(to_char(d_c44),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'045'
                      ||lpad(nvl(to_char(d_c45),' '),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'046'
                      ||lpad(nvl(to_char(d_c46),' '),16,' ')
              )
            ;
         exception 
              when no_data_found then null;
         END LEGGI_DEFS;

            D_conta_det   := 0;
            D_pagina_det  := D_pagina;
            D_num_ord_det := D_num_ord;
            D_step := 'Cursore Dettagli';
      FOR CUR_DET IN
      (select nvl(c102,' ')                        dc47
            , nvl(c48,0)                           dc48
            , nvl(c49,0)                           dc49
            , decode(D_decimali, 'X',trunc(nvl(c50,0),2)*100,trunc(nvl(c50,0),0))       dc50
            , decode(D_decimali, 'X',trunc(nvl(c51,0),2)*100,trunc(nvl(c51,0),0))       dc51
            , decode(D_decimali, 'X',trunc(nvl(c52,0),2)*100,trunc(nvl(c52,0),0))       dc52
            , decode(D_decimali, 'X',trunc(nvl(c53,0),2)*100,trunc(nvl(c53,0),0))       dc53
            , decode(D_decimali, 'X',trunc(nvl(c54,0),2)*100,trunc(nvl(c54,0),0))       dc54
            , decode(D_decimali, 'X',trunc(nvl(c55,0),2)*100,trunc(nvl(c55,0),0))       dc55
            , decode(D_decimali, 'X',trunc(nvl(c56,0),2)*100,trunc(nvl(c56,0),0))       dc56
            , decode(D_decimali, 'X',trunc(nvl(c57,0),2)*100,trunc(nvl(c57,0),0))       dc62
            , decode(D_decimali, 'X',trunc(nvl(c58,0),2)*100,trunc(nvl(c58,0),0))       dc63
            , decode(D_decimali, 'X',trunc(nvl(c59,0),2)*100,trunc(nvl(c59,0),0))       dc64
            , decode(D_decimali, 'X',trunc(nvl(c60,0),2)*100,trunc(nvl(c60,0),0))       dc65
            , decode(D_decimali, 'X',trunc(nvl(c61,0),2)*100,trunc(nvl(c61,0),0))       dc66
            , nvl(to_char(c62),' ')                                                     dc67
            , nvl(c105,' ')                                                             dc68
            , decode(D_decimali, 'X',trunc(nvl(c57,0),2)*100,trunc(nvl(c57,0),0))       c62
            , decode(D_decimali, 'X',trunc(nvl(c58,0),2)*100,trunc(nvl(c58,0),0))       c63
            , decode(D_decimali, 'X',trunc(nvl(c59,0),2)*100,trunc(nvl(c59,0),0))       c64
            , decode(D_decimali, 'X',trunc(nvl(c60,0),2)*100,trunc(nvl(c60,0),0))       c65
         from denuncia_fiscale
        where rilevanza = 'D'
          and anno      = d_anno
          and ci = CUR_RPFA.ci
          and nvl(c50,0) + nvl(c51,0) + nvl(c52,0) + nvl(c53,0) + nvl(c54,0) + nvl(c55,0) + nvl(c56,0)
            + nvl(c57,0) + nvl(c58,0) + nvl(c59,0) + nvl(c60,0) + nvl(c61,0) != 0
          ) 
         LOOP
            D_conta_det  := D_conta_det  + 1;

            D_tot_sospese := nvl(D_tot_sospese,0) + nvl(CUR_DET.dc54,0) + nvl(CUR_DET.dc56,0);
            D_tot_c62 := D_tot_c62 + CUR_DET.c62;
            D_tot_c63 := D_tot_c63 + CUR_DET.c63;
            D_tot_c64 := D_tot_c64 + CUR_DET.c64;
            D_tot_c65 := D_tot_c65 + CUR_DET.c65;

-- controllo su casella 48 causa
              IF nvl(CUR_DET.dc48,0) not in ( 0,1,2,3,4,5,6,7,8 ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' Casella 48 Errata: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DET.dc48 );
              END IF;
-- controllo su casella 49 causa
              IF nvl(CUR_DET.dc49,0) not in (0,1,2 ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' Casella 49 Errata: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DET.dc49 );
              END IF;
-- controllo su casella 67 periodo di imposta
                IF    nvl(rtrim(CUR_DET.dc67),0) != 0 
                and ( nvl(to_number(rtrim(CUR_DET.dc67)),D_anno-1) < 1900
                   or nvl(to_number(rtrim(CUR_DET.dc67)),D_anno-1) >= D_anno 
                    ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' Verificare valore casella 67: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DET.dc67 );
                END IF;
                IF D_conta_det != 1 THEN
                  D_pagina_det  := D_pagina_det + 1;
                END IF;
                IF D_conta_det != 1 THEN
                   D_num_ord_det:= D_num_ord_det + 1;
-- dbms_output.put_line('riga 0 per modulo 2 dettagli : '||D_pagina_det);
-- dbms_output.put_line('ci e ci_erede : '||CUR_RPFA.ci||' '||CUR_RPFA.ci_erede);
               insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                     , 2
                     , D_pagina_det
                     , 0
                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                       lpad(to_char(D_modulo),8,'0')||
                       lpad(to_char(D_num_ord_det),2,'0')||
                       rpad(nvl(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),' '),16,' ')||
                       lpad(' ',18,' ')||
                       nvl(D_dummy_f,' ')||
                       lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                       lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                       rpad(nvl(CUR_RPFA.c1,' '),15,' ')
                  from dual
                 where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_det
                          and riga            = 0)
                ;
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                      , 2
                      , D_pagina_det
                      , 300
                      , '}'
                  from dual
                    where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_det
                          and riga            = 300)
                ;
              D_riga := 10;
              commit;
              END IF;

              D_step := '1 Insert Cursore Dettagli';
              D_riga:= 11;
             insert into a_appoggio_stampe
             ( no_prenotazione, no_passo, pagina, riga, testo )
              values
                 ( prenotazione
                 , 2
                 , D_pagina_det
                 , D_riga
                 , 'DB'||lpad(to_char(D_num_ord_det),3,'0')||'047'
                       ||rpad(nvl((CUR_DET.dc47),' '),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'048'
                       ||lpad(to_char(CUR_DET.dc48),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'049'
                       ||lpad(to_char(CUR_DET.dc49),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'050'
                       ||lpad(to_char(CUR_DET.dc50),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'051'
                       ||lpad(to_char(CUR_DET.dc51),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'052'
                       ||lpad(to_char(CUR_DET.dc52),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'053'
                       ||lpad(to_char(CUR_DET.dc53),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'054'
                       ||lpad(to_char(CUR_DET.dc54),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'055'
                       ||lpad(to_char(CUR_DET.dc55),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'056'
                       ||lpad(to_char(CUR_DET.dc56),16,' ')
                 )
               ;
              D_step := '2 Insert Cursore Dettagli';
              D_riga := 13;
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              values
                 ( prenotazione
                 , 2
                 , D_pagina_det
                 , D_riga
                 , 'DB'||lpad(to_char(D_num_ord_det),3,'0')||'062'
                       ||lpad(to_char(CUR_DET.dc62),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'063'
                       ||lpad(to_char(CUR_DET.dc63),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'064'
                       ||lpad(to_char(CUR_DET.dc64),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'065'
                       ||lpad(to_char(CUR_DET.dc65),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'066'
                       ||lpad(nvl(rtrim(CUR_DET.dc66),' '),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'067'
                       ||lpad(nvl(rtrim(decode(CUR_DET.dc67,'0','',CUR_DET.dc67)),' '),16,' ')||
                   'DB'||lpad(to_char(D_num_ord_det),3,'0')||'068'
                       ||rpad(CUR_DET.dc68,16,' ')
                 )
            ;
         END LOOP; -- cur_det
-- controllo su casella 10 evento eccezionale
-- non è possibile metterla nel smfa2 dove verrà archiviata perchè 
-- mancano le informazioni per il controllo quindi verrà archiviata comunque
               IF ( nvl(ltrim(D_evento_eccezionale),5) not in ('1','3','4')  and D_tot_sospese != 0  )
               or ( nvl(ltrim(D_evento_eccezionale),5) in ('1','3','4') and D_tot_sospese = 0 )
               THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Evento Eccez. ( 1/2/3 ): ';
                  PECSMFA1.INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, D_valore_c104 );
               END IF; -- casella D_evento_eccezionale

-- controllo su casella 57 totale e dettaglio casella 61
               IF (  D_decimali !=  'X' and abs( abs(nvl(D_c57,0)) - abs(nvl(D_tot_c62,0)) ) > 1
                 or  D_decimali  =  'X' and round(nvl(D_c57,0),1) != round(nvl(D_tot_c62,0),1)
                  ) THEN
                  D_riga_e := D_riga_e + 1;
                  select ' Casella 57 con Dettaglio Errato '
                        ||decode(D_decimali
                                ,'X', '( Tot = '||round(nvl(D_c57,0),1)||' Dett = '||round(nvl(D_tot_c62,0),1)||' ) '
                                    , '( Tot = '||nvl(D_c57,0)||' Dett = '||nvl(D_tot_c62,0)||' ) '
                                )
                   into D_descr_errore
                   from dual ;
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null );
               END IF;
-- controllo su casella 58 totale e dettaglio casella 63
               IF ( D_decimali !=  'X' and abs ( abs(nvl(D_c58,0)) - abs(nvl(D_tot_c63,0)) ) > 1
                or  D_decimali =  'X' and round(nvl(D_c58,0),1) != round(nvl(D_tot_c63,0),1)
                  ) THEN
                  D_riga_e := D_riga_e + 1;
                  select ' Casella 58 con Dettaglio Errato '
                        ||decode(D_decimali
                                ,'X', '( Tot = '||round(nvl(D_c58,0),1)||' Dett = '||round(nvl(D_tot_c63,0),1)||' ) '
                                    , '( Tot = '||nvl(D_c58,0)||' Dett = '||nvl(D_tot_c63,0)||' ) '
                                )
                   into D_descr_errore
                   from dual ;
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null );
               END IF;
-- controllo su casella 59 totale e dettaglio casella 64
               IF ( D_decimali !=  'X' and abs ( abs(nvl(D_c59,0)) - abs(nvl(D_tot_c64,0)) ) > 1
                or  D_decimali =  'X' and round(nvl(D_c59,0),1) != round(nvl(D_tot_c64,0),1)
                  ) THEN
                  D_riga_e := D_riga_e + 1;
                  select ' Casella 59 con Dettaglio Errato '
                        ||decode(D_decimali
                                ,'X', '( Tot = '||round(nvl(D_c59,0),1)||' Dett = '||round(nvl(D_tot_c64,0),1)||' ) '
                                    , '( Tot = '||nvl(D_c59,0)||' Dett = '||nvl(D_tot_c64,0)||' ) '
                                )
                   into D_descr_errore
                   from dual ;

                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null );
-- controllo su casella 60 totale e dettaglio casella 65
               END IF;
               IF ( D_decimali !=  'X' and abs( abs(nvl(D_c60,0)) - abs(nvl(D_tot_c65,0))) > 1
                or  D_decimali =  'X' and round(nvl(D_c60,0),1) != round(nvl(D_tot_c65,0),1)
                  ) THEN
                  D_riga_e := D_riga_e + 1;
                  select ' Casella 60 con Dettaglio Errato '
                        ||decode(D_decimali
                                ,'X', '( Tot = '||round(nvl(D_c60,0),1)||' Dett = '||round(nvl(D_tot_c65,0),1)||' ) '
                                    , '( Tot = '||nvl(D_c60,0)||' Dett = '||nvl(D_tot_c65,0)||' ) '
                                )
                   into D_descr_errore
                   from dual ;
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null );
               END IF;
               D_step := '2 Insert Denuncia Fiscale';
               D_riga := 12;
               insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                values
                ( prenotazione
                , 2
                , D_pagina
                , D_riga
                , 'DB'||lpad(to_char(D_num_ord),3,'0')||'057'
                      ||lpad(to_char(d_c57),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'058'
                      ||lpad(to_char(d_c58),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'059'
                      ||lpad(to_char(d_c59),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'060'
                      ||lpad(to_char(d_c60),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'061'
                      ||lpad(d_c61,16,' ')
               )
              ;
               D_step := '3 Insert Denuncia Fiscale';
               D_riga :=  14;
               insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                values
                ( prenotazione
                , 2
                , D_pagina
                , D_riga
                , 'DB'||lpad(to_char(D_num_ord),3,'0')||'069'
                      ||lpad(to_char(d_c69),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'070'
                      ||lpad(to_char(d_c70),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'071'
                      ||lpad(to_char(d_c71),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'072'
                      ||lpad(to_char(d_c72),16,' ')||
                  'DB'||lpad(to_char(D_num_ord),3,'0')||'073'
                      ||lpad(translate(to_char(nvl(d_c73,0)),'.',','),16,' ')||
                  '{'
                 );

          IF nvl(D_cf_ere,' ') != ' ' and nvl(D_C73,0) != 0 THEN
          D_step := 'Insert C.F. Defunto';
          D_riga := 25;
             insert into a_appoggio_stampe
            ( no_prenotazione, no_passo, pagina, riga, testo )
             values
                   ( prenotazione
                   , 2
                   , D_pagina
                   , D_riga
                   , 'DB'||lpad(to_char(D_num_ord),3,'0')||'163'
                         ||lpad(nvl(D_cf_ere,' '),16,' ')
                   )
              ;
          END IF;
          D_conta_ere   := 0;
          D_pagina_ere  := D_pagina;
          D_modulo_ere  := D_modulo;
          D_num_ord_ere := D_num_ord;
          D_step := 'Cursore Eredi';
          FOR CUR_EREDE IN
             (select nvl(anag.codice_fiscale,' ') cod_fiscale
                   , nvl(radi.quota_erede,0)    quota_erede
                from anagrafici anag
                   , rapporti_individuali rain
                   , rapporti_diversi     radi
               where radi.anno = D_anno
                 and radi.ci_erede = CUR_RPFA.ci
                 and radi.rilevanza = 'E'
                 and radi.ci  = rain.ci
                 and rain.ni = anag.ni
                 and anag.al is null
                 and exists (select 'x'
                             from denuncia_fiscale
                            where rilevanza = 'T'
                              and anno      = d_anno
                              and ci        = rain.ci
                              and nvl(c69,0) + nvl(c70,0) + nvl(c71,0)  + nvl(c72,0) != 0
                           )
             ) LOOP

-- controllo su casella 159 quota spettante per indennita
                IF nvl(CUR_EREDE.quota_erede,0) > 100 THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' : Casella 159 maggiore di 100 ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null );
                  COMMIT;
                END IF;

             D_riga := 25;
             D_conta_ere  := D_conta_ere  + 1;
              IF D_conta_ere != 1 THEN
                D_pagina_ere  := D_pagina_ere + 1;
              END IF;
              IF D_conta_ere != 1 THEN
                D_num_ord_ere  := D_num_ord_ere  + 1;
-- dbms_output.put_line('riga 0 per modulo 3 eredi : '||D_modulo);
-- dbms_output.put_line('ci e ci_erede : '||CUR_RPFA.ci||' '||CUR_RPFA.ci_erede);
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                     , 2
                     , D_pagina_ere
                     , 0
                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                       lpad(to_char(D_modulo),8,'0')||
                       lpad(to_char(D_num_ord_ere),2,'0')||
                       rpad(nvl(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),' '),16,' ')||
                       lpad(' ',18,' ')||
                       nvl(D_dummy_f,' ')||
                       lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                       lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                       rpad(nvl(CUR_RPFA.c1,' '),15,' ')
                  from dual
                 where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_ere
                          and riga            = 0)
                ;
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                      , 2
                      , D_pagina_ere
                      , 300
                      , '}'
                  from dual
                    where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_ere
                          and riga            = 300)
                ;
              commit;
              D_riga := 25;
              END IF; -- d_conta_ere
              D_step := 'Insert Cursore Eredi';
              D_riga := D_riga + 1;
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              values
                 ( prenotazione
                 , 2
                 , D_pagina_ere
                 , D_riga
                 , 'DB'||lpad(to_char(D_num_ord_ere),3,'0')||'164'
                       ||rpad(CUR_EREDE.cod_fiscale,16,' ')||
                   'DB'||lpad(to_char(D_num_ord_ere),3,'0')||'165'
                       ||lpad(translate(to_char(CUR_EREDE.quota_erede),'.',','),16,' ')||
                '{'
              )
              ;
            END LOOP; -- cur_erede

           D_step := 'Insert Annotazioni';
           D_riga         := 30;
           D_annotazioni  := null;

           IF D_num_ord = 1 then
           BEGIN
             FOR CUR_NOTE in
               (select distinct lpad(substr(codice,1,2),2,' ') codice
                  from note_cud
                 where anno = D_anno
                   and ci = CUR_RPFA.ci
                   and ( substr(codice,1,1) in ( 'A','B' ) 
                      or substr(codice,1,2) = 'ZZ'
                       )
                ) LOOP
                BEGIN
                  D_annotazioni := D_annotazioni || CUR_NOTE.codice;
                END;
              END LOOP; -- CUR_NOTE
              IF length(nvl(D_annotazioni,' ')) > 36 THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' Annotazioni Estratte Parzialmente';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null );
              END IF; 
              IF nvl(d_annotazioni,' ') != ' ' THEN
                D_annotazioni := rpad(D_annotazioni,36,' ');
                insert into a_appoggio_stampe
                   ( no_prenotazione, no_passo, pagina, riga, testo )
                    values
                   ( prenotazione
                   , 2
                   , D_pagina
                   , D_riga
                   , 'DB'||lpad(to_char(D_num_ord),3,'0')||'166'
                         ||lpad(substr(D_annotazioni,1,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'167'
                         ||lpad(substr(D_annotazioni,3,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'168'
                         ||lpad(substr(D_annotazioni,5,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'169'
                         ||lpad(substr(D_annotazioni,7,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'170'
                         ||lpad(substr(D_annotazioni,9,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'171'
                         ||lpad(substr(D_annotazioni,11,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'172'
                         ||lpad(substr(D_annotazioni,13,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'173'
                         ||lpad(substr(D_annotazioni,15,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'174'
                         ||lpad(substr(D_annotazioni,17,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'175'
                         ||lpad(substr(D_annotazioni,19,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'176'
                         ||lpad(substr(D_annotazioni,21,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'177'
                         ||lpad(substr(D_annotazioni,23,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'178'
                         ||lpad(substr(D_annotazioni,25,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'179'
                         ||lpad(substr(D_annotazioni,27,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'180'
                         ||lpad(substr(D_annotazioni,29,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'181'
                         ||lpad(substr(D_annotazioni,31,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'182'
                         ||lpad(substr(D_annotazioni,33,2),16,' ')||
                     'DB'||lpad(to_char(D_num_ord),3,'0')||'183'
                         ||lpad(substr(D_annotazioni,35,2),16,' ')||
                     '{'
                   );
              END IF;
            END;
            END IF;

      IF nvl(CUR_RPFA.flag_solo_liq,'NO') = 'NO' THEN
/* in caso di 2 dip con radi = R ed entrambi con DEFS estrae il previdenziale solo per uno */
            D_step := 'Cursore EMENS';
            D_conta_emens   := 0;
            D_pagina_emens  := D_pagina;
            D_num_ord_emens := D_num_ord;

-- dbms_output.put_line('parametri per il cursore: '||D_anno||' '||CUR_RPFA.ci||' '||D_decimali);
            FOR CUR_EMENS in cursore_fiscale.CUR_EMENS (D_anno, CUR_RPFA.ci,'770', D_decimali)
            LOOP
-- dbms_output.put_line(' dentro al cursore ');
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
                  select sum( decode(D_decimali 
                                    , 'X', trunc(nvl(dape.imponibile,0))*100
                                         , trunc(nvl(dape.imponibile,0))
                            ))
                    into D_bonus_l243
                    from dati_particolari_emens dape
                   where anno = D_anno
                     and ci =  CUR_RPFA.ci
                     and identificatore = 'BONUS'
                     ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                      D_bonus_l243 := 0;
                  END;
                ELSE D_bonus_l243 := 0;
                END IF;

                BEGIN
                select max(decode( substr(riferimento,1,2),'01','Y','1'))
                     , max(decode( substr(riferimento,1,2),'02','Y','1'))
                     , max(decode( substr(riferimento,1,2),'03','Y','1'))
                     , max(decode( substr(riferimento,1,2),'04','Y','1'))
                     , max(decode( substr(riferimento,1,2),'05','Y','1'))
                     , max(decode( substr(riferimento,1,2),'06','Y','1'))
                     , max(decode( substr(riferimento,1,2),'07','Y','1'))
                     , max(decode( substr(riferimento,1,2),'08','Y','1'))
                     , max(decode( substr(riferimento,1,2),'09','Y','1'))
                     , max(decode( substr(riferimento,1,2),'10','Y','1'))
                     , max(decode( substr(riferimento,1,2),'11','Y','1'))
                     , max(decode( substr(riferimento,1,2),'12','Y','1'))
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
                BEGIN
                 select decode(D_mese_1,'Y','0',D_mese_1)
                      ||decode(D_mese_2,'Y','0',D_mese_2)
                      ||decode(D_mese_3,'Y','0',D_mese_3)
                      ||decode(D_mese_4,'Y','0',D_mese_4)
                      ||decode(D_mese_5,'Y','0',D_mese_5)
                      ||decode(D_mese_6,'Y','0',D_mese_6)
                      ||decode(D_mese_7,'Y','0',D_mese_7)
                      ||decode(D_mese_8,'Y','0',D_mese_8)
                      ||decode(D_mese_9,'Y','0',D_mese_9)
                      ||decode(D_mese_10,'Y','0',D_mese_10)
                      ||decode(D_mese_11,'Y','0',D_mese_11)
                      ||decode(D_mese_12,'Y','0',D_mese_12)
                   into D_mesi 
                   from dual;

                   IF   D_mesi = lpad('0',12,'0') THEN D_tutti := '1';
                   ELSE D_tutti := ' '; 
                   END IF;
                END;

                D_conta_emens  := D_conta_emens  + 1;
             IF D_conta_emens != 1 THEN
                D_pagina_emens  := D_pagina_emens + 1;
                D_num_ord_emens := D_num_ord_emens + 1;
-- dbms_output.put_line('riga 0 per modulo 4 emens : '||D_modulo);
-- dbms_output.put_line('ci e ci_erede : '||CUR_RPFA.ci||' '||nvl(CUR_RPFA.ci_erede,99999));
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                     , 2
                     , D_pagina_emens
                     , 0
                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                       lpad(to_char(D_modulo),8,'0')||
                       lpad(to_char(D_num_ord_emens),2,'0')||
                       rpad(nvl(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),' '),16,' ')||
                       lpad(' ',18,' ')||
                       nvl(D_dummy_f,' ')||
                       lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                       lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                       rpad(nvl(CUR_RPFA.c1,' '),15,' ')
                  from dual
                 where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_emens
                          and riga            = 0)
                ;
-- dbms_output.put_line('riga inserita: '||SQL%ROWCOUNT);
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                      , 2
                      , D_pagina_emens
                      , 300
                      , '}'
                  from dual
                    where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_emens
                          and riga            = 300)
                ;
                commit;
                D_riga := 30;
                D_conta_emens := 1;
              END IF;

              D_step := '1 Insert Cursore EMENS';
              D_riga := 31;
              IF CUR_EMENS.specie_rapporto = 'DIP' THEN
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              values
                 ( prenotazione
                 , 2
                 , D_pagina_emens
                 , D_riga
                 , 'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'001'
                       ||rpad(substr(nvl(CUR_EMENS.posizione_inps,' '),1,10),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'002'
                       ||rpad(nvl(decode(CUR_EMENS.inps,'X','1',''),' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'003'
                       ||rpad(nvl(decode(CUR_EMENS.altro,'X','1',''),' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'004'
                       ||lpad(nvl(CUR_EMENS.imponibile,' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'005'
                       ||rpad(decode(nvl(D_versamento,' '),'5','1',' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'006'
                       ||rpad(decode(nvl(D_versamento,' '),'6','1',' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'007'
                       ||rpad(decode(nvl(D_versamento,' '),'7','1',' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'008'
                       ||lpad(nvl(CUR_EMENS.ritenuta,' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'009'
                       ||lpad(nvl(to_char(nvl(D_bonus_l243,0)),' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'010'
                       ||rpad(nvl(D_tutti,' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'011'
                       ||rpad(nvl(D_mesi,' '),16,' ')||
                   '{'
                 )
              ;
              END IF; -- sezione dipendenti

              IF CUR_EMENS.specie_rapporto = 'COCO' THEN
              D_step := '2 Insert Cursore EMENS';
              D_riga := 32;
              insert into a_appoggio_stampe
             ( no_prenotazione, no_passo, pagina, riga, testo )
              values
                 ( prenotazione
                 , 2
                 , D_pagina_emens
                 , D_riga
                 , 'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'012'
                       ||lpad(nvl(CUR_EMENS.imponibile,' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'013'
                       ||lpad(nvl(CUR_EMENS.contributo,' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'014'
                       ||lpad(nvl(CUR_EMENS.ritenuta,' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'015'
                       ||lpad(nvl(to_char(decode(CUR_EMENS.tipo_agevolazione
                                                , null, nvl(CUR_EMENS.contributo,0)
                                                      , nvl(CUR_EMENS.contributo,0) - nvl(CUR_EMENS.imp_agevolazione,0)
                                                )),' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'016'
                       ||rpad(nvl(D_tutti,' '),16,' ')||
                   'DC'||lpad(to_char(D_num_ord_emens),3,'0')||'017'
                       ||rpad(nvl(D_mesi,' '),16,' ')||
                   '{'
                  )
              ;
              END IF; -- sezione collaboratori
            END LOOP; -- cur_emens


            D_step := 'Cursore DMA';
            D_conta_dma   := 0;
            D_pagina_dma  := D_pagina;
            D_num_ord_dma := D_num_ord;
-- dbms_output.put_line('prima del cursore dma');
            FOR CUR_DMA in cursore_fiscale.CUR_DMA (D_anno, CUR_RPFA.ci, D_decimali, D_dma_ass, D_forza_importi )
            LOOP
-- dbms_output.put_line('cursore');
-- controllo su casella 21 cassa pensione
                IF nvl(CUR_DMA.cassa_pensione,'1') not in ( '1', '2', '3', '4','5' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 21 Parte C: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DMA.cassa_pensione);
                END IF;
-- controllo su casella 22 cassa previdenza
                IF substr(nvl(CUR_DMA.cassa_previdenza,'6'),1,1) not in ( '6', '7' ) 
                or substr(nvl(CUR_DMA.cassa_previdenza,'6001'),2,3) not in ( '001', '002', '003' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 22 Parte C: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DMA.cassa_previdenza);
                END IF;
-- controllo su casella 23 cassa credito
                IF nvl(CUR_DMA.cassa_credito,'9') not in ( '9' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 23 Parte C: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DMA.cassa_credito);
                END IF;
-- controllo su casella 24 cassa enpdedp
                IF nvl(CUR_DMA.cassa_enpdedp,'8') not in ( '8' ) THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := ' per Casella 24 Parte C: ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DMA.cassa_enpdedp);
                END IF;

-- controllo su imponibili e contributi
                IF nvl(CUR_DMA.contr_pens,'0') != '0' and nvl(CUR_DMA.ipn_pens,'0') = '0' THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := 'per Impon. e Contr. Pensionistici - Rif. ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, CUR_DMA.anno_rif);
                END IF;
                IF nvl(CUR_DMA.contr_tfs,'0') != '0' and nvl(CUR_DMA.ipn_tfs,'0') = '0' THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := 'per Impon. e Contr. Tfs - Rif. ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null);
                END IF;
                IF nvl(CUR_DMA.contr_tfr,'0') != '0' and nvl(CUR_DMA.ipn_tfr,'0') = '0' THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := 'per Impon. e Contr. Tfr - Rif. ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null);
                END IF;
                IF nvl(CUR_DMA.contr_cassa_credito,'0') != '0' and nvl(CUR_DMA.ipn_cassa_credito,'0') = '0' THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := 'per Impon. e Contr. Cassa Credito - Rif. ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null);
                END IF;
                IF nvl(CUR_DMA.contr_enpdedp,'0') != '0' and nvl(CUR_DMA.ipn_enpdedp,'0') = '0' THEN
                  D_riga_e := D_riga_e + 1;
                  D_descr_errore := 'per Impon. e Contr. Enpdedp - Rif. ';
                  INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, null);
                END IF;

             D_conta_dma := D_conta_dma + 1;
             IF D_conta_dma != 1 THEN
                D_pagina_dma  := D_pagina_dma + 1;
                D_num_ord_dma := D_num_ord_dma + 1;
-- dbms_output.put_line('riga 0 per modulo 5 dma : '||D_modulo);
-- dbms_output.put_line('ci e ci_erede : '||CUR_RPFA.ci||' '||CUR_RPFA.ci_erede);
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                     , 2
                     , D_pagina_dma
                     , 0
                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                       lpad(to_char(D_modulo),8,'0')||
                       lpad(to_char(D_num_ord_dma),2,'0')||
                       rpad(nvl(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),' '),16,' ')||
                       lpad(' ',18,' ')||
                       nvl(D_dummy_f,' ')||
                       lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                       lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                       rpad(nvl(CUR_RPFA.c1,' '),15,' ')
                  from dual
                 where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_dma
                          and riga            = 0)
                ;
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo )
                select  prenotazione
                      , 2
                      , D_pagina_dma
                      , 300
                      , '}'
                  from dual
                    where not exists
                      (select 'x' from a_appoggio_stampe
                        where no_prenotazione = prenotazione
                          and no_passo        = 2
                          and pagina          = D_pagina_dma
                          and riga            = 300)
                ;
                commit;
                D_riga := 35;
                D_conta_dma := 1;
              END IF;

                D_step := '1 Insert Cursore DMA';
                D_riga:= 35;
                insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                values
                ( prenotazione
                , 2
                , D_pagina_dma
                , D_riga
                , 'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'018'
                      ||rpad(nvl(CUR_DMA.gest_cf,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'019'
                      ||rpad(lpad(nvl(to_char(CUR_DMA.prog_inpdap),'0'),5,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'021'
                      ||rpad(nvl(CUR_DMA.cassa_pensione,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'A22'
                      ||rpad(nvl(substr(CUR_DMA.cassa_previdenza,1,1),' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'B22'
                      ||rpad(nvl(substr(CUR_DMA.cassa_previdenza,2,3),' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'023'
                      ||rpad(nvl(CUR_DMA.cassa_credito,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'024'
                      ||rpad(nvl(CUR_DMA.cassa_enpdedp,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'025'
                      ||lpad(nvl(CUR_DMA.anno_rif,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'026'
                      ||lpad(nvl(CUR_DMA.ipn_pens,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'027'
                      ||lpad(nvl(CUR_DMA.contr_pens,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'028'
                      ||lpad(nvl(CUR_DMA.ipn_tfs,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'029'
                      ||lpad(nvl(CUR_DMA.contr_tfs,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'030'
                      ||lpad(nvl(CUR_DMA.ipn_tfr,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'031'
                      ||lpad(nvl(CUR_DMA.contr_tfr,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'032'
                      ||lpad(nvl(CUR_DMA.ipn_cassa_credito,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'033'
                      ||lpad(nvl(CUR_DMA.contr_cassa_credito,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'034'
                      ||lpad(nvl(CUR_DMA.ipn_enpdedp,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_dma),3,'0')||'035'
                      ||lpad(nvl(CUR_DMA.contr_enpdedp,' '),16,' ')||
                  '{'
                )
                ;
-- dbms_output.put_line('insert: '||sql%rowcount);
            END LOOP; -- cur_dma
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
            BEGIN
                select decode(D_decimali, 'X',trunc(nvl(c160,0),2)*100,trunc(nvl(c160,0),0))
                     , decode(D_decimali, 'X',trunc(nvl(c161,0),2)*100,trunc(nvl(c161,0),0))
                     , decode(D_decimali, 'X',trunc(nvl(c162,0),2)*100,trunc(nvl(c162,0),0))
                     , decode(D_decimali, 'X',trunc(nvl(c163,0),2)*100,trunc(nvl(c163,0),0))
                     , decode(D_decimali, 'X',trunc(nvl(c164,0),2)*100,trunc(nvl(c164,0),0))
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

            D_riga           := 40;
            D_num_inpdap     := 0;
            D_conta_inpdap   := 0;
            D_pagina_inpdap  := D_pagina;
            D_num_ord_inpdap := D_num_ord;
            D_inpdap_cf      := null;
            D_inpdap_serv    := null;
            D_inpdap_imp     := null;
            D_inpdap_cess    := to_date(null);
            D_inpdap_c_cess  := null;
            D_inpdap_mag     := null;
            D_inpdap_prov    := null;
            D_inpdap_dal     := to_date(null);
            D_inpdap_al      := to_date(null);
            D_inpdap_cassa   := null;
            D_inpdap_gg      := to_number(null);
            D_inpdap_fisse   := to_number(null);
            D_inpdap_acce    := to_number(null);
            D_inpdap_inadel  := to_number(null);
            D_inpdap_iis     := to_number(null);
            D_inpdap_ipn_tfr := to_number(null);
            D_inpdap_tfr     := to_number(null);
            D_inpdap_premio  := to_number(null);
            D_contributi_inpdap   := to_number(null);
            D_contributi_tfs := to_number(null);
            D_contributi_tfr := to_number(null);
            D_inpdap_ril     := null;
            D_inpdap_rif     := to_number(null);
            D_inpdap_ind_non_a := to_number(null);
            D_inpdap_l_388            := null;
            D_inpdap_perc_l300   := to_number(null);
            D_inpdap_data_decorrenza := to_date(null);
            D_inpdap_gg_tfr := to_number(null);
            D_inpdap_l_165   := to_number(null);
            D_inpdap_comp_18 := to_number(null);
            D_tredicesima    := to_number(null);
            D_gg_mag_1       := to_number(null);
            D_gg_mag_2       := to_number(null);
            D_gg_mag_3       := to_number(null);
            D_gg_mag_4       := to_number(null);
            D_data_opz_tfr :=   to_date(null);
            D_cf_amm_fisse :=   null;
            D_cf_amm_acc   :=   null;
            D_inpdap_comparto:=null;
            D_inpdap_sottocomparto:= null;
            D_inpdap_qualifica:= null;

            D_step := 'Cursore INPDAP';
            FOR CUR_INPDAP IN cursore_fiscale.CUR_INPDAP(D_anno, CUR_RPFA.ci, D_ini_a, D_fin_a, D_decimali)
            LOOP
        		 D_num_inpdap      := D_num_inpdap  + 1;
              IF D_num_inpdap = 1 THEN
                D_inpdap_cf      := CUR_INPDAP.gest_cf;
                D_inpdap_serv    := CUR_INPDAP.tipo_servizio;
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
                D_inpdap_iis     := CUR_INPDAP.iis_conglobata;
                D_inpdap_ipn_tfr := CUR_INPDAP.ipn_tfr;
                D_inpdap_tfr     := CUR_INPDAP.comp_tfr;
                D_inpdap_premio  := CUR_INPDAP.premio_prod;
                D_contributi_inpdap   := CUR_INPDAP.rit_inpdap;
                D_contributi_tfs := CUR_INPDAP.rit_tfs;
                D_contributi_tfr := CUR_INPDAP.contr_tfr;
                D_inpdap_ril     := CUR_INPDAP.rilevanza;
                D_inpdap_rif     := CUR_INPDAP.riferimento;
                D_inpdap_ind_non_a := CUR_INPDAP.ind_non_a;
                D_inpdap_l_388     := CUR_INPDAP.legge_388;
                D_inpdap_perc_l300   := CUR_INPDAP.perc_l300;
       	        D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
                D_inpdap_gg_tfr  := CUR_INPDAP.gg_tfr;
                D_inpdap_l_165   := CUR_INPDAP.l_165;
                D_inpdap_comp_18 := CUR_INPDAP.comp_18;
                D_tredicesima    := CUR_INPDAP.tredicesima;
                D_gg_mag_1       := CUR_INPDAP.gg_mag_1;
                D_gg_mag_2       := CUR_INPDAP.gg_mag_2;
                D_gg_mag_3       := CUR_INPDAP.gg_mag_3;
                D_gg_mag_4       := CUR_INPDAP.gg_mag_4;
                D_data_opz_tfr :=   CUR_INPDAP.data_opz_tfr;
                D_cf_amm_fisse :=   CUR_inpdap.cf_amm_fisse;
                D_cf_amm_acc   :=   CUR_inpdap.cf_amm_acc;
                D_inpdap_comparto:= CUR_INPDAP.comparto;
                D_inpdap_sottocomparto:= CUR_INPDAP.sottocomparto;
                D_inpdap_qualifica:= CUR_INPDAP.qualifica;
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
-- periodi uguali e consecutivi
                D_inpdap_cess      := CUR_INPDAP.data_cess;
                D_inpdap_c_cess    := CUR_INPDAP.causa_cess;
                D_inpdap_mag       := CUR_INPDAP.mag;
                D_inpdap_al        := CUR_INPDAP.al;
                D_inpdap_gg        := D_inpdap_gg     + CUR_INPDAP.gg_utili;
                D_inpdap_fisse     := D_inpdap_fisse  + CUR_INPDAP.comp_fisse;
                D_inpdap_acce      := D_inpdap_acce   + CUR_INPDAP.comp_accessorie;
                D_inpdap_inadel    := D_inpdap_inadel + CUR_INPDAP.comp_inadel;
                D_inpdap_iis       := D_inpdap_iis    + CUR_INPDAP.iis_conglobata;
                D_inpdap_ipn_tfr   := D_inpdap_ipn_tfr+ CUR_INPDAP.ipn_tfr;
                D_inpdap_tfr       := D_inpdap_tfr + CUR_INPDAP.comp_tfr;
                D_inpdap_premio    := D_inpdap_premio + CUR_INPDAP.premio_prod;
                D_inpdap_ind_non_a := D_inpdap_ind_non_a + CUR_INPDAP.ind_non_a;
                D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
                D_inpdap_gg_tfr  := D_inpdap_gg_tfr + CUR_INPDAP.gg_tfr;
                D_inpdap_l_165   := D_inpdap_l_165 + CUR_INPDAP.l_165;
                D_inpdap_comp_18 := D_inpdap_comp_18 + CUR_INPDAP.comp_18;
                D_tredicesima    := D_tredicesima  + CUR_INPDAP.tredicesima;
                D_gg_mag_1       := D_gg_mag_1 + CUR_INPDAP.gg_mag_1;
                D_gg_mag_2       := D_gg_mag_2 + CUR_INPDAP.gg_mag_2;
                D_gg_mag_3       := D_gg_mag_3 + CUR_INPDAP.gg_mag_3;
                D_gg_mag_4       := D_gg_mag_4 + CUR_INPDAP.gg_mag_4;
                D_data_opz_tfr :=   CUR_INPDAP.data_opz_tfr;
                D_cf_amm_fisse :=   CUR_inpdap.cf_amm_fisse;
                D_cf_amm_acc   :=   CUR_inpdap.cf_amm_acc;
                D_inpdap_comparto:= CUR_INPDAP.comparto;
                D_inpdap_sottocomparto:= CUR_INPDAP.sottocomparto;
                D_inpdap_qualifica:= CUR_INPDAP.qualifica;
                D_inpdap_perc_l300   := CUR_INPDAP.perc_l300;
                D_num_inpdap := D_num_inpdap + 1;
              ELSE
                D_conta_inpdap := D_conta_inpdap + 1;
		           IF D_conta_inpdap != 1 THEN
                  D_pagina_inpdap  := D_pagina_inpdap + 1;
                  D_num_ord_inpdap  := D_num_ord_inpdap +1;
-- dbms_output.put_line('riga 0 per modulo 6 ipost : '||D_modulo);
-- dbms_output.put_line('ci e ci_erede : '||CUR_RPFA.ci||' '||CUR_RPFA.ci_erede);
               insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                select prenotazione
                     , 2
                     , D_pagina_inpdap
                     , 0
                     , lpad(to_char(CUR_RPFA.ci),8,'0')||
                       lpad(to_char(D_modulo),8,'0')||
                       lpad(to_char(D_num_ord_inpdap),2,'0')||
                       rpad(nvl(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),' '),16,' ')||
                       lpad(' ',18,' ')||
                       nvl(D_dummy_f,' ')||
                       lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                       lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                       rpad(nvl(CUR_RPFA.c1,' '),15,' ')
                    from dual
                   where not exists
                        (select 'x' from a_appoggio_stampe
                          where no_prenotazione = prenotazione
                            and no_passo        = 2
                            and pagina          = D_pagina_inpdap
                            and riga            = 0)
                  ;
                  insert into a_appoggio_stampe
                 ( no_prenotazione, no_passo, pagina, riga, testo )
                  select  prenotazione
                        , 2
                        , D_pagina_inpdap
                        , 300
                        , '}'
                    from dual
                   where not exists
                        (select 'x' from a_appoggio_stampe
                          where no_prenotazione = prenotazione
                            and no_passo        = 2
                            and pagina          = D_pagina_inpdap
                            and riga            = 300)
                  ;
                  commit;
                  D_riga         := 40;
                  D_conta_inpdap := 1;
                END IF;
                IF CUR_INPDAP.data_cess is not null
                   and CUR_INPDAP.causa_cess is null THEN
                   BEGIN
                    select evra.cat_inpdap
                      into D_inpdap_c_cess
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
                     D_inpdap_c_cess := ' ';
                  END;
                END IF;
                D_step := '1 Insert Cursore INPDAP';
                D_riga:= D_riga + 1;
                insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                values
                ( prenotazione
                , 2
                , D_pagina_inpdap
                , D_riga
                , 'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'A36'
                      ||rpad(rpad(nvl(D_inpdap_comparto,' '),2,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'B36'
                      ||rpad(rpad(nvl(D_inpdap_sottocomparto,' '),2,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'C36'
                      ||rpad(rpad(nvl(D_inpdap_qualifica,' '),6,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'037'
                      ||rpad(nvl(D_inpdap_cf,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'038'
                      ||lpad(nvl(to_char(D_inpdap_data_decorrenza,'ddmmyyyy'),' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'039'
                      ||lpad(nvl(to_char(D_inpdap_dal,'ddmmyyyy'),' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'040'
                      ||lpad(nvl(to_char(D_inpdap_al,'ddmmyyyy'),' ') ,16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'041'
                      ||lpad(nvl(to_char(D_inpdap_gg_tfr),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'042'
                      ||lpad(nvl(D_inpdap_c_cess,' '),16,' ')||
                  '{'
                )
                ;
                D_step := '2 Insert Cursore INPDAP';
                D_riga:= D_riga + 1;
                insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                values
                ( prenotazione
                , 2
                , D_pagina_inpdap
                , D_riga
                , 'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'043'
                      ||lpad(nvl(D_inpdap_imp,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'044'
                      ||lpad(nvl(D_inpdap_serv,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'045'
                      ||lpad(nvl(D_inpdap_cassa,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'046'
                      ||lpad(nvl(D_inpdap_gg,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'047'
                      ||lpad(nvl(substr(D_inpdap_mag,1,3),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'048'
                      ||lpad(nvl(to_char(D_gg_mag_1),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'049'
                      ||lpad(nvl(substr(D_inpdap_mag,4,3),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'050'
                      ||lpad(nvl(to_char(D_gg_mag_2),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'051'
                      ||lpad(nvl(substr(D_inpdap_mag,7,3),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'052'
                      ||lpad(nvl(to_char(D_gg_mag_3),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'053'
                      ||lpad(nvl(substr(D_inpdap_mag,10,3),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'054'
                      ||lpad(nvl(to_char(D_gg_mag_4),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'055'
                      ||lpad(nvl(D_inpdap_fisse,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'056'
                      ||lpad(nvl(D_inpdap_acce,'0'),16,' ')||
                  '{'
                )
                ;
                D_step := '3 Insert Cursore INPDAP';
                D_riga:= D_riga + 1;
               insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                values
                ( prenotazione
                , 2
                , D_pagina_inpdap
                , D_riga
                , 'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'057'
                      ||lpad(nvl(to_char(D_inpdap_comp_18),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'058'
                      ||lpad(nvl(D_inpdap_inadel,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'059'
                      ||lpad(nvl(D_inpdap_tfr,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'060'
                      ||lpad(nvl(D_inpdap_premio,'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'061'
                      ||lpad(nvl(to_char(D_inpdap_ind_non_a),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'062'
                      ||lpad(nvl(to_char(D_inpdap_l_165),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'063'
                      ||lpad(nvl(to_char(D_tredicesima),'0'),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'064'
                      ||lpad(nvl(to_char(D_data_opz_tfr,'ddmmyyyy'),' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'065'
                      ||rpad(nvl(D_cf_amm_fisse,' '),16,' ')||
                  'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'066'
                      ||rpad(nvl(D_cf_amm_acc,' '),16,' ')||
                  '{'
                )
                ;
                D_step := '4 Insert Cursore INPDAP';
                D_riga:= D_riga + 1;
               insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                select prenotazione
                     , 2
                     , D_pagina_inpdap
                     , D_riga
                     , 'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'067'
                           ||lpad(nvl(D_contributi_inpdap,'0'),16,' ')||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'068'
                           ||lpad(nvl(D_contributi_tfs,'0'),16,' ')||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'069'
                           ||lpad(nvl(D_contributi_tfr,'0'),16,' ')||
                       '{'
                  from dual
                ;

                D_step := '5 Insert Cursore INPDAP';
                D_riga:= D_riga + 1;
                insert into a_appoggio_stampe
               ( no_prenotazione, no_passo, pagina, riga, testo )
                select prenotazione
                     , 2
                     , D_pagina_inpdap
                     , D_riga
                     , 'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'070'
                           ||lpad(nvl(decode(D_inpdap_l_388,'X','1',null),' '),16,' ')||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'071'
                           ||lpad(nvl(D_inpdap_iis,'0'),16,' ')||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'072'
                           ||lpad(nvl(D_inpdap_ipn_tfr,'0'),16,' ')||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'073'
                           ||decode( D_conta_inpdap
                                    ,1 , lpad(nvl(D_contr_sospesi_2002,'0'),16,' ')
                                       , lpad('0',16,' ')
                                    ) ||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'074'
                           ||decode( D_conta_inpdap
                                    ,1 , lpad(nvl(D_contr_sospesi_2003,'0'),16,' ')
                                       , lpad('0',16,' ')
                                    ) ||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'075'
                           ||decode( D_conta_inpdap
                                    ,1 , lpad(nvl(D_contr_sospesi_2004,'0'),16,' ')
                                       , lpad('0',16,' ')
                                    ) ||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'076'
                           ||decode( D_conta_inpdap
                                    ,1 , lpad(nvl(D_contr_sospesi_2005,'0'),16,' ')
                                       , lpad('0',16,' ')
                                    ) ||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'077'
                           ||decode( D_conta_inpdap
                                    ,1 , lpad(nvl(D_contr_sospesi_2006,'0'),16,' ')
                                       , lpad('0',16,' ')
                                    ) ||
                       'DC'||lpad(to_char(D_num_ord_inpdap),3,'0')||'078'
                           ||lpad(nvl(D_inpdap_perc_l300,'0'),16,' ')||
                       '{'
                  from dual
                ;
                IF CUR_INPDAP.gest_cf = 'Z'
                   THEN null;
                ELSE D_inpdap_cf      := CUR_INPDAP.gest_cf;
                     D_inpdap_serv    := CUR_INPDAP.tipo_servizio;
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
                     D_inpdap_iis     := CUR_INPDAP.iis_conglobata;
                     D_contributi_inpdap   := CUR_INPDAP.rit_inpdap;
                     D_contributi_tfs := CUR_INPDAP.rit_tfs;
                     D_contributi_tfr := CUR_INPDAP.contr_tfr;
                     D_inpdap_ipn_tfr := CUR_INPDAP.ipn_tfr;
                     D_inpdap_tfr     := CUR_INPDAP.comp_tfr;
                     D_inpdap_premio  := CUR_INPDAP.premio_prod;
                     D_inpdap_ril     := CUR_INPDAP.rilevanza;
                     D_inpdap_rif     := CUR_INPDAP.riferimento;
                     D_inpdap_ind_non_a := CUR_INPDAP.ind_non_a;
                     D_inpdap_l_388     := CUR_INPDAP.legge_388;
                     D_inpdap_perc_l300 := CUR_INPDAP.perc_l300;
                     D_inpdap_comparto:= CUR_INPDAP.comparto;
                     D_inpdap_sottocomparto:= CUR_INPDAP.sottocomparto;
                     D_inpdap_qualifica:= CUR_INPDAP.qualifica;
                     D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
                     D_inpdap_gg_tfr := CUR_INPDAP.gg_tfr;
                     D_inpdap_l_165   := CUR_INPDAP.l_165;
                     D_inpdap_comp_18 := CUR_INPDAP.comp_18;
                     D_tredicesima    := CUR_INPDAP.tredicesima;
                     D_gg_mag_1       := CUR_INPDAP.gg_mag_1;
                     D_gg_mag_2       := CUR_INPDAP.gg_mag_2;
                     D_gg_mag_3       := CUR_INPDAP.gg_mag_3;
                     D_gg_mag_4       := CUR_INPDAP.gg_mag_4;
                     D_data_opz_tfr   := CUR_INPDAP.data_opz_tfr;
                     D_cf_amm_fisse   := CUR_inpdap.cf_amm_fisse;
                     D_cf_amm_acc     := CUR_inpdap.cf_amm_acc;
                END IF;
              END IF;
              D_dummy_f := 'x';
            END LOOP; -- cur_inpdap
        END IF; -- controllo su D_ipost

            D_riga          := 50;
            D_conta_inail   := 0;
            D_num_inail     := 0;
            D_pagina_inail  := D_pagina;
            D_modulo_inail  := D_modulo;
            D_num_ord_inail := D_num_ord;
            D_step := 'Cursore INAIL';
            D_pos_ass       := null;
            D_cod_cat       := null;
            D_qual_inail    := null;
            D_inail_dal     := null;
            D_inail_al      := null;
            FOR CUR_INAIL IN
             ( select nvl(substr(ltrim(pos_inail)
                                 , 1 , decode(instr(pos_inail,'/')
                                             ,0, decode(instr(pos_inail,' ')
                                                             ,0, decode(instr(pos_inail,'-') 
                                                                       ,0,8,instr(pos_inail,'-')-1
                                                                       )
                                                               , instr(pos_inail,' ')-1
                                                       )
                                                ,instr(pos_inail,'/')-1
                                             )
                                 ),'0')
                    ||nvl(substr(pos_inail, decode(instr(pos_inail,'/')
                                                ,0,decode(instr(pos_inail,' ')
                                                         ,0,decode(instr(pos_inail,'-'),0,9,instr(pos_inail,'-')+1)
                                                           ,instr(pos_inail,' ')+1
                                                         )
                                                  ,instr(pos_inail,'/')+1
                                                )
                              ,2),'0')                    pos_ass
                    , nvl(dal, D_ini_a)                 dal
                    , nvl(al, D_fin_a)                  al
                    , nvl(codice_catasto,' ')           codice_catasto
                    , dein.qua_inail                    qual_inail
                    , '1'                               ord
               from denuncia_inail dein
              where anno = D_anno
                and dein.ci in
                   (select CUR_RPFA.ci
                      from dual
                     union
                    select ci_erede
                      from RAPPORTI_DIVERSI radi
                     where radi.ci = CUR_RPFA.ci
                       and radi.rilevanza in ('L','R')
                       and radi.anno = D_anno
                   )
                union
               select null              pos_ass
                    , to_date(null)     dal
                    , to_date(null)     al
                    , null              codice_catasto
                    , null              qual_inail
                    , '2'               ord
                 from dual
                order by 2,3,6
             ) LOOP

        D_num_inail      := D_num_inail + 1;

        IF D_num_inail = 1 THEN                    -- memorizzo i dati per confronto
           D_pos_ass    := CUR_INAIL.pos_ass;
           D_cod_cat    := CUR_INAIL.codice_catasto;
           D_qual_inail := CUR_INAIL.qual_inail;
           D_inail_dal  := CUR_INAIL.dal;
           D_inail_al   := CUR_INAIL.al;
        ELSIF                                      -- confronto
              nvl(D_pos_ass,' ')        = nvl(CUR_INAIL.pos_ass,' ')
          and nvl(D_cod_cat,' ')        = nvl(CUR_INAIL.codice_catasto,' ')
          and nvl(D_qual_inail,' ')     = nvl(CUR_INAIL.qual_inail,' ')
          and D_inail_al                <= CUR_INAIL.dal-1
        THEN                                      -- periodi uguali e consecutivi
           D_inail_al  := CUR_INAIL.al;
        ELSE
           D_conta_inail   := nvl(D_conta_inail,0) + 1;
-- controllo su casella 79
           IF nvl(D_qual_inail,'B') not in ( 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'L', 'M', 'N', 'P', 'Z')
              THEN
              D_riga_e := D_riga_e + 1;
              D_descr_errore := ' per Casella 79 - parte C: ';
              INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, D_qual_inail );
           END IF;
-- controllo su casella 80
           IF lpad( nvl(translate(nvl(D_pos_ass,'0'),'0123456789','0000000000'),'0'),10,'0') 
            = lpad('0',10,'0') THEN
              null;
           ELSE
              D_riga_e := D_riga_e + 1;
              D_descr_errore := ' Posizione INAIL ';
              INS_SEER ( prenotazione, CUR_RPFA.ci, D_riga_e, D_descr_errore, D_pos_ass );
              D_pos_ass := null;
           END IF;

           IF D_conta_inail != 1 THEN
              D_pagina_inail  := D_pagina_inail + 1;
              D_num_ord_inail  := D_num_ord_inail + 1;
-- dbms_output.put_line('riga 0 per modulo 7 inail: '||D_modulo);
-- dbms_output.put_line('ci e ci_erede : '||CUR_RPFA.ci||' '||CUR_RPFA.ci_erede);
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              select  prenotazione
                    , 2
                    , D_pagina_inail
                    , 0
                    , lpad(to_char(CUR_RPFA.ci),8,'0')||
                      lpad(to_char(D_modulo),8,'0')||
                      lpad(to_char(D_num_ord_inail),2,'0')||
                      rpad(nvl(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),' '),16,' ')||
                      lpad(' ',18,' ')||
                      nvl(D_dummy_f,' ')||
                      lpad(nvl(CUR_RPFA.cat_fiscale,'0'),2,'0')||
                      lpad(to_char(nvl(CUR_RPFA.ci_erede,0)),8,'0')||
                      rpad(nvl(CUR_RPFA.c1,' '),15,' ')
                 from dual
                where not exists
                        (select 'x' from a_appoggio_stampe
                          where no_prenotazione = prenotazione
                            and no_passo        = 2
                            and pagina          = D_pagina_inail
                            and riga            = 0)
                  ;
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              select  prenotazione
                    , 2
                    , D_pagina_inail
                    , 300
                    , '}'
                from dual
               where not exists
                        (select 'x' from a_appoggio_stampe
                          where no_prenotazione = prenotazione
                            and no_passo        = 2
                            and pagina          = D_pagina_inail
                            and riga            = 300)
                  ;
                  commit;
                  D_riga         := 50;
                  D_conta_inail := 1;
           END IF;
             D_step := 'Insert Cursore INAIL';
             D_riga:= D_riga + 1;
             insert into a_appoggio_stampe
             ( no_prenotazione, no_passo, pagina, riga, testo )
             values ( prenotazione
                    , 2
                    , D_pagina_inail
                    , D_riga
                    , 'DC'||lpad(to_char(D_num_ord_inail),3,'0')||'079'||
                            rpad(nvl(D_qual_inail,' '),16,' ')||
                      'DC'||lpad(to_char(D_num_ord_inail),3,'0')||'080'||
                            lpad(nvl(lpad(D_pos_ass,10,'0'),' '),16,' ')||
                      'DC'||lpad(to_char(D_num_ord_inail),3,'0')||'081'||
                            lpad(decode(nvl(D_inail_dal,D_ini_a)
                              ,D_ini_a,'0000'
                                      ,nvl(to_char(D_inail_dal,'ddmm'),' '))
                             ,16,' ')||
                      'DC'||lpad(to_char(D_num_ord_inail),3,'0')||'082'||
                            lpad(decode (nvl(D_inail_al,D_fin_a)
                            ,D_fin_a,'0000'
                                  ,nvl(to_char(D_inail_al,'ddmm'),' '))
                         ,16,' ')||
                      'DC'||lpad(to_char(D_num_ord_inail),3,'0')||'083'||
                            rpad(nvl(D_cod_cat,' '),16,' ')||
                     '{'
                    );
           IF CUR_INAIL.ord = '2'
              THEN null;
           ELSE      
              D_pos_ass    := CUR_INAIL.pos_ass;
              D_cod_cat    := CUR_INAIL.codice_catasto;
              D_qual_inail := CUR_INAIL.qual_inail;
              D_inail_dal  := CUR_INAIL.dal;
              D_inail_al   := CUR_INAIL.al;
           END IF; -- fine controllo per union di deposito
        END IF; -- fine controllo uguali e consecutivi
     END LOOP; -- cur_inail
  END IF;  -- CUR_RPFA.flag_solo_liq

    EXCEPTION
        WHEN NO_CODICEFISCALE then
          D_riga_e := D_riga_e + 1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,1,D_riga_e,'P05832',TO_CHAR(CUR_RPFA.ci)||' Individuo non gestito');
          COMMIT;
        WHEN OTHERS THEN
          D_descr_errore := SUBSTR(SQLERRM,1,200);
          D_riga_e := D_riga_e + 1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,1,D_riga_e,'P05832',SUBSTR('C.I.:'||TO_CHAR(CUR_RPFA.ci)||' '||D_step,1,50));
          D_riga_e := D_riga_e + 1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,1,D_riga_e,'P05832',SUBSTR(D_descr_errore,1,50));
    END; -- fine LOOP
        D_modulo  := greatest(D_modulo_inail,D_modulo_prec,D_modulo_ere, D_modulo);
        D_pagina  := greatest(D_pagina_det,D_pagina_emens,D_pagina_prec,D_pagina_ere
                             ,D_pagina_inail,D_pagina_inpdap,D_pagina_dma,D_pagina);
        D_dummy_f := null;
        D_cf_ere  := null;
        D_riga    := 0;
      COMMIT;
    END LOOP; -- cur rpfa
  END;
EXCEPTION
WHEN NO_QUALIFICA THEN
     null;
WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = 'A05721'
       where no_prenotazione = prenotazione;
      commit;
END;
end;
end;
/
