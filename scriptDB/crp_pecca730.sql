CREATE OR REPLACE PACKAGE PECCA730 IS
/******************************************************************************
 NOME:        PECCA730
 DESCRIZIONE: Inserimento dei dati fiscali trasmessi dal CAAF in tabella
              DENUNCIA_CAAF.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    28/07/2004    MV
 2.1  23/06/2005    CB
 2.2  28/06/2005 MS     Modifica per att. 11824
 2.3  25/07/2005 MS     Mod. Per attività 12144
 2.4  13/03/2006 MS     Controlli su data di ricezione (att. 12142 )
 3.0  18/04/2006 ML     Modifiche per tracciato 2006 (A15807)
 3.1  19/04/2006 ML     Modifiche per gestione personale con più di un ci (A13066).
 3.2  23/06/2006 ML     Spostata l'exception SEGNALA_RAPPORTI a un livello superiore (A16788).
 4.0  26/04/2007 MS     Modifiche per tracciato 2007 ( A20710 )
******************************************************************************/
FUNCTION VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCA730 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V4.0 del 26/04/2007';
END VERSIONE;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
DECLARE
  D_riga_e                   number := 0; -- indicatore per inserimento segnalazioni
  D_riga_s                   number := 0; -- indicatore per inserimento totali su apst
  D_descr_errore             varchar2(75);
  app                        varchar2(1);
  app2                       varchar2(1); 
  D_codice_fiscale           varchar2(20);
  D_errore                   varchar2(100);
  D_ente                     varchar2(4);
  D_ambiente                 varchar2(8);
  D_utente                   varchar2(8);
  D_data_ric                 date;
  D_ci                       number;
  D_ni                       number;
  D_anno                     number;
  D_caaf                     number;
  D_nome_caaf                varchar2(40);
  D_invio                    varchar2(1);
  D_int_rate_irpef           number;
  D_int_rate_irpef_con       number;
  D_int_rate_irpef_1r        number;
  D_int_rate_irpef_1r_con    number;
  D_int_rate_irpef_ap        number;
  D_int_rate_irpef_ap_con    number;
  D_int_rate_reg_dic         number;
  D_int_rate_reg_con         number;
  D_int_rate_com_dic         number;
  D_int_rate_com_con         number;
  D_int_rate_acc_com_dic     number;
  D_int_rate_acc_com_con     number;
  D_max_sequenza             number;
  T_ci                       number;
  T_irpef_db                 number;
  T_irpef_db_con             number;
  T_irpef_cr                 number;
  T_irpef_cr_con             number;
  T_irpef_1r                 number;
  T_irpef_2r                 number;
  T_irpef_1r_con             number;
  T_irpef_2r_con             number;
  T_add_reg_dic_db           number;
  T_add_reg_con_db           number;
  T_add_reg_dic_cr           number;
  T_add_reg_con_cr           number;
  T_add_com_dic_db           number;
  T_add_com_con_db           number;
  T_add_com_dic_cr           number;
  T_add_com_con_cr           number;
  T_acc_add_com_dic_db       number;
  T_acc_add_com_con_db       number;
  T_irpef_ap                 number;
  T_irpef_ap_con             number;
  V_cessato                  varchar2(2) := null;
  V_dal                      date := to_date(null);
  V_al                       date := to_date(null);
  USCITA                     exception;
  ESCI                       exception;
  SALTA                      exception;
  SEGNALA_RAPPORTI           exception;
BEGIN
BEGIN
--
--  -- Estrazione Parametri di Selezione della Prenotazione
--
   BEGIN
      select ente, utente, ambiente
        into D_ente, D_utente, D_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
   EXCEPTION      -- 1
      WHEN NO_DATA_FOUND THEN
        RAISE ESCI;
   END;
   BEGIN
      select substr(valore,1,1)
        into D_invio
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro = 'P_INVIO'
      ;
   END;
   BEGIN
        select to_date(valore,'dd/mm/yyyy')
        into D_data_ric
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro = 'P_DATA_RIC'
      ;
   EXCEPTION      -- 2
      WHEN NO_DATA_FOUND THEN
        RAISE USCITA;
   END;
-- dbms_output.put_line('la data!!!!!!!!!');
--
--  -- Estrae Anno di Riferimento per archiviazione
--
   BEGIN
      select anno
        into D_anno
        from riferimento_fine_anno
       where rifa_id = 'RIFA'
      ;
   EXCEPTION      -- 2
      WHEN NO_DATA_FOUND THEN
        D_riga_e := nvl(D_riga_e,0) + 1;
        insert into a_segnalazioni_errore
        (no_prenotazione,passo,progressivo,errore,precisazione)
        values (prenotazione,1,D_riga_e,'P05150','');
        RAISE ESCI;
   END;

   IF to_char(D_data_ric,'yyyy') != D_anno+1 THEN
      RAISE USCITA;
   END IF;

