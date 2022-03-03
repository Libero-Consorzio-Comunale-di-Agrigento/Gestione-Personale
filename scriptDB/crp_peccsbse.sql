CREATE OR REPLACE PACKAGE PECCSBSE IS
/******************************************************************************
 NOME:        PECCSMVB - CREAZIONE SUPPORTO MAGNETICO VERSAMENTI BANCA
 DESCRIZIONE: Gestione delle segnalazioni di errore

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    02/07/2003 MS     Prima emissione
 1.1  21/09/2004 MS     Modidica per attivita 7446
 1.2  01/12/2004 MS     Modifica per attivita 8518
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCSBSE IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 01/12/2004';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS

BEGIN
DECLARE
  P_anno         number;
  P_mese         number;
  P_mensilita    varchar2(4);
  P_prog         number;
  P_fascia       varchar2(2);
  P_IBAN         varchar2(1);

BEGIN
  BEGIN  
    select to_number(substr(valore,1,4)) 
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN  
    select substr(valore,1,4)
      into P_mensilita
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MENSILITA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select nvl(P_anno,rire.anno) 
         , mens.mese           
         , nvl(P_mensilita,mens.mensilita)   
      into P_anno,P_mese,P_mensilita
      from riferimento_retribuzione rire
         , mensilita                mens
     where rire.rire_id    = 'RIRE'
       and (   mens.codice  = P_mensilita
	      or mens.mensilita = rire.mensilita and 
	         mens.mese      = rire.mese      and 
               P_mensilita is null
           )       
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN  
    select substr(valore,1,2)
      into P_fascia
        from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FASCIA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
            P_fascia := '%';
  END;
  BEGIN  
    select valore
      into P_IBAN
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_IBAN'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_IBAN := null;
  END;

-- Controllo sui Codici Nazione per IBAN
BEGIN
P_prog := 1;
   IF P_IBAN = 'X' THEN
    BEGIN -- Controllo coordinate delle tesorerie
    FOR CUR_SIA IN (
        select nvl(iscr.codice_abi,'0')                 abi
             , nvl(spor2.cab,'0')                       cab
             , nvl(substr(spor1.descrizione,13,2),'IT') cod_naz_sia
          from istituti_credito iscr
             , sportelli spor1
             , sportelli spor2
        where spor1.istituto  = '*'
          and substr(spor1.sportello,1,1) = '*'
          and iscr.codice     = spor1.cab
          and spor2.istituto  = spor1.cab
          and spor2.sportello = spor1.dipendenza
    group by  nvl(iscr.codice_abi,'0')
            , nvl(spor2.cab,'0')
            , nvl(substr(spor1.descrizione,13,2),'IT')
    ) LOOP
     BEGIN
       IF CUR_SIA.cod_naz_sia not in ('IT','SM') THEN
                 P_prog := P_prog + 1;
                 insert into a_segnalazioni_errore (NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
                 select prenotazione
                       , 1
                       , P_prog
                       , 'P05443'
                       , 'Tesoreria ('||CUR_SIA.abi||'-'||CUR_SIA.cab||') / Cod.Nazione: '||CUR_SIA.cod_naz_sia
                   from dual;
       END IF;
     END;
    END LOOP; -- fine loop cur_sia

    BEGIN -- Controllo coordinate sui dipendenti
       FOR CUR_DIP IN (
            select rare.ci                     ci
                 , nvl(rare.cod_nazione,'IT')  cod_nazione
              from rapporti_retributivi rare
                 , movimenti_contabili moco
                 , rapporti_giuridici   ragi
                 , gestioni             gest
         where moco.anno      = P_anno
           and moco.mese      = P_mese
           and moco.mensilita = P_mensilita
           and moco.voce      =
              (select codice 
                 from voci_economiche 
                where automatismo = 'NETTO'
              )
           and sign(moco.imp) = 1
           and moco.ci        = rare.ci
           and moco.ci        = ragi.ci
	     and ragi.gestione  = gest.codice
           and gest.fascia    like P_fascia
         ) LOOP
            BEGIN
              IF CUR_DIP.cod_nazione not in ('IT','SM') THEN
                P_prog := P_prog + 1;
                insert into a_segnalazioni_errore (NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
                select prenotazione
                      , 1
                      , P_prog
                      , 'P05443'
                      , 'Cod.Ind. '||to_char(CUR_DIP.ci)||' Cod.Nazione: '||CUR_DIP.cod_nazione
                  from dual;
              END IF;
            END;
          END LOOP; -- cursore sui dipendenti
      END;
     END;
   END IF;

 BEGIN
 FOR CUR_NEG in ( select moco.ci ci
                       , moco.imp imp
                   from movimenti_contabili moco
                      , rapporti_giuridici   ragi
                      , gestioni             gest
                  where moco.anno      = P_anno
                    and moco.mese      = P_mese
                    and moco.mensilita = P_mensilita
                    and moco.voce      =
                       (select codice 
                          from voci_economiche 
                         where automatismo = 'NETTO')
                    and sign(moco.imp) = -1
                    and moco.ci        = ragi.ci
                    and ragi.gestione  = gest.codice
                    and gest.fascia    like P_fascia
                 ) LOOP
   BEGIN 
   P_prog := P_prog + 1;
     insert into a_segnalazioni_errore (NO_PRENOTAZIONE,PASSO,PROGRESSIVO,ERRORE,PRECISAZIONE)
     select prenotazione
          , 1
          , P_prog
          , 'P05830'
          , 'Cod.Ind. '||to_char(CUR_NEG.ci)||' netto: '||to_char(CUR_NEG.imp)
       from dual;
    commit;
   END;
  END LOOP;
 END;
 END;
 BEGIN
  update a_prenotazioni set prossimo_passo  = 91
                          , errore          = 'P05808'
  where no_prenotazione = prenotazione
    and exists
       (select 'x' from a_segnalazioni_errore
         where no_prenotazione = prenotazione
       )
  ;
  commit;
  END;
END;
END;
END;
/
