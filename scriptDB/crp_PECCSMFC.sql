CREATE OR REPLACE PACKAGE PECCSMFC IS
/******************************************************************************
 NOME:          crp_peccsmfc CREAZIONE SUPPORTO MAGNETICO 770/SC
 DESCRIZIONE:
      Questa fase produce un file secondo un tracciato concordato a livello
      aziendale per via dei limiti di ORACLE che permette di creare record
      di max 250 crt. Una ulteriore elaborazione adeguera' questi files al
      tracciato imposto dal Ministero delle Finanze.
      Il file prodotto si trovera' nella directory \\dislocazione\sta del report server con il nome
      PECCSMFC.txt .

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
      Creazione del flusso per la Denuncia Fiscale 770 / SF su
      supporto magnetico
      (nastri a bobina o dischetti - ASCII - lung. 4000 crt.).

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    28/06/2004 MS     Revisione 770/2004
 2.1  13/09/2004 MS     A7354 - modifiche alla casella 21
 2.2  15/09/2004 MS     A7382 - modifiche alla casella 21
 3    08/06/2005 GM     Revisione 770/2005
 3.1  29/07/2005 AM     Modificata la gestione dell'IRPEF agevolata per tratatre
                        anche i casi di passaggio a regime agevolato in corso d'anno
 4.0  22/03/2006 MS     Revisione 770/2006: gestione diversa delle somme
 4.1  01/06/2006 MS     sistemazione arrotondamenti
 4.2  01/06/2006 MS     Adeguamento 770/2006: aggiunta casella
 4.3  26/09/2006 MS     Sistemazione residenti all'estero (17833)
 5.0  28/03/2007 MS     Adeguamento 770/2007 e lettura da archivio ( att. 19919 e 20358 )
 5.1  03/08/2007 MS     Correzione nvl su erede e data nascita
 5.2  13/09/2007 MS/CB  A22783
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCSMFC IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V5.2 del 13/09/2007';
   END VERSIONE;

 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
 DECLARE
  D_ente            VARCHAR2(4);
  D_ambiente        VARCHAR2(8);
  D_utente          VARCHAR2(8);
--
-- Depositi e Contatori Vari
--
  D_r1              varchar2(20);
  D_filtro_1        varchar2(15);
  D_filtro_2        varchar2(15);
  D_filtro_3        varchar2(15);
  D_filtro_4        varchar2(15);
  D_pagina          number;
  D_riga            number;
  D_modulo          number := 0;
  D_num_ord         number;
  D_decimali        varchar2(1);

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
  D_cod_fis         varchar2(16);
  D_dep_cod_fis     varchar2(16);

  D_erede           varchar2(1);
  D_cod_evento      varchar2(1);
  D_lordo           varchar2(11);
  D_no_sogg_rc      varchar2(11);
  D_no_sogg         varchar2(11);
  D_ipn_ord         varchar2(11);
  D_ipt_acconto     varchar2(11);
  D_rit_imposta     varchar2(11);
  D_ipt_sosp        varchar2(11);
  D_con_pre_dat     varchar2(11);
  D_con_pre_lav     varchar2(11);
  D_spese_rimb      varchar2(11);
  D_rit_rimb        varchar2(11);

--
-- Variabili di Anagrafe
--
  A_cognome         varchar2(40);
  A_nome            varchar2(36);
  A_cod_fis         varchar2(16);
  A_data_nas        varchar2(8);
  A_sesso           varchar2(1);
  A_com_nas         varchar2(40);
  A_prov_nas        varchar2(2);
  A_com_res         varchar2(40);
  A_prov_res        varchar2(2);
  A_ind_res         varchar2(40);
  A_nr              varchar2(1);
  A_com_res_e       varchar2(40);
  A_cse             varchar2(3);
  A_cfe             varchar2(20);
  A_prov_res_e      varchar2(5);
  A_ind_res_e       varchar2(40);


BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
  BEGIN
    select substr(valore,1,4)
         , to_date('01'||substr(valore,1,4),'mmyyyy')
         , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
      into D_anno,D_ini_a,D_fin_a
      from a_parametri
     where no_prenotazione = PRENOTAZIONE
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      select anno
           , to_date('01'||to_char(anno),'mmyyyy')
           , to_date('3112'||to_char(anno),'ddmmyyyy')
        into D_anno,D_ini_a,D_fin_a
        from riferimento_fine_anno
       where rifa_id = 'RIFA'
      ;
  END;
  BEGIN
    select substr(valore,1,15)
      into D_filtro_1
      from a_parametri
     where no_prenotazione = PRENOTAZIONE
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
     where no_prenotazione = PRENOTAZIONE
       and parametro       = 'P_FILTRO_2'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_filtro_3:= '%';
  END;
  BEGIN
    select substr(valore,1,15)
      into D_filtro_3
      from a_parametri
     where no_prenotazione = PRENOTAZIONE
       and parametro       = 'P_FILTRO_3'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_filtro_3:= '%';
  END;
  BEGIN
    select substr(valore,1,15)
      into D_filtro_4
      from a_parametri
     where no_prenotazione = PRENOTAZIONE
       and parametro       = 'P_FILTRO_4'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_filtro_4:= '%';
  END;
  BEGIN
    select rpad(ltrim(substr(valore,1,16)),16,' ')
      into D_cod_fis_dic
      from a_parametri
     where no_prenotazione = PRENOTAZIONE
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
    D_modulo        := 0;
    D_pagina        := 0;
    D_riga          := 0;

    FOR CUR_RPFA IN
      (select distinct
              rpad(nvl( D_cod_fis
                      , ltrim(nvl( gest.codice_fiscale
                                  ,gest.partita_iva))),16)   ente_cf
            , rpfa.ci                                        ci
            , rain.cognome
            , rain.nome
            , rpfa.c1      c1
            , rain.ni      ni
            , rpfa.c5      c5
            , rpfa.c6      c6
            , defa.causale  causale
         from gestioni                gest
            , rapporti_individuali    rain
            , report_fine_anno        rpfa
            , classi_rapporto         clra
            , denuncia_fiscale_autonomi defa
        where gest.codice (+)   = rpfa.c1
-- and rain.ci = 1771
          and rpfa.anno         = D_anno
          and nvl(rpfa.c1,' ')  like D_filtro_1
          and nvl(rpfa.c2,' ')  like D_filtro_2
          and nvl(rpfa.c3,' ')  like D_filtro_3
          and nvl(rpfa.c4,' ')  like D_filtro_4
          and rain.ci           = rpfa.ci
          and rain.ci           = defa.ci
          and defa.anno         = D_anno
          and clra.codice = rain.rapporto
          and clra.cat_fiscale in ('3','4')
          and (   rain.cc is null
                  or exists
                    (select 'x'
                       from a_competenze
                      where ente        = D_ente
                        and ambiente    = D_ambiente
                        and utente      = D_utente
                        and competenza  = 'CI'
                        and oggetto     = rain.cc
                    )
                 )
          and exists
             (select 'x'
                from denuncia_fiscale_autonomi defa
               where defa.anno = D_anno
                 and defa.ci   = rpfa.ci
               group by defa.ci
              having  nvl(sum(defa.lordo),0) != 0
             )
        order by 1,3,4,7,8
     ) LOOP
-- dbms_output.put_line('CI: '||CUR_RPFA.ci);
        BEGIN
          select upper(anag.cognome)                            cognome
               , nvl(upper(anag.nome),' ')                      nome
               , rpad(anag.codice_fiscale,16,' ')               cod_fis
               , substr(to_char(anag.data_nas,'ddmmyyyy'),1,8)  data_nas
               , anag.sesso                                     sesso
               , upper(comu_n.denominazione)                    com_nas
               , substr( decode( sign(199-prov_n.provincia)
                               , -1, '  '
                                   , nvl(prov_n.sigla,' '))
                       ,1,2)                                    prov_nas
               , decode( sign(199-comu_r.cod_provincia)
                       , -1, ' '
                           , upper(comu_r.descrizione))         com_res
               , substr( decode( sign(199-comu_r.cod_provincia)
                               , -1, '  '
                                   , comu_r.sigla_provincia)
                       ,1,2)                                    prov_res
               , decode( sign(199-comu_r.cod_provincia)
                       , -1, ' '
                       , upper(anag.indirizzo_res))             ind_res
               , decode( sign(199-comu_r.cod_provincia)
                       , -1, '1'
                           , '0')                               nr
               , decode( sign(199-comu_r.cod_provincia)
                    , -1, upper(comu_r.descrizione)
                           , ' ')                               com_res_e
               , nvl(cses.codice,'000')                         cse
               , substr(anag.codice_fiscale_estero,1,16)        cfe
               , substr( decode( sign(199-comu_r.cod_provincia)
                               , -1, comu_r.sigla_provincia
                                   , '  ')
                       ,1,2)                                    prov_res_e
               , decode( sign(199-comu_r.cod_provincia)
                       , -1, upper(anag.indirizzo_res)
                       , ' ')                                   ind_res_e
            into A_cognome,A_nome,A_cod_fis,A_data_nas,A_sesso,A_com_nas
               , A_prov_nas,A_com_res,A_prov_res,A_ind_res
               , A_nr,A_com_res_e,A_cse,A_cfe, A_prov_res_e, A_ind_res_e
            from a_comuni                comu_n
               , a_provincie             prov_n
               , comuni                  comu_r
               , rapporti_individuali    rain
               , anagrafici              anag
               , categoria_stati_esteri  cses
           where anag.ni           = rain.ni
             and anag.al          is null
             and rain.ci           = CUR_RPFA.ci
             and comu_n.comune          (+) = anag.comune_nas
             and comu_n.provincia_stato (+) = anag.provincia_nas
             and prov_n.provincia       (+) = anag.provincia_nas
             and comu_r.cod_comune (+) = decode( sign(199-anag.provincia_res)
                                                , -1, 0
                                                    , anag.comune_res)
             and comu_r.cod_provincia (+) = anag.provincia_res
             and cses.provincia_stato (+) = anag.provincia_res
          ;
        END;

    BEGIN
    
    D_pagina        := D_pagina   + 1;
    D_num_ord       := D_num_ord  + 1;
    D_ente_cf       := CUR_RPFA.ente_cf;
    D_modulo        := D_modulo + 1;

       BEGIN
       <<DATI_FISCALI>>
           BEGIN
            select decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.lordo,0) ),2)*100
                                     , trunc( sum( nvl(defa.lordo,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.no_sogg_rc,0) ),2)*100
                                     , trunc( sum( nvl(defa.no_sogg_rc,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.no_sogg,0) ),2)*100
                                     , trunc( sum( nvl(defa.no_sogg,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.imponibile,0) ),2)*100
                                     , trunc( sum( nvl(defa.imponibile,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.rit_acconto,0) ),2)*100
                                     , trunc( sum( nvl(defa.rit_acconto,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.rit_imposta,0) ),2)*100
                                     , trunc( sum( nvl(defa.rit_imposta,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.rit_sospese,0) ),2)*100
                                     , trunc( sum( nvl(defa.rit_sospese,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.prev_erogante,0) ),2)*100
                                     , trunc( sum( nvl(defa.prev_erogante,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.prev_lavoratore,0) ),2)*100
                                     , trunc( sum( nvl(defa.prev_lavoratore,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.spese_rimb,0) ),2)*100
                                     , trunc( sum( nvl(defa.spese_rimb,0) ),0)
                          )
                 , decode(D_decimali
                                 ,'X', trunc( sum( nvl(defa.rit_rimb,0) ),2)*100
                                     , trunc( sum( nvl(defa.rit_rimb,0) ),0)
                          )
              into D_lordo
                 , D_no_sogg_rc
                 , D_no_sogg
                 , D_ipn_ord
                 , D_ipt_acconto
                 , D_rit_imposta
                 , D_ipt_sosp
                 , D_con_pre_dat
                 , D_con_pre_lav
                 , D_spese_rimb
                 , D_rit_rimb
              from DENUNCIA_FISCALE_AUTONOMI defa
             where defa.anno         = D_anno
               and defa.ci = CUR_RPFA.ci
            ;
           EXCEPTION WHEN NO_DATA_FOUND THEN
                  D_lordo         := null;
                  D_no_sogg_rc    := null;
                  D_no_sogg       := null;
                  D_ipn_ord       := null;
                  D_ipt_acconto   := null;
                  D_rit_imposta   := null;
                  D_ipt_sosp      := null;
                  D_con_pre_dat   := null;
                  D_con_pre_lav   := null;
                  D_spese_rimb    := null;
                  D_rit_rimb      := null;
           END;
       END DATI_FISCALI;

       BEGIN
         select max(erede), max(cod_evento_eccezionale)
           into D_erede, D_cod_evento
           from DENUNCIA_FISCALE_AUTONOMI defa
          where defa.anno   = D_anno
            and defa.ci     = CUR_RPFA.ci;
       EXCEPTION WHEN NO_DATA_FOUND THEN
          D_erede := 0;
          D_cod_evento := '';
       END;
    END;
        --
        --  Inserimento Primo Record -- testata quadro
        --
           D_riga    := 10;
           D_num_ord := 1;
           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           values ( prenotazione
                  , 1
                  , D_pagina
                  , D_riga
                  , 'H'||
                    rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),16,' ')||
                    lpad(to_char(D_modulo),8,'0')||
                    lpad(' ',4,' ')||
                    rpad(nvl(A_cod_fis,' '),16,' ')||
                    lpad(' ',44,' ')||
                    'AU001001'||
                    rpad(decode(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                               , nvl(CUR_RPFA.ente_cf,' '), ' '
                                                          , nvl(CUR_RPFA.ente_cf,' '))
                        ,16,' ')||
                    '}'
                  )
           ;
           D_pagina := D_pagina + 1;
           D_riga   := 0;
        --
        --  Inserimento Primo Record Dipendente
        --
        D_riga   := D_riga   + 1;
        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
        values ( PRENOTAZIONE
               , 1
               , D_pagina
               , 0
               , lpad(to_char(CUR_RPFA.ci),8,'0')||
                 lpad(to_char(D_modulo),8,'0')||
                 lpad(to_char(D_num_ord),2,'0')
               )
        ;
        D_riga   := D_riga   + 1;
        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
        values ( PRENOTAZIONE
               , 1
               , D_pagina
               , D_riga
               , 'H'||
                 rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf),16,' ')||
                 lpad(to_char(D_modulo),8,'0')||
                 lpad(' ',4,' ')||
                 rpad(nvl(A_cod_fis,' '),16,' ')||
                 lpad(' ',44,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'001'||
                 rpad(nvl(A_cod_fis,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'002'||
                 rpad(nvl(substr(A_cognome,1,16),' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'002'||
                 decode( greatest(16,length(A_cognome))
                       , 16, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_cognome,17,15),' ')
                                      ,15,' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'002'||
                 decode( greatest(31,length(A_cognome))
                       , 31, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_cognome,32),' ')
                                      ,'15',' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'003'||
                 rpad(nvl(substr(A_nome,1,16),' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'003'||
                 decode( greatest(16,length(nvl(A_nome,' ')))
                       , 16, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_nome,17,15),' ')
                                      ,15,' ')
                       )||
                 '{'
               )
        ;
        --
        --  Inserimento Secondo Record Dipendente
        --
        D_riga   := D_riga   + 1;
        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
        values ( PRENOTAZIONE
               , 1
               , D_pagina
               , D_riga
               , 'AU'||lpad(to_char(D_num_ord),3,'0')||'003'||
                 decode( greatest(31,length(nvl(A_nome,' ')))
                       , 31, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_nome,32),' ')
                                      ,'15',' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'004'||
                 rpad(nvl(A_sesso,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'005'||
                 lpad(nvl(A_data_nas,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'006'||
                 rpad(nvl(substr(A_com_nas,1,16),' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'006'||
                 decode( greatest(16,length(nvl(A_com_nas,' ')))
                       , 16, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_com_nas,17,15),' ')
                                      ,15,' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'006'||
                 decode( greatest(31,length(nvl(A_com_nas,' ')))
                       , 31, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_com_nas,32),' ')
                                      ,'15',' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'007'||
                 rpad(nvl(A_prov_nas,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'008'||
                 rpad(nvl(substr(A_com_res,1,16),' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'008'||
                 decode( greatest(16,length(A_com_res))
                       , 16, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_com_res,17,15),' ')
                                      ,15,' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'008'||
                 decode( greatest(31,length(A_com_res))
                       , 31, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_com_res,32),' ')
                                      ,'15',' ')
                       )||
                 '{'
               )
        ;
        --
        --  Inserimento Terzo Record Dipendente
        --
        D_riga   := D_riga   + 1;
        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
        values ( PRENOTAZIONE
               , 1
               , D_pagina
               , D_riga
               , 'AU'||lpad(to_char(D_num_ord),3,'0')||'009'||
                 rpad(nvl(A_prov_res,' '),16,' ')||
                         'AU'||lpad(to_char(D_num_ord),3,'0')||'010'||-- codice regione NON GESTITO
                 lpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'011'||-- via e numero civico
                 rpad(nvl(substr(A_ind_res,1,16),' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'011'||
                 decode( greatest(16,length(A_ind_res))
                          , 16, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_ind_res,17,15),' ')
                                      ,15,' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'011'||
                 decode( greatest(31,length(A_ind_res))
                       , 31, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_ind_res,32),' ')
                                      ,'15',' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'012'|| -- erede
                 lpad(nvl(decode(D_erede,'1','1',''),' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'013'|| -- evento eccezionale
                 rpad(nvl(D_cod_evento,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'014'|| -- codice identificazioen stato estero
                 rpad(nvl(A_cfe,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'015'|| -- provincia estera di residenza
                 rpad(nvl(A_prov_res_e,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'016'|| -- via e numero civico estero
                 rpad(nvl(substr(A_ind_res_e,1,16),' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'016'||
                 decode( greatest(16,length(A_ind_res_e))
                          , 16, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_ind_res_e,17,15),' ')
                                      ,15,' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'016'||
                 decode( greatest(31,length(A_ind_res_e))
                       , 31, rpad(' ',16,' ')
                           , '+'||rpad(nvl(substr(A_ind_res_e,32),' ')
                                      ,'15',' ')
                       )||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'017'|| -- cod stato estero
                 decode(A_cfe,null, lpad(' ',16,' '),lpad(nvl(A_cse,'0'),16,' '))||
                 '{'
               )
        ;
        --
        --  Inserimento Quarto Quinto Sesto e Settimo Records dip.
        --

        D_riga := D_riga + 1;

        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
        values ( PRENOTAZIONE
               , 1
               , D_pagina
               , D_riga
               , 'AU'||lpad(to_char(D_num_ord),3,'0')||'018'|| -- causale
                 rpad(nvl(CUR_RPFA.causale,' '),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'019'|| -- anno NON GESTITA
                 rpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'020'|| -- anticipazione NON GESTITA
                 rpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'021'|| -- ammontare lordo corrisposto
                 lpad(nvl(D_lordo,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'022'|| -- somme soggette a ritenuta per regime convenzionale
                 lpad(nvl(D_no_sogg_rc,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'023'|| -- altre somme non soggette a ritenute
                 lpad( nvl(D_no_sogg,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'024'|| -- imponibile
                 lpad(nvl(D_ipn_ord,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'025'|| -- ritenute a titolo d'acconto
                 lpad(nvl(D_ipt_acconto,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'026'|| -- ritenute a titolo d'imposta
                 lpad(nvl(D_rit_imposta,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'027'|| -- ritenute sospese
                 lpad(nvl(D_ipt_sosp,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'028'|| -- addizionale regionale a titolo d'acconto NON GESTITA
                 lpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'029'|| -- addizionale regionale a titolo d'imposta NON GESTITA
                 lpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'030'|| -- addizionale regionale sospesa NON GESTITA
                 lpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'031'|| -- imponibile ap NON GESTITA
                 lpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'032'|| -- imposta ap NON GESTITA
                 lpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'033'|| -- contributi a carico del datore di lavoro
                 lpad(nvl(D_con_pre_dat,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'034'|| -- contributi a carico del lavoratore
                 lpad(nvl(D_con_pre_lav,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'035'|| -- spese rimborsate
                 lpad(nvl(D_spese_rimb,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'036'|| -- ritenute rimborsate
                 lpad(nvl(D_rit_rimb,'0'),16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'037'|| -- sommme corrisposte prima della data del fallimento  NON GESTITA
                 lpad(' ',16,' ')||
                 'AU'||lpad(to_char(D_num_ord),3,'0')||'038'|| -- sommme corrisposte dal curatore / commissario NON GESTITA
                 lpad(' ',16,' ')||
                 '{'
               )
        ;
        D_riga := D_riga +2;
        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
        values ( PRENOTAZIONE
               , 1
               , D_pagina
               , D_riga
               ,'}'
               )
        ;
        D_riga := 0;
        D_dep_cod_fis := D_cod_fis;
     commit;
    END LOOP; -- cur_rpfa
   END;
END;
END;
END;
/
