CREATE OR REPLACE PACKAGE Peccmore_veneto IS
/******************************************************************************
 NOME:        PECCMORE_VENETO
 DESCRIZIONE: Colcolo Addizionale Regionale Veneto - Casi particolari
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    20/12/2005 NN     Prima emissione.
 1    02/01/2007 MS     Mod. gestione stampa elenco ( att. 19057 )
 1.1  13/02/2007 ML     Mod. lettura riga di a_appoggio_stampe per
                        non mescolare le segnalazioni (A19455).
******************************************************************************/
revisione varchar2(30) := '1.1 del 13/02/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE Cal_veneto
( P_ci                         NUMBER
, P_anno                       NUMBER
, P_riferimento                DATE
, P_ipn_tot_ac                 NUMBER
, P_alq_add_reg                NUMBER
, P_alq_add_reg_aumento IN OUT NUMBER
, P_add_irpef_mp               NUMBER
, P_add_reg_terzi              NUMBER
, P_imp                 IN OUT NUMBER
, P_caso_particolare    IN OUT NUMBER
-- Parametri per Trace
, p_trc             IN     NUMBER     -- Tipo di Trace
, p_prn             IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas             IN     NUMBER     -- Numero di Passo procedurale
, p_prs             IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp             IN OUT VARCHAR2   -- Step elaborato
, p_tim             IN OUT VARCHAR2   -- Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY Peccmore_veneto IS
form_trigger_failure EXCEPTION;
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.'||revisione;
END VERSIONE;
PROCEDURE Cal_veneto
/******************************************************************************
 NOME:        CALCOLO ADDIZIONALE REGIONALE VENETO
 DESCRIZIONE: Calcolo dell'addizionale Veneto - Casi particolari.
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    20/12/2005 NN     Prima emissione.
 1    02/01/2007 MS     Mod. gestione stampa elenco ( att. 19057 )
******************************************************************************/
( P_ci                         NUMBER
, P_anno                       NUMBER
, P_riferimento                DATE
, P_ipn_tot_ac                 NUMBER
, P_alq_add_reg                NUMBER
, P_alq_add_reg_aumento IN OUT NUMBER
, P_add_irpef_mp               NUMBER
, P_add_reg_terzi              NUMBER
, P_imp                 IN OUT NUMBER
, P_caso_particolare    IN OUT NUMBER
-- Parametri per Trace
, p_trc IN     NUMBER     -- Tipo di Trace
, p_prn IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas IN     NUMBER     -- Numero di Passo procedurale
, p_prs IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp IN OUT VARCHAR2   -- Step elaborato
, p_tim IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
V_reddito_fg            number := 50000;
V_reddito_agg_fg        number := 10000;
V_reddito_hd            number := 45000;
D_numero_figli          INFORMAZIONI_ADD_FISCALI.numero_figli%TYPE;
D_numero_disabili       INFORMAZIONI_ADD_FISCALI.numero_disabili%TYPE;
D_tipo_carico           INFORMAZIONI_ADD_FISCALI.tipo_carico%TYPE;
D_reddito_aggiuntivo    INFORMAZIONI_ADD_FISCALI.reddito_aggiuntivo%TYPE;
D_esiste                number;
D_imp                   number;
D_alq_add_reg_aumento   number;
D_asterisco             varchar2(3);
D_nome                  ANAGRAFICI.cognome%TYPE;
D_riga                  number;
D_pas_stampa            number;
BEGIN
  D_pas_stampa  := 4;
  BEGIN
       delete from INFORMAZIONI_ADD_FISCALI
        where ci               = P_ci
          and anno             = P_anno
          and data_riferimento = P_riferimento
          and tipo_agg is null
       ;
       COMMIT;
  END;
  BEGIN  -- Verifica dati specifici
     P_stp := 'VENETO.CAL_VENETO-00';
     select numero_figli, numero_disabili, tipo_carico, reddito_aggiuntivo, 1
       into D_numero_figli, D_numero_disabili, D_tipo_carico, D_reddito_aggiuntivo, D_esiste
       from INFORMAZIONI_ADD_FISCALI
      where ci = P_ci
        and anno = P_anno
        and data_riferimento = P_riferimento
        and tipo_agg is not null
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_numero_figli       := null;
          D_numero_disabili    := null;
          D_tipo_carico        := null;
          D_reddito_aggiuntivo := null;
          D_esiste             := 0;
  END;
  IF D_esiste = 0 THEN
     BEGIN
          select nvl(figli,0) + nvl(figli_dd,0)
               , nvl(figli_hh,0) + nvl(figli_hh_dd,0)
               , decode ( sign(nvl(figli,0) + nvl(figli_mn,0) + nvl(figli_hh,0) +
                               nvl(figli_dd,0) + nvl(figli_mn_dd,0) + nvl(figli_hh_dd,0))
                        , 1 , decode ( cond_fis
                                     , 'AC', 1
                                     , 'CC', 1
                                           , decode ( sign(nvl(figli,0) + nvl(figli_mn,0) + nvl(figli_hh,0))
                                                    , 1, decode( cond_fis
                                                               , 'AC', 1
                                                               , 'CC', 1
                                                                     , 2
                                                               )
                                                       , decode ( sign(nvl(figli_dd,0) + nvl(figli_mn_dd,0) +
                                                                       nvl(figli_hh_dd,0))
                                                                , 1, 1
                                                                   , 2
                                                                )
                                                    )
                                     )
                            , 2
                        )
            into D_numero_figli
               , D_numero_disabili
               , D_tipo_carico
            from CARICHI_FAMILIARI
           where ci = P_ci
             and anno = P_anno
             and mese = (select max(c2.mese)
                           from CARICHI_FAMILIARI c2
                          where c2.ci = P_ci
                            and c2.anno = P_anno
                            and c2.mese <= to_number(to_char(P_riferimento,'mm')))
          ;
     EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_numero_figli       := null;
          D_numero_disabili    := null;
          D_tipo_carico        := null;
     END;
     BEGIN
           insert into INFORMAZIONI_ADD_FISCALI
                       ( ci, anno, data_riferimento
                       , numero_figli, numero_disabili, tipo_carico, reddito_aggiuntivo
                       , utente, tipo_agg, data_agg
                       )
            values ( P_ci, P_anno, P_riferimento
                   , D_numero_figli, D_numero_disabili, D_tipo_carico, 0
                   , si4.utente, null, sysdate
                   )
            ;
     COMMIT;
     END;
  END IF;
  BEGIN
    D_alq_add_reg_aumento := P_alq_add_reg_aumento;
    IF D_numero_figli >= 3 THEN
       BEGIN                       -- almeno 3 figli e aliquota normale
            select E_Round( P_ipn_tot_ac * P_alq_add_reg / 100 ,'I')
                   - P_add_irpef_mp - P_add_reg_terzi
                 , 0
              into D_imp
                 , D_alq_add_reg_aumento
              from dual
             where nvl(P_ipn_tot_ac,0) + decode( D_tipo_carico, 1, 0, nvl(D_reddito_aggiuntivo,0)) <=
                   V_reddito_fg + (V_reddito_agg_fg * (D_numero_figli - 3))
       ;
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            null;
       END;
       BEGIN                       -- almeno 3 figli e aliquota aggiuntiva
            select E_Round( P_ipn_tot_ac * (P_alq_add_reg + P_alq_add_reg_aumento) / 100 ,'I')
                   - P_add_irpef_mp - P_add_reg_terzi
              into D_imp
              from dual
             where nvl(P_ipn_tot_ac,0) + decode( D_tipo_carico, 1, 0, nvl(D_reddito_aggiuntivo,0)) >
                   V_reddito_fg + (V_reddito_agg_fg * (D_numero_figli - 3))
       ;
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            null;
       END;
       D_asterisco := '***';
       P_caso_particolare := 1;
    ELSIF D_numero_disabili >= 1 THEN
       BEGIN                       -- almeno 1 disabile e aliquota normale
            select E_Round( P_ipn_tot_ac * P_alq_add_reg / 100 ,'I')
                   - P_add_irpef_mp - P_add_reg_terzi
                 , 0
              into D_imp
                 , D_alq_add_reg_aumento
              from dual
             where nvl(P_ipn_tot_ac,0) + decode( D_tipo_carico, 1, 0, nvl(D_reddito_aggiuntivo,0)) <=
                   V_reddito_hd
       ;
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            null;
       END;
       BEGIN                       -- almeno 1 disabile e aliquota aggiuntiva
            select E_Round( P_ipn_tot_ac * (P_alq_add_reg + P_alq_add_reg_aumento) / 100 ,'I')
                   - P_add_irpef_mp - P_add_reg_terzi
              into D_imp
              from dual
             where nvl(P_ipn_tot_ac,0) + decode( D_tipo_carico, 1, 0, nvl(D_reddito_aggiuntivo,0)) >
                   V_reddito_hd
       ;
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            null;
       END;
       D_asterisco := '***';
       P_caso_particolare := 1;
    ELSE
       D_imp := 0;
       P_caso_particolare := 0;
    END IF;
    P_imp                 := D_imp;
    P_alq_add_reg_aumento := D_alq_add_reg_aumento;
  END;
  BEGIN  -- Stampa dati specifici
         BEGIN
            insert into A_APPOGGIO_STAMPE
            (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
            select p_prn
                 , D_pas_stampa
                 , 1
                 , 1
                 , lpad(' ',3)||
                   lpad('Cod.Ind.',10,' ')||
                   rpad('Nominativo',40,' ')||
                   lpad('Data Rif.',10,' ')||
                   lpad('Figli ',7,' ')||
                   lpad('Disab.',6,' ')||
                   lpad('Carico',8,' ')||
                   lpad('Redd.Aggiuntivo',16,' ')
              from dual
             where not exists (select 'x'
                                 from A_APPOGGIO_STAMPE
                                where no_prenotazione = p_prn
                                  and no_passo = D_pas_stampa
                                  and pagina = 1
                                  and riga = 1
                              )
             ;
             insert into A_APPOGGIO_STAMPE
             (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
             select p_prn
                  , D_pas_stampa
                  , 1
                  , 2
                  , lpad('-',132,'-')
               from dual
             where not exists (select 'x'
                                 from A_APPOGGIO_STAMPE
                                where no_prenotazione = p_prn
                                  and no_passo = D_pas_stampa
                                  and pagina = 1
                                  and riga = 2
                              )
             ;
             commit;
         END;
         BEGIN
            select rpad(substr(rtrim(cognome)||' '||nome,1,40),40,' ')
              into D_nome
              from ANAGRAFICI
             where ni = (select max(ni)
                           from RAPPORTI_INDIVIDUALI
                          where ci = P_ci)
               and p_riferimento between dal and nvl(al,to_date(3333333,'j'))
            ;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_nome := null;
         END;
         BEGIN
            select nvl(max(riga),0) + 1
              into D_riga
              from A_APPOGGIO_STAMPE
             where no_prenotazione = p_prn
               and no_passo = D_pas_stampa
               and pagina = 1
               and riga   < 100000
            ;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_riga := 0;
         END;
         BEGIN
            insert into A_APPOGGIO_STAMPE
            (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
            values( p_prn
                  , D_pas_stampa
                  , 1
                  , D_riga
                  , lpad(nvl(D_asterisco,' '),3)||' '||
                    lpad(to_char(P_ci),8,' ')||' '||
                    rpad(D_nome,40,' ')||' '||
                    P_riferimento||' '||
                    lpad(to_char(nvl(D_numero_figli,0)),5,' ')||' '||
                    lpad(to_char(nvl(D_numero_disabili,0)),5,' ')||' '||
                    lpad(decode(D_tipo_carico,1,'Totale','Parziale'),8,' ')||' '||
                    lpad(translate(to_char(nvl(D_reddito_aggiuntivo,0),'999,999,990.90'),',.','.,'),15,' ')
                 );
              commit;
         END;
  END;
END cal_veneto;
END;
/
