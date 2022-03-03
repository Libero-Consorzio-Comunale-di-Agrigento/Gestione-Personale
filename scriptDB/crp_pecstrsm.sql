CREATE OR REPLACE PACKAGE PECSTRSM IS
/******************************************************************************
 NOME:        PECSTRSM - CREAZIONE SUPPORTO MAGNETICO Statistiche Trimestrali 
              Aziende Sanitarie
 DESCRIZIONE: Creazione dei file TXT da importare sulla stazione del ministero
              Il file prodotto si trovera nella cartella STA del report server
              o dell'application server e si chiamera MODCEM.txt 
              come indicato nelle specifiche tecniche del ministero stesso
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  19/09/2005 MS     Prima Emissione ( Att. 15975 )
 1.1  10/05/2006 MS     Controllo su Negativi ( Att. 15843 )
 1.2  22/05/2006 MS     Gestione degli arretrati AP se Comp. Econ. ( A15844 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSTRSM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 22/05/2006';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS
BEGIN
DECLARE
  P_pagina              number;
  P_riga                number;
  P_riga_s              number := 0;
  P_ente                varchar2(4);
  P_ambiente            varchar2(8);
  P_utente              varchar2(8);
  P_lingua              varchar2(1);
  P_anno                number(4);
  P_mese                number(2);
  P_ini_mese            date;
  P_fin_mese            date;
  P_gestione            varchar2(4);
  P_cod_reg             varchar2(3);
  P_cod_azienda         varchar2(3);
  P_mese_comp           varchar2(1);

  P_serv_fine           number(5);
  P_serv_fine_tot       number(5);
  P_pt_serv             number(5);
  P_pt_serv_tot         number(5);
  P_serv_corso          number(9,2);
  P_serv_corso_tot      number(9,2);
  P_assunti             number(5);
  P_assunti_tot         number(5);
  P_cessati             number(5);
  P_cessati_tot         number(5);
  P_assenze             number(5);
  P_assenze_tot         number(5);
  P_fisse               number(17,2);
  P_fisse_tot           number(17,2);
  P_fisse_arr           number(17,2);
  P_fisse_arr_tot       number(17,2);
  P_acce                number(17,2);
  P_acce_tot            number(17,2);
  P_acce_arr            number(17,2);
  P_acce_arr_tot        number(17,2);
  P_altri_costi         number(17,2);
  P_altri_costi_tot     number(17,2);
  P_coco                number(17,2);
  P_cont                number(17,2) := 0;
  P_cont_tot            number(17,2) := 0;
  P_irap                number(17,2) := 0;
  P_irap_tot            number(17,2) := 0;
  P_coco_tot            number(17,2) := 0;

  USCITA                EXCEPTION;
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    select ente
         , utente
         , ambiente
         , gruppo_ling
      into P_ente,P_utente,P_ambiente,P_lingua
      from a_prenotazioni
     where no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select to_number(substr(valore,1,4))
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
     select anno 
       into P_anno
      from riferimento_retribuzione;
  END;
  BEGIN
    select to_number(substr(valore,1,4))
      into P_mese
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
     select mese
       into P_mese
      from riferimento_retribuzione;
  END;
  BEGIN
    select substr(valore,1,4)
      into P_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_gestione := '%';
  END;

  BEGIN
    select substr(valore,1,3)
      into P_cod_reg
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_COD_REG'
    ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN P_cod_reg := null;
            RAISE USCITA;
  END;
  BEGIN
    select substr(valore,1,3)
      into P_cod_azienda
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_COD_AZIENDA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN P_cod_azienda := null;
            RAISE USCITA;
  END;
  BEGIN
    select substr(valore,1,1)
      into P_mese_comp
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE_COMP'
    ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN P_mese_comp := null;
  END;
  
BEGIN -- Modello CE Mensile
<<MODELLO>>
P_ini_mese  := to_date('01'||lpad(P_mese,2,'0')||lpad(P_anno,4,'0'),'ddmmyyyy');
P_fin_mese  := last_day(to_date(lpad(P_mese,2,'0')||lpad(P_anno,4,'0'),'mmyyyy'));

P_pagina := 1;
P_riga   := 1;

FOR CUR_CATEGORIE IN 
( select substr(descrizione,instr(descrizione,'<')+1
                           ,instr(descrizione,'>')-instr(descrizione,'<')-1
               ) codice
   from qualifiche_statistiche
  where statistica = 'SMTTRI'
 ) LOOP

 P_serv_fine_tot    := 0;
 P_pt_serv_tot      := 0;
 P_serv_corso_tot   := 0;
 P_assunti_tot := 0;
 P_cessati_tot := 0;
 P_assenze_tot := 0;
 P_fisse_tot   := 0;
 P_acce_tot    := 0;
 P_altri_costi_tot  := 0;
 P_fisse_arr_tot    := 0;
 P_acce_arr_tot     := 0;

-- dbms_output.put_line('categoria: '||cur_categorie.codice);

    FOR CUR_CODICE IN 
      ( select distinct codice, descrizione
          from qualifiche_statistiche
         where substr(descrizione,instr(descrizione,'<')+1
                           ,instr(descrizione,'>')-instr(descrizione,'<')-1
                     ) = CUR_CATEGORIE.codice
       )
    LOOP

-- dbms_output.put_line('qualifica min: '||cur_codice.codice);

    P_serv_fine    := 0;
    P_pt_serv      := 0;
    P_serv_corso   := 0;
    P_assunti      := 0;
    P_cessati      := 0;
    P_assenze      := 0;
    P_fisse        := 0;
    P_acce         := 0;
    P_altri_costi  := 0;
    P_fisse_arr    := 0;
    P_acce_arr     := 0;
    P_cont         := 0;
    P_irap         := 0;
    P_coco         := 0;
    
    BEGIN
    <<DATI>>

     IF CUR_CATEGORIE.codice in ( 'CEM01', 'CEM02', 'CEM03', 'CEM04') THEN
      BEGIN
      select round(sum(decode( nvl(stpe.tempo_determinato,'NO') 
                       ,'NO', 1
                            , decode(instr(upper(CUR_CODICE.descrizione),'UOMO/ANNO'),0
                                   , 1
                                   , decode( last_day(stpe.dal)
                                           , stpe.al, decode( to_char(stpe.dal,'dd')
                                                            , '01', 1
                                                                  , (stpe.al - stpe.dal +1 ) / 30
                                                            )
                                           , (stpe.al - stpe.dal +1 ) / 30
                                           ) * decode( P_anno
                                                     , 2003, 1
                                                           , decode( nvl(stpe.part_time,100) 
                                                                   , 100, 1
                                                                        , 0.5
                                                                   )
                                                     )
                                     ) 
                       ) * decode( P_anno
                                 , 2003, nvl(stpe.part_time,100) 
                                       , 100
                                 ) / 100
                ),2)  in_servizio
       into P_serv_fine
       from smttr_individui stin 
          , smttr_periodi stpe
      where stin.anno = stpe.anno
        and stin.mese = stpe.mese
        and stin.gestione = stpe.gestione
        and stin.ci = stpe.ci
        and stin.anno = P_anno
        and stin.gestione like P_gestione
        and stin.mese = P_mese
        and stin.est_comandato = 'NO'
        and (   nvl(stpe.tempo_determinato,'NO') = 'NO' and
                P_fin_mese  between stpe.dal and nvl(stpe.al, to_date('3333333', 'j'))
             or nvl(stpe.tempo_determinato,'NO') = 'SI' and
                P_fin_mese  between stpe.dal and nvl(stpe.al, to_date('3333333', 'j')) and  
                instr(upper(CUR_CODICE.descrizione),'UOMO/ANNO') = 0
             or nvl(stpe.tempo_determinato,'NO') = 'SI' and
                stpe.dal <= P_fin_mese and
                nvl(stpe.al, to_date('3333333', 'j')) >= P_ini_mese and
                instr(upper(CUR_CODICE.descrizione),'UOMO/ANNO') > 0 
            )
        and stpe.qualifica = CUR_CODICE.codice;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
           P_serv_fine := 0;
       END;
       BEGIN
       select count(*)
         into P_assunti
         from smttr_individui stin
             , smttr_periodi stpe 
        where stin.anno = stpe.anno
          and stin.mese = stpe.mese
          and stin.gestione = stpe.gestione
          and stin.ci = stpe.ci
          and stin.anno = P_anno
          and stin.gestione like P_gestione
          and stin.mese = P_mese
          and stpe.qualifica = CUR_CODICE.codice
          and stpe.dal between P_ini_mese and P_fin_mese
          and stpe.assunzione is not null;
       EXCEPTION WHEN NO_DATA_FOUND THEN P_assunti := 0;
       END;

       BEGIN
       select count(*) 
         into P_cessati
         from smttr_individui stin
            , smttr_periodi stpe 
        where stin.anno = stpe.anno
          and stin.mese = stpe.mese
          and stin.gestione = stpe.gestione
          and stin.ci = stpe.ci
          and stin.anno = P_anno
          and stin.gestione like P_gestione
          and stin.mese = P_mese
          and stpe.qualifica = CUR_CODICE.codice
          and nvl(stpe.al,to_date('3333333','j'))  between P_ini_mese-1 and P_fin_mese-1
          and stpe.cessazione is not null;
       EXCEPTION WHEN NO_DATA_FOUND THEN P_cessati := 0;
       END;

       BEGIN
       select sum(gg_assenza)
         into P_assenze
         from smttr_individui stin
            , smttr_periodi stpe 
        where stin.anno = stpe.anno
          and stin.mese = stpe.mese
          and stin.gestione = stpe.gestione
          and stin.ci = stpe.ci
          and stin.anno = P_anno
          and stin.gestione like P_gestione
          and stin.mese = P_mese
          and stpe.qualifica = CUR_CODICE.codice
          and stpe.dal <= P_fin_mese
          and nvl(stpe.al,to_date('3333333', 'j')) >= P_ini_mese;
       EXCEPTION WHEN NO_DATA_FOUND THEN P_assenze := 0;
       END;

-- estrazione importi altri fisse, accessori , contr. e irap personale di macrocategoria
       BEGIN
       select sum( decode(stim.colonna,'FISSE', sum(importo),0)
            + decode(stim.colonna,'FISSE_ARR', sum(importo),0) )
            , sum( decode(stim.colonna,'ACC', sum(importo),0)
            + decode(stim.colonna,'ACC_ARR', sum(importo),0) )
            , sum( decode(stim.colonna,'FISSE_ARR', sum(importo),0) )
            , sum( decode(stim.colonna,'ACC_ARR', sum(importo),0) )
            , sum( decode(stim.colonna,'CONT', sum(importo),0))
            , sum(decode(stim.colonna,'IRAP', sum(importo),0))
         into P_fisse, P_acce
            , P_fisse_arr, P_acce_arr
            , P_cont, P_irap
         from smttr_importi stim
            , smttr_periodi stpe
            , estrazione_valori_contabili esvc
            , voci_economiche             voec
        where stim.anno = stpe.anno
          and stim.mese = stpe.mese
          and stim.gestione = stpe.gestione
          and stim.dal = stpe.dal
          and nvl(stim.al, to_date('3333333','j')) =  nvl(stpe.al, to_date('3333333','j')) 
          and stim.anno = P_anno
          and stim.mese = P_mese
          and stim.gestione like P_gestione
          and stim.colonna in ('FISSE', 'FISSE_ARR', 'ACC', 'ACC_ARR', 'CONT','IRAP')
          and stpe.qualifica = CUR_CODICE.codice
          and stim.al >= to_date('01/01/'||P_anno,'dd/mm/yyyy')
          and nvl(stim.al, to_date('3333333','j')) <= P_fin_mese
          and stim.ci = stpe.ci
          and stim.colonna = esvc.colonna
          and esvc.estrazione = 'SMTTRI'
          and nvl(esvc.al,to_date('3333333','j')) = to_date('3333333','j')
          and voec.codice  = stim.voce
          and ( nvl(P_mese_comp,'N') = 'N'
             or nvl(P_mese_comp,'N') = 'X' and nvl(stim.anno_rif,P_anno) != P_anno-1 
              )
        group by stim.colonna, stim.voce;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
          P_fisse  := 0;
          P_acce  := 0;
          P_fisse_arr  := 0;
          P_acce_arr   := 0;
          P_cont  := 0;
          P_irap  := 0;
       END;

     END IF; -- controllo su macrocategorie

     IF CUR_CATEGORIE.codice = 'CEM03' THEN
      BEGIN
      select round(sum( decode( nvl(stpe.tempo_pieno,'NO')
                                ,'SI', 0
                                     , decode( nvl(stpe.tempo_determinato,'NO') 
                                              ,'NO', 1
                                                   , decode(instr(upper(CUR_CODICE.descrizione),'UOMO/ANNO'),0
                                                            , 1, decode( last_day(stpe.dal)
                                                                       , stpe.al, decode( to_char(stpe.dal,'dd')
                                                                                         , '01', 1
                                                                                               , (stpe.al - stpe.dal +1 ) / 30
                                                                                        )
                                                                                 , (stpe.al - stpe.dal +1 ) / 30
                                                                        ) * decode( P_anno
                                                                                  , 2003, 1
                                                                                        , decode( nvl(stpe.part_time,100) 
                                                                                                , 100, 1
                                                                                                     , 0.5
                                                                                                )
                                                                                   )
                                                            )
                                             ) * decode( P_anno
                                                       , 2003, nvl(stpe.part_time,100) 
                                                             , 100
                                ) / 100 )),2)  part_time
       into P_pt_serv
       from smttr_individui stin 
          , smttr_periodi stpe
      where stin.anno = stpe.anno
        and stin.mese = stpe.mese
        and stin.gestione = stpe.gestione
        and stin.ci = stpe.ci
        and stin.anno = P_anno
        and stin.gestione like P_gestione
        and stin.mese = P_mese
        and stin.est_comandato = 'NO'
        and (   nvl(stpe.tempo_determinato,'NO') = 'NO' and
                P_fin_mese  between stpe.dal and nvl(stpe.al, to_date('3333333', 'j'))
             or nvl(stpe.tempo_determinato,'NO') = 'SI' and
                P_fin_mese  between stpe.dal and nvl(stpe.al, to_date('3333333', 'j')) and  
                instr(upper(CUR_CODICE.descrizione),'UOMO/ANNO') = 0
             or nvl(stpe.tempo_determinato,'NO') = 'SI' and
                stpe.dal <= P_fin_mese and
                nvl(stpe.al, to_date('3333333', 'j')) >= P_ini_mese and
                instr(upper(CUR_CODICE.descrizione),'UOMO/ANNO') > 0 
            )
        and stpe.qualifica = CUR_CODICE.codice;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
           P_pt_serv   := 0;
       END;
     END IF; -- controllo su personale pt

     IF CUR_CATEGORIE.codice = 'CEM05' THEN
      BEGIN
      select round(sum(decode( nvl(stpe.tempo_determinato,'NO') 
                       ,'NO', 1
                            , decode(instr(upper(CUR_CODICE.descrizione),'UOMO/ANNO'),0
                                   , 1
                                   , decode( last_day(stpe.dal)
                                           , stpe.al, decode( to_char(stpe.dal,'dd')
                                                            , '01', 1
                                                                  , (stpe.al - stpe.dal +1 ) / 30
                                                            )
                                           , (stpe.al - stpe.dal +1 ) / 30
                                           ) * decode( P_anno
                                                     , 2003, 1
                                                           , decode( nvl(stpe.part_time,100) 
                                                                   , 100, 1
                                                                        , 0.5
                                                                   )
                                                     )
                                     ) 
                       ) * decode( P_anno
                                 , 2003, nvl(stpe.part_time,100) 
                                       , 100
                                 ) / 100
                ),2)  in_servizio
       into P_serv_corso
       from smttr_individui stin 
          , smttr_periodi stpe
      where stin.anno = stpe.anno
        and stin.mese = stpe.mese
        and stin.gestione = stpe.gestione
        and stin.ci = stpe.ci
        and stin.anno = P_anno
        and stin.gestione like P_gestione
        and stin.mese = P_mese
        and stin.est_comandato = 'NO'
        and nvl(stpe.al, to_date('3333333', 'j')) >= P_ini_mese
        and stpe.dal <= P_fin_mese
        and stpe.qualifica = CUR_CODICE.codice;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
           P_serv_corso := 0;
       END;
     END IF; -- controllo su personale td
-- dbms_output.put_line('serv corso: '||P_serv_corso);
    IF CUR_CATEGORIE.codice in ( 'CEM05', 'CEM06',  'CEM07', 'CEM08' ) THEN
-- estrazione importi altri costi , contr. e irap restante personale
       BEGIN
       select sum( decode(stim.colonna,'FISSE', sum(importo),0)
            + decode(stim.colonna,'FISSE_ARR', sum(importo),0) )
            + sum( decode(stim.colonna,'ACC', sum(importo),0)
            + decode(stim.colonna,'ACC_ARR', sum(importo),0) )
            , sum( decode(stim.colonna,'CONT', sum(importo),0))
            , sum ( decode(stim.colonna,'IRAP', sum(importo),0) )
         into P_altri_costi, P_cont, P_irap
         from smttr_importi stim
            , smttr_periodi stpe
            , estrazione_valori_contabili esvc
            , voci_economiche             voec
        where stim.anno = stpe.anno
          and stim.mese = stpe.mese
          and stim.gestione = stpe.gestione
          and stim.dal = stpe.dal
          and nvl(stim.al, to_date('3333333','j')) =  nvl(stpe.al, to_date('3333333','j')) 
          and stim.anno = P_anno
          and stim.mese = P_mese
          and stim.gestione like P_gestione
          and stim.colonna in ('FISSE', 'FISSE_ARR', 'ACC', 'ACC_ARR', 'CONT','IRAP')
          and stpe.qualifica = CUR_CODICE.codice
          and stim.al >= to_date('01/01/'||P_anno,'dd/mm/yyyy')
          and nvl(stim.al, to_date('3333333','j')) <= P_fin_mese
          and stim.ci = stpe.ci
          and stim.colonna = esvc.colonna
          and esvc.estrazione = 'SMTTRI'
          and nvl(esvc.al,to_date('3333333','j')) = to_date('3333333','j')
          and voec.codice  = stim.voce
          and ( nvl(P_mese_comp,'N') = 'N'
             or nvl(P_mese_comp,'N') = 'X' and nvl(stim.anno_rif,P_anno) != P_anno-1 
              )
        group by stim.colonna, stim.voce;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
          P_altri_costi  := 0;
          P_cont  := 0;
          P_irap  := 0;
       END;
     END IF;

    IF CUR_CATEGORIE.codice in ( 'CEM11' ) THEN
-- estrazione importi collaborazioni
       BEGIN
       select sum( decode(stim.colonna,'FISSE', sum(importo),0)
            + decode(stim.colonna,'FISSE_ARR', sum(importo),0) )
            + sum( decode(stim.colonna,'ACC', sum(importo),0)
            + decode(stim.colonna,'ACC_ARR', sum(importo),0) )
            + sum( decode(stim.colonna,'CONT', sum(importo),0))
            + sum ( decode(stim.colonna,'IRAP', sum(importo),0) )
         into P_coco
         from smttr_importi stim
            , smttr_periodi stpe
            , estrazione_valori_contabili esvc
            , voci_economiche             voec
        where stim.anno = stpe.anno
          and stim.mese = stpe.mese
          and stim.gestione = stpe.gestione
          and stim.dal = stpe.dal
          and nvl(stim.al, to_date('3333333','j')) =  nvl(stpe.al, to_date('3333333','j')) 
          and stim.anno = P_anno
          and stim.mese = P_mese
          and stim.gestione like P_gestione
          and stim.colonna in ('FISSE', 'FISSE_ARR', 'ACC', 'ACC_ARR', 'CONT','IRAP')
          and stpe.qualifica = CUR_CODICE.codice
          and stim.al >= to_date('01/01/'||P_anno,'dd/mm/yyyy')
          and nvl(stim.al, to_date('3333333','j')) <= P_fin_mese
          and stim.ci = stpe.ci
          and stim.colonna = esvc.colonna
          and esvc.estrazione = 'SMTTRI'
          and nvl(esvc.al,to_date('3333333','j')) = to_date('3333333','j')
          and voec.codice  = stim.voce
          and ( nvl(P_mese_comp,'N') = 'N'
             or nvl(P_mese_comp,'N') = 'X' and nvl(stim.anno_rif,P_anno) != P_anno-1 
              )
        group by stim.colonna, stim.voce;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
          P_coco  := 0;
       END;
     END IF; --fine collaborazioni

    END DATI;

    P_serv_fine_tot         := nvl(P_serv_fine_tot,0) + nvl(P_serv_fine,0);
    P_pt_serv_tot           := nvl(P_pt_serv_tot,0) + nvl(P_pt_serv,0);
    P_serv_corso_tot        := nvl(P_serv_corso_tot,0) + nvl(P_serv_corso,0);
    P_assunti_tot           := nvl(P_assunti_tot,0) + nvl(P_assunti,0);
    P_cessati_tot           := nvl(P_cessati_tot,0) + nvl(P_cessati,0);
    P_assenze_tot           := nvl(P_assenze_tot,0) + nvl(P_assenze,0);
    P_fisse_tot             := nvl(P_fisse_tot,0) + nvl(P_fisse,0);
    P_acce_tot              := nvl(P_acce_tot,0) + nvl(P_acce,0);
    P_altri_costi_tot       := nvl(P_altri_costi_tot,0) + nvl(P_altri_costi,0);
    P_fisse_arr_tot         := nvl(P_fisse_arr_tot,0) + nvl(P_fisse_arr,0);
    P_acce_arr_tot          := nvl(P_acce_arr_tot,0) + nvl(P_acce_arr,0);
    P_cont_tot              := nvl(P_cont_tot,0) + nvl(P_cont,0);
    P_irap_tot              := nvl(P_irap_tot,0) + nvl(P_irap,0);
    P_coco_tot              := nvl(P_coco_tot,0) + nvl(P_coco,0);

    END LOOP; -- CUR_CODICE

-- inserimento macrocategorie
    IF CUR_CATEGORIE.codice in ( 'CEM01', 'CEM02',  'CEM03', 'CEM04') 
     and ( nvl(P_serv_fine_tot,0) + nvl(P_pt_serv_tot,0)
     + nvl(P_assunti_tot,0) + nvl(P_cessati_tot,0) + nvl(P_assenze_tot,0)
     + nvl(P_fisse_tot,0) + nvl(P_acce_tot,0)
     + nvl(P_fisse_arr_tot,0) + nvl(P_acce_arr_tot,0) )  > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 1
              , P_pagina
              , P_riga
              , rpad(P_cod_reg,3,' ')
              ||rpad(P_cod_azienda,3,' ')
              ||lpad(to_char(P_anno),4,'0') 
              ||lpad(to_char(P_mese),2,'0') 
              ||rpad(CUR_CATEGORIE.codice,5,' ')
              ||lpad(nvl(P_serv_fine_tot,0),5,0)
              ||lpad(decode( CUR_CATEGORIE.codice
                            , 'CEM03',decode(sign(nvl(P_pt_serv_tot,0)),-1,lpad('0',5,'0'),nvl(P_pt_serv_tot,0))
                                     , 0),5,0)
              ||lpad(0,6,0)||','||lpad(0,2,0)
              ||decode(sign(nvl(P_assunti_tot,0)),-1,lpad('0',5,'0'),lpad(nvl(P_assunti_tot,0),5,0))
              ||decode(sign(nvl(P_cessati_tot,0)),-1,lpad('0',5,'0'),lpad(nvl(P_cessati_tot,0),5,0))
              ||decode(sign(nvl(P_assenze_tot,0)),-1,lpad('0',5,'0'),lpad(nvl(P_assenze_tot,0),5,0))
              ||decode(sign(nvl(P_fisse_tot,0)),-1,lpad('0',15,'0'),lpad(round(nvl(P_fisse_tot,0)),15,0))
              ||decode(sign(nvl(P_fisse_arr_tot,0)),-1,lpad('0',15,'0'),lpad(round(nvl(P_fisse_arr_tot,0)),15,0))
              ||decode(sign(nvl(P_acce_tot,0)),-1,lpad('0',15,'0'),lpad(round(nvl(P_acce_tot,0)),15,0))
              ||decode(sign(nvl(P_acce_arr_tot,0)),-1,lpad('0',15,'0'),lpad(round(nvl(P_acce_arr_tot,0)),15,0))
              ||lpad(0,15,0)
              ||'0'
              );
     commit;
     P_riga := P_riga + 1;
     END IF;
/* controllo negativi */
    IF  nvl(P_serv_fine_tot,0) < 0 
     or nvl(P_pt_serv_tot,0) < 0 or nvl(P_assunti_tot,0) < 0 
     or nvl(P_cessati_tot,0) < 0 or nvl(P_assenze_tot,0) < 0 
     or nvl(P_fisse_tot,0) < 0 or nvl(P_fisse_arr_tot,0) < 0 
     or nvl(P_acce_tot,0) < 0 or nvl(P_acce_arr_tot,0) < 0 
   THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 2
              , P_pagina
              , P_riga_s
              , 'Verificare Dati: Esistono Valori Negativi NON estratti per il Codice: '||CUR_CATEGORIE.codice
              );
    END IF; -- se negativi 
