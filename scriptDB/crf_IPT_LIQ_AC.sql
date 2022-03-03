CREATE OR REPLACE FUNCTION ipt_liq_ac
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN number IS
d_ipt_liq_ac                number;
BEGIN
  SELECT sum(nvl(ipt_liq,0))
    INTO d_ipt_liq_ac
    FROM movimenti_fiscali mofi
   WHERE mofi.ci            = p_ci
     AND mofi.anno          = p_anno
     AND mofi.mese          < p_mese
  ;
  RETURN d_ipt_liq_ac;
END ipt_liq_ac;
/

