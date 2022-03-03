CREATE OR REPLACE PACKAGE pipeecip IS
/******************************************************************************
 NOME:          PIPEECIP
 DESCRIZIONE:   Estrazione movimenti liquidati nella mensilita' di riferimento per
                successiva creazione elle voci economiche - Aggiornamento dell'impegno
                di spesa.
                Questa fase consente l'estrazione dei movimenti liquidati per il passaggio
                automatico all'Economico Contabile nonche' la registrazione sui movimenti
                estratti dell'informazione relativa all'impegno di spesa relativamente
                il finanziamento del progetto.
                L'estrazione e` effettuata per gli individui liquidati per i progetti sele-
                zionati. (solo stato Esecutivo o Terminato)
                La tavola in accesso e` MOVIMENTI_INCENTIVO ; da tale tavola sara`
                estratto il movimento e sara` operata la registrazione della sequenza
                e il ruolo relativi all'impegno di spesa per il progetto di appartenenza
                (con tale operazione si intende evidenziare che il movimento e' gia stato
                estratto e contabilizzato in disponibilita' di finanziamento.
                La registrazione del movimento estratto viene effettuata su DEPOSITO_VARIA-
                BILI_INCENTIVO.
                Il programma ripassa tutto quanto esiste di liquidato nel mese di riferi- 
                mento per il progetto/i richiesto/i; non tiene conto di precedenti emissio-
                ni in quanto azzera sequenza e ruolo di impegno per i movimenti relativi
                al progetto, elaborati nel mese, e gia` emessi (questo nel caso comunque
                i movimenti non siano stati gia' prelevati da PEC - flag = 'SI' e tabella
                deposito_variabili_incentivo vuota.
                i movienti non sono emessi se non esiste riga di sequenza per finanz.
                Se si esaurisce in corso di emissione oppure e' gia' esaurito passa comunque
                con maggior sequenza disponibile o maggior sequenza in assoluto

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

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

CREATE OR REPLACE PACKAGE BODY pipeecip IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;
	   procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	DECLARE
D_utente       varchar2(8);
D_ini_mes      date;
D_fin_mes      date;
D_m_rif        number(2);
D_a_rif        number(4);
D_aa_rif_e     number(4);
D_mm_rif_e     number(2);
D_progetto     varchar2(8);
D_dummy        varchar2(2);
D_ci           number;
D_dal          date;
D_al           date;
D_cifra_emessa number;
D_importo_regi number;
USCITA         EXCEPTION;
ERRORE         EXCEPTION;
D_sequenza     number(9);
D_importo      number;
D_anno_bil     number(4);
D_capitolo     varchar2(14);
D_articolo     varchar2(14);
D_sede_del     varchar2(2);
D_anno_del     number(4);
D_numero_del   number(7);
D_max          varchar2(2);
D_stato_pec    varchar2(2);
D_segnale      varchar2(1);
D_variabili_gipe number(2);
D_verifica     number(4);
D_rif_ret      varchar2(1);
BEGIN
        --
        -- Estrazione Parametri di Selezione della Prenotazione
  BEGIN
      select nvl(max(valore),'%')
        into D_progetto
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_PROGETTO'
      ;
  EXCEPTION
    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
  /* Valore non valido per parametro */
   update a_prenotazioni set errore = 'A00313'
        ,prossimo_passo = 99
    where no_prenotazione = prenotazione
   ;
      RAISE ERRORE;
  END;
  BEGIN
      select nvl(variabili_gipe,0)
        into D_variabili_gipe
        from ente
      ;
  EXCEPTION
    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
  /* Registrazione di Integrazione Sottosistemi Assente */
   update a_prenotazioni set errore = 'P00530'
        ,prossimo_passo = 99
    where no_prenotazione = prenotazione
   ;
      RAISE ERRORE;
  END;
  BEGIN
      select ini_mes
           , fin_mes
           , mese
           , anno
           , to_number(to_char(add_months(fin_mes,D_variabili_gipe),'yyyy'))
           , to_number(to_char(add_months(fin_mes,D_variabili_gipe),'mm'))
        into D_ini_mes,
             D_fin_mes,
             D_m_rif,
             D_a_rif,
             D_aa_rif_e,
             D_mm_rif_e
        from riferimento_incentivo
       where riip_id = 'RIIP'
      ;
  EXCEPTION
    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
  /* Errore selezione riferimento incentivo */
   update a_prenotazioni set errore = 'P06000'
        ,prossimo_passo = 99
    where no_prenotazione = prenotazione
   ;
      RAISE ERRORE;
  END;
  BEGIN
      select utente
        into D_utente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
  EXCEPTION
    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
  /* Valore non valido per parametro */
   update a_prenotazioni set errore = 'A00313'
        ,prossimo_passo = 99
    where no_prenotazione = prenotazione
   ;
      RAISE ERRORE;
  END;
  BEGIN                      -- Verifica Progetti richiesti
     select count(*)
       into D_verifica
       from dual
      where exists (select 'x'
                      from applicazioni_incentivo
                     where progetto like D_progetto
                       and stato in ('E','T')
                   )
     ;
  IF D_verifica = 0 THEN
          /* Progetto non previsto o in stato non consentito */
          update a_prenotazioni set errore = 'P06091'
                                  , prossimo_passo = 99
           where no_prenotazione = prenotazione
          ;
          RAISE ERRORE;
  END IF;
  END;
