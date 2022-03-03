CREATE OR REPLACE VIEW VISTA_DOCUMENTI_GIURIDICI AS
SELECT adog.ci
      ,adog.evento documento
      ,gp4_evgi.get_descrizione (adog.evento) descrizione_documento
      ,adog.scd tipo_documento
      ,sodo.descrizione descrizione_tipo_documento
      ,sodo.nota_del
      ,adog.del
      ,sodo.nota_descrizione
      ,adog.descrizione
      ,adog.sede_del
      ,adog.numero_del
      ,adog.anno_del
      ,adog.dal
      ,adog.al
      ,adog.rilascio
      ,sodo.nota_numero
      ,adog.numero
      ,sodo.nota_categoria
      ,adog.categoria
      ,sodo.nota_presso
      ,adog.presso
      ,adog.provincia cod_provincia
      ,adog.comune cod_comune
      ,gp4_comu.get_descrizione (adog.provincia, adog.comune) denominazione_comune
      ,gp4_comu.get_sigla_provincia (adog.provincia, adog.comune) sigla_provincia
      ,adog.scadenza
      ,adog.rinnovo
      ,adog.note
      ,sodo.nota_n1
      ,adog.dato_n1
      ,sodo.nota_n2
      ,adog.dato_n2
      ,sodo.nota_n3
      ,adog.dato_n3
      ,sodo.nota_a1
      ,adog.dato_a1
      ,sodo.nota_a2
      ,adog.dato_a2
      ,sodo.nota_a3
      ,adog.dato_a3
      ,adog.utente
      ,adog.data_agg
  FROM archivio_documenti_giuridici adog
      ,sottocodici_documento sodo
 WHERE NOT EXISTS (SELECT 'x'
                     FROM a_oggetti
                    WHERE oggetto = 'GP.EVENTO.PROTETTO.' || adog.evento)
   AND sodo.codice = adog.scd
   AND sodo.evento = adog.evento
/

