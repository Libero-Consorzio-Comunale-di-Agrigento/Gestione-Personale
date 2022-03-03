start crp_peccpere3.sql

create table pere_15513 as select * from periodi_retributivi
where to_char(periodo,'yyyy') = 2006
and to_char(al,'yyyy') = 2006;

create table pere_temp_stinp as select * from periodi_retributivi
where to_char(periodo,'yyyy') = 2006
and to_char(al,'yyyy') = 2006;

create table moco_15513 as select * from movimenti_contabili 
where anno = 2006
and voce in (Select codice from voci_economiche where automatismo = 'ST_INP');

-- SISTEMA SETTIMANE INPS

BEGIN -- Ricalcolo settimane INPS
 declare domenica      date;
         sabato        date;
         d_settimane   number(2);
         P_anno        number(4) := 2006;
         P_ini_ela     date := to_date('01012006','ddmmyyyy');
         P_fin_ela     date := to_date('31012006','ddmmyyyy');
 BEGIN
 FOR CUR_CI in 
    ( select distinct ci
        from movimenti_fiscali
       where anno = 2006
         and mese = 1
         and mensilita not in ( '*AP' , '*R*' )
    ) LOOP 
 BEGIN
 FOR CUR_PERE IN
     (select rowid, dal, al, servizio, competenza
        from periodi_retributivi
       where ci = CUR_CI.ci
         and periodo = P_fin_ela
         and last_day(al) = P_fin_ela
         and servizio = 'Q'
         and competenza in ('A','C')
         and gg_inp != 0
         and st_inp = 0
       order by al
     ) LOOP
    BEGIN
    domenica := gp4ec.get_next_day(last_day(add_months(CUR_PERE.al,-1))-7,'sunday','AMERICAN');
    sabato := gp4ec.get_next_day(last_day(add_months(CUR_PERE.al,-1))-1,'saturday','AMERICAN');
    d_settimane := 0;
    WHILE domenica <=  P_fin_ela 
LOOP
     BEGIN
      select d_settimane + 1
        into d_settimane
        from dual x
       where exists
            (select 'x' from periodi_giuridici pegi
              where greatest(pegi.dal,P_ini_ela) <= least(sabato,P_fin_ela)
                and CUR_PERE.al >= domenica
                and pegi.ci = CUR_CI.ci
                and pegi.rilevanza = 'S'
                and CUR_PERE.al between pegi.dal
                                    and least(nvl(last_day(pegi.al),P_fin_ela),P_fin_ela)
            )
         and not exists
            (select 'x' from periodi_retributivi p,
                             periodi_giuridici   g
              where greatest(g.dal,to_date(to_char(p.periodo,'yyyymm'),'yyyymm'))
                 <= least(sabato,P_fin_ela)
                and p.al >= domenica
                and least(p.al,P_fin_ela) < CUR_PERE.al
                and p.periodo in (P_fin_ela, add_months(P_fin_ela,-1))
                and p.servizio= 'Q'
                and p.competenza in ('C','A')
                and p.ci = CUR_CI.ci
                and g.ci = p.ci
                and g.rilevanza = 'S'
                and p.al between g.dal
                             and least(nvl(g.al,P_fin_ela),P_fin_ela)
                and to_char(sabato,'yyyy') = to_char(domenica,'yyyy')
            )
      ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN null;
     END;
     domenica := (sabato + 1);
     sabato   := (sabato + 7);
    END LOOP;
    update periodi_retributivi
       set st_inp     = nvl(d_settimane,0)
       where ci = CUR_CI.ci
         and periodo = P_fin_ela
         and al = CUR_PERE.al
         and servizio = 'Q'
         and competenza in ('A','C')
         and rowid      = CUR_PERE.rowid
     ;
   END;
  END LOOP; -- CUR_PERE
 END;
END LOOP; -- CUR_CI
END;
END;
/

-- SISTEMA SETTIMANE INPS IN CONGUAGLIO - FEB 2006 / MAR 2006 / APR 2006 / MAG 2006 / GIU 2006

    update periodi_retributivi pere
       set st_inp = ( select st_inp * -1
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
                         and servizio = pere.servizio
                    )
     where last_day(al) = to_date('31012006','ddmmyyyy') 
       and servizio = 'Q'
       and competenza = 'P'
       and gg_inp != 0
       and st_inp = 0
       and periodo = to_date('28022006','ddmmyyyy') 
       and exists  ( select 'X'
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
--                         and last_day(al) = last_day(pere.al)
                         and servizio = pere.servizio
                    )
/
    update periodi_retributivi pere
       set st_inp = ( select st_inp * -1
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
                         and servizio = pere.servizio
                    )
     where last_day(al) = to_date('31012006','ddmmyyyy') 
       and servizio = 'Q'
       and competenza = 'P'
       and gg_inp != 0
       and st_inp = 0
       and periodo = to_date('31032006','ddmmyyyy') 
       and exists  ( select 'X'
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
 --                        and last_day(al) = last_day(pere.al)
                         and servizio = pere.servizio
                    )
