CREATE OR REPLACE PACKAGE p_tavo IS

/******************************************************************************
 NOME:          CRP_P_TAVO
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

CREATE OR REPLACE PACKAGE BODY p_tavo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE TARIFFE_VOCE',(132-length('VERIFICA INTEGRITA` REFERENZIALE TARIFFE_VOCE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE TARIFFE_VOCE')))
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
	           	, 'Voce       Dal        Voce Qta   Sub Qta    Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---------- ---------- ---------- ---------------------'
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
	for cur_riga in (select voce, to_char(dal,'dd/mm/yyyy') dal, null cod_voce_qta,
       null sub_voce_qta,
       'VOCI_ECONOMICHE' tabella
from tariffe_voce tavo
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = tavo.voce)
union
select voce, to_char(dal,'dd/mm/yyyy') dal, cod_voce_qta,
       null sub_voce_qta,
       'VOCI_ECONOMICHE' tabella
from tariffe_voce tavo
where cod_voce_qta is not null
  and not exists
  (select 1 from voci_economiche voec
    where voec.codice = tavo.cod_voce_qta)
union
select voce, to_char(dal,'dd/mm/yyyy') dal, cod_voce_qta,
       sub_voce_qta,
       'VOCI_CONTABILI' tabella
from tariffe_voce tavo
where cod_voce_qta||sub_voce_qta is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce = tavo.cod_voce_qta
      and voco.sub  = tavo.sub_voce_qta)
order by 3,1,2


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
		       	, rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.cod_voce_qta,' '),10)||' '||
				  rpad(nvl(cur_riga.sub_voce_qta,' '),10)||' '||
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
END p_tavo;
/

