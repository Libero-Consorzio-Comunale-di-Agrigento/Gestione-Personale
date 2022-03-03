-- salvataggio dati AOO
DECLARE
V_esiste varchar2(2);
BEGIN
   BEGIN
   select 'SI'
    into V_esiste 
     from obj
    where object_name = 'AOO_ANTE_A14896';
   EXCEPTION WHEN NO_DATA_FOUND THEN V_esiste := 'NO';
   END;
   IF V_esiste = 'NO' THEN 
     si4.sql_execute('create table AOO_ANTE_A14896 as select * from AOO');
   END IF;
END;
/


drop table AOO;

CREATE TABLE AOO
(
  CODICE_AMMINISTRAZIONE  VARCHAR2(8)           	    NOT NULL,
  AMM_DAL                 DATE                  	    NOT NULL,
  CODICE_AOO              VARCHAR2(8)           	    NOT NULL,
  DAL                     DATE                  	    NOT NULL,
  AL                      DATE,
  NI                      NUMBER(8),
  GRUPPO                  VARCHAR2(4),
  ENTE                    VARCHAR2(1)                       NOT NULL
);

create unique index AOO_PK
on AOO (
   CODICE_AMMINISTRAZIONE ASC,
   AMM_DAL ASC,
   CODICE_AOO ASC,
   DAL ASC
);

create  index AOO_SOGG_FK
on AOO (
   NI ASC
);


create  index AOO_AMMI_FK
on AOO (
   AMM_DAL ASC,
   CODICE_AMMINISTRAZIONE ASC
);


create  index AOO_GRAM_FK
on AOO (
   GRUPPO ASC
);


insert into AOO (codice_amministrazione,amm_dal,codice_AOO,dal,al,ni,gruppo,ente)
       select codice_amministrazione,amm_dal,codice__AOO,dal,al,ni,gruppo,nvl(ente,'N') 
       from   AOO_ANTE_A14896
;

-- salvataggio dati UNOR
DECLARE
V_esiste varchar2(2);
BEGIN
   BEGIN
   select 'SI'
    into V_esiste 
     from obj
    where object_name = 'UNOR_ANTE_A14896';
   EXCEPTION WHEN NO_DATA_FOUND THEN V_esiste := 'NO';
   END;
   IF V_esiste = 'NO' THEN 
     si4.sql_execute('create table UNOR_ANTE_A14896 as select * from UNITA_ORGANIZZATIVE');
   END IF;
END;
/

alter table UNITA_ORGANIZZATIVE disable all triggers;

ALTER TABLE UNITA_ORGANIZZATIVE DROP COLUMN codice__aoo;

ALTER TABLE UNITA_ORGANIZZATIVE
ADD (codice_aoo VARCHAR2(8) );

UPDATE UNITA_ORGANIZZATIVE UNOR
SET    CODICE_AOO= (SELECT CODICE__AOO
                    FROM   UNOR_ANTE_A14896
                    WHERE  NI =UNOR.NI
                    AND    OTTICA=UNOR.OTTICA
                    AND    DAL=UNOR.DAL
                    AND    REVISIONE=UNOR.REVISIONE);

drop index UNOR_AOO_FK;

create  index UNOR_AOO_FK
on UNITA_ORGANIZZATIVE (
   CODICE_AMMINISTRAZIONE ASC,
   AMM_DAL ASC,
   CODICE_AOO ASC,
   AOO_DAL ASC
);

alter table UNITA_ORGANIZZATIVE enable all triggers;

start crf_gp4gm.sql