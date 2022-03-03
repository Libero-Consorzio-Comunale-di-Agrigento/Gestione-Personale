CREATE OR REPLACE PACKAGE GP4MT IS
/******************************************************************************
 NOME:        GP4MT
 DESCRIZIONE: <Descrizione Package>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    08/03/2004 CB     Prima emissione.
 1    19/04/2007 CB     Insert in DEVE coerentemente alla classe di VOEC
 1.1  30/05/2007 CB     Controllo sul deve.input='PMT'
 1.2  04/06/2007 CB     Inserimento dei campi di Delibera e Imputazione nel calcolo_forfait e calcolo_diaria
 1.3  08/06/2007 CB     Gestione Delibera e Imputazione nel Passaggio_Economico
 1.4  05/07/2007 CB     Gestione  del P00503
 1.5  06/09/2007 CB     trunc in data_distinta per aggiorna_stato e passaggio_economico
 1.6  01/10/2007 CB     Gestione ci nell'estrazione della max_data_inizio nel Passaggio_economico
******************************************************************************/
       FUNCTION  VERSIONE                RETURN VARCHAR2;
       PROCEDURE CALCOLO_FORFAIT        (p_data_inizio     in  date,
                                         p_data_fine       in  date,
                                         p_riri_id         in number,
                                         p_ci              in number,
                                         p_errore          out varchar2,
                                         p_segnalazione    out varchar2) ;
       PROCEDURE CALCOLO_DIARIA         (p_data_inizio     in  date,
                                         p_data_fine       in  date,
                                         p_riri_id         in number,
                                         p_ci              in number,
                                         p_tipo_missione   in varchar2,
                                         p_comune_fine     in number,
                                         p_button_flag     in number,
                                         p_form            in varchar2,
                                         p_errore          out varchar2,
                                         p_segnalazione    out varchar2) ;
       PROCEDURE CALCOLO_DIARIA_MANUALE (p_data_inizio     in  date,
                                         p_data_fine       in  date,
                                         p_riri_id         in number,
                                         p_quantita        in number,
                                         p_tariffa         in number,
                                         p_form            in varchar2,
                                         p_gestione        in varchar2,
                                         p_contratto       in varchar2,
                                         p_data_documento  in date,
                                         p_importo         out number,
                                         p_errore          out varchar2,
                                         p_segnalazione    out varchar2) ;
       PROCEDURE AGGIORNA_STATO         (p_stato_richiesta in  varchar2,
                                         p_riri_id         in  number,
                                         p_data_distinta   in  date,
                                         p_numero_distinta in  number,
                                         p_errore          out varchar2,
                                         p_segnalazione    out varchar2) ;
       PROCEDURE PASSAGGIO_ECONOMICO    (p_flag_arr        in  number,
                                         p_data_distinta   in  date,
                                         p_numero_distinta in  number,
                                         p_stato_richiesta in  varchar2,
                                         p_riri_id         in  number,
                                         p_sysdate         in  date,
                                         p_utente          in  varchar2,
                                         p_errore          out varchar2,
                                         p_segnalazione    out varchar2) ;

END GP4MT;
/
CREATE OR REPLACE PACKAGE BODY GP4MT AS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package. 
******************************************************************************/
BEGIN
   RETURN 'V1.6 del 01/10/2007 ';
END VERSIONE;
--

PROCEDURE CALCOLO_FORFAIT        (p_data_inizio  in  date,
                                  p_data_fine    in  date,
                                  p_riri_id      in number,
                                  p_ci           in number,
                                  p_errore       out varchar2,
                                  p_segnalazione out varchar2) IS
/******************************************************************************
 NOME:        CALCOLO_FORFAIT
 DESCRIZIONE: Cancella i record da RIGHE_RICHIESTA_RIMBORSO che hanno un
              tipo_spesa per il quale e attivo il flag se_sostituibile_da_forfait
              nella tabella TIPI_SPESA e genera un solo record che identifica il
              rimborso forfettario
 PARAMETRI:   p_data_inizio = data inizio trasferta
              p_data_fine   = data fine trasferta
              p_riri_id     = identificatvo di Righe_richieste_rimborso
              p_ci          = codice individuale del dipendente
 RITORNA:     --
 NOTE:        --
******************************************************************************/
p_flag           number:=0;
p_rirr_id        number;
p_progressivo    number;
app_progressivo  number;
app_tipo_spesa   varchar2(4);
p_tariffa        number;
p_quantita       number;
p_importo_magg   number;
app_gestione     varchar2(8);
app_contratto    varchar2(4);
app_qualifica    varchar2(8);
app_livello      varchar2(4);
app_diff_hh      number;
app_diff_mm      number;
app_min_arr      number;
app_se_tariffa   number;
app_durata       number;
app_se_qta       number;
app_perc_magg    number;
app_anno_del     number;
app_numero_del   number;
app_sede_del     varchar2(4);
app_risorsa_intervento varchar2(7);
app_capitolo     varchar2(14);
app_articolo     varchar2(14);
app_conto        varchar2(2);
app_impegno      number;
app_anno_impegno number;
app_sub_impegno    number;
app_anno_sub_impegno   number;
app_codice_siope       number;
esci             exception;
BEGIN

/* Calcolo dei campi di Delibera ed Imputazione */
begin
 select sede_del,
        anno_del,
        numero_del,
        risorsa_intervento,
        capitolo,
        articolo,
        conto,
        impegno,
        anno_impegno,
        sub_impegno,
        anno_sub_impegno,
        codice_siope
 into   app_sede_del,
        app_anno_del,
        app_numero_del,
        app_risorsa_intervento,
        app_capitolo,
        app_articolo,
        app_conto,
        app_impegno,
        app_anno_impegno,
        app_sub_impegno,
        app_anno_sub_impegno,
        app_codice_siope
 from   richieste_rimborso
 where  riri_id=p_riri_id;
 exception
 when no_data_found then null;
end;

for cur_1 in
 (select distinct tipo_spesa
  from  righe_richiesta_rimborso
  where riri_id = p_riri_id
 )
loop
  begin
     FOR CUR IN
     (
      select tisp.tipo_spesa
      from   tipi_spesa tisp
      where  to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'))
      and    tisp.se_sostituibile_da_forfait =1
      and    tisp.tipo_spesa=cur_1.tipo_spesa
      order by tipo_spesa
     )
     LOOP
       begin
        delete RIGHE_RICHIESTA_RIMBORSO
        where tipo_spesa=cur.tipo_spesa
        and   riri_id = p_riri_id;
        p_flag :=p_flag+1;
       end;
     END LOOP; -- cur
  end;
end loop; -- cur_1
begin
      begin
       select RIRR_SQ.NEXTVAL
       into p_rirr_id
       from dual
        ;
      end;
      BEGIN
       SELECT nvl(MAX(PROGRESSIVO),10)
         INTO app_progressivo
         FROM RIGHE_RICHIESTA_RIMBORSO
        WHERE RIRI_ID = p_riri_id
          AND PROGRESSIVO <4000;
        if mod(app_progressivo,10) != 0 then
         p_progressivo := (ceil(app_progressivo/10)*10);
        else
         p_progressivo := ((ceil(app_progressivo/10)*10)+10);
        end if;
        if p_progressivo >= 4000 then
          p_errore := 'P00217';
          p_segnalazione := si4.get_error(p_errore);
          raise esci;
        end if;
      END;
/* Seleziona i tipi spesa con :
   - causale_spesa = 'FO'
   - dal / al che includano la data di inizio trasferta
   - nvl(minimale_orario,0) sia il max tra quelli <= alla durata della trasferta in ore */
      app_diff_hh:=trunc((p_data_fine-p_data_inizio)*24);
      app_diff_mm:=round(((p_data_fine-p_data_inizio)*24 - trunc((p_data_fine-p_data_inizio)*24))*60);
      begin
       select nvl(minuti_arrotondamento,0)
       into app_min_arr
       from parametri_missioni;
       exception
        when no_data_found then
             p_errore := 'P00503';
             p_segnalazione := si4.get_error(p_errore)||' non presente';
             raise esci;
      end;
      if app_diff_mm < app_min_arr then
         app_durata := app_diff_hh;
      else
         app_durata := app_diff_hh+1;
      end if;
      begin
        select tisp.tipo_spesa
          into app_tipo_spesa
          from tipi_spesa tisp
         where tisp.causale_spesa='FO'
           and to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'))
           and nvl(minimale_orario,0) = (select max(nvl(minimale_orario,0))
                                           from tipi_spesa tisp2
                                          where tisp2.causale_spesa='FO'
                                            and to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy')
                                                between tisp2.dal and nvl(tisp2.al,to_date('3333333','j'))
                                            and nvl(tisp2.minimale_orario,0)<=app_durata
                                           );
      exception
         when no_data_found then
          p_errore := 'P00210';
             p_segnalazione := si4.get_error(p_errore);
             raise esci;
            when too_many_rows then
          p_errore := 'P00211';
             p_segnalazione := si4.get_error(p_errore);
             raise esci;
      end;
/* Calcolo tariffa */
  BEGIN
    begin
      select nvl(tisp.se_tariffa,0)
        into app_se_tariffa
        from tipi_spesa tisp
      where tisp.tipo_spesa=app_tipo_spesa
        and tisp.causale_spesa = 'FO'
        and to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'));
    exception
       when no_data_found then
         app_se_tariffa := 0;
    end;
    if app_se_tariffa = 1 then
      begin
        select gestione,contratto,codice,livello
          into app_gestione,app_contratto,app_qualifica,app_livello
          from qualifiche_giuridiche qugi,
               periodi_giuridici     pegi
         where pegi.qualifica = qugi.numero
           and pegi.rilevanza = 'S'
           and pegi.ci        = p_ci
           and to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
           and to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between pegi.dal and nvl(pegi.al,to_date('3333333','j'));
      exception
       when no_data_found then
       NULL;
      end ;
      begin
         select tariffa
           into p_tariffa
           from tariffe tari
          where tipo_spesa  = app_tipo_spesa
            and to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tari.dal and nvl(tari.al,to_date('3333333','j'))
            and tari.gestione  = app_gestione
            and tari.contratto = app_contratto
            and tari.qualifica = app_qualifica
            and tari.livello   = app_livello;
      exception
           when no_data_found then
            begin
                 select tariffa
                 into   p_tariffa
                 from   tariffe tari
                 where  tipo_spesa  = app_tipo_spesa
                 and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tari.dal and nvl(tari.al,to_date('3333333','j'))
                 and    tari.gestione  = '%'
                 and    tari.contratto = '%'
                 and    tari.qualifica = '%'
                 and    tari.livello   = '%';
            exception
                when no_data_found then
                 p_errore := 'P00212';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
                    when too_many_rows then
                 p_errore := 'P00213';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end ;
           when too_many_rows then
             begin
              p_errore := 'P00213';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
             end;
      end ;
    end if;
    if app_se_tariffa = 0 then
      begin
        p_errore := 'P00216';
          p_segnalazione := si4.get_error(p_errore);
          raise esci;
      end;
    end if;

     BEGIN
       begin
        select nvl(tisp.se_qta,0)
        into   app_se_qta
        from tipi_spesa tisp
        where tisp.tipo_spesa=app_tipo_spesa
        and   tisp.causale_spesa='FO'
        and   to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'));
       exception
           when no_data_found then
            app_se_qta := 0;
       end;
       if app_se_qta = 1 then
          p_quantita:=1;
       else
          p_quantita:= null;
       end if;
     END;
     BEGIN
        begin
         select perc_maggiorazione
         into   app_perc_magg
         from   tipi_spesa tisp
         where  to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'))
         and    tisp.tipo_spesa=app_tipo_spesa
         and    tisp.causale_spesa='FO'
         and    rownum=1;
        exception
         when no_data_found then
             app_perc_magg :=null;
        end;
        P_importo_magg := round(app_perc_magg * p_tariffa/100,2);
      END;
  END;
    insert into righe_richiesta_rimborso
    ( rirr_id,
      riri_id,
      riferimento_riga,
      progressivo,
      tipo_spesa,
      tariffa,
      importo,
      quantita,
      importo_maggiorazione,
      sede_del,
      anno_del,
      numero_del,
      risorsa_intervento,
      capitolo,
      articolo,
      conto,
      impegno,
      anno_impegno,
      sub_impegno,
      anno_sub_impegno,
      codice_siope 
    )
    values
    ( p_rirr_id,
      p_riri_id,
      p_rirr_id,
      p_progressivo,
      app_tipo_spesa,
      p_tariffa,
      p_tariffa,
      p_quantita,
      p_importo_magg,
      app_sede_del,
      app_anno_del,
      app_numero_del,
      app_risorsa_intervento,
      app_capitolo,
      app_articolo,
      app_conto,
      app_impegno,
      app_anno_impegno,
      app_sub_impegno,
      app_anno_sub_impegno,
      app_codice_siope
     );
    if p_flag = 0 then
       p_errore := 'P00209';
       p_segnalazione := si4.get_error(p_errore);
       raise esci;
    end if;
