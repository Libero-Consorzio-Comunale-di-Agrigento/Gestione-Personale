-- Nuova segnalazione per posi.collaboratore null
insert into A_ERRORI (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
values ('P05694', 'Pos.Giuridica Incompleta. Forzato COLLABORATORE=NO ', null, null, null);

-- ricompilazione PECCREIN in A19404
-- start crp_peccrein.sql

-- nuova vista riepilogativa 
start crv_viau.sql

-- Nuova vista utente per report retribuzioni inail
create or replace view stampa_utente_autoliq as
select anno
      ,gestione
      ,posizione
      ,des_posizione
      ,pat
      ,voce_rischio
      ,des_voce_rischio
      ,percentuale_ponderazione
      ,esenzione
      ,tipo_ipn
      ,retribuzione
      ,retribuzione_parz_esente
      ,retribuzione_tot_esente
  from vista_autoliquidazione
 where anno = (select anno from riferimento_fine_anno)
   and tipo_ipn = 'C'
;

