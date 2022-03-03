CREATE OR REPLACE PACKAGE p_popi IS

/******************************************************************************
 NOME:          crp_p_popi
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

CREATE OR REPLACE PACKAGE BODY p_popi IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number ;
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE POSTI_PIANTA',(132-length('VERIFICA INTEGRITA` REFERENZIALE POSTI_PIANTA'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE POSTI_PIANTA')))
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
	           	, 'Sede Anno Numero  Posto Dal        Attivita Sede Prov Anno Prov Num.Prov  Figura Gruppo       Settore Pianta Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---- ---- ------- ----- ---------- -------- --------- --------- --------- ------ ------------ ------- ------ --------------------'
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
	for cur_riga in (	select sede_posto, anno_posto, numero_posto, posto,
							   to_char(dal,'dd/mm/yyyy')dal, null attivita, null sede_prov,
							   null anno_prov, null numero_prov, null figura, null gruppo,
							   null settore, null pianta,'POSTI_ORGANICO' tabella
						  from posti_pianta popi
					 	 where not exists
						 	     (select 1 from posti_organico poor
								   where poor.sede = popi.sede_posto
								     and poor.anno = popi.anno_posto
									 and poor.numero = popi.numero_posto
									 and poor.posto = popi.posto)
						union
select sede_posto, anno_posto, numero_posto, posto,
       to_char(dal,'dd/mm/yyyy')dal, attivita, null sede_prov,
       null anno_prov, null numero_prov, null figura, null gruppo,
       null settore, null pianta,
       'ATTIVITA' tabella
from posti_pianta popi
where attivita is not null
  and not exists
 (select 1 from attivita atti
    where atti.codice = popi.attivita)
			 union
select sede_posto, anno_posto, numero_posto, posto,
       to_char(dal,'dd/mm/yyyy')dal, null attivita, sede_prov,
       to_char(anno_prov) anno_prov, to_char(numero_prov) numero_prov,
       null gruppo, null figura, null settore, null pianta,
       'DELIBERE' tabella
from posti_pianta popi
 where sede_prov||to_char(anno_prov)||to_char(numero_prov) is not null
  and not exists
  (select 1 from delibere deli
    where deli.sede = popi.sede_prov
      and deli.anno = popi.anno_prov
      and deli.numero = popi.numero_prov )
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
	union
select sede_posto, anno_posto, numero_posto, posto,
       to_char(dal,'dd/mm/yyyy')dal, null attivita, null sede_prov,
       null anno_prov, null numero_prov, to_char(figura), null gruppo,
       null settore, null pianta,
       'FIGURA' tabella
from posti_pianta popi
where not exists
  (select 1 from figure figu
    where figu.numero = popi.figura)
union
select sede_posto, anno_posto, numero_posto, posto,
       to_char(dal,'dd/mm/yyyy')dal, null attivita, null sede_prov,
       null anno_prov, null numero_prov, null figura, gruppo,
       null settore, null pianta,
       'GRUPPI_DISPONIBILITA' tabella
from posti_pianta popi
where gruppo is not null
  and not exists
  (select 1 from gruppi_disponibilita grdi
    where grdi.gruppo = popi.gruppo)
	union
select sede_posto, anno_posto, numero_posto, posto,
       to_char(dal,'dd/mm/yyyy')dal, null attivita, null sede_prov,
       null anno_prov, null numero_prov, null figura, null gruppo,
       to_char(settore), null pianta,
       'SETTORI' tabella
from posti_pianta popi
where not exists
  (select 1 from settori sett
    where sett.numero = popi.settore)
union
select sede_posto, anno_posto, numero_posto, posto,
       to_char(dal,'dd/mm/yyyy')dal, null attivita, null sede_prov,
       null anno_prov, null numero_prov, null figura, null gruppo,
       null settore, to_char(pianta),
       'SETTORI' tabella
from posti_pianta popi
where not exists
  (select 1 from settori sett
    where sett.numero = popi.pianta)
						  order by 14,6,7,8,9,10,11,12,13,1,2,3,4,5
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
		           	, rpad(nvl(cur_riga.sede_posto,' '),4)||' '||rpad(nvl(to_char(cur_riga.anno_posto),' '),4)||' '||rpad(nvl(to_char(cur_riga.numero_posto),' '),7)||' '
					||rpad(nvl(to_char(cur_riga.posto),' '),5)||' '||rpad(nvl(cur_riga.dal,' '),10)||' '||rpad(nvl(cur_riga.attivita,' '),8)||' '
		            ||rpad(nvl(cur_riga.sede_prov,' '),9)||' '||rpad(nvl(cur_riga.anno_prov,' '),9)||' '||rpad(nvl(cur_riga.numero_prov,' '),9)||' '
					||rpad(nvl(cur_riga.figura,' '),6)||' '||rpad(nvl(cur_riga.gruppo,' '),12)||' '||rpad(nvl(cur_riga.settore,' '),7)||' '
					||rpad(nvl(cur_riga.pianta,' '),6)||' '||nvl(cur_riga.tabella,' ')
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
END p_popi;
/

