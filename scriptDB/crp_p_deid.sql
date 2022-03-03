CREATE OR REPLACE PACKAGE p_deid IS

/******************************************************************************
 NOME:          crp_p_deid
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

CREATE OR REPLACE PACKAGE BODY p_deid IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE DENUNCIA_INADEL',(132-length('VERIFICA INTEGRITA` REFERENZIALE DENUNCIA_INADEL'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE DENUNCIA_INADEL')))
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
	           	, 'Anno Cod.Ind. Gestione Qualifica Cod.Asp.1 Cod.Asp.2 Cod.Asp.3 Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---- -------- -------- --------- --------- --------- --------- --------------------'
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
	for cur_riga in (select anno, ci, null gestione, null qualifica, null cod_asp1,
       null cod_asp2, null cod_asp3,
       'RAPPORTI_RETRIBUTIVI' tabella
from denuncia_inadel dein
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = dein.ci)
union
select anno, ci, gestione, null qualifica, null cod_asp1,
       null cod_asp2, null cod_asp3,
       'GESTIONI' tabella
from denuncia_inadel dein
where not exists
  (select 1 from gestioni gest
    where gest.codice = dein.gestione)
union
select anno, ci, null gestione, to_char(qualifica), null cod_asp1,
       null cod_asp2, null cod_asp3,
       'QUALIFICHE' tabella
from denuncia_inadel dein
where qualifica is not null
  and not exists
  (select 1 from qualifiche qual
    where qual.numero = dein.qualifica)
union
select anno, ci, null gestione, null qualifica, cod_asp1,
       null cod_asp2, null cod_asp3,
       'ASTENSIONI' tabella
from denuncia_inadel dein
where cod_asp1 is not null
  and not exists
  (select 1 from astensioni aste
    where aste.codice = dein.cod_asp1)
union
select anno, ci, null gestione, null qualifica, null cod_asp1,
       cod_asp2, null cod_asp3,
       'ASTENSIONI' tabella
from denuncia_inadel dein
where cod_asp2 is not null
  and not exists
  (select 1 from astensioni aste
    where aste.codice = dein.cod_asp2)
union
select anno, ci, null gestione, null qualifica, null cod_asp1,
       null cod_asp2, cod_asp3,
       'ASTENSIONI' tabella
from denuncia_inadel dein
where cod_asp3 is not null
  and not exists
  (select 1 from astensioni aste
    where aste.codice = dein.cod_asp3)
order by 8,3,4,5,6,7,1,2

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
		       	, rpad(nvl(to_char(cur_riga.anno),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.gestione,' '),8)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),9)||' '||
				  rpad(nvl(cur_riga.cod_asp1,' '),8)||' '||
				  rpad(nvl(cur_riga.cod_asp2,' '),8)||' '||
				  rpad(nvl(cur_riga.cod_asp3,' '),8)||' '||
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
END p_deid;
/