commit;
end;
exception WHEN ESCI THEN rollback;
END CALCOLO_FORFAIT;

PROCEDURE CALCOLO_DIARIA         (p_data_inizio   in  date,
                                  p_data_fine     in  date,
                                  p_riri_id       in number,
                                  p_ci            in number,
                                  p_tipo_missione in varchar2,
                                  p_comune_fine   in number,
                                  p_button_flag   in number,
                                  p_form          in varchar2,
                                  p_errore        out varchar2,
                                  p_segnalazione  out varchar2) IS
/***************************************************************************************************
 NOME:        CALCOLO_DIARIA
 DESCRIZIONE: Genera in RIGHE_RICHIESTA_RIMBORSO per i record con
              tipo_spesa per il quale e attivo il flag se_diaria_in_comune_lavoro
              e se_diaria nella tabella TIPI_MISSIONE uno o piu record per il
              rimborso dell'indennita diaria di missione
 PARAMETRI:   p_tipo_missione  = tipo missione
              p_data_inizio    = data inizio trasferta
              p_data_fine      = data fine trasferta
              p_riri_id        = identificatvo di Righe_richieste_rimborso
              p_ci             = codice individuale del dipendente
              p_comune_fine    = comune di arrivo della trasferta
              p_nome_form      = form da cui viene lanciata la procedura, se e la PMTCRIST,
                                 vengono trattati solo i record di vitto e alloggio con progressivo <5000;
                                 se e la PMTCCOUF invece vengono trattati quelli con progressivo >5000
 RITORNA:     --
 NOTE:        --
****************************************************************************************************/
p_rirr_id        number;
p_progressivo    number;
app_progressivo  number;
app_tipo_spesa   varchar2(4);
app_se_diaria                   number;
app_se_diaria_comune_lavoro     number;
app_se_diaria_comune_residenza  number;
app_min_gg_diaria_totale        number;
app_gestione_ente               varchar2(4);
app_comune_ente                 number;
app_comune_dip                  number;
app_prog_4000                   number;
app_nr_gg_interi                number;
w_count                         number;
p_importo                       number;
p_tariffa                       number;
p_quantita                      number;
flag_vitto                      number:=0;
flag_alloggio                   number:=0;
app_perc_diaria                 number;
app_importo                     number;
app_data                        date;
app_imp_massimale               number;
p_importo_magg   number;
app_gestione     varchar2(8);
app_contratto    varchar2(4);
app_qualifica    varchar2(8);
app_livello      varchar2(4);
app_diff_hh      number;
app_diff_mm      number;
app_min_arr      number;
app_se_tariffa   number;
app_durata       number;
app_perc_magg    number;
ore_trasferta    number;
app_anno_del     number;
app_numero_del   number;
app_sede_del     varchar2(4);
app_risorsa_intervento varchar2(7);
app_capitolo     varchar2(14);
app_articolo     varchar2(14);
app_conto        varchar2(2);
app_impegno      number;
app_anno_impegno number;
app_sub_impegno    number;
app_anno_sub_impegno   number;
app_codice_siope       number;
esci             exception;
BEGIN

begin
/* Analizzo i flag se_diaria,se_diaria_in_comune_lavoro,se_diaria_in_comune_residenza        */
/* e min_gg_per_diaria_sul_totale dalla tabella TIPI_MISSIONE per il tipo_missione passato   */

 BEGIN
  select nvl(se_diaria,0),
         nvl(se_diaria_in_comune_lavoro,0),
         nvl(se_diaria_in_comune_residenza,0),
         min_gg_per_diaria_sul_totale
  into   app_se_diaria,
         app_se_diaria_comune_lavoro,
         app_se_diaria_comune_residenza,
         app_min_gg_diaria_totale
  from   tipi_missione
  where  tipo_missione = p_tipo_missione;
  exception
   when no_data_found then null;
 END;

 if app_se_diaria = 0 then
    p_errore := 'P00200';
    p_segnalazione := si4.get_error(p_errore);
    raise esci;
 end if;

/* Determinazione del comune di "residenza" della gestione(filiali) dell'ente(sede amministrativa) che usa il modulo in questione (GP4MT)*/
 BEGIN
 select gestione
 into   app_gestione_ente
 from   periodi_giuridici
 where  ci        = p_ci
 and    rilevanza = 'E'
 and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'));
 exception
  when no_data_found then
   begin
    select gestione
    into   app_gestione_ente
    from   periodi_giuridici
    where  ci        = p_ci
    and    rilevanza = 'S'
    and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'));
   end;
 END;

 BEGIN
   select comune_res
   into   app_comune_ente
   from   gestioni
   where  codice = app_gestione_ente;
   exception
        when no_data_found then
             p_errore := 'P00503';
             p_segnalazione := si4.get_error(p_errore)||' non presente';
             raise esci;
 END;

 /* Determinazione del comune di residenza del dipendente */
 BEGIN
  select comune_res
  into   app_comune_dip
  from   anagrafici
  where  ni = p_ci
  and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'));
  exception
        when no_data_found then
             p_errore := 'P00503';
             p_segnalazione := si4.get_error(p_errore)||' non presente';
             raise esci;
 END;

/* Se il flag se_diaria_in_comune_lavoro non e settato ed il luogo di arrivo e uguala al comune */
/* di residenza dell'ente, non si procede */

 if app_se_diaria_comune_lavoro = 0 and app_comune_ente = p_comune_fine then
    p_errore := 'P00229';
    p_segnalazione := si4.get_error(p_errore);
    raise esci;
 end if;

/* Se il flag se_diaria_in_comune_residenza non e settato ed il luogo di arrivo e uguala al comune */
/* di residenza dell'ente, non si procede */

 if app_se_diaria_comune_residenza = 0 and app_comune_dip = p_comune_fine then
    p_errore := 'P00230';
    p_segnalazione := si4.get_error(p_errore);
    raise esci;
 end if;
/* Calcolo della durata in ore della trsferta*/
  begin
   select (data_fine-data_inizio)*24
   into   ore_trasferta
   from richieste_rimborso
   where riri_id=p_riri_id;
  exception
   when no_data_found then ore_trasferta:=0;
  end;
/* Calcolo dei campi di Delibera ed Imputazione */
  begin
   select sede_del,
          anno_del,
          numero_del,
          risorsa_intervento,
          capitolo,
          articolo,
          conto,
          impegno,
          anno_impegno,
          sub_impegno,
          anno_sub_impegno,
          codice_siope
   into   app_sede_del,
          app_anno_del,
          app_numero_del,
          app_risorsa_intervento,
          app_capitolo,
          app_articolo,
          app_conto,
          app_impegno,
          app_anno_impegno,
          app_sub_impegno,
          app_anno_sub_impegno,
          app_codice_siope
   from   richieste_rimborso
   where  riri_id=p_riri_id;
  exception
   when no_data_found then null;
  end;
/* Calcolo della durata della trasferta */
/* Se e durata piu di 24 ore si crea il record di diaria giornaliera,se e durata meno di 24 ore o */
/* si e gia inserito il record per la diaria giornaliera e ci sono ore eccedenti i multipli di 24 */
/* si inserisce anche il record di diaria oraria */
  app_diff_hh:=trunc((p_data_fine-p_data_inizio)*24);
  app_diff_mm:=round(((p_data_fine-p_data_inizio)*24 - trunc((p_data_fine-p_data_inizio)*24))*60);
  begin
   select nvl(minuti_arrotondamento,0)
   into app_min_arr
   from parametri_missioni;
   exception
        when no_data_found then
             p_errore := 'P00503';
             p_segnalazione := si4.get_error(p_errore)||' non presente';
             raise esci;
  end;
  if app_diff_mm < app_min_arr then
     app_durata := app_diff_hh;
  else
     app_durata := app_diff_hh+1;
  end if;

/* DIARIA GIORNALIERA */
if app_durata >= 24 then
   begin
/*Determinazione del tipo spesa */
      begin
        select tisp.tipo_spesa
        into   app_tipo_spesa
        from   tipi_spesa tisp
        where  tisp.causale_spesa='DG'
        and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'));
      exception
         when no_data_found then
          p_errore := 'P00210';
             p_segnalazione := si4.get_error(p_errore);
             raise esci;
            when too_many_rows then
          p_errore := 'P00211';
             p_segnalazione := si4.get_error(p_errore);
             raise esci;
      end;
/* Calcolo Tariffa */
     begin
      select nvl(tisp.se_tariffa,0)
      into   app_se_tariffa
      from tipi_spesa tisp
      where tisp.tipo_spesa=app_tipo_spesa
        and   tisp.causale_spesa = 'DG'
        and   to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'));
     exception
       when no_data_found then
         app_se_tariffa := 0;
     end;
    if app_se_tariffa = 1 then
      begin
        select gestione,contratto,codice,livello
        into   app_gestione,app_contratto,app_qualifica,app_livello
        from   qualifiche_giuridiche qugi,
               periodi_giuridici     pegi
        where  pegi.qualifica = qugi.numero
        and      pegi.rilevanza = 'S'
        and       pegi.ci        = p_ci
        and      to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
        and      to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between pegi.dal and nvl(pegi.al,to_date('3333333','j'));
      exception
       when no_data_found then
       NULL;
      end ;
       begin
           select tariffa
           into   p_tariffa
           from   tariffe tari
           where  tipo_spesa     = app_tipo_spesa
           and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tari.dal and nvl(tari.al,to_date('3333333','j'))
           and    tari.gestione  = app_gestione
           and    tari.contratto = app_contratto
           and    tari.qualifica = app_qualifica
           and    tari.livello   = app_livello;
       exception
          when no_data_found then
            begin
                 select tariffa
                 into   p_tariffa
                 from   tariffe tari
                 where  tipo_spesa  = app_tipo_spesa
                 and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tari.dal and nvl(tari.al,to_date('3333333','j'))
                 and    tari.gestione = '%'
                 and    tari.contratto ='%'
                 and    tari.qualifica = '%'
                 and    tari.livello   = '%';
             exception
                when no_data_found then
                 p_errore := 'P00220';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
                    when too_many_rows then
                 p_errore := 'P00221';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
             end ;
          when too_many_rows then
            begin
              p_errore := 'P00221';
              p_segnalazione := si4.get_error(p_errore);
              raise esci;
           end;
       end ;
    end if;
    if app_se_tariffa = 0 then
         begin
        p_errore := 'P00219';
          p_segnalazione := si4.get_error(p_errore);
          raise esci;
         end;
    end if;

