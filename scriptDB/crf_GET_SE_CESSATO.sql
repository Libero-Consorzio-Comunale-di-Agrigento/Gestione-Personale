CREATE OR REPLACE FUNCTION GET_SE_CESSATO (p_ci number, p_anno number , p_mese number) RETURN NUMBER IS
/******************************************************************************
 NOME:        GET_SE_CESSATO
 DESCRIZIONE: <Descrizione function>

 PARAMETRI:   ci, anno, mese

 RITORNA:     1 dipendente cessato
              0 in servizio

 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    30/08/2002 __     Prima emissione.
 1.1  08/07/2005 MS     Mod. per attività 11828.1
******************************************************************************/
d_valore NUMBER;
BEGIN
   d_valore := 0;
   select 1
     into d_valore
     from dual
	where not exists
	     (select 'x'
		    from periodi_giuridici
		   where ci         =  p_ci
		     and rilevanza = 'P'
		     and last_day ( to_date (p_anno||lpad(p_mese,2,'0'),'yyyymm'))+1
			     between dal and nvl(al,to_date(3333333,'j'))
		 )
   ;
   RETURN d_valore;
EXCEPTION
   WHEN no_data_found THEN d_valore := 0;
   return d_valore;
END GET_SE_CESSATO;
/

