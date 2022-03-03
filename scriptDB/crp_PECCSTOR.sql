CREATE OR REPLACE PACKAGE PECCSTOR IS
/******************************************************************************
 NOME:        PECCSTOR - CALCOLO CONTRIBUTI STORICI
 DESCRIZIONE: Inserisce record *R* su moco per evitare l'esposizione dello "storno"
              in caso di passaggio del calcolo CP dal 8.55 - 9.55 a 8.55 + 1.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    31/03/2005 AM     Prima emissione
******************************************************************************/
FUNCTION  VERSIONE RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCSTOR IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1 del 31/03/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
BEGIN
DECLARE
  V_comando       varchar2(2000);
  D_errore        varchar2(6);
  V_conta         number := 0;
  D_nominativo    varchar2(100);
  V_controllo     varchar2(1) := null;
  P_voce1         varchar2(10);
  P_sub1          varchar2(4);
  P_voce2         varchar2(10);
  P_sub2          varchar2(4);
  P_dal           date;

  d_PER_RIT_AP1   number := 0;
  d_COD_VOCE_RID1 varchar2(10);
  d_SUB_VOCE_RID1 varchar2(2);
  D_tipo          varchar2(1);
  D_moltiplica    number := 0;
  D_riferimento   date;

  D_ipn_cum       number := 0;
  D_ipn_cum_ap    number := 0;
  D_ipn1          number := 0;
  D_rit1          number := 0;
  D_ipn_ap1       number := 0;
  D_rit_ap1       number := 0;
  D_ipn2          number := 0;
  D_rit2          number := 0;
  D_ipn_ap2       number := 0;
  D_rit_ap2       number := 0;

  D_tar           number := 0;
  d_rit           number := 0;
  D_tar_ap        number := 0;
  d_rit_ap        number := 0;

  D_imp_new       number := 0;
  D_imp_eap_new   number := 0;

  USCITA          EXCEPTION;
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    <<PARAMETRI>>
    select max(decode(parametro,'P_VOCE1',substr(valore,1,10),null))
         , max(decode(parametro,'P_SUB1',substr(valore,1,10),null))
         , max(decode(parametro,'P_VOCE2',substr(valore,1,10),null))
         , max(decode(parametro,'P_SUB2',substr(valore,1,10),null))
         , nvl( max(decode(parametro,'P_DAL',to_date(substr(valore,1,10),'dd/mm/yyyy'),null))
         , to_date('01011940','ddmmyyyy'))
      into P_voce1
         , P_sub1
         , P_voce2
         , P_sub2
         , P_dal
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro in ( 'P_VOCE1', 'P_SUB1'
                        , 'P_VOCE2', 'P_SUB2'
                        , 'P_DAL'
                        )
      ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     P_voce1 := null;
     P_sub1 := null;
     P_voce2 := null;
     P_sub2 := null;
     P_dal  := to_date('01011940','ddmmyyyy');
  END PARAMETRI;
