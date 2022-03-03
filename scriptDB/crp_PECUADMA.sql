CREATE OR REPLACE PACKAGE PECUADMA IS
/******************************************************************************
 NOME:        PECUADMA
 DESCRIZIONE: Unifica mesi DMA INPDAP
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
     Il package prevede:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    14/03/2006 ML
 1.1  23/05/2006 ML     Gestioni controlli e segnalazioni parametri (A15410.1)
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECUADMA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1  del 23/05/2006';
END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  D_da_anno       number;
  D_da_mese       number;
  D_a_anno        number;
  D_a_mese        number;
  D_gestione      VARCHAR2(8);
  D_rapporto      VARCHAR2(4);
  D_gruppo        VARCHAR2(12);
  D_previdenza    VARCHAR2(6);
  D_ente          VARCHAR2(4);
  D_ambiente      VARCHAR2(8);
  D_utente        VARCHAR2(8);
  D_controllo     VARCHAR2(1);

--
-- Exceptions
--
  USCITA   EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
  SELECT to_number(substr(valore,1,4))
    INTO D_da_anno
	FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_DA_ANNO'
  ;
END;
BEGIN
  SELECT to_number(substr(valore,1,2))
    INTO D_da_mese
	FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_DA_MESE'
  ;
END;
BEGIN
  SELECT to_number(substr(valore,1,4))
    INTO D_a_anno
	FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_A_ANNO'
  ;
END;
BEGIN
  SELECT to_number(substr(valore,1,2))
    INTO D_a_mese
	FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_A_MESE'
  ;
END;
BEGIN
  SELECT valore
    INTO D_previdenza
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_PREVIDENZA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_previdenza := 'CP%';
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
IF D_da_anno||lpad(D_da_mese,2,0) > D_a_anno||lpad(D_a_mese,2,0) THEN
   update a_prenotazioni
      set prossimo_passo = 92
        , errore         = 'P00151'
    where no_prenotazione = prenotazione;
   commit;
   
   RAISE uscita;

END IF;

BEGIN
  select 'X' 
    into D_controllo
    from dual
   where D_a_anno||lpad(D_a_mese,2,0) != decode(D_da_mese,12,D_da_anno+1,D_da_anno)||
                                         decode(D_da_mese,12,'01',lpad(D_da_mese,2,0)+1);

   update a_prenotazioni
      set prossimo_passo = 92
        , errore         = 'P00152'
    where no_prenotazione = prenotazione;
   commit;
   
   RAISE uscita;

EXCEPTION WHEN NO_DATA_FOUND THEN null;
END;

BEGIN
  select 'X' 
    into D_controllo
    from dual
   where D_a_anno||lpad(D_a_mese,2,0) != 
        (select max(anno)||substr(max(anno||lpad(mese,2,0)),5)
           from denuncia_dma);

   update a_prenotazioni
      set prossimo_passo = 92
        , errore         = 'P00153'
    where no_prenotazione = prenotazione;
   commit;
   
   RAISE uscita;

EXCEPTION WHEN NO_DATA_FOUND THEN null;
END;


-- Loop che estrae i dipendenti da elaborare 

FOR CUR1 IN
   (select ci
         , previdenza
         , gestione
         , rilevanza
         , competenza
         , dal
         , al
         , max(fine_servizio)       fine_servizio
         , max(cassa_pensione)      cassa_pensione
         , max(cassa_previdenza)    cassa_previdenza
         , max(cassa_credito)       cassa_credito
         , max(cassa_enpdedp)       cassa_enpdedp
         , max(codice)              codice
         , max(posizione)           posizione
         , max(qualifica)           qualifica
         , max(causale_variazione)  causale_variazione
         , max(data_cessazione)     data_cessazione
         , max(causa_cessazione)    causa_cessazione
         , max(tipo_impiego)        tipo_impiego
         , max(tipo_servizio)       tipo_servizio
         , max(tipo_part_time)      tipo_part_time
         , max(perc_part_time)      perc_part_time
         , max(gg_utili)            gg_utili
         , max(ore_ridotte)         ore_ridotte
         , max(perc_l300)           perc_l300
         , max(riferimento)         riferimento
         , max(tipo_aliquota)       tipo_aliquota
         , sum(comp_fisse)          comp_fisse
         , sum(comp_accessorie)     comp_accessorie
         , sum(magg_l165)           magg_l165
         , sum(comp_18)             comp_18
         , sum(ind_non_a)           ind_non_a
         , sum(iis_conglobata)      iis_conglobata
         , sum(ipn_pens_periodo)    ipn_pens_periodo
         , sum(contr_pens_periodo)  contr_pens_periodo
         , sum(contr_su_eccedenza ) contr_su_eccedenza
         , sum(ipn_tfs)             ipn_tfs
         , sum(contr_tfs)           contr_tfs
         , sum(ipn_tfr)             ipn_tfr
         , sum(contr_ipn_tfr)       contr_ipn_tfr
         , sum(ult_ipn_tfr)         ult_ipn_tfr
         , sum(contr_ult_ipn_tfr)   contr_ult_ipn_tfr
         , sum(ipn_cassa_credito)   ipn_cassa_credito
         , sum(contr_cassa_credito) contr_cassa_credito
         , sum(contr_enpdedp)       contr_cassa_enpdedp
         , sum(tredicesima)         tredicesima
         , sum(retr_teorico_tfr)    retr_teorico_tfr
         , sum(retr_utile_tfr)      retr_utile_tfr
         , sum(quota_solidarieta_l166)   quota_solidarieta_l166
         , sum(contr_solidarieta_l166)   contr_solidarieta_l166
         , sum(retr_l135)                retr_l135
         , sum(contr_solidarieta_l135)   contr_solidarieta_l135
         , sum(contr_pens_calamita)      contr_pens_calamita
         , sum(contr_prev_calamita)      contr_prev_calamita
         , sum(sanzione_pensione)        sanzione_pensione
         , sum(sanzione_previdenza)      sanzione_previdenza
         , sum(sanzione_credito)         sanzione_credito
         , sum(sanzione_enpdedp)         sanzione_enpdedp
         , max(MAGGIORAZIONI)            maggiorazioni    
         , max(GG_MAG_1)                 gg_mag_1      
         , max(GG_MAG_2)                 gg_mag_2  
         , max(GG_MAG_3)                 gg_mag_3    
         , max(GG_MAG_4)                 gg_mag_4
         , max(CF_AMM_FISSE)             cf_amm_fisse
         , max(CF_AMM_ACC)               cf_amm_acc
         , max(DATA_FINE_CALAMITA)       data_fine_calamita   
         , max(TIPO_ACCERTAMENTO)        tipo_accertamento
         , max(DATA_SANZIONI)            data_sanzioni
         , max(GESTIONE_APP)             gestione_app
      from denuncia_dma ddma
     where anno||lpad(mese,2,0) between D_da_anno||lpad(D_da_mese,2,0)
                                    and D_a_anno||lpad(D_a_mese,2,0)
       and ddma.gestione   like D_gestione
       and ddma.previdenza like D_previdenza
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci         = ddma.ci
              and rapporto        like D_rapporto
              and nvl(gruppo,' ') like D_gruppo
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
    group by ci
           , previdenza
           , gestione
           , rilevanza
           , competenza
           , dal
           , al
   ) LOOP
     
     delete from denuncia_dma
     where anno||lpad(mese,2,0) between D_da_anno||lpad(D_da_mese,2,0)
                                    and D_a_anno||lpad(D_a_mese,2,0)
       and gestione   = CUR1.gestione
       and previdenza = CUR1.previdenza
       and ci         = CUR1.ci
       and rilevanza  = CUR1.rilevanza
       and competenza = CUR1.competenza
       and dal        = CUR1.dal
       and al         = CUR1.al
     ;


     insert into denuncia_dma
           ( ddma_id, anno, mese, previdenza, gestione, fine_servizio
           , cassa_pensione, cassa_previdenza, cassa_credito, cassa_enpdedp
           , ci, codice, posizione, qualifica, rilevanza, competenza, causale_variazione
           , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
           , tipo_part_time, perc_part_time, gg_utili, ore_ridotte, perc_l300, riferimento, tipo_aliquota
           , comp_fisse, comp_accessorie, magg_l165, comp_18, ind_non_a, iis_conglobata, ipn_pens_periodo
           , contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
           , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr,contr_ult_ipn_tfr,  ipn_cassa_credito, contr_cassa_credito
           , contr_enpdedp, tredicesima, retr_teorico_tfr, retr_utile_tfr, quota_solidarieta_l166
           , contr_solidarieta_l166, retr_l135, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
           , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp
           , maggiorazioni, gg_mag_1, gg_mag_2, gg_mag_3, gg_mag_4, cf_amm_fisse, cf_amm_acc
           , data_fine_calamita, tipo_accertamento, data_sanzioni, gestione_app
           , utente, tipo_agg, data_agg
           )
      select 
             ddma_sq.nextval, D_da_anno, D_da_mese, CUR1.previdenza, CUR1.gestione, CUR1.fine_servizio
           , CUR1.cassa_pensione, CUR1.cassa_previdenza, CUR1.cassa_credito, CUR1.cassa_enpdedp
           , CUR1.ci, CUR1.codice, CUR1.posizione, CUR1.qualifica
           , decode(to_char(CUR1.dal,'mmyyyy'),lpad(D_da_mese,2,0)||D_da_anno,'E0',CUR1.rilevanza)        rilevanza
           , decode(to_char(CUR1.dal,'mmyyyy'),lpad(D_da_mese,2,0)||D_da_anno,'C',CUR1.competenza)         competenza
           , decode(to_char(CUR1.dal,'mmyyyy'),lpad(D_da_mese,2,0)||D_da_anno,'',CUR1.causale_variazione)  causale_variazione
           , CUR1.dal, CUR1.al, CUR1.data_cessazione, CUR1.causa_cessazione, CUR1.tipo_impiego, CUR1.tipo_servizio
           , CUR1.tipo_part_time, CUR1.perc_part_time, CUR1.gg_utili, CUR1.ore_ridotte, CUR1.perc_l300
           , decode(to_char(CUR1.dal,'mmyyyy'),lpad(D_da_mese,2,0)||D_da_anno,'',CUR1.riferimento)    riferimento
           , decode(to_char(CUR1.dal,'mmyyyy'),lpad(D_da_mese,2,0)||D_da_anno,'',CUR1.tipo_aliquota)  tipo_aliquota
           , CUR1.comp_fisse, CUR1.comp_accessorie, CUR1.magg_l165, CUR1.comp_18, CUR1.ind_non_a, CUR1.iis_conglobata, CUR1.ipn_pens_periodo
           , CUR1.contr_pens_periodo, CUR1.contr_su_eccedenza, CUR1.ipn_tfs, CUR1.contr_tfs
           , CUR1.ipn_tfr, CUR1.contr_ipn_tfr, CUR1.ult_ipn_tfr, CUR1.contr_ult_ipn_tfr, CUR1.ipn_cassa_credito, CUR1.contr_cassa_credito
           , CUR1.contr_cassa_enpdedp, CUR1.tredicesima, CUR1.retr_teorico_tfr, CUR1.retr_utile_tfr, CUR1.quota_solidarieta_l166
           , CUR1.contr_solidarieta_l166, CUR1.retr_l135, CUR1.contr_solidarieta_l135, CUR1.contr_pens_calamita, CUR1.contr_prev_calamita
           , CUR1.sanzione_pensione, CUR1.sanzione_previdenza, CUR1.sanzione_credito, CUR1.sanzione_enpdedp
           , CUR1.maggiorazioni, CUR1.gg_mag_1, CUR1.gg_mag_2, CUR1.gg_mag_3, CUR1.gg_mag_4, CUR1.cf_amm_fisse, CUR1.cf_amm_acc
           , CUR1.data_fine_calamita, CUR1.tipo_accertamento, CUR1.data_sanzioni, CUR1.gestione_app
           , D_utente, null, sysdate
        from dual;
  END LOOP;

commit;
EXCEPTION WHEN USCITA THEN null;
end;
end;
end;
/
