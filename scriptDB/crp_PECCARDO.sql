CREATE OR REPLACE PACKAGE PECCARDO IS
/******************************************************************************
 NOME:          PECCARDO
 DESCRIZIONE:   Elaborazione per il caricamento dell'archivio denuncia ONAOSI
                Questa fase inserisce nelle tabelle DENUNCIA_ONAOSI e DENUNCIA_EVENTI_ONAOSI
		    i dati da dichiarare per il periodo richiesto
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO P_anno indica l'anno di riferimento da elaborare.
		   Il PARAMETRO P_periodo indica il semestre da elaborare
		   Il PARAMETRO P_gestione indica una specifica gestione da elaborare
		   Il PARAMETRO P_tipo indica il tipo di elaborazione (totale, parziale, ecc.)
		   Il PARAMETRO P_ci indica il dipendente richiesto per eventuali elaborazioni individuali
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    08/07/2004  ML
 2    27/09/2004  AM-ML sistemazione arretrati
 3    03/01/2005  AM    sistemazione arretrati: esclusi gli arr. AP dalla ripartizione sui mesi
 3.1  28/01/2005  ML	sistemazione arretrati: somma degli arretrati AP nel dovuto 
 4    05/12/2005  ML    Gestione nuova modalità di calcolo. (A13250)
                        Sistemazione ricalcolo dovuto in caso di aspettativa (A9594).
 4.1  09/01/2006  ML    sistemazione calcolo totale_dovuto e debito_credito (A14224).
 4.2  15/02/2006  NN    Passati anche voce e data (null) al calcolo onaosi.
 4.3  08/06/2006  ML    Gestione sia estrazione M che R per determinare il mese come dovuto (A15100).
 4.4  10/07/2006  ML    Gestione eventi per rinnovo contratto (A16883).
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCARDO IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V4.4 del 10/07/2006';
END VERSIONE;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
 P_ente       varchar2(4);
 P_ambiente   varchar2(8);
 P_utente     varchar2(8);
 P_anno       VARCHAR2(4);
 P_gestione   VARCHAR2(8);
 P_tipo	      VARCHAR2(1);
 P_ci	      NUMBER;
 P_contratto  varchar2(1);
 P_ini_ela    date;
 P_fin_ela    date;
 P_rif_ona    DATE;
 P_periodo    number;
 P_anno_prec  number;
 P_ini_prec   DATE;
 P_fin_prec   DATE;
 P_data_cess  DATE;

  P_conta		number;
  P_trattenuta_prec	number;
  P_tratt_2003          number;
  P_mese_1		number;
  P_mese_2		number;
  P_mese_3		number;
  P_mese_4		number;
  P_mese_5		number;
  P_mese_6		number;
  P_credito_prec	number;
  P_credito_gp4		number;
  P_totale_dovuto	number;
  P_totale_trattenuto	number;
  P_totale_tratt_2005   number;
  P_dovuto_2003_1_7	number;
  P_dovuto_2003_8_12	number;
  P_valore              number;
  P_evento_16           number;
  P_evento_17           number;
  P_evento_18           number;
  P_evento_19           number;
  P_evento_20           number;
  P_imp                 number;
  P_ipn_ac              number;
  P_ipn_onaosi_magg     number;
  P_estrazione          varchar2(4);


-- Parametri per Trace
  p_trc                NUMBER;        -- Tipo di Trace
  p_prn                NUMBER;        -- Numero di Prenotazione elaborazione
  p_pas                NUMBER;        -- Numero di Passo procedurale
  p_prs                NUMBER;        -- Numero progressivo di Segnalazione
  p_stp                VARCHAR(30);   -- Step elaborato
  p_tim                VARCHAR(30);   -- Time impiegato in secondi

-- Valorizzazione variabili fisse
 V_reddito_min      number := 14000;
 V_reddito_max      number := 28000;
 V_eta_min          number := 33;
 V_eta_max          number := 67;

 BEGIN
   select ente     D_ente
        , utente   D_utente
        , ambiente D_ambiente
     into P_ente, P_utente, P_ambiente
     from a_prenotazioni
    where no_prenotazione = prenotazione
   ;
 BEGIN
   select valore
     into P_periodo
     from a_parametri
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_PERIODO';
 END;
 BEGIN
   SELECT SUBSTR(valore,1,4)                             D_anno
        , TO_DATE(decode(P_periodo,6,'01','07')||
                  SUBSTR(valore,1,4),'mmyyyy')           D_ini_ela
	, LAST_DAY(TO_DATE(lpad(P_periodo,2,'0')||
                           SUBSTR(valore,1,4),'mmyyyy')) D_fin_ela
        , substr(valore,1,4) - 1 
        , to_date('3112'||(SUBSTR(valore,1,4)-1),'ddmmyyyy')  D_rif_ona
     INTO P_anno, P_ini_ela, P_fin_ela, P_anno_prec, P_rif_ona
     FROM a_parametri
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_ANNO'
   ;
 exception
      when no_data_found then
           SELECT NVL(P_anno,anno)                                   D_anno
	        , NVL(P_ini_ela
                     ,TO_DATE(decode(P_periodo,6,'01','07')||
                              to_char(anno),'mmyyyy'))               D_ini_ela
	        , NVL(P_fin_ela
	             ,LAST_DAY(TO_DATE(lpad(P_periodo,2,'0')||
                                       to_char(anno),'mmyyyy')))     D_fin_ela
                , nvl(P_anno,anno)-1
                , to_date('3112'||to_char(anno)-1,'ddmmyyyy')        D_rif_ona
	     INTO P_anno, P_ini_ela, P_fin_ela, P_anno_prec, P_rif_ona 
             FROM RIFERIMENTO_RETRIBUZIONE
            WHERE rire_id = 'RIRE';
 END;
 BEGIN
   select valore
     into P_gestione
     from a_parametri
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_GESTIONE';
 END;
 BEGIN
   select valore
     into P_tipo
     from a_parametri
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_TIPO';
 END;
 BEGIN
   select valore
     into P_ci
     from a_parametri 
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_CI';
 EXCEPTION
      WHEN NO_DATA_FOUND THEN null;
 END;
 BEGIN
   select valore
     into P_contratto
     from a_parametri
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_CONTRATTO';
 EXCEPTION
      WHEN NO_DATA_FOUND THEN P_contratto := null;
 END;


BEGIN
  delete from denuncia_onaosi deon
   where deon.anno             = P_anno
     and deon.periodo          = P_periodo
     and deon.gestione      like P_gestione
     and deon.ci               = nvl(P_ci,deon.ci)
     and (    P_tipo = 'T'
           or (P_tipo = 'S' and deon.ci = P_ci)
           or (    P_tipo in ('I','V','P')
               and nvl(tipo_agg,' ') != decode(P_tipo,'P',tipo_agg,P_tipo)
               and (exists
                  (select 'x' from denuncia_eventi_onaosi
                    where anno       = deon.anno
                      and periodo    = deon.periodo
                      and gestione   = deon.gestione
                      and ci         = deon.ci
                      and nvl(tipo_agg,' ') != decode(P_tipo,'P',tipo_agg,P_tipo)
                  )
                   or not exists
                  (select 'x' from denuncia_eventi_onaosi
                    where anno       = deon.anno
                      and periodo    = deon.periodo
                      and gestione   = deon.gestione
                      and ci         = deon.ci
                     -- and nvl(tipo_agg,' ') != decode(P_tipo,'P',tipo_agg,P_tipo)
                  )
                   )
              )
         )
     and exists
        (select 'x'
           from rapporti_individuali rain
          where rain.ci = deon.ci
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
  delete from denuncia_eventi_onaosi deeo
   where deeo.anno     = P_anno
     and deeo.periodo  = P_periodo
     and gestione   like P_gestione
     and not exists
        (select 'x' from denuncia_onaosi
          where anno     = deeo.anno
            and periodo  = deeo.periodo
            and gestione = deeo.gestione
            and ci       = deeo.ci)
     and exists
        (select 'x'
           from rapporti_individuali rain
          where rain.ci = deeo.ci
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
  BEGIN
    select max( condizione )
      into P_estrazione
      from estrazioni_voce  esvo
     where (voce,sub) in 
          (select voce,sub from estrazione_righe_contabili
            where estrazione = 'DENUNCIA_ONAOSI'
              and colonna    = 'RIT_ATTUALE'
              and P_fin_ela between dal and nvl(al,to_date('3333333','j'))
          )
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
    WHEN TOO_MANY_ROWS THEN null;
  END;
  BEGIN
--
-- Determina le persone da trattare controllando se hanno voci significative per l'ONAOSI per il periodo richiesto
-- 

    FOR CURS_CI IN
       (SELECT rain.ci                              						ci
             , trunc(to_number(months_between( TO_DATE('3112'||(P_anno-1),'ddmmyyyy')
                                                      ,rain.data_nas ) ) / 12)	eta
             , pegi.gestione                        						gestione
          FROM RAPPORTI_INDIVIDUALI          	    rain
             , periodi_giuridici                    pegi
         WHERE (   P_tipo != 'S'
                or p_tipo  = 'S' and rain.ci = P_ci)
           and rain.ci = nvl(P_ci,rain.ci)
           and pegi.ci = rain.ci
           and pegi.rilevanza = 'S'
           and pegi.gestione like P_gestione
           and pegi.dal    = 
              (select max(dal) from periodi_giuridici
                where ci        = pegi.ci 
                  and rilevanza = 'S'
                  and dal      <= last_day(to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy'))
              )
           and (   exists
                   (select 'x' from movimenti_contabili
                     where anno = P_anno
        	       AND mese between decode(P_periodo,6,1,decode(P_anno,2003,1,7))
                                    and P_periodo
		       AND ci   = rain.ci
	               AND voce IN
		          (SELECT voce
		             FROM ESTRAZIONE_RIGHE_CONTABILI
                            WHERE estrazione = 'DENUNCIA_ONAOSI'
		       	      AND colonna    = 'RIT'
			      AND to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy')
                                  between dal and nvl(al,to_date('3333333','j'))
                          )
                   )
                 or exists
                   (select 'x' 
                      FROM documenti_giuridici dogi
                     WHERE dogi.ci     = rain.ci
                       AND dogi.evento = 'MOD3'
                       AND P_ini_ela  <= nvl(dogi.al,to_date('3333333','j'))
                       AND P_fin_ela  >= dogi.dal
                   )
               )
           and not exists
              (select 'x' from denuncia_onaosi
                where anno         = P_anno
                  and periodo      = P_periodo
                  and gestione  like P_gestione
                  and ci           = pegi.ci)
        and exists
           (select 'x'
              from rapporti_individuali 
             where ci = rain.ci
               and (   cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = P_ente
                          and ambiente    = P_ambiente
                          and utente      = P_utente
                          and competenza  = 'CI'
                          and oggetto     = cc
                      )
                   )
           )
      ) LOOP

         P_conta     := 0;
  
         BEGIN  -- Estrae Reddito AP
           SELECT nvl(sum(nvl(ipn_ac,0)),0)
             INTO P_ipn_ac
             FROM PROGRESSIVI_FISCALI
            WHERE ci = CURS_CI.ci
              AND anno = P_anno_prec
              AND mese = 12
              AND mensilita = (SELECT max(mensilita)
                                 FROM MENSILITA
                                WHERE mese = 12
                                  AND tipo IN ('A','N','S'))
           ;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   P_ipn_ac := 0;
         END;
         BEGIN  -- Estrae Maggiorazione Onaosi
           SELECT nvl(ipn_onaosi_magg,0)
             INTO P_ipn_onaosi_magg
             FROM informazioni_extracontabili
            WHERE ci = CURS_Ci.ci
              AND anno = P_anno
           ;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   P_ipn_onaosi_magg := 0;
         END;

         BEGIN
           select al
             into P_data_cess
             from periodi_giuridici
            where ci = CURS_CI.ci
              and rilevanza = 'P'
              and dal = (select max(dal) from periodi_giuridici
                          where rilevanza = 'P'
                            and ci = CURS_CI.ci
                            and dal <= last_day(to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy'))
                        );
         EXCEPTION
           WHEN NO_DATA_FOUND THEN P_data_cess := null;
         END;


         FOR CUR_EVENTI IN
            (select pegi.dal	data
                  , nvl(evra.onaosi,2)	evento
               from periodi_giuridici pegi
                  , eventi_rapporto   evra
              where pegi.ci        = CURS_CI.ci
                and pegi.rilevanza = 'P'
                and pegi.dal between decode( P_anno
                                           , 2003, to_date('01082003','ddmmyyyy')
                                                 , to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy')
                                           )
                                 and decode( P_anno
                                           , 2003, to_date('31122003','ddmmyyyy')
                                                 , last_day(to_date(decode(P_periodo,12,'12','06')||P_anno,'mmyyyy')))
                and evra.codice    = pegi.evento
                and evra.rilevanza = 'I'
              union
             select pegi.al	data
                  , nvl(evra.onaosi,3)	evento
               from periodi_giuridici pegi
                  , eventi_rapporto   evra
              where pegi.ci        = CURS_CI.ci
                and pegi.rilevanza = 'P'
                and pegi.al between decode( P_anno
                                          , 2003, to_date('01082003','ddmmyyyy')
                                                , to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy')
                                          )
                                and decode( P_anno
                                          , 2003, to_date('31122003','ddmmyyyy')
                                                , last_day(to_date(decode(P_periodo,12,'12','06')||P_anno,'mmyyyy')))
                and evra.codice    = pegi.posizione
                and evra.rilevanza = 'T'
              union
             select pegi.dal
                  , nvl(evgi.onaosi,11)
               from periodi_giuridici pegi
                  , eventi_giuridici  evgi
              where pegi.ci        = CURS_CI.ci
                and pegi.rilevanza = 'A'
                and pegi.dal between decode( P_anno
                                           , 2003, to_date('01082003','ddmmyyyy')
                                                 , to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy')
                                           )
                                 and decode( P_anno
                                           , 2003, to_date('31122003','ddmmyyyy')
                                                 , last_day(to_date(decode(P_periodo,12,'12','06')||P_anno,'mmyyyy')))
                and evgi.codice    = pegi.evento
                and exists 
                   (select 'x' from astensioni
                     where evento  = pegi.evento
                       and codice  = pegi.assenza
                       and per_ret = 0)
              union
             select pegi.al
                  , nvl(to_number(pecr.RV_HIGH_VALUE),12)
               from periodi_giuridici pegi
                  , eventi_giuridici  evgi
                  , pec_ref_codes	pecr
              where pegi.ci        = CURS_CI.ci
                and pegi.rilevanza = 'A'
                and pegi.al between decode( P_anno
                                          , 2003, to_date('01082003','ddmmyyyy')
                                                , to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy')
                                          )
                                and decode( P_anno
                                          , 2003, to_date('31122003','ddmmyyyy')
                                                , last_day(to_date(decode(P_periodo,12,'12','06')||P_anno,'mmyyyy')))
                and evgi.codice    = pegi.evento
                and exists 
                   (select 'x' from astensioni
                     where evento  = pegi.evento
                       and codice  = pegi.assenza
                       and per_ret = 0)
                and pecr.rv_domain (+)    = 'DENUNCIA_ONAOSI.EVENTO'
                and pecr.rv_low_value (+) = nvl(evgi.onaosi,0)
              union
             select anag.dal
                  , 8
               from anagrafici anag
              where anag.ni = (select ni from rapporti_individuali where ci = CURS_CI.ci)
                and anag.dal between decode( P_anno
                                           , 2003, to_date('01082003','ddmmyyyy')
                                                 , to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy')
                                           )
                                 and decode( P_anno
                                           , 2003, to_date('31122003','ddmmyyyy')
                                                 , last_day(to_date(decode(P_periodo,12,'12','06')||P_anno,'mmyyyy')))
                and exists
                   (select 'x' from anagrafici
                     where ni = anag.ni
                       and dal < anag.dal
                       and comune_res != anag.comune_res
                       and provincia_res != anag.provincia_res
                       and indirizzo_res != anag.indirizzo_res)
              union
             select dogi.del
                  , nvl(evgi.onaosi,8)
               from documenti_giuridici dogi
                  , eventi_giuridici    EVGI
              where dogi.evento = 'ALBO'
                and evgi.codice (+) = dogi.evento
                and dogi.ci     = CURS_CI.ci
                and dogi.del between decode( P_anno
                                           , 2003, to_date('01082003','ddmmyyyy')
                                                 , to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy')
                                           )
                                 and decode( P_anno
                                           , 2003, to_date('31122003','ddmmyyyy')
                                                 , last_day(to_date(decode(P_periodo,12,'12','06')||P_anno,'mmyyyy')))
              union
             SELECT dogi.dal
                  , 10
               FROM documenti_giuridici dogi
                  , eventi_giuridici    evgi
              WHERE dogi.ci         = CURS_CI.ci
                and evgi.codice (+) = dogi.evento
                AND dogi.evento     = 'MOD2'
                AND P_ini_ela      <= nvl(dogi.al,to_date('3333333','j'))
                AND P_fin_ela      >= dogi.dal
                AND dogi.del        = (select min(del) from documenti_giuridici
                                        where ci         = CURS_CI.ci
                                          and evento     = 'MOD2'
                                          and P_ini_ela <= nvl(al,to_date('3333333','j'))
                                          and P_fin_ela >= dal
                                          and scd        = dogi.scd )
              union
             SELECT dogi.dal
                  , 15
               FROM documenti_giuridici dogi
                  , eventi_giuridici    evgi
              WHERE dogi.ci         = CURS_CI.ci
                and evgi.codice (+) = dogi.evento
                AND dogi.evento     = 'MOD3'
                AND P_ini_ela      <= nvl(dogi.al,to_date('3333333','j'))
                AND P_fin_ela      >= dogi.dal
                AND dogi.del        = (select min(del) from documenti_giuridici
                                        where ci         = CURS_CI.ci
                                          and evento     = 'MOD3'
                                          and P_ini_ela <= nvl(al,to_date('3333333','j'))
                                          and P_fin_ela >= dal
                                          and scd        = dogi.scd )
              union
             SELECT P_rif_ona
                  , 16
               FROM documenti_giuridici dogi
              WHERE ci     = CURS_CI.ci
                and evento = 'ALBO'
                and trunc(months_between(P_rif_ona,del)/12) < 5
                and del    = (select min(del) from documenti_giuridici
                               where ci     = CURS_CI.ci
                                 and evento = 'ALBO'
                                 and scd    = dogi.scd )
              union
             SELECT P_rif_ona
                  , nvl(evgi.onaosi,17)
               FROM documenti_giuridici dogi
                  , eventi_giuridici    EVGI
              WHERE dogi.ci          = CURS_CI.ci
                and evgi.codice (+)  = dogi.evento
                AND P_rif_ona  between dogi.dal and nvl(dogi.al,to_date('3333333','j'))
                AND upper(dogi.dato_a1) = 'SI'
                AND dogi.del         = (select min(del) from documenti_giuridici
                                         where ci               = CURS_CI.ci
                                           and P_rif_ona  between dal and nvl(al,to_date('3333333','j'))
                                           and upper(dato_a1)   = 'SI'
                                           and scd              = dogi.scd )
              union
             select P_rif_ona
                  , 18
               from dual
              where nvl(P_ipn_ac,0) + nvl(P_ipn_onaosi_magg,0) < V_reddito_min
                and P_data_cess < to_date('0101'||P_anno_prec,'ddmmyyyy')
              union
             select P_rif_ona
                  , 19
               from dual
              where nvl(P_ipn_ac,0) + nvl(P_ipn_onaosi_magg,0) between V_reddito_min and V_reddito_max
              union
             select P_rif_ona
                  , 20        
               from documenti_giuridici dogi
              where dogi.ci      = CURS_CI.ci
                and CURS_CI.eta >= V_eta_max
                and dogi.evento  = 'ONA'
                and trunc(months_between(P_rif_ona,del)/12) >= 30
                and dogi.del     = (select min(del) from documenti_giuridici
                                     where ci     = CURS_CI.ci
                                       and evento = 'ONA'
                                       and scd    = dogi.scd )
              order by 1
           ) LOOP
       
             P_conta := P_conta + 1;

-- dbms_output.put_line('Inserisco eventi');
             insert into denuncia_eventi_onaosi
                   ( anno
                   , periodo
                   , gestione
                   , ci
                   , nr_evento
                   , evento
                   , data
                   )
             values( P_anno
                   , P_periodo
                   , CURS_CI.gestione
                   , CURS_CI.ci
                   , P_conta
                   , CUR_EVENTI.evento
                   , CUR_EVENTI.data);
             END LOOP;


           P_trattenuta_prec	 := 0;
           P_tratt_2003          := 0;
           P_mese_1		 := 0;
           P_mese_2		 := 0;
           P_mese_3		 := 0;
           P_mese_4		 := 0;
           P_mese_5		 := 0;
           P_mese_6 	 	 := 0;
           P_credito_prec        := 0;
           P_credito_gp4         := 0;
           P_totale_dovuto       := 0;
           P_totale_trattenuto   := 0;
           P_dovuto_2003_1_7     := 0;
           P_dovuto_2003_8_12    := 0;


-- dbms_output.put_line('CI: '||CURS_CI.ci);
           BEGIN
             select sum(decode( to_char(P_periodo)||to_char(nvl(competenza,riferimento),'mmyyyy')
                              , '601'||P_anno, moco.imp
                              ,'1207'||P_anno, decode(P_anno,2003,0,moco.imp)
                                     , 0) * decode( voec.tipo, 'T', -1, 1))      		        mese_1
                  , sum(decode( to_char(P_periodo)||to_char(nvl(competenza,riferimento),'mmyyyy')
                              , '602'||P_anno, moco.imp
                              ,'1208'||P_anno, moco.imp
                                     , 0) * decode( voec.tipo, 'T', -1, 1))      			mese_2
                  , sum(decode( to_char(P_periodo)||to_char(nvl(competenza,riferimento),'mmyyyy')
                              , '603'||P_anno, moco.imp
                              ,'1209'||P_anno, moco.imp
                                     , 0) * decode( voec.tipo, 'T', -1, 1))      			mese_3
                  , sum(decode( to_char(P_periodo)||to_char(nvl(competenza,riferimento),'mmyyyy')
                              , '604'||P_anno, moco.imp
                              ,'1210'||P_anno, moco.imp
                                     , 0) * decode( voec.tipo, 'T', -1, 1))      			mese_4
                  , sum(decode( to_char(P_periodo)||to_char(nvl(competenza,riferimento),'mmyyyy')
                              , '605'||P_anno, moco.imp
                              ,'1211'||P_anno, moco.imp
                                     , 0) * decode( voec.tipo, 'T', -1, 1))      			mese_5
                  , sum(decode( to_char(P_periodo)||to_char(nvl(competenza,riferimento),'mmyyyy')
                              , '606'||P_anno, imp
                              ,'1212'||P_anno, imp
                                     , 0) * decode( voec.tipo, 'T', -1, 1))      			mese_6
                  , sum(imp * decode( voec.tipo, 'T', -1, 1))      			     		totale_trattenuto
               into P_mese_1
                  , P_mese_2
                  , P_mese_3
                  , P_mese_4
                  , P_mese_5
                  , P_mese_6
                  , P_totale_trattenuto
               from movimenti_contabili moco
                  , voci_economiche voec
              where moco.anno = P_anno
       	    and moco.mese between decode(P_periodo,6,1,decode(P_anno,2003,1,7))
                             and P_periodo
		    and moco.ci   = CURS_CI.ci
	          AND (moco.voce,moco.sub) IN
		       (SELECT voce,sub
		          FROM ESTRAZIONE_RIGHE_CONTABILI
                     WHERE estrazione = 'DENUNCIA_ONAOSI'
		           AND colonna    = 'RIT'
			     AND to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy')
                             between dal and nvl(al,to_date('3333333','j'))
                   )
                and voec.codice = moco.voce;
           END;
           BEGIN
             select debito_credito * -1
               into P_credito_prec
               from denuncia_onaosi
              where anno     = decode(P_periodo,12,P_anno,P_anno-1)
                and periodo  = decode(P_periodo,12,6,12)
--                and gestione = CURS_CI.gestione
                and ci       = CURS_CI.ci
                and sign(debito_credito) = -1
             ;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN P_credito_prec := null;
           END;

--
-- Calcolo il dovuto
--

           FOR CUR_MESI IN 
              (select mese
                    , fin_mese
                 from mesi
                where anno       = P_anno
                  and mese between decode(P_periodo,6,1,7) and P_periodo
                  and exists
                     (select 'x'
                        from periodi_retributivi
                       where  ci      = CURS_CI.ci
                         and  periodo = fin_mese
                         and  competenza in ('P','C','A')
                         and  servizio = 'Q'
                         and  P_estrazione = 'R'
                       group by to_char(al,'yyyymm')
                      having round( sum( gg_rat * decode(competenza,'A',1,'C',1,0))
                                   / 30)
                           + round( sum( gg_rat * decode(competenza,'P',1,0))
                                   / 30) >= 1
                     )  
                union
               select mese
                    , fin_mese
                 from mesi
                where anno       = P_anno
                  and mese between decode(P_periodo,6,1,7) and P_periodo
                  and exists
                     (select 'x'
                        from periodi_retributivi
                       where  ci      = CURS_CI.ci
                         and  periodo = fin_mese
                         and  competenza in ('P','C','A')
                         and  servizio = 'Q'
                         and  P_estrazione = 'M'
                         and  last_day(al) between to_date(lpad(decode(P_periodo,6,1,7),2,'0')||P_anno,'mmyyyy')
                                               and last_day(to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy'))
                       group  by ci
                      having nvl(sum(gg_fis),0) != 0
                     )      
                union           
               select mese
                    , fin_mese
                 from mesi
                where anno       = P_anno
                  and exists
                     (select 'x'
                        from documenti_giuridici 
                       where ci       = CURS_CI.ci
                         AND evento   = 'MOD2'
                         AND fin_mese between dal and nvl(al,to_date('3333333','j'))
                     )       
              ) LOOP 

                peccmore_onaosi.cal_onaosi ( curs_ci.ci, P_anno, cur_mesi.fin_mese, P_rif_ona
                                           , '', '', '', P_imp
                                           , p_trc, p_prn, p_pas, p_prs, p_stp, p_tim);

                P_totale_dovuto := P_totale_dovuto + P_imp;


                END LOOP; --cur_mesi

-- dbms_output.put_line('Totale dovuto 1: '||to_char(P_totale_dovuto));
-- dbms_output.put_line('Credito Prec.'||to_char(P_credito_prec));

           P_trattenuta_prec   := 0;
           P_tratt_2003        := 0;
           P_credito_gp4       := 0;
           IF P_anno = 2003 THEN
              BEGIN
                select sum(moco.imp * decode( voec.tipo, 'T', -1, 1))      
                  into P_trattenuta_prec
                  from movimenti_contabili moco
                     , voci_economiche voec
                 where moco.anno = P_anno
         	       and moco.mese between 1 and 12
/* modifica del 02/09/2004 di Annalena (da verificare con Morena)
                   and moco.riferimento between to_date('01012003','ddmmyyyy')
                                       and to_date('31072003','ddmmyyyy')
*/
                   and moco.riferimento <= to_date('31072003','ddmmyyyy')
		       and moco.ci   = CURS_CI.ci
	             AND (moco.voce,moco.sub) IN
		          (SELECT voce,sub
		             FROM ESTRAZIONE_RIGHE_CONTABILI
                        WHERE estrazione = 'DENUNCIA_ONAOSI'
		              AND colonna    = 'RIT'
			        AND to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy')
                              between dal and nvl(al,to_date('3333333','j'))
                      )
                   and voec.codice = moco.voce;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN P_trattenuta_prec := null;
              END;