-- controllo sui parametri
   BEGIN
   select 'Y' , tipo, decode(tipo,'T',-1,1)
     into V_controllo, D_tipo, D_moltiplica
     from voci_economiche
    where codice = P_voce1
      and exists ( select 'x' 
                     from contabilita_voce
                    where voce = P_voce1 and sub = P_sub1
                 );
   EXCEPTION WHEN NO_DATA_FOUND THEN 
         V_controllo := 'X';
   END;
   IF v_controllo = 'Y' THEN
   BEGIN
   select 'Y' 
     into V_controllo
     from dual
    where exists ( select 'x' 
                     from contabilita_voce
                    where voce =  P_voce2 and sub = P_sub2
                 );
   EXCEPTION WHEN NO_DATA_FOUND THEN 
         V_controllo := 'X';
   END;
   END IF;
   IF v_controllo = 'Y' THEN
   BEGIN
   -- riga 0
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 1, 0,
                  rpad('Voce',33,' ')||' '||
                  '  '||
                  rpad('Dal',10,' ')||' '||
                  rpad('Al',10,' ')||' '||
                  rpad('Su Imp.',9,' ')||' '||
                  lpad('a partire Da',9,' ')||' '||
                  lpad('Fino a',15,' ')||' '||
                  lpad('% AC',7,' ')||' '||
                  lpad('%AP',7,' ')||' '||
                  rpad('Ridotta di',15,' ')	            );
   -- riga 1
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 1, 1, lpad('_',120,'_'));
   -- riga 2
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 1, 2, null );
     v_conta := 2;
     for cur_stampa_diz in 
          (select rpad(covo.descrizione||' '||covo.voce||'/'||covo.sub,33,' ')||' '||
                  voec.tipo||' '||
                  to_char(nvl(rivo.dal,to_date('01011940','ddmmyyyy')),'dd/mm/yyyy')||' '||
                  nvl(to_char(rivo.al,'dd/mm/yyyy'),'          ')||' '||
                  rpad(nvl(rivo.VAL_VOCE_IPN||'-'||rivo.COD_VOCE_IPN||'/'||rivo.SUB_VOCE_IPN,' ')
                      ,15,' ')||' '||
                  lpad(nvl(to_char(rivo.LIM_INF),' '),9,' ')||' '||
                  lpad(nvl(to_char(rivo.LIM_SUP),' '),9,' ')||' '||
                  lpad(nvl(to_char(rivo.PER_RIT_AC),' '),7,' ')||' '||
                  lpad(nvl(to_char(rivo.PER_RIT_AP),' '),7,' ')||' '||
                  rpad(nvl(rivo.VAL_VOCE_RID||'-'||rivo.COD_VOCE_RID||'/'||rivo.SUB_VOCE_RID,' ')
                      ,15,' ') stampa
             from contabilita_voce covo
                , voci_economiche voec
                , ritenute_voce rivo
            where voec.codice = covo.voce
              and covo.voce = rivo.voce
              and rivo.sub = covo.sub
              and covo.voce in (P_voce1,P_voce2)
              and covo.sub in (P_sub1,P_sub2)
              and rivo.dal >= P_dal
            order by rivo.dal,rivo.voce,rivo.sub
           ) Loop
           v_conta := v_conta +1;
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
           values (prenotazione, 1, 1, v_conta, cur_stampa_diz.stampa)
           ;
         end loop;  -- cursore cur_stampa_diz
         commit;
   END;
   BEGIN
   select 'X' 
     into v_controllo
     from voci_economiche
    where codice = P_voce2
      and (   tipo != D_tipo
           or exists (select 'x' from ritenute_voce rivo1
                       where voce = P_voce1 and sub = P_sub1
                         and dal >= P_dal
                         and not exists (select 'x' from ritenute_voce 
                                          where voce = P_voce2 and sub = P_sub2
                                            and dal = rivo1.dal 
                                            and COD_VOCE_IPN = rivo1.cod_voce_ipn
                                            and SUB_VOCE_IPN = rivo1.sub_voce_Ipn)
                     )
           or exists (select 'x' from ritenute_voce rivo1
                       where voce = P_voce2 and sub = P_sub2
                         and dal >= P_dal
                         and not exists (select 'x' from ritenute_voce 
                                          where voce = P_voce1 and sub = P_sub1
                                            and dal = rivo1.dal 
                                            and COD_VOCE_IPN = rivo1.cod_voce_ipn
                                            and SUB_VOCE_IPN = rivo1.sub_voce_Ipn)
                     )
           or exists (select 'x' from ritenute_voce 
                       where voce = P_voce1 and sub = P_sub1
                         and dal >= P_dal
                         and (   LIM_INF is not null 
                              or LIM_SUP is not null 
                              or nvl(per_rit_ap,0) = 0
                              or val_voce_ipn != 'C'
                             )
                     )
           or exists (select 'x' from ritenute_voce 
                       where voce = P_voce2 and sub = P_sub2
                         and dal >= P_dal
                         and (   LIM_INF is null 
                              or LIM_SUP is not null 
                              or nvl(per_rit_ap,0) = 0
                              or val_voce_ipn != 'C'
                             )
                     )
          )
   ; 
   EXCEPTION WHEN NO_DATA_FOUND THEN 
         V_controllo := 'Y';
   END;
   END IF;
   IF V_controllo = 'X'
   THEN
      D_errore := 'P05610';
      RAISE USCITA;
   END IF;

   BEGIN 
   -- crea tabella in cui inserirà i rec. creati dallo script
   --
   v_comando := 'create table moco_inseriti_dalla_'||prenotazione
                 ||' as select * from movimenti_contabili where 1 = 0';
   si4.sql_execute(V_comando);
   END;

   -- riga 0
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 2, 0,
                 lpad('Anno',4,' ')||' '||
                 lpad('Cod.Ind',8,' ')||' '||
                 rpad('Nominativo',20,' ')||' '||
                 rpad('1^ Scaglione',13,' ')||' '||
                 lpad('Imponibile',14,' ')||' '||
                 lpad('Ritenuta',13,' ')||' '||
                 rpad('2^ Scaglione',13,' ')||' '||
                 lpad('Imponibile',14,' ')||' '||
                 lpad('Ritenuta',13,' ')
                 );
   -- riga 1
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 2, 1, lpad('_',120,'_'));
   -- riga 2
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 2, 2, null );
     v_conta := 2;

  FOR CUR_RIVO IN (select dal,al,LIM_INF,PER_RIT_AP
                        , COD_VOCE_IPN, SUB_VOCE_IPN
                        , COD_VOCE_RID, SUB_VOCE_RID   
                     from ritenute_voce
                    where voce = P_voce2
                      and sub  = P_sub2
                      and dal >= P_dal
                      and nvl(al,to_date('3333333','j')) < to_date('01012005','ddmmyyyy')
                     order by dal desc
                  ) LOOP

  BEGIN
    d_PER_RIT_AP1     := 0;
    d_COD_VOCE_RID1   := null;
    d_SUB_VOCE_RID1   := null;
    BEGIN
    select PER_RIT_AP, COD_VOCE_RID, SUB_VOCE_RID   
      into d_PER_RIT_AP1, d_COD_VOCE_RID1, d_SUB_VOCE_RID1 
      from ritenute_voce
     where voce = P_voce1
       and sub  = P_sub1
       and dal  = cur_rivo.dal;
    END;

    FOR CUR_CI IN (select ci from rapporti_giuridici ragi
                    where exists ( select 'x' 
                                     from movimenti_contabili
                                    where ci   = ragi.ci
                                      and voce = P_voce2
                                      and sub  = P_sub2
                                      and nvl(competenza, riferimento)
                                          between nvl(CUR_RIVO.dal,to_date('2222222','j'))
                                              and nvl(CUR_RIVO.al ,to_date('3333333','j'))
                                      and anno >= to_number(to_char(CUR_RIVO.dal,'yyyy'))
                                   having NVL(SUM(imp),0) != 0 or NVL(SUM(tar),0) != 0
                                  )
                    order by ci
                  ) LOOP

     D_nominativo := null;
     D_riferimento := null;
     D_ipn_cum := 0;
     D_ipn_cum_ap := 0;
     D_ipn1 := 0;
     D_rit1 := 0;
     D_ipn_ap1 := 0;
     D_rit_ap1 := 0;
     D_ipn2 := 0;
     D_rit2 := 0;
     D_ipn_ap2 := 0;
     D_rit_ap2 := 0;
     D_tar := 0;
     d_rit := 0;
     D_tar_ap := 0;
     d_rit_ap := 0;

    BEGIN
      BEGIN
      select substr(cognome||' '||nome,1,100)
        into D_nominativo
       from rapporti_individuali rain
      where ci = CUR_CI.ci
      ;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
      END;