/* Determinazione quantita */
app_nr_gg_interi := trunc(app_durata/24);
if app_nr_gg_interi <= app_min_gg_diaria_totale then
 begin
   p_quantita := app_nr_gg_interi;
   p_importo  := p_tariffa * p_quantita;
   for cur_1 in
       (select distinct tipo_spesa
        from  righe_richiesta_rimborso
        where riri_id = p_riri_id
        and   ((p_form= 'PMTCCOUF') or (p_form= 'PMTCRIST' and progressivo<5000))
       )
    loop
      begin
        select 1
        into   flag_alloggio
        from   tipi_spesa
        where  tipo_spesa=cur_1.tipo_spesa
        and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
        and    causale_spesa='AL';
      exception
       when no_data_found then null;
      end;
     begin
      select 1
      into   flag_vitto
      from   tipi_spesa
      where  tipo_spesa=cur_1.tipo_spesa
      and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
      and    causale_spesa='VI';
      exception
       when no_data_found then null;
     end;
   end loop; -- cur_1

   /* Determinazione della percentuale di diaria */
   begin
    select perc_diaria
    into   app_perc_diaria
    from   regole_diaria
    where  gestione = app_gestione
    and    contratto = app_contratto
    and    ore_trasferta between min_ore and max_ore;
   exception
    --   no_data_found app_gestione/app_contratto
    when no_data_found then
     begin
      select perc_diaria
      into   app_perc_diaria
      from   regole_diaria
      where  gestione = app_gestione
      and    contratto = '%'
      and    ore_trasferta between min_ore and max_ore;
     exception
      -- too_many_rows con app_gestione/%--
      when too_many_rows then
       begin
         select perc_diaria
         into   app_perc_diaria
         from   regole_diaria
         where  gestione  =app_gestione
         and    contratto = '%'
         and    nvl(se_rimborso_alloggio,0) = flag_alloggio
         and    ore_trasferta between min_ore and max_ore ;
       exception
        when too_many_rows then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  =app_gestione
          and    contratto = '%'
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    nvl(se_rimborso_vitto,0)    = flag_vitto
          and    ore_trasferta between min_ore and max_ore  ;
         exception
           when no_data_found then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = '%'
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore ;
              exception
               when no_data_found then
                 p_errore := 'P00222';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
               when too_many_rows then
                 p_errore := 'P00223';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
              end;
           when too_many_rows then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = '%'
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
               when no_data_found then
                 p_errore := 'P00222';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
               when too_many_rows then
                  p_errore := 'P00223';
                  p_segnalazione := si4.get_error(p_errore);
                  raise esci;
              end;
         end;
        when no_data_found then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  =app_gestione
          and    contratto = '%'
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    nvl(se_rimborso_vitto,0)    = flag_vitto
          and    ore_trasferta between min_ore and max_ore;
         exception
           when no_data_found then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
             where  gestione  =app_gestione
              and    contratto ='%'
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore  ;
            exception
               when no_data_found then
                 p_errore := 'P00222';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
               when too_many_rows then
                 p_errore := 'P00223';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
            end;
            when too_many_rows then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
              where  gestione  =app_gestione
                and    contratto = '%'
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore ;
            exception
               when no_data_found then
                 p_errore := 'P00222';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
               when too_many_rows then
                 p_errore := 'P00223';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
            end;
         end;
      end;
      -- no_data_found app_gestione / % --
       when no_data_found then
        begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione = '%'
          and    contratto = app_contratto
          and    ore_trasferta between min_ore and max_ore;
        exception
             when too_many_rows then
               begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  ='%'
                 and    contratto = app_contratto
                 and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                 and    ore_trasferta between min_ore and max_ore ;
              exception
                  when too_many_rows then
                   begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                      where  gestione  ='%'
                      and    contratto = app_contratto
                      and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    ore_trasferta between min_ore and max_ore ;
                   exception
                     when no_data_found then
                        begin
                          select perc_diaria
                          into   app_perc_diaria
                          from   regole_diaria
                          where  gestione  ='%'
                            and    contratto = app_contratto
                            and    nvl(se_rimborso_vitto,0)    = flag_vitto
                            and    p_quantita*24 between min_ore and max_ore
                            and    ore_trasferta between min_ore and max_ore ;
                        exception
                         when no_data_found then
                               p_errore := 'P00222';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                         when too_many_rows then
                               p_errore := 'P00223';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                        end;
                     when too_many_rows then
                        begin
                          select perc_diaria
                          into   app_perc_diaria
                          from   regole_diaria
                          where  gestione  ='%'
                          and    contratto = app_contratto
                          and    nvl(se_rimborso_vitto,0)    = flag_vitto
                          and    p_quantita*24 between min_ore and max_ore
                          and    ore_trasferta between min_ore and max_ore ;
                        exception
                         when no_data_found then
                               p_errore := 'P00222';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                         when too_many_rows then
                               p_errore := 'P00223';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                        end;
                   end;
                  when no_data_found then
                   begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                      where  gestione  =app_gestione
                        and    contratto = '%'
                        and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                        and    nvl(se_rimborso_vitto,0)    = flag_vitto
                        and    ore_trasferta between min_ore and max_ore ;
                   exception
                     when no_data_found then
                      begin
                        select perc_diaria
                        into   app_perc_diaria
                        from   regole_diaria
                        where  gestione  =app_gestione
                          and    contratto = '%'
                          and    nvl(se_rimborso_vitto,0)    = flag_vitto
                          and    p_quantita*24 between min_ore and max_ore
                          and    ore_trasferta between min_ore and max_ore ;
                      exception
                         when no_data_found then
                               p_errore := 'P00222';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                         when too_many_rows then
                               p_errore := 'P00223';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                      end;
                     when too_many_rows then
                      begin
                        select perc_diaria
                        into   app_perc_diaria
                        from   regole_diaria
                         where  gestione  =app_gestione
                          and    contratto = '%'
                          and    nvl(se_rimborso_vitto,0)    = flag_vitto
                          and    p_quantita*24 between min_ore and max_ore
                          and    ore_trasferta between min_ore and max_ore;
                      exception
                         when no_data_found then
                               p_errore := 'P00222';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                         when too_many_rows then
                               p_errore := 'P00223';
                               p_segnalazione := si4.get_error(p_errore);
                               raise esci;
                      end;
                   end;
              end;

        -- no_data_found % / app_contratto
        when no_data_found then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  ='%'
          and    contratto = '%'
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    ore_trasferta between min_ore and max_ore;
          exception
           when too_many_rows then
            begin
             select perc_diaria
             into   app_perc_diaria
             from   regole_diaria
             where  gestione  = '%'
             and    contratto = '%'
             and    nvl(se_rimborso_alloggio,0) = flag_alloggio
             and    nvl(se_rimborso_vitto,0)    = flag_vitto
             and    ore_trasferta between min_ore and max_ore;
             exception
              when no_data_found then
                 begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_vitto,0)    = flag_vitto
                 and    p_quantita*24 between min_ore and max_ore
                 and    ore_trasferta between min_ore and max_ore ;
                 exception
                  when no_data_found then
                    p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                    p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;

               end;
              when too_many_rows then
                 begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_vitto,0)    =flag_vitto
                 and    p_quantita*24 between min_ore and max_ore
                 and    ore_trasferta between min_ore and max_ore ;
                 exception
                  when no_data_found then
                    p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                    p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;

               end;
            end;
           when no_data_found then
            begin
             select perc_diaria
             into   app_perc_diaria
             from   regole_diaria
             where  gestione  = '%'
             and    contratto = '%'
             and    nvl(se_rimborso_alloggio,0) = flag_alloggio
             and    nvl(se_rimborso_vitto,0)    = flag_vitto
             and    ore_trasferta between min_ore and max_ore;
             exception
              when no_data_found then
               begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_vitto,0)    = flag_vitto
                 and    p_quantita*24 between min_ore and max_ore
                 and    ore_trasferta between min_ore and max_ore;
                 exception
                  when no_data_found then
                    p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                    p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;

               end;
               when too_many_rows then
               begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_vitto,0)    =flag_vitto
                 and    p_quantita*24 between min_ore and max_ore
                 and    ore_trasferta between min_ore and max_ore ;
                 exception
                  when no_data_found then
                    p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                    p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;

               end;
            end;
         end;
        end;
     end;
-- too_many_rows con app_gestione/app_contratto--
    when too_many_rows then
     begin
       select perc_diaria
       into   app_perc_diaria
       from   regole_diaria
       where  gestione  =app_gestione
       and    contratto = app_contratto
       and    nvl(se_rimborso_alloggio,0) = flag_alloggio
       and    ore_trasferta between min_ore and max_ore;
     exception
        when too_many_rows then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  =app_gestione
          and    contratto = app_contratto
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    nvl(se_rimborso_vitto,0)    = flag_vitto
          and    ore_trasferta between min_ore and max_ore ;
         exception
           when no_data_found then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = app_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
              end;
           when too_many_rows then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = app_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
              end;
         end;
        when no_data_found then
         begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  =app_gestione
            and    contratto = app_contratto
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    nvl(se_rimborso_vitto,0)    = flag_vitto
            and    ore_trasferta between min_ore and max_ore ;
         exception
           when no_data_found then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
             where  gestione  =app_gestione
              and    contratto = app_contratto
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore ;
            exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end;
           when too_many_rows then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
             where  gestione  =app_gestione
              and    contratto = app_contratto
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore ;
            exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                    p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end;
         end;
     end;
   end;
     app_importo := round(p_importo*app_perc_diaria/100,2);
    /* Controlla che l'importo non sia maggiore dell' importo massimale della tabella */
    /* LIMITI_IMPORTO_SPESA */
    BEGIN
     begin
       select importo_massimale
       into   app_imp_massimale
       from   limiti_importo_spesa
       where  tipo_spesa = app_tipo_spesa
         and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
         and    gestione  = app_gestione
         and    contratto = app_contratto
         and    qualifica = app_qualifica
         and    livello   = app_livello;
     exception
      when no_data_found then
        begin
           select importo_massimale
           into   app_imp_massimale
           from   limiti_importo_spesa
           where  tipo_spesa = app_tipo_spesa
           and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
           and    gestione  = '%'
           and    contratto = '%'
           and    qualifica = '%'
           and    livello   = '%';
        exception
          when no_data_found then app_imp_massimale:=null;
        end;
     end;

    if app_imp_massimale is not null and app_importo > app_imp_massimale then
       p_errore := 'P00225';
       p_segnalazione := si4.get_error(p_errore);
       raise esci;
    end if;
    END;

    /* Calcola la percentuale maggiorazione */
    BEGIN
      begin
         select perc_maggiorazione
         into   app_perc_magg
         from   tipi_spesa tisp
         where  to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'))
         and    tisp.tipo_spesa=app_tipo_spesa
         and    rownum=1;
      exception
         when no_data_found then
             app_perc_magg :=null;
      end;
      P_importo_magg := round(app_perc_magg * p_tariffa/100,2);
    END;
/* Determinazione del rirr_id */
     begin
       select RIRR_SQ.NEXTVAL
       into p_rirr_id
       from dual;
     end;
