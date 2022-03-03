CREATE OR REPLACE PACKAGE PGMSCERT IS
/******************************************************************************
 NOME:        PGMSCERT
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    20/11/2003 MS/CB  Revisione certificato
 3    27/02/2004 CB       "
 4    06/04/2004 CB       "
 4.1  07/10/2004 ML	- Gestione delle note unificate se unifica i periodi se parametro = SU
                    - Spostato alla riga 8000 il certificato economico
                    - Lettura della qualifica PRIMA della unificazione dei periodi,
                      quindi se cambia la qualifica spezza il periodo
 4.2  15/10/2004 ML	- Definita procedure INSERT_SERVIZI
 4.3  18/10/2004 ML	- Emissione titolo paragrafi solo se presenti i dettagli (assenze, rate, trattamento economico)
 4.4  17/12/2004 ML	- Modificata lettura posizione economica: deve usare il CUR_PEGI.rilevanza
 4.5  17/01/2005 ML	- Abilitazione Autocertificazione
 4.6  18/03/2005 ML	- Modificata lettura ore contrattuali (A10316)
 4.7  16/06/2005 ML	- Modificato test di unificazione periodi sul campo testo (A11680)
 4.8  20/09/2005 ML	- Inserito nuovamente campo if_testo (con confronto sul nuovo campo dep_if_testo) per
                      unificare i periodi di servizio anche se spezzati causa storicizzazione della figura (A12709)
 4.9  12/10/2005 ML - Modifica lettura cur_rate alla minore tra la data di cessazione e la data di riferimento,
                      gestione storicizzazione COVO sempre in cur_rate,
                      uniformata lettura cursori economici (cur_eco,cur_pro e cur_rate) con D_ci (A12981).
 4.10 24/11/2005 ML - Rivista la gestione della data di riferimento economico (A12981.1)
 4.11 24/01/2006 ML	- Eliminata determinazione delle ore lavoro e relativi concatenamenti nel testo in quanto
                      gia' correttamente selezione dal cursore CUR_PEGI.
 4.12 01/09/2006 ML - Nuova gestione campo presso per unificazione periodi (A17426).
 4.13 02/10/2006 ML - Spostata selezione ore individuali prima del cur_eco (A17927)
 4.14 28/11/2006 ML - Abilitata la stampa della retribuzione a rapporto orario solo sulla base della
                      presenza delle ore (A17927.1)
 4.15 06/03/2007 ML - Modifica per ripristino gestione storicizzazione della figura (A19437).
 4.16 14/03/2007 ML - Non stampa la durata su tutti i periodi (A19422).
 4.17 08/08/2007 MS     Sistemazione titolo personale di anagrafici
*******************************************************************************************************/
FUNCTION  VERSIONE RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
PROCEDURE INSERT_SERVIZI (PRENOTAZIONE        IN     NUMBER
                         ,D_RIGA              IN OUT NUMBER
                         ,D_RILEVANZA         IN     VARCHAR2
                         ,PEGI_RILEVANZA      IN     VARCHAR2
                         ,D_CI                IN     NUMBER
                         ,D_DECORRENZA        IN     VARCHAR2
                         ,DD_DECORRENZA       IN     DATE
                         ,D_DAL               IN     DATE
                         ,D_AL                IN     DATE
                         ,D_TESTO             IN     LONG
                         ,D_RUOLO             IN     LONG
                         ,D_PROFILO           IN     LONG
                         ,D_POS_FUN           IN     LONG
                         ,D_FIGURA            IN     LONG
                         ,D_FIGI_NOTE         IN     LONG
                         ,D_TIRA_DESCRIZIONE  IN     LONG
                         ,D_TIRA_NOTE         IN     LONG
                         ,D_DELIBERA          IN     LONG
                         ,D_ESECUTIVA         IN     LONG
                         ,D_DES_QUALIFICA     IN     LONG
                         ,D_NOTE              IN     LONG
                         ,D_DURATA            IN     VARCHAR2
                         ,D_GG                IN     NUMBER
                         ,D_DI_ANNI           IN     VARCHAR2
                         ,D_DI_MESI           IN     VARCHAR2
                         ,D_DI_GIORNI         IN     VARCHAR2
                         );
END;
/
CREATE OR REPLACE PACKAGE BODY PGMSCERT IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V4.17 del 08/08/2007';
END VERSIONE;
PROCEDURE INSERT_SERVIZI (PRENOTAZIONE        IN     NUMBER
                         ,D_RIGA              IN OUT NUMBER
                         ,D_RILEVANZA         IN     VARCHAR2
                         ,PEGI_RILEVANZA      IN     VARCHAR2
                         ,D_CI                IN     NUMBER
                         ,D_DECORRENZA        IN     VARCHAR2
                         ,DD_DECORRENZA       IN     DATE
                         ,D_DAL               IN     DATE
                         ,D_AL                IN     DATE
                         ,D_TESTO             IN     LONG
                         ,D_RUOLO             IN     LONG
                         ,D_PROFILO           IN     LONG
                         ,D_POS_FUN           IN     LONG
                         ,D_FIGURA            IN     LONG
                         ,D_FIGI_NOTE         IN     LONG
                         ,D_TIRA_DESCRIZIONE  IN     LONG
                         ,D_TIRA_NOTE         IN     LONG
                         ,D_DELIBERA          IN     LONG
                         ,D_ESECUTIVA         IN     LONG
                         ,D_DES_QUALIFICA     IN     LONG
                         ,D_NOTE              IN     LONG
                         ,D_DURATA            IN     VARCHAR2
                         ,D_GG                IN     NUMBER
                         ,D_DI_ANNI           IN     VARCHAR2
                         ,D_DI_MESI           IN     VARCHAR2
                         ,D_DI_GIORNI         IN     VARCHAR2
                         ) IS
BEGIN
DECLARE
  Durata             VARCHAR2(240);
BEGIN
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,decorrenza,dal,al,lung_riga,testo)
                VALUES ( prenotazione
                       , D_riga
                       , D_ci
                       , DECODE( D_decorrenza, 'SI', Dd_decorrenza, NULL)
                       , DECODE( D_rilevanza, 'P', TO_DATE(NULL), D_dal)
                       , D_al
                       , DECODE(D_decorrenza
                               ,'SI', decode(D_rilevanza,'P',68,46)
                                    , decode(D_rilevanza,'P',75,53))
                       , D_testo
                       )
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,rientri,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , 2
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_ruolo
                  FROM dual
                 WHERE D_ruolo IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,rientri,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , 2
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_profilo
                  FROM dual
                 WHERE D_profilo IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,rientri,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , 2
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_pos_fun
                  FROM dual
                 WHERE D_pos_fun IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,rientri,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , 2
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_figura
                  FROM dual
                 WHERE D_figura IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_figi_note
                  FROM dual
                 WHERE D_figi_note IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_tira_descrizione
                  FROM dual
                 WHERE D_tira_descrizione IS NOT NULL
                ;
        	    D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_tira_note
                  FROM dual
                 WHERE D_tira_note IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_delibera
                  FROM dual
                 WHERE D_delibera IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , D_ci
                     , DECODE(D_decorrenza,'SI',46,53)
                     , D_esecutiva
                  FROM dual
                 WHERE D_esecutiva IS NOT NULL
                ;
                D_riga := D_riga + 1;
                  INSERT INTO APPOGGIO_CERTIFICATI
                        (prenotazione,progressivo,ci,lung_riga,testo)
                  SELECT prenotazione
                       , D_riga
                       , D_ci
                       , DECODE(D_decorrenza,'SI',46,53)
                       , D_des_qualifica
                    FROM dual
                   WHERE D_des_qualifica IS NOT NULL
                     AND nvl(d_rilevanza, PEGI_rilevanza) not in ('D','P','A')
                  ;
                  D_riga := D_riga + 1;
                  BEGIN
                    SELECT '('||
                           DECODE( NVL(TRUNC(D_gg/360),0)
                                 ,0,NULL
                                   ,' '||D_Di_anni||' '||
                                    TO_CHAR(TRUNC(D_gg/360)))||
                           DECODE(NVL(TRUNC((D_gg-TRUNC(D_gg/360)*360)/30),0)
                                 ,0,NULL
                                   ,' '||D_Di_mesi||' '||
                                    TO_CHAR(TRUNC((D_gg-TRUNC(D_gg/360)*360)/30)))||
                           DECODE(NVL((D_gg
                                         -TRUNC(D_gg/360)*360
                                         -TRUNC((D_gg
                                                -TRUNC(D_gg/360)
                                                *360)/30)*30)
                                        ,0)
                                  ,0,NULL
                                    ,' '||D_Di_giorni||' '||
                                     TO_CHAR((D_gg
                                              -TRUNC(D_gg/360)*360
                                              -TRUNC((D_gg
                                              -TRUNC(D_gg/360)*360)/30)
                                              *30)))||' )'
                      INTO Durata
                      FROM dual
                     WHERE NVL(D_gg,0) != 0
                       AND D_durata = 'SI'
                       AND nvl(d_rilevanza,PEGI_rilevanza) !='D'
                    ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN Durata := NULL;
                  END;
                  INSERT INTO APPOGGIO_CERTIFICATI
                        (prenotazione,progressivo,ci,lung_riga,testo)
                  SELECT prenotazione
                       , D_riga
                       , D_ci
                       , DECODE(D_decorrenza,'SI',46,53)
                       , Durata
                    FROM dual
                   WHERE Durata IS NOT NULL
                   ;
                   D_riga := D_riga + 1;
                   INSERT INTO APPOGGIO_CERTIFICATI
                         (prenotazione,progressivo,ci,lung_riga,testo)
                   SELECT prenotazione
                        , D_riga
                        , D_ci
                        , DECODE(D_decorrenza,'SI',46,53)
                        , D_note
                     FROM dual
                    WHERE D_note IS NOT NULL
                   ;
                   D_riga := D_riga + 1;
 END;
END INSERT_SERVIZI;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE
--
-- Definizione Parametri
--
  D_ente               VARCHAR2(4);
  D_ambiente           VARCHAR2(8);
  D_utente             VARCHAR2(8);
  D_lingua             VARCHAR2(1);
  D_ci                 NUMBER;
  D_certificato        VARCHAR2(4);
  D_st_data            VARCHAR2(2);
  D_residenza          VARCHAR2(1);
  D_st_pagina          VARCHAR2(1);
  D_data_cessaz        VARCHAR2(1);
  D_sinottico          VARCHAR2(2);
  D_riferimento	       DATE;
  D_per_ni	       VARCHAR2(1);
--
-- Definizione Depositi e Contatori
--
  D_conta              NUMBER := 0;
  P_progressivo        NUMBER := 0;
  Dep_ci               NUMBER;
  Dep_rilevanza        VARCHAR2(1);
  Dep_decorrenza       DATE;
  Dep_dal              DATE;
  Dep_al               DATE;
  Dep_testo            LONG;
  Dep_if_testo         LONG;
  Dep_ruolo            LONG;
  Dep_profilo          LONG;
  Dep_pos_fun          LONG;
  Dep_figura           LONG;
  Dep_figi_note        LONG;
  Dep_delibera         LONG;
  Dep_gg               NUMBER;
  Dep_esecutiva        LONG;
  Dep_note             LONG;
  Dep_tira_note        LONG;
  Dep_tira_descrizione LONG;
  Dep_des_qualifica    LONG;
  Dep_t_presso         LONG;
  Dep_t_settore        LONG;
  D_tira_note          LONG;
  D_rif_eco            DATE;
--
-- Definizione Variabili
--
  Di_li                VARCHAR2(5);
  Di_il                VARCHAR2(5);
  Di_dal               VARCHAR2(5);
  Di_al                VARCHAR2(5);
  Di_anni              VARCHAR2(5);
  Di_mesi              VARCHAR2(5);
  Di_giorni            VARCHAR2(6);
  D_riga               NUMBER;
  D_l1                 VARCHAR2(1);
  D_l2                 VARCHAR2(1);
  D_l3                 VARCHAR2(1);
  D_ente_econ          VARCHAR2(2);
  D_oggetto            VARCHAR2(40);
  Di_oggetto           VARCHAR2(40);
  D_cod_int            VARCHAR2(4);
  D_cod_pre            VARCHAR2(4);
  D_cod_ser            VARCHAR2(4);
  D_cod_dim            VARCHAR2(4);
  D_cod_not            VARCHAR2(4);
  D_cod_con            VARCHAR2(4);
  D_cod_fir            VARCHAR2(4);
  Df_decorrenza        VARCHAR2(2);
  Df_oggetto           VARCHAR2(2);
  Df_servizio          VARCHAR2(2);
  Df_note_ind          VARCHAR2(2);
  Df_ruolo             VARCHAR2(2);
  Df_attivita          VARCHAR2(2);
  Df_delibera          VARCHAR2(2);
  Df_esecutivita       VARCHAR2(2);
  Df_durata            VARCHAR2(2);
  Df_cessazione        VARCHAR2(2);
  Df_assenze           VARCHAR2(2);
  Df_economico         VARCHAR2(2);
  Df_tempo_determinato VARCHAR2(2);
  Df_part_time         VARCHAR2(2);
  Df_qualifica         VARCHAR2(2);
  Df_rateali           VARCHAR2(2);
  Df_autocertificato   varchar2(2);
  Df_u_presso          varchar2(2);
  P_tipo_rapporto      VARCHAR2(2);
  D_data               VARCHAR2(250);
  D_testo              VARCHAR2(250);
  D_testo1             VARCHAR2(250);
  D_ni                 NUMBER;
  D_ore_ind	       NUMBER;
  D_ore_lavoro	       NUMBER;
  D_tempo_det	       VARCHAR2(240);
  D_tempo_indet	       VARCHAR2(240);
  D_part_time	       VARCHAR2(240);
  D_ore_cont           VARCHAR2(240);
  D_tempo_pieno	       VARCHAR2(240);
  D_tempo_ridotto      VARCHAR2(240);
  D_des_qualifica      VARCHAR2(4000);
  P_imp_pag            NUMBER;
  P_qta_pag            NUMBER;
  P_rilevanza          varchar2(1);
