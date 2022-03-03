CREATE OR REPLACE PACKAGE PECCADPM IS
/******************************************************************************
 NOME:        PECCADPM
 DESCRIZIONE: Archiviazione mensile INPDAP.

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
     Il package prevede:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    01/01/2003  ML
 2    01/01/2004  MS    - Revisione Denuncia INPDAP
 3    27/08/2004	ML	- Modificate delete (cancella sempre anche se ci sono importi)
				- Eliminta la ricerca e il controllo della previdenza nel CUR_CI per gestire il tutto nella 
				  procedure PREVIDENZA del CUR_PESEP
				- Gestione del campo rap_orario per calcolo gg_utili 
 3.1  10/09/2004  MV    - A7024 - Gestione del campo tipo_trattamento
 3.2  15/09/2004	MS	- A7276 - Verifica competenza di rain sui cursori CUR_SEGNALA2, CUR_SEGNALA3, CUR_SEGNALA4 e DIP
 3.3	20/10/2004	ML	- Spostata la delete all'interno del cur_ci
 3.4  28/10/2004	ML	- Passaggio parametro D_previdenza in chiamata procedure PREVIDENZA
 3.5  02/11/2004  MS    - Modifica per att. 6662
 3.6	24/01/2005	ML	- Modifica CUR_CI per last_day(riferimento) att. 9409
 4.0  01/02/2005  MS    - Modifica per attività 9557
 4.1  10/02/2005  MS    - Modifica per att. 3670.1
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCADPM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V4.1 del 10/02/2005';
END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  P_denuncia      VARCHAR2(1);
  P_sfasato       VARCHAR2(1);
  V_controllo     VARCHAR2(1);
  P_comparto      varchar2(2);
  P_sottocomparto varchar2(2);
  D_qualifica     varchar2(6);
  P_economica     VARCHAR2(1);
  P_ultima_cess   VARCHAR2(1);
  D_ente          VARCHAR2(4);
  D_ambiente      VARCHAR2(8);
  D_utente        VARCHAR2(8);
  D_anno          VARCHAR2(4);
  D_mese          NUMBER;
  D_mensilita     VARCHAR2(4);
  D_ini_a         VARCHAR2(8);
  D_fin_a         VARCHAR2(8);
  D_gestione      VARCHAR2(4);
  D_rapporto      VARCHAR2(4);
  D_gruppo        VARCHAR2(12);
  D_previdenza    VARCHAR2(6);
  D_tipo          VARCHAR2(1);
  D_tipo_trattamento  VARCHAR2(1);
  D_giorni        VARCHAR2(1);
  P_riferimento   DATE;
  D_prec_elab     DATE;
  D_elab          DATE;
  D_da            DATE;
  D_a             DATE;
  D_var           DATE;
  D_trattamento   VARCHAR2(4);
  D_pagina        NUMBER := 0;
  D_riga          NUMBER := 0;
  D_ci            NUMBER(8);
  D_num_servizi   NUMBER := 0;
  D_pr_err_0      NUMBER := 0;
  D_pr_err_1      NUMBER := 10000;
  D_pr_err_2      NUMBER := 20000;
  D_pr_err_3      NUMBER := 30000;
  D_pr_err_4      NUMBER := 40000;
  D_pr_err_5      NUMBER := 150000; -- max fino a 200000
  D_pr_err_7      NUMBER := 70000;
  I_previdenza    VARCHAR2(6);
  I_pensione      VARCHAR2(1);
  I_inadel        VARCHAR2(1);
  I_codice        VARCHAR2(10);
  I_posizione     VARCHAR2(8);
  I_data_ces      VARCHAR2(8);
  I_causa_ces     VARCHAR2(2);
  I_comp_fisse    NUMBER;
  I_comp_acc      NUMBER;
  I_comp_inadel   NUMBER;
  I_comp_tfr      NUMBER;
  I_ipn_tfr       NUMBER;
  I_comp_premio   NUMBER;
  I_preav         NUMBER;
  I_ferie         NUMBER;
  I_l_165         NUMBER;
  I_dal_arr       VARCHAR2(8);
  I_al_arr        VARCHAR2(8);
  I_contribuzione varchar2(1);
  I_colonna		varchar2(30);
  I_enpdep        varchar2(1);
  D_errore        varchar2(6);
--
-- Exceptions
--
  USCITA   EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
 select 'M'
   INTO P_denuncia 
  from dual;
END;
BEGIN
  SELECT valore
    INTO P_ultima_cess
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ULTIMA_CESS'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_ultima_cess := null;
END;
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
  SELECT valore
    INTO P_economica
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ECONOMICA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_economica := NULL;
END;
BEGIN
  select valore
    into D_giorni
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GIORNI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_giorni := ' ';
END;
IF D_giorni = 'X' and P_economica is null THEN
     D_errore := 'A05721';
     RAISE USCITA;
END IF;
BEGIN
  SELECT valore
    INTO D_anno
	FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ANNO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    SELECT anno
      INTO D_anno
      FROM RIFERIMENTO_RETRIBUZIONE
     WHERE rire_id = 'RIRE'
    ;
END;
BEGIN
  SELECT TO_DATE(valore,'dd/mm/yyyy')
    INTO P_RIFERIMENTO
    FROM A_PARAMETRI   
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_RIFERIMENTO'
  ;
   EXCEPTION
  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    P_RIFERIMENTO := SYSDATE;
END;
   IF D_ANNO != to_char(P_RIFERIMENTO,'YYYY') THEN
     D_errore := 'P05196';
     RAISE USCITA;
   END IF; 
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
IF nvl(D_ci,0) = 0 and D_tipo = 'S' THEN
     D_errore := 'A05721';
     RAISE USCITA;
ELSIF nvl(D_ci,0) != 0 and D_tipo = 'T' THEN
     D_errore := 'A05721';
     RAISE USCITA; 
END IF;
BEGIN
  SELECT valore
    INTO D_previdenza
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_PREVIDENZA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_previdenza := NULL;
END;
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
BEGIN
    SELECT valore
      INTO D_rapporto
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_RAPPORTO'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_rapporto := '%';
  END;
  BEGIN
    SELECT valore
      INTO D_gruppo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GRUPPO'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         D_gruppo := '%';
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
SELECT '0101'||D_anno
     , '3112'||D_anno
  INTO D_ini_a
     , D_fin_a
  FROM dual
;
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
     ELSE 
     D_errore := 'P05130';
     RAISE USCITA;
     END IF;
   WHEN OTHERS THEN NULL;
  END;
  D_ini_a := '0112'||to_number(D_anno-1);
  D_fin_a := '3011'||D_anno;
END IF;
--
-- Estrazione della precedente data di archiviazione in assoluto
--
   BEGIN
     SELECT MAX(TRUNC(data_agg))
	   INTO D_elab
       FROM DENUNCIA_INPDAP
	  WHERE anno = D_anno
          AND NVL(tipo_agg,' ') NOT IN ('I','V')
          AND NVL(gestione,' ') LIKE D_gestione
          AND NVL(previdenza,' ') LIKE D_previdenza
          AND ci IN (SELECT ci FROM RAPPORTI_INDIVIDUALI
                      WHERE rapporto LIKE D_rapporto
                        AND NVL(gruppo,' ')   LIKE D_gruppo)
	 ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
	  D_elab := NULL;
   END;
--
-- Estrazione della data di precedente archiviazione per l'anno di elaborazione
--
   BEGIN
	 SELECT MAX(TRUNC(data_agg))
	   INTO D_prec_elab
       FROM DENUNCIA_INPDAP dedp
	  WHERE dedp.anno = D_anno
          AND NVL(gestione,' ') LIKE D_gestione
          AND NVL(previdenza,' ') LIKE D_previdenza
          AND ci IN (SELECT ci FROM RAPPORTI_INDIVIDUALI
                      WHERE rapporto LIKE D_rapporto
                        AND NVL(gruppo,' ')   LIKE D_gruppo)
	    AND NVL(dedp.tipo_agg,' ') NOT IN ('I','V')
	    AND TRUNC(dedp.data_agg) < (SELECT MAX(TRUNC(data_agg))
		                       FROM DENUNCIA_INPDAP
		                      WHERE anno = D_anno
                                    AND NVL(gestione,' ') LIKE D_gestione
                                    AND NVL(previdenza,' ') LIKE D_previdenza
                                    AND ci IN (SELECT ci FROM RAPPORTI_INDIVIDUALI
                                                WHERE rapporto LIKE D_rapporto
                                                  AND NVL(gruppo,' ')   LIKE D_gruppo)
				                AND NVL(tipo_agg,' ') NOT IN ('I','V')
                             )
	 ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_prec_elab := NULL;
   END;

  BEGIN
   SELECT to_date('01'||to_char(TO_DATE(valore,'dd/mm/yyyy'),'mmyyyy'),'ddmmyyyy')
        , last_day(TO_DATE(valore,'dd/mm/yyyy'))
        , to_char(TO_DATE(valore,'dd/mm/yyyy'),'mm')
     INTO D_da
         ,D_a
         ,D_mese
    FROM A_PARAMETRI   
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_RIFERIMENTO'
    ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
     SELECT ini_ela
	    , fin_ela
          , mese
       INTO D_da
	     ,D_a
           ,D_mese
	   FROM RIFERIMENTO_RETRIBUZIONE
      WHERE rire_id = 'RIRE'
	 ;
  END;
   BEGIN
     SELECT MAX(MENSILITA)
       into D_mensilita
       FROM MENSILITA
      WHERE mese  = D_mese
        AND tipo IN ('A','N','S');
   END;
   IF NVL(TO_CHAR(D_elab,'yyyy'),TO_CHAR(P_RIFERIMENTO,'yyyy')) = nvl(TO_CHAR(D_prec_elab,'yyyy'),D_anno) THEN
     D_var := to_date(NULL);
     D_da  := TO_DATE('0101'||TO_CHAR(P_RIFERIMENTO,'yyyy'),'ddmmyyyy');
   ELSE
     D_var := D_elab+1;  -- Altrimenti achivierebbe anche quelli modificati il giorno dell'archiviazione prec.
   END IF;

   -- Loop che estrae i dipendenti da elaborare
-- dbms_output.put_line('Data var: '||to_char(D_var,'dd/mm/yyyy'));
-- dbms_output.put_line('Data prec. elab: '||to_char(D_prec_elab,'dd/mm/yyyy'));
-- dbms_output.put_line('Data elab: '||to_char(D_elab,'dd/mm/yyyy'));
   FOR CUR_CI IN
    (select distinct pere.ci, pere.gestione
      from periodi_retributivi pere
         , trattamenti_previdenziali trpr
     where pere.periodo between to_date(D_ini_a,'ddmmyyyy')
                            and last_day(P_riferimento)
--       and pere.competenza    = 'A'
       and pere.competenza    in ( 'A', 'C' )
       and pere.gestione   like D_gestione
       and pere.trattamento   = trpr.codice
       and trpr.previdenza is not null
       and trpr.previdenza like D_previdenza
       and (         D_tipo = 'T'
             or (    D_tipo = 'S' and pere.ci = D_ci)
             or (    D_tipo in ('I','V','P') 
                 and not exists
                    (select 'x' from denuncia_inpdap
                      where anno              = D_anno
                        and gestione          = pere.gestione
                        and previdenza        = trpr.previdenza
                        and ci                = pere.ci
                        and nvl(tipo_agg,' ') = decode(D_tipo,'P',tipo_agg,D_tipo)
                    )
                )
            )
       and pere.ci IN (SELECT ci
	                   FROM PERIODI_GIURIDICI
                        where (      dal <= P_riferimento
                                 and nvl(al,TO_DATE('3333333','j')) >= NVL(D_var,TO_DATE('2222222','j'))
                               or    nvl(trunc(data_agg),to_date('2222222','j')) >= NVL(D_var,TO_DATE('2222222','j'))
                                 and dal <= P_riferimento
                              )
                      )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci + 0 = pere.ci
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
	) LOOP
      BEGIN
	  IF D_tipo in ('S','T') THEN  -- Inizio Cancellazioni

           FOR CUR_SEGNALA IN
              (SELECT anno
                     ,ci
                     ,previdenza
    	               ,assicurazioni
	               ,gestione
	               ,codice
          	         ,posizione
	               ,rilevanza
                     ,dal
	               ,al 
	               ,tipo_impiego
	               ,tipo_servizio
	               ,data_cessazione
	               ,causa_cessazione
	               ,utente
                     ,tipo_agg
	               ,data_agg
	               ,maggiorazioni
   	           FROM DENUNCIA_INPDAP dedp
                WHERE anno               = D_anno
                  and dedp.gestione      = CUR_CI.gestione
                  and dedp.previdenza LIKE D_previdenza
                  and dedp.ci            = CUR_CI.ci
                  and exists
                     (select 'x'
                        from denuncia_inpdap  
                       where anno       = D_anno
                         and gestione   = dedp.gestione
                         and previdenza = dedp.previdenza
                         and ci         = dedp.ci
                         and (   D_tipo = 'T'
                              or D_tipo = 'S' and ci = D_ci)
  	                   AND NVL(tipo_agg,' ') IN ('I','V'))
                order by ci,decode(rilevanza,'S',1,2),dal
              ) LOOP
                D_pagina := D_pagina + 1;
	          D_riga   := D_riga + 1;
	          INSERT INTO a_appoggio_stampe
                VALUES ( prenotazione
                       , 1
                       , D_pagina
                       , D_riga
                       , LPAD(NVL(D_anno,' '),4,' ')||
                         LPAD(TO_CHAR(NVL(CUR_SEGNALA.ci,0)),8,' ')||
	                   RPAD(NVL(CUR_SEGNALA.previdenza,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA.assicurazioni,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA.gestione,' '),4,' ')||
		             RPAD(NVL(CUR_SEGNALA.codice,' '),10,' ')||
		             RPAD(NVL(CUR_SEGNALA.posizione,' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA.rilevanza,' '),1,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA.dal,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA.al,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA.tipo_impiego,' '),2,' ')||
		             RPAD(NVL(CUR_SEGNALA.tipo_servizio,' '),2,' ')||
                         RPAD(NVL(TO_CHAR(CUR_SEGNALA.data_cessazione,'ddmmyyyy'),' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA.causa_cessazione,' '),2,' ')||
                         RPAD(NVL(CUR_SEGNALA.utente,' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA.tipo_agg,' '),1,' ')||
                         RPAD(NVL(TO_CHAR(CUR_SEGNALA.data_agg,'ddmmyyyy'),' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA.maggiorazioni,' '),12,' ')
                       )
                ;
                END LOOP;	   

                LOCK TABLE DENUNCIA_INPDAP IN EXCLUSIVE MODE NOWAIT;

                DELETE FROM DENUNCIA_INPDAP dedp
                 WHERE dedp.anno          = D_anno
                   and dedp.gestione      = CUR_CI.gestione
                   and dedp.previdenza LIKE D_previdenza
                   and dedp.ci            = CUR_CI.ci
 	          ; 
        ELSE
          FOR CUR_SEGNALA1 IN
              (SELECT anno
                     ,ci
                     ,previdenza
    	               ,assicurazioni
	               ,gestione
	               ,codice
          	         ,posizione
	               ,rilevanza
                     ,dal
	               ,al 
	               ,tipo_impiego
	               ,tipo_servizio
	               ,data_cessazione
	               ,causa_cessazione
	               ,utente
                     ,tipo_agg
	               ,data_agg
	               ,maggiorazioni
                FROM DENUNCIA_INPDAP dedp
                WHERE anno               = D_anno
                  and dedp.gestione      = CUR_CI.gestione
                  and dedp.previdenza LIKE D_previdenza
                  and dedp.ci            = CUR_CI.ci
                  and exists
                     (select 'x'
                        from denuncia_inpdap  
                       where anno       = D_anno
                         and gestione   = dedp.gestione
                         and previdenza = dedp.previdenza
                         and ci         = dedp.ci
  	                  AND NVL(tipo_agg,' ') IN ('I','V'))
                order by ci,decode(rilevanza,'S',1,2),dal
              ) LOOP
-- dbms_output.put_line( 'CI: '||to_char(cur_segnala1.ci)||' gestione: '||cur_segnala1.gestione);
               D_pagina := D_pagina + 1;
               D_riga   := D_riga + 1;
-- dbms_output.put_line( 'Inserisco segnalazione');
               INSERT INTO a_appoggio_stampe
               VALUES ( prenotazione
                      , 2
                      , D_pagina
                      , D_riga
                       , LPAD(NVL(D_anno,' '),4,' ')||
                         LPAD(TO_CHAR(NVL(CUR_SEGNALA1.ci,0)),8,' ')||
	                   RPAD(NVL(CUR_SEGNALA1.previdenza,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA1.assicurazioni,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA1.gestione,' '),4,' ')||
		             RPAD(NVL(CUR_SEGNALA1.codice,' '),10,' ')||
		             RPAD(NVL(CUR_SEGNALA1.posizione,' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA1.rilevanza,' '),1,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA1.dal,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA1.al,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA1.tipo_impiego,' '),2,' ')||
		             RPAD(NVL(CUR_SEGNALA1.tipo_servizio,' '),2,' ')||
                         RPAD(NVL(TO_CHAR(CUR_SEGNALA1.data_cessazione,'ddmmyyyy'),' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA1.causa_cessazione,' '),2,' ')||
                         RPAD(NVL(CUR_SEGNALA1.utente,' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA1.tipo_agg,' '),1,' ')||
                         RPAD(NVL(TO_CHAR(CUR_SEGNALA1.data_agg,'ddmmyyyy'),' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA1.maggiorazioni,' '),12,' ')
                      )
               ;
               END LOOP;

               DELETE FROM DENUNCIA_INPDAP dedp
                WHERE dedp.anno             = D_anno
                  AND dedp.gestione         = CUR_CI.gestione
                  AND dedp.previdenza    LIKE D_previdenza
                  AND dedp.ci               = CUR_CI.ci
                  and not exists
                     (select 'x' from denuncia_inpdap
                       where anno              = D_anno
                         and gestione          = dedp.gestione
                         and previdenza        = dedp.previdenza
                         and ci                = dedp.ci
                         and nvl(tipo_agg,' ') = decode(D_tipo,'P',tipo_agg,D_tipo)
                     )
               ; 
	  END IF;  
      END;           -- Fine cancellazioni

BEGIN
begin
 select nvl(tipo_trattamento,'0')
  into D_tipo_trattamento
 from rapporti_retributivi
 where ci = CUR_CI.ci;
exception
 when no_data_found then
   D_tipo_trattamento := '0';
end; 

dbms_output.put_line('CI '||to_char(CUR_CI.ci));
			FOR CUR_PSEP IN
			   (SELECT GREATEST(psep.dal,TO_DATE(D_ini_a,'ddmmyyyy'))  dal
			         , psep.al                                         al
			         , psep.segmento                                   segmento
			         , psep.assenza                                    assenza
			         , DECODE( posi.contratto_formazione
			                 , 'NO', DECODE
			                         ( posi.stagionale
			                         , 'GG', '2'
			                               , DECODE
			                                 ( posi.part_time
			                                 , 'SI', '8'
			                                       , DECODE
			                                         ( NVL(psep.ore,cost.ore_lavoro)
			                                         , cost.ore_lavoro, '1'
			                                                          , '9')
			                                 )
			                         )
			                       , posi.tipo_formazione)                   impiego
			         , DECODE( psep.assenza
			                 , NULL, DECODE
			                         ( nvl(psep.ore,cost.ore_lavoro)
                                           , cost.ore_lavoro, decode( least(D_anno,2000)
                                                                      ,2000, '4', '11')
                                          , decode(posi.part_time
                                                  , 'SI', DECODE( LEAST(D_anno,2000)
	    		                                               , 2000, '5', '12')
                                                        , decode ( LEAST(D_anno,2000)
			                                                ,2000, '4', '11'))
                                           )
			                       , decode(aste.cat_fiscale,'32','30',aste.cat_fiscale )
                                    )                       servizio
                          , decode ( psep.assenza
                                    , null, null, decode(aste.cat_fiscale,'32',aste.per_ret, null)
                                    )                       perc_l300
                           , psep.posizione              posizione
                           , posi.part_time              part_time
                           , figi.profilo                profilo
                           , psep.ore                    ore
                           , cost.ore_lavoro             ore_lavoro
			      FROM POSIZIONI                   posi
			         , ASTENSIONI                  aste
			         , QUALIFICHE_GIURIDICHE       qugi
                           , figure_giuridiche           figi
			         , CONTRATTI_STORICI           cost
			         , periodi_servizio_previdenza psep
			     WHERE psep.ci             = CUR_CI.ci
			       AND psep.gestione       = CUR_CI.gestione
			       AND aste.codice    (+)  = psep.assenza
			       AND aste.servizio  (+) != 0
			       AND posi.codice    (+)  = psep.posizione
                         and figi.numero         = psep.figura
			       AND qugi.numero         = psep.qualifica
                         AND psep.dal           <= P_RIFERIMENTO
			       AND NVL(psep.al,P_RIFERIMENTO)
                             BETWEEN qugi.dal AND NVL(qugi.al,TO_DATE('3333333','j'))
                         and nvl(psep.al,p_RIFERIMENTO) 
                             between figi.dal and nvl(figi.al,to_date('3333333','j'))
			       AND cost.contratto      = qugi.contratto
			       AND NVL(psep.al,P_RIFERIMENTO)
                             BETWEEN cost.dal AND NVL(cost.al,TO_DATE('3333333','j'))
			       AND NVL(psep.al,TO_DATE('3333333','j'))
			                              >= TO_DATE(D_ini_a,'ddmmyyyy')
			       AND psep.dal <= NVL(psep.al,TO_DATE('3333333','j'))
			       AND psep.segmento      IN
			          (SELECT 'i' FROM dual
			            UNION
			           SELECT 'a' FROM dual
			            WHERE NOT EXISTS
			                  (SELECT 'x'
			                     FROM ASTENSIONI
			                    WHERE codice = psep.assenza
			                      AND servizio = 0)
			            UNION
			           SELECT 'c' FROM dual
			            UNION
			           SELECT 'f' FROM dual
			            UNION
			           SELECT 'u' FROM dual
			            WHERE NOT EXISTS
			                 (SELECT 'x'
			                    FROM periodi_servizio_previdenza
			                   WHERE ci      = psep.ci
			                     AND segmento = 'a'
			                     AND dal     <= psep.dal
			                     AND NVL(al,TO_DATE('3333333','j')) >= psep.dal)
			          )
			     ORDER BY 2,3
			   ) LOOP
	   	           D_num_servizi := D_num_servizi + 1;
                       DENUNCE_INPDAP.PREVIDENZA( CUR_CI.ci, CUR_PSEP.posizione, CUR_PSEP.profilo,D_tipo_trattamento
                                                , D_ini_a, D_fin_a, D_previdenza, CUR_PSEP.dal, CUR_PSEP.al, D_pr_err_0
                                                , D_pr_err_1, I_pensione, I_previdenza, prenotazione, P_denuncia);
                        BEGIN
			         SELECT DECODE( I_previdenza
			                      , 'CPDEL', codice_cpd
			                               , codice_cps)
			              , DECODE( I_previdenza
			                      , 'CPDEL', posizione_cpd
			                               , posizione_cps)
			           INTO I_codice,I_posizione
			           FROM rapporti_retributivi
			          WHERE ci = CUR_CI.ci;
			    EXCEPTION
			         WHEN NO_DATA_FOUND THEN I_codice    := NULL;
			                                 I_posizione := NULL;
			       END;
               BEGIN
         SELECT ROUND(SUM(DECODE( vaca.colonna
                          , 'COMP_INADEL', vaca.valore
                                         , 0))
                            / nvl(MAX(DECODE( vaca.colonna
                                        , 'COMP_INADEL', NVL(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(MAX(DECODE( vaca.colonna
                                        , 'COMP_INADEL', NVL(esvc.arrotonda,0.01)
                                                       , '')),1)
              , ROUND(SUM(DECODE( vaca.colonna
                          , 'COMP_TFR', vaca.valore
                                         , 0))
                            / nvl(MAX(DECODE( vaca.colonna
                                        , 'COMP_TFR', NVL(esvc.arrotonda,0.01)
                                                      , '')),1)
                      )
                            * nvl(MAX(DECODE( vaca.colonna
                                        , 'COMP_TFR', NVL(esvc.arrotonda,0.01)
                                                      , '')),1)
             , ROUND(SUM(DECODE( vaca.colonna
                             , 'IPN_TFR', vaca.valore
                                         , 0))
                            / nvl(MAX(DECODE( vaca.colonna
                                        , 'IPN_TFR', NVL(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(MAX(DECODE( vaca.colonna
                                        , 'IPN_TFR', NVL(esvc.arrotonda,0.01)
                                                      , '')),1)
           INTO I_comp_inadel,I_comp_tfr,I_ipn_tfr
           FROM valori_contabili_annuali vaca
              , ESTRAZIONE_VALORI_CONTABILI esvc
          WHERE esvc.estrazione        = vaca.estrazione
            AND esvc.colonna           = vaca.colonna
            AND esvc.dal              <= NVL(cur_psep.al,LAST_DAY(P_RIFERIMENTO))
            AND NVL(esvc.al,TO_DATE('3333333','j'))
                                      >= CUR_PSEP.dal
            AND vaca.riferimento BETWEEN esvc.dal
                                     AND NVL(esvc.al,TO_DATE('3333333','j'))
            AND vaca.anno              = D_anno
            AND vaca.mese              = D_mese
            AND vaca.MENSILITA         = D_mensilita
            AND vaca.estrazione        = 'DENUNCIA_INPDAP'
            AND vaca.colonna          IN ('COMP_INADEL','COMP_TFR','IPN_TFR')
            AND vaca.ci                = CUR_CI.ci
            AND vaca.moco_mensilita    != '*AP'
            AND to_char(vaca.riferimento,'yyyymm') BETWEEN to_char(CUR_PSEP.dal,'yyyymm')
                                     AND to_char(NVL(cur_psep.al,LAST_DAY(P_RIFERIMENTO)),'yyyymm');
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
           I_comp_inadel := TO_NUMBER(NULL);
           I_comp_tfr    := TO_NUMBER(NULL);
           I_ipn_tfr     := TO_NUMBER(NULL);
       END;

I_contribuzione   := null;
I_enpdep          := null;

DENUNCE_INPDAP.CONTRIBUZIONE (D_anno, D_fin_a,I_comp_inadel, I_comp_tfr,I_ipn_tfr, CUR_CI.ci, I_contribuzione, I_enpdep);

			     IF NVL(TO_CHAR(D_elab,'yyyy'),TO_CHAR(P_RIFERIMENTO,'yyyy')) 
                          = TO_CHAR(D_prec_elab,'yyyy') THEN
                        LOCK TABLE DENUNCIA_INPDAP IN EXCLUSIVE MODE NOWAIT;
			       INSERT INTO DENUNCIA_INPDAP
			          ( anno
			          , previdenza
			          , assicurazioni
			          , ci
			          , gestione
			          , codice
			          , posizione
			          , rilevanza
			          , dal
			          , al
			          , tipo_impiego
			          , tipo_servizio
                            , perc_L300
			          , data_cessazione
			          , causa_cessazione
			          , utente
			          , data_agg
                            , comparto
                            , sottocomparto
			          )
			     SELECT TO_NUMBER(D_anno)
			          , NVL(I_previdenza,'CPDEL')
			          , NVL(I_pensione||I_contribuzione || I_enpdep ||DECODE(I_previdenza, NULL, NULL, '9'),' ')
			          , CUR_CI.ci
			          , CUR_CI.gestione
			          , I_codice
			          , I_posizione
			          , 'S'
			          , CUR_PSEP.dal
			          , cur_psep.al
			          , CUR_PSEP.impiego
			          , CUR_PSEP.servizio
			          , CUR_PSEP.perc_L300
			          , NULL
			          , NULL
			          , D_utente
			          , P_RIFERIMENTO
                            , P_comparto
                            , P_sottocomparto
			       FROM dual
			      WHERE NOT EXISTS
			           (SELECT 'x' FROM DENUNCIA_INPDAP
			             WHERE anno       = TO_NUMBER(D_anno)
			               AND gestione   = CUR_CI.gestione
			               AND previdenza = I_previdenza
			               AND ci         = CUR_CI.ci
			               AND dal        = CUR_PSEP.dal
			           )
			     ;
                      update denuncia_inpdap
                         set rap_orario = (  nvl( al
                                                , decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento)
                                                )
                                           - dal + 1) * CUR_PSEP.ore / CUR_PSEP.ore_lavoro
                       where anno     = D_anno 
                         and ci       = CUR_CI.ci
                         and dal      = CUR_PSEP.dal
                         and CUR_PSEP.part_time = 'SI';

  			    ELSE LOCK TABLE DENUNCIA_INPDAP IN EXCLUSIVE MODE NOWAIT
			     ;

         IF TO_CHAR(nvl(CUR_PSEP.al,P_RIFERIMENTO),'yyyy') >=  D_anno THEN
	    INSERT INTO DENUNCIA_INPDAP
	          ( anno
	          , previdenza
	          , assicurazioni
	          , ci
	          , gestione
	          , codice
	          , posizione
	          , rilevanza
	          , dal
	          , al
	          , tipo_impiego
	          , tipo_servizio
                , perc_l300
	          , data_cessazione
	          , causa_cessazione
	          , utente
	          , data_agg
                , comparto
                , sottocomparto
                )
	     SELECT TO_NUMBER(D_anno)
	          , NVL(I_previdenza,'CPDEL')
	          , NVL(I_pensione||I_contribuzione || I_enpdep ||DECODE(I_previdenza, NULL, NULL, '9'),' ')
	          , CUR_CI.ci
	          , CUR_CI.gestione
	          , I_codice
	          , I_posizione
	          , 'S'
	          , GREATEST(CUR_PSEP.dal,TO_DATE('0101'||TO_CHAR(P_RIFERIMENTO,'yyyy'),'ddmmyyyy'))
	          , decode( nvl( to_char( cur_psep.al, 'yyyy' ), D_anno)
                        , D_anno, decode( P_sfasato
                                        , 'X', decode( least(nvl(cur_psep.al,add_months(P_riferimento,-1)),add_months(P_riferimento,-1))
                                                     , cur_psep.al, cur_psep.al
                                                                  , decode( to_char(P_riferimento,'ddmmyyyy')
                                                                          , '3112'||D_anno,add_months(P_riferimento,-1)
                                                                                          ,null )
                                                                          )
                                                     , decode( least(nvl(cur_psep.al,P_riferimento),P_riferimento)
                                                             , cur_psep.al, cur_psep.al
                                                                          , decode( to_char(P_riferimento,'ddmmyyyy')
                                                                                  , '3112'||D_anno,P_riferimento
                                                                                                  ,null )
                                                                                  ) 
                                                             )
                                , decode(P_sfasato
                                        ,'X',decode(to_char(P_riferimento,'ddmmyyyy')
                                                    ,'3112'||D_anno,to_date('3011'||D_anno,'ddmmyyyy')
--                                                    ,'3011'||D_anno,to_date('3110'||D_anno,'ddmmyyyy')
                                                                   ,null
                                                    )
                                            ,decode(to_char(P_riferimento,'ddmmyyyy')
                                                    ,'3112'||D_anno,P_riferimento
                                                                   ,null
                                                   )
                                        )
                          )
	          , CUR_PSEP.impiego
	          , CUR_PSEP.servizio
	          , CUR_PSEP.perc_l300
	          , NULL
	          , NULL
	          , D_utente
	          , P_RIFERIMENTO
                , P_comparto
                , P_sottocomparto
	       FROM dual
	      WHERE NOT EXISTS
	           (SELECT 'x' FROM DENUNCIA_INPDAP
	             WHERE anno       = TO_NUMBER(D_anno)
	               AND gestione   = CUR_CI.gestione
	               AND previdenza = I_previdenza
	               AND ci         = CUR_CI.ci
	               AND dal        = CUR_PSEP.dal
	           )
	     ;
                    update denuncia_inpdap 
                       set al = CUR_PSEP.al
		         WHERE ci = CUR_CI.ci 
 		           AND gestione   = CUR_CI.gestione
		           AND previdenza = I_previdenza
		           AND ci         = CUR_CI.ci
	 	           AND dal        = CUR_PSEP.dal
                       AND EXISTS
			      (SELECT 'x' FROM DENUNCIA_INPDAP
			        WHERE anno       = TO_NUMBER(D_anno)
			          AND gestione   = CUR_CI.gestione
			          AND previdenza = I_previdenza
			          AND ci         = CUR_CI.ci
			          AND dal        = CUR_PSEP.dal
                            AND AL         > CUR_PSEP.al
  		            )
			     ;
                      update denuncia_inpdap
                         set rap_orario = (  nvl( al
                                                , decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento)
                                                )
                                           - dal + 1) * CUR_PSEP.ore / CUR_PSEP.ore_lavoro
                       where anno     = D_anno 
                         and ci       = CUR_CI.ci
                         and dal      = GREATEST(CUR_PSEP.dal,TO_DATE('0101'||TO_CHAR(P_RIFERIMENTO,'yyyy'),'ddmmyyyy'))
                         and CUR_PSEP.part_time = 'SI';

                    END IF;
				 IF TO_CHAR(CUR_PSEP.dal,'yyyy') = TO_CHAR(D_anno-1) THEN
				   LOCK TABLE DENUNCIA_INPDAP IN EXCLUSIVE MODE NOWAIT
			       ;
			       INSERT INTO DENUNCIA_INPDAP
			          ( anno
			          , previdenza
			          , assicurazioni
			          , ci
			          , gestione
			          , codice
			          , posizione
			          , rilevanza
			          , dal
			          , al
			          , tipo_impiego
			          , tipo_servizio
			          , perc_l300
			          , data_cessazione
			          , causa_cessazione
			          , utente
			          , data_agg
                            , comparto
                            , sottocomparto
			          )
			     SELECT decode(P_sfasato,'X',D_anno,TO_NUMBER(D_anno)-1)
			          , NVL(I_previdenza,'CPDEL')
			          , NVL(I_pensione||I_contribuzione || I_enpdep ||DECODE(I_previdenza, NULL, NULL, '9'),' ')
			          , CUR_CI.ci
			          , CUR_CI.gestione
			          , I_codice
			          , I_posizione
			          , 'S'
			          , CUR_PSEP.dal
			          , LEAST(nvl(CUR_PSEP.al,to_date('3333333','j')),to_date('3112'||TO_CHAR(D_anno-1),'ddmmyyyy'))
			          , CUR_PSEP.impiego
			          , CUR_PSEP.servizio
			          , CUR_PSEP.perc_l300
			          , NULL
			          , NULL
			          , D_utente
			          , P_RIFERIMENTO
                      , P_comparto
                      , P_sottocomparto
			       FROM dual
			      WHERE NOT EXISTS
			           (SELECT 'x' FROM DENUNCIA_INPDAP
			             WHERE anno       = TO_NUMBER(D_anno)
			               AND gestione   = CUR_CI.gestione
			               AND previdenza = I_previdenza
			               AND ci         = CUR_CI.ci
			               AND dal        = CUR_PSEP.dal
			           )
			     ;
                      update denuncia_inpdap
                         set rap_orario = (  nvl( al
                                                , decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento)
                                                )
                                           - dal + 1) * CUR_PSEP.ore / CUR_PSEP.ore_lavoro
                       where anno     = D_anno 
                         and ci       = CUR_CI.ci
                         and dal      = CUR_PSEP.dal
                         and CUR_PSEP.part_time = 'SI';

				 END IF;

			   END IF;
			       BEGIN
			         SELECT TO_CHAR(pegi.al ,'ddmmyyyy'),
			                evra.cat_inpdap
			           INTO I_data_ces,
			                I_causa_ces
			           FROM PERIODI_GIURIDICI pegi,
			                EVENTI_RAPPORTO   evra
			          WHERE pegi.rilevanza = 'P'
			            AND pegi.ci        = CUR_CI.ci
			            AND pegi.posizione    = evra.codice
			            AND pegi.al  BETWEEN CUR_PSEP.dal
			                        AND NVL(cur_psep.al,LAST_DAY(P_RIFERIMENTO));
			       EXCEPTION
			         WHEN NO_DATA_FOUND THEN I_data_ces := NULL;
			                                 I_causa_ces := NULL;
			       END;
                 COMMIT;

                  UPDATE DENUNCIA_INPDAP
                     SET data_cessazione  = TO_DATE(I_data_ces,'ddmmyyyy'),
                         causa_cessazione = I_causa_ces
                   WHERE anno = D_anno
                     AND gestione = CUR_CI.gestione
                     AND ci = CUR_CI.ci
                     AND rilevanza = 'S'
                     AND TO_DATE(I_data_ces,'ddmmyyyy') 
                         between dal and nvl(al,TO_DATE(I_data_ces,'ddmmyyyy')) 
                     AND TO_DATE(I_data_ces,'ddmmyyyy') <= P_RIFERIMENTO
                     AND trunc(data_agg) = P_RIFERIMENTO
                  ;
                 COMMIT;
	        END LOOP; -- CUR_PSEP
    IF P_ultima_cess = 'X' THEN
     UPDATE DENUNCIA_INPDAP dedp
        SET data_cessazione = null
          , causa_cessazione = null
      WHERE anno = D_anno
        AND gestione = CUR_CI.gestione
        AND ci = CUR_CI.ci
        AND rilevanza = 'S'
        AND exists (SELECT 'x'
                     FROM DENUNCIA_INPDAP dein
                    WHERE dein.anno = dedp.anno
                      AND dein.gestione = dedp.gestione
                      AND dein.ci = dedp.ci
                      AND dein.rilevanza = 'S'
                      and data_cessazione > dedp.data_cessazione
                     ) 
        and trunc(data_agg) = P_RIFERIMENTO
     ;
    COMMIT;
  END IF;
/* Cancello i record futuri */
   BEGIN 
    delete from denuncia_inpdap
     where ( to_char(dal,'yyyy') > D_anno
        or dal > P_riferimento )
       and anno = D_anno
       and ci   = CUR_CI.ci;
    update denuncia_inpdap
       set data_cessazione = null, causa_cessazione = null
     where to_char(data_cessazione,'yyyy') > D_anno
       and ci = CUR_CI.ci;
    commit;
