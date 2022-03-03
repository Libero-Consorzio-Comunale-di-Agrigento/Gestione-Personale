CREATE OR REPLACE PACKAGE PECCSMFF IS
/******************************************************************************
 NOME:          PECCSMFA.sql   CREAZIONE SUPPORTO MAGNETICO 770/SF
 DESCRIZIONE:   
      Questa fase produce un file secondo un tracciato concordato a livello 
      aziendale per via dei limiti di ORACLE che permette di creare record
      di max 250 crt. Una ulteriore elaborazione adeguera' questi files al
      tracciato imposto dal Ministero delle Finanze.
      Il file prodotto si trovera' nella directory \\dislocazione\sta del report server con il nome   
      PECCSMFF.txt .

      N.B.: La gestione che deve risultare come intestataria della denuncia 
            deve essere stata inserita in << DGEST >> in modo tale che la 
            ragione sociale (campo nome) risulti essere la minore di tutte 
            le altre eventualmente inserite.
            Lo stesso risultato si raGgiunge anche inserendo un BLANK prima
            del nome di tutte le gestioni che devono essere escluse.
 ARGOMENTI:   
      Creazione del flusso per la Denuncia Fiscale 770 / SF su 
      supporto magnetico
      (nastri a bobina o dischetti - ASCII - lung. 4000 crt.).
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PECCSMFF IS
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
  D_gg_a            number;
--
-- Variabili di Ente
--
  D_cod_fis_dic     varchar2(16);
  D_ente_cf         varchar2(16);
--
-- Variabili di Dettaglio
--
  D_cod_fis         varchar2(16);
  D_dep_cod_fis     varchar2(16);
  D_totale          varchar2(11);
  D_no_sogg         varchar2(11);
  D_no_sogg_rc      varchar2(11);
  D_ipn_ord         varchar2(11);
  D_ipt_ord         varchar2(11);
  D_ipt_sosp        varchar2(11);
--
-- Variabili di Totale
--
  T_nr_dip          number := 0;      
  T_totale          number := 0;      
  T_no_sogg         number := 0;      
  T_no_sogg_rc      number := 0;      
  T_ipn_ord         number := 0;      
  T_ipt_ord         number := 0;      
  T_ipt_sosp        number := 0;      


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

        T_nr_dip        := 0;      
        T_totale        := 0;      
        T_no_sogg       := 0;      
        T_ipn_ord       := 0;      
        T_ipt_ord       := 0;      
        T_ipt_sosp      := 0;      
        D_num_ord       := 0;
        D_modulo        := 1;
        D_pagina        := 0;
        D_riga          := 0;

         FOR CUR_RPFA IN
            (select rpad(nvl( D_cod_fis
                            , ltrim(nvl( gest.codice_fiscale
                                        ,gest.partita_iva))),16)   ente_cf
                  , rpad(anag.codice_fiscale,16,' ')               cod_fis
                  , tbfa.ci                                        ci
                  , anag.cognome                                   cognome
                  , nvl(anag.nome,' ')                             nome
                  , substr(to_char(anag.data_nas,'ddmmyy'),1,6)  data_nas
                  , anag.sesso                                     sesso
                  , comu_n.descrizione                             com_nas
                  , substr( decode( sign(199-comu_n.cod_provincia)
                                  , -1, '  '
                                      , nvl(comu_n.sigla_provincia,' ')) 
                          ,1,2)                                    prov_nas
                  , decode( sign(199-comu_r.cod_provincia)
                          , -1, ' '
                              , comu_r.descrizione)                com_res
                  , substr( decode( sign(199-comu_r.cod_provincia)
                                  , -1, '  '
                                      , comu_r.sigla_provincia) 
                          ,1,2)                                    prov_res
                  , decode( sign(199-comu_r.cod_provincia)
                          , -1, ' '
                          , anag.indirizzo_res)                    ind_res
                  , nvl(substr(rain.gruppo,1,1),'A')               causale 
                  , decode( sign(199-comu_r.cod_provincia)
                          , -1, '1'
                              , '0')                               nr
                  , decode( sign(199-comu_r.cod_provincia)
                          , -1, comu_r.descrizione
                              , ' ')                               com_res_e
                  , decode( instr(nvl(anag.note,' '),'CSE:') 
                          , 0, '000'
                             , substr( anag.note
                                     , instr(anag.note,'CSE:')+5,3))       cse 
                  , decode( instr(nvl(anag.note,' '),'CFE:') 
                          , 0, ' '
                             , substr( anag.note 
                                     , instr(anag.note,'CFE:')+5,20)
                          )                                           cfe 
               from gestioni              gest
                  , comuni                comu_n
                  , comuni                comu_r
                  , rapporti_individuali  rain
                  , anagrafici            anag
                  , tabella_fiscale_anno  tbfa
              where gest.codice (+)   = tbfa.c1
                and tbfa.anno         = D_anno           
                and nvl(tbfa.c1,' ')  like D_filtro_1
                and anag.ni           = rain.ni
                and anag.al          is null
                and rain.ci           = tbfa.ci
                and rain.rapporto    in 
                   (select codice 
                      from classi_rapporto
                     where cat_fiscale = '3')
                and comu_n.cod_comune        = anag.comune_nas
                and comu_n.cod_provincia     = anag.provincia_nas
                and comu_r.cod_comune = decode( sign(199-anag.provincia_res)
                                              , -1, 0
                                                  , anag.comune_res)
                and comu_r.cod_provincia     = anag.provincia_res
                and exists
                   (select 'x' 
                      from progressivi_fiscali
                     where anno      = D_anno
                       and mese      = 12
                       and mensilita =
                          (select max(mensilita) from mensilita
                            where mese = 12 
                              and tipo in ('S','N','A'))
                       and ci   = tbfa.ci
                   )
              order by 1,7,8  
           ) LOOP

             BEGIN

               D_pagina        := D_pagina   + 1;
               D_num_ord       := D_num_ord  + 1;
               D_ente_cf       := CUR_RPFA.ente_cf;

               IF D_num_ord = 10
                  THEN D_num_ord := 1; 
                       D_modulo  := D_modulo + 1;
                  ELSE null;
               END IF;
 
               BEGIN
               --
               --  Estrazione Dati Fiscali                
               --
                    select abs(( nvl(sum(prfi.ipn_ac),0)     
                                +nvl(sum(prfi.ipn_ap ),0)
                                +nvl(sum(prfi.rit_ord),0)
                                +nvl(sum(prfi.rit_ap ),0)
                                +nvl(sum(prfi.rit_sep),0)
                                +decode( sign(nvl(sum(prfi.somme_1),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_1),0))
                                +decode( sign(nvl(sum(prfi.somme_2),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_2),0))
                                +decode( sign(nvl(sum(prfi.somme_3),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_3),0))
                                +decode( sign(nvl(sum(prfi.somme_4),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_4),0))
                                +decode( sign(nvl(sum(prfi.somme_5),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_5),0))
                                +decode( sign(nvl(sum(prfi.somme_6),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_6),0))
                                +decode( sign(nvl(sum(prfi.somme_7),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_7),0))
                                +decode( sign(nvl(sum(prfi.somme_8),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_8),0))
                                +decode( sign(nvl(sum(prfi.somme_9),0))
                                       , -1,  0
                                           ,  nvl(sum(prfi.somme_9),0))
                              ) )                              TOTALE
                         , abs((nvl(sum(prfi.rit_ord),0)
                               +nvl(sum(prfi.rit_ap),0)
                               +nvl(sum(prfi.rit_sep),0)
                               +decode( sign(nvl(sum(prfi.somme_1),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_1),0))
                               +decode( sign(nvl(sum(prfi.somme_2),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_2),0))
                               +decode( sign(nvl(sum(prfi.somme_3),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_3),0))
                               +decode( sign(nvl(sum(prfi.somme_4),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_4),0))
                               +decode( sign(nvl(sum(prfi.somme_5),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_5),0))
                               +decode( sign(nvl(sum(prfi.somme_6),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_6),0))
                               +decode( sign(nvl(sum(prfi.somme_7),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_7),0))
                               +decode( sign(nvl(sum(prfi.somme_8),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_8),0))
                               +decode( sign(nvl(sum(prfi.somme_9),0))
                                      , -1,  0
                                          ,  nvl(sum(prfi.somme_9),0))
                              ) )                              NO_SOGG
                         , abs(nvl(sum(prfi.ipn_ac ),0)
                              +nvl(sum(prfi.ipn_ap ),0))              IPN_ORD
                         , abs(nvl(sum(prfi.ipt_pag),0)
                              +nvl(sum(prfi.ipt_ap ),0))              IPT_ORD
                         , abs(nvl(sum(prfi.somme_16),0))             IPT_SOSP
                         , decode( CUR_RPFA.nr
                                 ,'0', 0
                                     , abs(nvl(sum(prfi.somme_10),0))
                                 )                                    NO_SOGG_RC
                      into D_totale
                         , D_no_sogg
                         , D_ipn_ord  
                         , D_ipt_ord
                         , D_ipt_sosp
                         , D_no_sogg_rc
                      from progressivi_fiscali   prfi
                     where prfi.anno         = D_anno
                       and prfi.mese         = 12
                       and prfi.mensilita    = 
                          (select max(mensilita) from mensilita
                            where mese = 12 
                              and tipo in ('S','N','A'))
                       and prfi.ci           = CUR_RPFA.ci    
                    ;
                 END;
             END;

             IF D_num_ord = 1 
                THEN
                --
                --  Inserimento Primo Record             
                --
                D_riga   := D_riga   + 1;
                D_num_ord := D_num_ord + 1;
                insert into a_appoggio_stampe
                values ( prenotazione
                       , 5
                       , D_pagina
                       , D_riga
                       , 'G'||
                         '00'||
                         rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),16,' ')||
                         lpad(' ',25,' ')||
                         lpad(' ',35,' ')||
                         lpad(to_char(D_modulo),6,'0')||
                         'SF010100'||
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
             D_riga   := D_riga   + 1;
             insert into a_appoggio_stampe
             values ( prenotazione
                    , 5
                    , D_pagina
                    , D_riga
                    , 'G'||
                      '00'||
                      rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),16,' ')||
                      lpad(' ',25,' ')||
                      lpad(' ',35,' ')||
                      lpad(to_char(D_modulo),6,'0')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0100'||
                      rpad(CUR_RPFA.cod_fis,16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0200'||
                      rpad(substr(CUR_RPFA.cognome,1,16),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0200'||
                      decode( greatest(16,length(CUR_RPFA.cognome))
                            , 16, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.cognome,17,15)
                                           ,15,' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0200'||
                      decode( greatest(31,length(CUR_RPFA.cognome))
                            , 31, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.cognome,32)
                                           ,'15',' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0300'||
                      rpad(substr(nvl(CUR_RPFA.nome,' '),1,16),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0300'||
                      decode( greatest(16,length(nvl(CUR_RPFA.nome,' ')))
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
                    , 5
                    , D_pagina
                    , D_riga
                    , 'SF'||lpad(to_char(D_num_ord),2,'0')||'0300'||
                      decode( greatest(31,length(nvl(CUR_RPFA.nome,' ')))
                            , 31, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.nome,32)
                                           ,'15',' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0400'||
                      rpad(nvl(CUR_RPFA.sesso,' '),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0500'||
                      lpad(nvl(CUR_RPFA.data_nas,'0'),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0600'||
                      rpad(substr(nvl(CUR_RPFA.com_nas,' '),1,16),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0600'||
                      decode( greatest(16,length(nvl(CUR_RPFA.com_nas,' ')))
                            , 16, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.com_nas,17,15)
                                           ,15,' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0600'||
                      decode( greatest(31,length(nvl(CUR_RPFA.com_nas,' ')))
                            , 31, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.com_nas,32)
                                           ,'15',' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0700'||
                      rpad(CUR_RPFA.prov_nas,16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0800'||
                      rpad(substr(CUR_RPFA.com_res,1,16),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0800'||
                      decode( greatest(16,length(CUR_RPFA.com_res))
                            , 16, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.com_res,17,15)
                                           ,15,' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'0800'||
                      decode( greatest(31,length(CUR_RPFA.com_res))
                            , 31, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.com_res,32)
                                           ,'15',' ')
                            )||
                      '{'
                    )
             ;
             --
             --  Inserimento Terzo Record Dipendente 
             --
             D_riga   := D_riga   + 1;
             insert into a_appoggio_stampe
             values ( prenotazione
                    , 5
                    , D_pagina
                    , D_riga
                    , 'SF'||lpad(to_char(D_num_ord),2,'0')||'0900'||
                      rpad(CUR_RPFA.prov_res,16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1000'||
                      rpad(substr(CUR_RPFA.ind_res,1,16),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1000'||
                      decode( greatest(16,length(CUR_RPFA.ind_res))
                            , 16, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.ind_res,17,15)
                                           ,15,' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1000'||
                      decode( greatest(31,length(CUR_RPFA.ind_res))
                            , 31, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.ind_res,32)
                                           ,'15',' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1100'||
                      lpad(nvl(CUR_RPFA.nr,'0'),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1200'||
                      rpad(substr(nvl(CUR_RPFA.com_res_e,' '),1,16),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1200'||
                      decode( greatest(16,length(CUR_RPFA.com_res_e))
                            , 16, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.com_res_e,17,15)
                                           ,15,' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1200'||
                      decode( greatest(31,length(CUR_RPFA.com_res_e))
                            , 31, rpad(' ',16,' ')
                                , '+'||rpad(substr(CUR_RPFA.com_res_e,32)
                                           ,'15',' ')
                            )||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1300'||
                      lpad(nvl(CUR_RPFA.cse,'0'),16,' ')||
                      'SF'||lpad(to_char(D_num_ord),2,'0')||'1400'||
                      rpad(nvl(CUR_RPFA.cfe,' '),16,' ')||
                      '{'
                    )
             ;
                  --
                  --  Inserimento Quarto Quinto Sesto e Settimo Records dip.   
                  --

                  D_riga := D_riga + 1;

                  insert into a_appoggio_stampe
                  values ( prenotazione
                         , 5
                         , D_pagina
                         , D_riga
                         , 'SF'||lpad(to_char(D_num_ord),2,'0')||'1500'||
                           rpad(nvl(CUR_RPFA.causale,' '),16,' ')||
                           'SF'||lpad(to_char(D_num_ord),2,'0')||'1600'||
                           lpad(nvl(D_totale,'0'),16,' ')||
                           'SF'||lpad(to_char(D_num_ord),2,'0')||'1700'||
                           lpad(nvl(D_no_sogg,'0'),16,' ')||
                           'SF'||lpad(to_char(D_num_ord),2,'0')||'1800'||
                           lpad(nvl(D_no_sogg_rc,'0'),16,' ')||
                           'SF'||lpad(to_char(D_num_ord),2,'0')||'1900'||
                           lpad(D_ipn_ord,16,' ')||
                           'SF'||lpad(to_char(D_num_ord),2,'0')||'2000'||
                           lpad(D_ipt_ord,16,' ')||
                           'SF'||lpad(to_char(D_num_ord),2,'0')||'2100'||
                           lpad(D_ipt_sosp,16,' ')||
                           '}'
                         )
                  ; 

                D_riga := 0;

                IF nvl(D_cod_fis,' ') = nvl(D_dep_cod_fis,' ')
                   THEN null;
                   ELSE  T_nr_dip     := T_nr_dip      + 1;
                         T_totale     := T_totale      + D_totale;
                         T_no_sogg    := T_no_sogg     + D_no_sogg;
                         T_no_sogg_rc := T_no_sogg_rc  + D_no_sogg_rc;
                         T_ipn_ord    := T_ipn_ord     + D_ipn_ord;
                         T_ipt_ord    := T_ipt_ord     + D_ipt_ord;
                         T_ipt_sosp   := T_ipt_sosp    + D_ipt_sosp;
                END IF;
                D_dep_cod_fis := D_cod_fis;
              END LOOP;
              BEGIN
              --
              --  Inserimento Primo Record Totale 
              --
              D_pagina := D_pagina + 1;
              D_riga   := D_riga   + 1;

              insert into a_appoggio_stampe
              values ( prenotazione
                     , 5
                     , D_pagina
                     , D_riga
                     , 'G'||
                       '00'||
                       rpad(nvl(D_cod_fis_dic,D_ente_cf),16,' ')||
                       lpad(' ',25,' ')||
                       lpad(' ',35,' ')||
                       lpad(to_char(D_modulo),6,'0')||
                       'SF100100'||
                       lpad(to_char(nvl(T_nr_dip,0)),16,' ')||
                       'SF100200'||
                       lpad(to_char(nvl(T_totale,0)),16,' ')||   
                       'SF100300'||
                       lpad(to_char(nvl(T_no_sogg,0)),16,' ')||        
                       'SF100400'||
                       lpad(to_char(nvl(T_no_sogg_rc,0)),16,' ')||         
                       'SF100500'||
                       lpad(to_char(nvl(T_ipn_ord,0)),16,' ')||           
                       'SF100600'||
                       lpad(to_char(nvl(T_ipt_ord,0)),16,' ')||      
                       '{'
                     )
              ;

              --
              --  Inserimento Secondo Record Totale 
              --
              D_riga   := D_riga   + 1;

              insert into a_appoggio_stampe
              values ( prenotazione
                     , 5
                     , D_pagina
                     , D_riga
                     , 'SF100700'||
                       lpad(to_char(nvl(T_ipt_sosp,0)),16,' ')||      
                       '}'
                     )
              ;
              END;
      END;
COMMIT;
END;
END;
END;
/