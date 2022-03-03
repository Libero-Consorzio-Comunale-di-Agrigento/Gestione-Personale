CREATE OR REPLACE PACKAGE p_inec IS

/******************************************************************************
 NOME:          crp_p_inec
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

CREATE OR REPLACE PACKAGE BODY p_inec IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE INQUADRAMENTI_ECONOMICI',(132-length('VERIFICA INTEGRITA` REFERENZIALE INQUADRAMENTI_ECONOMICI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE INQUADRAMENTI_ECONOMICI')))
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
	           	, 'Cod.Ind. Dal        Qualifica  Voce       Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ---------- ---------- ----------------------'
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
	for cur_riga in (select ci, to_char(dal,'dd/mm/yyyy') dal, '      ' qualifica,
       '          ' voce,
       'RAPPORTI_RETRIBUTIVI' tabella
from inquadramenti_economici inec
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = inec.ci )
union
select ci, to_char(dal,'dd/mm/yyyy') dal, to_char(qualifica),
       '          ' voce,
       'QUALIFICHE' tabella
from inquadramenti_economici inec
where not exists
  (select 1 from qualifiche qual
    where qual.numero = inec.qualifica)
union
select ci, to_char(dal,'dd/mm/yyyy') dal, to_char(qualifica),
       '          ' voce,
       'QUALIFICHE_GIURIDICHE' tabella
from inquadramenti_economici inec
where not exists
  (select 1 from qualifiche_giuridiche qugi
    where qugi.numero = inec.qualifica
      and inec.dal
          between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
  )
   or not exists
  (select 1 from qualifiche_giuridiche qugi
    where qugi.numero = inec.qualifica
      and nvl(inec.al,to_date('3333333','j'))
          between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
  )
union
select ci, to_char(dal,'dd/mm/yyyy') dal, '      ' qualifica,
       voce,
       'VOCI_ECONOMICHE' tabella
from inquadramenti_economici inec
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = inec.voce)
union
select ci, to_char(dal,'dd/mm/yyyy') dal, '      ' qualifica,
       voce,
       'CONTABILITA_VOCE' tabella
from inquadramenti_economici inec
where not exists
  (select 1 from contabilita_voce covo
    where covo.voce = inec.voce)
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
		       	, rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),10)||' '||
				  rpad(nvl(cur_riga.voce,' '),10)||' '||
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
END p_inec;
/