-- Legge l'imponibile cumulativo
      BEGIN
      SELECT NVL(SUM(moco.imp),0)
           , NVL(SUM(moco.ipn_p),0)
           , max(nvl(moco.competenza, moco.riferimento))
        INTO D_ipn_cum
           , D_ipn_cum_ap
           , D_riferimento
        FROM movimenti_contabili moco
       WHERE moco.voce    = CUR_RIVO.cod_voce_ipn
         AND moco.sub     = CUR_RIVO.sub_voce_ipn
         AND nvl(moco.competenza, moco.riferimento)
                             between nvl(CUR_RIVO.dal,to_date('2222222','j'))
                                 and nvl(CUR_RIVO.al ,to_date('3333333','j'))
         AND moco.ci    = CUR_CI.ci
         AND moco.anno >= to_number(to_char(CUR_RIVO.dal,'yyyy'));
      END;
-- Legge la ritenuta sul 1^ scaglione
      BEGIN
      SELECT NVL(SUM(moco.tar),0)
           , nvl(sum(moco.ipn_eap),0)
           , nvl(sum(moco.imp),0)
           , nvl(sum(moco.ipn_p),0)
           , nvl(D_riferimento,max(nvl(moco.competenza, moco.riferimento)))
       INTO D_ipn1
          , D_ipn_ap1
          , D_rit1
          , D_rit_ap1
          , D_riferimento
       FROM movimenti_contabili moco
      WHERE moco.ci    = CUR_CI.ci
        AND moco.anno >= to_number(to_char(CUR_RIVO.dal,'yyyy'))
        AND moco.voce  = P_voce1
        AND moco.sub   = P_sub1
        AND nvl(moco.competenza, moco.riferimento)
            between nvl(CUR_RIVO.dal,to_date('2222222','j'))
                and nvl(CUR_RIVO.al ,to_date('3333333','j'));
      END;
