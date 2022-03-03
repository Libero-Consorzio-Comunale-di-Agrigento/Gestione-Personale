CREATE OR REPLACE TRIGGER GEST_PEDO_TMA
AFTER UPDATE
OF PERC_COPERTURA
ON GESTIONI
FOR EACH ROW
declare
   /******************************************************************************
      NAME:     Allinea i campi di PERIODI_DOTAZIONE in caso di modifica degli attributi
                delle percentuali copertura
      PURPOSE:
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        16/03/2005
      1.1        29/03/2005               MM  Attivita 10421.6
      1.2        19/04/2005               CB  Attivita 10729
      1.3        18/07/2005               CB  Attivita 12008
      1.4        19/09/2005         MM  Attivita 12664
   ******************************************************************************/
begin
   update periodi_dotazione
      set ue = decode(sign(nvl(:new.perc_copertura / 100, 100) -
                           nvl(ore / decode(ore_lavoro, 0, 1, ore_lavoro), 0))
                     ,1
                     ,1 / 2
                     ,1)
    where gestione = :new.codice
      and :new.dotazione = 'SI';
exception
   when others then
      raise;
end;
/
