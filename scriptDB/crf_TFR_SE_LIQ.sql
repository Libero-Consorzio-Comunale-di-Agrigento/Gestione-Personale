CREATE OR REPLACE FUNCTION tfr_se_liq
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN NUMBER IS
d_se_liq              NUMBER;
BEGIN
  d_se_liq := 0;
  SELECT  decode( sign (   abs(nvl(mofi.riv_tfr_liq,0))
                          +abs(nvl(mofi.riv_tfr_ap_liq,0))
                          +abs(nvl(mofi.det_liq,0))
                          +abs(nvl(mofi.dtp_liq,0)) ) , 1, 1 ,0)
    INTO d_se_liq
    FROM MOVIMENTI_fiscali mofi
   WHERE ci            = p_ci
     AND anno          = p_anno
     AND mese          = p_mese
	 and mensilita     = (select max(mensilita)
	                        from mensilita
						   where mese = p_mese
						     and tipo = 'N'
						 )
  ;
  RETURN d_se_liq;
END tfr_se_liq;
/

