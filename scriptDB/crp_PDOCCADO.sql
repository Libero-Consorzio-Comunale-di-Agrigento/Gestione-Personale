create or replace package pdoccado is
   /******************************************************************************
    NOME:          PDOCCADO
    DESCRIZIONE:
    ARGOMENTI:
    RITORNA:
    ECCEZIONI:
    ANNOTAZIONI:
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ --------------------------------------------------------
    1    27/09/2005
   ******************************************************************************/
   function versione return varchar2;
   procedure main
   (
      prenotazione in number
     ,passo        in number
   );
   function get_sostituto
   (
      p_ci   in number
     ,p_data in date
   ) return number;
   pragma restrict_references(get_sostituto, wnds, wnps);
   function get_titolare
   (
      p_ci   in number
     ,p_data in date
   ) return number;
   pragma restrict_references(get_titolare, wnds, wnps);
   function conta_ore_supplenti
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;
   pragma restrict_references(conta_ore_supplenti, wnds, wnps);
   function conta_ore_mansioni_sup
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;
   pragma restrict_references(conta_ore_mansioni_sup, wnds, wnps);
   function conta_ore_inc_aq
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;
   pragma restrict_references(conta_ore_inc_aq, wnds, wnps);
   function conta_ore_aspettative
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;
   pragma restrict_references(conta_ore_aspettative, wnds, wnps);
   function conta_ore_universitari
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;
   pragma restrict_references(conta_ore_universitari, wnds, wnps);