/* mod. dl 07/10/2004
   sostituito aggiungendo al to. dovuto la trattenuta precedente, per sistemare anche i rec. degli anni != 2003
              BEGIN
                select sum(moco.imp * decode( voec.tipo, 'T', -1, 1))
                  into P_dovuto_2003_1_7
                  from movimenti_contabili moco
                     , voci_economiche voec
                 where moco.anno = P_anno
         	       and moco.mese between 1 and 7
		       and moco.ci   = CURS_CI.ci
	             AND (moco.voce,moco.sub) IN
		          (SELECT voce,sub
		             FROM ESTRAZIONE_RIGHE_CONTABILI
                        WHERE estrazione = 'DENUNCIA_ONAOSI'
		              AND colonna    = 'RIT'
			        AND to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy')
                              between dal and nvl(al,to_date('3333333','j'))
                      )
                   and voec.codice = moco.voce;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN P_dovuto_2003_1_7:= null;
              END;
              P_totale_dovuto := nvl(P_totale_dovuto,0) + nvl(P_dovuto_2003_1_7,0);
*/
-- dbms_output.put_line('Totale dovuto 2: '||to_char(P_totale_dovuto));
         ELSE
              FOR CUR_TRATT_PREC IN
                 (select decode( sign( sum(moco.imp * decode( voec.tipo, 'T', -1, 1) ) )
                               , 1, decode( sign(to_char(riferimento,'yyyymm')-200307)
                                          , 1, sum(imp * decode( voec.tipo, 'T', -1, 1))
                                             , 0)
                                  , 0) imp_tratt_2003
                       , decode( sign( sum(moco.imp * decode( voec.tipo, 'T', -1, 1) ) )
                               , 1, sum(imp * decode( voec.tipo, 'T', -1, 1))
                                   , 0) imp_tratt
                       , decode( sign( sum(moco.imp * decode( voec.tipo, 'T', -1, 1) ) )
                               , -1, sum(imp * decode( voec.tipo, 'T', -1, 1))
                                   , 0) imp_credito
                    from movimenti_contabili moco
                       , voci_economiche     voec
                   where moco.anno = P_anno
          	         and moco.mese between decode(P_periodo,6,1,decode(P_anno,2003,1,7))
                                       and P_periodo
                     and moco.riferimento < to_date('01'||decode(P_periodo,6,'01','07')||P_anno
                                                         ,'ddmmyyyy')
		         and moco.ci   = CURS_CI.ci
	               AND (moco.voce,moco.sub) IN
		            (SELECT voce,sub
		               FROM ESTRAZIONE_RIGHE_CONTABILI
                          WHERE estrazione = 'DENUNCIA_ONAOSI'
		                AND colonna    = 'RIT'
			          AND to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy')
                                between dal and nvl(al,to_date('3333333','j'))
                        )
                     and voec.codice = moco.voce
                   group by voec.tipo,to_char(moco.riferimento,'yyyymm')
                 ) LOOP
                     P_trattenuta_prec := P_trattenuta_prec + nvl(CUR_TRATT_PREC.imp_tratt,0);
                     P_credito_gp4     := P_credito_gp4     + nvl(CUR_TRATT_prec.imp_credito,0);
                     P_tratt_2003      := P_tratt_2003      + nvl(CUR_TRATT_PREC.imp_tratt_2003,0);
                   END LOOP;
           END IF;