/* Determinazione del progressivo */
      begin
       select 1
       into app_prog_4000
       from righe_richiesta_rimborso
       where progressivo = 4000
       and   riri_id= p_riri_id;
      exception
        when no_data_found then
             app_prog_4000:=0;
      end;

      if app_prog_4000   = 0 then
         p_progressivo := 4000;
      else
       BEGIN
         SELECT MAX(PROGRESSIVO)
         INTO app_progressivo
         FROM RIGHE_RICHIESTA_RIMBORSO
         WHERE RIRI_ID = p_riri_id
          AND   PROGRESSIVO BETWEEN 4000 AND 5000
         ;
         if mod(app_progressivo,10) != 0 then
           p_progressivo := (ceil(app_progressivo/10)*10);
         else
           p_progressivo := ((ceil(app_progressivo/10)*10)+10);
         end if;
         if p_progressivo >= 5000 then
            p_errore := 'P00214';
            p_segnalazione := si4.get_error(p_errore);
            raise esci;
         end if;
       END;
      end if;

   /* Inserimento un solo record di diaria giornaliera*/
       insert into righe_richiesta_rimborso
       ( rirr_id,
        riri_id,
        riferimento_riga,
        progressivo,
        tipo_spesa,
        tariffa,
        importo,
        quantita,
        importo_maggiorazione,
        note,
        button_diaria,
        sede_del,
        anno_del,
        numero_del,
        risorsa_intervento,
        capitolo,
        articolo,
        conto,
        impegno,
        anno_impegno,
        sub_impegno,
        anno_sub_impegno,
        codice_siope )
        values
      ( p_rirr_id,
        p_riri_id,
        p_rirr_id,
        p_progressivo,
        app_tipo_spesa,
        p_tariffa,
        app_importo,
        p_quantita,
        p_importo_magg,
        'Indennita diaria giornaliera dal '||to_char(trunc(p_data_inizio),'dd/mm/yyyy')||' al '||to_char(trunc(p_data_fine),'dd/mm/yyyy'),
        p_button_flag,
        app_sede_del,
        app_anno_del,
        app_numero_del,
        app_risorsa_intervento,
        app_capitolo,
        app_articolo,
        app_conto,
        app_impegno,
        app_anno_impegno,
        app_sub_impegno,
        app_anno_sub_impegno,
        app_codice_siope);
 end;
else
 begin
  p_quantita:=1;
  p_importo := p_tariffa;
  for w_count in 1 .. app_nr_gg_interi loop
  begin
    select  data_documento
    into    app_data
    from    righe_richiesta_rimborso rrri,
                tipi_spesa  tisp
      where   rrri.riri_id = p_riri_id
      and     rrri.tipo_spesa=tisp.tipo_spesa
      and     tisp.causale_spesa in ('VI','AL')
      and     trunc(p_data_inizio)+w_count-1 between dal and nvl(al,to_date('3333333','j'))
      and     ((p_form= 'PMTCCOUF') or (p_form= 'PMTCRIST' and progressivo<5000))
      and     data_documento is null;
     raise too_many_rows;
  exception
     when too_many_rows then
          p_errore := 'P00224';
          p_segnalazione := si4.get_error(p_errore);
          raise esci;
     when no_data_found then
       select  nvl(max(decode(tisp.causale_spesa,'VI',1,0)),0),nvl(max(decode(tisp.causale_spesa,'AL',1,0)),0)
       into    flag_vitto, flag_alloggio
       from    righe_richiesta_rimborso rrri,
               tipi_spesa  tisp
       where   rrri.riri_id        = p_riri_id
       and     rrri.tipo_spesa     = tisp.tipo_spesa
       and   ((p_form= 'PMTCCOUF') or (p_form= 'PMTCRIST' and progressivo<5000))
       and     to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') +w_count-1 between dal and nvl(al,to_date('3333333','j'))
       and     rrri.data_documento = to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') +w_count-1;
  end;

   /* Determinazione della percentuale di diaria */
   begin
    select perc_diaria
    into   app_perc_diaria
    from   regole_diaria
    where  gestione = app_gestione
    and    contratto = app_contratto
    and    ore_trasferta between min_ore and max_ore;
   exception
    --   no_data_found app_gestione/app_contratto
    when no_data_found then
     begin
      select perc_diaria
      into   app_perc_diaria
      from   regole_diaria
      where  gestione = app_gestione
      and    contratto = '%'
      and    ore_trasferta between min_ore and max_ore;
     exception
      -- too_many_rows con app_gestione/%--
      when too_many_rows then
      begin
       select perc_diaria
       into   app_perc_diaria
       from   regole_diaria
       where  gestione  =app_gestione
       and    contratto = '%'
       and    nvl(se_rimborso_alloggio,0) = flag_alloggio
       and    ore_trasferta between min_ore and max_ore ;
      exception
        when too_many_rows then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  =app_gestione
          and    contratto = '%'
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    nvl(se_rimborso_vitto,0)    = flag_vitto
          and    ore_trasferta between min_ore and max_ore;
         exception
           when no_data_found then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = '%'
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore ;
              exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                      p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
              end;
           when too_many_rows then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = '%'
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore ;
              exception
               when no_data_found then
                 p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                 p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;

              end;
         end;
        when no_data_found then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  =app_gestione
          and    contratto = '%'
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    nvl(se_rimborso_vitto,0)    = flag_vitto
          and    ore_trasferta between min_ore and max_ore ;
         exception
           when no_data_found then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
             where  gestione  =app_gestione
             and    contratto ='%'
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore;
            exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end;
           when too_many_rows then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
              where  gestione  =app_gestione
              and    contratto = '%'
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore;
            exception
               when no_data_found then
                 p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                 p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;

            end;
         end;
      end;
      -- no_data_found app_gestione / % --
       when no_data_found then
       begin
        select perc_diaria
        into   app_perc_diaria
        from   regole_diaria
        where  gestione = '%'
        and    contratto = app_contratto
        and    ore_trasferta between min_ore and max_ore;
       exception
          -- too_many_rows % / app_contratto
         when too_many_rows then
             begin
               select perc_diaria
               into   app_perc_diaria
               from   regole_diaria
               where  gestione  ='%'
               and    contratto = app_contratto
               and    nvl(se_rimborso_alloggio,0) = flag_alloggio
               and    ore_trasferta between min_ore and max_ore ;
             exception
                when too_many_rows then
                 begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  ='%'
                  and    contratto = app_contratto
                  and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    ore_trasferta between min_ore and max_ore ;
                 exception
                   when no_data_found then
                      begin
                        select perc_diaria
                        into   app_perc_diaria
                        from   regole_diaria
                        where  gestione  ='%'
                        and    contratto = app_contratto
                        and    nvl(se_rimborso_vitto,0)    = flag_vitto
                        and    p_quantita*24 between min_ore and max_ore
                        and    ore_trasferta between min_ore and max_ore;
                      exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                      end;
                   when too_many_rows then
                      begin
                        select perc_diaria
                        into   app_perc_diaria
                        from   regole_diaria
                        where  gestione  ='%'
                        and    contratto = app_contratto
                        and    nvl(se_rimborso_vitto,0)    = flag_vitto
                        and    p_quantita*24 between min_ore and max_ore
                        and    ore_trasferta between min_ore and max_ore ;
                      exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                      end;
                 end;
                when no_data_found then
                 begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  =app_gestione
                  and    contratto = '%'
                  and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    ore_trasferta between min_ore and max_ore ;
                 exception
                   when no_data_found then
                    begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                     where  gestione  =app_gestione
                      and    contratto = '%'
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    p_quantita*24 between min_ore and max_ore
                      and    ore_trasferta between min_ore and max_ore ;
                    exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                    end;
                    when too_many_rows then
                    begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                     where  gestione  =app_gestione
                     and    contratto = '%'
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    p_quantita*24 between min_ore and max_ore
                      and    ore_trasferta between min_ore and max_ore ;
                      exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                    end;
                 end;
             end;
          -- no_data_found % / app_contratto
          when no_data_found then
           begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  ='%'
          and    contratto = '%'
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    ore_trasferta between min_ore and max_ore ;
         exception
           when too_many_rows then
            begin
             select perc_diaria
             into   app_perc_diaria
             from   regole_diaria
             where  gestione  = '%'
             and    contratto = '%'
             and    nvl(se_rimborso_alloggio,0) = flag_alloggio
             and    nvl(se_rimborso_vitto,0)    = flag_vitto
             and    ore_trasferta between min_ore and max_ore ;
            exception
              when no_data_found then
                 begin
                   select perc_diaria
                   into   app_perc_diaria
                   from   regole_diaria
                   where  gestione  = '%'
                   and    contratto = '%'
                   and    nvl(se_rimborso_vitto,0)    = flag_vitto
                   and    p_quantita*24 between min_ore and max_ore
                   and    ore_trasferta between min_ore and max_ore ;
                 exception
                  when no_data_found then
                        p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                        p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
               end;
              when too_many_rows then
                 begin
                   select perc_diaria
                   into   app_perc_diaria
                   from   regole_diaria
                   where  gestione  = '%'
                   and    contratto = '%'
                   and    nvl(se_rimborso_vitto,0)    =flag_vitto
                   and    p_quantita*24 between min_ore and max_ore
                   and    ore_trasferta between min_ore and max_ore ;
                 exception
                  when no_data_found then
                        p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                        p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
               end;
            end;
           when no_data_found then
            begin
             select perc_diaria
             into   app_perc_diaria
             from   regole_diaria
             where  gestione  = '%'
             and    contratto = '%'
             and    nvl(se_rimborso_alloggio,0) = flag_alloggio
             and    nvl(se_rimborso_vitto,0)    = flag_vitto
             and    ore_trasferta between min_ore and max_ore;
            exception
              when no_data_found then
               begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_vitto,0)    = flag_vitto
                 and    p_quantita*24 between min_ore and max_ore
                 and    ore_trasferta between min_ore and max_ore ;
                 exception
                  when no_data_found then
                        p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                        p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
               end;
               when too_many_rows then
               begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_vitto,0)    =flag_vitto
                 and    p_quantita*24 between min_ore and max_ore
                 and    ore_trasferta between min_ore and max_ore ;
               exception
                  when no_data_found then
                        p_errore := 'P00222';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
                  when too_many_rows then
                        p_errore := 'P00223';
                        p_segnalazione := si4.get_error(p_errore);
                        raise esci;
               end;
            end;
         end;
       end;
     end;
-- too_many_rows con app_gestione/app_contratto--
    when too_many_rows then
     begin
       select perc_diaria
       into   app_perc_diaria
       from   regole_diaria
       where  gestione  =app_gestione
       and    contratto = app_contratto
       and    nvl(se_rimborso_alloggio,0) = flag_alloggio
       and    ore_trasferta between min_ore and max_ore ;
     exception
        when too_many_rows then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  =app_gestione
          and    contratto = app_contratto
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    nvl(se_rimborso_vitto,0)    = flag_vitto
          and    ore_trasferta between min_ore and max_ore;
         exception
           when no_data_found then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = app_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
              end;
           when too_many_rows then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = app_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
              end;
         end;
        when no_data_found then
         begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  =app_gestione
            and    contratto = app_contratto
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    nvl(se_rimborso_vitto,0)    = flag_vitto
            and    ore_trasferta between min_ore and max_ore;
         exception
           when no_data_found then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
               where  gestione  =app_gestione
               and    contratto = app_contratto
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore ;
            exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end;
            when too_many_rows then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
              where  gestione  =app_gestione
              and    contratto = app_contratto
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore;
            exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end;
         end;
     end;
   end;
   app_importo := round(p_importo * app_perc_diaria/100,2);
   /* Controlla che l'importo non sia maggiore dell' importo massimale della tabella */
    /* LIMITI_IMPORTO_SPESA */
    BEGIN
    begin
       select importo_massimale
       into   app_imp_massimale
       from   limiti_importo_spesa
       where  tipo_spesa = app_tipo_spesa
        and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
        and    gestione  = app_gestione
        and    contratto = app_contratto
        and    qualifica = app_qualifica
        and    livello   = app_livello;
    exception
      when no_data_found then
        begin
           select importo_massimale
           into   app_imp_massimale
           from   limiti_importo_spesa
           where  tipo_spesa = app_tipo_spesa
           and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
           and    gestione  = '%'
           and    contratto = '%'
           and    qualifica = '%'
           and    livello   = '%';
        exception
          when no_data_found then app_imp_massimale:=null;
        end;
    end;

    if app_imp_massimale is not null and app_importo > app_imp_massimale then
       p_errore := 'P00225';
       p_segnalazione := si4.get_error(p_errore);
       raise esci;
    end if;
    END;

   /* Calcola la percentuale maggiorazione */
    BEGIN
      begin
         select perc_maggiorazione
         into   app_perc_magg
         from   tipi_spesa tisp
         where  to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'))
         and    tisp.tipo_spesa=app_tipo_spesa
         and    rownum=1;
      exception
         when no_data_found then
             app_perc_magg :=null;
      end;
        P_importo_magg := round(app_perc_magg * p_tariffa/100,2);
    END;
