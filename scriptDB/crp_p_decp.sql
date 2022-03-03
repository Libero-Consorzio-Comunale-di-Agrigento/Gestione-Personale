CREATE OR REPLACE PACKAGE p_decp IS

/******************************************************************************
 NOME:          crp_p_decp
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

CREATE OR REPLACE PACKAGE BODY p_decp IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE DENUNCIA_CP',(132-length('VERIFICA INTEGRITA` REFERENZIALE DENUNCIA_CP'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE DENUNCIA_CP')))
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
	           	, 'Anno Previdenza Cod.Ind. Rilevanza Dal        Gestione Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---- ---------- -------- --------- ---------- -------- --------------------'
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
	for cur_riga in (select anno, previdenza, ci, rilevanza, to_char(dal,'dd/mm/yyyy') dal,
       null gestione, 'RAPPORTI_RETRIBUTIVI' tabella
from denuncia_cp decp
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = decp.ci)
union
select anno, previdenza, ci, rilevanza, to_char(dal,'dd/mm/yyyy') dal,
       gestione, 'GESTIONI' tabella
from denuncia_cp decp
where gestione is not null
  and not exists
  (select 1 from gestioni gest
    where gest.codice = decp.gestione)
order by 7,6,1,2,3,4,5

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
		       	, rpad(nvl(to_char(cur_riga.anno),' '),4)||' '||
				  rpad(nvl(cur_riga.previdenza,' '),10)||' '||
				  rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.rilevanza,' '),9)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.gestione,' '),8)||' '||
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
END p_decp;
/

