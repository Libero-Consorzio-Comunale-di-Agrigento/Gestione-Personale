delete from pec_ref_codes
where rv_domain = 'DENUNCIA_DMA.TIPO_IMPIEGO'
and rv_low_value in ('15','16');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning , rv_type )
values( '15','DENUNCIA_DMA.TIPO_IMPIEGO','Trasformazione in rapporto di lavoro a tempo indet. dei CFL di cui al codice 5','CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning , rv_type )
values( '16','DENUNCIA_DMA.TIPO_IMPIEGO','Trasformazione in rapporto di lavoro a tempo indet. dei CFL di cui al codice 6','CFG');
