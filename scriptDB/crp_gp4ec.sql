create or replace package gp4ec is
   /******************************************************************************
    NOME:        GP4EC
    DESCRIZIONE: <Descrizione Package>
   
    ANNOTAZIONI: -
    REVISIONI:
    Rev. Data       Autore Descrizione
    ---- ---------- ------ ------------------------------------------------------
    0    02/12/2002 __     Prima emissione.
    1.1  31/12/2006 MM     Aggiunta procedure CALCOLO_TARIFFA
    1.2  31/05/2005 MS     Aggiunte function GET_WEEK_NR e GET_NEXT_DAY
    1.3  25/01/2007 MS     Aggiunta function GET_VAL_DEC_STAMPA
    1.4  24/04/2007 MM     Att. 20376.1 e 19668
    1.5  14/05/2007 MM     Att. 20555
    1.6  14/08/2007 MM     Att. 20555 ( sistemazione per difetti )
   ******************************************************************************/
   function versione return varchar2;
   function get_anno return number;
   function get_mese return number;
   function get_mensilita return varchar2;
   function get_tipo_totalizzazione
   (
      p_voce       in varchar2
     ,p_sub        in varchar2
     ,p_imponibile in varchar2
   ) return varchar2;

   function calcolo_tariffa
   (
      p_ci          in number
     ,p_al          in date
     ,p_anno        in number
     ,p_mese        in number
     ,p_mensilita   in varchar2
     ,p_voce        in varchar2
     ,p_sub         in varchar2
     ,p_ore_mensili in number
     ,p_div_orario  in number
     ,p_ore_gg      in number
     ,p_gg_lavoro   in number
     ,p_ore_lavoro  in number
   ) return number;

   function get_week_nr
   (
      p_data in date
     ,lang   in varchar2
   ) return number;

   function chk_novo
   (
      p_ci   in number
     ,p_voce in varchar2
     ,p_data in date
   ) return varchar2;

   function get_next_day
   (
      p_data in date
     ,dn     in varchar2
     ,ln     in varchar2
   ) return date;

   function get_val_dec_stampa(d_val in number) return varchar2;

   function individuo_in_lunga_assenza
   (
      p_ci                 in number
     ,p_dal                in date
     ,p_al                 in date
     ,p_gg_consecutivi     in number
     ,p_gg_non_consecutivi in number
   ) return boolean;

   function get_giorni_in_lunga_assenza
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return number;

   function get_giorni_in_lunga_assenza
   (
      p_ci   in number
     ,p_dal  in date
     ,p_al   in date
     ,p_mese in number
   ) return number;

