CREATE OR REPLACE PACKAGE PECCCAAF IS
/******************************************************************************
 NOME:        PECCCAAF
 DESCRIZIONE: Creazione delle registrazioni mensili derivanti dalla denuncia IRPEF
              Mod.730.
              Questa funzione inserisce nella tavola MOVIMENTI_CONTABILI le registra-
              zioni derivanti dalla denuncia IRPEF effettuata attraverso i CAAF con la
              compilazione del Mod.730.
              Nel caso in cui risultino importi IRPEF e SSN da addebitare, la funzione
              in oggetto dovra` essere eseguita due volte nel corso dell'anno, e preci-
              samente, prima dell'elaborazione dei cedolini dei mesi relativi alla
              scadenza dei DUE acconti da versare.
              In occasione della prima elaborazione dovranno essere specificati la men-
              silita` di riferimento, le voci in accredito e le voci in addebito, avendo
              cura per queste ultime di comunicare SOLTANTO la voce di totale e la voce
              relativa alla PRIMA rata di acconto.
              In occasione della seconda elaborazione dovranno essere comunicate la men-
              silita` di riferimento e le voci in addebito inerenti alla SECONDA rata.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.1  20/01/2003             
 1.2  16/07/2004 ML     -Gestione data_ricezione in delete
                        -Separazione delle delete tra passaggio prime variabili e 
                         passaggio seconde rate (novembre)
                        -Aggiunte le voci mancanti (quelle a rate) alla prima delete
                        -Estrazione codice voce per voci a rate come per le altre
                        -Cancellazione voci con imp_var a 0
 1.3  04/08/2004 MS     Mod per attività
 1.4  17/09/2004 MS     Mod. per attività 7040
 1.5  25/10/2004 MS     Mod. per attività 6156
 1.6  04/02/2005 MS     Mod. per attività 6855
 1.7  08/02/2005 MS     Mod. per attività 7425
 1.8  06/07/2005 MS     Mod. per attività 11921 
 1.9  19/07/2005 CB     Mod. per attività 12073
 2.0  22/07/2005 MS     Mod. Per attività 11944
 2.1  25/07/2005 MS     Mod. Per attività 12144
 2.2  31/08/2005 MS     Mod. Per attività 11944.1
 2.3  12/09/2005 MS     Mod. per attività 12432
 2.4  26/09/2005 MS     Mod. per attività 12143: introdotto utilizzo di deposito_variabili_economiche
 2.5  09/11/2005 MS     Controlli su anno di rifa e parametri ( att. 13125 )
 2.6  10/11/2005 MS     Mod. inserimento deve_id ( att. A13398 )
 2.7  13/03/2006 MS     Controlli su data di ricezione (att. 12142 )
 2.8  21/04/2006 ML     Aggiunto controllo ragi.al su inserimento interessi rateali (A13475).
 2.9  27/04/2006 ML     Modifica normativa: non vengono carivati nelle variabili debiti / crediti 
                        inferiori ai 12 euro (A15971).
 2.10 03/05/2006 MS     Modifica segnalazioni ( corretto inestetismo - Att.13475.1 )
 2.11 09/05/2006 ML     Modificato test limite legale (12 euro) per gestire anche il valore 0 oltre al null (A15971.1).
 2.12 23/05%2006 ML     Gestione possibilita' di eliminazione delle voci caricate, piu' modifica
                        flag elab se cedolino gia' elaborato precedentemente (A15974).
 3.0  03/05/2007 MS     Modifica normativa
 3.1  04/05/2007 MS     Aggiunto controllo su delete ( att. 17269 )
 3.2  29/06/2007 ML     Modifica condizione in controllo importo < 12 euro (A21797).
 3.3  16/07/2007 MS     Sistemazione parametro P_gruppo per segnalazioni
 3.4  11/1072007 CB     Gestione del mese_liquidazione
******************************************************************************/
 FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE GESTIONE_ERRORI 
 ( PRENOTAZIONE IN NUMBER , PROGRESSIVO IN NUMBER  , D_ERRORE IN VARCHAR  , D_PRECISAZIONE IN VARCHAR);

 PROCEDURE CONTROLLO ( prenotazione   IN NUMBER
                     , P_anno_caaf    IN OUT NUMBER
                     , P_specifica    IN VARCHAR
                     , P_flag_rate    IN VARCHAR
                     , P_campo        IN VARCHAR
                     , P_voce         IN OUT VARCHAR
                     , P_prs          IN NUMBER -- progressivo per segnalazione P05644 Esistono legami con specifiche non definite
                     , P_prg          IN NUMBER -- progressivo per segnalazione P05643 Esistono voci con uguale specifica
                     , V_errore       OUT BOOLEAN);
 PROCEDURE CONTROLLO_NO_RATE ( PRENOTAZIONE IN NUMBER 
                             , D_ANNO IN NUMBER
                             , V_CAMPO IN VARCHAR
                             , P_PRS IN NUMBER
                             , V_SPECIFICA IN VARCHAR
                             , V_ERRORE OUT BOOLEAN );
 PROCEDURE CONTROLLO_RATE ( PRENOTAZIONE IN NUMBER 
                          , D_ANNO IN NUMBER
                          , V_CAMPO IN VARCHAR
                          , P_PRS IN NUMBER
                          , V_SPECIFICA IN VARCHAR
                          , V_ERRORE OUT BOOLEAN );
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
 
 v_controllo       number;