/* Assestamento periodi sfasati */
 IF P_sfasato = 'X'
   THEN
    update denuncia_inpdap 
       set al = to_date('3112'||D_anno-1,'ddmmyyyy')
     where anno = D_anno
       and ci   = CUR_CI.ci
       and to_char(dal,'yyyy') = D_anno-1
       and al is null;
   commit;
   IF to_char(P_riferimento,'mmyyyy') = '01'||D_anno
   THEN
    delete from denuncia_inpdap
     where anno = D_anno
       and ci   = CUR_CI.ci
       and dal  >= to_date('0101'||D_anno,'ddmmyyyy')
     ;
    commit;
   ELSIF P_riferimento >= to_date(D_fin_a,'ddmmyyyy')
   THEN
    delete from denuncia_inpdap
     where anno = D_anno
       and ci   = CUR_CI.ci
       and dal  > to_date(D_fin_a,'ddmmyyyy')
     ;
    commit;
   END IF;
 END IF; -- p_sfasato
   END;
-- Attribuzione qualifica ministeriale
    IF P_economica = 'X' THEN
      BEGIN
      select greatest(nvl(max(progressivo),0),150000)
        into D_pr_err_5
        from a_segnalazioni_errore
       where no_prenotazione = prenotazione
         and passo           = 1
         and progressivo between 150000 and 200000;
      EXCEPTION 
           WHEN NO_DATA_FOUND THEN D_pr_err_5 := 150000;
      END;
      DENUNCE_INPDAP.DETERMINA_QUALIFICA(D_anno,CUR_CI.ci,D_ini_a, D_fin_a,D_qualifica,CUR_CI.gestione
                                        ,D_pr_err_5, prenotazione, P_denuncia);
     END IF; -- controllo su economica
     DENUNCE_INPDAP.AGGIUNGI_SEGNALAZIONI (D_anno, D_ini_a, D_fin_a, CUR_CI.ci, prenotazione, D_pr_err_4);
   END;      
            
