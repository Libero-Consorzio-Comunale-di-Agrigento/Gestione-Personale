CREATE OR REPLACE PACKAGE PECCCDMA IS
/******************************************************************************
 NOME:        PECCCDMA - CALCOLO RITENUTE / CONTRIBUTI PER DENUNCIA DMA
 DESCRIZIONE: Inserisce record *R* su moco per rettificare riferimenti errati 
              in caso di ritenute / contributi su variabili comunicate a mano
              con data di riferimento precedente al mese di liquidazione.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    18/04/2005   NN   Prima emissione
 1.1  26/04/2005   AM   mod. la verisone per identificare chiaramente la patch 4.8.6
******************************************************************************/
FUNCTION  VERSIONE RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCCDMA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 26/04/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
BEGIN
DECLARE
D_imponibile        MOVIMENTI_CONTABILI.imp%TYPE;
D_rit_contr         MOVIMENTI_CONTABILI.imp%TYPE;
D_riferimento       MOVIMENTI_CONTABILI.riferimento%TYPE;
BEGIN   -- Ciclo Imponibili
  FOR CURI IN
     (select voce, sub
        from contabilita_voce
       where voce in
             (select codice
                from voci_economiche
               where classe = 'I'
                 and specie = 'T')
     )
  LOOP
    BEGIN  -- Ciclo individui / mesi da trattare
    FOR CURIM IN
        (select distinct ci,anno,mese,mensilita
           from movimenti_contabili
          where anno      = 2005
            and mensilita not like '%*%'
            and voce      = curi.voce
            and sub       = curi.sub
            and imp      != 0
         ) LOOP
    BEGIN  -- Ciclo Variabili comunicate
      FOR CURV IN
         (select least(nvl(imvo.al,pere.al),pere.al) riferimento
               , SUM( DECODE( tovo.anno
                            , 'C', NVL(moco.imp,0) - NVL(ipn_p,0)
                            , 'P', DECODE
                                   ( TO_CHAR(moco.riferimento,'yyyy')
                                   , TO_CHAR(last_day(to_date(moco.anno||lpad(moco.mese,2,0),'yyyymm')),'yyyy'), NVL(moco.ipn_p,0)
                                     , NVL(moco.imp,0)
                                   )
                            , 'M', NVL(moco.imp,0) - NVL(ipn_p,0)
                                 , NVL(moco.imp,0)
                            ) * NVL(tovo.per_tot,100) / 100
                              * NVL(imvo.per_ipn,100) / 100
                    )  imp
            from movimenti_contabili moco
               , totalizzazioni_voce tovo
               , periodi_retributivi pere
               , imponibili_voce imvo
           where imvo.voce        = tovo.voce_acc
             and moco.riferimento between nvl(imvo.dal,to_date('2222222','j'))
                                      and nvl(imvo.al,to_date('3333333','j'))
             and moco.riferimento between nvl(tovo.dal,to_date('2222222','j'))
                                      and nvl(tovo.al,to_date('3333333','j'))
             and moco.voce       = tovo.voce
             and moco.sub         = nvl(tovo.sub,moco.sub)
             and tovo.voce_acc    = curi.voce
             and pere.ci          = moco.ci
             and pere.periodo     =       
               ( select nvl(max(periodo),last_day(to_date(moco.anno||lpad(moco.mese,2,0),'yyyymm')))
	             from periodi_retributivi 
	            where ci       = moco.ci 
                    and periodo >= moco.riferimento 
                    and periodo <= last_day(to_date(moco.anno||lpad(moco.mese,2,0),'yyyymm'))
                    and competenza in ('C','A','P')
                    and to_number(to_char(al,'yyyymm')) = to_number(to_char(moco.riferimento,'yyyymm')) 
                    and nvl(tipo,' ') not in ('R','F') 
               ) 
             and (    pere.competenza in ('C','A')
                  and moco.input       = upper(moco.input)
                 )
             and pere.servizio = 'Q'
             and moco.riferimento BETWEEN pere.dal AND pere.al
             and moco.anno = 2005
             and moco.ci = curim.ci
             and moco.mese = curim.mese
             and moco.mensilita = curim.mensilita
             and data is not null
             and not exists (select 'x'
                               from periodi_retributivi
                              where ci = moco.ci
                                and periodo = last_day(to_date(moco.anno||lpad(moco.mese,2,0),'yyyymm'))
                                and competenza in ('C','A','P')
                                and nvl(tipo,' ') not in ('R','F') 
                                and to_number(to_char(al,'yyyymm')) = 
                                    to_number(to_char(moco.riferimento,'yyyymm')) 
                            )
             and not exists (select 'x'
                               from movimenti_contabili
                              where ci = moco.ci
                                and anno = moco.anno
                                and mese = moco.mese
                                and mensilita = moco.mensilita
                                and voce = curi.voce
                                and sub = curi.sub
                                and riferimento = least(nvl(imvo.al,pere.al),pere.al)
                            )
           group by least(nvl(imvo.al,pere.al),pere.al)
             having sum(imp) != 0
         )
      LOOP
          BEGIN
          select nvl( min(moco.riferimento)
                    , last_day(to_date(curim.anno||lpad(curim.mese,2,0),'yyyymm')))
            into D_riferimento
            from movimenti_contabili moco
           where ci   = curim.ci
             and anno = curim.anno
             and mese = curim.mese
             and mensilita = curim.mensilita
             and voce = curi.voce
             and sub  = curi.sub
             and riferimento >= curv.riferimento
          ;
          END;
          BEGIN  -- Inserisce record di storno imponibile con riferimento errato
          insert into MOVIMENTI_CONTABILI
                    ( ci, anno, mese, mensilita, voce, sub
                    , riferimento
                    , input, tar, qta, imp
                    )  
          values ( curim.ci, curim.anno, curim.mese, '*R*', curi.voce, curi.sub
                 , decode( to_char(curv.riferimento,'yyyy')
                         , curim.anno, D_riferimento
                                    , least( D_riferimento
                                           , last_day(to_date(to_char(curv.riferimento,'yyyy')||12,'yyyymm'))
                                           )
                         )
                 , 'C', null, null, curv.imp * -1
                 )
          ;
          END;
          BEGIN  -- Inserisce record di imponibile con riferimento comunicato
          insert into MOVIMENTI_CONTABILI
                    ( ci, anno, mese, mensilita, voce, sub
                    , riferimento
                    , input, tar, qta, imp
                    )
          values ( curim.ci, curim.anno, curim.mese, '*R*', curi.voce, curi.sub
                 , curv.riferimento
                 , 'C', null, null, curv.imp
                 )
          ;
          END;
          BEGIN  -- Ciclo Ritenute / Contributi
            FOR CURR IN
               (select voce, sub, per_ipn, per_rit_ac, per_rit_ap
                     , decode(voec.tipo,'T',-1,1) segno
                  from ritenute_voce rivo
                     , voci_economiche voec
                 where voec.codice = rivo.voce||''
                   and cod_voce_ipn = curi.voce
                   and sub_voce_ipn = curi.sub
                   and curv.riferimento between dal and nvl(al ,to_date(3333333,'j'))
                   and decode ( to_char(curv.riferimento,'yyyy')
                                         , 2005, rivo.per_rit_ac
                                               , rivo.per_rit_ap
                                         ) != 0
                   and exists (select 'x'
                                 from movimenti_contabili
                                where ci = curim.ci
                                  and anno = curim.anno
                                  and mese = curim.mese
                                  and mensilita = curim.mensilita
                                  and voce = rivo.voce
                                  and sub = rivo.sub
                                  and imp != 0
                              )
               )
            LOOP
                select E_Round( curv.imp * curr.per_ipn / 100, 'I')
                     , E_Round( curv.imp * curr.per_ipn / 100, 'I')
                       * decode ( to_char(curv.riferimento,'yyyy')
                                , 2005, curr.per_rit_ac
                                      , curr.per_rit_ap
                                )
                       / 100 * curr.segno
                  into d_imponibile
                     , d_rit_contr
                  from dual
                ;
                BEGIN  -- Inserisce record di storno ritenuta/contributo con riferimento errato
                insert into MOVIMENTI_CONTABILI
                          ( ci, anno, mese, mensilita, voce, sub
                          , riferimento
                          , input
                          , tar
                          , qta
                          , imp
                          )
                values ( curim.ci, curim.anno, curim.mese, '*R*', curr.voce, curr.sub
                       , decode( to_char(curv.riferimento,'yyyy')
                         , curim.anno, D_riferimento
                                    , least( D_riferimento
                                           , last_day(to_date(to_char(curv.riferimento,'yyyy')||12,'yyyymm'))
                                           )
                               )
                       , 'C'
                       , d_imponibile * -1
                       , decode ( to_char(curv.riferimento,'yyyy')
                                , 2005, curr.per_rit_ac
                                      , curr.per_rit_ap
                                )
                       , d_rit_contr * -1
                       )
                ;
                END;
                BEGIN  -- Inserisce record di ritenuta/contributo con riferimento comunicato
                insert into MOVIMENTI_CONTABILI
                          ( ci, anno, mese, mensilita, voce, sub
                          , riferimento
                          , input
                          , tar
                          , qta
                          , imp
                          )
                values ( curim.ci, curim.anno, curim.mese, '*R*', curr.voce, curr.sub
                       , curv.riferimento
                       , 'C'
                       , d_imponibile
                       , decode ( to_char(curv.riferimento,'yyyy')
                                , 2005, curr.per_rit_ac
                                      , curr.per_rit_ap
                                )
                       , d_rit_contr
                       )
                ;
                END;
            END LOOP;  -- Ciclo Ritenute / Contributi
          END;
      END LOOP;  -- Ciclo Variabili comunicate
    END;
    END LOOP;  -- Ciclo individui / mesi
    END;
    commit
    ;
  END LOOP;  -- Ciclo Imponibili
  commit
  ;
END;
END;
END PECCCDMA;
/
