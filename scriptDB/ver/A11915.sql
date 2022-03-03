DECLARE
V_esiste   varchar2(1);
v_comando  varchar2(100);
BEGIN
BEGIN
  select 'X' 
    into V_esiste 
    from dual
   where exists ( select 'x' from obj 
                   where object_name like '%ANTE_489%'
                );
EXCEPTION WHEN NO_DATA_FOUND THEN V_esiste := '';
END;
IF V_esiste = 'X' THEN NULL;
ELSE
  V_comando := 'create table SEIE_ANTE_489 as select * from settimane_emens';
  si4.sql_execute(V_comando);
  V_comando := 'create table VAIE_ANTE_489 as select * from variabili_emens';
  si4.sql_execute(V_comando);
  V_comando := 'create table DAPE_ANTE_489 as select * from dati_particolari_emens';
  si4.sql_execute(V_comando);
  V_comando := 'create table FOSE_ANTE_489 as select * from fondi_speciali_emens';
  si4.sql_execute(V_comando);
END IF;
END;
/
alter table settimane_emens add (  deie_id   NUMBER(10) );
alter table variabili_emens add (  deie_id   NUMBER(10) );
alter table dati_particolari_emens add (  deie_id   NUMBER(10) );
alter table fondi_speciali_emens add (  deie_id   NUMBER(10) );

delete from settimane_emens seie
where not exists ( select deie_id
                 from denuncia_emens
                where ci = seie.ci
                  and anno = seie.anno
                  and mese = seie.mese
                  and dal  = seie.dal_emens
              );
update settimane_emens seie
set deie_id = ( select deie_id
                 from denuncia_emens
                where ci = seie.ci
                  and anno = seie.anno
                  and mese = seie.mese
                  and dal  = seie.dal_emens
              );
delete from variabili_emens vaie
where not exists ( select deie_id
                 from denuncia_emens
                where ci = vaie.ci
                  and anno = vaie.anno
                  and mese = vaie.mese
                  and dal  = vaie.dal_emens
              );
update variabili_emens vaie
set deie_id = ( select deie_id
                 from denuncia_emens
                where ci = vaie.ci
                  and anno = vaie.anno
                  and mese = vaie.mese
                  and dal  = vaie.dal_emens
              );
delete from dati_particolari_emens dape
where not exists ( select deie_id
                 from denuncia_emens
                where ci = dape.ci
                  and anno = dape.anno
                  and mese = dape.mese
                  and dal  = dape.dal_emens
              );
update dati_particolari_emens dape
set deie_id = ( select deie_id
                 from denuncia_emens
                where ci = dape.ci
                  and anno = dape.anno
                  and mese = dape.mese
                  and dal  = dape.dal_emens
              );
prompt fondi
delete from fondi_speciali_emens fose
where not exists ( select deie_id
                 from denuncia_emens
                where ci = fose.ci
                  and anno = fose.anno
                  and mese = fose.mese
                  and dal  = fose.dal_emens
              );
update fondi_speciali_emens fose
set deie_id = ( select deie_id
                 from denuncia_emens
                where ci = fose.ci
                  and anno = fose.anno
                  and mese = fose.mese
                  and dal  = fose.dal_emens
              );
alter table settimane_emens modify deie_id   NOT NULL;
alter table variabili_emens modify deie_id   NOT NULL;
alter table dati_particolari_emens modify deie_id   NOT NULL;
alter table fondi_speciali_emens modify deie_id   NOT NULL;

-- ricreo gli indici ( DA FINIRE ; vedi modifiche ai crt )
drop index DEIE_PK;
drop index DEIE_IK;
CREATE UNIQUE INDEX DEIE_PK on DENUNCIA_EMENS ( deie_id );
CREATE INDEX DEIE_IK on DENUNCIA_EMENS ( ci , anno , mese , dal );

drop index SEIE_IK1;
CREATE INDEX SEIE_IK1 on SETTIMANE_EMENS ( deie_id );

drop index VAIE_IK1;
CREATE INDEX VAIE_IK1 on VARIABILI_EMENS ( deie_id );

drop index DAPE_IK1;
CREATE INDEX DAPE_IK1 on DATI_PARTICOLARI_EMENS ( deie_id );

drop index FOSE_IK1;
CREATE INDEX FOSE_IK1 on FONDI_SPECIALI_EMENS ( deie_id );

start crp_cursore_emens.sql
start crp_peccadmi.sql
start crv_emens.sql