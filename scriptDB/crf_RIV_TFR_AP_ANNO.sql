CREATE OR REPLACE FUNCTION riv_tfr_ap_anno (
   p_anno                              NUMBER
  ,p_ci                                NUMBER
)
   RETURN NUMBER IS
   d_riv_tfr_ap   NUMBER;
BEGIN
   SELECT SUM (NVL (prfi.riv_tfr_ap, 0) * 0.89)
     INTO d_riv_tfr_ap
     FROM progressivi_fiscali prfi
    WHERE prfi.anno = p_anno
      AND prfi.mese = 12
      AND prfi.ci = p_ci
      AND prfi.mensilita = (SELECT MAX (mensilita)
                              FROM mensilita
                             WHERE mese = 12
                               AND tipo = 'N');

   RETURN d_riv_tfr_ap;
END riv_tfr_ap_anno;
/

