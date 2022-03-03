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
