CREATE OR REPLACE FUNCTION GET_SE_RILIQ (p_ci number, p_anno number, p_mese number)RETURN NUMBER IS
/******************************************************************************
 NOME:        GET_SE_RILIQ
 DESCRIZIONE: Mi dice se sto riliquidando un TFR

 PARAMETRI:   1 Riliquidazione
              0 Qualcosa d'altro

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    30/08/2002 __     Prima emissione.
******************************************************************************/
d_valore NUMBER;
d_chk    NUMBER;
BEGIN
   d_valore := 0;
   d_chk    := 0;
   begin
     select 1
	   into d_chk
	   from dual
	  where not exists
	       (select 'x'
		      from periodi_giuridici
			 where ci = p_ci
               and rilevanza = 'P'
		       and last_day ( to_date (p_anno||lpad(p_mese,2,'0'),'yyyymm'))
			       between dal and nvl(al,to_date(3333333,'j'))
		   )
     ;
   exception
     when no_data_found then null;
   end;
   if p_mese > 1 then d_chk := d_chk + 1;
   end if;
   begin
     select d_chk + 1
	   into d_chk
	   from dual
	  where exists
	       (select 'x'
		      from progressivi_fiscali
			 where ci   = p_ci
               and anno||lpad(mese,2,'0') < p_anno||lpad(p_mese,2,'0')
			   and qta_tfr_ac_liq > 0
		   )
     ;
   exception
     when no_data_found then null;
   end;
   if d_chk = 3 then d_valore := 1;
   end if;
   RETURN d_valore;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
        d_valore := 0;
        RETURN d_valore;
END GET_SE_RILIQ;
/

