create or replace package gp4do_start is
   function versione return varchar2;
   procedure leggimi;
   procedure inizializza_gp4do
   (
      p_pedo         in varchar2
     ,p_subentri     in varchar2
     ,p_sostituzioni in varchar2
   );
   procedure inizializza_tabelle;
   procedure inizializza_periodi_dotazione;
   procedure inizializza_subentri;
   procedure inizializza_sostituzioni;
   /**************************************************************************************************************
      NAME:       GP4DO
      PURPOSE:    Contiene tutti gli oggetti PL/SQL del Modulo Dotazione Organica
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        19/07/2002                   Nuova procedure per inizializzazione tabelle do (Att. 16265)
   ****************************************************************************************************************/
end gp4do_start;
/
create or replace package body gp4do_start as
   function versione return varchar2 is
      /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
       PARAMETRI:   --
       RITORNA:     stringa varchar2 contenente versione e data.
       NOTE:        Il secondo numero della versione corrisponde alla revisione
                    del package.
      ******************************************************************************/
   begin
      return 'V1.0 del 12/06/2006';
   end versione;
   --
   procedure leggimi is
      /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Istruzioni per l'uso
      ******************************************************************************/
      d_testo varchar2(4000);
   begin
      d_testo := chr(10) || chr(10) || chr(10) || chr(10) || chr(10) || chr(10) ||
                 chr(10) || chr(10) || 'Istruzioni per l''uso.' || chr(10) || chr(10) ||
                 chr(10) || chr(10) || chr(10);
      dbms_output.put_line(d_testo);
      d_testo := 'Elenco delle procedure:' || chr(10) || chr(10);
      dbms_output.put_line(d_testo);
      d_testo := 'INIZIALIZZA_TABELLE  ' || chr(10) ||
                 'Allinea le tabelle di utilita generale (POSIZIONI,DOTAZIONE_ORGANICA,PERIODI_DOTAZIONE)';
      dbms_output.put_line(d_testo);
      d_testo := 'Utilizzo: exec gp4do_stato.inizializza_tabelle;' || chr(10);
      dbms_output.put_line(d_testo);
      d_testo := 'INIZIALIZZA_SUBENTRI' || chr(10) ||
                 'Allinea le tabelle di utilita generale (POSIZIONI,DOTAZIONE_ORGANICA,PERIODI_DOTAZIONE)';
      dbms_output.put_line(d_testo);
      d_testo := 'Utilizzo: exec gp4do_stato.inizializza_tabelle;' || chr(10);
      dbms_output.put_line(d_testo);
      d_testo := 'INIZIALIZZA_SOSTITUZIONI' || chr(10) ||
                 'Allinea le tabelle di utilita generale (POSIZIONI,DOTAZIONE_ORGANICA,PERIODI_DOTAZIONE)';
      dbms_output.put_line(d_testo);
      d_testo := 'Utilizzo: exec gp4do_stato.inizializza_tabelle;' || chr(10);
      dbms_output.put_line(d_testo);
      d_testo := 'INIZIALIZZA_PERIODI_DOTAZIONE' || chr(10) ||
                 'allinea le tabelle di utilita generale (POSIZIONI,DOTAZIONE_ORGANICA,PERIODI_DOTAZIONE)';
      dbms_output.put_line(d_testo);
      d_testo := 'Utilizzo: exec gp4do_stato.inizializza_tabelle;' || chr(10);
      dbms_output.put_line(d_testo);
      d_testo := 'LEGGIMI' || chr(10) ||
                 'Queste istruzioni. Utilizzo: exec gp4do_stato.inizializza_tabelle;';
      dbms_output.put_line(d_testo);
   end leggimi;
   --
   procedure inizializza_tabelle is
      d_revisione_m       number(8);
      d_revisione_a       number(8);
      d_revisione_modello number(8);
      d_dal_m             date;
      d_dal_a             date;
      d_data              date;
      d_par_1             varchar2(15) := to_char(null);
      d_par_2             varchar2(15) := to_char(null);
      d_par_3             varchar2(15) := to_char(null);
      d_par_4             varchar2(15) := to_char(null);
      d_par_5             varchar2(15) := to_char(null);
      d_dummy             varchar2(1);
      d_comando_1         varchar2(4000);
      d_comando_2         varchar2(4000);
      d_comando_3         varchar2(4000);
      d_max_id            number;
   begin
      d_revisione_a := gp4do.get_revisione_a;
      d_revisione_m := gp4do.get_revisione_m;
      /* Verifica allineamento di posi.ruolo_do con posi.ruolo: elimina i valori nulli
        La modifica scatena il trigger POSI_PEDO_TMA che aggiorna PERIODI_DOTAZIONE
      */
      update posizioni set ruolo_do = ruolo where ruolo_do is null;
      /* Predisponi revisione di dotazione su modello indicato su DOOR
         Raggruppa i dati giuridici effettivi sui campi diversi da %
         Come modello prende l'ultima revisione in ordine di REDO.DAL
      */
      d_revisione_modello := nvl(d_revisione_m, 0);
   
      select count(*)
        into d_dummy
        from dotazione_organica
       where revisione = d_revisione_modello;
   
      if d_dummy <> 1 then
         d_revisione_modello := 0;
      end if;
   
      begin
         select data
           into d_data
           from riferimento_dotazione
          where utente = nvl(si4.utente, 'GP4');
      exception
         when no_data_found then
            d_data := sysdate;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and gestione <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            d_par_1 := 'GESTIONE';
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and settore <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'SETTORE';
            else
               d_par_2 := 'SETTORE';
            end if;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and ruolo <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'RUOLO';
            elsif d_par_2 is null then
               d_par_2 := 'RUOLO';
            else
               d_par_3 := 'RUOLO';
            end if;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and profilo <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'PROFILO';
            elsif d_par_2 is null then
               d_par_2 := 'PROFILO';
            elsif d_par_3 is null then
               d_par_3 := 'PROFILO';
            else
               d_par_4 := 'PROFILO';
            end if;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and posizione <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'POSIZIONE';
            elsif d_par_2 is null then
               d_par_2 := 'POSIZIONE';
            elsif d_par_3 is null then
               d_par_3 := 'POSIZIONE';
            elsif d_par_4 is null then
               d_par_4 := 'POSIZIONE';
            else
               d_par_5 := 'POSIZIONE';
            end if;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and attivita <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'ATTIVITA';
            elsif d_par_2 is null then
               d_par_2 := 'ATTIVITA';
            elsif d_par_3 is null then
               d_par_3 := 'ATTIVITA';
            elsif d_par_4 is null then
               d_par_4 := 'ATTIVITA';
            else
               d_par_5 := 'ATTIVITA';
            end if;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and figura <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'FIGURA';
            elsif d_par_2 is null then
               d_par_2 := 'FIGURA';
            elsif d_par_3 is null then
               d_par_3 := 'FIGURA';
            elsif d_par_4 is null then
               d_par_4 := 'FIGURA';
            else
               d_par_5 := 'FIGURA';
            end if;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and qualifica <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'QUALIFICA';
            elsif d_par_2 is null then
               d_par_2 := 'QUALIFICA';
            elsif d_par_3 is null then
               d_par_3 := 'QUALIFICA';
            elsif d_par_4 is null then
               d_par_4 := 'QUALIFICA';
            else
               d_par_5 := 'QUALIFICA';
            end if;
      end;
      begin
         select 'x'
           into d_dummy
           from dotazione_organica
          where revisione = d_revisione_modello
            and livello <> '%';
         raise too_many_rows;
      exception
         when no_data_found then
            null;
         when too_many_rows then
            if d_par_1 is null then
               d_par_1 := 'LIVELLO';
            elsif d_par_2 is null then
               d_par_2 := 'LIVELLO';
            elsif d_par_3 is null then
               d_par_3 := 'LIVELLO';
            elsif d_par_4 is null then
               d_par_4 := 'LIVELLO';
            else
               d_par_5 := 'LIVELLO';
            end if;
      end;
      if d_par_1 is not null then
         begin
            si4.sql_execute('alter table dotazione_organica disable all triggers');
            si4.sql_execute('drop index dotazione_organica_uk');
            si4.sql_execute('drop index dotazione_organica_pk');
            delete from dotazione_organica where revisione = d_revisione_modello;
            select 'insert into dotazione_organica ' ||
                   '(REVISIONE,GESTIONE,AREA,SETTORE,RUOLO,PROFILO,POSIZIONE,ATTIVITA,FIGURA' ||
                   ' ,QUALIFICA,LIVELLO,TIPO_RAPPORTO,ORE,NUMERO,NUMERO_ORE,UTENTE,DATA_AGG,TIPO,DOOR_ID)'
              into d_comando_1
              from dual;
            dbms_output.put_line(d_comando_1);
            select ' select ' || d_revisione_modello ||
                   decode(d_par_1, 'GESTIONE', ',GESTIONE', '''%''') || ',' || '''%''' ||
                   decode(d_par_1
                         ,'SETTORE'
                         ,',nvl(gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore),''GP4'',' || '''' ||
                          d_data || '''' || '),''%'')'
                         ,decode(d_par_2
                                ,'SETTORE'
                                ,',nvl(gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore),''GP4'',' || '''' ||
                                 d_data || '''' || '),''%'')'
                                ,',' || '''%''')) ||
                   decode(d_par_1
                         ,'RUOLO'
                         ,',gp4_qugi.get_ruolo(pegi.qualifica,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'RUOLO'
                                ,',gp4_qugi.get_ruolo(pegi.qualifica,' || '''' || d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'RUOLO'
                                       ,',gp4_qugi.get_ruolo(pegi.qualifica,' || '''' ||
                                        d_data || '''' || ')'
                                       ,',' || '''%'''))) ||
                   decode(d_par_1
                         ,'PROFILO'
                         ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' || d_data || '''' ||
                          '),''%'')'
                         ,decode(d_par_2
                                ,'PROFILO'
                                ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' ||
                                 d_data || '''' || '),''%'')'
                                ,decode(d_par_3
                                       ,'PROFILO'
                                       ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' ||
                                        d_data || '''' || '),''%'')'
                                       ,decode(d_par_4
                                              ,'PROFILO'
                                              ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' ||
                                               d_data || '''' || '),''%'')'
                                              ,',' || '''%''')))) ||
                   decode(d_par_1
                         ,'POSIZIONE'
                         ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' || d_data || '''' ||
                          '),''%'')'
                         ,decode(d_par_2
                                ,'POSIZIONE'
                                ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                 d_data || '''' || '),''%'')'
                                ,decode(d_par_3
                                       ,'POSIZIONE'
                                       ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                        d_data || '''' || '),''%'')'
                                       ,decode(d_par_4
                                              ,'POSIZIONE'
                                              ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                               d_data || '''' || '),''%'')'
                                              ,decode(d_par_5
                                                     ,'POSIZIONE'
                                                     ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                                      d_data || '''' || '),''%'')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'ATTIVITA'
                         ,',nvl(ATTIVITA,''NULL'')'
                         ,decode(d_par_2
                                ,'ATTIVITA'
                                ,',nvl(ATTIVITA,''NULL'')'
                                ,decode(d_par_3
                                       ,'ATTIVITA'
                                       ,',nvl(ATTIVITA,''NULL'')'
                                       ,decode(d_par_4
                                              ,'ATTIVITA'
                                              ,',nvl(ATTIVITA,''NULL'')'
                                              ,decode(d_par_5
                                                     ,'ATTIVITA'
                                                     ,',nvl(ATTIVITA,''NULL'')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'FIGURA'
                         ,',gp4_figi.get_codice(pegi.figura,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'FIGURA'
                                ,',gp4_figi.get_codice(pegi.figura,' || '''' || d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'FIGURA'
                                       ,',gp4_figi.get_codice(pegi.figura,' || '''' ||
                                        d_data || '''' || ')'
                                       ,decode(d_par_4
                                              ,'FIGURA'
                                              ,',gp4_figi.get_codice(pegi.figura,' || '''' ||
                                               d_data || '''' || ')'
                                              ,decode(d_par_5
                                                     ,'FIGURA'
                                                     ,',gp4_figi.get_codice(pegi.figura,' || '''' ||
                                                      d_data || '''' || ')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'QUALIFICA'
                         ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'QUALIFICA'
                                ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' || d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'QUALIFICA'
                                       ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' ||
                                        d_data || '''' || ')'
                                       ,decode(d_par_4
                                              ,'QUALIFICA'
                                              ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' ||
                                               d_data || '''' || ')'
                                              ,decode(d_par_5
                                                     ,'QUALIFICA'
                                                     ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' ||
                                                      d_data || '''' || ')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'LIVELLO'
                         ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'LIVELLO'
                                ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                 d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'LIVELLO'
                                       ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                        d_data || '''' || ')'
                                       ,decode(d_par_4
                                              ,'LIVELLO'
                                              ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                               d_data || '''' || ')'
                                              ,decode(d_par_5
                                                     ,'LIVELLO'
                                                     ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                                      d_data || '''' || ')'
                                                     ,',' || '''%'''))))) || ',' ||
                   '''%''' || ',' || '''''' || ',count(*)' || ',count(*)' || ',' ||
                   '''GP4Start''' || ',sysdate' || ',' || '''''' || ',' || '0'
              into d_comando_2
              from dual;
            dbms_output.put_line(d_comando_2);
            select ' from periodi_giuridici pegi' || ' where rilevanza=''S''' ||
                   '   and ' || '''' || d_data || '''' || ' between dal and nvl(al,' || '''' ||
                   d_data || '''' || ')' || ' group by ' ||
                   decode(d_par_1, 'GESTIONE', 'GESTIONE', '''%''') ||
                   decode(d_par_1
                         ,'SETTORE'
                         ,',nvl(gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore),''GP4'',' || '''' ||
                          d_data || '''' || '),''%'')'
                         ,decode(d_par_2
                                ,'SETTORE'
                                ,',nvl(gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore),''GP4'',' || '''' ||
                                 d_data || '''' || '),''%'')'
                                ,',' || '''%''')) ||
                   decode(d_par_1
                         ,'RUOLO'
                         ,',gp4_qugi.get_ruolo(pegi.qualifica,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'RUOLO'
                                ,',gp4_qugi.get_ruolo(pegi.qualifica,' || '''' || d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'RUOLO'
                                       ,',gp4_qugi.get_ruolo(pegi.qualifica,' || '''' ||
                                        d_data || '''' || ')'
                                       ,',' || '''%'''))) ||
                   decode(d_par_1
                         ,'PROFILO'
                         ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' || d_data || '''' ||
                          '),''%'')'
                         ,decode(d_par_2
                                ,'PROFILO'
                                ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' ||
                                 d_data || '''' || '),''%'')'
                                ,decode(d_par_3
                                       ,'PROFILO'
                                       ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' ||
                                        d_data || '''' || '),''%'')'
                                       ,decode(d_par_4
                                              ,'PROFILO'
                                              ,',nvl(gp4_figi.get_profilo(pegi.figura,' || '''' ||
                                               d_data || '''' || '),''%'')'
                                              ,',' || '''%''')))) ||
                   decode(d_par_1
                         ,'POSIZIONE'
                         ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' || d_data || '''' ||
                          '),''%'')'
                         ,decode(d_par_2
                                ,'POSIZIONE'
                                ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                 d_data || '''' || '),''%'')'
                                ,decode(d_par_3
                                       ,'POSIZIONE'
                                       ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                        d_data || '''' || '),''%'')'
                                       ,decode(d_par_4
                                              ,'POSIZIONE'
                                              ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                               d_data || '''' || '),''%'')'
                                              ,decode(d_par_5
                                                     ,'POSIZIONE'
                                                     ,',nvl(gp4_figi.get_posizione(pegi.figura,' || '''' ||
                                                      d_data || '''' || '),''%'')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'ATTIVITA'
                         ,',nvl(ATTIVITA,''NULL'')'
                         ,decode(d_par_2
                                ,'ATTIVITA'
                                ,',nvl(ATTIVITA,''NULL'')'
                                ,decode(d_par_3
                                       ,'ATTIVITA'
                                       ,',nvl(ATTIVITA,''NULL'')'
                                       ,decode(d_par_4
                                              ,'ATTIVITA'
                                              ,',nvl(ATTIVITA,''NULL'')'
                                              ,decode(d_par_5
                                                     ,'ATTIVITA'
                                                     ,',nvl(ATTIVITA,''NULL'')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'FIGURA'
                         ,',gp4_figi.get_codice(pegi.figura,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'FIGURA'
                                ,',gp4_figi.get_codice(pegi.figura,' || '''' || d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'FIGURA'
                                       ,',gp4_figi.get_codice(pegi.figura,' || '''' ||
                                        d_data || '''' || ')'
                                       ,decode(d_par_4
                                              ,'FIGURA'
                                              ,',gp4_figi.get_codice(pegi.figura,' || '''' ||
                                               d_data || '''' || ')'
                                              ,decode(d_par_5
                                                     ,'FIGURA'
                                                     ,',gp4_figi.get_codice(pegi.figura,' || '''' ||
                                                      d_data || '''' || ')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'QUALIFICA'
                         ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'QUALIFICA'
                                ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' || d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'QUALIFICA'
                                       ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' ||
                                        d_data || '''' || ')'
                                       ,decode(d_par_4
                                              ,'QUALIFICA'
                                              ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' ||
                                               d_data || '''' || ')'
                                              ,decode(d_par_5
                                                     ,'QUALIFICA'
                                                     ,',gp4_qugi.get_codice(pegi.qualifica,' || '''' ||
                                                      d_data || '''' || ')'
                                                     ,',' || '''%'''))))) ||
                   decode(d_par_1
                         ,'LIVELLO'
                         ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' || d_data || '''' || ')'
                         ,decode(d_par_2
                                ,'LIVELLO'
                                ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                 d_data || '''' || ')'
                                ,decode(d_par_3
                                       ,'LIVELLO'
                                       ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                        d_data || '''' || ')'
                                       ,decode(d_par_4
                                              ,'LIVELLO'
                                              ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                               d_data || '''' || ')'
                                              ,decode(d_par_5
                                                     ,'LIVELLO'
                                                     ,',gp4_qugi.get_livello(pegi.qualifica,' || '''' ||
                                                      d_data || '''' || ')'
                                                     ,',' || '''%''')))))
              into d_comando_3
              from dual;
            dbms_output.put_line(d_comando_3);
            si4.sql_execute(d_comando_1 || d_comando_2 || d_comando_3);
            /* Determina il door_id nel caso sia nullo */
            update dotazione_organica
               set door_id = rownum
             where revisione = d_revisione_modello;
            d_comando_1 := 'CREATE UNIQUE INDEX DOTAZIONE_ORGANICA_UK ON DOTAZIONE_ORGANICA' ||
                           '(REVISIONE, GESTIONE, AREA, SETTORE, RUOLO,' ||
                           'PROFILO, POSIZIONE, ATTIVITA, FIGURA, QUALIFICA,' ||
                           'LIVELLO, TIPO_RAPPORTO, ORE)';
            si4.sql_execute(d_comando_1);
            d_comando_1 := 'CREATE UNIQUE INDEX DOTAZIONE_ORGANICA_PK ON DOTAZIONE_ORGANICA (REVISIONE, DOOR_ID)';
            si4.sql_execute(d_comando_1);
            si4.sql_execute('alter table dotazione_organica enable all triggers');
            select max(door_id) + 1 into d_max_id from dotazione_organica;
            si4.sql_execute('drop sequence door_sq');
            d_comando_1 := 'CREATE SEQUENCE DOOR_SQ START WITH ' || d_max_id ||
                           ' MAXVALUE 999999 ' || ' MINVALUE ' || d_max_id ||
                           ' NOCYCLE CACHE 2 NOORDER';
            si4.sql_execute(d_comando_1);
         exception
            when others then
               /* Determina il door_id nel caso sia nullo */
               for door in (select rowid from dotazione_organica where door_id is null)
               loop
                  update dotazione_organica
                     set door_id = door_sq.nextval
                   where rowid = door.rowid;
               end loop;
               begin
                  select 'x'
                    into d_dummy
                    from user_indexes
                   where index_name = 'DOTAZIONE_ORGANICA_UK';
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     null;
                  when no_data_found then
                     d_comando_1 := 'CREATE UNIQUE INDEX DOTAZIONE_ORGANICA_UK ON DOTAZIONE_ORGANICA' ||
                                    '(REVISIONE, GESTIONE, AREA, SETTORE, RUOLO,' ||
                                    'PROFILO, POSIZIONE, ATTIVITA, FIGURA, QUALIFICA,' ||
                                    'LIVELLO, TIPO_RAPPORTO, ORE)';
                     si4.sql_execute(d_comando_1);
               end;
               begin
                  select 'x'
                    into d_dummy
                    from user_indexes
                   where index_name = 'DOTAZIONE_ORGANICA_PK';
                  raise too_many_rows;
               exception
                  when too_many_rows then
                     null;
                  when no_data_found then
                     d_comando_1 := 'CREATE UNIQUE INDEX DOTAZIONE_ORGANICA_PK ON DOTAZIONE_ORGANICA (REVISIONE, DOOR_ID)';
                     si4.sql_execute(d_comando_1);
               end;
               si4.sql_execute('alter table dotazione_organica enable all triggers');
               select nvl(max(door_id), 0) + 1 into d_max_id from dotazione_organica;
               si4.sql_execute('drop sequence door_sq');
               d_comando_1 := 'CREATE SEQUENCE DOOR_SQ START WITH ' || d_max_id ||
                              ' MAXVALUE 999999 ' || ' MINVALUE ' || d_max_id ||
                              ' NOCYCLE CACHE 2 NOORDER';
               si4.sql_execute(d_comando_1);
         end;
      end if;
      if d_revisione_m is null then
         d_revisione_m := nvl(d_revisione_a + 1, 0);
         insert into revisioni_dotazione
            (revisione
            ,descrizione
            ,descrizione_al1
            ,descrizione_al2
            ,note
            ,dal
            ,data
            ,sede_del
            ,numero_del
            ,anno_del
            ,stato
            ,utente
            ,data_agg)
         values
            (d_revisione_m
            ,'Revisione Predefinita ' || d_revisione_m
            ,''
            ,''
            ,'Creata dall''attivazione di GP4DO'
            ,sysdate
            ,sysdate
            ,null
            ,to_number(null)
            ,null
            ,'M'
            ,'AutGP4DO'
            ,sysdate);
      else
         /* modifica l'utente delle revisione in modifica per attivare il trigger PEGI_PEDO_TMA e mantenere l'allineamento */
         update revisioni_dotazione
            set utente = 'AutGP4DO'
          where revisione = d_revisione_m
            and utente = 'Aut.POPI';
      end if;
   end inizializza_tabelle;
   --
   procedure inizializza_periodi_dotazione is
      d_revisione_m number(8);
      d_revisione_a number(8);
      d_dal_m       date;
      d_dal_a       date;
      d_dummy       varchar2(1);
   begin
      -- esegue l'allineamento di PERIODI_DOTAZIONE alle revisioni esistenti
      -- attivando il trigger PEGI_PEDO_TMA
      si4.sql_execute('alter table periodi_giuridici disable all triggers');
      si4.sql_execute('alter trigger pegi_pedo_tma enable');
      si4.sql_execute('truncate table periodi_dotazione');
      lock table periodi_giuridici in exclusive mode nowait;
      lock table periodi_dotazione in exclusive mode nowait;
      update periodi_giuridici set ci = ci where rilevanza in ('Q', 'S', 'I', 'E');
      commit;
      si4.sql_execute('alter table periodi_giuridici enable all triggers');
   end inizializza_periodi_dotazione;
   --
   procedure inizializza_subentri is
      d_revisione_m number(8);
      d_revisione_a number(8);
      d_dal_m       date;
      d_dal_a       date;
      d_dummy       varchar2(1);
   begin
      -- inserisce su SOSTITUZIONI_GIURIDICHE le cessazioni per predisporre i subentri,
      -- attivando il trigger PEGI_SOGI_TMA
      si4.sql_execute('alter table periodi_giuridici disable all triggers');
      si4.sql_execute('alter trigger pegi_sogi_tma enable');
      lock table periodi_giuridici in exclusive mode nowait;
      lock table sostituzioni_giuridiche in exclusive mode nowait;
      update periodi_giuridici
         set al = al
       where rilevanza = 'P'
         and al is not null;
      commit;
      si4.sql_execute('alter table periodi_giuridici enable all triggers');
   end inizializza_subentri;
   --
   procedure inizializza_sostituzioni is
      d_revisione_m      number(8);
      d_revisione_a      number(8);
      d_dal_m            date;
      d_dal_a            date;
      d_ore_sostituibili number;
      d_ore_sostituzione number;
      d_sogi_id          number;
      d_dummy            varchar2(1);
   begin
      -- determina le sostituzioni in base all'assegnazione ai posti di pianta
      for sost in (select distinct pegi_a.ci titolare
                                  ,pegi_a.dal dal_ass
                                  ,pegi_a.al al_ass
                                  ,pegi_t.dal
                                  ,pegi_t.al
                                  ,pegi_s.ci sostituto
                                  ,pegi_s.dal dal_sost
                                  ,pegi_s.al al_sost
                                  ,pegi_s.ore ore_sost
                     from periodi_giuridici pegi_a
                         ,periodi_giuridici pegi_t
                         ,periodi_giuridici pegi_s
                    where pegi_a.rilevanza = 'A'
                      and exists (select 'x'
                             from astensioni
                            where codice = pegi_a.assenza
                              and sostituibile = 1)
                      and pegi_t.ci = pegi_a.ci
                      and pegi_t.rilevanza = 'Q'
                      and pegi_t.posto is not null
                      and pegi_t.dal <= nvl(pegi_a.al, to_date(3333333, 'j'))
                      and nvl(pegi_t.al, to_date(3333333, 'j')) >= pegi_a.dal
                      and pegi_s.ci <> pegi_t.ci
                      and pegi_s.rilevanza = 'Q'
                      and pegi_s.sede_posto = pegi_t.sede_posto
                      and pegi_s.anno_posto = pegi_t.anno_posto
                      and pegi_s.numero_posto = pegi_t.numero_posto
                      and pegi_s.posto = pegi_t.posto
                      and pegi_s.dal >= pegi_a.dal
                      and nvl(pegi_s.al, to_date(3333333, 'j')) <=
                          nvl(pegi_a.al, to_date(3333333, 'j'))
                    order by 1
                            ,2)
      loop
         d_ore_sostituibili := gp4do.get_ore_sostituibili(sost.titolare, sost.dal_ass);
         d_ore_sostituzione := nvl(sost.ore_sost, d_ore_sostituibili);
         select sogi_sq.nextval into d_sogi_id from dual;
         insert into sostituzioni_giuridiche
            (sogi_id
            ,titolare
            ,dal_astensione
            ,rilevanza_astensione
            ,ore_sostituibili
            ,sostituto
            ,dal
            ,al
            ,rilevanza_sostituzione
            ,ore_sostituzione
            ,note)
         values
            (d_sogi_id
            ,sost.titolare
            ,sost.dal_ass
            ,'A'
            ,d_ore_sostituibili
            ,sost.sostituto
            ,sost.dal_sost
            ,sost.al_sost
            ,'Q'
            ,d_ore_sostituzione
            ,'Aut.POPI');
      end loop;
      commit;
   end inizializza_sostituzioni;
   --
   procedure inizializza_gp4do
   (
      p_pedo         in varchar2
     ,p_subentri     in varchar2
     ,p_sostituzioni in varchar2
   ) is
      /******************************************************************************
         NAME:       INIZIALIZZA_GP4DO
         PURPOSE:    Predispone le tabelle per le interrogazioni
      ******************************************************************************/
      d_revisione_m      number(8);
      d_revisione_a      number(8);
      d_dal_m            date;
      d_dal_a            date;
      d_ore_sostituibili number;
      d_ore_sostituzione number;
      d_sogi_id          number;
      situazione_anomala exception;
   begin
      if p_pedo = 'SI' then
         -- esegue l'allineamento di PERIODI_DOTAZIONE alle revisioni esistenti
         -- attivando il trigger PEGI_PEDO_TMA
         si4.sql_execute('alter table periodi_giuridici disable all triggers');
         si4.sql_execute('alter trigger pegi_pedo_tma enable');
         si4.sql_execute('truncate table periodi_dotazione');
         lock table periodi_giuridici in exclusive mode nowait;
         lock table periodi_dotazione in exclusive mode nowait;
         update periodi_giuridici set ci = ci where rilevanza in ('Q', 'S', 'I', 'E');
         commit;
         si4.sql_execute('alter table periodi_giuridici enable all triggers');
      end if;
      if p_subentri = 'SI' then
         -- inserisce su SOSTITUZIONI_GIURIDICHE le cessazioni per predisporre i subentri,
         -- attivando il trigger PEGI_SOGI_TMA
         si4.sql_execute('alter table periodi_giuridici disable all triggers');
         si4.sql_execute('alter trigger pegi_sogi_tma enable');
         lock table periodi_giuridici in exclusive mode nowait;
         lock table sostituzioni_giuridiche in exclusive mode nowait;
         update periodi_giuridici
            set al = al
          where rilevanza = 'P'
            and al is not null;
         commit;
         si4.sql_execute('alter table periodi_giuridici enable all triggers');
      end if;
      if p_sostituzioni = 'SI' then
         -- determina le sostituzioni in base all'assegnazione ai posti di pianta
         for sost in (select distinct pegi_a.ci titolare
                                     ,pegi_a.dal dal_ass
                                     ,pegi_a.al al_ass
                                     ,pegi_t.dal
                                     ,pegi_t.al
                                     ,pegi_s.ci sostituto
                                     ,pegi_s.dal dal_sost
                                     ,pegi_s.al al_sost
                                     ,pegi_s.ore ore_sost
                        from periodi_giuridici pegi_a
                            ,periodi_giuridici pegi_t
                            ,periodi_giuridici pegi_s
                       where pegi_a.rilevanza = 'A'
                         and exists
                       (select 'x'
                                from astensioni
                               where codice = pegi_a.assenza
                                 and sostituibile = 1)
                         and pegi_t.ci = pegi_a.ci
                         and pegi_t.rilevanza = 'Q'
                         and pegi_t.posto is not null
                         and pegi_t.dal <= nvl(pegi_a.al, to_date(3333333, 'j'))
                         and nvl(pegi_t.al, to_date(3333333, 'j')) >= pegi_a.dal
                         and pegi_s.ci <> pegi_t.ci
                         and pegi_s.rilevanza = 'Q'
                         and pegi_s.sede_posto = pegi_t.sede_posto
                         and pegi_s.anno_posto = pegi_t.anno_posto
                         and pegi_s.numero_posto = pegi_t.numero_posto
                         and pegi_s.posto = pegi_t.posto
                         and pegi_s.dal >= pegi_a.dal
                         and nvl(pegi_s.al, to_date(3333333, 'j')) <=
                             nvl(pegi_a.al, to_date(3333333, 'j'))
                       order by 1
                               ,2)
         loop
            d_ore_sostituibili := gp4do.get_ore_sostituibili(sost.titolare, sost.dal_ass);
            d_ore_sostituzione := nvl(sost.ore_sost, d_ore_sostituibili);
            select sogi_sq.nextval into d_sogi_id from dual;
            insert into sostituzioni_giuridiche
               (sogi_id
               ,titolare
               ,dal_astensione
               ,rilevanza_astensione
               ,ore_sostituibili
               ,sostituto
               ,dal
               ,al
               ,rilevanza_sostituzione
               ,ore_sostituzione
               ,note)
            values
               (d_sogi_id
               ,sost.titolare
               ,sost.dal_ass
               ,'A'
               ,d_ore_sostituibili
               ,sost.sostituto
               ,sost.dal_sost
               ,sost.al_sost
               ,'Q'
               ,d_ore_sostituzione
               ,'Aut.POPI');
         end loop;
         commit;
      end if;
   exception
      when situazione_anomala then
         rollback;
   end inizializza_gp4do;
end gp4do_start;
/
