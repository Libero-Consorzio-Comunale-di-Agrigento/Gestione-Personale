CREATE OR REPLACE FUNCTION data_richiesta_tfr
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN date IS
d_data_richiesta                date;
BEGIN
  SELECT min(moco.riferimento)
    INTO d_data_richiesta
    FROM MOVIMENTI_CONTABILI moco
        ,riferimento_retribuzione rire
   WHERE moco.ci            = p_ci
     AND moco.anno          = p_anno
     AND moco.mese         <= p_mese
     AND moco.voce         IN
     (SELECT codice
        FROM VOCI_ECONOMICHE
       WHERE specifica in ('DAL_FONDO','DAL_TFR')
     )
  ;
  if to_char(d_data_richiesta,'dd') <= 15 then
    d_data_richiesta := last_day(add_months(d_data_richiesta,-1));
  end if;
  RETURN d_data_richiesta;
END data_richiesta_tfr;
/

