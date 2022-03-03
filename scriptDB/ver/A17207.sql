-- Att. 17207
-- Rendiamo univoco l'indice PEDO_PK

DECLARE
   d_init    NUMBER;
   d_next    NUMBER;
   d_dummy   VARCHAR2 (1);
BEGIN
   BEGIN
      SELECT MAX (initial_extent)*5
            ,nvl(MAX (next_extent)*5,MAX (initial_extent)*2)
        INTO d_init
            ,d_next
        FROM user_indexes
       WHERE table_name = 'PERIODI_DOTAZIONE';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         d_init           := 5000000;
         d_next           := 5000000;
   END;

   FOR multi IN (SELECT   ci
                         ,dal
                         ,rilevanza
                         ,revisione
                     FROM periodi_dotazione
                 GROUP BY ci
                         ,dal
                         ,rilevanza
                         ,revisione
                   HAVING COUNT (*) > 1)
   LOOP
      DELETE FROM periodi_dotazione
            WHERE ci = multi.ci
              AND rilevanza = multi.rilevanza
              AND dal = multi.dal;

      UPDATE periodi_giuridici
         SET ci = ci
       WHERE rilevanza IN ('Q', 'S', 'I', 'E')
         AND ci = multi.ci
         AND rilevanza = multi.rilevanza
         AND dal = multi.dal;
   END LOOP;

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
      (   'create unique index PEDO_PK on PERIODI_DOTAZIONE (REVISIONE, DOOR_ID, CI, RILEVANZA, GESTIONE, DAL, AL) storage (initial '
       || d_init ||' next '|| d_next || ' maxextents 121 ' || 'PCTINCREASE      0 '
       || ' )'
      );
END;
/































































