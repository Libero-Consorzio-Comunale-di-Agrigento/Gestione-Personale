CREATE OR REPLACE PACKAGE p_figi IS

/******************************************************************************
 NOME:          crp_p_figi
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

CREATE OR REPLACE PACKAGE BODY p_figi IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE FIGURE_GIURIDICHE',(132-length('VERIFICA INTEGRITA` REFERENZIALE FIGURE_GIURIDICHE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE FIGURE_GIURIDICHE')))
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
	           	, 'Figura     Numero Dal        Prof.  Pos.   Carr.  Qualif Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ------ ---------- ------ ------ ------ ------ ---------------------'
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
	for cur_riga in (select  codice
				 			,numero
							,'          ' dal
							,'    ' profilo
							,'    ' posizione
							,'    ' carriera
							,'      ' qualifica
							,'FIGURE' tabella
						from figure_giuridiche figi
					   where not exists
					     (select 1 from figure figu
						     where figu.numero = figi.numero)
					 union
					 select  codice
					 		,numero
							,to_char(dal,'dd/mm/yyyy') dal
							,profilo
							,'    ' posizione
							,'    ' carriera
							,'      ' qualifica
							,'PROFILI_PROFESSIONALI' tabella
					   from figure_giuridiche figi
					  where profilo is not null
					    and not exists
						  (select 1 from profili_professionali prpr
						    where prpr.codice = figi.profilo)
					union
					select  codice
						   ,numero
						   ,to_char(dal,'dd/mm/yyyy') dal
						   ,profilo
						   ,posizione
						   , '    ' carriera
						   , '      ' qualifica
						   , 'POSIZIONI_FUNZIONALI' tabella
					from figure_giuridiche figi
					where posizione is not null
					  and not exists
					    (select 1 from posizioni_funzionali pofu
						    where pofu.profilo = figi.profilo
							      and pofu.codice  = figi.posizione)
					union
					select  codice
						   ,numero
						   , to_char(dal,'dd/mm/yyyy') dal
						   , '    ' profilo
						   , '    ' posizione
						   , carriera
						   , '      ' qualifica
						   , 'CARRIERE' tabella
					from figure_giuridiche figi
					where carriera is not null
					  and not exists
					    (select 1 from carriere carr
						    where carr.codice = figi.carriera)
					union
					select  codice
						   ,numero
						   , to_char(dal,'dd/mm/yyyy') dal
						   , '    ' profilo
						   , '    ' posizione
						   , '    ' carriera
						   , to_char(qualifica)
						   , 'QUALIFICHE' tabella
					from figure_giuridiche figi
					where not exists
					  (select 1 from qualifiche qual
					      where qual.numero = figi.qualifica)
					union
					select 	codice
						   ,numero
						   , to_char(dal,'dd/mm/yyyy') dal
						   , '    ' profilo
						   , '    ' posizione
						   , '    ' carriera
						   , to_char(qualifica)
						   , 'QUALIFICHE_GIURIDICHE' tabella
					from figure_giuridiche figi
					where not exists
					  (select 1 from qualifiche_giuridiche qugi
					      where qugi.numero = figi.qualifica
						        and figi.dal
								  between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
								    )
					   or not exists
					     (select 1 from qualifiche_giuridiche qugi
						     where qugi.numero = figi.qualifica
							       and nvl(figi.al,to_date('3333333','j'))
								             between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
								  )
order by 7,3,4,5,6,7,1,2

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
				  rpad(nvl(to_char(cur_riga.numero),' '),6)||' '||
  				  rpad(nvl(cur_riga.dal,' '),10)||' '||
   				  rpad(nvl(cur_riga.profilo,' '),6)||' '||
   				  rpad(nvl(cur_riga.posizione,' '),6)||' '||
   				  rpad(nvl(cur_riga.carriera,' '),6)||' '||
   				  rpad(nvl(cur_riga.qualifica,' '),6)||' '||
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
END p_figi;
/

