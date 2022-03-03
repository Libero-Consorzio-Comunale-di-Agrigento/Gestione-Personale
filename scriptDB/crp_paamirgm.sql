CREATE OR REPLACE PACKAGE paamirgm IS
/******************************************************************************
 NOME:        PAAMIRGM
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

CREATE OR REPLACE PACKAGE BODY paamirgm IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
-- 
-- NAME
--   VERIFICA INTEGRITA` REFERENZIALE GIURIDICO_MATRICOLARE  
-- 
-- FILE
--   PAAMIRGM
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

-- - CECO - Centri di imputazione del costo
--          Non esistono foreign keys
-- - CORR - Protocollo della corrispondenza ricevuta e spedita
--          Non esistono foreign keys
-- - DELI - Protocollo dei provvedimenti deliberativi emessi
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
--    Base-Dati GIURIDICO-MATRICOLARE
--   

-- - ASTE - Tipologie di astensione dal servizio
             p_aste.main(prenotazione,passo); 
-- - ATTI - Attivita` e Aree di attivita` o Discipline e Aree funzionali
             p_atti.main(prenotazione,passo); 
-- - CADO - Tabella di servizio per prospetti di Dotazione del Personale
--          Non esistono foreign keys     
-- - CARR - Carriere professionali
--          Non esistono foreign keys
-- - CERT - Certificati di servizio elaborabili
             p_cert.main(prenotazione,passo); 
-- - CLFU - Classificazioni funzionali di spesa
--          Non esistono foreign keys
-- - CONT - Contratti di lavoro gestiti nella retribuzione
--          Non esistono foreign keys
-- - COST - Attributi storici dei contratti di lavoro gestiti
             p_cost.main(prenotazione,passo); 
-- - DOGI - Documenti e altri titoli non di carriera dell"individuo
             p_dogi.main(prenotazione,passo); 
-- - ENTE - Dati anagrafici e fiscali dell"ente
             p_ente.main(prenotazione,passo); 
-- - EVGI - Eventi e motivazioni che identificano periodi e documenti giuridici
             p_evgi.main(prenotazione,passo); 
-- - EVRA - Eventi e motivazioni di inizio e termine del rapporto di lavoro
--          Non esistono foreign keys
-- - FIGU - Figure professionali o mansioni specifiche
--          Non esistono foreign keys
-- - FIGI - Attributi storici delle figure professionali
             p_figi.main(prenotazione,passo); 
-- - FOCE - Formule verbali preformattate da includere nei certificati
             p_foce.main(prenotazione,passo); 
-- - GEST - Dati anagrafici e fiscali delle gestioni nell"ambito dell"ente
             p_gest.main(prenotazione,passo); 
-- - PEGI - Periodi giuridici di rapporto di lavoro, di servizio e di assenza
             p_pegi.main(prenotazione,passo); 
-- - POSI - Posizioni giuridiche e di stato matricolare
             p_posi.main(prenotazione,passo); 
-- - POFU - Posizioni funzionali nell"ambito del profilo professionale
             p_pofu.main(prenotazione,passo); 
-- - PRPR - Profili professionali in ambito contrattuale
--          Non esistono foreign keys
-- - QUAL - Qualifiche retributive che differenziano il trattamento economico
--          Non esistono foreign keys
-- - QUGI - Attributi storici delle qualifiche retributive
             p_qugi.main(prenotazione,passo); 
-- - RAGI - Identificazione dei rapporti con caratteristiche giuridiche
             p_ragi.main(prenotazione,passo); 
-- - RIFU - Ripartizioni funzionali di spesa per suddivisione settoriale
             p_rifu.main(prenotazione,passo); 
-- - RUOL - Ruoli di ripartizione funzionale della spesa in bilancio
--          Non esistono foreign keys
-- - SEDE - Sedi fisiche o dislocazioni nell"ambito dell"ente
             p_sede.main(prenotazione,passo); 
-- - SEPR - Sedi di emissione dei provvedimenti deliberativi
--          Non esistono foreign keys
-- - SETT - Suddivisione settoriale nell"ambito delle gestioni dell"ente
             p_sett.main(prenotazione,passo); 
-- - SODO - Sottoclassificazione degli eventi giuridici di documentazione
             p_sodo.main(prenotazione,passo); 
-- - TEFO - Righe testo preformattato formule da includere nei certificati
             p_tefo.main(prenotazione,passo); 

END MAIN;
END paamirgm;
/

