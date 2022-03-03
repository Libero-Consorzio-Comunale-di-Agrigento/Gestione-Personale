CREATE OR REPLACE PACKAGE PECCRAAD IS
/******************************************************************************
 NOME:        PECCRAAD
 DESCRIZIONE: Caricamento Rate Addizionali
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
     Il package prevede:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    25/11/2004 ML
 1.1  28/02/2007 ML     Inserisce acconti nulli e per questo il totale in stampa è nullo (A19947).
 1.2  05/03/2007 ML     Aggiunto controllo categoria fiscale (A19997)
 1.3  06/03/2007 ML     Gestione sospensione 97 (A20005)
 1.4  13/03/2007 ML     Gestione addizionale comunale con fasce di esenzione A19993)
 1.5  04/04/2007 ML     Gestione richiesta esenzione comunale (A20420)
 1.6  26/04/2007 ML     Creazione automatica sub voce, nuovi parametri,
                        Rateizzazione voci a saldo (A19870)
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
PROCEDURE ST_PARAMETRI (PRENOTAZIONE IN NUMBER
                        ,passo       IN NUMBER
                        ,d_gestione   IN VARCHAR2
                        ,d_des_gestione IN VARCHAR2
                        ,d_fascia     IN VARCHAR2
                        ,d_rapporto   IN VARCHAR2
                        ,d_des_rapporto IN VARCHAR2
                        ,d_gruppo     IN VARCHAR2
                        ,d_des_gruppo IN VARCHAR2
                        ,d_ci         IN NUMBER
                        ,d_nominativo IN VARCHAR2
                        ,d_mese       IN NUMBER
                        ,d_des_mese   IN VARCHAR2
                        ,d_tipo       IN VARCHAR2
                        ,d_tipo_rate  IN VARCHAR2
                        ,d_rate       IN NUMBER
                        ,d_riga       IN OUT NUMBER
                  );
PROCEDURE ST_VARIATI (PRENOTAZIONE IN NUMBER
                     ,passo        IN NUMBER
                     ,d_variati    IN OUT NUMBER
                     ,d_ci         IN NUMBER
                     ,d_importo    IN NUMBER
                     ,d_riga       IN OUT NUMBER
                     );
END;
/
CREATE OR REPLACE PACKAGE BODY PECCRAAD IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
    BEGIN
      RETURN 'V1.6  del 26/04/2007';
    END VERSIONE;
 PROCEDURE ST_PARAMETRI (prenotazione IN NUMBER
                        ,passo        IN NUMBER
                        ,d_gestione   IN VARCHAR2
                        ,d_des_gestione IN VARCHAR2
                        ,d_fascia     IN VARCHAR2
                        ,d_rapporto   IN VARCHAR2
                        ,d_des_rapporto IN VARCHAR2
                        ,d_gruppo     IN VARCHAR2
                        ,d_des_gruppo IN VARCHAR2
                        ,d_ci         IN NUMBER
                        ,d_nominativo IN VARCHAR2
                        ,d_mese       IN NUMBER
                        ,d_des_mese   IN VARCHAR2
                        ,d_tipo       IN VARCHAR2
                        ,d_tipo_rate  IN VARCHAR2
                        ,d_rate       IN NUMBER
                        ,d_riga       IN OUT NUMBER
                        )IS
   BEGIN
                  insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 1
                        , ' '
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 2
                        , ' '
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 3
                        , 'PARAMETRI DI ELABORAZIONE'
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 4
                        , ' '
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 5
                        , 'GESTIONE ...........: '||rpad(D_gestione,10,' ')||D_des_gestione
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 6
                        , 'FASCIA .............: '||D_fascia
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 7
                        , 'RAPPORTO ...........: '||rpad(D_rapporto,6,' ')||D_des_rapporto
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 8
                        , 'GRUPPO .............: '||rpad(D_gruppo,14,' ')||D_des_gruppo
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 9
                        , 'COD.IND. ...........: '||rpad(D_CI,10,' ')||D_nominativo
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 10
                        , 'TIPO RATEIZZAZIONE..: '||D_tipo_rate||'  '||decode(D_tipo_rate,'A','ACCONTO ANNO CORRENTE','SALDO ANNO PRECEDENTE')
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 11
                        , 'NUMERO RATE.........: '||D_rate
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 12
                        , 'MESE DECORRENZA RATE: '||lpad(D_mese,2,0)||' '||D_des_mese
                        );
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , 13
                        , 'TIPO ELABORAZIONE ..: '||D_tipo||'  '||decode(D_tipo,'T','INSERIMENTO E STAMPA','SOLO STAMPA')
                        );
                 D_riga := 13;
 END ST_PARAMETRI;
 PROCEDURE ST_VARIATI (prenotazione IN NUMBER
                      ,passo        IN NUMBER
                      ,d_variati    IN OUT NUMBER
                      ,d_ci         IN NUMBER
                      ,d_importo    IN NUMBER
                      ,d_riga       IN OUT NUMBER
                      ) IS
   BEGIN
   IF D_variati = 0 THEN
   D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , ' '
                        );
   D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , ' '
                        );
   D_riga := D_riga + 1;
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , ' '
                        );
   D_riga := D_riga + 1;
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , '*** SITUAZIONI RATEALI VARIATE ***'
                        );
   D_riga := D_riga + 1;
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , '----------------------------------'
                        );
   D_riga := D_riga + 1;
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , ' '
                        );
   D_riga := D_riga + 1;
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , 'COD.IND.   NOMINATIVO                       IMP.TOT.'
                        );
   D_riga := D_riga + 1;
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , '--------   ------------------------------   -------'
                        );
   END IF;
   D_riga := D_riga + 1;
                 insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 select prenotazione
                      , passo
                      , 1
                      , D_riga
                      , lpad(to_char(D_ci),8,' ')||'   '||rpad(substr(rain.cognome||'  '||rain.nome,1,30),30,' ')||'   '||lpad(to_char(d_importo),8,' ')
                   from rapporti_individuali rain
                  where ci = D_ci;
 END ST_VARIATI;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
  BEGIN
    DECLARE
      D_dummy         VARCHAR2(1);
      D_ctr           VARCHAR2(1);
      D_istruzione    VARCHAR2(1000);
      D_esiste_rata   VARCHAR2(1);
      D_variati       NUMBER;
      D_ente          VARCHAR2(4);
      D_ambiente      VARCHAR2(8);
      D_utente        VARCHAR2(8);
      D_anno          NUMBER(4);
      D_mese          NUMBER(2);
      D_des_mese      VARCHAR2(20);
      D_gestione      VARCHAR2(8);
      D_des_gestione  VARCHAR2(40);
      D_fascia        VARCHAR2(1);
      D_rapporto      VARCHAR2(4);
      D_des_rapporto  VARCHAR2(30);
      D_gruppo        VARCHAR2(12);
      D_des_gruppo    VARCHAR2(30);
      D_tipo          VARCHAR2(1);
      D_ci            NUMBER(8);
      D_rate          NUMBER(2);
      D_tipo_rate     VARCHAR2(1);
      D_nominativo    VARCHAR2(40);
      D_voce          VARCHAR2(10);
      D_sequenza      NUMBER;
      D_sub           VARCHAR2(2);
      D_istituto      VARCHAR2(5);
      D_aliquota      NUMBER;
      D_imp_comu      NUMBER;
      D_valore_comu  NUMBER;
      D_tot_dip       NUMBER := 0;
      D_ins_comu      NUMBER := 0;
      D_tot_comu      NUMBER := 0;
      D_riga          NUMBER;
      D_ipt_pag       NUMBER;
      D_ipn_add       NUMBER;
      D_esenzione     NUMBER;
      D_scaglione     NUMBER;
      D_imposta       NUMBER;
      D_ci_esente     VARCHAR2(2);
      --exception
      uscita          EXCEPTION;
      BEGIN
        BEGIN
          SELECT valore
            INTO  D_gestione
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_GESTIONE'
          ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_gestione := '%';
        END;
        BEGIN
          SELECT valore
            INTO D_fascia
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_FASCIA'
         ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_fascia := '%';
        END;
        BEGIN
          SELECT valore
            INTO D_rapporto
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_RAPPORTO'
          ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_rapporto := '%';
        END;
        BEGIN
          SELECT valore
            INTO D_gruppo
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_GRUPPO'
          ;
        EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    D_gruppo := '%';
        END;
        BEGIN
          SELECT valore
            INTO D_ci
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_CI'
          ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_ci := null;
        END;
        BEGIN
          SELECT to_number(substr(valore,1,2))
            INTO D_mese
           	FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_MESE'
          ;
        END;
        BEGIN
          SELECT valore
            INTO D_tipo
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_TIPO'
          ;
        EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    D_tipo := 'T';
        END;
        BEGIN
          SELECT valore
            INTO D_rate
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_RATE'
          ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_rate := null;
        END;
        BEGIN
          SELECT valore
            INTO D_tipo_rate
            FROM a_parametri
           WHERE no_prenotazione = prenotazione
             AND parametro       = 'P_TIPO_RATE'
          ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_tipo_rate := null;
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
          select nome
            into D_des_gestione
            from gestioni
           where instr(D_gestione,'%') = 0
             and codice = D_gestione;
        EXCEPTION WHEN NO_DATA_FOUND THEN null;
        END;
        BEGIN
          select descrizione
            into D_des_rapporto
            from classi_rapporto
           where instr(D_rapporto,'%') = 0
             and codice = D_rapporto;
        EXCEPTION WHEN NO_DATA_FOUND THEN null;
        END;
        BEGIN
          select descrizione
            into D_des_gruppo
            from gruppi_rapporto
           where instr(D_gruppo,'%') = 0
             and gruppo = D_gruppo;
        EXCEPTION WHEN NO_DATA_FOUND THEN null;
        END;
        BEGIN
          select upper(substr(rv_meaning,1,20))
            into D_des_mese
            from pec_ref_codes
           where rv_domain = 'CALENDARI.MESE'
             and rv_low_value = D_mese;
        EXCEPTION WHEN NO_DATA_FOUND THEN null;
        END;
        BEGIN
          select substr(cognome||'  '||nome,1,40)
            into D_nominativo
            from rapporti_individuali
           where ci = D_ci
             and D_ci is not null;
        EXCEPTION WHEN NO_DATA_FOUND THEN null;
        END;
        BEGIN
          select anno
            into D_anno
            from riferimento_retribuzione;
        END;
     IF D_tipo = 'T' THEN
        IF d_tipo_rate = 'A' THEN
            BEGIN
              select codice,sequenza,sub,istituto
                into D_voce,D_sequenza,D_sub,D_istituto
                from voci_economiche, contabilita_voce
               where specifica = 'ADD_COM_AC'
                 and voce = codice
                 and sub = substr(D_anno,3,2);
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                       select   'insert into voci_contabili (voce,sub,alias,titolo) values (''ADD.COM.AC'',substr('||D_anno
                              ||',3,2),''ADDCOMAC'||substr(D_anno,3,2)||''',''ADDIZIONALE COMUNALE ACC. '||D_anno||''')'
                         into D_istruzione
                         from dual
                       ;
                       si4.sql_execute(D_istruzione);
                       BEGIN
                         select 'x'
                           into D_ctr
                           from contabilita_voce
                          where voce = (select codice from voci_economiche
                                         where specifica = 'ADD_COM_AC')
                            and sub = lpad(to_number(substr(D_anno,3,2)) - 1,2,'0');
                         select 'insert into contabilita_voce (voce,sub,descrizione,des_abb,fiscale,stampa_fr
                                ,stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp,bilancio,istituto)
                                select voce,'''||substr(to_char(D_anno),3,2)||''',replace(descrizione,'||to_char(D_anno-1)||','||to_char(D_anno)||'),des_abb,fiscale,stampa_fr
                                     , stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp
                                     , bilancio,istituto
                                  from contabilita_voce
                                 where voce = (select codice from voci_economiche
                                                where specifica = ''ADD_COM_AC'')
                                                  and sub = lpad(to_number('''||substr(D_anno,3,2)||''') - 1,2,''0'')'
                           into D_istruzione
                           from dual;
                         si4.sql_execute(D_istruzione);
                       EXCEPTION WHEN NO_DATA_FOUND THEN
                                 select 'insert into contabilita_voce (voce,sub,descrizione,des_abb,fiscale,stampa_fr
                                         ,stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp,bilancio,istituto) values (''ADD.COM.AC'','''
                                        ||substr(to_char(D_anno),3,2)||''',''ADDIZIONALE IRPEF COMUNALE ACC'',''A'',''N'',''F'',''T'',''Q'',''I'',''Q'',''N'',''I'',''99'',''ADFS'')'
                                   into D_istruzione
                                   from dual;
                                 si4.sql_execute(D_istruzione);
                       END;
             END;
             BEGIN
              select codice,sequenza,sub,istituto
                into D_voce,D_sequenza,D_sub,D_istituto
                from voci_economiche, contabilita_voce
               where specifica = 'ADD_COM_AC'
                 and voce = codice
                 and sub = substr(D_anno,3,2);
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN null;
             END;
         ELSE
            BEGIN
               select 'update voci_economiche set memorizza = ''P''
                       where memorizza != ''P'' and specifica = ''ADD_COM_RA'''
                 into D_istruzione
                 from dual
               ;
               si4.sql_execute(D_istruzione);
            END;
            BEGIN
              select codice,sequenza,sub,istituto
                into D_voce,D_sequenza,D_sub,D_istituto
                from voci_economiche, contabilita_voce
               where specifica = 'ADD_COM_RA'
                 and voce = codice
                 and sub = substr(D_anno,3,2);
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                       select   'insert into voci_contabili (voce,sub,alias,titolo) values (''ADD.COM.RA'',substr('||D_anno
                              ||',3,2),''ADDCOMRA'||substr(D_anno,3,2)||''',''ADDIZIONALE COMUNALE RAT. '||D_anno||''')'
                         into D_istruzione
                         from dual
                       ;
                       si4.sql_execute(D_istruzione);
                       D_ctr := null;
                       BEGIN
                         select 'x'
                           into D_ctr
                           from contabilita_voce
                          where voce = (select codice from voci_economiche
                                         where specifica = 'ADD_COM_RA')
                            and sub = lpad(to_number(substr(D_anno,3,2)) - 1,2,'0');
                         select 'insert into contabilita_voce (voce,sub,descrizione,des_abb,fiscale,stampa_fr
                                ,stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp,bilancio,istituto)
                                select voce,'''||substr(to_char(D_anno),3,2)||''',replace(descrizione,'||to_char(D_anno-1)||','||to_char(D_anno)||'),des_abb,fiscale,stampa_fr
                                     , stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp
                                     , bilancio,istituto
                                  from contabilita_voce
                                 where voce = (select codice from voci_economiche
                                                where specifica = ''ADD_COM_RA'')
                                                  and sub = lpad(to_number('''||substr(D_anno,3,2)||''') - 1,2,''0'')'
                           into D_istruzione
                           from dual;
                         si4.sql_execute(D_istruzione);
                       EXCEPTION WHEN NO_DATA_FOUND THEN
                                 BEGIN
                                   select 'x'
                                     into D_ctr
                                     from contabilita_voce
                                    where voce = (select codice from voci_economiche
                                                   where specifica = 'ADD_COM_RA')
                                      and sub = '*';
                                   select 'insert into contabilita_voce (voce,sub,descrizione,des_abb,fiscale,stampa_fr
                                          ,stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp,bilancio,istituto)
                                          select voce,'''||substr(to_char(D_anno),3,2)||''',replace(descrizione,'||to_char(D_anno-1)||','||to_char(D_anno)||'),des_abb,fiscale,stampa_fr
                                               , stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp
                                               , bilancio,istituto
                                            from contabilita_voce
                                           where voce = (select codice from voci_economiche
                                                          where specifica = ''ADD_COM_RA'')
                                                            and sub = ''*'''
                                     into D_istruzione
                                     from dual;
                                   si4.sql_execute(D_istruzione);
                                 EXCEPTION WHEN NO_DATA_FOUND THEN
                                 select 'insert into contabilita_voce (voce,sub,descrizione,des_abb,fiscale,stampa_fr
                                        ,stampa_tar,stampa_qta,stampa_imp,starie_tar,starie_qta,starie_imp,bilancio,istituto) values (''ADD.COM.RA'','''
                                        ||substr(to_char(D_anno),3,2)||''',''ADDIZIONALE IRPEF COMUNALE RAT'',''A'',''N'',''F'',''T'',''Q'',''I'',''Q'',''N'',''I'',''99'',''ADFS'')'
                                   into D_istruzione
                                   from dual;
                                 si4.sql_execute(D_istruzione);
                                 END;
                       END;
            END;
            BEGIN
              select codice,sequenza,sub,istituto
                into D_voce,D_sequenza,D_sub,D_istituto
                from voci_economiche, contabilita_voce
               where specifica = 'ADD_COM_RA'
                 and voce = codice
                 and sub = substr(D_anno,3,2);
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN null;
            END;
         END IF;
      END IF;
          ST_PARAMETRI (prenotazione
                       ,passo
                       ,d_gestione
                       ,d_des_gestione
                       ,d_fascia
                       ,d_rapporto
                       ,d_des_rapporto
                       ,d_gruppo
                       ,d_des_gruppo
                       ,d_ci
                       ,d_nominativo
                       ,d_mese
                       ,d_des_mese
                       ,d_tipo
                       ,d_tipo_rate
                       ,d_rate
                       ,D_riga
                       );
        BEGIN
          select 'x'
            into D_dummy
            from dual
            where not exists
                 (select 'x'
                    from movimenti_contabili
                   where anno  = D_anno
                     and voce  = D_voce
                     and sub   = D_sub
                     and ci  in (select ci from rapporti_giuridici
                                  where gestione in
                                       (select codice from gestioni
                                         where codice like D_gestione
                                           and nvl(fascia,'%') like D_fascia
                                       )
                                )
                     and ci  in (select ci from rapporti_individuali
                                  where rapporto like D_rapporto
                                    and nvl(gruppo,'%') like D_gruppo
                                    and (   cc is null
                                         or exists
                                           (select 'x'
                                              from a_competenze
                                             where ente       = D_ente
                                               and ambiente   = D_ambiente
                                               and utente     = D_utente
                                               and competenza = 'CI'
                                               and oggetto    = cc
                                            )
                                         )
                                )
                     and ci   = nvl(D_ci,ci)
                  )
               and D_tipo_rate = 'A'
          union
          select 'x'
            from dual
            where D_tipo_rate = 'S';
           BEGIN
             select 'x'
               into D_esiste_rata
               from dual
              where exists
                   (select 'x' from movimenti_contabili
                      where D_tipo_rate = 'S'
                        and anno = D_anno
                        and voce  = D_voce
                        and sub   = D_sub
                        and ci  in (select ci from rapporti_giuridici
                                     where gestione in
                                          (select codice from gestioni
                                            where codice like D_gestione
                                              and nvl(fascia,'%') like D_fascia
                                          )
                                   )
                        and ci  in (select ci from rapporti_individuali
                                     where rapporto like D_rapporto
                                       and nvl(gruppo,'%') like D_gruppo
                                       and (   cc is null
                                            or exists
                                              (select 'x'
                                                 from a_competenze
                                                where ente       = D_ente
                                                  and ambiente   = D_ambiente
                                                  and utente     = D_utente
                                                  and competenza = 'CI'
                                                  and oggetto    = cc
                                               )
                                            )
                                   )
                        and ci   = nvl(D_ci,ci));
           EXCEPTION WHEN NO_DATA_FOUND THEN D_esiste_rata := null;
           END;
             delete from informazioni_retributive inre
              where ci in (select ci from rapporti_giuridici
                            where gestione in
                                 (select codice from gestioni
                                   where codice like D_gestione
                                     and nvl(fascia,'%') like D_fascia
                                 )
                          )
                and ci  in (select ci from rapporti_individuali rain
                             where rapporto like D_rapporto
                               and nvl(gruppo,'%') like D_gruppo
                               and (   cc is null
                                    or exists
                                      (select 'x'
                                         from a_competenze
                                        where ente       = D_ente
                                          and ambiente   = D_ambiente
                                          and utente     = D_utente
                                          and competenza = 'CI'
                                          and oggetto    = rain.cc
                                       )
                                   )
                           )
                and ci     = nvl(D_ci,inre.ci)
                and voce   = D_voce
                and sub    = D_sub
                and D_tipo = 'T'
                and (    D_tipo_rate = 'A'
                     or (    D_tipo_rate = 'S'
                         and D_esiste_rata is null));
           D_variati := 0;
           BEGIN
             FOR CUR_CI IN
                (select ragi.ci, cost.gg_lavoro
                   from rapporti_giuridici          ragi
                      , contratti_storici           cost
                  where ragi.ci              = nvl(D_ci,ragi.ci)
                    and ragi.contratto = cost.contratto
                    and last_day(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')) between cost.dal and nvl(cost.al,to_date('3333333','j'))
                    and ragi.gestione in
                          (select codice from gestioni
                            where codice like D_gestione
                              and nvl(fascia,'%') like D_fascia
                          )
                    and ragi.ci  in (select ci from rapporti_individuali rain
                                      where rapporto like D_rapporto
                                        and nvl(gruppo,'%') like D_gruppo
                                        and exists
                                           (select 'x' FROM classi_rapporto
                                             where codice = rapporto
                                               and cat_fiscale IN ('1','2','15','25')
                                            )
                                        and (   cc is null
                                             or exists
                                               (select 'x'
                                                  from a_competenze
                                                 where ente       = D_ente
                                                   and ambiente   = D_ambiente
                                                   and utente     = D_utente
                                                   and competenza = 'CI'
                                                   and oggetto    = rain.cc
                                               )
                                            )
                                    )
                    and exists (select 'x'
                                  from periodi_giuridici
                                 where ci = ragi.ci
                                   and rilevanza = 'P'
                                   and (   (     to_date('0101'||D_anno,'ddmmyyyy') between dal
                                                                                        and nvl(al,to_date('3333333','j'))
                                             and D_Anno > 2007)
                                        or (     to_date('01'||lpad(D_mese,2,0)||D_anno,'ddmmyyyy') between dal
                                                                                           and nvl(al,to_date('3333333','j'))
                                             and D_Anno = 2007)
                                       )
                               )
                ) LOOP
                    D_tot_dip := D_tot_dip + 1;
                    D_valore_comu := 0;
                    BEGIN
                    D_ci_esente := gp4_inex.get_esente_comu(cur_ci.ci,D_anno);
                    BEGIN
                      select greatest( nvl(sum(ipn_ac),0) - sum(nvl(ded_con_ac,0)+nvl(ded_fig_ac,0)+nvl(ded_alt_ac,0))
                                     , 0
                                     )
                           , sum(ipt_pag)
                        into D_ipn_add
                           , D_ipt_pag
                        from progressivi_fiscali
                       where anno      = D_anno - 1
                         and mese      = 12
                         and mensilita = (select max(mensilita)
                                            from mensilita
                                           where mese = 12
                                             and tipo in ('S','N','A'))
                         and ci = cur_ci.ci;
                     EXCEPTION WHEN NO_DATA_FOUND THEN D_ipt_pag := null;
                                                       D_ipn_add := null;
                     END;
dbms_output.put_line('***D_ci_esente '||D_ci_esente||' P_esenzione '||D_esenzione);
                     IF D_tipo_rate = 'A' THEN
                        IF nvl(D_ipn_add,0) != 0 and (D_ipt_pag != 0 or D_ipt_pag is null ) THEN
                        begin
                           peccmore_addizionali.get_alq_comup(cur_ci.ci, D_anno,
                                                              last_day(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')),
                                                              D_ipn_add, D_aliquota, D_esenzione, D_scaglione, D_imposta);
--                    D_aliquota := peccmore_addizionali.get_alq_comu( cur_ci.ci
--                                                                   , D_anno
--                                                                     , last_day(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy'))
--                                                                     );
 dbms_output.put_line('D_ci_esente '||D_ci_esente||' P_esenzione '||D_esenzione);
                           IF  D_ci_esente = 'NO' THEN
                               D_esenzione := 0;
                           END IF;
dbms_output.put_line('D_ipn_add '||D_ipn_add||' P_esenzione '||D_esenzione);
                           IF nvl(D_aliquota,0) != 0 and nvl(D_ipn_add,0) > nvl(D_esenzione,0) THEN
                              D_imp_comu := peccmore_addizionali.get_add_comu( D_ipn_add - D_scaglione, D_aliquota)
                                                                 + D_imposta;
                              D_valore_comu := e_round(D_imp_comu * 30 / 100,'I');
-- conto i dip. inseriti se parametro solo stampa
                              IF D_tipo = 'S' and nvl(D_valore_comu,0) != 0 THEN
                                 D_ins_comu := D_ins_comu + 1;
                              END IF;
                              D_tot_comu := nvl(D_tot_comu,0) + nvl(D_valore_comu,0);
                           ELSE -- dipendenti che NON devono pagare l'acconto
                              D_valore_comu := 0;
                           END IF;
                           end;
                        END IF;
                     ELSE
                     BEGIN
                       select NVL(SUM(imp),0)
                         into D_valore_comu
                         from movimenti_contabili
                        where anno      = D_anno
                          and mese      = 1
                          and mensilita = '*AP'
                          and ci        = cur_ci.ci
                          and voce      =
                             (select codice from voci_economiche
                               where specifica = 'ADD_COM_SO')
                       group by ci
                       ;
                     EXCEPTION WHEN NO_DATA_FOUND THEN
                               D_valore_comu := null;
                     END;
-- conto i dip. inseriti se parametro solo stampa
                       IF D_tipo = 'S' and nvl(D_valore_comu,0) != 0 THEN
                          D_ins_comu := D_ins_comu + 1;
                       END IF;
                     D_tot_comu := nvl(D_tot_comu,0) + nvl(D_valore_comu,0);
                     END IF;
dbms_output.put_line('D_imp_comu '||D_imp_comu||' D_valore_comu '||D_valore_comu);
dbms_output.put_line('D_tipo '||D_tipo||' D_valore_comu '||D_valore_comu||' D_tipo_rate '||D_tipo_rate||' D_esiste_rata '||D_esiste_rata);
-- Se tipo rata A inserisce sempre (ha fatto la delete prima), altrimenti inserisce sempre solo
-- se è la prima volta, cioè se NON esistono rate pagate
                     IF D_tipo = 'T' and nvl(D_valore_comu,0) != 0
                        and (D_tipo_rate = 'A' or D_esiste_rata is null) THEN
dbms_output.put_line('passo da insert 1 '||cur_ci.ci);
                        insert into informazioni_retributive
                                  ( ci
                                  , voce
                                  , sub
                                  , sequenza_voce
                                  , tariffa
                                  , dal
                                  , al
                                  , tipo
                                  , sospensione
                                  , imp_tot
                                  , rate_tot
                                  , note
                                  , istituto
                                  , utente
                                  , data_agg
                                  )
                           values ( cur_ci.ci
                                  , D_voce
                                  , D_sub
                                  , D_sequenza
                                  , e_round((D_valore_comu / nvl(D_rate,decode(D_tipo_rate,'A',9,11))),'I')
                                  , to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                  , last_day(add_months(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                                       ,nvl(D_rate,decode(D_tipo_rate,'A',9,11))-1))
                                  , 'R'
                                  , decode(cur_ci.gg_lavoro,0,97,98)
                                  , D_valore_comu
                                  , nvl(D_rate,decode(D_tipo_rate,'A',9,11))
                                  , 'Inserimento automatico fase CRAAD - Prenotazione n. '
                                    ||prenotazione||' del '||to_char(trunc(sysdate),'dd/mm/yyyy')
                                  , D_istituto
                                  , 'AUTO'
                                  , sysdate
                                  );
                              D_ins_comu := D_ins_comu + 1;
--                       ELSIF D_tipo = 'T' and D_tipo_rate = 'S' or D_esiste_rata is not null and D_valore_comu != 0 THEN
                       ELSIF D_tipo = 'T' and D_tipo_rate = 'S' and D_esiste_rata is not null THEN
dbms_output.put_line('passo da qui '||cur_ci.ci);
                            delete from informazioni_retributive inre
                             where ci       = cur_ci.ci
                               and voce     = D_voce
                               and sub      = D_sub
                               and (   imp_tot  != D_valore_comu
                                    or rate_tot != nvl(D_rate,decode(D_tipo_rate,'A',9,11))
                                   )
                            ;
                       IF SQL%FOUND THEN
                          ST_VARIATI(prenotazione,passo,d_variati,cur_ci.ci,D_valore_comu,D_riga);
                          D_variati := D_variati + 1;
dbms_output.put_line('passo da insert 2 '||cur_ci.ci);
                        insert into informazioni_retributive
                                  ( ci
                                  , voce
                                  , sub
                                  , sequenza_voce
                                  , tariffa
                                  , dal
                                  , al
                                  , tipo
                                  , sospensione
                                  , imp_tot
                                  , rate_tot
                                  , note
                                  , istituto
                                  , utente
                                  , data_agg
                                  )
                           values ( cur_ci.ci
                                  , D_voce
                                  , D_sub
                                  , D_sequenza
                                  , e_round((D_valore_comu / nvl(D_rate,decode(D_tipo_rate,'A',9,11))),'I')
                                  , to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                  , last_day(add_months(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                                       ,nvl(D_rate,decode(D_tipo_rate,'A',9,11))-1))
                                  , 'R'
                                  , decode(cur_ci.gg_lavoro,0,97,98)
                                  , D_valore_comu
                                  , nvl(D_rate,decode(D_tipo_rate,'A',9,11))
                                  , 'Inserimento automatico fase CRAAD - Prenotazione n. '
                                    ||prenotazione||' del '||to_char(trunc(sysdate),'dd/mm/yyyy')
                                  , D_istituto
                                  , 'AUTO'
                                  , sysdate
                                  );
                              D_ins_comu := D_ins_comu + 1;
                            ELSE
dbms_output.put_line('passo da insert 2-bis '||cur_ci.ci);
                        insert into informazioni_retributive
                                  ( ci
                                  , voce
                                  , sub
                                  , sequenza_voce
                                  , tariffa
                                  , dal
                                  , al
                                  , tipo
                                  , sospensione
                                  , imp_tot
                                  , rate_tot
                                  , note
                                  , istituto
                                  , utente
                                  , data_agg
                                  )
                           select cur_ci.ci
                                , D_voce
                                , D_sub
                                , D_sequenza
                                , e_round((D_valore_comu / nvl(D_rate,decode(D_tipo_rate,'A',9,11))),'I')
                                , to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                , last_day(add_months(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                                     ,nvl(D_rate,decode(D_tipo_rate,'A',9,11))-1))
                                , 'R'
                                , decode(cur_ci.gg_lavoro,0,97,98)
                                , D_valore_comu
                                , nvl(D_rate,decode(D_tipo_rate,'A',9,11))
                                , 'Inserimento automatico fase CRAAD - Prenotazione n. '
                                  ||prenotazione||' del '||to_char(trunc(sysdate),'dd/mm/yyyy')
                                , D_istituto
                                , 'AUTO'
                                , sysdate
                             from dual
                            where not exists
                                 (select 'x' from informazioni_retributive
                                   where ci   = cur_ci.ci
                                     and voce = D_voce
                                     and sub  = D_sub
                                 )
                              and nvl(D_valore_comu,0) != 0;
                       IF SQL%FOUND THEN
dbms_output.put_line('conto insert 3 '||cur_ci.ci);
                              D_ins_comu := D_ins_comu + 1;
                       END IF;
                            END IF;
                            ELSIF D_tipo = 'T' and D_tipo_rate = 'S' and D_valore_comu is not null THEN
dbms_output.put_line('passo da insert 3 '||cur_ci.ci);
                             insert into informazioni_retributive
                                  ( ci
                                  , voce
                                  , sub
                                  , sequenza_voce
                                  , tariffa
                                  , dal
                                  , al
                                  , tipo
                                  , sospensione
                                  , imp_tot
                                  , rate_tot
                                  , note
                                  , istituto
                                  , utente
                                  , data_agg
                                  )
                           values ( cur_ci.ci
                                  , D_voce
                                  , D_sub
                                  , D_sequenza
                                  , e_round((D_valore_comu / nvl(D_rate,decode(D_tipo_rate,'A',9,11))),'I')
                                  , to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                  , last_day(add_months(to_date(lpad(D_mese,2,0)||D_anno,'mmyyyy')
                                                       ,nvl(D_rate,decode(D_tipo_rate,'A',9,11))-1))
                                  , 'R'
                                  , decode(cur_ci.gg_lavoro,0,97,98)
                                  , D_valore_comu
                                  , nvl(D_rate,decode(D_tipo_rate,'A',9,11))
                                  , 'Inserimento automatico fase CRAAD - Prenotazione n. '
                                    ||prenotazione||' del '||to_char(trunc(sysdate),'dd/mm/yyyy')
                                  , D_istituto
                                  , 'AUTO'
                                  , sysdate
                                  );
                              D_ins_comu := D_ins_comu + 1;
                            END IF;
--                       END IF;
                    END;
                  END LOOP;
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , ' '
                        );
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , ' '
                        );
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                        ( no_prenotazione
                        , no_passo
                        , pagina
                        , riga
                        , testo)
                 values ( prenotazione
                        , passo
                        , 1
                        , D_riga
                        , ' '
                        );
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                         ( no_prenotazione
                         , no_passo
                         , pagina
                         , riga
                         , testo)
                  values ( prenotazione
                         , passo
                         , 1
                         , D_riga
                         , 'Dip.Analizzati'||'  '||
                           'Rate Inserite'||'  '||
                           'Tot.Add.Comunale'
                         );
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                         ( no_prenotazione
                         , no_passo
                         , pagina
                         , riga
                         , testo)
                  values ( prenotazione
                         , passo
                         , 1
                         , D_riga
                         , '--------------'||'  '||
                           '-------------'||'  '||
                           '----------------'
                         );
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                         ( no_prenotazione
                          , no_passo
                         , pagina
                         , riga
                          , testo)
                  values ( prenotazione
                         , passo
                         , 1
                         , D_riga
                         , ' '
                         );
                  D_riga := D_riga + 1;
                  insert into a_appoggio_stampe
                         ( no_prenotazione
                         , no_passo
                         , pagina
                         , riga
                         , testo)
                  values ( prenotazione
                         , passo
                         , 1
                         , D_riga
                         , lpad(to_char(D_tot_dip),14,' ')||'  '||
                           lpad(to_char(D_ins_comu),13,' ')||'  '||
                           lpad(to_char(D_tot_comu),16,' ')
                         );
            END;
         EXCEPTION WHEN NO_DATA_FOUND THEN
                   BEGIN
                     D_riga := D_riga + 1;
                     insert into a_appoggio_stampe
                           ( no_prenotazione
                           , no_passo
                           , pagina
                           , riga
                           , testo)
                    values ( prenotazione
                           , passo
                           , 1
                           , D_riga
                           , ' '
                           );
                     D_riga := D_riga + 1;
                     insert into a_appoggio_stampe
                           ( no_prenotazione
                           , no_passo
                           , pagina
                           , riga
                           , testo)
                    values ( prenotazione
                           , passo
                           , 1
                           , D_riga
                           , ' '
                           );
                     D_riga := D_riga + 1;
                     insert into a_appoggio_stampe
                           ( no_prenotazione
                           , no_passo
                           , pagina
                           , riga
                           , testo)
                    values ( prenotazione
                           , passo
                           , 1
                           , D_riga
                           , ' '
                           );
                     D_riga := D_riga + 1;
                    insert into a_appoggio_stampe
                           ( no_prenotazione
                           , no_passo
                           , pagina
                           , riga
                           , testo)
                    values ( prenotazione
                           , passo
                           , 1
                           , D_riga
                           , 'VOCI DI ACCONTO ADDIZIONALE GIA'' LIQUIDATE'
                           );
                     D_riga := D_riga + 1;
                    insert into a_appoggio_stampe
                           ( no_prenotazione
                           , no_passo
                           , pagina
                           , riga
                           , testo)
                    values ( prenotazione
                           , passo
                           , 1
                           , D_riga
                           , ' '
                           );
                     D_riga := D_riga + 1;
                    insert into a_appoggio_stampe
                           ( no_prenotazione
                           , no_passo
                           , pagina
                           , riga
                           , testo)
                    values ( prenotazione
                           , passo
                           , 1
                           , D_riga
                           , 'MESE'||'  '||'MENS.'||'  '||'COD.IND.'||'  '||
                             rpad('COGNOME NOME',40,' ')||'  '||
                             rpad('VOCE',10,' ')||'  '||'SUB'||'  '||'RIFERIMENTO'||'  '||
                             'IMPORTO'
                           );
                     D_riga := D_riga + 1;
                    insert into a_appoggio_stampe
                           ( no_prenotazione
                           , no_passo
                           , pagina
                           , riga
                           , testo)
                    values ( prenotazione
                           , passo
                           , 1
                           , D_riga
                           , '----'||'  '||'-----'||'  '||'--------'||'  '||
                             rpad('-',40,'-')||'  '||lpad('-',10,'-')||'  '||'---'||'  '||
                             lpad('-',11,'-')||'  '||'-------'
                           );
                     D_riga := D_riga + 1;
                     FOR CUR_S IN
                        (select moco.mese,moco.mensilita,moco.ci
                              , substr(rain.cognome||'  '||rain.nome,1,40) nominativo
                              , moco.voce,moco.sub,moco.riferimento,moco.imp
                           from movimenti_contabili moco
                              , rapporti_individuali rain
                          where moco.anno  = D_anno
                            and moco.voce  = D_voce
                            and moco.sub   = D_sub
                            and moco.ci    = rain.ci
                            and rain.ci    = nvl(D_ci,rain.ci)
                            and rain.ci  in
                               (select ci from rapporti_giuridici
                                 where gestione in
                                      (select codice from gestioni
                                        where codice like D_gestione
                                          and nvl(fascia,'%') like D_fascia
                                      )
                               )
                            and rapporto like D_rapporto
                            and nvl(gruppo,'%') like D_gruppo
                            and (   cc is null
                                 or exists
                                   (select 'x'
                                      from a_competenze
                                     where ente       = D_ente
                                       and ambiente   = D_ambiente
                                       and utente     = D_utente
                                       and competenza = 'CI'
                                       and oggetto    = rain.cc
                                   )
                                )
                          order by 1,4
                        ) LOOP
                            insert into a_appoggio_stampe
                                  ( no_prenotazione
                                  , no_passo
                                  , pagina
                                  , riga
                                  , testo)
                           values ( prenotazione
                                  , passo
                                  , 1
                                  , D_riga
                                  , lpad(cur_s.mese,4,' ')||'  '||
                                    lpad(cur_s.mensilita,5,' ')||'  '||
                                    lpad(cur_s.ci,8,' ')||'  '||
                                    rpad(cur_s.nominativo,40,' ')||'  '||
                                    rpad(cur_s.voce,10,' ')||'  '||
                                    rpad(cur_s.sub,3,' ')||'  '||
                                    rpad(to_char(cur_s.riferimento,'dd/mm/yyyy'),11,' ')||'  '||
                                    rpad(cur_s.imp,7,' ')
                                  );
                                  D_riga:= D_riga + 1;
                          END LOOP;
                   END;
                   update a_prenotazioni
                      set errore = 'Addizionali in acconto pagate: fase non eseguita'
                    where no_prenotazione = prenotazione;
                   raise uscita;
        END;
--         EXCEPTION WHEN NO_DATA_FOUND THEN
--                   update a_prenotazioni
--                      set errore = 'Sub voce '||substr(D_Anno,3,2)||' non definito: fase non eseguita'
--                    where no_prenotazione = prenotazione;
--                   raise uscita;
--        END;
      EXCEPTION WHEN USCITA THEN
                commit;
      END;
  END;
END;
/
