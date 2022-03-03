CREATE OR REPLACE PACKAGE Pecdonao IS
/******************************************************************************
 NOME:          PECdonao   
 DESCRIZIONE:   DUPLICA VOCI PER NUOVA ONAOSI 2003-2004
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    13/04/2004 AM
 2    14/07/2004 AM     Correzioni varie da DB problemi
 2.1  03/06/2004 AM     Correzione 'not a group by expression'
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY Pecdonao IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V2.1 del 03/08/2004';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
  D_voce_modello       VARCHAR(10);
  D_voce_nuova         VARCHAR(10);
  D_titolo             VARCHAR(30);
  D_sequenza           NUMBER(4);
  D_errore             VARCHAR(200);
  D_dummy              VARCHAR(1);
  D_riga               NUMBER:=0;
  uscita               exception;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
 BEGIN -- duplica voci
  BEGIN
    SELECT valore
      INTO D_voce_modello
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_VOCE_MODELLO'
    ;
-- dbms_output.put_Line('voce modello '||D_voce_modello);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_voce_modello := NULL;
  END;
  BEGIN
    SELECT valore
      INTO D_voce_nuova
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_VOCE_NUOVA'
    ;
-- dbms_output.put_Line('voce nuova '||D_voce_nuova);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_voce_nuova := NULL;
  END;
  BEGIN
    SELECT valore
      INTO D_titolo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TITOLO'
    ;
-- dbms_output.put_Line('titolo '||D_titolo);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_titolo := NULL;
  END;
   BEGIN -- controllo voce modello
        select 'x'
          into D_dummy
          from VOCI_ECONOMICHE
         where codice = D_voce_modello
           and classe = 'R'
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
   BEGIN -- inserimento nuova voce
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
-- dbms_output.put_Line('seq. '||D_sequenza);

        insert into VOCI_ECONOMICHE 
                  ( codice, oggetto, oggetto_al1, oggetto_al2, sequenza, classe,
                    estrazione, specie, tipo, automatismo, specifica, numero, 
                    memorizza, mese, mensilita, note)
        select D_voce_nuova, nvl(D_titolo,oggetto), null, null, D_sequenza + 1, 'C',
               estrazione, NULL, tipo, null, null, numero,
               memorizza, NULL, NULL, NULL
          from VOCI_ECONOMICHE
         where codice = D_voce_modello;
-- dbms_output.put_Line('Ho inserito VOEC');

        insert into VOCI_CONTABILI
                  ( voce, sub, alias, alias_al1, alias_al2,
                    titolo,
                    titolo_al1, titolo_al2,
                    dal, al, note)
        select D_voce_nuova, '*', D_voce_nuova, null, null,
               decode(D_titolo,null,substr(titolo,1,26)||(D_sequenza + 1),D_titolo),
               null, null,
               null, null, null
          from VOCI_CONTABILI
         where voce = D_voce_modello
           and sub = (select max(sub) from voci_contabili where voce = D_voce_modello);
-- dbms_output.put_Line('Ho inserito VOCO');

        insert into CONTABILITA_VOCE
                  ( voce, sub, dal, al, descrizione, descrizione_al1, descrizione_al2,
                    des_abb, des_abb_al1, des_abb_al2, note, fiscale, somme, rapporto,
                    stampa_tar, stampa_qta, stampa_imp, starie_tar, starie_qta, starie_imp,
                    bilancio, budget, sede_del, anno_del, numero_del,
                    capitolo, articolo, conto, istituto, stampa_fr)
        select D_voce_nuova, '*', dal, al, nvl(D_titolo,descrizione), null, null,
               des_abb, null, null, note, fiscale, somme, null,
               stampa_tar, stampa_qta, stampa_imp, starie_tar, starie_qta, starie_imp,
               bilancio, budget, sede_del, anno_del, numero_del,
               capitolo, articolo, conto, istituto, stampa_fr
          from CONTABILITA_VOCE
         where voce = D_voce_modello
           and sub = (select max(sub) from contabilita_voce where voce = D_voce_modello);
-- dbms_output.put_Line('Ho inserito COVO');

        insert into TOTALIZZAZIONI_VOCE
                  ( voce, voce_acc, dal, al,
                    sub, anno, tipo, per_tot)
        select distinct D_voce_nuova, voce_acc, dal, al,
               sub, anno, tipo, per_tot
          from TOTALIZZAZIONI_VOCE
         where voce = D_voce_modello;
-- dbms_output.put_Line('Ho inserito TOVO');

        insert into TARIFFE_VOCE
                  ( voce, dal, al, 
                    tipo_moltiplica,moltiplica,
                    tipo_divide,divide,
                    decimali, arrotonda, 
                    val_voce_qta, cod_voce_qta, sub_voce_qta, quantita,
                    tipo_moltiplica_qta, moltiplica_qta,
                    tipo_divide_qta, divide_qta, decimali_qta)
        select D_voce_nuova, to_date('01082003','ddmmyyyy'), null,
               'VL', null,
               'VL', null,
               null, null,
               'V', null, null, null,
               'VL', null,
               'VL', null, null
          from dual;
-- dbms_output.put_Line('Ho inserito TAVO');

        insert into ESTRAZIONI_VOCE
                  ( voce, sub, gestione, contratto,
                    condizione, trattamento, sequenza, richiesta)
        select D_voce_nuova, '*', gestione, contratto,
               condizione, trattamento, rownum, richiesta
          from (select distinct  gestione, contratto,
                                 condizione, trattamento, richiesta
                  from ESTRAZIONI_VOCE
                 where voce = D_voce_modello);
/* vecchia versione:
        select distinct D_voce_nuova, '*', gestione, contratto,
               condizione, trattamento, sequenza, richiesta
          from ESTRAZIONI_VOCE
         where voce = D_voce_modello;
*/
-- dbms_output.put_Line('Ho inserito ESVO');

