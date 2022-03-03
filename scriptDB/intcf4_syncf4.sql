DECLARE 

V_tipo        varchar2(18);
V_conta       number := 0;
V_comando     varchar2(2000);

BEGIN
<<CREA_IMCO_CF4>>
/* creazione oggetto IMPUTAZIONI CONTABILI sull'utente del CF4
la tabella viene creata SOLO se non esiste nessuno oggetto con tale nome
inoltre viene ricreata se non ci sono dati */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'IMPUTAZIONI_CONTABILI'
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
         DBMS_SQL.PARSE(source_cursor,'select count(*) from IMPUTAZIONI_CONTABILI',DBMS_SQL.native);
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
         V_comando := 'DROP TABLE IMPUTAZIONI_CONTABILI';
         si4.sql_execute(V_comando);
         V_comando := 'create synonym imputazioni_contabili for &1.imputazioni_contabili';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
         V_comando := 'create synonym imputazioni_contabili for &1.imputazioni_contabili';
         si4.sql_execute(V_comando);
   END IF;
END CREA_IMCO_CF4;
/