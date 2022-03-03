CREATE OR REPLACE PACKAGE PECCADMI IS
/******************************************************************************
 NOME:        PECCADMI 
 DESCRIZIONE: Creazione delle registrazioni mensilita individuali per la 
              produzione della denuncia EMENS
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO P_tipo     determina il tipo di elaborazione da effettuare.
               Il PARAMETRO P_ruolo    indica se elaborare il personale di ruolo, non di
               ruolo o fuori ruolo
               Il PARAMETRO P_gestione determina quale gestione elaborare, valore di default %.
               Il PARAMETRO P_fascia    indica la fascia di gestione (campo fascia della tabella gestioni)
                                      , valore di default %.
               Il PARAMETRO P_rapporto determina quale classe di rapporto elaborare, valore di default %.

 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  18/03/2005 MS       Prima emissione ( Att. 8928 )
 1.1  21/04/2005 MS       Mod. per att. 10774
                          Corrette assunzioni e cessazioni
                          Corrette settimane utili per part-time e per rain.dal < pegi.dal
 1.2  21/04/2005 MS       Mod. per att. 10822 - Corretto unique_contraint su variabili
 1.3  22/04/2005 MS       Mod. per att. 10828 
                          Gestione degli arretrati AP
                          Revisione assunzione e cessazione
 1.4  22/04/2005 MS       Mod. per att. 10840 - Corrette arichiviazioni coco duplicate
 1.5  26/04/2005 MS       Mod. per att. 10850 - Corrette assunzioni su mesi precedenti
 1.6  26/04/2005 MS       Mod. per att. 10860 - Corretta estrazione fascia per ass.fam.
 1.7  26/04/2005 MS       Mod. per att. 10878 
                          Sistemazione controlli su delete con parametri diversi da %
                          Sistemazione ripresi per arretrati
 1.8  27/04/2005 MS       Mod. per att. 10895 - Sistemazione delete per tipo = P
 1.9  27/04/2005 MS       Mod. per att. 10856 - implementazione
 2.0  02/05/2005 MS       Mod. per att. 10973 - Sistemazione fondi e variabili per privati
 2.1  03/05/2005 MS       Mod. per att. 10896 - implementazione
 2.2  03/05/2005 MS       Mod. per att. 10978 - Adeguamento Oracle 7
 2.3  04/05/2005 MS       Mod. per att. 11037 - Corretta Aliquota coco
 2.4  04/05/2005 MS       Mod. per att. 11038 - Sistemazione dell'archiviazione con P_sfasato
 2.5  06/05/2005 MS       Mod. per att. 11072 
                          Cambiata estrazione dal per i coco
                          Corretta update su giorni e settimane
 2.6  06/05/2005 MS       Mod. per att. 10872 - Inserimento possibilità di archiviazione posticipata
 2.7  09/05/2005 MS       Mod. per att. 11074 - Corretta estrazione imponibile se riferimento diverso dal mese
 2.8  12/05/2005 MS       Mod. per att. 10872.1
 2.9  13/05/2005 MS       Mod. per att. 10895.1
 3.0  17/05/2005 MS       Mod. per att. 11204
                          Unificazione di periodi con stessa qualifica
                          Modifica assunzione e cessazione
 3.1  25/05/2005 MS       Mod. per att. 11344 + 11072.1
                          Sistemazione calcolo settimane per part-time
                          Sistemazione calcolo diff.accredito per privati 
 3.2  24/06/2005 MS       Mod. per att. 11673 - 11737
                          Aggiunta parametro P_posizione 
                          Aggiunto parametro per update su settimane utili con codice 71
 3.3  30/06/2005 MS       Mod. per att. 11766: Aggiunta segnalazione per importi negativi
 3.4  01/07/2005 MS       Mod. per att. 11753 + 11766 + 11801 + 11842
                          Cambio da NR a R : gestione del tipo contribuzione 99 per escludere la parte del ruolo
                          Corretti ripresi per arretrati
                          Aggiunta segnalazione per cambio di gestione nello stesso mese
                          Corretto ORA-01476: divisor is equal to zero
 3.5  11/07/2005 MS       Cambio chiave univoca e vista per accorpamenti ( Mod. per att. 11915 )
 3.6  15/07/2005 MS       Revisione per nuovi assegni familiari ( Mod. per att. 12017 )
 3.7  20/07/2005 MS       Mod. per att. 11915.1
 3.8  24/08/2005 MS       Assunzione inizio mese e cessazione fine mese ( Mod. per att. 12409 )
 3.9  06/10/2005 MS       Corretto Errore ORA6502 per GG.NEG ( Mod. per att. 12988 )
 4.0  07/11/2005 MS       Aggiunti campi in accorpamento sfasato per att. 13379
 4.1  16/11/2005 MS       Mod. estrazione giorni di ril P di pere ( Att: 13502 )
 4.2  19/12/2005 MS       Aggiunti campi  per CUD: ritenuta e contributo
 4.3  19/01/2006 MS       Mod. per riferimento voci COCO ( Att. 14468 )
 4.4  10/02/2006 MS       Mod. per attivita 14846 ( punti 1 e 2 )
 4.5  21/02/2006 MS       Mod. per attivita 14846 ( punti 3 e 4 )
 4.6  23/02/2006 MS       Estrazione Aliquota Storicizzata ( att. 15063 )
 4.7  06/03/2006 MS       Mod. gestione collaboratori ( Att.15156 )
 4.8  08/03/2006 MS       Aggiunta compile_all ( Att.15147 )
 4.9  14/03/2006 MS       Mod. gestione contributi coco a scaglione (Att.15230)
 5.0  14/03/2006 MS       Mod. gestione dipendenti con conguaglio AP (Att.15388)
 5.1  15/03/2006 MS       Nuova gestione campo TFR (Att.15387)
 5.2  20/03/2006 MS       Mod. function e lettura dati per calcolo giorni ( Att.15416 )
 5.3  29/03/2006 MS       Miglioria gestione coco 1% (att. 14880.1)
 5.4  15/05/2006 MS       Miglioria gestione gg neg ( att.15416.1 ) 
 5.5  15/05/2006 MS       Integrazione per enti privati ( att.16002 )
 5.6  30/05/2006 MS       Modifica per estrazione assenze privati a cavallo d'anno
 5.7  15/06/2006 MS       Modifica gestione parametro TFR (Att.16012)
 5.8  20/07/2006 MS       Sistemazione segnalazioni varie ( A17035 )
 5.9  19/09/2006 MS       Messa abs nella insert in vaie ( A17740 )
 5.10 17/10/2006 MS       Modificata lettura dell'IPN_FAM ( A17262 )
 5.11 20/10/2006 MS       Modificata gestione malattie privati ( A18151 )
 5.12 18/12/2006 MS       Corretta 53-esima settimana ( A18853 )
 5.13 20/12/2006 MS       Aggiunta possibilita di esporre malattie del mese corrente ( A18698 )
 5.14 22/01/2007 MS       Mod. passaggio del CI alla function GP4_INEX.GET_IPN_FAM ( Att. 19341 )
 5.15 14/02/2007 MS       Mod. passaggio del CI alle function CODICE_EVENTO( Att. 19341 )
 5.16 16/02/2007 MS       Mod. gestione settimane di Ril. P per enti privati ( Att. 19670 )
 5.17 02/03/2007 MS       Corretto Ora Err per CAFA doppio ( Att. 19986 )
 5.18 19/03/2007 MS       Aggiunta gestione del codice catasto ( Att. 20195 )
 5.19 04/03/2007 MS       Correzione dati Ril. P per enti privati ( Att. 19670.2 )
 5.20 09/05/2007 MS       Sistemazione delete per enti privati ( Att. 20887 )
 5.21 21/05/2007 MS       Aggiunta gestione della gestione alternativa 
                          Aggiunta archiviazione per Gruppo ( Att. 20885 )
 6.0  01/06/2007 MS       Adeguamento versione 2.1 ( Att. 20884 )
 6.1  01/06/2007 MS       Gestita cessazione ultimo giorno del mese.
 6.2  12/06/2007 MS       Correzioni da test per gestione TFR
 6.3  14/06/2007 MS       Correzioni da test per gestione TFR
 6.4  02/08/2007 MS       Adeguamento versione 2.1.1
 6.5  16/08/2007 MS       Correzioni per TFR privati ( att. 22433 )
 6.6  05/09/2007 MS       Correzioni da test per gestione TFR
 6.7  11/09/2007 MS       Correzioni da test per gestione TFR
 6.8  03/10/2007 MS       Modifica per privati settimane e bonus
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (VERSIONE , WNDS, WNPS);
PROCEDURE MAIN   (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCADMI IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V6.8 del 03/10/2007';
END VERSIONE;

PROCEDURE MAIN (prenotazione in number, passo in number) IS
P_ente            varchar2(4);
P_ambiente        varchar2(8);
P_utente          varchar2(8);
P_anno            varchar2(4);
P_mese            number(2);
P_ini_mese        date;
P_fin_mese        date;
P_gestione        varchar2(4);
P_fascia          varchar(2);
P_gruppo          varchar2(12);
P_rapporto        varchar2(4);
P_posizione       varchar2(4);
P_tipo            varchar2(1);
P_ci              number(8);
P_ruolo           varchar2(1);
P_tipo_gg         varchar2(1);
P_sfasato         varchar2(1);
P_posticipato     varchar2(1);
D_mese_den        number(2);
D_anno_den        varchar2(4);
D_ini_mese_prec   date;
D_fin_mese_prec   date;
V_imponibile      number := 0;
V_giorni          number := 0;
V_settimane       number := 0;
V_ritenuta        number := 0;

P_no_utili        varchar2(1);
P_tfr             varchar2(1);
P_tfr_privati     varchar2(1);
P_gestione_tfr    varchar2(1);
P_mal_privati     varchar2(1);
D_variabili_gape  number(1);
D_diff_accredito1 number(11,2);
D_diff_accredito2 number(11,2);
D_diff_accredito3 number(11,2);
D_diff_accredito4 number(11,2);
D_diff_accredito5 number(11,2);
D_diff_accredito6 number(11,2);
D_diff_accredito7 number(11,2);
D_gg_accredito1 number(5,2);
D_gg_accredito2 number(5,2);
D_gg_accredito3 number(5,2);
D_gg_accredito4 number(5,2);
D_gg_accredito5 number(5,2);
D_gg_accredito6 number(5,2);
D_gg_accredito7 number(5,2);

D_qualifica1      varchar2(1);
D_qualifica2      varchar2(1);
D_qualifica3      varchar2(1);
D_gestione_alternativa  varchar2(8);
D_tipo_contr      varchar2(2);
D_ci_cur          number(8) := 0;
D_conta_cur       number(4);
D_gg_neg          number(2);
D_sett_neg        number(5,2);
D_old_ci          number(8) := 0;
D_conta_rec       number := 0;
D_gg_ass          number(2);
D_tipo_ass        varchar2(2);
D_gg_cess         number(2);
D_tipo_cess       varchar2(2);
D_imponibile      number(12,2);
D_ritenuta        number(12,2);
D_contributo_coco_01 number(12,2);
D_contributo_coco_02 number(12,2);
D_ritenuta_coco_01 number(12,2);
D_ritenuta_coco_02 number(12,2);
D_arrotonda       number(12,2);
D_imponibile1     number(12,2);
D_imponibile_prg  number(12,2);
D_aliquota        number(5,2);
D_aliquota1       number(5,2);
D_aliquota2       number(5,2);
D_perc            number(5,2);
D_limite          number(10);
D_limite_max      number(10);
D_agevolazione    number(12,2);
D_rilevanza       varchar2(1);
D_assicurazione   varchar2(3);
D_max_riferimento date;
D_min_riferimento date;
D_dal_coco        date;
D_al_coco         date;
D_cond_af         varchar2(4);
D_nucleo_af       number(2);
D_nr_sca_af       varchar2(3);
D_tabella_af      varchar2(3);
D_ipn_fam         number(12,2);

D_min_aperl       date;
D_dal             date;
D_al              date;
D_succ_dal        date;
D_succ_al         date;
D_prec_dal        date;
D_id_sett         number(2);
D_conta_evento    number := 0;
D_tipo_copertura  varchar2(1);
D_cod_catasto     varchar2(4);
D_settore         number(6);

D_dal_preavviso   date;
D_al_preavviso    date;
D_dal_sind        date;
D_al_sind         date;

D_base_calcolo_tfr  number(12,2);
D_base_calcolo_pc   number(12,2);
D_imp_corrente      number(12,2);
D_imp_pregresso     number(12,2);
D_imp_liquidazione  number(12,2);
D_imp_anticipazione number(12,2);
D_tipo_scelta       varchar2(2);
D_data_scelta       date;
D_iscr_prev_obbl    varchar2(3);
D_iscr_prev_compl   varchar2(2);
D_fondo_tesoreria   varchar2(2);
D_data_adesione     date;
D_forma_prev        number(4);
D_tipo_quota        varchar2(4);
D_quota             number(5,2);

V_obj_invalid     number(3) := 0;
V_controllo       varchar2(1);
v_comando         varchar2(100);
V_esiste          varchar2(1);
D_pr_err          number(10) := 0;
D_precisazione    varchar2(200);
D_errore          varchar2(6);
USCITA            EXCEPTION;
BEGIN

-- Estrazione Parametri di Selezione
 BEGIN
   BEGIN
      select valore
        into P_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_ANNO'
      ;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
       select to_char(anno)
           into P_anno
         from riferimento_retribuzione
        where rire_id = 'RIRE'
       ;
   END;
   BEGIN
      select valore
        into P_mese
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_MESE'
      ;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
       select mese
         into P_mese
         from riferimento_retribuzione
        where rire_id = 'RIRE'
       ;
   END;
   BEGIN
      select to_date('01'||lpad(P_mese,2,'0')||lpad(P_anno,4,'0'),'ddmmyyyy')
           , last_day(to_date(lpad(P_mese,2,'0')||lpad(P_anno,4,'0'),'mmyyyy'))
        into P_ini_mese, P_fin_mese
        from dual
      ;
   END;
   BEGIN
      select valore
        into P_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TIPO'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_tipo := to_char(null);
   END;
   BEGIN
      select to_number(valore) D_ci
        into P_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_CI'
      ;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
            P_ci := to_number(null);
   END;
   IF nvl(P_ci,0) = 0 and nvl(P_tipo,'X') = 'S' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
   ELSIF nvl(P_ci,0) != 0 and nvl(P_tipo,'X') = 'T' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
   END IF;
   BEGIN
      select valore
        into P_gestione
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GESTIONE'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_gestione := '%';
   END;
   BEGIN
      select valore
        into P_fascia
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_FASCIA'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_fascia := '%';
   END;
   BEGIN
      select valore
        into P_rapporto
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_RAPPORTO'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_rapporto := '%';
   END;
   BEGIN
      select valore
        into P_gruppo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GRUPPO'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_gruppo := '%';
   END;
   BEGIN
      select valore
        into P_posizione
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_POSIZIONE'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_posizione := '%';
   END;
   BEGIN
      select valore
        into P_tipo_gg
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TIPO_GG'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_tipo_gg := to_char(null);
   END;
   BEGIN
      select valore
        into P_ruolo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_RUOLO'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_ruolo := '%';
   END;
   BEGIN
      select valore
        into P_no_utili
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_NO_UTILI'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_no_utili := null;
   END;
   BEGIN
      select valore
        into P_tfr
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TFR'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_tfr := null;
   END;
-- dbms_output.put_line('P_TFR: '||P_tfr);
   BEGIN
      select valore
        into P_tfr_privati
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_PRIVATI'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_tfr_privati := null;
   END;
   BEGIN
      select valore
        into P_gestione_tfr
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GESTIONE_TFR'
      ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
             P_gestione_tfr := null;
   END;
   BEGIN
      select valore
        into P_mal_privati
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_MAL_PRIVATI'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_mal_privati := null;
   END;
-- dbms_output.put_line('flag: '||P_mal_privati);
   BEGIN
    SELECT valore
         , decode( valore, 'X', decode(P_mese-1,0,12,P_mese-1)
                              , P_mese 
                 ) 
         , decode( valore, 'X', decode(P_mese-1,0,P_anno-1,P_anno)
                              , P_anno
                 ) 
      INTO P_sfasato
         , D_mese_den
         , D_anno_den
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_SFASATO'
    ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       P_sfasato := null;
       D_mese_den := nvl(D_mese_den,P_mese);
       D_anno_den := nvl(D_anno_den,P_anno);
   END;
   BEGIN
    SELECT valore
         , decode( valore, 'X', decode(P_mese+1,13,1,P_mese+1)
                              , P_mese 
                 ) 
         , decode( valore, 'X', decode(P_mese+1,13,P_anno+1,P_anno)
                              , P_anno
                 ) 
      INTO P_posticipato
         , D_mese_den
         , D_anno_den
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_POSTICIPATO'
    ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       P_posticipato := null;
       D_mese_den := nvl(D_mese_den,P_mese);
       D_anno_den := nvl(D_anno_den,P_anno);
   END;
   BEGIN
    select to_date('01'||lpad(decode(P_mese-1,0,12,P_mese-1),2,'0')
                       ||decode(P_mese-1,0,P_anno-1,P_anno)
                  ,'ddmmyyyy')
         , last_day(to_date(lpad(decode(P_mese-1,0,12,P_mese-1),2,'0')
                           ||decode(P_mese-1,0,P_anno-1,P_anno)
                           ,'mmyyyy'))
      INTO D_ini_mese_prec
         , D_fin_mese_prec
     from dual;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_ini_mese_prec := P_ini_mese;
       D_fin_mese_prec := P_fin_mese;
   END;

 -- controllo parametri
  IF P_sfasato = 'X' and P_posticipato = 'X' 
    THEN  D_errore := 'A05721';
       RAISE USCITA;
  END IF;
  V_controllo := null;
  IF P_sfasato = 'X' or P_posticipato = 'X' THEN
    BEGIN
     select 'X' 
       into V_controllo
       from gestioni
        where codice = P_gestione
        and P_gestione != '%';
    EXCEPTION 
     WHEN NO_DATA_FOUND THEN 
       IF P_tipo = 'S' THEN NULL;
        ELSE D_errore := 'P05130';
             RAISE USCITA;
       END IF;
     WHEN OTHERS THEN NULL;
    END;
  END IF; -- controllo parametri
  
   BEGIN
      select ente     D_ente
           , utente   D_utente
           , ambiente D_ambiente
        into P_ente, P_utente, P_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
   END;
 END; -- fine acquisizione parametri
-- Cancellazione Precedenti Archiviazioni
     BEGIN
     <<DEL>>
     lock table gestione_tfr_emens in exclusive mode nowait
     ;
     delete from gestione_tfr_emens gete
      where anno = P_anno and  mese = P_mese 
        and (    P_tipo = 'T'
             or ( P_tipo = 'S' and gete.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    ( select 'x' from gestione_tfr_emens 
                       where anno = gete.anno and  mese = gete.mese 
                         and ci       = gete.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = gete.anno and  mese = gete.mese 
                         and ci       = gete.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = gete.anno and  mese = gete.mese 
                         and ci       = gete.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = gete.anno and  mese = gete.mese 
                         and ci       = gete.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = gete.anno and  mese = gete.mese 
                         and ci       = gete.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union 
                      select 'x' from denuncia_emens 
                       where anno =gete.anno and  mese = gete.mese 
                         and ci       = gete.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )                      
                    )
                )
            )
        and (  ( P_tipo = 'S' and gete.ci = P_ci )
           or  ( P_tipo in ('P','V','I','T')
                   and exists (select 'x' 
                                 from periodi_retributivi pere
                                    , posizioni posi
                                where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                                  and competenza in ('P','C','A')
                                  and servizio   in ('Q','I','N')
                                  and ci          = gete.ci
                                  and pere.posizione like P_posizione
                                  and gestione       like P_gestione 
                                  and pere.gestione   in (select codice
                                                            from gestioni
                                                           where nvl(fascia,'%') like P_fascia)
                                  and pere.posizione  = posi.codice
                                  and ( posi.di_ruolo = P_ruolo
                                     or posi.collaboratore = 'SI'
                                     or P_ruolo = '%'
                                      )
                              )
                   )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = gete.ci
               and rain.rapporto       like P_rapporto
               and nvl(rain.gruppo,' ') like P_gruppo
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
-- dbms_output.put_line('Righe Cancellate: '||SQL%ROWCOUNT);
     lock table fondi_speciali_emens in exclusive mode nowait
     ;
     delete from fondi_speciali_emens fose
      where anno = P_anno and  mese = P_mese 
        and (    P_tipo = 'T'
             or ( P_tipo = 'S' and fose.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    ( select 'x' from gestione_tfr_emens 
                       where anno = fose.anno and  mese = fose.mese 
                         and ci       = fose.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = fose.anno and  mese = fose.mese 
                         and ci       = fose.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = fose.anno and  mese = fose.mese 
                         and ci       = fose.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = fose.anno and  mese = fose.mese 
                         and ci       = fose.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = fose.anno and  mese = fose.mese 
                         and ci       = fose.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union 
                      select 'x' from denuncia_emens 
                       where anno =fose.anno and  mese = fose.mese 
                         and ci       = fose.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )                      
                    )
                )
            )
        and (  ( P_tipo = 'S' and fose.ci = P_ci )
           or  ( P_tipo in ('P','V','I','T')
                   and exists (select 'x' 
                                 from periodi_retributivi pere
                                    , posizioni posi
                                where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                                  and competenza in ('P','C','A')
                                  and servizio   in ('Q','I','N')
                                  and ci          = fose.ci
                                  and pere.posizione like P_posizione
                                  and gestione       like P_gestione 
                                  and pere.gestione   in (select codice
                                                            from gestioni
                                                           where nvl(fascia,'%') like P_fascia)
                                  and pere.posizione  = posi.codice
                                  and ( posi.di_ruolo = P_ruolo
                                     or posi.collaboratore = 'SI'
                                     or P_ruolo = '%'
                                      )
                              )
                   )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = fose.ci
               and rain.rapporto       like P_rapporto
               and nvl(rain.gruppo,' ') like P_gruppo
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
     lock table dati_particolari_emens in exclusive mode nowait
     ;
     delete from dati_particolari_emens dape
      where anno = P_anno and  mese = P_mese 
        and (    P_tipo = 'T'
             or ( P_tipo = 'S' and dape.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    ( select 'x' from gestione_tfr_emens 
                       where anno = dape.anno and  mese = dape.mese 
                         and ci       = dape.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = dape.anno and  mese = dape.mese 
                         and ci       = dape.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = dape.anno and  mese = dape.mese 
                         and ci       = dape.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = dape.anno and  mese = dape.mese 
                         and ci       = dape.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = dape.anno and  mese = dape.mese 
                         and ci       = dape.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union 
                      select 'x' from denuncia_emens 
                       where anno = dape.anno and  mese = dape.mese 
                         and ci       = dape.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )  
                    )
                )
            )
        and (  ( P_tipo = 'S' and dape.ci = P_ci )
           or  ( P_tipo in ('P','V','I','T')
                   and exists (select 'x' 
                                 from periodi_retributivi pere
                                    , posizioni posi
                                where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                                  and competenza in ('P','C','A')
                                  and servizio   in ('Q','I','N')
                                  and ci          = dape.ci
                                  and pere.posizione like P_posizione
                                  and gestione       like P_gestione 
                                  and pere.gestione   in (select codice
                                                            from gestioni
                                                           where nvl(fascia,'%') like P_fascia)
                                  and pere.posizione  = posi.codice
                                  and ( posi.di_ruolo = P_ruolo
                                     or posi.collaboratore = 'SI'
                                     or P_ruolo = '%'
                                      )
                              )
                   )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = dape.ci
               and rain.rapporto       like P_rapporto
               and nvl(rain.gruppo,' ') like P_gruppo
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
     lock table variabili_emens in exclusive mode nowait
     ;
     delete from variabili_emens vaie
      where anno = P_anno and  mese = P_mese 
        and (    P_tipo = 'T'
             or ( P_tipo = 'S' and vaie.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    ( select 'x' from gestione_tfr_emens 
                       where anno = vaie.anno and  mese = vaie.mese 
                         and ci       = vaie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = vaie.anno and  mese =  vaie.mese 
                         and ci       = vaie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = vaie.anno and  mese = vaie.mese 
                         and ci       = vaie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = vaie.anno and  mese = vaie.mese 
                         and ci       = vaie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = vaie.anno and  mese = vaie.mese 
                         and ci       = vaie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union 
                      select 'x' from denuncia_emens 
                       where anno = vaie.anno and  mese = vaie.mese 
                         and ci       = vaie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )  
                    )
                )
            )
        and (    ( P_tipo = 'S' and vaie.ci = P_ci )
             or  ( P_tipo in ('P','V','I','T')
                   and exists (select 'x' 
                                 from periodi_retributivi pere
                                    , posizioni posi
                                where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                                  and competenza in ('P','C','A')
                                  and servizio   in ('Q','I','N')
                                  and ci          = vaie.ci
                                  and pere.posizione like P_posizione
                                  and gestione       like P_gestione 
                                  and pere.gestione   in (select codice
                                                            from gestioni
                                                           where nvl(fascia,'%') like P_fascia)
                                  and pere.posizione  = posi.codice
                                  and ( posi.di_ruolo = P_ruolo
                                     or posi.collaboratore = 'SI'
                                     or P_ruolo = '%'
                                      )
                              )
                 )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = vaie.ci
               and rain.rapporto       like P_rapporto
               and nvl(rain.gruppo,' ') like P_gruppo
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
     lock table settimane_emens in exclusive mode nowait 
     ;
     delete from settimane_emens seie
      where anno = P_anno and  mese = P_mese 
        and (    P_tipo = 'T'
             or ( P_tipo = 'S' and seie.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    (select 'x' from gestione_tfr_emens 
                       where anno = seie.anno and  mese = seie.mese 
                         and ci       = seie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens
                       where anno = seie.anno and  mese = seie.mese 
                         and ci       = seie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from  variabili_emens 
                       where anno = seie.anno and  mese = seie.mese 
                         and ci       = seie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = seie.anno and  mese = seie.mese 
                         and ci       = seie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = seie.anno and  mese = seie.mese 
                         and ci       = seie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union 
                      select 'x' from denuncia_emens 
                       where anno = seie.anno and  mese = seie.mese 
                         and ci       = seie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )  
                    )
                )
            )
        and (    ( P_tipo = 'S' and seie.ci = P_ci )
             or  ( P_tipo in ('P','V','I','T')
                   and exists (select 'x' 
                                 from periodi_retributivi pere
                                    , posizioni posi
                                where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                                  and competenza in ('P','C','A')
                                  and servizio   in ('Q','I','N')
                                  and ci          = seie.ci
                                  and pere.posizione like P_posizione
                                  and gestione       like P_gestione 
                                  and pere.gestione   in (select codice
                                                            from gestioni
                                                           where nvl(fascia,'%') like P_fascia)
                                  and pere.posizione  = posi.codice
                                  and ( posi.di_ruolo = P_ruolo
                                     or posi.collaboratore = 'SI'
                                     or P_ruolo = '%'
                                      )
                              )
                  )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = seie.ci
               and rain.rapporto       like P_rapporto
               and nvl(rain.gruppo,' ') like P_gruppo
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
     lock table denuncia_emens in exclusive mode nowait 
     ;
     delete from denuncia_emens deie
      where anno = P_anno and  mese = P_mese 
        and deie.ci      = nvl(P_ci,deie.ci)
        and deie.gestione  like P_gestione
        and deie.gestione   in (select codice
                                  from gestioni
                             where nvl(fascia,'%') like P_fascia)
        and (    P_tipo = 'T'
             or ( P_tipo = 'S' and deie.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    (select 'x' from denuncia_emens 
                       where anno = deie.anno and  mese = deie.mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno =  deie.anno and  mese = deie.mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = deie.anno and  mese = deie.mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = deie.anno and  mese = deie.mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union 
                      select 'x' from variabili_emens 
                       where anno = deie.anno and  mese = deie.mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )  
                       union 
                      select 'x' from gestione_tfr_emens 
                       where anno = deie.anno and  mese = deie.mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) ) 
                    )
                )
            )
        and (    P_ruolo = '%'
             or  ( P_tipo = 'S' and deie.ci = P_ci )
             or  ( P_tipo in ('P','V','I','T')
                   and exists (select 'x' 
                                 from periodi_retributivi pere
                                    , posizioni posi
                                where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                                  and competenza in ('P','C','A')
                                  and servizio   in ('Q','I','N')
                                  and ci          = deie.ci
                                  and pere.posizione like P_posizione
                                  and gestione       like P_gestione 
                                  and pere.gestione   in (select codice
                                                            from gestioni
                                                           where nvl(fascia,'%') like P_fascia)
                                  and pere.posizione  = posi.codice
                                  and ( posi.di_ruolo = P_ruolo
                                     or posi.collaboratore = 'SI'
                                      )
                              )
                   )
            )
        and not exists ( select 'x'
                           from settimane_emens 
                          where deie_id   = deie.deie_id
                         union
                         select 'x'
                           from variabili_emens 
                          where deie_id   = deie.deie_id
                          union
                         select 'x'
                           from dati_particolari_emens 
                          where deie_id   = deie.deie_id
                          union
                         select 'x'
                           from fondi_speciali_emens 
                          where deie_id   = deie.deie_id
                          union
                         select 'x'
                           from gestione_tfr_emens 
                          where deie_id   = deie.deie_id
                       )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = deie.ci
               and rain.rapporto       like P_rapporto
               and nvl(rain.gruppo,' ') like P_gruppo
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
     commit
     ;
   END DEL;
   FOR CUR_CI IN CURSORE_EMENS.CUR_CI_EMENS 
     ( P_tipo, P_ci, P_ruolo, P_anno, P_mese, P_posizione, P_gestione, P_fascia, P_rapporto, P_gruppo
      , P_tipo_gg, P_sfasato, D_anno_den, D_mese_den
      , P_ente, P_ambiente, P_utente )  LOOP
-- dbms_output.put_line('**********');
-- dbms_output.put_line('CUR_CI/GG: '||CUR_CI.ci||' '||CUR_CI.specie_rapporto);
-- dbms_output.put_line(' Periodo: '||CUR_CI.dal||' '||CUR_CI.al||' '||CUR_CI.gg_ret||' '||CUR_CI.sett_utili);
-- dbms_output.put_line('QUAL :'||CUR_CI.qualifica1||' '|| CUR_CI.qualifica2||' '|| CUR_CI.qualifica3);
/* azzeramento variabili */
   D_gestione_alternativa   := null;
   D_gg_ass         := null;
   D_tipo_ass       := null;
   D_gg_cess        := null;
   D_tipo_cess      := null;
   D_assicurazione  := null;
   D_imponibile     := null;
   D_ritenuta       := null;
   D_contributo_coco_01 := null;
   D_contributo_coco_02 := null;
   D_ritenuta_coco_01 := null;
   D_ritenuta_coco_02 := null;
   D_arrotonda      := null;
   D_imponibile1    := null;
   D_imponibile_prg := null;
   D_agevolazione   := null;
   D_aliquota       := null;
   D_aliquota1      := null;
   D_aliquota2      := null;
   D_perc           := null;
   D_limite         := null;
   D_limite_max     := null;

  IF nvl(D_ci_cur,0) != nvl(CUR_CI.ci,0) THEN
      D_conta_cur := 1;
      D_ci_cur := CUR_CI.ci;
  ELSE D_conta_cur := nvl(D_conta_cur,0) + 1;
  END IF;

  IF CUR_CI.codice_contribuzione != 99 or D_conta_cur = 1 THEN
      D_qualifica1     := CUR_CI.qualifica1;
      D_qualifica2     := CUR_CI.qualifica2;
      D_qualifica3     := CUR_CI.qualifica3;
      D_tipo_contr     := CUR_CI.tipo_contribuzione;
  END IF;

