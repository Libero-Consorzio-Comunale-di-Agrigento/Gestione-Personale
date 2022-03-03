CREATE OR REPLACE PACKAGE PECSMT12 IS
/******************************************************************************
 NOME:          PECSMT12
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:   Elenco delle segnalazioni e relativo codice - vedi PECCARSM
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 2    08/03/2004 GM/MV  Revisione SMT 2004 (con MS)
 3    25/06/2004 AM     Sistemata lettura parametri dal e al
 4    17/03/2005 GM     Revisione SMT 2005
 5    03/05/2005 CB     Revisione SMT 2005
 5.1  20/05/2005 MS     Mod. per att. 11255 
 5.2  24/05/2005 MS     Mod. per att. 11320
 5.3  27/05/2005 MS     Mod. per att. 11411
 5.4  27/05/2005 MS     Mod. per att. 11255.2
 5.5  24/03/2006 MS     Mod. per importi esterni AP ( att. 15505 )
 5.6  03/04/2006 MS     Mod. per importi riferiti periodi prec (Att. 15609 )
 5.7  04/04/2006 MS     Mod. conteggio giorni per mensilita (Att. 15590 )
 5.8  20/04/2006 MS     Correzioni varie per SMT 2006 ( A15666 )
 5.9  04/05/2006 MS     Migliorie tempi di elaborazione ( A16077 )
 5.10 08/05/2006 MS     Inversione cursori + corretto errore ORA ( Att. 16140 )
 5.11 13/07/2006 MS     Modifica gestione segnalazioni ( A16329 )
 5.12 22/03/2007 CB     Gestione di rqmi.posizione (A20251)
 6.0  03/05/2007 MS     Gestione COMPARTO per arretrati PD ( A20817 ) - modifiche normative 2007
 6.1  08/05/2007 CB     Modifica nome colonne archiviate ( A20830 )
 6.2  24/05/2007 MS     Eliminata gestione arretrati PD messa in pkg a parte ( A21313 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMT12 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V6.2 del 24/05/2007';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS

BEGIN
DECLARE
  P_anno       number(4);
  P_ini_a      varchar2(8);
  P_fin_a      varchar2(8);
  P_fin_ap     varchar2(8);
  P_gestione   varchar2(4);
  P_data_da    date;
  P_data_a     date;
  D_utente     varchar2(8);
  D_ambiente   varchar2(8);
  D_ente       varchar2(4);
  D_int_com    varchar2(2);
  D_est_com    varchar2(2);
  D_tipo       varchar2(1);
  D_elab       varchar2(1);
  D_ci         number(8);
  D_riga       number := 0;
  D_pagina     number := 0;
  P_competenza varchar2(1); -- parametri per Sanita
  P_inizio_mese_liq   number; -- parametri per Sanita
  P_fine_mese_liq     number; -- parametri per Sanita
  V_controllo  varchar2(1);
  D_qualifica  number; 
  D_codice     varchar2(8); 
  D_valore      varchar2(8);
  D_importo_col_3 number(12,2);
  D_importo_col_2 number(12,2);
  V_testo       varchar2(500);   
  V_dal         date := null;

BEGIN
  BEGIN
    select substr(valore,1,4)  D_gestione
      into P_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
      P_gestione := '%';
  END;
  BEGIN
    SELECT to_number(substr(valore,1,8))
      INTO D_ci
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ci := null;
  END;
  BEGIN
    SELECT valore
      INTO D_elab
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ELAB'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_elab := 'T';
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
      D_tipo := 'T';
  END;
  BEGIN
    select to_date(valore,'dd/mm/yyyy') D_data_a
      into P_data_a
      from a_parametri
     where no_prenotazione=prenotazione
       and parametro='P_A'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    P_data_a := null;
  END;
  BEGIN
    select to_date(valore,'dd/mm/yyyy') D_data_da
      into P_data_da
      from a_parametri
     where no_prenotazione=prenotazione
       and parametro='P_DA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    P_data_da := null;
  END;
  BEGIN
    select substr(valore,1,4)  D_anno
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_ANNO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    select to_char(to_date
                  ('0101'||nvl(P_anno,anno),'ddmmyyyy')
                  ,'ddmmyyyy')                               
         , to_char(to_date
                  ('3112'||nvl(P_anno,anno),'ddmmyyyy')
                  ,'ddmmyyyy')                               
         , to_char(to_date
                  ('3112'||(nvl(P_anno,anno)-1),'ddmmyyyy')
                  ,'ddmmyyyy')                               
         , nvl(P_anno,anno)                                  
      into P_ini_a, P_fin_a, P_fin_ap, P_anno
      from riferimento_fine_anno
     where rifa_id = 'RIFA'
    ;
  END;
  BEGIN
    select ente,ambiente,utente
      into D_ente,D_ambiente,D_utente
      from a_prenotazioni
     where no_prenotazione = prenotazione;
  EXCEPTION
    when no_data_found then
      D_ente     := NULL;
      D_utente   := NULL;
      D_ambiente := NULL;
  END;
  BEGIN
    select valore
      into P_competenza
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_COMPETENZA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
   P_competenza := 'N';
  END;
  BEGIN
    select decode( nvl(P_competenza,'N')
                 , 'X', lpad(substr(valore,1,2),2,0)
                      , 1
                  )
      into P_inizio_mese_liq
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE_DA';
  EXCEPTION WHEN NO_DATA_FOUND THEN 
      P_inizio_mese_liq := 1;
  END;
  BEGIN
    select decode( nvl(P_competenza,'N')
                 , 'X', lpad(substr(valore,1,2),2,0)
                      , 12
                  )
      into P_fine_mese_liq
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE_A';
  EXCEPTION WHEN NO_DATA_FOUND THEN 
      P_fine_mese_liq   := 12;
  END;
  BEGIN
    select max(nvl(pagina,0))+1
      into D_pagina
      from a_appoggio_stampe
     where no_prenotazione = prenotazione
       and passo = 2
    ;
  EXCEPTION WHEN OTHERS THEN
    D_pagina := 0;
  END;
 IF D_ELAB IN ('E','T') THEN
 BEGIN
 <<TABELLA_12>>
       IF D_tipo = 'T' THEN
         delete from smt_importi
          where anno     = P_anno
            and gestione in ( select codice  codice
                                from gestioni
                               where codice like nvl(P_gestione,'%')
                                 and gestito   = 'SI'
                             )
            and tabella  = 'T12'
          ;
         commit;
       END IF;
         BEGIN             
           FOR CUR_CI in 
               ( select distinct smpe.ci , smpe.gestione
                   from smt_periodi smpe
                  where anno = P_anno
                    and gestione in ( select codice  codice
                                      from gestioni
                                     where codice like nvl(P_gestione,'%')
                                       and gestito   = 'SI'
                                   )
                 AND ( D_tipo = 'T'
                 or ( D_tipo in ('I','V','P')
                      and ( not exists (select 'x' from smt_individui
                                       where anno     = P_anno
                                         and ci       = smpe.ci
                                         and gestione = smpe.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                         select 'x' from smt_periodi
                                       where anno = P_anno
                                         and ci   = smpe.ci
                                         and gestione = smpe.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                        select 'x' from smt_importi
                                       where anno = P_anno
                                         and ci   = smpe.ci
                                         and gestione = smpe.gestione
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                     )
                          )
                    )
                 or ( D_tipo  = 'S'
                      and smpe.ci = D_ci )
               )
          order by 1
             ) LOOP  
-- dbms_output.put_line('cur1: '||cur_ci.ci||' '||CUR_CI.gestione);
           BEGIN
              --cancello registrazioni precedenti
              delete from smt_importi
                where anno     = P_anno
                  and ci       = CUR_CI.ci
                  and gestione = CUR_CI.gestione
                  and tabella  = 'T12'
                ;
               COMMIT;
              FOR CURS IN
                  (select smpe.gestione                gestione
                        , smpe.ci                      ci
                        , smpe.dal dal
                        , smpe.dal dal_periodo
                        , least(nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy'))
                               ,nvl(smpe.al,to_date('3333333','j')))    al
                     from smt_periodi           smpe
                    where smpe.gestione        = CUR_CI.gestione
                      and smpe.anno            = P_anno
                      and smpe.ci              = CUR_CI.ci
                      and smpe.dal             <= nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy'))
                      and nvl(smpe.al,to_date('3333333','j')) >=
                                                  nvl(P_data_da-1,to_date('3112'||P_anno-1,'ddmmyyyy'))
                      and exists
                         (select 'x' from movimenti_contabili
                           where anno = P_anno
                             and ci   = smpe.ci
                             and ci   = CUR_CI.ci
                             and mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                          and nvl(to_number(to_char(p_data_a,'mm')),12)
                             and riferimento between smpe.dal
                                                 and least(nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy'))
                                                          ,nvl(smpe.al,to_date('3333333','j')))  
                          union
                          select 'x' from movimenti_contabili
                           where anno = P_anno+1 
                             and nvl(P_competenza,'N') = 'X'
                             and mese <= P_fine_mese_liq
                             and ci   = smpe.ci
                             and ci   = CUR_CI.ci
                             and mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                          and nvl(to_number(to_char(p_data_a,'mm')),12)
                             and to_char(riferimento,'yyyy') = P_anno
                        )
                     ) LOOP
                    BEGIN
                      D_int_com        := null;
                      D_est_com        := null;
-- dbms_output.put_line('CI CURS: '||CURS.ci||' '||CURS.dal||' '||CURS.al);
                        FOR VACM IN
                        (select vacm.colonna               colonna
                               ,sum(nvl(vacm.valore,0))    importo
                           from valori_contabili_mensili   vacm
                          where vacm.estrazione      = 'SMT_TAB8A'
                            and vacm.colonna in ('STIPENDI','IIS','RIA','13A','INDENNITA','RECUPERI')
                            and vacm.ci               = CURS.ci
/* aggiunto per i tempi di elaborazione */
                            and vacm.anno between P_anno and P_anno+1 
                            and vacm.mese             between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                          and nvl(to_number(to_char(p_data_a,'mm')),12)
                            and vacm.mensilita       != '*AP' 
                            and ( nvl(P_competenza,'N') = 'N'
                                 and vacm.anno              = P_anno
                                 and vacm.riferimento
                                      between CURS.dal and     nvl(CURS.al,to_date('3333333','j'))
                                 or nvl(P_competenza,'N')= 'X'
                                  and vacm.anno             = P_anno
                                  and to_char(vacm.riferimento,'yyyy') = P_anno
                                  and vacm.riferimento
                                      between CURS.dal and     nvl(CURS.al,to_date('3333333','j'))
                                )
                          group by vacm.ci
                              , vacm.colonna
                         having nvl(sum(valore),0) != 0
                          UNION 
                          select vacm.colonna               colonna
                               ,sum(nvl(vacm.valore,0))    importo
                           from valori_contabili_mensili   vacm
                          where vacm.estrazione      = 'SMT_TAB8A'
                            and vacm.colonna         = 'ARRETRATI'
                            and vacm.ci               = CURS.ci
