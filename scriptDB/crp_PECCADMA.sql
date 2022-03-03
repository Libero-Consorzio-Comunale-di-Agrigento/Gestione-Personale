CREATE OR REPLACE PACKAGE PECCADMA IS
/******************************************************************************
 NOME:        PECCADMA
 DESCRIZIONE: Archiviazione DMA INPDAP
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
     Il package prevede:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    25/11/2004 CB
 1.1  07/02/2006 ML	Eliminazione utilizza package PERIODO per unificazione record
 1.2  09/02/2005 ML	Definizione di del cur_ci_dma per spostare a un livello piu esterno
                        (cioe dopo che sono stati inseriti TUTTI i record) le operazioni di
			accorpamento record, verifica variabili esterne, e assestamenti vari.
                        nvl(I_aliquota,1) in insert e0
 1.3  22/02/2005 ML	Anticipata la valorizzazione di ini_mese e fin_mese a PRIMA del calcolo
                        dei giorni utili
 1.4  25/02/2005 ML	Modificata condizione per l'emissione dei giorni utili
 2    28/02/2005 ML	Gestione dati riscatti/ricongiunzioni per sezione F1
 3    17/03/2005 ML	Revisione gestione record di tipo V1 (inserimento in negativo vecchio mese dichiarato
			e in positivo nuova situazione)
 4    22/03/2005 ML	Eliminazione lettura da psep_mesi (legge tutto da PERE).
 4.1  30/03/2005 ML	Gestione parametro P_rapporto
 4.2  01/04/2005 ML	Eliminata condizione su moco_mensilita in cur_esterne
 4.3  08/04/2005 ML	Definizione cursore esterno per ottimizzazione tempi di elaborazione
 4.4  14/04/2005 MS     Correzioni segnalazioni varie Rif. A10535.2
 4.5  19/04/2005 ML	Modificata estrazione percentuale part-time verticale come da istruzioni;
                        mod. relative ai problemi BO11369, ecc.
 4.6  26/04/2005 AM     mod. la verisone per identificare chiaramente la patch 4.8.6
 4.7  27/04/2005 ML     modifica al calcolo dei gg utili
 4.8  29/04/2005 ML	modifica alla delete record E0 se servizio = 30 ( non testa tutte le caselle del TFR)
			compilazione perc_l300 se tipo_servizio 32
			modifica gestione cassa_previdenza con update successiva
                        causale di variazione fisso a 1 se servizio 30
 4.9  29/04/2005 AM     modifcata l'emissione della causale_variazione (in caso di V1 ricavati
                        da E0 rimaneva vuota); modificata la gestione dell'unificazione periodi (in
                        caso di cambio date sommava male i dati)
 4.10 30/04/2005 AM     aggiunto trattamento fondo prev. e credito nella parte di recupero rif. esterni
 4.11 02/05/2005 AM     sistemato errore in caso di piu cessazioni riferite al mese in corso
 4.12 04/05/2005 AM     tolta lettura mensilita' *AP; svuotati i comp_18 e IIS_conglobata in caso di cassa_pens != 1
 4.13 04/05/2005 AM     attivazione parametro "posticipato" e mod. sfasato
 4.14 05/05/2005 AM     spostato il trattamento delle quote fuori dal loop di denuncia_dma per includere anche
                        i dip. che non hanno altre voci soggette a denuncia
 4.15 09/05/2005 AM     getita la causa cessazione solo sul rec. che interessa il periodo effettivo
 4.16 10/05/2005 AM     mod. unificazione V1 in caso di cambio date
 4.17 10/05/2005 ML     aggiunta sum(gg_utili) nell'insert dei record unificati.
 4.18 11/05/2005 ML     ricalcolati gg_utili nell'insert dei record unificati.
 4.19 11/05/2005 AM     corretta archiviazione 'posticipata'
 4.20 17/05/2005 ML	definita procedure assicurazioni chiamata sia prima, sia dopo l'unificazione periodi.
 4.21 18/05/2005 ML	gestione assicurazione enpdedp
 4.22 24/05/2005 ML	modificata determinazione cassa_pensione (A11246)
 4.23 27/05/2005 ML	aggiunto test su perc_part_time in ricalcolo giorni utili quando unifica i periodi (A11334)
 4.24 31/05/2005 ML	aggiunta condizione sul moco.riferimento nel cursore delle quote(A11333)
 4.25 07/06/2005 ML	azzerato retr_teorico_tfr se non c'e ipn_tfr; eliminazione record con tutti gli importi a 0
			tolto il controllo sulla dma_quote quando elimina i record E0 con tipo_servizio 30 (A11347)
 4.26 09/06/2005 ML 	attivazione ore ridotte personale scolastico (A11079)
 4.27 13/06/2005 ML	modificato cur_esterne per condizioni "incongruenti" tra loro sul dal/al di esvc.
 4.28 20/06/2005 ML	Modificata determinazione tipo_impigo, tipo_servizio (A11285)
                        Spostato cursore cur_rate dentro al CUR1 per problemi di performance (A11637)
 4.29 28/06/2005 AM     Aggiunto assestamento per eliminare rec. con solo centesimi di arrotondamento; e per azzera
                        imponibile o contributo TFS se presenti solo per via degli arrotondamenti di centesimi (A11823);
                        inoltre sistemata lettura del trattamento in caso di incarico
 4.30 13/7/2005  ML	Modifica gestione causale variazione: impostata fissa a 1 e poi modificata con
			update per i giorni mai dichicarati prima (A11546)
 4.31 05/09/2005 AM	Modificata la gestione delle comp. esterne (A12486)
 4.32 22/09/2005 ML	Eliminate condizioni sulla gestione nella update di assestamento del tipo_impiego e
                        del tipo_servizio (A12529).
 4.33 27/09/2005 ML 	Copia dai mesi precedenti i codici maggiorazioni e la data di fine calamit', i giorni maggiorazione
			vengono attivati con i giorni utili del mese in elaborazione.
                        Aggiunti sul cursore CUR_DMA_CI i controlli sui parametri gestione e previdenza (A12122 - A11965 - A12123).
 5    07/10/2005 ML	Rideterminazione dei record V1 in caso di recupero giornate (es.: conguaglio per recupero giorni in
                        caso di cessazione non comunicata tempestivamente) (A12362).
 5.1  24/10/2005 ML 	Gestione tipo_aliquota e riferimento in insert eseguita solo in caso di mancata valorizzazione arrtrati.
                        Modificata update giorni_maggiorazione.
 5.2  24/10/2005 ML     Copia dai mesi precedenti la gestione di appartenenza, se presente. (A13148).
 5.3  25/11/2005 ML	Valorizzazione riferimento record V1 (A13652).
 5.4  03/11/2005 ML     Modificata gestione part_time (A13185).
 5.5  30/11/2005 ML     Modificata update causale_variazione in caso di tipo_servizio 30 (A13748).
 5.6  07/12/2005 ML     Modificata update tipo_impiego e tipo_servizio in caso di part-time,
                        deve essere eseguita solo sulle competenze C (A13404).
                        Gestione segnalazione di errore per record V1 senza riferimento (A13653).
 5.7  12/12/2005 ML     Modifica record E0 con tipo_servizio 30 in caso di tredicesima + relativa segnalazione (A13853).
 6.0  24/01/2006 ML	Eliminazione commenti e aggiunta order by nel CUR_P.
 6.1  30/01/2006 AM     Riportate anche le casse in caso di passaggio degli importi da E0 con tipo 30 a V1
 6.2  21/02/2006 ML     Eliminato il + 0 sull'accesso a rain (rain.ci + 0) per migliorare i tempi di elaborazione.
                        Aggiunta order by al cur1 e aggiunto il commit dopo il cur_arr (A14930).
 6.3  24/02/2006 ML     Modificato l'ordine di uscita delle stampe di segnalazione e aggiunto dal per la segnalazione
                        delle qualifiche ministeriali (A15026).
 6.4  03/03/2006 ML     Modifica update su competenza C della corrispondente P per gestire anche il tipo aliquota;
                        Inserita relativa segnalazione se non trovato il record. (A13924).
 6.5  26/04/2006 ML     Modificata duplica delle maggiorazioni dal periodo precendente, adesso nei giorni
                        mette i giorni maggiorazione e non i giorni utili (A14929).
                        Inoltre modificato assestamento assicurazioni gestendo la verifica degli importi diversi da 0
                        con le or invece della somma dei valori != 0 (erano capitati importi che si compensavano).
 6.6  23/06/2006 ML     Gestione competenze P con tipo_aliquota 2 (A16812)
 6.7  11/07/2006 ML     Gestione nvl in update tipo_servizio 30 (A16927)
 6.8  27/07/2006 ML     Eliminazione record che si azzerano con pari carattersitiche (A16762).
 6.9  13/10/2006 ML     Aggiunto controllo che la somma degli importi sia diversa da 0
                        in CUR_ESTERNE (A18083).
 7.0  22/01/2007 ML     Copia giorni e codici maggiorazioni dai periodi precedenti se presenti (A18840)
                        Copia data_fine_calamita da record V1 e non solo da E0 (A17442)
 7.1  22/02/2007 ML     Segnalazione per fine_servizio nullo (A19864).
 7.2  14/03/2007 ML     campo tredicesima per dipendenti ex anas previdenza inps con dma solo per inadel (A19858).
 7.3  10/04/2007 ML     Gestione orari ridotti (A20495)
 7.4  19/06/2007 ML     Gestione tipo aliquota Cassa / Competenza (A21496)
 7.5  18/07/2007 ML     Spostata update prossimo passo nel package pecctdma (A21942)
 7.6  14/08/2007 ML     Gestione competenza P per tipo aliquota 2 (A21496.1.0)
 7.7  14/08/2007 ML     Migliorie per cancellazione record con valori che si compensano (A21679)
 7.8  16/8/2007  ML     Gestione controlli specifici (A21491)
 7.9  24/08/2007 ML     Modificata chiamata DETERMINA_QUALIFICA_DMA (A22835).
 7.10 27/09/2007 ML     Gestione tipo servizio 5 in caso di part-time misti o verticali (A22666)
 7.11 10/10/2007 ML     Modifica gestione tipi elaborazione diversi da T e S (A23214).
 7.12 11/10/2007 ML     Modifica controllo imponibile / competenze (A23188)
 7.13 25/10/2007 ML     Cassa/competenza: gestione tipo aliquota per voci a 0 (A23575)
                                          gestione tipo aliquota in update in CUR_P_ASS (A23574)                 
******************************************************************************/
 FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
 PROCEDURE TITOLI_SEGNALAZIONI (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
 PROCEDURE SIST_ASSICURAZIONI (P_ass_ci IN NUMBER, P_ass_anno IN NUMBER, P_ass_mese IN NUMBER);
 PROCEDURE CTR_VOCI ( prenotazione IN NUMBER, passo IN NUMBER, P_anno IN NUMBER, P_mese IN NUMBER);
 PROCEDURE CTR_IPN_PENS ( prenotazione IN NUMBER, passo IN NUMBER
                        , P_anno IN NUMBER, P_mese IN NUMBER
                        , P_ci IN NUMBER, P_errore IN OUT NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCADMA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V7.13  del 25/10/2007';
END VERSIONE;
 PROCEDURE SIST_ASSICURAZIONI (P_ass_ci IN NUMBER, P_ass_anno IN NUMBER, P_ass_mese IN NUMBER) IS
    BEGIN
   update denuncia_dma ddma
      set cassa_previdenza = (select nvl(max('7'),'6')
                                from estrazione_righe_contabili esrc
                               where estrazione = 'DENUNCIA_DMA'
                                 and colonna    = 'ENPAS'
                                 and ddma.al between esrc.dal and nvl(esrc.al,to_date('3333333','j'))
                                 and exists ( select 'x'
                                                from movimenti_contabili
                                               where ci     = P_ass_ci
                                                 and anno   = P_ass_anno
                                                 and mese   = P_ass_mese
                                                 and mensilita != '*AP'
                                                 and voce   = esrc.voce
                                                 and sub    = esrc.sub
                                            )
                             )
      where anno = P_ass_anno
        and mese = P_ass_mese
        and ci   = P_ass_ci
        and nvl(ipn_tfs,0) + nvl(ipn_tfr,0) + nvl(ult_ipn_tfr,0) + nvl(retr_teorico_tfr,0) + nvl(retr_utile_tfr,0) != 0
   ;
  update denuncia_dma ddma
      set cassa_previdenza = null
    where anno = P_ass_anno
      and mese = P_ass_mese
      and ci   = P_ass_ci
      and nvl(ipn_tfs,0) + nvl(ipn_tfr,0) + nvl(ult_ipn_tfr,0) + nvl(retr_teorico_tfr,0) + nvl(retr_utile_tfr,0) = 0
   ;
   update denuncia_dma
      set cassa_credito = null
    where anno = P_ass_anno
      and mese = P_ass_mese
      and ci   = P_ass_ci
      and nvl(ipn_cassa_credito,0) + nvl(contr_cassa_credito,0) = 0
   ;
   update denuncia_dma
      set cassa_pensione = null
    where anno = P_ass_anno
      and mese = P_ass_mese
      and ci   = p_ass_ci
      and nvl(ipn_pens_periodo,0)  = 0
      and nvl(comp_fisse,0)        = 0
      and nvl(comp_accessorie,0)   = 0
      and nvl(ind_non_a,0)         = 0
      and nvl(retr_l135,0)         = 0
   ;
   update denuncia_dma
      set ipn_pens_periodo = null
        , comp_fisse       = null
        , comp_accessorie  = null
        , ind_non_a        = null
        , retr_l135        = null
    where anno = P_ass_anno
      and mese = P_ass_mese
      and ci   = P_ass_ci
      and cassa_pensione is null
   ;
   update denuncia_dma
      set cassa_enpdedp = '8'
    where anno = P_ass_anno
      and mese = P_ass_mese
      and ci   = P_ass_ci
      and nvl(contr_enpdedp,0) != 0
   ;
   update denuncia_dma
      set cassa_enpdedp = null
    where anno = P_ass_anno
      and mese = P_ass_mese
      and ci   = P_ass_ci
      and nvl(contr_enpdedp,0) = 0
      and cassa_enpdedp is not null
   ;
 END sist_assicurazioni;
 PROCEDURE CTR_VOCI (prenotazione IN NUMBER, passo IN NUMBER, P_anno IN NUMBER, P_mese IN NUMBER) IS
   BEGIN
   DECLARE
     D_errore   number := 30000000;
     BEGIN
   FOR CUR_ESRC IN
      (select distinct esrc.voce,esrc.sub
         from estrazione_righe_contabili esrc
        where estrazione = 'DENUNCIA_DMA'
          and colonna    = 'IPN_PENS'
          and last_day(to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy'))
              between dal and nvl(al,to_date('3333333','j'))
          and exists
             (select 'x' from voci_economiche
               where codice = esrc.voce
                 and classe = 'I')
        union
       select distinct cod_voce_ipn,sub_voce_ipn
         from ritenute_voce
        where (voce,sub) in
             (select esrc.voce,esrc.sub
                from estrazione_righe_contabili esrc
               where estrazione = 'DENUNCIA_DMA'
                 and colonna    = 'IPN_PENS'
                 and last_day(to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy'))
                     between dal and nvl(al,to_date('3333333','j'))
                 and exists
                    (select 'x' from voci_economiche
                      where codice = esrc.voce
                        and classe = 'R')
             )
          and last_day(to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy'))
              between dal and nvl(al,to_date('3333333','j'))
      ) LOOP
          D_errore := nvl(D_errore,0) + 1;
          INSERT INTO a_segnalazioni_errore
                ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT prenotazione
               , 1
               , D_errore
               , ' '
               , null
            FROM dual;
          FOR CUR_VOCI IN
             ( select tovo.voce,nvl(tovo.sub,covo.sub) sub
                 from totalizzazionI_voce tovo, contabilita_voce covo
                where tovo.voce_acc = cur_esrc.voce
                  and nvl(tovo.sub,covo.sub) = covo.sub
                  and tovo.voce = covo.voce
                  and last_day(to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy'))
                      between nvl(tovo.dal,to_date('2222222','j'))  and nvl(tovo.al,to_date('3333333','j'))
                  and last_day(to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy'))
                      between nvl(covo.dal,to_date('2222222','j')) and nvl(covo.al,to_date('3333333','j'))
                minus
               select voce,sub
                 from estrazione_righe_contabili
                where estrazione = 'DENUNCIA_DMA'
                  and colonna in ('COMP_FISSE','COMP_ACCESSORIE','COMP_18'
                                 ,'IIS_CONGLOBATA','IND_NON_A')
                  and last_day(to_date(lpad(P_mese,2,0)||P_anno,'mmyyyy'))
                      between dal and nvl(al,to_date('3333333','j'))
             ) LOOP
                 D_errore := nvl(D_errore,0) + 1;
                 INSERT INTO a_segnalazioni_errore
                       ( no_prenotazione, passo, progressivo, errore, precisazione )
                 SELECT prenotazione
                      , 1
                      , D_errore
                      , 'P05602'
                      , CUR_ESRC.voce||', ma non in estrazione DENUNCIA_DMA: '||
                        rpad(CUR_VOCI.voce,10,' ')||' / '||CUR_VOCI.sub
                   FROM dual;
             END LOOP;
        END LOOP;
        END;
   END CTR_VOCI;
 PROCEDURE CTR_IPN_PENS ( prenotazione IN NUMBER, passo IN NUMBER
                        , P_anno IN NUMBER, P_mese IN NUMBER
                        , P_ci IN NUMBER, P_errore IN OUT NUMBER) IS
 BEGIN
   BEGIN
   FOR CUR_DIFF IN
      (select ci,dal,al,competenza,tipo_aliquota
         from denuncia_dma
        where anno = P_anno
          and mese = P_mese
          and ci   = P_ci
          and abs(nvl(ipn_pens_periodo,0) -( nvl(comp_fisse,0) +
                                         nvl(comp_accessorie,0) +
--                                         nvl(comp_18,0) +
--                                         nvl(iis_conglobata,0)  +
                                         nvl(ind_non_a,0))) > 0.02
          and tipo_servizio in (2,3,4,5,7,11,15,27)
      ) LOOP

          P_errore := nvl(P_errore,0) + 1;
          INSERT INTO a_segnalazioni_errore
                ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT prenotazione
               , 1
               , P_errore
               , ' '
               , null
            FROM dual;

          P_errore := nvl(P_errore,0) + 1;
          INSERT INTO a_segnalazioni_errore
                ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT prenotazione
               , 1
               , P_errore
               , 'P00116'
               , 'Cod.Ind. '||lpad(to_char(CUR_DIFF.ci),8,' ')||
                 ' dal '||to_char(CUR_DIFF.dal,'dd/mm/yy')||
                 ' al '||to_char(CUR_DIFF.al,'dd/mm/yy')||
                 ' comp. '||CUR_DIFF.competenza||' aliquota '||CUR_DIFF.tipo_aliquota
            FROM dual;
        END LOOP;
        END;
   END CTR_IPN_PENS;
 PROCEDURE TITOLI_SEGNALAZIONI (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 1
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 10 and 29999000)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 1)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 2
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 10 and 29999000)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 2)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 3
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 10 and 29999000)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 3)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 4
        , ' '
        , 'SEGNALAZIONI BLOCCANTI: E'' NECESSARIO MODIFICARE I DATI PRIMA DI INVIARE IL FILE ALL''INPDAP'
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 10 and 29999000)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 4)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 5
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 10 and 29999000)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 5)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 29999901
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 29999910 and 59999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 29999901)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 29999902
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 29999910 and 59999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 29999902)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 29999903
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 29999910 and 59999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 29999903)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 29999904
        , ' '
        , 'SEGNALAZIONI DI MANCATA QUADRATURA'
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 29999910 and 59999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 29999904)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 29999905
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 29999910 and 59999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 29999905)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 59999901
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 59999910 and 79999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 59999901)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 59999902
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 59999910 and 79999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 59999902)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 59999903
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 59999910 and 79999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 59999903)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 59999904
        , ' '
        , 'SEGNALAZIONI DI ANOMALIE NON BLOCCANTI DA VERIFICARE'
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 59999910 and 79999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 59999904)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 59999905
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 59999910 and 79999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 59999905)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 79999901
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 79999910 and 99999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 79999901)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 79999902
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 79999910 and 99999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 79999902)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 79999903
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 79999910 and 99999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 79999903)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 79999904
        , ' '
        , 'DIPENDENTI NON ELABORATI'
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 79999910 and 99999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 79999904)
   ;
   insert into a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
   SELECT prenotazione
        , 1
        , 79999905
        , ' '
        , null
     FROM dual
    where exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
             and progressivo between 79999910 and 99999999)
      and not exists
         (select 'x' from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = 1
             and progressivo     = 79999905)
   ;
 END;  -- TITOLI_SEGNALAZIONI
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  D_rilevanza     VARCHAR2(2);
  D_qualifica     varchar2(6);
  P_sfasato       VARCHAR2(1);
  P_posticipato   VARCHAR2(1);
  P_cassa         VARCHAR2(1);
  P_aliquota      VARCHAR2(1);
  D_ente          VARCHAR2(4);
  D_ambiente      VARCHAR2(8);
  D_utente        VARCHAR2(8);
  D_anno          NUMBER(4);
  D_anno_moco     NUMBER(4);
  D_mese          NUMBER(2);
  D_mese_moco     NUMBER(2);
  D_ini_MESE      VARCHAR2(8);
  D_fin_MESE      VARCHAR2(8);
  D_gestione      VARCHAR2(8);
  D_rapporto      VARCHAR2(4);
  D_gruppo        VARCHAR2(12);
  D_previdenza    VARCHAR2(6);
  D_tipo          VARCHAR2(1);
  D_ci            NUMBER(8);
  D_prg_err       NUMBER := 60000000;  -- segnalazione assegnazione automatica
  D_prg_err_1     NUMBER := 62000000;  -- manca qualifica ministeriale
  D_prg_err_1b    NUMBER := 63000000;  -- Più qualifiche ministeriali
  D_prg_err_2     NUMBER := 2000000;   -- riferimento assente in V1
  D_prg_err_3     NUMBER := 3000000;   -- E0 con servizio 30 e competenze
  D_prg_err_3b    NUMBER := 64000000;  -- E0 con servizio 30 e competenze sommati in altro periodo
  D_prg_err_4     NUMBER := 1000000;   -- segnalazione negativi
  D_prg_err_5     NUMBER := 32000000;  -- mancato aggiornamento competenza P
  D_prg_err_6     NUMBER := 31000000;  -- imponibile diverso competenze
  D_prg_err_7     NUMBER := 10;        -- Perc. part-time non conforme ??? che tipo è ???
  D_prg_err_8     NUMBER := 33000000;  -- Riferimento esterno al servizio
  D_prg_err_8b    NUMBER := 65000000;  -- Riferimento esterno al servizio sommati in altro periodo
  D_prg_err_9     NUMBER := 80000000;   -- Dati modificati manualmente
  I_previdenza    VARCHAR2(6);
  I_trattamento   VARCHAR2(4);
  I_fine_servizio NUMBER;
  I_pensione      VARCHAR2(1);
  I_codice        VARCHAR2(10);
  I_enpdep        varchar2(1);
  I_posizione     VARCHAR2(8);
  I_servizio      varchar2(2);
  I_perc_l300     number;
  I_data_ces      DATE;
  I_causa_ces     VARCHAR2(2);
  I_tipo_part_time     varchar2(1);
  I_perc_part_time     number;
  I_note_tipo     varchar2(1);
  I_note_perc     varchar2(5);
  I_gg_utili      number;
  I_rif           varchar2(4);
  I_aliquota      number;
  I_comp_fisse    NUMBER;
  I_comp_acc      NUMBER;
  I_comp_18       NUMBER;
  I_ind_non_a     NUMBER;
  I_iis_congl     NUMBER;
  I_ipn_pens      NUMBER;
  I_contr_pens    NUMBER;
  I_contr_agg     NUMBER;
  I_ipn_tfs       NUMBER;
  I_contr_tfs     NUMBER;
  I_ipn_tfr       NUMBER;
  I_contr_tfr     NUMBER;
  I_ipn_cassa_cr  NUMBER;
  I_con_cassa_cr  NUMBER;
  I_con_enpdedp   NUMBER;
  I_tredicesima   NUMBER;
  I_teorico_tfr   NUMBER;
  I_comp_tfr      NUMBER;
  I_quota_l166    NUMBER;
  I_contr_l166    NUMBER;
  I_comp_premio   NUMBER;
  I_contr_l135    NUMBER;
  I_contr_pens_s  NUMBER;
  I_contr_prev_s  NUMBER;
  I_sanz_pens     NUMBER;
  I_sanz_prev     NUMBER;
  I_sanz_cred     NUMBER;
  I_sanz_enpdedp  NUMBER;
  D_errore        varchar2(6);
  D_pagina        number :=1;
  D_riga          number :=1;
  DU_conta		number;
  DU_ddma_id            number;
  DU_rilevanza          varchar2(2);
  DU_competenza         varchar2(1);
  DU_previdenza         varchar2(6);
  DU_gestione           varchar2(8);
  DU_cassa_pensione     varchar2(1);
  DU_cassa_previdenza	varchar2(1);
  DU_cassa_credito	varchar2(1);
  DU_cassa_enpdedp	varchar2(1);
  DU_qualifica		varchar2(6);
  DU_causa_cessazione	varchar2(2);
  DU_tipo_impiego       varchar2(2);
  DU_tipo_servizio	varchar2(2);
  DU_perc_part_time	number;
  DU_ore_ridotte        number;
  DU_dal                DATE;
  DU_al			DATE;
  DU_tipo_aliquota      number;
  V_controllo           VARCHAR2(1);
  V_insert              VARCHAR2(1);
  OLD_ddma              number(10);
  OLD_dal               date;
  OLD_al                date;
  DDMA30_segnala        number;
  DDMA30_dal            date;
  DDMA30_al             date;
  EST_dal               date;
  EST_al                date;
