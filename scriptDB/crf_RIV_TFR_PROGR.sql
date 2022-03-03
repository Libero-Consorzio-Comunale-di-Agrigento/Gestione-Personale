CREATE OR REPLACE FUNCTION RIV_TFR_PROGR
(p_anno           NUMBER
 ,p_mese           NUMBER
,p_ci             NUMBER)
RETURN NUMBER IS
d_riv_tfr                NUMBER;
BEGIN
  SELECT SUM(NVL(riv_tfr,0))
    INTO d_riv_tfr
    FROM MOVIMENTI_FISCALI
   WHERE anno          >= 2001
     and anno          < p_anno
     AND ci            = p_ci
  ;
  RETURN d_riv_tfr;
END Riv_Tfr_Progr;
/

