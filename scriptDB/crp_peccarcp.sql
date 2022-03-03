CREATE OR REPLACE PACKAGE peccarcp IS
/******************************************************************************
 NOME:        PECCARCP
 DESCRIZIONE: Creazione delle registrazioni annuali individuali per la fase di stampa
              della denuncia annuale Cassa Pensione.
              Questa funzione inserisce nella tavola DENUNCIA_CP le registrazioni
              relative ad ogni individuo che ha prestato servizio nell'anno richiesto,
              per consentire ad una funzione successiva di fornire un tabulato che
              permetta la compilazione della denuncia annuale di Cassa Pensione
              (Mod.106).
              A questo scopo e` necessario gestire diversi tipi di registrazioni,
              distinti dal campo RILEVANZA della tavola DENUNCIA_CP:
              S = Servizio     ---- contiene gli estremi dei periodi di servizio presta-
                                    ti dal dipendente nel corso dell'anno, eventualmente
                                    spezzati da periodi di assenza non utile.
              R = Retribuzione ---- contiene la Retribuzione Annua Contributiva effet-
                                    tivamente percepita dal dipendente e l'indicazio-
                                    ne della data di decorrenza.
              A = Arretrati    ---- non sempre presente, contiene l'importo di eventua-
                                    li arretrati relativi ad anni precedenti, percepiti
                                    dal dipendente e l'indicazione dell'anno cui si
                                    riferiscono.
             L'importo della retribuzione da dichiarare si ottiene dal campo VALORE
             della tabella VALORI_CONTABILI_ANNUALI da cui e` possibile leggere
             il progressivo al mese che interessa. La tabella infatti contiene i
             valori precalcolati di tutte le colonne definite in
             ESTRAZIONE_VALORI_CONTABILI.
             La retribuzione inoltre deve essere integrata al minimale retributivo
             rapportato ai giorni di servizio prestati dal dipendente.
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: Il PARAMETRO D_previdenza determina quale previdenza elaborare.
              Il PARAMETRO D_gestione determina quale gestione elaborare.
              Il PARAMETRO D_tipo determina il tipo di elaborazione da effettuare.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
 2.0  08/02/2005 MS     Modifiche per att. 7307
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccarcp IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.0 del 08/02/2005';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
	declare
P_ente       varchar2(4);
P_ambiente   varchar2(8);
P_utente     varchar2(8);
P_anno       varchar2(4);
P_gestione   varchar2(4);
P_previdenza varchar2(6);
P_tipo       varchar2(1);
    begin
  -- Estrazione Parametri di Selezione della Prenotazione
select max(decode(parametro,'P_TIPO'      ,valore,' ')) D_tipo
      ,max(decode(parametro,'P_PREVIDENZA',valore,' ')) D_previdenza
      ,max(decode(parametro,'P_GESTIONE'  ,valore,' ')) D_gestione
	  into p_tipo, p_previdenza, p_gestione
  from a_parametri
 where no_prenotazione = prenotazione
   and parametro      in ('P_TIPO','P_PREVIDENZA','P_GESTIONE')
;
select ente     D_ente
     , utente   D_utente
     , ambiente D_ambiente
	 into p_ente, p_utente, p_ambiente
  from a_prenotazioni
 where no_prenotazione = prenotazione
;
  -- Estrae Anno di Riferimento per archiviazione
      select to_char(anno) D_anno
	  into p_anno
        from riferimento_fine_anno
       where rifa_id = 'RIFA'
      ;
  -- Cancellazione Archiviazione precedente relativa all'anno richiesto
     lock table denuncia_cp in exclusive mode nowait
     ;
     delete from denuncia_cp decp
      where decp.anno             = to_number(p_anno)
        and decp.gestione      like p_gestione
        and decp.previdenza    like p_previdenza
        and (    p_tipo = 'T'
              or not exists
                (select 'x' from denuncia_cp
                  where anno       = decp.anno
                    and gestione   = decp.gestione
                    and previdenza = decp.previdenza
                    and ci         = decp.ci
                    and (    tipo_agg  = p_tipo
                         or (p_tipo     = 'P'       and
                             tipo_agg is not null
                            )
                        )
                )
             )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = decp.ci
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = p_ente
                          and ambiente    = p_ambiente
                          and utente      = p_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
     ;
     commit
     ;
 -- Creazione delle registrazioni di appoggio per determinazione dei
 -- dipendenti da trattare
     lock table denuncia_cp in exclusive mode nowait
     ;
     insert into denuncia_cp
          ( anno
          , previdenza
          , ci
          , gestione
          , codice
          , posizione
          , rilevanza
          , dal
          , al
          )
     select to_number(p_anno)
          , trpr.previdenza
          , pere.ci
          , substr(max(to_char(pere.dal,'j')||pere.gestione),8,4)
          , decode( trpr.previdenza
                  , 'CPDEL', max(rare.codice_cpd)
                           , max(rare.codice_cps))
          , decode( trpr.previdenza
                  , 'CPDEL', max(rare.posizione_cpd)
                           , max(rare.posizione_cps))
          , 'X'
          , decode( least( min( greatest( pere.dal
                                        , to_date(lpad(pere.mese,2,0)||
                                                  pere.anno,'mmyyyy')
                                        ))
                         , nvl(max(pere.al),to_date('3333333','j')))
                  , nvl(max(pere.al),to_date('3333333','j')), min(pere.dal)
                       , min( greatest( pere.dal
                                      , to_date(lpad(pere.mese,2,0)||
                                                pere.anno,'mmyyyy')
                                      ))
                  )
          , max(pere.al)
       from trattamenti_previdenziali  trpr
          , periodi_retributivi        pere
          , rapporti_retributivi       rare
      where pere.ci               = rare.ci+0
        and pere.periodo    between last_day(to_date('01'||to_number(p_anno)
                                                    ,'mmyyyy'))
                                and last_day(to_date('12'||to_number(p_anno)
                                                     ,'mmyyyy'))
        and pere.competenza      in ('P','C','A')
        and pere.servizio         = 'Q'
        and pere.gestione      like p_gestione
        and not exists              (select 'x' from denuncia_cp
                                      where anno       = to_number(p_anno)
                                        and gestione   = pere.gestione
                                        and previdenza = trpr.previdenza
                                        and ci         = rare.ci
                                    )
        and trpr.codice (+)       = pere.trattamento
        and trpr.previdenza    like p_previdenza
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = pere.ci
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = p_ente
                          and ambiente    = p_ambiente
                          and utente      = p_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
      group by pere.ci,trpr.previdenza
     ;
     commit;
 -- Creazione delle registrazioni di servizio Rilevanza = 'S'
     lock table denuncia_cp in exclusive mode nowait
     ;
     insert into denuncia_cp
          ( anno
          , previdenza
          , ci
          , gestione
          , codice
          , posizione
          , rilevanza
          , dal
          , al
          , ore
          , tipo_contratto
          , tipo_cessazione
          )
     select decp.anno
          , decp.previdenza
          , decp.ci
          , decp.gestione
          , decp.codice
          , decp.posizione
          , 'S'
          , greatest( p.dal
                    , decp.dal
                    , to_date('01'||decp.anno,'mmyyyy')-1
                    , decode(pa.rilevanza,'P',pa.dal,pa.al+1)) dal
          , decode
           ( least( nvl(p.al,to_date('3333333','j'))
                  , nvl(a.dal-1,to_date('3333333','j'))
                  , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                , to_date('3333333','j')
                                , decp.al)
                  , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                  )
           , to_date('0201'||(decp.anno+1),'ddmmyyyy'), to_date(null)
           , to_date('3333333','j'), to_date(null)
                                   , least( nvl(p.al,to_date('3333333','j'))
                                          , decode( decp.al
                                                  , to_date('3112'||decp.anno
                                                           ,'ddmmyyyy')
                                                  , to_date('3333333','j')
                                                  , decp.al)
                                          , nvl(a.dal-1,to_date('3333333','j')))
           )                                                   al
           , substr(max(to_char(s.dal,'yyyymmdd')||s.ore),9)
           , max(decode( posi.contratto_formazione
                   , 'NO', null
                         , decode( least( to_date('3112'||decp.anno,'ddmmyyyy')
                                        , s.dal)
                                 , s.dal, 'L'
                                        , 'F')))
          , max(decode
           ( least( nvl(p.al,to_date('3333333','j'))
                  , nvl(a.dal-1,to_date('3333333','j'))
                  , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                , to_date('3333333','j')
                                , decp.al)
                  , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                  )
           , to_date('0201'||(decp.anno+1),'ddmmyyyy'), ' '
           , to_date('3333333','j'), ' '
                , decode( nvl(instr(upper(evra.descrizione),'PENSION'),199)
                        ,199, 'C'
                        ,  0, 'C'
                            , 'P')
           ))
        from eventi_giuridici  evgi
           , eventi_rapporto   evra
           , astensioni        aste
           , astensioni        ast2
           , posizioni         posi
           , periodi_giuridici pa
           , periodi_giuridici p
           , periodi_giuridici a
           , periodi_giuridici s
           , denuncia_cp      decp
       where decp.anno      = to_number(p_anno)
         and decp.rilevanza = 'X'
         and decp.dal      <= to_date('3112'||decp.anno,'ddmmyyyy')
         and nvl(decp.al,to_date('3333333','j')) >= to_date('0101'||decp.anno
                                                            ,'ddmmyyyy')
         and p.rilevanza   = 'P'
         and p.ci          = decp.ci
         and (   pa.rilevanza = 'P'
              or pa.rilevanza = 'A' and
                 pa.al is not null)
         and pa.ci         = p.ci
         and greatest( p.dal
                     , decp.dal
                     , to_date('01'||decp.anno,'mmyyyy')-1
                     , decode(pa.rilevanza,'P',pa.dal,pa.al+1)) <=
             least( nvl(p.al,to_date('3333333','j'))
                   , nvl(a.dal-1,to_date('3333333','j'))
                   , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                 , to_date('3333333','j')
                                 , decp.al)
                   , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                   )
         and pa.dal       <= nvl(p.al,to_date('3333333','j'))
         and p.dal        <= nvl(pa.al,to_date('3333333','j'))
         and p.dal <= nvl(decp.al,to_date('3333333','j'))
         and nvl(p.al,to_date('3333333','j')) >= decp.dal
         and s.rilevanza = 'S'
         and s.ci = p.ci
         and greatest( p.dal
                     , to_date('01'||decp.anno,'mmyyyy')
                     , decode(pa.rilevanza,'P',pa.dal,pa.al+1))
             between s.dal and nvl(s.al,to_date('3112'||decp.anno,'ddmmyyyy'))
         and a.ci            = pa.ci
         and a.rilevanza     = 'A'
         and a.dal =
            (select min(dal)
               from periodi_giuridici pegi
              where ci        = p.ci
                and rilevanza = 'A'
                and dal       > pa.dal
                and dal      <= nvl(p.al,to_date('3333333','j'))
                and dal      <= to_date('3112'||decp.anno,'ddmmyyyy')
                and nvl(al,to_date('3333333','j')) >=
                                to_date('0101'||decp.anno,'ddmmyyyy')
                and exists (select 'x' from astensioni
                             where evento = pegi.evento
                               and codice = pegi.assenza
                               and servizio = 0)
            )
         and evra.codice (+) = p.posizione
         and evgi.codice (+) = a.evento
         and nvl(aste.evento,a.evento) = a.evento
         and aste.codice (+) = a.assenza
         and nvl(aste.servizio,0) = 0
         and nvl(ast2.evento,pa.evento) = pa.evento
         and ast2.codice (+) = pa.assenza
         and nvl(ast2.servizio,0) = 0
         and posi.codice (+) = s.posizione
       group by decp.anno
              , decp.previdenza
              , decp.ci
              , decp.gestione
              , decp.codice
              , decp.posizione
              , greatest( p.dal
                        , decp.dal
                        , to_date('01'||decp.anno,'mmyyyy')-1
                        , decode(pa.rilevanza,'P',pa.dal,pa.al+1))
              , decode
               ( least( nvl(p.al,to_date('3333333','j'))
                      , nvl(a.dal-1,to_date('3333333','j'))
                      , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                    , to_date('3333333','j')
                                    , decp.al)
                      , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                      )
               , to_date('0201'||(decp.anno+1),'ddmmyyyy'), to_date(null)
               , to_date('3333333','j'), to_date(null)
                                       , least( nvl(p.al,to_date('3333333','j'))
                                              , decode( decp.al
                                                      , to_date('3112'||decp.anno
                                                               ,'ddmmyyyy')
                                                      , to_date('3333333','j')
                                                      , decp.al)
                                              , nvl(a.dal-1,to_date('3333333','j')))
           )
UNION
     select decp.anno
          , decp.previdenza
          , decp.ci
          , decp.gestione
          , decp.codice
          , decp.posizione
          , 'S'
          , greatest( p.dal
                    , decp.dal
                    , to_date('01'||decp.anno,'mmyyyy')-1
                    , decode(pa.rilevanza,'P',pa.dal,pa.al+1)) dal
          , decode
           ( least( nvl(p.al,to_date('3333333','j'))
                  , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                , to_date('3333333','j')
                                , decp.al)
                  , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                  )
           , to_date('0201'||(decp.anno+1),'ddmmyyyy'), to_date(null)
           , to_date('3333333','j'), to_date(null)
                                   , least( nvl(p.al,to_date('3333333','j'))
                                          , decode( decp.al
                                                  , to_date('3112'||decp.anno
                                                           ,'ddmmyyyy')
                                                  , to_date('3333333','j')
                                                  , decp.al)
                                          , to_date('3333333','j'))
           )                                                   al
           , substr(max(to_char(s.dal,'yyyymmdd')||s.ore),9)
           , max(decode( posi.contratto_formazione
                   , 'NO', null
                         , decode( least( to_date('3112'||decp.anno,'ddmmyyyy')
                                        , s.dal)
                                 , s.dal, 'L'
                                        , 'F')))
          , max(decode
           ( least( nvl(p.al,to_date('3333333','j'))
                  , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                , to_date('3333333','j')
                                , decp.al)
                  , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                  )
           , to_date('0201'||(decp.anno+1),'ddmmyyyy'), ' '
           , to_date('3333333','j'), ' '
                , decode( nvl(instr(upper(evra.descrizione),'PENSION'),199)
                        ,199, 'C'
                            ,  0, 'C'
                                , 'P')
           ))
        from eventi_giuridici  evgi
           , eventi_rapporto   evra
           , astensioni        aste
           , posizioni         posi
           , periodi_giuridici pa
           , periodi_giuridici p
           , periodi_giuridici s
           , denuncia_cp      decp
       where decp.anno      = to_number(p_anno)
         and decp.rilevanza = 'X'
         and decp.dal      <= to_date('3112'||decp.anno,'ddmmyyyy')
         and nvl(decp.al,to_date('3333333','j')) >= to_date('0101'||decp.anno
                                                            ,'ddmmyyyy')
         and p.rilevanza   = 'P'
         and p.ci          = decp.ci
         and (   pa.rilevanza = 'P'
              or pa.rilevanza = 'A' and
                 pa.al is not null)
         and pa.ci         = p.ci
         and greatest( p.dal
                     , decp.dal
                     , to_date('01'||decp.anno,'mmyyyy')-1
                     , decode(pa.rilevanza,'P',pa.dal,pa.al+1)) <=
             least( nvl(p.al,to_date('3333333','j'))
                   , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                 , to_date('3333333','j')
                                 , decp.al)
                   , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                   )
         and pa.dal       <= nvl(p.al,to_date('3333333','j'))
         and p.dal        <= nvl(pa.al,to_date('3333333','j'))
         and p.dal <= nvl(decp.al,to_date('3333333','j'))
         and nvl(p.al,to_date('3333333','j')) >= decp.dal
         and s.rilevanza = 'S'
         and s.ci = p.ci
         and greatest( p.dal
                     , to_date('01'||decp.anno,'mmyyyy')
                     , decode(pa.rilevanza,'P',pa.dal,pa.al+1))
             between s.dal and nvl(s.al,to_date('3112'||decp.anno,'ddmmyyyy'))
         and not exists
            (select 'x'
               from periodi_giuridici pegi
              where ci        = p.ci
                and rilevanza = 'A'
                and dal       > pa.dal
                and dal      <= nvl(p.al,to_date('3333333','j'))
                and dal      <= to_date('3112'||decp.anno,'ddmmyyyy')
                and nvl(al,to_date('3333333','j')) >=
                                to_date('0101'||decp.anno,'ddmmyyyy')
                and exists (select 'x'
                              from astensioni
                             where evento = pegi.evento
                               and codice = pegi.assenza
                               and servizio = 0)
            )
         and evra.codice (+) = p.posizione
         and posi.codice (+) = s.posizione
         and evgi.codice (+) = pa.evento
         and nvl(aste.evento,pa.evento) = pa.evento
         and aste.codice (+) = pa.assenza
         and nvl(aste.servizio,0) = 0
       group by decp.anno
              , decp.previdenza
              , decp.ci
              , decp.gestione
              , decp.codice
              , decp.posizione
              , greatest( p.dal
                        , decp.dal
                        , to_date('01'||decp.anno,'mmyyyy')-1
                        , decode(pa.rilevanza,'P',pa.dal,pa.al+1))
              , decode
               ( least( nvl(p.al,to_date('3333333','j'))
                      , decode( decp.al, to_date('3112'||decp.anno,'ddmmyyyy')
                                    , to_date('3333333','j')
                                    , decp.al)
                      , to_date('0201'||(decp.anno+1),'ddmmyyyy')
                      )
               , to_date('0201'||(decp.anno+1),'ddmmyyyy'), to_date(null)
               , to_date('3333333','j'), to_date(null)
                                       , least( nvl(p.al,to_date('3333333','j'))
                                              , decode( decp.al
                                                      , to_date('3112'||decp.anno
                                                               ,'ddmmyyyy')
                                                      , to_date('3333333','j')
                                                      , decp.al)
                                              , to_date('3333333','j'))
           )
     ;
    commit;
      update denuncia_cp decp
         set tipo_cessazione = ''
       where decp.anno      = to_number(p_anno)
         and decp.rilevanza = 'S'
         and al is not null
         and al != (select max(nvl(al,to_date('3333333','j')))
                      from denuncia_cp
                     where anno = decp.anno
                       and rilevanza = 'S'
                       and ci = decp.ci
                   )
      ;
 -- Creazione delle registrazioni di retribuzione Rilevanza = 'R'
     lock table denuncia_cp in exclusive mode nowait
     ;
BEGIN
  FOR rci IN
    (select decp.anno
          , decp.previdenza
          , decp.ci
          , decp.gestione
          , decp.codice
          , decp.posizione
          , greatest( esvc1.dal
                    , greatest( to_date('01'||to_char(decp.anno),'mmyyyy')
                              , decp.dal)) dal
          , decp.al al
          , esvc.estrazione      estrazione
          , esvc.colonna         colonna
          , max(esvc.moltiplica) moltiplica
          , max(esvc.arrotonda)  arrotonda
          , max(esvc.divide)     divide
          , max(greatest(nvl(esvc1.al,to_date('3333333','j')),
                         nvl(decp.al,to_date('3333333','j')))) alp
       from estrazione_valori_contabili esvc
          , estrazione_valori_contabili esvc1
          , denuncia_cp                 decp
       where decp.anno        = to_number(p_anno)
         and decp.rilevanza   = 'X'
         and decp.dal        <= to_date('3112'||to_char(decp.anno),'ddmmyyyy')
         and nvl(decp.al,to_date('3333333','j'))
                             >= to_date('0101'||to_char(decp.anno),'ddmmyyyy')
         and esvc.estrazione  = 'DENUNCIA_CP'
         and esvc.colonna    in ('RAC','CONTRIBUTI')
         and esvc1.estrazione = 'DENUNCIA_CP'
         and esvc1.colonna   in ('RAC','CONTRIBUTI')
         and to_date('01'||to_char(decp.anno),'mmyyyy')
                        between esvc.dal
                            and nvl(esvc.al,to_date('3333333','j'))
         and esvc1.dal       <= to_date('3112'||to_char(decp.anno),'ddmmyyyy')
       group by decp.anno,decp.previdenza,decp.ci
              , decp.gestione,decp.codice,decp.posizione
           ,esvc.estrazione,esvc.colonna,esvc.sequenza
          , greatest( esvc1.dal
                    , greatest( to_date('01'||to_char(decp.anno),'mmyyyy')
                              , decp.dal))
          , decp.al
       order by decp.anno,decp.previdenza,decp.ci,decp.gestione
               ,decp.codice,decp.posizione,esvc.sequenza
    ) LOOP
    IF rci.colonna = 'RAC' THEN
     insert into denuncia_cp
          ( anno
          , previdenza
          , ci
          , gestione
          , codice
          , posizione
          , rilevanza
          , dal
          , al
          , importo
          )
     select rci.anno
          , rci.previdenza
          , rci.ci
          , rci.gestione
          , rci.codice
          , rci.posizione
          , 'R'
          , rci.dal
          , rci.al al
          , ( round( (sum(vaca.valore)
                    * nvl(rci.moltiplica,1))
                    / nvl(rci.arrotonda,0.01)
                   )* nvl(rci.arrotonda,0.01)
            ) / nvl(rci.divide,1) valore
        from valori_contabili_annuali    vaca
       where vaca.anno       = rci.anno
         and vaca.mese       = 12
         and vaca.mensilita  = (select max(mensilita) from mensilita
                                 where mese = 12)
         and vaca.ci         = rci.ci
         and vaca.estrazione = rci.estrazione
         and vaca.colonna    = rci.colonna
         and nvl(vaca.valore,0) != 0
         and vaca.riferimento between rci.dal and rci.alp
      ;
    ELSIF rci.colonna = 'CONTRIBUTI' then
     update denuncia_cp decp
        set contributi
          = (select nvl(
            (round( (sum(decode( rci.anno
                                ,to_char(vaca.riferimento,'yyyy')
                                ,vaca.valore,0)) *
                      nvl(rci.moltiplica,1))
                    / nvl(rci.arrotonda,0.01)
                   )* nvl(rci.arrotonda,0.01)
            ) / nvl(rci.divide,1)
                        ,decp.contributi)
        from valori_contabili_annuali    vaca
       where vaca.anno       = rci.anno
         and vaca.mese       = 12
         and vaca.mensilita  = (select max(mensilita) from mensilita
                                 where mese = 12)
         and vaca.ci         = rci.ci
         and vaca.estrazione = rci.estrazione
         and vaca.colonna    = rci.colonna
         and nvl(vaca.valore,0) != 0
         and vaca.riferimento between rci.dal and rci.alp
       )
       where decp.anno       = rci.anno
         and decp.rilevanza  = 'R'
         and decp.gestione   = rci.gestione
         and decp.previdenza = rci.previdenza
         and nvl(decp.posizione,' ')  = nvl(rci.posizione,' ')
         and decp.ci         = rci.ci
         and decp.dal        = rci.dal
     ;
    END IF;
  END LOOP;
END;
     commit;
 -- Integrazione al Minimale delle registrazioni con Rilevanza = 'R'
     lock table denuncia_cp in exclusive mode nowait
     ;
     update denuncia_cp decp1 set decp1.importo =
           (select round(trunc(sum(esrc.dato1 / 360 *
                  (trunc(months_between( last_day( nvl( decp.al
                                                      , to_date('12'||decp.anno
                                                               ,'mmyyyy'))
                                                 )+1
                                       , last_day(decp.dal)
                                       )
                        )*30
                  +(30-least(to_number(to_char(decp.dal,'dd')),30)+1)
                  -(30-least(to_number(to_char(nvl( decp.al
                                                  , to_date('3112'||decp.anno
                                                           ,'ddmmyyyy'))
                                              ,'dd')
                                      ),30)))
                                   )) / nvl(max(esvc.arrotonda),0.01))
                                    * nvl(max(esvc.arrotonda),0.01)
              from denuncia_cp decp
                 , estrazione_valori_contabili esvc
                 , estrazione_righe_contabili  esrc
             where decp.anno       = decp1.anno
               and decp.previdenza = decp1.previdenza
               and decp.ci         = decp1.ci
               and decp.rilevanza  = 'S'
               and esvc.estrazione = 'DENUNCIA_CP'
               and esvc.colonna    = 'MINIMALE_'||decp1.previdenza
               and to_date('01'||decp.anno,'mmyyyy')
                   between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
               and esrc.estrazione = esvc.estrazione
               and esrc.colonna    = esvc.colonna
               and esrc.dal        = esvc.dal
           )
      where decp1.anno      = to_number(p_anno)
        and decp1.rilevanza = 'R'
        and decp1.dal      <= to_date('01'||p_anno,'mmyyyy')
        and exists (select 'x' from denuncia_cp
                     where anno       = decp1.anno
                       and previdenza = decp1.previdenza
                       and ci         = decp1.ci
                       and rilevanza  = 'X')
        and decp1.importo   <
           (select round(trunc(sum(esrc.dato1 / 360 *
                  (trunc(months_between( last_day( nvl( decp.al
                                                      , to_date('12'||decp.anno
                                                               ,'mmyyyy'))
                                                 )+1
                                       , last_day(decp.dal)
                                       )
                        )*30
                  +(30-least(to_number(to_char(decp.dal,'dd')),30)+1)
                  -(30-least(to_number(to_char(nvl( decp.al
                                                  , to_date('3112'||decp.anno
                                                           ,'ddmmyyyy'))
                                              ,'dd')
                                      ),30)))
                                   )) / nvl(max(esvc.arrotonda),0.01))
                                    * nvl(max(esvc.arrotonda),0.01)
              from denuncia_cp decp
                 , estrazione_valori_contabili esvc
                 , estrazione_righe_contabili  esrc
             where decp.anno       = decp1.anno
               and decp.previdenza = decp1.previdenza
               and decp.ci         = decp1.ci
               and decp.rilevanza  = 'S'
               and esvc.estrazione = 'DENUNCIA_CP'
               and esvc.colonna    = 'MINIMALE_'||decp1.previdenza
               and to_date('01'||decp.anno,'mmyyyy')
                   between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
               and esrc.estrazione = esvc.estrazione
               and esrc.colonna    = esvc.colonna
               and esrc.dal        = esvc.dal
           )
     ;
     commit;
 -- Creazione delle registrazioni di retribuzione Rilevanza = 'A'
BEGIN
  FOR rci IN
    (select decp.anno
          , decp.previdenza
          , decp.ci
          , decp.gestione
          , decp.codice
          , decp.posizione
          , esvc1.dal
          , nvl(esvc1.al,to_date('3112'||to_char(decp.anno),'ddmmyyyy')) al
          , min(esvc.dal)                            esvc_dal
          , max(nvl(esvc.al,to_date('3333333','j'))) esvc_al
          , esvc.estrazione      estrazione
          , esvc.colonna         colonna
          , max(esvc.moltiplica) moltiplica
          , max(esvc.arrotonda)  arrotonda
          , max(esvc.divide)     divide
       from estrazione_valori_contabili esvc
          , estrazione_valori_contabili esvc1
          , denuncia_cp                 decp
       where decp.anno       = to_number(p_anno)
         and decp.rilevanza  = 'X'
         and esvc.estrazione = 'DENUNCIA_CP'
         and esvc.colonna   in ('ARR','CONTRIBUTI_ARR')
         and esvc1.estrazione = 'DENUNCIA_CP'
         and esvc1.colonna  in ('ARR','CONTRIBUTI_ARR')
       group by decp.anno,decp.previdenza,decp.ci,decp.gestione
              , decp.codice,decp.posizione
              , esvc.estrazione,esvc.colonna,esvc.sequenza
              , esvc1.dal
              , nvl(esvc1.al,to_date('3112'||to_char(decp.anno),'ddmmyyyy'))
       order by decp.anno,decp.previdenza,decp.ci,decp.gestione
              , decp.codice,decp.posizione
              , esvc.estrazione,esvc.colonna,esvc.sequenza
    ) LOOP
    IF rci.colonna = 'ARR' THEN
     insert into denuncia_cp
          ( anno
          , previdenza
          , ci
          , gestione
          , codice
          , posizione
          , rilevanza
          , dal
          , al
          , importo
          , riferimento
          )
     select rci.anno
          , rci.previdenza
          , rci.ci
          , rci.gestione
          , rci.codice
          , rci.posizione
          , 'A'
          , rci.dal
          , decode( decode( to_char(vaca.riferimento,'yyyy')
                          , vaca.anno, to_char(vaca.anno - 1)
                                     , to_char(riferimento,'yyyy'))
                  , rci.anno-1, least(rci.al,to_date('3112'||to_char(rci.anno-1)
                                                    ,'ddmmyyyy'))
                            , rci.al)
          , ( round( (sum(vaca.valore)
                    * nvl(rci.moltiplica,1))
                    / nvl(rci.arrotonda,0.01)
                   )* nvl(rci.arrotonda,0.01)
            ) / nvl(rci.divide,1) valore
          , decode( to_char(vaca.riferimento,'yyyy')
                  , vaca.anno, to_char(vaca.anno - 1)
                             , to_char(riferimento,'yyyy')) rif
        from valori_contabili_annuali    vaca
       where vaca.anno       = rci.anno
         and vaca.mese       = 12
         and vaca.mensilita  = (select max(mensilita) from mensilita
                                 where mese = 12)
         and vaca.ci         = rci.ci
         and vaca.estrazione = rci.estrazione
         and vaca.colonna    = rci.colonna
         and vaca.riferimento between rci.esvc_dal and rci.esvc_al
         and vaca.riferimento between rci.dal      and rci.al
         and nvl(vaca.valore,0) != 0
     group by decode( to_char(vaca.riferimento,'yyyy')
                    , vaca.anno, to_char(vaca.anno - 1)
                               , to_char(riferimento,'yyyy'))
     ;
   ELSIF rci.colonna = 'CONTRIBUTI_ARR' THEN
     update denuncia_cp decp
        set contributi
          = (select nvl(
                        ( round( sum(vaca.valore)
                                * nvl(rci.moltiplica,1)
                                / nvl(rci.arrotonda,0.01)
                               )* nvl(rci.arrotonda,0.01)
                        ) / nvl(rci.divide,1)
                       ,decp.contributi)
        from valori_contabili_annuali    vaca
       where vaca.anno       = rci.anno
         and vaca.mese       = 12
         and vaca.mensilita  = (select max(mensilita) from mensilita
                                 where mese = 12)
         and vaca.ci         = rci.ci
         and vaca.estrazione = rci.estrazione
         and vaca.colonna    = rci.colonna
         and vaca.riferimento between rci.esvc_dal and rci.esvc_al
         and vaca.riferimento between rci.dal      and rci.al
         and nvl(vaca.valore,0) != 0
         and decp.riferimento= decode( to_char(vaca.riferimento,'yyyy')
                                     , vaca.anno, to_char(vaca.anno - 1)
                                                , to_char(vaca.riferimento,'yyyy'))
       )
       where decp.anno       = rci.anno
         and decp.rilevanza  = 'A'
         and decp.gestione   = rci.gestione
         and decp.previdenza = rci.previdenza
         and nvl(decp.posizione,' ')  = nvl(rci.posizione,' ')
         and decp.ci         = rci.ci
         and decp.dal        = rci.dal
     ;
   END IF;
  END LOOP;
END;
     commit;
	 begin
 -- Cancellazione delle registrazioni di appoggio Rilevanza = 'X'
      lock table denuncia_cp in exclusive mode nowait
      ;
      delete from denuncia_cp
       where anno = to_number(p_anno)
         and rilevanza = 'X'
      ;
      delete from denuncia_cp x
       where anno = to_number(p_anno)
         and rilevanza = 'R'
         and nvl(importo,0) = 0
         and not exists
            (select 'x' from denuncia_cp
              where anno = x.anno
                and ci   = x.ci
                and rilevanza = 'S')
      ;
      delete from denuncia_cp x
       where anno = to_number(p_anno)
         and rilevanza = 'A'
         and nvl(importo,0) = 0
      ;
      commit;
   end;
   end;
   end;
   end;
/