-- dbms_output.put_line('Credito Prec.'||to_char(P_credito_prec));
-- dbms_output.put_line('tot.dovuto '||to_char(P_totale_dovuto));
-- dbms_output.put_line('tratt.2003 '||to_char(P_tratt_2003));
-- dbms_output.put_line('totale tratt. '||to_char(P_totale_trattenuto)||' + '||to_char(P_totale_tratt_2005));


           insert into denuncia_onaosi
                 (anno
                 ,periodo
                 ,gestione
                 ,ci
                 ,trattenuta_prec
                 ,mese1
                 ,mese2
                 ,mese3
                 ,mese4
                 ,mese5
                 ,mese6
                 ,credito_prec
                 ,totale_dovuto
                 ,totale_trattenuto
                 ,debito_credito
                 )
           select P_anno
                , P_periodo
                , CURS_CI.gestione
                , CURS_CI.ci
                , nvl(P_trattenuta_prec,0)
                , nvl(P_mese_1,0) + nvl(P_credito_gp4,0) mese1 -- P_credito_gp4 e negativo ???
                , nvl(P_mese_2,0)
                , nvl(P_mese_3,0)
                , nvl(P_mese_4,0)
                , nvl(P_mese_5,0)
                , nvl(P_mese_6,0)
                , nvl(P_credito_prec,0)
                , nvl(P_totale_dovuto,0) + nvl(P_trattenuta_prec,0) + nvl(P_credito_gp4,0)
