CREATE OR REPLACE PACKAGE p_asip IS
/******************************************************************************
 NOME:          CRP_P_ASIP
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

CREATE OR REPLACE PACKAGE BODY p_asip IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ASSEGNAZIONI INCENTIVO',(132-length('VERIFICA INTEGRITA` REFERENZIALE ASSEGNAZIONI INCENTIVO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ASSEGNAZIONI INCENTIVO')))
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
	           	, 'Progetto Cod.Ind. Dal        Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- -------- ---------- -------------------------------'
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
	for cur_riga in (select  asip.progetto                          progetto
       ,asip.ci                                ci
       ,substr(to_char(asip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,'PROGETTI INCENTIVO'                   tabella
  from  assegnazioni_incentivo asip
 where  not exists
       (select 1 
          from progetti_incentivo prip
         where asip.progetto = prip.progetto
       )
union
select  asip.progetto                          progetto
       ,asip.ci                                ci
       ,substr(to_char(asip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,'RAPPORTI GIURIDICI'                   tabella
  from  assegnazioni_incentivo asip
 where  not exists
       (select 1 
          from rapporti_giuridici ragi
         where ragi.ci = asip.ci
       )
 order by 4,1,2,3

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
		       	, rpad(nvl(cur_riga.progetto,' '),8)||' '||
				  rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
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
END p_asip;
/