/* Controllo su tipo_servizio 30 */
      BEGIN
      select greatest(nvl(max(progressivo),0),70000)
        into D_pr_err_7
        from a_segnalazioni_errore
       where no_prenotazione = prenotazione
         and passo           = 1
         and progressivo between 70000 and 80000;
      EXCEPTION 
           WHEN NO_DATA_FOUND THEN D_pr_err_7 := 70000;
      END;
      V_controllo := null;
      BEGIN
      select 'X'
        into v_controllo
        from dual
       where exists ( select 'x' from denuncia_inpdap
                       where anno = D_anno 
                         and ci = CUR_CI.ci
                         and tipo_servizio = '30'
                    );
     EXCEPTION WHEN NO_DATA_FOUND THEN  
        V_Controllo := null;
     END;
    IF V_controllo = 'X' THEN
       D_pr_err_7 := D_pr_err_7 + 1;
       IF D_pr_err_7 >= 80000 THEN NULL;
       ELSE
 	     INSERT INTO a_segnalazioni_errore
           ( no_prenotazione, passo, progressivo, errore, precisazione )
	     SELECT prenotazione
                 , 1
                 , D_pr_err_7
                 , 'P05184'
                 , ' Per il Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')
             FROM dual;
      END IF;
    END IF;

  END LOOP; -- CUR_CI