/* Determinazione del rirr_id */
    begin
       select RIRR_SQ.NEXTVAL
       into p_rirr_id
       from dual
        ;
    end;
/* Determinazione del progressivo */
    begin
       select 1
       into app_prog_4000
       from righe_richiesta_rimborso
       where progressivo = 4000
       and   riri_id= p_riri_id;
    exception
        when no_data_found then
             app_prog_4000:=0;
    end;

    if app_prog_4000   = 0 then
       p_progressivo := 4000;
    else
       BEGIN
       SELECT MAX(PROGRESSIVO)
       INTO app_progressivo
       FROM RIGHE_RICHIESTA_RIMBORSO
       WHERE RIRI_ID = p_riri_id
       AND   PROGRESSIVO BETWEEN 4000 AND 5000;
       if mod(app_progressivo,10) != 0 then
         p_progressivo := (ceil(app_progressivo/10)*10);
       else
         p_progressivo := ((ceil(app_progressivo/10)*10)+10);
       end if;
       if p_progressivo >= 5000 then
          p_errore := 'P00214';
          p_segnalazione := si4.get_error(p_errore);
          raise esci;
       end if;
       END;
    end if;

  /* Inserimento dei record di diaria giornaliera tanti quanti sono i giorni di trasferta*/
      insert into righe_richiesta_rimborso
      ( rirr_id,
        riri_id,
        riferimento_riga,
        progressivo,
        tipo_spesa,
        tariffa,
        importo,
        quantita,
        importo_maggiorazione,
        note,
        button_diaria,
        sede_del,
        anno_del,
        numero_del,
        risorsa_intervento,
        capitolo,
        articolo,
        conto,
        impegno,
        anno_impegno,
        sub_impegno,
        anno_sub_impegno,
        codice_siope )
        values
      ( p_rirr_id,
        p_riri_id,
        p_rirr_id,
        p_progressivo,
        app_tipo_spesa,
        p_tariffa,
        app_importo,
        p_quantita,
        p_importo_magg,
        'Indennita diaria giornaliera del '||to_char(trunc(p_data_inizio+w_count-1),'dd/mm/yyyy'),
        p_button_flag,
        app_sede_del,
        app_anno_del,
        app_numero_del,
        app_risorsa_intervento,
        app_capitolo,
        app_articolo,
        app_conto,
        app_impegno,
        app_anno_impegno,
        app_sub_impegno,
        app_anno_sub_impegno,
        app_codice_siope);
  end loop; --- w_count
 end;
end if;

end;
end if;

/* DIARIA ORARIA */
if mod(app_durata,24)!= 0 then
begin
/* Determinazione del tipo spesa */
    begin
      select tisp.tipo_spesa
      into   app_tipo_spesa
      from   tipi_spesa tisp
      where  tisp.causale_spesa='DO'
      and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'));
    exception
         when no_data_found then
             p_errore := 'P00210';
             p_segnalazione := si4.get_error(p_errore);
             raise esci;
         when too_many_rows then
            p_errore := 'P00211';
             p_segnalazione := si4.get_error(p_errore);
             raise esci;
     end;
/* Calcolo Tariffa */
   begin
      select nvl(tisp.se_tariffa,0)
      into   app_se_tariffa
      from tipi_spesa tisp
      where tisp.tipo_spesa=app_tipo_spesa
        and   tisp.causale_spesa = 'DO'
      and   to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'));
   exception
       when no_data_found then
         app_se_tariffa := 0;
   end;
    if app_se_tariffa = 1 then
      begin
        select gestione,contratto,codice,livello
        into   app_gestione,app_contratto,app_qualifica,app_livello
        from   qualifiche_giuridiche qugi,
               periodi_giuridici     pegi
        where  pegi.qualifica = qugi.numero
        and      pegi.rilevanza = 'S'
        and       pegi.ci        = p_ci
        and      to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
        and      to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between pegi.dal and nvl(pegi.al,to_date('3333333','j'));
      exception
       when no_data_found then
       NULL;
      end ;
      begin
           select tariffa
           into   p_tariffa
           from   tariffe tari
           where  tipo_spesa  = app_tipo_spesa
           and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tari.dal and nvl(tari.al,to_date('3333333','j'))
           and    tari.gestione  = app_gestione
           and    tari.contratto = app_contratto
           and    tari.qualifica = app_qualifica
           and    tari.livello   = app_livello;
      exception
          when no_data_found then
            begin
                 select tariffa
                 into   p_tariffa
                 from   tariffe tari
                 where  tipo_spesa  = app_tipo_spesa
                 and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tari.dal and nvl(tari.al,to_date('3333333','j'))
                 and    tari.gestione = '%'
                 and    tari.contratto ='%'
                 and    tari.qualifica = '%'
                 and    tari.livello   = '%';
            exception
                when no_data_found then
                     p_errore := 'P00220';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
                when too_many_rows then
                     p_errore := 'P00221';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end ;
          when too_many_rows then
            begin
                 p_errore := 'P00221';
                 p_segnalazione := si4.get_error(p_errore);
                 raise esci;
           end;
      end ;
     end if;
     if app_se_tariffa = 0 then
       begin
         p_errore := 'P00219';
         p_segnalazione := si4.get_error(p_errore);
         raise esci;
       end;
     end if;

/* Determiazione quantita */
p_quantita:= mod(app_durata,24);
p_importo := p_tariffa*p_quantita;

for cur_1 in
       (select distinct tipo_spesa
        from  righe_richiesta_rimborso
        where riri_id = p_riri_id
        and   ((p_form= 'PMTCCOUF') or (p_form= 'PMTCRIST' and progressivo<5000))
       )
    loop
      begin
        select 1
        into   flag_alloggio
        from   tipi_spesa
        where  tipo_spesa=cur_1.tipo_spesa
        and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
        and    causale_spesa='AL';
      exception
       when no_data_found then null;
      end;
     begin
      select 1
      into   flag_vitto
      from   tipi_spesa
      where  tipo_spesa=cur_1.tipo_spesa
      and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
      and    causale_spesa='VI';
      exception
       when no_data_found then null;
     end;
   end loop; -- cur_1

   /* Determinazione della percentuale di diaria */
   begin
    select perc_diaria
    into   app_perc_diaria
    from   regole_diaria
    where  gestione = app_gestione
    and    contratto = app_contratto
    and    ore_trasferta between min_ore and max_ore;
   exception
    --   no_data_found app_gestione/app_contratto
    when no_data_found then
     begin
      select perc_diaria
      into   app_perc_diaria
      from   regole_diaria
      where  gestione = app_gestione
      and    contratto = '%'
      and    ore_trasferta between min_ore and max_ore;
     exception
          -- too_many_rows con app_gestione/%--
        when too_many_rows then
          begin
           select perc_diaria
           into   app_perc_diaria
           from   regole_diaria
           where  gestione  =app_gestione
           and    contratto = '%'
           and    nvl(se_rimborso_alloggio,0) = flag_alloggio
           and    ore_trasferta between min_ore and max_ore;
          exception
            when too_many_rows then
             begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = '%'
                and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    ore_trasferta between min_ore and max_ore;
            exception
               when no_data_found then
                  begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                      where  gestione  =app_gestione
                      and    contratto = '%'
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    p_quantita*24 between min_ore and max_ore
                      and    ore_trasferta between min_ore and max_ore;
                  exception
                   when no_data_found then
                         p_errore := 'P00222';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                   when too_many_rows then
                         p_errore := 'P00223';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                  end;
               when too_many_rows then
                  begin
                    select perc_diaria
                    into   app_perc_diaria
                    from   regole_diaria
                    where  gestione  =app_gestione
                    and    contratto = '%'
                    and    nvl(se_rimborso_vitto,0)    = flag_vitto
                    and    p_quantita*24 between min_ore and max_ore
                    and    ore_trasferta between min_ore and max_ore;
                  exception
                   when no_data_found then
                         p_errore := 'P00222';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                   when too_many_rows then
                         p_errore := 'P00223';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                  end;
            end;
            when no_data_found then
             begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
              where  gestione  =app_gestione
              and    contratto = '%'
              and    nvl(se_rimborso_alloggio,0) = flag_alloggio
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    ore_trasferta between min_ore and max_ore ;
             exception
               when no_data_found then
                begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                 where  gestione  =app_gestione
                 and    contratto ='%'
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    p_quantita*24 between min_ore and max_ore
                  and    ore_trasferta between min_ore and max_ore ;
                exception
                   when no_data_found then
                         p_errore := 'P00222';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                   when too_many_rows then
                         p_errore := 'P00223';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                end;
               when too_many_rows then
                begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                 where  gestione  =app_gestione
                 and    contratto = '%'
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    p_quantita*24 between min_ore and max_ore
                  and    ore_trasferta between min_ore and max_ore;
                exception
                   when no_data_found then
                         p_errore := 'P00222';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                   when too_many_rows then
                         p_errore := 'P00223';
                         p_segnalazione := si4.get_error(p_errore);
                         raise esci;
                end;
             end;
          end;
          -- no_data_found app_gestione / % --
        when no_data_found then
           begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione = '%'
            and    contratto = app_contratto
            and    ore_trasferta between min_ore and max_ore;
           exception
            -- too_many_rows % / app_contratto
           when too_many_rows then
             begin
               select perc_diaria
               into   app_perc_diaria
               from   regole_diaria
               where  gestione  ='%'
               and    contratto = app_contratto
               and    nvl(se_rimborso_alloggio,0) = flag_alloggio
               and    ore_trasferta between min_ore and max_ore;
             exception
                when too_many_rows then
                 begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  ='%'
                   and    contratto = app_contratto
                  and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    ore_trasferta between min_ore and max_ore;
                 exception
                   when no_data_found then
                      begin
                        select perc_diaria
                        into   app_perc_diaria
                        from   regole_diaria
                        where  gestione  ='%'
                        and    contratto = app_contratto
                        and    nvl(se_rimborso_vitto,0)    = flag_vitto
                        and    p_quantita*24 between min_ore and max_ore
                        and    ore_trasferta between min_ore and max_ore ;
                      exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                      end;
                   when too_many_rows then
                      begin
                        select perc_diaria
                        into   app_perc_diaria
                        from   regole_diaria
                        where  gestione  ='%'
                        and    contratto = app_contratto
                        and    nvl(se_rimborso_vitto,0)    = flag_vitto
                        and    p_quantita*24 between min_ore and max_ore
                        and    ore_trasferta between min_ore and max_ore ;
                      exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                      end;
                 end;
                when no_data_found then
                 begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  =app_gestione
                  and    contratto = '%'
                  and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    ore_trasferta between min_ore and max_ore  ;
                 exception
                   when no_data_found then
                    begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                     where   gestione  =app_gestione
                      and    contratto = '%'
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    p_quantita*24 between min_ore and max_ore
                      and    ore_trasferta between min_ore and max_ore ;
                    exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                    end;
                   when too_many_rows then
                    begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                     where  gestione  =app_gestione
                     and    contratto = '%'
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    p_quantita*24 between min_ore and max_ore
                      and    ore_trasferta between min_ore and max_ore ;
                    exception
                       when no_data_found then
                             p_errore := 'P00222';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                       when too_many_rows then
                             p_errore := 'P00223';
                             p_segnalazione := si4.get_error(p_errore);
                             raise esci;
                    end;
                 end;
             end;
            -- no_data_found % / app_contratto
           when no_data_found then
             begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
              where  gestione  ='%'
              and    contratto = '%'
              and    nvl(se_rimborso_alloggio,0) = flag_alloggio
              and    ore_trasferta between min_ore and max_ore ;
             exception
               when too_many_rows then
                begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                 and    nvl(se_rimborso_vitto,0)    = flag_vitto
                 and    ore_trasferta between min_ore and max_ore ;
                exception
                  when no_data_found then
                     begin
                       select perc_diaria
                       into   app_perc_diaria
                       from   regole_diaria
                       where  gestione  = '%'
                       and    contratto = '%'
                       and    nvl(se_rimborso_vitto,0)    = flag_vitto
                       and    p_quantita*24 between min_ore and max_ore
                       and    ore_trasferta between min_ore and max_ore;
                     exception
                      when no_data_found then
                            p_errore := 'P00222';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                      when too_many_rows then
                            p_errore := 'P00223';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                     end;
                  when too_many_rows then
                     begin
                       select perc_diaria
                       into   app_perc_diaria
                       from   regole_diaria
                       where  gestione  = '%'
                       and    contratto = '%'
                       and    nvl(se_rimborso_vitto,0)    =flag_vitto
                       and    p_quantita*24 between min_ore and max_ore
                       and    ore_trasferta between min_ore and max_ore ;
                     exception
                      when no_data_found then
                            p_errore := 'P00222';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                      when too_many_rows then
                            p_errore := 'P00223';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                     end;
                end;
               when no_data_found then
                begin
                 select perc_diaria
                 into   app_perc_diaria
                 from   regole_diaria
                 where  gestione  = '%'
                 and    contratto = '%'
                 and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                 and    nvl(se_rimborso_vitto,0)    = flag_vitto
                 and    ore_trasferta between min_ore and max_ore ;
                exception
                  when no_data_found then
                   begin
                     select perc_diaria
                     into   app_perc_diaria
                     from   regole_diaria
                     where  gestione  = '%'
                     and    contratto = '%'
                     and    nvl(se_rimborso_vitto,0)    = flag_vitto
                     and    p_quantita*24 between min_ore and max_ore
                     and    ore_trasferta between min_ore and max_ore ;
                   exception
                      when no_data_found then
                            p_errore := 'P00222';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                      when too_many_rows then
                            p_errore := 'P00223';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                   end;
                  when too_many_rows then
                   begin
                     select perc_diaria
                     into   app_perc_diaria
                     from   regole_diaria
                     where  gestione  = '%'
                     and    contratto = '%'
                     and    nvl(se_rimborso_vitto,0)    =flag_vitto
                     and    p_quantita*24 between min_ore and max_ore
                     and    ore_trasferta between min_ore and max_ore ;
                   exception
                      when no_data_found then
                            p_errore := 'P00222';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                      when too_many_rows then
                            p_errore := 'P00223';
                            p_segnalazione := si4.get_error(p_errore);
                            raise esci;
                   end;
                end;
             end;
           end;
     end;