-- inserimento personale restante
-- dbms_output.put_line('tot serv corso: '||P_serv_corso_tot);
    IF CUR_CATEGORIE.codice in ( 'CEM05', 'CEM06',  'CEM07', 'CEM08' ) 
     and  ( nvl(P_altri_costi_tot,0) + nvl(P_serv_corso_tot,0) )  > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 1
              , P_pagina
              , P_riga
              , rpad(P_cod_reg,3,' ')
              ||rpad(P_cod_azienda,3,' ')
              ||lpad(to_char(P_anno),4,'0') 
              ||lpad(to_char(P_mese),2,'0') 
              ||rpad(CUR_CATEGORIE.codice,5,' ')
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||decode( CUR_CATEGORIE.codice
                          , 'CEM05',decode(sign(nvl(P_serv_corso_tot,0))
                                          ,-1 , lpad('0',6,'0')||','||lpad('0',2,'0')
                                              , lpad(trunc(nvl(P_serv_corso_tot,0)),6,0)||','
                                              ||lpad( (P_serv_corso_tot-trunc(nvl(P_serv_corso_tot,0)) ) *100,2,0)
                                          )
                                   , lpad(0,6,0)||','||lpad(0,2,0)
                      )
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||decode(sign(nvl(P_altri_costi_tot,0)),-1, lpad('0',15,'0'),lpad(round(nvl(P_altri_costi_tot,0)),15,0))
              ||'0'
              );
     commit;
     P_riga := P_riga + 1;
     END IF;
