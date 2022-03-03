-- =================================================================
-- Grant degli oggetti dell utente SIA a User CHILD P00
-- =================================================================

grant all on vista_operazioni_replica to &1 with grant option;

grant all on dati_replica to &1 with grant option;

grant execute on REPLAYEXEC to &1 with grant option;

grant execute on REPLAYSET to &1 with grant option;
