create or replace trigger anag_inmo_tma
   after delete or insert or update on anagrafici
   for each row
declare
   d_data_agg    date := sysdate;
   d_progressivo number(10);
begin
   if nvl(:new.tipo_soggetto, :old.tipo_soggetto) = 'I' then
      select inmo_sq.nextval into d_progressivo from dual;
   
      if deleting then
         /* Elimina le precedenti indicazioni di modifica sullo stesso record non ancora trattate e divenute
         inutili nel momento in cui il record e stato definitivamente cancellato */
         delete from individui_modificati
          where ni = :old.ni
            and tabella = 'ANAGRAFICI'
            and dal = :old.dal
            and data_agg <= d_data_agg
            and progressivo < d_progressivo;
      
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,dal
            ,operazione
            ,utente
            ,data_agg)
         values
            (:old.ni
            ,d_progressivo
            ,'ANAGRAFICI'
            ,:old.dal
            ,'D'
            ,si4.utente
            ,d_data_agg);
      elsif inserting then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,dal
            ,operazione
            ,utente
            ,data_agg)
         values
            (:new.ni
            ,d_progressivo
            ,'ANAGRAFICI'
            ,:new.dal
            ,'I'
            ,:new.utente
            ,d_data_agg);
      elsif updating then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,dal
            ,operazione
            ,utente
            ,data_agg)
         values
            (:new.ni
            ,d_progressivo
            ,'ANAGRAFICI'
            ,:new.dal
            ,'U'
            ,:new.utente
            ,d_data_agg);
      end if;
   end if;
end;
/
