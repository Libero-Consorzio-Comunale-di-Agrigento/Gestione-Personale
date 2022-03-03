start crp_PECCSMFC.sql
start crp_pecsmdsi.sql

INSERT INTO ESTRAZIONE_REPORT 
( ESTRAZIONE, DESCRIZIONE, SEQUENZA, OGGETTO, NUM_RIC,NOTE ) 
SELECT 'DENUNCIA_SOSTITUTI', 'Modello di Dichiarazione per Sostituti Imposta', 100, 'RAGI', 0, 'PECSMDSI - PECL70SC'
  from dual
 where not exists ( select 'x'
                     from ESTRAZIONE_REPORT
                    where estrazione = 'DENUNCIA_SOSTITUTI'
                 ); 

INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
SELECT 'DENUNCIA_SOSTITUTI', 'NO_CONV', TO_Date( '01/01/2000', 'MM/DD/YYYY')
, NULL, 'Somme soggette a ritenuta per regime convenzionale', 6, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x'
                     from ESTRAZIONE_VALORI_CONTABILI 
                    where estrazione = 'DENUNCIA_SOSTITUTI'
                     and colonna = 'NO_CONV'
                      and dal = TO_Date( '01/01/2000', 'MM/DD/YYYY')
                 );
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
SELECT 'DENUNCIA_SOSTITUTI', 'RIT_SOSP',  TO_Date( '01/01/2000', 'MM/DD/YYYY')
, NULL, 'Ritenute sospese', 7, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x'
                     from ESTRAZIONE_VALORI_CONTABILI 
                    where estrazione = 'DENUNCIA_SOSTITUTI'
                      and colonna = 'RIT_SOSP'
                      and dal = TO_Date( '01/01/2000', 'MM/DD/YYYY')
                 );
BEGIN
DECLARE
V_conta number(3) := 0;
V_sequenza number(3) := 0;
BEGIN
   FOR CUR_VOCE IN 
       ( select distinct covo.voce, covo.sub , voec.tipo, covo.somme, covo.fiscale
           from contabilita_voce covo
              , voci_economiche voec
          where to_date('01122005','ddmmyyyy')
                between nvl(covo.dal,to_date('2222222','j')) and nvl(covo.al,to_date('3333333','j'))
            and covo.somme in ('10', '16') 
            and voec.codice = covo.voce
       ) LOOP
      BEGIN
      V_sequenza := nvl(V_sequenza,0) + 1;
      INSERT INTO ESTRAZIONE_RIGHE_CONTABILI 
      ( ESTRAZIONE, COLONNA, DAL, AL, SEQUENZA, VOCE, SUB, TIPO, SEGNO1, DATO1 ) 
       select 'DENUNCIA_SOSTITUTI'
            , decode( cur_voce.somme
                    , '10', 'NO_CONV'
                    , '16', 'RIT_SOSP'
                    )
            , to_date('01012000','ddmmyyyy')
            , null
            , V_sequenza
            , CUR_VOCE.voce
            , CUR_VOCE.sub
            , 'P'
            , decode( CUR_VOCE.tipo, 'T', '*', null)
            , decode( CUR_VOCE.tipo, 'T', -1 , null)
        from dual;
     commit;
      END;
    END LOOP; -- cur_voce
END;
END;
/