/* controllo negativi */
    IF  nvl(P_serv_corso_tot,0) < 0 or nvl(P_altri_costi_tot,0) < 0
   THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 2
              , P_pagina
              , P_riga_s
              , 'Verificare Dati: Esistono Valori Negativi NON estratti per il Codice: '||CUR_CATEGORIE.codice
              );
    END IF; -- se negativi

-- inserimento collaboratori 
    IF CUR_CATEGORIE.codice in ( 'CEM11' ) 
     and  nvl(P_coco_tot,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 1
              , P_pagina
              , P_riga
              , rpad(P_cod_reg,3,' ')
              ||rpad(P_cod_azienda,3,' ')
              ||lpad(to_char(P_anno),4,'0') 
              ||lpad(to_char(P_mese),2,'0') 
              ||'CEM11'
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,6,0)||','||lpad(0,2,0)
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||decode(sign(nvl(P_coco_tot,0)),-1,lpad('0',15,'0'),lpad(round(nvl(P_coco_tot,0)),15,0))
              ||'0'
              );
     commit;
     P_riga := P_riga + 1;
     END IF;
/* controllo negativi */
    IF  nvl(P_coco_tot,0) < 0 THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 2
              , P_pagina
              , P_riga_s
              , 'Verificare Dati: Esistono Valori Negativi NON estratti per il Codice: CEM11'
              );
    END IF; -- se negativi
    END LOOP; -- cursore CUR_categorie --
