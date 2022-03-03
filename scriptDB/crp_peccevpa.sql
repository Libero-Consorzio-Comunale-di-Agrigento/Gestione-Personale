CREATE OR REPLACE PACKAGE Peccevpa IS
/******************************************************************************
 NOME:        PECCEVPA
 DESCRIZIONE:  Estrazione eventi da Assenze-Presenze per Economico-Contabile.
               Questa fase determina le voci contabili degli eventi di presenza e assen-
               za in base alla definizione delle Causali. La fase produce un archivio
               di appoggio in cui vengono registrate le voci relavite a eventi indivi-
               duali (Eventi_Presenza), eventi a classe (Valori_Presenza) e totalizza-
               zioni di eventi (Totalizzazione_Causali).
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 1.1  08/11/2005 MS     Modifica gestione del riferimento ( att. 13071 )
 1.2  07/02/2006 MS     Aggiunta segnalazione per ragi ( att. 13071 )

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY Peccevpa IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 07/02/2006';
END VERSIONE;
PROCEDURE main (prenotazione IN NUMBER,
	   			 	   passo IN NUMBER) IS
BEGIN
DECLARE   d_errore                VARCHAR2(6);
          d_anno                  NUMBER(4);
          d_mese                  NUMBER(2);
          d_mensilita             VARCHAR2(3);
          d_ini_ela               DATE;
          d_fin_ela               DATE;
          errore                  EXCEPTION;
          d_opzione               VARCHAR2(1);
BEGIN
/*
          +--------------------------------------------------------+
          | Memorizzazione parametri (attivazione arretrato C per  |
          | tutte le voci riferite all'anno precedente)            |
          +--------------------------------------------------------+
*/
  BEGIN
    SELECT para.valore
      INTO d_opzione
      FROM a_parametri para
     WHERE para.no_prenotazione = prenotazione
       AND para.parametro       = 'P_ARRETRATO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_opzione := '';
  END;
/*
/*
          +--------------------------------------------------------+
          | Memorizzazione dati del periodo di riferimento della   |
          | gestione economica.                                    |
          +--------------------------------------------------------+
*/
  BEGIN
    SELECT  anno,mese,MENSILITA,ini_ela,fin_ela
      INTO  d_anno,d_mese,d_mensilita,d_ini_ela,d_fin_ela
      FROM  RIFERIMENTO_RETRIBUZIONE
     WHERE  rire_id     = 'RIRE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_errore := 'P05140';
      RAISE errore;
  END;
/*
          +--------------------------------------------------------+
          | Eliminazione da MOVIMENTI_CONTABILI delle voci even-   |
          | tualmente gia` caricate per la Mensilita` di riferi-   |
          | mento Retribuzione provenienti da Gestione Presenze.   |
          +--------------------------------------------------------+
*/
  BEGIN
    DELETE FROM MOVIMENTI_CONTABILI moco
     WHERE moco.input              IN (SELECT 'P' FROM dual
	                                    UNION
									   SELECT 'M' FROM dual
									  )
       AND moco.anno                = d_anno
       AND moco.mese                = d_mese
       AND moco.MENSILITA           = d_mensilita
       AND moco.ci                  > 0
       AND (EXISTS
          (SELECT 'x' FROM DEPOSITO_EVENTI_EC
            WHERE ci    = moco.ci
              AND voce  = moco.voce
              AND sub   = moco.sub
          )
        OR EXISTS
          ( SELECT 'x' FROM RAPPORTI_PRESENZA
             WHERE ci = moco.ci
               AND flag_ec = 'M'
          ))
    ;
    DELETE FROM MOVIMENTI_CONTABILI moco
     WHERE moco.input               = 'D'
       AND moco.anno                = d_anno
       AND moco.mese                = d_mese
       AND moco.MENSILITA           = d_mensilita
       AND moco.ci                 IN (SELECT rapa.ci
                                         FROM RAPPORTI_PRESENZA rapa
                                        WHERE rapa.flag_ec      = 'M'
                                      )
       AND moco.sede_del            = 'F'
       AND moco.anno_del            = d_anno
       AND moco.numero_del          = d_mese
    ;
    UPDATE RAPPORTI_GIURIDICI
       SET flag_elab = 'P'
     WHERE flag_elab IN ('E','C')
       AND ci        IN (SELECT rapa.ci
                           FROM RAPPORTI_PRESENZA rapa
                          WHERE rapa.flag_ec      = 'M'
                        )
    ;
    COMMIT;
  END;
