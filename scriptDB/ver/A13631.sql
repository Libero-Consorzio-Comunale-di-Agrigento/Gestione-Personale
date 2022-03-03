-- Nuovi campi di periodi_dotazione

alter table PERIODI_DOTAZIONE add TIPO_PART_TIME VARCHAR2(2);

alter table PERIODI_DOTAZIONE add ASS_PART_TIME VARCHAR2(2);

-- Nuovi trigger
start crp_gp4_posi.sql
start crp_gp4_pegi.sql
start crp_gp4do.sql
start crv_gp4do1.sql
start crf_cost_pedo_tma.sql
start crf_pegi_pedo_tma.sql
start crf_gp4do.sql

-- Nuovi indici di periodi_dotazione

DECLARE
   d_init    NUMBER;
   d_next    NUMBER;
   d_dummy   VARCHAR2 (1);
BEGIN
   BEGIN
      SELECT max(initial_extent) 
        INTO d_init
        FROM user_indexes
       WHERE table_name='PERIODI_DOTAZIONE';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         d_init           := 1000000;
         d_next           := 500000;
   END;
   DBMS_OUTPUT.put_line (d_init || ' ' || d_next);

   BEGIN
      SELECT 'x'
        INTO d_dummy
        FROM user_indexes
       WHERE index_name = 'PEDO_UK';

      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      WHEN TOO_MANY_ROWS THEN
         si4.sql_execute ('drop index PEDO_UK');
   END;

   si4.sql_execute
              (   'create index PEDO_UK on PERIODI_DOTAZIONE (REVISIONE, DOOR_ID) storage (initial '
               || d_init
               || ' )'
              );

   DBMS_OUTPUT.put_line (d_init || ' ' || d_next);

   BEGIN
      SELECT 'x'
        INTO d_dummy
        FROM user_indexes
       WHERE index_name = 'PEDO_PK';

      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      WHEN TOO_MANY_ROWS THEN
         si4.sql_execute ('drop index PEDO_PK');
   END;

   si4.sql_execute
      (   'create index PEDO_PK on PERIODI_DOTAZIONE (REVISIONE, DOOR_ID, CI, RILEVANZA, GESTIONE, DAL, AL) storage (initial '
       || d_init
       || ' )'
      );

   BEGIN
      SELECT 'x'
        INTO d_dummy
        FROM user_indexes
       WHERE index_name = 'PEDO_UK3';

      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      WHEN TOO_MANY_ROWS THEN
         si4.sql_execute ('drop index PEDO_UK3');
   END;

   si4.sql_execute
      (   'create index PEDO_UK3 on PERIODI_DOTAZIONE (REVISIONE, CI, RILEVANZA, GESTIONE, DAL, AL) storage (initial '
       || d_init
       || ' )'
      );
END;
/

