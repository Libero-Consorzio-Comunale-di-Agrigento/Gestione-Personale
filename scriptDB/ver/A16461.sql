-- Attività 16461

-- ricrea trigger suddivisioni_struttura_tma

CREATE OR REPLACE TRIGGER suddivisioni_struttura_tma
   AFTER INSERT OR UPDATE OR DELETE
   ON suddivisioni_struttura
   FOR EACH ROW
DECLARE
   dep_nota     VARCHAR2 (14);
   dep_nota_o   VARCHAR2 (14);
BEGIN
   IF integritypackage.getnestlevel = 0 THEN
      integritypackage.nextnestlevel;
      dep_nota         := 'NOTA_';
      dep_nota_o       := 'NOTA_';

      IF (:NEW.livello = '0') THEN
         dep_nota         := dep_nota || 'GESTIONE';
      ELSIF (:NEW.livello = '1') THEN
         dep_nota         := dep_nota || 'SETTORE_A';
      ELSIF (:NEW.livello = '2') THEN
         dep_nota         := dep_nota || 'SETTORE_B';
      ELSIF (:NEW.livello = '3') THEN
         dep_nota         := dep_nota || 'SETTORE_C';
      ELSIF (:NEW.livello = '4') THEN
         dep_nota         := dep_nota || 'SETTORE';
      END IF;

      IF (:OLD.livello = '0') THEN
         dep_nota_o       := dep_nota_o || 'GESTIONE';
      ELSIF (:OLD.livello = '1') THEN
         dep_nota_o       := dep_nota_o || 'SETTORE_A';
      ELSIF (:OLD.livello = '2') THEN
         dep_nota_o       := dep_nota_o || 'SETTORE_B';
      ELSIF (:OLD.livello = '3') THEN
         dep_nota_o       := dep_nota_o || 'SETTORE_C';
      ELSIF (:OLD.livello = '4') THEN
         dep_nota_o       := dep_nota_o || 'SETTORE';
      END IF;

      IF (:OLD.ottica = 'GP4') THEN
         IF     INSERTING
            AND (:NEW.livello < '5') THEN
            si4.sql_execute (   'update ENTE set '
                             || dep_nota
                             || ' = '
                             || ''''
                             || REPLACE (SUBSTR (:NEW.denominazione, 1, 15), '''', '''''')
                             || ''''
                            );
         END IF;

         IF     UPDATING
            AND (:OLD.livello < '5') THEN
            IF (:NEW.livello < '5') THEN
               si4.sql_execute (   'update ENTE set '
                                || dep_nota
                                || ' = '
                                || ''''
                                || REPLACE (SUBSTR (:NEW.denominazione, 1, 15), '''', '''''')
                                || ''''
                               );
            END IF;
         END IF;

         IF DELETING THEN
            IF (:OLD.livello < '5') THEN
               si4.sql_execute ('update ENTE set ' || dep_nota_o || ' = ' || 'TO_CHAR(null)');
            END IF;
         END IF;
      END IF;

      integritypackage.previousnestlevel;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      integritypackage.initnestlevel;
      RAISE;
END;
/
   
