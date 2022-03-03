create or replace package pxirisca is
   /******************************************************************************
    NOME:          PXIRISCA
    Rev. Data       Autore Descrizione
    ---- ---------- ------ --------------------------------------------------------
    1.0  19/12/2006 MM     Creazione funzione versione
                           Acquisizione periodi assenza dei part-time verticali
                           Comprende la gestione dei Part-Time verticale e l'att.11730
    1.1  30/04/2007 MM     Modifica alla gestione del log. Nuova segnalazione in caso di errore
                           imprevisto (att.20600)
    1.2  25/05/2007 MM     Gestione part-time verticali  (att.18834)
    1.3  18/06/2007 MM     Att.21656:
                           Acquisizione da parametro della data di inizio.
                           Selezione delle segnalazioni da evidenziare.
                           Cancellazione del log differita
   ******************************************************************************/
   s_ci_log                periodi_giuridici.ci%type;
   s_operazione_log        assenze_iris.operazione%type;
   s_dal_log               date;
   s_al_log                date;
   s_assenza_log           periodi_giuridici.assenza%type := null;
   s_data_agg_log          date := trunc(sysdate);
   s_prenotazione_log      a_prenotazioni.no_prenotazione%type;
   s_data_prenotazione_log date;
   s_id_log                assenze_iris.id%type;
   s_tipo_segnalazioni     varchar2(1) := 'C';
   s_tag_assenza           varchar2(35) := '[ Codice assenza precedente : ]'; -- utilizzato nel caso di una assenza di un solo giorno alla quale modifichiamo il codice
   s_tag_inizio            varchar2(35) := '[ Data di inizio precedente : ]';
   s_tag_fine              varchar2(35) := '[ Data di fine precedente : ]';
   s_tag_incluso           varchar2(35) := '[ Assenza preesistente spezzata : ]';
   s_note_ins              varchar2(75) := '[ Inserito automaticamente dai calendari IRIS: part-time verticale ]';
   s_utente_ptv            periodi_giuridici.utente%type := 'Cal.IRIS';
   s_data_agg              date := trunc(sysdate);
   s_evento_ptv            periodi_giuridici.evento%type;
   s_assenza_ptv           periodi_giuridici.assenza%type;

   procedure main
   (
      prenotazione in number
     ,passo        in number
   );
   procedure inserisce_log
   (
      p_note              in varchar2
     ,p_tipo_segnalazioni in varchar2
   );
   procedure inserisce_ptv
   (
      p_ci         in number
     ,p_rilevanza  in varchar2
     ,p_dal        in date
     ,p_al         in date
     ,p_evento     in varchar2
     ,p_assenza    in varchar2
     ,p_confermato in number
     ,p_utente     in varchar2
     ,p_data_agg   in date
     ,p_note       in varchar2
   );
   function versione return varchar2;