--
-- Exceptions
--
  USCITA   EXCEPTION;
  NO_ELAB  EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
  SELECT valore
    INTO D_tipo
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_TIPO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_tipo := NULL;
END;
BEGIN
  SELECT to_number(substr(valore,1,4))
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
  SELECT to_number(substr(valore,1,2))
    INTO D_mese
	FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_MESE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    SELECT mese
      INTO D_mese
      FROM RIFERIMENTO_RETRIBUZIONE
     WHERE rire_id = 'RIRE'
    ;
END;
BEGIN
  SELECT valore
    INTO D_ci
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_CI'
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
    INTO P_cassa
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_CASSA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_cassa := null;
END;
BEGIN
  SELECT valore
    INTO P_aliquota
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ALIQUOTA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_aliquota := null;
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
BEGIN
  SELECT valore
    INTO P_sfasato
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_SFASATO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      P_sfasato := null;
END;
IF P_sfasato = 'X' THEN
  BEGIN
   SELECT decode(D_mese-1,0,12,D_mese-1)
       ,  D_mese
       ,  decode(D_mese-1,0,D_anno-1,D_anno)
       ,  D_anno
    INTO  D_mese
       ,  D_mese_moco
       ,  D_anno
       ,  D_anno_moco
    FROM  dual
  ;
  END;
ELSE
  D_mese_moco := D_mese;
  D_anno_moco := D_anno;
END IF;
BEGIN
  SELECT valore
    INTO P_posticipato
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_POSTICIPATO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      P_posticipato := null;
END;
--CTR_VOCI (prenotazione, passo, D_anno, D_mese);
IF P_posticipato = 'X' THEN
  BEGIN
   SELECT decode(D_mese+1,13,1,D_mese+1)
        , D_mese
        , decode(D_mese+1,13,D_anno+1,D_anno)
        , D_anno
    INTO  D_mese
        , D_mese_moco
        , D_anno
        , D_anno_moco
    FROM  dual
  ;
  END;
ELSE
  D_mese_moco := D_mese;
  D_anno_moco := D_anno;
END IF;
-- Eliminazione precedenti registrazioni
delete from denuncia_dma_quote ddmq
 where anno          = D_anno
   and mese          = D_mese
   and gestione   like D_gestione
   and ci           IN (SELECT ci FROM RAPPORTI_INDIVIDUALI
                         WHERE rapporto LIKE D_rapporto
                           AND NVL(gruppo,' ')   LIKE D_gruppo
                           and (   cc is null
                                or exists
                                  (select 'x'
                                     from a_competenze
                                    where ente        = D_ente
                                      and ambiente    = D_ambiente
                                      and utente      = D_utente
                                      and competenza  = 'CI'
                                      and oggetto     = cc
                                  )
                               )
                       )
   and (    D_tipo   = 'T'
        or (    D_tipo   = 'S'
            and ci       = D_ci)
        or (    D_tipo in ('P','V','I')
            and not exists
               (select 'x' from denuncia_dma_quote
                 where anno              = D_anno
                   and mese              = D_mese
--                   and gestione          = ddmq.gestione
                   and ci                = ddmq.ci
                   and nvl(tipo_agg,' ') = decode(D_tipo,'P',tipo_agg,D_tipo)
               )
           )
       )
/*   and exists
      (select 'x'
         from rapporti_individuali rain
        where rain.ci      = ddmq.ci
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
*/;
delete from denuncia_dma dedm
 where anno          = D_anno
   and mese          = D_mese
   and gestione   like D_gestione
   and previdenza like D_previdenza
   and ci           IN (SELECT ci FROM RAPPORTI_INDIVIDUALI
                         WHERE rapporto LIKE D_rapporto
                           AND NVL(gruppo,' ')   LIKE D_gruppo
                           and (   cc is null
                                or exists
                                  (select 'x'
                                     from a_competenze
                                    where ente        = D_ente
                                      and ambiente    = D_ambiente
                                      and utente      = D_utente
                                      and competenza  = 'CI'
                                      and oggetto     = cc
                                  )
                               )
                       )
   and (    D_tipo   = 'T'
        or (    D_tipo   = 'S'
            and ci       = D_ci)
        or (    D_tipo in ('P','V','I')
            and not exists
               (select 'x' from denuncia_dma
                 where anno              = D_anno
                   and mese              = D_mese
--                   and gestione          = dedm.gestione
--                   and previdenza        = dedm.previdenza
                   and ci                = dedm.ci
                   and nvl(tipo_agg,' ') = decode(D_tipo,'P',tipo_agg,D_tipo)
               )
           )
       )
   and not exists
      (select 'x' from denuncia_dma_quote
        where anno     = dedm.anno
          and mese     = dedm.mese
          and gestione = dedm.gestione
          and ci       = dedm.ci)
/*   and exists
      (select 'x'
         from rapporti_individuali rain
        where rain.ci      = dedm.ci
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
*/;
IF D_tipo not in ('T','S') THEN
   FOR CUR_NO_ELAB IN 
      (select distinct ci 
         from denuncia_dma
        where anno          = D_anno
          and mese          = D_mese
--          and gestione   like D_gestione
--          and previdenza like D_previdenza
        union
       select distinct ci 
         from denuncia_dma
        where anno          = D_anno
          and mese          = D_mese        
      ) LOOP 
          D_prg_err_9 := nvl(D_prg_err_9,0) + 1;
          INSERT INTO a_segnalazioni_errore
                ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT prenotazione
               , 1
               , D_prg_err_9
               , ' '
               , null
            FROM dual;
          D_prg_err_9 := nvl(D_prg_err_9,0) + 1;
          INSERT INTO a_segnalazioni_errore
                ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT prenotazione
               , 1
               , D_prg_err_9
               , 'P00121'
               , ' per Cod.Ind.: '||RPAD(TO_CHAR(CUR_NO_ELAB.ci),8,' ')
            FROM dual;
        END LOOP;
END IF;
-- Loop che estrae i dipendenti da elaborare --
FOR CUR1 IN
   (select pere.ci,pere.gestione
      from periodi_retributivi pere
         , trattamenti_previdenziali trpr
     where anno              = D_anno_moco
       and mese              = D_mese_moco
       and pere.competenza   = 'A'
       and pere.gestione   like D_gestione
       and pere.trattamento = trpr.codice
       and trpr.previdenza like D_previdenza
       and (         D_tipo = 'T'
             or (    D_tipo = 'S' and pere.ci = D_ci)
             or (    D_tipo in ('I','V','P')
                 and not exists
                    (select 'x' from denuncia_dma
                      where anno              = D_anno
                        and mese              = D_mese
--                        and gestione          = pere.gestione
--                        and previdenza        = trpr.previdenza
                        and ci                = pere.ci
                        and nvl(tipo_agg,' ') = decode(D_tipo,'P',tipo_agg,D_tipo)
                    )
                )
          )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci         = pere.ci
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
    order by pere.ci
   ) LOOP
   FOR CUR_CI IN CURSORE_DMA.CUR_DIP_DMA (CUR1.ci, D_anno_moco, D_mese_moco,D_gestione )  LOOP
    BEGIN
    I_servizio := null;
    I_perc_l300 := to_number(null);
    BEGIN -- modifico il tipo servizio se esiste un astensione non utile nel periodo
      select aste.cat_fiscale, decode(aste.cat_fiscale,'32',aste.per_ret,null)
        into I_servizio, I_perc_l300
        from astensioni    aste
           , periodi_retributivi pere
       where pere.periodo = cur_ci.periodo
         and pere.ci      = cur_ci.ci
         and pere.competenza   = lower(cur_ci.competenza)
         and pere.servizio     = 'Q'
         and pere.dal          = cur_ci.pere_dal
         and pere.al           = cur_ci.al
         and pere.cod_astensione = aste.codice;
    EXCEPTION WHEN NO_DATA_FOUND THEN I_servizio := cur_ci.servizio;
              WHEN TOO_MANY_ROWS THEN I_servizio := cur_ci.servizio;
    END;
    I_trattamento := null;
    BEGIN -- modifico il trattamento previdenziale se esiste un incarico
      select trattamento
        into I_trattamento
        from periodi_retributivi pere
       where pere.periodo = cur_ci.periodo
         and pere.ci      = cur_ci.ci
         and pere.competenza not in ('P','D')
         and pere.competenza   = upper(pere.competenza)
         and pere.servizio     = 'I'
         and pere.dal          = cur_ci.pere_dal
         and pere.al           = cur_ci.al;
    EXCEPTION WHEN NO_DATA_FOUND THEN I_trattamento := cur_ci.trattamento;
              WHEN TOO_MANY_ROWS THEN I_trattamento := cur_ci.trattamento;
    END;
   D_qualifica := null;
   BEGIN
	 SELECT pegi.al, evra.cat_inpdap
	 INTO I_data_ces, I_causa_ces
	 FROM PERIODI_GIURIDICI pegi,
	      EVENTI_RAPPORTO   evra
	 WHERE pegi.rilevanza = 'P'
	   AND pegi.ci        = CUR_CI.ci
	   AND pegi.posizione    = evra.codice
	   AND NVL(cur_ci.al,to_date('3333333','j')) between pegi.dal and pegi.al
           AND pegi.al between cur_ci.dal and NVL(cur_ci.al,to_date('3333333','j'));
	 EXCEPTION
	    WHEN NO_DATA_FOUND THEN
         begin
          SELECT null, reco.rv_low_value
		INTO I_data_ces, I_causa_ces
		FROM pec_ref_codes reco
	     WHERE rv_domain = 'DENUNCIA_DMA.CAUSA_CESSAZIONE'
	       AND rv_abbreviation like '%SOSPENSIONE'
               AND exists  (select 'x' from periodi_giuridici
                            WHERE rilevanza = 'A'
	                     AND ci        = CUR_CI.ci
	            	     AND dal       = CUR_CI.al+1
                             AND assenza in (select codice
                                               from astensioni
                                              where servizio = 0
                                                AND cat_fiscale = substr(rv_abbreviation,1,2)
                                           )
                 	       )
          ;
	 EXCEPTION
	    WHEN NO_DATA_FOUND THEN
           I_data_ces   := null;
           I_causa_ces  := null;
       end;
	END;
   I_perc_part_time := null;
   I_tipo_part_time := null;
   I_note_perc      := null;
   I_note_tipo      := null;
-- dbms_output.put_line('CUR_CI.part_time '||CUR_CI.part_time||' CUR_CI.ore '||CUR_CI.ore||' CUR_CI.ore_lavoro '||CUR_CI.ore_lavoro);
   IF nvl(CUR_CI.part_time,'NO') = 'SI' THEN
      BEGIN
        select decode( instr(upper(note),'VERTICALE: ')
                    , 0, substr(note,instr(upper(note),'MISTO: ')+7,5)
                       , substr(note,instr(upper(note),'VERTICALE: ')+11 ,5)
                    )
            ,decode( instr(upper(note),'VERTICALE: ')
                                 , 0, 'M'
                                    , 'V'
                                 )
          into I_note_perc
             , I_note_tipo
          from periodi_giuridici
         where ci        = CUR_CI.ci
           and rilevanza = 'S'
           and CUR_CI.al between dal and nvl(al,to_date('3333333','j'))
           and (   instr(upper(note),'VERTICALE: ') != 0
                or instr(upper(note),'MISTO: ') != 0 )
        ;
        exception
           when no_data_found then I_note_perc := null;
                                   I_note_tipo := null;
        END;
        IF translate(nvl(I_note_perc,'99999'),'0123456789.', '99999999999') != '99999' THEN
           D_prg_err_7 := nvl(D_prg_err_7,0) + 1;
           INSERT INTO a_segnalazioni_errore
                 ( no_prenotazione, passo, progressivo, errore, precisazione )
           SELECT prenotazione
                , 1
                , D_prg_err_7
                , ' '
                , null
             FROM dual;
           D_prg_err_7 := nvl(D_prg_err_7,0) + 1;
           INSERT INTO a_segnalazioni_errore
                 ( no_prenotazione, passo, progressivo, errore, precisazione )
           SELECT prenotazione
                , 1
                , D_prg_err_7
                , 'P00117'
                , 'per Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')||'  '||
                  'Dal '||TO_CHAR(CUR_CI.dal,'dd/mm/yyyy')||'  '||
                  'Al '||TO_CHAR(CUR_CI.al,'dd/mm/yyyy')
             FROM dual;
           RAISE NO_ELAB;
        END IF;
         IF CUR_CI.tipo_part_time is null  THEN
               IF CUR_CI.ore != CUR_CI.ore_lavoro THEN
                  I_perc_part_time := nvl(I_note_perc,round(CUR_CI.ore*100/CUR_CI.ore_lavoro,2));
                  I_tipo_part_time := nvl(I_note_tipo,'P');
               ELSE
                  I_perc_part_time := I_note_perc;
                  I_tipo_part_time := I_note_tipo;
               END IF;
         ELSIF CUR_CI.tipo_part_time = 'O' THEN
               IF CUR_CI.ore != CUR_CI.ore_lavoro THEN
                  I_perc_part_time := nvl(I_note_perc,round(CUR_CI.ore*100/CUR_CI.ore_lavoro,2));
                  I_tipo_part_time := nvl(I_note_tipo,'P');
               ELSE
                  I_perc_part_time := I_note_perc;
                  I_tipo_part_time := I_note_tipo;
               END IF;
         ELSIF CUR_CI.tipo_part_time = 'M' THEN
               IF CUR_CI.ore != CUR_CI.ore_lavoro THEN
                  I_perc_part_time := nvl(I_note_perc,round(CUR_CI.ore*100/CUR_CI.ore_lavoro,2));
                  I_tipo_part_time := nvl(I_note_tipo,CUR_CI.tipo_part_time);
               ELSE
                  I_perc_part_time := I_note_perc;
                  I_tipo_part_time := I_note_tipo;
               END IF;
         ELSIF CUR_CI.tipo_part_time = 'V' THEN
               IF CUR_CI.ore != CUR_CI.ore_lavoro THEN
                  I_perc_part_time := nvl(I_note_perc,round(CUR_CI.ore*100/CUR_CI.ore_lavoro,2));
                  I_tipo_part_time := nvl(I_note_tipo,CUR_CI.tipo_part_time);
               ELSE
                  I_perc_part_time := I_note_perc;
                  I_tipo_part_time := I_note_tipo;
               END IF;
         END IF;
   END IF;
   I_fine_servizio := null;
   I_previdenza    := null;
   I_pensione      := null;
     BEGIN
   -- cerco la previdenza da periodi_retributivi
       select substr(reco.rv_low_value,1,1)
            , nvl(trpr.previdenza,' ')
            , nvl(trpr.fine_servizio,0)
         into I_pensione,I_previdenza,I_fine_servizio
         from pec_ref_codes             reco
            , trattamenti_previdenziali trpr
        where trpr.codice               = nvl(I_trattamento,CUR_CI.trattamento)
          and reco.rv_domain    (+)     = 'DENUNCIA_INPDAP.ASSICURAZIONI'
          and reco.rv_abbreviation (+)  = trpr.previdenza
          and trpr.previdenza        like D_previdenza
        group by reco.rv_low_value,trpr.previdenza,trpr.fine_servizio;
    EXCEPTION WHEN NO_DATA_FOUND THEN
              --  Segnala periodi senza previdenza
          I_fine_servizio := 0;
          I_previdenza    := ' ';
    END;
    IF I_fine_servizio = 0 or nvl(I_previdenza,' ') = ' ' THEN
       D_prg_err := nvl(D_prg_err,0) + 1;
       INSERT INTO a_segnalazioni_errore
             ( no_prenotazione, passo, progressivo, errore, precisazione )
       SELECT prenotazione
            , 1
            , D_prg_err
            , ' '
            , null
         FROM dual;
       D_prg_err := nvl(D_prg_err,0) + 1;
       INSERT INTO a_segnalazioni_errore
             ( no_prenotazione, passo, progressivo, errore, precisazione )
       SELECT prenotazione
            , 1
            , D_prg_err
            , 'P05191'
            , 'Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')||'  '||
              'Dal '||TO_CHAR(CUR_CI.dal,'dd/mm/yyyy')||'  '||
              'Al '||TO_CHAR(CUR_CI.al,'dd/mm/yyyy')
         FROM dual;
     END IF;
