-- Modifiche alla strutura di NORMATIVA_VOCE
-- Add/modify columns 
alter table normativa_voce add NOVO_ID NUMBER(10);
alter table normativa_voce add LIVELLO VARCHAR2(4) default '%' not null;
alter table normativa_voce add RUOLO VARCHAR2(4) default '%' not null;
alter table normativa_voce add TIPO_RAPPORTO VARCHAR2(4) default '%' not null;
alter table normativa_voce add FIGURA VARCHAR2(8) default '%' not null;
alter table normativa_voce add POSIZIONE VARCHAR2(4) default '%' not null;
alter table normativa_voce add DI_RUOLO VARCHAR2(2) default '%' not null;
alter table normativa_voce add TEMPO_DETERMINATO VARCHAR2(2) default '%' not null;
alter table normativa_voce add PART_TIME VARCHAR2(2) default '%' not null;

update normativa_voce set novo_id=rownum;

alter table normativa_voce modify NOVO_ID NUMBER(10) not null;
-- Create/Recreate indexes 
create index NOVO_IK on NORMATIVA_VOCE (VOCE);
drop index NOVO_PK;
create unique index NOVO_PK on NORMATIVA_VOCE (NOVO_ID);

drop sequence NOVO_SQ
;

DECLARE
D_valore1   number(10);
D_valore2   number(10);
V_comando   varchar2(200);
BEGIN
-- creazione della sequence con un pl/sql per evitare errori di connessione ORA-01017
-- durante l'esecuzione degli script successivi
-- in particolare la definizione delle grant dal vortale
  BEGIN
    select nvl(max(NOVO_ID),0)
         , nvl(max(NOVO_ID),0)+1
      into D_valore1, D_valore2
      from NORMATIVA_VOCE
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     D_valore1   := 0;
     D_valore2   := 0;
  END;

  V_comando := 'CREATE SEQUENCE NOVO_SQ INCREMENT BY 1 START WITH '||D_valore2||'  MINVALUE 1 MAXVALUE 9999999999 NOCYCLE  CACHE 2 NOORDER ';
-- dbms_output.put_line(V_comando);
  si4.sql_execute(V_comando);
END;
/

start crp_gp4ec.sql
start crp_peccmoco.sql

--aggiorna il codice di errore

update a_errori
   set descrizione = 'Normativa voce non prevista per le caratteristiche giuridiche attuali'        
 where errore = 'P05690';


delete from a_guide_o where guida_o = 'P_NOVO';

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v, voce_menu,voce_rif) 
values ('P_NOVO','1','VOCO','V','Voci','P_VOCO', '','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v, voce_menu,voce_rif) 
values ('P_NOVO','2','CONT','C','Contratti','', 'PGMDCONT','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v, voce_menu,voce_rif) 
values ('P_NOVO','3','QUGI','Q','Qualifica','', 'PGMDQUAL','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v, voce_menu,voce_rif) 
values ('P_NOVO','4','FIGI','F','Figure','', 'PGMDFIGU','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v, voce_menu,voce_rif) 
values ('P_NOVO','5','TIRA','T','Tipi rap.','', 'PGMDTIRA','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v, voce_menu,voce_rif) 
values ('P_NOVO','6','POSI','P','Posizione','', 'PGMDPOSI','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v, voce_menu,voce_rif) 
values ('P_NOVO','7','RUOL','R','Ruoli','', 'PGMDRUOL','');