--
-- Definizione Vocaboli
--
  D_presta             VARCHAR2(240);
  D_prestato           VARCHAR2(240);
  D_decorre            VARCHAR2(240);
  D_fino_a             VARCHAR2(240);
  D_qualita            VARCHAR2(240);
  D_in_qualita         VARCHAR2(240);
  D_qualifica          VARCHAR2(240);
  D_cessazione         VARCHAR2(240);
  D_con                VARCHAR2(240);
  D_presso             VARCHAR2(240);
  D_ser_r              VARCHAR2(240);
  D_ser_nr             VARCHAR2(240);
  D_a                  VARCHAR2(240);
  D_tp                 VARCHAR2(240);
  D_td                 VARCHAR2(240);
  D_em                 VARCHAR2(240);
  D_ore                VARCHAR2(240);
  D_l_ruolo            VARCHAR2(240);
  D_l_profilo          VARCHAR2(240);
  D_l_pos_fun          VARCHAR2(240);
  D_l_figura           VARCHAR2(240);
  D_numero             VARCHAR2(240);
  D_del                VARCHAR2(240);
  D_esecutiva          VARCHAR2(240);
  D_oggi               VARCHAR2(240);
  D_assenza            VARCHAR2(240);
  D_sottolinea         VARCHAR2(240);
  D_contestual         VARCHAR2(240);
  D_tratt_econ         VARCHAR2(240);
  D_sott_econ          VARCHAR2(240);
  D_progr_econ         VARCHAR2(240);
  D_sott_progr         VARCHAR2(240);
  D_con_qual           VARCHAR2(240);
  D_lit                VARCHAR2(240);
  D_euro               VARCHAR2(240);
  D_scadenza           VARCHAR2(240);
  D_matura             VARCHAR2(240);
  D_in_data            VARCHAR2(240);
  D_ore_contratto      NUMBER;
  D_settore            VARCHAR2(240);
  DEP_PRENOTAZIONE     NUMBER:=PRENOTAZIONE;
--
-- Definizione Testi
--
  Dt_evento            VARCHAR2(240);
  Dep_presso           VARCHAR2(2);
  I_testo              LONG;
--
-- Definizione Exception
--
  USCITA               EXCEPTION;
BEGIN
  D_ente     := NULL;
  D_utente   := NULL;
  D_ambiente := NULL;
   BEGIN  /* Estrazione Parametri di Selezione della Prenotazione */
      BEGIN
      SELECT valore
        INTO D_ci
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_CI'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              RAISE USCITA;
      END;
	  BEGIN
	  SELECT to_date(valore,'dd/mm/yyyy')
        INTO D_riferimento
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_RIFERIMENTO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            D_riferimento:=sysdate;
      END;
      BEGIN
      SELECT valore
        INTO D_certificato
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_CERTIFICATO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            D_certificato:=null;
      END;
      BEGIN
      SELECT valore
        INTO D_st_data
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_ST_DATA'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_st_data := 'SI';
      END;
      BEGIN
      SELECT valore
        INTO D_data_cessaz
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_DATA_CESSAZ'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_data_cessaz:= NULL;
      END;
      BEGIN
      SELECT valore
        INTO D_residenza
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_RESIDENZA'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_residenza := NULL;
      END;
      BEGIN
      SELECT valore
        INTO D_st_pagina
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_ST_PAGINA'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_st_pagina := NULL;
      END;
      BEGIN
      SELECT valore
        INTO D_sinottico
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_SINOTTICO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_sinottico := 'I';
      END;
	  BEGIN
      SELECT valore
        INTO D_per_ni
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro    = 'P_TUTTI_CI'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            D_per_ni:=null;
      END;
      BEGIN
      SELECT ENTE
           , utente
           , ambiente
           , gruppo_ling
        INTO D_ente,D_utente,D_ambiente,D_lingua
        FROM a_prenotazioni
       WHERE no_prenotazione = prenotazione
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_ente      := NULL;
              D_ambiente  := NULL;
              D_utente    := NULL;
              D_lingua    := NULL;
      END;
      BEGIN
/* Estrazione gruppo linguistico + flag gestione economica */
        SELECT grli1.gruppo_al                                       l1,
               grli2.gruppo_al                                       l2,
               grli3.gruppo_al                                       l3,
               ENTE.economica                                        econ
          INTO D_l1,D_l2,D_l3,D_ente_econ
          FROM ENTE ENTE,gruppi_linguistici grli1,gruppi_linguistici grli2,
               gruppi_linguistici grli3
         WHERE ENTE.ente_id        = 'ENTE'
           AND grli1.gruppo (+)    = DECODE( ENTE.ente_id||UPPER(D_lingua)
                                           , 'ENTE*', 'I',UPPER(D_lingua))
           AND grli1.sequenza      = 1
           AND grli2.gruppo (+)    = DECODE( ENTE.ente_id||UPPER(D_lingua)
                                           , 'ENTE*', 'I',UPPER(D_lingua))
           AND grli2.sequenza      = 2
           AND grli3.gruppo (+)    = DECODE( ENTE.ente_id||UPPER(D_lingua)
                                           , 'ENTE*', 'I',UPPER(D_lingua))
           AND grli3.sequenza      = 3
        ;
      END;
      BEGIN
        BEGIN
/* Estrazione parametri certificato richiesto */
          SELECT f_int,f_pre,f_ser,f_dim,f_not,f_con,f_fir
               , decorrenza,oggetto,servizio,note_ind
               , ruolo,ATTIVITA,delibera,esecutivita
               , durata,cessazione,assenze,economico,tipo_rapporto
               , tempo_determinato,part_time,pos_economica,situazioni_rateali
               , autocertificazione,u_presso
            INTO D_cod_int,D_cod_pre,D_cod_ser,D_cod_dim
               , D_cod_not,D_cod_con,D_cod_fir
               , Df_decorrenza,Df_oggetto,Df_servizio,Df_note_ind
               , Df_ruolo,Df_attivita,Df_delibera,Df_esecutivita
               , Df_durata,Df_cessazione,Df_assenze,Df_economico,P_tipo_rapporto
               , Df_tempo_determinato,Df_part_time,Df_qualifica,Df_rateali
               , Df_autocertificato,Df_u_presso
            FROM CERTIFICATI
           WHERE codice = D_certificato
        ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
		   UPDATE A_PRENOTAZIONI
                  SET prossimo_passo = 91
                    , ERRORE = 'Certificato non presente'
               WHERE NO_PRENOTAZIONE = prenotazione
               ;
        END;
/* Cursore per certificato sinottico (multilingua) */
        FOR CUR_SIN IN
           (SELECT SUBSTR(D_sinottico,1,1) SIN
                 , 1                       ord
              FROM dual
             UNION
            SELECT SUBSTR(D_sinottico,2,1) SIN
                 , 2                       ord
              FROM dual
             WHERE NVL(SUBSTR(D_sinottico,2,1),' ') != ' '
             ORDER BY 2
           ) LOOP
             BEGIN
/* Estrazione formula di INTESTAZIONE */
             D_riga     := 10;
             FOR CUR_INT IN
                (SELECT testo
                   FROM TESTI_FORMULA
                  WHERE gruppo_ling = CUR_SIN.SIN
                    AND formula     = D_cod_int
                  ORDER BY sequenza
                ) LOOP
                  BEGIN
                  INSERT INTO APPOGGIO_CERTIFICATI
                  (prenotazione,progressivo,lung_riga,testo)
                  VALUES ( prenotazione
                         , D_riga
                         , 75
                         , CUR_INT.testo
                         )
                  ;
                  D_riga := D_riga + 1;
                  END;
                  END LOOP; -- CUR_INT
             END;
             BEGIN
/* Estrazione riga OGGETTO */
             BEGIN
             SELECT DECODE( CUR_SIN.SIN
                          , D_l1,NVL( r1.rv_meaning
                                    , NVL( r1.rv_meaning_al1
                                         , r1.rv_meaning_al2))
                                    , D_l2,NVL( r1.rv_meaning_al1
                                              , NVL( r1.rv_meaning
                                                   , r1.rv_meaning_al2))
                                    , D_l3,NVL( r1.rv_meaning_al2
                                              , NVL( r1.rv_meaning
                                                   , r1.rv_meaning_al1))
                                    )
               INTO Di_oggetto
               FROM PGM_REF_CODES r1
              WHERE r1.rv_domain    = 'VOCABOLO'
                AND r1.rv_low_value = 'OGGETTO:'
             ;
			 EXCEPTION
			  WHEN NO_DATA_FOUND THEN
			   Di_oggetto:='OGGETTO';
			 END;
             D_riga := 25;
/* All'oggetto viene assegnata una riga fissa */
            BEGIN
            SELECT DECODE( CUR_SIN.SIN
                          , D_l1, NVL( cert.descrizione
                                   , NVL( cert.descrizione_al1
                                          , cert.descrizione_al2))
                          , D_l2, NVL( cert.descrizione_al1
                                     , NVL( cert.descrizione
                                          , cert.descrizione_al2))
                          , D_l3, NVL( cert.descrizione_al2
                                     , NVL( cert.descrizione
                                          , cert.descrizione_al1))
                          )
               INTO D_oggetto
               FROM CERTIFICATI cert
              WHERE codice     = D_certificato
             ;
		 EXCEPTION WHEN NO_DATA_FOUND THEN
     		   UPDATE A_PRENOTAZIONI
                  SET ERRORE = 'Certificato non presente',prossimo_passo=91
                WHERE NO_PRENOTAZIONE = prenotazione
               ;
	      END;
             IF Df_oggetto = 'SI' THEN
               INSERT INTO APPOGGIO_CERTIFICATI
               (prenotazione,progressivo,lung_riga,testo)
               VALUES ( prenotazione
                      , D_riga
                      , 75
                      , Di_oggetto||' '||D_oggetto
                      )
               ;
               D_riga := D_riga + 1;
               INSERT INTO APPOGGIO_CERTIFICATI
               (prenotazione,progressivo,lung_riga,testo)
               VALUES ( prenotazione
                      , D_riga
                      , 75
                      , ' '
                      )
               ;
               D_riga := D_riga + 1;
               INSERT INTO APPOGGIO_CERTIFICATI
               (prenotazione,progressivo,lung_riga,testo)
               VALUES ( prenotazione
                      , D_riga
                      , 75
                      , ' '
                      )
               ;
               D_riga := D_riga + 1;
             END IF;
             END;
             D_riga := 30;
             BEGIN
/* Estrazione formula di PREMESSA */
             FOR CUR_PRE IN
                (SELECT testo
                  FROM TESTI_FORMULA
                 WHERE gruppo_ling = CUR_SIN.SIN
                   AND formula     = D_cod_pre
                 ORDER BY sequenza
                ) LOOP
                  BEGIN
                  INSERT INTO APPOGGIO_CERTIFICATI
                 (prenotazione,progressivo,lung_riga,testo)
                  VALUES ( prenotazione
                         , D_riga
                         , 75
                         , CUR_PRE.testo
                         )
                  ;
                  D_riga := D_riga + 1;
                  END;
                  END LOOP; -- CUR_PRE
             END;
             BEGIN
			 P_progressivo:=1;
