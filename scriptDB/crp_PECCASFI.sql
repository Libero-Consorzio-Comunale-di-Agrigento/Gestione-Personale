CREATE OR REPLACE PACKAGE PECCASFI IS
/******************************************************************************
 NOME:          PECCASFI Archiviazione Assistenza Fiscale per 770

 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/06/2006 MS     Prima Emissione - Modello 770/06
 1.1  13/06/2006 MS     Aggiunto campo per casella "integrativo"
 1.2  19/06/2006 MS     Controllo sui ref_codes
 1.3  23/08/2006 ML     Modificato controllo validità anagrafe del caaf. (A17326).
 1.4  29/08/2006 MS     Aggiunta controlli per Att. 17360
 1.5  14/06/2007 MS     Aggiunti controlli per report Att. 17300
 1.6  19/06/2007 MS     Correzioni da test
 1.7  03/09/2007 MS     Correzione archiviazione importi da rimborsare errati
 1.8  05/09/2007 MS     Tempi di elaborazione
 1.9  18/09/2007 MS     Correzione segnalazione errata
 1.10 15/11/2007 MS     Introduzione nuove specifiche nei controlli
******************************************************************************/

 FUNCTION  VERSIONE              RETURN VARCHAR2;
 FUNCTION INS_APST_IMPORTI ( D_importo in number ) RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCASFI IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.10 del 15/11/2007';
   END VERSIONE;
FUNCTION INS_APST_IMPORTI 
( D_importo in number ) RETURN VARCHAR2 IS
D_imp_char VARCHAR2(16) := null;
BEGIN
   BEGIN
    select decode(sign(nvl(D_importo,0))
                       ,-1, '-'||lpad(abs(nvl(D_importo,0)),15,0)
                          , lpad(nvl(D_importo,0),16,0)
                       )
      into D_imp_char
      from dual;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      D_imp_char := lpad('0',16,'0'); 
   END;
   RETURN D_imp_char;
END INS_APST_IMPORTI;

PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE
-- Depositi e Contatori Vari
  D_ente            VARCHAR(4);
  D_ambiente        VARCHAR(8);
  D_utente          VARCHAR(8);
  D_riga            number := 0;
  D_riga_0          number := 0;
  D_errore          VARCHAR(6);
  D_precisazione    VARCHAR(50);
  D_step            varchar2(200);

-- Variabili da Parametri
  P_anno            number;
  P_ini_a           date;
  P_fin_a           date;
  P_gestione        VARCHAR(4);
  P_tipo            VARCHAR(1);
  P_ci              NUMBER(8);
  P_controlli       VARCHAR(1);
  P_tipo_controlli  VARCHAR(1);

-- Variabili di Exception
  USCITA               EXCEPTION;

-- Variabili di dettaglio
  D_da_trattare     varchar2(1);
  D_esito_cong      varchar2(1);
  D_rettifica       varchar2(1);
  D_esito_2r        varchar2(1);
  D_esito_cong1     varchar2(1);
  D_tot_rate        varchar2(1);
  D_caaf_nome       varchar2(40);
  D_caaf_cod_fis    varchar2(16);
  D_caaf_nr_albo    varchar2(16);
  D_cod_r_dic_db    varchar2(16);
  D_cod_r_con_db    varchar2(16);
  D_cod_r_dic_cr    varchar2(16);
  D_cod_r_con_cr    varchar2(16);
  D_cod_c_dic_db    varchar2(16);
  D_cod_c_con_db    varchar2(16);
  D_cod_c_dic_cr    varchar2(16);
  D_cod_c_con_cr    varchar2(16);
  D_c_irpef_cr      number;
  D_c_irpef_db      number;
  D_c_irpef_1r      number;
  D_c_irpef_2r      number;
  D_c_irpef_ap      number;
  D_c_add_r_cr      number;
  D_c_add_r_db      number;
  D_c_add_r_crc     number;
  D_c_add_r_dbc     number;
  D_c_add_c_cr      number;
  D_c_add_c_db      number;
  D_c_add_c_crc     number;
  D_c_add_c_dbc     number;
  D_c_tipo_cong     varchar2(1);
  D_c_rett          varchar2(1);
  D_st_tipo         varchar2(1);
  D_non_terminato   varchar2(1) := '';
  D_irpef_1r_int    number;
  D_irpef_ri1r      number;
  D_irpef_ret_1r    number;
  D_add_r_int       number;
  D_add_r_ris       number;
  D_add_r_intc      number;
  D_irpef_ris       number;
  D_irpef_int       number;
  D_mese            number;
  D_irpef_cr        number;
  D_irpef_db        number;
  D_irpef_1r        number;
  D_irpef_2r        number;
  D_irpef_2r_int    number;
  D_irpef_ret_2r    number;
  D_irpef_ap        number;
  D_add_r_cr        number;
  D_add_r_db        number;
  D_add_r_crc       number;
  D_add_r_dbc       number;
  D_add_c_dbc       number;
  D_add_c_db        number;
  D_add_c_cr        number;
  D_add_c_crc       number;
  D_add_r_risc      number;
  D_add_c_int       number;
  D_add_c_ris       number;
  D_add_c_intc      number;
  D_add_c_risc      number;
  D_irpef_ap_int    number;
  D_irpef_riap      number;
  D_irpef_ret_ap    number;
  D_r_mese          number;
  D_rt_mese1        number;
  D_rt_mese2        number;
  D_r_irpef_db      number;
  D_r_irpef_cr      number;
  D_r_irpef_1r      number;
  D_r_irpef_2r      number;
  D_r_irpef_int     number;
  D_r_irpef_1r_int  number;
  D_r_irpef_ris     number;
  D_r_irpef_ap      number;
  D_r_add_r_db      number;
  D_r_add_r_dbc     number;
  D_r_add_c_db      number;
  D_r_add_c_dbc     number;
  T_irpef_cr        number;
  T_irpef_db        number;
  T_irpef_1r        number;
  T_irpef_2r        number;
  T_irpef_ap        number;
  T_add_r_cr        number;
  T_add_r_db        number;
  T_add_r_crc       number;
  T_add_r_dbc       number;
  T_add_c_cr        number;
  T_add_c_db        number;
  T_add_c_crc       number;
  T_add_c_dbc       number;
  V_controllo       varchar2(2);
  D_archiviato      varchar2(1);
  D_annotazione     varchar2(200);

--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
 BEGIN -- parametri
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
    SELECT substr(valore,1,4)
         , to_date('01'||substr(valore,1,4),'mmyyyy')
         , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
      INTO P_anno
         , P_ini_a
         , P_fin_a
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT anno
           , to_date('01'||to_char(anno),'mmyyyy')
           , to_date('3112'||to_char(anno),'ddmmyyyy')
        INTO P_anno
           , P_ini_a
           , P_fin_a
        FROM RIFERIMENTO_FINE_ANNO
       WHERE rifa_id = 'RIFA'
      ;
  END;

  BEGIN
    SELECT valore
      INTO P_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GESTIONE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_gestione := NULL;
  END;

  BEGIN
    SELECT valore
      INTO P_tipo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_tipo := NULL;
  END;

  BEGIN
    SELECT valore
      INTO P_ci
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_ci := 0;
  END;

  IF nvl(P_ci,0) = 0 and P_tipo = 'S' THEN
     D_errore := 'A05721';
     RAISE USCITA;
  ELSIF nvl(P_ci,0) != 0 and P_tipo = 'T' THEN
     D_errore := 'A05721';
     RAISE USCITA;
  END IF;

  BEGIN
    SELECT valore
      INTO P_controlli
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CONTROLLI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_controlli := NULL;
  END;

  BEGIN
    SELECT valore
      INTO P_tipo_controlli
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO_CONTROLLI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_tipo_controlli := 'T';
  END;
 END; -- parametri
  IF nvl(P_controlli,' ') = ' ' THEN
--
-- Cancellazione Archiviazione precedente relativa all'anno richiesto
--
  LOCK TABLE ARCHIVIO_ASSISTENZA_FISCALE IN EXCLUSIVE MODE NOWAIT
  ;
  DELETE FROM ARCHIVIO_ASSISTENZA_FISCALE asfi
   WHERE asfi.anno             = P_anno
     AND asfi.ci IN ( SELECT ci
                        FROM PERIODI_RETRIBUTIVI
                       WHERE asfi.ci = ci
                         AND gestione LIKE P_gestione 
                         AND to_char(periodo,'yyyy') = P_anno
                         AND upper(competenza) in ( 'A', 'C', 'P' )
                    )
     AND (  P_tipo = 'T'
       OR ( P_tipo IN ('I','V','P') 
            AND NOT EXISTS
                ( SELECT 'x' FROM ARCHIVIO_ASSISTENZA_FISCALE asfi1
                   WHERE asfi1.anno       = asfi.anno
                     AND asfi1.ci         = asfi.ci
                     AND NVL(tipo_agg,' ') = DECODE(P_tipo ,'P',tipo_agg, P_tipo)
                 )
              )
        OR ( P_tipo = 'S' AND asfi.ci = P_ci
           )
          )
     AND EXISTS
        (SELECT 'x'
           FROM RAPPORTI_INDIVIDUALI rain
          WHERE rain.ci = asfi.ci
            AND (   rain.CC IS NULL
                 OR EXISTS
                   (SELECT 'x'
                      FROM a_competenze
                     WHERE ENTE        = D_ente
                       AND ambiente    = D_ambiente
                       AND utente      = D_utente
                       AND competenza  = 'CI'
                       AND oggetto     = rain.CC
                   )
                )
        )
  ;
 COMMIT;
-- dbms_output.put_line('Cancellazione effettuata: ');
  FOR CUR_CI IN
  ( select distinct rain.ci 
      from RAPPORTI_INDIVIDUALI rain
         , PERIODI_RETRIBUTIVI  pere
     where rain.ci = pere.ci
       and pere.gestione LIKE P_gestione 
       AND to_char(pere.periodo,'yyyy') = P_anno
       AND upper(pere.competenza) in ( 'A', 'C', 'P' )
       and ( P_tipo = 'T'
        or ( P_tipo IN ('I','V','P') 
            and NOT EXISTS
               ( SELECT 'x' FROM ARCHIVIO_ASSISTENZA_FISCALE asfi
                  where asfi.anno  = P_anno
                    and asfi.ci    = rain.ci
                    and NVL(tipo_agg,' ') = DECODE(P_tipo ,'P',tipo_agg, P_tipo)
               )
           )
        or ( P_tipo = 'S' AND rain.ci = P_ci )
           )
       and (   rain.CC IS NULL
            or EXISTS  ( select 'x'
                           from a_competenze
                          WHERE ENTE        = D_ente
                            AND ambiente    = D_ambiente
                            AND utente      = D_utente
                            AND competenza  = 'CI'
                            AND oggetto     = rain.CC
                        )
           )
  ) LOOP
