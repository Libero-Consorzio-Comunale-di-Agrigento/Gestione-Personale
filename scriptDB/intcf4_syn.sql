DECLARE 

V_tipo        varchar2(18) := null;
V_conta       number := 0;
V_comando     varchar2(2000);

BEGIN
<<CREA_SOGG_CF4>>
/* creazione tabella SOGGETTI - Appoggio per Integrazione con CF4
la tabella viene creata SOLO se non esiste nessuno oggetto con tale nome
inoltre viene ricreata se non ci sono dati */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'SOGGETTI'
     ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_tipo := 'NULL';
   END;
-- dbms_output.put_line('Tipo:'||V_tipo);
   IF V_tipo = 'TABLE' THEN
      declare
      source_cursor INTEGER;
      ignore INTEGER;
      BEGIN
         source_cursor := dbms_sql.open_cursor;
         DBMS_SQL.PARSE(source_cursor,'select count(*) from SOGGETTI',DBMS_SQL.native);
         DBMS_SQL.DEFINE_COLUMN(source_cursor, 1, v_conta);
         ignore := DBMS_SQL.EXECUTE(source_cursor);
         IF DBMS_SQL.FETCH_ROWS(source_cursor)>0 THEN
            -- get column values of the row
               DBMS_SQL.COLUMN_VALUE(source_cursor, 1, v_conta);
            -- a questo punto nella variabile conta ho il contenuto dei campi del record
         ELSE
         -- no more row to copy
         v_conta := 0; -- sarebbe impossibile visto che è funzione di gruppo!!!
        END IF;
      DBMS_SQL.CLOSE_CURSOR(source_cursor);
      END;
      IF V_conta < 1 THEN 
-- dbms_output.put_line(' è un tabella vuota ');
         V_comando := 'DROP TABLE SOGGETTI';
-- dbms_output.put_line('comando1: '||V_comando);
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM SOGGETTI FOR &1.GP4_SOGGETTI';
-- dbms_output.put_line('comando2: '||V_comando);
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
-- dbms_output.put_line('non lo trovo ');
         V_comando := 'CREATE SYNONYM SOGGETTI FOR &1.GP4_SOGGETTI';
         si4.sql_execute(V_comando);
   END IF;
   IF V_tipo = 'SYNONYM' THEN
-- dbms_output.put_line(' è un syn');
         V_comando := 'DROP SYNONYM SOGGETTI';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM SOGGETTI FOR &1.GP4_SOGGETTI';
         si4.sql_execute(V_comando);
   END IF;
END CREA_SOGG_CF4;
/

DECLARE 

V_tipo        varchar2(18) := null;
V_conta       number := 0;
V_comando     varchar2(2000);

BEGIN
<<CREA_DELI_CF4>>
/* creazione oggetto DELIBERE - Appoggio per Integrazione con CF4
la tabella viene creata se non esiste nessuno oggetto con tale nome
inoltre viene ricreata se non ci sono dati */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'DELIBERE'
    ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_tipo := 'NULL';
   END;
   IF V_tipo = 'TABLE' THEN
      declare
      source_cursor INTEGER;
      ignore INTEGER;
      BEGIN
         source_cursor := dbms_sql.open_cursor;
         DBMS_SQL.PARSE(source_cursor,'select count(*) from DELIBERE',DBMS_SQL.native);
         DBMS_SQL.DEFINE_COLUMN(source_cursor, 1, v_conta);
         ignore := DBMS_SQL.EXECUTE(source_cursor);
         IF DBMS_SQL.FETCH_ROWS(source_cursor)>0 THEN
            -- get column values of the row
               DBMS_SQL.COLUMN_VALUE(source_cursor, 1, v_conta);
            -- a questo punto nella variabile conta ho il contenuto dei campi del record
         ELSE
         -- no more row to copy
         v_conta := 0; -- sarebbe impossibile visto che è funzione di gruppo!!!
        END IF;
      DBMS_SQL.CLOSE_CURSOR(source_cursor);
      END;
      IF V_conta < 1 THEN 
         V_comando := 'DROP TABLE DELIBERE';
         si4.sql_execute(V_comando);
         V_comando := 'create or replace view delibere 
                           as select  SEDE,  ANNO,  NUMERO ,  DATA  
                                   , '' '' OGGETTO
                                   , DESCRIZIONE 
                                   , '' '' ESECUTIVITA
                                   , TIPO_ESE 
                                   , '' '' NUMERO_ESE 
                                   ,  to_date(null) DATA_ESE  
                                   , '' '' NOTE
                          from &1.delibere';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'SYNONYM' THEN
         V_comando := 'DROP SYNONYM DELIBERE';
         si4.sql_execute(V_comando);
         V_comando := 'create or replace view delibere 
                           as select  SEDE,  ANNO,  NUMERO ,  DATA  
                                   , '' '' OGGETTO
                                   , DESCRIZIONE 
                                   , '' '' ESECUTIVITA
                                   , TIPO_ESE 
                                   , '' '' NUMERO_ESE 
                                   ,  to_date(null) DATA_ESE  
                                   , '' '' NOTE
                          from &1.delibere';
         si4.sql_execute(V_comando);
   END IF;
   IF V_tipo = 'VIEW' THEN
         V_comando := 'DROP VIEW DELIBERE';
         si4.sql_execute(V_comando);
         V_comando := 'create or replace view delibere 
                           as select  SEDE,  ANNO,  NUMERO ,  DATA  
                                   , '' '' OGGETTO
                                   , DESCRIZIONE 
                                   , '' '' ESECUTIVITA
                                   , TIPO_ESE 
                                   , '' '' NUMERO_ESE 
                                   ,  to_date(null) DATA_ESE  
                                   , '' '' NOTE
                          from &1.delibere';
         si4.sql_execute(V_comando);
   END IF;