-- recupera la vecchia voce:
begin
insert into movimenti_contabili
(ci,anno,mese,mensilita,voce,sub,riferimento,arr,input,data,tar_var,qta_var,imp_var)
select moco.ci,max(rire.anno),max(rire.mese),max(rire.mensilita),moco.voce,moco.sub,
max(least(nvl(ragi.al,moco.riferimento),moco.riferimento)),
'C','I',sysdate,sum(tar*decode(voec.tipo,'F',-1,1)),max(qta),sum(imp*decode(voec.tipo,'F',-1,1))
from movimenti_contabili moco
   , riferimento_retribuzione rire
   , voci_economiche voec
   , rapporti_giuridici ragi
where ragi.ci = moco.ci
  and voec.codice = moco.voce
  and ( moco.anno = 2003 and moco.mese > 7
     or moco.anno = 2004
      )
  and ( moco.anno != rire.anno
     or moco.anno  = rire.anno and moco.mese != rire.mese
      )
and moco.riferimento > to_date('31072003','ddmmyyyy')
and moco.voce = D_voce_modello
group by moco.ci,moco.voce,moco.sub,moco.riferimento
;
end;
begin
for cursore in
(select D_voce_nuova voce
      , 0 da
      , 32 a
      , 3 valore
   from dual
 union
 select D_voce_nuova voce
      , 33 da
      , 67 a
      , 12 valore
   from dual
 union
 select D_voce_nuova voce
      , 68 da
      , 99 a
      , 1.5 valore
   from dual
)
loop
-- inserisce la nuova voce per i vecchi periodi di PERE
begin
insert into movimenti_contabili
(ci,anno,mese,mensilita,voce,sub,riferimento,arr,input,data,tar_var,qta_var,imp_var)
select pere.ci,max(rire.anno),max(rire.mese),max(rire.mensilita),
cursore.voce,'*',max(least(nvl(ragi.al,pere.al),pere.al)),
'C','I',sysdate,cursore.valore,1,cursore.valore
from periodi_retributivi pere
   , riferimento_retribuzione rire
   , rapporti_giuridici ragi
where ragi.ci = pere.ci
and ( pere.anno = 2003 and pere.mese > 7
     or pere.anno = 2004
      )
and pere.periodo != rire.fin_ela
and pere.al > to_date('31072003','ddmmyyyy')
and exists (select 'x' from estrazioni_voce
             where voce = cursore.voce
               and trattamento = pere.trattamento)
and exists (select 'x'
              from rapporti_individuali
             where ci = pere.ci
               and trunc(months_between( to_date('3112'||(to_char(pere.al,'yyyy')-1),'ddmmyyyy')
                                       , data_nas) / 12) between cursore.da and cursore.a
           )
group by pere.ci,to_char(pere.al,'yyyymm')
having sum(gg_con) > 0
;
end;
-- inserimento ritenuta per il mese corrente; commentato perchè viene già inserita dai cacoli automatici
/* 
begin
insert into movimenti_contabili
(ci,anno,mese,mensilita,voce,sub,riferimento,arr,input,data,tar_var,qta_var,imp_var)
select pegi.ci,max(rire.anno),max(rire.mese),max(rire.mensilita),
cursore.voce,'*',max(least(nvl(pegi.al,rire.fin_ela),rire.fin_ela)),
'C','I',sysdate,cursore.valore,1,cursore.valore
from periodi_giuridici pegi
   , riferimento_retribuzione rire
where pegi.dal <= rire.fin_ela
  and nvl(pegi.al,to_date('3333333','j')) >= rire.ini_ela
  and pegi.rilevanza = 'S'
and exists (select 'x' from estrazioni_voce
             where voce = cursore.voce
               and trattamento in (select trattamento from periodi_retributivi
                                    where ci = pegi.ci and anno = 2004)
           )
and exists (select 'x'
              from rapporti_individuali
             where ci = pegi.ci
               and trunc(months_between( to_date('31122003','ddmmyyyy')
                                       , data_nas) / 12) between cursore.da and cursore.a
           )
group by pegi.ci
;
end;
*/
end loop;
end;

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



