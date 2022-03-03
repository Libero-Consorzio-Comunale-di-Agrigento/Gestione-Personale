create or replace view COMUNI as
select COMU.provincia_stato         COD_PROVINCIA
     , COMU.comune                  COD_COMUNE
     , COMU.denominazione           DESCRIZIONE
     , COMU.denominazione_al1       DESCRIZIONE_AL1
     , COMU.denominazione_al2       DESCRIZIONE_AL2
     , COMU.denominazione_breve     DESCRIZIONE_BREVE
     , COMU.denominazione_breve_al1 DESCRIZIONE_BREVE_AL1
     , COMU.denominazione_breve_al2 DESCRIZIONE_BREVE_AL2
     , COMU.CAPOLUOGO_PROVINCIA
     , COMU.CAP
     , COMU.provincia_tribunale     COD_PROVINCIA_TRIBUNALE
     , COMU.comune_tribunale        COD_COMUNE_TRIBUNALE
     , COMU.provincia_distretto     COD_PROVINCIA_DISTRETTO
     , COMU.comune_distretto        COD_COMUNE_DISTRETTO
     , COMU.DATA_SOPPRESSIONE       
     , COMU.provincia_fusione       COD_PROVINCIA_FUSIONE
     , COMU.comune_fusione          COD_COMUNE_FUSIONE
     , COMU.sigla_cfis              CODICE_CATASTO
     , COMU.CONSOLATO
     , COMU.TIPO_CONSOLATO
     , decode( sign(comu.provincia_stato - 199)
             , -1, prov.sigla
                 , stte.sigla
             )                      SIGLA_PROVINCIA
     , PROV.denominazione           DENOMINAZIONE_PROVINCIA
     , PROV.REGIONE
     , REGI.denominazione           DENOMINAZIONE_REGIONE
  from A_REGIONI         REGI
     , A_STATI_TERRITORI STTE
     , A_PROVINCIE       PROV
     , A_COMUNI          COMU
 where REGI.REGIONE          (+) = PROV.REGIONE
   and PROV.PROVINCIA        (+) = COMU.PROVINCIA_STATO
   and STTE.STATO_TERRITORIO (+) = COMU.PROVINCIA_STATO
/
