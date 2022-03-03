CREATE OR REPLACE PACKAGE Pecrcnon IS
/******************************************************************************
 NOME:          PECRCNON
 DESCRIZIONE:   Conguaglio Individuale Nuova Onaosi 2005 x variazione dati 
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    25/10/2005 NN
 1.1  15/02/2006 NN     Passati anche voce e data al calcolo onaosi.
 1.2  15/03/2007 AM     ATtivato il parameto "trattamento" anche con % 
                        e introdotto test su mese/ ensilita < di quello richiesto
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY Pecrcnon IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.1 del 15/02/2006';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
  D_ci                 NUMBER(8);
  D_tratt_prev         VARCHAR(4);
  D_data_inizio        DATE;
  D_anno               NUMBER(4);
  D_cod_mensilita      VARCHAR(4);
  D_errore             VARCHAR(200);
  D_dummy              VARCHAR(1);
  D_riga               NUMBER:=0;
  D_mese               NUMBER(2);
  D_mensilita          VARCHAR(3);
  D_imp                NUMBER:=0;
  D_imp_cong           NUMBER:=0;
  uscita               exception;
-- Parametri per Trace
  p_trc                NUMBER;        -- Tipo di Trace
  p_prn                NUMBER;        -- Numero di Prenotazione elaborazione
  p_pas                NUMBER;        -- Numero di Passo procedurale
  p_prs                NUMBER;        -- Numero progressivo di Segnalazione
  p_stp                VARCHAR(30);   -- Step elaborato
  p_tim                VARCHAR(30);   -- Time impiegato in secondi
--
-- Estrazione Parametri di Selezione della Prenotazione
--
 BEGIN -- conguaglio individuale
  BEGIN
    select valore
      into D_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ci := NULL;
  END;
  BEGIN
    select valore
      into D_tratt_prev
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TRATT_PREV'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_tratt_prev := '%';
  END;
  BEGIN
    select to_char(to_date(valore,'dd/mm/yyyy'),'dd-mon-yy')
      into D_data_inizio
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DATA_INIZIO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_data_inizio := NULL;
  END;
  BEGIN
    select valore
      into D_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_anno := NULL;
  END;
  BEGIN
    select valore
      into D_cod_mensilita
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MENSILITA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_cod_mensilita := NULL;
  END;
   BEGIN -- controllo congruenza parametri
        select 'x'
          into D_dummy
          from dual
         where D_ci is not null
            or D_tratt_prev is not null
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  d_dummy := null;
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P05715',null);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
   END;   -- controllo congruenza parametri

   BEGIN -- controllo mensilita' indicata
        select mens.mese, mens.mensilita
          into D_mese, D_mensilita
          from RIFERIMENTO_RETRIBUZIONE rire
             , MENSILITA mens
         where rire.anno     <= D_anno
           and mens.codice = D_cod_mensilita
           and mens.tipo = 'N'
           and (  rire.anno  > D_anno 
               or rire.mese <= mens.mese)
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  d_mese := null;
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P05831',': '||D_cod_mensilita);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
   END;   -- controllo mensilita' indicata

BEGIN     -- conguaglio
  FOR CURCI IN
    ( select ragi.ci ci
        from movimenti_contabili moco
           , voci_economiche voec
           , rapporti_giuridici ragi
           , figure_giuridiche figi
       where ragi.ci = moco.ci
         and voec.codice = moco.voce
         and ragi.figura = figi.numero
         and moco.ci = nvl(D_ci,moco.ci)
/* modifica del 15/03/2007 */
         and nvl(f_trattamento (ragi.ci, figi.profilo, ragi.posizione),' ') like D_tratt_prev
