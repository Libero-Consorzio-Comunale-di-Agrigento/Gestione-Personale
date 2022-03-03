CREATE OR REPLACE VIEW carico_prospetti_presenza
(
       prospetto
     , ci
     , dal
     , al
     , sede
     , cdc
     , val_01
     , val_02
     , val_03
     , val_04
     , val_05
     , val_06
     , val_07
     , val_08
     , val_09
     , val_10
     , val_11
     , val_12
     , val_13
     , val_14
     , val_15
     , val_16
     , val_17
     , val_18
     , val_19
     , val_20
)
AS SELECT
       rppa.prospetto
     , evpa.ci
     , evpa.dal
     , evpa.al
     , evpa.sede
     , evpa.cdc
     , decode(rppa.sequenza,01,evpa.valore,null)
     , decode(rppa.sequenza,02,evpa.valore,null)
     , decode(rppa.sequenza,03,evpa.valore,null)
     , decode(rppa.sequenza,04,evpa.valore,null)
     , decode(rppa.sequenza,05,evpa.valore,null)
     , decode(rppa.sequenza,06,evpa.valore,null)
     , decode(rppa.sequenza,07,evpa.valore,null)
     , decode(rppa.sequenza,08,evpa.valore,null)
     , decode(rppa.sequenza,09,evpa.valore,null)
     , decode(rppa.sequenza,10,evpa.valore,null)
     , decode(rppa.sequenza,11,evpa.valore,null)
     , decode(rppa.sequenza,12,evpa.valore,null)
     , decode(rppa.sequenza,13,evpa.valore,null)
     , decode(rppa.sequenza,14,evpa.valore,null)
     , decode(rppa.sequenza,15,evpa.valore,null)
     , decode(rppa.sequenza,16,evpa.valore,null)
     , decode(rppa.sequenza,17,evpa.valore,null)
     , decode(rppa.sequenza,18,evpa.valore,null)
     , decode(rppa.sequenza,19,evpa.valore,null)
     , decode(rppa.sequenza,20,evpa.valore,null)
  from eventi_presenza             evpa
     , righe_prospetto_presenza    rppa
     , prospetti_presenza          prpa
 where evpa.causale                = rppa.colonna
   and evpa.input                  = 'P'
   and rppa.tipo                   = 'CA'
   and rppa.prospetto              = prpa.codice
   and prpa.rilevanza              = 'C'
;