/* Estrazione assunzione e cessazione */

   IF CUR_CI.specie_rapporto = 'DIP' 
    THEN
     BEGIN
/* Estrazione Prima Assunzione del periodo */
      select lpad(to_char( decode(greatest(pegi.dal,CUR_CI.dal)
                         , pegi.dal, pegi.dal
                                   , to_date(null)
                                 ) ,'dd'),2,'0')
           , decode(greatest(pegi.dal,CUR_CI.dal)
                   , pegi.dal,evra.inps,null)
        into D_gg_ass, D_tipo_ass
        from periodi_giuridici pegi
           , eventi_rapporto evra
       where ci = CUR_CI.ci
         and pegi.rilevanza = 'P'
         and pegi.evento = evra.codice
         and evra.rilevanza = 'I'
         and CUR_CI.al between pegi.dal and nvl(pegi.al,P_fin_mese+1)
         and to_char(pegi.dal,'mmyyyy') = to_char(CUR_CI.al,'mmyyyy')
         and pegi.dal = ( select min(dal) 
                            from periodi_giuridici pegi1
                           where pegi1.ci = pegi.ci
                             and pegi1.rilevanza = 'P'
                             and CUR_CI.al between pegi1.dal and nvl(pegi1.al,P_fin_mese+1)
                             and pegi1.evento is not null
                        );
     EXCEPTION WHEN NO_DATA_FOUND THEN 
         D_gg_ass := null;
         D_tipo_ass := null;
     END;
-- dbms_output.put_line('Assunzione: '||D_gg_ass||' '||D_tipo_ass);
     BEGIN
/* Estrazione Ultima Cessazione del periodo */
       select lpad(to_char( decode(least(pegi.al,CUR_CI.al)
                                  , pegi.al, pegi.al
                                           , to_date(null)
                                  ) ,'dd'),2,'0')
           , decode(least(pegi.al,CUR_CI.al)
                        , pegi.al,evra.inps,null)
         into D_gg_cess, D_tipo_cess
        from periodi_giuridici pegi
           , eventi_rapporto evra
       where ci = CUR_CI.ci
         and pegi.rilevanza = 'P'
         and pegi.posizione = evra.codice
         and evra.rilevanza = 'T'
         and CUR_CI.al between pegi.dal and nvl(pegi.al,P_fin_mese+1)
         and to_char(pegi.al,'mmyyyy') = to_char(CUR_CI.al,'mmyyyy')
         and ( P_sfasato is null
           and  nvl(pegi.al,to_date('3333333','j')) <= P_fin_mese
            or P_sfasato = 'X'
           and nvl(pegi.al,to_date('3333333','j')) between to_date('01'||lpad(D_mese_den,2,'0')||D_anno_den,'ddmmyyyy')
                                                     and last_day(to_date(lpad(D_mese_den,2,'0')||D_anno_den,'mmyyyy'))
             )
         and pegi.al = (  select max(al) 
                            from periodi_giuridici pegi1
                           where pegi1.ci = pegi.ci
                             and pegi1.rilevanza = 'P'
                             and ( P_sfasato is null
                                and nvl(pegi1.al,to_date('3333333','j')) <= P_fin_mese
                                or P_sfasato = 'X'
                                and nvl(pegi1.al,to_date('3333333','j'))
                                    between to_date('01'||lpad(D_mese_den,2,'0')||D_anno_den,'ddmmyyyy')
                                        and last_day(to_date(lpad(D_mese_den,2,'0')||D_anno_den,'mmyyyy')) 
                                  )
                             and CUR_CI.al between pegi1.dal and nvl(pegi1.al,P_fin_mese+1)
                             and posizione is not null
                        )
          and not exists ( select 'x' 
                           from periodi_giuridici pegi2
                          where pegi2.ci = pegi.ci 
                            and pegi2.rilevanza     = 'P'
                            and pegi2.dal > pegi.dal
                            and ( P_sfasato is null 
                              and P_fin_mese between pegi2.dal and nvl(pegi2.al,P_fin_mese+1)
                              or  P_sfasato = 'X' 
                              and D_fin_mese_prec between pegi2.dal and nvl(pegi2.al,D_fin_mese_prec+1)
                                )
           )
           ;
     EXCEPTION WHEN NO_DATA_FOUND THEN 
         D_gg_cess := null;
         D_tipo_cess := null;
     END;
-- dbms_output.put_line('Cessazione: '||D_gg_cess||' '||D_tipo_cess);
   END IF; -- Fine assunzioni e cessazioni

/* estrazione dati assegni familiari */

   D_tabella_af := null;
   D_nucleo_af  := null;
   D_cond_af    := null;
   D_ipn_fam    := null;
   D_nr_sca_af  := null;
-- dbms_output.put_line('Assegni Familiari: ');
-- dbms_output.put_line('Tabella: '||D_tabella_af);
-- dbms_output.put_line('Nucleo: '||D_nucleo_af);
-- dbms_output.put_line('Cond: '||D_cond_af);
-- dbms_output.put_line('Ipn: '||D_ipn_fam);
-- dbms_output.put_line('Sca Af: '||D_nr_sca_af);
           BEGIN
           select lpad(to_char(cafa.nucleo_fam),2,'0')
                , cafa.cond_fam
                , tabella_inps
             into D_nucleo_af, D_cond_af, D_tabella_af
             from carichi_familiari         cafa
                , condizioni_familiari      cofa
            where cafa.anno       = P_anno
              and cafa.mese       = P_mese
              and cafa.ci         = CUR_CI.ci
              and cafa.cond_fam  is not null
              and cafa.cond_fam   = cofa.codice
           ;
           EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                  D_nucleo_af := null;
                  D_cond_af   := null;
                WHEN TOO_MANY_ROWS THEN 
                   select max(lpad(to_char(cafa.nucleo_fam),2,'0'))
                        , max(cafa.cond_fam)
                        , max(tabella_inps)
                     into D_nucleo_af, D_cond_af, D_tabella_af
                     from carichi_familiari         cafa
                        , condizioni_familiari      cofa
                    where cafa.anno       = P_anno
                      and cafa.mese       = P_mese
                      and cafa.ci         = CUR_CI.ci
                      and cafa.cond_fam  is not null
                      and cafa.cond_fam   = cofa.codice
                   ;
                  D_pr_err := nvl(D_pr_err,0)+1;
                  D_precisazione := substr(': esistono più registrazioni in ACAFA per CI: '||TO_CHAR(CUR_CI.ci),1,200);
