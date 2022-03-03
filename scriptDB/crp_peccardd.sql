CREATE OR REPLACE PACKAGE peccardd IS
/******************************************************************************
 NOME:        PECCADRDD
 DESCRIZIONE: Creazione delle registrazioni annuali individuali per la fase di stampa
              della denuncia annuale Inadel.
              Questa funzione inserisce nelle tavole DENUNCIA_INADEL e
              DENUNCIA_IMPORTI_INADEL le registrazioni relative ad ogni individuo
              che ha prestato servizio nell'anno richiesto o per il quale e` stato
              pagato un contributo INADEL.
              Una funzione successiva fornira` un tabulato per la compilazione
              della denuncia annuale INADEL.
              Nella tavola DENUNCIA_INADEL verra` inserita una registrazione per
              dipendente contenente le informazioni sul servizio prestato e gli
              eventi di assenza (ASTE.MAT_ANZ = 0).
              Nella tavola DENUNCIA_IMPORTI_INADEL invece verra` inserita una regi-
              strazione per ogni codice emolumento INADEL, sia corrente che arretra-
              to, il relativo importo e l'eventuale anno di riferimento.
              L'importo della retribuzione da dichiarare si ottiene dal campo VALORE
              della tabella VALORI_CONTABILI_ANNUALI da cui e` possibile leggere
              il progressivo al mese che interessa. La tabella infatti contiene i
              valori precalcolati di tutte le colonne definite in
              ESTRAZIONE_VALORI_CONTABILI.
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Il PARAMETRO D_tipo determina il tipo di elaborazione da effettuare.
               Il PARAMETRO D_gestione determina le gestioni da elaborare
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccardd IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
DECLARE
  D_ente      VARCHAR2(4);
  D_ambiente  VARCHAR2(8);
  D_utente    VARCHAR2(8);
  D_anno      number;
  D_mensilita VARCHAR2(4);
  D_tipo      VARCHAR2(1);
  D_gestione  VARCHAR2(1);
  D_count_ass number;
  D_data_ass  date;
  D_data_pass date;
  D_data_cess date;
  D_tp        VARCHAR2(1);
  D_qualifica number;
  D_posizione VARCHAR2(4);
  p_messaggio VARCHAR2(240) := 'Inizio Elaborazione CARDD';
BEGIN
  D_tipo     := null;
  D_ente     := null;
  D_utente   := null;
  D_ambiente := null;
   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
      BEGIN
      select substr(valore,1,1)
        into D_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TIPO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_tipo      := 'T';
      END;
      BEGIN
      select valore
        into D_gestione
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GESTIONE'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_gestione  := '%';
      END;
      BEGIN
      select ente
           , utente
           , ambiente
        into D_ente,D_utente,D_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_ente      := null;
              D_ambiente  := null;
              D_utente    := null;
      END;
   END;
   BEGIN  -- Preleva Anno di Riferimento Fine Anno per archiviazione
      select anno
        into D_anno
        from riferimento_fine_anno
       where rifa_id = 'RIFA'
      ;
      select max(mensilita)
        into D_mensilita
        from mensilita
       where mese = 12
      ;
   END;
   BEGIN  -- Cancellazione Archiviazione precedente relativa allo stesso anno
     p_messaggio := 'Cancellazione Archiviazione';
     lock table denuncia_importi_inadel in exclusive mode nowait
     ;
     delete from denuncia_importi_inadel diid
      where diid.anno            = D_anno
        and (    D_tipo = 'T'
              or (    not exists
                     (select 'x' from denuncia_importi_inadel
                       where anno = diid.anno
                         and ci   = diid.ci
                         and (    tipo_agg  = D_tipo
                              or (D_tipo     = 'P'          and
                                  tipo_agg is not null
                                 )
                             )
                     )
                  and not exists
                     (select 'x' from denuncia_inadel deid
                       where deid.anno              = diid.anno
                         and deid.ci                = diid.ci
                         and deid.gestione       like D_gestione
                         and (    tipo_agg  = D_tipo
                              or (D_tipo     = 'P'          and
                                  tipo_agg is not null
                                 )
                             )
                     )
                 )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = diid.ci
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = D_ente
                          and ambiente    = D_ambiente
                          and utente      = D_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
      ;
     lock table denuncia_inadel in exclusive mode nowait
     ;
     delete from denuncia_inadel deid
      where deid.anno             = D_anno
        and deid.gestione      like D_gestione
        and (   D_tipo = 'T'
             or not exists
               (select 'x' from denuncia_inadel
                 where anno = deid.anno
                   and ci   = deid.ci
                   and (   tipo_agg   = D_tipo
                        or (D_tipo     = 'P'      and
                            tipo_agg is not null
                           )
                       )
               )
            )
        and not exists
           (select 'x' from denuncia_importi_inadel
                 where anno = deid.anno
                   and ci   = deid.ci
           )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = deid.ci
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = D_ente
                          and ambiente    = D_ambiente
                          and utente      = D_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
     ;
      COMMIT;
   END;
   BEGIN -- Creazione delle registrazioni per la determinazione degli emolumenti
         -- annuali, correnti ed arretrati, per dipendente
     lock table denuncia_importi_inadel in exclusive mode nowait
     ;
     p_messaggio := 'Ciclo per periodi retributivi';
   FOR CURI IN
      (select pere.ci
            , substr(max(to_char(pere.dal,'j')||pere.gestione),8,4) gestione
         from periodi_retributivi pere
        where exists
             (select 'x' from movimenti_contabili moco
               where moco.ci        = pere.ci
                 and moco.anno      = D_anno
                 and (moco.voce,moco.sub) in
                    (select voce,sub from estrazione_righe_contabili
                      where estrazione = 'DENUNCIA_INADEL'
                        and colonna    = 'CONTRIBUTI'
                        and to_date('3112'||to_char(D_anno),'ddmmyyyy')
                                    between dal
                                        and nvl(al,to_date('3333333','j'))
                    )
                 and nvl(moco.tar,0)  != 0
             )
          and pere.periodo between last_day(to_date('01'||to_char(D_anno)
                                                   ,'mmyyyy'))
                               and last_day(to_date('12'||to_char(D_anno)
                                                   ,'mmyyyy'))
          and pere.competenza      in ('P','C','A')
          and pere.servizio         = 'Q'
          and pere.gestione      like D_gestione
          and exists
             (select 'x'
                from rapporti_individuali rain
               where rain.ci = pere.ci
                 and (   rain.cc is null
                      or exists
                        (select 'x'
                           from a_competenze
                          where ente        = D_ente
                            and ambiente    = D_ambiente
                            and utente      = D_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                        )
                     )
             )
      group by pere.ci
     ) LOOP
   BEGIN  -- Inserimento DENUNCIA_INADEL
      D_data_ass   := null;
      D_data_pass  := null;
      D_data_cess  := null;
      D_tp         := null;
      D_qualifica  := null;
      D_posizione  := null;
      --
      -- Selezione dati giuridici
      --
      BEGIN
      select min(dal)
        into D_data_ass
        from periodi_giuridici
       where ci        = CURI.ci
         and rilevanza = 'P'
         and dal       <= to_date('3112'||to_char(D_anno),'ddmmyyyy')
         and nvl(al,to_date('3333333','j')) >= to_date('01'||to_char(D_anno)
                                                      ,'mmyyyy')
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_data_ass := null;
      END;
      BEGIN
      select max(pegi.dal)
        into D_data_pass
        from periodi_giuridici pegi
       where pegi.ci         = CURI.ci
         and pegi.rilevanza  = 'S'
         and not exists (select 'x' from periodi_giuridici
                          where ci         = pegi.ci
                            and rilevanza  = 'S'
                            and al         < pegi.dal
                            and exists
                               (select 'x' from posizioni
                                 where codice = periodi_giuridici.posizione
                                   and ruolo  = 'SI'))
         and exists     (select 'x' from posizioni
                          where codice = pegi.posizione
                            and ruolo  = 'SI')
         and pegi.dal        <= to_date('3112'||to_char(D_anno),'ddmmyyyy')
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_data_pass := null;
      END;
      IF D_data_pass is null THEN
         BEGIN
           select min(pegi.dal)
             into D_data_pass
             from periodi_giuridici pegi
            where pegi.ci         = CURI.ci
              and pegi.rilevanza  = 'S'
              and pegi.dal       <= D_data_ass
              and pegi.dal       <= to_date('3112'||to_char(D_anno)
                                           ,'ddmmyyyy')
              and posizione      in (select codice from posizioni
                                      where ruolo = 'SI')
           ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_data_pass := null;
           END;
      END IF;
      BEGIN
      select pegi.al
        into D_data_cess
        from periodi_giuridici pegi
       where pegi.ci        = CURI.ci
         and pegi.rilevanza = 'P'
         and pegi.dal       = (select max(dal)
                                from periodi_giuridici
                                where ci        = pegi.ci
                                  and rilevanza = 'P'
                                  and dal <= to_date( '3112'||
                                                           to_char(D_anno)
                                                         , 'ddmmyyyy'))
     ;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             D_data_cess := null;
     END;
     BEGIN
     select decode(pegi.ore,null,null,'*')
          , pegi.qualifica
          , pegi.posizione
       into D_tp
          , D_qualifica
          , D_posizione
       from periodi_giuridici pegi
      where pegi.ci        = CURI.ci
        and pegi.rilevanza = 'S'
        and pegi.dal       = (select max(dal) from periodi_giuridici
                               where ci        = pegi.ci
                                 and rilevanza = 'S'
                                 and dal      <= to_date('3112'||to_char(D_anno)
                                                        ,'ddmmyyyy')
                             )
     ;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             D_qualifica := null;
             D_tp        := null;
             D_posizione := null;
     END;
     p_messaggio := 'Inserimento in denuncia Inadel';
     insert into denuncia_inadel
          ( anno
          , ci
          , gestione
          , codice
          , data_assunzione
          , data_passaggio
          , data_cessazione
          , qualifica
          , tp
          , posizione
          )
     select D_anno
          , CURI.ci
          , CURI.gestione
          , rare.codice_iad
          , D_data_ass
          , D_data_pass
          , D_data_cess
          , D_qualifica
          , D_tp
          , D_posizione
       from rapporti_retributivi rare
      where rare.ci               = CURI.ci
      ;
      commit;
      END;
   BEGIN  -- Aggiornamento DENUNCIA_INADEL per Aspettative
      D_count_ass := 0;
      p_messaggio := 'Ciclo per periodi di astensione';
      FOR CURA IN
         (select aste.codice
               , sum
                  (trunc
                     (months_between
                        ( last_day(least( to_date('3112'||to_char(D_anno)
                                                 ,'ddmmyyyy')
                                        , nvl(pegi.al,to_date('3333333','j'))
                                        )+1
                                  )
                        , last_day(greatest( pegi.dal
                                           , to_date('01'||to_char(D_anno)
                                                    ,'mmyyyy')
                                           )
                                  )
                     )*30
                    -least(30,to_number
                                (to_char
                                   (greatest(pegi.dal,to_date('01'||
                                                              to_char(D_anno)
                                                             ,'mmyyyy')
                                            ),'dd'))
                          )+1
                    +least(30,to_number
                                (to_char
                                   (least(to_date('3112'||to_char(D_anno)
                                                 ,'ddmmyyyy')
                                         ,nvl(pegi.al,to_date('3333333','j'))
                                         )+1,'dd'))
                    -1)
                    )) gg
            from astensioni        aste
               , periodi_giuridici pegi
           where pegi.ci        = CURI.ci
             and pegi.rilevanza = 'A'
             and pegi.dal      <= to_date('3112'||to_char(D_anno),'ddmmyyyy')
             and nvl(pegi.al,to_date('3333333','j')) >= to_date('01'||
                                                                to_char(D_anno)
                                                                ,'mmyyyy')
             and aste.codice    = pegi.assenza
             and aste.mat_anz   = 0
          group by aste.codice
         ) LOOP
      BEGIN
         p_messaggio := 'Modifica riga di denuncia Inadel';
         D_count_ass := D_count_ass + 1;
         IF D_count_ass = 1 THEN
            update denuncia_inadel
               set cod_asp1 = CURA.codice
                 , gg_asp1  = CURA.gg
             where anno = D_anno
               and ci   = CURI.ci
            ;
         ELSIF
            D_count_ass = 2 THEN
            update denuncia_inadel
               set cod_asp2 = CURA.codice
                 , gg_asp2  = CURA.gg
             where anno = D_anno
               and ci   = CURI.ci
            ;
         ELSIF
            D_count_ass = 3 THEN
            update denuncia_inadel
               set cod_asp2 = CURA.codice
                 , gg_asp2  = CURA.gg
             where anno = D_anno
               and ci   = CURI.ci
            ;
         END IF;
      END;
   END LOOP;
   BEGIN  -- Inserimento DENUNCIA_IMPORTI_INADEL
     p_messaggio := 'Inserimento in denuncia importi Inadel';
     --
     -- Ciclo per ogni colonna di estrazione
     --
     FOR CURC IN
        (select colonna
              , moltiplica
              , arrotonda
              , divide
           from estrazione_valori_contabili
          where estrazione = 'DENUNCIA_INADEL'
            and to_date('3112'||to_char(D_anno),'ddmmyyyy')
                        between dal
                            and nvl(al,to_date('3333333','j'))
        ) LOOP
            insert into denuncia_importi_inadel
                 ( anno
                 , ci
                 , riferimento
                 , codice
                 , importo
                 )
            select D_anno
                 , CURI.ci
                 , decode( to_char(vaca.riferimento,'yyyy')
                          ,to_char(D_anno),null
                          ,to_char(vaca.riferimento,'yyyy')
                         )
                 , CURC.colonna
                 , ( round( (sum(vaca.valore) *
                             nvl(CURC.moltiplica,1))
                           / nvl(CURC.arrotonda,1)
                          )* nvl(CURC.arrotonda,1)
                   ) / nvl(CURC.divide,1) importo
               from valori_contabili_annuali    vaca
              where not exists  (select 'x' from denuncia_importi_inadel
                                  where anno   = D_anno
                                    and ci     = CURI.ci
                                    and codice = CURC.colonna)
                and vaca.anno       = D_anno
                and vaca.mese       = 12
                and vaca.mensilita  = (select max(mensilita) from mensilita
                                        where mese = 12)
                and vaca.ci         = CURI.ci
                and vaca.estrazione = 'DENUNCIA_INADEL'
                and vaca.colonna    = CURC.colonna
              group by to_char(vaca.riferimento,'yyyy')
             having nvl(sum(vaca.valore),0) != 0
            ;
          END LOOP;
    END;
   END;
     END LOOP;
   END;
END;
COMMIT;
end;
end;
/

