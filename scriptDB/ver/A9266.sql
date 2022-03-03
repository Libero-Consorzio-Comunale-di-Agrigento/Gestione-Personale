INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA ) 
select 'DENUNCIA_CUD', 'PREV_13',  To_Date( '01/01/2003', 'MM/DD/YYYY'), NULL
, 'Casella 55 - INPS ( Bonus L243 )', 53
from dual 
where not exists ( select 'x' from estrazione_valori_contabili
                    where estrazione = 'DENUNCIA_CUD'
                      and colonna = 'PREV_13'
                      and al is null );
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA ) 
select 'DENUNCIA_CUD', 'PREV_14',  TO_Date( '01/01/2003', 'MM/DD/YYYY'), NULL
, 'Casella 103 INPDAP - Contr. Sospesi 2002', 54
from dual 
where not exists ( select 'x' from estrazione_valori_contabili
                    where estrazione = 'DENUNCIA_CUD'
                      and colonna = 'PREV_14'
                      and al is null ); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA ) 
select 'DENUNCIA_CUD', 'PREV_15',  TO_Date( '01/01/2003', 'MM/DD/YYYY'), NULL
, 'Casella 104 INPDAP - Contr. Sospesi 2003', 55
from dual 
where not exists ( select 'x' from estrazione_valori_contabili
                    where estrazione = 'DENUNCIA_CUD'
                      and colonna = 'PREV_15'
                      and al is null ); 

INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA ) 
select 'DENUNCIA_CUD', 'PREV_16',  TO_Date( '01/01/2003', 'MM/DD/YYYY'), NULL
, 'Casella 105 INPDAP - Contr. Sospesi 2004', 56
from dual 
where not exists ( select 'x' from estrazione_valori_contabili
                    where estrazione = 'DENUNCIA_CUD'
                      and colonna = 'PREV_16'
                      and al is null ); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA ) 
select 'DENUNCIA_CUD', 'TFR_139',  TO_Date( '01/01/2003', 'MM/DD/YYYY'), NULL
, 'Appoggio per Annotazione N11 . CUD 2004', 99
from dual 
where not exists ( select 'x' from estrazione_valori_contabili
                    where estrazione = 'DENUNCIA_CUD'
                      and colonna = 'TFR_139'
                      and al is null ); 

start crp_peccarfi.sql
