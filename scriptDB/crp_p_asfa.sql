CREATE OR REPLACE PACKAGE p_asfa IS

/******************************************************************************
 NOME:          crp_p_asfa
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    01/10/2004 MS     Prima Emissione
 ****************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER,PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY p_asfa IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 01/10/2004';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number;
procedure insert_intestazione(contarighe in out number, pagina in number) is
	begin
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, null
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ASSEGNI_FAMILIARI'
                         ,(132-length('VERIFICA INTEGRITA` REFERENZIALE ASSEGNI_FAMILIARI'))/2
                              +(length('VERIFICA INTEGRITA` REFERENZIALE ASSEGNI_FAMILIARI')))
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, null
	           )
			   ;
	contarighe:=contarighe+1;

	insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, 'Dal        Al         Scaglione Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---------- --------- -------------------------------'
	           )
			   ;
		commit;
		end;
BEGIN
	select nvl(max(riga),0)
	  into contarighe
	  from a_appoggio_stampe
	 where no_prenotazione = prenotazione
	 ;
	for cur_riga in (select to_char(dal,'dd/mm/yyyy') dal, to_char(al,'dd/mm/yyyy') al, tabella tab
                      , 'VALIDITA_ASSEGNI_FAMILIARI' tabella
from ASSEGNI_FAMILIARI asfa
where not exists
  (select 1 from validita_assegni_familiari vaaf
    where vaaf.dal = asfa.dal)
order by 4,1,2,3

) loop
		if mod(contarighe,57)= 0 then
            insert_intestazione(contarighe,p_pagina);
		end if;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		   , passo
		         , P_pagina
		         , contarighe
		         , rpad(nvl(cur_riga.dal,' '),10)||' '||
			     rpad(nvl(cur_riga.al,' '),10)||' '||
			     rpad(nvl(cur_riga.tab,' '),3)||' '||
			     cur_riga.tabella
		        );
end loop;
	while TRUE loop
		if mod(contarighe,57)= 0 then exit; end if;
		contarighe := contarighe+1;
		insert into a_appoggio_stampe
		values ( prenotazione
        		  , passo
		        , P_pagina
		        , contarighe
		        , null
		        );
	end loop;
	COMMIT;
END MAIN;
END p_asfa;
/

