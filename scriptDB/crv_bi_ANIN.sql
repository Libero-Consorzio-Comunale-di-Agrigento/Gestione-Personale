CREATE OR REPLACE VIEW VISTA_ANAGRAFICA_INDIVIDUI AS
SELECT anag.ni
      ,anag.cognome
      ,anag.nome
      ,anag.sesso
      ,anag.data_nas                               data_nascita
      ,anag.provincia_nas                          cod_provincia_nascita
      ,anag.comune_nas                             cod_comune_nascita
      ,cnas.denominazione                          descr_comune_nascita
      ,pnas.denominazione                          descr_provincia_nascita
      ,pnas.sigla                                  sigla_provincia_nascita
      ,anag.luogo_nas                              luogo_nascita
      ,anag.codice_fiscale
      ,anag.codice_fiscale_estero
      ,anag.partita_iva
      ,anag.cittadinanza
      ,stte.desc_cittadinanza                      descr_cittazinanza
      ,anag.gruppo_ling                            gruppo_linguistico
      ,anag.indirizzo_res                          indirizzo_residenza
      ,anag.provincia_res                          cod_provincia_residenza
      ,anag.comune_res                             cod_comune_residenza
      ,cres.denominazione                          descr_comune_residenza
      ,pres.denominazione                          descr_provincia_residenza
      ,pres.sigla                                  sigla_provincia_residenza
      ,anag.cap_res                                CAP_residenza
      ,anag.tel_res                                telefono_residenza
      ,anag.fax_res                                fax_residenza
      ,anag.presso                                 presso
      ,anag.indirizzo_dom                          indirizzo_domicilio
      ,anag.provincia_dom                          cod_provincia_domicilio
      ,anag.comune_dom                             cod_comune_domicilio
      ,cdom.denominazione                          descr_comune_domicilio
      ,pdom.denominazione                          descr_provincia_domicilio
      ,pdom.sigla                                  sigla_provincia_domicilio
      ,anag.cap_dom                                CAP_domicilio
      ,anag.tel_dom                                telefono_domicilio
      ,anag.fax_dom                                fax_domicilio
      ,anag.note
      ,anag.dal
      ,anag.al
      ,anag.stato_civile                           codice_stato_civile
      ,stci.descrizione                            descr_stato_civile
      ,anag.cognome_coniuge
      ,anag.titolo_studio                          codice_titolo_studio
      ,tist.descrizione                            descr_titolo_studio
      ,tipe.titolo                                 titolo_onorifico
      ,anag.categoria_protetta                     codice_categoria_protetta
      ,capr.descrizione                            descr_categoria_protetta
      ,anag.tessera_san                            numero_tessera_sanitaria
      ,anag.numero_usl                             numero_usl
      ,anag.provincia_usl                          provincia_usl
      ,anag.tipo_doc                               tipo_documento
      ,evgi.descrizione                            descr_tipo_documento
      ,anag.numero_doc                             numero_documento
      ,anag.provincia_doc                          provincia_documento
      ,anag.comune_doc                             comune_documento
      ,cdoc.denominazione                          descr_comune_documento
      ,pdoc.sigla                                  sigla_provincia_documento
      ,anag.utente                                 utente_modifica
      ,anag.data_agg                               data_modifica
      ,anag.telefono_ufficio
      ,anag.fax_ufficio
      ,anag.e_mail
      ,stato_cee
  FROM stati_civili stci
      ,titoli_studio tist
      ,titoli_personali tipe
      ,categorie_protette capr
      ,eventi_giuridici evgi
      ,a_comuni cdoc
      ,a_provincie pdoc
      ,a_comuni cnas
      ,a_provincie pnas
      ,a_stati_territori stte
      ,a_comuni cres
      ,a_provincie pres
      ,a_comuni cdom
      ,a_provincie pdom
      ,anagrafici anag
 WHERE stci.codice(+) = anag.stato_civile
   AND tist.codice(+) = anag.titolo_studio
   AND tipe.sequenza(+) = anag.titolo
   AND capr.codice(+) = anag.categoria_protetta
   AND evgi.codice(+) = anag.tipo_doc
   AND cdoc.provincia_stato(+) = anag.provincia_doc
   AND cdoc.comune(+) = anag.comune_doc
   AND pdoc.provincia(+) = cdoc.provincia_stato
   AND cnas.provincia_stato(+) = anag.provincia_nas
   AND cnas.comune(+) = anag.comune_nas
   AND pnas.provincia(+) = cnas.provincia_stato
   AND stte.stato_territorio(+) = DECODE (GREATEST (anag.cittadinanza, '999'), '999', anag.cittadinanza, NULL)
   AND cres.provincia_stato(+) = anag.provincia_res
   AND cres.comune(+) = anag.comune_res
   AND pres.provincia(+) = cres.provincia_stato
   AND cdom.provincia_stato(+) = anag.provincia_dom
   AND cdom.comune(+) = anag.comune_dom
   AND pdom.provincia(+) = cdom.provincia_stato
   AND nvl(tipo_soggetto,'I') = 'I'
/