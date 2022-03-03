DECLARE

V_dal date;

BEGIN
select max(dal) 
  into V_dal
  from estrazione_valori_contabili
 where estrazione = 'SMT_TAB8A';

  IF V_dal < to_date('01012002','ddmmyyyy') THEN
   INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE,
               DESCRIZIONE_AL1, DESCRIZIONE_AL2, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
   select ESTRAZIONE
          , COLONNA
          , to_date('01012002','ddmmyyyy')
          , null
          , DESCRIZIONE
          , DESCRIZIONE_AL1
          , DESCRIZIONE_AL2
          , SEQUENZA
          , NOTE
          , MOLTIPLICA
          , ARROTONDA
          , DIVIDE
     from estrazione_valori_contabili
    where estrazione = 'SMT_TAB8A'
      and dal = V_dal;
    update estrazione_valori_contabili
       set al = to_date('31122001','ddmmyyyy')
    where estrazione = 'SMT_TAB8A'
      and dal = V_dal;
   INSERT INTO ESTRAZIONE_RIGHE_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, SEQUENZA, VOCE, SUB, TIPO,
               ANNO, SEGNO1, DATO1, SEGNO2, DATO2 )
   select ESTRAZIONE
          , COLONNA
          , to_date('01012002','ddmmyyyy')
          , null
          , SEQUENZA
          , VOCE
          , SUB
          , TIPO
          , ANNO
          , SEGNO1
          , DATO1
          , SEGNO2
          , DATO2
     from estrazione_righe_contabili
    where estrazione = 'SMT_TAB8A'
      and dal = V_dal;
    update estrazione_righe_contabili
       set al = to_date('31122001','ddmmyyyy')
    where estrazione = 'SMT_TAB8A'
      and dal = V_dal;
    commit;
END IF;
   update estrazione_valori_contabili esvc
      set colonna = 'ARRETRATI_AP'
        , descrizione = descrizione||' Anni Prec.'
    where estrazione = 'SMT_TAB8A'
      and dal >= to_date('01012002','ddmmyyyy')
      and colonna = 'ARRETRATI'
      and not exists (select 'x' 
                        from estrazione_valori_contabili
                       where estrazione = esvc.estrazione
                         and dal = esvc.dal
                         and colonna = 'ARRETRATI_AP')
    ;
   update estrazione_righe_contabili esrc
      set colonna = 'ARRETRATI_AP'
    where estrazione = 'SMT_TAB8A'
      and dal >= to_date('01012002','ddmmyyyy')
      and colonna = 'ARRETRATI'
      and not exists (select 'x' 
                        from estrazione_righe_contabili
                       where estrazione = esrc.estrazione
                         and dal = esrc.dal
                         and colonna = 'ARRETRATI_AP')
    ;
   INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA)
   select 'SMT_TAB8A', 'ARRETRATI',  to_date('01012002','ddmmyyyy'), NULL, 'Arretrati A.C.', 5
     from dual
   where not exists (select 'x' 
                        from estrazione_valori_contabili
                       where estrazione = 'SMT_TAB8A'
                         and dal >= to_date('01012002','ddmmyyyy')
                         and colonna = 'ARRETRATI')
   ;
   commit;
END;
/