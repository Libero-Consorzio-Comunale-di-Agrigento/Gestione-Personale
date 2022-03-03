create or replace package ppacderi is
   s_prenotazione        a_prenotazioni.no_prenotazione%type;
   s_passo               a_prenotazioni.numero_passo%type;
   s_errore_prenotazione a_errori.errore%type := to_char(null);
   s_tipo_id_dipendente  ente.rilevazione_presenze%type;
   s_variabili_gape      number(1);
   s_fin_ela             date;
   procedure main
   (
      prenotazione in number
     ,passo        in number
   );
   function versione return varchar2;
   function get_ci
   (
      p_matricola in number
     ,p_data      in date
   ) return number;
   function get_progressivo return number;
   function get_causale(p_giustificativo in varchar2) return varchar2;
   function get_voce(p_causale in varchar2) return varchar2;
   function get_riferimento
   (
      p_ci   in number
     ,p_data in date
   ) return date;
   procedure log_trace
   (
      p_trc          in number -- Tipo di Trace
     ,p_prn          in number -- Nr di prenotazione in elaborazione
     ,p_pas          in number -- Nr di passo procedurale
     ,p_prs          in out number -- Nr progressivo di segnalazione
     ,p_stp          in varchar2 -- Identificazione dello step in oggetto
     ,p_tim          in out varchar2 -- Time impiegato in secondi
     ,p_errore       in out varchar2 -- Errore da segnalare
     ,p_segnalazione in out varchar2
   );
