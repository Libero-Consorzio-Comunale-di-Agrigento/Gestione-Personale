CREATE OR REPLACE FUNCTION ant_liq_ac
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN number IS
d_ant_liq_ac               number;
BEGIN
  SELECT sum(nvl(lor_acc,0) + nvl(lor_acc_2000,0) + nvl(lor_liq,0))
    INTO d_ant_liq_ac
    FROM movimenti_fiscali mofi
   WHERE mofi.ci            = p_ci
     AND mofi.anno          = p_anno
     AND mofi.mese          < p_mese
  ;
  RETURN d_ant_liq_ac;
END ant_liq_ac;
/

