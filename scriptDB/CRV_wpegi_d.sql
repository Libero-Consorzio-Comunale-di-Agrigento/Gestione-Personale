CREATE OR REPLACE VIEW WORD_PEGI_D ( CI, 
DOGI_DAL, DOGI_AL, DOGI_DEL, DOGI_DESCRIZIONE, 
EVENTO, EVGI_DESCRIZIONE, DOGI_SCD, SODO_DESCRIZIONE, 
DOGI_NOTE, DOGI_RILASCIO, DOGI_NUMERO, DOGI_CATEGORIA,
DOGI_PRESSO, DOGI_COMUNE, DOGI_PROVINCIA, DOGI_SCADENZA,
DOGI_RINNOVO, SODO_NOTA_N1, DOGI_DATO_N1, SODO_NOTA_N2, DOGI_DATO_N2, 
SODO_NOTA_A1, DOGI_DATO_A1, SODO_NOTA_A2, DOGI_DATO_A2,
SEDE_DEL, NUMERO_DEL, ANNO_DEL, 
DELI_DATA, DELI_NOTE, NUMERO_ESE, DATA_ESE, 
TIPO_ESE, DELI_ESTREMI, DOGI_GG ) AS SELECT 
  dogi.ci                                  ci 
, dogi.dal                                 dogi_dal 
, dogi.al                                  dogi_al 
, decode( to_char(dogi.del,'ddmmyyyy')
        , '01011900', to_date(null)
                    , dogi.del)            dogi_del 
, dogi.descrizione                         dogi_descrizione 
, dogi.evento                              evento 
, evgi.descrizione                         evgi_descrizione 
, dogi.scd                                 dogi_scd 
, sodo.descrizione                         sodo_descrizione 
, replace(gp4aa.elimina_tag(dogi.note,'[',']')
         ,chr(10),' ')                     dogi_note 
, dogi.rilascio                            dogi_rilascio
, dogi.numero                              dogi_numero
, dogi.categoria                           dogi_categoria
, dogi.presso                              dogi_presso
, comu.denominazione                       dogi_comune
, prov.sigla                               dogi_provincia
, dogi.scadenza                            dogi_scadenza
, dogi.rinnovo                             dogi_rinnovo
, sodo.nota_n1                             sodo_nota_n1
, dogi.dato_n1                             dogi_dato_n1
, sodo.nota_n2                             sodo_nota_n2
, dogi.dato_n2                             dogi_dato_n2
, sodo.nota_a1                             sodo_nota_a1
, dogi.dato_a1                             dogi_dato_a1
, sodo.nota_a2                             sodo_nota_a2
, dogi.dato_a2                             dogi_dato_a2
, NVL(sepr.descrizione,dogi.sede_del)      sede_del 
, dogi.numero_del                          numero_del 
, dogi.anno_del                            anno_del 
, decode(to_char(deli.data,'ddmmyyyy')
        , '01011900',to_date(null)
                    , deli.data)           deli_data 
, replace(gp4aa.elimina_tag(deli.note,'[',']')
         ,chr(10),' ')                     deli_note   
, deli.numero_ese                          numero_ese 
, deli.data_ese                            data_ese 
, deli.tipo_ese                            tipo_ese 
, substr(gp4_deli.estremi(dogi.sede_del
                              ,dogi.numero_del
                              ,dogi.anno_del),1,18)     deli_estremi
, TRUNC(MONTHS_BETWEEN( LAST_DAY(LEAST( NVL(dogi.al,TO_DATE('3333333','j')) 
                                       ,SYSDATE) +1 ) 
                       ,LAST_DAY(dogi.dal) 
                      ))*30 
  -LEAST(30,TO_NUMBER(TO_CHAR(dogi.dal,'dd'))) + 1 
  +LEAST(30,TO_NUMBER(TO_CHAR(LEAST( NVL(dogi.al,TO_DATE('3333333','j')) 
                                    ,SYSDATE) + 1,'dd')) - 1)       dogi_gg 
  FROM SEDI_PROVVEDIMENTO    sepr 
     , a_comuni              comu
     , a_provincie           prov
     , DELIBERE              deli 
     , SOTTOCODICI_DOCUMENTO sodo 
     , EVENTI_GIURIDICI      evgi 
     , documenti_giuridici   dogi 
 WHERE dogi.evento        = evgi.codice 
   AND dogi.evento        = sodo.evento (+)
   AND NVL(dogi.scd,' ')  = sodo.codice (+) 
   AND evgi.certificabile IN ('SI','SP') 
   AND deli.sede    (+)   = NVL(dogi.sede_del,' ') 
   AND deli.numero  (+)   = NVL(dogi.numero_del,0) 
   AND deli.anno    (+)   = NVL(dogi.anno_del,0) 
   AND sepr.codice  (+)   = NVL(dogi.sede_del,' ')
   AND comu.PROVINCIA_STATO (+) = dogi.PROVINCIA
   AND comu.COMUNE          (+) = dogi.COMUNE
   AND prov.PROVINCIA (+)       = dogi.PROVINCIA
/