connect cf4/cf4@si4

-- GRANT SELECT ON BILANCIO TO P00 with grant option;
GRANT SELECT ON DELIBERE TO P00 with grant option;
GRANT SELECT ON GP4_SOGGETTI TO P00 with grant option;
GRANT SELECT ON GP4_CAP TO P00 with grant option;
GRANT SELECT ON GP4_IMP_ACC TO P00 with grant option;
GRANT SELECT ON GP4_QUIETANZE TO P00 with grant option;
GRANT SELECT ON GP4_SUBIMP TO P00 with grant option;

conn p00/p00@si4

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

CREATE SYNONYM CAPITOLI_CONTABILITA FOR CF4.GP4_CAP;
CREATE SYNONYM ACC_IMP_CONTABILITA FOR CF4.GP4_IMP_ACC;
-- CREATE SYNONYM BILANCIO FOR CF4.BILANCIO;
CREATE SYNONYM SOGGETTI FOR CF4.GP4_SOGGETTI;
CREATE SYNONYM QUIETANZE_CONTABILITA FOR CF4.GP4_QUIETANZE;
CREATE SYNONYM SUBIMP_CONTABILITA FOR CF4.GP4_SUBIMP;
create or replace view delibere 
as select  SEDE,  ANNO,  NUMERO ,  DATA  
        , ' ' OGGETTO
        , DESCRIZIONE 
        , ' ' ESECUTIVITA
        , TIPO_ESE 
        , ' ' NUMERO_ESE 
        ,  to_date(null) DATA_ESE  
        , ' ' NOTE
from cf4.delibere;

alter function controlla_oggetti_cf4 compile;

grant all on imputazioni_contabili to cf4;
connect cf4/cf4@SI4
create synonym imputazioni_contabili for p00.imputazioni_contabili;
conn p00/p00@si4

