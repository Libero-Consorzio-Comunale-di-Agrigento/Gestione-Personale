CREATE OR REPLACE FUNCTION data_prima_assunzione
( p_ci             NUMBER
)
RETURN date IS
d_data_assunzione                    date;
BEGIN
  SELECT min(dal)
    INTO d_data_assunzione
    FROM periodi_giuridici pegi
   WHERE pegi.ci            = p_ci
     and rilevanza          = 'P'
  ;
  RETURN d_data_assunzione;
END data_prima_assunzione;
/