-- too_many_rows con app_gestione/app_contratto--
    when too_many_rows then
     begin
       select perc_diaria
       into   app_perc_diaria
       from   regole_diaria
       where  gestione  =app_gestione
       and    contratto = app_contratto
       and    nvl(se_rimborso_alloggio,0) = flag_alloggio
       and    ore_trasferta between min_ore and max_ore ;
     exception
        when too_many_rows then
         begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  =app_gestione
            and    contratto = app_contratto
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    nvl(se_rimborso_vitto,0)    = flag_vitto
            and    ore_trasferta between min_ore and max_ore ;
         exception
           when no_data_found then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = app_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore ;
              exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
              end;
           when too_many_rows then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =app_gestione
                and    contratto = app_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore ;
              exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
              end;
         end;
        when no_data_found then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione  =app_gestione
          and    contratto = app_contratto
          and    nvl(se_rimborso_alloggio,0) = flag_alloggio
          and    nvl(se_rimborso_vitto,0)    = flag_vitto
          and    ore_trasferta between min_ore and max_ore ;
         exception
           when no_data_found then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
             where  gestione  =app_gestione
              and    contratto = app_contratto
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore;
            exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end;
           when too_many_rows then
            begin
              select perc_diaria
              into   app_perc_diaria
              from   regole_diaria
             where  gestione  =app_gestione
             and    contratto = app_contratto
              and    nvl(se_rimborso_vitto,0)    = flag_vitto
              and    p_quantita*24 between min_ore and max_ore
              and    ore_trasferta between min_ore and max_ore;
            exception
               when no_data_found then
                     p_errore := 'P00222';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
               when too_many_rows then
                     p_errore := 'P00223';
                     p_segnalazione := si4.get_error(p_errore);
                     raise esci;
            end;
         end;
     end;
   end;

     app_importo := round(p_importo*app_perc_diaria/100,2);

/* Controlla che l'importo non sia maggiore dell' importo massimale della tabella */
    /* LIMITI_IMPORTO_SPESA */
    BEGIN
     begin
       select importo_massimale
       into   app_imp_massimale
       from   limiti_importo_spesa
       where  tipo_spesa = app_tipo_spesa
        and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
        and    gestione  = app_gestione
        and    contratto = app_contratto
        and    qualifica = app_qualifica
        and    livello   = app_livello;
     exception
      when no_data_found then
        begin
         select importo_massimale
         into   app_imp_massimale
         from   limiti_importo_spesa
         where  tipo_spesa = app_tipo_spesa
          and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
          and    gestione  = '%'
          and    contratto = '%'
          and    qualifica = '%'
          and    livello   = '%';
        exception
          when no_data_found then app_imp_massimale:=null;
        end;
     end;

    if app_imp_massimale is not null and p_importo > app_imp_massimale then
       p_errore := 'P00225';
       p_segnalazione := si4.get_error(p_errore);
       raise esci;
    end if;
    END;

/* Calcola la percentuale maggiorazione */
    BEGIN
      begin
         select perc_maggiorazione
         into   app_perc_magg
         from   tipi_spesa tisp
         where  to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between tisp.dal and nvl(tisp.al,to_date('3333333','j'))
         and    tisp.tipo_spesa=app_tipo_spesa
         and    rownum=1;
      exception
         when no_data_found then
             app_perc_magg :=null;
      end;
        P_importo_magg := round(app_perc_magg * p_tariffa/100,2);
    END;

/* Determinazione del rirr_id */
     begin
       select RIRR_SQ.NEXTVAL
       into p_rirr_id
       from dual
        ;
     end;
/* Determinazione del progressivo */
      begin
       select 1
       into app_prog_4000
       from righe_richiesta_rimborso
       where progressivo = 4000
       and   riri_id= p_riri_id;
      exception
        when no_data_found then
             app_prog_4000:=0;
      end;

      if app_prog_4000   = 0 then
         p_progressivo := 4000;
      else
       BEGIN
         SELECT MAX(PROGRESSIVO)
         INTO app_progressivo
         FROM RIGHE_RICHIESTA_RIMBORSO
         WHERE RIRI_ID = p_riri_id
          AND   PROGRESSIVO BETWEEN 4000 AND 5000;
         if mod(app_progressivo,10) != 0 then
           p_progressivo := (ceil(app_progressivo/10)*10);
         else
           p_progressivo := ((ceil(app_progressivo/10)*10)+10);
         end if;
        if p_progressivo >= 5000 then
            p_errore := 'P00214';
             p_segnalazione := si4.get_error(p_errore);
             raise esci;
        end if;
       END;
      end if;

/* Inserimento record di diaria oraria */
      insert into righe_richiesta_rimborso
      ( rirr_id,
        riri_id,
        riferimento_riga,
        progressivo,
        tipo_spesa,
        tariffa,
        importo,
        quantita,
        importo_maggiorazione ,
        note,
        button_diaria,
        sede_del,
        anno_del,
        numero_del,
        risorsa_intervento,
        capitolo,
        articolo,
        conto,
        impegno,
        anno_impegno,
        sub_impegno,
        anno_sub_impegno,
        codice_siope)
        values
      ( p_rirr_id,
        p_riri_id,
        p_rirr_id,
        p_progressivo,
        app_tipo_spesa,
        p_tariffa,
        app_importo,
        p_quantita,
        p_importo_magg,
        'Indennita di diaria oraria del '||to_char(trunc(p_data_fine),'dd/mm/yyyy'),
        p_button_flag,
        app_sede_del,
        app_anno_del,
        app_numero_del,
        app_risorsa_intervento,
        app_capitolo,
        app_articolo,
        app_conto,
        app_impegno,
        app_anno_impegno,
        app_sub_impegno,
        app_anno_sub_impegno,
        app_codice_siope);
      end;
end if;
commit;
end;
exception WHEN ESCI THEN rollback;
END CALCOLO_DIARIA;

PROCEDURE CALCOLO_DIARIA_MANUALE  (p_data_inizio    in  date,
                                  p_data_fine       in  date,
                                  p_riri_id         in number,
                                  p_quantita        in number,
                                  p_tariffa         in number,
                                  p_form            in varchar2,
                                  p_gestione        in varchar2,
                                  p_contratto       in varchar2,
                                  p_data_documento  in date,
                                  p_importo         out number,
                                 p_errore          out varchar2,
                                  p_segnalazione    out varchar2) IS
/***************************************************************************************************
 NOME:        CALCOLO_DIARIA_MANUALE
 DESCRIZIONE: Propone l'importo come prodotto tra la quantita, la tariffa e la percentuale diaria
              rimborso dell'indennita diaria di missione
 PARAMETRI:   p_data_inizio    = data inizio trasferta
              p_data_fine      = data fine trasferta
              p_riri_id        = identificatvo di Righe_richieste_rimborso
              p_nome_form      = form da cui viene lanciata la procedura, se e la PMTCRIST,
                                 vengono trattati solo i record di vitto e alloggio con progressivo <5000;
                                 se e la PMTCCOUF invece vengono trattati quelli con progressivo >5000
              p_quantita       = quantita
              p_tariffa        = tariffa
 RITORNA:     --
 NOTE:        --
****************************************************************************************************/

