CREATE OR REPLACE PACKAGE PECXAC62 IS
/******************************************************************************
 NOME:        PECXAC62
 DESCRIZIONE: Modifica qualifica su dati inpdap già archiviati

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI: Per evitare di modificare TUTTI i package della vecchia archiviazione INPDAP
              ( cardp / cadpm / caedp / denunce_inpdap ) a causa dell'utilizzo del parametro P_denuncia 
              si è scelto di inserire parte della procedure determina_qualifica direttamente 
              all'interno di questo package

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  30/08/2005 MS     Prima emissione
 1.1  31/08/2005 MS     corretta lettura dell'Al
 1.2  08/09/2005 MS     Modifica per att. 12545
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECXAC62 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 08/09/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
DECLARE
  P_sfasato       VARCHAR2(1);
  P_fine_anno     VARCHAR2(1);
  D_errore        VARCHAR2(6);
  V_controllo     VARCHAR2(1);
  P_comparto      varchar2(2);
  P_sottocomparto varchar2(2);
  D_qualifica     varchar2(6);
  D_ente          varchar(4);
  D_ambiente      varchar(8);
  D_utente        varchar(8);
  D_anno          varchar(4);
  D_ini_a         varchar(8);
  D_fin_a         varchar(8);
  D_gestione      varchar(4);
  D_previdenza    varchar(6);
  D_tipo          varchar(1);
  D_ci            number(8);
  P_mod           varchar2(1);
  D_pr_err        NUMBER := 0;
--
-- Exceptions
--
  USCITA EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN

BEGIN
  select valore
    into D_tipo
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_TIPO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_tipo := null;
END;
BEGIN
  select valore
    into D_ci
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    D_ci := 0;
END;
IF nvl(D_ci,0) = 0 and D_tipo = 'S' THEN
     D_errore := 'A05721';
     RAISE USCITA;
ELSIF nvl(D_ci,0) != 0 and D_tipo = 'T' THEN
     D_errore := 'A05721';
     RAISE USCITA; 
END IF;

BEGIN
  select valore
    into D_previdenza
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_PREVIDENZA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_previdenza := 'CP%';
END;
BEGIN
  select valore
    into D_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GESTIONE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_gestione := '%';
END;

-- dbms_output.put_line('par_GEST: '||D_gestione);
BEGIN
  select valore
    into P_comparto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_COMPARTO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_comparto :='00';
END;
BEGIN
  select valore
    into P_sottocomparto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_SOTTOCOMPARTO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_sottocomparto :='00';
END;
BEGIN
  select ente     D_ente
       , utente   D_utente
       , ambiente D_ambiente
    into D_ente,D_utente,D_ambiente
    from a_prenotazioni
   where no_prenotazione = prenotazione
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_ente     := null;
       D_utente   := null;
       D_ambiente := null;
END;

BEGIN

  select valore
    into P_mod
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_MOD';
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
       P_mod := null;
END;
-- dbms_output.put_line('par_MOD: '||P_mod);
-- Estrae Parametro per Gestione NDR es: Piacenza
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
IF P_sfasato = 'X' THEN
  BEGIN
   select 'X' 
     into V_controllo
     from gestioni
    where codice = D_gestione
      and D_gestione != '%';
  EXCEPTION 
   WHEN NO_DATA_FOUND THEN 
     IF D_tipo = 'S' THEN NULL;
	 ELSE D_errore := 'P05130';
	      RAISE USCITA;
     END IF;
   WHEN OTHERS THEN NULL;
  END;
END IF;

   BEGIN
       select decode(P_sfasato,'X','0112'||to_char(valore-1)
                                  ,'0101'||valore)
            , decode(P_sfasato,'X','3011'||valore
                                  ,'3112'||valore)
            , 'X'
            , valore
         into D_ini_a
            , D_fin_a
            , P_fine_anno
            , D_anno
        from  a_parametri
        where no_prenotazione = prenotazione
          and parametro       = 'P_ANNO'
        ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
           select decode(P_sfasato,'X','0112'||to_char(anno-1)
                                      ,'0101'||to_char(anno))
                , decode(P_sfasato,'X','3011'||anno
                                      ,'3112'||anno)
                , 'X'
                , anno
            into D_ini_a
                , D_fin_a
                , P_fine_anno
                , D_anno
             from riferimento_fine_anno
            where rifa_id = 'RIFA'
       ;
    END;

  FOR CUR_CI IN
   (select distinct dedp.ci, dedp.gestione
         , nvl(dal,to_date(D_ini_a,'ddmmyyyy')) dal
         , nvl(al,to_date(d_fin_a,'ddmmyyyy'))  al
    from denuncia_inpdap dedp
       , trattamenti_previdenziali trpr
     where dedp.anno = D_anno
       and dedp.gestione   like D_gestione
       and dedp.previdenza like D_previdenza
       and ( D_tipo = 'T' 
          or D_tipo = 'S' and dedp.ci = D_ci )
       and ( P_mod = 'X' and nvl(qualifica,'XXXXXX') = 'XXXXXX'
        or P_mod is null )
       and exists (select 'x'
                     from rapporti_individuali rain
                    where rain.ci = dedp.ci
                      and (   rain.cc is null
                          or exists
                            (select 'x'
                               from a_competenze
                              where ente        = D_ente
                                and ambiente    = D_ambiente
                                and utente      = D_utente
                                and competenza  = 'CI'
                                and oggetto     = rain.cc
                            )
                          )
                   )
     order by ci,dal,al
    ) LOOP
-- dbms_output.put_line('CI/GEST: '||CUR_CI.ci||' '||CUR_CI.gestione);
-- dbms_output.put_line('periodo: '||CUR_CI.dal||' '||CUR_CI.al);

   D_qualifica := null;
     BEGIN
      SELECT rqmi.codice          qua_min
      into D_qualifica
      FROM periodi_giuridici pegi
         , posizioni posi
         , righe_qualifica_ministeriale rqmi
      WHERE pegi.ci               = CUR_CI.ci
        AND pegi.rilevanza        = 'S'
        AND CUR_CI.al between pegi.dal
                             AND nvl(pegi.al,to_date(d_fin_a,'ddmmyyyy'))
        AND pegi.gestione    = CUR_CI.gestione
        AND posi.codice      = pegi.posizione
        AND to_date(D_ini_a,'ddmmyyyy')
            between rqmi.dal and nvl(rqmi.al,to_date('3333333','j'))
        AND (   (    rqmi.qualifica is null
                 and rqmi.figura     = pegi.figura)
             or (    rqmi.figura    is null
                 and rqmi.qualifica  = pegi.qualifica)
             or (    rqmi.qualifica is not null
                 and rqmi.figura    is not null
                 and rqmi.qualifica  = pegi.qualifica
                 and rqmi.figura     = pegi.figura)
             or (    rqmi.qualifica is null
                 and rqmi.figura    is null)
                             )
        AND nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
        AND nvl(rqmi.tempo_determinato,posi.tempo_determinato)
                                     = posi.tempo_determinato
        AND nvl(rqmi.formazione_lavoro,posi.contratto_formazione)
                                     = posi.contratto_formazione
        AND nvl(rqmi.part_time,posi.part_time) = posi.part_time
        AND nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqmi.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
        ;
     EXCEPTION
       when no_data_found then
       BEGIN
        D_pr_err := D_pr_err + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT prenotazione
             , 1
             , D_pr_err
             , 'P05986'
             , 'Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')||' '||
               'Dal '||TO_CHAR(CUR_CI.dal,'dd/mm/yyyy')||'  '||
                'Al '||TO_CHAR(CUR_CI.al, 'dd/mm/yyyy')
       from dual
       where not exists (select 'x' from a_segnalazioni_errore
                          where no_prenotazione = prenotazione
                            and passo           = 1
                            and errore          = 'P05986'
                            and precisazione    = 'Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')||' '||
                                                  'Dal '||TO_CHAR(CUR_CI.dal,'dd/mm/yyyy')||'  '||
                                                  'Al '||TO_CHAR(CUR_CI.al, 'dd/mm/yyyy')
                         );
       END;
      when too_many_rows then
       BEGIN
        D_pr_err := D_pr_err + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT prenotazione
             , 1
             , D_pr_err
             , 'P05985'
             , 'Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')||' '||
               'Dal '||TO_CHAR(CUR_CI.dal,'dd/mm/yyyy')||'  '||
                'Al '||TO_CHAR(CUR_CI.al, 'dd/mm/yyyy')
       from dual
       where not exists (select 'x' from a_segnalazioni_errore
                          where no_prenotazione = prenotazione
                            and passo          = 1
                            and errore         = 'P05985'
                            and precisazione   = 'Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')||' '||
                                                 'Dal '||TO_CHAR(CUR_CI.dal,'dd/mm/yyyy')||'  '||
                                                 'Al '||TO_CHAR(CUR_CI.al, 'dd/mm/yyyy')
                         );
       END;
     END;
-- dbms_output.put_line('qual: '||D_qualifica);
     IF D_qualifica is not null THEN
     update denuncia_inpdap
        set qualifica = D_qualifica
          , comparto = P_comparto
          , sottocomparto = P_sottocomparto
          , utente = D_utente
          , data_agg = sysdate
      where ci        = CUR_CI.ci
        and gestione  = CUR_CI.gestione
        and previdenza like D_previdenza
        and nvl(dal,to_date(D_ini_a,'ddmmyyyy')) = CUR_CI.dal
        and nvl(al,to_date(D_fin_a,'ddmmyyyy'))  = CUR_CI.al
     ;
    commit;
    END IF;
  END LOOP;  -- CUR_CI
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
END;
END;
end;
/
