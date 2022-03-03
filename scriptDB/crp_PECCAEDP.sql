CREATE OR REPLACE PACKAGE PECCAEDP IS
/******************************************************************************
 NOME:        PECCAEDP
 DESCRIZIONE: Archiviazione economica INPDAP.

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
     Il package prevede:
           - un loop a livello di codice individuale su denuncia_inpdap con rilevanza 'S';
           - un secondo loop per l'identificazione dei periodi (da denuncia_inpdap) dell'individuo;
           - l'estrazione dei dati economici da valori_contabili_annuali;
           - calcolo dei giorni utili;
           - update di denuncia_inpdap del periodo trattato con i valori economici calcolati;
           - esternamente al loop dei periodi (quindi nel loop individuale) il loop sugli arretrati CUR_ARR:
           - update sui giorni utili e giorni tfr.

           Il package e inserito come secondo passo della voce PECCARDP.


 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    06/02/2003  MV
 2    01/01/2004  MS    Revisione Denuncia INPDAP
 2.1  20/09/2004  MS    Mod. per attivita 7429
 2.2  20/09/2004  MS    Mod. per attivita 7436
 2.3	27/09/2004	ML	Modificato il calcolo dei GIORNI_UTILI e il CUR_ARR
 2.4	13/10/2004	ML	Modificato il calcolo dei GIORNI_UTILI e il CUR_ARR
 2.5	15/10/2004	ML	Aggiunta update per eliminare le ass. INADEL se non sono valorizzate le relative competenze
 2.6  02/11/2004  MS    Modifica per att. 6662
 3.0  01/02/2005  MS    Modifica per att. 9557
 3.1  10/02/2005  MS    Modifica per att. 3670.1
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
FUNCTION  ESTRAI_RECORD (p_ci in number, p_anno in number, p_al in date) RETURN date ;
PRAGMA RESTRICT_REFERENCES (ESTRAI_RECORD, WNDS, WNPS);
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCAEDP IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V3.1 del 10/02/2005';
END VERSIONE;
FUNCTION ESTRAI_RECORD (p_ci in number, p_anno in number, p_al in date) RETURN date IS
   v_comp_fisse number;
   v_gg_utili number;
   v_gg_tfr   number;
   v_al date;
   v_dal date;
   v_trovato_dal date;
BEGIN
   BEGIN
   select comp_fisse, gg_utili, dal, al
     into v_comp_fisse, v_gg_utili, v_dal, v_al
     from denuncia_inpdap
    where rilevanza = 'S'
      and ci        = p_ci
      and anno      = p_anno
      and nvl(dal,to_date('2222222','j'))
                    = nvl(p_al,to_date('2222222','j')) + 1;
     IF nvl(v_comp_fisse,0) != 0  and nvl(v_gg_utili,0) != 0 then
        v_trovato_dal := v_dal;
     ELSIF nvl(v_comp_fisse,0) = 0  and nvl(v_gg_utili,0) != 0 then     
        v_trovato_dal := ESTRAI_RECORD (p_ci, p_anno,v_al);
     END IF;
   EXCEPTION
   WHEN no_data_found THEN
        v_trovato_dal := to_date(null);   
   WHEN too_many_rows THEN
        v_trovato_dal := to_date(null);   
   END;
return v_trovato_dal;   
END;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
DECLARE
  P_denuncia      VARCHAR2(1);
  P_riferimento   DATE;
  P_sfasato       VARCHAR2(1);
  P_fine_anno     VARCHAR2(1);
  P_cassa         VARCHAR2(1);
  D_errore        VARCHAR2(6);
  V_controllo     VARCHAR2(1);
  V_provenienza   VARCHAR2(5);
  P_comparto      varchar2(2);
  P_sottocomparto varchar2(2);
  D_qualifica     varchar2(6);
  D_ente          varchar(4);
  D_ambiente      varchar(8);
  D_utente        varchar(8);
  D_anno          varchar(4);
  D_anno_rire     varchar(4);
  D_mese_rire     varchar(2);
  D_ini_a         varchar(8);
  D_fin_a         varchar(8);
  D_al_gg         date;
  D_gestione      varchar(4);
  D_previdenza    varchar(6);
  D_tipo          varchar(1);
  D_giorni        varchar(1);
  V_gg_ut         number(4);
  V_gg_tfr         number(4);
  D_dal           date;
  D_al            date;
  D_ci            number(8);
  P_ci            NUMBER(8) := null;
  D_num_servizi   number := 0;
  I_pensione      varchar(1);
  I_gg_utili      varchar(3);
  I_codice        varchar(10);
  I_posizione     varchar(8);
  I_comp_fisse    number := 0;
  I_comp_acc      number := 0;
  I_comp_inadel   number := 0;
  I_comp_tfr      number := 0;
  I_ipn_tfr       number := 0;
  I_comp_premio   number := 0;
  I_preav         number := 0;
  I_ferie         number := 0;
  I_l_165         number := 0;
  I_comp_18       number := 0;
  I_tredicesima     number := 0;
  P_rapporta_somme  varchar2(1);
  P_assenza           varchar2(1);
  V_app_comp_fisse        number := 0;
  V_app_comp_fisse_tot    number := 0;
  V_app_comp_fisse_tot1   number := 0;
  V_app_comp_inadel   number := 0;
  V_app_ipn_tfr       number := 0;
  V_new_comp_fisse    number := 0;
  V_new_comp_inadel   number := 0;
  V_comp_13a          number := 0;
  V_comp_fisse        number := 0;
  V_diff_fisse        number := 0;
  V_fisse_esterne     number(12,2) := 0;
  V_fisse_prec        number(12,2) := 0;
  V_acc_esterne       number(12,2) := 0;
  V_acc_prec          number(12,2) := 0;
  V_inadel_esterne    number(12,2) := 0;
  V_inadel_prec       number(12,2) := 0;
  V_tfr_esterne       number(12,2) := 0;
  V_tfr_prec          number(12,2) := 0;
  V_ipn_tfr_esterne   number(12,2) := 0;
  V_ipn_tfr_prec      number(12,2) := 0;
  V_preav_esterne     number(12,2) := 0;
  V_preav_prec        number(12,2) := 0;
  V_ferie_esterne     number(12,2) := 0;
  V_ferie_prec        number(12,2) := 0;
  V_L165_esterne      number(12,2) := 0;
  V_L165_prec         number(12,2) := 0;
  V_app_ipn_tfr_1     number(12,2) := 0;

  I_dal_arr         varchar(8);
  I_al_arr          varchar(8);
  I_contribuzione   varchar(1);
  I_colonna		  varchar(30);
  I_enpdep          varchar(1);
  D_pr_err_5        NUMBER := 150000; -- max fino a 200000
  D_pr_err_6        NUMBER := 60000;
  D_pr_err_8        NUMBER := 80000;
  D_pr_err_9        NUMBER := 90000;
  D_pr_err_10       NUMBER := 100000;
  D_pr_err_11       NUMBER := 110000;
  D_pr_err_12       NUMBER := 120000;
--
-- Exceptions
--
  USCITA EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
 select 'E'
   INTO P_denuncia 
  from dual;
END;
BEGIN
  select valore
    into D_tipo
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_TIPO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_tipo := null;
END;
BEGIN
  select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
    into D_dal
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_DAL'
  ;
  select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
    into D_al
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_AL'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    select ini_ela,fin_ela
      into D_dal,D_al
      from riferimento_retribuzione
     where rire_id = 'RIRE'
    ;
END;
BEGIN
  select valore
    into D_ci
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    D_ci := 0;
END;
IF nvl(D_ci,0) = 0 and D_tipo = 'S' THEN
     D_errore := 'A05721';
     RAISE USCITA;
ELSIF nvl(D_ci,0) != 0 and D_tipo = 'T' THEN
     D_errore := 'A05721';
     RAISE USCITA; 
END IF;

BEGIN
  select valore
    into D_previdenza
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_PREVIDENZA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_previdenza := null;
END;
BEGIN
  select valore
    into D_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GESTIONE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_gestione := null;
END;
BEGIN
  select valore
    into D_giorni
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GIORNI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_giorni := ' ';
END;
BEGIN
  select valore
    into P_comparto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_COMPARTO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_comparto :='00';
END;
BEGIN
  select valore
    into P_sottocomparto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_SOTTOCOMPARTO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_sottocomparto :='00';
END;
BEGIN
-- acquisizione parametro per spezzare gli importi se presenti assenze no inpdap
  select valore
    into P_rapporta_somme
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_RAPPORTA_SOMME'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_rapporta_somme := ' ';
END;
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

-- Estrae flag per Archiviazione Economica per Cassa (Rif. San Lazzaro)
BEGIN
  SELECT valore
    INTO P_cassa
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_CASSA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      P_cassa := null;
END;
-- Estrae Anno di Riferimento per archiviazione
-- Estrae Parametro per Gestione NDR es: Piacenza
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
IF P_sfasato = 'X' THEN
  BEGIN
   select 'X' 
     into V_controllo
     from gestioni
    where codice = D_gestione
      and D_gestione != '%';
  EXCEPTION 
   WHEN NO_DATA_FOUND THEN 
     IF D_tipo = 'S' THEN NULL;
	 ELSE D_errore := 'P05130';
	      RAISE USCITA;
     END IF;
   WHEN OTHERS THEN NULL;
  END;
END IF;

BEGIN
   select 'CADPM'
     into V_provenienza
     from dual
    where exists ( select 'x' 
                     from a_parametri
                    where no_prenotazione = prenotazione
                      and parametro       = 'P_RIFERIMENTO'
                 );
EXCEPTION WHEN NO_DATA_FOUND THEN
/* provendo da CARDP o da CAEDP */
   select 'CAEDP'
     into V_provenienza
     from dual
   ;
END;