/* Estrazione dati anagrafici */
   		 BEGIN
             SELECT decode( Df_autocertificato
                           , 'NO', DECODE( CUR_SIN.SIN
                                         , D_l1, NVL( r.rv_meaning
                                                    , NVL( r.rv_meaning_al1
                                                         , r.rv_meaning_al2))
                                         , D_l2, NVL( r.rv_meaning_al1
                                                    , NVL( r.rv_meaning
                                                         , r.rv_meaning_al2))
                                         , D_l3, NVL( r.rv_meaning_al2
                                                    , NVL( r.rv_meaning
                                                         , r.rv_meaning_al1)))||' '
                                 , null
                          )||
                    decode( Df_autocertificato
                           , 'NO', DECODE( anag.sesso
                                         , 'M', DECODE( CUR_SIN.SIN
                                                      , D_l1, NVL( r1.rv_meaning
                                                                 , NVL( r1.rv_meaning_al1
                                                                      , r1.rv_meaning_al2))
                                                      , D_l2, NVL( r1.rv_meaning_al1
                                                                 , NVL( r1.rv_meaning
                                                                      , r1.rv_meaning_al2))
                                                      , D_l3, NVL( r1.rv_meaning_al2
                                                                 , NVL( r1.rv_meaning
                                                                      , r1.rv_meaning_al1))
                                                      )
                                         , 'F', DECODE( CUR_SIN.SIN
                                                      , D_l1, NVL( r2.rv_meaning
                                                                 , NVL( r2.rv_meaning_al1
                                                                      , r2.rv_meaning_al2))
                                                      , D_l2, NVL( r2.rv_meaning_al1
                                                                 , NVL( r2.rv_meaning
                                                                      , r2.rv_meaning_al2))
                                                      , D_l3, NVL( r2.rv_meaning_al2
                                                                 , NVL( r2.rv_meaning
                                                                      , r2.rv_meaning_al1))
                                                      )
                                         )||' '
                                 , null
                    )||
                    DECODE
                    ( anag.titolo
                    , NULL, DECODE
                            ( anag.sesso
                            , 'M', DECODE( Df_autocertificato
                                         , 'NO', DECODE(CUR_SIN.SIN
                                                       ,D_l1,NVL(r3.rv_meaning
                                                                ,NVL(r3.rv_meaning_al1
                                                                    ,r3.rv_meaning_al2))
                                                       ,D_l2,NVL(r3.rv_meaning_al1
                                                                ,NVL(r3.rv_meaning
                                                                    ,r3.rv_meaning_al2))
                                                       ,D_l3,NVL(r3.rv_meaning_al2
                                                                ,NVL(r3.rv_meaning
                                                                    ,r3.rv_meaning_al1)))
                                               , DECODE(CUR_SIN.SIN
                                                       ,D_l1,NVL(r8.rv_meaning
                                                                ,NVL(r8.rv_meaning_al1
                                                                    ,r8.rv_meaning_al2))
                                                       ,D_l2,NVL(r8.rv_meaning_al1
                                                                ,NVL(r8.rv_meaning
                                                                    ,r8.rv_meaning_al2))
                                                       ,D_l3,NVL(r8.rv_meaning_al2
                                                                ,NVL(r8.rv_meaning
                                                                    ,r8.rv_meaning_al1)))
                                         )
                            , 'F', DECODE( Df_autocertificato
                                         , 'NO', DECODE(CUR_SIN.SIN
                                                       ,D_l1,NVL(r4.rv_meaning
                                                                ,NVL(r4.rv_meaning_al1
                                                                    ,r4.rv_meaning_al2))
                                                       ,D_l2,NVL(r4.rv_meaning_al1
                                                                ,NVL(r4.rv_meaning
                                                                    ,r4.rv_meaning_al2))
                                                       ,D_l3,NVL(r4.rv_meaning_al2
                                                                ,NVL(r4.rv_meaning
                                                                    ,r4.rv_meaning_al1)))
                                               , DECODE(CUR_SIN.SIN
                                                       ,D_l1,NVL(r9.rv_meaning
                                                                ,NVL(r9.rv_meaning_al1
                                                                    ,r9.rv_meaning_al2))
                                                       ,D_l2,NVL(r9.rv_meaning_al1
                                                                ,NVL(r9.rv_meaning
                                                                    ,r9.rv_meaning_al2))
                                                       ,D_l3,NVL(r9.rv_meaning_al2
                                                                ,NVL(r9.rv_meaning
                                                                    ,r9.rv_meaning_al1)))
                                         )
                            )
                          , nvl(tipe.titolo, anag.titolo)
                       )||' '||
                  anag.cognome||' '||anag.nome||' '||
                  DECODE( CUR_SIN.SIN
                        , D_l1, NVL( r6.rv_meaning
                                   , NVL( r6.rv_meaning_al1
                                        , r6.rv_meaning_al2))
                        , D_l2, NVL( r6.rv_meaning_al1
                                   , NVL( r6.rv_meaning
                                        , r6.rv_meaning_al2))
                        , D_l3, NVL( r6.rv_meaning_al2
                                   , NVL( r6.rv_meaning
                                        , r6.rv_meaning_al1))
                        )||' '||
                  DECODE
                  ( TO_CHAR(LEAST(999,GREATEST(199,anag.provincia_nas)))
                  , '999', DECODE
                         ( anag.luogo_nas
                         , NULL, DECODE(CUR_SIN.SIN
                                       ,D_l1,NVL(comu1.descrizione
                                                ,NVL(comu1.descrizione_al1
                                                    ,comu1.descrizione_al2))
                                       ,D_l2,NVL(comu1.descrizione_al1
                                                ,NVL(comu1.descrizione
                                                    ,comu1.descrizione_al2))
                                       ,D_l3,NVL(comu1.descrizione_al2
                                                ,NVL(comu1.descrizione
                                                    ,comu1.descrizione_al1))
                                       )
                               , anag.luogo_nas||' ('||
                                 DECODE(CUR_SIN.SIN
                                       ,D_l1,NVL(comu1.descrizione
                                                ,NVL(comu1.descrizione_al1
                                                    ,comu1.descrizione_al2))
                                       ,D_l2,NVL(comu1.descrizione_al1
                                                ,NVL(comu1.descrizione
                                                    ,comu1.descrizione_al2))
                                       ,D_l3,NVL(comu1.descrizione_al2
                                                ,NVL(comu1.descrizione
                                                    ,comu1.descrizione_al1))
                                       )||')'
                         )
                  , '199', DECODE(CUR_SIN.SIN
                               ,D_l1,NVL(comu1.descrizione
                                        ,NVL(comu1.descrizione_al1
                                            ,comu1.descrizione_al2))
                               ,D_l2,NVL(comu1.descrizione_al1
                                        ,NVL(comu1.descrizione
                                            ,comu1.descrizione_al2))
                               ,D_l3,NVL(comu1.descrizione_al2
                                        ,NVL(comu1.descrizione
                                            ,comu1.descrizione_al1))
                               )||' ('||
                         comu1.sigla_provincia||')'
                       , DECODE( anag.luogo_nas
                               , NULL, DECODE
                                       (CUR_SIN.SIN
                                       ,D_l1,NVL(comu1.descrizione
                                                ,NVL(comu1.descrizione_al1
                                                    ,comu1.descrizione_al2))
                                       ,D_l2,NVL(comu1.descrizione_al1
                                                ,NVL(comu1.descrizione
                                                    ,comu1.descrizione_al2))
                                       ,D_l3,NVL(comu1.descrizione_al2
                                                ,NVL(comu1.descrizione
                                                    ,comu1.descrizione_al1))
                                       )||
                                       DECODE
                                       ( anag.comune_nas
                                       , 0, NULL
                                          , ' ('||comu1.sigla_provincia||')'
                                       )
                               , anag.luogo_nas||' ('||
                                 DECODE
                                 ( anag.comune_nas
                                 , 0, DECODE
                                      (CUR_SIN.SIN
                                      ,D_l1,NVL(comu1.descrizione
                                               ,NVL(comu1.descrizione_al1
                                                   ,comu1.descrizione_al2))
                                      ,D_l2,NVL(comu1.descrizione_al1
                                               ,NVL(comu1.descrizione
                                                   ,comu1.descrizione_al2))
                                      ,D_l3,NVL(comu1.descrizione_al2
                                               ,NVL(comu1.descrizione
                                                   ,comu1.descrizione_al1))
                                      )
                                    , comu1.sigla_provincia
                                 )||')'
                         )
                  )||' '||
                  DECODE( CUR_SIN.SIN
                        , D_l1, NVL( r1.rv_meaning
                                   , NVL( r1.rv_meaning_al1
                                        , r1.rv_meaning_al2))
                        , D_l2, NVL( r1.rv_meaning_al1
                                   , NVL( r1.rv_meaning
                                        , r1.rv_meaning_al2))
                        , D_l3, NVL( r1.rv_meaning_al2
                                   , NVL( r1.rv_meaning
                                        , r1.rv_meaning_al1))
                        )||' '||
                  TO_CHAR(anag.data_nas,'dd.mm.yyyy')||', '
                 ,DECODE( D_residenza
                        , NULL, DECODE( CUR_SIN.SIN
                                      , D_l1, NVL( r7.rv_meaning
                                                 , NVL( r7.rv_meaning_al1
                                                      , r7.rv_meaning_al2))
                                      , D_l2, NVL( r7.rv_meaning_al1
                                                 , NVL( r7.rv_meaning
                                                      , r7.rv_meaning_al2))
                                      , D_l3, NVL( r7.rv_meaning_al2
                                                 , NVL( r7.rv_meaning
                                                      , r7.rv_meaning_al1))
                                      )||' '||
                                DECODE( CUR_SIN.SIN
                                       , D_l1, NVL( anag.indirizzo_res
                                                  , NVL( anag.indirizzo_res_al1
                                                       , anag.indirizzo_res_al2))
                                       , D_l2, NVL( anag.indirizzo_res_al1
                                                  , NVL( anag.indirizzo_res
                                                       , anag.indirizzo_res_al2))
                                       , D_l3, NVL( anag.indirizzo_res_al2
                                                   , NVL( anag.indirizzo_res
                                                        , anag.indirizzo_res_al1))
                                       )||' '||
                                DECODE( CUR_SIN.SIN
                                      , D_l1, NVL( comu2.descrizione
                                                 , NVL( comu2.descrizione_al1
                                                      , comu2.descrizione_al2))
                                      , D_l2, NVL( comu1.descrizione_al1
                                                 , NVL( comu2.descrizione
                                                      , comu2.descrizione_al2))
                                      , D_l3, NVL( comu1.descrizione_al2
                                                 , NVL( comu2.descrizione
                                                      , comu2.descrizione_al1))
                                      )||' ('||
                                comu2.sigla_provincia||'), '
                            , NULL)
                , anag.ni
             INTO D_testo
                , D_testo1
                , D_ni
             FROM PGM_REF_CODES r
                , PGM_REF_CODES r1
                , PGM_REF_CODES r2
                , PGM_REF_CODES r3
                , PGM_REF_CODES r4
                , PGM_REF_CODES r6
                , PGM_REF_CODES r7
                , PGM_REF_CODES r8
                , PGM_REF_CODES r9
                , ANAGRAFICI    anag
                , comuni        comu1
                , comuni        comu2
                , titoli_personali tipe
            WHERE r.rv_domain     = 'VOCABOLO'
              AND r.rv_low_value  = 'CHE'
              AND r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'IL'
              AND r2.rv_domain    = 'VOCABOLO'
              AND r2.rv_low_value = 'LA'
              AND r3.rv_domain    = 'VOCABOLO'
              AND r3.rv_low_value = 'SIGNOR'
              AND r4.rv_domain    = 'VOCABOLO'
              AND r4.rv_low_value = 'SIGNORA'
              AND r6.rv_domain    = 'VOCABOLO'
              AND r6.rv_low_value = 'NASCITA'||'_'||anag.sesso
              AND r7.rv_domain    = 'VOCABOLO'
              AND r7.rv_low_value = 'RESIDENZA'
              AND r8.rv_domain    = 'VOCABOLO'
              AND r8.rv_low_value = 'SOTTOSCRITTO'
              AND r9.rv_domain    = 'VOCABOLO'
              AND r9.rv_low_value = 'SOTTOSCRITTA'
              AND anag.ni         = (SELECT DISTINCT ni
                                       FROM RAPPORTI_INDIVIDUALI
                                      WHERE ci = D_ci)
              AND D_riferimento between anag.dal and nvl(anag.al,to_date('3333333','j'))
              AND anag.comune_nas    = comu1.cod_comune
              AND anag.provincia_nas = comu1.cod_provincia
              AND anag.comune_res    = comu2.cod_comune
              AND anag.provincia_res = comu2.cod_provincia
              AND anag.titolo        = tipe.sequenza (+)
           ;
		   EXCEPTION WHEN NO_DATA_FOUND THEN
		   UPDATE A_PRENOTAZIONI SET ERRORE = 'Individuo non presente e/o dati errati',prossimo_passo=91
           WHERE NO_PRENOTAZIONE = prenotazione
           ;
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1,NVL( r1.rv_meaning
                                  , NVL( r1.rv_meaning_al1
                                       , r1.rv_meaning_al2))
                                  , D_l2,NVL( r1.rv_meaning_al1
                                            , NVL( r1.rv_meaning
                                                 , r1.rv_meaning_al2))
                                  , D_l3,NVL( r1.rv_meaning_al2
                                            , NVL( r1.rv_meaning
                                                 , r1.rv_meaning_al1))
                                  )
             INTO Di_li
             FROM PGM_REF_CODES r1
            WHERE r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'LI'
           ;
          EXCEPTION
		   WHEN NO_DATA_FOUND THEN
	              Di_li:='li';
	    END;
          BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1,NVL( r1.rv_meaning
                                  , NVL( r1.rv_meaning_al1
                                       , r1.rv_meaning_al2))
                                  , D_l2,NVL( r1.rv_meaning_al1
                                            , NVL( r1.rv_meaning
                                                 , r1.rv_meaning_al2))
                                  , D_l3,NVL( r1.rv_meaning_al2
                                            , NVL( r1.rv_meaning
                                                 , r1.rv_meaning_al1))
                                  )
             INTO D_settore
             FROM PGM_REF_CODES r1
            WHERE r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'SETTORE'
           ;
	   EXCEPTION
	        WHEN NO_DATA_FOUND THEN
		       D_settore:='presso il settore';
	   END;
	   BEGIN
           SELECT comu.descrizione||', '||Di_li||' '||
                  TO_CHAR(D_riferimento,'dd/mm/yyyy')
             INTO D_data
             FROM GESTIONI                              gest,
                  comuni                                comu
            WHERE gest.comune_res    = comu.cod_comune
              AND gest.provincia_res = comu.cod_provincia
              AND gest.codice        =
                 (SELECT MAX(p.gestione)
                    FROM PERIODI_GIURIDICI p
                   WHERE p.ci IN (SELECT ci FROM RAPPORTI_INDIVIDUALI
                                   WHERE ni = D_ni)
                     AND p.rilevanza = 'Q'
                     AND p.dal =
                        (SELECT MAX(dal)
                           FROM PERIODI_GIURIDICI
                          WHERE ci = p.ci
                            AND rilevanza = 'Q'
                            AND NVL(dal,TO_DATE('3333333','j')) < D_riferimento))
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    BEGIN
		     SELECT comu.descrizione||', '||Di_li||' '||
                  TO_CHAR(D_riferimento,'dd/mm/yyyy')
                   INTO D_data
                   FROM ENTE
                      , comuni  comu
                  WHERE ENTE.comune_res    = comu.cod_comune
                    AND ENTE.provincia_res = comu.cod_provincia;
		     EXCEPTION
			  WHEN NO_DATA_FOUND THEN D_DATA:=NULL;
		     END;
	   END;
		  IF D_st_data = 'SI' OR  D_st_data = 'X' THEN
              D_riga := 20;