-- dbms_output.put_line('CI: '||CUR_CI.ci);

  BEGIN
     select 'X' 
       into D_da_trattare
       from dual
      where ( exists ( select 'x'
                         from denuncia_caaf deca
                        where anno (+) = P_anno - 1
                          and tipo (+) = 0
                          and deca.ci  = CUR_CI.ci
                          and (  nvl(conguaglio_1r,' ') != ' '
                             or nvl(conguaglio_2r,' ') != ' ')
                     )
           or exists ( select 'x'
                         from movimenti_contabili moco
                        where anno     = P_anno
                          and mese    >= 5
                          and ci       = CUR_CI.ci
                          and voce    in ( select codice from voci_economiche
                                           where specifica in
                                           ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
                                           ,'IRPEF_AP','IRPEF_APC','ADD_R_DBC'
                                           ,'ADD_R_DB','ADD_R_CR','ADD_R_CRC'
                                           ,'ADD_R_RAS','ADD_R_RASC','ADD_R_RIS'
                                           ,'ADD_R_RISC','ADD_R_INT','ADD_R_INTC'
                                           ,'IRPEF_SINT','IRPEF_1INT'
                                           ,'IRPEF_AINT','IRPEF_AINC','IRPEF_2R'
                                           ,'IRPEF_2INT'
                                           ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
                                           ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
                                           ,'IRPEF_RAPC','IRPEF_RIAC'
                                           ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP'
                                           ,'ADD_C_CR','ADD_C_DB','ADD_C_RAS'
                                           ,'ADD_C_INT','ADD_C_RIS','ADD_C_CRC'
                                           ,'ADD_C_DBC','ADD_C_RASC','ADD_C_INTC'
                                           ,'ADD_C_RISC','IRPEF_1RC','IRPEF_2RC'
                                           ,'IRPEF_1INC','IRPEF_1SOC','IRPEF_2INC'
                                           ,'IRPEF_2SOC','IRPEF_RA1C','IRPEF_RI1C')
                                        )
                        )
         )
    ;
  EXCEPTION 
       WHEN NO_DATA_FOUND THEN
            D_da_trattare := '';
  END;
  IF D_da_trattare = 'X' THEN
  BEGIN
       D_esito_cong     := null;
       D_esito_2r       := null;
       D_esito_cong1    := null;
       D_tot_rate        := null;
       D_caaf_nome       := null;
       D_caaf_cod_fis    := null;
       D_caaf_nr_albo    := null;
       D_cod_r_dic_db    := null;
       D_cod_r_con_db    := null;
       D_cod_r_dic_cr    := null;
       D_cod_r_con_cr    := null;
       D_cod_c_dic_db    := null;
       D_cod_c_con_db    := null;
       D_cod_c_dic_cr    := null;
       D_cod_c_con_cr    := null;
       D_c_irpef_cr      := null;
       D_c_irpef_db      := null;
       D_c_irpef_1r      := null;
       D_c_irpef_2r      := null;
       D_c_irpef_ap      := null;
       D_c_add_r_cr      := null;
       D_c_add_r_db      := null;
       D_c_add_r_crc     := null;
       D_c_add_r_dbc     := null;
       D_c_add_c_cr      := null;
       D_c_add_c_db      := null;
       D_c_add_c_crc     := null;
       D_c_add_c_dbc     := null;
       D_c_tipo_cong     := null;
       D_c_rett          := null;
       D_st_tipo         := null;
       T_irpef_cr        := null;
       T_irpef_db        := null;
       T_irpef_1r        := null;
       T_irpef_2r        := null;
       T_irpef_ap        := null;
       T_add_r_cr        := null;
       T_add_r_db        := null;
       T_add_r_crc       := null;
       T_add_r_dbc       := null;
       T_add_c_cr        := null;
       T_add_c_db        := null;
       T_add_c_crc       := null;
       T_add_c_dbc       := null;
       D_mese := null;
       D_irpef_db := null;
       D_irpef_cr := null;
       D_irpef_int := null;
       D_irpef_ris := null;
       D_irpef_1r := null;
       D_irpef_1r_int := null;
       D_irpef_ri1r := null;
       D_irpef_ret_1r := null;
       D_irpef_ap := null;
       D_irpef_ap_int := null;
       D_irpef_riap := null;
       D_irpef_ret_ap := null;
       D_add_r_dbc := null;
       D_add_r_db := null;
       D_add_r_cr := null;
       D_add_r_crc := null;
       D_add_r_ris := null;
       D_add_r_risc := null;
       D_add_r_int := null;
       D_add_r_intc := null;
       D_add_c_dbc := null;
       D_add_c_db := null;
       D_add_c_cr := null;
       D_add_c_crc := null;
       D_add_c_ris := null;
       D_add_c_risc := null;
       D_add_c_int := null;
       D_add_c_intc := null;
       D_r_irpef_db := null;
       D_r_irpef_cr := null;
       D_r_irpef_1r := null;
       D_r_irpef_2r := null;
       D_r_irpef_ap := null;
       D_r_add_r_db := null;
       D_r_add_r_dbc := null;
       D_r_add_c_db := null;
       D_r_add_c_dbc := null;
       V_controllo := null;

       --
       --  Estrazione Dati 730 da CAAF
       --
       BEGIN
       D_step := 'Select dati Denuncia_caaf';
       select max(deca.conguaglio_1r)                    esito_cong
            , max(deca.rettifica)                        tipo
            , max(decode(conguaglio_2r,'F','A',null))    esito_2r
            , max(decode(conguaglio_2r,'F',null,'P','F',conguaglio_2r))  esito_cong1
            , nvl(to_char(max(deca.nr_rate)),'0')        tot_rate
            , max(nvl(to_char(cod_reg_dic_db),' '))    cod_r_dic_db
            , max(nvl(to_char(cod_reg_con_db),' '))    cod_r_con_db
            , max(nvl(to_char(cod_reg_dic_cr),' '))    cod_r_dic_cr
            , max(nvl(to_char(cod_reg_con_cr),' '))    cod_r_con_cr
            , max(nvl(cod_com_dic_db,' '))    cod_c_dic_db
            , max(nvl(cod_com_con_db,' '))    cod_c_con_db
            , max(nvl(cod_com_dic_cr,' '))    cod_c_dic_cr
            , max(nvl(cod_com_con_cr,' '))    cod_c_con_cr
            , nvl(sum(irpef_cr),0)
            , nvl(sum(irpef_db),0)
            , nvl(sum(irpef_1r),0)+nvl(sum(irpef_1r_con),0)
            , nvl(sum(irpef_2r),0)+nvl(sum(irpef_2r_con),0)
            , sum(irpef_acconto_ap) + sum(irpef_acconto_ap_con)
            , nvl(sum(add_reg_dic_cr),0)
            , nvl(sum(add_reg_dic_db),0)
            , nvl(sum(add_reg_con_cr),0)
            , nvl(sum(add_reg_con_db),0)
            , nvl(sum(add_com_dic_cr),0)
            , nvl(sum(add_com_dic_db),0)
            , nvl(sum(add_com_con_cr),0)
            , nvl(sum(add_com_con_db),0)
            , decode(max(rettifica),'C','A'
                              ,'E','B'
                              ,'G','C'
                                    , decode(max(conguaglio_1r),'H','D',null)
                                  )
            , decode(max(rettifica)
                              ,'B','A'
                              ,'D','B'
                              ,'F','C'
                              ,'H','D'
                              ,'L','E'
                                  ,null)
            , max(decode( deca.rettifica,'1', null,deca.rettifica))
         into D_esito_cong
            , D_rettifica
            , D_esito_2r
            , D_esito_cong1
            , D_tot_rate
            , D_cod_r_dic_db
            , D_cod_r_con_db
            , D_cod_r_dic_cr
            , D_cod_r_con_cr
            , D_cod_c_dic_db
            , D_cod_c_con_db
            , D_cod_c_dic_cr
            , D_cod_c_con_cr
            , D_c_irpef_cr
            , D_c_irpef_db
            , D_c_irpef_1r
            , D_c_irpef_2r
            , D_c_irpef_ap
            , D_c_add_r_cr
            , D_c_add_r_db
            , D_c_add_r_crc
            , D_c_add_r_dbc
            , D_c_add_c_cr
            , D_c_add_c_db
            , D_c_add_c_crc
            , D_c_add_c_dbc
            , D_c_tipo_cong
            , D_c_rett
            , D_st_tipo
         from anagrafici     caaf
            , denuncia_caaf  deca
        where deca.anno      = P_anno - 1
          and rettifica     != 'M'
          and deca.ci        = CUR_CI.ci
          and deca.tipo      = 0
          and caaf.ni        =
             ( select ni from rapporti_individuali
                where ci = deca.ci_caaf )
          and to_date('3112'||P_anno - 1,'ddmmyyyy')  between caaf.dal and nvl(caaf.al,to_date('3333333','j'))
       ;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN 
         D_esito_cong    := null;
         D_rettifica     := null;
         D_esito_2r      := null;
         D_esito_cong1   := null;
         D_tot_rate      := null;
         D_cod_r_dic_db  := null;
         D_cod_r_con_db  := null;
         D_cod_r_dic_cr  := null;
         D_cod_r_con_cr  := null;
         D_cod_c_dic_db  := null;
         D_cod_c_con_db  := null;
         D_cod_c_dic_cr  := null;
         D_cod_c_con_cr  := null;
         D_c_irpef_cr    := null;
         D_c_irpef_db    := null;
         D_c_irpef_1r    := null;
         D_c_irpef_2r    := null;
         D_c_irpef_ap    := null;
         D_c_add_r_cr    := null;
         D_c_add_r_db    := null;
         D_c_add_r_crc   := null;
         D_c_add_r_dbc   := null;
         D_c_add_c_cr    := null;
         D_c_add_c_db    := null;
         D_c_add_c_crc   := null;
         D_c_add_c_dbc   := null;
         D_c_tipo_cong   := null;
         D_c_rett        := null;
         D_st_tipo       := null;
       END;

       T_irpef_cr     := D_c_irpef_cr;
       T_irpef_db     := D_c_irpef_db;
       T_irpef_1r     := D_c_irpef_1r;
       T_irpef_2r     := D_c_irpef_2r;
       T_irpef_ap     := D_c_irpef_ap;
       T_add_r_cr     := D_c_add_r_cr;
       T_add_r_db     := D_c_add_r_db;
       T_add_r_crc    := D_c_add_r_crc;
       T_add_r_dbc    := D_c_add_r_dbc;
       T_add_c_cr     := D_c_add_c_cr;
       T_add_c_db     := D_c_add_c_db;
       T_add_c_crc    := D_c_add_c_crc;
       T_add_c_dbc    := D_c_add_c_dbc;

       D_step := 'Select dati Movimenti Contabili';
       BEGIN
       select min(decode(moco.mese,5,7,6,7,moco.mese))
            ,  sum(decode( voec.specifica
                            , 'IRPEF_DB', nvl(moco.imp,0)
                            , 'IRPEF_RAS',nvl(moco.imp,0)
                                        , 0)) * -1      irpef_db
            ,  sum(decode( voec.specifica
                            , 'IRPEF_CR', nvl(moco.imp,0)
                                        , 0))           irpef_cr
            ,  sum(decode( voec.specifica
                            , 'IRPEF_SINT', nvl(moco.imp,0)
                                          , 0)) * -1    irpef_int
            ,  sum(decode( voec.specifica
                            , 'IRPEF_RIS' , nvl(moco.imp,0)
                                          , 0)) * -1    irpef_ris
            ,  sum(decode( voec.specifica
                            , 'IRPEF_1R', nvl(moco.imp,0)
                            , 'IRPEF_1RC', nvl(moco.imp,0)
                            , 'IRPEF_RA1R', nvl(moco.imp,0)
                            , 'IRPEF_RA1C', nvl(moco.imp,0)
                                        , 0)) * -1      irpef_1r
            ,  sum(decode( voec.specifica
                            , 'IRPEF_1INT', nvl(moco.imp,0)
                            , 'IRPEF_1INC', nvl(moco.imp,0)
                                          , 0)) * -1    irpef_1r_int
            ,  sum(decode( voec.specifica
                            , 'IRPEF_RI1R', nvl(moco.imp,0)
                            , 'IRPEF_RI1C', nvl(moco.imp,0)
                                          , 0)) * -1    irpef_ri1r
            ,  sum(decode( voec.specifica
                            , 'IRP_RET_1R', nvl(moco.imp,0)
                                          , 0))         irpef_ret_1r
            ,  sum(decode( voec.specifica
                            , 'IRPEF_AP', nvl(moco.imp,0)
                            , 'IRPEF_RAAP',nvl(moco.imp,0)
                            , 'IRPEF_APC',nvl(moco.imp,0)
                            , 'IRPEF_RAPC',nvl(moco.imp,0)
                                        , 0)) * -1      irpef_ap
            ,  sum(decode( voec.specifica
                            , 'IRPEF_AINT', nvl(moco.imp,0)
                            , 'IRPEF_AINC', nvl(moco.imp,0)
                                          , 0)) * -1    irpef_ap_int
            ,  sum(decode( voec.specifica
                            , 'IRPEF_RIAP', nvl(moco.imp,0)
                            , 'IRPEF_RIAC', nvl(moco.imp,0)
                                          , 0)) * -1    irpef_riap
            ,  sum(decode( voec.specifica
                            , 'IRP_RET_AP', nvl(moco.imp,0)
                                          , 0))         irpef_ret_ap
            ,  sum(decode( voec.specifica
                            , 'ADD_R_DBC',  nvl(moco.imp,0)
                            , 'ADD_R_RASC', nvl(moco.imp,0)
                                          , 0)) * -1    add_r_dbc
            ,  sum(decode( voec.specifica
                            , 'ADD_R_DB',   nvl(moco.imp,0)
                            , 'ADD_R_RAS',  nvl(moco.imp,0)
                                          , 0)) * -1    add_r_db
            ,  sum(decode( voec.specifica
                            , 'ADD_R_CR',   nvl(moco.imp,0)
                                          , 0))         add_r_cr
            ,  sum(decode( voec.specifica
                            , 'ADD_R_CRC',  nvl(moco.imp,0)
                                          , 0))         add_r_crc
            ,  sum(decode( voec.specifica
                            , 'ADD_R_RIS',  nvl(moco.imp,0)
                                          , 0)) * -1    add_r_ris
            ,  sum(decode( voec.specifica
                            , 'ADD_R_RISC', nvl(moco.imp,0)
                                          , 0)) * -1    add_r_risc
            ,  sum(decode( voec.specifica
                            , 'ADD_R_INT',  nvl(moco.imp,0)
                                          , 0)) * -1    add_r_int
            ,  sum(decode( voec.specifica
                            , 'ADD_R_INTC', nvl(moco.imp,0)
                                          , 0)) * -1    add_r_intc
            ,  sum(decode( voec.specifica
                            , 'ADD_C_DBC',  nvl(moco.imp,0)
                            , 'ADD_C_RASC', nvl(moco.imp,0)
                                          , 0)) * -1    add_c_dbc
            ,  sum(decode( voec.specifica
                            , 'ADD_C_DB',   nvl(moco.imp,0)
                            , 'ADD_C_RAS',  nvl(moco.imp,0)
                                          , 0)) * -1    add_c_db
            ,  sum(decode( voec.specifica
                            , 'ADD_C_CR',   nvl(moco.imp,0)
                                          , 0))         add_c_cr
            ,  sum(decode( voec.specifica
                            , 'ADD_C_CRC',  nvl(moco.imp,0)
                                          , 0))         add_c_crc
            ,  sum(decode( voec.specifica
                            , 'ADD_C_RIS',  nvl(moco.imp,0)
                                          , 0)) * -1    add_c_ris
            ,  sum(decode( voec.specifica
                            , 'ADD_C_RISC', nvl(moco.imp,0)
                                          , 0)) * -1    add_c_risc
            ,  sum(decode( voec.specifica
                            , 'ADD_C_INT',  nvl(moco.imp,0)
                                          , 0)) * -1    add_c_int
            ,  sum(decode( voec.specifica
                            , 'ADD_C_INTC', nvl(moco.imp,0)
                                          , 0)) * -1    add_c_intc
         into D_mese,
              D_irpef_db,D_irpef_cr,
              D_irpef_int,D_irpef_ris,D_irpef_1r,
              D_irpef_1r_int,D_irpef_ri1r,D_irpef_ret_1r,
              D_irpef_ap,D_irpef_ap_int,D_irpef_riap,
              D_irpef_ret_ap,D_add_r_dbc,D_add_r_db,
              D_add_r_cr,D_add_r_crc,D_add_r_ris,
              D_add_r_risc,D_add_r_int,D_add_r_intc,
              D_add_c_dbc,D_add_c_db,D_add_c_cr,
              D_add_c_crc,D_add_c_ris,D_add_c_risc,
              D_add_c_int,D_add_c_intc
         from movimenti_contabili   moco
            , voci_economiche       voec
        where moco.anno (+)    = P_anno
          and moco.mese         >= 5
          and moco.ci            = CUR_CI.ci
          and moco.voce          = voec.codice
          and voec.specifica in
               ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
               ,'IRPEF_AP','IRPEF_APC','ADD_R_DBC'
               ,'ADD_R_DB','ADD_R_CR','ADD_R_CRC'
               ,'ADD_R_RAS','ADD_R_RASC','ADD_R_RIS'
               ,'ADD_R_RISC','ADD_R_INT','ADD_R_INTC'
               ,'IRPEF_SINT','IRPEF_1INT'
               ,'IRPEF_AINT','IRPEF_AINC'
               ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
               ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
               ,'IRPEF_RAPC','IRPEF_RIAC'
               ,'IRP_RET_1R','IRP_RET_AP'
               ,'ADD_C_CR','ADD_C_DB','ADD_C_RAS'
               ,'ADD_C_INT','ADD_C_RIS','ADD_C_CRC'
               ,'ADD_C_DBC','ADD_C_RASC','ADD_C_INTC'
               ,'ADD_C_RISC','IRPEF_1RC'
               ,'IRPEF_1INC','IRPEF_1SOC'
               ,'IRPEF_RA1C','IRPEF_RI1C')
      ;
       exception
            when no_data_found then null;
       end;

        BEGIN
          D_step := '2 Select dati Denuncia_caaf';
          select D_c_irpef_db - nvl(deca.irpef_db,0)     irpef_db
               , D_c_irpef_cr - nvl(deca.irpef_cr,0)     irpef_cr
               , D_c_irpef_1r - nvl(deca.irpef_1r,0)     irpef_1r
               , D_c_irpef_2r - nvl(deca.irpef_2r,0)     irpef_2r
               , D_c_irpef_ap - nvl(deca.irpef_acconto_ap,0)  irpef_ap
               , D_c_add_r_db  - nvl(deca.add_reg_dic_db,0)   add_r_db
               , D_c_add_r_dbc - nvl(deca.add_reg_con_db,0)   add_r_dbc
               , D_c_add_c_db  - nvl(deca.add_com_dic_db,0)   add_c_db
               , D_c_add_c_dbc - nvl(deca.add_com_con_db,0)   add_c_dbc
            into D_r_irpef_db,D_r_irpef_cr,D_r_irpef_1r,
                 D_r_irpef_2r,D_r_irpef_ap,
                 D_r_add_r_db,D_r_add_r_dbc,D_r_add_c_db,
                 D_r_add_c_dbc
            from denuncia_caaf     deca
           where deca.anno         = P_anno - 1
             and deca.ci           = CUR_CI.ci
             and deca.rettifica    = 'M'
             and nvl(deca.irpef_cr,0)
                 + nvl(deca.irpef_db,0)
                 + nvl(deca.irpef_1r,0)
                 + nvl(deca.irpef_2r,0)
                 + nvl(deca.add_reg_dic_db,0)
                 + nvl(deca.add_reg_con_db,0)
                 + nvl(deca.add_reg_dic_cr,0)
                 + nvl(deca.add_reg_con_cr,0)
                 + nvl(deca.add_com_dic_db,0)
                 + nvl(deca.add_com_con_db,0)
                 + nvl(deca.add_com_dic_cr,0)
                 + nvl(deca.add_com_con_cr,0)
                 + nvl(deca.irpef_acconto_ap,0) != 0
          ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            D_r_irpef_db := null;
            D_r_irpef_cr := null;
            D_r_irpef_int := null;
            D_r_irpef_ris := null;
            D_r_irpef_1r_int := null;
            D_r_add_r_db := null;
            D_r_add_r_dbc := null;
            D_r_add_c_db := null;
            D_r_add_c_dbc := null;
        END;

        BEGIN
          select max(moco.mese)
            into D_rt_mese1
            from movimenti_contabili   moco
              , voci_economiche       voec
               where moco.anno (+)      = P_anno
            and moco.mese         >= 7
            and moco.ci            = CUR_CI.ci
            and moco.voce          = voec.codice
            and moco.voce          = voec.codice
            and voec.specifica in ('IRPEF_DB','IRPEF_CR','IRPEF_AP',
                                   'ADD_R_DB','ADD_R_DBC',
                                   'ADD_C_DB','ADD_C_DBC')
            and exists(select 'x'
                         from denuncia_caaf deca
                        where deca.anno= P_anno -1
                          and deca.ci = CUR_CI.ci
                          and deca.rettifica = 'M')
          ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            D_rt_mese1 := null;
        END;
        BEGIN
          select max(decode(moco.mese,10,11,moco.mese))
            into D_rt_mese2
            from movimenti_contabili   moco
              , voci_economiche       voec
               where moco.anno (+)      = P_anno
            and moco.mese         >= 7
            and moco.ci            = CUR_CI.ci
            and moco.voce          = voec.codice
            and moco.voce          = voec.codice
            and voec.specifica in ('IRPEF_2R','IRPEF_2INT','IRP_RET_2R')
            and exists(select 'x'
                         from denuncia_caaf deca
                        where deca.anno= P_anno -1
                          and deca.ci = CUR_CI.ci
                          and deca.rettifica = 'M')
          ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            D_rt_mese2 := null;
        END;

        BEGIN
          D_step := '2 Select dati Movimenti Contabili';
          select min(decode(moco.mese,10,11,moco.mese))  mese
               , sum(decode( voec.specifica
                           , 'IRPEF_2R' , nvl(moco.imp,0)
                           , 'IRPEF_2RC', nvl(moco.imp,0)
                                        , 0)) * -1                       irpef_2r
               , sum(decode( voec.specifica
                           , 'IRPEF_2INT', nvl(moco.imp,0)
                           , 'IRPEF_2INC', nvl(moco.imp,0)
                                         , 0)) * -1                      irpef_2r_int
                , sum(decode( voec.specifica
                            , 'IRP_RET_2R', nvl(moco.imp,0)
                                          , 0)) * -1                     irpef_ret_2r
           into D_r_mese,D_irpef_2r,D_irpef_2r_int,D_irpef_ret_2r
           from movimenti_contabili   moco
              , voci_economiche       voec
         where moco.anno (+)      = P_anno
            and moco.mese         >= 10
            and moco.ci            = CUR_CI.ci
            and moco.voce          = voec.codice
            and voec.specifica in ('IRPEF_2R','IRPEF_2INT','IRP_RET_2R'
                                  ,'IRPEF_2RC','IRPEF_2INC')
          ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            D_r_mese :=null;
            D_irpef_2r :=null;
            D_irpef_2r_int :=null;
            D_irpef_ret_2r :=null;
        END;

          if nvl(D_irpef_db,0)+nvl(D_irpef_cr,0)+
             nvl(D_irpef_int,0)+nvl(D_irpef_ris,0)+nvl(D_irpef_1r,0)+
             nvl(D_irpef_1r_int,0)+nvl(D_irpef_ri1r,0)+nvl(D_irpef_ret_1r,0)+
             nvl(D_irpef_ap,0)+nvl(D_irpef_ap_int,0)+nvl(D_irpef_riap,0)+
             nvl(D_irpef_ret_ap,0)+nvl(D_add_r_dbc,0)+nvl(D_add_r_db,0)+
             nvl(D_add_r_cr,0)+nvl(D_add_r_crc,0)+nvl(D_add_r_ris,0)+
             nvl(D_add_r_risc,0)+nvl(D_add_r_int,0)+nvl(D_add_r_intc,0)+
             nvl(D_add_c_dbc,0)+nvl(D_add_c_db,0)+nvl(D_add_c_cr,0)+
             nvl(D_add_c_crc,0)+nvl(D_add_c_ris,0)+nvl(D_add_c_risc,0) = 0 
          then
             D_mese := null;
          end if;

          if nvl(D_irpef_2r,0)+nvl(D_irpef_2r_int,0)+nvl(D_irpef_ret_2r,0) = 0 then
              D_r_mese := null;
          end if;
