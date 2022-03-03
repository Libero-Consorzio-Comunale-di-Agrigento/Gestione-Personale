create or replace view STAMPA_UTENTE_VOCI_CAAF ( ANNO
, CI
, NOMINATIVO
, VOCE
, SUB
, DESCRIZIONE
, IMP
, CODICE_COM
, comune
, CODICE_REG
, regione
) as 
select ANNO
     , care.CI
     , rain.cognome||'  '||rain.nome
     , care.VOCE
     , care.SUB
     , covo.descrizione
     , IMP
     , care.CODICE_COM
     , comu.descrizione
     , care.CODICE_REG
     , areg.denominazione
  from comuni               comu
     , a_regioni            areg
     , caaf_voci_rettifica  care
     , contabilita_voce     covo
     , rapporti_individuali rain
 where care.anno = (select anno from riferimento_fine_anno)
   and covo.voce = care.voce
   and covo.sub  = care.sub
   and rain.ci   = care.ci
   and comu.codice_catasto (+) = care.codice_com
   and areg.regione        (+) = care.codice_reg
/
