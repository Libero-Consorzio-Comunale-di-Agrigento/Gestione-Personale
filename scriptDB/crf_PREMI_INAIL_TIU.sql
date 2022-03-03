CREATE OR REPLACE TRIGGER premi_inail_tiu
   BEFORE INSERT
   ON premi_inail
   FOR EACH ROW
DECLARE
   d_prin_id   NUMBER;
BEGIN
   IF :NEW.prin_id IS NULL THEN
      SELECT prin_sq.NEXTVAL
        INTO d_prin_id
        FROM DUAL;

      :NEW.prin_id     := d_prin_id;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END premi_inail_tiu;
/
/

