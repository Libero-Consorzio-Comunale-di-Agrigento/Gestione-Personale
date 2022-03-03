CREATE OR REPLACE FUNCTION PXIRISDR ( p_ci NUMBER , p_riferimento DATE)
RETURN DATE IS
d_riferimento date;
d_dummy       varchar2(1);
/******************************************************************************
   NAME:       PXIRISDR
   PURPOSE:    Determinare la data riferimento per le variabili provenienti da iris 
               dati il CI e la data di riferiemento proposta dalla rilevazione.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        28/07/2003          1. Created this function.

******************************************************************************/
BEGIN
   d_riferimento := p_riferimento;
   BEGIN
       select 'x' 
	     into d_dummy
         from periodi_giuridici
        where ci         = p_ci
    	  and rilevanza  = 'S'
    	  and p_riferimento between dal 
    	                        and nvl(al,to_date(3333333,'j'))
       ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
	   BEGIN
    	   select max(al)
    	     into d_riferimento
    		 from periodi_giuridici
    		where ci        = p_ci
    		  and rilevanza = 'S'
    		  and dal      <= p_riferimento
		   ;
		   IF d_riferimento is null THEN
		     select min(dal)
			   into d_riferimento
			   from periodi_giuridici
			  where ci        = p_ci
			    and rilevanza = 'S'
				and dal      >= p_riferimento
			 ;
		   END IF;
	   END;
   END;
   RETURN d_riferimento;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
END PXIRISDR;
/ 

