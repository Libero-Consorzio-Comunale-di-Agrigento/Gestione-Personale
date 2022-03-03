create or replace trigger qugi_pedo_tma
   after insert or update of contratto, codice, ruolo, livello,al on qualifiche_giuridiche
   for each row
   /******************************************************************************
      NAME:     Allinea i campi di PERIODI_DOTAZIONE in caso di modifica degli attributi
                della qualifica retributiva
      PURPOSE:
   
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        04/02/2005
      1.1        15/06/2007  MM               A21621
   
   ******************************************************************************/
declare
   d_ore_lavoro      contratti_storici.ore_lavoro%type := 0;
   d_ue              periodi_dotazione.ue%type;
   d_nuovo_contratto number(1) := 0;
   d_perc_copertura  gestioni.perc_copertura%type;
begin

   if :new.contratto <> :old.contratto or inserting then
      select ore_lavoro
        into d_ore_lavoro
        from contratti_storici
       where contratto = :new.contratto
         and nvl(:new.al, to_date(3333333, 'j')) between dal and
             nvl(al, to_date(3333333, 'j'));
   
      d_nuovo_contratto := 1;
   
   end if;

   if d_nuovo_contratto = 0 then
      update periodi_dotazione
         set ruolo         = :new.ruolo
            ,cod_qualifica = :new.codice
            ,livello       = :new.livello
            ,contratto     = :new.contratto
       where qualifica = :new.numero
         and nvl(al, to_date(3333333, 'j')) between :new.dal and
             nvl(:new.al, to_date(3333333, 'j'));
   else
      for pedo in (select ci
                         ,rilevanza
                         ,dal
                         ,al
                         ,gestione
                         ,ore
                         ,ore_lavoro
                         ,rowid
                     from periodi_dotazione
                    where qualifica = :new.numero
                      and nvl(al, to_date(3333333, 'j')) between :new.dal and
                          nvl(:new.al, to_date(3333333, 'j')))
      loop
      
         d_perc_copertura := gp4_gest.get_perc_copertura(pedo.gestione);
      
         if d_ore_lavoro = 0 then
            d_ue := 1;
         else
            d_ue := pedo.ore / d_ore_lavoro;
         end if;
      
         if d_perc_copertura is not null then
            if d_ue > d_perc_copertura / 100 then
               d_ue := 1;
            else
               d_ue := 1 / 2;
            end if;
         end if;
      
         update periodi_dotazione
            set ruolo         = :new.ruolo
               ,cod_qualifica = :new.codice
               ,livello       = :new.livello
               ,contratto     = :new.contratto
               ,ore_lavoro    = d_ore_lavoro
               ,ue            = d_ue
          where rowid = pedo.rowid;
      end loop;
   end if;
exception
   when others then
      -- Consider logging the error and then re-raise
      raise;
end;
/
