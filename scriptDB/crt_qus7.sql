create table QUALIFICHE_INPDAP (
contratto_gp4 varchar2(4),
qualifica_gp4 varchar2(8),
dal           date,
al            date,
codice        varchar2(4),
mansione      varchar2(30),
note          varchar2(2000)
);
create unique index idx_qus7 on qualifiche_inpdap(contratto_gp4,qualifica_gp4,dal);