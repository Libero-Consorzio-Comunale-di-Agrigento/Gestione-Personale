CREATE OR REPLACE PACKAGE p_rava IS

/******************************************************************************
 NOME:          crp_p_rava
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

CREATE OR REPLACE PACKAGE BODY p_rava IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RACCOLTA_VARIABILI',(132-length('VERIFICA INTEGRITA` REFERENZIALE RACCOLTA_VARIABILI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RACCOLTA_VARIABILI')))
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
	           	, 'Modulo Codice Competenza              Cod.Ind. Riferimento Voce       Sub  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------ ------------------------------ -------- ----------- ---------- ---- ---------------------'
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
	for cur_riga in (select modulo, cc, ci, to_char(riferimento,'dd/mm/yyyy') riferimento,
       null voce, null sub,
       'RACCOLTA_MODULI' tabella
from raccolta_variabili rava
where not exists
  (select 1 from raccolta_moduli ramo
    where ramo.modulo = rava.modulo
      and ramo.cc     = rava.cc)
union
select modulo, cc, ci, to_char(riferimento,'dd/mm/yyyy') riferimento,
       null voce, null sub,
       'RAPPORTI_INDIVIDUALI' tabella
from raccolta_variabili rava
where not exists
  (select 1 from rapporti_individuali rain
    where rain.ci = rava.ci)
union
select modulo, cc, ci, to_char(riferimento,'dd/mm/yyyy') riferimento,
       voce, sub,
       'VOCI_CONTABILI' tabella
from raccolta_variabili rava
where voce||sub is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce = rava.voce
      and voco.sub  = rava.sub)
union
select modulo, cc, ci, to_char(riferimento,'dd/mm/yyyy') riferimento,
       voce, sub,
       'VOCI_ECONOMICHE' tabella
from raccolta_variabili rava
where voce is not null
  and not exists
  (select 1 from voci_economiche voec
    where voec.codice = rava.voce)
union
select modulo, cc, ci, to_char(riferimento,'dd/mm/yyyy') riferimento,
       voce, sub,
       'CONTABILITA_VOCE' tabella
from raccolta_variabili rava
where voce||sub is not null
  and not exists
  (select 1 from contabilita_voce covo
    where covo.voce = rava.voce
      and covo.sub  = rava.sub)
order by 7,5,6,1,2,3,4

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
		       	, rpad(nvl(cur_riga.modulo,' '),6)||' '||
				  rpad(nvl(cur_riga.cc,' '),30)||' '||
				  rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.riferimento,' '),11)||' '||
  				  rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub,' '),4)||' '||
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
END p_rava;
/