/* P05351 Verificare Carico Familiare */                  
                  INSERT INTO a_segnalazioni_errore
                  (no_prenotazione, passo, progressivo, errore, precisazione)
                  select prenotazione,1,D_pr_err,'P05351',D_precisazione
                    from dual
                  where not exists (select 'x' from a_segnalazioni_errore
                                     where no_prenotazione = prenotazione
                                       and passo  = 1
                                       and errore = 'P05351'
                                       and precisazione = D_precisazione
                                    );
           END;
           IF D_cond_af is not null THEN
           BEGIN
              D_ipn_fam := GP4_INEX.GET_IPN_FAM ( CUR_CI.ci, P_anno, P_mese );
           EXCEPTION WHEN NO_DATA_FOUND THEN
              D_ipn_fam := null;
           END;
           BEGIN
           select scaf.numero_fascia
             into D_nr_sca_af
             from scaglioni_assegno_familiare   scaf
                , aggiuntivi_familiari          agfa
                , condizioni_familiari      cofa
            where cofa.codice     = D_cond_af
              and agfa.codice (+) = D_cond_af
              and agfa.dal (+)    = scaf.dal
              and cofa.cod_scaglione = decode(scaf.cod_scaglione,'99',cofa.cod_scaglione,scaf.cod_scaglione)
              and scaf.scaglione = ( select min(scaf1.scaglione) 
                                       from scaglioni_assegno_familiare scaf1
                                      where scaf1.dal = scaf.dal
                                        and scaf1.cod_scaglione = scaf.cod_scaglione
                                        and nvl(scaf1.scaglione,0) + nvl(agfa.aggiuntivo,0) >= D_ipn_fam 
                                   )
              and last_day(to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy')) 
                  between scaf.dal and nvl(scaf.al,to_date('3333333','j'))
           ;
           EXCEPTION WHEN NO_DATA_FOUND THEN 
              D_nr_sca_af := null;
                     WHEN TOO_MANY_ROWS THEN 
              D_nr_sca_af := null;
           END;
        END IF;

-- dbms_output.put_line('Assegni Familiari dopo: ');
-- dbms_output.put_line('Tabella: '||D_tabella_af);
-- dbms_output.put_line('Nucleo: '||D_nucleo_af);
-- dbms_output.put_line('Cond: '||D_cond_af);
-- dbms_output.put_line('Ipn: '||D_ipn_fam);
-- dbms_output.put_line('Sca Af: '||D_nr_sca_af);

    IF CUR_CI.specie_rapporto = 'DIP' THEN
    BEGIN
    select round( sum(vacm.valore*decode( vacm.colonna
                                        , 'IMPONIBILE', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
      into D_imponibile, D_ritenuta
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('IMPONIBILE','RITENUTA')
       and vacm.anno            = P_anno
       and vacm.mese            = P_mese
       and vacm.ci              = CUR_CI.ci
       and vacm.riferimento between CUR_CI.dal and CUR_CI.al
       and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    having round( sum(vacm.valore*decode( vacm.colonna
                                        , 'IMPONIBILE', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1) 
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1) != 0
      ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
              D_imponibile      := null;
              D_ritenuta        := null;
    END;
   END IF; -- imponibile dipendenti

-- dbms_output.put_line('impon: '||D_imponibile);

   IF CUR_CI.specie_rapporto = 'COCO' THEN 
     BEGIN
      select substr(rtrim(ltrim(codice_iad)),1,3)
        into D_assicurazione
        from rapporti_retributivi
       where ci = CUR_CI.ci;
     EXCEPTION WHEN NO_DATA_FOUND THEN 
         D_assicurazione := null;
     END;
-- dbms_output.put_line('ass: '||D_assicurazione);
    BEGIN
    <<IMP_COCO>>
/* Estrazione dati dei collaboratori */
    select nvl(max(decode(vacm.colonna
                     , 'IMPONIBILE_01', substr(esvc.note, instr(esvc.note,'<')+1, instr(esvc.note,'>')-2)
                                      , NULL)),38641)
         , nvl(max(decode(vacm.colonna
                    ,'IMPONIBILE_01' , substr(esvc.note, instr(esvc.note,'<',instr(esvc.note,'>'))+1
                                                     , (instr(esvc.note, '>',instr(esvc.note,'>')+1 )-1
                                                                            -instr(esvc.note,'<',instr(esvc.note,'>'))
                                           ) 
                       ), null)),84049)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'IMPONIBILE', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( max(vacm.valore*decode( vacm.colonna
                                        , 'ALIQUOTA', 1
                                                      , 0))
                )
         ,  round( sum(vacm.valore*decode( vacm.colonna
                                          , 'IMPONIBILE_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , max(decode(vacm.colonna
                     ,'ALIQUOTA_01' , substr(esvc.note, instr(esvc.note,'<',1,1)+1
                                                     , (instr(esvc.note, '>',1,1 ) - instr(esvc.note,'<',1,1)-1 )
                                           )
                                    , null))
         , max(decode(vacm.colonna
                    ,'ALIQUOTA_01' , substr(esvc.note, instr(esvc.note,'<',1,2)+1
                                                     , (instr(esvc.note, '>',1,2 ) - instr(esvc.note,'<',1,2)-1 )
                                           )
                                   , null))
         , max(decode(vacm.colonna
                    ,'ALIQUOTA_01' , substr(esvc.note, instr(esvc.note,'<',1,3)+1
                                                     , (instr(esvc.note, '>',1,3 ) - instr(esvc.note,'<',1,3)-1 )
                                           )
                                   , null))
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'AGEVOLAZIONE', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'AGEVOLAZIONE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'AGEVOLAZIONE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , nvl(max(decode( vacm.colonna, 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01), '')),1)
      into D_limite, D_limite_max, D_imponibile, D_aliquota
         , D_imponibile1, D_aliquota1, D_aliquota2, D_perc
         , D_agevolazione
         , D_contributo_coco_01, D_contributo_coco_02
         , D_ritenuta_coco_01, D_ritenuta_coco_02
         , D_arrotonda
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('IMPONIBILE','ALIQUOTA','AGEVOLAZIONE'
                                  ,'IMPONIBILE_01', 'ALIQUOTA_01'
                                  , 'CONTRIBUTO_COCO_01', 'CONTRIBUTO_COCO_02'
                                  , 'RITENUTA_COCO_01', 'RITENUTA_COCO_02')
       and vacm.anno            = P_anno
       and vacm.mese            = P_mese
       and vacm.ci              = CUR_CI.ci
       and last_day(to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy')) between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    having round( sum(vacm.valore*decode( vacm.colonna
                                        , 'IMPONIBILE', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                          , '')),1) 
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'IMPONIBILE_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1) 

         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)  != 0
      ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
              D_imponibile      := null;
              D_aliquota        := null;
              D_imponibile1     := null;
              D_aliquota1       := null;
              D_aliquota2       := null;
              D_contributo_coco_01 := null;
              D_contributo_coco_02 := null;
              D_ritenuta_coco_01 := null;
              D_ritenuta_coco_02 := null;
              D_arrotonda       := null;
              D_agevolazione    := null;
              D_limite          := null;
              D_limite_max      := null;
    END IMP_COCO;
-- dbms_output.put_line('D_limite: '||D_limite);
    BEGIN
    <<IMP_PRG>>
    select round( sum(vacm.valore*decode( vacm.colonna
                                        , 'IMPONIBILE_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
      into D_imponibile_prg
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('IMPONIBILE_01')
       and vacm.anno            = P_anno
       and vacm.mese            <= P_mese
       and vacm.ci              = CUR_CI.ci
       and vacm.mensilita      != '*AP'
       and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    having round( sum(vacm.valore*decode( vacm.colonna
                                        , 'IMPONIBILE_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1) != 0
      ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
              D_imponibile_prg  := null;
    END IMP_PRG;
-- dbms_output.put_line('ipn prg: '||D_imponibile_prg);
   END IF; -- estrazione dati collaboratori

-- dbms_output.put_line('fine coco');
   D_gg_neg := null;
   D_sett_neg := null;
   IF CUR_CI.specie_rapporto = 'DIP' THEN
   BEGIN
      select sum( decode( trpr.contribuzione
                  , 99, to_number(null)
                      , nvl(decode(P_tipo_gg,'I',pere.gg_inp ,pere.gg_con ),0)
                   ))
           , sum(decode( trpr.contribuzione
                  , 99,to_number(null)
                      , decode( posi.part_time 
                               , 'NO',to_number(null)
                               ,e_round(( ( nvl(cost.ore_gg,6) 
                                          * nvl(decode(P_tipo_gg,'I',pere.gg_inp ,pere.gg_con),0)
                                     ) * ( pere.ore / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro) ) 
                                   ) / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)
                                 ,'I')
                    )))
        into D_gg_neg, D_sett_neg
        from periodi_retributivi pere
           , contratti_storici   cost
           , posizioni           posi
           , trattamenti_previdenziali trpr
       where ci = CUR_CI.ci
         and periodo = last_day(to_date(lpad(P_mese,2,'0')||to_number(P_anno),'mmyyyy'))
         and competenza = 'P'
         and posi.codice        (+)  = pere.posizione
         and trpr.codice    (+) = pere.trattamento
         and pere.al between CUR_CI.dal and CUR_CI.al
         and GET_QUALIFICA1_EMENS(pere.qualifica) = CUR_CI.qualifica1
         and GET_QUALIFICA2_EMENS(pere.posizione) = CUR_CI.qualifica2
         and GET_QUALIFICA3_EMENS(pere.posizione) = CUR_CI.qualifica3
         and cost.contratto (+) = pere.contratto
         and pere.periodo between cost.dal and nvl(cost.al,to_date('3333333','j'))
       ;
   EXCEPTION WHEN NO_DATA_FOUND THEN 
-- dbms_output.put_line('no data found su gg neg');
      D_gg_neg := NULL;
      D_sett_neg := null;
   END;
   END IF;
-- dbms_output.put_line('GGNEG/SETT 1 - rec. uguali: '||D_gg_neg||' '||D_sett_neg);

/* segnalazioni su tipo rapporto e attivita */
   IF ( sign(2-length(CUR_CI.tipo_rapporto)) = -1 
     or CUR_CI.specie_rapporto = 'COCO' and CUR_CI.tipo_rapporto is null ) THEN
      D_pr_err := nvl(D_pr_err,0)+1;
      D_precisazione := substr(CUR_CI.tipo_rapporto||' per CI: '||TO_CHAR(CUR_CI.ci),1,200);
      INSERT INTO a_segnalazioni_errore
      (no_prenotazione, passo, progressivo, errore, precisazione)
      select prenotazione,1,D_pr_err,'P07932',D_precisazione
        from dual
      where not exists (select 'x' from a_segnalazioni_errore
                         where no_prenotazione = prenotazione
                           and passo  = 1
                           and errore = 'P07932'
                           and precisazione = D_precisazione
                        );
   END IF;
   IF sign(2-length(CUR_CI.attivita)) = -1 THEN
      D_pr_err := nvl(D_pr_err,0)+1;
      D_precisazione := substr(CUR_CI.attivita||' per CI: '||TO_CHAR(CUR_CI.ci),1,200);
      INSERT INTO a_segnalazioni_errore
      (no_prenotazione, passo, progressivo, errore, precisazione)
      select prenotazione,1,D_pr_err,'P04141',D_precisazione
        from dual
      where not exists (select 'x' from a_segnalazioni_errore
                         where no_prenotazione = prenotazione
                           and passo  = 1
                           and errore = 'P04141'
                           and precisazione = D_precisazione
                        );
   END IF;

   BEGIN
     select gestione
       into D_gestione_alternativa
       from def_gestione_denunce
      where contratto = CUR_CI.contratto
        and posizione = CUR_CI.posizione
    ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
       D_gestione_alternativa := null;
   END;
   BEGIN 
   D_rilevanza := 'C';
/* Inserimento record dipendenti */
   IF CUR_CI.specie_rapporto = 'DIP' THEN
-- dbms_output.put_line('ins1: '||CUR_CI.dal||' '||CUR_CI.al||' '||CUR_CI.sett_utili||' '||D_gg_ass||' '||D_gg_cess);
-- dbms_output.put_line('ins1 Giorni: '||CUR_CI.gg_ret||' '||D_gg_neg||' '||D_sett_neg);
-- dbms_output.put_line('ins1 imponibile: '||D_imponibile);
    INSERT INTO DENUNCIA_EMENS 
       ( deie_id, ci, anno, mese
       , dal, al
       , rilevanza, gestione, gestione_alternativa
       , riferimento, specie_rapporto 
       , qualifica1, qualifica2, qualifica3
       , tipo_contribuzione, codice_contratto
       , giorno_assunzione, tipo_assunzione, giorno_cessazione, tipo_cessazione
       , tipo_lavoratore
       , imponibile, ritenuta
       , giorni_retribuiti, settimane_utili
       , tab_anf, num_anf, classe_anf
       , utente, tipo_agg, data_agg) 
    SELECT DEIE_SQ.nextval, CUR_CI.CI, P_anno, P_mese
         , nvl(CUR_CI.dal,P_ini_mese), nvl(CUR_CI.al,P_fin_mese)
         , D_rilevanza, CUR_CI.gestione, D_gestione_alternativa
         , decode( P_sfasato,'X', decode( to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy')
                                        , lpad(P_mese,2,'0')||P_anno, to_char(add_months(nvl(CUR_CI.al,P_fin_mese),-1),'mmyyyy')
                                                                    , to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy'))
                                , to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy'))
         , CUR_CI.specie_rapporto
         , D_qualifica1, D_qualifica2, D_qualifica3
         , decode(D_tipo_contr,0,null,D_tipo_contr), CUR_CI.codice_contratto
         , D_gg_ass, decode(nvl(D_gg_ass,0),0,null,D_tipo_ass)
         , D_gg_cess, decode(nvl(D_gg_cess,0),0,null,D_tipo_cess)
         , '0'
         , D_imponibile, D_ritenuta
         , CUR_CI.gg_ret+nvl(D_gg_neg,0), CUR_CI.sett_utili+nvl(D_sett_neg,0)
         , D_tabella_af, D_nucleo_af, D_nr_sca_af
         , P_utente, null, sysdate
       FROM DUAL;
    commit;
    END IF; -- fine inserimento dipendenti
   IF CUR_CI.specie_rapporto = 'COCO' THEN
/* Inserimento collaboratori 10 e 15 */
   IF  nvl(D_imponibile,0) != 0 THEN
-- dbms_output.put_line('ins record coco1: '||' '||CUR_CI.dal||' '||CUR_CI.al||' '||CUR_CI.sett_utili);

/* Inserimento aliquote 10 e 15 */
    INSERT INTO DENUNCIA_EMENS 
       ( deie_id, ci, anno, mese
       , dal, al
       , rilevanza, gestione, gestione_alternativa
       , riferimento, specie_rapporto 
       , imponibile, aliquota 
       , contributo, ritenuta
       , tipo_rapporto, cod_attivita, altra_ass
       , imp_agevolazione , tipo_agevolazione
       , utente, tipo_agg, data_agg) 
    SELECT DEIE_SQ.nextval, CUR_CI.CI, P_anno, P_mese
         , nvl(CUR_CI.dal,P_ini_mese), nvl(CUR_CI.al,P_fin_mese)
         , D_rilevanza, CUR_CI.gestione, D_gestione_alternativa
         , to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy'), CUR_CI.specie_rapporto
         , least( nvl(D_limite_max,84049), nvl(D_imponibile,0) ), nvl(D_aliquota,0)
         , D_contributo_coco_01, D_ritenuta_coco_01
         , decode(sign(2-length(CUR_CI.tipo_rapporto)),-1, null, CUR_CI.tipo_rapporto )
         , decode(sign(2-length(CUR_CI.attivita)),-1, null, CUR_CI.attivita)
         , D_assicurazione
         , D_agevolazione, decode(nvl(D_agevolazione,0),0,null,'01')
         , P_utente, null, sysdate
       FROM DUAL;
    commit;
   END IF;
   IF nvl(D_imponibile1,0) != 0 and nvl(D_imponibile_prg,0) <= D_limite 
      THEN
/* Inserimento coco a scaglioni, solo primo scaglione */
-- dbms_output.put_line('ins record coco SOLO primo scaglione: '||D_imponibile1);
    INSERT INTO DENUNCIA_EMENS 
       ( deie_id, ci, anno, mese
       , dal, al
       , rilevanza, gestione, gestione_alternativa
       , riferimento, specie_rapporto 
       , imponibile, aliquota
       , contributo, ritenuta
       , tipo_rapporto, cod_attivita, altra_ass
       , imp_agevolazione , tipo_agevolazione
       , utente, tipo_agg, data_agg) 
    SELECT DEIE_SQ.nextval, CUR_CI.CI, P_anno, P_mese
         , nvl(CUR_CI.dal,P_ini_mese), nvl(CUR_CI.al,P_fin_mese)
         , D_rilevanza, CUR_CI.gestione, D_gestione_alternativa
         , to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy'), CUR_CI.specie_rapporto
         , nvl(D_imponibile1,0), nvl(D_aliquota1,0)
         , D_contributo_coco_01, D_ritenuta_coco_01
         , decode(sign(2-length(CUR_CI.tipo_rapporto)),-1, null, CUR_CI.tipo_rapporto )
         , decode(sign(2-length(CUR_CI.attivita)),-1, null, CUR_CI.attivita)
         , D_assicurazione
         , D_agevolazione, decode(nvl(D_agevolazione,0),0,null,'01')
         , P_utente, null, sysdate
       FROM DUAL;
    commit;
    ELSIF nvl(D_imponibile1,0) != 0 and nvl(D_imponibile_prg,0) > D_limite 
      and ( nvl(D_imponibile_prg,0) - nvl(D_imponibile1,0 ) ) <= D_limite
    THEN
-- dbms_output.put_line('ins record coco primo scaglione');
/* mese di cambio scaglione */
/* inserimento coco primo scaglione */
    INSERT INTO DENUNCIA_EMENS 
       ( deie_id, ci, anno, mese
       , dal, al
       , rilevanza, gestione, gestione_alternativa
       , riferimento, specie_rapporto 
       , imponibile, aliquota 
       , contributo, ritenuta
       , tipo_rapporto, cod_attivita, altra_ass
       , imp_agevolazione , tipo_agevolazione
       , utente, tipo_agg, data_agg) 
    SELECT DEIE_SQ.nextval, CUR_CI.CI, P_anno, P_mese
         , nvl(CUR_CI.dal,P_ini_mese), nvl(CUR_CI.al,P_fin_mese)
         , D_rilevanza, CUR_CI.gestione, D_gestione_alternativa
         , to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy'), CUR_CI.specie_rapporto
         , D_imponibile1 - ( least( nvl(D_limite_max,84049) , nvl(D_imponibile_prg,0) - nvl(D_limite,0) ))
         , D_aliquota1
         , decode( D_perc
                  , 1, round( ( D_imponibile1 - ( least( nvl(D_limite_max,84049) 
                                                       , nvl(D_imponibile_prg,0) - nvl(D_limite,0) )))
                            / 100*D_aliquota1
                            / D_arrotonda ) * D_arrotonda
                     , D_contributo_coco_01
                 )
         , decode( D_perc
                  , 1, round( ( ( D_imponibile1 - ( least( nvl(D_limite_max,84049) 
                                                       , nvl(D_imponibile_prg,0) - nvl(D_limite,0) )))
                            / 100*D_aliquota1 ) / 3
                            / D_arrotonda ) * D_arrotonda
                     , D_ritenuta_coco_01
                 )
         , decode(sign(2-length(CUR_CI.tipo_rapporto)),-1, null, CUR_CI.tipo_rapporto )
         , decode(sign(2-length(CUR_CI.attivita)),-1, null, CUR_CI.attivita)
         , D_assicurazione
         , D_agevolazione, decode(nvl(D_agevolazione,0),0,null,'01')
         , P_utente, null, sysdate
       FROM DUAL;
/* inserimento secondo scaglione */
-- dbms_output.put_line('ins record coco secondo scaglione');
    INSERT INTO DENUNCIA_EMENS 
       ( deie_id, ci, anno, mese
       , dal, al
       , rilevanza, gestione, gestione_alternativa
       , riferimento, specie_rapporto 
       , imponibile, aliquota 
       , contributo, ritenuta
       , tipo_rapporto, cod_attivita, altra_ass
       , imp_agevolazione , tipo_agevolazione
       , utente, tipo_agg, data_agg) 
    SELECT DEIE_SQ.nextval, CUR_CI.CI, P_anno, P_mese
         , nvl(CUR_CI.dal,P_ini_mese), nvl(CUR_CI.al,P_fin_mese)
         , D_rilevanza, CUR_CI.gestione, D_gestione_alternativa
         , to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy'), CUR_CI.specie_rapporto
         , decode( sign ( nvl(D_imponibile_prg,0) - nvl(D_limite_max,84049) )
                 ,1 ,  nvl(D_imponibile_prg,0)  - nvl(D_limite,0) - nvl(84049,84049)
                    , least( nvl(D_limite_max,84049) , nvl(D_imponibile_prg,0) ) - nvl(D_limite,0)
                 ) 
         , D_aliquota2
         , decode( D_perc
                  , 1, round(  D_contributo_coco_01 + D_contributo_coco_02
                           - ( D_imponibile1 - ( least( nvl(D_limite_max,84049) , nvl(D_imponibile_prg,0) - nvl(D_limite,0) )) 
                             )/100*D_aliquota1
                            / D_arrotonda ) * D_arrotonda
                     , D_contributo_coco_02
                 )
         , decode( D_perc
                  , 1, round(  D_ritenuta_coco_01 + D_ritenuta_coco_02
                            - ( ( D_imponibile1 - ( least( nvl(D_limite_max,84049) , nvl(D_imponibile_prg,0) - nvl(D_limite,0) )) 
                               )/100*D_aliquota1 ) / 3
                            / D_arrotonda ) * D_arrotonda
                     , D_ritenuta_coco_02
                 )
         , decode(sign(2-length(CUR_CI.tipo_rapporto)),-1, null, CUR_CI.tipo_rapporto )
         , decode(sign(2-length(CUR_CI.attivita)),-1, null, CUR_CI.attivita)
         , D_assicurazione
         , D_agevolazione, decode(nvl(D_agevolazione,0),0,null,'01')
         , P_utente, null, sysdate
       FROM DUAL;
    ELSIF nvl(D_imponibile1,0) != 0 and ( nvl(D_imponibile_prg,0) - nvl(D_imponibile1,0 ) ) > D_limite
    THEN
/* inserimento secondo scaglione */
-- dbms_output.put_line('ins record coco SOLO secondo scaglione');
    INSERT INTO DENUNCIA_EMENS 
       ( deie_id, ci, anno, mese
       , dal, al
       , rilevanza, gestione, gestione_alternativa
       , riferimento, specie_rapporto 
       , imponibile, aliquota
       , contributo, ritenuta 
       , tipo_rapporto, cod_attivita, altra_ass
       , imp_agevolazione , tipo_agevolazione
       , utente, tipo_agg, data_agg) 
    SELECT DEIE_SQ.nextval, CUR_CI.CI, P_anno, P_mese
         , nvl(CUR_CI.dal,P_ini_mese), nvl(CUR_CI.al,P_fin_mese)
         , D_rilevanza, CUR_CI.gestione, D_gestione_alternativa
         , to_char(nvl(CUR_CI.al,P_fin_mese),'mmyyyy'), CUR_CI.specie_rapporto
         , decode ( sign( nvl(D_imponibile_prg,0) - nvl( D_limite_max, 0) )
                  , 1, nvl(D_imponibile1,0)- ( nvl(D_imponibile_prg,0) - nvl( D_limite_max, 0) )
                     , nvl(D_imponibile1,0) )
         , D_aliquota2
         , decode( D_perc
                  , 1, D_contributo_coco_01 + D_contributo_coco_02 
                     , D_contributo_coco_02 )
         , decode( D_perc
                  , 1, D_ritenuta_coco_01 + D_ritenuta_coco_02
                     , D_ritenuta_coco_02 )
         , decode(sign(2-length(CUR_CI.tipo_rapporto)),-1, null, CUR_CI.tipo_rapporto )
         , decode(sign(2-length(CUR_CI.attivita)),-1, null, CUR_CI.attivita)
         , D_assicurazione
         , D_agevolazione, decode(nvl(D_agevolazione,0),0,null,'01')
         , P_utente, null, sysdate
       FROM DUAL;
    END IF; -- fine inserimento aliquote a scaglioni
    END IF; -- fine inserimento collaboratori
   END; -- fine inserimento 1

-- dbms_output.put_line('fine loop cur_ci');

END LOOP; -- CUR_CI

 FOR CUR_DIP in CURSORE_EMENS.CUR_DIP_EMENS 
     ( P_tipo, P_ci, P_anno, P_mese, P_posizione, P_gestione, P_fascia, P_ruolo, P_rapporto , P_gruppo
     , P_ente, P_ambiente, P_utente , 'N'
     )  LOOP
-- dbms_output.put_line('CUR_DIP '||CUR_DIP.CI||' '||CUR_DIP.dal||' '||CUR_DIP.al);
/* verifico l'esistenza di periodi P con al maggiore della C */
-- dbms_output.put_line(' calcola giorni ');
     D_gg_neg := null;
     D_sett_neg := null;
     BEGIN
      select sum( decode( trpr.contribuzione
                  , 99, 0
                      , nvl(decode(P_tipo_gg,'I',pere.gg_inp,pere.gg_con), 0 )
                   ))
           , sum(decode( trpr.contribuzione
                  , 99,to_number(null)
                      , decode( posi.part_time 
                               , 'NO',to_number(null)
                               ,e_round(( ( nvl(cost.ore_gg,6) 
                                          * nvl(decode(P_tipo_gg,'I',pere.gg_inp,pere.gg_con), 0 )
                                     ) * ( pere.ore / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro) ) 
                                   ) / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)
                                 ,'I')
                    )))
        into D_gg_neg, D_sett_neg
        from periodi_retributivi pere
           , contratti_storici   cost
           , posizioni           posi
           , trattamenti_previdenziali trpr
       where ci = CUR_DIP.ci
         and periodo = last_day(to_date(lpad(P_mese,2,'0')||to_number(P_anno),'mmyyyy'))
         and competenza = 'P'
         and posi.codice    (+) = pere.posizione
         and trpr.codice    (+) = pere.trattamento
         and GET_QUALIFICA1_EMENS(pere.qualifica) = CUR_DIP.qualifica1
         and GET_QUALIFICA2_EMENS(pere.posizione) = CUR_DIP.qualifica2
         and GET_QUALIFICA3_EMENS(pere.posizione) = CUR_DIP.qualifica3
         and not exists ( select 'x' 
                            from denuncia_emens demi
                           where ci = pere.ci
                             and anno = P_anno
                             and mese = P_mese
                             and pere.al between nvl(demi.dal,P_ini_mese) and nvl(demi.al,P_fin_mese)
                             -- and to_char(pere.al,'mmyyyy') = to_char(demi.al,'mmyyyy')
                             and GET_QUALIFICA1_EMENS(pere.qualifica) = demi.qualifica1
                             and GET_QUALIFICA2_EMENS(pere.posizione) = demi.qualifica2
                             and GET_QUALIFICA3_EMENS(pere.posizione) = demi.qualifica3
                        ) 
         and not exists ( select 'x' 
                            from denuncia_emens demi
                           where ci = pere.ci
                             and anno = P_anno
                             and mese = P_mese
                             and pere.al  > nvl(demi.al,P_fin_mese)
                             and to_char(demi.al,'mmyyyy') = to_char(CUR_DIP.al,'mmyyyy')
                             and demi.dal > cur_dip.dal
                             and GET_QUALIFICA1_EMENS(pere.qualifica) = demi.qualifica1
                             and GET_QUALIFICA2_EMENS(pere.posizione) = demi.qualifica2
                             and GET_QUALIFICA3_EMENS(pere.posizione) = demi.qualifica3
                             and demi.qualifica1 = CUR_DIP.qualifica1
                             and demi.qualifica2 = CUR_DIP.qualifica2
                             and demi.qualifica3 = CUR_DIP.qualifica3
                        ) 
         and cost.contratto (+) = pere.contratto
         and to_char(pere.al,'mmyyyy') = to_char(CUR_DIP.al,'mmyyyy')
         and pere.periodo between cost.dal
                              and nvl(cost.al,to_date('3333333','j'))
       ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
-- dbms_output.put_line('seconda no data found sui gg neg');
      D_gg_neg := null;
      D_sett_neg := null;
     END;
-- dbms_output.put_line('GGNEG/SETT 2 - pere esterni : '||D_gg_neg||' '||D_sett_neg);
       IF nvl(D_gg_neg,0) != 0 or nvl(D_sett_neg,0) != 0 THEN
-- dbms_output.put_line('eseguo update');
        update denuncia_emens deie
           set giorni_retribuiti = nvl(giorni_retribuiti,0) + nvl(D_gg_neg,0) 
             , settimane_utili = nvl(settimane_utili,0) + nvl(D_sett_neg,0) 
         where deie_id = CUR_DIP.deie_id
       ;
        commit;
       ELSE
       BEGIN
-- dbms_output.put_line('cursore giorni da detrarre ');
        FOR CUR_GG_NEG in 
        ( select GET_QUALIFICA1_EMENS(pere.qualifica) qualifica1
               , GET_QUALIFICA2_EMENS(pere.posizione) qualifica2
               , GET_QUALIFICA3_EMENS(pere.posizione) qualifica3
               , GET_TIPO_CONTRIBUZIONE_EMENS(trpr.contribuzione) tipo_contribuzione
               , cost.con_inps                                codice_contratto
               , pere.gestione
               , gede.gestione      gestione_alternativa
               , sum( decode( trpr.contribuzione
                             , 99, 0
                                 , nvl(decode(P_tipo_gg,'I',pere.gg_inp,pere.gg_con), 0 )
                             ))                               gg_neg
               , sum(decode( trpr.contribuzione
                             , 99,to_number(null)
                                 , decode( posi.part_time 
                                          , 'NO',to_number(null)
                                                ,e_round(( ( nvl(cost.ore_gg,6) 
                                                        * nvl(decode(P_tipo_gg,'I',pere.gg_inp,pere.gg_con), 0 )
                                                           ) * ( pere.ore /decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro) ) 
                                                         )/ decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)
                                                        ,'I')
                       )))                                    sett_neg
           from periodi_retributivi pere
              , contratti_storici   cost
              , posizioni           posi
              , trattamenti_previdenziali trpr
              , def_gestione_denunce      gede
          where ci = CUR_DIP.ci
            and periodo = last_day(to_date(lpad(P_mese,2,'0')||to_number(P_anno),'mmyyyy'))
            and competenza = 'P'
            and posi.codice    (+) = pere.posizione
            and trpr.codice    (+) = pere.trattamento
            and gede.posizione (+) = pere.posizione
            and gede.contratto (+) = pere.contratto
            and pere.al            = CUR_DIP.al
            and ( GET_QUALIFICA1_EMENS(pere.qualifica) != CUR_DIP.qualifica1
               or GET_QUALIFICA2_EMENS(pere.posizione) != CUR_DIP.qualifica2
               or GET_QUALIFICA3_EMENS(pere.posizione) != CUR_DIP.qualifica3 
                )
            and not exists ( select 'x' 
                            from denuncia_emens demi
                           where ci = pere.ci
                             and anno = P_anno
                             and mese = P_mese
                             -- and pere.al between nvl(demi.dal,P_ini_mese) and nvl(demi.al,P_fin_mese)
                             and to_char(pere.al,'mmyyyy') = to_char(demi.al,'mmyyyy')
                             and GET_QUALIFICA1_EMENS(pere.qualifica) = demi.qualifica1
                             and GET_QUALIFICA2_EMENS(pere.posizione) = demi.qualifica2
                             and GET_QUALIFICA3_EMENS(pere.posizione) = demi.qualifica3
                        ) 
            and cost.contratto (+) = pere.contratto
            and pere.periodo between cost.dal and nvl(cost.al,to_date('3333333','j'))
        group by GET_QUALIFICA1_EMENS(pere.qualifica)
               , GET_QUALIFICA2_EMENS(pere.posizione)
               , GET_QUALIFICA3_EMENS(pere.posizione)
               , GET_TIPO_CONTRIBUZIONE_EMENS(trpr.contribuzione)
               , pere.gestione, gede.gestione 
               , cost.con_inps
        ) LOOP
        BEGIN
-- dbms_output.put_line('GGNEG/SETT - pere diversi : '||CUR_GG_NEG.gg_neg||' '||CUR_GG_NEG.sett_neg);
          IF nvl(CUR_GG_NEG.gg_neg,0) != 0 or nvl(CUR_GG_NEG.sett_neg,0) != 0 THEN
           INSERT INTO DENUNCIA_EMENS 
                ( deie_id, ci, anno, mese, dal, al, rilevanza
                , gestione, gestione_alternativa
                , riferimento, rettifica, specie_rapporto
                , qualifica1, qualifica2, qualifica3
                , tipo_contribuzione, codice_contratto, tipo_lavoratore
                , giorni_retribuiti, settimane_utili
                , utente, tipo_agg, data_agg ) 
           select DEIE_SQ.nextval, CUR_DIP.ci, P_anno, P_mese, CUR_DIP.dal, CUR_DIP.al, 'C'
                , CUR_GG_NEG.gestione, CUR_GG_NEG.gestione_alternativa
                , to_char(CUR_DIP.al,'mmyyyy'), 'S', 'DIP'
                , CUR_GG_NEG.qualifica1, CUR_GG_NEG.qualifica2, CUR_GG_NEG.qualifica3
                , CUR_GG_NEG.tipo_contribuzione, CUR_GG_NEG.codice_contratto, 0
                , CUR_GG_NEG.gg_neg,  CUR_GG_NEG.sett_neg
                , P_utente, null, sysdate
             from dual 
           ;
              commit;
           END IF;   
        END;
        END LOOP; -- CUR_GG_NEG
       END;
     END IF; -- fine controllo gg_neg
   END LOOP; -- cur_dip

  FOR CUR_DIP_SETT in CURSORE_EMENS.CUR_DIP_EMENS 
     ( P_tipo, P_ci, P_anno, P_mese, P_posizione, P_gestione, P_fascia, P_ruolo, P_rapporto  , P_gruppo
     , P_ente, P_ambiente, P_utente , 'S'
     )  LOOP

  IF nvl(D_old_ci,0) != nvl(CUR_DIP_SETT.ci,0) THEN
      D_conta_rec := 1;
      D_old_ci := CUR_DIP_SETT.ci;
  ELSE D_conta_rec := nvl(D_conta_rec,0) + 1;
  END IF;

   BEGIN
     select nvl(min(pegi_p.dal),CUR_DIP_SETT.dal)
      into D_min_aperl
      from periodi_giuridici pegi_p
     where rilevanza = 'P'
       and ci = CUR_DIP_SETT.ci
       and CUR_DIP_SETT.al BETWEEN pegi_p.dal
                               and nvl(pegi_p.al,P_fin_mese)
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
     D_min_aperl := CUR_DIP_SETT.dal;
   END;

   BEGIN
   <<SETTIMANE>>
/* Estrazione settimana */

   D_succ_dal := null;
   D_succ_al  := null;
   D_dal      := null;
   D_al       := null;

   IF nvl(CUR_DIP_SETT.giorni_retribuiti,0) != 0 and CUR_DIP_SETT.specie_rapporto = 'DIP'
      THEN
-- dbms_output.put_line('sett '||CUR_DIP_SETT.dal||' dal aperl: '||D_min_aperl);
   IF P_sfasato = 'X' THEN 
     D_dal := greatest(CUR_DIP_SETT.dal,greatest(D_min_aperl,D_ini_mese_prec));
     D_al  := least(CUR_DIP_SETT.al,D_fin_mese_prec);
   ELSE
     D_dal := greatest(CUR_DIP_SETT.dal,greatest(D_min_aperl,TO_DATE('01'||to_char(CUR_DIP_SETT.al,'mmyyyy'),'ddmmyyyy')));
     D_al  := least(CUR_DIP_SETT.al,P_fin_mese);
   END IF;
-- dbms_output.put_line('DAL/AL: '||D_dal||' '||D_al);
   BEGIN 
      WHILE d_dal <= d_al LOOP
        D_succ_dal := GP4EC.get_next_day( D_dal,'SUNDAY','AMERICAN');
        IF to_char(D_succ_dal,'yyyy') = to_char(D_succ_al,'yyyy')+1 THEN
           D_succ_al  := CUR_DIP_SETT.al;
        ELSE
           D_succ_al  := D_succ_dal-1;
        END IF;
        D_id_sett := GP4EC.get_week_nr(D_succ_al,'AMERICAN');
        D_succ_al  := least(D_al, D_succ_dal-1);
-- dbms_output.put_line('carico sett: '||D_dal||' '||D_succ_al||' '||D_id_sett);
        INSERT INTO SETTIMANE_EMENS
             ( CI, ANNO, MESE, DAL_EMENS, DEIE_ID, DAL, AL, ID_SETTIMANA
             , TIPO_COPERTURA
             , UTENTE , TIPO_AGG, DATA_AGG ) 
        select CUR_DIP_SETT.CI, P_anno, P_mese, CUR_DIP_SETT.dal, CUR_DIP_SETT.deie_id, D_dal, D_succ_al, D_id_sett
             , 'X'
             , P_utente, null, sysdate
          from dual
         where not exists ( select 'x' 
                              from settimane_emens
                             where anno = P_anno
                               and mese = P_mese
                               and ci  = CUR_DIP_SETT.ci
                               and dal = D_dal
                               and id_settimana = D_id_sett
                          )
          ;
        D_dal := D_succ_dal;
   END LOOP; -- conteggio settimane
   commit;
   END; 
  END IF; -- controllo su specie e rapporto
  END SETTIMANE;

   BEGIN
      select ente.variabili_gape
        into D_variabili_gape
        from ente;
   EXCEPTION WHEN NO_DATA_FOUND THEN
        D_variabili_gape := 1;
   END;
-- dbms_output.put_line('conta : '||D_conta_rec||' gape : '||D_variabili_gape||'par : '||P_mal_privati);
-- dbms_output.put_line('mese: '||P_mese);

   IF P_mal_privati = 'P' and D_conta_rec = 1 and D_variabili_gape > 0
      and ( P_mese != 1 and P_mese-D_variabili_gape > 0
          or P_mese = 1 and 13-D_variabili_gape > 0 ) 
   THEN
   BEGIN
   <<MAL_PRIVATI_P>>
   BEGIN -- inserisco record P 
-- dbms_output.put_line('malattie privati');
    D_rilevanza := 'P';
    INSERT INTO DENUNCIA_EMENS 
       ( deie_id, ci, anno, mese,  dal,al
       , rilevanza, gestione, gestione_alternativa
       , riferimento, specie_rapporto 
       , qualifica1, qualifica2, qualifica3
       , tipo_contribuzione, codice_contratto, tipo_lavoratore
       , codice_catasto
       , giorno_assunzione, tipo_assunzione
       , giorno_cessazione, tipo_cessazione
       , giorni_retribuiti, settimane_utili
       , tab_anf, num_anf, classe_anf
       , tfr
       , utente, tipo_agg, data_agg)
    SELECT DEIE_SQ.nextval, CI, P_anno, P_mese
         , greatest(dal, to_date('01'||lpad( ( decode(P_mese, 1, 13, P_mese) - D_variabili_gape) ,2,'0')|| decode(P_mese, 1, P_anno-1, P_anno ),'ddmmyyyy'))
         , least(al, last_day(to_date(lpad( ( decode(P_mese, 1, 13, P_mese) - D_variabili_gape) ,2,'0')|| decode(P_mese, 1, P_anno-1, P_anno ),'mmyyyy')))
         , D_rilevanza, gestione , gestione_alternativa
         , lpad(P_mese,2,'0')||P_anno, specie_rapporto
         , qualifica1, qualifica2, qualifica3
         , tipo_contribuzione, codice_contratto, tipo_lavoratore
         , codice_catasto 
         , giorno_assunzione, tipo_assunzione
         , giorno_cessazione, tipo_cessazione
         , giorni_retribuiti, settimane_utili
         , tab_anf, num_anf, classe_anf
         , decode(substr(riferimento,1,2),'02',tfr,null)
         , P_utente, null, sysdate
      FROM denuncia_emens deie
     where deie.ci = CUR_DIP_SETT.ci
       and deie.anno = decode(P_mese, 1, P_anno-1, P_anno )
       and deie.mese = decode(P_mese, 1, 13, P_mese) - D_variabili_gape
       and deie.rilevanza = 'C'
       and deie.riferimento = lpad(deie.mese,2,'0')||deie.anno;
-- dbms_output.put_line('fine insert P: '||sql%rowcount);
    commit;
    insert into dati_particolari_emens
    ( ci, anno, mese, dal_emens, deie_id
    , identificatore, imponibile, dal, al, num_settimane, anno_rif, settimane_utili
    , utente, tipo_agg, data_agg )
    select dape.ci, P_anno, P_mese
         , greatest(dape.dal_emens, to_date('01'||lpad( ( decode(P_mese, 1, 13, P_mese) - D_variabili_gape) ,2,'0')|| decode(P_mese, 1, P_anno-1, P_anno ),'ddmmyyyy'))
         , deie.deie_id
         , dape.identificatore, dape.imponibile, dape.dal, dape.al
         , dape.num_settimane, dape.anno_rif, dape.settimane_utili
         , P_utente, null, sysdate
      FROM dati_particolari_emens dape
         , denuncia_emens deie
     where dape.ci = CUR_DIP_SETT.ci
       and dape.anno = decode(P_mese, 1, P_anno-1, P_anno )
       and dape.mese = decode(P_mese, 1, 13, P_mese) - D_variabili_gape
       and deie.rilevanza = 'P'
       and deie.anno = P_anno
       and deie.mese = P_mese
       and deie.ci   = dape.ci
       and not exists ( select 'x' 
                          from dati_particolari_emens
                         where anno = P_anno
                           and mese = P_mese
                           and ci  = CUR_DIP_SETT.ci
                           and dal = dape.dal
                           and identificatore = dape.identificatore
                          );
    commit;
    INSERT INTO settimane_emens
       (  ci, anno, mese, dal_emens, deie_id, dal, al, id_settimana, tipo_copertura
        , utente, tipo_agg, data_agg)  
    SELECT seie.ci, P_anno, P_mese
         , greatest(seie.dal_emens, to_date('01'||lpad( ( decode(P_mese, 1, 13, P_mese) - D_variabili_gape) ,2,'0')|| decode(P_mese, 1, P_anno-1, P_anno ),'ddmmyyyy'))
         , deie.deie_id
         , seie.dal, seie.al, id_settimana, tipo_copertura
         , P_utente, null, sysdate
      FROM settimane_emens seie
         , denuncia_emens deie
     where seie.ci = CUR_DIP_SETT.ci
       and seie.anno = decode(P_mese, 1, P_anno-1, P_anno )
       and seie.mese = decode(P_mese, 1, 13, P_mese) - D_variabili_gape
       and to_char(seie.dal,'mm') = decode(P_mese, 1, 13, P_mese) - D_variabili_gape
       and to_char(seie.al,'mm') = decode(P_mese, 1, 13, P_mese) - D_variabili_gape
       and deie.rilevanza = 'P'
       and deie.anno = P_anno
       and deie.mese = P_mese
       and deie.ci   = seie.ci
       and nvl(seie.dal,to_date('2222222','j')) <= nvl(deie.al,to_date('3333333','j'))
       and nvl(seie.al,to_date('3333333','j')) >= nvl(deie.dal,to_date('2222222','j'))
       and not exists ( select 'x' 
                          from settimane_emens
                         where anno = P_anno
                           and mese = P_mese
                           and ci  = CUR_DIP_SETT.ci
                           and dal = seie.dal
                           and id_settimana = seie.id_settimana
                           and dal_emens = greatest(seie.dal_emens, to_date('01'||lpad( ( decode(P_mese, 1, 13, P_mese) - D_variabili_gape) ,2,'0')|| decode(P_mese, 1, P_anno-1, P_anno ),'ddmmyyyy'))
                          );
-- dbms_output.put_line('fine insert sett settimane: '||sql%rowcount);
   commit;
    END; -- insert P
      FOR CUR_SETT1 IN 
        ( select seie.dal_emens, seie.dal, seie.al , seie.id_settimana
            from settimane_emens seie
               , denuncia_emens deie
           where seie.ci = CUR_DIP_SETT.ci
             and seie.mese = P_mese
             and seie.anno = P_anno
             and to_char(seie.dal,'mm') = decode(P_mese, 1, 13, P_mese) - D_variabili_gape
             and to_char(seie.al,'mm') = decode(P_mese, 1, 13, P_mese) - D_variabili_gape
             and deie.deie_id = seie.deie_id
             and deie.rilevanza = 'P'
          order by 2,3
        ) LOOP
-- dbms_output.put_line('cur sett1 '||cur_sett1.dal||' '||cur_sett1.al||' '||cur_sett1.id_settimana);
      BEGIN
          D_conta_evento := 0;
          D_prec_dal := null;
          D_tipo_Copertura := null;
       FOR CUR_ASSENZE1 IN ( 
           SELECT distinct prpr.codice
             FROM EVENTI_PRESENZA           evpa
                , causali_evento            caev
                , prospetti_presenza        prpr
                , righe_prospetto_presenza  rppa
            WHERE evpa.input      = 'V'
              AND evpa.ci         = CUR_DIP_SETT.ci
             AND CUR_SETT1.dal    <= evpa.al
             AND CUR_SETT1.al     >= evpa.dal
             and evpa.causale    = caev.codice
             and caev.codice     = rppa.colonna
             and rppa.prospetto  = prpr.codice
             and prpr.note like '%EMENS%'
           ) LOOP
           D_conta_evento := nvl( D_conta_evento,0 ) + 1;
-- dbms_output.put_line('assenza : '||cur_assenze1.codice||'conta : '||D_conta_evento);
           update settimane_emens
              set codice_evento1 = decode(D_conta_evento,1,CUR_ASSENZE1.codice,codice_evento1)
                , codice_evento2 = decode(D_conta_evento,2,CUR_ASSENZE1.codice,codice_evento2)
                , codice_evento3 = decode(D_conta_evento,3,CUR_ASSENZE1.codice,codice_evento3)
                , codice_evento4 = decode(D_conta_evento,4,CUR_ASSENZE1.codice,codice_evento4)
                , codice_evento5 = decode(D_conta_evento,5,CUR_ASSENZE1.codice,codice_evento5)
                , codice_evento6 = decode(D_conta_evento,6,CUR_ASSENZE1.codice,codice_evento6)
                , codice_evento7 = decode(D_conta_evento,7,CUR_ASSENZE1.codice,codice_evento7)
              where ci = CUR_DIP_SETT.ci
                and mese = P_mese
                and anno = P_anno
                and dal = CUR_SETT1.dal
                and al = CUR_SETT1.al ;
             commit;
-- dbms_output.put_line('dopo update1');
            update settimane_emens 
               set tipo_copertura =  ( select decode( nvl( length( codice_evento1||codice_evento2||codice_evento3
                                                                 ||codice_evento4||codice_evento5||codice_evento6
                                                                 ||codice_evento7
                                                          ),0)
                                                    , 0, tipo_copertura , '2' )
                                         from settimane_emens
                                        where ci = CUR_DIP_SETT.ci
                                          and mese = P_mese
                                          and anno = P_anno
                                          and dal_emens = CUR_SETT1.dal_emens
                                          and dal = CUR_SETT1.dal
                                          and al = CUR_SETT1.al )
              where ci = CUR_DIP_SETT.ci
                and mese = P_mese
                and anno = P_anno
                and dal_emens = CUR_SETT1.dal_emens
                and dal = CUR_SETT1.dal
                and al = CUR_SETT1.al ;
-- dbms_output.put_line('dopo update2');
            IF CUR_ASSENZE1.codice in ( 'MAL','INF') THEN 
               D_pr_err := nvl(D_pr_err,0)+1;
               D_precisazione := substr(' per CI: '||TO_CHAR(CUR_DIP_SETT.ci)||' - Dal: '||to_char(CUR_SETT1.DAL,'dd/mm/yyyy'),1,200);
               INSERT INTO a_segnalazioni_errore
               (no_prenotazione, passo, progressivo, errore, precisazione)
               VALUES (prenotazione,1,D_pr_err,'P07064',D_precisazione);
            END IF;
        END LOOP; -- cur_assenze1
-- dbms_output.put_line('dal/al sett1: '||CUR_SETT1.dal||' '||CUR_SETT1.al);

      END;
      END LOOP; -- cur_sett1
      BEGIN
      <<DIFFERENZE>>
        D_diff_accredito1 := null;
        D_diff_accredito2 := null;
        D_diff_accredito3 := null;
        D_diff_accredito4 := null;
        D_diff_accredito5 := null;
        D_diff_accredito6 := null;
        D_diff_accredito7 := null;
        D_gg_accredito1 := null;
        D_gg_accredito2 := null;
        D_gg_accredito3 := null;
        D_gg_accredito4 := null;
        D_gg_accredito5 := null;
        D_gg_accredito6 := null;
        D_gg_accredito7 := null;
        FOR CUR_EVENTO1 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 1 )
        LOOP
        BEGIN
         D_diff_accredito1 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO1.dal,CUR_EVENTO1.al, CUR_EVENTO1.codice_evento );
         D_gg_accredito1   := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO1.dal,CUR_EVENTO1.al, CUR_EVENTO1.codice_evento );
-- dbms_output.put_line('evento1: '||CUR_EVENTO1.dal||' '||CUR_EVENTO1.al||' '||D_gg_accredito1);
        END;
         update settimane_emens
            set diff_accredito1 = round(D_diff_accredito1 * nvl(D_gg_accredito1,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO1.dal
            and al   = CUR_EVENTO1.al
            and codice_evento1 = CUR_EVENTO1.codice_evento;
         commit;
        END LOOP; -- cur_evento1

        FOR CUR_EVENTO2 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 2 )
        LOOP
        D_diff_accredito2 := null;
        BEGIN
         D_diff_accredito2 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO2.dal,CUR_EVENTO2.al, CUR_EVENTO2.codice_evento );
         D_gg_accredito2 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO2.dal,CUR_EVENTO2.al, CUR_EVENTO2.codice_evento );
        END;
         update settimane_emens
            set diff_accredito2 = round(D_diff_accredito2 * nvl(D_gg_accredito2,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO2.dal
            and al   = CUR_EVENTO2.al
            and codice_evento2 = CUR_EVENTO2.codice_evento;
         commit;
        END LOOP; -- cur_evento2

        FOR CUR_EVENTO3 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 3 )
        LOOP
        D_diff_accredito3 := null;
        BEGIN
         D_diff_accredito3 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO3.dal,CUR_EVENTO3.al, CUR_EVENTO3.codice_evento );
         D_gg_accredito3 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO3.dal,CUR_EVENTO3.al, CUR_EVENTO3.codice_evento );
        END;
         update settimane_emens
            set diff_accredito3 = round(D_diff_accredito3 * nvl(D_gg_accredito3,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO3.dal
            and al   = CUR_EVENTO3.al
            and codice_evento3 = CUR_EVENTO3.codice_evento;
         commit;
        END LOOP; -- cur_evento3

        FOR CUR_EVENTO4 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 4 )
        LOOP
        D_diff_accredito4 := null;
        BEGIN
         D_diff_accredito4 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO4.dal,CUR_EVENTO4.al, CUR_EVENTO4.codice_evento );
         D_gg_accredito4 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO4.dal,CUR_EVENTO4.al, CUR_EVENTO4.codice_evento );
        END;
         update settimane_emens
            set diff_accredito4 = round(D_diff_accredito4 * nvl(D_gg_accredito4,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO4.dal
            and al   = CUR_EVENTO4.al
            and codice_evento4 = CUR_EVENTO4.codice_evento;
         commit;
        END LOOP; -- cur_evento4

        FOR CUR_EVENTO5 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 5 )
        LOOP
        D_diff_accredito5 := null;
        BEGIN
         D_diff_accredito5 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO5.dal,CUR_EVENTO5.al, CUR_EVENTO5.codice_evento );
         D_gg_accredito5 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO5.dal,CUR_EVENTO5.al, CUR_EVENTO5.codice_evento );
        END;
         update settimane_emens
            set diff_accredito5 = round(D_diff_accredito5 * nvl(D_gg_accredito5,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO5.dal
            and al   = CUR_EVENTO5.al
            and codice_evento5 = CUR_EVENTO5.codice_evento;
         commit;
        END LOOP; -- cur_evento5

        FOR CUR_EVENTO6 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 6 )
        LOOP
        D_diff_accredito6 := null;
        BEGIN
         D_diff_accredito6 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO6.dal,CUR_EVENTO6.al, CUR_EVENTO6.codice_evento );
         D_gg_accredito6 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO6.dal,CUR_EVENTO6.al, CUR_EVENTO6.codice_evento );
        END;
         update settimane_emens
            set diff_accredito6 = round(D_diff_accredito6 * nvl(D_gg_accredito6,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO6.dal
            and al   = CUR_EVENTO6.al
            and codice_evento6 = CUR_EVENTO6.codice_evento;
         commit;
        END LOOP; -- cur_evento6

        FOR CUR_EVENTO7 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 7 )
        LOOP
        D_diff_accredito7 := null;
        BEGIN
         D_diff_accredito7 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO7.dal,CUR_EVENTO7.al, CUR_EVENTO7.codice_evento );
         D_gg_accredito7 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO7.dal,CUR_EVENTO7.al, CUR_EVENTO7.codice_evento );
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_diff_accredito7 := null; 
        END;
         update settimane_emens
            set diff_accredito7 = round(D_diff_accredito7 * nvl(D_gg_accredito7,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO7.dal
            and al   = CUR_EVENTO7.al
            and codice_evento7 = CUR_EVENTO7.codice_evento;
         commit;
        END LOOP; -- cur_evento7
     END DIFFERENZE;

    BEGIN 
     <<ASSESTAMENTO>>
        delete from dati_particolari_emens dape
         where anno = P_anno
           and mese = P_mese
           and ci = CUR_DIP_SETT.ci
           and not exists ( select 'x' 
                              from settimane_emens
                             where anno    = dape.anno
                               and mese    = dape.mese
                               and ci      = dape.ci
                               and deie_id = dape.deie_id
                               and nvl( length( codice_evento1||codice_evento2||codice_evento3
                                              ||codice_evento4||codice_evento5||codice_evento6
                                              ||codice_evento7),0) != 0
                           )
           and deie_id in ( select deie_id
                              from denuncia_emens
                             where anno    = dape.anno
                               and mese    = dape.mese
                               and ci      = dape.ci
                               and rilevanza = 'P'
                          )
        ;
        delete from settimane_emens seie
         where anno = P_anno
           and mese = P_mese
           and ci = CUR_DIP_SETT.ci
           and ( to_char(al,'yyyy')  = P_anno
             and to_char(al,'mm')  < P_mese
              or to_char(al,'yyyy') < P_anno
                )
           and not exists ( select 'x' 
                              from settimane_emens
                             where anno    = seie.anno
                               and mese    = seie.mese
                               and ci      = seie.ci
                               and deie_id = seie.deie_id
                               and nvl( length( codice_evento1||codice_evento2||codice_evento3
                                              ||codice_evento4||codice_evento5||codice_evento6
                                              ||codice_evento7),0) != 0
                           )
           and deie_id in ( select deie_id
                              from denuncia_emens
                             where anno    = seie.anno
                               and mese    = seie.mese
                               and ci      = seie.ci
                               and rilevanza = 'P'
                          )
        ;
     delete from denuncia_emens deie
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and rilevanza    = 'P'
        and not exists ( select 'x'
                           from settimane_emens 
                          where deie_id  = deie.deie_id
                       )
        ;
     commit;
     END ASSESTAMENTO;

    END MAL_PRIVATI_P; -- malattie privati mese precedente

   ELSIF ( P_mal_privati = 'C' and D_conta_rec = 1 and D_variabili_gape = 0
          and ( P_mese != 1 and P_mese - D_variabili_gape > 0
             or P_mese = 1 and 13-D_variabili_gape > 0 ) 
         )
   THEN
   BEGIN
   <<MAL_PRIVATI_C>>
/* calcolo delle causali di evento per le malattie dei privati su mese corrente e/o per le malattie degli enti locali */
      FOR CUR_SETT2 IN 
        ( select seie.dal_emens, seie.dal, seie.al , seie.id_settimana
            from settimane_emens seie
               , denuncia_emens deie
           where seie.ci = CUR_DIP_SETT.ci
             and seie.mese = P_mese
             and seie.anno = P_anno
             and to_char(seie.dal,'mm') = P_mese
             and to_char(seie.al,'mm') = P_mese
             and deie.deie_id = seie.deie_id
          order by 2,3
        ) LOOP
-- dbms_output.put_line('cur sett1 '||cur_sett2.dal||' '||cur_sett2.al||' '||cur_sett2.id_settimana);
      BEGIN
          D_conta_evento := 0;
          D_prec_dal := null;
          D_tipo_Copertura := null;
       FOR CUR_ASSENZE2 IN ( 
           SELECT distinct prpr.codice
             FROM EVENTI_PRESENZA           evpa
                , causali_evento            caev
                , prospetti_presenza        prpr
                , righe_prospetto_presenza  rppa
            WHERE evpa.input      = 'V'
              AND evpa.ci         = CUR_DIP_SETT.ci
             AND CUR_SETT2.dal    <= evpa.al
             AND CUR_SETT2.al     >= evpa.dal
             and evpa.causale    = caev.codice
             and caev.codice     = rppa.colonna
             and rppa.prospetto  = prpr.codice
             and prpr.note like '%EMENS%'
           ) LOOP
           D_conta_evento := nvl( D_conta_evento,0 ) + 1;
-- dbms_output.put_line('assenza : '||CUR_ASSENZE2.codice||'conta : '||D_conta_evento);
           update settimane_emens
              set codice_evento1 = decode(D_conta_evento,1,CUR_ASSENZE2.codice,codice_evento1)
                , codice_evento2 = decode(D_conta_evento,2,CUR_ASSENZE2.codice,codice_evento2)
                , codice_evento3 = decode(D_conta_evento,3,CUR_ASSENZE2.codice,codice_evento3)
                , codice_evento4 = decode(D_conta_evento,4,CUR_ASSENZE2.codice,codice_evento4)
                , codice_evento5 = decode(D_conta_evento,5,CUR_ASSENZE2.codice,codice_evento5)
                , codice_evento6 = decode(D_conta_evento,6,CUR_ASSENZE2.codice,codice_evento6)
                , codice_evento7 = decode(D_conta_evento,7,CUR_ASSENZE2.codice,codice_evento7)
              where ci = CUR_DIP_SETT.ci
                and mese = P_mese
                and anno = P_anno
                and dal = CUR_SETT2.dal
                and al = CUR_SETT2.al ;
             commit;
-- dbms_output.put_line('dopo update1');
            update settimane_emens 
               set tipo_copertura =  ( select decode( nvl( length( codice_evento1||codice_evento2||codice_evento3
                                                                 ||codice_evento4||codice_evento5||codice_evento6
                                                                 ||codice_evento7
                                                          ),0)
                                                    , 0, tipo_copertura , '2' )
                                         from settimane_emens
                                        where ci = CUR_DIP_SETT.ci
                                          and mese = P_mese
                                          and anno = P_anno
                                          and dal_emens = CUR_SETT2.dal_emens
                                          and dal = CUR_SETT2.dal
                                          and al = CUR_SETT2.al )
              where ci = CUR_DIP_SETT.ci
                and mese = P_mese
                and anno = P_anno
                and dal_emens = CUR_SETT2.dal_emens
                and dal = CUR_SETT2.dal
                and al = CUR_SETT2.al ;
-- dbms_output.put_line('dopo update2');
            IF CUR_ASSENZE2.codice in ( 'MAL','INF') THEN 
               D_pr_err := nvl(D_pr_err,0)+1;
               D_precisazione := substr(' per CI: '||TO_CHAR(CUR_DIP_SETT.ci)||' - Dal: '||to_char(CUR_SETT2.DAL,'dd/mm/yyyy'),1,200);
               INSERT INTO a_segnalazioni_errore
               (no_prenotazione, passo, progressivo, errore, precisazione)
               VALUES (prenotazione,1,D_pr_err,'P07064', D_precisazione);
            END IF;
        END LOOP; -- CUR_ASSENZE2
-- dbms_output.put_line('dal/al sett1: '||CUR_SETT2.dal||' '||CUR_SETT2.al);
      END;
      END LOOP; -- CUR_SETT2
/* calcolo delle differenze di accredito sul mese corrente solo per enti privati */
      BEGIN
      <<DIFFERENZE>>
        D_diff_accredito1 := null;
        D_diff_accredito2 := null;
        D_diff_accredito3 := null;
        D_diff_accredito4 := null;
        D_diff_accredito5 := null;
        D_diff_accredito6 := null;
        D_diff_accredito7 := null;
        D_gg_accredito1 := null;
        D_gg_accredito2 := null;
        D_gg_accredito3 := null;
        D_gg_accredito4 := null;
        D_gg_accredito5 := null;
        D_gg_accredito6 := null;
        D_gg_accredito7 := null;

        FOR CUR_EVENTO1 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 1 )
        LOOP
        BEGIN
         D_diff_accredito1 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO1.dal,CUR_EVENTO1.al, CUR_EVENTO1.codice_evento );
         D_gg_accredito1   := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO1.dal,CUR_EVENTO1.al, CUR_EVENTO1.codice_evento );
