create or replace trigger rqmi_inmo_tma
   after insert or update on righe_qualifica_ministeriale
   for each row
declare
   d_data_agg    date := sysdate;
   d_progressivo number(10);
begin
 -- rileva modifica per CODICI_MINIST
   if inserting then
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
         select rain.ni
               ,inmo_sq.nextval
               ,'CODICI_MINIST'
               ,pegi.rilevanza
               ,pegi.dal
               ,'I'
               ,si4.utente
               ,d_data_agg
               ,pegi.ci
           from periodi_giuridici     pegi
               ,posizioni             posi
               ,figure_giuridiche     figi
               ,qualifiche_giuridiche qugi
               ,rapporti_individuali  rain
          where rain.ci = pegi.ci
            and pegi.rilevanza = 'S'
            and qugi.numero = pegi.qualifica
            and figi.numero = pegi.figura
            and pegi.dal between figi.dal and nvl(figi.al, pegi.dal)
            and pegi.dal between qugi.dal and nvl(qugi.al, pegi.dal)
            and pegi.dal <= nvl(:new.al, to_date('3333333', 'j'))
            and nvl(pegi.al, to_date('3333333', 'j')) >= :new.dal
            and nvl(pegi.al, to_date('3333333', 'j')) between rain.dal and
                nvl(rain.al, to_date('3333333', 'j'))
            and posi.codice = pegi.posizione
            and pxirisfa.individuo_presente(pegi.ci) = 'SI'
            and nvl(:new.di_ruolo, posi.di_ruolo) = posi.di_ruolo
            and nvl(:new.tempo_determinato, posi.tempo_determinato) =
                posi.tempo_determinato
            and nvl(:new.part_time, posi.part_time) = posi.part_time
            and nvl(:new.tipo_rapporto, nvl(pegi.tipo_rapporto, 'NULL')) =
                nvl(pegi.tipo_rapporto, 'NULL')
            and ((:new.qualifica is null and :new.figura = pegi.figura) or
                (:new.figura is null and :new.qualifica = pegi.qualifica) or
                (:new.qualifica is not null and :new.figura is not null and
                :new.qualifica = pegi.qualifica and :new.figura = pegi.figura) or
                (:new.qualifica is null and :new.figura is null))
            and not exists (select 'x'
                   from individui_modificati
                  where ci = pegi.ci
                    and tabella = 'CODICI_MINIST');
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
         select rain.ni
               ,inmo_sq.nextval
               ,'CODICI_MINIST'
               ,pegi.rilevanza
               ,pegi.dal
               ,'U'
               ,si4.utente
               ,d_data_agg
               ,pegi.ci
           from periodi_giuridici     pegi
               ,posizioni             posi
               ,figure_giuridiche     figi
               ,qualifiche_giuridiche qugi
               ,rapporti_individuali  rain
          where rain.ci = pegi.ci
            and pegi.rilevanza = 'S'
            and qugi.numero = pegi.qualifica
            and figi.numero = pegi.figura
            and pegi.dal between figi.dal and nvl(figi.al, pegi.dal)
            and pegi.dal between qugi.dal and nvl(qugi.al, pegi.dal)
            and pegi.dal <= nvl(:new.al, to_date('3333333', 'j'))
            and nvl(pegi.al, to_date('3333333', 'j')) >= :new.dal
            and nvl(pegi.al, to_date('3333333', 'j')) between rain.dal and
                nvl(rain.al, to_date('3333333', 'j'))
            and posi.codice = pegi.posizione
            and pxirisfa.individuo_presente(pegi.ci) = 'SI'
            and nvl(:new.di_ruolo, posi.di_ruolo) = posi.di_ruolo
            and nvl(:new.tempo_determinato, posi.tempo_determinato) =
                posi.tempo_determinato
            and nvl(:new.part_time, posi.part_time) = posi.part_time
            and nvl(:new.tipo_rapporto, nvl(pegi.tipo_rapporto, 'NULL')) =
                nvl(pegi.tipo_rapporto, 'NULL')
            and ((:new.qualifica is null and :new.figura = pegi.figura) or
                (:new.figura is null and :new.qualifica = pegi.qualifica) or
                (:new.qualifica is not null and :new.figura is not null and
                :new.qualifica = pegi.qualifica and :new.figura = pegi.figura) or
                (:new.qualifica is null and :new.figura is null))
            and not exists (select 'x'
                   from individui_modificati
                  where ci = pegi.ci
                    and tabella = 'CODICI_MINIST');
   end if;
end;
/
/
