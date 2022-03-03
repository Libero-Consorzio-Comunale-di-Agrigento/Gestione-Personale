CREATE OR REPLACE FUNCTION INC_ESODO_50
( p_ci             NUMBER
 ,p_anno           NUMBER
)
/* Restituisce il valore dell'incentivo all'esodo a tassazione ridotta liquidato nell'anno
*/
RETURN NUMBER IS
d_importo                NUMBER;
BEGIN
  SELECT SUM(NVL(imp,0))
    INTO d_importo
    FROM MOVIMENTI_CONTABILI
   WHERE ci            = p_ci
     AND anno          = p_anno
     AND voce         IN
     (SELECT codice
        FROM VOCI_ECONOMICHE
       WHERE specifica = 'INC_ESOD50'
  )
  ;
  RETURN NVL(d_importo,0);
END INC_ESODO_50;
/