-- dbms_output.put_line('evento1: '||CUR_EVENTO1.dal||' '||CUR_EVENTO1.al||' '||D_gg_accredito1);
        END;
         update settimane_emens
            set diff_accredito1 = round(D_diff_accredito1 * nvl(D_gg_accredito1,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO1.dal
            and al   = CUR_EVENTO1.al
            and codice_evento1 = CUR_EVENTO1.codice_evento;
         commit;
        END LOOP; -- cur_evento1

        FOR CUR_EVENTO2 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 2 )
        LOOP
        D_diff_accredito2 := null;
        BEGIN
         D_diff_accredito2 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO2.dal,CUR_EVENTO2.al, CUR_EVENTO2.codice_evento );
         D_gg_accredito2 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO2.dal,CUR_EVENTO2.al, CUR_EVENTO2.codice_evento );
        END;
         update settimane_emens
            set diff_accredito2 = round(D_diff_accredito2 * nvl(D_gg_accredito2,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO2.dal
            and al   = CUR_EVENTO2.al
            and codice_evento2 = CUR_EVENTO2.codice_evento;
         commit;
        END LOOP; -- cur_evento2

        FOR CUR_EVENTO3 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 3 )
        LOOP
        D_diff_accredito3 := null;
        BEGIN
         D_diff_accredito3 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO3.dal,CUR_EVENTO3.al, CUR_EVENTO3.codice_evento );
         D_gg_accredito3 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO3.dal,CUR_EVENTO3.al, CUR_EVENTO3.codice_evento );
        END;
         update settimane_emens
            set diff_accredito3 = round(D_diff_accredito3 * nvl(D_gg_accredito3,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO3.dal
            and al   = CUR_EVENTO3.al
            and codice_evento3 = CUR_EVENTO3.codice_evento;
         commit;
        END LOOP; -- cur_evento3

        FOR CUR_EVENTO4 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 4 )
        LOOP
        D_diff_accredito4 := null;
        BEGIN
         D_diff_accredito4 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO4.dal,CUR_EVENTO4.al, CUR_EVENTO4.codice_evento );
         D_gg_accredito4 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO4.dal,CUR_EVENTO4.al, CUR_EVENTO4.codice_evento );
        END;
         update settimane_emens
            set diff_accredito4 = round(D_diff_accredito4 * nvl(D_gg_accredito4,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO4.dal
            and al   = CUR_EVENTO4.al
            and codice_evento4 = CUR_EVENTO4.codice_evento;
         commit;
        END LOOP; -- cur_evento4

        FOR CUR_EVENTO5 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 5 )
        LOOP
        D_diff_accredito5 := null;
        BEGIN
         D_diff_accredito5 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO5.dal,CUR_EVENTO5.al, CUR_EVENTO5.codice_evento );
         D_gg_accredito5 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO5.dal,CUR_EVENTO5.al, CUR_EVENTO5.codice_evento );
        END;
         update settimane_emens
            set diff_accredito5 = round(D_diff_accredito5 * nvl(D_gg_accredito5,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO5.dal
            and al   = CUR_EVENTO5.al
            and codice_evento5 = CUR_EVENTO5.codice_evento;
         commit;
        END LOOP; -- cur_evento5

        FOR CUR_EVENTO6 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 6 )
        LOOP
        D_diff_accredito6 := null;
        BEGIN
         D_diff_accredito6 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO6.dal,CUR_EVENTO6.al, CUR_EVENTO6.codice_evento );
         D_gg_accredito6 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO6.dal,CUR_EVENTO6.al, CUR_EVENTO6.codice_evento );
        END;
         update settimane_emens
            set diff_accredito6 = round(D_diff_accredito6 * nvl(D_gg_accredito6,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO6.dal
            and al   = CUR_EVENTO6.al
            and codice_evento6 = CUR_EVENTO6.codice_evento;
         commit;
        END LOOP; -- cur_evento6

        FOR CUR_EVENTO7 in CURSORE_EMENS.cur_evento ( CUR_DIP_SETT.ci, P_anno, P_mese, 7 )
        LOOP
        D_diff_accredito7 := null;
        BEGIN
         D_diff_accredito7 := GET_DIFF_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO7.dal,CUR_EVENTO7.al, CUR_EVENTO7.codice_evento );
         D_gg_accredito7 := GET_GG_ACCREDITO_EMENS ( CUR_DIP_SETT.ci,CUR_EVENTO7.dal,CUR_EVENTO7.al, CUR_EVENTO7.codice_evento );
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_diff_accredito7 := null; 
        END;
         update settimane_emens
            set diff_accredito7 = round(D_diff_accredito7 * nvl(D_gg_accredito7,1))
          where anno = P_anno
            and mese = P_mese
            and ci   = CUR_DIP_SETT.ci
            and dal  = CUR_EVENTO7.dal
            and al   = CUR_EVENTO7.al
            and codice_evento7 = CUR_EVENTO7.codice_evento;
         commit;
        END LOOP; -- cur_evento7
     END DIFFERENZE;
   END MAL_PRIVATI_C;
   END IF; -- controllo malattie privati
   BEGIN
/* Estrazione delle assenza che generano particolari assunzioni  cessazioni */
      FOR CUR_ASPETTATIVA in
      ( SELECT evgi.inps, pegi.dal, nvl(pegi.al,to_date('3333333','j')) al 
          FROM periodi_giuridici pegi
             , eventi_giuridici evgi
         WHERE pegi.rilevanza = 'A'
           AND pegi.evento = evgi.codice
           and nvl(evgi.inps,'XX' ) != 'XX'
           AND pegi.dal       <= CUR_DIP_SETT.al
           AND nvl(pegi.al,to_date('3333333','j')) >= CUR_DIP_SETT.dal
           AND pegi.ci = CUR_DIP_SETT.ci
       ) LOOP
         BEGIN
-- dbms_output.put_line('ass. '||cur_aspettativa.dal||' '||cur_aspettativa.al);
            IF   CUR_ASPETTATIVA.dal between greatest(CUR_DIP_SETT.dal,P_ini_mese) and least(CUR_DIP_SETT.al,P_fin_mese) 
             and CUR_ASPETTATIVA.al not between greatest(CUR_DIP_SETT.dal,P_ini_mese) and least(CUR_DIP_SETT.al,P_fin_mese)
            THEN
/* periodo di aspettativa che inizia nel periodo di denuncia */
               update denuncia_emens 
                  set al = CUR_ASPETTATIVA.dal-1
                    , giorno_cessazione = to_char(CUR_ASPETTATIVA.dal-1,'dd')
                    , tipo_cessazione = CUR_ASPETTATIVA.inps
               where ci = CUR_DIP_SETT.ci
                 and dal = CUR_DIP_SETT.dal
                 and anno = P_anno
                 and mese = P_mese
               ;
               delete from settimane_emens seie
               where ci = CUR_DIP_SETT.ci
                 and dal_emens = CUR_DIP_SETT.dal
                 and anno = P_anno
                 and mese = P_mese
                 and dal >= CUR_ASPETTATIVA.dal
               ;
            ELSIF CUR_ASPETTATIVA.al between greatest(CUR_DIP_SETT.dal,P_ini_mese) and least(CUR_DIP_SETT.al,P_fin_mese) 
              and CUR_ASPETTATIVA.dal not between greatest(CUR_DIP_SETT.dal,P_ini_mese) and least(CUR_DIP_SETT.al,P_fin_mese) 
             THEN
/* periodo di aspettativa che termina nel periodo di denuncia */
              update denuncia_emens 
                 set dal = CUR_ASPETTATIVA.al+1
                   , giorno_assunzione = to_char(CUR_ASPETTATIVA.al+1,'dd')
                   , tipo_assunzione = CUR_ASPETTATIVA.inps
               where deie_id = CUR_DIP_SETT.deie_id
               ;
               delete from settimane_emens seie
               where deie_id = CUR_DIP_SETT.deie_id
                 and dal <= CUR_ASPETTATIVA.al
               ;
              update settimane_emens
                 set dal_emens = CUR_ASPETTATIVA.al+1
               where deie_id = CUR_DIP_SETT.deie_id
               ;
              update dati_particolari_emens
                 set dal_emens = CUR_ASPETTATIVA.al+1
               where deie_id = CUR_DIP_SETT.deie_id
               ;
               update variabili_emens
                  set dal_emens = CUR_ASPETTATIVA.al+1
               where deie_id = CUR_DIP_SETT.deie_id
               ;
               update fondi_speciali_emens
                  set dal_emens = CUR_ASPETTATIVA.al+1
               where deie_id = CUR_DIP_SETT.deie_id
               ;
               update gestione_tfr_emens
                  set dal_emens = CUR_ASPETTATIVA.al+1
               where deie_id = CUR_DIP_SETT.deie_id
               ;
            ELSIF CUR_ASPETTATIVA.dal between greatest(CUR_DIP_SETT.dal,P_ini_mese) and least(CUR_DIP_SETT.al,P_fin_mese) 
              and CUR_ASPETTATIVA.al between greatest(CUR_DIP_SETT.dal,P_ini_mese) and least(CUR_DIP_SETT.al,P_fin_mese) 
             THEN
/* periodo di aspettativa compreso nel periodo di denuncia al momento non gestito */
               null;
            END IF; -- fine controllo periodi
         END;
      END LOOP; --cur_aspettativa
   END; 
-- dbms_output.put_line('fine loop cur dip sett');
  END LOOP; -- cur_dip_sett

-- dbms_output.put_line('prima dell accorpamento');
  FOR CUR_ACCORPA in CURSORE_EMENS.CUR_ACCORPA_EMENS 
     ( P_tipo, P_ci, P_anno, P_mese, P_posizione, P_gestione, P_fascia, P_ruolo, P_rapporto  , P_gruppo
     , P_ente, P_ambiente, P_utente 
     )  LOOP

   V_controllo := null;
   V_esiste    := null;
   BEGIN
   select 'X'
     into V_controllo
     from denuncia_emens
    where anno = P_anno
      and mese = P_mese 
      and ci = CUR_ACCORPA.ci
    group by ci, anno, mese
    having sum(nvl(giorni_retribuiti,0)) > 99;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN V_controllo := null;
   END;
   BEGIN
   IF V_controllo = 'X' THEN 
      D_pr_err := nvl(D_pr_err,0)+1;
      INSERT INTO a_segnalazioni_errore
      (no_prenotazione, passo, progressivo, errore, precisazione)
      VALUES (prenotazione,1,D_pr_err,'P05187',substr('99 per CI: '||TO_CHAR(CUR_ACCORPA.ci),1,50));
   ELSE
-- dbms_output.put_line('accorpamento');
    BEGIN
     select 'S' 
       into V_esiste
       from dual 
      where exists ( select 'x' from user_indexes where index_name = 'DEIE_PK' );
    EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := 'N';
    END;
    IF V_esiste = 'S' THEN
       v_comando := 'drop index deie_pk';
       si4.sql_execute(v_comando);
    END IF;
     CURSORE_EMENS.ACCORPA_EMENS( CUR_ACCORPA.ci, P_ANNO, P_MESE,P_sfasato );
     IF CUR_ACCORPA.specie_rapporto = 'DIP' THEN
-- dbms_output.put_line('accorpa uguali');
     CURSORE_EMENS.ACCORPA_EMENS_UGUALI ( CUR_ACCORPA.ci, P_ANNO, P_MESE, D_anno_den , D_mese_den, P_sfasato );
     END IF;
    BEGIN
     select 'S' 
       into V_esiste
       from dual 
      where exists ( select 'x' from obj where object_name = 'DEIE_PK' );
    EXCEPTION WHEN NO_DATA_FOUND THEN V_esiste := 'N';
    END;
    IF V_esiste = 'N' THEN
       v_comando := 'create unique index deie_pk on denuncia_emens (deie_id)';
       si4.sql_execute(v_comando);
    END IF; 
   END IF;
   END;
-- dbms_output.put_line('fine accorpamento');
  END LOOP; -- cur_accorpa

  FOR CUR_EMENS in CURSORE_EMENS.CUR_EMENS_EMENS
      ( P_tipo, P_ci, P_ruolo, P_anno, P_mese, P_posizione, P_gestione, P_fascia, P_rapporto, P_gruppo
      , P_ente, P_ambiente, P_utente
      ) LOOP
-- dbms_output.put_line('cur emens: '||CUR_EMENS.dal||' '||cur_emens.al);

/* Estrazione DAL / AL dei COCO */
   IF CUR_EMENS.specie_rapporto = 'COCO' THEN
     BEGIN
      select nvl( max(riferimento), last_day(to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy')) )
           , nvl( min(riferimento), to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy') )
        into D_max_riferimento, D_min_riferimento
        from  valori_contabili_mensili vacm
       where anno = P_anno
         and mese = P_mese
         and ci = CUR_EMENS.ci
         and vacm.estrazione = 'DENUNCIA_EMENS'
         and vacm.colonna    = 'COMPENSO'
         and vacm.valore     != 0;
     END;
     BEGIN
     select decode( to_char(pegi.dal,'yyyymm')
                  , to_char(D_min_riferimento,'yyyymm'), least(pegi.dal,D_min_riferimento)
                                                       , to_date('01'||to_char(D_min_riferimento,'mmyyyy'),'ddmmyyyy')
              )
       into D_dal_coco
       from periodi_giuridici pegi
      where rilevanza = 'S'
        and ci = CUR_EMENS.ci
        and D_max_riferimento between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
       ;
 
      D_al_coco := D_max_riferimento;
     EXCEPTION  WHEN NO_DATA_FOUND THEN 
        BEGIN
        select decode( to_char(max(pegi.dal),'yyyymm')
                     , to_char(D_min_riferimento,'yyyymm'), least(max(pegi.dal),D_min_riferimento)
                                                          , least(max(pegi.dal)
                                                                 ,to_date('01'||to_char(D_min_riferimento,'mmyyyy'),'ddmmyyyy'))
                   )
           , max(al)
         into D_dal_coco, D_al_coco
         from periodi_giuridici pegi
        where rilevanza = 'S'
             and ci = CUR_EMENS.ci
             and pegi.al  <= D_max_riferimento
             ;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         D_dal_coco := D_min_riferimento;
         D_al_coco  := D_max_riferimento;
       END;
     END; 
     UPDATE denuncia_emens
        set dal = nvl(D_dal_coco,P_ini_mese)
          ,  al = nvl(D_al_coco,P_fin_mese)
      where ci = CUR_EMENS.ci
        and dal = CUR_EMENS.dal
        and al = CUR_EMENS.al
        and anno = P_anno
        and mese = P_mese;
     commit;
   END IF; 

/* Estrazione Variabili */
-- dbms_output.put_line('richiamo il cursore variabili'||CUR_EMENS.ci||' '||P_anno||' '||P_mese||' '||CUR_EMENS.dal);
-- dbms_output.put_line(CUR_EMENS.rilevanza||' '||CUR_EMENS.specie_rapporto);
  IF CUR_EMENS.rilevanza = 'C' and CUR_EMENS.specie_rapporto = 'DIP' and P_mese = 1
     THEN
    FOR CUR_VAR IN CURSORE_EMENS.CUR_VAR_EMENS 
       (  CUR_EMENS.ci,  P_anno, P_mese, CUR_EMENS.dal 
       ) LOOP
    IF nvl(CUR_VAR.importo,0) != 0 THEN
-- dbms_output.put_line('ins variabili: '||CUR_EMENS.CI);
       insert into VARIABILI_EMENS
           ( ci, anno, mese, dal_emens, deie_id, dal, al, anno_rif
            , aum_imponibile
            , dim_imponibile
            , utente , tipo_agg, data_agg )
       select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id
            , nvl(CUR_VAR.dal_rif,CUR_EMENS.dal), nvl(CUR_VAR.al_rif,CUR_EMENS.al) , nvl(CUR_VAR.anno_rif,P_anno)
            , decode(sign(nvl(CUR_VAR.importo,0)),-1,null,CUR_VAR.importo)
            , decode(sign(nvl(CUR_VAR.importo,0)),-1,abs(CUR_VAR.importo),null)
            , P_utente, null , sysdate
         from dual;
    commit;
    END IF; -- controllo per inserimento
  END LOOP; -- variabili
 END IF; -- controllo per estrazione variabili

/* Estrazione dati particolari */
  IF CUR_EMENS.specie_rapporto = 'DIP' 
    THEN
   BEGIN
       FOR CUR_DATIP in CURSORE_EMENS.CUR_DATIP_EMENS
          ( CUR_EMENS.ci,  P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.al
          ) LOOP
    -- dbms_output.put_line('DAPE: '||CUR_EMENS.CI||' '||CUR_DATIP.dal||' '||CUR_DATIP.colonna);
        D_dal_preavviso := null;
        D_al_preavviso  := null;
        D_dal_sind      := null;
        D_al_sind       := null;
         BEGIN
           IF nvl(CUR_DATIP.preavviso,0) != 0 THEN
              BEGIN
              select dal, al
                into D_dal_preavviso, D_al_preavviso 
               from periodi_giuridici pegi
              where pegi.rilevanza = 'P'
                and pegi.ci        = CUR_EMENS.ci
                and CUR_DATIP.al between pegi.dal and nvl(pegi.al, to_date('3333333','j'));
              EXCEPTION WHEN NO_DATA_FOUND THEN
                 D_dal_preavviso := null;
                 D_al_preavviso := null;
              END;
              INSERT INTO DATI_PARTICOLARI_EMENS 
              ( CI, ANNO, MESE, DAL_EMENS, DEIE_ID, IDENTIFICATORE
              , IMPONIBILE, DAL, AL
              , NUM_SETTIMANE
              , UTENTE, TIPO_AGG, DATA_AGG ) 
              select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id, CUR_DATIP.colonna
                   , CUR_DATIP.preavviso, nvl(D_dal_preavviso,CUR_DATIP.dal), nvl(D_al_preavviso,CUR_DATIP.al)
                   , round( nvl(D_al_preavviso,CUR_DATIP.al)- nvl(D_dal_preavviso,CUR_DATIP.dal)+1 ) / 7
                   , P_utente, null , sysdate
                from dual;
           END IF;
           IF nvl(CUR_DATIP.bonus,0) != 0 THEN
              INSERT INTO DATI_PARTICOLARI_EMENS 
              ( CI, ANNO, MESE, DAL_EMENS, DEIE_ID, IDENTIFICATORE
              , IMPONIBILE, DAL
              , UTENTE, TIPO_AGG, DATA_AGG ) 
              select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id, CUR_DATIP.colonna
                   , CUR_DATIP.bonus, CUR_DATIP.dal
                   , P_utente, null , sysdate
                from dual;
           END IF;
           IF nvl(CUR_DATIP.estero,0) != 0 THEN
              INSERT INTO DATI_PARTICOLARI_EMENS 
              ( CI, ANNO, MESE, DAL_EMENS, DEIE_ID, IDENTIFICATORE
              , IMPONIBILE
              , UTENTE, TIPO_AGG, DATA_AGG ) 
              select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id, CUR_DATIP.colonna
                   , CUR_DATIP.estero
                   , P_utente, null , sysdate
                from dual;
           END IF;
           IF nvl(CUR_DATIP.atipica,0) != 0 THEN
              INSERT INTO DATI_PARTICOLARI_EMENS 
              ( CI, ANNO, MESE, DAL_EMENS, DEIE_ID, IDENTIFICATORE
              , IMPONIBILE, DAL, AL
              , NUM_SETTIMANE
              , UTENTE, TIPO_AGG, DATA_AGG ) 
              select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id, CUR_DATIP.colonna
                   , CUR_DATIP.atipica, CUR_DATIP.dal, CUR_DATIP.al
                   , round( CUR_DATIP.dal - CUR_DATIP.al + 1 ) / 7
                   , P_utente, null , sysdate
                from dual;
           END IF;
              BEGIN
              select min(dal), max(al)
                into D_dal_sind, D_al_sind
               from periodi_giuridici pegi
              where pegi.rilevanza = 'A'
                and pegi.ci        = CUR_EMENS.ci
                and CUR_DATIP.al between pegi.dal and nvl(pegi.al, to_date('3333333','j'))
                and assenza in ( select substr(esvc.note, instr(esvc.note,'<')+1, instr(esvc.note,'>')-2)
                                   from estrazione_valori_contabili esvc
                                  where estrazione = 'DENUNCIA_EMENS'
                                    and colonna = 'SINDACALI'
                                    and P_fin_mese between dal and nvl(al,to_date('3333333','j'))
                                 union
                                 select substr(esvc.note, instr(esvc.note,'<',instr(esvc.note,'>'))+1
                                                        , (instr(esvc.note, '>',instr(esvc.note,'>')+1 )-1
                                                          -instr(esvc.note,'<',instr(esvc.note,'>'))))
                                   from estrazione_valori_contabili esvc
                                  where estrazione = 'DENUNCIA_EMENS'
                                    and colonna = 'SINDACALI'
                                    and P_fin_mese between dal and nvl(al,to_date('3333333','j'))
                                )
              ;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                 D_dal_sind   := null;
                 D_al_sind    := null;
              END;
           IF nvl(CUR_DATIP.sindacali,0) != 0 THEN
              INSERT INTO DATI_PARTICOLARI_EMENS 
              ( CI, ANNO, MESE, DAL_EMENS, DEIE_ID, IDENTIFICATORE
              , IMPONIBILE, DAL, AL, ANNO_RIF
              , UTENTE, TIPO_AGG, DATA_AGG ) 
              select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id, CUR_DATIP.colonna
                   , CUR_DATIP.sindacali,  nvl(D_dal_sind, CUR_DATIP.dal) ,nvl(D_al_sind,CUR_DATIP.al)
                   , to_char(CUR_DATIP.al,'yyyy')
                   , P_utente, null , sysdate
                from dual;
           END IF;
         END;
       END LOOP; -- cur_datip
   END;
  END IF; -- controllo su specie 

/* Estrazione fondi speciali per privati */
  IF CUR_EMENS.specie_rapporto = 'DIP' and CUR_EMENS.riferimento = lpad(P_mese,2,'0')||P_anno
     THEN
  FOR CUR_FONDI in CURSORE_EMENS.CUR_FONDI_EMENS
      ( P_tipo, CUR_EMENS.ci, P_anno, P_mese, P_posizione, P_gestione, P_fascia
      ) LOOP
    IF nvl(CUR_FONDI.importo,0) != 0 THEN
-- dbms_output.put_line('ins fondi: '||CUR_EMENS.CI);
       INSERT INTO FONDI_SPECIALI_EMENS 
       (   CI, ANNO, MESE, FONDO, DAL_EMENS, DEIE_ID, RETR_PENS
         , UTENTE, TIPO_AGG, DATA_AGG) 
       SELECT CUR_EMENS.CI, P_anno, P_mese, 'ANTE95', CUR_EMENS.dal, CUR_EMENS.deie_id, CUR_FONDI.importo
            , P_utente, null , sysdate
         from dual;
    commit;
    END IF; -- controllo per inserimento
    IF nvl(CUR_FONDI.importo_arr,0) != 0 THEN
-- dbms_output.put_line('ins fondi: '||CUR_EMENS.CI);
       INSERT INTO FONDI_SPECIALI_EMENS 
       (   CI, ANNO, MESE, FONDO, DAL_EMENS, DEIE_ID
         , DAL, AL, ANNO_RIF, ARRETRATI
         , UTENTE, TIPO_AGG, DATA_AGG) 
       SELECT CUR_EMENS.CI, P_anno, P_mese, 'ANTE95', CUR_EMENS.dal, CUR_EMENS.deie_id
            , CUR_FONDI.dal_rif, CUR_FONDI.al_rif, CUR_FONDI.anno_rif, CUR_FONDI.importo_arr
            , P_utente, null , sysdate
         from dual;
    commit;
    END IF; -- controllo per inserimento
  END LOOP; -- fondi speciali
/* modifica tipo lavoratore per fondi e bonus */
  update denuncia_emens deie
     set tipo_lavoratore = 'X4'
   where anno         = to_number(P_anno)
     and mese         = P_mese
     and exists
         (select 'x' from fondi_speciali_emens
           where deie_id  = deie.deie_id
            )
    and tipo_lavoratore = '0';
  update denuncia_emens deie
     set tipo_lavoratore = 'BN'
   where anno         = to_number(P_anno)
     and mese         = P_mese
     and exists
         (select 'x' from dati_particolari_emens
           where deie_id  = deie.deie_id
             and identificatore = 'BONUS'
            )
    and tipo_lavoratore = '0';
 END IF; -- controllo per estrazione fondi

/* valorizzazione campo TFR per Privati */
  IF P_tfr_privati = 'X' and P_mese = 2 THEN
    BEGIN -- assestamento dati privati ex upd_tfr_privati
       update denuncia_emens deie
          set tfr = ( select  round(  ( sum(nvl(prfi.fdo_tfr_ap,0))
                                             + sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)))
                                           + sum(nvl(prfi.fdo_tfr_2000,0)) 
                                           - sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)) 
                                           - e_round(sum(distinct nvl(prfi.riv_tfr_ap,0)) * .11,'I') 
                                           + sum(nvl(prfi.qta_tfr_ac,0)) 
                                           - sum(nvl(prfi.rit_tfr,0)) 
                                           + sum(nvl(prfi.riv_tfr,0)) 
                                           + sum(nvl(prfi.riv_tfr_ap,0)) 
                                           - e_round(sum(nvl(prfi.riv_tfr,0)) * 11/100,'I')
                                           - least (    ( sum(nvl(prfi.fdo_tfr_ap,0)) 
                                                         + sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)))
                                                      + sum(nvl(prfi.fdo_tfr_2000,0))
                                                      - least( ( sum(nvl(prfi.fdo_tfr_ap,0)) 
                                                                + sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)))
                                                      + sum(nvl(prfi.fdo_tfr_2000,0))
                                                      , sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0))
                                                              )
                                                    ,   greatest( sum(nvl(prfi.fdo_tfr_ap_liq,0)) 
                                                        + sum(nvl(prfi.fdo_tfr_2000_liq,0))
                                                        - decode(  (sum(nvl(prfi.lor_acc_2000,0)) + sum(nvl(prfi.lor_acc,0)))
                                                                 , 0 ,sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)) 
                                                                     , 0 )
                                                                 , 0
                                                                 )
                                                    )    
                                            -  sum(nvl(riv_tfr_ap_liq,0))  
                                            -  sum(nvl(prfi.riv_tfr_liq,0))
                                            -  sum(nvl(prfi.qta_tfr_ac_liq,0))
                                   )
                                 from progressivi_fiscali   prfi
                             where prfi.anno       = P_anno-1
                               and prfi.mese       = 12
                               and prfi.mensilita  =   (select max(mensilita) from mensilita
                                                         where mese  = 12 
                                                           and tipo in ('S','N','A')
                                                        )
                               and prfi.ci         = deie.ci
                            having abs ( trunc ( round(  sum(nvl(prfi.fdo_tfr_ap,0)) 
                                    + sum(nvl(prfi.fdo_tfr_2000,0)) 
                                    - sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)) 
                                    - e_round(sum(distinct nvl(prfi.riv_tfr_ap,0)) * .11,'I') 
                                    + sum(nvl(prfi.qta_tfr_ac,0)) 
                                    - sum(nvl(prfi.rit_tfr,0)) 
                                    + sum(nvl(prfi.riv_tfr,0)) 
                                           + sum(nvl(prfi.riv_tfr_ap,0)) 
                                           - e_round(sum(nvl(prfi.riv_tfr,0)) * 11/100,'I')
                                           - least (    sum(nvl(prfi.fdo_tfr_ap,0)) 
                                                      + sum(nvl(prfi.fdo_tfr_2000,0))
                                                      - least( sum(nvl(prfi.fdo_tfr_ap,0)) 
                                                      + sum(nvl(prfi.fdo_tfr_2000,0))
                                                      , sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0))
                                                              )
                                                    ,   greatest( sum(nvl(prfi.fdo_tfr_ap_liq,0)) 
                                                        + sum(nvl(prfi.fdo_tfr_2000_liq,0))
                                                        - decode(  (sum(nvl(prfi.lor_acc_2000,0)) + sum(nvl(prfi.lor_acc,0)))
                                                                 , 0 ,sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)) 
                                                                     , 0 )
                                                                 , 0
                                                                 )
                                                    )    
                                            -  sum(nvl(riv_tfr_ap_liq,0))  
                                            -  sum(nvl(prfi.riv_tfr_liq,0))
                                            -  sum(nvl(prfi.qta_tfr_ac_liq,0))
                                            )) - trunc(sum(nvl(lor_liq,0))) ) > 1 
                              )
       where anno = P_anno
         and mese = 2
         and rilevanza = 'C'
         and ci = CUR_EMENS.ci
         and dal = ( select max(dal)
                       from denuncia_emens
                      where ci = deie.ci
                        and anno = P_anno
                        and mese = 2
                        and rilevanza = 'C'
                   )
      ;
    commit;
    END;
  END IF; -- fine gestione tfr privati