/* aggiunto per i tempi di elaborazione */
                            and vacm.anno between P_anno and P_anno+1 
                            and vacm.mese             between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                          and nvl(to_number(to_char(p_data_a,'mm')),12)
                            and vacm.mensilita       != '*AP' 
                            and ( nvl(P_competenza,'N') = 'N'
                                 and vacm.anno              = P_anno
                                 and vacm.riferimento
                                     between CURS.dal and     nvl(CURS.al,to_date('3333333','j'))
                                  or nvl(P_competenza,'N') = 'X'
                                 and vacm.anno             = P_anno+1
                                 and to_char(vacm.riferimento,'yyyy') = P_anno
                                 and vacm.mese             <= P_fine_mese_liq
                                 and vacm.riferimento
                                     between CURS.dal and     nvl(CURS.al,to_date('3333333','j'))
                                )
                          group by vacm.ci
                              , vacm.colonna
                         having nvl(sum(valore),0) != 0
                          UNION 
/* gestione degli arretrati ap */
                         select vacm.colonna               colonna
                               ,sum(nvl(vacm.valore,0))    importo
                           from valori_contabili_mensili   vacm
                          where vacm.estrazione      = 'SMT_TAB8A'
                            and vacm.colonna         = 'ARRETRATI_AP'
                            and vacm.ci               = CURS.ci
