CREATE OR REPLACE TRIGGER CTEV_RAPA_T
 AFTER INSERT OR UPDATE OR DELETE ON CATEGORIE_EVENTO
FOR EACH ROW

BEGIN
  UPDATE RAPPORTI_PRESENZA
     SET flag_ec = 'M'
   WHERE EXISTS
        (SELECT 'x' FROM dual
		  WHERE NVL(:NEW.dal,TO_DATE(3333333,'j')) <> NVL(:OLD.dal,TO_DATE(3333333,'j'))
		     OR NVL(:NEW.al,TO_DATE(3333333,'j'))  <> NVL(:OLD.al,TO_DATE(3333333,'j'))
		     OR NVL(:NEW.gestione,' ')             <> NVL(:OLD.gestione,' ')
		     OR NVL(:NEW.opzione,' ')              <> NVL(:OLD.opzione,' ')
		     OR NVL(:NEW.segno,' ')                <> NVL(:OLD.segno,' ')
		     OR NVL(:NEW.voce,' ')                 <> NVL(:OLD.voce,' ')
		     OR NVL(:NEW.sub,' ')                  <> NVL(:OLD.sub,' ')
		)
  ;
END;
/ 