/* valorizzazione nuova sezione gestione TFR per Privati */
    IF P_gestione_tfr = 'X'
    and P_anno >= 2007 
    and CUR_EMENS.rilevanza = 'C'
    and ( ( P_sfasato = 'X' and CUR_EMENS.riferimento = to_char(add_months(P_fin_mese,-1),'mmyyyy'))
         or CUR_EMENS.riferimento = lpad(P_mese,2,'0')||P_anno
        )
    THEN
     BEGIN
      D_base_calcolo_tfr  := 0;
      D_base_calcolo_pc   := 0;
      D_imp_corrente      := 0;
      D_imp_pregresso     := 0;
      D_imp_liquidazione  := 0;
      D_imp_anticipazione := 0;
      D_tipo_scelta       := null;
      D_data_scelta       := to_date(null);
      D_iscr_prev_obbl    := null;
      D_iscr_prev_compl   := null;
      D_fondo_tesoreria   := null;
      D_data_adesione     := to_date(null);
      D_forma_prev        := 0;
      D_tipo_quota        := null;
      D_quota             := 0;
        BEGIN -- sezione destinazione TFR
dbms_output.put_line ( 'Tipo Quota 1: '||D_tipo_quota );
          BEGIN -- estrazione dati TFR se presenti
          select upper(decode(min(adog.scd)
                             ,'PREV', max(decode(adog.scd,'PREV',substr(nvl(adog.descrizione,'SA'),1,2),''))
                                    , max(decode(adog.scd,'TFR',substr(nvl(adog.descrizione,'SA'),1,2),''))
                       ))
               , decode(min(adog.scd)
                       ,'PREV', max(decode(adog.scd,'PREV',adog.del,to_date(null)))
                              , max(decode(adog.scd,'TFR',adog.del,to_date(null)))
                       )
               , upper(decode(min(adog.scd)
                             ,'PREV', max(decode(adog.scd,'PREV',nvl(dato_a1,'A93'),''))
                                    , max(decode(adog.scd,'TFR',nvl(dato_a1,'A93'),''))
                       ))
               , upper(decode(min(adog.scd)
                             ,'PREV', max(decode(adog.scd,'PREV',nvl(dato_a2,'NO'),''))
                                    , max(decode(adog.scd,'TFR',nvl(dato_a2,'NO'),''))
                       ))
               , max(decode(evgi.posizione,'TFR','NO','SI'))
               , max(decode(adog.scd,'PREV',dal,to_date(null)))
               , max(decode(adog.scd,'PREV',dato_n1,''))
               , upper(max(decode(adog.scd,'PREV',dato_a3,'')))
               , max(decode(adog.scd,'PREV',dato_n2,''))
            into D_tipo_scelta
               , D_data_scelta
               , D_iscr_prev_obbl
               , D_iscr_prev_compl
               , D_fondo_tesoreria
               , D_data_adesione
               , D_forma_prev
               , D_tipo_quota
               , D_quota
            from archivio_documenti_giuridici adog
               , eventi_giuridici evgi
           where adog.ci = CUR_EMENS.CI
             and adog.evento = 'TFR'
             and adog.scd in ( 'TFR', 'PREV')
             and adog.evento = evgi.codice
             and to_char(adog.rilascio,'mmyyyy') = lpad(P_mese,2,'0')||P_anno
             and ( P_anno > 2007 
                or P_anno = 2007 and P_mese >= 7 
                 )
          ;
          EXCEPTION WHEN NO_DATA_FOUND THEN
               null;
          END;
