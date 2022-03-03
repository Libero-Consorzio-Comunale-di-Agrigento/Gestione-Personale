CREATE OR REPLACE PACKAGE p_eson IS

/******************************************************************************
 NOME:          crp_p_eson
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

CREATE OR REPLACE PACKAGE BODY p_eson IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONE_ONERI',(132-length('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONE_ONERI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONE_ONERI')))
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
	           	, 'Seq Voce       Sub        Voce Riv.  Sub Riv.   Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '--- ---------- ---------- ---------- ---------- --------------------'
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
	for cur_riga in (select sequenza, voce, sub, null riv_voce, null riv_sub,
       'VOCI_CONTABILI' tabella
from estrazione_oneri eson
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = eson.voce
      and voco.sub  = eson.sub)
union
select sequenza, null voce, null sub, riv_voce, riv_sub,
       'VOCI_CONTABILI' tabella
from estrazione_oneri eson
where riv_voce||riv_sub is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce = eson.riv_voce
      and voco.sub  = eson.riv_sub)
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
		       	, rpad(nvl(to_char(cur_riga.sequenza),' '),3)||' '||
				  rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub,' '),10)||' '||
				  rpad(nvl(cur_riga.riv_voce,' '),10)||' '||
				  rpad(nvl(cur_riga.riv_sub,' '),10)||' '||
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
END p_eson;
/

