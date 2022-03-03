create or replace trigger inre_inmo_tma
   after delete or insert or update on informazioni_retributive
   for each row
declare
   d_data_agg    date := sysdate;
   d_ni          number(10);
   d_voce        varchar2(10);
   d_progressivo number(10);
begin
   if pxirisfa.individuo_presente(nvl(:old.ci, :new.ci)) = 'SI' then
      begin
         select covo.des_abb
           into d_voce
           from contabilita_voce covo
          where covo.voce in (:old.voce, :new.voce)
            and exists (select 'x'
                   from voci_economiche
                  where codice = covo.voce
                    and specifica = 'SIN')
            and upper(covo.des_abb) <> 'NO';
      
         raise too_many_rows;
      exception
         when too_many_rows then
            select inmo_sq.nextval into d_progressivo from dual;
         
            if deleting then
               insert into individui_modificati
                  (ni
                  ,progressivo
                  ,tabella
                  ,dal
                  ,operazione
                  ,utente
                  ,data_agg
                  ,sindacato
                  ,al
                  ,ci)
               values
                  (gp4_rain.get_ni(:old.ci)
                  ,d_progressivo
                  ,'SINDACATO'
                  ,:old.dal
                  ,'D'
                  ,:old.utente
                  ,d_data_agg
                  ,d_voce
                  ,:old.al
                  ,:old.ci);
            elsif inserting then
               insert into individui_modificati
                  (ni
                  ,progressivo
                  ,tabella
                  ,dal
                  ,operazione
                  ,utente
                  ,data_agg
                  ,sindacato
                  ,al
                  ,ci)
               values
                  (gp4_rain.get_ni(:new.ci)
                  ,d_progressivo
                  ,'SINDACATO'
                  ,:new.dal
                  ,'I'
                  ,:new.utente
                  ,d_data_agg
                  ,d_voce
                  ,:new.al
                  ,:new.ci);
            elsif updating then
               insert into individui_modificati
                  (ni
                  ,progressivo
                  ,tabella
                  ,dal
                  ,operazione
                  ,utente
                  ,data_agg
                  ,sindacato
                  ,al
                  ,ci)
               values
                  (gp4_rain.get_ni(:new.ci)
                  ,d_progressivo
                  ,'SINDACATO'
                  ,:new.dal
                  ,'U'
                  ,:new.utente
                  ,d_data_agg
                  ,d_voce
                  ,:new.al
                  ,:new.ci);
            end if;
         when no_data_found then
            null;
      end;
   end if;
end;
/
/
