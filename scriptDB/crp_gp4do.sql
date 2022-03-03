CREATE OR REPLACE package gp4do is
   type ref_cur_non_assegnati is record(
       d_ci        number(8)
      ,d_rilevanza varchar2(1)
      ,d_dal       date
      ,d_al        date
      ,d_settore   varchar2(15)
      ,d_figura    varchar2(8));

   type non_assegnati is ref cursor return ref_cur_non_assegnati;

   procedure get_non_assegnati(c_non_assegnati in out non_assegnati);

   type ref_cur_individui is record(
       d_utente            varchar2(8)
      ,d_revisione         number
      ,d_provenienza       varchar2(1)
      ,d_nominativo        varchar2(120)
      ,d_ci                number(8)
      ,d_dal               date
      ,d_al                date
      ,d_evento            varchar2(6)
      ,d_posizione_ind     varchar2(4)
      ,d_ore_ind           varchar2(5)
      ,d_assenza           varchar2(4)
      ,d_di_ruolo          varchar2(2)
      ,d_incarico          varchar2(1)
      ,d_gestione          varchar2(4)
      ,d_area              varchar2(4)
      ,d_settore           varchar2(15)
      ,d_ruolo             varchar2(4)
      ,d_profilo           varchar2(4)
      ,d_pos_funz          varchar2(4)
      ,d_attivita          varchar2(4)
      ,d_figura            varchar2(8)
      ,d_qualifica         varchar2(8)
      ,d_livello           varchar2(4)
      ,d_tipo_rapporto     varchar2(4)
      ,d_ore               varchar2(5)
      ,d_assunto_part_time varchar2(2));

   type individui is ref cursor return ref_cur_individui;

   procedure get_individui
   (
      p_diritto_fatto     in varchar2
     ,p_gestione          in varchar2
     ,p_utente            in varchar2
     ,p_revisione         in number
     ,p_ore               in varchar2
     ,p_tipo_rapporto     in varchar2
     ,p_qualifica         in varchar2
     ,p_livello           in varchar2
     ,p_figura            in varchar2
     ,p_attivita          in varchar2
     ,p_profilo           in varchar2
     ,p_pos_funz          in varchar2
     ,p_settore           in varchar2
     ,p_area              in varchar2
     ,p_part_time         in varchar2
     ,p_incaricati        in varchar2
     ,p_assenti           in varchar2
     ,p_assenza           in varchar2
     ,p_di_ruolo          in varchar2
     ,p_ruolo             in varchar2
     ,p_posizione         in varchar2
     ,p_livello_struttura in number
     ,c_individui         in out individui
   );

   type ref_cur_dotazione is record(
       utente         varchar2(8)
      ,revisione      number
      ,gestione       varchar2(4)
      ,provenienza    varchar2(1)
      ,door_id        number(10)
      ,posizione_ind  varchar2(4)
      ,ore            varchar2(5)
      ,area           varchar2(4)
      ,settore        varchar2(15)
      ,ruolo          varchar2(4)
      ,profilo        varchar2(4)
      ,posizione      varchar2(4)
      ,attivita       varchar2(4)
      ,figura         varchar2(8)
      ,qualifica      varchar2(8)
      ,livello        varchar2(4)
      ,tipo_rapporto  varchar2(4)
      ,dsp_previsti   number(5, 1)
      ,dsp_ruolo      number(5, 1)
      ,dsp_assenti    number(5, 1)
      ,dsp_incaricati number(5, 1)
      ,dsp_non_ruolo  number(5, 1)
      ,contrattisti   number(5, 1)
      --,part_time        number(5,1)
      ,dsp_servizio number(5, 1)
      ,dsp_num_disp number(5, 1)
      ,dsp_disp_ore number(5, 1)
      ,id           number
      ,sovrannumero number(5, 1));

   type dotazione is ref cursor return ref_cur_dotazione;

   procedure get_dotazione
   (
      p_diritto_fatto     in varchar2
     ,p_gestione          in varchar2
     ,p_utente            in varchar2
     ,p_revisione         in number
     ,p_scostamenti       in varchar2
     ,p_livello_struttura in varchar2
     ,p_modalita          in varchar2
     ,p_id                in number
     ,c_dotazione         in out dotazione
     ,p_area              in varchar2
     ,p_settore           in varchar2
     ,p_ruolo             in varchar2
     ,p_profilo           in varchar2
     ,p_posizione         in varchar2
     ,p_attivita          in varchar2
     ,p_figura            in varchar2
     ,p_qualifica         in varchar2
     ,p_livello           in varchar2
     ,p_tipo_rapporto     in varchar2
     ,p_ore               in varchar2
   );

   function versione return varchar2;

   pragma restrict_references(versione, wnds, wnps);

   function get_nome_responsabile_uo
   (
      p_ni       in number
     ,p_dal_unor in date
     ,p_al       in date
   ) return varchar2;

   pragma restrict_references(get_nome_responsabile_uo, wnds, wnps);

   function get_icona_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2;

   pragma restrict_references(get_icona_sust, wnds, wnps);

   function get_ultimo_sostituto
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return number;

   pragma restrict_references(get_ultimo_sostituto, wnds);

   function get_dal_ultimo_sostituto
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return date;

   pragma restrict_references(get_dal_ultimo_sostituto, wnds);

   function get_al_ultimo_sostituto
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return date;

   pragma restrict_references(get_al_ultimo_sostituto, wnds);

   function get_sostituto
   (
      p_ci  in number
     ,p_dal in date
   ) return number;

   pragma restrict_references(get_sostituto, wnds);

   function get_dal_sostituto
   (
      p_ci  in number
     ,p_dal in date
   ) return date;

   pragma restrict_references(get_dal_sostituto, wnds);

   function get_al_sostituto
   (
      p_ci  in number
     ,p_dal in date
   ) return date;

   pragma restrict_references(get_al_ultimo_sostituto, wnds);

   function get_revisione_m return number;

   pragma restrict_references(get_revisione_m, wnds, wnps);

   function get_revisione_a return number;

   pragma restrict_references(get_revisione_a, wnds, wnps);

   function get_revisione_o return number;

   pragma restrict_references(get_revisione_o, wnds, wnps);

   function get_revisione(p_data in date) return number;

   pragma restrict_references(get_revisione, wnds);

   function get_des_abb_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2;

   pragma restrict_references(get_non_assegnati, wnds, wnps);

   function get_denominazione_livello(p_ni in number) return varchar2;

   pragma restrict_references(get_denominazione_livello, wnds, wnps);

   function get_assenza
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2;

   pragma restrict_references(get_assenza, wnds, wnps);

   function get_ore_sostituibili
   (
      p_ci  in number
     ,p_dal in date
   ) return number;

   pragma restrict_references(get_ore_sostituibili, wnds);

   function get_ore_sostituite
   (
      p_ci   in number
     ,p_dal  in date
     ,p_data in date
   ) return number;

   pragma restrict_references(get_ore_sostituite, wnds, wnps);

   function get_incarico
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2;

   pragma restrict_references(get_incarico, wnds, wnps);

   procedure chk_sostituzioni
   (
      p_ci           in number
     ,p_rilevanza    in varchar2
     ,p_dal          in date
     ,p_al           in date
     ,p_posizione    in varchar2
     ,p_titolare     in number
     ,p_dal_assenza  in date
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure chk_sostituzioni_inc
   (
      p_ci           in number
     ,p_rilevanza    in varchar2
     ,p_dal          in date
     ,p_al           in date
     ,p_posizione    in varchar2
     ,p_sostituto    in number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure chk_numero_dotazione_o
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   );

   procedure chk_numero_dotazione
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   );

   procedure chk_gruppi_linguistici_o
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   );

   procedure chk_gruppi_linguistici
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   );

   procedure valida_revisione
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure duplica_revisione
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure duplica_revisioni
   (
      p_revisione    in number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure acquisisci_revisione_prec
   (
      p_revisione    in number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure set_esaurimento
   (
      p_ci           in number
     ,p_rilevanza    in varchar2
     ,p_dal          in date
     ,p_gestione     in varchar2
     ,p_figura       in number
     ,p_qualifica    in number
     ,p_ore          in number
     ,p_utente       in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure chk_revisione_m
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   procedure chk_revisione_o
   (
      p_revisione    in number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );

   function get_num_esaurimento
   (
      p_revisione in number
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(get_num_esaurimento, wnds, wnps);

   function get_ore_esaurimento
   (
      p_revisione in number
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(get_ore_esaurimento, wnds, wnps);

   function conta_previsti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_tipo          in varchar2
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_previsti_o, wnds, wnps);

   function conta_previsti
   (
      p_revisione in number
     ,p_tipo      in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_previsti, wnds, wnps);

   function conta_dotazione_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dotazione_o, wnds, wnps);

   function conta_dotazione
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dotazione, wnds, wnps);

   function conta_dot_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number;

   pragma restrict_references(conta_dot_struttura, wnps);

   function conta_dot_ore_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number;

   pragma restrict_references(conta_dot_ore_struttura, wnps);

   function conta_dot_ruolo_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number;

   pragma restrict_references(conta_dot_ruolo_struttura, wnps);

   function conta_dot_ore_ruolo_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number;

   pragma restrict_references(conta_dot_ore_ruolo_struttura, wnps);

   function conta_dot_contr_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number;

   pragma restrict_references(conta_dot_contr_struttura, wnps);

   function conta_dot_ore_contr_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number;

   pragma restrict_references(conta_dot_ore_contr_struttura, wnps);

   function conta_dot_ass_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number;

   pragma restrict_references(conta_dot_ass_struttura, wnps);

   function conta_dot_ore_ass_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number;

   pragma restrict_references(conta_dot_ore_ass_struttura, wnps);

   function conta_dot_inc_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number;

   pragma restrict_references(conta_dot_inc_struttura, wnps);

   function conta_dot_ore_inc_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number;

   pragma restrict_references(conta_dot_ore_inc_struttura, wnps);

   function conta_dotazione_ling_o
   (
      p_revisione     in number
     ,p_gruppo_ling   in varchar2
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dotazione_ling_o, wnds, wnps);

   function conta_dotazione_ling
   (
      p_revisione   in number
     ,p_gruppo_ling in varchar2
     ,p_rilevanza   in varchar2
     ,p_data        in date
     ,p_gestione    in varchar2
     ,p_door_id     in number
     ,p_ore_lavoro  in number
   ) return number;

   pragma restrict_references(conta_dotazione_ling, wnds, wnps);

   function conta_dotazione_ling_ruolo_o
   (
      p_revisione     in number
     ,p_gruppo_ling   in varchar2
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dotazione_ling_ruolo_o, wnds, wnps);

   function conta_dotazione_ling_ruolo
   (
      p_revisione   in number
     ,p_gruppo_ling in varchar2
     ,p_rilevanza   in varchar2
     ,p_data        in date
     ,p_gestione    in varchar2
     ,p_door_id     in number
     ,p_ore_lavoro  in number
   ) return number;

   pragma restrict_references(conta_dotazione_ling_ruolo, wnds, wnps);

   function conta_dot_ore_o
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number;

   pragma restrict_references(conta_dot_ore_o, wnps);

   function conta_dot_ore
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_dot_ore, wnds, wnps);

   function conta_dot_ue_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_ue_o, wnds, wnps);

   function conta_dot_ue
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_dot_ue, wnds, wnps);

   function conta_dot_ruolo_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_ruolo_o, wnds, wnps);

   function conta_dot_ruolo
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dot_ruolo, wnds, wnps);

   function conta_dot_non_ruolo_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_non_ruolo_o, wnds, wnps);

   function conta_dot_non_ruolo
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dot_non_ruolo, wnds, wnps);

   function conta_dot_contrattisti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_contrattisti_o, wnds, wnps);

   function conta_dot_sovrannumero_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_sovrannumero_o, wnds, wnps);

   function conta_dot_contrattisti
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dot_contrattisti, wnds, wnps);

   function conta_dot_sovrannumero
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dot_sovrannumero, wnds, wnps);

   function conta_dot_ruolo_ore_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_ruolo_ore_o, wnds, wnps);

   function conta_dot_ruolo_ore
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_dot_ruolo_ore, wnds, wnps);

   function conta_ore_non_ruolo_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_ore_non_ruolo_o, wnds, wnps);

   function conta_ore_non_ruolo
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_ore_non_ruolo, wnds, wnps);

   function conta_ore_contrattisti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_ore_contrattisti_o, wnds, wnps);

   function conta_ore_sovrannumero
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_ore_sovrannumero, wnds, wnps);

   function conta_ore_contrattisti
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_ore_contrattisti, wnds, wnps);

   function conta_dot_assenti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_assenti_o, wnds, wnps);

   function conta_dot_assenti
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dot_assenti, wnds, wnps);

   function conta_dot_sostituiti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_sostituiti_o, wnds, wnps);

   function conta_dot_sostituiti
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dot_sostituiti, wnds, wnps);

   function conta_ore_assenti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_ore_assenti_o, wnds, wnps);

   function conta_ore_assenti
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_ore_assenti, wnds, wnps);

   function conta_dot_incaricati_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_dot_incaricati_o, wnds, wnps);

   function conta_dot_incaricati
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number;

   pragma restrict_references(conta_dot_incaricati, wnds, wnps);

   function conta_ore_incaricati_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number;

   pragma restrict_references(conta_ore_incaricati_o, wnds, wnps);

   function conta_ore_incaricati
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number;

   pragma restrict_references(conta_ore_incaricati, wnds, wnps);

   function get_ore_lavoro_ue
   (
      p_data      in date
     ,p_ruolo     in varchar2
     ,p_profilo   in varchar2
     ,p_posizione in varchar2
     ,p_figura    in varchar2
     ,p_qualifica in varchar2
     ,p_livello   in varchar2
   ) return number;

   pragma restrict_references(get_ore_lavoro_ue, wnds, wnps);

   procedure chk_totale_ripartizione
   (
      p_rigd_id      in number
     ,p_segnalazione out varchar2
   );

   cursor cur_dotazione(p_diritto_fatto in varchar2, p_gestione in varchar2, p_utente in varchar2, p_revisione in number, p_ore_do in varchar2) is
      select rido.utente
            ,door.revisione
            ,door.gestione
            ,'D'
            ,door.door_id
            ,to_char(null)
            ,door.ore
            ,door.area
            ,door.settore
            ,door.ruolo
            ,door.profilo
            ,door.posizione
            ,door.attivita
            ,door.figura
            ,door.qualifica
            ,door.livello
            ,door.tipo_rapporto
            ,door.numero
            ,decode(p_ore_do
                   ,'U'
                   ,round(gp4do.conta_dot_ruolo_ore(door.revisione
                                                   ,p_diritto_fatto
                                                   ,rido.data
                                                   ,door.gestione
                                                   ,door.door_id
                                                   ,gp4do.get_ore_lavoro_ue(rido.data
                                                                           ,door.ruolo
                                                                           ,door.profilo
                                                                           ,door.posizione
                                                                           ,door.figura
                                                                           ,door.qualifica
                                                                           ,door.livello))
                         ,1)
                   ,gp4do.conta_dot_ruolo(door.revisione
                                         ,p_diritto_fatto
                                         ,rido.data
                                         ,door.gestione
                                         ,door.door_id)) di_ruolo
            ,decode(p_ore_do
                   ,'U'
                   ,round(gp4do.conta_ore_assenti(door.revisione
                                                 ,p_diritto_fatto
                                                 ,rido.data
                                                 ,door.gestione
                                                 ,door.door_id
                                                 ,gp4do.get_ore_lavoro_ue(rido.data
                                                                         ,door.ruolo
                                                                         ,door.profilo
                                                                         ,door.posizione
                                                                         ,door.figura
                                                                         ,door.qualifica
                                                                         ,door.livello))
                         ,1)
                   ,gp4do.conta_dot_assenti(door.revisione
                                           ,p_diritto_fatto
                                           ,rido.data
                                           ,door.gestione
                                           ,door.door_id)) assenti
            ,decode(p_ore_do
                   ,'U'
                   ,round(gp4do.conta_ore_incaricati(door.revisione
                                                    ,p_diritto_fatto
                                                    ,rido.data
                                                    ,door.gestione
                                                    ,door.door_id
                                                    ,gp4do.get_ore_lavoro_ue(rido.data
                                                                            ,door.ruolo
                                                                            ,door.profilo
                                                                            ,door.posizione
                                                                            ,door.figura
                                                                            ,door.qualifica
                                                                            ,door.livello))
                         ,1)
                   ,gp4do.conta_dot_incaricati(door.revisione
                                              ,p_diritto_fatto
                                              ,rido.data
                                              ,door.gestione
                                              ,door.door_id)) incaricati
            ,decode(p_ore_do
                   ,'U'
                   ,round(gp4do.conta_ore_non_ruolo(door.revisione
                                                   ,p_diritto_fatto
                                                   ,rido.data
                                                   ,door.gestione
                                                   ,door.door_id
                                                   ,gp4do.get_ore_lavoro_ue(rido.data
                                                                           ,door.ruolo
                                                                           ,door.profilo
                                                                           ,door.posizione
                                                                           ,door.figura
                                                                           ,door.qualifica
                                                                           ,door.livello))
                         ,1)
                   ,gp4do.conta_dot_non_ruolo(door.revisione
                                             ,p_diritto_fatto
                                             ,rido.data
                                             ,door.gestione
                                             ,door.door_id)) non_ruolo
            ,decode(p_ore_do
                   ,'U'
                   ,round(gp4do.conta_ore_contrattisti(door.revisione
                                                      ,p_diritto_fatto
                                                      ,rido.data
                                                      ,door.gestione
                                                      ,door.door_id
                                                      ,gp4do.get_ore_lavoro_ue(rido.data
                                                                              ,door.ruolo
                                                                              ,door.profilo
                                                                              ,door.posizione
                                                                              ,door.figura
                                                                              ,door.qualifica
                                                                              ,door.livello))
                         ,1)
                   ,gp4do.conta_dot_contrattisti(door.revisione
                                                ,p_diritto_fatto
                                                ,rido.data
                                                ,door.gestione
                                                ,door.door_id)) contrattisti
            ,decode(p_ore_do
                   ,'U'
                   ,round(gp4do.conta_dot_ore(door.revisione
                                             ,p_diritto_fatto
                                             ,rido.data
                                             ,door.gestione
                                             ,door.door_id
                                             ,gp4do.get_ore_lavoro_ue(rido.data
                                                                     ,door.ruolo
                                                                     ,door.profilo
                                                                     ,door.posizione
                                                                     ,door.figura
                                                                     ,door.qualifica
                                                                     ,door.livello))
                         ,1)
                   ,gp4do.conta_dotazione(door.revisione
                                         ,p_diritto_fatto
                                         ,rido.data
                                         ,door.gestione
                                         ,door.door_id)) effettivi
            ,gp4do.conta_dotazione(door.revisione
                                  ,p_diritto_fatto
                                  ,rido.data
                                  ,door.gestione
                                  ,door.door_id) - door.numero diff_numero
            ,round(gp4do.conta_dot_ore(revisione
                                      ,p_diritto_fatto
                                      ,rido.data
                                      ,door.gestione
                                      ,door.door_id
                                      ,gp4do.get_ore_lavoro_ue(rido.data
                                                              ,door.ruolo
                                                              ,door.profilo
                                                              ,door.posizione
                                                              ,door.figura
                                                              ,door.qualifica
                                                              ,door.livello)) -
                   door.numero_ore
                  ,2) diff_ore
        from dotazione_organica    door
            ,riferimento_dotazione rido
       where door.revisione = p_revisione
         and rido.utente = p_utente
         and door.gestione like p_gestione
      union
      select rido.utente
            ,pedo.revisione
            ,pedo.gestione
            ,'G'
            ,0
            ,to_char(null)
            ,pedo.ore
            ,to_char(null) area
            ,pedo.codice_uo
            ,pedo.ruolo
            ,pedo.profilo
            ,pedo.pos_funz
            ,pedo.attivita
            ,pedo.cod_figura
            ,pedo.cod_qualifica
            ,pedo.livello
            ,pedo.tipo_rapporto
            ,count(ci)
            ,sum(decode(pedo.di_ruolo, 'SI', 1, 0)) di_ruolo
            ,sum(gp4gm.get_se_assente(pedo.ci, rido.data)) assenti
            ,sum(gp4gm.get_se_incaricato(pedo.ci, rido.data)) incaricati
            ,sum(decode(pedo.di_ruolo, 'NO', 1, 0)) non_ruolo
            ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione), 'SI', 1, 0)) contrattisti
            ,count(ci) effettivi
            ,count(ci) diff_numero
            ,sum(pedo.ore) diff_ore
        from periodi_dotazione     pedo
            ,riferimento_dotazione rido
       where pedo.rilevanza = p_diritto_fatto
         and rido.data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
         and rido.utente = p_utente
         and pedo.revisione = p_revisione
         and pedo.gestione = p_gestione
         and pedo.door_id = 0
       group by rido.utente
               ,rido.data
               ,pedo.revisione
               ,pedo.gestione
               ,pedo.codice_uo
               ,pedo.ruolo
               ,pedo.profilo
               ,pedo.pos_funz
               ,pedo.attivita
               ,pedo.cod_figura
               ,pedo.cod_qualifica
               ,pedo.livello
               ,pedo.tipo_rapporto
               ,pedo.ore;
   /******************************************************************************
      NAME:       GP4DO
      PURPOSE:    Contiene tutti gli oggetti PL/SQL del Modulo Dotazione Organica
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        19/07/2002                   Created this package.
      2.0        29/01/2004                   Modifica alle funzioni di calcolo di dotazione
      3.0        07/06/2004                   Modifiche per personalizzazioni Alto Adige
      4.0        24/01/2005                   Nuove modalita di calcolo della dotazione (introduzione di PEDO)
      4.1        29/03/2005                   Correzioni da test per Reggio (Att.10364.5)
      4.2        29/03/2005                   Correzioni da test per Reggio (Att.10421.6)
      4.3        05/04/2005                   Attivita 10420
      4.4        06/04/2005                   Attivita 10421.2 , 10553.3
      4.5        31/08/2005 MS                Modifica per compilazioni in Ora8
      4.6        07/10/2005 MS                Attivita 12876
      4.7        02/11/2005 MM                Attivita 13003 -- Creazione di revisioni di dotazione gia obsolete
      4.8        04/01/2006 MM                Attivita 10866.4 - 10421.5
      4.9        12/04/2006 MM                Attivita 15389 - 13631
      5.0        18/05/2006 MM                Attivita 16256
      5.1        27/12/2006 MM                Attivita 16525 
                                              Pulizia generale delle variabili inutilizzate
                                              Eliminata la funzione GET_RESPONSABILE
      5.2        29/01/2007 MM                Att. 15533                                                                                                                               
   ******************************************************************************/