-- Decodifica CAAF
    BEGIN
    app2             := null;
    D_codice_fiscale := null;

   FOR CUR_ANAG in 
   ( select rain.ci,anag.cognome, anag.nome, anag.codice_fiscale
       from anagrafici anag,
            rapporti_individuali rain,
            com730
      where anag.codice_fiscale = rtrim(substr(campo2,21,16)) 
        and tipo_rec   = '0'
        and anag.al    is null
        and rain.ni     = anag.ni
        and rain.dal    =
            (select max(r.dal)
               from rapporti_individuali r,
                    classi_rapporto c
              where r.ni = anag.ni
                and r.dal <= to_date('3112'||to_char(D_anno),'ddmmyyyy')
                and nvl(r.al,to_date('3333333','j')) >=
                           to_date('0101'||to_char(D_anno),'ddmmyyyy')
                and c.codice      = r.rapporto
                and c.retributivo = 'NO'
                and c.giuridico   = 'NO'
                and c.presenza    = 'NO'
                and c.concorso    = 'NO'
            )
        and (rain.cc is null or
             exists (select 'x'
                       from a_competenze
                      where ambiente   = D_ambiente
                        and ente       = D_ente
                        and utente     = D_utente
                        and competenza = 'CI'
                        and oggetto    = rain.cc
                    )
            )
    ) loop
-- dbms_output.put_line(CUR_ANAG.codice_fiscale||' '||D_codice_fiscale);
       app2 := 'X';
       if D_codice_fiscale = CUR_ANAG.codice_fiscale then
-- Esistono piu' referenze anagrafiche per lo stesso C.A.A.F.
         D_riga_e := nvl(D_riga_e,0) + 1;
         insert into a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         values (prenotazione,1,D_riga_e,'P01066'
                ,rtrim(CUR_ANAG.cognome)||' '||rtrim(CUR_ANAG.nome)||' ('||CUR_ANAG.codice_fiscale||')'); 
       else
         null;
       end if;
       D_codice_fiscale := CUR_ANAG.codice_fiscale;
-- dbms_output.put_line('fine loop anag');
     end loop; -- cur_anag

     if app2  is null then 
-- Centro Assistenza Fiscale non previsto
        D_riga_e := nvl(D_riga_e,0) + 1;
        insert into a_segnalazioni_errore
        (no_prenotazione,passo,progressivo,errore,precisazione)
        values (prenotazione,1,D_riga_e,'P01080','');
        RAISE ESCI;
     end if;
   END;
--
--  Lettura informazioni da tipo_rec 0
--
   FOR CUR_CAAF IN
     (select rtrim(substr(campo2,21,16)) cf_caaf
            ,substr(campo2,15,5)  cod_int
            ,substr(campo2,20,1)  se_rett 
            ,sequenza             sequenza 
        from com730
       where tipo_rec = '0'
     )LOOP
-- dbms_output.put_line('inizio loop caaf');
   BEGIN     
     BEGIN
       select min(sequenza)
         into D_max_sequenza
         from com730
        where tipo_rec = '9'
          and sequenza > CUR_CAAF.sequenza 
       ;
     END;  
--
-- Update Record se Il Modulo e' Integrativo
--
   IF CUR_CAAF.cod_int = '7304I' THEN
     update com730 set 
          ( irpef_cr, irpef_cr_con
          , cod_reg_dic_cr, add_reg_dic_cr
          , cod_reg_con_cr, add_reg_con_cr
          , add_reg_tot_cr
          , cod_com_dic_cr, add_com_dic_cr
          , cod_com_con_cr, add_com_con_cr
          , add_com_tot_cr
          , irpef_acconto_ap, irpef_acconto_con_ap
          , irpef_acconto_tot_ap) = ( select substr(c.deposito,1,9), substr(c.deposito,10,9),
                                             substr(c.deposito,28,2),substr(c.deposito,30,8),
                                             substr(c.deposito,38,2),substr(c.deposito,40,8),
                                             substr(c.deposito,48,8),
                                             substr(c.deposito,56,4),substr(c.deposito,60,8),
                                             substr(c.deposito,68,4),substr(c.deposito,72,8),
                                             substr(c.deposito,80,8),
                                             to_char(to_number(substr(c.deposito,88,9)) * -1),
                                             to_char(to_number(substr(c.deposito,97,9)) * -1),
                                             to_char(to_number(substr(c.deposito,106,9)) * -1)
                                        from com730 c
                                       where c.rowid = com730.rowid
                                    )
     where tipo_rec = 1
     ;
   END IF;