--     dbms_output.put_line('trattamento '||nvl(I_trattamento,CUR_CI.trattamento)||' D_previdenza '||D_previdenza||' fine ser. '||I_fine_servizio);
   BEGIN
     SELECT DECODE( I_previdenza, 'CPDEL', codice_cpd, codice_cps)
          , DECODE( I_previdenza, 'CPDEL', posizione_cpd, posizione_cps)
       INTO I_codice,I_posizione
       FROM rapporti_retributivi
      WHERE ci = CUR_CI.ci;
   EXCEPTION
        WHEN NO_DATA_FOUND THEN I_codice    := NULL;
                                I_posizione := NULL;
   END;
   CURSORE_DMA.DETERMINA_QUALIFICA_DMA(to_char(D_anno),to_char(D_mese), CUR_CI.ci,
                                          CUR_CI.figura,CUR_CI.qualifica,CUR_CI.posizione,CUR_CI.tipo_rapporto,
                                          to_char(TO_DATE('01'||LPAD(to_char(D_mese_moco),2,0)||to_char(D_anno_moco),'ddmmyyyy'),'ddmmyyyy'),
                                          to_char(CUR_CI.dal,'ddmmyyyy'),to_char(CUR_CI.al,'ddmmyyyy'),
                                          D_qualifica,
                                          D_prg_err_1, D_prg_err_1b, prenotazione);
   D_ini_mese      := '01'||to_char(cur_ci.dal,'mmyyyy');
   D_fin_mese      := to_char(last_day(to_date(('01'||to_char(CUR_ci.dal,'mmyyyy')),'ddmmyyyy')),'ddmmyyyy');
   BEGIN
     select decode(to_char(CUR_CI.dal,'ddmmyyyy'),
                   D_ini_mese,decode(to_char(CUR_CI.al,'ddmmyyyy'),
                                     D_fin_mese,30,CUR_CI.al-CUR_CI.dal+1
                                    ),
                              decode(to_char(CUR_CI.al,'ddmmyyyy'),
                                     D_fin_mese,greatest(0,30-to_char(CUR_CI.dal,'dd'))+1,
                                                CUR_CI.al-CUR_CI.dal+1
                  ) )
       into I_gg_utili
       from dual
      where CUR_CI.tipo_part_time is null
     ;
    EXCEPTION
	   WHEN NO_DATA_FOUND THEN I_gg_utili  := NULL;
    END;
    BEGIN
      if to_char(cur_ci.dal,'mmyyyy') = lpad(to_char(D_mese),2,0)||to_char(D_anno) then
         D_rilevanza          :='E0';
         I_rif                := null;
         I_aliquota           := 1;
      else
         D_rilevanza := 'V1';
         old_ddma := to_number(null);
         old_dal  := to_date(null);
         old_al   := to_date(null);
         FOR CUR_OLD IN
            (select ddma_id, dal, al, tipo_aliquota
               from denuncia_dma ddma
              where (anno,mese) in
                   (select max(anno),substr(max(anno||lpad(mese,2,'0')),5)
                      from denuncia_dma
                     where ci    = CUR_ci.ci
                       and anno >= to_char(cur_ci.dal,'yyyy')
                       and anno||lpad(mese,2,'0') < D_anno||lpad(D_mese,2,'0')
                       and to_char(dal,'mmyyyy') = to_char(cur_ci.dal,'mmyyyy')
                       and nvl(competenza,'C')  = 'C'
                   )
               and ci = cur_ci.ci
               and to_char(dal,'mmyyyy') = to_char(cur_ci.dal,'mmyyyy')
               and nvl(competenza,'C')  = 'C'
            ) LOOP
               old_ddma := cur_old.ddma_id;
               old_dal  := cur_old.dal;
               old_al   := cur_old.al;
               insert into denuncia_dma
                 ( ddma_id, anno, mese, previdenza, gestione, fine_servizio
                 , cassa_pensione, cassa_previdenza, cassa_credito, cassa_enpdedp
                 , ci, codice, posizione, qualifica, rilevanza, competenza, causale_variazione
                 , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
                 , tipo_part_time, perc_part_time, gg_utili, ore_ridotte, perc_l300
                 , maggiorazioni, gg_mag_1, gg_mag_2, gg_mag_3, gg_mag_4, riferimento, tipo_aliquota
                 , comp_fisse, comp_accessorie, magg_l165, comp_18, ind_non_a, iis_conglobata, ipn_pens_periodo
                 , contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
                 , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr,contr_ult_ipn_tfr,  ipn_cassa_credito, contr_cassa_credito
                 , contr_enpdedp, tredicesima, retr_teorico_tfr, retr_utile_tfr, quota_solidarieta_l166
                 , contr_solidarieta_l166, retr_l135, data_fine_calamita, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
                 , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp, utente, tipo_agg, data_agg
                 )
               select
                   ddma_sq.nextval, D_anno, D_mese, previdenza, gestione, fine_servizio
                 , cassa_pensione, cassa_previdenza, cassa_credito, cassa_enpdedp
                 , ci, codice, posizione, qualifica, 'V1', 'P', '1'
                 , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
                 , tipo_part_time, perc_part_time, 0 gg_utili, ore_ridotte, perc_l300
                 , maggiorazioni, gg_mag_1, gg_mag_2, gg_mag_3, gg_mag_4, decode(ddma.rilevanza,'E0',substr(lpad(nvl(riferimento,anno),6,'0'),3,4),riferimento), tipo_aliquota
                 , comp_fisse*-1, comp_accessorie*-1, magg_l165*-1, comp_18*-1, ind_non_a*-1, iis_conglobata*-1, ipn_pens_periodo*-1
                 , contr_pens_periodo*-1, contr_su_eccedenza*-1, ipn_tfs*-1, contr_tfs*-1
                 , ipn_tfr*-1, contr_ipn_tfr*-1, ult_ipn_tfr*-1, contr_ult_ipn_tfr*-1, ipn_cassa_credito*-1, contr_cassa_credito*-1
                 , contr_enpdedp*-1, tredicesima*-1, retr_teorico_tfr*-1, retr_utile_tfr*-1, quota_solidarieta_l166*-1
                 , contr_solidarieta_l166*-1, retr_l135*-1, data_fine_calamita,  contr_solidarieta_l135*-1, contr_pens_calamita*-1, contr_prev_calamita*-1
                 , sanzione_pensione*-1, sanzione_previdenza*-1, sanzione_credito*-1, sanzione_enpdedp*-1
                 , D_utente, null, sysdate
                from denuncia_dma ddma
               where ddma_id = cur_old.ddma_id
                 and not exists
                     (select 'x' from denuncia_dma
                       where anno      = D_anno
                         and mese      = D_mese
                         and ci        = cur_ci.ci
                         and rilevanza = 'V1'
                         and dal       = cur_old.dal
                         and al        = cur_old.al
                         and tipo_aliquota = cur_old.tipo_aliquota
                         and competenza = 'P');
         END LOOP;
      end if;
      if to_char(cur_ci.dal,'yyyy')  = to_char(D_anno) then
