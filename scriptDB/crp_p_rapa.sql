CREATE OR REPLACE PACKAGE p_rapa IS

/******************************************************************************
 NOME:          CRP_P_RAPA
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

CREATE OR REPLACE PACKAGE BODY p_rapa IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI PRESENZA',(132-length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI PRESENZA'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI PRESENZA')))
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
	           	, 'Cod.Ind. Dal        Al          Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ---------- -------------------------------'
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
	for cur_riga in (select  rapa.ci                                ci
       ,substr(to_char(rapa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(rapa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'RAPPORTI INDIVIDUALI'                 tabella
  from  rapporti_presenza rapa
 where  not exists
       (select 1 
          from rapporti_individuali rain
         where rain.ci     = rapa.ci
       )
union
select  rapa.ci                                ci
       ,substr(to_char(rapa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(rapa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'SEDI'                                 tabella
  from  rapporti_presenza rapa
 where  not exists
       (select 1 
          from sedi sede
         where sede.numero = rapa.sede
       )
   and  rapa.sede         is not null
union
select  rapa.ci                                ci
       ,substr(to_char(rapa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(rapa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'CENTRI COSTO'                         tabella
  from  rapporti_presenza rapa
 where  not exists
       (select 1 
          from centri_costo ceco
         where ceco.codice = rapa.cdc
       )
   and  rapa.cdc          is not null
 order by 1,2,3
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
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.al,' '),10)||' '||
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
END p_rapa;
/

