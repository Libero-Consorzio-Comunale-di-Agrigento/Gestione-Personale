CREATE OR REPLACE PACKAGE PECCSMFE IS
/******************************************************************************
 NOME:         PECCSMFE
 DESCRIZIONE:  Creazione del flusso per la Denuncia Fiscale 770 / SA su
               supporto magnetico
               (nastri a bobina o dischetti - ASCII - lung. 4000 crt.).
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
              Il PARAMETRO D_filtro_1 indica i dipendenti da elaborare
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PECCSMFE IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN

DECLARE 
--
-- Depositi e Contataori Vari
--
  D_dummy           varchar2(1);
  D_r1              varchar2(20);
  D_filtro_1        varchar2(15);
  D_pagina          number;
  D_riga            number;
  D_modulo          number;
  D_num_ord         number;
--
-- Variabili di Periodo
--
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
--
-- Variabili di Ente
--
  D_cod_fis_dic     varchar2(16);
  D_ente_cf         varchar2(16);
--
-- Variabili di Dettaglio
--
  D_data            varchar2(4);
  D_cod_fis         varchar2(16);
  D_dep_cod_fis     varchar2(16);
  D_esito_28        varchar2(1);
  D_tipo            varchar2(1);
  D_esito_38        varchar2(1);
  D_tot_rate        varchar2(1);
  D_caaf_nome       varchar2(40);
  D_caaf_cod_fis    varchar2(16);
  D_caaf_nr_albo    varchar2(16);
  D_data_ric        varchar2(16);
  D_conta_dip_1     number;
  D_conta_dip_2     number;
  T_compensi        number;

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
      select to_char(to_date(valore,decode(nvl(length(translate(valore,'a0123456789/','a')),0),0,'dd/mm/yyyy','dd-mon-yy')),'ddmm')
        into D_data
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DATA'      
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_data := null;
      END;
      BEGIN
      select to_number(substr(valore,1,11))
        into T_compensi
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_COMPENSI'      
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_cod_fis_dic := null;
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
           (select rpad(nvl( D_cod_fis
                           , ltrim(nvl( gest.codice_fiscale
                                      ,gest.partita_iva))),16)    ente_cf
                 , tbfa.ci                                        ci
                 , upper(anag.cognome)                            cognome
                 , upper(anag.nome)                               nome
                 , anag.codice_fiscale                            cod_fis
                 , substr(to_char(anag.data_nas,'ddmmyyyy'),1,8)  data_nas
                 , anag.sesso                                     sesso
                 , upper(comu_n.descrizione)                      com_nas
                 , substr( decode( sign(199-comu_n.cod_provincia)
                                 , -1, '  '
                                     , comu_n.sigla_provincia)
                         ,1,2)                                    prov_nas
              from comuni                comu_n
                 , gestioni              gest
                 , anagrafici            anag
                 , rapporti_individuali  rain
                 , report_770_abis       tbfa
             where tbfa.anno                = D_anno
               and gest.codice (+)          = tbfa.c1
               and nvl(tbfa.c1,' ')      like D_filtro_1
               and tbfa.ci                  = rain.ci
               and anag.ni                  = rain.ni
               and rain.rapporto           in
                  (select codice from classi_rapporto
                    where cat_fiscale in ('1','10'))
               and anag.al                 is null
               and comu_n.cod_comune        = anag.comune_nas
               and comu_n.cod_provincia     = anag.provincia_nas
               and exists
                  (select 'x' from denuncia_caaf
                    where anno (+) = D_anno - 1
                      and ci   (+) = tbfa.ci
                      and tipo (+) = 0
                      and nvl(conguaglio_2r,' ') != ' '
                   union
                   select 'x' from movimenti_contabili
                    where anno     = tbfa.anno
                      and mese    >= 8
                      and ci       = tbfa.ci
                      and voce    in
                         (select codice from voci_economiche
                           where specifica in 
                                      ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
                                      ,'IRPEF_AP','CSSN_DB','CSSN_CR'
                                      ,'CSSN_SINT','CSSN_RINT','CSSN_RATA'
                                      ,'CSSN_SSOP','IRPEF_SINT','IRPEF_1INT'
                                      ,'IRPEF_1SOP','IRPEF_AINT','IRPEF_ASOP'
                                      ,'IRPEF_SSOP','IRPEF_2R','IRPEF_2INT'
                                      ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
                                      ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
                                      ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP')))
             order by 1,3,4
           ) LOOP

             BEGIN

             D_pagina        := D_pagina    + 1;
             D_ente_cf       := CUR_RPFA.ente_cf;

             --
             --  Estrazione Dati 730 da CAAF           
             --
             BEGIN
             select nvl(max(deca.conguaglio_1r),' ')           esito_28
                  , nvl(max(deca.rettifica),' ')               tipo
                  , nvl(max(deca.conguaglio_2r),' ')           esito_38
                  , nvl(to_char(max(deca.nr_rate)),'0')        tot_rate
                  , max(decode
                        ( nvl(deca.irpef_db,0)+nvl(deca.irpef_cr,0)+
                          nvl(deca.irpef_1r,0)+
                          nvl(deca.irpef_acconto_ap,0)+
                          nvl(deca.cssn_db,0)+nvl(deca.cssn_cr,0)
                        , 0, decode( caaf.codice_fiscale
                                   , CUR_RPFA.ente_cf, ' '
                                                     , upper(caaf.cognome))
                           , ' '))                            caaf_nome
                  , max(decode
                        ( nvl(deca.irpef_db,0)+nvl(deca.irpef_cr,0)+
                          nvl(deca.irpef_1r,0)+
                          nvl(deca.irpef_acconto_ap,0)+
                          nvl(deca.cssn_db,0)+nvl(deca.cssn_cr,0)
                        , 0, decode( caaf.codice_fiscale
                                   , CUR_RPFA.ente_cf, ' '
                                                 , caaf.codice_fiscale)
                           , ' '))                     caaf_cod_fis
                  , max(decode
                        ( nvl(deca.irpef_db,0)+nvl(deca.irpef_cr,0)+
                          nvl(deca.irpef_1r,0)+
                          nvl(deca.irpef_acconto_ap,0)+
                          nvl(deca.cssn_db,0)+nvl(deca.cssn_cr,0)
                        , 0, decode( caaf.codice_fiscale
                                   , CUR_RPFA.ente_cf, '0'
                                                 , caaf.numero_doc)
                           , ' '))                     caaf_nr_albo
                  , max(decode
                        ( nvl(deca.irpef_db,0)+nvl(deca.irpef_cr,0)+
                          nvl(deca.irpef_1r,0)+
                          nvl(deca.irpef_acconto_ap,0)+
                          nvl(deca.cssn_db,0)+nvl(deca.cssn_cr,0)
                        , 0, D_data
                           , '0'))                      data_ric
                  , max(decode
                        ( nvl(caaf.codice_fiscale,' ')
                        , CUR_RPFA.ente_cf, decode( nvl(deca.irpef_db,0) +
                                                nvl(deca.irpef_cr,0) +
                                                nvl(deca.irpef_1r,0) +
                                                nvl(deca.irpef_acconto_ap,0) +
                                                nvl(deca.cssn_db,0)  +
                                                nvl(deca.cssn_cr,0) 
                                              , 0, 1
                                                 , 0)
                                      , 0)
                       )                                conta_dip_1
                  , max(decode
                        ( nvl(caaf.codice_fiscale,' ')
                        , CUR_RPFA.ente_cf, 0
                                      , decode( nvl(deca.irpef_db,0) +
                                                nvl(deca.irpef_cr,0) +
                                                nvl(deca.irpef_1r,0) +
                                                nvl(deca.irpef_acconto_ap,0) +
                                                nvl(deca.cssn_db,0)  +
                                                nvl(deca.cssn_cr,0)
                                              , 0, 1
                                                 , 0)
                        )
                       )                                conta_dip_2
               into D_esito_28
                  , D_tipo
                  , D_esito_38
                  , D_tot_rate
                  , D_caaf_nome
                  , D_caaf_cod_fis
                  , D_caaf_nr_albo
                  , D_data_ric
                  , D_conta_dip_1
                  , D_conta_dip_2
               from anagrafici     caaf
                  , denuncia_caaf  deca
              where deca.anno      = D_anno - 1
                and deca.ci        = CUR_RPFA.ci
                and deca.tipo      = 0
                and caaf.ni        =  
                   (select ni from rapporti_individuali
                     where ci = deca.ci_caaf)
                and caaf.al       is null
             ;
             EXCEPTION 
               WHEN NO_DATA_FOUND THEN D_esito_28      := ' ';
                                       D_tipo          := ' ';
                                       D_esito_38      := ' ';
                                       D_caaf_nome     := ' ';
                                       D_caaf_cod_fis  := ' ';
                                       D_caaf_nr_albo  := ' ';
                                       D_data_ric      := '0';
                                       D_conta_dip_1   := 0;
                                       D_conta_dip_2   := 0;
             END;
             BEGIN -- Azzera il tipo se restituzione per rettifica
               select ' ' 
                 into D_tipo
                 from dual
                where exists 
                     (select 'x' from movimenti_contabili
                       where anno     = D_anno
                         and mese    >= 8
                         and ci       = CUR_RPFA.ci
                         and voce    in
                            (select codice from voci_economiche
                              where specifica in   
                                   ('IRP_RET_1R','IRP_RET_2R','IRP_RET_AP')));
             EXCEPTION 
               WHEN NO_DATA_FOUND THEN null;
             END;
             FOR CUR_DECA IN
                (select 1                                     ord
                      , decode(sum(decode( voec.specifica
                                         , 'IRPEF_DB'  , abs(moco.imp)
                                         , 'IRPEF_CR'  , abs(moco.imp)
                                         , 'IRPEF_SINT', abs(moco.imp)
                                         , 'IRPEF_1R'  , abs(moco.imp)
                                         , 'IRPEF_1INT', abs(moco.imp)
                                         , 'IRPEF_1SOP', abs(moco.imp)
                                         , 'IRPEF_SSOP', abs(moco.imp)
                                         , 'IRPEF_AP'  , abs(moco.imp)
                                         , 'IRPEF_AINT', abs(moco.imp)
                                         , 'IRPEF_ASOP', abs(moco.imp)
                                         , 'IRPEF_RAS' , abs(moco.imp)
                                         , 'IRPEF_RIS' , abs(moco.imp)
                                         , 'IRPEF_RA1R', abs(moco.imp)
                                         , 'IRPEF_RI1R', abs(moco.imp)
                                         , 'IRPEF_RAAP', abs(moco.imp)
                                         , 'IRPEF_RIAP', abs(moco.imp)
                                         , 'IRP_RET_1R', abs(moco.imp)
                                         , 'IRP_RET_AP', abs(moco.imp)
                                         , 'CSSN_DB'   , abs(moco.imp)
                                         , 'CSSN_CR'   , abs(moco.imp)
                                         , 'CSSN_SINT' , abs(moco.imp)
                                         , 'CSSN_SSOP' , abs(moco.imp)
                                         , 'CSSN_RATA' , abs(moco.imp)
                                         , 'CSSN_RINT' , abs(moco.imp)
                                                       , 0
                                        )
                                 )
                             , 0, 0
                                , moco.mese)                       mese_cas8
                      , decode(sum(decode( voec.specifica
                                         , 'IRPEF_DB'  , abs(moco.imp)
                                         , 'IRPEF_CR'  , abs(moco.imp)
                                         , 'IRPEF_SINT', abs(moco.imp)
                                         , 'IRPEF_1R'  , abs(moco.imp)
                                         , 'IRPEF_1INT', abs(moco.imp)
                                         , 'IRPEF_1SOP', abs(moco.imp)
                                         , 'IRPEF_SSOP', abs(moco.imp)
                                         , 'IRPEF_AP'  , abs(moco.imp)
                                         , 'IRPEF_AINT', abs(moco.imp)
                                         , 'IRPEF_ASOP', abs(moco.imp)
                                         , 'IRPEF_RAS' , abs(moco.imp)
                                         , 'IRPEF_RIS' , abs(moco.imp)
                                         , 'IRPEF_RA1R', abs(moco.imp)
                                         , 'IRPEF_RI1R', abs(moco.imp)
                                         , 'IRPEF_RAAP', abs(moco.imp)
                                         , 'IRPEF_RIAP', abs(moco.imp)
                                         , 'IRP_RET_1R', abs(moco.imp)
                                         , 'IRP_RET_AP', abs(moco.imp)
                                         , 'CSSN_DB'   , abs(moco.imp)
                                         , 'CSSN_CR'   , abs(moco.imp)
                                         , 'CSSN_SINT' , abs(moco.imp)
                                         , 'CSSN_SSOP' , abs(moco.imp)
                                         , 'CSSN_RATA' , abs(moco.imp)
                                         , 'CSSN_RINT' , abs(moco.imp)
                                                    , 0
                                         )
                                  )
                              , 0, ' '
                                 , D_esito_28)                   st_esito_28
                      , decode(sum(decode( voec.specifica
                                         , 'IRPEF_DB'  , abs(moco.imp)
                                         , 'IRPEF_CR'  , abs(moco.imp)
                                         , 'IRPEF_SINT', abs(moco.imp)
                                         , 'IRPEF_1R'  , abs(moco.imp)
                                         , 'IRPEF_1INT', abs(moco.imp)
                                         , 'IRPEF_1SOP', abs(moco.imp)
                                         , 'IRPEF_SSOP', abs(moco.imp)
                                         , 'IRPEF_AP'  , abs(moco.imp)
                                         , 'IRPEF_AINT', abs(moco.imp)
                                         , 'IRPEF_ASOP', abs(moco.imp)
                                         , 'IRPEF_RAS' , abs(moco.imp)
                                         , 'IRPEF_RIS' , abs(moco.imp)
                                         , 'IRPEF_RA1R', abs(moco.imp)
                                         , 'IRPEF_RI1R', abs(moco.imp)
                                         , 'IRPEF_RAAP', abs(moco.imp)
                                         , 'IRPEF_RIAP', abs(moco.imp)
                                         , 'IRP_RET_1R', abs(moco.imp)
                                         , 'IRP_RET_AP', abs(moco.imp)
                                         , 'CSSN_DB'   , abs(moco.imp)
                                         , 'CSSN_CR'   , abs(moco.imp)
                                         , 'CSSN_SINT' , abs(moco.imp)
                                         , 'CSSN_SSOP' , abs(moco.imp)
                                         , 'CSSN_RATA' , abs(moco.imp)
                                         , 'CSSN_RINT' , abs(moco.imp)
                                                    , 0
                                         )
                                  )
                              , 0, ' '
                                 , ' ')                            st_tipo
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_DB', abs(moco.imp)
                                      , 'IRPEF_RAS',abs(moco.imp)
                                                  , 0)))           irpef_db
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_CR', abs(moco.imp)
                                                  , 0)))           irpef_cr
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_SINT', abs(moco.imp)
                                                    , 0)))         irpef_int
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_RIS' , abs(moco.imp)
                                                    , 0)))         irpef_ris
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_1R', abs(moco.imp)
                                      , 'IRPEF_RA1R', abs(moco.imp)
                                                  , 0)))           irpef_1r
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_1INT', abs(moco.imp)
                                                    , 0)))         irpef_1r_int
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_RI1R', abs(moco.imp)
                                                    , 0)))         irpef_ri1r
                      , abs(sum(decode( voec.specifica
                                      , 'IRP_RET_1R', abs(moco.imp)
                                                    , 0)))         irpef_ret_1r
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_1SOP', abs(moco.imp)
                                      , 'IRPEF_SSOP', abs(moco.imp)
                                                    , 0)))         irpef_1r_sop
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_AP', abs(moco.imp)
                                      , 'IRPEF_RAAP',abs(moco.imp)
                                                  , 0)))           irpef_ap
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_AINT', abs(moco.imp)
                                                    , 0)))         irpef_ap_int
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_RIAP', abs(moco.imp)
                                                    , 0)))         irpef_riap
                      , abs(sum(decode( voec.specifica
                                      , 'IRPEF_ASOP', abs(moco.imp)
                                                    , 0)))         irpef_ap_sop
                      , abs(sum(decode( voec.specifica
                                      , 'IRP_RET_AP', abs(moco.imp)
                                                    , 0)))         irpef_ret_ap
                      , abs(sum(decode( voec.specifica
                                      , 'CSSN_DB', abs(moco.imp)
                                      , 'CSSN_RATA', abs(moco.imp)
                                                 , 0)))            cssn_db
                      , abs(sum(decode( voec.specifica
                                      , 'CSSN_CR', abs(moco.imp)
                                                 , 0)))            cssn_cr
                      , abs(sum(decode( voec.specifica
                                      , 'CSSN_SINT', abs(moco.imp)
                                                   , 0)))          cssn_int
                      , abs(sum(decode( voec.specifica
                                      , 'CSSN_RINT', abs(moco.imp)
                                                   , 0)))          cssn_rint
                      , abs(sum(decode( voec.specifica
                                      , 'CSSN_SSOP', abs(moco.imp)
                                                   , 0)))          cssn_ssop
                      , decode(sum(decode( voec.specifica
                                         , 'IRPEF_2R'  , abs(moco.imp)
                                         , 'IRPEF_2INT', abs(moco.imp)
                                                       , 0
                                         )
                                  )
                              , 0, 0
                                 , moco.mese)                    mese_cas31
                      , decode(sum(decode( voec.specifica
                                         , 'IRPEF_2R'  , abs(moco.imp)
                                         , 'IRPEF_2INT', abs(moco.imp)
                                         , 'IRP_RET_2R', abs(moco.imp)
                                                       , 0
                                         )
                                  )
                              , 0, ' '
                                 , D_esito_38)                   st_esito_38
                      , abs(sum(decode( voec.specifica
                                  , 'IRPEF_2R', abs(moco.imp)
                                              , 0)))             irpef_2r
                      , abs(sum(decode( voec.specifica
                                  , 'IRPEF_2INT', abs(moco.imp)
                                                , 0)))           irpef_2r_int
                      , abs(sum(decode( voec.specifica
                                  , 'IRP_RET_2R', abs(moco.imp)
                                                , 0)))           irpef_ret_2r
                      , decode( D_tot_rate
                              , '0', 0
                                   , moco.mese-6)                nr_rata
                   from movimenti_contabili   moco
                      , voci_economiche       voec
                  where moco.anno (+)      = D_anno
                    and moco.mese         >= 8
                    and moco.ci   (+)      = CUR_RPFA.ci
                    and moco.voce          = voec.codice
                    and voec.specifica in 
                                      ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
                                      ,'IRPEF_AP','CSSN_DB','CSSN_CR'
                                      ,'CSSN_SINT','CSSN_RINT','CSSN_RATA'
                                      ,'CSSN_SSOP','IRPEF_SINT','IRPEF_1INT'
                                      ,'IRPEF_1SOP','IRPEF_AINT','IRPEF_ASOP'
                                      ,'IRPEF_SSOP','IRPEF_2R','IRPEF_2INT'
                                      ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
                                      ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
                                      ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP')
                  group by moco.mese
                  union
                  select 2                                     ord
                       , 0                                     mese_cas8
                       , ' '                                   st_esito_28
                       , 'L'                                   st_tipo
                       , nvl(deca.irpef_cr,0)                  irpef_db
                       , nvl(deca.irpef_db,0)                  irpef_cr
                       , nvl(deca.irpef_1r,0)                  irpef_int
                       , nvl(deca.irpef_2r,0)                  irpef_ris
                       , nvl(deca.cssn_db,0)                   irpef_1r
                       , nvl(deca.irpef_acconto_ap,0)          irpef_1r_int
                       , 0                                     irpef_ri1r
                       , 0                                     irpef_ret_1r
                       , 0                                     irpef_1r_sop
                       , 0                                     irpef_ap
                       , 0                                     irpef_ap_int
                       , 0                                     irpef_riap
                       , 0                                     irpef_ap_sop
                       , 0                                     irpef_ret_ap
                       , 0                                     cssn_db
                       , 0                                     cssn_cr
                       , 0                                     cssn_int
                       , 0                                     cssn_rint
                       , 0                                     cssn_ssop
                       , 0                                     mese_cas31
                       , ' '                                   st_esito_38
                       , 0                                     irpef_2r
                       , 0                                     irpef_2r_int
                       , 0                                     irpef_ret_2r
                       , 0                                     nr_rata
                    from denuncia_caaf     deca
                   where deca.anno         = D_anno - 1
                     and deca.ci           = CUR_RPFA.ci
                     and deca.rettifica    = 'L'
                     and nvl(deca.irpef_cr,0)   
                       + nvl(deca.irpef_db,0)    
                       + nvl(deca.irpef_1r,0)     
                       + nvl(deca.irpef_2r,0)      
                       + nvl(deca.cssn_db,0)         
                       + nvl(deca.irpef_acconto_ap,0) != 0
                     and not exists 
                        (select 'x' from movimenti_contabili
                          where anno     = D_anno
                            and mese    >= 8
                            and ci       = CUR_RPFA.ci
                            and voce    in
                               (select codice from voci_economiche
                                 where specifica in   
                                      ('IRP_RET_1R','IRP_RET_2R','IRP_RET_AP')))
                  union
                  select 3
                       , 0
                       , ' '            
                       , ' '           
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0
                       , 0  
                       , D_esito_38          
                       , 0
                       , 0
                       , 0
                       , 0  
                    from dual
                   where exists
                        (select 'x' from denuncia_caaf 
                          where anno (+)            = D_anno - 1
                            and ci   (+)            = CUR_RPFA.ci
                            and tipo (+)            = 0
                            and nvl(conguaglio_2r,' ') != ' ')
                     and not exists 
                        (select 'x' from movimenti_contabili
                          where anno     = D_anno
                            and mese    >= 8
                            and ci       = CUR_RPFA.ci
                            and voce    in
                               (select codice from voci_economiche
                                 where specifica in   
                                      ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
                                      ,'IRPEF_AP','CSSN_DB','CSSN_CR'
                                      ,'CSSN_SINT','CSSN_RINT','CSSN_RATA'
                                      ,'CSSN_SSOP','IRPEF_SINT','IRPEF_1INT'
                                      ,'IRPEF_1SOP','IRPEF_AINT','IRPEF_ASOP'
                                      ,'IRPEF_SSOP','IRPEF_2R','IRPEF_2INT'
                                      ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
                                      ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
                                      ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP')))
                 order by 1,2
                ) LOOP
                  BEGIN
                  D_num_ord       := D_num_ord   + 1;
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
                       D_riga    := 10;
                       D_num_ord := D_num_ord + 1;

                     insert into a_appoggio_stampe
                     values ( prenotazione
                            , 4
                            , D_pagina
                            , D_riga
                            , 'F'||
                              rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                  , 16, ' ')||
                              lpad(to_char(D_modulo),8,'0')||
                              lpad(' ',3,' ')||
                              lpad(' ',25,' ')||
                              lpad('0',8,'0')||
                              lpad(' ',12,' ')||
                              lpad(' ',16,' ')||
                              'SD001001'||
                              rpad(decode(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                         ,CUR_RPFA.ente_cf,' '
                                                          ,CUR_RPFA.ente_cf)
                                  ,16,' ')||
                              '}'
                            )
                     ;
                  END IF;
                  --
                  --  Inserimento Primo Record Dipendente 
                  --
                  D_pagina := D_pagina + 1;
                  D_riga   := 0;
                  D_riga   := D_riga   + 1;
                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 4
                         , D_pagina
                         , D_riga
                         , lpad(to_char(CUR_RPFA.ci),8,'0')||
                           lpad(to_char(D_num_ord),2,'0')||
                           nvl(CUR_DECA.st_tipo,' ')
                         )
                  ;

                  D_riga   := D_riga   + 1;
                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 4
                         , D_pagina
                         , D_riga
                         , 'F'||
                           rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                               , 16, ' ')||
                           lpad(to_char(D_modulo),8,'0')||
                           lpad(' ',3,' ')||
                           lpad(' ',25,' ')||
                           lpad('0',8,'0')||
                           lpad(' ',12,' ')||
                           lpad(' ',16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'001'||
                           rpad(CUR_RPFA.cod_fis,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'002'||
                           rpad(substr(CUR_RPFA.cognome,1,16),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'002'||
                           decode( greatest(16,length(CUR_RPFA.cognome))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.cognome,17,15)
                                                ,15,' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'002'||
                           decode( greatest(31,length(CUR_RPFA.cognome))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.cognome,32)
                                                ,'15',' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'003'||
                           rpad(substr(CUR_RPFA.nome,1,16),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'003'||
                           decode( greatest(16,length(CUR_RPFA.nome))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.nome,17,15)
                                                ,15,' ')
                                 )||
                           '{'
                         )
                  ;
                  --
                  --  Inserimento Secondo Record Dipendente 
                  --
                  D_riga   := D_riga   + 1;
                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 4
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'003'||
                           decode( greatest(31,length(CUR_RPFA.nome))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.nome,32)
                                                ,'15',' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'004'||
                           lpad(CUR_RPFA.data_nas,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'005'||
                           rpad(CUR_RPFA.sesso,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'006'||
                           rpad(substr(CUR_RPFA.com_nas,1,16),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'006'||
                           decode( greatest(16,length(CUR_RPFA.com_nas))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.com_nas,17,15)
                                                ,15,' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'006'||
                           decode( greatest(31,length(CUR_RPFA.com_nas))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.com_nas,32)
                                                ,'15',' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'007'||
                           rpad(CUR_RPFA.prov_nas,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'008'||
                           lpad(to_char(CUR_DECA.mese_cas8),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'009'||
                           lpad(to_char(CUR_DECA.irpef_cr),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           lpad(to_char(CUR_DECA.irpef_db),16,' ')||
                           '{'
                         )
                  ;
                  --
                  --  Inserimento Terzo Record Dipendente 
                  --
                  D_riga   := D_riga   + 1;
                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 4
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'011'||
                           lpad(to_char(CUR_DECA.irpef_int),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'012'||
                           lpad(to_char(CUR_DECA.irpef_ris),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'013'||
                           lpad(to_char(CUR_DECA.irpef_1r),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'014'||
                           lpad(to_char(CUR_DECA.irpef_1r_int),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'015'||
                           lpad(to_char(CUR_DECA.irpef_ri1r),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'016'||
                           lpad(to_char(CUR_DECA.irpef_ret_1r),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'017'||
                           lpad(to_char(CUR_DECA.irpef_1r_sop),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'018'||
                           lpad(to_char(CUR_DECA.cssn_cr),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'019'||
                           lpad(to_char(CUR_DECA.cssn_db),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'020'||
                           lpad(to_char(CUR_DECA.cssn_int),16,' ')||
                           '{'
                         )
                  ;

                  --
                  --  Inserimento Quarto Quinto Sesto e Settimo Records dip.   
                  --

                  D_riga := D_riga + 1;

                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 4
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'021'||
                           lpad(to_char(CUR_DECA.cssn_rint),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'022'||
                           lpad(to_char(CUR_DECA.cssn_ssop),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'023'||
                           lpad(to_char(CUR_DECA.irpef_ap),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'024'||
                           lpad(to_char(CUR_DECA.irpef_ap_int),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'025'||
                           lpad(to_char(CUR_DECA.irpef_riap),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'026'||
                           lpad(to_char(CUR_DECA.irpef_ret_ap),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'027'||
                           lpad(to_char(CUR_DECA.irpef_ap_sop),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'028'||
                           rpad(CUR_DECA.st_esito_28,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'029'||
                           rpad(CUR_DECA.st_tipo,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'030'||
                           lpad(D_tot_rate,16,' ')||
                           '{'
                         )
                  ;

                  D_riga := D_riga + 1;

                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 4
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'031'||
                           lpad(to_char(nvl(CUR_DECA.nr_rata,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'032'||
                           lpad('0',16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'033'||
                           lpad(to_char(CUR_DECA.mese_cas31),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'034'||
                           lpad(to_char(CUR_DECA.irpef_2r),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'035'||
                           lpad(to_char(CUR_DECA.irpef_2r_int),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'036'||
                           lpad(to_char(CUR_DECA.irpef_ret_2r),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'037'||
                           rpad(CUR_DECA.st_esito_38,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'038'||
                           rpad(nvl(D_caaf_cod_fis,' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'039'||
                           rpad(substr(nvl(D_caaf_nome,' '),1,16),16,' ')||
                           '{'
                         )
                  ;

                  D_riga := D_riga + 1;

                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 4
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'039'||
                           decode( greatest(16,length(D_caaf_nome))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(D_caaf_nome,17,15)
                                                ,15,' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'039'||
                           decode( greatest(31,length(D_caaf_nome))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(d_caaf_nome,32)
                                                ,'15',' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'040'||
                           lpad(nvl(D_caaf_nr_albo,'0'),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'041'||
                           lpad(D_data_ric,16,' ')||
                           '}'
                         )
                  ; 

                D_dep_cod_fis := D_cod_fis;
                END;
                END LOOP;

                D_riga := 0;
                END;
              END LOOP;
      END;
COMMIT;
END;
END;
END;
/