-- la casella 42 e settata a B se la somma delle caselle 39,40,41 e < 1 
            if nvl(D_esito_2r,' ') != 'A' and (nvl(D_irpef_2r,0) + nvl(D_irpef_2r_int,0) + nvl(D_irpef_ret_2r,0)) < 1 and (nvl(D_irpef_2r,0) + nvl(D_irpef_2r_int,0) + nvl(D_irpef_ret_2r,0)) != 0 then
              D_esito_2r := 'B';
            end if;

            T_irpef_cr  := T_irpef_cr  - nvl(D_irpef_cr,0);
            T_irpef_db  := T_irpef_db  - nvl(D_irpef_db,0);
            T_irpef_1r  := T_irpef_1r  - nvl(D_irpef_1r,0) - nvl(D_irpef_ret_1r,0)*-1;
            T_irpef_2r  := T_irpef_2r  - nvl(D_irpef_2r,0);
            T_irpef_ap  := T_irpef_ap  - nvl(D_irpef_ap,0);
            T_add_r_cr  := T_add_r_cr  - nvl(D_add_r_cr,0);
            T_add_r_db  := T_add_r_db  - nvl(D_add_r_db,0);
            T_add_r_crc := T_add_r_crc - nvl(D_add_r_crc,0);
            T_add_r_dbc := T_add_r_dbc - nvl(D_add_r_dbc,0);
            T_add_c_cr  := T_add_c_cr  - nvl(D_add_c_cr,0);
            T_add_c_db  := T_add_c_db  - nvl(D_add_c_db,0);
            T_add_c_crc := T_add_c_crc - nvl(D_add_c_crc,0);
            T_add_c_dbc := T_add_c_dbc - nvl(D_add_c_dbc,0);

           BEGIN
              select ' '
                into D_non_terminato
                from denuncia_caaf
               where anno = P_anno - 1
                 and ci   = CUR_CI.ci
                 and rettifica = 'A'
              ;
            EXCEPTION WHEN NO_DATA_FOUND THEN
              BEGIN
                select 'X'
                  into D_non_terminato
                  from dual
                 where nvl(T_irpef_cr,0) != 0
                    or nvl(T_irpef_db,0) != 0
                    or nvl(T_irpef_1r,0) != 0
                    or nvl(T_irpef_2r,0) != 0
                    or nvl(T_irpef_ap,0) != 0
                    or nvl(T_add_r_cr,0) != 0
                    or nvl(T_add_r_db,0) != 0
                    or nvl(T_add_c_cr,0) != 0
                    or nvl(T_add_c_db,0) != 0
                    or nvl(T_add_r_crc,0) != 0
                    or nvl(T_add_r_dbc,0) != 0
                    or nvl(T_add_c_crc,0) != 0
                    or nvl(T_add_c_dbc,0) != 0
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  D_non_terminato := null;
              END;
            END;
     BEGIN
      IF D_c_tipo_cong is not null THEN
       V_controllo := pec_reco.chk_pec_reco('ARCHIVIO_ASSISTENZA_FISCALE.TIPO_CONGUAGLIO',D_c_tipo_cong);
       IF V_controllo = 'NO' THEN
          D_riga   := D_riga + 1;
          D_step   := ' Codice Tipo Conguaglio';
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,'P00505',SUBSTR('Dip.:'||TO_CHAR(CUR_CI.ci)||D_step,1,50));
          D_c_tipo_cong := '';
       END IF;
      END IF;

      IF D_c_rett is not null THEN
       V_controllo := pec_reco.chk_pec_reco('ARCHIVIO_ASSISTENZA_FISCALE.RETTIFICATIVO',D_c_rett);
       IF V_controllo = 'NO' THEN
          D_riga   := D_riga + 1;
          D_step   := ' Codice Rettificativo';
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,'P00505',SUBSTR('Dip.:'||TO_CHAR(CUR_CI.ci)||D_step,1,50));
          D_c_rett := '';
       END IF;
      END IF;

      IF D_esito_2r is not null THEN
       V_controllo := pec_reco.chk_pec_reco('ARCHIVIO_ASSISTENZA_FISCALE.ESITO',D_esito_2r);
       IF V_controllo = 'NO' THEN
          D_riga   := D_riga + 1;
          D_step   := ' Esito Seconda Rata';
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,'P00505',SUBSTR('Dip.:'||TO_CHAR(CUR_CI.ci)||D_step,1,50));
          D_esito_2r := '';
       END IF;
      END IF;

      IF D_esito_cong is not null THEN
       V_controllo := pec_reco.chk_pec_reco('ARCHIVIO_ASSISTENZA_FISCALE.ESITO_CONGUAGLI',D_esito_cong);
       IF V_controllo = 'NO' THEN
          D_riga   := D_riga + 1;
          D_step   := ' Esito Conguagli';
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,'P00505',SUBSTR('Dip.:'||TO_CHAR(CUR_CI.ci)||D_step,1,50));
          D_esito_cong := '';
       END IF;
      END IF;
     END;

     BEGIN
      insert into archivio_assistenza_fiscale
      ( anno, ci, moco_mese1, moco_mese2, moco_mese3, moco_mese4
      , moco_n1, moco_n2, moco_n3, moco_n4, moco_n5, moco_n6, moco_n7, moco_n8, moco_n9, moco_n10
      , moco_n11, moco_n12, moco_n13, moco_n14, moco_n15, moco_n16, moco_n17, moco_n18, moco_n19, moco_n20
      , moco_n21, moco_n22, moco_n23, moco_n24
      , deca_n1, deca_n2, deca_n3, deca_n4, deca_n5, deca_n6, deca_n7, deca_n8
      , deca_c1, deca_c2, deca_c3, deca_c4, deca_c5, deca_c6, deca_c7, deca_c8, deca_c9
      , diff_n1, diff_n2, diff_n3, diff_n4, diff_n5, diff_n6, diff_n7, diff_n8, diff_n9, diff_n10
      , diff_n11, diff_n12, diff_n13, diff_n14, diff_n15, diff_n16
      , utente, tipo_agg, data_agg )
      select P_anno
           , CUR_CI.ci
           , D_mese
           , D_r_mese                                                  -- moco_mese2 casella 38
           , D_rt_mese1                                                -- moco_mese3 casella 43
           , D_rt_mese2                                                -- moco_mese4 casella 51
           , decode(nvl(D_irpef_cr,0),0,null,D_irpef_cr)               -- moco_n1 casella 2
           , decode(nvl(D_irpef_db,0),0,null,D_irpef_db)               -- moco_n2 casella 3
           , decode(nvl(D_irpef_int,0)+nvl(D_irpef_ris,0)
                   ,0,null,nvl(D_irpef_int,0)+nvl(D_irpef_ris,0))      -- moco_n3 casella 4
           , decode(nvl(D_irpef_1r,0),0,null,D_irpef_1r)               -- moco_n4 casella 6
           , decode(nvl(D_irpef_1r_int,0)+nvl(D_irpef_ri1r,0)
                   ,0,null,nvl(D_irpef_1r_int,0)+nvl(D_irpef_ri1r,0))  -- moco_n5 casella 7
           , decode(nvl(D_irpef_ret_1r,0),0,null,D_irpef_ret_1r)       -- moco_n6 casella 8
           , decode(nvl(D_add_r_cr,0),0,null,D_add_r_cr)               -- moco_n7 casella 10
           , decode(nvl(D_add_r_db,0),0,null,D_add_r_db)               -- moco_n8 casella 11
           , decode(nvl(D_add_r_int,0)+nvl(D_add_r_ris,0)
                   ,0,null,nvl(D_add_r_int,0)+nvl(D_add_r_ris,0))      -- moco_n9 casella 12
           , decode(nvl(D_add_r_crc,0),0,null,D_add_r_crc)             -- moco_n10 casella 15
           , decode(nvl(D_add_r_dbc,0),0,null,D_add_r_dbc)             -- moco_n11 casella 16
           , decode(nvl(D_add_r_intc,0)+nvl(D_add_r_risc,0)
                   ,0,null,nvl(D_add_r_intc,0)+nvl(D_add_r_risc,0))    -- moco_n12 casella 17
           , decode(nvl(D_add_c_cr,0),0,null,D_add_c_cr)               -- moco_n13 casella 20
           , decode(nvl(D_add_c_db,0),0,null,D_add_c_db)               -- moco_n14 casella 21
           , decode(nvl(D_add_c_int,0)+nvl(D_add_c_ris,0)
                   ,0,null,nvl(D_add_c_int,0)+nvl(D_add_c_ris,0))      -- moco_n15 casella 22
           , decode(nvl(D_add_c_crc,0),0,null,D_add_c_crc)             -- moco_n16 casella 25
           , decode(nvl(D_add_c_dbc,0),0,null,D_add_c_dbc)             -- moco_n17 casella 26
           , decode(nvl(D_add_c_intc,0)+nvl(D_add_c_risc,0)
                   ,0,null,nvl(D_add_c_intc,0)+nvl(D_add_c_risc,0))    -- moco_n18 casella 27
           , decode(nvl(D_irpef_ap,0),0,null,D_irpef_ap)               -- moco_n19 casella 30
           , decode(nvl(D_irpef_ap_int,0)+nvl(D_irpef_riap,0)
                   ,0,null,nvl(D_irpef_ap_int,0)+nvl(D_irpef_riap,0))  -- moco_n20 casella 31
           , decode(nvl(D_irpef_ret_ap,0),0,null,D_irpef_ret_ap)       -- moco_n21 casella 32
           , decode(nvl(D_irpef_2r,0),0,null,D_irpef_2r)               -- moco_n22 casella 39
           , decode(nvl(D_irpef_2r_int,0),0,null,D_irpef_2r_int)       -- moco_n23 casella 40
           , decode(nvl(D_irpef_ret_2r,0),0,null,D_irpef_ret_2r)       -- moco_n24 casella 41
           , decode(sign(nvl(D_r_irpef_db,0))
                   ,-1,null
                      ,decode(nvl(D_r_irpef_db,0),0,null,D_r_irpef_db))     -- deca_n1 casella 44
           , decode(sign(nvl(D_r_irpef_1r,0))
                   ,-1,null
                      ,decode(nvl(D_r_irpef_1r,0),0,null,D_r_irpef_1r))     -- deca_n2 casella 45
           , decode(sign(nvl(D_r_add_r_db,0))
                   ,-1,null
                      ,decode(nvl(D_r_add_r_db,0),0,null,D_r_add_r_db))     -- deca_n3 casella 46
           , decode(sign(nvl(D_r_add_r_dbc,0))
                   ,-1,null
                      ,decode(nvl(D_r_add_r_dbc,0),0,null,D_r_add_r_dbc))   -- deca_n4 casella 47
           , decode(sign(nvl(D_r_add_c_db,0))
                   ,-1,null
                      ,decode(nvl(D_r_add_c_db,0),0,null,D_r_add_c_db))     -- deca_n5 casella 48
           , decode(sign(nvl(D_r_add_c_dbc,0))
                   ,-1,null
                      ,decode(nvl(D_r_add_c_dbc,0),0,null,D_r_add_c_dbc))   -- deca_n6 casella 49
           , decode(sign(nvl(D_r_irpef_ap,0))
                   ,-1,null
                      ,decode(nvl(D_r_irpef_ap,0),0,null,D_r_irpef_ap))     -- deca_n7 casella 50
           , decode(sign(nvl(D_r_irpef_2r,0))
                   ,-1,null
                      ,decode(nvl(D_r_irpef_2r,0),0,null,D_r_irpef_2r))     -- deca_n8 casella 52
           , decode(nvl(D_add_r_db,0)
                   , 0 , decode( nvl(D_add_r_cr,0)
                                , 0, null
                                   , ltrim(rtrim(D_cod_r_dic_cr))
                               )
                       , ltrim(rtrim(D_cod_r_dic_db))
                    )                                                       -- deca_c1 casella 14
           , decode( nvl(D_add_r_dbc,0)
                   , 0, decode( nvl(D_add_r_crc,0)
                              ,0, null
                                , ltrim(rtrim(D_cod_r_con_cr))
                              )
                      , ltrim(rtrim(D_cod_r_con_db))
                    )                                                       -- deca_c2 casella 19
           , decode( nvl(D_add_c_db,0)
                   , 0 , decode( nvl(D_add_c_cr,0)
                               , 0, null
                                  , ltrim(rtrim(D_cod_c_dic_cr))
                               )
                       , ltrim(rtrim(D_cod_c_dic_db))
                    )                                                       -- deca_c3 casella 24
           , decode( nvl(D_add_c_dbc,0)
                   , 0, decode( nvl(D_add_c_crc,0)
                               ,0, null
                                 , ltrim(rtrim(D_cod_c_con_cr))
                               )
                      , ltrim(rtrim(D_cod_c_con_db))
                    )                                                       -- deca_c4 casella 29
           , D_c_tipo_cong                                                  -- deca_c5 casella 34
           , D_c_rett                                                       -- deca_c6 casella 35
           , decode(D_st_tipo,'A','1',' ')                                  -- deca_c7 casella 36
           , D_esito_2r                                                     -- deca_c8 casella 42
           , decode(nvl(D_non_terminato,' ')
                   , 'X', nvl(D_esito_cong,D_esito_cong1)
                        , null
                   )                                                        -- deca_c9 casella 53
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_irpef_cr,0),0,null,T_irpef_cr)
                        , null
                   )                                                        -- diff_n1 casella 54
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_irpef_db,0),0,null,T_irpef_db)
                        , null
                   )                                                        -- diff_n2 casella 55
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(sign(nvl(T_irpef_1r,0))
                                 ,-1, abs(decode(nvl(T_irpef_1r,0),0,null,T_irpef_1r))
                                    , null
                                )
                        , null
                   )                                                        -- diff_n3 casella 56
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(sign(nvl(T_irpef_1r,0))
                                ,-1, null
                                   , decode(nvl(T_irpef_1r,0),0,null,T_irpef_1r))
                        , null
                   )                                                        -- diff_n4 casella 57
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_r_cr,0),0,null,T_add_r_cr)
                        , null
                   )                                                        -- diff_n5 casella 58
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_r_db,0),0,null,T_add_r_db)
                        , null
                   )                                                        -- diff_n6 casella 59
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_r_crc,0),0,null,T_add_r_crc)
                        , null
                   )                                                        -- diff_n7 casella 60
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_r_dbc,0),0,null,T_add_r_dbc)
                        , null
                   )                                                        -- diff_n8 casella 61
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_c_cr,0),0,null,T_add_c_cr)
                        , null
                   )                                                        -- diff_n9 casella 62
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_c_db,0),0,null,T_add_c_db)
                        , null
                   )                                                        -- diff_n10 casella 63
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_c_crc,0),0,null,T_add_c_crc)
                        , null
                   )                                                        -- diff_n11 casella 64
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(nvl(T_add_c_dbc,0),0,null,T_add_c_dbc)
                        , null
                   )                                                        -- diff_n12 casella 65
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(sign(nvl(T_irpef_ap,0))
                                ,-1,abs(decode(nvl(T_irpef_ap,0),0,null,T_irpef_ap))
                                   ,null
                                 )
                        , null
                   )                                                        -- diff_n13 casella 66
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(sign(nvl(T_irpef_ap,0))
                                ,-1,null
                                   ,decode(nvl(T_irpef_ap,0),0,null,T_irpef_ap)
                                )
                        , null
                   )                                                        -- diff_n14 casella 67
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(sign(nvl(T_irpef_2r,0))
                                ,-1, abs(decode(nvl(T_irpef_2r,0),0,null,T_irpef_2r))
                                   , null 
                                )
                        , null
                   )                                                        -- diff_n15 casella 68
           , decode(nvl(D_non_terminato,' ')
                   , 'X', decode(D_esito_cong1
                                 ,' ',null
                                     ,decode(sign(nvl(T_irpef_2r,0))
                                             ,-1,null
                                                ,decode(nvl(T_irpef_2r,0),0,null,T_irpef_2r)
                                             )
                                )
                        , null
                   )                                                        -- diff_n16 casella 69
           , D_utente
           , null
           , sysdate
       from dual;
       commit; 
 END;
 EXCEPTION
   WHEN OTHERS THEN
     D_errore := SUBSTR(SQLERRM,1,200);
     D_riga   := D_riga + 1;
     INSERT INTO a_segnalazioni_errore
     (no_prenotazione,passo,progressivo,errore,precisazione)
     VALUES (prenotazione,passo,D_riga,'P05832',SUBSTR('Dip.:'||TO_CHAR(CUR_CI.ci)||' '||D_step,1,50));
     D_riga   := D_riga + 1;
     INSERT INTO a_segnalazioni_errore
     (no_prenotazione,passo,progressivo,errore,precisazione)
     VALUES (prenotazione,passo,D_riga,'P05832',SUBSTR(D_errore,1,50));
     COMMIT;
   END;
  ELSE
    null; -- dipendente da NON trattare
  END IF; -- dipendente da trattare
  commit;

  END LOOP; -- cur_ci
  BEGIN
      FOR CUR in 
      ( SELECT distinct ci
          FROM DENUNCIA_CAAF deca
         WHERE deca.anno      = P_anno - 1
           and not exists ( select 'x' 
                              from periodi_retributivi
                             where ci = deca.ci
                               and periodo between P_ini_a
                                               AND P_fin_a
                               AND competenza    = 'A' 
                          )
            and (  P_tipo = 'T'
              or ( P_tipo = 'S' AND deca.ci = P_ci )
                )
       order by ci
       ) LOOP
       BEGIN
            D_riga := D_riga +1;
            D_precisazione := 'Manca Periodo Elaborato';
            INSERT INTO a_segnalazioni_errore
            ( no_prenotazione,passo,progressivo,errore,precisazione)
            VALUES (prenotazione,passo,D_riga,'P05008',substr('CI: '||TO_CHAR(CUR.ci)||' '||D_precisazione,1,50));
            COMMIT;
       END;
     END LOOP; -- cur
   END;
  END IF; -- P_controlli