/* aggiunto per i tempi di elaborazione */
                            and vacm.anno between P_anno and P_anno+1 
                            and vacm.mese             between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                          and nvl(to_number(to_char(p_data_a,'mm')),12)
                            and vacm.mensilita       != '*AP' 
                            and ( nvl(P_competenza,'N') = 'N'
                                 and vacm.anno              = P_anno
                                 and vacm.riferimento
                                     between CURS.dal and     nvl(CURS.al,to_date('3333333','j'))
                                 or ( nvl(P_competenza,'N')= 'X'
                                  and vacm.anno             = P_anno
                                  and to_char(vacm.riferimento,'yyyy') < P_anno
                                  and vacm.riferimento
                                      between CURS.dal and     nvl(CURS.al,to_date('3333333','j'))
                                  and to_char(vacm.riferimento,'yyyy') < P_anno
                                  and vacm.mese             >= P_inizio_mese_liq
                                    or nvl(P_competenza,'N') = 'X'
                                   and vacm.anno             = P_anno+1
                                   and to_char(vacm.riferimento,'yyyy') < P_anno
                                   and vacm.mese            <= P_fine_mese_liq
                                   and vacm.riferimento
                                       between CURS.dal and     nvl(CURS.al,to_date('3333333','j'))
                                    )
                                )
                          group by vacm.ci
                              , vacm.colonna
                         having nvl(sum(valore),0) != 0
                          UNION 
                         select 'GG' colonna
                              , round(sum(pere.gg_rap/decode(cost.gg_lavoro,0,1,cost.gg_lavoro)),2) importo
                           from periodi_retributivi   pere
                              , contratti_storici     cost
                          where pere.ci = CURS.ci
                            and pere.periodo >= to_date(P_ini_a,'ddmmyyyy')
                            and to_char(pere.al,'yyyy') = P_anno
                            and pere.competenza in ('A','C','P')
                            and pere.contratto = cost.contratto
                            and pere.periodo between cost.dal
                                                 and nvl(cost.al,to_date('3333333','j'))
                            and nvl(pere.gg_rap,0) != 0
                            and cost.gg_lavoro     != 0
                            and pere.al between greatest(CURS.dal,nvl(P_data_da,to_date(P_ini_a,'ddmmyyyy')))
                                            and nvl(CURS.al,nvl(P_data_a,to_date('3333333','j')))
                        ) LOOP

-- dbms_output.put_line('VACM : '||VACM.colonna||' '|| VACM.importo);
                            BEGIN
                            --inserisco in smt_importi
                           insert into smt_importi
                            (ANNO,CI,GESTIONE,DAL,TABELLA
                            ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                            )
                            select P_anno
                                 , CURS.ci
                                 , CURS.gestione
                                 , CURS.dal_periodo
                                 , 'T12'
                                 , VACM.colonna
                                 , VACM.importo
                                 , D_utente
                                 , null
                                 , sysdate
                              from dual
                            ;
                            commit;
                            END;
                            END LOOP; --VACM                            
                          END;
                            BEGIN
                              FOR CUR_CONTROLLI IN
                               (  select ci, dal, al, gestione
                                    from smt_periodi  stpe
                                   where ci        = CURS.ci
                                     and anno      = P_anno
                                     and gestione  = CUR_CI.gestione
                                     and exists ( select 'x'
                                                    from smt_importi
                                                   where ci             = stpe.ci
                                                     and anno           = stpe.anno
                                                     and tabella        = 'T12'
                                                     and colonna       != 'GG'
                                                     and gestione       = stpe.gestione
                                                   group by ci, anno, gestione
                                                  having sum(nvl(importo,0)) = 0
                                                )
                               and ( D_tipo in ('T','V','I','P')
                                or ( D_tipo = 'S' and stpe.ci = D_ci)
                                   )
                               ) LOOP
