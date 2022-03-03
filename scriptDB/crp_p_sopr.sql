CREATE OR REPLACE PACKAGE p_sopr IS

/******************************************************************************
 NOME:          CRP_P_SOPR
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

CREATE OR REPLACE PACKAGE BODY p_sopr IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE SOSPENSIONI_PROGRESSIONE',(132-length('VERIFICA INTEGRITA` REFERENZIALE SOSPENSIONI_PROGRESSIONE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE SOSPENSIONI_PROGRESSIONE')))
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
	           	, 'Dal        Contratto    Gestione     Ruolo        Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ------------ ------------ ------------ ---------------------'
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
	for cur_riga in (select to_char(dal,'dd/mm/yyyy') dal, contratto,
       '    ' gestione, '    ' ruolo,
       'CONTRATTI' tabella
from sospensioni_progressione sosp
where not exists
  (select 1 from contratti cont
    where cont.codice like sosp.contratto)
union
select to_char(dal,'dd/mm/yyyy') dal, '    ' contratto,
       gestione, '    ' ruolo,
       'GESTIONI' tabella
from sospensioni_progressione sosp
where not exists
  (select 1 from gestioni gest
    where gest.codice like sosp.gestione)
union
select to_char(dal,'dd/mm/yyyy') dal, '    ' contratto,
       '    ' gestione, ruolo,
       'RUOLI' tabella
from sospensioni_progressione sosp
where not exists
  (select 1 from ruoli ruol
    where ruol.codice like sosp.ruolo)
order by 5,2,3,4,1
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
				  rpad(nvl(cur_riga.contratto,' '),12)||' '||
				  rpad(nvl(cur_riga.gestione,' '),12)||' '||
				  rpad(nvl(cur_riga.ruolo,' '),12)||' '||
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
END p_sopr;
/

