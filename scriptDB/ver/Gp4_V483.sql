-- Da rilasci precedenti

-- Attivita' 1806
start ver\A1806.sql

-- Attivita' 6408
start ver\A6408.sql

drop package gpx_rare;

delete from pec_ref_codes
 where rv_low_value = 'DED_BASE.A'
   and exists (select 'x'
                 from pec_ref_codes r2
                where r2.rv_low_value = 'DED_BASE_A')
;

delete from pec_ref_codes
 where rv_low_value = 'DED_AGG.A'
   and exists (select 'x'
                 from pec_ref_codes r2
                where r2.rv_low_value = 'DED_AGG_A')
;

update pec_ref_codes r1
   set rv_low_value = decode ( rv_low_value
                             , 'DED_BASE.A', 'DED_BASE_A'
                             , 'DED_AGG.A' , 'DED_AGG_A'
                             , rv_low_value)
 where rv_low_value in ('DED_BASE.A', 'DED_AGG.A')
--   and not exists (select 'x'
--                     from pec_ref_codes r2
--                    where r2.rv_low_value in ('DED_BASE_A', 'DED_AGG_A'))
;

-- Patch 4.8.3

-- Attivita' 3670.1
start ver\A3670_1.sql

-- Attivita' 6662
start ver\A6662.sql

-- Attivita' 6945
start ver\A6945.sql

-- Attivita' 6947
start ver\A6947.sql

-- Attivita' 6950
start ver\A6950.sql

-- Attivita' 6951.1
start ver\A6951_1.sql

-- Attivita' 6953
start ver\A6953.sql

-- Attivita' 6967
start ver\A6967.sql

-- Attivita' 7043
start ver\A7043.sql

-- Attivita' 7276
start ver\A7276.sql

-- Attivita' 7306
start ver\A7306.sql

-- Attivita' 7554
start ver\A7554.sql

-- Attivita' 8353.2
start ver\A8353_2.sql

-- Attivita' 8522
start ver\A8522.sql

-- Attivita' 8637.1
start ver\A8637_1.sql

-- Attivita' 8793
start ver\A8793.sql

-- Attivita' 8894
start ver\A8894.sql

-- Attivita' 8898
start ver\A8898.sql

-- Attivita' 9409
start ver\A9409.sql

-- Attivita' 9545
start ver\A9545.sql

-- Attivita' 9609
start ver\A9609.sql

-- Attivita' 9613
start ver\A9613.sql

-- Attivita' 9631
start ver\A9631.sql

-- Attivita' 9687
start ver\A9687.sql

-- Attivita' 9698
start ver\A9698.sql

-- Attivita' 9728
start ver\A9728.sql

-- Attivita' 9740
start ver\A9740.sql

-- Attivita' 9748
start ver\A9748.sql

-- Attivita' 9775
start ver\A9775.sql

-- Attivita' 9806
start ver\A9806.sql

-- Attivita' 9815
start ver\A9815.sql

-- Attivita' 9829
start ver\A9829.sql

-- Attivita' 9831
start ver\A9831.sql

-- Attivita' 9898
start ver\A9898.sql


-- Attività per CUD

-- Attivita' 4512
start ver\A4512.sql

-- Attivita' 8880
start ver\A8880.sql

-- Attivita' 8882
start ver\A8882.sql

-- Attivita' 8882
start ver\A8882_ins_cafi.sql

-- Attivita' 8884
start ver\A8884.sql

-- Attivita' 8885
start ver\A8885.sql

-- Attivita' 8886
start ver\A8886.sql

-- Attivita' 8887
start ver\A8887.sql

-- Attivita' 8888
start ver\A8888.sql

-- Attivita' 8890
start ver\A8890.sql

-- Attivita' 8892
start ver\A8892.sql

-- Attivita' 9263
start ver\A9263.sql

-- Attivita' 9265
start ver\A9265.sql

-- Attivita' 9266
start ver\A9266.sql

-- Attivita' 9267
start ver\A9267.sql
start ver\A9267_ins_ref_codes.sql

-- Attivita' 9268
start ver\A9268.sql

-- Attivita' 9557
start ver\A9557.sql

-- Attivita' 9623
start ver\A9623.sql

-- Attivita' 9695
start ver\A9695.sql

-- Attivita' 9726
start ver\A9726.sql

-- ricreazione vista_settori_amministrativi per congruenza con mod. a ESTAM
CREATE OR REPLACE VIEW VISTA_SETTORI_AMMINISTRATIVI ( GESTIONE, 
SUDDIVISIONE, CODICE, LIVELLO, DESCRIZIONE, 
REVISIONE, OTTICA, UNITA_PADRE, NI
 ) AS select  substr(gp4_stam.get_gestione(unor.ni) ,1,4)                                               gestione    
       ,substr(lpad(' ',(gp4_unor.get_livello(unor.ni,'GP4',unor.dal)-1) * 2,' ')||    
	    substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8),1,30)                 suddivisione    
       ,substr(gp4_stam.get_codice(ni),1,15)                                         codice    
       ,gp4_unor.get_livello(unor.ni,'GP4',gp4_unor.get_dal(unor.ni))                livello    
       ,decode( gp4gm.get_revisione_gest(gp4_stam.get_gestione(unor.ni))    
	           ,gp4gm.get_revisione_a,unor.descrizione    
			                         ,'*** '||unor.descrizione    
			  )                                                                      descrizione    
	   ,revisione    
       ,ottica 
       ,unita_padre 
       ,ni 
  from  unita_organizzative unor    
 where ottica='GP4'
;