-- Estrazione dati economici correnti --
-- La select va da valori_contabili_annuali volutamente, attenzione alla condizione sul MOCO_MESE che serve proprio per
-- estrarre solo i dati del mese di elaborazione e NON i dati fino a quel mese, attenzione che pero' NON DEVE ESSERCI
-- la condizione sulla MOCO_MENSILITA perche' del mese di elaborazione servono TUTTE le mensilita se ce ne sono piu di una
         BEGIN
           select round(sum(decode( vaca.colonna
                                , 'COMP_FISSE', nvl(vaca.valore,0)
                                              , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                , round(sum(decode( vaca.colonna
                                , 'COMP_ACCESSORIE', nvl(vaca.valore,0)
                                              , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                               , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                               , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'COMP_18', nvl(vaca.valore,0)
                                             , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                       , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'IND_NON_A', nvl(vaca.valore,0)
                                               , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'IIS_CONGLOBATA', nvl(vaca.valore,0)
                                                    , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                              , '')),1)
               , round(sum(decode( vaca.colonna
                                  , 'IPN_PENS', nvl(vaca.valore,0)
                                              , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_PENS', nvl(vaca.valore,0)
                                                , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_AGG', nvl(vaca.valore,0)
                                               , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
               , round(sum(decode( vaca.colonna
                                  , 'IPN_TFS', nvl(vaca.valore,0)
                                              , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_TFS', nvl(vaca.valore,0)
                                               , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
               , round(sum(decode( vaca.colonna
                                  , 'IPN_TFR', nvl(vaca.valore,0)
                                              , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_TFR', nvl(vaca.valore,0)
                                               , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                         , '')),1)
               , round(sum(decode( vaca.colonna
                                  , 'IPN_CASSA_CREDITO', nvl(vaca.valore,0)
                                                       , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                 , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                 , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_CASSA_CREDITO', nvl(vaca.valore,0)
                                                         , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                   , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                                   , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_ENPDEDP', nvl(vaca.valore,0)
                                                   , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'TREDICESIMA', nvl(vaca.valore,0)
                                                 , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'TEORICO_TFR', nvl(vaca.valore,0)
                                                 , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                       )    * nvl(max(distinct decode( vaca.colonna
                                            , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'COMP_TFR', nvl(vaca.valore,0)
                                              , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                        , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'QUOTA_L166', nvl(vaca.valore,0)
                                                , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_L166', nvl(vaca.valore,0)
                                                , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'COMP_PREMIO', nvl(vaca.valore,0)
                                                 , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                           , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_L135', nvl(vaca.valore,0)
                                                , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                          , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_PENS_SOSPESI', nvl(vaca.valore,0)
                                                        , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'CONTR_PREV_SOSPESI', nvl(vaca.valore,0)
                                                        , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                                  , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'SANZIONE_PENS', nvl(vaca.valore,0)
                                                   , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                       )  * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'SANZIONE_PREV', nvl(vaca.valore,0)
                                                   , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'SANZIONE_CRED', nvl(vaca.valore,0)
                                                   , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                             , '')),1)
                , round(sum(decode( vaca.colonna
                                  , 'SANZIONE_ENPDEDP', nvl(vaca.valore,0)
                                                      , 0 )
                            )
                            / nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                                , '')),1)
                       )   * nvl(max(distinct decode( vaca.colonna
                                            , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                                , '')),1)
                , decode( D_rilevanza, 'E0', null, to_char(max(distinct vaca.riferimento),'yyyy'))
           into I_comp_fisse,I_comp_acc,I_comp_18,I_ind_non_a,I_iis_congl,I_ipn_pens,
                I_contr_pens,I_contr_agg,I_ipn_tfs,I_contr_tfs,I_ipn_tfr,I_contr_tfr,
                I_ipn_cassa_cr,I_con_cassa_cr,I_con_enpdedp,I_tredicesima,I_teorico_tfr,
                I_comp_tfr,I_quota_l166,I_contr_l166,I_comp_premio,I_contr_l135,
                I_contr_pens_s,I_contr_prev_s,I_sanz_pens,I_sanz_prev,I_sanz_cred,I_sanz_enpdedp
              , I_rif
           from valori_contabili_annuali    vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esvc.dal              <= nvl(CUR_CI.al,to_date('3333333','j'))
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= CUR_CI.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno_moco
            and vaca.mese              = D_mese_moco
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = D_mese_moco
                                             and tipo in ('A','N','S'))
            and vaca.mensilita        != '*AP'
            and vaca.moco_mese         = D_mese_moco
            and vaca.estrazione        = 'DENUNCIA_DMA'
            and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_18','IND_NON_A','IIS_CONGLOBATA'
                                         ,'IPN_PENS','CONTR_PENS','CONTR_AGG','IPN_TFS'
                                         ,'CONTR_TFS','IPN_TFR','CONTR_TFR','IPN_CASSA_CREDITO'
                                         ,'CONTR_CASSA_CREDITO','CONTR_ENPDEDP','TREDICESIMA'
                                         ,'TEORICO_TFR','COMP_TFR','QUOTA_L166','CONTR_L166'
                                         ,'COMP_PREMIO','CONTR_L135','CONTR_PENS_SOSPESI'
                                         ,'CONTR_PREV_SOSPESI','SANZIONE_PENS','SANZIONE_PREV'
                                         ,'SANZIONE_CRED','SANZIONE_ENPDEDP'   )
            and vaca.ci                = CUR_CI.ci
            and vaca.riferimento between CUR_CI.dal
                                     and CUR_CI.al
--            and nvl(vaca.competenza,vaca.riferimento) = vaca.riferimento
          ;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
         I_comp_fisse        := to_number(null);
         I_comp_acc          := to_number(null);
         I_comp_18           := to_number(null);
         I_ind_non_a         := to_number(null);
         I_iis_congl         := to_number(null);
         I_ipn_pens          := to_number(null);
         I_contr_pens        := to_number(null);
         I_contr_agg         := to_number(null);
         I_ipn_tfs           := to_number(null);
         I_contr_tfs         := to_number(null);
         I_ipn_tfr           := to_number(null);
         I_contr_tfr         := to_number(null);
         I_ipn_cassa_cr      := to_number(null);
         I_con_cassa_cr      := to_number(null);
         I_con_enpdedp       := to_number(null);
         I_tredicesima       := to_number(null);
         I_teorico_tfr       := to_number(null);
         I_comp_tfr          := to_number(null);
         I_quota_l166        := to_number(null);
         I_contr_l166        := to_number(null);
         I_comp_premio       := to_number(null);
         I_contr_l135        := to_number(null);
         I_contr_pens_s      := to_number(null);
         I_contr_prev_s      := to_number(null);
         I_sanz_pens         := to_number(null);
         I_sanz_prev         := to_number(null);
         I_sanz_cred         := to_number(null);
         I_sanz_enpdedp      := to_number(null);
         I_rif               := null;
    END;
    BEGIN
    -- insert into DENUNCIA_DMA --
    insert into DENUNCIA_DMA
    ( ddma_id, anno, mese, previdenza, gestione, fine_servizio
    , cassa_pensione, cassa_credito, cassa_enpdedp
    , ci, codice, posizione, qualifica, rilevanza, competenza, causale_variazione
    , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
    , tipo_part_time, perc_part_time, gg_utili, ore_ridotte, perc_l300, riferimento, tipo_aliquota
    , comp_fisse, comp_accessorie, magg_l165, comp_18, ind_non_a, iis_conglobata, ipn_pens_periodo
    , contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
    , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr,contr_ult_ipn_tfr,  ipn_cassa_credito, contr_cassa_credito
    , contr_enpdedp, tredicesima, retr_teorico_tfr, retr_utile_tfr, quota_solidarieta_l166
    , contr_solidarieta_l166, retr_l135, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
    , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp, utente, tipo_agg, data_agg
    )
    select
     ddma_sq.nextval, D_anno, D_mese, nvl(I_previdenza, 'CPDEL'), CUR_CI.gestione, I_fine_servizio
   , I_pensione, DECODE(I_previdenza, NULL, NULL, '9'), I_enpdep
   , CUR_CI.ci, I_codice, I_posizione, D_qualifica, D_rilevanza, 'C', decode(D_rilevanza,'E0',null,'1')
   , CUR_CI.dal, CUR_CI.al, I_data_ces, I_causa_ces, CUR_CI.impiego, nvl(I_servizio,CUR_CI.servizio)
   , I_tipo_part_time, I_perc_part_time, I_gg_utili, decode(CUR_CI.impiego,9,CUR_CI.ore,null), I_perc_l300
   , decode(D_rilevanza,'E0', null, nvl(I_rif,to_char(cur_ci.dal,'yyyy'))), 1
   , decode(nvl(instr(I_pensione,'1'),0),0,nvl(I_comp_fisse,0),nvl(I_comp_fisse,0) - nvl(I_tredicesima,0))
   , I_comp_acc, null, decode(nvl(instr(I_pensione,'1'),0),0,0 ,I_comp_18)
   , I_ind_non_a, decode(nvl(instr(I_pensione,'1'),0),0,0 ,nvl(I_iis_congl,0))
   , I_ipn_pens, I_contr_pens, I_contr_agg,  I_ipn_tfs, I_contr_tfs, I_ipn_tfr, I_contr_tfr,null, null
   , I_ipn_cassa_cr, I_con_cassa_cr, I_con_enpdedp, decode(nvl(instr(I_pensione,'1'),0),0,0 ,nvl(I_tredicesima,0))
   , I_teorico_tfr,  I_comp_tfr, I_quota_l166, I_contr_l166, I_comp_premio, I_contr_l135, I_contr_pens_s
   , I_contr_prev_s, I_sanz_pens, I_sanz_prev, I_sanz_cred, I_sanz_enpdedp, D_utente, null, sysdate
    from dual;
END;
       elsif nvl(P_aliquota,' ') = 'X' THEN
       BEGIN
-- Estrazione dati economici arretrati --
       V_insert   := null;
       I_aliquota := null;
       FOR CUR_ARR2 IN CURSORE_DMA.ARR_DMA2 (CUR_CI.ci, D_anno_moco, D_mese_moco,  D_anno, D_mese, CUR_CI.DAL, CUR_CI.AL)
       LOOP
       I_aliquota := null;
       BEGIN
         BEGIN
           select decode(cur_arr2.I_anno_comp,cur_arr2.I_anno_rif,'1','2')
             into   I_aliquota
             from   dual;
         END;
       BEGIN
           insert into DENUNCIA_DMA
           ( ddma_id, anno, mese, previdenza, gestione, fine_servizio
           , cassa_pensione, cassa_credito, cassa_enpdedp
           , ci, codice, posizione, qualifica, rilevanza, competenza, causale_variazione
           , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
           , tipo_part_time, perc_part_time, gg_utili, ore_ridotte, perc_l300, riferimento, tipo_aliquota
           , comp_fisse, comp_accessorie, magg_l165, comp_18, ind_non_a, iis_conglobata
           , ipn_pens_periodo, contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
           , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr, contr_ult_ipn_tfr
           , ipn_cassa_credito, contr_cassa_credito, contr_enpdedp
           , tredicesima, retr_teorico_tfr, retr_utile_tfr, quota_solidarieta_l166, contr_solidarieta_l166
           , retr_l135, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
           , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp
           , utente, tipo_agg, data_agg
           )
        select
           ddma_sq.nextval, D_anno, D_mese, nvl(I_previdenza, 'CPDEL'), CUR_CI.gestione , I_fine_servizio
         , I_pensione, DECODE(I_previdenza, NULL, NULL, '9'), I_enpdep
         , CUR_CI.ci, I_codice, I_posizione, D_qualifica, D_rilevanza, 'C', decode(D_rilevanza,'E0',null,'1')
         , CUR_CI.dal, CUR_CI.al, I_data_ces, I_causa_ces, CUR_CI.impiego, nvl(I_servizio,CUR_CI.servizio)
         , I_tipo_part_time, I_perc_part_time, I_gg_utili,decode(CUR_CI.impiego,9,CUR_CI.ore,null), I_perc_l300, cur_arr2.I_anno_rif, I_aliquota
         , decode(nvl(instr(I_pensione,'1'),0) ,0,nvl(cur_arr2.I_comp_fisse,0)
                                          ,nvl(cur_arr2.I_comp_fisse,0) - nvl(cur_arr2.I_tredicesima,0))
         , cur_arr2.I_comp_acc, null, decode(nvl(instr(I_pensione,'1'),0),0,0,cur_arr2.I_comp_18)
         , cur_arr2.I_ind_non_a, decode(nvl(instr(I_pensione,'1'),0),0,0,nvl(cur_arr2.I_iis_congl,0))
         , cur_arr2.I_ipn_pens, cur_arr2.I_contr_pens, cur_arr2.I_contr_agg, cur_arr2.I_ipn_tfs
         , cur_arr2.I_contr_tfs, cur_arr2.I_ipn_tfr, cur_arr2.I_contr_tfr, null, null
         , cur_arr2.I_ipn_cassa_cr, cur_arr2.I_con_cassa_cr, cur_arr2.I_con_enpdedp
         , decode(nvl(instr(I_pensione,'1'),0),0,0,nvl(cur_arr2.I_tredicesima,0))
         , cur_arr2.I_teorico_tfr, cur_arr2.I_comp_tfr, cur_arr2.I_quota_l166, cur_arr2.I_contr_l166, cur_arr2.I_comp_premio
         , cur_arr2.I_contr_l135, cur_arr2.I_contr_pens_s, cur_arr2.I_contr_prev_s
         , cur_arr2.I_sanz_pens, cur_arr2.I_sanz_prev, cur_arr2.I_sanz_cred, cur_arr2.I_sanz_enpdedp
         , D_utente, null, sysdate
      from dual;
      V_insert := 'X';
    END;
    END;
    commit;
    END LOOP; -- cur_arr2
-- Questa insert serve per non perdere il periodo se non ci sono voci con il riferimento compreso nel dal/al;
-- il periodo inserito senza import potrebbe poi essere completato dal riblatamento della competenza P, oppure dalla
-- unificazione con altri periodi
    IF V_insert is null THEN
           insert into DENUNCIA_DMA
           ( ddma_id, anno, mese, previdenza, gestione, fine_servizio
           , cassa_pensione, cassa_credito, cassa_enpdedp
           , ci, codice, posizione, qualifica, rilevanza, competenza, causale_variazione
           , tipo_aliquota
           , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
           , tipo_part_time, perc_part_time, gg_utili, ore_ridotte, perc_l300,riferimento
           , utente, tipo_agg, data_agg
           )
        select
           ddma_sq.nextval, D_anno, D_mese, nvl(I_previdenza, 'CPDEL'), CUR_CI.gestione , I_fine_servizio
         , I_pensione, DECODE(I_previdenza, NULL, NULL, '9'), I_enpdep
         , CUR_CI.ci, I_codice, I_posizione, D_qualifica, D_rilevanza, 'C', decode(D_rilevanza,'E0',null,'1')
         , nvl(I_aliquota,1)
         , CUR_CI.dal, CUR_CI.al, I_data_ces, I_causa_ces, CUR_CI.impiego, nvl(I_servizio,CUR_CI.servizio)
         , I_tipo_part_time, I_perc_part_time, I_gg_utili,decode(CUR_CI.impiego,9,CUR_CI.ore,null), I_perc_l300
         , to_char(CUR_CI.dal,'yyyy'), D_utente, null, sysdate
      from dual;
    END IF;
    END;
       ELSE
       BEGIN
-- Estrazione dati economici arretrati --
       V_insert := null;
       FOR CUR_ARR IN CURSORE_DMA.ARR_DMA (CUR_CI.ci, D_anno_moco, D_mese_moco,  D_anno, D_mese, P_cassa, CUR_CI.DAL, CUR_CI.AL)
       LOOP
       BEGIN
    BEGIN
     select decode(cur_arr.I_anno_comp,cur_arr.I_anno_rif,'1','2')
     into   I_aliquota
     from   dual;
    END;
    BEGIN
           insert into DENUNCIA_DMA
           ( ddma_id, anno, mese, previdenza, gestione, fine_servizio
           , cassa_pensione, cassa_credito, cassa_enpdedp
           , ci, codice, posizione, qualifica, rilevanza, competenza, causale_variazione
           , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
           , tipo_part_time, perc_part_time, gg_utili, ore_ridotte, perc_l300, riferimento, tipo_aliquota
           , comp_fisse, comp_accessorie, magg_l165, comp_18, ind_non_a, iis_conglobata
           , ipn_pens_periodo, contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
           , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr, contr_ult_ipn_tfr
           , ipn_cassa_credito, contr_cassa_credito, contr_enpdedp
           , tredicesima, retr_teorico_tfr, retr_utile_tfr, quota_solidarieta_l166, contr_solidarieta_l166
           , retr_l135, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
           , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp
           , utente, tipo_agg, data_agg
           )
        select
           ddma_sq.nextval, D_anno, D_mese, nvl(I_previdenza, 'CPDEL'), CUR_CI.gestione , I_fine_servizio
         , I_pensione, DECODE(I_previdenza, NULL, NULL, '9'), I_enpdep
         , CUR_CI.ci, I_codice, I_posizione, D_qualifica, D_rilevanza, 'C', decode(D_rilevanza,'E0',null,'1')
         , CUR_CI.dal, CUR_CI.al, I_data_ces, I_causa_ces, CUR_CI.impiego, nvl(I_servizio,CUR_CI.servizio)
         , I_tipo_part_time, I_perc_part_time, I_gg_utili,decode(CUR_CI.impiego,9,CUR_CI.ore,null), I_perc_l300, cur_arr.I_anno_rif, I_aliquota
         , decode(nvl(instr(I_pensione,'1'),0) ,0,nvl(CUR_ARR.I_comp_fisse,0)
                                          ,nvl(CUR_ARR.I_comp_fisse,0) - nvl(cur_arr.I_tredicesima,0))
         , cur_arr.I_comp_acc, null, decode(nvl(instr(I_pensione,'1'),0),0,0,cur_arr.I_comp_18)
         , cur_arr.I_ind_non_a, decode(nvl(instr(I_pensione,'1'),0),0,0,nvl(cur_arr.I_iis_congl,0))
         , cur_arr.I_ipn_pens, cur_arr.I_contr_pens, cur_arr.I_contr_agg, cur_arr.I_ipn_tfs
         , cur_arr.I_contr_tfs, cur_arr.I_ipn_tfr, cur_arr.I_contr_tfr, null, null
         , cur_arr.I_ipn_cassa_cr, cur_arr.I_con_cassa_cr, cur_arr.I_con_enpdedp
         , decode(nvl(instr(I_pensione,'1'),0),0,0,nvl(CUR_ARR.I_tredicesima,0))
         , cur_arr.I_teorico_tfr, cur_arr.I_comp_tfr, cur_arr.I_quota_l166, cur_arr.I_contr_l166, cur_arr.I_comp_premio
         , cur_arr.I_contr_l135, cur_arr.I_contr_pens_s, cur_arr.I_contr_prev_s
         , cur_arr.I_sanz_pens, cur_arr.I_sanz_prev, cur_arr.I_sanz_cred, cur_arr.I_sanz_enpdedp
         , D_utente, null, sysdate
      from dual;
      V_insert := 'X';
    END;
    END;
    commit;
    END LOOP; -- cur_arr
-- Questa insert serve per non perdere il periodo se non ci sono voci con il riferimento compreso nel dal/al;
-- il periodo inserito senza import potrebbe poi essere completato dal riblatamento della competenza P, oppure dalla
-- unificazione con altri periodi
    IF V_insert is null THEN
           insert into DENUNCIA_DMA
           ( ddma_id, anno, mese, previdenza, gestione, fine_servizio
           , cassa_pensione, cassa_credito, cassa_enpdedp
           , ci, codice, posizione, qualifica, rilevanza, competenza, causale_variazione
           , tipo_aliquota
           , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
           , tipo_part_time, perc_part_time, gg_utili, ore_ridotte, perc_l300,riferimento
           , utente, tipo_agg, data_agg
           )
        select
           ddma_sq.nextval, D_anno, D_mese, nvl(I_previdenza, 'CPDEL'), CUR_CI.gestione , I_fine_servizio
         , I_pensione, DECODE(I_previdenza, NULL, NULL, '9'), I_enpdep
         , CUR_CI.ci, I_codice, I_posizione, D_qualifica, D_rilevanza, 'C', decode(D_rilevanza,'E0',null,'1')
         , nvl(I_aliquota,1)
         , CUR_CI.dal, CUR_CI.al, I_data_ces, I_causa_ces, CUR_CI.impiego, nvl(I_servizio,CUR_CI.servizio)
         , I_tipo_part_time, I_perc_part_time, I_gg_utili,decode(CUR_CI.impiego,9,CUR_CI.ore,null), I_perc_l300
         , to_char(CUR_CI.dal,'yyyy'), D_utente, null, sysdate
      from dual;
    END IF;
    END;
    end if;
    END;
    commit;
exception when no_elab then null;
end;
end loop; -- cur_ci
BEGIN
  FOR CUR_P in
     (select dal
           , al
           , cassa_pensione,cassa_previdenza,cassa_enpdedp,cassa_credito
           , tipo_aliquota
           , ddma_id
           , comp_fisse
           , comp_accessorie
           , comp_18
           , ind_non_a
           , iis_conglobata
           , ipn_pens_periodo
           , contr_pens_periodo
           , contr_su_eccedenza
           , ipn_tfs
           , contr_tfs
           , ipn_tfr
           , contr_ipn_tfr
           , ipn_cassa_credito
           , contr_cassa_credito
           , contr_enpdedp
           , tredicesima
           , retr_teorico_tfr
           , retr_utile_tfr
           , quota_solidarieta_l166
           , contr_solidarieta_l166
           , retr_l135
           , contr_solidarieta_l135
           , contr_pens_calamita
           , contr_prev_calamita
           , sanzione_pensione
           , sanzione_previdenza
           , sanzione_credito
           , sanzione_enpdedp
       from denuncia_dma
      where anno   = D_anno
        and mese   = D_mese
        and ci     = CUR1.ci
        and competenza = 'P'
      order by 1
      ) loop
    BEGIN
-- dbms_output.put_line('CUR.P.: '||to_char(cur_p.dal,'dd/mm/yyyy')||' - '||to_char(cur_P.al,'dd/mm/yyyy')||' cassa '||
-- CUR_P.cassa_pensione||' imp. '||to_char(CUR_P.ipn_pens_periodo));
    update denuncia_dma ddma
       set cassa_pensione         = nvl(ddma.cassa_pensione,CUR_P.cassa_pensione)
         , cassa_previdenza       = nvl(ddma.cassa_previdenza,CUR_P.cassa_previdenza)
         , cassa_enpdedp          = nvl(ddma.cassa_enpdedp,CUR_P.cassa_enpdedp)
         , cassa_credito          = nvl(ddma.cassa_credito,CUR_P.cassa_credito)
         , comp_fisse             = nvl(ddma.comp_fisse,0)      + nvl(CUR_P.comp_fisse,0) * -1
         , comp_accessorie        = nvl(ddma.comp_accessorie,0) + nvl(CUR_P.comp_accessorie,0) * -1
         , comp_18                = nvl(ddma.comp_18,0)         + nvl(CUR_P.comp_18,0) * -1
         , ind_non_a              = nvl(ddma.ind_non_a,0)       + nvl(CUR_P.ind_non_a,0) * -1
         , iis_conglobata         = nvl(ddma.iis_conglobata,0)  + nvl(CUR_P.iis_conglobata,0) * -1
         , ipn_pens_periodo       = nvl(ddma.ipn_pens_periodo,0) + nvl(CUR_P.ipn_pens_periodo,0) * -1
         , contr_pens_periodo     = nvl(ddma.contr_pens_periodo,0) + nvl(CUR_P.contr_pens_periodo,0) * -1
         , contr_su_eccedenza     = nvl(ddma.contr_su_eccedenza,0) + nvl(CUR_P.contr_su_eccedenza,0) * -1
         , ipn_tfs                = nvl(ddma.ipn_tfs,0)            + nvl(CUR_P.ipn_tfs,0) * -1
         , contr_tfs              = nvl(ddma.contr_tfs,0)          + nvl(CUR_P.contr_tfs,0) * -1
         , ipn_tfr                = nvl(ddma.ipn_tfr,0)            + nvl(CUR_P.ipn_tfr,0) * -1
         , contr_ipn_tfr          = nvl(ddma.contr_ipn_tfr,0)      + nvl(CUR_P.contr_ipn_tfr,0) * -1
         , ipn_cassa_credito      = nvl(ddma.ipn_cassa_credito,0)  + nvl(CUR_P.ipn_cassa_credito,0) * -1
         , contr_cassa_credito    = nvl(ddma.contr_cassa_credito,0) + nvl(CUR_P.contr_cassa_credito,0) * -1
         , contr_enpdedp          = nvl(ddma.contr_enpdedp,0)       + nvl(CUR_P.contr_enpdedp,0) * -1
         , tredicesima            = nvl(ddma.tredicesima,0)         + nvl(CUR_P.tredicesima,0) * -1
         , retr_teorico_tfr       = nvl(ddma.retr_teorico_tfr,0)    + nvl(CUR_P.retr_teorico_tfr,0) * -1
         , retr_utile_tfr         = nvl(ddma.retr_utile_tfr,0)      + nvl(CUR_P.retr_utile_tfr,0) * -1
         , quota_solidarieta_l166 = nvl(ddma.quota_solidarieta_l166,0) + nvl(CUR_P.quota_solidarieta_l166,0) * -1
         , contr_solidarieta_l166 = nvl(ddma.contr_solidarieta_l166,0) + nvl(CUR_P.contr_solidarieta_l166,0) * -1
         , retr_l135              = nvl(ddma.retr_l135,0)              + nvl(CUR_P.retr_l135,0)* -1
         , contr_solidarieta_l135 = nvl(ddma.contr_solidarieta_l135,0) + nvl(CUR_P.contr_solidarieta_l135,0) * -1
         , contr_pens_calamita    = nvl(ddma.contr_pens_calamita,0)    + nvl(CUR_P.contr_pens_calamita,0) * -1
         , contr_prev_calamita    = nvl(ddma.contr_prev_calamita ,0)   + nvl(CUR_P.contr_prev_calamita ,0) * -1
         , sanzione_pensione      = nvl(ddma.sanzione_pensione ,0)     + nvl(CUR_P.sanzione_pensione ,0) * -1
         , sanzione_previdenza    = nvl(ddma.sanzione_previdenza,0)    + nvl(CUR_P.sanzione_previdenza,0) * -1
         , sanzione_credito       = nvl(ddma.sanzione_credito,0)       + nvl(CUR_P.sanzione_credito,0) * -1
         , sanzione_enpdedp       = nvl(ddma.sanzione_enpdedp ,0)      + nvl(CUR_P.sanzione_enpdedp ,0) * -1
     where anno = D_anno
       and mese = D_mese
       and ci   = CUR1.ci
       and competenza = 'C'
       and dal = (select max(dal) from denuncia_dma
                   where anno       = D_anno
                     and mese       = D_mese
                     and ci         = CUR1.ci
                     and competenza = 'C'
                     and to_char(al,'yyyymm') = to_char(CUR_P.al,'yyyymm')
                     and dal                 <= CUR_P.al
                     and tipo_aliquota        = CUR_P.tipo_aliquota
                 )
       and (    P_aliquota is null
            or (    P_aliquota is not null
                and ddma.tipo_aliquota        = CUR_P.tipo_aliquota)
           )
    ;
    IF not SQL%FOUND THEN
       IF cur_p.tipo_aliquota = '2' THEN
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
                 , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp, utente, tipo_agg, data_agg
                 )
               select
                   ddma_sq.nextval, D_anno, D_mese, previdenza, gestione, fine_servizio
                 , cassa_pensione, cassa_previdenza, cassa_credito, cassa_enpdedp
                 , ci, codice, posizione, qualifica, 'V1', 'C', '1'
                 , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
                 , tipo_part_time, perc_part_time, 0 gg_utili, ore_ridotte, perc_l300, riferimento, tipo_aliquota
                 , comp_fisse*-1, comp_accessorie*-1, magg_l165*-1, comp_18*-1, ind_non_a*-1, iis_conglobata*-1, ipn_pens_periodo*-1
                 , contr_pens_periodo*-1, contr_su_eccedenza*-1, ipn_tfs*-1, contr_tfs*-1
                 , ipn_tfr*-1, contr_ipn_tfr*-1, ult_ipn_tfr*-1, contr_ult_ipn_tfr*-1, ipn_cassa_credito*-1, contr_cassa_credito*-1
                 , contr_enpdedp*-1, tredicesima*-1, retr_teorico_tfr*-1, retr_utile_tfr*-1, quota_solidarieta_l166*-1
                 , contr_solidarieta_l166*-1, retr_l135*-1, contr_solidarieta_l135*-1, contr_pens_calamita*-1, contr_prev_calamita*-1
                 , sanzione_pensione*-1, sanzione_previdenza*-1, sanzione_credito*-1, sanzione_enpdedp*-1
                 , D_utente, null, sysdate
                from denuncia_dma ddma
               where ddma_id = cur_p.ddma_id;
       ELSE
          D_prg_err_5 := nvl(D_prg_err_5,0) + 1;
          INSERT INTO a_segnalazioni_errore
                ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT prenotazione
               , 1
               , D_prg_err_5
               , ' '
               , null
            FROM dual;
          D_prg_err_5 := nvl(D_prg_err_5,0) + 1;
          INSERT INTO a_segnalazioni_errore
                ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT prenotazione
               , 1
               , D_prg_err_5
               , 'P05496'
               ,  'Cod.Ind.: '||RPAD(TO_CHAR(CUR1.ci),8,' ')||'  '||
                  'Dal '||TO_CHAR(CUR_P.dal,'dd/mm/yyyy')||'  '||
                  'Al '||TO_CHAR(CUR_P.al,'dd/mm/yyyy')
            FROM dual;
        END IF;
     END IF;
     END;
  END LOOP;
END;
-- Trattamento Quote
BEGIN
  FOR CUR_RATE in
     (select moco.ci, moco.voce  voce,  moco.sub sub, to_char(moco.riferimento,'mmyyyy') riferimento
           , substr(esrc.colonna,1,1) cassa, abs(sum(nvl(imp,0))) somma
           , decode( sign(sum(moco.imp)) , -1, 'V', 'R') operazione
           , substr(esvc.note,1,2)  tipo_amm, inre.al scadenza
      from movimenti_contabili moco,
           informazioni_retributive inre,
           estrazione_righe_contabili esrc,
           estrazione_valori_contabili esvc
      where moco.voce       = esrc.voce
        and esvc.colonna    = esrc.colonna
        and esvc.dal        = esrc.dal
        and esvc.estrazione = esrc.estrazione
        and moco.sub        = esrc.sub
        and moco.anno       = D_anno_moco
        and moco.mese       = D_mese_moco
        and moco.mensilita not in ('*AP','*R*')
        and esvc.estrazione = 'CARTOLARIZZAZIONE'
        and esvc.colonna not in ('MD','PP')
        and inre.ci         = CUR1.ci
        and inre.ci         = moco.ci
        and inre.voce       = moco.voce
        and inre.sub        = moco.sub
        and moco.riferimento between nvl(inre.dal,to_date('2222222','j'))
                                 and nvl(inre.al,to_date('3333333','j'))
-- Trattaiamo le voci indicate in DESRE Anche se caricate da AINRI e non da AINRA
-- per queste voci (di AINRI) non si riesce ovviamente a controllare l'istituto
-- e la scadenza sara' esposta solo se indicata come data 'al' in AINRI
--        and inre.tipo       = 'R'
        and esvc.note is not null
        and (   instr(esvc.note,'<') = 0
           or inre.istituto = substr(esvc.note, instr(esvc.note,'<',  instr(esvc.note,istituto)-1) +1
                                              , instr(esvc.note,'>',  instr(esvc.note,istituto)) -1 - instr(esvc.note,'<',  instr(esvc.note,istituto)-1)
                                    )
          )
      group by moco.ci, moco.voce, moco.sub, to_char(moco.riferimento,'mmyyyy'),
               esrc.colonna, inre.al, substr(esvc.note,1,2)
     ) LOOP
     insert into denuncia_dma_quote
          ( ddmq_id , anno, mese, riferimento, gestione, ci, cassa, tipo_amm, scadenza, importo, operazione)
     select ddmq_sq.nextval, D_anno, D_mese, CUR_RATE.riferimento, CUR1.gestione
          , CUR1.ci, CUR_RATE.cassa, CUR_RATE.tipo_amm, CUR_RATE.scadenza, CUR_RATE.somma, CUR_RATE.operazione
       from dual;
    END LOOP; --cur_rate
end;
end loop; -- cur1
BEGIN
--
-- Nuovo cursore sui ci archiviati
--
FOR CUR_CI_DMA IN
   (select ci , max(gestione) gestione
      from denuncia_dma dma
     where anno    = D_anno
       and mese    = D_mese
       and gestione   like D_gestione
       and previdenza like D_previdenza
       and (         D_tipo = 'T'
             or (    D_tipo = 'S' and ci = D_ci)
             or (    D_tipo in ('I','V','P')
                 and not exists
                    (select 'x' from denuncia_dma
                      where anno              = D_anno
                        and mese              = D_mese
                        and gestione          = dma.gestione
                        and previdenza        = dma.previdenza
                        and ci                = dma.ci
                        and nvl(tipo_agg,' ') = decode(D_tipo,'P',tipo_agg,D_tipo)
                    )
                )
          )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci         = dma.ci
             and  rapporto        like D_rapporto
             and  nvl(gruppo,' ') like D_gruppo
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
   ) LOOP
     SIST_ASSICURAZIONI(cur_ci_dma.ci,D_anno,D_mese);
BEGIN
  FOR CUR_P_ASS in
     (select dal,al,ddma_id
       from denuncia_dma ddma
      where anno   = D_anno
        and mese   = D_mese
        and ci     = CUR_CI_DMA.ci
        and rilevanza  = 'V1'
        and competenza = 'C'
        and cassa_pensione   is null
        and cassa_previdenza is null
        and cassa_enpdedp    is null
        and cassa_credito    is null
        and nvl(comp_fisse,0) + nvl(comp_accessorie,0)  + nvl(magg_l165,0) + nvl(comp_18,0)
          + nvl(ind_non_a,0) + nvl(iis_conglobata,0) + nvl(ipn_pens_periodo,0) + nvl(contr_pens_periodo,0)
          + nvl(contr_su_eccedenza,0) + nvl(ipn_tfs,0) + nvl(contr_tfs,0) + nvl(ipn_tfr,0) + nvl(contr_ipn_tfr,0)
          + nvl(ult_ipn_tfr,0) + nvl(contr_ult_ipn_tfr,0) + nvl(ipn_cassa_credito,0) + nvl(contr_cassa_credito,0)
          + nvl(contr_enpdedp,0) + nvl(tredicesima,0)
          + nvl(quota_solidarieta_l166,0) + nvl(contr_solidarieta_l166,0) + nvl(retr_l135,0) + nvl(contr_solidarieta_l135,0)
          + nvl(contr_pens_calamita,0) + nvl(contr_prev_calamita,0) + nvl(sanzione_pensione,0) + nvl(sanzione_previdenza,0)
          + nvl(sanzione_credito,0) + nvl(sanzione_enpdedp,0) = 0
        and exists
           (select 'x' from denuncia_dma
             where anno      = D_anno
               and mese      = D_mese
               and ci        = CUR_CI_DMA.ci
               and rilevanza  = 'V1'
               and competenza = 'P'
               and ddma.al between dal and al
               and (   cassa_pensione   is not null
                    or cassa_previdenza is not null
                    or cassa_enpdedp    is not null
                    or cassa_credito    is not null)
               and nvl(comp_fisse,0) + nvl(comp_accessorie,0)  + nvl(magg_l165,0) + nvl(comp_18,0)
                 + nvl(ind_non_a,0) + nvl(iis_conglobata,0) + nvl(ipn_pens_periodo,0) + nvl(contr_pens_periodo,0)
                 + nvl(contr_su_eccedenza,0) + nvl(ipn_tfs,0) + nvl(contr_tfs,0) + nvl(ipn_tfr,0) + nvl(contr_ipn_tfr,0)
                 + nvl(ult_ipn_tfr,0) + nvl(contr_ult_ipn_tfr,0) + nvl(ipn_cassa_credito,0) + nvl(contr_cassa_credito,0)
                 + nvl(contr_enpdedp,0) + nvl(tredicesima,0)
                 + nvl(quota_solidarieta_l166,0) + nvl(contr_solidarieta_l166,0) + nvl(retr_l135,0) + nvl(contr_solidarieta_l135,0)
                 + nvl(contr_pens_calamita,0) + nvl(contr_prev_calamita,0) + nvl(sanzione_pensione,0) + nvl(sanzione_previdenza,0)
                 + nvl(sanzione_credito,0) + nvl(sanzione_enpdedp,0) != 0)
     ) LOOP
-- dbms_output.put_line('CUR.P.ASS.: '||to_char(cur_p_ass.dal,'dd/mm/yyyy')||' - '||to_char(cur_P_ass.al,'dd/mm/yyyy'));
    BEGIN
    update denuncia_dma ddma
       set ( cassa_pensione
           , cassa_previdenza
           , cassa_enpdedp
           , cassa_credito) = ( select cassa_pensione,cassa_previdenza,cassa_enpdedp,cassa_credito
                                  from denuncia_dma
                                 where anno      = D_anno
                                   and mese      = D_mese
                                   and ci        = CUR_CI_DMA.ci
                                   and rilevanza  = 'V1'
                                   and competenza = 'P'
                                   and tipo_aliquota = ddma.tipo_aliquota
                                   and ddma.al between dal and al
                                   and (   cassa_pensione   is not null
                                        or cassa_previdenza is not null
                                        or cassa_enpdedp    is not null
                                        or cassa_credito    is not null)
                                   and nvl(comp_fisse,0) + nvl(comp_accessorie,0)  + nvl(magg_l165,0) + nvl(comp_18,0)
                                     + nvl(ind_non_a,0) + nvl(iis_conglobata,0) + nvl(ipn_pens_periodo,0) + nvl(contr_pens_periodo,0)
                                     + nvl(contr_su_eccedenza,0) + nvl(ipn_tfs,0) + nvl(contr_tfs,0) + nvl(ipn_tfr,0) + nvl(contr_ipn_tfr,0)
                                     + nvl(ult_ipn_tfr,0) + nvl(contr_ult_ipn_tfr,0) + nvl(ipn_cassa_credito,0) + nvl(contr_cassa_credito,0)
                                     + nvl(contr_enpdedp,0) + nvl(tredicesima,0)
                                     + nvl(quota_solidarieta_l166,0) + nvl(contr_solidarieta_l166,0) + nvl(retr_l135,0) + nvl(contr_solidarieta_l135,0)
                                     + nvl(contr_pens_calamita,0) + nvl(contr_prev_calamita,0) + nvl(sanzione_pensione,0) + nvl(sanzione_previdenza,0)
                                     + nvl(sanzione_credito,0) + nvl(sanzione_enpdedp,0) != 0)
     where ddma_id = CUR_P_ASS.ddma_id
    ;
    END;
  END LOOP;
END;
    BEGIN
--
-- UNIFICA I PERIODI
--
DU_conta		:= 0;
DU_rilevanza		:= null;
DU_ddma_id              := null;
DU_competenza           := null;
DU_previdenza		:= null;
DU_gestione		:= null;
DU_cassa_pensione	:= null;
DU_cassa_previdenza	:= null;
DU_cassa_credito	:= null;
DU_cassa_enpdedp	:= null;
DU_qualifica		:= null;
DU_causa_cessazione	:= null;
DU_tipo_impiego		:= null;
DU_tipo_servizio	:= null;
DU_perc_part_time	:= to_number(null);
DU_ore_ridotte    := to_number(null);
DU_dal		:= to_date(null);
DU_al			:= to_date(null);
DU_tipo_aliquota	:= null;
    FOR CUR_UNIFICA IN
       (SELECT ddma.dal, ddma.al, ddma.ci, ddma.rilevanza
             , ddma.competenza, ddma.previdenza, ddma.tipo_aliquota
             , ddma.gestione
             , ddma.cassa_pensione, ddma.cassa_previdenza, ddma.cassa_credito
             , ddma.cassa_enpdedp, ddma.qualifica, ddma.causa_cessazione, ddma.tipo_impiego
             , ddma.tipo_servizio, ddma.perc_part_time, ddma.ore_ridotte
             , ddma.ddma_id
         FROM DENUNCIA_DMA DDMA
        WHERE ddma.anno = D_anno
          and ddma.mese = D_mese
          and ddma.ci = cur_ci_dma.ci
-- potrei escludere dal loop le comp. 'P'? derivando da un'archiviazione precedente dovrebbero
-- gia essere "unificate" (Annalena)
          and nvl(competenza,'C') != 'P'
        union
        select to_date('3333333','j') dal, to_date(null) al, cur_ci_dma.ci, '' rilevanza
             , '' competenza, '' previdenza, to_number('') tipo_aliquota
             , '' gestione
             , '' cassa_pensione, '' cassa_previdenza, '' cassa_credito
             , '' cassa_enpdedp, '' qualifica, '' causa_cessazione, '' tipo_impiego
             , '' tipo_servizio, to_number('') perc_part_time, to_number('')  ore_ridotte
             , 0 ddma_id
          from dual
        order by 1, 4, 2
       ) LOOP
-- dbms_output.put_Line('cursore unifica dal '||CUR_UNIFICA.dal);
	DU_conta := DU_conta + 1;
	IF DU_conta = 1 THEN
		   -- memorizzo i dati
               DU_ddma_id          := CUR_UNIFICA.ddma_id;
               DU_rilevanza        := CUR_UNIFICA.rilevanza;
               DU_competenza       := CUR_UNIFICA.competenza;
               DU_previdenza       := CUR_UNIFICA.previdenza;
               DU_gestione         := CUR_UNIFICA.gestione;
               DU_tipo_aliquota    := CUR_UNIFICA.tipo_aliquota;
               DU_cassa_pensione   := CUR_UNIFICA.cassa_pensione;
               DU_cassa_previdenza := CUR_UNIFICA.cassa_previdenza;
               DU_cassa_credito    := CUR_UNIFICA.cassa_credito;
               DU_cassa_enpdedp    := CUR_UNIFICA.cassa_enpdedp;
               DU_qualifica        := CUR_UNIFICA.qualifica;
               DU_causa_cessazione := CUR_UNIFICA.causa_cessazione;
               DU_tipo_impiego     := CUR_UNIFICA.tipo_impiego;
               DU_tipo_servizio    := CUR_UNIFICA.tipo_servizio;
               DU_perc_part_time   := CUR_UNIFICA.perc_part_time;
               DU_ore_ridotte      := CUR_UNIFICA.ore_ridotte;
               DU_dal              := CUR_UNIFICA.dal;
               DU_al               := CUR_UNIFICA.al;
            ELSIF -- confronto i dati memorizzati
                  DU_rilevanza                 = CUR_UNIFICA.rilevanza
              AND nvl(DU_competenza,'C')       = nvl(CUR_UNIFICA.competenza,'C')
              AND DU_previdenza                = CUR_UNIFICA.previdenza
              AND nvl(DU_gestione,' ')         = nvl(CUR_UNIFICA.gestione,' ')
              AND nvl(DU_tipo_aliquota,1)      = nvl(CUR_UNIFICA.tipo_aliquota,1)
              AND nvl(DU_cassa_pensione,' ')   = nvl(CUR_UNIFICA.cassa_pensione,' ')
              AND nvl(DU_cassa_previdenza,' ') = nvl(CUR_UNIFICA.cassa_previdenza,' ')
              AND nvl(DU_cassa_credito,' ')    = nvl(CUR_UNIFICA.cassa_credito,' ')
              AND nvl(DU_cassa_enpdedp,' ')    = nvl(CUR_UNIFICA.cassa_enpdedp,' ')
              AND nvl(DU_qualifica,' ')        = nvl(CUR_UNIFICA.qualifica,' ')
              AND nvl(DU_causa_cessazione,' ') = nvl(CUR_UNIFICA.causa_cessazione,' ')
              AND nvl(DU_tipo_impiego,' ')     = nvl(CUR_UNIFICA.tipo_impiego,' ')
              AND nvl(DU_tipo_servizio,' ')    = nvl(CUR_UNIFICA.tipo_servizio,' ')
              AND nvl(DU_perc_part_time,0)     = nvl(CUR_UNIFICA.perc_part_time,0)
              AND nvl(DU_ore_ridotte,0)        = nvl(CUR_UNIFICA.ore_ridotte,0)
              AND to_char(DU_dal,'mmyyyy')     = to_char(CUR_UNIFICA.dal,'mmyyyy')
              AND (   DU_al + 1                = CUR_UNIFICA.dal
                   or DU_dal                   = CUR_UNIFICA.dal
                   or DU_al                    = CUR_UNIFICA.al
                  )
            THEN
-- dbms_output.put_Line('sono uguali: DU_al '||DU_al||' CUR_UNIFICA.al '||CUR_UNIFICA.al);
               DU_al := CUR_UNIFICA.al;
            ELSE
-- dbms_output.put_Line('sono diversi: DU_dal '||DU_dal||' DU_al '||DU_al||' CUR_UNIFICA.al '||CUR_UNIFICA.al);
-- dbms_output.put_Line('mem '||DU_gestione||' '||DU_previdenza||' '||DU_rilevanza||' '||
--                             DU_tipo_aliquota||' '||nvl(DU_competenza,'C'));
         update denuncia_dma ddma
            set ( al, gg_utili, comp_fisse, comp_accessorie, magg_l165
                , comp_18, ind_non_a, iis_conglobata, ipn_pens_periodo
                , contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
                , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr, contr_ult_ipn_tfr
                , ipn_cassa_credito, contr_cassa_credito, contr_enpdedp
                , tredicesima, retr_teorico_tfr, retr_utile_tfr
                , quota_solidarieta_l166, contr_solidarieta_l166
                , retr_l135, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
                , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp
                )  =
          (select DU_al
                , decode( ddma.perc_part_time
                        , null, decode(to_char(ddma.dal,'ddmmyyyy')
                                      ,'01'||to_char(ddma.dal,'mmyyy'),decode(to_char(DU_al,'ddmmyyyy'),
                                             to_char(last_day(DU_al),'ddmmyyyy'),30,DU_al-ddma.dal+1),
                                          decode(to_char(DU_al,'ddmmyyyy'),
                                                 to_char(last_day(DU_al),'ddmmyyyy'),greatest(0,30-to_char(ddma.dal,'dd'))+1,
                                                                        DU_al-ddma.dal+1
                                      ) )
                              , null)
                , sum(comp_fisse), sum(comp_accessorie), sum(magg_l165)
                , sum(comp_18), sum(ind_non_a), sum(iis_conglobata), sum(ipn_pens_periodo)
                , sum(contr_pens_periodo), sum(contr_su_eccedenza), sum(ipn_tfs), sum(contr_tfs)
                , sum(ipn_tfr), sum(contr_ipn_tfr), sum(ult_ipn_tfr), sum(contr_ult_ipn_tfr)
                , sum(ipn_cassa_credito), sum(contr_cassa_credito), sum(contr_enpdedp)
                , sum(tredicesima), sum(retr_teorico_tfr), sum(retr_utile_tfr)
                , sum(quota_solidarieta_l166), sum(contr_solidarieta_l166)
                , sum(retr_l135), sum(contr_solidarieta_l135), sum(contr_pens_calamita), sum(contr_prev_calamita)
                , sum(sanzione_pensione), sum(sanzione_previdenza), sum(sanzione_credito), sum(sanzione_enpdedp)
            from denuncia_dma
           where anno                = D_anno
             and mese                = D_mese
             and ci                  = cur_unifica.ci
             and gestione            = DU_gestione
             and previdenza          = DU_previdenza
             and rilevanza           = DU_rilevanza
             and tipo_aliquota       = DU_tipo_aliquota
             and nvl(competenza,'C') = nvl(DU_competenza,'C')
             and dal                >= DU_dal
             and al                 <= DU_al
           )
          where anno                = D_anno
            and mese                = D_mese
            and ci                  = cur_unifica.ci
            and gestione            = DU_gestione
            and previdenza          = DU_previdenza
            and rilevanza           = DU_rilevanza
            and tipo_aliquota       = DU_tipo_aliquota
            and nvl(competenza,'C') = nvl(DU_competenza,'C')
            and dal                 = DU_dal
            and ddma_id             = DU_ddma_id
         ;
         delete denuncia_dma
          where anno                = D_anno
            and mese                = D_mese
            and ci                  = cur_unifica.ci
            and gestione            = DU_gestione
            and previdenza          = DU_previdenza
            and rilevanza           = DU_rilevanza
            and tipo_aliquota       = DU_tipo_aliquota
            and nvl(competenza,'C') = nvl(DU_competenza,'C')
            and dal                >= DU_dal
            and al                 <= DU_al
            and ddma_id            != DU_ddma_id
          ;
            -- Ri-memorizzo i dati
	   DU_ddma_id          := CUR_UNIFICA.ddma_id;
	   DU_rilevanza        := CUR_UNIFICA.rilevanza;
	   DU_competenza       := CUR_UNIFICA.competenza;
           DU_previdenza       := CUR_UNIFICA.previdenza;
           DU_gestione         := CUR_UNIFICA.gestione;
           DU_tipo_aliquota    := CUR_UNIFICA.tipo_aliquota;
           DU_cassa_pensione   := CUR_UNIFICA.cassa_pensione;
           DU_cassa_previdenza := CUR_UNIFICA.cassa_previdenza;
           DU_cassa_credito    := CUR_UNIFICA.cassa_credito;
           DU_cassa_enpdedp    := CUR_UNIFICA.cassa_enpdedp;
           DU_qualifica        := CUR_UNIFICA.qualifica;
           DU_causa_cessazione := CUR_UNIFICA.causa_cessazione;
           DU_tipo_impiego     := CUR_UNIFICA.tipo_impiego;
           DU_tipo_servizio    := CUR_UNIFICA.tipo_servizio;
           DU_perc_part_time   := CUR_UNIFICA.perc_part_time;
           DU_ore_ridotte      := CUR_UNIFICA.ore_ridotte;
           DU_dal              := CUR_UNIFICA.dal;
           DU_al               := CUR_UNIFICA.al;
          END IF;
     END LOOP;  -- CUR_UNIFICA
     END;
 BEGIN
    FOR CUR_ESTERNE IN
    (     select round(sum(decode( vaca.colonna
                                , 'COMP_FISSE', nvl(vaca.valore,0)
                                              , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) comp_fisse
                , round(sum(decode( vaca.colonna
                          , 'COMP_ACCESSORIE', nvl(vaca.valore,0)
                                             , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                             * nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) comp_accessorie
                , round(sum(decode( vaca.colonna
                            , 'COMP_18', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) comp_18
                , round(sum(decode( vaca.colonna
                            , 'IND_NON_A', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) ind_non_a
                , round(sum(decode( vaca.colonna
                          , 'IIS_CONGLOBATA', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) iis_conglobata
               , round(sum(decode( vaca.colonna
                          , 'IPN_PENS', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) ipn_pens
                , round( sum(decode(vaca.colonna
                                 ,'CONTR_PENS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_pens
                  , round( sum(decode(vaca.colonna
                                 ,'CONTR_AGG',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_agg
                  , round( sum(decode(vaca.colonna
                                 ,'IPN_TFS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) ipn_tfs
                  , round( sum(decode(vaca.colonna
                                 ,'CONTR_TFS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_tfs
                   , round( sum(decode(vaca.colonna
                                 ,'IPN_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) ipn_tfr
                   , round( sum(decode(vaca.colonna
                                 ,'CONTR_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_tfr
                   , round( sum(decode(vaca.colonna
                                 ,'IPN_CASSA_CREDITO',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) ipn_cassa_credito
                   , round( sum(decode(vaca.colonna
                                 ,'CONTR_CASSA_CREDITO',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_cassa_credito
                   , round( sum(decode(vaca.colonna
                                 ,'CONTR_ENPDEDP',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_enpdedp
                   , round( sum(decode(vaca.colonna
                                 ,'TREDICESIMA',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) tredicesima
                    , round( sum(decode(vaca.colonna
                                 ,'TEORICO_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1) teorico_tfr
                , round( sum(decode(vaca.colonna
                                 ,'COMP_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)  comp_tfr
                , round( sum(decode(vaca.colonna
                                 ,'QUOTA_L166',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) quota_L166
                , round( sum(decode(vaca.colonna
                                 ,'CONTR_L166',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_L166
                , round( sum(decode(vaca.colonna
                                 ,'COMP_PREMIO',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) comp_premio
                , round( sum(decode(vaca.colonna
                                 ,'CONTR_L135',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_l135
                , round( sum(decode(vaca.colonna
                                 ,'CONTR_PENS_SOSPESI',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_pens_sospesi
                , round( sum(decode(vaca.colonna
                                 ,'CONTR_PREV_SOSPESI',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) contr_prev_sospesi
                , round( sum(decode(vaca.colonna
                                 ,'SANZIONE_PENS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) sanzione_pens
                , round( sum(decode(vaca.colonna
                                 ,'SANZIONE_PREV',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) sanzione_prev
                , round( sum(decode(vaca.colonna
                                 ,'SANZIONE_CRED',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) sanzione_cred
                , round( sum(decode(vaca.colonna
                                 ,'SANZIONE_ENPDEDP',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) sanzione_enpdedp
              , vaca.ci                              ci
              , vaca.riferimento                     riferimento
           from valori_contabili_annuali    vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno_moco
            and vaca.mese              = D_mese_moco
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = D_mese_moco
                                             and tipo in ('A','N','S'))
            and vaca.mensilita        != '*AP'
            and vaca.moco_mese         = D_mese_moco
            and vaca.estrazione        = 'DENUNCIA_DMA'
            and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_18','IND_NON_A','IIS_CONGLOBATA'
                                         ,'IPN_PENS','CONTR_PENS','CONTR_AGG','IPN_TFS'
                                         ,'CONTR_TFS','IPN_TFR','CONTR_TFR','IPN_CASSA_CREDITO'
                                         ,'CONTR_CASSA_CREDITO','CONTR_ENPDEDP','TREDICESIMA'
                                         ,'TEORICO_TFR','COMP_TFR','QUOTA_L166','CONTR_L166'
                                         ,'COMP_PREMIO','CONTR_L135','CONTR_PENS_SOSPESI'
                                         ,'CONTR_PREV_SOSPESI','SANZIONE_PENS','SANZIONE_PREV'
                                         ,'SANZIONE_CRED','SANZIONE_ENPDEDP'   )
            and ci = cur_ci_dma.ci
            and not exists (select 'x' from denuncia_dma
                             where anno      = D_anno
                               and mese      = D_mese
                               and ci        = vaca.ci
                               and vaca.riferimento between dal and al
                               and competenza != 'P'
                           )
           group by vaca.ci,vaca.riferimento
          having round(sum(decode( vaca.colonna
                                , 'COMP_FISSE', nvl(vaca.valore,0)
                                              , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_FISSE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round(sum(decode( vaca.colonna
                          , 'COMP_ACCESSORIE', nvl(vaca.valore,0)
                                             , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                             * nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_ACCESSORIE', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round(sum(decode( vaca.colonna
                            , 'COMP_18', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'COMP_18', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round(sum(decode( vaca.colonna
                            , 'IND_NON_A', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'IND_NON_A', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round(sum(decode( vaca.colonna
                          , 'IIS_CONGLOBATA', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'IIS_CONGLOBATA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
               + round(sum(decode( vaca.colonna
                          , 'IPN_PENS', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(distinct decode( vaca.colonna
                                        , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                            * nvl(max(distinct decode( vaca.colonna
                                        , 'IPN_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'CONTR_PENS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                  + round( sum(decode(vaca.colonna
                                 ,'CONTR_AGG',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_AGG', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                  + round( sum(decode(vaca.colonna
                                 ,'IPN_TFS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                  + round( sum(decode(vaca.colonna
                                 ,'CONTR_TFS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                   + round( sum(decode(vaca.colonna
                                 ,'IPN_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                   + round( sum(decode(vaca.colonna
                                 ,'CONTR_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                   + round( sum(decode(vaca.colonna
                                 ,'IPN_CASSA_CREDITO',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'IPN_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                   + round( sum(decode(vaca.colonna
                                 ,'CONTR_CASSA_CREDITO',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_CASSA_CREDITO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                   + round( sum(decode(vaca.colonna
                                 ,'CONTR_ENPDEDP',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                   + round( sum(decode(vaca.colonna
                                 ,'TREDICESIMA',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'TREDICESIMA', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                    + round( sum(decode(vaca.colonna
                                 ,'TEORICO_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'TEORICO_TFR', nvl(esvc.arrotonda,0.01)
                                                    , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'COMP_TFR',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'QUOTA_L166',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'QUOTA_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'CONTR_L166',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L166', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'COMP_PREMIO',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'COMP_PREMIO', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'CONTR_L135',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_L135', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'CONTR_PENS_SOSPESI',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PENS_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'CONTR_PREV_SOSPESI',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'CONTR_PREV_SOSPESI', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'SANZIONE_PENS',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PENS', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'SANZIONE_PREV',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_PREV', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'SANZIONE_CRED',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_CRED', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                + round( sum(decode(vaca.colonna
                                 ,'SANZIONE_ENPDEDP',nvl(vaca.valore,0),0))
                     / nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                     * nvl(max(distinct decode( vaca.colonna
                                 , 'SANZIONE_ENPDEDP', nvl(esvc.arrotonda,0.01)
                                                   , '')),1) != 0
    )
    LOOP
      D_prg_err_8b := nvl(D_prg_err_8b,0) + 1;
      INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
      VALUES (prenotazione,1,D_prg_err_8b,' ',null);
     BEGIN
     update denuncia_dma
        set comp_fisse          = decode(nvl(instr(I_pensione,'1'),0),0,nvl(comp_fisse,0) + nvl(cur_esterne.comp_fisse,0)
                                                                ,nvl(comp_fisse,0) + nvl(cur_esterne.comp_fisse,0) - nvl(cur_esterne.tredicesima,0)
                                        )
          , comp_accessorie     = nvl(comp_accessorie,0) + nvl(cur_esterne.comp_accessorie,0)
          , comp_18             = decode(nvl(instr(I_pensione,'1'),0),0, nvl(comp_18,0) + nvl(cur_esterne.comp_18,0))
          , ind_non_a           = nvl(ind_non_a,0) + nvl(cur_esterne.ind_non_a,0)
          , iis_conglobata      = decode(nvl(instr(I_pensione,'1'),0),0,nvl(iis_conglobata,0),nvl(iis_conglobata,0) + nvl(cur_esterne.iis_conglobata,0))
          , ipn_pens_periodo    = nvl(ipn_pens_periodo,0) + nvl(cur_esterne.ipn_pens,0)
          , contr_pens_periodo  = nvl(contr_pens_periodo,0) + nvl(cur_esterne.contr_pens,0)
          , contr_su_eccedenza  = nvl(contr_su_eccedenza,0) + nvl(cur_esterne.contr_agg,0)
          , ipn_tfs             = nvl(ipn_tfs,0) + nvl(cur_esterne.ipn_tfs,0)
          , contr_tfs           = nvl(contr_tfs,0) + nvl(cur_esterne.contr_tfs,0)
          , ipn_tfr             = nvl(ipn_tfr,0) + nvl(cur_esterne.ipn_tfr,0)
          , contr_ipn_tfr       = nvl(contr_ipn_tfr,0) + nvl(cur_esterne.contr_tfr,0)
          , ipn_cassa_credito   = nvl(ipn_cassa_credito,0) + nvl(cur_esterne.ipn_cassa_credito,0)
          , contr_cassa_credito = nvl(contr_cassa_credito,0) + nvl(cur_esterne.contr_cassa_credito,0)
          , contr_enpdedp       = nvl(contr_enpdedp,0) + nvl(cur_esterne.contr_enpdedp,0)
          , tredicesima         = decode( nvl(instr(I_pensione,'1'),0)
                                        ,0,nvl(tredicesima,0),nvl(tredicesima,0)+ nvl(cur_esterne.tredicesima,0))
          , retr_teorico_tfr    = nvl(retr_teorico_tfr,0) + nvl(cur_esterne.teorico_tfr,0)
          , retr_utile_tfr         = nvl(retr_utile_tfr,0) + nvl(cur_esterne.comp_tfr,0)
          , quota_solidarieta_l166 = nvl(quota_solidarieta_l166,0) + nvl(cur_esterne.quota_L166,0)
          , contr_solidarieta_l166 = nvl(contr_solidarieta_l166,0) + nvl(cur_esterne.contr_L166,0)
          , retr_l135              = nvl(retr_l135,0) + nvl(cur_esterne.comp_premio,0)
          , contr_solidarieta_l135 = nvl(contr_solidarieta_l135,0) + nvl(cur_esterne.contr_L135,0)
          , contr_pens_calamita    = nvl(contr_pens_calamita,0) + nvl(cur_esterne.contr_pens_sospesi,0)
          , contr_prev_calamita    = nvl(contr_prev_calamita,0) + nvl(cur_esterne.contr_prev_sospesi,0)
          , sanzione_pensione      = nvl(sanzione_pensione,0) + nvl(cur_esterne.sanzione_pens,0)
          , sanzione_previdenza    = nvl(sanzione_previdenza,0) + nvl(cur_esterne.sanzione_prev,0)
          , sanzione_credito       = nvl(sanzione_credito,0) + nvl(cur_esterne.sanzione_cred,0)
          , sanzione_enpdedp       = nvl(sanzione_enpdedp,0) + nvl(cur_esterne.sanzione_enpdedp,0)
      where anno     = D_anno
        and mese     = D_mese
        and ci       = cur_esterne.ci
        and nvl(competenza,'C') = 'C'
        and dal      =
           (select nvl(max(dal),to_date(lpad(D_mese,2,'0')||D_anno,'mmyyyy'))
              from denuncia_dma
             where anno   = D_anno
               and mese   = D_mese
               and ci     = CUR_ESTERNE.ci
               and al     < CUR_ESTERNE.riferimento
           );
    BEGIN
      select dal,al
        into EST_dal,EST_al
        from denuncia_dma
       where anno     = D_anno
         and mese     = D_mese
         and ci       = cur_esterne.ci
         and nvl(competenza,'C') = 'C'
         and dal      =
            (select nvl(max(dal),to_date(lpad(D_mese,2,'0')||D_anno,'mmyyyy'))
               from denuncia_dma
              where anno   = D_anno
                and mese   = D_mese
                and ci     = CUR_ESTERNE.ci
                and al     < CUR_ESTERNE.riferimento
            );
        D_prg_err_8b := nvl(D_prg_err_8b,0) + 1;
        INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
        VALUES (prenotazione,1,D_prg_err_8b
               ,'P05185','Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||
                         ' Riferimento: '||to_char(CUR_ESTERNE.riferimento,'dd/mm/yyyy')||
                         ' Importi sommati al periodo: dal '||to_char(EST_dal,'dd/mm/yyyy')||
                         ' Al: '||to_char(EST_al,'dd/mm/yyyy')||
                         ' Comp.Fisse: '||nvl(CUR_ESTERNE.comp_fisse,0)||
                         ' Comp.Acc.: '||nvl(CUR_ESTERNE.comp_accessorie,0)||
                         ' Ipn.Pens.: '||nvl(CUR_ESTERNE.ipn_pens,0)||
                         ' Contr.Pens.: '||nvl(CUR_ESTERNE.contr_pens,0)||
                         ' Ipn.TFS: '||nvl(CUR_ESTERNE.ipn_tfs,0)||
                         ' Contr.TFS '||nvl(CUR_ESTERNE.contr_tfs,0)||
                         ' Ipn.TFR: '||nvl(CUR_ESTERNE.ipn_tfr,0)||
                         ' Contr.TFR '||nvl(CUR_ESTERNE.contr_tfr,0)||
                         ' Teorico TFR '||nvl(CUR_ESTERNE.teorico_tfr,0)||
                         ' Ipn. Credito '||nvl(CUR_ESTERNE.ipn_cassa_credito,0)||
                         ' Contr. Credito '||nvl(CUR_ESTERNE.contr_cassa_credito,0)
               );
     EXCEPTION WHEN NO_DATA_FOUND THEN null;
     END;
     IF not SQL%FOUND THEN
        null;
        D_prg_err_8 := nvl(D_prg_err_8,0) + 1;
        INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
        VALUES (prenotazione,1,D_prg_err_8
               ,'P05185','Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||
                         ' Riferimento: '||to_char(CUR_ESTERNE.riferimento,'dd/mm/yyyy')||
                         ' Comp.Fisse: '||nvl(CUR_ESTERNE.comp_fisse,0)||
                         ' Comp.Acc.: '||nvl(CUR_ESTERNE.comp_accessorie,0)||
                         ' Ipn.Pens.: '||nvl(CUR_ESTERNE.ipn_pens,0)||
                         ' Contr.Pens.: '||nvl(CUR_ESTERNE.contr_pens,0)||
                         ' Ipn.TFS: '||nvl(CUR_ESTERNE.ipn_tfs,0)||
                         ' Contr.TFS '||nvl(CUR_ESTERNE.contr_tfs,0)||
                         ' Ipn.TFR: '||nvl(CUR_ESTERNE.ipn_tfr,0)||
                         ' Contr.TFR '||nvl(CUR_ESTERNE.contr_tfr,0)||
                         ' Teorico TFR '||nvl(CUR_ESTERNE.teorico_tfr,0)||
                         ' Ipn. Credito '||nvl(CUR_ESTERNE.ipn_cassa_credito,0)||
                         ' Contr. Credito '||nvl(CUR_ESTERNE.contr_cassa_credito,0)
               );
/*              INSERT INTO a_appoggio_stampe
              values( prenotazione
                    , 1
                    , D_pagina
                    , D_riga
                    , LPAD(TO_CHAR(CUR_ESTERNE.ci),8,'0')||
                      TO_CHAR(CUR_ESTERNE.riferimento,'dd/mm/yyyy')||
                      lpad(nvl(cur_esterne.comp_fisse,0) ,10,'0')||
                      lpad(nvl(cur_esterne.comp_accessorie,0) ,10,'0')||
                      lpad(nvl(cur_esterne.comp_18,0) ,10,'0')||
                      lpad(nvl(cur_esterne.ind_non_a,0) ,10,'0')||
                      lpad(nvl(cur_esterne.iis_conglobata,0) ,10,'0')||
                      lpad(nvl(cur_esterne.ipn_pens,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_pens,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_agg,0) ,10,'0')||
                      lpad(nvl(cur_esterne.ipn_tfs,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_tfs,0) ,10,'0')||
                      lpad(nvl(cur_esterne.ipn_tfr,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_tfr,0) ,10,'0')||
                      lpad(nvl(cur_esterne.ipn_cassa_credito,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_cassa_credito,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_enpdedp,0) ,10,'0')||
                      lpad(nvl(cur_esterne.tredicesima,0) ,10,'0')||
                      lpad(nvl(cur_esterne.teorico_tfr,0) ,10,'0')||
                      lpad(nvl(cur_esterne.comp_tfr,0) ,10,'0')||
                      lpad(nvl(cur_esterne.quota_L166,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_L166,0) ,10,'0')||
                      lpad(nvl(cur_esterne.comp_premio,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_L135,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_pens_sospesi,0) ,10,'0')||
                      lpad(nvl(cur_esterne.contr_prev_sospesi,0) ,10,'0')||
                      lpad(nvl(cur_esterne.sanzione_pens,0) ,10,'0')||
                      lpad(nvl(cur_esterne.sanzione_prev,0) ,10,'0')||
                      lpad(nvl(cur_esterne.sanzione_cred,0) ,10,'0')||
                      lpad(nvl(cur_esterne.sanzione_enpdedp,0) ,10,'0')
                 );
              commit;
              D_pagina := D_pagina + 1;
              D_riga   := D_riga   + 1;*/
     END IF;
     END;
    END LOOP;    -- cur_esterne
     END;
 BEGIN -- assestamenti vari
update denuncia_dma ddma
   set causale_variazione = '2'
 where ddma.anno = D_anno
   and ddma.mese = D_mese
   and ddma.ci   = CUR_CI_DMA.ci
   and ddma.rilevanza = 'V1'
   and ddma.tipo_servizio != '30'
   and ddma.causale_variazione = '1'
   and ddma.dal  >= to_date('01012005','ddmmyyyy') 	--data fissa inizio DMA i periodi precedenti si considerano dichiarati con il 770
   and not exists
      (select 'x' from denuncia_dma
        where anno = to_char(ddma.dal,'yyyy')
          and mese = to_char(ddma.dal,'mm')
          and ci   = ddma.ci
          and rilevanza = 'E0')
;
update denuncia_dma ddma
   set tipo_impiego =
(select nvl(max(decode( posi.contratto_formazione
                 , 'NO', decode
                         ( posi.stagionale
                         , 'GG', '2'
                               , decode
                                 ( posi.part_time
                                 , 'SI',decode( posi.tempo_determinato
                                              , 'NO', '8'
                                                    , '18')
                                       ,decode( posi.tempo_determinato
                                              , 'NO', '1'
                                                    , '17')
                                 )
                         )
                       , posi.tipo_formazione)) ,ddma.tipo_impiego)           impiego
   from posizioni                   posi
      , periodi_giuridici           pegi
  where pegi.rilevanza      = 'S'
    and pegi.ci             = ddma.ci
    and pegi.dal =
       (select min(pegis.dal) from periodi_giuridici pegis
         where pegis.rilevanza = 'S'
           and pegis.ci        = ddma.ci
           and pegis.dal       >= (select max(dal) from periodi_giuridici
                                    where rilevanza = 'P'
                                      and ci = ddma.ci
                                      and dal <= ddma.dal)
       )
    and posi.codice    (+)  = pegi.posizione
)
where ddma.anno         = D_anno
  and ddma.mese         = D_mese
  and ddma.ci           = CUR_CI_DMA.ci
  and ddma.tipo_impiego = '8'
  and nvl(ddma.competenza,'C') = 'C'
;
update denuncia_dma ddma
   set  tipo_servizio =
(select nvl(max(decode( posi.part_time
                      , 'SI', '4'
                            , ddma.tipo_servizio)), ddma.tipo_servizio)       servizio
   from posizioni                   posi
      , periodi_giuridici           pegi
  where pegi.rilevanza      = 'S'
    and pegi.ci             = ddma.ci
    and pegi.dal =
       (select min(pegis.dal) from periodi_giuridici pegis
         where pegis.rilevanza = 'S'
           and pegis.ci        = ddma.ci
           and pegis.dal       >= (select max(dal) from periodi_giuridici
                                    where rilevanza = 'P'
                                      and ci = ddma.ci
                                      and dal <= ddma.dal)
       )
    and posi.codice    (+)  = pegi.posizione
)
where ddma.anno         = D_anno
  and ddma.mese         = D_mese
  and ddma.ci           = CUR_CI_DMA.ci
  and ddma.tipo_servizio  = '5'
  and ddma.tipo_impiego in ('8','18')
  and nvl(ddma.competenza,'C') = 'C'
;
--
-- modifica tipo_servizio per p.t. misti o verticali (nel cursore_dma
-- non avendo le ore ridotte non riesce a metterle il 5.
--
update denuncia_dma ddma
   set  tipo_servizio =
(select nvl(max(decode( posi.part_time
                      , 'SI', '4'
                            , '5')), '5')       servizio
   from posizioni                   posi
      , periodi_giuridici           pegi
  where pegi.rilevanza      = 'S'
    and pegi.ci             = ddma.ci
    and pegi.dal =
       (select min(pegis.dal) from periodi_giuridici pegis
         where pegis.rilevanza = 'S'
           and pegis.ci        = ddma.ci
           and pegis.dal       >= (select max(dal) from periodi_giuridici
                                    where rilevanza = 'P'
                                      and ci = ddma.ci
                                      and dal <= ddma.dal)
       )
    and posi.codice    (+)  = pegi.posizione
)
where ddma.anno         = D_anno
  and ddma.mese         = D_mese
  and ddma.ci           = CUR_CI_DMA.ci
  and ddma.tipo_servizio  = '4'
  and nvl(ddma.perc_part_time,0) != 0
  and nvl(ddma.competenza,'C') = 'C'
  and exists 
     (select 'x' from periodi_giuridici
       where rilevanza = 'S'
         and ci = ddma.ci
         and ddma.dal between dal and nvl(al,to_date('3333333','j'))
         and instr(upper(note),'VERTICALE: ') != 0 
          or instr(upper(note),'MISTO: ') != 0 )
;
update denuncia_dma ddma
   set retr_teorico_tfr =
      (select nvl(max(retr_teorico_tfr),0)
         from denuncia_dma
        where anno = D_anno
          and mese = D_mese
          and ci   = CUR_CI_DMA.ci
          and rilevanza = 'E0'
          and nvl(retr_teorico_tfr,0) != 0)
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and rilevanza = 'E0'
   and fine_servizio in ('1','2')
   and nvl(retr_teorico_tfr,0) = 0
;
-- controlla fondo prev. e credito
update denuncia_dma
   set ipn_cassa_credito = 0
     , contr_cassa_credito = 0
where anno = D_anno
  and mese = D_mese
  and ci   = CUR_CI_DMA.ci
  and abs(nvl(ipn_cassa_credito,0))   <= 0.05
  and abs(nvl(contr_cassa_credito,0)) <= 0.02
  and (ipn_cassa_credito != 0 or contr_cassa_credito != 0)
;
-- controlla cassa pensione
update denuncia_dma
   set ipn_pens_periodo = 0
     , contr_pens_periodo = 0
where anno = D_anno
  and mese = D_mese
  and ci   = CUR_CI_DMA.ci
  and abs(nvl(ipn_pens_periodo,0))  <= 0.05
  and abs(nvl(contr_pens_periodo,0)) <= 0.05
  and (ipn_pens_periodo != 0 or contr_pens_periodo != 0)
;
-- controlla i contributi su eccedenza
update denuncia_dma
   set contr_su_eccedenza = 0
where anno = D_anno
  and mese = D_mese
  and ci   = CUR_CI_DMA.ci
  and nvl(ipn_pens_periodo,0) = 0
  and abs(nvl(contr_su_eccedenza,0)) <= 0.05
  and contr_su_eccedenza  != 0
;
-- controlla imponibile e contributi TFS
update denuncia_dma
   set ipn_tfs = 0
     , contr_tfs = 0
where anno = D_anno
  and mese = D_mese
  and ci   = CUR_CI_DMA.ci
  and abs(nvl(ipn_tfs,0))   <= 0.05
  and abs(nvl(contr_tfs,0)) <= 0.05
  and (ipn_tfs != 0 or contr_tfs != 0)
;
-- controlla imponibile e contributi TFR
update denuncia_dma
   set ipn_tfr = 0
     , contr_ipn_tfr = 0
     , RETR_TEORICO_TFR = 0
     , RETR_UTILE_TFR = 0
where anno = D_anno
  and mese = D_mese
  and ci   = CUR_CI_DMA.ci
  and abs(nvl(ipn_tfr,0))   <= 0.05
  and abs(nvl(contr_ipn_tfr,0)) <= 0.05
  and (ipn_tfr != 0 or contr_ipn_tfr != 0)
;
update denuncia_dma
   set retr_utile_tfr = 0
     , retr_teorico_tfr = 0
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and nvl(ipn_tfr,0) = 0
;
update denuncia_dma
   set comp_18 =0, IIS_conglobata = 0
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and nvl(cassa_pensione,0) != 1
;
-- recupera maggiorazioni e giorni dal mese precedente
update denuncia_dma dma
   set (maggiorazioni,GG_MAG_1,GG_MAG_2,GG_MAG_3,GG_MAG_4) =
( select maggiorazioni
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),1,3)
               , '   ', null
                      , gg_mag_1)
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),4,3)
               , '   ', null
                      , gg_mag_2)
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),7,3)
               , '   ', null
                      , gg_mag_3)
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),10,3)
               , '   ', null
                      , gg_mag_4)
    from denuncia_dma
   where (anno,mese,ci,dal) = (select max(anno),max(mese),max(ci),max(dal)
                                 from denuncia_dma
                                where anno = decode(D_mese,1,D_anno-1,D_anno)
                                  and mese < decode(D_mese,1,13,D_mese)
                                  and ci   = cur_ci_dma.ci
                                  and rilevanza = 'E0')
     and rilevanza = 'E0')
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and rilevanza = 'E0';
update denuncia_dma dma
   set (maggiorazioni,GG_MAG_1,GG_MAG_2,GG_MAG_3,GG_MAG_4) =
( select maggiorazioni
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),1,3)
               , '   ', null
                      , gg_mag_1)
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),4,3)
               , '   ', null
                      , gg_mag_2)
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),7,3)
               , '   ', null
                      , gg_mag_3)
       , decode( substr(rpad(nvl(maggiorazioni,' '),12,' '),10,3)
               , '   ', null
                      , gg_mag_4)
    from denuncia_dma
   where anno = D_anno
     and mese = D_mese
     and rilevanza = 'V1'
     and competenza = 'P'
     and dal = dma.dal
     and ci  = dma.ci
     and tipo_aliquota = dma.tipo_aliquota
)
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and rilevanza = 'V1'
   and competenza = 'C';
-- recupera data fine calamita' dal mese precedente
update denuncia_dma dma
   set data_fine_calamita =
( select max(data_fine_calamita)
    from denuncia_dma
   where anno = decode(D_mese,1,D_anno-1,D_anno)
     and mese = decode(D_mese,1,12,D_mese-1)
     and ci   = cur_ci_dma.ci
     and rilevanza = 'E0')
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and nvl(contr_pens_calamita,0) + nvl(contr_prev_calamita,0) != 0;
update denuncia_dma dma
   set data_fine_calamita =
( select data_fine_calamita
    from denuncia_dma
   where anno = D_ANNO
     and mese = D_mese
     and ci   = dma.ci
     and dal  = dma.dal
     and rilevanza = 'V1'
     and competenza = 'P')
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and rilevanza = 'V1'
   and competenza = 'C'
   and nvl(contr_pens_calamita,0) + nvl(contr_prev_calamita,0) != 0;
-- recupera gestione di appartenenza dal mese precedente
update denuncia_dma dma
   set gestione_app =
( select max(gestione_app)
    from denuncia_dma
   where (anno,mese,ci,dal) = (select max(anno),max(mese),max(ci),max(dal)
                                 from denuncia_dma
                                where anno = decode(D_mese,1,D_anno-1,D_anno)
                                  and mese < decode(D_mese,1,13,D_mese)
                                  and ci   = cur_ci_dma.ci
                                  and gestione_app is not null)
     and gestione_app is not null)
 where anno = D_anno
   and mese = D_mese
   and ci   = CUR_CI_DMA.ci
   and exists
      (select 'x' from denuncia_dma
        where anno = decode(D_mese,1,D_anno-1,D_anno)
          and mese < decode(D_mese,1,13,D_mese)
          and ci   = cur_ci_dma.ci
          and gestione_app is not null);
SIST_ASSICURAZIONI(cur_ci_dma.ci,D_anno,D_mese);
commit;
END;
-- cancellazione record con servizio 30 e senza importi
 delete from denuncia_dma dedm
  where ci = CUR_CI_DMA.ci
    and anno = D_anno
    and mese = D_mese
    and rilevanza = 'E0'
    and tipo_servizio = '30'
    and nvl(comp_fisse,0)         = 0
    and nvl(comp_accessorie,0)    = 0
    and nvl(magg_l165,0)          = 0
    and nvl(comp_18,0)            = 0
    and nvl(ind_non_a,0)          = 0
    and nvl(iis_conglobata,0)     = 0
    and nvl(ipn_pens_periodo,0)   = 0
    and nvl(contr_pens_periodo,0) = 0
    and nvl(contr_su_eccedenza,0) = 0
    and nvl(ipn_tfs,0)            = 0
    and nvl(contr_tfs,0)          = 0
    and nvl(ipn_tfr,0)            = 0
    and nvl(contr_ipn_tfr,0)      = 0
    and nvl(ult_ipn_tfr,0)        = 0
    and nvl(contr_ult_ipn_tfr,0)  = 0
    and nvl(ipn_cassa_credito,0)  = 0
    and nvl(contr_cassa_credito,0)    = 0
    and nvl(contr_enpdedp,0)          = 0
    and nvl(tredicesima,0)            = 0
    and nvl(quota_solidarieta_l166,0) = 0
    and nvl(contr_solidarieta_l166,0) = 0
    and nvl(retr_l135,0)              = 0
    and nvl(contr_solidarieta_l135,0) = 0
    and nvl(contr_pens_calamita,0)    = 0
    and nvl(contr_prev_calamita,0)    = 0
    and nvl(sanzione_pensione,0)      = 0
    and nvl(sanzione_previdenza,0)    = 0
    and nvl(sanzione_credito,0)       = 0
    and nvl(sanzione_enpdedp,0)       = 0
    and nvl(retr_teorico_tfr,0)       = 0
    ;
-- cancellazione record con tutti gli importi a 0
 delete from denuncia_dma dedm
  where ci = CUR_CI_DMA.ci
    and anno = D_anno
    and mese = D_mese
    and tipo_servizio != '30'
    and nvl(comp_fisse,0)          = 0
    and nvl(comp_accessorie,0)     = 0
    and nvl(magg_l165,0)           = 0
    and nvl(comp_18,0)             = 0
    and nvl(ind_non_a,0)           = 0
    and nvl(iis_conglobata,0)      = 0
    and nvl(ipn_pens_periodo,0)    = 0
    and nvl(contr_pens_periodo,0)  = 0
    and nvl(contr_su_eccedenza,0)  = 0
    and nvl(ipn_tfs,0)             = 0
    and nvl(contr_tfs,0)           = 0
    and nvl(ipn_tfr,0)             = 0
    and nvl(contr_ipn_tfr,0)       = 0
    and nvl(ult_ipn_tfr,0)         = 0
    and nvl(contr_ult_ipn_tfr,0)   = 0
    and nvl(ipn_cassa_credito,0)   = 0
    and nvl(contr_cassa_credito,0) = 0
    and nvl(contr_enpdedp,0)       = 0
    and nvl(tredicesima,0)         = 0
    and nvl(quota_solidarieta_l166,0) = 0
    and nvl(contr_solidarieta_l166,0) = 0
    and nvl(retr_l135,0)              = 0
    and nvl(contr_solidarieta_l135,0) = 0
    and nvl(contr_pens_calamita,0)    = 0
    and nvl(contr_prev_calamita,0)    = 0
    and nvl(sanzione_pensione,0)      = 0
    and nvl(sanzione_previdenza,0)    = 0
    and nvl(sanzione_credito,0)       = 0
    and nvl(sanzione_enpdedp,0)       = 0
    and nvl(retr_teorico_tfr,0)       = 0
    ;
-- cancellazione record con tutti gli importi a 0 e contributi o imponibili di centesimi di arr.
 delete from denuncia_dma dedm
  where ci = CUR_CI_DMA.ci
    and anno = D_anno
    and mese = D_mese
    and nvl(comp_fisse,0)             between -0.02 and 0.02
    and nvl(comp_accessorie,0)        between -0.02 and 0.02
    and nvl(magg_l165,0)              between -0.02 and 0.02
    and nvl(comp_18,0)                between -0.02 and 0.02
    and nvl(ind_non_a,0)              between -0.02 and 0.02
    and nvl(iis_conglobata,0)         between -0.02 and 0.02
    and nvl(tredicesima,0)            between -0.02 and 0.02
    and nvl(quota_solidarieta_l166,0) between -0.02 and 0.02
    and nvl(retr_l135,0)              between -0.02 and 0.02
    and nvl(sanzione_pensione,0)      between -0.02 and 0.02
    and nvl(sanzione_previdenza,0)    between -0.02 and 0.02
    and nvl(sanzione_credito,0)       between -0.02 and 0.02
    and nvl(sanzione_enpdedp,0)       between -0.02 and 0.02
    and nvl(contr_pens_periodo,0)     between -0.02 and 0.02
    and nvl(contr_su_eccedenza,0)     between -0.02 and 0.02
    and nvl(contr_tfs,0)              between -0.02 and 0.02
    and nvl(contr_ipn_tfr,0)          between -0.02 and 0.02
    and nvl(contr_ult_ipn_tfr,0)      between -0.02 and 0.02
    and nvl(contr_cassa_credito,0)    between -0.02 and 0.02
    and nvl(contr_enpdedp,0)          between -0.02 and 0.02
    and nvl(contr_solidarieta_l166,0) between -0.02 and 0.02
    and nvl(contr_solidarieta_l135,0) between -0.02 and 0.02
    and nvl(contr_pens_calamita,0)    between -0.02 and 0.02
    and nvl(contr_prev_calamita,0)    between -0.02 and 0.02
    and nvl(ipn_pens_periodo,0)       between -0.02 and 0.02
    and nvl(ipn_tfs,0)                between -0.02 and 0.02
    and nvl(ipn_tfr,0)                between -0.02 and 0.02
    and nvl(ult_ipn_tfr,0)            between -0.02 and 0.02
    and nvl(ipn_cassa_credito,0)      between -0.02 and 0.02
    and nvl(retr_teorico_tfr,0)       between -0.02 and 0.02
    ;
-- cancellazione record le stesse caratteristiche che si azzerano tra loro
delete from denuncia_dma
 where anno = D_anno
   and mese = D_mese
   and (ci,dal,al,previdenza,nvl(qualifica,' '),cassa_pensione,cassa_previdenza,cassa_credito,nvl(cassa_enpdedp,' ')
       ,tipo_impiego,tipo_servizio,nvl(perc_part_time,0),nvl(ore_ridotte,0),nvl(causa_cessazione,' ')) in
       (select ci,dal,al,previdenza,nvl(qualifica,' '),cassa_pensione,cassa_previdenza,cassa_credito,nvl(cassa_enpdedp,' ')
             , tipo_impiego,tipo_servizio,nvl(perc_part_time,0),nvl(ore_ridotte,0),nvl(causa_cessazione,' ')
          from denuncia_dma
         where anno = D_anno
           and mese = D_mese
           and ci   = CUR_CI_DMA.ci
         group by ci,dal,al,previdenza,qualifica,cassa_pensione,cassa_previdenza,cassa_credito,cassa_enpdedp
             , tipo_impiego,tipo_servizio,perc_part_time,ore_ridotte,causa_cessazione
        having sum(nvl(comp_fisse,0))          = 0
           and sum(nvl(comp_accessorie,0))     = 0
           and sum(nvl(magg_l165,0))           = 0
           and sum(nvl(comp_18,0))             = 0
           and sum(nvl(ind_non_a,0))           = 0
           and sum(nvl(iis_conglobata,0))      = 0
           and sum(nvl(ipn_pens_periodo,0))    = 0
           and sum(nvl(contr_pens_periodo,0))  = 0
           and sum(nvl(contr_su_eccedenza,0))  = 0
           and sum(nvl(ipn_tfs,0))             = 0
           and sum(nvl(contr_tfs,0))           = 0
           and sum(nvl(ipn_tfr,0))             = 0
           and sum(nvl(contr_ipn_tfr,0))       = 0
           and sum(nvl(ult_ipn_tfr,0))         = 0
           and sum(nvl(contr_ult_ipn_tfr,0))   = 0
           and sum(nvl(ipn_cassa_credito,0))   = 0
           and sum(nvl(contr_cassa_credito,0)) = 0
           and sum(nvl(contr_enpdedp,0))       = 0
           and sum(nvl(tredicesima,0))         = 0
           and sum(nvl(quota_solidarieta_l166,0)) = 0
           and sum(nvl(contr_solidarieta_l166,0)) = 0
           and sum(nvl(retr_l135,0))              = 0
           and sum(nvl(contr_solidarieta_l135,0)) = 0
           and sum(nvl(contr_pens_calamita,0))    = 0
           and sum(nvl(contr_prev_calamita,0))    = 0
           and sum(nvl(sanzione_pensione,0))      = 0
           and sum(nvl(sanzione_previdenza,0))    = 0
           and sum(nvl(sanzione_credito,0))       = 0
           and sum(nvl(sanzione_enpdedp,0))       = 0
           and sum(nvl(retr_teorico_tfr,0))       = 0)
;
-- Controllo E0 tipo 30 rimasti
BEGIN
  FOR CUR_30 IN
     (select ddma_id,dal,al
           , comp_fisse,comp_accessorie
           , ipn_pens_periodo,contr_pens_periodo
           , ipn_tfs,contr_tfs
           , ipn_tfr,contr_ipn_tfr,retr_teorico_tfr
           , ipn_cassa_credito,contr_cassa_credito
        from denuncia_dma
       where anno               = D_anno
         and mese               = D_mese
         and rilevanza          = 'E0'
         and tipo_servizio      = '30'
         and ci                 = CUR_CI_DMA.ci
         and (   nvl(comp_fisse,0)          != 0
              or nvl(comp_accessorie,0)     != 0
              or nvl(magg_l165,0)           != 0
              or nvl(comp_18,0)             != 0
              or nvl(ind_non_a,0)           != 0
              or nvl(iis_conglobata,0)      != 0
              or nvl(ipn_pens_periodo,0)    != 0
              or nvl(contr_pens_periodo,0)  != 0
              or nvl(contr_su_eccedenza,0)  != 0
              or nvl(ipn_tfs,0)             != 0
              or nvl(contr_tfs,0)           != 0
              or nvl(ipn_tfr,0)             != 0
              or nvl(contr_ipn_tfr,0)       != 0
              or nvl(ult_ipn_tfr,0)         != 0
              or nvl(contr_ult_ipn_tfr,0)   != 0
              or nvl(ipn_cassa_credito,0)   != 0
              or nvl(contr_cassa_credito,0) != 0
              or nvl(contr_enpdedp,0)       != 0
              or nvl(tredicesima,0)         != 0
              or nvl(quota_solidarieta_l166,0) != 0
              or nvl(contr_solidarieta_l166,0) != 0
              or nvl(retr_l135,0)              != 0
              or nvl(contr_solidarieta_l135,0) != 0
              or nvl(contr_pens_calamita,0)    != 0
              or nvl(contr_prev_calamita,0)    != 0
              or nvl(sanzione_pensione,0)      != 0
              or nvl(sanzione_previdenza,0)    != 0
              or nvl(sanzione_credito,0)       != 0
              or nvl(sanzione_enpdedp,0)       != 0
              or nvl(retr_teorico_tfr,0)       != 0)
     ) LOOP
         D_prg_err_3b := nvl(D_prg_err_3b,0) + 1;
         INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
         VALUES (prenotazione,1,D_prg_err_3b,' ',null);
       BEGIN
         DDMA30_segnala := 0;
         FOR CUR_E0 IN
            (select ddma_id,dal,al
               from denuncia_dma ddma
              where anno       = D_anno
                and rilevanza  = 'E0'
                and ci         = CUR_CI_DMA.ci
                and mese       =
                   (select max(mese)
                      from denuncia_dma
                     where anno      = D_anno
                       and mese      < D_mese
                       and ci        = CUR_CI_DMA.ci
                       and rilevanza = 'E0'
                   )
            ) LOOP
              DDMA30_segnala := 1;
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
                 , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp, utente, tipo_agg, data_agg
                 )
               select
                   ddma_sq.nextval, D_anno, D_mese, previdenza, gestione, fine_servizio
                 , cassa_pensione, cassa_previdenza, cassa_credito, cassa_enpdedp
                 , ci, codice, posizione, qualifica, 'V1', 'P', '1'
                 , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
                 , tipo_part_time, perc_part_time, 0 gg_utili, ore_ridotte, perc_l300,                    decode(ddma.rilevanza,'E0',substr(lpad(nvl(riferimento,anno),6,'0'),3,4),riferimento), tipo_aliquota
                 , comp_fisse*-1, comp_accessorie*-1, magg_l165*-1, comp_18*-1, ind_non_a*-1, iis_conglobata*-1,                    ipn_pens_periodo*-1
                 , contr_pens_periodo*-1, contr_su_eccedenza*-1, ipn_tfs*-1, contr_tfs*-1
                 , ipn_tfr*-1, contr_ipn_tfr*-1, ult_ipn_tfr*-1, contr_ult_ipn_tfr*-1, ipn_cassa_credito*-1,                    contr_cassa_credito*-1
                 , contr_enpdedp*-1, tredicesima*-1, retr_teorico_tfr*-1, retr_utile_tfr*-1, quota_solidarieta_l166*-1
                 , contr_solidarieta_l166*-1, retr_l135*-1, contr_solidarieta_l135*-1, contr_pens_calamita*-1,                    contr_prev_calamita*-1
                 , sanzione_pensione*-1, sanzione_previdenza*-1, sanzione_credito*-1, sanzione_enpdedp*-1
                 , D_utente, null, sysdate
                from denuncia_dma ddma
               where ddma_id = CUR_E0.ddma_id
                 and not exists
                     (select 'x' from denuncia_dma
                       where anno      = D_anno
                         and mese      = D_mese
                         and ci        = CUR_CI_DMA.ci
                         and rilevanza = 'V1'
                         and dal       = cur_e0.dal
                         and al        = cur_e0.al
                         and competenza = 'P');
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
                 , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp, utente, tipo_agg, data_agg
                 )
               select
                   ddma_sq.nextval, D_anno, D_mese, previdenza, gestione, fine_servizio
                 , cassa_pensione, cassa_previdenza, cassa_credito, cassa_enpdedp
                 , ci, codice, posizione, qualifica, 'V1', 'C', '1'
                 , dal, al, data_cessazione, causa_cessazione, tipo_impiego, tipo_servizio
                 , tipo_part_time, perc_part_time, 0 gg_utili, ore_ridotte, perc_l300, decode(ddma.rilevanza,'E0',substr(lpad(nvl(riferimento,anno),6,'0'),3,4),riferimento), tipo_aliquota
                 , comp_fisse, comp_accessorie, magg_l165, comp_18, ind_non_a, iis_conglobata, ipn_pens_periodo
                 , contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
                 , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr, contr_ult_ipn_tfr, ipn_cassa_credito, contr_cassa_credito
                 , contr_enpdedp, tredicesima, retr_teorico_tfr, retr_utile_tfr, quota_solidarieta_l166
                 , contr_solidarieta_l166, retr_l135, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
                 , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp
                 , D_utente, null, sysdate
                from denuncia_dma ddma
               where ddma_id = CUR_E0.ddma_id
                 and not exists
                     (select 'x' from denuncia_dma
                       where anno      = D_anno
                         and mese      = D_mese
                         and ci        = CUR_CI_DMA.ci
                         and rilevanza = 'V1'
                         and dal      <= cur_e0.al
                         and al       >= cur_e0.dal
                         and competenza = 'C');
           D_prg_err_3b := nvl(D_prg_err_3b,0) + 1;
           INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES (prenotazione,1,D_prg_err_3b,'P05495','Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||
                                                              ' Dal: '||to_char(CUR_30.dal,'dd/mm/yyyy')||
                                                              ' Al: '||to_char(CUR_30.al,'dd/mm/yyyy')||
                                                              ' Importi sommati al periodo: dal '||to_char(CUR_E0.dal,'dd/mm/yyyy')||
                                                              ' Al: '||to_char(CUR_E0.al,'dd/mm/yyyy')||
                                                              ' Comp.Fisse: '||nvl(CUR_30.comp_fisse,0)||
                                                              ' Comp.Acc.: '||nvl(cur_30.comp_accessorie,0)||
                                                              ' Ipn.Pens.: '||nvl(cur_30.ipn_pens_periodo,0)||
                                                              ' Contr.Pens.: '||nvl(cur_30.contr_pens_periodo,0)||
                                                              ' Ipn.TFS: '||nvl(cur_30.ipn_tfs,0)||
                                                              ' Contr.TFS '||nvl(cur_30.contr_tfs,0)||
                                                              ' Ipn.TFR: '||nvl(cur_30.ipn_tfr,0)||
                                                              ' Contr.TFR '||nvl(cur_30.contr_ipn_tfr,0)||
                                                              ' Teorico TFR '||nvl(cur_30.retr_teorico_tfr,0)||
                                                              ' Ipn. Credito '||nvl(cur_30.ipn_cassa_credito,0)||
                                                              ' Contr. Credito '||nvl(cur_30.contr_cassa_credito,0)
                  );
              END LOOP;
         update denuncia_dma ddma
            set ( cassa_pensione, cassa_previdenza, cassa_credito, cassa_enpdedp
                , comp_fisse, comp_accessorie, magg_l165
                , comp_18, ind_non_a, iis_conglobata, ipn_pens_periodo
                , contr_pens_periodo, contr_su_eccedenza, ipn_tfs, contr_tfs
                , ipn_tfr, contr_ipn_tfr, ult_ipn_tfr, contr_ult_ipn_tfr
                , ipn_cassa_credito, contr_cassa_credito, contr_enpdedp
                , tredicesima, retr_teorico_tfr, retr_utile_tfr
                , quota_solidarieta_l166, contr_solidarieta_l166
                , retr_l135, contr_solidarieta_l135, contr_pens_calamita, contr_prev_calamita
                , sanzione_pensione, sanzione_previdenza, sanzione_credito, sanzione_enpdedp
                )  =
                (select nvl(ddma.cassa_pensione,cassa_pensione)
                      , nvl(ddma.cassa_previdenza,cassa_previdenza)
                      , nvl(ddma.cassa_credito,cassa_credito)
                      , nvl(ddma.cassa_enpdedp,cassa_enpdedp)
                      , nvl(ddma.comp_fisse,0)         + nvl(comp_fisse,0)
                      , nvl(ddma.comp_accessorie,0)    + nvl(comp_accessorie,0)
                      , nvl(ddma.magg_l165,0)          + nvl(magg_l165,0)
                      , nvl(ddma.comp_18,0)            + nvl(comp_18,0)
                      , nvl(ddma.ind_non_a,0)          + nvl(ind_non_a,0)
                      , nvl(ddma.iis_conglobata,0)     + nvl(iis_conglobata,0)
                      , nvl(ddma.ipn_pens_periodo,0)   + nvl(ipn_pens_periodo,0)
                      , nvl(ddma.contr_pens_periodo,0) + nvl(contr_pens_periodo,0)
                      , nvl(ddma.contr_su_eccedenza,0) + nvl(contr_su_eccedenza,0)
                      , nvl(ddma.ipn_tfs,0)            + nvl(ipn_tfs,0)
                      , nvl(ddma.contr_tfs,0)          + nvl(contr_tfs,0)
                      , nvl(ddma.ipn_tfr,0)            + nvl(ipn_tfr,0)
                      , nvl(ddma.contr_ipn_tfr,0)      + nvl(contr_ipn_tfr,0)
                      , nvl(ddma.ult_ipn_tfr,0)        + nvl(ult_ipn_tfr,0)
                      , nvl(ddma.contr_ult_ipn_tfr,0)  + nvl(contr_ult_ipn_tfr,0)
                      , nvl(ddma.ipn_cassa_credito,0)  + nvl(ipn_cassa_credito,0)
                      , nvl(ddma.contr_cassa_credito,0) + nvl(contr_cassa_credito,0)
                      , nvl(ddma.contr_enpdedp,0)       + nvl(contr_enpdedp,0)
                      , nvl(ddma.tredicesima,0)         + nvl(tredicesima,0)
                      , nvl(ddma.retr_teorico_tfr,0)    + nvl(retr_teorico_tfr,0)
                      , nvl(ddma.retr_utile_tfr,0)      + nvl(retr_utile_tfr,0)
                      , nvl(ddma.quota_solidarieta_l166,0) + nvl(quota_solidarieta_l166,0)
                      , nvl(ddma.contr_solidarieta_l166,0) + nvl(contr_solidarieta_l166,0)
                      , nvl(ddma.retr_l135,0)              + nvl(retr_l135,0)
                      , nvl(ddma.contr_solidarieta_l135,0) + nvl(contr_solidarieta_l135,0)
                      , nvl(ddma.contr_pens_calamita,0)    + nvl(contr_pens_calamita,0)
                      , nvl(ddma.contr_prev_calamita,0)    + nvl(contr_prev_calamita,0)
                      , nvl(ddma.sanzione_pensione,0)      + nvl(sanzione_pensione,0)
                      , nvl(ddma.sanzione_previdenza,0)    + nvl(sanzione_previdenza,0)
                      , nvl(ddma.sanzione_credito,0)       + nvl(sanzione_credito,0)
                      , nvl(ddma.sanzione_enpdedp,0)       + nvl(sanzione_enpdedp,0)
                   from denuncia_dma
                  where ddma_id = CUR_30.ddma_id
                )
          where anno                = D_anno
            and mese                = D_mese
            and ci                  = CUR_CI_DMA.ci
            and rilevanza           = 'V1'
            and competenza          = 'C'
            and dal                 =
               (select max(dal) from denuncia_dma
                 where anno       = D_anno
                   and mese       = D_mese
                   and ci         = CUR_CI_DMA.ci
                   and rilevanza  = 'V1'
                   and competenza = 'C'
               )
         ;
        END;
        BEGIN
          select dal,al
            into DDMA30_dal,DDMA30_al
            from denuncia_dma
          where anno                = D_anno
            and mese                = D_mese
            and ci                  = CUR_CI_DMA.ci
            and rilevanza           = 'V1'
            and competenza          = 'C'
            and dal                 =
               (select max(dal) from denuncia_dma
                 where anno       = D_anno
                   and mese       = D_mese
                   and ci         = CUR_CI_DMA.ci
                   and rilevanza  = 'V1'
                   and competenza = 'C'
               )
         ;
        EXCEPTION WHEN NO_DATA_FOUND THEN null;
        END;
        IF DDMA30_segnala = 0 THEN
           D_prg_err_3 := nvl(D_prg_err_3,0) + 1;
           INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES (prenotazione,1,D_prg_err_3
                  ,'P05495','Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||
                            ' Dal: '||to_char(CUR_30.dal,'dd/mm/yyyy')||
                            ' Al: '||to_char(CUR_30.al,'dd/mm/yyyy')||
                            ' Comp.Fisse: '||nvl(CUR_30.comp_fisse,0)||
                            ' Comp.Acc.: '||nvl(cur_30.comp_accessorie,0)||
                            ' Ipn.Pens.: '||nvl(cur_30.ipn_pens_periodo,0)||
                            ' Contr.Pens.: '||nvl(cur_30.contr_pens_periodo,0)||
                            ' Ipn.TFS: '||nvl(cur_30.ipn_tfs,0)||
                            ' Contr.TFS '||nvl(cur_30.contr_tfs,0)||
                            ' Ipn.TFR: '||nvl(cur_30.ipn_tfr,0)||
                            ' Contr.TFR '||nvl(cur_30.contr_ipn_tfr,0)||
                            ' Teorico TFR '||nvl(cur_30.retr_teorico_tfr,0)||
                            ' Ipn. Credito '||nvl(cur_30.ipn_cassa_credito,0)||
                            ' Contr. Credito '||nvl(cur_30.contr_cassa_credito,0)
                  );
        ELSE
           D_prg_err_3 := nvl(D_prg_err_3,0) + 1;
           INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
           VALUES (prenotazione,1,D_prg_err_3
                  ,'P05495','Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||
                            ' Dal: '||to_char(CUR_30.dal,'dd/mm/yyyy')||
                            ' Al: '||to_char(CUR_30.al,'dd/mm/yyyy')||
                            ' Importi sommati al periodo: dal '||to_char(DDMA30_dal,'dd/mm/yyyy')||
                            ' Al: '||to_char(DDMA30_al,'dd/mm/yyyy')||
                            ' Comp.Fisse: '||nvl(CUR_30.comp_fisse,0)||
                            ' Comp.Acc.: '||nvl(cur_30.comp_accessorie,0)||
                            ' Ipn.Pens.: '||nvl(cur_30.ipn_pens_periodo,0)||
                            ' Contr.Pens.: '||nvl(cur_30.contr_pens_periodo,0)||
                            ' Ipn.TFS: '||nvl(cur_30.ipn_tfs,0)||
                            ' Contr.TFS '||nvl(cur_30.contr_tfs,0)||
                            ' Ipn.TFR: '||nvl(cur_30.ipn_tfr,0)||
                            ' Contr.TFR '||nvl(cur_30.contr_ipn_tfr,0)||
                            ' Teorico TFR '||nvl(cur_30.retr_teorico_tfr,0)||
                            ' Ipn. Credito '||nvl(cur_30.ipn_cassa_credito,0)||
                            ' Contr. Credito '||nvl(cur_30.contr_cassa_credito,0)
                  );
           delete from denuncia_dma
            where anno = D_anno
              and mese = D_mese
              and ci   = CUR_CI_DMA.ci
              and rilevanza          = 'E0'
              and tipo_servizio      = '30'
              and (   nvl(comp_fisse,0)          != 0
                   or nvl(comp_accessorie,0)     != 0
                   or nvl(magg_l165,0)           != 0
                   or nvl(comp_18,0)             != 0
                   or nvl(ind_non_a,0)           != 0
                   or nvl(iis_conglobata,0)      != 0
                   or nvl(ipn_pens_periodo,0)    != 0
                   or nvl(contr_pens_periodo,0)  != 0
                   or nvl(contr_su_eccedenza,0)  != 0
                   or nvl(ipn_tfs,0)             != 0
                   or nvl(contr_tfs,0)           != 0
                   or nvl(ipn_tfr,0)             != 0
                   or nvl(contr_ipn_tfr,0)       != 0
                   or nvl(ult_ipn_tfr,0)         != 0
                   or nvl(contr_ult_ipn_tfr,0)   != 0
                   or nvl(ipn_cassa_credito,0)   != 0
                   or nvl(contr_cassa_credito,0) != 0
                   or nvl(contr_enpdedp,0)       != 0
                   or nvl(tredicesima,0)         != 0
                   or nvl(quota_solidarieta_l166,0) != 0
                   or nvl(contr_solidarieta_l166,0) != 0
                   or nvl(retr_l135,0)              != 0
                   or nvl(contr_solidarieta_l135,0) != 0
                   or nvl(contr_pens_calamita,0)    != 0
                   or nvl(contr_prev_calamita,0)    != 0
                   or nvl(sanzione_pensione,0)      != 0
                   or nvl(sanzione_previdenza,0)    != 0
                   or nvl(sanzione_credito,0)       != 0
                   or nvl(sanzione_enpdedp,0)       != 0
                   or nvl(retr_teorico_tfr,0)       != 0)
           ;
        END IF;
       END LOOP;
       commit;
END;
-- Controllo Valori negativi
  V_controllo := null;
 BEGIN
  select 'X'
    into V_controllo
    from dual
   where exists
       ( select 'X'
           from denuncia_dma
          where ci = CUR_CI_DMA.ci
            and anno = D_anno
            and mese = D_mese
            and rilevanza = 'E0'
            and ( nvl(comp_fisse,0) < 0  or nvl(comp_accessorie,0) < 0
             or   nvl(magg_l165,0)  < 0  or nvl(comp_18,0)        < 0
             or   nvl(ind_non_a,0)  < 0  or nvl(iis_conglobata,0) < 0
             or   nvl(ipn_pens_periodo,0)    < 0 or   nvl(contr_pens_periodo,0) < 0
             or   nvl(contr_su_eccedenza,0)  < 0 or   nvl(ipn_tfs,0)            < 0
             or   nvl(contr_tfs,0)           < 0 or   nvl(ipn_tfr,0)            < 0
             or   nvl(contr_ipn_tfr,0)       < 0 or   nvl(ult_ipn_tfr,0)        < 0
             or   nvl(contr_ult_ipn_tfr,0)   < 0 or   nvl(ipn_cassa_credito,0)  < 0
             or   nvl(contr_cassa_credito,0) < 0 or   nvl(contr_enpdedp,0)      < 0
             or   nvl(tredicesima,0)            < 0 or   nvl(retr_teorico_tfr,0) < 0
             or   nvl(retr_utile_tfr,0)         < 0 or   nvl(quota_solidarieta_l166,0) < 0
             or   nvl(contr_solidarieta_l166,0) < 0 or   nvl(retr_l135,0)           < 0
             or   nvl(contr_solidarieta_l135,0) < 0 or   nvl(contr_pens_calamita,0) < 0
             or   nvl(contr_prev_calamita,0)    < 0 or   nvl(sanzione_pensione,0)   < 0
             or   nvl(sanzione_previdenza,0)    < 0 or   nvl(sanzione_credito,0)    < 0
             or   nvl(sanzione_enpdedp,0)       < 0
                )
          );
 EXCEPTION WHEN NO_DATA_FOUND THEN null;
 END;
 IF V_controllo = 'X' THEN
    D_prg_err_4 := nvl(D_prg_err_4,0) + 1;
    INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
    VALUES (prenotazione,1,D_prg_err_4,' ',null);
    D_prg_err_4 := nvl(D_prg_err_4,0) + 1;
    INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
    VALUES (prenotazione,1,D_prg_err_4,'P05840','Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||' - Verificare Importi');
 END IF;
-- fine controllo negativi
-- controllo assicurazioni
   FOR CUR_CASSE IN
      (select dal,al
         from denuncia_dma ddma
        where anno       = D_anno
          and mese       = D_mese
          and ci         = CUR_CI_DMA.ci
          and rilevanza  = 'V1'
          and competenza = 'C'
          and exists
             (select 'x' from denuncia_dma
               where anno = D_anno
                 and mese = D_mese
                 and ci   = ddma.ci
                 and gestione   = ddma.gestione
                 and previdenza = ddma.previdenza
                 and rilevanza  = 'V1'
                 and competenza = 'P'
                 and dal       <= ddma.dal
                 and al        >= ddma.al
                 and (   nvl(cassa_pensione,' ')   != nvl(ddma.cassa_pensione,' ')
                      or nvl(cassa_previdenza,' ') != nvl(ddma.cassa_previdenza,' ')
                      or nvl(cassa_credito,' ')    != nvl(ddma.cassa_credito,' ')
                      or nvl(cassa_enpdedp,' ')    != nvl(ddma.cassa_enpdedp,' ')
                     )
                 and tipo_aliquota = ddma.tipo_aliquota
             )
      ) LOOP
          D_prg_err := nvl(D_prg_err,0) + 1;
          INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,1,D_prg_err,' ',null);
          D_prg_err := nvl(D_prg_err,0) + 1;
          INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,1,D_prg_err,'P05493',substr('Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||
                                                              ' Dal: '||to_char(CUR_CASSE.dal,'dd/mm/yyyy')||
                                                              ' Al: '||to_char(CUR_CASSE.al,'dd/mm/yyyy')
                                                             ,1,50));
        END LOOP;
-- fine controllo assicurazioni
-- controllo riferimento su V1
   FOR CUR_RIF_V1 IN
      (select dal,al
         from denuncia_dma ddma
        where anno       = D_anno
          and mese       = D_mese
          and ci         = CUR_CI_DMA.ci
          and rilevanza  = 'V1'
          and riferimento is null
      ) LOOP
          D_prg_err_2 := nvl(D_prg_err_2,0) + 1;
          INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,1,D_prg_err_2,' ',null);
          D_prg_err_2 := nvl(D_prg_err_2,0) + 1;
          INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,1,D_prg_err_2,'P05494',substr('Per il CI: '||TO_CHAR(CUR_CI_DMA.ci)||
                                                              ' Dal: '||to_char(CUR_RIF_V1.dal,'dd/mm/yyyy')||
                                                              ' Al: '||to_char(CUR_RIF_V1.al,'dd/mm/yyyy')
                                                             ,1,50));
        END LOOP;
        commit;
-- fine controllo riferimento su V1
CTR_IPN_PENS (prenotazione, passo, D_anno, D_mese, CUR_CI_DMA.ci, D_prg_err_6);
END LOOP; -- CUR_CI_DMA
TITOLI_SEGNALAZIONI (prenotazione,passo);
/*BEGIN
  update a_prenotazioni
     set prossimo_passo = 91,
         errore         = 'P00108'
   where no_prenotazione = prenotazione
     and exists (select 'x'
                   from a_appoggio_stampe
                  where no_prenotazione = prenotazione)
  ;
 IF SQL%NOTFOUND THEN
  update a_prenotazioni
     set prossimo_passo = 93,
         errore         = 'P00109'
   where no_prenotazione = prenotazione
     and exists (select 'x'
                   from a_segnalazioni_errore
                  where no_prenotazione = prenotazione)
  ;
 END IF;
 END;
*/
END;
EXCEPTION WHEN USCITA THEN
--TITOLI_SEGNALAZIONI (prenotazione,passo);
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
commit;
end;
end;
end;
/
