CREATE OR REPLACE TRIGGER RARS_TB
   before INSERT or UPDATE or DELETE on RAPPORTI_RETRIBUTIVI_STORICI
BEGIN
   IF IntegrityPackage.GetNestLevel = 0 THEN
      IntegrityPackage.InitNestLevel;
   END IF;
END;

/ 
