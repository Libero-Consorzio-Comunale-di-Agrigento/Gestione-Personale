UPDATE A_VOCI_MENU SET GUIDA_O = 'P_ATGI' WHERE VOCE_MENU='PGMDATGI';

INSERT INTO A_GUIDE_V ( GUIDA_V, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, VOCE_MENU, VOCE_RIF, PROPRIETA ) VALUES ( 
'P_DELI_A', 1, NULL, 'E', NULL, NULL, 'Elenco', NULL, NULL, 'P00EDELI', NULL, NULL); 
INSERT INTO A_GUIDE_V ( GUIDA_V, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, VOCE_MENU, VOCE_RIF, PROPRIETA ) VALUES ( 
'P_DELI_A', 2, NULL, 'A', NULL, NULL, 'Aggiornamento', NULL, NULL, 'P00ADELI', NULL
, NULL); 

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_ATGI', 1, 'DELI', 'D', NULL, NULL, 'Delibere', NULL, NULL, 'P_DELI_A', NULL, NULL
, NULL, NULL, NULL, NULL); 

ALTER TABLE REVISIONI_STRUTTURA
ADD (SEDE_DEL VARCHAR2(4));

ALTER TABLE REVISIONI_STRUTTURA
ADD (ANNO_DEL NUMBER(4));

ALTER TABLE REVISIONI_STRUTTURA
ADD (NUMERO_DEL NUMBER(8));

DECLARE
V_controllo varchar2(1);
V_comando   varchar2(1000);

BEGIN
 BEGIN
  select 'Y' 
    into V_controllo
    from dual
   where exists ( select 'x' from obj 
                   where object_name = 'REST_PRIMA_DELLA_A12627'
                 );
 EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := 'X';
 END;
/* Salvataggio Dati */
 IF V_controllo = 'Y' THEN NULL;
 ELSE
   V_comando := 'create table REST_PRIMA_DELLA_A12627 as select * from revisioni_struttura';
   si4.sql_execute(V_comando);
 END IF;
END;
/

UPDATE REVISIONI_STRUTTURA
SET   SEDE_DEL = TIPO_REGISTRO;

UPDATE REVISIONI_STRUTTURA
SET   ANNO_DEL = ANNO;

UPDATE REVISIONI_STRUTTURA
SET   NUMERO_DEL = NUMERO;


declare
v_versione  varchar2(1);
V_comando   varchar2(1000);
begin
  BEGIN
-- estrazione della versione
  select '7'
    into v_versione
    from v$version
   where instr(upper(banner),'RELEASE')>0
     and substr(banner,7,1) = '7'
     and substr(banner,instr(upper(banner),'RELEASE ')+8,1)= '7'
      ;
   exception
   when no_data_found then
        v_versione := '8';
   END;
 IF v_versione = '7' THEN NULL;
 ELSE 
   v_comando :='ALTER TABLE REVISIONI_STRUTTURA DROP COLUMN TIPO_REGISTRO';
   si4.sql_execute(v_comando);
   v_comando :='ALTER TABLE REVISIONI_STRUTTURA DROP COLUMN ANNO';
   si4.sql_execute(v_comando);
   v_comando :='ALTER TABLE REVISIONI_STRUTTURA DROP COLUMN NUMERO';
   si4.sql_execute(v_comando);
 END IF;
END;
/

start crf_gp4gm.sql