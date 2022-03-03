CREATE OR REPLACE PACKAGE p_rqmi IS

/******************************************************************************
 NOME:          crp_p_rqumi
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

CREATE OR REPLACE PACKAGE BODY p_rqmi IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RIGHE_QUALIFICA_MINISTERIALE',(132-length('VERIFICA INTEGRITA` REFERENZIALE RIGHE_QUALIFICA_MINISTERIALE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RIGHE_QUALIFICA_MINISTERIALE')))
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
	           	, 'Codice Sequenza Figura Qualifica Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------ -------- ------ --------- -------------------------------'
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
	for cur_riga in (select codice, to_char(sequenza) sequenza, null figura, null qualifica,
       'QUALIFICHE_MINISTERIALI' tabella
from righe_qualifica_ministeriale rqmi
where not exists
  (select 1 from qualifiche_ministeriali qumi
    where qumi.codice = rqmi.codice)
union
select codice, to_char(sequenza) sequenza, to_char(figura), null qualifica,
       'FIGURE' tabella
from righe_qualifica_ministeriale rqmi
where figura is not null
  and not exists
  (select 1 from figure figu
    where figu.numero = rqmi.figura)
union
select codice, to_char(sequenza) sequenza, null figura, to_char(qualifica),
       'QUALIFICHE' tabella
from righe_qualifica_ministeriale rqmi
where qualifica is not null
  and not exists
  (select 1 from qualifiche qual
    where qual.numero = rqmi.qualifica)
order by 5,3,4,1,2

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
		       	, rpad(nvl(cur_riga.codice,' '),6)||' '||
				  rpad(nvl(cur_riga.sequenza,' '),8)||' '||
				  rpad(nvl(cur_riga.figura,' '),6)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),9)||' '||
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
END p_rqmi;
/

