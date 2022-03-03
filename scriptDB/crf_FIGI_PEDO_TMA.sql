create or replace trigger figi_pedo_tma
   after insert or update of codice, profilo, posizione on figure_giuridiche
   for each row
/******************************************************************************
   NAME:     Allinea i campi di PERIODI_DOTAZIONE in caso di modifica degli attributi
             della figura professionale
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/02/2005
   1.1        15/06/2007  MM               A21621   
******************************************************************************/
declare
   d_cod_qualifica qualifiche_giuridiche.codice%type;
   d_ruolo         qualifiche_giuridiche.ruolo%type;
   d_contratto     qualifiche_giuridiche.contratto%type;
   d_livello       qualifiche_giuridiche.livello%type;
begin
   begin
      select codice
            ,ruolo
            ,contratto
            ,livello
        into d_cod_qualifica
            ,d_ruolo
            ,d_contratto
            ,d_livello
        from qualifiche_giuridiche
       where numero = :new.qualifica
         and nvl(:new.al, to_date(3333333, 'j')) between dal and
             nvl(al, to_date(3333333, 'j'));
   exception
      when no_data_found then
         d_cod_qualifica := null;
         d_ruolo         := null;
         d_livello       := null;
         d_contratto     := null;
   end;

   update periodi_dotazione
      set profilo       = :new.profilo
         ,cod_figura    = :new.codice
         ,pos_funz      = :new.posizione
         ,cod_qualifica = decode(rilevanza
                                ,'Q'
                                ,d_cod_qualifica
                                ,'I'
                                ,d_cod_qualifica
                                ,cod_qualifica)
         ,qualifica     = decode(rilevanza
                                ,'Q'
                                ,:new.qualifica
                                ,'I'
                                ,:new.qualifica
                                ,qualifica)
         ,ruolo         = decode(rilevanza, 'Q', d_ruolo, 'I', d_ruolo, ruolo)
         ,livello       = decode(rilevanza, 'Q', d_livello, 'I', d_livello, livello)
         ,contratto     = decode(rilevanza, 'Q', d_contratto, 'I', d_contratto, contratto)
    where figura = :new.numero
      and nvl(al, to_date(3333333, 'j')) between :new.dal and
          nvl(:new.al, to_date(3333333, 'j'));
exception
   when others then
      -- Consider logging the error and then re-raise
      raise;
end;
/
