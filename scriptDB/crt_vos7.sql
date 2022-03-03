create table VOCI_INPDAP (
contratto_gp4 varchar2(4),
voce_gp4      varchar2(10),
sub_gp4       varchar2(2),
dal           date,
al            date,
codice        varchar2(4),
note          varchar2(2000)
);
create unique index idx_vos7 on voci_inpdap(contratto_gp4,voce_gp4,sub_gp4,dal);
