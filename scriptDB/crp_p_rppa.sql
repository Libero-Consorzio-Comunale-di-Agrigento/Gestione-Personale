CREATE OR REPLACE PACKAGE p_rppa IS

/******************************************************************************
 NOME:          CRP_P_RPPA
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

CREATE OR REPLACE PACKAGE BODY p_rppa IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RIGHE PROSPETTO PRESENZA',(132-length('VERIFICA INTEGRITA` REFERENZIALE RIGHE PROSPETTO PRESENZA'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RIGHE PROSPETTO PRESENZA')))
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
	           	, 'Prospett Seq Ti Colonna  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- --- -- -------- -------------------------------'
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
	for cur_riga in (select  rppa.prospetto                         prospetto       
       ,rppa.sequenza                          sequenza
       ,rppa.tipo                              tipo
       ,rppa.colonna                           colonna
       ,'PROSPETTI PRESENZA'                   tabella
  from  righe_prospetto_presenza rppa
 where  not exists
       (select 1 
          from prospetti_presenza prpa
         where prpa.codice = rppa.prospetto
       )
union
select  rppa.prospetto                         prospetto       
       ,rppa.sequenza                          sequenza
       ,rppa.tipo                              tipo
       ,rppa.colonna                           colonna
       ,'CATEGORIE EVENTO'                     tabella
  from  righe_prospetto_presenza rppa
 where  not exists
       (select 1 
          from categorie_evento ctev
         where ctev.codice = rppa.colonna
       )
   and  rppa.tipo          = 'CT'
union
select  rppa.prospetto                         prospetto       
       ,rppa.sequenza                          sequenza
       ,rppa.tipo                              tipo
       ,rppa.colonna                           colonna
       ,'CAUSALI EVENTO'                       tabella
  from  righe_prospetto_presenza rppa
 where  not exists
       (select 1 
          from causali_evento caev
         where caev.codice = rppa.colonna
       )
   and  rppa.tipo     not in ('CT','CL')
union
select  rppa.prospetto                         prospetto       
       ,rppa.sequenza                          sequenza
       ,rppa.tipo                              tipo
       ,rppa.colonna                           colonna
       ,'CLASSI EVENTO'                        tabella
  from  righe_prospetto_presenza rppa
 where  not exists
       (select 1 
          from classi_evento clev
         where clev.codice = rppa.colonna
       )
   and  rppa.tipo          = 'CL'
 order by 2,1


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
		       	, rpad(nvl(cur_riga.prospetto,' '),8)||' '||
				  rpad(nvl(to_char(cur_riga.sequenza),' '),3)||' '||
				  rpad(nvl(cur_riga.tipo,' '),2)||' '||
 				  rpad(nvl(cur_riga.colonna,' '),8)||' '||
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
END p_rppa;
/