dbms_output.put_line ( 'Tipo Quota 2: '||D_tipo_quota );
          IF D_tipo_quota is null THEN
            BEGIN -- Estrazione solo del tipo quota per elaborazioni successive
              select upper(dato_a3)
                into D_tipo_quota
                from archivio_documenti_giuridici adog
                   , eventi_giuridici evgi
               where adog.ci = CUR_EMENS.CI
                 and adog.evento = 'TFR'
                 and adog.scd    = 'PREV'
                 and adog.evento = evgi.codice
                 and adog.rilascio is not null
                 and P_anno >= 2007
              ;
            EXCEPTION WHEN NO_DATA_FOUND THEN
              null;
            END;
           END IF;
          IF D_data_scelta is not null THEN
          update gestione_tfr_emens
             set tipo_scelta = D_tipo_scelta
               , data_scelta = greatest(D_data_scelta,to_date('31122006','ddmmyyyy'))
               , iscr_prev_obbl = D_iscr_prev_obbl
               , iscr_prev_compl = D_iscr_prev_compl
               , fondo_tesoreria = D_fondo_tesoreria
               , data_adesione = D_data_adesione
               , forma_prev_compl = D_forma_prev
               , tipo_quota_prev_compl = D_tipo_quota
               , quota_prev_compl = D_quota
           where ci = CUR_EMENS.CI
             and anno = P_anno
             and mese = P_mese
             and dal_emens = CUR_EMENS.dal
           ;
-- dbms_output.put_line('righe in update 1: '||SQL%ROWCOUNT);
           IF SQL%ROWCOUNT = 0 THEN
              insert into gestione_tfr_emens
                (ci, anno, mese, dal_emens, deie_id
                , tipo_scelta, data_scelta
                , iscr_prev_obbl, iscr_prev_compl
                , fondo_tesoreria
                , data_adesione, forma_prev_compl, tipo_quota_prev_compl, quota_prev_compl
                , utente, tipo_agg, data_agg)
              select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id
                   , D_tipo_scelta, greatest(D_data_scelta,to_date('31122006','ddmmyyyy'))
                   , D_iscr_prev_obbl, D_iscr_prev_compl
                   , D_fondo_tesoreria
                   , D_data_adesione, D_forma_prev, D_tipo_quota, D_quota
                   , P_utente, null , sysdate
               from dual
               ;
-- dbms_output.put_line('righe in insert 1: '||SQL%ROWCOUNT);
           END IF;
          commit;
          END IF;
        END; -- sezione destinazione TFR

        BEGIN -- sezione Mese TFR
          BEGIN -- base calcolo tfr
          D_base_calcolo_tfr := GET_BASE_CALCOLO_TFR_EMENS(CUR_EMENS.CI, P_anno, P_mese
                                                          ,'BASE_CALCOLO_TFR', CUR_EMENS.dal, CUR_EMENS.al);
          IF nvl(D_base_calcolo_tfr,0) != 0 THEN
          update gestione_tfr_emens
             set base_calcolo = decode(nvl(base_calcolo,0) + nvl(D_base_calcolo_tfr,0)
                                      ,0, base_calcolo
                                        , nvl(base_calcolo,0) + nvl(D_base_calcolo_tfr,0)
                                      )
           where ci = CUR_EMENS.CI
             and anno = P_anno
             and mese = P_mese
             and dal_emens = CUR_EMENS.dal
           ;
-- dbms_output.put_line('righe in update 2: '||SQL%ROWCOUNT);
           IF SQL%ROWCOUNT = 0 THEN
              insert into gestione_tfr_emens
                (ci, anno, mese, dal_emens, deie_id, base_calcolo
                , utente, tipo_agg, data_agg)
              select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id, D_base_calcolo_tfr
                    , P_utente, null , sysdate
               from dual
               ;
-- dbms_output.put_line('righe in insert 2: '||SQL%ROWCOUNT);
           END IF;
          commit;
          END IF;

          END; -- base calcolo tfr
          BEGIN -- base calcolo previdenza complementare
