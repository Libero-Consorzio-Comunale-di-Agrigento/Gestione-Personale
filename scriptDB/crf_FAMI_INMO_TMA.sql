CREATE OR REPLACE TRIGGER fami_inmo_tma
   AFTER DELETE OR INSERT OR UPDATE
   ON familiari
   FOR EACH ROW
declare
   d_data_agg    date := sysdate;
   d_progressivo number(10);
   d_dummy       varchar2(1);
begin
   select inmo_sq.nextval into d_progressivo from dual;

   if deleting then
      /* Elimina le precedenti indicazioni di modifica sullo stesso record non ancora trattate e divenute
      inutili nel momento in cui il record e stato definitivamente cancellato */
      delete from individui_modificati
       where ni = :old.ni
         and tabella = 'FAMILIARI'
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
         ,'FAMILIARI'
         ,:old.dal
         ,'D'
         ,si4.utente
         ,d_data_agg);
   end if;
   if inserting or updating then
      begin
         select 'x'
           into d_dummy
           from individui_modificati
          where ni = :new.ni
            and tabella = 'FAMILIARI'
            and operazione in ('I', 'U');
         raise too_many_rows;
      exception
         when no_data_found then
            begin
               if inserting then
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
                     ,'FAMILIARI'
                     ,:new.dal
                     ,'I'
                     ,si4.utente
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
                     ,'FAMILIARI'
                     ,:new.dal
                     ,'U'
                     ,si4.utente
                     ,d_data_agg);
               end if;
            end;
         when too_many_rows then
            null;
      end;
   end if;
end;
/
