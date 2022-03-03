/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECCSMUR IS
/******************************************************************************
 NOME:        PECCSMUR
 DESCRIZIONE: Creazione del flusso di passaggio dei dati economici e della carriera
              alla procedura URSUS (ASCII - Lung. variabile).
              Questa fase produce un file secondo i tracciati imposti dalla Direzione
              dell' INPS.
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: La gestione che deve risultare come intestataria della denuncia
              deve essere stata inserita in << DGEST >> in modo tale che la
              ragione sociale (campo nome) risulti essere la minore di tutte
              le altre eventualmente inserite.
              Lo stesso risultato si raggiunge anche inserendo un BLANK prima
              del nome di tutte le gestioni che devono essere escluse.

              Il PARAMETRO D_ambiente indica l'ambiente richiedente.
              Il PARAMETRO D_ente indica l'ente richiedente.
              Il PARAMETRO D_utente indica l'utente richiedente.
              Il PARAMETRO D_ci contiene il codice individuale per l'elabo-
              razione di un solo dipendente.
              Il PARAMETRO D_rapporto indica quale tipo di dipendenti elaborare in
              caso di elaborazione collettiva.
              Il PARAMETRO D_r_al indica la valida` del rapporto.
              Il PARAMETRO D_filtro_1 indica i dipendenti da elaborare.
              Il PARAMETRO D_filtro_2 indica i dipendenti da elaborare.
              Il PARAMETRO D_filtro_3 indica i dipendenti da elaborare.
              Il PARAMETRO D_filtro_4 indica i dipendenti da elaborare.
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

CREATE OR REPLACE PACKAGE BODY PECCSMUR IS
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
  D_ambiente  varchar2(8);
  D_ente      varchar2(4);
  D_utente    varchar2(8);
  D_ci        number;
  D_rapporto  varchar2(4);
  D_r_al      date;
  D_filtro_1  varchar2(15);
  D_filtro_2  varchar2(15);
  D_filtro_3  varchar2(15);
  D_filtro_4  varchar2(15);
--
--  Variabili anagrafiche
--
  D_ni        number;
  D_assunz    date;
  D_cessaz    date;
  D_interrupt varchar2(1);
  D_ult_ente  varchar2(30);
  A_cognome   varchar2(30);
  A_nascita   varchar2(8);
  A_luogo     varchar2(20);
  A_sesso     varchar2(1);
  A_via       varchar2(30);
  A_citta     varchar2(30);
  A_cf        varchar2(16);
  A_telefono  varchar2(12);
  A_qualif    varchar2(22);
  A_posiz     varchar2(9);
  A_meccan    varchar2(9);
  A_motivo    varchar2(1);
  A_cassa     varchar2(8);
--
--  Variabili fiscali
--
  A_det_fn    varchar2(1);
  A_assegni   varchar2(1);
  A_det_con   number;
  A_det_fg    number;
  A_det_alt   number;
  A_det_ult   number;
--
--  Variabili fiscali
--
  SOV_decr         varchar2(8);
  SOV_del          varchar2(8);
  SOV_mese         number;
  SOV_resid        number;
  SOV_quote        number;
  SOV_fine         varchar2(8);
  SOV_cassa        varchar2(15);
  SOV_estinzione   number;
  SOV_voce         varchar2(10);
  SOV_sub          varchar2(2);
  SOV_imp_tot      number;
  SOV_rate_tot     number;
  D_maturato       number;
  D_assegno_a      number;
  D_assegno_b      number;
  D_assegno_c      number;
  D_r_paga         varchar2(8);
  D_r_spec         varchar2(8);
  D_r_tp           varchar2(8);
--
--  Inadel
--
  I_data           varchar2(8);
  I_cat            number;
  I_qual           number;
--
--  Definizione Exception
--
  NO_CED EXCEPTION;
BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
  BEGIN
      select ente
           , utente
           , ambiente
        into D_ente,D_utente,D_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
  END;
  BEGIN
    select substr(valore,1,8)
      into D_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_ci := null;
  END;
  BEGIN
    select substr(valore,1,4)
      into D_rapporto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_RAPPORTO'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_rapporto := '%';
  END;
  BEGIN
    select substr(valore,1,9)
      into D_r_al
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_R_AL'
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_r_al := null;
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
  --
  --  Loop per inserimento records 11 e 12 (Gestioni)
  --
  BEGIN
    D_pagina := 0;
    FOR CUR_CI IN
       (select rpcp.ci
          from report_riepilogo_cp rpcp
         where rpcp.ci = nvl(D_ci,rpcp.ci)
           and nvl(rpcp.c1,' ') like nvl(D_filtro_1,'%')
           and nvl(rpcp.c2,' ') like nvl(D_filtro_2,'%')
           and nvl(rpcp.c3,' ') like nvl(D_filtro_3,'%')
           and nvl(rpcp.c4,' ') like nvl(D_filtro_4,'%')
           and exists
              (select 'x' from rapporti_individuali rain
                             , riferimento_retribuzione rire
                where rire.rire_id   = 'RIRE'
                  and rain.ci        = rpcp.ci
                  and rain.rapporto in (select codice
                                          from classi_rapporto
                                         where codice like D_rapporto
                                           and retributivo = 'SI')
                  and nvl(D_r_al,rire.fin_ela)
                          between rain.dal
                              and nvl(rain.al,to_date('3333333','j'))
                  and (    rain.cc is null
                        or exists (select 'x'
                                     from a_competenze
                                    where ente        = D_ente
                                      and ambiente    = D_ambiente
                                      and utente      = D_utente
                                      and competenza  = 'CI'
                                      and oggetto     = rain.cc))
               )
       ) LOOP
         D_pagina := D_pagina + 1;
         D_riga   := 0;
         BEGIN -- Estrazione Dati Anagrafici
           select rpad(substr(anag.cognome||' '||anag.nome
                             ,1,30),30,' ')                       A_cognome
                , to_char(anag.data_nas,'ddmmyyy')                A_nascita
                , rpad( substr(comu_n.denominazione,1,15)||
                        ' ('||prov_n.sigla||')'
                      , 20,' ')                                  A_luogo
                , anag.sesso                                     A_sesso
                , rpad(substr(anag.indirizzo_res,1,30),30,' ')   A_via
                , rpad( substr(comu_r.denominazione,1,25)||
                        ' ('||prov_r.sigla||')'
                      , 30,' ')                                  A_citta
                , anag.codice_fiscale                            A_cf
                , rpad(nvl(anag.tel_res,' '),12,' ')             A_telefono
                , anag.ni                                        D_ni
             into A_cognome,A_nascita,A_luogo,A_sesso,A_via
                , A_citta,A_cf,A_telefono,D_ni
             from a_comuni      comu_n
                , a_provincie   prov_n
                , a_comuni      comu_r
                , a_provincie   prov_r
                , anagrafici  anag
            where anag.ni   = (select max(ni) from rapporti_individuali
                                where ci = CUR_CI.ci)
              and anag.al                   is null
              and comu_n.comune    (+)       = anag.comune_nas
              and comu_n.provincia_stato (+) = anag.provincia_nas
              and prov_n.provincia (+)       = anag.provincia_nas
              and comu_r.comune    (+)       = anag.comune_res
              and comu_r.provincia_stato (+) = anag.provincia_res
              and prov_r.provincia (+)       = anag.provincia_res
          ;
         END;
         BEGIN -- Estrazione Dati Qualifica
           select rpad(substr(qugi.descrizione,1,22),22,' ')       A_qualif
                , substr(rpad(qual.cat_inadel,2,' '),1,1) I_cat
             into A_qualif,I_cat
             from qualifiche_giuridiche qugi
                , qualifiche            qual
                , periodi_giuridici     pegi
            where pegi.ci        = D_ci
              and pegi.rilevanza = 'S'
              and pegi.dal       = (select max(dal) from periodi_giuridici
                                     where rilevanza = 'S'
                                       and ci        = pegi.ci)
              and qugi.numero (+)= pegi.qualifica
              and nvl(pegi.al,to_date('3333333','j'))
                  between nvl(qugi.dal,to_date('2222222','j'))
                      and nvl(qugi.al,to_date('3333333','j'))
              and qual.numero (+)= pegi.qualifica
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                A_qualif := ' ';
         END;
         BEGIN -- Estrazione Ruolo
           select decode(posi.di_ruolo,'R','1','0')
             into I_qual
             from posizioni posi
            where posi.codice = (select substr(max(dal||posizione),9)
                                   from periodi_giuridici
                                  where ci = D_ci
                                    and rilevanza in ('Q','I'))
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                I_qual := '0';
         END;
         BEGIN -- Estrazione Data Assunzione
           select min(pegi.dal)
             into D_assunz
             from periodi_giuridici pegi
            where pegi.ci        = D_ci
              and pegi.rilevanza = 'P'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                D_assunz := null;
         END;
         BEGIN -- Estrazione Dati Cessazione
           select evra.cod_previdenza , pegi.al
             into A_motivo , D_cessaz
             from eventi_rapporto   evra
                , periodi_giuridici pegi
            where pegi.ci        = D_ci
              and evra.codice    = pegi.posizione
              and evra.rilevanza = 'T'
              and pegi.rilevanza = 'P'
              and pegi.dal       =
                 (select max(dal) from periodi_giuridici
                   where ci        = D_ci
                     and rilevanza = 'P')
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                A_motivo := '0';
                D_cessaz := null;
         END;
         BEGIN -- Estrazione Dati Previdenza
           select rpad(decode( trpr.previdenza
                             , 'CPDEL', rare.posizione_cpd
                                      , rare.posizione_cps)
                      ,9,' ')                                A_posiz
                , rpad(decode( trpr.previdenza
                             , 'CPDEL', rare.codice_cpd
                                      , rare.codice_cps)
                      ,9,' ')                                A_meccan
                , rpad(trpr.previdenza,8,' ')                A_cassa
                , to_char(rare.data_iad,'ddmmyyyy')
             into A_posiz,A_meccan,A_cassa,I_data
             from trattamenti_previdenziali trpr
                , rapporti_retributivi      rare
            where rare.ci         = D_ci
              and trpr.codice (+) = rare.trattamento
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                A_posiz := ' ';
                A_cassa := ' ';
         END;
         BEGIN -- Estrazione Dati Carichi Familiari
           select decode( length(to_char(figli))
                        , '1', to_char(figli)
                             , substr(to_char(figli),1,1)
                        )
                , decode( to_char(nvl(nucleo_fam,0))
                        , '0', 'N', 'S')
             into A_det_fn,A_assegni
             from carichi_familiari
            where ci          = D_ci
              and (anno,mese) = (select max(anno),max(mese)
                                   from periodi_retributivi
                                  where ci = D_ci)
           ;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   A_det_fn  := '0';
                   A_assegni := 'N';
         END;
         BEGIN -- Inserimento Record 1 prima parte  (C_URS.dbf)
         lock table a_appoggio_stampe in exclusive mode nowait;
         D_riga := D_riga + 1;
         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
         values ( prenotazione
                , 1
                , D_pagina
                , D_riga
                , A_cognome||
                  A_nascita||
                  A_luogo||
                  A_sesso||
                  A_via||
                  A_citta||
                  A_cf||
                  rpad(A_qualif,22,' ')||
                  rpad(nvl(A_posiz,' '),9,' ')||
                  nvl(A_motivo,'0')||
                  '0'||
                  '0'||
                  '00'||
                  rpad(A_cassa,8,' ')||
                  rpad(nvl(A_telefono,' '),12,' ')||
                  nvl(A_det_fn,'0')||
                  nvl(A_assegni,'N')||
                  rpad(' ',135,' ')||
                  '00000000'||
                  rpad(' ',49,' ')||
                  '00000000'||
                  rpad(nvl(A_meccan,' '),9,' ')
                );
         END;
         BEGIN -- Inserimento Record 1 prima parte  (C_INA1.dbf)
         lock table a_appoggio_stampe in exclusive mode nowait;
         D_pagina := D_pagina + 1;
         D_riga := D_riga + 1;
         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
         values ( prenotazione
                , 17
                , D_pagina
                , D_riga
                , '00'||
                  nvl(I_data,'00000000')||
                  I_cat||
                  I_qual||
                  '0'||
                  '0'||
                  '0'||
                  '00000000'||
                  '00000000'||
                  '        '||
                  '00000000'||
                  '        '||
                  '00000000'||
                  '        '||
                  '00000000'||
                  '        '||
                  lpad(' ',119,' ')||
                  '00000000'||
                  '        '||
                  '00000000'||
                  '        '||
                  lpad(' ',119,' ')||
                  lpad(' ',31,' ')||
                  '00000000'||
                  lpad('0',13,'0')||
                  lpad(' ',10,' ')||
                  '00000000'||
                  lpad('0',13,'0')||
                  rpad(nvl(A_meccan,' '),9,' ')
                );
         END;
         BEGIN
           FOR CUR_FAM IN
              (select rpad(substr(fami.cognome||' '||fami.nome
                                 ,1,30),30,' ')                       cognome
                    , to_char(fami.data_nas,'ddmmyyy')                nascita
                    , fami.codice_fiscale                             cf
                    , pare.cod_previdenza                             rapporto
                 from familiari fami
                    , parentele pare
                where fami.ni        = D_ni
                  and fami.relazione = pare.sequenza
              ) LOOP
                BEGIN -- Inserimento Record 2   (C_ANAG.dbf)
                lock table a_appoggio_stampe in exclusive mode nowait;
                D_riga := D_riga + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 3
                       , D_pagina
                       , D_riga
                       , rpad(nvl(CUR_FAM.cognome,' '),30,' ')||
                         rpad(nvl(CUR_FAM.nascita,'0'),8,'0')||
                         rpad(' ',20,' ')||
                         nvl(CUR_FAM.rapporto,'0')||
                         rpad(nvl(CUR_FAM.cf,' '),16,' ')||
                         rpad(nvl(A_meccan,' '),9,' ')
                       );
                END;
                END LOOP;
         BEGIN -- Estrazione Dati Fiscali
           select nvl(sum(prfi.det_con),0)         A_det_con
                , nvl(sum(prfi.det_fig),0)         A_det_fg
                , nvl(sum(prfi.det_alt),0)         A_det_alt
                , nvl(sum(prfi.det_ult),0)         A_det_ult
             into A_det_con,A_det_fg,A_det_alt,A_det_ult
             from progressivi_fiscali  prfi
            where prfi.anno      = (select max(anno) from periodi_retributivi
                                     where ci = D_ci)
              and prfi.mese      = 12
              and prfi.mensilita = (select max(codice) from mensilita
                                     where mese = 12
                                       and tipo in ('A','S','N')
                                   )
              and prfi.ci        = D_ci
           ;
         EXCEPTION WHEN NO_DATA_FOUND THEN
                   A_det_con := 0;
                   A_det_fg  := 0;
                   A_det_alt := 0;
                   A_det_ult := 0;
         END;
         BEGIN -- Estrazione Dati Sovvenzione
           select inre.numero                        SOV_decr
                , to_char(inre.data ,'ddmmyyyy')     SOV_del
                , inre.tariffa                       SOV_mese
                , inre.imp_tot                       SOV_resid
                , inre.rate_tot                      SOV_quote
                , to_char(nvl(D_cessaz,inre.al)
                         ,'ddmmyyyy')                SOV_fine
                , decode
                  ( greatest(nvl(D_cessaz,rire.fin_ela)
                            ,inre.al)
                  , nvl(D_cessaz,rire.fin_ela), 1
                                         , 0)        SOV_estinzione
                , substr(iscr.descrizione,1,15)      SOV_cassa
                , inre.voce                          SOV_voce
                , inre.sub                           SOV_sub
             into SOV_decr,SOV_del,SOV_mese,SOV_imp_tot,SOV_rate_tot
                , SOV_fine,SOV_estinzione,SOV_cassa,SOV_voce,SOV_sub
             from estrazione_righe_contabili  esrc
                , istituti_credito            iscr
                , informazioni_retributive    inre
                , riferimento_retribuzione    rire
            where rire.rire_id        = 'RIRE'
              and esrc.estrazione     = 'MODELLO_98'
              and esrc.colonna        = 'SOVVENZIONE'
              and inre.voce           = esrc.voce
              and nvl(inre.sub,'*')   = nvl(esrc.sub,'*')
              and inre.tipo           = 'R'
              and inre.ci             = CUR_CI.ci
              and inre.dal            = (select max(dal)
                                           from informazioni_retributive
                                          where ci = CUR_CI.ci
                                            and voce = esrc.voce
                                            and sub  = esrc.sub)
              and iscr.codice (+)     = inre.istituto
           ;
         EXCEPTION WHEN NO_DATA_FOUND THEN
                   SOV_decr       := ' ';
                   SOV_del        := ' ';
                   SOV_mese       :=  0;
                   SOV_imp_tot    :=  0;
                   SOV_rate_tot   :=  0;
                   SOV_estinzione := '0';
                   SOV_cassa      := ' ';
                   SOV_voce       := ' ';
                   SOV_sub        := ' ';
         END;
         BEGIN
           select nvl(SOV_imp_tot,0) - nvl(sum(prco.imp),0)
                , nvl(SOV_rate_tot,0) - nvl(sum(prco.qta),0) * -1
             into SOV_resid, SOV_quote
             from progressivi_contabili prco
            where prco.ci             = CUR_CI.ci
              and prco.anno           =
                 (select max(anno) from periodi_retributivi
                   where ci = CUR_CI.ci)
              and prco.mese           = 12
              and prco.mensilita      = (select max(codice) from mensilita
                                          where mese = 12
                                            and tipo in ('S','A','N'))
              and prco.voce           = SOV_voce
              and nvl(prco.sub,'*')   = nvl(SOV_sub,'*')
           ;
         EXCEPTION WHEN NO_DATA_FOUND THEN
                   SOV_resid      := 0;
                   SOV_quote      := 0;
         END;
         BEGIN -- Estrazione Dati Eccedenza
           select max(decode( esrc.colonna
                            , 'ECCE_A', to_char(inec.dal,'ddmmyyyy')
                                      , null))            D_r_paga
                , max(decode( esrc.colonna
                            , 'ECCE_B', to_char(inec.dal,'ddmmyyyy')
                                      , null))            D_r_spec
                , max(decode( esrc.colonna
                            , 'ECCE_C', to_char(inec.dal,'ddmmyyyy')
                                      , null))            D_r_tp
                , max(decode( esrc.colonna
                            , 'ECCE_A', inec.eccedenza
                                      , null))            D_assegno_a
                , max(decode( esrc.colonna
                            , 'ECCE_B', inec.eccedenza
                                      , null))            D_assegno_b
                , max(decode( esrc.colonna
                            , 'ECCE_C', inec.eccedenza
                                      , null))            D_assegno_c
             into D_r_paga,D_r_spec,D_r_tp
                , D_assegno_a,D_assegno_b,D_assegno_c
             from estrazione_righe_contabili  esrc
                , inquadramenti_economici     inec
                , riferimento_retribuzione    rire
            where rire.rire_id        = 'RIRE'
              and esrc.estrazione     = 'MODELLO_98'
              and esrc.colonna       in ('ECCE_A','ECCE_B','ECCE_C')
              and inec.voce           = esrc.voce
              and inec.ci             = CUR_CI.ci
              and inec.dal            = (select max(dal)
                                           from inquadramenti_economici
                                          where ci = CUR_CI.ci
                                            and voce = esrc.voce)
           ;
         EXCEPTION WHEN NO_DATA_FOUND THEN
                   D_r_paga       := ' ';
                   D_r_spec       := ' ';
                   D_r_tp         := ' ';
                   D_assegno_a    := 0;
                   D_assegno_b    := 0;
                   D_assegno_c    := 0;
         END;
         BEGIN -- Estrazione Maturato
           select inre.tariffa
             into D_maturato
             from estrazione_righe_contabili  esrc
                , informazioni_retributive    inre
                , riferimento_retribuzione    rire
            where rire.rire_id        = 'RIRE'
              and esrc.estrazione     = 'MODELLO_98'
              and esrc.colonna        = 'MATURATO'
              and inre.voce           = esrc.voce
              and inre.ci             = CUR_CI.ci
              and inre.dal            = (select max(dal)
                                           from informazioni_retributive
                                          where ci = CUR_CI.ci
                                            and voce = esrc.voce)
           ;
         EXCEPTION WHEN NO_DATA_FOUND THEN D_maturato := 0;
         END;
         BEGIN -- Inserimento Record 3  (C_ECON.dbf)
         lock table a_appoggio_stampe in exclusive mode nowait;
         D_riga := D_riga + 1;
         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
         values ( prenotazione
                , 5
                , D_pagina
                , D_riga
                , lpad(to_char(A_det_con),8,'0')||
                  lpad(to_char(A_det_fg),8,'0')||
                  lpad(to_char(A_det_alt),8,'0')||
                  lpad(to_char(A_det_ult),8,'0')||
                  '       '||
                  '       '||
                  lpad(to_char(nvl(D_maturato,0)),8,'0')||
                  '00000000'||
                  '00000000'||
                  '00000000'||
                  lpad(to_char(nvl(D_assegno_a,0)),8,'0')||
                  lpad(to_char(nvl(D_assegno_b,0)),8,'0')||
                  lpad(to_char(nvl(D_assegno_c,0)),8,'0')||
                  '000000000'||
                  lpad(to_char(nvl(SOV_mese,0)),8,'0')||
                  lpad(to_char(nvl(SOV_resid,0)),8,'0')||
                  lpad(to_char(nvl(SOV_quote,0)),3,'0')||
                  rpad(nvl(SOV_cassa,' '),15,' ')||
                  '        '||
                  '          '||
                  rpad(nvl(SOV_decr,' '),8,' ')||
                  rpad(' ',8,' ')||
                  nvl(to_char(SOV_estinzione),'0')||
                  rpad(nvl(D_r_paga,' '),8,' ')||
                  rpad(nvl(D_r_spec,' '),8,' ')||
                  rpad(nvl(D_r_tp,' '),8,' ')||
                  rpad(nvl(A_meccan,' '),9,' ')
                );
         END;
         BEGIN -- Inserimento Record 4 fisso al 1/1/70   (C_RETR.dbf)
         lock table a_appoggio_stampe in exclusive mode nowait;
         D_riga := D_riga + 1;
         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
         values ( prenotazione
                , 7
                , D_pagina
                , D_riga
                , '01011970'||
                  lpad('0',9,'0')||
                  rpad(nvl(A_meccan,' '),9,' ')
                );
         END;
         FOR CUR_RETR IN
            (select to_char(dal,'ddmmyyyy')   dal
                  , importo                   imp
              from denuncia_cp
             where anno      < (select anno - 5
                                  from riferimento_fine_anno)
               and ci        = CUR_CI.ci
               and rilevanza = 'R'
            ) LOOP
              BEGIN -- Inserimento Record 4    (C_RETR.dbf)
              lock table a_appoggio_stampe in exclusive mode nowait;
              D_riga := D_riga + 1;
              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
              values ( prenotazione
                     , 7
                     , D_pagina
                     , D_riga
                     , lpad(CUR_RETR.dal,8,'0')||
                       lpad(to_char(nvl(CUR_RETR.imp,0)),9,'0')||
                       rpad(nvl(A_meccan,' '),9,' ')
                     );
              END;
              END LOOP;
              BEGIN
                select 'S'
                  into D_interrupt
                  from periodi_giuridici
                 where rilevanza  = 'A'
                   and ci         = D_ci
                   and dal  between D_assunz
                                and D_cessaz
                   and assenza   in (select codice
                                       from astensioni
                                      where servizio = 0);
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        D_interrupt := 'N';
              END;
              BEGIN
                select substr(nome,1,30)
                  into D_ult_ente
                  from gestioni
                 where codice = (select substr(max(to_char(dal,'yyyymmdd')||
                                                   gestione),9)
                                   from periodi_giuridici
                                  where rilevanza = 'S'
                                    and ci        = D_ci);
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        D_ult_ente := ' ';
              END;
              BEGIN -- Inserimento Record 5   (C_SER2.dbf)
              lock table a_appoggio_stampe in exclusive mode nowait;
              D_riga := D_riga + 1;
              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
              values ( prenotazione
                     , 9
                     , D_pagina
                     , D_riga
                     , rpad(nvl(D_ult_ente,' '),30,' ')||
                       rpad(A_cassa,8,' ')||
                       lpad(to_char(D_assunz,'ddmmyyyy'),8,'0')||
                       lpad(to_char(nvl(D_cessaz,sysdate),'ddmmyyyy'),8,'0')||
                       lpad('0',2,'0')||
                       lpad('0',2,'0')||
                       lpad('0',2,'0')||
                       '0'||
                       ' '||
                       rpad(nvl(A_meccan,' '),9,' ')
                     );
              END;
         END;
         END LOOP;
         BEGIN -- Inserimento Record 7   (C_SER1.dbf)
         lock table a_appoggio_stampe in exclusive mode nowait;
         D_riga := D_riga + 1;
         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
         values ( prenotazione
                , 13
                , D_pagina
                , D_riga
                , lpad('0',26,'0')||
                  '  '||
                  lpad('0',49,'0')||
                  rpad(nvl(A_meccan,' '),9,' ')
                );
         END;
         BEGIN
           FOR CUR_RISC IN
              (select decode( esrc.colonna
                            , 'RISCATTO','1','2')       tipo
                    , inre.numero                       decr
                    , to_char(inre.data ,'ddmmyyyy')    del
                    , inre.tariffa                      mese
                    , inre.al                           fine
                    , decode
                      ( greatest(rire.fin_ela,inre.al)
                      , fin_ela, 1
                               , 0)                     estinzione
                 from riferimento_retribuzione    rire
                    , estrazione_righe_contabili  esrc
                    , informazioni_retributive    inre
                where rire.rire_id        = 'RIRE'
                  and esrc.estrazione     = 'MODELLO_98'
                  and esrc.colonna       in ('RISCATTO','RICONGIUNZIONE')
                  and inre.voce           = esrc.voce
                  and nvl(inre.sub,'*')   = nvl(esrc.sub,'*')
                  and inre.tipo           = 'R'
                  and inre.ci             = D_ci
              ) LOOP
                  BEGIN -- Inserimento Record 8   (C_RISC.dbf)
                    lock table a_appoggio_stampe in exclusive mode nowait;
                    D_riga := D_riga + 1;
                    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                    values ( prenotazione
                           , 15
                           , D_pagina
                           , D_riga
                           , lpad(to_char(CUR_RISC.mese),8,'0')||
                             '00000000'||
                             '000'||
                             rpad(CUR_RISC.decr,11,' ')||
                             '00000000'||
                             '00000000'||
                             '00'||
                             '00'||
                             '00'||
                             '0'||
                             CUR_RISC.tipo||
                             '0'||
                             rpad(nvl(A_meccan,' '),9,' ')
                           );
                  END;
                END LOOP;
         END;
         BEGIN
           FOR CUR_SER IN
              (select psec.dal                           dal
                    , nvl(psec.al,sysdate)               al
                    , decode( least( nvl(psec.al,sysdate)
                                   , to_date('31121992','ddmmyyyy'))
                            , to_date('31121992','ddmmyyyy'), '0'
                                                            , '1'
                            )                            modo
                    , decode( least( nvl(psec.al,sysdate)
                                   , to_date('31121992','ddmmyyyy'))
                            , to_date('31121992','ddmmyyyy'), null
                                                            , 'E'||qual.livello
                            )                            codifica
                    , decode( posi.part_time
                            , 'SI', '3'
                                  , decode
                                    ( nvl(psec.ore,cost.ore_lavoro)
                                    , cost.ore_lavoro, '0'
                                                     , '9')
                            )                           tipo
                    , decode( nvl(psec.ore,cost.ore_lavoro)
                            , cost.ore_lavoro, null
                                      , psec.ore)       ore
                 from posizioni                  posi
                    , contratti_storici          cost
                    , qualifiche_giuridiche      qual
                    , periodi_servizio_contabile psec
                where psec.ci                  = D_ci
                  and psec.rilevanza          in ('i','c','f','e')
                  and not exists
                     (select 'x' from periodi_giuridici
                       where ci           = psec.ci
                         and rilevanza    = 'A'
                         and assenza     in
                            (select codice from astensioni
                              where servizio = 0
                            )
                         and dal <= nvl(psec.al,to_date('3333333','j'))
                         and nvl(al,to_date('3333333','j')) >= psec.dal
                     )
                  and qual.numero    (+)       = psec.qualifica
                  and nvl(qual.dal,to_date('2222222','j'))   =
                     (select nvl(max(dal),to_date('2222222','j'))
                        from qualifiche_giuridiche
                       where numero = psec.qualifica)
                  and cost.contratto  (+)      = qual.contratto
                  and nvl(cost.dal,to_date('2222222','j'))   =
                     (select nvl(max(dal),to_date('2222222','j'))
                        from contratti_storici
                       where contratto = qual.contratto)
                  and posi.codice (+)          = psec.posizione
                union
               select psec.dal                   dal
                    , nvl(pegi.dal-1,sysdate)    al
                    , decode( least( nvl(psec.al,sysdate)
                                   , to_date('31121992','ddmmyyyy'))
                            , to_date('31121992','ddmmyyyy'), '0'
                                                            , '1'
                            )                            modo
                    , decode( least( nvl(psec.al,sysdate)
                                   , to_date('31121992','ddmmyyyy'))
                            , to_date('31121992','ddmmyyyy'), null
                                                            , 'E'||qual.livello
                            )                            codifica
                    , decode( posi.part_time
                            , 'SI', '3'
                                  , decode
                                    ( nvl(psec.ore,cost.ore_lavoro)
                                    , cost.ore_lavoro, '0'
                                                     , '9')
                            )                           tipo
                    , decode( nvl(psec.ore,cost.ore_lavoro)
                            , cost.ore_lavoro, null
                                      , psec.ore)       ore
                 from posizioni                  posi
                    , contratti_storici          cost
                    , qualifiche_giuridiche      qual
                    , periodi_giuridici          pegi
                    , periodi_servizio_contabile psec
                where psec.ci                  = D_ci
                  and psec.rilevanza          in ('i','c','f','e')
                  and pegi.ci                  = psec.ci
                  and pegi.rilevanza           = 'A'
                  and pegi.assenza            in
                     (select codice from astensioni
                       where servizio = 0
                     )
                  and pegi.dal between psec.dal
                                   and nvl(psec.al,to_date('3333333','j'))
                  and qual.numero    (+)       = psec.qualifica
                  and nvl(qual.dal,to_date('2222222','j'))   =
                     (select nvl(max(dal),to_date('2222222','j'))
                        from qualifiche_giuridiche
                       where numero = psec.qualifica)
                  and cost.contratto  (+)      = qual.contratto
                  and nvl(cost.dal,to_date('2222222','j'))   =
                     (select nvl(max(dal),to_date('2222222','j'))
                        from contratti_storici
                       where contratto = qual.contratto)
                  and posi.codice (+)          = psec.posizione
                union
               select pegi.al+1                  dal
                    , nvl(psec.al,sysdate)       al
                    , decode( least( nvl(psec.al,sysdate)
                                   , to_date('31121992','ddmmyyyy'))
                            , to_date('31121992','ddmmyyyy'), '0'
                                                            , '1'
                            )                            modo
                    , decode( least( nvl(psec.al,sysdate)
                                   , to_date('31121992','ddmmyyyy'))
                            , to_date('31121992','ddmmyyyy'), null
                                                            , 'E'||qual.livello
                            )                            codifica
                    , decode( posi.part_time
                            , 'SI', '3'
                                  , decode
                                    ( nvl(psec.ore,cost.ore_lavoro)
                                    , cost.ore_lavoro, '0'
                                                     , '9')
                            )                           tipo
                    , decode( nvl(psec.ore,cost.ore_lavoro)
                            , cost.ore_lavoro, null
                                      , psec.ore)       ore
                 from posizioni                  posi
                    , contratti_storici          cost
                    , qualifiche_giuridiche      qual
                    , periodi_giuridici          pegi
                    , periodi_servizio_contabile psec
                where psec.ci                  = D_ci
                  and psec.rilevanza          in ('i','c','f','e')
                  and pegi.ci                  = psec.ci
                  and pegi.rilevanza           = 'A'
                  and pegi.assenza            in
                     (select codice from astensioni
                       where servizio = 0
                     )
                  and nvl(pegi.al,to_date('3333333','j'))
                          between psec.dal
                              and nvl(psec.al,to_date('3333333','j'))
                  and qual.numero    (+)       = psec.qualifica
                  and nvl(qual.dal,to_date('2222222','j'))   =
                     (select nvl(max(dal),to_date('2222222','j'))
                        from qualifiche_giuridiche
                       where numero = psec.qualifica)
                  and cost.contratto  (+)      = qual.contratto
                  and nvl(cost.dal,to_date('2222222','j'))   =
                     (select nvl(max(dal),to_date('2222222','j'))
                        from contratti_storici
                       where contratto = qual.contratto)
                  and posi.codice (+)          = psec.posizione
              ) LOOP
                  BEGIN
                    FOR CUR_AD_PER IN
                       (select inre.tariffa        tariffa
                             , greatest( CUR_SER.dal
                                       , nvl(inre.dal,to_date('2222222','j'))
                                       )           dal
                             , least( CUR_SER.al
                                    , nvl(inre.al,to_date('3333333','j'))
                                    )              al
                          from informazioni_retributive inre
                             , estrazione_righe_contabili esrc
                         where esrc.estrazione = 'MODELLO_98'
                           and esrc.colonna    = 'ASS_AD_PER'
                           and inre.voce (+)   = esrc.voce
                           and inre.sub  (+)   = esrc.sub
                           and nvl(inre.dal (+), to_date('2222222','j'))
                                        <= CUR_SER.al
                           and nvl(inre.al (+), to_date('3333333','j'))
                                        >= CUR_SER.dal
                       ) LOOP
                          BEGIN -- Inserimento Record 6   (C_SER.dbf)
                          lock table a_appoggio_stampe in exclusive mode nowait;
                          D_riga := D_riga + 1;
                          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                          values ( prenotazione
                                 , 11
                                 , D_pagina
                                 , D_riga
                                 , to_char(nvl(CUR_AD_PER.dal
                                              ,CUR_SER.dal),'dd/mm/yyyy')||
                                   to_char(nvl(CUR_AD_PER.al
                                              ,CUR_SER.al),'dd/mm/yyyy')||
                                   nvl(CUR_SER.modo,'0')||
                                   nvl(CUR_SER.tipo,'0')||
                                   '0'||
                                   rpad(CUR_SER.codifica,7,' ')||
                                   '00'||
                                   '0'||
                                   lpad(to_char(CUR_SER.ore),5,'0')||
                                   lpad(to_char(nvl(CUR_AD_PER.tariffa,0))
                                       ,9,'0')||
                                   lpad(' ',22,' ')||
                                   lpad(' ',6,' ')||
                                   lpad(' ',8,' ')||
                                   lpad(' ',6,' ')||
                                   lpad(' ',8,' ')||
                                   lpad(' ',6,' ')||
                                   lpad(' ',8,' ')||
                                   rpad(nvl(A_meccan,' '),9,' ')
                                 );
                          END;
                         END LOOP;
                  END;
                END LOOP;
         END;
END;
COMMIT;
EXCEPTION
WHEN NO_CED THEN
 null;
END;
END;
END;
/

