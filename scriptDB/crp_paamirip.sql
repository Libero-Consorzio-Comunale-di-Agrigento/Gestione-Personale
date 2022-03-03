CREATE OR REPLACE PACKAGE paamirip IS
/******************************************************************************
 NOME:        PAAMIRIP
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

CREATE OR REPLACE PACKAGE BODY paamirip IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
 
-- NAME
--   VERIFICA INTEGRITA` REFERENZIALE INCENTIVAZIONE PRODUTTIVITA`
 
-- FILE
--   PAAMIRIP
 
-- PURPOSE
--   Emissione report di verifica errori di Integrita` Referenziale.         
-- DESCRIPTION
--   Esegue  lancio dei package
 

-- EQIP-- Equipe l'incentivazione della produttivita`
--        Non esistono foreign-keys
-- EQST-- Storico di Equipe l'incentivazione della produttivita`
--            p_eqst.main(prenotazione,passo); 
-- PAAP-- Parti applicative
--        Non esistono foreign-keys
-- GRIP-- Gruppi per l'incentivazione della produttivita`
--        Non esistono foreign-keys
-- QUIP-- Storico di Qualifiche per incentivazione della produttivita`
              p_quip.main(prenotazione,passo);
-- AEIP-- Attribuzione Equipe per l'incentivazione della produttivita`
              p_aeip.main(prenotazione,passo);
-- PRIP-- Progetti di incentivazione della produttivita`
--        Non esistono foreign-keys
-- APIP-- Applicazioni dei Progetti di incentivazione della produttivita`
              p_apip.main(prenotazione,passo);
-- IPIP-- Impegni dei Progetti di incentivazione della produttivita`
              p_ipip.main(prenotazione,passo);
-- ASIP-- Assegnazioni degli Individui ai Progetti di incentivazione
              p_asip.main(prenotazione,passo);
-- AQIP-- Attribuzione delle Quote ai Progetti di incentivazione
              p_aqip.main(prenotazione,passo);
-- TRIP-- Tetti retributivi individuali per l'incentivazione
              p_trip.main(prenotazione,passo);
-- RAIP-- Rapporti individui-applicazioni per l'incentivazione
              p_raip.main(prenotazione,passo);
-- MOIP-- Movimenti liquidati di incentivazione della produttivita`
              p_moip.main(prenotazione,passo);
-- VEIP-- Versioni per Ipotesi di Spesa
--        Non esistono foreign-keys
-- EIIP-- Equipe per Ipotesi di Spesa
--        Non esistono foreign-keys
-- ISIP-- Movimenti di Ipotesi di Spesa per Progetti di incentivazione
              p_isip.main(prenotazione,passo);
END MAIN;
END paamirip;
/