/* Inserimento DATA con riga fissa, precedente a quella dell'oggetto
   Se il parametro e SI o X allora stampero la data */
              INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,lung_riga,testo)
              VALUES ( prenotazione
                     , D_riga
                     , 75
                     , ' '
                     )
              ;
              D_riga := D_riga + 1;
              INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,lung_riga,testo)
              VALUES ( prenotazione
                     , D_riga
                     , 78
                     , LPAD(D_data,78,' ')
                     )
              ;
		  IF D_st_data = 'X' THEN
/* se sono entrato nell'IF con X voglio stampare anche la nota */
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,lung_riga,testo)
                VALUES ( prenotazione
                       , D_riga
                       , 78
                       , LPAD('Data termine conteggio periodi di servizio',78,' ')
                       )
                ;
		  ELSE
/* altrimenti sono entrato nell'IF per SI e quindi non voglio la nota */
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,lung_riga,testo)
                VALUES ( prenotazione
                       , D_riga
                       , 75
                       , ' '
                       )
                ;
		  END IF;
              D_riga := D_riga + 1;
              INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,lung_riga,testo)
              VALUES ( prenotazione
                     , D_riga
                     , 75
                     , ' '
                     )
              ;
		END IF;
           D_riga := 40;
/* Inserimento prima riga anagrafica */
           INSERT INTO APPOGGIO_CERTIFICATI
                   (prenotazione,progressivo,lung_riga,testo)
           VALUES ( prenotazione
                  , D_riga
                  , 75
                  , D_testo
                  )
           ;
           D_riga := D_riga + 1;
           INSERT INTO APPOGGIO_CERTIFICATI
                   (prenotazione,progressivo,lung_riga,testo)
           VALUES ( prenotazione
                  , D_riga
                  , 75
                  , D_testo1
                  )
           ;
           END;
           BEGIN
/* Estrazione formula dipendenti in SERVIZIO */
        --   D_riga := 50;
         SELECT nvl(ceil(max(progressivo/10))*10,50)
             INTO D_riga
             FROM appoggio_certificati
            WHERE prenotazione = DEP_prenotazione
              AND progressivo >= 50
           ;
           FOR CUR_SER IN
              (SELECT testo
                 FROM TESTI_FORMULA
                WHERE gruppo_ling = CUR_SIN.SIN
                  AND formula     = D_cod_ser
                  AND EXISTS
                     (SELECT 'x'
                        FROM PERIODI_GIURIDICI pegi
                       WHERE pegi.ci IN
                           (SELECT ci
                              FROM RAPPORTI_INDIVIDUALI rain
                             WHERE rain.ni = D_ni
                           )
                        AND pegi.rilevanza = 'P'
                        AND pegi.dal        =
                           (SELECT MAX(pegi1.dal)
                              FROM PERIODI_GIURIDICI pegi1
                             WHERE pegi1.ci = pegi.ci
                               AND pegi1.rilevanza = pegi.rilevanza
                               AND pegi1.dal <= D_riferimento)
                        AND NVL(pegi.al,TO_DATE('3333333','j'))>= D_riferimento
					 UNION
					 SELECT 'x'
                        FROM PERIODI_GIURIDICI pegi
                       WHERE pegi.ci IN
                           (SELECT ci
                              FROM RAPPORTI_INDIVIDUALI rain
                             WHERE rain.ni = D_ni
                           )
                        AND pegi.rilevanza = 'Q'
                        AND pegi.dal        =
                           (SELECT MAX(pegi1.dal)
                              FROM PERIODI_GIURIDICI pegi1
                             WHERE pegi1.ci = pegi.ci
                               AND pegi1.rilevanza = pegi.rilevanza
                               AND pegi1.dal <= D_riferimento)
                        AND NVL(pegi.al,TO_DATE('3333333','j'))>= D_riferimento
						AND NOT EXISTS (SELECT 'x' FROM PERIODI_GIURIDICI
						                 WHERE ci = pegi.ci
										   AND rilevanza = 'P'
										   AND dal <= NVL(pegi.al,TO_DATE('3333333','j'))
										   AND NVL(al,TO_DATE('3333333','j')) >= pegi.dal)
					 )
                ORDER BY sequenza
              ) LOOP
                BEGIN
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,lung_riga,testo)
                VALUES ( prenotazione
                       , D_riga
                       , 75
                       , CUR_SER.testo
                       )
                ;
                D_riga := D_riga + 1;
                END;
              END LOOP; -- CUR_SER
           END;
          BEGIN
/* Estrazione formula dipendenti CESSATI */
           SELECT nvl(ceil(max(progressivo/10))*10,60)
             INTO D_riga
             FROM appoggio_certificati
            WHERE prenotazione = DEP_prenotazione
             AND progressivo >= 50
           ;
           FOR CUR_DIM IN
              (SELECT testo
                 FROM TESTI_FORMULA
                WHERE gruppo_ling = CUR_SIN.SIN
                  AND formula     = D_cod_dim
                  AND NOT EXISTS
                     (SELECT 'x'
                        FROM PERIODI_GIURIDICI pegi
                       WHERE pegi.ci IN
                           (SELECT ci
                              FROM RAPPORTI_INDIVIDUALI rain
                             WHERE rain.ni = D_ni
                           )
                        AND pegi.rilevanza = 'P'
                        AND pegi.dal        =
                           (SELECT MAX(pegi1.dal)
                              FROM PERIODI_GIURIDICI pegi1
                             WHERE pegi1.ci = pegi.ci
                               AND pegi1.rilevanza = pegi.rilevanza
                               AND pegi1.dal <= D_riferimento)
                        AND NVL(pegi.al,TO_DATE('3333333','j'))>= D_riferimento
					 UNION
					 SELECT 'x'
                        FROM PERIODI_GIURIDICI pegi
                       WHERE pegi.ci IN
                           (SELECT ci
                              FROM RAPPORTI_INDIVIDUALI rain
                             WHERE rain.ni = D_ni
                           )
                        AND pegi.rilevanza = 'Q'
                        AND pegi.dal        =
                           (SELECT MAX(pegi1.dal)
                              FROM PERIODI_GIURIDICI pegi1
                             WHERE pegi1.ci = pegi.ci
                               AND pegi1.rilevanza = pegi.rilevanza
                               AND pegi1.dal <= D_riferimento)
                        AND NVL(pegi.al,TO_DATE('3333333','j'))>= D_riferimento
						AND NOT EXISTS (SELECT 'x' FROM PERIODI_GIURIDICI
						                 WHERE ci = pegi.ci
										   AND rilevanza = 'P'
										   AND dal <= NVL(pegi.al,TO_DATE('3333333','j'))
										   AND NVL(al,TO_DATE('3333333','j')) >= pegi.dal)
					 )
               ORDER BY sequenza
              ) LOOP
                BEGIN
                INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,lung_riga,testo)
                VALUES ( prenotazione
                       , D_riga
                       , 75
                       , CUR_DIM.testo
                       )
                ;
                D_riga := D_riga + 1;
                END;
                END LOOP; -- CUR_DIM
           END;
           BEGIN
/* Estrazione vocaboli fissi dai ref_codes per eventuali traduzioni */
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1,NVL( r1.rv_meaning
                                  , NVL( r1.rv_meaning_al1
                                       , r1.rv_meaning_al2))
                        , D_l2,NVL( r1.rv_meaning_al1
                                  , NVL( r1.rv_meaning
                                       , r1.rv_meaning_al2))
                        , D_l3,NVL( r1.rv_meaning_al2
                                  , NVL( r1.rv_meaning
                                       , r1.rv_meaning_al1))
                        )
             INTO Di_li
             FROM PGM_REF_CODES r1
            WHERE r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'LI'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    Di_li:='li';
	   END;
         BEGIN
           SELECT DECODE( Df_decorrenza
                        , 'SI', DECODE( CUR_SIN.SIN
                                      , D_l1,NVL( r1.rv_meaning
                                                , NVL( r1.rv_meaning_al1
                                                     , r1.rv_meaning_al2))
                                      , D_l2,NVL( r1.rv_meaning_al1
                                                , NVL( r1.rv_meaning
                                                     , r1.rv_meaning_al2))
                                      , D_l3,NVL( r1.rv_meaning_al2
                                                , NVL( r1.rv_meaning
                                                     , r1.rv_meaning_al1))
                                      )
                              , LPAD(' ',5,' ')
                        )
             INTO Di_il
             FROM PGM_REF_CODES r1
            WHERE r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'IL'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    Di_il:='il';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1,NVL( r1.rv_meaning
                                  , NVL( r1.rv_meaning_al1
                                       , r1.rv_meaning_al2))
                        , D_l2,NVL( r1.rv_meaning_al1
                                  , NVL( r1.rv_meaning
                                       , r1.rv_meaning_al2))
                        , D_l3,NVL( r1.rv_meaning_al2
                                  , NVL( r1.rv_meaning
                                       , r1.rv_meaning_al1))
                        )
             INTO Di_dal
             FROM PGM_REF_CODES r1
            WHERE r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'DAL'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    Di_dal:='dal';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1,NVL( r1.rv_meaning
                                  , NVL( r1.rv_meaning_al1
                                       , r1.rv_meaning_al2))
                        , D_l2,NVL( r1.rv_meaning_al1
                                 , NVL( r1.rv_meaning
                                      , r1.rv_meaning_al2))
                        , D_l3,NVL( r1.rv_meaning_al2
                                  , NVL( r1.rv_meaning
                                       , r1.rv_meaning_al1))
                        )
             INTO Di_al
             FROM PGM_REF_CODES r1
            WHERE r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'AL'
           ;
		   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    Di_al:='al';
	   END;
           INSERT INTO APPOGGIO_CERTIFICATI
                 (prenotazione,progressivo,lung_riga,testo)
           SELECT prenotazione
                , D_riga
                , 75
                , '   '||RPAD(Di_il,5,' ')||LPAD(' ',54,' ')||
                  RPAD(Di_dal,5,' ')||LPAD(' ',6,' ')||
                  RPAD(Di_al,5,' ')
             FROM dual
            WHERE Df_decorrenza IN ('SI','NO')
           ;
           D_riga := D_riga + 1;
           INSERT INTO APPOGGIO_CERTIFICATI
                 (prenotazione,progressivo,lung_riga,testo)
           SELECT prenotazione
                , D_riga
                , 75
                , RPAD(' ',75,' ')
             FROM dual
            WHERE Df_decorrenza IN ('SI','NO')
           ;
	 END;
       <<ESTRAZIONE_VOCABOLO>>
       BEGIN
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_presta
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'PRESTA'
           ;
	   EXCEPTION
              WHEN NO_DATA_FOUND THEN
		       D_presta:='e presta la propria attivita';
         END;
         BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1,NVL( r1.rv_meaning
                                  , NVL( r1.rv_meaning_al1
                                       , r1.rv_meaning_al2))
                        , D_l2,NVL( r1.rv_meaning_al1
                                 , NVL( r1.rv_meaning
                                      , r1.rv_meaning_al2))
                        , D_l3,NVL( r1.rv_meaning_al2
                                  , NVL( r1.rv_meaning
                                       , r1.rv_meaning_al1))
                        )
             INTO D_ore_cont
             FROM PGM_REF_CODES r1
            WHERE r1.rv_domain    = 'VOCABOLO'
              AND r1.rv_low_value = 'ORE_CONT'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_ore_cont:='su ore contrattuali ';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_tempo_det
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'TEMPO_DET'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
                    D_tempo_det:='a tempo determinato';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_tempo_indet
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'TEMPO_INDET'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_tempo_indet:='a tempo indeterminato';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_part_time
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'PART_TIME'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_part_time:='a tempo parziale';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_tempo_pieno
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'TEMPO_PIENO'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_tempo_pieno:='a tempo pieno';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_tempo_ridotto
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'TEMPO_RIDOTTO'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_tempo_ridotto:='tempo ridotto';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_prestato
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'PRESTATO'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_prestato:='e ha prestato la propria attivita';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_decorre
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'DECORRE'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_decorre:='a decorrere dal';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_fino_a
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'FINO_A'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_fino_a:='fino al';
         END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_in_qualita
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'IN_QUALITA'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_in_qualita:='in qualita di';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_qualita
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'QUALITA'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_qualita:='in qualita di';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_qualifica
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'QUALIFICA'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_qualifica:='con qualifica';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_cessazione
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'CESSAZIONE'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_cessazione:='Cessazione dal Servizio per';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_in_data
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'IN_DATA'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_in_data:='in data';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_con
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'CON'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_con:='con';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_presso
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'PRESSO'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_presso:= 'presso';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_ser_r
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'SER_R'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_ser_r:='Servizio di ruolo per';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_ser_nr
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'SER_NR'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_ser_nr:='Servizio non di ruolo per';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_a
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'A'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_a:='a';
	   END;
	   BEGIN
		   SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_tp
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'TP'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_tp:='Tempo Pieno';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_td
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'TD'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_td:='Tempo Definito';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_em
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'EM'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_em:='con libera professione extra-muraria';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_ore
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'ORE'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_ore:='ore';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                              )
             INTO D_l_ruolo
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'L_RUOLO'
           ;
	   EXCEPTION
              WHEN NO_DATA_FOUND THEN
		    D_l_ruolo:='Ruolo: ....: ';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_l_profilo
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'L_PROFILO'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_l_profilo:='Profilo ..: ';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_l_pos_fun
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'L_POS_FUN'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_l_pos_fun:='Posizione : ';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                              )
             INTO D_l_figura
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'L_FIGURA'
           ;
	   EXCEPTION
              WHEN NO_DATA_FOUND THEN
		    D_l_figura:='Figura: ...: ';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_numero
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'NUMERO'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_numero:='N.';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_del
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'DEL'
           ;
	   EXCEPTION
		    WHEN NO_DATA_FOUND THEN
			 D_del:='del';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_esecutiva
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'ESECUTIVITA'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_esecutiva:='Esecutivita ';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_oggi
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'OGGI'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_oggi:='Tutt''oggi';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_assenza
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'ASSENZA'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_assenza:='Assenze dal Servizio';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_sottolinea
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'SOTTOLINEA'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_sottolinea:=null;
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO D_contestual
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'CONTESTUALMENTE'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    D_contestual:='E contestualmente';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO Di_anni
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'ANNI'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
		    Di_anni:='anni';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO Di_mesi
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'MESI'
           ;
	   EXCEPTION
		   WHEN NO_DATA_FOUND THEN
                    Di_mesi:='mesi';
	   END;
	   BEGIN
           SELECT DECODE( CUR_SIN.SIN
                        , D_l1, NVL( rv_meaning
                                   , NVL( rv_meaning_al1
                                        , rv_meaning_al2))
                        , D_l2, NVL( rv_meaning_al1
                                   , NVL( rv_meaning
                                        , rv_meaning_al2))
                        , D_l3, NVL( rv_meaning_al2
                                   , NVL( rv_meaning
                                        , rv_meaning_al1))
                        )
             INTO Di_giorni
             FROM PGM_REF_CODES
            WHERE rv_domain    = 'VOCABOLO'
              AND rv_low_value = 'GIORNI'
           ;
	   EXCEPTION
              WHEN NO_DATA_FOUND THEN
		    Di_giorni:='giorni';
	   END;
         END ESTRAZIONE_VOCABOLI;
         BEGIN
