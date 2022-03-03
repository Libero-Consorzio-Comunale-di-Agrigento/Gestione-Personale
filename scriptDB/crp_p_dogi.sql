CREATE OR REPLACE PACKAGE p_dogi IS

/******************************************************************************
 NOME:          crp_p_dogi
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

CREATE OR REPLACE PACKAGE BODY p_dogi IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ARCHIVIO_DOCUMENTI_GIURIDICI ',(132-length('VERIFICA INTEGRITA` REFERENZIALE ARCHIVIO_DOCUMENTI_GIURIDICI '))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ARCHIVIO_DOCUMENTI_GIURIDICI ')))
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
	           	, 'Num.Ind. Del        Evento Sottocod.Doc Sede Del. Anno Del. Numero Del. Provincia Comune    Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ------ ------------ --------- --------- ----------- --------- --------- -------------------------'
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
	for cur_riga in (select  ci
				 			,to_char(del,'dd/mm/yyyy') del
							,'    ' evento
							,'    ' scd
							,'  ' sede_del
							,'    ' anno_del
							,'       ' numero_del
							,'   ' provincia
							,'   ' comune
							,'RAPPORTI_INDIVIDUALI' Tabella
					  from archivio_documenti_giuridici dogi
					  where not exists
					    (select 1 from rapporti_individuali rain
						    where rain.ci = dogi.ci)
					union
					select  ci
						   ,to_char(del,'dd/mm/yyyy') del
						   , evento
						   ,'    ' scd
						   ,'  ' sede_del
						   ,'    ' anno_del
						   ,'       ' numero_del
						   ,'   ' provincia
						   ,'   ' comune
						   ,'EVENTI_GIURIDICI' Tabella
					from archivio_documenti_giuridici dogi
					where not exists
					  (select 1 from eventi_giuridici evgi
					      where evgi.codice = dogi.evento)
					union
					select  ci
						   ,to_char(del,'dd/mm/yyyy') del
						   ,evento
						   ,scd
						   ,'  ' sede_del
						   ,'    ' anno_del
						   ,'       ' numero_del
						   ,'   ' provincia
						   ,'   ' comune
						   ,'SOTTOCODICI_DOCUMENTO' Tabella
					from archivio_documenti_giuridici dogi
					where not exists
					  (select 1 from sottocodici_documento sodo
					      where sodo.evento = dogi.evento
						        and sodo.codice = dogi.scd)
					union
					select  ci
						   ,to_char(del,'dd/mm/yyyy') del
						   ,'    ' evento
						   ,'    ' scd
						   ,sede_del
						   ,to_char(anno_del) anno_del
						   ,to_char(numero_del) numero_del
						   ,'   ' provincia
						   ,'   ' comune
						   ,'DELIBERE' Tabella
					from archivio_documenti_giuridici dogi
					where sede_del||anno_del||numero_del is not null
					  and not exists
					    (select 1 from delibere deli
						    where deli.sede = dogi.sede_del
							      and deli.anno = dogi.anno_del
								        and deli.numero = dogi.numero_del)
					  and exists
					    (select 1 from ente
						    where ente.delibere = 'SI')
					union
					select  ci
						   ,to_char(del,'dd/mm/yyyy') del
						   ,'    ' evento
						   ,'    ' scd
						   ,'  ' sede_del
						   ,'    ' anno_del
						   ,'       ' numero_del
						   ,to_char(provincia) provincia
						   ,to_char(comune) comune
						   ,'COMUNI' tabella
					  from archivio_documenti_giuridici dogi
					 where provincia||comune is not null
					   and not exists
					     (select 1 from comuni comu
						     where comu.cod_provincia = dogi.provincia
							       and comu.cod_comune    = dogi.comune)
order by 10,3,4,5,6,7,8,9,1,2

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
				  rpad(nvl(cur_riga.del,' '),10)||' '||
				  rpad(nvl(cur_riga.evento,' '),6)||' '||
				  rpad(nvl(cur_riga.scd,' '),12)||' '||
				  rpad(nvl(cur_riga.sede_del,' '),9)||' '||
				  rpad(nvl(cur_riga.anno_del,' '),9)||' '||
				  rpad(nvl(cur_riga.numero_del,' '),8)||' '||
				  rpad(nvl(cur_riga.provincia,' '),9)||' '||
				  rpad(nvl(cur_riga.comune,' '),9)||' '||
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
END p_dogi;
/

