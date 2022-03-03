CREATE OR REPLACE PACKAGE p_esrc IS

/******************************************************************************
 NOME:          crp_p_esrc
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

CREATE OR REPLACE PACKAGE BODY p_esrc IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONE_RIGHE_CONTABILI',(132-length('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONE_RIGHE_CONTABILI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONE_RIGHE_CONTABILI')))
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
	           	, 'Estrazione           Colonna                        Dal        Voce       Sub        Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------------------- ------------------------------ ---------- ---------- ---------- ------------------------------'
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
	for cur_riga in (select estrazione, colonna, to_char(dal,'dd/mm/yyyy') dal, null voce, null sub,
       'ESTRAZIONE_VALORI_CONTABILI' tabella
from estrazione_righe_contabili esrc
where not exists
  (select 1 from estrazione_valori_contabili esvc
    where esvc.estrazione = esrc.estrazione
      and esvc.colonna    = esrc.colonna
      and esvc.dal        = esrc.dal
      and nvl(esvc.al,to_date('3333333','j')) =
          nvl(esrc.al,to_date('3333333','j')))
union
select estrazione, colonna, to_char(dal,'dd/mm/yyyy') dal, voce, sub,
       'VOCI_CONTABILI' tabella
from estrazione_righe_contabili esrc
where voce||sub is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce = esrc.voce
      and voco.sub  = esrc.sub)
order by 6,4,5,1,2,3

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
		       	, rpad(nvl(cur_riga.estrazione,' '),20)||' '||
				  rpad(nvl(cur_riga.colonna,' '),30)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub,' '),10)||' '||
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
END p_esrc;
/

