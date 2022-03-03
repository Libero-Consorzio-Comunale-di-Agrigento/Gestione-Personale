CREATE OR REPLACE PACKAGE PECSMDPM IS
/******************************************************************************
 NOME:        PECSMDPM
 DESCRIZIONE: Emissione File Testo per INPDAP.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
     Il package prevede:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    01/01/2003  ML
 2    01/01/2004  MS/CB Revisione per Cartolarizzazione
 2.1  08/11/2004  ML    Se P_economico null NON deve estrarre i record di arretrati
 2.2  25/02/2005  ML    Modificato il codice fiscale dell'ente nell'emissione dei record M
 2.3  06/04/2005  ML    Aggiunta la gestione nell'insert della riga 0 per la cartolarizzazione A10120
 2.4  09/07/2007  ML    Gestione codice indentificativo inpdap (gest.progressivo_inpdap) (A21908)
 2.5  27/07/2007  ML    Gestione codice indentificativo inpdap anche nel record M (gest.progressivo_inpdap) (A22176)
 2.6  27/08/2007  GM    Moficata dimensione campo E_mail
 2.7  25/09/2007  ML    Modificato nvl per progressivo_inpdap (A23013)
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMDPM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.7 del 25/09/2007';
END VERSIONE;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE
  D_ente          varchar(4);
  D_ambiente      varchar(8);
  D_utente        varchar(8);
  D_tipo_for    VARCHAR2(1);
  D_rapporto        VARCHAR2(4);
  D_gruppo          VARCHAR2(12);
  P_sfasato       VARCHAR2(1);
  D_gestione        VARCHAR2(4);
  D_inpdap_data_decorrenza DATE;
  D_cod_fis_dic     VARCHAR2(16);
  D_dummy_f         VARCHAR2(1);
  D_economico       VARCHAR2(1);
  D_cartolarizzazione VARCHAR2(1);
  D_qua_fiscale     VARCHAR2(1);
  D_cod_catasto     VARCHAR2(4);
  D_com_cess        VARCHAR2(40);
  D_prov_cess       VARCHAR2(5);
  D_cassa_arr       VARCHAR2(1);
  D_cassa_ser       VARCHAR2(1);
  D_riga            NUMBER := 0;
  D_pagina          NUMBER := 0;
  D_anno            VARCHAR2(4);
  D_mese            varchar2(2);
  D_modulo          NUMBER := 0;
  D_modulo_m        NUMBER := 0;
  D_num_ord         NUMBER := 1;
  D_conta_inpdap    NUMBER := 0;
  D_data_inail      DATE;
  D_inpdap_cf       VARCHAR2(16);
  D_inpdap_pos      VARCHAR2(10);
  D_inpdap_serv     VARCHAR2(2);
  D_inpdap_imp      VARCHAR2(2);
  D_inpdap_cess     DATE;
  D_inpdap_c_cess   VARCHAR2(2);
  D_inpdap_ass      VARCHAR2(6);
  D_inpdap_mag      VARCHAR2(12);
  D_inpdap_prov     VARCHAR2(2);
  D_inpdap_dal      DATE;
  D_inpdap_al       DATE;
  D_inpdap_cassa    varchar2(1);
  D_inpdap_gg       number;
  D_inpdap_fisse    number;
  D_inpdap_acce     number;
  D_inpdap_inadel   number;
  D_inpdap_tfr      number;
  D_inpdap_ind_non_a number;
  D_inpdap_premio   number;
  D_inpdap_ril      VARCHAR2(2);
  D_inpdap_rif      number;
  D_inpdap_l_388    varchar2(1);
  D_inpdap_gg_tfr   number;
  D_inpdap_l_165    number;
  D_inpdap_comp_18  number;
  D_al              DATE;
  D_fin_a           DATE;
  D_cod_fis         VARCHAR(16);
  D_gest            VARCHAR2(4);
  D_nome            varchar2(60);
  D_comune          varchar2(40);
  D_provincia       varchar2(2);
  D_indirizzo       varchar2(35);
  D_cap             varchar2(5);
  D_codice_attivita varchar2(5);
  D_tel_res         varchar2(12);
  D_fax_res         varchar2(12);
  D_e_mail          GESTIONI.E_MAIL%TYPE;
  D_progr_inpdap    number(5);
  D_conta_g         number:=0;
  D_rif_vers        varchar2(16);
  D_tipo_pag        varchar2(16);
  D_numero_distinta varchar2(16);
  D_data_pag        date;
  D_ass_cess        varchar2(1);
  D_cess            varchar2(1);
  D_note            varchar2(40);
  esci              EXCEPTION;
BEGIN
-- estrazione parametri di selezione
  BEGIN
    select ente     D_ente
         , utente   D_utente
         , ambiente D_ambiente
      into D_ente,D_utente,D_ambiente
      from a_prenotazioni
     where no_prenotazione = prenotazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_ente     := null;
         D_utente   := null;
         D_ambiente := null;
  END;
  BEGIN
    SELECT valore
      INTO D_gestione
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
    INTO P_sfasato
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ANNO_SFASATO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      P_sfasato := null;
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
      INTO D_tipo_for
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO_FOR'
  ;
  END;
  BEGIN
    SELECT TO_DATE('3112'||SUBSTR(valore,1,4),'ddmmyyyy')
      INTO D_fin_a
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            SELECT TO_DATE('3112'||TO_CHAR(anno),'ddmmyyyy')
              INTO D_fin_a
              FROM RIFERIMENTO_FINE_ANNO
             WHERE rifa_id = 'RIFA';
    END;
  BEGIN
    SELECT valore
      INTO D_anno
   FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT anno
        INTO D_anno
        FROM RIFERIMENTO_RETRIBUZIONE
       WHERE rire_id = 'RIRE'
      ;
  END;
  BEGIN
 SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/',
          'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
   INTO D_al
   FROM a_parametri
  WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_AL'
 ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_al := LAST_DAY(SYSDATE);
  END;
  BEGIN
    SELECT valore
      INTO D_rif_vers
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_RIF_VERS'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_rif_vers := null;
  END;
  BEGIN
    SELECT valore
      INTO D_tipo_pag
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO_PAG'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_tipo_pag := NULL;
  END;
  BEGIN
    SELECT valore
      INTO D_numero_distinta
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_NUMERO_DISTINTA'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_numero_distinta := NULL;
  END;
BEGIN
    SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/',
          'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
      INTO D_data_pag
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_DATA_PAG'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_data_pag := NULL;
  END;
  BEGIN
    SELECT to_char(nvl(D_al,trunc(sysdate)),'mm')
      INTO D_mese
      FROM dual
      ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_mese:= NULL;
  END;
  BEGIN
    SELECT valore
      INTO D_economico
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ECONOMICO'
  ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_economico := null;
  END;
 BEGIN
    SELECT valore
      INTO D_cartolarizzazione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CARTOLARIZZAZIONE'
  ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_cartolarizzazione := 'C';
  END;
  BEGIN
    SELECT DISTINCT codice_fiscale
 INTO D_cod_fis
      FROM DENUNCIA_INPDAP dein
          ,GESTIONI        gest
     WHERE dein.gestione LIKE D_gestione
       AND gest.codice = dein.gestione
       AND dein.anno   = D_anno
    ;
 UPDATE a_selezioni
    SET valore_default = DECODE( D_tipo_for
                                    , '1', D_cod_fis||'-01.txt'
                                    , '2', D_cod_fis||'-01'||TO_CHAR(NVL(D_AL,SYSDATE),'MM')||SUBSTR(D_anno,3,2)||'.txt'
                                         , D_cod_fis||'-'||TO_CHAR(NVL(D_AL,SYSDATE),'MM')|| SUBSTR(D_anno,3,2)||'.txt'
                                    )
  WHERE voce_menu = 'PECSMDPM'
    AND parametro = 'TXTFILE'
 ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
   UPDATE a_prenotazioni
      SET errore = 'P00111'
             , prossimo_passo = 99
    WHERE no_prenotazione = prenotazione
   ;
 RAISE esci;
    WHEN TOO_MANY_ROWS THEN
   UPDATE a_prenotazioni
      SET errore = 'P00110'
             , prossimo_passo = 99
    WHERE no_prenotazione = prenotazione
   ;
 RAISE esci;
  END;
BEGIN
    SELECT max(nome)
         , max(upper(COMU.DESCRIZIONE))
         , max(SUBSTR( DECODE( SIGN(199-comu.cod_provincia), -1,'  ', comu.sigla_provincia),1,2))
         , max(upper(gest.indirizzo_res))
         , max(comu.cap)
         , max(codice_attivita)
         , max(decode(lpad(translate(nvl(replace(replace(tel_res,'/',''),'-',''),' ')
                                    ,'0123456789','0000000000')
                           ,12,'0')
              ,'000000000000', replace(replace(tel_res,'/',''),'-','')
                             , null))                   tel_res
         , max(decode(lpad(translate(nvl(replace(replace(tel_res,'/',''),'-',''),' ')
                                     ,'0123456789','0000000000')
                          ,12,'0')
              ,'000000000000', replace(replace(fax_res,'/',''),'-','')
                             , null))                  fax_res
         , max(e_mail)
         , max(progressivo_inpdap)
 INTO D_nome,D_comune,D_provincia,D_indirizzo,D_cap,D_codice_attivita
     , D_tel_res,D_fax_res,D_e_mail,D_progr_inpdap
      FROM DENUNCIA_INPDAP dein
          ,GESTIONI        gest
          ,comuni          comu
     WHERE dein.gestione LIKE D_gestione
       AND gest.codice = dein.gestione
       AND dein.anno   = D_anno
       AND comu.cod_comune    (+) = gest.comune_res
       AND comu.cod_provincia (+) = gest.provincia_res
    ;
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
 D_nome:=null;
      D_comune:=null;
      D_provincia:=null;
      D_indirizzo:=null;
      D_cap:=null;
      D_codice_attivita:=null;
      D_tel_res:=null;
      D_fax_res:=null;
      D_e_mail:=null;
END;
IF D_cartolarizzazione != 'D' THEN
   d_pagina := 1;
           INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                VALUES ( prenotazione
             , 1
           , d_pagina
        , 1
        , 'A'||
                         rpad(' ',14,' ')||
                         rpad('77S02',5,' ')||
                         lpad('01',2,'0')||
                         rpad(nvl(d_cod_fis,' '),16,' ')||
                         lpad(' ',177,' ') ||
                         rpad(nvl(D_nome,' '),60,' ')  ||
                         rpad(nvl(D_comune,' '),40,' ')||
                         rpad(nvl(D_provincia,' '),2,' ') ||
                         rpad(nvl(D_indirizzo,' '),35,' ') ||
                         lpad(nvl(D_cap,0),5,'0') ||
                         rpad(nvl(D_comune,' '),40,' ')||
                         rpad(nvl(D_provincia,' '),2,' ') ||
                         rpad(nvl(D_indirizzo,' '),35,' ') ||
                         lpad(nvl(D_cap,0),5,'0') ||
                         lpad(' ',82,' ')||
                         lpad('1',4,'0')||
                         lpad('1',4,'0')||
                         lpad(' ',1368,' ')||
           'A'||
                         lpad(' ',2,' ')
      )
                        ;
          d_pagina:=2;
          INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
        VALUES ( prenotazione
                 , 1
                , d_pagina
                 , 1
                 , 'B'||
                   rpad(d_cod_fis,11,' ')||
                   lpad(nvl(to_char(D_progr_inpdap),' '),5,' ')||
                         lpad('1',8,'0')||
                         lpad(' ',64,' ')||
                         lpad('0',1,'0') ||
                         lpad('0',1,'0') ||
                         lpad('1',1,'0') || -- importi espressi in Euro
                         lpad('0',1,'0') ||
                         lpad('0',1,'0') ||
                         lpad(' ',7,' ') ||
                         lpad('0',2,'0') ||
                         lpad(' ',2,' ') ||
                         rpad(' ',7,' ') ||
                         lpad(' ',44,' ') ||
                         rpad(nvl(D_nome,' '),60,' ')||
                         lpad(' ',15,' ')||
                         lpad(nvl(D_codice_attivita,'0'),5,'0')||
                         rpad(nvl(D_tel_res,' '),12,' ')||
                         rpad(nvl(D_fax_res,' '),12,' ')||
                         rpad(nvl(D_e_mail,' '),100,' ')||
                         lpad(' ',9,' ')||
                         lpad(' ',352,' ')||
                         rpad(' ',6,' ')||
                         rpad(nvl(D_comune,' '),40,' ')||
                         rpad(nvl(D_provincia,' '),2,' ')||
                         rpad(nvl(D_indirizzo,' '),35,' ')||
                         lpad(nvl(D_cap,0),5,'0')||
                         lpad(' ',6,' ')||
                         rpad(nvl(D_comune,' '),40,' ')||
                         rpad(nvl(D_provincia,' '),2,' ')||
                         rpad(nvl(D_indirizzo,' '),35,' ')||
                         lpad(nvl(D_cap,0),5,'0')||
                         lpad(' ',16,' ')||
                         lpad(' ',1,' ')||
                         lpad(' ',2,' ')||
                         lpad(' ',1,' ')||
                         lpad(' ',62,' ')||
                         lpad('0',11,'0')||
                         lpad(' ',51,' ')||
                         lpad(' ',255,' ')|| -- dichiarazione per altri
                         lpad('0',1,'0')|| -- campo 108
                         lpad(' ',2,' ')||
                         lpad('0',1,'0')|| -- campo 111
                         lpad(' ',48,' ')||
                         lpad('0',1,'0')||
                         lpad('0',1,'0')||
                         lpad('0',8,'0')||
                         lpad('0',8,'0')||
                         lpad(' ',34,' ')||
                         lpad('0',1,'0')||
                         lpad(' ',73,' ')||
                         lpad('0',1,'0')||
                         lpad('0',1,'0')||
                         lpad('0',8,'0')||
                         lpad('0',8,'0')||
                         lpad(' ',408,' ')
            )
     ;
 end if;
  BEGIN
    FOR CUR_ANA IN
       (SELECT DISTINCT rain.ci                           ci
             , anag.codice_fiscale                        cod_fis
             , UPPER(anag.cognome)                        cognome
             , UPPER(anag.nome)                           nome
             , SUBSTR(TO_CHAR(anag.data_nas
                             ,'ddmmyyyy'),1,8)            data_nas
             , anag.sesso                                 sesso
             , UPPER(comu_n.descrizione)                  com_nas
             , SUBSTR( DECODE( SIGN(199-comu_n.cod_provincia)
                        , -1, '  '
                            , comu_n.sigla_provincia)
                ,1,2)                                     prov_nas
             , UPPER(comu_r.descrizione)                  com_res
             , SUBSTR( DECODE( SIGN(199-comu_r.cod_provincia)
                        , -1, 'EE'
                            , comu_r.sigla_provincia)
                ,1,2)                                     prov_res
             , UPPER(anag.indirizzo_res)                  ind_res
             , comu_r.cap                                 cap_res
             , LPAD(NVL(cste.codice,'0'),3,'0')           cittadinanza
          FROM comuni                   comu_n
             , comuni                   comu_r
             , ANAGRAFICI               anag
             , RAPPORTI_INDIVIDUALI     rain
             , CATEGORIA_STATI_ESTERI   cste
         WHERE anag.ni  = rain.ni
           AND anag.dal =
                        (SELECT MAX(dal)
                           FROM ANAGRAFICI
                          WHERE ni  = anag.ni
                            AND dal <= D_al)
           AND comu_n.cod_comune        = anag.comune_nas
           AND comu_n.cod_provincia     = anag.provincia_nas
           AND comu_r.cod_comune        = anag.comune_res
           AND comu_r.cod_provincia     = anag.provincia_res
           AND cste.cittadinanza (+)    = anag.cittadinanza
      AND EXISTS (SELECT 'x'
                    FROM DENUNCIA_INPDAP dein
              WHERE anno = D_anno
                AND ci = rain.ci
      AND gestione LIKE D_gestione
                          and (   rilevanza = 'S'
                               or D_economico = 'X')
       )
         AND rain.rapporto LIKE D_rapporto
      AND NVL(rain.gruppo,' ')   LIKE D_gruppo
           AND not exists(select 'x'
                            from rapporti_diversi radi
                            where rain.ci = radi.ci_erede
                              and radi.rilevanza in ('R','L')
                              and radi.anno = D_anno
                          )
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
   ORDER BY 3,4,1
       ) LOOP
                BEGIN
                  SELECT comu.descrizione     com_cess,
                         comu.sigla_provincia prov_cess,
                          DECODE( SIGN(199-comu.cod_provincia)
                                  , -1, ' '
                                  , comu.codice_catasto)
                     INTO D_com_cess,
                          D_prov_cess,
                          D_cod_catasto
                     FROM RAPPORTI_INDIVIDUALI rain,
                          ANAGRAFICI  anag,
                          comuni comu
                    WHERE rain.ci = CUR_ANA.ci
                      AND rain.ni = anag.ni
                      AND anag.dal =
                           (SELECT MAX(dal)
                              FROM ANAGRAFICI
                             WHERE ni        = anag.ni
                               AND dal       <= D_al)
                      AND anag.comune_res    = comu.cod_comune
                      AND anag.provincia_res = comu.cod_provincia
                   ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     D_com_cess := ' ';
                     D_prov_cess := ' ';
                     D_cod_catasto := ' ';
                 END;
                 BEGIN
                   SELECT DECODE(INSTR(NVL(UPPER(pegi.note),' ')
                                ,'INTRAMURARIA')
                                ,0,SUBSTR(qual.cat_fiscale,1,1)
                                ,'R')
                     INTO D_qua_fiscale
                     FROM QUALIFICHE             qual
                        , PERIODI_GIURIDICI      pegi
                    WHERE qual.numero    = pegi.qualifica
                      AND pegi.rilevanza = 'S'
                      AND pegi.ci        = CUR_ANA.ci
                      AND pegi.dal       =
                                        (SELECT MAX(p2.dal)
                                           FROM PERIODI_GIURIDICI p2
                                          WHERE p2.rilevanza = 'S'
                                            AND p2.ci        = CUR_ANA.ci
                                            AND p2.dal      <= D_al
                                        )
                   ;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     BEGIN
                       SELECT DECODE(INSTR(NVL(UPPER(pegi.note),' ')
                                    ,'INTRAMURARIA')
                                    ,0,SUBSTR(qual.cat_fiscale,1,1)
                                    ,'R')
                         INTO D_qua_fiscale
                         FROM QUALIFICHE             qual
                            , PERIODI_GIURIDICI      pegi
                        WHERE pegi.rilevanza = 'Q'
                          AND pegi.ci        = CUR_ANA.ci
                          AND pegi.dal       =
                                            (SELECT MAX(p2.dal)
                                               FROM PERIODI_GIURIDICI p2
                                              WHERE p2.rilevanza = 'Q'
                                                AND p2.ci        = CUR_ANA.ci
                                                AND p2.dal      <= D_al)
                                                AND qual.numero    =
                                                    (SELECT qualifica
                                                       FROM FIGURE_GIURIDICHE
                                                      WHERE numero = pegi.figura
                                                        AND LEAST( NVL(pegi.al,TO_DATE('3333333','j'))
                                                                 , D_al)
                                                            BETWEEN dal
                                                                AND NVL(al,TO_DATE('3333333','j'))
                                            )
                       ;
                     EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        D_qua_fiscale := ' ';
                     END;
                 END;
           D_inpdap_cf      := NULL;
           D_inpdap_serv    := NULL;
           D_inpdap_imp     := NULL;
           D_inpdap_cess    := TO_DATE(NULL);
           D_inpdap_c_cess  := NULL;
           D_inpdap_ass     := NULL;
           D_inpdap_mag     := NULL;
           D_inpdap_prov    := NULL;
           D_inpdap_dal     := TO_DATE(NULL);
           D_inpdap_al      := TO_DATE(NULL);
           D_inpdap_cassa   := null;
           D_inpdap_gg      := to_number(null);
           D_inpdap_fisse   := to_number(null);
           D_inpdap_acce    := to_number(null);
           D_inpdap_inadel  := to_number(null);
           D_inpdap_tfr     := to_number(null);
           D_inpdap_premio  := to_number(null);
           D_inpdap_ril     := NULL;
           D_inpdap_rif     := to_number(null);
           D_inpdap_ind_non_a := to_number(null);
        D_inpdap_l_388            := null;
        D_inpdap_data_decorrenza := TO_DATE(NULL);
        D_inpdap_gg_tfr := to_number(null);
     D_inpdap_l_165   := to_number(null);
     D_inpdap_comp_18 := to_number(null);
        D_conta_inpdap   := 0;
     D_gest           := NULL;
           FOR CUR_INPDAP IN
             (SELECT gest.codice_fiscale                   gest_cf
         , decode( least(D_al,nvl(dedp.data_cessazione,D_al+1))
                           , dedp.data_cessazione,dedp.data_cessazione
                                                 , to_date(null))
                                             data_cess
                   , decode( least(D_al,nvl(dedp.data_cessazione,D_al+1))
                           , dedp.data_cessazione,dedp.causa_cessazione
                                                 ,null)                 causa_cess
                   , dedp.assicurazioni                    ass
                   , dedp.maggiorazioni                    mag
                   , NVL(dedp.tipo_impiego,'0')            tipo_impiego
                   , NVL(dedp.tipo_servizio,'0')           tipo_servizio
                   , dedp.dal                              dal
                   , decode( P_sfasato
                           , 'X', decode( posi.di_ruolo
                                        , 'R', LEAST(nvl(dedp.al,D_al),D_al)
                                             , LEAST(nvl(dedp.al,add_months(D_al,-1)),add_months(D_al,-1))
                                        )
                                , LEAST(nvl(dedp.al,D_al),D_al)
                           )                           al
         , DECODE
                     ( dedp.rilevanza
                     ,'S',DECODE(D_cassa_ser,'X','1',NULL)
                         ,DECODE
                          (D_cassa_arr
                          ,'X','2'
                              , DECODE
                                (dedp.Competenza
                                ,dedp.riferimento,'1','2'))) cassa_comp
                   , nvl(dedp.gg_utili,0)                  gg_utili
       , round(nvl(dedp.comp_fisse,0))         comp_fisse
                   , round(nvl(dedp.comp_accessorie,0))    comp_accessorie
                   , round(nvl(dedp.comp_inadel,0))        comp_inadel
                   , round(nvl(dedp.comp_tfr,0))           comp_tfr
                   , round(nvl(dedp.premio_prod,0))        premio_prod
                   , dedp.rilevanza                        rilevanza
                   , dedp.riferimento                      riferimento
          , l_388                                 legge_388
       , data_decorrenza                       data_dec
          , gg_tfr                                gg_tfr
          , round(nvl(ind_non_a,0))               ind_non_a
          , round(nvl(l_165,0))                   l_165
          , round(nvl(comp_18,0))                 comp_18
       , dedp.gestione                         gest
       , DECODE(dedp.rilevanza,'S',1,2)        ord
                FROM DENUNCIA_INPDAP  dedp,
                     posizioni        posi,
                     GESTIONI         gest
               WHERE dedp.anno     = D_anno
                 and (   nvl(D_cartolarizzazione,' ') != 'C'
                      or 1 = 2)
                 AND dedp.ci      IN (  SELECT rain.ci
                                          FROM RAPPORTI_INDIVIDUALI rain
                                         WHERE CI IN ( select CUR_ANA.ci
                                                         from dual
                                                        union
                                                       select ci_erede
                                                         from RAPPORTI_DIVERSI radi
                                                        where radi.ci = CUR_ANA.ci
                                                         and radi.rilevanza in ('L','R')
                                                         and radi.anno = D_anno
                                                     )
                                           AND rapporto IN ( SELECT codice FROM CLASSI_RAPPORTO
                                            WHERE cat_fiscale IN ('1','10','15','2','20','25'))
                                     )
                 AND gest.codice LIKE D_gestione
                 AND posi.codice    = (select substr(max(to_char(dal,'yyyymmdd')||posizione),9)
                                         from periodi_giuridici
                                        where rilevanza = 'Q'
                                          and ci        = dedp.ci
                                          and dal      <= nvl(dedp.al,D_al))
                 AND dedp.gestione = gest.codice
                 AND (   dedp.rilevanza = 'S'
                      or D_economico    = 'X')
       AND dedp.dal <= NVL(D_al,LAST_DAY(SYSDATE))
               UNION
              SELECT 'Z'                           gest_cf
                   , TO_DATE(NULL)                 data_cess
                   , NULL                          causa_cess
                   , NULL                          ass
                   , NULL                          mag
                   , NULL                          tipo_impiego
                   , NULL                          tipo_servizio
                   , TO_DATE(NULL)                 dal
                   , TO_DATE(NULL)                 al
    , NULL                          cassa_comp
                   , to_number(null)               gg_utili
                   , to_number(null)               comp_fisse
                   , to_number(null)               comp_accessorie
                   , to_number(null)               comp_inadel
                   , to_number(null)               comp_tfr
                   , to_number(null)               premio_prod
                   , NULL                          rilevanza
                   , to_number(null)               riferimento
            , null                          legge_388
    , TO_DATE(NULL)                 data_dec
    , to_number(null)               gg_tfr
    , to_number(null)               ind_non_a
         , to_number(null)               l_165
         , to_number(null)               comp_18
                   , NULL                           gest
                   , 3                             ord
                FROM dual
               WHERE EXISTS
                    (SELECT 'x' FROM DENUNCIA_INPDAP
                      WHERE anno = D_anno
                        AND ci   = CUR_ANA.ci
                        AND gestione LIKE D_gestione)
                 and (   nvl(D_cartolarizzazione,' ') != 'C'
                      or 1 = 2)
      ORDER BY 26,8
             ) LOOP
              BEGIN
              D_conta_inpdap   := D_conta_inpdap + 1;
              IF D_conta_inpdap = 1 THEN
                D_inpdap_cf      := CUR_INPDAP.gest_cf;
                D_inpdap_serv    := CUR_INPDAP.tipo_servizio;
                D_inpdap_imp     := CUR_INPDAP.tipo_impiego;
                D_inpdap_cess    := CUR_INPDAP.data_cess;
                D_inpdap_c_cess  := CUR_INPDAP.causa_cess;
                D_inpdap_ass     := CUR_INPDAP.ass;
                D_inpdap_mag     := CUR_INPDAP.mag;
                D_inpdap_dal     := CUR_INPDAP.dal;
                D_inpdap_al      := CUR_INPDAP.al;
                D_inpdap_cassa   := CUR_INPDAP.cassa_comp;
                D_inpdap_gg      := CUR_INPDAP.gg_utili;
                D_inpdap_fisse   := CUR_INPDAP.comp_fisse;
                D_inpdap_acce    := CUR_INPDAP.comp_accessorie;
                D_inpdap_inadel  := CUR_INPDAP.comp_inadel;
                D_inpdap_tfr     := CUR_INPDAP.comp_tfr;
                D_inpdap_premio  := CUR_INPDAP.premio_prod;
                D_inpdap_ril     := CUR_INPDAP.rilevanza;
                D_inpdap_rif     := CUR_INPDAP.riferimento;
                D_inpdap_ind_non_a := CUR_INPDAP.ind_non_a;
                D_inpdap_l_388     := CUR_INPDAP.legge_388;
             D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
             D_inpdap_gg_tfr := CUR_INPDAP.gg_tfr;
                D_inpdap_l_165   := CUR_INPDAP.l_165;
                D_inpdap_comp_18 := CUR_INPDAP.comp_18;
                D_conta_inpdap   := D_conta_inpdap + 1;
           D_gest           := CUR_INPDAP.gest;
              ELSIF NVL(D_inpdap_cf,' ') = NVL(CUR_INPDAP.gest_cf,' ')
                AND
                    NVL(D_inpdap_serv ,' ') = NVL(CUR_INPDAP.tipo_servizio,' ')
                AND
                    NVL(D_inpdap_imp ,' ') = NVL(CUR_INPDAP.tipo_impiego,' ')
                AND
                    D_inpdap_ril = CUR_INPDAP.rilevanza
                AND
                    nvl(D_inpdap_rif,0) = nvl(CUR_INPDAP.riferimento,0)
                AND
                    NVL(D_inpdap_cassa,' ')= NVL(CUR_INPDAP.cassa_comp,' ')
          AND
                    NVL(D_inpdap_ass,' ')= NVL(CUR_INPDAP.ass,' ')
                AND
                    NVL(D_inpdap_al,TO_DATE('3333333','j')) = CUR_INPDAP.dal - 1
               THEN
                D_inpdap_cess  := CUR_INPDAP.data_cess;
                D_inpdap_c_cess  := CUR_INPDAP.causa_cess;
                D_inpdap_ass   := CUR_INPDAP.ass;
                D_inpdap_mag   := CUR_INPDAP.mag;
                D_inpdap_al    := CUR_INPDAP.al;
                D_inpdap_gg    := D_inpdap_gg     + CUR_INPDAP.gg_utili;
                D_inpdap_fisse := D_inpdap_fisse  + CUR_INPDAP.comp_fisse;
                D_inpdap_acce  := D_inpdap_acce   + CUR_INPDAP.comp_accessorie;
                D_inpdap_inadel := D_inpdap_inadel + CUR_INPDAP.comp_inadel;
                D_inpdap_tfr := D_inpdap_tfr + CUR_INPDAP.comp_tfr;
                D_inpdap_premio := D_inpdap_premio + CUR_INPDAP.premio_prod;
                D_inpdap_ind_non_a := D_inpdap_ind_non_a + CUR_INPDAP.ind_non_a;
                D_inpdap_l_388     := D_inpdap_l_388 + CUR_INPDAP.legge_388;
             D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
      D_inpdap_gg_tfr := D_inpdap_gg_tfr + CUR_INPDAP.gg_tfr;
      D_inpdap_l_165   := D_inpdap_l_165 + CUR_INPDAP.l_165;
      D_inpdap_comp_18 := D_inpdap_comp_18 + CUR_INPDAP.comp_18;
                D_conta_inpdap := D_conta_inpdap + 1;
      D_gest           := CUR_INPDAP.gest;
              ELSE
                D_conta_inpdap := D_conta_inpdap + 1;
     IF D_conta_inpdap != 1  THEN
                  D_riga           := 1;
    D_pagina := D_pagina + 1;
          D_modulo := D_modulo + 1;
                   INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
            VALUES ( prenotazione
             , 1
            , D_pagina
        , 0
        , LPAD(CUR_ANA.CI,8)||
          RPAD(nvl(D_gest,' '),4,' ')
       )
      ;
        D_gest           := CUR_INPDAP.gest;
                  INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                   VALUES ( prenotazione
                          , 1
                          , D_pagina
                          , D_riga
                          , 'G'||
                            RPAD(NVL(D_inpdap_cf,' '),16,' ')||
                            LPAD(TO_CHAR(D_modulo),8,'0')||
                            LPAD(' ',4,' ')||
                            RPAD(CUR_ANA.cod_fis,16,' ')||
                            LPAD(' ',44,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'001'||
                            RPAD(CUR_ANA.cod_fis,16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'002'||
                            RPAD(SUBSTR(CUR_ANA.cognome,1,16),16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'002'||
                            DECODE( GREATEST(16,LENGTH(CUR_ANA.cognome))
                                  , 16, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(CUR_ANA.cognome,17,15)
                                                 ,15,' ')
                                  )||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'002'||
                            DECODE( GREATEST(31,LENGTH(CUR_ANA.cognome))
                                  , 31, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(CUR_ANA.cognome,32)
                                                 ,'15',' ')
                                  )||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'003'||
                            RPAD(SUBSTR(CUR_ANA.nome,1,16),16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'003'||
                            DECODE( GREATEST(16,LENGTH(CUR_ANA.nome))
                                  , 16, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(CUR_ANA.nome,17,15)
                                                 ,15,' ')
                                  )||
                            '{'
                          )
                   ;
D_conta_g:=D_conta_g+1;
--  Inserimento Secondo Record Dipendente
                       D_riga   := D_riga   + 1;
                   INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                   VALUES ( prenotazione
                          , 1
                          , D_pagina
                          , D_riga
                          , 'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'003'||
                            DECODE( GREATEST(31,LENGTH(CUR_ANA.nome))
                                  , 31, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(CUR_ANA.nome,32)
                                                 ,'15',' ')
                                  )||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'004'||
                            RPAD(CUR_ANA.sesso,16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'005'||
                            LPAD(CUR_ANA.data_nas,16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'006'||
                            RPAD(SUBSTR(CUR_ANA.com_nas,1,16),16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'006'||
                            DECODE( GREATEST(16,LENGTH(CUR_ANA.com_nas))
                                  , 16, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(CUR_ANA.com_nas,17,15)
                                                 ,15,' ')
                                  )||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'006'||
                            DECODE( GREATEST(31,LENGTH(CUR_ANA.com_nas))
                                  , 31, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(CUR_ANA.com_nas,32)
                                                 ,'15',' ')
                                  )||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'007'||
                            RPAD(CUR_ANA.prov_nas,16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'008'||
                            RPAD(NVL(D_qua_fiscale,' '),16,' ')||
                            '{'
                          )
                   ;
--  Inserimento Terzo Record Dipendente
                   D_riga   := D_riga   + 1;
                   INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                   VALUES ( prenotazione
                          , 1
                          , D_pagina
                          , D_riga
                          , 'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'009'||
                            RPAD(SUBSTR(D_com_cess,1,16),16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'009'||
                            DECODE( GREATEST(16,LENGTH(D_com_cess))
                                  , 16, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(D_com_cess,17,15)
                                                 ,15,' ')
                                  )||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'009'||
                            DECODE( GREATEST(31,LENGTH(D_com_cess))
                                  , 31, RPAD(' ',16,' ')
                                      , '+'||RPAD(SUBSTR(D_com_cess,32)
                                                 ,'15',' ')
                                  )||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'010'||
                            RPAD(NVL(D_prov_cess,' '),16,' ')||
                            'DA'||LPAD(TO_CHAR(D_num_ord),3,'0')||'011'||
                            RPAD(NVL(D_cod_catasto,' '),16,' ')||
                            '{'
                          )
                   ;
                    INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                    SELECT  prenotazione
                          , 1
                          , D_pagina
                          , 300
                          , '}'
                      FROM dual
                     WHERE NOT EXISTS
                          (SELECT 'x' FROM a_appoggio_stampe
                            WHERE no_prenotazione = prenotazione
                              AND no_passo        = 2
                              AND pagina          = D_pagina
                              AND riga            = 300)
                    ;
                 IF CUR_INPDAP.data_cess IS NOT NULL
                    AND CUR_INPDAP.causa_cess IS NULL THEN
                   BEGIN
                     SELECT evra.cat_inpdap
                       INTO D_inpdap_c_cess
                       FROM PERIODI_GIURIDICI pegi,
                            EVENTI_RAPPORTO   evra
                      WHERE pegi.rilevanza = 'P'
                        AND pegi.ci        = CUR_ANA.ci
                        AND pegi.posizione    = evra.codice
                        AND pegi.dal       =
                            (SELECT MAX(dal) FROM PERIODI_GIURIDICI
                              WHERE rilevanza = 'P'
                                AND ci        = CUR_ANA.ci
                                AND dal      <= D_al)
                     ;
                   EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      D_inpdap_c_cess := ' ';
                   END;
                 END IF;
                 D_riga := D_riga + 1;
                 INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                 VALUES
                 ( prenotazione
                 , 1
                 , D_pagina
                 , D_riga
                 , 'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'063'
                       ||RPAD(NVL(D_inpdap_cf,' '),16,' ')||
               'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'064'
                       ||LPAD(NVL(TO_CHAR(D_inpdap_data_decorrenza,'ddmmyyyy'),' '),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'065'
                       ||LPAD(NVL(TO_CHAR(D_inpdap_dal,'ddmmyyyy'),' '),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'066'
                       ||LPAD(NVL(TO_CHAR(D_inpdap_al,'ddmmyyyy'),' ') ,16,' ')||
         'DC'||lpad(to_char(D_num_ord),3,'0')||'067'||
                         decode(D_economico
                               ,'X', lpad(nvl(to_char(D_inpdap_gg_tfr),'0'),16,' ')
                                   , lpad(' ',16,' ')
                               )||
                'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'068'
                       ||LPAD(NVL(D_inpdap_c_cess,' '),16,' ')||
                   '{'
                 )
                 ;
                 D_riga:= D_riga + 1;
                 INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                 VALUES
                 ( prenotazione
                 , 1
                 , D_pagina
                 , D_riga
                 , 'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'069'
                       ||LPAD(NVL(SUBSTR(D_inpdap_ass,1,1),'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'070'
                       ||LPAD(NVL(SUBSTR(D_inpdap_ass,2,1),'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'071'
                       ||LPAD(NVL(SUBSTR(D_inpdap_ass,3,1),'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'072'
                       ||LPAD(NVL(SUBSTR(D_inpdap_ass,4,1),'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'073'
                       ||LPAD(NVL(D_inpdap_imp,'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'074'
                       ||LPAD(NVL(D_inpdap_serv,'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'075'
                       ||LPAD(NVL(D_inpdap_cassa,'0'),16,' ')||
                        'DC'||lpad(to_char(D_num_ord),3,'0')||'076'||
                        decode(D_economico
                               , 'X', lpad(nvl(D_inpdap_gg,'0'),16,' ')
                                    , lpad(' ',16,' ')
                              )||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'077'
                       ||LPAD(NVL(SUBSTR(D_inpdap_mag,1,3),'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'078'
                       ||LPAD(NVL(SUBSTR(D_inpdap_mag,4,3),'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'079'
                       ||LPAD(NVL(SUBSTR(D_inpdap_mag,7,3),'0'),16,' ')||
                   'DC'||LPAD(TO_CHAR(D_num_ord),3,'0')||'080'
                       ||LPAD(NVL(SUBSTR(D_inpdap_mag,10,3),'0'),16,' ')||
    decode(D_economico
                               , 'X', 'DC'||lpad(to_char(D_num_ord),3,'0')||'081'
                                          ||lpad(nvl(D_inpdap_fisse,'0'),16,' ')||
                                      'DC'||lpad(to_char(D_num_ord),3,'0')||'082'
                                          ||lpad(nvl(D_inpdap_acce,'0'),16,' ')
                                    , null )||
                   '{'
                 )
                 ;
   IF D_economico = 'X'
                  THEN
      D_riga:= D_riga + 1;
                    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                    values
                    ( prenotazione
                    , 1
                    , D_pagina
                    , D_riga
                 , 'DC'||lpad(to_char(D_num_ord),3,'0')||'083'
                       ||lpad(nvl(to_char(D_inpdap_comp_18),'0'),16,' ')||
                   'DC'||lpad(to_char(D_num_ord),3,'0')||'084'
                       ||lpad(nvl(D_inpdap_inadel,'0'),16,' ')||
                   'DC'||lpad(to_char(D_num_ord),3,'0')||'085'
                       ||lpad(nvl(D_inpdap_tfr,'0'),16,' ')||
                   'DC'||lpad(to_char(D_num_ord),3,'0')||'086'
                       ||lpad(nvl(D_inpdap_premio,'0'),16,' ')||
         'DC'||lpad(to_char(D_num_ord),3,'0')||'087'
                       ||lpad(nvl(to_char(D_inpdap_ind_non_a),'0'),16,' ')||
                   'DC'||lpad(to_char(D_num_ord),3,'0')||'088'
                       ||lpad(nvl(to_char(D_inpdap_l_165),'0'),16,' ')||
                   '{'
                 )
                 ;
                    END IF;
                 IF CUR_INPDAP.gest_cf = 'Z' THEN
       NULL;
                 ELSE D_inpdap_cf      := CUR_INPDAP.gest_cf;
                      D_inpdap_serv    := CUR_INPDAP.tipo_servizio;
                      D_inpdap_imp     := CUR_INPDAP.tipo_impiego;
                      D_inpdap_cess    := CUR_INPDAP.data_cess;
                      D_inpdap_c_cess  := CUR_INPDAP.causa_cess;
                      D_inpdap_ass     := CUR_INPDAP.ass;
                      D_inpdap_mag     := CUR_INPDAP.mag;
                      D_inpdap_dal     := CUR_INPDAP.dal;
                      D_inpdap_al      := CUR_INPDAP.al;
                      D_inpdap_cassa   := CUR_INPDAP.cassa_comp;
                      D_inpdap_gg      := CUR_INPDAP.gg_utili;
                      D_inpdap_fisse   := CUR_INPDAP.comp_fisse;
                      D_inpdap_acce    := CUR_INPDAP.comp_accessorie;
                      D_inpdap_inadel  := CUR_INPDAP.comp_inadel;
                      D_inpdap_tfr     := CUR_INPDAP.comp_tfr;
                      D_inpdap_premio  := CUR_INPDAP.premio_prod;
                      D_inpdap_ril     := CUR_INPDAP.rilevanza;
                      D_inpdap_rif     := CUR_INPDAP.riferimento;
                      D_inpdap_ind_non_a := CUR_INPDAP.ind_non_a;
                      D_inpdap_l_388     := CUR_INPDAP.legge_388;
                      D_inpdap_data_decorrenza := CUR_INPDAP.data_dec;
       D_inpdap_gg_tfr := CUR_INPDAP.gg_tfr;
       D_inpdap_l_165   := CUR_INPDAP.l_165;
       D_inpdap_comp_18 := CUR_INPDAP.comp_18;
                 END IF;
               END IF;
                END IF;
    END;
           END LOOP; -- cur_inpdap
      END LOOP; -- cur_ana
if D_cartolarizzazione != 'D' then
   FOR CUR_DIP IN
   (select  moco.ci ci,
            moco.voce voce,
            moco.sub  sub,
            to_char(moco.riferimento,'mm') mese,
            to_char(moco.riferimento,'yyyy') anno,
            esrc.colonna colonna,
            sum(nvl(imp,0)) somma,
            ragi.gestione  gestione
    from    movimenti_contabili moco,
            estrazione_righe_contabili esrc,
            estrazione_valori_contabili esvc,
            rapporti_giuridici          ragi
    where   moco.voce   =esrc.voce
    and     esvc.colonna=esrc.colonna
    and     esvc.dal    =esrc.dal
    and     esvc.estrazione = esrc.estrazione
    and     moco.sub =esrc.sub
    and     moco.anno=D_anno
    and     moco.mese=D_mese
    and     moco.mensilita != '*AP'
    and     esrc.estrazione='CARTOLARIZZAZIONE'
    and     moco.ci        = ragi.ci
    and exists (select 'x' from informazioni_retributive
                where ci = moco.ci
                and voce= moco.voce
                and sub = moco.sub
                and tipo = 'R'
                and (esvc.note is null
                or istituto = substr(esvc.note , instr(esvc.note,'<',  instr(esvc.note,istituto)-1) +1
                                               , instr(esvc.note,'>',  instr(esvc.note,istituto)) -1 - instr(esvc.note,'<',  instr(esvc.note,istituto)-1)
                                    )
                    )
                )
   AND EXISTS (SELECT 'x'
                    FROM DENUNCIA_INPDAP dein
              WHERE anno = D_anno
                AND ci = moco.ci
      AND gestione LIKE D_gestione
       )
   and exists
        (select 'x'
           from rapporti_individuali rain
          where rain.ci = moco.ci
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
          )
    group by moco.ci,moco.voce,
             moco.sub,
             to_char(moco.riferimento,'mm'),
             to_char(moco.riferimento,'yyyy'),
             esrc.colonna, ragi.gestione
   order by moco.ci)
   LOOP
    BEGIN
--dbms_output.put_line(cur_dip.ci);
    D_cess  := null;
    D_note  := null;
    D_pagina:=D_pagina+1;
    D_riga  :=D_riga+1;
         BEGIN
          SELECT anag.codice_fiscale  cod_fis
            INTO D_cod_fis_dic
            FROM ANAGRAFICI               anag
               , RAPPORTI_INDIVIDUALI     rain
           WHERE anag.ni  = rain.ni
             and rain.ci  = CUR_DIP.ci
             and anag.al is null;
         EXCEPTION
          WHEN NO_DATA_FOUND THEN D_cod_fis_dic := null;
          WHEN TOO_MANY_ROWS THEN
                  SELECT max(anag.codice_fiscale)  cod_fis
                    INTO D_cod_fis_dic
                    FROM ANAGRAFICI               anag
                       , RAPPORTI_INDIVIDUALI     rain
                   WHERE anag.ni  = rain.ni
                     and rain.ci  = CUR_DIP.ci
                     and anag.al is null;
         END;
    BEGIN
-- verifico se assunto o cessato nel periodo
      select 'X'
        into D_ass_cess
        from periodi_giuridici pegi
       where pegi.ci   = cur_dip.ci
         and rilevanza = 'P'
         and (pegi.dal between to_date('01/'||D_mese||'/'||D_anno,'dd/mm/yyyy')
                          and last_day(to_date('01/'||D_mese||'/'||D_anno,'dd/mm/yyyy'))
         or nvl(pegi.al,to_date('3333333','j'))
             between to_date('01/'||D_mese||'/'||D_anno,'dd/mm/yyyy')
                 and last_day(to_date('01/'||D_mese||'/'||D_anno,'dd/mm/yyyy')));
         raise too_many_rows;
       exception
        when no_data_found then D_ass_cess:=null;
        when too_many_rows then D_ass_cess:='X';
     end;
    BEGIN -- determino cessazione per record MC001013
      select decode(evra.cat_inpdap,'3', 'S'
                                   ,'4', 'S'
                                   ,'19', 'S'
                                   ,'20', 'S'
                                        ,'N')
        into D_cess
        from periodi_giuridici pegi, eventi_rapporto evra
       where pegi.ci   = cur_dip.ci
         and pegi.rilevanza = 'P'
         and nvl(pegi.al,to_date('3333333','j'))
             between to_date('01/'||D_mese||'/'||D_anno,'dd/mm/yyyy')
                 and last_day(to_date('01/'||D_mese||'/'||D_anno,'dd/mm/yyyy'))
         and pegi.posizione = evra.codice (+)
         and evra.rilevanza = 'T';
       EXCEPTION
        when no_data_found then D_cess:=null;
        when too_many_rows then D_cess:='N';
     END;
     if D_ass_cess='X' then
      begin
      select substr(note,instr(note,'COD.AMM:')+8,16)
      into D_note
      from informazioni_retributive
      where ci=cur_dip.ci
      and   voce=cur_dip.voce
      and   sub=cur_dip.sub
      AND   INSTR(NOTE,'COD.AMM:')!= 0;
      exception
      when no_data_found then D_note:=null;
      when too_many_rows then
       begin
        select max(substr(note,instr(note,'COD.AMM:')+8,16))
         into D_note
         from informazioni_retributive
         where ci=cur_dip.ci
         and   voce=cur_dip.voce
         and   sub=cur_dip.sub;
       end;
      end;
     ELSE
        D_NOTE:= NULL;
     end if;
    D_modulo_m := D_modulo_m + 1;
    IF D_cartolarizzazione = 'C' THEN
                   INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
            VALUES ( prenotazione
             , 1
            , D_pagina
        , 0
        , LPAD(CUR_DIP.CI,8)||
                                   rpad(cur_dip.gestione,8,' ')
       )
      ;
    END IF;
            INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
            VALUES ( prenotazione
                   , 1
                   , d_pagina
                   , 1
                   , 'M'||
                     rpad(nvl(D_cod_fis,' '),11,' ')||
                     lpad(nvl(to_char(D_progr_inpdap),' '),5,' ')||
                     LPAD(nvl(TO_CHAR(D_modulo_m),'0'),8,'0')||
                     LPAD(' ',4,' ')||
                     RPAD(nvl(D_cod_fis_dic,' '),16,' ')||
                    LPAD(' ',44,' ')||
                          'MC001001'||RPAD('L',16,' ')||
                          'MC001002'||RPAD(' ',16,' ')||
                          'MC001003'||RPAD(nvl(D_cod_fis,' '),16,' ')||
                          'MC001004'||RPAD(' ',16,' ')||
                          'MC001005'||RPAD(' ',16,' ')||
                          'MC001006'||RPAD(nvl(D_note,' '),16,' ')||
                          'MC001007'||LPAD('0',16,' ')||
                          'MC001008'||RPAD(' ',16,' ')||
                          'MC001009'||LPAD('0',16,' ')||
                          'MC001010'||RPAD('0',16,' ')||
                          'MC001011'||LPAD(nvl(D_mese,' '),16,' ')||
                          'MC001012'||LPAD(nvl(D_anno,' '),16,' ')||
                          'MC001013'||RPAD(nvl(D_cess,' '),16,' ')||            -- Da valutare
                          'MP001001'||RPAD(nvl(D_rif_vers,' '),16,' ')||
                          'MP001002'||RPAD(nvl(D_tipo_pag,' '),16,' ')||
                          'MP001003'||LPAD(nvl(D_numero_distinta,' '),16,' ')||
                          'MP001004'||RPAD(nvl(to_char(D_data_pag,'ddmmyyyy'),' '),16,' ')||
                          'MP001005'||RPAD(nvl(decode(sign(cur_dip.somma)
                                                     ,-1,'V'
                                                     , 1,'R'
                                                        ,' ')
                                              ,' '),16,' ')||
                          'MP001006'||LPAD(nvl(translate( to_char(abs(cur_dip.somma),'999999999990.00')
                                                        , '.',','),' '),16,' ')||
                          'MP001007'||RPAD(nvl(cur_dip.colonna,' '),16,' ')||
                          'MP001008'||LPAD(nvl(cur_dip.mese,' '),16,' ')||
                          'MP001009'||LPAD(nvl(cur_dip.anno,' '),16,' ')
     )
    ;
    END;
    END LOOP;
end if;
if D_cartolarizzazione != 'D' then
d_pagina:=d_pagina+1;
           INSERT INTO a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                VALUES ( prenotazione
                       , 1
                     , d_pagina
                  , 1
                       , 'Z'||
                         lpad(' ',14,' ')||
                         lpad('1',9,'0')||
                         lpad('0',9,'0')||
                         lpad('0',9,'0')||
                         lpad(D_conta_g,9,'0')||
                         lpad('0',9,'0')||
                         lpad(' ',1837,' ')||
                         'A'||
                         lpad(' ',2,' ')
          )
                        ;
end if;
            COMMIT;
  END;
EXCEPTION
  WHEN ESCI THEN NULL;
END;
END;
END Pecsmdpm;
/
