CREATE OR REPLACE PACKAGE PECCBARP IS
/******************************************************************************
 NOME:        PECCABARP
 DESCRIZIONE: Caricamento delle tabelle utilizzate nel calcolo della elaborazione
              di previsione.
              Caricamento delle tabelle BASI_VOCE_BP, VALORI_BASE_VOCE_BP,
              VALORI_PROGRESSIONE_VOCE_BP, INFORMAZIONI_RETRIBUTIVE_BP .
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003         
 1.1  23/11/2004 MS     Modifica per attivita 8453    
 1.2  16/06/2006 MS     Modifica gestione delle insert (att. 16698 )
 1.3  06/08/2007 MS     Introduzione duplica assegni familiari ( att. 2239 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN  (PRENOTAZIONE IN NUMBER,passo in number);
end;
/
CREATE OR REPLACE PACKAGE BODY PECCBARP IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.3 del 06/08/2007';
END VERSIONE;
procedure main (prenotazione in number,passo in number) is
begin
DECLARE
  dep_elaborazione   VARCHAR2(1);
  dep_ci             number;
  p_ini_ela          date;
  p_fin_ela          date;
  P_anno             number(4);
  P_mese             number(2);
  p_mensilita        varchar2(4);
BEGIN
  BEGIN
  select valore          D_elaborazione
    into dep_elaborazione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ELABORAZIONE'
   ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN dep_elaborazione := 'X';
  END;
  BEGIN
  select valore        D_ci
    into dep_ci
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CI'
   ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN dep_ci := 0;
  END;
  BEGIN
   select anno
        , mese
        , mensilita
        , ini_ela
        , to_date('3112'||to_char(fin_ela,'yyyy'),'ddmmyyyy')
    into P_anno, P_mese, p_mensilita, p_ini_ela, p_fin_ela
    from riferimento_retribuzione
   where rire_id = 'RIRE'
     and mensilita in (select mensilita
                         from mensilita
                        where tipo = 'B'
                      );
   IF ( dep_elaborazione in ('T','B','C','A') and nvl(dep_ci,0)  != 0 
      or dep_elaborazione = 'I' and nvl(dep_ci,0)  = 0 
      or dep_elaborazione = 'X' ) 
   THEN
      BEGIN
      update a_prenotazioni
      set errore = 'P05190',
          prossimo_passo = 91
      where no_prenotazione = prenotazione
      ;
      commit;
      END;
   ELSE
      BEGIN
      IF dep_elaborazione in ('T','B') 
-- Tratto le voci di base e a progressione
      THEN
       delete from basi_voce_bp;
       INSERT INTO BASI_VOCE_BP 
       ( VOCE, CLASSE, CONTRATTO, DAL, AL, NOTE
       , FLAG_INQV, VOCE_BASE, VOCE_ECCE, BENEFICIO_ANZIANITA, MM_INIZIO, MM_PERIODO
       , MAX_PERCENTUALE, MAX_PERIODI, MIN_PERIODI, GG_PERIODO, MOLTIPLICA, DIVIDE, DECIMALI) 
       select VOCE, CLASSE, CONTRATTO, DAL, AL, NOTE
            , FLAG_INQV, VOCE_BASE, VOCE_ECCE, BENEFICIO_ANZIANITA, MM_INIZIO, MM_PERIODO
            , MAX_PERCENTUALE, MAX_PERIODI, MIN_PERIODI, GG_PERIODO, MOLTIPLICA, DIVIDE, DECIMALI
         from basi_voce;

       delete from valori_base_voce_bp;
       INSERT INTO VALORI_BASE_VOCE_BP 
       ( VOCE, CONTRATTO, DAL, AL, GESTIONE, RUOLO
       , LIVELLO, QUALIFICA, TIPO_RAPPORTO, VALORE ) 
       select VOCE, CONTRATTO, DAL, AL, GESTIONE, RUOLO
            , LIVELLO, QUALIFICA, TIPO_RAPPORTO, VALORE
         from valori_base_voce;

       delete from valori_progressione_voce_bp;
       INSERT INTO VALORI_PROGRESSIONE_VOCE_BP 
       ( VOCE, CONTRATTO, DAL, AL, LIVELLO, TIPO_RAPPORTO
       , PERIODO, PER_PRO, IMP_FIS )
       select VOCE, CONTRATTO, DAL, AL, LIVELLO, TIPO_RAPPORTO
            , PERIODO, PER_PRO, IMP_FIS 
         from valori_progressione_voce;
      END IF; 

      IF dep_elaborazione in ('T','C') THEN
-- Tratto le voci di base e individuali e le rate per tutti
       delete from informazioni_retributive_bp
        where voce not in ( select codice 
                              from voci_economiche
                             where automatismo = 'ASS_FAM'
                          )
       ;
       INSERT INTO INFORMAZIONI_RETRIBUTIVE_BP 
       ( CI, VOCE, SUB,  SEQUENZA_VOCE, TARIFFA, DAL,  AL, TIPO
       , QUALIFICA, TIPO_RAPPORTO, SOSPENSIONE, IMP_TOT,  RATE_TOT, NOTE, ISTITUTO,  NUMERO, DATA
       , UTENTE, DATA_AGG) 
       select CI, VOCE, SUB,  SEQUENZA_VOCE, TARIFFA, DAL,  AL, TIPO
            , QUALIFICA, TIPO_RAPPORTO, SOSPENSIONE, IMP_TOT,  RATE_TOT, NOTE, ISTITUTO,  NUMERO, DATA
            , UTENTE, DATA_AGG
         from informazioni_retributive
        where tipo != 'I'
          and voce not in ( select codice 
                              from voci_economiche
                             where automatismo = 'ASS_FAM'
                          )
;
-- dbms_output.put_line('inserito non I');
-- dbms_output.put_line(to_char(p_ini_ela)||to_char(p_fin_ela));
-- Tratto le voci di tipo I 
         insert into informazioni_retributive_bp 
        (ci, voce, sub, sequenza_voce,tariffa,dal, al,tipo,qualifica,tipo_rapporto
        ,sospensione, imp_tot,rate_tot,note,istituto,numero,data, utente,data_agg)                       
         select ci, voce, sub, sequenza_voce,tariffa
              , greatest(nvl(dal,p_ini_ela), p_ini_ela), least(nvl(al,to_date('3333333','j')), p_fin_ela)
              , tipo,qualifica,tipo_rapporto,sospensione, imp_tot,rate_tot,note,istituto,numero,data, utente,data_agg
           from informazioni_retributive
          where ( dal between p_ini_ela and p_fin_ela
              or al between p_ini_ela and p_fin_ela
              or dal is null and al >= p_ini_ela
              or al is null and dal <= p_ini_ela
              or dal is null and al is null
               )
            and tipo = 'I'
            and voce not in ( select codice 
                                  from voci_economiche
                                 where automatismo = 'ASS_FAM'
                              )
            ;
-- dbms_output.put_line('inserito I');
      END IF;

      IF dep_elaborazione in ( 'A', 'T', 'I' ) THEN
-- Trattamento degli assegni familiari 
        BEGIN
          FOR CUR_CI in 
            ( select distinct moco.ci, moco.voce, moco.sub , voec.sequenza
                from movimenti_contabili moco
                   , voci_economiche voec
               where moco.anno = decode(P_mese, 1, P_anno-1, P_anno )
                 and moco.voce = voec.codice 
                 and voec.automatismo = 'ASS_FAM'
                 and moco.mensilita != '*AP'
                 and ( dep_elaborazione in ( 'A','T' )
                    or dep_elaborazione = 'I' and moco.ci = dep_ci
                     )
             ) 
          LOOP
             BEGIN
               delete from informazioni_retributive_bp
                where ci = CUR_CI.ci
                  and voce = CUR_CI.voce
                  and sub = CUR_CI.sub
                 ;
              insert into informazioni_retributive_bp 
              ( ci, voce, sub, sequenza_voce
              , tariffa
              , dal, al
              , tipo, utente, data_agg )
              select CUR_CI.ci, CUR_CI.voce, CUR_CI.sub, CUR_CI.sequenza
                   , sum(moco.imp)
                   , p_ini_ela, p_fin_ela
                   , 'I', 'GP4', sysdate
              from movimenti_contabili moco
             where anno = decode(P_mese, 1, P_anno-1, P_anno )
               and ci = CUR_CI.ci
               and voce = CUR_CI.voce
               and sub = CUR_CI.sub
               and mensilita != '*AP'
               and to_char(moco.riferimento,'mm') = moco.mese
               and mese in ( select max(mese)
                               from movimenti_contabili moco
                              where anno = decode(P_mese, 1, P_anno-1, P_anno )
                                and ci = CUR_CI.ci
                                and voce = CUR_CI.voce
                                and sub = CUR_CI.sub
                                and mensilita != '*AP'
                                and nvl(imp,0) != 0
                           );
          commit;
          END;
          END LOOP;
        END;
      END IF;
      IF dep_elaborazione = 'I' THEN
-- Tratto le voci di base individuali e le rate per il CI
         delete from informazioni_retributive_bp
          where ci = dep_ci
          and voce not in ( select codice 
                              from voci_economiche
                             where automatismo = 'ASS_FAM'
                          )
         ;
-- dbms_output.put_line('cancellato il dipendendente');
         INSERT INTO INFORMAZIONI_RETRIBUTIVE_BP 
         ( CI, VOCE, SUB,  SEQUENZA_VOCE, TARIFFA, DAL,  AL, TIPO
         , QUALIFICA, TIPO_RAPPORTO, SOSPENSIONE, IMP_TOT,  RATE_TOT, NOTE, ISTITUTO,  NUMERO, DATA
         , UTENTE, DATA_AGG) 
         select CI, VOCE, SUB,  SEQUENZA_VOCE, TARIFFA, DAL,  AL, TIPO
              , QUALIFICA, TIPO_RAPPORTO, SOSPENSIONE, IMP_TOT,  RATE_TOT, NOTE, ISTITUTO,  NUMERO, DATA
              , UTENTE, DATA_AGG
           from informazioni_retributive
          where tipo != 'I'
            and ci = dep_ci
            and voce not in ( select codice 
                              from voci_economiche
                             where automatismo = 'ASS_FAM'
                          )
           ;
-- dbms_output.put_line('inserito non I del dipendendente');
-- Tratto le voci di tipo I 
          insert into informazioni_retributive_bp 
          (ci, voce, sub, sequenza_voce,tariffa,dal, al,tipo,qualifica,tipo_rapporto
          ,sospensione, imp_tot,rate_tot,note,istituto,numero,data, utente,data_agg)                       
          select ci, voce, sub, sequenza_voce,tariffa
               , greatest(nvl(dal,p_ini_ela), p_ini_ela), least(nvl(al, to_date('3333333','j')), p_fin_ela)
               , tipo,qualifica,tipo_rapporto,sospensione, imp_tot,rate_tot,note,istituto,numero,data, utente,data_agg
            from informazioni_retributive
          where ( dal between p_ini_ela and p_fin_ela
              or al between p_ini_ela and p_fin_ela
              or dal is null and al >= p_ini_ela
              or al is null and dal <= p_ini_ela
              or dal is null and al is null
               )
           and tipo = 'I'
           and ci = dep_ci
           and voce not in ( select codice 
                               from voci_economiche
                              where automatismo = 'ASS_FAM'
                          );
-- dbms_output.put_line('inserito I del dipendendente');
      END IF;
      END;
   END IF;
  EXCEPTION
-- non trovata mensilita
   WHEN NO_DATA_FOUND then null;
  END;
END;
end;
end;
/