/*Estrazione periodi giuridici */
           SELECT nvl(ceil(max(progressivo/10))*10,1070)
             INTO D_riga
             FROM appoggio_certificati
            WHERE prenotazione = DEP_prenotazione
              AND progressivo >= 50
           ;
         Dep_presso := NULL;
 FOR CUR_PEGI IN CURSORE_CERTIFICATO.CUR_PERIODI
                ( Df_decorrenza, Df_note_ind, Df_servizio, Df_ruolo, Df_attivita, Df_delibera
                , Df_esecutivita, Df_durata, Df_cessazione, Df_assenze, Df_economico
                , Df_tempo_determinato,Df_part_time
                , D_del, D_numero, D_esecutiva, D_ni, D_prestato, D_presta
                , D_qualita, D_con, D_presso, D_contestual, D_ser_r, D_ser_nr
                , D_a, D_tp, D_td, D_em, D_ore, D_in_qualita
                , D_l_ruolo, D_l_profilo, D_l_pos_fun, D_l_figura, P_tipo_rapporto, D_qualifica
                , D_cessazione, D_data_cessaz, D_in_data, D_assenza, D_sottolinea
                , D_decorre, D_fino_a,D_riferimento,D_per_ni,D_ci,D_tempo_det
                , D_tempo_indet,D_part_time,D_tempo_pieno,D_tempo_ridotto,D_settore,D_ore_cont
                , Df_u_presso
                ) LOOP
 Dep_ci     := CUR_PEGI.ci;
 D_des_qualifica := null;
 D_ore_contratto := null;
/*
 IF instr(cur_pegi.pegi_testo,' ore') !=0 then
  BEGIN
   select CONS.ore_lavoro
     into d_ore_contratto
     from qualifiche_giuridiche QUGI
        , periodi_giuridici     PEGI_S
        , contratti_storici     CONS
    where PEGI_S.ci        = cur_pegi.ci
      and PEGI_S.rilevanza = 'S'
      and nvl(CUR_PEGI.al,D_riferimento)
          between PEGI_S.dal and nvl(PEGI_S.al,to_date('3333333','j'))
      and QUGI.numero      = PEGI_S.qualifica
      and CONS.contratto   = QUGI.contratto
      and nvl(PEGI_S.al,to_date('3333333','j'))
          between nvl(CONS.dal,to_date('2222222','j')) and nvl(CONS.al,to_date('3333333','j'))
      and nvl(PEGI_S.al,d_riferimento)
          between nvl(QUGI.dal,to_date('2222222','j')) and nvl(QUGI.al,to_date('3333333','j'));
   EXCEPTION
     WHEN OTHERS THEN
          D_ore_contratto:=null;
   END;
  END IF;
*/
  BEGIN
    D_des_qualifica := null;
    IF Df_qualifica='SI' then
-- dbms_output.put_line(to_char(cur_pegi.ci)||' - rif. '||to_char(D_riferimento,'dd/mm/yyyy')||' - '||to_char(cur_pegi.dal,'dd/mm/yyyy')||' - '||to_char(cur_pegi.al,'dd/mm/yyyy'));
       begin
         select pegi_se.qugi_note
           into D_des_qualifica
           from pegi_se
          where pegi_se.ci = CUR_PEGI.ci
            and nvl(cur_pegi.al,D_riferimento)
                between pegi_se.dal and nvl(pegi_se.al,D_riferimento)
         ;
         EXCEPTION
              WHEN no_data_found THEN
                   D_des_qualifica := NULL;
              WHEN too_many_rows THEN
                   BEGIN
                     select pegi_se.qugi_note
                       into D_des_qualifica
                       from pegi_se
                      where pegi_se.ci = CUR_PEGI.ci
                        and nvl(cur_pegi.al,D_riferimento)
                                   between pegi_se.dal
                               and nvl(pegi_se.al,D_riferimento)
                        and rilevanza = decode(CUR_PEGI.rilevanza,'Q','S','S','S','E');
                   EXCEPTION
                        WHEN no_data_found THEN
                             BEGIN
                               select pegi_se.qugi_note
                                 into D_des_qualifica
                                 from pegi_se
                                where pegi_se.ci = CUR_PEGI.ci
                                  and nvl(cur_pegi.al,D_riferimento)
                                      between pegi_se.dal and nvl(pegi_se.al,D_riferimento)
                                  and rilevanza=decode(CUR_PEGI.rilevanza,'I','S','E');
                             EXCEPTION
                                  WHEN no_data_found THEN d_des_qualifica :=null;
                                  WHEN others THEN D_des_qualifica := null;
                             END;
                        WHEN others THEN D_des_qualifica :=  null;
                   END;
              WHEN others THEN D_des_qualifica := NULL;
         END;
    END IF;
  END;
-- dbms_output.put_line('descr. '||D_des_qualifica);
--
-- UNIFICA PERIODI
--
  D_conta    := D_conta + 1;
--  dbms_output.put_line('CONTA '||to_char(d_conta)||'cur_pegi.rilevanza '||cur_pegi.rilevanza);
  IF D_conta = 1
/* Se primo recod memorizza i dati da confrontare con i record successivi */
     THEN
--     IF   instr(cur_pegi.pegi_testo,' ore') =0  then
          Dep_testo      := CUR_PEGI.pegi_testo;
          Dep_if_testo   := CUR_PEGI.if_testo;
/*     ELSE
          IF d_ore_contratto is not null THEN
          Dep_testo      :=substr(CUR_PEGI.pegi_testo,1,instr (CUR_PEGI.pegi_testo,' ore')+4)
                           ||D_ore_cont||D_ore_contratto
                           ||substr(CUR_PEGI.pegi_testo,instr (CUR_PEGI.pegi_testo,' ore')+4) ;
          Dep_if_testo   :=substr(CUR_PEGI.if_testo,1,instr (CUR_PEGI.if_testo,' ore')+4)
                           ||D_ore_cont||D_ore_contratto
                           ||substr(CUR_PEGI.if_testo,instr (CUR_PEGI.if_testo,' ore')+4) ;
          ELSE
          Dep_testo      := CUR_PEGI.pegi_testo;
          Dep_if_testo   := CUR_PEGI.if_testo;
          END IF;
     END IF;
*/
          Dep_ruolo            := CUR_PEGI.pegi_ruolo;
          Dep_profilo          := CUR_PEGI.pegi_profilo;
          Dep_pos_fun          := CUR_PEGI.pegi_pos_fun;
          Dep_figura           := CUR_PEGI.pegi_figura;
          Dep_figi_note        := CUR_PEGI.figi_note;
          Dep_delibera         := CUR_PEGI.pegi_delibera;
          Dep_esecutiva        := CUR_PEGI.pegi_esecutiva;
          Dep_note             := CUR_PEGI.pegi_note;
          Dep_tira_note        := CUR_PEGI.tira_note;
          D_tira_note          := CUR_pegi.tira_note;
          Dep_rilevanza        := CUR_PEGI.rilevanza;
          Dep_decorrenza       := CUR_PEGI.pegi_deco;
          Dep_dal              := CUR_PEGI.dal;
          Dep_al               := CUR_PEGI.al;
          Dep_gg               := CUR_PEGI.pegi_gg;
          Dep_presso           := CUR_PEGI.presso;
          Dep_tira_descrizione := CUR_PEGI.tira_descrizione;
          Dep_des_qualifica    := D_des_qualifica;
          Dep_t_presso         := CUR_PEGI.t_presso;
          Dep_t_settore        := CUR_PEGI.t_settore;
	IF NVL(dep_al,TO_DATE('3333333','j')) >= D_riferimento and dep_rilevanza != 'P'
         THEN dep_al := null;
      END IF;
/* Dal secondo record in poi confronta i dati correnti con quelli del record precedente */
--dbms_output.put_line('Dep testo: '||dep_testo);
--dbms_output.put_line('Dep if testo: '||dep_if_testo);
--dbms_output.put_line('IF testo: '||cur_pegi.if_testo);
--dbms_output.put_line('pegi testo: '||cur_pegi.pegi_testo);
    ELSE
--dbms_output.put_line('Dep testo: '||dep_testo);
--dbms_output.put_line('Dep if testo: '||dep_if_testo);
--dbms_output.put_line('IF testo: '||cur_pegi.if_testo);
--dbms_output.put_line('gg. '||DEP_gg);
IF Dep_if_testo                  = CUR_PEGI.if_testo                AND
          NVL(Dep_ruolo,' ')         = NVL(CUR_PEGI.pegi_ruolo,' ')     AND
          NVL(Dep_profilo,' ')       = NVL(CUR_PEGI.pegi_profilo,' ')   AND
          NVL(Dep_pos_fun,' ')       = NVL(CUR_PEGI.pegi_pos_fun,' ')   AND
          NVL(Dep_figura    ,' ')    = NVL(CUR_PEGI.pegi_figura  ,' ')  AND
          NVL(Dep_delibera,' ')      = NVL(CUR_PEGI.pegi_delibera,' ')  AND
      (   Df_note_ind != 'SI'
       OR (    Df_note_ind = 'SI'
           AND NVL(Dep_note,' ')          = NVL(CUR_PEGI.pegi_note,' ')
          )
      )                                                                   AND
          NVL(Dep_tira_note,' ')     = NVL(CUR_PEGI.tira_note,' ')        AND
          NVL(Dep_des_qualifica,' ') = NVL(D_des_qualifica,' ')           AND
          NVL(Dep_t_presso,' ')      = NVL(CUR_PEGI.t_presso,' ')         AND
          NVL(Dep_t_settore,' ')     = NVL(CUR_PEGI.t_settore,' ')
          THEN
               IF CUR_PEGI.dal = Dep_al + 1
