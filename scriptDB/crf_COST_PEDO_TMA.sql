create or replace trigger cost_pedo_tma
   after insert or update of ore_lavoro
   on contratti_storici
   for each row
declare
   /******************************************************************************
      NAME:     Allinea i campi di PERIODI_DOTAZIONE in caso di modifica degli attributi
                del contratto
      PURPOSE:
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        04/02/2005
      1.1        15/06/2007  MM               A21621
   ******************************************************************************/
   d_ue             number;
   d_perc_copertura number;
begin
   for pedo in (select rowid
                      ,ci
                      ,dal
                      ,al
                      ,rilevanza
                      ,gestione
                      ,ore
                      ,ore_lavoro
                  from periodi_dotazione
                 where contratto = :new.contratto
                   and nvl(al, to_date(3333333, 'j')) between :new.dal and
                       nvl(:new.al, to_date(3333333, 'j')))
   loop
      begin
         if :new.ore_lavoro = 0 then
            d_ue := 1;
         else
            d_ue := pedo.ore / :new.ore_lavoro;
         end if;
         d_perc_copertura := gp4_gest.get_perc_copertura(pedo.gestione);
         if d_perc_copertura is not null then
            if d_ue > d_perc_copertura / 100 then
               d_ue := 1;
            else
               d_ue := 0.5;
            end if;
         end if;
         update periodi_dotazione
            set ore_lavoro = :new.ore_lavoro
               ,ue         = d_ue
          where rowid = pedo.rowid;
      end;
   end loop;
exception
   when others then
      -- Consider logging the error and then re-raise
      raise;
end;
/