end gp4ec;
/
create or replace package body gp4ec as
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
      return 'V1.6 del 14/08/2007';
   end versione;
   --
   function get_anno return number is
      /******************************************************************************
       NOME:        GET_ANNO
       DESCRIZIONE: Restituisce l'anno di riferimento dell'economico contabile
      
       ANNOTAZIONI : se RIRE non e definito (non si deve verificare) restituisce 0
      
       REVISIONI:
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       0    02/12/2002     __     Prima emissione.
      ******************************************************************************/
      d_anno number;
   begin
      d_anno := 0;
      select anno into d_anno from riferimento_retribuzione where rire_id = 'RIRE';
      return d_anno;
   exception
      when no_data_found then
         d_anno := 0;
         return d_anno;
   end get_anno;
   --
   function get_mese return number
   /******************************************************************************
       NOME:        GET_MESE
       DESCRIZIONE: Restituisce il di riferimento dell'economico contabile
      
       ANNOTAZIONI : se RIRE non e definito (non si deve verificare) restituisce 0
      
       REVISIONI:
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       0    02/12/2002     __     Prima emissione.
      ******************************************************************************/
    is
      d_mese number;
   begin
      d_mese := 0;
      select mese into d_mese from riferimento_retribuzione where rire_id = 'RIRE';
      return d_mese;
   exception
      when no_data_found then
         d_mese := 0;
         return d_mese;
   end get_mese;
   --
   function get_mensilita return varchar2
   /******************************************************************************
       NOME:        GET_MENSILITA
       DESCRIZIONE: Restituisce la mensilita di riferimento dell'economico contabile
      
       ANNOTAZIONI : se RIRE non e definito (non si deve verificare) restituisce null
      
       REVISIONI:
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       0    02/12/2002     __     Prima emissione.
      ******************************************************************************/
    is
      d_mensilita riferimento_retribuzione.mensilita%type;
   begin
      d_mensilita := to_char(null);
      select mensilita
        into d_mensilita
        from riferimento_retribuzione
       where rire_id = 'RIRE';
      return d_mensilita;
   exception
      when no_data_found then
         d_mensilita := to_char(null);
         return d_mensilita;
   end get_mensilita;
   --
   function get_tipo_totalizzazione
   (
      p_voce       in varchar2
     ,p_sub        in varchar2
     ,p_imponibile in varchar2
   ) return varchar2 is
      /******************************************************************************
       NOME:        GET_TIPO_TOTALIZZAZIONE
       DESCRIZIONE: Restituisce il tipo di totalizzazione di una voce rispetto ad
                    un imponibile dato.
      
       ANNOTAZIONI : La funzione è prevista per un uso interno. Si presuppone che gli
                     imponibili su cui vengono calcolati i contributi a carico ente abbiano
                     un codice con formato '%.E'
      
       REVISIONI:
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       1.0  09/03/2007 MS     Prima emissione ( Rif. MM )
      ******************************************************************************/
      d_tipo   varchar2(1) := '';
      d_c_ente varchar2(1) := '';
      d_c_dip  varchar2(1) := '';
   begin
      begin
         select max('1')
           into d_c_dip
           from totalizzazioni_voce
          where voce = p_voce
            and (p_sub = sub or sub is null)
            and voce_acc like upper(p_imponibile);
      exception
         when no_data_found then
            null;
      end;
   
      begin
         select max('1')
           into d_c_ente
           from totalizzazioni_voce
          where voce = p_voce
            and (p_sub = sub or sub is null)
            and voce_acc like upper(p_imponibile) || '.E';
      exception
         when no_data_found then
            null;
      end;
   
      if d_c_ente = '1' and d_c_dip = '1' then
         d_tipo := 'T';
      elsif d_c_ente = '1' and d_c_dip is null then
         d_tipo := 'E';
      elsif d_c_dip = '1' and d_c_ente is null then
         d_tipo := 'D';
      end if;
   
      return d_tipo;
   exception
      when no_data_found then
         return d_tipo;
   end get_tipo_totalizzazione;
   --
   function get_week_nr
   (
      p_data in date
     ,lang   in varchar2
   ) return number is
      /******************************************************************************
       NOME:        GET_WEEK_NR
       DESCRIZIONE: Esegue il conteggio della settimana prgressiva all'interno
                    dell'anno tenendo conto che la settimana inizia con la Domenica
                    e termina con il Sabato successivo come indicato dall'I.N.P.S.
      
       PARAMETRI:  p_data  data     termine del periodo da conteggiare
                   lang    varchar  linguaggio utilizzato dalla function
      
       RITORNA:    week   number
      
       ECCEZIONI:
      
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       0    23/03/2005 SN     Prima emissione.
      ******************************************************************************/
      cursor c_lang is
         select value from nls_session_parameters where parameter = 'NLS_DATE_LANGUAGE';
      cursor c_week(p_data in date) is
         select trunc((to_number(to_char(p_data, 'ddd')) -
                      (7 - to_number(to_char(trunc(p_data, 'yyyy'), 'd')) + 1) - 1) / 7 + 2) numero_settimana
           from dual;
      week          number;
      old_date_lang varchar2(128);
   begin
      open c_lang;
      fetch c_lang
         into old_date_lang;
      close c_lang;
      dbms_session.set_nls('NLS_DATE_LANGUAGE', lang);
      open c_week(p_data);
      fetch c_week
         into week;
      close c_week;
      dbms_session.set_nls('NLS_DATE_LANGUAGE', old_date_lang);
      return(week);
   end get_week_nr;
   --
   function chk_novo
   (
      p_ci   in number
     ,p_voce in varchar2
     ,p_data in date
   ) return varchar2 is
      /******************************************************************************
       NOME:        CHK_NOVO
       DESCRIZIONE: Esegue il controllo di compatibilità su normativa_voce
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       0    13/04/2007 MM     Prima emissione.
      ******************************************************************************/
      d_compatibile varchar2(2);
   begin
      begin
         select 'NO'
           into d_compatibile
           from normativa_voce
          where voce = p_voce
            and p_data between nvl(dal, to_date(2222222, 'j')) and
                nvl(al, to_date(3333333, 'j'));
         raise too_many_rows;
      exception
         when no_data_found then
            d_compatibile := 'SI';
         when too_many_rows then
            begin
               select 'SI'
                 into d_compatibile
                 from normativa_voce novo
                where novo.voce = p_voce
                  and exists
                (select 'x'
                         from periodi_giuridici     pegi
                             ,qualifiche_giuridiche qugi
                             ,figure_giuridiche     figi
                             ,posizioni             posi
                        where pegi.ci = p_ci
                          and pegi.rilevanza = 'S'
                          and p_data between pegi.dal and
                              nvl(pegi.al, to_date(3333333, 'j'))
                          and qugi.numero = pegi.qualifica
                          and p_data between qugi.dal and
                              nvl(qugi.al, to_date(3333333, 'j'))
                          and figi.numero = pegi.figura
                          and p_data between figi.dal and
                              nvl(figi.al, to_date(3333333, 'j'))
                          and posi.codice = pegi.posizione
                          and qugi.contratto like novo.contratto
                          and qugi.codice like novo.qualifica
                          and qugi.ruolo like novo.ruolo
                          and qugi.livello like novo.livello
                          and nvl(pegi.tipo_rapporto, 'NULL') like novo.tipo_rapporto
                          and figi.codice like novo.figura
                          and posi.codice like novo.posizione
                          and posi.ruolo like novo.di_ruolo
                          and posi.part_time like novo.part_time
                          and posi.tempo_determinato like novo.tempo_determinato
                          and p_data between nvl(novo.dal, to_date(2222222, 'j')) and
                              nvl(novo.al, to_date(3333333, 'j')));
               raise too_many_rows;
            exception
               when no_data_found then
                  begin
                     select 'SI'
                       into d_compatibile
                       from normativa_voce novo
                      where novo.voce = p_voce
                        and novo.qualifica = '%'
                        and novo.livello = '%'
                        and novo.contratto = '%'
                        and novo.ruolo = '%'
                        and exists
                      (select 'x'
                               from periodi_giuridici pegi
                                   ,figure_giuridiche figi
                                   ,posizioni         posi
                              where pegi.ci = p_ci
                                and pegi.rilevanza = 'Q'
                                and p_data between pegi.dal and
                                    nvl(pegi.al, to_date(3333333, 'j'))
                                and figi.numero = pegi.figura
                                and p_data between figi.dal and
                                    nvl(figi.al, to_date(3333333, 'j'))
                                and posi.codice = pegi.posizione
                                and nvl(pegi.tipo_rapporto, 'NULL') like
                                    novo.tipo_rapporto
                                and figi.codice like novo.figura
                                and posi.codice like novo.posizione
                                and posi.ruolo like novo.di_ruolo
                                and posi.part_time like novo.part_time
                                and posi.tempo_determinato like novo.tempo_determinato
                                and p_data between nvl(novo.dal, to_date(2222222, 'j')) and
                                    nvl(novo.al, to_date(3333333, 'j')));
                     raise too_many_rows;
                  exception
                     when no_data_found then
                        d_compatibile := 'NO';
                     when too_many_rows then
                        d_compatibile := 'SI';
                  end;
               when too_many_rows then
                  d_compatibile := 'SI';
            end;
      end;
      return(d_compatibile);
   end chk_novo;
   --
   function get_next_day
   (
      p_data in date
     ,dn     in varchar2
     ,ln     in varchar2
   ) return date is
      /******************************************************************************
       NOME:        GET_NEXT_DAY
       DESCRIZIONE: Estrai il primo giorno del tipo indicato successivo alla data
      
       PARAMETRI:  p_data  data     data da cui iniziare la ricerca
                   dn      varchar  giorno da cercare
                   ln      varchar  linguaggio utilizzato dalla function
      
       RITORNA:    week   number
      
       ECCEZIONI:
      
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       0    23/03/2005 SN     Prima emissione.
      ******************************************************************************/
      cursor cr1 is
         select value from nls_session_parameters where parameter = 'NLS_DATE_LANGUAGE';
      cursor cr2(dn1 in varchar2) is
         select next_day(p_data, upper(dn1)) from dual;
      day           date;
      old_date_lang varchar2(128);
   begin
      open cr1;
      fetch cr1
         into old_date_lang;
      close cr1;
      dbms_session.set_nls('NLS_DATE_LANGUAGE', ln);
      open cr2(dn);
      fetch cr2
         into day;
      close cr2;
      dbms_session.set_nls('NLS_DATE_LANGUAGE', old_date_lang);
      return(day);
   end get_next_day;
   --
   function individuo_in_lunga_assenza
   (
      p_ci                 in number
     ,p_dal                in date
     ,p_al                 in date
     ,p_gg_consecutivi     in number
     ,p_gg_non_consecutivi in number
   ) return boolean is
      d_lungo_assente   boolean := false;
      d_min_dal_assenza date;
      d_max_al_assenza  date;
      d_tot_gg_assenza  number;
      d_max_gg_assenza  number;
      d_dummy           varchar2(1);
   begin
      -- vediamo se il CI è stato assente nel periodo
      if p_dal is not null and p_al is not null then
         begin
            select 'x'
              into d_dummy
              from periodi_giuridici
             where ci = p_ci
               and rilevanza = 'A'
               and assenza in
                   (select codice from astensioni aste where aste.lunga_assenza = 'SI')
               and dal <= p_al
               and nvl(al, p_al) >= p_dal;
            raise too_many_rows;
         exception
            when no_data_found then
               -- se non stato è assenze, non è nemmeno lungo assente
               /*               dbms_output.put_line('non risulta assente');
               */
               null;
            when too_many_rows then
               -- determiniamo gli estremi dei periodi e il totale dei giorni di assenza nel periodo
               select min(greatest(dal, p_dal))
                     ,max(least(nvl(al, p_al), p_al))
                     ,sum(least(nvl(al, p_al), p_al) - greatest(dal, p_dal) + 1)
                     ,max(least(nvl(al, p_al), p_al) - greatest(dal, p_dal) + 1)
                 into d_min_dal_assenza
                     ,d_max_al_assenza
                     ,d_tot_gg_assenza
                     ,d_max_gg_assenza
                 from periodi_giuridici
                where ci = p_ci
                  and rilevanza = 'A'
                  and assenza in
                      (select codice from astensioni aste where aste.lunga_assenza = 'SI')
                  and dal <= p_al
                  and nvl(al, p_al) >= p_dal;
               /*               dbms_output.put_line(p_ci || ' ' || d_tot_gg_assenza || ' ' ||
                                                   d_max_gg_assenza);
               */
               if d_max_gg_assenza >= nvl(p_gg_consecutivi, 999999) or
                  d_tot_gg_assenza >= nvl(p_gg_non_consecutivi, 999999) then
                  d_lungo_assente := true;
               end if;
            
         end;
      end if;
      return d_lungo_assente;
   end;
   --
   function get_giorni_in_lunga_assenza
   (
      p_ci  in number
     ,p_dal in date
     ,p_al  in date
   ) return number is
      d_min_dal_assenza date;
      d_max_al_assenza  date;
      d_tot_gg_assenza  number := 0;
      d_max_gg_assenza  number;
      d_dummy           varchar2(1);
      d_ini_mes         date;
      d_fin_mes         date;
      d_anno            number(4);
      d_gg_mese         number(2);
      d_gg_ass_mese     number(2);
      d_gg_cont         contratti_storici.gg_lavoro%type;
   begin
      d_anno := to_char(p_dal, 'yyyy');
      -- determina i giorni contrattuali
      d_gg_cont := gp4_cost.get_gg_lavoro(gp4_pegi.get_qualifica(p_ci, 'S', p_dal), p_dal);
      -- calcolo dei giorni di assenza con dettaglio mensile, per la rettifica ai giorni contrattuali
      for mese in to_number(to_char(p_dal, 'mm')) .. to_number(to_char(p_al, 'mm'))
      loop
         d_ini_mes := to_date(lpad(mese, 2, '0') || d_anno, 'mmyyyy');
         d_fin_mes := last_day(to_date(lpad(mese, 2, '0') || d_anno, 'mmyyyy'));
         d_gg_mese := d_fin_mes - d_ini_mes + 1;
      
         select nvl(sum(least(nvl(al, d_fin_mes), d_fin_mes) - greatest(dal, d_ini_mes) + 1)
                   ,0)
           into d_gg_ass_mese
           from periodi_giuridici
          where ci = p_ci
            and rilevanza = 'A'
            and assenza in
                (select codice from astensioni aste where aste.lunga_assenza = 'SI')
            and dal <= d_fin_mes
            and nvl(al, d_fin_mes) >= d_ini_mes;
         -- assestamento ai giorni contrattuali   
         if d_gg_ass_mese = d_gg_mese then
            d_gg_ass_mese := d_gg_cont;
         end if;
         --         dbms_output.put_line('mese:' || mese || ' giorni:' || d_gg_ass_mese);
      
         d_tot_gg_assenza := d_tot_gg_assenza + d_gg_ass_mese;
      
      end loop;
      -- determiniamo gli estremi dei periodi e il totale dei giorni di assenza nel periodo
      return d_tot_gg_assenza;
   end;
   --
   function get_giorni_in_lunga_assenza
   (
      p_ci   in number
     ,p_dal  in date
     ,p_al   in date
     ,p_mese in number
   ) return number is
      d_min_dal_assenza date;
      d_max_al_assenza  date;
      d_tot_gg_assenza  number := 0;
      d_max_gg_assenza  number;
      d_dummy           varchar2(1);
      d_ini_mes         date;
      d_fin_mes         date;
      d_anno            number(4);
      d_gg_mese         number(2);
      d_gg_ass_mese     number(2);
      d_gg_cont         contratti_storici.gg_lavoro%type;
   begin
      d_anno    := to_char(p_dal, 'yyyy');
      d_ini_mes := to_date(lpad(p_mese, 2, '0') || d_anno, 'mmyyyy');
      d_fin_mes := last_day(to_date(lpad(p_mese, 2, '0') || d_anno, 'mmyyyy'));
      d_gg_mese := d_fin_mes - d_ini_mes + 1;
      -- determina i giorni contrattuali
      d_gg_cont := gp4_cost.get_gg_lavoro(gp4_pegi.get_qualifica(p_ci, 'S', d_fin_mes)
                                         ,d_fin_mes);
      -- calcolo dei giorni di assenza con dettaglio mensile, per la rettifica ai giorni contrattuali
      select nvl(sum(least(nvl(al, d_fin_mes), d_fin_mes) - greatest(dal, d_ini_mes) + 1)
                ,0)
        into d_gg_ass_mese
        from periodi_giuridici
       where ci = p_ci
         and rilevanza = 'A'
         and assenza in
             (select codice from astensioni aste where aste.lunga_assenza = 'SI')
         and dal <= d_fin_mes
         and nvl(al, d_fin_mes) >= d_ini_mes;
      -- assestamento ai giorni contrattuali   
      if d_gg_ass_mese = d_gg_mese then
         d_gg_ass_mese := d_gg_cont;
      end if;
      return d_gg_ass_mese;
   end;
   --
   function get_val_dec_stampa(d_val in number) return varchar2 is
      /******************************************************************************
       NOME:        GET_VAL_DEC_STAMPA
       DESCRIZIONE: Dato un numerico restituisce il valore con sempre i 2 decimali
                    Normalmente utilizzato per la stampa di valori numerici
      
       PARAMETRI:   D_val      number      importo che si vuole convertire
      
       RITORNA:     D_val_dec  varchar2    stringa che corrisponde all'importo
                                           con 2 decimali
      
       ECCEZIONI:
      
       ANNOTAZIONI:
       REVISIONI:
       Rev. Data       Autore Descrizione
       ---- ---------- ------ ------------------------------------------------------
       1.0  25/01/2007 MS     Prima emissione.
      ******************************************************************************/
      d_val_dec varchar2(20) := ' ';
   begin
      begin
         select decode(sign(d_val), -1, '-', '') || trunc(abs(d_val)) || '.' ||
                lpad((abs(d_val) - trunc(abs(d_val))) * 100, 2, '0')
           into d_val_dec
           from dual;
      exception
         when no_data_found then
            d_val_dec := ' ';
      end;
      return d_val_dec;
   end get_val_dec_stampa;
   --
   function calcolo_tariffa
   (
      p_ci          in number
     ,p_al          in date
     ,p_anno        in number
     ,p_mese        in number
     ,p_mensilita   in varchar2
     ,p_voce        in varchar2
     ,p_sub         in varchar2
     ,p_ore_mensili in number
     ,p_div_orario  in number
     ,p_ore_gg      in number
     ,p_gg_lavoro   in number
     ,p_ore_lavoro  in number
   ) return number is
      /*
         Questa funzione richiama la procedure peccmore_tariffa.calcolo e consente il calcolo della tariffa
         in SQL*Plus.
      
         Da usare solo per select estemporanee. In ambito PL*SQL,
         va utilizzata direttamente la procedure peccmore_tariffa.calcolo
      */
   
      d_tariffa        movimenti_contabili.tar%type;
      d_flag_movimenti number; -- Indicatore Tariffa su movimenti del mese
      d_rif_tar        date;
      d_errore         a_errori.errore%type;
      d_segnalazione   varchar2(200);
   begin
      -- Trattamento voce a Tariffa
      d_flag_movimenti := 0;
   
      select nvl(p_al, last_day(to_date('01/' || p_mese || '/' || p_anno, 'DD/MM/YYYY')))
        into d_rif_tar
        from dual;
   
      peccmore_tariffa.calcolo(p_ci
                              ,p_al
                              ,p_anno
                              ,p_mese
                              ,p_mensilita
                              ,nvl(p_al
                                  ,last_day(to_date('01/' || p_mese || '/' || p_anno
                                                   ,'DD/MM/YYYY')))
                              ,p_voce
                              ,p_sub
                              ,nvl(p_al
                                  ,last_day(to_date('01/' || p_mese || '/' || p_anno
                                                   ,'DD/MM/YYYY')))
                              ,d_rif_tar
                              ,d_tariffa
                              ,d_flag_movimenti
                              ,p_ore_mensili
                              ,p_div_orario
                              ,p_ore_gg
                              ,p_gg_lavoro
                              ,p_ore_lavoro
                              ,d_errore
                              ,d_segnalazione);
   
      if d_flag_movimenti = 1 then
         d_tariffa := '';
         /* Tariffa su movimenti del mese non corretta */
      end if;
      return d_tariffa;
   exception
      when others then
         d_tariffa := '';
         return d_tariffa;
   end;

end gp4ec;
/* End Package Body: GP4EC */
/
