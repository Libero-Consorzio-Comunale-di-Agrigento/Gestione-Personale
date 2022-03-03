create or replace procedure aggiorna_pedo
(
   p_tipo   in varchar2
  ,p_codice in varchar2
  ,p_stato  in varchar2
) is
   /* Procedure di utilità per allineare PEDO in caso di forzature di
      GESTIONI.DOTAZIONE        (a)      p_tipo = 'GESTIONE'
      CLASSI_RAPPORTO.DOTAZIONE (b)      p_tipo = 'RAPPORTO'
      il codice sarà, a seconda del tipo un codice di gestione o di classe di rapporto.
      lo stato assume i valori:
      ON  : crea le registrazioni su PERIODI_DOTAZIONE se compatibile con (a) o (b)
      OFF : elimina le eventuali registrazioni su PERIODI_DOTAZIONE se compatibile con (a) o (b)
   */
   d_dummy varchar2(1);
   esci exception;
begin
   dbms_output.enable(1000000);
   begin
      /* Verifica preventiva di compatibilità tra i parametri proposti
         e le impostazioni sul db
      */
      if p_tipo = 'GESTIONE' and p_stato = 'ON' and
         gp4_gest.get_dotazione(p_codice) = 'NO' or
         p_tipo = 'GESTIONE' and p_stato = 'OFF' and
         gp4_gest.get_dotazione(p_codice) = 'SI' then
         raise esci;
      end if;
      if p_tipo = 'RAPPORTO' then
         begin
            select 'x'
              into d_dummy
              from classi_rapporto
             where (codice = p_codice and p_stato = 'ON' and dotazione = 'NO')
                or (codice = p_codice and p_stato = 'OFF' and dotazione = 'SI');
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               raise esci;
         end;
      end if;
      --or p_tipo = 'RAPPORTO' and p_stato = 'ON' and gp4_gest.get_dotazione(p_codice)='NO'
      lock table periodi_giuridici in exclusive mode nowait;
      lock table periodi_dotazione in exclusive mode nowait;
   
      si4.sql_execute('alter table periodi_giuridici disable all triggers');
      si4.sql_execute('alter trigger pegi_pedo_tma enable');
      if p_stato = 'ON' then
         -- esegue l'allineamento di PERIODI_DOTAZIONE alle revisioni esistenti
         -- attivando il trigger PEGI_PEDO_TMA
         if p_tipo = 'GESTIONE' then
            update periodi_giuridici
               set ci = ci + 0
             where rilevanza in ('Q', 'S', 'I', 'E')
               and gestione = p_codice;
         elsif p_tipo = 'RAPPORTO' then
            update periodi_giuridici
               set ci = ci + 0
             where rilevanza in ('Q', 'S', 'I', 'E')
               and ci in (select ci from rapporti_individuali where rapporto = p_codice);
         else
            raise esci;
         end if;
      else
         if p_tipo = 'GESTIONE' then
            delete from periodi_dotazione where gestione = p_codice;
         elsif p_tipo = 'RAPPORTO' then
            delete from periodi_dotazione
             where ci in (select ci from rapporti_individuali where rapporto = p_codice);
         else
            raise esci;
         end if;
      end if;
   
      si4.sql_execute('alter table periodi_giuridici enable all triggers');
   exception
      when esci then
         dbms_output.put_line('Parametri errati');
         null;
   end;
end aggiorna_pedo;
/
