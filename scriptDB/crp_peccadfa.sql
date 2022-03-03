CREATE OR REPLACE PACKAGE PECCADFA IS
/******************************************************************************
 NOME:          crp_peccadfa 
 DESCRIZIONE:   CARICAMENTO ARCHIVIO FISCALE  PER CERTIFICAZIONI LAVORO AUTONOMO
                PROVVIGIONI E REDDITI DIVERSI

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  27/03/2007 MS     Prima Emissione
 1.1  04/06/2007 MS     Gestione regimi agevolati per mese
 1.2  12/06/2007 MS     Correzioni da test
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCADFA IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.2 del 12/06/2007';
   END VERSIONE;

 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN

 DECLARE
  D_ente            VARCHAR2(4);
  D_ambiente        VARCHAR2(8);
  D_utente          VARCHAR2(8);
--
-- Parametri di Prenotazione
--
  P_anno               VARCHAR(4);
  P_ini_a              VARCHAR(8);
  P_fin_a              VARCHAR(8);
  P_rapporto           VARCHAR(4);
  P_tipo               VARCHAR(1);
  P_ci                 NUMBER(8);
  P_evento_eccezionale VARCHAR(1);
--
-- Variabili di Utilità Generale
--
  D_riga               NUMBER(10) := 0;
  D_cod_errore         VARCHAR(6);
  D_precisazione       VARCHAR(200);
  D_controllo          VARCHAR(2);
  USCITA               EXCEPTION;
--
-- Variabili di Dettaglio
--
  D_causale         varchar2(1);
  D_agevolato       varchar2(1);
  D_ipn_ord         number(12,2);
  D_ipn_ord_agev    number(12,2);
  D_no_sogg         number(12,2);
  D_rit_ord         number(12,2);
  D_rit_sep         number(12,2);
  D_rit_ap          number(12,2);
  D_ipt_ord         number(12,2);
  D_rit_imposta     number(12,2);
  D_competenze      number(12,2);
  D_no_sogg_rc      number(12,2);
  D_ipt_sosp        number(12,2);
  D_con_pre_dat     number(12,2);
  D_con_pre_lav     number(12,2);
  D_spese_rimb      number(12,2);
  D_rit_rimb        number(12,2);  
  D_altre_rit       number(12,2);


BEGIN

  BEGIN
    SELECT valore
      INTO P_tipo       -- utilizzato dominio P_TIPO che assume i valori I, P, S, T, V      
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
     D_cod_errore := 'A05721';
     RAISE USCITA;
  ELSIF nvl(P_ci,0) != 0 and P_tipo = 'T' THEN
     D_cod_errore := 'A05721';
     RAISE USCITA;
  END IF;
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
         , '0101'||valore
         , '3112'||valore
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
           , '0101'||TO_CHAR(anno)
           , '3112'||TO_CHAR(anno)
        INTO P_anno
           , P_ini_a
           , P_fin_a
        FROM RIFERIMENTO_FINE_ANNO
       WHERE rifa_id = 'RIFA'
      ;
  END;

  BEGIN
    SELECT valore
      INTO P_evento_eccezionale
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_EVENTO'
     ;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
         P_evento_eccezionale := null;
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
  <<UNO>>

--
-- Cancellazione Archiviazione precedente relativa all'anno richiesto
--
  lock table denuncia_fiscale_autonomi in exclusive mode nowait
  ;
  delete from denuncia_fiscale_autonomi defa
   where defa.anno             = P_anno
     and defa.ci in ( select ci
                        from rapporti_individuali
                       where ci = defa.ci
                         and rapporto like P_rapporto
                    )
     and (    P_tipo = 'T'
         or ( P_tipo in ('I','V','P') and not exists
                 (select 'X' from denuncia_fiscale_autonomi
                   where anno       = defa.anno
                     and ci         = defa.ci
                     and nvl(tipo_agg,' ') = decode( P_tipo
                                                   ,'P', tipo_agg
                                                       , P_tipo )
                 )
              )
         or ( P_tipo = 'S' and defa.ci = P_ci
            )
          )
     and exists
        ( select 'X'
           from rapporti_individuali rain
          where rain.ci = defa.ci
            and (   rain.cc is null
                 or exists
                   (select 'X'
                      from a_competenze
                     where ente        = D_ente
                       and ambiente    = D_ambiente
                       and utente      = D_utente
                       and competenza  = 'CI'
                       and oggetto     = rain.cc
                   )
                )
        )
   ;
-- dbms_output.put_line('cancellazione effettuata: '||sql%rowcount);  
   commit;

    IF  nvl(P_evento_eccezionale,'1') not in ('1','3','4') THEN
      D_riga := nvl(D_riga,0) + 1 ;
      D_cod_errore   := 'P00505';  -- Valore non ammesso in questo contesto
      D_precisazione := ' per Codice Eventi Eccezionali ( 1,3,4 ) : '||P_evento_eccezionale;
      INSERT INTO a_segnalazioni_errore
      (no_prenotazione,passo,progressivo,errore,precisazione)
      VALUES (prenotazione,passo,D_riga,D_cod_errore, substr(D_precisazione,1,200) );
    END IF;
    FOR CUR_CI IN
     ( select rain.ci      ci
         from rapporti_individuali    rain
            , classi_rapporto            clra
        where clra.codice = rain.rapporto
          and clra.cat_fiscale in ('3','4')
          and rain.rapporto like P_rapporto
          and (    P_tipo = 'T'
             or ( P_tipo in ('I','V','P') and not exists
                     (select 'X' from denuncia_fiscale_autonomi
                       where anno       = P_anno
                         and ci         = rain.ci
                         and nvl(tipo_agg,' ') = decode( P_tipo
                                                       ,'P', tipo_agg
                                                           , P_tipo )
                     )
                  )
             or ( P_tipo = 'S' and rain.ci = P_ci
                )
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
          and exists
             (select 'x'
                from progressivi_fiscali prfi
               where prfi.anno = P_anno
                 and prfi.mese = 12
                 and prfi.mensilita =
                    (select max(mensilita) from mensilita
                      where mese = 12
                        and tipo in ('S','N','A'))
                 and prfi.ci   = rain.ci
               group by prfi.ci
              having  nvl(sum(prfi.ipn_ac ),0) + nvl(sum(prfi.ipn_ap ),0)
                    + nvl(sum(prfi.rit_ord),0) + nvl(sum(prfi.rit_sep),0)
                    + nvl(sum(prfi.rit_ap ),0) + nvl(sum(prfi.ipt_pag),0) + nvl(sum(prfi.ipt_ap ),0)
                    != 0
             )
        order by 1
     ) LOOP
-- dbms_output.put_line('CI: '||CUR_CI.ci);
          BEGIN
            select nvl(grra.cat_fiscale,'A')
              into D_causale
              from gruppi_rapporto         grra
                 , rapporti_individuali    rain
                 , anagrafici              anag
             where anag.ni           = rain.ni
               and anag.al          is null
               and rain.ci           = CUR_CI.ci
               and grra.gruppo(+)    = rain.gruppo
            ;
          EXCEPTION WHEN NO_DATA_FOUND THEN 
             D_causale := '';
             D_riga := nvl(D_riga,0) + 1 ;
             D_cod_errore := 'P00503'; -- manca definizione codice causale
             D_precisazione := 'Manca Definizione Causale per Cod. Ind.: '||to_char(CUR_CI.ci); 
             INSERT INTO a_segnalazioni_errore
             (no_prenotazione,passo,progressivo,errore,precisazione)
             VALUES (prenotazione,passo,D_riga,D_cod_errore, substr(D_precisazione,1,200) );
          END;
          D_controllo := '';
          IF D_causale is not null THEN
           D_controllo := pec_reco.chk_pec_reco('DENUNCIA_FISCALE_AUTONOMI.CAUSALE',D_causale);
           IF D_controllo = 'NO' THEN
              D_riga := nvl(D_riga,0) + 1 ;
              D_cod_errore := 'P00505'; -- Valore non ammesso in questo contesto
              D_precisazione := ' Causale Errata ('||D_causale||') per Cod. Ind.:'||TO_CHAR(CUR_CI.ci);
              INSERT INTO a_segnalazioni_errore
              (no_prenotazione,passo,progressivo,errore,precisazione)
              VALUES (prenotazione,passo,D_riga,'P00505',SUBSTR(D_precisazione,1,200));
           END IF;
          END IF;

          BEGIN  --  Estrazione Dati Fiscali: dati da PRFI
           <<DATI_FISCALI>>
            select sum( nvl(prfi.ipn_ac,0) + nvl(prfi.ipn_ap,0))
                 , sum(nvl(prfi.rit_ord,0) + nvl(prfi.rit_sep,0) +  nvl(prfi.rit_ap,0))
                 , sum(nvl(prfi.rit_ord,0))
                 , sum(nvl(prfi.rit_sep,0))
                 , sum(nvl(prfi.rit_ap,0))
                 , sum(nvl(prfi.ipt_pag,0)+nvl(prfi.ipt_ap,0))
              into D_ipn_ord
                 , D_no_sogg
                 , D_rit_ord
                 , D_rit_sep
                 , D_rit_ap
                 , D_ipt_ord
              from progressivi_fiscali prfi
             where prfi.anno         = P_anno
               and prfi.mese         = 12
               and prfi.mensilita in ( select max(mensilita)
                                         from mensilita
                                        WHERE mese = 12
                                          AND tipo IN ('N','A','S')
                                     )
               and prfi.ci = CUR_CI.ci
            ;
          EXCEPTION WHEN NO_DATA_FOUND THEN
                D_ipn_ord      := null;
                D_no_sogg      := null;
                D_rit_ord      := null;
                D_rit_sep      := null;
                D_rit_ap       := null;
                D_ipt_ord      := null;
          END DATI_FISCALI;
          BEGIN -- Estrazione Estrazione dati da VACA
          <<DATI_VACA>>
            select sum(decode(vaca.colonna,'COMPETENZE', nvl(vaca.valore,0),0))
                 , sum(decode(vaca.colonna,'NO_CONV', nvl(vaca.valore,0),0))
                 , sum(decode(vaca.colonna,'RIT_SOSP', nvl(vaca.valore,0),0))
                 , sum(decode(vaca.colonna,'C_INPS', nvl(vaca.valore,0),0))
                 , sum(decode(vaca.colonna,'R_INPS', nvl(vaca.valore,0),0))
                 , sum(decode(vaca.colonna,'SPESE_RIMB', nvl(vaca.valore,0),0))
                 , sum(decode(vaca.colonna,'ALTRE_RIT', nvl(vaca.valore,0),0))
              into D_competenze
                 , D_no_sogg_rc
                 , D_ipt_sosp
                 , D_con_pre_dat
                 , D_con_pre_lav
                 , D_spese_rimb
                 , D_altre_rit
              from valori_contabili_annuali   vaca
             where vaca.anno              = P_anno
               and vaca.mese              = 12
               and vaca.mensilita         in ( select max(mensilita)
                                                 from mensilita
                                                where mese  = 12
                                                  and tipo in ('A','N','S')
                                             )
               and vaca.estrazione        = 'DENUNCIA_SOSTITUTI'
               and vaca.colonna          in ('COMPETENZE', 'NO_CONV', 'RIT_SOSP'
                                            ,'C_INPS', 'R_INPS', 'SPESE_RIMB', 'ALTRE_RIT')
               and vaca.moco_mensilita    != '*AP'
               and vaca.ci                = CUR_CI.ci
            having sum(decode(vaca.colonna,'COMPETENZE', nvl(vaca.valore,0),0))
                 + sum(decode(vaca.colonna,'NO_CONV', nvl(vaca.valore,0),0))
                 + sum(decode(vaca.colonna,'RIT_SOSP', nvl(vaca.valore,0),0))
                 + sum(decode(vaca.colonna,'C_INPS', nvl(vaca.valore,0),0))
                 + sum(decode(vaca.colonna,'R_INPS', nvl(vaca.valore,0),0))
                 + sum(decode(vaca.colonna,'SPESE_RIMB', nvl(vaca.valore,0),0))
                 + sum(decode(vaca.colonna,'ALTRE_RIT', nvl(vaca.valore,0),0)) != 0
              ;
          EXCEPTION WHEN NO_DATA_FOUND THEN
                D_competenze  := null;
                D_no_sogg_rc  := null;
                D_ipt_sosp    := null;
                D_con_pre_dat := null;
                D_con_pre_lav := null;
                D_spese_rimb  := null;
                D_altre_rit   := null;
          END DATI_VACA;
-- dbms_output.put_line('COMPETENZE : '||D_competenze);
          
          BEGIN
          -- verifico se e un medico in regime fiscale agevolato
            select 'X'
             into D_agevolato
             from informazioni_extracontabili
            where anno = P_anno
              and ci   = CUR_CI.ci
              and perc_irpef_ord = 0;
          EXCEPTION WHEN NO_DATA_FOUND THEN
             D_agevolato := null;
          END;
-- dbms_output.put_line('Agevolato: '||D_agevolato);
          D_ipn_ord_agev := 0;
          BEGIN
          -- estraggo la parte di ipn_ord non assoggettata a IRPEF
            select sum(sum(nvl(ipn_ord,0)+nvl(ipn_sep,0)))
             into D_ipn_ord_agev
             from movimenti_fiscali
            where anno = P_anno
              and ci   = CUR_CI.ci
             group by mese
              having sum(nvl(ipt_ord,0)) = 0;
          END;
        -- dbms_output.put_line('Ipn Agevolato: '||D_ipn_ord_agev);
          BEGIN -- archiviazione nella tabella d'appoggio
          insert into denuncia_fiscale_autonomi
                ( anno, ci
                , cod_evento_eccezionale
                , causale
                , lordo
                , no_sogg_rc
                , no_sogg
                , reg_agevolato
                , imponibile
                , rit_acconto
                , rit_imposta
                , rit_sospese
                , prev_erogante, prev_lavoratore, prev_enpam
                , spese_rimb, rit_rimb, altre_rit
                , utente, tipo_agg, data_agg )
          select P_anno, CUR_CI.ci
               , decode( nvl(D_ipt_sosp,0), 0, '', P_evento_eccezionale )
               , D_causale
               , nvl(D_ipn_ord,0) + nvl(D_rit_ord,0) + nvl(D_rit_ap,0) + nvl(D_rit_sep,0) + nvl(D_competenze,0)
               , nvl(D_no_sogg_rc,0)
               , nvl(D_no_sogg,0) + nvl(D_competenze,0)
               + decode(D_agevolato,'X',nvl(D_ipn_ord_agev,0),0)
               , nvl(D_ipn_ord_agev,0)
               , decode( D_agevolato
                       ,'X', nvl(D_ipn_ord,0) - nvl(D_ipn_ord_agev,0)
                           , nvl(D_ipn_ord,0) 
                       )
               , nvl(D_ipt_ord,0)
               , nvl(D_rit_imposta,0)
               , nvl(D_ipt_sosp,0)
               , nvl(D_con_pre_dat,0) , nvl(D_con_pre_lav,0)
               , nvl(D_no_sogg,0) - nvl(D_con_pre_lav,0)
               , nvl(D_spese_rimb,0)
               , nvl(D_rit_rimb,0)
               , nvl(D_altre_rit,0)
               , D_utente, '', sysdate
            from dual
            ;
          END;
      COMMIT;
    END LOOP; -- cur_ci
   END UNO;
 EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_cod_errore
       where no_prenotazione = prenotazione;
      commit;
 END;
END;
END PECCADFA;
/