-- Inserimento Contributi
    IF nvl(P_cont_tot,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 1
              , P_pagina
              , P_riga
              , rpad(P_cod_reg,3,' ')
              ||rpad(P_cod_azienda,3,' ')
              ||lpad(to_char(P_anno),4,'0') 
              ||lpad(to_char(P_mese),2,'0') 
              ||'CEM09'
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,6,0)||','||lpad(0,2,0)
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||decode(sign(nvl(P_cont_tot,0)),-1,lpad('0',15,'0'),lpad(round(nvl(P_cont_tot,0)),15,0))
              ||'0'
              );
     commit;
     P_riga := P_riga + 1;
     END IF;
/* controllo negativi */
    IF  nvl(P_cont_tot,0) < 0 THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 2
              , P_pagina
              , P_riga_s
              , 'Verificare Dati: Esistono Valori Negativi NON estratti per il Codice: CEM09'
              );
    END IF; -- se negativi
-- Inserimento IRAP
    IF nvl(P_irap_tot,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 1
              , P_pagina
              , P_riga
              , rpad(P_cod_reg,3,' ')
              ||rpad(P_cod_azienda,3,' ')
              ||lpad(to_char(P_anno),4,'0') 
              ||lpad(to_char(P_mese),2,'0') 
              ||'CEM10'
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,6,0)||','||lpad(0,2,0)
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,5,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||lpad(0,15,0)
              ||decode(sign(nvl(P_irap_tot,0)),-1, lpad('0',15,'0'),lpad(round(nvl(P_irap_tot,0)),15,0))
              ||'0'
              );
     commit;
     P_riga := P_riga + 1;
     END IF;
/* controllo negativi */
    IF  nvl(P_irap_tot,0) < 0  THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 2
              , P_pagina
              , P_riga_s
              , 'Verificare Dati: Esistono Valori Negativi NON estratti per il Codice: CEM10'
              );
    END IF; -- se negativi
  update a_prenotazioni 
     set errore          = 'P05808'
  where no_prenotazione = prenotazione
    and exists
       (select 'x' 
          from a_appoggio_stampe
         where no_prenotazione = prenotazione
           and no_passo = 2
       )
  ;
  commit;
END MODELLO;
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = 'A05721'
       where no_prenotazione = prenotazione;
      commit;
END;
END;
END;
/
