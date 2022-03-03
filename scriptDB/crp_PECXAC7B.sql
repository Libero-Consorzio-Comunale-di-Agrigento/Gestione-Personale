CREATE OR REPLACE PACKAGE PECXAC7B IS

/******************************************************************************
 NOME:          PECXAC7B
 DESCRIZIONE:   caricamento Casella 7 Bis per CUD e per 770 2007

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  12/02/2007 MS     Prima Emissione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECXAC7B IS
 
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 12/02/2007';
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

  D_acconto_com     NUMBER(15,2) := 0;
  D_riga            number := 0;
  D_cod_errore      varchar2(6);
  D_precisazione    varchar2(200) := '';

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
         D_cod_errore := 'A05721';
     RAISE USCITA;
    ELSIF nvl(P_ci,0) != 0 and P_tipo = 'T' THEN
         D_cod_errore := 'A05721';
         RAISE USCITA; 
    END IF;

    BEGIN
       FOR CUR_CI IN
        (SELECT defs.ci
           FROM denuncia_fiscale defs
          WHERE defs.anno = P_anno
            and ( P_tipo = 'T' 
               or P_tipo = 'S' and defs.ci = P_ci )
            and defs.rilevanza = 'T'
            and exists
               ( select 'x'
                   from rapporti_individuali rain
                  where rain.ci = defs.ci
                     and (   rain.cc is null
                          or exists
                             ( select 'x'
                                from a_competenze
                               where ente        = d_ente
                                 and ambiente    = d_ambiente
                                 and utente      = d_utente
                                 and competenza  = 'CI'
                                 and oggetto     = rain.cc
                             )
                        )
              )
         ) LOOP

         D_acconto_com := 0;
-- dbms_output.put_line('ci: '||CUR_CI.ci );

         BEGIN
          select nvl(imp_tot,0)
            into D_acconto_com
            from informazioni_retributive
           where ci = CUR_CI.ci
             and to_char(dal,'yyyy') = P_anno+1
             and voce in ( select codice 
                             from voci_economiche
                            where specifica = 'ADD_COM_AC'
                         );
         EXCEPTION 
              WHEN NO_DATA_FOUND THEN
                   D_acconto_com := 0;
              WHEN TOO_MANY_ROWS THEN
                   D_acconto_com := 0;
                   D_riga       := D_riga +1; 
                   D_cod_errore   := 'P05728';  -- Esiste Informazione Retributiva collegata a
                   D_precisazione := substr(' CI: '||TO_CHAR(CUR_CI.ci)||' - Controllare AINRA',1,200);
                   INSERT INTO a_segnalazioni_errore
                   (no_prenotazione,passo,progressivo,errore,precisazione)
                   select prenotazione,1,D_riga,D_cod_errore,D_precisazione
                     from dual
                    where not exists ( select 'x'
                                         from a_segnalazioni_errore
                                        where no_prenotazione = prenotazione
                                          and passo = 1
                                          and errore = D_cod_errore
                                          and precisazione = D_precisazione
                                     );
         END;

         IF nvl(D_acconto_com,0) != 0 THEN
         BEGIN
           UPDATE denuncia_fiscale
              SET C32 = D_acconto_com
            WHERE ci  = CUR_CI.ci
              AND anno = P_anno
              AND rilevanza = 'T'
            ;
         END;
         ELSE
           null;
         -- segnalazione
         END IF; -- controllo su D_acconto_com
	  COMMIT;
       END LOOP; -- CUR_CI
    END;

   FOR CUR1 in 
    ( select distinct ci
        from informazioni_retributive inre
       where to_char(dal,'yyyy') = P_anno+1
         and P_tipo = 'T' 
         and voce in ( select codice 
                         from voci_economiche
                        where automatismo = 'ADD_COM_AC'
                     )
         and sub = substr(P_anno+1,3,2)
         and not exists ( select 'x'
                            from denuncia_fiscale
                           where anno = P_anno
                             and ci   = inre.ci
                             and rilevanza = 'T'
                         )
    )
   LOOP
    BEGIN
       D_riga       := D_riga +1; 
       D_cod_errore   := 'P01070';  -- Individuo non presente
       D_precisazione := substr(' - Manca archiviazione fiscale per CI: '||TO_CHAR(CUR1.ci),1,200);
       INSERT INTO a_segnalazioni_errore
       (no_prenotazione,passo,progressivo,errore,precisazione)
       select prenotazione,1,D_riga,D_cod_errore,D_precisazione
         from dual
        where not exists ( select 'x'
                             from a_segnalazioni_errore
                            where no_prenotazione = prenotazione
                              and passo = 1
                              and errore = D_cod_errore
                              and precisazione = D_precisazione
                         );
    END;
   END LOOP; -- cur1 per segnalazioni 
   
EXCEPTION
     WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo  = 93
           , errore          = D_cod_errore
       where no_prenotazione = prenotazione;
      commit;
  END;
END;
END PECXAC7B;
/