/* Se dati uguali e date consecutive unifica il periodo */
                THEN Dep_al   := CUR_PEGI.al;
		      IF NVL(dep_al,TO_DATE('3333333','j'))>= D_riferimento and dep_rilevanza!='P' then
		         dep_al := null;
  		      END IF;
                  IF Df_note_ind = 'SU' and CUR_PEGI.pegi_note is not null THEN
                     Dep_note := Dep_note||' '||nvl(CUR_PEGI.pegi_note,' ');
                  END IF;
                  Dep_gg   := Dep_gg + CUR_PEGI.pegi_gg;
                ELSE
/* Se dati uguali, ma date non consecutive, inserisce primo record e memorizza dati record corrente */
     BEGIN
       SELECT decode( Dep_testo
                      || decode(nvl(Dep_presso,'NO'),'NO',null,' '||D_presso||' '||Dep_t_presso)
                      || Dep_t_settore
                    , null, null
                          , Dep_testo
                            || decode(nvl(Dep_presso,'NO'),'NO',null,' '||D_presso||' '||Dep_t_presso)
                            || Dep_t_settore||' ')
              ||D_qualita
         into I_testo
         from dual
        where Df_decorrenza not in ('AS','DD')
          and Dep_rilevanza in ('Q','I','S','E');
     EXCEPTION
       WHEN NO_DATA_FOUND THEN I_testo := Dep_testo;
     END;
INSERT_SERVIZI (PRENOTAZIONE,D_riga,Dep_rilevanza,CUR_PEGI.rilevanza,CUR_PEGI.ci,Df_decorrenza,Dep_decorrenza
               ,Dep_dal,Dep_al,I_testo,Dep_ruolo,Dep_profilo,Dep_pos_fun,Dep_figura,Dep_figi_note,Dep_tira_descrizione
               ,Dep_tira_note,Dep_delibera,Dep_esecutiva,Dep_des_qualifica,Dep_note,Df_durata,Dep_gg,Di_anni,Di_mesi
               ,Di_giorni);
                   D_riga := D_riga + 1;
--                   if   instr(cur_pegi.pegi_testo,' ore') =0 then
                        Dep_testo      := CUR_PEGI.pegi_testo;
                        Dep_if_testo   := CUR_PEGI.if_testo;
/*                   else
                       IF d_ore_contratto is not null THEN
                          Dep_testo      :=substr(CUR_PEGI.pegi_testo,1,instr (CUR_PEGI.pegi_testo,' ore')+4)
                                          ||D_ore_cont||D_ore_contratto
                                          ||substr(CUR_PEGI.pegi_testo,instr (CUR_PEGI.pegi_testo,' ore')+4) ;
                          Dep_if_testo  :=substr(CUR_PEGI.if_testo,1,instr (CUR_PEGI.if_testo,' ore')+4)
                                          ||D_ore_cont||D_ore_contratto
                                          ||substr(CUR_PEGI.if_testo,instr (CUR_PEGI.if_testo,' ore')+4) ;
                       ELSE
                       Dep_testo      := CUR_PEGI.pegi_testo;
                       Dep_if_testo   := CUR_PEGI.if_testo;
                       END IF;
                   end if;
*/
                   Dep_ruolo            := CUR_PEGI.pegi_ruolo;
                   Dep_profilo          := CUR_PEGI.pegi_profilo;
                   Dep_pos_fun          := CUR_PEGI.pegi_pos_fun;
                   Dep_figura           := CUR_PEGI.pegi_figura;
                   Dep_figi_note        := CUR_PEGI.figi_note;
                   Dep_delibera         := CUR_PEGI.pegi_delibera;
                   Dep_esecutiva        := CUR_PEGI.pegi_esecutiva;
                   Dep_note             := CUR_PEGI.pegi_note     ;
                   Dep_rilevanza        := CUR_PEGI.rilevanza;
                   Dep_decorrenza       := CUR_PEGI.pegi_deco;
                   Dep_dal              := CUR_PEGI.dal;
                   Dep_al               := CUR_PEGI.al;
                   Dep_gg               := CUR_PEGI.pegi_gg;
                   Dep_presso           := CUR_PEGI.presso;
                   Dep_tira_note        := CUR_PEGI.tira_note;
                   Dep_tira_descrizione := CUR_PEGI.tira_descrizione;
                   Dep_des_qualifica    := D_des_qualifica;
                   Dep_t_presso         := CUR_PEGI.t_presso;
                   Dep_t_settore        := CUR_PEGI.t_settore;
                   IF NVL(dep_al,TO_DATE('3333333','j')) >= D_riferimento and dep_rilevanza != 'P'
                      THEN dep_al := null;
                   END IF;
            END IF;
          ELSE
          /* Se dati diversi, inserisce primo record e memorizza dati record corrente */
     BEGIN
       SELECT decode( Dep_testo
                      || decode(nvl(Dep_presso,'NO'),'NO',null,' '||D_presso||' '||Dep_t_presso)
                      || Dep_t_settore
                    , null, null
                          , Dep_testo
                            || decode(nvl(Dep_presso,'NO'),'NO',null,' '||D_presso||' '||Dep_t_presso)
                            || Dep_t_settore||' ')
              ||D_qualita
         into I_testo
         from dual
         where Df_decorrenza not in ('AS','DD')
           and Dep_rilevanza in ('Q','I','S','E');
     EXCEPTION
       WHEN NO_DATA_FOUND THEN I_testo := Dep_testo;
     END;
INSERT_SERVIZI (PRENOTAZIONE,D_riga,Dep_rilevanza,CUR_PEGI.rilevanza,CUR_PEGI.ci,Df_decorrenza,Dep_decorrenza
               ,Dep_dal,Dep_al,I_testo,Dep_ruolo,Dep_profilo,Dep_pos_fun,Dep_figura,Dep_figi_note,Dep_tira_descrizione
               ,Dep_tira_note,Dep_delibera,Dep_esecutiva,Dep_des_qualifica,Dep_note,Df_durata,Dep_gg,Di_anni,Di_mesi
               ,Di_giorni);
         D_riga := D_riga + 1;
--            if   instr(cur_pegi.pegi_testo,' ore') =0  then
                 Dep_testo      := CUR_PEGI.pegi_testo;
                 Dep_if_testo   := CUR_PEGI.if_testo;
/*            else
                IF d_ore_contratto is not null THEN
                   Dep_testo    :=substr(CUR_PEGI.pegi_testo,1,instr (CUR_PEGI.pegi_testo,' ore')+4)
                                  ||D_ore_cont||D_ore_contratto
                                  ||substr(CUR_PEGI.pegi_testo,instr (CUR_PEGI.pegi_testo,' ore')+4) ;
                   Dep_if_testo :=substr(CUR_PEGI.if_testo,1,instr (CUR_PEGI.if_testo,' ore')+4)
                                  ||D_ore_cont||D_ore_contratto
                                  ||substr(CUR_PEGI.if_testo,instr (CUR_PEGI.if_testo,' ore')+4) ;
                ELSE
                Dep_testo      := CUR_PEGI.pegi_testo;
                Dep_if_testo   := CUR_PEGI.if_testo;
                END IF;
            end if;
*/
            Dep_ruolo            := CUR_PEGI.pegi_ruolo;
            Dep_profilo          := CUR_PEGI.pegi_profilo;
            Dep_pos_fun          := CUR_PEGI.pegi_pos_fun;
            Dep_figura           := CUR_PEGI.pegi_figura;
            Dep_figi_note        := CUR_PEGI.figi_note;
            Dep_delibera         := CUR_PEGI.pegi_delibera;
            Dep_esecutiva        := CUR_PEGI.pegi_esecutiva;
            Dep_note             := CUR_PEGI.pegi_note     ;
            Dep_rilevanza        := CUR_PEGI.rilevanza;
            Dep_decorrenza       := CUR_PEGI.pegi_deco;
            Dep_dal              := CUR_PEGI.dal;
            Dep_al               := CUR_PEGI.al;
            Dep_gg               := CUR_PEGI.pegi_gg;
            Dep_presso           := CUR_PEGI.presso;
            Dep_tira_note        := CUR_PEGI.tira_note;
            Dep_tira_descrizione := CUR_PEGI.tira_descrizione;
            Dep_des_qualifica    := D_des_qualifica;
            Dep_t_presso         := CUR_PEGI.t_presso;
            Dep_t_settore        := CUR_PEGI.t_settore;
		if NVL(dep_al,TO_DATE('3333333','j'))>= D_riferimento and dep_rilevanza!='P' then
		   dep_al := null;
  		end if;
	   END IF;
end IF;
         D_riga := D_riga + 1;
     END LOOP; -- CUR_PEGI
     D_conta := 0;
     BEGIN
       SELECT decode( Dep_testo
                      || decode(nvl(Dep_presso,'NO'),'NO',null,' '||D_presso||' '||Dep_t_presso)
                      || Dep_t_settore
                    , null, null
                          , Dep_testo
                            || decode(nvl(Dep_presso,'NO'),'NO',null,' '||D_presso||' '||Dep_t_presso)
                            || Dep_t_settore||' ')
              ||D_qualita
         into I_testo
         from dual
        where Df_decorrenza not in ('AS','DD')
          and Dep_rilevanza in ('Q','I','S','E');
     EXCEPTION
       WHEN NO_DATA_FOUND THEN I_testo := Dep_testo;
     END;
INSERT_SERVIZI (PRENOTAZIONE,D_riga,Dep_rilevanza,Dep_rilevanza,Dep_ci,Df_decorrenza,Dep_decorrenza
               ,Dep_dal,Dep_al,I_testo,Dep_ruolo,Dep_profilo,Dep_pos_fun,Dep_figura,Dep_figi_note,Dep_tira_descrizione
               ,Dep_tira_note,Dep_delibera,Dep_esecutiva,Dep_des_qualifica,Dep_note,Df_durata,Dep_gg,Di_anni,Di_mesi
               ,Di_giorni);
--
-- FINE INSERIMENTO PERIODI UNIFICATI
--
BEGIN
  SELECT least(nvl(max(nvl(al,D_riferimento)),D_riferimento),D_riferimento)
    INTO D_rif_eco
    FROM PERIODI_GIURIDICI
   WHERE ci  = D_ci
     AND rilevanza IN ('P','Q')
     AND dal       <= D_riferimento
  ;
END;
BEGIN
  SELECT PEGI_S.ORE
       , CNST.ORE_LAVORO
       , decode( figi.cert_qua
               , 'SI', DECODE( CUR_SIN.SIN
                             , D_l1,NVL( r1.rv_meaning, NVL( r1.rv_meaning_al1, r1.rv_meaning_al2))
                             , D_l2,NVL( r1.rv_meaning_al1, NVL( r1.rv_meaning, r1.rv_meaning_al2))
                             , D_l3,NVL( r1.rv_meaning_al2, NVL( r1.rv_meaning, r1.rv_meaning_al1))
                     , null))||
         decode( figi.cert_qua
               , 'SI',' '||qugi.descrizione,null)
    INTO D_ore_ind,D_ore_lavoro,D_con_qual
    FROM FIGURE_GIURIDICHE             figi
       , QUALIFICHE_GIURIDICHE         qugi
       , PGM_REF_CODES                 r1
  	   , PERIODI_GIURIDICI             pegi_s
       , CONTRATTI_STORICI             cnst
   WHERE PEGI_S.CI          = D_ci
     AND PEGI_S.RILEVANZA   = 'S'
  	 AND D_rif_eco
         BETWEEN PEGI_S.dal AND NVL(PEGI_S.al,D_riferimento)
--     AND figi.cert_qua      = 'SI'
     AND FIGI.NUMERO        = PEGI_S.FIGURA
     AND QUGI.NUMERO        = PEGI_S.QUALIFICA
     AND CNST.CONTRATTO     = QUGI.CONTRATTO
     AND NVL(pegi_s.al,TO_DATE('3333333','j'))
         BETWEEN NVL(CNST.dal,TO_DATE('2222222','j'))
             AND NVL(CNST.al,TO_DATE('3333333','j'))
     AND NVL(pegi_s.al,D_riferimento)
         BETWEEN NVL(qugi.dal,TO_DATE('2222222','j'))
             AND NVL(qugi.al,TO_DATE('3333333','j'))
     AND NVL(pegi_s.al,D_riferimento)
         BETWEEN NVL(figi.dal,TO_DATE('2222222','j'))
             AND NVL(figi.al,TO_DATE('3333333','j'))
     AND r1.rv_domain    = 'VOCABOLO'
     AND r1.rv_low_value = 'CON_QUAL'
  ;
EXCEPTION WHEN NO_DATA_FOUND THEN
               D_ore_ind      := NULL;
					     D_con_qual     := NULL;
               D_ore_lavoro   := NULL;