/*  BEGIN                      -- Testo per congruenza periodi PEC PIP
    select 'x'
      into D_rif_ret
      from riferimento_retribuzione
     where D_aa_rif_e = anno
       and D_mm_rif_e = mese
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN */
  /* Movimenti Incompatibili con Mensilita Economico */
/*   update a_prenotazioni set errore = 'P06905'
        ,prossimo_passo = 99
    where no_prenotazione = prenotazione
   ;
    RAISE ERRORE;
  END; */
  BEGIN                      -- Test per verifica esecutibilita` estrazione
    select stato_pec
      into D_stato_pec
      from riferimento_incentivo
     where riip_id = 'RIIP'
    ;
    IF D_stato_pec = 'NO'
      THEN              -- Estrazione dati per emmissione a Economico Contab.
                        -- non gestita
        /* Estrazione Movimenti non Gestita */
        update a_prenotazioni set errore = 'P06906'
                                , prossimo_passo = 99
         where no_prenotazione = prenotazione
        ;
        RAISE ERRORE;
    END IF;
    IF D_stato_pec = 'OK'
      THEN              -- Controlla se ci sono movimenti per a/m nella tabella
                        -- di passaggio; solo in tal caso puo` essere
                        -- ripetuta l'estrazione
        BEGIN
        select 'x'
          into D_segnale
          from deposito_variabili_incentivo
         where rownum < 2
           and to_char(anno)||to_char(mese) =
               to_char(D_aa_rif_e)||to_char(D_mm_rif_e)
        ;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN   -- tabella vuota
          /* Movimenti gia` integrati in economico - Impossibile ripetere */
          update a_prenotazioni set errore = 'P06825'
                                  , prossimo_passo = 99
           where no_prenotazione = prenotazione
          ;
          RAISE;
        END;
        BEGIN                      -- Ripristino movimenti eventualmente
                                   -- gia` emessi in pagamento
                                   -- per a/m
                                   -- nb. fin_mes costruisce d_aa_rif_e
                                   --     e d_mm_rif_e + mesi differenza per PEC
            update movimenti_incentivo
               set ruolo_impegno    = null,
                   sequenza_impegno = null
             where progetto         like D_progetto
               and ruolo_impegno    is    not null
               and sequenza_impegno is    not null
               and periodo          =    D_fin_mes
            ;
            delete from deposito_variabili_incentivo
             where progetto like D_progetto
               and to_char(anno)||to_char(mese) =
                   to_char(D_aa_rif_e)||to_char(D_mm_rif_e)
            ;
        END;
  END IF;
  END;
  --
  -- Ciclo per ogni registrazione di servizio e incarico sul Progetto
  --
  FOR CURS IN
    (select progetto,scp,parte,fondo
       from applicazioni_incentivo apip
          , parti_applicative paip
      where progetto like D_progetto
        and exists (select 'x' from movimenti_incentivo
                     where progetto = apip.progetto
                       and periodo = D_fin_mes )
        and paip.codice = apip.parte
        and stato in ('E','T')
    )
  LOOP
  BEGIN                      -- Trattamento Progetto
    FOR CURR IN              -- Cursore per ruolo
      (select distinct ruolo
         from impegni_progetto_incentivo ipip
        where progetto = curs.progetto
          and scp      = curs.scp
          and exists (select 'x' from movimenti_incentivo
                       where progetto         = curs.progetto
                         and scp              = curs.scp
                         and ruolo            like ipip.ruolo
                         and sequenza_impegno is null
                         and ruolo_impegno    is null
                         and periodo          = D_fin_mes))
    LOOP
    BEGIN                    -- Trattamento Ruolo
      BEGIN                  -- Cerca la minor sequenza ,per quel ruolo,
                             -- con disponibilita`
        select sequenza,importo,
               anno_bil,capitolo,articolo,
               anno_del,numero_del,sede_del
          into D_sequenza,D_importo,D_anno_bil,D_capitolo,D_articolo,
               D_anno_del,D_numero_del,D_sede_del
          from impegni_progetto_incentivo ipip
         where progetto = curs.progetto
           and scp      = curs.scp
           and ruolo    = curr.ruolo
           and sequenza = (select min(sequenza)
                             from impegni_progetto_incentivo
                            where progetto = curs.progetto
                              and scp      = curs.scp
                              and ruolo    = curr.ruolo
                              and nvl(importo,0) >
                           (select nvl(sum(nvl(liquidato,0)+nvl(saldo,0)),0)
                              from movimenti_incentivo
                             where progetto = curs.progetto
                               and scp      = curs.scp
                               and ruolo like ipip.ruolo
                               and sequenza_impegno = ipip.sequenza
                               and ruolo_impegno    = ipip.ruolo
                               and sequenza_impegno is not null
                               and ruolo_impegno    is not null)
                           )
                    ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN -- non ci sono sequenze con disponibilita'
        BEGIN
                             -- prende la max in assoluto per il ruolo
                             -- controllare se ne esiste almeno una!
          select sequenza,importo,
                 anno_bil,capitolo,articolo,
                 anno_del,numero_del,sede_del
            into D_sequenza,D_importo,D_anno_bil,D_capitolo,D_articolo,
                 D_anno_del,D_numero_del,D_sede_del
            from impegni_progetto_incentivo
           where progetto    = curs.progetto
             and scp         = curs.scp
             and ruolo       = curr.ruolo
             and sequenza    = (select max(sequenza)
                                  from impegni_progetto_incentivo
                                 where progetto = curs.progetto
                                   and scp      = curs.scp
                                   and ruolo    = curr.ruolo
                               )
          ;
            D_max := 'SI';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              /* Finanziamento non indicato per il Ruolo - Emissione Impossibile
              */
              update a_prenotazioni
                 set errore = 'P06123'
                   , prossimo_passo = 2
               where no_prenotazione = prenotazione
              ;
              RAISE USCITA;    -- Simulazione uscita dal LOOP
          END;
      END;
                             -- Sono in possesso di una sequenza
                             -- seleziona D_cifra_emessa (come somma di moip)
      BEGIN
      select nvl(sum(nvl(liquidato,0)+nvl(saldo,0)),0)
        into D_cifra_emessa
        from movimenti_incentivo
       where progetto = curs.progetto
         and scp      = curs.scp
         and ruolo like curr.ruolo
         and sequenza_impegno = D_sequenza
         and ruolo_impegno    = curr.ruolo
      ;
      END;
      FOR MOIP IN
        (select distinct moip.ci,moip.anno,moip.mese,
                         nvl(grp.flag_voce,'Y') flag_voce,
                         decode(moip.calcolo,'S','S','A') tipo
           from movimenti_incentivo moip
               ,gruppi_incentivo grp
          where progetto      = curs.progetto
            and scp           = curs.scp
            and ruolo      like curr.ruolo
            and periodo       = D_fin_mes
            and ruolo_impegno is null
            and sequenza_impegno is null
            and grp.codice    = moip.gruppo)
      LOOP
        BEGIN                      -- ciclo per trattamento singolo
                                   -- movimento
          D_importo_regi := 0;
          FOR REGI IN
            (select nvl(liquidato,0)+nvl(saldo,0) importo,
                    rowid
               from movimenti_incentivo
              where ci       = moip.ci
                and progetto = curs.progetto
                and scp      = curs.scp
                and ruolo like curr.ruolo
                and periodo  = D_fin_mes
                and mese     = moip.mese
                and anno     = moip.anno
                and gruppo in (select codice from gruppi_incentivo
                                where nvl(flag_voce,'Y') = moip.flag_voce)
                and decode(calcolo,'S','S','A') = moip.tipo)
          LOOP
            BEGIN            -- Aggiornamento impegno su movimento emesso
               update movimenti_incentivo
                  set ruolo_impegno    = curr.ruolo,
                      sequenza_impegno = D_sequenza
                where rowid = regi.rowid
               ;
            END;
            D_importo_regi := D_importo_regi + regi.importo;
            D_cifra_emessa := D_cifra_emessa + regi.importo;
            IF  D_cifra_emessa >= D_importo   -- sfondamento
            AND D_max != 'SI'
              THEN           -- segnalazione di sfondamento
                /*Finanziamento inferiore a Residuo da Liquidare */
                update a_prenotazioni
                   set errore = 'P06103'
                 where no_prenotazione = prenotazione
                ;
                             -- scrivo_file_deposito_variabili_incentivo
                             -- quindi emetto comunque il movimento
                insert into deposito_variabili_incentivo
                ( ANNO, MESE, CI, FONDO, PARTE, PROGETTO, SCP, TIPO
                , IMPORTO, ANNO_BIL, CAPITOLO, ARTICOLO, SEDE_DEL
                , ANNO_DEL, NUMERO_DEL, C_ANNO, C_MESE, FLAG_VOCE 
                )
                       values (D_aa_rif_e,D_mm_rif_e,moip.ci,curs.fondo,
                       curs.parte,curs.progetto,curs.scp,moip.tipo,
                       D_importo_regi,D_anno_bil,D_capitolo,D_articolo,
                       D_sede_del,D_anno_del,D_numero_del,moip.anno,
                       moip.mese,moip.flag_voce)
                ;
                D_importo_regi := 0;         --  azzero valore emissione
                D_cifra_emessa := 0;         --  azzero somma_importo
                BEGIN        -- cerco altra sequenza (come sopra)
                             -- controllando che ce ne siano disponibili
                             -- altrimenti tenendo l'ultima
                  select sequenza,importo,
                         anno_bil,capitolo,articolo,
                         anno_del,numero_del,sede_del
                    into D_sequenza,D_importo,D_anno_bil,D_capitolo,D_articolo,
                         D_anno_del,D_numero_del,D_sede_del
                    from impegni_progetto_incentivo ipip
                   where progetto =    curs.progetto
                     and scp      =    curs.scp
                     and ruolo    =    curr.ruolo
                     and sequenza = (select min(sequenza)
                                       from impegni_progetto_incentivo
                                      where progetto = curs.progetto
                                        and scp      = curs.scp
                                        and ruolo    = curr.ruolo
                                        and nvl(importo,0) >
                                            (select nvl(sum(nvl(liquidato,0)+
                                                    nvl(saldo,0)),0)
                                               from movimenti_incentivo
                                              where progetto = curs.progetto
                                                and scp      = curs.scp
                                                and ruolo like ipip.ruolo
                                                and sequenza_impegno =
                                                    ipip.sequenza
                                                and ruolo_impegno    =
                                                    ipip.ruolo)
                                    )
                  ;
                IF D_sequenza IS NULL THEN
                             -- prende la max in assoluto per il ruolo
                             -- controllare se ne esiste almeno una!
                  select sequenza,importo,anno_bil,capitolo,articolo,
                         anno_del,numero_del,sede_del
                    into D_sequenza,D_importo,D_anno_bil,D_capitolo,D_articolo,
                         D_anno_del,D_numero_del,D_sede_del
                    from impegni_progetto_incentivo
                   where progetto    = curs.progetto
                     and scp         = curs.scp
                     and ruolo       = curr.ruolo
                     and sequenza    = (select max(sequenza)
                                          from impegni_progetto_incentivo
                                         where progetto = curs.progetto
                                           and scp      = curs.scp
                                           and ruolo    = curr.ruolo
                                       )
                  ;
                  IF D_sequenza IS NULL THEN
                    /* Finanziamento non indicato per il Ruolo
                       - Emissione Impossibile */
                     update a_prenotazioni
                        set errore          = 'P06123'
                          , prossimo_passo  = 2
                      where no_prenotazione = prenotazione
                     ;
                     RAISE USCITA;    -- Simulazione uscita dal LOOP
                  ELSE
                     D_max := 'SI';
                  END IF;
                END IF;
                END;
                             -- seleziona D_cifra_emessa (come somma di moip)
                BEGIN
                  select nvl(sum(nvl(liquidato,0)+nvl(saldo,0)),0)
                    into D_cifra_emessa
                    from movimenti_incentivo
                   where progetto = curs.progetto
                     and scp      = curs.scp
                     and ruolo like curr.ruolo
                     and sequenza_impegno = D_sequenza
                     and ruolo_impegno    = curr.ruolo
                  ;
                END;
            END IF;
          END LOOP;          -- fine loop per regi - registr. su moip
        IF D_importo_regi != 0
          THEN               --  registro deposito_variabili_incentivo
            insert into deposito_variabili_incentivo
                ( ANNO, MESE, CI, FONDO, PARTE, PROGETTO, SCP, TIPO
                , IMPORTO, ANNO_BIL, CAPITOLO, ARTICOLO, SEDE_DEL
                , ANNO_DEL, NUMERO_DEL, C_ANNO, C_MESE, FLAG_VOCE 
                )
                   values (D_aa_rif_e,D_mm_rif_e,moip.ci,curs.fondo,
                   curs.parte,curs.progetto,curs.scp,moip.tipo,
                   D_importo_regi,D_anno_bil,D_capitolo,D_articolo,
                   D_sede_del,D_anno_del,D_numero_del,moip.anno,
                   moip.mese,moip.flag_voce)
            ;
        END IF;                -- Considero valida la sequenza che ho in
                               -- linea che e' sempre l'ultima corrente e
                               -- corretta
        END;                        -- fine begin per raggr. moip
      END LOOP;                     -- fine loop per moip
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
            /* Finanziamento non indicato per il Ruolo - Emissione Impossibile
            */
            update a_prenotazioni
               set errore = 'P06123'
                 , prossimo_passo = 2
             where no_prenotazione = prenotazione
               and not exists (select 'x' from impegni_progetto_incentivo
                                where progetto = curs.progetto
                                  and scp = curs.scp
                                  and ruolo like curr.ruolo)
            ;
            RAISE USCITA;    -- Simulazione uscita dal LOOP
      WHEN USCITA THEN EXIT;
    END;                            -- fine begin per ruolo,sequenza
    END LOOP;                       -- fine loop su ruolo
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;
  END LOOP;                         -- fine loop su applicazioni
update riferimento_incentivo
   set stato_pec = 'OK'
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
  WHEN ERRORE THEN NULL;
END;
--
-- Fine operazioni di Funzione
--
DECLARE
D_prossimo_passo               number;
BEGIN
  select prossimo_passo
    into D_prossimo_passo
    from a_prenotazioni
   where no_prenotazione = prenotazione
  ;
  IF D_prossimo_passo IS NULL
    THEN                     -- Aggiorna prossimo_passo = 3 per lista
                             -- e per evitare elenco sfondamenti
    update a_prenotazioni
       set prossimo_passo = 3
     where no_prenotazione = prenotazione
    ;
  END IF;
END;
end;
end;
/

