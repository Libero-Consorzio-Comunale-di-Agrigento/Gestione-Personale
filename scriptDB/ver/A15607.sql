-- Attività 15607

start crq_prin.sql

alter table PREMI_INAIL add  PRIN_ID number(10); 

update premi_inail set prin_id=prin_sq.nextval;

alter table PREMI_INAIL modify PRIN_ID number(10) not null;

create unique index prin_pk on premi_inail (prin_id);

start crf_premi_inail_tiu.sql

start crp_peccalpi.sql

