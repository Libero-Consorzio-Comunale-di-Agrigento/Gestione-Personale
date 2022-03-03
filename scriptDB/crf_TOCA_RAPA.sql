CREATE OR REPLACE TRIGGER TOCA_RAPA_T
 AFTER INSERT OR UPDATE OR DELETE ON TOTALIZZAZIONE_CAUSALI
FOR EACH ROW
DECLARE
BEGIN
  UPDATE RAPPORTI_PRESENZA
     SET flag_ec = 'M'
   WHERE EXISTS
        (SELECT 'x' FROM dual
		  WHERE NVL(:NEW.causale,TO_DATE(3333333,'j')) <> NVL(:OLD.causale,TO_DATE(3333333,'j'))
		     OR NVL(:NEW.segno,TO_DATE(3333333,'j'))   <> NVL(:OLD.segno,TO_DATE(3333333,'j'))
		     OR NVL(:NEW.gestione,' ')                 <> NVL(:OLD.gestione,' ')
		     OR NVL(:NEW.riferimento_mm,' ')           <> NVL(:OLD.riferimento_mm,' ')
		     OR NVL(:NEW.riferimento_gg,' ')           <> NVL(:OLD.riferimento_gg,' ')
		)
     and exists
        (select 'x' from categorie_evento
          where codice = :NEW.categoria
            and voce  is not null
        )
  ;
END;
/ 