-- Legge la ritenuta sul 2^ scaglione
      BEGIN
      SELECT NVL(SUM(moco.tar),0)
           , nvl(sum(moco.ipn_eap),0)
           , nvl(sum(moco.imp),0)
           , nvl(sum(moco.ipn_p),0)
           , nvl(D_riferimento,max(nvl(moco.competenza, moco.riferimento)))
        INTO D_ipn2
           , D_ipn_ap2
           , D_rit2
           , D_rit_ap2
           , D_riferimento
        FROM movimenti_contabili moco
       WHERE moco.ci    = CUR_CI.ci
         AND moco.anno >= to_number(to_char(CUR_RIVO.dal,'yyyy'))
         AND moco.voce  = P_voce2
         AND moco.sub   = P_sub2
         AND nvl(moco.competenza, moco.riferimento)
             between nvl(CUR_RIVO.dal,to_date('2222222','j'))
                 and nvl(CUR_RIVO.al ,to_date('3333333','j'));
      END;

-- determina le differenze per *R*
      IF abs( D_ipn_cum - D_ipn1 ) > 5 THEN
         D_tar := least( D_ipn2, D_ipn_cum - D_ipn1);
         D_tar_ap := least( D_ipn_ap2, D_ipn_cum_ap - D_ipn_ap1);
      END IF;
      IF abs( D_rit1 - ( round(D_ipn_cum * d_PER_RIT_AP1 / 100,2) * D_moltiplica ) ) > 5 THEN
         d_rit := least( D_rit2 * D_moltiplica
                       , (round(D_ipn_cum * d_PER_RIT_AP1 / 100,2) ) - (D_rit1 * D_moltiplica) 
                       ) * D_moltiplica;
         D_rit_ap := least( D_rit_ap2 * D_moltiplica
                       , (round(D_ipn_cum_ap * d_PER_RIT_AP1 / 100,2) ) - (D_rit_ap1 * D_moltiplica) 
                       ) * D_moltiplica;
      END IF;
      
      IF D_Tar != 0 or d_rit != 0 THEN 
         BEGIN
         insert into movimenti_contabili
         (CI,ANNO,MESE,MENSILITA,VOCE,SUB,RIFERIMENTO,INPUT,
          TAR,QTA,IMP,IPN_EAP,IPN_P,sede_del)
         values
         (CUR_CI.ci,2004,12,'*R*',P_voce1,P_sub1,D_riferimento,'C',
          D_tar,d_PER_RIT_AP1,D_rit,D_tar_ap,D_rit_ap,'X'
         );
         END;

         BEGIN
         insert into movimenti_contabili
         (CI,ANNO,MESE,MENSILITA,VOCE,SUB,RIFERIMENTO,INPUT,
          TAR,QTA,IMP,IPN_EAP,IPN_P,sede_del)
         values
         (CUR_CI.ci,2004,12,'*R*',P_voce2,P_sub2,D_riferimento,'C',
          0,CUR_RIVO.PER_RIT_AP,D_rit *-1,0,D_rit_ap*-1,'X'
         );
         END;

         v_conta := v_conta + 1;
         BEGIN
	 insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
         values (prenotazione, 1, 2, v_conta, 
                 lpad(to_char(D_riferimento,'yyyy'),4,' ')||' '||
                 lpad(CUR_CI.ci,8,' ')||' '||
                 rpad(D_nominativo,20,' ')||' '||
                 rpad(P_voce1||'/'||P_sub1,13,' ')||' '||
                 lpad(to_char(D_tar),14,' ')||' '||
                 lpad(to_char(D_rit),13,' ')||' '||
                 rpad(P_voce2||'/'||P_sub2,13,' ')||' '||
                 lpad('0.00',14,' ')||' '||
                 lpad(to_char(D_rit*-1),13,' ')
                );
         END;

      END IF;

    END;
  END LOOP; -- cursore CUR_CI
  commit;
  END;
 END LOOP; -- cursore CUR_RIVO
 commit;
