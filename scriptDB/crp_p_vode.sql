CREATE OR REPLACE PACKAGE p_vode IS

/******************************************************************************
 NOME:          CRP_P_VODE
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

CREATE OR REPLACE PACKAGE BODY p_vode IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE VOCI_DELIBERATE',(132-length('VERIFICA INTEGRITA` REFERENZIALE VOCI_DELIBERATE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE VOCI_DELIBERATE')))
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
	           	, 'Delibera   Sequenza  Voce       Sub  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- --------- ---------- ---- ---------------------'
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
	for cur_riga in (select delibera, to_char(sequenza) sequenza, null voce, null sub,
       'CLASSI_DELIBERA' tabella
from voci_deliberate vode
where not exists
  (select 1 from classi_delibera clde
    where clde.codice = vode.delibera)
union
select delibera, to_char(sequenza) sequenza, voce, null sub,
       'VOCI_ECONOMICHE' tabella
from voci_deliberate vode
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = vode.voce)
union
select delibera, to_char(sequenza) sequenza, voce, sub,
       'VOCI_CONTABILI' tabella
from voci_deliberate vode
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = vode.voce
      and voco.sub  = vode.sub)
union
select delibera, to_char(sequenza) sequenza, voce, sub,
       'CONTABILITA_VOCE' tabella
from voci_deliberate vode
where not exists
  (select 1 from contabilita_voce covo
    where covo.voce = vode.voce
      and covo.sub  = vode.sub)
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
		       	, rpad(nvl(cur_riga.delibera,' '),10)||' '||
				  rpad(nvl(cur_riga.sequenza,' '),9)||' '||
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
END p_vode;
/

