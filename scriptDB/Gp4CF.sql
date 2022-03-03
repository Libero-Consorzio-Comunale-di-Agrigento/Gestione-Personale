-- start A5388.sql
DECLARE 

V_tipo        varchar2(18);
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
         V_comando := 'DROP TABLE SOGGETTI';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE TABLE SOGGETTI
                      ( soggetto                        NUMBER(9,0)      NOT NULL
                      , denominazione                   VARCHAR(40)      NULL
                      , denominazione_al1               VARCHAR(40)      NULL
                      , denominazione_al2               VARCHAR(40)      NULL
                      , codice_fiscale                  VARCHAR(16)      NULL
                      , divisione                       VARCHAR2(4)      NULL
                      )';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
         V_comando := 'CREATE TABLE SOGGETTI
                      ( soggetto                        NUMBER(9,0)      NOT NULL
                      , denominazione                   VARCHAR(40)      NULL
                      , denominazione_al1               VARCHAR(40)      NULL
                      , denominazione_al2               VARCHAR(40)      NULL
                      , codice_fiscale                  VARCHAR(16)      NULL
                      , divisione                       VARCHAR2(4)      NULL
                      )';
         si4.sql_execute(V_comando);
   END IF;
END CREA_SOGG_CF4;
/

DECLARE 

V_tipo        varchar2(18);
V_conta       number := 0;
V_comando     varchar2(2000);