end;
/
create or replace package body pxirisca is
   function versione return varchar2 is
   begin
      return 'V1.3 del 18/06/2007';
   end versione;
   procedure inserisce_log
   (
      p_note              in varchar2
     ,p_tipo_segnalazioni in varchar2
   ) is
      d_note assenze_iris_log.note%type;
   begin
      if p_tipo_segnalazioni = s_tipo_segnalazioni or s_tipo_segnalazioni = 'C' then
         if s_operazione_log = 'P' then
            d_note := p_note;
         else
            d_note := p_note || '   [id:' || s_id_log || ']';
         end if;
         insert into assenze_iris_log
            (ci
            ,operazione
            ,dal
            ,al
            ,assenza
            ,data_agg
            ,note
            ,prenotazione
            ,data_prenotazione)
         values
            (s_ci_log
            ,s_operazione_log
            ,s_dal_log
            ,s_al_log
            ,s_assenza_log
            ,s_data_agg_log
            ,d_note
            ,s_prenotazione_log
            ,s_data_prenotazione_log);
      end if;
   end inserisce_log;
   procedure inserisce_ptv
   (
      p_ci         in number
     ,p_rilevanza  in varchar2
     ,p_dal        in date
     ,p_al         in date
     ,p_evento     in varchar2
     ,p_assenza    in varchar2
     ,p_confermato in number
     ,p_utente     in varchar2
     ,p_data_agg   in date
     ,p_note       in varchar2
   ) is
   begin
      insert into periodi_giuridici
         (ci
         ,rilevanza
         ,dal
         ,al
         ,evento
         ,assenza
         ,confermato
         ,utente
         ,data_agg
         ,note)
      values
         (p_ci
         ,p_rilevanza
         ,p_dal
         ,p_al
         ,p_evento
         ,p_assenza
         ,p_confermato
         ,p_utente
         ,p_data_agg
         ,p_note);
   
   end inserisce_ptv;

   procedure main
   (
      prenotazione in number
     ,passo        in number
   ) is
   begin
      declare
         d_fin_mes              date;
         d_ini_mes              date;
         d_data_ultimo_agg      date;
         d_utente               varchar(8);
         d_num_record           number(12);
         d_errore               varchar(6);
         w_giuridico            number;
         w_assenza              number;
         d_conguaglio           varchar2(2);
         d_prolungamenti        varchar2(2);
         d_part_time_verticali  varchar2(2);
         d_cessati              varchar2(2);
         d_assesta_intersezioni varchar2(2);
         d_ruolo                varchar2(2);
         d_posizione            varchar2(4);
         d_sostituto            periodi_giuridici.ci%type;
         d_pegi_dal             periodi_giuridici.dal%type;
         d_pegi_al              periodi_giuridici.al%type;
         d_pegi_dal_prec        periodi_giuridici.dal%type;
         d_pegi_al_prec         periodi_giuridici.al%type;
         d_pegi_assenza         periodi_giuridici.assenza%type;
         d_pegi_evento          periodi_giuridici.evento%type;
         d_dal_int              date;
         d_assenza_int          periodi_giuridici.assenza%type;
         d_pegi_note            periodi_giuridici.note%type;
         d_inizio_ptv           date;
         d_fine_ptv             date;
         d_dummy                varchar2(1);
         w_pegi                 periodi_giuridici%rowtype;
         d_pegi_rowid           rowid;
         d_ptv_rowid            rowid;
         err_dati exception;
         errore exception;
         prossimo exception;
         prossimo_ptv exception;
         /*
                 +-----------------------------------+
                 | Inserimento movimenti da IRIS     |
                 | in Periodi_Giuridici.             |
                 +-----------------------------------+
         */
      begin
         -- dbms_output.put_line('Vai...');
         /* 1 */
         begin
            select utente
                  ,data_prenotazione
              into d_utente
                  ,s_data_prenotazione_log
              from a_prenotazioni
             where no_prenotazione = prenotazione;
         exception
            when no_data_found then
               d_utente := '*';
         end;
         begin
            select valore_default
              into d_part_time_verticali
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_PTV';
            if d_part_time_verticali not in ('SI', 'NO') then
               d_errore := 'P05809';
               raise errore;
            end if;
         exception
            when no_data_found then
               d_part_time_verticali := 'NO';
         end;
         begin
            select valore_default
              into d_prolungamenti
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_PROLUNGAMENTI';
            if d_prolungamenti not in ('SI', 'NO') then
               d_errore := 'P05809';
               raise errore;
            end if;
         exception
            when no_data_found then
               d_prolungamenti := 'NO';
         end;
         --         dbms_output.put_line('Prolungamenti: ' || d_prolungamenti);
         begin
            select valore_default
              into d_cessati
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_CESSATI';
            if d_cessati not in ('SI', 'NO') then
               d_errore := 'P05809';
               raise errore;
            end if;
         exception
            when no_data_found then
               d_cessati := 'NO';
         end;
         begin
            select valore_default
              into d_assesta_intersezioni
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_INTERSEZIONI';
            if d_assesta_intersezioni not in ('SI', 'NO') then
               d_errore := 'P05809';
               raise errore;
            end if;
         exception
            when no_data_found then
               d_assesta_intersezioni := 'NO';
         end;
         begin
            select to_date(valore, 'dd/mm/yyyy')
              into d_data_ultimo_agg
              from a_parametri
             where no_prenotazione = prenotazione
               and parametro = 'P_DATA_INIZIO';
         exception
            when no_data_found then
               d_data_ultimo_agg := null;
         end;
         if d_data_ultimo_agg is null then
            begin
               select nvl(max(trunc(data_agg)), to_date('01011900', 'ddmmyyyy'))
                 into d_data_ultimo_agg
                 from periodi_giuridici
                where rilevanza = 'A'
                  and utente = 'Aut.IRIS';
            exception
               when no_data_found then
                  d_data_ultimo_agg := to_date('01011900', 'ddmmyyyy');
            end;
         else
            begin
               select least(d_data_ultimo_agg, nvl(max(data_agg), d_data_ultimo_agg))
                 into d_data_ultimo_agg
                 from periodi_giuridici
                where rilevanza = 'A'
                  and utente = 'Aut.IRIS';
            exception
               when no_data_found then
                  null;
            end;
         end if;
         /*         dbms_output.put_line('Data ultimo aggiornamento ' ||
                                       to_char(d_data_ultimo_agg, 'dd/mm/yyyy'));
         */
         if d_part_time_verticali = 'SI' then
            begin
               select valore_default
                 into s_assenza_ptv
                 from a_selezioni
                where voce_menu = 'PXIRISCV'
                  and parametro = 'P_ASSPTV';
            
               select evento
                 into s_evento_ptv
                 from astensioni
                where codice = s_assenza_ptv;
            
               d_inizio_ptv := d_data_ultimo_agg;
               d_fine_ptv   := greatest(d_data_ultimo_agg, sysdate);
            
            exception
               when no_data_found then
                  d_errore := 'P00544';
                  raise errore;
            end;
         end if;
         --         dbms_output.put_line('inizio ' || d_inizio_ptv);
         begin
            select ripa.ini_mes
                  ,ripa.fin_mes
              into d_ini_mes
                  ,d_fin_mes
              from riferimento_presenza ripa
             where ripa.ripa_id = 'RIPA';
         exception
            when no_data_found then
               d_errore := 'P07000';
               raise errore;
         end;
         begin
            select valore_default
              into s_tipo_segnalazioni
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_SEGNALAZIONI';
         exception
            when no_data_found then
               s_tipo_segnalazioni := 'C';
         end;
         s_prenotazione_log := prenotazione;
         s_operazione_log   := 'I';
         if s_tipo_segnalazioni = 'A' then
            inserisce_log('VENGONO EVIDENZIATE LE SOLE SEGNALAZIONI DI ANOMALIA', 'A');
         end if;
         begin
            /* cancello segnalazioni relative ad elaborazioni precedenti
            piu vecchie di 18 mesi */
            delete from assenze_iris_log
             where operazione <> 'S'
               and data_prenotazione < sysdate - 540;
         end;
         begin
            --            dbms_output.put_line('Inizio...' || d_data_ultimo_agg);
         
            lock table periodi_giuridici in exclusive mode;
            si4.sql_execute('ALTER TABLE PERIODI_GIURIDICI DISABLE ALL TRIGGERS');
            for cur_asir in (select asir.ci
                                   ,asir.assenza
                                   ,asir.dal
                                   ,asir.al
                                   ,asir.operazione
                                   ,asir.data_agg
                                   ,aste.mat_anz
                                   ,aste.per_ret
                                   ,aste.mat_inps
                                   ,aste.mat_assfam
                                   ,aste.detrazioni
                                   ,asir.id
                               from assenze_iris asir
                                   ,astensioni   aste
                              where trunc(asir.data_agg) >= d_data_ultimo_agg
                                and asir.operazione in
                                    (select 'I'
                                       from dual
                                     union
                                     select 'C' from dual)
                                and aste.codice = asir.assenza
                             --     and asir.ci = 1030
                              order by asir.ci
                                      ,asir.id)
            loop
               s_ci_log           := cur_asir.ci;
               s_operazione_log   := cur_asir.operazione;
               s_dal_log          := cur_asir.dal;
               s_al_log           := cur_asir.al;
               s_assenza_log      := cur_asir.assenza;
               s_data_agg_log     := cur_asir.data_agg;
               s_id_log           := cur_asir.id;
               s_prenotazione_log := prenotazione;
               begin
                  if nvl(cur_asir.al, to_date(3333333, 'j')) < cur_asir.dal then
                     /*inseriamo una segnalazione*/
                     inserisce_log('Periodo con Al minore del Dal', 'A');
                     raise prossimo;
                  end if;
                  if cur_asir.operazione = 'C' then
                     /* Operazione di cancellazione */
                     /* verifico esistenza di record automatici da cancellare */
                     d_num_record := 0;
                     select nvl(count(*), 0)
                       into d_num_record
                       from periodi_giuridici pegi
                      where rilevanza = 'A'
                        and ci = cur_asir.ci
                        and cur_asir.dal <= nvl(pegi.al, to_date(3333333, 'j'))
                        and nvl(cur_asir.al, to_date(3333333, 'j')) >= pegi.dal
                        and pegi.utente = 'Aut.IRIS';
                     if d_num_record = 0 then
                        inserisce_log('Non esistono assenze comprese nel periodo di cancellazione'
                                     ,'A');
                        raise prossimo;
                     end if;
                     /* verifico esistenza di record non automatici che intersecano periodo da cancellare */
                     d_num_record := 0;
                     select nvl(count(*), 0)
                       into d_num_record
                       from periodi_giuridici pegi
                      where rilevanza = 'A'
                        and ci = cur_asir.ci
                        and cur_asir.dal <= nvl(pegi.al, to_date(3333333, 'j'))
                        and nvl(cur_asir.al, to_date(3333333, 'j')) >= pegi.dal
                        and pegi.utente <> 'Aut.IRIS';
                     if d_num_record > 0 then
                        /* inserisco assenze non cancellabili sul log */
                        for pegi in (select pegi.ci
                                           ,cur_asir.operazione
                                           ,pegi.dal
                                           ,pegi.al
                                           ,pegi.assenza
                                           ,pegi.data_agg
                                           ,'Assenza non automatica, non eliminata; operazione di cancellazione dal ' ||
                                            to_char(cur_asir.dal, 'dd/mm/yyyy') || ' al ' ||
                                            to_char(nvl(cur_asir.al, sysdate)
                                                   ,'dd/mm/yyyy') || ' non eseguita ' note
                                           ,prenotazione
                                       from periodi_giuridici pegi
                                      where rilevanza = 'A'
                                        and ci = cur_asir.ci
                                        and cur_asir.dal <=
                                            nvl(pegi.al, to_date(3333333, 'j'))
                                        and nvl(cur_asir.al, to_date(3333333, 'j')) >=
                                            pegi.dal
                                        and pegi.utente <> 'Aut.IRIS')
                        loop
                           s_operazione_log := cur_asir.operazione;
                           s_dal_log        := pegi.dal;
                           s_al_log         := pegi.al;
                           s_assenza_log    := pegi.assenza;
                           s_data_agg_log   := pegi.data_agg;
                           inserisce_log(pegi.note, 'A');
                        end loop;
                        raise prossimo;
                     end if;
                     /* controllo prima di cancellare se esistono periodi cancellabili
                     per i quali e presente un sostituto */
                     d_num_record := 0;
                     select nvl(count(*), 0)
                       into d_num_record
                       from periodi_giuridici pegi
                      where rilevanza = 'A'
                        and ci = cur_asir.ci
                        and cur_asir.dal <= nvl(pegi.al, to_date(3333333, 'j'))
                        and nvl(cur_asir.al, to_date(3333333, 'j')) >= pegi.dal
                        and pegi.utente = 'Aut.IRIS'
                        and exists (select 'x'
                               from sostituzioni_giuridiche
                              where titolare = cur_asir.ci
                                and dal_astensione = pegi.dal
                                and rilevanza_astensione = 'A');
                     if d_num_record > 0 then
                        /* inserisco assenze non cancellabili sul log */
                        for pegi in (select pegi.ci
                                           ,cur_asir.operazione
                                           ,pegi.dal
                                           ,pegi.al
                                           ,pegi.assenza
                                           ,pegi.data_agg
                                           ,'Assenza automatica non eliminata: esiste un sostituto; operazione di cancellazione dal ' ||
                                            to_char(cur_asir.dal, 'dd/mm/yyyy') || ' al ' ||
                                            to_char(nvl(cur_asir.al, sysdate)
                                                   ,'dd/mm/yyyy') || ' non eseguita ' note
                                           ,prenotazione
                                       from periodi_giuridici pegi
                                      where rilevanza = 'A'
                                        and ci = cur_asir.ci
                                        and cur_asir.dal <= pegi.dal
                                        and nvl(cur_asir.al, to_date(3333333, 'j')) >=
                                            nvl(pegi.al, to_date(3333333, 'j'))
                                        and pegi.utente = 'Aut.IRIS'
                                        and exists
                                      (select 'x'
                                               from sostituzioni_giuridiche
                                              where titolare = cur_asir.ci
                                                and dal_astensione = pegi.dal
                                                and rilevanza_astensione = 'A'))
                        loop
                           s_operazione_log := cur_asir.operazione;
                           s_dal_log        := pegi.dal;
                           s_al_log         := pegi.al;
                           s_assenza_log    := pegi.assenza;
                           s_data_agg_log   := pegi.data_agg;
                           inserisce_log(pegi.note, 'A');
                        end loop;
                        raise prossimo;
                     end if;
                     if d_assesta_intersezioni = 'NO' then
                        /* inserisco assenze da cancellare sul log */
                        for pegi in (select pegi.ci
                                           ,cur_asir.operazione
                                           ,pegi.dal
                                           ,pegi.al
                                           ,pegi.assenza
                                           ,pegi.data_agg
                                           ,'Assenza eliminata dall'' operazione di cancellazione dal ' ||
                                            to_char(cur_asir.dal, 'dd/mm/yyyy') || ' al ' ||
                                            to_char(nvl(cur_asir.al, sysdate)
                                                   ,'dd/mm/yyyy') note
                                           ,prenotazione
                                       from periodi_giuridici pegi
                                      where rilevanza = 'A'
                                        and ci = cur_asir.ci
                                        and cur_asir.dal <=
                                            nvl(pegi.al, to_date(3333333, 'j'))
                                        and nvl(cur_asir.al, to_date(3333333, 'j')) >=
                                            pegi.dal
                                        and pegi.utente = 'Aut.IRIS')
                        loop
                           s_operazione_log := cur_asir.operazione;
                           s_dal_log        := pegi.dal;
                           s_al_log         := pegi.al;
                           s_assenza_log    := pegi.assenza;
                           s_data_agg_log   := pegi.data_agg;
                           inserisce_log(pegi.note, 'C');
                        end loop;
                        /* elimina da PEGI i record che intersecano il periodo di cancellazione */
                        delete from periodi_giuridici pegi
                         where rilevanza = 'A'
                           and ci = cur_asir.ci
                           and cur_asir.dal <= nvl(pegi.al, to_date(3333333, 'j'))
                           and nvl(cur_asir.al, to_date(3333333, 'j')) >= pegi.dal
                           and pegi.utente = 'Aut.IRIS';
                        /* Aggiorno rapporti_giuridici */
                        d_conguaglio := 'NO';
                        if cur_asir.per_ret <> 100 or cur_asir.mat_anz = 0 or
                           cur_asir.mat_inps = 0 or cur_asir.mat_assfam = 0 or
                           cur_asir.mat_assfam = 2 or cur_asir.detrazioni = 0 then
                           d_conguaglio := 'SI';
                        end if;
                        update rapporti_giuridici ragi
                           set ragi.d_cong    = decode(d_conguaglio
                                                      ,'SI'
                                                      ,least(nvl(ragi.d_cong
                                                                ,to_date('3333333', 'j'))
                                                            ,to_date(to_char(cur_asir.dal
                                                                            ,'yyyymm')
                                                                    ,'yyyymm'))
                                                      ,ragi.d_cong)
                              ,ragi.d_inqe    = decode(cur_asir.mat_anz
                                                      ,'0'
                                                      ,least(nvl(ragi.d_inqe
                                                                ,to_date('3333333', 'j'))
                                                            ,cur_asir.dal)
                                                      ,ragi.d_inqe)
                              ,ragi.flag_inqe = decode(cur_asir.mat_anz
                                                      ,'0'
                                                      ,'A'
                                                      ,ragi.flag_inqe)
                         where ragi.ci = cur_asir.ci;
                     else
                        /* assesta intersezioni dei periodi esistenti su PEGI */
                        /* elimina i periodi giuridici di assenza completamente
                        contenuti nel periodo di cancellazione */
                        for pegi in (select pegi.ci
                                           ,cur_asir.operazione
                                           ,pegi.dal
                                           ,pegi.al
                                           ,pegi.assenza
                                           ,pegi.data_agg
                                           ,'Assenza eliminata dall'' operazione di cancellazione dal ' ||
                                            to_char(cur_asir.dal, 'dd/mm/yyyy') || ' al ' ||
                                            to_char(nvl(cur_asir.al, sysdate)
                                                   ,'dd/mm/yyyy') note
                                           ,prenotazione
                                       from periodi_giuridici pegi
                                      where rilevanza = 'A'
                                        and ci = cur_asir.ci
                                        and cur_asir.dal <= pegi.dal
                                        and nvl(cur_asir.al, to_date(3333333, 'j')) >=
                                            nvl(pegi.dal, to_date(3333333, 'j'))
                                        and pegi.utente = 'Aut.IRIS')
                        loop
                           s_operazione_log := cur_asir.operazione;
                           s_dal_log        := pegi.dal;
                           s_al_log         := pegi.al;
                           s_assenza_log    := pegi.assenza;
                           s_data_agg_log   := pegi.data_agg;
                           inserisce_log(pegi.note, 'C');
                        end loop;
                        /* elimina da PEGI i record che intersecano il periodo di cancellazione */
                        delete from periodi_giuridici pegi
                         where rilevanza = 'A'
                           and ci = cur_asir.ci
                           and pegi.dal >= cur_asir.dal
                           and nvl(pegi.al, to_date(3333333, 'j')) <=
                               nvl(cur_asir.al, to_date(3333333, 'j'))
                           and pegi.utente = 'Aut.IRIS';
                        /* modifica la data finale dell'eventuale periodi di astensione che interseca l'inizio
                        del periodo di cancellazione */
                        begin
                           select dal
                                 ,assenza
                             into d_dal_int
                                 ,d_assenza_int
                             from periodi_giuridici
                            where ci = cur_asir.ci
                              and rilevanza = 'A'
                              and nvl(al, to_date(3333333, 'j')) between cur_asir.dal and
                                  nvl(cur_asir.al, to_date(3333333, 'j'));
                           raise too_many_rows;
                        exception
                           when no_data_found then
                              null;
                           when too_many_rows then
                              /* modifica la data finale del preesistente periodi di PEGI che interseca l'inizio
                              del periodo di cancellazione */
                              for pegi in (select pegi.ci
                                                 ,cur_asir.operazione
                                                 ,pegi.dal
                                                 ,pegi.al
                                                 ,pegi.assenza
                                                 ,pegi.data_agg
                                                 ,'Assenza modificata: corretto AL alla data: ' ||
                                                  to_char(cur_asir.dal - 1, 'dd/mm/yyyy') note
                                                 ,prenotazione
                                             from periodi_giuridici pegi
                                            where rilevanza = 'A'
                                              and ci = cur_asir.ci
                                              and nvl(al, to_date(3333333, 'j')) between
                                                  cur_asir.dal and
                                                  nvl(cur_asir.al, to_date(3333333, 'j'))
                                              and pegi.utente = 'Aut.IRIS')
                              loop
                                 s_operazione_log := cur_asir.operazione;
                                 s_dal_log        := pegi.dal;
                                 s_al_log         := pegi.al;
                                 s_assenza_log    := pegi.assenza;
                                 s_data_agg_log   := pegi.data_agg;
                                 inserisce_log(pegi.note, 'C');
                              end loop;
                              /* assesta il suddetto periodo */
                              update periodi_giuridici
                                 set al = cur_asir.dal - 1
                               where rilevanza = 'A'
                                 and ci = cur_asir.ci
                                 and nvl(al, to_date(3333333, 'j')) between cur_asir.dal and
                                     nvl(cur_asir.al, to_date(3333333, 'j'))
                                 and utente = 'Aut.IRIS';
                        end;
                        /* modifica la data iniziale dell'eventuale periodi di astensione che interseca la fine
                        del periodo di cancellazione */
                        begin
                           select dal
                                 ,assenza
                             into d_dal_int
                                 ,d_assenza_int
                             from periodi_giuridici
                            where ci = cur_asir.ci
                              and rilevanza = 'A'
                              and dal between cur_asir.dal and
                                  nvl(cur_asir.al, to_date(3333333, 'j'));
                           raise too_many_rows;
                        exception
                           when no_data_found then
                              null;
                           when too_many_rows then
                              /* modifica la data iniziale del preesistente periodi di PEGI che interseca la fine
                              del periodo di cancellazione */
                              for pegi in (select pegi.ci
                                                 ,cur_asir.operazione
                                                 ,pegi.dal
                                                 ,pegi.al
                                                 ,pegi.assenza
                                                 ,pegi.data_agg
                                                 ,'Assenza modificata: corretto DAL alla data: ' ||
                                                  to_char(cur_asir.al + 1, 'dd/mm/yyyy') note
                                                 ,prenotazione
                                             from periodi_giuridici pegi
                                            where rilevanza = 'A'
                                              and ci = cur_asir.ci
                                              and dal between cur_asir.dal and
                                                  nvl(cur_asir.al, to_date(3333333, 'j'))
                                              and pegi.utente = 'Aut.IRIS')
                              loop
                                 s_operazione_log := cur_asir.operazione;
                                 s_dal_log        := pegi.dal;
                                 s_al_log         := pegi.al;
                                 s_assenza_log    := pegi.assenza;
                                 s_data_agg_log   := pegi.data_agg;
                                 inserisce_log(pegi.note, 'C');
                              end loop;
                              /* assesta il suddetto periodo */
                              update periodi_giuridici
                                 set dal = cur_asir.al + 1
                               where rilevanza = 'A'
                                 and ci = cur_asir.ci
                                 and dal between cur_asir.dal and
                                     nvl(cur_asir.al, to_date(3333333, 'j'))
                                 and utente = 'Aut.IRIS';
                        end;
                     end if;
                  else
                     /*                     dbms_output.put_line('Inserimento');
                     */ /****** Operazione di Inserimento ******/
                     begin
                        /*                        dbms_output.put_line('cur_asir.dal ' ||
                                                                     to_char(cur_asir.dal, 'dd/mm/yyyy'));
                                                dbms_output.put_line('cur_asir.al  ' ||
                                                                     to_char(cur_asir.al, 'dd/mm/yyyy'));
                        */ /* Verifico l'esistenza di un periodo di inquadramento che possa contenere l'assenza da inserire */
                        /*                        dbms_output.put_line('Sono nel caso in cui Verifico l''esistenza di un periodo di inquadramento che possa contenere l''assenza da inserire');
                        */
                        d_num_record := 1;
                        begin
                           select (sum(least(nvl(pegi.al, to_date(3333333, 'j'))
                                            ,nvl(cur_asir.al, to_date(3333333, 'j'))) -
                                       greatest(dal, cur_asir.dal) + 1))
                             into w_giuridico
                             from periodi_giuridici pegi
                            where pegi.rilevanza = 'Q'
                              and pegi.ci = cur_asir.ci
                              and nvl(cur_asir.al, to_date(3333333, 'j')) >= pegi.dal
                              and cur_asir.dal <= nvl(pegi.al, to_date(3333333, 'j'));
                        exception
                           when no_data_found then
                              w_giuridico  := 0;
                              d_num_record := 0;
                        end;
                        w_assenza := nvl(cur_asir.al, to_date(3333333, 'j')) -
                                     cur_asir.dal + 1;
                     end;
                     /*                     dbms_output.put_line('w_giuridico ' || w_giuridico);
                                          dbms_output.put_line('d_num_record ' || d_num_record);
                                          dbms_output.put_line('w_assenza ' || w_assenza);
                     */
                     if (w_assenza <> nvl(w_giuridico, 0)) or nvl(d_num_record, 0) = 0 then
                        d_posizione := gp4_pegi.get_posizione(cur_asir.ci
                                                             ,'Q'
                                                             ,cur_asir.dal);
                        d_ruolo     := gp4_posi.get_ruolo(d_posizione);
                        /*                        dbms_output.put_line('d_posizione ' || d_posizione);
                                                dbms_output.put_line('d_ruolo ' || d_ruolo);
                                                dbms_output.put_line('d_cessati ' || d_cessati);
                        */
                        if d_cessati = 'SI' and d_ruolo = 'NO' then
                           /* Scrivo record da inserire sul log */
                           inserisce_log('Inserita assenza dal ' ||
                                         to_char(cur_asir.dal, 'dd/mm/yyyy') || ' al ' ||
                                         to_char(cur_asir.al, 'dd/mm/yyyy') ||
                                         '; e necessario inserire il periodo di inquadramento'
                                        ,'A');
                           /* Inserisco il nuovo record su PEGI */
                           insert into periodi_giuridici
                              (ci
                              ,rilevanza
                              ,dal
                              ,al
                              ,evento
                              ,assenza
                              ,confermato
                              ,utente
                              ,data_agg
                              ,note)
                              select cur_asir.ci
                                    ,'A'
                                    ,cur_asir.dal
                                    ,cur_asir.al
                                    ,aste.evento
                                    ,cur_asir.assenza
                                    ,1
                                    ,'Aut.IRIS'
                                    ,cur_asir.data_agg
                                    ,'[ Inserito automaticamente da CIRIS ]'
                                from astensioni aste
                               where aste.codice = cur_asir.assenza;
                           raise prossimo;
                        else
                           /* scrivo sul log il record che non posso caricare */
                           inserisce_log('Non esiste il periodo di inquadramento ' ||
                                         cur_asir.assenza || ' ' ||
                                         to_char(cur_asir.dal, 'dd/mm/yyyy') || ' al ' ||
                                         to_char(nvl(cur_asir.al, sysdate), 'dd/mm/yyyy') ||
                                         ' inserimento non eseguito'
                                        ,'A');
                           raise prossimo;
                        end if;
                     end if;
                     begin
                        /* Verifico l'esistenza di periodi di assenza che intersecano quello che vorrei inserire */
                        /*                        dbms_output.put_line('Sono nel caso in cui i periodi di assenza che intersecano quello che vorrei inserire');
                        */
                        d_num_record   := 0;
                        d_pegi_dal     := null;
                        d_pegi_al      := null;
                        d_pegi_assenza := null;
                        select nvl(count(*), 0)
                              ,max(dal)
                              ,max(assenza)
                              ,max(al)
                          into d_num_record
                              ,d_pegi_dal
                              ,d_pegi_assenza
                              ,d_pegi_al
                          from periodi_giuridici pegi
                         where rilevanza = 'A'
                           and ci = cur_asir.ci
                           and cur_asir.dal <= nvl(pegi.al, to_date(3333333, 'j'))
                           and nvl(cur_asir.al, to_date(3333333, 'j')) >= pegi.dal;
                     end;
                     if d_num_record > 0 then
                        if d_prolungamenti = 'SI' and d_num_record = 1 and
                           d_pegi_dal = cur_asir.dal and
                           d_pegi_assenza = cur_asir.assenza and cur_asir.al > d_pegi_al then
                           /* Scrivo record da inserire sul log */
                           inserisce_log('Il periodo dal ' ||
                                         to_char(d_pegi_al + 1, 'dd/mm/yyyy') || ' al ' ||
                                         to_char(cur_asir.al, 'dd/mm/yyyy') ||
                                         ' e stato inserito come prolungamento del periodo dal ' ||
                                         to_char(d_pegi_dal, 'dd/mm/yyyy') || ' al ' ||
                                         to_char(d_pegi_al, 'dd/mm/yyyy')
                                        ,'C');
                           -- segnalazione per sostituto
                           begin
                              select sogi.sostituto
                                into d_sostituto
                                from sostituzioni_giuridiche sogi
                               where sogi.titolare = cur_asir.ci
                                 and sogi.rilevanza_astensione = 'A'
                                 and sogi.dal_astensione = d_pegi_dal;
                              raise too_many_rows;
                           exception
                              when too_many_rows then
                                 inserisce_log('Il periodo dal ' ||
                                               to_char(d_pegi_dal, 'dd/mm/yyyy') ||
                                               ' al ' ||
                                               to_char(d_pegi_al, 'dd/mm/yyyy') ||
                                               ' era sostituito da ' ||
                                               gp4_rain.get_nominativo(d_sostituto) ||
                                               ' (Cod.Ind. ' || d_sostituto || ')'
                                              ,'A');
                              when no_data_found then
                                 null;
                           end;
                           /* Inserisco il nuovo record su PEGI */
                           insert into periodi_giuridici
                              (ci
                              ,rilevanza
                              ,dal
                              ,al
                              ,evento
                              ,assenza
                              ,confermato
                              ,utente
                              ,data_agg
                              ,note)
                              select cur_asir.ci
                                    ,'A'
                                    ,d_pegi_al + 1
                                    ,cur_asir.al
                                    ,aste.evento
                                    ,cur_asir.assenza
                                    ,1
                                    ,'Aut.IRIS'
                                    ,cur_asir.data_agg
                                    ,'[ Inserito automaticamente da CIRIS ]'
                                from astensioni aste
                               where aste.codice = cur_asir.assenza
                                 and nvl(cur_asir.al, to_date(3333333, 'j')) >=
                                     d_pegi_al + 1;
                           raise prossimo;
                        else
                           /* scrivo sul log i records che impediscono il caricamento */
                           for pegi in (select cur_asir.ci
                                              ,cur_asir.operazione
                                              ,cur_asir.dal
                                              ,cur_asir.al
                                              ,cur_asir.assenza
                                              ,cur_asir.data_agg
                                              ,'Il periodo ' || pegi.assenza || ' ' ||
                                               to_char(pegi.dal, 'dd/mm/yyyy') || ' al ' ||
                                               to_char(nvl(pegi.al, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               ' e'' sovrapposto  inserimento non eseguito' note
                                              ,prenotazione
                                          from periodi_giuridici pegi
                                         where rilevanza = 'A'
                                           and ci = cur_asir.ci
                                           and cur_asir.dal <=
                                               nvl(pegi.al, to_date(3333333, 'j'))
                                           and nvl(cur_asir.al, to_date(3333333, 'j')) >=
                                               pegi.dal)
                           loop
                              inserisce_log(pegi.note, 'A');
                           end loop;
                           raise prossimo;
                        end if;
                     end if;
                     begin
                        /* Scrivo record da inserire sul log */
                        inserisce_log('Inserimento eseguito ', 'C');
                        -- segnalazione per sostituto
                        begin
                           select sogi.sostituto
                                 ,pegi.dal
                                 ,pegi.al
                             into d_sostituto
                                 ,d_pegi_dal
                                 ,d_pegi_al
                             from sostituzioni_giuridiche sogi
                                 ,periodi_giuridici       pegi
                            where sogi.titolare = cur_asir.ci
                              and pegi.ci = cur_asir.ci
                              and pegi.rilevanza = 'A'
                              and sogi.rilevanza_astensione = 'A'
                              and sogi.dal_astensione = pegi.dal
                              and pegi.al = cur_asir.dal - 1;
                           raise too_many_rows;
                        exception
                           when too_many_rows then
                              inserisce_log('Il periodo dal ' ||
                                            to_char(d_pegi_dal, 'dd/mm/yyyy') || ' al ' ||
                                            to_char(d_pegi_al, 'dd/mm/yyyy') ||
                                            ' era sostituito da ' ||
                                            gp4_rain.get_nominativo(d_sostituto) ||
                                            ' (Cod.Ind. ' || d_sostituto || ')'
                                           ,'A');
                           when no_data_found then
                              null;
                        end;
                        /* Inserisco il nuovo record su PEGI */
                        insert into periodi_giuridici
                           (ci
                           ,rilevanza
                           ,dal
                           ,al
                           ,evento
                           ,assenza
                           ,confermato
                           ,utente
                           ,data_agg
                           ,note)
                           select cur_asir.ci
                                 ,'A'
                                 ,cur_asir.dal
                                 ,cur_asir.al
                                 ,aste.evento
                                 ,cur_asir.assenza
                                 ,1
                                 ,'Aut.IRIS'
                                 ,cur_asir.data_agg
                                 ,'[ Inserito automaticamente da CIRIS ]'
                             from astensioni aste
                            where aste.codice = cur_asir.assenza;
                        /* Aggiorno rapporti_giuridici */
                        d_conguaglio := 'NO';
                        if cur_asir.per_ret <> 100 or cur_asir.mat_anz = 0 or
                           cur_asir.mat_inps = 0 or cur_asir.mat_assfam = 0 or
                           cur_asir.mat_assfam = 2 or cur_asir.detrazioni = 0 then
                           d_conguaglio := 'SI';
                        end if;
                        update rapporti_giuridici ragi
                           set ragi.d_cong    = decode(d_conguaglio
                                                      ,'SI'
                                                      ,least(nvl(ragi.d_cong
                                                                ,to_date('3333333', 'j'))
                                                            ,to_date(to_char(cur_asir.dal
                                                                            ,'yyyymm')
                                                                    ,'yyyymm'))
                                                      ,ragi.d_cong)
                              ,ragi.d_inqe    = decode(cur_asir.mat_anz
                                                      ,'0'
                                                      ,least(nvl(ragi.d_inqe
                                                                ,to_date('3333333', 'j'))
                                                            ,cur_asir.dal)
                                                      ,ragi.d_inqe)
                              ,ragi.flag_inqe = decode(cur_asir.mat_anz
                                                      ,'0'
                                                      ,'A'
                                                      ,ragi.flag_inqe)
                         where ragi.ci = cur_asir.ci;
                     end;
                  end if;
               exception
                  when prossimo then
                     null;
                  when others then
                     /* scrivo sul log il record che non posso caricare */
                     inserisce_log('Errore bloccante sul periodo ' || cur_asir.assenza || ' ' ||
                                   to_char(cur_asir.dal, 'dd/mm/yyyy') || ' al ' ||
                                   to_char(nvl(cur_asir.al, sysdate), 'dd/mm/yyyy') ||
                                   ' operazione non eseguita'
                                  ,'A');
               end;
            end loop;
            /*            dbms_output.put_line('Termine gestione Assenze...');
                        dbms_output.put_line('Inizio gestione Part-Time verticali...');
            */ --
            --
            -- Trattiamo tutti i part-time verticali in servizio nel periodo
            --
            --
            if d_part_time_verticali = 'SI' then
               s_operazione_log := 'P';
               s_assenza_log    := s_assenza_ptv;
               s_data_agg_log   := s_data_agg;
               for dip_ptv in (select ptvi.ci
                                     ,ptvi.progressivo
                                     ,greatest(ptvi.dal, d_inizio_ptv) inizio
                                     ,least(ptvi.al, d_fine_ptv) fine
                                     ,ptvi.tipo_pt
                                 from part_time_verticali_iris ptvi
                                where ptvi.dal <= d_fine_ptv
                                  and ptvi.al >= d_inizio_ptv
                                order by ptvi.ci
                                        ,ptvi.dal)
               loop
                  s_ci_log := dip_ptv.ci;
                  -- Trattiamo i giorni dei calendari di iris dell'individuo
                  -- trattiamo anche i giorni con lavorativo = 'S' per gestire eventuali rettifiche
                  for cale_ptv in (select trunc(ca_iris.data) data
                                         ,ca_iris.festivo
                                         ,ca_iris.lavorativo
                                         ,ca_iris.numgiorni
                                     from calendari_iris ca_iris
                                    where ca_iris.progressivo = dip_ptv.progressivo
                                      and ca_iris.lavorativo in ('N', 'S')
                                      and ca_iris.data between dip_ptv.inizio and
                                          dip_ptv.fine
                                    order by data)
                  loop
                     d_pegi_dal := '';
                     d_pegi_al  := '';
                     s_dal_log  := cale_ptv.data;
                     s_al_log   := cale_ptv.data;
                     --    dbms_output.put_line('PTV...' || cale_ptv.data);
                     begin
                        if cale_ptv.lavorativo = 'N' then
                           -- GIORNO DI NON LAVORO
                           -- verifica della copertura con un periodo di servizio
                           begin
                              select 'x'
                                into d_dummy
                                from periodi_giuridici pegi
                               where pegi.ci = dip_ptv.ci
                                 and pegi.rilevanza = 'S'
                                 and cale_ptv.data between pegi.dal and
                                     nvl(pegi.al, to_date(3333333, 'j'));
                           exception
                              when no_data_found then
                                 /* scrivo sul log il record che non posso caricare */
                                 inserisce_log('Non esiste il periodo di servizio per la data : ' ||
                                               to_char(nvl(cale_ptv.data, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               ' inserimento non eseguito'
                                              ,'A');
                                 raise prossimo_ptv;
                              
                              when too_many_rows then
                                 null;
                           end;
                           -- verifica della presenza di un precedente caricamento
                           begin
                              select 'x'
                                into d_dummy
                                from periodi_giuridici pegi
                               where pegi.ci = dip_ptv.ci
                                 and pegi.rilevanza = 'A'
                                 and cale_ptv.data = pegi.dal
                                 and cale_ptv.data = pegi.al
                                 and utente = s_utente_ptv;
                              raise prossimo_ptv;
                              --   dbms_output.put_line('presente...' || cale_ptv.data);
                           exception
                              when no_data_found then
                                 null;
                           end;
                           begin
                              select trunc(dal)
                                    ,nvl(trunc(al), to_date(3333333, 'j'))
                                into d_pegi_dal
                                    ,d_pegi_al
                                from periodi_giuridici pegi
                               where pegi.ci = dip_ptv.ci
                                 and pegi.rilevanza = 'A'
                                 and cale_ptv.data between pegi.dal and
                                     nvl(pegi.al, to_date(3333333, 'j'));
                              /*                              dbms_output.put_line('PTV...PEGI...' || d_pegi_dal ||
                                                                                 ' - ' || d_pegi_al);
                              */
                              if d_pegi_dal = d_pegi_al and d_pegi_dal = cale_ptv.data then
                                 -- assenza gia presente ma di un solo giorno... coincide con il giorno di non lavoro
                                 /*    Potremmo, in alternativa :
                                    1. Modifichiamo la rilevanza ('s') del record di assenza preesistente per poterlo recuperare alla bisogna
                                    2. Modifichiamo il codice dell'assenza in quello del non lavoro e registriamo il vecchio codice con un tag nelle note
                                 */
                                 -- realizzazione ipotesi 2
                                 update periodi_giuridici pegi
                                    set note     = pegi.note || s_tag_assenza || '[' ||
                                                   assenza || ']'
                                       ,assenza  = s_assenza_ptv
                                       ,evento   = s_evento_ptv
                                       ,utente   = s_utente_ptv
                                       ,data_agg = sysdate
                                  where ci = dip_ptv.ci
                                    and dal = d_pegi_dal
                                    and rilevanza = 'A';
                                 inserisce_log('Giorno non lavorato (part-time verticale) ' ||
                                               to_char(nvl(cale_ptv.data, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               '; modificato periodo di assenza preesistente alla stessa data'
                                              ,'C');
                              elsif cale_ptv.data = d_pegi_dal then
                                 -- assenza preesistente con inizio coincidente
                                 update periodi_giuridici pegi
                                    set note = pegi.note || s_tag_inizio || '[' ||
                                               to_char(d_pegi_dal, 'dd/mm/yyyy') || ']' || '[' ||
                                               assenza || ']'
                                       ,dal  = dal + 1
                                  where ci = dip_ptv.ci
                                    and dal = d_pegi_dal
                                    and rilevanza = 'A';
                                 inserisce_log('Giorno non lavorato (part-time verticale) ' ||
                                               to_char(nvl(cale_ptv.data, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               '; modificato periodo di assenza preeesistente con inizio coincidente'
                                              ,'C');
                              elsif cale_ptv.data = d_pegi_al then
                                 -- assenza preesistente con fine coincidente
                                 update periodi_giuridici pegi
                                    set note = pegi.note || s_tag_fine || '[' ||
                                               to_char(pegi.al, 'dd/mm/yyyy') || ']' || '[' ||
                                               assenza || ']'
                                       ,al   = al - 1
                                  where ci = dip_ptv.ci
                                    and dal = d_pegi_dal
                                    and rilevanza = 'A';
                                 inserisce_log('Giorno non lavorato (part-time verticale) ' ||
                                               to_char(nvl(cale_ptv.data, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               '; modificato periodo di assenza preesistente con fine coincidente'
                                              ,'C');
                              elsif cale_ptv.data > d_pegi_dal and
                                    cale_ptv.data < d_pegi_al then
                                 -- assenza preesistente che comprende il giorno di non lavoro. Spezziamo il periodo
                                 -- selezioniamo le informazioni del periodo di assenza preesistente
                                 select *
                                   into w_pegi
                                   from periodi_giuridici
                                  where ci = dip_ptv.ci
                                    and dal = d_pegi_dal
                                    and rilevanza = 'A';
                                 -- chiudo l'assenza al giorno precedente
                                 update periodi_giuridici pegi
                                    set note = pegi.note || s_tag_incluso || s_tag_fine || '[' ||
                                               to_char(cale_ptv.data + 1, 'dd/mm/yyyy') || ']'
                                       ,al   = cale_ptv.data - 1
                                  where ci = dip_ptv.ci
                                    and dal = d_pegi_dal
                                    and rilevanza = 'A';
                                 -- inserisce la parte restante dell'assenza preesistente
                                 insert into periodi_giuridici
                                    (ci
                                    ,rilevanza
                                    ,dal
                                    ,al
                                    ,evento
                                    ,ore
                                    ,assenza
                                    ,confermato
                                    ,note
                                    ,note_al1
                                    ,note_al2
                                    ,sede_del
                                    ,anno_del
                                    ,numero_del
                                    ,utente
                                    ,data_agg)
                                 values
                                    (w_pegi.ci
                                    ,w_pegi.rilevanza
                                    ,cale_ptv.data + 1
                                    ,w_pegi.al
                                    ,w_pegi.evento
                                    ,w_pegi.ore
                                    ,w_pegi.assenza
                                    ,w_pegi.confermato
                                    ,w_pegi.note
                                    ,w_pegi.note_al1
                                    ,w_pegi.note_al2
                                    ,w_pegi.sede_del
                                    ,w_pegi.anno_del
                                    ,w_pegi.numero_del
                                    ,w_pegi.utente
                                    ,w_pegi.data_agg);
                                 inserisce_log('Giorno non lavorato (part-time verticale) ' ||
                                               to_char(nvl(cale_ptv.data, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               '; inserito all''interno di un periodo di assenza preesistente'
                                              ,'C');
                              end if;
                              if (cale_ptv.data = d_pegi_dal and
                                 cale_ptv.data = d_pegi_al) then
                                 raise prossimo_ptv;
                              else
                                 /*                                 dbms_output.put_line('inserisce ptv ' || cale_ptv.data || ' ' ||
                                                                                       d_pegi_dal || ':' || d_pegi_al);
                                 */
                                 inserisce_ptv(dip_ptv.ci
                                              ,'A'
                                              ,cale_ptv.data
                                              ,cale_ptv.data
                                              ,s_evento_ptv
                                              ,s_assenza_ptv
                                              ,1
                                              ,s_utente_ptv
                                              ,s_data_agg
                                              ,s_note_ins);
                                 inserisce_log('Giorno non lavorato (part-time verticale) ' ||
                                               to_char(nvl(cale_ptv.data, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               '; inserimento eseguito'
                                              ,'C');
                                 raise prossimo_ptv;
                              end if;
                           exception
                              when no_data_found then
                                 null;
                              when too_many_rows then
                                 /* scrivo sul log il record che non posso caricare */
                                 inserisce_log('ERRORE !!! Esistono diverse assenze sovrapposte : ' ||
                                               to_char(nvl(cale_ptv.data, sysdate)
                                                      ,'dd/mm/yyyy') ||
                                               ' inserimento non eseguito'
                                              ,'A');
                                 raise prossimo_ptv;
                           end;
                           /*
                               Inserisce il giorno di non lavoro in assenza di condizioni ostative
                               ...da gestire RAGI per attivazione conguagli e inquadramenti...
                           */
                           inserisce_ptv(dip_ptv.ci
                                        ,'A'
                                        ,cale_ptv.data
                                        ,cale_ptv.data
                                        ,s_evento_ptv
                                        ,s_assenza_ptv
                                        ,1
                                        ,s_utente_ptv
                                        ,s_data_agg
                                        ,s_note_ins);
                           inserisce_log('Giorno non lavorato (part-time verticale) ' ||
                                         to_char(nvl(cale_ptv.data, sysdate)
                                                ,'dd/mm/yyyy') ||
                                         '; inserimento eseguito'
                                        ,'C');
                        else
                           -- GIORNO LAVORATIVO: verifichiamo precedenti caricamenti da eliminare e assenze giornaliere da ripristinare
                           begin
                              select note
                                    ,rowid
                                into d_pegi_note
                                    ,d_ptv_rowid
                                from periodi_giuridici
                               where rilevanza = 'A'
                                 and ci = dip_ptv.ci
                                 and dal = cale_ptv.data
                                 and al = cale_ptv.data
                                 and utente = s_utente_ptv;
                              -- verifichiamo se avevamo modificato l'astensione di un periodo di assenza preesistente
                              if d_pegi_note like '%' || s_tag_assenza || '%' then
                                 d_pegi_assenza := substr(d_pegi_note
                                                         ,instr(d_pegi_note
                                                               ,s_tag_assenza) + 32
                                                         ,to_number(instr(d_pegi_note
                                                                         ,']'
                                                                         ,instr(d_pegi_note
                                                                               ,s_tag_assenza) + 32)) -
                                                          to_number(instr(d_pegi_note
                                                                         ,s_tag_assenza) + 32));
                                 --                                 dbms_output.put_line('Assenza prec.:' || d_pegi_assenza);
                                 begin
                                    select evento
                                      into d_pegi_evento
                                      from astensioni
                                     where codice = d_pegi_assenza;
                                    /*                                    dbms_output.put_line('Evento prec.:' ||
                                                                                             d_pegi_evento);
                                    */ -- ripristino dei dati modificati quando esisteva il giorno di non lavoro
                                    update periodi_giuridici pegi
                                       set assenza  = d_pegi_assenza
                                          ,evento   = d_pegi_evento
                                          ,utente   = 'Aut.IRIS'
                                          ,data_agg = sysdate
                                          ,note     = replace(pegi.note
                                                             ,s_tag_assenza || '[' ||
                                                              d_pegi_assenza || ']'
                                                             ,' ')
                                     where rowid = d_ptv_rowid;
                                    /*                                    dbms_output.put_line('Eseguita modifica con: ' ||
                                                                                             d_pegi_assenza || ' ' ||
                                                                                             d_pegi_evento);
                                    */
                                    raise prossimo_ptv;
                                 exception
                                    when no_data_found or too_many_rows then
                                       inserisce_log('ERRORE !!! mancata decodifica assenza precedente : ' ||
                                                     to_char(nvl(cale_ptv.data, sysdate)
                                                            ,'dd/mm/yyyy') ||
                                                     '; modifica non eseguita'
                                                    ,'A');
                                       raise prossimo_ptv;
                                    
                                 end;
                              
                              end if;
                              -- verifichiamo se esiste un periodo di assenza preesistente a cui era stata modificata la data finale
                              begin
                                 select note
                                       ,al
                                       ,rowid
                                   into d_pegi_note
                                       ,d_pegi_al
                                       ,d_pegi_rowid
                                   from periodi_giuridici
                                  where rilevanza = 'A'
                                    and ci = dip_ptv.ci
                                    and al = cale_ptv.data - 1;
                                 if d_pegi_note like '%' || s_tag_fine || '%' then
                                    delete from periodi_giuridici
                                     where rowid = d_ptv_rowid;
                                    d_pegi_al_prec := to_date(substr(d_pegi_note
                                                                    ,instr(d_pegi_note
                                                                          ,s_tag_fine) + 30
                                                                    ,10)
                                                             ,'dd/mm/yyyy');
                                    if d_pegi_al + 1 <> d_pegi_al_prec then
                                       inserisce_log('Incongruenza tra la data finale e le note : ' ||
                                                     to_char(nvl(cale_ptv.data, sysdate)
                                                            ,'dd/mm/yyyy') ||
                                                     ' modifica eseguita'
                                                    ,'A');
                                    
                                    end if;
                                    update periodi_giuridici pegi
                                       set al     = al + 1
                                          ,utente = 'Aut.IRIS'
                                          ,note   = replace(pegi.note
                                                           ,s_tag_fine || '[' ||
                                                            to_char(d_pegi_al_prec
                                                                   ,'dd/mm/yyyy') || ']'
                                                           ,' ')
                                     where rowid = d_pegi_rowid;
                                    raise prossimo_ptv;
                                 end if;
                              exception
                                 when no_data_found then
                                    null;
                              end;
                              -- verifichiamo se esiste un periodo di assenza preesistente a cui era stata modificata la data iniziale
                              begin
                                 select note
                                       ,al
                                       ,rowid
                                   into d_pegi_note
                                       ,d_pegi_al
                                       ,d_pegi_rowid
                                   from periodi_giuridici
                                  where rilevanza = 'A'
                                    and ci = dip_ptv.ci
                                    and dal = cale_ptv.data + 1;
                                 if d_pegi_note like '%' || s_tag_inizio || '%' then
                                    delete from periodi_giuridici
                                     where rowid = d_ptv_rowid;
                                    d_pegi_dal_prec := to_date(substr(d_pegi_note
                                                                     ,instr(d_pegi_note
                                                                           ,s_tag_inizio) + 32
                                                                     ,10)
                                                              ,'dd/mm/yyyy');
                                    if d_pegi_dal - 1 <> d_pegi_dal_prec then
                                       inserisce_log('Incongruenza tra la data iniziale e le note : ' ||
                                                     to_char(nvl(cale_ptv.data, sysdate)
                                                            ,'dd/mm/yyyy') ||
                                                     ' modifica eseguita'
                                                    ,'A');
                                    
                                    end if;
                                    update periodi_giuridici pegi
                                       set dal    = dal - 1
                                          ,note   = replace(pegi.note
                                                           ,s_tag_inizio || '[' ||
                                                            to_char(d_pegi_dal_prec
                                                                   ,'dd/mm/yyyy') || ']'
                                                           ,' ')
                                          ,utente = 'Aut.IRIS'
                                     where rowid = d_pegi_rowid;
                                    raise prossimo_ptv;
                                 end if;
                              exception
                                 when no_data_found then
                                    null;
                              end;
                              -- elimino il giorno di non lavoro inserito precedentemente
                              delete from periodi_giuridici where rowid = d_ptv_rowid;
                           exception
                              when no_data_found then
                                 null;
                           end;
                        end if;
                     exception
                        when prossimo_ptv then
                           --                           dbms_output.put_line('Prossimo...');
                           null;
                     end;
                  end loop;
               
               end loop;
            end if;
            --            dbms_output.put_line('Termine gestione Part-Time verticali...');
            si4.sql_execute('ALTER TABLE PERIODI_GIURIDICI ENABLE ALL TRIGGERS');
         end;
      exception
         when errore then
            --            dbms_output.put_line('rollo tutto...');
            rollback;
            update a_prenotazioni
               set errore         = d_errore
                  ,prossimo_passo = decode(d_errore, 'P07301', prossimo_passo, 99)
             where no_prenotazione = prenotazione;
      end; /* 1 */
   end;
end;
/