flag_vitto                      number:=0;
flag_alloggio                   number:=0;
app_perc_diaria                 number;
ore_trasferta                   number;
esci             exception;
BEGIN
/* Calcolo della durata in ore della trsferta*/
  begin
   select (data_fine-data_inizio)*24
   into   ore_trasferta
   from richieste_rimborso
   where riri_id=p_riri_id;
  exception
   when no_data_found then ore_trasferta:=0;
  end;
   begin
    for cur_1 in
         (select distinct tipo_spesa
          from  righe_richiesta_rimborso
          where riri_id = p_riri_id
          and   data_documento = nvl(p_data_documento,data_documento)
          and   ((p_form= 'PMTCCOUF') or (p_form= 'PMTCRIST' and progressivo<5000))
         )
    loop
      begin
        select 1
        into   flag_alloggio
        from   tipi_spesa
        where  tipo_spesa=cur_1.tipo_spesa
        and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
        and    causale_spesa='AL';
      exception
       when no_data_found then null;
      end;
      begin
        select 1
        into   flag_vitto
        from   tipi_spesa
        where  tipo_spesa=cur_1.tipo_spesa
        and    to_date(to_char(p_data_inizio,'dd/mm/yyyy'),'dd/mm/yyyy') between dal and nvl(al,to_date('3333333','j'))
        and    causale_spesa='VI';
      exception
       when no_data_found then null;
      end;
   end loop; -- cur_1

     /* Determinazione della percentuale di diaria */
     begin
      select perc_diaria
      into   app_perc_diaria
      from   regole_diaria
      where  gestione = p_gestione
      and    contratto = p_contratto
      and    ore_trasferta between min_ore and max_ore ;
     exception
      --   no_data_found app_gestione/app_contratto
      when no_data_found then
       begin
        select perc_diaria
        into   app_perc_diaria
        from   regole_diaria
        where  gestione = p_gestione
        and    contratto = '%'
        and    ore_trasferta between min_ore and max_ore;
       exception
        -- too_many_rows con app_gestione/%--
        when too_many_rows then
        begin
         select perc_diaria
         into   app_perc_diaria
         from   regole_diaria
         where  gestione  =p_gestione
         and    contratto = '%'
         and    nvl(se_rimborso_alloggio,0) = flag_alloggio
         and    ore_trasferta between min_ore and max_ore ;
        exception
          when too_many_rows then
           begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  =p_gestione
            and    contratto = '%'
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    nvl(se_rimborso_vitto,0)    = flag_vitto
            and    ore_trasferta between min_ore and max_ore ;
           exception
             when no_data_found then
                begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  =p_gestione
                  and    contratto = '%'
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    p_quantita*24 between min_ore and max_ore
                  and    ore_trasferta between min_ore and max_ore ;
                exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                end;
             when too_many_rows then
                begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  =p_gestione
                  and    contratto = '%'
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    p_quantita*24 between min_ore and max_ore
                  and    ore_trasferta between min_ore and max_ore ;
                exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
              end;
           end;
          when no_data_found then
           begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  =p_gestione
            and    contratto = '%'
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    nvl(se_rimborso_vitto,0)    = flag_vitto
            and    ore_trasferta between min_ore and max_ore;
           exception
             when no_data_found then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =p_gestione
                and    contratto ='%'
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
              end;
             when too_many_rows then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
               where  gestione  =p_gestione
               and    contratto = '%'
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
              end;
           end;
        end;
        -- no_data_found app_gestione / % --
        when no_data_found then
         begin
          select perc_diaria
          into   app_perc_diaria
          from   regole_diaria
          where  gestione = '%'
          and    contratto = p_contratto
          and    ore_trasferta between min_ore and max_ore;
         exception
          -- too_many_rows % / app_contratto
         when too_many_rows then
           begin
             select perc_diaria
             into   app_perc_diaria
             from   regole_diaria
             where  gestione  ='%'
             and    contratto = p_contratto
             and    nvl(se_rimborso_alloggio,0) = flag_alloggio
             and    ore_trasferta between min_ore and max_ore;
           exception
              when too_many_rows then
               begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  ='%'
                and    contratto = p_contratto
                and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    ore_trasferta between min_ore and max_ore ;
               exception
                 when no_data_found then
                    begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                      where  gestione  ='%'
                      and    contratto = p_contratto
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    p_quantita*24 between min_ore and max_ore
                      and    ore_trasferta between min_ore and max_ore;
                    exception
                     when no_data_found then
                           p_errore := 'P00222';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                     when too_many_rows then
                           p_errore := 'P00223';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                    end;
                 when too_many_rows then
                    begin
                      select perc_diaria
                      into   app_perc_diaria
                      from   regole_diaria
                      where  gestione  ='%'
                      and    contratto = p_contratto
                      and    nvl(se_rimborso_vitto,0)    = flag_vitto
                      and    p_quantita*24 between min_ore and max_ore
                      and    ore_trasferta between min_ore and max_ore;
                    exception
                     when no_data_found then
                           p_errore := 'P00222';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                     when too_many_rows then
                           p_errore := 'P00223';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                    end;
               end;
              when no_data_found then
               begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
                where  gestione  =p_gestione
                and    contratto = '%'
                and    nvl(se_rimborso_alloggio,0) = flag_alloggio
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    ore_trasferta between min_ore and max_ore;
               exception
                 when no_data_found then
                  begin
                    select perc_diaria
                    into   app_perc_diaria
                    from   regole_diaria
                   where  gestione  =p_gestione
                    and    contratto = '%'
                    and    nvl(se_rimborso_vitto,0)    = flag_vitto
                    and    p_quantita*24 between min_ore and max_ore
                    and    ore_trasferta between min_ore and max_ore;
                  exception
                     when no_data_found then
                           p_errore := 'P00222';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                     when too_many_rows then
                           p_errore := 'P00223';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                  end;
                 when too_many_rows then
                  begin
                    select perc_diaria
                    into   app_perc_diaria
                    from   regole_diaria
                   where  gestione  =p_gestione
                   and    contratto = '%'
                    and    nvl(se_rimborso_vitto,0)    = flag_vitto
                    and    p_quantita*24 between min_ore and max_ore
                    and    ore_trasferta between min_ore and max_ore ;
                  exception
                     when no_data_found then
                           p_errore := 'P00222';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                     when too_many_rows then
                           p_errore := 'P00223';
                           p_segnalazione := si4.get_error(p_errore);
                           raise esci;
                  end;
               end;
           end;
          -- no_data_found % / app_contratto
         when no_data_found then
           begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  ='%'
            and    contratto = '%'
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    ore_trasferta between min_ore and max_ore;
           exception
             when too_many_rows then
              begin
               select perc_diaria
               into   app_perc_diaria
               from   regole_diaria
               where  gestione  = '%'
               and    contratto = '%'
               and    nvl(se_rimborso_alloggio,0) = flag_alloggio
               and    nvl(se_rimborso_vitto,0)    = flag_vitto
               and    ore_trasferta between min_ore and max_ore;
              exception
                when no_data_found then
                   begin
                     select perc_diaria
                     into   app_perc_diaria
                     from   regole_diaria
                     where  gestione  = '%'
                     and    contratto = '%'
                     and    nvl(se_rimborso_vitto,0)    = flag_vitto
                     and    p_quantita*24 between min_ore and max_ore
                     and    ore_trasferta between min_ore and max_ore ;
                   exception
                    when no_data_found then
                          p_errore := 'P00222';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                    when too_many_rows then
                          p_errore := 'P00223';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                  end;
                when too_many_rows then
                   begin
                     select perc_diaria
                     into   app_perc_diaria
                     from   regole_diaria
                     where  gestione  = '%'
                     and    contratto = '%'
                     and    nvl(se_rimborso_vitto,0)    =flag_vitto
                     and    p_quantita*24 between min_ore and max_ore
                     and    ore_trasferta between min_ore and max_ore ;
                   exception
                    when no_data_found then
                          p_errore := 'P00222';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                    when too_many_rows then
                          p_errore := 'P00223';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                   end;
              end;
             when no_data_found then
              begin
               select perc_diaria
               into   app_perc_diaria
               from   regole_diaria
               where  gestione  = '%'
               and    contratto = '%'
               and    nvl(se_rimborso_alloggio,0) = flag_alloggio
               and    nvl(se_rimborso_vitto,0)    = flag_vitto
               and    ore_trasferta between min_ore and max_ore ;
              exception
                when no_data_found then
                 begin
                   select perc_diaria
                   into   app_perc_diaria
                   from   regole_diaria
                   where  gestione  = '%'
                   and    contratto = '%'
                   and    nvl(se_rimborso_vitto,0)    = flag_vitto
                   and    p_quantita*24 between min_ore and max_ore
                   and    ore_trasferta between min_ore and max_ore ;
                 exception
                    when no_data_found then
                          p_errore := 'P00222';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                    when too_many_rows then
                          p_errore := 'P00223';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                 end;
                when too_many_rows then
                 begin
                   select perc_diaria
                   into   app_perc_diaria
                   from   regole_diaria
                   where  gestione  = '%'
                   and    contratto = '%'
                   and    nvl(se_rimborso_vitto,0)    =flag_vitto
                   and    p_quantita*24 between min_ore and max_ore
                   and    ore_trasferta between min_ore and max_ore ;
                 exception
                    when no_data_found then
                          p_errore := 'P00222';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                    when too_many_rows then
                          p_errore := 'P00223';
                          p_segnalazione := si4.get_error(p_errore);
                          raise esci;
                 end;
              end;
           end;
         end;
       end;
    -- too_many_rows con app_gestione/app_contratto--
      when too_many_rows then
       begin
         select perc_diaria
         into   app_perc_diaria
         from   regole_diaria
         where  gestione  =p_gestione
         and    contratto = p_contratto
         and    nvl(se_rimborso_alloggio,0) = flag_alloggio
         and    ore_trasferta between min_ore and max_ore ;
       exception
          when too_many_rows then
            begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  =p_gestione
            and    contratto = p_contratto
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    nvl(se_rimborso_vitto,0)    = flag_vitto
            and    ore_trasferta between min_ore and max_ore ;
           exception
             when no_data_found then
                begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  =p_gestione
                  and    contratto = p_contratto
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    p_quantita*24 between min_ore and max_ore
                  and    ore_trasferta between min_ore and max_ore;
                exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                end;
             when too_many_rows then
                begin
                  select perc_diaria
                  into   app_perc_diaria
                  from   regole_diaria
                  where  gestione  =p_gestione
                  and    contratto = p_contratto
                  and    nvl(se_rimborso_vitto,0)    = flag_vitto
                  and    p_quantita*24 between min_ore and max_ore
                  and    ore_trasferta between min_ore and max_ore;
                exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                end;
           end;
          when no_data_found then
           begin
            select perc_diaria
            into   app_perc_diaria
            from   regole_diaria
            where  gestione  =p_gestione
            and    contratto = p_contratto
            and    nvl(se_rimborso_alloggio,0) = flag_alloggio
            and    nvl(se_rimborso_vitto,0)    = flag_vitto
            and    ore_trasferta between min_ore and max_ore;
           exception
             when no_data_found then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
               where  gestione  =p_gestione
                and    contratto = p_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore ;
              exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
              end;
             when too_many_rows then
              begin
                select perc_diaria
                into   app_perc_diaria
                from   regole_diaria
               where  gestione  =p_gestione
               and    contratto = p_contratto
                and    nvl(se_rimborso_vitto,0)    = flag_vitto
                and    p_quantita*24 between min_ore and max_ore
                and    ore_trasferta between min_ore and max_ore;
              exception
                 when no_data_found then
                       p_errore := 'P00222';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
                 when too_many_rows then
                       p_errore := 'P00223';
                       p_segnalazione := si4.get_error(p_errore);
                       raise esci;
              end;
           end;
       end;
     end;

    p_importo := round(p_quantita*p_tariffa*app_perc_diaria/100,2);
   end;
 exception WHEN ESCI THEN null;
END CALCOLO_DIARIA_MANUALE;

PROCEDURE AGGIORNA_STATO                  (p_stato_richiesta in  varchar2,
                                           p_riri_id         in  number,
                                           p_data_distinta   in  date,
                                           p_numero_distinta in  number,
                                           p_errore          out varchar2,
                                           p_segnalazione    out varchar2) IS
/***************************************************************************************************
 NOME:        AGGIORNA_STATO
 DESCRIZIONE:   aggiorna  i record di RICHIESTE_RIMBORSO con estremi della distinta
                uguali a quelli selezionati e il campo INPUT di DEPOSITO_VARIABILI_ECONOMICHE
                uguale al codice del modulo della procedura Missioni e Trasferte.
                Elimina i record di DEPOSITO_VARIABILI_ECONOMICHE con data_acquisizione nulla
                 ed input uguale al codice del modulo della procedura Missioni e Trasferte
 PARAMETRI:    p_stato_richiesta     : stato della richiesta
               p_riri_id             : riri_id
 RITORNA:     --
 NOTE:        --
****************************************************************************************************/
BEGIN
 begin
 -- Primo step :aggiorna  i record di RICHIESTE_RIMBORSO con estremi della distinta
 --             uguali a quelli selezionati e il campo INPUT di DEPOSITO_VARIABILI_ECONOMICHE
 --             uguale al codice del modulo della procedura Missioni e Trasferte
 if p_stato_richiesta = '7'      then
    update richieste_rimborso    set
          stato_richiesta       = '6',
         riferimento_economico = null
   where  riri_id               = p_riri_id;
 end if;

 -- Secondo step : Elimina i record di DEPOSITO_VARIABILI_ECONOMICHE con data_acquisizione nulla
 --                ed input uguale al codice del modulo della procedura Missioni e Trasferte
 delete from deposito_variabili_economiche
 where  input='PMT'
 and    data_acquisizione is null
 and    distinta               = p_numero_distinta
 and    trunc(data_distinta)        = p_data_distinta
