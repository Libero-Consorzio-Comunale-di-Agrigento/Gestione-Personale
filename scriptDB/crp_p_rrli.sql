CREATE OR REPLACE PACKAGE p_rrli IS

/******************************************************************************
 NOME:          crp_p_rrli
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

CREATE OR REPLACE PACKAGE BODY p_rrli IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RIGHE_RIPARTIZIONE_LINGUISTICA',(132-length('VERIFICA INTEGRITA` REFERENZIALE RIGHE_RIPARTIZIONE_LINGUISTICA'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RIGHE_RIPARTIZIONE_LINGUISTICA')))
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
	           	, 'Ripartizione Settore Dal        Sequenza Profilo Posizione Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------------ ------- ---------- -------- -------- --------- ------------------------------'
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
	for cur_riga in (select ripartizione, to_char(settore) settore, to_char(dal,'dd/mm/yyyy') dal,
       to_char(sequenza) sequenza, null profilo, null posizione,
       'RIPARTIZIONI_LINGUISTICHE' tabella
from righe_ripartizione_linguistica rrli
where not exists
  (select 1 from ripartizioni_linguistiche rili
    where rili.ripartizione = rrli.ripartizione
      and rili.settore = rrli.settore
      and rili.dal = rrli.dal)
union
select ripartizione, to_char(settore) settore, to_char(dal,'dd/mm/yyyy') dal,
       to_char(sequenza) sequenza, profilo, posizione,
       'POSIZIONI_FUNZIONALI' tabella
from righe_ripartizione_linguistica rrli
where not exists
  (select 1 from posizioni_funzionali pofu
    where pofu.profilo = rrli.profilo
      and pofu.codice  = rrli.posizione)
order by 7,5,6,1,2,3,4
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
		       	, rpad(nvl(cur_riga.ripartizione,' '),12)||' '||rpad(nvl(cur_riga.settore,' '),8)||' '||rpad(nvl(cur_riga.dal,' '),12)||' '
				||rpad(nvl(cur_riga.sequenza,' '),8)||' '||rpad(nvl(cur_riga.profilo,' '),8)||' '||rpad(nvl(cur_riga.posizione,' '),9)||' '||cur_riga.tabella
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
END p_rrli;
/

