CREATE OR REPLACE PACKAGE p_mofi IS

/******************************************************************************
 NOME:          crp_p_mofi
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

CREATE OR REPLACE PACKAGE BODY p_mofi IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_FISCALI',(132-length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_FISCALI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_FISCALI')))
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
	           	, 'Cod.Ind. Anno Me Mensilita Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---- -- --------- -------------------------------'
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
	for cur_riga in (select ci, anno, mese, mensilita,
       'RAPPORTI_RETRIBUTIVI' tabella
from movimenti_fiscali mofi
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = mofi.ci
       or rare.ci_erede = mofi.ci )
union
select ci, anno, mese, mensilita,
       'MESI' tabella
from movimenti_fiscali mofi
where not exists
  (select 1 from mesi mese
    where mese.anno = mofi.anno
      and mese.mese = mofi.mese)
union
select ci, anno, mese, mensilita,
       'MENSILITA' tabella
from movimenti_fiscali mofi
where not exists
  (select 1 from mensilita mens
    where mens.mese = mofi.mese
      and mens.mensilita = mofi.mensilita)
union
select ci, anno, mese, mensilita,
       'INFORMAZIONI_EXTRACONTABILI' tabella
from movimenti_fiscali mofi
where not exists
  (select 1 from informazioni_extracontabili inex
    where inex.anno = mofi.anno
      and inex.ci   = mofi.ci)
  and mensilita != '*AP'
order by 5,2,3,4,1

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
				  rpad(nvl(to_char(cur_riga.anno),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.mese),' '),2)||' '||
				  rpad(nvl(cur_riga.mensilita,' '),9)||' '||
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
END p_mofi;
/

