CREATE OR REPLACE PACKAGE paamirpo IS
/******************************************************************************
 NOME:        PAAMIRPO
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

CREATE OR REPLACE PACKAGE BODY paamirpo IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
-- 
-- NAME
--   VERIFICA INTEGRITA` REFERENZIALE PIANTA ORGANICA        
-- 
-- FILE
--   PAAMIRPO
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
-- MODIFIED
-- 
--
-- Inizio operazioni di Funzione   
--

--   
--    Base-Dati PIANTA ORGANICA
--   

--    Base-Dati gia` condivisa dal Sistema Integrato del Personale

-- - POOR - Identificazione del Posto in Organico
--          Non esistono foreign keys     
-- - POPI - Caratteristiche storiche del Posto in Pianta Organica
             p_popi.main(prenotazione,passo);

--    Base-Dati proprietaria non condivisa dal Sistema Integrato del Personale

-- - CAPO - Tabella di servizio per prospetti di Pianta Organica
--          Non esistono foreign keys     
-- - RIOR - Data di riferimento della situazione organica
--          Non esistono foreign keys
-- - TRPO - Identificazione della provenienza di un posto in organico
             p_trpo.main(prenotazione,passo) ;
-- - RRLI - Righe di composizione della Ripartizione Linguistica
             p_rrli.main(prenotazione,passo); 
-- - RILI - Ripartizione percentuale di copertura posti in organico
             p_rili.main(prenotazione,passo) ;

--
-- Fine operazioni di Funzione     
--

END MAIN;
END paamirpo;
/

