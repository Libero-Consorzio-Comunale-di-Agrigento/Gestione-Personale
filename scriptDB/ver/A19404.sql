-- Migliorie a calcolo autoliquidazione

alter table CALCOLI_RETRIBUZIONI_INAIL modify FUNZIONALE VARCHAR2(8);
alter table CALCOLI_RETRIBUZIONI_INAIL add ARRETRATO VARCHAR2(1);
comment on column CALCOLI_RETRIBUZIONI_INAIL.ARRETRATO is 'C=competenza , A= Arretrato';

start crv_vipm.sql

start crp_peccrein.sql


























