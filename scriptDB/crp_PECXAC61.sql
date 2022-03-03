CREATE OR REPLACE PACKAGE PECXAC61 IS

/******************************************************************************
 NOME:          PECXAC61
 DESCRIZIONE:   caricamento Casella 61 per 770/07

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  29/03/2007 MS     Prima Emissione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECXAC61 IS
 
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 29/03/2007';
   END VERSIONE;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE
--
-- Depositi e Contatori Vari
--
  P_anno            number;
  P_tipo            varchar2(1);
  P_ci              number;

  D_ente            varchar2(4);
  D_ambiente        varchar2(8);
  D_utente          varchar2(8);

  V_errore          varchar2(6);

  USCITA EXCEPTION;
  BEGIN
--
-- Estrazione Parametri di Selezione della Prenotazione
--
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
      SELECT substr(valore,1,4)
        INTO P_anno
        FROM a_parametri
       WHERE no_prenotazione = prenotazione
         AND parametro       = 'P_ANNO'
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT anno
          INTO P_anno
          FROM riferimento_fine_anno
         WHERE rifa_id = 'RIFA'
        ;
    END;
    BEGIN
      select valore
        into P_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_TIPO'
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           P_tipo := null;
    END;
    BEGIN
      select valore
        into P_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_CI'
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_ci := 0;
    END;

    IF nvl(P_ci,0) = 0 and P_tipo = 'S' THEN
         V_errore := 'A05721';
     RAISE USCITA;
    ELSIF nvl(P_ci,0) != 0 and P_tipo = 'T' THEN
         V_errore := 'A05721';
         RAISE USCITA; 
    END IF;

    BEGIN
       FOR CUR_CI IN
        (SELECT radi.ci
              , min(radi.anno)              anno
           FROM rapporti_diversi            radi
              , denuncia_fiscale            defs
              , rapporti_individuali        rain
          WHERE radi.ci  = defs.ci
            and rain.ci  = defs.ci
            and ( P_tipo = 'T' 
               or P_tipo = 'S' and defs.ci = P_ci )
            and defs.anno = P_anno
            and defs.rilevanza = 'T'
            and radi.rilevanza = 'E'
            and nvl(defs.c57,0) + nvl(defs.c58,0) + nvl(defs.c59,0) + nvl(defs.c60,0) != 0
            and ( rain.cc is null
               or exists ( select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = d_utente
                              and competenza  = 'CI'
                              and oggetto     = rain.cc
                           )
                )
          group by radi.ci
         ) LOOP
  	  BEGIN
           UPDATE denuncia_fiscale
              SET C145 = CUR_CI.anno
            WHERE ci = CUR_CI.ci
              AND anno = P_anno
              AND rilevanza = 'T'
            ;
          END;
	 COMMIT;
       END LOOP; --CUR_CI
    END;
EXCEPTION
     WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = 'A05721'
       where no_prenotazione = prenotazione;
      commit;
  END;
END;
END;
/