dbms_output.put_line ( 'Tipo Quota 3: '||D_tipo_quota );
          IF D_tipo_quota = 'QRUT' THEN
             D_base_calcolo_pc := GET_BASE_CALCOLO_TFR_EMENS(CUR_EMENS.CI, P_anno, P_mese
                                                             ,'BASE_CALCOLO_QRUT', CUR_EMENS.dal, CUR_EMENS.al);
          ELSIF D_tipo_quota = 'QTFR' THEN
             D_base_calcolo_pc := GET_BASE_CALCOLO_TFR_EMENS(CUR_EMENS.CI, P_anno, P_mese
                                                             ,'BASE_CALCOLO_QTFR', CUR_EMENS.dal, CUR_EMENS.al);
          ELSE
             D_base_calcolo_pc := GET_BASE_CALCOLO_TFR_EMENS(CUR_EMENS.CI, P_anno, P_mese
                                                             ,'BASE_CALCOLO_PREV_COMPL', CUR_EMENS.dal, CUR_EMENS.al);
          END IF;

          IF nvl(D_base_calcolo_pc,0) != 0 THEN
            update gestione_tfr_emens
               set base_calcolo_prev_compl = decode(nvl(base_calcolo_prev_compl,0) + nvl(D_base_calcolo_pc,0)
                                                   ,0, base_calcolo_prev_compl
                                                     , nvl(base_calcolo_prev_compl,0) + nvl(D_base_calcolo_pc,0)
                                                   )
             where ci = CUR_EMENS.CI
               and anno = P_anno
               and mese = P_mese
               and dal_emens = CUR_EMENS.dal
             ;
-- dbms_output.put_line('righe in update 3: '||SQL%ROWCOUNT);
             IF SQL%ROWCOUNT = 0 THEN
                insert into gestione_tfr_emens
                  (ci, anno, mese, dal_emens, deie_id, base_calcolo_prev_compl
                  , utente, tipo_agg, data_agg)
                select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id, D_base_calcolo_pc
                      , P_utente, null , sysdate
                 from dual
                 ;
-- dbms_output.put_line('righe in insert 3: '||SQL%ROWCOUNT);
             END IF;
          commit;
          END IF;

          END; -- base calcolo previdenza complementare
          BEGIN -- contribuzione e prestazione
            SELECT  SUM( decode(nvl(moco.arr,'X')
                              ,'X', nvl(moco.imp,0)
                                  , 0
                              ) * decode ( esco.codice, 'CF01',1,0)
                                * decode ( esco.tipo, 'M',1,0) 
                       ) corrente
                 , SUM( decode(nvl(moco.arr,'X')
                              ,'X', 0
                                  , nvl(moco.imp,0)
                              ) * decode ( esco.codice, 'CF02',1,0)
                                * decode ( esco.tipo, 'A',1,0) 
                      ) pregresso
                 ,  SUM( decode(nvl(moco.arr,'X')
                              ,'X', nvl(moco.imp,0)
                                  , 0
                              ) * decode ( esco.codice, 'PF10',1,0)
                                * decode ( esco.tipo, 'M',1,0) 
                       )
                 + SUM( decode(nvl(moco.arr,'X')
                              ,'X', 0
                                  , nvl(moco.imp,0)
                              ) * decode ( esco.codice, 'PF20',1,0)
                                * decode ( esco.tipo, 'A',1,0) 
                      ) liquidazione
                 , SUM( decode(nvl(moco.arr,'X')
                              ,'X', nvl(moco.imp,0)
                                  , 0
                              ) * decode ( esco.codice, 'PA10',1,0)
                                * decode ( esco.tipo, 'M',1,0) 
                       )
                 + SUM( decode(nvl(moco.arr,'X')
                              ,'X', 0
                                  , nvl(moco.imp,0)
                              ) * decode ( esco.codice, 'PA20',1,0)
                                * decode ( esco.tipo, 'A',1,0) 
                      ) anticipazione
              into D_imp_corrente
                 , D_imp_pregresso
                 , D_imp_liquidazione
                 , D_imp_anticipazione
              FROM ESTRAZIONE_CONTRIBUTI esco
                 , MOVIMENTI_CONTABILI   moco
             WHERE esco.quadro   IN ('C','D')
               AND esco.codice   in ('CF01','CF02','PF10','PF20','PA10','PA20')
               AND moco.ci         = CUR_EMENS.ci
               AND moco.voce       = esco.voce
               AND moco.sub        = esco.sub
               AND moco.anno       = P_anno
               AND moco.mese       = P_mese
               and moco.mensilita != '*AP'
          having ( SUM( decode(nvl(moco.arr,'X')
                              ,'X', nvl(moco.imp,0)
                                  , 0
                              ) * decode ( esco.codice, 'CF01',1,0)
                                * decode ( esco.tipo, 'M',1,0) 
                       )
                 + SUM( decode(nvl(moco.arr,'X')
                              ,'X', 0
                                  , nvl(moco.imp,0)
                              ) * decode ( esco.codice, 'CF02',1,0)
                                * decode ( esco.tipo, 'A',1,0) 
                      )
                 + SUM( decode(nvl(moco.arr,'X')
                              ,'X', nvl(moco.imp,0)
                                  , 0
                              ) * decode ( esco.codice, 'PF10',1,0)
                                * decode ( esco.tipo, 'M',1,0) 
                       )
                 + SUM( decode(nvl(moco.arr,'X')
                              ,'X', 0
                                  , nvl(moco.imp,0)
                              ) * decode ( esco.codice, 'PF20',1,0)
                                * decode ( esco.tipo, 'A',1,0) 
                      )
                 + SUM( decode(nvl(moco.arr,'X')
                              ,'X', nvl(moco.imp,0)
                                  , 0
                              ) * decode ( esco.codice, 'PA10',1,0)
                                * decode ( esco.tipo, 'M',1,0) 
                       )
                 + SUM( decode(nvl(moco.arr,'X')
                              ,'X', 0
                                  , nvl(moco.imp,0)
                              ) * decode ( esco.codice, 'PA20',1,0)
                                * decode ( esco.tipo, 'A',1,0) 
                      ) ) != 0
            ;
          EXCEPTION 
               WHEN NO_DATA_FOUND THEN
                    D_imp_corrente      := 0;
                    D_imp_pregresso     := 0;
                    D_imp_liquidazione  := 0;
                    D_imp_anticipazione := 0;
          END;
          IF nvl(D_imp_corrente,0) + nvl(D_imp_pregresso,0) != 0 THEN
  /* inserimento elemento contribuzione */
            update gestione_tfr_emens
               set imp_corrente = decode(nvl(D_imp_corrente,0)
                                        ,0, nvl(imp_corrente,0)
                                          , nvl(imp_corrente,0) + nvl(D_imp_corrente,0)
                                        )
                 , imp_pregresso = decode(nvl(D_imp_pregresso,0)
                                          ,0, nvl(imp_pregresso,0)
                                            , nvl(imp_pregresso,0) + nvl(D_imp_pregresso,0)
                                        )
             where ci = CUR_EMENS.CI
               and anno = P_anno
               and mese = P_mese
               and dal_emens = CUR_EMENS.dal
               and CUR_EMENS.dal = ( select max(deie.dal)
                                       from denuncia_emens deie
                                      where deie.ci         = CUR_EMENS.CI
                                        and deie.anno       = P_anno
                                        and deie.mese       = P_mese
                                        and deie.rilevanza  = 'C'
                                        and ( ( P_sfasato = 'X' and deie.riferimento = to_char(add_months(P_fin_mese,-1),'mmyyyy'))
                                             or deie.riferimento = lpad(P_mese,2,'0')||P_anno
                                             )
                                   )
             ;
-- dbms_output.put_line('righe in update 4: '||SQL%ROWCOUNT);
             IF SQL%ROWCOUNT = 0 THEN
                insert into gestione_tfr_emens
                (ci, anno, mese, dal_emens, deie_id, imp_corrente, imp_pregresso
                , utente, tipo_agg, data_agg)
                select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id
                     , decode(D_imp_corrente,0,null,D_imp_corrente)
                     , decode(D_imp_pregresso,0,null,D_imp_pregresso)
                     , P_utente, null , sysdate
                 from dual
                 where CUR_EMENS.dal = ( select max(deie.dal)
                                           from denuncia_emens deie
                                          where deie.ci         = CUR_EMENS.CI
                                            and deie.anno       = P_anno
                                            and deie.mese       = P_mese
                                            and deie.rilevanza  = 'C'
                                            and ( ( P_sfasato = 'X' and deie.riferimento = to_char(add_months(P_fin_mese,-1),'mmyyyy'))
                                                 or deie.riferimento = lpad(P_mese,2,'0')||P_anno
                                                 )
                                       )
                 ;
-- dbms_output.put_line('righe in insert 4: '||SQL%ROWCOUNT);
             END IF;
          commit;
          END IF;

          IF nvl(D_imp_liquidazione,0) + nvl(D_imp_anticipazione,0) != 0 THEN
  /* inserimento elemento prestazione */
            update gestione_tfr_emens
               set imp_liquidazione = decode(nvl(D_imp_liquidazione,0)
                                            ,0, nvl(imp_liquidazione,0)
                                              , nvl(imp_liquidazione,0) + nvl(D_imp_liquidazione,0)
                                            )
                 , imp_anticipazione = decode(nvl(D_imp_anticipazione,0) 
                                              ,0, nvl(imp_anticipazione,0)
                                                , nvl(imp_anticipazione,0) + nvl(D_imp_anticipazione,0)
                                              )
             where ci = CUR_EMENS.CI
               and anno = P_anno
               and mese = P_mese
               and dal_emens = CUR_EMENS.dal
               and CUR_EMENS.dal = ( select max(deie.dal)
                                       from denuncia_emens deie
                                      where deie.ci         = CUR_EMENS.CI
                                        and deie.anno       = P_anno
                                        and deie.mese       = P_mese
                                        and deie.rilevanza  = 'C'
                                        and ( ( P_sfasato = 'X' and deie.riferimento = to_char(add_months(P_fin_mese,-1),'mmyyyy'))
                                             or deie.riferimento = lpad(P_mese,2,'0')||P_anno
                                             )
                                   )
             ;
-- dbms_output.put_line('righe in update 5: '||SQL%ROWCOUNT);
             IF SQL%ROWCOUNT = 0 THEN
                insert into gestione_tfr_emens
                (ci, anno, mese, dal_emens, deie_id, imp_liquidazione, imp_anticipazione
                , utente, tipo_agg, data_agg)
                select CUR_EMENS.CI, P_anno, P_mese, CUR_EMENS.dal, CUR_EMENS.deie_id
                     , decode(D_imp_liquidazione,0,null,D_imp_liquidazione)
                     , decode(D_imp_anticipazione,0,null,D_imp_anticipazione)
                     , P_utente, null , sysdate
                 from dual
                 where CUR_EMENS.dal = ( select max(deie.dal)
                                           from denuncia_emens deie
                                          where deie.ci         = CUR_EMENS.CI
                                            and deie.anno       = P_anno
                                            and deie.mese       = P_mese
                                            and deie.rilevanza  = 'C'
                                            and ( ( P_sfasato = 'X' and deie.riferimento = to_char(add_months(P_fin_mese,-1),'mmyyyy'))
                                                 or deie.riferimento = lpad(P_mese,2,'0')||P_anno
                                                 )
                                       )
                 ;
-- dbms_output.put_line('righe in insert 5: '||SQL%ROWCOUNT);
             END IF;
             commit;
          END IF;

          BEGIN
          -- assestamento gestione TFR
          update gestione_tfr_emens
             set imp_corrente = nvl(imp_corrente,0)
               , imp_pregresso = nvl(imp_pregresso,0)
               , imp_liquidazione = nvl(imp_liquidazione,0)
               , imp_anticipazione = nvl(imp_anticipazione,0)
           where anno = P_anno
             and mese = P_mese
             and ci = CUR_EMENS.CI
             and dal_emens = CUR_EMENS.dal
             and base_calcolo is not null
          ;
          END;
        END;
      END;
  END IF; 
END LOOP; -- cur_emens
/* Accorpamento periodi SOLO DIP e SOLO per sfasato */
 IF P_sfasato = 'X' THEN
-- dbms_output.put_line('accorpa sfasato');
  FOR CUR_ACCORPA_SFASATO in 
     ( select distinct ci, dal, gestione, gestione_alternativa, rilevanza, qualifica1, qualifica2, qualifica3 
                     , tipo_contribuzione, codice_contratto , riferimento
        from denuncia_emens deie
       where anno = P_anno
         and mese = P_mese
         and specie_rapporto = 'DIP'
         and rilevanza = 'C'
         and to_char(dal,'mmyyyy') = lpad(P_mese,2,'0')||P_anno
         and nvl(imponibile,0) != 0
         and not exists ( select 'x'
                            from settimane_emens 
                           where deie_id = deie.deie_id
                          union
                          select 'x'
                            from variabili_emens 
                           where deie_id = deie.deie_id
                          union
                          select 'x'
                            from dati_particolari_emens 
                           where deie_id = deie.deie_id
                          union
                          select 'x'
                            from fondi_speciali_emens 
                           where deie_id = deie.deie_id
                          union
                          select 'x'
                            from gestione_tfr_emens
                           where deie_id = deie.deie_id
                        )
         and exists ( select 'x'
                        from denuncia_emens 
                       where anno = P_anno 
                         and  mese = P_mese 
                         and ci = deie.ci 
                         and ( to_char(al,'yyyy') = P_anno
                         and to_char(al,'mm') < P_mese
                           or to_char(al,'yyyy') < P_anno
                             )
                    )
         and (  P_tipo = 'T'
           or ( P_tipo = 'S' and deie.ci = P_ci )
           or ( P_tipo in ('P','V','I')
               and not exists
                    ( select 'x' from denuncia_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                    )
              )
          )
         and exists (select 'x'
                       from periodi_retributivi pere
                          , posizioni posi
                      where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                        and competenza in ('P','C','A')
                        and servizio   in ('Q','I','N')
                        and ci          = deie.ci
                        and pere.posizione like P_posizione
                        and gestione       like P_gestione
                        and pere.gestione   in (select codice
                                                  from gestioni
                                                 where nvl(fascia,'%') like P_fascia)
                        and pere.posizione  = posi.codice
                        and ( posi.di_ruolo = P_ruolo
                           or ( P_tipo = 'S' and pere.ci = P_ci )
                           or P_ruolo            = '%'
                           or posi.collaboratore = 'SI'
                            )
                      )
         and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = deie.ci
                 and rain.rapporto       like P_rapporto
                 and nvl(rain.gruppo,' ') like P_gruppo
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
     order by 1
     )  LOOP
-- dbms_output.put_line('inizio loop');
     V_imponibile := 0;
     V_ritenuta   := 0;
     V_giorni     := 0;
     V_settimane  := 0;
       select sum(imponibile), sum(ritenuta) , sum(giorni_retribuiti) , sum(settimane_utili)
         into V_imponibile, V_ritenuta, V_giorni, V_settimane
         from denuncia_emens
        where anno = P_anno
          and mese = P_mese
          and ci = CUR_ACCORPA_SFASATO.ci
          and dal = CUR_ACCORPA_SFASATO.dal
          and nvl(qualifica1,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica1,' ')
          and nvl(qualifica2,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica2,' ')
          and nvl(qualifica3,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica3,' ')
          and nvl(gestione,' ' ) = nvl(CUR_ACCORPA_SFASATO.gestione,' ')
          and nvl(gestione_alternativa,' ' ) = nvl(CUR_ACCORPA_SFASATO.gestione_alternativa,' ')
          and nvl(rilevanza,' ' ) = nvl(CUR_ACCORPA_SFASATO.rilevanza, ' ')
          and nvl(tipo_contribuzione,' ' ) = nvl(CUR_ACCORPA_SFASATO.tipo_contribuzione,' ')
          and nvl(codice_contratto,' ' ) = nvl(CUR_ACCORPA_SFASATO.codice_contratto,' ')
          and nvl(riferimento,' ' ) = nvl(CUR_ACCORPA_SFASATO.riferimento,' ')
        ;
    IF nvl(V_imponibile,0) + nvl(V_ritenuta,0) + nvl(V_giorni,0) + nvl(V_settimane,0) != 0 THEN
       FOR CUR_DAL in
       ( select deie_id, dal
           from denuncia_emens deie
          where anno = P_anno
            and mese = P_mese
            and ci = CUR_ACCORPA_SFASATO.ci
            and nvl(qualifica1,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica1,' ')
            and nvl(qualifica2,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica2,' ')
            and nvl(qualifica3,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica3,' ')
            and nvl(gestione,' ' ) = nvl(CUR_ACCORPA_SFASATO.gestione,' ')
            and nvl(gestione_alternativa,' ' ) = nvl(CUR_ACCORPA_SFASATO.gestione_alternativa,' ')
            and nvl(rilevanza,' ' ) = nvl(CUR_ACCORPA_SFASATO.rilevanza, ' ')
            and nvl(tipo_contribuzione,' ' ) = nvl(CUR_ACCORPA_SFASATO.tipo_contribuzione,' ')
            and nvl(codice_contratto,' ' ) = nvl(CUR_ACCORPA_SFASATO.codice_contratto,' ')
            and nvl(riferimento,' ' ) = nvl(CUR_ACCORPA_SFASATO.riferimento,' ')
            and dal = ( select max(dal) 
                          from denuncia_emens
                         where anno = P_anno and  mese = P_mese and ci = deie.ci 
                           and ( to_char(al,'yyyy') = P_anno
                           and to_char(al,'mm') < P_mese
                             or to_char(al,'yyyy') < P_anno
                              )
                           and nvl(qualifica1,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica1,' ')
                           and nvl(qualifica2,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica2,' ')
                           and nvl(qualifica3,' ') = nvl(CUR_ACCORPA_SFASATO.qualifica3,' ')
                           and nvl(gestione,' ' ) = nvl(CUR_ACCORPA_SFASATO.gestione,' ')
                           and nvl(gestione_alternativa,' ' ) = nvl(CUR_ACCORPA_SFASATO.gestione_alternativa,' ')
                           and nvl(rilevanza,' ' ) = nvl(CUR_ACCORPA_SFASATO.rilevanza, ' ')
                           and nvl(tipo_contribuzione,' ' ) = nvl(CUR_ACCORPA_SFASATO.tipo_contribuzione,' ')
                           and nvl(codice_contratto,' ' ) = nvl(CUR_ACCORPA_SFASATO.codice_contratto,' ')
                           and nvl(riferimento,' ' ) = nvl(CUR_ACCORPA_SFASATO.riferimento,' ')
                      )
            and ( to_char(al,'yyyy') = P_anno
            and to_char(al,'mm') < P_mese
             or to_char(al,'yyyy') < P_anno
                )
            and exists ( select 'x'
                           from settimane_emens 
                           where deie_id = deie.deie_id
                          union
                         select 'x'
                           from variabili_emens 
                           where deie_id = deie.deie_id
                         union
                         select 'x'
                           from dati_particolari_emens 
                           where deie_id = deie.deie_id
                         union
                         select 'x'
                           from fondi_speciali_emens 
                           where deie_id = deie.deie_id
                         union
                         select 'x'
                           from gestione_tfr_emens 
                           where deie_id = deie.deie_id
                        )
            and rownum = 1
       ) LOOP
       update denuncia_emens deie
          set imponibile = nvl(imponibile,0) + V_imponibile
            , ritenuta = nvl(ritenuta,0) + V_ritenuta
            , giorni_retribuiti = nvl(giorni_retribuiti,0) + V_giorni
            , settimane_utili = nvl(settimane_utili,0) + V_settimane
        where anno = P_anno
          and mese = P_mese
          and ci = CUR_ACCORPA_SFASATO.ci
          and dal = CUR_DAL.dal
          and deie_id = CUR_DAL.deie_id;
       delete from denuncia_emens deie
        where anno = P_anno
          and mese = P_mese
          and ci = CUR_ACCORPA_SFASATO.ci
          and dal = CUR_ACCORPA_SFASATO.dal;
        END LOOP; -- CUR_DAL
 END IF;
  END LOOP; -- cur_ACCORPA_SFASATO
  END IF; -- controllo su sfasato

  FOR CUR_EMENS_CATASTO in CURSORE_EMENS.CUR_EMENS_EMENS
      ( P_tipo, P_ci, P_ruolo, P_anno, P_mese, P_posizione, P_gestione, P_fascia, P_rapporto, P_gruppo
      , P_ente, P_ambiente, P_utente
      ) LOOP
      BEGIN
        D_cod_catasto := null;
        D_settore     := null;
        BEGIN
         select settore
           into D_settore
           from periodi_retributivi pere
          where ci = CUR_EMENS_CATASTO.ci
            and competenza = 'A'
            and periodo = last_day(to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy'))
         ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_settore := null;
        END;
        BEGIN
          select comu.codice_catasto
            into D_cod_catasto
            from comuni       comu
               , anagrafici   anag
           where anag.comune_res    = comu.cod_comune
             and anag.provincia_res = comu.cod_provincia
             and anag.ni            = gp4_unor.get_sede(  gp4_stam.GET_NI_NUMERO(D_settore)
                                                        , 'GP4'
                                                        , last_day(to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy'))
                                                        )
             and last_day(to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy')) between anag.dal
                                                                            and nvl(anag.al,to_date('3333333','j'))
           ;
         EXCEPTION WHEN NO_DATA_FOUND THEN
             BEGIN
                select comu.codice_catasto
                  into D_cod_catasto
                  from comuni       comu
                     , gestioni     gest
                 where gest.comune_res    = comu.cod_comune
                   and gest.provincia_res = comu.cod_provincia
                   and gest.codice        = CUR_EMENS_CATASTO.gestione
              ;
             EXCEPTION WHEN NO_DATA_FOUND THEN
                D_cod_catasto := '';
             END;
         END;
         IF D_cod_catasto is not null THEN
            update denuncia_emens
               set codice_catasto = D_cod_catasto
             where deie_id = CUR_EMENS_CATASTO.deie_id
            ;
            commit;
         ELSE
         -- segnalazione
         null;
         END IF;
      END;
  END LOOP; -- cur_emens_catasto

  BEGIN 
/* cancello record vuoti e senza dettaglio ed eseguo ultimi assestamenti */
  <<FINALE>>
   FOR CUR_CI_FINALE in 
  ( select distinct ci 
      from denuncia_emens deie
     where anno = to_number(P_anno)
       and mese = P_mese
       and (    P_tipo = 'T'
           or ( P_tipo = 'S' and deie.ci = P_ci )
           or ( P_tipo in ('P','V','I')
            and not exists  ( select 'x' from denuncia_emens 
                               where anno = P_anno and  mese = P_mese 
                                 and ci       = deie.ci
                                 and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                  or (P_tipo     = 'P' and tipo_agg is not null) )
                               union
                              select 'x' from settimane_emens 
                               where anno = P_anno and  mese = P_mese 
                                 and ci       = deie.ci
                                 and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                  or (P_tipo     = 'P' and tipo_agg is not null) )
                               union
                              select 'x' from variabili_emens 
                               where anno = P_anno and  mese = P_mese 
                                 and ci       = deie.ci
                                 and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                  or (P_tipo     = 'P' and tipo_agg is not null) )
                               union
                              select 'x' from dati_particolari_emens 
                               where anno = P_anno and  mese = P_mese 
                                 and ci       = deie.ci
                                 and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                  or (P_tipo     = 'P' and tipo_agg is not null) )
                               union
                              select 'x' from fondi_speciali_emens 
                               where anno = P_anno and  mese = P_mese 
                                 and ci       = deie.ci
                                 and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                  or (P_tipo     = 'P' and tipo_agg is not null) )
                               union
                              select 'x' from gestione_tfr_emens 
                               where anno = P_anno and  mese = P_mese 
                                 and ci       = deie.ci
                                 and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                                  or (P_tipo     = 'P' and tipo_agg is not null) )
                            )
                        )
                    )
         and exists (select 'x' 
                       from periodi_retributivi pere
                          , posizioni posi
                      where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                        and competenza in ('P','C','A')
                        and servizio   in ('Q','I','N')
                        and ci          = deie.ci
                        and pere.posizione like P_posizione
                        and gestione       like P_gestione 
                        and pere.gestione   in (select codice
                                                  from gestioni
                                                 where nvl(fascia,'%') like P_fascia)
                        and pere.posizione  = posi.codice
                        and ( posi.di_ruolo = P_ruolo
                           or ( P_tipo = 'S' and pere.ci = P_ci )
                           or P_ruolo            = '%'
                           or posi.collaboratore = 'SI'
                            )
                      )
         and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = deie.ci
                 and rain.rapporto       like P_rapporto
                 and nvl(rain.gruppo,' ') like P_gruppo
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
    ) LOOP
