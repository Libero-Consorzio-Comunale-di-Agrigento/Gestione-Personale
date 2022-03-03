create or replace package PECCMOCO is
/******************************************************************************

 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 3    28/07/2004 AM     Modifiche a seguito di segnalazioni dei clienti:
                        inseriti messaggi piu puntali sulle segnalazioni di anomalie
                        rivisti i totali
 4    27/08/2004 MV     A6982  
 4.1  27/11/2006 CB     Introdotti parametri per selezionare i dipendenti  
 4.2  11/03/2007 CB     A15292 (Calcolo automatico o no dell'arr)     
 4.3  24/05/2007 MM     A20555 Controlli su NORMATIVA_VOCE  
 4.4  07/09/2007 CB 
 4.5  09/10/2007 MS     Modificata gestione del controllo di esistenza di RAGI
 4.6  10/09/2007 CB     A23168 (Filtri su mese_liquidazione,anno_liquidazione e mensilita_liquidazione
******************************************************************************/
procedure main ( prenotazione in number , passo        in number );
function versione return varchar2;
end PECCMOCO;
/
create or replace package body PECCMOCO is
function versione return varchar2 is
begin
   return 'V4.6 del 10/10/2007';
end versione;
procedure main ( prenotazione in number , passo        in number ) is
begin
declare
p_ente              varchar2(4);
p_ambiente          varchar2(8);
p_utente            varchar2(8);
p_anno              varchar2(4);
p_mese              varchar2(2);
p_mensilita         varchar2(3);
p_fin_ela           date;
p_ini_ela           date;
p_rif               date;
p_anomalie          varchar2(1);
p_controlli         varchar2(1);
p_totali            varchar2(1);
p_origine           varchar2(10);
p_codice_origine    varchar2(120);
p_contratto         varchar2(4);
p_ruolo             varchar2(2);
p_gestione          varchar2(8);
p_fascia            varchar2(2);
p_gruppo            varchar2(12);
p_rapporto          varchar2(4);
p_ragi              varchar2(1);
p_pagina            number := 0;
p_riga              number := 0;
p_flag_elab         varchar2(1);
d_data_acquisizione date;
d_riferimento       date;
d_ultimo            date;
d_dep_ente_mm       number;
d_rif_ente          date;
p_arr               varchar2(1);
esci exception;
esci_loop exception;

 begin

   BEGIN
   --
   --  -- Estrazione Parametri di Selezione della Prenotazione e data di acquisizione
   --
   select ente d_ente
         ,utente d_utente
         ,ambiente d_ambiente
         ,sysdate
     into p_ente
         ,p_utente
         ,p_ambiente
         ,d_data_acquisizione
     from a_prenotazioni
    where no_prenotazione = prenotazione;
   --
   --  -- Estrae Anno, Mese, Mensilita di Riferimento Retribuzione
   --
   select to_char(anno) d_anno
         ,to_char(mese) d_mese
         ,mensilita d_mensilita
         ,fin_ela d_fin_ela
         ,ini_ela d_ini_ela
         ,add_months(fin_ela, variabili_gepe * -1) d_rif
         ,last_day(to_date(to_char(mese) || '/' || to_char(anno), 'MM/YYYY'))
     into p_anno
         ,p_mese
         ,p_mensilita
         ,p_fin_ela
         ,p_ini_ela
         ,p_rif
         ,d_ultimo
     from riferimento_retribuzione
         ,ente
    where rire_id = 'RIRE';
   --
   --  Estrae il flag delle anomalie (X o null)
   --
   begin
      select para.valore
        into p_anomalie
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_ANOMALIE';
   exception
      when no_data_found then
         p_anomalie := null;
   end;
   --
   --  Estrae il flag dei totali (se X o null)
   --
   begin
      select para.valore
        into p_totali
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_TOTALI';
   exception
      when no_data_found then
         p_totali := null;
   end;
   --
   --  Estrae le origini
   --
   begin
      select para.valore
        into p_origine
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_ORIGINE';
   exception
      when no_data_found then
         p_origine := null;
   end;
   --
   --  Estrae il flag per i SOLI controlli
   --
   begin
      select para.valore
        into p_controlli
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_CONTROLLI';
   exception
      when no_data_found then
         p_controlli := null;
   end;
      
   --
   --  Estrae il flag dell'arretrato (X o null)
   --
   begin
      select para.valore
        into p_arr
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_ARR';
   exception
      when no_data_found then
         p_arr := null;
   end;
      
   --  Estrae il parametro del contratto
   begin
      select para.valore
        into p_contratto
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_CONTRATTO';
   exception
      when no_data_found then
         p_contratto := null;
   end;
      
   --  Estrae il parametro del ruolo
   begin
      select para.valore
        into p_ruolo
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_RUOLO';
   exception
      when no_data_found then
         p_ruolo := null;
   end;
      
   --  Estrae il parametro della gestione
   begin
      select para.valore
        into p_gestione
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_GESTIONE';
   exception
      when no_data_found then
         p_gestione := null;
   end;
      
   --  Estrae il parametro della fascia della gestione
   begin
      select para.valore
        into p_fascia
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_FASCIA';
   exception
      when no_data_found then
         p_fascia := null;
   end;
      
   --  Estrae il parametro della classe rapporto
   begin
      select para.valore
        into p_rapporto
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_RAPPORTO';
   exception
      when no_data_found then
         p_rapporto := null;
   end;
      
   --  Estrae il parametro del gruppo
   begin
      select para.valore
        into p_gruppo
        from a_parametri para
       where para.no_prenotazione = prenotazione
         and para.parametro = 'P_GRUPPO';
   exception
      when no_data_found then
         p_gruppo := null;
   end;
   END;

   begin
     --Controlli preliminari (eseguiti su tutti i record della tabella)
     --
     --Verifica se esistono origini obbligatorie su ORVA per le quali non sono presenti
     --registrazioni su DEVE con mensilita corrente o nulla (cioè da caricare):
     --
     p_codice_origine := null;
      begin
         select 'X'
           into p_codice_origine
           from origini_variabili orva
          where orva.obbligatorio = 'SI'
            and rownum = 1
            and not exists (select 1
                   from deposito_variabili_economiche deve
                  where (deve.mensilita = p_mensilita and
                        deve.mese = p_mese and deve.anno = p_anno or
                        deve.mensilita is null and
                        deve.mese is null and deve.anno is null)
                    and deve.data_acquisizione is null
                    and deve.input = orva.origine);
         -- Emette la testata della segnalazione:
         if p_codice_origine = 'X' then
            update a_prenotazioni
               set errore = 'Mancano le seguenti origini:'
             where no_prenotazione = prenotazione;
         end if;
      exception
         when no_data_found then
            null;
      end;
      --
      --
      for cur_a in (select origine
                      from origini_variabili orva
                     where orva.obbligatorio = 'SI'
                       and not exists
                     (select 1
                              from deposito_variabili_economiche deve
                             where (deve.mensilita = p_mensilita and
                                   deve.mese = p_mese and deve.anno = p_anno or
                                   deve.mensilita is null and deve.mese is null and
                                   deve.anno is null)
                               and deve.data_acquisizione is null
                               and deve.input = orva.origine))
      loop
         begin
            -- Completa la segnalazione con i codici delle Origini Obbligatorie mancanti
            update a_prenotazioni
               set errore = errore || ' ' || cur_a.origine
             where no_prenotazione = prenotazione;
            commit;
         end;
      end loop;
      if p_codice_origine = 'X' then
         raise esci;
      end if;
   end;

   begin
   --
   -- Verifica se esistono origini con mensilita 'SI' e anno o mensilita di DEVE nulli
   --
      begin
         select 'X'
           into p_codice_origine
           from origini_variabili orva
          where orva.mensilita = 'SI'
            and rownum = 1
            and exists (select 1
                   from deposito_variabili_economiche deve
                  where (deve.mensilita is null or deve.mese is null or
                        deve.anno is null)
                    and deve.data_acquisizione is null
                    and deve.input = orva.origine);
         -- Emette la testata della segnalazione:
         if p_codice_origine = 'X' then
            update a_prenotazioni
               set errore = 'Mensilità non specificata per le seguenti origini:'
             where no_prenotazione = prenotazione;
         end if;
      exception
         when no_data_found then
            null;
      end;
      for cur_b in (select origine
                      from origini_variabili orva
                     where orva.mensilita = 'SI'
                       and exists
                     (select 1
                              from deposito_variabili_economiche deve
                             where (deve.mensilita is null or deve.mese is null or
                                   deve.anno is null)
                               and deve.data_acquisizione is null
                               and deve.input = orva.origine))
      loop
         begin
            -- Completa la segnalazione con i codici delle Origini
            update a_prenotazioni
               set errore = errore || ' ' || cur_b.origine
             where no_prenotazione = prenotazione;
            commit;
         end;
      end loop;
      if p_codice_origine = 'X' then
         raise esci;
      end if;
   end;
      
   begin
   -- Verifica la presenza su DEVE di registrazioni con origini presenti su ORVA
      begin
         select 'X'
           into p_codice_origine
           from deposito_variabili_economiche deve
          where rownum = 1
            and not exists (select 1
                   from origini_variabili orva
                  where deve.input = orva.origine)
            and deve.data_acquisizione is null;
         if p_codice_origine = 'X' then
            -- Emette la testata della segnalazione:
            update a_prenotazioni
               set errore = 'Origine non definita:'
             where no_prenotazione = prenotazione;
         end if;
      exception
         when no_data_found then
            null;
      end;
      for cur_c in (select distinct input
                      from deposito_variabili_economiche deve
                     where not exists (select 1
                              from origini_variabili orva
                             where deve.input = orva.origine)
                       and deve.data_acquisizione is null)
      loop
         begin
            -- Completa la segnalazione con i codici delle Origini
            update a_prenotazioni
               set errore = errore || ' ' || cur_c.input
             where no_prenotazione = prenotazione;
            commit;
         end;
      end loop;
      if p_codice_origine = 'X' then
         raise esci;
      end if;
   end;
      
   begin
   -- Inserimenti sulla a_appoggio_stampe
   -- Segnalazione 1 (se ci sono codici di mensilita non nulli e incompleti o non definiti su MENS)
      p_pagina := 1;
      p_riga   := 1;
      for cur in (select distinct deve.input
                                 ,deve.anno
                                 ,deve.mese
                                 ,deve.mensilita
                                 ,orva.descrizione
                    from deposito_variabili_economiche deve
                        ,origini_variabili             orva
                   where deve.input = orva.origine
                     and deve.input like p_origine
                     and deve.data_acquisizione is null
                     and (deve.mensilita is not null or deve.mese is not null or
                         deve.anno is not null)
                     and not exists (select 1
                            from mensilita mens
                           where mens.mese = deve.mese
                             and mens.mensilita = deve.mensilita
                             and deve.anno is not null))
      loop
         begin
            insert into a_appoggio_stampe
               (no_prenotazione
               ,no_passo
               ,pagina
               ,riga
               ,testo)
            values
               (prenotazione
               ,1
               ,p_pagina
               ,p_riga
               ,rpad(cur.input, 10, ' ') || ' ' || rpad(cur.descrizione, 40, ' ') || ' ' ||
                lpad(nvl(cur.anno, 0), 4, 0) || ' ' ||
                lpad(nvl(cur.mese, 0), 2, 0) || ' ' ||
                rpad(nvl(cur.mensilita, ' '), 3, ' '));
            p_riga := p_riga + 1;
         end;
      end loop;
   end;

   begin
   --
   -- Segnalazione 2 (se ci sono voci contabili non definite su CONTABILITA_VOCE)
   -- oppure con classe diversa da ('Q','V','C','B','P','R');
      p_pagina := 2;
      p_riga   := 1;
      for cur in (select distinct deve.input
                                 ,deve.voce
                                 ,deve.sub
                                 ,orva.descrizione
                    from deposito_variabili_economiche deve
                        ,origini_variabili             orva
                   where deve.input = orva.origine
                     and deve.input like p_origine
                     and deve.data_acquisizione is null
                     and (not exists
                          (select 1
                             from contabilita_voce covo
                            where covo.voce = deve.voce
                              and covo.sub = deve.sub
                              and deve.riferimento between
                                  nvl(covo.dal, to_date(2222222, 'j')) and
                                  nvl(covo.al, to_date(3333333, 'j'))) or not exists
                          (select 1
                             from voci_economiche voec
                            where voec.codice = deve.voce
                              and voec.classe in ('Q', 'V', 'C', 'B', 'P', 'R'))))
      loop
         begin
            insert into a_appoggio_stampe
               (no_prenotazione
               ,no_passo
               ,pagina
               ,riga
               ,testo)
            values
               (prenotazione
               ,1
               ,p_pagina
               ,p_riga
               ,rpad(cur.input, 10, ' ') || ' ' || rpad(cur.descrizione, 40, ' ') || ' ' ||
                rpad(cur.voce, 10, ' ') || ' ' || rpad(cur.sub, 2, ' '));
            p_riga := p_riga + 1;
         end;
      end loop;
   end;

   begin
   --
   -- Segnalazione 3 (se ci sono valori di ARR non nulli diversi da P e C)
      p_pagina := 3;
      p_riga   := 1;
      for cur in (select distinct deve.input
                                 ,deve.arr
                                 ,orva.descrizione
                    from deposito_variabili_economiche deve
                        ,origini_variabili             orva
                   where deve.input = orva.origine
                     and deve.input like p_origine
                     and deve.data_acquisizione is null
                     and deve.arr is not null
                     and deve.arr not in ('P', 'C'))
      loop
         begin
            insert into a_appoggio_stampe
               (no_prenotazione
               ,no_passo
               ,pagina
               ,riga
               ,testo)
            values
               (prenotazione
               ,1
               ,p_pagina
               ,p_riga
               ,rpad(cur.input, 10, ' ') || ' ' || rpad(cur.descrizione, 40, ' ') || ' ' ||
                rpad(nvl(cur.arr, ' '), 1, ' '));
            p_riga := p_riga + 1;
         end;
      end loop;
   end;

   begin
   --
   -- Segnalazione 4 (se richiesto stampa i totali degli importi da caricare)
      p_pagina := 4;
      p_riga   := 1;
      for cur in (select deve.input
                        ,orva.descrizione
                        ,deve.voce
                        ,deve.sub
                         --            ,deve.riferimento
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), 0, qta)) qta_acquisiti
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), qta, 0)) qta_da_acquisire
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), 0, imp)) imp_acquisiti
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), imp, 0)) imp_da_acquisire
                   from deposito_variabili_economiche deve
                        ,origini_variabili             orva
                        ,rapporti_giuridici            ragi
                        ,gestioni                      gest
                        ,rapporti_individuali          rain
                   where deve.ci = ragi.ci
                     and deve.ci = rain.ci
                     and gest.codice = ragi.gestione
                     and deve.input = orva.origine
                     and deve.input like p_origine
                     and p_totali is null
                     and (deve.mensilita is null and deve.mese is null and
                         deve.anno is null or
                         deve.mensilita = p_mensilita and deve.mese = p_mese and
                         deve.anno = p_anno)
                     and (deve.mensilita_liquidazione is null and deve.mese_liquidazione is null and
                         deve.anno_liquidazione is null or
                         deve.mensilita_liquidazione = p_mensilita and deve.mese_liquidazione = p_mese and
                         deve.anno_liquidazione = p_anno)
                     and nvl(ragi.contratto, '%') like nvl(p_contratto, '%')
                     and nvl(ragi.di_ruolo, '%') like nvl(p_ruolo, '%')
                     and nvl(ragi.gestione, '%') like nvl(p_gestione, '%')
                     and nvl(rain.rapporto, '%') like nvl(p_rapporto, '%')
                     and nvl(rain.gruppo, '%') like nvl(p_gruppo, '%')
                     and nvl(gest.fascia, '%') like nvl(p_fascia, '%')
                   group by deve.input
                           ,deve.voce
                           ,deve.sub
                           ,orva.descrizione
                  --       ,deve.riferimento
                   order by deve.input
                           ,deve.voce)
      loop
         begin
            insert into a_appoggio_stampe
               (no_prenotazione
               ,no_passo
               ,pagina
               ,riga
               ,testo)
            values
               (prenotazione
               ,1
               ,98
               ,p_riga
               ,rpad(cur.input, 10, ' ') || ' ' || rpad(cur.descrizione, 40, ' ') || ' ' ||
                rpad(cur.voce, 10, ' ') || ' ' || rpad(cur.sub, 2, ' ') || ' ' ||
                lpad(nvl(cur.qta_acquisiti, 0), 15, ' ') || ' ' ||
                lpad(nvl(cur.qta_da_acquisire, 0), 15, ' ') || ' ' ||
                lpad(nvl(cur.imp_acquisiti, 0), 15, ' ') || ' ' ||
                lpad(nvl(cur.imp_da_acquisire, 0), 15, ' '));
            p_riga := p_riga + 1;
         end;
      end loop;
   end;

   begin
   --
   -- Segnalazione 5,6,8 e 99
   -- Per ogni record con utente_acquisizione nullo e mensilita nulla o corrente:
   -- Segnalazione 5: Verifica se il CI non esiste in RAGI
   -- Segnalazione 6: Verifica se IMP e QTA sono entrambi nulli
   -- Segnalazione 8: Verifica se CI, VOCE e RIFERIMENTO sono compatibili su NORMATIVA_VOCE
   -- Segnalazione 99: Se richiesto stampa gli iserimenti NON effettuati in MOCO
      p_riga := 1;
      p_ragi := null;

      for CUR_CHK_RAGI in 
         ( select distinct deve.input
               , deve.ci
               , gp4_rain.get_nominativo(deve.ci) nominativo
               , deve.voce
               , deve.sub
               , deve.riferimento
               , deve.qta
               , deve.tar
               , deve.imp
            from deposito_variabili_economiche deve
                ,rapporti_individuali          rain
           where deve.ci = rain.ci (+)
             and deve.input like p_origine
             and deve.utente_acquisizione is null
             and (deve.mensilita is null and deve.mese is null and
                 deve.anno is null or
                 deve.mensilita = p_mensilita and deve.mese = p_mese and
                 deve.anno = p_anno)
             and nvl(arr, 'C') in ('C', 'P')
             and nvl(rain.rapporto, '%') like nvl(p_rapporto, '%')
             and nvl(rain.gruppo, '%') like nvl(p_gruppo, '%')
           order by input
                  , deve.ci
                  , voce
         ) loop
            begin
               -- controllo su RAGI
               select 'x'
                 into p_ragi
                 from rapporti_giuridici ragi
                where CUR_CHK_RAGI.ci = ragi.ci;
            exception
               when no_data_found then
                  -- segnalazione CI senza RAGI 
                  p_ragi := null;
                  begin
                     insert into a_appoggio_stampe
                        (no_prenotazione
                        ,no_passo
                        ,pagina
                        ,riga
                        ,testo)
                     values
                        (prenotazione
                        ,1
                        ,5
                        ,p_riga
                        ,rpad(CUR_CHK_RAGI.input, 10, ' ') || ' ' ||
                         rpad(CUR_CHK_RAGI.voce, 10, ' ') || ' ' || rpad(CUR_CHK_RAGI.sub, 2, ' ') || ' ' ||
                         rpad(CUR_CHK_RAGI.ci, 8, ' ') || ' ' ||
                         rpad(nvl(CUR_CHK_RAGI.nominativo, ' '), 30, ' ') || ' ' ||
                         rpad(to_char(CUR_CHK_RAGI.riferimento, 'dd/mm/yyyy'), 10, ' ') || ' ' ||
                         lpad(nvl(CUR_CHK_RAGI.qta, 0), 15, ' ') || ' ' ||
                         lpad(nvl(CUR_CHK_RAGI.tar, 0), 15, ' ') || ' ' ||
                         lpad(nvl(CUR_CHK_RAGI.imp, 0), 15, ' '));
                     p_riga := p_riga + 1;
                  end;
            end;
      END LOOP;

      for cur in 
        ( select deve.input
                ,orva.descrizione
                ,deve.data_inserimento
                ,deve.ci
                ,gp4_rain.get_nominativo(deve.ci) nominativo
                ,deve.voce
                ,deve.sub
                ,deve.mensilita
                ,deve.arr
                ,deve.riferimento
                ,deve.competenza
                ,deve.qta
                ,deve.tar
                ,deve.imp
                ,deve.sede_del
                ,deve.anno_del
                ,deve.numero_del
                ,deve.delibera
                ,deve.capitolo
                ,deve.articolo
                ,deve.conto
                ,deve.impegno
                ,deve.anno_impegno
                ,deve.risorsa_intervento
                ,deve.sub_impegno
                ,deve.anno_sub_impegno
                ,deve.rowid
                ,voec.classe
            from deposito_variabili_economiche deve
                ,origini_variabili             orva
                ,voci_economiche               voec
                ,rapporti_giuridici            ragi
                ,gestioni                      gest
                ,rapporti_individuali          rain
           where voec.codice = deve.voce
             and deve.ci = ragi.ci
             and deve.ci = rain.ci
             and gest.codice = ragi.gestione
             and deve.input = orva.origine
             and deve.input like p_origine
             and deve.utente_acquisizione is null
             and (deve.mensilita is null and deve.mese is null and
                 deve.anno is null or
                 deve.mensilita = p_mensilita and deve.mese = p_mese and
                 deve.anno = p_anno)
             and exists
           (select 1
                    from contabilita_voce covo
                   where covo.voce = deve.voce
                     and covo.sub = deve.sub
                     and deve.riferimento between
                         nvl(covo.dal, to_date(2222222, 'j')) and
                         nvl(covo.al, to_date(3333333, 'j')))
             and nvl(arr, 'C') in ('C', 'P')
             and nvl(ragi.contratto, '%') like nvl(p_contratto, '%')
             and nvl(ragi.di_ruolo, '%') like nvl(p_ruolo, '%')
             and nvl(ragi.gestione, '%') like nvl(p_gestione, '%')
             and nvl(rain.rapporto, '%') like nvl(p_rapporto, '%')
             and nvl(rain.gruppo, '%') like nvl(p_gruppo, '%')
             and nvl(gest.fascia, '%') like nvl(p_fascia, '%')
           order by input
                   ,deve.ci
                   ,voce
        ) loop
         begin
            if cur.qta is null and cur.imp is null or
               cur.classe in ('B', 'P', 'V') and cur.qta is not null then
               -- segnalazione imp e qta nulli 
               begin
                  insert into a_appoggio_stampe
                     (no_prenotazione
                     ,no_passo
                     ,pagina
                     ,riga
                     ,testo)
                  values
                     (prenotazione
                     ,1
                     ,6
                     ,p_riga
                     ,rpad(cur.input, 10, ' ') || ' ' || rpad(cur.voce, 10, ' ') || ' ' ||
                      rpad(cur.sub, 2, ' ') || ' ' || rpad(cur.ci, 8, ' ') || ' ' ||
                      rpad(nvl(cur.nominativo, ' '), 30, ' ') || ' ' ||
                      rpad(to_char(cur.riferimento, 'dd/mm/yyyy'), 10, ' ') || ' ' ||
                      lpad(nvl(cur.qta, 0), 15, ' ') || ' ' ||
                      lpad(nvl(cur.tar, 0), 15, ' ') || ' ' ||
                      lpad(nvl(cur.imp, 0), 15, ' '));
                  p_riga := p_riga + 1;
               end;
            elsif p_ragi is not null then
               -- Assesta la data di riferimento
               begin
                  select least(cur.riferimento, p_fin_ela)
                    into d_riferimento
                    from periodi_giuridici
                   where exists (select 'x'
                            from periodi_giuridici pegi
                           where pegi.ci = cur.ci
                             and pegi.rilevanza = 'S')
                     and ci = cur.ci
                     and rilevanza = 'S'
                     and least(cur.riferimento, p_fin_ela) between
                         nvl(dal, to_date('2222222', 'j')) and
                         nvl(al, to_date('3333333', 'j'));
               exception
                  when no_data_found then
                     begin
                        select greatest(least(cur.riferimento
                                             ,nvl(ragi.al, to_date('3333333', 'j'))
                                             ,p_fin_ela)
                                       ,nvl(ragi.dal, to_date('2222222', 'j')))
                          into d_riferimento
                          from rapporti_giuridici ragi
                         where ci = cur.ci;
                     exception
                        when no_data_found then
                           d_riferimento := to_date(null);
                     end;
               end;
               if gp4ec.chk_novo(cur.ci, cur.voce, d_riferimento) = 'NO' then
                  begin
                     insert into a_appoggio_stampe
                        (no_prenotazione
                        ,no_passo
                        ,pagina
                        ,riga
                        ,testo)
                     values
                        (prenotazione
                        ,1
                        ,8
                        ,p_riga
                        ,rpad(cur.input, 10, ' ') || ' ' ||
                         rpad(cur.voce, 10, ' ') || ' ' || rpad(cur.sub, 2, ' ') || ' ' ||
                         rpad(cur.ci, 8, ' ') || ' ' ||
                         rpad(nvl(cur.nominativo, ' '), 30, ' ') || ' ' ||
                         rpad(to_char(d_riferimento, 'dd/mm/yyyy'), 10, ' ') || ' ' ||
                         lpad(nvl(cur.qta, 0), 15, ' ') || ' ' ||
                         lpad(nvl(cur.tar, 0), 15, ' ') || ' ' ||
                         lpad(nvl(cur.imp, 0), 15, ' '));
                     p_riga := p_riga + 1;
                  end;
               else
                  if p_controlli is null then
                     if p_arr = 'X' then
                        begin
                           select variabili_gepe into d_dep_ente_mm from ente;
                        exception
                           when no_data_found then
                              d_dep_ente_mm := 0;
                        end;
                           
                        begin
                           select add_months(d_ultimo, -nvl(d_dep_ente_mm, 0))
                             into d_rif_ente
                             from dual;
                        exception
                           when no_data_found then
                              null;
                        end;
 
                        if nvl(d_riferimento, p_rif) < p_ini_ela then
                           if nvl(d_riferimento, p_rif) <=
                              add_months(d_rif_ente, -1) then
                              if to_number(to_char(nvl(d_riferimento, p_rif)
                                                  ,'yyyy')) <
                                 to_number(to_char(p_ini_ela, 'yyyy')) then
                                 cur.arr := 'C';
                              else
                                 cur.arr := 'C';
                              end if;
                           else 
                                 cur.arr := null;   
                           end if;
                        else
                           cur.arr := null;
                        end if;
                     else
                        null;
                     end if;
                        
                     begin
                        insert into movimenti_contabili
                           (ci
                           ,anno
                           ,mese
                           ,mensilita
                           ,voce
                           ,sub
                           ,riferimento
                           ,arr
                           ,input
                           ,data
                           ,tar_var
                           ,qta_var
                           ,imp_var
                           ,sede_del
                           ,anno_del
                           ,numero_del
                           ,delibera
                           ,capitolo
                           ,articolo
                           ,conto
                           ,impegno
                           ,anno_impegno
                           ,risorsa_intervento
                           ,sub_impegno
                           ,anno_sub_impegno
                           ,competenza)
                        values
                           (cur.ci
                           ,p_anno
                           ,p_mese
                           ,p_mensilita
                           ,cur.voce
                           ,cur.sub
                           ,nvl(d_riferimento, p_rif)
                           ,decode(cur.classe
                                  ,'B'
                                  ,nvl(cur.arr, 'C')
                                  ,'P'
                                  ,nvl(cur.arr, 'C')
                                  ,cur.arr)
                           ,'I'
                           ,nvl(cur.data_inserimento, sysdate)
                           ,cur.tar
                           ,cur.qta
                           ,cur.imp
                           ,cur.sede_del
                           ,cur.anno_del
                           ,cur.numero_del
                           ,cur.delibera
                           ,cur.capitolo
                           ,cur.articolo
                           ,cur.conto
                           ,cur.impegno
                           ,decode(cur.impegno, null, null, cur.anno_impegno)
                           ,cur.risorsa_intervento
                           ,cur.sub_impegno
                           ,decode(cur.sub_impegno
                                  ,null
                                  ,null
                                  ,cur.anno_sub_impegno)
                           ,cur.competenza);
                     end;
                     begin
                        update deposito_variabili_economiche
                           set data_acquisizione      = d_data_acquisizione
                              ,utente_acquisizione    = p_utente
                              ,anno_liquidazione      = p_anno
                              ,mensilita_liquidazione = p_mensilita
                              ,mese_liquidazione      = p_mese
                         where rowid = cur.rowid;
                        commit;
                     end;
                     if p_anomalie is null then
                        begin
                           insert into a_appoggio_stampe
                              (no_prenotazione
                              ,no_passo
                              ,pagina
                              ,riga
                              ,testo)
                           values
                              (prenotazione
                              ,1
                              ,7
                              ,p_riga
                              ,rpad(cur.input, 10, ' ') || ' ' ||
                               rpad(cur.voce, 10, ' ') || ' ' ||
                               rpad(cur.sub, 2, ' ') || ' ' ||
                               rpad(cur.ci, 8, ' ') || ' ' ||
                               rpad(nvl(cur.nominativo, ' '), 30, ' ') || ' ' ||
                               rpad(to_char(cur.riferimento, 'dd/mm/yyyy')
                                   ,10
                                   ,' ') || ' ' || lpad(nvl(cur.qta, 0), 15, ' ') || ' ' ||
                               lpad(nvl(cur.tar, 0), 15, ' ') || ' ' ||
                               lpad(nvl(cur.imp, 0), 15, ' '));
                           p_riga := p_riga + 1;
                        end;
                     end if; -- P_anomalie
                     --
                     -- Attiva se necessario ragi.flag_elab per obbligare alla rielaborazione dei cedolini
                     begin
                        select flag_elab
                          into p_flag_elab
                          from rapporti_giuridici ragi
                         where ci = cur.ci;
                        if p_flag_elab in ('E', 'C') then
                           update rapporti_giuridici
                              set flag_elab = 'P'
                            where ci = cur.ci;
                        end if;
                     end;
                  end if; -- P_controlli
               end if; -- chk_novo
            end if; -- qta e imp significativi e RAGI esistente
         end;
      end loop;
      raise esci_loop;
   exception
      when esci_loop then
         null;
   end;

   begin
   -- Segnalazione 99: se richiesto stampa i totali degli importi NON acquisiti
   -- (quindi rimasti con data_acquisizione nulla)
      p_pagina := 99;
      p_riga   := 1;
      for cur in (select deve.input
                        ,orva.descrizione
                        ,deve.voce
                        ,deve.sub
                         --,deve.riferimento
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), 0, qta)) qta_acquisiti
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), qta, 0)) qta_da_acquisire
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), 0, imp)) imp_acquisiti
                        ,sum(decode(lpad(deve.anno_liquidazione,4,'0')||lpad(deve.mensilita_liquidazione,3,' ')||lpad(deve.mese_liquidazione,2,' '), lpad(p_anno,4,'0')||lpad(p_mensilita,3,' ')||lpad(p_mese,2,' '), imp, 0)) imp_da_acquisire
                  from deposito_variabili_economiche deve
                        ,origini_variabili             orva
                   where deve.input = orva.origine
                     and deve.input like p_origine
                     and p_totali is null
                     and (deve.mensilita is null and deve.mese is null and
                         deve.anno is null or
                         deve.mensilita = p_mensilita and deve.mese = p_mese and
                         deve.anno = p_anno)
                     and (deve.mensilita_liquidazione is null and deve.mese_liquidazione is null and
                         deve.anno_liquidazione is null or
                         deve.mensilita_liquidazione = p_mensilita and deve.mese_liquidazione = p_mese and
                         deve.anno_liquidazione = p_anno)
                   group by deve.input
                           ,deve.voce
                           ,deve.sub
                           ,orva.descrizione
                  --        ,deve.riferimento
                   order by deve.input
                           ,deve.voce)
      loop
         begin
            insert into a_appoggio_stampe
               (no_prenotazione
               ,no_passo
               ,pagina
               ,riga
               ,testo)
            values
               (prenotazione
               ,1
               ,p_pagina
               ,p_riga
               ,rpad(cur.input, 10, ' ') || ' ' || rpad(cur.descrizione, 40, ' ') || ' ' ||
                rpad(cur.voce, 10, ' ') || ' ' || rpad(cur.sub, 2, ' ') || ' ' ||
                lpad(nvl(cur.qta_acquisiti, 0), 15, ' ') || ' ' ||
                lpad(nvl(cur.qta_da_acquisire, 0), 15, ' ') || ' ' ||
                lpad(nvl(cur.imp_acquisiti, 0), 15, ' ') || ' ' ||
                lpad(nvl(cur.imp_da_acquisire, 0), 15, ' '));
            p_riga := p_riga + 1;
         end;
      end loop;
   end;

 exception
      when esci then null;
 end main;
end;
end PECCMOCO;
/
