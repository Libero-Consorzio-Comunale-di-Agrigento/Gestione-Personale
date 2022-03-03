CREATE OR REPLACE PACKAGE p_agfa IS

/******************************************************************************
 NOME:          crp_p_agfa
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

  PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY p_agfa IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number;
procedure insert_intestazione( contarighe in out number, pagina in number) is
	begin
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, null
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE AGGIUNTIVI_FAMILIARI',(132-length('VERIFICA INTEGRITA` REFERENZIALE AGGIUNTIVI_FAMILIARI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE AGGIUNTIVI_FAMILIARI')))
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, null
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, 'Codice Dal        Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------ ---------- ------------------------------'
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
	for cur_riga in (select codice,to_char(dal,'dd/mm/yyyy') dal,
       'CONDIZIONI_FAMILIARI' tabella
from aggiuntivi_familiari agfa
where not exists
  (select 1 from condizioni_familiari cofa
    where cofa.codice = agfa.codice)
union
select codice,to_char(dal,'dd/mm/yyyy') dal,
       'VALIDITA_ASSEGNI_FAMILIARI' tabella
from aggiuntivi_familiari agfa
where not exists
  (select 1 from validita_assegni_familiari vaaf
    where vaaf.dal = agfa.dal)
order by 3,1,2
) loop
		if mod(contarighe,57)= 0 then
			   insert_intestazione(contarighe,p_pagina);
		end if;
		contarighe:=contarighe+1;

		insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
		 values ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, rpad(nvl(cur_riga.codice,' '),6)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  cur_riga.tabella
		        );
	end loop;
	while TRUE loop
		if mod(contarighe,57)= 0 then exit; end if;
		contarighe := contarighe+1;
		insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
		values ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, null
		        );
	end loop;
	COMMIT;
END MAIN;
END p_agfa;
/