--
-- Decodifica CAAF
--
   BEGIN
     select rain.ci
          , rain.cognome
       into D_caaf
          , D_nome_caaf
       from anagrafici anag,
            rapporti_individuali rain
      where anag.codice_fiscale = CUR_CAAF.cf_caaf
        and anag.al    is null
        and rain.ni     = anag.ni
        and rain.dal    =
            (select max(r.dal)
               from rapporti_individuali r,
                    classi_rapporto c
              where r.ni = anag.ni
                and r.dal <= to_date('3112'||to_char(D_anno),'ddmmyyyy')
                and nvl(r.al,to_date('3333333','j')) >=
                           to_date('0101'||to_char(D_anno),'ddmmyyyy')
                and c.codice      = r.rapporto
                and c.retributivo = 'NO'
                and c.giuridico   = 'NO'
                and c.presenza    = 'NO'
                and c.concorso    = 'NO'
            )
        and (rain.cc is null or
             exists (select 'x'
                       from a_competenze
                      where ambiente   = D_ambiente
                        and ente       = D_ente
                        and utente     = D_utente
                        and competenza = 'CI'
                        and oggetto    = rain.cc
                    )
            );
   EXCEPTION       -- 3
      WHEN NO_DATA_FOUND THEN D_riga_e := nvl(D_riga_e,0) + 1;
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                         ,errore,precisazione)
        values (prenotazione,1,D_riga_e,'P01080','');
        RAISE ESCI;
      WHEN TOO_MANY_ROWS THEN
        D_riga_e := nvl(D_riga_e,0) + 1;
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                         ,errore,precisazione)
        values (prenotazione,1,D_riga_e,'P01066','');
        RAISE ESCI;
   END;
-- Ciclo su records di tipo 1
 BEGIN
  T_ci             := 0;
  T_irpef_db       := 0;
  T_irpef_db_con   := 0;
  T_irpef_cr       := 0;
  T_irpef_cr_con   := 0;
  T_irpef_ap       := 0;
  T_irpef_ap_con   := 0;
  T_irpef_1r       := 0;
  T_irpef_2r       := 0;
  T_irpef_1r_con   := 0;
  T_irpef_2r_con   := 0;
  T_add_reg_dic_db := 0;
  T_add_reg_con_db := 0;
  T_add_reg_dic_cr := 0;
  T_add_reg_con_cr := 0;
  T_add_com_dic_db := 0;
  T_add_com_con_db := 0;
  T_add_com_dic_cr := 0;
  T_add_com_con_cr := 0;
  T_acc_add_com_dic_db := 0;
  T_acc_add_com_con_db := 0;
 FOR CURC IN
    (select substr(campo2,1,16)           codice_fiscale,
            substr(campo2,17,24)          cognome,
            campo3                        nome,
            irpef_db                      irpef_db,
            irpef_db_con                  irpef_db_con,
            irpef_cr                      irpef_cr,
            irpef_cr_con                  irpef_cr_con,
            cod_reg_dic_db,
            add_reg_dic_db                add_reg_dic_db,
            cod_reg_con_db,
            add_reg_con_db                add_reg_con_db,
            cod_reg_dic_cr,
            add_reg_dic_cr                add_reg_dic_cr,
            cod_reg_con_cr,
            add_reg_con_cr                add_reg_con_cr,
            cod_com_dic_db,
            add_com_dic_db                add_com_dic_db,
            cod_com_con_db,
            add_com_con_db                add_com_con_db,
            cod_com_dic_cr,
            add_com_dic_cr                add_com_dic_cr,
            cod_com_con_cr,
            add_com_con_cr                add_com_con_cr,
            acc1_irpef_dic                acc1_irpef_dic,
            acc1_irpef_con                acc1_irpef_con,
            acc2_irpef_dic                acc2_irpef_dic,
            acc2_irpef_con                acc2_irpef_con,
            irpef_acconto_ap              irpef_acconto_ap,
            irpef_acconto_con_ap          irpef_acconto_ap_con,
            cod_com_acc_dic_db,
            acc_add_com_dic_db            acc_add_com_dic_db,
            cod_com_acc_con_db,
            acc_add_com_con_db            acc_add_com_con_db,
            nr_rate                       nr_rate
       from COM730
      where tipo_rec           = '1'
        and sequenza between CUR_CAAF.sequenza AND D_max_sequenza
    )
 LOOP
 V_cessato := null;
 V_dal     := to_date(null);
 V_al      := to_date(null);

-- dbms_output.put_line('inizio loop curc '||curc.codice_fiscale);
 BEGIN
 -- Controlla esistenza del dipendente in ANAGRAFICA.
  BEGIN
    BEGIN
    <<CHK_ANAG>>
-- dbms_output.put_line('select 1');
      select rain.ci, anag.ni
        into D_ci, D_ni
        from anagrafici anag,
             rapporti_individuali rain
       where anag.codice_fiscale = curc.codice_fiscale
         and anag.al    is null
         and rain.ni     = anag.ni
         and nvl(rain.al,to_date('3333333','j')) >=
             to_date('0101'||to_char(D_anno),'ddmmyyyy')
         and (rain.cc is null or
              exists (select 'x'
                        from a_competenze
                       where ambiente   = D_ambiente
                         and ente       = D_ente
                         and utente     = D_utente
                         and competenza = 'CI'
                         and oggetto    = rain.cc
                     )
             )
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_riga_e := nvl(D_riga_e,0) + 1;
        insert into a_segnalazioni_errore
        (no_prenotazione,passo,progressivo ,errore,precisazione)
        values (prenotazione,1,D_riga_e,'P01070',
                rtrim(curc.cognome)||' '||rtrim(curc.nome)||' ('||curc.codice_fiscale||')');
        RAISE SALTA;
      WHEN TOO_MANY_ROWS THEN
       BEGIN
