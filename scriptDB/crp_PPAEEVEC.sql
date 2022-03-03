create or replace package ppaeevec is
   /******************************************************************************
    NOME:          PPAEEVEC
    DESCRIZIONE:   Estrazione eventi da Assenze-Presenze per Economico-Contabile.
                   Questa fase determina le voci contabili degli eventi di presenza e assen-
                   za in base alla definizione delle Causali. La fase produce un archivio
                   di appoggio in cui vengono registrate le voci relavite a eventi indivi-
                   duali (Eventi_Presenza), eventi a classe (Valori_Presenza) e totalizza-
                   zioni di eventi (Totalizzazione_Causali).
                   Include le precedenti funzioni del PECCEVPA (passaggio da DEEC  a MOCO)
   
    Rev. Data       Autore Descrizione
    ---- ---------- ------ --------------------------------------------------------
    1    22/01/2003
    2    13/05/2005 GM
    2.1  27/03/2007 MM     A5473
   ******************************************************************************/
   function versione return varchar2;
   procedure main
   (
      prenotazione in number
     ,passo        in number
   );
end;
/
create or replace package body ppaeevec is
   function versione return varchar2 is
   begin
      return 'V2.1 del 27/03/2007';
   end versione;
   procedure main
   (
      prenotazione in number
     ,passo        in number
   ) is
   begin
      declare
         d_errore         varchar2(6);
         d_variabili_gape number(1);
         d_variabili_gepe number(1);
         d_ini_mes        date;
         d_fin_mes        date;
         d_anno           riferimento_retribuzione.anno%type;
         d_mese           riferimento_retribuzione.mese%type;
         d_mensilita      riferimento_retribuzione.mensilita%type;
         d_ini_ela        riferimento_retribuzione.ini_ela%type;
         d_fin_ela        riferimento_retribuzione.fin_ela%type;
         d_opzione_valore varchar2(1);
         d_opzione_arr    varchar2(1);
         d_segnalazione   number;
         errore exception;
      begin
         /*
                   +--------------------------------------------------------+
                   | Memorizzazione parametri (limite riferimento per la e- |
                   | strazione valorizzazioni causali. Proveniente da EEVEC |
                   +--------------------------------------------------------+
         */
         begin
            select para.valore
              into d_opzione_valore
              from a_parametri para
             where para.no_prenotazione = prenotazione
               and para.parametro = 'P_OPZIONE';
         exception
            when no_data_found then
               d_opzione_valore := 'P';
         end;
         /*
                   +--------------------------------------------------------+
                   | Memorizzazione parametri (attivazione arretrato C per  |
                   | tutte le voci riferite all'anno precedente) ex CEVPA   |
                   +--------------------------------------------------------+
         */
         begin
            select para.valore
              into d_opzione_arr
              from a_parametri para
             where para.no_prenotazione = prenotazione
               and para.parametro = 'P_ARRETRATO';
         exception
            when no_data_found then
               d_opzione_arr := '';
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
         /*
                   +-------------------------------------------------------+
                   | Memorizzazione variabili_gape da tabella ENTE.        |
                   +-------------------------------------------------------+
         */
         begin
            select nvl(ente.variabili_gape, 0)
                  ,nvl(ente.variabili_gepe, 0)
              into d_variabili_gape
                  ,d_variabili_gepe
              from ente
             where ente_id = 'ENTE';
         exception
            when too_many_rows then
               d_errore := 'A00003';
               raise errore;
            when no_data_found then
               d_errore := 'P00531';
               raise errore;
         end;
         /*
                   +-------------------------------------------------------+
                   | Controllo che il Riferimento Presenze sia esattamente |
                   | la differenza tra il Riferimento Retribuzione ed il   |
                   | numero dei mesi in variabili_gape della tabella ENTE. |
                   +-------------------------------------------------------+
         */
         begin
            select 'P07401'
              into d_errore
              from riferimento_retribuzione rire
                  ,riferimento_presenza     ripa
             where ripa.ripa_id = 'RIPA'
               and rire.rire_id = 'RIRE'
               and add_months(ripa.fin_mes, nvl(d_variabili_gape, 0)) != rire.fin_ela;
            raise too_many_rows;
         exception
            when too_many_rows then
               raise errore;
            when no_data_found then
               null;
         end;
         /*
                   +--------------------------------------------------------+
                   | Memorizzazione dati del periodo di riferimento della   |
                   | gestione economica.                                    |
                   +--------------------------------------------------------+
         */
         begin
            select anno
                  ,mese
                  ,mensilita
                  ,ini_ela
                  ,fin_ela
              into d_anno
                  ,d_mese
                  ,d_mensilita
                  ,d_ini_ela
                  ,d_fin_ela
              from riferimento_retribuzione
             where rire_id = 'RIRE';
         exception
            when no_data_found then
               d_errore := 'P05140';
               raise errore;
         end;
         /*
                   +-------------------------------------------------------+
                   | Pulizia tabella DEPOSITO_EVENTI_EC.                   |
                   +-------------------------------------------------------+
         */
         begin
            delete from deposito_eventi_ec;
         end;
         /*
                   +-------------------------------------------------------+
                   | Inserimento movimenti da EVENTI_PRESENZA eventi non a |
                   | Classe.                                               |
                   +-------------------------------------------------------+
         */
         for curs in (select distinct ci from rapporti_presenza where flag_ec = 'M')
         loop
            begin
               insert into deposito_eventi_ec
                  (ci
                  ,voce
                  ,sub
                  ,riferimento
                  ,arr
                  ,gestione
                  ,input
                  ,qta
                  ,tar
                  ,imp
                  ,delibera)
                  select evpa.ci
                        ,caev.voce
                        ,caev.sub
                        ,evpa.al
                        ,decode(to_number(to_char(evpa.al, 'yyyy'))
                               ,ripa.anno
                               ,decode(sign(to_number(to_char(evpa.al, 'mm')) -
                                            ripa.mese)
                                      ,-1
                                      ,'C'
                                      ,null)
                               ,'C')
                        ,caev.gestione
                        ,'Q'
                        ,decode(caev.gestione
                               ,'O'
                               ,round(evpa.valore / 60, 2)
                               ,'H'
                               ,round(evpa.valore / 60, 2)
                               ,'G'
                               ,evpa.valore
                               ,'N'
                               ,evpa.valore
                               ,'P'
                               ,evpa.valore
                               ,null)
                        ,null
                        ,decode(caev.gestione, 'I', evpa.valore, null)
                        ,caev.classe_delibera
                    from ente                 ente
                        ,riferimento_presenza ripa
                        ,rapporti_presenza    rapa
                        ,causali_evento       caev
                        ,eventi_presenza      evpa
                   where ente.ente_id = 'ENTE'
                     and ripa.ripa_id = 'RIPA'
                     and rapa.ci = evpa.ci
                     and evpa.ci = curs.ci
                     and evpa.dal between rapa.dal and
                         nvl(rapa.al, to_date('3333333', 'j'))
                     and rapa.flag_ec = 'M'
                     and caev.codice = evpa.causale
                     and caev.voce is not null
                     and evpa.input != 'V'
                     and evpa.riferimento <=
                         add_months(ripa.fin_mes, nvl(ente.variabili_gape, 0))
                     and (to_date(to_char(evpa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') =
                         ripa.fin_mes or
                         to_date(to_char(evpa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') <=
                         ripa.fin_mes and
                         nvl(evpa.al, to_date('3333333', 'j')) >=
                         add_months(ripa.fin_mes, nvl(ente.variabili_gape, 0)));
               /*
                         +-------------------------------------------------------+
                         | Inserimento movimenti da EVENTI_PRESENZA eventi a va- |
                         | lore attribuiti a classe.                             |
                         +-------------------------------------------------------+
               */
               insert into deposito_eventi_ec
                  (ci
                  ,voce
                  ,sub
                  ,riferimento
                  ,arr
                  ,gestione
                  ,input
                  ,qta
                  ,tar
                  ,imp
                  ,delibera)
                  select evpa.ci
                        ,vapa.voce
                        ,vapa.sub
                        ,evpa.riferimento
                        ,max(decode(to_number(to_char(add_months(evpa.dal
                                                                ,d_variabili_gape)
                                                     ,'yyyy'))
                                   ,ripa.anno
                                   ,decode(sign(to_number(to_char(add_months(evpa.dal
                                                                            ,d_variabili_gape)
                                                                 ,'mm')) - ripa.mese)
                                          ,-1
                                          ,'C'
                                          ,null)
                                   ,'C'))
                        ,'V'
                        ,'V'
                        ,sum(vapa.qta)
                        ,null
                        ,sum(vapa.imp)
                        ,max(caev.classe_delibera)
                    from ente                 ente
                        ,riferimento_presenza ripa
                        ,rapporti_presenza    rapa
                        ,causali_evento       caev
                        ,eventi_presenza      evpa
                        ,valori_presenza      vapa
                   where ente.ente_id = 'ENTE'
                     and ripa.ripa_id = 'RIPA'
                     and rapa.ci = evpa.ci
                     and evpa.ci = curs.ci
                     and evpa.dal between rapa.dal and
                         nvl(rapa.al, to_date('3333333', 'j'))
                     and rapa.flag_ec = 'M'
                     and evpa.evento = vapa.evento
                     and caev.codice = evpa.causale
                     and evpa.input = 'V'
                     and evpa.dal <=
                         add_months(ripa.fin_mes
                                   ,decode(d_opzione_valore
                                          ,'P'
                                          ,0
                                          ,nvl(ente.variabili_gape, 0)))
                     and (to_date(to_char(vapa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') =
                         ripa.fin_mes or
                         to_date(to_char(vapa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') <=
                         ripa.fin_mes and
                         nvl(evpa.al, to_date('3333333', 'j')) >=
                         add_months(ripa.ini_mes
                                    ,decode(d_opzione_valore
                                           ,'P'
                                           ,0
                                           ,nvl(ente.variabili_gape, 0))))
                   group by evpa.ci
                           ,vapa.voce
                           ,vapa.sub
                           ,evpa.riferimento
                  having nvl(sum(vapa.qta), 0) + nvl(sum(vapa.imp), 0) != 0;
            
               /*
                         +-------------------------------------------------------+
                         | Aggiornamento operazione sulle voci di valori_presen- |
                         | za trattati precedentemente.                          |
                         +-------------------------------------------------------+
               */
               update valori_presenza
                  set operazione = 'A'
                where rowid in
                      (select vapa.rowid
                         from ente                 ente
                             ,riferimento_presenza ripa
                             ,rapporti_presenza    rapa
                             ,causali_evento       caev
                             ,eventi_presenza      evpa
                             ,valori_presenza      vapa
                        where ente.ente_id = 'ENTE'
                          and ripa.ripa_id = 'RIPA'
                          and rapa.ci = evpa.ci
                          and evpa.ci = curs.ci
                          and evpa.dal between rapa.dal and
                              nvl(rapa.al, to_date('3333333', 'j'))
                          and rapa.flag_ec = 'M'
                          and evpa.evento = vapa.evento
                          and vapa.operazione != 'A'
                          and caev.codice = evpa.causale
                          and evpa.input = 'V'
                          and evpa.dal <=
                              add_months(ripa.fin_mes
                                        ,decode(d_opzione_valore
                                               ,'P'
                                               ,0
                                               ,nvl(ente.variabili_gape, 0)))
                          and (to_date(to_char(evpa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') =
                              ripa.fin_mes or
                              to_date(to_char(evpa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') <=
                              ripa.fin_mes and
                              nvl(evpa.al, to_date('3333333', 'j')) >=
                              add_months(ripa.fin_mes
                                         ,decode(d_opzione_valore
                                                ,'P'
                                                ,0
                                                ,nvl(ente.variabili_gape, 0)))));
            end;
         end loop;
      
         /*
                   +-------------------------------------------------------+
                   | Scrive segnalazione di errore per le causali presenti |
                   | su EVPA ma prive di voce economica                    |
                   +-------------------------------------------------------+
         */
      
         for causali in (select distinct evpa.causale
                                        ,caev.descrizione
                           from ente                 ente
                               ,riferimento_presenza ripa
                               ,rapporti_presenza    rapa
                               ,causali_evento       caev
                               ,eventi_presenza      evpa
                          where ente.ente_id = 'ENTE'
                            and ripa.ripa_id = 'RIPA'
                            and rapa.ci = evpa.ci
                            and evpa.dal between rapa.dal and
                                nvl(rapa.al, to_date('3333333', 'j'))
                            and rapa.flag_ec = 'M'
                            and caev.codice = evpa.causale
                            and caev.voce is null
                            and evpa.input != 'V'
                            and evpa.riferimento <=
                                add_months(ripa.fin_mes, nvl(ente.variabili_gape, 0))
                            and (to_date(to_char(evpa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') =
                                ripa.fin_mes or
                                to_date(to_char(evpa.data_agg, 'ddmmyyyy'), 'ddmmyyyy') <=
                                ripa.fin_mes and
                                nvl(evpa.al, to_date('3333333', 'j')) >=
                                add_months(ripa.fin_mes, nvl(ente.variabili_gape, 0))))
         loop
            select evpa_sq.nextval into d_segnalazione from dual;
            insert into a_segnalazioni_errore
               (no_prenotazione
               ,passo
               ,progressivo
               ,errore
               ,precisazione)
            values
               (prenotazione
               ,2
               ,d_segnalazione
               ,'P07030'
               ,substr(' - Causale: ' || causali.causale || ' - ' || causali.descrizione
                      ,1
                      ,50));
         end loop;
      
         for curs2 in (select codice categoria
                         from categorie_evento
                        where voce is not null)
         loop
            begin
               /*
                         +--------------------------------------------------------+
                         | Emissione voci totalizzate per categoria               |
                         +--------------------------------------------------------+
               */
               insert into deposito_eventi_ec
                  (ci
                  ,voce
                  ,sub
                  ,riferimento
                  ,arr
                  ,gestione
                  ,input
                  ,qta
                  ,tar
                  ,imp
                  ,delibera)
                  select evpa.ci
                        ,ctev.voce
                        ,ctev.sub
                        ,least(d_fin_mes, nvl(ragi.al, to_date(3333333, 'j')))
                        ,null
                        ,max(ctev.gestione)
                        ,'C'
                        ,round(sum(decode(toca.gestione
                                         ,'G'
                                         ,(nvl(evpa.al, to_date('3333333', 'j')) -
                                          evpa.dal + 1)
                                         ,evpa.valore) * decode(toca.segno, '-', -1, 1) *
                                   decode(ctev.gestione || caev.gestione
                                         ,'HG'
                                         ,nvl(pspa.min_gg, 0)
                                         ,'OG'
                                         ,nvl(pspa.min_gg, 0)
                                         ,1) / decode(ctev.gestione || caev.gestione
                                                     ,'GH'
                                                     ,nvl(pspa.min_gg, 1)
                                                     ,'GO'
                                                     ,nvl(pspa.min_gg, 1)
                                                     ,1)) /
                               decode(max(ctev.gestione), 'H', 60, 'O', 60, 1)
                              ,decode(max(ctev.gestione), 'H', 2, 'O', 2, 1))
                        ,null
                        ,null
                        ,max(ctev.delibera)
                    from causali_evento            caev
                        ,categorie_evento          ctev
                        ,sedi                      sedr
                        ,sedi                      sede
                        ,rapporti_giuridici        ragi
                        ,eventi_presenza           evpa
                        ,mesi                      mese
                        ,ripartizioni_funzionali   rifu
                        ,rapporti_presenza         rapa
                        ,totalizzazione_causali    toca
                        ,periodi_servizio_presenza pspa
                        ,riferimento_presenza      ripa
                   where evpa.ci = pspa.ci
                     and rapa.ci = pspa.ci
                     and ragi.ci = rapa.ci
                     and rapa.dal = pspa.dal_rapporto
                     and rifu.sede(+) = pspa.sede_cdc
                     and rifu.settore(+) = pspa.settore
                     and caev.codice = evpa.causale
                     and ctev.codice = toca.categoria
                     and ctev.codice = curs2.categoria
                     and evpa.causale = toca.causale
                     and nvl(evpa.motivo, ' ') like toca.motivo
                     and evpa.dal between pspa.dal and
                         nvl(pspa.al, to_date('3333333', 'j'))
                     and evpa.riferimento between nvl(ctev.dal, to_date('2222222', 'j')) and
                         nvl(ctev.al, to_date('3333333', 'j'))
                     and (mese.fin_mese - evpa.dal + 1) <=
                         decode(to_char(toca.riferimento_mm) ||
                                to_char(toca.riferimento_gg)
                               ,null
                               ,9999
                               ,nvl(toca.riferimento_mm, 0) * 30 +
                                nvl(toca.riferimento_gg, 0))
                     and evpa.dal <= mese.fin_mese
                     and sedr.numero(+) = nvl(pspa.sede, 0)
                     and sede.numero(+) = nvl(evpa.sede, 0)
                     and nvl(sede.codice, nvl(sedr.codice, ' ')) like ctev.sede
                     and nvl(evpa.cdc, nvl(rapa.cdc, nvl(rifu.cdc, ' '))) like ctev.cdc
                     and decode(ctev.opzione
                               ,'M'
                               ,to_char(add_months(evpa.dal
                                                  ,decode(caev.riferimento, 'P', 1, 0))
                                       ,'yyyymm')
                               ,'A'
                               ,to_char(add_months(evpa.dal
                                                  ,decode(caev.riferimento, 'P', 1, 0))
                                       ,'yyyy')
                               ,'T'
                               ,to_char(mese.fin_mese, 'yyyy')
                               ,'P'
                               ,to_char(add_months(evpa.dal
                                                  ,decode(caev.riferimento, 'P', 1, 0))
                                       ,'yyyy')
                               ,null) =
                         decode(ctev.opzione
                               ,'M'
                               ,to_char(mese.fin_mese, 'yyyymm')
                               ,'A'
                               ,to_char(mese.fin_mese, 'yyyy')
                               ,'T'
                               ,to_char(mese.fin_mese, 'yyyy')
                               ,'P'
                               ,to_char(to_number(to_char(mese.fin_mese, 'yyyy')) - 1))
                     and mese.anno = to_number(to_char(d_ini_mes, 'yyyy'))
                     and mese.mese = to_number(to_char(d_ini_mes, 'mm'))
                     and ctev.voce is not null
                     and ripa.ripa_id = 'RIPA'
                     and exists (select 'x'
                            from periodi_servizio_presenza
                           where ci = rapa.ci
                             and rilevanza = 'S'
                             and ripa.ini_mes <= nvl(al, ripa.ini_mes)
                             and ripa.fin_mes >= dal)
                   group by evpa.ci
                           ,ctev.voce
                           ,ctev.sub
                           ,least(d_fin_mes, nvl(ragi.al, to_date(3333333, 'j')));
            end;
         end loop;
         /*
                   +--------------------------------------------------------+
                   | Eliminazione da MOVIMENTI_CONTABILI delle voci even-   |
                   | tualmente gia` caricate per la Mensilita` di riferi-   |
                   | mento Retribuzione provenienti da Gestione Presenze.   |
                   +--------------------------------------------------------+
         */
         begin
            delete from movimenti_contabili moco
             where moco.input in (select 'P'
                                    from dual
                                  union
                                  select 'M' from dual)
               and moco.anno = d_anno
               and moco.mese = d_mese
               and moco.mensilita = d_mensilita
               and moco.ci > 0
               and exists (select 'x'
                      from rapporti_presenza
                     where ci = moco.ci
                       and flag_ec = 'M');
            delete from movimenti_contabili moco
             where moco.input = 'D'
               and moco.anno = d_anno
               and moco.mese = d_mese
               and moco.mensilita = d_mensilita
               and moco.ci in
                   (select rapa.ci from rapporti_presenza rapa where rapa.flag_ec = 'M')
               and moco.sede_del = 'F'
               and moco.anno_del = d_anno
               and moco.numero_del = d_mese;
            update rapporti_giuridici
               set flag_elab = 'P'
             where flag_elab in ('E', 'C')
               and ci in
                   (select rapa.ci from rapporti_presenza rapa where rapa.flag_ec = 'M');
         end;
         /*
                   +--------------------------------------------------------+
                   | Emissione voci contabili.                              |
                   +--------------------------------------------------------+
         */
         begin
            insert into movimenti_contabili
               (ci
               ,voce
               ,sub
               ,riferimento
               ,arr
               ,input
               ,qta_var
               ,tar_var
               ,imp_var
               ,delibera
               ,sede_del
               ,anno_del
               ,numero_del
               ,anno
               ,mese
               ,mensilita
               ,data)
               select deec.ci
                     ,deec.voce
                     ,deec.sub
                     ,least(deec.riferimento, d_fin_ela)
                     ,decode(to_char(deec.riferimento, 'yyyy')
                            ,d_anno
                            ,deec.arr
                            ,nvl(d_opzione_arr, deec.arr))
                     ,decode(deec.delibera
                            ,null
                            ,decode(deec.gestione, 'P', 'M', 'P')
                            ,'D')
                     ,decode(deec.qta, 0, null, deec.qta)
                     ,decode(deec.tar, 0, null, deec.tar)
                     ,decode(deec.imp, 0, null, deec.imp)
                     ,deec.delibera
                     ,decode(deec.delibera, null, null, 'F')
                     ,decode(deec.delibera, null, null, d_anno)
                     ,decode(deec.delibera, null, null, d_mese)
                     ,d_anno
                     ,d_mese
                     ,d_mensilita
                     ,to_date(to_char(sysdate, 'ddmmyyyy'), 'ddmmyyyy')
                 from deposito_eventi_ec deec;
         
            /* Inserimento segnalazioni per riferimenti > data di fine mese oppure > ragi.al */
            select nvl(max(progressivo), 0)
              into d_segnalazione
              from a_segnalazioni_errore
             where no_prenotazione = prenotazione
               and passo = 2;
            insert into a_segnalazioni_errore
               (no_prenotazione
               ,passo
               ,progressivo
               ,errore
               ,precisazione)
               select distinct prenotazione
                              ,2
                              ,rownum + d_segnalazione
                              ,'P05732'
                              ,substr(' - Voce: ' || deec.voce || ' - Cod.Ind.: ' ||
                                      deec.ci || ' ' || rain.cognome || ' ' || rain.nome
                                     ,1
                                     ,50)
                 from deposito_eventi_ec   deec
                     ,rapporti_individuali rain
                     ,rapporti_giuridici   ragi
                where deec.ci = rain.ci
                  and ragi.ci = rain.ci
                  and (deec.riferimento > d_fin_ela or not exists
                       (select 'x'
                          from periodi_giuridici
                         where ci = rain.ci
                           and rilevanza = 'S'
                           and deec.riferimento between dal and
                               nvl(al, to_date(3333333, 'j'))));
            /*
                      +--------------------------------------------------------+
                      | Eliminazione movimenti da DEPOSITO_EVENTI_EC.          |
                      +--------------------------------------------------------+
            */
            delete from deposito_eventi_ec;
            /*
                      +--------------------------------------------------------+
                      | Viene ripristinato il flag_ec sui RAPPORTI_PRESENZA in |
                      | tutti gli individui trattati che non hanno voci gia`   |
                      | calcolate in VALORI_PRESENZA per mensilita` successive.|
                      +--------------------------------------------------------+
            */
            update rapporti_presenza rapa
               set rapa.flag_ec = null
             where rapa.flag_ec = 'M'
               and not exists (select 'x'
                      from valori_presenza vapa
                          ,eventi_presenza evpa
                     where vapa.evento = evpa.evento
                       and evpa.dal > d_fin_ela);
         end;
      exception
         when errore then
            rollback;
            update a_prenotazioni
               set errore         = d_errore
                  ,prossimo_passo = 99
             where no_prenotazione = prenotazione;
      end;
   end;
end;
/
