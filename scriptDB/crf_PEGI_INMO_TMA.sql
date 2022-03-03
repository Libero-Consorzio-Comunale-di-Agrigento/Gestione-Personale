create or replace trigger pegi_inmo_tma
   after delete or insert or update on periodi_giuridici
   for each row
declare
   d_data_agg    date := sysdate;
   d_progressivo number(10);
   d_ni          rapporti_individuali.ni%type := gp4_rain.get_ni(nvl(:old.ci, :new.ci));
begin
   if nvl(:old.rilevanza, :new.rilevanza) =
      pxirisfa.rilevanza_utile(nvl(:old.ci, :new.ci)) then
      -- rileva modifica per PERIODI_GIURIDICI
      select inmo_sq.nextval into d_progressivo from dual;
   
      if deleting then
         /* Elimina le precedenti indicazioni di modifica sullo stesso record non ancora trattate e divenute
         inutili nel momento in cui il record e stato definitivamente cancellato */
         delete from individui_modificati
          where ci = :old.ci
            and rilevanza = :old.rilevanza
            and tabella = 'PERIODI_GIURIDICI'
            and dal = :old.dal
            and data_agg <= d_data_agg
            and progressivo < d_progressivo;
      
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'PERIODI_GIURIDICI'
            ,:old.rilevanza
            ,:old.dal
            ,'D'
            ,si4.utente
            ,d_data_agg
            ,:old.ci);
      elsif inserting and :new.utente <> 'Aut.IRIS' then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'PERIODI_GIURIDICI'
            ,:new.rilevanza
            ,:new.dal
            ,'I'
            ,:new.utente
            ,d_data_agg
            ,:new.ci);
      elsif updating and :new.utente <> 'Aut.IRIS' then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'PERIODI_GIURIDICI'
            ,:old.rilevanza
            ,:new.dal
            ,'U'
            ,:new.utente
            ,sysdate
            ,:old.ci);
      end if;
   
      -- rileva modifica per CODICI_MINIST
      select inmo_sq.nextval into d_progressivo from dual;
   
      if deleting then
         /* Elimina le precedenti indicazioni di modifica sullo stesso record non ancora trattate e divenute
         inutili nel momento in cui il record e stato definitivamente cancellato */
         delete from individui_modificati
          where ci = :old.ci
            and rilevanza = :old.rilevanza
            and tabella = 'CODICI_MINIST'
            and dal = :old.dal
            and data_agg <= d_data_agg
            and progressivo < d_progressivo;
      
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'CODICI_MINIST'
            ,:old.rilevanza
            ,:old.dal
            ,'D'
            ,si4.utente
            ,sysdate
            ,:old.ci);
      elsif inserting and :new.utente <> 'Aut.IRIS' then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'CODICI_MINIST'
            ,:new.rilevanza
            ,:new.dal
            ,'I'
            ,:new.utente
            ,d_data_agg
            ,:new.ci);
      elsif updating and :new.utente <> 'Aut.IRIS' then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'CODICI_MINIST'
            ,:old.rilevanza
            ,:new.dal
            ,'U'
            ,:new.utente
            ,sysdate
            ,:old.ci);
      end if;
   end if;

   if nvl(:old.rilevanza, :new.rilevanza) = 'P' and
      pxirisfa.individuo_presente(nvl(:old.ci, :new.ci)) = 'SI' then
      -- rileva modifica per PERIODI_RAPPORTO
      select inmo_sq.nextval into d_progressivo from dual;
   
      if deleting then
         /* Elimina le precedenti indicazioni di modifica sullo stesso record non ancora trattate e divenute
         inutili nel momento in cui il record e stato definitivamente cancellato */
         delete from individui_modificati
          where ci = :old.ci
            and rilevanza = :old.rilevanza
            and tabella = 'PERIODI_RAPPORTO'
            and dal = :old.dal
            and data_agg <= d_data_agg
            and progressivo < d_progressivo;
      
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'PERIODI_RAPPORTO'
            ,:old.rilevanza
            ,:old.dal
            ,'D'
            ,si4.utente
            ,sysdate
            ,:old.ci);
      elsif inserting then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,d_progressivo
            ,'PERIODI_RAPPORTO'
            ,:new.rilevanza
            ,:new.dal
            ,'I'
            ,:new.utente
            ,d_data_agg
            ,:new.ci);
      elsif updating then
         insert into individui_modificati
            (ni
            ,progressivo
            ,tabella
            ,rilevanza
            ,dal
            ,operazione
            ,utente
            ,data_agg
            ,ci)
         values
            (d_ni
            ,evpa_sq.nextval
            ,'PERIODI_RAPPORTO'
            ,:old.rilevanza
            ,:new.dal
            ,'U'
            ,:new.utente
            ,sysdate
            ,:old.ci);
      end if;
   end if;
end;
/
