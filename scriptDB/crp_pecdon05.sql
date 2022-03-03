CREATE OR REPLACE PACKAGE Pecdon05 IS
/******************************************************************************
 NOME:          PECDON05
 DESCRIZIONE:   DUPLICA VOCI PER NUOVA ONAOSI 2005
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    14/10/2005 NN
 1.1  15/02/2006 NN     Passati anche voce e data al calcolo onaosi.
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY Pecdon05 IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.1 del 15/02/2006';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
  D_voce_modello       VARCHAR(10);
  D_voce_nuova         VARCHAR(10);
  D_titolo             VARCHAR(30);
  D_sequenza           NUMBER(4);
  D_errore             VARCHAR(200);
  D_dummy              VARCHAR(1);
  D_riga               NUMBER:=0;
  D_imp                NUMBER:=0;
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
 BEGIN -- duplica voci
  BEGIN
    select valore
      into D_voce_modello
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_VOCE_MODELLO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_voce_modello := NULL;
  END;
  BEGIN
    select valore
      into D_voce_nuova
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_VOCE_NUOVA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_voce_nuova := NULL;
  END;
  BEGIN
    select valore
      into D_titolo
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TITOLO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_titolo := NULL;
  END;
   BEGIN -- controllo voce modello
        select 'x'
          into D_dummy
          from VOCI_ECONOMICHE
         where codice = D_voce_modello
           and classe = 'C'
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  d_dummy := null;
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P07112',': '||D_voce_modello);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
   END;  -- controllo voce modello
   BEGIN -- controllo voce nuova
        select 'x'
          into D_dummy
          from VOCI_ECONOMICHE
         where codice = D_voce_nuova
        ;
        RAISE uscita;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  NULL;
             WHEN uscita THEN
        D_riga := D_riga + 1;
        INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                         ,errore,precisazione)
        VALUES (prenotazione,1,D_riga,'P07113',': '||D_voce_nuova);
        update a_prenotazioni set prossimo_passo  = 91
                                , errore          = 'P05808'
         where no_prenotazione = prenotazione
        ;
        COMMIT;
        RAISE;
   END;  -- controllo voce nuova
BEGIN    -- inserimento nuova voce
        select min(voec1.sequenza)
          into D_sequenza
          from VOCI_ECONOMICHE voec1
         where voec1.sequenza >= (select max(voec2.sequenza)
                                    from VOCI_ECONOMICHE voec2
                                   where voec2.codice = D_voce_modello)
           and not exists (select 'x'
                             from VOCI_ECONOMICHE voec3
                            where voec3.sequenza = voec1.sequenza+1
                          );

        insert into VOCI_ECONOMICHE 
                  ( codice, oggetto, oggetto_al1, oggetto_al2, sequenza, classe,
                    estrazione, specie, tipo, automatismo, specifica, numero, 
                    memorizza, mese, mensilita, note)
        select D_voce_nuova, nvl(D_titolo,oggetto), null, null, D_sequenza + 1, 'R',
               estrazione, NULL, tipo, null, 'ONAOSI', numero,
               memorizza, NULL, NULL, NULL
          from VOCI_ECONOMICHE
         where codice = D_voce_modello;

        insert into VOCI_CONTABILI
                  ( voce, sub, alias, alias_al1, alias_al2,
                    titolo,
                    titolo_al1, titolo_al2,
                    dal, al, note)
        select D_voce_nuova, '1', D_voce_nuova, null, null,
               decode(D_titolo,null,substr(titolo,1,26)||(D_sequenza + 1),D_titolo),
               null, null,
               null, null, null
          from VOCI_CONTABILI
         where voce = D_voce_modello
           and sub = (select max(sub) from voci_contabili where voce = D_voce_modello);

        insert into CONTABILITA_VOCE
                  ( voce, sub, dal, al, descrizione, descrizione_al1, descrizione_al2,
                    des_abb, des_abb_al1, des_abb_al2, note, fiscale, somme, rapporto,
                    stampa_tar, stampa_qta, stampa_imp, starie_tar, starie_qta, starie_imp,
                    bilancio, budget, sede_del, anno_del, numero_del,
                    capitolo, articolo, conto, istituto, stampa_fr)
        select D_voce_nuova, '1', dal, al, nvl(D_titolo,descrizione), null, null,
               des_abb, null, null, note, fiscale, somme, null,
               stampa_tar, stampa_qta, stampa_imp, starie_tar, starie_qta, starie_imp,
               bilancio, budget, sede_del, anno_del, numero_del,
               capitolo, articolo, conto, istituto, stampa_fr
          from CONTABILITA_VOCE
         where voce = D_voce_modello
           and sub = (select max(sub) from contabilita_voce where voce = D_voce_modello);

        insert into TOTALIZZAZIONI_VOCE
                  ( voce, voce_acc, dal, al,
                    sub, anno, tipo, per_tot)
        select distinct D_voce_nuova, voce_acc, dal, al,
               sub, anno, tipo, per_tot
          from TOTALIZZAZIONI_VOCE
         where voce = D_voce_modello;

        insert into ESTRAZIONI_VOCE
                  ( voce, sub, gestione, contratto,
                    condizione, trattamento, sequenza, richiesta)
        select D_voce_nuova, '1', gestione, contratto,
               condizione, trattamento, rownum, richiesta
          from (select distinct  gestione, contratto,
                                 condizione, trattamento, richiesta
                  from ESTRAZIONI_VOCE
                 where voce = D_voce_modello);

        insert into RITENUTE_VOCE
                  ( voce, sub, dal, al,
                    note,
                    val_voce_ipn, cod_voce_ipn, sub_voce_ipn,
                    per_rit_ac, per_rit_ap)
        select D_voce_nuova, '1', to_date('01012005','ddmmyyyy'), null,
               '*** DATI FITTIZI PER NUOVO CALCOLO ONAOSI 2005!!  NON CANCELLARE!  NON MODIFICARE! ***',
               'P', max(codice), '*',
               1, 1
          from (select distinct  codice
                  from VOCI_ECONOMICHE
                 where classe = 'I');

   BEGIN  -- recupera la vecchia voce:
   insert into movimenti_contabili
             ( ci, anno, mese, mensilita, voce, sub
             , riferimento
             , arr, input, data, tar_var, qta_var, imp_var)
   select moco.ci, max(rire.anno), max(rire.mese), max(rire.mensilita), moco.voce, moco.sub
        , max(least(nvl(ragi.al,moco.riferimento), moco.riferimento))
        , 'C', 'I', sysdate, sum(tar*decode(voec.tipo,'F',-1,1)), max(qta), sum(imp*decode(voec.tipo,'F',-1,1))
     from movimenti_contabili moco
        , riferimento_retribuzione rire
        , voci_economiche voec
        , rapporti_giuridici ragi
    where ragi.ci = moco.ci
      and voec.codice = moco.voce
      and moco.anno >= 2005
      and ( moco.anno < rire.anno
         or moco.anno = rire.anno and moco.mese < rire.mese
          )
      and to_number(to_char(riferimento,'yyyy')) >= 2005
      and moco.voce = D_voce_modello
    group by moco.ci,moco.voce,moco.sub,moco.riferimento
   ;
   END;  -- recupera la vecchia voce

   BEGIN  -- inserisce la nuova voce:
     FOR CURV IN
       ( select moco.ci, max(rire.anno) anno, max(rire.mese) mese, max(rire.mensilita) mensilita, D_voce_nuova, '1'
              , max(least(nvl(ragi.al,moco.riferimento),moco.riferimento)) riferimento
              , to_char( to_date('3112'||
                         to_number(to_char(max(least(nvl(ragi.al,moco.riferimento),moco.riferimento))
                       , 'yyyy')) -1,'ddmmyyyy')) riferimento_onaosi
           from movimenti_contabili moco
              , riferimento_retribuzione rire
              , rapporti_giuridici ragi
          where ragi.ci = moco.ci
            and moco.anno >= 2005
            and (  moco.anno < rire.anno
                or moco.anno = rire.anno and moco.mese < rire.mese
                )
            and to_number(to_char(riferimento,'yyyy')) >= 2005
            and moco.voce = D_voce_modello
       group by moco.ci,moco.voce,moco.sub,moco.riferimento
       )
     LOOP
       peccmore_onaosi.cal_onaosi ( curv.ci, curv.anno, curv.riferimento, curv.riferimento_onaosi
                                  , D_voce_nuova, '1', sysdate, D_imp
                                  , p_trc, p_prn, p_pas, p_prs, p_stp, p_tim);
       insert into movimenti_contabili
                 ( ci, anno, mese, mensilita, voce, sub
                 , riferimento
                 , arr, input, data, tar_var, qta_var, imp_var)
       values (curv.ci, curv.anno, curv.mese, curv.mensilita, D_voce_nuova, '1'
            ,  curv.riferimento
            , 'C', 'I', sysdate+1.15740741E-5, null, null, D_imp)
       ;
     END LOOP;
   END;  -- inserisce la nuova voce
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
            VALUES (prenotazione,1,D_riga,'P00109',substr('VOCE MODELLO: '||D_voce_modello||' '||D_errore,1,50));
            update a_prenotazioni set prossimo_passo  = 91
                                    , errore          = 'P05808'
             where no_prenotazione = prenotazione
            ;
            COMMIT;
   END; -- inserimento nuova voce
   COMMIT;

EXCEPTION
     WHEN uscita THEN
        NULL;
     WHEN OTHERS THEN
        RAISE;
END;  -- duplica voce
END;
/