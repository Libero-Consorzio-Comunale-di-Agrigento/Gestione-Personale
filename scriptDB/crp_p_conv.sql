CREATE OR REPLACE PACKAGE p_conv IS

/******************************************************************************
 NOME:          crp_p_conv
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

CREATE OR REPLACE PACKAGE BODY p_conv IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE CONVOCAZIONI',(132-length('VERIFICA INTEGRITA` REFERENZIALE CONVOCAZIONI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE CONVOCAZIONI')))
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
	           	, 'Num.Ind Data      Reg. Anno Num.Eff Reg. Anno Num.Rif. S. Anno Num.Del Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ------- ------ ------- ------ ------- ------ ------- ------ ------- ------ ------- ----- ------------------'
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
	for cur_riga in (select ci
				,to_char(data,'dd/mm/yyyy') data
				,registro_eff
			      	,substr(to_char(anno_eff),1,5) anno_eff
				,substr(to_char(numero_eff),1,7) numero_eff
				,'     ' registro_rif
				,'     ' anno_rif
				,'       ' numero_rif
				,'  ' sede_del
				,'     ' anno_del
				,'       ' numero_del
				,'CORRISPONDENZE' tabella
			from convocazioni
			where (registro_eff,anno_eff,numero_eff) not in
				      (select registro,anno,numero from corrispondenze)
			   and registro_eff||anno_eff||numero_eff is not null
			union
			select 	ci
			      	,to_char(data,'dd/mm/yyyy') data
				,'     '  registro_eff
				,'     ' anno_eff
				,'       '  numero_eff
			        ,registro_rif
				,substr(to_char(anno_rif),1,5) anno_rif
				,substr(to_char(numero_rif),1,7) numero_rif
				,'  ' sede_del
				,'     ' anno_del
				,'       ' numero_del
				,'CORRISPONDENZE' tabella
			 from convocazioni
			where (registro_rif,anno_rif,numero_rif) not in
			      (select registro,anno,numero from corrispondenze)
			  and registro_rif||anno_rif||numero_rif is not null
			union
			select 	 ci
				,to_char(data,'dd/mm/yyyy') data
				,'     ' registro_eff
				,'     ' anno_eff
				,'       ' numero_eff
				,'     ' registro_rif
				,'     ' anno_rif
				,'       ' numero_rif
				,sede_del
				,substr(to_char(anno_del),1,5) anno_del
				,substr(to_char(numero_del),1,7) numero_del
				,'DELIBERE' tabella
			  from convocazioni
			 where (sede_del,anno_del,numero_del) not in
				  (select sede,anno,numero from delibere)
			  and exists (select 1 from ente
     				       where ente.delibere = 'SI')
			union
			select	 ci
				,to_char(data,'dd/mm/yyyy') data
				,'     ' registro_eff
				,'     ' anno_eff
				,'       ' numero_eff
				,'     ' registro_rif
				,'     ' anno_rif
				,'       ' numero_rif
				,'  ' sede_del
				,'     ' anno_del
				,'       ' numero_del
				,'RAPPORTI_INDIVIDUALI' tabella
			  from convocazioni
			 where ci not in
			  (select ci from rapporti_individuali)
		order by 12,3,4,5,6,7,8,9,10,11,1,2
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
			  rpad(nvl(cur_riga.data,' '),10)||' '||
			  rpad(nvl(cur_riga.registro_eff,' '),4)||' '||
			  rpad(nvl(cur_riga.anno_eff,' '),4)||' '||
			  rpad(nvl(cur_riga.numero_eff,' '),7)||' '||
			  rpad(nvl(cur_riga.registro_rif,' '),4)||' '||
			  rpad(nvl(cur_riga.anno_rif,' '),4)||' '||
			  rpad(nvl(cur_riga.numero_eff,' '),8)||' '||
			  rpad(nvl(cur_riga.sede_del,' '),2)||' '||
			  rpad(nvl(cur_riga.anno_del,' '),4)||' '||
			  rpad(nvl(cur_riga.numero_del,' '),7)||' '||
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
END p_conv;
/

