CREATE OR REPLACE PACKAGE PECXAGGP IS
/******************************************************************************
 NOME:        PECXAGGP 
 DESCRIZIONE: Aggiorna i campi attivita e tipo_rapporto di APERE leggendo da APESS
              e APESE eventuali modifihce successive al calcolo
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO P_inizio   determina l'inizio del periodo da trattare
               Il PARAMETRO P_fine     determina la fine  del periodo da trattare

 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  01/04/2005 MS       Prima emissione
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN   (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECXAGGP IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 01/04/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
P_ente            varchar2(4);
P_ambiente        varchar2(8);
P_utente          varchar2(8);
P_inizio          date;
P_fine            date;
P_gestione        varchar2(4);
P_rapporto        varchar2(4);
P_tipo            varchar2(1);
P_ci              number(8);
D_tipo_rapporto   varchar2(4);
D_attivita        varchar2(4);
D_riga            number(6) := 0;
D_testo           varchar2(200);
D_errore          varchar2(6);
V_comando         varchar(500);
USCITA            EXCEPTION;

 BEGIN
-- Estrazione parametri di elaborazione
   BEGIN
      select to_date(valore,'dd/mm/yyyy')
        into P_inizio
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_INIZIO'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
           BEGIN
             select ini_ela
               into P_inizio
               from riferimento_retribuzione;
           EXCEPTION WHEN NO_DATA_FOUND THEN
               D_errore := 'A05721';
               RAISE USCITA;
           END;
   END;
   BEGIN
      select to_date(valore,'dd/mm/yyyy')
        into P_fine
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_FINE'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
           BEGIN
             select fin_ela
               into P_fine
               from riferimento_retribuzione;
           EXCEPTION WHEN NO_DATA_FOUND THEN
               D_errore := 'A05721';
               RAISE USCITA;
           END;
   END;
   BEGIN
      select valore
        into P_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TIPO'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_tipo := to_char(null);
   END;
   BEGIN
 	select to_number(valore) D_ci
        into P_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_CI'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_ci := to_number(null);
   END;
   IF nvl(P_ci,0) = 0 and nvl(P_tipo,'X') = 'S' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
   ELSIF nvl(P_ci,0) != 0 and nvl(P_tipo,'X') = 'T' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
   END IF;
   BEGIN
      select valore
        into P_gestione
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GESTIONE'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_gestione := '%';
   END;
   BEGIN
      select valore
        into P_rapporto
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_RAPPORTO'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_gestione := '%';
   END;
   BEGIN
      select ente     D_ente
           , utente   D_utente
           , ambiente D_ambiente
        into P_ente, P_utente, P_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
   END;

-- creazione tabella di salvataggio
   BEGIN 
   v_comando := 'create table pere_prima_della_'||prenotazione
                 ||' as select * from periodi_retributivi where 1 = 0';
   si4.sql_execute(V_comando);
   END;

   BEGIN
     BEGIN
-- Inserimento Testata
      D_riga := 1;
      INSERT INTO a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione,1,1,D_riga,'Elenco individui modificati in APERE per tipo rapporto e/o attitiva'''
        from dual;
       D_riga := 2;
      INSERT INTO a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione,1,1,D_riga,lpad('-',70,'-')
        from dual;
     END;
     D_riga := 3;
   FOR CUR_CI IN 
   ( select ci, periodo, al, servizio, tipo_rapporto, attivita, 'TR' flag
       from periodi_retributivi pere
      where pere.periodo between P_inizio and P_fine
        and pere.competenza in ('A','C','P')
        and pere.posizione in ( select codice from posizioni where collaboratore = 'SI')
        and exists (select 'x' from periodi_giuridici pegi
                     where ci = pere.ci
                       and rilevanza = decode(pere.servizio,'I','E','S')
                       and nvl(tipo_rapporto,'NULL') != nvl(pere.tipo_rapporto,'NULL')
                       and pegi.dal = (select max(dal)
                                         from periodi_giuridici
                                        where ci = pegi.ci
                                          and rilevanza = pegi.rilevanza
                                          and dal <= pere.al
--                                          and greatest(pere.al,pere.periodo) between dal and nvl(al,pere.periodo)
--                                          and nvl(tipo_rapporto,'NULL') != nvl(pere.tipo_rapporto,'NULL')
                                       )
                   )
       and ( P_tipo = 'S' and ci = P_ci
          or P_tipo = 'T' and gestione like P_gestione
           )
       and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = pere.ci
               and rain.rapporto       like P_rapporto
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = P_ente
                          and ambiente    = P_ambiente
                          and utente      = P_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
     union
      select ci, periodo, al, servizio, tipo_rapporto, attivita, 'ATT' flag
       from periodi_retributivi pere
      where pere.periodo between P_inizio and P_fine
        and pere.competenza in ('A','C','P')
        and pere.posizione in ( select codice from posizioni where collaboratore = 'SI')
        and exists (select 'x' from periodi_giuridici pegi
                     where ci = pere.ci
                       and rilevanza = decode(pere.servizio,'I','E','S')
                       and nvl(attivita,'NULL') != nvl(pere.attivita,'NULL')
                       and pegi.dal = (select max(dal)
                                         from periodi_giuridici
                                        where ci = pegi.ci
                                          and rilevanza = pegi.rilevanza
                                          and dal <= pere.al
--                                          and greatest(pere.al,pere.periodo) between dal and nvl(al,pere.periodo)
--                                          and nvl(attivita,'NULL') != nvl(pere.attivita,'NULL')
                                       )
                   )
       and ( P_tipo = 'S' and ci = P_ci
          or P_tipo = 'T' 
          and gestione like P_gestione
           ) 
       and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = pere.ci
               and rain.rapporto       like P_rapporto
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = P_ente
                          and ambiente    = P_ambiente
                          and utente      = P_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
      order by 1
     ) LOOP

     BEGIN
-- salvataggio dati precedenti
       v_comando := 'insert into pere_prima_della_'||prenotazione||' 
                     select * from periodi_retributivi
                     where ci = '||CUR_CI.ci||'
                       and periodo = '''||CUR_CI.periodo||'''
                       and al = '''||CUR_CI.al||'''
                       and servizio = '''||CUR_CI.servizio||'''
                       and competenza in (''A'',''C'',''P'')';
         si4.sql_execute(V_comando);
     END;
     D_tipo_rapporto := null;
     D_attivita := null;
-- dbms_output.put_line('dati : '||cur_ci.ci||' '||cur_ci.periodo||' '||cur_ci.al||' '||cur_ci.servizio);
-- dbms_output.put_line('tr :'||nvl(cur_ci.tipo_rapporto,'xxxx'));
-- dbms_output.put_line('att :'||cur_ci.attivita);
    IF CUR_CI.flag = 'TR' THEN
-- dbms_output.put_line('Rettifica tipo rapporto');
     BEGIN
       select tipo_rapporto
         into D_tipo_rapporto
         from periodi_giuridici pegi
        where ci = CUR_CI.ci
          and rilevanza = decode(CUR_CI.servizio,'I','E','S')
          and pegi.dal = (select max(dal)
                            from periodi_giuridici
                           where ci = pegi.ci
                             and rilevanza = pegi.rilevanza
                             and dal <= CUR_CI.al
--                             and nvl(tipo_rapporto,'NULL') != nvl(CUR_CI.tipo_rapporto,'NULL')
                          )
          and nvl(tipo_rapporto,'NULL') != nvl(CUR_CI.tipo_rapporto,'NULL');
      EXCEPTION WHEN NO_DATA_FOUND THEN
          D_tipo_rapporto := 'NULL';
      END;
-- dbms_output.put_line('tr_new: '||D_tipo_rapporto);
      IF D_tipo_rapporto = 'NULL' THEN
-- Inserimento segnalazione dipendente NON trattato
          D_riga := nvl(D_riga,0) +1;
         BEGIN
          select rpad(substr(lpad(TO_CHAR(CUR_CI.ci),8,' ')||' - '||rain.cognome||' '||rain.nome,1,50),50,' ')
               ||' - Impossibile Trovare Tipo Rapporto per periodo '||to_char(CUR_CI.periodo,'dd/mm/yyyy')
            into D_testo
            from rapporti_individuali rain
           where ci = CUR_CI.ci;
          EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
          END;    
         INSERT INTO a_appoggio_stampe
         (no_prenotazione, no_passo, pagina, riga, testo)
         select prenotazione,1,1,D_riga,D_testo
           from dual
          where not exists (select 'x' from a_appoggio_stampe
                             where no_prenotazione = prenotazione
                               and passo  = 1
                               and pagina = 1
                               and testo  = D_testo
                           );
      ELSE 
-- Inserimento segnalazione dipendente trattato per tipo rapporto
      D_riga := nvl(D_riga,0) +1;
       BEGIN
        select rpad(substr(lpad(TO_CHAR(CUR_CI.ci),8,' ')||' - '||rain.cognome||' '||rain.nome,1,50),50,' ')
             ||' - Modificato tipo rapporto per periodo '||to_char(CUR_CI.periodo,'dd/mm/yyyy')
          into D_testo
          from rapporti_individuali rain
         where ci = CUR_CI.ci;
       EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
      INSERT INTO a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione,1,1,D_riga,D_testo
        from dual
      where not exists (select 'x' from a_appoggio_stampe
                         where no_prenotazione = prenotazione
                           and passo  = 1
                           and pagina = 1
                           and testo  = D_testo
                        );
      commit;
       update periodi_retributivi pere
          set tipo_rapporto = D_tipo_rapporto
        where pere.periodo  = CUR_CI.periodo
          and pere.al = CUR_CI.al
          and servizio = CUR_CI.servizio
          and pere.competenza in ('A','C','P')
          and pere.ci = CUR_CI.ci
         ;
      END IF; --D_tipo_rapporto
     commit;
   ELSE
-- dbms_output.put_line('Rettifica attivita');
     BEGIN
       select attivita
         into D_attivita
         from periodi_giuridici pegi
        where ci = CUR_CI.ci
          and rilevanza = decode(CUR_CI.servizio,'I','E','S')
          and pegi.dal = (select max(dal)
                            from periodi_giuridici
                           where ci = pegi.ci
                             and rilevanza = pegi.rilevanza
                             and dal <= CUR_CI.al
--                             and nvl(attivita,'NULL') != nvl(CUR_CI.attivita,'NULL')
                          )
          and nvl(attivita,'NULL') != nvl(CUR_CI.attivita,'NULL');
      EXCEPTION WHEN NO_DATA_FOUND THEN
          D_attivita := 'NULL';
      END;
-- dbms_output.put_line('att_new: '||D_attivita );
      IF D_attivita = 'NULL' THEN
-- Inserimento segnalazione dipendente NON trattato
          D_riga := nvl(D_riga,0) +1;
          BEGIN
          select rpad(substr(lpad(TO_CHAR(CUR_CI.ci),8,' ')||' - '||rain.cognome||' '||rain.nome,1,50),50,' ')
               ||' - Impossibile Trovare Attivita  per periodo '||to_char(CUR_CI.periodo,'dd/mm/yyyy')
            into D_testo
            from rapporti_individuali rain
           where ci = CUR_CI.ci;
          EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
          END;
      INSERT INTO a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione,1,1,D_riga,D_testo
        from dual
      where not exists (select 'x' from a_appoggio_stampe
                         where no_prenotazione = prenotazione
                           and passo  = 1
                           and pagina = 1
                           and testo  = D_testo
                        );
      ELSE 
-- Inserimento segnalazione dipendente trattato per attivita
      D_riga := nvl(D_riga,0) +1;
       BEGIN
        select rpad(substr(lpad(TO_CHAR(CUR_CI.ci),8,' ')||' - '||rain.cognome||' '||rain.nome,1,50),50,' ')
             ||' - Modificata attivita  per periodo '||to_char(CUR_CI.periodo,'dd/mm/yyyy')
          into D_testo
          from rapporti_individuali rain
         where ci = CUR_CI.ci;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
      END;
      INSERT INTO a_appoggio_stampe
      (no_prenotazione, no_passo, pagina, riga, testo)
      select prenotazione,1,1,D_riga,D_testo
        from dual
      where not exists (select 'x' from a_appoggio_stampe
                         where no_prenotazione = prenotazione
                           and passo  = 1
                           and pagina = 1
                           and testo  = D_testo
                        );
      commit;
       update periodi_retributivi pere
          set attivita = D_attivita
        where pere.periodo  = CUR_CI.periodo
          and pere.al = CUR_CI.al
          and servizio = CUR_CI.servizio
          and pere.competenza in ('A','C','P')
          and pere.ci = CUR_CI.ci
         ;
       END IF; -- D_attivita
     commit;
   END IF; -- flag
   END LOOP; -- cur_ci
  END;
 EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
 END;
END PECXAGGP;
/