-- dbms_output.put_line('select 2 '||curc.codice_fiscale||' '||to_char(D_anno)||' amb.:'||
-- D_ambiente||'utente: '||D_utente||' ente: '||D_ente);
      select rain.ci, anag.ni
            into D_ci, D_ni
            from anagrafici anag,
                 rapporti_individuali rain
           where anag.codice_fiscale = curc.codice_fiscale
             and anag.al    is null
             and rain.ni     = anag.ni
             and nvl(rain.al,to_date('3333333','j')) >=
                 to_date('0101'||to_char(D_anno),'ddmmyyyy')
             and (rain.cc is null or
                  exists (select 'x'
                            from a_competenze
                           where ambiente   = D_ambiente
                             and ente       = D_ente
                             and utente     = D_utente
                             and competenza = 'CI'
                             and oggetto    = rain.cc
                         )
                 )
             and exists (select 'x' from classi_rapporto
                          where codice = rain.rapporto
                            and retributivo = 'SI'
                            and giuridico   = 'SI'
                            and presenza    = 'SI'
                            and concorso    = 'NO'
                        )
          ;
                RAISE SEGNALA_RAPPORTI;
        EXCEPTION
          WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
-- dbms_output.put_line('select 3');
          BEGIN
/* in caso di più rapporti cerca quello valido nell'anno con l'al maggiore), in caso di più rapporti aperti o 
   chiusi lo stesso giorno prende il l'ultimo dal */
            select rain.ci, anag.ni
                into D_ci, D_ni
                from anagrafici anag,
                     rapporti_individuali rain
               where anag.codice_fiscale = curc.codice_fiscale
                 and anag.al    is null
                 and rain.ni     = anag.ni
                 and (rain.ci,rain.dal) in 
                    (select substr(max(to_char(r.dal,'yyyymmdd')||r.ci),9),max(r.dal)
                       from rapporti_individuali r
                      where r.ni = anag.ni
                        and (r.ci,nvl(r.al,to_date('3333333','j'))) in 
                           (select substr(max(to_char(nvl(r1.al,to_date('3333333','j')),'yyyymmdd')||r1.ci),9),max(nvl(r1.al,to_date('3333333','j')))
                              from rapporti_individuali r1
                                 , classi_rapporto c
                             where r1.ni = anag.ni 
                               and nvl(r1.al,to_date('3333333','j')) >=
                                            to_date('0101'||to_char(D_anno),'ddmmyyyy')
                               and c.codice      = r1.rapporto
                               and c.retributivo = 'SI'
                               and c.giuridico   = 'SI'
                               and c.presenza    = 'SI'
                               and c.concorso    = 'NO'
                               and (r1.cc is null or
                                      exists (select 'x'
                                                from a_competenze
                                               where ambiente   = D_ambiente
                                                 and ente       = D_ente
                                                 and utente     = D_utente
                                                 and competenza = 'CI'
                                                 and oggetto    = r.cc
                                             )
                                   )
                               and exists
                                  (select 'x' from rapporti_giuridici
                                    where ci = r1.ci
                                      and dal is not null
                                  )
                            )
                    )
           ;
       RAISE SEGNALA_RAPPORTI;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
        D_riga_e := nvl(D_riga_e,0) + 1;
            insert into a_segnalazioni_errore
            (no_prenotazione,passo,progressivo,errore,precisazione)
            values (prenotazione,1,D_riga_e,'P01070',
                    rtrim(curc.cognome)||' '||rtrim(curc.nome)||' ('||
                    curc.codice_fiscale||')');
            RAISE SALTA;
       WHEN TOO_MANY_ROWS THEN
            D_riga_e := nvl(D_riga_e,0) + 1;
            insert into a_segnalazioni_errore
            (no_prenotazione,passo,progressivo,errore,precisazione)
            values (prenotazione,1,D_riga_e,'P01065',
                    curc.cognome||' '||curc.nome||' ('||
                    curc.codice_fiscale||')');
            RAISE SALTA;
            END;
      END;
    END CHK_ANAG;
exception
    WHEN SEGNALA_RAPPORTI THEN
