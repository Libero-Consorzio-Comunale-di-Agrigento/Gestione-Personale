CREATE OR REPLACE FUNCTION Fondi_Tfr_progressivi
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN NUMBER IS
d_importo                NUMBER;
BEGIN
  SELECT SUM(NVL(imp,0))
    INTO d_importo
    FROM MOVIMENTI_CONTABILI
   WHERE ci            = p_ci
     AND anno||lpad(mese,2,'0') <= p_anno||lpad(p_mese,2,'0')
     AND voce         IN
     (SELECT codice
        FROM VOCI_ECONOMICHE
       WHERE specifica = 'FONDI_TFR'
     )
  ;
  RETURN NVL(d_importo,0);
END Fondi_Tfr_progressivi;
/

