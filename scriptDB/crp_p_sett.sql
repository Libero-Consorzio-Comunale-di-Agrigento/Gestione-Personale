CREATE OR REPLACE PACKAGE p_sett IS

/******************************************************************************
 NOME:          CRP_P_SETT
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

CREATE OR REPLACE PACKAGE BODY p_sett IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE SETTORI',(132-length('VERIFICA INTEGRITA` REFERENZIALE SETTORI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE SETTORI')))
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
	           	, 'Numero Gestione Sede   Sett.A Sett.B Sett.C Sett.G Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------ -------- ------ ------ ------ ------ ------ ----------'
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
	for cur_riga in (select numero,gestione, to_number(null) sede, to_number(null) settore_a,
       to_number(null) settore_b, to_number(null) settore_c,
       to_number(null) settore_g,
       'GESTIONI' tabella
from settori sett
where not exists
  (select 1 from gestioni gest
    where gest.codice = sett.gestione)
union
select numero, '    ' gestione, sede, to_number(null) settore_a,
       to_number(null) settore_b, to_number(null) settore_c,
       to_number(null) settore_g,
       'SEDI' tabella
from settori sett
where nvl(sede,0) != 0
  and not exists
  (select 1 from sedi sede
    where sede.numero = sett.sede)
union
select numero, '    ' gestione,to_number(null) sede, settore_a,
       to_number(null) settore_b, to_number(null) settore_c,
       to_number(null) settore_g,
       'SETTORI' tabella
from settori sett
where settore_a is not null
  and not exists
  (select 1 from settori sett2
    where sett2.numero = sett.settore_a)
union
select numero,'    ' gestione,to_number(null) sede, to_number(null) settore_a,
       settore_b, to_number(null) settore_c, to_number(null) settore_g,
       'SETTORI' tabella
from settori sett
where settore_b is not null
  and not exists
  (select 1 from settori sett2
    where sett2.numero = sett.settore_b)
union
select numero,'    ' gestione,to_number(null) sede, to_number(null) settore_a,
       to_number(null) settore_b, settore_c, to_number(null) settore_g,
       'SETTORI' tabella
from settori sett
where settore_c is not null
  and not exists
  (select 1 from settori sett2
    where sett2.numero = sett.settore_c)
union
select numero,'    ' gestione,to_number(null) sede, to_number(null) settore_a,
       to_number(null) settore_b, to_number(null) settore_c, settore_g,
       'SETTORI' tabella
from settori sett
where settore_g is not null
  and not exists
  (select 1 from settori sett2
    where sett2.numero = sett.settore_g)
order by 8,2,3,4,5,6,7,1

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
		       	, rpad(nvl(to_char(cur_riga.numero),' '),6)||' '||
				  rpad(nvl(cur_riga.gestione,' '),8)||' '||
				  rpad(nvl(to_char(cur_riga.sede),' '),6)||' '||
  				  rpad(nvl(to_char(cur_riga.settore_a),' '),6)||' '||
				  rpad(nvl(to_char(cur_riga.settore_b),' '),6)||' '||
				  rpad(nvl(to_char(cur_riga.settore_c),' '),6)||' '||
				  rpad(nvl(to_char(cur_riga.settore_g),' '),6)||' '||
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
END p_sett;
/