/* inizio commento dei controlli */
  BEGIN
  <<CONTROLLI>>
  D_archiviato  := '';
  D_annotazione := '';

    BEGIN -- Q_VOEC Tabella di abbinamento voci/specifiche:
     FOR CUR_Q_VOEC in 
     (  select covo.voce                             voce
             , covo.sub                              sub
             , covo.descrizione                      descrizione
             , voec.tipo                             tipo
             , voec.specifica                        specifica
          from contabilita_voce    covo
             , voci_economiche     voec
         where covo.voce        = voec.codice
           and voec.specifica  in
              ('IRPEF_DB','IRPEF_DBC','IRPEF_CR','IRPEF_CRC'
              ,'IRPEF_1R','IRPEF_1RC','IRPEF_2R','IRPEF_2RC'
              ,'IRPEF_AP','IRPEF_APC'
              ,'ADD_R_DB','ADD_R_DBC','ADD_R_CR','ADD_R_CRC'
              ,'ADD_R_RAS','ADD_R_RASC','ADD_R_RIS','ADD_R_RISC','ADD_R_INT','ADD_R_INTC'
              ,'ADD_C_DB','ADD_C_DBC','ADD_C_CR','ADD_C_CRC'
              ,'ADD_C_RAS','ADD_C_RASC','ADD_C_RIS','ADD_C_RISC','ADD_C_INT','ADD_C_INTC'
              ,'ADD_C_AC','ADD_C_RAC','ADD_C_RIA','ADD_C_IAC'
              ,'ADD_C_ACC','ADD_C_RACC','ADD_C_RIAC','ADD_C_IACC'
              ,'IRPEF_SINT','IRPEF_SINC'
              ,'IRPEF_1INT','IRPEF_RA1C','IRPEF_RI1C','IRPEF_1SOP'
              ,'IRPEF_AINT','IRPEF_AINC','IRPEF_ASOP','IRPEF_SSOP'
              ,'IRPEF_2INT'
              ,'IRPEF_RAS','IRPEF_RASC','IRPEF_RIS','IRPEF_RISC','IRPEF_RA1R'
              ,'IRPEF_RI1R'
              ,'IRPEF_RAAP','IRPEF_RIAP','IRPEF_RAPC','IRPEF_RIAC'
              ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP','IRPEF_1INC','IRPEF_2INC'
              )
           and P_tipo_controlli   in ('T','V')
           and P_tipo = 'T'
     ) LOOP
     BEGIN
        D_riga := nvl(D_riga,0) + 1;
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
        values ( prenotazione
               , 2
               , 1
               , D_riga
               , rpad('Q_VOEC',10,' ')||
                 rpad(nvl(CUR_Q_VOEC.voce,' '),10,' ')||
                 rpad(nvl(CUR_Q_VOEC.sub,' '),3,' ')||
                 rpad(nvl(CUR_Q_VOEC.descrizione,' '),30,' ')||
                 nvl(CUR_Q_VOEC.tipo,' ')||
                 rpad(nvl(CUR_Q_VOEC.specifica,' '),10,' ')
               );
         commit;
     END;
     END LOOP; -- CUR_Q_VOEC

    END;

    BEGIN -- Q_RAIN Sono state effettuate le seguenti rettifiche:
