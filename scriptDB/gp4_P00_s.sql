REM
REM FILE
REM 
REM PURPOSE
REM   Creazione SYNONYM per table legate ad altri Ambienti.                 
REM 
REM TOP TITLE
REM   
REM 
REM DESCRIPTION
REM   Lancio del file SQL*Plus per creazione SYNONYM su ambiente A00 
REM   e ambiente P00 (principale) e GRANT e SYNONYM su Ambienti Esterni.
REM 
REM NOTES
REM 
REM 
REM MODIFIED
REM 
REM


PROMPT Argomento 1 = Utente di Ambiente
column C1 noprint new_value P1

select '&1' C1
  from dual
;

create synonym N_STAMPA for &P1.N_STAMPA;
create synonym N_PRENOTAZIONE for &P1.N_PRENOTAZIONE;
create synonym A_SELEZIONE for &P1.A_SELEZIONE;
create synonym A_SEQUENZE_MENU for &P1.A_SEQUENZE_MENU;
create synonym A_ACCESSI for &P1.A_ACCESSI;
create synonym A_AIUTI_ERRORE for &P1.A_AIUTI_ERRORE;
create synonym A_AMBIENTI for &P1.A_AMBIENTI;
create synonym A_APPLICAZIONI for &P1.A_APPLICAZIONI;
create synonym A_APPOGGIO_STAMPE for &P1.A_APPOGGIO_STAMPE;
create synonym A_CAMPI_VISTE_ELENCHI for &P1.A_CAMPI_VISTE_ELENCHI;
create synonym A_CATALOGO_STAMPE for &P1.A_CATALOGO_STAMPE;
create synonym A_CLASSI_STAMPA for &P1.A_CLASSI_STAMPA;
create synonym A_CODE_ELENCHI for &P1.A_CODE_ELENCHI;
create synonym A_COLONNE_ELENCO for &P1.A_COLONNE_ELENCO;
create synonym A_CONDIZIONI_ELENCHI for &P1.A_CONDIZIONI_ELENCHI;
create synonym A_COMPETENZE for &P1.A_COMPETENZE;
create synonym A_DIRITTI_ACCESSO for &P1.A_DIRITTI_ACCESSO;
create synonym A_DOMINI_SELEZIONI for &P1.A_DOMINI_SELEZIONI;
create synonym A_DUAL for &P1.A_DUAL;
create synonym A_ELENCHI for &P1.A_ELENCHI;
create synonym A_EMULAZIONI for &P1.A_EMULAZIONI;
create synonym A_ENTI for &P1.A_ENTI;
create synonym A_ERRORI for &P1.A_ERRORI;
create synonym A_FUNZIONI_CHIAMATE for &P1.A_FUNZIONI_CHIAMATE;
create synonym A_GRUPPI_LAVORO for &P1.A_GRUPPI_LAVORO;
create synonym A_GRUPPI_LINGUISTICI for &P1.A_GRUPPI_LINGUISTICI;
create synonym A_GUIDE_O for &P1.A_GUIDE_O;
create synonym A_GUIDE_V for &P1.A_GUIDE_V;
create synonym A_HELP for &P1.A_HELP;
create synonym A_INDICI_AIUTO for &P1.A_INDICI_AIUTO;
create synonym A_ISTANZE_AMBIENTE for &P1.A_ISTANZE_AMBIENTE;
create synonym A_MARGINI_STAMPA for &P1.A_MARGINI_STAMPA;
create synonym A_MENU for &P1.A_MENU;
create synonym A_MODI_STAMPA for &P1.A_MODI_STAMPA;
create synonym A_OGGETTI for &P1.A_OGGETTI;
create synonym A_PARAMETRI for &P1.A_PARAMETRI;
create synonym A_PARAMETRI_ELENCHI for &P1.A_PARAMETRI_ELENCHI;
create synonym A_PARAMETRI_INSTALLAZIONE for &P1.A_PARAMETRI_INSTALLAZIONE;
create synonym A_PARAMETRI_SCHED for &P1.A_PARAMETRI_SCHED;
create synonym A_PASSI_PROC for &P1.A_PASSI_PROC;
create synonym A_PERSONALIZZAZIONI for &P1.A_PERSONALIZZAZIONI;
create synonym A_PRENOTAZIONI for &P1.A_PRENOTAZIONI;
create synonym A_PRENOTAZIONI_LOG for &P1.A_PRENOTAZIONI_LOG;
create synonym A_RUOLI for &P1.A_RUOLI;
create synonym A_SEGNALAZIONI_ERRORE for &P1.A_SEGNALAZIONI_ERRORE;
create synonym A_SELEZIONI for &P1.A_SELEZIONI;
create synonym A_SEQUENZE_EMULAZIONE for &P1.A_SEQUENZE_EMULAZIONE;
create synonym A_SETTAGGI_STAMP for &P1.A_SETTAGGI_STAMP;
create synonym A_STAMPANTI for &P1.A_STAMPANTI;
create synonym A_STAMPE for &P1.A_STAMPE;
create synonym A_STAMPEWEB for &P1.A_STAMPEWEB;
create synonym A_TESTATE_ELENCHI for &P1.A_TESTATE_ELENCHI;
create synonym A_TESTI_HELP for &P1.A_TESTI_HELP;
create synonym A_UTENTI for &P1.A_UTENTI;
create synonym A_VISTE_ELENCHI for &P1.A_VISTE_ELENCHI;
create synonym A_VOCI_MENU for &P1.A_VOCI_MENU;
create synonym A_V_PARAMETRI for &P1.A_V_PARAMETRI;
create synonym A_V_SELEZIONI for &P1.A_V_SELEZIONI;
create synonym A_V_UTENTI for &P1.A_V_UTENTI;
create synonym A00_REF_CODES for &P1.A00_REF_CODES;
create synonym A_COMUNI for &P1.A_COMUNI;
create synonym A_PROVINCIE for &P1.A_PROVINCIE;
create synonym A_REGIONI for &P1.A_REGIONI;
create synonym A_STATI_TERRITORI for &P1.A_STATI_TERRITORI;
create synonym A_ERRORI_APPLICAZIONI for &P1.A_ERRORI_APPLICAZIONI;
create synonym SI4_REGISTRO	   for &P1.REGISTRO;
create synonym si4_MENUMENUTE	   for &P1.MENUMENUTE;
create synonym SI4_REGISTRO_UTILITY  for &P1.REGISTRO_UTILITY;
create synonym SI4_tree	   	   for &P1.si4_tree;
create synonym ASTESTUT	   	   for &P1.ASTESTUT;



PROMPT
PROMPT Connessione ad User Oracle da Installare
PROMPT
PROMPT
PROMPT Creazione Sinonimi su Ambiente di Sistema
PROMPT _________________________________________
PROMPT
PROMPT View COMUNI su Table A_COMUNI ...
start crv_comu.sql
PROMPT
PROMPT Creazione Sinonimo  GRUPPI_LINGUISTICI
create synonym GRUPPI_LINGUISTICI for a_gruppi_linguistici;
