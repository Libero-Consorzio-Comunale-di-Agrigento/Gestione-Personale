-- Nuova versione unificata di PPACDERI e PXIRISCD

-- Nuova selezione e passi procedurali

delete from a_passi_proc where voce_menu = 'PPACDERI';

delete from a_selezioni where voce_menu = 'PPACDERI';

insert into a_passi_proc
   (voce_menu
   ,passo
   ,titolo
   ,tipo
   ,modulo
   ,stringa
   ,stampa
   ,gruppo_ling)
values
   ('PPACDERI'
   ,'1'
   ,'Caricamento eventi rilevazione'
   ,'Q'
   ,'PPACDERI'
   ,''
   ,''
   ,'N');
insert into a_passi_proc
   (voce_menu
   ,passo
   ,titolo
   ,tipo
   ,modulo
   ,stringa
   ,stampa
   ,gruppo_ling)
values
   ('PPACDERI'
   ,'2'
   ,'Segnalazioni in Elaborazione'
   ,'R'
   ,'ACARAPPR'
   ,''
   ,'ACARAPPR'
   ,'N');
insert into a_passi_proc
   (voce_menu
   ,passo
   ,titolo
   ,tipo
   ,modulo
   ,stringa
   ,stampa
   ,gruppo_ling)
values
   ('PPACDERI'
   ,'3'
   ,'Cancellazione errori'
   ,'Q'
   ,'ACACANRP'
   ,''
   ,''
   ,'N');

insert into a_selezioni
   (parametro
   ,voce_menu
   ,sequenza
   ,descrizione
   ,lunghezza
   ,formato
   ,obbligo
   ,valore_default
   ,dominio
   ,alias
   ,gruppo_alias
   ,numero_fk)
values
   ('P_SOFTWARE'
   ,'PPACDERI'
   ,'0'
   ,'Codice software rilevazione'
   ,'8'
   ,'U'
   ,'S'
   ,'%'
   ,''
   ,''
   ,''
   ,'');

-- Nuovi codici di errore

insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P07401', 'Rif. Presenze non allineato al Rif. Retribuzione', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P07402', 'Esistono eventi non allineati al mese di riferimento', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P07403', 'Sono presenti registrazioni di origine diversa', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P07404', 'Non esistono registrazioni da caricare', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P07405', 'Codice individuale non determinabile in modo univoco', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P07406', 'Riferimento rettificato in base ai periodi giuridici e alla mensilita', null, null, null);
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P07407', 'Date di riferimento non compatibili con i periodi giuridici', null, null, null);

start crp_ppacderi.sql
-- il package pxiriscd è sostituito da ppacderi nuova versione
drop package pxiriscd;