BEGIN
IF V_provenienza = 'CADPM' THEN
 BEGIN -- provengo da CADPM
  select to_char(last_day(TO_DATE(valore,'dd/mm/yyyy')),'ddmmyyyy')
       , decode(to_char(last_day(TO_DATE(valore,'dd/mm/yyyy')),'ddmm')
               ,'3112','X',null)
       , to_date(valore,'dd/mm/yyyy')
    into D_fin_a
       , P_fine_anno
       , P_riferimento
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_RIFERIMENTO'
   ;
 END;
 BEGIN
  select valore
       , decode(P_sfasato,'X','0112'||to_char(valore-1)
                             ,'0101'||valore)
    into D_anno
       , D_ini_a
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ANNO'
  ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     select anno
          , decode(P_sfasato,'X','0112'||to_char(anno-1)
                                ,'0101'||to_char(anno))
      into D_anno
         , D_ini_a
      from riferimento_retribuzione rire
     where rire_id = 'RIRE'
    ;
  END;
 ELSE
    BEGIN -- provengo da CARDP o CAEDP
       select decode(P_sfasato,'X','0112'||to_char(valore-1)
                                  ,'0101'||valore)
            , decode(P_sfasato,'X','3011'||valore
                                  ,'3112'||valore)
            , 'X'
            , valore
            , to_date('3112'||valore,'ddmmyyyy')
         into D_ini_a
            , D_fin_a
            , P_fine_anno
            , D_anno
            , P_riferimento
        from  a_parametri
        where no_prenotazione = prenotazione
          and parametro       = 'P_ANNO'
        ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
           select decode(P_sfasato,'X','0112'||to_char(anno-1)
                                      ,'0101'||to_char(anno))
                , decode(P_sfasato,'X','3011'||anno
                                      ,'3112'||anno)
                , 'X'
                , anno
             , to_date('3112'||anno,'ddmmyyyy')
            into D_ini_a
                , D_fin_a
                , P_fine_anno
                , D_anno
                , P_riferimento
             from riferimento_fine_anno
            where rifa_id = 'RIFA'
       ;
    END;
 END IF;
END;
BEGIN
  select decode(P_sfasato,'X',decode(P_fine_anno
                                    ,'X',to_date('3011'||D_anno,'ddmmyyyy')
                                        ,add_months(to_date(D_fin_a,'ddmmyyyy'),-1)
                                     )
                             ,to_date(D_fin_a,'ddmmyyyy'))
    into D_al_gg
    from dual;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    select decode(P_sfasato,'X',add_months(to_date('3011'||anno,'ddmmyyyy'),-1)
                               ,add_months(to_date('3112'||anno,'ddmmyyyy'),-1)
                  )
      into D_al_gg
      from riferimento_fine_anno
     where rifa_id = 'RIFA';
END;
-- Creazione delle registrazioni di appoggio per determinazione dei
-- dipendenti da trattare
-- dbms_output.put_line('anno '||D_anno||' - ini_a '||D_ini_a||' - fin_a '||D_fin_a);
FOR CUR_PERS IN
   (select distinct pere.ci, pere.gestione
      from periodi_retributivi pere
         , trattamenti_previdenziali trpr
     where pere.periodo between to_date(D_ini_a,'ddmmyyyy')
                            and to_date(D_fin_a,'ddmmyyyy')
--       and pere.competenza    = 'A'
       and pere.competenza    in ( 'A', 'C' )
       and pere.gestione   like D_gestione
       and pere.trattamento   = trpr.codice
       and trpr.previdenza is not null
       and trpr.previdenza like D_previdenza
       and (    D_tipo = 'T'
             or ( D_tipo in ('I','V','P') and not exists
                   (select 'x' from denuncia_inpdap
                     where anno       = D_anno
                       and gestione   = pere.gestione
                       and previdenza = trpr.previdenza
                       and ci         = pere.ci
                       and nvl(tipo_agg,' ') = decode(D_tipo
                                                      ,'P',tipo_agg,
                                                          D_tipo)
                   )
                )
             or ( D_tipo = 'C' 
                 and ( exists (select 'x'
                                from periodi_giuridici pegi
                               where pegi.rilevanza = 'P'
                                 and pegi.ci         = pere.ci
                                 and pegi.dal        =
                                    (select max(dal) 
                                      from periodi_giuridici
                                     where rilevanza = 'P'
                                      and ci        = pegi.ci
                                      and dal      <= D_al
                                   )
                                and pegi.al between D_dal and D_al
                              )
                   or exists ( select 'x'
                                from periodi_giuridici pegi
                     where pegi.rilevanza = 'P'
                       and pegi.ci        = pere.ci
                       and pegi.dal       =
                           (select max(dal) from periodi_giuridici
                             where rilevanza = 'P'
                               and ci        = pegi.ci
                               and dal      <= D_al
                            )
                       and pegi.al <=
                           (select last_day
                                   (to_date
                                   (max(lpad(to_char(mese),2,'0')||
                                   to_char(anno)),'mmyyyy'))
                              from movimenti_fiscali
                             where ci       = pegi.ci
                               and last_day
                                   (to_date
                                   (lpad(to_char(mese),2,'0')||
                                   to_char(anno),'mmyyyy'))
                                   between D_dal and D_al
                               and nvl(ipn_ord,0)  + nvl(ipn_liq,0)
                                   +nvl(ipn_ap,0)   + nvl(lor_liq,0)
                                   +nvl(lor_acc,0) != 0
                               and mensilita != '*AP'
                           )
                           ) 
                      )
                ) -- tipo C
             or ( D_tipo = 'S' and pere.ci = D_ci )
            )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci + 0 = pere.ci
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
   ) LOOP
   P_ci := CUR_PERS.ci;
-- dbms_output.put_line('cur pers: '||cur_pers.ci||' '||cur_pers.gestione);
-- Gestione degli arretrati
-- CUR_ARR
       delete from denuncia_inpdap
        where anno      = D_anno
          and ci        = CUR_PERS.ci
          and rilevanza = 'A'
          and gestione  = CUR_PERS.gestione;
-- dbms_output.put_line('cursore arretrati');
FOR CUR_ARR in
(  select  to_char(vaca.riferimento,'yyyy')           anno_rif
              , D_anno						anno_comp
              , to_char(max(vaca.riferimento),'ddmmyyyy')  riferimento
              , round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                       / nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                       * nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_fisse
              , round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1) arr_accessorie
              , round( sum(decode(vaca.colonna
                                 ,'COMP_INADEL',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                               , '')),1) arr_inadel
             , round( sum(decode(vaca.colonna
                                 ,'COMP_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01),'')),1)
                           )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                               , '')),1) arr_tfr
             , round( sum(decode(vaca.colonna
                                ,'IPN_TFR',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                           , '')),1) arr_ipn_tfr
             , round( sum(decode(vaca.colonna
                                ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                               , '')),1) arr_premio
             , round( sum(decode(vaca.colonna
                                ,'PREAVV_RISARCITORIO',decode( voec.classe||P_cassa
                                                             , 'RX', nvl(vaca.ipn_eap,0)
                                                                   , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                       , '')),1) arr_preav
             , round( sum(decode(vaca.colonna
                                ,'FERIE_NON_GODUTE',decode( voec.classe||P_cassa
                                                          , 'RX', nvl(vaca.ipn_eap,0)
                                                                , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01),'')),1)
                    )
                    * nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1) arr_ferie
             , round( sum(decode(vaca.colonna
                                ,'L_165',decode( voec.classe||P_cassa
                                               , 'RX', nvl(vaca.ipn_eap,0)
                                                     , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01)
                                         , '')),1)  arr_l_165
             , round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                           , '')),1)  arr_comp_18
         	 , round( sum(decode(vaca.colonna
                                ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01),'')),1)
                    )
                    * nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                               , '')),1)  arr_tredicesima
              , max(pere.gestione)                 gestione
              , max(trpr.previdenza)               previdenza
          from estrazione_valori_contabili esvc
             , valori_contabili_annuali   vaca
             , periodi_retributivi        pere
             , trattamenti_previdenziali  trpr
             , voci_economiche            voec
         where esvc.estrazione        = vaca.estrazione
           and esvc.colonna           = vaca.colonna
           and vaca.riferimento
                     between esvc.dal
                         and nvl(esvc.al,to_date('3333333','j'))
           and vaca.anno              = D_anno
           and vaca.mese              = 12
           and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
           and vaca.mensilita         = (select max(mensilita)
                                           from mensilita
                                          where mese  = 12
                                            and tipo in ('A','N','S'))
           and vaca.estrazione        = 'DENUNCIA_INPDAP'
           and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                        ,'COMP_INADEL','COMP_PREMIO','COMP_TFR','IPN_TFR'
                                        ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165'
										,'COMP_18', 'TREDICESIMA')
           and vaca.moco_mensilita    != '*AP'
           and vaca.ci                = CUR_PERS.ci
           and vaca.riferimento       < to_date(D_ini_a,'ddmmyyyy')
/* vecchia versione
           and (   (voec.classe != 'R' and nvl(vaca.arr,'C')      = 'C')
                or (voec.classe = 'R' and nvl(vaca.valore,0) > nvl(vaca.ipn_eap,0))
               )
*/
           and (    P_cassa = 'X' and
                   (    voec.classe != 'R' and nvl(vaca.arr,' ') = 'P'
                     or voec.classe = 'R' and nvl(vaca.ipn_eap,0) != 0
                   )
                or  P_cassa is null and
                    to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy') = D_anno
               )                     
           and pere.periodo = last_day(to_date(lpad(vaca.moco_mese,2,0)||
                                       vaca.anno,'mmyyyy'))
           and vaca.riferimento between pere.dal
                                    and pere.al
           and vaca.ci                = pere.ci
           and pere.gestione          = CUR_PERS.gestione
           and pere.competenza       in ('A','C')
           and pere.servizio          = 'Q'
           and trpr.codice            = pere.trattamento
           and voec.codice            = vaca.voce
  group by to_char(vaca.riferimento,'yyyy')
 having  round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                       / nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                       * nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) 
              + round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1) 
              + round( sum(decode(vaca.colonna
                                 ,'COMP_INADEL',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                               , '')),1) 
             + round( sum(decode(vaca.colonna
                                 ,'COMP_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01),'')),1)
                           )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                               , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'IPN_TFR',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                           , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                               , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'PREAVV_RISARCITORIO',decode( voec.classe||P_cassa
                                                             , 'RX', nvl(vaca.ipn_eap,0)
                                                                   , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'FERIE_NON_GODUTE',decode( voec.classe||P_cassa
                                                          , 'RX', nvl(vaca.ipn_eap,0)
                                                                , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01),'')),1)
                    )
                    * nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'L_165',decode( voec.classe||P_cassa
                                               , 'RX', nvl(vaca.ipn_eap,0)
                                                     , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01)
                                         , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01),'')),1)
                     )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                           , '')),1)
         	 + round( sum(decode(vaca.colonna
                                ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01),'')),1)
                    )
                    * nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                               , '')),1)   != 0
