CREATE OR REPLACE PACKAGE P00UPDPP IS
/******************************************************************************
 NOME:          P00UPDPP
 DESCRIZIONE:   Fase standard per modificare la sequenza di esecuzione
                dei passi procedurali
 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  30/01/2006 MS     prima Emissione per mod. CUD/2006 ( att.7892 )
 1.1  10/02/2006 GM     modifica gestione stampa terza pagina del CUD 2006 (att. 14700)
 1.2  19/01/2007 GM     Modifica gestione prog. storici CUD 2006 (att. 19092)
 1.3  13/02/2007 GM     Modifica gestione terza pagina per stampa A_B (la terza pagina a parte non è prevista)
 1.4  26/09/2007 GM     Aggiunto trattamento stampe PECSETAN - PECSETDI
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY P00UPDPP IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.4 del 26/09/2007';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  D_ente               VARCHAR(4);
  D_ambiente           VARCHAR(8);
  D_utente             VARCHAR(8);
  D_tipo               VARCHAR(4);
  D_voce_menu          VARCHAR(8);
  D_terza_pagina       VARCHAR(1);
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
  BEGIN
    select voce_menu
      into D_voce_menu
      from a_prenotazioni
     where no_prenotazione = prenotazione
   ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_voce_menu := NULL;
  END;

  BEGIN
    SELECT valore
      INTO D_tipo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO_DESFORMAT'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_tipo := 'PDF';
  END;

  BEGIN
    SELECT valore
      INTO D_terza_pagina
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TERZA_PAGINA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_terza_pagina := 'P';
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
    IF D_voce_menu = 'PECSMCU6' THEN
       IF D_tipo = 'PDF' and passo = 8 THEN
          update a_prenotazioni
             set prossimo_passo = 9
           where no_prenotazione = prenotazione;
       ELSIF D_tipo = 'A_B' and passo = 8 THEN
          update a_prenotazioni
             set prossimo_passo = 10
           where no_prenotazione = prenotazione;
       ELSIF D_terza_pagina = 'P' and passo = 4 and D_tipo = 'PDF' THEN
          update a_prenotazioni
             set prossimo_passo = 5
           where no_prenotazione = prenotazione;
       ELSIF (D_tipo = 'A_B' or D_terza_pagina = 'S') and passo = 4 THEN
          update a_prenotazioni
             set prossimo_passo = 6
           where no_prenotazione = prenotazione;
       ELSIF passo = 10 and D_tipo = 'PDF' THEN
          update a_prenotazioni
             set prossimo_passo = 12
           where no_prenotazione = prenotazione;
      END IF;
      commit;
   ELSIF D_voce_menu = 'PECCUD06' THEN
      IF    D_terza_pagina = 'P' and passo = 3 THEN
          update a_prenotazioni
             set prossimo_passo = 4
           where no_prenotazione = prenotazione;
      ELSIF D_terza_pagina = 'S' and passo = 3 THEN
          update a_prenotazioni
             set prossimo_passo = 5
           where no_prenotazione = prenotazione;
      END IF;
      commit;
   ELSIF D_voce_menu in ('PECSETAN','PECSETDI') THEN
      IF D_tipo = 'PDF' and passo = 1 THEN
          update a_prenotazioni
             set prossimo_passo = 4
           where no_prenotazione = prenotazione;
      ELSIF D_tipo = 'A_D' and passo = 3 THEN     
          update a_prenotazioni
             set prossimo_passo = 5
           where no_prenotazione = prenotazione;                 
      END IF;
      commit;      
   END IF;
  END;
END;
END;
END;
/