/*
          +--------------------------------------------------------+
          | Emissione voci contabili.                              |
          +--------------------------------------------------------+
*/
  BEGIN
    INSERT  INTO MOVIMENTI_CONTABILI
           (ci
           ,voce
           ,sub
           ,riferimento
           ,arr
           ,input
           ,qta_var
           ,tar_var
           ,imp_var
           ,delibera
           ,sede_del
           ,anno_del
           ,numero_del
           ,anno
           ,mese
           ,MENSILITA
           ,data
           )
    SELECT  deec.ci
           ,deec.voce
           ,deec.sub
           ,least(deec.riferimento,d_fin_ela)
           ,DECODE( TO_CHAR(deec.riferimento,'yyyy')
                  , d_anno, deec.arr
                          , NVL(d_opzione,deec.arr)
                  )
           ,DECODE(deec.delibera,NULL,DECODE(deec.gestione,'P','M','P'),'D')
           ,DECODE(deec.qta,0,NULL,deec.qta)
           ,DECODE(deec.tar,0,NULL,deec.tar)
           ,DECODE(deec.imp,0,NULL,deec.imp)
           ,deec.delibera
           ,DECODE(deec.delibera,NULL,NULL,'F')
           ,DECODE(deec.delibera,NULL,NULL,d_anno)
           ,DECODE(deec.delibera,NULL,NULL,d_mese)
           ,d_anno
           ,d_mese
           ,d_mensilita
           ,TO_DATE(TO_CHAR(SYSDATE,'ddmmyyyy'),'ddmmyyyy')
     FROM   DEPOSITO_EVENTI_EC deec
   ;
/* Inserimento segnalazioni per riferimenti > data di fine mese oppure > ragi.al */

      INSERT INTO a_segnalazioni_errore
      (no_prenotazione, passo, progressivo, errore, precisazione)
      select distinct prenotazione,1,rownum,'P05732'
           , substr(' - Voce: '||deec.voce||' - Cod.Ind.: '||deec.ci||' '||rain.cognome||' '||rain.nome,1,50)
        from DEPOSITO_EVENTI_EC deec
           , rapporti_individuali rain
           , rapporti_giuridici   ragi
       where deec.ci = rain.ci
         and ragi.ci = rain.ci
         and ( deec.riferimento > d_fin_ela
           or  deec.riferimento > nvl(ragi.al,to_date('3333333','j'))
             )
       ;

/*
          +--------------------------------------------------------+
          | Eliminazione movimenti da DEPOSITO_EVENTI_EC.          |
          +--------------------------------------------------------+
*/
   DELETE FROM DEPOSITO_EVENTI_EC;
/*
          +--------------------------------------------------------+
          | Viene ripristinato il flag_ec sui RAPPORTI_PRESENZA in |
          | tutti gli individui trattati che non hanno voci gia`   |
          | calcolate in VALORI_PRESENZA per mensilita` successive.|
          +--------------------------------------------------------+
*/
   UPDATE RAPPORTI_PRESENZA rapa
      SET rapa.flag_ec  = NULL
    WHERE rapa.flag_ec  = 'M'
      AND NOT EXISTS (SELECT 'x'
                        FROM VALORI_PRESENZA vapa
                            ,EVENTI_PRESENZA evpa
                       WHERE vapa.evento        = evpa.evento
                         AND evpa.dal           > d_fin_ela
                     )
   ;
   COMMIT;
  END;
EXCEPTION
  WHEN errore THEN
    ROLLBACK;
    UPDATE a_prenotazioni SET errore         = d_errore
                             ,prossimo_passo = 99
     WHERE no_prenotazione = prenotazione
    ;
END;
COMMIT;
END;
END;
/

