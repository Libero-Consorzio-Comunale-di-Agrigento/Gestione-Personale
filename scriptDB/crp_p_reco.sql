CREATE OR REPLACE PACKAGE p_reco IS

/******************************************************************************
 NOME:          crp_p_reco
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

CREATE OR REPLACE PACKAGE BODY p_reco IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RELAZIONE_COND_OGGETTO',(132-length('VERIFICA INTEGRITA` REFERENZIALE RELAZIONE_COND_OGGETTO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RELAZIONE_COND_OGGETTO')))
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
	           	, 'Oggetto    Riferimento Sequenza   Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ----------- ---------- -------------------------------'
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
	for cur_riga in (select oggetto, null riferimento,
       to_char(sequenza) sequenza,
       'RELAZIONE_OGGETTI' tabella
from relazione_cond_oggetto reco
where not exists
  (select 1 from relazione_oggetti reog
    where reog.oggetto = reco.oggetto)
union
select oggetto, riferimento,
       to_char(sequenza) sequenza,
       'RELAZIONE_OGGETTI' tabella
from relazione_cond_oggetto reco
where not exists
  (select 1 from relazione_oggetti reog
    where reog.oggetto = reco.riferimento)
union
select oggetto, riferimento,
       to_char(sequenza) sequenza,
       'RELAZIONE_RIFE_OGGETTO' tabella
from relazione_cond_oggetto reco
where not exists
  (select 1 from relazione_rife_oggetto rero
    where rero.oggetto = reco.oggetto
      and rero.riferimento = reco.riferimento)
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
		       	, rpad(nvl(cur_riga.oggetto,' '),10)||' '||
				  rpad(nvl(cur_riga.riferimento,' '),11)||' '||
  				  rpad(nvl(cur_riga.sequenza,' '),10)||' '||
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
END p_reco;
/

