CREATE OR REPLACE PACKAGE PECXAC40 IS

/******************************************************************************
 NOME:          PECXAC40
 DESCRIZIONE:   caricamento Casella 40 per 770/06

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  29/05/2006 MS     Prima Emissione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECXAC40 IS
 
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 29/05/2006';
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

  D_c1              number := 0;
  D_c2              number := 0;
  D_c40             number := 0;

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
        (SELECT inex.ci
              , nvl(inex.ipn_ded,0)         ipn_ded
              , nvl(inex.ipn_ded_magg,0)    ipn_ded_magg
           FROM informazioni_extracontabili inex
              , rapporti_individuali rain
          WHERE rain.ci = inex.ci
            and ( P_tipo = 'T' 
               or P_tipo = 'S' and inex.ci = P_ci )
            and inex.anno = P_anno
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
            and abs(nvl(inex.ipn_ded,0)) + abs(nvl(inex.ipn_ded_magg,0)) != 0
         ) LOOP

            D_c1   := 0;
            D_c2   := 0;
            D_c40  := 0;

-- dbms_output.put_line('ci: '||CUR_CI.ci );

         IF nvl(CUR_CI.ipn_ded_magg,0) != 0 THEN
            D_c40 := nvl(CUR_CI.ipn_ded_magg,0);
         ELSIF nvl(CUR_CI.ipn_ded,0) != 0 THEN
            BEGIN
              select nvl(c1,0), nvl(c2,0)
                into D_c1, D_c2
                from denuncia_fiscale
               where rilevanza = 'T'
                 and anno      = P_anno
                 and ci        = CUR_CI.ci
                 and nvl(c1,0) + nvl(c2,0) != 0
              ;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;
            D_c40 := nvl(CUR_CI.ipn_ded,0) - nvl(D_c1,0) - nvl(D_c2,0);
         END IF;

         IF nvl(D_c40,0) != 0 THEN
 	  BEGIN
           UPDATE denuncia_fiscale
              SET C40  = D_c40
            WHERE ci = CUR_CI.ci
              AND anno = P_anno
              AND rilevanza = 'T'
            ;
           IF SQL%ROWCOUNT = 0 THEN
           LOCK TABLE DENUNCIA_FISCALE IN EXCLUSIVE MODE NOWAIT;
           INSERT INTO denuncia_fiscale 
           ( ANNO, CI, RILEVANZA, C40 , UTENTE, TIPO_AGG, DATA_AGG )
           VALUES ( P_anno, CUR_CI.ci , 'T'
                  , D_c40
                  , D_utente, null, SYSDATE)
            ;
           END IF;
          END;
         END IF; -- controllo su d_c40
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
