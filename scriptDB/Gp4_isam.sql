REM /******************************************************************************
REM  NOME:        GP4_isam
REM  DESCRIZIONE: Creazione istanza di ambiente
REM 
REM  ARGOMENTI:   1 IN User di DB
REM               2 IN Codice Ente di Provenienza
REM               3 IN Codice Ente di Default             
REM  
REM  ANNOTAZIONI: -
REM  REVISIONI:
REM  Rev. Data       Autore Descrizione
REM  ---- ---------- ------ ------------------------------------------------------
REM  0    18/05/2001 __     Prima emissione.
REM  1    30/08/2001 MF     Aggiunto insert di A_AMBIENTI eliminato da gp4_ins_menu
REM  2    15/09/2003 MF     Modificata insert in A_ISTANZE_AMBIENTE causa attivazione trigger
REM  3    10/10/2007 MS     Gestite insert con la not exists
REM ******************************************************************************/

INSERT INTO A_UTENTI 
( UTENTE, NOMINATIVO, PASSWORD, GRUPPO_LING, GRUPPO, DATA_PASSWORD, GIORNI_PASSWORD, ABIL_PASSWORD, IMPORTANZA, DATA_ACCESSO, TENTATIVI, TERMINALE, ACCESSI, STAT_ACCESSI, STAMPANTE, TENTATIVI_MAX)
SELECT 'GP4', 'GP4', NULL, '*', 'P', sysdate, NULL, 'S', 1, sysdate, 0, NULL, 0, 'N', NULL, NULL
  from dual
 where not exists ( select 'x'
                      from a_utenti
                     where ( utente = 'GP4' or nominativo = 'GP4' )
                  );

INSERT INTO A_GRUPPI_LAVORO 
( GRUPPO, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
select  'P', 'Gruppo P', NULL, NULL
  from dual 
 where not exists ( select 'x'
                      from a_gruppi_lavoro
                     where gruppo = 'P'
                  );

INSERT INTO A_AMBIENTI 
( AMBIENTE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
select 'P00', 'Ambiente del Personale', NULL, NULL
  from dual 
 where not exists ( select 'x'
                      from A_AMBIENTI 
                     where ambiente = 'P00'
                  );

INSERT INTO A_ISTANZE_AMBIENTE 
( ambiente, ente, gruppo_ling, descrizione
, user_oracle, password, dislocazione )
SELECT distinct 'P00', '&3', '*', 'Gestione Integrata del Personale '||'&2'
     , '&1', nvl(password_oracle,'X55') 
     , '\\[nome_server]\si4\gp4\gipv4-[disco_server]:\si4\gp4\gipv4\-[nr_coda_stampa]'
FROM  ad4_istanze 
where user_oracle='&1'
  and not exists ( select 'x' 
                     from A_ISTANZE_AMBIENTE 
                    where ambiente = 'P00'
                      and ente = '&3'
                      and gruppo_ling = '*'
                 );

INSERT INTO A_DIRITTI_ACCESSO 
( UTENTE, AMBIENTE, ENTE, GRUPPO_LING, APPLICAZIONE, RUOLO, SEQUENZA)
select 'GP4', 'P00', '&3', '*', 'GP4', 'AMM', NULL
  from dual
 where not exists ( select 'x' from A_DIRITTI_ACCESSO 
                      where UTENTE = 'GP4'
                        and AMBIENTE = 'P00'
                        and ENTE = '&3'
                        and GRUPPO_LING  = '*'
                  );

INSERT INTO A_RUOLI (RUOLO, DESCRIZIONE)
select 'PEC', 'Procedura Economico Contabile'
  from dual
 where not exists ( select 'x' 
                      from a_ruoli
                     where ruolo = 'PEC'
                  );
 