CREATE OR REPLACE FUNCTION RIT_RIV_ANNO
(p_anno           NUMBER
,p_ci             NUMBER)
RETURN NUMBER IS
d_rit_riv_tfr                NUMBER;
BEGIN
  SELECT e_round(SUM(NVL(riv_tfr,0)) * 11 / 100,'I')
    into d_rit_riv_tfr
    FROM MOVIMENTI_FISCALI
   WHERE anno          = p_anno
     AND ci            = p_ci
  ;
  RETURN d_rit_riv_tfr;
END RIT_RIV_ANNO;
/

