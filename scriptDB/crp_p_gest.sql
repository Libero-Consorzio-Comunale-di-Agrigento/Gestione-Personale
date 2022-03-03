CREATE OR REPLACE PACKAGE p_gest IS

/******************************************************************************
 NOME:          crp_p_gest
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

CREATE OR REPLACE PACKAGE BODY p_gest IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE GESTIONI',(132-length('VERIFICA INTEGRITA` REFERENZIALE GESTIONI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE GESTIONI')))
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
	           	, 'Codice     Pr.Nasc.   Com.Nasc.  Pr.Res.    Com.Res.   Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---------- ---------- ---------- ---------- ------------------'
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
	for cur_riga in (select codice
				 			, to_char(provincia_nas) provincia_nas
							, to_char(comune_nas) comune_nas
							, '   ' provincia_res
							, '   ' comune_res
							, 'COMUNI' tabella
						from gestioni
						where comune_nas||provincia_nas is not null
						  and not exists
						    (select 1 from comuni
							    where cod_comune = comune_nas
								      and cod_provincia = provincia_nas)
					union
					select  codice
						   ,'   ' provincia_nas
						   ,'   ' comune_nas
						   ,to_char(provincia_res)
						   ,to_char(comune_res)
						   ,'COMUNI' tabella
					from gestioni
					where not exists
					  (select 1 from comuni
					      where cod_comune = comune_res
						        and cod_provincia = provincia_res)
				order by 6,2,3,4,5,1

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
		       	, rpad(nvl(cur_riga.codice,' '),10)||' '||
  				  rpad(nvl(cur_riga.provincia_nas,' '),10)||' '||
   				  rpad(nvl(cur_riga.comune_nas,' '),10)||' '||
				  rpad(nvl(cur_riga.provincia_res,' '),10)||' '||
				  rpad(nvl(cur_riga.comune_res,' '),10)||' '||
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
END p_gest;
/

