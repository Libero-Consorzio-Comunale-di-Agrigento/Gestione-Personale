CREATE OR REPLACE PACKAGE paamirpa IS

/******************************************************************************
 NOME:          crp_paamirpa
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

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

CREATE OR REPLACE PACKAGE BODY paamirpa IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
--
-- NAME
--   VERIFICA INTEGRITA` REFERENZIALE PRESENZE ASSENZE
--
-- FILE
--   PAAMIRPA
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

-- - AUPA - Automatismi collettivi di Presenza / Assenza
p_aupa.main(prenotazione,passo);
-- - CTEV - Categorie di Evento di Presenza / Assenza
p_ctev.main(prenotazione,passo);
-- - CAEV - Causali di Evento di Presenza / Assenza
p_caev.main(prenotazione,passo);
-- - EAPA - Eventi Automatici Individuali di Presenza / Assenza
p_eapa.main(prenotazione,passo);
-- - EVPA - Eventi individuali di Presenza /Assenza
p_evpa.main(prenotazione,passo);
-- - RAPA - Rapporti di Presenza
p_rapa.main(prenotazione,passo);
-- - RFCA - Righe formula di valorizzazione Causali a Valore
p_rfca.main(prenotazione,passo);
-- - VAPA - Importi contabili di Causali a Valore
p_vapa.main(prenotazione,passo);
-- - VCEV - Voci contabili da valorizzare per Causali a Valore
p_vcev.main(prenotazione,passo);

-- - CAGI - Causali abbinate ai Giustificativi di Rilevazione Presenze
p_cagi.main(prenotazione,passo);
-- - CLPA - Eventi individuali a Classe di Evento
p_clpa.main(prenotazione,passo);
-- - RPPA - Righe Prospetti caricamento o stampa di Presenza / Assenza
p_rppa.main(prenotazione,passo);
-- - RICA - Ripartizione o composizione delle Classi di Causali
p_rica.main(prenotazione,passo);
-- - RIMO - Ripartizione Motivi di sottocodifica Classi di evento
p_rimo.main(prenotazione,passo);
-- - TOCA - Totalizzazione delle Causali nelle Categorie
p_toca.main(prenotazione,passo);

END MAIN;
END paamirpa;
/