-- assesta gli eventuali rec. già calcolati con "storno" per avere degli importi "puliti"
-- da indicare nella denuncia DMA
 FOR cur_dma in (select ci,anno,mese,mensilita,riferimento,qta,imp,ipn_eap
                   from movimenti_contabili moco
                  where anno = 2005
                    and mensilita not like '%*%'
                    and voce = P_voce2
                    and sub = P_sub2
                    and to_char(riferimento,'yyyy') < 2005
                    and abs(qta) = 1
                    and abs( (tar*qta/100) - imp) > 5
                    and not exists (select 'x' from movimenti_contabili
                                     where ci = moco.ci
                                       and anno = 2004
                                       and mese = 12
                                       and mensilita = '*R*'
                                       and voce = moco.voce
                                       and sub = moco.sub
                                       and to_char(riferimento,'yyyy') = to_char(moco.riferimento,'yyyy')
                                       and sede_del = 'CSTO'
                                   ) 
                ) loop
 D_imp_new := 0;
 D_imp_eap_new := 0;
-- c'è da gestire anche ipn_eap
 BEGIN
 select (sum(imp) * CUR_dma.qta / 100)
      , (sum(ipn_p) * CUR_dma.qta / 100)
   into D_imp_new,  D_imp_eap_new
   from movimenti_contabili 
  where ci = CUR_dma.ci
    and anno = CUR_dma.anno
    and mese = CUR_dma.mese
    and mensilita = CUR_dma.mensilita
    and (voce,sub) = (select cod_voce_ipn,sub_voce_ipn from ritenute_voce
                       where voce = P_voce2
                         and sub = P_sub2
                         and CUR_dma.riferimento between dal and nvl(al,to_date('3333333','j'))
                     )
    and to_char(riferimento,'yyyymm') = to_char(CUR_dma.riferimento,'yyyymm')
 ;
 EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
           D_imp_new := 0;
           D_imp_eap_new := 0;
 END;