end gp4do;
/
CREATE OR REPLACE package body gp4do as
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
      return 'V5.3  del   29/07/2007';
   end versione;

   --
   function get_denominazione_livello(p_ni in number) return varchar2 is
      d_den_livello varchar2(60);
      /******************************************************************************
         NAME:       GET_DENOMINAZIONE_LIVELLO
         PURPOSE:    Restituire la denominazione del livello dell'U.O.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        24/07/2002
      ******************************************************************************/
   begin
      begin
         select denominazione
           into d_den_livello
           from suddivisioni_struttura sust
               ,unita_organizzative    unor
          where sust.ottica = unor.ottica
            and unor.suddivisione = sust.livello
            and unor.tipo = 'P'
            and unor.ottica = 'GP4'
            and unor.dal = gp4_unor.get_dal(unor.ni)
            and unor.ni = p_ni;
      exception
         when no_data_found then
            d_den_livello := to_char(null);
            return d_den_livello;
         when too_many_rows then
            d_den_livello := to_char(null);
            return d_den_livello;
      end;
   
      return d_den_livello;
   end get_denominazione_livello;

   --
   function get_assenza
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2 is
      d_assenza periodi_giuridici.assenza%type;
      /******************************************************************************
         NAME:       GET_ASSENZA
         PURPOSE:    Restituire il codice dell'eventuale assenza sostituibile dell'individuo
                     ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        24/07/2002
      ******************************************************************************/
   begin
      d_assenza := to_char(null);
   
      begin
         select assenza
           into d_assenza
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and rilevanza = 'A'
            and exists (select 'x'
                   from astensioni
                  where codice = pegi.assenza
                    and sostituibile = 1);
      exception
         when no_data_found then
            d_assenza := to_char(null);
            return d_assenza;
      end;
   
      return d_assenza;
   end get_assenza;

   --
   function get_ore_sostituibili
   (
      p_ci  in number
     ,p_dal in date
   ) return number is
      d_ore_lavoro       contratti_storici.ore_lavoro%type;
      d_ore_sostituibili periodi_giuridici.ore%type;
      d_perc_assenza     periodi_giuridici.ore%type;
      d_ore_lavorate     periodi_giuridici.ore%type;
      /******************************************************************************
         NAME:       GET_ORE_SOSTITUIBILI
         PURPOSE:    Restituire il numero di ore effettivamente sostituibili del periodo
                     di astensione indicato
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        11/02/2004                   Created this function.
         1.1        05/04/2005               Attivita 10420
      ******************************************************************************/
   begin
      d_ore_sostituibili := to_number(null);
      /* Determino le ore lavorate contrattuali */
      d_ore_lavoro := gp4_cost.get_ore_lavoro(gp4_pegi.get_qualifica(p_ci, 'S', p_dal)
                                             ,p_dal);
      /* Determino le ore lavorate dall'individuo */
      d_ore_lavorate := nvl(gp4_pegi.get_ore(p_ci, 'Q', p_dal), d_ore_lavoro);
      /* Determino la percentuale di assenza del periodo */
      d_perc_assenza := nvl(gp4_pegi.get_ore(p_ci, 'A', p_dal), 100);
   
      /* Determino le ore effettivamente sostituibili nel periodo */
      select decode(sign(d_ore_lavorate - round(d_ore_lavoro * d_perc_assenza / 100, 2))
                   ,-1
                   ,d_ore_lavorate
                   ,d_ore_lavorate -
                    (d_ore_lavoro - round(d_ore_lavoro * d_perc_assenza / 100, 2)))
        into d_ore_sostituibili
        from dual;
   
      return d_ore_sostituibili;
   end get_ore_sostituibili;

   --
   function get_ore_sostituite
   (
      p_ci   in number
     ,p_dal  in date
     ,p_data in date
   ) return number is
      d_ore_sostituite periodi_giuridici.ore%type;
      /******************************************************************************
         NAME:       GET_ORE_SOSTITUITE
         PURPOSE:    Restituire il numero di ore gia sostituite per il periodo
                     di astensione indicato ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        11/02/2004
      ******************************************************************************/
   begin
      d_ore_sostituite := 0;
   
      select nvl(sum(sogi.ore_sostituzione), 0)
        into d_ore_sostituite
        from sostituzioni_giuridiche sogi
       where sogi.titolare = p_ci
         and sogi.dal_astensione = p_dal
         and p_data between sogi.dal and nvl(sogi.al, to_date(3333333, 'j'));
   
      return d_ore_sostituite;
   end get_ore_sostituite;

   --
   function get_incarico
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2 is
      d_incarico periodi_giuridici.evento%type;
      /******************************************************************************
         NAME:       GET_incarico
         PURPOSE:    Restituire il codice dell'evento del periodi di incarico dell'individuo
                     ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        24/07/2002
      ******************************************************************************/
   begin
      d_incarico := to_char(null);
   
      begin
         select evento
           into d_incarico
           from periodi_giuridici pegi
          where ci = p_ci
            and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
            and rilevanza = 'I';
      exception
         when no_data_found then
            d_incarico := to_char(null);
            return d_incarico;
      end;
   
      return d_incarico;
   end get_incarico;

   --
   function get_nome_responsabile_uo
   (
      p_ni       in number
     ,p_dal_unor in date
     ,p_al       in date
   ) return varchar2 is
      d_responsabile varchar2(80);
      /******************************************************************************
         NAME:       GET_NOME_RESPONSABILE_UO
         PURPOSE:    Restituisce cognome e nome del responsabile della UO (identificata dall'NI)
                     ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      select anag.cognome || '  ' || anag.nome
        into d_responsabile
        from anagrafe anag
       where ni = (select ni
                     from componenti comp
                    where comp.unita_ni = p_ni
                      and comp.unita_ottica = 'GP4'
                      and comp.unita_dal = p_dal_unor
                      and comp.dal = (select max(dal)
                                        from componenti
                                       where unita_ni = p_ni
                                         and unita_ottica = 'GP4'
                                         and unita_dal = p_dal_unor
                                         and componente = comp.componente)
                      and exists (select 'x'
                             from tipi_incarico
                            where incarico = comp.incarico
                              and responsabile = 'SI'));
   
      return d_responsabile;
   exception
      when no_data_found then
         d_responsabile := to_char(null);
         return d_responsabile;
      when others then
         d_responsabile := to_char(null);
         return d_responsabile;
   end get_nome_responsabile_uo;

   --
   function get_des_abb_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2 is
      d_des_abb suddivisioni_struttura.des_abb%type;
      /******************************************************************************
         NAME:       GET_DES_ABB_SUST
         PURPOSE:    Fornire ila descrizione abbreviata di uu livello di suddivisione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_des_abb := to_char(null);
   
      begin
         select des_abb
           into d_des_abb
           from suddivisioni_struttura
          where ottica = p_ottica
            and livello = p_livello;
      exception
         when no_data_found then
            begin
               d_des_abb := to_char(null);
            end;
         when too_many_rows then
            begin
               d_des_abb := to_char(null);
            end;
      end;
   
      return d_des_abb;
   end get_des_abb_sust;

   --
   procedure chk_numero_dotazione
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_NUMERO_DOTAZIONE
         PURPOSE:    Controlla la consistenza della dotazione organica effettiva rispetto
                     a quella teorica a fronte di una variazione su PERIODI_GIURIDICI.
                     Controllo sul numero dei dipendenti e sul numero delle ore prestate.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/09/2004
         2.0        24/01/2005               Nuova versione velocizzata basata su PEDO
                                                 e DOOR_ID
      
      ******************************************************************************/
      d_settore           settori_amministrativi.codice%type;
      d_area              aree.area%type;
      d_ruolo             ruoli.codice%type;
      d_profilo           profili_professionali.codice%type;
      d_posizione         posizioni_funzionali.codice%type;
      d_figura            figure_giuridiche.codice%type;
      d_qualifica         qualifiche_giuridiche.codice%type;
      d_livello           qualifiche_giuridiche.livello%type;
      d_numero            dotazione_organica.numero_ore%type;
      d_numero_ore        dotazione_organica.numero_ore%type;
      d_gestione          dotazione_organica.gestione%type;
      d_attivita          dotazione_organica.attivita%type;
      d_tipo_rapporto     dotazione_organica.tipo_rapporto%type;
      d_ore               dotazione_organica.ore%type;
      d_door_id_pedo_prec dotazione_organica.door_id%type;
      d_door_id_pedo      dotazione_organica.door_id%type;
      d_revisione         number(8);
      d_effettivi         number;
      d_ore_effettive     number;
      d_ore_assenti       number;
      d_mess_assenti      varchar2(250);
      d_tipo              varchar2(1);
      -- N=numero individui; O=numero ore
      d_ore_do     varchar2(1);
      d_ore_lavoro number;
      situazione_anomala exception;
   begin
      p_errore    := null;
      d_area      := to_char(null);
      d_settore   := gp4_stam.get_codice(gp4_stam.get_ni_numero(p_settore));
      d_ruolo     := gp4_qugi.get_ruolo(nvl(p_qualifica
                                           ,gp4_figi.get_qualifica(p_figura, p_dal))
                                       ,p_dal);
      d_profilo   := gp4_figi.get_profilo(p_figura, p_dal);
      d_posizione := gp4_figi.get_posizione(p_figura, p_dal);
      d_figura    := gp4_figi.get_codice(p_figura, p_dal);
      d_qualifica := gp4_qugi.get_codice(nvl(p_qualifica
                                            ,gp4_figi.get_qualifica(p_figura, p_dal))
                                        ,p_dal);
      d_livello   := gp4_qugi.get_livello(nvl(p_qualifica
                                             ,gp4_figi.get_qualifica(p_figura, p_dal))
                                         ,p_dal);
      /* Determino i gruppi di dotazione interessati dalla modifica */
      d_revisione := gp4_redo.get_revisione(p_dal);
   
      begin
         select door_id
               ,door_id_prec
           into d_door_id_pedo
               ,d_door_id_pedo_prec
           from periodi_dotazione
          where ci = p_ci
            and rilevanza = p_rilevanza
            and p_dal between dal and nvl(al, to_date(3333333, 'j'))
            and revisione = d_revisione;
      exception
         when no_data_found then
            p_segnalazione := 'Controlli sulla Dotazione Organica non eseguibili. Le caratteristiche giuridiche dell''individuo non sono previste';
            raise situazione_anomala;
         when too_many_rows then
            p_segnalazione := 'Controlli sulla Dotazione Organica non eseguibili. Le caratteristiche giuridiche dell''individuo non sono previste';
            raise situazione_anomala;
      end;
   
      p_scostamento  := 0;
      d_mess_assenti := ' ';
   
      /* Esegue il controllo del numero degli effettivi per tutte le date di variazione
         del giuridico comprese nel periodo di PEGI da controllare
      */
      for chk in (select distinct dal     data
                                 ,door_id door_id
                    from periodi_dotazione
                   where rilevanza = p_rilevanza
                     and dal between p_dal and nvl(p_al, to_date(3333333, 'j'))
                     and door_id in (d_door_id_pedo, d_door_id_pedo_prec)
                     and door_id != 0
                  union
                  select distinct nvl(al, to_date(3333333, 'j')) data
                                 ,door_id door_id
                    from periodi_dotazione
                   where rilevanza = p_rilevanza
                     and nvl(al, to_date(3333333, 'j')) between p_dal and
                         nvl(p_al, to_date(3333333, 'j'))
                     and door_id in (d_door_id_pedo, d_door_id_pedo_prec)
                     and door_id != 0
                   order by 1)
      loop
         begin
            /* Determino la revisione di dotazione valida alla data di controllo */
            d_revisione := gp4_redo.get_revisione(chk.data);
         
            /* Seleziono le caratteristiche del gruppo di dotazione dell'individuo alla data di controllo,
            determinando anche i valori teorici */
            begin
               select gestione
                     ,area
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
                 into d_gestione
                     ,d_area
                     ,d_settore
                     ,d_ruolo
                     ,d_profilo
                     ,d_posizione
                     ,d_attivita
                     ,d_figura
                     ,d_qualifica
                     ,d_livello
                     ,d_tipo_rapporto
                     ,d_ore
                     ,d_numero
                     ,d_numero_ore
                 from dotazione_organica
                where door_id = chk.door_id
                  and revisione = d_revisione;
            exception
               when no_data_found then
                  p_segnalazione := 'Controlli sulla Dotazione Organica non eseguibili. Le caratteristiche giuridiche dell''individuo non sono previste';
                  raise situazione_anomala;
            end;
         
            /*  Determino quale tipo di controllo eseguire sulla dotazione teorica */
            if nvl(d_numero, 0) = 0 then
               d_tipo := 'O'; -- controllo a ore o U.E.
            else
               d_tipo := 'N'; -- controllo a numero
            end if;
         
            /* Determino il numero degli individui effettivamente in servizio */
            if d_tipo = 'N' then
               d_effettivi := conta_dotazione(d_revisione
                                             ,p_rilevanza
                                             ,chk.data
                                             ,p_gestione
                                             ,chk.door_id) -
                              conta_dot_sovrannumero(d_revisione
                                                    ,p_rilevanza
                                                    ,chk.data
                                                    ,p_gestione
                                                    ,chk.door_id);
               p_assenti   := nvl(conta_dot_assenti(d_revisione
                                                   ,p_rilevanza
                                                   ,chk.data
                                                   ,d_gestione
                                                   ,chk.door_id)
                                 ,0) + nvl(conta_dot_incaricati(d_revisione
                                                               ,p_rilevanza
                                                               ,chk.data
                                                               ,d_gestione
                                                               ,chk.door_id)
                                          ,0); -- Totale numero assenti
            elsif d_tipo = 'O' then
               d_ore_do := gp4_gest.get_ore_do(p_gestione);
            
               if d_ore_do = 'U' then
                  d_ore_lavoro := get_ore_lavoro_ue(chk.data
                                                   ,d_ruolo
                                                   ,d_profilo
                                                   ,d_posizione
                                                   ,d_figura
                                                   ,d_qualifica
                                                   ,d_livello);
               
                  if nvl(d_ore_lavoro, 0) = 0 then
                     raise situazione_anomala;
                  end if;
               end if;
            
               d_ore_effettive := conta_dot_ore(d_revisione
                                               ,p_rilevanza
                                               ,chk.data
                                               ,p_gestione
                                               ,chk.door_id
                                               ,d_ore_lavoro) -
                                  conta_ore_sovrannumero(d_revisione
                                                        ,p_rilevanza
                                                        ,chk.data
                                                        ,p_gestione
                                                        ,chk.door_id
                                                        ,d_ore_lavoro);
               d_ore_assenti   := nvl(conta_ore_assenti(d_revisione
                                                       ,p_rilevanza
                                                       ,chk.data
                                                       ,p_gestione
                                                       ,chk.door_id
                                                       ,d_ore_lavoro)
                                     ,0) + nvl(conta_ore_incaricati(d_revisione
                                                                   ,p_rilevanza
                                                                   ,chk.data
                                                                   ,p_gestione
                                                                   ,chk.door_id
                                                                   ,d_ore_lavoro)
                                              ,0); -- Totale numero ore assenti
            end if;
         
            if d_tipo = 'N' then
               if p_assenti = 1 then
                  d_mess_assenti := ', di cui ' || p_assenti ||
                                    ' assente di ruolo o incaricato.';
               elsif p_assenti > 1 then
                  d_mess_assenti := ', di cui ' || p_assenti ||
                                    ' assenti di ruolo o incaricati.';
               end if;
            
               p_scostamento := nvl(d_effettivi, 0) - nvl(d_numero, 0);
            elsif d_tipo = 'O' then
               if d_ore_assenti > 0 then
                  d_mess_assenti := ', di cui ' || d_ore_assenti ||
                                    ' di individui assenti di ruolo o incaricati.';
               end if;
            
               p_scostamento := nvl(d_ore_effettive, 0) - nvl(d_numero_ore, 0);
            end if;
         
            if p_scostamento > 0 then
               select decode(d_tipo, 'N', 'P08027', 'O', 'P08028')
                 into p_errore
                 from dual; -- esubero
            
               p_segnalazione := si4.get_error(p_errore) || ' dalla data: ' ||
                                 to_char(chk.data, 'dd/mm/yyyy') || '; Eccedenza : ' ||
                                 p_scostamento || d_mess_assenti;
               raise situazione_anomala;
            elsif p_scostamento < 0 then
               select decode(d_tipo, 'N', 'P08029', 'O', 'P08030')
                 into p_errore
                 from dual; -- carenza
            
               p_segnalazione := si4.get_error(p_errore) || ' dalla data: ' ||
                                 to_char(chk.data, 'dd/mm/yyyy') || '; Carenza : ' ||
                                 p_scostamento || d_mess_assenti;
               raise situazione_anomala;
            end if;
         end;
      end loop;
   exception
      when situazione_anomala then
         null;
   end chk_numero_dotazione;

   --
   function get_icona_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2 is
      d_nome_icona suddivisioni_struttura.icona%type;
      /******************************************************************************
         NAME:       GET_ICONA_SUST
         PURPOSE:    Fornire il nome del file dell'icona di un livello di suddivisione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002                      1. Created this function.
      ******************************************************************************/
   begin
      d_nome_icona := 'XXXXXXXXXXXXXX';
   
      begin
         select icona
           into d_nome_icona
           from suddivisioni_struttura
          where ottica = p_ottica
            and livello = p_livello;
      exception
         when no_data_found then
            begin
               d_nome_icona := to_char(null);
            end;
         when too_many_rows then
            begin
               d_nome_icona := to_char(null);
            end;
      end;
   
      return d_nome_icona;
   end get_icona_sust;

   --
   function get_ultimo_sostituto
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return number is
      d_sostituto periodi_giuridici.sostituto%type;
      /******************************************************************************
         NAME:       GET_ULTIMO_SOSTITUTO
         PURPOSE:    Fornire il ci dell'eventuale ultimo sostituto di un determinato
                     periodo di assenza del titolare
                  (ultimo periodo di inquadramento che interseca il periodo di assenza)
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002                   1. Created this function.
      ******************************************************************************/
   begin
      d_sostituto := to_number(null);
   
      begin
         select pegi.ci
           into d_sostituto
           from periodi_giuridici pegi
          where pegi.rilevanza = 'Q'
            and pegi.sostituto = p_ci
            and p_dal <= nvl(pegi.al, to_date(3333333, 'j'))
            and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal
            and dal = (select max(dal)
                         from periodi_giuridici
                        where rilevanza = 'Q'
                          and ci = pegi.ci
                          and p_dal <= nvl(pegi.al, to_date(3333333, 'j'))
                          and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal);
      exception
         when no_data_found then
            d_sostituto := to_number(null);
         when too_many_rows then
            begin
               d_sostituto := to_number(null);
            end;
      end;
   
      return d_sostituto;
   end get_ultimo_sostituto;

   --
   function get_dal_ultimo_sostituto
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return date is
      d_dal periodi_giuridici.dal%type := to_date(null);
      /******************************************************************************
         NAME:       GET_DAL_ULTIMO_SOSTITUTO
         PURPOSE:    Fornire la data di inizio dell'eventuale ultimo sostituto di un determinato
                     periodo di assenza del titolare
                     (ultimo periodo di inquadramento che interseca il periodo di assenza)
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002                 1. Created this function.
      ******************************************************************************/
   begin
      begin
         select pegi.dal
           into d_dal
           from periodi_giuridici pegi
          where pegi.rilevanza = 'Q'
            and pegi.sostituto = p_ci
            and p_dal <= nvl(pegi.al, to_date(3333333, 'j'))
            and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal
            and dal = (select max(dal)
                         from periodi_giuridici
                        where rilevanza = 'Q'
                          and ci = pegi.ci
                          and p_dal <= nvl(pegi.al, to_date(3333333, 'j'))
                          and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal);
      exception
         when no_data_found then
            d_dal := to_date(null);
         when too_many_rows then
            begin
               d_dal := to_date(null);
            end;
      end;
   
      return d_dal;
   end get_dal_ultimo_sostituto;

   --
   function get_al_ultimo_sostituto
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return date is
      d_al periodi_giuridici.dal%type;
      /******************************************************************************
         NAME:       GET_AL_ULTIMO_SOSTITUTO
         PURPOSE:    Fornire la data di termine dell'eventuale ultimo sostituto di un determinato
                     periodo di assenza del titolare
                      (ultimo periodo di inquadramento che interseca il periodo di assenza)
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_al := to_date(null);
   
      begin
         select pegi.al
           into d_al
           from periodi_giuridici pegi
          where pegi.rilevanza = 'Q'
            and pegi.sostituto = p_ci
            and p_dal <= nvl(pegi.al, to_date(3333333, 'j'))
            and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal
            and dal = (select max(dal)
                         from periodi_giuridici
                        where rilevanza = 'Q'
                          and ci = pegi.ci
                          and p_dal <= nvl(pegi.al, to_date(3333333, 'j'))
                          and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal);
      exception
         when no_data_found then
            d_al := to_date(null);
         when too_many_rows then
            begin
               d_al := to_date(null);
            end;
      end;
   
      return d_al;
   end get_al_ultimo_sostituto;

   --
   function get_sostituto
   (
      p_ci  in number
     ,p_dal in date
   ) return number is
      d_sostituto periodi_giuridici.sostituto%type;
      /******************************************************************************
         NAME:       GET_SOSTITUTO
         PURPOSE:    Fornire il CI dell'eventuale sostituto dati CI del titolare e DATA
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002                 1. Created this function.
      ******************************************************************************/
   begin
      d_sostituto := to_number(null);
   
      begin
         select pegi.ci
           into d_sostituto
           from periodi_giuridici pegi
          where pegi.rilevanza = 'Q'
            and pegi.sostituto = p_ci
            and p_dal between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_sostituto := to_number(null);
         when too_many_rows then
            begin
               d_sostituto := to_number(null);
            end;
      end;
   
      return d_sostituto;
   end get_sostituto;

   --
   function get_dal_sostituto
   (
      p_ci  in number
     ,p_dal in date
   ) return date is
      d_dal periodi_giuridici.dal%type;
      /******************************************************************************
         NAME:       GET_DAL_SOSTITUTO
         PURPOSE:    Fornire l'inizio del periodo dell'eventuale sostituto dati CI e DATA
                     del dipendente di ruolo
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002                   1. Created this function.
      ******************************************************************************/
   begin
      d_dal := to_date(null);
   
      begin
         select pegi.dal
           into d_dal
           from periodi_giuridici pegi
          where pegi.rilevanza = 'Q'
            and pegi.sostituto = p_ci
            and p_dal between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_dal := to_date(null);
         when too_many_rows then
            begin
               d_dal := to_date(null);
            end;
      end;
   
      return d_dal;
   end get_dal_sostituto;

   --
   function get_al_sostituto
   (
      p_ci  in number
     ,p_dal in date
   ) return date is
      d_al periodi_giuridici.dal%type;
      /******************************************************************************
         NAME:       GET_AL_SOSTITUTO
         PURPOSE:    Fornire la fine del periodo dell'eventuale sostituto dati CI e DATA
                     del dipendente di ruolo
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002                     1. Created this function.
      ******************************************************************************/
   begin
      d_al := to_date(null);
   
      begin
         select pegi.al
           into d_al
           from periodi_giuridici pegi
          where pegi.rilevanza = 'Q'
            and pegi.sostituto = p_ci
            and p_dal between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_al := to_date(null);
         when too_many_rows then
            begin
               d_al := to_date(null);
            end;
      end;
   
      return d_al;
   end get_al_sostituto;

   --
   function get_revisione_m return number is
      d_revisione revisioni_dotazione.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE_M
         PURPOSE:    Fornire il codice della revisione in modifica
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002                      1. Created this function.
      ******************************************************************************/
   begin
      d_revisione := 0;
   
      begin
         select revisione into d_revisione from revisioni_dotazione where stato = 'M';
      exception
         when no_data_found then
            begin
               d_revisione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_char(null);
            end;
      end;
   
      return d_revisione;
   end get_revisione_m;

   --
   function get_revisione_a return number is
      d_revisione revisioni_dotazione.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE_A
         PURPOSE:    Fornire il codice della revisione attiva
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002                    1. Created this function.
      ******************************************************************************/
   begin
      d_revisione := 0;
   
      begin
         select revisione into d_revisione from revisioni_dotazione where stato = 'A';
      exception
         when no_data_found then
            begin
               d_revisione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_char(null);
            end;
      end;
   
      return d_revisione;
   end get_revisione_a;

   function get_revisione_o return number is
      d_revisione revisioni_dotazione.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE_A
         PURPOSE:    Fornire il codice dell'ultima revisione obsoleta prima di quella attiva
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002                   1. Created this function.
      ******************************************************************************/
   begin
      d_revisione := 0;
   
      begin
         select revisione
           into d_revisione
           from revisioni_dotazione
          where stato = 'O'
            and dal = (select max(dal) from revisioni_dotazione where stato = 'O');
      exception
         when no_data_found then
            begin
               d_revisione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_char(null);
            end;
      end;
   
      return d_revisione;
   end get_revisione_o;

   --
   function get_revisione(p_data in date) return number is
      d_revisione revisioni_dotazione.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE
         PURPOSE:    Fornire il codice della revisione valida alla data indicata
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        25/11/2002                   1. Created this function.
      ******************************************************************************/
   begin
      d_revisione := 0;
   
      begin
         select revisione
           into d_revisione
           from revisioni_dotazione
          where dal = (select max(dal) from revisioni_dotazione where dal <= p_data);
      exception
         when no_data_found then
            begin
               d_revisione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_char(null);
            end;
      end;
   
      return d_revisione;
   end get_revisione;

   --
   procedure valida_revisione
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       VALIDA_REVISIONE
         PURPOSE:    Attiva la revisione in modifica
                     Rende obsoleta la revisione attiva al momento
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002                 1. Created this function.
      ******************************************************************************/
      d_revisione_m number(8);
      d_revisione_a number(8);
      d_dal_m       date;
      situazione_anomala exception;
   begin
      p_errore      := null;
      d_revisione_m := get_revisione_m;
      d_revisione_a := get_revisione_a;
      d_dal_m       := gp4_redo.get_dal_redo_modifica;
   
      if d_revisione_m is null then
         p_errore := 'P08005';
         raise situazione_anomala;
      end if;
   
      /* Elimina le registrazioni relative a posti ad esaurimento
      riferiti alla revisione attiva */
      delete from dotazione_esaurimento
       where revisione = d_revisione_a
         and nvl(data_cessazione, to_date(2222222, 'j')) >= d_dal_m;
   
      /* Cambia a Obsoleto lo stato della revisione attiva */
      if d_revisione_a is not null then
         update revisioni_dotazione
            set stato = 'O'
          where stato = 'A'
            and revisione = d_revisione_a;
      end if;
   
      /* Cambia a Attivo lo stato della revisione in modifica */
      update revisioni_dotazione
         set stato = 'A'
       where stato = 'M'
         and revisione = d_revisione_m;
      /* Allinea PERIODI_DOTAZIONE alla nuova revisione
      La modifica a PEGI, provoca, tramite il trigger
      PEGI_PEDO_TMA, l'allineamento di PEDO */
      --   update periodi_giuridici
      --      set ci = ci
      --    where nvl(al,to_date(3333333,'j')) >= d_dal_m
      --      and rilevanza in ('Q','S','I','E')
      --   ;
   exception
      when situazione_anomala then
         rollback;
   end valida_revisione;

   --
   procedure chk_numero_dotazione_o
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_NUMERO_DOTAZIONE
         PURPOSE:    Controlla la consistenza della dotazione organica effettiva rispetto
                     a quella teorica a fronte di una variazione su PERIODI_GIURIDICI.
                     Controllo sul numero dei dipendentie sul numero delle ore prestate.
                  Questa versione non utilizza il door_id della tabella PERIODI_DOTAZIONE.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002                 1. Created this function.
      ******************************************************************************/
      d_settore       settori_amministrativi.codice%type;
      d_area          aree.area%type;
      d_ruolo         ruoli.codice%type;
      d_profilo       profili_professionali.codice%type;
      d_posizione     posizioni_funzionali.codice%type;
      d_figura        figure_giuridiche.codice%type;
      d_qualifica     qualifiche_giuridiche.codice%type;
      d_livello       qualifiche_giuridiche.livello%type;
      d_numero        dotazione_organica.numero_ore%type;
      d_gestione      dotazione_organica.gestione%type;
      d_attivita      dotazione_organica.attivita%type;
      d_tipo_rapporto dotazione_organica.tipo_rapporto%type;
      d_ore           dotazione_organica.ore%type;
      d_door_id       dotazione_organica.door_id%type;
      d_revisione_a   number(8);
      d_dal_a         date;
      d_effettivi     number;
      d_ore_effettive number;
      d_ore_assenti   number;
      d_mess_assenti  varchar2(250);
      d_tipo          varchar2(1);
      -- N=numero individui; O=numero ore
      situazione_anomala exception;
   begin
      p_errore      := null;
      d_revisione_a := get_revisione_a;
      d_dal_a       := gp4_redo.get_dal_redo_attiva;
      d_area        := to_char(null);
      d_settore     := gp4_stam.get_codice(gp4_stam.get_ni_numero(p_settore));
      d_ruolo       := gp4_qugi.get_ruolo(nvl(p_qualifica
                                             ,gp4_figi.get_qualifica(p_figura, p_dal))
                                         ,p_dal);
      d_profilo     := gp4_figi.get_profilo(p_figura, p_dal);
      d_posizione   := gp4_figi.get_posizione(p_figura, p_dal);
      d_figura      := gp4_figi.get_codice(p_figura, p_dal);
      d_qualifica   := gp4_qugi.get_codice(nvl(p_qualifica
                                              ,gp4_figi.get_qualifica(p_figura, p_dal))
                                          ,p_dal);
      d_livello     := gp4_qugi.get_livello(nvl(p_qualifica
                                               ,gp4_figi.get_qualifica(p_figura, p_dal))
                                           ,p_dal);
      d_tipo        := 'O';
      --
      d_door_id := gp4_door.get_id(d_revisione_a
                                  ,p_rilevanza
                                  ,p_gestione
                                  ,d_area
                                  ,d_settore
                                  ,d_ruolo
                                  ,d_profilo
                                  ,d_posizione
                                  ,p_attivita
                                  ,d_figura
                                  ,d_qualifica
                                  ,d_livello
                                  ,p_tipo_rapporto
                                  ,p_ore);
   
      begin
         select gestione
               ,area
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
           into d_gestione
               ,d_area
               ,d_settore
               ,d_ruolo
               ,d_profilo
               ,d_posizione
               ,d_attivita
               ,d_figura
               ,d_qualifica
               ,d_livello
               ,d_tipo_rapporto
               ,d_ore
           from dotazione_organica
          where door_id = d_door_id
            and revisione = d_revisione_a;
      exception
         when no_data_found then
            p_segnalazione := 'Controlli sulla Dotazione Organica non eseguibili. Le caratteristiche giuridiche dell''individuo non sono previste';
            raise situazione_anomala;
      end;
   
      --
      d_numero := conta_previsti_o(d_revisione_a
                                  ,p_rilevanza
                                  ,d_tipo
                                   -- N = numero individui , O = ore lavorate/unita equivalenti
                                  ,p_gestione
                                  ,d_area
                                  ,d_settore
                                  ,d_ruolo
                                  ,d_profilo
                                  ,d_posizione
                                  ,nvl(p_attivita, '%')
                                  ,d_figura
                                  ,d_qualifica
                                  ,d_livello
                                  ,p_tipo_rapporto
                                  ,d_ore);
   
      if nvl(d_numero, 0) = 0 then
         d_numero := conta_previsti_o(d_revisione_a
                                     ,p_rilevanza
                                     ,'N'
                                      -- N = numero individui , O = ore lavorate/unita equivalenti
                                     ,p_gestione
                                     ,d_area
                                     ,d_settore
                                     ,d_ruolo
                                     ,d_profilo
                                     ,d_posizione
                                     ,p_attivita
                                     ,d_figura
                                     ,d_qualifica
                                     ,d_livello
                                     ,p_tipo_rapporto
                                     ,d_ore);
         d_tipo   := 'N';
      end if;
   
      p_scostamento  := 0;
      d_mess_assenti := ' ';
   
      /* Esegue il controllo del numero degli effettivi per tutte le date di variazione
         del giuridico (I=inizio, T=Termine)
      */
      for chk in (select distinct dal data
                    from periodi_giuridici
                   where rilevanza = p_rilevanza
                     and dal between p_dal and nvl(p_al, to_date(3333333, 'j'))
                     and dal >= d_dal_a
                  union
                  select distinct nvl(al, to_date(3333333, 'j')) data
                    from periodi_giuridici
                   where rilevanza = p_rilevanza
                     and nvl(al, to_date(3333333, 'j')) between p_dal and
                         nvl(p_al, to_date(3333333, 'j'))
                     and nvl(al, to_date(3333333, 'j')) >= d_dal_a
                   order by 1)
      loop
         begin
            if d_tipo = 'N' then
               d_effettivi := conta_dotazione_o(d_revisione_a
                                               ,p_rilevanza
                                               ,chk.data
                                               ,p_gestione
                                               ,d_area
                                               ,d_settore
                                               ,d_ruolo
                                               ,d_profilo
                                               ,d_posizione
                                               ,d_attivita
                                               ,d_figura
                                               ,d_qualifica
                                               ,d_livello
                                               ,d_tipo_rapporto
                                               ,d_ore);
               p_assenti   := nvl(conta_dot_assenti_o(d_revisione_a
                                                     ,p_rilevanza
                                                     ,chk.data
                                                     ,d_gestione
                                                     ,d_area
                                                     ,d_settore
                                                     ,d_ruolo
                                                     ,d_profilo
                                                     ,d_posizione
                                                     ,d_attivita
                                                     ,d_figura
                                                     ,d_qualifica
                                                     ,d_livello
                                                     ,d_tipo_rapporto
                                                     ,d_ore)
                                 ,0) + nvl(conta_dot_incaricati_o(d_revisione_a
                                                                 ,p_rilevanza
                                                                 ,chk.data
                                                                 ,d_gestione
                                                                 ,d_area
                                                                 ,d_settore
                                                                 ,d_ruolo
                                                                 ,d_profilo
                                                                 ,d_posizione
                                                                 ,d_attivita
                                                                 ,d_figura
                                                                 ,d_qualifica
                                                                 ,d_livello
                                                                 ,d_tipo_rapporto
                                                                 ,d_ore)
                                          ,0); -- Totale numero assenti
            elsif d_tipo = 'O' then
               d_ore_assenti := nvl(conta_ore_assenti_o(d_revisione_a
                                                       ,p_rilevanza
                                                       ,chk.data
                                                       ,d_gestione
                                                       ,d_area
                                                       ,d_settore
                                                       ,d_ruolo
                                                       ,d_profilo
                                                       ,d_posizione
                                                       ,d_attivita
                                                       ,d_figura
                                                       ,d_qualifica
                                                       ,d_livello
                                                       ,d_tipo_rapporto
                                                       ,d_ore)
                                   ,0) + nvl(conta_ore_incaricati_o(d_revisione_a
                                                                   ,p_rilevanza
                                                                   ,chk.data
                                                                   ,d_gestione
                                                                   ,d_area
                                                                   ,d_settore
                                                                   ,d_ruolo
                                                                   ,d_profilo
                                                                   ,d_posizione
                                                                   ,d_attivita
                                                                   ,d_figura
                                                                   ,d_qualifica
                                                                   ,d_livello
                                                                   ,d_tipo_rapporto
                                                                   ,d_ore)
                                            ,0); -- Totale numero ore assenti
            end if;
         
            if d_tipo = 'N' then
               if p_assenti = 1 then
                  d_mess_assenti := ', di cui ' || p_assenti ||
                                    ' assente di ruolo o incaricato.';
               elsif p_assenti > 1 then
                  d_mess_assenti := ', di cui ' || p_assenti ||
                                    ' assenti di ruolo o incaricati.';
               end if;
            
               p_scostamento := nvl(d_effettivi, 0) - nvl(d_numero, 0);
            elsif d_tipo = 'O' then
               if d_ore_assenti > 0 then
                  d_mess_assenti := ', di cui ' || d_ore_assenti ||
                                    ' di individui assenti di ruolo o incaricati.';
               end if;
            
               p_scostamento := nvl(d_ore_effettive, 0) - nvl(d_numero, 0);
            end if;
         
            if p_scostamento > 0 then
               select decode(d_tipo, 'N', 'P08027', 'O', 'P08028')
                 into p_errore
                 from dual; -- esubero
            
               p_segnalazione := si4.get_error(p_errore) || ' dalla data: ' ||
                                 to_char(chk.data, 'dd/mm/yyyy') || '; Eccedenza : ' ||
                                 p_scostamento || d_mess_assenti;
               raise situazione_anomala;
            elsif p_scostamento < 0 then
               select decode(d_tipo, 'N', 'P08029', 'O', 'P08030')
                 into p_errore
                 from dual; -- carenza
            
               p_segnalazione := si4.get_error(p_errore) || ' dalla data: ' ||
                                 to_char(chk.data, 'dd/mm/yyyy') || '; Carenza : ' ||
                                 p_scostamento || d_mess_assenti;
               raise situazione_anomala;
            end if;
         end;
      end loop;
   exception
      when situazione_anomala then
         null;
   end chk_numero_dotazione_o;

   --
   procedure chk_gruppi_linguistici_o
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_GRUPPI_LINGUISTICI
         PURPOSE:    Controlla la consistenza della dotazione organica effettiva rispetto
                     alla ripartizione per gruppo linguistico a fronte di una variazione
                  su PERIODI_GIURIDICI.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        09/02/2004                   1. Created this function.
      ******************************************************************************/
      d_settore      settori_amministrativi.codice%type;
      d_area         aree.area%type;
      d_ruolo        ruoli.codice%type;
      d_profilo      profili_professionali.codice%type;
      d_posizione    posizioni_funzionali.codice%type;
      d_figura       figure_giuridiche.codice%type;
      d_qualifica    qualifiche_giuridiche.codice%type;
      d_livello      qualifiche_giuridiche.livello%type;
      d_numero       dotazione_organica.numero%type;
      d_numero_ore   dotazione_organica.numero_ore%type;
      d_numero_ore_i dotazione_organica.numero_ore%type;
      d_numero_ore_d dotazione_organica.numero_ore%type;
      d_numero_ore_l dotazione_organica.numero_ore%type;
      d_door_id      dotazione_organica.door_id%type;
      d_rigd_id      righe_gruppi_dotazione.rigd_id%type;
      d_revisione    dotazione_organica.revisione%type;
      d_dal_a        date;
      d_data         date;
      d_effettivi    number;
      -- N=numero individui; O=numero ore
      d_gruppo_ling        anagrafici.gruppo_ling%type;
      d_gestione_door      dotazione_organica.gestione%type;
      d_area_door          dotazione_organica.area%type;
      d_settore_door       dotazione_organica.settore%type;
      d_ruolo_door         dotazione_organica.ruolo%type;
      d_profilo_door       dotazione_organica.profilo%type;
      d_posizione_door     dotazione_organica.posizione%type;
      d_attivita_door      dotazione_organica.attivita%type;
      d_figura_door        dotazione_organica.figura%type;
      d_qualifica_door     dotazione_organica.qualifica%type;
      d_livello_door       dotazione_organica.livello%type;
      d_tipo_rapporto_door dotazione_organica.tipo_rapporto%type;
      d_ore_door           dotazione_organica.ore%type;
      prossimo exception;
      situazione_anomala exception;
   begin
      p_errore    := null;
      d_dal_a     := gp4_redo.get_dal_redo_attiva;
      d_area      := to_char(null);
      d_settore   := gp4_stam.get_codice(gp4_stam.get_ni_numero(p_settore));
      d_ruolo     := gp4_qugi.get_ruolo(nvl(p_qualifica
                                           ,gp4_figi.get_qualifica(p_figura, p_dal))
                                       ,p_dal);
      d_profilo   := gp4_figi.get_profilo(p_figura, p_dal);
      d_posizione := gp4_figi.get_posizione(p_figura, p_dal);
      d_figura    := gp4_figi.get_codice(p_figura, p_dal);
      d_qualifica := gp4_qugi.get_codice(nvl(p_qualifica
                                            ,gp4_figi.get_qualifica(p_figura, p_dal))
                                        ,p_dal);
      d_livello   := gp4_qugi.get_livello(nvl(p_qualifica
                                             ,gp4_figi.get_qualifica(p_figura, p_dal))
                                         ,p_dal);
      /* Determina il gruppo linguistico dell'individuo */
      d_gruppo_ling := gp4_anag.get_gruppo_ling(gp4_rain.get_ni(p_ci));
   
      /* Eseguiamo il controllo sulla ripartizione linguistica per tutte le scadenze
         comprese all'interno del periodo giuridico considerato
      */
      for chk in (select distinct dal data
                    from periodi_giuridici
                   where rilevanza = p_rilevanza
                     and dal between p_dal and nvl(p_al, to_date(3333333, 'j'))
                     and dal >= d_dal_a
                  union
                  select distinct nvl(al, to_date(3333333, 'j')) data
                    from periodi_giuridici
                   where rilevanza = p_rilevanza
                     and nvl(al, to_date(3333333, 'j')) between p_dal and
                         nvl(p_al, to_date(3333333, 'j'))
                     and nvl(al, to_date(3333333, 'j')) >= d_dal_a
                   order by 1)
      loop
         begin
            /* Determino la revisione di dotazione valida alla data */
            begin
               select revisione
                 into d_revisione
                 from revisioni_dotazione
                where dal = (select max(dal)
                               from revisioni_dotazione
                              where dal <= chk.data
                                and stato in ('A', 'O'));
            exception
               when no_data_found then
                  d_revisione := to_number(null);
            end;
         
            /* Determina l'ID del record di DOOR che rappresenta gli attributi giuridici del
               periodo trattato
            */
            d_door_id := gp4_door.get_id(d_revisione
                                        ,p_rilevanza
                                        ,p_gestione
                                        ,d_area
                                        ,d_settore
                                        ,d_ruolo
                                        ,d_profilo
                                        ,d_posizione
                                        ,p_attivita
                                        ,d_figura
                                        ,d_qualifica
                                        ,d_livello
                                        ,p_tipo_rapporto
                                        ,p_ore);
         
            /* Determina il gruppo di dotazione nel quale e inquadrato
                il record di DOOR che rappresenta gli attributi giuridici
            del periodo trattato
             */
            begin
               select distinct rgdo.rigd_id
                 into d_rigd_id
                 from righe_gruppi_dotazione rgdo
                where revisione = d_revisione
                  and door_id = d_door_id
                  and chk.data between nvl(rgdo.dal, to_date(2222222, 'j')) and
                      nvl(rgdo.al, to_date(3333333, 'j'));
            exception
               when too_many_rows then
                  d_rigd_id := 0;
                  raise situazione_anomala;
               when no_data_found then
                  raise prossimo;
            end;
         
            /* Determina il valore di NUMERO_ORE (unita equivalenti)
               del gruppo di dotazione che comprende il DOOR_ID individuato
            */
            begin
               select numero_ore_i
                     ,numero_ore_d
                     ,numero_ore_l
                 into d_numero_ore_i
                     ,d_numero_ore_d
                     ,d_numero_ore_l
                 from ripartizione_gruppi_dotazione
                where rigd_id = d_rigd_id;
            exception
               when no_data_found or too_many_rows then
                  d_rigd_id := 0;
                  raise situazione_anomala;
            end;
         
            /* Determina il totale di NUMERO e NUMERO_ORE delle registrazioni di DOOR
               del gruppo di dotazione che comprende il DOOR_ID individuato
            */
            select sum(nvl(door.numero, 0))
                  ,sum(nvl(door.numero_ore, 0))
              into d_numero
                  ,d_numero_ore
              from dotazione_organica door
             where (door.revisione, door.door_id) in
                   (select revisione
                          ,door_id
                      from righe_gruppi_dotazione
                     where rigd_id = d_rigd_id);
         
            /* Calcola il numero degli individui giuridicamente simili a quello trattato
               con lo stesso gruppo linguistico sommando tutti gli effettivi dei diversi
              record di DOOR raggruppati nel gruppo determinato precedentemente
            */
            d_effettivi := 0;
         
            for cur_rigd in (select revisione
                                   ,door_id
                               from righe_gruppi_dotazione
                              where rigd_id = d_rigd_id)
            loop
               select gestione
                     ,area
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
                 into d_gestione_door
                     ,d_area_door
                     ,d_settore_door
                     ,d_ruolo_door
                     ,d_profilo_door
                     ,d_posizione_door
                     ,d_attivita_door
                     ,d_figura_door
                     ,d_qualifica_door
                     ,d_livello_door
                     ,d_tipo_rapporto_door
                     ,d_ore_door
                 from dotazione_organica
                where door_id = cur_rigd.door_id
                  and revisione = cur_rigd.revisione;
            
               d_effettivi := d_effettivi +
                              conta_dotazione_ling_o(d_revisione
                                                    ,d_gruppo_ling
                                                    ,p_rilevanza
                                                    ,chk.data
                                                    ,d_gestione_door
                                                    ,d_area_door
                                                    ,d_settore_door
                                                    ,d_ruolo_door
                                                    ,d_profilo_door
                                                    ,d_posizione_door
                                                    ,d_attivita_door
                                                    ,d_figura_door
                                                    ,d_qualifica_door
                                                    ,d_livello_door
                                                    ,d_tipo_rapporto_door
                                                    ,d_ore_door);
            end loop;
         
            select nvl(d_effettivi, 0) - decode(d_gruppo_ling
                                               ,'I'
                                               ,d_numero_ore_i
                                               ,'D'
                                               ,d_numero_ore_d
                                               ,'L'
                                               ,d_numero_ore_l)
              into p_scostamento
              from dual;
         
            /* Interpreta il risultato e predispone le segnalazioni*/
            if p_scostamento > 0 then
               select 'P08027' into p_errore from dual; -- esubero
            
               p_segnalazione := si4.get_error(p_errore) || ' per il gruppo liguistico ' ||
                                 ' dalla data: ' || to_char(chk.data, 'dd/mm/yyyy') ||
                                 '; Eccedenza : ' || p_scostamento;
               raise situazione_anomala;
            elsif p_scostamento < 0 then
               select 'P08029' into p_errore from dual; -- carenza
            
               p_segnalazione := si4.get_error(p_errore) || ' per il gruppo liguistico ' ||
                                 ' dalla data: ' || to_char(chk.data, 'dd/mm/yyyy') ||
                                 '; Carenza : ' || p_scostamento;
               raise situazione_anomala;
            end if;
         exception
            when prossimo then
               null;
         end;
      
         d_data := chk.data;
      end loop;
   exception
      when situazione_anomala then
         null;
   end chk_gruppi_linguistici_o;

   --
   procedure chk_gruppi_linguistici
   (
      p_ci            in number
     ,p_rilevanza     in varchar2
     ,p_dal           in date
     ,p_al            in date
     ,p_posizione     in varchar2
     ,p_gestione      in varchar2
     ,p_settore       in number
     ,p_attivita      in varchar2
     ,p_figura        in number
     ,p_qualifica     in number
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
     ,p_scostamento   out number
     ,p_assenti       out number
     ,p_errore        out varchar2
     ,p_segnalazione  out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_GRUPPI_LINGUISTICI
         PURPOSE:    Controlla la consistenza della dotazione organica effettiva rispetto
                     alla ripartizione per gruppo linguistico a fronte di una variazione
                  su PERIODI_GIURIDICI.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        09/02/2004                   1. Created this function.
      ******************************************************************************/
      d_numero            dotazione_organica.numero%type;
      d_numero_ore        dotazione_organica.numero_ore%type;
      d_numero_ore_i      dotazione_organica.numero_ore%type;
      d_numero_ore_d      dotazione_organica.numero_ore%type;
      d_numero_ore_l      dotazione_organica.numero_ore%type;
      d_door_id_pedo      dotazione_organica.door_id%type;
      d_door_id_pedo_prec dotazione_organica.door_id%type;
      d_rigd_id           righe_gruppi_dotazione.rigd_id%type;
      d_revisione         dotazione_organica.revisione%type;
      d_data              date;
      d_effettivi         number;
      -- N=numero individui; O=numero ore
      d_gruppo_ling        anagrafici.gruppo_ling%type;
      d_gestione_door      dotazione_organica.gestione%type;
      d_area_door          dotazione_organica.area%type;
      d_settore_door       dotazione_organica.settore%type;
      d_ruolo_door         dotazione_organica.ruolo%type;
      d_profilo_door       dotazione_organica.profilo%type;
      d_posizione_door     dotazione_organica.posizione%type;
      d_attivita_door      dotazione_organica.attivita%type;
      d_figura_door        dotazione_organica.figura%type;
      d_qualifica_door     dotazione_organica.qualifica%type;
      d_livello_door       dotazione_organica.livello%type;
      d_tipo_rapporto_door dotazione_organica.tipo_rapporto%type;
      d_ore_door           dotazione_organica.ore%type;
      d_ore_do             varchar2(1);
      d_ore_lavoro         number;
      prossimo exception;
      situazione_anomala exception;
   begin
      p_errore := null;
      /* Determina il gruppo linguistico dell'individuo */
      d_gruppo_ling := gp4_anag.get_gruppo_ling(gp4_rain.get_ni(p_ci));
      /* Determino i gruppi di dotazione interessati dalla modifica */
      d_revisione := gp4_redo.get_revisione(p_dal);
   
      begin
         select door_id
               ,door_id_prec
           into d_door_id_pedo
               ,d_door_id_pedo_prec
           from periodi_dotazione
          where ci = p_ci
            and rilevanza = p_rilevanza
            and p_dal between dal and nvl(al, to_date(3333333, 'j'))
            and revisione = d_revisione;
      exception
         when no_data_found then
            p_segnalazione := 'Controlli sulla Dotazione Organica non eseguibili. Le caratteristiche giuridiche dell''individuo non sono previste';
            raise situazione_anomala;
      end;
   
      /* Eseguiamo il controllo sulla ripartizione linguistica per tutte le scadenze
         comprese all'interno del periodo giuridico considerato
      */
      for chk in (select distinct dal data
                                 ,door_id
                    from periodi_dotazione
                   where rilevanza = p_rilevanza
                     and dal between p_dal and nvl(p_al, to_date(3333333, 'j'))
                     and door_id in (d_door_id_pedo, d_door_id_pedo_prec)
                     and door_id <> 0
                  union
                  select distinct nvl(al, to_date(3333333, 'j')) data
                                 ,door_id
                    from periodi_dotazione
                   where rilevanza = p_rilevanza
                     and nvl(al, to_date(3333333, 'j')) between p_dal and
                         nvl(p_al, to_date(3333333, 'j'))
                     and door_id in (d_door_id_pedo, d_door_id_pedo_prec)
                     and door_id <> 0
                   order by 1)
      loop
         begin
            /* Determino la revisione di dotazione valida alla data */
            d_revisione := gp4_redo.get_revisione(chk.data);
         
            /* Determina il gruppo di dotazione nel quale e inquadrato
                il record di DOOR che rappresenta gli attributi giuridici
            del periodo trattato
             */
            begin
               select distinct rgdo.rigd_id
                 into d_rigd_id
                 from righe_gruppi_dotazione rgdo
                where revisione = d_revisione
                  and door_id = chk.door_id
                  and chk.data between nvl(rgdo.dal, to_date(2222222, 'j')) and
                      nvl(rgdo.al, to_date(3333333, 'j'));
            exception
               when too_many_rows then
                  d_rigd_id := 0;
                  raise situazione_anomala;
               when no_data_found then
                  raise prossimo;
            end;
         
            /* Determina il valore di NUMERO_ORE (unita equivalenti)
               del gruppo di dotazione che comprende il DOOR_ID individuato
            */
            begin
               select numero_ore_i
                     ,numero_ore_d
                     ,numero_ore_l
                 into d_numero_ore_i
                     ,d_numero_ore_d
                     ,d_numero_ore_l
                 from ripartizione_gruppi_dotazione
                where rigd_id = d_rigd_id;
            exception
               when no_data_found or too_many_rows then
                  d_rigd_id := 0;
                  raise situazione_anomala;
            end;
         
            /* Determina il totale di NUMERO e NUMERO_ORE delle registrazioni di DOOR
               del gruppo di dotazione che comprende il DOOR_ID individuato
            */
            select sum(nvl(door.numero, 0))
                  ,sum(nvl(door.numero_ore, 0))
              into d_numero
                  ,d_numero_ore
              from dotazione_organica door
             where (door.revisione, door.door_id) in
                   (select revisione
                          ,door_id
                      from righe_gruppi_dotazione
                     where rigd_id = d_rigd_id);
         
            /* Calcola il numero degli individui giuridicamente simili a quello trattato
               con lo stesso gruppo linguistico sommando tutti gli effettivi dei diversi
              record di DOOR raggruppati nel gruppo determinato precedentemente
            */
            d_effettivi := 0;
         
            for cur_rigd in (select revisione
                                   ,door_id
                               from righe_gruppi_dotazione
                              where rigd_id = d_rigd_id)
            loop
               select gestione
                     ,area
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
                 into d_gestione_door
                     ,d_area_door
                     ,d_settore_door
                     ,d_ruolo_door
                     ,d_profilo_door
                     ,d_posizione_door
                     ,d_attivita_door
                     ,d_figura_door
                     ,d_qualifica_door
                     ,d_livello_door
                     ,d_tipo_rapporto_door
                     ,d_ore_door
                 from dotazione_organica
                where door_id = cur_rigd.door_id
                  and revisione = cur_rigd.revisione;
            
               d_ore_do := gp4_gest.get_ore_do(p_gestione);
            
               if d_ore_do = 'U' then
                  d_ore_lavoro := get_ore_lavoro_ue(chk.data
                                                   ,d_ruolo_door
                                                   ,d_profilo_door
                                                   ,d_posizione_door
                                                   ,d_figura_door
                                                   ,d_qualifica_door
                                                   ,d_livello_door);
               
                  if nvl(d_ore_lavoro, 0) = 0 then
                     raise situazione_anomala;
                  end if;
               end if;
            
               d_effettivi := d_effettivi +
                              conta_dotazione_ling(d_revisione
                                                  ,d_gruppo_ling
                                                  ,p_rilevanza
                                                  ,chk.data
                                                  ,d_gestione_door
                                                  ,cur_rigd.door_id
                                                  ,d_ore_lavoro);
            end loop;
         
            select nvl(d_effettivi, 0) - decode(d_gruppo_ling
                                               ,'I'
                                               ,d_numero_ore_i
                                               ,'D'
                                               ,d_numero_ore_d
                                               ,'L'
                                               ,d_numero_ore_l)
              into p_scostamento
              from dual;
         
            /* Interpreta il risultato e predispone le segnalazioni*/
            if p_scostamento > 0 then
               select 'P08027' into p_errore from dual; -- esubero
            
               p_segnalazione := si4.get_error(p_errore) || ' per il gruppo liguistico ' ||
                                 ' dalla data: ' || to_char(chk.data, 'dd/mm/yyyy') ||
                                 '; Eccedenza : ' || p_scostamento;
               raise situazione_anomala;
            elsif p_scostamento < 0 then
               select 'P08029' into p_errore from dual; -- carenza
            
               p_segnalazione := si4.get_error(p_errore) || ' per il gruppo liguistico ' ||
                                 ' dalla data: ' || to_char(chk.data, 'dd/mm/yyyy') ||
                                 '; Carenza : ' || p_scostamento;
               raise situazione_anomala;
            end if;
         exception
            when prossimo then
               null;
         end;
      
         d_data := chk.data;
      end loop;
   exception
      when situazione_anomala then
         null;
   end chk_gruppi_linguistici;

   procedure chk_sostituzioni
   (
      p_ci        in number -- sostituto
     ,p_rilevanza in varchar2
      -- rilevanza astensione (I/A)
     ,p_dal          in date -- inizio sostituzione
     ,p_al           in date -- fine   sostituzione
     ,p_posizione    in varchar2
     ,p_titolare     in number -- titolare
     ,p_dal_assenza  in date -- inizio assenza
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_SOSTITUZIONI
         PURPOSE:    Controlla la correttezza del periodo giuridico di inquadramento
                     o di servizio del sostituto rispetto al periodo di assenza del
                     dipendente di ruolo.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        27/08/2002                   1. Created this function.
         2.0        07/06/2004                   2. Introduzione della tabella SOGI
      ******************************************************************************/
      d_dal_ass             date;
      d_al_ass              date;
      d_sost_ruolo          gestioni.sostituzioni_non_ruolo%type;
      d_giorni_assenza      number;
      d_giorni_sostituzione number;
      d_ore_lavorate        number;
      d_ore_lavorate_inc    number;
      d_ore_sostituibili    number;
      d_ore_sostituzione    number;
      d_ore_sostituzione2   number;
      -- ore di assenza del sostituto
      d_eccedenza_ore     number;
      d_eccedenza_ore_inc number;
      d_gg_pre_sost       number;
      d_gg_post_sost      number;
      d_rilevanza         varchar2(1);
      d_dummy             varchar2(1);
      situazione_anomala exception;
   begin
      p_errore := null;
   
      delete from key_error_log
       where error_usertext in ('PGMAPEAS', 'PGMASOGI')
         and error_session = userenv('sessionid');
   
      /* Controllo di copertura dell'assenza rispetto al periodo del sostituto */
      -- Prelevo dalla gestione i giorni di anticipo/posticipo della sostituzione
      d_gg_pre_sost  := nvl(gp4_gest.get_gg_sost_ante_assenza(gp4_pegi.get_gestione(p_titolare
                                                                                   ,'Q'
                                                                                   ,p_dal_assenza))
                           ,0);
      d_gg_post_sost := nvl(gp4_gest.get_gg_sost_post_assenza(gp4_pegi.get_gestione(p_titolare
                                                                                   ,'Q'
                                                                                   ,p_dal_assenza))
                           ,0);
      d_sost_ruolo   := gp4_gest.get_sost_ruolo(gp4_pegi.get_gestione(p_titolare
                                                                     ,'Q'
                                                                     ,p_dal_assenza));
   
      -- Calcolo giorni di assenza nel periodo
      begin
         -- Determina le caratteristiche del periodo di assenza
         select min(dal)
               ,max(al)
               ,max(nvl(pegi.al, to_date(3333333, 'j')) - pegi.dal + 1)
               ,max(pegi.rilevanza)
           into d_dal_ass
               ,d_al_ass
               ,d_giorni_assenza
               ,d_rilevanza
           from periodi_giuridici pegi
          where pegi.rilevanza = p_rilevanza
            and pegi.ci = p_titolare
            and pegi.dal = p_dal_assenza
            and (p_rilevanza = 'I' or (p_rilevanza = 'A' and exists
                 (select 'x'
                                          from astensioni
                                         where codice = pegi.assenza
                                           and sostituibile = 1)));
      
         -- calcolo giorni del periodo di sostituzione
         select (nvl(p_al, to_date(3333333, 'j')) - p_dal + 1)
           into d_giorni_sostituzione
           from dual;
      
         if p_dal < d_dal_ass - d_gg_pre_sost or
            nvl(p_al, to_date(3333333, 'j')) >
            nvl(d_al_ass, to_date(3333333, 'j')) + d_gg_post_sost
         --nvl(d_giorni_assenza,0) < nvl(d_giorni_sostituzione,0)
          then
            if d_rilevanza = 'A' then
               p_errore := 'P08031';
               -- sostituzione esterna all'assenza
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            elsif d_rilevanza = 'I' then
               p_errore := 'P08044';
               -- sostituzione esterna all'incarico
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end if;
         elsif nvl(d_giorni_assenza, 0) > nvl(d_giorni_sostituzione, 0) then
            null;
            --P_errore       := 'P08034';                     -- assenza non completamente coperta
            --P_segnalazione := si4.GET_ERROR(P_errore);
         end if;
      end;
   
      /* Controllo che la posizione giuridica del sostituto sia non di ruolo */
      if d_sost_ruolo = 'NO' then
         if gp4_posi.get_ruolo(p_posizione) = 'SI' then
            p_errore := 'P08032';
            -- il sostituto deve essere non di ruolo
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
         end if;
      end if;
   
      /* Controllo che il totale delle sostituzioni del supplente non superino le sue ore lavorate */
      d_ore_lavorate     := nvl(gp4_pegi.get_ore(p_ci, 'Q', p_dal)
                               ,gp4_cost.get_ore_lavoro(gp4_pegi.get_qualifica(p_ci
                                                                              ,'S'
                                                                              ,p_dal)
                                                       ,p_dal));
      d_ore_lavorate_inc := nvl(nvl(gp4_pegi.get_ore(p_ci, 'I', p_dal)
                                   ,gp4_cost.get_ore_lavoro(gp4_pegi.get_qualifica(p_ci
                                                                                  ,'E'
                                                                                  ,p_dal)
                                                           ,p_dal))
                               ,d_ore_lavorate);
      dbms_output.put_line('ore lavorate     : ' || d_ore_lavorate);
      dbms_output.put_line('ore lavorate inc : ' || d_ore_lavorate_inc);
      begin
         for cur_sostituzioni in (select sogi.sostituto
                                        ,sogi.dal dal_sost
                                        ,sogi.al al_sost
                                        ,sogi.ore_sostituzione
                                        ,sogi.titolare
                                        ,pegi.dal dal_ass
                                        ,pegi.al al_ass
                                    from sostituzioni_giuridiche sogi
                                        ,periodi_giuridici       pegi
                                   where sogi.sostituto = p_ci
                                     and sogi.dal <= nvl(p_al, to_date(3333333, 'j'))
                                     and nvl(sogi.al, to_date(3333333, 'j')) >= p_dal
                                     and pegi.ci = sogi.titolare
                                     and pegi.rilevanza = sogi.rilevanza_astensione
                                     and pegi.dal = sogi.dal_astensione
                                     and sogi.rilevanza_astensione in ('A', 'I'))
         loop
            begin
               begin
                  -- controlla se il sostituto e a sua volta assente
                  select 'x'
                    into d_dummy
                    from periodi_giuridici pegi
                   where rilevanza = 'A'
                     and ci = p_ci
                     and (cur_sostituzioni.dal_sost between pegi.dal and
                         nvl(pegi.al, to_date(3333333, 'j')) or
                         nvl(cur_sostituzioni.al_sost, to_date(3333333, 'j')) between
                         pegi.dal and nvl(pegi.al, to_date(3333333, 'j')));
               
                  raise too_many_rows;
               exception
                  when no_data_found then
                     null;
                  when too_many_rows then
                     p_segnalazione := 'Sostituto assente nel periodo ' ||
                                       to_char(cur_sostituzioni.dal_sost, 'dd/mm/yyyy') ||
                                       ' - ' ||
                                       to_char(cur_sostituzioni.al_sost, 'dd/mm/yyyy');
                     raise situazione_anomala;
               end;
            
               -- determina totale delle ore di sostituzione effettuate
               select sum(ore_sostituzione)
                 into d_ore_sostituzione
                 from sostituzioni_giuridiche sogi
                where sostituto = cur_sostituzioni.sostituto
                  and sogi.rilevanza_astensione in ('A', 'I')
                  and cur_sostituzioni.dal_sost between sogi.dal and
                      nvl(sogi.al, to_date(3333333, 'j'));
            
               select sum(ore_sostituzione)
                 into d_ore_sostituzione2
                 from sostituzioni_giuridiche sogi
                where sostituto = cur_sostituzioni.sostituto
                  and sogi.rilevanza_astensione in ('A', 'I')
                  and nvl(cur_sostituzioni.al_sost, to_date(3333333, 'j')) between
                      sogi.dal and nvl(sogi.al, to_date(3333333, 'j'));
            
               d_eccedenza_ore     := greatest(d_ore_sostituzione, d_ore_sostituzione2) -
                                      d_ore_lavorate;
               d_eccedenza_ore_inc := greatest(d_ore_sostituzione, d_ore_sostituzione2) -
                                      d_ore_lavorate_inc;
            
               dbms_output.put_line('ore eccedenza     : ' || d_eccedenza_ore);
               dbms_output.put_line('ore eccedenza inc : ' || d_eccedenza_ore_inc);
               if d_eccedenza_ore_inc > 0 then
                  p_errore       := 'P08055';
                  p_segnalazione := si4.get_error(p_errore) || ' nel periodo ' ||
                                    to_char(cur_sostituzioni.dal_sost, 'dd/mm/yyyy') || '-' ||
                                    to_char(cur_sostituzioni.al_sost, 'dd/mm/yyyy') ||
                                    ' Eccedenza : ' || d_eccedenza_ore;
                  raise situazione_anomala;
               elsif d_eccedenza_ore > 0 then
                  --          p_errore       := 'P08071';
                  p_segnalazione := si4.get_error('P08071') || ' nel periodo ' ||
                                    to_char(cur_sostituzioni.dal_sost, 'dd/mm/yyyy') || '-' ||
                                    to_char(cur_sostituzioni.al_sost, 'dd/mm/yyyy') ||
                                    ' Eccedenza : ' || d_eccedenza_ore;
               end if;
            end;
         end loop;
      end;
   
      /* Controllo che le ore di sostituzione effettuate dai diversi sostituti non eccedano le ore sostituibili */
      begin
         -- determino le ore sostituibili
         d_ore_sostituibili := get_ore_sostituibili(p_titolare, p_dal_assenza);
      
         for cur_sogi in (select sogi.sostituto
                                ,sogi.dal dal_sost
                                ,sogi.al al_sost
                            from sostituzioni_giuridiche sogi
                           where sogi.titolare = p_titolare
                             and sogi.dal_astensione = p_dal_assenza)
         loop
            begin
               -- determina totale delle ore di sostituzione effettuate
               select sum(ore_sostituzione)
                 into d_ore_sostituzione
                 from sostituzioni_giuridiche sogi
                where titolare = p_titolare
                  and (cur_sogi.dal_sost between sogi.dal and
                      nvl(sogi.al, to_date(3333333, 'j')) or
                      nvl(cur_sogi.al_sost, to_date(3333333, 'j')) between sogi.dal and
                      nvl(sogi.al, to_date(3333333, 'j')));
            
               d_eccedenza_ore := d_ore_sostituzione - d_ore_sostituibili;
            
               if d_eccedenza_ore > 0 then
                  p_errore       := 'P08056';
                  p_segnalazione := si4.get_error(p_errore) || ' nel periodo ' ||
                                    to_char(cur_sogi.dal_sost, 'dd/mm/yyyy') || '-' ||
                                    to_char(cur_sogi.dal_sost, 'dd/mm/yyyy') ||
                                    ' Eccedenza : ' || d_eccedenza_ore;
                  raise situazione_anomala;
               end if;
            end;
         end loop;
      end;
   exception
      when situazione_anomala then
         null;
   end chk_sostituzioni;

   --
   procedure chk_sostituzioni_inc
   (
      p_ci           in number -- sostituto
     ,p_rilevanza    in varchar2
     ,p_dal          in date
     ,p_al           in date
     ,p_posizione    in varchar2
     ,p_sostituto    in number -- titolare
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_SOSTITUZIONI_INC
         PURPOSE:    Controlla la correttezza del periodo giuridico di inquadramento
                     o di servizio del sostituto rispetto al periodo di incarico del
                     dipendente di ruolo.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        27/08/2002          1. Created this function.
      ******************************************************************************/
      d_giorni_incarico     number;
      d_giorni_sostituzione number;
      situazione_anomala exception;
      d_sost_ruolo gestioni.sostituzioni_non_ruolo%type;
   
   begin
      p_errore     := null;
      d_sost_ruolo := gp4_gest.get_sost_ruolo(gp4_pegi.get_gestione(p_ci, 'Q', p_dal));
   
      /* Controllo di copertura dell'incarico rispetto al periodo del sostituto */
      -- Calcolo giorni di incarico nel periodo
      begin
         -- Calcolo giorni di incarico nel periodo
         select sum(least(nvl(pegi.al, to_date(3333333, 'j'))
                         ,nvl(p_al, to_date(3333333, 'j'))) - greatest(pegi.dal, p_dal) + 1)
           into d_giorni_incarico
           from periodi_giuridici pegi
          where pegi.rilevanza = 'I'
            and pegi.ci = p_sostituto
            and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal
            and p_dal <= nvl(pegi.al, to_date(3333333, 'j'));
      
         -- calcolo giorni del periodo di sostituzione
         select (nvl(p_al, to_date(3333333, 'j')) - p_dal + 1)
           into d_giorni_sostituzione
           from dual;
      
         if nvl(d_giorni_incarico, 0) <> 0 and
            nvl(d_giorni_incarico, 0) < nvl(d_giorni_sostituzione, 0) then
            p_errore := 'P08044';
            -- sostituzione esterna all'incarico
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
         elsif nvl(d_giorni_incarico, 0) > nvl(d_giorni_sostituzione, 0) then
            p_errore := 'P08045';
            -- incarico non completamente coperta
            p_segnalazione := si4.get_error(p_errore);
         end if;
      end;
   
      /* Controllo che la posizione giuridica del sostituto sia non di ruolo */
      if d_sost_ruolo = 'NO' then
         if gp4_posi.get_ruolo(p_posizione) = 'SI' then
            p_errore := 'P08032';
            -- il sostituto deve essere non di ruolo
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
         end if;
      end if;
   
      /* Controllo che non esistano periodi di sostituzione di altri supplenti che intersechino
      il periodo di inquadramento in oggetto */
      begin
         for cur_incarichi in (select pegi.ci
                                     ,pegi.dal
                                     ,pegi.al
                                 from periodi_giuridici pegi
                                where pegi.rilevanza = 'I'
                                  and pegi.ci = p_sostituto
                                  and nvl(p_al, to_date(3333333, 'j')) >= pegi.dal
                                  and p_dal <= nvl(pegi.al, to_date(3333333, 'j')))
         loop
            begin
               for cur_sostituzioni in (select pegi.ci
                                              ,pegi.dal
                                              ,pegi.al
                                          from periodi_giuridici pegi
                                         where rilevanza = p_rilevanza
                                           and sostituto = p_sostituto
                                           and ci <> p_ci
                                           and dal <=
                                               nvl(cur_incarichi.al, to_date(3333333, 'j'))
                                           and nvl(al, to_date(3333333, 'j')) >=
                                               cur_incarichi.dal)
               loop
                  begin
                     if (cur_sostituzioni.dal <= nvl(p_al, to_date(3333333, 'j')) and
                        nvl(cur_sostituzioni.al, to_date(3333333, 'j')) >= p_dal) then
                        p_errore       := 'P08046';
                        p_segnalazione := si4.get_error(p_errore);
                        raise situazione_anomala;
                     end if;
                  end;
               end loop;
            end;
         end loop;
      end;
   exception
      when situazione_anomala then
         null;
   end chk_sostituzioni_inc;

   --
   procedure get_non_assegnati(c_non_assegnati in out non_assegnati) is
   begin
      open c_non_assegnati for
         select ci
               ,rilevanza
               ,pegi.dal
               ,pegi.al
               ,gp4_unor.get_codice_uo(stam.ni, 'GP4', pegi.al)
               ,figi.codice
           from periodi_giuridici      pegi
               ,settori_amministrativi stam
               ,figure_giuridiche      figi
          where rilevanza in (select 'Q'
                                from dual
                              union
                              select 'S'
                                from dual
                              union
                              select 'I'
                                from dual
                              union
                              select 'E' from dual)
            and nvl(pegi.al, to_date(3333333, 'j')) >=
                gp4_rest.get_dal_rest_attiva('GP4')
            and not exists
          (select 'x'
                   from unita_organizzative unor
                  where ni =
                        (select ni from settori_amministrativi where numero = pegi.settore)
                    and unor.ottica = 'GP4'
                    and unor.revisione = gp4do.get_revisione_a)
            and exists
          (select 'x'
                   from unita_organizzative unor
                  where ni =
                        (select ni from settori_amministrativi where numero = pegi.settore)
                    and unor.ottica = 'GP4'
                    and unor.revisione = gp4do.get_revisione_o)
            and stam.numero = pegi.settore
            and figi.numero = pegi.figura
            and nvl(pegi.al, to_date(3333333, 'j')) between figi.dal and
                nvl(figi.al, to_date(3333333, 'j'));
   end get_non_assegnati;

   --
   procedure duplica_revisione
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       DUPLICA_REVISIONE
         PURPOSE:    Duplica la revisione di dotazione attiva su quella in modifica
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
         2.0        14/06/2004                   Posti ad esaurimento
      ******************************************************************************/
      d_revisione_m number(8);
      d_revisione_a number(8);
      d_dal_m       date;
      situazione_anomala exception;
   begin
      p_errore := null;
   
      begin
         select revisione
               ,dal
           into d_revisione_m
               ,d_dal_m
           from revisioni_dotazione
          where stato = 'M';
      exception
         when no_data_found then
            begin
               p_errore := 'P08005';
               -- Non esistono revisioni in modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
         when too_many_rows then
            begin
               p_errore := 'P08006';
               -- Esistono piu di una revisione in stato di modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
   
      begin
         select revisione into d_revisione_a from revisioni_dotazione where stato = 'A';
      exception
         when no_data_found then
            begin
               p_errore := 'P08007';
               -- Non esistono revisioni attive
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
         when too_many_rows then
            begin
               p_errore := 'P08008';
               -- Esistono piu di una revisione in stato attivo
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
   
      begin
         -- Duplica la definizione della dotazione teorica della revisione attiva sulla revisione in modifica
         delete from dotazione_organica where revisione = d_revisione_m;
      
         insert into dotazione_organica
            (revisione
            ,door_id
            ,gestione
            ,area
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
            ,utente
            ,data_agg
            ,numero
            ,numero_ore
            ,tipo)
            select d_revisione_m
                  ,door_id
                  ,gestione
                  ,area
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
                  ,utente
                  ,data_agg
                  ,numero - nvl(get_num_esaurimento(revisione, door_id), 0)
                   -- detrae i posti previsti ad esaurimento per la revisione
                  ,numero_ore - nvl(get_ore_esaurimento(revisione, door_id), 0)
                   -- detrae le ore previste ad esaurimento per la revisione
                  ,tipo
              from dotazione_organica
             where revisione = d_revisione_a;
      end;
   
      /* Allinea PERIODI_DOTAZIONE alla nuova revisione
      La modifica a PEGI, provoca, tramite il trigger
      PEGI_PEDO_TMA, l'allineamento di PEDO */
      /*  update periodi_giuridici
         set ci = ci
       where nvl(al,to_date(3333333,'j')) >= d_dal_m
      ;*/
      delete from periodi_dotazione where revisione = d_revisione_m;
   
      insert into periodi_dotazione
         (ci
         ,rilevanza
         ,dal
         ,al
         ,gestione
         ,ore
         ,revisione
         ,door_id
         ,figura
         ,qualifica
         ,posizione
         ,revisione_prec
         ,door_id_prec
         ,attivita
         ,tipo_rapporto
         ,settore
         ,area
         ,codice_uo
         ,ruolo
         ,profilo
         ,pos_funz
         ,cod_figura
         ,cod_qualifica
         ,livello
         ,assenza
         ,di_ruolo
         ,incarico
         ,part_time
         ,evento
         ,ue
         ,unita_ni
         ,contrattista
         ,sovrannumero
         ,contratto
         ,ore_lavoro)
         select ci
               ,rilevanza
               ,dal
               ,al
               ,gestione
               ,ore
               ,d_revisione_m
               ,door_id
               ,figura
               ,qualifica
               ,posizione
               ,d_revisione_m
               ,door_id_prec
               ,attivita
               ,tipo_rapporto
               ,settore
               ,area
               ,codice_uo
               ,ruolo
               ,profilo
               ,pos_funz
               ,cod_figura
               ,cod_qualifica
               ,livello
               ,assenza
               ,di_ruolo
               ,incarico
               ,part_time
               ,evento
               ,ue
               ,unita_ni
               ,contrattista
               ,sovrannumero
               ,contratto
               ,ore_lavoro
           from periodi_dotazione
          where revisione = d_revisione_a
            and nvl(al, to_date(3333333, 'j')) >= d_dal_m;
   exception
      when situazione_anomala then
         null;
   end duplica_revisione;

   --
   --
   procedure duplica_revisioni
   (
      p_revisione    in number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       DUPLICA_REVISIONI
         PURPOSE:    Duplica la revisione di dotazione attiva o obsoleta su quella in modifica
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002
         2.0        14/06/2004                   Posti ad esaurimento
         2.1        23/08/2007  CB     
      ******************************************************************************/
      d_revisione_m number(8);
      d_revisione_a number(8);
      d_dal_m       date;
      situazione_anomala exception;
   begin
      p_errore := null;
   
      begin
         select revisione
               ,dal
           into d_revisione_m
               ,d_dal_m
           from revisioni_dotazione
          where stato = 'M';
      exception
         when no_data_found then
            begin
               p_errore := 'P08005';
               -- Non esistono revisioni in modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
         when too_many_rows then
            begin
               p_errore := 'P08006';
               -- Esistono piu di una revisione in stato di modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
   
      begin
         -- Duplica la definizione della dotazione teorica della revisione data sulla revisione in modifica
         delete from dotazione_organica where revisione = d_revisione_m;
      
         insert into dotazione_organica
            (revisione
            ,door_id
            ,gestione
            ,area
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
            ,utente
            ,data_agg
            ,numero
            ,numero_ore
            ,tipo)
            select d_revisione_m
                  ,door_id
                  ,gestione
                  ,area
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
                  ,utente
                  ,data_agg
                  ,numero - nvl(get_num_esaurimento(revisione, door_id), 0)
                   -- detrae i posti previsti ad esaurimento per la revisione
                  ,numero_ore - nvl(get_ore_esaurimento(revisione, door_id), 0)
                   -- detrae le ore previste ad esaurimento per la revisione
                  ,tipo
              from dotazione_organica
             where revisione = p_revisione;
      end;
   
      /* Allinea PERIODI_DOTAZIONE alla nuova revisione
      La modifica a PEGI, provoca, tramite il trigger
      PEGI_PEDO_TMA, l'allineamento di PEDO */
      /*  update periodi_giuridici
         set ci = ci
       where nvl(al,to_date(3333333,'j')) >= d_dal_m
      ;*/
      delete from periodi_dotazione where revisione = d_revisione_m;
   
      insert into periodi_dotazione
         (ci
         ,rilevanza
         ,dal
         ,al
         ,gestione
         ,ore
         ,revisione
         ,door_id
         ,figura
         ,qualifica
         ,posizione
         ,revisione_prec
         ,door_id_prec
         ,attivita
         ,tipo_rapporto
         ,settore
         ,area
         ,codice_uo
         ,ruolo
         ,profilo
         ,pos_funz
         ,cod_figura
         ,cod_qualifica
         ,livello
         ,assenza
         ,di_ruolo
         ,incarico
         ,part_time
         ,evento
         ,ue
         ,unita_ni
         ,contrattista
         ,sovrannumero
         ,contratto
         ,ore_lavoro)
         select ci
               ,rilevanza
               ,dal
               ,al
               ,gestione
               ,ore
               ,d_revisione_m
               ,door_id
               ,figura
               ,qualifica
               ,posizione
               ,d_revisione_m
               ,door_id_prec
               ,attivita
               ,tipo_rapporto
               ,settore
               ,area
               ,codice_uo
               ,ruolo
               ,profilo
               ,pos_funz
               ,cod_figura
               ,cod_qualifica
               ,livello
               ,assenza
               ,di_ruolo
               ,incarico
               ,part_time
               ,evento
               ,ue
               ,unita_ni
               ,contrattista
               ,sovrannumero
               ,contratto
               ,ore_lavoro
           from periodi_dotazione
          where revisione = p_revisione
            and nvl(al, to_date(3333333, 'j')) >= d_dal_m;
   exception
      when situazione_anomala then
         null;
   end duplica_revisioni;

   --

   procedure acquisisci_revisione_prec
   (
      p_revisione    in number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       ACQUISISCI_REVISIONE_PREC
         PURPOSE:    Acquisisce sulla nuova revisione obsoleta le definizioni di quella precedente
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        03/11/2005
      ******************************************************************************/
      d_revisione_o    number(8);
      d_revisione_prec number(8);
      d_dal_o          date;
      d_dal_prec       date;
      situazione_anomala exception;
   begin
      p_errore      := null;
      d_revisione_o := p_revisione;
      d_dal_o       := gp4_redo.get_dal(d_revisione_o);
   
      begin
         select revisione
               ,dal
           into d_revisione_prec
               ,d_dal_prec
           from revisioni_dotazione
          where stato = 'O'
            and dal = (select max(dal)
                         from revisioni_dotazione
                        where stato = 'O'
                          and dal < d_dal_o);
      exception
         when no_data_found then
            begin
               p_errore := 'P08054';
               -- Non esistono revisioni valide per l'acquisizione
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
   
      begin
         -- Duplica la definizione della dotazione teorica della revisione precedente sulla nuova revisione obsoleta
         delete from dotazione_organica where revisione = d_revisione_o;
      
         insert into dotazione_organica
            (revisione
            ,door_id
            ,gestione
            ,area
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
            ,utente
            ,data_agg
            ,numero
            ,numero_ore
            ,tipo)
            select d_revisione_o
                  ,door_id
                  ,gestione
                  ,area
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
                  ,utente
                  ,data_agg
                  ,numero
                  ,numero_ore
                  ,tipo
              from dotazione_organica
             where revisione = d_revisione_prec;
      end;
   
      /* Allinea PERIODI_DOTAZIONE alla nuova revisione
      La modifica a PEGI, provoca, tramite il trigger
      PEGI_PEDO_TMA, l'allineamento di PEDO */
      /*  update periodi_giuridici
         set ci = ci
       where nvl(al,to_date(3333333,'j')) >= d_dal_m
      ;*/
      delete from periodi_dotazione where revisione = d_revisione_o;
   
      insert into periodi_dotazione
         (ci
         ,rilevanza
         ,dal
         ,al
         ,gestione
         ,ore
         ,revisione
         ,door_id
         ,figura
         ,qualifica
         ,posizione
         ,revisione_prec
         ,door_id_prec
         ,attivita
         ,tipo_rapporto
         ,settore
         ,area
         ,codice_uo
         ,ruolo
         ,profilo
         ,pos_funz
         ,cod_figura
         ,cod_qualifica
         ,livello
         ,assenza
         ,di_ruolo
         ,incarico
         ,part_time
         ,evento
         ,ue
         ,unita_ni
         ,contrattista
         ,sovrannumero
         ,contratto
         ,ore_lavoro)
         select ci
               ,rilevanza
               ,dal
               ,al
               ,gestione
               ,ore
               ,d_revisione_o
               ,door_id
               ,figura
               ,qualifica
               ,posizione
               ,d_revisione_o
               ,door_id_prec
               ,attivita
               ,tipo_rapporto
               ,settore
               ,area
               ,codice_uo
               ,ruolo
               ,profilo
               ,pos_funz
               ,cod_figura
               ,cod_qualifica
               ,livello
               ,assenza
               ,di_ruolo
               ,incarico
               ,part_time
               ,evento
               ,ue
               ,unita_ni
               ,contrattista
               ,sovrannumero
               ,contratto
               ,ore_lavoro
           from periodi_dotazione
          where revisione = d_revisione_prec
            and nvl(al, to_date(3333333, 'j')) >= d_dal_o;
   exception
      when situazione_anomala then
         null;
   end acquisisci_revisione_prec;

   --
   procedure set_esaurimento
   (
      p_ci           in number
     ,p_rilevanza    in varchar2
     ,p_dal          in date
     ,p_gestione     in varchar2
     ,p_figura       in number
     ,p_qualifica    in number
     ,p_ore          in number
     ,p_utente       in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       SET_ESAURIMENTO
         PURPOSE:    Inserisce gli estremi del posto occupato dall'individuo come posto
                     ad esaurimento, da non replicare nella revisione successiva
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        11/06/2004                   1. Created this function.
      ******************************************************************************/
      d_revisione_a number(8);
      d_door_id     dotazione_organica.door_id%type;
      d_ore         periodi_giuridici.ore%type;
      d_ore_lav     periodi_giuridici.ore%type;
      d_ore_do      varchar2(1);
      d_dummy       varchar2(1);
      situazione_anomala exception;
   begin
      p_errore      := null;
      d_revisione_a := get_revisione_a;
   
      /* determina la revisione di dotazione attiva */
      if d_revisione_a is null then
         p_errore := 'P08007';
         -- Non esistono revisioni attive
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
   
      /* determina il door_id dell'individuo */
      d_door_id := gp4_pegi.get_pegi_door_id(p_ci, p_rilevanza, p_dal, d_revisione_a);
   
      if nvl(d_door_id, 0) = 0 then
         p_errore := 'P08057';
         -- attributi giuridici non previsti su DOOR
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
   
      /* Determina il tipo di calcolo delle ore per la gestione */
      d_ore_do := gp4_gest.get_ore_do(p_gestione);
   
      /* Determina le ore lavorate dall'individuo */
      if d_ore_do = 'U' then
         if p_rilevanza = 'S' then
            d_ore_lav := gp4_cost.get_ore_lavoro_divisione(p_qualifica, p_dal);
         elsif p_rilevanza = 'Q' then
            d_ore_lav := gp4_cost.get_ore_lavoro_divisione(gp4_figi.get_qualifica(p_figura
                                                                                 ,p_dal)
                                                          ,p_dal);
         end if;
      
         d_ore := nvl(p_ore, d_ore_lav) / d_ore_lav;
      else
         if p_rilevanza = 'S' then
            d_ore_lav := gp4_cost.get_ore_lavoro(p_qualifica, p_dal);
         elsif p_rilevanza = 'Q' then
            d_ore_lav := gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(p_figura, p_dal)
                                                ,p_dal);
         end if;
      
         d_ore := nvl(p_ore, d_ore_lav);
      end if;
   
      /* Inserisce la registrazione su DOTAZIONE_ESAURIMENTO se non gia presente */
      begin
         select 'x' into d_dummy from dotazione_esaurimento where ci = p_ci;
      
         raise too_many_rows;
      exception
         when no_data_found then
            insert into dotazione_esaurimento
               (ci
               ,revisione
               ,door_id
               ,utente
               ,data_agg
               ,numero
               ,numero_ore)
            values
               (p_ci
               ,d_revisione_a
               ,d_door_id
               ,p_utente
               ,sysdate
               ,1
               ,d_ore);
         when too_many_rows then
            p_errore := 'P08058';
            -- individuo gia ad esaurimento
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
      end;
   exception
      when situazione_anomala then
         rollback;
   end set_esaurimento;

   --
   function get_num_esaurimento
   (
      p_revisione in number
     ,p_door_id   in number
   ) return number is
      d_numero number;
      /******************************************************************************
         NAME:       GET_NUM_ESAURIMENTO
         PURPOSE:    Restituire il numero di posti ad esaurimento del gruppo di dotazione
                     indicato
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/06/2004                   1. Created this function.
      ******************************************************************************/
   begin
      d_numero := 0;
   
      begin
         select sum(numero)
           into d_numero
           from dotazione_esaurimento does
          where revisione = p_revisione
            and door_id = p_door_id
            and nvl(data_cessazione, to_date(2222222, 'j')) <=
                gp4_redo.get_dal_redo_modifica;
      exception
         when no_data_found then
            d_numero := 0;
            return d_numero;
      end;
   
      return nvl(d_numero, 0);
   end get_num_esaurimento;

   --
   function get_ore_esaurimento
   (
      p_revisione in number
     ,p_door_id   in number
   ) return number is
      d_numero number;
      /******************************************************************************
         NAME:       GET_ORE_ESAURIMENTO
         PURPOSE:    Restituire il numero delle ore prestate ad esaurimento del gruppo di dotazione
                     indicato
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/06/2004                   1. Created this function.
      ******************************************************************************/
   begin
      d_numero := 0;
   
      begin
         select sum(numero_ore)
           into d_numero
           from dotazione_esaurimento does
          where revisione = p_revisione
            and door_id = p_door_id
            and nvl(data_cessazione, to_date(2222222, 'j')) <=
                gp4_redo.get_dal_redo_modifica;
      exception
         when no_data_found then
            d_numero := 0;
            return d_numero;
      end;
   
      return nvl(d_numero, 0);
   end get_ore_esaurimento;

   --
   procedure chk_revisione_m
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_REVISIONE_M
         PURPOSE:    Controlla l'esistenza di differenze tra la revisione attiva (che deve essere duplicata) e
                     la revisione in modifica; da eseguire prima della cancellazione del contenuto della
                  revisione in modifica, per salvaguardare le modifiche manuali eseguite dopo una precedente
                  operazione di copia.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        12/08/2002          1. Created this function.
      ******************************************************************************/
      cursor cpk_dotazione_organica is
         select gestione || area || settore || ruolo || profilo || posizione || attivita ||
                figura || qualifica || livello || tipo_rapporto || ore || numero ||
                numero_ore || tipo
           from dotazione_organica
          where revisione = get_revisione_m
         minus
         select gestione || area || settore || ruolo || profilo || posizione || attivita ||
                figura || qualifica || livello || tipo_rapporto || ore || numero ||
                numero_ore || tipo
           from dotazione_organica
          where revisione = get_revisione_a;
   
      d_revisione_m number(8);
      d_revisione_a number(8);
      w_dummy       varchar2(100);
      found         boolean;
      situazione_anomala exception;
   begin
      p_errore := to_char(null);
      w_dummy  := to_char(null);
   
      begin
         select revisione into d_revisione_m from revisioni_dotazione where stato = 'M';
      exception
         when no_data_found then
            begin
               p_errore := 'P08005';
               -- Non esistono revisioni in modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
         when too_many_rows then
            begin
               p_errore := 'P08006';
               -- Esistono piu di una revisione in stato di modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
   
      begin
         select revisione into d_revisione_a from revisioni_dotazione where stato = 'A';
      exception
         when no_data_found then
            begin
               p_errore := 'P08007';
               -- Non esistono revisioni attive
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
         when too_many_rows then
            begin
               p_errore := 'P08008';
               -- Esistono piu di una revisione in stato attivo
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
   
      begin
         -- controllo di identita tra la revisione M e la revisione A
         open cpk_dotazione_organica;
      
         fetch cpk_dotazione_organica
            into w_dummy;
      
         found := cpk_dotazione_organica%found;
      
         close cpk_dotazione_organica;
      
         if found then
            p_errore       := 'P08035';
            p_segnalazione := si4.get_error(p_errore);
         end if;
      end;
   exception
      when situazione_anomala then
         rollback;
   end chk_revisione_m;

   --
   procedure chk_revisione_o
   (
      p_revisione    in number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_REVISIONE_O
         PURPOSE:    Controlla l'esistenza di differenze tra la revisione obsoleta che si vuole popolare e
                     la revisione immediatamente precedente che si vuole come modello.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        02/11/2005
      ******************************************************************************/
      d_revisione_o    number(8);
      d_revisione_prec number(8);
      d_dal_o          date;
      w_dummy          varchar2(100);
      found            boolean;
      situazione_anomala exception;
   
      cursor cpk_dotazione_organica is
         select gestione || area || settore || ruolo || profilo || posizione || attivita ||
                figura || qualifica || livello || tipo_rapporto || ore || numero ||
                numero_ore || tipo
           from dotazione_organica
          where revisione = d_revisione_o
         minus
         select gestione || area || settore || ruolo || profilo || posizione || attivita ||
                figura || qualifica || livello || tipo_rapporto || ore || numero ||
                numero_ore || tipo
           from dotazione_organica
          where revisione = d_revisione_prec;
   begin
      p_errore      := to_char(null);
      w_dummy       := to_char(null);
      d_revisione_o := p_revisione;
      d_dal_o       := gp4_redo.get_dal(p_revisione);
   
      begin
         select revisione
           into d_revisione_prec
           from revisioni_dotazione
          where stato = 'O'
            and dal = (select max(dal)
                         from revisioni_dotazione
                        where stato = 'O'
                          and dal < d_dal_o);
      exception
         when no_data_found then
            begin
               p_errore := 'P08054';
               -- Non esistono revisioni valide per l'acquisizione
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
   
      begin
         -- controllo di identita tra la revisione data e la revisione da duplicare
         open cpk_dotazione_organica;
      
         fetch cpk_dotazione_organica
            into w_dummy;
      
         found := cpk_dotazione_organica%found;
      
         close cpk_dotazione_organica;
      
         if found then
            p_errore       := 'P08035';
            p_segnalazione := si4.get_error(p_errore);
         end if;
      end;
   exception
      when situazione_anomala then
         rollback;
   end chk_revisione_o;

   --
   procedure chk_totale_ripartizione
   (
      p_rigd_id      in number
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_TOTALE_RIPARTIZIONE
         PURPOSE:
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        06/02/2004                1. Created this function.
      ******************************************************************************/
      d_tot_num_rigd number;
      d_tot_num_rgdo number;
      d_tot_ore_rigd number;
      d_tot_ore_rgdo number;
      situazione_anomala exception;
   begin
      p_segnalazione := to_char(null);
   
      begin
         /* Seleziono i dati del gruppo di dotazione */
         d_tot_ore_rigd := gp4_rigd.get_tot_ore(p_rigd_id);
         d_tot_num_rigd := gp4_rigd.get_tot_numero(p_rigd_id);
      
         /* Seleziono i totali di dotazione_organica relativi al gruppo */
         select sum(nvl(numero, 0))
               ,sum(nvl(numero_ore, 0))
           into d_tot_num_rgdo
               ,d_tot_ore_rgdo
           from dotazione_organica door
          where (revisione, door_id) in
                (select revisione
                       ,door_id
                   from righe_gruppi_dotazione
                  where rigd_id = p_rigd_id);
      
         if d_tot_num_rigd is null and d_tot_ore_rigd is null then
            raise situazione_anomala;
         end if;
      exception
         when no_data_found then
            raise situazione_anomala;
      end;
   
      if nvl(d_tot_num_rigd, 0) <> nvl(d_tot_num_rgdo, 0) or
         nvl(d_tot_ore_rigd, 0) <> nvl(d_tot_ore_rgdo, 0) then
         /* Abbiamo una squadratura */
         p_segnalazione := 'Esiste una differenza tra i totali del gruppo e la ripartizione linguistica dello stesso';
         raise situazione_anomala;
      else
         p_segnalazione := 'Totali di gruppo congruenti con la ripartizione linguistica';
      end if;
   exception
      when situazione_anomala then
         if p_segnalazione is null then
            p_segnalazione := 'Calcolo ripartizione non eseguito';
         end if;
   end chk_totale_ripartizione;

   --
   function conta_previsti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_tipo          in varchar2
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_numero number;
      /******************************************************************************
         NAME:       CONTA_PREVISTI
         PURPOSE:    Fornire il numero di individui previsti dalla dotazione teorica
                     per una certa revisione, ad una certa data, per gli attributi
                  giuridici indicati
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        26/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_numero := 0;
   
      if p_rilevanza in ('Q', 'I') then
         begin
            select decode(p_tipo, 'N', numero, 'O', numero_ore, to_number(null))
              into d_numero
              from dotazione_organica door
             where door.revisione = p_revisione
               and nvl(p_gestione, '%') like door.gestione
               and nvl(p_ruolo, '%') like door.ruolo
               and nvl(p_livello, '%') like door.livello
               and nvl(p_qualifica, '%') like door.qualifica
               and nvl(p_area, '%') like door.area
               and nvl(p_settore, '%') like door.settore
               and nvl(p_profilo, '%') like door.profilo
               and nvl(p_posizione, '%') like door.posizione
               and nvl(p_figura, '%') like door.figura
               and nvl(p_attivita, '%') like door.attivita
               and nvl(p_tipo_rapporto, '%') like door.tipo_rapporto
               and nvl(p_ore, 0) = nvl(door.ore, 0);
         exception
            when no_data_found then
               begin
                  d_numero := 0;
               end;
            when too_many_rows then
               begin
                  d_numero := 0;
               end;
         end;
      elsif p_rilevanza in ('S', 'E') then
         begin
            select decode(p_tipo, 'N', numero, 'O', numero_ore, to_number(null))
              into d_numero
              from dotazione_organica door
             where door.revisione = p_revisione
               and p_gestione like door.gestione
               and nvl(p_area, '%') like door.area
               and nvl(p_settore, '%') like door.settore
               and nvl(p_ruolo, '%') like door.ruolo
               and nvl(p_livello, '%') like door.livello
               and nvl(p_qualifica, '%') like door.qualifica
               and nvl(p_profilo, '%') like door.profilo
               and nvl(p_posizione, '%') like door.posizione
               and nvl(p_figura, '%') like door.figura
               and nvl(p_attivita, '%') like door.attivita
               and nvl(p_tipo_rapporto, '%') like door.tipo_rapporto
               and nvl(p_ore, 0) = nvl(door.ore, 0);
         exception
            when no_data_found then
               begin
                  d_numero := 0;
               end;
            when too_many_rows then
               begin
                  d_numero := 0;
               end;
         end;
      end if;
   
      return nvl(d_numero, 0);
   end conta_previsti_o;

   --
   function conta_previsti
   (
      p_revisione in number
     ,p_tipo      in varchar2
     ,p_door_id   in number
   ) return number is
      d_numero number;
      /******************************************************************************
         NAME:       CONTA_PREVISTI
         PURPOSE:    Fornire il numero di individui previsti dalla dotazione teorica
                     per una certa revisione, ad una certa data, per gli attributi
                     giuridici indicati
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         2.0        25/11/2004                   Introduzione di PEDO
      ******************************************************************************/
   begin
      d_numero := 0;
   
      begin
         select decode(p_tipo, 'N', numero, 'O', numero_ore, to_number(null))
           into d_numero
           from dotazione_organica door
          where door.revisione = p_revisione
            and door_id = p_door_id;
      exception
         when no_data_found then
            begin
               d_numero := 0;
            end;
         when too_many_rows then
            begin
               d_numero := 0;
            end;
      end;
   
      return nvl(d_numero, 0);
   end conta_previsti;

   --
   function conta_dotazione_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOTAZIONE
         PURPOSE:    Calcola il numero degli individui relativi ad un raggruppamento della dotazione teorica
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_ore_do := gp4_gest.get_ore_do(p_gestione);
      d_totale := 0;
   
      begin
         select decode(d_ore_do, 'U', sum(pedo.ue), count(ci))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and codice_uo like p_settore
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and pedo.door_id <> 0;
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
   
      return nvl(d_totale, 0);
   end conta_dotazione_o;

   --

   --
   function conta_dotazione
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOTAZIONE
         PURPOSE:    Calcola il numero degli individui relativi ad un raggruppamento della dotazione teorica
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and door_id = p_door_id
            and revisione = p_revisione
            and gestione = p_gestione;
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
   
      return nvl(d_totale, 0);
   end conta_dotazione;

   --
   function conta_dot_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_STRUTTURA
         PURPOSE:    Calcola il numero degli individui relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and pedo.door_id > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_struttura;

   --
   function conta_dot_ore_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_ORE_STRUTTURA
         PURPOSE:    Calcola il totale ore degli individui relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and pedo.door_id > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_ore_struttura;

   --
   function conta_dot_ruolo_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_RUOLO_STRUTTURA
         PURPOSE:    Calcola il numero degli individui di ruolo relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and door_id > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_ruolo_struttura;

   --
   function conta_dot_ore_ruolo_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_ORE_RUOLO_STRUTTURA
         PURPOSE:    Calcola il totale ore degli individui di ruolo relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_ore_ruolo_struttura;

   --
   function conta_dot_contr_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_CONTR_STRUTTURA
         PURPOSE:    Calcola il numero degli individui con contratto
                     d'opera relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and contrattista = 'SI'
            and pedo.door_id > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_contr_struttura;

   --
   function conta_dot_ore_contr_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_ORE_CONTR_STRUTTURA
         PURPOSE:    Calcola il totale ore degli individui a contratto d'opera
                     relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and contrattista = 'SI'
            and pedo.door_id > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_ore_contr_struttura;

   --
   function conta_dot_sovr_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_SOVR_STRUTTURA
         PURPOSE:    Calcola il numero degli individui in sovrannumero
                     relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        21/01/2005   CB          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and sovrannumero = 'SI'
            and pedo.door_id > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_sovr_struttura;

   --
   function conta_dot_ass_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_ASS_STRUTTURA
         PURPOSE:    Calcola il numero degli individui assenti
                      relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id > 0
            and exists (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'A'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                    and exists (select 'x'
                           from astensioni
                          where codice = pegi1.assenza
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
   
      return nvl(d_totale, 0);
   end conta_dot_ass_struttura;

   --
   function conta_dot_ore_ass_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_ORE_ASS_STRUTTURA
         PURPOSE:    Calcola il totale ore degli individui assenti
                     relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id > 0
            and exists (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'A'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                    and exists (select 'x'
                           from astensioni
                          where codice = pegi1.assenza
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
   
      return nvl(d_totale, 0);
   end conta_dot_ore_ass_struttura;

   --
   function conta_dot_inc_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_INC_STRUTTURA
         PURPOSE:    Calcola il numero degli individui incaricati
                      relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id > 0
            and exists
          (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'I'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data));
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
   
      return nvl(d_totale, 0);
   end conta_dot_inc_struttura;

   --
   function conta_dot_ore_inc_struttura
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_ORE_INC_STRUTTURA
         PURPOSE:    Calcola il totale ore degli individui incaricati
                     relativi ad un ramo della struttura settoriale
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and exists (select 'x'
                   from relazioni_uo
                  where codice_padre = p_settore
                    and gestione = p_gestione
                    and revisione = p_revisione_struttura
                    and figlio = pedo.unita_ni)
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id > 0
            and exists
          (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'I'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data));
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
   
      return nvl(d_totale, 0);
   end conta_dot_ore_inc_struttura;

   --
   function conta_dotazione_ling_o
   (
      p_revisione     in number
     ,p_gruppo_ling   in varchar2
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOTAZIONE_LING
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti relativi
                     ad una particolare definizione di dotazione appartenenti al gruppo
                  linguistico dato
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         if d_ore_do = 'U' then
            d_ore_lavoro := get_ore_lavoro_ue(p_data
                                             ,p_ruolo
                                             ,p_profilo
                                             ,p_posizione
                                             ,p_figura
                                             ,p_qualifica
                                             ,p_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise non_calcolabile;
            end if;
         end if;
      
         if p_rilevanza = 'S' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                             d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data)
                  and gp4_anag.get_gruppo_ling(gp4_rain.get_ni(pegi.ci)) = p_gruppo_ling;
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
         elsif p_rilevanza = 'Q' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal))) / d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like nvl(p_ruolo, '%')
                  and qugi.livello like nvl(p_livello, '%')
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                ,pegi.dal)
                                                         ,pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data)
                  and gp4_anag.get_gruppo_ling(gp4_rain.get_ni(pegi.ci)) = p_gruppo_ling;
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_dotazione_ling_o;

   --
   --
   function conta_dotazione_ling
   (
      p_revisione   in number
     ,p_gruppo_ling in varchar2
     ,p_rilevanza   in varchar2
     ,p_data        in date
     ,p_gestione    in varchar2
     ,p_door_id     in number
     ,p_ore_lavoro  in number
   ) return number is
      d_totale number;
      d_ore_do gestioni.ore_do%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOTAZIONE_LING
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti relativi
                     ad una particolare definizione di dotazione appartenenti al gruppo
                  linguistico dato
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and gp4_anag.get_gruppo_ling(gp4_rain.get_ni(pedo.ci)) = p_gruppo_ling;
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
   end conta_dotazione_ling;

   --
   function conta_dotazione_ling_ruolo_o
   (
      p_revisione     in number
     ,p_gruppo_ling   in varchar2
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOTAZIONE_LING
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti di ruolo relativi
                     ad una particolare definizione di dotazione appartenenti al gruppo
                  linguistico dato
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         if d_ore_do = 'U' then
            d_ore_lavoro := get_ore_lavoro_ue(p_data
                                             ,p_ruolo
                                             ,p_profilo
                                             ,p_posizione
                                             ,p_figura
                                             ,p_qualifica
                                             ,p_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise non_calcolabile;
            end if;
         end if;
      
         if p_rilevanza = 'S' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                             d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, to_date(3333333, 'j'))
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, to_date(3333333, 'j'))
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
                  and exists
                (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and gp4_anag.get_gruppo_ling(gp4_rain.get_ni(pegi.ci)) = p_gruppo_ling;
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
         elsif p_rilevanza = 'Q' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal))) / d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like nvl(p_ruolo, '%')
                  and qugi.livello like nvl(p_livello, '%')
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, to_date(3333333, 'j'))
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, to_date(3333333, 'j'))
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                ,pegi.dal)
                                                         ,pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
                  and exists
                (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and gp4_anag.get_gruppo_ling(gp4_rain.get_ni(pegi.ci)) = p_gruppo_ling;
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_dotazione_ling_ruolo_o;

   --
   --
   function conta_dotazione_ling_ruolo
   (
      p_revisione   in number
     ,p_gruppo_ling in varchar2
     ,p_rilevanza   in varchar2
     ,p_data        in date
     ,p_gestione    in varchar2
     ,p_door_id     in number
     ,p_ore_lavoro  in number
   ) return number is
      d_totale number;
      d_ore_do gestioni.ore_do%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOTAZIONE_LING_RUOLO
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti di ruolo relativi
                     ad una particolare definizione di dotazione appartenenti al gruppo
                  linguistico dato
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select decode(d_ore_do
                         ,'O'
                         ,sum(nvl(pedo.ore
                                 ,gp4_cost.get_ore_lavoro(nvl(pedo.qualifica
                                                             ,gp4_figi.get_qualifica(pedo.figura
                                                                                    ,pedo.dal))
                                                         ,pedo.dal)))
                         ,'U'
                         ,sum(nvl(pedo.ore
                                 ,gp4_cost.get_ore_lavoro(nvl(pedo.qualifica
                                                             ,gp4_figi.get_qualifica(pedo.figura
                                                                                    ,pedo.dal))
                                                         ,pedo.dal))) / p_ore_lavoro)
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and pedo.di_ruolo = 'SI'
               and gp4_anag.get_gruppo_ling(gp4_rain.get_ni(pedo.ci)) = p_gruppo_ling;
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
   end conta_dotazione_ling_ruolo;

   --
   function conta_dot_ruolo_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_RUOLO
         PURPOSE:    Fornire il numero dei dipendenti di ruolo per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_ore_do := gp4_gest.get_ore_do(p_gestione);
      d_totale := 0;
   
      begin
         select decode(d_ore_do, 'U', sum(pedo.ue), count(ci))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and codice_uo like p_settore
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id <> 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_ruolo_o;

   --
   --
   function conta_dot_ruolo
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_RUOLO
         PURPOSE:    Fornire il numero dei dipendenti di ruolo per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and pedo.di_ruolo = 'SI'
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and door_id = p_door_id
            and gestione = p_gestione;
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
   
      return nvl(d_totale, 0);
   end conta_dot_ruolo;

   --
   function conta_dot_non_ruolo_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_non_RUOLO
         PURPOSE:    Fornire il numero dei dipendenti non di ruolo per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      if p_rilevanza in ('S', 'E') then
         begin
            select count(ci)
              into d_totale
              from settori_amministrativi stam
                  ,figure_giuridiche      figi
                  ,qualifiche_giuridiche  qugi
                  ,periodi_giuridici      pegi
             where pegi.gestione like p_gestione
               and stam.codice || ' ' like p_settore
               and stam.numero = pegi.settore
               and qugi.ruolo || ' ' like p_ruolo
               and qugi.livello like p_livello
               and qugi.codice || ' ' like p_qualifica
               and qugi.numero = pegi.qualifica
               and p_data between qugi.dal and nvl(qugi.al, to_date(3333333, 'j'))
               and nvl(figi.profilo, '%') like p_profilo
               and nvl(figi.posizione, '%') like p_posizione
               and figi.codice || ' ' like p_figura
               and figi.numero = pegi.figura
               and p_data between figi.dal and nvl(figi.al, to_date(3333333, 'j'))
               and nvl(pegi.attivita, ' ') like p_attivita
               and nvl(pegi.tipo_rapporto, ' ') like p_tipo_rapporto
               and to_char(nvl(pegi.ore
                              ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                   nvl(to_char(p_ore), '%')
               and exists
             (select 'x'
                      from posizioni
                     where codice = pegi.posizione
                       and ruolo_do = 'NO')
               and rilevanza = p_rilevanza
               and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
               and pegi.ci > 0;
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
      elsif p_rilevanza in ('Q', 'I') then
         begin
            select count(ci)
              into d_totale
              from settori_amministrativi stam
                  ,figure_giuridiche      figi
                  ,qualifiche_giuridiche  qugi
                  ,periodi_giuridici      pegi
             where pegi.gestione like p_gestione
               and stam.codice like p_settore
               and stam.numero = pegi.settore
               and qugi.ruolo like nvl(p_ruolo, '%')
               and qugi.livello like nvl(p_livello, '%')
               and qugi.codice like p_qualifica
               and qugi.numero = figi.qualifica
               and p_data between qugi.dal and nvl(qugi.al, to_date(3333333, 'j'))
               and nvl(figi.profilo, '%') like p_profilo
               and nvl(figi.posizione, '%') like p_posizione
               and figi.codice like p_figura
               and figi.numero = pegi.figura
               and p_data between figi.dal and nvl(figi.al, to_date(3333333, 'j'))
               and nvl(pegi.attivita, ' ') like p_attivita
               and nvl(pegi.tipo_rapporto, ' ') like p_tipo_rapporto
               and to_char(nvl(pegi.ore
                              ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                             ,pegi.dal)
                                                      ,pegi.dal))) like
                   nvl(to_char(p_ore), '%')
               and exists
             (select 'x'
                      from posizioni
                     where codice = pegi.posizione
                       and ruolo_do = 'NO')
               and rilevanza = p_rilevanza
               and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'));
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
      end if;
   
      return nvl(d_totale, 0);
   end conta_dot_non_ruolo_o;

   --
   function conta_dot_non_ruolo
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_non_RUOLO
         PURPOSE:    Fornire il numero dei dipendenti non di ruolo per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and pedo.di_ruolo = 'NO'
            and rilevanza = p_rilevanza
            and pedo.gestione = p_gestione
            and pedo.door_id = p_door_id
            and pedo.revisione = p_revisione;
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
   
      return nvl(d_totale, 0);
   end conta_dot_non_ruolo;

   --
   function conta_dot_contrattisti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_CONTRATTISTI
         PURPOSE:    Fornire il numero dei CONTRATTISTI
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/06/2004                  1. Created this function.
      ******************************************************************************/
   begin
      d_ore_do := gp4_gest.get_ore_do(p_gestione);
      d_totale := 0;
   
      begin
         select decode(d_ore_do, 'U', sum(pedo.ue), count(ci))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and codice_uo like p_settore
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and contrattista = 'SI'
            and pedo.door_id <> 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_contrattisti_o;

   --
   function conta_dot_sovrannumero_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_SOVRANNUMERO_O
         PURPOSE:    Fornire il numero dei SOVRANNUMERO
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/06/2004                  1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and codice_uo like p_settore
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and sovrannumero = 'SI'
            and pedo.door_id <> 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_sovrannumero_o;

   --
   function conta_dot_contrattisti
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_CONTRATTISTI
         PURPOSE:    Fornire il numero dei CONTRATTISTI
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/06/2004                  1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and revisione = p_revisione
            and door_id = p_door_id
            and contrattista = 'SI'
            and rilevanza = p_rilevanza
            and pedo.gestione = p_gestione;
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
   
      return nvl(d_totale, 0);
   end conta_dot_contrattisti;

   --
   function conta_dot_sovrannumero
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_SOVRANNUMERO
         PURPOSE:    Fornire il numero dei SOVRANNUMERO
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/06/2004                  1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, to_date(3333333, 'j'))
            and revisione = p_revisione
            and door_id = p_door_id
            and sovrannumero = 'SI'
            and rilevanza = p_rilevanza
            and pedo.ci > 0;
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
   
      return nvl(d_totale, 0);
   end conta_dot_sovrannumero;

   --
   function conta_dot_assenti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_ASSENTI
         PURPOSE:    Fornire il numero dei dipendenti di ruolo assenti e sostituibili
                     per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_ore_do := gp4_gest.get_ore_do(p_gestione);
      d_totale := 0;
   
      begin
         select decode(d_ore_do, 'U', sum(pedo.ue), count(ci))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and gestione = p_gestione
            and codice_uo like p_settore
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id <> 0
            and exists (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'A'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                    and exists (select 'x'
                           from astensioni
                          where codice = pegi1.assenza
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
   
      return nvl(d_totale, 0);
   end conta_dot_assenti_o;

   --
   function conta_dot_assenti
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_ASSENTI
         PURPOSE:    Fornire il numero dei dipendenti di ruolo assenti e sostituibili
                     per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and door_id = p_door_id
            and gestione = p_gestione
            and di_ruolo = 'SI'
            and exists (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'A'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                    and exists (select 'x'
                           from astensioni
                          where codice = pegi1.assenza
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
   
      return nvl(d_totale, 0);
   end conta_dot_assenti;

   --
   function conta_dot_sostituiti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_SOSTITUITI
         PURPOSE:    Fornire il numero dei dipendenti di ruolo incaricati o assenti per
                     i quali e stato previsto un sostituto.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      if p_rilevanza = 'S' then
         begin
            select count(ci)
              into d_totale
              from settori_amministrativi stam
                  ,figure_giuridiche      figi
                  ,qualifiche_giuridiche  qugi
                  ,periodi_giuridici      pegi
             where pegi.gestione like p_gestione
               and stam.codice like p_settore
               and stam.numero = pegi.settore
               and qugi.ruolo like p_ruolo
               and qugi.livello like p_livello
               and qugi.codice like p_qualifica
               and qugi.numero = pegi.qualifica
               and p_data between qugi.dal and nvl(qugi.al, p_data)
               and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
               and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
               and figi.codice like p_figura
               and figi.numero = pegi.figura
               and p_data between figi.dal and nvl(figi.al, p_data)
               and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
               and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
               and to_char(nvl(pegi.ore
                              ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                   nvl(to_char(p_ore), '%')
               and rilevanza = p_rilevanza
               and p_data between pegi.dal and nvl(pegi.al, p_data)
               and exists (select 'x'
                      from posizioni
                     where codice = pegi.posizione
                       and ruolo_do = 'SI')
               and exists (select 'x'
                      from periodi_giuridici pegi1
                     where rilevanza in (select 'A'
                                           from dual
                                         union
                                         select 'I' from dual)
                       and ci = pegi.ci
                       and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                       and (rilevanza = 'I' or
                           (rilevanza = 'A' and exists
                            (select 'x'
                                from astensioni
                               where codice = pegi1.assenza
                                 and sostituibile = 1))))
               and exists
             (select 'x'
                      from periodi_giuridici pegi2
                     where rilevanza = 'S'
                       and pegi2.sostituto = pegi.ci
                       and p_data between pegi2.dal and nvl(pegi2.al, p_data));
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
      elsif p_rilevanza = 'Q' then
         begin
            select count(ci)
              into d_totale
              from settori_amministrativi stam
                  ,figure_giuridiche      figi
                  ,periodi_giuridici      pegi
             where pegi.gestione like p_gestione
               and stam.codice like p_settore
               and stam.numero = pegi.settore
               and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
               and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
               and figi.codice like p_figura
               and figi.numero = pegi.figura
               and p_data between figi.dal and nvl(figi.al, p_data)
               and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
               and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
               and to_char(nvl(pegi.ore
                              ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                             ,pegi.dal)
                                                      ,pegi.dal))) like
                   nvl(to_char(p_ore), '%')
               and exists (select 'x'
                      from posizioni
                     where codice = pegi.posizione
                       and ruolo_do = 'SI')
               and exists (select 'x'
                      from periodi_giuridici pegi1
                     where rilevanza in (select 'A'
                                           from dual
                                         union
                                         select 'I' from dual)
                       and ci = pegi.ci
                       and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                       and (rilevanza = 'I' or
                           (rilevanza = 'A' and exists
                            (select 'x'
                                from astensioni
                               where codice = pegi1.assenza
                                 and sostituibile = 1))))
               and exists (select 'x'
                      from periodi_giuridici pegi2
                     where rilevanza = p_rilevanza
                       and pegi2.sostituto = pegi.ci
                       and p_data between pegi2.dal and nvl(pegi2.al, p_data))
               and rilevanza = p_rilevanza
               and p_data between pegi.dal and nvl(pegi.al, p_data);
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
      end if;
   
      return nvl(d_totale, 0);
   end conta_dot_sostituiti_o;

   --
   function conta_dot_sostituiti
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_SOSTITUITI
         PURPOSE:    Fornire il numero dei dipendenti di ruolo incaricati o assenti per
                     i quali e stato previsto un sostituto.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and revisione = p_revisione
            and door_id = p_door_id
            and rilevanza = p_rilevanza
            and pedo.di_ruolo = 'SI'
            and pedo.gestione = p_gestione
            and exists (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza in (select 'A'
                                        from dual
                                      union
                                      select 'I' from dual)
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                    and (rilevanza = 'I' or
                        (rilevanza = 'A' and exists
                         (select 'x'
                             from astensioni
                            where codice = pegi1.assenza
                              and sostituibile = 1))))
            and exists
          (select 'x'
                   from periodi_giuridici pegi2
                  where rilevanza = 'S'
                    and pegi2.sostituto = pedo.ci
                    and p_data between pegi2.dal and nvl(pegi2.al, p_data));
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
   
      return nvl(d_totale, 0);
   end conta_dot_sostituiti;

   --
   function conta_ore_assenti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_ORE_ASSENTI
         PURPOSE:    Fornire il numero delle ore lavorate dei dipendenti di ruolo
                     assenti e sostituibili per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         if d_ore_do = 'U' then
            d_ore_lavoro := get_ore_lavoro_ue(p_data
                                             ,p_ruolo
                                             ,p_profilo
                                             ,p_posizione
                                             ,p_figura
                                             ,p_qualifica
                                             ,p_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise non_calcolabile;
            end if;
         end if;
      
         if p_rilevanza in ('E', 'S') then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                             d_ore_lavoro)
                 into d_totale
                 from periodi_giuridici      pegi
                     ,settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                where rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data)
                  and pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and exists
                (select 'x'
                         from periodi_giuridici pegi1
                        where rilevanza = 'A'
                          and ci = pegi.ci
                          and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                          and exists (select 'x'
                                 from astensioni
                                where codice = pegi1.assenza
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
         elsif p_rilevanza in ('Q', 'I') then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal))) / d_ore_lavoro)
                 into d_totale
                 from periodi_giuridici      pegi
                     ,settori_amministrativi stam
                     ,qualifiche_giuridiche  qugi
                     ,figure_giuridiche      figi
                where rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data)
                  and pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like nvl(p_ruolo, '%')
                  and qugi.livello like nvl(p_livello, '%')
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                ,pegi.dal)
                                                         ,pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and exists
                (select 'x'
                         from periodi_giuridici pegi1
                        where rilevanza = 'A'
                          and ci = pegi.ci
                          and p_data between pegi1.dal and nvl(pegi1.al, p_data)
                          and exists (select 'x'
                                 from astensioni
                                where codice = pegi1.assenza
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_assenti_o;

   --
   function conta_dot_incaricati_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale number;
      d_ore_do varchar2(1);
      /******************************************************************************
         NAME:       CONTA_DOT_INCARICATI
         PURPOSE:    Fornire il numero dei dipendenti di ruolo con un incarico non di ruolo
                     in un'altra posizione per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_ore_do := gp4_gest.get_ore_do(p_gestione);
      d_totale := 0;
   
      begin
         select decode(d_ore_do, 'U', sum(pedo.ue), count(ci))
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and rilevanza = p_rilevanza
            and revisione = p_revisione
            and gestione = p_gestione
            and codice_uo like p_settore
            and area like p_area
            and ruolo like p_ruolo
            and nvl(profilo, '%') like p_profilo
            and nvl(pos_funz, '%') like p_posizione
            and nvl(attivita, '%') like p_attivita
            and cod_figura like p_figura
            and cod_qualifica like p_qualifica
            and livello like p_livello
            and nvl(tipo_rapporto, '%') like p_tipo_rapporto
            and to_char(ore) like nvl(to_char(p_ore), '%')
            and di_ruolo = 'SI'
            and pedo.door_id <> 0
            and exists
          (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'I'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data));
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
   
      return nvl(d_totale, 0);
   end conta_dot_incaricati_o;

   --
   function conta_dot_incaricati
   (
      p_revisione in number
     ,p_rilevanza in varchar2
     ,p_data      in date
     ,p_gestione  in varchar2
     ,p_door_id   in number
   ) return number is
      d_totale number;
      /******************************************************************************
         NAME:       CONTA_DOT_INCARICATI
         PURPOSE:    Fornire il numero dei dipendenti di ruolo con un incarico non di ruolo
                     in un'altra posizione per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      begin
         select count(ci)
           into d_totale
           from periodi_dotazione pedo
          where p_data between pedo.dal and nvl(pedo.al, p_data)
            and revisione = p_revisione
            and door_id = p_door_id
            and rilevanza = p_rilevanza
            and gestione = p_gestione
            and di_ruolo = 'SI'
            and exists
          (select 'x'
                   from periodi_giuridici pegi1
                  where rilevanza = 'E'
                    and ci = pedo.ci
                    and p_data between pegi1.dal and nvl(pegi1.al, p_data));
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
   
      return nvl(d_totale, 0);
   end conta_dot_incaricati;

   --
   function conta_ore_incaricati_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_ORE_INCARICATI
         PURPOSE:    Fornire il numero delle ore lavorate dei dipendenti di ruolo INCARICATI
                     per una certa definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         if d_ore_do = 'U' then
            d_ore_lavoro := get_ore_lavoro_ue(p_data
                                             ,p_ruolo
                                             ,p_profilo
                                             ,p_posizione
                                             ,p_figura
                                             ,p_qualifica
                                             ,p_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise non_calcolabile;
            end if;
         end if;
      
         if p_rilevanza in ('E', 'S') then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                             d_ore_lavoro)
                 into d_totale
                 from periodi_giuridici      pegi
                     ,settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                where rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data)
                  and pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and nvl(to_char(pegi.ore), '%') like nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and exists
                (select 'x'
                         from periodi_giuridici pegi1
                        where rilevanza = 'I'
                          and ci = pegi.ci
                          and p_data between pegi1.dal and nvl(pegi1.al, p_data));
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
         elsif p_rilevanza in ('Q', 'I') then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal))) / d_ore_lavoro)
                 into d_totale
                 from periodi_giuridici      pegi
                     ,settori_amministrativi stam
                     ,qualifiche_giuridiche  qugi
                     ,figure_giuridiche      figi
                where rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data)
                  and pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and qugi.ruolo like nvl(p_ruolo, '%')
                  and qugi.livello like nvl(p_livello, '%')
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and stam.numero = pegi.settore
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and nvl(to_char(pegi.ore), '%') like nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and exists
                (select 'x'
                         from periodi_giuridici pegi1
                        where rilevanza = 'I'
                          and ci = pegi.ci
                          and p_data between pegi1.dal and nvl(pegi1.al, p_data));
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_incaricati_o;

   --
   --
   function conta_ore_incaricati
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
      /******************************************************************************
         NAME:       CONTA_ORE_ASSENTI
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti relativi
                     ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        11/08/2004
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
      
         begin
            d_ore_do := gp4_gest.get_ore_do(p_gestione);
         
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where rilevanza = p_rilevanza
               and door_id = p_door_id
               and revisione = p_revisione
               and gestione = p_gestione
               and p_data between pedo.dal and nvl(pedo.al, p_data)
               and pedo.di_ruolo = 'SI'
               and exists
             (select 'x'
                      from periodi_giuridici pegi
                     where rilevanza = 'I'
                       and ci = pedo.ci
                       and p_data between pegi.dal and nvl(pegi.al, p_data));
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
   end conta_ore_incaricati;

   --
   function conta_dot_ore
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
      /******************************************************************************
         NAME:       CONTA_DOT_ORE
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti relativi
                     ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        11/08/2004
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
      
         begin
            d_ore_do := gp4_gest.get_ore_do(p_gestione);
         
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where rilevanza = p_rilevanza
               and door_id = p_door_id
               and revisione = p_revisione
               and gestione = p_gestione
               and p_data between pedo.dal and nvl(pedo.al, p_data);
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
   end conta_dot_ore;

   --
   function conta_ore_assenti
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
      /******************************************************************************
         NAME:       CONTA_ORE_ASSENTI
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti relativi
                     ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        11/08/2004
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
      
         begin
            d_ore_do := gp4_gest.get_ore_do(p_gestione);
         
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where rilevanza = p_rilevanza
               and door_id = p_door_id
               and revisione = p_revisione
               and p_data between pedo.dal and nvl(pedo.al, p_data)
               and gestione = p_gestione
               and di_ruolo = 'SI'
               and exists (select 'x'
                      from periodi_giuridici pegi
                     where rilevanza = 'A'
                       and ci = pedo.ci
                       and p_data between pegi.dal and nvl(pegi.al, p_data)
                       and exists (select 'x'
                              from astensioni
                             where codice = pegi.assenza
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
   end conta_ore_assenti;

   --
   function conta_dot_ore_o
   (
      p_revisione           in number
     ,p_rilevanza           in varchar2
     ,p_data                in date
     ,p_gestione            in varchar2
     ,p_area                in varchar2
     ,p_settore             in varchar2
     ,p_ruolo               in varchar2
     ,p_profilo             in varchar2
     ,p_posizione           in varchar2
     ,p_attivita            in varchar2
     ,p_figura              in varchar2
     ,p_qualifica           in varchar2
     ,p_livello             in varchar2
     ,p_tipo_rapporto       in varchar2
     ,p_ore                 in number
     ,p_revisione_struttura in number
     ,p_ore_lavoro          in number
   ) return number is
      d_totale number;
      d_ore_do gestioni.ore_do%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOT_ORE
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti relativi
                     ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
      
         begin
            d_ore_do := gp4_gest.get_ore_do(p_gestione);
         
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, p_data)
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and gestione = p_gestione
               and exists (select 'x'
                      from relazioni_uo
                     where codice_padre = p_settore
                       and gestione = p_gestione
                       and revisione = p_revisione_struttura
                       and figlio = pedo.unita_ni)
               and area like p_area
               and ruolo like p_ruolo
               and nvl(profilo, '%') like p_profilo
               and nvl(pos_funz, '%') like p_posizione
               and nvl(attivita, '%') like p_attivita
               and cod_figura like p_figura
               and cod_qualifica like p_qualifica
               and livello like p_livello
               and nvl(tipo_rapporto, '%') like p_tipo_rapporto
               and to_char(ore) like nvl(to_char(p_ore), '%')
               and pedo.door_id <> 0;
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
   end conta_dot_ore_o;

   --
   --
   function conta_dot_ruolo_ore
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
      /******************************************************************************
         NAME:       CONTA_DOT_RUOLO_ORE
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti di ruolo
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where door_id = p_door_id
               and revisione = p_revisione
               and di_ruolo = 'SI'
               and gestione = p_gestione
               and rilevanza = p_rilevanza
               and p_data between pedo.dal and nvl(pedo.al, p_data);
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
   end conta_dot_ruolo_ore;

   --
   function conta_dot_ruolo_ore_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOT_RUOLO_ORE
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti di ruolo
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         if d_ore_do = 'U' then
            d_ore_lavoro := get_ore_lavoro_ue(p_data
                                             ,p_ruolo
                                             ,p_profilo
                                             ,p_posizione
                                             ,p_figura
                                             ,p_qualifica
                                             ,p_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise non_calcolabile;
            end if;
         end if;
      
         if p_rilevanza = 'S' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                             d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         elsif p_rilevanza = 'Q' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal))) / d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                ,pegi.dal)
                                                         ,pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_dot_ruolo_ore_o;

   --
   function conta_ore_non_ruolo_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_ORE_NON_RUOLO
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti non di ruolo
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         if d_ore_do = 'U' then
            d_ore_lavoro := get_ore_lavoro_ue(p_data
                                             ,p_ruolo
                                             ,p_profilo
                                             ,p_posizione
                                             ,p_figura
                                             ,p_qualifica
                                             ,p_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise non_calcolabile;
            end if;
         end if;
      
         if p_rilevanza = 'S' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                             d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'NO')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         elsif p_rilevanza = 'Q' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal))) / d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                ,pegi.dal)
                                                         ,pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'NO')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_non_ruolo_o;

   --
   function conta_ore_non_ruolo
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
      /******************************************************************************
         NAME:       CONTA_ORE_NON_RUOLO
         PURPOSE:    Fornire il totale delle ore prestate dai dipendenti non di ruolo
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/08/2002          1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, p_data)
               and di_ruolo = 'NO'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and gestione = p_gestione;
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
   end conta_ore_non_ruolo;

   --
   function conta_ore_contrattisti_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_do     gestioni.ore_do%type;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_ORE_CONTRATTISTI
         PURPOSE:    Fornire il totale delle ore prestate dai contrattisti
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/06/2004                  1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         if d_ore_do = 'U' then
            d_ore_lavoro := get_ore_lavoro_ue(p_data
                                             ,p_ruolo
                                             ,p_profilo
                                             ,p_posizione
                                             ,p_figura
                                             ,p_qualifica
                                             ,p_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise non_calcolabile;
            end if;
         end if;
      
         if p_rilevanza = 'S' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                             d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         elsif p_rilevanza = 'Q' then
            begin
               select decode(d_ore_do
                            ,'O'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal)))
                            ,'U'
                            ,sum(nvl(pegi.ore
                                    ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                   ,pegi.dal)
                                                            ,pegi.dal))) / d_ore_lavoro)
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                ,pegi.dal)
                                                         ,pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'NO'
                          and contratto_opera = 'SI')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return d_totale;
      end;
   end conta_ore_contrattisti_o;

   --
   function conta_ore_contrattisti
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
      /******************************************************************************
         NAME:       CONTA_ORE_CONTRATTISTI
         PURPOSE:    Fornire il totale delle ore prestate dai contrattisti
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/06/2004                  1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, p_data)
               and contrattista = 'SI'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and gestione = p_gestione;
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
   end conta_ore_contrattisti;

   --
   function conta_ore_sovrannumero
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
      /******************************************************************************
         NAME:       CONTA_ORE_SOVRANNUMERO
         PURPOSE:    Fornire il totale delle ore prestate dai sovrannumero
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/06/2004                  1. Created this function.
      ******************************************************************************/
   begin
      begin
         d_totale := 0;
         d_ore_do := gp4_gest.get_ore_do(p_gestione);
      
         begin
            select decode(d_ore_do, 'O', sum(pedo.ore), 'U', sum(pedo.ue))
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, p_data)
               and sovrannumero = 'SI'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id;
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
   end conta_ore_sovrannumero;

   --
   function conta_dot_ue_o
   (
      p_revisione     in number
     ,p_rilevanza     in varchar2
     ,p_data          in date
     ,p_gestione      in varchar2
     ,p_area          in varchar2
     ,p_settore       in varchar2
     ,p_ruolo         in varchar2
     ,p_profilo       in varchar2
     ,p_posizione     in varchar2
     ,p_attivita      in varchar2
     ,p_figura        in varchar2
     ,p_qualifica     in varchar2
     ,p_livello       in varchar2
     ,p_tipo_rapporto in varchar2
     ,p_ore           in number
   ) return number is
      d_totale     number;
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOT_UE
         PURPOSE:    Fornire il totale dei dipendenti (intesi come unita equivalenti)
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        29/01/2004                   1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      /* Determina il contratto di lavoro e le ore settimanali in base ai parametri
         forniti. Se si rilevano valori contraddittori, termina con d_totale nullo
        Si da per scontato che non e possibile mescolare parametri economici, quali
        livello e qualifica, con parametri giuridici (figura, profilo, posizione)
      */
      begin
         if p_figura || p_profilo || p_posizione = '%%%' and
            p_qualifica || p_livello || p_ruolo <> '%%%' then
            -- parametri economici
            begin
               select distinct ore_lavoro
                 into d_ore_lavoro
                 from contratti_storici cost
                where contratto in
                      (select contratto
                         from qualifiche_giuridiche
                        where codice like p_qualifica
                          and livello like p_livello
                          and ruolo like p_ruolo
                          and p_data between dal and nvl(al, p_data))
                  and p_data between cost.dal and nvl(cost.al, p_data);
            exception
               when no_data_found or too_many_rows then
                  raise non_calcolabile;
            end;
         elsif p_figura || p_profilo || p_posizione <> '%%%' and
               p_qualifica || p_livello || p_ruolo = '%%%' then
            -- parametri giuridici
            begin
               select distinct ore_lavoro
                 into d_ore_lavoro
                 from contratti_storici cost
                where contratto in
                      (select contratto
                         from qualifiche_giuridiche
                        where numero in
                              (select qualifica
                                 from figure_giuridiche
                                where p_data between dal and nvl(al, p_data)
                                  and codice like p_figura
                                  and nvl(profilo, '%') like p_profilo
                                  and nvl(posizione, '%') like p_posizione)
                          and p_data between dal and nvl(al, p_data))
                  and p_data between cost.dal and nvl(cost.al, p_data);
            exception
               when no_data_found or too_many_rows then
                  raise non_calcolabile;
            end;
         else
            raise non_calcolabile;
         end if;
      
         /* Determina il numero di unita equivalenti presenti alla data per gli attributi giuridici indicati
         */
         if p_rilevanza = 'S' then
            -- situazione di fatto
            begin
               select sum(nvl(pegi.ore, gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) /
                      d_ore_lavoro
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = pegi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(pegi.qualifica, pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         elsif p_rilevanza = 'Q' then
            -- situazione di diritto
            begin
               select sum(nvl(pegi.ore
                             ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                            ,pegi.dal)
                                                     ,pegi.dal))) / d_ore_lavoro
                 into d_totale
                 from settori_amministrativi stam
                     ,figure_giuridiche      figi
                     ,qualifiche_giuridiche  qugi
                     ,periodi_giuridici      pegi
                where pegi.gestione like p_gestione
                  and stam.codice like p_settore
                  and stam.numero = pegi.settore
                  and qugi.ruolo like p_ruolo
                  and qugi.livello like p_livello
                  and qugi.codice like p_qualifica
                  and qugi.numero = figi.qualifica
                  and p_data between qugi.dal and nvl(qugi.al, p_data)
                  and nvl(figi.profilo, '%') like nvl(p_profilo, '%')
                  and nvl(figi.posizione, '%') like nvl(p_posizione, '%')
                  and figi.codice like p_figura
                  and figi.numero = pegi.figura
                  and p_data between figi.dal and nvl(figi.al, p_data)
                  and nvl(pegi.attivita, ' ') like nvl(p_attivita, '%')
                  and nvl(pegi.tipo_rapporto, ' ') like nvl(p_tipo_rapporto, '%')
                  and to_char(nvl(pegi.ore
                                 ,gp4_cost.get_ore_lavoro(gp4_figi.get_qualifica(pegi.figura
                                                                                ,pegi.dal)
                                                         ,pegi.dal))) like
                      nvl(to_char(p_ore), '%')
                  and exists (select 'x'
                         from posizioni
                        where codice = pegi.posizione
                          and ruolo_do = 'SI')
                  and rilevanza = p_rilevanza
                  and p_data between pegi.dal and nvl(pegi.al, p_data);
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
         end if;
      
         return round(nvl(d_totale, 0), 5);
      exception
         when non_calcolabile then
            d_totale := 0;
            return round(nvl(d_totale, 0), 5);
      end;
   end conta_dot_ue_o;

   --
   function conta_dot_ue
   (
      p_revisione  in number
     ,p_rilevanza  in varchar2
     ,p_data       in date
     ,p_gestione   in varchar2
     ,p_door_id    in number
     ,p_ore_lavoro in number
   ) return number is
      d_totale number;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       CONTA_DOT_UE
         PURPOSE:    Fornire il totale dei dipendenti (intesi come unita equivalenti)
                     relativi ad una particolare definizione di dotazione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        29/01/2004                   1. Created this function.
      ******************************************************************************/
   begin
      d_totale := 0;
   
      /* Determina il contratto di lavoro e le ore settimanali in base ai parametri
         forniti. Se si rilevano valori contraddittori, termina con d_totale nullo
        Si da per scontato che non e possibile mescolare parametri economici, quali
        livello e qualifica, con parametri giuridici (figura, profilo, posizione)
      */
      begin
         /* Determina il numero di unita equivalenti presenti alla data per gli attributi giuridici indicati
         */
         begin
            select sum(pedo.ue)
              into d_totale
              from periodi_dotazione pedo
             where p_data between pedo.dal and nvl(pedo.al, p_data)
               and di_ruolo = 'SI'
               and rilevanza = p_rilevanza
               and revisione = p_revisione
               and door_id = p_door_id
               and gestione = p_gestione;
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
            return round(nvl(d_totale, 0), 5);
      end;
   end conta_dot_ue;

   --
   function get_ore_lavoro_ue
   (
      p_data      in date
     ,p_ruolo     in varchar2
     ,p_profilo   in varchar2
     ,p_posizione in varchar2
     ,p_figura    in varchar2
     ,p_qualifica in varchar2
     ,p_livello   in varchar2
   ) return number is
      d_ore_lavoro contratti_storici.ore_lavoro%type;
      non_calcolabile exception;
      /******************************************************************************
         NAME:       GET_ORE_LAVORO_UE
         PURPOSE:    Restituisce il numero di ore contrattuali per la tipologia di dipendenti
                     individuati dai parametri forniti.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        29/01/2004                   1. Created this function.
      ******************************************************************************/
   begin
      /* Determina il contratto di lavoro e le ore settimanali in base ai parametri
         forniti. Se si rilevano valori contraddittori, termina con d_totale nullo
        Si da per scontato che non e possibile mescolare parametri economici, quali
        livello e qualifica, con parametri giuridici (figura, profilo, posizione)
      */
      begin
         if p_figura || p_profilo || p_posizione = '%%%' and
            p_qualifica || p_livello || p_ruolo <> '%%%' then
            -- parametri economici
            begin
               select distinct ore_lavoro
                 into d_ore_lavoro
                 from contratti_storici cost
                where contratto in
                      (select contratto
                         from qualifiche_giuridiche
                        where codice like p_qualifica
                          and livello || '' like p_livello
                          and ruolo || '' like p_ruolo
                          and p_data between dal and nvl(al, p_data))
                  and p_data between cost.dal and nvl(cost.al, p_data);
            exception
               when no_data_found or too_many_rows then
                  raise non_calcolabile;
            end;
         elsif p_figura || p_profilo || p_posizione <> '%%%' and
               p_qualifica || p_livello || p_ruolo = '%%%' then
            -- parametri giuridici
            begin
               select distinct ore_lavoro
                 into d_ore_lavoro
                 from contratti_storici cost
                where contratto in
                      (select contratto
                         from qualifiche_giuridiche
                        where numero in
                              (select qualifica
                                 from figure_giuridiche
                                where p_data between dal and nvl(al, p_data)
                                  and codice like p_figura
                                  and nvl(profilo, '%') like p_profilo
                                  and nvl(posizione, '%') like p_posizione)
                          and p_data between dal and nvl(al, p_data))
                  and p_data between cost.dal and nvl(cost.al, p_data);
            exception
               when no_data_found or too_many_rows then
                  raise non_calcolabile;
            end;
         else
            raise non_calcolabile;
         end if;
      
         return d_ore_lavoro;
      exception
         when non_calcolabile then
            d_ore_lavoro := 0;
            return d_ore_lavoro;
      end;
   end get_ore_lavoro_ue;

   --
   procedure get_individui
   (
      p_diritto_fatto     in varchar2
     ,p_gestione          in varchar2
     ,p_utente            in varchar2
     ,p_revisione         in number
     ,p_ore               in varchar2
     ,p_tipo_rapporto     in varchar2
     ,p_qualifica         in varchar2
     ,p_livello           in varchar2
     ,p_figura            in varchar2
     ,p_attivita          in varchar2
     ,p_profilo           in varchar2
     ,p_pos_funz          in varchar2
     ,p_settore           in varchar2
     ,p_area              in varchar2
     ,p_part_time         in varchar2
     ,p_incaricati        in varchar2
     ,p_assenti           in varchar2
     ,p_assenza           in varchar2
     ,p_di_ruolo          in varchar2
     ,p_ruolo             in varchar2
     ,p_posizione         in varchar2
     ,p_livello_struttura in number
     ,c_individui         in out individui
   ) is
      d_revisione_struttura revisioni_struttura.revisione%type;
      d_suddivisione        suddivisioni_struttura.livello%type;
   begin
      d_revisione_struttura := gp4gm.get_revisione(gp4_rido.get_data(p_utente));
      d_suddivisione        := gp4_sust.get_suddivisione(p_livello_struttura);
   
      begin
         if p_livello_struttura is null then
            open c_individui for
               select utente
                     ,revisione
                     ,provenienza
                     ,nominativo
                     ,ci
                     ,dal
                     ,al
                     ,evento
                     ,posizione_ind
                     ,decode(ore_ind, '%', to_number(null), to_number(ore_ind))
                     ,assenza
                     ,di_ruolo
                     ,incarico
                     ,gestione
                     ,area
                     ,settore
                     ,ruolo
                     ,profilo
                     ,posizione
                     ,attivita
                     ,figura
                     ,qualifica
                     ,livello
                     ,tipo_rapporto
                     ,decode(ore, '%', to_number(null), to_number(ore))
                     ,assunto_part_time
                 from dotazione_nominativa_diritto
                where nvl(posizione_ind, '%') like
                      decode(p_posizione, null, nvl(posizione_ind, '%'), p_posizione)
                  and ((assenza is not null and assenza like nvl(p_assenza, '%')) or
                       (assenza is null and p_assenza is null))
                  and (decode(nvl(assenza, '0'), '0', '0', '1') = nvl(p_assenti, '0') or
                       p_assenti is null)
                  and di_ruolo = decode(p_di_ruolo, 'S', 'SI', 'N', 'NO', 'X', di_ruolo)
                  and (decode(nvl(incarico, '0'), '0', '0', '1') = nvl(p_incaricati, '0') or
                       p_incaricati is null)
                  and (p_part_time = '-' and part_time is not null or
                       p_part_time = part_time or p_part_time is null)
                  and nvl(area, '%') like p_area
                  and nvl(settore, '%') like p_settore
                  and nvl(profilo, '%') like p_profilo
                  and nvl(posizione, '%') like p_pos_funz
                  and nvl(attivita, '%') like p_attivita
                  and nvl(figura, '%') like p_figura
                  and nvl(qualifica, '%') like p_qualifica
                  and nvl(livello, '%') like p_livello
                  and nvl(ruolo, '%') like p_ruolo
                  and nvl(tipo_rapporto, '%') like p_tipo_rapporto
                  and nvl(to_char(ore_ind), '%') like nvl(p_ore, '%')
                  and revisione = p_revisione
                  and utente = p_utente
                  and gestione = p_gestione
                  and p_diritto_fatto = 'D'
               union
               select utente
                     ,revisione
                     ,provenienza
                     ,nominativo
                     ,ci
                     ,dal
                     ,al
                     ,evento
                     ,posizione_ind
                     ,decode(ore_ind, '%', to_number(null), to_number(ore_ind))
                     ,assenza
                     ,di_ruolo
                     ,incarico
                     ,gestione
                     ,area
                     ,settore
                     ,ruolo
                     ,profilo
                     ,posizione
                     ,attivita
                     ,figura
                     ,qualifica
                     ,livello
                     ,tipo_rapporto
                     ,decode(ore, '%', to_number(null), to_number(ore))
                     ,assunto_part_time
                 from dotazione_nominativa_fatto
                where nvl(posizione_ind, '%') like
                      decode(p_posizione, null, nvl(posizione_ind, '%'), p_posizione)
                  and ((assenza is not null and assenza like nvl(p_assenza, '%')) or
                       (assenza is null and p_assenza is null))
                  and (decode(nvl(assenza, '0'), '0', '0', '1') = nvl(p_assenti, '0') or
                       p_assenti is null)
                  and di_ruolo = decode(p_di_ruolo, 'S', 'SI', 'N', 'NO', 'X', di_ruolo)
                  and (decode(nvl(incarico, '0'), '0', '0', '1') = nvl(p_incaricati, '0') or
                       p_incaricati is null)
                  and (p_part_time = '-' and part_time is not null or
                       p_part_time = part_time or p_part_time is null)
                  and nvl(area, '%') like p_area
                  and nvl(settore, '%') like p_settore
                  and nvl(profilo, '%') like p_profilo
                  and nvl(posizione, '%') like p_pos_funz
                  and nvl(attivita, '%') like p_attivita
                  and nvl(figura, '%') like p_figura
                  and nvl(qualifica, '%') like p_qualifica
                  and nvl(livello, '%') like p_livello
                  and nvl(ruolo, '%') like p_ruolo
                  and nvl(tipo_rapporto, '%') like p_tipo_rapporto
                  and nvl(to_char(ore_ind), '%') like nvl(p_ore, '%')
                  and revisione = p_revisione
                  and utente = p_utente
                  and gestione = p_gestione
                  and p_diritto_fatto = 'F';
         else
            /* seleziona tutti gli individui con settore figlio di quello dato */
            null;
         
            open c_individui for
               select dond.utente
                     ,dond.revisione
                     ,dond.provenienza
                     ,dond.nominativo
                     ,dond.ci
                     ,dond.dal
                     ,dond.al
                     ,dond.evento
                     ,dond.posizione_ind
                     ,decode(dond.ore_ind, '%', to_number(null), to_number(dond.ore_ind))
                     ,dond.assenza
                     ,dond.di_ruolo
                     ,dond.incarico
                     ,dond.gestione
                     ,dond.area
                     ,dond.settore
                     ,dond.ruolo
                     ,dond.profilo
                     ,dond.posizione
                     ,dond.attivita
                     ,dond.figura
                     ,dond.qualifica
                     ,dond.livello
                     ,dond.tipo_rapporto
                     ,decode(dond.ore, '%', to_number(null), to_number(dond.ore))
                     ,assunto_part_time
                 from dotazione_nominativa_diritto dond
                     ,relazioni_uo                 reuo
                where nvl(dond.posizione_ind, '%') like
                      decode(p_posizione, null, nvl(dond.posizione_ind, '%'), p_posizione)
                  and ((assenza is not null and assenza like nvl(p_assenza, '%')) or
                       (assenza is null and p_assenza is null))
                  and (decode(nvl(assenza, '0'), '0', '0', '1') = nvl(p_assenti, '0') or
                       p_assenti is null)
                  and dond.di_ruolo =
                      decode(p_di_ruolo, 'S', 'SI', 'N', 'NO', 'X', dond.di_ruolo)
                  and (decode(nvl(incarico, '0'), '0', '0', '1') = nvl(p_incaricati, '0') or
                       p_incaricati is null)
                  and (p_part_time = '-' and part_time is not null or
                       p_part_time = part_time or p_part_time is null)
                  and nvl(dond.area, '%') like p_area
                  and reuo.revisione = d_revisione_struttura
                  and reuo.suddivisione_padre = d_suddivisione
                  and reuo.gestione = p_gestione
                  and reuo.codice_padre = p_settore
                  and dond.settore = reuo.codice_figlio
                  and nvl(dond.profilo, '%') like p_profilo
                  and nvl(dond.posizione, '%') like p_pos_funz
                  and nvl(dond.attivita, '%') like p_attivita
                  and nvl(dond.figura, '%') like p_figura
                  and nvl(dond.qualifica, '%') like p_qualifica
                  and nvl(dond.livello, '%') like p_livello
                  and nvl(dond.ruolo, '%') like p_ruolo
                  and nvl(dond.tipo_rapporto, '%') like p_tipo_rapporto
                  and nvl(to_char(dond.ore_ind), '%') like nvl(p_ore, '%')
                  and dond.revisione = p_revisione
                  and dond.utente = p_utente
                  and dond.gestione = p_gestione
                  and p_diritto_fatto = 'D'
               union
               select donf.utente
                     ,donf.revisione
                     ,donf.provenienza
                     ,donf.nominativo
                     ,donf.ci
                     ,donf.dal
                     ,donf.al
                     ,donf.evento
                     ,donf.posizione_ind
                     ,decode(donf.ore_ind, '%', to_number(null), to_number(donf.ore_ind))
                     ,donf.assenza
                     ,donf.di_ruolo
                     ,donf.incarico
                     ,donf.gestione
                     ,donf.area
                     ,donf.settore
                     ,donf.ruolo
                     ,donf.profilo
                     ,donf.posizione
                     ,donf.attivita
                     ,donf.figura
                     ,donf.qualifica
                     ,donf.livello
                     ,donf.tipo_rapporto
                     ,decode(donf.ore, '%', to_number(null), to_number(donf.ore))
                     ,assunto_part_time
                 from dotazione_nominativa_fatto donf
                     ,relazioni_uo               reuo
                where nvl(donf.posizione_ind, '%') like
                      decode(p_posizione, null, nvl(donf.posizione_ind, '%'), p_posizione)
                  and ((assenza is not null and assenza like nvl(p_assenza, '%')) or
                       (assenza is null and p_assenza is null))
                  and (decode(nvl(assenza, '0'), '0', '0', '1') = nvl(p_assenti, '0') or
                       p_assenti is null)
                  and donf.di_ruolo =
                      decode(p_di_ruolo, 'S', 'SI', 'N', 'NO', 'X', donf.di_ruolo)
                  and (decode(nvl(incarico, '0'), '0', '0', '1') = nvl(p_incaricati, '0') or
                       p_incaricati is null)
                  and (p_part_time = '-' and part_time is not null or
                       p_part_time = part_time or p_part_time is null)
                  and nvl(donf.area, '%') like p_area
                  and reuo.revisione = d_revisione_struttura
                  and reuo.suddivisione_padre = d_suddivisione
                  and reuo.gestione = p_gestione
                  and reuo.codice_padre = p_settore
                  and donf.settore = reuo.codice_figlio
                  and nvl(donf.profilo, '%') like p_profilo
                  and nvl(donf.posizione, '%') like p_pos_funz
                  and nvl(donf.attivita, '%') like p_attivita
                  and nvl(donf.figura, '%') like p_figura
                  and nvl(donf.qualifica, '%') like p_qualifica
                  and nvl(donf.livello, '%') like p_livello
                  and nvl(donf.ruolo, '%') like p_ruolo
                  and nvl(donf.tipo_rapporto, '%') like p_tipo_rapporto
                  and nvl(to_char(donf.ore_ind), '%') like nvl(p_ore, '%')
                  and donf.revisione = p_revisione
                  and donf.utente = p_utente
                  and donf.gestione = p_gestione
                  and p_diritto_fatto = 'F';
         end if;
      end;
   end get_individui;

   --
   procedure get_dotazione
   (
      p_diritto_fatto     in varchar2
     ,p_gestione          in varchar2
     ,p_utente            in varchar2
     ,p_revisione         in number
     ,p_scostamenti       in varchar2
     ,p_livello_struttura in varchar2
     ,p_modalita          in varchar2
     ,p_id                in number
     ,c_dotazione         in out dotazione
     ,p_area              in varchar2
     ,p_settore           in varchar2
     ,p_ruolo             in varchar2
     ,p_profilo           in varchar2
     ,p_posizione         in varchar2
     ,p_attivita          in varchar2
     ,p_figura            in varchar2
     ,p_qualifica         in varchar2
     ,p_livello           in varchar2
     ,p_tipo_rapporto     in varchar2
     ,p_ore               in varchar2
   ) is
      d_ore_do              gestioni.ore_do%type;
      d_ore_lavoro          contratti_storici.ore_lavoro%type;
      d_data                date;
      d_revisione_struttura revisioni_struttura.revisione%type;
      d_suddivisione        suddivisioni_struttura.livello%type;
      d_effettivi           number;
      d_ore_effettive       number;
      d_ruolo               number;
      d_non_ruolo           number;
      d_assenti             number;
      d_incaricati          number;
      d_contrattisti        number;
      d_sovrannumero        number;
      d_numero              number;
      d_numero_ore          number;
      d_diff_numero         number;
      d_diff_ore            number;
      d_ore                 varchar2(8);
      d_provenienza         varchar2(1);
      d_filtro_settore      varchar2(2);
      d_area                dotazione_organica.area%type;
      d_settore             dotazione_organica.settore%type;
      d_settore_padre       dotazione_organica.settore%type;
      d_ruolo_ret           dotazione_organica.ruolo%type;
      d_profilo             dotazione_organica.profilo%type;
      d_posizione           dotazione_organica.posizione%type;
      d_attivita            dotazione_organica.attivita%type;
      d_figura              dotazione_organica.figura%type;
      d_qualifica           dotazione_organica.qualifica%type;
      d_livello             dotazione_organica.livello%type;
      d_tipo_rapporto       dotazione_organica.tipo_rapporto%type;
      dp_ore                varchar2(8);
      dp_area               dotazione_organica.area%type;
      dp_settore            dotazione_organica.settore%type;
      dp_ruolo              dotazione_organica.ruolo%type;
      dp_profilo            dotazione_organica.profilo%type;
      dp_posizione          dotazione_organica.posizione%type;
      dp_attivita           dotazione_organica.attivita%type;
      dp_figura             dotazione_organica.figura%type;
      dp_qualifica          dotazione_organica.qualifica%type;
      dp_livello            dotazione_organica.livello%type;
      dp_tipo_rapporto      dotazione_organica.tipo_rapporto%type;
      situazione_anomala exception;
   begin
      d_data := gp4_rido.get_data(p_utente);
      /* Determino il tipo di calcolo in ore richiesto per la Gestione */
      d_ore_do              := nvl(gp4_gest.get_ore_do(p_gestione), 'U');
      d_revisione_struttura := gp4gm.get_revisione(d_data);
      d_filtro_settore      := gp4_gest.get_filtro_settori(p_gestione);
      dp_ore                := nvl(p_ore, '%');
      dp_area               := nvl(p_area, '%');
      dp_settore            := nvl(p_settore, '%');
      dp_ruolo              := nvl(p_ruolo, '%');
      dp_profilo            := nvl(p_profilo, '%');
      dp_posizione          := nvl(p_posizione, '%');
      dp_attivita           := nvl(p_attivita, '%');
      dp_figura             := nvl(p_figura, '%');
      dp_qualifica          := nvl(p_qualifica, '%');
      dp_livello            := nvl(p_livello, '%');
      dp_tipo_rapporto      := nvl(p_tipo_rapporto, '%');
   
      if p_modalita = 'I' then
         if p_livello_struttura is null then
            /* non viene richiesto alcun raggruppamento per livello di settore;
            l'interrogazione viene eseguita secondo la modalita precedente */
            open c_dotazione for
               select p_utente
                     ,door.revisione
                     ,door.gestione
                     ,'D'
                     ,door.door_id
                     ,to_char(null)
                     ,door.ore
                     ,door.area
                     ,door.settore
                     ,door.ruolo
                     ,door.profilo
                     ,door.posizione
                     ,door.attivita
                     ,door.figura
                     ,door.qualifica
                     ,door.livello
                     ,door.tipo_rapporto
                     ,nvl(door.numero, door.numero_ore) numero
                     ,decode(d_ore_do
                            ,'U'
                            ,round(gp4do.conta_dot_ruolo_ore(door.revisione
                                                            ,p_diritto_fatto
                                                            ,d_data
                                                            ,door.gestione
                                                            ,door.door_id
                                                            ,gp4do.get_ore_lavoro_ue(d_data
                                                                                    ,door.ruolo
                                                                                    ,door.profilo
                                                                                    ,door.posizione
                                                                                    ,door.figura
                                                                                    ,door.qualifica
                                                                                    ,door.livello))
                                  ,1)
                            ,gp4do.conta_dot_ruolo(door.revisione
                                                  ,p_diritto_fatto
                                                  ,d_data
                                                  ,door.gestione
                                                  ,door.door_id)) di_ruolo
                     ,decode(d_ore_do
                            ,'U'
                            ,round(gp4do.conta_ore_assenti(door.revisione
                                                          ,p_diritto_fatto
                                                          ,d_data
                                                          ,door.gestione
                                                          ,door.door_id
                                                          ,gp4do.get_ore_lavoro_ue(d_data
                                                                                  ,door.ruolo
                                                                                  ,door.profilo
                                                                                  ,door.posizione
                                                                                  ,door.figura
                                                                                  ,door.qualifica
                                                                                  ,door.livello))
                                  ,1)
                            ,gp4do.conta_dot_assenti(door.revisione
                                                    ,p_diritto_fatto
                                                    ,d_data
                                                    ,door.gestione
                                                    ,door.door_id)) assenti
                     ,decode(d_ore_do
                            ,'U'
                            ,round(gp4do.conta_ore_incaricati(door.revisione
                                                             ,p_diritto_fatto
                                                             ,d_data
                                                             ,door.gestione
                                                             ,door.door_id
                                                             ,gp4do.get_ore_lavoro_ue(d_data
                                                                                     ,door.ruolo
                                                                                     ,door.profilo
                                                                                     ,door.posizione
                                                                                     ,door.figura
                                                                                     ,door.qualifica
                                                                                     ,door.livello))
                                  ,1)
                            ,gp4do.conta_dot_incaricati(door.revisione
                                                       ,p_diritto_fatto
                                                       ,d_data
                                                       ,door.gestione
                                                       ,door.door_id)) incaricati
                     ,decode(d_ore_do
                            ,'U'
                            ,round(gp4do.conta_ore_non_ruolo(door.revisione
                                                            ,p_diritto_fatto
                                                            ,d_data
                                                            ,door.gestione
                                                            ,door.door_id
                                                            ,gp4do.get_ore_lavoro_ue(d_data
                                                                                    ,door.ruolo
                                                                                    ,door.profilo
                                                                                    ,door.posizione
                                                                                    ,door.figura
                                                                                    ,door.qualifica
                                                                                    ,door.livello))
                                  ,1)
                            ,gp4do.conta_dot_non_ruolo(door.revisione
                                                      ,p_diritto_fatto
                                                      ,d_data
                                                      ,door.gestione
                                                      ,door.door_id)) non_ruolo
                     ,decode(d_ore_do
                            ,'U'
                            ,round(gp4do.conta_ore_contrattisti(door.revisione
                                                               ,p_diritto_fatto
                                                               ,d_data
                                                               ,door.gestione
                                                               ,door.door_id
                                                               ,gp4do.get_ore_lavoro_ue(d_data
                                                                                       ,door.ruolo
                                                                                       ,door.profilo
                                                                                       ,door.posizione
                                                                                       ,door.figura
                                                                                       ,door.qualifica
                                                                                       ,door.livello))
                                  ,1)
                            ,gp4do.conta_dot_contrattisti(door.revisione
                                                         ,p_diritto_fatto
                                                         ,d_data
                                                         ,door.gestione
                                                         ,door.door_id)) contrattisti
                     ,round(decode(d_ore_do
                                  ,'U'
                                  ,round(gp4do.conta_dot_ore(door.revisione
                                                            ,p_diritto_fatto
                                                            ,d_data
                                                            ,door.gestione
                                                            ,door.door_id
                                                            ,gp4do.get_ore_lavoro_ue(d_data
                                                                                    ,door.ruolo
                                                                                    ,door.profilo
                                                                                    ,door.posizione
                                                                                    ,door.figura
                                                                                    ,door.qualifica
                                                                                    ,door.livello))
                                        ,1)
                                  ,gp4do.conta_dotazione(door.revisione
                                                        ,p_diritto_fatto
                                                        ,d_data
                                                        ,door.gestione
                                                        ,door.door_id))
                           ,1) effettivi
                     ,gp4do.conta_dotazione(door.revisione
                                           ,p_diritto_fatto
                                           ,d_data
                                           ,door.gestione
                                           ,door.door_id) - door.numero diff_numero
                     ,round(gp4do.conta_dot_ore(revisione
                                               ,p_diritto_fatto
                                               ,d_data
                                               ,door.gestione
                                               ,door.door_id
                                               ,gp4do.get_ore_lavoro_ue(d_data
                                                                       ,door.ruolo
                                                                       ,door.profilo
                                                                       ,door.posizione
                                                                       ,door.figura
                                                                       ,door.qualifica
                                                                       ,door.livello)) -
                            door.numero_ore
                           ,2) diff_ore
                     ,to_number(null) id
                     ,decode(d_ore_do
                            ,'U'
                            ,round(gp4do.conta_ore_sovrannumero(door.revisione
                                                               ,p_diritto_fatto
                                                               ,d_data
                                                               ,door.gestione
                                                               ,door.door_id
                                                               ,gp4do.get_ore_lavoro_ue(d_data
                                                                                       ,door.ruolo
                                                                                       ,door.profilo
                                                                                       ,door.posizione
                                                                                       ,door.figura
                                                                                       ,door.qualifica
                                                                                       ,door.livello))
                                  ,1)
                            ,gp4do.conta_dot_sovrannumero(door.revisione
                                                         ,p_diritto_fatto
                                                         ,d_data
                                                         ,door.gestione
                                                         ,door.door_id)) sovrannumero
                 from dotazione_organica door
                where door.revisione = p_revisione
                  and door.gestione like p_gestione
                  and door.area like dp_area
                  and door.settore like dp_settore
                  and door.ruolo like dp_ruolo
                  and door.profilo like dp_profilo
                  and door.posizione like dp_posizione
                  and door.attivita like dp_attivita
                  and door.figura like dp_figura
                  and door.qualifica like dp_qualifica
                  and door.livello like dp_livello
                  and door.tipo_rapporto like dp_tipo_rapporto
                  and nvl(to_char(door.ore), '%') like dp_ore
               union
               select p_utente
                     ,pedo.revisione
                     ,pedo.gestione
                     ,'G'
                     ,0
                     ,to_char(null) --posizione_ind
                     ,pedo.ore
                     ,to_char(null) area
                     ,pedo.codice_uo
                     ,nvl(pedo.ruolo, '%')
                     ,nvl(pedo.profilo, '%')
                     ,nvl(pedo.pos_funz, '%')
                     ,nvl(pedo.attivita, '%')
                     ,pedo.cod_figura
                     ,pedo.cod_qualifica
                     ,pedo.livello
                     ,nvl(pedo.tipo_rapporto, '%')
                     ,0
                     ,round(decode(nvl(d_ore_do, 'O')
                                  ,'O'
                                  ,sum(decode(pedo.di_ruolo, 'SI', 1, 0))
                                  ,sum(decode(pedo.di_ruolo, 'SI', pedo.ue, 0)))
                           ,1) di_ruolo
                     ,round(decode(nvl(d_ore_do, 'O')
                                  ,'O'
                                  ,sum(gp4gm.get_se_assente(pedo.ci, d_data))
                                  ,sum(decode(gp4gm.get_se_assente(pedo.ci, d_data)
                                             ,1
                                             ,pedo.ue)))
                           ,1) assenti
                     ,round(decode(nvl(d_ore_do, 'O')
                                  ,'O'
                                  ,sum(gp4gm.get_se_incaricato(pedo.ci, d_data))
                                  ,sum(decode(gp4gm.get_se_incaricato(pedo.ci, d_data)
                                             ,1
                                             ,pedo.ue)))
                           ,1) incaricati
                     ,round(decode(nvl(d_ore_do, 'O')
                                  ,'O'
                                  ,sum(decode(pedo.di_ruolo, 'NO', 1, 0))
                                  ,sum(decode(pedo.di_ruolo, 'NO', pedo.ue, 0)))
                           ,1) non_ruolo
                     ,round(decode(nvl(d_ore_do, 'O')
                                  ,'O'
                                  ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                             ,'SI'
                                             ,1
                                             ,0))
                                  ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                             ,'SI'
                                             ,pedo.ue
                                             ,0)))
                           ,1) contrattisti
                     ,round(decode(nvl(d_ore_do, 'O'), 'O', count(ci), sum(pedo.ue)), 1) effettivi
                     ,count(ci) diff_numero
                     ,round(decode(nvl(d_ore_do, 'O'), 'O', sum(pedo.ore), sum(pedo.ue))
                           ,1) diff_ore
                     ,to_number(null) id
                     ,round(decode(nvl(d_ore_do, 'O')
                                  ,'O'
                                  ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                             ,'SI'
                                             ,1
                                             ,0))
                                  ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                             ,'SI'
                                             ,pedo.ue
                                             ,0)))
                           ,1) sovrannumero
                 from periodi_dotazione pedo
                where pedo.door_id = 0
                  and pedo.revisione = p_revisione
                  and pedo.gestione = p_gestione
                  and pedo.rilevanza = p_diritto_fatto
                  and pedo.ci > 0
                  and d_data between pedo.dal and nvl(pedo.al, d_data)
                  and pedo.codice_uo like dp_settore
                  and pedo.ruolo like dp_ruolo
                  and nvl(pedo.profilo, '%') || '' like dp_profilo
                  and nvl(pedo.pos_funz, '%') like dp_posizione
                  and pedo.attivita like dp_attivita
                  and pedo.cod_figura like dp_figura
                  and pedo.cod_qualifica like dp_qualifica
                  and pedo.livello like dp_livello
                  and pedo.tipo_rapporto like dp_tipo_rapporto
                  and nvl(to_char(pedo.ore), '%') like dp_ore
                group by pedo.revisione
                        ,pedo.gestione
                        ,pedo.codice_uo
                        ,pedo.ruolo
                        ,pedo.profilo
                        ,pedo.pos_funz
                        ,pedo.attivita
                        ,pedo.cod_figura
                        ,pedo.cod_qualifica
                        ,pedo.livello
                        ,pedo.tipo_rapporto
                        ,pedo.ore
                order by 4
                        ,14
                        ,13
                        ,9;
         else
            /* raggruppamento sul livello dato */
            begin
               delete from calcoli_do where door_id in (0, 1);
            
               d_suddivisione := gp4_sust.get_suddivisione(p_livello_struttura);
            
               insert into calcoli_do
                  (utente
                  ,data
                  ,revisione
                  ,door_id
                  ,provenienza
                  ,gestione
                  ,area
                  ,settore
                  ,unita_ni
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
                  ,effettivi
                  ,di_ruolo
                  ,assenti
                  ,incaricati
                  ,non_ruolo
                  ,contrattisti
                  ,sovrannumero
                  ,diff_numero
                  ,diff_ore)
                  select p_utente
                        ,d_data
                        ,p_revisione
                        ,1
                        ,'D'
                        ,p_gestione
                        ,door.area
                        ,reuo.codice_padre
                        ,reuo.padre
                        ,door.ruolo
                        ,door.profilo
                        ,door.posizione
                        ,door.attivita
                        ,door.figura
                        ,door.qualifica
                        ,door.livello
                        ,door.tipo_rapporto
                        ,door.ore
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                    from dotazione_organica door
                        ,relazioni_uo       reuo
                   where door.revisione = p_revisione
                     and door.gestione = p_gestione
                     and reuo.revisione = d_revisione_struttura
                     and reuo.suddivisione_padre = d_suddivisione
                     and door.area like dp_area
                     and decode(d_filtro_settore, 'SI', door.settore, reuo.codice_padre) like
                         dp_settore
                     and door.ruolo like dp_ruolo
                     and door.profilo like dp_profilo
                     and door.posizione like dp_posizione
                     and door.attivita like dp_attivita
                     and door.figura like dp_figura
                     and door.qualifica like dp_qualifica
                     and door.livello like dp_livello
                     and door.tipo_rapporto like dp_tipo_rapporto
                     and nvl(to_char(door.ore), '%') like dp_ore
                   group by door.area
                           ,reuo.codice_padre
                           ,reuo.padre
                           ,door.ruolo
                           ,door.profilo
                           ,door.posizione
                           ,door.attivita
                           ,door.figura
                           ,door.qualifica
                           ,door.livello
                           ,door.tipo_rapporto
                           ,door.ore
                  union
                  select p_utente
                        ,d_data
                        ,p_revisione
                        ,0
                        ,'G'
                        ,pedo.gestione
                        ,to_char(null) --area
                        ,reuo.codice_padre
                        ,reuo.padre
                        ,nvl(pedo.ruolo, '%')
                        ,nvl(pedo.profilo, '%')
                        ,nvl(pedo.pos_funz, '%')
                        ,nvl(pedo.attivita, '%')
                        ,pedo.cod_figura
                        ,pedo.cod_qualifica
                        ,pedo.livello
                        ,nvl(pedo.tipo_rapporto, '%')
                        ,pedo.ore
                        ,0 --count(ci)
                        ,0 --pedo.ore
                        ,decode(nvl(d_ore_do, 'O'), 'O', count(ci), sum(pedo.ue)) effettivi
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(pedo.di_ruolo, 'SI', 1, 0))
                               ,sum(decode(pedo.di_ruolo, 'SI', pedo.ue, 0))) di_ruolo
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(gp4gm.get_se_assente(pedo.ci, d_data))
                               ,sum(decode(gp4gm.get_se_assente(pedo.ci, d_data)
                                          ,1
                                          ,pedo.ue))) assenti
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(gp4gm.get_se_incaricato(pedo.ci, d_data))
                               ,sum(decode(gp4gm.get_se_incaricato(pedo.ci, d_data)
                                          ,1
                                          ,pedo.ue))) incaricati
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(pedo.di_ruolo, 'NO', 1, 0))
                               ,sum(decode(pedo.di_ruolo, 'NO', pedo.ue, 0))) non_ruolo
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                          ,'SI'
                                          ,1
                                          ,0))
                               ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                          ,'SI'
                                          ,pedo.ue
                                          ,0))) contrattisti
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                          ,'SI'
                                          ,1
                                          ,0))
                               ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                          ,'SI'
                                          ,pedo.ue
                                          ,0))) sovrannumero
                        ,count(ci) diff_numero
                        ,decode(nvl(d_ore_do, 'O'), 'O', sum(pedo.ore), sum(pedo.ue)) diff_ore
                    from periodi_dotazione pedo
                        ,relazioni_uo      reuo
                   where pedo.rilevanza = p_diritto_fatto
                     and d_data between pedo.dal and nvl(pedo.al, d_data)
                     and pedo.revisione = p_revisione
                     and pedo.gestione = p_gestione
                     and reuo.gestione = pedo.gestione
                     and pedo.door_id = 0
                     and reuo.revisione = d_revisione_struttura
                     and reuo.suddivisione_padre = d_suddivisione
                     and pedo.unita_ni = reuo.figlio
                     and decode(d_filtro_settore, 'SI', pedo.codice_uo, reuo.codice_padre) like
                         dp_settore
                     and pedo.ruolo like dp_ruolo
                     and nvl(pedo.profilo, '%') like dp_profilo
                     and nvl(pedo.pos_funz, '%') like dp_posizione
                     and pedo.attivita like dp_attivita
                     and pedo.cod_figura like dp_figura
                     and pedo.cod_qualifica like dp_qualifica
                     and pedo.livello like dp_livello
                     and pedo.tipo_rapporto like dp_tipo_rapporto
                     and nvl(to_char(pedo.ore), '%') like dp_ore
                   group by pedo.revisione
                           ,pedo.gestione
                           ,reuo.codice_padre
                           ,reuo.padre
                           ,pedo.ruolo
                           ,pedo.profilo
                           ,pedo.pos_funz
                           ,pedo.attivita
                           ,pedo.cod_figura
                           ,pedo.cod_qualifica
                           ,pedo.livello
                           ,pedo.tipo_rapporto
                           ,pedo.ore;
            
               update calcoli_do cado
                  set (numero, numero_ore) = (select sum(numero)
                                                    ,sum(numero_ore)
                                                from dotazione_organica door
                                               where door.revisione = p_revisione
                                                 and door.gestione = p_gestione
                                                 and area = cado.area
                                                 and ruolo = cado.ruolo
                                                 and profilo = cado.profilo
                                                 and posizione = cado.posizione
                                                 and attivita = cado.attivita
                                                 and figura = cado.figura
                                                 and qualifica = cado.qualifica
                                                 and livello = cado.livello
                                                 and tipo_rapporto = cado.tipo_rapporto
                                                 and nvl(to_char(ore), '%') like
                                                     nvl(to_char(cado.ore), '%')
                                                 and exists
                                               (select 'x'
                                                        from relazioni_uo
                                                       where codice_padre = cado.settore
                                                         and revisione =
                                                             d_revisione_struttura
                                                         and codice_figlio like door.settore
                                                         and gestione = p_gestione))
                where provenienza = 'D'
                  and door_id in (0, 1);
            
               delete from calcoli_do
                where numero is null
                  and numero_ore is null
                  and provenienza = 'D'
                  and door_id = 1;
            
               update calcoli_do set id = rownum;
            
               for cado in (select gestione
                                  ,area
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
                                  ,rowid
                              from calcoli_do
                             where utente = p_utente
                               and data = d_data
                               and revisione = p_revisione
                               and gestione = p_gestione
                               and provenienza = 'D'
                               and door_id in (0, 1))
               loop
                  if d_ore_do <> 'U' then
                     d_effettivi    := gp4do.conta_dot_struttura(p_revisione
                                                                ,p_diritto_fatto
                                                                ,d_data
                                                                ,cado.gestione
                                                                ,cado.area
                                                                ,cado.settore
                                                                ,cado.ruolo
                                                                ,cado.profilo
                                                                ,cado.posizione
                                                                ,cado.attivita
                                                                ,cado.figura
                                                                ,cado.qualifica
                                                                ,cado.livello
                                                                ,cado.tipo_rapporto
                                                                ,cado.ore
                                                                ,d_revisione_struttura);
                     d_ruolo        := gp4do.conta_dot_ruolo_struttura(p_revisione
                                                                      ,p_diritto_fatto
                                                                      ,d_data
                                                                      ,cado.gestione
                                                                      ,cado.area
                                                                      ,cado.settore
                                                                      ,cado.ruolo
                                                                      ,cado.profilo
                                                                      ,cado.posizione
                                                                      ,cado.attivita
                                                                      ,cado.figura
                                                                      ,cado.qualifica
                                                                      ,cado.livello
                                                                      ,cado.tipo_rapporto
                                                                      ,cado.ore
                                                                      ,d_revisione_struttura);
                     d_non_ruolo    := d_effettivi - d_ruolo;
                     d_contrattisti := gp4do.conta_dot_contr_struttura(p_revisione
                                                                      ,p_diritto_fatto
                                                                      ,d_data
                                                                      ,cado.gestione
                                                                      ,cado.area
                                                                      ,cado.settore
                                                                      ,cado.ruolo
                                                                      ,cado.profilo
                                                                      ,cado.posizione
                                                                      ,cado.attivita
                                                                      ,cado.figura
                                                                      ,cado.qualifica
                                                                      ,cado.livello
                                                                      ,cado.tipo_rapporto
                                                                      ,cado.ore
                                                                      ,d_revisione_struttura);
                     d_sovrannumero := gp4do.conta_dot_sovr_struttura(p_revisione
                                                                     ,p_diritto_fatto
                                                                     ,d_data
                                                                     ,cado.gestione
                                                                     ,cado.area
                                                                     ,cado.settore
                                                                     ,cado.ruolo
                                                                     ,cado.profilo
                                                                     ,cado.posizione
                                                                     ,cado.attivita
                                                                     ,cado.figura
                                                                     ,cado.qualifica
                                                                     ,cado.livello
                                                                     ,cado.tipo_rapporto
                                                                     ,cado.ore
                                                                     ,d_revisione_struttura);
                     d_assenti      := gp4do.conta_dot_ass_struttura(p_revisione
                                                                    ,p_diritto_fatto
                                                                    ,d_data
                                                                    ,cado.gestione
                                                                    ,cado.area
                                                                    ,cado.settore
                                                                    ,cado.ruolo
                                                                    ,cado.profilo
                                                                    ,cado.posizione
                                                                    ,cado.attivita
                                                                    ,cado.figura
                                                                    ,cado.qualifica
                                                                    ,cado.livello
                                                                    ,cado.tipo_rapporto
                                                                    ,cado.ore
                                                                    ,d_revisione_struttura);
                     d_incaricati   := gp4do.conta_dot_inc_struttura(p_revisione
                                                                    ,p_diritto_fatto
                                                                    ,d_data
                                                                    ,cado.gestione
                                                                    ,cado.area
                                                                    ,cado.settore
                                                                    ,cado.ruolo
                                                                    ,cado.profilo
                                                                    ,cado.posizione
                                                                    ,cado.attivita
                                                                    ,cado.figura
                                                                    ,cado.qualifica
                                                                    ,cado.livello
                                                                    ,cado.tipo_rapporto
                                                                    ,cado.ore
                                                                    ,d_revisione_struttura);
                     d_ore_lavoro   := get_ore_lavoro_ue(d_data
                                                        ,cado.ruolo
                                                        ,cado.profilo
                                                        ,cado.posizione
                                                        ,cado.figura
                                                        ,cado.qualifica
                                                        ,cado.livello);
                  
                     if nvl(d_ore_lavoro, 0) = 0 then
                        raise situazione_anomala;
                     end if;
                  
                     d_ore_effettive := gp4do.conta_dot_ore_struttura(p_revisione
                                                                     ,p_diritto_fatto
                                                                     ,d_data
                                                                     ,cado.gestione
                                                                     ,cado.area
                                                                     ,cado.settore
                                                                     ,cado.ruolo
                                                                     ,cado.profilo
                                                                     ,cado.posizione
                                                                     ,cado.attivita
                                                                     ,cado.figura
                                                                     ,cado.qualifica
                                                                     ,cado.livello
                                                                     ,cado.tipo_rapporto
                                                                     ,cado.ore
                                                                     ,d_revisione_struttura
                                                                     ,d_ore_lavoro);
                     d_diff_numero   := d_effettivi - cado.numero;
                     d_diff_ore      := d_ore_effettive - cado.numero_ore;
                  else
                     /* Calcolo ad unita equivalenti */
                     d_effettivi    := gp4do.conta_dot_ore_struttura(p_revisione
                                                                    ,p_diritto_fatto
                                                                    ,d_data
                                                                    ,cado.gestione
                                                                    ,cado.area
                                                                    ,cado.settore
                                                                    ,cado.ruolo
                                                                    ,cado.profilo
                                                                    ,cado.posizione
                                                                    ,cado.attivita
                                                                    ,cado.figura
                                                                    ,cado.qualifica
                                                                    ,cado.livello
                                                                    ,cado.tipo_rapporto
                                                                    ,cado.ore
                                                                    ,d_revisione_struttura
                                                                    ,d_ore_lavoro);
                     d_ruolo        := gp4do.conta_dot_ore_ruolo_struttura(p_revisione
                                                                          ,p_diritto_fatto
                                                                          ,d_data
                                                                          ,cado.gestione
                                                                          ,cado.area
                                                                          ,cado.settore
                                                                          ,cado.ruolo
                                                                          ,cado.profilo
                                                                          ,cado.posizione
                                                                          ,cado.attivita
                                                                          ,cado.figura
                                                                          ,cado.qualifica
                                                                          ,cado.livello
                                                                          ,cado.tipo_rapporto
                                                                          ,cado.ore
                                                                          ,d_revisione_struttura
                                                                          ,d_ore_lavoro);
                     d_non_ruolo    := d_effettivi - d_ruolo;
                     d_contrattisti := gp4do.conta_dot_ore_contr_struttura(p_revisione
                                                                          ,p_diritto_fatto
                                                                          ,d_data
                                                                          ,cado.gestione
                                                                          ,cado.area
                                                                          ,cado.settore
                                                                          ,cado.ruolo
                                                                          ,cado.profilo
                                                                          ,cado.posizione
                                                                          ,cado.attivita
                                                                          ,cado.figura
                                                                          ,cado.qualifica
                                                                          ,cado.livello
                                                                          ,cado.tipo_rapporto
                                                                          ,cado.ore
                                                                          ,d_revisione_struttura
                                                                          ,d_ore_lavoro);
                     d_sovrannumero := gp4do.conta_dot_sovr_struttura(p_revisione
                                                                     ,p_diritto_fatto
                                                                     ,d_data
                                                                     ,cado.gestione
                                                                     ,cado.area
                                                                     ,cado.settore
                                                                     ,cado.ruolo
                                                                     ,cado.profilo
                                                                     ,cado.posizione
                                                                     ,cado.attivita
                                                                     ,cado.figura
                                                                     ,cado.qualifica
                                                                     ,cado.livello
                                                                     ,cado.tipo_rapporto
                                                                     ,cado.ore
                                                                     ,d_revisione_struttura);
                     d_assenti      := gp4do.conta_dot_ore_ass_struttura(p_revisione
                                                                        ,p_diritto_fatto
                                                                        ,d_data
                                                                        ,cado.gestione
                                                                        ,cado.area
                                                                        ,cado.settore
                                                                        ,cado.ruolo
                                                                        ,cado.profilo
                                                                        ,cado.posizione
                                                                        ,cado.attivita
                                                                        ,cado.figura
                                                                        ,cado.qualifica
                                                                        ,cado.livello
                                                                        ,cado.tipo_rapporto
                                                                        ,cado.ore
                                                                        ,d_revisione_struttura
                                                                        ,d_ore_lavoro);
                     d_incaricati   := gp4do.conta_dot_ore_inc_struttura(p_revisione
                                                                        ,p_diritto_fatto
                                                                        ,d_data
                                                                        ,cado.gestione
                                                                        ,cado.area
                                                                        ,cado.settore
                                                                        ,cado.ruolo
                                                                        ,cado.profilo
                                                                        ,cado.posizione
                                                                        ,cado.attivita
                                                                        ,cado.figura
                                                                        ,cado.qualifica
                                                                        ,cado.livello
                                                                        ,cado.tipo_rapporto
                                                                        ,cado.ore
                                                                        ,d_revisione_struttura
                                                                        ,d_ore_lavoro);
                     d_ore_lavoro   := get_ore_lavoro_ue(d_data
                                                        ,cado.ruolo
                                                        ,cado.profilo
                                                        ,cado.posizione
                                                        ,cado.figura
                                                        ,cado.qualifica
                                                        ,cado.livello);
                  
                     if nvl(d_ore_lavoro, 0) = 0 then
                        raise situazione_anomala;
                     end if;
                  
                     d_ore_effettive := d_effettivi;
                     d_diff_numero   := d_effettivi - cado.numero;
                     d_diff_ore      := d_ore_effettive - cado.numero_ore;
                  end if;
               
                  update calcoli_do
                     set effettivi    = d_effettivi
                        ,di_ruolo     = d_ruolo
                        ,non_ruolo    = d_non_ruolo
                        ,contrattisti = d_contrattisti
                        ,sovrannumero = d_sovrannumero
                        ,assenti      = d_assenti
                        ,incaricati   = d_incaricati
                        ,diff_numero  = d_diff_numero
                        ,diff_ore     = d_diff_ore
                   where rowid = cado.rowid;
               end loop;
            
               open c_dotazione for
                  select p_utente
                        ,p_revisione
                        ,cado.gestione
                        ,'D'
                        ,0
                        ,to_char(null)
                        ,cado.ore
                        ,cado.area
                        ,cado.settore
                        ,cado.ruolo
                        ,cado.profilo
                        ,cado.posizione
                        ,cado.attivita
                        ,cado.figura
                        ,cado.qualifica
                        ,cado.livello
                        ,cado.tipo_rapporto
                        ,nvl(cado.numero, cado.numero_ore)
                        ,round(cado.di_ruolo, 1)
                        ,round(cado.assenti, 1)
                        ,round(cado.incaricati, 1)
                        ,round(cado.non_ruolo, 1)
                        ,round(cado.contrattisti, 1)
                        ,round(cado.effettivi, 1)
                        ,round(cado.diff_numero, 1)
                        ,round(cado.diff_ore, 1)
                        ,cado.id
                        ,round(cado.sovrannumero, 1)
                    from calcoli_do cado
                   where door_id in (0, 1)
                     and (nvl(cado.diff_ore, 0) =
                         decode(p_scostamenti
                                ,'S'
                                ,decode(nvl(cado.diff_ore, 0), 0, 1, cado.diff_ore)
                                ,'T'
                                ,nvl(cado.diff_ore, 0)) or
                         nvl(cado.diff_numero, 0) =
                         decode(p_scostamenti
                                ,'S'
                                ,decode(nvl(cado.diff_numero, 0), 0, 1, cado.diff_numero)
                                ,'T'
                                ,nvl(cado.diff_numero, 0)))
                   order by provenienza
                           ,settore
                           ,figura
                           ,profilo
                           ,posizione
                           ,attivita;
            exception
               when situazione_anomala then
                  open c_dotazione for
                     select to_char(null)
                           ,to_number(null)
                           ,to_char(null)
                           ,to_number(null)
                           ,to_char(null)
                           ,to_number(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                       from dual;
            end;
         end if;
      elsif p_modalita = 'R' then
         /* Contesto della riga */
         begin
            /* Elimino preesistenti registrazioni di dettaglio */
            delete from calcoli_do where id is null;
         
            select cado.provenienza
                  ,cado.ore
                  ,cado.area
                  ,cado.settore
                  ,cado.ruolo
                  ,cado.profilo
                  ,cado.posizione
                  ,cado.attivita
                  ,cado.figura
                  ,cado.qualifica
                  ,cado.livello
                  ,cado.tipo_rapporto
                  ,cado.numero
                  ,cado.numero_ore
              into d_provenienza
                  ,d_ore
                  ,d_area
                  ,d_settore
                  ,d_ruolo_ret
                  ,d_profilo
                  ,d_posizione
                  ,d_attivita
                  ,d_figura
                  ,d_qualifica
                  ,d_livello
                  ,d_tipo_rapporto
                  ,d_numero
                  ,d_numero_ore
              from calcoli_do cado
             where id = p_id;
         end;
      
         if d_provenienza = 'D' then
            insert into calcoli_do
               (utente
               ,data
               ,revisione
               ,door_id
               ,provenienza
               ,gestione
               ,area
               ,settore
               ,unita_ni
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
               ,effettivi
               ,di_ruolo
               ,assenti
               ,incaricati
               ,non_ruolo
               ,contrattisti
               ,sovrannumero
               ,diff_numero
               ,diff_ore)
               select p_utente
                     ,d_data
                     ,p_revisione
                     ,to_number(null)
                     ,'D'
                     ,p_gestione
                     ,d_area
                     ,reuo.codice_figlio
                     ,reuo.figlio
                     ,d_ruolo
                     ,d_profilo
                     ,d_posizione
                     ,d_attivita
                     ,d_figura
                     ,d_qualifica
                     ,d_livello
                     ,d_tipo_rapporto
                     ,d_ore
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                     ,to_number(null)
                 from relazioni_uo reuo
                where reuo.revisione = d_revisione_struttura
                  and reuo.codice_padre = d_settore
                  and gestione = p_gestione;
         
            update calcoli_do cado
               set (numero, numero_ore) = (select sum(numero)
                                                 ,sum(numero_ore)
                                             from dotazione_organica door
                                            where door.revisione = p_revisione
                                              and door.gestione = p_gestione
                                              and area = d_area
                                              and ruolo = d_ruolo_ret
                                              and profilo = d_profilo
                                              and posizione = d_posizione
                                              and attivita = d_attivita
                                              and figura = d_figura
                                              and qualifica = d_qualifica
                                              and livello = d_livello
                                              and tipo_rapporto = d_tipo_rapporto
                                              and nvl(to_char(ore), '%') like
                                                  nvl(d_ore, '%')
                                              and settore = cado.settore)
             where provenienza = 'D'
               and door_id is null;
         
            delete from calcoli_do
             where numero is null
               and numero_ore is null
               and provenienza = 'D'
               and door_id is null;
         
            update calcoli_do cado
               set effettivi = conta_dotazione_o(p_revisione
                                                ,p_diritto_fatto
                                                ,d_data
                                                ,p_gestione
                                                ,d_area
                                                ,cado.settore
                                                ,d_ruolo_ret
                                                ,d_profilo
                                                ,d_posizione
                                                ,d_attivita
                                                ,d_figura
                                                ,d_qualifica
                                                ,d_livello
                                                ,d_tipo_rapporto
                                                ,d_ore)
             where door_id is null
               and provenienza = 'D';
         
            update calcoli_do cado
               set di_ruolo = gp4do.conta_dot_ruolo_o(p_revisione
                                                     ,p_diritto_fatto
                                                     ,d_data
                                                     ,p_gestione
                                                     ,d_area
                                                     ,cado.settore
                                                     ,d_ruolo_ret
                                                     ,d_profilo
                                                     ,d_posizione
                                                     ,d_attivita
                                                     ,d_figura
                                                     ,d_qualifica
                                                     ,d_livello
                                                     ,d_tipo_rapporto
                                                     ,d_ore)
             where door_id is null
               and provenienza = 'D';
         
            update calcoli_do cado
               set contrattisti = gp4do.conta_dot_contrattisti_o(p_revisione
                                                                ,p_diritto_fatto
                                                                ,d_data
                                                                ,p_gestione
                                                                ,d_area
                                                                ,cado.settore
                                                                ,d_ruolo_ret
                                                                ,d_profilo
                                                                ,d_posizione
                                                                ,d_attivita
                                                                ,d_figura
                                                                ,d_qualifica
                                                                ,d_livello
                                                                ,d_tipo_rapporto
                                                                ,d_ore)
             where door_id is null
               and provenienza = 'D';
         
            update calcoli_do cado
               set sovrannumero = gp4do.conta_dot_sovrannumero_o(p_revisione
                                                                ,p_diritto_fatto
                                                                ,d_data
                                                                ,p_gestione
                                                                ,d_area
                                                                ,cado.settore
                                                                ,d_ruolo_ret
                                                                ,d_profilo
                                                                ,d_posizione
                                                                ,d_attivita
                                                                ,d_figura
                                                                ,d_qualifica
                                                                ,d_livello
                                                                ,d_tipo_rapporto
                                                                ,d_ore)
             where door_id is null
               and provenienza = 'D';
         
            update calcoli_do cado
               set assenti = gp4do.conta_dot_assenti_o(p_revisione
                                                      ,p_diritto_fatto
                                                      ,d_data
                                                      ,p_gestione
                                                      ,d_area
                                                      ,cado.settore
                                                      ,d_ruolo_ret
                                                      ,d_profilo
                                                      ,d_posizione
                                                      ,d_attivita
                                                      ,d_figura
                                                      ,d_qualifica
                                                      ,d_livello
                                                      ,d_tipo_rapporto
                                                      ,d_ore)
             where door_id is null
               and provenienza = 'D';
         
            update calcoli_do cado
               set incaricati = gp4do.conta_dot_incaricati_o(p_revisione
                                                            ,p_diritto_fatto
                                                            ,d_data
                                                            ,p_gestione
                                                            ,d_area
                                                            ,cado.settore
                                                            ,d_ruolo_ret
                                                            ,d_profilo
                                                            ,d_posizione
                                                            ,d_attivita
                                                            ,d_figura
                                                            ,d_qualifica
                                                            ,d_livello
                                                            ,d_tipo_rapporto
                                                            ,d_ore)
             where door_id is null
               and provenienza = 'D';
         
            d_ore_lavoro := get_ore_lavoro_ue(d_data
                                             ,d_ruolo_ret
                                             ,d_profilo
                                             ,d_posizione
                                             ,d_figura
                                             ,d_qualifica
                                             ,d_livello);
         
            if nvl(d_ore_lavoro, 0) = 0 then
               raise situazione_anomala;
            end if;
         
            update calcoli_do cado
               set ore_effettive = gp4do.conta_dot_ore_o(p_revisione
                                                        ,p_diritto_fatto
                                                        ,d_data
                                                        ,p_gestione
                                                        ,d_area
                                                        ,cado.settore
                                                        ,d_ruolo_ret
                                                        ,d_profilo
                                                        ,d_posizione
                                                        ,d_attivita
                                                        ,d_figura
                                                        ,d_qualifica
                                                        ,d_livello
                                                        ,d_tipo_rapporto
                                                        ,d_ore
                                                        ,d_revisione_struttura
                                                        ,d_ore_lavoro)
             where door_id is null
               and provenienza = 'D';
         
            update calcoli_do cado
               set diff_numero = cado.numero - cado.effettivi
                  ,diff_ore    = cado.numero_ore - cado.ore_effettive
                  ,non_ruolo   = effettivi - di_ruolo;
         elsif d_provenienza = 'G' then
            null;
         
            /* Elimino preesistenti registrazioni di dettaglio */
            delete from calcoli_do where door_id is null;
         
            select cado.provenienza
                  ,cado.ore
                  ,cado.area
                  ,cado.settore
                  ,cado.ruolo
                  ,cado.profilo
                  ,cado.posizione
                  ,cado.attivita
                  ,cado.figura
                  ,cado.qualifica
                  ,cado.livello
                  ,cado.tipo_rapporto
                  ,cado.numero
                  ,cado.numero_ore
              into d_provenienza
                  ,d_ore
                  ,d_area
                  ,d_settore
                  ,d_ruolo_ret
                  ,d_profilo
                  ,d_posizione
                  ,d_attivita
                  ,d_figura
                  ,d_qualifica
                  ,d_livello
                  ,d_tipo_rapporto
                  ,d_numero
                  ,d_numero_ore
              from calcoli_do cado
             where id = p_id;
         
            insert into calcoli_do
               (utente
               ,data
               ,revisione
               ,door_id
               ,provenienza
               ,gestione
               ,area
               ,settore
               ,unita_ni
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
               ,effettivi
               ,di_ruolo
               ,assenti
               ,incaricati
               ,non_ruolo
               ,contrattisti
               ,sovrannumero
               ,diff_numero
               ,diff_ore)
               select p_utente
                     ,d_data
                     ,p_revisione
                     ,to_number(null)
                     ,'G'
                     ,pedo.gestione
                     ,to_char(null) --area
                     ,reuo.codice_figlio
                     ,reuo.figlio
                     ,nvl(pedo.ruolo, '%')
                     ,nvl(pedo.profilo, '%')
                     ,nvl(pedo.pos_funz, '%')
                     ,nvl(pedo.attivita, '%')
                     ,pedo.cod_figura
                     ,pedo.cod_qualifica
                     ,pedo.livello
                     ,nvl(pedo.tipo_rapporto, '%')
                     ,pedo.ore
                     ,0 --count(ci)
                     ,0 --pedo.ore
                     ,decode(nvl(d_ore_do, 'O'), 'O', count(ci), sum(pedo.ue)) effettivi
                     ,decode(nvl(d_ore_do, 'O')
                            ,'O'
                            ,sum(decode(pedo.di_ruolo, 'SI', 1, 0))
                            ,sum(decode(pedo.di_ruolo, 'SI', pedo.ue, 0))) di_ruolo
                     ,decode(nvl(d_ore_do, 'O')
                            ,'O'
                            ,sum(gp4gm.get_se_assente(pedo.ci, d_data))
                            ,sum(decode(gp4gm.get_se_assente(pedo.ci, d_data)
                                       ,1
                                       ,pedo.ue))) assenti
                     ,decode(nvl(d_ore_do, 'O')
                            ,'O'
                            ,sum(gp4gm.get_se_incaricato(pedo.ci, d_data))
                            ,sum(decode(gp4gm.get_se_incaricato(pedo.ci, d_data)
                                       ,1
                                       ,pedo.ue))) incaricati
                     ,decode(nvl(d_ore_do, 'O')
                            ,'O'
                            ,sum(decode(pedo.di_ruolo, 'NO', 1, 0))
                            ,sum(decode(pedo.di_ruolo, 'NO', pedo.ue, 0))) non_ruolo
                     ,decode(nvl(d_ore_do, 'O')
                            ,'O'
                            ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                       ,'SI'
                                       ,1
                                       ,0))
                            ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                       ,'SI'
                                       ,pedo.ue
                                       ,0))) contrattisti
                     ,decode(nvl(d_ore_do, 'O')
                            ,'O'
                            ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                       ,'SI'
                                       ,1
                                       ,0))
                            ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                       ,'SI'
                                       ,pedo.ue
                                       ,0))) sovrannumero
                     ,count(ci) diff_numero
                     ,decode(nvl(d_ore_do, 'O'), 'O', sum(pedo.ore), sum(pedo.ue)) diff_ore
                 from periodi_dotazione pedo
                     ,relazioni_uo      reuo
                where pedo.rilevanza = p_diritto_fatto
                  and nvl(pedo.area, '%') = nvl(d_area, '%')
                  and pedo.ruolo = d_ruolo_ret
                  and nvl(pedo.profilo, '%') = nvl(d_profilo, '%')
                  and nvl(pedo.pos_funz, '%') = nvl(d_posizione, '%')
                  and nvl(pedo.attivita, '%') = nvl(d_attivita, '%')
                  and pedo.cod_figura = d_figura
                  and pedo.cod_qualifica = d_qualifica
                  and pedo.livello = d_livello
                  and nvl(pedo.tipo_rapporto, '%') = nvl(d_tipo_rapporto, '%')
                  and nvl(to_char(pedo.ore), '%') like nvl(d_ore, '%')
                  and d_data between pedo.dal and nvl(pedo.al, d_data)
                  and pedo.revisione = p_revisione
                  and pedo.gestione = p_gestione
                  and pedo.door_id = 0
                  and reuo.revisione = d_revisione_struttura
                  and reuo.codice_padre = d_settore
                  and reuo.gestione = pedo.gestione
                  and pedo.unita_ni = reuo.figlio
                group by pedo.revisione
                        ,pedo.gestione
                        ,reuo.codice_figlio
                        ,reuo.figlio
                        ,pedo.ruolo
                        ,pedo.profilo
                        ,pedo.pos_funz
                        ,pedo.attivita
                        ,pedo.cod_figura
                        ,pedo.cod_qualifica
                        ,pedo.livello
                        ,pedo.tipo_rapporto
                        ,pedo.ore;
         end if;
      
         open c_dotazione for
            select p_utente
                  ,p_revisione
                  ,cado.gestione
                  ,'D'
                  ,0
                  ,to_char(null)
                  ,cado.ore
                  ,cado.area
                  ,cado.settore
                  ,cado.ruolo
                  ,cado.profilo
                  ,cado.posizione
                  ,cado.attivita
                  ,cado.figura
                  ,cado.qualifica
                  ,cado.livello
                  ,cado.tipo_rapporto
                  ,nvl(cado.numero, cado.numero_ore)
                  ,round(cado.di_ruolo, 1)
                  ,round(cado.assenti, 1)
                  ,round(cado.incaricati, 1)
                  ,round(cado.non_ruolo, 1)
                  ,round(cado.contrattisti, 1)
                  ,round(cado.effettivi, 1)
                  ,round(cado.diff_numero, 1)
                  ,round(cado.diff_ore, 1)
                  ,cado.id
                  ,round(cado.sovrannumero, 1)
              from calcoli_do cado
             where door_id is null
               and (nvl(cado.diff_ore, 0) =
                   decode(p_scostamenti
                          ,'S'
                          ,decode(nvl(cado.diff_ore, 0), 0, 1, cado.diff_ore)
                          ,'T'
                          ,nvl(cado.diff_ore, 0)) or
                   nvl(cado.diff_numero, 0) =
                   decode(p_scostamenti
                          ,'S'
                          ,decode(nvl(cado.diff_numero, 0), 0, 1, cado.diff_numero)
                          ,'T'
                          ,nvl(cado.diff_numero, 0)));
      elsif p_modalita = 'S' then
         null; /* Contesto del solo settore */
      
         begin
            begin
               delete from calcoli_do where door_id < 0;
            
               select settore into d_settore_padre from calcoli_do where id = p_id;
            
               insert into calcoli_do
                  (utente
                  ,data
                  ,revisione
                  ,door_id
                  ,provenienza
                  ,gestione
                  ,area
                  ,settore
                  ,unita_ni
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
                  ,effettivi
                  ,di_ruolo
                  ,assenti
                  ,incaricati
                  ,non_ruolo
                  ,contrattisti
                  ,sovrannumero
                  ,diff_numero
                  ,diff_ore)
                  select p_utente
                        ,d_data
                        ,p_revisione
                        ,door.door_id * -1
                        ,'D'
                        ,p_gestione
                        ,door.area
                        ,door.settore
                        ,reuo.figlio
                        ,door.ruolo
                        ,door.profilo
                        ,door.posizione
                        ,door.attivita
                        ,door.figura
                        ,door.qualifica
                        ,door.livello
                        ,door.tipo_rapporto
                        ,door.ore
                        ,door.numero
                        ,door.numero_ore
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                        ,to_number(null)
                    from dotazione_organica door
                        ,relazioni_uo       reuo
                   where door.revisione = p_revisione
                     and door.gestione = p_gestione
                     and reuo.revisione = d_revisione_struttura
                     and reuo.codice_padre = d_settore_padre
                     and reuo.gestione = door.gestione
                     and door.settore = reuo.codice_figlio
                  union
                  select p_utente
                        ,d_data
                        ,p_revisione
                        ,-1
                        ,'G'
                        ,pedo.gestione
                        ,to_char(null) --area
                        ,reuo.codice_figlio
                        ,reuo.figlio
                        ,nvl(pedo.ruolo, '%')
                        ,nvl(pedo.profilo, '%')
                        ,nvl(pedo.pos_funz, '%')
                        ,nvl(pedo.attivita, '%')
                        ,pedo.cod_figura
                        ,pedo.cod_qualifica
                        ,pedo.livello
                        ,nvl(pedo.tipo_rapporto, '%')
                        ,pedo.ore
                        ,0 --count(ci)
                        ,0 --pedo.ore
                        ,decode(nvl(d_ore_do, 'O'), 'O', count(ci), sum(pedo.ue)) effettivi
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(pedo.di_ruolo, 'SI', 1, 0))
                               ,sum(decode(pedo.di_ruolo, 'SI', pedo.ue, 0))) di_ruolo
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(gp4gm.get_se_assente(pedo.ci, d_data))
                               ,sum(decode(gp4gm.get_se_assente(pedo.ci, d_data)
                                          ,1
                                          ,pedo.ue))) assenti
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(gp4gm.get_se_incaricato(pedo.ci, d_data))
                               ,sum(decode(gp4gm.get_se_incaricato(pedo.ci, d_data)
                                          ,1
                                          ,pedo.ue))) incaricati
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(pedo.di_ruolo, 'NO', 1, 0))
                               ,sum(decode(pedo.di_ruolo, 'NO', pedo.ue, 0))) non_ruolo
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                          ,'SI'
                                          ,1
                                          ,0))
                               ,sum(decode(gp4_posi.get_contratto_opera(pedo.posizione)
                                          ,'SI'
                                          ,pedo.ue
                                          ,0))) contrattisti
                        ,decode(nvl(d_ore_do, 'O')
                               ,'O'
                               ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                          ,'SI'
                                          ,1
                                          ,0))
                               ,sum(decode(gp4_posi.get_sovrannumero(pedo.posizione)
                                          ,'SI'
                                          ,pedo.ue
                                          ,0))) sovrannumero
                        ,count(ci) diff_numero
                        ,decode(nvl(d_ore_do, 'O'), 'O', sum(pedo.ore), sum(pedo.ue)) diff_ore
                    from periodi_dotazione pedo
                        ,relazioni_uo      reuo
                   where pedo.rilevanza = p_diritto_fatto
                     and d_data between pedo.dal and nvl(pedo.al, d_data)
                     and pedo.revisione = p_revisione
                     and pedo.gestione = p_gestione
                     and pedo.door_id = 0
                     and reuo.revisione = d_revisione_struttura
                     and reuo.codice_padre = d_settore_padre
                     and reuo.gestione = pedo.gestione
                     and pedo.unita_ni = reuo.figlio
                   group by pedo.revisione
                           ,pedo.gestione
                           ,pedo.codice_uo
                           ,reuo.codice_figlio
                           ,reuo.figlio
                           ,pedo.ruolo
                           ,pedo.profilo
                           ,pedo.pos_funz
                           ,pedo.attivita
                           ,pedo.cod_figura
                           ,pedo.cod_qualifica
                           ,pedo.livello
                           ,pedo.tipo_rapporto
                           ,pedo.ore;
            
               delete from calcoli_do
                where numero is null
                  and numero_ore is null
                  and provenienza = 'D'
                  and door_id < 0;
            
               for cado in (select gestione
                                  ,area
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
                                  ,door_id
                                  ,rowid
                              from calcoli_do
                             where utente = p_utente
                               and data = d_data
                               and revisione = p_revisione
                               and gestione = p_gestione
                               and provenienza = 'D'
                               and door_id < 0)
               loop
                  if d_ore_do <> 'U' then
                     d_effettivi    := gp4do.conta_dotazione(p_revisione
                                                            ,p_diritto_fatto
                                                            ,d_data
                                                            ,cado.gestione
                                                            ,cado.door_id * -1);
                     d_ruolo        := gp4do.conta_dot_ruolo(p_revisione
                                                            ,p_diritto_fatto
                                                            ,d_data
                                                            ,cado.gestione
                                                            ,cado.door_id * -1);
                     d_non_ruolo    := d_effettivi - d_ruolo;
                     d_contrattisti := gp4do.conta_dot_contrattisti(p_revisione
                                                                   ,p_diritto_fatto
                                                                   ,d_data
                                                                   ,cado.gestione
                                                                   ,cado.door_id * -1);
                     d_sovrannumero := gp4do.conta_dot_sovrannumero(p_revisione
                                                                   ,p_diritto_fatto
                                                                   ,d_data
                                                                   ,cado.gestione
                                                                   ,cado.door_id * -1);
                     d_assenti      := gp4do.conta_dot_assenti(p_revisione
                                                              ,p_diritto_fatto
                                                              ,d_data
                                                              ,cado.gestione
                                                              ,cado.door_id * -1);
                     d_incaricati   := gp4do.conta_dot_incaricati(p_revisione
                                                                 ,p_diritto_fatto
                                                                 ,d_data
                                                                 ,cado.gestione
                                                                 ,cado.door_id * -1);
                  else
                     d_ore_lavoro   := get_ore_lavoro_ue(d_data
                                                        ,cado.ruolo
                                                        ,cado.profilo
                                                        ,cado.posizione
                                                        ,cado.figura
                                                        ,cado.qualifica
                                                        ,cado.livello);
                     d_effettivi    := gp4do.conta_dot_ore(p_revisione
                                                          ,p_diritto_fatto
                                                          ,d_data
                                                          ,cado.gestione
                                                          ,cado.door_id * -1
                                                          ,d_ore_lavoro);
                     d_ruolo        := gp4do.conta_dot_ruolo_ore(p_revisione
                                                                ,p_diritto_fatto
                                                                ,d_data
                                                                ,cado.gestione
                                                                ,cado.door_id * -1
                                                                ,d_ore_lavoro);
                     d_non_ruolo    := d_effettivi - d_ruolo;
                     d_contrattisti := gp4do.conta_ore_contrattisti(p_revisione
                                                                   ,p_diritto_fatto
                                                                   ,d_data
                                                                   ,cado.gestione
                                                                   ,cado.door_id * -1
                                                                   ,d_ore_lavoro);
                     d_sovrannumero := gp4do.conta_ore_sovrannumero(p_revisione
                                                                   ,p_diritto_fatto
                                                                   ,d_data
                                                                   ,cado.gestione
                                                                   ,cado.door_id * -1
                                                                   ,d_ore_lavoro);
                     d_assenti      := gp4do.conta_ore_assenti(p_revisione
                                                              ,p_diritto_fatto
                                                              ,d_data
                                                              ,cado.gestione
                                                              ,cado.door_id * -1
                                                              ,d_ore_lavoro);
                     d_incaricati   := gp4do.conta_ore_incaricati(p_revisione
                                                                 ,p_diritto_fatto
                                                                 ,d_data
                                                                 ,cado.gestione
                                                                 ,cado.door_id * -1
                                                                 ,d_ore_lavoro);
                  end if;
               
                  if nvl(d_ore_lavoro, 0) = 0 then
                     raise situazione_anomala;
                  end if;
               
                  d_ore_effettive := gp4do.conta_dot_ore(p_revisione
                                                        ,p_diritto_fatto
                                                        ,d_data
                                                        ,cado.gestione
                                                        ,cado.door_id * -1
                                                        ,d_ore_lavoro);
                  d_diff_numero   := d_effettivi - cado.numero;
                  d_diff_ore      := d_ore_effettive - cado.numero_ore;
               
                  update calcoli_do
                     set effettivi    = d_effettivi
                        ,di_ruolo     = d_ruolo
                        ,non_ruolo    = d_non_ruolo
                        ,contrattisti = d_contrattisti
                        ,sovrannumero = d_sovrannumero
                        ,assenti      = d_assenti
                        ,incaricati   = d_incaricati
                        ,diff_numero  = d_diff_numero
                        ,diff_ore     = d_diff_ore
                   where rowid = cado.rowid;
               end loop;
            
               open c_dotazione for
                  select p_utente
                        ,p_revisione
                        ,cado.gestione
                        ,'D'
                        ,0
                        ,to_char(null)
                        ,cado.ore
                        ,cado.area
                        ,cado.settore
                        ,cado.ruolo
                        ,cado.profilo
                        ,cado.posizione
                        ,cado.attivita
                        ,cado.figura
                        ,cado.qualifica
                        ,cado.livello
                        ,cado.tipo_rapporto
                        ,nvl(cado.numero, cado.numero_ore)
                        ,round(cado.di_ruolo, 1)
                        ,round(cado.assenti, 1)
                        ,round(cado.incaricati, 1)
                        ,round(cado.non_ruolo, 1)
                        ,round(cado.contrattisti, 1)
                        ,round(cado.effettivi, 1)
                        ,round(cado.diff_numero, 1)
                        ,round(cado.diff_ore, 1)
                        ,cado.id
                        ,round(cado.sovrannumero, 1)
                    from calcoli_do cado
                   where door_id < 0
                     and (nvl(cado.diff_ore, 0) =
                         decode(p_scostamenti
                                ,'S'
                                ,decode(nvl(cado.diff_ore, 0), 0, 1, cado.diff_ore)
                                ,'T'
                                ,nvl(cado.diff_ore, 0)) or
                         nvl(cado.diff_numero, 0) =
                         decode(p_scostamenti
                                ,'S'
                                ,decode(nvl(cado.diff_numero, 0), 0, 1, cado.diff_numero)
                                ,'T'
                                ,nvl(cado.diff_numero, 0)))
                   order by provenienza;
            exception
               when situazione_anomala or no_data_found then
                  open c_dotazione for
                     select to_char(null)
                           ,to_number(null)
                           ,to_char(null)
                           ,to_number(null)
                           ,to_char(null)
                           ,to_number(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_char(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null) sovrannumero
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                           ,to_number(null)
                       from dual;
            end;
         end;
      end if;
   end get_dotazione;
   --
end gp4do;
/
