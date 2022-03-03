CREATE OR REPLACE VIEW VISTA_ASSEGNAZIONI_CONTABILI AS
SELECT asco.ci
      ,asco.dal
      ,asco.al
      ,vuor.gestione
      ,vuor.codice_unita_organizzative
      ,vuor.descr_unita_organizzative
      ,asco.settore
      ,vuor.revisione
      ,vuor.ni_unita_organizzative
      ,vuor.sudd_unita_organizzative
      ,asco.sede
      ,gp4_sdam.get_denominazione_numero (asco.sede) descrizione_sede_contabile
      ,rifu.funzionale
      ,gp4_clfu.get_descrizione(rifu.funzionale) descrizione_funzionale
      ,rifu.cdc
      ,gp4_ceco.get_descrizione(rifu.cdc) descrizione_cdc
      ,asco.QUOTA
      ,asco.intero
      ,asco.note
      ,ROUND (asco.QUOTA / asco.intero * 100, 2) percentuale_imputazione
      ,asco.utente utente_modifica
      ,asco.data_agg data_modifica
  FROM assegnazioni_contabili asco
      ,vista_unita_organizzative vuor
      ,ripartizioni_funzionali rifu
 WHERE asco.settore = vuor.numero_settore
   and vuor.stato_revisione = 'A'
   and asco.sede = rifu.sede
   and asco.settore = rifu.settore
/