-- dbms_output.put_line('CUR CI FINALE: '||CUR_CI_FINALE.ci );
/* azzeramento settimane utili se cont 71 per Piacenza */
   IF P_no_utili = 'X' THEN
     update denuncia_emens deie
        set settimane_utili = ''
      where nvl(settimane_utili,0) != 0
        and anno = P_anno
        and mese = P_mese
        and tipo_contribuzione = '71'
        and deie.ci = CUR_CI_FINALE.ci 
       ;
   END IF;
/* assestamento giorni malattia in recupero */
   IF P_mal_privati = 'P' THEN
     update denuncia_emens deie
        set giorni_retribuiti = ( select giorni_retribuiti
                                    from denuncia_emens
                                   where ci = deie.ci
                                     and anno = P_anno
                                     and mese = P_mese
                                     and riferimento != deie.riferimento
                                     and nvl(giorni_retribuiti,0) < 0
                                     and nvl(imponibile,0) = 0
                                     and giorno_cessazione is null
                                     and al = deie.al 
                                     and rilevanza = 'C'
                                )
      where anno = P_anno
        and mese = P_mese
        and rilevanza = 'P'
        and ci = CUR_CI_FINALE.ci
        and exists ( select 'x'
                       from denuncia_emens
                      where ci = deie.ci
                        and anno = P_anno
                        and mese = P_mese
                        and riferimento != deie.riferimento
                        and nvl(giorni_retribuiti,0) < 0
                        and nvl(imponibile,0) = 0
                        and giorno_cessazione is null
                        and al = deie.al 
                        and rilevanza = 'C'
                    )
      ;
    commit;
    update denuncia_emens deie
       set giorni_retribuiti = ''
     where anno = P_anno
       and mese = P_mese
       and rilevanza = 'C'
       and nvl(imponibile,0) = 0
       and ci = CUR_CI_FINALE.ci
       and giorno_cessazione is null
       and exists ( select 'x'
                      from denuncia_emens
                     where ci = deie.ci
                       and anno = P_anno
                       and mese = P_mese
                       and riferimento = lpad(P_mese,2,'0')||P_anno
                       and nvl(giorni_retribuiti,0) < 0
                       and al = deie.al 
                       and rilevanza = 'P'
                     );
   END IF; -- P_mal_privati mesi precedenti

/*  assestamento per liquidazione su periodi di aperl precedenti
  e assestamento periodi su anno precedente con cambio di dati significativi in pere */

   IF nvl(P_sfasato,' ') != 'X' THEN
     update denuncia_emens deie
        set ( imponibile, ritenuta, contributo ) 
                       = ( select nvl(deie.imponibile,0) + nvl(sum(deie1.imponibile),0)
                               ,  nvl(deie.ritenuta,0) + nvl(sum(deie1.ritenuta),0)
                               ,  nvl(deie.contributo,0) + nvl(sum(deie1.contributo),0)
                             from denuncia_emens deie1
                            where deie1.ci = deie.ci
                              and deie1.anno = P_anno
                              and deie1.mese = P_mese
                              and ( substr(deie1.riferimento,3,4) < P_anno 
                                or  substr(deie1.riferimento,3,4) = P_anno
                                and substr(deie1.riferimento,1,2) < P_mese
                                   )
                              and nvl(deie1.imponibile,0) + nvl(deie1.ritenuta,0) + nvl(deie1.contributo,0) != 0
                              and deie1.rilevanza = 'C'
                         )
      where anno = P_anno
        and mese = P_mese
        and rilevanza = 'C'
        and specie_rapporto = 'DIP'
        and riferimento = lpad(P_mese,2,'0')||P_anno
        and dal = ( select min(dal)
                      from denuncia_emens
                     where ci   = deie.ci
                       and anno = P_anno
                       and mese = P_mese
                       and rilevanza = 'C'
                       and specie_rapporto = 'DIP'
                       and riferimento = lpad(P_mese,2,'0')||P_anno
                   )
        and exists ( select 'x'
                       from denuncia_emens deie1
                      where deie1.ci = deie.ci
                        and deie1.anno = P_anno
                        and deie1.mese = P_mese
                        and ( substr(deie1.riferimento,3,4) < P_anno 
                          or  substr(deie1.riferimento,3,4) = P_anno
                          and substr(deie1.riferimento,1,2) < P_mese
                            )
                        and nvl(deie1.imponibile,0) + nvl(deie1.ritenuta,0) + nvl(deie1.contributo,0) != 0
                        and deie1.rilevanza = 'C'
                    )
        and ci = CUR_CI_FINALE.ci
      ;
-- dbms_output.put_line('mod: '||sql%rowcount);
    commit;
     update denuncia_emens deie
        set imponibile = ''
          , ritenuta = ''
          , contributo = ''
      where anno = P_anno
        and mese = P_mese
        and rilevanza = 'C'
        and specie_rapporto = 'DIP'
        and exists ( select 'x'
                       from denuncia_emens deie1
                      where deie1.ci = deie.ci
                        and deie1.anno = P_anno
                        and deie1.mese = P_mese
                        and deie1.riferimento = lpad(P_mese,2,'0')||P_anno
                        and deie1.rilevanza = 'C'
                        and nvl(deie1.imponibile,0) + nvl(deie1.ritenuta,0) + nvl(deie1.contributo,0) != 0
                    )
        and ( substr(deie.riferimento,3,4) < P_anno 
          or  substr(deie.riferimento,3,4) = P_anno
          and substr(deie.riferimento,1,2) < P_mese
            )
        and ci = CUR_CI_FINALE.ci
      ;
    commit;
/* assestamento per anno 2005 ripresi per arretrati del 2004 */
    IF P_anno = 2005 THEN
     update denuncia_emens deie
        set riferimento  = lpad(P_mese,2,'0')||P_anno
          , tipo_assunzione = null
          , giorno_assunzione = null
          , tipo_cessazione = null
          , giorno_cessazione = null
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and substr(riferimento,3,4) < P_anno 
        and not exists
            (select 'x' from denuncia_emens
              where ci       = deie.ci 
                and anno     = deie.anno
                and mese     = deie.mese
                and riferimento = lpad(P_mese,2,'0')||P_anno
            )
        and ci = CUR_CI_FINALE.ci;
     END IF; -- controllo su anno 2005
    commit;
     update denuncia_emens deie
        set rettifica = 'S'
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and rilevanza    = 'C'
        and ci = CUR_CI_FINALE.ci
        and ( substr(riferimento,3,4) < P_anno 
         or  substr(riferimento,3,4) = P_anno
         and substr(riferimento,1,2) < P_mese
           );
    commit;
    END IF; -- P_sfasato

/* ripresi per arretrati */
     update denuncia_emens deie
        set rettifica = null
          , riferimento = decode( P_sfasato,'X',lpad(D_mese_den,2,'0')||D_anno_den
                                               ,lpad(P_mese,2,'0')||P_anno)
          , giorno_assunzione = null
          , tipo_assunzione = null
          , giorno_cessazione = null
          , tipo_cessazione = null
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and ( P_sfasato is null
         and  substr(riferimento,3,4) < P_anno 
          or P_sfasato is null
         and substr(riferimento,3,4) = P_anno
         and substr(riferimento,1,2) < P_mese
         or  P_sfasato ='X'
         and substr(riferimento,3,4) < D_anno_den
          or P_sfasato ='X'
         and substr(riferimento,3,4) = D_anno_den
         and substr(riferimento,1,2) < D_mese_den
            )
        and not exists 
           ( select 'x' from denuncia_emens
              where ci       = deie.ci 
                and anno     = deie.anno
                and mese     = deie.mese
                and riferimento = lpad(P_mese,2,'0')||P_anno
            )
        and ci = CUR_CI_FINALE.ci
        and nvl(deie.imponibile,0) + nvl(deie.ritenuta,0) + nvl(deie.contributo,0) != 0
        and nvl(deie.giorni_retribuiti,0) = 0 ;
    commit;

/* liquidazioni in AC riferite ad AP su personale cessato */
    FOR CUR_RIF_AP IN 
   ( select ci
       FROM denuncia_emens deie
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and ( P_sfasato is null
         and  substr(riferimento,3,4) < P_anno 
           or P_sfasato is null
          and substr(riferimento,3,4) = P_anno
          and substr(riferimento,1,2) < P_mese
          or  P_sfasato ='X'
          and substr(riferimento,3,4) < D_anno_den
           or P_sfasato ='X'
          and substr(riferimento,3,4) = D_anno_den
          and substr(riferimento,1,2) < D_mese_den
             )
          and not exists 
                   ( select 'x' from denuncia_emens
                      where ci       = deie.ci 
                        and anno     = deie.anno
                        and mese     = deie.mese
                        and riferimento = lpad(P_mese,2,'0')||P_anno
                    )
          and specie_rapporto = 'DIP'
          and ci = CUR_CI_FINALE.ci   
  ) LOOP
    BEGIN
     INSERT INTO DENUNCIA_EMENS 
          ( deie_id, ci, anno, mese, dal, al, rilevanza, gestione, gestione_alternativa
          , riferimento
          , specie_rapporto, qualifica1, qualifica2, qualifica3
          , tipo_contribuzione, codice_contratto, tipo_lavoratore
          , imponibile, ritenuta
          , codice_catasto
          , utente, tipo_agg, data_agg) 
     SELECT DEIE_SQ.nextval, CUR_RIF_AP.ci, P_anno, P_mese
          , to_date('01'||lpad(D_mese_den,2,'0')||D_anno_den,'ddmmyyyy')
          , last_day(to_date(lpad(D_mese_den,2,'0')||D_anno_den,'mmyyyy'))
          , deie1.rilevanza, deie1.gestione, deie1.gestione_alternativa
          , lpad(D_mese_den,2,'0')||D_anno_den
          , deie1.specie_rapporto, deie1.qualifica1, deie1.qualifica2, deie1.qualifica3
          , deie1.tipo_contribuzione, deie1.codice_contratto, '0'
          , deie1.imponibile, deie1.ritenuta
          , deie1.codice_catasto
          , P_utente, null, sysdate
       FROM dual
          , ( select ci, specie_rapporto, qualifica1, qualifica2, qualifica3
                   , rilevanza, gestione, gestione_alternativa
                   , tipo_contribuzione, codice_contratto
                   , sum(imponibile) imponibile
                   , sum(ritenuta) ritenuta
                   , max(codice_catasto) codice_catasto
               FROM denuncia_emens deie
              where anno         = to_number(P_anno)
                and mese         = P_mese
                and ( P_sfasato is null
                 and  substr(riferimento,3,4) < P_anno 
                  or P_sfasato is null
                 and substr(riferimento,3,4) = P_anno
                 and substr(riferimento,1,2) < P_mese
                 or  P_sfasato ='X'
                 and substr(riferimento,3,4) < D_anno_den
                  or P_sfasato ='X'
                 and substr(riferimento,3,4) = D_anno_den
                 and substr(riferimento,1,2) < D_mese_den
                    )
                and not exists 
                   ( select 'x' from denuncia_emens
                      where ci       = deie.ci 
                        and anno     = deie.anno
                        and mese     = deie.mese
                        and riferimento = lpad(P_mese,2,'0')||P_anno
                    )
                and specie_rapporto = 'DIP'
                and deie.ci = CUR_RIF_AP.ci
             group by ci
                    , rilevanza, gestione, gestione_alternativa
                    , specie_rapporto, qualifica1, qualifica2, qualifica3
                    , tipo_contribuzione, codice_contratto
               having sum( nvl(deie.imponibile,0) + nvl(deie.ritenuta,0) + nvl(deie.contributo,0) 
                         + nvl(giorni_retribuiti,0) ) != 0 
            ) deie1
    ;
   commit;
     update denuncia_emens deie
        set imponibile = '', ritenuta = ''
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and ( P_sfasato is null
         and  substr(riferimento,3,4) < P_anno 
          or P_sfasato is null
         and substr(riferimento,3,4) = P_anno
         and substr(riferimento,1,2) < P_mese
         or  P_sfasato ='X'
         and substr(riferimento,3,4) < D_anno_den
          or P_sfasato ='X'
         and substr(riferimento,3,4) = D_anno_den
         and substr(riferimento,1,2) < D_mese_den
            )
        and specie_rapporto = 'DIP'
        and deie.ci = CUR_RIF_AP.ci
        and  nvl(deie.imponibile,0) + nvl(deie.ritenuta,0) + nvl(deie.contributo,0) 
               + nvl(giorni_retribuiti,0) != 0 
    ;
    commit;
    END;
   END LOOP; -- CUR_RIF_AP 

/* cancellazione dettaglio settimane per record vuoti */
     delete from settimane_emens seie
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and ci           = CUR_CI_FINALE.ci
        and exists
           (select 'x' from denuncia_emens deie
             where deie.deie_id  = seie.deie_id
               and rilevanza     = 'C'
               and nvl(deie.giorni_retribuiti,0) = 0
               and nvl(deie.settimane_utili,0) = 0
               and nvl(deie.imponibile,0) = 0
               and nvl(deie.ritenuta,0) = 0
               and nvl(deie.contributo,0) = 0
            )
        and not exists ( select 'x'
                           from variabili_emens 
                          where deie_id  = seie.deie_id
                       )
        and not exists ( select 'x'
                           from dati_particolari_emens 
                          where deie_id  = seie.deie_id
                       )
        and not exists ( select 'x'
                           from fondi_speciali_emens 
                          where deie_id  = seie.deie_id
                       )
        and not exists ( select 'x'
                           from gestione_tfr_emens 
                          where deie_id  = seie.deie_id
                       )
        ;
    commit;

/* cancellazione record con imponibile e giorni a zero e senza dettaglio */
     delete from denuncia_emens deie
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and deie.ci      = CUR_CI_FINALE.ci
        and nvl(giorni_retribuiti,0) = 0
        and nvl(settimane_utili,0) = 0
        and nvl(imponibile,0) = 0
        and nvl(ritenuta,0) = 0
        and nvl(contributo,0) = 0
        and not exists ( select 'x'
                           from settimane_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from variabili_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from dati_particolari_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from fondi_speciali_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from gestione_tfr_emens 
                          where deie_id  = deie.deie_id
                       )
       ;
    commit;

/* cancellazione record non validi */
      delete from denuncia_emens deie
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and ci                = CUR_CI_FINALE.ci
        and dal > al
        and nvl(imponibile,0) = 0
        and not exists ( select 'x'
                           from settimane_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from variabili_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from dati_particolari_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from fondi_speciali_emens 
                          where deie_id  = deie.deie_id
                       )
        and not exists ( select 'x'
                           from gestione_tfr_emens 
                          where deie_id  = deie.deie_id
                       )
       ;
    commit;

/* cancellazione record 2004 o antecedenti */
     delete from denuncia_emens deie
      where anno         = to_number(P_anno)
        and mese         = P_mese
        and ci           = CUR_CI_FINALE.ci
        and substr(riferimento,3,4) <= '2004'
        and nvl(P_sfasato,' ') != 'X'
        and nvl(imponibile,0)   = 0
      ;
    commit;

/* Modifica tipo_lavoratore per privati */
     update denuncia_emens deie
        set tipo_lavoratore = 'Z4'
      where anno            = P_anno
        and mese            = P_mese
        and ci              = CUR_CI_FINALE.ci
        and exists   (select 'x' 
                        from periodi_retributivi pere
                           , posizioni posi
                       where periodo = last_day(to_date(lpad(P_mese,2,'0')||(P_anno),'mmyyyy'))
                         and competenza in ('P','C','A')
                         and servizio   in ('Q','I','N')
                         and ci              = deie.ci
                         and pere.posizione like P_posizione
                         and gestione       like P_gestione 
                         and pere.gestione   in (select codice
                                                   from gestioni
                                                  where nvl(fascia,'%') like P_fascia)
                         and pere.posizione  = posi.codice
                         and pere.trattamento in ( 'R96', 'RI96')
                         and ( posi.di_ruolo = P_ruolo
                            or P_ruolo            = '%'
                            or ( P_tipo = 'S' and pere.ci = P_ci )
                             )
                      );
       commit;
    IF P_sfasato = 'X' THEN
     update denuncia_emens deie
        set al    = least(al,D_fin_mese_prec)
          , riferimento = lpad(D_mese_den,2,'0')||D_anno_den
      where anno  = to_number(P_anno)
        and mese   = P_mese
        and ci = CUR_CI_FINALE.ci 
        and riferimento = lpad(P_mese,2,'0')||P_anno
     ;
    END IF;
    IF P_posticipato = 'X' THEN
/* Solo per Dipendenti */
       INSERT INTO DENUNCIA_EMENS 
          ( deie_id, ci, anno, mese, dal, al, rilevanza, gestione, gestione_alternativa
          , riferimento
          , specie_rapporto, qualifica1, qualifica2, qualifica3
          , tipo_contribuzione, codice_contratto, tipo_lavoratore
          , imponibile, ritenuta
          , codice_catasto
          , utente, tipo_agg, data_agg) 
     SELECT DEIE_SQ.nextval, ci, P_anno, P_mese
          , to_date('01'||lpad(D_mese_den,2,'0')||D_anno_den,'ddmmyyyy')
          , last_day(to_date(lpad(D_mese_den,2,'0')||D_anno_den,'mmyyyy'))
          , rilevanza, gestione, gestione_alternativa
          , lpad(D_mese_den,2,'0')||D_anno_den
          , specie_rapporto, qualifica1, qualifica2, qualifica3
          , tipo_contribuzione, codice_contratto, '0'
          , imponibile, ritenuta
          , codice_catasto
          , P_utente, null, sysdate
       FROM denuncia_emens deie
      where anno = P_anno
        and mese = P_mese
        and riferimento = lpad(P_mese,2,'0')||P_anno
        and specie_rapporto = 'DIP'
        and ci = CUR_CI_FINALE.ci;

     update denuncia_emens deie
        set rettifica = 'S' 
          , imponibile = null
          , ritenuta = null
      where anno = P_anno
        and mese = P_mese
        and riferimento = lpad(P_mese,2,'0')||P_anno
        and specie_rapporto = 'DIP'
        and ci = CUR_CI_FINALE.ci;

/* Solo per i collaboratori */
     update denuncia_emens deie
        set riferimento = lpad(D_mese_den,2,'0')||D_anno_den
      where anno = P_anno
        and mese = P_mese
        and riferimento = lpad(P_mese,2,'0')||P_anno
        and specie_rapporto = 'COCO'
        and ci = CUR_CI_FINALE.ci;
      END IF; -- posticipato
/* annullamento importi a 0 */
     update denuncia_emens
        set imponibile = decode(imponibile, 0, null, imponibile )
          , ritenuta = decode(ritenuta, 0, null, ritenuta )
          , contributo = decode(contributo, 0, null, contributo )
          , giorni_retribuiti = decode(giorni_retribuiti, 0, null, giorni_retribuiti)
          , settimane_utili = decode(settimane_utili, 0, null, settimane_utili)
      where anno = P_anno
        and mese = P_mese
        and ci = CUR_CI_FINALE.ci;
     commit;

    IF P_tfr in ( '0', '1' ) and P_mese = 2 THEN
-- dbms_output.put_line( ' update tfr ');
     BEGIN
       update denuncia_emens deie
          set tfr = P_tfr
       where anno = P_anno
         and mese = 2
         and rilevanza = 'C'
         and specie_rapporto = 'DIP'
         and rettifica is null
         and ci = CUR_CI_FINALE.ci
         and dal = ( select max(dal)
                       from denuncia_emens
                      where ci = deie.ci
                        and anno = P_anno
                        and mese = P_mese
                        and rilevanza = 'C'
                        and rettifica is null
                   )
         and not exists ( select 'x' 
                           from denuncia_emens
                          where ci = deie.ci
                            and anno = P_anno
                            and mese = P_mese
                            and nvl(tfr,0) != 0
                        )
      ;
      commit;
      END;
-- dbms_output.put_line( ' update tfr eseguita: '||sql%rowcount);
     END IF; -- mese 2

    END LOOP; -- CUR_CI_FINALE
  END FINALE;
  BEGIN
   <<ERRORI>>
      FOR CUR_ERRORI IN CURSORE_EMENS.CUR_ERRORI_EMENS 
      ( P_tipo, P_ci, P_anno, P_mese
      ) LOOP
      D_pr_err := nvl(D_pr_err,0)+1;
-- dbms_output.put_line('CUR_ERRORI: '||CUR_ERRORI.ci||' '||CUR_ERRORI.errore);
      INSERT INTO a_segnalazioni_errore
      (no_prenotazione, passo, progressivo, errore, precisazione)
      select prenotazione,1,D_pr_err,CUR_ERRORI.errore,substr(CUR_ERRORI.precisazione,1,200)
        from dual
      where not exists (select 'x' from a_segnalazioni_errore
                         where no_prenotazione = prenotazione
                           and passo  = 1
                           and errore = CUR_ERRORI.errore
                           and precisazione = substr(CUR_ERRORI.precisazione,1,200)
                        );
      END LOOP; -- cur_errori
  END ERRORI;

  BEGIN
    select count(*)
      into V_obj_invalid
      from obj
     where object_name like '%EMENS'
       and status = 'INVALID'
    ;
  EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
           V_obj_invalid := 0;
  END;
  IF V_obj_invalid != 0 THEN
    BEGIN
       utilitypackage.compile_all;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
  END IF;
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
END;
END;
/
