CREATE OR REPLACE PACKAGE paamirec IS
/******************************************************************************
 NOME:        PAAMIREC
 DESCRIZIONE: Emissione report di verifica errori di Integrità Referenziale.
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: Il passo 1 contiene il numero di prenotazione
              Il passo 2 contiene il numero del passo procedurale
              Il passo 3 contiene l'identificativo della stampa
              Il passo 4 contiene l'identificativo del file di output
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY paamirec IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
  temp varchar2(1);
BEGIN
-- 
-- NAME
--   VERIFICA INTEGRITA` REFERENZIALE ECONOMICO-CONTABILE    
-- 
-- FILE
--   PAAMIREC
-- 
-- PURPOSE
--   Emissione report di verifica errori di Integrita` Referenziale.         
-- 
-- TOP TITLE
--   
-- 
-- DESCRIPTION
--   Esegue lancio dei package
-- 

--
-- Inizio operazioni di Funzione   
--

--   
--    Base-Dati di INTEGRATA condivisa
--   

-- - BILA - Archivio Bilancio per estrapolazione Impegni di Spesa
--          Non esistono foreign keys     
-- - CECO - Centri di imputazione del costo
--          Non esistono foreign keys
-- - CORR - Protocollo della corrispondenza ricevuta e spedita
--          Non esistono foreign keys
-- - DELI - Protocollo dei provvedimenti deliberativi emessi
--          Non esistono foreign keys
-- - SOGG - Soggetto Fiscale per codifica Beneficiari e Debitori
--          Non esistono foreign keys

--   
--    Base-Dati di ANAGRAFE-MATRICOLARE condivisa
--   

-- - ANAG - Anagrafe storica del personale
             p_anag.main(prenotazione,passo);
-- - CAPR - Categorie sociali che godono di trattamento particolare
             p_capr.main(prenotazione,passo); 
-- - CLRA - Classi di rapporto individuale con l"ente
--          Non esistono foreign keys
-- - CONP - Tipologie di condizione non professionale
--          Non esistono foreign keys
-- - CONV - Estremi inerenti convocazione o corrispondenza con l"individuo
             p_conv.main(prenotazione,passo); 
-- - FAMI - Dati anagrafici dei familiari dell"individuo
             p_fami.main(prenotazione,passo); 
-- - GRRA - Riferimenti specifici di raggruppamento aggregazione di personale
             p_grra.main(prenotazione,passo); 
-- - INDI - Identificazioni univoche degli individui in anagrafe storica
--          Non esistono foreign keys
-- - PARE - Relazioni di parentela dei familiari dell"individuo
--          Non esistono foreign keys
-- - RAIN - Rapporti dell"individuo con l"ente
             p_rain.main(prenotazione,passo); 
-- - STCI - Tipi di stato civile anagrafico
--          Non esistono foreign keys
-- - TIST - Titoli di studio intesi come livello di scolarita`
--          Non esistono foreign keys

--   
--    Base-Dati ECONOMICO-CONTABILE
--   

-- - AGFA - Valori aggiuntivi agli scaglioni di reddito per nucleo familiare
             p_agfa.main(prenotazione,passo); 
-- - ASCO - Assegnazioni contabili diverse dalla assegnazione giuridica
             p_asco.main(prenotazione,passo); 
-- - ASFA - Importi di assegno per nucleo familiare
--- ASFA - Importi di assegno per nucleo familiare
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ASFA'
					    and status = 'INVALID'
				    )
  ;
  p_asfa.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
-- - ASIN - Posizioni assicurative INAIL
--          Non esistono foreign keys
-- - BAVO - Caratteristiche storiche delle voci economiche tabellari
             p_bavo.main(prenotazione,passo); 
-- - BAVP - Voci economiche tabellari per Bilancio di Previsione
             p_bavp.main(prenotazione,passo); 
-- - CACO - Calcolo transitorio dei movimenti contabili di retribuzione
--          Non esistono foreign keys
-- - CARE - Calcolo transitorio dei periodi retributivi
--          Non esistono foreign keys
-- - CAVA - Calcolo transitorio valori contabili per Estrazioni Parametriche
--          Non esistono foreign keys
-- - CALE - Calendario delle giornate festive e feriali
             p_cale.main(prenotazione,passo); 
-- - CAFA - Carichi familiari individuali per assegni e detrazioni fiscali
             p_cafa.main(prenotazione,passo); 
-- - CLBU - Riclassificazioni di spesa per analisi di previsione
--          Non esistono foreign keys
-- - CLDE - Classificazioni tipologie di deliberazione variabili retributive
--          Non esistono foreign keys
-- - COBI - Codici di ripartizione economica della spesa in bilancio
             p_cobi.main(prenotazione,passo); 
-- - COFA - Condizioni di situazione familiare per assegni
--          Non esistono foreign keys
-- - COFI - Condizioni di situazione familiare per detrazioni fiscali
--          Non esistono foreign keys
-- - COVO - Caretteristiche storiche di contabilizzazione della voce
             p_covo.main(prenotazione,passo); 
-- - DERE - Estemi deliberativi dei provvedimenti retribuzione variabili
             p_dere.main(prenotazione,passo); 
-- - CAAF - Archivio Dati Centri Assistenza Fiscale
             p_caaf.main(prenotazione,passo); 
-- - DECP - Archivio Denuncia Cassa Pensione
             p_decp.main(prenotazione,passo); 
-- - DIID - Archivio Importi Denuncia I.N.A.D.E.L.
             p_diid.main(prenotazione,passo); 
-- - DEID - Archivio Denuncia I.N.A.D.E.L.
             p_deid.main(prenotazione,passo); 
-- - D1IS - Archivio Denuncia I.N.P.S. O1/M
             p_d1is.main(prenotazione,passo); 
-- - D3IS - Archivio Denuncia I.N.P.S. O3/M
             p_d3is.main(prenotazione,passo); 
-- - DEFI - Importi di detrazione fiscale
             p_defi.main(prenotazione,passo); 
-- - ESCO - Parametri di estrazione del Riepilogo Contributi
             p_esco.main(prenotazione,passo); 
-- - ESCR - Creazione temporanea dei Report parametrici personalizzabili
--          Non esistono foreign keys
-- - ESEL - Parametri di estrazione degli Elenchi di dettaglio voci
             p_esel.main(prenotazione,passo); 
-- - ESGE - Selezioni di estrazione degli elaborati di Gestione
             p_esge.main(prenotazione,passo); 
-- - ESMO - Parametri di estrazione dei Moduli di Raccolta Variabili
--          Non esistono foreign keys
-- - ESNC - Note da indicare nelle righe di dettaglio del Cedolino
--          Non esistono foreign keys
-- - ESON - Parametri di estrazione degli elenchi di dettaglio Oneri
             p_eson.main(prenotazione,passo); 
-- - ESRE - Definizione dei Report parametrici personalizzabili
             p_esre.main(prenotazione,passo); 
-- - ESRC - Voci contabili dei Report parametrici su valori contabili
             p_esrc.main(prenotazione,passo); 
-- - ESRM - Voci contabili da raccogliere nei Moduli Raccolta Variabili
             p_esrm.main(prenotazione,passo); 
-- - ESVC - Colonne previste dai Report parametrici su valori contabili
             p_esvc.main(prenotazione,passo); 
-- - ESVO - Condizioni di estrazione automatica delle voci contabili
             p_esvo.main(prenotazione,passo); 
-- - IMVO - Caratteristiche di imponibilita` della voce economica
             p_imvo.main(prenotazione,passo); 
-- - IMCO - Archivio di transito movimenti contabili in Bilancio
             p_imco.main(prenotazione,passo); 
-- - INEX - Informazioni contabili particolari o di rilevanza annuale
             p_inex.main(prenotazione,passo); 
-- - INRE - Informazioni sulle voci e sui valori che compongono la retribuzione
             p_inre.main(prenotazione,passo); 
-- - INRP - Informazioni voci che compongono retribuzione Bilancio Previsione
             p_inrp.main(prenotazione,passo); 
-- - INEC - Periodi di inquadramento sulle voci a progressione economica
             p_inec.main(prenotazione,passo); 
-- - ISCR - Istituti di credito e identificativi di soggetti fiscali
             p_iscr.main(prenotazione,passo); 
-- - MENS - Mensilita` retributive elaborabili
--          Non esistono foreign keys
-- - MESE - Mesi dell"anno
--          Non esistono foreign keys
-- - MOBP - Movimenti sintetici di Bilancio di Previsione
--          Non esistono foreign keys
-- - MOCO - Movimenti contabili che costituiscono la retribuzione individuale
             p_moco.main(prenotazione,passo); 
-- - MOCP - Movimenti contabili retribuzione per Bilancio di Previsione
             p_mocp.main(prenotazione,passo); 
-- - MOFI - Informazioni fiscali sintetiche riassuntive dei movimenti contabili
             p_mofi.main(prenotazione,passo); 
-- - PERE - Caratteristiche contabili dei periodi giuridici retribuiti
             p_pere.main(prenotazione,passo); 
-- - PERP - Caratteristiche contabili dei periodi giuridici Bilancio Previsione
             p_perp.main(prenotazione,passo); 
-- - PREC - Validita` dei periodi di voce a progressione attribuita
             p_prec.main(prenotazione,passo); 
-- - QUGE - Attribuzione qualifica identificativa per Gestione
             p_quge.main(prenotazione,passo); 
-- - QUMI - Codifica Ministeriale delle Qualifiche retributive
--          Non esistono foreign keys
-- - RAMO - Moduli di Raccolta Variabili caricati
             p_ramo.main(prenotazione,passo); 
-- - RARM - Personalizzazione dei Moduli di Raccolta Variabili caricati
             p_rarm.main(prenotazione,passo); 
-- - RAVA - Valori dei Moduli di Raccolta Variabili caricati
             p_rava.main(prenotazione,passo); 
-- - RARE - Identificazione dei rapporti con caratteristiche retributive
             p_rare.main(prenotazione,passo); 
-- - REAT - Attributi degli oggetti previsti dalle Estrazioni Parametriche
             p_reat.main(prenotazione,passo); 
-- - REAC - Abbinamento tra chiavi e attributi previsti Estrazioni Parametriche
             p_reac.main(prenotazione,passo); 
-- - REAE - Attributi richiesti dalle Estrazioni Parametriche
             p_reae.main(prenotazione,passo); 
-- - RECH - Chiavi di ordinamento previste dalle Estrazioni Parametriche
--          Non esistono foreign keys
-- - REES - Chiavi di ordinamento richieste sulle Estrazioni Parametriche
             p_rees.main(prenotazione,passo); 
-- - RECE - Condizioni di estrazione richieste sulle Estrazioni Parametriche
             p_rece.main(prenotazione,passo); 
-- - RECO - Condizioni relazione oggetti previsti da Estrazioni Parametriche
             p_reco.main(prenotazione,passo); 
-- - REOG - Oggetti previsti dalle Estrazioni Parametriche
--          Non esistono foreign keys
-- - REOE - Oggetti richiesti dalle Estrazioni Parametriche
             p_reoe.main(prenotazione,passo); 
-- - RERO - Relazione tra gli oggetti delle Estrazioni Parametriche
             p_rero.main(prenotazione,passo); 
-- - RIEL - Registrazione di riferimento per le elaborazioni IMMEDIATE
--          Non esistono foreign keys
-- - RIFA - Dati di riferimento per le elaborazioni di Fine Anno
--          Non esistono foreign keys
-- - RIRE - Periodo di riferimento per la retribuzione mensile
             p_rire.main(prenotazione,passo); 
-- - RQMI - Figure professionali che compongono le Qualifiche Ministeriali
             p_rqmi.main(prenotazione,passo); 
-- - RTVO - Righe di composizione della tariffa della voce retributiva
             p_rtvo.main(prenotazione,passo); 
-- - RICO - Imputazione contabile delle ripartizione economiche e funzionali
             p_rico.main(prenotazione,passo); 
-- - RIVO - Caratteristiche storiche delle voci retributive a ritenuta
             p_rivo.main(prenotazione,passo); 
-- - SCAF - Scaglioni di reddito familiare per assegno di nucleo familiare
             p_scaf.main(prenotazione,passo); 
-- - SCDF - Scaglioni fiscali di imponibile per calcolo ulteriore detrazione
             p_scdf.main(prenotazione,passo); 
-- - SCFI - Scaglioni fiscali di imponibile per calcolo imposta
             p_scfi.main(prenotazione,passo); 
-- - SOPR - Data di sospensione delle progressioni economiche
             p_sopr.main(prenotazione,passo); 
-- - SPOR - Sportelli bancari degli istituti di credito
             p_spor.main(prenotazione,passo); 
-- - TAVO - Caratteristiche storiche delle tariffe di voci retributive
             p_tavo.main(prenotazione,passo); 
-- - TICA - Tipi di calendario applicabili sulle sedi di lavoro
--          Non esistono foreign keys
-- - TOVO - Totalizzazioni delle voci retributive su voci di accumulo
             p_tovo.main(prenotazione,passo); 
-- - TRCO - Abbinamento del trattamento previdenziale su profilo e posizione
             p_trco.main(prenotazione,passo); 
-- - TRPR - Trattamento previdenziale e contributivo da applicare
--          Non esistono foreign keys
-- - VAAF - Periodi di validita` degli importi di assegno per nucleo familiare
--          Non esistono foreign keys
-- - VAFI - Periodi di validita` di scaglioni e detrazioni fiscali
--          Non esistono foreign keys
-- - VBVO - Importi delle voci tabellari base
             p_vbvo.main(prenotazione,passo); 
-- - VBVP - Importi delle voci tabellari base per Bilancio di Previsione
             p_vbvp.main(prenotazione,passo); 
-- - VPVO - Importi delle voci tabellari a progressione
             p_vpvo.main(prenotazione,passo); 
-- - VPVP - Importo delle voci tabellari a progressione Bilancio di Previsione
             p_vpvp.main(prenotazione,passo); 
-- - VOCO - Sub-classificazione contabile delle voci economiche
             p_voco.main(prenotazione,passo); 
-- - VODE - Voci retributive attivate da una classe di deliberazione
             p_vode.main(prenotazione,passo); 
-- - VOEC - Caratteristiche fondamentali delle voci economiche
             p_voec.main(prenotazione,passo); 
-- - VOIN - Voci retributive abbinate alle posizioni assicurative INAIL
             p_voin.main(prenotazione,passo); 


END MAIN;
END paamirec;
/

