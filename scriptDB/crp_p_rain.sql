CREATE OR REPLACE PACKAGE p_rain IS

/******************************************************************************
 NOME:          crp_p_rain
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

CREATE OR REPLACE PACKAGE BODY p_rain IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_INDIVIDUALI',(132-length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_INDIVIDUALI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_INDIVIDUALI')))
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
	           	, 'Cod.Ind. Num.Ind. Gruppo       Rapporto Competenza                     Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- -------- ------------ --------------------------------------- --------------------'
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
	for cur_riga in (select  ci ci
				 			,ni ni
							,'            ' gruppo
							,'    ' rapporto
							,'                    ' cc
							,'INDIVIDUI' tabella
						from rapporti_individuali
					   where ni not in
					     (select ni from individui)
					union
					select  ci ci
						   ,to_number(null) ni
						   ,gruppo gruppo
						   ,'    ' rapporto
						   ,'                    ' cc
						   ,'GRUPPI_RAPPORTO' tabella
					from rapporti_individuali
					where gruppo not in
					  (select gruppo from gruppi_rapporto)
					  and   gruppo is not null
					 union
					 select ci ci
					 		,to_number(null) ni
							,'            ' gruppo
							,rapporto
							,'                    ' cc
							,'CLASSI_RAPPORTO' tabella
						from rapporti_individuali
						where rapporto not in
						  (select codice from classi_rapporto)
						union
						select ci ci
							   , to_number(null) ni
							   , '            ' gruppo
							   , '    ' rapporto
							   , cc
							   , 'A_COMPETENZE' tabella
						from rapporti_individuali
						where cc       not in
							(select oggetto from a_competenze)
						  and cc is not null
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
		       	, rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
			  rpad(nvl(to_char(cur_riga.ni),' '),8)||' '||
			  rpad(nvl(cur_riga.gruppo,' '),12)||' '||
			  rpad(nvl(cur_riga.rapporto,' '),8)||' '||
  			  rpad(nvl(cur_riga.cc,' '),30)||' '||
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
END p_rain;
/