end;
/
create or replace package body ppacderi is
   function versione return varchar2 is
   begin
      return 'V3.0 del 27/03/2007';
   end versione;
   function get_ci
   (
      p_matricola in number
     ,p_data      in date
   ) return number is
      d_ci rapporti_individuali.ci%type;
   begin
      begin
         select rain.ci
           into d_ci
           from rapporti_individuali rain
               ,rapporti_retributivi rare
               ,classi_rapporto      clra
          where p_matricola = decode(s_tipo_id_dipendente
                                    ,'C'
                                    ,rain.ci
                                    ,'M'
                                    ,rare.matricola
                                    ,'N'
                                    ,rain.ni)
            and rare.ci = rain.ci
            and clra.codice = rain.rapporto
            and clra.presenza = 'SI'
            and nvl(p_data, to_date(3333333, 'j')) between rain.dal and
                nvl(rain.al, to_date(3333333, 'j'));
         return d_ci;
      exception
         when no_data_found or too_many_rows then
            d_ci := null;
            return d_ci;
      end;
   end get_ci;
   --
   function get_progressivo return number is
      d_progressivo number;
   begin
      begin
         --Preleva nr max di segnalazioni
         select nvl(max(progressivo), 0)
           into d_progressivo
           from a_segnalazioni_errore
          where no_prenotazione = s_prenotazione
            and passo = s_passo;
         return d_progressivo;
      exception
         when no_data_found or too_many_rows then
            d_progressivo := null;
            return d_progressivo;
      end;
   end get_progressivo;
   --
   function get_causale(p_giustificativo in varchar2) return varchar2 is
      d_causale causali_evento.codice%type := to_char(null);
   begin
      begin
         select cagi.causale
           into d_causale
           from causali_giustificativo cagi
          where cagi.da_a = 'A'
            and cagi.codice = p_giustificativo;
         return d_causale;
      exception
         when no_data_found or too_many_rows then
            return d_causale;
      end;
   end get_causale;
   --
   function get_voce(p_causale in varchar2) return varchar2 is
      d_voce varchar2(12) := to_char(null);
   begin
      begin
         select rpad(translate(caev.voce, ' ', '?'), 10, ' ') ||
                rpad(translate(caev.sub, ' ', '?'), 2, ' ')
           into d_voce
           from causali_evento caev
          where codice = p_causale;
         return d_voce;
      exception
         when no_data_found or too_many_rows then
            return d_voce;
      end;
   end get_voce;
   --
   function get_riferimento
   (
      p_ci   in number
     ,p_data in date
   ) return date is
      d_riferimento date;
      d_dummy       varchar2(1);
      /******************************************************************************
      ******************************************************************************/
   begin
      d_riferimento := p_data;
      if d_riferimento > s_fin_ela then
         d_riferimento := s_fin_ela;
      end if;
      begin
         select 'x'
           into d_dummy
           from periodi_giuridici
          where ci = p_ci
            and rilevanza = 'S'
            and p_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            begin
               select max(al)
                 into d_riferimento
                 from periodi_giuridici
                where ci = p_ci
                  and rilevanza = 'S'
                  and dal <= p_data;
               if d_riferimento is null then
                  select min(dal)
                    into d_riferimento
                    from periodi_giuridici
                   where ci = p_ci
                     and rilevanza = 'S'
                     and dal >= p_data;
               end if;
            end;
      end;
      return d_riferimento;
   end get_riferimento;
   procedure log_trace
   (
      p_trc          in number -- Tipo di Trace
     ,p_prn          in number -- Numero di Prenotazione elaborazione
     ,p_pas          in number -- Numero di Passo procedurale
     ,p_prs          in out number -- Numero progressivo di Segnalazione
     ,p_stp          in varchar2 -- Identificazione dello Step in oggetto
     ,p_tim          in out varchar2 -- Time impiegato in secondi
     ,p_errore       in out varchar2 -- Errore da segnalare
     ,p_segnalazione in out varchar2 -- Decodifica errore da segnalare
   ) is
      d_ora     varchar2(8); -- Ora:minuti.secondi
      d_systime number;
   begin
      if p_trc is not null then
         d_systime := to_number(to_char(sysdate, 'sssss'));
         if d_systime < to_number(p_tim) then
            p_tim := to_char(86400 - to_number(p_tim) + d_systime);
         else
            p_tim := to_char(d_systime - to_number(p_tim));
         end if;
         d_ora := to_char(sysdate, 'hh24:mi.ss');
         p_prs := p_prs + 1;
         if p_trc = 0 then
            -- Inizio elaborazione
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05800'
               ,rpad(substr(p_stp, 1, 21), 21) || 'h.' || d_ora);
         elsif p_trc in (1, 3, 4, 5, 6, 7, 8) then
            -- varie
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,p_errore
               ,p_segnalazione);
         elsif p_trc = 2 then
            -- Segnalazione di Stop
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05802'
               ,rpad(substr(p_stp, 1, 20), 20) || ' h.' || d_ora || ' (' || p_tim || '")');
         end if;
         if s_errore_prenotazione is null and p_trc in (3, 7) then
            s_errore_prenotazione := 'P00108';
         end if;
         if nvl(s_errore_prenotazione, 'P00108') = 'P00108' and p_trc in (1, 4, 5, 6, 8) then
            s_errore_prenotazione := 'P00109';
         end if;
      end if;
      p_tim := to_char(sysdate, 'sssss');
   end log_trace;
   --
   procedure main
   (
      prenotazione in number
     ,passo        in number
   ) is
   begin
      declare
         d_ci           rapporti_individuali.ci%type;
         d_causale      eventi_presenza.causale%type;
         d_dal          date;
         d_al           date;
         d_riferimento  date;
         d_errore       varchar2(6);
         d_segnalazione a_segnalazioni_errore.precisazione%type;
         d_ini_mes      date;
         d_fin_mes      date;
         d_software     eventi_presenza.utente%type;
         d_prn          number;
         d_pas          number;
         d_prs          number;
         d_stp          varchar2(100);
         d_tim          varchar2(100);
         d_formato_data varchar2(8) := 'yyyymmdd';
         prossimo exception;
         errore exception;
         esci exception;
      begin
         s_passo        := passo;
         s_prenotazione := prenotazione;
         /*      Segnalazione di inizio elaborazione
         */
         begin
            d_stp          := null;
            d_tim          := to_char(sysdate, 'sssss');
            d_prs          := get_progressivo;
            d_prn          := s_prenotazione;
            d_pas          := s_passo;
            d_errore       := null;
            d_segnalazione := ' ';
            log_trace(0, d_prn, d_pas, d_prs, d_stp, d_tim, d_errore, d_segnalazione);
         end;
         /*
                   +--------------------------------------------------------+
                   | Memorizzazione dati del periodo di riferimento della   |
                   | gestione presenze-assenze.                             |
                   +--------------------------------------------------------+
         */
         begin
            select ini_mes
                  ,fin_mes
              into d_ini_mes
                  ,d_fin_mes
              from riferimento_presenza
             where ripa_id = 'RIPA';
         exception
            when no_data_found then
               d_errore := 'P07000';
               raise errore;
         end;
         begin
            select fin_ela
              into s_fin_ela
              from riferimento_retribuzione
             where rire_id = 'RIRE';
         exception
            when no_data_found then
               d_errore := 'P07000';
               raise errore;
         end;
         /*
                   +--------------------------------------------------------------------------------+
                   | Determinazione del codice del software di rilevazione presenze dalle selezioni |
                   +--------------------------------------------------------------------------------+
         */
         begin
            select valore_default
              into d_software
              from a_selezioni
             where voce_menu = 'PPACDERI'
               and parametro = 'P_SOFTWARE';
         exception
            when no_data_found then
               begin
                  select distinct deri.utente
                    into d_software
                    from deposito_eventi_rilevazione deri
                   where utente <> 'CANCELLA';
               exception
                  when no_data_found then
                     -- nessuna registrazione
                     d_stp          := null;
                     d_tim          := to_char(sysdate, 'sssss');
                     d_prs          := get_progressivo;
                     d_prn          := s_prenotazione;
                     d_pas          := s_passo;
                     d_errore       := 'P07404';
                     d_segnalazione := ' ';
                     log_trace(4
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,d_tim
                              ,d_errore
                              ,d_segnalazione);
                     raise esci;
                  when too_many_rows then
                     -- origini multiple
                     d_stp          := null;
                     d_tim          := to_char(sysdate, 'sssss');
                     d_prs          := get_progressivo;
                     d_prn          := s_prenotazione;
                     d_pas          := s_passo;
                     d_errore       := 'P07403';
                     d_segnalazione := ' ';
                     log_trace(3
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,d_tim
                              ,d_errore
                              ,d_segnalazione);
               end;
               d_software := '%';
         end;
         /*
                   +-------------------------------------------------------+
                   | Memorizzazione variabili_gape da tabella ENTE.        |
                   +-------------------------------------------------------+
         */
         begin
            select nvl(ente.variabili_gape, 0)
                  ,nvl(ente.rilevazione_presenze, 'C')
              into s_variabili_gape
                  ,s_tipo_id_dipendente
              from ente
             where ente_id = 'ENTE';
         exception
            when too_many_rows or no_data_found then
               d_errore := 'A00003';
               raise errore;
         end;
         /*
                   +--------------------------------------------------------+
                   | Precedente gestione delle cancellazioni da IRIS        |
                   | Non viene piu utilizzata, ma e ancora disponibile tra  |
                   | le funzionilta di MONDOEDP, per cui la manteniamo,     |
                   | almeno formalmente.                                    |
                   +--------------------------------------------------------+
                   | Cancello records con utente CANCELLA                   |
                   +--------------------------------------------------------+
         */
         d_formato_data := 'yyyymmdd';
         begin
            select 'x'
              into d_errore
              from riferimento_presenza ripa
             where ripa.ripa_id = 'RIPA'
               and exists
             (select 'x'
                      from deposito_eventi_rilevazione deri
                     where to_date(deri.data_agg, d_formato_data /*'yyyymmdd'*/) <>
                           ripa.fin_mes
                       and utente = 'CANCELLA');
            raise too_many_rows;
         exception
            when too_many_rows then
               d_stp          := null;
               d_tim          := to_char(sysdate, 'sssss');
               d_prs          := get_progressivo;
               d_prn          := s_prenotazione;
               d_pas          := s_passo;
               d_errore       := 'P07402';
               d_segnalazione := ' nell''origine ' || 'CANCELLA';
               log_trace(5, d_prn, d_pas, d_prs, d_stp, d_tim, d_errore, d_segnalazione);
               raise errore;
            when no_data_found then
               d_formato_data := '';
               null;
            when others then
            
               d_formato_data := 'ddmmyyyy';
               begin
                  select 'x'
                    into d_errore
                    from riferimento_presenza ripa
                   where ripa.ripa_id = 'RIPA'
                     and exists
                   (select 'x'
                            from deposito_eventi_rilevazione deri
                           where to_date(deri.data_agg, d_formato_data /*'ddmmyyyy'*/) <>
                                 ripa.fin_mes
                             and utente = 'CANCELLA');
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     d_stp          := null;
                     d_tim          := to_char(sysdate, 'sssss');
                     d_prs          := get_progressivo;
                     d_prn          := s_prenotazione;
                     d_pas          := s_passo;
                     d_errore       := 'P07402';
                     d_segnalazione := ' nell''origine ' || 'CANCELLA';
                     log_trace(5
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,d_tim
                              ,d_errore
                              ,d_segnalazione);
                     raise errore;
                  when no_data_found then
                     null;
               end;
         end;
         if d_formato_data is not null then
            begin
               dbms_output.put_line('formato: ' || d_formato_data);
               for cancella in (select nvl(deri.evento, evpa_sq.nextval) evento
                                      ,rain.ci ci
                                      ,cagi.causale causale
                                      ,decode(cagi.motivo, '%', null, cagi.motivo) motivo
                                      ,decode(to_date(deri.dal, d_formato_data)
                                             ,d_ini_mes
                                             ,greatest(to_date(deri.dal, d_formato_data)
                                                      ,rain.dal)
                                             ,to_date(deri.dal, d_formato_data)) dal
                                      ,decode(to_date(deri.al, d_formato_data)
                                             ,d_fin_mes
                                             ,least(to_date(deri.al, d_formato_data)
                                                   ,nvl(ragi.al, d_fin_mes))
                                             ,to_date(deri.al, d_formato_data)) al
                                      ,to_date(deri.riferimento, d_formato_data) riferimento
                                      ,'SI' chiuso
                                      ,deri.input input
                                      ,deri.classe classe
                                      ,deri.dalle dalle
                                      ,deri.alle alle
                                      ,substr(deri.valore, instr(valore, '-')) valore
                                      ,deri.cdc cdc
                                      ,deri.sede sede
                                      ,deri.note note
                                      ,deri.utente utente
                                      ,to_date(deri.data_agg, d_formato_data) data_agg
                                  from deposito_eventi_rilevazione deri
                                      ,causali_giustificativo      cagi
                                      ,rapporti_individuali        rain
                                      ,classi_rapporto             clra
                                      ,rapporti_retributivi        rare
                                      ,rapporti_giuridici          ragi
                                 where cagi.da_a = 'A'
                                   and ragi.ci = rare.ci
                                   and cagi.codice = deri.giustificativo
                                   and deri.ci = decode(s_tipo_id_dipendente
                                                       ,'C'
                                                       ,rain.ci
                                                       ,'M'
                                                       ,rare.matricola
                                                       ,'N'
                                                       ,rain.ni)
                                   and deri.utente = 'CANCELLA'
                                   and ragi.ci = rain.ci
                                   and clra.codice = rain.rapporto
                                   and clra.presenza = 'SI'
                                   and decode(to_date(deri.dal, d_formato_data)
                                             ,d_ini_mes
                                             ,greatest(to_date(deri.dal, d_formato_data)
                                                      ,rain.dal)
                                             ,to_date(deri.dal, d_formato_data)) between
                                       rain.dal and nvl(rain.al, to_date('3333333', 'j')))
               loop
                  begin
                     delete from eventi_presenza
                      where ci = cancella.ci
                        and causale = cancella.causale
                        and dal = cancella.dal
                        and al = cancella.al;
                  exception
                     when no_data_found then
                        null;
                  end;
                  begin
                     insert into deposito_eventi_presenza
                        (rilevanza
                        ,ci
                        ,assenza
                        ,data
                        ,operazione
                        ,dal
                        ,al
                        ,utente
                        ,data_agg)
                        select 'R'
                              ,cancella.ci
                              ,caev.assenza
                              ,decode(caev.riferimento
                                     ,'P'
                                     ,add_months(to_date('01' ||
                                                         to_char(cancella.dal, 'mmyyyy')
                                                        ,'ddmmyyyy')
                                                ,-1)
                                     ,'M'
                                     ,to_date('01' || to_char(cancella.dal, 'mmyyyy')
                                             ,'ddmmyyyy')
                                     ,cancella.dal)
                              ,'D'
                              ,decode(caev.riferimento
                                     ,'P'
                                     ,add_months(to_date('01' ||
                                                         to_char(cancella.dal, 'mmyyyy')
                                                        ,'ddmmyyyy')
                                                ,-1)
                                     ,'M'
                                     ,to_date('01' || to_char(cancella.dal, 'mmyyyy')
                                             ,'ddmmyyyy')
                                     ,cancella.dal)
                              ,decode(caev.riferimento
                                     ,'P'
                                     ,add_months(last_day(cancella.al), -1)
                                     ,'M'
                                     ,last_day(cancella.al)
                                     ,cancella.al)
                              ,cancella.utente
                              ,cancella.data_agg
                          from causali_evento caev
                         where caev.codice = cancella.causale
                           and caev.assenza is not null
                           and cancella.data_agg = d_fin_mes
                           and cancella.input = 'R';
                  end;
               end loop;
            end;
         end if;
         /*
                   +--------------------------------------------------------+
                   | Carico su EVENTI_PRESENZA                              |
                   +--------------------------------------------------------+
         */
         dbms_output.put_line('software: ' || d_software);
         for origini in (select distinct nvl(utente, '%') software
                           from deposito_eventi_rilevazione
                          where nvl(utente, '%') like d_software)
         loop
            begin
               d_formato_data := 'yyyymmdd'; -- ipotizziamo il formato yyyymmdd
               /*
                         +-------------------------------------------------------+
                         | Controllo che il Riferimento Presenze sia esattamente |
                         | la data di aggiornamento dei dati provenienti dal     |
                         | sistema di Rilevazione Presenze.                      |
                         +-------------------------------------------------------+
               */
               begin
                  select 'x'
                    into d_errore
                    from riferimento_presenza ripa
                   where ripa.ripa_id = 'RIPA'
                     and exists
                   (select 'x'
                            from deposito_eventi_rilevazione deri
                           where to_date(deri.data_agg, d_formato_data /*'yyyymmdd'*/) <>
                                 ripa.fin_mes
                             and nvl(utente, '%') = origini.software);
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     d_stp          := null;
                     d_tim          := to_char(sysdate, 'sssss');
                     d_prs          := get_progressivo;
                     d_prn          := s_prenotazione;
                     d_pas          := s_passo;
                     d_errore       := 'P07402';
                     d_segnalazione := ' nell''origine ' || origini.software;
                     log_trace(5
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,d_tim
                              ,d_errore
                              ,d_segnalazione);
                     raise errore;
                  when no_data_found then
                     null;
                  when others then
                     d_formato_data := 'ddmmyyyy';
                     begin
                        select 'x'
                          into d_errore
                          from riferimento_presenza ripa
                         where ripa.ripa_id = 'RIPA'
                           and exists
                         (select 'x'
                                  from deposito_eventi_rilevazione deri
                                 where to_date(deri.data_agg
                                              ,d_formato_data /*'ddmmyyyy'*/) <>
                                       ripa.fin_mes
                                   and nvl(utente, '%') = origini.software);
                        raise too_many_rows;
                     exception
                        when too_many_rows then
                           d_stp          := null;
                           d_tim          := to_char(sysdate, 'sssss');
                           d_prs          := get_progressivo;
                           d_prn          := s_prenotazione;
                           d_pas          := s_passo;
                           d_errore       := 'P07402';
                           d_segnalazione := ' nell''origine ' || origini.software;
                           log_trace(5
                                    ,d_prn
                                    ,d_pas
                                    ,d_prs
                                    ,d_stp
                                    ,d_tim
                                    ,d_errore
                                    ,d_segnalazione);
                           raise errore;
                        when no_data_found then
                           null;
                     end;
               end;
               /*
                         +-------------------------------------------------------+
                         | Cancello da EVENTI_PRESENZA le registrazioni dovute a |
                         | precedenti lanci della fase nel mese di riferimento.  |
                         +-------------------------------------------------------+
               */
               begin
                  delete from eventi_presenza evpa
                   where input = 'R'
                     and data_agg = d_fin_mes
                     and nvl(utente, '%') = origini.software;
                  commit;
               end;
               /*
                         +-------------------------------------------------------+
                         | Carico su EVENTI_PRESENZA                             |
                         +-------------------------------------------------------+
               */
               for deri in (select nvl(deri.evento, evpa_sq.nextval) evento
                                  ,deri.ci
                                  ,deri.giustificativo
                                  ,'%' motivo
                                  ,to_date(deri.dal, d_formato_data) dal
                                  ,to_date(deri.al, d_formato_data) al
                                  ,to_date(deri.riferimento, d_formato_data) riferimento
                                  ,'SI' chiuso
                                  ,deri.input
                                  ,deri.classe
                                  ,deri.dalle
                                  ,deri.alle
                                  ,substr(deri.valore, instr(valore, '-')) valore
                                  ,deri.cdc
                                  ,deri.sede
                                  ,deri.note
                                  ,deri.utente
                                  ,to_date(deri.data_agg, d_formato_data) data_agg
                              from deposito_eventi_rilevazione deri
                             where nvl(utente, '%') = origini.software
                               and to_date(deri.data_agg, d_formato_data) = d_fin_mes)
               loop
                  begin
                     d_ci := get_ci(deri.ci, deri.al);
                     if d_ci is null then
                        d_stp          := null;
                        d_tim          := to_char(sysdate, 'sssss');
                        d_prs          := get_progressivo;
                        d_prn          := s_prenotazione;
                        d_pas          := s_passo;
                        d_errore       := 'P07405';
                        d_segnalazione := ' Matricola di origine : ' || deri.ci;
                        log_trace(1
                                 ,d_prn
                                 ,d_pas
                                 ,d_prs
                                 ,d_stp
                                 ,d_tim
                                 ,d_errore
                                 ,d_segnalazione);
                        raise prossimo;
                     end if;
                     d_causale := get_causale(deri.giustificativo);
                     if d_causale is null then
                        d_stp          := null;
                        d_tim          := to_char(sysdate, 'sssss');
                        d_prs          := get_progressivo;
                        d_prn          := s_prenotazione;
                        d_pas          := s_passo;
                        d_errore       := 'P07305';
                        d_segnalazione := ' Giustificativo : ' || deri.giustificativo;
                        log_trace(6
                                 ,d_prn
                                 ,d_pas
                                 ,d_prs
                                 ,d_stp
                                 ,d_tim
                                 ,d_errore
                                 ,d_segnalazione);
                        raise prossimo;
                     end if;
                     d_dal         := get_riferimento(d_ci, deri.dal);
                     d_al          := get_riferimento(d_ci, deri.al);
                     d_riferimento := get_riferimento(d_ci, deri.riferimento);
                     if (deri.dal is not null and d_dal is null) or
                        (deri.al is not null and d_al is null) or
                        (deri.riferimento is not null and d_riferimento is null) then
                        d_stp          := null;
                        d_tim          := to_char(sysdate, 'sssss');
                        d_prs          := get_progressivo;
                        d_prn          := s_prenotazione;
                        d_pas          := s_passo;
                        d_errore       := 'P07407';
                        d_segnalazione := ' Cod.Ind.: ' || d_ci || '  Causale : ' ||
                                          d_causale || '  dal : ' ||
                                          to_char(deri.dal, 'dd/mm/yyyy') || ' > ' ||
                                          to_char(d_dal, 'dd/mm/yyyy') || '  al : ' ||
                                          to_char(deri.al, 'dd/mm/yyyy') || ' > ' ||
                                          to_char(d_al, 'dd/mm/yyyy');
                        log_trace(8
                                 ,d_prn
                                 ,d_pas
                                 ,d_prs
                                 ,d_stp
                                 ,d_tim
                                 ,d_errore
                                 ,d_segnalazione);
                        raise prossimo;
                     end if;
                     if d_dal <> deri.dal or d_al <> deri.al or
                        d_riferimento <> deri.riferimento then
                        d_stp          := null;
                        d_tim          := to_char(sysdate, 'sssss');
                        d_prs          := get_progressivo;
                        d_prn          := s_prenotazione;
                        d_pas          := s_passo;
                        d_errore       := 'P07406';
                        d_segnalazione := ' Cod.Ind.: ' || d_ci || '  Causale : ' ||
                                          d_causale || '  dal : ' ||
                                          to_char(deri.dal, 'dd/mm/yyyy') || ' > ' ||
                                          to_char(d_dal, 'dd/mm/yyyy') || '  al : ' ||
                                          to_char(deri.al, 'dd/mm/yyyy') || ' > ' ||
                                          to_char(d_al, 'dd/mm/yyyy');
                        log_trace(7
                                 ,d_prn
                                 ,d_pas
                                 ,d_prs
                                 ,d_stp
                                 ,d_tim
                                 ,d_errore
                                 ,d_segnalazione);
                     end if;
                     begin
                        insert into eventi_presenza
                           (evento
                           ,ci
                           ,causale
                           ,motivo
                           ,dal
                           ,al
                           ,riferimento
                           ,chiuso
                           ,input
                           ,classe
                           ,dalle
                           ,alle
                           ,valore
                           ,cdc
                           ,sede
                           ,note
                           ,utente
                           ,data_agg)
                        values
                           (deri.evento
                           ,d_ci
                           ,d_causale
                           ,deri.motivo
                           ,d_dal
                           ,d_al
                           ,d_riferimento
                           ,deri.chiuso
                           ,deri.input
                           ,deri.classe
                           ,deri.dalle
                           ,deri.alle
                           ,deri.valore
                           ,deri.cdc
                           ,deri.sede
                           ,deri.note
                           ,deri.utente
                           ,deri.data_agg);
                     exception
                        when errore then
                           rollback;
                           update a_prenotazioni
                              set errore         = d_errore
                                 ,prossimo_passo = 99
                            where no_prenotazione = prenotazione;
                     end;
                     /*
                               +--------------------------------------------------------+
                               | Carico su DEPOSITO_EVENTI_PRESENZA                     |
                               +--------------------------------------------------------+
                     */
                     begin
                        insert into deposito_eventi_presenza
                           (rilevanza
                           ,ci
                           ,assenza
                           ,data
                           ,operazione
                           ,dal
                           ,al
                           ,utente
                           ,data_agg)
                           select 'R'
                                 ,evpa.ci
                                 ,caev.assenza
                                 ,decode(caev.riferimento
                                        ,'P'
                                        ,add_months(to_date('01' ||
                                                            to_char(evpa.dal, 'mmyyyy')
                                                           ,'ddmmyyyy')
                                                   ,-1)
                                        ,'M'
                                        ,to_date('01' || to_char(evpa.dal, 'mmyyyy')
                                                ,'ddmmyyyy')
                                        ,evpa.dal)
                                 ,'I'
                                 ,decode(caev.riferimento
                                        ,'P'
                                        ,add_months(to_date('01' ||
                                                            to_char(evpa.dal, 'mmyyyy')
                                                           ,'ddmmyyyy')
                                                   ,-1)
                                        ,'M'
                                        ,to_date('01' || to_char(evpa.dal, 'mmyyyy')
                                                ,'ddmmyyyy')
                                        ,evpa.dal)
                                 ,decode(caev.riferimento
                                        ,'P'
                                        ,add_months(last_day(evpa.al), -1)
                                        ,'M'
                                        ,last_day(evpa.al)
                                        ,evpa.al)
                                 ,evpa.utente
                                 ,evpa.data_agg
                             from eventi_presenza evpa
                                 ,causali_evento  caev
                            where caev.codice = evpa.causale
                              and caev.assenza is not null
                              and evpa.data_agg = d_fin_mes
                              and evpa.input = 'R';
                     end;
                  exception
                     when prossimo then
                        null;
                  end;
               end loop;
               /*
                         +--------------------------------------------------------+
                         | Modifica il flag_ec su RAPPORTI_PRESENZA               |
                         +--------------------------------------------------------+
               */
               begin
                  update rapporti_presenza rapa
                     set rapa.flag_ec = 'M'
                   where rapa.ci in
                         (select evpa.ci
                            from eventi_presenza evpa
                           where evpa.data_agg = d_fin_mes
                             and evpa.input = 'R'
                             and nvl(utente, '%') = origini.software);
               end;
            exception
               when esci then
                  null;
            end;
         end loop;
         /*      Segnalazione di fine elaborazione
         */
         begin
            d_stp          := null;
            d_tim          := to_char(sysdate, 'sssss');
            d_prs          := get_progressivo;
            d_prn          := s_prenotazione;
            d_pas          := s_passo;
            d_errore       := null;
            d_segnalazione := ' ';
            log_trace(2, d_prn, d_pas, d_prs, d_stp, d_tim, d_errore, d_segnalazione);
         end;
         /*      Aggiorna errore sulla prenotazione
         */
         update a_prenotazioni
            set errore = s_errore_prenotazione
          where no_prenotazione = prenotazione;
      exception
         when errore then
            null;
      end;
   end;
end;
/
