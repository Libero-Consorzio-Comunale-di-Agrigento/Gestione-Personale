CREATE OR REPLACE PACKAGE paamirge IS
/******************************************************************************
 NOME:        PAAMIRGE
 DESCRIZIONE: Emissione report di verifica errori di Integrita` Referenziale.


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
 1.1  14/02/2006 MS     Introduzione controllo RARS
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY paamirge IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 14/02/2006';
END VERSIONE;
PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS

  temp varchar2(1);
BEGIN

--
--NAME
--  VERIFICA INTEGRITA` REFERENZIALE GIURIDICO ED ECONOMICO
--
--FILE
--  PAAMIRGE
--
--PURPOSE
--  Emissione report di verifica errori di Integrita` Referenziale.
--
--TOP TITLE
--
--
--DESCRIPTION
--  Esegue start dei package previsti.
--
--
--MODIFIED
--
--

--
--Inizio operazioni di Funzione
--
--   Base-Dati di INTEGRATA condivisa
--

--- BILA - Archivio Bilancio per estrapolazione Impegni di Spesa
--         Non esistono foreign keys
--- CECO - Centri di imputazione del costo
--         Non esistono foreign keys
--- CORR - Protocollo della corrispondenza ricevuta e spedita
--         Non esistono foreign keys
--- SOGG - Soggetto Fiscale per codifica Beneficiari e Debitori
--         Non esistono foreign keys

--
--   Base-Dati di ANAGRAFE-MATRICOLARE condivisa
--

--- ANAG - Anagrafe storica del personale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ANAG'
					    and status = 'INVALID'
				    )
  ;
  p_anag.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- CFIS - Controllo dei codici fiscali
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_CFIS'
					    and status = 'INVALID'
				    )
  ;
  p_cfis.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;	  
--- CAPR - Categorie sociali che godono di trattamento particolare
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_CAPR'
					    and status = 'INVALID'
				    )
  ;
  p_capr.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;	  
--- CLRA - Classi di rapporto individuale con l"ente
--         Non esistono foreign keys
--- CONP - Tipologie di condizione non professionale
--         Non esistono foreign keys
--- CONV - Estremi inerenti convocazione o corrispondenza con l"individuo
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_CONV'
					    and status = 'INVALID'
				    )
  ;
  p_conv.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;	
--- FAMI - Dati anagrafici dei familiari dell"individuo
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_FAMI'
					    and status = 'INVALID'
				    )
  ;
  p_fami.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;	
--- GRRA - Riferimenti specifici di raggruppamento aggregazione di personale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_GRRA'
					    and status = 'INVALID'
				    )
  ;
  p_grra.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- INDI - Identificazioni univoche degli individui in anagrafe storica
--         Non esistono foreign keys
--- PARE - Relazioni di parentela dei familiari dell"individuo
--         Non esistono foreign keys
--- RAIN - Rapporti dell"individuo con l"ente
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RAIN'
					    and status = 'INVALID'
				    )
  ;
  p_rain.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- STCI - Tipi di stato civile anagrafico
--         Non esistono foreign keys
--- TIST - Titoli di studio intesi come livello di scolarita`
--         Non esistono foreign keys

--
--   Base-Dati GIURIDICO-MATRICOLARE
--

--- ASTE - Tipologie di astensione dal servizio
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ASTE'
					    and status = 'INVALID'
				    )
  ;
  p_aste.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;  
--- ATTI - Attivita` e Aree di attivita` o Discipline e Aree funzionali
             p_atti.main(prenotazione,passo);
--- CADO - Tabella di servizio per prospetti di Dotazione del Personale
--         Non esistono foreign keys
--- CARR - Carriere professionali
--         Non esistono foreign keys
--- CERT - Certificati di servizio elaborabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_CERT'
					    and status = 'INVALID'
				    )
  ;
  p_cert.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- CLFU - Classificazioni funzionali di spesa
--         Non esistono foreign keys
--- CONT - Contratti di lavoro gestiti nella retribuzione
--         Non esistono foreign keys
--- COST - Attributi storici dei contratti di lavoro gestiti
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_COST'
					    and status = 'INVALID'
				    )
  ;
  p_cost.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- DOGI - Documenti e altri titoli non di carriera dell"individuo
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_DOGI'
					    and status = 'INVALID'
				    )
  ;
  p_dogi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- ENTE - Dati anagrafici e fiscali dell"ente
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ENTE'
					    and status = 'INVALID'
				    )
  ;
  p_ente.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- EVGI - Eventi e motivazioni che identificano periodi e documenti giuridici
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_EVGI'
					    and status = 'INVALID'
				    )
  ;
  p_evgi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- EVRA - Eventi e motivazioni di inizio e termine del rapporto di lavoro
--         Non esistono foreign keys
--- FIGU - Figure professionali o mansioni specifiche
--         Non esistono foreign keys
--- FIGI - Attributi storici delle figure professionali
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_FIGI'
					    and status = 'INVALID'
				    )
  ;
  p_figi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- FOCE - Formule verbali preformattate da includere nei certificati
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_FOCE'
					    and status = 'INVALID'
				    )
  ;
  p_foce.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;  
--- GEST - Dati anagrafici e fiscali delle gestioni nell"ambito dell"ente
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_GEST'
					    and status = 'INVALID'
				    )
  ;
  p_gest.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;  
--- PEGI - Periodi giuridici di rapporto di lavoro, di servizio e di assenza
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_PEGI'
					    and status = 'INVALID'
				    )
  ;
  p_pegi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;  
--- POSI - Posizioni giuridiche e di stato matricolare
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_POSI'
					    and status = 'INVALID'
				    )
  ;
  p_posi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;  
--- POFU - Posizioni funzionali nell"ambito del profilo professionale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_POFU'
					    and status = 'INVALID'
				    )
  ;
  p_pofu.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;  
--- PRPR - Profili professionali in ambito contrattuale
--         Non esistono foreign keys
--- QUAL - Qualifiche retributive che differenziano il trattamento economico
--         Non esistono foreign keys
--- QUGI - Attributi storici delle qualifiche retributive
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_QUGI'
					    and status = 'INVALID'
				    )
  ;
  p_qugi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- RAGI - Identificazione dei rapporti con caratteristiche giuridiche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RAGI'
					    and status = 'INVALID'
				    )
  ;
  p_ragi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- RIFU - Ripartizioni funzionali di spesa per suddivisione settoriale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RIFU'
					    and status = 'INVALID'
				    )
  ;
  p_rifu.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- RUOL - Ruoli di ripartizione funzionale della spesa in bilancio
--         Non esistono foreign keys
--- SEDE - Sedi fisiche o dislocazioni nell"ambito dell"ente
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SEDE'
					    and status = 'INVALID'
				    )
  ;
  p_sede.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- SEPR - Sedi di emissione dei provvedimenti deliberativi
--         Non esistono foreign keys
--- SETT - Suddivisione settoriale nell"ambito delle gestioni dell"ente
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SETT'
					    and status = 'INVALID'
				    )
  ;
  p_sett.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- SODO - Sottoclassificazione degli eventi giuridici di documentazione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SODO'
					    and status = 'INVALID'
				    )
  ;
  p_sodo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;		 
--- TEFO - Righe testo preformattato formule da includere nei certificati
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_TEFO'
					    and status = 'INVALID'
				    )
  ;
  p_tefo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--
--   Base-Dati ECONOMICO-CONTABILE
--

--- AGFA - Valori aggiuntivi agli scaglioni di reddito per nucleo familiare
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_AGFA'
					    and status = 'INVALID'
				    )
  ;
  p_agfa.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- ASCO - Assegnazioni contabili diverse dalla assegnazione giuridica
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ASCO'
					    and status = 'INVALID'
				    )
  ;
  p_asco.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
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
--- ASIN - Posizioni assicurative INAIL
--         Non esistono foreign keys
--- BAVO - Caratteristiche storiche delle voci economiche tabellari
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_BAVO'
					    and status = 'INVALID'
				    )
  ;
  p_bavo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- BAVP - Voci economiche tabellari per Bilancio di Previsione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_BAVP'
					    and status = 'INVALID'
				    )
  ;
  p_bavp.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- CACO - Calcolo transitorio dei movimenti contabili di retribuzione
--         Non esistono foreign keys
--- CARE - Calcolo transitorio dei periodi retributivi
--         Non esistono foreign keys
--- CAVA - Calcolo transitorio valori contabili per Estrazioni Parametriche
--         Non esistono foreign keys
--- CALE - Calendario delle giornate festive e feriali
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_CALE'
					    and status = 'INVALID'
				    )
  ;
  p_cale.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- CAFA - Carichi familiari individuali per assegni e detrazioni fiscali
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_CAFA'
					    and status = 'INVALID'
				    )
  ;
  p_cafa.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- CLBU - Riclassificazioni di spesa per analisi di previsione
--         Non esistono foreign keys
--- CLDE - Classificazioni tipologie di deliberazione variabili retributive
--         Non esistono foreign keys
--- COBI - Codici di ripartizione economica della spesa in bilancio
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_COBI'
					    and status = 'INVALID'
				    )
  ;
  p_cobi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- COFA - Condizioni di situazione familiare per assegni
--         Non esistono foreign keys
--- COFI - Condizioni di situazione familiare per detrazioni fiscali
--         Non esistono foreign keys
--- COVO - Caretteristiche storiche di contabilizzazione della voce
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_COVO'
					    and status = 'INVALID'
				    )
  ;
  p_covo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- DERE - Estemi deliberativi dei provvedimenti retribuzione variabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_DERE'
					    and status = 'INVALID'
				    )
  ;
  p_dere.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- DELI - Protocollo dei provvedimenti deliberativi emessi
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_DELI'
					    and status = 'INVALID'
				    )
     AND EXISTS     (select 1 
                       from ente
                      where ente.delibere = 'SI'
                    )
  ;
  p_deli.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- CAAF - Archivio Dati Centri Assistenza Fiscale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_CAAF'
					    and status = 'INVALID'
				    )
  ;
  p_caaf.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- DECP - Archivio Denuncia Cassa Pensione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_DECP'
					    and status = 'INVALID'
				    )
  ;
  p_decp.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- DIID - Archivio Importi Denuncia I.N.A.D.E.L.
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_DIID'
					    and status = 'INVALID'
				    )
  ;
  p_diid.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- DEID - Archivio Denuncia I.N.A.D.E.L.
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_DEID'
					    and status = 'INVALID'
				    )
  ;
  p_deid.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- D1IS - Archivio Denuncia I.N.P.S. O1/M
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_D1IS'
					    and status = 'INVALID'
				    )
  ;
  p_d1is.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- D3IS - Archivio Denuncia I.N.P.S. O3/M
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_D3IS'
					    and status = 'INVALID'
				    )
  ;
  p_d3is.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- DEFI - Importi di detrazione fiscale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_DEFI'
					    and status = 'INVALID'
				    )
  ;
  p_defi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- ESCO - Parametri di estrazione del Riepilogo Contributi
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESCO'
					    and status = 'INVALID'
				    )
  ;
  p_esco.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- ESCR - Creazione temporanea dei Report parametrici personalizzabili
--         Non esistono foreign keys
--- ESEL - Parametri di estrazione degli Elenchi di dettaglio voci
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESEL'
					    and status = 'INVALID'
				    )
  ;
  p_esel.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- ESGE - Selezioni di estrazione degli elaborati di Gestione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESGE'
					    and status = 'INVALID'
				    )
  ;
  p_esge.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- ESMO - Parametri di estrazione dei Moduli di Raccolta Variabili
--         Non esistono foreign keys
--- ESNC - Note da indicare nelle righe di dettaglio del Cedolino
--         Non esistono foreign keys
--- ESON - Parametri di estrazione degli elenchi di dettaglio Oneri
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESON'
					    and status = 'INVALID'
				    )
  ;
  p_eson.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;  
--- ESRE - Definizione dei Report parametrici personalizzabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESRE'
					    and status = 'INVALID'
				    )
  ;
  p_esre.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- ESRC - Voci contabili dei Report parametrici su valori contabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESRC'
					    and status = 'INVALID'
				    )
  ;
  p_esrc.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- ESRM - Voci contabili da raccogliere nei Moduli Raccolta Variabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESRM'
					    and status = 'INVALID'
				    )
  ;
  p_esrm.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- ESVC - Colonne previste dai Report parametrici su valori contabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESVC'
					    and status = 'INVALID'
				    )
  ;
  p_esvc.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- ESVO - Condizioni di estrazione automatica delle voci contabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ESVO'
					    and status = 'INVALID'
				    )
  ;
  p_esvo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- IMVO - Caratteristiche di imponibilita` della voce economica
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_IMVO'
					    and status = 'INVALID'
				    )
  ;
  p_imvo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- IMCO - Archivio di transito movimenti contabili in Bilancio
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_IMCO'
					    and status = 'INVALID'
				    )
  ;
  p_imco.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- INEX - Informazioni contabili particolari o di rilevanza annuale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_INEX'
					    and status = 'INVALID'
				    )
  ;
  p_inex.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- INRE - Informazioni sulle voci e sui valori che compongono la retribuzione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_INRE'
					    and status = 'INVALID'
				    )
  ;
  p_inre.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- INRP - Informazioni voci che compongono retribuzione Bilancio Previsione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_INRP'
					    and status = 'INVALID'
				    )
  ;
  p_inrp.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- INEC - Periodi di inquadramento sulle voci a progressione economica
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_INEC'
					    and status = 'INVALID'
				    )
  ;
  p_inec.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- ISCR - Istituti di credito e identificativi di soggetti fiscali
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_ISCR'
					    and status = 'INVALID'
				    )
  ;
  p_iscr.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- MENS - Mensilita` retributive elaborabili
--         Non esistono foreign keys
--- MESE - Mesi dell"anno
--         Non esistono foreign keys
--- MOBP - Movimenti sintetici di Bilancio di Previsione
--         Non esistono foreign keys
--- MOCO - Movimenti contabili che costituiscono la retribuzione individuale
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_MOCO'
					    and status = 'INVALID'
				    )
  ;
  p_moco.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END; 
--- MOCP - Movimenti contabili retribuzione per Bilancio di Previsione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_MOCP'
					    and status = 'INVALID'
				    )
  ;
  p_mocp.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- MOFI - Informazioni fiscali sintetiche riassuntive dei movimenti contabili
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_MOFI'
					    and status = 'INVALID'
				    )
  ;
  p_mofi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- PERE - Caratteristiche contabili dei periodi giuridici retribuiti
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_PERE'
					    and status = 'INVALID'
				    )
  ;
  p_pere.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- PERP - Caratteristiche contabili dei periodi giuridici Bilancio Previsione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_PERP'
					    and status = 'INVALID'
				    )
  ;
  p_perp.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- PREC - Validita` dei periodi di voce a progressione attribuita
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_PREC'
					    and status = 'INVALID'
				    )
  ;
  p_prec.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- QUGE - Attribuzione qualifica identificativa per Gestione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_QUGE'
					    and status = 'INVALID'
				    )
  ;
  p_quge.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- QUMI - Codifica Ministeriale delle Qualifiche retributive
--         Non esistono foreign keys
--- RAMO - Moduli di Raccolta Variabili caricati
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RAMO'
					    and status = 'INVALID'
				    )
  ;
  p_ramo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RARM - Personalizzazione dei Moduli di Raccolta Variabili caricati
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RARM'
					    and status = 'INVALID'
				    )
  ;
  p_rarm.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RAVA - Valori dei Moduli di Raccolta Variabili caricati
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RAVA'
					    and status = 'INVALID'
				    )
  ;
  p_rava.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RARE - Identificazione dei rapporti con caratteristiche retributive
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RARE'
					    and status = 'INVALID'
				    )
  ;
  p_rare.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RARS - Identificazione dei rapporti storici con caratteristiche retributive
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
                      where USER_OBJECTS.OBJECT_NAME like 'P_RARS'
			and status = 'INVALID'
                     )
  ;
  p_rars.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- REAT - Attributi degli oggetti previsti dalle Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_REAT'
					    and status = 'INVALID'
				    )
  ;
  p_reat.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- REAC - Abbinamento tra chiavi e attributi previsti Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_REAC'
					    and status = 'INVALID'
				    )
  ;
  p_reac.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- REAE - Attributi richiesti dalle Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_REAE'
					    and status = 'INVALID'
				    )
  ;
  p_reae.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RECH - Chiavi di ordinamento previste dalle Estrazioni Parametriche
--         Non esistono foreign keys
--- REES - Chiavi di ordinamento richieste sulle Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_REES'
					    and status = 'INVALID'
				    )
  ;
  p_rees.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RECE - Condizioni di estrazione richieste sulle Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RECE'
					    and status = 'INVALID'
				    )
  ;
  p_rece.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RECO - Condizioni relazione oggetti previsti da Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RECO'
					    and status = 'INVALID'
				    )
  ;
  p_reco.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- REOG - Oggetti previsti dalle Estrazioni Parametriche
--         Non esistono foreign keys
--- REOE - Oggetti richiesti dalle Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_REOE'
					    and status = 'INVALID'
				    )
  ;
  p_reoe.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RERO - Relazione tra gli oggetti delle Estrazioni Parametriche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RERO'
					    and status = 'INVALID'
				    )
  ;
  p_rero.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RIEL - Registrazione di riferimento per le elaborazioni IMMEDIATE
--         Non esistono foreign keys
--- RIFA - Dati di riferimento per le elaborazioni di Fine Anno
--         Non esistono foreign keys
--- RIRE - Periodo di riferimento per la retribuzione mensile
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RIRE'
					    and status = 'INVALID'
				    )
  ;
  p_rire.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RQMI - Figure professionali che compongono le Qualifiche Ministeriali
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RQMI'
					    and status = 'INVALID'
				    )
  ;
  p_rqmi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RTVO - Righe di composizione della tariffa della voce retributiva
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RTVO'
					    and status = 'INVALID'
				    )
  ;
  p_rtvo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RICO - Imputazione contabile delle ripartizione economiche e funzionali
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RICO'
					    and status = 'INVALID'
				    )
  ;
  p_rico.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- RIVO - Caratteristiche storiche delle voci retributive a ritenuta
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_RIVO'
					    and status = 'INVALID'
				    )
  ;
  p_rivo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- SCAF - Scaglioni di reddito familiare per assegno di nucleo familiare
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SCAF'
					    and status = 'INVALID'
				    )
  ;
  p_scaf.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- SCDF - Scaglioni fiscali di imponibile per calcolo ulteriore detrazione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SCDF'
					    and status = 'INVALID'
				    )
  ;
  p_scdf.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- SCFI - Scaglioni fiscali di imponibile per calcolo imposta
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SCFI'
					    and status = 'INVALID'
				    )
  ;
  p_scfi.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- SOPR - Data di sospensione delle progressioni economiche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SOPR'
					    and status = 'INVALID'
				    )
  ;
  p_sopr.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- SPOR - Sportelli bancari degli istituti di credito
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_SPOR'
					    and status = 'INVALID'
				    )
  ;
  p_spor.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- TAVO - Caratteristiche storiche delle tariffe di voci retributive
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_TAVO'
					    and status = 'INVALID'
				    )
  ;
  p_tavo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- TICA - Tipi di calendario applicabili sulle sedi di lavoro
--         Non esistono foreign keys
--- TOVO - Totalizzazioni delle voci retributive su voci di accumulo
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_TOVO'
					    and status = 'INVALID'
				    )
  ;
  p_tovo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- TRCO - Abbinamento del trattamento previdenziale su profilo e posizione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_TRCO'
					    and status = 'INVALID'
				    )
  ;
  p_trco.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- TRPR - Trattamento previdenziale e contributivo da applicare
--         Non esistono foreign keys
--- VAAF - Periodi di validita` degli importi di assegno per nucleo familiare
--         Non esistono foreign keys
--- VAFI - Periodi di validita` di scaglioni e detrazioni fiscali
--         Non esistono foreign keys
--- VBVO - Importi delle voci tabellari base
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VBVO'
					    and status = 'INVALID'
				    )
  ;
  p_vbvo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- VBVP - Importi delle voci tabellari base per Bilancio di Previsione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VBVP'
					    and status = 'INVALID'
				    )
  ;
  p_vbvp.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- VPVO - Importi delle voci tabellari a progressione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VPVO'
					    and status = 'INVALID'
				    )
  ;
  p_vpvo.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- VPVP - Importo delle voci tabellari a progressione Bilancio di Previsione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VPVP'
					    and status = 'INVALID'
				    )
  ;
  p_vpvp.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- VOCO - Sub-classificazione contabile delle voci economiche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VOCO'
					    and status = 'INVALID'
				    )
  ;
  p_voco.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- VODE - Voci retributive attivate da una classe di deliberazione
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VODE'
					    and status = 'INVALID'
				    )
  ;
  p_vode.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- VOEC - Caratteristiche fondamentali delle voci economiche
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VOEC'
					    and status = 'INVALID'
				    )
  ;
  p_voec.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;
--- VOIN - Voci retributive abbinate alle posizioni assicurative INAIL
BEGIN
  SELECT 'X'
    INTO temp
    FROM dual
   WHERE NOT EXISTS (select * 
                       from USER_OBJECTS 
					  where USER_OBJECTS.OBJECT_NAME like 'P_VOIN'
					    and status = 'INVALID'
				    )
  ;
  p_voin.main(prenotazione,passo);
EXCEPTION
  WHEN no_data_found THEN
    null;
END;

END MAIN;
END paamirge;
/