END CREA_DELI_CF4;
/

DECLARE 

V_tipo        varchar2(18) := null;
V_comando     varchar2(2000);

BEGIN
<<CREA_CAP_CF4>>
/* creazione oggetto CAPITOLI_CONTABILITA */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'CAPITOLI_CONTABILITA'
    ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_tipo := 'NULL';
   END;
   IF V_tipo = 'TABLE' THEN
         V_comando := 'DROP TABLE CAPITOLI_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM CAPITOLI_CONTABILITA FOR &1.GP4_CAP';
         si4.sql_execute(V_comando);
   END IF;
   IF V_tipo = 'SYNONYM' THEN
         V_comando := 'DROP SYNONYM CAPITOLI_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM CAPITOLI_CONTABILITA FOR &1.GP4_CAP';
         si4.sql_execute(V_comando);
   END IF;
END CREA_CAP_CF4;
/

DECLARE 

V_tipo        varchar2(18) := null;
V_comando     varchar2(2000);

BEGIN
<<CREA_ACC_IMP_CF4>>
/* creazione oggetto ACC_IMP_CONTABILITA */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'ACC_IMP_CONTABILITA'
    ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_tipo := 'NULL';
   END;
   IF V_tipo = 'TABLE' THEN
         V_comando := 'DROP TABLE ACC_IMP_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM ACC_IMP_CONTABILITA FOR &1.GP4_IMP_ACC';
         si4.sql_execute(V_comando);
   END IF;
   IF V_tipo = 'SYNONYM' THEN
         V_comando := 'DROP SYNONYM ACC_IMP_CONTABILITA ';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM ACC_IMP_CONTABILITA FOR &1.GP4_IMP_ACC';
         si4.sql_execute(V_comando);
   END IF;
END CREA_ACC_IMP_CF4;
/

DECLARE 

V_tipo        varchar2(18) := null;
V_comando     varchar2(2000);

BEGIN
<<CREA_QUIETANZE_CF4>>
/* creazione oggetto QUIETANZE_CONTABILITA */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'QUIETANZE_CONTABILITA'
    ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_tipo := 'NULL';
   END;
   IF V_tipo = 'TABLE' THEN
         V_comando := 'DROP TABLE QUIETANZE_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM QUIETANZE_CONTABILITA FOR &1.GP4_QUIETANZE';
         si4.sql_execute(V_comando);
   END IF;
   IF V_tipo = 'SYNONYM' THEN
         V_comando := 'DROP SYNONYM QUIETANZE_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM QUIETANZE_CONTABILITA FOR &1.GP4_QUIETANZE';
         si4.sql_execute(V_comando);
   END IF;
END CREA_QUIETANZE_CF4;
/

DECLARE 

V_tipo        varchar2(18) := null;
V_comando     varchar2(2000);

BEGIN
<<CREA_SUBIMP_CF4>>
/* creazione oggetto SUBIMP_CONTABILITA */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'SUBIMP_CONTABILITA'
    ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_tipo := 'NULL';
   END;
   IF V_tipo = 'TABLE' THEN
         V_comando := 'DROP TABLE SUBIMP_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM SUBIMP_CONTABILITA FOR &1.GP4_SUBIMP';
         si4.sql_execute(V_comando);
   END IF;
   IF V_tipo = 'SYNONYM' THEN
         V_comando := 'DROP SYNONYM SUBIMP_CONTABILITA ';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE SYNONYM SUBIMP_CONTABILITA FOR &1.GP4_SUBIMP';
         si4.sql_execute(V_comando);
   END IF;
END CREA_SUBIMP_CF4;
/

alter function controlla_oggetti_cf4 compile;

grant select on imputazioni_contabili to &1;
