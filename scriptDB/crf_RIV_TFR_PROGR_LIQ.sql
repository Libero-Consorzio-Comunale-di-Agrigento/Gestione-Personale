CREATE OR REPLACE FUNCTION Riv_Tfr_Progr_liq
(p_anno           NUMBER
,p_ci             NUMBER)
RETURN NUMBER IS
d_riv_tfr_liq                NUMBER;
BEGIN
  SELECT SUM(NVL(riv_tfr_liq,0))
    INTO d_riv_tfr_liq
    FROM MOVIMENTI_FISCALI
   WHERE anno          < p_anno
     AND ci            = p_ci
  ;
  RETURN d_riv_tfr_liq;
END Riv_Tfr_Progr_Liq;
/

