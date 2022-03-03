create or replace package peccrein is
   s_pos_inail           assicurazioni_inail.codice%type := '%';
   s_gestione            gestioni.codice%type := '%';
   s_prenotazione        a_prenotazioni.no_prenotazione%type;
   s_errore_prenotazione a_errori.errore%type := to_char(null);
   procedure main
   (
      prenotazione in number
     ,passo        in number
   );
   procedure calcolo_retribuzioni_dip_tp
   (
      p_ci              in number
     ,p_anno            in number
     ,p_mese            in number
     ,p_tipo            in varchar2
     ,p_dal             in date
     ,p_gestione        in varchar2
     ,p_posizione       in varchar2
     ,p_trattamento     in varchar2
     ,p_posizione_inail in varchar2
     ,p_figura          in number
     ,p_giorni          in number
     ,p_qualifica       in number
     ,p_dirigente       in varchar2
     ,p_arretrato       in varchar2
     ,p_prenotazione    in number
     ,p_passo           in number
   );
   procedure calcolo_retribuzioni_dip_pt
   (
      p_ci              in number
     ,p_anno            in number
     ,p_mese            in number
     ,p_tipo            in varchar2
     ,p_dal             in date
     ,p_al              in date
     ,p_gestione        in varchar2
     ,p_posizione       in varchar2
     ,p_trattamento     in varchar2
     ,p_posizione_inail in varchar2
     ,p_figura          in number
     ,p_qualifica       in number
     ,p_ruolo           in varchar2
     ,p_ore             in number
     ,p_tariffa         in out number
     ,p_errore          out varchar2
     ,p_segnalazione    out varchar2
     ,p_prenotazione    in number
     ,p_passo           in number
   );
   procedure calcolo_retribuzioni_coco
   (
      p_ci              in number
     ,p_anno            in number
     ,p_mese            in number
     ,p_tipo            in varchar2
     ,p_dal             in date
     ,p_gestione        in varchar2
     ,p_posizione       in varchar2
     ,p_trattamento     in varchar2
     ,p_posizione_inail in varchar2
     ,p_figura          in number
     ,p_qualifica       in number
     ,p_giorni          in number
     ,p_prenotazione    in number
     ,p_passo           in number
   );
   procedure calcolo_retribuzione_oraria
   (
      p_ci           in number
     ,p_dal          in date
     ,p_al           in date
     ,p_anno         in number
     ,p_mese         in number
     ,p_gestione     in varchar2
     ,p_ore          in number
     ,p_qualifica    in number
     ,p_ruolo        in varchar2
     ,p_tariffa      in out number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   function get_posizione_inail
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2;
   pragma restrict_references(get_posizione_inail, wnds, wnps);
   function get_tipo_inail(p_posizione in varchar2) return varchar2;
   pragma restrict_references(get_tipo_inail, wnds, wnps);
   function get_voce_ipn
   (
      p_posizione_inail in varchar2
     ,p_gestione        in varchar2
     ,p_contratto       in varchar2
     ,p_trattamento     in varchar2
     ,p_data            in date
   ) return varchar2;
   pragma restrict_references(get_voce_ipn, wnds, wnps);
   function get_bilancio_contributo
   (
      p_posizione_inail in varchar2
     ,p_gestione        in varchar2
     ,p_contratto       in varchar2
     ,p_trattamento     in varchar2
     ,p_data            in date
   ) return varchar2;
   pragma restrict_references(get_bilancio_contributo, wnds, wnps);
   function get_voce_contributo
   (
      p_posizione_inail in varchar2
     ,p_gestione        in varchar2
     ,p_contratto       in varchar2
     ,p_trattamento     in varchar2
     ,p_data            in date
   ) return varchar2;
   pragma restrict_references(get_voce_contributo, wnds, wnps);
   function get_trattamento
   (
      p_posizione        in varchar2
     ,p_figura           in number
     ,p_data             in date
     ,p_tipo_trattamento in varchar2
   ) return varchar2;
   pragma restrict_references(get_trattamento, wnds, wnps);
   function get_esenzione
   (
      p_posizione   in varchar2
     ,p_trattamento in varchar2
     ,p_anno        in number
   ) return varchar2;
   pragma restrict_references(get_esenzione, wnds, wnps);
   function get_giorni_inail
   (
      p_ci   in number
     ,p_dal  in date
     ,p_al   in date
     ,p_anno in number
     ,p_mese in number
     ,p_sede in number
   ) return number;
   pragma restrict_references(get_giorni_inail, wnds, wnps);
   function calcolo_ipn_mese
   (
      p_ci   in number
     ,p_voce in varchar2
     ,p_anno in number
     ,p_mese in number
   ) return number;
   pragma restrict_references(calcolo_ipn_mese, wnds, wnps);
   function calcolo_ipn_anno
   (
      p_ci   in number
     ,p_voce in varchar2
     ,p_anno in number
   ) return number;
   pragma restrict_references(calcolo_ipn_anno, wnds, wnps);
   procedure calcolo_retribuzione_inail
   (
      p_ci           in number
     ,p_anno         in number
     ,p_tipo         in varchar2
     ,p_prenotazione in number
     ,p_passo        in number
     ,p_tipo_elab    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   procedure calcolo_premio_inail
   (
      p_anno         in number
     ,p_ci           in number
     ,p_tipo         in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
     ,p_prenotazione in number
     ,p_passo        in number
   );
   function calcolo_esenzioni
   (
      p_anno           in number
     ,p_gestione       in varchar2
     ,p_posizione      in varchar2
     ,p_tipo_ipn       in varchar2
     ,p_tipo_esenzione in varchar2
   ) return number;
   function premi_inail
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number;
   pragma restrict_references(premi_inail, wnds, wnps);
   function premi_inail_ruolo
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_ruolo     in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number;
   pragma restrict_references(premi_inail_ruolo, wnds, wnps);
   function calcolo_retr_parz_esente
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number;
   pragma restrict_references(calcolo_retr_parz_esente, wnds, wnps);
   function calcolo_retr_effettiva
   (
      p_ci         in number
     ,p_anno       in number
     ,p_gestione   in varchar2
     ,p_ruolo      in varchar2
     ,p_posizione  in varchar2
     ,p_esenzione  in varchar2
     ,p_funzionale in varchar2
     ,p_conto      in varchar2
     ,p_cdc        in varchar2
     ,p_tipo       in varchar2
   ) return number;
   pragma restrict_references(calcolo_retr_effettiva, wnds, wnps);
   function calcolo_premio_effettivo
   (
      p_ci         in number
     ,p_anno       in number
     ,p_gestione   in varchar2
     ,p_ruolo      in varchar2
     ,p_posizione  in varchar2
     ,p_esenzione  in varchar2
     ,p_funzionale in varchar2
     ,p_conto      in varchar2
     ,p_cdc        in varchar2
     ,p_tipo       in varchar2
   ) return number;
   pragma restrict_references(calcolo_premio_effettivo, wnds, wnps);
   function calcolo_regolazione
   (
      p_anno               in number
     ,p_tipo               in varchar2
     ,p_gestione           in varchar2
     ,p_funzionale         in varchar2
     ,p_cdc                in varchar2
     ,p_ruolo              in varchar2
     ,p_capitolo           in varchar2
     ,p_articolo           in varchar2
     ,p_conto              in varchar2
     ,p_risorsa_intervento in varchar2
     ,p_impegno            in number
     ,p_anno_impegno       in number
     ,p_sub_impegno        in number
     ,p_anno_sub_impegno   in number
     ,p_codice_siope       in number
   ) return number;
   pragma restrict_references(calcolo_regolazione, wnds, wnps);
   function calcolo_presunto
   (
      p_anno               in number
     ,p_tipo               in varchar2
     ,p_gestione           in varchar2
     ,p_funzionale         in varchar2
     ,p_cdc                in varchar2
     ,p_ruolo              in varchar2
     ,p_capitolo           in varchar2
     ,p_articolo           in varchar2
     ,p_conto              in varchar2
     ,p_risorsa_intervento in varchar2
     ,p_impegno            in number
     ,p_anno_impegno       in number
     ,p_sub_impegno        in number
     ,p_anno_sub_impegno   in number
     ,p_codice_siope       in number
   ) return number;
   pragma restrict_references(calcolo_presunto, wnds, wnps);
   function calcolo_retr_tot_esente
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number;
   pragma restrict_references(calcolo_retr_tot_esente, wnds, wnps);
   function complesso
   (
      p_ci   in number
     ,p_anno in number
     ,p_tipo in varchar2
   ) return number;
   pragma restrict_references(complesso, wnds, wnps);
   function calcolo_sum_giorni
   (
      p_ci   in number
     ,p_anno in number
     ,p_mese in number
   ) return number;
   pragma restrict_references(calcolo_sum_giorni, wnds, wnps);
   function calcolo_nr_mesi
   (
      p_ci   in number
     ,p_anno in number
   ) return number;
   pragma restrict_references(calcolo_nr_mesi, wnds, wnps);
   function calcolo_nr_giorni
   (
      p_ci   in number
     ,p_anno in number
   ) return number;
   pragma restrict_references(calcolo_nr_giorni, wnds, wnps);
   function calcolo_minimale
   (
      p_voce in varchar2
     ,p_data in date
   ) return number;
   pragma restrict_references(calcolo_minimale, wnds, wnps);
   function calcolo_massimale
   (
      p_voce in varchar2
     ,p_data in date
   ) return number;
   pragma restrict_references(calcolo_massimale, wnds, wnps);
   function get_capitolo
   (
      p_anno            in number
     ,p_dal             in date
     ,p_voce_contributo in varchar2
     ,p_sub_contributo  in varchar2
     ,p_gestione        in varchar2
     ,p_funzionale      in varchar2
     ,p_ruolo           in varchar2
     ,p_posizione       in varchar2
     ,p_imponibile      in number
   ) return varchar2;
   pragma restrict_references(get_capitolo, wnds, wnps);
   procedure log_trace
   (
      p_trc          in number -- Tipo di Trace
     ,p_prn          in number -- Nr di prenotazione in elaborazione
     ,p_pas          in number -- Nr di passo procedurale
     ,p_prs          in out number -- Nr progressivo di segnalazione
     ,p_stp          in varchar2 -- Identificazione dello step in oggetto
     ,p_cnt          in number -- Count delle row trattate
     ,p_tim          in out varchar2 -- Time impiegato in secondi
     ,p_errore       in out varchar2 -- Errore da segnalare
     ,p_segnalazione in out varchar2
   );
   /******************************************************************************
    NOME:        PECCREIN
    DESCRIZIONE: Calcolo RETRIBUZIONI INAIL per AUTOLIQUIDAZIONE
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    0    27/08/2003 MM     Prima emissione.
    1    17/02/2005 MM     Attivita 9730
    1.1  22/06/2005 CB     Mod. Att. 11756
    1.2  22/06/2005 MS     Ripristino Mod. Att. 9036-9730-7319.3
    1.3  20/12/2005 MS     Corretto errore exact-fetch
    1.4  28/12/2005 MM     Differenziati i dirigenti anche per contratto
    1.5  18/01/2006 MM     Attivita 7319.9 - 14190
    1.6  30/01/2006 MM     Attivita 7319.10
    1.7  31/01/2006 MM     Attivita 14640
    1.8  12/06/2006 MS     Inserimento codice siope
    1.9  16/06/2006 MS     correzione errori oracle ( A16640 )
    2.0  05/12/2006 MM     Attivita: 16644 e 16646
    2.1  14/12/2006 MS     Sistemazione controllo per contabilita F ed E per report
    2.2  25/01/2007 MM     Gestione arretrati e rapporto 25esimi dirigenti (Att.19404)
    2.3  31/01/2007 MM     Att.19439
    2.4  02/02/2007 MM     Att.19509
    2.5  07/02/2007 MM     Att.19581
    2.6  03/04/2007 MM     Att.18226
   ******************************************************************************/
end peccrein;
/
create or replace package body peccrein as
   procedure main
   (
      prenotazione in number
     ,passo        in number
   ) is
   begin
      declare
         d_ente         varchar2(4);
         d_ambiente     varchar2(8);
         d_utente       varchar2(8);
         p_anno         number;
         p_ci           varchar2(8);
         p_tipo         varchar2(1);
         p_tipo_elab    varchar2(1);
         p_errore       varchar2(10);
         p_segnalazione varchar2(100);
      begin
         s_prenotazione := prenotazione;
         -- Estrazione Parametri di Selezione della Prenotazione
         begin
            select ente     d_ente
                  ,utente   d_utente
                  ,ambiente d_ambiente
              into d_ente
                  ,d_utente
                  ,d_ambiente
              from a_prenotazioni
             where no_prenotazione = prenotazione;
         exception
            when no_data_found then
               null;
         end;
         -- Estrae Anno di Riferimento Retribuzione
         begin
            select valore
              into p_anno
              from a_parametri
             where no_prenotazione = prenotazione
               and parametro = 'P_ANNO';
         exception
            when no_data_found then
               begin
                  select anno
                    into p_anno
                    from riferimento_retribuzione
                   where rire_id = 'RIRE';
               end;
         end;
         -- Estrae il tipo di calcolo (C consuntivo o P preventivo)
         begin
            select valore
              into p_tipo
              from a_parametri
             where no_prenotazione = prenotazione
               and parametro = 'P_TIPO';
         exception
            when no_data_found then
               p_tipo := 'C';
         end;
         -- Estrae il tipo di elaborazione
         --(I non altera gli individui inseriti, P non altera gli inseriti o variati, V non altera i variati, S estrae il singolo individuo)
         begin
            select valore
              into p_tipo_elab
              from a_parametri
             where no_prenotazione = prenotazione
               and parametro = 'P_TIPO_ELAB';
         exception
            when no_data_found then
               p_tipo_elab := 'P';
         end;
         -- Estrae la classe di gestioni da trattare (gestita in like)
         begin
            select valore
              into s_gestione
              from a_parametri
             where no_prenotazione = prenotazione
               and parametro = 'P_GESTIONE';
         exception
            when no_data_found then
               s_gestione := '%';
         end;
         -- Estrae la classe di posizioni inail da trattare (gestita in like)
         begin
            select valore
              into s_pos_inail
              from a_parametri
             where no_prenotazione = prenotazione
               and parametro = 'P_POS_INAIL';
         exception
            when no_data_found then
               s_pos_inail := '%';
         end;
         -- Estrae il codice individuale dell'individuo da trattare
         -- In caso di Cod.Ind. non indicato estra tutti gli individui di MOFI per quell'anno
         begin
            --dbms_output.put_line('Parametri  ANNO:'||p_anno||' CI:'||p_ci||' Tipo:'||P_tipo||' Tipo elab:'||P_tipo_elab);
            select valore
              into p_ci
              from a_parametri
             where no_prenotazione = prenotazione
               and parametro = 'P_CI';
            raise too_many_rows;
         exception
            when no_data_found then
               --dbms_output.put_line('tutti ');
               begin
                  for mofi in (select distinct mofi.ci
                                 from movimenti_fiscali            mofi
                                     ,mensilita                    mens
                                     ,periodi_retributivi          pere
                                     ,rapporti_retributivi_storici rars
                                where 1 = 1
                                  and pere.ci = mofi.ci
                                  and pere.anno = mofi.anno
                                  and pere.mese = mofi.mese
                                  and pere.gestione like s_gestione
                                  and rars.ci = mofi.ci
                                  and rars.posizione_inail like s_pos_inail
                                  and to_date('0101' || mofi.anno, 'ddmmyyyy') <=
                                      nvl(rars.al, to_date(3333333, 'j'))
                                  and to_date('3112' || mofi.anno, 'ddmmyyyy') >= rars.dal
                                  and mens.tipo in ('N', 'S', 'A')
                                  and mofi.anno =
                                      decode(p_tipo, 'C', p_anno, 'P', p_anno - 1)
                                  and mofi.mese = mens.mese
                                  and mofi.mensilita = mens.mensilita)
                  loop
                     p_ci := mofi.ci;
                     --dbms_output.put_line('ANNO'||p_anno||' CI:'||p_ci);
                     calcolo_retribuzione_inail(p_ci
                                               ,p_anno
                                               ,p_tipo
                                               ,prenotazione
                                               ,passo
                                               ,p_tipo_elab
                                               ,p_errore
                                               ,p_segnalazione);
                  end loop;
               end;
            when too_many_rows then
               begin
                  --dbms_output.put_line('TOO_MANY '||p_anno||p_tipo||p_tipo_elab||p_ci);
                  calcolo_retribuzione_inail(p_ci
                                            ,p_anno
                                            ,p_tipo
                                            ,prenotazione
                                            ,passo
                                            ,p_tipo_elab
                                            ,p_errore
                                            ,p_segnalazione);
               end;
         end;
         if s_errore_prenotazione is not null then
            /* Errore bloccante o segnalazione significativa su almeno un CI */
            update a_prenotazioni
               set errore = s_errore_prenotazione
             where no_prenotazione = s_prenotazione;
            /*         else
                        update a_prenotazioni
                           set errore = 'A00032'
                         where no_prenotazione = s_prenotazione;
            */
         end if;
      end;
   end main;
   --
   procedure log_trace
   (
      p_trc          in number -- Tipo di Trace
     ,p_prn          in number -- Numero di Prenotazione elaborazione
     ,p_pas          in number -- Numero di Passo procedurale
     ,p_prs          in out number -- Numero progressivo di Segnalazione
     ,p_stp          in varchar2 -- Identificazione dello Step in oggetto
     ,p_cnt          in number -- Count delle row trattate
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
            -- Segnalazione di Start
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05800'
               ,rpad(substr(p_stp, 1, 21), 21) || 'h.' || d_ora);
         elsif p_trc = 1 then
            -- Trace di singolo step
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05801'
               ,rpad(substr(p_stp, 1, 20), 20) || ' h.' || d_ora || ' (' || p_tim ||
                '") #<' || to_char(p_cnt) || '>');
         elsif p_trc = 2 then
            -- Segnalazione di Stop
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05802'
               ,rpad(substr(p_stp, 1, 20), 20) || ' h.' || d_ora || ' (' || p_tim || '")');
         elsif p_trc = 3 then
            -- per Warning
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05808'
               ,rpad(substr(p_stp, 1, 20), 20) || ' h.' || d_ora);
         elsif p_trc = 4 then
            -- per Errore in caso si part_time=SI ed collaboratore=SI
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05674'
               ,p_segnalazione);
         elsif p_trc = 5 then
            -- per Errore in caso si part_time=SI ed CARI.ore non definibili
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05673'
               ,p_segnalazione);
         elsif p_trc = 6 then
            -- per Errore per tariffa calcolata nulla
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05672'
               ,p_segnalazione);
         elsif p_trc = 7 then
            -- per Errore da gp4ec.calcolo_tariffa
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,p_errore
               ,p_segnalazione);
         elsif p_trc = 8 then
            -- per calcolo_sum_giorni nullo o zero
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05676'
               ,p_segnalazione);
         elsif p_trc = 9 then
            -- per minimale nullo
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05679'
               ,p_segnalazione);
         elsif p_trc = 10 then
            -- per categora minimale nulla
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05677'
               ,p_segnalazione);
         elsif p_trc = 11 then
            -- per massimale nullo
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05680'
               ,p_segnalazione);
         elsif p_trc = 12 then
            -- per calcolo_nr_mesi nullo o zero
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05683'
               ,p_segnalazione);
         elsif p_trc = 13 then
            -- per individuo modificato/inserito
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05684'
               ,p_segnalazione);
         elsif p_trc = 14 then
            -- per individuo modificato/inserito
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05685'
               ,p_segnalazione);
         elsif p_trc = 15 then
            -- per Posizione INAIL non definita su ALIN
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05686'
               ,p_segnalazione);
         elsif p_trc = 16 then
            -- per ore individuali forzate a valore calcolato
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05689'
               ,p_segnalazione);
         elsif p_trc = 17 then
            -- imputazione contabile non definita
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05693'
               ,p_segnalazione);
         elsif p_trc = 18 then
            -- posizione giuridica con collaboratore null
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P05694'
               ,p_segnalazione);
         elsif p_trc = 19 then
            -- individuo con rapporti retributivi sovrapposti
            insert into a_segnalazioni_errore
            values
               (p_prn
               ,p_pas
               ,p_prs
               ,'P01065'
               ,p_segnalazione);
         end if;
         if p_trc > 3 and s_errore_prenotazione is null then
            s_errore_prenotazione := 'P00108';
         end if;
      end if;
      p_tim := to_char(sysdate, 'sssss');
   end log_trace;
   --
   procedure calcolo_retribuzioni_dip_tp
   (
      p_ci              in number
     ,p_anno            in number
     ,p_mese            in number
     ,p_tipo            in varchar2
     ,p_dal             in date
     ,p_gestione        in varchar2
     ,p_posizione       in varchar2
     ,p_trattamento     in varchar2
     ,p_posizione_inail in varchar2
     ,p_figura          in number
     ,p_giorni          number
     ,p_qualifica       in number
     ,p_dirigente       in varchar2
     ,p_arretrato       in varchar2
     ,p_prenotazione    in number
     ,p_passo           in number
   ) is
   begin
      -- Esegue il calcolo dell'imponibile per i periodi in cui il dipendente era a tempo pieno
      declare
         d_voce_ipn          varchar2(20);
         d_cat_minimale      qualifiche.cat_minimale%type;
         d_minimale          imponibili_voce.min_gg%type;
         d_massimale         imponibili_voce.max_ipn%type;
         d_contratto         qualifiche_giuridiche.contratto%type;
         d_note_dir          number(1) := 0;
         d_imponibile        number;
         d_sum               number;
         d_imponibile_finale number;
         d_prn               number;
         d_pas               number;
         d_prs               number;
         d_stp               varchar2(100);
         d_tim               varchar2(100);
         esci exception;
         p_errore       varchar2(10);
         p_segnalazione varchar2(100);
      begin
         /*         dbms_output.put_line('---');
                  dbms_output.put_line('P_ci             :' || p_ci);
                  dbms_output.put_line('P_posizione_inail:' || p_posizione_inail);
                  dbms_output.put_line('P_gestione       :' || p_gestione);
                  dbms_output.put_line('P_qualifica      :' || p_qualifica);
                  dbms_output.put_line('P_dal            :' || p_dal);
                  dbms_output.put_line('P_trattamento    :' || p_trattamento);
         */
         d_contratto := gp4_qugi.get_contratto(p_qualifica, p_dal);
         /*                  dbms_output.put_line('d_contratto      :' || d_contratto);
         */
         d_voce_ipn := get_voce_ipn(p_posizione_inail
                                   ,p_gestione
                                   ,d_contratto
                                   ,p_trattamento
                                   ,p_dal);
         /*         dbms_output.put_line('Mese:' || p_mese);
                  dbms_output.put_line('Voce IPN:' || d_voce_ipn);
         */
         if rtrim(substr(d_voce_ipn, 1, 10)) is null then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            --            dbms_output.put_line('trace 14 TP');
            log_trace(14
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_cat_minimale := gp4_qual.get_cat_minimale(p_qualifica);
         --         dbms_output.put_line('Cat.MINIMALE:' || d_cat_minimale);
         d_sum := calcolo_sum_giorni(p_ci, p_anno, p_mese);
         --         dbms_output.put_line('GIORNI:' || d_sum);
         if (d_sum is null or d_sum = 0) and p_arretrato = 'C' then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            --            dbms_output.put_line('trace 8');
            log_trace(8
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_minimale := gp4_imvo.get_minimale_gg(rtrim(substr(d_voce_ipn, 1, 10))
                                               ,p_dal
                                               ,d_cat_minimale
                                               ,'TP') * d_sum;
         --         dbms_output.put_line('Minimale:' || d_minimale);
         if d_minimale is null then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            --            dbms_output.put_line('trace 9 TP');
            log_trace(9
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_imponibile := greatest(d_minimale
                                 ,calcolo_ipn_mese(p_ci
                                                  ,rtrim(substr(d_voce_ipn, 1, 10))
                                                  ,p_anno
                                                  ,p_mese));
         --         dbms_output.put_line(d_contratto || ' ' || p_dal);
         /* Tratta i dirigenti - massimale - */
         if p_dirigente = 'SI' then
            begin
               select max_ipn
                 into d_massimale
                 from imponibili_voce
                where voce = rtrim(substr(d_voce_ipn, 1, 10))
                  and p_dal between nvl(dal, to_date(2222222, 'j')) and
                      nvl(al, to_date(3333333, 'j'));
               d_imponibile := d_massimale;
            exception
               when no_data_found then
                  d_massimale := 999999999;
            end;
            if d_massimale is null then
               d_stp := null;
               d_tim := to_char(sysdate, 'sssss');
               begin
                  --Preleva nr max di segnalazioni
                  select nvl(max(progressivo), 0)
                    into d_prs
                    from a_segnalazioni_errore
                   where no_prenotazione = p_prenotazione
                     and passo = p_passo;
               end;
               d_prn          := p_prenotazione;
               d_pas          := p_passo;
               p_errore       := null;
               p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                                 p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
               log_trace(11
                        ,d_prn
                        ,d_pas
                        ,d_prs
                        ,d_stp
                        ,sql%rowcount
                        ,d_tim
                        ,p_errore
                        ,p_segnalazione);
               raise esci;
            end if;
            d_imponibile_finale := nvl((d_imponibile / 25 * least(25, p_giorni / 26 * 25))
                                      ,0);
         else
            if p_arretrato = 'C' then
               d_imponibile_finale := nvl(d_imponibile / d_sum * p_giorni, 0);
            else
               d_imponibile_finale := nvl(d_imponibile, 0);
            end if;
         end if;
         /* Fine modifica per dirigenti      */
         /*         dbms_output.put_line('Imponibile :' || d_imponibile || ' Imponibile finale:' ||
                                       d_imponibile_finale);
         */
         update calcoli_retribuzioni_inail crei
            set imponibile = d_imponibile_finale * nvl(quota, 1) / nvl(intero, 1)
          where anno = p_anno
            and ci = p_ci
            and mese = p_mese
            and dal = p_dal;
      exception
         when esci then
            null;
      end;
   end calcolo_retribuzioni_dip_tp;
   --
   procedure calcolo_retribuzioni_dip_pt
   (
      p_ci              in number
     ,p_anno            in number
     ,p_mese            in number
     ,p_tipo            in varchar2
     ,p_dal             in date
     ,p_al              in date
     ,p_gestione        in varchar2
     ,p_posizione       in varchar2
     ,p_trattamento     in varchar2
     ,p_posizione_inail in varchar2
     ,p_figura          in number
     ,p_qualifica       in number
     ,p_ruolo           in varchar2
     ,p_ore             in number
     ,p_tariffa         in out number
     ,p_errore          out varchar2
     ,p_segnalazione    out varchar2
     ,p_prenotazione    in number
     ,p_passo           in number
   ) is
   begin
      -- Esegue il calcolo dell'imponibile per i periodi in cui il dipendente era part time
      declare
         d_voce_ipn          varchar2(20);
         d_cat_minimale      qualifiche.cat_minimale%type;
         d_minimale          imponibili_voce.min_gg%type;
         d_imponibile_finale number;
         d_tar_oraria        number;
         d_prn               number;
         d_pas               number;
         d_prs               number;
         d_stp               varchar2(100);
         d_tim               varchar2(100);
         esci exception;
         errore_in_elaborazione exception;
         p_errore             varchar2(10);
         p_segnalazione       varchar2(100);
         p_ore_eff            number;
         p_giorni_eff         number;
         p_ore_giornaliere    number;
         p_giorni_settimanali number;
         p_ore_lavoro         number(5, 2);
         p_ore_gg             number(5, 2);
         d_giorni             varchar2(40);
         w_errore             varchar2(10);
      begin
         --         dbms_output.put_line('Calcolo PT');
         d_voce_ipn := get_voce_ipn(p_posizione_inail
                                   ,p_gestione
                                   ,gp4_qugi.get_contratto(p_qualifica, p_dal)
                                   ,p_trattamento
                                   ,p_dal);
         if rtrim(substr(d_voce_ipn, 1, 10)) is null then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            --dbms_output.put_line('trace 14 PT');
            log_trace(14
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_cat_minimale := gp4_qual.get_cat_minimale(p_qualifica);
         d_minimale     := (gp4_imvo.get_minimale_gg(rtrim(substr(d_voce_ipn, 1, 10))
                                                    ,p_dal
                                                    ,d_cat_minimale
                                                    ,'PT') * 6) /
                           gp4_cost.get_ore_lavoro_divisione(p_qualifica, p_dal);
         --dbms_output.put_line('D_minimale nuovo: '||D_minimale);
         if d_minimale is null then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            --dbms_output.put_line('trace 9 PT');
            log_trace(9
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         calcolo_retribuzione_oraria(p_ci
                                    ,p_dal
                                    ,p_al
                                    ,p_anno
                                    ,p_mese
                                    ,p_gestione
                                    ,p_ore
                                    ,p_qualifica
                                    ,p_ruolo
                                    ,p_tariffa
                                    ,p_errore
                                    ,p_segnalazione);
         --dbms_output.put_line('P_tariffa  : '||P_tariffa);
         --dbms_output.put_line('D_minimale : '||D_minimale);
         d_tar_oraria := greatest(d_minimale, p_tariffa);
         begin
            select ore_lavoro
                  ,ore_gg
              into p_ore_lavoro
                  ,p_ore_gg
              from contratti_storici
             where contratto = gp4_qugi.get_contratto(p_qualifica, p_dal)
               and p_dal between dal and nvl(al, to_date(3333333, 'j'));
         exception
            when no_data_found then
               p_ore_lavoro := 0;
               p_ore_gg     := 0;
         end;
         p_giorni_settimanali := round(p_ore_lavoro / p_ore_gg);
         p_ore_giornaliere    := p_ore / p_giorni_settimanali;
         begin
            select cale.giorni
              into d_giorni
              from calendari cale
             where cale.anno = p_anno
               and cale.mese = p_mese
               and cale.calendario = '*';
         exception
            when too_many_rows then
               w_errore := 'A00003 CALENDARI';
               raise errore_in_elaborazione;
            when no_data_found then
               w_errore := 'P05000'; --Calendario non previsto
               raise errore_in_elaborazione;
         end;
         p_giorni_eff := 0;
         --dbms_output.PUT_LINE('P_giorni_settimanali      :'||P_giorni_settimanali);
         for ind in to_number(to_char(p_dal, 'dd')) .. to_number(to_char(p_al, 'dd'))
         loop
            if (p_giorni_settimanali = 5 and substr(d_giorni, ind, 1) = 'f') or
               (p_giorni_settimanali = 6 and substr(d_giorni, ind, 1) in ('s', 'f')) then
               p_giorni_eff := p_giorni_eff + 1;
            else
               p_giorni_eff := p_giorni_eff;
            end if;
         end loop;
         p_ore_eff           := p_ore_giornaliere * p_giorni_eff;
         d_imponibile_finale := nvl(d_tar_oraria * p_ore_eff, 0);
         --dbms_output.PUT_LINE('P_giorni_eff      :'||P_giorni_eff);
         --dbms_output.PUT_LINE('P_ore_giornaliere :'||P_ore_giornaliere);
         --dbms_output.PUT_LINE('D_tar_oraria      :'||D_tar_oraria);
         --dbms_output.PUT_LINE('Imponibile finale PT '||D_imponibile_finale);
         update calcoli_retribuzioni_inail crei
            set imponibile = d_imponibile_finale * nvl(quota, 1) / nvl(intero, 1)
          where anno = p_anno
            and ci = p_ci
            and mese = p_mese
            and dal = p_dal;
      exception
         when esci then
            null;
         when errore_in_elaborazione then
            update a_prenotazioni
               set errore = w_errore
             where no_prenotazione = p_prenotazione;
      end;
   end calcolo_retribuzioni_dip_pt;
   --
   procedure calcolo_retribuzioni_coco
   (
      p_ci              in number
     ,p_anno            in number
     ,p_mese            in number
     ,p_tipo            in varchar2
     ,p_dal             in date
     ,p_gestione        in varchar2
     ,p_posizione       in varchar2
     ,p_trattamento     in varchar2
     ,p_posizione_inail in varchar2
     ,p_figura          in number
     ,p_qualifica       in number
     ,p_giorni          in number
     ,p_prenotazione    in number
     ,p_passo           in number
   ) is
   begin
      -- Esegue il calcolo dell'imponibile per i periodi in cui il dipendente aveva un rapporto
      -- di collaborazione coordinata continuativa
      declare
         d_voce_ipn          varchar2(20);
         d_voce_contributo   varchar2(20);
         d_sub_contributo    varchar2(20);
         d_bilancio          contabilita_voce.bilancio%type;
         d_minimale          number;
         d_massimale         number;
         d_imponibile        number;
         d_imponibile_finale number;
         d_nr_mesi           number;
         d_retr_media        number;
         d_prn               number;
         d_pas               number;
         d_prs               number;
         d_stp               varchar2(100);
         d_tim               varchar2(100);
         esci exception;
         p_errore             varchar2(10);
         p_segnalazione       varchar2(100);
         d_risorsa_intervento ripartizioni_contabili.risorsa_intervento%type;
         d_capitolo           ripartizioni_contabili.capitolo%type;
         d_articolo           ripartizioni_contabili.articolo%type;
         d_conto              ripartizioni_contabili.conto%type;
         d_impegno            ripartizioni_contabili.impegno%type;
         d_anno_impegno       ripartizioni_contabili.anno_impegno%type;
         d_sub_impegno        ripartizioni_contabili.sub_impegno%type;
         d_anno_sub_impegno   ripartizioni_contabili.anno_sub_impegno%type;
         d_codice_siope       ripartizioni_contabili.codice_siope%type;
         d_sede_del           movimenti_contabili.sede_del%type;
         d_anno_del           movimenti_contabili.anno_del%type;
         d_numero_del         movimenti_contabili.numero_del%type;
      begin
         dbms_output.put_line('Calcolo COCO');
         d_nr_mesi := nvl(calcolo_nr_mesi(p_ci, p_anno), 0);
         if d_nr_mesi = 0 then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            log_trace(12
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_voce_ipn := get_voce_ipn(p_posizione_inail
                                   ,p_gestione
                                   ,gp4_qugi.get_contratto(p_qualifica, p_dal)
                                   ,p_trattamento
                                   ,p_dal);
         if rtrim(substr(d_voce_ipn, 1, 10)) is null then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            log_trace(14
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_minimale := calcolo_minimale(rtrim(substr(d_voce_ipn, 1, 10)), p_dal);
         if d_minimale is null then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            log_trace(9
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_massimale := calcolo_massimale(rtrim(substr(d_voce_ipn, 1, 10)), p_dal);
         if d_massimale is null then
            d_stp := null;
            d_tim := to_char(sysdate, 'sssss');
            begin
               --Preleva nr max di segnalazioni
               select nvl(max(progressivo), 0)
                 into d_prs
                 from a_segnalazioni_errore
                where no_prenotazione = p_prenotazione
                  and passo = p_passo;
            end;
            d_prn          := p_prenotazione;
            d_pas          := p_passo;
            p_errore       := null;
            p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                              p_mese || ' Data: ' || to_char(p_dal, 'dd/mm/yyyy') || ' ';
            log_trace(11
                     ,d_prn
                     ,d_pas
                     ,d_prs
                     ,d_stp
                     ,sql%rowcount
                     ,d_tim
                     ,p_errore
                     ,p_segnalazione);
            raise esci;
         end if;
         d_retr_media := calcolo_ipn_anno(p_ci, rtrim(substr(d_voce_ipn, 1, 10)), p_anno) /
                         d_nr_mesi;
         if d_retr_media between d_minimale and d_massimale then
            d_imponibile := d_retr_media;
         elsif d_minimale > d_retr_media then
            d_imponibile := d_minimale;
         elsif d_massimale < d_retr_media then
            d_imponibile := d_massimale;
         end if;
         --dbms_output.PUT_LINE('D_imponibile : '||D_imponibile);
         --dbms_output.PUT_LINE('D_nr_mesi    : '||D_nr_mesi);
         --dbms_output.PUT_LINE('P_giorni     : '||P_giorni);
         d_imponibile_finale := nvl(d_imponibile, 0);
         --dbms_output.PUT_LINE('D_imponibile_finale : '||D_imponibile_finale);
         update calcoli_retribuzioni_inail crei
            set imponibile = d_imponibile_finale * nvl(quota, 1) / nvl(intero, 1)
          where anno = p_anno
            and ci = p_ci
            and mese = p_mese
            and dal = p_dal;
         d_voce_contributo := get_voce_contributo(p_posizione_inail
                                                 ,p_gestione
                                                 ,gp4_qugi.get_contratto(p_qualifica
                                                                        ,p_dal)
                                                 ,p_trattamento
                                                 ,p_dal);
         d_sub_contributo  := rtrim(substr(d_voce_contributo, 11, 2));
         d_voce_contributo := rtrim(substr(d_voce_contributo, 1, 10));
         --dbms_output.put_line('voce ipn '||D_voce_ipn);
         --dbms_output.put_line('voce '||D_voce_contributo);
         --dbms_output.put_line('sub '||D_sub_contributo);
         --dbms_output.put_line('Minimale '||D_minimale);
         --dbms_output.put_line('Massimale '||D_massimale);
         --dbms_output.put_line('Media '||D_retr_media);
         begin
            select max(sede_del)
                  ,max(anno_del)
                  ,max(numero_del)
              into d_sede_del
                  ,d_anno_del
                  ,d_numero_del
              from movimenti_contabili moco
             where anno = p_anno
               and mese = p_mese
               and ci = p_ci
               and voce = d_voce_contributo
               and sub = d_sub_contributo
               and sede_del is not null;
            --dbms_output.put_line(D_sede_del);
            --dbms_output.put_line(D_numero_del);
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               begin
                  select bilancio
                    into d_bilancio
                    from contabilita_voce
                   where voce = d_voce_contributo
                     and sub = d_sub_contributo
                     and p_dal between nvl(dal, to_date(2222222, 'j')) and
                         nvl(al, to_date(3333333, 'j'));
                  select risorsa_intervento
                        ,capitolo
                        ,articolo
                        ,conto
                        ,impegno
                        ,anno_impegno
                        ,sub_impegno
                        ,anno_sub_impegno
                        ,codice_siope
                    into d_risorsa_intervento
                        ,d_capitolo
                        ,d_articolo
                        ,d_conto
                        ,d_impegno
                        ,d_anno_impegno
                        ,d_sub_impegno
                        ,d_anno_sub_impegno
                        ,d_codice_siope
                    from righe_delibera_retributiva
                   where sede = d_sede_del
                     and anno = d_anno_del
                     and numero = d_numero_del
                     and bilancio = d_bilancio;
                  raise too_many_rows;
               exception
                  when no_data_found then
                     null;
                  when too_many_rows then
                     update calcoli_retribuzioni_inail crei
                        set sede_del   = d_sede_del
                           ,anno_del   = d_anno_del
                           ,numero_del = d_numero_del
                      where anno = p_anno
                        and ci = p_ci
                        and mese = p_mese
                        and dal = p_dal;
               end;
         end;
      exception
         when esci then
            null;
      end;
   end calcolo_retribuzioni_coco;
   --
   procedure calcolo_retribuzione_oraria
   (
      p_ci           in number
     ,p_dal          in date
     ,p_al           in date
     ,p_anno         in number
     ,p_mese         in number
     ,p_gestione     in varchar2
     ,p_ore          in number
     ,p_qualifica    in number
     ,p_ruolo        in varchar2
     ,p_tariffa      in out number
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
   begin
      declare
         d_voce           varchar2(10);
         d_mensilita      varchar2(3);
         d_ore_mensili    number;
         d_div_orario     number;
         d_ore_gg         number;
         d_gg_lavoro      number;
         d_ore_lavoro     number;
         d_rif_tar        date;
         d_flag_movimenti number(1);
         esci exception;
      begin
         p_tariffa := null;
         begin
            select codice
              into d_voce
              from voci_economiche
             where specifica = 'RET_CO_ORA';
         exception
            when no_data_found then
               raise esci;
            when too_many_rows then
               raise esci;
         end;
         --dbms_output.put_line ('Voce tariffa oraria : '||D_voce);
         begin
            select max(mensilita)
              into d_mensilita
              from mensilita
             where tipo = 'N'
               and mese = p_mese;
         end;
         --         d_tipo_rapporto := gp4_pegi.get_tipo_rapporto(p_ci, 'S', p_dal);
         --         d_contratto     := gp4_qugi.get_contratto(p_qualifica, p_dal);
         --         d_livello       := gp4_qugi.get_livello(p_qualifica, p_dal);
         d_ore_mensili := gp4_cost.get_ore_mensili(p_qualifica, p_dal);
         d_div_orario  := gp4_cost.get_div_orario(p_qualifica, p_dal);
         d_ore_gg      := gp4_cost.get_ore_gg(p_qualifica, p_dal);
         d_gg_lavoro   := gp4_cost.get_gg_lavoro(p_qualifica, p_dal);
         d_ore_lavoro  := gp4_cost.get_ore_lavoro(p_qualifica, p_dal);
         /*         gp4ec.calcolo_tariffa(p_ci
                                       ,p_al
                                       ,p_anno
                                       ,p_mese
                                       ,d_mensilita
                                       ,nvl(p_al
                                           ,last_day(to_date('01/' || p_mese || '/' || p_anno
                                                            ,'DD/MM/YYYY')))
                                       ,d_voce
                                       ,'*'
                                       ,nvl(p_al
                                           ,last_day(to_date('01/' || p_mese || '/' || p_anno
                                                            ,'DD/MM/YYYY')))
                                       ,p_tariffa
                                       ,p_gestione
                                       ,d_tipo_rapporto
                                       ,p_ore
                                       ,d_contratto
                                       ,p_ruolo
                                       ,p_qualifica
                                       ,d_livello
                                       ,d_ore_mensili
                                       ,d_div_orario
                                       ,d_ore_gg
                                       ,d_gg_lavoro
                                       ,d_ore_lavoro
                                       ,p_errore
                                       ,p_segnalazione);
         */
         peccmore_tariffa.calcolo(p_ci
                                 ,p_al
                                 ,p_anno
                                 ,p_mese
                                 ,d_mensilita
                                 ,nvl(p_al
                                     ,last_day(to_date('01/' || p_mese || '/' || p_anno
                                                      ,'DD/MM/YYYY')))
                                 ,d_voce
                                 ,'*'
                                 ,nvl(p_al
                                     ,last_day(to_date('01/' || p_mese || '/' || p_anno
                                                      ,'DD/MM/YYYY')))
                                 ,d_rif_tar
                                 ,p_tariffa
                                 ,d_flag_movimenti
                                 ,d_ore_mensili
                                 ,d_div_orario
                                 ,d_ore_gg
                                 ,d_gg_lavoro
                                 ,d_ore_lavoro
                                 ,p_errore
                                 ,p_segnalazione);
      exception
         when esci then
            p_tariffa := null;
      end;
   end calcolo_retribuzione_oraria;
   --
   function versione return varchar2 is
   begin
      return 'V2.6 del 03/04/2007';
   end versione;
   --
   procedure calcolo_premio_inail
   (
      p_anno         in number
     ,p_ci           in number
     ,p_tipo         in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
     ,p_prenotazione in number
     ,p_passo        in number
   ) is
   begin
      declare
         d_manuale varchar2(1);
         d_prn     number;
         d_pas     number;
         d_prs     number;
         d_stp     varchar2(100);
         d_tim     varchar2(100);
         esci exception;
         p_errore        varchar2(10);
         p_segnalazione  varchar2(100);
         d_aliquota      number;
         d_alq_esenzione number;
         d_premio        number(12, 2);
      begin
         begin
            select 'x'
              into d_manuale
              from retribuzioni_inail rein
             where manuale is not null
               and anno = p_anno
               and ci = p_ci
               and tipo_ipn = p_tipo;
            raise too_many_rows;
         exception
            when too_many_rows then
               begin
                  d_stp := null;
                  d_tim := to_char(sysdate, 'sssss');
                  begin
                     --Preleva nr max di segnalazioni
                     select nvl(max(progressivo), 0)
                       into d_prs
                       from a_segnalazioni_errore
                      where no_prenotazione = p_prenotazione
                        and passo = p_passo;
                  end;
                  d_prn          := p_prenotazione;
                  d_pas          := p_passo;
                  p_errore       := null;
                  p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Tipo: ' ||
                                    p_tipo || ' ';
                  --dbms_output.put_line('trace 13');
                  log_trace(13
                           ,d_prn
                           ,d_pas
                           ,d_prs
                           ,d_stp
                           ,sql%rowcount
                           ,d_tim
                           ,p_errore
                           ,p_segnalazione);
                  raise esci;
               end;
            when no_data_found then
               --dbms_output.put_line('Premio     no_found');
               begin
                  --dbms_output.put_line('Premio inail');
                  for rein in (select ci
                                     ,posizione_inail
                                     ,esenzione
                                     ,imponibile
                                     ,imin_id
                                 from retribuzioni_inail rein
                                where ci = p_ci
                                  and anno = p_anno
                                  and tipo_ipn = p_tipo
                                order by ci
                                        ,anno)
                  loop
                     d_aliquota := gp4_alin.get_aliquota(rein.posizione_inail
                                                        ,p_anno
                                                        ,p_tipo);
                     --dbms_output.put_line('CI : '||rein.ci||' Posizione Inail : '||rein.posizione_inail||' '||p_anno||' '||p_tipo||' Aliquota :'||d_aliquota);
                     if rein.esenzione is not null then
                        d_alq_esenzione := nvl(gp4_alei.get_aliquota(rein.esenzione
                                                                    ,p_anno)
                                              ,0);
                     else
                        d_alq_esenzione := 0;
                        --dbms_output.put_line('alq_esenzione '||d_alq_esenzione);
                     end if;
                     --dbms_output.put_line('imponibile '||REIN.imponibile);
                     --dbms_output.put_line('esenzione '||rein.esenzione);
                     d_premio := (rein.imponibile -
                                 (rein.imponibile * d_alq_esenzione / 100)) * d_aliquota / 100;
                     --dbms_output.put_line('Premio '||d_premio);
                     update retribuzioni_inail
                        set premio = d_premio
                      where anno = p_anno
                        and ci = p_ci
                        and tipo_ipn = p_tipo
                        and imin_id = rein.imin_id;
                  end loop;
               end;
         end;
      exception
         when esci then
            null;
      end;
   end calcolo_premio_inail;
   procedure calcolo_retribuzione_inail
   (
      p_ci           in number
     ,p_anno         in number
     ,p_tipo         in varchar2
     ,p_prenotazione in number
     ,p_passo        in number
     ,p_tipo_elab    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
   begin
      declare
         d_voce_contributo varchar2(100);
         d_part_time       varchar2(2);
         d_coco            varchar2(2);
         d_dirigente       varchar2(2);
         d_note_dir        number(1) := 0;
         d_esenzione       varchar2(4);
         d_tariffa         number;
         d_prn             number;
         d_pas             number;
         d_prs             number;
         d_stp             varchar2(100);
         d_tim             varchar2(100);
         d_manuale         varchar2(1);
         d_sequence        number;
         d_progressivo     calcoli_retribuzioni_inail.progressivo%type;
         -- progressivo per assegnazioni contabili multiple
         d_utente             varchar2(8);
         d_data_agg           date;
         d_ore_ind            number;
         d_periodo_astensione varchar2(2) := 'NO';
         d_rars_sovrapposti   number(1) := 0;
         esci exception;
      begin
         --eliminazione dei periodi eventualmente presenti per l'individuo
         --dbms_output.put_line('Prima delete '||p_ci);
         delete from calcoli_retribuzioni_inail
          where anno = p_anno
            and ci = p_ci;
         --dbms_output.put_line(' CI : '||p_ci);
         --dbms_output.put_line(' Tipo_elab : '||p_tipo_elab);
         if p_tipo_elab is null or p_tipo_elab = 'P' then
            begin
               select 'x'
                 into d_manuale
                 from retribuzioni_inail rein
                where manuale is not null
                  and ci = p_ci
                  and anno = p_anno
                  and tipo_ipn = p_tipo;
               raise too_many_rows;
            exception
               when too_many_rows then
                  begin
                     d_stp := null;
                     d_tim := to_char(sysdate, 'sssss');
                     begin
                        --Preleva nr max di segnalazioni
                        select nvl(max(progressivo), 0)
                          into d_prs
                          from a_segnalazioni_errore
                         where no_prenotazione = p_prenotazione
                           and passo = p_passo;
                     end;
                     d_prn          := p_prenotazione;
                     d_pas          := p_passo;
                     p_errore       := null;
                     p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Tipo: ' ||
                                       p_tipo || ' ';
                     --dbms_output.put_line('trace 13 tipo_elab = P ');
                     log_trace(13
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,sql%rowcount
                              ,d_tim
                              ,p_errore
                              ,p_segnalazione);
                     raise esci;
                  end;
               when no_data_found then
                  null;
            end;
         elsif p_tipo_elab = 'I' then
            begin
               select 'x'
                 into d_manuale
                 from retribuzioni_inail rein
                where manuale = 'I'
                  and ci = p_ci
                  and anno = p_anno
                  and tipo_ipn = p_tipo;
               raise too_many_rows;
            exception
               when too_many_rows then
                  begin
                     d_stp := null;
                     d_tim := to_char(sysdate, 'sssss');
                     begin
                        --Preleva nr max di segnalazioni
                        select nvl(max(progressivo), 0)
                          into d_prs
                          from a_segnalazioni_errore
                         where no_prenotazione = p_prenotazione
                           and passo = p_passo;
                     end;
                     d_prn          := p_prenotazione;
                     d_pas          := p_passo;
                     p_errore       := null;
                     p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Tipo: ' ||
                                       p_tipo || ' ';
                     --dbms_output.put_line('trace 13 tipo_elab = I ');
                     log_trace(13
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,sql%rowcount
                              ,d_tim
                              ,p_errore
                              ,p_segnalazione);
                     raise esci;
                  end;
               when no_data_found then
                  null;
            end;
         elsif p_tipo_elab = 'V' then
            begin
               select 'x'
                 into d_manuale
                 from retribuzioni_inail rein
                where manuale = 'V'
                  and ci = p_ci
                  and anno = p_anno
                  and tipo_ipn = p_tipo;
               raise too_many_rows;
            exception
               when too_many_rows then
                  begin
                     d_stp := null;
                     d_tim := to_char(sysdate, 'sssss');
                     begin
                        --Preleva nr max di segnalazioni
                        select nvl(max(progressivo), 0)
                          into d_prs
                          from a_segnalazioni_errore
                         where no_prenotazione = p_prenotazione
                           and passo = p_passo;
                     end;
                     d_prn          := p_prenotazione;
                     d_pas          := p_passo;
                     p_errore       := null;
                     p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Tipo: ' ||
                                       p_tipo || ' ';
                     --dbms_output.put_line('trace 13 tipo_elab = V ');
                     log_trace(13
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,sql%rowcount
                              ,d_tim
                              ,p_errore
                              ,p_segnalazione);
                     raise esci;
                  end;
               when no_data_found then
                  null;
            end;
         elsif p_tipo_elab in ('T', 'S') then
            null;
         end if;
         -- Valorizziamo preventivamente CALCOLI_RETRIBUZIONI_INAIL con le registrazioni di
         --   VISTA_PEGI_MESI e RAPPORTI_RETRIBUTIVI_STORICI
         -- Se l'elaborazione e preventiva, vengono replicate le registrazioni del consuntivo dell'anno precedente
         -- Se l'elaborazione e consuntiva, si riesegue il calcolo partendo dai dati giuridici ed economici individuali noti.
         --dbms_output.put_line('Calcolo il ci: '||P_CI);
         d_progressivo := 1;
         if p_tipo = 'C' then
            -- Consuntivo
            /* Controllo preventivo per parare casi anomali con record su RARS sovrapposti
            */
            begin
               select 1
                 into d_rars_sovrapposti
                 from rapporti_retributivi_storici rars
                where ci = p_ci
                  and exists (select 'x'
                         from rapporti_retributivi_storici
                        where ci = rars.ci
                          and dal <= nvl(rars.al, to_date(3333333, 'j'))
                          and nvl(al, to_date(3333333, 'j')) >= rars.dal
                          and rowid <> rars.rowid);
               raise too_many_rows;
            exception
               when too_many_rows then
                  begin
                     d_stp := null;
                     d_tim := to_char(sysdate, 'sssss');
                     begin
                        --Preleva nr max di segnalazioni
                        select nvl(max(progressivo), 0)
                          into d_prs
                          from a_segnalazioni_errore
                         where no_prenotazione = p_prenotazione
                           and passo = p_passo;
                     end;
                     d_prn          := p_prenotazione;
                     d_pas          := p_passo;
                     p_errore       := 'P01065';
                     p_segnalazione := 'CI: ' || p_ci ||
                                       ' #### INDIVIDUO NON ELABORABILE #### ';
                     --dbms_output.put_line('trace 13 tipo_elab = V ');
                     log_trace(19
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,sql%rowcount
                              ,d_tim
                              ,p_errore
                              ,p_segnalazione);
                     s_errore_prenotazione := 'P00109';
                     raise esci;
                  end;
               when no_data_found then
                  null;
            end;
            begin
               insert into calcoli_retribuzioni_inail
                  (ci
                  ,anno
                  ,mese
                  ,dal
                  ,al
                  ,giorni
                  ,gestione
                  ,posizione
                  ,figura
                  ,qualifica
                  ,trattamento
                  ,settore
                  ,sede
                  ,posizione_inail
                  ,ruolo
                  ,tipo_ipn
                  ,competenza
                  ,ore
                  ,progressivo
                  ,arretrato)
                  select vpem.ci
                        ,vpem.anno
                        ,vpem.mese
                        ,greatest(vpem.dal, rars.dal)
                        ,least(nvl(vpem.al, to_date(3333333, 'j'))
                              ,nvl(rars.al, to_date(3333333, 'j')))
                        ,decode(vpem.arretrato
                               ,'C'
                               ,get_giorni_inail(vpem.ci
                                                ,greatest(vpem.dal, rars.dal)
                                                ,least(nvl(vpem.al
                                                          ,to_date(3333333, 'j'))
                                                      ,nvl(rars.al
                                                          ,to_date(3333333, 'j')))
                                                ,vpem.anno
                                                ,vpem.mese
                                                ,nvl(vpem.sede, 0))
                               ,'A'
                               ,0)
                        ,vpem.gestione
                        ,vpem.posizione
                        ,vpem.figura
                        ,vpem.qualifica
                        ,rars.trattamento
                        ,vpem.settore
                        ,vpem.sede
                        ,rars.posizione_inail
                        ,vpem.ruolo
                        ,p_tipo
                        ,'G'
                        ,vpem.ore
                        ,d_progressivo
                        ,vpem.arretrato
                    from vista_pegi_mesi              vpem
                        ,rapporti_retributivi_storici rars
                   where rars.dal <= nvl(vpem.al, to_date(3333333, 'j'))
                     and nvl(rars.al, to_date(3333333, 'j')) >= vpem.dal
                     and rars.ci = vpem.ci
                     and vpem.anno = p_anno
                     and vpem.ci = p_ci
                     and rars.posizione_inail is not null;
               -- Aggiorniamo i giorni per i mesi spezzati in piu periodi:
               --   in questo caso, il semplice conteggio delle domeniche puo determinare totali mensili non corretti
               --   Il cursore rileva tutti i mesi spezzati su piu periodi che pero coprono tutto il mese, dove la somma
               --   dei giorni calcolati precedentemente e diversa da 26
               --dbms_output.put_line('Post inserimento: '||P_CI);
               /* Verifica la definizione delle posizioni inail
               dell'individuo su ALIN per l'anno             */
               for alin in (select distinct posizione_inail
                              from calcoli_retribuzioni_inail
                             where anno = p_anno
                               and ci = p_ci)
               loop
                  begin
                     select 1
                       into d_sequence
                       from aliquote_inail
                      where anno = p_anno
                        and posizione_inail = alin.posizione_inail;
                  exception
                     when no_data_found then
                        d_stp := null;
                        d_tim := to_char(sysdate, 'sssss');
                        begin
                           --Preleva nr max di segnalazioni
                           select nvl(max(progressivo), 0)
                             into d_prs
                             from a_segnalazioni_errore
                            where no_prenotazione = p_prenotazione
                              and passo = p_passo;
                        end;
                        d_prn          := p_prenotazione;
                        d_pas          := p_passo;
                        p_errore       := null;
                        p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno ||
                                          ' Posizione: ' || alin.posizione_inail || ' ' ||
                                          ' ### NON ELABORABILE ###';
                        --dbms_output.put_line('trace 13 tipo_elab = I ');
                        log_trace(15
                                 ,d_prn
                                 ,d_pas
                                 ,d_prs
                                 ,d_stp
                                 ,sql%rowcount
                                 ,d_tim
                                 ,p_errore
                                 ,p_segnalazione);
                        s_errore_prenotazione := 'P00109';
                        raise esci;
                  end;
               end loop;
               for giorni in (select ci
                                    ,anno
                                    ,mese
                                    ,count(*) num_periodi
                                    ,sum(giorni) giorni
                                    ,sum(al - dal + 1) gg_tot
                                    ,to_number(to_char(last_day(to_date(anno ||
                                                                        lpad(mese, 2, '0')
                                                                       ,'yyyymm'))
                                                      ,'dd')) gg_mese
                                    ,max(giorni) gg_max
                                from calcoli_retribuzioni_inail
                               where anno = p_anno
                                 and ci = p_ci
                                 and arretrato = 'C'
                               group by ci
                                       ,anno
                                       ,mese
                              having count(*) > 1 and sum(giorni) <> 26 and sum(al - dal + 1) = to_number(to_char(last_day(to_date(anno || lpad(mese, 2, '0'), 'yyyymm')), 'dd')))
               loop
                  begin
                     if giorni.giorni > 26 then
                        update calcoli_retribuzioni_inail crei
                           set giorni = giorni - 1
                         where ci = giorni.ci
                           and anno = giorni.anno
                           and mese = giorni.mese
                           and dal = (select max(dal)
                                        from calcoli_retribuzioni_inail
                                       where ci = giorni.ci
                                         and anno = giorni.anno
                                         and mese = giorni.mese
                                         and giorni = giorni.gg_max);
                     elsif giorni.giorni < 26 then
                        update calcoli_retribuzioni_inail crei
                           set giorni = giorni + 1
                         where ci = giorni.ci
                           and anno = giorni.anno
                           and mese = giorni.mese
                           and dal = (select max(dal)
                                        from calcoli_retribuzioni_inail
                                       where ci = giorni.ci
                                         and anno = giorni.anno
                                         and mese = giorni.mese
                                         and giorni = giorni.gg_max);
                     end if;
                  end;
               end loop;
               --dbms_output.put_line('Post spezza: '||P_CI);
               -- Aggiornamento del trattamento previdenziale per i periodi che non hanno
               -- il trattamento fisso su RAPPORTI_RETRIBUTIVI_STORICI.
               --Viene inoltre determinato l'eventuale codice di esenzione
               for tratt in (select posizione
                                   ,figura
                                   ,trattamento
                                   ,dal
                                   ,mese
                                   ,competenza
                                   ,gp4_rars.get_tipo_trattamento(p_ci, dal) tipo_trattamento
                               from calcoli_retribuzioni_inail crei
                              where anno = p_anno
                                and tipo_ipn = p_tipo
                                and ci = p_ci
                                and trattamento is null)
               loop
                  declare
                     d_tratt varchar2(4);
                  begin
                     --dbms_output.put_line('Determino trattamento ed esenzione: '||P_CI);
                     --dbms_output.put_line('Posizione                         : '||tratt.posizione);
                     --dbms_output.put_line('Figura                            : '||tratt.figura);
                     --dbms_output.put_line('Data                              : '||tratt.dal);
                     d_tratt := get_trattamento(tratt.posizione
                                               ,tratt.figura
                                               ,tratt.dal
                                               ,tratt.tipo_trattamento);
                     -- Determinazione dell'eventuale trattamento
                     update calcoli_retribuzioni_inail
                        set trattamento = d_tratt
                      where anno = p_anno
                        and tipo_ipn = p_tipo
                        and ci = p_ci
                        and dal = tratt.dal
                        and competenza = tratt.competenza;
                     -- Determinazione dell'eventuale codice di esenzione
                     d_esenzione := get_esenzione(tratt.posizione, d_tratt, p_anno);
                     --dbms_output.put_line('CI:'||p_ci||' '||tratt.posizione||' tratt:'||D_tratt||' '||p_anno||' '||p_tipo||' '||d_esenzione);
                     update calcoli_retribuzioni_inail
                        set esenzione = get_esenzione(tratt.posizione, d_tratt, p_anno)
                      where anno = p_anno
                        and ci = p_ci
                        and tipo_ipn = p_tipo
                        and dal = tratt.dal
                        and competenza = tratt.competenza;
                  end;
               end loop;
               --dbms_output.put_line('Post trattamento: '||P_CI);
               --commit;
               -- Se esistono delle ASSEGNAZIONI_CONTABILI, inseriamo delle registrazioni con le stesse
               -- caratteristiche giuridiche, ma con gli attributi di imputazione specifici. Nelle registrazioni
               -- gia esistenti, si aggiorna la quota
               d_progressivo := 1;
               begin
                  declare
                     ini_anno date;
                     fin_anno date;
                  begin
                     ini_anno := to_date('0101' || p_anno, 'ddmmyyyy');
                     fin_anno := to_date('3112' || p_anno, 'ddmmyyyy');
                     --dbms_output.put_line('Parametri  ANNO:'||p_anno||' CI:'||p_ci||' Tipo:'||P_tipo||' Tipo elab:'||P_tipo_elab);
                     for asco in (select ci
                                        ,nvl(dal, ini_anno) dal
                                        ,nvl(al, fin_anno) al
                                        ,settore
                                        ,sede
                                        ,quota
                                        ,intero
                                    from assegnazioni_contabili
                                   where ci = p_ci
                                     and nvl(al, to_date(3333333, 'j')) >= ini_anno
                                     and nvl(dal, to_date(2222222, 'j')) <= fin_anno)
                     loop
                        --dbms_output.put_line('Dal : '||asco.dal||'   al : '||asco.al);
                        for crei in (select ci
                                           ,anno
                                           ,mese
                                           ,dal
                                           ,al
                                           ,giorni
                                           ,gestione
                                           ,posizione
                                           ,figura
                                           ,qualifica
                                           ,trattamento
                                           ,settore
                                           ,sede
                                           ,posizione_inail
                                           ,esenzione
                                           ,ruolo
                                           ,tipo_ipn
                                           ,ore
                                           ,arretrato
                                       from calcoli_retribuzioni_inail
                                      where anno = p_anno
                                        and ci = p_ci
                                        and tipo_ipn = p_tipo
                                        and al >= asco.dal
                                        and dal <= asco.al
                                        and competenza = 'G'
                                      order by anno
                                              ,mese
                                              ,dal)
                        loop
                           --dbms_output.put_line('Inserisco i C .. CI:'||crei.ci||' Anno:'||crei.anno||' Mese:'||crei.mese||' Dal:'||asco.dal||' progressivo:'||d_progressivo||' posizione:'||crei.posizione_inail);
                           d_progressivo := d_progressivo + 1;
                           insert into calcoli_retribuzioni_inail
                              (ci
                              ,anno
                              ,mese
                              ,dal
                              ,al
                              ,giorni
                              ,gestione
                              ,posizione
                              ,figura
                              ,qualifica
                              ,trattamento
                              ,settore
                              ,sede
                              ,posizione_inail
                              ,esenzione
                              ,ruolo
                              ,tipo_ipn
                              ,competenza
                              ,progressivo
                              ,quota
                              ,intero
                              ,ore
                              ,arretrato)
                           values
                              (crei.ci
                              ,crei.anno
                              ,crei.mese
                              ,crei.dal
                              ,crei.al
                              ,crei.giorni
                              ,gp4_stam.get_gestione(gp4_stam.get_ni_numero(asco.settore))
                              ,crei.posizione
                              ,crei.figura
                              ,crei.qualifica
                              ,crei.trattamento
                              ,asco.settore
                              ,asco.sede
                              ,crei.posizione_inail
                              ,crei.esenzione
                              ,crei.ruolo
                              ,crei.tipo_ipn
                              ,'C'
                              ,d_progressivo
                              ,asco.quota
                              ,asco.intero
                              ,crei.ore
                              ,crei.arretrato);
                        end loop;
                        update calcoli_retribuzioni_inail crei
                           set (quota, intero) = (select max(intero) - sum(quota)
                                                        ,max(intero)
                                                    from calcoli_retribuzioni_inail
                                                   where ci = crei.ci
                                                     and anno = crei.anno
                                                     and mese = crei.mese
                                                     and dal = crei.dal
                                                     and tipo_ipn = p_tipo
                                                     and competenza = 'C')
                         where ci = asco.ci
                           and anno = p_anno
                           and tipo_ipn = p_tipo
                           and al >= asco.dal
                           and dal <= asco.al
                           and competenza = 'G';
                     end loop;
                  end;
                  -- Aggiorniamo i campi funzionale e CDC di CARI, verificando settore e sede sulle RIPARTIZIONI_FUNZIONALI
                  -- In caso di fallita attribuzione, dobbiamo dare una segnalazione.
                  begin
                     declare
                        d_funzionale ripartizioni_funzionali.funzionale%type;
                        d_cdc        ripartizioni_funzionali.cdc%type;
                     begin
                        for cari in (select ci
                                           ,anno
                                           ,mese
                                           ,dal
                                           ,competenza
                                           ,nvl(progressivo, 0) progressivo
                                           ,settore
                                           ,sede
                                       from calcoli_retribuzioni_inail
                                      where anno = p_anno
                                        and tipo_ipn = p_tipo
                                      order by ci
                                              ,anno
                                              ,mese
                                              ,dal)
                        loop
                           begin
                              select funzionale
                                    ,cdc
                                into d_funzionale
                                    ,d_cdc
                                from ripartizioni_funzionali
                               where settore = cari.settore
                                 and sede = nvl(cari.sede, 0);
                              if d_funzionale is null then
                                 null; -- Segnalazione di errata atttribuzione 2
                              end if;
                              if d_cdc is null then
                                 null; -- Segnalazione di errata atttribuzione 2
                              end if;
                              update calcoli_retribuzioni_inail
                                 set (funzionale, cdc) = (select d_funzionale
                                                                ,d_cdc
                                                            from dual)
                               where anno = cari.anno
                                 and mese = cari.mese
                                 and ci = cari.ci
                                 and dal = cari.dal
                                 and competenza = cari.competenza
                                 and nvl(progressivo, 0) = cari.progressivo;
                              --dbms_output.put_line('Ci : '||cari.ci||'  Anno : '||cari.anno||'  Mese : '||cari.mese||'  settore : '||cari.settore||'  sede : '||cari.sede||'  funzionale : '||d_funzionale||'  cdc : '||d_cdc);
                           exception
                              when no_data_found then
                                 null;
                                 -- Segnalazione di errata attribuzione 1
                           end;
                        end loop;
                     end;
                  end;
               end;
               begin
                  --Assegnazioni iniziali per trace
                  d_prn := p_prenotazione;
                  d_pas := p_passo;
                  if d_prn = 0 then
                     delete from a_segnalazioni_errore
                      where no_prenotazione = d_prn
                        and passo = d_pas;
                  end if;
                  begin
                     --Preleva nr max di segnalazioni
                     select nvl(max(progressivo), 0)
                       into d_prs
                       from a_segnalazioni_errore
                      where no_prenotazione = d_prn
                        and passo = d_pas;
                  end;
               end;
               /*               begin
                                 --Segnalazione iniziale - Commentata con l'att.19581
                                 d_stp := 'CREIN-Start CI:' || p_ci;
                                 d_tim := to_char(sysdate, 'sssss');
                                 log_trace(0
                                          ,d_prn
                                          ,d_pas
                                          ,d_prs
                                          ,d_stp
                                          ,0
                                          ,d_tim
                                          ,p_errore
                                          ,p_segnalazione);
                              end;
               */
               for cari in (select ci
                                  ,anno
                                  ,mese
                                  ,giorni
                                  ,ore
                                  ,gestione
                                  ,posizione
                                  ,trattamento
                                  ,posizione_inail
                                  ,tipo_ipn
                                  ,dal
                                  ,al
                                  ,ruolo
                                  ,figura
                                  ,qualifica
                                  ,funzionale
                                  ,imponibile
                                  ,arretrato
                              from calcoli_retribuzioni_inail cari
                             where anno = p_anno
                               and ci = p_ci
                               and tipo_ipn = p_tipo
                             order by ci
                                     ,anno
                                     ,mese
                                     ,dal)
               loop
                  begin
                     select 'SI'
                       into d_periodo_astensione
                       from periodi_giuridici pegi
                      where rilevanza = 'A'
                        and ci = p_ci
                        and dal <= cari.dal
                        and nvl(al, to_date(3333333, 'j')) >= cari.al
                        and exists (select 'x'
                               from astensioni aste
                              where codice = pegi.assenza
                                and aste.per_ret = 0
                                and aste.mat_inps = 0);
                  exception
                     when no_data_found then
                        d_periodo_astensione := 'NO';
                  end;
                  begin
                     select part_time
                       into d_part_time
                       from posizioni posi
                      where posi.codice = cari.posizione;
                  exception
                     when no_data_found then
                        d_part_time := 'NO';
                  end;
                  begin
                     select collaboratore
                       into d_coco
                       from posizioni posi
                      where posi.codice = cari.posizione;
                  exception
                     when no_data_found then
                        d_coco := 'NO';
                  end;
                  if d_coco is null then
                     d_coco   := 'NO';
                     d_stp    := null;
                     p_errore := 'P05694';
                     begin
                        --Preleva nr max di segnalazioni
                        select nvl(max(progressivo), 0)
                          into d_prs
                          from a_segnalazioni_errore
                         where no_prenotazione = d_prn
                           and passo = d_pas;
                     end;
                     p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                                       cari.mese || ' Data: ' ||
                                       to_char(cari.dal, 'dd/mm/yyyy') || ' Posizione:' ||
                                       cari.posizione;
                     log_trace(18
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,sql%rowcount
                              ,d_tim
                              ,p_errore
                              ,p_segnalazione);
                  end if;
                  begin
                     select 1
                       into d_note_dir
                       from contratti_storici
                      where contratto = gp4_qugi.get_contratto(cari.qualifica, cari.dal)
                        and cari.dal between nvl(dal, to_date(2222222, 'j')) and
                            nvl(al, to_date(3333333, 'j'))
                        and instr(note, '[Autoliquidazione:DIRIGENTE]') <> 0;
                  exception
                     when no_data_found then
                        d_note_dir := null;
                  end;
                  if gp4_qual.get_qua_inps(cari.qualifica) in ('9', '3') or
                     gp4_qual.get_qua_inps(cari.qualifica) = '2' and d_note_dir = 1 then
                     d_dirigente := 'SI';
                  end if;
                  --dbms_output.put_line(P_ci||' mese :'||CARI.mese||' Dal: '||CARI.dal||' ORE: '||CARI.ORE||' Ptime: '||d_part_time||' Coco: '||D_coco);
                  if d_part_time = 'SI' and d_coco = 'NO' and d_periodo_astensione = 'NO' and
                     cari.arretrato = 'C' then
                     d_ore_ind := cari.ore;
                     --        DBMS_OUTPUT.put_line ('D_ore_ind zero :' || d_ore_ind);
                     if d_ore_ind is null then
                        begin
                           begin
                              select gp4_cost.get_ore_lavoro(cari.qualifica, cari.al) *
                                     nvl(to_number(substr(ltrim(substr(note
                                                                      ,instr(note
                                                                            ,'VERTICALE:') + 10))
                                                         ,1
                                                         ,5))
                                        ,0) / 100
                                into d_ore_ind
                                from periodi_giuridici
                               where rilevanza = 'S'
                                 and ci = p_ci
                                 and note like '%VERTICALE:%'
                                 and cari.al between dal and
                                     nvl(al, to_date(3333333, 'j'));
                           exception
                              when no_data_found then
                                 d_ore_ind := 0;
                           end;
                           --        DBMS_OUTPUT.put_line ('D_ore_ind uno :' || d_ore_ind);
                           if nvl(d_ore_ind, 0) = 0 then
                              begin
                                 select gp4_cost.get_ore_lavoro(cari.qualifica, cari.al) *
                                        nvl(to_number(substr(ltrim(substr(note
                                                                         ,instr(note
                                                                               ,'MISTO:') + 6))
                                                            ,1
                                                            ,5))
                                           ,0) / 100
                                   into d_ore_ind
                                   from periodi_giuridici
                                  where rilevanza = 'S'
                                    and ci = p_ci
                                    and note like '%MISTO:%'
                                    and cari.al between dal and
                                        nvl(al, to_date(3333333, 'j'));
                              exception
                                 when no_data_found then
                                    d_ore_ind := 0;
                              end;
                           end if;
                           --                DBMS_OUTPUT.put_line ('D_ore_ind due :' || d_ore_ind);
                           if nvl(d_ore_ind, 0) = 0 then
                              d_ore_ind := gp4_cost.get_ore_lavoro(cari.qualifica
                                                                  ,cari.al);
                           end if;
                           --                 DBMS_OUTPUT.put_line ('D_ore_ind tre :' || d_ore_ind);
                           if nvl(d_ore_ind, 0) <> 0 then
                              d_stp    := null;
                              p_errore := 'P05689';
                              begin
                                 --Preleva nr max di segnalazioni
                                 select nvl(max(progressivo), 0)
                                   into d_prs
                                   from a_segnalazioni_errore
                                  where no_prenotazione = d_prn
                                    and passo = d_pas;
                              end;
                              p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno ||
                                                ' Mese: ' || cari.mese || ' Data: ' ||
                                                to_char(cari.dal, 'dd/mm/yyyy') ||
                                                ' Ore:' || round(d_ore_ind, 2);
                              log_trace(16
                                       ,d_prn
                                       ,d_pas
                                       ,d_prs
                                       ,d_stp
                                       ,sql%rowcount
                                       ,d_tim
                                       ,p_errore
                                       ,p_segnalazione);
                           end if;
                        exception
                           when no_data_found or too_many_rows then
                              d_ore_ind := 0;
                           when others then
                              d_ore_ind := 0;
                        end;
                     end if;
                     if nvl(d_ore_ind, 0) <> 0 then
                        --dbms_output.put_line('Esegue calcolo CALCOLO_RETRIBUZIONI_DIP_PT');
                        calcolo_retribuzioni_dip_pt(p_ci
                                                   ,p_anno
                                                   ,cari.mese
                                                   ,p_tipo
                                                   ,cari.dal
                                                   ,cari.al
                                                   ,cari.gestione
                                                   ,cari.posizione
                                                   ,cari.trattamento
                                                   ,cari.posizione_inail
                                                   ,cari.figura
                                                   ,cari.qualifica
                                                   ,cari.ruolo
                                                   ,d_ore_ind
                                                   ,d_tariffa
                                                   ,p_errore
                                                   ,p_segnalazione
                                                   ,p_prenotazione
                                                   ,p_passo);
                        if p_errore is not null then
                           d_stp := null;
                           --dbms_output.put_line('trace 7');
                           begin
                              --Preleva nr max di segnalazioni
                              select nvl(max(progressivo), 0)
                                into d_prs
                                from a_segnalazioni_errore
                               where no_prenotazione = d_prn
                                 and passo = d_pas;
                           end;
                           log_trace(7
                                    ,d_prn
                                    ,d_pas
                                    ,d_prs
                                    ,d_stp
                                    ,sql%rowcount
                                    ,d_tim
                                    ,p_errore
                                    ,p_segnalazione);
                        end if;
                        if d_tariffa is null then
                           d_stp := null;
                           begin
                              --Preleva nr max di segnalazioni
                              select nvl(max(progressivo), 0)
                                into d_prs
                                from a_segnalazioni_errore
                               where no_prenotazione = d_prn
                                 and passo = d_pas;
                           end;
                           p_errore       := null;
                           p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno ||
                                             ' Mese: ' || cari.mese || ' Data: ' ||
                                             to_char(cari.dal, 'dd/mm/yyyy') || ' ';
                           --dbms_output.put_line('trace 6');
                           log_trace(6
                                    ,d_prn
                                    ,d_pas
                                    ,d_prs
                                    ,d_stp
                                    ,sql%rowcount
                                    ,d_tim
                                    ,p_errore
                                    ,p_segnalazione);
                        end if;
                     else
                        d_stp    := null;
                        p_errore := null;
                        begin
                           --Preleva nr max di segnalazioni
                           select nvl(max(progressivo), 0)
                             into d_prs
                             from a_segnalazioni_errore
                            where no_prenotazione = d_prn
                              and passo = d_pas;
                        end;
                        p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno ||
                                          ' Mese: ' || cari.mese || ' Data: ' ||
                                          to_char(cari.dal, 'dd/mm/yyyy') || ' ';
                        --dbms_output.put_line('trace 5');
                        log_trace(5
                                 ,d_prn
                                 ,d_pas
                                 ,d_prs
                                 ,d_stp
                                 ,sql%rowcount
                                 ,d_tim
                                 ,p_errore
                                 ,p_segnalazione);
                     end if;
                  end if;
                  if d_coco = 'SI' and d_part_time = 'NO' and cari.arretrato = 'C' then
                     --dbms_output.put_line(P_ci||' mese :'||CARI.mese||' Dal: '||CARI.dal||' ORE: '||CARI.ORE||' Ptime: '||d_part_time||' Coco: '||D_coco);
                     --dbms_output.put_line('Esegue calcolo CALCOLO_RETRIBUZIONI_COCO');
                     calcolo_retribuzioni_coco(p_ci
                                              ,p_anno
                                              ,cari.mese
                                              ,p_tipo
                                              ,cari.dal
                                              ,cari.gestione
                                              ,cari.posizione
                                              ,cari.trattamento
                                              ,cari.posizione_inail
                                              ,cari.figura
                                              ,cari.qualifica
                                              ,cari.giorni
                                              ,p_prenotazione
                                              ,p_passo);
                  end if;
                  if d_part_time = 'NO' and d_coco = 'NO' then
                     --dbms_output.put_line('Esegue calcolo CALCOLO_RETRIBUZIONI_DIP_TP');
                     if d_dirigente = 'SI' and d_periodo_astensione = 'SI' then
                        null;
                     else
                        calcolo_retribuzioni_dip_tp(p_ci
                                                   ,p_anno
                                                   ,cari.mese
                                                   ,p_tipo
                                                   ,cari.dal
                                                   ,cari.gestione
                                                   ,cari.posizione
                                                   ,cari.trattamento
                                                   ,cari.posizione_inail
                                                   ,cari.figura
                                                   ,cari.giorni
                                                   ,cari.qualifica
                                                   ,d_dirigente
                                                   ,cari.arretrato
                                                   ,p_prenotazione
                                                   ,p_passo);
                     end if;
                  end if;
                  if d_part_time = 'SI' and d_coco = 'SI' then
                     d_stp := null;
                     begin
                        --Preleva nr max di segnalazioni
                        select nvl(max(progressivo), 0)
                          into d_prs
                          from a_segnalazioni_errore
                         where no_prenotazione = d_prn
                           and passo = d_pas;
                     end;
                     p_errore       := null;
                     p_segnalazione := 'CI: ' || p_ci || ' Anno: ' || p_anno || ' Mese: ' ||
                                       cari.mese || ' Data: ' ||
                                       to_char(cari.dal, 'dd/mm/yyyy') || ' ';
                     --dbms_output.put_line('trace 4');
                     log_trace(4
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,sql%rowcount
                              ,d_tim
                              ,p_errore
                              ,p_segnalazione);
                  end if;
                  d_voce_contributo := get_voce_contributo(cari.posizione_inail
                                                          ,cari.gestione
                                                          ,gp4_qugi.get_contratto(cari.qualifica
                                                                                 ,cari.dal)
                                                          ,cari.trattamento
                                                          ,cari.dal);
                  --dbms_output.put_line('D_voce_contributo:'||D_voce_contributo);
               end loop;
               --dbms_output.put_line('Termine calcolo imponibili');
               /*               begin           -- segnalazione di stop eliminata con l'att.19581
                                 --Operazioni finali per trace
                                 d_stp          := 'CREIN-Stop';
                                 p_errore       := null;
                                 p_segnalazione := null;
                                 begin
                                    --Preleva nr max di segnalazioni
                                    select nvl(max(progressivo), 0)
                                      into d_prs
                                      from a_segnalazioni_errore
                                     where no_prenotazione = d_prn
                                       and passo = d_pas;
                                 end;
                                 log_trace(2
                                          ,d_prn
                                          ,d_pas
                                          ,d_prs
                                          ,d_stp
                                          ,0
                                          ,d_tim
                                          ,p_errore
                                          ,p_segnalazione);
                                 if p_errore != 'P05809' and p_errore != 'P05808' and
                                    p_errore != 'P00872' and p_errore != 'P00873' and
                                    p_errore != 'P05674' and p_errore != 'P05673' and
                                    p_errore != 'P05672' then
                                    p_errore := 'P05802'; --Elaborazione completata
                                 end if;
                                 --    commit;
                              end;
               */ --eliminazione dei record di REIN per ci,anno e tipo
               --dbms_output.put_line('delete da REIN');
               delete from retribuzioni_inail
                where anno = p_anno
                  and ci = p_ci
                  and tipo_ipn = p_tipo;
               --inserimento su REIN --
               begin
                  select utente
                        ,sysdate
                    into d_utente
                        ,d_data_agg
                    from a_prenotazioni
                   where no_prenotazione = p_prenotazione;
               exception
                  when no_data_found then
                     d_utente := null;
               end;
               for vimi in (select ci
                                  ,anno
                                  ,gestione
                                  ,posizione_inail
                                  ,esenzione
                                  ,capitolo
                                  ,articolo
                                  ,risorsa_intervento
                                  ,impegno
                                  ,sub_impegno
                                  ,anno_impegno
                                  ,anno_sub_impegno
                                  ,codice_siope
                                  ,conto
                                  ,cdc
                                  ,tipo_ipn
                                  ,ruolo
                                  ,funzionale
                                  ,sum(imponibile) imponibile
                                  ,sum(premio) premio
                                  ,1 origine
                              from vista_imputazioni_inail
                             where ci = p_ci
                               and anno = p_anno
                               and tipo_ipn = p_tipo
                             group by ci
                                     ,anno
                                     ,gestione
                                     ,posizione_inail
                                     ,esenzione
                                     ,capitolo
                                     ,articolo
                                     ,conto
                                     ,risorsa_intervento
                                     ,impegno
                                     ,sub_impegno
                                     ,anno_impegno
                                     ,anno_sub_impegno
                                     ,codice_siope
                                     ,cdc
                                     ,tipo_ipn
                                     ,ruolo
                                     ,funzionale
                            having sum(imponibile) != 0
                            union
                            select ci
                                  ,anno
                                  ,gestione
                                  ,posizione_inail
                                  ,esenzione
                                  ,to_char(null)
                                  ,to_char(null)
                                  ,to_char(null)
                                  ,to_number(null)
                                  ,to_number(null)
                                  ,to_number(null)
                                  ,to_number(null)
                                  ,to_number(null)
                                  ,to_char(null)
                                  ,cdc
                                  ,tipo_ipn
                                  ,ruolo
                                  ,funzionale
                                  ,sum(imponibile) imponibile
                                  ,sum(premio) premio
                                  ,2 origine
                              from calcoli_retribuzioni_inail crei
                             where ci = p_ci
                               and anno = p_anno
                               and tipo_ipn = p_tipo
                               and not exists
                             (select 'x'
                                      from vista_imputazioni_inail
                                     where ci = crei.ci
                                       and anno = crei.anno
                                       and tipo_ipn = crei.tipo_ipn
                                       and gestione = crei.gestione
                                       and posizione_inail = crei.posizione_inail
                                       and nvl(esenzione, ' ') = nvl(crei.esenzione, ' ')
                                       and nvl(cdc, ' ') = nvl(crei.cdc, ' ')
                                       and ruolo = crei.ruolo
                                       and nvl(funzionale, ' ') = nvl(crei.funzionale, ' '))
                             group by ci
                                     ,anno
                                     ,gestione
                                     ,posizione_inail
                                     ,esenzione
                                     ,cdc
                                     ,tipo_ipn
                                     ,ruolo
                                     ,funzionale
                            having sum(imponibile) != 0)
               loop
                  if vimi.origine = 2 then
                     d_stp    := null;
                     p_errore := 'P05693';
                     begin
                        --Preleva nr max di segnalazioni
                        select nvl(max(progressivo), 0)
                          into d_prs
                          from a_segnalazioni_errore
                         where no_prenotazione = d_prn
                           and passo = d_pas;
                     end;
                     p_segnalazione := 'CI: ' || p_ci || ' Gestione: ' || vimi.gestione ||
                                       ' Posizione: ' || vimi.posizione_inail ||
                                       ' Esenzione: ' || vimi.esenzione || ' CDC: ' ||
                                       vimi.cdc || ' Ruolo: ' || vimi.ruolo ||
                                       ' Funzionale: ' || vimi.funzionale;
                     log_trace(17
                              ,d_prn
                              ,d_pas
                              ,d_prs
                              ,d_stp
                              ,sql%rowcount
                              ,d_tim
                              ,p_errore
                              ,p_segnalazione);
                  end if;
                  select imin_sq.nextval into d_sequence from dual;
                  begin
                     insert into retribuzioni_inail
                        (imin_id
                        ,ci
                        ,anno
                        ,gestione
                        ,posizione_inail
                        ,esenzione
                        ,capitolo
                        ,articolo
                        ,risorsa_intervento
                        ,impegno
                        ,sub_impegno
                        ,anno_impegno
                        ,anno_sub_impegno
                        ,codice_siope
                        ,conto
                        ,cdc
                        ,tipo_ipn
                        ,ruolo
                        ,funzionale
                        ,imponibile
                        ,premio
                        ,utente
                        ,data_agg)
                     values
                        (d_sequence
                        ,vimi.ci
                        ,vimi.anno
                        ,vimi.gestione
                        ,vimi.posizione_inail
                        ,vimi.esenzione
                        ,vimi.capitolo
                        ,vimi.articolo
                        ,vimi.risorsa_intervento
                        ,vimi.impegno
                        ,vimi.sub_impegno
                        ,vimi.anno_impegno
                        ,vimi.anno_sub_impegno
                        ,vimi.codice_siope
                        ,vimi.conto
                        ,vimi.cdc
                        ,vimi.tipo_ipn
                        ,vimi.ruolo
                        ,vimi.funzionale
                        ,vimi.imponibile
                        ,vimi.premio
                        ,d_utente
                        ,d_data_agg);
                  exception
                     when others then
                        null;
                        --dbms_output.put_line ('CI errato :'||p_ci);
                  end;
               end loop;
               calcolo_premio_inail(p_anno
                                   ,p_ci
                                   ,p_tipo
                                   ,p_errore
                                   ,p_segnalazione
                                   ,p_prenotazione
                                   ,p_passo);
               --   EXCEPTION
               --     WHEN OTHERS THEN --dbms_output.put_line ('CI errato :'||p_ci);
               --dbms_output.put_line('Seconda delete '||p_ci);
               delete from calcoli_retribuzioni_inail
                where anno = p_anno
                  and ci = p_ci;
            end;
         elsif p_tipo = 'P' then
            --Preventivo
            delete from retribuzioni_inail
             where anno = p_anno
               and ci = p_ci
               and tipo_ipn = p_tipo;
            insert into retribuzioni_inail
               (imin_id
               ,ci
               ,anno
               ,gestione
               ,posizione_inail
               ,esenzione
               ,capitolo
               ,articolo
               ,conto
               ,cdc
               ,tipo_ipn
               ,ruolo
               ,funzionale
               ,imponibile
               ,premio
               ,utente
               ,data_agg
               ,risorsa_intervento
               ,impegno
               ,anno_impegno
               ,sub_impegno
               ,anno_sub_impegno
               ,codice_siope)
               select imin_sq.nextval
                     ,ci
                     ,p_anno
                     ,gestione
                     ,posizione_inail
                     ,esenzione
                     ,capitolo
                     ,articolo
                     ,conto
                     ,cdc
                     ,p_tipo
                     ,ruolo
                     ,funzionale
                     ,imponibile
                     ,0 premio
                     ,d_utente
                     ,d_data_agg
                     ,risorsa_intervento
                     ,impegno
                     ,anno_impegno
                     ,sub_impegno
                     ,anno_sub_impegno
                     ,codice_siope
                 from retribuzioni_inail
                where anno = p_anno - 1
                  and ci = p_ci
                  and tipo_ipn = 'C';
         end if;
         -- Calcolo del premio
         --dbms_output.put_line('Parametri  ANNO:'||p_anno||' CI:'||p_ci||' Tipo:'||P_tipo||' Tipo elab:'||P_tipo_elab);
         calcolo_premio_inail(p_anno
                             ,p_ci
                             ,p_tipo
                             ,p_errore
                             ,p_segnalazione
                             ,p_prenotazione
                             ,p_passo);
      exception
         when esci then
            null;
      end;
   end calcolo_retribuzione_inail;
   --
   function get_posizione_inail
   (
      p_ci   in number
     ,p_data in date
   ) return varchar2 is
      d_posizione varchar2(15);
   begin
      d_posizione := to_char(null);
      begin
         select posizione_inail
           into d_posizione
           from rapporti_retributivi_storici
          where ci = p_ci
            and p_data between dal and nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            /* se situazione anomala, ritorna null */
            d_posizione := to_char(null);
      end;
      return d_posizione;
   end get_posizione_inail;
   --
   function get_tipo_inail(p_posizione in varchar2) return varchar2 is
      d_tipo varchar2(15);
   begin
      begin
         d_tipo := to_char(null);
         begin
            select nvl(collaboratore, 'NO') || nvl(part_time, 'NO')
              into d_tipo
              from posizioni
             where codice = p_posizione;
         exception
            when no_data_found then
               /* se posizione errata, ritorna null */
               d_tipo := to_char(null);
         end;
         if d_tipo = 'NONO' then
            d_tipo := 'DIPENDENTE';
            return d_tipo;
         end if;
         if d_tipo = 'NOSI' then
            d_tipo := 'PART-TIME';
            return d_tipo;
         end if;
         if d_tipo = 'SINO' then
            d_tipo := 'COLLABORATORE';
            return d_tipo;
         end if;
      end;
   end get_tipo_inail;
   --
   function get_trattamento
   (
      p_posizione        in varchar2
     ,p_figura           in number
     ,p_data             in date
     ,p_tipo_trattamento in varchar2
   ) return varchar2 is
      d_trattamento rapporti_retributivi_storici.trattamento%type;
   begin
      begin
         select trco.trattamento
           into d_trattamento
           from trattamenti_contabili trco
          where trco.posizione = p_posizione
            and trco.tipo_trattamento = p_tipo_trattamento
            and trco.profilo_professionale =
                (select profilo
                   from figure_giuridiche
                  where numero = p_figura
                    and p_data between nvl(dal, to_date(2222222, 'j')) and
                        nvl(al, to_date(3333333, 'j')));
      exception
         when no_data_found then
            d_trattamento := 'X';
      end;
      return d_trattamento;
   end get_trattamento;
   --
   function get_esenzione
   (
      p_posizione   in varchar2
     ,p_trattamento in varchar2
     ,p_anno        in number
   ) return varchar2 is
      d_esenzione esenzioni_inail.esenzione%type;
   begin
      begin
         select resi.esenzione
           into d_esenzione
           from righe_esenzione_inail resi
          where anno = p_anno
            and (p_posizione = nvl(resi.posizione, 'x') or
                p_trattamento = nvl(resi.trattamento, 'x'));
      exception
         when no_data_found then
            d_esenzione := to_char(null);
      end;
      return d_esenzione;
   end get_esenzione;
   --
   function get_voce_ipn
   (
      p_posizione_inail in varchar2
     ,p_gestione        in varchar2
     ,p_contratto       in varchar2
     ,p_trattamento     in varchar2
     ,p_data            in date
   ) return varchar2 is
      /* Restituisce il codice della voce economica che rappresenta l'imponibile INAIL per gli attributi indicati */
      d_voce varchar2(20);
   begin
      begin
         select rpad(max(rivo.cod_voce_ipn), 10, ' ') ||
                rpad(max(rivo.sub_voce_ipn), 2, ' ')
           into d_voce
           from voci_inail       voin
               ,contabilita_voce covo
               ,ritenute_voce    rivo
          where (rivo.voce, rivo.sub) in
                (select voce
                       ,sub
                   from estrazioni_voce
                  where p_gestione like gestione
                    and p_contratto like contratto
                    and p_trattamento like trattamento)
            and covo.voce = rivo.voce
            and covo.sub = rivo.sub
            and p_data between nvl(rivo.dal, to_date(2222222, 'j')) and
                nvl(rivo.al, to_date(3333333, 'j'))
            and p_data between nvl(covo.dal, to_date(2222222, 'j')) and
                nvl(covo.al, to_date(3333333, 'j'))
            and exists (select 'x'
                   from voci_economiche
                  where specifica = 'IPN_INAIL'
                    and codice = rivo.cod_voce_ipn)
            and voin.voce = covo.voce
            and voin.sub = covo.sub
            and voin.codice = p_posizione_inail;
      exception
         when no_data_found then
            d_voce := to_char(null);
         when too_many_rows then
            d_voce := to_char(null);
      end;
      return d_voce;
   end get_voce_ipn;
   --
   function get_voce_contributo
   (
      p_posizione_inail in varchar2
     ,p_gestione        in varchar2
     ,p_contratto       in varchar2
     ,p_trattamento     in varchar2
     ,p_data            in date
   ) return varchar2 is
      /* Restituisce la voce di contributo economica per gli attributi indicati */
      d_voce varchar2(20);
   begin
      begin
         select max(rpad(rivo.voce, 10, ' ') || rpad(rivo.sub, 2, ' '))
           into d_voce
           from voci_inail       voin
               ,contabilita_voce covo
               ,ritenute_voce    rivo
          where (rivo.voce, rivo.sub) in
                (select voce
                       ,sub
                   from estrazioni_voce
                  where p_gestione like gestione
                    and p_contratto like contratto
                    and p_trattamento like trattamento
                    and condizione in ('M', 'S'))
            and exists (select 'x'
                   from voci_economiche
                  where codice = covo.voce
                    and tipo = 'F')
            and exists (select 'x'
                   from voci_economiche
                  where codice = rivo.cod_voce_ipn
                    and specifica = 'IPN_INAIL')
            and covo.voce = rivo.voce
            and covo.sub = rivo.sub
            and p_data between nvl(rivo.dal, to_date(2222222, 'j')) and
                nvl(rivo.al, to_date(3333333, 'j'))
            and p_data between nvl(covo.dal, to_date(2222222, 'j')) and
                nvl(covo.al, to_date(3333333, 'j'))
            and voin.voce = covo.voce
            and voin.sub = covo.sub
            and voin.codice = p_posizione_inail;
      exception
         when no_data_found then
            d_voce := to_char(null);
         when too_many_rows then
            d_voce := to_char(null);
      end;
      return d_voce;
   end get_voce_contributo;
   --
   function get_bilancio_contributo
   (
      p_posizione_inail in varchar2
     ,p_gestione        in varchar2
     ,p_contratto       in varchar2
     ,p_trattamento     in varchar2
     ,p_data            in date
   ) return varchar2 is
      /* Restituisce il codice di bilancio della voce di contributo INAIL per gli attributi indicati */
      d_bilancio varchar2(20);
   begin
      begin
         select covo.bilancio
           into d_bilancio
           from voci_inail       voin
               ,contabilita_voce covo
               ,ritenute_voce    rivo
          where (rivo.voce, rivo.sub) in
                (select voce
                       ,sub
                   from estrazioni_voce
                  where p_gestione like gestione
                    and p_contratto like contratto
                    and p_trattamento like trattamento)
            and covo.voce = rivo.voce
            and covo.sub = rivo.sub
            and p_data between nvl(rivo.dal, to_date(2222222, 'j')) and
                nvl(rivo.al, to_date(3333333, 'j'))
            and p_data between nvl(covo.dal, to_date(2222222, 'j')) and
                nvl(covo.al, to_date(3333333, 'j'))
            and voin.voce = covo.voce
            and voin.sub = covo.sub
            and voin.codice = p_posizione_inail;
      exception
         when no_data_found then
            d_bilancio := to_char(null);
         when too_many_rows then
            d_bilancio := to_char(null);
      end;
      return d_bilancio;
   end get_bilancio_contributo;
   --
   function get_giorni_inail
   (
      p_ci   in number
     ,p_dal  in date
     ,p_al   in date
     ,p_anno in number
     ,p_mese in number
     ,p_sede in number
   ) return number is
      /* Calcolo delle giornate in 26esimi, dati ci e periodo */
      d_gg_inail       number;
      d_giorno         number;
      d_gg_fin_periodo number;
      d_gg_ini_periodo number;
      d_giorni         varchar2(1);
   begin
      begin
         if to_char(p_al, 'dd') = to_char(last_day(p_al), 'dd') and
            to_char(p_dal, 'dd') = '01' then
            d_gg_inail := 26;
            return d_gg_inail;
         else
            begin
               d_gg_fin_periodo := to_number(to_char(p_al, 'dd'));
               d_gg_ini_periodo := to_number(to_char(p_dal, 'dd'));
               d_giorno         := d_gg_ini_periodo;
               d_gg_inail       := 0;
               while d_giorno <= d_gg_fin_periodo
               loop
                  begin
                     --Estrazione del giorno da Calendario
                     select substr(giorni, d_giorno, 1)
                       into d_giorni
                       from calendari
                      where calendario = (select nvl(max(calendario), '*')
                                            from sedi
                                           where numero = p_sede)
                        and anno = p_anno
                        and mese = p_mese;
                  exception
                     when no_data_found or too_many_rows then
                        null;
                  end;
                  if d_giorni in ('f', 'F', 's', 'S') then
                     d_gg_inail := d_gg_inail + 1;
                  end if;
                  d_giorno := d_giorno + 1;
               end loop;
            end;
            return d_gg_inail;
         end if;
      end;
   end get_giorni_inail;
   --
   function get_capitolo
   (
      p_anno            in number
     ,p_dal             in date
     ,p_voce_contributo in varchar2
     ,p_sub_contributo  in varchar2
     ,p_gestione        in varchar2
     ,p_funzionale      in varchar2
     ,p_ruolo           in varchar2
     ,p_posizione       in varchar2
     ,p_imponibile      in number
   ) return varchar2 is
      /*Restituisce la concatenazione dei campi relativi a capitolo, articolo e conto di una registrazione su CARI */
      d_capitolo varchar2(100);
   begin
      begin
         select rpad(decode(cobi.codice
                           ,covo.bilancio
                           ,decode(covo.capitolo
                                  ,null
                                  ,nvl(rico.capitolo, '0')
                                  ,covo.capitolo)
                           ,nvl(rico.capitolo, '0'))
                    ,14
                    ,' ') || rpad(decode(cobi.codice
                                        ,covo.bilancio
                                        ,decode(covo.capitolo
                                               ,null
                                               ,nvl(rico.articolo, '0')
                                               ,nvl(covo.articolo, '0'))
                                        ,nvl(rico.articolo, '0'))
                                 ,14
                                 ,' ') ||
                rpad(decode(rico.arr
                           ,'P'
                           ,nvl(decode(cobi.codice
                                      ,covo.bilancio
                                      ,decode(covo.capitolo, null, rico.conto, covo.conto)
                                      ,rico.conto)
                               ,decode(least(to_char(p_dal, 'yyyy'), p_anno)
                                      ,p_anno
                                      ,'AP'
                                      ,substr(to_char(p_dal, 'yy'), 1, 2)))
                           ,decode(cobi.codice
                                  ,covo.bilancio
                                  ,decode(covo.capitolo, null, rico.conto, covo.conto)
                                  ,rico.conto))
                    ,2
                    ,' ')
           into d_capitolo
           from ripartizioni_contabili rico
               ,posizioni              posi
               ,contabilita_voce       covo
               ,codici_bilancio        cobi
               ,mesi                   mese
          where cobi.codice = nvl(rico.input_bilancio, covo.bilancio)
            and covo.bilancio != '0'
            and covo.voce = p_voce_contributo
            and covo.sub = p_sub_contributo
            and p_dal between nvl(covo.dal, to_date(2222222, 'j')) and
                nvl(covo.al, to_date(3333333, 'j'))
            and posi.codice = p_posizione
            and mese.anno = p_anno
            and (mese.mese = 1 or
                (nvl(p_imponibile, 0) != 0 and
                p_anno = to_number(to_char(p_dal, 'yyyy')) and mese.mese = 2))
            and rico.chiave =
                (select max(chiave)
                   from ripartizioni_contabili
                  where (bilancio = covo.bilancio or bilancio = '%')
                    and (decode(mese.anno
                               ,p_anno
                               ,decode(mese.mese, 1, 'C', decode(arr, '%', null, 'P'))
                               ,'P') like arr or
                        mese.anno != p_anno and
                        to_char(p_anno - to_number(to_char(p_dal, 'yyyy'))) = arr)
                    and nvl(p_funzionale, ' ') like funzionale
                    and nvl(posi.di_ruolo, ' ') like di_ruolo
                    and nvl(p_ruolo, ' ') like ruolo
                    and nvl(p_gestione, ' ') like gestione
                    and arr = 'C');
      exception
         when no_data_found then
            d_capitolo := null;
         when too_many_rows then
            d_capitolo := null;
      end;
      return d_capitolo;
   end get_capitolo;
   --
   function calcolo_ipn_mese
   (
      p_ci   in number
     ,p_voce in varchar2
     ,p_anno in number
     ,p_mese in number
   ) return number is
      /* Calcolo della somma mensile delle competenze soggette inail , dati ci e mese */
      d_totale number;
   begin
      begin
         select nvl(sum(nvl(moco.imp, 0) *
                        decode(nvl(tovo.tipo, 'I'), 'I', 1, 'V', 1, 'D', 1, 0) *
                        nvl(tovo.per_tot, 100) / 100)
                   ,0)
           into d_totale
           from totalizzazioni_voce tovo
               ,movimenti_contabili moco
          where tovo.voce = moco.voce || ''
            and tovo.voce_acc = p_voce
            and nvl(tovo.sub, moco.sub) = moco.sub
            and moco.ci = p_ci
            and moco.anno = p_anno
            and moco.mese = p_mese
            and moco.riferimento between nvl(tovo.dal, to_date(2222222, 'j')) and
                nvl(tovo.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_ipn_mese;
   --
   function calcolo_ipn_anno
   (
      p_ci   in number
     ,p_voce in varchar2
     ,p_anno in number
   ) return number is
      /* Calcolo della somma annuale delle competenze soggette inail , dati ci e anno*/
      d_totale number;
   begin
      begin
         select nvl(sum(nvl(moco.imp, 0) *
                        decode(nvl(tovo.tipo, 'I'), 'I', 1, 'V', 1, 'D', 1, 0) *
                        nvl(tovo.per_tot, 100) / 100)
                   ,0)
           into d_totale
           from totalizzazioni_voce tovo
               ,movimenti_contabili moco
          where tovo.voce = moco.voce || ''
            and tovo.voce_acc = p_voce
            and nvl(tovo.sub, moco.sub) = moco.sub
            and moco.ci = p_ci
            and moco.anno = p_anno
            and moco.riferimento between nvl(tovo.dal, to_date(2222222, 'j')) and
                nvl(tovo.al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_ipn_anno;
   --
   function premi_inail
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number is
      d_totale totali_retribuzioni_inail.premio%type;
   begin
      begin
         d_totale := null;
         select sum(premio)
           into d_totale
           from totali_retribuzioni_inail
          where anno = p_anno
            and gestione like p_gestione
            and posizione_inail like p_posizione
            and tipo_ipn = p_tipo;
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end premi_inail;
   --
   function premi_inail_ruolo
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_ruolo     in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number is
      d_totale totali_retribuzioni_inail.premio%type;
   begin
      begin
         d_totale := null;
         select sum(premio)
           into d_totale
           from totali_retribuzioni_inail
          where anno = p_anno
            and gestione like p_gestione
            and ruolo like p_ruolo
            and posizione_inail like p_posizione
            and tipo_ipn = p_tipo;
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end premi_inail_ruolo;
   --
   function calcolo_retr_parz_esente
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number is
      d_totale vista_retribuzioni_inail.parz_esente%type;
   begin
      begin
         d_totale := null;
         select sum(decode(gp4_alei.get_aliquota(esenzione, anno)
                          ,100
                          ,0
                          ,imponibile * gp4_alei.get_aliquota(esenzione, anno) / 100))
           into d_totale
           from totali_retribuzioni_inail
          where anno = p_anno
            and gestione like p_gestione
            and posizione_inail like p_posizione
            and tipo_ipn = p_tipo;
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_retr_parz_esente;
   --
   function calcolo_retr_effettiva
   (
      p_ci         in number
     ,p_anno       in number
     ,p_gestione   in varchar2
     ,p_ruolo      in varchar2
     ,p_posizione  in varchar2
     ,p_esenzione  in varchar2
     ,p_funzionale in varchar2
     ,p_conto      in varchar2
     ,p_cdc        in varchar2
     ,p_tipo       in varchar2
   ) return number is
      d_totale      retribuzioni_inail.imponibile%type;
      d_ci1         rapporti_individuali.ci%type;
      d_ci2         rapporti_individuali.ci%type;
      d_contabilita ente.contabilita%type;
   begin
      begin
         select contabilita into d_contabilita from ente;
      end;
      begin
         d_totale := null;
         if p_ci is null then
            d_ci1 := 0;
            d_ci2 := 99999999;
         else
            d_ci1 := p_ci;
            d_ci2 := p_ci;
         end if;
         select sum(imponibile)
           into d_totale
           from retribuzioni_inail
          where anno = p_anno
            and nvl(gestione, ' ') like nvl(p_gestione, ' ')
            and nvl(ruolo, ' ') like nvl(p_ruolo, ' ')
            and nvl(posizione_inail, ' ') like nvl(p_posizione, ' ')
            and tipo_ipn like p_tipo
            and ci between d_ci1 and d_ci2
            and nvl(esenzione, ' ') like nvl(p_esenzione, ' ')
            and nvl(funzionale, ' ') like nvl(p_funzionale, ' ')
            and (d_contabilita = 'E' and
                nvl(capitolo || '/' || articolo || '-' || conto, ' ') like
                nvl(p_conto, ' ') or
                d_contabilita = 'F' and
                nvl(risorsa_intervento || '.' || capitolo || '/' || articolo || '-' ||
                     conto || ' ' || impegno || '/' || anno_impegno || ' ' || sub_impegno || '/' ||
                     anno_sub_impegno || ' ' || codice_siope
                    ,' ') like nvl(p_conto, ' '))
            and nvl(cdc, ' ') like nvl(p_cdc, ' ');
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_retr_effettiva;
   --
   --
   function calcolo_premio_effettivo
   (
      p_ci         in number
     ,p_anno       in number
     ,p_gestione   in varchar2
     ,p_ruolo      in varchar2
     ,p_posizione  in varchar2
     ,p_esenzione  in varchar2
     ,p_funzionale in varchar2
     ,p_conto      in varchar2
     ,p_cdc        in varchar2
     ,p_tipo       in varchar2
   ) return number is
      d_totale      retribuzioni_inail.premio%type;
      d_ci1         rapporti_individuali.ci%type;
      d_ci2         rapporti_individuali.ci%type;
      d_contabilita ente.contabilita%type;
   begin
      begin
         select contabilita into d_contabilita from ente;
      end;
      begin
         d_totale := null;
         if p_ci is null then
            d_ci1 := 0;
            d_ci2 := 99999999;
         else
            d_ci1 := p_ci;
            d_ci2 := p_ci;
         end if;
         select sum(premio)
           into d_totale
           from retribuzioni_inail
          where anno = p_anno
            and nvl(gestione, ' ') like nvl(p_gestione, ' ')
            and nvl(ruolo, ' ') like nvl(p_ruolo, ' ')
            and nvl(posizione_inail, ' ') like nvl(p_posizione, ' ')
            and tipo_ipn like p_tipo
            and ci between d_ci1 and d_ci2
            and nvl(esenzione, ' ') like nvl(p_esenzione, ' ')
            and nvl(funzionale, ' ') like nvl(p_funzionale, ' ')
            and (d_contabilita = 'E' and
                nvl(capitolo || '/' || articolo || '-' || conto, ' ') like
                nvl(p_conto, ' ') or
                d_contabilita = 'F' and
                nvl(risorsa_intervento || '.' || capitolo || '/' || articolo || '-' ||
                     conto || ' ' || impegno || '/' || anno_impegno || ' ' || sub_impegno || '/' ||
                     anno_sub_impegno || ' ' || codice_siope
                    ,' ') like nvl(p_conto, ' '))
            and nvl(cdc, ' ') like nvl(p_cdc, ' ');
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_premio_effettivo;
   --
   function calcolo_regolazione
   (
      p_anno               in number
     ,p_tipo               in varchar2
     ,p_gestione           in varchar2
     ,p_funzionale         in varchar2
     ,p_cdc                in varchar2
     ,p_ruolo              in varchar2
     ,p_capitolo           in varchar2
     ,p_articolo           in varchar2
     ,p_conto              in varchar2
     ,p_risorsa_intervento in varchar2
     ,p_impegno            in number
     ,p_anno_impegno       in number
     ,p_sub_impegno        in number
     ,p_anno_sub_impegno   in number
     ,p_codice_siope       in number
   ) return number is
      d_totale totali_retribuzioni_inail.premio%type;
      /* Calcolo della regolazione */
   begin
      begin
         d_totale := null;
         select sum(decode(p_tipo
                          ,'I'
                          ,nvl(imponibile, 0) * decode(tipo_ipn, 'P', -1, 'C', 1)
                          ,nvl(premio, 0) * decode(tipo_ipn, 'P', -1, 'C', 1)))
           into d_totale
           from totali_retribuzioni_inail
          where anno = p_anno
            and nvl(gestione, ' ') like nvl(p_gestione, ' ')
            and nvl(funzionale, ' ') like nvl(p_funzionale, ' ')
            and nvl(risorsa_intervento, ' ') like nvl(p_risorsa_intervento, ' ')
            and nvl(impegno, 0) = nvl(p_impegno, 0)
            and nvl(anno_impegno, 0) = nvl(p_anno_impegno, 0)
            and nvl(sub_impegno, 0) = nvl(p_sub_impegno, 0)
            and nvl(anno_sub_impegno, 0) = nvl(p_anno_sub_impegno, 0)
            and nvl(codice_siope, 0) = nvl(p_codice_siope, 0)
            and nvl(capitolo, ' ') like nvl(p_capitolo, ' ')
            and nvl(articolo, ' ') like nvl(p_articolo, ' ')
            and nvl(conto, ' ') like nvl(p_conto, ' ')
            and nvl(cdc, ' ') like nvl(p_cdc, ' ')
            and nvl(ruolo, ' ') like nvl(p_ruolo, ' ');
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_regolazione;
   --
   function calcolo_presunto
   (
      p_anno               in number
     ,p_tipo               in varchar2
     ,p_gestione           in varchar2
     ,p_funzionale         in varchar2
     ,p_cdc                in varchar2
     ,p_ruolo              in varchar2
     ,p_capitolo           in varchar2
     ,p_articolo           in varchar2
     ,p_conto              in varchar2
     ,p_risorsa_intervento in varchar2
     ,p_impegno            in number
     ,p_anno_impegno       in number
     ,p_sub_impegno        in number
     ,p_anno_sub_impegno   in number
     ,p_codice_siope       in number
   ) return number is
      d_totale totali_retribuzioni_inail.premio%type;
      /* Calcolo dei valori presunti */
   begin
      begin
         d_totale := null;
         select sum(decode(p_tipo, 'I', nvl(imponibile, 0), nvl(premio, 0)))
           into d_totale
           from totali_retribuzioni_inail
          where anno = p_anno
            and nvl(gestione, ' ') like nvl(p_gestione, ' ')
            and nvl(funzionale, ' ') like nvl(p_funzionale, ' ')
            and nvl(risorsa_intervento, ' ') like nvl(p_risorsa_intervento, ' ')
            and nvl(impegno, 0) = nvl(p_impegno, 0)
            and nvl(anno_impegno, 0) = nvl(p_anno_impegno, 0)
            and nvl(sub_impegno, 0) = nvl(p_sub_impegno, 0)
            and nvl(anno_sub_impegno, 0) = nvl(p_anno_sub_impegno, 0)
            and nvl(codice_siope, 0) = nvl(p_codice_siope, 0)
            and nvl(capitolo, ' ') like nvl(p_capitolo, ' ')
            and nvl(articolo, ' ') like nvl(p_articolo, ' ')
            and nvl(conto, ' ') like nvl(p_conto, ' ')
            and nvl(cdc, ' ') like nvl(p_cdc, ' ')
            and nvl(ruolo, ' ') like nvl(p_ruolo, ' ')
            and tipo_ipn = 'P';
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_presunto;
   --
   function calcolo_retr_tot_esente
   (
      p_anno      in number
     ,p_gestione  in varchar2
     ,p_posizione in varchar2
     ,p_tipo      in varchar2
   ) return number is
      d_totale vista_retribuzioni_inail.tot_esente%type;
   begin
      begin
         d_totale := null;
         select sum(decode(gp4_alei.get_aliquota(esenzione, anno), 100, imponibile, 0))
           into d_totale
           from totali_retribuzioni_inail
          where anno = p_anno
            and gestione like p_gestione
            and posizione_inail like p_posizione
            and tipo_ipn = p_tipo;
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            d_totale := null;
      end;
      return d_totale;
   end calcolo_retr_tot_esente;
   --
   function complesso
   (
      p_ci   in number
     ,p_anno in number
     ,p_tipo in varchar2
   ) return number is
      /******************************************************************************
       NOME:        COMPLESSO
       DESCRIZIONE: <Descrizione function>
       PARAMETRI:   ci, anno, tipo
       RITORNA:     1 se esistono piu di un record per l'individuo in quell'anno e per quel tipo
                    0  in caso contrario
       Rev. Data       Autore Descrizione
       ---- ---------- ------ -------------------------------------------------------
       0    25/08/2003 __     Prima emissione.
      ******************************************************************************/
      d_valore number;
   begin
      begin
         d_valore := 0;
         select 1
           into d_valore
           from retribuzioni_inail
          where ci = p_ci
            and anno = p_anno
            and tipo_ipn = p_tipo;
         d_valore := 0;
      exception
         when no_data_found then
            d_valore := 0;
         when too_many_rows then
            d_valore := 1;
      end;
      return d_valore;
   end complesso;
   --
   function calcolo_sum_giorni
   (
      p_ci   in number
     ,p_anno in number
     ,p_mese in number
   ) return number is
      /***************************************************************************************
       NOME:        SUM_GIORNI
       DESCRIZIONE: <Descrizione function>
       PARAMETRI:   ci, anno, mese
       RITORNA:     il totale dei giorni interi lavorati dal dipendente nel mese in quell'anno
       Rev. Data       Autore Descrizione
       ---- ---------- ------ -------------------------------------------------------
       0    25/08/2003 __     Prima emissione.
      ****************************************************************************************/
      d_sum number;
   begin
      begin
         select sum(giorni)
           into d_sum
           from calcoli_retribuzioni_inail cari
               ,posizioni                  posi
          where posi.codice = cari.posizione
            and anno = p_anno
            and ci = p_ci
            and mese = p_mese
            and competenza = 'G'
            and posi.part_time != 'SI'
            and nvl(posi.collaboratore, 'NO') != 'SI';
      exception
         when no_data_found then
            d_sum := null;
         when too_many_rows then
            d_sum := null;
      end;
      return d_sum;
   end calcolo_sum_giorni;
   --
   function calcolo_nr_mesi
   (
      p_ci   in number
     ,p_anno in number
   ) return number is
      /***************************************************************************************
       NOME:        NR_MESI
       DESCRIZIONE: <Descrizione function>
       PARAMETRI:   ci, anno
       RITORNA:     il nr di mesi e frazioni di mesi dell'anno di riferimento per il quale
                    si e prolungato il rapporto
       Rev. Data       Autore Descrizione
       ---- ---------- ------ -------------------------------------------------------
       0    25/08/2003 __     Prima emissione.
      ****************************************************************************************/
      d_nr_mesi number;
   begin
      begin
         select count(distinct mese)
           into d_nr_mesi
           from calcoli_retribuzioni_inail cari
               ,posizioni                  posi
          where posi.codice = cari.posizione
            and anno = p_anno
            and cari.ci = p_ci
            and posi.collaboratore = 'SI'
            and arretrato = 'C';
      exception
         when no_data_found then
            d_nr_mesi := null;
         when too_many_rows then
            d_nr_mesi := null;
      end;
      return d_nr_mesi;
   end calcolo_nr_mesi;
   --
   function calcolo_nr_giorni
   (
      p_ci   in number
     ,p_anno in number
   ) return number is
      /*****************************************************************************
       NOME:        NR_GIORNI
       DESCRIZIONE: <Descrizione function>
       PARAMETRI:   ci, anno
       RITORNA:     il nr di giorni dell'anno di riferimento per il quale
                    si e prolungato il rapporto
       Rev. Data       Autore Descrizione
       ---- ---------- ------ -------------------------------------------------------
       0    25/08/2003 __     Prima emissione.
      ******************************************************************************/
      d_nr_giorni number;
   begin
      begin
         select sum(giorni)
           into d_nr_giorni
           from calcoli_retribuzioni_inail cari
               ,posizioni                  posi
          where posi.codice = cari.posizione
            and anno = p_anno
            and cari.ci = p_ci
            and posi.collaboratore = 'SI'
            and competenza = 'G';
      exception
         when no_data_found then
            d_nr_giorni := null;
         when too_many_rows then
            d_nr_giorni := null;
      end;
      return d_nr_giorni;
   end calcolo_nr_giorni;
   --
   function calcolo_minimale
   (
      p_voce in varchar2
     ,p_data in date
   ) return number is
      /***************************************************************************************
       NOME:        MINIMALE
       DESCRIZIONE: <Descrizione function>
       PARAMETRI:   voce, dal, al
       RITORNA:     il valore del minimale
       Rev. Data       Autore Descrizione
       ---- ---------- ------ -------------------------------------------------------
       0    27/08/2003 __     Prima emissione.
      ****************************************************************************************/
      d_minimale number;
   begin
      begin
         select min_ipn
           into d_minimale
           from imponibili_voce
          where voce = p_voce
            and p_data between nvl(dal, to_date(2222222, 'j')) and
                nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_minimale := null;
         when too_many_rows then
            d_minimale := null;
      end;
      return d_minimale;
   end calcolo_minimale;
   --
   function calcolo_massimale
   (
      p_voce in varchar2
     ,p_data in date
   ) return number is
      /***************************************************************************************
       NOME:        MASSIMALE
       DESCRIZIONE: <Descrizione function>
       PARAMETRI:   voce, dal
       RITORNA:     il valore del massimale
       Rev. Data       Autore Descrizione
       ---- ---------- ------ -------------------------------------------------------
       0    27/08/2003 __     Prima emissione.
      ****************************************************************************************/
      d_massimale number;
   begin
      begin
         select max_ipn
           into d_massimale
           from imponibili_voce
          where voce = p_voce
            and p_data between nvl(dal, to_date(2222222, 'j')) and
                nvl(al, to_date(3333333, 'j'));
      exception
         when no_data_found then
            d_massimale := null;
         when too_many_rows then
            d_massimale := null;
      end;
      return d_massimale;
   end calcolo_massimale;
   --
   function calcolo_esenzioni
   (
      p_anno           in number
     ,p_gestione       in varchar2
     ,p_posizione      in varchar2
     ,p_tipo_ipn       in varchar2
     ,p_tipo_esenzione in varchar2
   ) return number is
      d_totale totali_retribuzioni_inail.premio%type;
   begin
      d_totale := null;
      begin
         if p_tipo_esenzione = 'T' then
            select sum(imponibile * gp4_alei.get_aliquota(esenzione, anno) / 100)
              into d_totale
              from totali_retribuzioni_inail
             where anno = p_anno
               and gestione = p_gestione
               and posizione_inail = p_posizione
               and tipo_ipn = p_tipo_ipn
               and gp4_alei.get_aliquota(esenzione, anno) = 100;
         elsif p_tipo_esenzione = 'P' then
            select sum(imponibile * gp4_alei.get_aliquota(esenzione, anno) / 100)
              into d_totale
              from totali_retribuzioni_inail
             where anno = p_anno
               and gestione = p_gestione
               and posizione_inail = p_posizione
               and tipo_ipn = p_tipo_ipn
               and gp4_alei.get_aliquota(esenzione, anno) < 100;
         end if;
      exception
         when no_data_found then
            d_totale := null;
         when too_many_rows then
            begin
               d_totale := null;
            end;
      end;
      return d_totale;
   end calcolo_esenzioni;
   --
end peccrein;
/
