CREATE OR REPLACE PACKAGE PECSMT7S IS
/******************************************************************************
 NOME:          PECSMT7S
 DESCRIZIONE:   Pre-elaborazione dei dati riguardanti gli scioperi tabella 7
                Statistiche Ministero del Tesoro.
                Questa fase prepara le righe di stampa della parte rigurdante gli
                scioperi della tabella 7 delle Statistiche del Ministero del Tesoro.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Il PARAMETRO D_anno indica l'anno di riferimento dell'elaborato.
               Il PARAMETRO D_gestione      indica quale gestione deve essere elaborata
               (% = tutte).
               Il PARAMETRO D_tot           indica se deve essere generato un totale
               generale.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003
 2    08/03/2004 MV     Revisione SMT 2004
 3    03/05/2005 CB     Revisione SMT 2005 
 3.1  16/05/2005 MS     Mod. per Att. 10853.1
 3.2  30/05/2005 MS     Mod. per Att. 10275.3
 3.3  06/04/2006 MS     Mod. per cambio gestione assenze ( att. 15597 )
 4.0  15/05/2007 CB     A20817
 4.1  11/06/2007 MS     Mod. controlli per categoria SUPAN ( att. 21575 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMT7S IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V4.1 del 11/06/2007';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS

BEGIN 

DECLARE

 P_anno       number(4);
 P_ini_a      varchar2(8);
 P_fin_a      varchar2(8);
 P_comparto   varchar2(10);
 P_gestione   varchar2(4);
 P_tot        varchar2(1);
 P_ppa        varchar2(1);
 ESCI         EXCEPTION;
 P_data_da    date;
 P_data_a     date;

BEGIN

  select substr(valore,1,4)  D_gestione
    into P_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_GESTIONE'
  ;
  BEGIN
  select substr(valore,1,10)  D_comparto
    into P_comparto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_COMPARTO'
  ;
EXCEPTION WHEN NO_DATA_FOUND THEN
    P_comparto := '%';
END;

BEGIN
  select substr(valore,1,1)  D_tot
    into P_tot
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_TOT'
  ;
EXCEPTION WHEN NO_DATA_FOUND THEN
    P_tot := null;
END;

BEGIN
    select to_date(valore,'dd/mm/yyyy')
      into P_data_a
      from a_parametri
     where no_prenotazione=prenotazione
       and parametro='P_DATA_A'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    P_data_a := null;
  END;
  BEGIN
    select to_date(valore,'dd/mm/yyyy')
      into P_data_da
      from a_parametri
     where no_prenotazione=prenotazione
       and parametro='P_DATA_DA'
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
                 ('01'||nvl(P_anno,anno),'mmyyyy')
                ,'ddmmyyyy')                               
       , to_char(to_date
                 ('3112'||nvl(P_anno,anno),'ddmmyyyy')
                ,'ddmmyyyy')                               
       , nvl(P_anno,anno)                               
    into P_ini_a, P_fin_a, P_anno
   from riferimento_fine_anno
   where rifa_id = 'RIFA'
  ;
END;
BEGIN
  select 'x' 
    into P_ppa
    from ente
   where nvl(assenze,'NO') = 'SI';
  EXCEPTION when NO_DATA_FOUND then raise ESCI;
END; 
DECLARE 
  
  P_pagina number;
  P_riga   number;
  P_gg_m   number;
  P_gg_f   number;
  P_m      number;
  P_f      number;
  P_gg     number;
  P_dep_ci number;
 
  BEGIN

  P_pagina := 1;
  P_riga   := 1;
  P_gg_m   := 0;
  P_gg_f   := 0;
  P_m      := 0;
  P_f      := 0;
  P_gg     := 0;

  FOR GEST IN
     (select codice  codice
           , 0       ord
        from gestioni gest
       where codice like nvl(P_gestione,'%')
         and gestito = 'SI'
         and exists (select 'x' from smt_individui 
                      where anno = P_anno
                        and gestione = gest.codice
                     union
                     select 'x' from smt_periodi
                      where anno = P_anno
                        and gestione = gest.codice
                     )
       union
      select P_gestione  codice
           , 1       ord
        from dual
       where P_tot = 'X'
       order by 2
     ) LOOP
         BEGIN
           P_gg_m   := 0;
           P_gg_f   := 0;
           P_m      := 0;
           P_f      := 0;
           P_gg     := 0;
             FOR QUMI IN
                (select descrizione
                      , codice
                   from qualifiche_ministeriali qumi
                  where nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy')) between qumi.dal and nvl(qumi.al,to_date('3333333','j'))
                    and nvl(comparto,'%') like nvl(P_comparto,'%')
                  order by sequenza
                ) LOOP

               FOR CURS IN
                  (select smpe.gestione
                        , smpe.ci                         ci
                        , smin.sesso                      sesso
                        , nvl(cost.ore_gg,6)              ore_gg
                        , decode( nvl(length(translate( substr(substr(esvc.note , instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1) +1
                                               , instr(esvc.note,'>',  instr(esvc.note,cost.contratto)) -1 - instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1)
                                        ),instr(substr(esvc.note , instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1) +1
                                               , instr(esvc.note,'>',  instr(esvc.note,cost.contratto)) -1 - instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1)
                                        ),':')+1)
                                                , 'a123456789.','a')),0)
                                ,0 , substr(substr(esvc.note , instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1) +1
                                               , instr(esvc.note,'>',  instr(esvc.note,cost.contratto)) -1 - instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1)
                                        ),instr(substr(esvc.note , instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1) +1
                                               , instr(esvc.note,'>',  instr(esvc.note,cost.contratto)) -1 - instr(esvc.note,'<',  instr(esvc.note,cost.contratto)-1)
                                        ),':')+1)
                                   ,'') ore_gg_1
                     from smt_periodi                  smpe
                        , smt_individui                smin
                        , contratti_storici            cost  
                        , rapporti_giuridici           ragi
                        , estrazione_valori_contabili   esvc
                    where smpe.dal = 
                         (select max(dal) from smt_periodi
                           where ci        = smpe.ci
                             and anno      = P_anno
                             and dal      <= nvl(P_data_a,to_date(P_fin_a,'ddmmyyyy') )    
                             and nvl(al,to_date('3333333','j')) >= 
                                 nvl(P_data_da,to_date(P_ini_a,'ddmmyyyy'))
                         )
                      and esvc.ESTRAZIONE ='SMT_TAB7S'
                      and esvc.colonna         in ('SCI_ORE')
                      and nvl(smpe.al,to_date('3333333','j')) between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
                      and smin.ci = smpe.ci
                      and smin.ci = ragi.ci
                      and smin.anno = smpe.anno
                      and smin.anno = P_anno
                      and smin.gestione = smpe.gestione
                      and smpe.gestione      like GEST.codice
                      and smpe.qualifica       = QUMI.codice
                      and ( smpe.TEMPO_DETERMINATO='NO' or smpe.categoria in ('DIREL','DIRSAN','SUPAN') )
                      and nvl(smpe.universitario,'NO') ='NO'
                      and nvl(smin.est_comandato,'NO') ='NO'
                      and cost.contratto (+)   = ragi.contratto
                      and cost.dal = 
                         (select max(dal) from contratti_storici
                           where contratto = cost.contratto
                             and dal <= to_date(P_fin_a,'ddmmyyyy')
                             and dal <= nvl(smpe.al,to_date('3333333','j'))
                             and nvl(al,to_date('3333333','j')) >= smpe.dal)
                  ) LOOP
                      BEGIN
                        select sum(decode( vaca.colonna
                                         , 'SCI_GG', vaca.valore
                                                   , 0) +
                                   decode( vaca.colonna
                                         , 'SCI_ORE', round(vaca.valore 
                                                           /nvl(CURS.ore_gg_1,CURS.ore_gg),2)
                                                    , 0)) 
                          into P_gg
                          from valori_contabili_annuali     vaca
                         where vaca.anno             = P_anno
                           and vaca.mese             = 12
                           and vaca.mensilita        = 
                              (select max(mensilita) from mensilita
                                where mese = 12 
                                  and tipo in ('A','N','S'))
                           and vaca.estrazione       = 'SMT_TAB7S'
                           and vaca.colonna         in ('SCI_ORE','SCI_GG')
                           and vaca.ci               = CURS.ci
                        ;

                        IF nvl(P_gg,0) = 0 THEN null ;
                        ELSIF nvl(P_dep_ci,0) = CURS.ci
                              THEN null;
                                ELSIF CURS.sesso = 'M' 
                                 THEN P_m    := P_m + 1;
                                      P_gg_m := P_gg_m + P_gg; 
                                 ELSE P_f    := P_f + 1;
                                      P_gg_f := P_gg_f + P_gg; 
                        END IF; 
                      END;
                      P_dep_ci := CURS.ci;
                    END LOOP; -- curs
                    P_pagina := P_pagina + 1;
                    P_riga   := P_riga   + 1;
                    insert into a_appoggio_stampe
                    (NO_PRENOTAZIONE,NO_PASSO,PAGINA,RIGA,TESTO)
                    select prenotazione
                         , 3
                         , P_pagina
                         , P_riga
                         , rpad(decode(GEST.codice,P_gestione,'*',GEST.codice),4,' ')||
                           rpad(nvl(QUMI.descrizione,' '),45,' ')||
                           rpad(QUMI.codice,6,' ')||
                           lpad(to_char(P_m),5,'0')||     
                           decode(sign(P_gg_m),-1,'-','+')||
                           lpad(to_char(abs(P_gg_m)),8,'0')||     
                           lpad(to_char(P_f),5,'0')||     
                           decode(sign(P_gg_f),-1,'-','+')||
                           lpad(to_char(abs(P_gg_f)),8,'0')     
                      from dual
                    ;
                  P_gg_m   := 0;
                  P_gg_f   := 0;
                  P_m      := 0;
                  P_f      := 0;
                  P_gg     := 0;
                  END LOOP; -- qumi
         END;
       END LOOP; -- gest
  COMMIT;
  END;
exception when ESCI then null;
END;
END;
END;
/