end;
/
create or replace package body pdoccado is
   form_trigger_failure exception;
   w_utente         varchar2(10);
   w_ambiente       varchar2(10);
   w_ente           varchar2(10);
   w_lingua         varchar2(1);
   w_prenotazione   number(10);
   w_voce_menu      varchar2(8);
   errore           varchar2(6);
   p_d_f            varchar2(1);
   p_data           date;
   p_nominativa     varchar2(1);
   d_revisione_rest revisioni_struttura.revisione%type;
   p_revisione      revisioni_dotazione.revisione%type;
   p_gestione       dotazione_organica.gestione%type;
   p_uso_interno    varchar2(1);
   p_lingue         varchar2(3);

   function versione return varchar2 is
   begin
      return 'V1.1 del 16/11/2003';
   end versione;

   --
   procedure del_dett_posti is
   begin
      delete from calcolo_dotazione where cado_prenotazione = w_prenotazione;
   end;

   -- PULIZIA TABELLA DI LAVORO
   procedure delete_tab is
   begin
      delete from calcolo_dotazione where cado_prenotazione = w_prenotazione;
   
      delete from calcolo_nominativo_dotazione where cndo_prenotazione = w_prenotazione;
   end;

   ----------------------------------------------------------------------------
   function get_sostituto
   (
      p_ci   in number
     ,p_data in date
   ) return number is
      d_sostituto number;
      non_calcolabile exception;
   begin
      begin
         d_sostituto := 0;
      
         begin
            select sostituto
              into d_sostituto
              from sostituzioni_giuridiche sogi
             where p_data between sogi.dal and nvl(sogi.al, to_date(3333333, 'j'))
               and rilevanza_astensione || '' = 'A'
               and titolare = p_ci
               and (dal, sogi_id) =
                   (select max(dal)
                          ,max(sogi_id)
                      from sostituzioni_giuridiche
                     where titolare = p_ci
                       and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       and rilevanza_astensione = 'A');
         exception
            when no_data_found then
               begin
                  d_sostituto := 0;
               end;
            when too_many_rows then
               begin
                  d_sostituto := 0;
               end;
         end;
      
         return d_sostituto;
      exception
         when non_calcolabile then
            d_sostituto := 0;
            return d_sostituto;
      end;
   end get_sostituto;

   --
   ----------------------------------------------------------------------------
   function get_titolare
   (
      p_ci   in number
     ,p_data in date
   ) return number is
      d_titolare number;
      non_calcolabile exception;
   begin
      begin
         d_titolare := 0;
      
         begin
            select titolare
              into d_titolare
              from sostituzioni_giuridiche sogi
             where p_data between sogi.dal and nvl(sogi.al, to_date(3333333, 'j'))
               and rilevanza_astensione = 'A'
               and sostituto = p_ci
               and (dal, sogi_id) =
                   (select max(dal)
                          ,max(sogi_id)
                      from sostituzioni_giuridiche
                     where sostituto = p_ci
                       and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       and rilevanza_astensione = 'A');
         exception
            when no_data_found then
               begin
                  d_titolare := 0;
               end;
            when too_many_rows then
               begin
                  d_titolare := 0;
               end;
         end;
      
         return d_titolare;
      exception
         when non_calcolabile then
            d_titolare := 0;
            return d_titolare;
      end;
   end get_titolare;

   --
   ----------------------------------------------------------------------------
   function conta_ore_supplenti
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number is
      d_totale number;
      d_ore_do gestioni.ore_do%type;
      non_calcolabile exception;
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            --            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
            select sum(pedo.ue)
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and di_ruolo = 'NO'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and gp4gm.get_se_assente(pedo.ci, p_data) = 0
               and gp4gm.get_se_incaricato(pedo.ci, p_data) = 0
               and exists
             (select 'x'
                      from sostituzioni_giuridiche
                     where sostituto = pedo.ci
                       and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       and gp4gm.get_se_di_ruolo(titolare, p_data) = 1);
         exception
            when no_data_found then
               begin
                  d_totale := 0;
               end;
            when too_many_rows then
               begin
                  d_totale := 0;
               end;
         end;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_supplenti;

   --
   ----------------------------------------------------------------------------
   function conta_ore_mansioni_sup
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select sum(pedo.ue)
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and di_ruolo = 'SI'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and exists
             (select 'x'
                      from periodi_giuridici pegi
                     where ci = pedo.ci
                       and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       and rilevanza = 'I'
                       and exists (select 'x'
                              from posizioni
                             where codice = pegi.posizione
                               and ruolo = 'SI'
                               and di_ruolo = 'F'));
         exception
            when no_data_found then
               begin
                  d_totale := 0;
               end;
            when too_many_rows then
               begin
                  d_totale := 0;
               end;
         end;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_mansioni_sup;

   --
   ----------------------------------------------------------------------------
   function conta_ore_inc_aq
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select sum(pedo.ue)
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and di_ruolo = 'SI'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and exists
             (select 'x'
                      from periodi_giuridici pegi
                     where ci = pedo.ci
                       and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       and rilevanza = 'I'
                       and exists (select 'x'
                              from posizioni
                             where codice = pegi.posizione
                                  --     and ruolo = 'NO'
                               and di_ruolo = 'F'));
         exception
            when no_data_found then
               begin
                  d_totale := 0;
               end;
            when too_many_rows then
               begin
                  d_totale := 0;
               end;
         end;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_inc_aq;

   --
   ----------------------------------------------------------------------------
   function conta_ore_aspettative
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select sum(pedo.ue)
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and di_ruolo = 'SI'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and exists
             (select 'x'
                      from periodi_giuridici pegi
                     where ci = pedo.ci
                       and p_data between dal and nvl(al, to_date(3333333, 'j'))
                       and rilevanza = 'A'
                       and exists (select 'x'
                              from astensioni
                             where codice = pegi.assenza
                               and per_ret = 0
                               and sostituibile = 1));
         exception
            when no_data_found then
               begin
                  d_totale := 0;
               end;
            when too_many_rows then
               begin
                  d_totale := 0;
               end;
         end;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_aspettative;

   --
   ----------------------------------------------------------------------------
   function conta_ore_universitari
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select sum(pedo.ue)
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and di_ruolo = 'NO'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and ruolo = 'UNIV';
         exception
            when no_data_found then
               begin
                  d_totale := 0;
               end;
            when too_many_rows then
               begin
                  d_totale := 0;
               end;
         end;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_universitari;

   --
   procedure calcolo_eta_anzianita
   (
      p_ci     in number
     ,p_mm_eta in out number
     ,p_aa_eta in out number
     ,p_gg_anz in out number
     ,p_mm_anz in out number
     ,p_aa_anz in out number
   ) is
      d_cndo_mm_eta number(4);
      d_cndo_aa_eta number(4);
      d_gg_anz      number(4);
      d_mm_anz      number(4);
      d_aa_anz      number(4);
      d_cndo_gg_anz number(4);
      d_cndo_mm_anz number(4);
      d_cndo_aa_anz number(4);
      d_ci          number(8);
      d_conta       number(6);
   begin
      d_ci := p_ci;
   
      select sum((trunc((trunc(months_between(last_day(nvl(pegi.al, rior.data) + 1)
                                             ,last_day(pegi.dal))) * 30 -
                        least(30, to_number(to_char(pegi.dal, 'dd'))) + 1 +
                        least(30
                              ,to_number(to_char(nvl(pegi.al, rior.data) + 1, 'dd')) - 1)) / 360)) *
                 to_number(decode(pegi.rilevanza, 'Q', 1, -1))) --  Anni di Anzianita`
            ,sum((trunc((trunc(months_between(last_day(nvl(pegi.al, rior.data) + 1)
                                             ,last_day(pegi.dal))) * 30 -
                        least(30, to_number(to_char(pegi.dal, 'dd'))) + 1 +
                        least(30
                              ,to_number(to_char(nvl(pegi.al, rior.data) + 1, 'dd')) - 1) -
                        trunc((trunc(months_between(last_day(nvl(pegi.al, rior.data) + 1)
                                                    ,last_day(pegi.dal))) * 30 -
                               least(30, to_number(to_char(pegi.dal, 'dd'))) + 1 +
                               least(30
                                     ,to_number(to_char(nvl(pegi.al, rior.data) + 1
                                                       ,'dd')) - 1)) / 360) * 360) / 30)) *
                 to_number(decode(pegi.rilevanza, 'Q', 1, -1))) -- Mesi di Anzianita`
            ,sum((trunc(months_between(last_day(nvl(pegi.al, rior.data) + 1)
                                      ,last_day(pegi.dal))) * 30 -
                 least(30, to_number(to_char(pegi.dal, 'dd'))) + 1 +
                 least(30, to_number(to_char(nvl(pegi.al, rior.data) + 1, 'dd')) - 1) -
                 (trunc((trunc(months_between(last_day(nvl(pegi.al, rior.data) + 1)
                                              ,last_day(pegi.dal))) * 30 -
                         least(30, to_number(to_char(pegi.dal, 'dd'))) + 1 +
                         least(30
                               ,to_number(to_char(nvl(pegi.al, rior.data) + 1, 'dd')) - 1)) / 360) * 360) -
                 trunc((trunc(months_between(last_day(nvl(pegi.al, rior.data) + 1)
                                             ,last_day(pegi.dal))) * 30 -
                        least(30, to_number(to_char(pegi.dal, 'dd'))) + 1 +
                        least(30
                              ,to_number(to_char(nvl(pegi.al, rior.data) + 1, 'dd')) - 1) -
                        trunc((trunc(months_between(last_day(nvl(pegi.al, rior.data) + 1)
                                                    ,last_day(pegi.dal))) * 30 -
                               least(30, to_number(to_char(pegi.dal, 'dd'))) + 1 +
                               least(30
                                     ,to_number(to_char(nvl(pegi.al, rior.data) + 1
                                                       ,'dd')) - 1)) / 360) * 360) / 30) * 30) *
                 to_number(decode(pegi.rilevanza, 'Q', 1, -1))) -- Giorni di Anzianita`
            ,max(trunc(months_between(rior.data, anag.data_nas) / 12))
             -- Anni di Eta`
            ,max(trunc(months_between(rior.data, anag.data_nas)) -
                 trunc(months_between(rior.data, anag.data_nas) / 12) * 12) -- Mesi di Eta`
            ,count(*)
        into d_aa_anz
            ,d_mm_anz
            ,d_gg_anz
            ,d_cndo_aa_eta
            ,d_cndo_mm_eta
            ,d_conta
        from rapporti_individuali rain
            ,anagrafici           anag
            ,periodi_giuridici    pegi
            ,riferimento_organico rior
       where rain.ci = pegi.ci
         and anag.ni = rain.ni
         and rior.data between anag.dal and nvl(anag.al, to_date('3333333', 'j'))
         and (pegi.rilevanza = 'Q' or pegi.rilevanza = 'A' and exists
              (select 'x'
                 from astensioni aste
                where aste.codice = pegi.assenza
                  and aste.servizio = 0))
         and pegi.dal <= rior.data
         and pegi.ci = d_ci;
   
      d_cndo_gg_anz := mod((d_gg_anz + d_mm_anz * 30 + d_aa_anz * 360), 30);
      d_cndo_mm_anz := trunc(mod((d_gg_anz + d_mm_anz * 30 + d_aa_anz * 360), 360) / 30);
      d_cndo_aa_anz := trunc((d_gg_anz + d_mm_anz * 30 + d_aa_anz * 360) / 360);
   
      if d_conta = 0 then
         -- No data found
         d_cndo_mm_eta := 0;
         d_cndo_aa_eta := 0;
         d_cndo_gg_anz := 0;
         d_cndo_mm_anz := 0;
         d_cndo_aa_anz := 0;
      end if;
   
      p_mm_eta := d_cndo_mm_eta;
      p_aa_eta := d_cndo_aa_eta;
      p_gg_anz := d_cndo_gg_anz;
      p_mm_anz := d_cndo_mm_anz;
      p_aa_anz := d_cndo_aa_anz;
   end;

   -- DETERMINA LA SEQUENZA DEI GRUPPI LINGUISTICI
   procedure seq_lingua is
      d_lingua_1 varchar2(1);
      d_lingua_2 varchar2(1);
      d_lingua_3 varchar2(1);
      d_lingua   varchar2(1);
      d_conta    number(2);
   
      cursor gruppi_ling is
         select gruppo_al
           from gruppi_linguistici
          where gruppo = w_lingua
            and rownum < 4
          order by sequenza
                  ,gruppo_al;
   begin
      if w_lingua != '*' then
         open gruppi_ling;
      
         d_conta    := 1;
         d_lingua_1 := '?';
         d_lingua_2 := '?';
         d_lingua_3 := '?';
      
         loop
            fetch gruppi_ling
               into d_lingua;
         
            exit when gruppi_ling%notfound;
         
            if d_conta = 1 then
               d_lingua_1 := d_lingua;
            elsif d_conta = 2 then
               d_lingua_2 := d_lingua;
            else
               d_lingua_3 := d_lingua;
            end if;
         
            if d_conta = 3 then
               exit;
            end if;
         
            d_conta := d_conta + 1;
         end loop;
      
         close gruppi_ling;
      else
         d_lingua_1 := 'I';
         d_lingua_2 := '?';
         d_lingua_3 := '?';
      end if;
   
      p_lingue := d_lingua_1 || d_lingua_2 || d_lingua_3;
   end;

   /* GENERAZIONE DELLA TABELLA DI APPOGGIO PER SITUAZIONE POSTI */
   procedure cc_posti is
      d_errtext                      varchar2(240);
      d_prenotazione                 number(6);
      d_rior_data                    date;
      d_popi_sede_posto              varchar2(4);
      d_popi_anno_posto              number(4);
      d_popi_numero_posto            number(7);
      d_popi_posto                   number(5);
      d_popi_dal                     date;
      d_popi_stato                   varchar2(1);
      d_popi_situazione              varchar2(1);
      d_popi_ricopribile             varchar2(1);
      d_popi_gruppo                  varchar2(12);
      d_popi_pianta                  number(6);
      d_setp_sequenza                number(6);
      d_setp_codice                  varchar2(15);
      d_popi_settore                 number(6);
      d_sett_sequenza                number(6);
      d_sett_codice                  varchar2(15);
      d_codice_uo                    varchar2(15);
      d_sett_suddivisione            number(1);
      d_sett_settore_g               number(6);
      d_setg_sequenza                number(6);
      d_setg_codice                  varchar2(15);
      d_sett_settore_a               number(6);
      d_seta_sequenza                number(6);
      d_seta_codice                  varchar2(15);
      d_sett_settore_b               number(6);
      d_setb_sequenza                number(6);
      d_setb_codice                  varchar2(15);
      d_sett_settore_c               number(6);
      d_setc_sequenza                number(6);
      d_setc_codice                  varchar2(15);
      d_sett_gestione                varchar2(4);
      d_gest_prospetto_po            varchar2(1);
      d_gest_sintetico_po            varchar2(1);
      d_popi_figura                  number(6);
      d_figi_dal                     date;
      d_figu_sequenza                number(6);
      d_figi_codice                  varchar2(8);
      d_figi_numero                  figure_giuridiche.numero%type;
      d_figi_qualifica               number(6);
      d_qugi_dal                     date;
      d_qual_sequenza                number(6);
      d_qugi_codice                  varchar2(8);
      d_qugi_contratto               varchar2(4);
      d_qugi_numero                  qualifiche_giuridiche.numero%type;
      d_cost_dal                     date;
      d_cont_sequenza                number(3);
      d_cost_ore_lavoro              number(10, 2);
      d_qugi_livello                 varchar2(4);
      d_figi_profilo                 varchar2(4);
      d_prpr_sequenza                number(3);
      d_prpr_suddivisione_po         varchar2(1);
      d_figi_posizione               varchar2(4);
      d_pofu_sequenza                number(3);
      d_qugi_ruolo                   varchar2(4);
      d_ruol_sequenza                number(4);
      d_popi_attivita                varchar2(4);
      d_atti_sequenza                number(6);
      d_popi_ore                     number(10, 2);
      d_pegi_posizione               varchar2(4);
      d_posi_sequenza                number(3);
      d_posi_di_ruolo                number(1);
      d_pegi_tipo_rapporto           varchar2(4);
      d_pegi_ore                     number(10, 2);
      d_cado_previsti                number(5);
      d_cado_ore_previsti            number(10, 2);
      d_cado_in_pianta               number(5);
      d_cado_in_deroga               number(5);
      d_cado_in_sovrannumero         number(5);
      d_cado_in_rilascio             number(5);
      d_cado_in_istituzione          number(5);
      d_cado_in_acquisizione         number(5);
      d_cado_ass_ruolo_l1            number(5);
      d_cado_ore_ass_ruolo_l1        number(10, 2);
      d_cado_ass_ruolo_l2            number(5);
      d_cado_ore_ass_ruolo_l2        number(10, 2);
      d_cado_ass_ruolo_l3            number(5);
      d_cado_ore_ass_ruolo_l3        number(10, 2);
      d_cado_ass_ruolo               number(5);
      d_cado_ore_ass_ruolo           number(10, 2);
      d_cado_assegnazioni            number(5);
      d_cado_ore_assegnazioni        number(10, 2);
      d_cado_assenze_incarico        number(5);
      d_cado_assenze_assenza         number(5);
      d_cado_assenze_non_retr        number(5);
      d_cado_disponibili             number(5);
      d_cado_ore_disponibili         number(10, 2);
      d_cado_coperti_ruolo_1         number(5);
      d_cado_ore_coperti_ruolo_1     number(10, 2);
      d_cado_coperti_ruolo_2         number(5);
      d_cado_ore_coperti_ruolo_2     number(10, 2);
      d_cado_coperti_ruolo_3         number(5);
      d_cado_ore_coperti_ruolo_3     number(10, 2);
      d_cado_coperti_ruolo           number(5);
      d_cado_ore_coperti_ruolo       number(10, 2);
      d_cado_coperti_no_ruolo        number(5);
      d_cado_ore_coperti_no_ruolo    number(10, 2);
      d_cado_vacanti                 number(5);
      d_cado_ore_vacanti             number(10, 2);
      d_cado_vacanti_coperti         number(5);
      d_cado_ore_vacanti_coperti     number(10, 2);
      d_cado_vacanti_non_coperti     number(5);
      d_cado_ore_vacanti_non_coperti number(10, 2);
      d_cado_vacanti_non_ricopribili number(5);
      d_cado_sost_titolari           number(5);
      d_cado_ore_sost_titolari       number(10, 2);
      d_cado_sostituibili            number(5);
      d_cado_ore_sostituibili        number(10, 2);
      d_cado_supplenti               number(5);
      d_cado_universitari            number(5);
      d_cado_ore_supplenti           number(10, 2);
      d_cado_ore_inc_aq              number(10, 2);
      d_cado_incaricati              number(5);
      d_cado_mansioni_sup            number(5);
      d_cado_ore_mansioni_sup        number(10, 2);
      d_cado_ore_mansioni_sup_i      number(10, 2);
      d_cado_inc_aq                  number(5);
      d_cado_ore_incaricati          number(10, 2);
      d_cado_tp                      number(5);
      d_cado_td                      number(5);
      d_cado_straordinari            number(5);
      d_cado_straordinari_i          number(5);
      d_contrattisti                 number(5);
      d_cado_ore_straordinari        number(10, 2);
      d_ore_contrattisti             number(10, 2);
      nore                           number(10, 2);
      nore_1                         number(10, 2);
      nore_2                         number(10, 2);
      nore_3                         number(10, 2);
      --
      -- Non previsti
      d_cado_np_previsti             number;
      d_cado_np_ore_previsti         number;
      d_cado_np_ass_ruolo            number;
      d_cado_np_ore_ass_ruolo        number;
      d_cado_np_assegnazioni         number;
      d_cado_np_ore_assegnazioni     number;
      d_cado_np_assenze_incarico     number;
      d_cado_np_assenze_assenza      number;
      d_cado_np_disponibili          number;
      d_cado_np_ore_disponibili      number;
      d_cado_np_coperti_ruolo        number;
      d_cado_np_ore_coperti_ruolo    number;
      d_cado_np_coperti_no_ruolo     number;
      d_cado_np_ore_coperti_no_ruolo number;
      d_cado_np_vacanti              number;
      d_cado_np_ore_vacanti          number;
      d_cado_np_straordinari         number;
      d_cado_np_ore_straordinari     number;
      d_cado_np_ore_supplenti        number;
      d_cado_np_incaricati           number;
      d_cado_np_ore_incaricati       number;
      d_cado_np_ore_mansioni_sup     number;
      d_cado_np_mansioni_sup         number;
      d_cado_np_ore_inc_aq           number;
      d_cado_np_inc_aq               number;
      d_cado_np_assenze_non_retr     number;
      d_cado_np_universitari         number;
      d_sett_sede                    number(6);
      d_sedi_codice                  varchar2(8);
      d_sedi_sequenza                number(6);
      d_anag_gruppo_ling             varchar2(4);
      d_cndo_mm_eta                  number(2);
      d_cndo_aa_eta                  number(2);
      d_cndo_gg_anz                  number(2);
      d_cndo_mm_anz                  number(2);
      d_cndo_aa_anz                  number(2);
      d_popi_sede_posto_inc          varchar2(4);
      d_popi_anno_posto_inc          number(4);
      d_popi_numero_posto_inc        number(7);
      d_popi_posto_inc               number(5);
      d_pegi_tp                      number(5);
      d_pegi_td                      number(5);
      d_cndo_ruolo                   number(5);
      d_cndo_incaricato              number(5);
      d_cndo_mans_sup                number(5);
      d_cndo_inc_td                  number(5);
      d_cndo_supplente               number(5);
      d_cndo_inc_aq                  number(5);
      d_cndo_assente                 number(5);
      d_cndo_aspettativa             number(5);
      d_cndo_univ                    number(5);
      d_cndo_vac_tit                 number(5);
      d_cndo_vac_disp                number(5);
      d_cndo_sovr                    number(5);
      d_cndo_disp_supp               number(5);
      d_ore                          number(10, 2);
      d_ore_do                       varchar2(1);
   begin
      begin
         d_rior_data := p_data;
      end;
   
      dbms_output.put_line('  revisione : ' || p_revisione);
      d_revisione_rest := gp4gm.get_revisione(p_data);
   
      for posti in (select gestione
                          ,settore
                          ,ruolo
                          ,profilo
                          ,posizione
                          ,attivita
                          ,figura
                          ,qualifica
                          ,livello
                          ,tipo_rapporto
                          ,ore
                          ,numero
                          ,numero_ore
                          ,nvl(numero, numero_ore) previsti
                          ,door_id
                      from dotazione_organica
                     where revisione = p_revisione
                    /*and door_id in (84714 \*, 85486*\
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               )*/
                    )
      loop
         -- Azzero un po' di tutto....
         d_cado_ass_ruolo_l1            := 0;
         d_cado_ore_ass_ruolo_l1        := 0;
         d_cado_ass_ruolo_l2            := 0;
         d_cado_ore_ass_ruolo_l2        := 0;
         d_cado_ass_ruolo_l3            := 0;
         d_cado_ore_ass_ruolo_l3        := 0;
         d_cado_ass_ruolo               := 0;
         d_cado_ore_ass_ruolo           := 0;
         d_cado_disponibili             := 0;
         d_cado_ore_disponibili         := 0;
         d_cado_coperti_ruolo_1         := 0;
         d_cado_ore_coperti_ruolo_1     := 0;
         d_cado_coperti_ruolo_2         := 0;
         d_cado_ore_coperti_ruolo_2     := 0;
         d_cado_coperti_ruolo_3         := 0;
         d_cado_ore_coperti_ruolo_3     := 0;
         d_cado_coperti_ruolo           := 0;
         d_cado_ore_coperti_ruolo       := 0;
         d_cado_coperti_no_ruolo        := 0;
         d_cado_ore_coperti_no_ruolo    := 0;
         d_cado_vacanti                 := 0;
         d_cado_ore_vacanti             := 0;
         d_cado_vacanti_coperti         := 0;
         d_cado_ore_vacanti_coperti     := 0;
         d_cado_vacanti_non_coperti     := 0;
         d_cado_ore_vacanti_non_coperti := 0;
         d_cado_vacanti_non_ricopribili := 0;
         d_cado_sost_titolari           := 0;
         d_cado_ore_sost_titolari       := 0;
         d_cado_sostituibili            := 0;
         d_cado_ore_sostituibili        := 0;
         d_cado_supplenti               := 0;
         d_cado_universitari            := 0;
         d_cado_ore_supplenti           := 0;
         d_cado_incaricati              := 0;
         d_cado_ore_incaricati          := 0;
         d_cado_mansioni_sup            := 0;
         d_cado_inc_aq                  := 0;
         d_cado_assenze_assenza         := 0;
         d_cado_assenze_non_retr        := 0;
         d_cado_tp                      := 0;
         d_cado_td                      := 0;
         d_popi_posto                   := 0;
         -- non previsti
         d_cado_np_previsti             := 0;
         d_cado_np_ore_previsti         := 0;
         d_cado_np_ass_ruolo            := 0;
         d_cado_np_ore_ass_ruolo        := 0;
         d_cado_np_assegnazioni         := 0;
         d_cado_np_ore_assegnazioni     := 0;
         d_cado_np_assenze_incarico     := 0;
         d_cado_np_assenze_assenza      := 0;
         d_cado_np_disponibili          := 0;
         d_cado_np_ore_disponibili      := 0;
         d_cado_np_coperti_ruolo        := 0;
         d_cado_np_ore_coperti_ruolo    := 0;
         d_cado_np_coperti_no_ruolo     := 0;
         d_cado_np_ore_coperti_no_ruolo := 0;
         d_cado_np_vacanti              := 0;
         d_cado_np_ore_vacanti          := 0;
         d_cado_np_straordinari         := 0;
         d_cado_np_ore_straordinari     := 0;
         d_cado_np_ore_supplenti        := 0;
         d_cado_np_incaricati           := 0;
         d_cado_np_ore_incaricati       := 0;
         d_cado_np_mansioni_sup         := 0;
         d_cado_np_ore_mansioni_sup     := 0;
         d_cado_np_ore_inc_aq           := 0;
         d_cado_np_inc_aq               := 0;
         d_cado_np_assenze_non_retr     := 0;
         d_cado_np_universitari         := 0;
      
         begin
            d_popi_posto    := posti.door_id;
            d_setp_codice   := posti.settore;
            d_sett_codice   := posti.settore;
            d_sett_gestione := posti.gestione;
            d_popi_settore  := gp4_stam.get_numero(gp4_unor.get_ni(d_sett_codice
                                                                  ,'GP4'
                                                                  ,p_data));
            d_figi_codice   := posti.figura;
            d_figi_numero   := gp4_figi.get_numero(posti.figura, p_data);
         
            if d_figi_numero is null then
               begin
                  select min(numero)
                    into d_figi_numero
                    from figure_giuridiche
                   where profilo = posti.profilo
                     and posizione = posti.posizione
                     and p_data between dal and nvl(al, to_date(3333333, 'j'))
                     and gp4_qugi.get_ruolo(qualifica, p_data) = posti.ruolo;
               exception
                  when no_data_found then
                     null;
               end;
            end if;
         
            begin
               select sequenza
                 into d_figu_sequenza
                 from figure
                where numero = d_figi_numero;
            exception
               when no_data_found then
                  d_figu_sequenza := to_number(null);
            end;
         
            if nvl(posti.qualifica, '%') = '%' then
               d_qugi_numero := gp4_figi.get_qualifica(d_figi_numero, p_data);
               d_qugi_codice := gp4_qugi.get_codice(d_qugi_numero, p_data);
            else
               d_qugi_codice := posti.qualifica;
               d_qugi_numero := gp4_qugi.get_numero(posti.qualifica, p_data);
            end if;
         
            begin
               select decode(posti.ruolo
                            ,'%'
                            ,gp4_qugi.get_ruolo(d_qugi_numero, p_data)
                            ,posti.ruolo)
                 into d_qugi_ruolo
                 from dual;
            
               select sequenza
                 into d_qual_sequenza
                 from qualifiche
                where numero = d_qugi_numero;
            exception
               when no_data_found then
                  d_qual_sequenza := to_number(null);
            end;
         
            d_qugi_contratto  := gp4_qugi.get_contratto(d_qugi_numero, p_data);
            d_cost_ore_lavoro := gp4_cost.get_ore_lavoro(d_qugi_numero, p_data);
            d_qugi_livello    := gp4_qugi.get_livello(d_qugi_numero, p_data);
         
            begin
               select sequenza
                 into d_ruol_sequenza
                 from ruoli
                where codice = d_qugi_ruolo;
            exception
               when no_data_found then
                  d_prpr_sequenza := to_number(null);
            end;
         
            if posti.profilo = '%' then
               d_figi_profilo := gp4_figi.get_profilo(d_figi_numero, p_data);
            else
               d_figi_profilo := posti.profilo;
            end if;
         
            begin
               select sequenza
                 into d_prpr_sequenza
                 from profili_professionali
                where codice = d_figi_profilo;
            exception
               when no_data_found or too_many_rows then
                  d_prpr_sequenza := to_number(null);
            end;
         
            if posti.posizione = '%' then
               d_figi_posizione := gp4_figi.get_posizione(d_figi_numero, p_data);
            else
               d_figi_posizione := posti.posizione;
            end if;
         
            begin
               select sequenza
                 into d_pofu_sequenza
                 from posizioni_funzionali
                where codice = d_figi_posizione;
            exception
               when no_data_found or too_many_rows then
                  d_pofu_sequenza := to_number(null);
            end;
         
            d_popi_attivita := posti.attivita;
         
            begin
               select sequenza
                 into d_atti_sequenza
                 from attivita
                where codice = d_popi_attivita;
            exception
               when no_data_found then
                  d_pofu_sequenza := to_number(null);
            end;
         
            d_pegi_tipo_rapporto := posti.tipo_rapporto;
            d_pegi_ore           := posti.ore;
            ------------------------------------------------------------------------
            -- Contatori
            ------------------------------------------------------------------------
            d_ore_do            := gp4_gest.get_ore_do(p_gestione);
            d_cado_previsti     := posti.numero;
            d_cado_ore_previsti := posti.numero_ore;
         
            d_cado_ass_ruolo := gp4do.conta_dot_ruolo(p_revisione
                                                     ,'Q'
                                                     ,p_data
                                                     ,p_gestione
                                                     ,posti.door_id);
         
            /*            dbms_output.put_line(posti.door_id || '  Sett.' || posti.settore || ' prof.' ||
                                             posti.profilo || ' pos.' || posti.posizione || ' att.' ||
                                             posti.attivita || ' prev.' || d_cado_previsti ||
                                             ' ruolo.' || d_cado_ass_ruolo);
            */
            d_cado_ore_ass_ruolo := gp4do.conta_dot_ruolo_ore(p_revisione
                                                             ,'Q'
                                                             ,p_data
                                                             ,p_gestione
                                                             ,posti.door_id
                                                             ,d_cost_ore_lavoro);
         
            d_cado_assegnazioni := gp4do.conta_dotazione(p_revisione
                                                        ,'Q'
                                                        ,p_data
                                                        ,p_gestione
                                                        ,posti.door_id);
         
            d_cado_ore_assegnazioni := gp4do.conta_dot_ore(p_revisione
                                                          ,'Q'
                                                          ,p_data
                                                          ,p_gestione
                                                          ,posti.door_id
                                                          ,d_cost_ore_lavoro);
         
            d_cado_assenze_incarico := gp4do.conta_dot_incaricati(p_revisione
                                                                 ,'Q'
                                                                 ,p_data
                                                                 ,p_gestione
                                                                 ,posti.door_id);
         
            d_cado_assenze_assenza := gp4do.conta_dot_assenti(p_revisione
                                                             ,'Q'
                                                             ,p_data
                                                             ,p_gestione
                                                             ,posti.door_id);
         
            d_cado_disponibili          := 0; --------------------
            d_cado_ore_disponibili      := 0; --------------------
            d_cado_coperti_ruolo        := d_cado_ass_ruolo;
            d_cado_ore_coperti_ruolo    := d_cado_ore_ass_ruolo;
            d_cado_np_coperti_ruolo     := d_cado_np_ass_ruolo;
            d_cado_np_ore_coperti_ruolo := d_cado_np_ore_ass_ruolo;
         
            d_cado_coperti_no_ruolo := gp4do.conta_dot_non_ruolo(p_revisione
                                                                ,'Q'
                                                                ,p_data
                                                                ,p_gestione
                                                                ,posti.door_id);
         
            d_cado_ore_coperti_no_ruolo := gp4do.conta_ore_non_ruolo(p_revisione
                                                                    ,'Q'
                                                                    ,p_data
                                                                    ,p_gestione
                                                                    ,posti.door_id
                                                                    ,d_cost_ore_lavoro);
         
            d_cado_vacanti := nvl(d_cado_previsti, 0) - nvl(d_cado_coperti_ruolo, 0);
         
            d_cado_np_vacanti := 0;
         
            d_cado_ore_vacanti := nvl(d_cado_ore_previsti, 0) -
                                  nvl(d_cado_ore_coperti_ruolo, 0);
         
            d_cado_np_ore_vacanti := 0;
         
            d_contrattisti := gp4do.conta_dot_contrattisti(p_revisione
                                                          ,'Q'
                                                          ,p_data
                                                          ,p_gestione
                                                          ,posti.door_id);
         
            d_cado_straordinari := gp4do.conta_dot_sovrannumero(p_revisione
                                                               ,'Q'
                                                               ,p_data
                                                               ,p_gestione
                                                               ,posti.door_id);
         
            d_cado_straordinari_i := gp4do.conta_dot_sovrannumero(p_revisione
                                                                 ,'I'
                                                                 ,p_data
                                                                 ,p_gestione
                                                                 ,posti.door_id);
         
            d_ore_contrattisti := gp4do.conta_ore_contrattisti(p_revisione
                                                              ,'Q'
                                                              ,p_data
                                                              ,p_gestione
                                                              ,posti.door_id
                                                              ,d_cost_ore_lavoro);
         
            d_cado_ore_straordinari := gp4do.conta_ore_sovrannumero(p_revisione
                                                                   ,'Q'
                                                                   ,p_data
                                                                   ,p_gestione
                                                                   ,posti.door_id
                                                                   ,d_cost_ore_lavoro);
         
            d_cado_ore_supplenti := conta_ore_supplenti(p_revisione
                                                       ,'Q'
                                                       ,p_data
                                                       ,p_gestione
                                                       ,posti.door_id
                                                       ,d_cost_ore_lavoro);
         
            d_cado_universitari := conta_ore_universitari(p_revisione
                                                         ,'Q'
                                                         ,p_data
                                                         ,p_gestione
                                                         ,posti.door_id
                                                         ,d_cost_ore_lavoro);
         
            d_cado_incaricati := gp4do.conta_dot_non_ruolo(p_revisione
                                                          ,'Q'
                                                          ,p_data
                                                          ,p_gestione
                                                          ,posti.door_id) -
                                 d_cado_straordinari - d_cado_universitari -
                                 d_contrattisti - d_cado_ore_supplenti;
         
            d_cado_straordinari := d_cado_straordinari + nvl(d_cado_straordinari_i, 0);
         
            d_cado_ore_incaricati := gp4do.conta_ore_non_ruolo(p_revisione
                                                              ,'Q'
                                                              ,p_data
                                                              ,p_gestione
                                                              ,posti.door_id
                                                              ,d_cost_ore_lavoro);
         
            d_cado_ore_mansioni_sup_i := conta_ore_mansioni_sup(p_revisione
                                                               ,'I'
                                                               ,p_data
                                                               ,p_gestione
                                                               ,posti.door_id
                                                               ,d_cost_ore_lavoro);
            d_cado_ore_mansioni_sup   := conta_ore_mansioni_sup(p_revisione
                                                               ,'Q'
                                                               ,p_data
                                                               ,p_gestione
                                                               ,posti.door_id
                                                               ,d_cost_ore_lavoro);
         
            d_cado_ore_inc_aq := conta_ore_inc_aq(p_revisione
                                                 ,'Q'
                                                 ,p_data
                                                 ,p_gestione
                                                 ,posti.door_id
                                                 ,d_cost_ore_lavoro);
         
            d_cado_coperti_ruolo := greatest(d_cado_coperti_ruolo, 0);
         
            /*            d_cado_coperti_ruolo := greatest(d_cado_coperti_ruolo -
                                                         nvl(d_cado_ore_inc_aq, 0) -
                                                         nvl(d_cado_straordinari_i, 0)
                                                        ,0);
            */
            d_cado_assenze_non_retr := conta_ore_aspettative(p_revisione
                                                            ,'Q'
                                                            ,p_data
                                                            ,p_gestione
                                                            ,posti.door_id
                                                            ,d_cost_ore_lavoro);
         
            d_cado_assegnazioni := nvl(d_cado_coperti_ruolo, 0) -
                                   nvl(d_cado_ore_mansioni_sup, 0) +
                                   nvl(d_cado_incaricati, 0) +
                                   nvl(d_cado_ore_supplenti, 0) +
                                   nvl(d_cado_straordinari, 0) +
                                   nvl(d_cado_ore_mansioni_sup_i, 0) -
                                   nvl(d_cado_assenze_non_retr, 0);
         
            d_cado_ore_mansioni_sup := d_cado_ore_mansioni_sup_i;
         
            --------------------------------------------------------------------------------------------------------
            -----------------------------------------------------------------------------------
            --
            --  INSERIMENTO REGISTRAZIONI POSTO.
            --
            /*            dbms_output.put_line('Inserimento : d_sett_codice : ' || d_sett_codice ||
                                             '  -  d_setb_codice : ' || d_setb_codice || ' ' ||
                                             d_figi_profilo || ' ' || d_figi_posizione || ' ' ||
                                             d_popi_attivita || d_cado_vacanti || ' ' ||
                                             d_cado_previsti || ' ' || d_cado_ass_ruolo ||
                                             ' incaricati : ' || d_cado_incaricati || ' door_id : ' ||
                                             d_popi_posto || ' universitari : ' ||
                                             d_cado_universitari || ' inc_td : ' ||
                                             d_cado_straordinari || ' contrattisti : ' ||
                                             d_contrattisti);
            */
            insert into calcolo_dotazione
               (cado_prenotazione
               ,cado_rilevanza
               ,cado_lingue
               ,rior_data
               ,popi_sede_posto
               ,popi_anno_posto
               ,popi_numero_posto
               ,popi_posto
               ,popi_dal
               ,popi_ricopribile
               ,popi_gruppo
               ,popi_pianta
               ,setp_sequenza
               ,setp_codice
               ,popi_settore
               ,sett_sequenza
               ,sett_codice
               ,sett_suddivisione
               ,sett_settore_g
               ,setg_sequenza
               ,setg_codice
               ,sett_settore_a
               ,seta_sequenza
               ,seta_codice
               ,sett_settore_b
               ,setb_sequenza
               ,setb_codice
               ,sett_settore_c
               ,setc_sequenza
               ,setc_codice
               ,sett_gestione
               ,gest_prospetto_po
               ,gest_sintetico_po
               ,popi_figura
               ,figi_dal
               ,figu_sequenza
               ,figi_codice
               ,figi_qualifica
               ,qugi_dal
               ,qual_sequenza
               ,qugi_codice
               ,qugi_contratto
               ,cost_dal
               ,cont_sequenza
               ,cost_ore_lavoro
               ,qugi_livello
               ,figi_profilo
               ,prpr_sequenza
               ,prpr_suddivisione_po
               ,figi_posizione
               ,pofu_sequenza
               ,qugi_ruolo
               ,ruol_sequenza
               ,popi_attivita
               ,atti_sequenza
               ,pegi_posizione
               ,posi_sequenza
               ,pegi_tipo_rapporto
               ,cado_previsti
               ,cado_ore_previsti
               ,cado_in_pianta
               ,cado_in_deroga
               ,cado_in_sovrannumero
               ,cado_in_rilascio
               ,cado_in_acquisizione
               ,cado_in_istituzione
               ,cado_assegnazioni_ruolo_l1
               ,cado_ore_assegnazioni_ruolo_l1
               ,cado_assegnazioni_ruolo_l2
               ,cado_ore_assegnazioni_ruolo_l2
               ,cado_assegnazioni_ruolo_l3
               ,cado_ore_assegnazioni_ruolo_l3
               ,cado_assegnazioni_ruolo
               ,cado_vacanti
               ,cado_vacanti_coperti
               ,cado_coperti_ruolo
               ,cado_coperti_no_ruolo
               ,cado_sostituibili
               ,cado_supplenti
               ,cado_assenze_assenza
               ,cado_tp
               ,cado_td
               ,cado_mansioni_sup
               ,cado_inc_aq
               ,cado_assenze_non_retr
               ,cado_universitari
               ,cado_incaricati
               ,cado_straordinari
               ,cado_assegnazioni)
            values
               (w_prenotazione
               ,1
               ,p_lingue
               ,d_rior_data
               ,d_popi_sede_posto
               ,d_popi_anno_posto
               ,d_popi_numero_posto
               ,d_popi_posto
               ,d_popi_dal
               ,d_popi_ricopribile
               ,d_popi_gruppo
               ,d_popi_pianta
               ,d_setp_sequenza
               ,d_setp_codice
               ,d_popi_settore
               ,d_sett_sequenza
               ,d_sett_codice
               ,d_sett_suddivisione
               ,d_sett_settore_g
               ,d_setg_sequenza
               ,d_setg_codice
               ,d_sett_settore_a
               ,d_seta_sequenza
               ,d_seta_codice
               ,d_sett_settore_b
               ,d_setb_sequenza
               ,d_setb_codice
               ,d_sett_settore_c
               ,d_setc_sequenza
               ,d_setc_codice
               ,d_sett_gestione
               ,d_gest_prospetto_po
               ,d_gest_sintetico_po
               ,d_popi_figura
               ,d_figi_dal
               ,d_figu_sequenza
               ,d_figi_codice
               ,d_figi_qualifica
               ,d_qugi_dal
               ,d_qual_sequenza
               ,d_qugi_codice
               ,d_qugi_contratto
               ,d_cost_dal
               ,d_cont_sequenza
               ,d_cost_ore_lavoro
               ,d_qugi_livello
               ,d_figi_profilo
               ,d_prpr_sequenza
               ,d_prpr_suddivisione_po
               ,d_figi_posizione
               ,d_pofu_sequenza
               ,d_qugi_ruolo
               ,d_ruol_sequenza
               ,d_popi_attivita
               ,d_atti_sequenza
               ,null
               ,0
               ,null
               ,d_cado_previsti
               ,d_cado_ore_previsti
               ,0
               ,0
               ,0
               ,0
               ,0
               ,0
               ,d_cado_ass_ruolo_l1
               ,d_cado_ore_ass_ruolo_l1
               ,d_cado_ass_ruolo_l2
               ,d_cado_ore_ass_ruolo_l2
               ,d_cado_ass_ruolo_l3
               ,d_cado_ore_ass_ruolo_l3
               ,d_cado_ass_ruolo
               ,d_cado_vacanti
               ,0
               ,d_cado_coperti_ruolo
               ,d_cado_coperti_no_ruolo
               ,d_cado_sostituibili
               ,d_cado_ore_supplenti
               ,d_cado_assenze_assenza
               ,d_cado_tp
               ,d_cado_td
               ,d_cado_ore_mansioni_sup
               ,d_cado_ore_inc_aq
               ,d_cado_assenze_non_retr
               ,d_cado_universitari
               ,d_cado_incaricati
               ,d_cado_straordinari
               ,d_cado_assegnazioni);
         
            if d_cado_vacanti > 0 then
               for vacanti in 1 .. d_cado_vacanti
               loop
                  begin
                     d_cost_ore_lavoro    := gp4_cost.get_ore_lavoro(d_qugi_numero
                                                                    ,p_data);
                     d_popi_ore           := nvl(d_popi_ore, d_cost_ore_lavoro);
                     d_pegi_ore           := d_cost_ore_lavoro;
                     d_pegi_posizione     := null;
                     d_posi_sequenza      := 999;
                     d_pegi_tipo_rapporto := null;
                     d_sett_sede          := 0;
                     d_popi_dal           := null;
                     d_popi_sede_posto    := '.';
                     d_popi_anno_posto    := '';
                     d_popi_numero_posto  := '';
                     d_popi_posto         := vacanti;
                     d_setb_codice        := nvl(gp4_reuo.get_codice_padre(d_revisione_rest
                                                                          ,d_sett_codice
                                                                          ,2)
                                                ,d_sett_codice);
                  
                     /*                     dbms_output.put_line(' vacante : ' || d_qugi_numero || ' ' ||
                                                               d_figi_profilo || ' ' || d_figi_posizione || ' ' ||
                                                               d_qugi_ruolo || ' ' || d_pegi_ore || ' ' ||
                                                               d_popi_attivita || ' ' || d_popi_ore || ' ' ||
                                                               d_cost_ore_lavoro);
                     */
                     insert into calcolo_nominativo_dotazione
                        (cndo_prenotazione
                        ,cndo_rilevanza
                        ,rior_data
                        ,popi_sede_posto
                        ,popi_anno_posto
                        ,popi_numero_posto
                        ,popi_posto
                        ,popi_gruppo
                        ,popi_dal
                        ,popi_ricopribile
                        ,popi_pianta
                        ,setp_sequenza
                        ,setp_codice
                        ,popi_settore
                        ,sett_sequenza
                        ,sett_codice
                        ,sett_suddivisione
                        ,sett_settore_g
                        ,setg_sequenza
                        ,setg_codice
                        ,sett_settore_a
                        ,seta_sequenza
                        ,seta_codice
                        ,sett_settore_b
                        ,setb_sequenza
                        ,setb_codice
                        ,sett_settore_c
                        ,setc_sequenza
                        ,setc_codice
                        ,sett_gestione
                        ,gest_prospetto_po
                        ,gest_sintetico_po
                        ,sett_sede
                        ,sedi_codice
                        ,sedi_sequenza
                        ,popi_figura
                        ,figi_dal
                        ,figu_sequenza
                        ,figi_codice
                        ,figi_qualifica
                        ,qugi_dal
                        ,qual_sequenza
                        ,qugi_codice
                        ,qugi_contratto
                        ,cost_dal
                        ,cont_sequenza
                        ,cost_ore_lavoro
                        ,qugi_livello
                        ,figi_profilo
                        ,prpr_sequenza
                        ,prpr_suddivisione_po
                        ,figi_posizione
                        ,pofu_sequenza
                        ,qugi_ruolo
                        ,ruol_sequenza
                        ,popi_attivita
                        ,atti_sequenza
                        ,pegi_posizione
                        ,posi_sequenza
                        ,pegi_tipo_rapporto
                        ,pegi_ci
                        ,pegi_sostituto
                        ,pegi_rilevanza
                        ,pegi_ore
                        ,pegi_assenza
                        ,pegi_gruppo_ling
                        ,cndo_mm_eta
                        ,cndo_aa_eta
                        ,cndo_gg_anz
                        ,cndo_mm_anz
                        ,cndo_aa_anz
                        ,cndo_dal
                        ,cndo_al
                        ,popi_sede_posto_inc
                        ,popi_anno_posto_inc
                        ,popi_numero_posto_inc
                        ,popi_posto_inc
                        ,cndo_tp
                        ,cndo_td
                        ,cndo_ruolo
                        ,cndo_incaricato
                        ,cndo_mans_sup
                        ,cndo_inc_td
                        ,cndo_supplente
                        ,cndo_inc_aq
                        ,cndo_assente
                        ,cndo_aspettativa
                        ,cndo_univ
                        ,cndo_vac_tit
                        ,cndo_sovr)
                     values
                        (w_prenotazione
                        ,1
                        ,d_rior_data
                        ,d_popi_sede_posto
                        ,d_popi_anno_posto
                        ,d_popi_numero_posto
                        ,d_popi_posto
                        ,d_popi_gruppo
                        ,d_popi_dal
                        ,d_popi_ricopribile
                        ,d_popi_pianta
                        ,d_setp_sequenza
                        ,d_setp_codice
                        ,d_popi_settore
                        ,d_sett_sequenza
                        ,d_sett_codice
                        ,d_sett_suddivisione
                        ,d_sett_settore_g
                        ,d_setg_sequenza
                        ,d_sett_gestione
                        ,d_sett_settore_a
                        ,d_seta_sequenza
                        ,d_seta_codice
                        ,d_sett_settore_b
                        ,d_setb_sequenza
                        ,d_setb_codice
                        ,d_sett_settore_c
                        ,d_setc_sequenza
                        ,d_setc_codice
                        ,d_sett_gestione
                        ,d_gest_prospetto_po
                        ,d_gest_sintetico_po
                        ,d_sett_sede
                        ,d_sedi_codice
                        ,d_sedi_sequenza
                        ,d_popi_figura
                        ,d_figi_dal
                        ,d_figu_sequenza
                        ,d_figi_codice
                        ,d_figi_qualifica
                        ,d_qugi_dal
                        ,d_qual_sequenza
                        ,d_qugi_codice
                        ,d_qugi_contratto
                        ,d_cost_dal
                        ,d_cont_sequenza
                        ,d_cost_ore_lavoro
                        ,d_qugi_livello
                        ,d_figi_profilo
                        ,d_prpr_sequenza
                        ,d_prpr_suddivisione_po
                        ,d_figi_posizione
                        ,d_pofu_sequenza
                        ,d_qugi_ruolo
                        ,d_ruol_sequenza
                        ,d_popi_attivita
                        ,d_atti_sequenza
                        ,d_pegi_posizione
                        ,d_posi_sequenza
                        ,d_pegi_tipo_rapporto
                        ,0
                        ,0
                        ,'V'
                        ,nvl(d_pegi_ore, nvl(d_popi_ore, d_cost_ore_lavoro))
                        ,null
                        ,d_anag_gruppo_ling
                        ,d_cndo_mm_eta
                        ,d_cndo_aa_eta
                        ,d_cndo_gg_anz
                        ,d_cndo_mm_anz
                        ,d_cndo_aa_anz
                        ,to_date(null)
                        ,to_date(null)
                        ,d_popi_sede_posto_inc
                        ,d_popi_anno_posto_inc
                        ,d_popi_numero_posto_inc
                        ,d_popi_posto_inc
                        ,d_pegi_tp
                        ,d_pegi_td
                        ,''
                        ,''
                        ,''
                        ,''
                        ,''
                        ,''
                        ,''
                        ,''
                        ,''
                        ,1
                        ,'');
                  end;
               end loop;
            end if;
         end;
      end loop;
   
      -- non previsti -2-
      begin
         insert into calcolo_dotazione
            (cado_prenotazione
            ,cado_rilevanza
            ,cado_lingue
            ,rior_data
            ,popi_sede_posto
            ,popi_anno_posto
            ,popi_numero_posto
            ,popi_posto
            ,popi_dal
            ,popi_ricopribile
            ,popi_gruppo
            ,popi_pianta
            ,setp_sequenza
            ,setp_codice
            ,popi_settore
            ,sett_sequenza
            ,sett_codice
            ,sett_suddivisione
            ,sett_settore_g
            ,setg_sequenza
            ,setg_codice
            ,sett_settore_a
            ,seta_sequenza
            ,seta_codice
            ,sett_settore_b
            ,setb_sequenza
            ,setb_codice
            ,sett_settore_c
            ,setc_sequenza
            ,setc_codice
            ,sett_gestione
            ,gest_prospetto_po
            ,gest_sintetico_po
            ,popi_figura
            ,figi_dal
            ,figu_sequenza
            ,figi_codice
            ,figi_qualifica
            ,qugi_dal
            ,qual_sequenza
            ,qugi_codice
            ,qugi_contratto
            ,cost_dal
            ,cont_sequenza
            ,cost_ore_lavoro
            ,qugi_livello
            ,figi_profilo
            ,prpr_sequenza
            ,prpr_suddivisione_po
            ,figi_posizione
            ,pofu_sequenza
            ,qugi_ruolo
            ,ruol_sequenza
            ,popi_attivita
            ,atti_sequenza
            ,pegi_posizione
            ,posi_sequenza
            ,pegi_tipo_rapporto
            ,cado_previsti
            ,cado_ore_previsti
            ,cado_in_pianta
            ,cado_in_deroga
            ,cado_in_sovrannumero
            ,cado_in_rilascio
            ,cado_in_acquisizione
            ,cado_in_istituzione
            ,cado_assegnazioni_ruolo_l1
            ,cado_ore_assegnazioni_ruolo_l1
            ,cado_assegnazioni_ruolo_l2
            ,cado_ore_assegnazioni_ruolo_l2
            ,cado_assegnazioni_ruolo_l3
            ,cado_ore_assegnazioni_ruolo_l3
            ,cado_assegnazioni_ruolo
            ,cado_vacanti
            ,cado_vacanti_coperti
            ,cado_coperti_ruolo
            ,cado_coperti_no_ruolo
            ,cado_sostituibili
            ,cado_supplenti
            ,cado_assenze_assenza
            ,cado_tp
            ,cado_td
            ,cado_mansioni_sup
            ,cado_inc_aq
            ,cado_assenze_non_retr
            ,cado_universitari
            ,cado_incaricati
            ,cado_straordinari
            ,cado_assegnazioni)
            select w_prenotazione
                  ,1
                  ,p_lingue
                  ,d_rior_data
                  ,'.'
                  ,null
                  ,null
                  ,0
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,pedo.codice_uo
                  ,pedo.settore
                  ,null
                  ,pedo.codice_uo
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,pedo.gestione
                  ,null
                  ,null
                  ,null
                  ,null
                  ,null
                  ,pedo.cod_figura
                  ,null
                  ,null
                  ,null
                  ,pedo.cod_qualifica
                  ,null
                  ,null
                  ,null
                  ,null
                  ,pedo.livello
                  ,pedo.profilo
                  ,null
                  ,null
                  ,pedo.pos_funz
                  ,null
                  ,pedo.ruolo
                  ,null
                  ,pedo.attivita
                  ,null
                  ,null
                  ,0
                  ,null
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,sum(decode(pedo.di_ruolo, 'SI', 1, 0)) di_ruolo
                  ,0
                  ,0
                  ,sum(decode(pedo.di_ruolo, 'SI', 1, 0)) di_ruolo
                  ,sum(decode(pedo.di_ruolo, 'NO', 1, 0)) no_ruolo
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0
                  ,0 --incaricati
                   --                  ,sum(decode(posi.ruolo, 'SI', decode(posi.di_ruolo, 'F', 1, 0), 0)) inc_aq
                  ,sum(decode(posi.di_ruolo, 'F', 1, 0)) inc_aq
                  ,0 --:d_cado_assenze_non_retr
                  ,sum(decode(pedo.ruolo, 'UNIV', 1, 0)) universitari
                  ,sum(decode(pedo.di_ruolo, 'NO', 1, 0)) -
                   sum(decode(pedo.sovrannumero, 'SI', 1, 0)) -
                   sum(decode(pedo.ruolo, 'UNIV', 1, 0)) -
                   sum(decode(pedo.contrattista, 'SI', 1, 0)) no_ruolo
                  ,sum(decode(pedo.sovrannumero, 'SI', 1, 0)) sovrannumero
                  ,sum(1)
              from periodi_dotazione pedo
                  ,posizioni         posi
             where posi.codice = pedo.posizione
               and p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and revisione = p_revisione
               and door_id + 0 = 0
               and rilevanza = 'Q'
               and pedo.ci > 0
            --               and pedo.ci in (12883, 37404)
             group by pedo.codice_uo
                     ,pedo.settore
                     ,pedo.codice_uo
                     ,pedo.gestione
                     ,pedo.cod_figura
                     ,pedo.cod_qualifica
                     ,pedo.livello
                     ,pedo.profilo
                     ,pedo.pos_funz
                     ,pedo.ruolo
                     ,pedo.attivita;
      end;
   
      ------------------------------------------------------------------------------
      ------------------------------------------------------------------------------
      ------------------------------------------------------------------------------
      /* Nominativa */
      ------------------------------------------------------------------------------
      ------------------------------------------------------------------------------
      ------------------------------------------------------------------------------
      begin
         if p_nominativa = 'X' then
            for periodi in (select pedo.ore
                                  ,pedo.gestione
                                  ,pedo.posizione
                                  ,999 posi_sequenza
                                  ,pedo.tipo_rapporto
                                  ,pedo.figura
                                  ,nvl(pedo.qualifica
                                      ,gp4_figi.get_qualifica(pedo.figura, p_data)) qualifica
                                  ,pedo.settore
                                  ,pedo.codice_uo
                                  ,0 sede
                                  ,pedo.ci
                                  ,decode(get_sostituto(pedo.ci, p_data)
                                         ,0
                                         ,pedo.ci
                                         ,get_sostituto(pedo.ci, p_data)) sostituto
                                  ,pedo.rilevanza
                                  ,gp4do.get_assenza(pedo.ci, p_data) assenza
                                  ,pedo.dal
                                  ,pedo.al
                                  ,pedo.di_ruolo di_ruolo
                                  ,'I' gruppo_ling
                                  ,pedo.ue
                                  ,pedo.sovrannumero
                                  ,pedo.contrattista
                                  ,gp4_posi.get_universitario(pedo.posizione) universitario
                                  ,gp4gm.get_se_assente(pedo.ci, p_data) assente
                                  ,pedo.door_id
                                  ,pedo.profilo
                                  ,pedo.pos_funz
                                  ,pedo.ruolo
                                  ,pedo.attivita
                              from periodi_dotazione pedo
                             where p_data between pedo.dal and
                                   nvl(pedo.al, to_date('3333333', 'j'))
                                  --                               and door_id in (83897, 82563, 82814)
                               and pedo.revisione = p_revisione
                               and pedo.rilevanza in ('Q', 'I')
                                  --                               and pedo.ci in (12883, 37404)
                               and pedo.ci > 0
                             order by pedo.ci
                                     ,pedo.rilevanza desc)
            loop
               begin
                  --                  DBMS_OUTPUT.put_line ('CI : ' || periodi.ci);
                  d_cndo_mm_eta      := null;
                  d_cndo_aa_eta      := null;
                  d_cndo_gg_anz      := null;
                  d_cndo_mm_anz      := null;
                  d_cndo_aa_anz      := null;
                  d_cndo_ruolo       := null;
                  d_cndo_incaricato  := null;
                  d_cndo_mans_sup    := null;
                  d_cndo_inc_td      := null;
                  d_cndo_supplente   := null;
                  d_cndo_inc_aq      := null;
                  d_cndo_assente     := null;
                  d_cndo_aspettativa := null;
                  d_cndo_univ        := null;
                  d_cndo_vac_tit     := null;
                  d_cndo_vac_disp    := null;
                  d_cndo_sovr        := null;
                  d_cndo_disp_supp   := null;
                  d_setb_codice      := gp4_reuo.get_codice_padre(d_revisione_rest
                                                                 ,periodi.codice_uo
                                                                 ,2);
               
                  --                   DBMS_OUTPUT.put_line (   'd_sett_codice : '
                  --                                         || d_sett_codice
                  --                                         || '  -  d_setb_codice : '
                  --                                         || d_setb_codice
                  --                                        );
                  begin
                     select nvl(sequenza, 999999)
                           ,codice
                       into d_setp_sequenza
                           ,d_setp_codice
                       from settori
                      where numero = periodi.settore;
                  end;
               
                  -- Copertura di dipendente di ruolo
                  if periodi.di_ruolo = 'SI' and periodi.rilevanza = 'Q' and
                     periodi.sovrannumero = 'NO' then
                     d_cndo_ruolo := 1;
                  end if;
               
                  -- Dipendente di ruolo con incarico in altra qualifica
                  d_ore := null;
                  if periodi.rilevanza = 'Q' then
                     begin
                     
                        select sum(pedo.ore)
                          into d_ore
                          from periodi_dotazione pedo
                         where p_data between pedo.dal and
                               nvl(pedo.al, to_date('3333333', 'J'))
                           and pedo.rilevanza = 'Q'
                           and pedo.revisione = p_revisione
                           and pedo.ci = periodi.ci
                           and pedo.dal = periodi.dal
                           and pedo.di_ruolo = 'SI'
                           and exists
                         (select 1
                                  from periodi_dotazione pedo_i
                                 where p_data between pedo_i.dal and
                                       nvl(pedo_i.al, to_date('3333333', 'J'))
                                   and pedo_i.ci = pedo.ci
                                   and pedo_i.rilevanza = 'I'
                                   and pedo_i.revisione = p_revisione
                                   and pedo_i.door_id <> pedo.door_id
                                   and exists (select 'x'
                                          from posizioni
                                         where codice = pedo_i.posizione
                                              --            and ruolo = 'SI'
                                           and di_ruolo = 'F'));
                     end;
                  
                     if d_ore <> 0 then
                        d_cndo_inc_aq := 1;
                     end if;
                  end if;
                  -- Dipendente di ruolo con mansioni superiori
                  begin
                     select sum(pedo.ore)
                       into d_ore
                       from periodi_dotazione pedo
                      where p_data between pedo.dal and
                            nvl(pedo.al, to_date('3333333', 'J'))
                        and pedo.rilevanza = 'Q'
                        and pedo.revisione = p_revisione
                        and pedo.ci = periodi.ci
                        and pedo.dal = periodi.dal
                        and pedo.di_ruolo = 'SI'
                        and exists
                      (select 1
                               from periodi_dotazione pedo_i
                              where p_data between pedo_i.dal and
                                    nvl(pedo_i.al, to_date('3333333', 'J'))
                                and pedo_i.ci = pedo.ci
                                and pedo_i.rilevanza = 'I'
                                and pedo_i.revisione = p_revisione
                                and pedo_i.door_id <> pedo.door_id
                                and exists (select 'x'
                                       from posizioni
                                      where codice = pedo_i.posizione
                                        and ruolo = 'SI'
                                        and di_ruolo = 'R'));
                  end;
               
                  if d_ore <> 0 then
                     d_cndo_mans_sup := 1;
                  end if;
               
                  if periodi.di_ruolo = 'SI' and periodi.rilevanza = 'I' and
                     periodi.sovrannumero = 'NO' then
                     d_cndo_mans_sup := 1;
                  end if;
               
                  if periodi.di_ruolo = 'NO' then
                     -- Copertura di dipendente supplente
                     begin
                        d_ore := 0;
                     
                        select sum(pedo.ore)
                          into d_ore
                          from periodi_dotazione pedo
                         where p_data between pedo.dal and
                               nvl(pedo.al, to_date('3333333', 'J'))
                           and pedo.rilevanza = 'Q'
                           and pedo.revisione = p_revisione
                           and pedo.door_id <> 0
                           and pedo.ci = periodi.ci
                           and pedo.dal = periodi.dal
                           and pedo.di_ruolo = 'NO'
                           and gp4gm.get_se_assente(pedo.ci, p_data) = 0
                           and gp4gm.get_se_incaricato(pedo.ci, p_data) = 0
                           and exists
                         (select 'x'
                                  from sostituzioni_giuridiche
                                 where sostituto = pedo.ci
                                   and p_data between dal and
                                       nvl(al, to_date(3333333, 'j'))
                                   and gp4gm.get_se_di_ruolo(titolare, p_data) = 1);
                     end;
                  
                     if d_ore > 0 then
                        d_cndo_supplente := 1;
                     end if;
                     -- Copertura di dipendente non di ruolo incaricato
                     begin
                        d_ore := 0;
                     
                        select sum(pedo.ore)
                          into d_ore
                          from periodi_dotazione pedo
                         where p_data between pedo.dal and
                               nvl(pedo.al, to_date('3333333', 'J'))
                           and pedo.rilevanza = 'Q'
                           and pedo.revisione = p_revisione
                           and pedo.door_id <> 0
                           and pedo.ci = periodi.ci
                           and pedo.dal = periodi.dal
                           and pedo.di_ruolo = 'NO'
                           and pedo.sovrannumero = 'NO'
                           and gp4gm.get_se_assente(pedo.ci, p_data) = 0
                           and gp4gm.get_se_incaricato(pedo.ci, p_data) = 0;
                     end;
                  
                     if d_ore > 0 and nvl(d_cndo_supplente, 0) = 0 then
                        d_cndo_incaricato := 1;
                     end if;
                  
                  end if;
               
                  -- Dipendente di ruolo senza posto ( sovrannumerario )
                  if periodi.di_ruolo = 'SI' and periodi.rilevanza = 'Q' and
                     periodi.sovrannumero = 'SI' then
                     d_cndo_sovr := 1;
                  end if;
               
                  -- Dipendente non di ruolo senza posto (straordinario o inc.t.d.)
                  if periodi.di_ruolo = 'NO' and periodi.rilevanza in ('Q', 'I') and
                     periodi.sovrannumero = 'SI' then
                     d_cndo_inc_td := 1;
                  end if;
               
                  -- Dipendente universitario
                  if periodi.di_ruolo = 'NO' and periodi.rilevanza = 'Q' and
                     periodi.universitario = 'SI' then
                     d_cndo_univ        := 1;
                     d_cndo_ruolo       := null;
                     d_cndo_incaricato  := null;
                     d_cndo_mans_sup    := null;
                     d_cndo_inc_td      := null;
                     d_cndo_supplente   := null;
                     d_cndo_inc_aq      := null;
                     d_cndo_assente     := null;
                     d_cndo_aspettativa := null;
                     d_cndo_vac_tit     := null;
                     d_cndo_vac_disp    := null;
                     d_cndo_sovr        := null;
                     d_cndo_disp_supp   := null;
                  end if;
               
                  -- Dipendente con assenza sostituibile
                  d_ore          := null;
                  d_cndo_assente := periodi.assente;
               
                  -- Dipendente con apettativa non retribuita
                  if periodi.assenza is not null then
                     begin
                        select per_ret
                          into d_ore
                          from astensioni
                         where codice = periodi.assenza;
                     end;
                  end if;
               
                  if d_ore = 0 then
                     d_cndo_aspettativa := 1;
                  end if;
               
                  -- Posto vacante
                  --            IF d_rilevanza = 3 THEN
                  --               d_cndo_vac_tit := 1;
                  --            END IF;
                  begin
                     select nvl(s.sequenza, 999999)
                           ,s.codice
                           ,s.suddivisione
                           ,s.gestione
                           ,g.prospetto_po
                           ,nvl(g.sintetico_po, g.prospetto_po)
                           ,s.settore_g
                           ,s.settore_a
                           ,s.settore_b
                           ,s.settore_c
                           ,g.sintetico_po
                       into d_sett_sequenza
                           ,d_sett_codice
                           ,d_sett_suddivisione
                           ,d_sett_gestione
                           ,d_gest_prospetto_po
                           ,d_gest_sintetico_po
                           ,d_sett_settore_g
                           ,d_sett_settore_a
                           ,d_sett_settore_b
                           ,d_sett_settore_c
                           ,d_gest_sintetico_po
                       from gestioni g
                           ,settori  s
                      where s.numero = periodi.settore
                        and g.codice = s.gestione;
                  end;
               
                  begin
                     select nvl(sequenza, 999999)
                       into d_atti_sequenza
                       from attivita
                      where codice = d_popi_attivita;
                  exception
                     when no_data_found then
                        d_atti_sequenza := 999999;
                  end;
               
                  calcolo_eta_anzianita(periodi.ci
                                       ,d_cndo_mm_eta
                                       ,d_cndo_aa_eta
                                       ,d_cndo_gg_anz
                                       ,d_cndo_mm_anz
                                       ,d_cndo_aa_anz);
               
                  --                   DBMS_OUTPUT.put_line (   ' d_sett_gestione : '
                  --                                         || d_sett_gestione
                  --                                         || ' d_sett_codice : '
                  --                                         || d_sett_codice
                  --                                         || ' d_qugi_ruolo : '
                  --                                         || d_qugi_ruolo
                  --                                         || ' d_figi_profilo : '
                  --                                         || d_figi_profilo
                  --                                         || ' d_figi_posizione : '
                  --                                         || d_figi_posizione
                  --                                         || ' d_popi_attivita : '
                  --                                         || d_popi_attivita
                  --                                        );
               
                  insert into calcolo_nominativo_dotazione
                     (cndo_prenotazione
                     ,cndo_rilevanza
                     ,rior_data
                     ,popi_sede_posto
                     ,popi_anno_posto
                     ,popi_numero_posto
                     ,popi_posto
                     ,popi_gruppo
                     ,popi_dal
                     ,popi_ricopribile
                     ,popi_pianta
                     ,setp_sequenza
                     ,setp_codice
                     ,popi_settore
                     ,sett_sequenza
                     ,sett_codice
                     ,sett_suddivisione
                     ,sett_settore_g
                     ,setg_sequenza
                     ,setg_codice
                     ,sett_settore_a
                     ,seta_sequenza
                     ,seta_codice
                     ,sett_settore_b
                     ,setb_sequenza
                     ,setb_codice
                     ,sett_settore_c
                     ,setc_sequenza
                     ,setc_codice
                     ,sett_gestione
                     ,gest_prospetto_po
                     ,gest_sintetico_po
                     ,sett_sede
                     ,sedi_codice
                     ,sedi_sequenza
                     ,popi_figura
                     ,figi_dal
                     ,figu_sequenza
                     ,figi_codice
                     ,figi_qualifica
                     ,qugi_dal
                     ,qual_sequenza
                     ,qugi_codice
                     ,qugi_contratto
                     ,cost_dal
                     ,cont_sequenza
                     ,cost_ore_lavoro
                     ,qugi_livello
                     ,figi_profilo
                     ,prpr_sequenza
                     ,prpr_suddivisione_po
                     ,figi_posizione
                     ,pofu_sequenza
                     ,qugi_ruolo
                     ,ruol_sequenza
                     ,popi_attivita
                     ,atti_sequenza
                     ,pegi_posizione
                     ,posi_sequenza
                     ,pegi_tipo_rapporto
                     ,pegi_ci
                     ,pegi_sostituto
                     ,pegi_rilevanza
                     ,pegi_ore
                     ,pegi_assenza
                     ,pegi_gruppo_ling
                     ,cndo_mm_eta
                     ,cndo_aa_eta
                     ,cndo_gg_anz
                     ,cndo_mm_anz
                     ,cndo_aa_anz
                     ,cndo_dal
                     ,cndo_al
                     ,popi_sede_posto_inc
                     ,popi_anno_posto_inc
                     ,popi_numero_posto_inc
                     ,popi_posto_inc
                     ,cndo_tp
                     ,cndo_td
                     ,cndo_ruolo
                     ,cndo_incaricato
                     ,cndo_mans_sup
                     ,cndo_inc_td
                     ,cndo_supplente
                     ,cndo_inc_aq
                     ,cndo_assente
                     ,cndo_aspettativa
                     ,cndo_univ
                     ,cndo_vac_tit
                     ,cndo_sovr)
                     select w_prenotazione
                           ,1
                           ,d_rior_data
                           ,'' --d_popi_sede_posto
                           ,'' --d_popi_anno_posto
                           ,'' --d_popi_numero_posto
                           ,periodi.door_id --popi_posto
                           ,'' --d_popi_gruppo
                           ,'' --d_popi_dal
                           ,'' --d_popi_ricopribile
                           ,'' --d_popi_pianta
                           ,d_setp_sequenza
                           ,d_setp_codice
                           ,periodi.settore --d_popi_settore
                           ,d_sett_sequenza
                           ,d_sett_codice
                           ,d_sett_suddivisione
                           ,d_sett_settore_g
                           ,'' --d_setg_sequenza
                           ,periodi.gestione
                           ,d_sett_settore_a
                           ,'' --d_seta_sequenza
                           ,'' --d_seta_codice
                           ,d_sett_settore_b
                           ,'' --d_setb_sequenza
                           ,d_setb_codice
                           ,d_sett_settore_c
                           ,'' --d_setc_sequenza
                           ,'' --d_setc_codice
                           ,d_sett_gestione
                           ,'' --d_gest_prospetto_po
                           ,'' --d_gest_sintetico_po
                           ,'' --d_sett_sede
                           ,'' --d_sedi_codice
                           ,'' --d_sedi_sequenza
                           ,'' --d_popi_figura
                           ,'' --d_figi_dal
                           ,'' --d_figu_sequenza
                           ,'' --d_figi_codice
                           ,'' --d_figi_qualifica
                           ,'' --d_qugi_dal
                           ,'' --d_qual_sequenza
                           ,'' --d_qugi_codice
                           ,'' --d_qugi_contratto
                           ,'' --d_cost_dal
                           ,'' --d_cont_sequenza
                           ,'' --d_cost_ore_lavoro
                           ,'' --d_qugi_livello
                           ,periodi.profilo --d_figi_profilo
                           ,'' --d_prpr_sequenza
                           ,'' --d_prpr_suddivisione_po
                           ,periodi.pos_funz --d_figi_posizione
                           ,'' --d_pofu_sequenza
                           ,periodi.ruolo --d_qugi_ruolo
                           ,'' --d_ruol_sequenza
                           ,periodi.attivita --d_popi_attivita
                           ,'' --d_atti_sequenza
                           ,periodi.posizione
                           ,'' --d_posi_sequenza
                           ,periodi.tipo_rapporto
                           ,periodi.ci
                           ,periodi.sostituto
                           ,periodi.rilevanza
                           ,periodi.ore
                           ,periodi.assenza
                           ,'I'
                           ,d_cndo_mm_eta
                           ,d_cndo_aa_eta
                           ,d_cndo_gg_anz
                           ,d_cndo_mm_anz
                           ,d_cndo_aa_anz
                           ,periodi.dal
                           ,periodi.al
                           ,'' --d_popi_sede_posto_inc
                           ,'' --d_popi_anno_posto_inc
                           ,'' --d_popi_numero_posto_inc
                           ,'' --d_popi_posto_inc
                           ,'' --d_pegi_tp
                           ,'' --d_pegi_td
                           ,d_cndo_ruolo
                           ,d_cndo_incaricato
                           ,d_cndo_mans_sup
                           ,d_cndo_inc_td
                           ,d_cndo_supplente
                           ,d_cndo_inc_aq
                           ,d_cndo_assente
                           ,d_cndo_aspettativa
                           ,d_cndo_univ
                           ,d_cndo_vac_tit
                           ,d_cndo_sovr
                       from dual;
               end;
            end loop;
            ----------------------------------------------- fine nominativa
         end if;
      end;
   end;

   procedure calcolo is
   begin
      begin
         delete_tab;
         seq_lingua;
         cc_posti;
      exception
         when form_trigger_failure then
            raise;
      end;
   end;

   procedure main
   (
      prenotazione in number
     ,passo        in number
   ) is
   begin
      if prenotazione != 0 then
         begin
            -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
            select utente
                  ,ambiente
                  ,ente
                  ,gruppo_ling
                  ,voce_menu
              into w_utente
                  ,w_ambiente
                  ,w_ente
                  ,w_lingua
                  ,w_voce_menu
              from a_prenotazioni
             where no_prenotazione = prenotazione;
         exception
            when others then
               null;
         end;
      end if;
   
      begin
         select to_date(para.valore, 'DD/MM/YYYY')
           into p_data
           from a_parametri para
          where para.no_prenotazione = prenotazione
            and para.parametro = 'P_RIFERIMENTO';
      exception
         when no_data_found or too_many_rows then
            begin
               select rido.data
                 into p_data
                 from riferimento_dotazione rido
                where utente = w_utente;
            exception
               when no_data_found or too_many_rows then
                  p_data := sysdate;
            end;
      end;
   
      begin
         select substr(para.valore, 1, 1)
           into p_d_f
           from a_parametri para
          where para.no_prenotazione = prenotazione
            and para.parametro = 'P_DF';
      exception
         when no_data_found or too_many_rows then
            p_d_f := 'D';
      end;
   
      begin
         select substr(para.valore, 1, 1)
           into p_nominativa
           from a_parametri para
          where para.no_prenotazione = prenotazione
            and para.parametro = 'P_SE_NOMINATIVA';
      exception
         when no_data_found or too_many_rows then
            p_nominativa := '';
      end;
   
      begin
         select substr(para.valore, 1, 1)
           into p_uso_interno
           from a_parametri para
          where para.no_prenotazione = prenotazione
            and para.parametro = 'P_USO_INTERNO';
      exception
         when no_data_found or too_many_rows then
            p_uso_interno := 'X';
      end;
   
      begin
         select para.valore
           into p_gestione
           from a_parametri para
          where para.no_prenotazione = prenotazione
            and para.parametro = 'P_GESTIONE';
      exception
         when no_data_found or too_many_rows then
            p_gestione := '%';
      end;
   
      begin
         select substr(para.valore, 1, 1)
           into p_revisione
           from a_parametri para
          where para.no_prenotazione = prenotazione
            and para.parametro = 'P_REVISIONE';
      exception
         when no_data_found or too_many_rows then
            --            p_revisione := 16;
            p_revisione := gp4do.get_revisione_a;
      end;
   
      w_prenotazione := prenotazione;
      -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
      calcolo; -- ESECUZIONE DEL CALCOLO POSTI
   
      if w_prenotazione != 0 then
         if substr(errore, 6, 1) = '8' then
            update a_prenotazioni
               set errore = 'P05808'
             where no_prenotazione = w_prenotazione;
         
            commit;
         elsif substr(errore, 6, 1) = '9' then
            update a_prenotazioni
               set errore         = 'P05809'
                  ,prossimo_passo = 91
             where no_prenotazione = w_prenotazione;
         
            commit;
         end if;
      end if;
   exception
      when form_trigger_failure then
         null;
   end;
end;
/
