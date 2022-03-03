CREATE OR REPLACE TRIGGER STAM_REUO_TMA
AFTER Update Of sequenza,gestione
ON SETTORI_AMMINISTRATIVI 
for each row
declare
   /******************************************************************************
      NAME:
      PURPOSE:   Mantiene l'allineamento tra UNITA_ORGANIZZATIVE e RELAZIONI_UO
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        03/02/2005
      1.1        11/03/2005  MM               Attivita 10116
      1.2        17/10/2006  MS               Mod. Insert
      2.0        26/01/2007  MM               Passaggio alla modalità for each row
      NOTES:
   ******************************************************************************/
begin
   update relazioni_uo
      set gestione = :new.gestione
    where figlio = :new.ni
       or padre = :new.ni;
   update relazioni_uo set sequenza_figlio = :new.sequenza where figlio = :new.ni;
   update relazioni_uo set sequenza_padre = :new.sequenza where padre = :new.ni;
end;
/
