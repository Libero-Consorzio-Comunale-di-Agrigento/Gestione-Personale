CREATE OR REPLACE FUNCTION ipt_liq_mese
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN number IS
d_ipt_liq_mese               number;
BEGIN
  SELECT sum(nvl(ipt_liq,0) - nvl(det_liq,0) - nvl(dtp_liq,0))
    INTO d_ipt_liq_mese
    FROM movimenti_fiscali mofi
   WHERE mofi.ci            = p_ci
     AND mofi.anno          = p_anno
     AND mofi.mese          = p_mese
  ;
  RETURN d_ipt_liq_mese;
END ipt_liq_mese;
/