union
select  to_char(vaca.riferimento,'yyyy')           anno_rif
              , to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy') anno_comp
              , to_char(max(vaca.riferimento),'ddmmyyyy')  riferimento
              , round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                       / nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                       * nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_fisse
              , round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
								                   ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                  , '')),1) arr_accessorie
              , round( sum(decode(vaca.colonna
                                 ,'COMP_INADEL',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
								                   ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_inadel
             , round( sum(decode(vaca.colonna
                                 ,'COMP_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
								                   ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_tfr
             , round( sum(decode(vaca.colonna
                                ,'IPN_TFR',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_ipn_tfr
             , round( sum(decode(vaca.colonna
                                ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_premio
             , round( sum(decode(vaca.colonna
                                ,'PREAVV_RISARCITORIO',decode( voec.classe||P_cassa
                                                             , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                                   , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_preav
             , round( sum(decode(vaca.colonna
                                ,'FERIE_NON_GODUTE',decode( voec.classe||P_cassa
                                                          , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                                , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) arr_ferie
             , round( sum(decode(vaca.colonna
                                ,'L_165',decode( voec.classe||P_cassa
                                               , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                     , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)  arr_l_165
             , round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)  arr_comp_18
         	 , round( sum(decode(vaca.colonna
                                ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)  arr_tredicesima
              , max(pere.gestione)                 gestione
              , max(trpr.previdenza)               previdenza
          from estrazione_valori_contabili esvc
             , valori_contabili_annuali   vaca
             , periodi_retributivi        pere
             , trattamenti_previdenziali  trpr
             , voci_economiche            voec
         where esvc.estrazione        = vaca.estrazione
           and esvc.colonna           = vaca.colonna
           and vaca.riferimento
                     between esvc.dal
                         and nvl(esvc.al,to_date('3333333','j'))
           and vaca.anno              = D_anno
           and vaca.mese              = 12
           and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
           and vaca.mensilita         = (select max(mensilita)
                                           from mensilita
                                          where mese  = 12
                                            and tipo in ('A','N','S'))
           and vaca.estrazione        = 'DENUNCIA_INPDAP'
           and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                        ,'COMP_INADEL','COMP_PREMIO','COMP_TFR','IPN_TFR'
                                        ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165'
										,'COMP_18', 'TREDICESIMA')
           and vaca.moco_mensilita    != '*AP'
           and vaca.ci                = CUR_PERS.ci
           and vaca.riferimento       < to_date(D_ini_a,'ddmmyyyy')
           and (    P_cassa = 'X' and
                   (    voec.classe != 'R' and nvl(vaca.arr,'C') = 'C'
                     or voec.classe  = 'R' and nvl(vaca.valore,0) > nvl(vaca.ipn_eap,0) 
                   )
                or  P_cassa is null and
                    to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy') != D_anno
               )                     
           and pere.periodo = last_day(to_date(lpad(vaca.moco_mese,2,0)||
                                       vaca.anno,'mmyyyy'))
           and vaca.riferimento between pere.dal
                                    and pere.al
           and vaca.ci                = pere.ci
           and pere.gestione          = CUR_PERS.gestione
           and pere.competenza       in ('A','C')
           and pere.servizio          = 'Q'
           and trpr.codice            = pere.trattamento
           and voec.codice            = vaca.voce
  group by to_char(vaca.riferimento,'yyyy')
         , to_char(nvl(vaca.competenza,vaca.riferimento),'yyyy') 
   having  round( sum(decode(vaca.colonna
                                  ,'COMP_FISSE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
                                               ,0))
                       / nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                       * nvl(max(decode( vaca.colonna
                                   , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
              + round( sum(decode(vaca.colonna
                                 ,'COMP_ACCESSORIE',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
								                   ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                  , '')),1) 
              + round( sum(decode(vaca.colonna
                                 ,'COMP_INADEL',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
								                   ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) 
             + round( sum(decode(vaca.colonna
                                 ,'COMP_TFR',decode( voec.classe||P_cassa
                                                      , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                            , nvl(vaca.valore,0))
								                   ,0))
                     / nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                     * nvl(max(decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) 
             + round( sum(decode(vaca.colonna
                                ,'IPN_TFR',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                 , '')),1) 
             + round( sum(decode(vaca.colonna
                                ,'COMP_PREMIO',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'PREAVV_RISARCITORIO',decode( voec.classe||P_cassa
                                                             , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                                   , nvl(vaca.valore,0))
                                                      ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'FERIE_NON_GODUTE',decode( voec.classe||P_cassa
                                                          , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                                , nvl(vaca.valore,0))
                                                   ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
             + round( sum(decode(vaca.colonna
                                ,'L_165',decode( voec.classe||P_cassa
                                               , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                     , nvl(vaca.valore,0))
                                        ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'L_165', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
              + round( sum(decode(vaca.colonna
                                ,'COMP_18',decode( voec.classe||P_cassa
                                                 , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                       , nvl(vaca.valore,0))
                                          ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
         	 + round( sum(decode(vaca.colonna
                                ,'TREDICESIMA',decode( voec.classe||P_cassa
                                                     , 'RX', nvl(vaca.valore,0) - nvl(vaca.ipn_eap,0)
                                                           , nvl(vaca.valore,0))
                                              ,0))
                    / nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                      )
                    * nvl(max(decode( vaca.colonna
                                , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)  != 0
     ) LOOP

-- dbms_output.put_line('loop cursore arretrati');
     D_num_servizi := D_num_servizi + 1;

       I_contribuzione := null;
       I_colonna       := null;
       I_enpdep        := null;
       BEGIN
         select substr(reco.rv_low_value,1,1)
           into I_pensione
           from pec_ref_codes             reco
          where reco.rv_domain    (+)  = 'DENUNCIA_INPDAP.ASSICURAZIONI'
            and reco.rv_abbreviation (+)  = CUR_ARR.previdenza
          group by reco.rv_low_value
         ;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           I_pensione    := null;
       END;
       BEGIN
         select decode( CUR_ARR.previdenza
                       , 'CPDEL', codice_cpd,codice_cps)
              , decode( CUR_ARR.previdenza
                       , 'CPDEL', posizione_cpd,posizione_cps)
           into I_codice,I_posizione
           from rapporti_retributivi
          where ci = CUR_PERS.ci
         ;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           I_codice    := null;
           I_posizione := null;
       END;
       BEGIN
         select to_char(greatest(min(dal)
                                ,to_date('0101'||CUR_ARR.anno_rif,'ddmmyyyy')),'ddmmyyyy')
               ,to_char(least(max(nvl(al,to_date('3333333','j')))
                            ,to_date(decode(P_sfasato
                                           ,'X',decode(CUR_ARR.anno_rif,D_anno-1,'3011','3112')||CUR_ARR.anno_rif
                                               ,'3112'||CUR_ARR.anno_rif
                                            )
                                    ,'ddmmyyyy'))
                       ,'ddmmyyyy')
           into I_dal_arr, I_al_arr
           from periodi_giuridici
          where rilevanza = 'P'
            and ci = CUR_PERS.ci
            and to_date(CUR_ARR.riferimento ,'ddmmyyyy')
                between dal
                    and nvl(al,to_date('3333333','j'))
         ;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           I_dal_arr := null;
           I_al_arr := null;
       END;
       IF I_dal_arr is null or I_al_arr is null then
-- setto le variabili ai valori di default per l''inserimento
        IF I_dal_arr is null THEN
         I_dal_arr  := '01'||to_char(to_date(CUR_ARR.riferimento,'ddmmyyyy'),'mmyyyy');
        END IF;
        IF I_al_arr is null THEN
         I_al_arr   := to_char(last_day(to_date(CUR_ARR.riferimento,'ddmmyyyy')),'ddmmyyyy');
        END IF;
-- inserisco la segnalazione
         BEGIN
           D_pr_err_12 := D_pr_err_12 + 1;
           INSERT INTO a_segnalazioni_errore
           ( no_prenotazione, passo, progressivo, errore, precisazione )
           SELECT prenotazione
                 , 1
                 , D_pr_err_12
                 , 'P05186'
                 , ' : Riferimenti Esterni per Cod.Ind.: '||RPAD(TO_CHAR(CUR_PERS.ci),8,' ')
--                 ||'  '||'Dal '||TO_CHAR(to_date(I_dal_arr,'ddmmyyyy'),'dd/mm/yyyy')
--                 ||'  '||'Al '||TO_CHAR(to_date(I_al_arr,'ddmmyyyy'),'dd/mm/yyyy')
           FROM dual;
         END;
       END IF;
-- dbms_output.put_line('ins. periodo arr.: '||to_char(cur_pers.ci)||' '||I_dal_arr||' '||I_al_arr);
        BEGIN
          I_contribuzione := null; 
          I_enpdep        := null;
          DENUNCE_INPDAP.CONTRIBUZIONE (D_anno, D_fin_a, cur_arr.arr_inadel,cur_arr.arr_tfr,cur_arr.arr_ipn_tfr, P_ci, I_contribuzione, I_enpdep);
        END;
       BEGIN
         select round(
                sum(decode( vaca.colonna
                          , 'COMP_PREMIO', nvl(vaca.valore,0)
                                         , 0))
                    / max(nvl(esvc.arrotonda,0.01))
                    )
                     * max(nvl(esvc.arrotonda,0.01))
           into I_comp_premio
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                       from mensilita
                                      where mese  = 12
                                        and tipo in ('A','N','S'))
            and D_num_servizi          = 1
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna           = 'COMP_PREMIO'
            and vaca.ci                = CUR_PERS.ci
            and vaca.moco_mensilita    != '*AP'
            and to_char(vaca.riferimento,'yyyy') < D_anno 
            and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
            ;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN I_comp_premio  := to_number(null);
       END;
       insert into denuncia_inpdap
            ( anno
            , previdenza
            , assicurazioni
            , ci
            , gestione
            , codice
            , posizione
            , rilevanza
            , dal
            , al
            , comp_fisse
            , comp_accessorie
            , comp_inadel
            , comp_tfr
            , ipn_tfr
            , premio_prod
            , ind_non_a
            , l_165
 	      , comp_18
  	      , tredicesima
            , riferimento
            , competenza
            , utente
            , data_agg
            , comparto
            , sottocomparto
            )
       select to_number(D_anno)
            , nvl(CUR_ARR.previdenza,'CPDEL')
            , nvl(I_pensione||I_contribuzione||I_enpdep||decode(nvl(CUR_ARR.previdenza,'CPDEL'), null, null, '9'),' ')
            , CUR_PERS.ci
            , CUR_ARR.gestione
            , I_codice
            , I_posizione
            ,'A'
            , to_date(I_dal_arr,'ddmmyyyy')
            , to_date(I_al_arr,'ddmmyyyy')
            , decode(instr(I_pensione,'1'),0,decode(CUR_ARR.arr_fisse,0,null,CUR_ARR.arr_fisse)
                                            ,decode(CUR_ARR.arr_fisse,0,null,CUR_ARR.arr_fisse - cur_arr.arr_tredicesima)
                    )
            , decode(CUR_ARR.arr_accessorie,0,null,CUR_ARR.arr_accessorie)
            , decode(CUR_ARR.arr_inadel,0,null,CUR_ARR.arr_inadel)
            , decode(CUR_ARR.arr_tfr,0,null,CUR_ARR.arr_tfr)
            , decode(CUR_ARR.arr_ipn_tfr,0,null,CUR_ARR.arr_ipn_tfr)
            , decode(CUR_ARR.arr_premio,0,null,CUR_ARR.arr_premio)
            , decode(CUR_ARR.arr_preav +CUR_ARR.arr_ferie,0,null,CUR_ARR.arr_preav + CUR_ARR.arr_ferie)
            , decode(CUR_ARR.arr_l_165,0,null,CUR_ARR.arr_l_165)
            , decode(instr(I_pensione,'1'),0,null
                                            ,decode(CUR_ARR.arr_comp_18,0,null,CUR_ARR.arr_comp_18))
		, decode(instr(I_pensione,'1'),0,null
                                            ,decode(CUR_ARR.arr_tredicesima,0,null,CUR_ARR.arr_tredicesima))
            , CUR_ARR.anno_rif
            , CUR_ARR.anno_comp
            , D_utente
            , to_date(D_fin_a,'ddmmyyyy')
            , P_comparto
            , P_sottocomparto
         from dual
       ;
       commit;
      BEGIN
      select greatest(nvl(max(progressivo),0),150000)
        into D_pr_err_5
        from a_segnalazioni_errore
       where no_prenotazione = prenotazione
         and passo           = 1
         and progressivo between 150000 and 200000;
      EXCEPTION 
           WHEN NO_DATA_FOUND THEN D_pr_err_5 := 150000;
      END;
      DENUNCE_INPDAP.DETERMINA_QUALIFICA(D_anno,CUR_PERS.ci,D_ini_a, D_fin_a,D_qualifica,CUR_ARR.gestione
                                        ,D_pr_err_5, prenotazione, P_denuncia);
    END LOOP;-- CUR_ARR

FOR CUR_CI IN
   (select distinct dedp.ci, dedp.gestione
    from denuncia_inpdap dedp
       , trattamenti_previdenziali trpr
     where dedp.anno = D_anno
--       and dedp.gestione   like D_gestione
       and dedp.gestione   = CUR_PERS.gestione
       and dedp.previdenza like D_previdenza
       and dedp.ci         = CUR_PERS.CI
) LOOP
D_num_servizi := 0;
-- loop per l'idendificazione dei periodi dell'individuo
         for CUR_DEDP IN
             (select dal, nvl(al,to_date(D_fin_a,'ddmmyyyy')) al
                   , assicurazioni, gestione, previdenza
			  from denuncia_inpdap
                     where ci        = CUR_CI.ci
			     and   anno      = D_anno
			     and   rilevanza = 'S'
			     and   gestione  = CUR_CI.gestione
                order by dal, nvl(al,to_date(D_fin_a,'ddmmyyyy')) 
                     ) LOOP
-- estrazione dei dati economici
D_num_servizi := D_num_servizi + 1;
          BEGIN
         select round(sum(decode( vaca.colonna
                                , 'COMP_FISSE', nvl(vaca.valore,0)
                                              , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
              , round(sum(decode( vaca.colonna
                          , 'COMP_ACCESSORIE', nvl(vaca.valore,0)
                                             , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
              , round(sum(decode( vaca.colonna
                          , 'COMP_INADEL', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
              , round(sum(decode( vaca.colonna
                          , 'COMP_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
             , round(sum(decode( vaca.colonna
                          , 'IPN_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
              , round( sum(decode(vaca.colonna
                                 ,'PREAVV_RISARCITORIO',nvl(vaca.valore,0),0))
                     / nvl(max(decode( vaca.colonna
                                 , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                     * nvl(max(decode( vaca.colonna
                                 , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
              , round( sum(decode(vaca.colonna
                                 ,'FERIE_NON_GODUTE',decode(greatest(D_anno-1
                                                                    ,to_char(vaca.riferimento,'yyyy'))
                                                           ,D_anno -1 , 0
                                                                      , nvl(vaca.valore,0)),0))
                     / nvl(max(decode( vaca.colonna
                                 , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                     * nvl(max(decode( vaca.colonna
                                 , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
              , round(sum(decode(vaca.colonna
                               ,'L_165',decode (greatest(D_anno-1
                                                        ,to_char(vaca.riferimento,'yyyy'))
                                               ,D_anno -1 , 0
                                                          , nvl(vaca.valore,0)),0))
                     / nvl(max(decode( vaca.colonna
                                 , 'L_165', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                     * nvl(max(decode( vaca.colonna
                                 , 'L_165', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
             ,  decode(instr(CUR_DEDP.assicurazioni ,'1')
                           ,0, null
                             , round( sum(decode(vaca.colonna
                                                ,'COMP_18',decode(greatest(D_anno-1,to_char(vaca.riferimento,'yyyy'))
                                                                  ,D_anno -1 , 0 
                                                                             , nvl(vaca.valore,0)),0))
                      / nvl(max(decode( vaca.colonna
                                  , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                      * nvl(max(decode( vaca.colonna
                                  , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
             , decode(instr(CUR_DEDP.assicurazioni ,'1')
                           ,0, null
                             , round(sum(decode(vaca.colonna
                                        ,'TREDICESIMA',decode(greatest(D_anno-1,to_char(vaca.riferimento,'yyyy'))
                                                             ,D_anno -1 , 0
                                                                        , nvl(vaca.valore,0))
                                        ,0))
                      / nvl(max(decode( vaca.colonna
                                  , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                      * nvl(max(decode( vaca.colonna
                                  , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
           into I_comp_fisse,I_comp_acc,I_comp_inadel,I_comp_tfr,I_ipn_tfr,
                I_preav,I_ferie,I_l_165, I_comp_18, I_tredicesima
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esvc.dal              <= nvl(CUR_DEDP.al,to_date('3333333','j'))
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= CUR_DEDP.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno
            and vaca.mese              = 12
            and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_INADEL','COMP_TFR','IPN_TFR'
                                         ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165','COMP_18'
                                         ,'TREDICESIMA')
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            and vaca.riferimento between CUR_DEDP.dal
                                     and least( nvl(CUR_DEDP.al,to_date(D_fin_a,'ddmmyyyy')),to_date(D_fin_a,'ddmmyyyy')) ;
         I_comp_fisse := nvl(I_comp_fisse,0) - nvl(I_tredicesima,0);
    EXCEPTION
         WHEN NO_DATA_FOUND THEN 
         I_comp_fisse        := to_number(null);
         I_comp_acc          := to_number(null);
         I_comp_inadel       := to_number(null);
         I_comp_tfr          := to_number(null);
         I_ipn_tfr           := to_number(null);
         I_l_165             := to_number(null);
         I_comp_18           := to_number(null);
         I_tredicesima       := to_number(null);
       END;
I_contribuzione  := null;
I_enpdep         := null;

DENUNCE_INPDAP.CONTRIBUZIONE (D_anno, D_fin_a, I_comp_inadel, I_comp_tfr, I_ipn_tfr, P_ci, I_contribuzione, I_enpdep);
       BEGIN
         select round(
                sum(decode( vaca.colonna
                          , 'COMP_PREMIO', nvl(vaca.valore,0)
                                         , 0))
                     / max(nvl(esvc.arrotonda,0.01))
                     )
                     * max(nvl(esvc.arrotonda,0.01))
           into I_comp_premio
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                       from mensilita
                                      where mese  = 12
                                        and tipo in ('A','N','S'))
            and D_num_servizi          = 1
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna           = 'COMP_PREMIO'
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            and to_char(vaca.riferimento,'yyyy') = D_anno
            and vaca.moco_mese        <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm');
       EXCEPTION
         WHEN NO_DATA_FOUND THEN I_comp_premio  := to_number(null);
       END;
-- CALCOLO GIORNI UTILI
BEGIN
     DENUNCE_INPDAP.GIORNI_UTILI(D_ANNO, CUR_CI.ci, CUR_DEDP.DAL, CUR_DEDP.AL, P_sfasato, P_riferimento, I_gg_utili);
END;
BEGIN
UPDATE DENUNCIA_INPDAP
   SET comp_fisse      = decode(I_comp_fisse,0,null,I_comp_fisse)
     , comp_accessorie = decode(I_comp_acc,0,null,I_comp_acc)
     , comp_inadel     = decode(I_comp_inadel,0,null,I_comp_inadel)
     , comp_tfr        = decode(I_comp_tfr,0,null,I_comp_tfr)
     , ipn_tfr         = decode(I_ipn_tfr,0,null,I_ipn_tfr)
     , premio_prod     = decode(I_comp_premio,0,null,I_comp_premio)
     , ind_non_a       = decode(I_preav +I_ferie,0,null,I_preav +I_ferie)
     , l_165           = decode(I_l_165,0,null,I_l_165)
     , comp_18         = decode(I_comp_18,0,null,I_comp_18)
     , tredicesima     = decode(I_tredicesima,0,null,I_tredicesima)
     , gg_utili        = I_gg_utili
     , riferimento     = D_anno
     , competenza      = D_anno
 WHERE anno            = D_anno
   AND previdenza      = nvl(CUR_DEDP.previdenza,'CPDEL')
   AND gestione        = CUR_DEDP.gestione
   AND ci              = CUR_CI.ci
   AND rilevanza       = 'S'
   AND dal             = CUR_DEDP.dal;
commit;
END; -- Fine update
   DENUNCE_INPDAP.ASSICURAZIONI_ASSENZE(D_anno, D_fin_a, P_ci);
END LOOP; -- CUR_DEDP

-- update di giorni utili e giorni tfr

   DENUNCE_INPDAP.GG_TFR(D_anno, to_char(D_al_gg,'ddmmyyyy'), P_ci);
--   DENUNCE_INPDAP.GG_UTILI(D_al_gg, D_anno, CUR_CI.ci, D_giorni);
update denuncia_inpdap dedp
   set tipo_impiego =
(select nvl(max(decode( posi.contratto_formazione
                 , 'NO', decode
                         ( posi.stagionale
                         , 'GG', '2'
                               , decode
                                 ( posi.part_time
                                 , 'SI', '8'
                                       , '1'
                                 )
                         )
                       , posi.tipo_formazione)) ,dedp.tipo_impiego)                  impiego
      from posizioni                   posi
         , astensioni                  aste
         , qualifiche_giuridiche       qugi
         , contratti_storici           cost
         , periodi_servizio_previdenza psep
     where psep.ci             = CUR_CI.ci
	 and psep.gestione       = dedp.gestione
       and psep.dal =
           (select min(pegis.dal)
                                    from periodi_giuridici pegis
                                   where pegis.rilevanza = 'S'
                                     and pegis.ci        = CUR_CI.ci
                                     and pegis.dal       >=
                                        (select max(dal) from periodi_giuridici
                                          where rilevanza = 'P'
                                            and ci = CUR_CI.ci
                                            and dal <= psep.dal))
       and aste.codice    (+)  = psep.assenza
       and aste.servizio  (+) != 0
       and posi.codice    (+)  = psep.posizione
       and qugi.numero         = psep.qualifica
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between qugi.dal
                                    and nvl(qugi.al,to_date('3333333','j'))
       and cost.contratto      = qugi.contratto
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between cost.dal
                                    and nvl(cost.al,to_date('3333333','j'))
       and psep.dal <= nvl(psep.al,to_date('3333333','j'))
       and psep.segmento      in
          (select 'i' from dual
            union
           select 'a' from dual
            union
           select 'c' from dual
            union
           select 'f' from dual
            union
           select 'u' from dual
            where not exists
                 (select 'x'
                    from periodi_servizio_previdenza
                   where ci      = psep.ci
                     and segmento = 'a'
                     and dal     <= psep.dal
                     and nvl(al,to_date('3333333','j')) >= psep.dal)
          )
)
where dedp.anno        = D_anno
  and dedp.ci           = CUR_CI.ci
  and dedp.tipo_impiego = '8'
;
commit;

-- sdoppiamento delle competenze fisse e accessorie solo se p_cassa è nullo
     IF P_cassa is null THEN
     BEGIN
     <<SDOPPIA_ARRETRATI>>
       update denuncia_inpdap 
          set competenza = D_anno
        where rilevanza = 'A'
          and anno       = D_anno
          and competenza < D_anno
          and ci         = CUR_CI.ci
          and nvl(comp_fisse,0) != 0
          and nvl(comp_accessorie,0) = 0
       ;
     insert into denuncia_inpdap
       ( anno, previdenza, assicurazioni, ci, gestione, codice, posizione, rilevanza
       , dal, al, tipo_impiego, tipo_servizio, perc_l300, gg_utili,  data_cessazione, causa_cessazione
       , comp_fisse, comp_accessorie, comp_inadel, premio_prod, comp_tfr, ipn_tfr
       , riferimento, competenza, comparto, sottocomparto, qualifica
       , utente, tipo_agg, data_agg )
      select anno, previdenza, assicurazioni, ci, gestione, codice, posizione, rilevanza
           , dal, al, tipo_impiego, tipo_servizio, perc_l300, gg_utili,  data_cessazione, causa_cessazione
           , comp_fisse, 0, comp_inadel, premio_prod, comp_tfr, ipn_tfr
           , riferimento, D_anno, comparto, sottocomparto, qualifica
           , utente, tipo_agg, data_agg 
       from denuncia_inpdap
      where rilevanza = 'A'
        and ci = CUR_CI.ci
        and anno = D_anno
        and nvl(comp_fisse,0) != 0
        and nvl(comp_accessorie,0) != 0
        ;
       update denuncia_inpdap
          set comp_fisse = 0,
              comp_inadel = 0,
              comp_tfr = 0,ipn_tfr=0,
              assicurazioni =  replace(replace(replace(assicurazioni,'6',''),'7',''),'8','')
        where rilevanza = 'A'
          and ci = CUR_CI.ci
          and anno = D_anno
          and nvl(comp_fisse,0) != 0
          and nvl(comp_accessorie,0) != 0
       ;
      update denuncia_inpdap 
         set competenza = riferimento
       where rilevanza = 'A'
         and ci = CUR_CI.ci
         and anno = D_anno
         and competenza = D_anno
         and nvl(comp_fisse,0) = 0
         and nvl(comp_accessorie,0) != 0;
     END SDOPPIA_ARRETRATI;
     END IF;
-- Aggiunge gli importi esterni al periodo archiviato (cessati dopo cedolino elaborato) 
FOR CUR_ESTERNI in 
(select ci, dal, al
   from denuncia_inpdap dedp
  where anno      = D_anno
    and rilevanza = 'S'
    and ci        = CUR_CI.ci
    and gestione  = CUR_CI.gestione
    and exists (select 'x' 
                from valori_contabili_annuali vaca
               where vaca.anno              = dedp.anno
                 and vaca.mese              = 12
                 and vaca.mensilita         = (select max(mensilita)
                                                  from mensilita
                                             where mese  = 12
                                               and tipo in ('A','N','S'))
                 and vaca.estrazione        = 'DENUNCIA_INPDAP'
                 and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                           ,'COMP_INADEL','COMP_TFR','IPN_TFR'
                                           ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165'
                                           )
                 and vaca.ci                = dedp.ci
                 and vaca.moco_mensilita    != '*AP'
                 and not exists (select 'x' from denuncia_inpdap
                                  where anno      = dedp.anno
                                    and ci        = dedp.ci
                                     and rilevanza = dedp.rilevanza
                                     and vaca.riferimento between dal and nvl(al,to_date(D_fin_a,'ddmmyyyy'))
                                )
               )
  ) LOOP
  BEGIN
  V_fisse_esterne     := 0;
  V_fisse_prec        := 0;
  V_acc_esterne       := 0;
  V_acc_prec          := 0;
  V_inadel_esterne    := 0;
  V_inadel_prec       := 0;
  V_tfr_esterne       := 0;
  V_tfr_prec          := 0;
  V_ipn_tfr_esterne   := 0;
  V_ipn_tfr_prec      := 0;
  V_preav_esterne     := 0;
  V_preav_prec        := 0;
  V_ferie_esterne     := 0;
  V_ferie_prec        := 0;
  V_L165_esterne      := 0;
  V_L165_prec         := 0;

        select nvl(round(sum(decode( vaca.colonna
                                , 'COMP_FISSE', nvl(vaca.valore,0)
                                              , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'COMP_ACCESSORIE', nvl(vaca.valore,0)
                                             , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'COMP_INADEL', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'COMP_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'IPN_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                            * nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round( sum(decode(vaca.colonna
                                     ,'PREAVV_RISARCITORIO',nvl(vaca.valore,0),0))
                         / nvl(max(decode( vaca.colonna
                                     , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
									 ,'')),1)
                          )
                         * nvl(max(decode( vaca.colonna
                                     , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round( sum(decode(vaca.colonna
                                     ,'FERIE_NON_GODUTE',decode(greatest(D_anno-1
                                                                        ,to_char(vaca.riferimento,'yyyy'))
                                                               ,D_anno -1 , 0
                                                                          , nvl(vaca.valore,0)),0))
                         / nvl(max(decode( vaca.colonna
                                     , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                         * nvl(max(decode( vaca.colonna
                                     , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode(vaca.colonna
                                   ,'L_165',decode (greatest(D_anno-1
                                                            ,to_char(vaca.riferimento,'yyyy'))
                                                   ,D_anno -1 , 0
                                                              , nvl(vaca.valore,0)),0))
                         / nvl(max(decode( vaca.colonna
                                     , 'L_165', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                         * nvl(max(decode( vaca.colonna
                                     , 'L_165', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
           into V_fisse_esterne, V_acc_esterne, V_inadel_esterne, V_tfr_esterne,V_ipn_tfr_esterne
              , V_preav_esterne, V_ferie_esterne, V_L165_esterne
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and vaca.riferimento between to_date(D_ini_a,'ddmmyyyy')   -- AGGIUNTO PER TESTARE CHE LE SOMME CHE VADO AD 
  				   	       and to_date(D_fin_a,'ddmmyyyy')   -- NON SIANO ARRETRATI
            and esvc.dal              <= nvl(CUR_ESTERNI.al,to_date(D_fin_a,'ddmmyyyy') )
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= CUR_ESTERNI.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_INADEL','COMP_TFR','IPN_TFR'
                                         ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165'
                                         )
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
            and not exists (select 'x' from denuncia_inpdap
                             where anno      = D_anno
                               and ci        = CUR_CI.ci
                               and rilevanza = 'S'
                               and vaca.riferimento between dal and nvl(al,to_date(D_fin_a,'ddmmyyyy'))
                           )
            and nvl(CUR_ESTERNI.dal,to_date(D_ini_a,'ddmmyyyy') )=
                   (select max(nvl(dal,to_date(D_ini_a,'ddmmyyyy') ))
                      from denuncia_inpdap
                     where anno             = D_anno
                       and ci               = CUR_CI.ci
                       and rilevanza        = 'S'
                       and vaca.riferimento > nvl(al,to_date(D_fin_a,'ddmmyyyy') )
                   );
        select nvl(round(sum(decode( vaca.colonna
                                , 'COMP_FISSE', nvl(vaca.valore,0)
                                              , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'COMP_ACCESSORIE', nvl(vaca.valore,0)
                                             , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'COMP_INADEL', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'COMP_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode( vaca.colonna
                          , 'IPN_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                            * nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
                , nvl(round( sum(decode(vaca.colonna
                                     ,'PREAVV_RISARCITORIO',nvl(vaca.valore,0),0))
                         / nvl(max(decode( vaca.colonna
                                     , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                         * nvl(max(decode( vaca.colonna
                                     , 'PREAVV_RISARCITORIO', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round( sum(decode(vaca.colonna
                                     ,'FERIE_NON_GODUTE',decode(greatest(D_anno-1
                                                                        ,to_char(vaca.riferimento,'yyyy'))
                                                               ,D_anno -1 , 0
                                                                          , nvl(vaca.valore,0)),0))
                         / nvl(max(decode( vaca.colonna
                                     , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                         * nvl(max(decode( vaca.colonna
                                     , 'FERIE_NON_GODUTE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
              , nvl(round(sum(decode(vaca.colonna
                                   ,'L_165',decode (greatest(D_anno-1
                                                            ,to_char(vaca.riferimento,'yyyy'))
                                                   ,D_anno -1 , 0
                                                              , nvl(vaca.valore,0)),0))
                         / nvl(max(decode( vaca.colonna
                                     , 'L_165', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                          )
                         * nvl(max(decode( vaca.colonna
                                     , 'L_165', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                   ,0)
           into V_fisse_prec, V_acc_prec, V_inadel_prec, V_tfr_prec,V_ipn_tfr_prec
              , V_preav_prec, V_ferie_prec, V_L165_prec
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and vaca.riferimento between to_date(D_ini_a,'ddmmyyyy')   -- AGGIUNTO PER TESTARE CHE LE SOMME CHE VADO AD 
  				   	       and to_date(D_fin_a,'ddmmyyyy')   -- NON SIANO ARRETRATI
            and esvc.dal              <= nvl(CUR_ESTERNI.al,to_date(D_fin_a,'ddmmyyyy') )
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= CUR_ESTERNI.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_INADEL','COMP_TFR','IPN_TFR'
                                         ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165'
                                         )
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
            and not exists (select 'x' from denuncia_inpdap
                             where anno      = D_anno
                               and ci        = CUR_CI.ci
                               and rilevanza = 'S'
                               and vaca.riferimento between dal and nvl(al,to_date(D_fin_a,'ddmmyyyy'))
                           )
            and nvl(CUR_ESTERNI.dal,to_date(D_ini_a,'ddmmyyyy') )=
                   (select min(nvl(dal,to_date(D_ini_a,'ddmmyyyy') ))
                      from denuncia_inpdap dedp1
                     where anno             = D_anno
                       and ci               = CUR_CI.ci
                       and rilevanza        = 'S'
                       and vaca.riferimento < nvl(dal,to_date(D_ini_a,'ddmmyyyy'))
                       and not exists (select 'x' from denuncia_inpdap
                                        where ci        = dedp1.ci 
                                          and rilevanza = 'S'
                                          and anno      = D_anno
                                          and nvl(dal,to_date(D_ini_a,'ddmmyyyy'))
                                            < nvl(dedp1.dal,to_date(D_ini_a,'ddmmyyyy'))
                                       )
                   );
           update denuncia_inpdap dedp
              set comp_fisse      = nvl(comp_fisse,0) + nvl(V_fisse_esterne,0) + nvl(V_fisse_prec,0)
                , comp_accessorie = nvl(comp_accessorie,0) + nvl(V_acc_esterne,0) + nvl(V_acc_prec,0)
                , comp_inadel     = nvl(comp_inadel,0) + nvl(V_inadel_esterne,0) + nvl(V_inadel_prec,0)
                , comp_tfr        = nvl(comp_tfr,0) + nvl(V_tfr_esterne,0) + nvl(V_tfr_prec,0)
                , ipn_tfr         = nvl(ipn_tfr,0) + nvl(V_ipn_tfr_esterne,0) + nvl(V_ipn_tfr_prec,0)
                , ind_non_a       = nvl(ind_non_a,0) + nvl(V_preav_esterne,0) + nvl(V_preav_prec,0)
                                  + nvl(V_ferie_esterne,0) + nvl(V_ferie_prec,0)
                , L_165           = nvl(L_165,0) + nvl(V_L165_esterne,0) + nvl(V_L165_prec,0)
            where anno        = D_anno
              and ci          = CUR_CI.ci
              and dal         = CUR_ESTERNI.dal
              and rilevanza   = 'S'
           ;
           commit;
   END;
  END LOOP; -- cur_esterni

IF P_rapporta_somme = 'X' THEN
BEGIN
        select sum(nvl(comp_fisse,0))
          into V_app_comp_fisse_tot
         from denuncia_inpdap
        where anno      = D_anno
          and ci        = CUR_CI.ci
          and rilevanza = 'S'
        ;
  BEGIN -- Modifiche per Assenze non INPDAP
  <<AGGIORNA_IMPORTI_ASSENZE>> -- aggiornamento per periodi di Assenza NON INPDAP
    BEGIN
     select 'X' 
       into P_assenza
       from dual
      where exists (select 'x' 
                      from denuncia_inpdap dedp
                     where anno      = D_anno
                       and ci              = CUR_CI.ci
                       and rilevanza       = 'S'
                       and exists (select 'x' 
                                     from periodi_giuridici pegi
                                    where rilevanza = 'A'
                                     and ci        = dedp.ci
                                     and assenza in ( select codice from astensioni 
                                         where servizio = 0)
                                     and pegi.dal <=  to_date(D_fin_a,'ddmmyyyy')
                                     and nvl(pegi.al,TO_DATE('3333333','j')) >= to_date(D_ini_a,'ddmmyyyy')
                                     )
                    )
      ;
      EXCEPTION WHEN NO_DATA_FOUND THEN P_assenza := null;
      END;
      IF P_assenza = 'X' THEN
        select sum(nvl(comp_fisse,0))
          into V_app_comp_fisse
         from denuncia_inpdap
        where anno      = D_anno
          and ci        = CUR_CI.ci
          and rilevanza = 'S'
        ;
      FOR CUR_DEDP_ASS in 
         ( select dal, al, ci, gg_utili 
             from denuncia_inpdap
            where anno      = D_anno
              and ci        = CUR_CI.ci
              and rilevanza = 'S'
            order by dal, al
         ) LOOP 
           BEGIN
           D_pr_err_10 := D_pr_err_10 + 1;
           INSERT INTO a_segnalazioni_errore
           ( no_prenotazione, passo, progressivo, errore, precisazione )
           SELECT prenotazione
                 , 1
                 , D_pr_err_10
                 , 'P05189'
                 , 'Assenza - Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')
                   ||' '||'Dal '||TO_CHAR(CUR_DEDP_ASS.dal,'dd/mm/yyyy')
           FROM dual;
           END;
        V_comp_fisse := 0;
        V_comp_13a   := 0;
         BEGIN
         <<RICALCOLO>>
         select round(sum(inre.tariffa/decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
                                      /decode(cost.ore_lavoro,0,1,cost.ore_lavoro)
                                      *nvl(pegi.ore,decode(cost.ore_lavoro,0,1,cost.ore_lavoro))
                      )) * CUR_DEDP_ASS.gg_utili
           into V_comp_fisse
           from  informazioni_retributive inre
               , periodi_giuridici        pegi
               , contratti_storici        cost
               , qualifiche_giuridiche    qugi
          where inre.ci               = CUR_DEDP_ASS.ci
            and inre.ci               = pegi.ci
            and pegi.rilevanza        = 'S'
            and nvl(inre.al,to_date('3333333','j'))
                between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
            and qugi.numero           = pegi.qualifica
            and nvl(pegi.al,to_date('3333333','j')) 
                between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
            and cost.contratto      = qugi.contratto
            and nvl(inre.al,to_date('3333333','j'))
                between cost.dal and nvl(cost.al,to_date('3333333','j'))
            and CUR_DEDP_ASS.dal 
                between nvl(inre.dal,to_date('2222222','j')) and nvl(inre.al,to_date('3333333','j'))
            and (inre.voce,inre.sub) in (select voce,sub 
                                           from estrazione_righe_contabili esrc
                                          where esrc.estrazione = 'DENUNCIA_INPDAP'
                                            and esrc.colonna = 'COMP_FISSE' 
                                            and nvl(inre.al,to_date('3333333','j'))
                                                between esrc.dal and nvl(esrc.al,to_date('3333333','j'))
                                         )
         ;
         select round(sum(nvl(imp,0)))
           into V_comp_13a
           from movimenti_contabili moco
          where moco.anno = D_anno
            and (voce,sub) in (select voce,sub 
                                 from estrazione_righe_contabili
                                where estrazione = 'DENUNCIA_INPDAP'
                                  and colonna    = 'TREDICESIMA'
                                  and moco.riferimento between dal and nvl(al,to_date(D_fin_a,'ddmmyyyy'))
                              )
            and moco.ci = CUR_CI.ci
            and moco.riferimento 
                between CUR_DEDP_ASS.dal and nvl(CUR_DEDP_ASS.al,to_date(D_fin_a,'ddmmyyyy'))
         ;

         update denuncia_inpdap
            set comp_fisse = nvl(V_comp_fisse,0) + nvl(V_comp_13a,0)
          where anno = D_anno
            and ci   = CUR_CI.ci
            and dal  = CUR_DEDP_ASS.dal
            and rilevanza = 'S'
         ;
         END RICALCOLO;
         END LOOP; -- cur_dedp_ass
         BEGIN
         <<ASSESTAMENTO>>
         V_new_comp_fisse  := 0;
         V_diff_fisse      := 0;
         select sum(nvl(comp_fisse,0))
           into V_new_comp_fisse
           from denuncia_inpdap
          where anno      = D_anno
            and ci        = CUR_CI.ci
            and rilevanza = 'S'
            ;
         select nvl(V_app_comp_fisse,0) - nvl(V_new_comp_fisse,0) 
           into V_diff_fisse
           from dual;
             IF abs(V_diff_fisse) != 0
                THEN
                   update denuncia_inpdap dedp
                      set comp_fisse = 
                         (select decode( nvl(dedp.comp_fisse, 0 ) + V_diff_fisse
                                        , 0 , null
                                            , nvl(dedp.comp_fisse, 0 ) + V_diff_fisse
                                       )
                            from denuncia_inpdap 
                           where ci        = dedp.ci
                             and rilevanza = dedp.rilevanza
                             and dal       = dedp.dal
                          )
                    where anno      = D_anno
                      and rilevanza = 'S'
                      and ci        = CUR_CI.ci
                      and dal = (select max(dal) from denuncia_Inpdap
                                  where ci       = dedp.ci
                                    and anno     = dedp.anno
                                   and rilevanza = dedp.rilevanza
                                )
              ;
             END IF;
         END ASSESTAMENTO;      
      END IF; -- P_assenza
   /*    BEGIN -- Modifica per San Lazzaro
            update denuncia_inpdap dedp
               set comp_fisse = round(comp_fisse*30/100)
             where anno          = D_anno
               and rilevanza     = 'S'
               and ci            = CUR_CI.ci
               and tipo_servizio = '9'
            ;
         END;
   */
  END AGGIORNA_IMPORTI_ASSENZE;
  BEGIN
  <<AGGIORNA_FISSE_SPEZZATI>> -- aggiornamento per periodi spezzati nel mese
    FOR CUR_DEDP_PERIODI in 
    ( select dal, al, gg_utili
        from denuncia_inpdap dedp
       where anno              = D_anno
         and ci                = CUR_CI.ci
         and rilevanza         = 'S'
         and nvl(comp_fisse,0) = 0
         and nvl(gg_utili,0)  != 0
         and peccaedp.ESTRAI_RECORD (dedp.ci, D_anno, dedp.al) is not null
         and nvl(al,to_date('3333333','j')) != last_day(nvl(al,to_date('3333333','j')))
       order by dal, al
    ) LOOP
    BEGIN
      V_comp_fisse := 0;
      V_app_comp_fisse := 0;
      V_new_comp_fisse  := 0;
      V_diff_fisse      := 0;
           BEGIN
           D_pr_err_11 := D_pr_err_11 + 1;
           INSERT INTO a_segnalazioni_errore
           ( no_prenotazione, passo, progressivo, errore, precisazione )
           SELECT prenotazione
                 , 1
                 , D_pr_err_11
                 , 'P05189'
                 , 'Periodi Spezzati - CI: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')
                   ||' '||'Dal '||TO_CHAR(CUR_DEDP_PERIODI.dal,'dd/mm/yyyy')
            FROM dual;
           END;
      BEGIN
      <<RICALCOLO1>>
      select sum(nvl(comp_fisse,0))
        into V_app_comp_fisse
        from denuncia_inpdap
       where anno = D_anno
         and ci   = CUR_CI.ci
         and rilevanza = 'S'
         and nvl(al,to_date('3333333','j')) = last_day(nvl(CUR_DEDP_PERIODI.al,to_date('3333333','j')))
      ;
         select round(sum(inre.tariffa/decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
                                      /decode(cost.ore_lavoro,0,1,cost.ore_lavoro)
                                      *nvl(pegi.ore,decode(cost.ore_lavoro,0,1,cost.ore_lavoro))
                      )) * CUR_DEDP_PERIODI.gg_utili
           into V_comp_fisse
           from  informazioni_retributive inre
               , periodi_giuridici        pegi
               , contratti_storici        cost
               , qualifiche_giuridiche    qugi
          where inre.ci               = CUR_CI.ci
            and inre.ci               = pegi.ci
            and pegi.rilevanza        = 'S'
            and nvl(inre.al,to_date('3333333','j'))
                between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
            and qugi.numero           = pegi.qualifica
            and nvl(pegi.al,to_date('3333333','j')) 
                between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
            and cost.contratto      = qugi.contratto
            and nvl(inre.al,to_date('3333333','j'))
                between cost.dal and nvl(cost.al,to_date('3333333','j'))
            and CUR_DEDP_PERIODI.dal 
                between nvl(inre.dal,to_date('2222222','j')) and nvl(inre.al,to_date('3333333','j'))
            and (inre.voce,inre.sub) in (select voce,sub 
                                           from estrazione_righe_contabili esrc
                                          where esrc.estrazione = 'DENUNCIA_INPDAP'
                                            and esrc.colonna = 'COMP_FISSE' 
                                            and nvl(inre.al,to_date('3333333','j'))
                                                between esrc.dal and nvl(esrc.al,to_date('3333333','j'))
                                         )
         ;
         update denuncia_inpdap
            set comp_fisse = nvl(V_comp_fisse,0) + nvl(V_comp_13a,0)
          where anno      = D_anno
            and ci        = CUR_CI.ci
            and dal       = CUR_DEDP_PERIODI.dal
            and rilevanza = 'S'
         ;
       END RICALCOLO1;
         BEGIN
         <<ASSESTAMENTO1>>
            select sum(nvl(comp_fisse,0))
              into V_new_comp_fisse
              from denuncia_inpdap
             where anno      = D_anno
               and ci        = CUR_CI.ci
               and rilevanza = 'S'
               and last_day(nvl(al,to_date('3333333','j'))) = last_day(nvl(CUR_DEDP_PERIODI.al,to_date('3333333','j'))) 
            ;
         select nvl(V_app_comp_fisse,0) - nvl(V_new_comp_fisse,0) 
           into V_diff_fisse
           from dual;
             IF abs(V_diff_fisse) != 0
                THEN
                   update denuncia_inpdap dedp
                      set comp_fisse = 
                         (select decode( nvl(dedp.comp_fisse, 0 ) + V_diff_fisse
                                        , 0 , null
                                            , nvl(dedp.comp_fisse, 0 ) + V_diff_fisse
                                       )
                            from denuncia_inpdap 
                           where ci        = dedp.ci
                             and rilevanza = dedp.rilevanza
                             and dal       = dedp.dal
                          )
                    where anno      = D_anno
                      and rilevanza = 'S'
                      and ci        = CUR_CI.ci
                      and dal = (select max(dal) from denuncia_inpdap
                                  where ci       = dedp.ci
                                    and anno     = dedp.anno
                                    and rilevanza = dedp.rilevanza
                                    and nvl(al,to_date('3333333','j')) 
                                      = last_day(nvl(CUR_DEDP_PERIODI.al,to_date('3333333','j')))
                                )
              ;
             END IF;
         END ASSESTAMENTO1;
       END;
      END LOOP; -- CUR_DEDP_PERIODI
  END AGGIORNA_FISSE_SPEZZATI;
  BEGIN
    <<AGGIORNA_INADEL_TFR>>
    -- Assestamento INADEL e TFR
     select round(sum(nvl(comp_fisse,0)) / 100 * 80)
          , sum(nvl(comp_inadel,0)) 
          , sum(nvl(ipn_tfr,0))
       into V_app_comp_fisse, V_app_comp_inadel, V_app_ipn_tfr
      from denuncia_inpdap
     where anno = D_anno
       and rilevanza = 'S'
       and ci        = CUR_CI.ci;

            IF nvl(V_app_comp_fisse,0) = nvl(V_app_comp_inadel,0) THEN
               update denuncia_inpdap dedp
                  set comp_inadel = round( nvl(comp_fisse,0) / 100 * 80)
               where anno      = D_anno
                 and rilevanza = 'S'
                 and ci        = CUR_CI.ci
                 and nvl(comp_fisse,0) != nvl(comp_inadel,0)
               ;
            END IF; -- modifica competenze inadel
            IF nvl(V_app_comp_fisse,0) = nvl(V_app_ipn_tfr,0) THEN
               update denuncia_inpdap dedp
                  set ipn_tfr = round( nvl(comp_fisse,0) / 100 * 80)
               where anno      = D_anno
                 and rilevanza = 'S'
                 and ci = CUR_CI.ci
                 and nvl(comp_fisse,0) != nvl(ipn_tfr,0)
               ;
            END IF; -- modifica competenze tfr
  END AGGIORNA_INADEL_TFR;
  BEGIN -- controllo finale
  <<CONTROLLO_FINALE>>
    V_app_comp_fisse_tot1   := 0;
        select sum(nvl(comp_fisse,0))
          into V_app_comp_fisse_tot1
         from denuncia_inpdap
        where anno      = D_anno
          and ci        = CUR_CI.ci
          and rilevanza = 'S'
        ;
         select nvl(V_app_comp_fisse_tot,0) - nvl(V_app_comp_fisse_tot1,0) 
           into V_diff_fisse
           from dual;
        IF abs(V_diff_fisse) > 5 THEN
        update denuncia_inpdap dedp
            set comp_fisse = (select decode( nvl(dedp.comp_fisse, 0 ) + V_diff_fisse
                                        , 0 , null
                                            , nvl(dedp.comp_fisse, 0 ) + V_diff_fisse
                                       )
                            from denuncia_inpdap 
                           where ci        = dedp.ci
                             and rilevanza = dedp.rilevanza
                             and dal       = dedp.dal
                          )
                    where anno      = D_anno
                      and rilevanza = 'S'
                      and ci        = CUR_CI.ci
                      and dal = (select max(dal) from denuncia_inpdap
                                  where ci       = dedp.ci
                                    and anno     = dedp.anno
                                    and rilevanza = dedp.rilevanza
                                );
        END IF; -- controllo su v_diff
     END;
  END CONTROLLO_FINALE;
 END IF; -- p_rapporta_somme
 
END LOOP;  -- CUR_CI

DENUNCE_INPDAP.UPDATE_IMPIEGO_SERVIZIO(D_anno, D_fin_a, P_denuncia,to_date(D_fin_a,'ddmmyyyy'));
DENUNCE_INPDAP.ASSICURAZIONI_ASSENZE(D_anno, D_fin_a, P_ci);

DENUNCE_INPDAP.NON_ARCHIVIATI (D_anno, cur_pers.ci, prenotazione, cur_pers.gestione, D_pr_err_8);

  BEGIN -- controllo giorni
  V_gg_ut  := 0;
  V_gg_tfr := 0;
   BEGIN 
     select sum(nvl(gg_utili,0)),  sum(nvl(gg_tfr,0))
       into V_gg_ut, V_gg_tfr
       from denuncia_inpdap
      where ci   = CUR_PERS.ci
        and anno = D_anno
      ;
   EXCEPTION 
     WHEN NO_DATA_FOUND THEN 
          V_gg_ut  := 0;
          V_gg_tfr := 0;
   END;
   IF ( D_giorni = 'X' and V_gg_ut  > 365 and D_anno != 2004
     or D_giorni = 'X' and V_gg_tfr > 365 and D_anno != 2004
     or D_giorni = 'X' and V_gg_ut  > 366 and D_anno = 2004
     or D_giorni = 'X' and V_gg_tfr > 366 and D_anno = 2004
      ) THEN
      D_pr_err_9 := D_pr_err_9 + 1;
      IF D_anno = 2004 THEN
      INSERT INTO a_segnalazioni_errore
      ( no_prenotazione, passo, progressivo, errore, precisazione )
      SELECT prenotazione
           , 1
           , D_pr_err_9
           , 'P05187'
           , ' '||to_char(366)||' - Cod.Ind.: '||RPAD(TO_CHAR(CUR_PERS.ci),8,' ')
        FROM dual;
      ELSE
      INSERT INTO a_segnalazioni_errore
      ( no_prenotazione, passo, progressivo, errore, precisazione )
      SELECT prenotazione
           , 1
           , D_pr_err_9
           , 'P05187'
           , ' '||to_char(365)||' - Cod.Ind.: '||RPAD(TO_CHAR(CUR_PERS.ci),8,' ')
        FROM dual;
      END IF;
   ELSIF ( V_gg_ut > 360 
        or V_gg_tfr > 360 
         ) THEN
      D_pr_err_9 := D_pr_err_9 + 1;
      INSERT INTO a_segnalazioni_errore
      ( no_prenotazione, passo, progressivo, errore, precisazione )
      SELECT prenotazione
           , 1
           , D_pr_err_9
           , 'P05187'
           , ' '||to_char(360)||' - Cod.Ind.: '||RPAD(TO_CHAR(CUR_PERS.ci),8,' ')
        FROM dual;
   END IF;
  END;
  BEGIN
    update denuncia_inpdap
       set comparto = P_comparto
         , sottocomparto = P_sottocomparto
     where ci   = CUR_PERS.ci
       and anno = D_anno
       and ( comparto is null
          or sottocomparto is null)
     ;
  END;
-- Assestamento assicurazioni INADEL per precedenti archiviazioni 
update denuncia_inpdap dedp
set assicurazioni = decode(instr(dedp.assicurazioni,'8')
                          , 0, decode(instr(dedp.assicurazioni,'9')
                                      ,0, dedp.assicurazioni||'6'
                                        , substr(dedp.assicurazioni,1,instr(dedp.assicurazioni,'9')-1)||'6'||
                                          substr(dedp.assicurazioni,instr(dedp.assicurazioni,'9'))
                                      )
                             , substr(dedp.assicurazioni,1,instr(dedp.assicurazioni,'8')-1)||'6'||
                                      substr(dedp.assicurazioni,instr(dedp.assicurazioni,'8'))
                           )
where dedp.anno      = D_anno
  and dedp.ci        = CUR_PERS.ci
  and dedp.rilevanza = 'S'
  and instr(dedp.assicurazioni,'6') = 0
  and exists (select 'x' from denuncia_inpdap dedp1
               where dedp1.ci = dedp.ci 
                 and dedp1.anno = dedp.anno
                 and dedp1.rilevanza = 'S'
                 and instr(dedp1.assicurazioni,'6') != 0
             )
  and ( nvl(comp_inadel,0) != 0
   or nvl(comp_tfr,0) != 0
   or nvl(ipn_tfr,0) != 0)
;
update denuncia_inpdap dedp
set assicurazioni = decode(instr(dedp.assicurazioni,'8')
                          , 0, decode(instr(dedp.assicurazioni,'9')
                                      ,0, dedp.assicurazioni||'7'
                                        , substr(dedp.assicurazioni,1,instr(dedp.assicurazioni,'9')-1)||'7'||
                                          substr(dedp.assicurazioni,instr(dedp.assicurazioni,'9'))
                                      )
                             , substr(dedp.assicurazioni,1,instr(dedp.assicurazioni,'8')-1)||'7'||
                                      substr(dedp.assicurazioni,instr(dedp.assicurazioni,'8'))
                           )
where dedp.anno      = D_anno
  and dedp.ci        = CUR_PERS.ci
  and dedp.rilevanza = 'S'
  and instr(dedp.assicurazioni,'7') = 0
  and exists (select 'x' from denuncia_inpdap dedp1
               where dedp1.ci = dedp.ci 
                 and dedp1.anno = dedp.anno
                 and dedp1.rilevanza = 'S'
                 and instr(dedp1.assicurazioni,'7') != 0
             )
  and ( nvl(comp_inadel,0) != 0
   or nvl(comp_tfr,0) != 0
   or nvl(ipn_tfr,0) != 0)
;
update denuncia_inpdap dedp
set assicurazioni = decode(instr(dedp.assicurazioni,'8')
                          , 0, decode(instr(dedp.assicurazioni,'9')
                                      ,0, dedp.assicurazioni||'6'
                                        , substr(dedp.assicurazioni,1,instr(dedp.assicurazioni,'9')-1)||'6'||
                                          substr(dedp.assicurazioni,instr(dedp.assicurazioni,'9'))
                                      )
                             , substr(dedp.assicurazioni,1,instr(dedp.assicurazioni,'8')-1)||'6'||
                                      substr(dedp.assicurazioni,instr(dedp.assicurazioni,'8'))
                           )
where dedp.anno      = D_anno
  and dedp.ci        = CUR_PERS.ci
--  and dedp.rilevanza = 'S'
  and instr(dedp.assicurazioni,'6') = 0
  and instr(dedp.assicurazioni,'7') = 0
  and not exists (select 'x' from denuncia_inpdap dedp1
                   where dedp1.ci = dedp.ci 
                     and dedp1.anno = dedp.anno
                     and dedp1.rilevanza = 'S'
                     and instr(dedp1.assicurazioni,'6') != 0
                     and instr(dedp1.assicurazioni,'7') != 0
             )
  and ( nvl(comp_inadel,0) != 0
   or nvl(comp_tfr,0) != 0
   or nvl(ipn_tfr,0) != 0)
;
-- modifica per BO8617 
-- azzero casella 89 se la casella 102 = 0
 BEGIN 
 V_app_ipn_tfr_1 := 0;
  select sum(nvl(ipn_tfr,0)) 
    into V_app_ipn_tfr_1
    from denuncia_inpdap
   where anno  = D_anno
     and ci    = CUR_PERS.ci;
  IF V_app_ipn_tfr_1 = 0 THEN
     update denuncia_inpdap 
        set comp_tfr = null
     where anno = D_anno  
       and nvl(comp_tfr,0) != 0
       and ci    = CUR_PERS.ci;
  END IF;
 END;

--
-- Eliminazione delle assicurazioni INADEL se non sono valorizzate le relative competenze (visti dei casi a San Lazzaro - 15/10/2004)
--
 update denuncia_inpdap 
    set assicurazioni = substr(assicurazioni,1,instr(assicurazioni,'6')-1)||
                        substr(assicurazioni,instr(assicurazioni,'6')+1)
  where anno                      = D_anno
    and ci                        = CUR_PERS.ci 
    and instr(assicurazioni,'6') != 0
    and nvl(comp_inadel,0) 
        + nvl(comp_tfr,0)    
        + nvl(ipn_tfr,0)          = 0
;
END LOOP;  -- CUR_PERS

EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
END;
end;
end;
/