/
    update periodi_retributivi pere
       set st_inp = ( select st_inp * -1
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
                         and servizio = pere.servizio
                    )
     where last_day(al) = to_date('31012006','ddmmyyyy') 
       and servizio = 'Q'
       and competenza = 'P'
       and gg_inp != 0
       and st_inp = 0
       and periodo = to_date('30042006','ddmmyyyy') 
       and exists  ( select 'X'
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
--                         and last_day(al) = last_day(pere.al)
                         and servizio = pere.servizio
                    )
/
    update periodi_retributivi pere
       set st_inp = ( select st_inp * -1
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
                         and servizio = pere.servizio
                    )
     where last_day(al) = to_date('31012006','ddmmyyyy') 
       and servizio = 'Q'
       and competenza = 'P'
       and gg_inp != 0
       and st_inp = 0
       and periodo = to_date('31052006','ddmmyyyy') 
       and exists  ( select 'X'
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
--                         and last_day(al) = last_day(pere.al)
                         and servizio = pere.servizio
                    )
/
    update periodi_retributivi pere
       set st_inp = ( select st_inp * -1
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
                         and servizio = pere.servizio
                    )
     where last_day(al) = to_date('31012006','ddmmyyyy') 
       and servizio = 'Q'
       and competenza = 'P'
       and gg_inp != 0
       and st_inp = 0
       and periodo = to_date('30062006','ddmmyyyy') 
       and exists  ( select 'X'
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = to_date('31012006','ddmmyyyy') 
                         and competenza IN ( 'C','A' )
                         and st_inp != 0
                         and al = pere.al
--                         and last_day(al) = last_day(pere.al)
                         and servizio = pere.servizio
                    )
/

-- INSERISCE VOCE ST_INP in MOVIMENTI_CONTABILI

BEGIN
for CUR_DATI IN 
( select ci, periodo, al, st_inp
     , qualifica,tipo_rapporto, ore
  from periodi_retributivi new
 where periodo >= to_date('31012006','ddmmyyyy') 
   and competenza in ('A','C','P')
 minus
 select ci, periodo, al, st_inp
     , qualifica,tipo_rapporto, ore
  from PERE_TEMP_STINP
 where periodo >= to_date('31012006','ddmmyyyy') 
   and competenza in ('A','C','P')
) LOOP
INSERT INTO MOVIMENTI_CONTABILI
( anno, mese, mensilita, ci, voce, sub, riferimento, arr, input, qualifica, tipo_rapporto, ore, qta )
SELECT to_char(CUR_DATI.periodo,'yyyy') 
     , to_char(CUR_DATI.periodo,'mm') 
     , mofi.mensilita
     , CUR_DATI.ci
     , voec.codice, '*'
     , CUR_DATI.al
     , DECODE( TO_CHAR(CUR_DATI.periodo,'yyyymm') , TO_CHAR(CUR_DATI.al,'yyyymm'), NULL, 'C')
     , 'C'
     , CUR_DATI.qualifica, CUR_DATI.tipo_rapporto, CUR_DATI.ore
     , CUR_DATI.st_inp
 FROM VOCI_ECONOMICHE voec
    , movimenti_fiscali mofi
WHERE voec.automatismo = 'ST_INP'  
  and mofi.ci = CUR_DATI.ci
  and mofi.anno = to_char(CUR_DATI.periodo,'yyyy')
  and mofi.mese = to_char(CUR_DATI.periodo,'mm') 
  and mofi.mensilita in ( select mensilita
                            from mensilita 
                           where mese = to_char(CUR_DATI.periodo,'mm') 
                             and tipo = 'N')
  and not exists (Select 'x' from movimenti_contabili
                   where anno = to_char(CUR_DATI.periodo,'yyyy') 
                     and mese = to_char(CUR_DATI.periodo,'mm') 
                     and mensilita = mofi.mensilita
                     and ci = CUR_DATI.ci
                     and voce = voec.codice
                     and sub = '*'
                     and riferimento = CUR_DATI.al
                     and qta = CUR_DATI.st_inp
                  )
;
END LOOP;
END;
/


-- CONTROLLO SU PERE (deve dare no rows)

select 'UNO', ci, to_char(al,'mmyyyy') , sum(gg_inp), sum(st_inp)
from periodi_retributivi
where to_char(al,'yyyy') = '2006'
and periodo >= to_date('31012006','ddmmyyyy')
and competenza in ('A','C','P')
group by  ci, to_char(al,'mmyyyy')
having sum(gg_inp) != 0 and sum(st_inp) = 0
UNION
select 'DUE', ci, to_char(al,'mmyyyy') , sum(gg_inp), sum(st_inp)
from periodi_retributivi
where to_char(al,'yyyy') = '2006'
and periodo >= to_date('31012006','ddmmyyyy')
and competenza in ('A','C','P')
group by  ci, to_char(al,'mmyyyy')
having sum(gg_inp) = 0 and sum(st_inp) != 0
UNION
select 'TRE', ci, to_char(al,'mmyyyy') , sum(gg_inp), sum(st_inp)
from periodi_retributivi
where to_char(al,'yyyy') = '2006'
and periodo >= to_date('31012006','ddmmyyyy')
and competenza in ('A','C','P')
group by  ci, to_char(al,'mmyyyy')
having sum(st_inp) > 5
/