/* Segnala tutti i rapporti validi del dipendente, indicando quello scelto per caricare i dati */
-- dbms_output.put_line('segnala_rapporti');
                 BEGIN
                   D_riga_e := nvl(D_riga_e,0) + 1;
                   insert into a_segnalazioni_errore
                   (no_prenotazione,passo,progressivo,errore,precisazione)
                   values (prenotazione,1,D_riga_e,'P01085','');
                   D_riga_e := nvl(D_riga_e,0) + 1;
                   insert into a_segnalazioni_errore
                   (no_prenotazione,passo,progressivo,errore,precisazione)
                   values (prenotazione,1,D_riga_e,'      ',
                           substr(curc.cognome||' '||curc.nome||' ('||
                           curc.codice_fiscale||')',1,50));
                   FOR CUR_RAPP IN
                      (select ci,rapporto,dal,al
                         from rapporti_individuali 
                        where ni = D_ni
                          and nvl(al,to_date('3333333','j')) >= to_date('0101'||to_char(D_anno),'ddmmyyyy')
                      ) LOOP
                          D_riga_e := nvl(D_riga_e,0) + 1;
                          insert into a_segnalazioni_errore
                          (no_prenotazione,passo,progressivo,errore,precisazione)
                          values (prenotazione,1,D_riga_e,'      ',
                                  'Cod.Ind. '||lpad(to_char(cur_rapp.ci),8,' ')||' '||rpad(cur_rapp.rapporto,4,' ')||' '||
                                  to_char(cur_rapp.dal,'dd/mm/yyyy')||' - '||
                                  to_char(cur_rapp.al,'dd/mm/yyyy'));
                        END LOOP;
                   D_riga_e := nvl(D_riga_e,0) + 1;
                   insert into a_segnalazioni_errore
                   (no_prenotazione,passo,progressivo,errore,precisazione)
                   values (prenotazione,1,D_riga_e,'P01086', to_char(D_ci));
                   D_riga_e := nvl(D_riga_e,0) + 1;
                   insert into a_segnalazioni_errore
                   (no_prenotazione,passo,progressivo,errore,precisazione)
                   values (prenotazione,1,D_riga_e,' ', ' '); -- inserimento riga vuota
                 END;
   END;
   BEGIN
   <<CHK_RAGI>> 
/* Segnalazione dipendente non in servizio */
    BEGIN
    select 'SI', dal, al
      into V_cessato, V_dal, V_al
      from rapporti_giuridici ragi
     where nvl(ragi.al,to_date('3333333','j')) <=  to_date('3006'||D_anno+1,'ddmmyyyy')
       and ci = D_ci
     ;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_cessato := 'NO';
    END;
    IF V_cessato = 'SI' THEN
