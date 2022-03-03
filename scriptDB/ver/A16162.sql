update pec_ref_codes
   set rv_low_value = replace(rv_low_value,'ragi.','pere.')
 where rv_domain = 'MODELLI_STAMPA.DEFINIZIONE'
   and rv_low_value in ('ragi.figura'
                       ,'ragi.ore'
                       ,'ragi.ore_coco'
                       ,'ragi.ore_coco_td'
                       ,'ragi.ore_td'
                       ,'ragi.posizione'
                       ,'ragi.qualifica'
                       ,'ragi.ruolo'
                       ,'ragi.sede'
                       ,'ragi.settore'
                       ,'ragi.tipo_rapporto')
;

update struttura_modelli_stampa  set riga = replace(riga,'ragi.','pere.') 
 where nvl(riga,' ') != ' ' 
   and instr(upper(riga),'RAGI.') > 0
;

-- inclusa nel file A15353
-- start crp_pecsmor6.sql


