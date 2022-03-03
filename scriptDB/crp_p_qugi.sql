CREATE OR REPLACE PACKAGE p_qugi IS

/******************************************************************************
 NOME:          crp_p_qugi
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

CREATE OR REPLACE PACKAGE BODY p_qugi IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE QUALIFICHE_GIURIDICHE',(132-length('VERIFICA INTEGRITA` REFERENZIALE QUALIFICHE_GIURIDICHE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE QUALIFICHE_GIURIDICHE')))
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
	           	, 'Qualifica  Numero Data       Contratto  Ruolo      Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ------ ---------- ---------- ---------- --------------------'
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
	for cur_riga in (select codice,numero,to_char(dal,'dd/mm/yyyy') dal, contratto,
       '    ' ruolo, 'CONTRATTI' tabella
from qualifiche_giuridiche qugi
where not exists
  (select 1 from contratti cont
    where cont.codice = qugi.contratto)
union
select codice,numero,to_char(dal,'dd/mm/yyyy') dal, contratto,
       '    ' ruolo, 'CONTRATTI_STORICI' tabella
from qualifiche_giuridiche qugi
where not exists
  (select 1 from contratti_storici cost
    where cost.contratto = qugi.contratto
      and qugi.dal
          between cost.dal and nvl(cost.al,to_date('3333333','j'))
  )
   or not exists
  (select 1 from contratti_storici cost
    where cost.contratto = qugi.contratto
      and nvl(qugi.al,to_date('3333333','j'))
          between cost.dal and nvl(cost.al,to_date('3333333','j'))
  )
union
select codice,numero,to_char(dal,'dd/mm/yyyy') dal, '    ' contratto,
       '    ' ruolo, 'QUALIFICHE' tabella
from qualifiche_giuridiche qugi
where not exists
  (select 1 from qualifiche qual
    where qual.numero = qugi.numero)
union
select codice,numero,to_char(dal,'dd/mm/yyyy') dal, '    ' contratto,
       ruolo, 'RUOLI' tabella
from qualifiche_giuridiche qugi
where not exists
  (select 1 from ruoli ruol
    where ruol.codice = qugi.ruolo)
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
		       	, rpad(nvl(cur_riga.codice,' '),10)||' '||
				  rpad(nvl(to_char(cur_riga.numero),' '),6)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.contratto,' '),10)||' '||
				  rpad(nvl(cur_riga.ruolo,' '),10)||' '||
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
END p_qugi;
/