-- dbms_output.put_line('Cur_controlli: '||CUR_CONTROLLI.ci);
                                 BEGIN
                                 IF D_pagina is null THEN D_pagina := 1;
                                 END IF;
                                 D_riga           := nvl(D_riga,0) + 1 ;
                                 V_testo := lpad('Errore 020',10)||
                                          lpad(nvl(CUR_CONTROLLI.gestione,' '),4,' ')||
                                          lpad(nvl(CUR_CONTROLLI.ci,0),8,0)||
                                          lpad(nvl(to_char(CUR_CONTROLLI.dal,'ddmmyyyy'),' '),8,' ')||
                                          lpad(nvl(to_char(CUR_CONTROLLI.al,'ddmmyyyy'),' '),8,' ')||
                                          rpad('Verificare Correttezza Dipendente: Esistono Record con Importo Nullo in T12',132,' ')
                                       ;
                                 insert into a_appoggio_stampe
                                 (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                                 select  prenotazione
                                        , 2
                                        , D_pagina
                                        , D_riga
                                        , V_testo
                                   from dual
                                  where not exists ( select 'x' 
                                                       from a_appoggio_stampe
                                                       where no_prenotazione = prenotazione
                                                         and passo = 2
                                                         and testo = V_testo
                                                  )
                             ;
                                 END;
                               END LOOP; -- cur_controlli
                        END;
                       BEGIN
                           select qualifica,contratto
                             into D_qualifica,D_codice
                             from periodi_giuridici pegi_s,
                                  qualifiche_giuridiche qugi
                            where rilevanza='S'
                              and pegi_s.ci= cur_ci.ci
                              and nvl(curs.al,to_date('3333333','j')) between pegi_s.dal and nvl(pegi_s.al,to_date('3333333','j'))
                              and pegi_s.qualifica= qugi.numero
                              and least(nvl(pegi_s.al,to_date('3333333','j')),to_date(P_fin_a,'ddmmyyyy'))
                                  between nvl(qugi.dal,to_date('2222222','j'))
                                      and nvl(qugi.al ,to_date('3333333','j'));
                       EXCEPTION 
                            WHEN NO_DATA_FOUND THEN D_codice := null;
                       END;
                       BEGIN
                            select substr(rtrim(ltrim(nvl(substr(esvc.note , instr(esvc.note,'<',  instr(esvc.note,D_codice)-1) +1
                                                   , instr(esvc.note,'>',  instr(esvc.note,D_codice)) -1 - instr(esvc.note,'<',  instr(esvc.note,D_codice)-1)
                                        ),' '))),1,8)
                              into  D_valore
                              from  estrazione_valori_contabili esvc
                             where  colonna ='IIS'
                               and  estrazione='SMT_TAB8A'
                               and  nvl(curs.al,to_date('3333333','j')) 
                                    between dal and nvl(al,to_date('3333333','j'));
                       EXCEPTION 
                            WHEN NO_DATA_FOUND THEN D_valore:=null;
                      END;
                      IF D_valore =  D_codice then
                          BEGIN
                             select sum(importo) 
                               into D_importo_col_3
                               from smt_importi
                              where ci =cur_ci.ci
                                and anno= P_anno
                                and gestione = curs.gestione
                                and tabella='T12'
                                and colonna='03'
                                and dal = CURS.dal_periodo;
                          EXCEPTION 
                                WHEN NO_DATA_FOUND THEN D_importo_col_3:=0;
                          END;
                          BEGIN
                           select sum(importo) 
                             into D_importo_col_2
                             from smt_importi
                            where ci =cur_ci.ci
                              and anno= P_anno
                              and gestione = curs.gestione
                              and tabella='T12'
                              and colonna='02'
                              and dal = CURS.dal_periodo;                           
                          EXCEPTION 
                                WHEN NO_DATA_FOUND THEN D_importo_col_2:=0;
                          END;
                        delete from smt_importi
                         where ci =cur_ci.ci
                           and anno= P_anno
                           and gestione = curs.gestione
                           and tabella='T12'
                           and colonna='03'
                           and dal = CURS.dal_periodo;
                        commit;
                        update smt_importi
                           set importo = nvl(D_importo_col_2,0)+nvl(D_importo_col_3,0)
                         where ci =cur_ci.ci
                           and anno= P_anno
                           and gestione = curs.gestione
                           and tabella='T12'
                           and colonna='02'
                           and dal = CURS.dal_periodo; 
                        commit;
                      ELSE
                          null;
                      END IF;
                    END LOOP; -- CURS
           END;
           BEGIN
             select 'X'
               into V_controllo
               from dual
              where exists ( select 'x' 
                               from valori_contabili_mensili vacm
                              where vacm.ci               = CUR_CI.ci
                                and vacm.mensilita        != '*AP' 
                                and vacm.estrazione       = 'SMT_TAB8A'
                                and vacm.colonna in ('STIPENDI','IIS','RIA','13A','INDENNITA','RECUPERI')
/* aggiunto per i tempi di elaborazione */
                                and vacm.anno between P_anno and P_anno+1 
                                and to_char(vacm.riferimento,'yyyy') = P_anno
                                and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                   and nvl(to_number(to_char(p_data_a,'mm')),12)
                                and not exists (select 'x' from smt_periodi
                                                 where ci   = vacm.ci
                                                   and anno = P_anno
                                                   and least(nvl(al, to_date(P_fin_a,'ddmmyyyy')) 
                                                            , to_date(P_ini_a,'ddmmyyyy')) 
                                                       between to_date(P_ini_a,'ddmmyyyy')
                                                           and to_date(P_fin_a,'ddmmyyyy')
                                               )
                                and vacm.valore != 0
                            );
            IF V_controllo = 'X' THEN
            BEGIN
             IF D_pagina is null THEN D_pagina := 0;
             END IF;
             D_riga   := nvl(D_riga,0) + 1;
             d_riga := d_riga + 1;
            V_testo := lpad('Errore 022',10)||
                      lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                      lpad(nvl(CUR_CI.ci,0),8,0)||
                      lpad(' ',8,' ')||
                      lpad(' ',8,' ')||
                      rpad('Verificare Importi: riferimento attuale non archiviato in T12',132,' ')
                   ;
             insert into a_appoggio_stampe (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
             select   prenotazione
                    , 2
                    , D_pagina
                    , D_riga
                    , V_testo
               from dual
              where not exists ( select 'x' 
                                   from a_appoggio_stampe
                                  where no_prenotazione = prenotazione
                                    and passo = 2
                                    and testo = V_testo
                     );
              END;
             END IF;
           EXCEPTION 
             WHEN NO_DATA_FOUND THEN 
               NULL;
           END;
           BEGIN 
             FOR CUR_PER_CON IN
               (select dal, al
                  from smt_periodi smpe
                 where anno              = P_anno
                   and ci                = CUR_CI.ci
                   and gestione          = CUR_CI.gestione
                   and exists (select 'x' from smt_periodi
                                where ci         = smpe.ci
                                  and anno       = smpe.anno
                                  and gestione   = smpe.gestione
                                  and dal        = smpe.al+1
                                  and qualifica != smpe.qualifica
                              )
                   and nvl(al,to_date('3333333','j')) != last_day(nvl(al,to_date('3333333','j')))
                order by dal, al
                ) LOOP
-- dbms_output.put_line('Insert CUR_PER_CON: '||CUR_PER_CON.dal||' '||CUR_PER_CON.al);
                    IF D_pagina is null THEN D_pagina := 1;
                    END IF;
                    d_riga := d_riga + 1;
                   V_testo := lpad('Errore 024',10)||
                             lpad(nvl(CUR_CI.gestione,' '),4,' ')||
                             lpad(nvl(CUR_CI.ci,0),8,0)||
                             lpad(nvl(to_char(CUR_PER_CON.dal,'ddmmyyyy'),' '),8,' ')||
                             lpad(nvl(to_char(CUR_PER_CON.al,'ddmmyyyy'),' '),8,' ')||
                             rpad('Dipendenti con cambio di qualifica all''interno del mese',132,' ')
                           ;
                    insert  into a_appoggio_stampe (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                    select   prenotazione
                           , 2
                           , D_pagina
                           , D_riga
                           , V_testo
                     from dual
                    where not exists ( select 'x' 
                                         from a_appoggio_stampe
                                        where no_prenotazione = prenotazione
                                          and passo = 2
                                          and testo = V_testo
                                     );
             END LOOP; -- CUR_PER_CON
           END;
           END LOOP; -- CUR_CI

        BEGIN
       <<ESTERNI>>
        FOR CUR_CI_1 in
         ( select distinct ci
             from smt_periodi smpe
            where smpe.anno     = P_anno
              and categoria    != lpad('9',10,'9')
              AND ( D_tipo = 'T'
                 or ( D_tipo in ('I','V','P')
                      and ( not exists (select 'x' from smt_individui
                                       where anno     = P_anno
                                         and ci       = smpe.ci
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                         select 'x' from smt_periodi
                                       where anno = P_anno
                                         and ci   = smpe.ci
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                        union
                                        select 'x' from smt_importi
                                       where anno = P_anno
                                         and ci   = smpe.ci
                                         and nvl(tipo_agg,' ') = decode(D_tipo
                                                                       ,'P',tipo_agg
                                                                       ,D_tipo)
                                     )
                          )
                    )
                 or ( D_tipo  = 'S'
                      and smpe.ci = D_ci )
                )
        ) LOOP
        BEGIN
         FOR CUR_ESTERNI in 
             (select distinct ci
                from smt_periodi smpe
               where smpe.anno            = P_anno
                 and smpe.ci              = CUR_CI_1.ci
                 and exists (select 'x' 
                               from valori_contabili_mensili vacm
                              where ( nvl(P_competenza,'N') = 'N'
                                 and vacm.anno              = P_anno
                                 and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                    and nvl(to_number(to_char(p_data_a,'mm')),12)
                                 or ( nvl(P_competenza,'N') = 'X'
                                  and vacm.anno             = P_anno
                                  and to_char(vacm.riferimento,'yyyy') = P_anno
                                    )
                                )
                                and vacm.mensilita        !=  '*AP'
                                and vacm.estrazione       = 'SMT_TAB8A'
                                and vacm.colonna in ('STIPENDI','IIS','RIA','13A','INDENNITA','RECUPERI')
                                and vacm.ci                = smpe.ci
                                and vacm.anno              = P_anno
                                and vacm.mensilita    != '*AP'
                                and not exists (select 'x' from smt_periodi smpe1
                                                 where ci        = vacm.ci
                                                   and smpe1.anno            = P_anno
                                                   and vacm.anno             = P_anno
                                                   and ( nvl(P_competenza,'N') = 'N'
                                                   and vacm.anno              = P_anno
                                                   and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                      and nvl(to_number(to_char(p_data_a,'mm')),12)
                                                   and vacm.riferimento 
                                                       between dal 
                                                           and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                   or (  nvl(P_competenza,'N') = 'X'
                                                     and vacm.anno             = P_anno
                                                     and to_char(vacm.riferimento,'yyyy') = P_anno
                                                     and vacm.riferimento 
                                                         between dal 
                                                             and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                      )
                                                     )
                                                ) 
                            UNION 
                            select 'x' 
                               from valori_contabili_mensili vacm
                              where ( nvl(P_competenza,'N') = 'N'
                                 and vacm.anno              = P_anno
                                 and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                    and nvl(to_number(to_char(p_data_a,'mm')),12)
                                 or ( nvl(P_competenza,'N') = 'X'
                                   and vacm.anno             = P_anno+1
                                   and to_char(vacm.riferimento,'yyyy') = P_anno
                                   and vacm.mese            <= P_fine_mese_liq
                                    )
                                )
                                and vacm.mensilita        !=  '*AP'
                                and vacm.estrazione       = 'SMT_TAB8A'
                                and vacm.colonna          = 'ARRETRATI'
                                and vacm.ci                = smpe.ci
                                and vacm.anno between P_anno and P_anno+1 
                                and vacm.mensilita    != '*AP'
                                and not exists (select 'x' from smt_periodi smpe1
                                                 where ci        = vacm.ci
                                                   and smpe1.anno = P_anno
                                                   and vacm.anno between P_anno and P_anno+1 
                                                   and ( nvl(P_competenza,'N') = 'N'
                                                   and vacm.anno              = P_anno
                                                   and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                      and nvl(to_number(to_char(p_data_a,'mm')),12)
                                                   and vacm.riferimento 
                                                       between dal 
                                                           and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                   or (  nvl(P_competenza,'N') = 'X'
                                                     and vacm.anno             = P_anno+1
                                                     and to_char(vacm.riferimento,'yyyy') = P_anno
                                                     and vacm.mese            <= P_fine_mese_liq
                                                     and vacm.riferimento 
                                                         between dal 
                                                             and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                      )
                                                     )
                                                ) 
                            UNION 
/* gestione degli arretrati ap */
                            select 'x' 
                               from valori_contabili_mensili vacm
                              where ( nvl(P_competenza,'N') = 'N'
                                 and vacm.anno              = P_anno
                                 and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                    and nvl(to_number(to_char(p_data_a,'mm')),12)
                                 or ( nvl(P_competenza,'N') = 'X'
                                  and vacm.anno             = P_anno
                                  and to_char(vacm.riferimento,'yyyy') < P_anno
                                  and vacm.mese            >= P_inizio_mese_liq
                                    or nvl(P_competenza,'N')= 'X'
                                   and vacm.anno             = P_anno+1
                                   and to_char(vacm.riferimento,'yyyy') < P_anno
                                   and vacm.mese             <= P_fine_mese_liq
                                    )
                                )
                                and vacm.mensilita        !=  '*AP'
                                and vacm.estrazione       = 'SMT_TAB8A'
                                and vacm.colonna          = 'ARRETRATI_AP'
                                and vacm.ci                = smpe.ci
                                and vacm.anno between P_anno and P_anno+1 
                                and vacm.mensilita    != '*AP'
                                and not exists ( select 'x' from smt_periodi smpe1
                                                  where ci        = vacm.ci
                                                   and smpe1.anno = P_anno
                                                   and vacm.anno between P_anno and P_anno+1 
                                                   and ( nvl(P_competenza,'N') = 'N'
                                                   and vacm.anno              = P_anno
                                                   and vacm.mese  between nvl(to_number(to_char(p_data_da,'mm')),1)
                                                                      and nvl(to_number(to_char(p_data_a,'mm')),12)
                                                   and vacm.riferimento 
                                                       between dal 
                                                           and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                   or (  nvl(P_competenza,'N') = 'X'
                                                     and vacm.anno             = P_anno
                                                     and to_char(vacm.riferimento,'yyyy') < P_anno
                                                     and vacm.riferimento 
                                                         between dal 
                                                             and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                     and vacm.mese            >= P_inizio_mese_liq
                                                      or nvl(P_competenza,'N') = 'X'
                                                     and vacm.anno             = P_anno+1
                                                     and to_char(vacm.riferimento,'yyyy') < P_anno
                                                     and vacm.mese            <= P_fine_mese_liq
                                                     and vacm.riferimento 
                                                         between dal 
                                                             and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                      )
                                                     )
                                                ) 
                             )
            ) LOOP
-- dbms_output.put_line('CUR ESTERNI: '||CUR_ESTERNI.ci);
                BEGIN
                  FOR CUR_VACM_EST IN (
                  select vacm.colonna colonna, vacm.riferimento
                       , nvl(sum(nvl(vacm.valore,0)),0) importo                
                    from valori_contabili_mensili    vacm
                   where vacm.ci                = cur_esterni.ci
/* aggiunto per i tempi di elaborazione */
                     and vacm.anno between P_anno and P_anno+1 
                     and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                       and nvl(to_number(to_char(p_data_a,'mm')),12)
                     and ( nvl(P_competenza,'N') = 'N'
                       and vacm.anno              = P_anno
                      or ( nvl(P_competenza,'N') = 'X'
                       and vacm.anno             = P_anno
                       and to_char(vacm.riferimento,'yyyy') = P_anno
                          )
                         )
                     and vacm.mensilita        != '*AP'
                     and vacm.estrazione        = 'SMT_TAB8A'
                     and vacm.colonna     in ('STIPENDI','IIS','RIA','13A','INDENNITA','RECUPERI')
                     and not exists (select 'x' from smt_periodi
                                      where ci        = CUR_ESTERNI.ci
                                        and anno      = P_anno
                                        and ( nvl(P_competenza,'N') = 'N'
                                          and vacm.anno              = P_anno
/* aggiunto per i tempi di elaborazione */
                                          and vacm.anno between P_anno and P_anno+1 
                                          and vacm.riferimento 
                                              between dal
                                                  and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                           or ( nvl(P_competenza,'N') = 'X'
                                            and vacm.anno             = P_anno
                                            and to_char(vacm.riferimento,'yyyy') = P_anno
                                            and vacm.riferimento 
                                                between dal 
                                                    and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                )
                                              )
                                        )
                     group by vacm.colonna, vacm.riferimento
                  UNION
                  select vacm.colonna colonna, vacm.riferimento
                       , nvl(sum(nvl(vacm.valore,0)),0) importo                
                    from valori_contabili_mensili    vacm
                   where vacm.ci                = cur_esterni.ci
/* aggiunto per i tempi di elaborazione */
                     and vacm.anno between P_anno and P_anno+1 
                     and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                       and nvl(to_number(to_char(p_data_a,'mm')),12)
                     and ( nvl(P_competenza,'N') = 'N'
                       and vacm.anno              = P_anno
                      or ( nvl(P_competenza,'N') = 'X'
                       and vacm.anno             = P_anno+1
                       and to_char(vacm.riferimento,'yyyy') = P_anno
                       and vacm.mese             <= P_fine_mese_liq
                          )
                         )
                     and vacm.mensilita        != '*AP'
                     and vacm.estrazione        = 'SMT_TAB8A'
                     and vacm.colonna           = 'ARRETRATI'
                     and not exists (select 'x' from smt_periodi
                                      where ci        = CUR_ESTERNI.ci
                                        and anno      = P_anno
                                        and ( nvl(P_competenza,'N') = 'N'
                                          and vacm.anno              = P_anno
/* aggiunto per i tempi di elaborazione */
                                          and vacm.anno between P_anno and P_anno+1 
                                          and vacm.riferimento 
                                              between dal
                                                  and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                           or ( nvl(P_competenza,'N') = 'X'
                                            and vacm.anno             = P_anno+1
                                            and to_char(vacm.riferimento,'yyyy') = P_anno
                                            and vacm.mese            <= P_fine_mese_liq
                                            and vacm.riferimento
                                                between dal 
                                                    and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                )
                                              )
                                        )
                     group by vacm.colonna, vacm.riferimento
                  UNION
/* gestione degli arretrati ap */
                  select vacm.colonna colonna, vacm.riferimento
                       , nvl(sum(nvl(vacm.valore,0)),0) importo                
                    from valori_contabili_mensili    vacm
                   where vacm.ci                = cur_esterni.ci
/* aggiunto per i tempi di elaborazione */
                     and vacm.anno between P_anno and P_anno+1 
                     and vacm.mese between nvl(to_number(to_char(p_data_da,'mm')),1)
                                       and nvl(to_number(to_char(p_data_a,'mm')),12)
                     and ( nvl(P_competenza,'N') = 'N'
                       and vacm.anno              = P_anno
                      or ( nvl(P_competenza,'N') = 'X'
                       and vacm.anno             = P_anno
                       and to_char(vacm.riferimento,'yyyy') < P_anno
                       and vacm.mese            >= P_inizio_mese_liq
                        or nvl(P_competenza,'N')= 'X'
                       and vacm.anno             = P_anno+1
                       and to_char(vacm.riferimento,'yyyy') < P_anno
                       and vacm.mese            <= P_fine_mese_liq
                          )
                         )
                     and vacm.mensilita        != '*AP'
                     and vacm.estrazione        = 'SMT_TAB8A'
                     and vacm.colonna           = 'ARRETRATI_AP'
                     and not exists (select 'x' from smt_periodi
                                      where ci        = CUR_ESTERNI.ci
                                        and anno      = P_anno
                                        and ( nvl(P_competenza,'N') = 'N'
                                          and vacm.anno              = P_anno
/* aggiunto per i tempi di elaborazione */
                                          and vacm.anno between P_anno and P_anno+1 
                                          and vacm.riferimento 
                                              between dal
                                                  and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                           or ( nvl(P_competenza,'N') = 'X'
                                            and vacm.anno             = P_anno
                                            and to_char(vacm.riferimento,'yyyy') < P_anno
                                            and vacm.mese            >= P_inizio_mese_liq
                                            and vacm.riferimento 
                                                between dal 
                                                    and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                             or nvl(P_competenza,'N')= 'X'
                                            and vacm.anno             = P_anno+1
                                            and to_char(vacm.riferimento,'yyyy') < P_anno
                                            and vacm.mese            <= P_fine_mese_liq
                                            and vacm.riferimento 
                                                between dal 
                                                    and nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                                                )
                                              )
                                        )
                     group by vacm.colonna, vacm.riferimento
                  ) LOOP
-- dbms_output.put_line('ESTERNO1: '||CUR_VACM_EST.colonna||' '||CUR_VACM_EST.importo);
                    V_dal := null;
                    BEGIN
                    select max(dal)
                      into V_dal
                      from smt_periodi
                     where anno             = P_anno
                       and ci               = CUR_ESTERNI.ci
                       and CUR_VACM_EST.riferimento > nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                      ;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                      V_dal := null;
                    END;
                     IF V_dal is not null THEN
                       update smt_importi 
                          set importo = nvl(importo,0) + nvl(CUR_VACM_EST.importo,0)
                        where anno        = P_anno
                          and ci          = CUR_ESTERNI.ci
                          and dal         = V_dal
                          and tabella     = 'T12'
                          and colonna     = CUR_VACM_EST.colonna
                          and exists (select 'x' 
                                        from smt_importi
                                       where ci       = CUR_ESTERNI.ci
                                         and anno     = P_anno
                                         and tabella  = 'T12'
                                         and dal      = V_dal
                                         and colonna  = CUR_VACM_EST.colonna
                                             ); 
-- dbms_output.put_line('Inserimento periodo se manca colonna: '||CUR_ESTERNI.ci||' '||CUR_VACM_EST.colonna);
                            insert into smt_importi
                            (ANNO,CI,GESTIONE,DAL,TABELLA
                            ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                            )
                            select P_anno
                                 , CUR_ESTERNI.ci
                                 , smpe.gestione
                                 , smpe.dal
                                 , 'T12'
                                 , CUR_VACM_EST.colonna
                                 , CUR_VACM_EST.importo
                                 , D_utente
                                 , null
                                 , sysdate
                              from smt_periodi smpe
                            where anno = P_anno
                              and ci = CUR_ESTERNI.ci
                              and dal = V_dal
                              and not exists (select 'x' 
                                                from smt_importi
                                               where ci       = CUR_ESTERNI.ci
                                                 and anno     = P_anno
                                                 and tabella  = 'T12'
                                                 and dal      = V_dal
                                                 and colonna  = CUR_VACM_EST.colonna
                                             ); 
                           commit;
                     ELSE
                       BEGIN
                       select min(dal)
                         into V_dal
                         from smt_periodi
                        where anno             = P_anno
                          and ci               = CUR_ESTERNI.ci
                          and CUR_VACM_EST.riferimento < nvl(al,nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')))
                         ;
                       EXCEPTION WHEN NO_DATA_FOUND THEN
                         V_dal := null;
                       END;
                     IF V_dal is not null THEN
                        update smt_importi 
                          set importo = nvl(importo,0) + nvl(CUR_VACM_EST.importo,0)
                        where anno        = P_anno
                          and ci          = CUR_ESTERNI.ci
                          and dal         = V_dal
                          and tabella     = 'T12'
                          and colonna     = CUR_VACM_EST.colonna
                          and exists (select 'x' 
                                        from smt_importi
                                       where ci       = CUR_ESTERNI.ci
                                         and anno     = P_anno
                                         and tabella  = 'T12'
                                         and dal      = V_dal
                                         and colonna  = CUR_VACM_EST.colonna
                                             ); 
-- dbms_output.put_line('Inserimento periodo se manca colonna: '||CUR_ESTERNI.ci||' '||CUR_VACM_EST.colonna);
                            insert into smt_importi
                            (ANNO,CI,GESTIONE,DAL,TABELLA
                            ,COLONNA,IMPORTO,UTENTE,TIPO_AGG,DATA_AGG
                            )
                            select P_anno
                                 , CUR_ESTERNI.ci
                                 , smpe.gestione
                                 , smpe.dal
                                 , 'T12'
                                 , CUR_VACM_EST.colonna
                                 , CUR_VACM_EST.importo
                                 , D_utente
                                 , null
                                 , sysdate
                              from smt_periodi smpe
                            where anno = P_anno
                              and ci = CUR_ESTERNI.ci
                              and dal = V_dal
                              and not exists (select 'x' 
                                                from smt_importi
                                               where ci       = CUR_ESTERNI.ci
                                                 and anno     = P_anno
                                                 and tabella  = 'T12'
                                                 and dal      = V_dal
                                                 and colonna  = CUR_VACM_EST.colonna
                                             ); 
                          commit;
                         ELSE
                           V_dal := null;
-- non dovrebbe essere un caso esistente, trattasi di dipendente senza smt_periodi
                           commit;
                         END IF ; -- dal successivo
                    END IF; -- dal precedente
                   END LOOP; -- CUR_VACM_EST  
                END;
              END LOOP; --cur_esterni
             END;
            END LOOP; -- cur_ci1
            END ESTERNI;
       END;
 COMMIT;
 END TABELLA_12;
 END IF;
END;
END;
END;
/
