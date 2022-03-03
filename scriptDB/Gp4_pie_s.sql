-- =================================================================
-- creazione dei sinonimi agli oggetti dell utente SIA
-- =================================================================

PROMPT Argomento 1 = User DataBase PARENT

create synonym vista_operazioni_replica for &1.vista_operazioni_replica;

create synonym dati_replica for &1.dati_replica;

create synonym REPLAYEXEC for &1.REPLAYEXEC;

create synonym REPLAYSET for &1.REPLAYSET;
