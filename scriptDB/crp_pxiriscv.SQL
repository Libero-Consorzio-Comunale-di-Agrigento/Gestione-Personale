create or replace package pxiriscv is
   s_rilevanza        periodi_giuridici.rilevanza%type;
   s_ci_log           periodi_giuridici.ci%type;
   s_operazione_log   assenze_iris.operazione%type := 'S';
   s_dal_log          date;
   s_al_log           date;
   s_assenza_log      periodi_giuridici.assenza%type;
   s_data_agg_log     date;
   s_prenotazione_log a_prenotazioni.no_prenotazione%type;
   s_utente           periodi_giuridici.utente%type;
   s_evento           periodi_giuridici.evento%type;
   s_peir_id          number;
   s_conguaglio       varchar2(2);
   s_blocco           varchar2(2);
   procedure main
   (
      prenotazione in number
     ,passo        in number
   );
   procedure aggiorna_pegi
   (
      p_ci          in number
     ,p_data_inizio in date
   );
   procedure inserisce_log(p_note in varchar2);
   function versione return varchar2;
   /*
      versione
   
      2.0      22/03/2007      MM      Nuova versione consolidata
      2.1      30/04/2007      MM      Att.20553
   
   */
end;
/
create or replace package body pxiriscv is
   function versione return varchar2 is
   begin
      return 'V2.1 del 30/04/2007';
   end versione;
   procedure inserisce_log(p_note in varchar2) is
   begin
      insert into assenze_iris_log
         (ci
         ,operazione
         ,dal
         ,al
         ,assenza
         ,data_agg
         ,note
         ,prenotazione)
      values
         (s_ci_log
         ,s_operazione_log
         ,s_dal_log
         ,s_al_log
         ,s_assenza_log
         ,s_data_agg_log
         ,p_note || ' [id:' || s_peir_id || ']'
         ,s_prenotazione_log);
   end inserisce_log;
   procedure aggiorna_pegi
   (
      p_ci          in number
     ,p_data_inizio in date
   ) is
      data_inizio_c      date;
      data_inizio_p      date;
      data_fine          date;
      data_cong          date;
      d_data_inizio      date;
      d_ultimo_servizio  date;
      d_dal              date;
      d_al               date;
      d_cod_settore_pegi unita_organizzative.codice_uo%type;
      d_cod_sede_pegi    sedi_amministrative.codice%type;
      d_gestione_peir    periodi_giuridici.gestione%type;
      d_sede             rapporti_giuridici.sede%type;
      d_settore          rapporti_giuridici.settore%type;
      w_ragi             rapporti_giuridici%rowtype;
      w_pegi             periodi_giuridici%rowtype;
      t_pegi             periodi_giuridici%rowtype;
      c_pegi             periodi_giuridici%rowtype;
      w_peir             periodi_iris%rowtype;
      d_pegi_rowid       rowid;
      prossimo exception;
   begin
      --dbms_output.put_line('ci: ' || p_ci || ' rilevanza ' || s_rilevanza);
      /* Determinazione della data di inizio della fase di compattazione dei periodi contigui */
      select inmo_sq.nextval into s_peir_id from dual;
      begin
         select nvl(max(dal), p_data_inizio)
           into data_inizio_c
           from periodi_giuridici
          where ci = p_ci
            and rilevanza = s_rilevanza
            and dal <= p_data_inizio;
         --dbms_output.put_line('Inizio periodo per compattazione ' || data_inizio_c);
      exception
         when no_data_found then
            data_inizio_c := p_data_inizio;
      end;
      begin
         data_cong := null;
         begin
            select * into w_ragi from rapporti_giuridici where ci = p_ci;
            data_cong := w_ragi.d_cong;
         exception
            when no_data_found then
               -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante il Rapporto Giuridico non presente
               s_dal_log := null;
               s_al_log  := null;
               inserisce_log('Rapporto Giuridico non presente');
               raise prossimo;
         end;
         begin
            --estraggo la data di fine trattamento per il ci
            select greatest(max(pegi.dal), max(peir.dal))
              into data_fine
              from periodi_giuridici pegi
                  ,periodi_iris      peir
             where pegi.ci = p_ci
               and peir.ci = p_ci
               and pegi.rilevanza = s_rilevanza;
         exception
            when no_data_found then
               --dbms_output.put_line('Periodi di servizio non presenti');
               null;
         end;
         data_inizio_p := p_data_inizio;
         d_data_inizio := p_data_inizio;
         while (d_data_inizio <= data_fine)
         loop
            /*            dbms_output.put_line(p_ci);
                        dbms_output.put_line('Data inizio ' || d_data_inizio);
                        dbms_output.put_line('Data fine   ' || data_fine);
            */ --seleziono il primo periodo di PEGI maggiore o uguale della data da trattare
            <<peir>>
            begin
               select pegi.*
                 into w_pegi
                 from periodi_giuridici pegi
                where d_data_inizio between dal and nvl(al, to_date(3333333, 'j'))
                  and ci = p_ci
                  and rilevanza = s_rilevanza;
            
               select rowid
                 into d_pegi_rowid
                 from periodi_giuridici
                where ci = p_ci
                  and rilevanza = s_rilevanza
                  and dal = w_pegi.dal;
            
               data_cong := least(w_pegi.dal, nvl(w_ragi.d_cong, to_date(3333333, 'j')));
            
               d_cod_settore_pegi := gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(w_pegi.settore)
                                                           ,'GP4'
                                                           ,nvl(w_pegi.al
                                                               ,to_date(3333333, 'j')));
            
               d_cod_sede_pegi := gp4_sdam.get_codice_numero(w_pegi.sede);
            
            exception
               when no_data_found then
                  if w_peir.dal is not null and w_peir.al is not null then
                     s_dal_log := d_data_inizio;
                     s_al_log  := nvl(w_peir.al, data_fine);
                     begin
                        select dal
                          into d_data_inizio
                          from periodi_giuridici
                         where dal > d_data_inizio
                           and ci = p_ci
                           and rilevanza = s_rilevanza
                           and dal = (select min(dal)
                                        from periodi_giuridici
                                       where dal > d_data_inizio
                                         and ci = p_ci
                                         and rilevanza = s_rilevanza);
                        --dbms_output.put_line('Nuova data di inizio ' || d_data_inizio);
                        goto peir;
                     exception
                        when no_data_found then
                           inserisce_log('Ril. ' || s_rilevanza ||
                                         ': Interruzione dei periodi giuridici incompatibile con la progressione dei periodi di IRIS');
                           /*                           dbms_output.put_line('Periodo esterno al servizio ' || ' ' ||
                                                                           w_peir.dal || ' ' || w_peir.al ||
                                                                           ' per ' || d_data_inizio);
                           */
                           goto fusione;
                     end;
                     /*                     inserisce_log('Interruzione dei periodi giuridici incompatibile con la progressione dei periodi di IRIS');
                                          dbms_output.put_line('Periodo esterno al servizio ' || ' ' ||
                                                               w_peir.dal || ' ' || w_peir.al || ' per ' ||
                                                               d_data_inizio);
                     */
                  end if;
                  goto fusione;
                  --        raise prossimo;
            end;
            data_inizio_c := least(data_inizio_c, w_pegi.dal);
            --            dbms_output.put_line('periodo di pegi ' || w_pegi.dal || ' ' || w_pegi.al);
            -- seleziono il primo periodo di T430 che interseca il periodo di PEGI
         
            begin
               select *
                 into w_peir
                 from periodi_iris
                where ci = p_ci
                  and dal <= nvl(w_pegi.al, to_date(3333333, 'j'))
                  and nvl(al, to_date(3333333, 'j')) >= w_pegi.dal
                  and dal = (select min(dal)
                               from periodi_iris
                              where ci = p_ci
                                and dal <= nvl(w_pegi.al, to_date(3333333, 'j'))
                                and nvl(al, to_date(3333333, 'j')) >= w_pegi.dal);
            
               d_gestione_peir := gp4_stam.get_gestione(gp4_stam.get_ni_numero(w_peir.num_settore));
            
               select s_peir_id + inmo_sq.nextval into s_peir_id from dual;
            
            exception
               when no_data_found then
                  dbms_output.put_line('no_data_found B');
            end;
            /*            dbms_output.put_line('tratta periodi - pegi ' || w_pegi.dal || ' - ' ||
                                             w_pegi.al || ' peir ' || w_peir.dal || ' - ' ||
                                             w_peir.al);
            */
            if w_peir.num_settore is null then
               -- inserisco in ASSENZE_IRIS_LOG la registrazione per il settore non presente
               s_dal_log := w_peir.dal;
               s_al_log  := w_peir.al;
               inserisce_log('Settore ' || w_peir.cod_settore || ' non previsto');
            elsif w_peir.num_sede is null then
               -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante per la sede non presente
               s_dal_log := w_peir.dal;
               s_al_log  := w_peir.al;
               inserisce_log('Sede ' || w_peir.cod_sede || ' non prevista');
            end if;
            if w_pegi.gestione <> d_gestione_peir then
               /* segnalazione non bloccante di cambio di gestione */
               s_dal_log := w_peir.dal;
               s_al_log  := w_peir.al;
               s_peir_id := s_peir_id + 1;
               inserisce_log('Ril. ' || s_rilevanza || ': cambio di gestione da ' ||
                             w_pegi.gestione || ' a ' || d_gestione_peir);
            end if;
            if nvl(w_peir.al, to_date(3333333, 'j')) <
               nvl(w_pegi.al, to_date(3333333, 'j')) then
               dbms_output.put_line('caso 1 update AL: pegi ' || w_pegi.dal || ' - ' ||
                                    w_pegi.al || ' peir ' || w_peir.dal || ' - ' ||
                                    w_peir.al);
               begin
                  update periodi_giuridici
                     set dal      = w_peir.dal
                        ,al       = w_peir.al
                        ,data_agg = sysdate
                        ,utente   = s_utente
                   where ci = p_ci
                     and dal = w_pegi.dal
                     and rilevanza = s_rilevanza;
                  -- aggiorniamo le date di inquadramento e di RAGI
                  update rapporti_giuridici
                     set d_cong = decode(s_conguaglio
                                        ,'SI'
                                        ,least(nvl(d_cong, to_date('3333333', 'j'))
                                              ,to_date('01' ||
                                                       to_char(data_cong, 'mmyyyy')
                                                      ,'ddmmyyyy'))
                                        ,d_cong)
                        ,d_coni = least(nvl(d_coni, to_date('3333333', 'j')), data_cong)
                        ,d_inqe = least(nvl(d_inqe, to_date('3333333', 'j')), data_cong)
                   where ci = p_ci;
                  -- se cambia una delle sedi cambia anche l'evento
                  if w_pegi.sede != w_peir.num_sede or
                     w_pegi.settore != w_peir.num_settore then
                     update periodi_giuridici
                        set settore  = w_peir.num_settore
                           ,sede     = w_peir.num_sede
                           ,evento   = s_evento
                           ,utente   = s_utente
                           ,data_agg = sysdate
                      where ci = p_ci
                        and rowid = d_pegi_rowid
                        and rilevanza = s_rilevanza;
                  end if;
                  -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante le modifiche
                  s_dal_log := w_peir.dal;
                  s_al_log  := w_peir.al;
                  inserisce_log('Ril. ' || s_rilevanza || ': nuovi settore ' ||
                                w_peir.cod_settore || ' e sede ' || w_peir.cod_sede);
               exception
                  when others then
                     s_dal_log := w_peir.al + 1;
                     s_al_log  := to_date(null);
                  
                     inserisce_log('Ril. ' || s_rilevanza ||
                                   ': Interruzione dei periodi di IRIS incompatibile con la progressione dei periodi giuridici ' ||
                                   to_char(w_pegi.dal, 'dd/mm/yyyy') || ' - ' ||
                                   to_char(w_pegi.al, 'dd/mm/yyyy') ||
                                   '; le variazioni successive non sono state elaborate');
                     goto fusione;
               end;
               /*               dbms_output.put_line('w_peir.al ' || w_peir.al);
                              dbms_output.put_line('Insert ' || w_pegi.evento);
                              dbms_output.put_line('Pegi.sede ' || w_pegi.sede || ' Pegi.settore ' ||
                                                   w_pegi.settore);
                              dbms_output.put_line('Peir.sede ' || w_peir.num_sede || ' Peir.settore ' ||
                                                   w_peir.num_settore);
               */
               insert into periodi_giuridici
                  (ci
                  ,rilevanza
                  ,dal
                  ,al
                  ,evento
                  ,posizione
                  ,tipo_rapporto
                  ,sede_posto
                  ,anno_posto
                  ,numero_posto
                  ,posto
                  ,sostituto
                  ,qualifica
                  ,ore
                  ,figura
                  ,attivita
                  ,gestione
                  ,settore
                  ,sede
                  ,gruppo
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
                  (p_ci
                  ,s_rilevanza
                  ,w_peir.al + 1
                  ,w_pegi.al
                  ,s_evento
                  ,w_pegi.posizione
                  ,w_pegi.tipo_rapporto
                  ,w_pegi.sede_posto
                  ,w_pegi.anno_posto
                  ,w_pegi.numero_posto
                  ,w_pegi.posto
                  ,w_pegi.sostituto
                  ,w_pegi.qualifica
                  ,w_pegi.ore
                  ,w_pegi.figura
                  ,w_pegi.attivita
                  ,w_pegi.gestione
                  ,w_pegi.settore
                  ,w_pegi.sede
                  ,w_pegi.gruppo
                  ,w_pegi.assenza
                  ,w_pegi.confermato
                  ,w_pegi.note
                  ,w_pegi.note_al1
                  ,w_pegi.note_al2
                  ,w_pegi.sede_del
                  ,w_pegi.anno_del
                  ,w_pegi.numero_del
                  ,s_utente
                  ,sysdate);
               -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante le modifiche
               s_dal_log := w_peir.al + 1;
               s_al_log  := w_pegi.al;
               inserisce_log('Ril. ' || s_rilevanza ||
                             ': aggiornamento periodo su settore ' || d_cod_settore_pegi ||
                             ' e sede ' || d_cod_sede_pegi);
               /* verifica la necesita di inserire un nuovo periodo giuridico nel caso l'inizio del periodo
               di peir non coincida con l'inizio del periodo di pegi */
               if nvl(w_peir.dal, to_date(3333333, 'j')) > w_pegi.dal then
                  insert into periodi_giuridici
                     (ci
                     ,rilevanza
                     ,dal
                     ,al
                     ,evento
                     ,posizione
                     ,tipo_rapporto
                     ,sede_posto
                     ,anno_posto
                     ,numero_posto
                     ,posto
                     ,sostituto
                     ,qualifica
                     ,ore
                     ,figura
                     ,attivita
                     ,gestione
                     ,settore
                     ,sede
                     ,gruppo
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
                     (p_ci
                     ,s_rilevanza
                     ,w_pegi.dal
                     ,w_peir.dal - 1
                     ,w_pegi.evento
                     ,w_pegi.posizione
                     ,w_pegi.tipo_rapporto
                     ,w_pegi.sede_posto
                     ,w_pegi.anno_posto
                     ,w_pegi.numero_posto
                     ,w_pegi.posto
                     ,w_pegi.sostituto
                     ,w_pegi.qualifica
                     ,w_pegi.ore
                     ,w_pegi.figura
                     ,w_pegi.attivita
                     ,w_pegi.gestione
                     ,w_pegi.settore
                     ,w_pegi.sede
                     ,w_pegi.gruppo
                     ,w_pegi.assenza
                     ,w_pegi.confermato
                     ,w_pegi.note
                     ,w_pegi.note_al1
                     ,w_pegi.note_al2
                     ,w_pegi.sede_del
                     ,w_pegi.anno_del
                     ,w_pegi.numero_del
                     ,s_utente
                     ,sysdate);
                  -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante le modifiche
                  s_dal_log := w_pegi.dal;
                  s_al_log  := w_peir.dal - 1;
                  inserisce_log('Ril. ' || s_rilevanza ||
                                ':   Assestato il periodo preesistente ' ||
                                to_char(w_pegi.dal, 'dd/mm/yyyy') || ' - ' ||
                                to_char(w_pegi.al, 'dd/mm/yyyy'));
               end if;
               d_data_inizio := w_peir.al + 1;
               dbms_output.put_line(d_data_inizio || ' cerco nuovo peir');
               goto peir; -- #########
            end if;
            if w_pegi.dal >= w_peir.dal and nvl(w_pegi.al, to_date(3333333, 'j')) <=
               nvl(w_peir.al, to_date(3333333, 'j')) then
               dbms_output.put_line('caso 2 il periodo di pegi e contenuto nel periodo di peir: pegi ' ||
                                    w_pegi.dal || ' - ' || w_pegi.al || ' peir ' ||
                                    w_peir.dal || ' - ' || w_peir.al);
               -- il periodo di pegi e contenuto nel periodo di periodi_iris
               --dbms_output.put_line('periodo di pegi contenuto in peir');
               -- controllo se ila sede o il settore di periodi_iris sono diverse da quelle di periodi_giuridici, se si eseguo l'update
               --dbms_output.put_line('Settore di PEGI ' || w_pegi.settore);
               --dbms_output.put_line('Settore di PEIR ' || w_peir.num_settore);
               if (w_pegi.settore != w_peir.num_settore) or
                  (w_pegi.sede != w_peir.num_sede) then
                  begin
                     update periodi_giuridici
                        set settore  = w_peir.num_settore
                           ,sede     = w_peir.num_sede
                           ,evento   = s_evento
                           ,utente   = s_utente
                           ,data_agg = sysdate
                      where ci = p_ci
                        and rilevanza = s_rilevanza
                        and rowid = d_pegi_rowid;
                     -- aggiorniamo le date di inquadramento e di RAGI
                     update rapporti_giuridici
                        set d_cong = decode(s_conguaglio
                                           ,'SI'
                                           ,least(nvl(d_cong, to_date('3333333', 'j'))
                                                 ,to_date('01' ||
                                                          to_char(data_cong, 'mmyyyy')
                                                         ,'ddmmyyyy'))
                                           ,d_cong)
                           ,d_coni = least(nvl(d_coni, to_date('3333333', 'j'))
                                          ,data_cong)
                           ,d_inqe = least(nvl(d_inqe, to_date('3333333', 'j'))
                                          ,data_cong)
                      where ci = p_ci;
                     dbms_output.put_line('Update settore');
                     -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante le modifiche
                     s_dal_log := w_pegi.dal;
                     s_al_log  := w_pegi.al;
                     inserisce_log('Ril. ' || s_rilevanza || ': nuovi settore ' ||
                                   w_peir.cod_settore || ' e sede ' || w_peir.cod_sede);
                  end;
               end if;
               d_data_inizio := nvl(w_pegi.al, to_date(3333333, 'j')) + 1;
               dbms_output.put_line(d_data_inizio || ' cerco nuovo peir');
               goto peir; -- #########
            end if;
            if nvl(w_peir.al, to_date(3333333, 'j')) =
               nvl(w_pegi.al, to_date(3333333, 'j')) and w_peir.dal > w_pegi.dal then
               dbms_output.put_line('caso 3 peir contenuto in pegi con fine coincidente: pegi ' ||
                                    w_pegi.dal || ' - ' || w_pegi.al || ' peir ' ||
                                    w_peir.dal || ' - ' || w_peir.al);
               begin
                  update periodi_giuridici
                     set dal      = w_peir.dal
                        ,data_agg = sysdate
                        ,utente   = s_utente
                   where ci = p_ci
                     and dal = w_pegi.dal
                     and rilevanza = s_rilevanza;
                  -- aggiorniamo le date di inquadramento e di RAGI
                  update rapporti_giuridici
                     set d_cong = decode(s_conguaglio
                                        ,'SI'
                                        ,least(nvl(d_cong, to_date('3333333', 'j'))
                                              ,to_date('01' ||
                                                       to_char(data_cong, 'mmyyyy')
                                                      ,'ddmmyyyy'))
                                        ,d_cong)
                        ,d_coni = least(nvl(d_coni, to_date('3333333', 'j')), data_cong)
                        ,d_inqe = least(nvl(d_inqe, to_date('3333333', 'j')), data_cong)
                   where ci = p_ci;
                  -- se cambia una delle sedi cambia anche l'evento
                  if w_pegi.sede != w_peir.num_sede or
                     w_pegi.settore != w_peir.num_settore then
                     update periodi_giuridici
                        set settore  = w_peir.num_settore
                           ,sede     = w_peir.num_sede
                           ,evento   = s_evento
                           ,utente   = s_utente
                           ,data_agg = sysdate
                      where ci = p_ci
                        and rowid = d_pegi_rowid
                        and rilevanza = s_rilevanza;
                  end if;
                  -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante le modifiche
                  s_dal_log := w_peir.dal;
                  s_al_log  := w_peir.al;
                  inserisce_log('Ril. ' || s_rilevanza || ': nuovi settore ' ||
                                w_peir.cod_settore || ' e sede ' || w_peir.cod_sede);
                  insert into periodi_giuridici
                     (ci
                     ,rilevanza
                     ,dal
                     ,al
                     ,evento
                     ,posizione
                     ,tipo_rapporto
                     ,sede_posto
                     ,anno_posto
                     ,numero_posto
                     ,posto
                     ,sostituto
                     ,qualifica
                     ,ore
                     ,figura
                     ,attivita
                     ,gestione
                     ,settore
                     ,sede
                     ,gruppo
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
                     (p_ci
                     ,s_rilevanza
                     ,w_pegi.dal
                     ,w_peir.dal - 1
                     ,w_pegi.evento
                     ,w_pegi.posizione
                     ,w_pegi.tipo_rapporto
                     ,w_pegi.sede_posto
                     ,w_pegi.anno_posto
                     ,w_pegi.numero_posto
                     ,w_pegi.posto
                     ,w_pegi.sostituto
                     ,w_pegi.qualifica
                     ,w_pegi.ore
                     ,w_pegi.figura
                     ,w_pegi.attivita
                     ,w_pegi.gestione
                     ,w_pegi.settore
                     ,w_pegi.sede
                     ,w_pegi.gruppo
                     ,w_pegi.assenza
                     ,w_pegi.confermato
                     ,w_pegi.note
                     ,w_pegi.note_al1
                     ,w_pegi.note_al2
                     ,w_pegi.sede_del
                     ,w_pegi.anno_del
                     ,w_pegi.numero_del
                     ,s_utente
                     ,sysdate);
                  -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante le modifiche
                  s_dal_log := w_pegi.dal;
                  s_al_log  := w_peir.dal - 1;
                  inserisce_log('Ril. ' || s_rilevanza ||
                                ': Assestato il periodo preesistente ' ||
                                to_char(w_pegi.dal, 'dd/mm/yyyy') || ' - ' ||
                                to_char(w_pegi.al, 'dd/mm/yyyy'));
                  d_data_inizio := nvl(w_peir.al, to_date(3333333, 'j')) + 1;
                  dbms_output.put_line(d_data_inizio || ' cerco nuovo peir');
                  goto peir; -- #########
               exception
                  when others then
                     dbms_output.put_line('no_data_found C');
               end;
            
            end if;
            if nvl(w_peir.al, to_date(3333333, 'j')) >=
               nvl(w_pegi.al, to_date(3333333, 'j')) then
               -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante il periodo incompatibile
               dbms_output.put_line('caso 4 il periodo incompatibile ' || w_pegi.dal ||
                                    ' - ' || w_pegi.al || ' peir ' || w_peir.dal ||
                                    ' - ' || w_peir.al);
               s_dal_log := w_peir.dal;
               s_al_log  := w_peir.al;
               inserisce_log('Ril. ' || s_rilevanza ||
                             ': Periodo incompatibile con la progressione dei periodi giuridici ' ||
                             to_char(w_pegi.dal, 'dd/mm/yyyy') || ' - ' ||
                             to_char(w_pegi.al, 'dd/mm/yyyy') ||
                             '; le variazioni successive non sono state elaborate');
               goto fusione;
            end if;
         end loop;
         <<fusione>>
      --fusione dei periodi contigui uguali
         d_ultimo_servizio := null;
         begin
            select nvl(dal, to_date(3333333, 'j'))
              into d_ultimo_servizio
              from periodi_giuridici pegi
             where rilevanza = s_rilevanza
               and dal = (select max(dal)
                            from periodi_giuridici
                           where ci = pegi.ci
                             and rilevanza = s_rilevanza)
               and ci = p_ci;
            dbms_output.put_line('Ultimo periodo di servizio : ' || d_ultimo_servizio);
         exception
            when no_data_found then
               -- inserisco in ASSENZE_IRIS_LOG la registrazione riguardante il periodo di servizio non presente
               s_dal_log := null;
               s_al_log  := null;
               --               inserisce_log('Periodi di servizio non presenti');
               dbms_output.put_line('Ultimo periodo di servizio non presente');
               dbms_output.put_line(s_rilevanza || ' ' || d_ultimo_servizio || ' ' || p_ci);
               raise prossimo;
         end;
         dbms_output.put_line('Fusione dei periodi');
         dbms_output.put_line('Data inizio compattazione' || data_inizio_c);
      
         while (data_inizio_c < data_fine) and (data_inizio_c < d_ultimo_servizio)
         loop
            begin
               select *
                 into c_pegi
                 from periodi_giuridici
                where dal >= data_inizio_c
                  and ci = p_ci
                  and rilevanza = s_rilevanza
                  and dal = (select min(dal)
                               from periodi_giuridici
                              where ci = p_ci
                                and rilevanza = s_rilevanza
                                and dal >= data_inizio_c);
            exception
               when no_data_found then
                  dbms_output.put_line('no_data_found A in fusione periodi');
            end;
            --seleziono il prossimo periodo di PEGI
            begin
               select *
                 into t_pegi
                 from periodi_giuridici
                where ci = p_ci
                  and rilevanza = s_rilevanza
                  and dal = (select min(dal)
                               from periodi_giuridici
                              where ci = p_ci
                                and rilevanza = s_rilevanza
                                and dal > c_pegi.dal);
               dbms_output.put_line('periodo di pegi contiguo ' || t_pegi.dal || ' ' ||
                                    t_pegi.al);
            exception
               when no_data_found then
                  dbms_output.put_line('no_data_found B in fusione periodi');
            end;
            if t_pegi.dal = c_pegi.al + 1 then
               dbms_output.put_line('Ho trovato dei periodi che potrebbero essere uniti');
               --controllo se i due record hanno i seguenti campi uguali
               if nvl(t_pegi.evento, ' ') = nvl(c_pegi.evento, ' ') and
                  nvl(t_pegi.posizione, ' ') = nvl(c_pegi.posizione, ' ') and
                  nvl(t_pegi.tipo_rapporto, ' ') = nvl(c_pegi.tipo_rapporto, ' ') and
                  nvl(t_pegi.sede_posto, ' ') = nvl(c_pegi.sede_posto, ' ') and
                  nvl(t_pegi.anno_posto, 0) = nvl(c_pegi.anno_posto, 0) and
                  nvl(t_pegi.numero_posto, 0) = nvl(c_pegi.numero_posto, 0) and
                  nvl(t_pegi.posto, 0) = nvl(c_pegi.posto, 0) and
                  nvl(t_pegi.sostituto, 0) = nvl(c_pegi.sostituto, 0) and
                  nvl(t_pegi.qualifica, 0) = nvl(c_pegi.qualifica, 0) and
                  nvl(t_pegi.ore, 0) = nvl(c_pegi.ore, 0) and
                  nvl(t_pegi.figura, 0) = nvl(c_pegi.figura, 0) and
                  nvl(t_pegi.attivita, ' ') = nvl(c_pegi.attivita, ' ') and
                  nvl(t_pegi.gestione, ' ') = nvl(c_pegi.gestione, ' ') and
                  nvl(t_pegi.settore, 0) = nvl(c_pegi.settore, 0) and
                  nvl(t_pegi.sede, 0) = nvl(c_pegi.sede, 0) and
                  nvl(t_pegi.gruppo, ' ') = nvl(c_pegi.gruppo, ' ') and
                  nvl(t_pegi.assenza, ' ') = nvl(c_pegi.assenza, ' ') and
                  nvl(t_pegi.confermato, 0) = nvl(c_pegi.confermato, 0) and
                  nvl(t_pegi.note, ' ') = nvl(c_pegi.note, ' ') and
                  nvl(t_pegi.note_al1, ' ') = nvl(c_pegi.note_al1, ' ') and
                  nvl(t_pegi.note_al2, ' ') = nvl(c_pegi.note_al2, ' ') and
                  nvl(t_pegi.sede_del, ' ') = nvl(c_pegi.sede_del, ' ') and
                  nvl(t_pegi.anno_del, 0) = nvl(c_pegi.anno_del, 0) and
                  nvl(t_pegi.numero_del, 0) = nvl(c_pegi.numero_del, 0) then
                  dbms_output.put_line('Li ho uniti');
                  delete from periodi_giuridici
                   where ci = p_ci
                     and rilevanza = s_rilevanza
                     and dal = t_pegi.dal;
                  update periodi_giuridici
                     set al       = t_pegi.al
                        ,utente   = s_utente
                        ,data_agg = sysdate
                   where ci = p_ci
                     and rilevanza = s_rilevanza
                     and dal = c_pegi.dal;
                  data_inizio_c := c_pegi.dal;
               else
                  data_inizio_c := t_pegi.dal;
               end if;
            else
               data_inizio_c := t_pegi.dal;
            end if;
            dbms_output.put_line('Data inizio compattazione dopo ' || data_inizio_c);
         end loop;
         dbms_output.put_line('Data Conguaglio e Inquadramento ' || data_cong);
         begin
            select dal
                  ,al
                  ,sede
                  ,settore
              into d_dal
                  ,d_al
                  ,d_sede
                  ,d_settore
              from periodi_giuridici
             where rilevanza = s_rilevanza
               and ci = p_ci
               and dal = (select max(dal)
                            from periodi_giuridici
                           where ci = p_ci
                             and rilevanza = s_rilevanza);
         exception
            /* Gestiamo la no data found per i casi errati (ma presenti) di individui senza periodi di servizio */
            when no_data_found then
               null;
         end;
         update rapporti_giuridici
            set d_cong    = decode(s_conguaglio
                                  ,'SI'
                                  ,least(nvl(d_cong, to_date('3333333', 'j'))
                                        ,to_date('01' || to_char(data_cong, 'mmyyyy')
                                                ,'ddmmyyyy'))
                                  ,d_cong)
               ,d_coni    = least(nvl(d_coni, to_date('3333333', 'j')), data_cong)
               ,d_inqe    = least(nvl(d_inqe, to_date('3333333', 'j'))
                                 ,data_cong - 1
                                 ,data_inizio_c - 1)
               ,flag_inqe = decode(flag_inqe, 'A', 'A', 'M')
               ,settore   = d_settore
               ,sede      = d_sede
               ,dal       = d_dal
               ,al        = d_al
          where ci = p_ci;
      exception
         when prossimo then
            dbms_output.put_line('Prossimo');
      end;
   end aggiorna_pegi;
   procedure main
   (
      prenotazione in number
     ,passo        in number
   ) is
   begin
      declare
         data_inizio date;
         d_ni        number(8);
         d_ci        number(8);
         d_rilevanze varchar2(4);
         d_blocco    varchar2(2);
         d_errore    varchar(6);
         errore exception;
         prossimo exception;
         num_elab number;
         -- cursore degli individui con variazioni di settore
         cursor vase is
            select max(rain.ni)
                  ,rain.ci
                  ,min(devs.dal)
              from rapporti_individuali        rain
                  ,deposito_variazioni_settore devs
             where rain.ni = devs.ni
               and devs.dal between rain.dal and nvl(rain.al, to_date(3333333, 'j'))
               and exists (select 'x'
                      from classi_rapporto
                     where codice = rain.rapporto
                       and giuridico = 'SI'
                       and presenza = 'SI')
             group by rain.ci;
         -- cursore dei periodi giuridici influenzati dalle variazioni
         cursor pegi(p_ci number, p_dal date) is
            select *
              from periodi_giuridici pegi
             where ci = p_ci
               and rilevanza = s_rilevanza
               and dal >= p_dal;
      begin
         begin
            dbms_output.put_line('Inizio');
            select 'Aut.IRIS'
              into s_utente
              from a_prenotazioni
             where no_prenotazione = prenotazione;
         exception
            when no_data_found then
               s_utente := 'Aut.IRIS';
         end;
         begin
            select valore_default
              into s_evento
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_EVENTO';
            begin
               select codice into s_evento from eventi_giuridici where codice = s_evento;
            exception
               when no_data_found then
                  d_errore := 'P05809';
                  raise errore;
            end;
         exception
            when no_data_found then
               --d_evento := TO_CHAR(NULL);
               d_errore := 'P05809';
               raise errore;
         end;
         /* Verifichiamo se e richiesto il blocco dell'elaborazione se esistono
         individui in fase di calcolo retribuzione */
         begin
            select valore_default
              into d_blocco
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_BLOCCO';
            if d_blocco not in ('SI', 'NO') then
               d_errore := 'P05809';
               raise errore;
            end if;
         exception
            when no_data_found then
               d_blocco := 'NO';
         end;
         /* Verifichiamo se e richiesta l'attivazione del conguaglio giuridico */
         begin
            select valore_default
              into s_conguaglio
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_CONGUAGLIO';
            if s_conguaglio not in ('SI', 'NO') then
               d_errore := 'P05809';
               raise errore;
            end if;
         exception
            when no_data_found then
               s_conguaglio := 'NO';
         end;
         /* Verifichiamo se e richiesto l'aggiornamento su altre rilevanze oltre la S
            Le condizioni previste sono:
            S             Sola rilevanza S (default)
            SQ            Rilevanze S e Q: la gestione degli incarichi resta di competenza
                          esclusiva dell'ufficio giuridico
            SE            Rilevanze S ed E: la gestione degli inquadramenti resta di competenza
                          esclusiva dell'ufficio giuridico
            SQIE          Attivo su tutte le rilevanze
         */
         begin
            select valore_default
              into d_rilevanze
              from a_selezioni
             where voce_menu = 'PXIRISCV'
               and parametro = 'P_RILEVANZE';
            if d_rilevanze not in ('S', 'SQ', 'SE', 'SQEI') then
               d_errore := 'P05809';
               raise errore;
            end if;
         exception
            when no_data_found then
               d_rilevanze := 'S';
         end;
         /* Verifichiamo la necessita di un blocco dell'elaborazione dovuto alla
         presenza di individui in fase di calcolo */
         begin
            if d_blocco = 'SI' then
               select count(*)
                 into num_elab
                 from rapporti_giuridici
                where flag_elab in ('S', 'P', 'E');
               if num_elab > 0 then
                  dbms_output.put_line('Stipendi in corso, esco');
                  return;
               end if;
            end if;
         exception
            when others then
               dbms_output.put_line('Riscontrati problemi nella verifica dei dipendenti in fase di elaborazione');
               s_dal_log := null;
               s_al_log  := null;
               inserisce_log('Riscontrati problemi nella verifica dei dipendenti in fase di elaborazione');
               return;
         end;
      
         /* Cancellazione delle precedenti segnalazioni dalla tabella di log */
         s_prenotazione_log := prenotazione;
      
         delete from assenze_iris_log
          where operazione = 'S'
            and (data_prenotazione < sysdate - 540 or prenotazione = s_prenotazione_log);
      
         begin
            --    LOCK TABLE PERIODI_GIURIDICI IN EXCLUSIVE MODE;
            --  Si4.sql_execute('ALTER TABLE PERIODI_GIURIDICI DISABLE ALL TRIGGERS');
            open vase;
            loop
               fetch vase
                  into d_ni, d_ci, data_inizio;
               exit when vase%notfound;
               s_ci_log       := d_ci;
               s_peir_id      := 0;
               s_data_agg_log := sysdate;
               dbms_output.put_line('Individuo CI : ' || d_ci);
               if d_rilevanze like '%Q%' then
                  s_rilevanza := 'Q';
                  aggiorna_pegi(d_ci, data_inizio);
               end if;
               if d_rilevanze like '%I%' then
                  s_rilevanza := 'I';
                  aggiorna_pegi(d_ci, data_inizio);
               end if;
               if d_rilevanze like '%S%' then
                  s_rilevanza := 'S';
                  aggiorna_pegi(d_ci, data_inizio);
               end if;
               if d_rilevanze like '%E%' then
                  s_rilevanza := 'E';
                  aggiorna_pegi(d_ci, data_inizio);
               end if;
               --cancello le registrazioni riguardanti il ci che abbiamo finito di trattare dalla tabella deposito_variazioni_settore
               delete from deposito_variazioni_settore where ni = d_ni;
            end loop;
            close vase;
            --  Si4.sql_execute('ALTER TABLE PERIODI_GIURIDICI ENABLE ALL TRIGGERS');
         end;
      exception
         when errore then
            dbms_output.put_line('Errore');
            --            rollback;
            update a_prenotazioni
               set errore         = d_errore
                  ,prossimo_passo = decode(d_errore, 'P07301', prossimo_passo, 99)
             where no_prenotazione = prenotazione;
      end;
      --      commit;
   end;
end;
/