--           = nvl(D_tratt_prev, nvl(f_trattamento (ragi.ci, figi.profilo, ragi.posizione),' '))
/* fine modifica del 15/03/2007 */
         and nvl(ragi.al,nvl(figi.al,to_date('3333333','j'))) between
             nvl(figi.dal,to_date('2222222','j')) and nvl(figi.al,to_date('3333333','j'))
         and nvl(figi.al,to_date('3333333','j')) =
             (select max(nvl(figi2.al,to_date('3333333','j')))
                from figure_giuridiche figi2
                   , rapporti_giuridici ragi2
               where ragi2.ci = ragi.ci
                 and ragi2.figura = figi2.numero
                 and nvl(ragi2.al,nvl(figi2.al,to_date('3333333','j'))) between
                     nvl(figi2.dal,to_date('2222222','j')) and nvl(figi2.al,to_date('3333333','j')))
         and moco.anno >= 2005
         and moco.riferimento >= D_data_inizio
         and ( moco.anno  < D_anno
            or moco.anno  = D_anno and moco.mese < D_mese
            or moco.anno  = D_anno and moco.mese = D_mese and moco.mensilita < D_mensilita
              )
         and to_number(to_char(riferimento,'yyyy')) >= 2005
         and voec.specifica = 'ONAOSI'
    group by ragi.ci
    )
  LOOP

   BEGIN  -- elimina eventuali voci caricate con precedente conguaglio:
   delete from movimenti_contabili
    where ci = CURCI.ci
      and anno = D_anno
      and mese = D_mese
      and mensilita = D_mensilita
      and voce in (select codice from voci_economiche where specifica = 'ONAOSI')
      and data is not null
   ;
   COMMIT;
   END;   -- elimina eventuali voci caricate con precedente conguaglio

   BEGIN  -- recupera la vecchia voce:
   insert into movimenti_contabili
             ( ci, anno, mese, mensilita, voce, sub
             , riferimento
             , arr, input, data, tar_var, qta_var, imp_var)
   select CURCI.ci, D_anno, D_mese, D_mensilita, moco.voce, moco.sub
        , max(least(nvl(ragi.al,moco.riferimento), moco.riferimento))
        , 'C', 'I', sysdate, sum(tar*decode(voec.tipo,'F',-1,1)), max(qta), sum(imp*decode(voec.tipo,'F',-1,1))
     from movimenti_contabili moco
        , voci_economiche voec
        , rapporti_giuridici ragi
    where moco.ci = CURCI.ci
      and ragi.ci = moco.ci
      and voec.codice = moco.voce
      and moco.anno >= 2005
      and moco.riferimento >= D_data_inizio
      and ( moco.anno  < D_anno
            or moco.anno  = D_anno and moco.mese < D_mese
            or moco.anno  = D_anno and moco.mese = D_mese and moco.mensilita < D_mensilita
          )
      and to_number(to_char(riferimento,'yyyy')) >= 2005
      and voec.specifica = 'ONAOSI'
 group by moco.voce,moco.sub,moco.riferimento
   ;
   END;   -- recupera la vecchia voce

   BEGIN  -- inserisce la nuova voce:
     FOR CURV IN
       ( select moco.voce voce, moco.sub sub
              , max(least(nvl(ragi.al,moco.riferimento),moco.riferimento)) riferimento
              , to_char( to_date('3112'||
                         to_number(to_char(max(least(nvl(ragi.al,moco.riferimento),moco.riferimento))
                       , 'yyyy')) -1,'ddmmyyyy')) riferimento_onaosi
           from movimenti_contabili moco
              , voci_economiche voec
              , rapporti_giuridici ragi
          where moco.ci = CURCI.ci
            and ragi.ci = moco.ci
            and voec.codice = moco.voce
            and moco.anno >= 2005
            and moco.riferimento >= D_data_inizio
            and ( moco.anno  < D_anno
                or moco.anno  = D_anno and moco.mese < D_mese
                or moco.anno  = D_anno and moco.mese = D_mese and moco.mensilita < D_mensilita
                )
            and to_number(to_char(riferimento,'yyyy')) >= 2005
            and voec.specifica = 'ONAOSI'
       group by moco.voce,moco.sub,moco.riferimento
       )
     LOOP
       peccmore_onaosi.cal_onaosi ( CURCI.ci, D_anno, curv.riferimento, curv.riferimento_onaosi
                                  , curv.voce, curv.sub, sysdate, D_imp
                                  , p_trc, p_prn, p_pas, p_prs, p_stp, p_tim);
       insert into movimenti_contabili
                 ( ci, anno, mese, mensilita, voce, sub
                 , riferimento
                 , arr, input, data, tar_var, qta_var, imp_var)
       values (CURCI.ci, D_anno, D_mese, D_mensilita, curv.voce, curv.sub
            ,  curv.riferimento
            , 'C', 'I', sysdate+1.15740741E-5, null, null, D_imp) -- aggiunge 1 secondo alla sysdate x PK PECAVARI
       ;
     END LOOP;    -- Voci Nuove
   END;  -- inserisce la nuova voce

   BEGIN  -- verifica conguaglio significativo
   select sum(imp_var)
     into d_imp_cong
     from movimenti_contabili
    where ci = CURCI.ci
      and anno = D_anno
      and mese = D_mese
      and mensilita = D_mensilita
      and voce in (select codice from voci_economiche where specifica = 'ONAOSI')
      and data is not null
   ;
     IF nvl(D_imp_cong,0) = 0 THEN
          ROLLBACK;
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
            D_riga := D_riga +1;
            INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                             ,errore,precisazione)
            VALUES (prenotazione,1,D_riga,'P06306',substr('CI: '||CURCI.ci||' '||D_errore,1,50));
            update a_prenotazioni set prossimo_passo  = 91
                                    , errore          = 'P05808'
             where no_prenotazione = prenotazione
            ;
            COMMIT;
     END IF;
   END;         -- verifica conguaglio significativo
   END LOOP;    -- CI
   EXCEPTION
       WHEN OTHERS THEN
          D_errore := SUBSTR(SQLERRM,1,200);
          ROLLBACK;
          select nvl(max(progressivo),0)
            into D_riga
            from a_segnalazioni_errore
           where no_prenotazione = prenotazione
             and passo           = passo
          ;
            D_riga := D_riga +1;
            INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                             ,errore,precisazione)
            VALUES (prenotazione,1,D_riga,'P00109',substr(D_errore,1,50));
            update a_prenotazioni set prossimo_passo  = 91
                                    , errore          = 'P05808'
             where no_prenotazione = prenotazione
            ;
            COMMIT;
   END; -- conguaglio
   COMMIT;

EXCEPTION
     WHEN uscita THEN
        NULL;
     WHEN OTHERS THEN
        RAISE;
END;  -- conguaglio individuale
END;
/