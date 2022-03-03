/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECCSMDS IS
/******************************************************************************
 NOME:        PECCSMDS
 DESCRIZIONE: Creazione del flusso per la Denuncia INPS O1/M su supporto magnetico
              (dischetti a 5',25 o 3',50 - ASCII - lung. 128 crt.).
              Questa fase produce un file secondo i tracciati imposti dalla Direzione
              dell' INPS.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  La gestione che deve risultare come intestataria della denuncia
               deve essere stata inserita in << DGEST >> in modo tale che la
               ragione sociale (campo nome) risulti essere la minore di tutte
               le altre eventualmente inserite.
               Lo stesso risultato si raggiunge anche inserendo un BLANK prima
               del nome di tutte le gestioni che devono essere escluse.
               Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
               da elaborare.
               Il PARAMETRO D_ced indica quale gestione deve risultare come
               C.E.D. che ha elaborato il supporto.
               Il PARAMETRO D_pos_inps indica quale posizione INPS deve essere ela-
               rata (% = tutte).
               Il PARAMETRO D_prog_den indica il progressivo di presentazione del
               supporto.
               Il PARAMETRO D_tipo_sup indica il tipo di supporto utilizzato.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY PECCSMDS IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
DECLARE
--
--  Variabili di Ordinamento
--
  D_pagina    number;
  D_riga      number;
  D_prog_rec  number;
  D_prog_ind  number;
--
--  Variabili di Estrazione
--
  D_rire      varchar2(2);
  D_anno      number;
  D_ini_a     date;
  D_fin_a     date;
  D_ced       varchar2(4);
  D_pos_inps  varchar2(12);
  D_prog_den  varchar2(2);
  D_tipo_sup  varchar2(2);
--
--  Variabili di CED
--
  D_ced_nome     varchar2(50);
  D_tot_11       varchar2(6);
  D_tot_21       number := 0;
  D_tot_22       number := 0;
  D_tot_41       number := 0;
  D_tot_42       number := 0;
  D_tot_47       number := 0;
  D_tot_51       number := 0;
  D_tot_61       number := 0;
  D_tot_62       number := 0;
  D_tot_dip      number := 0;
  D_ced_sede     varchar2(4);
  D_ced_cf       varchar2(16);
  D_ced_inps     varchar2(10);
  D_ced_ir       varchar2(32);
  D_ced_nc       varchar2(5);
  D_ced_cr       varchar2(23);
  D_ced_pr       varchar2(2);
  D_ced_cap      varchar2(5);
--
--  Variabili Individuali
--
  D_cn        varchar2(24);
  D_pn        varchar2(2);
  D_cr        varchar2(23);
  D_pr        varchar2(3);
--
--  Variabili di Rapporto
--
  D_ini_rap   varchar2(6);
  D_fin_rap   varchar2(6);
  D_td        varchar2(2);
  D_cat_fis   varchar2(2);
--
--  Definizione Exception
--
  NO_CED EXCEPTION;
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
    select substr(valore,1,4)
      into D_ced
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CED'
       and exists
          (select 'x' from gestioni
            where codice = rtrim(substr(valore,1,4))
          )
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            -- Gestione C.E.D. non prevista
               update a_prenotazioni set errore = 'P01201'
                                          , prossimo_passo = 99
                where no_prenotazione = prenotazione
               ;
            COMMIT;
            RAISE NO_CED;
  END;
  BEGIN
    select substr(valore,1,12)
      into D_pos_inps
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_POS_INPS'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_pos_inps := '%';
  END;
  BEGIN
    select substr(valore,1,2)
      into D_prog_den
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_PROG_DEN'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_prog_den := '01';
  END;
  BEGIN
    select substr(valore,1,2)
      into D_tipo_sup
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TIPO_SUP'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_tipo_sup := '09';
  END;
  BEGIN
    D_pagina := 0;
    D_riga   := 0;
    --
    --  Estrazione anno di presentazione supporto
    --
    BEGIN
      select substr(to_char(anno),3,2)
        into D_rire
        from riferimento_retribuzione
       where rire_id = 'RIRE'
      ;
    END;
    --
    --  Estrazione numero gestioni in denuncia (tot. record 11)
    --
    BEGIN
      select lpad(to_char(count(distinct posizione_inps)),6,'0')
        into D_tot_11
        from gestioni
       where posizione_inps like D_pos_inps
         and exists
            (select 'x' from denuncia_o1_inps
              where anno     = D_anno
                and gestione = gestioni.codice)
      ;
    END;
    --
    --  Estrazione Dati C.E.D.
    --
    BEGIN
      select rpad(gest.nome,50,' ')
           , lpad(to_char(nvl(gest.provincia_sede_inps,0)),2,'0')||
             lpad(to_char(nvl(gest.zona_sede_inps,0)),2,'0')
           , rpad(nvl(gest.partita_iva,gest.codice_fiscale),16,' ')
           , rpad(gest.posizione_inps,10,' ')
           , rpad(gest.indirizzo_res,32,' ')
           , rpad(gest.numero_civico,5,' ')
           , rpad(comu.descrizione,23,' ')
           , comu.sigla_provincia
           , gest.cap
        into D_ced_nome
           , D_ced_sede
           , D_ced_cf
           , D_ced_inps
           , D_ced_ir
           , D_ced_nc
           , D_ced_cr
           , D_ced_pr
           , D_ced_cap
        from gestioni gest
           , comuni   comu
       where gest.codice        = D_ced
         and comu.cod_comune    = gest.comune_res
         and comu.cod_provincia = gest.provincia_res
      ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            -- Comune non codificato
               update a_prenotazioni set errore = 'P00800'
                                       , prossimo_passo = 99
                where no_prenotazione = prenotazione
               ;
            COMMIT;
            RAISE NO_CED;
    END;
    --
    --  Inserimento Dati C.E.D.
    --
    D_pagina := D_pagina + 1;
    D_riga   := D_riga   + 1;
    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
    values ( prenotazione
           , 1
           , D_pagina
           , D_riga
           , '01'||
             rpad(' ',10,' ')||
             D_ced_nome||
             'INPSDMINDIV'||
             D_tot_11||
             D_ced_sede||
             'NORMAL'||
             D_ced_cf||
             D_ced_inps||
             D_rire||
             D_prog_den||
             '6'||
             rpad(' ',8,' ')
           )
    ;
    D_pagina := D_pagina + 1;
    D_riga   := D_riga   + 1;
    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
    values ( prenotazione
           , 1
           , D_pagina
           , D_riga
           , '02'||
             rpad(' ',10,' ')||
             D_ced_ir||
             D_ced_nc||
             D_ced_cr||
             D_ced_pr||
             D_ced_cap||
             rpad(' ',49,' ')
           )
    ;
  END;
  --
  --  Loop per inserimento records 11 e 12 (Gestioni)
  --
  BEGIN
    FOR CUR_11 IN
       (select rpad(gest.nome,50,' ')                           gest_nome
             , lpad(to_char(nvl(gest.zona_sede_inps,0)),2,'0')  gest_zona
             , rpad(nvl( gest.partita_iva
                       , gest.codice_fiscale),16,' ')           gest_cf
             , gest.posizione_inps                              gest_inps
             , rpad(gest.indirizzo_res,32,' ')                  gest_ir
             , rpad(gest.numero_civico,5,' ')                   gest_nc
             , rpad(comu.descrizione,23,' ')                    gest_cr
             , comu.sigla_provincia                             gest_pr
             , gest.cap                                         gest_cap
          from gestioni gest
             , comuni   comu
         where gest.codice in
              (select substr(min(rpad(nome,40)||codice),41,4)
                 from gestioni
                where substr(nome,1,1) !=   ' '
                  and posizione_inps   like D_pos_inps
                group by posizione_inps
              )
           and exists
              (select 'x' from denuncia_o1_inps
                where anno     = D_Anno
                  and gestione = gest.codice)
           and comu.cod_comune    = gest.comune_res
           and comu.cod_provincia = gest.provincia_res
       ) LOOP
         BEGIN
           D_prog_rec := 0;
           D_prog_ind := 0;
           BEGIN
             D_prog_rec := D_prog_rec + 1;
             D_pagina   := D_pagina   + 1;
             D_riga     := D_riga     + 1;
             insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
             values ( prenotazione
                    , 1
                    , D_pagina
                    , D_riga
                    , '11'||
                      rpad(' ',10,' ')||
                      CUR_11.gest_nome||
                      D_tipo_sup||
                      'C'||
                      CUR_11.gest_cf||
                      '1'||
                      rpad(' ',26,' ')||
                      substr(to_char(D_anno),3,2)||
                      lpad(to_char(D_prog_rec),6,'0')||
                      rpad(CUR_11.gest_inps,10,' ')||
                      CUR_11.gest_zona
                    )
             ;
             D_prog_rec := D_prog_rec + 1;
             D_pagina   := D_pagina + 1;
             D_riga     := D_riga   + 1;
             insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
             values ( prenotazione
                    , 1
                    , D_pagina
                    , D_riga
                    , '12'||
                      rpad(' ',10,' ')||
                      CUR_11.gest_ir||
                      CUR_11.gest_nc||
                      CUR_11.gest_cr||
                      CUR_11.gest_pr||
                      CUR_11.gest_cap||
                      rpad(' ',29,' ')||
                      substr(to_char(D_anno),3,2)||
                      lpad(to_char(D_prog_rec),6,'0')||
                      rpad(CUR_11.gest_inps,10,' ')||
                      CUR_11.gest_zona
                    )
             ;
           END;
           --
           --  Estrazione Dipendenti da Elaborare
           --
           DECLARE
             D_tot_dip_az   number := 0;
             D_tot_21_az    number := 0;
             D_tot_22_az    number := 0;
             D_tot_41_az    number := 0;
             D_tot_42_az    number := 0;
             D_tot_47_az    number := 0;
             D_tot_51_az    number := 0;
             D_tot_cc_az    number := 0;
             D_tot_ac_az    number := 0;
             D_tot_ap_az    number := 0;
             D_tot_c1_az    number := 0;
             D_tot_c2_az    number := 0;
             D_tot_c3_az    number := 0;
             D_tot_c4_az    number := 0;
             BEGIN
             FOR CUR_DIP IN
                (select d1is.codice                           inps
                      , anag.ni                               ni
                      , max(anag.cognome)                     cognome
                      , max(anag.nome)                        nome
                      , max(anag.codice_fiscale)              cf
                      , to_char(max(anag.data_nas),'ddmmyy')  data_nas
                      , max(anag.comune_nas)                  cod_cn
                      , max(anag.provincia_nas)               cod_pn
                      , max(anag.sesso)                       sesso
                      , max(anag.cittadinanza)                cittadinanza
                      , max(anag.indirizzo_res)               ir
                      , max(anag.comune_res)                  cod_cr
                      , max(anag.provincia_res)               cod_pr
                      , max(anag.cap_res)                     cap_res
                   from anagrafici        anag
                      , denuncia_o1_inps  d1is
                  where d1is.anno      = D_anno
                    and d1is.gestione in
                       (select codice from gestioni
                         where posizione_inps = CUR_11.gest_inps
                       )
                    and anag.ni =
                       (select distinct ni
                          from rapporti_individuali
                         where ci = d1is.ci
                       )
                    and anag.al    is null
                  group by anag.ni,d1is.codice
                  order by 3,4
                ) LOOP
                  DECLARE
                    D_tot_41_i number := 0;
                    D_tot_42_i number := 0;
                    D_tot_47_i number := 0;
                    D_tot_51_i number := 0;
                  BEGIN
                    D_riga       := 0;
                    D_pagina     := D_pagina     + 1;
                    D_tot_dip_az := D_tot_dip_az + 1;
                    --
                    --  Determinazione Inserimento Record 21 e 22 (Anagrafe)
                    --
                    IF CUR_DIP.inps is null
                       THEN
                          --
                          --  Estrazione Comune Nascita
                          --
                          BEGIN
                          select rpad(descrizione,24,' ')
                               , decode( sign(199-CUR_DIP.cod_pn)
                                       , -1, '  '
                                           , rpad(sigla_provincia,2,' '))
                            into D_cn,D_pn
                            from comuni
                           where cod_comune    = CUR_DIP.cod_cn
                             and cod_provincia = CUR_DIP.cod_pn
                          ;
                          EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                  D_cn := ' ';
                                  D_pn := '  ';
                          END;
                          --
                          --  Estrazione Comune Residenza
                          --
                          BEGIN
                          select rpad(descrizione,23,' ')
                               , rpad(sigla_provincia,3,' ')
                            into D_cr,D_pr
                            from comuni
                           where cod_comune    = CUR_DIP.cod_cr
                             and cod_provincia = CUR_DIP.cod_pr
                          ;
                          EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                  D_cr := ' ';
                                  D_pr := '   ';
                          END;
                          D_tot_21_az := D_tot_21_az + 1;
                          D_prog_rec  := D_prog_rec  + 1;
                          D_prog_ind  := D_prog_ind  + 1;
                          D_riga      := D_riga      + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values ( prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , '21'||
                                   lpad(to_char(D_prog_ind),9,'0')||
                                   ' '||
                                   rpad(CUR_DIP.cognome,32,' ')||
                                   rpad(CUR_DIP.nome,18,' ')||
                                   CUR_DIP.data_nas||
                                   rpad(D_cn,24,' ')||
                                   D_pn||
                                   CUR_DIP.sesso||
                                   rpad( decode( CUR_DIP.cittadinanza
                                               , 'ITA', ' '
                                               , 'I'  , ' '
                                                      , CUR_DIP.cittadinanza
                                               )
                                       , 3,' ')||
                                   rpad(' ',3,' ')||
                                   rpad(' ',5,' ')||
                                   rpad(' ',2,' ')||
                                   substr(to_char(D_anno),3,2)||
                                   lpad(to_char(D_prog_rec),6,'0')||
                                   rpad(CUR_11.gest_inps,10,' ')||
                                   CUR_11.gest_zona
                                 )
                          ;
                          D_tot_22_az := D_tot_22_az + 1;
                          D_prog_rec  := D_prog_rec  + 1;
                          D_riga      := D_riga      + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values ( prenotazione
                                 , 1
                                 , D_pagina
                                 , D_riga
                                 , '22'||
                                   lpad(to_char(D_prog_ind),9,'0')||
                                   ' '||
                                   rpad(CUR_DIP.ir,40,' ')||
                                   D_cr||
                                   D_pr||
                                   lpad(CUR_DIP.cap_res,5,'0')||
                                   lpad(to_char(CUR_DIP.ni),10,'0')||
                                   rpad(' ',8,' ')||
                                   rpad(' ',5,' ')||
                                   rpad(' ',2,' ')||
                                   substr(to_char(D_anno),3,2)||
                                   lpad(to_char(D_prog_rec),6,'0')||
                                   rpad(CUR_11.gest_inps,10,' ')||
                                   CUR_11.gest_zona
                                 )
                          ;
                       ELSE
                         null;
                    END IF;
                    BEGIN
                      --
                      --  Estrazione Dati O1/M
                      --
                      FOR CUR_O1 IN
                         (select max(nvl(provincia,' '))          prov
                               , nvl(qualifica,' ')               qual
                               , nvl(assicurazioni,'0')             ass
                               , trunc( sum(nvl(importo_cc,0))
                                      /1000)                      imp_cc
                               , trunc( sum(nvl(importo_ac,0))
                                      /1000)                      imp_ac
                               , sum(nvl(settimane,0))            sett
                               , sum(nvl(giorni,0))               giorni
                               , max(decode(substr(mesi,1,1),'X','1','0'))||
                                 max(decode(substr(mesi,2,1),'X','1','0'))||
                                 max(decode(substr(mesi,3,1),'X','1','0'))||
                                 max(decode(substr(mesi,4,1),'X','1','0'))||
                                 max(decode(substr(mesi,5,1),'X','1','0'))||
                                 max(decode(substr(mesi,6,1),'X','1','0'))||
                                 max(decode(substr(mesi,7,1),'X','1','0'))||
                                 max(decode(substr(mesi,8,1),'X','1','0'))||
                                 max(decode(substr(mesi,9,1),'X','1','0'))||
                                 max(decode(substr(mesi,10,1),'X','1','0'))||
                                 max(decode(substr(mesi,11,1),'X','1','0'))||
                                 max(decode(substr(mesi,12,1),'X','1','0'))
                                                                   mesi
                               , max(nvl(contratto,' '))           contr
                               , max(decode( substr(contratto,4,1)
                                           , 'N', 'N'
                                           , 'R', 'R'
                                           , 'P', 'P'
                                           , 'A', 'A'
                                                , ' '))            tipo_contr
                               , max(nvl(livello,' '))             liv
                               , to_char(max(data_cessazione)
                                        ,'ddmm')                   data_ces
                               , trunc( sum(nvl(importo_ap,0))
                                      /1000)                       imp_ap
                               , trunc( sum(nvl(importo_af,0))
                                      /1000)                       imp_af
                               , nvl(tipo_rapporto,'0')              tipo_rapp
                               , nvl(trasf_rapporto,' ')           trasf_rapp
                               , sum(nvl(sett_utili,0))            sett_utili
                               , max(nvl(rd_148,' '))              rd_148
                               , max(tipo_c1)                      tipo_c1
                               , to_char(max(dal_c1),'ddmmyy')     dal_c1
                               , to_char(max(al_c1),'ddmmyy')      al_c1
                               , trunc( sum(nvl(importo_c1,0))
                                      /1000)                       imp_c1
                               , sum(sett_c1)                      sett_c1
                               , sum(gg_r_c1)                      gg_r_c1
                               , sum(gg_u_c1)                      gg_u_c1
                               , trunc( sum(nvl(importo_pen_c1,0))
                                      /1000)                       imp_p_c1
                               , sum(gg_nr_c1)                     gg_nr_c1
                               , max(tipo_c2)                      tipo_c2
                               , to_char(max(dal_c2),'ddmmyy')     dal_c2
                               , to_char(max(al_c2),'ddmmyy')      al_c2
                               , trunc( sum(nvl(importo_c2,0))
                                      /1000)                       imp_c2
                               , sum(sett_c2)                      sett_c2
                               , sum(gg_r_c2)                      gg_r_c2
                               , sum(gg_u_c2)                      gg_u_c2
                               , trunc( sum(nvl(importo_pen_c2,0))
                                      /1000)                       imp_p_c2
                               , sum(gg_nr_c2)                     gg_nr_c2
                               , max(tipo_c3)                      tipo_c3
                               , to_char(max(dal_c3),'ddmmyy')     dal_c3
                               , to_char(max(al_c3),'ddmmyy')      al_c3
                               , trunc( sum(nvl(importo_c3,0))
                                      /1000)                       imp_c3
                               , sum(sett_c3)                      sett_c3
                               , sum(gg_r_c3)                      gg_r_c3
                               , sum(gg_u_c3)                      gg_u_c3
                               , trunc( sum(nvl(importo_pen_c3,0))
                                      /1000)                       imp_p_c3
                               , sum(gg_nr_c3)                     gg_nr_c3
                               , max(tipo_c4)                      tipo_c4
                               , to_char(max(dal_c4),'ddmmyy')     dal_c4
                               , to_char(max(al_c4),'ddmmyy')      al_c4
                               , trunc( sum(nvl(importo_c4,0))
                                      /1000)                       imp_c4
                               , sum(sett_c4)                      sett_c4
                               , sum(gg_r_c4)                      gg_r_c4
                               , sum(gg_u_c4)                      gg_u_c4
                               , trunc( sum(nvl(importo_pen_c4,0))
                                      /1000)                       imp_p_c4
                               , sum(gg_nr_c4)                     gg_nr_c4
                               , sum(sett_d)                       sett_d
                               , trunc(sum(importo_rid_d)/1000)    imp_rid_d
                               , trunc(sum(importo_cig_d)/1000)    imp_cig_d
                               , sum(sett1_mal_d)                  s1_mal_d
                               , sum(sett2_mal_d)                  s2_mal_d
                               , sum(sett1_mat_d)                  s1_mat_d
                               , sum(sett2_mat_d)                  s2_mat_d
                               , sum(sett1_m88_d)                  s1_m88_d
                               , sum(sett2_m88_d)                  s2_m88_d
                               , sum(sett1_cig_d)                  s1_cig_d
                               , sum(sett2_cig_d)                  s2_cig_d
                               , sum(sett2_dds_d)                  s2_dds_d
                            from denuncia_o1_inps
                           where anno      = D_anno
                             and gestione in
                                (select codice from gestioni
                                  where posizione_inps = CUR_11.gest_inps
                                )
                             and ci in
                                (select ci from rapporti_individuali
                                  where ni = CUR_DIP.ni)
                           group by gestione,qualifica,assicurazioni
                                  , tipo_rapporto,trasf_rapporto
                         ) LOOP
                           BEGIN
                           --
                           --  Inserimento Record 41
                           --
                           D_prog_rec  := D_prog_rec  + 1;
                           D_riga      := D_riga      + 1;
                           D_tot_cc_az := D_tot_cc_az + CUR_O1.imp_cc;
                           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                           values ( prenotazione
                                  , 1
                                  , D_pagina
                                  , D_riga
                                  , '41'||
                                    rpad(nvl(CUR_DIP.inps
                                            ,lpad(to_char(D_prog_ind),9,'0')
                                            ),9,' ')||
                                    ' '||
                                    CUR_DIP.cf||
                                    rpad(CUR_O1.prov,2,' ')||
                                    CUR_O1.qual||
                                    lpad(CUR_O1.ass,2,'0')||
                                    lpad(to_char(CUR_O1.imp_cc),6,'0')||
                                    lpad(to_char(CUR_O1.sett),2,'0')||
                                    ' ' ||
                                    CUR_O1.mesi||
                                    rpad(CUR_O1.contr,3,' ')||
                                    CUR_O1.tipo_contr||
                                    rpad(CUR_O1.liv,4,' ')||
                                    nvl(CUR_O1.data_ces,'0000')||
                                    decode( CUR_O1.imp_ap
                                          , 0, rpad(nvl(CUR_O1.tipo_c1,' ')
                                                   ,2,' ')
                                             ,'AP')||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.dal_c1,'0')
                                                   ,6,'0')
                                             ,'000000')||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.al_c1,'0')
                                                   ,6,'0')
                                             ,'000000')||
                                    lpad( to_char(decode( CUR_O1.imp_ap
                                                        , 0 , CUR_O1.imp_c1
                                                            , CUR_O1.imp_ap))
                                        , 6, '0')||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(to_char
                                                     (nvl(CUR_O1.sett_c1,0))
                                                   ,2,'0')
                                             , '00')||
                                    lpad(to_char(CUR_DIP.ni),10,'0')||
                                    lpad(to_char(CUR_O1.giorni),3,'0')||
                                    rpad(' ',5,' ')||
                                    decode(to_char(CUR_O1.imp_af)
                                          ,'0','0','1')||
                                    to_char(D_tot_41_i)||
                                    substr(to_char(D_anno),3,2)||
                                    lpad(to_char(D_prog_rec),6,'0')||
                                    rpad(CUR_11.gest_inps,10,' ')||
                                    CUR_11.gest_zona
                                  )
                           ;
                           D_tot_41_i  := D_tot_41_i  + 1;
                           --
                           --  Totalizzazione per Record 61
                           --
                           D_tot_ac_az := D_tot_ac_az + CUR_O1.imp_ac;
                           D_tot_ap_az := D_tot_ap_az + CUR_O1.imp_ap;
                           D_tot_c1_az := D_tot_c1_az + CUR_O1.imp_c1;
                           D_tot_c2_az := D_tot_c2_az + CUR_O1.imp_c2;
                           D_tot_c3_az := D_tot_c3_az + CUR_O1.imp_c3;
                           D_tot_c4_az := D_tot_c4_az + CUR_O1.imp_c4;
                           --
                           --  Inserimento Record 42
                           --
                           D_prog_rec  := D_prog_rec  + 1;
                           D_riga      := D_riga      + 1;
                           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                           values ( prenotazione
                                  , 1
                                  , D_pagina
                                  , D_riga
                                  , '42'||
                                    rpad(nvl(CUR_DIP.inps
                                            ,lpad(to_char(D_prog_ind),9,'0')
                                            ),9,' ')||
                                    ' '||
                                    decode( CUR_O1.imp_ap
                                          , 0, rpad(nvl(CUR_O1.tipo_c2,' ')
                                                   ,2,' ')
                                             , rpad(nvl(CUR_O1.tipo_c1,' ')
                                                   ,2,' '))||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.dal_c2,'0')
                                                   ,6,'0')
                                             , lpad(nvl(CUR_O1.dal_c1,'0')
                                                   ,6,'0'))||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.al_c2,'0')
                                                   ,6,'0')
                                             , lpad(nvl(CUR_O1.al_c1,'0')
                                                   ,6,'0'))||
                                    lpad( to_char(decode( CUR_O1.imp_ap
                                                        , 0 , CUR_O1.imp_c2
                                                            , CUR_O1.imp_c1))
                                        , 6, '0')||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(to_char
                                                     (nvl(CUR_O1.sett_c2,0))
                                                   ,2,'0')
                                             , lpad(to_char
                                                     (nvl(CUR_O1.sett_c1,0))
                                                   ,2,'0'))||
                                    decode( CUR_O1.imp_ap
                                          , 0, rpad(nvl(CUR_O1.tipo_c3,' ')
                                                   ,2,' ')
                                             , rpad(nvl(CUR_O1.tipo_c2,' ')
                                                   ,2,' '))||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.dal_c3,'0')
                                                   ,6,'0')
                                             , lpad(nvl(CUR_O1.dal_c2,'0')
                                                   ,6,'0'))||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.al_c3,'0')
                                                   ,6,'0')
                                             , lpad(nvl(CUR_O1.al_c2,'0')
                                                   ,6,'0'))||
                                    lpad( to_char(decode( CUR_O1.imp_ap
                                                        , 0 , CUR_O1.imp_c3
                                                            , CUR_O1.imp_c2))
                                        , 6, '0')||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(to_char
                                                     (nvl(CUR_O1.sett_c3,0))
                                                   ,2,'0')
                                             , lpad(to_char
                                                     (nvl(CUR_O1.sett_c2,0))
                                                   ,2,'0'))||
                                    decode( CUR_O1.imp_ap
                                          , 0, rpad(nvl(CUR_O1.tipo_c4,' ')
                                                   ,2,' ')
                                             , rpad(nvl(CUR_O1.tipo_c3,' ')
                                                   ,2,' '))||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.dal_c4,'0')
                                                   ,6,'0')
                                             , lpad(nvl(CUR_O1.dal_c3,'0')
                                                   ,6,'0'))||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(nvl(CUR_O1.al_c4,'0')
                                                   ,6,'0')
                                             , lpad(nvl(CUR_O1.al_c3,'0')
                                                   ,6,'0'))||
                                    lpad( to_char(decode( CUR_O1.imp_ap
                                                        , 0 , CUR_O1.imp_c4
                                                            , CUR_O1.imp_c3))
                                        , 6, '0')||
                                    decode( CUR_O1.imp_ap
                                          , 0, lpad(to_char
                                                     (nvl(CUR_O1.sett_c4,0))
                                                   ,2,'0')
                                             , lpad(to_char
                                                     (nvl(CUR_O1.sett_c3,0))
                                                   ,2,'0'))||
                                    lpad(to_char(CUR_O1.imp_ac),6,'0')||
                                    rpad(' ',4,' ')||
                                    lpad(CUR_O1.tipo_rapp,2,'0')||
                                    decode(CUR_O1.trasf_rapp,'SI','1','0')||
                                    lpad(to_char(CUR_O1.sett_utili),2,'0')||
                                    rpad(CUR_O1.rd_148,2,' ')||
                                    rpad(' ',6,' ')||
                                    rpad(' ',5,' ')||
                                    ' '||
                                    to_char(D_tot_42_i)||
                                    substr(to_char(D_anno),3,2)||
                                    lpad(to_char(D_prog_rec),6,'0')||
                                    rpad(CUR_11.gest_inps,10,' ')||
                                    CUR_11.gest_zona
                                  )
                           ;
                           D_tot_42_i  := D_tot_42_i  + 1;
                           --
                           --  Inserimento Record 47
                           --
                           IF CUR_O1.tipo_c1||
                              CUR_O1.tipo_c2||
                              CUR_O1.tipo_c3||
                              CUR_O1.tipo_c4   is not null THEN
                           D_prog_rec  := D_prog_rec  + 1;
                           D_riga      := D_riga      + 1;
                           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                           values ( prenotazione
                                  , 1
                                  , D_pagina
                                  , D_riga
                                  , '47'||
                                    rpad(nvl(CUR_DIP.inps
                                            ,lpad(to_char(D_prog_ind),9,'0')
                                            ),9,' ')||
                                    ' 590'||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_r_c1,0))
                                              ,3,'0')
                                        , '000')||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_u_c1,0))
                                              ,3,'0')
                                        , '000')||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.imp_p_c1,0))
                                              ,6,'0')
                                        , '000000')||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_nr_c1,0))
                                              ,3,'0')
                                        , '000')||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_r_c2,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_r_c1,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_u_c2,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_u_c1,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.imp_p_c2,0))
                                              ,6,'0')
                                        , lpad(to_char(nvl(CUR_O1.imp_p_c1,0))
                                              ,6,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_nr_c2,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_nr_c1,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_r_c3,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_r_c2,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_u_c3,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_u_c2,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.imp_p_c3,0))
                                              ,6,'0')
                                        , lpad(to_char(nvl(CUR_O1.imp_p_c2,0))
                                              ,6,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_nr_c3,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_nr_c2,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_r_c4,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_r_c3,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_u_c4,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_u_c3,0))
                                              ,3,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.imp_p_c4,0))
                                              ,6,'0')
                                        , lpad(to_char(nvl(CUR_O1.imp_p_c3,0))
                                              ,6,'0'))||
                                    decode
                                     ( CUR_O1.imp_ap
                                     , 0, lpad(to_char(nvl(CUR_O1.gg_nr_c4,0))
                                              ,3,'0')
                                        , lpad(to_char(nvl(CUR_O1.gg_nr_c3,0))
                                              ,3,'0'))||
                                    rpad(' ',26,' ')||
                                    rpad(' ',5,' ')||
                                    ' '||
                                    to_char(D_tot_47_i)||
                                    substr(to_char(D_anno),3,2)||
                                    lpad(to_char(D_prog_rec),6,'0')||
                                    rpad(CUR_11.gest_inps,10,' ')||
                                    CUR_11.gest_zona
                                  )
                           ;
                           D_tot_47_i  := D_tot_47_i  + 1;
                           ELSE null;
                           END IF;
                           --
                           --  Inserimento Record 51
                           --
                           IF to_char(CUR_O1.sett_d)||
                              to_char(CUR_O1.imp_rid_d)||
                              to_char(CUR_O1.imp_cig_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)||
                              to_char(CUR_O1.s1_mal_d)    is not null
                           THEN
                           D_prog_rec  := D_prog_rec  + 1;
                           D_riga      := D_riga      + 1;
                           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                           values ( prenotazione
                                  , 1
                                  , D_pagina
                                  , D_riga
                                  , '51'||
                                    rpad(nvl(CUR_DIP.inps
                                            ,lpad(to_char(D_prog_ind),9,'0')
                                            ),9,' ')||
                                    ' 590'||
                                    lpad(to_char(nvl(CUR_O1.sett_d,0)),2,'0')||
                                    lpad( to_char(nvl(CUR_O1.imp_rid_d,0))
                                        , 6,'0')||
                                    lpad( to_char(nvl(CUR_O1.imp_cig_d,0))
                                        , 6,'0')||
                                    lpad( to_char(nvl(CUR_O1.s1_mal_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s2_mal_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s1_mat_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s2_mat_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s1_m88_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s2_m88_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s1_cig_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s2_cig_d,0))
                                        , 2,'0')||
                                    lpad( to_char(nvl(CUR_O1.s2_dds_d,0))
                                        , 2,'0')||
                                    rpad(' ',54,' ')||
                                    rpad(' ',5,' ')||
                                    ' '||
                                    to_char(D_tot_51_i)||
                                    substr(to_char(D_anno),3,2)||
                                    lpad(to_char(D_prog_rec),6,'0')||
                                    rpad(CUR_11.gest_inps,10,' ')||
                                    CUR_11.gest_zona
                                  )
                           ;
                           D_tot_51_i  := D_tot_51_i  + 1;
                           ELSE null;
                           END IF;
                           END;
                           END LOOP;
                      --
                      --  Aggiornamento Campi di Controllo (da pos. 102 a 105)
                      --  dei record individuali 21,22,41,42,47,51
                      --
                      update a_appoggio_stampe
                             set testo = substr(testo,1,101)||
                                         decode( CUR_DIP.inps
                                               , null, '1'
                                                     , '0')||
                                         to_char(D_tot_51_i)||
                                         to_char(D_tot_47_i)||
                                         to_char(D_tot_41_i)||
                                         to_char(D_tot_42_i)||
                                         substr(testo,107,22)
                       where no_prenotazione = prenotazione
                         and pagina          = D_pagina
                      ;
                      --
                      --  Totalizzazioni per Record 62
                      --
                      D_tot_41_az := D_tot_41_az + D_tot_41_i;
                      D_tot_42_az := D_tot_42_az + D_tot_42_i;
                      D_tot_47_az := D_tot_47_az + D_tot_47_i;
                      D_tot_51_az := D_tot_51_az + D_tot_51_i;
                    END;
                  END;
                END LOOP;
           --
           --  Inserimento Record 61 e 62
           --
           D_prog_rec  := D_prog_rec  + 1;
           D_riga      := D_riga      + 1;
           D_pagina    := D_pagina    + 1;
           D_tot_61    := D_tot_61    + 1;
           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           values ( prenotazione
                  , 1
                  , D_pagina
                  , D_riga
                  , '61'||
                    rpad(' ',10,' ')||
                    lpad(to_char(D_tot_cc_az),10,'0')||
                    lpad(to_char(D_tot_ac_az),10,'0')||
                    rpad(' ',10,' ')||
                    lpad(to_char(D_tot_ap_az),10,'0')||
                    lpad(to_char(D_tot_c1_az),10,'0')||
                    lpad(to_char(D_tot_c2_az),10,'0')||
                    lpad(to_char(D_tot_c3_az),10,'0')||
                    lpad(to_char(D_tot_c4_az),10,'0')||
                    rpad(' ',16,' ')||
                    substr(to_char(D_anno),3,2)||
                    lpad(to_char(D_prog_rec),6,'0')||
                    rpad(CUR_11.gest_inps,10,' ')||
                    CUR_11.gest_zona
                  )
           ;
           D_prog_rec  := D_prog_rec  + 1;
           D_riga      := D_riga      + 1;
           D_pagina    := D_pagina    + 1;
           D_tot_62    := D_tot_62    + 1;
           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           values ( prenotazione
                  , 1
                  , D_pagina
                  , D_riga
                  , '62'||
                    rpad(' ',10,' ')||
                    lpad(to_char(D_tot_dip_az),7,'0')||
                    lpad(to_char(D_tot_21_az),7,'0')||
                    lpad(to_char(D_tot_22_az),7,'0')||
                    lpad(to_char(D_tot_41_az),7,'0')||
                    lpad(to_char(D_tot_42_az),7,'0')||
                    lpad(to_char(D_tot_47_az),7,'0')||
                    lpad(to_char(D_tot_51_az),7,'0')||
                    rpad(' ',47,' ')||
                    substr(to_char(D_anno),3,2)||
                    lpad(to_char(D_prog_rec),6,'0')||
                    rpad(CUR_11.gest_inps,10,' ')||
                    CUR_11.gest_zona
                  )
           ;
           --
           --  Totalizzazioni per Record 91
           --
           D_tot_dip := D_tot_dip + D_tot_dip_az;
           D_tot_21  := D_tot_21  + D_tot_21_az;
           D_tot_22  := D_tot_22  + D_tot_22_az;
           D_tot_41  := D_tot_41  + D_tot_41_az;
           D_tot_42  := D_tot_42  + D_tot_42_az;
           D_tot_47  := D_tot_47  + D_tot_47_az;
           D_tot_51  := D_tot_51  + D_tot_51_az;
           END;
         END;
         END LOOP;
  --
  --  Inserimento Record 91
  --
  D_riga      := D_riga      + 1;
  D_pagina    := D_pagina    + 1;
  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
  values ( prenotazione
         , 1
         , D_pagina
         , D_riga
         , '91'||
           rpad(' ',10,' ')||
           lpad(to_char(D_tot_dip),7,'0')||
           lpad(D_tot_11,7,'0')||
           lpad(D_tot_11,7,'0')||
           lpad(to_char(D_tot_21),7,'0')||
           lpad(to_char(D_tot_22),7,'0')||
           lpad(to_char(D_tot_41),7,'0')||
           lpad(to_char(D_tot_42),7,'0')||
           lpad(to_char(D_tot_47),7,'0')||
           lpad(to_char(D_tot_51),7,'0')||
           lpad(to_char(D_tot_61),7,'0')||
           lpad(to_char(D_tot_62),7,'0')||
           rpad(' ',7,' ')||
           D_ced_sede||
           rpad(' ',28,' ')
         )
  ;
  END;
COMMIT;
EXCEPTION
WHEN NO_CED THEN
 null;
END;
END;
END;
/

