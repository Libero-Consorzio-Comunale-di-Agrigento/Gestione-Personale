CREATE OR REPLACE FUNCTION giorni_richiesta_tfr
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN number IS
d_giorni_richiesta                number;
BEGIN
  SELECT months_between( max(last_day( to_date (p_anno||lpad(p_mese,2,'0'),'yyyymm')))
                       , min(moco.riferimento)
					   ) * 30
    INTO d_giorni_richiesta
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
  RETURN d_giorni_richiesta;
END giorni_richiesta_tfr;
/

