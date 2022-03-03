CREATE OR REPLACE PACKAGE p_esvo IS

/******************************************************************************
 NOME:          crp_p_esvo
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

CREATE OR REPLACE PACKAGE BODY p_esvo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONI_VOCE',(132-length('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONI_VOCE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ESTRAZIONI_VOCE')))
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
	           	, 'Voce       Sub  Gestione Contratto Trattamento Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---- -------- --------- ----------- -------------------------'
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
	for cur_riga in (select voce, '  ' sub, '    ' contratto, '    ' gestione, '    ' trattamento
       ,'VOCI_ECONOMICHE' tabella
from estrazioni_voce esvo
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = esvo.voce)
union
select voce, sub, '    ' contratto, '    ' gestione, '    ' trattamento
       ,'VOCI_CONTABILI' tabella
from estrazioni_voce esvo
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = esvo.voce
      and voco.sub  = esvo.sub)
union
select voce, sub, '    ' contratto, gestione, '    ' trattamento
       ,'GESTIONI' tabella
from estrazioni_voce esvo
where not exists
  (select 1 from gestioni gest
    where gest.codice like esvo.gestione)
union
select voce, sub, contratto, '    ' gestione, '    ' trattamento
       ,'CONTRATTI' tabella
from estrazioni_voce esvo
where not exists
  (select 1 from contratti cont
    where cont.codice like esvo.contratto)
union
select voce, sub, '    ' contratto, '    ' gestione, trattamento
       ,'TRATTAMENTI_PREVIDENZIALI' tabella
from estrazioni_voce esvo
where not exists
  (select 1 from trattamenti_previdenziali trpr
    where trpr.codice like esvo.trattamento)
order by 6,3,4,5,1,2

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
				  rpad(nvl(cur_riga.sub,' '),4)||' '||
				  rpad(nvl(cur_riga.gestione,' '),8)||' '||
				  rpad(nvl(cur_riga.contratto,' '),9)||' '||
				  rpad(nvl(cur_riga.trattamento,' '),11)||' '||
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
END p_esvo;
/