-- Loop che estrae i dipendenti che hanno periodi con assicurazioni diverse
BEGIN
   FOR CUR_SEGNALA2 IN
     (select anno
            ,ci
	        ,previdenza
	        ,assicurazioni
	        ,gestione
	        ,codice
	        ,posizione
	        ,rilevanza
	        ,dal
	        ,al
	        ,tipo_impiego
	        ,tipo_servizio
	        ,data_cessazione
	        ,causa_cessazione
	        ,utente
	        ,tipo_agg
	        ,data_agg
	        ,maggiorazioni
        from denuncia_inpdap dedp1
       where dedp1.anno = D_anno
         and exists (select 'x'
		       from denuncia_inpdap dedp2
			  where anno = D_anno
			    and dedp1.ci = dedp2.ci
		        and dedp1.assicurazioni != dedp2.assicurazioni
	                )
         and ( D_tipo != 'S' 
          or   D_tipo = 'S' and dedp1.ci = D_ci)
         and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = dedp1.ci
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
	 ) LOOP
	     BEGIN
		   D_pagina := D_pagina + 1;
           D_riga   := D_riga + 1;
           INSERT INTO a_appoggio_stampe
                VALUES ( prenotazione
                       , 3
                       , D_pagina
                       , D_riga
                       , LPAD(NVL(D_anno,' '),4,' ')||
                         LPAD(TO_CHAR(NVL(CUR_SEGNALA2.ci,0)),8,' ')||
			             RPAD(NVL(CUR_SEGNALA2.previdenza,' '),6,' ')||
			             RPAD(NVL(CUR_SEGNALA2.assicurazioni,' '),6,' ')||
			             RPAD(NVL(CUR_SEGNALA2.gestione,' '),4,' ')||
			             RPAD(NVL(CUR_SEGNALA2.codice,' '),10,' ')||
			             RPAD(NVL(CUR_SEGNALA2.posizione,' '),8,' ')||
			             RPAD(NVL(CUR_SEGNALA2.rilevanza,' '),1,' ')||
			             RPAD(NVL(TO_CHAR(CUR_SEGNALA2.dal,'ddmmyyyy'),' '),8,' ')||
			             RPAD(NVL(TO_CHAR(CUR_SEGNALA2.al,'ddmmyyyy'),' '),8,' ')||
			             RPAD(NVL(CUR_SEGNALA2.tipo_impiego,' '),2,' ')||
			             RPAD(NVL(CUR_SEGNALA2.tipo_servizio,' '),2,' ')||
                               RPAD(NVL(TO_CHAR(CUR_SEGNALA2.data_cessazione,'ddmmyyyy'),' '),8,' ')||
                               RPAD(NVL(CUR_SEGNALA2.causa_cessazione,' '),2,' ')||
                               RPAD(NVL(CUR_SEGNALA2.utente,' '),8,' ')||
                               RPAD(NVL(CUR_SEGNALA2.tipo_agg,' '),1,' ')||
                               RPAD(NVL(TO_CHAR(CUR_SEGNALA2.data_agg,'ddmmyyyy'),' '),8,' ')||
                               RPAD(NVL(CUR_SEGNALA2.maggiorazioni,' '),12,' ')
                         )
           ;
	 END;
       END LOOP; -- CUR_SEGNALA2
 commit;