END;
/* Certificato Economico */
BEGIN
  IF Df_economico = 'SI' AND D_ente_econ = 'SI'
     THEN
     D_riga := 8000;
     <<CERT_ECONOMICO>>
     BEGIN
       SELECT DECODE( CUR_SIN.SIN
                    , D_l1,NVL( r1.rv_meaning
                              , NVL( r1.rv_meaning_al1
                                   , r1.rv_meaning_al2))
                    , D_l2,NVL( r1.rv_meaning_al1
                              , NVL( r1.rv_meaning
                                   , r1.rv_meaning_al2))
                    , D_l3,NVL( r1.rv_meaning_al2
                              , NVL( r1.rv_meaning
                                   , r1.rv_meaning_al1))
                    )
          INTO D_matura
          FROM PGM_REF_CODES r1
         WHERE r1.rv_domain    = 'VOCABOLO'
           AND r1.rv_low_value = 'MATURA'
       ;
     EXCEPTION
	        WHEN NO_DATA_FOUND THEN D_matura := 'Maturazione il ';
     END;
     BEGIN
/* Estrazione informazioni retributive */
       FOR CUR_ECO IN
          (SELECT covo.descrizione                      voce
                , inre.tariffa                          tariffa
                , inre.tariffa/decode(nvl(D_ore_lavoro,1),0,1,D_ore_lavoro)*D_ore_ind   imp
                , DECODE
                  ( voec.classe
                  , 'P', DECODE
                         ( D_rif_eco
                         , D_riferimento, decode( inre.al
                                                , null, null
                                                      , D_matura||' '||
                                                        TO_CHAR(inre.al+1,'dd/mm/yyyy')
                                                )
                                        , NULL)
                       , NULL)   testo_econ
                , inre.istituto                         istituto
             FROM CONTABILITA_VOCE                      covo
                , INFORMAZIONI_RETRIBUTIVE              inre
                , VOCI_ECONOMICHE                       voec
            WHERE inre.ci    = D_ci
              AND nvl(inre.tariffa,0)!=0
              AND inre.voce  = voec.codice
              AND inre.tipo != 'E'
              AND (   (    voec.classe IN ('P','B')
                       AND voec.tipo||NVL(voec.specie,'T') IN ('CT','FT')
                      )
                   OR (    voec.classe  = 'V'
                        AND voec.tipo||NVL(voec.specie,'T') IN
                            ('CT','FT','QT')
                      )
                  )
              AND (   (    inre.tipo  != 'B')
                   OR (    inre.tipo   = 'B'
                       AND NOT EXISTS
                          (SELECT 'x'
                             FROM INFORMAZIONI_RETRIBUTIVE inre2
                                , VOCI_CONTABILI           voco
                            WHERE inre2.ci        = inre.ci
                              AND inre2.voce      = inre.voce
                              AND inre2.ROWID    != inre.ROWID
                              AND voco.voce       = inre.voce
                              AND inre2.sub      != 'Q'
                              AND D_rif_eco
                                  BETWEEN NVL(inre2.dal,TO_DATE('2222222','j'))
                                      AND NVL(inre2.al,TO_DATE('3333333','j'))
                          )
                       ))
              AND inre.voce  = covo.voce
              AND inre.sub   = covo.sub
              AND D_rif_eco
                  BETWEEN NVL(inre.dal,TO_DATE('2222222','j'))
                      AND NVL(inre.al,TO_DATE('3333333','j'))
              AND D_rif_eco
                  BETWEEN NVL(covo.dal,TO_DATE('2222222','j'))
                      AND NVL(covo.al,TO_DATE('3333333','j'))
              and inre.tipo != 'R'
            ORDER BY inre.sequenza_voce
          ) LOOP
            D_conta := D_conta + 1;
            IF D_conta = 1 THEN
               BEGIN
/* Estrazione vocaboli fissi dai ref_codes e inserimento "titoli" certificato economico */
                 SELECT MAX(DECODE( CUR_SIN.SIN
                                  , D_l1,NVL( r1.rv_meaning
                                            , NVL( r1.rv_meaning_al1
                                                 , r1.rv_meaning_al2))
                                  , D_l2,NVL( r1.rv_meaning_al1
                                            , NVL( r1.rv_meaning
                                                 , r1.rv_meaning_al2))
                                  , D_l3,NVL( r1.rv_meaning_al2
                                            , NVL( r1.rv_meaning
                                                 , r1.rv_meaning_al1))
                                  ))||' '||to_char(D_rif_eco,'dd/mm/yyyy')
                   INTO D_tratt_econ
                   FROM PGM_REF_CODES     r1
                  WHERE r1.rv_domain    = 'VOCABOLO'
                    AND r1.rv_low_value = 'TRATT_ECON'
                 ;
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                         D_tratt_econ:='Trattamento Economico al';
               END;
               BEGIN
                 SELECT DECODE( CUR_SIN.SIN
                              , D_l1,NVL( r1.rv_meaning
                                        , NVL( r1.rv_meaning_al1
                                             , r1.rv_meaning_al2))
                              , D_l2,NVL( r1.rv_meaning_al1
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al2))
                              , D_l3,NVL( r1.rv_meaning_al2
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al1))
                              )
                   INTO D_sott_econ
                   FROM PGM_REF_CODES r1
                  WHERE r1.rv_domain    = 'VOCABOLO'
                    AND r1.rv_low_value = 'SOTT_ECON'
                 ;
	   	         EXCEPTION
                    WHEN NO_DATA_FOUND THEN
					               D_sott_econ:=null;
               END;
-- c'era l'estrazione delle ore individuali
               INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,ci,lung_riga,testo)
               SELECT prenotazione
                    , D_riga
                    , Dep_ci
                    , 75
                    , ' '
                 FROM dual
                WHERE D_con_qual IS NOT NULL
               ;
               D_riga := D_riga + 1;
               INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,ci,lung_riga,testo)
               SELECT prenotazione
                    , D_riga
                    , Dep_ci
                    , 75
                    , D_tratt_econ
                 FROM dual
                WHERE D_tratt_econ IS NOT NULL
               ;
               D_riga := D_riga + 1;
               INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,ci,lung_riga,testo)
               SELECT prenotazione
                    , D_riga
                    , Dep_ci
                    , 75
                    , D_sott_econ
                 FROM dual
                WHERE D_sott_econ IS NOT NULL
               ;
               D_riga := D_riga + 1;
               INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,ci,lung_riga,testo)
               SELECT prenotazione
                    , D_riga
                    , Dep_ci
                    , 75
                    , ' '
                 FROM dual
                WHERE D_con_qual||decode(nvl(D_ore_ind,0),0,null,' - ore:'||D_ore_ind) IS NOT NULL
               ;
               D_riga := D_riga + 1;
               INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,ci,lung_riga,testo)
               SELECT prenotazione
                    , D_riga
                    , Dep_ci
                    , 75
                    , D_con_qual||decode(nvl(D_ore_ind,0),0,null,' - ore:'||D_ore_ind)
                      ||' su ore settimanali:'||D_ore_lavoro
                 FROM dual
                WHERE D_con_qual||decode(nvl(D_ore_ind,0),0,null,' - ore:'||D_ore_ind) IS NOT NULL
               ;
               D_riga := D_riga + 1;
               INSERT INTO APPOGGIO_CERTIFICATI
                     (prenotazione,progressivo,ci,lung_riga,testo)
               SELECT prenotazione
                    , D_riga
                    , Dep_ci
                    , 75
                    , ' '
                 FROM dual
                WHERE D_con_qual||decode(nvl(D_ore_ind,0),0,null,' - ore:'||D_ore_ind) IS NOT NULL
               ;
               D_riga := D_riga + 1;
               BEGIN
                 SELECT DECODE( CUR_SIN.SIN
                              , D_l1,NVL( r1.rv_meaning
                                        , NVL( r1.rv_meaning_al1
                                             , r1.rv_meaning_al2))
                              , D_l2,NVL( r1.rv_meaning_al1
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al2))
                              , D_l3,NVL( r1.rv_meaning_al2
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al1))
                              )
                   INTO D_lit
                   FROM PGM_REF_CODES r1
                  WHERE r1.rv_domain    = 'VOCABOLO'
                    AND r1.rv_low_value = 'LIT'
                 ;
	             EXCEPTION
                    WHEN NO_DATA_FOUND THEN D_lit := 'Lit. ';
               END;
		       	   BEGIN
                 SELECT DECODE( CUR_SIN.SIN
                              , D_l1,NVL( r1.rv_meaning
                                        , NVL( r1.rv_meaning_al1
                                             , r1.rv_meaning_al2))
                              , D_l2,NVL( r1.rv_meaning_al1
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al2))
                              , D_l3,NVL( r1.rv_meaning_al2
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al1))
                             )
                   INTO D_euro
                   FROM PGM_REF_CODES r1
                  WHERE r1.rv_domain    = 'VOCABOLO'
                    AND r1.rv_low_value = 'EURO'
                 ;
      			   EXCEPTION
                    WHEN NO_DATA_FOUND THEN D_euro := 'Euro ';
               END;
               BEGIN
                 SELECT DECODE( CUR_SIN.SIN
                              , D_l1,NVL( r1.rv_meaning
                                        , NVL( r1.rv_meaning_al1
                                             , r1.rv_meaning_al2))
                              , D_l2,NVL( r1.rv_meaning_al1
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al2))
                              , D_l3,NVL( r1.rv_meaning_al2
                                        , NVL( r1.rv_meaning
                                             , r1.rv_meaning_al1))
                              )
                   INTO D_scadenza
                   FROM PGM_REF_CODES r1
                  WHERE r1.rv_domain    = 'VOCABOLO'
                    AND r1.rv_low_value = 'SCADENZA'
                 ;
        			 EXCEPTION
			              WHEN NO_DATA_FOUND THEN D_scadenza := 'Scadenza il ';
               END;
/* Inserimento testata Certificato Economico */
               BEGIN
                 INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,ci,lung_riga,testo)
                 SELECT prenotazione
                      , D_riga
                      , Dep_ci
                      , 80
                      , RPAD('Voce Economica ',30,' ')||'  '||
                        RPAD(' ',15,' ' )||
                        RPAD('Tariffa ',17,' ')||
                        RPAD(decode(nvl(D_ore_ind,0),0,' ','Rapporto a Ore '),17,' ')
                   from dual;
                 D_riga := D_riga + 1;
                 INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,ci,lung_riga,testo)
                 SELECT prenotazione
                      , D_riga
                      , Dep_ci
                      , 80
                      , RPAD('-',80,'-' )
                   from dual;
                 D_riga := D_riga + 1;
                 INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,ci,lung_riga,testo)
                 SELECT prenotazione
                      , D_riga
                      , Dep_ci
                      , 80
                      , RPAD(' ',80,' ' )
                   from dual;
                   D_riga := D_riga + 1;
                 END;
            END IF;
            INSERT INTO APPOGGIO_CERTIFICATI
                  (prenotazione,progressivo,ci,lung_riga,testo)
            SELECT prenotazione
                 , D_riga
                 , Dep_ci
                 , 80
                 , RPAD(CUR_ECO.voce,30,' ')||'  '||
                   decode(valuta,'L',D_lit,'E',D_euro)||' '||
                   TRANSLATE(
                   DECODE( Valuta
                         , 'E', TO_CHAR(CUR_ECO.tariffa,'999,999,999.99999')
                              , TO_CHAR(CUR_ECO.tariffa,'999,999,999,999'))
                  ,'.,',',.')||' '||' '||
                   TRANSLATE(
                   DECODE( Valuta
                         , 'E', TO_CHAR(CUR_ECO.imp,'999,999,999.99999')
                              , TO_CHAR(CUR_ECO.imp,'999,999,999,999'))
                  ,'.,',',.')||
                   CUR_ECO.testo_econ
              FROM dual
            ;
            D_riga := D_riga + 1;
            END LOOP; -- CUR_ECO
     END CERT_ECONOMICO;
     D_conta := 0;
     BEGIN
