update estrazione_valori_contabili esvc
  set note = '<80931>'||substr(note,1,230)
 where esvc.estrazione = 'DENUNCIA_CUD'
   and esvc.colonna    =  'COCO_01'
;
start crp_peccarfi.sql