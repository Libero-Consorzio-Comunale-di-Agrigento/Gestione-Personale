CREATE OR REPLACE PACKAGE p_bavo IS

/******************************************************************************
 NOME:          crp_p_bavo
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

CREATE OR REPLACE PACKAGE BODY p_bavo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE BASI_VOCE',(132-length('VERIFICA INTEGRITA` REFERENZIALE BASI_VOCE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE BASI_VOCE')))
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
	           	, 'Voce       Contratto Voce Base  Voce Ecc.  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- --------- ---------- ---------- -------------------------'
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
	for cur_riga in (select voce, '    ' contratto, '          ' voce_base,
       '          ' voce_ecce, 'VOCI_ECONOMICHE' tabella
  from basi_voce bavo
where  not exists
      (select 1 from voci_economiche voec
       where voec.codice = bavo.voce )
union
select voce, contratto, '          ' voce_base,
       '          ' voce_ecce, 'CONTRATTI' tabella
  from basi_voce bavo
where  not exists
      (select 1 from contratti cont
       where cont.codice = bavo.contratto)
union
select voce, '    ' contratto, voce_base,
       '          ' voce_ecce, 'VOCI_ECONOMICHE' tabella
  from basi_voce bavo
where  voce_base is not null
  and  not exists
      (select 1 from voci_economiche voec
       where voec.codice = bavo.voce_base )
union
select voce, '    ' contratto, '          ' voce_base,
       voce_ecce, 'VOCI_ECONOMICHE' tabella
  from basi_voce bavo
where  voce_ecce is not null
  and  not exists
      (select 1 from voci_economiche voec
       where voec.codice = bavo.voce_ecce )
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
		       	, rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.contratto,' '),9)||' '||
				  rpad(nvl(cur_riga.voce_base,' '),10)||' '||
				  rpad(nvl(cur_riga.voce_ecce,' '),10)||' '||
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
END p_bavo;
/

