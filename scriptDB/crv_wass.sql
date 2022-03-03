CREATE OR REPLACE VIEW WORD_ASSENZE ( CI, 
RILEVANZA, PEGI_DAL, PEGI_AL, EVENTO, 
ASTE_DESCRIZIONE, PEGI_NOTE, SEDE_DEL, NUMERO_DEL, 
ANNO_DEL, DELI_DATA, DELI_NOTE, NUMERO_ESE, 
DATA_ESE, TIPO_ESE, DELI_ESTREMI, PEGI_GG ) AS SELECT
   pegi.ci                                  ci
 , pegi.rilevanza                           rilevanza
 , pegi.dal                                 pegi_dal
 , pegi.al                                  pegi_al
 , pegi.assenza                             evento
 , aste.descrizione                         aste_descrizione
 , replace(gp4aa.elimina_tag(pegi.note,'[',']')
          ,chr(10),' ')                     pegi_note
 , NVL(sepr.descrizione,pegi.sede_del)      sede_del
 , pegi.numero_del                          numero_del
 , pegi.anno_del                            anno_del
 , gp4_deli.data_del(pegi.sede_del
                              ,pegi.numero_del
                              ,pegi.anno_del)  deli_data
 , replace(gp4aa.elimina_tag(deli.note,'[',']')
          ,chr(10),' ')                     deli_note
 , deli.numero_ese                          numero_ese
 , deli.data_ese                            data_ese
 , deli.tipo_ese                            tipo_ese
 , substr(gp4_deli.estremi(pegi.sede_del
                              ,pegi.numero_del
                              ,pegi.anno_del),1,18)     deli_estremi
 , TRUNC(MONTHS_BETWEEN( LAST_DAY(LEAST( NVL(pegi.al,TO_DATE('3333333','j'))
                                        ,SYSDATE) +1 )
                        ,LAST_DAY(pegi.dal)
                       ))*30
   -LEAST(30,TO_NUMBER(TO_CHAR(pegi.dal,'dd'))) + 1
   +LEAST(30,TO_NUMBER(TO_CHAR(LEAST( NVL(pegi.al,TO_DATE('3333333','j'))
                                     ,SYSDATE) + 1,'dd')) - 1)       pegi_gg
   FROM SEDI_PROVVEDIMENTO sepr
      , DELIBERE           deli
      , ASTENSIONI         aste
      , PERIODI_GIURIDICI  pegi
  WHERE pegi.rilevanza     = 'A'
    AND pegi.evento       IN (SELECT codice FROM EVENTI_GIURIDICI
                               WHERE rilevanza = 'A'
                                 AND certificabile IN ('SI','SP'))
    AND pegi.assenza       = aste.codice
    AND deli.sede    (+)   = NVL(pegi.sede_del,' ')
    AND deli.numero  (+)   = NVL(pegi.numero_del,0)
    AND deli.anno    (+)   = NVL(pegi.anno_del,0)
    AND sepr.codice  (+)   = NVL(pegi.sede_del,' ')
/