END;
/
CREATE OR REPLACE PACKAGE BODY PECCCAAF IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V3.4 del 11/10/2007';
 END VERSIONE;
 
 PROCEDURE CONTROLLO ( prenotazione   IN NUMBER
                     , P_anno_caaf    IN OUT NUMBER
                     , P_specifica    IN VARCHAR
                     , P_flag_rate    IN VARCHAR
                     , P_campo        IN VARCHAR
                     , P_voce         IN OUT VARCHAR
                     , P_prs          IN NUMBER -- progressivo per segnalazione P05644 Esistono legami con specifiche non definite
                     , P_prg          IN NUMBER -- progressivo per segnalazione P05643 Esistono voci con uguale specifica
                     , V_errore      OUT BOOLEAN
                     ) IS
 BEGIN
   BEGIN
      select codice
        into P_voce
        from voci_economiche
       where specifica = P_specifica
      ;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
         P_voce := '';
         IF P_flag_rate = 'SI' THEN
           CONTROLLO_RATE(prenotazione, P_Anno_caaf, P_campo, P_prs, P_specifica, V_errore);
         ELSE
           CONTROLLO_NO_RATE(prenotazione, P_Anno_caaf, P_campo, P_prs, P_specifica, V_errore);
         END IF;
      WHEN TOO_MANY_ROWS THEN
         P_voce := '';
         GESTIONE_ERRORI( prenotazione, P_prg, 'P05643', P_specifica );
         V_errore := TRUE;
   END;
 END CONTROLLO;

 PROCEDURE CONTROLLO_NO_RATE ( PRENOTAZIONE IN NUMBER 
                             , D_ANNO IN NUMBER
                             , V_CAMPO IN VARCHAR
                             , P_PRS IN NUMBER
                             , V_SPECIFICA IN VARCHAR
                             , V_ERRORE OUT BOOLEAN ) IS
 BEGIN
 DECLARE
 v_select         varchar2(500);
   BEGIN
    v_select := 'BEGIN select ''1'' into pecccaaf.v_controllo 
                       from dual
                      where exists (select ''X''
                       from denuncia_caaf caaf
                      where nvl('||v_campo||',0) != 0
                        and caaf.anno = '||D_anno||'); END;';
    BEGIN
        si4.sql_execute(v_select);
        GESTIONE_ERRORI( prenotazione, P_PRS , 'P05644', v_specifica );
        v_errore := TRUE;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
    END; 
  END;
 END CONTROLLO_NO_RATE;

 PROCEDURE CONTROLLO_RATE ( PRENOTAZIONE IN NUMBER 
                          , D_ANNO IN NUMBER
                          , V_CAMPO IN VARCHAR
                          , P_PRS IN NUMBER
                          , V_SPECIFICA IN VARCHAR
                          , V_ERRORE OUT BOOLEAN ) IS
 BEGIN
 DECLARE
 v_select         varchar2(500);
 BEGIN
  v_select := 'BEGIN select ''1'' into pecccaaf.v_controllo 
                       from dual
                      where exists (select ''X''
                       from denuncia_caaf caaf
                      where nvl('||v_campo||',0) != 0
                        and nvl(nr_rate,0)  != 0
                        and caaf.anno = '||D_anno||'); END;';
     BEGIN
        si4.sql_execute(v_select);
        GESTIONE_ERRORI( prenotazione, P_PRS , 'P05644', v_specifica );
        v_errore := TRUE;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
    END; 
  END;
 END CONTROLLO_RATE;

 PROCEDURE GESTIONE_ERRORI 
 ( PRENOTAZIONE IN NUMBER , PROGRESSIVO IN NUMBER , D_ERRORE IN VARCHAR , D_PRECISAZIONE IN VARCHAR) IS
 BEGIN
     insert into a_segnalazioni_errore
     (no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , progressivo
          , d_errore
          , d_precisazione
       from dual
     ;
 END GESTIONE_ERRORI;

 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
 DECLARE
--
-- Parametri della prenotazione
--
P_ente          varchar2(4);
P_ambiente      varchar2(8);
P_utente        varchar2(8);
P_anno          varchar2(4);
P_gestione      varchar2(4);
P_rapporto      varchar2(4);
P_gruppo        varchar2(12);
P_mese          varchar2(4);
P_mensilita     varchar2(4);
P_inserisci     varchar2(2);
P_albo          varchar2(16);
P_variabili     varchar2(1);
P_seconda_rata  varchar2(1);
P_rate          varchar2(1);
P_data_ric      date;
P_data_ric_a    date;
--
-- Variabili generiche
--
P_anno_caaf     number;
P_ini_ela       varchar2(8);
P_fin_ela       varchar2(8);
P_cod_sequenza  varchar2(1);
V_controllo_seq number := 0;
D_ni            number;
D_ci            number;
v_errore        boolean := FALSE;
errore          exception;
uscita          exception;
D_cod_errore    varchar2(6);
V_deve_id       number(10) := 0;
--
-- Codici Voce
--
P_irpef_db      varchar2(10);
P_irpef_cr      varchar2(10);
P_irpef_1r      varchar2(10);
P_irpef_2r      varchar2(10);
P_add_i_db      varchar2(10);
P_add_i_dbc     varchar2(10);
P_add_i_cr      varchar2(10);
P_add_i_crc     varchar2(10);
P_acconto_ap    varchar2(10);
P_acconto_apc   varchar2(10);
P_add_c_db      varchar2(10);
P_add_c_dbc     varchar2(10);
P_add_c_cr      varchar2(10);
P_add_c_crc     varchar2(10);
P_irpef_ras     varchar2(10);
P_irpef_raap    varchar2(10);
P_irpef_ra1r    varchar2(10);
P_irpef_rapc    varchar2(10);
P_add_r_ras     varchar2(10);
P_add_r_rasc    varchar2(10);
P_add_c_ras     varchar2(10);
P_add_c_rasc    varchar2(10);
P_irpef_ris     varchar2(10);
P_irpef_riap    varchar2(10);
P_irpef_ri1r    varchar2(10);
P_irpef_riac    varchar2(10);
P_add_r_ris     varchar2(10);
P_add_r_risc    varchar2(10);
P_add_c_ris     varchar2(10);
P_add_c_risc    varchar2(10);
P_irpef_crc     varchar2(10);
P_irpef_dbc     varchar2(10);
P_irpef_rasc    varchar2(10);
P_irpef_risc    varchar2(10);
P_irpef_1rc     varchar2(10);
P_irpef_2rc     varchar2(10);
P_irpef_ra1c    varchar2(10);
P_irpef_ri1c    varchar2(10);
P_add_c_ac      varchar2(10);
P_add_c_rac     varchar2(10);
P_add_c_ria     varchar2(10);
P_add_c_acc     varchar2(10);
P_add_c_racc    varchar2(10);
P_add_c_riac    varchar2(10);

BEGIN
-- dbms_output.put_line('Inizio');
   BEGIN
      select anno
        into P_anno_caaf
        from riferimento_fine_anno
       where rifa_id = 'RIFA'
      ;
   END;
-- Estrazione Parametri di Selezione della Prenotazione
   BEGIN
      select valore   D_anno
        into P_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           P_anno := null;
   END;
-- dbms_output.put_line('Anno '||P_anno);
   BEGIN
      select valore   D_mensilita
        into P_mensilita
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_MENSILITA'
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           P_mensilita := '';
   END;
-- dbms_output.put_line('P_mensilita '||P_mensilita);
   BEGIN
    SELECT valore
      INTO P_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GESTIONE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_gestione := '%';
  END;
  BEGIN
    SELECT valore
      INTO P_rapporto
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_RAPPORTO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_rapporto := '%';
  END;
  BEGIN
    SELECT valore
      INTO P_GRUPPO
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GRUPPO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_GRUPPO := '%';
  END;
  BEGIN
-- parametro accoda registrazioni
      select valore   D_inserisci
        into P_inserisci
        from a_parametri
       where no_prenotazione =prenotazione
         and parametro       = 'P_INSERISCI'
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
            P_inserisci := 'NO';
   END;
   BEGIN
      select valore   D_albo
        into P_albo
        from a_parametri
       where no_prenotazione =prenotazione
         and parametro       = 'P_ALBO'
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_albo := null;
   END;
   BEGIN
      select valore   D_variabili
        into P_variabili
        from a_parametri
       where no_prenotazione =prenotazione
         and parametro       = 'P_VARIABILI'
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
            null;
   END;
      BEGIN
      select valore   D_seconda_rata
        into P_seconda_rata
        from a_parametri
       where no_prenotazione =prenotazione
         and parametro       = 'P_SECONDA_RATA'
      ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
            null;
   END;
  
  IF P_seconda_rata = 'X' and P_variabili = 'X'
    THEN 
    D_cod_errore := 'A05721';
    raise uscita;
  END IF;
  
  IF P_anno_caaf != P_anno-1 THEN
    D_cod_errore := 'P05196';
    raise uscita;
  END IF;
  
  BEGIN
      select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
        into P_data_ric
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DATA_RIC'
      ;
  EXCEPTION 
       WHEN NO_DATA_FOUND  THEN 
       select to_date('01/01/'||nvl(P_anno,anno),'dd/mm/yyyy')
         into P_data_ric
         from riferimento_retribuzione;
  END;
  BEGIN
      select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
        into P_data_ric_a
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DATA_RIC_A'
      ;
  EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
          select to_date('31/12/'||nvl(P_anno,anno),'dd/mm/yyyy')
            into P_data_ric_a
            from riferimento_retribuzione;
  END;
  BEGIN
    select valore   D_rate
      into P_rate
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_RATE'
   ;
  EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
            P_rate := NULL;
  END;
  
  IF P_data_ric > P_data_ric_a THEN
    D_cod_errore := 'A05721';
    raise uscita;
  END IF;

  BEGIN
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_DB', 'NO', 'irpef_db', P_irpef_db, 40, 1, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_CR', 'NO', 'irpef_cr', P_irpef_cr, 41, 2, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_1R', 'NO', 'irpef_1r', P_irpef_1r, 42, 3, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_2R', 'NO', 'irpef_2r', P_irpef_2r, 43, 4, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_DB', 'NO', 'add_reg_dic_db', P_add_i_db, 44, 5, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_DBC', 'NO', 'add_reg_con_db', P_add_i_dbc, 45, 6, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_CR', 'NO', 'add_reg_dic_cr', P_add_i_cr, 46, 7, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_CRC', 'NO', 'add_reg_con_cr', P_add_i_crc, 47, 8, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_AP', 'NO', 'irpef_acconto_ap', P_acconto_ap, 48, 9, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_APC', 'NO', 'irpef_acconto_ap_con', P_acconto_apc, 49, 10, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_DB', 'NO', 'add_com_dic_db', P_add_c_db, 50, 11, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_DBC', 'NO', 'add_com_con_db', P_add_c_dbc, 51, 12, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_CR', 'NO', 'add_com_dic_cr', P_add_c_cr, 52, 13, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_CRC', 'NO', 'add_com_con_cr', P_add_c_crc, 53, 14, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RAS', 'SI', 'irpef_db', P_irpef_ras, 54, 15, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RIS', 'SI', 'int_rate_irpef', P_irpef_ris, 55, 16, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RAAP', 'SI', 'irpef_acconto_ap', P_irpef_raap, 56, 17, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RIAP', 'SI', 'int_rate_irpef_ap', P_irpef_riap, 57, 18, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RA1R', 'SI', 'irpef_1r', P_irpef_ra1r, 58, 19, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RI1R', 'SI', 'int_rate_irpef_1r', P_irpef_ri1r, 59, 20, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RAPC', 'SI', 'irpef_acconto_ap_con', P_irpef_rapc, 60, 21, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RIAC', 'SI', 'int_rate_irpef_ap_con', P_irpef_riac, 61, 22, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_RAS', 'SI', 'add_reg_dic_db', P_add_r_ras, 62, 23, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_RIS', 'SI', 'int_rate_reg_dic', P_add_r_ris, 63, 24, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_RASC', 'SI', 'add_reg_con_db', P_add_r_rasc, 64, 25, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_R_RISC', 'SI', 'int_rate_reg_con', P_add_r_risc, 65, 26, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RAS', 'SI', 'add_com_dic_db', P_add_c_ras, 66, 27, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RIS', 'SI', 'int_rate_com_dic', P_add_c_ris, 67, 28, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RASC', 'SI', 'add_com_con_db', P_add_c_rasc, 68, 29, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RISC', 'SI', 'int_rate_com_con', P_add_c_risc, 69, 30, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_DBC', 'NO', 'irpef_db_con', P_irpef_dbc, 70, 31, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_CRC', 'NO', 'irpef_cr_con', P_irpef_crc, 71, 32, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_1RC', 'NO', 'irpef_1r_con', P_irpef_1rc, 72, 33, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RA1C', 'SI', 'irpef_1r_con', P_irpef_ra1c, 73, 34, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RI1C', 'SI', 'int_rate_irpef_1r_con', P_irpef_ri1c, 74, 35, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_2RC', 'NO', 'irpef_2r_con', P_irpef_2rc, 75, 36, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RASC', 'SI', 'irpef_db_con', P_irpef_rasc, 76, 37, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'IRPEF_RISC', 'SI', 'int_rate_irpef_con', P_irpef_risc, 77, 38, V_errore );
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_AC', 'NO', 'acc_add_com_dic_db', P_add_c_ac, 78, 39, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_ACC', 'NO', 'acc_add_com_con_db', P_add_c_acc, 79, 40, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RAC', 'SI', 'acc_add_com_dic_db', P_add_c_rac, 80, 41, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RACC', 'SI', 'acc_add_com_con_db', P_add_c_racc, 81, 42, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RIA', 'SI', 'int_rate_acc_com_dic', P_add_c_ria, 82, 43, V_errore );     
     CONTROLLO ( prenotazione, P_anno_caaf, 'ADD_C_RIAC', 'SI', 'int_rate_acc_com_con', P_add_c_riac, 83, 44, V_errore );     
   -- fine controlli su specifiche
  END;

  IF not nvl(v_errore,FALSE)  THEN -- nessun controllo precedente ha segnalato errore
  -- Estrazione Anno, Mese e Mensilita` di Riferimento  (default RIRE)
    BEGIN
      select nvl(P_anno,rire.anno)    D_anno
           , mens.mese                D_mese
           , mens.mensilita           D_mensilita
           , to_char(to_date(lpad(mens.mese,2,0)||nvl(P_anno,rire.anno)
                           ,'mmyyyy')
                    ,'ddmmyyyy')      D_ini_ela
           , to_char(last_day(to_date(lpad(mens.mese,2,0)|| nvl(P_anno,rire.anno)
                                     ,'mmyyyy')) 
                     ,'ddmmyyyy')     D_fin_ela
           , cod_sequenza             D_cod_sequenza
        into P_anno,P_mese,P_mensilita,P_ini_ela,P_fin_ela,P_cod_sequenza
        from riferimento_retribuzione rire
           , mensilita                mens
       where rire.rire_id    = 'RIRE'
         and (   (    P_mensilita is null
                  and mens.mese       = rire.mese
                  and mens.mensilita  = rire.mensilita
                 )
              or mens.codice = P_mensilita
             )
      ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
/* Non ho inserito il codice della mensilita e quello di rire non è corretto - potrebbe essere un bil. prev. */
        update a_prenotazioni 
           set prossimo_passo  = 99
             , errore          = 'A05721'
         where no_prenotazione = prenotazione
          ;
     END;
   IF P_rate is not null THEN
/* controllo l'esistenza delle mensilita con il cod_sequenza indicato per inserire le rate */
     BEGIN
     select count(*) 
       into V_controllo_seq
       from mensilita mens
      where nvl(mens.cod_sequenza,' ')  = nvl(P_cod_sequenza,' ')
        and mens.tipo           = 'N'
        and mens.mese     between 1 and 12
        and not exists ( select 'x' from mensilita
                          where nvl(cod_sequenza,' ')  = nvl(P_cod_sequenza,' ')
                            and mese = mens.mese
                            and tipo = 'N'
                           and rowid != mens.rowid
                       )
     ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
       V_controllo_seq := 0;
     END;
-- dbms_output.put_line('CHK: '||V_controllo_seq);
    IF V_controllo_seq != 12 THEN
       D_cod_errore := 'P05853';
       raise uscita;
    END IF;
-- spostata la IF per errato controllo
   END IF;

  IF P_inserisci = 'E' THEN
     BEGIN
       select 'P08070'
         into D_cod_errore
         from riferimento_retribuzione
        where anno      != P_Anno
           OR mensilita != P_mensilita;
       raise uscita;
     EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
     END;
  END IF;
  BEGIN
    select ente     D_ente
         , utente   D_utente
         , ambiente D_ambiente
      into P_ente,P_utente,P_ambiente
      from a_prenotazioni
     where no_prenotazione = prenotazione
    ;
  END;
  BEGIN
     IF nvl(P_albo,' ') != ' ' THEN
        BEGIN
          select ni
            into D_ni
            from anagrafici anag
           where numero_doc = P_albo
             and anag.dal       <= to_date(P_fin_ela,'ddmmyyyy')
             and nvl(anag.al,to_date('3333333','j')) >= to_date(P_ini_ela,'ddmmyyyy')
         ;
-- dbms_output.put_line('D_ni '||to_char(D_ni));
        EXCEPTION
             when NO_DATA_FOUND then
             insert into a_segnalazioni_errore
             ( no_prenotazione,passo,progressivo,errore,precisazione )
              values (prenotazione,1,1,'P01059',' - Per il numero Albo: '||P_albo);
             raise errore;
        END;
        BEGIN
          select ci
            into D_ci
            from rapporti_individuali rain
           where ni = D_ni
             and rain.dal       <= to_date(P_fin_ela,'ddmmyyyy')
             and nvl(rain.al,to_date('3333333','j')) >= to_date(P_ini_ela,'ddmmyyyy')
          ;
-- dbms_output.put_line('D_ci '||to_char(D_ci));
        EXCEPTION
          when NO_DATA_FOUND then
          insert into a_segnalazioni_errore
         (no_prenotazione,passo,progressivo,errore,precisazione)
         values (prenotazione,1,1,'P05839','Impossibile trovare un CI')
          ;
          raise errore;
        END;
     ELSE
        D_ci := to_number(null);
     END IF;
-- dbms_output.put_line('P_inserisci '||P_inserisci);
   lock table movimenti_contabili in exclusive mode nowait;
   delete from movimenti_contabili moco
    where moco.anno      = P_anno
      and moco.mese     >= P_mese
      and P_variabili    = 'X'
      and moco.voce IN ( P_irpef_cr, P_irpef_db, P_irpef_1r
                       , P_irpef_crc, P_irpef_dbc, P_irpef_1rc
                       , P_acconto_ap, P_acconto_apc
                       , P_irpef_ras, P_irpef_ris, P_irpef_ra1r, P_irpef_ri1r
                       , P_irpef_rasc, P_irpef_risc, P_irpef_ra1c, P_irpef_ri1c
                       , P_irpef_raap, P_irpef_riap, P_irpef_rapc, P_irpef_riac
                       , P_add_i_cr, P_add_i_db, P_add_i_crc, P_add_i_dbc
                       , P_add_r_ras, P_add_r_rasc, P_add_r_ris, P_add_r_risc
                       , P_add_c_cr, P_add_c_db, P_add_c_crc, P_add_c_dbc
                       , P_add_c_ras, P_add_c_rasc, P_add_c_ris, P_add_c_risc
                       , P_add_c_ac, P_add_c_rac, P_add_c_ria
                       , P_add_c_acc, P_add_c_racc, P_add_c_riac
                       )
      and exists (select 'x' from denuncia_caaf caaf
                   where caaf.anno    = P_Anno_caaf
                     and caaf.ci_caaf = decode(P_albo,null,caaf.ci_caaf,D_ci)
                     and caaf.ci      = moco.ci
                     and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) 
                                                 and nvl(P_data_ric_a,to_date('3333333','j'))
                 )
      and exists (select 'x' 
                    from deposito_variabili_economiche  deve
                   where deve.input     = 'CCAAF'
                     and deve.ci        = moco.ci
                     and deve.anno      = moco.anno
                     and deve.mese      = moco.mese
                     and deve.mensilita = moco.mensilita
                     and deve.voce      = moco.voce
                     and deve.sub       = moco.sub
                 )
      and ci in ( select ci 
                   from rapporti_giuridici ragi
                   where ragi.gestione like P_gestione
                )
      and exists (select 'x'
                     from rapporti_individuali rain
                    where rain.ci = moco.ci
                      and nvl(rain.rapporto,'%') like P_rapporto
                      and NVL(rain.gruppo,' ')   like P_gruppo
                      and (   rain.cc is null
                          or exists
                            (select 'x'
                               from a_competenze
                              where ente        = P_ente
                                and ambiente    = P_ambiente
                                and utente      = P_utente
                                and competenza  = 'CI'
                                and oggetto     = rain.cc
                            )
                          )
                   )
      and P_inserisci   in ('NO','E')
     ;
-- dbms_output.put_line('Righe cancellate 1: '||sql%rowcount);
   delete from movimenti_contabili moco
    where moco.anno      = P_anno
      and moco.mese      = P_mese
      and moco.mensilita = P_mensilita
      and P_seconda_rata = 'X'
      and moco.voce            in ( P_irpef_2r, P_irpef_2rc )
      and exists ( select 'x' from denuncia_caaf caaf
                    where caaf.anno    = P_Anno_caaf
                      and caaf.ci_caaf = decode(P_albo,null,caaf.ci_caaf,D_ci)
                      and caaf.ci      = moco.ci
                      and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) 
                                                 and nvl(P_data_ric_a,to_date('3333333','j'))
                 )
      and exists (select 'x' 
                    from deposito_variabili_economiche  deve
                   where deve.input     = 'CCAAF'
                     and deve.ci        = moco.ci
                     and deve.anno      = moco.anno
                     and deve.mese      = moco.mese
                     and deve.mensilita = moco.mensilita
                     and deve.voce      = moco.voce
                     and deve.sub       = moco.sub
                 )
      and ci in ( select ci 
                    from rapporti_giuridici ragi
                   where ragi.gestione like P_gestione
                )
      and exists  (select 'x'
                     from rapporti_individuali rain
                    where rain.ci = moco.ci
                      and nvl(rain.rapporto,'%') like P_rapporto
                      and NVL(rain.gruppo,' ')   like P_gruppo
                      and (   rain.cc is null
                          or exists
                            (select 'x'
                               from a_competenze
                              where ente        = P_ente
                                and ambiente    = P_ambiente
                                and utente      = P_utente
                                and competenza  = 'CI'
                                and oggetto     = rain.cc
                            )
                          )
                   )
      and P_inserisci   in ('NO','E')
      ;
-- dbms_output.put_line('Righe cancellate 2: '||sql%rowcount);
   commit;
-- delete da tabella appoggio
   delete from deposito_variabili_economiche  deve
    where input = 'CCAAF'
      and deve.anno      = P_anno
      and deve.mese     >= P_mese
      and P_variabili    = 'X'
      and deve.voce IN ( P_irpef_cr, P_irpef_db, P_irpef_1r
                       , P_irpef_crc, P_irpef_dbc, P_irpef_1rc
                       , P_acconto_ap, P_acconto_apc
                       , P_irpef_ras, P_irpef_ris, P_irpef_ra1r, P_irpef_ri1r
                       , P_irpef_rasc, P_irpef_risc, P_irpef_ra1c, P_irpef_ri1c
                       , P_irpef_raap, P_irpef_riap, P_irpef_rapc, P_irpef_riac
                       , P_add_i_cr, P_add_i_db, P_add_i_crc, P_add_i_dbc
                       , P_add_r_ras, P_add_r_rasc, P_add_r_ris, P_add_r_risc
                       , P_add_c_cr, P_add_c_db, P_add_c_crc, P_add_c_dbc
                       , P_add_c_ras, P_add_c_rasc, P_add_c_ris, P_add_c_risc
                       , P_add_c_ac, P_add_c_rac, P_add_c_ria
                       , P_add_c_acc, P_add_c_racc, P_add_c_riac )
      and exists (select 'x' from denuncia_caaf caaf
                   where caaf.anno    = P_Anno_caaf
                     and caaf.ci_caaf = decode(P_albo,null,caaf.ci_caaf,D_ci)
                     and caaf.ci      = deve.ci
                     and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) 
                                                 and nvl(P_data_ric_a,to_date('3333333','j'))
                 )
      and ci in ( select ci 
                    from rapporti_giuridici ragi
                   where ragi.gestione like P_gestione
                )
      and exists  (select 'x'
                     from rapporti_individuali rain
                    where rain.ci = deve.ci
                      and nvl(rain.rapporto,'%') like P_rapporto
                      and NVL(rain.gruppo,' ')   like P_gruppo
                      and (   rain.cc is null
                          or exists
                            (select 'x'
                               from a_competenze
                              where ente        = P_ente
                                and ambiente    = P_ambiente
                                and utente      = P_utente
                                and competenza  = 'CI'
                                and oggetto     = rain.cc
                            )
                          )
                   )
      and P_inserisci   in ('NO','E')
     ;
-- dbms_output.put_line('Righe cancellate 1A: '||sql%rowcount);
    delete from deposito_variabili_economiche  deve
      where input = 'CCAAF'
        and deve.anno      = P_anno
        and deve.mese      = P_mese
        and deve.mensilita = P_mensilita
        and P_seconda_rata = 'X'
        and deve.voce            in ( P_irpef_2r,  P_irpef_2rc )
        and exists
           ( select 'x' from denuncia_caaf caaf
             where caaf.anno    = P_Anno_caaf
               and caaf.ci_caaf = decode(P_albo,null,caaf.ci_caaf,D_ci)
               and caaf.ci      = deve.ci
               and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) 
                                           and nvl(P_data_ric_a,to_date('3333333','j'))
           )
        and ci in ( select ci 
                     from rapporti_giuridici ragi
                    where ragi.gestione like P_gestione
                  )
        and exists
            ( select 'x'
               from rapporti_individuali rain
              where rain.ci = deve.ci
                and nvl(rain.rapporto,'%') like P_rapporto
                and NVL(rain.gruppo,' ')   like P_gruppo
                and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = P_ente
                          and ambiente    = P_ambiente
                          and utente      = P_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                    )
             )
        and P_inserisci   in ('NO','E')
        ;
-- dbms_output.put_line('Righe cancellate 2A: '||sql%rowcount);
     commit;

     BEGIN
       select max(deve_id) 
         into V_deve_id 
         from deposito_variabili_economiche
        where input = 'CCAAF';
     EXCEPTION WHEN NO_DATA_FOUND THEN V_deve_id := 0;
     END;

 -- Inserimento Registrazioni II Rata
-- dbms_output.put_line('Inserisco seconda rata');
       insert into deposito_variabili_economiche
            ( input
            , ci
            , anno
            , mese
            , mensilita
            , voce
            , sub
            , riferimento
            , imp
            , deve_id
            )
       select 'CCAAF'
            , caaf.ci
            , P_anno
            , P_mese
            , P_mensilita
            , voec.codice
            , '*'
            , least(to_date(P_fin_ela,'ddmmyyyy'),nvl(ragi.al,to_date('3333333','j')))
            , decode( voec.specifica
                    , 'IRPEF_2R' ,caaf.irpef_2r     * decode(voec.tipo,'C',-1,1)
                    , 'IRPEF_2RC',caaf.irpef_2r_con * decode(voec.tipo,'C',-1,1)
                    )
            , nvl(V_deve_id,0) + rownum
         from denuncia_caaf        caaf
            , rapporti_giuridici   ragi
            , voci_economiche      voec
        where caaf.anno = P_Anno_caaf
          and caaf.rettifica != 'M'
          and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
          and ragi.gestione like P_gestione
          and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
          and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = caaf.ci
                 and nvl(rain.rapporto,'%') like P_rapporto
                 and NVL(rain.gruppo,' ')   like P_gruppo
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = P_ente
                            and ambiente    = P_ambiente
                            and utente      = P_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                        )
                     )
             )
          and ragi.ci                        =  caaf.ci
          and nvl(ragi.al,to_date('3333333','j')) >= to_date(P_ini_ela,'ddmmyyyy')
          and caaf.conguaglio_2r is null
          and voec.codice   in (P_irpef_2r, P_irpef_2rc)
          and abs(decode( voec.codice
                         , P_irpef_2r ,nvl(caaf.irpef_2r,0)
                         , P_irpef_2rc,nvl(caaf.irpef_2r_con,0)
                    )) > 12
          and nvl(P_seconda_rata,' ') = 'X'                        
          and P_inserisci != 'E'                
       ;
-- dbms_output.put_line('Righe inserite '||sql%rowcount);
       commit;
-- dbms_output.put_line('P_variabili '||P_variabili);
-- Inserimento Registrazioni dipendenti senza rate
-- dbms_output.put_line('Inserisco dipendenti senza rate');
       insert into deposito_variabili_economiche
            ( input
            , ci
            , anno
            , mese
            , mensilita
            , voce
            , sub
            , riferimento
            , imp
            , deve_id
            )
       select 'CCAAF'
            , caaf.ci
            , P_anno
            , P_mese
            , P_mensilita
            , voec.codice
            , '*'
            , least(to_date(P_fin_ela,'ddmmyyyy'),nvl(ragi.al,to_date('3333333','j')))
            , decode( voec.specifica
                    , 'IRPEF_DB', caaf.irpef_db*decode(voec.tipo,'C',-1,1)
                    , 'IRPEF_DBC', caaf.irpef_db_con*decode(voec.tipo,'C',-1,1)
                    , 'IRPEF_CR', caaf.irpef_cr*decode(voec.tipo,'T',-1,1)
                    , 'IRPEF_CRC', caaf.irpef_cr_con*decode(voec.tipo,'T',-1,1)
                    , 'IRPEF_1R', caaf.irpef_1r*decode(voec.tipo,'C',-1,1)
                    , 'IRPEF_1RC', caaf.irpef_1r_con*decode(voec.tipo,'C',-1,1)
                    , 'ADD_R_DB', caaf.add_reg_dic_db*decode(voec.tipo,'C',-1,1)
                    , 'ADD_R_DBC',caaf.add_reg_con_db*decode(voec.tipo,'C',-1,1)
                    , 'ADD_R_CR', caaf.add_reg_dic_cr*decode(voec.tipo,'T',-1,1)
                    , 'ADD_R_CRC',caaf.add_reg_con_cr*decode(voec.tipo,'T',-1,1)
                    , 'IRPEF_AP', caaf.irpef_acconto_ap*decode(voec.tipo,'C',-1,1)
                    , 'IRPEF_APC',caaf.irpef_acconto_ap_con*decode(voec.tipo,'C',-1,1)
                    , 'ADD_C_DB', caaf.add_com_dic_db*decode(voec.tipo,'C',-1,1)
                    , 'ADD_C_DBC',caaf.add_com_con_db*decode(voec.tipo,'C',-1,1)
                    , 'ADD_C_CR', caaf.add_com_dic_cr*decode(voec.tipo,'T',-1,1)
                    , 'ADD_C_CRC',caaf.add_com_con_cr*decode(voec.tipo,'T',-1,1)
                    , 'ADD_C_AC', caaf.acc_add_com_dic_db*decode(voec.tipo,'C',-1,1)
                    , 'ADD_C_ACC',caaf.acc_add_com_con_db*decode(voec.tipo,'C',-1,1)
                    )
            , nvl(V_deve_id,0) + rownum + 10000
         from denuncia_caaf        caaf
            , rapporti_giuridici   ragi
            , voci_economiche      voec
        where caaf.anno = P_Anno_caaf
          and caaf.rettifica in ('1','C','E','G')
          and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
          and ragi.gestione like P_gestione
          and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
          and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = caaf.ci
                 and nvl(rain.rapporto,'%') like P_rapporto
                 and NVL(rain.gruppo,' ')   like P_gruppo
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = P_ente
                            and ambiente    = P_ambiente
                            and utente      = P_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                        )
                     )
             )
          and ragi.ci                        =  caaf.ci
          and nvl(ragi.al,to_date('3333333','j')) >=
              decode( voec.specifica
                    , 'IRPEF_CR' , nvl(ragi.al,to_date('3333333','j'))
                    , 'IRPEF_CRC' , nvl(ragi.al,to_date('3333333','j'))
                    , 'ADD_R_CR' , nvl(ragi.al,to_date('3333333','j'))
                    , 'ADD_R_CRC', nvl(ragi.al,to_date('3333333','j'))
                    , 'ADD_C_CR' , nvl(ragi.al,to_date('3333333','j'))
                    , 'ADD_C_CRC', nvl(ragi.al,to_date('3333333','j'))
                                 , to_date(P_ini_ela,'ddmmyyyy')
                    )
          and voec.codice in (P_irpef_db,P_irpef_dbc
                             ,P_irpef_cr,P_irpef_crc
                             ,P_irpef_1r,P_irpef_1rc
                             ,P_add_i_db,P_add_i_dbc,
                              P_add_i_cr,P_add_i_crc,
                              P_acconto_ap,P_acconto_apc,
                              P_add_c_db,P_add_c_dbc,
                              P_add_c_cr,P_add_c_crc,
                              P_add_c_ac,P_add_c_acc
                             )
          and abs(decode( voec.codice
                    , P_irpef_db, nvl(caaf.irpef_db,0)
                    , P_irpef_dbc, nvl(caaf.irpef_db_con,0)
                    , P_irpef_cr, nvl(caaf.irpef_cr,0)
                    , P_irpef_crc, nvl(caaf.irpef_cr_con,0)
                    , P_irpef_1r, nvl(caaf.irpef_1r,0)
                    , P_irpef_1rc, nvl(caaf.irpef_1r_con,0)
                    , P_add_i_db, nvl(caaf.add_reg_dic_db,0)
                    , P_add_i_dbc, nvl(caaf.add_reg_con_db,0)
                    , P_add_i_cr, nvl(caaf.add_reg_dic_cr,0)
                    , P_add_i_crc, nvl(caaf.add_reg_con_cr,0)
                    , P_acconto_ap, nvl(caaf.irpef_acconto_ap,0)
                    , P_acconto_apc, nvl(caaf.irpef_acconto_ap_con,0)
                    , P_add_c_db, nvl(caaf.add_com_dic_db,0)
                    , P_add_c_dbc, nvl(caaf.add_com_con_db,0)
                    , P_add_c_cr, nvl(caaf.add_com_dic_cr,0)
                    , P_add_c_crc, nvl(caaf.add_com_con_cr,0)
                    , P_add_c_ac, nvl(caaf.acc_add_com_dic_db,0)
                    , P_add_c_acc, nvl(caaf.acc_add_com_con_db,0)
                    )) > 12
          and nvl(caaf.nr_rate,0) = 0
          and nvl(P_variabili,' ') = 'X'
          and P_inserisci != 'E'                
       ;
-- dbms_output.put_line('Righe inserite '||sql%rowcount);
       commit;
-- dbms_output.put_line('inserimento rate a debito');
-- Inserimento Registrazioni a credito dipendenti con rate
-- dbms_output.put_line('Inserisco dipendenti con rate a debito e a credito');
       insert into deposito_variabili_economiche
            ( input
            , ci
            , anno
            , mese
            , mensilita
            , voce
            , sub
            , riferimento
            , imp
            , deve_id
            )
       select 'CCAAF'
            , caaf.ci
            , P_anno
            , P_mese
            , P_mensilita
            , voec.codice
            , '*'
            , least(to_date(P_fin_ela,'ddmmyyyy'),nvl(ragi.al,to_date('3333333','j')))
            , decode( voec.specifica
                    , 'IRPEF_CR' , caaf.irpef_cr*decode(voec.tipo,'T',-1,1)
                    , 'IRPEF_CRC' , caaf.irpef_cr_con*decode(voec.tipo,'T',-1,1)
                    , 'ADD_R_CR' , caaf.add_reg_dic_cr*decode(voec.tipo,'T',-1,1)
                    , 'ADD_R_CRC', caaf.add_reg_con_cr*decode(voec.tipo,'T',-1,1)
                    , 'ADD_C_CR' , caaf.add_com_dic_cr*decode(voec.tipo,'T',-1,1)
                    , 'ADD_C_CRC', caaf.add_com_con_cr*decode(voec.tipo,'T',-1,1)
                    )
            , nvl(V_deve_id,0) + rownum + 20000
         from denuncia_caaf        caaf
            , rapporti_giuridici   ragi
            , voci_economiche      voec
        where caaf.anno = P_Anno_caaf
          and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
          and caaf.rettifica in ('1','C','E','G')
          and ragi.gestione like P_gestione
          and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
          and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = caaf.ci
                 and nvl(rain.rapporto,'%') like P_rapporto
                 and NVL(rain.gruppo,' ')   like P_gruppo
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = P_ente
                            and ambiente    = P_ambiente
                            and utente      = P_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                        )
                     )
             )
          and ragi.ci                        =  caaf.ci
          and voec.codice in ( P_irpef_cr, P_irpef_crc, P_add_i_cr, P_add_i_crc
                             , P_add_c_cr, P_add_c_crc )
          and abs(decode( voec.codice
                    , P_irpef_cr , nvl(caaf.irpef_cr,0)
                    , P_irpef_crc , nvl(caaf.irpef_cr_con,0)
                    , P_add_i_cr , nvl(caaf.add_reg_dic_cr,0)
                    , P_add_i_crc, nvl(caaf.add_reg_con_cr,0)
                    , P_add_c_cr , nvl(caaf.add_com_dic_cr,0)
                    , P_add_c_crc, nvl(caaf.add_com_con_cr,0)
                    )) > 12
          and nvl(caaf.nr_rate,0) != 0
          and P_rate           is not null
          and P_inserisci != 'E'                
       ;
-- dbms_output.put_line('Righe inserite '||sql%rowcount);
       commit;
 -- Inserimento Rate a debito
       insert into deposito_variabili_economiche
            ( input
            , ci
            , anno
            , mese
            , mensilita
            , voce
            , sub
            , riferimento
            , imp
            , deve_id
            )
       select 'CCAAF'
            , caaf.ci
            , P_anno
            , mens.mese
            , mens.mensilita
            , voec.codice
            , '*'
            , least(last_day(to_date(lpad(mens.mese,2,'0')||P_anno,'mmyyyy'))
                   ,nvl(ragi.al,to_date('3333333','j')))
            , decode
              (voec.specifica
              ,'IRPEF_RAS',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.irpef_db,0)
                                        -e_round( nvl(caaf.irpef_db,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.irpef_db,0)
                                                / caaf.nr_rate,'I')
                            )
              ,'IRPEF_RASC',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.irpef_db_con,0)
                                        -e_round( nvl(caaf.irpef_db_con,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.irpef_db_con,0)
                                                / caaf.nr_rate,'I')
                            )
              ,'IRPEF_RA1R',decode
                            (mens.mese,P_mese+caaf.nr_rate-1
                                      , nvl(caaf.irpef_1r,0)
                                       -e_round( nvl(caaf.irpef_1r,0)
                                              / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.irpef_1r,0)
                                                 / caaf.nr_rate,'I')
                            )
              ,'IRPEF_RA1C',decode
                            (mens.mese,P_mese+caaf.nr_rate-1
                                      , nvl(caaf.irpef_1r_con,0)
                                       -e_round( nvl(caaf.irpef_1r_con,0)
                                              / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.irpef_1r_con,0)
                                                 / caaf.nr_rate,'I')
                            )
              ,'IRPEF_RAAP',decode
                            (mens.mese,P_mese+caaf.nr_rate-1
                                      , nvl(caaf.irpef_acconto_ap,0)
                                       -e_round( nvl(caaf.irpef_acconto_ap,0)
                                              / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.irpef_acconto_ap,0)
                                                 / caaf.nr_rate,'I')
                            )
              ,'IRPEF_RAPC',decode
                            (mens.mese,P_mese+caaf.nr_rate-1
                                      , nvl(caaf.irpef_acconto_ap_con,0)
                                       -e_round( nvl(caaf.irpef_acconto_ap_con,0)
                                              / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.irpef_acconto_ap_con,0)
                                                 / caaf.nr_rate,'I')
                            )
              ,'ADD_R_RAS',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.add_reg_dic_db,0)
                                        -e_round( nvl(caaf.add_reg_dic_db,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.add_reg_dic_db,0)
                                                / caaf.nr_rate,'I')
                           )
              ,'ADD_R_RASC',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.add_reg_con_db,0)
                                        -e_round( nvl(caaf.add_reg_con_db,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.add_reg_con_db,0)
                                                 / caaf.nr_rate,'I')
                           )
              ,'ADD_C_RAS',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.add_com_dic_db,0)
                                        -e_round( nvl(caaf.add_com_dic_db,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.add_com_dic_db,0)
                                                / caaf.nr_rate,'I')
                           )
              ,'ADD_C_RASC',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.add_com_con_db,0)
                                        -e_round( nvl(caaf.add_com_con_db,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.add_com_con_db,0)
                                                / caaf.nr_rate,'I')
                            )
              ,'ADD_C_RAC',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.acc_add_com_dic_db,0)
                                        -e_round( nvl(caaf.acc_add_com_dic_db,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.acc_add_com_dic_db,0)
                                                / caaf.nr_rate,'I')
                           )
              ,'ADD_C_RACC',decode
                           ( mens.mese
                           , P_mese+caaf.nr_rate-1
                                      ,  nvl(caaf.acc_add_com_con_db,0)
                                        -e_round( nvl(caaf.acc_add_com_con_db,0)
                                               / caaf.nr_rate,'I')*(caaf.nr_rate-1)
                                         , e_round( nvl(caaf.acc_add_com_con_db,0)
                                                / caaf.nr_rate,'I')
                            )
              )
            , nvl(V_deve_id,0) + rownum + 30000
         from denuncia_caaf        caaf
            , rapporti_giuridici   ragi
            , voci_economiche      voec
            , mensilita            mens
        where caaf.anno = P_Anno_caaf
          and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
          and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
          and caaf.rettifica in ('1','C','E','G')
          and ragi.gestione like P_gestione
          and ragi.ci                        =  caaf.ci
          and nvl(ragi.al,to_date('3333333','j')) >= to_date(P_ini_ela,'ddmmyyyy')
          and voec.codice    in (P_irpef_ras,P_irpef_rasc, P_irpef_raap,P_irpef_ra1r,P_irpef_ra1c,P_irpef_rapc
                                ,P_add_r_ras,P_add_r_rasc,P_add_c_ras,P_add_c_rasc,P_add_c_rac,P_add_c_racc)
          and nvl(caaf.nr_rate,0) != 0
          and P_rate           is not null
          and P_mese+nvl(caaf.nr_rate,0) < 13
          and mens.tipo           = 'N'
          and nvl(mens.cod_sequenza,' ')  = nvl(P_cod_sequenza,' ')
          and mens.mese     between P_mese and P_mese+caaf.nr_rate -1
          and abs(decode
                  (voec.specifica
                  ,'IRPEF_RAS',nvl(caaf.irpef_db,0)
                  ,'IRPEF_RASC',nvl(caaf.irpef_db_con,0)
                  ,'IRPEF_RA1R', nvl(caaf.irpef_1r,0)
                  ,'IRPEF_RA1C', nvl(caaf.irpef_1r_con,0)
                  ,'IRPEF_RAAP', nvl(caaf.irpef_acconto_ap,0)
                  ,'IRPEF_RAPC', nvl(caaf.irpef_acconto_ap_con,0)
                  ,'ADD_R_RAS',  nvl(caaf.add_reg_dic_db,0)
                  ,'ADD_R_RASC', nvl(caaf.add_reg_con_db,0)
                  ,'ADD_C_RAS',  nvl(caaf.add_com_dic_db,0)
                  ,'ADD_C_RASC', nvl(caaf.add_com_con_db,0)
                  ,'ADD_C_RAC',  nvl(caaf.acc_add_com_dic_db,0)
                  ,'ADD_C_RACC', nvl(caaf.acc_add_com_con_db,0)
                  )) > 12
          and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = caaf.ci
                 and nvl(rain.rapporto,'%') like P_rapporto
                 and NVL(rain.gruppo,' ')   like P_gruppo
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = P_ente
                            and ambiente    = P_ambiente
                            and utente      = P_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                        )
                     )
             )
          and P_inserisci != 'E'                
       ;
-- dbms_output.put_line('Righe inserite '||sql%rowcount);
       commit;
-- Inserimento Interessi su Versamenti Rateali (meno prima rata)
/*  
  NB.: sull'ultima rata viene inserito il totale degli interessi
       di ACAAF perche con l'update successiva viene ricalcolata
      come differenza tra il totale e il totale delle rate gia inserite
*/
-- dbms_output.put_line('Inserisco interessi su versamenti rateali');
     insert into deposito_variabili_economiche
          ( input
          , ci
          , anno
          , mese
          , mensilita
          , voce
          , sub
          , riferimento
          , imp
          , deve_id
          )
     select 'CCAAF'
          , caaf.ci
          , P_anno
          , mens.mese
          , mens.mensilita
          , voec.codice
          , '*'
          , least(last_day(to_date(lpad(mens.mese,2,'0')||P_anno,'mmyyyy'))
                 ,nvl(max(ragi.al),to_date('3333333','j')))
          , max(decode
                (voec.specifica
                ,'IRPEF_RIS',decode
                              (voec2.specifica
                              , 'IRPEF_RAS',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_irpef
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'IRPEF_RISC',decode
                              (voec2.specifica
                              , 'IRPEF_RASC',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_irpef_con
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'IRPEF_RI1R',decode
                              (voec2.specifica
                              , 'IRPEF_RA1R',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_irpef_1r
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'IRPEF_RI1C',decode
                              (voec2.specifica
                              , 'IRPEF_RA1C',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_irpef_1r_con
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'IRPEF_RIAP',decode
                              (voec2.specifica
                              , 'IRPEF_RAAP',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_irpef_ap
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'IRPEF_RIAC',decode
                              (voec2.specifica
                              , 'IRPEF_RAPC',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_irpef_ap_con
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'ADD_R_RIS',decode
                              (voec2.specifica
                              , 'ADD_R_RAS',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_reg_dic
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'ADD_R_RISC',decode
                              (voec2.specifica
                              , 'ADD_R_RASC',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_reg_con
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'ADD_C_RIS',decode
                              (voec2.specifica
                              , 'ADD_C_RAS',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_com_dic
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'ADD_C_RISC',decode
                              (voec2.specifica
                              , 'ADD_C_RASC',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_com_con
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'ADD_C_RIA',decode
                              (voec2.specifica
                              , 'ADD_C_RAC',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_acc_com_dic
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
                ,'ADD_C_RIAC',decode
                              (voec2.specifica
                              , 'ADD_C_RACC',decode
                                             (deve.mese
                                             ,P_mese+caaf.nr_rate-1
                                                  ,caaf.int_rate_acc_com_con
                                                   ,e_round(deve.imp*0.5
                                                         *(mens.mese-P_mese)
                                                         /100,'I'))
                                             ,0)
            ))
          , nvl(V_deve_id,0) + max(rownum) + 40000
       from deposito_variabili_economiche  deve
          , denuncia_caaf        caaf
          , rapporti_giuridici   ragi
          , voci_economiche      voec
          , voci_economiche      voec2
          , mensilita            mens
      where caaf.anno = P_Anno_caaf
        and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
        and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
        and caaf.rettifica       in ('1','C','E','G')
        and ragi.gestione           like P_gestione
        and ragi.ci              = caaf.ci
        and nvl(ragi.al,to_date('3333333','j')) >= to_date(P_ini_ela,'ddmmyyyy')
        and deve.input           = 'CCAAF'
        and deve.ci              = caaf.ci
        and deve.anno            = P_anno
        and deve.mese            = mens.mese
        and deve.voce            = voec2.codice
        and voec2.codice    in (P_irpef_ras,P_irpef_rasc,P_irpef_raap,P_irpef_ra1r,P_irpef_ra1c,P_irpef_rapc
                               ,P_add_r_ras,P_add_r_rasc,P_add_c_ras,P_add_c_rasc,P_add_c_rac,P_add_c_racc)
        and voec.codice     in (P_irpef_ris,P_irpef_risc,P_irpef_riap,P_irpef_ri1r,P_irpef_ri1c,P_irpef_riac
                               ,P_add_r_ris,P_add_r_risc,P_add_c_ris,P_add_c_risc,P_add_c_ria,P_add_c_riac)
        and nvl(caaf.nr_rate,0) != 0
        and P_rate           is not null
        and P_mese+nvl(caaf.nr_rate,0) < 13
        and mens.tipo           = 'N'
        and nvl(mens.cod_sequenza,' ') = nvl(P_cod_sequenza,' ') 
        and mens.mese     between P_mese+1
                              and P_mese+ caaf.nr_rate  - 1
        and abs(decode
                (voec2.specifica
                ,'IRPEF_RAS',nvl(caaf.irpef_db,0)
                ,'IRPEF_RASC',nvl(caaf.irpef_db_con,0)
                ,'IRPEF_RA1R', nvl(caaf.irpef_1r,0)
                ,'IRPEF_RA1C', nvl(caaf.irpef_1r_con,0)
                ,'IRPEF_RAAP', nvl(caaf.irpef_acconto_ap,0)
                ,'IRPEF_RAPC', nvl(caaf.irpef_acconto_ap_con,0)
                ,'ADD_R_RAS',  nvl(caaf.add_reg_dic_db,0)
                ,'ADD_R_RASC', nvl(caaf.add_reg_con_db,0)
                ,'ADD_C_RAS',  nvl(caaf.add_com_dic_db,0)
                ,'ADD_C_RASC', nvl(caaf.add_com_con_db,0)
                ,'ADD_C_RAC',  nvl(caaf.acc_add_com_dic_db,0)
                ,'ADD_C_RACC', nvl(caaf.acc_add_com_con_db,0)
                )) > 12
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = caaf.ci
               and nvl(rain.rapporto,'%') like P_rapporto
               and NVL(rain.gruppo,' ')   like P_gruppo
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = P_ente
                          and ambiente    = P_ambiente
                          and utente      = P_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
       and P_inserisci != 'E'                
     group by caaf.ci
          , mens.mese
          , mens.mensilita
          , voec.codice
          , voec.specifica
     ;
-- dbms_output.put_line('Righe inserite '||sql%rowcount);
     commit;
-- dbms_output.put_line('Inizio update');
-- update IRPEF SALDO
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_irpef) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_irpef_ris
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_irpef_ris
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 1: '||sql%rowcount);
    commit;
-- update IRPEF SALDO coniuge
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_irpef_con) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_irpef_risc
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_irpef_risc
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 1c: '||sql%rowcount);
    commit;    
--- update IRPEF Prima RATA
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_irpef_1r) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_irpef_ri1r
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_irpef_ri1r
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 2: '||sql%rowcount);
    commit;
--- update IRPEF Prima RATA Coniuge
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_irpef_1r_con) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_irpef_ri1c
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_irpef_ri1c
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 2c: '||sql%rowcount);
    commit;
 --- update IRPEF ACCONTO AP
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_irpef_ap) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_irpef_riap
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_irpef_riap
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 3: '||sql%rowcount);
    commit;
-- update IRPEF ACCONTO AP Coniuge
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_irpef_ap_con) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_irpef_riac
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_irpef_riac
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 4: '||sql%rowcount);
    commit;
-- update ADD.REG.IRPEF Dichiarante
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_reg_dic) - sum(imp)
             from deposito_variabili_economiche  m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_add_r_ris
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_add_r_ris
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
      and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 5: '||sql%rowcount);
    commit;
-- update ADD.REG. IRPEF Coniuge
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_reg_con) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_add_r_risc
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_add_r_Risc
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 6: '||sql%rowcount);
    commit;
-- update ADD.COM.IRPEF Dichiarante
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_com_dic) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_add_c_ris
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_add_c_ris
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 7: '||sql%rowcount);
    commit;
-- update ADD.COM. IRPEF Coniuge
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_com_con) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_add_c_risc
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_Add_C_Risc
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 8: '||sql%rowcount);
    commit;
-- update Acconto ADD.COM.IRPEF Dichiarante
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_acc_com_dic) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_add_c_ria
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_add_c_ria
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 9: '||sql%rowcount);
    commit;
-- update Acconto ADD.COM. IRPEF Coniuge
    update deposito_variabili_economiche x
       set imp =
          (select max(d.int_rate_acc_com_con) - sum(imp)
             from deposito_variabili_economiche m
                , denuncia_caaf d
            where m.anno = P_anno
              and d.ci_caaf = nvl(D_ci,d.ci_caaf)
              and m.ci   = x.ci
              and d.ci   = x.ci
              and d.anno = P_Anno_caaf
              and d.rettifica in ('1','C','E','G')
              and m.voce = x.voce
              and m.mese < x.mese
              and m.voce = P_add_c_riac
              group by d.ci)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce = P_Add_c_riac
       and mese = (select P_mese + nr_rate - 1
                     from denuncia_caaf
                    where anno     = P_Anno_caaf
                      and ci_caaf = nvl(D_ci,ci_caaf)
                      and ci       = x.ci
                      and rettifica in ('1','C','E','G')
                      and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
                      and nr_rate  > 2)
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 10: '||sql%rowcount);
    commit;
-- update segno rate
    update deposito_variabili_economiche x
       set imp = (select x.imp * decode(tipo,'C',-1,1)
                        from voci_economiche
                       where codice = x.voce)
     where input = 'CCAAF'
       and anno = P_anno
       and P_rate           is not null
       and voce in (P_irpef_ras,P_irpef_rasc,P_irpef_raap,P_irpef_ra1r,P_irpef_ra1c,P_irpef_rapc
                   ,P_irpef_ris,P_irpef_riap,P_irpef_ri1r,P_irpef_risc,P_irpef_ri1c
                   ,P_irpef_riac,P_add_r_ras,P_add_r_rasc,P_add_c_ras,P_add_c_rasc
                   ,P_add_r_ris,P_add_r_risc,P_add_c_ris,P_add_c_risc
                   ,P_add_c_rac,P_add_c_racc,P_add_c_ria,P_add_c_riac)
      and exists
         (select 'x' from denuncia_caaf
           where anno     = P_Anno_caaf
            and ci_caaf = nvl(D_ci,ci_caaf)
            and ci       = x.ci
            and rettifica in ('1','C','E','G')
            and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
         )
       and ci in ( select ci 
                     from rapporti_giuridici ragi 
                    where ragi.gestione like P_gestione
                 )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
       and P_inserisci != 'E'                
    ;
-- dbms_output.put_line('update 9: '||sql%rowcount);
    commit;
--
-- Cancellazione voci inserite a 0 o nulle
--
   delete from deposito_variabili_economiche x
     where input = 'CCAAF'
       and anno = P_anno
       and voce IN (P_irpef_cr, P_irpef_db, P_irpef_1r
                   , P_irpef_crc, P_irpef_dbc, P_irpef_1rc
                   , P_acconto_ap, P_acconto_apc
                   , P_irpef_ras, P_irpef_ris, P_irpef_ra1r, P_irpef_ri1r
                   , P_irpef_rasc, P_irpef_risc, P_irpef_ra1c, P_irpef_ri1c
                   , P_irpef_raap, P_irpef_riap, P_irpef_rapc, P_irpef_riac
                   , P_add_i_cr, P_add_i_db, P_add_i_crc, P_add_i_dbc
                   , P_add_r_ras, P_add_r_rasc, P_add_r_ris, P_add_r_risc
                   , P_add_c_cr, P_add_c_db, P_add_c_crc, P_add_c_dbc
                   , P_add_c_ras, P_add_c_rasc, P_add_c_ris, P_add_c_risc
                   , P_add_c_ac, P_add_c_rac, P_add_c_ria
                   , P_add_c_acc, P_add_c_racc, P_add_c_riac 
                   , P_irpef_2r,  P_irpef_2rc)
      and exists
         (select 'x' from denuncia_caaf
           where anno     = P_Anno_caaf
              and ci_caaf = nvl(D_ci,ci_caaf)
            and ci       = x.ci
            and rettifica in ('1','C','E','G')
            and data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
         )
      and ci in ( select ci 
                    from rapporti_giuridici ragi
                   where ragi.gestione like P_gestione
                )
      and nvl(imp,0) = 0
      and P_inserisci != 'E'
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = x.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
   ;
-- dbms_output.put_line('ultima delete '||sql%rowcount);
   commit;
/* Inserimento su movimenti_contabili */
   lock table movimenti_contabili in exclusive mode nowait;
   insert into movimenti_contabili 
     ( ci, anno, mese, mensilita, voce, sub, riferimento
     , data, imp_var, input )
   select deve.ci, P_anno,  deve.mese, deve.mensilita
        , deve.voce, deve.sub, deve.riferimento
        , sysdate, deve.imp, 'I'
     from deposito_variabili_economiche deve
    where anno = P_anno
      and mese >= P_mese
      and input = 'CCAAF'
      and anno_liquidazione is null
      and mensilita_liquidazione is null
      and mese_liquidazione is null
      and P_inserisci != 'E'                
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = deve.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
  ;
-- dbms_output.put_line('insert su moco'||sql%rowcount);
  update deposito_variabili_economiche deve
     set data_acquisizione   = sysdate
       , utente_acquisizione = P_utente
       , anno_liquidazione   = P_anno
       , mensilita_liquidazione = mensilita
       , mese_liquidazione      = mese
   WHERE anno = P_anno
      and mese >= P_mese
      and input = 'CCAAF'
      and anno_liquidazione is null
      and mensilita_liquidazione is null
      and mese_liquidazione is null
      and P_inserisci != 'E'
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = deve.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
  ;
-- dbms_output.put_line('update deve '||sql%rowcount);
  commit;
  update rapporti_giuridici ragi
     set flag_elab = 'P'
   where ci in 
   ( SELECT ragi2.ci 
       FROM rapporti_giuridici ragi2
          , denuncia_caaf caaf
       where ragi2.gestione like P_gestione
         and caaf.anno    = P_Anno_caaf
         and caaf.ci_caaf = decode(P_albo,null,caaf.ci_caaf,D_ci)
         and caaf.ci      = ragi.ci
         and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) 
                                     and nvl(P_data_ric_a,to_date('3333333','j'))
         and exists
            (select 'x'
               from rapporti_individuali rain
              where rain.ci = ragi2.ci
                and nvl(rain.rapporto,'%') like P_rapporto
                and NVL(rain.gruppo,' ')   like P_gruppo
                and (   rain.cc is null
                     or exists
                       (select 'x'
                          from a_competenze
                         where ente        = P_ente
                           and ambiente    = P_ambiente
                           and utente      = P_utente
                           and competenza  = 'CI'
                           and oggetto     = rain.cc
                       )
                    )
            ))
     and ragi.flag_elab in ('E','C')
     and ( P_anno, P_mese, P_mensilita ) in ( select anno, mese, mensilita from riferimento_retribuzione )
    ;
/* Inserimento voci non consentito dipendente non in servizio : cod.ind. */
     insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+10000
          , 'P05834'
          , to_char(ci)||
            ' -- INDICARE in ACAAF il "Conguaglio"'
       from rapporti_giuridici ragi
      where nvl(ragi.al,to_date('3333333','j')) < to_date(P_ini_ela,'ddmmyyyy')
        and exists
           (select 'x'
              from denuncia_caaf caaf
             where caaf.anno = P_Anno_caaf
               and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
               and caaf.ci   = ragi.ci
               and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
               and ((P_variabili = 'X' and
                     nvl(caaf.irpef_db,0)             +
                     nvl(caaf.irpef_db_con,0)         +
                     nvl(caaf.irpef_1r,0)             +
                     nvl(caaf.irpef_1r_con,0)         +
                     nvl(caaf.irpef_acconto_ap,0)     +
                     nvl(caaf.irpef_acconto_ap_con,0) +
                     nvl(caaf.add_reg_dic_db,0)       +
                     nvl(caaf.add_reg_con_db,0)       +
                     nvl(caaf.add_com_dic_db,0)       +
                     nvl(caaf.add_com_con_db,0)       +
                     nvl(caaf.acc_add_com_dic_db,0)   +
                     nvl(caaf.acc_add_com_con_db,0)   != 0
                                                  )
                or (P_seconda_rata = 'X' and
                    nvl(caaf.irpef_2r,0)             +
                    nvl(caaf.irpef_2r_con,0)        != 0
                                                       )
                                          )
           )
       and ragi.gestione like P_gestione
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = ragi.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
     ;
/* Archivi di Lavoro non caricati */
     insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+20000
          , 'P00600'
          , to_char(ci)||
            ' -- Seconde Rate Non Caricate"'
       from rapporti_giuridici ragi
      where exists
           (select 'x'
              from denuncia_caaf caaf
             where caaf.anno = P_Anno_caaf
               and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
               and caaf.ci   = ragi.ci
               and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
               and P_seconda_rata = 'X' 
               and conguaglio_2r is not null
           )
        and ragi.gestione like P_gestione
        and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = ragi.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
     ;
/* Inserimento voci non consentito dipendente non in servizio : cod.ind. */
   insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+30000
          , 'P05834'
          , to_char(ci)||
            ' -- Voci a Credito elaborate, verificare ACAAF'
       from rapporti_giuridici ragi
      where nvl(al,to_date('3333333','j'))  <  to_date(P_ini_ela,'ddmmyyyy')
        and exists
           (select 'x'
              from denuncia_caaf caaf 
             where caaf.anno = P_Anno_caaf
               and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
               and caaf.ci_caaf   = nvl(D_ci,caaf.ci_caaf)
               and caaf.ci   = ragi.ci
               and nvl(caaf.irpef_cr,0) + nvl(caaf.irpef_cr_con,0) + nvl(cssn_cr,0) 
               + nvl(add_reg_dic_cr,0) + nvl(add_reg_con_cr,0) 
               + nvl(add_com_dic_cr,0) + nvl(add_com_con_cr,0) != 0
           )
        and ragi.gestione like P_gestione
        and P_variabili = 'X'
        and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = ragi.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
     ;
/* Numero rate superiore alla mensilita di dicembre: cod.ind.: */
     insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+40000
          , 'P05839'
          , to_char(ci)
      from rapporti_giuridici ragi
     where exists ( select 'x'
                      from denuncia_caaf caaf
                     where caaf.anno = P_Anno_caaf
                       and caaf.data_ricezione  between nvl(P_data_ric,to_date('2222222','j'))
                                                    and nvl(P_data_ric_a,to_date('3333333','j'))
                       and caaf.ci   = ragi.ci
                       and caaf.ci_caaf   = nvl(D_ci,caaf.ci_caaf)
                       and P_mese - 1 + nvl(nr_rate,0) >12
                   )
       and P_rate is not null
       and ragi.gestione like P_gestione
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = ragi.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
     ;
/* Rapporto Individuale non valido in questo contesto */
     insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+50000
          , 'P01097'
          , ' - Cod.Ind.: '||to_char(caaf.ci)
       from denuncia_caaf        caaf
      where caaf.anno = P_Anno_caaf
        and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
        and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) 
                                    and nvl(P_data_ric_a,to_date('3333333','j'))
        and exists (select 'x'
                      from rapporti_individuali rain
                     where rain.ci = caaf.ci
                       and rain.rapporto = '*'
                       and NVL(rain.gruppo,' ')   like P_gruppo
                       and (   rain.cc is null
                            or exists (select 'x'
                                         from a_competenze
                                        where ente        = P_ente
                                          and ambiente    = P_ambiente
                                          and utente      = P_utente
                                          and competenza  = 'CI'
                                          and oggetto     = rain.cc
                                      )
                            )
                     )
     ;
/* Controllo su Validità del rapporto Giuridico */
     insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+55000
          , 'P01150' -- Rapporto Giuridico non presente
          , 'o incompleto - Cod.Ind.: '||to_char(caaf.ci)
       from denuncia_caaf        caaf
      where caaf.anno = P_Anno_caaf
        and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
        and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) 
                                    and nvl(P_data_ric_a,to_date('3333333','j'))
        and caaf.ci in ( select ci
                          from rapporti_individuali rain
                         where rain.ci = caaf.ci
                           and nvl(rain.rapporto,'%') like P_rapporto
                           and NVL(rain.gruppo,' ')   like P_gruppo
                           and (   rain.cc is null
                                or exists (select 'x'
                                             from a_competenze
                                            where ente        = P_ente
                                              and ambiente    = P_ambiente
                                              and utente      = P_utente
                                              and competenza  = 'CI'
                                              and oggetto     = rain.cc
                                          )
                                )
                     )
        and ( not exists ( select 'x' 
                            from rapporti_giuridici ragi
                           where ragi.ci =  caaf.ci
                         )
          or exists ( select 'x' 
                        from rapporti_giuridici ragi
                       where ragi.ci =  caaf.ci
                         and (   dal is null
                              or gestione is null )
                     )
             )
     ;
/* Controllo su data di ricezione e anno */
     insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+60000
          , 'P01069'
          , substr(' - Verificare dati caricati per Cod.Ind.: '||to_char(caaf.ci),1,50)
       from denuncia_caaf        caaf
      where caaf.anno = P_Anno_caaf
        and caaf.ci_caaf = nvl(D_ci,caaf.ci_caaf)
        and to_char(caaf.data_ricezione,'yyyy') != caaf.anno + 1
        and ci in ( select ci 
                      from rapporti_giuridici ragi
                     where ragi.gestione like P_gestione
                  )
        and exists (select 'x'
                        from rapporti_individuali rain
                       where rain.ci = caaf.ci
                         and nvl(rain.rapporto,'%') like P_rapporto
                         and NVL(rain.gruppo,' ')   like P_gruppo
                         and (   rain.cc is null
                              or exists (select 'x'
                                           from a_competenze
                                          where ente        = P_ente
                                            and ambiente    = P_ambiente
                                            and utente      = P_utente
                                            and competenza  = 'CI'
                                            and oggetto     = rain.cc
                                        )
                              )
                       )
     ;
/* Inserimento voci non consentito dipendente non in servizio : cod.ind. */
   insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+70000
          , 'P05834'
          , to_char(ci)||
            ' -- Voci a Rate elaborate, verificare ACAAF'
       from rapporti_giuridici ragi
      where exists
           (select 'x'
              from denuncia_caaf caaf 
             where caaf.anno = P_Anno_caaf
               and nvl(caaf.nr_rate,0) != 0
               and nvl(ragi.al,to_date('3333333','j')) < add_months(to_date(P_ini_ela,'ddmmyyyy'),nr_rate)
               and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
               and caaf.ci_caaf   = nvl(D_ci,caaf.ci_caaf)
               and caaf.ci   = ragi.ci
               and   nvl(caaf.irpef_db,0)             +
                     nvl(caaf.irpef_db_con,0)         +
                     nvl(caaf.irpef_1r,0)             +
                     nvl(caaf.irpef_1r_con,0)         +
                     nvl(caaf.irpef_acconto_ap,0)     +
                     nvl(caaf.irpef_acconto_ap_con,0) +
                     nvl(caaf.add_reg_dic_db,0)       +
                     nvl(caaf.add_reg_con_db,0)       +
                     nvl(caaf.add_com_dic_db,0)       +
                     nvl(caaf.add_com_con_db,0)       +
                     nvl(caaf.acc_add_com_dic_db,0)   +
                     nvl(caaf.acc_add_com_con_db,0)  != 0
            )
        and ragi.gestione like P_gestione
        and P_rate is not null
        and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = ragi.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
      ;
   insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
     select prenotazione
          , 1
          , rownum+80000
          , 'P05856'
          , to_char(ci)||
            ' -- Verificare ACAAF'
       from rapporti_giuridici ragi
      where exists
           (select 'x'
              from denuncia_caaf caaf 
             where caaf.anno = P_Anno_caaf
               and caaf.data_ricezione between nvl(P_data_ric,to_date('2222222','j')) and nvl(P_data_ric_a,to_date('3333333','j'))
               and caaf.ci_caaf   = nvl(D_ci,caaf.ci_caaf)
               and caaf.ci   = ragi.ci
               and (   (    P_variabili = 'X'
                        and (   least(abs(nvl(caaf.irpef_db,13)),13)             <= 12 and
                                nvl(caaf.irpef_db,0) != 0   
                             or least(abs(nvl(caaf.irpef_db_con,13)),13)         <= 12 and
                                nvl(caaf.irpef_db_con,0) != 0   
                             or least(abs(nvl(caaf.irpef_cr,13)),13)             <= 12 and
                                nvl(caaf.irpef_cr,0) != 0
                             or least(abs(nvl(caaf.irpef_cr_con,13)),13)         <= 12 and
                                nvl(caaf.irpef_cr_con,0) != 0
                             or least(abs(nvl(caaf.irpef_1r,13)),13)             <= 12 and  
                                nvl(caaf.irpef_1r,0) != 0
                             or least(abs(nvl(caaf.irpef_1r_con,13)),13)         <= 12 and
                                nvl(caaf.irpef_1r_con,0) != 0 
                             or least(abs(nvl(caaf.irpef_acconto_ap,13)),13)     <= 12 and
                                nvl(caaf.irpef_acconto_ap,0) != 0 
                             or least(abs(nvl(caaf.irpef_acconto_ap_con,13)),13) <= 12 and
                                nvl(caaf.irpef_acconto_ap_con,0) != 0 
                             or least(abs(nvl(caaf.add_reg_dic_db,13)),13)       <= 12 and
                                nvl(caaf.add_reg_dic_db,0) != 0 
                             or least(abs(nvl(caaf.add_reg_con_db,13)),13)       <= 12 and
                                nvl(caaf.add_reg_con_db,0) != 0 
                             or least(abs(nvl(caaf.add_com_dic_db,13)),13)       <= 12 and
                                nvl(caaf.add_com_dic_db,0) != 0 
                             or least(abs(nvl(caaf.add_com_con_db,13)),13)       <= 12 and 
                                nvl(caaf.add_com_con_db,0) != 0 
                             or least(abs(nvl(caaf.acc_add_com_dic_db,13)),13)   <= 12 and
                                nvl(caaf.acc_add_com_dic_db,0) != 0 
                             or least(abs(nvl(caaf.acc_add_com_con_db,13)),13)   <= 12 and 
                                nvl(caaf.acc_add_com_con_db,0) != 0 
                             or least(abs(nvl(caaf.add_reg_dic_cr,13)),13)       <= 12 and
                                nvl(caaf.add_reg_dic_cr,0) != 0 
                             or least(abs(nvl(caaf.add_reg_con_cr,13)),13)       <= 12 and 
                                nvl(caaf.add_reg_con_cr,0) != 0 
                             or least(abs(nvl(caaf.add_com_dic_cr,13)),13)       <= 12 and
                                nvl(caaf.add_com_dic_cr,0) != 0 
                             or least(abs(nvl(caaf.add_com_con_cr,13)),13)       <= 12 and
                                nvl(caaf.add_com_con_cr,0) != 0 
                            )
                       )
                    or (        P_rate = 'X'
                        and (   least(abs(nvl(caaf.irpef_db,13)),13)             <= 12 and
                                nvl(caaf.irpef_db,0) != 0
                             or least(abs(nvl(caaf.irpef_db_con,13)),13)         <= 12 and
                                nvl(caaf.irpef_db_con,0) != 0
                             or least(abs(nvl(caaf.irpef_1r,13)),13)             <= 12 and
                                nvl(caaf.irpef_1r,0) != 0
                             or least(abs(nvl(caaf.irpef_1r_con,13)),13)         <= 12 and
                                nvl(caaf.irpef_1r_con,0) != 0
                             or least(abs(nvl(caaf.irpef_acconto_ap,13)),13)     <= 12 and
                                nvl(caaf.irpef_acconto_ap,0) != 0
                             or least(abs(nvl(caaf.irpef_acconto_ap_con,13)),13) <= 12 and
                                nvl(caaf.irpef_acconto_ap_con,0) != 0
                             or least(abs(nvl(caaf.add_reg_dic_db,13)),13)       <= 12 and
                                nvl(caaf.add_reg_dic_db,0) != 0
                             or least(abs(nvl(caaf.add_reg_con_db,13)),13)       <= 12 and
                                nvl(caaf.add_reg_con_db,0) != 0
                             or least(abs(nvl(caaf.add_com_dic_db,13)),13)       <= 12 and
                                nvl(caaf.add_com_dic_db,0) != 0
                             or least(abs(nvl(caaf.add_com_con_db,13)),13)       <= 12 and
                                nvl(caaf.add_com_con_db,0) != 0
                             or least(abs(nvl(caaf.acc_add_com_dic_db,13)),13)   <= 12 and
                                nvl(caaf.acc_add_com_dic_db,0) != 0 
                             or least(abs(nvl(caaf.acc_add_com_con_db,13)),13)   <= 12 and 
                                nvl(caaf.acc_add_com_con_db,0) != 0 
                            )
                       )
                    or (    P_seconda_rata = 'X'
                        and (   least(abs(nvl(caaf.irpef_2r,13)),13)             <= 12 and
                                nvl(caaf.irpef_2r,0) != 0
                             or least(abs(nvl(caaf.irpef_2r_con,13)),13)         <= 12 and
                                nvl(caaf.irpef_2r_con,0) != 0
                            )
                       )
                  )
            )
        and ragi.gestione like P_gestione
        and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = ragi.ci
              and nvl(rain.rapporto,'%') like P_rapporto
              and NVL(rain.gruppo,' ')   like P_gruppo
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = P_ente
                         and ambiente    = P_ambiente
                         and utente      = P_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                       )
                     )
             )
      ;
 EXCEPTION
   when errore then
-- dbms_output.put_line('Passo da errore');
     null;
 END;
-- dbms_output.put_line('update su a_prenotazioni');
 update a_prenotazioni 
    set prossimo_passo  = 91
      , errore          = 'P05808'
  where no_prenotazione = prenotazione
    and exists
       (select 'x' from a_segnalazioni_errore
         where no_prenotazione = prenotazione
       )
 ;
 update a_prenotazioni 
    set prossimo_passo  = 92
  where no_prenotazione = prenotazione
    and not exists
       (select 'x' from a_segnalazioni_errore
         where no_prenotazione = prenotazione
       )
 ;
 commit;
ELSE -- generato errore nei controlli
-- dbms_output.put_line('Ho generato errori nei controlli');
 update a_prenotazioni 
    set prossimo_passo  = 91
      , errore          = 'P05808'
  where no_prenotazione = prenotazione
    and exists
       (select 'x' from a_segnalazioni_errore
         where no_prenotazione = prenotazione
       )
 ;
 update a_prenotazioni set prossimo_passo  = 92
  where no_prenotazione = prenotazione
    and not exists
       (select 'x' from a_segnalazioni_errore
         where no_prenotazione = prenotazione
       )
 ;
     commit;
end if; -- controllo su generazione errore V_errore
 EXCEPTION
   when uscita then
       update a_prenotazioni
          set prossimo_passo = 92
            , errore         = D_cod_errore
       where no_prenotazione = prenotazione;
  commit;
 END;
end;
end;
/
