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

drop synonym N_STAMPA ;
drop synonym N_PRENOTAZIONE ;
drop synonym A_SELEZIONE ;
drop synonym A_SEQUENZE_MENU ;
drop synonym A_ACCESSI ;
drop synonym A_AIUTI_ERRORE ;
drop synonym A_AMBIENTI  ;
drop synonym A_APPLICAZIONI ;
drop synonym A_APPOGGIO_STAMPE  ;
drop synonym A_CAMPI_VISTE_ELENCHI ;
drop synonym A_CATALOGO_STAMPE  ;
drop synonym A_CLASSI_STAMPA  ;
drop synonym A_CODE_ELENCHI ;
drop synonym A_COLONNE_ELENCO ;
drop synonym A_CONDIZIONI_ELENCHI ;
drop synonym A_COMPETENZE ;
drop synonym A_DIRITTI_ACCESSO ;
drop synonym A_DOMINI_SELEZIONI ;
drop synonym A_DUAL ;
drop synonym A_ELENCHI ;
drop synonym A_EMULAZIONI ;
drop synonym A_ENTI  ;
drop synonym A_ERRORI  ;
drop synonym A_FUNZIONI_CHIAMATE;
drop synonym A_GRUPPI_LAVORO ;
drop synonym A_GRUPPI_LINGUISTICI ;
drop synonym A_GUIDE_O ;
drop synonym A_GUIDE_V ;
drop synonym A_HELP;
drop synonym A_INDICI_AIUTO ;
drop synonym A_ISTANZE_AMBIENTE ;
drop synonym A_MARGINI_STAMPA ;
drop synonym A_MENU  ;
drop synonym A_MODI_STAMPA ;
drop synonym A_OGGETTI ;
drop synonym A_PARAMETRI ;
drop synonym A_PARAMETRI_ELENCHI ;
drop synonym A_PARAMETRI_INSTALLAZIONE ;
drop synonym A_PARAMETRI_SCHED;
drop synonym A_PASSI_PROC ;
drop synonym A_PERSONALIZZAZIONI ;
drop synonym A_PRENOTAZIONI ;
drop synonym A_PRENOTAZIONI_LOG ;
drop synonym A_RUOLI ;
drop synonym A_SEGNALAZIONI_ERRORE ;
drop synonym A_SELEZIONI ;
drop synonym A_SEQUENZE_EMULAZIONE  ;
drop synonym A_SETTAGGI_STAMP;
drop synonym A_STAMPANTI ;
drop synonym A_STAMPE;
drop synonym A_TESTATE_ELENCHI ;
drop synonym A_TESTI_HELP ;
drop synonym A_UTENTI ;
drop synonym A_VISTE_ELENCHI ;
drop synonym A_VOCI_MENU ;
drop synonym A_V_PARAMETRI ;
drop synonym A_V_SELEZIONI ;
drop synonym A_V_UTENTI ;
drop synonym A00_REF_CODES ;
drop synonym A_COMUNI ;
drop synonym A_PROVINCIE ;
drop synonym A_REGIONI ;
drop synonym A_STATI_TERRITORI ;