-- estrae i dipendenti che hanno dei rettificativi in ACAAF
     FOR CUR_Q_RAIN in 
     (select rain.ci                                              ci
           , deca.rettifica                                       rettifica
           , substr(perc.rv_meaning,1,100)                        motivo
        from rapporti_individuali         rain
           , pec_ref_codes                perc
           , denuncia_caaf                deca
       where p_tipo_controlli  in ('T','R')
         and deca.ci           = rain.ci
         and deca.anno         = P_anno - 1
         and perc.rv_domain    = 'DENUNCIA_CAAF.RETTIFICA'
         and perc.rv_low_value = deca.rettifica
         and deca.rettifica   != 'M'
           and ( P_tipo = 'S' and rain.ci = P_ci
             or  P_tipo = 'T'
               )
         and deca.ci in
            (select ci from denuncia_caaf
              where anno      = P_anno - 1
                and rettifica = 'M')
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
           ) LOOP
     BEGIN
        D_riga := nvl(D_riga,0) + 1;
        insert into a_appoggio_stampe
        ( no_prenotazione, no_passo, pagina, riga, testo )
        values ( prenotazione
               , 2
               , 1
               , D_riga
               , rpad('Q_RAIN',10,' ')||
                 lpad(nvl(to_char(CUR_Q_RAIN.ci),'0'),8,'0')||
                 nvl(CUR_Q_RAIN.rettifica,' ')||
                 rpad(nvl(CUR_Q_RAIN.motivo,' '),100,' ')
               );
         commit;
     END;
     END LOOP; -- CUR_Q_RAIN
    END;

    BEGIN -- Q_DIFF Conguagli non terminati e Riepilogo Differenze tra Movimenti e Dati 730
     BEGIN
       select 'X'
         into D_archiviato
         from dual
        where exists ( select 'x'
                         from archivio_assistenza_fiscale
                        where anno = P_anno
                     )
        ; 
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_archiviato := '';
     END;
     FOR CUR_CI_DIFF IN 
     ( select distinct mofi.ci ci
         from movimenti_fiscali mofi
        where anno = P_anno
          and (   P_tipo = 'T' 
             or ( P_tipo = 'S' and mofi. ci = P_ci )
             )
          and mensilita != '*AP'
          and exists ( select 'x' 
                         from rapporti_individuali rain
                        where rain.ci = mofi.ci
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
          and P_tipo_controlli in ( 'T', 'C' )
       union
       select distinct asfi.ci ci
         from archivio_assistenza_fiscale asfi
        where anno = P_anno
          and (   P_tipo = 'T' 
             or ( P_tipo = 'S' and asfi. ci = P_ci )
             )
          and exists ( select 'x' 
                         from rapporti_individuali rain
                        where rain.ci = asfi.ci
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
          and P_tipo_controlli in ( 'T', 'C' )
       union
       select distinct deca.ci ci
         from denuncia_caaf deca
        where anno = P_anno-1
          and (   P_tipo = 'T' 
             or ( P_tipo = 'S' and deca.ci = P_ci )
             )
          and exists ( select 'x' 
                         from rapporti_individuali rain
                        where rain.ci = deca.ci
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
          and P_tipo_controlli in ( 'T', 'C' )
     order by 1
     ) LOOP
     BEGIN
       FOR CUR_Q_DIFF in 
       (  select rain.ci
               , voec.specifica
               , voec.codice
               , voec.oggetto desc_voce
               , nvl(sum(decode( voec.specifica
                               , 'IRPEF_CR', deca.irpef_cr
                               , 'IRPEF_CRC', deca.irpef_crc
                               , 'IRPEF_DB', deca.irpef_db
                               , 'IRPEF_DBC', deca.irpef_dbc
                               , 'IRPEF_1R', deca.irpef_1r
                               , 'IRPEF_1RC', deca.irpef_1r_con
                               , 'IRPEF_2R', deca.irpef_2r
                               , 'IRPEF_2RC', deca.irpef_2r_con
                               , 'IRPEF_AP', deca.irpef_ap
                               , 'IRPEF_APC', deca.irpef_ap_con
                               , 'ADD_R_CR', deca.add_reg_dic_cr
                               , 'ADD_R_CRC', deca.add_reg_con_cr
                               , 'ADD_R_DB', deca.add_reg_dic_db
                               , 'ADD_R_DBC', deca.add_reg_con_db
                               , 'ADD_C_CR', deca.add_com_dic_cr
                               , 'ADD_C_CRC', deca.add_com_con_cr
                               , 'ADD_C_DB', deca.add_com_dic_db
                               , 'ADD_C_DBC', deca.add_com_con_db
                               , 'ADD_C_AC', deca.add_c_ac
                               , 'ADD_C_ACC', deca.add_c_acc
                           ,0)),0) deca
               , nvl(sum(decode(voec.specifica
                               , 'IRPEF_CR', moco.irpef_cr
                               , 'IRPEF_CRC', moco.irpef_crc
                               , 'IRPEF_DB', moco.irpef_db
                               , 'IRPEF_DBC', moco.irpef_dbc
                               , 'IRPEF_1R', moco.irpef_1r
                               , 'IRPEF_1RC', moco.irpef_1r_con
                               , 'IRPEF_2R', moco.irpef_2r
                               , 'IRPEF_2RC', moco.irpef_2r_con
                               , 'IRPEF_AP', moco.irpef_ap
                               , 'IRPEF_APC', moco.irpef_ap_con
                               , 'ADD_R_CR', moco.add_reg_dic_cr
                               , 'ADD_R_CRC', moco.add_reg_con_cr
                               , 'ADD_R_DB', moco.add_reg_dic_db
                               , 'ADD_R_DBC', moco.add_reg_con_db
                               , 'ADD_C_CR', moco.add_com_dic_cr
                               , 'ADD_C_CRC', moco.add_com_con_cr
                               , 'ADD_C_DB', moco.add_com_dic_db
                               , 'ADD_C_DBC', moco.add_com_con_db
                               , 'ADD_C_AC', moco.add_c_ac
                               , 'ADD_C_ACC', moco.add_c_acc
                           ,0)),0) moco
               , nvl(sum(decode(voec.specifica
                               , 'IRPEF_CR', moco.irpef_cr
                               , 'IRPEF_CRC', moco.irpef_crc
                               , 'IRPEF_DB', moco.irpef_db
                               , 'IRPEF_DBC', moco.irpef_dbc
                               , 'IRPEF_1R', moco.irpef_1r
                               , 'IRPEF_1RC', moco.irpef_1r_con
                               , 'IRPEF_2R', moco.irpef_2r
                               , 'IRPEF_2RC', moco.irpef_2r_con
                               , 'IRPEF_AP', moco.irpef_ap
                               , 'IRPEF_APC', moco.irpef_ap_con
                               , 'ADD_R_CR', moco.add_reg_dic_cr
                               , 'ADD_R_CRC', moco.add_reg_con_cr
                               , 'ADD_R_DB', moco.add_reg_dic_db
                               , 'ADD_R_DBC', moco.add_reg_con_db
                               , 'ADD_C_CR', moco.add_com_dic_cr
                               , 'ADD_C_CRC', moco.add_com_con_cr
                               , 'ADD_C_DB', moco.add_com_dic_db
                               , 'ADD_C_DBC', moco.add_com_con_db
                               , 'ADD_C_AC', moco.add_c_ac
                               , 'ADD_C_ACC', moco.add_c_acc
                           ,0)),0) 
               - nvl(sum(decode( voec.specifica
                               , 'IRPEF_CR', deca.irpef_cr
                               , 'IRPEF_CRC', deca.irpef_crc
                               , 'IRPEF_DB', deca.irpef_db
                               , 'IRPEF_DBC', deca.irpef_dbc
                               , 'IRPEF_1R', deca.irpef_1r
                               , 'IRPEF_1RC', deca.irpef_1r_con
                               , 'IRPEF_2R', deca.irpef_2r
                               , 'IRPEF_2RC', deca.irpef_2r_con
                               , 'IRPEF_AP', deca.irpef_ap
                               , 'IRPEF_APC', deca.irpef_ap_con
                               , 'ADD_R_CR', deca.add_reg_dic_cr
                               , 'ADD_R_CRC', deca.add_reg_con_cr
                               , 'ADD_R_DB', deca.add_reg_dic_db
                               , 'ADD_R_DBC', deca.add_reg_con_db
                               , 'ADD_C_CR', deca.add_com_dic_cr
                               , 'ADD_C_CRC', deca.add_com_con_cr
                               , 'ADD_C_DB', deca.add_com_dic_db
                               , 'ADD_C_DBC', deca.add_com_con_db
                               , 'ADD_C_AC', deca.add_c_ac
                               , 'ADD_C_ACC', deca.add_c_acc
                           ,0)),0) diff
               ,  decode(D_archiviato
                       ,'X', nvl(sum(decode( voec.specifica
                                           , 'IRPEF_CR', asfi.irpef_cr
                                           , 'IRPEF_CRC', asfi.irpef_crc
                                           , 'IRPEF_DB', asfi.irpef_db
                                           , 'IRPEF_DBC', asfi.irpef_dbc
                                           , 'IRPEF_1R', asfi.irpef_1r
                                           , 'IRPEF_1RC', asfi.irpef_1r_con
                                           , 'IRPEF_2R', asfi.irpef_2r
                                           , 'IRPEF_2RC', asfi.irpef_2r_con
                                           , 'IRPEF_AP',  asfi.irpef_ap
                                           , 'IRPEF_APC', asfi.irpef_ap_con
                                           , 'ADD_R_CR',  asfi.add_reg_dic_cr
                                           , 'ADD_R_CRC', asfi.add_reg_con_cr
                                           , 'ADD_R_DB',  asfi.add_reg_dic_db
                                           , 'ADD_R_DBC', asfi.add_reg_con_db
                                           , 'ADD_C_CR',  asfi.add_com_dic_cr
                                           , 'ADD_C_CRC', asfi.add_com_con_cr
                                           , 'ADD_C_DB',  asfi.add_com_dic_db
                                           , 'ADD_C_DBC', asfi.add_com_con_db
                                           , 'ADD_C_AC', asfi.add_c_ac
                                           , 'ADD_C_ACC', asfi.add_c_acc
                             ,0)),0)
                           ,'') arch
               , decode(D_archiviato
                       ,'X', nvl(sum(decode(voec.specifica
                                           , 'IRPEF_CR',  moco.irpef_cr
                                           , 'IRPEF_CRC', 0
                                           , 'IRPEF_DB',  moco.irpef_db
                                           , 'IRPEF_DBC', 0
                                           , 'IRPEF_1R',  nvl(moco.irpef_1r,0) + nvl(moco.irpef_1r_con,0)
                                           , 'IRPEF_1RC', 0
                                           , 'IRPEF_2R',  nvl(moco.irpef_2r,0) + nvl(moco.irpef_2r_con,0)
                                           , 'IRPEF_2RC', 0
                                           , 'IRPEF_AP',  nvl(moco.irpef_ap,0) + nvl(moco.irpef_ap_con,0)
                                           , 'IRPEF_APC', 0
                                           , 'ADD_R_CR',  moco.add_reg_dic_cr
                                           , 'ADD_R_CRC', moco.add_reg_con_cr
                                           , 'ADD_R_DB',  moco.add_reg_dic_db
                                           , 'ADD_R_DBC', moco.add_reg_con_db
                                           , 'ADD_C_CR',  moco.add_com_dic_cr
                                           , 'ADD_C_CRC', moco.add_com_con_cr
                                           , 'ADD_C_DB',  moco.add_com_dic_db
                                           , 'ADD_C_DBC', moco.add_com_con_db
                                           , 'ADD_C_AC',  0
                                           , 'ADD_C_ACC', 0
                             ,0)),0)
                           - nvl(sum(decode( voec.specifica
                                           , 'IRPEF_CR', asfi.irpef_cr
                                           , 'IRPEF_CRC', 0
                                           , 'IRPEF_DB', asfi.irpef_db
                                           , 'IRPEF_DBC', 0
                                           , 'IRPEF_1R', asfi.irpef_1r
                                           , 'IRPEF_1RC', 0
                                           , 'IRPEF_2R', asfi.irpef_2r
                                           , 'IRPEF_2RC', 0
                                           , 'IRPEF_AP',  asfi.irpef_ap
                                           , 'IRPEF_APC', 0
                                           , 'ADD_R_CR',  asfi.add_reg_dic_cr
                                           , 'ADD_R_CRC', asfi.add_reg_con_cr
                                           , 'ADD_R_DB',  asfi.add_reg_dic_db
                                           , 'ADD_R_DBC', asfi.add_reg_con_db
                                           , 'ADD_C_CR',  asfi.add_com_dic_cr
                                           , 'ADD_C_CRC', asfi.add_com_con_cr
                                           , 'ADD_C_DB',  asfi.add_com_dic_db
                                           , 'ADD_C_DBC', asfi.add_com_con_db
                                           , 'ADD_C_AC',  0
                                           , 'ADD_C_ACC', 0
                             ,0)),0)
                           ,'') diff1
           from rapporti_individuali rain
              , voci_economiche       voec
              ,(select deca.ci
                     , nvl(sum(deca.irpef_cr),0) irpef_cr
                     , nvl(sum(deca.irpef_cr_con),0) irpef_crc
                     , nvl(sum(deca.irpef_db),0) irpef_db
                     , nvl(sum(deca.irpef_db_con),0) irpef_dbc
                     , nvl(sum(deca.irpef_1r),0) irpef_1r
                     , nvl(sum(deca.irpef_1r_con),0) irpef_1r_con
                     , nvl(sum(deca.irpef_2r),0) irpef_2r
                     , nvl(sum(deca.irpef_2r_con),0) irpef_2r_con
                     , nvl(sum(deca.irpef_acconto_ap),0) irpef_ap
                     , nvl(sum(deca.irpef_acconto_ap_con),0) irpef_ap_con
                     , nvl(sum(deca.add_reg_dic_cr),0) add_reg_dic_cr
                     , nvl(sum(deca.add_reg_con_cr),0) add_reg_con_cr
                     , nvl(sum(deca.add_reg_dic_db),0) add_reg_dic_db
                     , nvl(sum(deca.add_reg_con_db),0) add_reg_con_db
                     , nvl(sum(deca.add_com_dic_cr),0) add_com_dic_cr
                     , nvl(sum(deca.add_com_con_cr),0) add_com_con_cr
                     , nvl(sum(deca.add_com_dic_db),0) add_com_dic_db
                     , nvl(sum(deca.add_com_con_db),0) add_com_con_db
                     , nvl(sum(deca.ACC_ADD_COM_DIC_DB),0) add_c_ac
                     , nvl(sum(deca.ACC_ADD_COM_CON_DB),0) add_c_acc
                  from denuncia_caaf            deca
                 where deca.anno           = P_anno - 1
                   and deca.rettifica     != 'M'
                   and deca.ci             = CUR_CI_DIFF.ci
                 group by deca.ci 
               ) deca
              ,(select moco.ci
                     , nvl(sum(decode(voec.specifica
                                     ,'IRPEF_CR', moco.imp
                                                , 0
                                      )),0) irpef_cr
                     , nvl(sum(decode(voec.specifica
                                     ,'IRPEF_CRC', moco.imp
                                                , 0
                                      )),0) irpef_crc
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_DB', moco.imp*-1
                                      ,'IRPEF_RAS', moco.imp*-1
                                      )),0) irpef_db
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_DBC', moco.imp*-1
                                      ,'IRPEF_RASC', moco.imp*-1
                                      )),0) irpef_dbc
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_1R', moco.imp*-1
                                      ,'IRPEF_RA1R', moco.imp*-1
                                      )),0) irpef_1r
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_1RC', moco.imp*-1
                                      ,'IRPEF_RA1C', moco.imp*-1
                                      )),0)irpef_1r_con
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_2R', moco.imp*-1
                                      )),0) irpef_2r
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_2RC', moco.imp*-1
                                      )),0) irpef_2r_con
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_AP', moco.imp*-1
                                      ,'IRPEF_RAAP', moco.imp*-1
                                      )),0) irpef_ap
                     , nvl(sum(decode(voec.specifica
                                      ,'IRPEF_APC', moco.imp*-1
                                      ,'IRPEF_RAPC', moco.imp*-1
                                      )),0) irpef_ap_con
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_R_CR', moco.imp
                                      )),0) add_reg_dic_cr
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_R_CRC', moco.imp
                                      )),0) add_reg_con_cr
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_R_DB', moco.imp*-1
                                      ,'ADD_R_RAS', moco.imp*-1
                                      )),0)  add_reg_dic_db
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_R_DBC', moco.imp*-1
                                      ,'ADD_R_RASC', moco.imp*-1
                                      )),0) add_reg_con_db
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_C_CR', moco.imp
                                      )),0) add_com_dic_cr
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_C_CRC', moco.imp
                                      )),0) add_com_con_cr
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_C_DB', moco.imp*-1
                                      ,'ADD_C_RAS', moco.imp*-1
                                      )),0) add_com_dic_db
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_C_DBC', moco.imp*-1
                                      ,'ADD_C_RASC', moco.imp*-1
                                      )),0) add_com_con_db
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_C_AC', moco.imp*-1
                                      ,'ADD_C_RAC', moco.imp*-1
                                      )),0) add_c_ac
                     , nvl(sum(decode(voec.specifica
                                      ,'ADD_C_ACC', moco.imp*-1
                                      ,'ADD_C_RACC', moco.imp*-1
                                      )),0) add_c_acc
                  from voci_economiche       voec
                     , movimenti_contabili   moco
                 where voec.specifica in ( 'IRPEF_CR',  'IRPEF_CRC'
                                         , 'IRPEF_DB',  'IRPEF_DBC', 'IRPEF_RAS' , 'IRPEF_RASC'
                                         , 'IRPEF_1R',  'IRPEF_RA1R'
                                         , 'IRPEF_1RC', 'IRPEF_RA1C'
                                         , 'IRPEF_2R',  'IRPEF_2RC'
                                         , 'IRPEF_AP',  'IRPEF_RAAP'
                                         , 'IRPEF_APC', 'IRPEF_RAPC'
                                         , 'ADD_R_CR',  'ADD_R_CRC'
                                         , 'ADD_R_DB',  'ADD_R_RAS'
                                         , 'ADD_R_DBC', 'ADD_R_RASC'
                                         , 'ADD_C_CR',  'ADD_C_CRC'
                                         , 'ADD_C_DB',  'ADD_C_RAS'
                                         , 'ADD_C_DBC', 'ADD_C_RASC'
                                         , 'ADD_C_AC',  'ADD_C_RAC'
                                         , 'ADD_C_ACC', 'ADD_C_RACC'
                                          )
                   and moco.anno         = P_anno
                   and moco.mensilita   != '*AP'
                   and moco.voce        = voec.codice
                   and moco.ci          = CUR_CI_DIFF.ci
                 group by moco.ci
              ) moco
              ,(select asfi.ci
                     , nvl(sum(asfi.moco_n1),0) irpef_cr
                     , nvl(sum(0),0)            irpef_crc -- sistemare 770/2008
                     , nvl(sum(asfi.moco_n2),0) irpef_db
                     , nvl(sum(0),0)            irpef_dbc -- sistemare 770/2008
                     , nvl(sum(asfi.moco_n4),0) irpef_1r
                     , nvl(sum(0),0) irpef_1r_con -- non esisteva nel 2006 redditi 2005
                     , nvl(sum(asfi.moco_n22),0) irpef_2r
                     , nvl(sum(0),0) irpef_2r_con -- non esisteva nel 2006 redditi 2005
                     , nvl(sum(asfi.moco_n19),0) irpef_ap
                     , nvl(sum(0),0) irpef_ap_con -- non esisteva nel 2006 redditi 2005
                     , nvl(sum(asfi.moco_n7),0) add_reg_dic_cr
                     , nvl(sum(asfi.moco_n10),0) add_reg_con_cr
                     , nvl(sum(asfi.moco_n8),0) add_reg_dic_db
                     , nvl(sum(asfi.moco_n11),0) add_reg_con_db
                     , nvl(sum(asfi.moco_n13),0) add_com_dic_cr
                     , nvl(sum(asfi.moco_n16),0) add_com_con_cr
                     , nvl(sum(asfi.moco_n14),0) add_com_dic_db
                     , nvl(sum(asfi.moco_n17),0) add_com_con_db
                     , nvl(sum(0),0)             add_c_ac     -- sistemare 770/2008
                     , nvl(sum(0),0)             add_c_acc    -- sistemare 770/2008
                  from archivio_assistenza_fiscale  asfi
                 where asfi.anno = P_anno
                   and asfi.ci   = CUR_CI_DIFF.ci
                 group by asfi.ci 
               ) asfi
          where rain.ci = CUR_CI_DIFF.ci
            and rain.ci = deca.ci (+)
            and rain.ci = moco.ci (+)
            and rain.ci = asfi.ci (+)
            and voec.specifica in (  'IRPEF_CR', 'IRPEF_CRC', 'IRPEF_DB', 'IRPEF_DBC'
                                   , 'IRPEF_1R', 'IRPEF_1RC'
                                   , 'IRPEF_2R', 'IRPEF_2RC'
                                   , 'IRPEF_AP', 'IRPEF_APC'
                                   , 'ADD_R_CR', 'ADD_R_CRC'
                                   , 'ADD_R_DB', 'ADD_R_DBC'
                                   , 'ADD_C_CR', 'ADD_C_CRC'
                                   , 'ADD_C_DB', 'ADD_C_DBC'
                                   , 'ADD_C_AC', 'ADD_C_ACC'
                                 )
            group by rain.ci
                   , voec.specifica
                   , voec.codice
                   , voec.oggetto
            having (  nvl(sum(decode(voec.specifica
                               , 'IRPEF_CR', moco.irpef_cr
                               , 'IRPEF_CRC', moco.irpef_crc
                               , 'IRPEF_DB', moco.irpef_db
                               , 'IRPEF_DBC', moco.irpef_dbc
                               , 'IRPEF_1R', moco.irpef_1r
                               , 'IRPEF_1RC', moco.irpef_1r_con
                               , 'IRPEF_2R', moco.irpef_2r
                               , 'IRPEF_2RC', moco.irpef_2r_con
                               , 'IRPEF_AP', moco.irpef_ap
                               , 'IRPEF_APC', moco.irpef_ap_con
                               , 'ADD_R_CR', moco.add_reg_dic_cr
                               , 'ADD_R_CRC', moco.add_reg_con_cr
                               , 'ADD_R_DB', moco.add_reg_dic_db
                               , 'ADD_R_DBC', moco.add_reg_con_db
                               , 'ADD_C_CR', moco.add_com_dic_cr
                               , 'ADD_C_CRC', moco.add_com_con_cr
                               , 'ADD_C_DB', moco.add_com_dic_db
                               , 'ADD_C_DBC', moco.add_com_con_db
                               , 'ADD_C_AC',  moco.add_c_ac
                               , 'ADD_C_ACC',  moco.add_c_acc
                           ,0)),0)
               -  nvl(sum(decode( voec.specifica
                                 , 'IRPEF_CR', deca.irpef_cr
                                 , 'IRPEF_CRC', deca.irpef_crc
                                 , 'IRPEF_DB', deca.irpef_db
                                 , 'IRPEF_DBC', deca.irpef_dbc
                                 , 'IRPEF_1R', deca.irpef_1r
                                 , 'IRPEF_1RC', deca.irpef_1r_con
                                 , 'IRPEF_2R', deca.irpef_2r
                                 , 'IRPEF_2RC', deca.irpef_2r_con
                                 , 'IRPEF_AP', deca.irpef_ap
                                 , 'IRPEF_APC', deca.irpef_ap_con
                                 , 'ADD_R_CR', deca.add_reg_dic_cr
                                 , 'ADD_R_CRC', deca.add_reg_con_cr
                                 , 'ADD_R_DB', deca.add_reg_dic_db
                                 , 'ADD_R_DBC', deca.add_reg_con_db
                                 , 'ADD_C_CR', deca.add_com_dic_cr
                                 , 'ADD_C_CRC', deca.add_com_con_cr
                                 , 'ADD_C_DB', deca.add_com_dic_db
                                 , 'ADD_C_DBC', deca.add_com_con_db
                                 , 'ADD_C_AC',  deca.add_c_ac
                                 , 'ADD_C_ACC',  deca.add_c_acc
                           ,0)),0) != 0
                 )
           or ( decode(D_archiviato
                       ,'X', nvl(sum(decode(voec.specifica
                                           , 'IRPEF_CR',  moco.irpef_cr
                                           , 'IRPEF_CRC', 0
                                           , 'IRPEF_DB',  moco.irpef_db
                                           , 'IRPEF_DBC', 0
                                           , 'IRPEF_1R',  nvl(moco.irpef_1r,0) + nvl(moco.irpef_1r_con,0)
                                           , 'IRPEF_1RC', 0
                                           , 'IRPEF_2R',  nvl(moco.irpef_2r,0) + nvl(moco.irpef_2r_con,0)
                                           , 'IRPEF_2RC', 0
                                           , 'IRPEF_AP',  nvl(moco.irpef_ap,0) + nvl(moco.irpef_ap_con,0)
                                           , 'IRPEF_APC', 0
                                           , 'ADD_R_CR',  moco.add_reg_dic_cr
                                           , 'ADD_R_CRC', moco.add_reg_con_cr
                                           , 'ADD_R_DB',  moco.add_reg_dic_db
                                           , 'ADD_R_DBC', moco.add_reg_con_db
                                           , 'ADD_C_CR',  moco.add_com_dic_cr
                                           , 'ADD_C_CRC', moco.add_com_con_cr
                                           , 'ADD_C_DB',  moco.add_com_dic_db
                                           , 'ADD_C_DBC', moco.add_com_con_db
                                           , 'ADD_C_AC',  0
                                           , 'ADD_C_ACC', 0
                             ,0)),0)
                           - nvl(sum(decode( voec.specifica
                                           , 'IRPEF_CR', asfi.irpef_cr
                                           , 'IRPEF_CRC', 0
                                           , 'IRPEF_DB', asfi.irpef_db
                                           , 'IRPEF_DBC', 0
                                           , 'IRPEF_1R', asfi.irpef_1r
                                           , 'IRPEF_1RC', 0
                                           , 'IRPEF_2R', asfi.irpef_2r
                                           , 'IRPEF_2RC', 0
                                           , 'IRPEF_AP',  asfi.irpef_ap
                                           , 'IRPEF_APC', 0
                                           , 'ADD_R_CR',  asfi.add_reg_dic_cr
                                           , 'ADD_R_CRC', asfi.add_reg_con_cr
                                           , 'ADD_R_DB',  asfi.add_reg_dic_db
                                           , 'ADD_R_DBC', asfi.add_reg_con_db
                                           , 'ADD_C_CR',  asfi.add_com_dic_cr
                                           , 'ADD_C_CRC', asfi.add_com_con_cr
                                           , 'ADD_C_DB',  asfi.add_com_dic_db
                                           , 'ADD_C_DBC', asfi.add_com_con_db
                                           , 'ADD_C_AC',  0
                                           , 'ADD_C_ACC', 0
                             ,0)),0)
                           ,'') != 0
                 )
         order by 1,2
       ) LOOP
       BEGIN
          BEGIN
            select decode(CUR_Q_DIFF.specifica
                         ,'IRPEF_1R', decode(sign(CUR_Q_DIFF.diff)
                                            ,-1,'I rata IRPEF: Importo non trattenuto o trattenuto parzialmente'
                                               ,'')
                         ,'IRPEF_1RC', decode(sign(CUR_Q_DIFF.diff)
                                            ,-1,'I rata IRPEF coniuge: Importo non trattenuto o trattenuto parzialmente'
                                            ,'')
                         ,'IRPEF_2R', decode(sign(CUR_Q_DIFF.diff)
                                            ,-1,'II rata IRPEF: Importo non trattenuto o trattenuto parzialmente'
                                            ,'')
                         ,'IRPEF_2RC', decode(sign(CUR_Q_DIFF.diff)
                                            ,-1,'II rata IRPEF coniuge: Importo non trattenuto o trattenuto parzialmente'
                                            ,'')
                                     , decode(sign(CUR_Q_DIFF.diff)
                                            ,-1,'Conguagli non terminati: verificare il motivo in ACAAF '
                                            ,'')
                        )
              into D_annotazione
              from dual;
          EXCEPTION 
               WHEN NO_DATA_FOUND THEN 
                    D_annotazione := ' ';
          END;
          D_riga := nvl(D_riga,0) + 1;
          insert into a_appoggio_stampe
          ( no_prenotazione, no_passo, pagina, riga, testo )
          values ( prenotazione
                 , 2
                 , 1
                 , D_riga
                 , rpad('Q_DIFF',10,' ')||
                   lpad(nvl(to_char(CUR_Q_DIFF.ci),'0'),8,'0')||
                   rpad(nvl(CUR_Q_DIFF.specifica,' '),10,' ')||
                   rpad(nvl(CUR_Q_DIFF.desc_voce,' '),40,' ')||
                   PECCASFI.ins_apst_importi(nvl(CUR_Q_DIFF.moco,0))||
                   PECCASFI.ins_apst_importi(nvl(CUR_Q_DIFF.deca,0))||
                   PECCASFI.ins_apst_importi(nvl(CUR_Q_DIFF.diff,0))||
                   decode(D_archiviato
                         ,'X',PECCASFI.ins_apst_importi(nvl(CUR_Q_DIFF.arch,0))
                             ,rpad(' ',16,' ')
                         )|| -- archiviazione
                   decode(D_archiviato
                         ,'X',PECCASFI.ins_apst_importi(nvl(CUR_Q_DIFF.diff1,0))
                             ,rpad(' ',16,' ')
                         )|| -- seconda differenza
                   rpad(substr(nvl(D_annotazione,' '),1,100),100,' ')||
                   lpad(decode(CUR_Q_DIFF.specifica
                             , 'IRPEF_CR', 1
                             , 'IRPEF_CRC', 2
                             , 'IRPEF_DB', 3
                             , 'IRPEF_DBC', 4
                             , 'IRPEF_1R', 5
                             , 'IRPEF_1RC', 6
                             , 'IRPEF_2R', 7
                             , 'IRPEF_2RC', 8
                             , 'IRPEF_AP',  10
                             , 'IRPEF_APC', 11
                             , 'ADD_R_CR',  12
                             , 'ADD_R_CRC', 13
                             , 'ADD_R_DB',  14
                             , 'ADD_R_DBC', 15
                             , 'ADD_C_CR',  16
                             , 'ADD_C_CRC', 17
                             , 'ADD_C_DB',  18
                             , 'ADD_C_DBC', 19 
                             , 'ADD_C_AC',  20
                             , 'ADD_C_ACC', 21
                                          , 99) ,2,'0') 
                 );
             commit;
       END;
       END LOOP; -- CUR_Q_DIFF
     END;
     END LOOP; -- CUR_CI_DIFF
    END;

    BEGIN -- Q_MOV Riepilogo Movimenti:
    FOR CUR_CI_MOV in 
     (  select distinct mofi.ci ci
         from movimenti_fiscali mofi
        where anno = P_anno
          and (   P_tipo = 'T' 
             or ( P_tipo = 'S' and mofi. ci = P_ci )
             )
          and mensilita != '*AP'
          and exists ( select 'x' 
                         from rapporti_individuali rain
                        where rain.ci = mofi.ci
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
          and P_tipo_controlli in ( 'T', 'M' )
     ) LOOP
     BEGIN
       FOR CUR_Q_MOV in 
       (  select covo.voce                             voce
               , covo.sub
               , max(covo.descrizione)                 desc_voce
               , sum(decode( moco.mese
                           , 6, moco.imp
                              , 0))                    giugno
               , sum(decode( moco.mese
                           , 7, moco.imp
                              , 0))                    luglio
               , sum(decode( moco.mese
                           , 8, moco.imp
                              , 0))                    agosto
               , sum(decode( moco.mese
                           , 9, moco.imp
                              , 0))                    settembre
               , sum(decode( moco.mese
                           ,10, moco.imp
                              , 0))                    ottobre
               , sum(decode( moco.mese
                           ,11, moco.imp
                              , 0))                    novembre
               , sum(decode( moco.mese
                           ,12, moco.imp
                              , 0))                    dicembre
               , sum(moco.imp)                         totale
            from movimenti_contabili  moco
               , contabilita_voce     covo
               , voci_economiche      voec
           where moco.anno         = P_anno
             and moco.voce         = covo.voce
             and moco.sub          = covo.sub
             and moco.ci           = CUR_CI_MOV.ci
             and covo.voce         = voec.codice
             and voec.specifica   in
              ('IRPEF_DB','IRPEF_DBC','IRPEF_CR','IRPEF_CRC'
              ,'IRPEF_1R','IRPEF_1RC','IRPEF_2R','IRPEF_2RC'
              ,'IRPEF_AP','IRPEF_APC'
              ,'ADD_R_DB','ADD_R_DBC','ADD_R_CR','ADD_R_CRC'
              ,'ADD_R_RAS','ADD_R_RASC','ADD_R_RIS','ADD_R_RISC','ADD_R_INT','ADD_R_INTC'
              ,'ADD_C_DB','ADD_C_DBC','ADD_C_CR','ADD_C_CRC'
              ,'ADD_C_RAS','ADD_C_RASC','ADD_C_RIS','ADD_C_RISC','ADD_C_INT','ADD_C_INTC'
              ,'ADD_C_AC','ADD_C_RAC','ADD_C_RIA','ADD_C_IAC'
              ,'ADD_C_ACC','ADD_C_RACC','ADD_C_RIAC','ADD_C_IACC'
              ,'IRPEF_SINT','IRPEF_SINC'
              ,'IRPEF_1INT','IRPEF_RA1C','IRPEF_RI1C','IRPEF_1SOP'
              ,'IRPEF_AINT','IRPEF_AINC','IRPEF_ASOP','IRPEF_SSOP'
              ,'IRPEF_2INT'
              ,'IRPEF_RAS','IRPEF_RASC','IRPEF_RIS','IRPEF_RISC','IRPEF_RA1R'
              ,'IRPEF_RI1R'
              ,'IRPEF_RAAP','IRPEF_RIAP','IRPEF_RAPC','IRPEF_RIAC'
              ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP','IRPEF_1INC','IRPEF_2INC'
              )
           group by covo.voce,covo.sub
       ) LOOP
       BEGIN
          D_riga_0 := nvl(D_riga_0,0) + 1;
          insert into a_appoggio_stampe
          ( no_prenotazione, no_passo, pagina, riga, testo )
          values ( prenotazione
                 , 0
                 , 1
                 , D_riga_0
                 , rpad('Q_MOV',10,' ')||
                   rpad(nvl(CUR_Q_MOV.voce,' '),10,' ')||
                   rpad(nvl(CUR_Q_MOV.sub,' '),3,' ')||
                   rpad(nvl(CUR_Q_MOV.desc_voce,' '),40,' ')||
                   lpad(nvl(CUR_Q_MOV.giugno,0),16,' ')||
                   lpad(nvl(CUR_Q_MOV.luglio,0),16,' ')||
                   lpad(nvl(CUR_Q_MOV.agosto,0),16,' ')||
                   lpad(nvl(CUR_Q_MOV.settembre,0),16,' ')||
                   lpad(nvl(CUR_Q_MOV.ottobre,0),16,' ')||
                   lpad(nvl(CUR_Q_MOV.novembre,0),16,' ')||
                   lpad(nvl(CUR_Q_MOV.dicembre,0),16,' ')||
                   lpad(nvl(CUR_Q_MOV.totale,0),16,' ')||
                   lpad(nvl(CUR_CI_MOV.ci,0),8,'0')
                 );
             commit;
       END;
       END LOOP; -- CUR_Q_MOV
-- dbms_output.put_line('D_riga: '||D_riga);
     END;
     END LOOP; -- CUR_CI_MOV
     FOR Q_MOV_STAMPA in 
       ( select substr(apst.testo,11,10) voce
              , substr(apst.testo,21,3) sub
              , substr(apst.testo,24,40) desc_voce
              , sum(nvl(to_number(ltrim(substr(apst.testo,64,16))),0)) giugno
              , sum(nvl(to_number(ltrim(substr(apst.testo,80,16))),0)) luglio
              , sum(nvl(to_number(ltrim(substr(apst.testo,96,16))),0)) agosto
              , sum(nvl(to_number(ltrim(substr(apst.testo,112,16))),0)) settembre
              , sum(nvl(to_number(ltrim(substr(apst.testo,128,16))),0)) ottobre
              , sum(nvl(to_number(ltrim(substr(apst.testo,144,16))),0)) novembre
              , sum(nvl(to_number(ltrim(substr(apst.testo,160,16))),0)) dicembre
              , sum(nvl(to_number(ltrim(substr(apst.testo,176,16))),0)) totale
           from a_appoggio_stampe apst
          where apst.no_prenotazione = prenotazione
            and apst.no_passo = 0
            and apst.pagina = 1
          group by substr(apst.testo,11,10)
                 , substr(apst.testo,21,3)
                 , substr(apst.testo,24,40)
        ) LOOP
           BEGIN
              D_riga := nvl(D_riga,0) + 1;
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              select   prenotazione
                     , 2
                     , 1
                     , D_riga
                     , rpad('Q_MOV',10,' ')||
                       rpad(nvl(Q_MOV_STAMPA.voce,' '),10,' ')||
                       rpad(nvl(Q_MOV_STAMPA.sub,' '),3,' ')||
                       rpad(nvl(Q_MOV_STAMPA.desc_voce,' '),40,' ')||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.giugno,0))||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.luglio,0))||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.agosto,0))||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.settembre,0))||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.ottobre,0))||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.novembre,0))||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.dicembre,0))||
                       PECCASFI.ins_apst_importi(nvl(Q_MOV_STAMPA.totale,0))
                  from dual
               ;
              commit;
-- dbms_output.put_line('D_riga 1: '||D_riga);
           END;
     END LOOP; -- CUR_MOV_STAMPA
     BEGIN -- cancellazione registrazione temporanea APST
       delete from a_appoggio_stampe apst
        where apst.no_prenotazione = prenotazione
          and apst.no_passo = 0
          and apst.pagina = 1;
       commit;
     END;
    END;
  END CONTROLLI;
/* fine commento dei controlli */
EXCEPTION
WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
END;
END;
end;
/
