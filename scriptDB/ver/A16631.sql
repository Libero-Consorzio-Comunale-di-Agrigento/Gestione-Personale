-- attività 16631
CREATE OR REPLACE TRIGGER settori_amministrativi_tma
   AFTER INSERT OR UPDATE OR DELETE
   ON settori_amministrativi
   FOR EACH ROW
DECLARE
   tmpvar            NUMBER;
   dep_ni            NUMBER;
   dep_revisione     NUMBER;
   integrity_error   EXCEPTION;
   errno             INTEGER;
   errmsg            CHAR (200);
   dummy             INTEGER;
   FOUND             BOOLEAN;
BEGIN
   /* Creazione di un nuovo settore amministrativo. Inseriamo su Ripartizioni funzionali */
   IF INSERTING THEN
      INSERT INTO ripartizioni_funzionali
                  (settore, sede)
         SELECT :NEW.numero
               ,NVL (:NEW.sede, 0)
           FROM DUAL
          WHERE NOT EXISTS (SELECT 'x'
                              FROM ripartizioni_funzionali
                             WHERE settore = :NEW.numero
                               AND sede = NVL (:NEW.sede, 0) );
   END IF;

   IF UPDATING THEN
      UPDATE ripartizioni_funzionali rifu
         SET sede = NVL (:NEW.sede, 0)
       WHERE settore = :NEW.numero
         AND sede = NVL (:OLD.sede, 0)
         AND NOT EXISTS (SELECT 'x'
                           FROM ripartizioni_funzionali
                          WHERE settore = :NEW.numero
                            AND sede = NVL (:NEW.sede, 0) );  --A16631
   END IF;

   IF DELETING THEN
      DELETE FROM ripartizioni_funzionali
            WHERE settore = :OLD.numero
              AND sede = NVL (:OLD.sede, 0);
   END IF;
END settori_amministrativi_tma;
/