END;
-- Loop che estrae i dipendenti che hanno periodi che hanno periodi che si intersecano tra loro
BEGIN
   FOR CUR_SEGNALA3 IN
     (select anno
            ,ci
            ,previdenza
            ,assicurazioni
            ,gestione
            ,codice
            ,posizione
            ,rilevanza
            ,dal
            ,al
            ,tipo_impiego
            ,tipo_servizio
            ,data_cessazione
            ,causa_cessazione
            ,utente
            ,tipo_agg
            ,data_agg
            ,maggiorazioni
       from denuncia_inpdap dedp1
      where anno = d_anno
        and exists (select 'x'
		              from denuncia_inpdap dedp2
			         where anno = d_anno
			           and dedp1.ci = dedp2.ci
			           and dedp2.dal < NVL(dedp1.al,TO_DATE('3333333','j'))
			           and nvl(dedp2.al,to_date(D_fin_a,'ddmmyyyy')) > NVL(dedp1.dal,TO_DATE('3333333','j'))
			           and dedp2.rowid != dedp1.rowid
		           )
         and ( D_tipo != 'S' 
          or   D_tipo = 'S' and dedp1.ci = D_ci)
         and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = dedp1.ci
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
        ) LOOP
	     BEGIN
		   D_pagina := D_pagina + 1;
           D_riga   := D_riga + 1;
           INSERT INTO a_appoggio_stampe
                VALUES ( prenotazione
                       , 4
                       , D_pagina
                       , D_riga
                       , LPAD(NVL(D_anno,' '),4,' ')||
                         LPAD(TO_CHAR(NVL(CUR_SEGNALA3.ci,0)),8,' ')||
  	                   RPAD(NVL(CUR_SEGNALA3.previdenza,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA3.assicurazioni,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA3.gestione,' '),4,' ')||
		             RPAD(NVL(CUR_SEGNALA3.codice,' '),10,' ')||
		             RPAD(NVL(CUR_SEGNALA3.posizione,' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA3.rilevanza,' '),1,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA3.dal,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA3.al,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA3.tipo_impiego,' '),2,' ')||
		             RPAD(NVL(CUR_SEGNALA3.tipo_servizio,' '),2,' ')||
                         RPAD(NVL(TO_CHAR(CUR_SEGNALA3.data_cessazione,'ddmmyyyy'),' '),8,' ')||
			       RPAD(NVL(CUR_SEGNALA3.causa_cessazione,' '),2,' ')||
			       RPAD(NVL(CUR_SEGNALA3.utente,' '),8,' ')||
			       RPAD(NVL(CUR_SEGNALA3.tipo_agg,' '),1,' ')||
			       RPAD(NVL(TO_CHAR(CUR_SEGNALA3.data_agg,'ddmmyyyy'),' '),8,' ')||
			       RPAD(NVL(CUR_SEGNALA3.maggiorazioni,' '),12,' ')
                         )
           ;
		 END;
       END LOOP; -- CUR_SEGNALA3
 commit;
END;

-- Loop che estrae i dipendenti che hanno data_cessazione senza codice o viceversa
BEGIN
   FOR CUR_SEGNALA4 IN
       (select anno
              ,ci
              ,previdenza
	        ,assicurazioni
	        ,gestione
	        ,codice
	        ,posizione
	        ,rilevanza
	        ,dal
	        ,al
	        ,tipo_impiego
	        ,tipo_servizio
	        ,data_cessazione
	        ,causa_cessazione
	        ,utente
	        ,tipo_agg
	        ,data_agg
	        ,maggiorazioni
        from denuncia_inpdap dedp1
       where dedp1.anno = D_anno
         and ( D_tipo != 'S' 
          or   D_tipo = 'S' and dedp1.ci = D_ci)
         and ( data_cessazione is not null and causa_cessazione is null
            or causa_cessazione is not null and data_cessazione is null
             ) 
         and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = dedp1.ci
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
	 ) LOOP
	     BEGIN
	     D_pagina := D_pagina + 1;
           D_riga   := D_riga + 1;
           INSERT INTO a_appoggio_stampe
                VALUES ( prenotazione
                       , 5
                       , D_pagina
                       , D_riga
                       , LPAD(NVL(D_anno,' '),4,' ')||
                         LPAD(TO_CHAR(NVL(CUR_SEGNALA4.ci,0)),8,' ')||
		             RPAD(NVL(CUR_SEGNALA4.previdenza,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA4.assicurazioni,' '),6,' ')||
		             RPAD(NVL(CUR_SEGNALA4.gestione,' '),4,' ')||
		             RPAD(NVL(CUR_SEGNALA4.codice,' '),10,' ')||
		             RPAD(NVL(CUR_SEGNALA4.posizione,' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA4.rilevanza,' '),1,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA4.dal,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(TO_CHAR(CUR_SEGNALA4.al,'ddmmyyyy'),' '),8,' ')||
		             RPAD(NVL(CUR_SEGNALA4.tipo_impiego,' '),2,' ')||
		             RPAD(NVL(CUR_SEGNALA4.tipo_servizio,' '),2,' ')||
                         RPAD(NVL(TO_CHAR(CUR_SEGNALA4.data_cessazione,'ddmmyyyy'),' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA4.causa_cessazione,' '),2,' ')||
                         RPAD(NVL(CUR_SEGNALA4.utente,' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA4.tipo_agg,' '),1,' ')||
                         RPAD(NVL(TO_CHAR(CUR_SEGNALA4.data_agg,'ddmmyyyy'),' '),8,' ')||
                         RPAD(NVL(CUR_SEGNALA4.maggiorazioni,' '),12,' ')
                         )
           ;
	 END;
       END LOOP; -- CUR_SEGNALA4
  commit;
 END;

-- 29/09/2004 spostate le tre update prima dell'accorpamento in quanto agiscono su dati determinanti per l'accorpamento. 
-- ci 6146 su p00 di svi NON accorpava dei periodi perchè avevano il tipo impiego diverso che veniva poi modificato 
-- (rendendolo uguale) dalle update DOPO l'accorpamento. Morena.

DENUNCE_INPDAP.UPDATE_IMPIEGO_SERVIZIO(D_anno, D_fin_a, P_denuncia, P_riferimento);
DENUNCE_INPDAP.UPDATE_IMPIEGO(D_anno,D_fin_a, P_denuncia, P_riferimento);
DENUNCE_INPDAP.UPDATE_SERVIZIO(D_anno, D_pr_err_3, prenotazione, P_denuncia);

-- estrazione dipendenti da accorpare: non possibile dentro il cur_ci (test effettuato negativo su ci = 7624) 
  FOR CUR_DIP IN 
  ( select distinct dedp.ci
      from denuncia_inpdap dedp
     where dedp.anno = D_anno
       and (D_tipo != 'S'
        or  D_tipo = 'S' and dedp.ci = D_ci)
       and exists
          (select 'x'
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
  ) LOOP
  BEGIN
     DENUNCE_INPDAP.ACCORPA_PERIODI (D_anno, CUR_DIP.ci, P_sfasato);
  END;
  END LOOP; -- cur_dip
IF P_economica = 'X' THEN
      update a_prenotazioni
         set prossimo_passo = 3
       where no_prenotazione = prenotazione;
      commit;
ELSE 
      update a_prenotazioni
         set prossimo_passo = 4
       where no_prenotazione = prenotazione;
      commit;
END IF;
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
END;
END;
END;
/
