CREATE OR REPLACE FUNCTION INC_ESODO_IPN_50
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER
)
/* Restituisce il valore dell'incentivo all'esodo a tassazione ridotta liquidato nel mese,
   utilizzata dal report PECSMOFR
*/
RETURN NUMBER IS
d_importo                NUMBER;
BEGIN
  SELECT SUM(NVL(imp,0))
    INTO d_importo
    FROM MOVIMENTI_CONTABILI
   WHERE ci            = p_ci
     AND anno          = p_anno
  and mese          = p_mese
     AND voce         IN
     (SELECT codice
        FROM VOCI_ECONOMICHE
       WHERE specifica = 'IPN_ESOD50'
  )
  ;
  RETURN NVL(d_importo,0);
END INC_ESODO_IPN_50;
/