-- + nvl(P_tratt_2003,0) 
                , nvl(P_totale_trattenuto,0) + nvl(P_totale_tratt_2005,0)
                ,(nvl(P_totale_dovuto,0) + nvl(P_trattenuta_prec,0) + nvl(P_credito_gp4,0)
-- + nvl(P_tratt_2003,0)
                 ) - 
                 (nvl(P_totale_trattenuto,0) + nvl(P_totale_tratt_2005,0)) - 
                 nvl(P_credito_prec,0) 
             from dual;

           IF P_contratto is not null and nvl(P_trattenuta_prec,0) != 0 THEN
   
              insert into denuncia_eventi_onaosi
                    ( anno
                    , periodo
                    , gestione
                    , ci
                    , nr_evento
                    , evento
                    , data
                    )
              select P_anno
                   , P_periodo
                   , CURS_CI.gestione
                   , CURS_CI.ci
                   , 0
                   , decode( greatest(nvl(P_data_cess,to_date('3333333','j'))
                                     ,to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy')
                                     )
                           ,to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy'), '22', '21')
                   , null
                from dual ;

              insert into denuncia_eventi_onaosi
                    ( anno
                    , periodo
                    , gestione
                    , ci
                    , nr_evento
                    , evento
                    , data
                    )
              select P_anno
                   , P_periodo
                   , CURS_CI.gestione
                   , CURS_CI.ci
                   , P_conta + 1
                   , 5
                   , P_data_cess
                from dual
               where P_data_cess < to_date('01'||decode(P_periodo,12,'07','01')||P_anno,'ddmmyyyy') ;

              update denuncia_eventi_onaosi
                 set nr_evento = nr_evento + 1
               where anno      = P_anno
                 and periodo   = P_periodo
                 and ci        = CURS_CI.ci 
                 and gestione  = CURS_CI.gestione;
              
           END IF;
         
         END LOOP;
END;
END;
END;
END;
END;
/
