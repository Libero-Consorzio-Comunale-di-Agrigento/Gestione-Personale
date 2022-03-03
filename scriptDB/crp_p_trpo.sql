CREATE OR REPLACE PACKAGE p_trpo IS

/******************************************************************************
 NOME:          CRP_P_TRPO
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

CREATE OR REPLACE PACKAGE BODY p_trpo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE TRASFORMAZIONE_POSTI',(132-length('VERIFICA INTEGRITA` REFERENZIALE TRASFORMAZIONE_POSTI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE TRASFORMAZIONE_POSTI')))
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
	           	, 'Da Sede Da Anno Da Numero Da Posto In Sede In Anno In Numero In Posto Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------- ------- --------- -------- ------- ------- --------- -------- --------------------'
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
	for cur_riga in (select da_sede, to_char(da_anno) da_anno, to_char(da_numero) da_numero,
      			 	 to_char(da_posto) da_posto, null in_sede, null in_anno,
					 				         null in_numero, null in_posto,
       'POSTI_ORGANICO' tabella
from trasformazione_posti trpo
where not exists
  (select 1 from posti_organico poor
    where poor.sede   = trpo.da_sede
      and poor.anno   = trpo.da_anno
      and poor.numero = trpo.da_numero
      and poor.posto  = trpo.da_posto)
union
select null da_sede, null da_anno, null da_numero,
       null da_posto, in_sede, to_char(in_anno) in_anno,
       to_char(in_numero) in_numero, to_char(in_posto) in_posto,
       'POSTI_ORGANICO' tabella
from trasformazione_posti trpo
where not exists
  (select 1 from posti_organico poor
    where poor.sede   = trpo.in_sede
      and poor.anno   = trpo.in_anno
      and poor.numero = trpo.in_numero
      and poor.posto  = trpo.in_posto)
order by 9,1,2,3,4,5,6,7,8
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
		       	, rpad(nvl(cur_riga.da_sede,' '),7)||' '||rpad(nvl(cur_riga.da_anno,' '),7)||' '||rpad(nvl(cur_riga.da_numero,' '),9)||' '
				||rpad(nvl(cur_riga.da_posto,' '),8)||' '||rpad(nvl(cur_riga.in_sede,' '),7)||' '||rpad(nvl(cur_riga.in_anno,' '),7)||' '
				||rpad(nvl(cur_riga.in_numero,' '),9)||' '||rpad(nvl(cur_riga.in_posto,' '),8)||' '||cur_riga.tabella
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
END p_trpo;
/