/* Estrazione progressioni economiche */
       FOR CUR_PRO IN
          (SELECT covo.descrizione             voce_anz
                , 'n. '||LPAD(inec.periodo,2)  numero_anz
                , DECODE( NVL(inec.periodo,0)
                        , 0, TO_DATE(NULL)
                           , DECODE
                             (SIGN(bavo.gg_periodo
                                  -TO_CHAR(prec.inizio,'dd'))
                             ,-1,LAST_DAY(prec.inizio)+1
                                ,LAST_DAY
                                 (ADD_MONTHS(prec.inizio,-1))+1
                                 )
                         )                      data_anz
             FROM CONTABILITA_VOCE        covo
                , INQUADRAMENTI_ECONOMICI inec
                , PROGRESSIONI_ECONOMICHE prec
                , BASI_VOCE               bavo
            WHERE bavo.voce               = inec.voce
              AND bavo.contratto          =
                 (SELECT contratto FROM QUALIFICHE
                   WHERE numero  = inec.qualifica
                 )
              AND inec.dal
                  BETWEEN bavo.dal AND NVL(bavo.al,TO_DATE('3333333','j'))
              AND prec.ci                 = inec.ci
              AND prec.dal                = inec.dal
              AND prec.qualifica          = inec.qualifica
              AND prec.voce               = inec.voce
              AND prec.periodo            = inec.periodo
              AND covo.voce               = inec.voce
              AND covo.sub                = 'Q'
              AND inec.ci                 = D_CI
              AND D_rif_eco
                  BETWEEN NVL(inec.dal,TO_DATE('2222222','j'))
                      AND NVL(inec.al,TO_DATE('3333333','j'))
              ORDER BY 1
          ) LOOP
            D_conta := D_conta + 1;
            IF D_conta = 1 THEN
            <<PROGR_ECONOMICHE>>
               BEGIN
                 BEGIN
                   select decode( CUR_SIN.sin
                        , D_l1,nvl( r1.rv_meaning
                                  , nvl( r1.rv_meaning_al1
                                       , r1.rv_meaning_al2))
                        , D_l2,nvl( r1.rv_meaning_al1
                                  , nvl( r1.rv_meaning
                                       , r1.rv_meaning_al2))
                        , D_l3,nvl( r1.rv_meaning_al2
                                  , nvl( r1.rv_meaning
                                       , r1.rv_meaning_al1))
                                  )
                     into D_progr_econ
                     from pgm_ref_codes r1
                    where r1.rv_domain    = 'VOCABOLO'
                      and r1.rv_low_value = 'PROGR_ECON'
                   ;
	  		         EXCEPTION
	 		                WHEN NO_DATA_FOUND THEN
            		           D_progr_econ := 'Progressioni Economiche :';
                 END;
                 BEGIN
                   select decode( CUR_SIN.sin
                                , D_l1,nvl( r1.rv_meaning
                                          , nvl( r1.rv_meaning_al1
                                               , r1.rv_meaning_al2))
                                , D_l2,nvl( r1.rv_meaning_al1
                                          , nvl( r1.rv_meaning
                                               , r1.rv_meaning_al2))
                                , D_l3,nvl( r1.rv_meaning_al2
                                          , nvl( r1.rv_meaning
                                               , r1.rv_meaning_al1))
                                )
                      into D_sott_progr
                      from pgm_ref_codes r1
                     where r1.rv_domain    = 'VOCABOLO'
                       and r1.rv_low_value = 'SOTT_PROGR'
                   ;
     			       EXCEPTION
            		      WHEN NO_DATA_FOUND THEN D_sott_progr := NULL;
                 END;
               END PROGR_ECONOMICHE;
               BEGIN
                 INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,ci,lung_riga,testo)
                 SELECT prenotazione
                      , D_riga
                      , Dep_ci
                      , 75
                      , ' '
                   FROM dual
                 ;
                 D_riga := D_riga + 1;
                 INSERT INTO APPOGGIO_CERTIFICATI
                       (prenotazione,progressivo,ci,lung_riga,testo)
                 SELECT prenotazione
                      , D_riga
                      , Dep_ci
                      , 75
                      , D_progr_econ
                   FROM dual
                  WHERE D_progr_econ IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , Dep_ci
                     , 75
                     , D_sott_progr
                  FROM dual
                 WHERE D_sott_progr IS NOT NULL
                ;
                D_riga := D_riga + 1;
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , Dep_ci
                     , 75
                     , ' '
                  FROM dual
                ;
                D_riga := D_riga + 1;
               END;
            END IF;
            INSERT INTO APPOGGIO_CERTIFICATI
                  (prenotazione,progressivo,ci,lung_riga,testo)
            SELECT prenotazione
                 , D_riga
                 , Dep_ci
                 , 80
                 , RPAD(CUR_PRO.voce_anz,30,' ')||' '||
                   RPAD(CUR_PRO.numero_anz,5,' ')||' '||
                   Di_dal||' '||
                   TO_CHAR(CUR_PRO.data_anz,'dd/mm/yyyy')
              FROM dual
            ;
            D_riga := D_riga + 1;
            END LOOP; -- CUR_PRO
     END;
     D_conta := 0;
/*Gestione delle rateali*/
     IF Df_rateali = 'SI' THEN
        D_riga:=D_riga+1;
        FOR CUR_RATE IN
           (SELECT covo.descrizione       descr_voce
                 , covo.voce              voce
                 , covo.sub               sub
                 , inre.imp_tot           imp_tot
                 , inre.rate_tot          rate_tot
                 , inre.tariffa           rata
                 , voec.tipo             tipo_voce
                 , D_scadenza||' '||TO_CHAR(inre.al,'dd/mm/yyyy') scadenza
                 , inre.istituto                         istituto
                 , iscr.descrizione                      des_istituto
              FROM CONTABILITA_VOCE                      covo
                 , INFORMAZIONI_RETRIBUTIVE              inre
                 , VOCI_ECONOMICHE                       voec
                 , ISTITUTI_CREDITO                      iscr
             WHERE inre.ci         = D_ci
               and D_rif_eco between inre.dal and nvl(inre.al,to_date('3333333','j'))
               AND inre.voce       = voec.codice
               AND iscr.codice     = inre.istituto
               AND inre.tipo       = 'R'
               AND inre.voce       = covo.voce
               AND inre.sub        = covo.sub
               and D_rif_eco between nvl(covo.dal,to_date('2222222','j'))
                                 and nvl(covo.al,to_date('3333333','j'))
               and inre.sospensione != '99'
             ORDER BY inre.sequenza_voce
           ) LOOP
             D_conta := D_conta + 1;
             IF D_conta = 1 THEN
                  -- inserimento riga vuota + intestazioni per le rate--
                INSERT INTO APPOGGIO_CERTIFICATI
                      (prenotazione,progressivo,ci,lung_riga,testo)
                SELECT prenotazione
                     , D_riga
                     , Dep_ci
                     , 75
                     , ' '
                  FROM dual
                ;
                D_riga := D_riga + 1;
                insert into appoggio_certificati
                      (prenotazione,progressivo,lung_riga,testo)
                values( prenotazione,
                        D_riga,
                        80,
                        rpad('Situazioni Rateali al '||to_char(D_rif_eco,'dd/mm/yyyy'),80,' ')
                      )
                ;
                D_riga:=D_riga+1;
                insert into appoggio_certificati
                      (prenotazione,progressivo,lung_riga,testo)
                values( prenotazione,
                        D_riga,
                        80,
                        rpad('-',32,'-')
                      )
                ;
                D_riga:=D_riga+1;
                insert into appoggio_certificati
                      (prenotazione,progressivo,lung_riga,testo)
                values( prenotazione,
                        D_riga,
                        80,
                        rpad('',32,''))
                ;
                D_riga:=D_riga+1;
             END IF;
             BEGIN
               select sum(p_imp)*decode(CUR_RATE.tipo_voce,'T',-1,1),
                      sum(p_qta)*decode(CUR_RATE.tipo_voce,'T',-1,1)
                 into p_imp_pag,p_qta_pag
                 from PROGRESSIVI_CONTABILI prco
                where ci   =  D_ci
                  and voce =  cur_rate.voce
                  and sub  =  cur_rate.sub
                  and anno =  to_char(D_rif_eco,'yyyy')
                  and mese =  to_char(D_rif_eco,'mm')
                  and mensilita = (select max (mensilita)
                                     from  progressivi_contabili
                                    where ci = prco.ci
                                      and anno= prco.anno
                                      and mese = prco.mese
                                      and voce = prco.voce
                                      and sub = prco.sub
                                   );
             EXCEPTION
                  when others then p_imp_pag:=null;
                                   p_qta_pag:=null;
             END;
             INSERT INTO APPOGGIO_CERTIFICATI
                   (prenotazione,progressivo,lung_riga,testo)
             VALUES ( prenotazione
                    , D_riga
                    , 80
                    , rpad(CUR_RATE.descr_voce,30,' ')||' con '||rpad(CUR_RATE.scadenza,23,' ')
                    )
            ;
            D_riga:=D_riga+1;
            INSERT INTO APPOGGIO_CERTIFICATI
                  (prenotazione,progressivo,lung_riga,testo)
            VALUES ( prenotazione
                   , D_riga
                   , 80
                   , rpad(' ',35,' ')||
                     'Istituto:'||rpad(CUR_RATE.istituto,6,' ')||rpad(CUR_RATE.des_istituto,30,' ')
                   )
            ;
            D_riga:=D_riga+1;
            insert into appoggio_certificati
                  (prenotazione,progressivo,lung_riga,testo)
            values( prenotazione,
                    D_riga,
                    80,
                    rpad('',80,''))
            ;
            D_riga:=D_riga+1;
            insert into appoggio_certificati
                  (prenotazione,progressivo,lung_riga,testo)
            values( prenotazione,
                    D_riga,
                    80,
                    lpad('Imp.Tot.',17,' ') ||
                    lpad('Rate Tot.',11,' ')||
                    lpad('Imp.Rata',12,' ')     ||
                    lpad('Imp.Pag.',18,' ') ||
                    lpad('Qta Pag.',9,' ')
                  )
            ;
            D_riga:=D_riga+1;
            insert into appoggio_certificati
                  (prenotazione,progressivo,lung_riga,testo)
            values( prenotazione,
                    D_riga,
                    80,
                    rpad('-',80,'-'))
            ;
            D_riga:=D_riga+1;
            INSERT INTO APPOGGIO_CERTIFICATI
                  (prenotazione,progressivo,lung_riga,testo)
            VALUES ( prenotazione
                   , D_riga
                   , 80
                   , TRANSLATE(DECODE( Valuta
                                     , 'E', TO_CHAR(CUR_RATE.imp_tot,'9,999,999,999.99')
                                          , TO_CHAR(CUR_RATE.imp_tot,'999,999,999,999')
                                     ),'.,',',.')
                     ||lpad(' ',4,' ')
                     ||TRANSLATE(TO_CHAR(CUR_RATE.rate_tot,'99999'),'.,',',.')
                     ||TRANSLATE(DECODE( Valuta
                                       , 'E', TO_CHAR(CUR_RATE.rata,'9,999,999.99')
                                            , TO_CHAR(CUR_RATE.rata,'999,999,999')
                                       ),'.,',',.')
                     ||TRANSLATE(DECODE( Valuta
                                       , 'E', TO_CHAR(p_imp_pag,'9,999,999,999.99')
                                            , TO_CHAR(p_imp_pag,'999,999,999,999')
                                       ),'.,',',.')
                     ||lpad(' ',4,' ')
                     ||TRANSLATE(TO_CHAR(p_qta_pag,'99999'),'.,',',.')
                   );
             INSERT INTO APPOGGIO_CERTIFICATI
                   (prenotazione,progressivo,lung_riga,testo)
             values( prenotazione,
                     D_riga,
                     80,
                     rpad('',80,''))
             ;
             D_riga:=D_riga+1;
             END LOOP; -- CUR_RATE
     ELSE NULL;
     END IF;
  ELSE NULL;
  END IF;
  END;
END;
D_riga := 8400;
INSERT INTO APPOGGIO_CERTIFICATI
      (prenotazione,progressivo,lung_riga,testo)
VALUES ( prenotazione
       , D_riga
       , 75
       , ' '
       )
       ;
D_riga := D_riga + 1;
BEGIN
  FOR CUR_NOT IN
     (SELECT testo
        FROM TESTI_FORMULA
       WHERE gruppo_ling = CUR_SIN.SIN
         AND formula     = D_cod_not
       ORDER BY sequenza
     ) LOOP
         BEGIN
           INSERT INTO APPOGGIO_CERTIFICATI
                 (prenotazione,progressivo,lung_riga,testo)
           VALUES ( prenotazione
                  , D_riga
                  , 75
                  , CUR_NOT.testo
                  )
           ;
           D_riga := D_riga + 1;
         END;
       END LOOP; -- CUR_NOT
END;
BEGIN
  FOR CUR_CON IN
     (SELECT testo
        FROM TESTI_FORMULA
       WHERE gruppo_ling = CUR_SIN.SIN
         AND formula     = D_cod_con
       ORDER BY sequenza
      ) LOOP
          BEGIN
            INSERT INTO APPOGGIO_CERTIFICATI
                  (prenotazione,progressivo,lung_riga,testo)
            VALUES ( prenotazione
                   , D_riga
                   , 75
                   , CUR_CON.testo
                   )
            ;
            D_riga := D_riga + 1;
          END;
        END LOOP; -- CUR_CON
END;
BEGIN
  D_riga := 8450;
  FOR CUR_FIR IN
     (SELECT testo
        FROM TESTI_FORMULA
       WHERE gruppo_ling = CUR_SIN.SIN
         AND formula     = D_cod_fir
       ORDER BY sequenza
      ) LOOP
          BEGIN
            INSERT INTO APPOGGIO_CERTIFICATI
                  (prenotazione,progressivo,lung_riga,testo)
            VALUES ( prenotazione
                   , D_riga
                   , 75
                   , CUR_FIR.testo
                   )
            ;
            D_riga := D_riga + 1;
          END;
        END LOOP; -- CUR_FIR
END;
END LOOP; -- CUR_SIN
END;
END;
EXCEPTION WHEN USCITA
          THEN NULL;
END;
COMMIT;
END;
END;
/