-- Inserisce la diff. per arrivare al nuovo importo sul sub 2 del mese in cui è calcolato
-- la stessa differenza la mette in negativo sempre sul sub 2 in un mese 1 per salvaguardare il progressivo
-- la stessa differenza la mette in negativo sul sub 1 del mese in cui è calcolato per salvaguardare il 
-- calcolo ritenute del mese
-- sempre per salvaguardare il progressivo lo stesso importo lo mette sempre sul sub 1 in negativo in un mese 1
-- con queste registrazioni l'assestamento calcolato è trasparente sia per il calcolo del mese (passa da un 
-- sub all'altro), sia per il calcolo del progressivo avendo inserito la stessa modifica per ogni sub in + e in -
 BEGIN
 insert into movimenti_contabili
         (CI,ANNO,MESE,MENSILITA,VOCE,SUB,RIFERIMENTO,INPUT,
          TAR,QTA,IMP,IPN_EAP,IPN_P,sede_del)
         values
         (CUR_dma.ci,2005,cur_dma.mese,'*R*',P_voce2,P_sub2,cur_dma.riferimento,'C',
          0,0,D_imp_new - CUR_dma.imp,0,D_imp_eap_new - CUR_dma.ipn_eap,'Y'
         );
 END;
 BEGIN
 insert into movimenti_contabili
         (CI,ANNO,MESE,MENSILITA,VOCE,SUB,RIFERIMENTO,INPUT,
          TAR,QTA,IMP,IPN_EAP,IPN_P,sede_del)
         values
         (CUR_dma.ci,2004,12,'*R*',P_voce2,P_sub2,cur_dma.riferimento,'C',
          0,0,(D_imp_new - CUR_dma.imp)* -1 ,0,(D_imp_eap_new - CUR_dma.ipn_eap) * -1,'CSTO'
         );
 END;
 BEGIN
 insert into movimenti_contabili
         (CI,ANNO,MESE,MENSILITA,VOCE,SUB,RIFERIMENTO,INPUT,
          TAR,QTA,IMP,IPN_EAP,IPN_P,sede_del)
         values
         (CUR_dma.ci,2005,cur_dma.mese,'*R*',P_voce1,P_sub1,cur_dma.riferimento,'C',
          0,0,(D_imp_new - CUR_dma.imp) * -1,0,(D_imp_eap_new - CUR_dma.ipn_eap) * -1,'Y'
         );
 END;
 BEGIN
 insert into movimenti_contabili
         (CI,ANNO,MESE,MENSILITA,VOCE,SUB,RIFERIMENTO,INPUT,
          TAR,QTA,IMP,IPN_EAP,IPN_P,sede_del)
         values
         (CUR_dma.ci,2004,12,'*R*',P_voce1,P_sub1,cur_dma.riferimento,'C',
          0,0,(D_imp_new - CUR_dma.imp) ,0,(D_imp_eap_new - CUR_dma.ipn_eap) ,'CSTO'
         );
 END;
 END LOOP;  -- cursore cur_dma
 commit;

 v_comando := 'insert into moco_inseriti_dalla_'||prenotazione
            ||' select * from movimenti_contabili'
            ||' where anno = 2005 and mese = 1 and mensilita = ''*R*'''
            ||' and sede_del in (''X'',''Y'')';
 si4.sql_execute(V_comando);

 BEGIN
 update movimenti_contabili
    set sede_del = ''
  where anno = 2005 and mensilita = '*R*'
    and sede_del in ('Y', 'X')
    and anno_del is null
    and sede_del is null
 ;
 END;


EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 2
           , errore         = D_errore
       where no_prenotazione = prenotazione;
END;
END;
END PECCSTOR;
/
