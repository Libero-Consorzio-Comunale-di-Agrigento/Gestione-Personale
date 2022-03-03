alter table dotazione_organica add(door_id number(10));

-- start crq_door.sql
col C2 noprint format 9999999999 new_value P2
select nvl(max(door_id),0) mnf 
      ,nvl(max(door_id),0)+1 C2 
  from dotazione_organica  
;
DROP SEQUENCE door_sq
;
CREATE SEQUENCE door_sq
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
; 

DROP index DOTAZIONE_ORGANICA_PK;

update dotazione_organica
set door_id = door_sq.NEXTVAL;

create unique index DOTAZIONE_ORGANICA_PK
on DOTAZIONE_ORGANICA (
   REVISIONE ASC,
   DOOR_ID ASC
);

start crt_grdo.sql
start crt_rgdo.sql
start crt_rigd.sql
start crq_rigd.sql
start crq_rgdo.sql 

alter table ente add(MODIFICHE_DO VARCHAR2 (2), PERC_GRLI_I NUMBER (5,2),PERC_GRLI_D NUMBER (5,2), 
  		     PERC_GRLI_L  NUMBER (5,2));

alter table gestioni add(CONTROLLI_DO_GRLI VARCHAR2 (1), SOSTITUZIONI_NON_RUOLO  VARCHAR2 (2), GG_SOST_ANTE_ASSENZA    NUMBER (3), 
  		         GG_SOST_POST_ASSENZA    NUMBER (3), ORE_DO VARCHAR2 (1));

update gestioni set ore_do='O';

start crp_gp4_ente.sql
