delete from estrazione_righe_contabili
where estrazione = 'DENUNCIA_DMA'
  and colonna = 'COMP_ACCESSORIE'
  and dal < to_date('01011993','ddmmyyyy')
/
delete from estrazione_valori_contabili
where estrazione = 'DENUNCIA_DMA'
  and colonna = 'COMP_ACCESSORIE'
  and dal < to_date('01011993','ddmmyyyy')
/

update estrazione_righe_contabili
set dal = to_date('01011996','ddmmyyyy')
where estrazione = 'DENUNCIA_DMA'
  and colonna = 'COMP_ACCESSORIE'
  and dal = to_date('01011993','ddmmyyyy')
/
update estrazione_valori_contabili
set dal = to_date('01011996','ddmmyyyy')
where estrazione = 'DENUNCIA_DMA'
  and colonna = 'COMP_ACCESSORIE'
  and dal = to_date('01011993','ddmmyyyy')
/

start crp_peccadma.sql