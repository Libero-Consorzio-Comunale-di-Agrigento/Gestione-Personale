CREATE OR REPLACE PACKAGE p_fami IS

/******************************************************************************
 NOME:          crp_p_fami
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

CREATE OR REPLACE PACKAGE BODY p_fami IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE FAMILIARI',(132-length('VERIFICA INTEGRITA` REFERENZIALE FAMILIARI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE FAMILIARI')))
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
	           	, 'Num.Ind. Cognome                   Nome                 Data Nas.  Dal        Relaz. Cond.Prof. Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ------------------------- -------------------- ---------- ---------- ------ ---------- ----------------------------'
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
	for cur_riga in (select  ni
				 			,cognome
							,nome
							,to_char(data_nas,'dd/mm/yyyy') data_nas
						    ,to_char(dal,'dd/mm/yyyy') dal
							,substr(to_char(relazione),1,9) relazione
							,'          ' condizione_pro
							,'PARENTELE' tabella
							from familiari
						    where relazione not in
							  (select sequenza from parentele)
					union
					select 	  ni
							 ,cognome
							 ,nome
							 ,to_char(data_nas,'dd/mm/yyyy') data_nas
							 ,to_char(dal,'dd/mm/yyyy') dal
							 ,'         ' relazione
							 , condizione_pro
							 ,'CONDIZIONI_NON_PROFESSIONALI' tabella
					from familiari
					where condizione_pro not in
					  (select codice from condizioni_non_professionali)
					    and condizione_pro is not null
					union
					select	  ni
							 ,cognome
							 ,nome
							 ,to_char(data_nas,'dd/mm/yyyy') data_nas
							 ,to_char(dal,'dd/mm/yyyy') dal
							 ,'         ' relazione
							 ,'          ' condizione_pro
							 ,'INDIVIDUI' tabella
					from familiari
					where ni not in
					  (select ni from individui)
		order by 8,6,7,1,2,3,4,5	) loop
		if mod(contarighe,57)= 0 then
			   insert_intestazione(contarighe,p_pagina);
		end if;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, rpad(nvl(to_char(cur_riga.NI),' '),8)||' '||
			  rpad(nvl(cur_riga.cognome,' '),25)||' '||
			  rpad(nvl(cur_riga.nome,' '),20)||' '||
			  rpad(nvl(cur_riga.data_nas,' '),10)||' '||
			  rpad(nvl(cur_riga.dal,' '),10)||' '||
			  rpad(nvl(cur_riga.relazione,' '),6)||' '||
			  rpad(nvl(cur_riga.condizione_pro,' '),10)||' '||
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
END p_fami;
/

