CREATE OR REPLACE FUNCTION data_fine_rapporto_tfr
( p_ci             NUMBER
 ,p_anno           NUMBER
 ,p_mese           NUMBER)
RETURN date IS
d_data_richiesta                    date;
d_data_fine_rapporto                date;
BEGIN
  SELECT min(moco.riferimento)
    INTO d_data_richiesta
    FROM MOVIMENTI_CONTABILI moco
        ,riferimento_retribuzione rire
   WHERE moco.ci            = p_ci
     AND moco.anno          = p_anno
     AND moco.mese          <= p_mese
     AND moco.voce         IN
     (SELECT codice
        FROM VOCI_ECONOMICHE
       WHERE specifica in ('DAL_FONDO','DAL_TFR')
     )
  ;
  SELECT pegi.al
    INTO d_data_fine_rapporto
    FROM periodi_giuridici pegi
   WHERE pegi.ci            = p_ci
     AND rilevanza          = 'P'
     AND d_data_richiesta between pegi.dal
                           and nvl(pegi.al,to_date(3333333,'j'))
  ;
  if to_char(d_data_fine_rapporto,'dd') <= 15 then
    d_data_fine_rapporto := last_day(add_months(d_data_fine_rapporto,-1));
  end if;
  RETURN d_data_fine_rapporto;
END data_fine_rapporto_tfr;
/