;      
 commit;
 end;

END AGGIORNA_STATO;

PROCEDURE PASSAGGIO_ECONOMICO             (p_flag_arr        in  number,
                                           p_data_distinta   in  date,
                                           p_numero_distinta in  number,
                                           p_stato_richiesta in  varchar2,
                                           p_riri_id         in  number,
                                           p_sysdate         in  date,
                                           p_utente          in  varchar2,
                                           p_errore          out varchar2,
                                           p_segnalazione    out varchar2) IS
/***************************************************************************************************
 NOME:        PASSAGGIO_ECONOMICO
 DESCRIZIONE:  Gestisce il vero e proprio passaggio all'economico
               analizzando i record con cod_record in (2,3), stato_ricchiesta= '6' e riferimento_economico nullo
 PARAMETRI:   p_flag_arr            : gestisce come arretrati gli eventuali storni
              p_data_distinta       : data della distinta
              p_numero_distinta     : numero della distinta
              p_stato_richiesta     : stato della richiesta
 RITORNA:     --
 NOTE:        --
****************************************************************************************************/
max_data_inizio             date;
app_deve_id                 number;
app_arr                     varchar2(1);
app_voce_economica_acconto  varchar2(10);
app_sub_acconto             varchar2(2);
app                         varchar(1);

BEGIN
/* begin
  select max(data_inizio)
  into   max_data_inizio
  from   richieste_rimborso
  where  trunc(data_distinta)   = p_data_distinta
  and    numero_distinta = p_numero_distinta  
;     
 end;
*/
 for cur in
     (select  riri.ci,
              voce_economica,
              voec.classe classe,
              sub,
              rrri.tariffa tariffa,
              nvl(sum(quantita),0)  quantita,
              nvl(sum(decode(nvl(tisp.se_liquidabile,0),0,0,rrri.importo)),0)+nvl(sum(rrri.importo_maggiorazione),0) importo,
              0 importo_acconto,
              cod_record,
              rrri.anno_del,
              rrri.numero_del,
              rrri.sede_del,
              rrri.risorsa_intervento,
              rrri.capitolo,
              rrri.articolo,
              rrri.conto,
              rrri.impegno,
              rrri.anno_impegno,
              rrri.sub_impegno,
              rrri.anno_sub_impegno,
              rrri.codice_siope
      from   richieste_rimborso riri,
             righe_richiesta_rimborso rrri,
             tipi_spesa tisp,
             parametri_missioni pami,
             voci_economiche    voec
        where  trunc(data_distinta)       = p_data_distinta
          and    numero_distinta     = p_numero_distinta
          and    riri.riri_id        = rrri.riri_id
          and    tisp.tipo_spesa     = rrri.tipo_spesa
          and    tisp.voce_economica = voec.codice
          and    riri.data_inizio between tisp.dal and nvl(tisp.al,to_date('3333333','j'))
      group by  riri.ci,
                data_distinta,
                numero_distinta,
                rrri.anno_del  ,
                rrri.sede_del , 
                rrri.numero_del   ,
                rrri.risorsa_intervento   ,
                rrri.capitolo         ,   
                rrri.articolo         ,   
                rrri.conto            ,      
                rrri.impegno            ,      
                rrri.anno_impegno      ,
                rrri.sub_impegno         ,
                rrri.anno_sub_impegno   ,
                rrri.codice_siope      ,  
                voce_economica,
                sub,
                rrri.tariffa,
                decode(nvl(1,0),1,riri.sequenza,null),
                cod_record,
                voec.classe
      union
      select  riri.ci,
              '0',
              '0',
              '0',
              0 tariffa,
              0  quantita,
              0 importo,
              decode(max(pami.SEGNO_ACCONTO_IN_EC ), '-',
              nvl(decode(nvl(max(pami.se_gestione_acconti),0),0,nvl(sum(riri.importo_acconto),0),nvl(acer.importo,0)),0)*-1,
              nvl(decode(nvl(max(pami.se_gestione_acconti),0),0,nvl(sum(riri.importo_acconto),0),nvl(acer.importo,0)),0)     ) importo_acconto,
              cod_record,
              riri.anno_del,
              riri.numero_del,
              riri.sede_del,
              riri.risorsa_intervento,
              riri.capitolo,
              riri.articolo,
              riri.conto,
              riri.impegno,
              riri.anno_impegno,
              riri.sub_impegno,
              riri.anno_sub_impegno,
              riri.codice_siope
      from   richieste_rimborso riri,
             parametri_missioni pami,
             acconti_erogati acer
      where  trunc(data_distinta)   = p_data_distinta
      and    numero_distinta = p_numero_distinta
     and    acer.ci             (+) = riri.ci
      and    acer.data_acconto   (+) = riri.data_acconto
      and    acer.numero_acconto (+) = riri.numero_acconto
      group by riri.ci,
              data_distinta,
              numero_distinta,
              anno_del  ,
              sede_del , 
              numero_del   ,
              risorsa_intervento   ,
              capitolo         ,   
              articolo         ,   
              conto            ,      
              impegno            ,      
              anno_impegno      ,
              sub_impegno         ,
              anno_sub_impegno   ,
              codice_siope      ,  
              '0',
              '0',
              0,
              decode(nvl(1,0),1,riri.sequenza,null),
              cod_record,
              acer.importo      )
     loop
      begin
        begin
          select max(data_inizio)
          into   max_data_inizio
          from   richieste_rimborso
          where  trunc(data_distinta)   = p_data_distinta
          and    numero_distinta        = p_numero_distinta 
          and    ci =cur.ci 
            ;     
        end;
        if p_flag_arr = '1' and cur.cod_record=3 then
           app_arr    := 'C';
        else
           app_arr    :=null;
        end if;
        if cur.importo!=0 then
         begin
          select GP4MT_DEVE_ID.NEXTVAL
          into   app_deve_id
          from   dual;
         end;
          if cur.classe in ('Q','C','R') then
           insert into deposito_variabili_economiche
           (input,
            riferimento,
            deve_id,
            ci,
            voce,
            sub,
            arr,
            tar,
            qta,
            imp,
            data_inserimento,
            utente_inserimento,
            data_distinta,
            distinta,
            anno_del,
            numero_del,
            sede_del,
            risorsa_intervento,
            capitolo,
            articolo,
            conto,
            impegno,
            anno_impegno,
            sub_impegno,
            anno_sub_impegno,
            codice_siope
            )
           values
            ('PMT',
              max_data_inizio,
              app_deve_id,
              cur.ci,
              cur.voce_economica,
              cur.sub,
              app_arr,
              cur.tariffa,
              cur.quantita,
              cur.importo,
              p_sysdate,
              p_utente,
              p_data_distinta,
              p_numero_distinta,
              cur.anno_del,
              cur.numero_del,
              cur.sede_del,
              cur.risorsa_intervento,
              cur.capitolo,
              cur.articolo,
              cur.conto,
              cur.impegno,
              cur.anno_impegno,
              cur.sub_impegno,
              cur.anno_sub_impegno,
              cur.codice_siope
              )
           ;
          elsif cur.classe in ('B','P','V')  then
            insert into deposito_variabili_economiche
             (input,
              riferimento,
              deve_id,
              ci,
              voce,
              sub,
              arr,
              tar,
              qta,
              imp,
              data_inserimento,
              utente_inserimento,
              data_distinta,
              distinta,
              anno_del,
              numero_del,
              sede_del,
              risorsa_intervento,
              capitolo,
              articolo,
              conto,
              impegno,
              anno_impegno,
              sub_impegno,
              anno_sub_impegno,
              codice_siope
              )
             values
              ('PMT',
                max_data_inizio,
                app_deve_id,
                cur.ci,
                cur.voce_economica,
                cur.sub,
                app_arr,
                null,
                null,
                cur.importo,
                p_sysdate,
                p_utente,
                p_data_distinta,
                p_numero_distinta,
                cur.anno_del,
                cur.numero_del,
                cur.sede_del,
                cur.risorsa_intervento,
                cur.capitolo,
                cur.articolo,
                cur.conto,
                cur.impegno,
                cur.anno_impegno,
                cur.sub_impegno,
                cur.anno_sub_impegno,
                cur.codice_siope )
             ;
          else
            insert into deposito_variabili_economiche
             (input,
              riferimento,
              deve_id,
              ci,
              voce,
              sub,
              arr,
              tar,
              qta,
              imp,
              data_inserimento,
              utente_inserimento,
              data_distinta,
              distinta,
              anno_del,
              numero_del,
              sede_del,
              risorsa_intervento,
              capitolo,
              articolo,
              conto,
              impegno,
              anno_impegno,
              sub_impegno,
              anno_sub_impegno,
              codice_siope)
             values
              ('PMT',
                max_data_inizio,
                app_deve_id,
                cur.ci,
                cur.voce_economica,
                cur.sub,
                app_arr,
                cur.tariffa,
                cur.quantita,
                cur.importo,
                p_sysdate,
                p_utente,
                p_data_distinta,
                p_numero_distinta,
                cur.anno_del,
                cur.numero_del,
                cur.sede_del,
                cur.risorsa_intervento,
                cur.capitolo,
                cur.articolo,
                cur.conto,
                cur.impegno,
                cur.anno_impegno,
                cur.sub_impegno,
                cur.anno_sub_impegno,
                cur.codice_siope )
             ;
          end if;
        end if;
        if cur.importo_acconto != 0 then
           begin
            select voce_economica_acconto
            into   app_voce_economica_acconto
            from   parametri_missioni;
           exception
            when no_data_found then  app_voce_economica_acconto:= null;
           end;

           begin
            select sub_acconto
            into   app_sub_acconto
            from   parametri_missioni;
           exception
            when no_data_found then  app_sub_acconto:= null;
           end;
          begin
            select 'x'
            into   app
            from deposito_variabili_economiche deve
                                 where  ci = cur.ci
                                 and    riferimento=max_data_inizio
                                 and    voce =app_voce_economica_acconto
                                 and    sub  =app_sub_acconto
                                 and    imp  =cur.importo_acconto
                                 and    input ='PMT';
            raise too_many_rows ;
          exception
               when no_data_found then
                 begin
                  select GP4MT_DEVE_ID.NEXTVAL
                  into   app_deve_id
                  from   dual;
                 end;
                   
                 insert into deposito_variabili_economiche
                 (input,
                  riferimento,
                  deve_id,
                  ci,
                  voce,
                  sub,
                  arr,
                  imp,
                  data_inserimento,
                  utente_inserimento,
                  data_distinta,
                  distinta,
                  anno_del,
                  numero_del,
                  sede_del,
                  risorsa_intervento,
                  capitolo,
                  articolo,
                  conto,
                  impegno,
                  anno_impegno,
                  sub_impegno,
                  anno_sub_impegno,
                  codice_siope)
                   select
                  'PMT',
                    max_data_inizio,
                    app_deve_id,
                    cur.ci,
                    app_voce_economica_acconto,
                    app_sub_acconto,
                    app_arr,
                    cur.importo_acconto,
                    p_sysdate,
                    p_utente,
                    p_data_distinta,
                    p_numero_distinta,
                    cur.anno_del,
                    cur.numero_del,
                    cur.sede_del,
                    cur.risorsa_intervento,
                    cur.capitolo,
                    cur.articolo,
                    cur.conto,
                    cur.impegno,
                    cur.anno_impegno,
                    cur.sub_impegno,
                    cur.anno_sub_impegno,
                    cur.codice_siope
               from dual
                   ;
               when too_many_rows then null;
          end;
        end if;

      end;
    end loop; -- CUR
commit;
END PASSAGGIO_ECONOMICO    ;

END GP4MT;

/* End Package Body: GP4MT */
/
