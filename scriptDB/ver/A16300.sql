start crp_PECCSMFC.sql

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
SELECT 'DENUNCIA_SOSTITUTI', 'SPESE_RIMB', TO_Date( '01/01/2000', 'MM/DD/YYYY')
, NULL, 'Spese Rimborsate', 8, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x'
                     from ESTRAZIONE_VALORI_CONTABILI 
                    where estrazione = 'DENUNCIA_SOSTITUTI'
                     and colonna = 'SPESE_RIMB'
                      and dal = TO_Date( '01/01/2000', 'MM/DD/YYYY')
                 );