CREATE OR REPLACE VIEW VISTA_ANAGRAFICI
    ( NI,
      COGNOME,
      NOME,
      SESSO,
      DATA_NAS,
      PROVINCIA_NAS,
      COMUNE_NAS,
      DES_COMUNE_NAS,
      DES_SIGLA_NAS,
      LUOGO_NAS,
      CODICE_FISCALE,
      CODICE_FISCALE_ESTERO,
      PARTITA_IVA,
      CITTADINANZA,
      DES_CITTADINANZA,
      GRUPPO_LING,
      INDIRIZZO_RES,
      PROVINCIA_RES,
      COMUNE_RES,
      DES_COMUNE_RES,
      DES_SIGLA_RES,
      CAP_RES,
      TEL_RES,
      FAX_RES,
      PRESSO,
      INDIRIZZO_DOM,
      PROVINCIA_DOM,
      COMUNE_DOM,
      DES_COMUNE_DOM,
      DES_SIGLA_DOM,
      CAP_DOM,
      TEL_DOM,
      FAX_DOM,
      NOTE,
      DAL,
      AL,
      STATO_CIVILE,
      DES_STATO_CIVILE,
      COGNOME_CONIUGE,
      TITOLO_STUDIO,
      DES_TITOLO_STUDIO,
      TITOLO,
      DES_TITOLO_ONORIFICO,
      CATEGORIA_PROTETTA,
      DES_CATEGORIA_PROTETTA,
      TESSERA_SAN,
      NUMERO_USL,
      PROVINCIA_USL,
      TIPO_DOC,
      DES_TIPO_DOC,
      NUMERO_DOC,
      PROVINCIA_DOC,
      COMUNE_DOC,
      DES_COMUNE_DOC,
      DES_SIGLA_DOC
 ) AS
  SELECT ANAG.NI,
         ANAG.COGNOME,
         ANAG.NOME,
         ANAG.SESSO,
         ANAG.DATA_NAS,
         ANAG.PROVINCIA_NAS,
         ANAG.COMUNE_NAS,
         CNAS.DENOMINAZIONE DES_COMUNE_NAS,
         PNAS.SIGLA         DES_SIGLA_NAS,
         ANAG.LUOGO_NAS,
         ANAG.CODICE_FISCALE,
         ANAG.CODICE_FISCALE_ESTERO,
         ANAG.PARTITA_IVA,
         ANAG.CITTADINANZA,
         STTE.DESC_CITTADINANZA,
         ANAG.GRUPPO_LING,
         ANAG.INDIRIZZO_RES,
         ANAG.PROVINCIA_RES,
         ANAG.COMUNE_RES,
         CRES.DENOMINAZIONE DES_COMUNE_RES,
         PRES.SIGLA         DES_SIGLA_RES,
         ANAG.CAP_RES,
         ANAG.TEL_RES,
         ANAG.FAX_RES,
         ANAG.PRESSO,
         ANAG.INDIRIZZO_DOM,
         ANAG.PROVINCIA_DOM,
         ANAG.COMUNE_DOM,
         CDOM.DENOMINAZIONE DES_COMUNE_DOM,
         PDOM.SIGLA         DES_SIGLA_DOM,
         ANAG.CAP_DOM,
         ANAG.TEL_DOM,
         ANAG.FAX_DOM,
         ANAG.NOTE,
         decode( greatest( nvl(ANAG.DAL,to_date('2222222','j'))
                         , nvl(ANAG.DAL,to_date('2222222','j'))
                         )
               , to_date('2222222','j'), ANAG.DATA_NAS
                 , greatest( nvl(ANAG.DAL,to_date('2222222','j'))
                           , nvl(ANAG.DAL,to_date('2222222','j'))
                           )
               ) DAL,   
         decode( least( nvl(ANAG.AL,to_date('3333333','j'))
                      , nvl(ANAG.AL,to_date('3333333','j'))
                      )
               , to_date('3333333','j'), to_date(null)
                 , least( nvl(ANAG.AL,to_date('3333333','j'))
                        , nvl(ANAG.AL,to_date('3333333','j'))
                        )
               ) AL,  
         ANAG.STATO_CIVILE,
         STCI.DESCRIZIONE DES_STATO_CIVILE,
         ANAG.COGNOME_CONIUGE,
         ANAG.TITOLO_STUDIO,
         TIST.DESCRIZIONE DES_TITOLO_STUDIO,
         ANAG.TITOLO,
         TIPE.TITOLO DES_TITOLO_ONORIFICO,
         ANAG.CATEGORIA_PROTETTA,
         CAPR.DESCRIZIONE DES_CATEGORIA_PROTETTA,
         ANAG.TESSERA_SAN,
         ANAG.NUMERO_USL,
         ANAG.PROVINCIA_USL,
         ANAG.TIPO_DOC,
         EVGI.DESCRIZIONE DES_TIPO_DOC,
         ANAG.NUMERO_DOC,
         ANAG.PROVINCIA_DOC,
         ANAG.COMUNE_DOC,
         CDOC.DENOMINAZIONE DES_COMUNE_DOC,
         PDOC.SIGLA         DES_SIGLA_DOC
    FROM STATI_CIVILI        STCI
       , TITOLI_STUDIO       TIST
       , TITOLI_PERSONALI    TIPE
       , CATEGORIE_PROTETTE  CAPR
       , EVENTI_GIURIDICI    EVGI
       , A_COMUNI          CDOC
       , A_PROVINCIE       PDOC
       , A_COMUNI          CNAS
       , A_PROVINCIE       PNAS
       , A_STATI_TERRITORI STTE
       , A_COMUNI          CRES
       , A_PROVINCIE       PRES
       , A_COMUNI          CDOM
       , A_PROVINCIE       PDOM
       , ANAGRAFICI        ANAG
   WHERE STCI.CODICE (+) = ANAG.STATO_CIVILE
     AND TIST.CODICE (+) = ANAG.TITOLO_STUDIO
     AND TIPE.SEQUENZA (+) = ANAG.TITOLO
     AND CAPR.CODICE (+) = ANAG.CATEGORIA_PROTETTA
     AND EVGI.CODICE (+) = ANAG.TIPO_DOC
     AND CDOC.PROVINCIA_STATO (+) = ANAG.PROVINCIA_DOC
     AND CDOC.COMUNE          (+) = ANAG.COMUNE_DOC
     AND PDOC.PROVINCIA (+)       = CDOC.PROVINCIA_STATO    
     AND CNAS.PROVINCIA_STATO (+) = ANAG.PROVINCIA_NAS
     AND CNAS.COMUNE          (+) = ANAG.COMUNE_NAS
     AND PNAS.PROVINCIA (+)       = CNAS.PROVINCIA_STATO    
     AND STTE.STATO_TERRITORIO(+) = decode( greatest(ANAG.CITTADINANZA,'999')
                                          , '999', ANAG.CITTADINANZA
                                                 , null
                                          )
     AND CRES.PROVINCIA_STATO (+) = ANAG.PROVINCIA_RES
     AND CRES.COMUNE          (+) = ANAG.COMUNE_RES
     AND PRES.PROVINCIA (+)       = CRES.PROVINCIA_STATO    
     AND CDOM.PROVINCIA_STATO (+) = ANAG.PROVINCIA_DOM
     AND CDOM.COMUNE          (+) = ANAG.COMUNE_DOM
     AND PDOM.PROVINCIA (+)       = CDOM.PROVINCIA_STATO    
;