/*  Rapporto giuridico valido in periodo */
       D_riga_e := nvl(D_riga_e,0) + 1;
       insert into a_segnalazioni_errore
       (no_prenotazione,passo,progressivo ,errore,precisazione)
       values (prenotazione,1,D_riga_e,'P01156'
             , substr(': '||to_char(V_dal,'dd/mm/yyyy')||' - ' ||to_char(V_al,'dd/mm/yyyy')
               ||' Cod.Ind.: '||D_ci,1,50));
       RAISE SALTA;
    END IF;
   END CHK_RAGI;
 -- Segnala i record che verranno eliminati
    BEGIN
      select 'x'
        into app
        from dual
       where exists (select 'x'
                       from denuncia_caaf
                      where anno             = D_anno
                        and ci               = D_ci
                        and rettifica        = D_invio
                        and nvl(utente,' ') != 'CAR.AUTO'
                    );
      D_riga_e := nvl(D_riga_e,0) + 1;
      insert into a_segnalazioni_errore
      (no_prenotazione,passo,progressivo,errore,precisazione)
      values (prenotazione,1,D_riga_e,'P05833',to_char(D_ci));
    EXCEPTION        -- 6
      WHEN NO_DATA_FOUND THEN null;
    END;
    BEGIN
      delete from denuncia_caaf
       where anno      = D_anno
         and rettifica = D_invio
         and ci        = D_ci
         and CUR_CAAF.cod_int != '7304I'
      ;
    END;
 -- In caso di 2^ invio il record di tipo A diventa di tipo B
    IF CUR_CAAF.se_rett = '1' THEN
    BEGIN
      update denuncia_caaf
         set rettifica = 'M'
       where anno      = D_anno
         and ci        = D_ci
         and rettifica = '1'
         and not exists (select 'x'
                           from denuncia_caaf
                          where anno      = D_anno
                            and ci        = D_ci
                            and rettifica = '1'
                        );
      delete denuncia_caaf
       where anno      = D_anno
         and ci        = D_ci
         and rettifica = 'B';
    END;
    END IF;

    BEGIN -- Calcolo interessi per Versamenti Rateali
      select decode( nvl(curc.irpef_db,0)
                   , 0 , null
                       , e_round( nvl(curc.irpef_db,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi saldo irpef
           , decode( nvl(curc.irpef_db_con,0)
                   , 0 , null
                       , e_round( nvl(curc.irpef_db_con,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi saldo irpef coniuge
           , decode( nvl(curc.acc1_irpef_dic,0)
                   , 0 , null
                       , e_round( nvl(curc.acc1_irpef_dic,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi primo acconto irpef
          , decode( nvl(curc.acc1_irpef_con,0)
                   , 0 , null
                       , e_round( nvl(curc.acc1_irpef_con,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi primo acconto irpef coniuge
           , decode( nvl(curc.irpef_acconto_ap,0)
                   , 0 , null
                       , e_round( nvl(curc.irpef_acconto_ap,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi acconto irpef ap
           , decode( nvl(curc.irpef_acconto_ap_con,0)
                   , 0 , null
                       , round( nvl(curc.irpef_acconto_ap_con,0)
                               / curc.nr_rate * 0.5 /100
                               *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                              )
                   ) -- interessi acconto irpef ap coniuge
           , decode( nvl(curc.add_reg_dic_db,0)
                   , 0 , null
                       , e_round( nvl(curc.add_reg_dic_db,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi addizionale regionale
           , decode( nvl(curc.add_reg_con_db,0)
                   , 0 , null
                       , e_round( nvl(curc.add_reg_con_db,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi addizionale regionale coniuge
           , decode( nvl(curc.add_com_dic_db,0)
                   , 0 , null
                       , e_round( nvl(curc.add_com_dic_db,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi addizionale comunale
           , decode( nvl(curc.add_com_con_db,0)
                   , 0 , null
                       , e_round( nvl(curc.add_com_con_db,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi addizionale comunale coniuge
           , decode( nvl(curc.acc_add_com_dic_db,0)
                   , 0 , null
                       , e_round( nvl(curc.acc_add_com_dic_db,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi acconto addizionale comunale
           , decode( nvl(curc.acc_add_com_con_db,0)
                   , 0 , null
                       , e_round( nvl(curc.acc_add_com_con_db,0)
                                / curc.nr_rate * 0.5 /100
                                *decode( curc.nr_rate,2,1,3,3,4,6,5,10)
                                , 'I')
                   ) -- interessi acconto addizionale comunale coniuge
        into D_int_rate_irpef, D_int_rate_irpef_con
           , D_int_rate_irpef_1r, D_int_rate_irpef_1r_con
           , D_int_rate_irpef_ap, D_int_rate_irpef_ap_con
           , D_int_rate_reg_dic, D_int_rate_reg_con
           , D_int_rate_com_dic, D_int_rate_com_con
           , D_int_rate_acc_com_dic, D_int_rate_acc_com_con
        from dual
       where nvl(curc.nr_rate,0) != 0
       ;
    EXCEPTION WHEN NO_DATA_FOUND THEN 
              D_int_rate_irpef        := 0;
              D_int_rate_irpef_con    := 0;
              D_int_rate_irpef_1r     := 0;
              D_int_rate_irpef_1r_con := 0;
              D_int_rate_irpef_ap     := 0;
              D_int_rate_irpef_ap_con := 0;
              D_int_rate_reg_dic      := 0;
              D_int_rate_reg_con      := 0;
              D_int_rate_com_dic      := 0;
              D_int_rate_com_con      := 0;
              D_int_rate_acc_com_dic  := 0;
              D_int_rate_acc_com_con  := 0;
    END;
 -- Inserisce record in tabella denuncia_caaf.
    BEGIN
      insert into denuncia_caaf 
       ( anno, ci, ci_caaf
       , irpef_db, irpef_db_con
       , irpef_cr, irpef_cr_con
       , cod_reg_dic_db,add_reg_dic_db
       , cod_reg_con_db,add_reg_con_db
       , cod_reg_dic_cr,add_reg_dic_cr
       , cod_reg_con_cr,add_reg_con_cr
       , cod_com_dic_db, add_com_dic_db
       , cod_com_con_db, add_com_con_db
       , cod_com_dic_cr, add_com_dic_cr
       , cod_com_con_cr, add_com_con_cr
       , cod_com_acc_dic_db, acc_add_com_dic_db
       , cod_com_acc_con_db, acc_add_com_con_db
       , irpef_1r, irpef_1r_con
       , irpef_2r, irpef_2r_con
       , irpef_acconto_ap, irpef_acconto_ap_con
       , nr_rate
       , int_rate_irpef, int_rate_irpef_con
       , int_rate_irpef_1r, int_rate_irpef_1r_con
       , int_rate_irpef_ap, int_rate_irpef_ap_con
       , int_rate_reg_dic, int_rate_reg_con
       , int_rate_com_dic, int_rate_com_con
       , int_rate_acc_com_dic, int_rate_acc_com_con
       , rettifica, tipo
       , utente, data_agg, data_ricezione
       )
      values ( D_anno, D_ci, D_caaf
             , to_number(curc.irpef_db), to_number(curc.irpef_db_con)
             , to_number(curc.irpef_cr), to_number(curc.irpef_cr_con)
             , decode(to_number(curc.cod_reg_dic_db),0,null,to_number(curc.cod_reg_dic_db))
             , to_number(curc.add_reg_dic_db)
             , decode(to_number(curc.cod_reg_con_db),0,null,to_number(curc.cod_reg_con_db))
             , to_number(curc.add_reg_con_db)
             , decode(to_number(curc.cod_reg_dic_cr),0,null,to_number(curc.cod_reg_dic_cr))
             , to_number(curc.add_reg_dic_cr)
             , decode(to_number(curc.cod_reg_con_cr),0,null,to_number(curc.cod_reg_con_cr))
             , to_number(curc.add_reg_con_cr)
             , decode(to_number(curc.add_com_dic_db),0,null,curc.cod_com_dic_db)
             , to_number(curc.add_com_dic_db)
             , decode(to_number(curc.add_com_con_db),0,null,curc.cod_com_con_db)
             , to_number(curc.add_com_con_db)
             , decode(to_number(curc.add_com_dic_cr),0,null,curc.cod_com_dic_cr)
             , to_number(curc.add_com_dic_cr)
             , decode(to_number(curc.add_com_con_cr),0,null,curc.cod_com_con_cr)
             , to_number(curc.add_com_con_cr)
             , decode(to_number(curc.acc_add_com_dic_db),0,null,curc. cod_com_acc_dic_db)
             , to_number(curc.acc_add_com_dic_db)
             , decode(to_number(curc.acc_add_com_con_db),0,null,curc. cod_com_acc_con_db)
             , to_number(curc.acc_add_com_con_db)
             , to_number(curc.acc1_irpef_dic), to_number(curc.acc1_irpef_con)
             , to_number(curc.acc2_irpef_dic), to_number(curc.acc2_irpef_con)
             , to_number(curc.irpef_acconto_ap), to_number(curc.irpef_acconto_ap_con)
             , curc.nr_rate
             , D_int_rate_irpef, D_int_rate_irpef_con
             , D_int_rate_irpef_1r, D_int_rate_irpef_1r_con
             , D_int_rate_irpef_ap, D_int_rate_irpef_ap_con
             , D_int_rate_reg_dic, D_int_rate_reg_con
             , D_int_rate_com_dic, D_int_rate_com_con
             , D_int_rate_acc_com_dic, D_int_rate_acc_com_con
             , D_invio, 0
             , 'CAR.AUTO', trunc(sysdate), D_data_ric
             )
      ;
    EXCEPTION      -- INSERT
      WHEN OTHERS THEN
        D_errore := substr(SQLERRM,1,100);
        rollback;
        D_riga_e := nvl(D_riga_e,0) + 1;
        insert into a_segnalazioni_errore
        (no_prenotazione,passo,progressivo,errore,precisazione)
        values (prenotazione,1,D_riga_e,'P05832',substr(to_char(D_ci)||' '||D_errore,1,50));
    END;
    T_ci             := T_ci + 1;
    T_irpef_db       := T_irpef_db       + nvl(curc.irpef_db,0);
    T_irpef_db_con   := T_irpef_db_con   + nvl(curc.irpef_db_con,0);
    T_irpef_cr       := T_irpef_cr       + nvl(curc.irpef_cr,0);
    T_irpef_cr_con   := T_irpef_cr_con   + nvl(curc.irpef_cr_con,0);
    T_add_reg_dic_db := T_add_reg_dic_db + nvl(curc.add_reg_dic_db,0);
    T_add_reg_con_db := T_add_reg_con_db + nvl(curc.add_reg_con_db,0);
    T_add_reg_dic_cr := T_add_reg_dic_cr + nvl(curc.add_reg_dic_cr,0);
    T_add_reg_con_cr := T_add_reg_con_cr + nvl(curc.add_reg_con_cr,0);
    T_add_com_dic_db := T_add_com_dic_db + nvl(curc.add_com_dic_db,0);
    T_add_com_con_db := T_add_com_con_db + nvl(curc.add_com_con_db,0);
    T_add_com_dic_cr := T_add_com_dic_cr + nvl(curc.add_com_dic_cr,0);
    T_add_com_con_cr := T_add_com_con_cr + nvl(curc.add_com_con_cr,0);
    T_acc_add_com_dic_db := T_acc_add_com_dic_db + nvl(curc.acc_add_com_dic_db,0);
    T_acc_add_com_con_db := T_acc_add_com_con_db + nvl(curc.acc_add_com_con_db,0);
    T_irpef_1r       := T_irpef_1r       + nvl(curc.acc1_irpef_dic,0);
    T_irpef_1r_con   := T_irpef_1r_con   + nvl(curc.acc1_irpef_con,0);
    T_irpef_2r       := T_irpef_2r       + nvl(curc.acc2_irpef_dic,0);
    T_irpef_2r_con   := T_irpef_2r_con   + nvl(curc.acc2_irpef_con,0);
    T_irpef_ap       := T_irpef_ap       + nvl(curc.irpef_acconto_ap,0);
    T_irpef_ap_con   := T_irpef_ap_con   + nvl(curc.irpef_acconto_ap_con,0) ;
 EXCEPTION        -- 7
    WHEN SALTA THEN
        D_riga_e := nvl(D_riga_e,0) + 1;
 END;
 commit;
-- dbms_output.put_line('fine loop curc');
 END LOOP; -- curc
   BEGIN
/* Inserimento righe dei totali su apst per stampa utente */
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',(132-length('TOTALI CARICAMENTO DATI CAAF'||D_nome_caaf))/2,' ')
           ||'TOTALI CARICAMENTO DATI CAAF: '||D_nome_caaf
         from dual
      ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad('-',132,'-')
         from dual
      ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
      ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      D_descr_errore := substr(si4.GET_ERROR('P05847'),instr(si4.GET_ERROR('A00002'),']')+2); -- Totale IRPEF   :
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(D_descr_errore,30,' ')||
             rpad('Debito Dichiarante ',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_db),11,' ')||
             lpad(' ',5,' ')||
             rpad('Credito Dichiarante ',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_cr),11,' ')
         from dual
      ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad(' ',7,' ')||rpad('Coniuge',23,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_db_con),11,' ')||
             lpad(' ',5,' ')||
             rpad(' ',8,' ')||rpad('Coniuge ',22,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_cr_con),11,' ')
       from dual
      ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_db_con+T_irpef_db),11,' ')||
             lpad(' ',5,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_cr_con+T_irpef_cr),11,' ')
       from dual
       ;       
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad('Acc. AP Dichiarante',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_ap),11,' ')
        from dual;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad(' ',8,' ')||rpad('Coniuge',22,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_ap_con),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_ap+T_irpef_ap_con),11,' ')
       from dual
       ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad('I Rata Dichiarante',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_1r),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad(' ',7,' ')||rpad('Coniuge',23,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_1r_con),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_1r+T_irpef_1r_con),11,' ')
       from dual
       ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad('II Rata Dichiarante',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_2r),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad(' ',8,' ')||rpad('Coniuge',22,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_2r_con),11,' ')
        from dual;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_irpef_2r+T_irpef_2r_con),11,' ')
       from dual
       ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      D_descr_errore := substr(si4.GET_ERROR('P05848'),instr(si4.GET_ERROR('P05848'),']')+2); -- Totale ADD.REG.:
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(D_descr_errore,30,' ')||
             rpad('Debito Dichiarante ',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_reg_dic_db),11,' ')||
             rpad(' ',5,' ')||
             rpad('Credito Dichiarante ',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_reg_dic_cr),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad(' ',7,' ')||rpad('Coniuge',23,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_reg_con_db),11,' ')||
             rpad(' ',5,' ')||
             rpad(' ',8,' ')||rpad('Coniuge ',22,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_reg_con_cr),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_reg_dic_db+T_add_reg_con_db),11,' ')||
             rpad(' ',5,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_reg_dic_cr+T_add_reg_con_cr),11,' ')
       from dual
       ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      D_descr_errore := substr(si4.GET_ERROR('P05851'),instr(si4.GET_ERROR('P05851'),']')+2); -- Totale ADD.COM.:
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(D_descr_errore,30,' ')||
             rpad('Debito Dichiarante ',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_com_dic_db),11,' ')||
             rpad(' ',5,' ')||
             rpad('Credito Dichiarante ',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_com_dic_cr),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad(' ',7,' ')||rpad('Coniuge ',23,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_com_con_db),11,' ')||
             rpad(' ',5,' ')||
             rpad(' ',8,' ')||rpad('Coniuge ',22,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_com_con_cr),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_com_dic_db+T_add_com_con_db),11,' ')||
             rpad(' ',5,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_add_com_dic_cr+T_add_com_con_cr),11,' ')
       from dual
       ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad('Acconto Dichiarante',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_acc_add_com_dic_db),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             rpad(' ',8,' ')||rpad('Coniuge',22,' ')||lpad(GP4EC.get_val_dec_stampa(T_acc_add_com_con_db),11,' ')
        from dual
        ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale:',30,' ')||lpad(GP4EC.get_val_dec_stampa(T_acc_add_com_dic_db+T_acc_add_com_con_db),11,' ')
       from dual
       ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('-',41,'-')||
             rpad(' ',5,' ')||
             lpad('-',41,'-')
         from dual
         ;         
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
       ;        
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(' ',30,' ')||
             lpad('Totale Importo a Debito ',30,' ')||
             lpad(GP4EC.get_val_dec_stampa( T_irpef_db + T_irpef_db_con + T_irpef_ap + T_irpef_ap_con
                                          + T_irpef_1r + T_irpef_1r_con + T_irpef_2r + T_irpef_2r_con 
                                          + T_add_reg_dic_db + T_add_reg_con_db
                                          + T_add_com_dic_db + T_add_com_con_db + T_acc_add_com_dic_db + T_acc_add_com_con_db
                                          ),11,' ')||
             rpad(' ',5,' ')||
             lpad('Totale Importo a Credito ',30,' ')||
             lpad(GP4EC.get_val_dec_stampa( T_irpef_cr + T_irpef_cr_con 
                                          + T_add_reg_dic_cr + T_add_reg_con_cr + T_add_com_dic_cr + T_add_com_con_cr
                                          ),11,' ')
         from dual
         ;
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , lpad(' ',132,' ')
         from dual
       ;
      D_descr_errore := substr(si4.GET_ERROR('P05849'),instr(si4.GET_ERROR('P05849'),']')+2);  -- Nr. dipendenti elaborati:
      D_riga_s := nvl(D_riga_s,0) + 1;
      insert into a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione
           , 1
           , 1
           , D_riga_s
           , rpad(D_descr_errore,30,' ')||to_char(T_ci)
         from dual
       ;
      commit;
   END;
END;
END;
-- dbms_output.put_line('fine loop caaf');
END LOOP; --caaf
EXCEPTION            -- 8
     WHEN ESCI THEN commit;
END;
EXCEPTION            -- 8
     WHEN USCITA THEN
     update a_prenotazioni
        set prossimo_passo = 91
          , errore         = 'P01069'
     where no_prenotazione = prenotazione
     ;
END;
END;
END;
/
