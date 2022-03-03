CREATE OR REPLACE TRIGGER DDMA_TB
   before INSERT or UPDATE or DELETE on DENUNCIA_DMA
BEGIN
   IF IntegrityPackage.GetNestLevel = 0 THEN
      IntegrityPackage.InitNestLevel;
   END IF;
END;

/ 
