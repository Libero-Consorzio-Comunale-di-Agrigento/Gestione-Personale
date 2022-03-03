CREATE OR REPLACE VIEW SETTORI_STATISTICI
(
 ci,
 dal,
 al,
 numero,
 gestione,
 settore_a,
 settore_b,
 settore_c,
 settore,
 cod_reg1,
 cod_reg2,
 cod_reg3,
 cod_reg4
 )
AS select pegi.ci
         ,pegi.dal
         ,pegi.al 
	 ,vise.numero
         ,vise.codice_g
         ,vise.codice_a
         ,vise.codice_b
         ,vise.codice_c
         ,vise.codice
         ,substr(vise.cod_reg,1,4)
         ,substr(vise.cod_reg,6,4)
         ,substr(vise.cod_reg,11,4)
         ,substr(vise.cod_reg,16,4)
     from vista_settori           vise
         ,periodi_giuridici       pegi
    where vise.numero = pegi.settore
      and rilevanza   = 'S'
;
