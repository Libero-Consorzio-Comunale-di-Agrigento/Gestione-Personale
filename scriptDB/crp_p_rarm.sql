CREATE OR REPLACE PACKAGE p_rarm IS

/******************************************************************************
 NOME:          crp_p_rarm
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

CREATE OR REPLACE PACKAGE BODY p_rarm IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RACCOLTA_RIGHE_MODULO',(132-length('VERIFICA INTEGRITA` REFERENZIALE RACCOLTA_RIGHE_MODULO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RACCOLTA_RIGHE_MODULO')))
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
	           	, 'Modulo Codice Competenza              Sequenza Voce       Sub  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------ ------------------------------ -------- ---------- ---- ---------------------'
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
	for cur_riga in (select modulo, cc, to_char(sequenza) sequenza, null voce, null sub,
       'RACCOLTA_MODULI' tabella
from raccolta_righe_modulo rarm
where not exists
  (select 1 from raccolta_moduli ramo
    where ramo.modulo = rarm.modulo
      and ramo.cc     = rarm.cc)
union
select modulo, cc, to_char(sequenza) sequenza, voce, sub,
       'VOCI_CONTABILI' tabella
from raccolta_righe_modulo rarm
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = rarm.voce
      and voco.sub  = rarm.sub)
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
		       	, rpad(nvl(cur_riga.modulo,' '),6)||' '||
				  rpad(nvl(cur_riga.cc,' '),30)||' '||
				  rpad(nvl(cur_riga.sequenza,' '),8)||' '||
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
END p_rarm;
/

