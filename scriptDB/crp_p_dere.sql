CREATE OR REPLACE PACKAGE p_dere IS

/******************************************************************************
 NOME:          crp_p_dere
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

CREATE OR REPLACE PACKAGE BODY p_dere IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE DELIBERE_RETRIBUTIVE',(132-length('VERIFICA INTEGRITA` REFERENZIALE DELIBERE_RETRIBUTIVE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE DELIBERE_RETRIBUTIVE')))
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
	           	, 'Sede       Anno Numero  Tipo Mese Mensilita Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---- ------ ---- ---- --------- --------------------'
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
	for cur_riga in (select sede, anno, numero, null tipo, null mese, null mensilita,
       'DELIBERE' tabella
from delibere_retributive dere
where not exists
  (select 1 from delibere deli
    where deli.sede = dere.sede
      and deli.anno = dere.anno
      and deli.numero = dere.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede, anno, numero, tipo, null mese, null mensilita,
       'CLASSI_DELIBERA' tabella
from delibere_retributive dere
where not exists
  (select 1 from classi_delibera clde
    where clde.codice = dere.tipo)
union
select sede, anno, numero, null tipo, to_char(mese), mensilita,
       'MENSILITA' tabella
from delibere_retributive dere
where to_char(mese)||mensilita is not null
  and not exists
  (select 1 from mensilita mens
    where mens.mese = dere.mese
      and mens.mensilita = dere.mensilita)
order by 7,4,5,6,1,2,3

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
		       	, rpad(nvl(cur_riga.sede,' '),10)||' '||
				  rpad(nvl(to_char(cur_riga.anno),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.numero),' '),7)||' '||
  				  rpad(nvl(cur_riga.tipo,' '),4)||' '||
				  rpad(nvl(cur_riga.mese,' '),4)||' '||
				  rpad(nvl(cur_riga.mensilita,' '),9)||' '||
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
END p_dere;
/

