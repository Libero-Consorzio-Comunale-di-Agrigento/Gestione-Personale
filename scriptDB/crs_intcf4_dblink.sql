
CREATE TABLE DELI_INTCF4_OLD AS SELECT * FROM DELIBERE;

-- drop table bilancio;
drop table soggetti;
drop table delibere;
drop table capitoli_contabilita;
drop table acc_imp_contabilita;
drop table quietanze_contabilita;
drop table subimp_contabilita;

-- drop synonym bilancio;
drop synonym soggetti;
drop synonym delibere;
drop view delibere;
drop synonym capitoli_contabilita;
drop synonym acc_imp_contabilita;
drop synonym quietanze_contabilita;
drop synonym subimp_contabilita;

CREATE SYNONYM CAPITOLI_CONTABILITA FOR GP4_CAP@dbl_cf4;
CREATE SYNONYM ACC_IMP_CONTABILITA FOR GP4_IMP_ACC@dbl_cf4;
-- CREATE SYNONYM BILANCIO FOR BILANCIO@dbl_cf4;
CREATE SYNONYM SOGGETTI FOR GP4_SOGGETTI@dbl_cf4;
CREATE SYNONYM QUIETANZE_CONTABILITA FOR GP4_QUIETANZE@dbl_cf4;
CREATE SYNONYM SUBIMP_CONTABILITA FOR GP4_SUBIMP@dbl_cf4;
create or replace view delibere 
as select  SEDE,  ANNO,  NUMERO ,  DATA  
        , ' ' OGGETTO
        , DESCRIZIONE 
        , ' ' ESECUTIVITA
        , TIPO_ESE 
        , ' ' NUMERO_ESE 
        ,  to_date(null) DATA_ESE  
        , ' ' NOTE
from delibere@dbl_cf4;

-- alter function controlla_oggetti_cf4 compile;
