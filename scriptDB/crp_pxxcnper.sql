CREATE OR REPLACE PACKAGE PXXCNPER IS

/******************************************************************************
 NOME:          PXXCNPER 
 DESCRIZIONE:   Archiviazione NOTE_CUD personalizzate Modello CUD e 770

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Gestisce la nota AL per i COCO ( rif. BO13725 )

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  25/01/2007 MS     Prima Emissione

******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PXXCNPER IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 25/01/2007';
   END VERSIONE;

 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  D_ente               VARCHAR(4);
  D_ambiente           VARCHAR(8);
  D_utente             VARCHAR(8);
  D_gruppo_ling        VARCHAR(1);  -- per multilinguismo
  D_anno               VARCHAR(4);
  D_ini_a              VARCHAR(8);
  D_fin_a              VARCHAR(8);
  D_ini_as             VARCHAR(8);
  D_fin_as             VARCHAR(8);
  D_gestione           VARCHAR(4);
  D_rapporto           VARCHAR(4);
  P_sfasato            VARCHAR2(1);
  P_periodi_effettivi  VARCHAR2(2);
  D_tipo               VARCHAR(1);
  D_ci                 NUMBER(8);
  D_sequenza           NUMBER(8) := 0;
  D_riga               NUMBER := 0;
  D_errore             VARCHAR(200);
  D_note_al            VARCHAR(2000);
  D_note_TFR           VARCHAR(2000);
  D_intesta_periodi    VARCHAR(2000); 
  D_note_periodi       VARCHAR(2000);
  D_descr_rapporto     VARCHAR(30);
  D_descr_tempo_det    VARCHAR(40);
  D_conta_rapporti     NUMBER;
  D_conta_periodi      NUMBER;
  V_errore             varchar2(6) := null;
  V_controllo          varchar2(1) := null ;
  USCITA               EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
  BEGIN
    SELECT valore
      INTO D_tipo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_tipo := NULL;
  END;
-- dbms_output.put_Line('Tipo: '||D_tipo);

  BEGIN
    SELECT valore
      INTO D_ci
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ci := 0;
  END;
  V_errore := null;
  IF nvl(D_ci,0) = 0 and D_tipo = 'S' THEN
     V_errore := 'A05721';
     RAISE USCITA;
  ELSIF nvl(D_ci,0) != 0 and D_tipo = 'T' THEN
     V_errore := 'A05721';
     RAISE USCITA;
  END IF;
-- dbms_output.put_Line('CI: '||to_char(D_ci));
  BEGIN
    SELECT valore
      INTO D_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GESTIONE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_gestione := NULL;
  END;
-- dbms_output.put_Line('gestione: '||D_gestione);
  BEGIN
    SELECT valore
      INTO D_rapporto
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_RAPPORTO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_rapporto := NULL;
  END;
-- dbms_output.put_Line('rapporto: '||D_rapporto);
 BEGIN
  SELECT valore
    INTO P_sfasato
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ANNO_SFASATO'
   ;
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_sfasato := null;
 END;
 
 BEGIN
  SELECT valore
    INTO P_periodi_effettivi
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_PER_EFFE'
   ;
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_periodi_effettivi := null;
 END;

  BEGIN
   select 'X' 
     into V_controllo
     from classi_rapporto
    where codice = D_rapporto
      and D_rapporto != '%';
  EXCEPTION 
   WHEN NO_DATA_FOUND THEN 
     IF D_tipo = 'S' THEN NULL;
     ELSE 
     V_errore := 'P01100';
     RAISE USCITA;
     END IF;
   WHEN OTHERS THEN NULL;
  END;

  BEGIN
    SELECT valore
         , '0101'||valore
         , '3112'||valore
      INTO D_anno
         , D_ini_a
         , D_fin_a
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT anno
           , '0101'||TO_CHAR(anno)
           , '3112'||TO_CHAR(anno)
        INTO D_anno
           , D_ini_a
           , D_fin_a
        FROM RIFERIMENTO_FINE_ANNO
       WHERE rifa_id = 'RIFA'
      ;
  END;

  D_ini_as := '0112'||to_number(D_anno-1);
  D_fin_as := '3011'||D_anno;

-- dbms_output.put_Line('Anno: '||(D_anno)||' ini: '||(d_ini_a)||' fin: '||(d_fin_a));
  BEGIN
    SELECT ENTE        D_ente
         , utente      D_utente
         , ambiente    D_ambiente
         , gruppo_ling D_gruppo_ling
      INTO D_ente,D_utente,D_ambiente,D_gruppo_ling
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ente     := NULL;
      D_utente   := NULL;
      D_ambiente := NULL;
  END;
--
-- Cancellazione Archiviazione precedente relativa all'anno richiesto
--
  LOCK TABLE NOTE_CUD IN EXCLUSIVE MODE NOWAIT
  ;
  DELETE FROM NOTE_CUD nocu
   WHERE nocu.anno = D_anno
     and codice    = 'AL'
     AND nocu.ci IN (SELECT ci
                      FROM PERIODI_RETRIBUTIVI
                     WHERE nocu.ci = ci
                       AND gestione LIKE nvl(D_gestione,'%'))
     AND (    D_tipo = 'T'
         OR ( D_tipo = 'S' AND nocu.ci = D_ci )
          )
     AND EXISTS
        (SELECT 'x'
           FROM RAPPORTI_INDIVIDUALI rain
          WHERE rain.ci = nocu.ci
            and rapporto LIKE nvl(D_rapporto,'%')
            AND (   rain.CC IS NULL
                 OR EXISTS
                   (SELECT 'x'
                      FROM a_competenze
                     WHERE ENTE        = D_ente
                       AND ambiente    = D_ambiente
                       AND utente      = D_utente
                       AND competenza  = 'CI'
                       AND oggetto     = rain.CC
                   )
                )
        )
  ;
 COMMIT;
 FOR CUR_CI IN
   (SELECT defi.ci
         , defi.c1
         , defi.c2
         , defi.c3
         , defi.c4
         , defi.c45
         , defi.c46
         , defi.c139
      FROM denuncia_fiscale     defi
     WHERE defi.rilevanza = 'T'
       AND defi.anno      = D_anno
       AND EXISTS (select 'x'
                      FROM PERIODI_RETRIBUTIVI  pere
                     WHERE pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                                            AND TO_DATE(D_fin_a,'ddmmyyyy')
                       AND pere.competenza    = 'A'
                       AND pere.gestione   LIKE nvl(D_gestione,'%')
                       AND pere.ci            = defi.ci
                   )
     AND D_tipo = 'T'
     AND EXISTS
        (SELECT 'x'
           FROM RAPPORTI_INDIVIDUALI rain
          WHERE rain.ci = defi.ci
            and rapporto LIKE nvl(D_rapporto,'%')
            AND (   rain.CC IS NULL
                 OR EXISTS
                   (SELECT 'x'
                      FROM a_competenze
                     WHERE ENTE        = D_ente
                       AND ambiente    = D_ambiente
                       AND utente      = D_utente
                       AND competenza  = 'CI'
                       AND oggetto     = rain.CC
                   )
                )
        )
    UNION ALL
    SELECT defi.ci
         , defi.c1
         , defi.c2
         , defi.c3
         , defi.c4
         , defi.c45
         , defi.c46
         , defi.c139
       FROM denuncia_fiscale     defi
      WHERE defi.rilevanza = 'T'
        AND D_tipo  = 'S'
        AND defi.ci = D_ci
        AND defi.anno      = D_anno
        AND EXISTS (select 'x'
                      FROM PERIODI_RETRIBUTIVI  pere
                     WHERE pere.periodo BETWEEN TO_DATE(D_ini_a,'ddmmyyyy')
                                            AND TO_DATE(D_fin_a,'ddmmyyyy')
                       AND pere.competenza    = 'A'
                       AND pere.gestione   LIKE nvl(D_gestione,'%')
                       AND pere.ci            = defi.ci
                   )
        AND EXISTS
           (SELECT 'x'
              FROM RAPPORTI_INDIVIDUALI rain
             WHERE rain.ci = defi.ci
               and rapporto LIKE nvl(D_rapporto,'%')
                AND (   rain.CC IS NULL
                  OR EXISTS
                    (SELECT 'x'
                       FROM a_competenze
                      WHERE ENTE        = D_ente
                        AND ambiente    = D_ambiente
                        AND utente      = D_utente
                        AND competenza  = 'CI'
                        AND oggetto     = rain.CC
                    )
                 )
           )
   )LOOP
    BEGIN
    <<NOTE>>
-- dbms_output.put_Line('CI: '||to_char(CUR_CI.ci));
 
    D_sequenza := 0;
    FOR CUR_LINGUA in
    ( select decode( nvl(instr(upper(rain.note),'LINGUA '),0)
                    , 0, anag.gruppo_ling
                       , substr( upper(rain.note) , instr(upper(rain.note),'LINGUA ')+7, 1)
                   )  lingua_dip
            , 0  seq
         from anagrafici anag
            , rapporti_individuali rain
        where rain.ci = CUR_CI.ci
          and rain.ni = anag.ni
          and anag.al is null
    ) LOOP
   
    BEGIN
-- dbms_output.put_line('Nota AL');
BEGIN
<<NOTA_AL>>
/* Nota AL - CUD 2007 */
  IF nvl(CUR_CI.c1,0) != 0 or nvl(CUR_CI.c2,0) != 0 THEN
    d_conta_rapporti := 0;
    D_note_AL := '';
    FOR CUR_RAPP in ( select 2,CUR_CI.ci ci,
                           null rilevanza
                      from dual
                     union
                    select 1,ci_erede ci,
                           rilevanza rilevanza
                      from rapporti_diversi
                     where ci = CUR_CI.ci
                       and rilevanza in ('R')
                       and anno = D_anno
                      order by 1,2
                   )
    LOOP
    BEGIN
        select decode( CUR_lingua.lingua_dip 
                     , grli1.gruppo_al, nvl(clra.descrizione, nvl(clra.descrizione_al1,clra.descrizione_al2))
                     , grli2.gruppo_al, nvl(clra.descrizione_al1, nvl(clra.descrizione,clra.descrizione_al2))
                     , grli3.gruppo_al, nvl(clra.descrizione_al2, nvl(clra.descrizione,clra.descrizione_al1))
                                      , nvl(clra.descrizione, nvl(clra.descrizione_al1,clra.descrizione_al2))
                     )
          into D_descr_rapporto
          from  rapporti_individuali rain
              , classi_rapporto clra
              , ente
              , gruppi_linguistici grli1
              , gruppi_linguistici grli2
              , gruppi_linguistici grli3
         where ente.ente_id       = 'ENTE'
           and rain.rapporto      = clra.codice
           and rain.ci            = CUR_RAPP.ci
           and (   nvl(CUR_RAPP.rilevanza,'z') != 'R'
              or ( CUR_RAPP.rilevanza = 'R' 
                 and exists ( select 'x'
                                from rapporti_individuali rain2
                               where rain2.ci = CUR_CI.ci
                                 and rain2.rapporto != rain.rapporto
                            )
                 )
               )
           and grli1.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                            , 'ENTE*', 'I'
                                                     , upper(D_gruppo_ling)
                                           )
           and grli1.sequenza      = 1
           and grli2.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                            , 'ENTE*', 'I'
                                                     , upper(D_gruppo_ling)
                                           )
           and grli2.sequenza      = 2
           and grli3.gruppo (+)    = decode( ente.ente_id||upper(D_gruppo_ling)
                                            , 'ENTE*', 'I'
                                                     , upper(D_gruppo_ling)
                                           )
           and grli3.sequenza      = 3
        ;
    EXCEPTION
      WHEN no_data_found THEN
           d_descr_rapporto := '';
    END;

        D_conta_rapporti := D_conta_rapporti + 1;
        IF D_conta_rapporti = 1 then
           IF nvl(CUR_CI.c1,0) != 0 and nvl(CUR_CI.c2,0) != 0 then
                 D_note_AL := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_2', D_gruppo_ling, CUR_lingua.lingua_dip  );
           ELSIF nvl(CUR_CI.c1,0) != 0 and nvl(CUR_CI.c2,0) = 0 then
                 D_note_AL := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_1', D_gruppo_ling, CUR_lingua.lingua_dip  );
           ELSIF nvl(CUR_CI.c1,0) = 0 and nvl(CUR_CI.c2,0) != 0 then
                 D_note_AL := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_2', D_gruppo_ling, CUR_lingua.lingua_dip  );
           ELSE  D_note_AL := null;
           END IF;
        END IF;
        IF nvl(CUR_CI.c1,0) + nvl(CUR_CI.c2,0) != 0 then
           IF D_conta_rapporti = 1 then
              D_note_AL := D_note_AL||d_descr_rapporto||d_descr_tempo_det;
           ELSIF nvl(d_descr_rapporto,' ') != ' '  then
              D_note_AL := D_note_AL||', '||d_descr_rapporto||d_descr_tempo_det;
           END IF;
        END IF;
    END LOOP; -- CUR_RAPP

 D_note_periodi := null;
 D_conta_periodi := 0;
 D_intesta_periodi := null;

 IF (  P_periodi_effettivi in ( 'PS', 'AS' )
  or ( P_periodi_effettivi in ( 'PG', 'AG' ) 
    and ( nvl(CUR_CI.c3,0) + nvl(CUR_CI.c4,0) ) between 1 and 364 
     )
    ) THEN
    d_conta_periodi := 0;
    d_note_periodi := '';
    FOR CUR_PEGI in (select decode( P_sfasato
                                   ,'X', to_char(greatest(to_date(d_ini_as,'ddmmyyyy'),pegi.dal),'dd/mm/yyyy')
                                       , to_char(greatest(to_date(d_ini_a,'ddmmyyyy'),pegi.dal),'dd/mm/yyyy')
                                  ) pegi_dal,
                            decode( P_sfasato
                                   ,'X', to_char(least(nvl(pegi.al,to_date(d_fin_a,'ddmmyyyy')),to_date(d_fin_as,'ddmmyyyy')),'dd/mm/yyyy')
                                       , to_char(least(nvl(pegi.al,to_date(d_fin_a,'ddmmyyyy')),to_date(d_fin_a,'ddmmyyyy')),'dd/mm/yyyy')
                                  )  pegi_al
                       from periodi_giuridici pegi
                      where pegi.ci in ( select CUR_CI.ci
                                           from dual
                                          union
                                         select ci_erede
                                           from rapporti_diversi
                                          where ci = CUR_CI.ci
                                            and anno = D_anno
                                            and rilevanza = 'R'
                                       )
                        and pegi.rilevanza = 'P'
                        and P_periodi_effettivi in ( 'PG', 'PS')
                        and pegi.dal <= decode( P_sfasato,'X', to_date(d_fin_as,'ddmmyyyy') , to_date(d_fin_a,'ddmmyyyy'))
                        and nvl(pegi.al,decode( P_sfasato,'X',to_date(d_fin_as,'ddmmyyyy'), to_date(d_fin_a,'ddmmyyyy')))
                                >= decode( P_sfasato,'X', to_date(d_ini_as,'ddmmyyyy'), to_date(d_ini_a,'ddmmyyyy'))
                     union
                     select decode( P_sfasato
                                   ,'X', to_char(to_date(d_ini_as,'ddmmyyyy'),'dd/mm/yyyy')
                                       , to_char(to_date(d_ini_a,'ddmmyyyy'),'dd/mm/yyyy')
                                  ) pegi_dal,
                            decode( P_sfasato
                                   ,'X', to_char(to_date(d_fin_as,'ddmmyyyy'),'dd/mm/yyyy')
                                       , to_char(to_date(d_fin_a,'ddmmyyyy'),'dd/mm/yyyy')
                                  )  pegi_al
                       from dual 
                      where P_periodi_effettivi in ( 'AG', 'AS')
                   order by 1,2
                    )
    LOOP
    BEGIN
        D_conta_periodi := D_conta_periodi + 1;
        IF D_conta_periodi = 1 then
           D_note_periodi := D_note_periodi||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'DAL', D_gruppo_ling, CUR_lingua.lingua_dip )
                             ||' '||CUR_PEGI.pegi_dal||' '||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'AL', D_gruppo_ling, CUR_lingua.lingua_dip )
                             ||' '||CUR_PEGI.pegi_al;
        ELSE
           D_note_periodi := D_note_periodi||', '||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'DAL', D_gruppo_ling, CUR_lingua.lingua_dip )
                             ||' '||CUR_PEGI.pegi_dal||' '||PEC_RECO.GET_RV_MEANING('VOCABOLO', 'AL', D_gruppo_ling, CUR_lingua.lingua_dip )
                             ||' '||CUR_PEGI.pegi_al;
        END IF;
    END;
    END LOOP;  -- CUR_PEGI
        IF D_note_periodi is not null THEN D_note_periodi := D_note_periodi||'. ';
        END IF;
        IF D_conta_periodi = 1 then
           D_intesta_periodi := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_5', D_gruppo_ling, CUR_lingua.lingua_dip  );
        ELSE 
           D_intesta_periodi := PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_6', D_gruppo_ling, CUR_lingua.lingua_dip  );
        END IF;
  ELSE
     D_note_periodi := null;
     D_conta_periodi := 0;
     D_intesta_periodi := null;
  END IF; -- controllo c6 - c7
  
   BEGIN
   select decode( nvl(CUR_CI.c139,0),0, null, ' con presenza di TFR') 
     into d_note_tfr
     from dual;
   EXCEPTION WHEN NO_DATA_FOUND THEN D_note_tfr := null;
   END;
    select nvl(D_note_AL,' ')||nvl(D_note_tfr,'')||'. '
         ||nvl(D_intesta_periodi,'')
         ||nvl(D_note_periodi,'')
         ||PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_7', D_gruppo_ling, CUR_lingua.lingua_dip )
         ||GP4EC.GET_VAL_DEC_STAMPA((nvl(CUR_ci.c1,0) + nvl(CUR_ci.c2,0)))
         ||decode((nvl(CUR_CI.c45,0)+nvl(CUR_CI.c46,0))
                 ,0,''
                   ,PEC_RECO.GET_RV_MEANING('DENUNCIA_CUD.ANNOTAZIONI', 'AL_8', D_gruppo_ling, CUR_lingua.lingua_dip )
                  )||'.'
      into D_note_AL
      from dual;
   D_sequenza := 11 + CUR_LINGUA.seq;
      INSERT INTO NOTE_CUD 
      (anno,ci,codice, sequenza,note,utente,data_agg)
          select d_anno,CUR_CI.ci,'AL', D_sequenza
               , substr(D_note_AL,1,2000)
               , D_utente, SYSDATE
            from dual
      where nvl(CUR_CI.c1,0) + nvl(CUR_CI.c2,0) != 0 
      ;
      IF length(D_note_AL) > 2000 THEN
          D_riga := D_riga +1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,2,D_riga,'P00521',substr('CI: '||TO_CHAR(CUR_CI.ci)||', Nota AL '||D_errore,1,50));
      END IF;
  END IF; -- controllo c1 e c2
END NOTA_AL;

-- dbms_output.put_line('Fine Nota AL');

  END;
  END LOOP; -- CUR_lingua
   EXCEPTION
       WHEN OTHERS THEN
-- dbms_output.put_line('ERRORE');
           D_errore := SUBSTR(SQLERRM,1,30);
          ROLLBACK;
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
          D_riga := D_riga +1;
          INSERT INTO a_segnalazioni_errore
          ( no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,2,D_riga,'P00109',' Note del CI: '||SUBSTR(TO_CHAR(CUR_CI.ci)||' '||D_errore,1,50));
          COMMIT;
    END NOTE;
   COMMIT;
    END LOOP; -- CUR_CI
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 99
           , errore         = V_errore
       where no_prenotazione = prenotazione;
      commit;
END;
END;
END;
/