BEGIN
<<CREA_DELI_CF4>>
/* creazione tabella DELIBERE - Appoggio per Integrazione con CF4
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
         V_comando := 'CREATE TABLE DELIBERE
                       ( sede                            VARCHAR(4)       NOT NULL
                       , anno                            NUMBER(4,0)      NOT NULL
                       , numero                          NUMBER(7,0)      NOT NULL
                       , data                            DATE             NOT NULL
                       , oggetto                         VARCHAR(240)     NULL
                       , descrizione                     VARCHAR(50)      NULL
                       , esecutivita                     VARCHAR(1)       NOT NULL
                       , tipo_ese                        VARCHAR(30)      NOT NULL
                       , numero_ese                      VARCHAR(12)      NULL
                       , data_ese                        DATE             NULL
                       , note                            VARCHAR(60)      NULL
                       )';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
         V_comando := 'CREATE TABLE DELIBERE
                       ( sede                            VARCHAR(4)       NOT NULL
                       , anno                            NUMBER(4,0)      NOT NULL
                       , numero                          NUMBER(7,0)      NOT NULL
                       , data                            DATE             NOT NULL
                       , oggetto                         VARCHAR(240)     NULL
                       , descrizione                     VARCHAR(50)      NULL
                       , esecutivita                     VARCHAR(1)       NOT NULL
                       , tipo_ese                        VARCHAR(30)      NOT NULL
                       , numero_ese                      VARCHAR(12)      NULL
                       , data_ese                        DATE             NULL
                       , note                            VARCHAR(60)      NULL
                       )';
         si4.sql_execute(V_comando);
   END IF;
END CREA_DELI_CF4;
/

DECLARE 

V_tipo        varchar2(18);
V_conta       number := 0;
V_comando     varchar2(2000);

BEGIN
<<CREA_CACO_CF4>>
/* creazione tabella CAPITOLI_CONTABILITA - Appoggio per Integrazione con CF4
la tabella viene creata se non esiste nessuno oggetto con tale nome
inoltre viene ricreata se non ci sono dati */
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
      declare
      source_cursor INTEGER;
      ignore INTEGER;
      BEGIN
         source_cursor := dbms_sql.open_cursor;
         DBMS_SQL.PARSE(source_cursor,'select count(*) from CAPITOLI_CONTABILITA',DBMS_SQL.native);
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
         V_comando := 'DROP TABLE CAPITOLI_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE TABLE CAPITOLI_CONTABILITA
                       ( ESERCIZIO                       NUMBER(4)     NOT NULL 
                       , E_S                             VARCHAR2(1)   NOT NULL
                       , RISORSA_INTERVENTO              NUMBER(7)     NOT NULL
                       , CAPITOLO                        NUMBER(6)     NOT NULL
                       , ARTICOLO                        NUMBER(2)     NOT NULL
                       , DESCRIZIONE                     VARCHAR2(140) NOT NULL 
                       , TITOLO                          NUMBER(2)
                       , CATEGORIA                       NUMBER(2)
                       , COD_INTERVENTO                  NUMBER(2)
                       , CTERZI                          NUMBER(2)
                       , DIVISIONE                       VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX CAPC_PK ON CAPITOLI_CONTABILITA 
                       ( ESERCIZIO, E_S, RISORSA_INTERVENTO, CAPITOLO, ARTICOLO)';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
         V_comando := 'CREATE TABLE CAPITOLI_CONTABILITA
                       ( ESERCIZIO                       NUMBER(4)     NOT NULL 
                       , E_S                             VARCHAR2(1)   NOT NULL
                       , RISORSA_INTERVENTO              NUMBER(7)     NOT NULL
                       , CAPITOLO                        NUMBER(6)     NOT NULL
                       , ARTICOLO                        NUMBER(2)     NOT NULL
                       , DESCRIZIONE                     VARCHAR2(140) NOT NULL 
                       , TITOLO                          NUMBER(2)
                       , CATEGORIA                       NUMBER(2)
                       , COD_INTERVENTO                  NUMBER(2)
                       , CTERZI                          NUMBER(2)
                       , DIVISIONE                       VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX CAPC_PK ON CAPITOLI_CONTABILITA 
                       ( ESERCIZIO, E_S, RISORSA_INTERVENTO, CAPITOLO, ARTICOLO)';
         si4.sql_execute(V_comando);
   END IF;
END CREA_CACO_CF4;
/

DECLARE 

V_tipo        varchar2(18);
V_conta       number := 0;
V_comando     varchar2(2000);

-- creazione della tabella ACC_IMP_CONTABILITA
BEGIN
<<CREA_ACIM_CF4>>
/* creazione tabella ACC_IMP_CONTABILITA - Appoggio per Integrazione con CF4
la tabella viene creata se non esiste nessuno oggetto con tale nome
inoltre viene ricreata se non ci sono dati; se è una vista la droppo e ricreo la tabella perchè significa che 
provengo dal primo rilascio dell'integrazione */
   BEGIN
   select object_type 
     into V_tipo
     from obj
    where object_name = 'ACC_IMP_CONTABILITA'
     ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_tipo := 'NULL';
   END;
   IF V_tipo = 'VIEW' THEN
         V_comando := 'DROP VIEW ACC_IMP_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE TABLE ACC_IMP_CONTABILITA
                       ( ESERCIZIO                                NUMBER       NOT NULL
                       , E_S                                      VARCHAR2(1)  NOT NULL
                       , RISORSA_INTERVENTO                       NUMBER       NOT NULL
                       , CAPITOLO                                 NUMBER       NOT NULL
                       , ARTICOLO                                 NUMBER       NOT NULL
                       , ANNO_IMP_ACC                             NUMBER       NOT NULL
                       , NUMERO_IMP_ACC                           NUMBER       NOT NULL
                       , ANNO_DEL                                 VARCHAR2(2000)
                       , NUMERO_DEL                               VARCHAR2(2000)
                       , SEDE_DEL                                 VARCHAR2(2000)
                       , SOGGETTO                                 VARCHAR2(2000)
                       , DIVISIONE                                VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX ACON_PK ON ACC_IMP_CONTABILITA
                      ( ESERCIZIO
                      , E_S
                      , RISORSA_INTERVENTO
                      , CAPITOLO
                      , ARTICOLO
                      , ANNO_IMP_ACC
                      , NUMERO_IMP_ACC
                      )';
         si4.sql_execute(V_comando);
   ELSIF V_tipo = 'TABLE' THEN
      declare
      source_cursor INTEGER;
      ignore INTEGER;
      BEGIN
         source_cursor := dbms_sql.open_cursor;
         DBMS_SQL.PARSE(source_cursor,'select count(*) from ACC_IMP_CONTABILITA',DBMS_SQL.native);
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
         V_comando := 'DROP TABLE ACC_IMP_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE TABLE ACC_IMP_CONTABILITA
                       ( ESERCIZIO                                NUMBER       NOT NULL
                       , E_S                                      VARCHAR2(1)  NOT NULL
                       , RISORSA_INTERVENTO                       NUMBER       NOT NULL
                       , CAPITOLO                                 NUMBER       NOT NULL
                       , ARTICOLO                                 NUMBER       NOT NULL
                       , ANNO_IMP_ACC                             NUMBER       NOT NULL
                       , NUMERO_IMP_ACC                           NUMBER       NOT NULL
                       , ANNO_DEL                                 VARCHAR2(2000)
                       , NUMERO_DEL                               VARCHAR2(2000)
                       , SEDE_DEL                                 VARCHAR2(2000)
                       , SOGGETTO                                 VARCHAR2(2000)
                       , DIVISIONE                                VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX ACON_PK ON ACC_IMP_CONTABILITA
                      ( ESERCIZIO
                      , E_S
                      , RISORSA_INTERVENTO
                      , CAPITOLO
                      , ARTICOLO
                      , ANNO_IMP_ACC
                      , NUMERO_IMP_ACC
                      )';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
         V_comando := 'CREATE TABLE ACC_IMP_CONTABILITA
                       ( ESERCIZIO                                NUMBER       NOT NULL
                       , E_S                                      VARCHAR2(1)  NOT NULL
                       , RISORSA_INTERVENTO                       NUMBER       NOT NULL
                       , CAPITOLO                                 NUMBER       NOT NULL
                       , ARTICOLO                                 NUMBER       NOT NULL
                       , ANNO_IMP_ACC                             NUMBER       NOT NULL
                       , NUMERO_IMP_ACC                           NUMBER       NOT NULL
                       , ANNO_DEL                                 VARCHAR2(2000)
                       , NUMERO_DEL                               VARCHAR2(2000)
                       , SEDE_DEL                                 VARCHAR2(2000)
                       , SOGGETTO                                 VARCHAR2(2000)
                       , DIVISIONE                                VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX ACON_PK ON ACC_IMP_CONTABILITA
                      ( ESERCIZIO
                      , E_S
                      , RISORSA_INTERVENTO
                      , CAPITOLO
                      , ARTICOLO
                      , ANNO_IMP_ACC
                      , NUMERO_IMP_ACC
                      )';
         si4.sql_execute(V_comando);
   END IF;
END CREA_ACIM_CF4;
/
DECLARE 

V_tipo        varchar2(18);
V_conta       number := 0;
V_comando     varchar2(2000);

-- creazione della tabella SUBIMP_CONTABILITA
BEGIN
<<CREA_SUBIMP_CF4>>
/* creazione tabella SUBIMP_CONTABILITA - Appoggio per Integrazione con CF4
la tabella viene creata se non esiste nessuno oggetto con tale nome
inoltre viene ricreata se non ci sono dati */
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
      declare
      source_cursor INTEGER;
      ignore INTEGER;
      BEGIN
         source_cursor := dbms_sql.open_cursor;
         DBMS_SQL.PARSE(source_cursor,'select count(*) from SUBIMP_CONTABILITA',DBMS_SQL.native);
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
         V_comando := 'DROP TABLE SUBIMP_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE TABLE SUBIMP_CONTABILITA
                       ( ESERCIZIO                       NUMBER(4) NOT NULL
                       , E_S                             VARCHAR(1) NOT NULL
                       , RISORSA_INTERVENTO              NUMBER(7) NOT NULL
                       , CAPITOLO                        NUMBER(6) NOT NULL
                       , ARTICOLO                        NUMBER(2) NOT NULL
                       , ANNO_IMP                        NUMBER(4) NOT NULL
                       , NUMERO_IMP                      NUMBER(5) NOT NULL
                       , ANNO_SUBIMP                     NUMBER(4) NOT NULL
                       , NUMERO_SUBIMP                   NUMBER(5) NOT NULL
                       , ANNO_DEL                        VARCHAR2(2000)
                       , NUMERO_DEL                      VARCHAR2(2000)
                       , SEDE_DEL                        VARCHAR2(2000)
                       , SOGGETTO                        VARCHAR2(2000)
                       , DIVISIONE                       VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX SUCO_PK ON SUBIMP_CONTABILITA
                      ( ESERCIZIO
                      , E_S
                      , RISORSA_INTERVENTO
                      , CAPITOLO
                      , ARTICOLO
                      , ANNO_IMP
                      , NUMERO_IMP
                      , ANNO_SUBIMP
                      , NUMERO_SUBIMP
                      )';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
         V_comando := 'CREATE TABLE SUBIMP_CONTABILITA
                       ( ESERCIZIO                       NUMBER(4) NOT NULL
                       , E_S                             VARCHAR(1) NOT NULL
                       , RISORSA_INTERVENTO              NUMBER(7) NOT NULL
                       , CAPITOLO                        NUMBER(6) NOT NULL
                       , ARTICOLO                        NUMBER(2) NOT NULL
                       , ANNO_IMP                        NUMBER(4) NOT NULL
                       , NUMERO_IMP                      NUMBER(5) NOT NULL
                       , ANNO_SUBIMP                     NUMBER(4) NOT NULL
                       , NUMERO_SUBIMP                   NUMBER(5) NOT NULL
                       , ANNO_DEL                        VARCHAR2(2000)
                       , NUMERO_DEL                      VARCHAR2(2000)
                       , SEDE_DEL                        VARCHAR2(2000)
                       , SOGGETTO                        VARCHAR2(2000)
                       , DIVISIONE                       VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX SUCO_PK ON SUBIMP_CONTABILITA
                      ( ESERCIZIO
                      , E_S
                      , RISORSA_INTERVENTO
                      , CAPITOLO
                      , ARTICOLO
                      , ANNO_IMP
                      , NUMERO_IMP
                      , ANNO_SUBIMP
                      , NUMERO_SUBIMP
                      )';
         si4.sql_execute(V_comando);
   END IF;
END CREA_SUBIMP_CF4;
/
DECLARE 

V_tipo        varchar2(18);
V_conta       number := 0;
V_comando     varchar2(2000);

-- creazione della tabella QUIETANZE_CONTABILITA
BEGIN
<<CREA_QTN_CF4>>
/* creazione tabella QUIETANZE_CONTABILITA - Appoggio per Integrazione con CF4
la tabella viene creata se non esiste nessuno oggetto con tale nome
inoltre viene ricreata se non ci sono dati */
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
      declare
      source_cursor INTEGER;
      ignore INTEGER;
      BEGIN
         source_cursor := dbms_sql.open_cursor;
         DBMS_SQL.PARSE(source_cursor,'select count(*) from QUIETANZE_CONTABILITA',DBMS_SQL.native);
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
         V_comando := 'DROP TABLE QUIETANZE_CONTABILITA';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE TABLE QUIETANZE_CONTABILITA
                       ( SOGGETTO           NUMBER(6) NOT NULL 
                       , NUM_QUIETANZA      NUMBER(2) NOT NULL 
                       , DESCRIZIONE                  VARCHAR2(2000)
                       , SCADENZA                     DATE
                       , DIVISIONE                    VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX QUCO_PK ON QUIETANZE_CONTABILITA
                      ( SOGGETTO,
                        NUM_QUIETANZA
                      )';
         si4.sql_execute(V_comando);
      END IF;
   END IF;
   IF V_tipo = 'NULL' THEN
         V_comando := 'CREATE TABLE QUIETANZE_CONTABILITA
                       (  SOGGETTO           NUMBER(6) NOT NULL 
                       , NUM_QUIETANZA      NUMBER(2) NOT NULL 
                       , DESCRIZIONE                  VARCHAR2(2000)
                       , SCADENZA                     DATE
                       , DIVISIONE                    VARCHAR2(2000)
                       )';
         si4.sql_execute(V_comando);
         V_comando := 'CREATE UNIQUE INDEX QUCO_PK ON QUIETANZE_CONTABILITA
                      ( SOGGETTO,
                        NUM_QUIETANZA
                      )';
         si4.sql_execute(V_comando);
   END IF;
END CREA_QUIETANZE_CF4;
/
-- creazione della function di controllo
start crf_cf4chk.sql

