--Attivita 10421.5

column C1 noprint new_value P1
column C2 noprint new_value P2
column C3 noprint new_value P3
column C4 noprint new_value P4
column C5 noprint new_value P5
column C6 noprint new_value P6
column C7 noprint new_value P7

select count(*)       C1
      ,count(*)*1500  c2
      ,count(*)*300   c3
      ,count(*)*800   c4
      ,count(*)*750   c5
      ,count(*)*400   c6
      ,count(*)*150   c7
  from anagrafici
 where al is null
;

-- Modifiche agli indici di PEDO

-- Add/modify columns 
alter table PERIODI_DOTAZIONE modify REVISIONE not null;
alter table PERIODI_DOTAZIONE modify DOOR_ID not null;
-- Create/Recreate indexes 
drop index PEDO_PK;
drop index PEDO_UK_DI_RUOLO;
CREATE INDEX PEDO_PK ON PERIODI_DOTAZIONE
(REVISIONE, DOOR_ID, RILEVANZA, GESTIONE, DAL, 
AL)
STORAGE    (
  INITIAL   &p2
  NEXT   &p5
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;
CREATE INDEX PEDO_UK_DI_RUOLO ON PERIODI_DOTAZIONE
(DOOR_ID, REVISIONE, DI_RUOLO, GESTIONE, RILEVANZA, 
DAL, AL)
STORAGE    (
  INITIAL   &p3
  NEXT   &p7
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UK ON PERIODI_DOTAZIONE
(DOOR_ID, REVISIONE, GESTIONE, RILEVANZA, CI, 
DAL, AL)
STORAGE    (
  INITIAL   &p4
  NEXT   &p6
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UK2 ON PERIODI_DOTAZIONE
(RILEVANZA, REVISIONE, DOOR_ID, GESTIONE, PROFILO, 
POS_FUNZ, ATTIVITA)
STORAGE    (
  INITIAL   &p4
  NEXT   &p6
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;

start crv_dndi.sql
start crv_dnfa.sql
start crp_gp4gm.sql
start crp_gp4do.sql



