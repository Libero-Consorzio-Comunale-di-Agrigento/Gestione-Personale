CREATE OR REPLACE FUNCTION F_TRATTAMENTO (v_ci number, v_profilo_professionale varchar2, v_posizione varchar2) 
RETURN VARCHAR2 IS
v_trattamento RAPPORTI_RETRIBUTIVI_STORICI.TRATTAMENTO%TYPE:= to_char(null);
v_tipo varchar2(1);
BEGIN
   BEGIN
       select tipo_trattamento
         into v_tipo
         FROM RAPPORTI_RETRIBUTIVI_STORICI     RARS
             ,RIFERIMENTO_RETRIBUZIONE         RIRE
        WHERE RIRE.RIRE_ID  =    'RIRE'
		    AND RARS.CI = v_ci
          AND rars.dal      =
              (select max(dal)
                 from RAPPORTI_RETRIBUTIVI_STORICI
                where ci       = v_ci
              )
       ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      v_tipo := 0;
   END;
   BEGIN
       select trattamento
         into v_trattamento
         FROM RAPPORTI_RETRIBUTIVI_STORICI     RARS
             ,RIFERIMENTO_RETRIBUZIONE         RIRE
        WHERE RIRE.RIRE_ID  =    'RIRE'
		    AND RARS.CI = v_ci
          AND rars.dal      =
              (select max(dal)
                 from RAPPORTI_RETRIBUTIVI_STORICI
                where ci       = v_ci
              )
       ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      v_trattamento := to_char(null);
   END;
   IF v_trattamento is null THEN
     BEGIN
       select trattamento
         into v_trattamento
         from trattamenti_contabili
        where profilo_professionale = v_profilo_professionale
          and posizione             = v_posizione
          and tipo_trattamento      = nvl(v_tipo,0)
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_trattamento := to_char(null);
     END;
   END IF;
RETURN v_trattamento;
END F_TRATTAMENTO;
/

